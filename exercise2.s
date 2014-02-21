	.file	"exercise2.c"
	.text
Ltext0:
	.comm	_g_ui32Flags, 4, 2
	.globl	_current_time
	.bss
	.align 4
_current_time:
	.space 4
	.globl	_systick_period
	.section .rdata,"dr"
	.align 4
_systick_period:
	.long	6550
	.data
	.align 4
_uiConfig:
	.long	10
	.long	1
	.long	0
	.long	0
	.text
	.globl	_ConfigureUART
	.def	_ConfigureUART;	.scl	2;	.type	32;	.endef
_ConfigureUART:
LFB6:
	.file 1 "exercise2.c"
	.loc 1 121 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	.loc 1 125 0
	movl	$-268433408, (%esp)
	call	_ROM_SysCtlPeripheralEnable
	.loc 1 130 0
	movl	$-268429312, (%esp)
	call	_ROM_SysCtlPeripheralEnable
	.loc 1 135 0
	movl	$1, (%esp)
	call	_ROM_GPIOPinConfigure
	.loc 1 136 0
	movl	$1025, (%esp)
	call	_ROM_GPIOPinConfigure
	.loc 1 137 0
	movl	$3, 4(%esp)
	movl	$1073758208, (%esp)
	call	_ROM_GPIOPinTypeUART
	.loc 1 142 0
	movl	$5, 4(%esp)
	movl	$1073790976, (%esp)
	call	_UARTClockSourceSet
	.loc 1 147 0
	movl	$16000000, 8(%esp)
	movl	$115200, 4(%esp)
	movl	$0, (%esp)
	call	_UARTStdioConfig
	.loc 1 148 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE6:
	.globl	_SysTickIntHandler
	.def	_SysTickIntHandler;	.scl	2;	.type	32;	.endef
_SysTickIntHandler:
LFB7:
	.loc 1 156 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 1 157 0
	call	_ROM_IntMasterDisable
	.loc 1 158 0
	movl	$-536813552, %eax
	movl	(%eax), %eax
	.loc 1 159 0
	movl	_current_time, %eax
	addl	$1, %eax
	movl	%eax, _current_time
	.loc 1 160 0
	call	_ROM_IntMasterEnable
	.loc 1 161 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE7:
	.globl	_Timer0IntHandler
	.def	_Timer0IntHandler;	.scl	2;	.type	32;	.endef
_Timer0IntHandler:
LFB8:
	.loc 1 170 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	.loc 1 174 0
	movl	$1, 4(%esp)
	movl	$1073938432, (%esp)
	call	_ROM_TimerIntClear
	.loc 1 178 0
	movl	$_g_ui32Flags, %eax
	andl	$1048575, %eax
	sall	$5, %eax
	movl	%eax, %edx
	movl	$_g_ui32Flags, %eax
	andl	$-268435456, %eax
	orl	$33554432, %eax
	orl	%edx, %eax
	movl	$_g_ui32Flags, %edx
	andl	$1048575, %edx
	movl	%edx, %ecx
	sall	$5, %ecx
	movl	$_g_ui32Flags, %edx
	andl	$-268435456, %edx
	orl	$33554432, %edx
	orl	%ecx, %edx
	movl	(%edx), %edx
	xorl	$1, %edx
	movl	%edx, (%eax)
	.loc 1 179 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE8:
	.globl	_Timer1IntHandler
	.def	_Timer1IntHandler;	.scl	2;	.type	32;	.endef
_Timer1IntHandler:
LFB9:
	.loc 1 188 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	.loc 1 192 0
	movl	$1, 4(%esp)
	movl	$1073942528, (%esp)
	call	_ROM_TimerIntClear
	.loc 1 196 0
	movl	$_g_ui32Flags, %eax
	andl	$1048575, %eax
	sall	$5, %eax
	movl	%eax, %edx
	movl	$_g_ui32Flags, %eax
	andl	$-268435456, %eax
	orl	$33554436, %eax
	orl	%edx, %eax
	movl	$_g_ui32Flags, %edx
	andl	$1048575, %edx
	movl	%edx, %ecx
	sall	$5, %ecx
	movl	$_g_ui32Flags, %edx
	andl	$-268435456, %edx
	orl	$33554436, %edx
	orl	%ecx, %edx
	movl	(%edx), %edx
	xorl	$1, %edx
	movl	%edx, (%eax)
	.loc 1 198 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE9:
	.globl	_ConfigSysTick
	.def	_ConfigSysTick;	.scl	2;	.type	32;	.endef
_ConfigSysTick:
LFB10:
	.loc 1 207 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	.loc 1 211 0
	movl	$_SysTickIntHandler, (%esp)
	call	_SysTickIntRegister
	.loc 1 214 0
	movl	$96, 4(%esp)
	movl	$15, (%esp)
	call	_IntPrioritySet
	.loc 1 219 0
	call	_SysCtlClockGet
	movl	$1374389535, %edx
	mull	%edx
	movl	%edx, %eax
	shrl	$5, %eax
	movl	%eax, (%esp)
	call	_SysTickPeriodSet
	.loc 1 224 0
	call	_IntMasterEnable
	.loc 1 229 0
	call	_SysTickIntEnable
	.loc 1 234 0
	call	_SysTickEnable
	.loc 1 235 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE10:
	.def	___main;	.scl	2;	.type	32;	.endef
	.globl	_main
	.def	_main;	.scl	2;	.type	32;	.endef
_main:
LFB11:
	.loc 1 245 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	andl	$-16, %esp
	subl	$16, %esp
	.loc 1 245 0
	call	___main
	.loc 1 251 0
	movl	$29361472, (%esp)
	call	_ROM_SysCtlClockSet
	.loc 1 257 0
	call	_ConfigureUART
	.loc 1 259 0
	call	_CFAL96x64x16Init
	.loc 1 260 0
	call	_ButtonsInit
	.loc 1 265 0
	movl	$_g_sCFAL96x64x16, 4(%esp)
	movl	$_sDisplayContext.3260, (%esp)
	call	_GrContextInit
	.loc 1 268 0
	movl	$0, _uiConfig+12
	.loc 1 270 0
	movl	$_sDisplayContext.3260, (%esp)
	call	_vInitUI
L8:
	.loc 1 274 0
	movl	$_uiConfig, 4(%esp)
	movl	$_sDisplayContext.3260, (%esp)
	call	_vPollSBoxButton
	.loc 1 275 0
	movl	_uiConfig+12, %eax
	cmpl	$1, %eax
	jne	L7
	.loc 1 276 0
	movl	$_uiConfig, 4(%esp)
	movl	$_sDisplayContext.3260, (%esp)
	call	_AcquireMain
	.loc 1 279 0
	jmp	L8
L7:
	jmp	L8
	.cfi_endproc
LFE11:
.lcomm _sDisplayContext.3260,44,32
Letext0:
	.file 2 "/usr/include/stdint.h"
	.file 3 "../../../../grlib/grlib.h"
	.file 4 "uicontrol.h"
	.file 5 "../drivers/cfal96x64x16.h"
	.section	.debug_info,"dr"
Ldebug_info0:
	.long	0x987
	.word	0x4
	.secrel32	Ldebug_abbrev0
	.byte	0x4
	.uleb128 0x1
	.ascii "GNU C 4.8.2 -mtune=generic -march=i686 -g -std=c99\0"
	.byte	0x1
	.ascii "exercise2.c\0"
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
	.long	0xb7
	.uleb128 0x2
	.byte	0x2
	.byte	0x5
	.ascii "short int\0"
	.uleb128 0x3
	.ascii "int32_t\0"
	.byte	0x2
	.byte	0x16
	.long	0xd3
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
	.long	0xfa
	.uleb128 0x2
	.byte	0x1
	.byte	0x8
	.ascii "unsigned char\0"
	.uleb128 0x3
	.ascii "uint16_t\0"
	.byte	0x2
	.byte	0x1f
	.long	0x11b
	.uleb128 0x2
	.byte	0x2
	.byte	0x7
	.ascii "short unsigned int\0"
	.uleb128 0x3
	.ascii "uint32_t\0"
	.byte	0x2
	.byte	0x22
	.long	0x141
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
	.long	0x1b4
	.uleb128 0x5
	.ascii "i16XMin\0"
	.byte	0x3
	.byte	0x3b
	.long	0xa8
	.byte	0
	.uleb128 0x5
	.ascii "i16YMin\0"
	.byte	0x3
	.byte	0x40
	.long	0xa8
	.byte	0x2
	.uleb128 0x5
	.ascii "i16XMax\0"
	.byte	0x3
	.byte	0x45
	.long	0xa8
	.byte	0x4
	.uleb128 0x5
	.ascii "i16YMax\0"
	.byte	0x3
	.byte	0x4a
	.long	0xa8
	.byte	0x6
	.byte	0
	.uleb128 0x3
	.ascii "tRectangle\0"
	.byte	0x3
	.byte	0x4c
	.long	0x16b
	.uleb128 0x4
	.byte	0x28
	.byte	0x3
	.byte	0x53
	.long	0x2b5
	.uleb128 0x5
	.ascii "i32Size\0"
	.byte	0x3
	.byte	0x58
	.long	0xc4
	.byte	0
	.uleb128 0x5
	.ascii "pvDisplayData\0"
	.byte	0x3
	.byte	0x5d
	.long	0x2b5
	.byte	0x4
	.uleb128 0x5
	.ascii "ui16Width\0"
	.byte	0x3
	.byte	0x62
	.long	0x10b
	.byte	0x8
	.uleb128 0x5
	.ascii "ui16Height\0"
	.byte	0x3
	.byte	0x67
	.long	0x10b
	.byte	0xa
	.uleb128 0x5
	.ascii "pfnPixelDraw\0"
	.byte	0x3
	.byte	0x6c
	.long	0x2d1
	.byte	0xc
	.uleb128 0x5
	.ascii "pfnPixelDrawMultiple\0"
	.byte	0x3
	.byte	0x75
	.long	0x310
	.byte	0x10
	.uleb128 0x5
	.ascii "pfnLineDrawH\0"
	.byte	0x3
	.byte	0x7e
	.long	0x335
	.byte	0x14
	.uleb128 0x5
	.ascii "pfnLineDrawV\0"
	.byte	0x3
	.byte	0x84
	.long	0x335
	.byte	0x18
	.uleb128 0x5
	.ascii "pfnRectFill\0"
	.byte	0x3
	.byte	0x8a
	.long	0x35b
	.byte	0x1c
	.uleb128 0x5
	.ascii "pfnColorTranslate\0"
	.byte	0x3
	.byte	0x91
	.long	0x375
	.byte	0x20
	.uleb128 0x5
	.ascii "pfnFlush\0"
	.byte	0x3
	.byte	0x97
	.long	0x386
	.byte	0x24
	.byte	0
	.uleb128 0x6
	.byte	0x4
	.uleb128 0x7
	.long	0x2d1
	.uleb128 0x8
	.long	0x2b5
	.uleb128 0x8
	.long	0xc4
	.uleb128 0x8
	.long	0xc4
	.uleb128 0x8
	.long	0x131
	.byte	0
	.uleb128 0x9
	.byte	0x4
	.long	0x2b7
	.uleb128 0x7
	.long	0x305
	.uleb128 0x8
	.long	0x2b5
	.uleb128 0x8
	.long	0xc4
	.uleb128 0x8
	.long	0xc4
	.uleb128 0x8
	.long	0xc4
	.uleb128 0x8
	.long	0xc4
	.uleb128 0x8
	.long	0xc4
	.uleb128 0x8
	.long	0x305
	.uleb128 0x8
	.long	0x305
	.byte	0
	.uleb128 0x9
	.byte	0x4
	.long	0x30b
	.uleb128 0xa
	.long	0xeb
	.uleb128 0x9
	.byte	0x4
	.long	0x2d7
	.uleb128 0x7
	.long	0x335
	.uleb128 0x8
	.long	0x2b5
	.uleb128 0x8
	.long	0xc4
	.uleb128 0x8
	.long	0xc4
	.uleb128 0x8
	.long	0xc4
	.uleb128 0x8
	.long	0x131
	.byte	0
	.uleb128 0x9
	.byte	0x4
	.long	0x316
	.uleb128 0x7
	.long	0x350
	.uleb128 0x8
	.long	0x2b5
	.uleb128 0x8
	.long	0x350
	.uleb128 0x8
	.long	0x131
	.byte	0
	.uleb128 0x9
	.byte	0x4
	.long	0x356
	.uleb128 0xa
	.long	0x1b4
	.uleb128 0x9
	.byte	0x4
	.long	0x33b
	.uleb128 0xb
	.long	0x131
	.long	0x375
	.uleb128 0x8
	.long	0x2b5
	.uleb128 0x8
	.long	0x131
	.byte	0
	.uleb128 0x9
	.byte	0x4
	.long	0x361
	.uleb128 0x7
	.long	0x386
	.uleb128 0x8
	.long	0x2b5
	.byte	0
	.uleb128 0x9
	.byte	0x4
	.long	0x37b
	.uleb128 0x3
	.ascii "tDisplay\0"
	.byte	0x3
	.byte	0x99
	.long	0x1c6
	.uleb128 0x4
	.byte	0xc8
	.byte	0x3
	.byte	0xae
	.long	0x416
	.uleb128 0x5
	.ascii "ui8Format\0"
	.byte	0x3
	.byte	0xb4
	.long	0xeb
	.byte	0
	.uleb128 0x5
	.ascii "ui8MaxWidth\0"
	.byte	0x3
	.byte	0xbb
	.long	0xeb
	.byte	0x1
	.uleb128 0x5
	.ascii "ui8Height\0"
	.byte	0x3
	.byte	0xc1
	.long	0xeb
	.byte	0x2
	.uleb128 0x5
	.ascii "ui8Baseline\0"
	.byte	0x3
	.byte	0xc8
	.long	0xeb
	.byte	0x3
	.uleb128 0x5
	.ascii "pui16Offset\0"
	.byte	0x3
	.byte	0xcd
	.long	0x416
	.byte	0x4
	.uleb128 0x5
	.ascii "pui8Data\0"
	.byte	0x3
	.byte	0xd2
	.long	0x305
	.byte	0xc4
	.byte	0
	.uleb128 0xc
	.long	0x10b
	.long	0x426
	.uleb128 0xd
	.long	0x426
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
	.long	0x39c
	.uleb128 0x9
	.byte	0x4
	.long	0x131
	.uleb128 0xe
	.byte	0x8
	.byte	0x3
	.word	0x2e2
	.long	0x496
	.uleb128 0xf
	.ascii "ui16SrcCodepage\0"
	.byte	0x3
	.word	0x2e7
	.long	0x10b
	.byte	0
	.uleb128 0xf
	.ascii "ui16FontCodepage\0"
	.byte	0x3
	.word	0x2ec
	.long	0x10b
	.byte	0x2
	.uleb128 0xf
	.ascii "pfnMapChar\0"
	.byte	0x3
	.word	0x2f2
	.long	0x4c2
	.byte	0x4
	.byte	0
	.uleb128 0xb
	.long	0x131
	.long	0x4af
	.uleb128 0x8
	.long	0x4af
	.uleb128 0x8
	.long	0x131
	.uleb128 0x8
	.long	0x43f
	.byte	0
	.uleb128 0x9
	.byte	0x4
	.long	0x4b5
	.uleb128 0xa
	.long	0x4ba
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.ascii "char\0"
	.uleb128 0x9
	.byte	0x4
	.long	0x496
	.uleb128 0x10
	.ascii "tCodePointMap\0"
	.byte	0x3
	.word	0x2f5
	.long	0x445
	.uleb128 0x9
	.byte	0x4
	.long	0x4e4
	.uleb128 0x7
	.long	0x508
	.uleb128 0x8
	.long	0x508
	.uleb128 0x8
	.long	0x4af
	.uleb128 0x8
	.long	0xc4
	.uleb128 0x8
	.long	0xc4
	.uleb128 0x8
	.long	0xc4
	.uleb128 0x8
	.long	0x638
	.byte	0
	.uleb128 0x9
	.byte	0x4
	.long	0x50e
	.uleb128 0xa
	.long	0x513
	.uleb128 0x11
	.ascii "_tContext\0"
	.byte	0x2c
	.byte	0x3
	.word	0x33f
	.long	0x638
	.uleb128 0xf
	.ascii "i32Size\0"
	.byte	0x3
	.word	0x345
	.long	0xc4
	.byte	0
	.uleb128 0xf
	.ascii "psDisplay\0"
	.byte	0x3
	.word	0x34a
	.long	0x641
	.byte	0x4
	.uleb128 0xf
	.ascii "sClipRegion\0"
	.byte	0x3
	.word	0x34f
	.long	0x1b4
	.byte	0x8
	.uleb128 0xf
	.ascii "ui32Foreground\0"
	.byte	0x3
	.word	0x354
	.long	0x131
	.byte	0x10
	.uleb128 0xf
	.ascii "ui32Background\0"
	.byte	0x3
	.word	0x359
	.long	0x131
	.byte	0x14
	.uleb128 0xf
	.ascii "psFont\0"
	.byte	0x3
	.word	0x35e
	.long	0x64c
	.byte	0x18
	.uleb128 0xf
	.ascii "pfnStringRenderer\0"
	.byte	0x3
	.word	0x366
	.long	0x4de
	.byte	0x1c
	.uleb128 0xf
	.ascii "pCodePointMapTable\0"
	.byte	0x3
	.word	0x36d
	.long	0x657
	.byte	0x20
	.uleb128 0xf
	.ascii "ui16Codepage\0"
	.byte	0x3
	.word	0x372
	.long	0x10b
	.byte	0x24
	.uleb128 0xf
	.ascii "ui8NumCodePointMaps\0"
	.byte	0x3
	.word	0x377
	.long	0xeb
	.byte	0x26
	.uleb128 0xf
	.ascii "ui8CodePointMap\0"
	.byte	0x3
	.word	0x37d
	.long	0xeb
	.byte	0x27
	.uleb128 0xf
	.ascii "ui8Reserved\0"
	.byte	0x3
	.word	0x382
	.long	0xeb
	.byte	0x28
	.byte	0
	.uleb128 0x2
	.byte	0x1
	.byte	0x2
	.ascii "_Bool\0"
	.uleb128 0x9
	.byte	0x4
	.long	0x647
	.uleb128 0xa
	.long	0x38c
	.uleb128 0x9
	.byte	0x4
	.long	0x652
	.uleb128 0xa
	.long	0x432
	.uleb128 0x9
	.byte	0x4
	.long	0x65d
	.uleb128 0xa
	.long	0x4c8
	.uleb128 0x10
	.ascii "tContext\0"
	.byte	0x3
	.word	0x385
	.long	0x513
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
	.long	0x6ae
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
	.long	0x694
	.uleb128 0x14
	.secrel32	LASF0
	.byte	0x4
	.byte	0x4
	.byte	0x25
	.long	0x6dc
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
	.long	0x6bf
	.uleb128 0x16
	.ascii "tsOpt\0"
	.byte	0x10
	.byte	0x4
	.byte	0x27
	.long	0x73a
	.uleb128 0x5
	.ascii "freq\0"
	.byte	0x4
	.byte	0x29
	.long	0x131
	.byte	0
	.uleb128 0x5
	.ascii "sample_size\0"
	.byte	0x4
	.byte	0x2a
	.long	0x131
	.byte	0x4
	.uleb128 0x5
	.ascii "channelOpt\0"
	.byte	0x4
	.byte	0x2b
	.long	0x6dc
	.byte	0x8
	.uleb128 0x5
	.ascii "uiState\0"
	.byte	0x4
	.byte	0x2c
	.long	0x6ae
	.byte	0xc
	.byte	0
	.uleb128 0x3
	.ascii "tuiConfig\0"
	.byte	0x4
	.byte	0x2d
	.long	0x6e7
	.uleb128 0x17
	.ascii "ConfigureUART\0"
	.byte	0x1
	.byte	0x78
	.long	LFB6
	.long	LFE6-LFB6
	.uleb128 0x1
	.byte	0x9c
	.long	0x7d2
	.uleb128 0x18
	.ascii "ROM_SysCtlPeripheralEnable\0"
	.byte	0x1
	.byte	0x7d
	.long	0xd3
	.long	0x792
	.uleb128 0x19
	.byte	0
	.uleb128 0x18
	.ascii "ROM_GPIOPinConfigure\0"
	.byte	0x1
	.byte	0x87
	.long	0xd3
	.long	0x7b4
	.uleb128 0x19
	.byte	0
	.uleb128 0x1a
	.ascii "ROM_GPIOPinTypeUART\0"
	.byte	0x1
	.byte	0x89
	.long	0xd3
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x17
	.ascii "SysTickIntHandler\0"
	.byte	0x1
	.byte	0x9b
	.long	LFB7
	.long	LFE7-LFB7
	.uleb128 0x1
	.byte	0x9c
	.long	0x835
	.uleb128 0x18
	.ascii "ROM_IntMasterDisable\0"
	.byte	0x1
	.byte	0x9d
	.long	0xd3
	.long	0x817
	.uleb128 0x19
	.byte	0
	.uleb128 0x1a
	.ascii "ROM_IntMasterEnable\0"
	.byte	0x1
	.byte	0xa0
	.long	0xd3
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x17
	.ascii "Timer0IntHandler\0"
	.byte	0x1
	.byte	0xa9
	.long	LFB8
	.long	LFE8-LFB8
	.uleb128 0x1
	.byte	0x9c
	.long	0x865
	.uleb128 0x1b
	.secrel32	LASF1
	.byte	0x1
	.byte	0xae
	.long	0xd3
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x17
	.ascii "Timer1IntHandler\0"
	.byte	0x1
	.byte	0xbb
	.long	LFB9
	.long	LFE9-LFB9
	.uleb128 0x1
	.byte	0x9c
	.long	0x895
	.uleb128 0x1b
	.secrel32	LASF1
	.byte	0x1
	.byte	0xae
	.long	0xd3
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x1c
	.ascii "ConfigSysTick\0"
	.byte	0x1
	.byte	0xcf
	.long	LFB10
	.long	LFE10-LFB10
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x1d
	.ascii "main\0"
	.byte	0x1
	.byte	0xf4
	.long	0xd3
	.long	LFB11
	.long	LFE11-LFB11
	.uleb128 0x1
	.byte	0x9c
	.long	0x904
	.uleb128 0x1e
	.ascii "sDisplayContext\0"
	.byte	0x1
	.byte	0xf7
	.long	0x662
	.uleb128 0x5
	.byte	0x3
	.long	_sDisplayContext.3260
	.uleb128 0x1a
	.ascii "ROM_SysCtlClockSet\0"
	.byte	0x1
	.byte	0xfb
	.long	0xd3
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x1e
	.ascii "uiConfig\0"
	.byte	0x1
	.byte	0x70
	.long	0x73a
	.uleb128 0x5
	.byte	0x3
	.long	_uiConfig
	.uleb128 0x1f
	.ascii "g_sCFAL96x64x16\0"
	.byte	0x5
	.byte	0x23
	.long	0x647
	.uleb128 0x20
	.ascii "g_ui32Flags\0"
	.byte	0x1
	.byte	0x5c
	.long	0x131
	.uleb128 0x5
	.byte	0x3
	.long	_g_ui32Flags
	.uleb128 0x20
	.ascii "current_time\0"
	.byte	0x1
	.byte	0x62
	.long	0x964
	.uleb128 0x5
	.byte	0x3
	.long	_current_time
	.uleb128 0x21
	.long	0x131
	.uleb128 0x20
	.ascii "systick_period\0"
	.byte	0x1
	.byte	0x69
	.long	0x985
	.uleb128 0x5
	.byte	0x3
	.long	_systick_period
	.uleb128 0xa
	.long	0x131
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
	.uleb128 0x19
	.uleb128 0x18
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x1a
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
	.byte	0
	.byte	0
	.uleb128 0x1c
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
	.uleb128 0x1d
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
	.uleb128 0x1e
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
	.uleb128 0x1f
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
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x20
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
	.uleb128 0x21
	.uleb128 0x35
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
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
LASF1:
	.ascii "ROM_TimerIntClear\0"
LASF0:
	.ascii "channel_enum\0"
	.ident	"GCC: (GNU) 4.8.2"
	.def	_ROM_SysCtlPeripheralEnable;	.scl	2;	.type	32;	.endef
	.def	_ROM_GPIOPinConfigure;	.scl	2;	.type	32;	.endef
	.def	_ROM_GPIOPinTypeUART;	.scl	2;	.type	32;	.endef
	.def	_UARTClockSourceSet;	.scl	2;	.type	32;	.endef
	.def	_UARTStdioConfig;	.scl	2;	.type	32;	.endef
	.def	_ROM_IntMasterDisable;	.scl	2;	.type	32;	.endef
	.def	_ROM_IntMasterEnable;	.scl	2;	.type	32;	.endef
	.def	_ROM_TimerIntClear;	.scl	2;	.type	32;	.endef
	.def	_SysTickIntRegister;	.scl	2;	.type	32;	.endef
	.def	_IntPrioritySet;	.scl	2;	.type	32;	.endef
	.def	_SysCtlClockGet;	.scl	2;	.type	32;	.endef
	.def	_SysTickPeriodSet;	.scl	2;	.type	32;	.endef
	.def	_IntMasterEnable;	.scl	2;	.type	32;	.endef
	.def	_SysTickIntEnable;	.scl	2;	.type	32;	.endef
	.def	_SysTickEnable;	.scl	2;	.type	32;	.endef
	.def	_ROM_SysCtlClockSet;	.scl	2;	.type	32;	.endef
	.def	_CFAL96x64x16Init;	.scl	2;	.type	32;	.endef
	.def	_ButtonsInit;	.scl	2;	.type	32;	.endef
	.def	_GrContextInit;	.scl	2;	.type	32;	.endef
	.def	_vInitUI;	.scl	2;	.type	32;	.endef
	.def	_vPollSBoxButton;	.scl	2;	.type	32;	.endef
	.def	_AcquireMain;	.scl	2;	.type	32;	.endef
