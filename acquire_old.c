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
 * Pointer to next line of ADC buffer for processing.
 ***************************************************************/
volatile int p_processingPtr = 0;

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
 *************************************************************/
uint32_t GetSequence(tuiConfig* p_uiConfig){
	switch (p_uiConfig->sample_size) {
	case 1: return 3;
	default: return 0;
	}
}

/***************************************************************
 * Reads the ADC buffer for a new sample. Computes Min, Max, Ave
 * and sets the sample event flag when sampling is completed.
 ***************************************************************/
void GetSampleISR() {
	// Reset pointer on new sample.
	ADCIntClear(ADC0_BASE, sequence);
	if (p_uiADCBufferPtr == -1)p_uiADCBufferPtr = 0;
	ADCSequenceDataGet(ADC0_BASE, sequence, &p_uiADCBuffer[p_uiADCBufferPtr]);
	p_uiADCBufferPtr+=steplen;
	UARTprintf(".\n");
	if (p_uiADCBufferPtr == buffersize) {// Reset buffer pointer, stop processing till started by SW.
		p_uiADCBufferPtr = -1;
	//	TODO:Stop Command Here
	}
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
ConfigTimer0(tuiConfig* p_uiConfig) {
	// Enable the timer peripherals.
	//
	ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_TIMER0);
	//
	// Configure the two 32-bit periodic timers.
	//
	ROM_TimerConfigure(TIMER0_BASE, TIMER_CFG_PERIODIC_UP);
	ROM_TimerLoadSet(TIMER0_BASE, TIMER_A, GetPeriod(p_uiConfig->freq));
//	// Set the ADC event trigger.
	TimerADCEventSet(TIMER0_BASE, TIMER_ADC_TIMEOUT_A);
	// Configure Timer0 to trigger the ADC conversion.
	TimerControlTrigger(TIMER0_BASE, TIMER_A, true);
	ROM_TimerEnable(TIMER0_BASE, TIMER_A);
}
/***************************************************************
 * Sets up the appropriate ADC channel, its trigger and associated
 * interrupt handler. Also initialises the buffer size and sequence
 * variable for ADC logging.
 * After this call, the ADC periodic sampling starts running.
 ****************************************************************/
void
configChannel(tuiConfig* p_uiConfig) {
	//
	// The ADC0 peripheral must be enabled for use.
	//
	SysCtlPeripheralEnable(SYSCTL_PERIPH_ADC0);

	//
	// For this example ADC0 is used with AIN0 on port E7.
	// The actual port and pins used may be different on your part, consult
	// the data sheet for more information.  GPIO port E needs to be enabled
	// so these pins can be used.
	// TODO: change this to whichever GPIO port you are using.
	//
	SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOE);

	//
	// Select the analog ADC function for these pins.
	// Consult the data sheet to see which functions are allocated per pin.
	// TODO: change this to select the port/pin you are using.
	//
	if (p_uiConfig->channelOpt == ACCEL) {
		GPIOPinTypeADC(GPIO_PORTE_BASE, GPIO_PIN_6);
	} else if (p_uiConfig->channelOpt == VOLTS) {
		GPIOPinTypeADC(GPIO_PORTE_BASE, GPIO_PIN_3);
	}
    //
    // Select the external reference for greatest accuracy.
    //
    ROM_ADCReferenceSet(ADC0_BASE, ADC_REF_EXT_3V);
//    MAP_ADCReferenceSet(ADC1_BASE, ADC_REF_EXT_3V);

    //
    // Apply workaround for erratum 6.1, in order to use the
    // external reference.
    //
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOB);
    HWREG(GPIO_PORTB_BASE + GPIO_O_AMSEL) |= GPIO_PIN_6;
//    UARTprintf("ADC Config Check0! \n");
	sequence = GetSequence( p_uiConfig);

	//
	//Configure the timer to be used for triggering conversion.
	// Configure the ADC Event

	ConfigTimer0(p_uiConfig);

	//
	// Enable sample sequence with a processor signal trigger.  Sequence 3
	// will do a single sample when the processor sends a signal to start the
	// conversion.  Each ADC module has 4 programmable sequences, sequence 0
	// to sequence 3.  This example is arbitrarily using sequence 3.
	//
	ADCSequenceConfigure(ADC0_BASE, sequence,  ADC_TRIGGER_TIMER, 3);
//	UARTprintf("ADC Config Check1! \n");
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
	uint32_t channel = 0;
	if (p_uiConfig->channelOpt == ACCEL) {
		channel = ADC_CTL_CH21;
	} else if (p_uiConfig->channelOpt == VOLTS) {
		channel = ADC_CTL_CH0;
	}
	steplen = (sequence == 0)? 8:1;
	for (int step = 0; step < steplen; step++) {
		if (step == 8)	channel |= (ADC_CTL_IE | ADC_CTL_END);
		 ADCSequenceStepConfigure(ADC0_BASE, sequence, step, channel);
	}
//	UARTprintf("ADC Config Check2! \n");
	ADCIntRegister(ADC0_BASE, sequence, GetSampleISR);
	// Configure the buffer size for sequence.
	buffersize = p_uiConfig->sample_size * MAX_SAMPLES;
	//
	// Since sample sequence is now configured, it must be enabled.
	//
	ADCSequenceEnable(ADC0_BASE, sequence);
//	ADCIntEnable(ADC0_BASE, sequence);
	//
	// Clear the interrupt status flag.  This is done to make sure the
	// interrupt flag is cleared before we sample.
	//
	ADCIntClear(ADC0_BASE, sequence);
	// Enable the interrupt after calibration.
	ADCIntEnable(ADC0_BASE, sequence);
//	char str[5];
//	usprintf(str, "%d", GetPeriod(p_uiConfig->freq));
//	UARTprintf(str);
}
/***************************************************************
 * Main function to execute the acquire function. This starts the ADC
 * and plots the values on the graph. It is an infinite loop that
 * breaks on user input.
 ***************************************************************/
void
AcquireRun(tContext* pContext, tuiConfig* p_uiConfig) {
	configChannel(p_uiConfig);
//	UARTprintf("Acquire run check!");
	//Debug!
	char str[5];
	usprintf(str, "%d", TimerLoadGet(TIMER0_BASE, TIMER_A));
	UARTprintf("Timer period: ");
	UARTprintf(str);
	UARTprintf("\n");


//	char str[5];
	while (1) {
//		computeSample(p_uiConfig);
//		usprintf(str, "%d",datapoints[2]);
//		WriteString(pContext,str,0, 3, 7);
	}

}

