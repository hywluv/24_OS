
uapp.elf:     file format elf64-littleriscv


Disassembly of section .text.init:

0000000000000000 <_start>:
   0:	2010006f          	j	a00 <main>

Disassembly of section .text.atoi:

0000000000000004 <atoi>:
   4:	fd010113          	addi	sp,sp,-48
   8:	02113423          	sd	ra,40(sp)
   c:	02813023          	sd	s0,32(sp)
  10:	03010413          	addi	s0,sp,48
  14:	fca43c23          	sd	a0,-40(s0)
  18:	fe042623          	sw	zero,-20(s0)
  1c:	fd843503          	ld	a0,-40(s0)
  20:	2d9010ef          	jal	ra,1af8 <strlen>
  24:	00050793          	mv	a5,a0
  28:	fef42223          	sw	a5,-28(s0)
  2c:	fe042423          	sw	zero,-24(s0)
  30:	0500006f          	j	80 <atoi+0x7c>
  34:	fec42783          	lw	a5,-20(s0)
  38:	00078713          	mv	a4,a5
  3c:	00070793          	mv	a5,a4
  40:	0027979b          	slliw	a5,a5,0x2
  44:	00e787bb          	addw	a5,a5,a4
  48:	0017979b          	slliw	a5,a5,0x1
  4c:	0007871b          	sext.w	a4,a5
  50:	fe842783          	lw	a5,-24(s0)
  54:	fd843683          	ld	a3,-40(s0)
  58:	00f687b3          	add	a5,a3,a5
  5c:	0007c783          	lbu	a5,0(a5)
  60:	0007879b          	sext.w	a5,a5
  64:	00f707bb          	addw	a5,a4,a5
  68:	0007879b          	sext.w	a5,a5
  6c:	fd07879b          	addiw	a5,a5,-48
  70:	fef42623          	sw	a5,-20(s0)
  74:	fe842783          	lw	a5,-24(s0)
  78:	0017879b          	addiw	a5,a5,1
  7c:	fef42423          	sw	a5,-24(s0)
  80:	fe842783          	lw	a5,-24(s0)
  84:	00078713          	mv	a4,a5
  88:	fe442783          	lw	a5,-28(s0)
  8c:	0007071b          	sext.w	a4,a4
  90:	0007879b          	sext.w	a5,a5
  94:	faf740e3          	blt	a4,a5,34 <atoi+0x30>
  98:	fec42783          	lw	a5,-20(s0)
  9c:	00078513          	mv	a0,a5
  a0:	02813083          	ld	ra,40(sp)
  a4:	02013403          	ld	s0,32(sp)
  a8:	03010113          	addi	sp,sp,48
  ac:	00008067          	ret

Disassembly of section .text.get_param:

00000000000000b0 <get_param>:
  b0:	fd010113          	addi	sp,sp,-48
  b4:	02813423          	sd	s0,40(sp)
  b8:	03010413          	addi	s0,sp,48
  bc:	fca43c23          	sd	a0,-40(s0)
  c0:	0100006f          	j	d0 <get_param+0x20>
  c4:	fd843783          	ld	a5,-40(s0)
  c8:	00178793          	addi	a5,a5,1
  cc:	fcf43c23          	sd	a5,-40(s0)
  d0:	fd843783          	ld	a5,-40(s0)
  d4:	0007c783          	lbu	a5,0(a5)
  d8:	00078713          	mv	a4,a5
  dc:	02000793          	li	a5,32
  e0:	fef702e3          	beq	a4,a5,c4 <get_param+0x14>
  e4:	fe042623          	sw	zero,-20(s0)
  e8:	0300006f          	j	118 <get_param+0x68>
  ec:	fd843703          	ld	a4,-40(s0)
  f0:	00170793          	addi	a5,a4,1
  f4:	fcf43c23          	sd	a5,-40(s0)
  f8:	fec42783          	lw	a5,-20(s0)
  fc:	0017869b          	addiw	a3,a5,1
 100:	fed42623          	sw	a3,-20(s0)
 104:	00074703          	lbu	a4,0(a4)
 108:	00002697          	auipc	a3,0x2
 10c:	e5868693          	addi	a3,a3,-424 # 1f60 <string_buf>
 110:	00f687b3          	add	a5,a3,a5
 114:	00e78023          	sb	a4,0(a5)
 118:	fd843783          	ld	a5,-40(s0)
 11c:	0007c783          	lbu	a5,0(a5)
 120:	00078c63          	beqz	a5,138 <get_param+0x88>
 124:	fd843783          	ld	a5,-40(s0)
 128:	0007c783          	lbu	a5,0(a5)
 12c:	00078713          	mv	a4,a5
 130:	02000793          	li	a5,32
 134:	faf71ce3          	bne	a4,a5,ec <get_param+0x3c>
 138:	00002717          	auipc	a4,0x2
 13c:	e2870713          	addi	a4,a4,-472 # 1f60 <string_buf>
 140:	fec42783          	lw	a5,-20(s0)
 144:	00f707b3          	add	a5,a4,a5
 148:	00078023          	sb	zero,0(a5)
 14c:	00002797          	auipc	a5,0x2
 150:	e1478793          	addi	a5,a5,-492 # 1f60 <string_buf>
 154:	00078513          	mv	a0,a5
 158:	02813403          	ld	s0,40(sp)
 15c:	03010113          	addi	sp,sp,48
 160:	00008067          	ret

Disassembly of section .text.get_string:

0000000000000164 <get_string>:
 164:	fd010113          	addi	sp,sp,-48
 168:	02113423          	sd	ra,40(sp)
 16c:	02813023          	sd	s0,32(sp)
 170:	03010413          	addi	s0,sp,48
 174:	fca43c23          	sd	a0,-40(s0)
 178:	0100006f          	j	188 <get_string+0x24>
 17c:	fd843783          	ld	a5,-40(s0)
 180:	00178793          	addi	a5,a5,1
 184:	fcf43c23          	sd	a5,-40(s0)
 188:	fd843783          	ld	a5,-40(s0)
 18c:	0007c783          	lbu	a5,0(a5)
 190:	00078713          	mv	a4,a5
 194:	02000793          	li	a5,32
 198:	fef702e3          	beq	a4,a5,17c <get_string+0x18>
 19c:	fd843783          	ld	a5,-40(s0)
 1a0:	0007c783          	lbu	a5,0(a5)
 1a4:	00078713          	mv	a4,a5
 1a8:	02200793          	li	a5,34
 1ac:	06f71c63          	bne	a4,a5,224 <get_string+0xc0>
 1b0:	fd843783          	ld	a5,-40(s0)
 1b4:	00178793          	addi	a5,a5,1
 1b8:	fcf43c23          	sd	a5,-40(s0)
 1bc:	fe042623          	sw	zero,-20(s0)
 1c0:	0300006f          	j	1f0 <get_string+0x8c>
 1c4:	fd843703          	ld	a4,-40(s0)
 1c8:	00170793          	addi	a5,a4,1
 1cc:	fcf43c23          	sd	a5,-40(s0)
 1d0:	fec42783          	lw	a5,-20(s0)
 1d4:	0017869b          	addiw	a3,a5,1
 1d8:	fed42623          	sw	a3,-20(s0)
 1dc:	00074703          	lbu	a4,0(a4)
 1e0:	00002697          	auipc	a3,0x2
 1e4:	d8068693          	addi	a3,a3,-640 # 1f60 <string_buf>
 1e8:	00f687b3          	add	a5,a3,a5
 1ec:	00e78023          	sb	a4,0(a5)
 1f0:	fd843783          	ld	a5,-40(s0)
 1f4:	0007c783          	lbu	a5,0(a5)
 1f8:	00078713          	mv	a4,a5
 1fc:	02200793          	li	a5,34
 200:	fcf712e3          	bne	a4,a5,1c4 <get_string+0x60>
 204:	00002717          	auipc	a4,0x2
 208:	d5c70713          	addi	a4,a4,-676 # 1f60 <string_buf>
 20c:	fec42783          	lw	a5,-20(s0)
 210:	00f707b3          	add	a5,a4,a5
 214:	00078023          	sb	zero,0(a5)
 218:	00002797          	auipc	a5,0x2
 21c:	d4878793          	addi	a5,a5,-696 # 1f60 <string_buf>
 220:	0100006f          	j	230 <get_string+0xcc>
 224:	fd843503          	ld	a0,-40(s0)
 228:	e89ff0ef          	jal	ra,b0 <get_param>
 22c:	00050793          	mv	a5,a0
 230:	00078513          	mv	a0,a5
 234:	02813083          	ld	ra,40(sp)
 238:	02013403          	ld	s0,32(sp)
 23c:	03010113          	addi	sp,sp,48
 240:	00008067          	ret

Disassembly of section .text.parse_cmd:

0000000000000244 <parse_cmd>:
 244:	c9010113          	addi	sp,sp,-880
 248:	36113423          	sd	ra,872(sp)
 24c:	36813023          	sd	s0,864(sp)
 250:	34913c23          	sd	s1,856(sp)
 254:	35213823          	sd	s2,848(sp)
 258:	35313423          	sd	s3,840(sp)
 25c:	35413023          	sd	s4,832(sp)
 260:	33513c23          	sd	s5,824(sp)
 264:	33613823          	sd	s6,816(sp)
 268:	33713423          	sd	s7,808(sp)
 26c:	33813023          	sd	s8,800(sp)
 270:	31913c23          	sd	s9,792(sp)
 274:	31a13823          	sd	s10,784(sp)
 278:	31b13423          	sd	s11,776(sp)
 27c:	37010413          	addi	s0,sp,880
 280:	d0a43423          	sd	a0,-760(s0)
 284:	00058793          	mv	a5,a1
 288:	d0f42223          	sw	a5,-764(s0)
 28c:	d0843783          	ld	a5,-760(s0)
 290:	0007c783          	lbu	a5,0(a5)
 294:	00078713          	mv	a4,a5
 298:	06500793          	li	a5,101
 29c:	0af71863          	bne	a4,a5,34c <parse_cmd+0x108>
 2a0:	d0843783          	ld	a5,-760(s0)
 2a4:	00178793          	addi	a5,a5,1
 2a8:	0007c783          	lbu	a5,0(a5)
 2ac:	00078713          	mv	a4,a5
 2b0:	06300793          	li	a5,99
 2b4:	08f71c63          	bne	a4,a5,34c <parse_cmd+0x108>
 2b8:	d0843783          	ld	a5,-760(s0)
 2bc:	00278793          	addi	a5,a5,2
 2c0:	0007c783          	lbu	a5,0(a5)
 2c4:	00078713          	mv	a4,a5
 2c8:	06800793          	li	a5,104
 2cc:	08f71063          	bne	a4,a5,34c <parse_cmd+0x108>
 2d0:	d0843783          	ld	a5,-760(s0)
 2d4:	00378793          	addi	a5,a5,3
 2d8:	0007c783          	lbu	a5,0(a5)
 2dc:	00078713          	mv	a4,a5
 2e0:	06f00793          	li	a5,111
 2e4:	06f71463          	bne	a4,a5,34c <parse_cmd+0x108>
 2e8:	d0843783          	ld	a5,-760(s0)
 2ec:	00478793          	addi	a5,a5,4
 2f0:	d0f43423          	sd	a5,-760(s0)
 2f4:	d0843503          	ld	a0,-760(s0)
 2f8:	e6dff0ef          	jal	ra,164 <get_string>
 2fc:	f6a43823          	sd	a0,-144(s0)
 300:	f7043503          	ld	a0,-144(s0)
 304:	7f4010ef          	jal	ra,1af8 <strlen>
 308:	00050793          	mv	a5,a0
 30c:	d0f42223          	sw	a5,-764(s0)
 310:	d0442783          	lw	a5,-764(s0)
 314:	d0843703          	ld	a4,-760(s0)
 318:	00f707b3          	add	a5,a4,a5
 31c:	d0f43423          	sd	a5,-760(s0)
 320:	d0442783          	lw	a5,-764(s0)
 324:	00078613          	mv	a2,a5
 328:	f7043583          	ld	a1,-144(s0)
 32c:	00100513          	li	a0,1
 330:	015010ef          	jal	ra,1b44 <write>
 334:	00100613          	li	a2,1
 338:	00002597          	auipc	a1,0x2
 33c:	af858593          	addi	a1,a1,-1288 # 1e30 <lseek+0x74>
 340:	00100513          	li	a0,1
 344:	001010ef          	jal	ra,1b44 <write>
 348:	6780006f          	j	9c0 <parse_cmd+0x77c>
 34c:	d0843783          	ld	a5,-760(s0)
 350:	0007c783          	lbu	a5,0(a5)
 354:	00078713          	mv	a4,a5
 358:	06300793          	li	a5,99
 35c:	1af71c63          	bne	a4,a5,514 <parse_cmd+0x2d0>
 360:	d0843783          	ld	a5,-760(s0)
 364:	00178793          	addi	a5,a5,1
 368:	0007c783          	lbu	a5,0(a5)
 36c:	00078713          	mv	a4,a5
 370:	06100793          	li	a5,97
 374:	1af71063          	bne	a4,a5,514 <parse_cmd+0x2d0>
 378:	d0843783          	ld	a5,-760(s0)
 37c:	00278793          	addi	a5,a5,2
 380:	0007c783          	lbu	a5,0(a5)
 384:	00078713          	mv	a4,a5
 388:	07400793          	li	a5,116
 38c:	18f71463          	bne	a4,a5,514 <parse_cmd+0x2d0>
 390:	d0843783          	ld	a5,-760(s0)
 394:	00378793          	addi	a5,a5,3
 398:	00078513          	mv	a0,a5
 39c:	d15ff0ef          	jal	ra,b0 <get_param>
 3a0:	f6a43423          	sd	a0,-152(s0)
 3a4:	f6843703          	ld	a4,-152(s0)
 3a8:	00002697          	auipc	a3,0x2
 3ac:	b7868693          	addi	a3,a3,-1160 # 1f20 <__func__.0>
 3b0:	03c00613          	li	a2,60
 3b4:	00002597          	auipc	a1,0x2
 3b8:	a8458593          	addi	a1,a1,-1404 # 1e38 <lseek+0x7c>
 3bc:	00002517          	auipc	a0,0x2
 3c0:	a8450513          	addi	a0,a0,-1404 # 1e40 <lseek+0x84>
 3c4:	638010ef          	jal	ra,19fc <printf>
 3c8:	00100593          	li	a1,1
 3cc:	f6843503          	ld	a0,-152(s0)
 3d0:	15d010ef          	jal	ra,1d2c <open>
 3d4:	00050793          	mv	a5,a0
 3d8:	f6f42223          	sw	a5,-156(s0)
 3dc:	f6442783          	lw	a5,-156(s0)
 3e0:	00078713          	mv	a4,a5
 3e4:	00002697          	auipc	a3,0x2
 3e8:	b3c68693          	addi	a3,a3,-1220 # 1f20 <__func__.0>
 3ec:	03e00613          	li	a2,62
 3f0:	00002597          	auipc	a1,0x2
 3f4:	a4858593          	addi	a1,a1,-1464 # 1e38 <lseek+0x7c>
 3f8:	00002517          	auipc	a0,0x2
 3fc:	a6850513          	addi	a0,a0,-1432 # 1e60 <lseek+0xa4>
 400:	5fc010ef          	jal	ra,19fc <printf>
 404:	f6442783          	lw	a5,-156(s0)
 408:	0007871b          	sext.w	a4,a5
 40c:	fff00793          	li	a5,-1
 410:	00f71c63          	bne	a4,a5,428 <parse_cmd+0x1e4>
 414:	f6843583          	ld	a1,-152(s0)
 418:	00002517          	auipc	a0,0x2
 41c:	a6850513          	addi	a0,a0,-1432 # 1e80 <lseek+0xc4>
 420:	5dc010ef          	jal	ra,19fc <printf>
 424:	59c0006f          	j	9c0 <parse_cmd+0x77c>
 428:	d1840713          	addi	a4,s0,-744
 42c:	f6442783          	lw	a5,-156(s0)
 430:	1fd00613          	li	a2,509
 434:	00070593          	mv	a1,a4
 438:	00078513          	mv	a0,a5
 43c:	029010ef          	jal	ra,1c64 <read>
 440:	00050793          	mv	a5,a0
 444:	f6f42023          	sw	a5,-160(s0)
 448:	f6042783          	lw	a5,-160(s0)
 44c:	0007879b          	sext.w	a5,a5
 450:	02079263          	bnez	a5,474 <parse_cmd+0x230>
 454:	f8f44783          	lbu	a5,-113(s0)
 458:	0ff7f713          	zext.b	a4,a5
 45c:	00a00793          	li	a5,10
 460:	0af70063          	beq	a4,a5,500 <parse_cmd+0x2bc>
 464:	00002517          	auipc	a0,0x2
 468:	a3450513          	addi	a0,a0,-1484 # 1e98 <lseek+0xdc>
 46c:	590010ef          	jal	ra,19fc <printf>
 470:	0900006f          	j	500 <parse_cmd+0x2bc>
 474:	f8042423          	sw	zero,-120(s0)
 478:	06c0006f          	j	4e4 <parse_cmd+0x2a0>
 47c:	f8842783          	lw	a5,-120(s0)
 480:	f9078793          	addi	a5,a5,-112
 484:	008787b3          	add	a5,a5,s0
 488:	d887c783          	lbu	a5,-632(a5)
 48c:	00079e63          	bnez	a5,4a8 <parse_cmd+0x264>
 490:	00100613          	li	a2,1
 494:	00002597          	auipc	a1,0x2
 498:	a0c58593          	addi	a1,a1,-1524 # 1ea0 <lseek+0xe4>
 49c:	00100513          	li	a0,1
 4a0:	6a4010ef          	jal	ra,1b44 <write>
 4a4:	0200006f          	j	4c4 <parse_cmd+0x280>
 4a8:	d1840713          	addi	a4,s0,-744
 4ac:	f8842783          	lw	a5,-120(s0)
 4b0:	00f707b3          	add	a5,a4,a5
 4b4:	00100613          	li	a2,1
 4b8:	00078593          	mv	a1,a5
 4bc:	00100513          	li	a0,1
 4c0:	684010ef          	jal	ra,1b44 <write>
 4c4:	f8842783          	lw	a5,-120(s0)
 4c8:	f9078793          	addi	a5,a5,-112
 4cc:	008787b3          	add	a5,a5,s0
 4d0:	d887c783          	lbu	a5,-632(a5)
 4d4:	f8f407a3          	sb	a5,-113(s0)
 4d8:	f8842783          	lw	a5,-120(s0)
 4dc:	0017879b          	addiw	a5,a5,1
 4e0:	f8f42423          	sw	a5,-120(s0)
 4e4:	f8842783          	lw	a5,-120(s0)
 4e8:	00078713          	mv	a4,a5
 4ec:	f6042783          	lw	a5,-160(s0)
 4f0:	0007071b          	sext.w	a4,a4
 4f4:	0007879b          	sext.w	a5,a5
 4f8:	f8f742e3          	blt	a4,a5,47c <parse_cmd+0x238>
 4fc:	f2dff06f          	j	428 <parse_cmd+0x1e4>
 500:	00000013          	nop
 504:	f6442783          	lw	a5,-156(s0)
 508:	00078513          	mv	a0,a5
 50c:	069010ef          	jal	ra,1d74 <close>
 510:	4b00006f          	j	9c0 <parse_cmd+0x77c>
 514:	d0843783          	ld	a5,-760(s0)
 518:	0007c783          	lbu	a5,0(a5)
 51c:	00078713          	mv	a4,a5
 520:	06500793          	li	a5,101
 524:	48f71663          	bne	a4,a5,9b0 <parse_cmd+0x76c>
 528:	d0843783          	ld	a5,-760(s0)
 52c:	00178793          	addi	a5,a5,1
 530:	0007c783          	lbu	a5,0(a5)
 534:	00078713          	mv	a4,a5
 538:	06400793          	li	a5,100
 53c:	46f71a63          	bne	a4,a5,9b0 <parse_cmd+0x76c>
 540:	d0843783          	ld	a5,-760(s0)
 544:	00278793          	addi	a5,a5,2
 548:	0007c783          	lbu	a5,0(a5)
 54c:	00078713          	mv	a4,a5
 550:	06900793          	li	a5,105
 554:	44f71e63          	bne	a4,a5,9b0 <parse_cmd+0x76c>
 558:	d0843783          	ld	a5,-760(s0)
 55c:	00378793          	addi	a5,a5,3
 560:	0007c783          	lbu	a5,0(a5)
 564:	00078713          	mv	a4,a5
 568:	07400793          	li	a5,116
 56c:	44f71263          	bne	a4,a5,9b0 <parse_cmd+0x76c>
 570:	00010793          	mv	a5,sp
 574:	00078493          	mv	s1,a5
 578:	d0843783          	ld	a5,-760(s0)
 57c:	00478793          	addi	a5,a5,4
 580:	d0f43423          	sd	a5,-760(s0)
 584:	0100006f          	j	594 <parse_cmd+0x350>
 588:	d0843783          	ld	a5,-760(s0)
 58c:	00178793          	addi	a5,a5,1
 590:	d0f43423          	sd	a5,-760(s0)
 594:	d0843783          	ld	a5,-760(s0)
 598:	0007c783          	lbu	a5,0(a5)
 59c:	00078713          	mv	a4,a5
 5a0:	02000793          	li	a5,32
 5a4:	00f71863          	bne	a4,a5,5b4 <parse_cmd+0x370>
 5a8:	d0843783          	ld	a5,-760(s0)
 5ac:	0007c783          	lbu	a5,0(a5)
 5b0:	fc079ce3          	bnez	a5,588 <parse_cmd+0x344>
 5b4:	d0843503          	ld	a0,-760(s0)
 5b8:	af9ff0ef          	jal	ra,b0 <get_param>
 5bc:	f4a43c23          	sd	a0,-168(s0)
 5c0:	f5843503          	ld	a0,-168(s0)
 5c4:	534010ef          	jal	ra,1af8 <strlen>
 5c8:	00050793          	mv	a5,a0
 5cc:	f4f42a23          	sw	a5,-172(s0)
 5d0:	f5442783          	lw	a5,-172(s0)
 5d4:	0017879b          	addiw	a5,a5,1
 5d8:	0007879b          	sext.w	a5,a5
 5dc:	00078713          	mv	a4,a5
 5e0:	fff70713          	addi	a4,a4,-1
 5e4:	f4e43423          	sd	a4,-184(s0)
 5e8:	00078713          	mv	a4,a5
 5ec:	cee43823          	sd	a4,-784(s0)
 5f0:	ce043c23          	sd	zero,-776(s0)
 5f4:	cf043703          	ld	a4,-784(s0)
 5f8:	03d75713          	srli	a4,a4,0x3d
 5fc:	cf843683          	ld	a3,-776(s0)
 600:	00369693          	slli	a3,a3,0x3
 604:	c8d43c23          	sd	a3,-872(s0)
 608:	c9843683          	ld	a3,-872(s0)
 60c:	00d76733          	or	a4,a4,a3
 610:	c8e43c23          	sd	a4,-872(s0)
 614:	cf043703          	ld	a4,-784(s0)
 618:	00371713          	slli	a4,a4,0x3
 61c:	c8e43823          	sd	a4,-880(s0)
 620:	00078713          	mv	a4,a5
 624:	cee43023          	sd	a4,-800(s0)
 628:	ce043423          	sd	zero,-792(s0)
 62c:	ce043703          	ld	a4,-800(s0)
 630:	03d75713          	srli	a4,a4,0x3d
 634:	ce843683          	ld	a3,-792(s0)
 638:	00369d93          	slli	s11,a3,0x3
 63c:	01b76db3          	or	s11,a4,s11
 640:	ce043703          	ld	a4,-800(s0)
 644:	00371d13          	slli	s10,a4,0x3
 648:	00f78793          	addi	a5,a5,15
 64c:	0047d793          	srli	a5,a5,0x4
 650:	00479793          	slli	a5,a5,0x4
 654:	40f10133          	sub	sp,sp,a5
 658:	00010793          	mv	a5,sp
 65c:	00078793          	mv	a5,a5
 660:	f4f43023          	sd	a5,-192(s0)
 664:	f8042223          	sw	zero,-124(s0)
 668:	0300006f          	j	698 <parse_cmd+0x454>
 66c:	f8442783          	lw	a5,-124(s0)
 670:	f5843703          	ld	a4,-168(s0)
 674:	00f707b3          	add	a5,a4,a5
 678:	0007c703          	lbu	a4,0(a5)
 67c:	f4043683          	ld	a3,-192(s0)
 680:	f8442783          	lw	a5,-124(s0)
 684:	00f687b3          	add	a5,a3,a5
 688:	00e78023          	sb	a4,0(a5)
 68c:	f8442783          	lw	a5,-124(s0)
 690:	0017879b          	addiw	a5,a5,1
 694:	f8f42223          	sw	a5,-124(s0)
 698:	f8442783          	lw	a5,-124(s0)
 69c:	00078713          	mv	a4,a5
 6a0:	f5442783          	lw	a5,-172(s0)
 6a4:	0007071b          	sext.w	a4,a4
 6a8:	0007879b          	sext.w	a5,a5
 6ac:	fcf740e3          	blt	a4,a5,66c <parse_cmd+0x428>
 6b0:	f4043703          	ld	a4,-192(s0)
 6b4:	f5442783          	lw	a5,-172(s0)
 6b8:	00f707b3          	add	a5,a4,a5
 6bc:	00078023          	sb	zero,0(a5)
 6c0:	f5442783          	lw	a5,-172(s0)
 6c4:	d0843703          	ld	a4,-760(s0)
 6c8:	00f707b3          	add	a5,a4,a5
 6cc:	d0f43423          	sd	a5,-760(s0)
 6d0:	0100006f          	j	6e0 <parse_cmd+0x49c>
 6d4:	d0843783          	ld	a5,-760(s0)
 6d8:	00178793          	addi	a5,a5,1
 6dc:	d0f43423          	sd	a5,-760(s0)
 6e0:	d0843783          	ld	a5,-760(s0)
 6e4:	0007c783          	lbu	a5,0(a5)
 6e8:	00078713          	mv	a4,a5
 6ec:	02000793          	li	a5,32
 6f0:	00f71863          	bne	a4,a5,700 <parse_cmd+0x4bc>
 6f4:	d0843783          	ld	a5,-760(s0)
 6f8:	0007c783          	lbu	a5,0(a5)
 6fc:	fc079ce3          	bnez	a5,6d4 <parse_cmd+0x490>
 700:	d0843503          	ld	a0,-760(s0)
 704:	9adff0ef          	jal	ra,b0 <get_param>
 708:	f4a43c23          	sd	a0,-168(s0)
 70c:	f5843503          	ld	a0,-168(s0)
 710:	3e8010ef          	jal	ra,1af8 <strlen>
 714:	00050793          	mv	a5,a0
 718:	f4f42a23          	sw	a5,-172(s0)
 71c:	f5442783          	lw	a5,-172(s0)
 720:	0017879b          	addiw	a5,a5,1
 724:	0007879b          	sext.w	a5,a5
 728:	00078713          	mv	a4,a5
 72c:	fff70713          	addi	a4,a4,-1
 730:	f2e43c23          	sd	a4,-200(s0)
 734:	00078713          	mv	a4,a5
 738:	cce43823          	sd	a4,-816(s0)
 73c:	cc043c23          	sd	zero,-808(s0)
 740:	cd043703          	ld	a4,-816(s0)
 744:	03d75713          	srli	a4,a4,0x3d
 748:	cd843683          	ld	a3,-808(s0)
 74c:	00369c93          	slli	s9,a3,0x3
 750:	01976cb3          	or	s9,a4,s9
 754:	cd043703          	ld	a4,-816(s0)
 758:	00371c13          	slli	s8,a4,0x3
 75c:	00078713          	mv	a4,a5
 760:	cce43023          	sd	a4,-832(s0)
 764:	cc043423          	sd	zero,-824(s0)
 768:	cc043703          	ld	a4,-832(s0)
 76c:	03d75713          	srli	a4,a4,0x3d
 770:	cc843683          	ld	a3,-824(s0)
 774:	00369b93          	slli	s7,a3,0x3
 778:	01776bb3          	or	s7,a4,s7
 77c:	cc043703          	ld	a4,-832(s0)
 780:	00371b13          	slli	s6,a4,0x3
 784:	00f78793          	addi	a5,a5,15
 788:	0047d793          	srli	a5,a5,0x4
 78c:	00479793          	slli	a5,a5,0x4
 790:	40f10133          	sub	sp,sp,a5
 794:	00010793          	mv	a5,sp
 798:	00078793          	mv	a5,a5
 79c:	f2f43823          	sd	a5,-208(s0)
 7a0:	f8042023          	sw	zero,-128(s0)
 7a4:	0300006f          	j	7d4 <parse_cmd+0x590>
 7a8:	f8042783          	lw	a5,-128(s0)
 7ac:	f5843703          	ld	a4,-168(s0)
 7b0:	00f707b3          	add	a5,a4,a5
 7b4:	0007c703          	lbu	a4,0(a5)
 7b8:	f3043683          	ld	a3,-208(s0)
 7bc:	f8042783          	lw	a5,-128(s0)
 7c0:	00f687b3          	add	a5,a3,a5
 7c4:	00e78023          	sb	a4,0(a5)
 7c8:	f8042783          	lw	a5,-128(s0)
 7cc:	0017879b          	addiw	a5,a5,1
 7d0:	f8f42023          	sw	a5,-128(s0)
 7d4:	f8042783          	lw	a5,-128(s0)
 7d8:	00078713          	mv	a4,a5
 7dc:	f5442783          	lw	a5,-172(s0)
 7e0:	0007071b          	sext.w	a4,a4
 7e4:	0007879b          	sext.w	a5,a5
 7e8:	fcf740e3          	blt	a4,a5,7a8 <parse_cmd+0x564>
 7ec:	f3043703          	ld	a4,-208(s0)
 7f0:	f5442783          	lw	a5,-172(s0)
 7f4:	00f707b3          	add	a5,a4,a5
 7f8:	00078023          	sb	zero,0(a5)
 7fc:	f5442783          	lw	a5,-172(s0)
 800:	d0843703          	ld	a4,-760(s0)
 804:	00f707b3          	add	a5,a4,a5
 808:	d0f43423          	sd	a5,-760(s0)
 80c:	0100006f          	j	81c <parse_cmd+0x5d8>
 810:	d0843783          	ld	a5,-760(s0)
 814:	00178793          	addi	a5,a5,1
 818:	d0f43423          	sd	a5,-760(s0)
 81c:	d0843783          	ld	a5,-760(s0)
 820:	0007c783          	lbu	a5,0(a5)
 824:	00078713          	mv	a4,a5
 828:	02000793          	li	a5,32
 82c:	00f71863          	bne	a4,a5,83c <parse_cmd+0x5f8>
 830:	d0843783          	ld	a5,-760(s0)
 834:	0007c783          	lbu	a5,0(a5)
 838:	fc079ce3          	bnez	a5,810 <parse_cmd+0x5cc>
 83c:	d0843503          	ld	a0,-760(s0)
 840:	925ff0ef          	jal	ra,164 <get_string>
 844:	f4a43c23          	sd	a0,-168(s0)
 848:	f5843503          	ld	a0,-168(s0)
 84c:	2ac010ef          	jal	ra,1af8 <strlen>
 850:	00050793          	mv	a5,a0
 854:	f4f42a23          	sw	a5,-172(s0)
 858:	f5442783          	lw	a5,-172(s0)
 85c:	0017879b          	addiw	a5,a5,1
 860:	0007879b          	sext.w	a5,a5
 864:	00078713          	mv	a4,a5
 868:	fff70713          	addi	a4,a4,-1
 86c:	f2e43423          	sd	a4,-216(s0)
 870:	00078713          	mv	a4,a5
 874:	cae43823          	sd	a4,-848(s0)
 878:	ca043c23          	sd	zero,-840(s0)
 87c:	cb043703          	ld	a4,-848(s0)
 880:	03d75713          	srli	a4,a4,0x3d
 884:	cb843683          	ld	a3,-840(s0)
 888:	00369a93          	slli	s5,a3,0x3
 88c:	01576ab3          	or	s5,a4,s5
 890:	cb043703          	ld	a4,-848(s0)
 894:	00371a13          	slli	s4,a4,0x3
 898:	00078713          	mv	a4,a5
 89c:	cae43023          	sd	a4,-864(s0)
 8a0:	ca043423          	sd	zero,-856(s0)
 8a4:	ca043703          	ld	a4,-864(s0)
 8a8:	03d75713          	srli	a4,a4,0x3d
 8ac:	ca843683          	ld	a3,-856(s0)
 8b0:	00369993          	slli	s3,a3,0x3
 8b4:	013769b3          	or	s3,a4,s3
 8b8:	ca043703          	ld	a4,-864(s0)
 8bc:	00371913          	slli	s2,a4,0x3
 8c0:	00f78793          	addi	a5,a5,15
 8c4:	0047d793          	srli	a5,a5,0x4
 8c8:	00479793          	slli	a5,a5,0x4
 8cc:	40f10133          	sub	sp,sp,a5
 8d0:	00010793          	mv	a5,sp
 8d4:	00078793          	mv	a5,a5
 8d8:	f2f43023          	sd	a5,-224(s0)
 8dc:	f6042e23          	sw	zero,-132(s0)
 8e0:	0300006f          	j	910 <parse_cmd+0x6cc>
 8e4:	f7c42783          	lw	a5,-132(s0)
 8e8:	f5843703          	ld	a4,-168(s0)
 8ec:	00f707b3          	add	a5,a4,a5
 8f0:	0007c703          	lbu	a4,0(a5)
 8f4:	f2043683          	ld	a3,-224(s0)
 8f8:	f7c42783          	lw	a5,-132(s0)
 8fc:	00f687b3          	add	a5,a3,a5
 900:	00e78023          	sb	a4,0(a5)
 904:	f7c42783          	lw	a5,-132(s0)
 908:	0017879b          	addiw	a5,a5,1
 90c:	f6f42e23          	sw	a5,-132(s0)
 910:	f7c42783          	lw	a5,-132(s0)
 914:	00078713          	mv	a4,a5
 918:	f5442783          	lw	a5,-172(s0)
 91c:	0007071b          	sext.w	a4,a4
 920:	0007879b          	sext.w	a5,a5
 924:	fcf740e3          	blt	a4,a5,8e4 <parse_cmd+0x6a0>
 928:	f2043703          	ld	a4,-224(s0)
 92c:	f5442783          	lw	a5,-172(s0)
 930:	00f707b3          	add	a5,a4,a5
 934:	00078023          	sb	zero,0(a5)
 938:	f5442783          	lw	a5,-172(s0)
 93c:	d0843703          	ld	a4,-760(s0)
 940:	00f707b3          	add	a5,a4,a5
 944:	d0f43423          	sd	a5,-760(s0)
 948:	f3043503          	ld	a0,-208(s0)
 94c:	eb8ff0ef          	jal	ra,4 <atoi>
 950:	00050793          	mv	a5,a0
 954:	f0f42e23          	sw	a5,-228(s0)
 958:	00300593          	li	a1,3
 95c:	f4043503          	ld	a0,-192(s0)
 960:	3cc010ef          	jal	ra,1d2c <open>
 964:	00050793          	mv	a5,a0
 968:	f0f42c23          	sw	a5,-232(s0)
 96c:	f1c42703          	lw	a4,-228(s0)
 970:	f1842783          	lw	a5,-232(s0)
 974:	00000613          	li	a2,0
 978:	00070593          	mv	a1,a4
 97c:	00078513          	mv	a0,a5
 980:	43c010ef          	jal	ra,1dbc <lseek>
 984:	f5442703          	lw	a4,-172(s0)
 988:	f1842783          	lw	a5,-232(s0)
 98c:	00070613          	mv	a2,a4
 990:	f2043583          	ld	a1,-224(s0)
 994:	00078513          	mv	a0,a5
 998:	1ac010ef          	jal	ra,1b44 <write>
 99c:	f1842783          	lw	a5,-232(s0)
 9a0:	00078513          	mv	a0,a5
 9a4:	3d0010ef          	jal	ra,1d74 <close>
 9a8:	00048113          	mv	sp,s1
 9ac:	0140006f          	j	9c0 <parse_cmd+0x77c>
 9b0:	d0843583          	ld	a1,-760(s0)
 9b4:	00001517          	auipc	a0,0x1
 9b8:	4f450513          	addi	a0,a0,1268 # 1ea8 <lseek+0xec>
 9bc:	040010ef          	jal	ra,19fc <printf>
 9c0:	c9040113          	addi	sp,s0,-880
 9c4:	36813083          	ld	ra,872(sp)
 9c8:	36013403          	ld	s0,864(sp)
 9cc:	35813483          	ld	s1,856(sp)
 9d0:	35013903          	ld	s2,848(sp)
 9d4:	34813983          	ld	s3,840(sp)
 9d8:	34013a03          	ld	s4,832(sp)
 9dc:	33813a83          	ld	s5,824(sp)
 9e0:	33013b03          	ld	s6,816(sp)
 9e4:	32813b83          	ld	s7,808(sp)
 9e8:	32013c03          	ld	s8,800(sp)
 9ec:	31813c83          	ld	s9,792(sp)
 9f0:	31013d03          	ld	s10,784(sp)
 9f4:	30813d83          	ld	s11,776(sp)
 9f8:	37010113          	addi	sp,sp,880
 9fc:	00008067          	ret

Disassembly of section .text.main:

0000000000000a00 <main>:
 a00:	f6010113          	addi	sp,sp,-160
 a04:	08113c23          	sd	ra,152(sp)
 a08:	08813823          	sd	s0,144(sp)
 a0c:	0a010413          	addi	s0,sp,160
 a10:	00f00613          	li	a2,15
 a14:	00001597          	auipc	a1,0x1
 a18:	4ac58593          	addi	a1,a1,1196 # 1ec0 <lseek+0x104>
 a1c:	00100513          	li	a0,1
 a20:	124010ef          	jal	ra,1b44 <write>
 a24:	00f00613          	li	a2,15
 a28:	00001597          	auipc	a1,0x1
 a2c:	4a858593          	addi	a1,a1,1192 # 1ed0 <lseek+0x114>
 a30:	00200513          	li	a0,2
 a34:	110010ef          	jal	ra,1b44 <write>
 a38:	fe042623          	sw	zero,-20(s0)
 a3c:	00001517          	auipc	a0,0x1
 a40:	4a450513          	addi	a0,a0,1188 # 1ee0 <lseek+0x124>
 a44:	7b9000ef          	jal	ra,19fc <printf>
 a48:	fe840793          	addi	a5,s0,-24
 a4c:	00100613          	li	a2,1
 a50:	00078593          	mv	a1,a5
 a54:	00000513          	li	a0,0
 a58:	20c010ef          	jal	ra,1c64 <read>
 a5c:	fe844783          	lbu	a5,-24(s0)
 a60:	00078713          	mv	a4,a5
 a64:	00d00793          	li	a5,13
 a68:	00f71e63          	bne	a4,a5,a84 <main+0x84>
 a6c:	00100613          	li	a2,1
 a70:	00001597          	auipc	a1,0x1
 a74:	3c058593          	addi	a1,a1,960 # 1e30 <lseek+0x74>
 a78:	00100513          	li	a0,1
 a7c:	0c8010ef          	jal	ra,1b44 <write>
 a80:	0440006f          	j	ac4 <main+0xc4>
 a84:	fe844783          	lbu	a5,-24(s0)
 a88:	00078713          	mv	a4,a5
 a8c:	07f00793          	li	a5,127
 a90:	02f71a63          	bne	a4,a5,ac4 <main+0xc4>
 a94:	fec42783          	lw	a5,-20(s0)
 a98:	0007879b          	sext.w	a5,a5
 a9c:	0af05263          	blez	a5,b40 <main+0x140>
 aa0:	00300613          	li	a2,3
 aa4:	00001597          	auipc	a1,0x1
 aa8:	45458593          	addi	a1,a1,1108 # 1ef8 <lseek+0x13c>
 aac:	00100513          	li	a0,1
 ab0:	094010ef          	jal	ra,1b44 <write>
 ab4:	fec42783          	lw	a5,-20(s0)
 ab8:	fff7879b          	addiw	a5,a5,-1
 abc:	fef42623          	sw	a5,-20(s0)
 ac0:	0800006f          	j	b40 <main+0x140>
 ac4:	fe840793          	addi	a5,s0,-24
 ac8:	00100613          	li	a2,1
 acc:	00078593          	mv	a1,a5
 ad0:	00100513          	li	a0,1
 ad4:	070010ef          	jal	ra,1b44 <write>
 ad8:	fe844783          	lbu	a5,-24(s0)
 adc:	00078713          	mv	a4,a5
 ae0:	00d00793          	li	a5,13
 ae4:	02f71e63          	bne	a4,a5,b20 <main+0x120>
 ae8:	fec42783          	lw	a5,-20(s0)
 aec:	ff078793          	addi	a5,a5,-16
 af0:	008787b3          	add	a5,a5,s0
 af4:	f6078c23          	sb	zero,-136(a5)
 af8:	fec42703          	lw	a4,-20(s0)
 afc:	f6840793          	addi	a5,s0,-152
 b00:	00070593          	mv	a1,a4
 b04:	00078513          	mv	a0,a5
 b08:	f3cff0ef          	jal	ra,244 <parse_cmd>
 b0c:	fe042623          	sw	zero,-20(s0)
 b10:	00001517          	auipc	a0,0x1
 b14:	3d050513          	addi	a0,a0,976 # 1ee0 <lseek+0x124>
 b18:	6e5000ef          	jal	ra,19fc <printf>
 b1c:	f2dff06f          	j	a48 <main+0x48>
 b20:	fec42783          	lw	a5,-20(s0)
 b24:	0017871b          	addiw	a4,a5,1
 b28:	fee42623          	sw	a4,-20(s0)
 b2c:	fe844703          	lbu	a4,-24(s0)
 b30:	ff078793          	addi	a5,a5,-16
 b34:	008787b3          	add	a5,a5,s0
 b38:	f6e78c23          	sb	a4,-136(a5)
 b3c:	f0dff06f          	j	a48 <main+0x48>
 b40:	00000013          	nop
 b44:	f05ff06f          	j	a48 <main+0x48>

Disassembly of section .text.putc:

0000000000000b48 <putc>:
 b48:	fe010113          	addi	sp,sp,-32
 b4c:	00813c23          	sd	s0,24(sp)
 b50:	02010413          	addi	s0,sp,32
 b54:	00050793          	mv	a5,a0
 b58:	fef42623          	sw	a5,-20(s0)
 b5c:	00002797          	auipc	a5,0x2
 b60:	40478793          	addi	a5,a5,1028 # 2f60 <tail>
 b64:	0007a783          	lw	a5,0(a5)
 b68:	0017871b          	addiw	a4,a5,1
 b6c:	0007069b          	sext.w	a3,a4
 b70:	00002717          	auipc	a4,0x2
 b74:	3f070713          	addi	a4,a4,1008 # 2f60 <tail>
 b78:	00d72023          	sw	a3,0(a4)
 b7c:	fec42703          	lw	a4,-20(s0)
 b80:	0ff77713          	zext.b	a4,a4
 b84:	00002697          	auipc	a3,0x2
 b88:	3e468693          	addi	a3,a3,996 # 2f68 <buffer>
 b8c:	00f687b3          	add	a5,a3,a5
 b90:	00e78023          	sb	a4,0(a5)
 b94:	fec42783          	lw	a5,-20(s0)
 b98:	0ff7f793          	zext.b	a5,a5
 b9c:	0007879b          	sext.w	a5,a5
 ba0:	00078513          	mv	a0,a5
 ba4:	01813403          	ld	s0,24(sp)
 ba8:	02010113          	addi	sp,sp,32
 bac:	00008067          	ret

Disassembly of section .text.isspace:

0000000000000bb0 <isspace>:
 bb0:	fe010113          	addi	sp,sp,-32
 bb4:	00813c23          	sd	s0,24(sp)
 bb8:	02010413          	addi	s0,sp,32
 bbc:	00050793          	mv	a5,a0
 bc0:	fef42623          	sw	a5,-20(s0)
 bc4:	fec42783          	lw	a5,-20(s0)
 bc8:	0007871b          	sext.w	a4,a5
 bcc:	02000793          	li	a5,32
 bd0:	02f70263          	beq	a4,a5,bf4 <isspace+0x44>
 bd4:	fec42783          	lw	a5,-20(s0)
 bd8:	0007871b          	sext.w	a4,a5
 bdc:	00800793          	li	a5,8
 be0:	00e7de63          	bge	a5,a4,bfc <isspace+0x4c>
 be4:	fec42783          	lw	a5,-20(s0)
 be8:	0007871b          	sext.w	a4,a5
 bec:	00d00793          	li	a5,13
 bf0:	00e7c663          	blt	a5,a4,bfc <isspace+0x4c>
 bf4:	00100793          	li	a5,1
 bf8:	0080006f          	j	c00 <isspace+0x50>
 bfc:	00000793          	li	a5,0
 c00:	00078513          	mv	a0,a5
 c04:	01813403          	ld	s0,24(sp)
 c08:	02010113          	addi	sp,sp,32
 c0c:	00008067          	ret

Disassembly of section .text.strtol:

0000000000000c10 <strtol>:
 c10:	fb010113          	addi	sp,sp,-80
 c14:	04113423          	sd	ra,72(sp)
 c18:	04813023          	sd	s0,64(sp)
 c1c:	05010413          	addi	s0,sp,80
 c20:	fca43423          	sd	a0,-56(s0)
 c24:	fcb43023          	sd	a1,-64(s0)
 c28:	00060793          	mv	a5,a2
 c2c:	faf42e23          	sw	a5,-68(s0)
 c30:	fe043423          	sd	zero,-24(s0)
 c34:	fe0403a3          	sb	zero,-25(s0)
 c38:	fc843783          	ld	a5,-56(s0)
 c3c:	fcf43c23          	sd	a5,-40(s0)
 c40:	0100006f          	j	c50 <strtol+0x40>
 c44:	fd843783          	ld	a5,-40(s0)
 c48:	00178793          	addi	a5,a5,1
 c4c:	fcf43c23          	sd	a5,-40(s0)
 c50:	fd843783          	ld	a5,-40(s0)
 c54:	0007c783          	lbu	a5,0(a5)
 c58:	0007879b          	sext.w	a5,a5
 c5c:	00078513          	mv	a0,a5
 c60:	f51ff0ef          	jal	ra,bb0 <isspace>
 c64:	00050793          	mv	a5,a0
 c68:	fc079ee3          	bnez	a5,c44 <strtol+0x34>
 c6c:	fd843783          	ld	a5,-40(s0)
 c70:	0007c783          	lbu	a5,0(a5)
 c74:	00078713          	mv	a4,a5
 c78:	02d00793          	li	a5,45
 c7c:	00f71e63          	bne	a4,a5,c98 <strtol+0x88>
 c80:	00100793          	li	a5,1
 c84:	fef403a3          	sb	a5,-25(s0)
 c88:	fd843783          	ld	a5,-40(s0)
 c8c:	00178793          	addi	a5,a5,1
 c90:	fcf43c23          	sd	a5,-40(s0)
 c94:	0240006f          	j	cb8 <strtol+0xa8>
 c98:	fd843783          	ld	a5,-40(s0)
 c9c:	0007c783          	lbu	a5,0(a5)
 ca0:	00078713          	mv	a4,a5
 ca4:	02b00793          	li	a5,43
 ca8:	00f71863          	bne	a4,a5,cb8 <strtol+0xa8>
 cac:	fd843783          	ld	a5,-40(s0)
 cb0:	00178793          	addi	a5,a5,1
 cb4:	fcf43c23          	sd	a5,-40(s0)
 cb8:	fbc42783          	lw	a5,-68(s0)
 cbc:	0007879b          	sext.w	a5,a5
 cc0:	06079c63          	bnez	a5,d38 <strtol+0x128>
 cc4:	fd843783          	ld	a5,-40(s0)
 cc8:	0007c783          	lbu	a5,0(a5)
 ccc:	00078713          	mv	a4,a5
 cd0:	03000793          	li	a5,48
 cd4:	04f71e63          	bne	a4,a5,d30 <strtol+0x120>
 cd8:	fd843783          	ld	a5,-40(s0)
 cdc:	00178793          	addi	a5,a5,1
 ce0:	fcf43c23          	sd	a5,-40(s0)
 ce4:	fd843783          	ld	a5,-40(s0)
 ce8:	0007c783          	lbu	a5,0(a5)
 cec:	00078713          	mv	a4,a5
 cf0:	07800793          	li	a5,120
 cf4:	00f70c63          	beq	a4,a5,d0c <strtol+0xfc>
 cf8:	fd843783          	ld	a5,-40(s0)
 cfc:	0007c783          	lbu	a5,0(a5)
 d00:	00078713          	mv	a4,a5
 d04:	05800793          	li	a5,88
 d08:	00f71e63          	bne	a4,a5,d24 <strtol+0x114>
 d0c:	01000793          	li	a5,16
 d10:	faf42e23          	sw	a5,-68(s0)
 d14:	fd843783          	ld	a5,-40(s0)
 d18:	00178793          	addi	a5,a5,1
 d1c:	fcf43c23          	sd	a5,-40(s0)
 d20:	0180006f          	j	d38 <strtol+0x128>
 d24:	00800793          	li	a5,8
 d28:	faf42e23          	sw	a5,-68(s0)
 d2c:	00c0006f          	j	d38 <strtol+0x128>
 d30:	00a00793          	li	a5,10
 d34:	faf42e23          	sw	a5,-68(s0)
 d38:	fd843783          	ld	a5,-40(s0)
 d3c:	0007c783          	lbu	a5,0(a5)
 d40:	00078713          	mv	a4,a5
 d44:	02f00793          	li	a5,47
 d48:	02e7f863          	bgeu	a5,a4,d78 <strtol+0x168>
 d4c:	fd843783          	ld	a5,-40(s0)
 d50:	0007c783          	lbu	a5,0(a5)
 d54:	00078713          	mv	a4,a5
 d58:	03900793          	li	a5,57
 d5c:	00e7ee63          	bltu	a5,a4,d78 <strtol+0x168>
 d60:	fd843783          	ld	a5,-40(s0)
 d64:	0007c783          	lbu	a5,0(a5)
 d68:	0007879b          	sext.w	a5,a5
 d6c:	fd07879b          	addiw	a5,a5,-48
 d70:	fcf42a23          	sw	a5,-44(s0)
 d74:	0800006f          	j	df4 <strtol+0x1e4>
 d78:	fd843783          	ld	a5,-40(s0)
 d7c:	0007c783          	lbu	a5,0(a5)
 d80:	00078713          	mv	a4,a5
 d84:	06000793          	li	a5,96
 d88:	02e7f863          	bgeu	a5,a4,db8 <strtol+0x1a8>
 d8c:	fd843783          	ld	a5,-40(s0)
 d90:	0007c783          	lbu	a5,0(a5)
 d94:	00078713          	mv	a4,a5
 d98:	07a00793          	li	a5,122
 d9c:	00e7ee63          	bltu	a5,a4,db8 <strtol+0x1a8>
 da0:	fd843783          	ld	a5,-40(s0)
 da4:	0007c783          	lbu	a5,0(a5)
 da8:	0007879b          	sext.w	a5,a5
 dac:	fa97879b          	addiw	a5,a5,-87
 db0:	fcf42a23          	sw	a5,-44(s0)
 db4:	0400006f          	j	df4 <strtol+0x1e4>
 db8:	fd843783          	ld	a5,-40(s0)
 dbc:	0007c783          	lbu	a5,0(a5)
 dc0:	00078713          	mv	a4,a5
 dc4:	04000793          	li	a5,64
 dc8:	06e7f863          	bgeu	a5,a4,e38 <strtol+0x228>
 dcc:	fd843783          	ld	a5,-40(s0)
 dd0:	0007c783          	lbu	a5,0(a5)
 dd4:	00078713          	mv	a4,a5
 dd8:	05a00793          	li	a5,90
 ddc:	04e7ee63          	bltu	a5,a4,e38 <strtol+0x228>
 de0:	fd843783          	ld	a5,-40(s0)
 de4:	0007c783          	lbu	a5,0(a5)
 de8:	0007879b          	sext.w	a5,a5
 dec:	fc97879b          	addiw	a5,a5,-55
 df0:	fcf42a23          	sw	a5,-44(s0)
 df4:	fd442783          	lw	a5,-44(s0)
 df8:	00078713          	mv	a4,a5
 dfc:	fbc42783          	lw	a5,-68(s0)
 e00:	0007071b          	sext.w	a4,a4
 e04:	0007879b          	sext.w	a5,a5
 e08:	02f75663          	bge	a4,a5,e34 <strtol+0x224>
 e0c:	fbc42703          	lw	a4,-68(s0)
 e10:	fe843783          	ld	a5,-24(s0)
 e14:	02f70733          	mul	a4,a4,a5
 e18:	fd442783          	lw	a5,-44(s0)
 e1c:	00f707b3          	add	a5,a4,a5
 e20:	fef43423          	sd	a5,-24(s0)
 e24:	fd843783          	ld	a5,-40(s0)
 e28:	00178793          	addi	a5,a5,1
 e2c:	fcf43c23          	sd	a5,-40(s0)
 e30:	f09ff06f          	j	d38 <strtol+0x128>
 e34:	00000013          	nop
 e38:	fc043783          	ld	a5,-64(s0)
 e3c:	00078863          	beqz	a5,e4c <strtol+0x23c>
 e40:	fc043783          	ld	a5,-64(s0)
 e44:	fd843703          	ld	a4,-40(s0)
 e48:	00e7b023          	sd	a4,0(a5)
 e4c:	fe744783          	lbu	a5,-25(s0)
 e50:	0ff7f793          	zext.b	a5,a5
 e54:	00078863          	beqz	a5,e64 <strtol+0x254>
 e58:	fe843783          	ld	a5,-24(s0)
 e5c:	40f007b3          	neg	a5,a5
 e60:	0080006f          	j	e68 <strtol+0x258>
 e64:	fe843783          	ld	a5,-24(s0)
 e68:	00078513          	mv	a0,a5
 e6c:	04813083          	ld	ra,72(sp)
 e70:	04013403          	ld	s0,64(sp)
 e74:	05010113          	addi	sp,sp,80
 e78:	00008067          	ret

Disassembly of section .text.puts_wo_nl:

0000000000000e7c <puts_wo_nl>:
 e7c:	fd010113          	addi	sp,sp,-48
 e80:	02113423          	sd	ra,40(sp)
 e84:	02813023          	sd	s0,32(sp)
 e88:	03010413          	addi	s0,sp,48
 e8c:	fca43c23          	sd	a0,-40(s0)
 e90:	fcb43823          	sd	a1,-48(s0)
 e94:	fd043783          	ld	a5,-48(s0)
 e98:	00079863          	bnez	a5,ea8 <puts_wo_nl+0x2c>
 e9c:	00001797          	auipc	a5,0x1
 ea0:	06478793          	addi	a5,a5,100 # 1f00 <lseek+0x144>
 ea4:	fcf43823          	sd	a5,-48(s0)
 ea8:	fd043783          	ld	a5,-48(s0)
 eac:	fef43423          	sd	a5,-24(s0)
 eb0:	0240006f          	j	ed4 <puts_wo_nl+0x58>
 eb4:	fe843783          	ld	a5,-24(s0)
 eb8:	00178713          	addi	a4,a5,1
 ebc:	fee43423          	sd	a4,-24(s0)
 ec0:	0007c783          	lbu	a5,0(a5)
 ec4:	0007871b          	sext.w	a4,a5
 ec8:	fd843783          	ld	a5,-40(s0)
 ecc:	00070513          	mv	a0,a4
 ed0:	000780e7          	jalr	a5
 ed4:	fe843783          	ld	a5,-24(s0)
 ed8:	0007c783          	lbu	a5,0(a5)
 edc:	fc079ce3          	bnez	a5,eb4 <puts_wo_nl+0x38>
 ee0:	fe843703          	ld	a4,-24(s0)
 ee4:	fd043783          	ld	a5,-48(s0)
 ee8:	40f707b3          	sub	a5,a4,a5
 eec:	0007879b          	sext.w	a5,a5
 ef0:	00078513          	mv	a0,a5
 ef4:	02813083          	ld	ra,40(sp)
 ef8:	02013403          	ld	s0,32(sp)
 efc:	03010113          	addi	sp,sp,48
 f00:	00008067          	ret

Disassembly of section .text.print_dec_int:

0000000000000f04 <print_dec_int>:
     f04:	f9010113          	addi	sp,sp,-112
     f08:	06113423          	sd	ra,104(sp)
     f0c:	06813023          	sd	s0,96(sp)
     f10:	07010413          	addi	s0,sp,112
     f14:	faa43423          	sd	a0,-88(s0)
     f18:	fab43023          	sd	a1,-96(s0)
     f1c:	00060793          	mv	a5,a2
     f20:	f8d43823          	sd	a3,-112(s0)
     f24:	f8f40fa3          	sb	a5,-97(s0)
     f28:	f9f44783          	lbu	a5,-97(s0)
     f2c:	0ff7f793          	zext.b	a5,a5
     f30:	02078663          	beqz	a5,f5c <print_dec_int+0x58>
     f34:	fa043703          	ld	a4,-96(s0)
     f38:	fff00793          	li	a5,-1
     f3c:	03f79793          	slli	a5,a5,0x3f
     f40:	00f71e63          	bne	a4,a5,f5c <print_dec_int+0x58>
     f44:	00001597          	auipc	a1,0x1
     f48:	fc458593          	addi	a1,a1,-60 # 1f08 <lseek+0x14c>
     f4c:	fa843503          	ld	a0,-88(s0)
     f50:	f2dff0ef          	jal	ra,e7c <puts_wo_nl>
     f54:	00050793          	mv	a5,a0
     f58:	2a00006f          	j	11f8 <print_dec_int+0x2f4>
     f5c:	f9043783          	ld	a5,-112(s0)
     f60:	00c7a783          	lw	a5,12(a5)
     f64:	00079a63          	bnez	a5,f78 <print_dec_int+0x74>
     f68:	fa043783          	ld	a5,-96(s0)
     f6c:	00079663          	bnez	a5,f78 <print_dec_int+0x74>
     f70:	00000793          	li	a5,0
     f74:	2840006f          	j	11f8 <print_dec_int+0x2f4>
     f78:	fe0407a3          	sb	zero,-17(s0)
     f7c:	f9f44783          	lbu	a5,-97(s0)
     f80:	0ff7f793          	zext.b	a5,a5
     f84:	02078063          	beqz	a5,fa4 <print_dec_int+0xa0>
     f88:	fa043783          	ld	a5,-96(s0)
     f8c:	0007dc63          	bgez	a5,fa4 <print_dec_int+0xa0>
     f90:	00100793          	li	a5,1
     f94:	fef407a3          	sb	a5,-17(s0)
     f98:	fa043783          	ld	a5,-96(s0)
     f9c:	40f007b3          	neg	a5,a5
     fa0:	faf43023          	sd	a5,-96(s0)
     fa4:	fe042423          	sw	zero,-24(s0)
     fa8:	f9f44783          	lbu	a5,-97(s0)
     fac:	0ff7f793          	zext.b	a5,a5
     fb0:	02078863          	beqz	a5,fe0 <print_dec_int+0xdc>
     fb4:	fef44783          	lbu	a5,-17(s0)
     fb8:	0ff7f793          	zext.b	a5,a5
     fbc:	00079e63          	bnez	a5,fd8 <print_dec_int+0xd4>
     fc0:	f9043783          	ld	a5,-112(s0)
     fc4:	0057c783          	lbu	a5,5(a5)
     fc8:	00079863          	bnez	a5,fd8 <print_dec_int+0xd4>
     fcc:	f9043783          	ld	a5,-112(s0)
     fd0:	0047c783          	lbu	a5,4(a5)
     fd4:	00078663          	beqz	a5,fe0 <print_dec_int+0xdc>
     fd8:	00100793          	li	a5,1
     fdc:	0080006f          	j	fe4 <print_dec_int+0xe0>
     fe0:	00000793          	li	a5,0
     fe4:	fcf40ba3          	sb	a5,-41(s0)
     fe8:	fd744783          	lbu	a5,-41(s0)
     fec:	0017f793          	andi	a5,a5,1
     ff0:	fcf40ba3          	sb	a5,-41(s0)
     ff4:	fa043703          	ld	a4,-96(s0)
     ff8:	00a00793          	li	a5,10
     ffc:	02f777b3          	remu	a5,a4,a5
    1000:	0ff7f713          	zext.b	a4,a5
    1004:	fe842783          	lw	a5,-24(s0)
    1008:	0017869b          	addiw	a3,a5,1
    100c:	fed42423          	sw	a3,-24(s0)
    1010:	0307071b          	addiw	a4,a4,48
    1014:	0ff77713          	zext.b	a4,a4
    1018:	ff078793          	addi	a5,a5,-16
    101c:	008787b3          	add	a5,a5,s0
    1020:	fce78423          	sb	a4,-56(a5)
    1024:	fa043703          	ld	a4,-96(s0)
    1028:	00a00793          	li	a5,10
    102c:	02f757b3          	divu	a5,a4,a5
    1030:	faf43023          	sd	a5,-96(s0)
    1034:	fa043783          	ld	a5,-96(s0)
    1038:	fa079ee3          	bnez	a5,ff4 <print_dec_int+0xf0>
    103c:	f9043783          	ld	a5,-112(s0)
    1040:	00c7a783          	lw	a5,12(a5)
    1044:	00078713          	mv	a4,a5
    1048:	fff00793          	li	a5,-1
    104c:	02f71063          	bne	a4,a5,106c <print_dec_int+0x168>
    1050:	f9043783          	ld	a5,-112(s0)
    1054:	0037c783          	lbu	a5,3(a5)
    1058:	00078a63          	beqz	a5,106c <print_dec_int+0x168>
    105c:	f9043783          	ld	a5,-112(s0)
    1060:	0087a703          	lw	a4,8(a5)
    1064:	f9043783          	ld	a5,-112(s0)
    1068:	00e7a623          	sw	a4,12(a5)
    106c:	fe042223          	sw	zero,-28(s0)
    1070:	f9043783          	ld	a5,-112(s0)
    1074:	0087a703          	lw	a4,8(a5)
    1078:	fe842783          	lw	a5,-24(s0)
    107c:	fcf42823          	sw	a5,-48(s0)
    1080:	f9043783          	ld	a5,-112(s0)
    1084:	00c7a783          	lw	a5,12(a5)
    1088:	fcf42623          	sw	a5,-52(s0)
    108c:	fd042783          	lw	a5,-48(s0)
    1090:	00078593          	mv	a1,a5
    1094:	fcc42783          	lw	a5,-52(s0)
    1098:	00078613          	mv	a2,a5
    109c:	0006069b          	sext.w	a3,a2
    10a0:	0005879b          	sext.w	a5,a1
    10a4:	00f6d463          	bge	a3,a5,10ac <print_dec_int+0x1a8>
    10a8:	00058613          	mv	a2,a1
    10ac:	0006079b          	sext.w	a5,a2
    10b0:	40f707bb          	subw	a5,a4,a5
    10b4:	0007871b          	sext.w	a4,a5
    10b8:	fd744783          	lbu	a5,-41(s0)
    10bc:	0007879b          	sext.w	a5,a5
    10c0:	40f707bb          	subw	a5,a4,a5
    10c4:	fef42023          	sw	a5,-32(s0)
    10c8:	0280006f          	j	10f0 <print_dec_int+0x1ec>
    10cc:	fa843783          	ld	a5,-88(s0)
    10d0:	02000513          	li	a0,32
    10d4:	000780e7          	jalr	a5
    10d8:	fe442783          	lw	a5,-28(s0)
    10dc:	0017879b          	addiw	a5,a5,1
    10e0:	fef42223          	sw	a5,-28(s0)
    10e4:	fe042783          	lw	a5,-32(s0)
    10e8:	fff7879b          	addiw	a5,a5,-1
    10ec:	fef42023          	sw	a5,-32(s0)
    10f0:	fe042783          	lw	a5,-32(s0)
    10f4:	0007879b          	sext.w	a5,a5
    10f8:	fcf04ae3          	bgtz	a5,10cc <print_dec_int+0x1c8>
    10fc:	fd744783          	lbu	a5,-41(s0)
    1100:	0ff7f793          	zext.b	a5,a5
    1104:	04078463          	beqz	a5,114c <print_dec_int+0x248>
    1108:	fef44783          	lbu	a5,-17(s0)
    110c:	0ff7f793          	zext.b	a5,a5
    1110:	00078663          	beqz	a5,111c <print_dec_int+0x218>
    1114:	02d00793          	li	a5,45
    1118:	01c0006f          	j	1134 <print_dec_int+0x230>
    111c:	f9043783          	ld	a5,-112(s0)
    1120:	0057c783          	lbu	a5,5(a5)
    1124:	00078663          	beqz	a5,1130 <print_dec_int+0x22c>
    1128:	02b00793          	li	a5,43
    112c:	0080006f          	j	1134 <print_dec_int+0x230>
    1130:	02000793          	li	a5,32
    1134:	fa843703          	ld	a4,-88(s0)
    1138:	00078513          	mv	a0,a5
    113c:	000700e7          	jalr	a4
    1140:	fe442783          	lw	a5,-28(s0)
    1144:	0017879b          	addiw	a5,a5,1
    1148:	fef42223          	sw	a5,-28(s0)
    114c:	fe842783          	lw	a5,-24(s0)
    1150:	fcf42e23          	sw	a5,-36(s0)
    1154:	0280006f          	j	117c <print_dec_int+0x278>
    1158:	fa843783          	ld	a5,-88(s0)
    115c:	03000513          	li	a0,48
    1160:	000780e7          	jalr	a5
    1164:	fe442783          	lw	a5,-28(s0)
    1168:	0017879b          	addiw	a5,a5,1
    116c:	fef42223          	sw	a5,-28(s0)
    1170:	fdc42783          	lw	a5,-36(s0)
    1174:	0017879b          	addiw	a5,a5,1
    1178:	fcf42e23          	sw	a5,-36(s0)
    117c:	f9043783          	ld	a5,-112(s0)
    1180:	00c7a703          	lw	a4,12(a5)
    1184:	fd744783          	lbu	a5,-41(s0)
    1188:	0007879b          	sext.w	a5,a5
    118c:	40f707bb          	subw	a5,a4,a5
    1190:	0007871b          	sext.w	a4,a5
    1194:	fdc42783          	lw	a5,-36(s0)
    1198:	0007879b          	sext.w	a5,a5
    119c:	fae7cee3          	blt	a5,a4,1158 <print_dec_int+0x254>
    11a0:	fe842783          	lw	a5,-24(s0)
    11a4:	fff7879b          	addiw	a5,a5,-1
    11a8:	fcf42c23          	sw	a5,-40(s0)
    11ac:	03c0006f          	j	11e8 <print_dec_int+0x2e4>
    11b0:	fd842783          	lw	a5,-40(s0)
    11b4:	ff078793          	addi	a5,a5,-16
    11b8:	008787b3          	add	a5,a5,s0
    11bc:	fc87c783          	lbu	a5,-56(a5)
    11c0:	0007871b          	sext.w	a4,a5
    11c4:	fa843783          	ld	a5,-88(s0)
    11c8:	00070513          	mv	a0,a4
    11cc:	000780e7          	jalr	a5
    11d0:	fe442783          	lw	a5,-28(s0)
    11d4:	0017879b          	addiw	a5,a5,1
    11d8:	fef42223          	sw	a5,-28(s0)
    11dc:	fd842783          	lw	a5,-40(s0)
    11e0:	fff7879b          	addiw	a5,a5,-1
    11e4:	fcf42c23          	sw	a5,-40(s0)
    11e8:	fd842783          	lw	a5,-40(s0)
    11ec:	0007879b          	sext.w	a5,a5
    11f0:	fc07d0e3          	bgez	a5,11b0 <print_dec_int+0x2ac>
    11f4:	fe442783          	lw	a5,-28(s0)
    11f8:	00078513          	mv	a0,a5
    11fc:	06813083          	ld	ra,104(sp)
    1200:	06013403          	ld	s0,96(sp)
    1204:	07010113          	addi	sp,sp,112
    1208:	00008067          	ret

Disassembly of section .text.vprintfmt:

000000000000120c <vprintfmt>:
    120c:	f4010113          	addi	sp,sp,-192
    1210:	0a113c23          	sd	ra,184(sp)
    1214:	0a813823          	sd	s0,176(sp)
    1218:	0c010413          	addi	s0,sp,192
    121c:	f4a43c23          	sd	a0,-168(s0)
    1220:	f4b43823          	sd	a1,-176(s0)
    1224:	f4c43423          	sd	a2,-184(s0)
    1228:	f8043023          	sd	zero,-128(s0)
    122c:	f8043423          	sd	zero,-120(s0)
    1230:	fe042623          	sw	zero,-20(s0)
    1234:	7a40006f          	j	19d8 <vprintfmt+0x7cc>
    1238:	f8044783          	lbu	a5,-128(s0)
    123c:	72078e63          	beqz	a5,1978 <vprintfmt+0x76c>
    1240:	f5043783          	ld	a5,-176(s0)
    1244:	0007c783          	lbu	a5,0(a5)
    1248:	00078713          	mv	a4,a5
    124c:	02300793          	li	a5,35
    1250:	00f71863          	bne	a4,a5,1260 <vprintfmt+0x54>
    1254:	00100793          	li	a5,1
    1258:	f8f40123          	sb	a5,-126(s0)
    125c:	7700006f          	j	19cc <vprintfmt+0x7c0>
    1260:	f5043783          	ld	a5,-176(s0)
    1264:	0007c783          	lbu	a5,0(a5)
    1268:	00078713          	mv	a4,a5
    126c:	03000793          	li	a5,48
    1270:	00f71863          	bne	a4,a5,1280 <vprintfmt+0x74>
    1274:	00100793          	li	a5,1
    1278:	f8f401a3          	sb	a5,-125(s0)
    127c:	7500006f          	j	19cc <vprintfmt+0x7c0>
    1280:	f5043783          	ld	a5,-176(s0)
    1284:	0007c783          	lbu	a5,0(a5)
    1288:	00078713          	mv	a4,a5
    128c:	06c00793          	li	a5,108
    1290:	04f70063          	beq	a4,a5,12d0 <vprintfmt+0xc4>
    1294:	f5043783          	ld	a5,-176(s0)
    1298:	0007c783          	lbu	a5,0(a5)
    129c:	00078713          	mv	a4,a5
    12a0:	07a00793          	li	a5,122
    12a4:	02f70663          	beq	a4,a5,12d0 <vprintfmt+0xc4>
    12a8:	f5043783          	ld	a5,-176(s0)
    12ac:	0007c783          	lbu	a5,0(a5)
    12b0:	00078713          	mv	a4,a5
    12b4:	07400793          	li	a5,116
    12b8:	00f70c63          	beq	a4,a5,12d0 <vprintfmt+0xc4>
    12bc:	f5043783          	ld	a5,-176(s0)
    12c0:	0007c783          	lbu	a5,0(a5)
    12c4:	00078713          	mv	a4,a5
    12c8:	06a00793          	li	a5,106
    12cc:	00f71863          	bne	a4,a5,12dc <vprintfmt+0xd0>
    12d0:	00100793          	li	a5,1
    12d4:	f8f400a3          	sb	a5,-127(s0)
    12d8:	6f40006f          	j	19cc <vprintfmt+0x7c0>
    12dc:	f5043783          	ld	a5,-176(s0)
    12e0:	0007c783          	lbu	a5,0(a5)
    12e4:	00078713          	mv	a4,a5
    12e8:	02b00793          	li	a5,43
    12ec:	00f71863          	bne	a4,a5,12fc <vprintfmt+0xf0>
    12f0:	00100793          	li	a5,1
    12f4:	f8f402a3          	sb	a5,-123(s0)
    12f8:	6d40006f          	j	19cc <vprintfmt+0x7c0>
    12fc:	f5043783          	ld	a5,-176(s0)
    1300:	0007c783          	lbu	a5,0(a5)
    1304:	00078713          	mv	a4,a5
    1308:	02000793          	li	a5,32
    130c:	00f71863          	bne	a4,a5,131c <vprintfmt+0x110>
    1310:	00100793          	li	a5,1
    1314:	f8f40223          	sb	a5,-124(s0)
    1318:	6b40006f          	j	19cc <vprintfmt+0x7c0>
    131c:	f5043783          	ld	a5,-176(s0)
    1320:	0007c783          	lbu	a5,0(a5)
    1324:	00078713          	mv	a4,a5
    1328:	02a00793          	li	a5,42
    132c:	00f71e63          	bne	a4,a5,1348 <vprintfmt+0x13c>
    1330:	f4843783          	ld	a5,-184(s0)
    1334:	00878713          	addi	a4,a5,8
    1338:	f4e43423          	sd	a4,-184(s0)
    133c:	0007a783          	lw	a5,0(a5)
    1340:	f8f42423          	sw	a5,-120(s0)
    1344:	6880006f          	j	19cc <vprintfmt+0x7c0>
    1348:	f5043783          	ld	a5,-176(s0)
    134c:	0007c783          	lbu	a5,0(a5)
    1350:	00078713          	mv	a4,a5
    1354:	03000793          	li	a5,48
    1358:	04e7f663          	bgeu	a5,a4,13a4 <vprintfmt+0x198>
    135c:	f5043783          	ld	a5,-176(s0)
    1360:	0007c783          	lbu	a5,0(a5)
    1364:	00078713          	mv	a4,a5
    1368:	03900793          	li	a5,57
    136c:	02e7ec63          	bltu	a5,a4,13a4 <vprintfmt+0x198>
    1370:	f5043783          	ld	a5,-176(s0)
    1374:	f5040713          	addi	a4,s0,-176
    1378:	00a00613          	li	a2,10
    137c:	00070593          	mv	a1,a4
    1380:	00078513          	mv	a0,a5
    1384:	88dff0ef          	jal	ra,c10 <strtol>
    1388:	00050793          	mv	a5,a0
    138c:	0007879b          	sext.w	a5,a5
    1390:	f8f42423          	sw	a5,-120(s0)
    1394:	f5043783          	ld	a5,-176(s0)
    1398:	fff78793          	addi	a5,a5,-1
    139c:	f4f43823          	sd	a5,-176(s0)
    13a0:	62c0006f          	j	19cc <vprintfmt+0x7c0>
    13a4:	f5043783          	ld	a5,-176(s0)
    13a8:	0007c783          	lbu	a5,0(a5)
    13ac:	00078713          	mv	a4,a5
    13b0:	02e00793          	li	a5,46
    13b4:	06f71863          	bne	a4,a5,1424 <vprintfmt+0x218>
    13b8:	f5043783          	ld	a5,-176(s0)
    13bc:	00178793          	addi	a5,a5,1
    13c0:	f4f43823          	sd	a5,-176(s0)
    13c4:	f5043783          	ld	a5,-176(s0)
    13c8:	0007c783          	lbu	a5,0(a5)
    13cc:	00078713          	mv	a4,a5
    13d0:	02a00793          	li	a5,42
    13d4:	00f71e63          	bne	a4,a5,13f0 <vprintfmt+0x1e4>
    13d8:	f4843783          	ld	a5,-184(s0)
    13dc:	00878713          	addi	a4,a5,8
    13e0:	f4e43423          	sd	a4,-184(s0)
    13e4:	0007a783          	lw	a5,0(a5)
    13e8:	f8f42623          	sw	a5,-116(s0)
    13ec:	5e00006f          	j	19cc <vprintfmt+0x7c0>
    13f0:	f5043783          	ld	a5,-176(s0)
    13f4:	f5040713          	addi	a4,s0,-176
    13f8:	00a00613          	li	a2,10
    13fc:	00070593          	mv	a1,a4
    1400:	00078513          	mv	a0,a5
    1404:	80dff0ef          	jal	ra,c10 <strtol>
    1408:	00050793          	mv	a5,a0
    140c:	0007879b          	sext.w	a5,a5
    1410:	f8f42623          	sw	a5,-116(s0)
    1414:	f5043783          	ld	a5,-176(s0)
    1418:	fff78793          	addi	a5,a5,-1
    141c:	f4f43823          	sd	a5,-176(s0)
    1420:	5ac0006f          	j	19cc <vprintfmt+0x7c0>
    1424:	f5043783          	ld	a5,-176(s0)
    1428:	0007c783          	lbu	a5,0(a5)
    142c:	00078713          	mv	a4,a5
    1430:	07800793          	li	a5,120
    1434:	02f70663          	beq	a4,a5,1460 <vprintfmt+0x254>
    1438:	f5043783          	ld	a5,-176(s0)
    143c:	0007c783          	lbu	a5,0(a5)
    1440:	00078713          	mv	a4,a5
    1444:	05800793          	li	a5,88
    1448:	00f70c63          	beq	a4,a5,1460 <vprintfmt+0x254>
    144c:	f5043783          	ld	a5,-176(s0)
    1450:	0007c783          	lbu	a5,0(a5)
    1454:	00078713          	mv	a4,a5
    1458:	07000793          	li	a5,112
    145c:	30f71263          	bne	a4,a5,1760 <vprintfmt+0x554>
    1460:	f5043783          	ld	a5,-176(s0)
    1464:	0007c783          	lbu	a5,0(a5)
    1468:	00078713          	mv	a4,a5
    146c:	07000793          	li	a5,112
    1470:	00f70663          	beq	a4,a5,147c <vprintfmt+0x270>
    1474:	f8144783          	lbu	a5,-127(s0)
    1478:	00078663          	beqz	a5,1484 <vprintfmt+0x278>
    147c:	00100793          	li	a5,1
    1480:	0080006f          	j	1488 <vprintfmt+0x27c>
    1484:	00000793          	li	a5,0
    1488:	faf403a3          	sb	a5,-89(s0)
    148c:	fa744783          	lbu	a5,-89(s0)
    1490:	0017f793          	andi	a5,a5,1
    1494:	faf403a3          	sb	a5,-89(s0)
    1498:	fa744783          	lbu	a5,-89(s0)
    149c:	0ff7f793          	zext.b	a5,a5
    14a0:	00078c63          	beqz	a5,14b8 <vprintfmt+0x2ac>
    14a4:	f4843783          	ld	a5,-184(s0)
    14a8:	00878713          	addi	a4,a5,8
    14ac:	f4e43423          	sd	a4,-184(s0)
    14b0:	0007b783          	ld	a5,0(a5)
    14b4:	01c0006f          	j	14d0 <vprintfmt+0x2c4>
    14b8:	f4843783          	ld	a5,-184(s0)
    14bc:	00878713          	addi	a4,a5,8
    14c0:	f4e43423          	sd	a4,-184(s0)
    14c4:	0007a783          	lw	a5,0(a5)
    14c8:	02079793          	slli	a5,a5,0x20
    14cc:	0207d793          	srli	a5,a5,0x20
    14d0:	fef43023          	sd	a5,-32(s0)
    14d4:	f8c42783          	lw	a5,-116(s0)
    14d8:	02079463          	bnez	a5,1500 <vprintfmt+0x2f4>
    14dc:	fe043783          	ld	a5,-32(s0)
    14e0:	02079063          	bnez	a5,1500 <vprintfmt+0x2f4>
    14e4:	f5043783          	ld	a5,-176(s0)
    14e8:	0007c783          	lbu	a5,0(a5)
    14ec:	00078713          	mv	a4,a5
    14f0:	07000793          	li	a5,112
    14f4:	00f70663          	beq	a4,a5,1500 <vprintfmt+0x2f4>
    14f8:	f8040023          	sb	zero,-128(s0)
    14fc:	4d00006f          	j	19cc <vprintfmt+0x7c0>
    1500:	f5043783          	ld	a5,-176(s0)
    1504:	0007c783          	lbu	a5,0(a5)
    1508:	00078713          	mv	a4,a5
    150c:	07000793          	li	a5,112
    1510:	00f70a63          	beq	a4,a5,1524 <vprintfmt+0x318>
    1514:	f8244783          	lbu	a5,-126(s0)
    1518:	00078a63          	beqz	a5,152c <vprintfmt+0x320>
    151c:	fe043783          	ld	a5,-32(s0)
    1520:	00078663          	beqz	a5,152c <vprintfmt+0x320>
    1524:	00100793          	li	a5,1
    1528:	0080006f          	j	1530 <vprintfmt+0x324>
    152c:	00000793          	li	a5,0
    1530:	faf40323          	sb	a5,-90(s0)
    1534:	fa644783          	lbu	a5,-90(s0)
    1538:	0017f793          	andi	a5,a5,1
    153c:	faf40323          	sb	a5,-90(s0)
    1540:	fc042e23          	sw	zero,-36(s0)
    1544:	f5043783          	ld	a5,-176(s0)
    1548:	0007c783          	lbu	a5,0(a5)
    154c:	00078713          	mv	a4,a5
    1550:	05800793          	li	a5,88
    1554:	00f71863          	bne	a4,a5,1564 <vprintfmt+0x358>
    1558:	00001797          	auipc	a5,0x1
    155c:	9d878793          	addi	a5,a5,-1576 # 1f30 <upperxdigits.1>
    1560:	00c0006f          	j	156c <vprintfmt+0x360>
    1564:	00001797          	auipc	a5,0x1
    1568:	9e478793          	addi	a5,a5,-1564 # 1f48 <lowerxdigits.0>
    156c:	f8f43c23          	sd	a5,-104(s0)
    1570:	fe043783          	ld	a5,-32(s0)
    1574:	00f7f793          	andi	a5,a5,15
    1578:	f9843703          	ld	a4,-104(s0)
    157c:	00f70733          	add	a4,a4,a5
    1580:	fdc42783          	lw	a5,-36(s0)
    1584:	0017869b          	addiw	a3,a5,1
    1588:	fcd42e23          	sw	a3,-36(s0)
    158c:	00074703          	lbu	a4,0(a4)
    1590:	ff078793          	addi	a5,a5,-16
    1594:	008787b3          	add	a5,a5,s0
    1598:	f8e78023          	sb	a4,-128(a5)
    159c:	fe043783          	ld	a5,-32(s0)
    15a0:	0047d793          	srli	a5,a5,0x4
    15a4:	fef43023          	sd	a5,-32(s0)
    15a8:	fe043783          	ld	a5,-32(s0)
    15ac:	fc0792e3          	bnez	a5,1570 <vprintfmt+0x364>
    15b0:	f8c42783          	lw	a5,-116(s0)
    15b4:	00078713          	mv	a4,a5
    15b8:	fff00793          	li	a5,-1
    15bc:	02f71663          	bne	a4,a5,15e8 <vprintfmt+0x3dc>
    15c0:	f8344783          	lbu	a5,-125(s0)
    15c4:	02078263          	beqz	a5,15e8 <vprintfmt+0x3dc>
    15c8:	f8842703          	lw	a4,-120(s0)
    15cc:	fa644783          	lbu	a5,-90(s0)
    15d0:	0007879b          	sext.w	a5,a5
    15d4:	0017979b          	slliw	a5,a5,0x1
    15d8:	0007879b          	sext.w	a5,a5
    15dc:	40f707bb          	subw	a5,a4,a5
    15e0:	0007879b          	sext.w	a5,a5
    15e4:	f8f42623          	sw	a5,-116(s0)
    15e8:	f8842703          	lw	a4,-120(s0)
    15ec:	fa644783          	lbu	a5,-90(s0)
    15f0:	0007879b          	sext.w	a5,a5
    15f4:	0017979b          	slliw	a5,a5,0x1
    15f8:	0007879b          	sext.w	a5,a5
    15fc:	40f707bb          	subw	a5,a4,a5
    1600:	0007871b          	sext.w	a4,a5
    1604:	fdc42783          	lw	a5,-36(s0)
    1608:	f8f42a23          	sw	a5,-108(s0)
    160c:	f8c42783          	lw	a5,-116(s0)
    1610:	f8f42823          	sw	a5,-112(s0)
    1614:	f9442783          	lw	a5,-108(s0)
    1618:	00078593          	mv	a1,a5
    161c:	f9042783          	lw	a5,-112(s0)
    1620:	00078613          	mv	a2,a5
    1624:	0006069b          	sext.w	a3,a2
    1628:	0005879b          	sext.w	a5,a1
    162c:	00f6d463          	bge	a3,a5,1634 <vprintfmt+0x428>
    1630:	00058613          	mv	a2,a1
    1634:	0006079b          	sext.w	a5,a2
    1638:	40f707bb          	subw	a5,a4,a5
    163c:	fcf42c23          	sw	a5,-40(s0)
    1640:	0280006f          	j	1668 <vprintfmt+0x45c>
    1644:	f5843783          	ld	a5,-168(s0)
    1648:	02000513          	li	a0,32
    164c:	000780e7          	jalr	a5
    1650:	fec42783          	lw	a5,-20(s0)
    1654:	0017879b          	addiw	a5,a5,1
    1658:	fef42623          	sw	a5,-20(s0)
    165c:	fd842783          	lw	a5,-40(s0)
    1660:	fff7879b          	addiw	a5,a5,-1
    1664:	fcf42c23          	sw	a5,-40(s0)
    1668:	fd842783          	lw	a5,-40(s0)
    166c:	0007879b          	sext.w	a5,a5
    1670:	fcf04ae3          	bgtz	a5,1644 <vprintfmt+0x438>
    1674:	fa644783          	lbu	a5,-90(s0)
    1678:	0ff7f793          	zext.b	a5,a5
    167c:	04078463          	beqz	a5,16c4 <vprintfmt+0x4b8>
    1680:	f5843783          	ld	a5,-168(s0)
    1684:	03000513          	li	a0,48
    1688:	000780e7          	jalr	a5
    168c:	f5043783          	ld	a5,-176(s0)
    1690:	0007c783          	lbu	a5,0(a5)
    1694:	00078713          	mv	a4,a5
    1698:	05800793          	li	a5,88
    169c:	00f71663          	bne	a4,a5,16a8 <vprintfmt+0x49c>
    16a0:	05800793          	li	a5,88
    16a4:	0080006f          	j	16ac <vprintfmt+0x4a0>
    16a8:	07800793          	li	a5,120
    16ac:	f5843703          	ld	a4,-168(s0)
    16b0:	00078513          	mv	a0,a5
    16b4:	000700e7          	jalr	a4
    16b8:	fec42783          	lw	a5,-20(s0)
    16bc:	0027879b          	addiw	a5,a5,2
    16c0:	fef42623          	sw	a5,-20(s0)
    16c4:	fdc42783          	lw	a5,-36(s0)
    16c8:	fcf42a23          	sw	a5,-44(s0)
    16cc:	0280006f          	j	16f4 <vprintfmt+0x4e8>
    16d0:	f5843783          	ld	a5,-168(s0)
    16d4:	03000513          	li	a0,48
    16d8:	000780e7          	jalr	a5
    16dc:	fec42783          	lw	a5,-20(s0)
    16e0:	0017879b          	addiw	a5,a5,1
    16e4:	fef42623          	sw	a5,-20(s0)
    16e8:	fd442783          	lw	a5,-44(s0)
    16ec:	0017879b          	addiw	a5,a5,1
    16f0:	fcf42a23          	sw	a5,-44(s0)
    16f4:	f8c42703          	lw	a4,-116(s0)
    16f8:	fd442783          	lw	a5,-44(s0)
    16fc:	0007879b          	sext.w	a5,a5
    1700:	fce7c8e3          	blt	a5,a4,16d0 <vprintfmt+0x4c4>
    1704:	fdc42783          	lw	a5,-36(s0)
    1708:	fff7879b          	addiw	a5,a5,-1
    170c:	fcf42823          	sw	a5,-48(s0)
    1710:	03c0006f          	j	174c <vprintfmt+0x540>
    1714:	fd042783          	lw	a5,-48(s0)
    1718:	ff078793          	addi	a5,a5,-16
    171c:	008787b3          	add	a5,a5,s0
    1720:	f807c783          	lbu	a5,-128(a5)
    1724:	0007871b          	sext.w	a4,a5
    1728:	f5843783          	ld	a5,-168(s0)
    172c:	00070513          	mv	a0,a4
    1730:	000780e7          	jalr	a5
    1734:	fec42783          	lw	a5,-20(s0)
    1738:	0017879b          	addiw	a5,a5,1
    173c:	fef42623          	sw	a5,-20(s0)
    1740:	fd042783          	lw	a5,-48(s0)
    1744:	fff7879b          	addiw	a5,a5,-1
    1748:	fcf42823          	sw	a5,-48(s0)
    174c:	fd042783          	lw	a5,-48(s0)
    1750:	0007879b          	sext.w	a5,a5
    1754:	fc07d0e3          	bgez	a5,1714 <vprintfmt+0x508>
    1758:	f8040023          	sb	zero,-128(s0)
    175c:	2700006f          	j	19cc <vprintfmt+0x7c0>
    1760:	f5043783          	ld	a5,-176(s0)
    1764:	0007c783          	lbu	a5,0(a5)
    1768:	00078713          	mv	a4,a5
    176c:	06400793          	li	a5,100
    1770:	02f70663          	beq	a4,a5,179c <vprintfmt+0x590>
    1774:	f5043783          	ld	a5,-176(s0)
    1778:	0007c783          	lbu	a5,0(a5)
    177c:	00078713          	mv	a4,a5
    1780:	06900793          	li	a5,105
    1784:	00f70c63          	beq	a4,a5,179c <vprintfmt+0x590>
    1788:	f5043783          	ld	a5,-176(s0)
    178c:	0007c783          	lbu	a5,0(a5)
    1790:	00078713          	mv	a4,a5
    1794:	07500793          	li	a5,117
    1798:	08f71063          	bne	a4,a5,1818 <vprintfmt+0x60c>
    179c:	f8144783          	lbu	a5,-127(s0)
    17a0:	00078c63          	beqz	a5,17b8 <vprintfmt+0x5ac>
    17a4:	f4843783          	ld	a5,-184(s0)
    17a8:	00878713          	addi	a4,a5,8
    17ac:	f4e43423          	sd	a4,-184(s0)
    17b0:	0007b783          	ld	a5,0(a5)
    17b4:	0140006f          	j	17c8 <vprintfmt+0x5bc>
    17b8:	f4843783          	ld	a5,-184(s0)
    17bc:	00878713          	addi	a4,a5,8
    17c0:	f4e43423          	sd	a4,-184(s0)
    17c4:	0007a783          	lw	a5,0(a5)
    17c8:	faf43423          	sd	a5,-88(s0)
    17cc:	fa843583          	ld	a1,-88(s0)
    17d0:	f5043783          	ld	a5,-176(s0)
    17d4:	0007c783          	lbu	a5,0(a5)
    17d8:	0007871b          	sext.w	a4,a5
    17dc:	07500793          	li	a5,117
    17e0:	40f707b3          	sub	a5,a4,a5
    17e4:	00f037b3          	snez	a5,a5
    17e8:	0ff7f793          	zext.b	a5,a5
    17ec:	f8040713          	addi	a4,s0,-128
    17f0:	00070693          	mv	a3,a4
    17f4:	00078613          	mv	a2,a5
    17f8:	f5843503          	ld	a0,-168(s0)
    17fc:	f08ff0ef          	jal	ra,f04 <print_dec_int>
    1800:	00050793          	mv	a5,a0
    1804:	fec42703          	lw	a4,-20(s0)
    1808:	00f707bb          	addw	a5,a4,a5
    180c:	fef42623          	sw	a5,-20(s0)
    1810:	f8040023          	sb	zero,-128(s0)
    1814:	1b80006f          	j	19cc <vprintfmt+0x7c0>
    1818:	f5043783          	ld	a5,-176(s0)
    181c:	0007c783          	lbu	a5,0(a5)
    1820:	00078713          	mv	a4,a5
    1824:	06e00793          	li	a5,110
    1828:	04f71c63          	bne	a4,a5,1880 <vprintfmt+0x674>
    182c:	f8144783          	lbu	a5,-127(s0)
    1830:	02078463          	beqz	a5,1858 <vprintfmt+0x64c>
    1834:	f4843783          	ld	a5,-184(s0)
    1838:	00878713          	addi	a4,a5,8
    183c:	f4e43423          	sd	a4,-184(s0)
    1840:	0007b783          	ld	a5,0(a5)
    1844:	faf43823          	sd	a5,-80(s0)
    1848:	fec42703          	lw	a4,-20(s0)
    184c:	fb043783          	ld	a5,-80(s0)
    1850:	00e7b023          	sd	a4,0(a5)
    1854:	0240006f          	j	1878 <vprintfmt+0x66c>
    1858:	f4843783          	ld	a5,-184(s0)
    185c:	00878713          	addi	a4,a5,8
    1860:	f4e43423          	sd	a4,-184(s0)
    1864:	0007b783          	ld	a5,0(a5)
    1868:	faf43c23          	sd	a5,-72(s0)
    186c:	fb843783          	ld	a5,-72(s0)
    1870:	fec42703          	lw	a4,-20(s0)
    1874:	00e7a023          	sw	a4,0(a5)
    1878:	f8040023          	sb	zero,-128(s0)
    187c:	1500006f          	j	19cc <vprintfmt+0x7c0>
    1880:	f5043783          	ld	a5,-176(s0)
    1884:	0007c783          	lbu	a5,0(a5)
    1888:	00078713          	mv	a4,a5
    188c:	07300793          	li	a5,115
    1890:	02f71e63          	bne	a4,a5,18cc <vprintfmt+0x6c0>
    1894:	f4843783          	ld	a5,-184(s0)
    1898:	00878713          	addi	a4,a5,8
    189c:	f4e43423          	sd	a4,-184(s0)
    18a0:	0007b783          	ld	a5,0(a5)
    18a4:	fcf43023          	sd	a5,-64(s0)
    18a8:	fc043583          	ld	a1,-64(s0)
    18ac:	f5843503          	ld	a0,-168(s0)
    18b0:	dccff0ef          	jal	ra,e7c <puts_wo_nl>
    18b4:	00050793          	mv	a5,a0
    18b8:	fec42703          	lw	a4,-20(s0)
    18bc:	00f707bb          	addw	a5,a4,a5
    18c0:	fef42623          	sw	a5,-20(s0)
    18c4:	f8040023          	sb	zero,-128(s0)
    18c8:	1040006f          	j	19cc <vprintfmt+0x7c0>
    18cc:	f5043783          	ld	a5,-176(s0)
    18d0:	0007c783          	lbu	a5,0(a5)
    18d4:	00078713          	mv	a4,a5
    18d8:	06300793          	li	a5,99
    18dc:	02f71e63          	bne	a4,a5,1918 <vprintfmt+0x70c>
    18e0:	f4843783          	ld	a5,-184(s0)
    18e4:	00878713          	addi	a4,a5,8
    18e8:	f4e43423          	sd	a4,-184(s0)
    18ec:	0007a783          	lw	a5,0(a5)
    18f0:	fcf42623          	sw	a5,-52(s0)
    18f4:	fcc42703          	lw	a4,-52(s0)
    18f8:	f5843783          	ld	a5,-168(s0)
    18fc:	00070513          	mv	a0,a4
    1900:	000780e7          	jalr	a5
    1904:	fec42783          	lw	a5,-20(s0)
    1908:	0017879b          	addiw	a5,a5,1
    190c:	fef42623          	sw	a5,-20(s0)
    1910:	f8040023          	sb	zero,-128(s0)
    1914:	0b80006f          	j	19cc <vprintfmt+0x7c0>
    1918:	f5043783          	ld	a5,-176(s0)
    191c:	0007c783          	lbu	a5,0(a5)
    1920:	00078713          	mv	a4,a5
    1924:	02500793          	li	a5,37
    1928:	02f71263          	bne	a4,a5,194c <vprintfmt+0x740>
    192c:	f5843783          	ld	a5,-168(s0)
    1930:	02500513          	li	a0,37
    1934:	000780e7          	jalr	a5
    1938:	fec42783          	lw	a5,-20(s0)
    193c:	0017879b          	addiw	a5,a5,1
    1940:	fef42623          	sw	a5,-20(s0)
    1944:	f8040023          	sb	zero,-128(s0)
    1948:	0840006f          	j	19cc <vprintfmt+0x7c0>
    194c:	f5043783          	ld	a5,-176(s0)
    1950:	0007c783          	lbu	a5,0(a5)
    1954:	0007871b          	sext.w	a4,a5
    1958:	f5843783          	ld	a5,-168(s0)
    195c:	00070513          	mv	a0,a4
    1960:	000780e7          	jalr	a5
    1964:	fec42783          	lw	a5,-20(s0)
    1968:	0017879b          	addiw	a5,a5,1
    196c:	fef42623          	sw	a5,-20(s0)
    1970:	f8040023          	sb	zero,-128(s0)
    1974:	0580006f          	j	19cc <vprintfmt+0x7c0>
    1978:	f5043783          	ld	a5,-176(s0)
    197c:	0007c783          	lbu	a5,0(a5)
    1980:	00078713          	mv	a4,a5
    1984:	02500793          	li	a5,37
    1988:	02f71063          	bne	a4,a5,19a8 <vprintfmt+0x79c>
    198c:	f8043023          	sd	zero,-128(s0)
    1990:	f8043423          	sd	zero,-120(s0)
    1994:	00100793          	li	a5,1
    1998:	f8f40023          	sb	a5,-128(s0)
    199c:	fff00793          	li	a5,-1
    19a0:	f8f42623          	sw	a5,-116(s0)
    19a4:	0280006f          	j	19cc <vprintfmt+0x7c0>
    19a8:	f5043783          	ld	a5,-176(s0)
    19ac:	0007c783          	lbu	a5,0(a5)
    19b0:	0007871b          	sext.w	a4,a5
    19b4:	f5843783          	ld	a5,-168(s0)
    19b8:	00070513          	mv	a0,a4
    19bc:	000780e7          	jalr	a5
    19c0:	fec42783          	lw	a5,-20(s0)
    19c4:	0017879b          	addiw	a5,a5,1
    19c8:	fef42623          	sw	a5,-20(s0)
    19cc:	f5043783          	ld	a5,-176(s0)
    19d0:	00178793          	addi	a5,a5,1
    19d4:	f4f43823          	sd	a5,-176(s0)
    19d8:	f5043783          	ld	a5,-176(s0)
    19dc:	0007c783          	lbu	a5,0(a5)
    19e0:	84079ce3          	bnez	a5,1238 <vprintfmt+0x2c>
    19e4:	fec42783          	lw	a5,-20(s0)
    19e8:	00078513          	mv	a0,a5
    19ec:	0b813083          	ld	ra,184(sp)
    19f0:	0b013403          	ld	s0,176(sp)
    19f4:	0c010113          	addi	sp,sp,192
    19f8:	00008067          	ret

Disassembly of section .text.printf:

00000000000019fc <printf>:
    19fc:	f8010113          	addi	sp,sp,-128
    1a00:	02113c23          	sd	ra,56(sp)
    1a04:	02813823          	sd	s0,48(sp)
    1a08:	04010413          	addi	s0,sp,64
    1a0c:	fca43423          	sd	a0,-56(s0)
    1a10:	00b43423          	sd	a1,8(s0)
    1a14:	00c43823          	sd	a2,16(s0)
    1a18:	00d43c23          	sd	a3,24(s0)
    1a1c:	02e43023          	sd	a4,32(s0)
    1a20:	02f43423          	sd	a5,40(s0)
    1a24:	03043823          	sd	a6,48(s0)
    1a28:	03143c23          	sd	a7,56(s0)
    1a2c:	fe042623          	sw	zero,-20(s0)
    1a30:	04040793          	addi	a5,s0,64
    1a34:	fcf43023          	sd	a5,-64(s0)
    1a38:	fc043783          	ld	a5,-64(s0)
    1a3c:	fc878793          	addi	a5,a5,-56
    1a40:	fcf43823          	sd	a5,-48(s0)
    1a44:	fd043783          	ld	a5,-48(s0)
    1a48:	00078613          	mv	a2,a5
    1a4c:	fc843583          	ld	a1,-56(s0)
    1a50:	fffff517          	auipc	a0,0xfffff
    1a54:	0f850513          	addi	a0,a0,248 # b48 <putc>
    1a58:	fb4ff0ef          	jal	ra,120c <vprintfmt>
    1a5c:	00050793          	mv	a5,a0
    1a60:	fef42623          	sw	a5,-20(s0)
    1a64:	00100793          	li	a5,1
    1a68:	fef43023          	sd	a5,-32(s0)
    1a6c:	00001797          	auipc	a5,0x1
    1a70:	4f478793          	addi	a5,a5,1268 # 2f60 <tail>
    1a74:	0007a783          	lw	a5,0(a5)
    1a78:	0017871b          	addiw	a4,a5,1
    1a7c:	0007069b          	sext.w	a3,a4
    1a80:	00001717          	auipc	a4,0x1
    1a84:	4e070713          	addi	a4,a4,1248 # 2f60 <tail>
    1a88:	00d72023          	sw	a3,0(a4)
    1a8c:	00001717          	auipc	a4,0x1
    1a90:	4dc70713          	addi	a4,a4,1244 # 2f68 <buffer>
    1a94:	00f707b3          	add	a5,a4,a5
    1a98:	00078023          	sb	zero,0(a5)
    1a9c:	00001797          	auipc	a5,0x1
    1aa0:	4c478793          	addi	a5,a5,1220 # 2f60 <tail>
    1aa4:	0007a603          	lw	a2,0(a5)
    1aa8:	fe043703          	ld	a4,-32(s0)
    1aac:	00001697          	auipc	a3,0x1
    1ab0:	4bc68693          	addi	a3,a3,1212 # 2f68 <buffer>
    1ab4:	fd843783          	ld	a5,-40(s0)
    1ab8:	04000893          	li	a7,64
    1abc:	00070513          	mv	a0,a4
    1ac0:	00068593          	mv	a1,a3
    1ac4:	00060613          	mv	a2,a2
    1ac8:	00000073          	ecall
    1acc:	00050793          	mv	a5,a0
    1ad0:	fcf43c23          	sd	a5,-40(s0)
    1ad4:	00001797          	auipc	a5,0x1
    1ad8:	48c78793          	addi	a5,a5,1164 # 2f60 <tail>
    1adc:	0007a023          	sw	zero,0(a5)
    1ae0:	fec42783          	lw	a5,-20(s0)
    1ae4:	00078513          	mv	a0,a5
    1ae8:	03813083          	ld	ra,56(sp)
    1aec:	03013403          	ld	s0,48(sp)
    1af0:	08010113          	addi	sp,sp,128
    1af4:	00008067          	ret

Disassembly of section .text.strlen:

0000000000001af8 <strlen>:
    1af8:	fd010113          	addi	sp,sp,-48
    1afc:	02813423          	sd	s0,40(sp)
    1b00:	03010413          	addi	s0,sp,48
    1b04:	fca43c23          	sd	a0,-40(s0)
    1b08:	fe042623          	sw	zero,-20(s0)
    1b0c:	0100006f          	j	1b1c <strlen+0x24>
    1b10:	fec42783          	lw	a5,-20(s0)
    1b14:	0017879b          	addiw	a5,a5,1
    1b18:	fef42623          	sw	a5,-20(s0)
    1b1c:	fd843783          	ld	a5,-40(s0)
    1b20:	00178713          	addi	a4,a5,1
    1b24:	fce43c23          	sd	a4,-40(s0)
    1b28:	0007c783          	lbu	a5,0(a5)
    1b2c:	fe0792e3          	bnez	a5,1b10 <strlen+0x18>
    1b30:	fec42783          	lw	a5,-20(s0)
    1b34:	00078513          	mv	a0,a5
    1b38:	02813403          	ld	s0,40(sp)
    1b3c:	03010113          	addi	sp,sp,48
    1b40:	00008067          	ret

Disassembly of section .text.write:

0000000000001b44 <write>:
    1b44:	fb010113          	addi	sp,sp,-80
    1b48:	04813423          	sd	s0,72(sp)
    1b4c:	05010413          	addi	s0,sp,80
    1b50:	00050693          	mv	a3,a0
    1b54:	fcb43023          	sd	a1,-64(s0)
    1b58:	fac43c23          	sd	a2,-72(s0)
    1b5c:	fcd42623          	sw	a3,-52(s0)
    1b60:	00010693          	mv	a3,sp
    1b64:	00068593          	mv	a1,a3
    1b68:	fb843683          	ld	a3,-72(s0)
    1b6c:	00168693          	addi	a3,a3,1
    1b70:	00068613          	mv	a2,a3
    1b74:	fff60613          	addi	a2,a2,-1
    1b78:	fec43023          	sd	a2,-32(s0)
    1b7c:	00068e13          	mv	t3,a3
    1b80:	00000e93          	li	t4,0
    1b84:	03de5613          	srli	a2,t3,0x3d
    1b88:	003e9893          	slli	a7,t4,0x3
    1b8c:	011668b3          	or	a7,a2,a7
    1b90:	003e1813          	slli	a6,t3,0x3
    1b94:	00068313          	mv	t1,a3
    1b98:	00000393          	li	t2,0
    1b9c:	03d35613          	srli	a2,t1,0x3d
    1ba0:	00339793          	slli	a5,t2,0x3
    1ba4:	00f667b3          	or	a5,a2,a5
    1ba8:	00331713          	slli	a4,t1,0x3
    1bac:	00f68793          	addi	a5,a3,15
    1bb0:	0047d793          	srli	a5,a5,0x4
    1bb4:	00479793          	slli	a5,a5,0x4
    1bb8:	40f10133          	sub	sp,sp,a5
    1bbc:	00010793          	mv	a5,sp
    1bc0:	00078793          	mv	a5,a5
    1bc4:	fcf43c23          	sd	a5,-40(s0)
    1bc8:	fe042623          	sw	zero,-20(s0)
    1bcc:	0300006f          	j	1bfc <write+0xb8>
    1bd0:	fec42783          	lw	a5,-20(s0)
    1bd4:	fc043703          	ld	a4,-64(s0)
    1bd8:	00f707b3          	add	a5,a4,a5
    1bdc:	0007c703          	lbu	a4,0(a5)
    1be0:	fd843683          	ld	a3,-40(s0)
    1be4:	fec42783          	lw	a5,-20(s0)
    1be8:	00f687b3          	add	a5,a3,a5
    1bec:	00e78023          	sb	a4,0(a5)
    1bf0:	fec42783          	lw	a5,-20(s0)
    1bf4:	0017879b          	addiw	a5,a5,1
    1bf8:	fef42623          	sw	a5,-20(s0)
    1bfc:	fec42783          	lw	a5,-20(s0)
    1c00:	fb843703          	ld	a4,-72(s0)
    1c04:	fce7e6e3          	bltu	a5,a4,1bd0 <write+0x8c>
    1c08:	fd843703          	ld	a4,-40(s0)
    1c0c:	fb843783          	ld	a5,-72(s0)
    1c10:	00f707b3          	add	a5,a4,a5
    1c14:	00078023          	sb	zero,0(a5)
    1c18:	fcc42703          	lw	a4,-52(s0)
    1c1c:	fd843683          	ld	a3,-40(s0)
    1c20:	fb843603          	ld	a2,-72(s0)
    1c24:	fd043783          	ld	a5,-48(s0)
    1c28:	04000893          	li	a7,64
    1c2c:	00070513          	mv	a0,a4
    1c30:	00068593          	mv	a1,a3
    1c34:	00060613          	mv	a2,a2
    1c38:	00000073          	ecall
    1c3c:	00050793          	mv	a5,a0
    1c40:	fcf43823          	sd	a5,-48(s0)
    1c44:	fd043783          	ld	a5,-48(s0)
    1c48:	0007879b          	sext.w	a5,a5
    1c4c:	00058113          	mv	sp,a1
    1c50:	00078513          	mv	a0,a5
    1c54:	fb040113          	addi	sp,s0,-80
    1c58:	04813403          	ld	s0,72(sp)
    1c5c:	05010113          	addi	sp,sp,80
    1c60:	00008067          	ret

Disassembly of section .text.read:

0000000000001c64 <read>:
    1c64:	fc010113          	addi	sp,sp,-64
    1c68:	02813c23          	sd	s0,56(sp)
    1c6c:	04010413          	addi	s0,sp,64
    1c70:	00050793          	mv	a5,a0
    1c74:	fcb43823          	sd	a1,-48(s0)
    1c78:	fcc43423          	sd	a2,-56(s0)
    1c7c:	fcf42e23          	sw	a5,-36(s0)
    1c80:	fdc42703          	lw	a4,-36(s0)
    1c84:	fd043683          	ld	a3,-48(s0)
    1c88:	fc843603          	ld	a2,-56(s0)
    1c8c:	fe843783          	ld	a5,-24(s0)
    1c90:	03f00893          	li	a7,63
    1c94:	00070513          	mv	a0,a4
    1c98:	00068593          	mv	a1,a3
    1c9c:	00060613          	mv	a2,a2
    1ca0:	00000073          	ecall
    1ca4:	00050793          	mv	a5,a0
    1ca8:	fef43423          	sd	a5,-24(s0)
    1cac:	fe843783          	ld	a5,-24(s0)
    1cb0:	0007879b          	sext.w	a5,a5
    1cb4:	00078513          	mv	a0,a5
    1cb8:	03813403          	ld	s0,56(sp)
    1cbc:	04010113          	addi	sp,sp,64
    1cc0:	00008067          	ret

Disassembly of section .text.sys_openat:

0000000000001cc4 <sys_openat>:
    1cc4:	fd010113          	addi	sp,sp,-48
    1cc8:	02813423          	sd	s0,40(sp)
    1ccc:	03010413          	addi	s0,sp,48
    1cd0:	00050793          	mv	a5,a0
    1cd4:	fcb43823          	sd	a1,-48(s0)
    1cd8:	00060713          	mv	a4,a2
    1cdc:	fcf42e23          	sw	a5,-36(s0)
    1ce0:	00070793          	mv	a5,a4
    1ce4:	fcf42c23          	sw	a5,-40(s0)
    1ce8:	fdc42703          	lw	a4,-36(s0)
    1cec:	fd842603          	lw	a2,-40(s0)
    1cf0:	fd043683          	ld	a3,-48(s0)
    1cf4:	fe843783          	ld	a5,-24(s0)
    1cf8:	03800893          	li	a7,56
    1cfc:	00070513          	mv	a0,a4
    1d00:	00068593          	mv	a1,a3
    1d04:	00060613          	mv	a2,a2
    1d08:	00000073          	ecall
    1d0c:	00050793          	mv	a5,a0
    1d10:	fef43423          	sd	a5,-24(s0)
    1d14:	fe843783          	ld	a5,-24(s0)
    1d18:	0007879b          	sext.w	a5,a5
    1d1c:	00078513          	mv	a0,a5
    1d20:	02813403          	ld	s0,40(sp)
    1d24:	03010113          	addi	sp,sp,48
    1d28:	00008067          	ret

Disassembly of section .text.open:

0000000000001d2c <open>:
    1d2c:	fe010113          	addi	sp,sp,-32
    1d30:	00113c23          	sd	ra,24(sp)
    1d34:	00813823          	sd	s0,16(sp)
    1d38:	02010413          	addi	s0,sp,32
    1d3c:	fea43423          	sd	a0,-24(s0)
    1d40:	00058793          	mv	a5,a1
    1d44:	fef42223          	sw	a5,-28(s0)
    1d48:	fe442783          	lw	a5,-28(s0)
    1d4c:	00078613          	mv	a2,a5
    1d50:	fe843583          	ld	a1,-24(s0)
    1d54:	f9c00513          	li	a0,-100
    1d58:	f6dff0ef          	jal	ra,1cc4 <sys_openat>
    1d5c:	00050793          	mv	a5,a0
    1d60:	00078513          	mv	a0,a5
    1d64:	01813083          	ld	ra,24(sp)
    1d68:	01013403          	ld	s0,16(sp)
    1d6c:	02010113          	addi	sp,sp,32
    1d70:	00008067          	ret

Disassembly of section .text.close:

0000000000001d74 <close>:
    1d74:	fd010113          	addi	sp,sp,-48
    1d78:	02813423          	sd	s0,40(sp)
    1d7c:	03010413          	addi	s0,sp,48
    1d80:	00050793          	mv	a5,a0
    1d84:	fcf42e23          	sw	a5,-36(s0)
    1d88:	fdc42703          	lw	a4,-36(s0)
    1d8c:	fe843783          	ld	a5,-24(s0)
    1d90:	03900893          	li	a7,57
    1d94:	00070513          	mv	a0,a4
    1d98:	00000073          	ecall
    1d9c:	00050793          	mv	a5,a0
    1da0:	fef43423          	sd	a5,-24(s0)
    1da4:	fe843783          	ld	a5,-24(s0)
    1da8:	0007879b          	sext.w	a5,a5
    1dac:	00078513          	mv	a0,a5
    1db0:	02813403          	ld	s0,40(sp)
    1db4:	03010113          	addi	sp,sp,48
    1db8:	00008067          	ret

Disassembly of section .text.lseek:

0000000000001dbc <lseek>:
    1dbc:	fd010113          	addi	sp,sp,-48
    1dc0:	02813423          	sd	s0,40(sp)
    1dc4:	03010413          	addi	s0,sp,48
    1dc8:	00050793          	mv	a5,a0
    1dcc:	00058693          	mv	a3,a1
    1dd0:	00060713          	mv	a4,a2
    1dd4:	fcf42e23          	sw	a5,-36(s0)
    1dd8:	00068793          	mv	a5,a3
    1ddc:	fcf42c23          	sw	a5,-40(s0)
    1de0:	00070793          	mv	a5,a4
    1de4:	fcf42a23          	sw	a5,-44(s0)
    1de8:	fdc42703          	lw	a4,-36(s0)
    1dec:	fd842683          	lw	a3,-40(s0)
    1df0:	fd442603          	lw	a2,-44(s0)
    1df4:	fe843783          	ld	a5,-24(s0)
    1df8:	03e00893          	li	a7,62
    1dfc:	00070513          	mv	a0,a4
    1e00:	00068593          	mv	a1,a3
    1e04:	00060613          	mv	a2,a2
    1e08:	00000073          	ecall
    1e0c:	00050793          	mv	a5,a0
    1e10:	fef43423          	sd	a5,-24(s0)
    1e14:	fe843783          	ld	a5,-24(s0)
    1e18:	0007879b          	sext.w	a5,a5
    1e1c:	00078513          	mv	a0,a5
    1e20:	02813403          	ld	s0,40(sp)
    1e24:	03010113          	addi	sp,sp,48
    1e28:	00008067          	ret
