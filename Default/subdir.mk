################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../exercise1.c \
../startup_ccs.c 

C_DEPS += \
./exercise1.d \
./startup_ccs.d 


# Each subdirectory must supply rules for building sources it contributes
%.o: ../%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM Windows GCC C Compiler (Sourcery Lite Bare)'
	arm-none-eabi-gcc -O2 -ffunction-sections -fdata-sections -Wall -Wa,-adhlns="$@.lst" -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -mcpu=cortex-m3 -mthumb -g -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


