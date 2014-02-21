/*
 * acquire.c
 *
 *  Created on: 18 Feb 2014
 *      Author: Chinemelu Ezeh
 *      This contains functions to configure the ADC to ...
 */
#include <stdint.h>
#include <stdbool.h>
#include "inc/hw_memmap.h"
#include "driverlib/fpu.h"
#include "driverlib/sysctl.h"
#include "driverlib/rom.h"
#include "driverlib/pin_map.h"
#include "driverlib/uart.h"
#include "grlib/grlib.h"
#include "drivers/cfal96x64x16.h"
#include "utils/uartstdio.h"
#include "driverlib/gpio.h"
#include "driverlib/systick.h"
#include "driverlib/interrupt.h"
#include "utils/ustdlib.h"
#include "driverlib/timer.h"
#include "inc/hw_timer.h"
#include "inc/hw_nvic.h"
#include "inc/hw_types.h"
#include "inc/hw_ints.h"
#include "inc/hw_gpio.h"
#include "driverlib/debug.h"
#include "driverlib/adc.h"
#include "exercise2.h"
#include "uicontrol.h"
#include "acquire.h"


#define MAX_SAMPLES 96
#define MAX_SAMPLE_SIZE 32
/****************************************************************
 * Buffer to store Acquisition Data
 ***************************************************************/
uint32_t p_uiADCBuffer[MAX_SAMPLES*MAX_SAMPLE_SIZE];

/****************************************************************
 * Pointer to ADC buffer.
 ***************************************************************/
volatile int p_uiADCBufferPtr = 0;
/****************************************************************
 * Sample Event Flag
 ***************************************************************/
//volatile bool sampleflag = 0;

volatile uint32_t buffersize;
volatile uint32_t sequence;
volatile uint32_t steplen;
/************************************************************
 * Stores the values of the data point to be plotted.
 * min = datapoint[0], max = datapoint[1], ave = datapoint[2]
 *************************************************************/
#define MAX_NUM 999999999
uint32_t datapoints[3] = {MAX_NUM,0,0};
/****************************************************************
 * Pointer to NEXT line of ADC buffer for processing.
 ***************************************************************/
volatile int p_processingPtr = 0;
/****************************************************************
 * Buffer to store the read ADC values.
 ****************************************************************/
volatile uint32_t pui32ADC0Value[8];
/****************************************************************
 * Stores the user's options.
 ****************************************************************/
volatile tuiConfig* puiConfig;
/************************************************************
 * Reads the ADC buffer to compute the min, max and ave data points.
 * The function always reads up to the written part of the buffer
 * so there is no chance for data hazard.
 *************************************************************/
void
computeSample(tuiConfig* p_uiConfig) {
	// Read the ADC buffer pointer in a critical section.
	// Loops until buffer has enough data.
	int size = 0;
	do {
		ROM_IntMasterDisable();
		int pointer = p_uiADCBufferPtr;
		ROM_IntMasterEnable();
		if (pointer == -1) { //end of sample.
			size =  buffersize;
		} else {
			size = pointer;
		}
		size -= p_processingPtr;
		// Don't poll too fast to prevent the ISR.
		SysCtlDelay(1000);
	} while(size < p_uiConfig->sample_size);

	// Reset data points;
	datapoints[0] = MAX_NUM;
	datapoints[1] = datapoints[2] = 0;
	// Compute Min, Max, Ave
	for (int i = p_processingPtr; i < p_uiConfig->sample_size; i++) {
		if (p_uiADCBuffer[i] < datapoints[0]) { // Compute Min
			datapoints[0] = p_uiADCBuffer[i];
		}
		if (p_uiADCBuffer[i] > datapoints[1]) { // Compute Max
			datapoints[1] = p_uiADCBuffer[i];
		}
		datapoints[2]+=p_uiADCBuffer[i];
	}
	datapoints[2] /= p_uiConfig->sample_size;
	p_processingPtr += p_uiConfig->sample_size;
	// Check for wrap around
	if (p_processingPtr == buffersize)
		p_processingPtr = 0;
}
/************************************************************
 * Gets the appropriate sequence for the ADC.
 * Sequence 0 has a FIFO depth of 8words. Sequence 1:4 words,
 * Sequence 2: 2 words and Sequence 3: 1 word.
 * The frequency of sampling determines the appropriate fifo length.
 * Since the ADC can only sample back-to-back at 1MHz,
 * the length of the fifo is only maximum at 1MHz. We are assuming
 * in this case that data can be grabbed within 50clocks.
 * In any other frequency, we use a fifo length of 1.
 *************************************************************/
uint32_t GetSequence(tuiConfig* p_uiConfig){
	switch (p_uiConfig->freq) {
	case 1000000: return 0;
	default: return 3;
	}
}

/***************************************************************
 * Reads the ADC buffer for a new sample. Computes Min, Max, Ave
 * and sets the sample event flag when sampling is completed.
 ***************************************************************/
void GetSampleISR() {
	// Reset pointer on new sample.
//	char str[5];
	ADCIntClear(ADC0_BASE, sequence);
//	ADCSequenceDataGet(ADC0_BASE, sequence,pui32ADC0Value);
//	usprintf(str, "%d", pui32ADC0Value[0]);
	UARTprintf("ISR\r");
//	UARTprintf(str);
//	UARTprintf("\r");
//	if (sequence == 0) {
//		usprintf(str, "%d", pui32ADC0Value[7]);
//		UARTprintf("WHAT: ");
//		UARTprintf(str);
//		UARTprintf("\r");
//	}
//	ADCProcessorTrigger(ADC0_BASE, sequence);
}
/***************************************************************
 * Gets the Actual Frequency Equivalent of value
 ***************************************************************/
uint32_t
GetPeriod(uint32_t freq){
	return SysCtlClockGet()/freq;
}
// ***************************************************************
//
// Sets up timer0 to count up periodically with a period of 23us.
// Its priority is 1. 0 is reserved for exception handling.
//
// ***************************************************************
void
ConfigTimer0(uint32_t period) {

	// Enable the timer peripherals.
	//
	ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_TIMER0);
	//
	// Configure the two 32-bit periodic timers.
	//
	ROM_TimerConfigure(TIMER0_BASE, TIMER_CFG_PERIODIC_UP);
	ROM_TimerLoadSet(TIMER0_BASE, TIMER_A, period);
	// Set the timer to trigger ADC conversion.
	TimerControlTrigger(TIMER0_BASE, TIMER_A, true);
	//
	// Enable the timer0.
	//
	ROM_TimerEnable(TIMER0_BASE, TIMER_A);
}
/***************************************************************
 * Sets up the appropriate ADC channel, its trigger and associated
 * interrupt handler. Also initialises the buffer size and sequence
 * variable for ADC logging.
 * After this call, the ADC periodic sampling starts running.
 ****************************************************************/
void
AcquireStart(tuiConfig* p_uiConfig) {
	//
	// Display the setup on the console.
	//
	UARTprintf("ADC ->\n");
	UARTprintf("  Type: Single Ended\n");
	UARTprintf("  Samples: One\n");
	UARTprintf("  Update Rate: 250ms\n");
	UARTprintf("  Input Pin: AIN0/PE7\n\n");

	//
	// The ADC0 peripheral must be enabled for use.
	//
	SysCtlPeripheralEnable(SYSCTL_PERIPH_ADC0);

	//
	//  GPIO port E needs to be enabled so the GPIO pins can be used.
	//
	SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOE);

	//
	// Select the analog ADC function for these pins.
	//
	if (p_uiConfig->channelOpt == ACCEL) {
		GPIOPinTypeADC(GPIO_PORTE_BASE, GPIO_PIN_6);
	} else if (p_uiConfig->channelOpt == VOLTS) {
		GPIOPinTypeADC(GPIO_PORTE_BASE, GPIO_PIN_3);
	}

	//
	// Select the external reference for greatest accuracy.
	//
	ADCReferenceSet(ADC0_BASE, ADC_REF_EXT_3V);

	//
	// Apply workaround for erratum 6.1, in order to use the
	// external reference.
	//
	SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOB);
	HWREG(GPIO_PORTB_BASE + GPIO_O_AMSEL) |= GPIO_PIN_6;
	//
	// Enable sample sequence 3 with a processor signal trigger.  Sequence 3
	// will do a single sample when the processor sends a signal to start the
	// conversion.  Each ADC module has 4 programmable sequences, sequence 0
	// to sequence 3.  This example is arbitrarily using sequence 3.
	//
	sequence = GetSequence(p_uiConfig);
	ADCSequenceConfigure(ADC0_BASE, sequence, ADC_TRIGGER_TIMER, 3);
	ADCIntRegister(ADC0_BASE, sequence, GetSampleISR);
	//
	// Configure step 0 on sequence 3.  Sample channel 0 (ADC_CTL_CH0) in
	// single-ended mode (default) and configure the interrupt flag
	// (ADC_CTL_IE) to be set when the sample is done.  Tell the ADC logic
	// that this is the last conversion on sequence 3 (ADC_CTL_END).  Sequence
	// 3 has only one programmable step.  Sequence 1 and 2 have 4 steps, and
	// sequence 0 has 8 programmable steps.  Since we are only doing a single
	// conversion using sequence 3 we will only configure step 0.  For more
	// information on the ADC sequences and steps, reference the datasheet.
	//
	uint32_t config = 0;
	if (p_uiConfig->channelOpt == ACCEL) {
		config = ADC_CTL_CH21;
	} else if (p_uiConfig->channelOpt == VOLTS) {
		config = ADC_CTL_CH0;
	}
	steplen = (sequence == 0)? 8:1;
	for (int step = 0; step < steplen; step++) {
		if (step == steplen-1)	{
			config |= (ADC_CTL_IE | ADC_CTL_END);
		}
		ADCSequenceStepConfigure(ADC0_BASE, sequence, step, config);
	}

	//
	// Since sample sequence 3 is now configured, it must be enabled.
	//
	ADCSequenceEnable(ADC0_BASE, sequence);

	//
	// Clear the interrupt status flag.  This is done to make sure the
	// interrupt flag is cleared before we sample.
	//
	ADCIntClear(ADC0_BASE, sequence);
	// Enable the interrupt after calibration.
	ADCIntEnable(ADC0_BASE, sequence);
	ConfigTimer0(GetPeriod(p_uiConfig->freq));
}

// Returns Accelerometer value in g*100 read raw from ADC buffer.
int ReadAccel(uint32_t value) {
	return (2442*(int)value - 5000000)/10000;
}
// Described with its implementation.
void AcquireInit(tuiConfig* p_uiConfig);

/***************************************************************
 * Main function to execute the acquire function. This starts the ADC
 * and plots the values on the graph. It is an infinite loop that
 * breaks on user input.
 ***************************************************************/
void
AcquireMain(tContext* pContext, tuiConfig* puiConfig_t) {
    //
    // This array is used for storing the data read from the ADC FIFO. It
    // must be as large as the FIFO for the sequencer in use.  This example
    // uses sequence 3 which has a FIFO depth of 1.  If another sequence
    // was used with a deeper FIFO, then the array size must be changed.
    //
	puiConfig = puiConfig_t;
	AcquireInit(puiConfig);
//	ADCProcessorTrigger(ADC0_BASE, sequence);
	// Sample AIN0 forever.  Display the value on the console.
	//
	while(1)
	{
//		//
//		// Trigger the ADC conversion.
//		//
//
//
//		//
//		// Wait for conversion to be completed.
//		//
//		while(!ADCIntStatus(ADC0_BASE, 3, false))
//		{
//		}
//
//		//
//		// Clear the ADC interrupt flag.
//		//
//		ADCIntClear(ADC0_BASE, 3);
//
//		//
//		// Read ADC Value. The ADC AIN0 value read is voltage * 100.
//		//
//		ADCSequenceDataGet(ADC0_BASE, 3, pui32ADC0Value);
//
//		//
//		// Display the AIN0 (PE7) digital value on the console.
//		//
//		UARTprintf("AIN0 = %d\r",pui32ADC0Value[0]);
//
//		//
//		// This function provides a means of generating a constant length
//		// delay.  The function delay (in cycles) = 3 * parameter.  Delay
//		// 250ms arbitrarily.
//		//
//		SysCtlDelay(SysCtlClockGet() / 100);
	}

}

/****************************************************************
 * Defines the threshold voltage for the volts trigger detection.
 ****************************************************************/
# define VTHRES 104

/****************************************************************
 * Used to indicate the first entry to TriggerDetectISR.
 ****************************************************************/
volatile bool first = true;

/****************************************************************
 * Stores the previous value of the accelerometer z-axis 100ms ago.
 ****************************************************************/
volatile int prev_value = 0;

/****************************************************************
 * This interrupt handler is set up by AcquireInit to check
 * for the events that begin a data logging. This is when the voltage
 * exceeds a changeable threshold or
 * the accelerometer z-axis changes g by more than 0.5.
 *****************************************************************/
void TriggerDetectISR() {
	ADCIntClear(ADC0_BASE, 3);
	ADCSequenceDataGet(ADC0_BASE, 3,pui32ADC0Value);
	if (puiConfig->channelOpt == ACCEL) {
		if (first) {
			first = false;
			prev_value = ReadAccel(pui32ADC0Value[0]);
		} else {
			int curr_value = ReadAccel(pui32ADC0Value[0]);
			if (abs(curr_value - prev_value) > 50) {
				UARTprintf("Accel!\r");
			}
			prev_value = curr_value;
		}
	} else if (puiConfig->channelOpt == VOLTS){
		if (pui32ADC0Value[0] > VTHRES) {
			UARTprintf("Volts!\r");
		}
	}
}
/*****************************************************************
 * Stops the trigger detection functionality.
 *****************************************************************/
void
StopDetection() {
	// Disable the interrupt after calibration.
	ADCIntDisable(ADC0_BASE, 3);
	// Disable the interrupt after calibration.
	ADCIntDisable(ADC0_BASE, 3);
	// Clear the any pending Interrupt
	ADCIntClear(ADC0_BASE, 3);
	// First remove the ISR.
	ADCIntUnregister(ADC0_BASE,3);
	// Disable the timer to stop triggering ADC conversions
	ROM_TimerDisable(TIMER0_BASE, TIMER_A);
}
/****************************************************************
 * This function should be called first in AcquireRun.
 * It starts the ADC interrupt to detect the beginning of data logging
 * which is when the voltage exceeds a changeable threshold or
 * the accelerometer z-axis changes g by more than 0.5. The trigger
 * to look out for depends on the user's selection. The interrupt is
 * called every 100ms.
 ****************************************************************/
void AcquireInit(tuiConfig* p_uiConfig) {
	//
	// The ADC0 peripheral must be enabled for use.
	//
	SysCtlPeripheralEnable(SYSCTL_PERIPH_ADC0);

	//
	// GPIO port E needs to be enabled
	// so the GPIO pins for data input can be used.
	//
	SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOE);

	//
	// Select the analog ADC function for these pins.
	// Accelerometer z-axis is on PE6 and AIN0 is on PE3
	//
	if (p_uiConfig->channelOpt == ACCEL) {
		GPIOPinTypeADC(GPIO_PORTE_BASE, GPIO_PIN_6);
	} else if (p_uiConfig->channelOpt == VOLTS) {
		GPIOPinTypeADC(GPIO_PORTE_BASE, GPIO_PIN_3);
	}

	//
	// Select the external reference for greatest accuracy.
	//
	ADCReferenceSet(ADC0_BASE, ADC_REF_EXT_3V);

	//
	// Apply workaround for erratum 6.1, in order to use the
	// external reference.
	//
	SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOB);
	HWREG(GPIO_PORTB_BASE + GPIO_O_AMSEL) |= GPIO_PIN_6;
	//
	// Enable sample sequence 3 with a timer trigger.  Sequence 3
	// will do a single sample when the processor sends a signal to start the
	// conversion.  Each ADC module has 4 programmable sequences, sequence 0
	// to sequence 3.
	//
	ADCSequenceConfigure(ADC0_BASE, 3, ADC_TRIGGER_TIMER, 3);
	// Register the interupt called after ADC conversion.
	ADCIntRegister(ADC0_BASE, 3, TriggerDetectISR);
	/*
	 * Select the ADC channel for the specific GPIO pin to be used.
	 */
	uint32_t config = 0;
	if (p_uiConfig->channelOpt == ACCEL) {
		config = ADC_CTL_CH21;
	} else if (p_uiConfig->channelOpt == VOLTS) {
		config = ADC_CTL_CH0;
	}
	//
	// Configure step 0 on sequence 3.  Sample channel 0 (ADC_CTL_CH0) in
	// single-ended mode (default) and configure the interrupt flag
	// (ADC_CTL_IE) to be set when the sample is done.  Tell the ADC logic
	// that this is the last conversion on sequence 3 (ADC_CTL_END).  Sequence
	// 3 has only one programmable step.  Sequence 1 and 2 have 4 steps, and
	// sequence 0 has 8 programmable steps.  Since we are only doing a single
	// conversion using sequence 3 we will only configure step 0.  For more
	// information on the ADC sequences and steps, reference the datasheet.
	//

	ADCSequenceStepConfigure(ADC0_BASE, 3, 0, config |ADC_CTL_IE|
			ADC_CTL_END);
	//
	// Since sample sequence 3 is now configured, it must be enabled.
	//
	ADCSequenceEnable(ADC0_BASE, 3);

	//
	// Clear the interrupt status flag.  This is done to make sure the
	// interrupt flag is cleared before we sample.
	//
	ADCIntClear(ADC0_BASE, 3);
	// Enable the interrupt after calibration.
	ADCIntEnable(ADC0_BASE, 3);
	// Set timer0 to trigger ADC every 100ms for data logging start event.
	ConfigTimer0(SysCtlClockGet()/10);
}
