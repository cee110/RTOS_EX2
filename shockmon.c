/*
 * shockmon.c
 *
 *  Created on: 22 Feb 2014
 *      Author: Chinemelu Ezeh
 *
 *      Shock monitor listens for changes in the accelerometer.
 *      If there isi a change by a certain measure, the whole system
 *      stops and the accelerometer waveform is logged.
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
#include "inc/hw_types.h"
#include "inc/hw_ints.h"
#include "inc/hw_gpio.h"
#include "driverlib/debug.h"
#include "driverlib/adc.h"
#include "exercise2.h"
#include "uicontrol.h"
#include "acquire.h"


volatile uint32_t puiADC1Buffer[1];
volatile uint32_t prev1_value;
volatile bool first_entry = true;
volatile tuiConfig* psuiConfig;


//*****************************************************************************
//
// Flags that contain the current value of the interrupt indicator as displayed
// on the CSTN display.
//
//*****************************************************************************
uint32_t g_ui32Flags;
void
MonitorStart() {
	ROM_TimerEnable(TIMER1_BASE, TIMER_A);
	//
	// Disable ADC sequencers
	//
	ROM_ADCSequenceEnable(ADC1_BASE, 3);
}

void
MonitorStop() {
	ROM_TimerDisable(TIMER1_BASE, TIMER_A);
	//
	// Disable ADC sequencers
	//
	ROM_ADCSequenceDisable(ADC1_BASE, 3);
}
/****************************************************************
 * This interrupt handler is set up by AcquireInit to check
 * for the events that begin a data logging. This is when the voltage
 * exceeds a changeable threshold or
 * the accelerometer z-axis changes g by more than 0.5.
 *****************************************************************/
void MonitorShockISR() {
    ROM_TimerIntClear(TIMER1_BASE, TIMER_TIMA_TIMEOUT);
    //
    // Toggle the flag for the second timer.
    //
    HWREGBITW(&g_ui32Flags, 1) ^= 1;
	// If ADC has not converted yet, exit ISR.
   	if (!ADCIntStatus(ADC1_BASE, 3, false)) {
   		return;
   	}
   	ADCIntClear(ADC1_BASE, 3);
	ADCSequenceDataGet(ADC1_BASE, 3, puiADC1Buffer);
	ADCProcessorTrigger(ADC1_BASE, 3);
	if (first_entry) {
		first_entry = false;
		prev1_value = ReadAccel(puiADC1Buffer[0]);
	} else {
		puiADC1Buffer[0] = ReadAccel(puiADC1Buffer[0]);
		// Shock monitor detects a change of more than 2.5g
		if (abs((int)puiADC1Buffer[0] - prev1_value) > 240) {
//			UARTprintf("Shock! : %d \r",puiADC1Buffer[0]);
			MonitorStop();
//			ADC0AcquireStop();
			// Start logging waveform.
			ROM_IntMasterDisable();
			psuiConfig->isShocked = true;
			ROM_IntMasterEnable();
		}
		prev1_value = puiADC1Buffer[0];
	}

}

//*****************************************************************************
//
// Sets up timer1 to count up periodically with a period of 131us.
// Its priority is 2. 0 is reserved for exception handling.
//
//*****************************************************************************
//void
//ConfigTimer1(uint32_t period) {
//	//Register Interrupt Handlers
//	TimerIntRegister(TIMER1_BASE, TIMER_A, MonitorShockISR);
//	// Set the priority of the Timers
//	// Set Timer1 as level 1 priority
//	IntPrioritySet(INT_TIMER1A, 0x40);
//
//	//
//	// Configure the two 32-bit periodic timers.
//	//
//	ROM_TimerLoadSet(TIMER1_BASE, TIMER_A, period);
//	//
//	// Setup the interrupts for the timer timeouts.
//	//;
//	ROM_IntEnable(INT_TIMER1A);
//	ROM_TimerIntEnable(TIMER1_BASE, TIMER_TIMA_TIMEOUT);
//	//
//	// Enable the timer1.
//	//
//	ROM_TimerEnable(TIMER1_BASE, TIMER_A);
//}
void
ConfigTimer1(uint32_t period) {
	//Register Interrupt Handlers
	TimerIntRegister(TIMER1_BASE, TIMER_A, MonitorShockISR);
	// Set the priority of the Timers
	// Set Timer1 as level 2 priority
	IntPrioritySet(INT_TIMER1A, 0x40);
	// Enable the timer peripherals.
	//
	ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_TIMER1);
	//
	// Configure the two 32-bit periodic timers.
	//
	TimerConfigure(TIMER1_BASE, TIMER_CFG_PERIODIC);
	ROM_TimerLoadSet(TIMER1_BASE, TIMER_A, period);
	//
	// Setup the interrupts for the timer timeouts.
	//;
	ROM_IntEnable(INT_TIMER1A);
	ROM_TimerIntEnable(TIMER1_BASE, TIMER_TIMA_TIMEOUT);
	//
	// Enable the timer1.
	//
	ROM_TimerEnable(TIMER1_BASE, TIMER_A);
}
/****************************************************************
 * This function should be called first in AcquireRun.
 * It starts the ADC interrupt to detect the beginning of data logging
 * which is when the voltage exceeds a changeable threshold or
 * the accelerometer z-axis changes g by more than 0.5. The trigger
 * to look out for depends on the user's selection. The interrupt is
 * called every 100ms.
 ****************************************************************/
void ADC1AcquireStart() {

	//
	// Enable sample sequence 3 with a timer trigger.  Sequence 3
	// will do a single sample when the processor sends a signal to start the
	// conversion.  Each ADC module has 4 programmable sequences, sequence 0
	// to sequence 3.
	//
	ADCSequenceConfigure(ADC1_BASE, 3, ADC_TRIGGER_PROCESSOR, 0);

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

	ADCSequenceStepConfigure(ADC1_BASE, 3, 0, ADC_CTL_CH21 |ADC_CTL_IE|
			ADC_CTL_END);
	//
	// Since sample sequence 3 is now configured, it must be enabled.
	//
	ADCSequenceEnable(ADC1_BASE, 3);

	//
	// Clear the interrupt status flag.  This is done to make sure the
	// interrupt flag is cleared before we sample.
	//
	ADCIntClear(ADC1_BASE, 3);
	// Enable the interrupt after calibration.
//	ADCIntEnable(ADC1_BASE, 3);
}

void MonitorShockInit( tuiConfig* psuiConfig_t) {
	psuiConfig = psuiConfig_t;
	ADC1AcquireStart();
	//Need to poll the ADC
	ADCProcessorTrigger(ADC1_BASE, 3);
	ConfigTimer1(SysCtlClockGet()/100); //10ms
 }

