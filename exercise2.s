
gcc/exercise2.o:     file format elf32-little


Disassembly of section .text.ConfigureUART:

00000000 <$t>:
$t():
   0:	10 b5 13 4c 13 48    	adc    BYTE PTR [ebp+0x48134c13],dh

00000001 <ConfigureUART>:
ConfigureUART():
   1:	b5 13                	mov    ch,0x13
   3:	4c                   	dec    esp
   4:	13 48 23             	adc    ecx,DWORD PTR [eax+0x23]
   7:	68 9b 69 98 47       	push   0x4798699b
   c:	23 68 12             	and    ebp,DWORD PTR [eax+0x12]
   f:	48                   	dec    eax
  10:	9b                   	fwait
  11:	69 98 47 54 f8 24 3c 	imul   ebx,DWORD PTR [eax+0x24f85447],0x9b20013c
  18:	01 20 9b 
  1b:	6e                   	outs   dx,BYTE PTR ds:[esi]
  1c:	98                   	cwde   
  1d:	47                   	inc    edi
  1e:	54                   	push   esp
  1f:	f8                   	clc    
  20:	24 3c                	and    al,0x3c
  22:	40                   	inc    eax
  23:	f2 01 40 9b          	repnz add DWORD PTR [eax-0x65],eax
  27:	6e                   	outs   dx,BYTE PTR ds:[esi]
  28:	98                   	cwde   
  29:	47                   	inc    edi
  2a:	54                   	push   esp
  2b:	f8                   	clc    
  2c:	24 3c                	and    al,0x3c
  2e:	4f                   	dec    edi
  2f:	f0 40                	lock inc eax
  31:	20 5b 6d             	and    BYTE PTR [ebx+0x6d],bl
  34:	03 21                	add    esp,DWORD PTR [ecx]
  36:	98                   	cwde   
  37:	47                   	inc    edi
  38:	08 48 05             	or     BYTE PTR [eax+0x5],cl
  3b:	21 ff                	and    edi,edi
  3d:	f7 fe                	idiv   esi
  3f:	ff 00                	inc    DWORD PTR [eax]
  41:	20 4f f4             	and    BYTE PTR [edi-0xc],cl
  44:	e1 31                	loope  77 <SysTickIntHandler+0x12>
  46:	06                   	push   es
  47:	4a                   	dec    edx
  48:	bd e8 10 40 ff       	mov    ebp,0xff4010e8
  4d:	f7 fe                	idiv   esi
  4f:	bf 44 00 00 01       	mov    edi,0x1000044

00000050 <$d>:
  50:	44                   	inc    esp
  51:	00 00                	add    BYTE PTR [eax],al
  53:	01 00                	add    DWORD PTR [eax],eax
  55:	08 00                	or     BYTE PTR [eax],al
  57:	f0 00 18             	lock add BYTE PTR [eax],bl
  5a:	00 f0                	add    al,dh
  5c:	00 c0                	add    al,al
  5e:	00 40 00             	add    BYTE PTR [eax+0x0],al
  61:	24 f4                	and    al,0xf4
	...

Disassembly of section .text.SysTickIntHandler:

00000064 <$t>:
$t():
  64:	10 b5 07 4c 23 68    	adc    BYTE PTR [ebp+0x68234c07],dh

00000065 <SysTickIntHandler>:
SysTickIntHandler():
  65:	b5 07                	mov    ch,0x7
  67:	4c                   	dec    esp
  68:	23 68 9b             	and    ebp,DWORD PTR [eax-0x65]
  6b:	68 98 47 06 4b       	push   0x4b064798
  70:	1b 68 06             	sbb    ebp,DWORD PTR [eax+0x6]
  73:	4b                   	dec    ebx
  74:	1a 68 01             	sbb    ch,BYTE PTR [eax+0x1]
  77:	32 1a                	xor    bl,BYTE PTR [edx]
  79:	60                   	pusha  
  7a:	23 68 5b             	and    ebp,DWORD PTR [eax+0x5b]
  7d:	68 98 47 10 bd       	push   0xbd104798
  82:	00 bf 48 00 00 01    	add    BYTE PTR [edi+0x1000048],bh

00000084 <$d>:
  84:	48                   	dec    eax
  85:	00 00                	add    BYTE PTR [eax],al
  87:	01 10                	add    DWORD PTR [eax],edx
  89:	e0 00                	loopne 8b <SysTickIntHandler+0x26>
  8b:	e0 00                	loopne 8d <SysTickIntHandler+0x28>
  8d:	00 00                	add    BYTE PTR [eax],al
	...

Disassembly of section .text.InitialiseADCPeripherals:

000000f4 <$t>:
$t():
  f4:	10 b5 11 48 11 4c    	adc    BYTE PTR [ebp+0x4c114811],dh

000000f5 <InitialiseADCPeripherals>:
InitialiseADCPeripherals():
  f5:	b5 11                	mov    ch,0x11
  f7:	48                   	dec    eax
  f8:	11 4c ff f7          	adc    DWORD PTR [edi+edi*8-0x9],ecx
  fc:	fe                   	(bad)  
  fd:	ff 11                	call   DWORD PTR [ecx]
  ff:	48                   	dec    eax
 100:	ff f7                	push   edi
 102:	fe                   	(bad)  
 103:	ff 10                	call   DWORD PTR [eax]
 105:	48                   	dec    eax
 106:	ff f7                	push   edi
 108:	fe                   	(bad)  
 109:	ff 20                	jmp    DWORD PTR [eax]
 10b:	46                   	inc    esi
 10c:	40                   	inc    eax
 10d:	21 ff                	and    edi,edi
 10f:	f7 fe                	idiv   esi
 111:	ff 20                	jmp    DWORD PTR [eax]
 113:	46                   	inc    esi
 114:	08 21                	or     BYTE PTR [ecx],ah
 116:	ff f7                	push   edi
 118:	fe                   	(bad)  
 119:	ff 0c 48             	dec    DWORD PTR [eax+ecx*2]
 11c:	01 21                	add    DWORD PTR [ecx],esp
 11e:	ff f7                	push   edi
 120:	fe                   	(bad)  
 121:	ff 0b                	dec    DWORD PTR [ebx]
 123:	48                   	dec    eax
 124:	01 21                	add    DWORD PTR [ecx],esp
 126:	ff f7                	push   edi
 128:	fe                   	(bad)  
 129:	ff 0a                	dec    DWORD PTR [edx]
 12b:	48                   	dec    eax
 12c:	ff f7                	push   edi
 12e:	fe                   	(bad)  
 12f:	ff 09                	dec    DWORD PTR [ecx]
 131:	4b                   	dec    ebx
 132:	1a 68 42             	sbb    ch,BYTE PTR [eax+0x42]
 135:	f0 40                	lock inc eax
 137:	02 1a                	add    bl,BYTE PTR [edx]
 139:	60                   	pusha  
 13a:	10 bd 00 38 00 f0    	adc    BYTE PTR [ebp-0xfffc800],bh

0000013c <$d>:
 13c:	00 38                	add    BYTE PTR [eax],bh
 13e:	00 f0                	add    al,dh
 140:	00 40 02             	add    BYTE PTR [eax+0x2],al
 143:	40                   	inc    eax
 144:	01 38                	add    DWORD PTR [eax],edi
 146:	00 f0                	add    al,dh
 148:	04 08                	add    al,0x8
 14a:	00 f0                	add    al,dh
 14c:	00 80 03 40 00 90    	add    BYTE PTR [eax-0x6fffbffd],al
 152:	03 40 01             	add    eax,DWORD PTR [eax+0x1]
 155:	08 00                	or     BYTE PTR [eax],al
 157:	f0 28 55 00          	lock sub BYTE PTR [ebp+0x0],dl
 15b:	40                   	inc    eax

Disassembly of section .text.InitialiseTimer0:

00000250 <$t>:
$t():
 250:	09 4b 0a             	or     DWORD PTR [ebx+0xa],ecx

00000251 <InitialiseTimer0>:
InitialiseTimer0():
 251:	4b                   	dec    ebx
 252:	0a 48 1b             	or     cl,BYTE PTR [eax+0x1b]
 255:	68 10 b5 9b 69       	push   0x699bb510
 25a:	09 4c 98 47          	or     DWORD PTR [eax+ebx*4+0x47],ecx
 25e:	09 4b 1b             	or     DWORD PTR [ebx+0x1b],ecx
 261:	68 20 46 32 21       	push   0x21324620
 266:	db 68 98             	fld    TBYTE PTR [eax-0x68]
 269:	47                   	inc    edi
 26a:	20 46 ff             	and    BYTE PTR [esi-0x1],al
 26d:	21 00                	and    DWORD PTR [eax],eax
 26f:	22 bd e8 10 40 ff    	and    bh,BYTE PTR [ebp-0xbfef18]
 275:	f7 fe                	idiv   esi
 277:	bf 44 00 00 01       	mov    edi,0x1000044

00000278 <$d>:
 278:	44                   	inc    esp
 279:	00 00                	add    BYTE PTR [eax],al
 27b:	01 00                	add    DWORD PTR [eax],eax
 27d:	04 00                	add    al,0x0
 27f:	f0 00 00             	lock add BYTE PTR [eax],al
 282:	03 40 3c             	add    eax,DWORD PTR [eax+0x3c]
 285:	00 00                	add    BYTE PTR [eax],al
 287:	01                   	.byte 0x1

Disassembly of section .text.startup.main:

000004d8 <$t>:
$t():
 4d8:	22 4b 23             	and    cl,BYTE PTR [ebx+0x23]

000004d9 <main>:
main():
 4d9:	4b                   	dec    ebx
 4da:	23 48 1b             	and    ecx,DWORD PTR [eax+0x1b]
 4dd:	68 23 4d db 6d       	push   0x6ddb4d23
 4e2:	23 4e 80             	and    ecx,DWORD PTR [esi-0x80]
 4e5:	b5 98                	mov    ch,0x98
 4e7:	47                   	inc    edi
 4e8:	ff f7                	push   edi
 4ea:	fe                   	(bad)  
 4eb:	ff                   	(bad)  
 4ec:	ff f7                	push   edi
 4ee:	fe                   	(bad)  
 4ef:	ff                   	(bad)  
 4f0:	ff f7                	push   edi
 4f2:	fe                   	(bad)  
 4f3:	ff 1f                	call   FWORD PTR [edi]
 4f5:	49                   	dec    ecx
 4f6:	20 48 ff             	and    BYTE PTR [eax-0x1],cl
 4f9:	f7 fe                	idiv   esi
 4fb:	ff                   	(bad)  
 4fc:	ff f7                	push   edi
 4fe:	fe                   	(bad)  
 4ff:	ff                   	(bad)  
 500:	ff f7                	push   edi
 502:	fe                   	(bad)  
 503:	ff 00                	inc    DWORD PTR [eax]
 505:	23 1c 48             	and    ebx,DWORD PTR [eax+ecx*2]
 508:	6b 72 ab 72          	imul   esi,DWORD PTR [edx-0x55],0x72
 50c:	ff f7                	push   edi
 50e:	fe                   	(bad)  
 50f:	ff 28                	jmp    FWORD PTR [eax]
 511:	46                   	inc    esi
 512:	ff f7                	push   edi
 514:	fe                   	(bad)  
 515:	ff 2c 46             	jmp    FWORD PTR [esi+eax*2]
 518:	17                   	pop    ss
 519:	48                   	dec    eax
 51a:	14 49                	adc    al,0x49
 51c:	ff f7                	push   edi
 51e:	fe                   	(bad)  
 51f:	ff 6b 7a             	jmp    FWORD PTR [ebx+0x7a]
 522:	01 2b                	add    DWORD PTR [ebx],ebp
 524:	02 d0                	add    dl,al
 526:	a3 7a 00 2b f5       	mov    ds:0xf52b007a,eax
 52b:	d0 ab 7a 6b b1 4f    	shr    BYTE PTR [ebx+0x4fb16b7a],1
 531:	f4                   	hlt    
 532:	c8 63 01 27          	enter  0x163,0x27
 536:	84 e8                	test   al,ch
 538:	88 00                	mov    BYTE PTR [eax],al
 53a:	00 23                	add    BYTE PTR [ebx],ah
 53c:	23 72 33             	and    esi,DWORD PTR [edx+0x33]
 53f:	68 9b 68 98 47       	push   0x4798689b
 544:	33 68 67             	xor    ebp,DWORD PTR [eax+0x67]
 547:	72 5b                	jb     5a4 <$d+0x40>
 549:	68 98 47 0a 48       	push   0x480a4798
 54e:	07                   	pop    es
 54f:	49                   	dec    ecx
 550:	ff f7                	push   edi
 552:	fe                   	(bad)  
 553:	ff ab 7a 00 2b de    	jmp    FWORD PTR [ebx-0x21d4ff86]
 559:	d1 07                	rol    DWORD PTR [edi],1
 55b:	48                   	dec    eax
 55c:	ff f7                	push   edi
 55e:	fe                   	(bad)  
 55f:	ff da                	call   <internal disassembler error>
 561:	e7 00                	out    0x0,eax
 563:	bf 44 00 00 01       	mov    edi,0x1000044

00000564 <$d>:
 564:	44                   	inc    esp
 565:	00 00                	add    BYTE PTR [eax],al
 567:	01 40 05             	add    DWORD PTR [eax+0x5],eax
 56a:	c0 01 00             	rol    BYTE PTR [ecx],0x0
 56d:	00 00                	add    BYTE PTR [eax],al
 56f:	00 48 00             	add    BYTE PTR [eax+0x0],cl
 572:	00 01                	add    BYTE PTR [ecx],al
	...
