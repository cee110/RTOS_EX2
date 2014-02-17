#******************************************************************************
#
# Makefile - Rules for building the exercise1 example.
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

#
# Where to find header files that do not live in the source directory.
#
IPATH=..
IPATH+=../../../..

#
# The default rule, which causes the exercise1 example to be built.
#
all: ${COMPILER}
all: ${COMPILER}/exercise1.axf

#
# The rule to clean out all the build products.
#
clean:
	@rm -rf ${COMPILER} ${wildcard *~}

#
# The rule to download object to flash & run the code
#

flash:
	lmflash -q ek-lm4f232 -r -e all $(COMPILER)/exercise1.bin

#
# The rule to create the target directory.
#
${COMPILER}:
	@mkdir -p ${COMPILER}



#
# Rules for building the exercise1.
#
${COMPILER}/exercise1.axf: ${COMPILER}/cfal96x64x16.o
${COMPILER}/exercise1.axf: ${COMPILER}/exercise1.o
${COMPILER}/exercise1.axf: ${COMPILER}/startup_${COMPILER}.o
${COMPILER}/exercise1.axf: ${COMPILER}/uartstdio.o
${COMPILER}/exercise1.axf: ${COMPILER}/ustdlib.o
${COMPILER}/exercise1.axf: ${ROOT}/grlib/${COMPILER}/libgr.a
${COMPILER}/exercise1.axf: ${ROOT}/driverlib/${COMPILER}/libdriver.a
${COMPILER}/exercise1.axf: exercise1.ld
SCATTERgcc_exercise1=exercise1.ld
ENTRY_exercise1=ResetISR
CFLAGSgcc=-DTARGET_IS_BLIZZARD_RA1

#
# Include the automatically generated dependency files.
#
ifneq (${MAKECMDGOALS},clean)
-include ${wildcard ${COMPILER}/*.d} __dummy__
endif
