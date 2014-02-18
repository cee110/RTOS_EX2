	.file	"systick.c"
	.text
Ltext0:
	.globl	_SysTickEnable
	.def	_SysTickEnable;	.scl	2;	.type	32;	.endef
_SysTickEnable:
LFB0:
	.file 1 "../../../../driverlib/systick.c"
	.loc 1 76 0
	.cfi_startproc
	pushl	%ebp
LCFI0:
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
LCFI1:
	.cfi_def_cfa_register 5
	.loc 1 80 0
	movl	$-536813552, %eax
	movl	$-536813552, %edx
	movl	(%edx), %edx
	orl	$5, %edx
	movl	%edx, (%eax)
	.loc 1 81 0
	popl	%ebp
LCFI2:
	.cfi_def_cfa 4, 4
	.cfi_restore 5
	ret
	.cfi_endproc
LFE0:
	.globl	_SysTickDisable
	.def	_SysTickDisable;	.scl	2;	.type	32;	.endef
_SysTickDisable:
LFB1:
	.loc 1 95 0
	.cfi_startproc
	pushl	%ebp
LCFI3:
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
LCFI4:
	.cfi_def_cfa_register 5
	.loc 1 99 0
	movl	$-536813552, %eax
	movl	$-536813552, %edx
	movl	(%edx), %edx
	andl	$-2, %edx
	movl	%edx, (%eax)
	.loc 1 100 0
	popl	%ebp
LCFI5:
	.cfi_def_cfa 4, 4
	.cfi_restore 5
	ret
	.cfi_endproc
LFE1:
	.globl	_SysTickIntRegister
	.def	_SysTickIntRegister;	.scl	2;	.type	32;	.endef
_SysTickIntRegister:
LFB2:
	.loc 1 120 0
	.cfi_startproc
	pushl	%ebp
LCFI6:
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
LCFI7:
	.cfi_def_cfa_register 5
	subl	$24, %esp
	.loc 1 124 0
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$15, (%esp)
	call	_IntRegister
	.loc 1 129 0
	movl	$-536813552, %eax
	movl	$-536813552, %edx
	movl	(%edx), %edx
	orl	$2, %edx
	movl	%edx, (%eax)
	.loc 1 130 0
	leave
	.cfi_restore 5
LCFI8:
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE2:
	.globl	_SysTickIntUnregister
	.def	_SysTickIntUnregister;	.scl	2;	.type	32;	.endef
_SysTickIntUnregister:
LFB3:
	.loc 1 147 0
	.cfi_startproc
	pushl	%ebp
LCFI9:
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
LCFI10:
	.cfi_def_cfa_register 5
	subl	$24, %esp
	.loc 1 151 0
	movl	$-536813552, %eax
	movl	$-536813552, %edx
	movl	(%edx), %edx
	andl	$-3, %edx
	movl	%edx, (%eax)
	.loc 1 156 0
	movl	$15, (%esp)
	call	_IntUnregister
	.loc 1 157 0
	leave
	.cfi_restore 5
LCFI11:
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE3:
	.globl	_SysTickIntEnable
	.def	_SysTickIntEnable;	.scl	2;	.type	32;	.endef
_SysTickIntEnable:
LFB4:
	.loc 1 175 0
	.cfi_startproc
	pushl	%ebp
LCFI12:
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
LCFI13:
	.cfi_def_cfa_register 5
	.loc 1 179 0
	movl	$-536813552, %eax
	movl	$-536813552, %edx
	movl	(%edx), %edx
	orl	$2, %edx
	movl	%edx, (%eax)
	.loc 1 180 0
	popl	%ebp
LCFI14:
	.cfi_def_cfa 4, 4
	.cfi_restore 5
	ret
	.cfi_endproc
LFE4:
	.globl	_SysTickIntDisable
	.def	_SysTickIntDisable;	.scl	2;	.type	32;	.endef
_SysTickIntDisable:
LFB5:
	.loc 1 194 0
	.cfi_startproc
	pushl	%ebp
LCFI15:
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
LCFI16:
	.cfi_def_cfa_register 5
	.loc 1 198 0
	movl	$-536813552, %eax
	movl	$-536813552, %edx
	movl	(%edx), %edx
	andl	$-3, %edx
	movl	%edx, (%eax)
	.loc 1 199 0
	popl	%ebp
LCFI17:
	.cfi_def_cfa 4, 4
	.cfi_restore 5
	ret
	.cfi_endproc
LFE5:
	.globl	_SysTickPeriodSet
	.def	_SysTickPeriodSet;	.scl	2;	.type	32;	.endef
_SysTickPeriodSet:
LFB6:
	.loc 1 222 0
	.cfi_startproc
	pushl	%ebp
LCFI18:
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
LCFI19:
	.cfi_def_cfa_register 5
	.loc 1 231 0
	movl	$-536813548, %eax
	movl	8(%ebp), %edx
	decl	%edx
	movl	%edx, (%eax)
	.loc 1 232 0
	popl	%ebp
LCFI20:
	.cfi_def_cfa 4, 4
	.cfi_restore 5
	ret
	.cfi_endproc
LFE6:
	.globl	_SysTickPeriodGet
	.def	_SysTickPeriodGet;	.scl	2;	.type	32;	.endef
_SysTickPeriodGet:
LFB7:
	.loc 1 246 0
	.cfi_startproc
	pushl	%ebp
LCFI21:
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
LCFI22:
	.cfi_def_cfa_register 5
	.loc 1 250 0
	movl	$-536813548, %eax
	movl	(%eax), %eax
	incl	%eax
	.loc 1 251 0
	popl	%ebp
LCFI23:
	.cfi_def_cfa 4, 4
	.cfi_restore 5
	ret
	.cfi_endproc
LFE7:
	.globl	_SysTickValueGet
	.def	_SysTickValueGet;	.scl	2;	.type	32;	.endef
_SysTickValueGet:
LFB8:
	.loc 1 265 0
	.cfi_startproc
	pushl	%ebp
LCFI24:
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
LCFI25:
	.cfi_def_cfa_register 5
	.loc 1 269 0
	movl	$-536813544, %eax
	movl	(%eax), %eax
	.loc 1 270 0
	popl	%ebp
LCFI26:
	.cfi_def_cfa 4, 4
	.cfi_restore 5
	ret
	.cfi_endproc
LFE8:
Letext0:
	.file 2 "c:/mingw/bin/../lib/gcc/mingw32/4.6.1/../../../../include/stdint.h"
	.section	.debug_info,"dr"
Ldebug_info0:
	.long	0x287
	.word	0x2
	.secrel32	Ldebug_abbrev0
	.byte	0x4
	.uleb128 0x1
	.ascii "GNU C 4.6.1\0"
	.byte	0x1
	.ascii "../../../../driverlib/systick.c\0"
	.ascii "C:\\emsys\\TivaC1157\\examples\\boards\\ek-lm4f232\\exercise2\0"
	.long	Ltext0
	.long	Letext0
	.secrel32	Ldebug_line0
	.uleb128 0x2
	.byte	0x2
	.byte	0x7
	.ascii "short unsigned int\0"
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.ascii "signed char\0"
	.uleb128 0x2
	.byte	0x1
	.byte	0x8
	.ascii "unsigned char\0"
	.uleb128 0x2
	.byte	0x2
	.byte	0x5
	.ascii "short int\0"
	.uleb128 0x2
	.byte	0x4
	.byte	0x5
	.ascii "int\0"
	.uleb128 0x3
	.ascii "uint32_t\0"
	.byte	0x2
	.byte	0x20
	.long	0xd7
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.ascii "unsigned int\0"
	.uleb128 0x2
	.byte	0x8
	.byte	0x5
	.ascii "long long int\0"
	.uleb128 0x2
	.byte	0x8
	.byte	0x7
	.ascii "long long unsigned int\0"
	.uleb128 0x4
	.byte	0x1
	.ascii "SysTickEnable\0"
	.byte	0x1
	.byte	0x4b
	.byte	0x1
	.long	LFB0
	.long	LFE0
	.secrel32	LLST0
	.uleb128 0x4
	.byte	0x1
	.ascii "SysTickDisable\0"
	.byte	0x1
	.byte	0x5e
	.byte	0x1
	.long	LFB1
	.long	LFE1
	.secrel32	LLST1
	.uleb128 0x5
	.byte	0x1
	.ascii "SysTickIntRegister\0"
	.byte	0x1
	.byte	0x77
	.byte	0x1
	.long	LFB2
	.long	LFE2
	.secrel32	LLST2
	.long	0x18f
	.uleb128 0x6
	.ascii "pfnHandler\0"
	.byte	0x1
	.byte	0x77
	.long	0x191
	.byte	0x2
	.byte	0x91
	.sleb128 0
	.byte	0
	.uleb128 0x7
	.byte	0x1
	.uleb128 0x8
	.byte	0x4
	.long	0x18f
	.uleb128 0x4
	.byte	0x1
	.ascii "SysTickIntUnregister\0"
	.byte	0x1
	.byte	0x92
	.byte	0x1
	.long	LFB3
	.long	LFE3
	.secrel32	LLST3
	.uleb128 0x4
	.byte	0x1
	.ascii "SysTickIntEnable\0"
	.byte	0x1
	.byte	0xae
	.byte	0x1
	.long	LFB4
	.long	LFE4
	.secrel32	LLST4
	.uleb128 0x4
	.byte	0x1
	.ascii "SysTickIntDisable\0"
	.byte	0x1
	.byte	0xc1
	.byte	0x1
	.long	LFB5
	.long	LFE5
	.secrel32	LLST5
	.uleb128 0x5
	.byte	0x1
	.ascii "SysTickPeriodSet\0"
	.byte	0x1
	.byte	0xdd
	.byte	0x1
	.long	LFB6
	.long	LFE6
	.secrel32	LLST6
	.long	0x23e
	.uleb128 0x6
	.ascii "ui32Period\0"
	.byte	0x1
	.byte	0xdd
	.long	0xc7
	.byte	0x2
	.byte	0x91
	.sleb128 0
	.byte	0
	.uleb128 0x9
	.byte	0x1
	.ascii "SysTickPeriodGet\0"
	.byte	0x1
	.byte	0xf5
	.byte	0x1
	.long	0xc7
	.long	LFB7
	.long	LFE7
	.secrel32	LLST7
	.uleb128 0xa
	.byte	0x1
	.ascii "SysTickValueGet\0"
	.byte	0x1
	.word	0x108
	.byte	0x1
	.long	0xc7
	.long	LFB8
	.long	LFE8
	.secrel32	LLST8
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
	.uleb128 0x1
	.uleb128 0x10
	.uleb128 0x6
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
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0xc
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0xc
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x40
	.uleb128 0x6
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0xc
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0xc
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x40
	.uleb128 0x6
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x6
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
	.uleb128 0xa
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0x15
	.byte	0
	.uleb128 0x27
	.uleb128 0xc
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0xc
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0xc
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x40
	.uleb128 0x6
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0xc
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x27
	.uleb128 0xc
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x40
	.uleb128 0x6
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_loc,"dr"
Ldebug_loc0:
LLST0:
	.long	LFB0-Ltext0
	.long	LCFI0-Ltext0
	.word	0x2
	.byte	0x74
	.sleb128 4
	.long	LCFI0-Ltext0
	.long	LCFI1-Ltext0
	.word	0x2
	.byte	0x74
	.sleb128 8
	.long	LCFI1-Ltext0
	.long	LCFI2-Ltext0
	.word	0x2
	.byte	0x75
	.sleb128 8
	.long	LCFI2-Ltext0
	.long	LFE0-Ltext0
	.word	0x2
	.byte	0x74
	.sleb128 4
	.long	0
	.long	0
LLST1:
	.long	LFB1-Ltext0
	.long	LCFI3-Ltext0
	.word	0x2
	.byte	0x74
	.sleb128 4
	.long	LCFI3-Ltext0
	.long	LCFI4-Ltext0
	.word	0x2
	.byte	0x74
	.sleb128 8
	.long	LCFI4-Ltext0
	.long	LCFI5-Ltext0
	.word	0x2
	.byte	0x75
	.sleb128 8
	.long	LCFI5-Ltext0
	.long	LFE1-Ltext0
	.word	0x2
	.byte	0x74
	.sleb128 4
	.long	0
	.long	0
LLST2:
	.long	LFB2-Ltext0
	.long	LCFI6-Ltext0
	.word	0x2
	.byte	0x74
	.sleb128 4
	.long	LCFI6-Ltext0
	.long	LCFI7-Ltext0
	.word	0x2
	.byte	0x74
	.sleb128 8
	.long	LCFI7-Ltext0
	.long	LCFI8-Ltext0
	.word	0x2
	.byte	0x75
	.sleb128 8
	.long	LCFI8-Ltext0
	.long	LFE2-Ltext0
	.word	0x2
	.byte	0x74
	.sleb128 4
	.long	0
	.long	0
LLST3:
	.long	LFB3-Ltext0
	.long	LCFI9-Ltext0
	.word	0x2
	.byte	0x74
	.sleb128 4
	.long	LCFI9-Ltext0
	.long	LCFI10-Ltext0
	.word	0x2
	.byte	0x74
	.sleb128 8
	.long	LCFI10-Ltext0
	.long	LCFI11-Ltext0
	.word	0x2
	.byte	0x75
	.sleb128 8
	.long	LCFI11-Ltext0
	.long	LFE3-Ltext0
	.word	0x2
	.byte	0x74
	.sleb128 4
	.long	0
	.long	0
LLST4:
	.long	LFB4-Ltext0
	.long	LCFI12-Ltext0
	.word	0x2
	.byte	0x74
	.sleb128 4
	.long	LCFI12-Ltext0
	.long	LCFI13-Ltext0
	.word	0x2
	.byte	0x74
	.sleb128 8
	.long	LCFI13-Ltext0
	.long	LCFI14-Ltext0
	.word	0x2
	.byte	0x75
	.sleb128 8
	.long	LCFI14-Ltext0
	.long	LFE4-Ltext0
	.word	0x2
	.byte	0x74
	.sleb128 4
	.long	0
	.long	0
LLST5:
	.long	LFB5-Ltext0
	.long	LCFI15-Ltext0
	.word	0x2
	.byte	0x74
	.sleb128 4
	.long	LCFI15-Ltext0
	.long	LCFI16-Ltext0
	.word	0x2
	.byte	0x74
	.sleb128 8
	.long	LCFI16-Ltext0
	.long	LCFI17-Ltext0
	.word	0x2
	.byte	0x75
	.sleb128 8
	.long	LCFI17-Ltext0
	.long	LFE5-Ltext0
	.word	0x2
	.byte	0x74
	.sleb128 4
	.long	0
	.long	0
LLST6:
	.long	LFB6-Ltext0
	.long	LCFI18-Ltext0
	.word	0x2
	.byte	0x74
	.sleb128 4
	.long	LCFI18-Ltext0
	.long	LCFI19-Ltext0
	.word	0x2
	.byte	0x74
	.sleb128 8
	.long	LCFI19-Ltext0
	.long	LCFI20-Ltext0
	.word	0x2
	.byte	0x75
	.sleb128 8
	.long	LCFI20-Ltext0
	.long	LFE6-Ltext0
	.word	0x2
	.byte	0x74
	.sleb128 4
	.long	0
	.long	0
LLST7:
	.long	LFB7-Ltext0
	.long	LCFI21-Ltext0
	.word	0x2
	.byte	0x74
	.sleb128 4
	.long	LCFI21-Ltext0
	.long	LCFI22-Ltext0
	.word	0x2
	.byte	0x74
	.sleb128 8
	.long	LCFI22-Ltext0
	.long	LCFI23-Ltext0
	.word	0x2
	.byte	0x75
	.sleb128 8
	.long	LCFI23-Ltext0
	.long	LFE7-Ltext0
	.word	0x2
	.byte	0x74
	.sleb128 4
	.long	0
	.long	0
LLST8:
	.long	LFB8-Ltext0
	.long	LCFI24-Ltext0
	.word	0x2
	.byte	0x74
	.sleb128 4
	.long	LCFI24-Ltext0
	.long	LCFI25-Ltext0
	.word	0x2
	.byte	0x74
	.sleb128 8
	.long	LCFI25-Ltext0
	.long	LCFI26-Ltext0
	.word	0x2
	.byte	0x75
	.sleb128 8
	.long	LCFI26-Ltext0
	.long	LFE8-Ltext0
	.word	0x2
	.byte	0x74
	.sleb128 4
	.long	0
	.long	0
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
	.def	_IntRegister;	.scl	2;	.type	32;	.endef
	.def	_IntUnregister;	.scl	2;	.type	32;	.endef
