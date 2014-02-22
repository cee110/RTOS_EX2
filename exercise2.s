
gcc/exercise2.o:     file format elf32-little


Disassembly of section .text.SysTickIntHandler:

00000000 <$t>:
$t():
   0:	10 b5 07 4c 23 68    	adc    BYTE PTR [ebp+0x68234c07],dh

00000001 <SysTickIntHandler>:
SysTickIntHandler():
   1:	b5 07                	mov    ch,0x7
   3:	4c                   	dec    esp
   4:	23 68 9b             	and    ebp,DWORD PTR [eax-0x65]
   7:	68 98 47 06 4b       	push   0x4b064798
   c:	1b 68 06             	sbb    ebp,DWORD PTR [eax+0x6]
   f:	4b                   	dec    ebx
  10:	1a 68 01             	sbb    ch,BYTE PTR [eax+0x1]
  13:	32 1a                	xor    bl,BYTE PTR [edx]
  15:	60                   	pusha  
  16:	23 68 5b             	and    ebp,DWORD PTR [eax+0x5b]
  19:	68 98 47 10 bd       	push   0xbd104798
  1e:	00 bf 48 00 00 01    	add    BYTE PTR [edi+0x1000048],bh

00000020 <$d>:
  20:	48                   	dec    eax
  21:	00 00                	add    BYTE PTR [eax],al
  23:	01 10                	add    DWORD PTR [eax],edx
  25:	e0 00                	loopne 27 <$t+0x27>
  27:	e0 00                	loopne 29 <$t+0x29>
  29:	00 00                	add    BYTE PTR [eax],al
	...

Disassembly of section .text.ConfigureUART:

0000002c <$t>:
$t():
  2c:	10 b5 13 4c 13 48    	adc    BYTE PTR [ebp+0x48134c13],dh

0000002d <ConfigureUART>:
ConfigureUART():
  2d:	b5 13                	mov    ch,0x13
  2f:	4c                   	dec    esp
  30:	13 48 23             	adc    ecx,DWORD PTR [eax+0x23]
  33:	68 9b 69 98 47       	push   0x4798699b
  38:	23 68 12             	and    ebp,DWORD PTR [eax+0x12]
  3b:	48                   	dec    eax
  3c:	9b                   	fwait
  3d:	69 98 47 54 f8 24 3c 	imul   ebx,DWORD PTR [eax+0x24f85447],0x9b20013c
  44:	01 20 9b 
  47:	6e                   	outs   dx,BYTE PTR ds:[esi]
  48:	98                   	cwde   
  49:	47                   	inc    edi
  4a:	54                   	push   esp
  4b:	f8                   	clc    
  4c:	24 3c                	and    al,0x3c
  4e:	40                   	inc    eax
  4f:	f2 01 40 9b          	repnz add DWORD PTR [eax-0x65],eax
  53:	6e                   	outs   dx,BYTE PTR ds:[esi]
  54:	98                   	cwde   
  55:	47                   	inc    edi
  56:	54                   	push   esp
  57:	f8                   	clc    
  58:	24 3c                	and    al,0x3c
  5a:	4f                   	dec    edi
  5b:	f0 40                	lock inc eax
  5d:	20 5b 6d             	and    BYTE PTR [ebx+0x6d],bl
  60:	03 21                	add    esp,DWORD PTR [ecx]
  62:	98                   	cwde   
  63:	47                   	inc    edi
  64:	08 48 05             	or     BYTE PTR [eax+0x5],cl
  67:	21 ff                	and    edi,edi
  69:	f7 fe                	idiv   esi
  6b:	ff 00                	inc    DWORD PTR [eax]
  6d:	20 4f f4             	and    BYTE PTR [edi-0xc],cl
  70:	e1 31                	loope  a3 <current_time+0xa3>
  72:	06                   	push   es
  73:	4a                   	dec    edx
  74:	bd e8 10 40 ff       	mov    ebp,0xff4010e8
  79:	f7 fe                	idiv   esi
  7b:	bf 44 00 00 01       	mov    edi,0x1000044

0000007c <$d>:
  7c:	44                   	inc    esp
  7d:	00 00                	add    BYTE PTR [eax],al
  7f:	01 00                	add    DWORD PTR [eax],eax
  81:	08 00                	or     BYTE PTR [eax],al
  83:	f0 00 18             	lock add BYTE PTR [eax],bl
  86:	00 f0                	add    al,dh
  88:	00 c0                	add    al,al
  8a:	00 40 00             	add    BYTE PTR [eax+0x0],al
  8d:	24 f4                	and    al,0xf4
	...

Disassembly of section .text.Timer0IntHandler:

000000bc <$t>:
$t():
  bc:	08 b5 0a 4b 0a 48    	or     BYTE PTR [ebp+0x480a4b0a],dh

000000bd <Timer0IntHandler>:
Timer0IntHandler():
  bd:	b5 0a                	mov    ch,0xa
  bf:	4b                   	dec    ebx
  c0:	0a 48 1b             	or     cl,BYTE PTR [eax+0x1b]
  c3:	68 01 21 1b 68       	push   0x681b2101
  c8:	98                   	cwde   
  c9:	47                   	inc    edi
  ca:	09 4a 02             	or     DWORD PTR [edx+0x2],ecx
  cd:	f0 70 43             	lock jo 113 <current_time+0x113>
  d0:	43                   	inc    ebx
  d1:	f0 00 73 c2          	lock add BYTE PTR [ebx-0x3e],dh
  d5:	f3 13 02             	repz adc eax,DWORD PTR [edx]
  d8:	43                   	inc    ebx
  d9:	ea 42 13 1a 68 82 f0 	jmp    0xf082:0x681a1342
  e0:	01 02                	add    DWORD PTR [edx],eax
  e2:	1a 60 08             	sbb    ah,BYTE PTR [eax+0x8]
  e5:	bd 00 bf 3c 00       	mov    ebp,0x3cbf00

000000e8 <$d>:
  e8:	3c 00                	cmp    al,0x0
  ea:	00 01                	add    BYTE PTR [ecx],al
  ec:	00 00                	add    BYTE PTR [eax],al
  ee:	03 40 00             	add    eax,DWORD PTR [eax+0x0]
  f1:	00 00                	add    BYTE PTR [eax],al
	...

Disassembly of section .text.Timer1IntHandler:

000001b0 <$t>:
$t():
 1b0:	08 b5 0b 4b 0b 48    	or     BYTE PTR [ebp+0x480b4b0b],dh

000001b1 <Timer1IntHandler>:
Timer1IntHandler():
 1b1:	b5 0b                	mov    ch,0xb
 1b3:	4b                   	dec    ebx
 1b4:	0b 48 1b             	or     ecx,DWORD PTR [eax+0x1b]
 1b7:	68 01 21 1b 68       	push   0x681b2101
 1bc:	98                   	cwde   
 1bd:	47                   	inc    edi
 1be:	0a 4a 02             	or     cl,BYTE PTR [edx+0x2]
 1c1:	f0 70 43             	lock jo 207 <current_time+0x207>
 1c4:	43                   	inc    ebx
 1c5:	f0 00 73 c2          	lock add BYTE PTR [ebx-0x3e],dh
 1c9:	f3 13 02             	repz adc eax,DWORD PTR [edx]
 1cc:	43                   	inc    ebx
 1cd:	f0 04 03             	lock add al,0x3
 1d0:	43                   	inc    ebx
 1d1:	ea 42 13 1a 68 82 f0 	jmp    0xf082:0x681a1342
 1d8:	01 02                	add    DWORD PTR [edx],eax
 1da:	1a 60 08             	sbb    ah,BYTE PTR [eax+0x8]
 1dd:	bd 00 bf 3c 00       	mov    ebp,0x3cbf00

000001e0 <$d>:
 1e0:	3c 00                	cmp    al,0x0
 1e2:	00 01                	add    BYTE PTR [ecx],al
 1e4:	00 10                	add    BYTE PTR [eax],dl
 1e6:	03 40 00             	add    eax,DWORD PTR [eax+0x0]
 1e9:	00 00                	add    BYTE PTR [eax],al
	...

Disassembly of section .text.ConfigSysTick:

0000039c <$t>:
$t():
 39c:	08 b5 0b 48 ff f7    	or     BYTE PTR [ebp-0x800b7f5],dh

0000039d <ConfigSysTick>:
ConfigSysTick():
 39d:	b5 0b                	mov    ch,0xb
 39f:	48                   	dec    eax
 3a0:	ff f7                	push   edi
 3a2:	fe                   	(bad)  
 3a3:	ff 60 21             	jmp    DWORD PTR [eax+0x21]
 3a6:	0f 20 ff             	mov    edi,cr7
 3a9:	f7 fe                	idiv   esi
 3ab:	ff                   	(bad)  
 3ac:	ff f7                	push   edi
 3ae:	fe                   	(bad)  
 3af:	ff 64 23 b0          	jmp    DWORD PTR [ebx+eiz*1-0x50]
 3b3:	fb                   	sti    
 3b4:	f3 f0 ff f7          	repz lock push edi
 3b8:	fe                   	(bad)  
 3b9:	ff                   	(bad)  
 3ba:	ff f7                	push   edi
 3bc:	fe                   	(bad)  
 3bd:	ff                   	(bad)  
 3be:	ff f7                	push   edi
 3c0:	fe                   	(bad)  
 3c1:	ff                   	(bad)  
 3c2:	bd e8 08 40 ff       	mov    ebp,0xff4008e8
 3c7:	f7 fe                	idiv   esi
 3c9:	bf 00 bf 00 00       	mov    edi,0xbf00

000003cc <$d>:
 3cc:	00 00                	add    BYTE PTR [eax],al
	...

Disassembly of section .text.startup.main:

0000076c <$t>:
$t():
 76c:	08 b5 10 4b 10 48    	or     BYTE PTR [ebp+0x48104b10],dh

0000076d <main>:
main():
 76d:	b5 10                	mov    ch,0x10
 76f:	4b                   	dec    ebx
 770:	10 48 1b             	adc    BYTE PTR [eax+0x1b],cl
 773:	68 10 4c db 6d       	push   0x6ddb4c10
 778:	98                   	cwde   
 779:	47                   	inc    edi
 77a:	ff f7                	push   edi
 77c:	fe                   	(bad)  
 77d:	ff                   	(bad)  
 77e:	ff f7                	push   edi
 780:	fe                   	(bad)  
 781:	ff                   	(bad)  
 782:	ff f7                	push   edi
 784:	fe                   	(bad)  
 785:	ff 0d 48 0d 49 ff    	dec    DWORD PTR ds:0xff490d48
 78b:	f7 fe                	idiv   esi
 78d:	ff 00                	inc    DWORD PTR [eax]
 78f:	23 0a                	and    ecx,DWORD PTR [edx]
 791:	48                   	dec    eax
 792:	63 72 ff             	arpl   WORD PTR [edx-0x1],si
 795:	f7 fe                	idiv   esi
 797:	ff 08                	dec    DWORD PTR [eax]
 799:	48                   	dec    eax
 79a:	07                   	pop    es
 79b:	49                   	dec    ecx
 79c:	ff f7                	push   edi
 79e:	fe                   	(bad)  
 79f:	ff 63 7a             	jmp    DWORD PTR [ebx+0x7a]
 7a2:	01 2b                	add    DWORD PTR [ebx],ebp
 7a4:	f8                   	clc    
 7a5:	d1 05 48 03 49 ff    	rol    DWORD PTR ds:0xff490348,1
 7ab:	f7 fe                	idiv   esi
 7ad:	ff f3                	push   ebx
 7af:	e7 44                	out    0x44,eax

000007b0 <$d>:
 7b0:	44                   	inc    esp
 7b1:	00 00                	add    BYTE PTR [eax],al
 7b3:	01 40 05             	add    DWORD PTR [eax+0x5],eax
 7b6:	c0 01 00             	rol    BYTE PTR [ecx],0x0
	...
