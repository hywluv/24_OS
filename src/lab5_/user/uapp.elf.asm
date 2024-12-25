
uapp.elf:     file format elf64-littleriscv


Disassembly of section .text.init:

0000000000000000 <_start>:
   0:	08c0006f          	j	8c <main>

Disassembly of section .text.getpid:

0000000000000004 <getpid>:
   4:	fe010113          	addi	sp,sp,-32
   8:	00813c23          	sd	s0,24(sp)
   c:	02010413          	addi	s0,sp,32
  10:	fe843783          	ld	a5,-24(s0)
  14:	0ac00893          	li	a7,172
  18:	00000073          	ecall
  1c:	00050793          	mv	a5,a0
  20:	fef43423          	sd	a5,-24(s0)
  24:	fe843783          	ld	a5,-24(s0)
  28:	00078513          	mv	a0,a5
  2c:	01813403          	ld	s0,24(sp)
  30:	02010113          	addi	sp,sp,32
  34:	00008067          	ret

Disassembly of section .text.wait:

0000000000000038 <wait>:
  38:	fd010113          	addi	sp,sp,-48
  3c:	02813423          	sd	s0,40(sp)
  40:	03010413          	addi	s0,sp,48
  44:	00050793          	mv	a5,a0
  48:	fcf42e23          	sw	a5,-36(s0)
  4c:	fe042623          	sw	zero,-20(s0)
  50:	0100006f          	j	60 <wait+0x28>
  54:	fec42783          	lw	a5,-20(s0)
  58:	0017879b          	addiw	a5,a5,1
  5c:	fef42623          	sw	a5,-20(s0)
  60:	fec42783          	lw	a5,-20(s0)
  64:	00078713          	mv	a4,a5
  68:	fdc42783          	lw	a5,-36(s0)
  6c:	0007071b          	sext.w	a4,a4
  70:	0007879b          	sext.w	a5,a5
  74:	fef760e3          	bltu	a4,a5,54 <wait+0x1c>
  78:	00000013          	nop
  7c:	00000013          	nop
  80:	02813403          	ld	s0,40(sp)
  84:	03010113          	addi	sp,sp,48
  88:	00008067          	ret

Disassembly of section .text.main:

000000000000008c <main>:
  8c:	fe010113          	addi	sp,sp,-32
  90:	00113c23          	sd	ra,24(sp)
  94:	00813823          	sd	s0,16(sp)
  98:	02010413          	addi	s0,sp,32
  9c:	00000097          	auipc	ra,0x0
  a0:	f68080e7          	jalr	-152(ra) # 4 <getpid>
  a4:	00050593          	mv	a1,a0
  a8:	00010613          	mv	a2,sp
  ac:	00001797          	auipc	a5,0x1
  b0:	0c078793          	addi	a5,a5,192 # 116c <counter>
  b4:	0007a783          	lw	a5,0(a5)
  b8:	0017879b          	addiw	a5,a5,1
  bc:	0007871b          	sext.w	a4,a5
  c0:	00001797          	auipc	a5,0x1
  c4:	0ac78793          	addi	a5,a5,172 # 116c <counter>
  c8:	00e7a023          	sw	a4,0(a5)
  cc:	00001797          	auipc	a5,0x1
  d0:	0a078793          	addi	a5,a5,160 # 116c <counter>
  d4:	0007a783          	lw	a5,0(a5)
  d8:	00078693          	mv	a3,a5
  dc:	00001517          	auipc	a0,0x1
  e0:	00c50513          	addi	a0,a0,12 # 10e8 <printf+0x104>
  e4:	00001097          	auipc	ra,0x1
  e8:	f00080e7          	jalr	-256(ra) # fe4 <printf>
  ec:	fe042623          	sw	zero,-20(s0)
  f0:	0100006f          	j	100 <main+0x74>
  f4:	fec42783          	lw	a5,-20(s0)
  f8:	0017879b          	addiw	a5,a5,1
  fc:	fef42623          	sw	a5,-20(s0)
 100:	fec42783          	lw	a5,-20(s0)
 104:	0007871b          	sext.w	a4,a5
 108:	500007b7          	lui	a5,0x50000
 10c:	ffe78793          	addi	a5,a5,-2 # 4ffffffe <buffer+0x4fffee86>
 110:	fee7f2e3          	bgeu	a5,a4,f4 <main+0x68>
 114:	f89ff06f          	j	9c <main+0x10>

Disassembly of section .text.putc:

0000000000000118 <putc>:
 118:	fe010113          	addi	sp,sp,-32
 11c:	00813c23          	sd	s0,24(sp)
 120:	02010413          	addi	s0,sp,32
 124:	00050793          	mv	a5,a0
 128:	fef42623          	sw	a5,-20(s0)
 12c:	00001797          	auipc	a5,0x1
 130:	04478793          	addi	a5,a5,68 # 1170 <tail>
 134:	0007a783          	lw	a5,0(a5)
 138:	0017871b          	addiw	a4,a5,1
 13c:	0007069b          	sext.w	a3,a4
 140:	00001717          	auipc	a4,0x1
 144:	03070713          	addi	a4,a4,48 # 1170 <tail>
 148:	00d72023          	sw	a3,0(a4)
 14c:	fec42703          	lw	a4,-20(s0)
 150:	0ff77713          	zext.b	a4,a4
 154:	00001697          	auipc	a3,0x1
 158:	02468693          	addi	a3,a3,36 # 1178 <buffer>
 15c:	00f687b3          	add	a5,a3,a5
 160:	00e78023          	sb	a4,0(a5)
 164:	fec42783          	lw	a5,-20(s0)
 168:	0ff7f793          	zext.b	a5,a5
 16c:	0007879b          	sext.w	a5,a5
 170:	00078513          	mv	a0,a5
 174:	01813403          	ld	s0,24(sp)
 178:	02010113          	addi	sp,sp,32
 17c:	00008067          	ret

Disassembly of section .text.isspace:

0000000000000180 <isspace>:
 180:	fe010113          	addi	sp,sp,-32
 184:	00813c23          	sd	s0,24(sp)
 188:	02010413          	addi	s0,sp,32
 18c:	00050793          	mv	a5,a0
 190:	fef42623          	sw	a5,-20(s0)
 194:	fec42783          	lw	a5,-20(s0)
 198:	0007871b          	sext.w	a4,a5
 19c:	02000793          	li	a5,32
 1a0:	02f70263          	beq	a4,a5,1c4 <isspace+0x44>
 1a4:	fec42783          	lw	a5,-20(s0)
 1a8:	0007871b          	sext.w	a4,a5
 1ac:	00800793          	li	a5,8
 1b0:	00e7de63          	bge	a5,a4,1cc <isspace+0x4c>
 1b4:	fec42783          	lw	a5,-20(s0)
 1b8:	0007871b          	sext.w	a4,a5
 1bc:	00d00793          	li	a5,13
 1c0:	00e7c663          	blt	a5,a4,1cc <isspace+0x4c>
 1c4:	00100793          	li	a5,1
 1c8:	0080006f          	j	1d0 <isspace+0x50>
 1cc:	00000793          	li	a5,0
 1d0:	00078513          	mv	a0,a5
 1d4:	01813403          	ld	s0,24(sp)
 1d8:	02010113          	addi	sp,sp,32
 1dc:	00008067          	ret

Disassembly of section .text.strtol:

00000000000001e0 <strtol>:
 1e0:	fb010113          	addi	sp,sp,-80
 1e4:	04113423          	sd	ra,72(sp)
 1e8:	04813023          	sd	s0,64(sp)
 1ec:	05010413          	addi	s0,sp,80
 1f0:	fca43423          	sd	a0,-56(s0)
 1f4:	fcb43023          	sd	a1,-64(s0)
 1f8:	00060793          	mv	a5,a2
 1fc:	faf42e23          	sw	a5,-68(s0)
 200:	fe043423          	sd	zero,-24(s0)
 204:	fe0403a3          	sb	zero,-25(s0)
 208:	fc843783          	ld	a5,-56(s0)
 20c:	fcf43c23          	sd	a5,-40(s0)
 210:	0100006f          	j	220 <strtol+0x40>
 214:	fd843783          	ld	a5,-40(s0)
 218:	00178793          	addi	a5,a5,1
 21c:	fcf43c23          	sd	a5,-40(s0)
 220:	fd843783          	ld	a5,-40(s0)
 224:	0007c783          	lbu	a5,0(a5)
 228:	0007879b          	sext.w	a5,a5
 22c:	00078513          	mv	a0,a5
 230:	00000097          	auipc	ra,0x0
 234:	f50080e7          	jalr	-176(ra) # 180 <isspace>
 238:	00050793          	mv	a5,a0
 23c:	fc079ce3          	bnez	a5,214 <strtol+0x34>
 240:	fd843783          	ld	a5,-40(s0)
 244:	0007c783          	lbu	a5,0(a5)
 248:	00078713          	mv	a4,a5
 24c:	02d00793          	li	a5,45
 250:	00f71e63          	bne	a4,a5,26c <strtol+0x8c>
 254:	00100793          	li	a5,1
 258:	fef403a3          	sb	a5,-25(s0)
 25c:	fd843783          	ld	a5,-40(s0)
 260:	00178793          	addi	a5,a5,1
 264:	fcf43c23          	sd	a5,-40(s0)
 268:	0240006f          	j	28c <strtol+0xac>
 26c:	fd843783          	ld	a5,-40(s0)
 270:	0007c783          	lbu	a5,0(a5)
 274:	00078713          	mv	a4,a5
 278:	02b00793          	li	a5,43
 27c:	00f71863          	bne	a4,a5,28c <strtol+0xac>
 280:	fd843783          	ld	a5,-40(s0)
 284:	00178793          	addi	a5,a5,1
 288:	fcf43c23          	sd	a5,-40(s0)
 28c:	fbc42783          	lw	a5,-68(s0)
 290:	0007879b          	sext.w	a5,a5
 294:	06079c63          	bnez	a5,30c <strtol+0x12c>
 298:	fd843783          	ld	a5,-40(s0)
 29c:	0007c783          	lbu	a5,0(a5)
 2a0:	00078713          	mv	a4,a5
 2a4:	03000793          	li	a5,48
 2a8:	04f71e63          	bne	a4,a5,304 <strtol+0x124>
 2ac:	fd843783          	ld	a5,-40(s0)
 2b0:	00178793          	addi	a5,a5,1
 2b4:	fcf43c23          	sd	a5,-40(s0)
 2b8:	fd843783          	ld	a5,-40(s0)
 2bc:	0007c783          	lbu	a5,0(a5)
 2c0:	00078713          	mv	a4,a5
 2c4:	07800793          	li	a5,120
 2c8:	00f70c63          	beq	a4,a5,2e0 <strtol+0x100>
 2cc:	fd843783          	ld	a5,-40(s0)
 2d0:	0007c783          	lbu	a5,0(a5)
 2d4:	00078713          	mv	a4,a5
 2d8:	05800793          	li	a5,88
 2dc:	00f71e63          	bne	a4,a5,2f8 <strtol+0x118>
 2e0:	01000793          	li	a5,16
 2e4:	faf42e23          	sw	a5,-68(s0)
 2e8:	fd843783          	ld	a5,-40(s0)
 2ec:	00178793          	addi	a5,a5,1
 2f0:	fcf43c23          	sd	a5,-40(s0)
 2f4:	0180006f          	j	30c <strtol+0x12c>
 2f8:	00800793          	li	a5,8
 2fc:	faf42e23          	sw	a5,-68(s0)
 300:	00c0006f          	j	30c <strtol+0x12c>
 304:	00a00793          	li	a5,10
 308:	faf42e23          	sw	a5,-68(s0)
 30c:	fd843783          	ld	a5,-40(s0)
 310:	0007c783          	lbu	a5,0(a5)
 314:	00078713          	mv	a4,a5
 318:	02f00793          	li	a5,47
 31c:	02e7f863          	bgeu	a5,a4,34c <strtol+0x16c>
 320:	fd843783          	ld	a5,-40(s0)
 324:	0007c783          	lbu	a5,0(a5)
 328:	00078713          	mv	a4,a5
 32c:	03900793          	li	a5,57
 330:	00e7ee63          	bltu	a5,a4,34c <strtol+0x16c>
 334:	fd843783          	ld	a5,-40(s0)
 338:	0007c783          	lbu	a5,0(a5)
 33c:	0007879b          	sext.w	a5,a5
 340:	fd07879b          	addiw	a5,a5,-48
 344:	fcf42a23          	sw	a5,-44(s0)
 348:	0800006f          	j	3c8 <strtol+0x1e8>
 34c:	fd843783          	ld	a5,-40(s0)
 350:	0007c783          	lbu	a5,0(a5)
 354:	00078713          	mv	a4,a5
 358:	06000793          	li	a5,96
 35c:	02e7f863          	bgeu	a5,a4,38c <strtol+0x1ac>
 360:	fd843783          	ld	a5,-40(s0)
 364:	0007c783          	lbu	a5,0(a5)
 368:	00078713          	mv	a4,a5
 36c:	07a00793          	li	a5,122
 370:	00e7ee63          	bltu	a5,a4,38c <strtol+0x1ac>
 374:	fd843783          	ld	a5,-40(s0)
 378:	0007c783          	lbu	a5,0(a5)
 37c:	0007879b          	sext.w	a5,a5
 380:	fa97879b          	addiw	a5,a5,-87
 384:	fcf42a23          	sw	a5,-44(s0)
 388:	0400006f          	j	3c8 <strtol+0x1e8>
 38c:	fd843783          	ld	a5,-40(s0)
 390:	0007c783          	lbu	a5,0(a5)
 394:	00078713          	mv	a4,a5
 398:	04000793          	li	a5,64
 39c:	06e7f863          	bgeu	a5,a4,40c <strtol+0x22c>
 3a0:	fd843783          	ld	a5,-40(s0)
 3a4:	0007c783          	lbu	a5,0(a5)
 3a8:	00078713          	mv	a4,a5
 3ac:	05a00793          	li	a5,90
 3b0:	04e7ee63          	bltu	a5,a4,40c <strtol+0x22c>
 3b4:	fd843783          	ld	a5,-40(s0)
 3b8:	0007c783          	lbu	a5,0(a5)
 3bc:	0007879b          	sext.w	a5,a5
 3c0:	fc97879b          	addiw	a5,a5,-55
 3c4:	fcf42a23          	sw	a5,-44(s0)
 3c8:	fd442783          	lw	a5,-44(s0)
 3cc:	00078713          	mv	a4,a5
 3d0:	fbc42783          	lw	a5,-68(s0)
 3d4:	0007071b          	sext.w	a4,a4
 3d8:	0007879b          	sext.w	a5,a5
 3dc:	02f75663          	bge	a4,a5,408 <strtol+0x228>
 3e0:	fbc42703          	lw	a4,-68(s0)
 3e4:	fe843783          	ld	a5,-24(s0)
 3e8:	02f70733          	mul	a4,a4,a5
 3ec:	fd442783          	lw	a5,-44(s0)
 3f0:	00f707b3          	add	a5,a4,a5
 3f4:	fef43423          	sd	a5,-24(s0)
 3f8:	fd843783          	ld	a5,-40(s0)
 3fc:	00178793          	addi	a5,a5,1
 400:	fcf43c23          	sd	a5,-40(s0)
 404:	f09ff06f          	j	30c <strtol+0x12c>
 408:	00000013          	nop
 40c:	fc043783          	ld	a5,-64(s0)
 410:	00078863          	beqz	a5,420 <strtol+0x240>
 414:	fc043783          	ld	a5,-64(s0)
 418:	fd843703          	ld	a4,-40(s0)
 41c:	00e7b023          	sd	a4,0(a5)
 420:	fe744783          	lbu	a5,-25(s0)
 424:	0ff7f793          	zext.b	a5,a5
 428:	00078863          	beqz	a5,438 <strtol+0x258>
 42c:	fe843783          	ld	a5,-24(s0)
 430:	40f007b3          	neg	a5,a5
 434:	0080006f          	j	43c <strtol+0x25c>
 438:	fe843783          	ld	a5,-24(s0)
 43c:	00078513          	mv	a0,a5
 440:	04813083          	ld	ra,72(sp)
 444:	04013403          	ld	s0,64(sp)
 448:	05010113          	addi	sp,sp,80
 44c:	00008067          	ret

Disassembly of section .text.puts_wo_nl:

0000000000000450 <puts_wo_nl>:
 450:	fd010113          	addi	sp,sp,-48
 454:	02113423          	sd	ra,40(sp)
 458:	02813023          	sd	s0,32(sp)
 45c:	03010413          	addi	s0,sp,48
 460:	fca43c23          	sd	a0,-40(s0)
 464:	fcb43823          	sd	a1,-48(s0)
 468:	fd043783          	ld	a5,-48(s0)
 46c:	00079863          	bnez	a5,47c <puts_wo_nl+0x2c>
 470:	00001797          	auipc	a5,0x1
 474:	cb078793          	addi	a5,a5,-848 # 1120 <printf+0x13c>
 478:	fcf43823          	sd	a5,-48(s0)
 47c:	fd043783          	ld	a5,-48(s0)
 480:	fef43423          	sd	a5,-24(s0)
 484:	0240006f          	j	4a8 <puts_wo_nl+0x58>
 488:	fe843783          	ld	a5,-24(s0)
 48c:	00178713          	addi	a4,a5,1
 490:	fee43423          	sd	a4,-24(s0)
 494:	0007c783          	lbu	a5,0(a5)
 498:	0007871b          	sext.w	a4,a5
 49c:	fd843783          	ld	a5,-40(s0)
 4a0:	00070513          	mv	a0,a4
 4a4:	000780e7          	jalr	a5
 4a8:	fe843783          	ld	a5,-24(s0)
 4ac:	0007c783          	lbu	a5,0(a5)
 4b0:	fc079ce3          	bnez	a5,488 <puts_wo_nl+0x38>
 4b4:	fe843703          	ld	a4,-24(s0)
 4b8:	fd043783          	ld	a5,-48(s0)
 4bc:	40f707b3          	sub	a5,a4,a5
 4c0:	0007879b          	sext.w	a5,a5
 4c4:	00078513          	mv	a0,a5
 4c8:	02813083          	ld	ra,40(sp)
 4cc:	02013403          	ld	s0,32(sp)
 4d0:	03010113          	addi	sp,sp,48
 4d4:	00008067          	ret

Disassembly of section .text.print_dec_int:

00000000000004d8 <print_dec_int>:
 4d8:	f9010113          	addi	sp,sp,-112
 4dc:	06113423          	sd	ra,104(sp)
 4e0:	06813023          	sd	s0,96(sp)
 4e4:	07010413          	addi	s0,sp,112
 4e8:	faa43423          	sd	a0,-88(s0)
 4ec:	fab43023          	sd	a1,-96(s0)
 4f0:	00060793          	mv	a5,a2
 4f4:	f8d43823          	sd	a3,-112(s0)
 4f8:	f8f40fa3          	sb	a5,-97(s0)
 4fc:	f9f44783          	lbu	a5,-97(s0)
 500:	0ff7f793          	zext.b	a5,a5
 504:	02078863          	beqz	a5,534 <print_dec_int+0x5c>
 508:	fa043703          	ld	a4,-96(s0)
 50c:	fff00793          	li	a5,-1
 510:	03f79793          	slli	a5,a5,0x3f
 514:	02f71063          	bne	a4,a5,534 <print_dec_int+0x5c>
 518:	00001597          	auipc	a1,0x1
 51c:	c1058593          	addi	a1,a1,-1008 # 1128 <printf+0x144>
 520:	fa843503          	ld	a0,-88(s0)
 524:	00000097          	auipc	ra,0x0
 528:	f2c080e7          	jalr	-212(ra) # 450 <puts_wo_nl>
 52c:	00050793          	mv	a5,a0
 530:	2a00006f          	j	7d0 <print_dec_int+0x2f8>
 534:	f9043783          	ld	a5,-112(s0)
 538:	00c7a783          	lw	a5,12(a5)
 53c:	00079a63          	bnez	a5,550 <print_dec_int+0x78>
 540:	fa043783          	ld	a5,-96(s0)
 544:	00079663          	bnez	a5,550 <print_dec_int+0x78>
 548:	00000793          	li	a5,0
 54c:	2840006f          	j	7d0 <print_dec_int+0x2f8>
 550:	fe0407a3          	sb	zero,-17(s0)
 554:	f9f44783          	lbu	a5,-97(s0)
 558:	0ff7f793          	zext.b	a5,a5
 55c:	02078063          	beqz	a5,57c <print_dec_int+0xa4>
 560:	fa043783          	ld	a5,-96(s0)
 564:	0007dc63          	bgez	a5,57c <print_dec_int+0xa4>
 568:	00100793          	li	a5,1
 56c:	fef407a3          	sb	a5,-17(s0)
 570:	fa043783          	ld	a5,-96(s0)
 574:	40f007b3          	neg	a5,a5
 578:	faf43023          	sd	a5,-96(s0)
 57c:	fe042423          	sw	zero,-24(s0)
 580:	f9f44783          	lbu	a5,-97(s0)
 584:	0ff7f793          	zext.b	a5,a5
 588:	02078863          	beqz	a5,5b8 <print_dec_int+0xe0>
 58c:	fef44783          	lbu	a5,-17(s0)
 590:	0ff7f793          	zext.b	a5,a5
 594:	00079e63          	bnez	a5,5b0 <print_dec_int+0xd8>
 598:	f9043783          	ld	a5,-112(s0)
 59c:	0057c783          	lbu	a5,5(a5)
 5a0:	00079863          	bnez	a5,5b0 <print_dec_int+0xd8>
 5a4:	f9043783          	ld	a5,-112(s0)
 5a8:	0047c783          	lbu	a5,4(a5)
 5ac:	00078663          	beqz	a5,5b8 <print_dec_int+0xe0>
 5b0:	00100793          	li	a5,1
 5b4:	0080006f          	j	5bc <print_dec_int+0xe4>
 5b8:	00000793          	li	a5,0
 5bc:	fcf40ba3          	sb	a5,-41(s0)
 5c0:	fd744783          	lbu	a5,-41(s0)
 5c4:	0017f793          	andi	a5,a5,1
 5c8:	fcf40ba3          	sb	a5,-41(s0)
 5cc:	fa043703          	ld	a4,-96(s0)
 5d0:	00a00793          	li	a5,10
 5d4:	02f777b3          	remu	a5,a4,a5
 5d8:	0ff7f713          	zext.b	a4,a5
 5dc:	fe842783          	lw	a5,-24(s0)
 5e0:	0017869b          	addiw	a3,a5,1
 5e4:	fed42423          	sw	a3,-24(s0)
 5e8:	0307071b          	addiw	a4,a4,48
 5ec:	0ff77713          	zext.b	a4,a4
 5f0:	ff078793          	addi	a5,a5,-16
 5f4:	008787b3          	add	a5,a5,s0
 5f8:	fce78423          	sb	a4,-56(a5)
 5fc:	fa043703          	ld	a4,-96(s0)
 600:	00a00793          	li	a5,10
 604:	02f757b3          	divu	a5,a4,a5
 608:	faf43023          	sd	a5,-96(s0)
 60c:	fa043783          	ld	a5,-96(s0)
 610:	fa079ee3          	bnez	a5,5cc <print_dec_int+0xf4>
 614:	f9043783          	ld	a5,-112(s0)
 618:	00c7a783          	lw	a5,12(a5)
 61c:	00078713          	mv	a4,a5
 620:	fff00793          	li	a5,-1
 624:	02f71063          	bne	a4,a5,644 <print_dec_int+0x16c>
 628:	f9043783          	ld	a5,-112(s0)
 62c:	0037c783          	lbu	a5,3(a5)
 630:	00078a63          	beqz	a5,644 <print_dec_int+0x16c>
 634:	f9043783          	ld	a5,-112(s0)
 638:	0087a703          	lw	a4,8(a5)
 63c:	f9043783          	ld	a5,-112(s0)
 640:	00e7a623          	sw	a4,12(a5)
 644:	fe042223          	sw	zero,-28(s0)
 648:	f9043783          	ld	a5,-112(s0)
 64c:	0087a703          	lw	a4,8(a5)
 650:	fe842783          	lw	a5,-24(s0)
 654:	fcf42823          	sw	a5,-48(s0)
 658:	f9043783          	ld	a5,-112(s0)
 65c:	00c7a783          	lw	a5,12(a5)
 660:	fcf42623          	sw	a5,-52(s0)
 664:	fd042783          	lw	a5,-48(s0)
 668:	00078593          	mv	a1,a5
 66c:	fcc42783          	lw	a5,-52(s0)
 670:	00078613          	mv	a2,a5
 674:	0006069b          	sext.w	a3,a2
 678:	0005879b          	sext.w	a5,a1
 67c:	00f6d463          	bge	a3,a5,684 <print_dec_int+0x1ac>
 680:	00058613          	mv	a2,a1
 684:	0006079b          	sext.w	a5,a2
 688:	40f707bb          	subw	a5,a4,a5
 68c:	0007871b          	sext.w	a4,a5
 690:	fd744783          	lbu	a5,-41(s0)
 694:	0007879b          	sext.w	a5,a5
 698:	40f707bb          	subw	a5,a4,a5
 69c:	fef42023          	sw	a5,-32(s0)
 6a0:	0280006f          	j	6c8 <print_dec_int+0x1f0>
 6a4:	fa843783          	ld	a5,-88(s0)
 6a8:	02000513          	li	a0,32
 6ac:	000780e7          	jalr	a5
 6b0:	fe442783          	lw	a5,-28(s0)
 6b4:	0017879b          	addiw	a5,a5,1
 6b8:	fef42223          	sw	a5,-28(s0)
 6bc:	fe042783          	lw	a5,-32(s0)
 6c0:	fff7879b          	addiw	a5,a5,-1
 6c4:	fef42023          	sw	a5,-32(s0)
 6c8:	fe042783          	lw	a5,-32(s0)
 6cc:	0007879b          	sext.w	a5,a5
 6d0:	fcf04ae3          	bgtz	a5,6a4 <print_dec_int+0x1cc>
 6d4:	fd744783          	lbu	a5,-41(s0)
 6d8:	0ff7f793          	zext.b	a5,a5
 6dc:	04078463          	beqz	a5,724 <print_dec_int+0x24c>
 6e0:	fef44783          	lbu	a5,-17(s0)
 6e4:	0ff7f793          	zext.b	a5,a5
 6e8:	00078663          	beqz	a5,6f4 <print_dec_int+0x21c>
 6ec:	02d00793          	li	a5,45
 6f0:	01c0006f          	j	70c <print_dec_int+0x234>
 6f4:	f9043783          	ld	a5,-112(s0)
 6f8:	0057c783          	lbu	a5,5(a5)
 6fc:	00078663          	beqz	a5,708 <print_dec_int+0x230>
 700:	02b00793          	li	a5,43
 704:	0080006f          	j	70c <print_dec_int+0x234>
 708:	02000793          	li	a5,32
 70c:	fa843703          	ld	a4,-88(s0)
 710:	00078513          	mv	a0,a5
 714:	000700e7          	jalr	a4
 718:	fe442783          	lw	a5,-28(s0)
 71c:	0017879b          	addiw	a5,a5,1
 720:	fef42223          	sw	a5,-28(s0)
 724:	fe842783          	lw	a5,-24(s0)
 728:	fcf42e23          	sw	a5,-36(s0)
 72c:	0280006f          	j	754 <print_dec_int+0x27c>
 730:	fa843783          	ld	a5,-88(s0)
 734:	03000513          	li	a0,48
 738:	000780e7          	jalr	a5
 73c:	fe442783          	lw	a5,-28(s0)
 740:	0017879b          	addiw	a5,a5,1
 744:	fef42223          	sw	a5,-28(s0)
 748:	fdc42783          	lw	a5,-36(s0)
 74c:	0017879b          	addiw	a5,a5,1
 750:	fcf42e23          	sw	a5,-36(s0)
 754:	f9043783          	ld	a5,-112(s0)
 758:	00c7a703          	lw	a4,12(a5)
 75c:	fd744783          	lbu	a5,-41(s0)
 760:	0007879b          	sext.w	a5,a5
 764:	40f707bb          	subw	a5,a4,a5
 768:	0007871b          	sext.w	a4,a5
 76c:	fdc42783          	lw	a5,-36(s0)
 770:	0007879b          	sext.w	a5,a5
 774:	fae7cee3          	blt	a5,a4,730 <print_dec_int+0x258>
 778:	fe842783          	lw	a5,-24(s0)
 77c:	fff7879b          	addiw	a5,a5,-1
 780:	fcf42c23          	sw	a5,-40(s0)
 784:	03c0006f          	j	7c0 <print_dec_int+0x2e8>
 788:	fd842783          	lw	a5,-40(s0)
 78c:	ff078793          	addi	a5,a5,-16
 790:	008787b3          	add	a5,a5,s0
 794:	fc87c783          	lbu	a5,-56(a5)
 798:	0007871b          	sext.w	a4,a5
 79c:	fa843783          	ld	a5,-88(s0)
 7a0:	00070513          	mv	a0,a4
 7a4:	000780e7          	jalr	a5
 7a8:	fe442783          	lw	a5,-28(s0)
 7ac:	0017879b          	addiw	a5,a5,1
 7b0:	fef42223          	sw	a5,-28(s0)
 7b4:	fd842783          	lw	a5,-40(s0)
 7b8:	fff7879b          	addiw	a5,a5,-1
 7bc:	fcf42c23          	sw	a5,-40(s0)
 7c0:	fd842783          	lw	a5,-40(s0)
 7c4:	0007879b          	sext.w	a5,a5
 7c8:	fc07d0e3          	bgez	a5,788 <print_dec_int+0x2b0>
 7cc:	fe442783          	lw	a5,-28(s0)
 7d0:	00078513          	mv	a0,a5
 7d4:	06813083          	ld	ra,104(sp)
 7d8:	06013403          	ld	s0,96(sp)
 7dc:	07010113          	addi	sp,sp,112
 7e0:	00008067          	ret

Disassembly of section .text.vprintfmt:

00000000000007e4 <vprintfmt>:
 7e4:	f4010113          	addi	sp,sp,-192
 7e8:	0a113c23          	sd	ra,184(sp)
 7ec:	0a813823          	sd	s0,176(sp)
 7f0:	0c010413          	addi	s0,sp,192
 7f4:	f4a43c23          	sd	a0,-168(s0)
 7f8:	f4b43823          	sd	a1,-176(s0)
 7fc:	f4c43423          	sd	a2,-184(s0)
 800:	f8043023          	sd	zero,-128(s0)
 804:	f8043423          	sd	zero,-120(s0)
 808:	fe042623          	sw	zero,-20(s0)
 80c:	7b40006f          	j	fc0 <vprintfmt+0x7dc>
 810:	f8044783          	lbu	a5,-128(s0)
 814:	74078663          	beqz	a5,f60 <vprintfmt+0x77c>
 818:	f5043783          	ld	a5,-176(s0)
 81c:	0007c783          	lbu	a5,0(a5)
 820:	00078713          	mv	a4,a5
 824:	02300793          	li	a5,35
 828:	00f71863          	bne	a4,a5,838 <vprintfmt+0x54>
 82c:	00100793          	li	a5,1
 830:	f8f40123          	sb	a5,-126(s0)
 834:	7800006f          	j	fb4 <vprintfmt+0x7d0>
 838:	f5043783          	ld	a5,-176(s0)
 83c:	0007c783          	lbu	a5,0(a5)
 840:	00078713          	mv	a4,a5
 844:	03000793          	li	a5,48
 848:	00f71863          	bne	a4,a5,858 <vprintfmt+0x74>
 84c:	00100793          	li	a5,1
 850:	f8f401a3          	sb	a5,-125(s0)
 854:	7600006f          	j	fb4 <vprintfmt+0x7d0>
 858:	f5043783          	ld	a5,-176(s0)
 85c:	0007c783          	lbu	a5,0(a5)
 860:	00078713          	mv	a4,a5
 864:	06c00793          	li	a5,108
 868:	04f70063          	beq	a4,a5,8a8 <vprintfmt+0xc4>
 86c:	f5043783          	ld	a5,-176(s0)
 870:	0007c783          	lbu	a5,0(a5)
 874:	00078713          	mv	a4,a5
 878:	07a00793          	li	a5,122
 87c:	02f70663          	beq	a4,a5,8a8 <vprintfmt+0xc4>
 880:	f5043783          	ld	a5,-176(s0)
 884:	0007c783          	lbu	a5,0(a5)
 888:	00078713          	mv	a4,a5
 88c:	07400793          	li	a5,116
 890:	00f70c63          	beq	a4,a5,8a8 <vprintfmt+0xc4>
 894:	f5043783          	ld	a5,-176(s0)
 898:	0007c783          	lbu	a5,0(a5)
 89c:	00078713          	mv	a4,a5
 8a0:	06a00793          	li	a5,106
 8a4:	00f71863          	bne	a4,a5,8b4 <vprintfmt+0xd0>
 8a8:	00100793          	li	a5,1
 8ac:	f8f400a3          	sb	a5,-127(s0)
 8b0:	7040006f          	j	fb4 <vprintfmt+0x7d0>
 8b4:	f5043783          	ld	a5,-176(s0)
 8b8:	0007c783          	lbu	a5,0(a5)
 8bc:	00078713          	mv	a4,a5
 8c0:	02b00793          	li	a5,43
 8c4:	00f71863          	bne	a4,a5,8d4 <vprintfmt+0xf0>
 8c8:	00100793          	li	a5,1
 8cc:	f8f402a3          	sb	a5,-123(s0)
 8d0:	6e40006f          	j	fb4 <vprintfmt+0x7d0>
 8d4:	f5043783          	ld	a5,-176(s0)
 8d8:	0007c783          	lbu	a5,0(a5)
 8dc:	00078713          	mv	a4,a5
 8e0:	02000793          	li	a5,32
 8e4:	00f71863          	bne	a4,a5,8f4 <vprintfmt+0x110>
 8e8:	00100793          	li	a5,1
 8ec:	f8f40223          	sb	a5,-124(s0)
 8f0:	6c40006f          	j	fb4 <vprintfmt+0x7d0>
 8f4:	f5043783          	ld	a5,-176(s0)
 8f8:	0007c783          	lbu	a5,0(a5)
 8fc:	00078713          	mv	a4,a5
 900:	02a00793          	li	a5,42
 904:	00f71e63          	bne	a4,a5,920 <vprintfmt+0x13c>
 908:	f4843783          	ld	a5,-184(s0)
 90c:	00878713          	addi	a4,a5,8
 910:	f4e43423          	sd	a4,-184(s0)
 914:	0007a783          	lw	a5,0(a5)
 918:	f8f42423          	sw	a5,-120(s0)
 91c:	6980006f          	j	fb4 <vprintfmt+0x7d0>
 920:	f5043783          	ld	a5,-176(s0)
 924:	0007c783          	lbu	a5,0(a5)
 928:	00078713          	mv	a4,a5
 92c:	03000793          	li	a5,48
 930:	04e7f863          	bgeu	a5,a4,980 <vprintfmt+0x19c>
 934:	f5043783          	ld	a5,-176(s0)
 938:	0007c783          	lbu	a5,0(a5)
 93c:	00078713          	mv	a4,a5
 940:	03900793          	li	a5,57
 944:	02e7ee63          	bltu	a5,a4,980 <vprintfmt+0x19c>
 948:	f5043783          	ld	a5,-176(s0)
 94c:	f5040713          	addi	a4,s0,-176
 950:	00a00613          	li	a2,10
 954:	00070593          	mv	a1,a4
 958:	00078513          	mv	a0,a5
 95c:	00000097          	auipc	ra,0x0
 960:	884080e7          	jalr	-1916(ra) # 1e0 <strtol>
 964:	00050793          	mv	a5,a0
 968:	0007879b          	sext.w	a5,a5
 96c:	f8f42423          	sw	a5,-120(s0)
 970:	f5043783          	ld	a5,-176(s0)
 974:	fff78793          	addi	a5,a5,-1
 978:	f4f43823          	sd	a5,-176(s0)
 97c:	6380006f          	j	fb4 <vprintfmt+0x7d0>
 980:	f5043783          	ld	a5,-176(s0)
 984:	0007c783          	lbu	a5,0(a5)
 988:	00078713          	mv	a4,a5
 98c:	02e00793          	li	a5,46
 990:	06f71a63          	bne	a4,a5,a04 <vprintfmt+0x220>
 994:	f5043783          	ld	a5,-176(s0)
 998:	00178793          	addi	a5,a5,1
 99c:	f4f43823          	sd	a5,-176(s0)
 9a0:	f5043783          	ld	a5,-176(s0)
 9a4:	0007c783          	lbu	a5,0(a5)
 9a8:	00078713          	mv	a4,a5
 9ac:	02a00793          	li	a5,42
 9b0:	00f71e63          	bne	a4,a5,9cc <vprintfmt+0x1e8>
 9b4:	f4843783          	ld	a5,-184(s0)
 9b8:	00878713          	addi	a4,a5,8
 9bc:	f4e43423          	sd	a4,-184(s0)
 9c0:	0007a783          	lw	a5,0(a5)
 9c4:	f8f42623          	sw	a5,-116(s0)
 9c8:	5ec0006f          	j	fb4 <vprintfmt+0x7d0>
 9cc:	f5043783          	ld	a5,-176(s0)
 9d0:	f5040713          	addi	a4,s0,-176
 9d4:	00a00613          	li	a2,10
 9d8:	00070593          	mv	a1,a4
 9dc:	00078513          	mv	a0,a5
 9e0:	00000097          	auipc	ra,0x0
 9e4:	800080e7          	jalr	-2048(ra) # 1e0 <strtol>
 9e8:	00050793          	mv	a5,a0
 9ec:	0007879b          	sext.w	a5,a5
 9f0:	f8f42623          	sw	a5,-116(s0)
 9f4:	f5043783          	ld	a5,-176(s0)
 9f8:	fff78793          	addi	a5,a5,-1
 9fc:	f4f43823          	sd	a5,-176(s0)
 a00:	5b40006f          	j	fb4 <vprintfmt+0x7d0>
 a04:	f5043783          	ld	a5,-176(s0)
 a08:	0007c783          	lbu	a5,0(a5)
 a0c:	00078713          	mv	a4,a5
 a10:	07800793          	li	a5,120
 a14:	02f70663          	beq	a4,a5,a40 <vprintfmt+0x25c>
 a18:	f5043783          	ld	a5,-176(s0)
 a1c:	0007c783          	lbu	a5,0(a5)
 a20:	00078713          	mv	a4,a5
 a24:	05800793          	li	a5,88
 a28:	00f70c63          	beq	a4,a5,a40 <vprintfmt+0x25c>
 a2c:	f5043783          	ld	a5,-176(s0)
 a30:	0007c783          	lbu	a5,0(a5)
 a34:	00078713          	mv	a4,a5
 a38:	07000793          	li	a5,112
 a3c:	30f71263          	bne	a4,a5,d40 <vprintfmt+0x55c>
 a40:	f5043783          	ld	a5,-176(s0)
 a44:	0007c783          	lbu	a5,0(a5)
 a48:	00078713          	mv	a4,a5
 a4c:	07000793          	li	a5,112
 a50:	00f70663          	beq	a4,a5,a5c <vprintfmt+0x278>
 a54:	f8144783          	lbu	a5,-127(s0)
 a58:	00078663          	beqz	a5,a64 <vprintfmt+0x280>
 a5c:	00100793          	li	a5,1
 a60:	0080006f          	j	a68 <vprintfmt+0x284>
 a64:	00000793          	li	a5,0
 a68:	faf403a3          	sb	a5,-89(s0)
 a6c:	fa744783          	lbu	a5,-89(s0)
 a70:	0017f793          	andi	a5,a5,1
 a74:	faf403a3          	sb	a5,-89(s0)
 a78:	fa744783          	lbu	a5,-89(s0)
 a7c:	0ff7f793          	zext.b	a5,a5
 a80:	00078c63          	beqz	a5,a98 <vprintfmt+0x2b4>
 a84:	f4843783          	ld	a5,-184(s0)
 a88:	00878713          	addi	a4,a5,8
 a8c:	f4e43423          	sd	a4,-184(s0)
 a90:	0007b783          	ld	a5,0(a5)
 a94:	01c0006f          	j	ab0 <vprintfmt+0x2cc>
 a98:	f4843783          	ld	a5,-184(s0)
 a9c:	00878713          	addi	a4,a5,8
 aa0:	f4e43423          	sd	a4,-184(s0)
 aa4:	0007a783          	lw	a5,0(a5)
 aa8:	02079793          	slli	a5,a5,0x20
 aac:	0207d793          	srli	a5,a5,0x20
 ab0:	fef43023          	sd	a5,-32(s0)
 ab4:	f8c42783          	lw	a5,-116(s0)
 ab8:	02079463          	bnez	a5,ae0 <vprintfmt+0x2fc>
 abc:	fe043783          	ld	a5,-32(s0)
 ac0:	02079063          	bnez	a5,ae0 <vprintfmt+0x2fc>
 ac4:	f5043783          	ld	a5,-176(s0)
 ac8:	0007c783          	lbu	a5,0(a5)
 acc:	00078713          	mv	a4,a5
 ad0:	07000793          	li	a5,112
 ad4:	00f70663          	beq	a4,a5,ae0 <vprintfmt+0x2fc>
 ad8:	f8040023          	sb	zero,-128(s0)
 adc:	4d80006f          	j	fb4 <vprintfmt+0x7d0>
 ae0:	f5043783          	ld	a5,-176(s0)
 ae4:	0007c783          	lbu	a5,0(a5)
 ae8:	00078713          	mv	a4,a5
 aec:	07000793          	li	a5,112
 af0:	00f70a63          	beq	a4,a5,b04 <vprintfmt+0x320>
 af4:	f8244783          	lbu	a5,-126(s0)
 af8:	00078a63          	beqz	a5,b0c <vprintfmt+0x328>
 afc:	fe043783          	ld	a5,-32(s0)
 b00:	00078663          	beqz	a5,b0c <vprintfmt+0x328>
 b04:	00100793          	li	a5,1
 b08:	0080006f          	j	b10 <vprintfmt+0x32c>
 b0c:	00000793          	li	a5,0
 b10:	faf40323          	sb	a5,-90(s0)
 b14:	fa644783          	lbu	a5,-90(s0)
 b18:	0017f793          	andi	a5,a5,1
 b1c:	faf40323          	sb	a5,-90(s0)
 b20:	fc042e23          	sw	zero,-36(s0)
 b24:	f5043783          	ld	a5,-176(s0)
 b28:	0007c783          	lbu	a5,0(a5)
 b2c:	00078713          	mv	a4,a5
 b30:	05800793          	li	a5,88
 b34:	00f71863          	bne	a4,a5,b44 <vprintfmt+0x360>
 b38:	00000797          	auipc	a5,0x0
 b3c:	60878793          	addi	a5,a5,1544 # 1140 <upperxdigits.1>
 b40:	00c0006f          	j	b4c <vprintfmt+0x368>
 b44:	00000797          	auipc	a5,0x0
 b48:	61478793          	addi	a5,a5,1556 # 1158 <lowerxdigits.0>
 b4c:	f8f43c23          	sd	a5,-104(s0)
 b50:	fe043783          	ld	a5,-32(s0)
 b54:	00f7f793          	andi	a5,a5,15
 b58:	f9843703          	ld	a4,-104(s0)
 b5c:	00f70733          	add	a4,a4,a5
 b60:	fdc42783          	lw	a5,-36(s0)
 b64:	0017869b          	addiw	a3,a5,1
 b68:	fcd42e23          	sw	a3,-36(s0)
 b6c:	00074703          	lbu	a4,0(a4)
 b70:	ff078793          	addi	a5,a5,-16
 b74:	008787b3          	add	a5,a5,s0
 b78:	f8e78023          	sb	a4,-128(a5)
 b7c:	fe043783          	ld	a5,-32(s0)
 b80:	0047d793          	srli	a5,a5,0x4
 b84:	fef43023          	sd	a5,-32(s0)
 b88:	fe043783          	ld	a5,-32(s0)
 b8c:	fc0792e3          	bnez	a5,b50 <vprintfmt+0x36c>
 b90:	f8c42783          	lw	a5,-116(s0)
 b94:	00078713          	mv	a4,a5
 b98:	fff00793          	li	a5,-1
 b9c:	02f71663          	bne	a4,a5,bc8 <vprintfmt+0x3e4>
 ba0:	f8344783          	lbu	a5,-125(s0)
 ba4:	02078263          	beqz	a5,bc8 <vprintfmt+0x3e4>
 ba8:	f8842703          	lw	a4,-120(s0)
 bac:	fa644783          	lbu	a5,-90(s0)
 bb0:	0007879b          	sext.w	a5,a5
 bb4:	0017979b          	slliw	a5,a5,0x1
 bb8:	0007879b          	sext.w	a5,a5
 bbc:	40f707bb          	subw	a5,a4,a5
 bc0:	0007879b          	sext.w	a5,a5
 bc4:	f8f42623          	sw	a5,-116(s0)
 bc8:	f8842703          	lw	a4,-120(s0)
 bcc:	fa644783          	lbu	a5,-90(s0)
 bd0:	0007879b          	sext.w	a5,a5
 bd4:	0017979b          	slliw	a5,a5,0x1
 bd8:	0007879b          	sext.w	a5,a5
 bdc:	40f707bb          	subw	a5,a4,a5
 be0:	0007871b          	sext.w	a4,a5
 be4:	fdc42783          	lw	a5,-36(s0)
 be8:	f8f42a23          	sw	a5,-108(s0)
 bec:	f8c42783          	lw	a5,-116(s0)
 bf0:	f8f42823          	sw	a5,-112(s0)
 bf4:	f9442783          	lw	a5,-108(s0)
 bf8:	00078593          	mv	a1,a5
 bfc:	f9042783          	lw	a5,-112(s0)
 c00:	00078613          	mv	a2,a5
 c04:	0006069b          	sext.w	a3,a2
 c08:	0005879b          	sext.w	a5,a1
 c0c:	00f6d463          	bge	a3,a5,c14 <vprintfmt+0x430>
 c10:	00058613          	mv	a2,a1
 c14:	0006079b          	sext.w	a5,a2
 c18:	40f707bb          	subw	a5,a4,a5
 c1c:	fcf42c23          	sw	a5,-40(s0)
 c20:	0280006f          	j	c48 <vprintfmt+0x464>
 c24:	f5843783          	ld	a5,-168(s0)
 c28:	02000513          	li	a0,32
 c2c:	000780e7          	jalr	a5
 c30:	fec42783          	lw	a5,-20(s0)
 c34:	0017879b          	addiw	a5,a5,1
 c38:	fef42623          	sw	a5,-20(s0)
 c3c:	fd842783          	lw	a5,-40(s0)
 c40:	fff7879b          	addiw	a5,a5,-1
 c44:	fcf42c23          	sw	a5,-40(s0)
 c48:	fd842783          	lw	a5,-40(s0)
 c4c:	0007879b          	sext.w	a5,a5
 c50:	fcf04ae3          	bgtz	a5,c24 <vprintfmt+0x440>
 c54:	fa644783          	lbu	a5,-90(s0)
 c58:	0ff7f793          	zext.b	a5,a5
 c5c:	04078463          	beqz	a5,ca4 <vprintfmt+0x4c0>
 c60:	f5843783          	ld	a5,-168(s0)
 c64:	03000513          	li	a0,48
 c68:	000780e7          	jalr	a5
 c6c:	f5043783          	ld	a5,-176(s0)
 c70:	0007c783          	lbu	a5,0(a5)
 c74:	00078713          	mv	a4,a5
 c78:	05800793          	li	a5,88
 c7c:	00f71663          	bne	a4,a5,c88 <vprintfmt+0x4a4>
 c80:	05800793          	li	a5,88
 c84:	0080006f          	j	c8c <vprintfmt+0x4a8>
 c88:	07800793          	li	a5,120
 c8c:	f5843703          	ld	a4,-168(s0)
 c90:	00078513          	mv	a0,a5
 c94:	000700e7          	jalr	a4
 c98:	fec42783          	lw	a5,-20(s0)
 c9c:	0027879b          	addiw	a5,a5,2
 ca0:	fef42623          	sw	a5,-20(s0)
 ca4:	fdc42783          	lw	a5,-36(s0)
 ca8:	fcf42a23          	sw	a5,-44(s0)
 cac:	0280006f          	j	cd4 <vprintfmt+0x4f0>
 cb0:	f5843783          	ld	a5,-168(s0)
 cb4:	03000513          	li	a0,48
 cb8:	000780e7          	jalr	a5
 cbc:	fec42783          	lw	a5,-20(s0)
 cc0:	0017879b          	addiw	a5,a5,1
 cc4:	fef42623          	sw	a5,-20(s0)
 cc8:	fd442783          	lw	a5,-44(s0)
 ccc:	0017879b          	addiw	a5,a5,1
 cd0:	fcf42a23          	sw	a5,-44(s0)
 cd4:	f8c42703          	lw	a4,-116(s0)
 cd8:	fd442783          	lw	a5,-44(s0)
 cdc:	0007879b          	sext.w	a5,a5
 ce0:	fce7c8e3          	blt	a5,a4,cb0 <vprintfmt+0x4cc>
 ce4:	fdc42783          	lw	a5,-36(s0)
 ce8:	fff7879b          	addiw	a5,a5,-1
 cec:	fcf42823          	sw	a5,-48(s0)
 cf0:	03c0006f          	j	d2c <vprintfmt+0x548>
 cf4:	fd042783          	lw	a5,-48(s0)
 cf8:	ff078793          	addi	a5,a5,-16
 cfc:	008787b3          	add	a5,a5,s0
 d00:	f807c783          	lbu	a5,-128(a5)
 d04:	0007871b          	sext.w	a4,a5
 d08:	f5843783          	ld	a5,-168(s0)
 d0c:	00070513          	mv	a0,a4
 d10:	000780e7          	jalr	a5
 d14:	fec42783          	lw	a5,-20(s0)
 d18:	0017879b          	addiw	a5,a5,1
 d1c:	fef42623          	sw	a5,-20(s0)
 d20:	fd042783          	lw	a5,-48(s0)
 d24:	fff7879b          	addiw	a5,a5,-1
 d28:	fcf42823          	sw	a5,-48(s0)
 d2c:	fd042783          	lw	a5,-48(s0)
 d30:	0007879b          	sext.w	a5,a5
 d34:	fc07d0e3          	bgez	a5,cf4 <vprintfmt+0x510>
 d38:	f8040023          	sb	zero,-128(s0)
 d3c:	2780006f          	j	fb4 <vprintfmt+0x7d0>
 d40:	f5043783          	ld	a5,-176(s0)
 d44:	0007c783          	lbu	a5,0(a5)
 d48:	00078713          	mv	a4,a5
 d4c:	06400793          	li	a5,100
 d50:	02f70663          	beq	a4,a5,d7c <vprintfmt+0x598>
 d54:	f5043783          	ld	a5,-176(s0)
 d58:	0007c783          	lbu	a5,0(a5)
 d5c:	00078713          	mv	a4,a5
 d60:	06900793          	li	a5,105
 d64:	00f70c63          	beq	a4,a5,d7c <vprintfmt+0x598>
 d68:	f5043783          	ld	a5,-176(s0)
 d6c:	0007c783          	lbu	a5,0(a5)
 d70:	00078713          	mv	a4,a5
 d74:	07500793          	li	a5,117
 d78:	08f71263          	bne	a4,a5,dfc <vprintfmt+0x618>
 d7c:	f8144783          	lbu	a5,-127(s0)
 d80:	00078c63          	beqz	a5,d98 <vprintfmt+0x5b4>
 d84:	f4843783          	ld	a5,-184(s0)
 d88:	00878713          	addi	a4,a5,8
 d8c:	f4e43423          	sd	a4,-184(s0)
 d90:	0007b783          	ld	a5,0(a5)
 d94:	0140006f          	j	da8 <vprintfmt+0x5c4>
 d98:	f4843783          	ld	a5,-184(s0)
 d9c:	00878713          	addi	a4,a5,8
 da0:	f4e43423          	sd	a4,-184(s0)
 da4:	0007a783          	lw	a5,0(a5)
 da8:	faf43423          	sd	a5,-88(s0)
 dac:	fa843583          	ld	a1,-88(s0)
 db0:	f5043783          	ld	a5,-176(s0)
 db4:	0007c783          	lbu	a5,0(a5)
 db8:	0007871b          	sext.w	a4,a5
 dbc:	07500793          	li	a5,117
 dc0:	40f707b3          	sub	a5,a4,a5
 dc4:	00f037b3          	snez	a5,a5
 dc8:	0ff7f793          	zext.b	a5,a5
 dcc:	f8040713          	addi	a4,s0,-128
 dd0:	00070693          	mv	a3,a4
 dd4:	00078613          	mv	a2,a5
 dd8:	f5843503          	ld	a0,-168(s0)
 ddc:	fffff097          	auipc	ra,0xfffff
 de0:	6fc080e7          	jalr	1788(ra) # 4d8 <print_dec_int>
 de4:	00050793          	mv	a5,a0
 de8:	fec42703          	lw	a4,-20(s0)
 dec:	00f707bb          	addw	a5,a4,a5
 df0:	fef42623          	sw	a5,-20(s0)
 df4:	f8040023          	sb	zero,-128(s0)
 df8:	1bc0006f          	j	fb4 <vprintfmt+0x7d0>
 dfc:	f5043783          	ld	a5,-176(s0)
 e00:	0007c783          	lbu	a5,0(a5)
 e04:	00078713          	mv	a4,a5
 e08:	06e00793          	li	a5,110
 e0c:	04f71c63          	bne	a4,a5,e64 <vprintfmt+0x680>
 e10:	f8144783          	lbu	a5,-127(s0)
 e14:	02078463          	beqz	a5,e3c <vprintfmt+0x658>
 e18:	f4843783          	ld	a5,-184(s0)
 e1c:	00878713          	addi	a4,a5,8
 e20:	f4e43423          	sd	a4,-184(s0)
 e24:	0007b783          	ld	a5,0(a5)
 e28:	faf43823          	sd	a5,-80(s0)
 e2c:	fec42703          	lw	a4,-20(s0)
 e30:	fb043783          	ld	a5,-80(s0)
 e34:	00e7b023          	sd	a4,0(a5)
 e38:	0240006f          	j	e5c <vprintfmt+0x678>
 e3c:	f4843783          	ld	a5,-184(s0)
 e40:	00878713          	addi	a4,a5,8
 e44:	f4e43423          	sd	a4,-184(s0)
 e48:	0007b783          	ld	a5,0(a5)
 e4c:	faf43c23          	sd	a5,-72(s0)
 e50:	fb843783          	ld	a5,-72(s0)
 e54:	fec42703          	lw	a4,-20(s0)
 e58:	00e7a023          	sw	a4,0(a5)
 e5c:	f8040023          	sb	zero,-128(s0)
 e60:	1540006f          	j	fb4 <vprintfmt+0x7d0>
 e64:	f5043783          	ld	a5,-176(s0)
 e68:	0007c783          	lbu	a5,0(a5)
 e6c:	00078713          	mv	a4,a5
 e70:	07300793          	li	a5,115
 e74:	04f71063          	bne	a4,a5,eb4 <vprintfmt+0x6d0>
 e78:	f4843783          	ld	a5,-184(s0)
 e7c:	00878713          	addi	a4,a5,8
 e80:	f4e43423          	sd	a4,-184(s0)
 e84:	0007b783          	ld	a5,0(a5)
 e88:	fcf43023          	sd	a5,-64(s0)
 e8c:	fc043583          	ld	a1,-64(s0)
 e90:	f5843503          	ld	a0,-168(s0)
 e94:	fffff097          	auipc	ra,0xfffff
 e98:	5bc080e7          	jalr	1468(ra) # 450 <puts_wo_nl>
 e9c:	00050793          	mv	a5,a0
 ea0:	fec42703          	lw	a4,-20(s0)
 ea4:	00f707bb          	addw	a5,a4,a5
 ea8:	fef42623          	sw	a5,-20(s0)
 eac:	f8040023          	sb	zero,-128(s0)
 eb0:	1040006f          	j	fb4 <vprintfmt+0x7d0>
 eb4:	f5043783          	ld	a5,-176(s0)
 eb8:	0007c783          	lbu	a5,0(a5)
 ebc:	00078713          	mv	a4,a5
 ec0:	06300793          	li	a5,99
 ec4:	02f71e63          	bne	a4,a5,f00 <vprintfmt+0x71c>
 ec8:	f4843783          	ld	a5,-184(s0)
 ecc:	00878713          	addi	a4,a5,8
 ed0:	f4e43423          	sd	a4,-184(s0)
 ed4:	0007a783          	lw	a5,0(a5)
 ed8:	fcf42623          	sw	a5,-52(s0)
 edc:	fcc42703          	lw	a4,-52(s0)
 ee0:	f5843783          	ld	a5,-168(s0)
 ee4:	00070513          	mv	a0,a4
 ee8:	000780e7          	jalr	a5
 eec:	fec42783          	lw	a5,-20(s0)
 ef0:	0017879b          	addiw	a5,a5,1
 ef4:	fef42623          	sw	a5,-20(s0)
 ef8:	f8040023          	sb	zero,-128(s0)
 efc:	0b80006f          	j	fb4 <vprintfmt+0x7d0>
 f00:	f5043783          	ld	a5,-176(s0)
 f04:	0007c783          	lbu	a5,0(a5)
 f08:	00078713          	mv	a4,a5
 f0c:	02500793          	li	a5,37
 f10:	02f71263          	bne	a4,a5,f34 <vprintfmt+0x750>
 f14:	f5843783          	ld	a5,-168(s0)
 f18:	02500513          	li	a0,37
 f1c:	000780e7          	jalr	a5
 f20:	fec42783          	lw	a5,-20(s0)
 f24:	0017879b          	addiw	a5,a5,1
 f28:	fef42623          	sw	a5,-20(s0)
 f2c:	f8040023          	sb	zero,-128(s0)
 f30:	0840006f          	j	fb4 <vprintfmt+0x7d0>
 f34:	f5043783          	ld	a5,-176(s0)
 f38:	0007c783          	lbu	a5,0(a5)
 f3c:	0007871b          	sext.w	a4,a5
 f40:	f5843783          	ld	a5,-168(s0)
 f44:	00070513          	mv	a0,a4
 f48:	000780e7          	jalr	a5
 f4c:	fec42783          	lw	a5,-20(s0)
 f50:	0017879b          	addiw	a5,a5,1
 f54:	fef42623          	sw	a5,-20(s0)
 f58:	f8040023          	sb	zero,-128(s0)
 f5c:	0580006f          	j	fb4 <vprintfmt+0x7d0>
 f60:	f5043783          	ld	a5,-176(s0)
 f64:	0007c783          	lbu	a5,0(a5)
 f68:	00078713          	mv	a4,a5
 f6c:	02500793          	li	a5,37
 f70:	02f71063          	bne	a4,a5,f90 <vprintfmt+0x7ac>
 f74:	f8043023          	sd	zero,-128(s0)
 f78:	f8043423          	sd	zero,-120(s0)
 f7c:	00100793          	li	a5,1
 f80:	f8f40023          	sb	a5,-128(s0)
 f84:	fff00793          	li	a5,-1
 f88:	f8f42623          	sw	a5,-116(s0)
 f8c:	0280006f          	j	fb4 <vprintfmt+0x7d0>
 f90:	f5043783          	ld	a5,-176(s0)
 f94:	0007c783          	lbu	a5,0(a5)
 f98:	0007871b          	sext.w	a4,a5
 f9c:	f5843783          	ld	a5,-168(s0)
 fa0:	00070513          	mv	a0,a4
 fa4:	000780e7          	jalr	a5
 fa8:	fec42783          	lw	a5,-20(s0)
 fac:	0017879b          	addiw	a5,a5,1
 fb0:	fef42623          	sw	a5,-20(s0)
 fb4:	f5043783          	ld	a5,-176(s0)
 fb8:	00178793          	addi	a5,a5,1
 fbc:	f4f43823          	sd	a5,-176(s0)
 fc0:	f5043783          	ld	a5,-176(s0)
 fc4:	0007c783          	lbu	a5,0(a5)
 fc8:	840794e3          	bnez	a5,810 <vprintfmt+0x2c>
 fcc:	fec42783          	lw	a5,-20(s0)
 fd0:	00078513          	mv	a0,a5
 fd4:	0b813083          	ld	ra,184(sp)
 fd8:	0b013403          	ld	s0,176(sp)
 fdc:	0c010113          	addi	sp,sp,192
 fe0:	00008067          	ret

Disassembly of section .text.printf:

0000000000000fe4 <printf>:
     fe4:	f8010113          	addi	sp,sp,-128
     fe8:	02113c23          	sd	ra,56(sp)
     fec:	02813823          	sd	s0,48(sp)
     ff0:	04010413          	addi	s0,sp,64
     ff4:	fca43423          	sd	a0,-56(s0)
     ff8:	00b43423          	sd	a1,8(s0)
     ffc:	00c43823          	sd	a2,16(s0)
    1000:	00d43c23          	sd	a3,24(s0)
    1004:	02e43023          	sd	a4,32(s0)
    1008:	02f43423          	sd	a5,40(s0)
    100c:	03043823          	sd	a6,48(s0)
    1010:	03143c23          	sd	a7,56(s0)
    1014:	fe042623          	sw	zero,-20(s0)
    1018:	04040793          	addi	a5,s0,64
    101c:	fcf43023          	sd	a5,-64(s0)
    1020:	fc043783          	ld	a5,-64(s0)
    1024:	fc878793          	addi	a5,a5,-56
    1028:	fcf43823          	sd	a5,-48(s0)
    102c:	fd043783          	ld	a5,-48(s0)
    1030:	00078613          	mv	a2,a5
    1034:	fc843583          	ld	a1,-56(s0)
    1038:	fffff517          	auipc	a0,0xfffff
    103c:	0e050513          	addi	a0,a0,224 # 118 <putc>
    1040:	fffff097          	auipc	ra,0xfffff
    1044:	7a4080e7          	jalr	1956(ra) # 7e4 <vprintfmt>
    1048:	00050793          	mv	a5,a0
    104c:	fef42623          	sw	a5,-20(s0)
    1050:	00100793          	li	a5,1
    1054:	fef43023          	sd	a5,-32(s0)
    1058:	00000797          	auipc	a5,0x0
    105c:	11878793          	addi	a5,a5,280 # 1170 <tail>
    1060:	0007a783          	lw	a5,0(a5)
    1064:	0017871b          	addiw	a4,a5,1
    1068:	0007069b          	sext.w	a3,a4
    106c:	00000717          	auipc	a4,0x0
    1070:	10470713          	addi	a4,a4,260 # 1170 <tail>
    1074:	00d72023          	sw	a3,0(a4)
    1078:	00000717          	auipc	a4,0x0
    107c:	10070713          	addi	a4,a4,256 # 1178 <buffer>
    1080:	00f707b3          	add	a5,a4,a5
    1084:	00078023          	sb	zero,0(a5)
    1088:	00000797          	auipc	a5,0x0
    108c:	0e878793          	addi	a5,a5,232 # 1170 <tail>
    1090:	0007a603          	lw	a2,0(a5)
    1094:	fe043703          	ld	a4,-32(s0)
    1098:	00000697          	auipc	a3,0x0
    109c:	0e068693          	addi	a3,a3,224 # 1178 <buffer>
    10a0:	fd843783          	ld	a5,-40(s0)
    10a4:	04000893          	li	a7,64
    10a8:	00070513          	mv	a0,a4
    10ac:	00068593          	mv	a1,a3
    10b0:	00060613          	mv	a2,a2
    10b4:	00000073          	ecall
    10b8:	00050793          	mv	a5,a0
    10bc:	fcf43c23          	sd	a5,-40(s0)
    10c0:	00000797          	auipc	a5,0x0
    10c4:	0b078793          	addi	a5,a5,176 # 1170 <tail>
    10c8:	0007a023          	sw	zero,0(a5)
    10cc:	fec42783          	lw	a5,-20(s0)
    10d0:	00078513          	mv	a0,a5
    10d4:	03813083          	ld	ra,56(sp)
    10d8:	03013403          	ld	s0,48(sp)
    10dc:	08010113          	addi	sp,sp,128
    10e0:	00008067          	ret
