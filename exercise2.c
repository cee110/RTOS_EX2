//*****************************************************************************
//
// exercise2.c - Data Logger with Shock Detection.
// Author: Chinemelu Ezeh
//
//*****************************************************************************
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
#include "driverlib/adc.h"
#include "inc/hw_nvic.h"
#include "inc/hw_types.h"
#include "inc/hw_gpio.h"
#include "inc/hw_ints.h"
#include "drivers/buttons.h"
#include "uicontrol.h"
#include "acquire.h"
#include "shockmon.h"
//*****************************************************************************
//
//
//! This is a simple application that displays the accelerometer z-axis and voltage input
//! data on the OLED display. To navigate through the settings, press up and down to scroll
//! between different setting topic. Press left and right to scroll between options for a
//! specific topic. Press SELECT to lock onto a setting. If SELECT is not pressed, the
//! settings are not saved.
//!
//! The shock monitoring system starts at runtime but once a shock is detected, the
//! waveform is plotted on a graph and the led blinks for about 10 seconds. Within this
//! time, the graph can be cancelled but the led will still be blinking. Normal waveform
//! can still be plotted but the shock monitoring will start again when the led stops blinking.
//!
//! The normal waveform graph can be cancelled at anytime so there is no need for reset.
//! New setting can be selected after cancelling a graph.
//!
//! Errata:
//! The ADC0 does not sample for 100kHz and 1MHz. So when selecting these options, operation is
//! not guaranteed. The observation is that there is a relationship between unregistering an
//! old ISR for the specific ADC0  and registering a new ISR. If no unregistering occurs, the ADC works fine.
//! However, with re-registry comes change of timer0 period so that may also be part of issue.
//
//
//*****************************************************************************

//The serial port speed
#define BAUDRATE 115200
#define MAX_VAL 999999999;
//*****************************************************************************
//
// The error routine that is called if the driver library encounters an error.
//
//*****************************************************************************
#ifdef DEBUG
void
__error__(char *pcFilename, uint32_t ui32Line)
{
    UARTprintf("Library Error: line %d\n",ui32Line);
}
#endif

//*****************************************************************************
//
// Patches that were needed.
//
//*****************************************************************************
#if __STDC_VERSION__ < 199901L
#define restrict /* nothing */
#endif

//*****************************************************************************
//
// Flags that contain the current value of the interrupt indicator as displayed
// on the CSTN display.
//
//*****************************************************************************
uint32_t g_ui32Flags;
//*****************************************************************************
//
// Counter to count the number of interrupts that have been called by SysTick.
//
//*****************************************************************************
volatile uint32_t current_time = 0;

//*****************************************************************************
//
// Period of SysTick Timer.
//
//*****************************************************************************
const uint32_t systick_period = 6550;// 50E6 * 0.000131

/***********************************************
 *
 * Stores User Configuration.
 * Initialise to 10Hz, 1 sample, Accelerometer channel and idle state
 ************************************************/
static tuiConfig uiConfig = {10,1, ACCEL, idle};
//tContext sContext;
//*****************************************************************************
//
// Configure the UART and its pins.  This must be called before UARTprintf().
//
//*****************************************************************************
void
ConfigureUART(void)
{
    //
    // Enable the GPIO Peripheral used by the UART.
    //
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOA);

    //
    // Enable UART0
    //
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_UART0);

    //
    // Configure GPIO Pins for UART mode.
    //
    ROM_GPIOPinConfigure(GPIO_PA0_U0RX);
    ROM_GPIOPinConfigure(GPIO_PA1_U0TX);
    ROM_GPIOPinTypeUART(GPIO_PORTA_BASE, GPIO_PIN_0 | GPIO_PIN_1);

    //
    // Use the internal 16MHz oscillator as the UART clock source.
    //
    UARTClockSourceSet(UART0_BASE, UART_CLOCK_PIOSC);

    //
    // Initialize the UART for console I/O.
    //
    UARTStdioConfig(0, BAUDRATE, 16000000);
}

//*****************************************************************************
//
// The interrupt handler for the for Systick interrupt.
//
//*****************************************************************************
void
SysTickIntHandler(void)
{
	ROM_IntMasterDisable();
	if ((HWREG(NVIC_ST_CTRL) & NVIC_ST_CTRL_COUNT)!=0){}
	current_time++;
	ROM_IntMasterEnable();
}

////*****************************************************************************
////
//// Sets up SysTick Timer to count down periodically with a period of 131us.
//// Its priority is 3. 0 is reserved for exception handling.
////
////*****************************************************************************
//void
//ConfigSysTick() {
//	 //
//	// Register the interrupt handler function for Systick.
//	//
//	SysTickIntRegister(SysTickIntHandler);
//
//	// Set SysTick Priority to level 3
//	IntPrioritySet(FAULT_SYSTICK,0x60);
//
//	//
//	// Set up the period for the SysTick timer(Resolution 1us).
//	//
//	SysTickPeriodSet(SysCtlClockGet()/100);
//
//	//
//	// Enable interrupts to the processor.
//	//
//	IntMasterEnable();
//
//	//
//	// Enable the SysTick Interrupt.
//	//
//	SysTickIntEnable();
//
//	//
//	// Enable SysTick.
//	//
//	SysTickEnable();
//}
/******************************************************************************
 * Enables the ADC peripherals
 * but the Sequence needs to be configured at run-time
 ******************************************************************************/
void
InitialiseADCPeripherals () {
	//
	// The ADC0 peripheral must be enabled for use.
	//
	SysCtlPeripheralEnable(SYSCTL_PERIPH_ADC0);
	SysCtlPeripheralEnable(SYSCTL_PERIPH_ADC1);
	//
	// GPIO port E needs to be enabled
	// so the GPIO pins for data input can be used.
	//
	SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOE);

	//
	// Select the analog ADC function for these pins.
	// Accelerometer z-axis is on PE6 and AIN0 is on PE3
	//

	GPIOPinTypeADC(GPIO_PORTE_BASE, GPIO_PIN_6);
	GPIOPinTypeADC(GPIO_PORTE_BASE, GPIO_PIN_3);

	//
	// Select the external reference for greatest accuracy.
	//
	ADCReferenceSet(ADC0_BASE, ADC_REF_EXT_3V);
	ADCReferenceSet(ADC1_BASE, ADC_REF_EXT_3V);
	//
	// Apply workaround for erratum 6.1, in order to use the
	// external reference.
	//
	SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOB);
	HWREG(GPIO_PORTB_BASE + GPIO_O_AMSEL) |= GPIO_PIN_6;

}

/******************************************************************************
 * Enables the Timer peripherals
 * but the ADC trigger and timers needs to be configured at run-time
 ******************************************************************************/
void
InitialiseTimer0() {
	// Enable the timer peripherals.
	//
	ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_TIMER0);
	//
	// Configure the two 32-bit periodic timers.
	//
	ROM_TimerConfigure(TIMER0_BASE, TIMER_CFG_PERIODIC_UP);

	TimerLoadSet(TIMER0_BASE, TIMER_A, 0);
}
//*****************************************************************************
//
// High level App Controller.
//
//*****************************************************************************
int
main(void)
{
	// Display Context
	static tContext sDisplayContext;
    //
    // Set the clocking to run directly from the crystal.
    //
    ROM_SysCtlClockSet(SYSCTL_SYSDIV_4 | SYSCTL_USE_PLL | SYSCTL_XTAL_16MHZ |
                       SYSCTL_OSC_MAIN);

    //
    // Initialize the UART.
    //
    ConfigureUART();

    CFAL96x64x16Init(); /* initialise controller */
	ButtonsInit(); 		/* initialise buttons */

	//
	// Initialize the graphics context.
	//
	GrContextInit(&sDisplayContext, &g_sCFAL96x64x16);
	// Initialise the ADC peripherals
	InitialiseADCPeripherals();
	// Initialise the timers
	InitialiseTimer0();
	// Initialise UI State
	uiConfig.uiState = idle;
	uiConfig.isShocked = false;
	// Setup Display.
	vInitUI(&sDisplayContext);
	// Start monitoring for shock.
	MonitorShockInit(&uiConfig);

	while (1) {
		/* vProcessSBoxButton should be called regularly */
		/* poll keys, changing SBoxes if needed */
		vPollSBoxButton(&sDisplayContext,&uiConfig);

		if ((uiConfig.uiState == logging)||(uiConfig.isShocked == true)) {

			// If the system was shocked from any state
			//	change state to logging.
			//	Acquire Main captures as normal to detect shock waveform
			// Freq = 1600Hz, N = 1, channel = ACCEL
			if (uiConfig.isShocked == true) {
				uiConfig.freq = 1600;
				uiConfig.sample_size = 1;
				uiConfig.channelOpt = ACCEL;
				ROM_IntMasterDisable();
				uiConfig.uiState = logging;
				ROM_IntMasterEnable();
			}
			//	This is an infinite loop till user pressed a button
			AcquireMain(&sDisplayContext, &uiConfig);
			// Redraw settings UI.
			vPaintSBoxes(&sDisplayContext);
		}
	}

}
