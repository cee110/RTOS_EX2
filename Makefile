#******************************************************************************
#
# Makefile - Rules for building the exercise2 example.
#
# Copyright (c) 2011-2013 Texas Instruments Incorporated.  All rights reserved.
# Software License Agreement
# 
# Texas Instruments (TI) is supplying this software for use solely and
# exclusively on TI's microcontroller products. The software is owned by
# TI and/or its suppliers, and is protected under applicable copyright
# laws. You may not combine this software with "viral" open-source
# software in order to form a larger program.
# 
# THIS SOFTWARE IS PROVIDED "AS IS" AND WITH ALL FAULTS.
# NO WARRANTIES, WHETHER EXPRESS, IMPLIED OR STATUTORY, INCLUDING, BUT
# NOT LIMITED TO, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE APPLY TO THIS SOFTWARE. TI SHALL NOT, UNDER ANY
# CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL, OR CONSEQUENTIAL
# DAMAGES, FOR ANY REASON WHATSOEVER.
# 
# This is part of revision 2.0.1.11577 of the EK-LM4F232 Firmware Package.
#
#******************************************************************************

#
# Defines the part type that this project uses.
#
PART=TM4C123GH6PGE

#
# The base directory for TivaWare.
#
ROOT=../../../..

#
# Include the common make definitions.
#
include ${ROOT}/makedefs

#
# Where to find source files that do not live in this directory.
#

VPATH=../drivers
VPATH+=../../../../utils

GCCPATH = -I${VPATH}
GCCPATH += -I..
GCCPATH += -I${ROOT}

#
# Where to find header files that do not live in the source directory.
#
IPATH=..
IPATH+=../../../..

#
# The default rule, which causes the exercise2 example to be built.
#
asmobj: 
	objdump -l -d -m i386:intel gcc/exercise2.o > exercise2.s

#
# The default rule, which causes the exercise2 example to be built.
#
asmgcc: 
	 gcc -v ${GCCPATH} -std=c99 -g -c -S -Wa,-alh exercise2.c

#
# The default rule, which causes the exercise2 example to be built.
#
asmsystick: 
	 gcc -v ${GCCPATH} -I. -g -c -S -Wa,-alh ${ROOT}/driverlib/systick.c

#
# The default rule, which causes the exercise2 example to be built.
#
asm_uart: 
	 gcc -v ${GCCPATH} -I. -g -c -S -Wa,-alh ${ROOT}/utils/uartstdio.c
	  
#
# The default rule, which causes the exercise2 example to be built.
#
all: ${COMPILER}
all: ${COMPILER}/exercise2.axf

#
# The rule to clean out all the build products.
#
clean:
	@rm -rf ${COMPILER} ${wildcard *~}

#
# The rule to download object to flash & run the code
#

flash:
	lmflash -q ek-lm4f232 -r -e all $(COMPILER)/exercise2.bin

#
# The rule to create the target directory.
#
${COMPILER}:
	@mkdir -p ${COMPILER}



#
# Rules for building the exercise2.
#
${COMPILER}/exercise2.axf: ${COMPILER}/cfal96x64x16.o
${COMPILER}/exercise2.axf: ${COMPILER}/exercise2.o
${COMPILER}/exercise2.axf: ${COMPILER}/startup_${COMPILER}.o
${COMPILER}/exercise2.axf: ${COMPILER}/uartstdio.o
${COMPILER}/exercise2.axf: ${COMPILER}/ustdlib.o
${COMPILER}/exercise2.axf: ${COMPILER}/buttons.o
${COMPILER}/exercise2.axf: ${COMPILER}/quickselect.o
${COMPILER}/exercise2.axf: ${ROOT}/grlib/${COMPILER}/libgr.a
${COMPILER}/exercise2.axf: ${ROOT}/driverlib/${COMPILER}/libdriver.a
${COMPILER}/exercise2.axf: exercise2.ld
SCATTERgcc_exercise2=exercise2.ld
ENTRY_exercise2=ResetISR
CFLAGSgcc=-DTARGET_IS_BLIZZARD_RA1

#
# Include the automatically generated dependency files.
#
ifneq (${MAKECMDGOALS},clean)
-include ${wildcard ${COMPILER}/*.d} __dummy__
endif
