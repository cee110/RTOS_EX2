	.file	"acquire.c"
	.text
Ltext0:
	.comm	_puiADC0Buffer, 12288, 5
	.comm	_puiADC0StartPtr, 4, 2
	.comm	_puiADC0StopPtr, 4, 2
	.globl	_puiADC0BufferPtr
	.bss
	.align 4
_puiADC0BufferPtr:
	.space 4
	.globl	_eventflags
_eventflags:
	.space 1
	.comm	_buffersize, 4, 2
	.comm	_sequence, 4, 2
	.comm	_steplen, 4, 2
	.globl	_datapoints
	.data
	.align 4
_datapoints:
	.long	999999999
	.long	0
	.long	0
	.globl	_p_processingPtr
	.bss
	.align 4
_p_processingPtr:
	.space 4
	.comm	_puiConfig, 4, 2
	.text
	.globl	_computeSample
	.def	_computeSample;	.scl	2;	.type	32;	.endef
_computeSample:
LFB6:
	.file 1 "acquire.c"
	.loc 1 92 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	.loc 1 95 0
	movl	$0, -12(%ebp)
L4:
LBB2:
	.loc 1 97 0
	call	_ROM_IntMasterDisable
	.loc 1 98 0
	movl	_puiADC0BufferPtr, %eax
	movl	%eax, -20(%ebp)
	.loc 1 99 0
	call	_ROM_IntMasterEnable
	.loc 1 100 0
	cmpl	$-1, -20(%ebp)
	jne	L2
	.loc 1 101 0
	movl	_buffersize, %eax
	movl	%eax, -12(%ebp)
	jmp	L3
L2:
	.loc 1 103 0
	movl	-20(%ebp), %eax
	movl	%eax, -12(%ebp)
L3:
	.loc 1 105 0
	movl	_p_processingPtr, %eax
	subl	%eax, -12(%ebp)
	.loc 1 107 0
	movl	$1000, (%esp)
	call	_SysCtlDelay
LBE2:
	.loc 1 108 0
	movl	-12(%ebp), %edx
	movl	8(%ebp), %eax
	movl	4(%eax), %eax
	cmpl	%eax, %edx
	jb	L4
	.loc 1 111 0
	movl	$999999999, _datapoints
	.loc 1 112 0
	movl	$0, _datapoints+8
	movl	_datapoints+8, %eax
	movl	%eax, _datapoints+4
LBB3:
	.loc 1 114 0
	movl	_p_processingPtr, %eax
	movl	%eax, -16(%ebp)
	jmp	L5
L8:
	.loc 1 115 0
	movl	-16(%ebp), %eax
	movl	_puiADC0Buffer(,%eax,4), %edx
	movl	_datapoints, %eax
	cmpl	%eax, %edx
	jae	L6
	.loc 1 116 0
	movl	-16(%ebp), %eax
	movl	_puiADC0Buffer(,%eax,4), %eax
	movl	%eax, _datapoints
L6:
	.loc 1 118 0
	movl	-16(%ebp), %eax
	movl	_puiADC0Buffer(,%eax,4), %edx
	movl	_datapoints+4, %eax
	cmpl	%eax, %edx
	jbe	L7
	.loc 1 119 0
	movl	-16(%ebp), %eax
	movl	_puiADC0Buffer(,%eax,4), %eax
	movl	%eax, _datapoints+4
L7:
	.loc 1 121 0
	movl	_datapoints+8, %edx
	movl	-16(%ebp), %eax
	movl	_puiADC0Buffer(,%eax,4), %eax
	addl	%edx, %eax
	movl	%eax, _datapoints+8
	.loc 1 114 0
	addl	$1, -16(%ebp)
L5:
	.loc 1 114 0 is_stmt 0 discriminator 1
	movl	-16(%ebp), %edx
	movl	8(%ebp), %eax
	movl	4(%eax), %eax
	cmpl	%eax, %edx
	jb	L8
LBE3:
	.loc 1 123 0 is_stmt 1
	movl	_datapoints+8, %eax
	movl	8(%ebp), %edx
	movl	4(%edx), %ecx
	movl	$0, %edx
	divl	%ecx
	movl	%eax, _datapoints+8
	.loc 1 124 0
	movl	8(%ebp), %eax
	movl	4(%eax), %edx
	movl	_p_processingPtr, %eax
	addl	%edx, %eax
	movl	%eax, _p_processingPtr
	.loc 1 126 0
	movl	_p_processingPtr, %eax
	movl	%eax, %edx
	movl	_buffersize, %eax
	cmpl	%eax, %edx
	jne	L1
	.loc 1 127 0
	movl	$0, _p_processingPtr
L1:
	.loc 1 128 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE6:
	.globl	_GetSequence
	.def	_GetSequence;	.scl	2;	.type	32;	.endef
_GetSequence:
LFB7:
	.loc 1 139 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	.loc 1 140 0
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	cmpl	$1000000, %eax
	jne	L14
	.loc 1 141 0
	movl	$0, %eax
	jmp	L13
L14:
	.loc 1 142 0
	movl	$3, %eax
L13:
	.loc 1 144 0
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE7:
	.globl	_tobedelted
	.bss
	.align 4
_tobedelted:
	.space 4
	.text
	.globl	_GetSampleISR
	.def	_GetSampleISR;	.scl	2;	.type	32;	.endef
_GetSampleISR:
LFB8:
	.loc 1 151 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	.loc 1 153 0
	movl	_sequence, %eax
	movl	%eax, 4(%esp)
	movl	$1073971200, (%esp)
	call	_ADCIntClear
	.loc 1 154 0
	movl	_puiADC0StartPtr, %edx
	movl	_sequence, %eax
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	$1073971200, (%esp)
	call	_ADCSequenceDataGet
	.loc 1 155 0
	movl	_puiADC0StartPtr, %eax
	movl	_steplen, %edx
	sall	$2, %edx
	addl	%edx, %eax
	movl	%eax, _puiADC0StartPtr
	.loc 1 160 0
	movl	_puiADC0StartPtr, %edx
	movl	_puiADC0StopPtr, %eax
	cmpl	%eax, %edx
	jne	L15
	.loc 1 161 0
	movl	$_puiADC0Buffer, _puiADC0StartPtr
L15:
	.loc 1 166 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE8:
	.globl	_GetPeriod
	.def	_GetPeriod;	.scl	2;	.type	32;	.endef
_GetPeriod:
LFB9:
	.loc 1 171 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 1 172 0
	call	_SysCtlClockGet
	movl	$0, %edx
	divl	8(%ebp)
	.loc 1 173 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE9:
	.globl	_ConfigTimer0
	.def	_ConfigTimer0;	.scl	2;	.type	32;	.endef
_ConfigTimer0:
LFB10:
	.loc 1 181 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	.loc 1 185 0
	movl	$-268434432, (%esp)
	call	_ROM_SysCtlPeripheralEnable
	.loc 1 189 0
	movl	$50, 4(%esp)
	movl	$1073938432, (%esp)
	call	_ROM_TimerConfigure
	.loc 1 190 0
	movl	8(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$255, 4(%esp)
	movl	$1073938432, (%esp)
	call	_ROM_TimerLoadSet
	.loc 1 192 0
	movl	$1, 8(%esp)
	movl	$255, 4(%esp)
	movl	$1073938432, (%esp)
	call	_TimerControlTrigger
	.loc 1 196 0
	movl	$255, 4(%esp)
	movl	$1073938432, (%esp)
	call	_ROM_TimerEnable
	.loc 1 197 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE10:
	.section .rdata,"dr"
LC0:
	.ascii "ADC Acquire Start\12\0"
	.text
	.globl	_AcquireStart
	.def	_AcquireStart;	.scl	2;	.type	32;	.endef
_AcquireStart:
LFB11:
	.loc 1 205 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	.loc 1 209 0
	movl	$LC0, (%esp)
	call	_UARTprintf
	.loc 1 214 0
	movl	$-268421120, (%esp)
	call	_SysCtlPeripheralEnable
	.loc 1 219 0
	movl	$-268433404, (%esp)
	call	_SysCtlPeripheralEnable
	.loc 1 224 0
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	testl	%eax, %eax
	jne	L21
	.loc 1 225 0
	movl	$64, 4(%esp)
	movl	$1073889280, (%esp)
	call	_GPIOPinTypeADC
	jmp	L22
L21:
	.loc 1 226 0
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	cmpl	$1, %eax
	jne	L22
	.loc 1 227 0
	movl	$8, 4(%esp)
	movl	$1073889280, (%esp)
	call	_GPIOPinTypeADC
L22:
	.loc 1 233 0
	movl	$1, 4(%esp)
	movl	$1073971200, (%esp)
	call	_ADCReferenceSet
	.loc 1 239 0
	movl	$-268433407, (%esp)
	call	_SysCtlPeripheralEnable
	.loc 1 240 0
	movl	$1073763624, %eax
	movl	$1073763624, %edx
	movl	(%edx), %edx
	orl	$64, %edx
	movl	%edx, (%eax)
	.loc 1 248 0
	movl	_sequence, %eax
	movl	$3, 12(%esp)
	movl	$5, 8(%esp)
	movl	%eax, 4(%esp)
	movl	$1073971200, (%esp)
	call	_ADCSequenceConfigure
	.loc 1 249 0
	movl	_sequence, %eax
	movl	$_GetSampleISR, 8(%esp)
	movl	%eax, 4(%esp)
	movl	$1073971200, (%esp)
	call	_ADCIntRegister
	.loc 1 262 0
	movl	$0, -12(%ebp)
	.loc 1 263 0
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	testl	%eax, %eax
	jne	L23
	.loc 1 264 0
	movl	$261, -12(%ebp)
	jmp	L24
L23:
	.loc 1 265 0
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	cmpl	$1, %eax
	jne	L24
	.loc 1 266 0
	movl	$0, -12(%ebp)
L24:
	.loc 1 270 0
	movl	8(%ebp), %eax
	movl	4(%eax), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$5, %eax
	movl	%eax, _buffersize
LBB4:
	.loc 1 271 0
	movl	$0, -16(%ebp)
	jmp	L25
L27:
	.loc 1 272 0
	movl	-16(%ebp), %eax
	movl	_steplen, %edx
	subl	$1, %edx
	cmpl	%edx, %eax
	jne	L26
	.loc 1 273 0
	orl	$96, -12(%ebp)
L26:
	.loc 1 275 0
	movl	-16(%ebp), %edx
	movl	_sequence, %eax
	movl	-12(%ebp), %ecx
	movl	%ecx, 12(%esp)
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	$1073971200, (%esp)
	call	_ADCSequenceStepConfigure
	.loc 1 271 0
	addl	$1, -16(%ebp)
L25:
	.loc 1 271 0 is_stmt 0 discriminator 1
	movl	-16(%ebp), %edx
	movl	_steplen, %eax
	cmpl	%eax, %edx
	jb	L27
LBE4:
	.loc 1 281 0 is_stmt 1
	movl	_sequence, %eax
	movl	%eax, 4(%esp)
	movl	$1073971200, (%esp)
	call	_ADCSequenceEnable
	.loc 1 287 0
	movl	_sequence, %eax
	movl	%eax, 4(%esp)
	movl	$1073971200, (%esp)
	call	_ADCIntClear
	.loc 1 289 0
	movl	_sequence, %eax
	movl	%eax, 4(%esp)
	movl	$1073971200, (%esp)
	call	_ADCIntEnable
	.loc 1 290 0
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	_GetPeriod
	movl	%eax, (%esp)
	call	_ConfigTimer0
	.loc 1 291 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE11:
	.globl	_ReadAccel
	.def	_ReadAccel;	.scl	2;	.type	32;	.endef
_ReadAccel:
LFB12:
	.loc 1 294 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	.loc 1 295 0
	movl	8(%ebp), %eax
	imull	$2442, %eax, %eax
	leal	-5000000(%eax), %ecx
	movl	$1759218605, %edx
	movl	%ecx, %eax
	imull	%edx
	sarl	$12, %edx
	movl	%ecx, %eax
	sarl	$31, %eax
	subl	%eax, %edx
	movl	%edx, %eax
	.loc 1 296 0
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE12:
	.section .rdata,"dr"
LC1:
	.ascii "%d\0"
LC2:
	.ascii "\15\0"
	.text
	.globl	_AcquireMain
	.def	_AcquireMain;	.scl	2;	.type	32;	.endef
_AcquireMain:
LFB13:
	.loc 1 306 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	.loc 1 316 0
	movl	12(%ebp), %eax
	movl	%eax, _puiConfig
	.loc 1 318 0
	movl	$_puiADC0Buffer, _puiADC0StartPtr
	.loc 1 319 0
	movl	_puiConfig, %eax
	movl	4(%eax), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$5, %eax
	subl	$1, %eax
	sall	$2, %eax
	addl	$_puiADC0Buffer, %eax
	movl	%eax, _puiADC0StopPtr
	.loc 1 320 0
	movl	$0, _puiADC0BufferPtr
	.loc 1 321 0
	movl	_puiConfig, %eax
	movl	%eax, (%esp)
	call	_GetSequence
	movl	%eax, _sequence
	.loc 1 322 0
	movl	_sequence, %eax
	testl	%eax, %eax
	jne	L31
	.loc 1 322 0 is_stmt 0 discriminator 1
	movl	$8, %eax
	jmp	L32
L31:
	.loc 1 322 0 discriminator 2
	movl	$1, %eax
L32:
	.loc 1 322 0 discriminator 3
	movl	%eax, _steplen
	.loc 1 339 0 is_stmt 1 discriminator 3
	movl	_puiConfig, %eax
	movl	%eax, (%esp)
	call	_AcquireStart
L33:
LBB5:
	.loc 1 343 0
	movl	_puiConfig, %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_vPollSBoxButton
	.loc 1 344 0
	movl	_puiConfig, %eax
	movl	12(%eax), %eax
	.loc 1 348 0
	call	_ROM_IntMasterDisable
	.loc 1 349 0
	movl	_puiADC0StartPtr, %eax
	subl	$4, %eax
	movl	(%eax), %eax
	movl	%eax, 8(%esp)
	movl	$LC1, 4(%esp)
	leal	-13(%ebp), %eax
	movl	%eax, (%esp)
	call	_usprintf
	.loc 1 350 0
	call	_ROM_IntMasterEnable
	.loc 1 351 0
	leal	-13(%ebp), %eax
	movl	%eax, (%esp)
	call	_UARTprintf
	.loc 1 352 0
	movl	$LC2, (%esp)
	call	_UARTprintf
	.loc 1 385 0
	call	_SysCtlClockGet
	movl	$1374389535, %edx
	mull	%edx
	movl	%edx, %eax
	shrl	$5, %eax
	movl	%eax, (%esp)
	call	_SysCtlDelay
LBE5:
	.loc 1 386 0
	jmp	L33
	.cfi_endproc
LFE13:
	.globl	_StopDetection
	.def	_StopDetection;	.scl	2;	.type	32;	.endef
_StopDetection:
LFB14:
	.loc 1 393 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	.loc 1 395 0
	movl	$0, 8(%esp)
	movl	$255, 4(%esp)
	movl	$1073938432, (%esp)
	call	_TimerControlTrigger
	.loc 1 397 0
	movl	$3, 4(%esp)
	movl	$1073971200, (%esp)
	call	_ADCIntDisable
	.loc 1 399 0
	movl	$3, 4(%esp)
	movl	$1073971200, (%esp)
	call	_ADCIntUnregister
	.loc 1 401 0
	movl	$3, 4(%esp)
	movl	$1073971200, (%esp)
	call	_ADCSequenceDisable
	.loc 1 406 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE14:
	.globl	_first
	.data
_first:
	.byte	1
	.globl	_prev_value
	.bss
	.align 4
_prev_value:
	.space 4
	.section .rdata,"dr"
LC3:
	.ascii "Accel!\15\0"
LC4:
	.ascii "Volts!\15\0"
	.text
	.globl	_TriggerDetectISR
	.def	_TriggerDetectISR;	.scl	2;	.type	32;	.endef
_TriggerDetectISR:
LFB15:
	.loc 1 428 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	.loc 1 429 0
	movl	$3, 4(%esp)
	movl	$1073971200, (%esp)
	call	_ADCIntClear
	.loc 1 430 0
	movl	_tobedelted, %eax
	addl	$1, %eax
	movl	%eax, _tobedelted
	.loc 1 431 0
	movl	$_puiADC0Buffer, 8(%esp)
	movl	$3, 4(%esp)
	movl	$1073971200, (%esp)
	call	_ADCSequenceDataGet
	.loc 1 432 0
	movl	_puiConfig, %eax
	movl	8(%eax), %eax
	testl	%eax, %eax
	jne	L36
	.loc 1 433 0
	movzbl	_first, %eax
	testb	%al, %al
	je	L37
	.loc 1 434 0
	movb	$0, _first
	.loc 1 435 0
	movl	_puiADC0Buffer, %eax
	movl	%eax, (%esp)
	call	_ReadAccel
	movl	%eax, _prev_value
	jmp	L35
L37:
LBB6:
	.loc 1 437 0
	movl	_puiADC0Buffer, %eax
	movl	%eax, (%esp)
	call	_ReadAccel
	movl	%eax, -12(%ebp)
LBB7:
	.loc 1 438 0
	movl	_prev_value, %eax
	movl	-12(%ebp), %edx
	subl	%eax, %edx
	movl	%edx, %eax
	cltd
	xorl	%edx, %eax
	subl	%edx, %eax
	cmpl	$50, %eax
	jle	L39
	.loc 1 439 0
	movl	$LC3, (%esp)
	call	_UARTprintf
	.loc 1 441 0
	movzbl	_eventflags, %eax
	orl	$1, %eax
	movb	%al, _eventflags
	.loc 1 442 0
	call	_StopDetection
L39:
LBE7:
	.loc 1 444 0
	movl	-12(%ebp), %eax
	movl	%eax, _prev_value
	jmp	L35
L36:
LBE6:
	.loc 1 446 0
	movl	_puiConfig, %eax
	movl	8(%eax), %eax
	cmpl	$1, %eax
	jne	L35
	.loc 1 447 0
	movl	_puiADC0Buffer, %eax
	cmpl	$104, %eax
	jbe	L35
	.loc 1 448 0
	movl	$LC4, (%esp)
	call	_UARTprintf
	.loc 1 449 0
	movzbl	_eventflags, %eax
	orl	$1, %eax
	movb	%al, _eventflags
	.loc 1 450 0
	call	_StopDetection
L35:
	.loc 1 453 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE15:
	.globl	_AcquireInit
	.def	_AcquireInit;	.scl	2;	.type	32;	.endef
_AcquireInit:
LFB16:
	.loc 1 463 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	.loc 1 465 0
	movb	$0, _eventflags
	.loc 1 469 0
	movl	$-268421120, (%esp)
	call	_SysCtlPeripheralEnable
	.loc 1 475 0
	movl	$-268433404, (%esp)
	call	_SysCtlPeripheralEnable
	.loc 1 481 0
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	testl	%eax, %eax
	jne	L42
	.loc 1 482 0
	movl	$64, 4(%esp)
	movl	$1073889280, (%esp)
	call	_GPIOPinTypeADC
	jmp	L43
L42:
	.loc 1 483 0
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	cmpl	$1, %eax
	jne	L43
	.loc 1 484 0
	movl	$8, 4(%esp)
	movl	$1073889280, (%esp)
	call	_GPIOPinTypeADC
L43:
	.loc 1 490 0
	movl	$1, 4(%esp)
	movl	$1073971200, (%esp)
	call	_ADCReferenceSet
	.loc 1 496 0
	movl	$-268433407, (%esp)
	call	_SysCtlPeripheralEnable
	.loc 1 497 0
	movl	$1073763624, %eax
	movl	$1073763624, %edx
	movl	(%edx), %edx
	orl	$64, %edx
	movl	%edx, (%eax)
	.loc 1 504 0
	movl	$3, 12(%esp)
	movl	$5, 8(%esp)
	movl	$3, 4(%esp)
	movl	$1073971200, (%esp)
	call	_ADCSequenceConfigure
	.loc 1 506 0
	movl	$_TriggerDetectISR, 8(%esp)
	movl	$3, 4(%esp)
	movl	$1073971200, (%esp)
	call	_ADCIntRegister
	.loc 1 510 0
	movl	$0, -12(%ebp)
	.loc 1 511 0
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	testl	%eax, %eax
	jne	L44
	.loc 1 512 0
	movl	$261, -12(%ebp)
	jmp	L45
L44:
	.loc 1 513 0
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	cmpl	$1, %eax
	jne	L45
	.loc 1 514 0
	movl	$0, -12(%ebp)
L45:
	.loc 1 527 0
	movl	-12(%ebp), %eax
	orl	$96, %eax
	movl	%eax, 12(%esp)
	movl	$0, 8(%esp)
	movl	$3, 4(%esp)
	movl	$1073971200, (%esp)
	call	_ADCSequenceStepConfigure
	.loc 1 532 0
	movl	$3, 4(%esp)
	movl	$1073971200, (%esp)
	call	_ADCSequenceEnable
	.loc 1 538 0
	movl	$3, 4(%esp)
	movl	$1073971200, (%esp)
	call	_ADCIntClear
	.loc 1 540 0
	movl	$3, 4(%esp)
	movl	$1073971200, (%esp)
	call	_ADCIntEnable
	.loc 1 542 0
	call	_SysCtlClockGet
	movl	$-858993459, %edx
	mull	%edx
	movl	%edx, %eax
	shrl	$3, %eax
	movl	%eax, (%esp)
	call	_ConfigTimer0
	.loc 1 543 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE16:
Letext0:
	.file 2 "/usr/include/stdint.h"
	.file 3 "../../../../grlib/grlib.h"
	.file 4 "uicontrol.h"
	.file 5 "<built-in>"
	.section	.debug_info,"dr"
Ldebug_info0:
	.long	0xc82
	.word	0x4
	.secrel32	Ldebug_abbrev0
	.byte	0x4
	.uleb128 0x1
	.ascii "GNU C 4.8.2 -mtune=generic -march=i686 -g -std=c99\0"
	.byte	0x1
	.ascii "acquire.c\0"
	.ascii "/cygdrive/c/emsys/TivaC1157/examples/boards/ek-lm4f232/exercise2\0"
	.long	Ltext0
	.long	Letext0-Ltext0
	.secrel32	Ldebug_line0
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.ascii "signed char\0"
	.uleb128 0x3
	.ascii "int16_t\0"
	.byte	0x2
	.byte	0x15
	.long	0xb5
	.uleb128 0x2
	.byte	0x2
	.byte	0x5
	.ascii "short int\0"
	.uleb128 0x3
	.ascii "int32_t\0"
	.byte	0x2
	.byte	0x16
	.long	0xd1
	.uleb128 0x2
	.byte	0x4
	.byte	0x5
	.ascii "int\0"
	.uleb128 0x2
	.byte	0x8
	.byte	0x5
	.ascii "long long int\0"
	.uleb128 0x3
	.ascii "uint8_t\0"
	.byte	0x2
	.byte	0x1e
	.long	0xf8
	.uleb128 0x2
	.byte	0x1
	.byte	0x8
	.ascii "unsigned char\0"
	.uleb128 0x3
	.ascii "uint16_t\0"
	.byte	0x2
	.byte	0x1f
	.long	0x119
	.uleb128 0x2
	.byte	0x2
	.byte	0x7
	.ascii "short unsigned int\0"
	.uleb128 0x3
	.ascii "uint32_t\0"
	.byte	0x2
	.byte	0x22
	.long	0x13f
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.ascii "unsigned int\0"
	.uleb128 0x2
	.byte	0x8
	.byte	0x7
	.ascii "long long unsigned int\0"
	.uleb128 0x4
	.byte	0x8
	.byte	0x3
	.byte	0x36
	.long	0x1b2
	.uleb128 0x5
	.ascii "i16XMin\0"
	.byte	0x3
	.byte	0x3b
	.long	0xa6
	.byte	0
	.uleb128 0x5
	.ascii "i16YMin\0"
	.byte	0x3
	.byte	0x40
	.long	0xa6
	.byte	0x2
	.uleb128 0x5
	.ascii "i16XMax\0"
	.byte	0x3
	.byte	0x45
	.long	0xa6
	.byte	0x4
	.uleb128 0x5
	.ascii "i16YMax\0"
	.byte	0x3
	.byte	0x4a
	.long	0xa6
	.byte	0x6
	.byte	0
	.uleb128 0x3
	.ascii "tRectangle\0"
	.byte	0x3
	.byte	0x4c
	.long	0x169
	.uleb128 0x4
	.byte	0x28
	.byte	0x3
	.byte	0x53
	.long	0x2b3
	.uleb128 0x5
	.ascii "i32Size\0"
	.byte	0x3
	.byte	0x58
	.long	0xc2
	.byte	0
	.uleb128 0x5
	.ascii "pvDisplayData\0"
	.byte	0x3
	.byte	0x5d
	.long	0x2b3
	.byte	0x4
	.uleb128 0x5
	.ascii "ui16Width\0"
	.byte	0x3
	.byte	0x62
	.long	0x109
	.byte	0x8
	.uleb128 0x5
	.ascii "ui16Height\0"
	.byte	0x3
	.byte	0x67
	.long	0x109
	.byte	0xa
	.uleb128 0x5
	.ascii "pfnPixelDraw\0"
	.byte	0x3
	.byte	0x6c
	.long	0x2cf
	.byte	0xc
	.uleb128 0x5
	.ascii "pfnPixelDrawMultiple\0"
	.byte	0x3
	.byte	0x75
	.long	0x30e
	.byte	0x10
	.uleb128 0x5
	.ascii "pfnLineDrawH\0"
	.byte	0x3
	.byte	0x7e
	.long	0x333
	.byte	0x14
	.uleb128 0x5
	.ascii "pfnLineDrawV\0"
	.byte	0x3
	.byte	0x84
	.long	0x333
	.byte	0x18
	.uleb128 0x5
	.ascii "pfnRectFill\0"
	.byte	0x3
	.byte	0x8a
	.long	0x359
	.byte	0x1c
	.uleb128 0x5
	.ascii "pfnColorTranslate\0"
	.byte	0x3
	.byte	0x91
	.long	0x373
	.byte	0x20
	.uleb128 0x5
	.ascii "pfnFlush\0"
	.byte	0x3
	.byte	0x97
	.long	0x384
	.byte	0x24
	.byte	0
	.uleb128 0x6
	.byte	0x4
	.uleb128 0x7
	.long	0x2cf
	.uleb128 0x8
	.long	0x2b3
	.uleb128 0x8
	.long	0xc2
	.uleb128 0x8
	.long	0xc2
	.uleb128 0x8
	.long	0x12f
	.byte	0
	.uleb128 0x9
	.byte	0x4
	.long	0x2b5
	.uleb128 0x7
	.long	0x303
	.uleb128 0x8
	.long	0x2b3
	.uleb128 0x8
	.long	0xc2
	.uleb128 0x8
	.long	0xc2
	.uleb128 0x8
	.long	0xc2
	.uleb128 0x8
	.long	0xc2
	.uleb128 0x8
	.long	0xc2
	.uleb128 0x8
	.long	0x303
	.uleb128 0x8
	.long	0x303
	.byte	0
	.uleb128 0x9
	.byte	0x4
	.long	0x309
	.uleb128 0xa
	.long	0xe9
	.uleb128 0x9
	.byte	0x4
	.long	0x2d5
	.uleb128 0x7
	.long	0x333
	.uleb128 0x8
	.long	0x2b3
	.uleb128 0x8
	.long	0xc2
	.uleb128 0x8
	.long	0xc2
	.uleb128 0x8
	.long	0xc2
	.uleb128 0x8
	.long	0x12f
	.byte	0
	.uleb128 0x9
	.byte	0x4
	.long	0x314
	.uleb128 0x7
	.long	0x34e
	.uleb128 0x8
	.long	0x2b3
	.uleb128 0x8
	.long	0x34e
	.uleb128 0x8
	.long	0x12f
	.byte	0
	.uleb128 0x9
	.byte	0x4
	.long	0x354
	.uleb128 0xa
	.long	0x1b2
	.uleb128 0x9
	.byte	0x4
	.long	0x339
	.uleb128 0xb
	.long	0x12f
	.long	0x373
	.uleb128 0x8
	.long	0x2b3
	.uleb128 0x8
	.long	0x12f
	.byte	0
	.uleb128 0x9
	.byte	0x4
	.long	0x35f
	.uleb128 0x7
	.long	0x384
	.uleb128 0x8
	.long	0x2b3
	.byte	0
	.uleb128 0x9
	.byte	0x4
	.long	0x379
	.uleb128 0x3
	.ascii "tDisplay\0"
	.byte	0x3
	.byte	0x99
	.long	0x1c4
	.uleb128 0x4
	.byte	0xc8
	.byte	0x3
	.byte	0xae
	.long	0x414
	.uleb128 0x5
	.ascii "ui8Format\0"
	.byte	0x3
	.byte	0xb4
	.long	0xe9
	.byte	0
	.uleb128 0x5
	.ascii "ui8MaxWidth\0"
	.byte	0x3
	.byte	0xbb
	.long	0xe9
	.byte	0x1
	.uleb128 0x5
	.ascii "ui8Height\0"
	.byte	0x3
	.byte	0xc1
	.long	0xe9
	.byte	0x2
	.uleb128 0x5
	.ascii "ui8Baseline\0"
	.byte	0x3
	.byte	0xc8
	.long	0xe9
	.byte	0x3
	.uleb128 0x5
	.ascii "pui16Offset\0"
	.byte	0x3
	.byte	0xcd
	.long	0x414
	.byte	0x4
	.uleb128 0x5
	.ascii "pui8Data\0"
	.byte	0x3
	.byte	0xd2
	.long	0x303
	.byte	0xc4
	.byte	0
	.uleb128 0xc
	.long	0x109
	.long	0x424
	.uleb128 0xd
	.long	0x424
	.byte	0x5f
	.byte	0
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.ascii "sizetype\0"
	.uleb128 0x3
	.ascii "tFont\0"
	.byte	0x3
	.byte	0xd4
	.long	0x39a
	.uleb128 0x9
	.byte	0x4
	.long	0x12f
	.uleb128 0xe
	.byte	0x8
	.byte	0x3
	.word	0x2e2
	.long	0x494
	.uleb128 0xf
	.ascii "ui16SrcCodepage\0"
	.byte	0x3
	.word	0x2e7
	.long	0x109
	.byte	0
	.uleb128 0xf
	.ascii "ui16FontCodepage\0"
	.byte	0x3
	.word	0x2ec
	.long	0x109
	.byte	0x2
	.uleb128 0xf
	.ascii "pfnMapChar\0"
	.byte	0x3
	.word	0x2f2
	.long	0x4c0
	.byte	0x4
	.byte	0
	.uleb128 0xb
	.long	0x12f
	.long	0x4ad
	.uleb128 0x8
	.long	0x4ad
	.uleb128 0x8
	.long	0x12f
	.uleb128 0x8
	.long	0x43d
	.byte	0
	.uleb128 0x9
	.byte	0x4
	.long	0x4b3
	.uleb128 0xa
	.long	0x4b8
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.ascii "char\0"
	.uleb128 0x9
	.byte	0x4
	.long	0x494
	.uleb128 0x10
	.ascii "tCodePointMap\0"
	.byte	0x3
	.word	0x2f5
	.long	0x443
	.uleb128 0x9
	.byte	0x4
	.long	0x4e2
	.uleb128 0x7
	.long	0x506
	.uleb128 0x8
	.long	0x506
	.uleb128 0x8
	.long	0x4ad
	.uleb128 0x8
	.long	0xc2
	.uleb128 0x8
	.long	0xc2
	.uleb128 0x8
	.long	0xc2
	.uleb128 0x8
	.long	0x636
	.byte	0
	.uleb128 0x9
	.byte	0x4
	.long	0x50c
	.uleb128 0xa
	.long	0x511
	.uleb128 0x11
	.ascii "_tContext\0"
	.byte	0x2c
	.byte	0x3
	.word	0x33f
	.long	0x636
	.uleb128 0xf
	.ascii "i32Size\0"
	.byte	0x3
	.word	0x345
	.long	0xc2
	.byte	0
	.uleb128 0xf
	.ascii "psDisplay\0"
	.byte	0x3
	.word	0x34a
	.long	0x63f
	.byte	0x4
	.uleb128 0xf
	.ascii "sClipRegion\0"
	.byte	0x3
	.word	0x34f
	.long	0x1b2
	.byte	0x8
	.uleb128 0xf
	.ascii "ui32Foreground\0"
	.byte	0x3
	.word	0x354
	.long	0x12f
	.byte	0x10
	.uleb128 0xf
	.ascii "ui32Background\0"
	.byte	0x3
	.word	0x359
	.long	0x12f
	.byte	0x14
	.uleb128 0xf
	.ascii "psFont\0"
	.byte	0x3
	.word	0x35e
	.long	0x64a
	.byte	0x18
	.uleb128 0xf
	.ascii "pfnStringRenderer\0"
	.byte	0x3
	.word	0x366
	.long	0x4dc
	.byte	0x1c
	.uleb128 0xf
	.ascii "pCodePointMapTable\0"
	.byte	0x3
	.word	0x36d
	.long	0x655
	.byte	0x20
	.uleb128 0xf
	.ascii "ui16Codepage\0"
	.byte	0x3
	.word	0x372
	.long	0x109
	.byte	0x24
	.uleb128 0xf
	.ascii "ui8NumCodePointMaps\0"
	.byte	0x3
	.word	0x377
	.long	0xe9
	.byte	0x26
	.uleb128 0xf
	.ascii "ui8CodePointMap\0"
	.byte	0x3
	.word	0x37d
	.long	0xe9
	.byte	0x27
	.uleb128 0xf
	.ascii "ui8Reserved\0"
	.byte	0x3
	.word	0x382
	.long	0xe9
	.byte	0x28
	.byte	0
	.uleb128 0x2
	.byte	0x1
	.byte	0x2
	.ascii "_Bool\0"
	.uleb128 0x9
	.byte	0x4
	.long	0x645
	.uleb128 0xa
	.long	0x38a
	.uleb128 0x9
	.byte	0x4
	.long	0x650
	.uleb128 0xa
	.long	0x430
	.uleb128 0x9
	.byte	0x4
	.long	0x65b
	.uleb128 0xa
	.long	0x4c6
	.uleb128 0x10
	.ascii "tContext\0"
	.byte	0x3
	.word	0x385
	.long	0x511
	.uleb128 0x2
	.byte	0x4
	.byte	0x5
	.ascii "long int\0"
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.ascii "long unsigned int\0"
	.uleb128 0x12
	.byte	0x4
	.byte	0x4
	.byte	0x24
	.long	0x6ac
	.uleb128 0x13
	.ascii "idle\0"
	.sleb128 0
	.uleb128 0x13
	.ascii "logging\0"
	.sleb128 1
	.byte	0
	.uleb128 0x3
	.ascii "uiState_t\0"
	.byte	0x4
	.byte	0x24
	.long	0x692
	.uleb128 0x14
	.secrel32	LASF0
	.byte	0x4
	.byte	0x4
	.byte	0x25
	.long	0x6da
	.uleb128 0x13
	.ascii "ACCEL\0"
	.sleb128 0
	.uleb128 0x13
	.ascii "VOLTS\0"
	.sleb128 1
	.byte	0
	.uleb128 0x15
	.secrel32	LASF0
	.byte	0x4
	.byte	0x25
	.long	0x6bd
	.uleb128 0x16
	.ascii "tsOpt\0"
	.byte	0x10
	.byte	0x4
	.byte	0x27
	.long	0x738
	.uleb128 0x5
	.ascii "freq\0"
	.byte	0x4
	.byte	0x29
	.long	0x12f
	.byte	0
	.uleb128 0x5
	.ascii "sample_size\0"
	.byte	0x4
	.byte	0x2a
	.long	0x12f
	.byte	0x4
	.uleb128 0x5
	.ascii "channelOpt\0"
	.byte	0x4
	.byte	0x2b
	.long	0x6da
	.byte	0x8
	.uleb128 0x5
	.ascii "uiState\0"
	.byte	0x4
	.byte	0x2c
	.long	0x6ac
	.byte	0xc
	.byte	0
	.uleb128 0x3
	.ascii "tuiConfig\0"
	.byte	0x4
	.byte	0x2d
	.long	0x6e5
	.uleb128 0x17
	.ascii "computeSample\0"
	.byte	0x1
	.byte	0x5c
	.long	LFB6
	.long	LFE6-LFB6
	.uleb128 0x1
	.byte	0x9c
	.long	0x7da
	.uleb128 0x18
	.secrel32	LASF1
	.byte	0x1
	.byte	0x5c
	.long	0x7da
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x19
	.ascii "size\0"
	.byte	0x1
	.byte	0x5f
	.long	0xd1
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x1a
	.long	LBB2
	.long	LBE2-LBB2
	.long	0x7c3
	.uleb128 0x1b
	.secrel32	LASF2
	.byte	0x1
	.byte	0x61
	.long	0xd1
	.long	0x7a3
	.uleb128 0x1c
	.byte	0
	.uleb128 0x19
	.ascii "pointer\0"
	.byte	0x1
	.byte	0x62
	.long	0xd1
	.uleb128 0x2
	.byte	0x91
	.sleb128 -28
	.uleb128 0x1d
	.secrel32	LASF3
	.byte	0x1
	.byte	0x63
	.long	0xd1
	.uleb128 0x1c
	.byte	0
	.byte	0
	.uleb128 0x1e
	.long	LBB3
	.long	LBE3-LBB3
	.uleb128 0x19
	.ascii "i\0"
	.byte	0x1
	.byte	0x72
	.long	0xd1
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.byte	0
	.byte	0
	.uleb128 0x9
	.byte	0x4
	.long	0x738
	.uleb128 0x1f
	.ascii "GetSequence\0"
	.byte	0x1
	.byte	0x8b
	.long	0x12f
	.long	LFB7
	.long	LFE7-LFB7
	.uleb128 0x1
	.byte	0x9c
	.long	0x810
	.uleb128 0x18
	.secrel32	LASF1
	.byte	0x1
	.byte	0x8b
	.long	0x7da
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.byte	0
	.uleb128 0x20
	.ascii "GetSampleISR\0"
	.byte	0x1
	.byte	0x97
	.long	LFB8
	.long	LFE8-LFB8
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x21
	.ascii "GetPeriod\0"
	.byte	0x1
	.byte	0xab
	.long	0x12f
	.long	LFB9
	.long	LFE9-LFB9
	.uleb128 0x1
	.byte	0x9c
	.long	0x859
	.uleb128 0x22
	.ascii "freq\0"
	.byte	0x1
	.byte	0xab
	.long	0x12f
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.byte	0
	.uleb128 0x17
	.ascii "ConfigTimer0\0"
	.byte	0x1
	.byte	0xb5
	.long	LFB10
	.long	LFE10-LFB10
	.uleb128 0x1
	.byte	0x9c
	.long	0x908
	.uleb128 0x22
	.ascii "period\0"
	.byte	0x1
	.byte	0xb5
	.long	0x12f
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x23
	.ascii "ROM_SysCtlPeripheralEnable\0"
	.byte	0x1
	.byte	0xb9
	.long	0xd1
	.long	0x8b0
	.uleb128 0x1c
	.byte	0
	.uleb128 0x23
	.ascii "ROM_TimerConfigure\0"
	.byte	0x1
	.byte	0xbd
	.long	0xd1
	.long	0x8d0
	.uleb128 0x1c
	.byte	0
	.uleb128 0x23
	.ascii "ROM_TimerLoadSet\0"
	.byte	0x1
	.byte	0xbe
	.long	0xd1
	.long	0x8ee
	.uleb128 0x1c
	.byte	0
	.uleb128 0x24
	.ascii "ROM_TimerEnable\0"
	.byte	0x1
	.byte	0xc4
	.long	0xd1
	.uleb128 0x1c
	.byte	0
	.byte	0
	.uleb128 0x17
	.ascii "AcquireStart\0"
	.byte	0x1
	.byte	0xcd
	.long	LFB11
	.long	LFE11-LFB11
	.uleb128 0x1
	.byte	0x9c
	.long	0x961
	.uleb128 0x18
	.secrel32	LASF1
	.byte	0x1
	.byte	0xcd
	.long	0x7da
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x25
	.ascii "config\0"
	.byte	0x1
	.word	0x106
	.long	0x12f
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x1e
	.long	LBB4
	.long	LBE4-LBB4
	.uleb128 0x25
	.ascii "step\0"
	.byte	0x1
	.word	0x10f
	.long	0xd1
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.byte	0
	.byte	0
	.uleb128 0x26
	.ascii "ReadAccel\0"
	.byte	0x1
	.word	0x126
	.long	0xd1
	.long	LFB12
	.long	LFE12-LFB12
	.uleb128 0x1
	.byte	0x9c
	.long	0x993
	.uleb128 0x27
	.ascii "value\0"
	.byte	0x1
	.word	0x126
	.long	0x12f
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.byte	0
	.uleb128 0x28
	.ascii "AcquireMain\0"
	.byte	0x1
	.word	0x132
	.long	LFB13
	.long	LFE13-LFB13
	.uleb128 0x1
	.byte	0x9c
	.long	0xa14
	.uleb128 0x27
	.ascii "pContext\0"
	.byte	0x1
	.word	0x132
	.long	0xa14
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x27
	.ascii "puiConfig_t\0"
	.byte	0x1
	.word	0x132
	.long	0x7da
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0x25
	.ascii "str\0"
	.byte	0x1
	.word	0x154
	.long	0xa1a
	.uleb128 0x2
	.byte	0x91
	.sleb128 -21
	.uleb128 0x1e
	.long	LBB5
	.long	LBE5-LBB5
	.uleb128 0x1b
	.secrel32	LASF2
	.byte	0x1
	.byte	0x61
	.long	0xd1
	.long	0xa05
	.uleb128 0x1c
	.byte	0
	.uleb128 0x1d
	.secrel32	LASF3
	.byte	0x1
	.byte	0x63
	.long	0xd1
	.uleb128 0x1c
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x9
	.byte	0x4
	.long	0x660
	.uleb128 0xc
	.long	0x4b8
	.long	0xa2a
	.uleb128 0xd
	.long	0x424
	.byte	0x4
	.byte	0
	.uleb128 0x29
	.ascii "StopDetection\0"
	.byte	0x1
	.word	0x189
	.long	LFB14
	.long	LFE14-LFB14
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x2a
	.ascii "TriggerDetectISR\0"
	.byte	0x1
	.word	0x1ac
	.long	LFB15
	.long	LFE15-LFB15
	.uleb128 0x1
	.byte	0x9c
	.long	0xaa1
	.uleb128 0x1e
	.long	LBB6
	.long	LBE6-LBB6
	.uleb128 0x25
	.ascii "curr_value\0"
	.byte	0x1
	.word	0x1b5
	.long	0xd1
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x1e
	.long	LBB7
	.long	LBE7-LBB7
	.uleb128 0x24
	.ascii "abs\0"
	.byte	0x5
	.byte	0
	.long	0xd1
	.uleb128 0x1c
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x28
	.ascii "AcquireInit\0"
	.byte	0x1
	.word	0x1cf
	.long	LFB16
	.long	LFE16-LFB16
	.uleb128 0x1
	.byte	0x9c
	.long	0xae1
	.uleb128 0x2b
	.secrel32	LASF1
	.byte	0x1
	.word	0x1cf
	.long	0x7da
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x25
	.ascii "config\0"
	.byte	0x1
	.word	0x1fe
	.long	0x12f
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.byte	0
	.uleb128 0xc
	.long	0x12f
	.long	0xaf2
	.uleb128 0x2c
	.long	0x424
	.word	0xbff
	.byte	0
	.uleb128 0x2d
	.ascii "puiADC0Buffer\0"
	.byte	0x1
	.byte	0x29
	.long	0xae1
	.uleb128 0x5
	.byte	0x3
	.long	_puiADC0Buffer
	.uleb128 0x2d
	.ascii "puiADC0StartPtr\0"
	.byte	0x1
	.byte	0x2e
	.long	0xb2a
	.uleb128 0x5
	.byte	0x3
	.long	_puiADC0StartPtr
	.uleb128 0x9
	.byte	0x4
	.long	0xb30
	.uleb128 0x2e
	.long	0x12f
	.uleb128 0x2d
	.ascii "puiADC0StopPtr\0"
	.byte	0x1
	.byte	0x2f
	.long	0xb2a
	.uleb128 0x5
	.byte	0x3
	.long	_puiADC0StopPtr
	.uleb128 0x2d
	.ascii "puiADC0BufferPtr\0"
	.byte	0x1
	.byte	0x31
	.long	0xb6f
	.uleb128 0x5
	.byte	0x3
	.long	_puiADC0BufferPtr
	.uleb128 0x2e
	.long	0xd1
	.uleb128 0x2d
	.ascii "eventflags\0"
	.byte	0x1
	.byte	0x3d
	.long	0xb8c
	.uleb128 0x5
	.byte	0x3
	.long	_eventflags
	.uleb128 0x2e
	.long	0xe9
	.uleb128 0x2d
	.ascii "buffersize\0"
	.byte	0x1
	.byte	0x44
	.long	0xb30
	.uleb128 0x5
	.byte	0x3
	.long	_buffersize
	.uleb128 0x2d
	.ascii "sequence\0"
	.byte	0x1
	.byte	0x45
	.long	0xb30
	.uleb128 0x5
	.byte	0x3
	.long	_sequence
	.uleb128 0x2d
	.ascii "steplen\0"
	.byte	0x1
	.byte	0x46
	.long	0xb30
	.uleb128 0x5
	.byte	0x3
	.long	_steplen
	.uleb128 0xc
	.long	0x12f
	.long	0xbe4
	.uleb128 0xd
	.long	0x424
	.byte	0x2
	.byte	0
	.uleb128 0x2d
	.ascii "datapoints\0"
	.byte	0x1
	.byte	0x4c
	.long	0xbd4
	.uleb128 0x5
	.byte	0x3
	.long	_datapoints
	.uleb128 0x2d
	.ascii "p_processingPtr\0"
	.byte	0x1
	.byte	0x51
	.long	0xb6f
	.uleb128 0x5
	.byte	0x3
	.long	_p_processingPtr
	.uleb128 0x2d
	.ascii "puiConfig\0"
	.byte	0x1
	.byte	0x55
	.long	0xc30
	.uleb128 0x5
	.byte	0x3
	.long	_puiConfig
	.uleb128 0x9
	.byte	0x4
	.long	0xc36
	.uleb128 0x2e
	.long	0x738
	.uleb128 0x2d
	.ascii "tobedelted\0"
	.byte	0x1
	.byte	0x91
	.long	0xb30
	.uleb128 0x5
	.byte	0x3
	.long	_tobedelted
	.uleb128 0x2f
	.ascii "first\0"
	.byte	0x1
	.word	0x19f
	.long	0xc67
	.uleb128 0x5
	.byte	0x3
	.long	_first
	.uleb128 0x2e
	.long	0x636
	.uleb128 0x2f
	.ascii "prev_value\0"
	.byte	0x1
	.word	0x1a4
	.long	0xb6f
	.uleb128 0x5
	.byte	0x3
	.long	_prev_value
	.byte	0
	.section	.debug_abbrev,"dr"
Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0x8
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x1b
	.uleb128 0x8
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x10
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0x13
	.byte	0x1
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0x15
	.byte	0x1
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0x5
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0x26
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0x15
	.byte	0x1
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xc
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xd
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xe
	.uleb128 0x13
	.byte	0x1
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xf
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x10
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x11
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x12
	.uleb128 0x4
	.byte	0x1
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x13
	.uleb128 0x28
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x1c
	.uleb128 0xd
	.byte	0
	.byte	0
	.uleb128 0x14
	.uleb128 0x4
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x15
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x16
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x17
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2116
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x18
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x19
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x1a
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1b
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1c
	.uleb128 0x18
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x1d
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x1e
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.byte	0
	.byte	0
	.uleb128 0x1f
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2117
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x20
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2116
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x21
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2116
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x22
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x23
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x24
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x25
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x26
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2117
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x27
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x28
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2116
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x29
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2116
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x2a
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2116
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x2b
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x2c
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0x5
	.byte	0
	.byte	0
	.uleb128 0x2d
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x2e
	.uleb128 0x35
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x2f
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_aranges,"dr"
	.long	0x1c
	.word	0x2
	.secrel32	Ldebug_info0
	.byte	0x4
	.byte	0
	.word	0
	.word	0
	.long	Ltext0
	.long	Letext0-Ltext0
	.long	0
	.long	0
	.section	.debug_line,"dr"
Ldebug_line0:
	.section	.debug_str,"dr"
LASF0:
	.ascii "channel_enum\0"
LASF1:
	.ascii "p_uiConfig\0"
LASF2:
	.ascii "ROM_IntMasterDisable\0"
LASF3:
	.ascii "ROM_IntMasterEnable\0"
	.ident	"GCC: (GNU) 4.8.2"
	.def	_ROM_IntMasterDisable;	.scl	2;	.type	32;	.endef
	.def	_ROM_IntMasterEnable;	.scl	2;	.type	32;	.endef
	.def	_SysCtlDelay;	.scl	2;	.type	32;	.endef
	.def	_ADCIntClear;	.scl	2;	.type	32;	.endef
	.def	_ADCSequenceDataGet;	.scl	2;	.type	32;	.endef
	.def	_SysCtlClockGet;	.scl	2;	.type	32;	.endef
	.def	_ROM_SysCtlPeripheralEnable;	.scl	2;	.type	32;	.endef
	.def	_ROM_TimerConfigure;	.scl	2;	.type	32;	.endef
	.def	_ROM_TimerLoadSet;	.scl	2;	.type	32;	.endef
	.def	_TimerControlTrigger;	.scl	2;	.type	32;	.endef
	.def	_ROM_TimerEnable;	.scl	2;	.type	32;	.endef
	.def	_UARTprintf;	.scl	2;	.type	32;	.endef
	.def	_SysCtlPeripheralEnable;	.scl	2;	.type	32;	.endef
	.def	_GPIOPinTypeADC;	.scl	2;	.type	32;	.endef
	.def	_ADCReferenceSet;	.scl	2;	.type	32;	.endef
	.def	_ADCSequenceConfigure;	.scl	2;	.type	32;	.endef
	.def	_ADCIntRegister;	.scl	2;	.type	32;	.endef
	.def	_ADCSequenceStepConfigure;	.scl	2;	.type	32;	.endef
	.def	_ADCSequenceEnable;	.scl	2;	.type	32;	.endef
	.def	_ADCIntEnable;	.scl	2;	.type	32;	.endef
	.def	_vPollSBoxButton;	.scl	2;	.type	32;	.endef
	.def	_usprintf;	.scl	2;	.type	32;	.endef
	.def	_ADCIntDisable;	.scl	2;	.type	32;	.endef
	.def	_ADCIntUnregister;	.scl	2;	.type	32;	.endef
	.def	_ADCSequenceDisable;	.scl	2;	.type	32;	.endef
