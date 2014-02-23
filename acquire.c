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
#include "shockmon.h"
#include "acquire.h"


#define MAX_SAMPLES 96
#define MAX_SAMPLE_SIZE 32
/****************************************************************
 * Buffer to store Acquisition Data
 ***************************************************************/
uint32_t puiADC0Buffer[MAX_SAMPLES*MAX_SAMPLE_SIZE];

/****************************************************************
 * Pointers to ADC buffer.
 ***************************************************************/
volatile uint32_t* puiADC0StartPtr;
volatile uint32_t* puiADC0StopPtr;
/****************************************************************
 * Acquire Event Flags.
 * Bit 0: For Normal Data logging Start Trigger.
 * 0 means trigger has not been detected.
 * 1 means trigger has been detected.
 *
 * Bit 1: Done bit for Sampling Set Event.
 * Clear this flag when you have read all the data from the ADC buffer.
 * 0 means that the current sampling set has not finished
 * 1 means that the current sampling set has been gotten.
 *
 * Bit 2: Indication for ADC0AcquireStart() first entry
 * Clear this after first entry to ADC0AcquireStart()
 * 0 means this is the first entry
 * 1 means this is NOT the first entry
 ***************************************************************/
volatile uint8_t eventflags = 0;
/* ***************************************************************
 * Defines for accessing eventflag bits.
 * ***************************************************************/
#define ADC_TRIG_CTL 0x01
#define ADC_SAMPLE_DONE 0x02
#define ADC_START_ENTRY 0x04

volatile uint32_t buffersize;
volatile uint32_t sequence;
volatile uint32_t steplen;
/************************************************************
 * Stores the values of the data point to be plotted.
 * min = datapoint[0], max = datapoint[1], ave = datapoint[2]
 *************************************************************/
#define MAX_NUM 999999999
typedef struct tdata {
	uint32_t max;
	uint32_t min;
	uint32_t ave;
}tdatapoint;

volatile tdatapoint datapoints = {MAX_NUM,0,0};
/****************************************************************
 * Pointer to NEXT line of ADC buffer for processing.
 ***************************************************************/
volatile uint32_t* p_processingPtr;
/****************************************************************
 * Graphs x-axis. Here because it needs global initialisation.
 ****************************************************************/
volatile uint32_t x_axis;
/****************************************************************
 * Initialise the Graphics configuration
 ****************************************************************/
tYBounds yBounds[] = {
		{250, -50, ACCEL },				// Accelerometer unit is g*100
		{200, 0, VOLTS }					// Voltage is in V*100
};
/****************************************************************
 * Initialise the series color
 ****************************************************************/
tseriesColor seriesColor = {ClrRed, ClrGreen, ClrWhite};
/****************************************************************
 * Initialise the graphics configuration
 ****************************************************************/
volatile tguiConfig record = {
		0,
		yBounds,
		&seriesColor,
		0
};

//-------------------------Functions----------------------------//

void
StopTimer0() {
	ROM_TimerDisable(TIMER0_BASE, TIMER_A);
	TimerControlTrigger(TIMER0_BASE, TIMER_A, false);
}
void ADC0AcquireStop() {

	// Disable every sequence used in ADC0.
	//
	// Disable ADC interrupts
	//
	ROM_IntDisable(INT_ADC0SS0);
	ROM_IntDisable(INT_ADC0SS3);

	//
	// Disable ADC sequencers
	//
	ROM_ADCSequenceDisable(ADC0_BASE, 0);
	ROM_ADCSequenceDisable(ADC0_BASE, 3);

	TimerControlTrigger(TIMER0_BASE, TIMER_A, false);
	//Disable Timers
	StopTimer0();
}
// Returns Accelerometer value in g*100 read raw from ADC buffer.
int ReadAccel(uint32_t value) {
	return (2442*(int)value - 5000000)/10000;
}
/****************************************************************/
#define MAX_SCREEN_Y_AXIS 56
/*
 * Gets the fraction of the screen for the appropriate boundary condition.
 * If values exceeds the maximum then it saturates at the maximum.
 * Likewise for minimum.
 */
uint32_t
GetYAxis(channel_enum channel, uint32_t val) {
	uint32_t temp = 0;
	// Get the fraction of the screen for appropriate boundary condition.
	for (int i = 0; i < sizeof(yBounds)/sizeof(tYBounds);i++){ // Search for matching channel
		if (yBounds[i].channel == channel) {
			if (channel == ACCEL) {
				int temp_accel = ReadAccel(val);
				if (temp_accel > record.pYbounds[i].MAX ) {
					temp = MAX_SCREEN_Y_AXIS;
				} else if (temp_accel < record.pYbounds[i].MIN) {
					temp = 0;
				} else {
					temp = ((temp_accel - record.pYbounds[i].MIN)*MAX_SCREEN_Y_AXIS)/ (record.pYbounds[i].MAX - record.pYbounds[i].MIN);
				}
				break;

			} else if(channel == VOLTS){
				if (val > record.pYbounds[i].MAX ) {
					temp = MAX_SCREEN_Y_AXIS;
				} else if (val < record.pYbounds[i].MIN) {
					temp = 0;
				} else {
					temp = ((val - record.pYbounds[i].MIN)*MAX_SCREEN_Y_AXIS)/ (record.pYbounds[i].MAX - record.pYbounds[i].MIN);
				}
				break;
			}
		}
	}

	// Account for screen inverting.
	return 63-temp;
}

/****************************************************************
 * Plots one sample on OLED
 *****************************************************************/
void
PlotData(tContext* psContext){
	GrContextForegroundSet(psContext, record.pSeriesColor->MAX_COLOR);
	GrPixelDraw(psContext, x_axis,GetYAxis(record.puiConfig->channelOpt, datapoints.max)); // Draw max first.

	GrContextForegroundSet(psContext, record.pSeriesColor->MIN_COLOR);
	GrPixelDraw(psContext, x_axis,GetYAxis(record.puiConfig->channelOpt, datapoints.min)); // Draw min

	GrContextForegroundSet(psContext, record.pSeriesColor->AVE_COLOR);
	GrPixelDraw(psContext, x_axis,GetYAxis(record.puiConfig->channelOpt, datapoints.ave)); // Draw ave last

	x_axis++;
	//wraparound.
	if(x_axis == MAX_SAMPLES) {
		x_axis = 0;
		//Clear Graph.
		ClearGraph(record.pContext);
	}
}
/************************************************************
 * Reads the ADC buffer to compute the min, max and ave data points.
 * The function always reads up to the written part of the buffer
 * so there is no chance for data hazard.
 * TODO: Use mutex instead of critical sections.
 *************************************************************/
void
computeSample(tContext *pContext, tuiConfig* p_uiConfig) {
	// Read the ADC buffer pointer in a critical section.
	// Loops until buffer has enough data.
//	UARTprintf("Sample\r");

	uint32_t * pointer;
	int size = 0;
	char debugChar[10];

	do {
		ROM_IntMasterDisable();
		pointer = puiADC0StartPtr;
		ROM_IntMasterEnable();
		size = pointer - p_processingPtr;
		// Don't poll too fast to starve the ISR with the critical section.
		/*
		 * Because compute sample may take a while for the slowest
		 * sampling frequency, button polling is inserted here to
		 * check if a button has been pressed.
		 * TODO: implement button press isr.
		 */
		vPollSBoxButton(pContext, p_uiConfig);
		if (record.puiConfig->uiState == idle) {
			return;
		}
		SysCtlDelay(1000);

	} while(size < p_uiConfig->sample_size);
//	usprintf(debugChar, "%d", size);
//	UARTprintf(debugChar);
//	UARTprintf("\r");
	// Reset data points;
	datapoints.min = MAX_NUM;
	datapoints.max = 0;
	datapoints.ave = 0;
	// Compute Min, Max, Ave
	for (int i = 0; i < p_uiConfig->sample_size; i++) {
		if (p_processingPtr[0] < datapoints.min) { // Compute Min
			datapoints.min = p_processingPtr[0];
		}
		if (p_processingPtr[0] > datapoints.max) { // Compute Max
			datapoints.max = p_processingPtr[0];
		}
		datapoints.ave+=p_processingPtr[0];
		p_processingPtr++;
	}
	datapoints.ave /= p_uiConfig->sample_size;
	// Check for wrap around
	if (p_processingPtr == puiADC0StopPtr) {
		p_processingPtr = puiADC0Buffer;
	}
//	UARTprintf("start...\r");
	usprintf(debugChar, "%5d", datapoints.max);
	UARTprintf(debugChar);
	UARTprintf(" \r");
	UARTprintf("ave \r");
	usprintf(debugChar, "%5d", datapoints.ave);
	UARTprintf(debugChar);
	UARTprintf(" \r");
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
volatile uint32_t tobedelted = 0;
/***************************************************************
 * Reads the ADC buffer for a new sample. Computes Min, Max, Ave
 * and sets the sample event flag when sampling is completed.
 * TODO: Implement Circular buffers.
 ***************************************************************/
void GetSampleISR() {
	// Reset pointer on new sample.
	ADCIntClear(ADC0_BASE, sequence);
	ADCSequenceDataGet(ADC0_BASE, sequence, puiADC0StartPtr);
	puiADC0StartPtr+=steplen;
	/*
	 * Check for wraparound. This also means one sequence has been
	 * obtained so flag for sampling done.
	 */
	if (puiADC0StartPtr == puiADC0StopPtr) {
		puiADC0StartPtr = puiADC0Buffer;
		// Set the done bit of the event flag.
		eventflags |= ADC_SAMPLE_DONE;
	//	TODO:Stop Command Here
		ADC0AcquireStop();
	}
	tobedelted++;
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
StartTimerTrigger0(uint32_t period) {
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
ADC0AcquireStart(tuiConfig* p_uiConfig, void (*pfnHandler)(void)) {
	if((!eventflags) & ADC_START_ENTRY) { // First entry
		eventflags |= ADC_START_ENTRY; //Set the flag
		sequence = 3;
		steplen = 1;
	} else {
		sequence = GetSequence(record.puiConfig);
		steplen = (sequence == 0)? 8:1;
	}
	//
	// Display the setup on the console.
	//
	UARTprintf("ADC Acquire Start\n");

	//
	// Enable sample sequence 3 with a processor signal trigger.  Sequence 3
	// will do a single sample when the processor sends a signal to start the
	// conversion.  Each ADC module has 4 programmable sequences, sequence 0
	// to sequence 3.  This example is arbitrarily using sequence 3.
	//

	ADCSequenceConfigure(ADC0_BASE, sequence, ADC_TRIGGER_TIMER, 1);
	ADCIntRegister(ADC0_BASE, sequence, pfnHandler);

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
	// Some important initialisations
	// Configure the buffer size for sequence.
	buffersize = p_uiConfig->sample_size * MAX_SAMPLES;
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
//	StartTimerTrigger0(GetPeriod(p_uiConfig->freq));
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
	ADCSequenceDataGet(ADC0_BASE, sequence, puiADC0Buffer);
	if (record.puiConfig->channelOpt == ACCEL) {
		if (first) {
			first = false;
			prev_value = ReadAccel(puiADC0Buffer[0]);
		} else {
			int curr_value = ReadAccel(puiADC0Buffer[0]);
			if (abs(curr_value - prev_value) > 50) {
				UARTprintf("Accel!\r");
				// Set the event flag
				eventflags|= ADC_TRIG_CTL;
				ADC0AcquireStop();
			}
			prev_value = curr_value;
		}
	} else if (record.puiConfig->channelOpt == VOLTS){
		if (puiADC0Buffer[0] > VTHRES) {
			UARTprintf("Volts!\r");
			eventflags|= ADC_TRIG_CTL;
			ADC0AcquireStop();
		}
	}
}
// Described with its implementation.
//void AcquireInit(tuiConfig* p_uiConfig);

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

	// --------------------Initialisations----------------------------//
	//initialise user configuration
	record.puiConfig = puiConfig_t;
	//initialise pointers
	p_processingPtr = puiADC0Buffer;
	puiADC0StartPtr = puiADC0Buffer;
	puiADC0StopPtr = &puiADC0Buffer[record.puiConfig->sample_size * MAX_SAMPLES];

	// Initialise title.
	if (record.puiConfig->channelOpt == ACCEL) {
		record.seriesTitle = "ACCEL";
	}else if (record.puiConfig->channelOpt == VOLTS) {
		record.seriesTitle = "VOLTS";
	}
	//Initialise the context
	record.pContext = pContext;
	DrawStartBanner(pContext, record.seriesTitle);

	// Initialise Graph x-axis
	x_axis = 0;
	// Resets the event flags
	eventflags = 0;
	uint32_t loopCount = 0;
	uint32_t waitCount = 0;
	// ---------------Run Acquire functionality----------------------//
	// If state == shocked, by pass trigger to start logging.
	if (record.puiConfig->isShocked == false) {
		ADC0AcquireStart(record.puiConfig, TriggerDetectISR);
		StartTimerTrigger0(SysCtlClockGet()/10);//100ms
		//---------

		// Wait for trigger event
		while((!eventflags) & ADC_TRIG_CTL){
			/*
			 * check for button press while waiting. Should really
			 * use an ISR for buttons. This is getting way too messy.
			 */
			vPollSBoxButton(pContext, record.puiConfig);
			#include "eventCheck.txt"
		}
		// Reset trigger event flag.
		eventflags &= !ADC_TRIG_CTL;
		// If we get to here that means ADC has triggered
		// wave capture is about to start.
//		UARTprintf("  Checkpoint!\r");
	} else { // System was shocked. Reset flag.
		ROM_IntMasterDisable();
		record.puiConfig->isShocked = false;
		ROM_IntMasterEnable();
	}
	while (1) {
	 	// Start logging data!
		ADC0AcquireStart(record.puiConfig, GetSampleISR);
		StartTimerTrigger0(GetPeriod(record.puiConfig->freq));
		char str[5];
		//reset loopcount
		loopCount = 0;
		// One loop outputs one sample set so there should be 96 loops
		while(loopCount != MAX_SAMPLES)
		{
			loopCount++;
			vPollSBoxButton(pContext, record.puiConfig);
			computeSample(record.pContext,record.puiConfig);
			#include "eventCheck.txt"
			PlotData(record.pContext);
			SysCtlDelay(SysCtlClockGet() / 1000);
		}

		//TODO: Modify Loop to poll buttons.
		if (record.puiConfig->channelOpt == ACCEL) {
			waitCount = 1500;
		} else if (record.puiConfig->channelOpt == VOLTS) {
			waitCount = 150;
		}
		loopCount = 0;
		while(loopCount != waitCount) {
			loopCount++;
			vPollSBoxButton(pContext, record.puiConfig);
			#include "eventCheck.txt"
			SysCtlDelay(SysCtlClockGet()/1000);
		}
	}
}
/*****************************************************************
 * Stops the trigger detection functionality.
 *****************************************************************/
//void
//StopDetection() {
//	// Disable the interrupt.
//	ADCIntDisable(ADC0_BASE, 3);
//	// Stop the timer from triggering ADC conversion.
//	TimerControlTrigger(TIMER0_BASE, TIMER_A, false);
//	// First remove the ISR.
//	ADCIntUnregister(ADC0_BASE,3);
//	// Disable the sequence.
//	ADCSequenceDisable(ADC0_BASE, 3);
//	//
//	// The ADC0 peripheral is disabled till use.
//	//
////	SysCtlPeripheralDisable(SYSCTL_PERIPH_ADC0);
//}



/****************************************************************
 * This function should be called first in AcquireRun.
 * It starts the ADC interrupt to detect the beginning of data logging
 * which is when the voltage exceeds a changeable threshold or
 * the accelerometer z-axis changes g by more than 0.5. The trigger
 * to look out for depends on the user's selection. The interrupt is
 * called every 100ms.
 ****************************************************************/
//void AcquireInit(tuiConfig* p_uiConfig) {
//
//	//
//	// Enable sample sequence 3 with a timer trigger.  Sequence 3
//	// will do a single sample when the processor sends a signal to start the
//	// conversion.  Each ADC module has 4 programmable sequences, sequence 0
//	// to sequence 3.
//	//
//	ADCSequenceConfigure(ADC0_BASE, 3, ADC_TRIGGER_TIMER, 3);
//	// Register the interupt called after ADC conversion.
//	ADCIntRegister(ADC0_BASE, 3, TriggerDetectISR);
//	/*
//	 * Select the ADC channel for the specific GPIO pin to be used.
//	 */
//	uint32_t config = 0;
//	if (p_uiConfig->channelOpt == ACCEL) {
//		config = ADC_CTL_CH21;
//	} else if (p_uiConfig->channelOpt == VOLTS) {
//		config = ADC_CTL_CH0;
//	}
//	//
//	// Configure step 0 on sequence 3.  Sample channel 0 (ADC_CTL_CH0) in
//	// single-ended mode (default) and configure the interrupt flag
//	// (ADC_CTL_IE) to be set when the sample is done.  Tell the ADC logic
//	// that this is the last conversion on sequence 3 (ADC_CTL_END).  Sequence
//	// 3 has only one programmable step.  Sequence 1 and 2 have 4 steps, and
//	// sequence 0 has 8 programmable steps.  Since we are only doing a single
//	// conversion using sequence 3 we will only configure step 0.  For more
//	// information on the ADC sequences and steps, reference the datasheet.
//	//
//
//	ADCSequenceStepConfigure(ADC0_BASE, 3, 0, config |ADC_CTL_IE|
//			ADC_CTL_END);
//	//
//	// Since sample sequence 3 is now configured, it must be enabled.
//	//
//	ADCSequenceEnable(ADC0_BASE, 3);
//
//	//
//	// Clear the interrupt status flag.  This is done to make sure the
//	// interrupt flag is cleared before we sample.
//	//
//	ADCIntClear(ADC0_BASE, 3);
//	// Enable the interrupt after calibration.
//	ADCIntEnable(ADC0_BASE, 3);
//	// Set timer0 to trigger ADC every 100ms for data logging start event.
//	StartTimer0(SysCtlClockGet()/10);
//}
