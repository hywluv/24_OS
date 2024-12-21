
uapp.elf:     file format elf64-littleriscv


Disassembly of section .text.init:

0000000000000000 <_start>:
   0:	0c00006f          	j	c0 <main>

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

Disassembly of section .text.fork:

0000000000000038 <fork>:
  38:	fe010113          	addi	sp,sp,-32
  3c:	00813c23          	sd	s0,24(sp)
  40:	02010413          	addi	s0,sp,32
  44:	fe843783          	ld	a5,-24(s0)
  48:	0dc00893          	li	a7,220
  4c:	00000073          	ecall
  50:	00050793          	mv	a5,a0
  54:	fef43423          	sd	a5,-24(s0)
  58:	fe843783          	ld	a5,-24(s0)
  5c:	00078513          	mv	a0,a5
  60:	01813403          	ld	s0,24(sp)
  64:	02010113          	addi	sp,sp,32
  68:	00008067          	ret

Disassembly of section .text.wait:

000000000000006c <wait>:
  6c:	fd010113          	addi	sp,sp,-48
  70:	02813423          	sd	s0,40(sp)
  74:	03010413          	addi	s0,sp,48
  78:	00050793          	mv	a5,a0
  7c:	fcf42e23          	sw	a5,-36(s0)
  80:	fe042623          	sw	zero,-20(s0)
  84:	0100006f          	j	94 <wait+0x28>
  88:	fec42783          	lw	a5,-20(s0)
  8c:	0017879b          	addiw	a5,a5,1
  90:	fef42623          	sw	a5,-20(s0)
  94:	fec42783          	lw	a5,-20(s0)
  98:	00078713          	mv	a4,a5
  9c:	fdc42783          	lw	a5,-36(s0)
  a0:	0007071b          	sext.w	a4,a4
  a4:	0007879b          	sext.w	a5,a5
  a8:	fef760e3          	bltu	a4,a5,88 <wait+0x1c>
  ac:	00000013          	nop
  b0:	00000013          	nop
  b4:	02813403          	ld	s0,40(sp)
  b8:	03010113          	addi	sp,sp,48
  bc:	00008067          	ret

Disassembly of section .text.main:

00000000000000c0 <main>:
  c0:	fe010113          	addi	sp,sp,-32
  c4:	00113c23          	sd	ra,24(sp)
  c8:	00813823          	sd	s0,16(sp)
  cc:	02010413          	addi	s0,sp,32
  d0:	00000097          	auipc	ra,0x0
  d4:	f68080e7          	jalr	-152(ra) # 38 <fork>
  d8:	00050793          	mv	a5,a0
  dc:	fef42623          	sw	a5,-20(s0)
  e0:	fec42783          	lw	a5,-20(s0)
  e4:	0007879b          	sext.w	a5,a5
  e8:	04079c63          	bnez	a5,140 <main+0x80>
  ec:	00000097          	auipc	ra,0x0
  f0:	f18080e7          	jalr	-232(ra) # 4 <getpid>
  f4:	00050593          	mv	a1,a0
  f8:	00001797          	auipc	a5,0x1
  fc:	12478793          	addi	a5,a5,292 # 121c <global_variable>
 100:	0007a783          	lw	a5,0(a5)
 104:	0017871b          	addiw	a4,a5,1
 108:	0007069b          	sext.w	a3,a4
 10c:	00001717          	auipc	a4,0x1
 110:	11070713          	addi	a4,a4,272 # 121c <global_variable>
 114:	00d72023          	sw	a3,0(a4)
 118:	00078613          	mv	a2,a5
 11c:	00001517          	auipc	a0,0x1
 120:	04450513          	addi	a0,a0,68 # 1160 <printf+0x100>
 124:	00001097          	auipc	ra,0x1
 128:	f3c080e7          	jalr	-196(ra) # 1060 <printf>
 12c:	500007b7          	lui	a5,0x50000
 130:	fff78513          	addi	a0,a5,-1 # 4fffffff <buffer+0x4fffedd7>
 134:	00000097          	auipc	ra,0x0
 138:	f38080e7          	jalr	-200(ra) # 6c <wait>
 13c:	fb1ff06f          	j	ec <main+0x2c>
 140:	00000097          	auipc	ra,0x0
 144:	ec4080e7          	jalr	-316(ra) # 4 <getpid>
 148:	00050593          	mv	a1,a0
 14c:	00001797          	auipc	a5,0x1
 150:	0d078793          	addi	a5,a5,208 # 121c <global_variable>
 154:	0007a783          	lw	a5,0(a5)
 158:	0017871b          	addiw	a4,a5,1
 15c:	0007069b          	sext.w	a3,a4
 160:	00001717          	auipc	a4,0x1
 164:	0bc70713          	addi	a4,a4,188 # 121c <global_variable>
 168:	00d72023          	sw	a3,0(a4)
 16c:	00078613          	mv	a2,a5
 170:	00001517          	auipc	a0,0x1
 174:	02850513          	addi	a0,a0,40 # 1198 <printf+0x138>
 178:	00001097          	auipc	ra,0x1
 17c:	ee8080e7          	jalr	-280(ra) # 1060 <printf>
 180:	500007b7          	lui	a5,0x50000
 184:	fff78513          	addi	a0,a5,-1 # 4fffffff <buffer+0x4fffedd7>
 188:	00000097          	auipc	ra,0x0
 18c:	ee4080e7          	jalr	-284(ra) # 6c <wait>
 190:	fb1ff06f          	j	140 <main+0x80>

Disassembly of section .text.putc:

0000000000000194 <putc>:
 194:	fe010113          	addi	sp,sp,-32
 198:	00813c23          	sd	s0,24(sp)
 19c:	02010413          	addi	s0,sp,32
 1a0:	00050793          	mv	a5,a0
 1a4:	fef42623          	sw	a5,-20(s0)
 1a8:	00001797          	auipc	a5,0x1
 1ac:	07878793          	addi	a5,a5,120 # 1220 <tail>
 1b0:	0007a783          	lw	a5,0(a5)
 1b4:	0017871b          	addiw	a4,a5,1
 1b8:	0007069b          	sext.w	a3,a4
 1bc:	00001717          	auipc	a4,0x1
 1c0:	06470713          	addi	a4,a4,100 # 1220 <tail>
 1c4:	00d72023          	sw	a3,0(a4)
 1c8:	fec42703          	lw	a4,-20(s0)
 1cc:	0ff77713          	zext.b	a4,a4
 1d0:	00001697          	auipc	a3,0x1
 1d4:	05868693          	addi	a3,a3,88 # 1228 <buffer>
 1d8:	00f687b3          	add	a5,a3,a5
 1dc:	00e78023          	sb	a4,0(a5)
 1e0:	fec42783          	lw	a5,-20(s0)
 1e4:	0ff7f793          	zext.b	a5,a5
 1e8:	0007879b          	sext.w	a5,a5
 1ec:	00078513          	mv	a0,a5
 1f0:	01813403          	ld	s0,24(sp)
 1f4:	02010113          	addi	sp,sp,32
 1f8:	00008067          	ret

Disassembly of section .text.isspace:

00000000000001fc <isspace>:
 1fc:	fe010113          	addi	sp,sp,-32
 200:	00813c23          	sd	s0,24(sp)
 204:	02010413          	addi	s0,sp,32
 208:	00050793          	mv	a5,a0
 20c:	fef42623          	sw	a5,-20(s0)
 210:	fec42783          	lw	a5,-20(s0)
 214:	0007871b          	sext.w	a4,a5
 218:	02000793          	li	a5,32
 21c:	02f70263          	beq	a4,a5,240 <isspace+0x44>
 220:	fec42783          	lw	a5,-20(s0)
 224:	0007871b          	sext.w	a4,a5
 228:	00800793          	li	a5,8
 22c:	00e7de63          	bge	a5,a4,248 <isspace+0x4c>
 230:	fec42783          	lw	a5,-20(s0)
 234:	0007871b          	sext.w	a4,a5
 238:	00d00793          	li	a5,13
 23c:	00e7c663          	blt	a5,a4,248 <isspace+0x4c>
 240:	00100793          	li	a5,1
 244:	0080006f          	j	24c <isspace+0x50>
 248:	00000793          	li	a5,0
 24c:	00078513          	mv	a0,a5
 250:	01813403          	ld	s0,24(sp)
 254:	02010113          	addi	sp,sp,32
 258:	00008067          	ret

Disassembly of section .text.strtol:

000000000000025c <strtol>:
 25c:	fb010113          	addi	sp,sp,-80
 260:	04113423          	sd	ra,72(sp)
 264:	04813023          	sd	s0,64(sp)
 268:	05010413          	addi	s0,sp,80
 26c:	fca43423          	sd	a0,-56(s0)
 270:	fcb43023          	sd	a1,-64(s0)
 274:	00060793          	mv	a5,a2
 278:	faf42e23          	sw	a5,-68(s0)
 27c:	fe043423          	sd	zero,-24(s0)
 280:	fe0403a3          	sb	zero,-25(s0)
 284:	fc843783          	ld	a5,-56(s0)
 288:	fcf43c23          	sd	a5,-40(s0)
 28c:	0100006f          	j	29c <strtol+0x40>
 290:	fd843783          	ld	a5,-40(s0)
 294:	00178793          	addi	a5,a5,1
 298:	fcf43c23          	sd	a5,-40(s0)
 29c:	fd843783          	ld	a5,-40(s0)
 2a0:	0007c783          	lbu	a5,0(a5)
 2a4:	0007879b          	sext.w	a5,a5
 2a8:	00078513          	mv	a0,a5
 2ac:	00000097          	auipc	ra,0x0
 2b0:	f50080e7          	jalr	-176(ra) # 1fc <isspace>
 2b4:	00050793          	mv	a5,a0
 2b8:	fc079ce3          	bnez	a5,290 <strtol+0x34>
 2bc:	fd843783          	ld	a5,-40(s0)
 2c0:	0007c783          	lbu	a5,0(a5)
 2c4:	00078713          	mv	a4,a5
 2c8:	02d00793          	li	a5,45
 2cc:	00f71e63          	bne	a4,a5,2e8 <strtol+0x8c>
 2d0:	00100793          	li	a5,1
 2d4:	fef403a3          	sb	a5,-25(s0)
 2d8:	fd843783          	ld	a5,-40(s0)
 2dc:	00178793          	addi	a5,a5,1
 2e0:	fcf43c23          	sd	a5,-40(s0)
 2e4:	0240006f          	j	308 <strtol+0xac>
 2e8:	fd843783          	ld	a5,-40(s0)
 2ec:	0007c783          	lbu	a5,0(a5)
 2f0:	00078713          	mv	a4,a5
 2f4:	02b00793          	li	a5,43
 2f8:	00f71863          	bne	a4,a5,308 <strtol+0xac>
 2fc:	fd843783          	ld	a5,-40(s0)
 300:	00178793          	addi	a5,a5,1
 304:	fcf43c23          	sd	a5,-40(s0)
 308:	fbc42783          	lw	a5,-68(s0)
 30c:	0007879b          	sext.w	a5,a5
 310:	06079c63          	bnez	a5,388 <strtol+0x12c>
 314:	fd843783          	ld	a5,-40(s0)
 318:	0007c783          	lbu	a5,0(a5)
 31c:	00078713          	mv	a4,a5
 320:	03000793          	li	a5,48
 324:	04f71e63          	bne	a4,a5,380 <strtol+0x124>
 328:	fd843783          	ld	a5,-40(s0)
 32c:	00178793          	addi	a5,a5,1
 330:	fcf43c23          	sd	a5,-40(s0)
 334:	fd843783          	ld	a5,-40(s0)
 338:	0007c783          	lbu	a5,0(a5)
 33c:	00078713          	mv	a4,a5
 340:	07800793          	li	a5,120
 344:	00f70c63          	beq	a4,a5,35c <strtol+0x100>
 348:	fd843783          	ld	a5,-40(s0)
 34c:	0007c783          	lbu	a5,0(a5)
 350:	00078713          	mv	a4,a5
 354:	05800793          	li	a5,88
 358:	00f71e63          	bne	a4,a5,374 <strtol+0x118>
 35c:	01000793          	li	a5,16
 360:	faf42e23          	sw	a5,-68(s0)
 364:	fd843783          	ld	a5,-40(s0)
 368:	00178793          	addi	a5,a5,1
 36c:	fcf43c23          	sd	a5,-40(s0)
 370:	0180006f          	j	388 <strtol+0x12c>
 374:	00800793          	li	a5,8
 378:	faf42e23          	sw	a5,-68(s0)
 37c:	00c0006f          	j	388 <strtol+0x12c>
 380:	00a00793          	li	a5,10
 384:	faf42e23          	sw	a5,-68(s0)
 388:	fd843783          	ld	a5,-40(s0)
 38c:	0007c783          	lbu	a5,0(a5)
 390:	00078713          	mv	a4,a5
 394:	02f00793          	li	a5,47
 398:	02e7f863          	bgeu	a5,a4,3c8 <strtol+0x16c>
 39c:	fd843783          	ld	a5,-40(s0)
 3a0:	0007c783          	lbu	a5,0(a5)
 3a4:	00078713          	mv	a4,a5
 3a8:	03900793          	li	a5,57
 3ac:	00e7ee63          	bltu	a5,a4,3c8 <strtol+0x16c>
 3b0:	fd843783          	ld	a5,-40(s0)
 3b4:	0007c783          	lbu	a5,0(a5)
 3b8:	0007879b          	sext.w	a5,a5
 3bc:	fd07879b          	addiw	a5,a5,-48
 3c0:	fcf42a23          	sw	a5,-44(s0)
 3c4:	0800006f          	j	444 <strtol+0x1e8>
 3c8:	fd843783          	ld	a5,-40(s0)
 3cc:	0007c783          	lbu	a5,0(a5)
 3d0:	00078713          	mv	a4,a5
 3d4:	06000793          	li	a5,96
 3d8:	02e7f863          	bgeu	a5,a4,408 <strtol+0x1ac>
 3dc:	fd843783          	ld	a5,-40(s0)
 3e0:	0007c783          	lbu	a5,0(a5)
 3e4:	00078713          	mv	a4,a5
 3e8:	07a00793          	li	a5,122
 3ec:	00e7ee63          	bltu	a5,a4,408 <strtol+0x1ac>
 3f0:	fd843783          	ld	a5,-40(s0)
 3f4:	0007c783          	lbu	a5,0(a5)
 3f8:	0007879b          	sext.w	a5,a5
 3fc:	fa97879b          	addiw	a5,a5,-87
 400:	fcf42a23          	sw	a5,-44(s0)
 404:	0400006f          	j	444 <strtol+0x1e8>
 408:	fd843783          	ld	a5,-40(s0)
 40c:	0007c783          	lbu	a5,0(a5)
 410:	00078713          	mv	a4,a5
 414:	04000793          	li	a5,64
 418:	06e7f863          	bgeu	a5,a4,488 <strtol+0x22c>
 41c:	fd843783          	ld	a5,-40(s0)
 420:	0007c783          	lbu	a5,0(a5)
 424:	00078713          	mv	a4,a5
 428:	05a00793          	li	a5,90
 42c:	04e7ee63          	bltu	a5,a4,488 <strtol+0x22c>
 430:	fd843783          	ld	a5,-40(s0)
 434:	0007c783          	lbu	a5,0(a5)
 438:	0007879b          	sext.w	a5,a5
 43c:	fc97879b          	addiw	a5,a5,-55
 440:	fcf42a23          	sw	a5,-44(s0)
 444:	fd442783          	lw	a5,-44(s0)
 448:	00078713          	mv	a4,a5
 44c:	fbc42783          	lw	a5,-68(s0)
 450:	0007071b          	sext.w	a4,a4
 454:	0007879b          	sext.w	a5,a5
 458:	02f75663          	bge	a4,a5,484 <strtol+0x228>
 45c:	fbc42703          	lw	a4,-68(s0)
 460:	fe843783          	ld	a5,-24(s0)
 464:	02f70733          	mul	a4,a4,a5
 468:	fd442783          	lw	a5,-44(s0)
 46c:	00f707b3          	add	a5,a4,a5
 470:	fef43423          	sd	a5,-24(s0)
 474:	fd843783          	ld	a5,-40(s0)
 478:	00178793          	addi	a5,a5,1
 47c:	fcf43c23          	sd	a5,-40(s0)
 480:	f09ff06f          	j	388 <strtol+0x12c>
 484:	00000013          	nop
 488:	fc043783          	ld	a5,-64(s0)
 48c:	00078863          	beqz	a5,49c <strtol+0x240>
 490:	fc043783          	ld	a5,-64(s0)
 494:	fd843703          	ld	a4,-40(s0)
 498:	00e7b023          	sd	a4,0(a5)
 49c:	fe744783          	lbu	a5,-25(s0)
 4a0:	0ff7f793          	zext.b	a5,a5
 4a4:	00078863          	beqz	a5,4b4 <strtol+0x258>
 4a8:	fe843783          	ld	a5,-24(s0)
 4ac:	40f007b3          	neg	a5,a5
 4b0:	0080006f          	j	4b8 <strtol+0x25c>
 4b4:	fe843783          	ld	a5,-24(s0)
 4b8:	00078513          	mv	a0,a5
 4bc:	04813083          	ld	ra,72(sp)
 4c0:	04013403          	ld	s0,64(sp)
 4c4:	05010113          	addi	sp,sp,80
 4c8:	00008067          	ret

Disassembly of section .text.puts_wo_nl:

00000000000004cc <puts_wo_nl>:
 4cc:	fd010113          	addi	sp,sp,-48
 4d0:	02113423          	sd	ra,40(sp)
 4d4:	02813023          	sd	s0,32(sp)
 4d8:	03010413          	addi	s0,sp,48
 4dc:	fca43c23          	sd	a0,-40(s0)
 4e0:	fcb43823          	sd	a1,-48(s0)
 4e4:	fd043783          	ld	a5,-48(s0)
 4e8:	00079863          	bnez	a5,4f8 <puts_wo_nl+0x2c>
 4ec:	00001797          	auipc	a5,0x1
 4f0:	ce478793          	addi	a5,a5,-796 # 11d0 <printf+0x170>
 4f4:	fcf43823          	sd	a5,-48(s0)
 4f8:	fd043783          	ld	a5,-48(s0)
 4fc:	fef43423          	sd	a5,-24(s0)
 500:	0240006f          	j	524 <puts_wo_nl+0x58>
 504:	fe843783          	ld	a5,-24(s0)
 508:	00178713          	addi	a4,a5,1
 50c:	fee43423          	sd	a4,-24(s0)
 510:	0007c783          	lbu	a5,0(a5)
 514:	0007871b          	sext.w	a4,a5
 518:	fd843783          	ld	a5,-40(s0)
 51c:	00070513          	mv	a0,a4
 520:	000780e7          	jalr	a5
 524:	fe843783          	ld	a5,-24(s0)
 528:	0007c783          	lbu	a5,0(a5)
 52c:	fc079ce3          	bnez	a5,504 <puts_wo_nl+0x38>
 530:	fe843703          	ld	a4,-24(s0)
 534:	fd043783          	ld	a5,-48(s0)
 538:	40f707b3          	sub	a5,a4,a5
 53c:	0007879b          	sext.w	a5,a5
 540:	00078513          	mv	a0,a5
 544:	02813083          	ld	ra,40(sp)
 548:	02013403          	ld	s0,32(sp)
 54c:	03010113          	addi	sp,sp,48
 550:	00008067          	ret

Disassembly of section .text.print_dec_int:

0000000000000554 <print_dec_int>:
 554:	f9010113          	addi	sp,sp,-112
 558:	06113423          	sd	ra,104(sp)
 55c:	06813023          	sd	s0,96(sp)
 560:	07010413          	addi	s0,sp,112
 564:	faa43423          	sd	a0,-88(s0)
 568:	fab43023          	sd	a1,-96(s0)
 56c:	00060793          	mv	a5,a2
 570:	f8d43823          	sd	a3,-112(s0)
 574:	f8f40fa3          	sb	a5,-97(s0)
 578:	f9f44783          	lbu	a5,-97(s0)
 57c:	0ff7f793          	zext.b	a5,a5
 580:	02078863          	beqz	a5,5b0 <print_dec_int+0x5c>
 584:	fa043703          	ld	a4,-96(s0)
 588:	fff00793          	li	a5,-1
 58c:	03f79793          	slli	a5,a5,0x3f
 590:	02f71063          	bne	a4,a5,5b0 <print_dec_int+0x5c>
 594:	00001597          	auipc	a1,0x1
 598:	c4458593          	addi	a1,a1,-956 # 11d8 <printf+0x178>
 59c:	fa843503          	ld	a0,-88(s0)
 5a0:	00000097          	auipc	ra,0x0
 5a4:	f2c080e7          	jalr	-212(ra) # 4cc <puts_wo_nl>
 5a8:	00050793          	mv	a5,a0
 5ac:	2a00006f          	j	84c <print_dec_int+0x2f8>
 5b0:	f9043783          	ld	a5,-112(s0)
 5b4:	00c7a783          	lw	a5,12(a5)
 5b8:	00079a63          	bnez	a5,5cc <print_dec_int+0x78>
 5bc:	fa043783          	ld	a5,-96(s0)
 5c0:	00079663          	bnez	a5,5cc <print_dec_int+0x78>
 5c4:	00000793          	li	a5,0
 5c8:	2840006f          	j	84c <print_dec_int+0x2f8>
 5cc:	fe0407a3          	sb	zero,-17(s0)
 5d0:	f9f44783          	lbu	a5,-97(s0)
 5d4:	0ff7f793          	zext.b	a5,a5
 5d8:	02078063          	beqz	a5,5f8 <print_dec_int+0xa4>
 5dc:	fa043783          	ld	a5,-96(s0)
 5e0:	0007dc63          	bgez	a5,5f8 <print_dec_int+0xa4>
 5e4:	00100793          	li	a5,1
 5e8:	fef407a3          	sb	a5,-17(s0)
 5ec:	fa043783          	ld	a5,-96(s0)
 5f0:	40f007b3          	neg	a5,a5
 5f4:	faf43023          	sd	a5,-96(s0)
 5f8:	fe042423          	sw	zero,-24(s0)
 5fc:	f9f44783          	lbu	a5,-97(s0)
 600:	0ff7f793          	zext.b	a5,a5
 604:	02078863          	beqz	a5,634 <print_dec_int+0xe0>
 608:	fef44783          	lbu	a5,-17(s0)
 60c:	0ff7f793          	zext.b	a5,a5
 610:	00079e63          	bnez	a5,62c <print_dec_int+0xd8>
 614:	f9043783          	ld	a5,-112(s0)
 618:	0057c783          	lbu	a5,5(a5)
 61c:	00079863          	bnez	a5,62c <print_dec_int+0xd8>
 620:	f9043783          	ld	a5,-112(s0)
 624:	0047c783          	lbu	a5,4(a5)
 628:	00078663          	beqz	a5,634 <print_dec_int+0xe0>
 62c:	00100793          	li	a5,1
 630:	0080006f          	j	638 <print_dec_int+0xe4>
 634:	00000793          	li	a5,0
 638:	fcf40ba3          	sb	a5,-41(s0)
 63c:	fd744783          	lbu	a5,-41(s0)
 640:	0017f793          	andi	a5,a5,1
 644:	fcf40ba3          	sb	a5,-41(s0)
 648:	fa043703          	ld	a4,-96(s0)
 64c:	00a00793          	li	a5,10
 650:	02f777b3          	remu	a5,a4,a5
 654:	0ff7f713          	zext.b	a4,a5
 658:	fe842783          	lw	a5,-24(s0)
 65c:	0017869b          	addiw	a3,a5,1
 660:	fed42423          	sw	a3,-24(s0)
 664:	0307071b          	addiw	a4,a4,48
 668:	0ff77713          	zext.b	a4,a4
 66c:	ff078793          	addi	a5,a5,-16
 670:	008787b3          	add	a5,a5,s0
 674:	fce78423          	sb	a4,-56(a5)
 678:	fa043703          	ld	a4,-96(s0)
 67c:	00a00793          	li	a5,10
 680:	02f757b3          	divu	a5,a4,a5
 684:	faf43023          	sd	a5,-96(s0)
 688:	fa043783          	ld	a5,-96(s0)
 68c:	fa079ee3          	bnez	a5,648 <print_dec_int+0xf4>
 690:	f9043783          	ld	a5,-112(s0)
 694:	00c7a783          	lw	a5,12(a5)
 698:	00078713          	mv	a4,a5
 69c:	fff00793          	li	a5,-1
 6a0:	02f71063          	bne	a4,a5,6c0 <print_dec_int+0x16c>
 6a4:	f9043783          	ld	a5,-112(s0)
 6a8:	0037c783          	lbu	a5,3(a5)
 6ac:	00078a63          	beqz	a5,6c0 <print_dec_int+0x16c>
 6b0:	f9043783          	ld	a5,-112(s0)
 6b4:	0087a703          	lw	a4,8(a5)
 6b8:	f9043783          	ld	a5,-112(s0)
 6bc:	00e7a623          	sw	a4,12(a5)
 6c0:	fe042223          	sw	zero,-28(s0)
 6c4:	f9043783          	ld	a5,-112(s0)
 6c8:	0087a703          	lw	a4,8(a5)
 6cc:	fe842783          	lw	a5,-24(s0)
 6d0:	fcf42823          	sw	a5,-48(s0)
 6d4:	f9043783          	ld	a5,-112(s0)
 6d8:	00c7a783          	lw	a5,12(a5)
 6dc:	fcf42623          	sw	a5,-52(s0)
 6e0:	fd042783          	lw	a5,-48(s0)
 6e4:	00078593          	mv	a1,a5
 6e8:	fcc42783          	lw	a5,-52(s0)
 6ec:	00078613          	mv	a2,a5
 6f0:	0006069b          	sext.w	a3,a2
 6f4:	0005879b          	sext.w	a5,a1
 6f8:	00f6d463          	bge	a3,a5,700 <print_dec_int+0x1ac>
 6fc:	00058613          	mv	a2,a1
 700:	0006079b          	sext.w	a5,a2
 704:	40f707bb          	subw	a5,a4,a5
 708:	0007871b          	sext.w	a4,a5
 70c:	fd744783          	lbu	a5,-41(s0)
 710:	0007879b          	sext.w	a5,a5
 714:	40f707bb          	subw	a5,a4,a5
 718:	fef42023          	sw	a5,-32(s0)
 71c:	0280006f          	j	744 <print_dec_int+0x1f0>
 720:	fa843783          	ld	a5,-88(s0)
 724:	02000513          	li	a0,32
 728:	000780e7          	jalr	a5
 72c:	fe442783          	lw	a5,-28(s0)
 730:	0017879b          	addiw	a5,a5,1
 734:	fef42223          	sw	a5,-28(s0)
 738:	fe042783          	lw	a5,-32(s0)
 73c:	fff7879b          	addiw	a5,a5,-1
 740:	fef42023          	sw	a5,-32(s0)
 744:	fe042783          	lw	a5,-32(s0)
 748:	0007879b          	sext.w	a5,a5
 74c:	fcf04ae3          	bgtz	a5,720 <print_dec_int+0x1cc>
 750:	fd744783          	lbu	a5,-41(s0)
 754:	0ff7f793          	zext.b	a5,a5
 758:	04078463          	beqz	a5,7a0 <print_dec_int+0x24c>
 75c:	fef44783          	lbu	a5,-17(s0)
 760:	0ff7f793          	zext.b	a5,a5
 764:	00078663          	beqz	a5,770 <print_dec_int+0x21c>
 768:	02d00793          	li	a5,45
 76c:	01c0006f          	j	788 <print_dec_int+0x234>
 770:	f9043783          	ld	a5,-112(s0)
 774:	0057c783          	lbu	a5,5(a5)
 778:	00078663          	beqz	a5,784 <print_dec_int+0x230>
 77c:	02b00793          	li	a5,43
 780:	0080006f          	j	788 <print_dec_int+0x234>
 784:	02000793          	li	a5,32
 788:	fa843703          	ld	a4,-88(s0)
 78c:	00078513          	mv	a0,a5
 790:	000700e7          	jalr	a4
 794:	fe442783          	lw	a5,-28(s0)
 798:	0017879b          	addiw	a5,a5,1
 79c:	fef42223          	sw	a5,-28(s0)
 7a0:	fe842783          	lw	a5,-24(s0)
 7a4:	fcf42e23          	sw	a5,-36(s0)
 7a8:	0280006f          	j	7d0 <print_dec_int+0x27c>
 7ac:	fa843783          	ld	a5,-88(s0)
 7b0:	03000513          	li	a0,48
 7b4:	000780e7          	jalr	a5
 7b8:	fe442783          	lw	a5,-28(s0)
 7bc:	0017879b          	addiw	a5,a5,1
 7c0:	fef42223          	sw	a5,-28(s0)
 7c4:	fdc42783          	lw	a5,-36(s0)
 7c8:	0017879b          	addiw	a5,a5,1
 7cc:	fcf42e23          	sw	a5,-36(s0)
 7d0:	f9043783          	ld	a5,-112(s0)
 7d4:	00c7a703          	lw	a4,12(a5)
 7d8:	fd744783          	lbu	a5,-41(s0)
 7dc:	0007879b          	sext.w	a5,a5
 7e0:	40f707bb          	subw	a5,a4,a5
 7e4:	0007871b          	sext.w	a4,a5
 7e8:	fdc42783          	lw	a5,-36(s0)
 7ec:	0007879b          	sext.w	a5,a5
 7f0:	fae7cee3          	blt	a5,a4,7ac <print_dec_int+0x258>
 7f4:	fe842783          	lw	a5,-24(s0)
 7f8:	fff7879b          	addiw	a5,a5,-1
 7fc:	fcf42c23          	sw	a5,-40(s0)
 800:	03c0006f          	j	83c <print_dec_int+0x2e8>
 804:	fd842783          	lw	a5,-40(s0)
 808:	ff078793          	addi	a5,a5,-16
 80c:	008787b3          	add	a5,a5,s0
 810:	fc87c783          	lbu	a5,-56(a5)
 814:	0007871b          	sext.w	a4,a5
 818:	fa843783          	ld	a5,-88(s0)
 81c:	00070513          	mv	a0,a4
 820:	000780e7          	jalr	a5
 824:	fe442783          	lw	a5,-28(s0)
 828:	0017879b          	addiw	a5,a5,1
 82c:	fef42223          	sw	a5,-28(s0)
 830:	fd842783          	lw	a5,-40(s0)
 834:	fff7879b          	addiw	a5,a5,-1
 838:	fcf42c23          	sw	a5,-40(s0)
 83c:	fd842783          	lw	a5,-40(s0)
 840:	0007879b          	sext.w	a5,a5
 844:	fc07d0e3          	bgez	a5,804 <print_dec_int+0x2b0>
 848:	fe442783          	lw	a5,-28(s0)
 84c:	00078513          	mv	a0,a5
 850:	06813083          	ld	ra,104(sp)
 854:	06013403          	ld	s0,96(sp)
 858:	07010113          	addi	sp,sp,112
 85c:	00008067          	ret

Disassembly of section .text.vprintfmt:

0000000000000860 <vprintfmt>:
     860:	f4010113          	addi	sp,sp,-192
     864:	0a113c23          	sd	ra,184(sp)
     868:	0a813823          	sd	s0,176(sp)
     86c:	0c010413          	addi	s0,sp,192
     870:	f4a43c23          	sd	a0,-168(s0)
     874:	f4b43823          	sd	a1,-176(s0)
     878:	f4c43423          	sd	a2,-184(s0)
     87c:	f8043023          	sd	zero,-128(s0)
     880:	f8043423          	sd	zero,-120(s0)
     884:	fe042623          	sw	zero,-20(s0)
     888:	7b40006f          	j	103c <vprintfmt+0x7dc>
     88c:	f8044783          	lbu	a5,-128(s0)
     890:	74078663          	beqz	a5,fdc <vprintfmt+0x77c>
     894:	f5043783          	ld	a5,-176(s0)
     898:	0007c783          	lbu	a5,0(a5)
     89c:	00078713          	mv	a4,a5
     8a0:	02300793          	li	a5,35
     8a4:	00f71863          	bne	a4,a5,8b4 <vprintfmt+0x54>
     8a8:	00100793          	li	a5,1
     8ac:	f8f40123          	sb	a5,-126(s0)
     8b0:	7800006f          	j	1030 <vprintfmt+0x7d0>
     8b4:	f5043783          	ld	a5,-176(s0)
     8b8:	0007c783          	lbu	a5,0(a5)
     8bc:	00078713          	mv	a4,a5
     8c0:	03000793          	li	a5,48
     8c4:	00f71863          	bne	a4,a5,8d4 <vprintfmt+0x74>
     8c8:	00100793          	li	a5,1
     8cc:	f8f401a3          	sb	a5,-125(s0)
     8d0:	7600006f          	j	1030 <vprintfmt+0x7d0>
     8d4:	f5043783          	ld	a5,-176(s0)
     8d8:	0007c783          	lbu	a5,0(a5)
     8dc:	00078713          	mv	a4,a5
     8e0:	06c00793          	li	a5,108
     8e4:	04f70063          	beq	a4,a5,924 <vprintfmt+0xc4>
     8e8:	f5043783          	ld	a5,-176(s0)
     8ec:	0007c783          	lbu	a5,0(a5)
     8f0:	00078713          	mv	a4,a5
     8f4:	07a00793          	li	a5,122
     8f8:	02f70663          	beq	a4,a5,924 <vprintfmt+0xc4>
     8fc:	f5043783          	ld	a5,-176(s0)
     900:	0007c783          	lbu	a5,0(a5)
     904:	00078713          	mv	a4,a5
     908:	07400793          	li	a5,116
     90c:	00f70c63          	beq	a4,a5,924 <vprintfmt+0xc4>
     910:	f5043783          	ld	a5,-176(s0)
     914:	0007c783          	lbu	a5,0(a5)
     918:	00078713          	mv	a4,a5
     91c:	06a00793          	li	a5,106
     920:	00f71863          	bne	a4,a5,930 <vprintfmt+0xd0>
     924:	00100793          	li	a5,1
     928:	f8f400a3          	sb	a5,-127(s0)
     92c:	7040006f          	j	1030 <vprintfmt+0x7d0>
     930:	f5043783          	ld	a5,-176(s0)
     934:	0007c783          	lbu	a5,0(a5)
     938:	00078713          	mv	a4,a5
     93c:	02b00793          	li	a5,43
     940:	00f71863          	bne	a4,a5,950 <vprintfmt+0xf0>
     944:	00100793          	li	a5,1
     948:	f8f402a3          	sb	a5,-123(s0)
     94c:	6e40006f          	j	1030 <vprintfmt+0x7d0>
     950:	f5043783          	ld	a5,-176(s0)
     954:	0007c783          	lbu	a5,0(a5)
     958:	00078713          	mv	a4,a5
     95c:	02000793          	li	a5,32
     960:	00f71863          	bne	a4,a5,970 <vprintfmt+0x110>
     964:	00100793          	li	a5,1
     968:	f8f40223          	sb	a5,-124(s0)
     96c:	6c40006f          	j	1030 <vprintfmt+0x7d0>
     970:	f5043783          	ld	a5,-176(s0)
     974:	0007c783          	lbu	a5,0(a5)
     978:	00078713          	mv	a4,a5
     97c:	02a00793          	li	a5,42
     980:	00f71e63          	bne	a4,a5,99c <vprintfmt+0x13c>
     984:	f4843783          	ld	a5,-184(s0)
     988:	00878713          	addi	a4,a5,8
     98c:	f4e43423          	sd	a4,-184(s0)
     990:	0007a783          	lw	a5,0(a5)
     994:	f8f42423          	sw	a5,-120(s0)
     998:	6980006f          	j	1030 <vprintfmt+0x7d0>
     99c:	f5043783          	ld	a5,-176(s0)
     9a0:	0007c783          	lbu	a5,0(a5)
     9a4:	00078713          	mv	a4,a5
     9a8:	03000793          	li	a5,48
     9ac:	04e7f863          	bgeu	a5,a4,9fc <vprintfmt+0x19c>
     9b0:	f5043783          	ld	a5,-176(s0)
     9b4:	0007c783          	lbu	a5,0(a5)
     9b8:	00078713          	mv	a4,a5
     9bc:	03900793          	li	a5,57
     9c0:	02e7ee63          	bltu	a5,a4,9fc <vprintfmt+0x19c>
     9c4:	f5043783          	ld	a5,-176(s0)
     9c8:	f5040713          	addi	a4,s0,-176
     9cc:	00a00613          	li	a2,10
     9d0:	00070593          	mv	a1,a4
     9d4:	00078513          	mv	a0,a5
     9d8:	00000097          	auipc	ra,0x0
     9dc:	884080e7          	jalr	-1916(ra) # 25c <strtol>
     9e0:	00050793          	mv	a5,a0
     9e4:	0007879b          	sext.w	a5,a5
     9e8:	f8f42423          	sw	a5,-120(s0)
     9ec:	f5043783          	ld	a5,-176(s0)
     9f0:	fff78793          	addi	a5,a5,-1
     9f4:	f4f43823          	sd	a5,-176(s0)
     9f8:	6380006f          	j	1030 <vprintfmt+0x7d0>
     9fc:	f5043783          	ld	a5,-176(s0)
     a00:	0007c783          	lbu	a5,0(a5)
     a04:	00078713          	mv	a4,a5
     a08:	02e00793          	li	a5,46
     a0c:	06f71a63          	bne	a4,a5,a80 <vprintfmt+0x220>
     a10:	f5043783          	ld	a5,-176(s0)
     a14:	00178793          	addi	a5,a5,1
     a18:	f4f43823          	sd	a5,-176(s0)
     a1c:	f5043783          	ld	a5,-176(s0)
     a20:	0007c783          	lbu	a5,0(a5)
     a24:	00078713          	mv	a4,a5
     a28:	02a00793          	li	a5,42
     a2c:	00f71e63          	bne	a4,a5,a48 <vprintfmt+0x1e8>
     a30:	f4843783          	ld	a5,-184(s0)
     a34:	00878713          	addi	a4,a5,8
     a38:	f4e43423          	sd	a4,-184(s0)
     a3c:	0007a783          	lw	a5,0(a5)
     a40:	f8f42623          	sw	a5,-116(s0)
     a44:	5ec0006f          	j	1030 <vprintfmt+0x7d0>
     a48:	f5043783          	ld	a5,-176(s0)
     a4c:	f5040713          	addi	a4,s0,-176
     a50:	00a00613          	li	a2,10
     a54:	00070593          	mv	a1,a4
     a58:	00078513          	mv	a0,a5
     a5c:	00000097          	auipc	ra,0x0
     a60:	800080e7          	jalr	-2048(ra) # 25c <strtol>
     a64:	00050793          	mv	a5,a0
     a68:	0007879b          	sext.w	a5,a5
     a6c:	f8f42623          	sw	a5,-116(s0)
     a70:	f5043783          	ld	a5,-176(s0)
     a74:	fff78793          	addi	a5,a5,-1
     a78:	f4f43823          	sd	a5,-176(s0)
     a7c:	5b40006f          	j	1030 <vprintfmt+0x7d0>
     a80:	f5043783          	ld	a5,-176(s0)
     a84:	0007c783          	lbu	a5,0(a5)
     a88:	00078713          	mv	a4,a5
     a8c:	07800793          	li	a5,120
     a90:	02f70663          	beq	a4,a5,abc <vprintfmt+0x25c>
     a94:	f5043783          	ld	a5,-176(s0)
     a98:	0007c783          	lbu	a5,0(a5)
     a9c:	00078713          	mv	a4,a5
     aa0:	05800793          	li	a5,88
     aa4:	00f70c63          	beq	a4,a5,abc <vprintfmt+0x25c>
     aa8:	f5043783          	ld	a5,-176(s0)
     aac:	0007c783          	lbu	a5,0(a5)
     ab0:	00078713          	mv	a4,a5
     ab4:	07000793          	li	a5,112
     ab8:	30f71263          	bne	a4,a5,dbc <vprintfmt+0x55c>
     abc:	f5043783          	ld	a5,-176(s0)
     ac0:	0007c783          	lbu	a5,0(a5)
     ac4:	00078713          	mv	a4,a5
     ac8:	07000793          	li	a5,112
     acc:	00f70663          	beq	a4,a5,ad8 <vprintfmt+0x278>
     ad0:	f8144783          	lbu	a5,-127(s0)
     ad4:	00078663          	beqz	a5,ae0 <vprintfmt+0x280>
     ad8:	00100793          	li	a5,1
     adc:	0080006f          	j	ae4 <vprintfmt+0x284>
     ae0:	00000793          	li	a5,0
     ae4:	faf403a3          	sb	a5,-89(s0)
     ae8:	fa744783          	lbu	a5,-89(s0)
     aec:	0017f793          	andi	a5,a5,1
     af0:	faf403a3          	sb	a5,-89(s0)
     af4:	fa744783          	lbu	a5,-89(s0)
     af8:	0ff7f793          	zext.b	a5,a5
     afc:	00078c63          	beqz	a5,b14 <vprintfmt+0x2b4>
     b00:	f4843783          	ld	a5,-184(s0)
     b04:	00878713          	addi	a4,a5,8
     b08:	f4e43423          	sd	a4,-184(s0)
     b0c:	0007b783          	ld	a5,0(a5)
     b10:	01c0006f          	j	b2c <vprintfmt+0x2cc>
     b14:	f4843783          	ld	a5,-184(s0)
     b18:	00878713          	addi	a4,a5,8
     b1c:	f4e43423          	sd	a4,-184(s0)
     b20:	0007a783          	lw	a5,0(a5)
     b24:	02079793          	slli	a5,a5,0x20
     b28:	0207d793          	srli	a5,a5,0x20
     b2c:	fef43023          	sd	a5,-32(s0)
     b30:	f8c42783          	lw	a5,-116(s0)
     b34:	02079463          	bnez	a5,b5c <vprintfmt+0x2fc>
     b38:	fe043783          	ld	a5,-32(s0)
     b3c:	02079063          	bnez	a5,b5c <vprintfmt+0x2fc>
     b40:	f5043783          	ld	a5,-176(s0)
     b44:	0007c783          	lbu	a5,0(a5)
     b48:	00078713          	mv	a4,a5
     b4c:	07000793          	li	a5,112
     b50:	00f70663          	beq	a4,a5,b5c <vprintfmt+0x2fc>
     b54:	f8040023          	sb	zero,-128(s0)
     b58:	4d80006f          	j	1030 <vprintfmt+0x7d0>
     b5c:	f5043783          	ld	a5,-176(s0)
     b60:	0007c783          	lbu	a5,0(a5)
     b64:	00078713          	mv	a4,a5
     b68:	07000793          	li	a5,112
     b6c:	00f70a63          	beq	a4,a5,b80 <vprintfmt+0x320>
     b70:	f8244783          	lbu	a5,-126(s0)
     b74:	00078a63          	beqz	a5,b88 <vprintfmt+0x328>
     b78:	fe043783          	ld	a5,-32(s0)
     b7c:	00078663          	beqz	a5,b88 <vprintfmt+0x328>
     b80:	00100793          	li	a5,1
     b84:	0080006f          	j	b8c <vprintfmt+0x32c>
     b88:	00000793          	li	a5,0
     b8c:	faf40323          	sb	a5,-90(s0)
     b90:	fa644783          	lbu	a5,-90(s0)
     b94:	0017f793          	andi	a5,a5,1
     b98:	faf40323          	sb	a5,-90(s0)
     b9c:	fc042e23          	sw	zero,-36(s0)
     ba0:	f5043783          	ld	a5,-176(s0)
     ba4:	0007c783          	lbu	a5,0(a5)
     ba8:	00078713          	mv	a4,a5
     bac:	05800793          	li	a5,88
     bb0:	00f71863          	bne	a4,a5,bc0 <vprintfmt+0x360>
     bb4:	00000797          	auipc	a5,0x0
     bb8:	63c78793          	addi	a5,a5,1596 # 11f0 <upperxdigits.1>
     bbc:	00c0006f          	j	bc8 <vprintfmt+0x368>
     bc0:	00000797          	auipc	a5,0x0
     bc4:	64878793          	addi	a5,a5,1608 # 1208 <lowerxdigits.0>
     bc8:	f8f43c23          	sd	a5,-104(s0)
     bcc:	fe043783          	ld	a5,-32(s0)
     bd0:	00f7f793          	andi	a5,a5,15
     bd4:	f9843703          	ld	a4,-104(s0)
     bd8:	00f70733          	add	a4,a4,a5
     bdc:	fdc42783          	lw	a5,-36(s0)
     be0:	0017869b          	addiw	a3,a5,1
     be4:	fcd42e23          	sw	a3,-36(s0)
     be8:	00074703          	lbu	a4,0(a4)
     bec:	ff078793          	addi	a5,a5,-16
     bf0:	008787b3          	add	a5,a5,s0
     bf4:	f8e78023          	sb	a4,-128(a5)
     bf8:	fe043783          	ld	a5,-32(s0)
     bfc:	0047d793          	srli	a5,a5,0x4
     c00:	fef43023          	sd	a5,-32(s0)
     c04:	fe043783          	ld	a5,-32(s0)
     c08:	fc0792e3          	bnez	a5,bcc <vprintfmt+0x36c>
     c0c:	f8c42783          	lw	a5,-116(s0)
     c10:	00078713          	mv	a4,a5
     c14:	fff00793          	li	a5,-1
     c18:	02f71663          	bne	a4,a5,c44 <vprintfmt+0x3e4>
     c1c:	f8344783          	lbu	a5,-125(s0)
     c20:	02078263          	beqz	a5,c44 <vprintfmt+0x3e4>
     c24:	f8842703          	lw	a4,-120(s0)
     c28:	fa644783          	lbu	a5,-90(s0)
     c2c:	0007879b          	sext.w	a5,a5
     c30:	0017979b          	slliw	a5,a5,0x1
     c34:	0007879b          	sext.w	a5,a5
     c38:	40f707bb          	subw	a5,a4,a5
     c3c:	0007879b          	sext.w	a5,a5
     c40:	f8f42623          	sw	a5,-116(s0)
     c44:	f8842703          	lw	a4,-120(s0)
     c48:	fa644783          	lbu	a5,-90(s0)
     c4c:	0007879b          	sext.w	a5,a5
     c50:	0017979b          	slliw	a5,a5,0x1
     c54:	0007879b          	sext.w	a5,a5
     c58:	40f707bb          	subw	a5,a4,a5
     c5c:	0007871b          	sext.w	a4,a5
     c60:	fdc42783          	lw	a5,-36(s0)
     c64:	f8f42a23          	sw	a5,-108(s0)
     c68:	f8c42783          	lw	a5,-116(s0)
     c6c:	f8f42823          	sw	a5,-112(s0)
     c70:	f9442783          	lw	a5,-108(s0)
     c74:	00078593          	mv	a1,a5
     c78:	f9042783          	lw	a5,-112(s0)
     c7c:	00078613          	mv	a2,a5
     c80:	0006069b          	sext.w	a3,a2
     c84:	0005879b          	sext.w	a5,a1
     c88:	00f6d463          	bge	a3,a5,c90 <vprintfmt+0x430>
     c8c:	00058613          	mv	a2,a1
     c90:	0006079b          	sext.w	a5,a2
     c94:	40f707bb          	subw	a5,a4,a5
     c98:	fcf42c23          	sw	a5,-40(s0)
     c9c:	0280006f          	j	cc4 <vprintfmt+0x464>
     ca0:	f5843783          	ld	a5,-168(s0)
     ca4:	02000513          	li	a0,32
     ca8:	000780e7          	jalr	a5
     cac:	fec42783          	lw	a5,-20(s0)
     cb0:	0017879b          	addiw	a5,a5,1
     cb4:	fef42623          	sw	a5,-20(s0)
     cb8:	fd842783          	lw	a5,-40(s0)
     cbc:	fff7879b          	addiw	a5,a5,-1
     cc0:	fcf42c23          	sw	a5,-40(s0)
     cc4:	fd842783          	lw	a5,-40(s0)
     cc8:	0007879b          	sext.w	a5,a5
     ccc:	fcf04ae3          	bgtz	a5,ca0 <vprintfmt+0x440>
     cd0:	fa644783          	lbu	a5,-90(s0)
     cd4:	0ff7f793          	zext.b	a5,a5
     cd8:	04078463          	beqz	a5,d20 <vprintfmt+0x4c0>
     cdc:	f5843783          	ld	a5,-168(s0)
     ce0:	03000513          	li	a0,48
     ce4:	000780e7          	jalr	a5
     ce8:	f5043783          	ld	a5,-176(s0)
     cec:	0007c783          	lbu	a5,0(a5)
     cf0:	00078713          	mv	a4,a5
     cf4:	05800793          	li	a5,88
     cf8:	00f71663          	bne	a4,a5,d04 <vprintfmt+0x4a4>
     cfc:	05800793          	li	a5,88
     d00:	0080006f          	j	d08 <vprintfmt+0x4a8>
     d04:	07800793          	li	a5,120
     d08:	f5843703          	ld	a4,-168(s0)
     d0c:	00078513          	mv	a0,a5
     d10:	000700e7          	jalr	a4
     d14:	fec42783          	lw	a5,-20(s0)
     d18:	0027879b          	addiw	a5,a5,2
     d1c:	fef42623          	sw	a5,-20(s0)
     d20:	fdc42783          	lw	a5,-36(s0)
     d24:	fcf42a23          	sw	a5,-44(s0)
     d28:	0280006f          	j	d50 <vprintfmt+0x4f0>
     d2c:	f5843783          	ld	a5,-168(s0)
     d30:	03000513          	li	a0,48
     d34:	000780e7          	jalr	a5
     d38:	fec42783          	lw	a5,-20(s0)
     d3c:	0017879b          	addiw	a5,a5,1
     d40:	fef42623          	sw	a5,-20(s0)
     d44:	fd442783          	lw	a5,-44(s0)
     d48:	0017879b          	addiw	a5,a5,1
     d4c:	fcf42a23          	sw	a5,-44(s0)
     d50:	f8c42703          	lw	a4,-116(s0)
     d54:	fd442783          	lw	a5,-44(s0)
     d58:	0007879b          	sext.w	a5,a5
     d5c:	fce7c8e3          	blt	a5,a4,d2c <vprintfmt+0x4cc>
     d60:	fdc42783          	lw	a5,-36(s0)
     d64:	fff7879b          	addiw	a5,a5,-1
     d68:	fcf42823          	sw	a5,-48(s0)
     d6c:	03c0006f          	j	da8 <vprintfmt+0x548>
     d70:	fd042783          	lw	a5,-48(s0)
     d74:	ff078793          	addi	a5,a5,-16
     d78:	008787b3          	add	a5,a5,s0
     d7c:	f807c783          	lbu	a5,-128(a5)
     d80:	0007871b          	sext.w	a4,a5
     d84:	f5843783          	ld	a5,-168(s0)
     d88:	00070513          	mv	a0,a4
     d8c:	000780e7          	jalr	a5
     d90:	fec42783          	lw	a5,-20(s0)
     d94:	0017879b          	addiw	a5,a5,1
     d98:	fef42623          	sw	a5,-20(s0)
     d9c:	fd042783          	lw	a5,-48(s0)
     da0:	fff7879b          	addiw	a5,a5,-1
     da4:	fcf42823          	sw	a5,-48(s0)
     da8:	fd042783          	lw	a5,-48(s0)
     dac:	0007879b          	sext.w	a5,a5
     db0:	fc07d0e3          	bgez	a5,d70 <vprintfmt+0x510>
     db4:	f8040023          	sb	zero,-128(s0)
     db8:	2780006f          	j	1030 <vprintfmt+0x7d0>
     dbc:	f5043783          	ld	a5,-176(s0)
     dc0:	0007c783          	lbu	a5,0(a5)
     dc4:	00078713          	mv	a4,a5
     dc8:	06400793          	li	a5,100
     dcc:	02f70663          	beq	a4,a5,df8 <vprintfmt+0x598>
     dd0:	f5043783          	ld	a5,-176(s0)
     dd4:	0007c783          	lbu	a5,0(a5)
     dd8:	00078713          	mv	a4,a5
     ddc:	06900793          	li	a5,105
     de0:	00f70c63          	beq	a4,a5,df8 <vprintfmt+0x598>
     de4:	f5043783          	ld	a5,-176(s0)
     de8:	0007c783          	lbu	a5,0(a5)
     dec:	00078713          	mv	a4,a5
     df0:	07500793          	li	a5,117
     df4:	08f71263          	bne	a4,a5,e78 <vprintfmt+0x618>
     df8:	f8144783          	lbu	a5,-127(s0)
     dfc:	00078c63          	beqz	a5,e14 <vprintfmt+0x5b4>
     e00:	f4843783          	ld	a5,-184(s0)
     e04:	00878713          	addi	a4,a5,8
     e08:	f4e43423          	sd	a4,-184(s0)
     e0c:	0007b783          	ld	a5,0(a5)
     e10:	0140006f          	j	e24 <vprintfmt+0x5c4>
     e14:	f4843783          	ld	a5,-184(s0)
     e18:	00878713          	addi	a4,a5,8
     e1c:	f4e43423          	sd	a4,-184(s0)
     e20:	0007a783          	lw	a5,0(a5)
     e24:	faf43423          	sd	a5,-88(s0)
     e28:	fa843583          	ld	a1,-88(s0)
     e2c:	f5043783          	ld	a5,-176(s0)
     e30:	0007c783          	lbu	a5,0(a5)
     e34:	0007871b          	sext.w	a4,a5
     e38:	07500793          	li	a5,117
     e3c:	40f707b3          	sub	a5,a4,a5
     e40:	00f037b3          	snez	a5,a5
     e44:	0ff7f793          	zext.b	a5,a5
     e48:	f8040713          	addi	a4,s0,-128
     e4c:	00070693          	mv	a3,a4
     e50:	00078613          	mv	a2,a5
     e54:	f5843503          	ld	a0,-168(s0)
     e58:	fffff097          	auipc	ra,0xfffff
     e5c:	6fc080e7          	jalr	1788(ra) # 554 <print_dec_int>
     e60:	00050793          	mv	a5,a0
     e64:	fec42703          	lw	a4,-20(s0)
     e68:	00f707bb          	addw	a5,a4,a5
     e6c:	fef42623          	sw	a5,-20(s0)
     e70:	f8040023          	sb	zero,-128(s0)
     e74:	1bc0006f          	j	1030 <vprintfmt+0x7d0>
     e78:	f5043783          	ld	a5,-176(s0)
     e7c:	0007c783          	lbu	a5,0(a5)
     e80:	00078713          	mv	a4,a5
     e84:	06e00793          	li	a5,110
     e88:	04f71c63          	bne	a4,a5,ee0 <vprintfmt+0x680>
     e8c:	f8144783          	lbu	a5,-127(s0)
     e90:	02078463          	beqz	a5,eb8 <vprintfmt+0x658>
     e94:	f4843783          	ld	a5,-184(s0)
     e98:	00878713          	addi	a4,a5,8
     e9c:	f4e43423          	sd	a4,-184(s0)
     ea0:	0007b783          	ld	a5,0(a5)
     ea4:	faf43823          	sd	a5,-80(s0)
     ea8:	fec42703          	lw	a4,-20(s0)
     eac:	fb043783          	ld	a5,-80(s0)
     eb0:	00e7b023          	sd	a4,0(a5)
     eb4:	0240006f          	j	ed8 <vprintfmt+0x678>
     eb8:	f4843783          	ld	a5,-184(s0)
     ebc:	00878713          	addi	a4,a5,8
     ec0:	f4e43423          	sd	a4,-184(s0)
     ec4:	0007b783          	ld	a5,0(a5)
     ec8:	faf43c23          	sd	a5,-72(s0)
     ecc:	fb843783          	ld	a5,-72(s0)
     ed0:	fec42703          	lw	a4,-20(s0)
     ed4:	00e7a023          	sw	a4,0(a5)
     ed8:	f8040023          	sb	zero,-128(s0)
     edc:	1540006f          	j	1030 <vprintfmt+0x7d0>
     ee0:	f5043783          	ld	a5,-176(s0)
     ee4:	0007c783          	lbu	a5,0(a5)
     ee8:	00078713          	mv	a4,a5
     eec:	07300793          	li	a5,115
     ef0:	04f71063          	bne	a4,a5,f30 <vprintfmt+0x6d0>
     ef4:	f4843783          	ld	a5,-184(s0)
     ef8:	00878713          	addi	a4,a5,8
     efc:	f4e43423          	sd	a4,-184(s0)
     f00:	0007b783          	ld	a5,0(a5)
     f04:	fcf43023          	sd	a5,-64(s0)
     f08:	fc043583          	ld	a1,-64(s0)
     f0c:	f5843503          	ld	a0,-168(s0)
     f10:	fffff097          	auipc	ra,0xfffff
     f14:	5bc080e7          	jalr	1468(ra) # 4cc <puts_wo_nl>
     f18:	00050793          	mv	a5,a0
     f1c:	fec42703          	lw	a4,-20(s0)
     f20:	00f707bb          	addw	a5,a4,a5
     f24:	fef42623          	sw	a5,-20(s0)
     f28:	f8040023          	sb	zero,-128(s0)
     f2c:	1040006f          	j	1030 <vprintfmt+0x7d0>
     f30:	f5043783          	ld	a5,-176(s0)
     f34:	0007c783          	lbu	a5,0(a5)
     f38:	00078713          	mv	a4,a5
     f3c:	06300793          	li	a5,99
     f40:	02f71e63          	bne	a4,a5,f7c <vprintfmt+0x71c>
     f44:	f4843783          	ld	a5,-184(s0)
     f48:	00878713          	addi	a4,a5,8
     f4c:	f4e43423          	sd	a4,-184(s0)
     f50:	0007a783          	lw	a5,0(a5)
     f54:	fcf42623          	sw	a5,-52(s0)
     f58:	fcc42703          	lw	a4,-52(s0)
     f5c:	f5843783          	ld	a5,-168(s0)
     f60:	00070513          	mv	a0,a4
     f64:	000780e7          	jalr	a5
     f68:	fec42783          	lw	a5,-20(s0)
     f6c:	0017879b          	addiw	a5,a5,1
     f70:	fef42623          	sw	a5,-20(s0)
     f74:	f8040023          	sb	zero,-128(s0)
     f78:	0b80006f          	j	1030 <vprintfmt+0x7d0>
     f7c:	f5043783          	ld	a5,-176(s0)
     f80:	0007c783          	lbu	a5,0(a5)
     f84:	00078713          	mv	a4,a5
     f88:	02500793          	li	a5,37
     f8c:	02f71263          	bne	a4,a5,fb0 <vprintfmt+0x750>
     f90:	f5843783          	ld	a5,-168(s0)
     f94:	02500513          	li	a0,37
     f98:	000780e7          	jalr	a5
     f9c:	fec42783          	lw	a5,-20(s0)
     fa0:	0017879b          	addiw	a5,a5,1
     fa4:	fef42623          	sw	a5,-20(s0)
     fa8:	f8040023          	sb	zero,-128(s0)
     fac:	0840006f          	j	1030 <vprintfmt+0x7d0>
     fb0:	f5043783          	ld	a5,-176(s0)
     fb4:	0007c783          	lbu	a5,0(a5)
     fb8:	0007871b          	sext.w	a4,a5
     fbc:	f5843783          	ld	a5,-168(s0)
     fc0:	00070513          	mv	a0,a4
     fc4:	000780e7          	jalr	a5
     fc8:	fec42783          	lw	a5,-20(s0)
     fcc:	0017879b          	addiw	a5,a5,1
     fd0:	fef42623          	sw	a5,-20(s0)
     fd4:	f8040023          	sb	zero,-128(s0)
     fd8:	0580006f          	j	1030 <vprintfmt+0x7d0>
     fdc:	f5043783          	ld	a5,-176(s0)
     fe0:	0007c783          	lbu	a5,0(a5)
     fe4:	00078713          	mv	a4,a5
     fe8:	02500793          	li	a5,37
     fec:	02f71063          	bne	a4,a5,100c <vprintfmt+0x7ac>
     ff0:	f8043023          	sd	zero,-128(s0)
     ff4:	f8043423          	sd	zero,-120(s0)
     ff8:	00100793          	li	a5,1
     ffc:	f8f40023          	sb	a5,-128(s0)
    1000:	fff00793          	li	a5,-1
    1004:	f8f42623          	sw	a5,-116(s0)
    1008:	0280006f          	j	1030 <vprintfmt+0x7d0>
    100c:	f5043783          	ld	a5,-176(s0)
    1010:	0007c783          	lbu	a5,0(a5)
    1014:	0007871b          	sext.w	a4,a5
    1018:	f5843783          	ld	a5,-168(s0)
    101c:	00070513          	mv	a0,a4
    1020:	000780e7          	jalr	a5
    1024:	fec42783          	lw	a5,-20(s0)
    1028:	0017879b          	addiw	a5,a5,1
    102c:	fef42623          	sw	a5,-20(s0)
    1030:	f5043783          	ld	a5,-176(s0)
    1034:	00178793          	addi	a5,a5,1
    1038:	f4f43823          	sd	a5,-176(s0)
    103c:	f5043783          	ld	a5,-176(s0)
    1040:	0007c783          	lbu	a5,0(a5)
    1044:	840794e3          	bnez	a5,88c <vprintfmt+0x2c>
    1048:	fec42783          	lw	a5,-20(s0)
    104c:	00078513          	mv	a0,a5
    1050:	0b813083          	ld	ra,184(sp)
    1054:	0b013403          	ld	s0,176(sp)
    1058:	0c010113          	addi	sp,sp,192
    105c:	00008067          	ret

Disassembly of section .text.printf:

0000000000001060 <printf>:
    1060:	f8010113          	addi	sp,sp,-128
    1064:	02113c23          	sd	ra,56(sp)
    1068:	02813823          	sd	s0,48(sp)
    106c:	04010413          	addi	s0,sp,64
    1070:	fca43423          	sd	a0,-56(s0)
    1074:	00b43423          	sd	a1,8(s0)
    1078:	00c43823          	sd	a2,16(s0)
    107c:	00d43c23          	sd	a3,24(s0)
    1080:	02e43023          	sd	a4,32(s0)
    1084:	02f43423          	sd	a5,40(s0)
    1088:	03043823          	sd	a6,48(s0)
    108c:	03143c23          	sd	a7,56(s0)
    1090:	fe042623          	sw	zero,-20(s0)
    1094:	04040793          	addi	a5,s0,64
    1098:	fcf43023          	sd	a5,-64(s0)
    109c:	fc043783          	ld	a5,-64(s0)
    10a0:	fc878793          	addi	a5,a5,-56
    10a4:	fcf43823          	sd	a5,-48(s0)
    10a8:	fd043783          	ld	a5,-48(s0)
    10ac:	00078613          	mv	a2,a5
    10b0:	fc843583          	ld	a1,-56(s0)
    10b4:	fffff517          	auipc	a0,0xfffff
    10b8:	0e050513          	addi	a0,a0,224 # 194 <putc>
    10bc:	fffff097          	auipc	ra,0xfffff
    10c0:	7a4080e7          	jalr	1956(ra) # 860 <vprintfmt>
    10c4:	00050793          	mv	a5,a0
    10c8:	fef42623          	sw	a5,-20(s0)
    10cc:	00100793          	li	a5,1
    10d0:	fef43023          	sd	a5,-32(s0)
    10d4:	00000797          	auipc	a5,0x0
    10d8:	14c78793          	addi	a5,a5,332 # 1220 <tail>
    10dc:	0007a783          	lw	a5,0(a5)
    10e0:	0017871b          	addiw	a4,a5,1
    10e4:	0007069b          	sext.w	a3,a4
    10e8:	00000717          	auipc	a4,0x0
    10ec:	13870713          	addi	a4,a4,312 # 1220 <tail>
    10f0:	00d72023          	sw	a3,0(a4)
    10f4:	00000717          	auipc	a4,0x0
    10f8:	13470713          	addi	a4,a4,308 # 1228 <buffer>
    10fc:	00f707b3          	add	a5,a4,a5
    1100:	00078023          	sb	zero,0(a5)
    1104:	00000797          	auipc	a5,0x0
    1108:	11c78793          	addi	a5,a5,284 # 1220 <tail>
    110c:	0007a603          	lw	a2,0(a5)
    1110:	fe043703          	ld	a4,-32(s0)
    1114:	00000697          	auipc	a3,0x0
    1118:	11468693          	addi	a3,a3,276 # 1228 <buffer>
    111c:	fd843783          	ld	a5,-40(s0)
    1120:	04000893          	li	a7,64
    1124:	00070513          	mv	a0,a4
    1128:	00068593          	mv	a1,a3
    112c:	00060613          	mv	a2,a2
    1130:	00000073          	ecall
    1134:	00050793          	mv	a5,a0
    1138:	fcf43c23          	sd	a5,-40(s0)
    113c:	00000797          	auipc	a5,0x0
    1140:	0e478793          	addi	a5,a5,228 # 1220 <tail>
    1144:	0007a023          	sw	zero,0(a5)
    1148:	fec42783          	lw	a5,-20(s0)
    114c:	00078513          	mv	a0,a5
    1150:	03813083          	ld	ra,56(sp)
    1154:	03013403          	ld	s0,48(sp)
    1158:	08010113          	addi	sp,sp,128
    115c:	00008067          	ret
