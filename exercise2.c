//*****************************************************************************
//
// exercise1.c - Simple exercise1 world example.
//
// Copyright (c) 2011-2013 Texas Instruments Incorporated.  All rights reserved.
// Software License Agreement
//
// Texas Instruments (TI) is supplying this software for use solely and
// exclusively on TI's microcontroller products. The software is owned by
// TI and/or its suppliers, and is protected under applicable copyright
// laws. You may not combine this software with "viral" open-source
// software in order to form a larger program.
//
// THIS SOFTWARE IS PROVIDED "AS IS" AND WITH ALL FAULTS.
// NO WARRANTIES, WHETHER EXPRESS, IMPLIED OR STATUTORY, INCLUDING, BUT
// NOT LIMITED TO, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE APPLY TO THIS SOFTWARE. TI SHALL NOT, UNDER ANY
// CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL, OR CONSEQUENTIAL
// DAMAGES, FOR ANY REASON WHATSOEVER.
//
// This is part of revision 2.0.1.11577 of the EK-LM4F232 Firmware Package.
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
#include "inc/hw_nvic.h"
#include "inc/hw_types.h"
#include "inc/hw_ints.h"
#include "quickselect.h"
//*****************************************************************************
//
//! \addtogroup example_list
//! <h1>exercise1 World (exercise1)</h1>
//!
//! A very simple ``exercise1 world'' example.  It simply displays ``exercise1 World!''
//! on the display and is a starting point for more complicated applications.
//! This example uses calls to the TivaWare Graphics Library graphics
//! primitives functions to update the display.  For a similar example using
//! widgets, please see ``exercise1_widget''.
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
volatile uint32_t prevtime = 0;
//*****************************************************************************
//
// Stores the values to be measure. In general, measurements[0] stores minimum
// measurements[1], maximum; measurements[2] = average;
// measurements[3] = interrupt handler entry count
//
//*****************************************************************************
volatile uint32_t measurements[4];
//*****************************************************************************
//
// Stores the entry previous time to interrupt handler
//
//*****************************************************************************
volatile uint32_t prev_entrytime = 0;
//*****************************************************************************
//
// Period of timer0
//
//*****************************************************************************
const uint32_t timer0_period = 1150; // 50E6 * 0.000023
//*****************************************************************************
//
// Period of timer 1
//
//*****************************************************************************
const uint32_t timer1_period = 5000; // 50E6 * 0.0001
//*****************************************************************************
//
// Period of SysTick Timer.
//
//*****************************************************************************
const uint32_t systick_period = 6550;// 50E6 * 0.000131

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

//*****************************************************************************
//
// The interrupt handler for the first timer interrupt.
//
//*****************************************************************************
void
Timer0IntHandler(void)
{
    //
    // Clear the timer interrupt.
    //
    ROM_TimerIntClear(TIMER0_BASE, TIMER_TIMA_TIMEOUT);
    //
    // Toggle the flag for the first timer.
    //
    HWREGBITW(&g_ui32Flags, 0) ^= 1;
}

//*****************************************************************************
//
// The interrupt handler for the second timer level 2 interrupt.
//
//*****************************************************************************
void
Timer1IntHandler(void)
{
	//
    // Clear the timer interrupt.
    //
    ROM_TimerIntClear(TIMER1_BASE, TIMER_TIMA_TIMEOUT);
    //
    // Toggle the flag for the second timer.
    //
    HWREGBITW(&g_ui32Flags, 1) ^= 1;

}
//*****************************************************************************
//
// Sets up timer0 to count up periodically with a period of 23us.
// Its priority is 1. 0 is reserved for exception handling.
//
//*****************************************************************************
void
ConfigTimer0() {
	//Register Interrupt Handlers
	TimerIntRegister(TIMER0_BASE, TIMER_A, Timer0IntHandler);
	// Set the priority of the Timers
	// Set Timer0 as level 1 priority
	IntPrioritySet(INT_TIMER0A, 0x20);

	// Enable the timer peripherals.
	//
	ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_TIMER0);
	//
	// Configure the two 32-bit periodic timers.
	//
	ROM_TimerConfigure(TIMER0_BASE, TIMER_CFG_PERIODIC_UP);
	ROM_TimerLoadSet(TIMER0_BASE, TIMER_A, timer0_period);
	//
	// Setup the interrupts for the timer timeouts.
	//
	ROM_IntEnable(INT_TIMER0A);
	ROM_TimerIntEnable(TIMER0_BASE, TIMER_TIMA_TIMEOUT);
	//
	// Enable the timer0.
	//
	ROM_TimerEnable(TIMER0_BASE, TIMER_A);
}

//*****************************************************************************
//
// Sets up timer1 to count up periodically with a period of 131us.
// Its priority is 2. 0 is reserved for exception handling.
//
//*****************************************************************************
void
ConfigTimer1() {
	//Register Interrupt Handlers
	TimerIntRegister(TIMER1_BASE, TIMER_A, Timer1IntHandler);
	// Set the priority of the Timers
	// Set Timer1 as level 2 priority
	IntPrioritySet(INT_TIMER1A, 0x40);
	// Enable the timer peripherals.
	//
	ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_TIMER1);
	//
	// Configure the two 32-bit periodic timers.
	//
	ROM_TimerConfigure(TIMER1_BASE, TIMER_CFG_PERIODIC_UP);
	ROM_TimerLoadSet(TIMER1_BASE, TIMER_A, timer1_period);
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

//*****************************************************************************
//
// Sets up SysTick Timer to count down periodically with a period of 131us.
// Its priority is 3. 0 is reserved for exception handling.
//
//*****************************************************************************
void
ConfigSysTick() {
	 //
	// Register the interrupt handler function for Systick.
	//
	SysTickIntRegister(SysTickIntHandler);

	// Set SysTick Priority to level 3
	IntPrioritySet(FAULT_SYSTICK,0x60);

	//
	// Set up the period for the SysTick timer(Resolution 1us).
	//
	SysTickPeriodSet(systick_period);

	//
	// Enable interrupts to the processor.
	//
	IntMasterEnable();

	//
	// Enable the SysTick Interrupt.
	//
	SysTickIntEnable();

	//
	// Enable SysTick.
	//
	SysTickEnable();
}

//*****************************************************************************
//
// Print "exercise1 World!" to the display.
//
//*****************************************************************************
int
main(void)
{

    //
    // Set the clocking to run directly from the crystal.
    //
    ROM_SysCtlClockSet(SYSCTL_SYSDIV_4 | SYSCTL_USE_PLL | SYSCTL_XTAL_16MHZ |
                       SYSCTL_OSC_MAIN);

    //
    // Initialize the UART.
    //
    ConfigureUART();

    vTestSBoxes();
}
