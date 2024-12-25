
uapp:     file format elf64-littleriscv


Disassembly of section .text:

00000000000100e8 <_start>:
   100e8:	2010006f          	j	10ae8 <main>

00000000000100ec <atoi>:
   100ec:	fd010113          	addi	sp,sp,-48
   100f0:	02113423          	sd	ra,40(sp)
   100f4:	02813023          	sd	s0,32(sp)
   100f8:	03010413          	addi	s0,sp,48
   100fc:	fca43c23          	sd	a0,-40(s0)
   10100:	fe042623          	sw	zero,-20(s0)
   10104:	fd843503          	ld	a0,-40(s0)
   10108:	2d9010ef          	jal	ra,11be0 <strlen>
   1010c:	00050793          	mv	a5,a0
   10110:	fef42223          	sw	a5,-28(s0)
   10114:	fe042423          	sw	zero,-24(s0)
   10118:	0500006f          	j	10168 <atoi+0x7c>
   1011c:	fec42783          	lw	a5,-20(s0)
   10120:	00078713          	mv	a4,a5
   10124:	00070793          	mv	a5,a4
   10128:	0027979b          	slliw	a5,a5,0x2
   1012c:	00e787bb          	addw	a5,a5,a4
   10130:	0017979b          	slliw	a5,a5,0x1
   10134:	0007871b          	sext.w	a4,a5
   10138:	fe842783          	lw	a5,-24(s0)
   1013c:	fd843683          	ld	a3,-40(s0)
   10140:	00f687b3          	add	a5,a3,a5
   10144:	0007c783          	lbu	a5,0(a5)
   10148:	0007879b          	sext.w	a5,a5
   1014c:	00f707bb          	addw	a5,a4,a5
   10150:	0007879b          	sext.w	a5,a5
   10154:	fd07879b          	addiw	a5,a5,-48
   10158:	fef42623          	sw	a5,-20(s0)
   1015c:	fe842783          	lw	a5,-24(s0)
   10160:	0017879b          	addiw	a5,a5,1
   10164:	fef42423          	sw	a5,-24(s0)
   10168:	fe842783          	lw	a5,-24(s0)
   1016c:	00078713          	mv	a4,a5
   10170:	fe442783          	lw	a5,-28(s0)
   10174:	0007071b          	sext.w	a4,a4
   10178:	0007879b          	sext.w	a5,a5
   1017c:	faf740e3          	blt	a4,a5,1011c <atoi+0x30>
   10180:	fec42783          	lw	a5,-20(s0)
   10184:	00078513          	mv	a0,a5
   10188:	02813083          	ld	ra,40(sp)
   1018c:	02013403          	ld	s0,32(sp)
   10190:	03010113          	addi	sp,sp,48
   10194:	00008067          	ret

0000000000010198 <get_param>:
   10198:	fd010113          	addi	sp,sp,-48
   1019c:	02813423          	sd	s0,40(sp)
   101a0:	03010413          	addi	s0,sp,48
   101a4:	fca43c23          	sd	a0,-40(s0)
   101a8:	0100006f          	j	101b8 <get_param+0x20>
   101ac:	fd843783          	ld	a5,-40(s0)
   101b0:	00178793          	addi	a5,a5,1
   101b4:	fcf43c23          	sd	a5,-40(s0)
   101b8:	fd843783          	ld	a5,-40(s0)
   101bc:	0007c783          	lbu	a5,0(a5)
   101c0:	00078713          	mv	a4,a5
   101c4:	02000793          	li	a5,32
   101c8:	fef702e3          	beq	a4,a5,101ac <get_param+0x14>
   101cc:	fe042623          	sw	zero,-20(s0)
   101d0:	0300006f          	j	10200 <get_param+0x68>
   101d4:	fd843703          	ld	a4,-40(s0)
   101d8:	00170793          	addi	a5,a4,1
   101dc:	fcf43c23          	sd	a5,-40(s0)
   101e0:	fec42783          	lw	a5,-20(s0)
   101e4:	0017869b          	addiw	a3,a5,1
   101e8:	fed42623          	sw	a3,-20(s0)
   101ec:	00074703          	lbu	a4,0(a4)
   101f0:	00003697          	auipc	a3,0x3
   101f4:	e5868693          	addi	a3,a3,-424 # 13048 <string_buf>
   101f8:	00f687b3          	add	a5,a3,a5
   101fc:	00e78023          	sb	a4,0(a5)
   10200:	fd843783          	ld	a5,-40(s0)
   10204:	0007c783          	lbu	a5,0(a5)
   10208:	00078c63          	beqz	a5,10220 <get_param+0x88>
   1020c:	fd843783          	ld	a5,-40(s0)
   10210:	0007c783          	lbu	a5,0(a5)
   10214:	00078713          	mv	a4,a5
   10218:	02000793          	li	a5,32
   1021c:	faf71ce3          	bne	a4,a5,101d4 <get_param+0x3c>
   10220:	00003717          	auipc	a4,0x3
   10224:	e2870713          	addi	a4,a4,-472 # 13048 <string_buf>
   10228:	fec42783          	lw	a5,-20(s0)
   1022c:	00f707b3          	add	a5,a4,a5
   10230:	00078023          	sb	zero,0(a5)
   10234:	00003797          	auipc	a5,0x3
   10238:	e1478793          	addi	a5,a5,-492 # 13048 <string_buf>
   1023c:	00078513          	mv	a0,a5
   10240:	02813403          	ld	s0,40(sp)
   10244:	03010113          	addi	sp,sp,48
   10248:	00008067          	ret

000000000001024c <get_string>:
   1024c:	fd010113          	addi	sp,sp,-48
   10250:	02113423          	sd	ra,40(sp)
   10254:	02813023          	sd	s0,32(sp)
   10258:	03010413          	addi	s0,sp,48
   1025c:	fca43c23          	sd	a0,-40(s0)
   10260:	0100006f          	j	10270 <get_string+0x24>
   10264:	fd843783          	ld	a5,-40(s0)
   10268:	00178793          	addi	a5,a5,1
   1026c:	fcf43c23          	sd	a5,-40(s0)
   10270:	fd843783          	ld	a5,-40(s0)
   10274:	0007c783          	lbu	a5,0(a5)
   10278:	00078713          	mv	a4,a5
   1027c:	02000793          	li	a5,32
   10280:	fef702e3          	beq	a4,a5,10264 <get_string+0x18>
   10284:	fd843783          	ld	a5,-40(s0)
   10288:	0007c783          	lbu	a5,0(a5)
   1028c:	00078713          	mv	a4,a5
   10290:	02200793          	li	a5,34
   10294:	06f71c63          	bne	a4,a5,1030c <get_string+0xc0>
   10298:	fd843783          	ld	a5,-40(s0)
   1029c:	00178793          	addi	a5,a5,1
   102a0:	fcf43c23          	sd	a5,-40(s0)
   102a4:	fe042623          	sw	zero,-20(s0)
   102a8:	0300006f          	j	102d8 <get_string+0x8c>
   102ac:	fd843703          	ld	a4,-40(s0)
   102b0:	00170793          	addi	a5,a4,1
   102b4:	fcf43c23          	sd	a5,-40(s0)
   102b8:	fec42783          	lw	a5,-20(s0)
   102bc:	0017869b          	addiw	a3,a5,1
   102c0:	fed42623          	sw	a3,-20(s0)
   102c4:	00074703          	lbu	a4,0(a4)
   102c8:	00003697          	auipc	a3,0x3
   102cc:	d8068693          	addi	a3,a3,-640 # 13048 <string_buf>
   102d0:	00f687b3          	add	a5,a3,a5
   102d4:	00e78023          	sb	a4,0(a5)
   102d8:	fd843783          	ld	a5,-40(s0)
   102dc:	0007c783          	lbu	a5,0(a5)
   102e0:	00078713          	mv	a4,a5
   102e4:	02200793          	li	a5,34
   102e8:	fcf712e3          	bne	a4,a5,102ac <get_string+0x60>
   102ec:	00003717          	auipc	a4,0x3
   102f0:	d5c70713          	addi	a4,a4,-676 # 13048 <string_buf>
   102f4:	fec42783          	lw	a5,-20(s0)
   102f8:	00f707b3          	add	a5,a4,a5
   102fc:	00078023          	sb	zero,0(a5)
   10300:	00003797          	auipc	a5,0x3
   10304:	d4878793          	addi	a5,a5,-696 # 13048 <string_buf>
   10308:	0100006f          	j	10318 <get_string+0xcc>
   1030c:	fd843503          	ld	a0,-40(s0)
   10310:	e89ff0ef          	jal	ra,10198 <get_param>
   10314:	00050793          	mv	a5,a0
   10318:	00078513          	mv	a0,a5
   1031c:	02813083          	ld	ra,40(sp)
   10320:	02013403          	ld	s0,32(sp)
   10324:	03010113          	addi	sp,sp,48
   10328:	00008067          	ret

000000000001032c <parse_cmd>:
   1032c:	c9010113          	addi	sp,sp,-880
   10330:	36113423          	sd	ra,872(sp)
   10334:	36813023          	sd	s0,864(sp)
   10338:	34913c23          	sd	s1,856(sp)
   1033c:	35213823          	sd	s2,848(sp)
   10340:	35313423          	sd	s3,840(sp)
   10344:	35413023          	sd	s4,832(sp)
   10348:	33513c23          	sd	s5,824(sp)
   1034c:	33613823          	sd	s6,816(sp)
   10350:	33713423          	sd	s7,808(sp)
   10354:	33813023          	sd	s8,800(sp)
   10358:	31913c23          	sd	s9,792(sp)
   1035c:	31a13823          	sd	s10,784(sp)
   10360:	31b13423          	sd	s11,776(sp)
   10364:	37010413          	addi	s0,sp,880
   10368:	d0a43423          	sd	a0,-760(s0)
   1036c:	00058793          	mv	a5,a1
   10370:	d0f42223          	sw	a5,-764(s0)
   10374:	d0843783          	ld	a5,-760(s0)
   10378:	0007c783          	lbu	a5,0(a5)
   1037c:	00078713          	mv	a4,a5
   10380:	06500793          	li	a5,101
   10384:	0af71863          	bne	a4,a5,10434 <parse_cmd+0x108>
   10388:	d0843783          	ld	a5,-760(s0)
   1038c:	00178793          	addi	a5,a5,1
   10390:	0007c783          	lbu	a5,0(a5)
   10394:	00078713          	mv	a4,a5
   10398:	06300793          	li	a5,99
   1039c:	08f71c63          	bne	a4,a5,10434 <parse_cmd+0x108>
   103a0:	d0843783          	ld	a5,-760(s0)
   103a4:	00278793          	addi	a5,a5,2
   103a8:	0007c783          	lbu	a5,0(a5)
   103ac:	00078713          	mv	a4,a5
   103b0:	06800793          	li	a5,104
   103b4:	08f71063          	bne	a4,a5,10434 <parse_cmd+0x108>
   103b8:	d0843783          	ld	a5,-760(s0)
   103bc:	00378793          	addi	a5,a5,3
   103c0:	0007c783          	lbu	a5,0(a5)
   103c4:	00078713          	mv	a4,a5
   103c8:	06f00793          	li	a5,111
   103cc:	06f71463          	bne	a4,a5,10434 <parse_cmd+0x108>
   103d0:	d0843783          	ld	a5,-760(s0)
   103d4:	00478793          	addi	a5,a5,4
   103d8:	d0f43423          	sd	a5,-760(s0)
   103dc:	d0843503          	ld	a0,-760(s0)
   103e0:	e6dff0ef          	jal	ra,1024c <get_string>
   103e4:	f6a43823          	sd	a0,-144(s0)
   103e8:	f7043503          	ld	a0,-144(s0)
   103ec:	7f4010ef          	jal	ra,11be0 <strlen>
   103f0:	00050793          	mv	a5,a0
   103f4:	d0f42223          	sw	a5,-764(s0)
   103f8:	d0442783          	lw	a5,-764(s0)
   103fc:	d0843703          	ld	a4,-760(s0)
   10400:	00f707b3          	add	a5,a4,a5
   10404:	d0f43423          	sd	a5,-760(s0)
   10408:	d0442783          	lw	a5,-764(s0)
   1040c:	00078613          	mv	a2,a5
   10410:	f7043583          	ld	a1,-144(s0)
   10414:	00100513          	li	a0,1
   10418:	015010ef          	jal	ra,11c2c <write>
   1041c:	00100613          	li	a2,1
   10420:	00002597          	auipc	a1,0x2
   10424:	af858593          	addi	a1,a1,-1288 # 11f18 <lseek+0x74>
   10428:	00100513          	li	a0,1
   1042c:	001010ef          	jal	ra,11c2c <write>
   10430:	6780006f          	j	10aa8 <parse_cmd+0x77c>
   10434:	d0843783          	ld	a5,-760(s0)
   10438:	0007c783          	lbu	a5,0(a5)
   1043c:	00078713          	mv	a4,a5
   10440:	06300793          	li	a5,99
   10444:	1af71c63          	bne	a4,a5,105fc <parse_cmd+0x2d0>
   10448:	d0843783          	ld	a5,-760(s0)
   1044c:	00178793          	addi	a5,a5,1
   10450:	0007c783          	lbu	a5,0(a5)
   10454:	00078713          	mv	a4,a5
   10458:	06100793          	li	a5,97
   1045c:	1af71063          	bne	a4,a5,105fc <parse_cmd+0x2d0>
   10460:	d0843783          	ld	a5,-760(s0)
   10464:	00278793          	addi	a5,a5,2
   10468:	0007c783          	lbu	a5,0(a5)
   1046c:	00078713          	mv	a4,a5
   10470:	07400793          	li	a5,116
   10474:	18f71463          	bne	a4,a5,105fc <parse_cmd+0x2d0>
   10478:	d0843783          	ld	a5,-760(s0)
   1047c:	00378793          	addi	a5,a5,3
   10480:	00078513          	mv	a0,a5
   10484:	d15ff0ef          	jal	ra,10198 <get_param>
   10488:	f6a43423          	sd	a0,-152(s0)
   1048c:	f6843703          	ld	a4,-152(s0)
   10490:	00002697          	auipc	a3,0x2
   10494:	b5868693          	addi	a3,a3,-1192 # 11fe8 <__func__.0>
   10498:	03c00613          	li	a2,60
   1049c:	00002597          	auipc	a1,0x2
   104a0:	a8458593          	addi	a1,a1,-1404 # 11f20 <lseek+0x7c>
   104a4:	00002517          	auipc	a0,0x2
   104a8:	a8450513          	addi	a0,a0,-1404 # 11f28 <lseek+0x84>
   104ac:	638010ef          	jal	ra,11ae4 <printf>
   104b0:	00100593          	li	a1,1
   104b4:	f6843503          	ld	a0,-152(s0)
   104b8:	15d010ef          	jal	ra,11e14 <open>
   104bc:	00050793          	mv	a5,a0
   104c0:	f6f42223          	sw	a5,-156(s0)
   104c4:	f6442783          	lw	a5,-156(s0)
   104c8:	00078713          	mv	a4,a5
   104cc:	00002697          	auipc	a3,0x2
   104d0:	b1c68693          	addi	a3,a3,-1252 # 11fe8 <__func__.0>
   104d4:	03e00613          	li	a2,62
   104d8:	00002597          	auipc	a1,0x2
   104dc:	a4858593          	addi	a1,a1,-1464 # 11f20 <lseek+0x7c>
   104e0:	00002517          	auipc	a0,0x2
   104e4:	a6850513          	addi	a0,a0,-1432 # 11f48 <lseek+0xa4>
   104e8:	5fc010ef          	jal	ra,11ae4 <printf>
   104ec:	f6442783          	lw	a5,-156(s0)
   104f0:	0007871b          	sext.w	a4,a5
   104f4:	fff00793          	li	a5,-1
   104f8:	00f71c63          	bne	a4,a5,10510 <parse_cmd+0x1e4>
   104fc:	f6843583          	ld	a1,-152(s0)
   10500:	00002517          	auipc	a0,0x2
   10504:	a6850513          	addi	a0,a0,-1432 # 11f68 <lseek+0xc4>
   10508:	5dc010ef          	jal	ra,11ae4 <printf>
   1050c:	59c0006f          	j	10aa8 <parse_cmd+0x77c>
   10510:	d1840713          	addi	a4,s0,-744
   10514:	f6442783          	lw	a5,-156(s0)
   10518:	1fd00613          	li	a2,509
   1051c:	00070593          	mv	a1,a4
   10520:	00078513          	mv	a0,a5
   10524:	029010ef          	jal	ra,11d4c <read>
   10528:	00050793          	mv	a5,a0
   1052c:	f6f42023          	sw	a5,-160(s0)
   10530:	f6042783          	lw	a5,-160(s0)
   10534:	0007879b          	sext.w	a5,a5
   10538:	02079263          	bnez	a5,1055c <parse_cmd+0x230>
   1053c:	f8f44783          	lbu	a5,-113(s0)
   10540:	0ff7f713          	zext.b	a4,a5
   10544:	00a00793          	li	a5,10
   10548:	0af70063          	beq	a4,a5,105e8 <parse_cmd+0x2bc>
   1054c:	00002517          	auipc	a0,0x2
   10550:	a3450513          	addi	a0,a0,-1484 # 11f80 <lseek+0xdc>
   10554:	590010ef          	jal	ra,11ae4 <printf>
   10558:	0900006f          	j	105e8 <parse_cmd+0x2bc>
   1055c:	f8042423          	sw	zero,-120(s0)
   10560:	06c0006f          	j	105cc <parse_cmd+0x2a0>
   10564:	f8842783          	lw	a5,-120(s0)
   10568:	f9078793          	addi	a5,a5,-112
   1056c:	008787b3          	add	a5,a5,s0
   10570:	d887c783          	lbu	a5,-632(a5)
   10574:	00079e63          	bnez	a5,10590 <parse_cmd+0x264>
   10578:	00100613          	li	a2,1
   1057c:	00002597          	auipc	a1,0x2
   10580:	a0c58593          	addi	a1,a1,-1524 # 11f88 <lseek+0xe4>
   10584:	00100513          	li	a0,1
   10588:	6a4010ef          	jal	ra,11c2c <write>
   1058c:	0200006f          	j	105ac <parse_cmd+0x280>
   10590:	d1840713          	addi	a4,s0,-744
   10594:	f8842783          	lw	a5,-120(s0)
   10598:	00f707b3          	add	a5,a4,a5
   1059c:	00100613          	li	a2,1
   105a0:	00078593          	mv	a1,a5
   105a4:	00100513          	li	a0,1
   105a8:	684010ef          	jal	ra,11c2c <write>
   105ac:	f8842783          	lw	a5,-120(s0)
   105b0:	f9078793          	addi	a5,a5,-112
   105b4:	008787b3          	add	a5,a5,s0
   105b8:	d887c783          	lbu	a5,-632(a5)
   105bc:	f8f407a3          	sb	a5,-113(s0)
   105c0:	f8842783          	lw	a5,-120(s0)
   105c4:	0017879b          	addiw	a5,a5,1
   105c8:	f8f42423          	sw	a5,-120(s0)
   105cc:	f8842783          	lw	a5,-120(s0)
   105d0:	00078713          	mv	a4,a5
   105d4:	f6042783          	lw	a5,-160(s0)
   105d8:	0007071b          	sext.w	a4,a4
   105dc:	0007879b          	sext.w	a5,a5
   105e0:	f8f742e3          	blt	a4,a5,10564 <parse_cmd+0x238>
   105e4:	f2dff06f          	j	10510 <parse_cmd+0x1e4>
   105e8:	00000013          	nop
   105ec:	f6442783          	lw	a5,-156(s0)
   105f0:	00078513          	mv	a0,a5
   105f4:	069010ef          	jal	ra,11e5c <close>
   105f8:	4b00006f          	j	10aa8 <parse_cmd+0x77c>
   105fc:	d0843783          	ld	a5,-760(s0)
   10600:	0007c783          	lbu	a5,0(a5)
   10604:	00078713          	mv	a4,a5
   10608:	06500793          	li	a5,101
   1060c:	48f71663          	bne	a4,a5,10a98 <parse_cmd+0x76c>
   10610:	d0843783          	ld	a5,-760(s0)
   10614:	00178793          	addi	a5,a5,1
   10618:	0007c783          	lbu	a5,0(a5)
   1061c:	00078713          	mv	a4,a5
   10620:	06400793          	li	a5,100
   10624:	46f71a63          	bne	a4,a5,10a98 <parse_cmd+0x76c>
   10628:	d0843783          	ld	a5,-760(s0)
   1062c:	00278793          	addi	a5,a5,2
   10630:	0007c783          	lbu	a5,0(a5)
   10634:	00078713          	mv	a4,a5
   10638:	06900793          	li	a5,105
   1063c:	44f71e63          	bne	a4,a5,10a98 <parse_cmd+0x76c>
   10640:	d0843783          	ld	a5,-760(s0)
   10644:	00378793          	addi	a5,a5,3
   10648:	0007c783          	lbu	a5,0(a5)
   1064c:	00078713          	mv	a4,a5
   10650:	07400793          	li	a5,116
   10654:	44f71263          	bne	a4,a5,10a98 <parse_cmd+0x76c>
   10658:	00010793          	mv	a5,sp
   1065c:	00078493          	mv	s1,a5
   10660:	d0843783          	ld	a5,-760(s0)
   10664:	00478793          	addi	a5,a5,4
   10668:	d0f43423          	sd	a5,-760(s0)
   1066c:	0100006f          	j	1067c <parse_cmd+0x350>
   10670:	d0843783          	ld	a5,-760(s0)
   10674:	00178793          	addi	a5,a5,1
   10678:	d0f43423          	sd	a5,-760(s0)
   1067c:	d0843783          	ld	a5,-760(s0)
   10680:	0007c783          	lbu	a5,0(a5)
   10684:	00078713          	mv	a4,a5
   10688:	02000793          	li	a5,32
   1068c:	00f71863          	bne	a4,a5,1069c <parse_cmd+0x370>
   10690:	d0843783          	ld	a5,-760(s0)
   10694:	0007c783          	lbu	a5,0(a5)
   10698:	fc079ce3          	bnez	a5,10670 <parse_cmd+0x344>
   1069c:	d0843503          	ld	a0,-760(s0)
   106a0:	af9ff0ef          	jal	ra,10198 <get_param>
   106a4:	f4a43c23          	sd	a0,-168(s0)
   106a8:	f5843503          	ld	a0,-168(s0)
   106ac:	534010ef          	jal	ra,11be0 <strlen>
   106b0:	00050793          	mv	a5,a0
   106b4:	f4f42a23          	sw	a5,-172(s0)
   106b8:	f5442783          	lw	a5,-172(s0)
   106bc:	0017879b          	addiw	a5,a5,1
   106c0:	0007879b          	sext.w	a5,a5
   106c4:	00078713          	mv	a4,a5
   106c8:	fff70713          	addi	a4,a4,-1
   106cc:	f4e43423          	sd	a4,-184(s0)
   106d0:	00078713          	mv	a4,a5
   106d4:	cee43823          	sd	a4,-784(s0)
   106d8:	ce043c23          	sd	zero,-776(s0)
   106dc:	cf043703          	ld	a4,-784(s0)
   106e0:	03d75713          	srli	a4,a4,0x3d
   106e4:	cf843683          	ld	a3,-776(s0)
   106e8:	00369693          	slli	a3,a3,0x3
   106ec:	c8d43c23          	sd	a3,-872(s0)
   106f0:	c9843683          	ld	a3,-872(s0)
   106f4:	00d76733          	or	a4,a4,a3
   106f8:	c8e43c23          	sd	a4,-872(s0)
   106fc:	cf043703          	ld	a4,-784(s0)
   10700:	00371713          	slli	a4,a4,0x3
   10704:	c8e43823          	sd	a4,-880(s0)
   10708:	00078713          	mv	a4,a5
   1070c:	cee43023          	sd	a4,-800(s0)
   10710:	ce043423          	sd	zero,-792(s0)
   10714:	ce043703          	ld	a4,-800(s0)
   10718:	03d75713          	srli	a4,a4,0x3d
   1071c:	ce843683          	ld	a3,-792(s0)
   10720:	00369d93          	slli	s11,a3,0x3
   10724:	01b76db3          	or	s11,a4,s11
   10728:	ce043703          	ld	a4,-800(s0)
   1072c:	00371d13          	slli	s10,a4,0x3
   10730:	00f78793          	addi	a5,a5,15
   10734:	0047d793          	srli	a5,a5,0x4
   10738:	00479793          	slli	a5,a5,0x4
   1073c:	40f10133          	sub	sp,sp,a5
   10740:	00010793          	mv	a5,sp
   10744:	00078793          	mv	a5,a5
   10748:	f4f43023          	sd	a5,-192(s0)
   1074c:	f8042223          	sw	zero,-124(s0)
   10750:	0300006f          	j	10780 <parse_cmd+0x454>
   10754:	f8442783          	lw	a5,-124(s0)
   10758:	f5843703          	ld	a4,-168(s0)
   1075c:	00f707b3          	add	a5,a4,a5
   10760:	0007c703          	lbu	a4,0(a5)
   10764:	f4043683          	ld	a3,-192(s0)
   10768:	f8442783          	lw	a5,-124(s0)
   1076c:	00f687b3          	add	a5,a3,a5
   10770:	00e78023          	sb	a4,0(a5)
   10774:	f8442783          	lw	a5,-124(s0)
   10778:	0017879b          	addiw	a5,a5,1
   1077c:	f8f42223          	sw	a5,-124(s0)
   10780:	f8442783          	lw	a5,-124(s0)
   10784:	00078713          	mv	a4,a5
   10788:	f5442783          	lw	a5,-172(s0)
   1078c:	0007071b          	sext.w	a4,a4
   10790:	0007879b          	sext.w	a5,a5
   10794:	fcf740e3          	blt	a4,a5,10754 <parse_cmd+0x428>
   10798:	f4043703          	ld	a4,-192(s0)
   1079c:	f5442783          	lw	a5,-172(s0)
   107a0:	00f707b3          	add	a5,a4,a5
   107a4:	00078023          	sb	zero,0(a5)
   107a8:	f5442783          	lw	a5,-172(s0)
   107ac:	d0843703          	ld	a4,-760(s0)
   107b0:	00f707b3          	add	a5,a4,a5
   107b4:	d0f43423          	sd	a5,-760(s0)
   107b8:	0100006f          	j	107c8 <parse_cmd+0x49c>
   107bc:	d0843783          	ld	a5,-760(s0)
   107c0:	00178793          	addi	a5,a5,1
   107c4:	d0f43423          	sd	a5,-760(s0)
   107c8:	d0843783          	ld	a5,-760(s0)
   107cc:	0007c783          	lbu	a5,0(a5)
   107d0:	00078713          	mv	a4,a5
   107d4:	02000793          	li	a5,32
   107d8:	00f71863          	bne	a4,a5,107e8 <parse_cmd+0x4bc>
   107dc:	d0843783          	ld	a5,-760(s0)
   107e0:	0007c783          	lbu	a5,0(a5)
   107e4:	fc079ce3          	bnez	a5,107bc <parse_cmd+0x490>
   107e8:	d0843503          	ld	a0,-760(s0)
   107ec:	9adff0ef          	jal	ra,10198 <get_param>
   107f0:	f4a43c23          	sd	a0,-168(s0)
   107f4:	f5843503          	ld	a0,-168(s0)
   107f8:	3e8010ef          	jal	ra,11be0 <strlen>
   107fc:	00050793          	mv	a5,a0
   10800:	f4f42a23          	sw	a5,-172(s0)
   10804:	f5442783          	lw	a5,-172(s0)
   10808:	0017879b          	addiw	a5,a5,1
   1080c:	0007879b          	sext.w	a5,a5
   10810:	00078713          	mv	a4,a5
   10814:	fff70713          	addi	a4,a4,-1
   10818:	f2e43c23          	sd	a4,-200(s0)
   1081c:	00078713          	mv	a4,a5
   10820:	cce43823          	sd	a4,-816(s0)
   10824:	cc043c23          	sd	zero,-808(s0)
   10828:	cd043703          	ld	a4,-816(s0)
   1082c:	03d75713          	srli	a4,a4,0x3d
   10830:	cd843683          	ld	a3,-808(s0)
   10834:	00369c93          	slli	s9,a3,0x3
   10838:	01976cb3          	or	s9,a4,s9
   1083c:	cd043703          	ld	a4,-816(s0)
   10840:	00371c13          	slli	s8,a4,0x3
   10844:	00078713          	mv	a4,a5
   10848:	cce43023          	sd	a4,-832(s0)
   1084c:	cc043423          	sd	zero,-824(s0)
   10850:	cc043703          	ld	a4,-832(s0)
   10854:	03d75713          	srli	a4,a4,0x3d
   10858:	cc843683          	ld	a3,-824(s0)
   1085c:	00369b93          	slli	s7,a3,0x3
   10860:	01776bb3          	or	s7,a4,s7
   10864:	cc043703          	ld	a4,-832(s0)
   10868:	00371b13          	slli	s6,a4,0x3
   1086c:	00f78793          	addi	a5,a5,15
   10870:	0047d793          	srli	a5,a5,0x4
   10874:	00479793          	slli	a5,a5,0x4
   10878:	40f10133          	sub	sp,sp,a5
   1087c:	00010793          	mv	a5,sp
   10880:	00078793          	mv	a5,a5
   10884:	f2f43823          	sd	a5,-208(s0)
   10888:	f8042023          	sw	zero,-128(s0)
   1088c:	0300006f          	j	108bc <parse_cmd+0x590>
   10890:	f8042783          	lw	a5,-128(s0)
   10894:	f5843703          	ld	a4,-168(s0)
   10898:	00f707b3          	add	a5,a4,a5
   1089c:	0007c703          	lbu	a4,0(a5)
   108a0:	f3043683          	ld	a3,-208(s0)
   108a4:	f8042783          	lw	a5,-128(s0)
   108a8:	00f687b3          	add	a5,a3,a5
   108ac:	00e78023          	sb	a4,0(a5)
   108b0:	f8042783          	lw	a5,-128(s0)
   108b4:	0017879b          	addiw	a5,a5,1
   108b8:	f8f42023          	sw	a5,-128(s0)
   108bc:	f8042783          	lw	a5,-128(s0)
   108c0:	00078713          	mv	a4,a5
   108c4:	f5442783          	lw	a5,-172(s0)
   108c8:	0007071b          	sext.w	a4,a4
   108cc:	0007879b          	sext.w	a5,a5
   108d0:	fcf740e3          	blt	a4,a5,10890 <parse_cmd+0x564>
   108d4:	f3043703          	ld	a4,-208(s0)
   108d8:	f5442783          	lw	a5,-172(s0)
   108dc:	00f707b3          	add	a5,a4,a5
   108e0:	00078023          	sb	zero,0(a5)
   108e4:	f5442783          	lw	a5,-172(s0)
   108e8:	d0843703          	ld	a4,-760(s0)
   108ec:	00f707b3          	add	a5,a4,a5
   108f0:	d0f43423          	sd	a5,-760(s0)
   108f4:	0100006f          	j	10904 <parse_cmd+0x5d8>
   108f8:	d0843783          	ld	a5,-760(s0)
   108fc:	00178793          	addi	a5,a5,1
   10900:	d0f43423          	sd	a5,-760(s0)
   10904:	d0843783          	ld	a5,-760(s0)
   10908:	0007c783          	lbu	a5,0(a5)
   1090c:	00078713          	mv	a4,a5
   10910:	02000793          	li	a5,32
   10914:	00f71863          	bne	a4,a5,10924 <parse_cmd+0x5f8>
   10918:	d0843783          	ld	a5,-760(s0)
   1091c:	0007c783          	lbu	a5,0(a5)
   10920:	fc079ce3          	bnez	a5,108f8 <parse_cmd+0x5cc>
   10924:	d0843503          	ld	a0,-760(s0)
   10928:	925ff0ef          	jal	ra,1024c <get_string>
   1092c:	f4a43c23          	sd	a0,-168(s0)
   10930:	f5843503          	ld	a0,-168(s0)
   10934:	2ac010ef          	jal	ra,11be0 <strlen>
   10938:	00050793          	mv	a5,a0
   1093c:	f4f42a23          	sw	a5,-172(s0)
   10940:	f5442783          	lw	a5,-172(s0)
   10944:	0017879b          	addiw	a5,a5,1
   10948:	0007879b          	sext.w	a5,a5
   1094c:	00078713          	mv	a4,a5
   10950:	fff70713          	addi	a4,a4,-1
   10954:	f2e43423          	sd	a4,-216(s0)
   10958:	00078713          	mv	a4,a5
   1095c:	cae43823          	sd	a4,-848(s0)
   10960:	ca043c23          	sd	zero,-840(s0)
   10964:	cb043703          	ld	a4,-848(s0)
   10968:	03d75713          	srli	a4,a4,0x3d
   1096c:	cb843683          	ld	a3,-840(s0)
   10970:	00369a93          	slli	s5,a3,0x3
   10974:	01576ab3          	or	s5,a4,s5
   10978:	cb043703          	ld	a4,-848(s0)
   1097c:	00371a13          	slli	s4,a4,0x3
   10980:	00078713          	mv	a4,a5
   10984:	cae43023          	sd	a4,-864(s0)
   10988:	ca043423          	sd	zero,-856(s0)
   1098c:	ca043703          	ld	a4,-864(s0)
   10990:	03d75713          	srli	a4,a4,0x3d
   10994:	ca843683          	ld	a3,-856(s0)
   10998:	00369993          	slli	s3,a3,0x3
   1099c:	013769b3          	or	s3,a4,s3
   109a0:	ca043703          	ld	a4,-864(s0)
   109a4:	00371913          	slli	s2,a4,0x3
   109a8:	00f78793          	addi	a5,a5,15
   109ac:	0047d793          	srli	a5,a5,0x4
   109b0:	00479793          	slli	a5,a5,0x4
   109b4:	40f10133          	sub	sp,sp,a5
   109b8:	00010793          	mv	a5,sp
   109bc:	00078793          	mv	a5,a5
   109c0:	f2f43023          	sd	a5,-224(s0)
   109c4:	f6042e23          	sw	zero,-132(s0)
   109c8:	0300006f          	j	109f8 <parse_cmd+0x6cc>
   109cc:	f7c42783          	lw	a5,-132(s0)
   109d0:	f5843703          	ld	a4,-168(s0)
   109d4:	00f707b3          	add	a5,a4,a5
   109d8:	0007c703          	lbu	a4,0(a5)
   109dc:	f2043683          	ld	a3,-224(s0)
   109e0:	f7c42783          	lw	a5,-132(s0)
   109e4:	00f687b3          	add	a5,a3,a5
   109e8:	00e78023          	sb	a4,0(a5)
   109ec:	f7c42783          	lw	a5,-132(s0)
   109f0:	0017879b          	addiw	a5,a5,1
   109f4:	f6f42e23          	sw	a5,-132(s0)
   109f8:	f7c42783          	lw	a5,-132(s0)
   109fc:	00078713          	mv	a4,a5
   10a00:	f5442783          	lw	a5,-172(s0)
   10a04:	0007071b          	sext.w	a4,a4
   10a08:	0007879b          	sext.w	a5,a5
   10a0c:	fcf740e3          	blt	a4,a5,109cc <parse_cmd+0x6a0>
   10a10:	f2043703          	ld	a4,-224(s0)
   10a14:	f5442783          	lw	a5,-172(s0)
   10a18:	00f707b3          	add	a5,a4,a5
   10a1c:	00078023          	sb	zero,0(a5)
   10a20:	f5442783          	lw	a5,-172(s0)
   10a24:	d0843703          	ld	a4,-760(s0)
   10a28:	00f707b3          	add	a5,a4,a5
   10a2c:	d0f43423          	sd	a5,-760(s0)
   10a30:	f3043503          	ld	a0,-208(s0)
   10a34:	eb8ff0ef          	jal	ra,100ec <atoi>
   10a38:	00050793          	mv	a5,a0
   10a3c:	f0f42e23          	sw	a5,-228(s0)
   10a40:	00300593          	li	a1,3
   10a44:	f4043503          	ld	a0,-192(s0)
   10a48:	3cc010ef          	jal	ra,11e14 <open>
   10a4c:	00050793          	mv	a5,a0
   10a50:	f0f42c23          	sw	a5,-232(s0)
   10a54:	f1c42703          	lw	a4,-228(s0)
   10a58:	f1842783          	lw	a5,-232(s0)
   10a5c:	00000613          	li	a2,0
   10a60:	00070593          	mv	a1,a4
   10a64:	00078513          	mv	a0,a5
   10a68:	43c010ef          	jal	ra,11ea4 <lseek>
   10a6c:	f5442703          	lw	a4,-172(s0)
   10a70:	f1842783          	lw	a5,-232(s0)
   10a74:	00070613          	mv	a2,a4
   10a78:	f2043583          	ld	a1,-224(s0)
   10a7c:	00078513          	mv	a0,a5
   10a80:	1ac010ef          	jal	ra,11c2c <write>
   10a84:	f1842783          	lw	a5,-232(s0)
   10a88:	00078513          	mv	a0,a5
   10a8c:	3d0010ef          	jal	ra,11e5c <close>
   10a90:	00048113          	mv	sp,s1
   10a94:	0140006f          	j	10aa8 <parse_cmd+0x77c>
   10a98:	d0843583          	ld	a1,-760(s0)
   10a9c:	00001517          	auipc	a0,0x1
   10aa0:	4f450513          	addi	a0,a0,1268 # 11f90 <lseek+0xec>
   10aa4:	040010ef          	jal	ra,11ae4 <printf>
   10aa8:	c9040113          	addi	sp,s0,-880
   10aac:	36813083          	ld	ra,872(sp)
   10ab0:	36013403          	ld	s0,864(sp)
   10ab4:	35813483          	ld	s1,856(sp)
   10ab8:	35013903          	ld	s2,848(sp)
   10abc:	34813983          	ld	s3,840(sp)
   10ac0:	34013a03          	ld	s4,832(sp)
   10ac4:	33813a83          	ld	s5,824(sp)
   10ac8:	33013b03          	ld	s6,816(sp)
   10acc:	32813b83          	ld	s7,808(sp)
   10ad0:	32013c03          	ld	s8,800(sp)
   10ad4:	31813c83          	ld	s9,792(sp)
   10ad8:	31013d03          	ld	s10,784(sp)
   10adc:	30813d83          	ld	s11,776(sp)
   10ae0:	37010113          	addi	sp,sp,880
   10ae4:	00008067          	ret

0000000000010ae8 <main>:
   10ae8:	f6010113          	addi	sp,sp,-160
   10aec:	08113c23          	sd	ra,152(sp)
   10af0:	08813823          	sd	s0,144(sp)
   10af4:	0a010413          	addi	s0,sp,160
   10af8:	00f00613          	li	a2,15
   10afc:	00001597          	auipc	a1,0x1
   10b00:	4ac58593          	addi	a1,a1,1196 # 11fa8 <lseek+0x104>
   10b04:	00100513          	li	a0,1
   10b08:	124010ef          	jal	ra,11c2c <write>
   10b0c:	00f00613          	li	a2,15
   10b10:	00001597          	auipc	a1,0x1
   10b14:	4a858593          	addi	a1,a1,1192 # 11fb8 <lseek+0x114>
   10b18:	00200513          	li	a0,2
   10b1c:	110010ef          	jal	ra,11c2c <write>
   10b20:	fe042623          	sw	zero,-20(s0)
   10b24:	00001517          	auipc	a0,0x1
   10b28:	4a450513          	addi	a0,a0,1188 # 11fc8 <lseek+0x124>
   10b2c:	7b9000ef          	jal	ra,11ae4 <printf>
   10b30:	fe840793          	addi	a5,s0,-24
   10b34:	00100613          	li	a2,1
   10b38:	00078593          	mv	a1,a5
   10b3c:	00000513          	li	a0,0
   10b40:	20c010ef          	jal	ra,11d4c <read>
   10b44:	fe844783          	lbu	a5,-24(s0)
   10b48:	00078713          	mv	a4,a5
   10b4c:	00d00793          	li	a5,13
   10b50:	00f71e63          	bne	a4,a5,10b6c <main+0x84>
   10b54:	00100613          	li	a2,1
   10b58:	00001597          	auipc	a1,0x1
   10b5c:	3c058593          	addi	a1,a1,960 # 11f18 <lseek+0x74>
   10b60:	00100513          	li	a0,1
   10b64:	0c8010ef          	jal	ra,11c2c <write>
   10b68:	0440006f          	j	10bac <main+0xc4>
   10b6c:	fe844783          	lbu	a5,-24(s0)
   10b70:	00078713          	mv	a4,a5
   10b74:	07f00793          	li	a5,127
   10b78:	02f71a63          	bne	a4,a5,10bac <main+0xc4>
   10b7c:	fec42783          	lw	a5,-20(s0)
   10b80:	0007879b          	sext.w	a5,a5
   10b84:	0af05263          	blez	a5,10c28 <main+0x140>
   10b88:	00300613          	li	a2,3
   10b8c:	00001597          	auipc	a1,0x1
   10b90:	45458593          	addi	a1,a1,1108 # 11fe0 <lseek+0x13c>
   10b94:	00100513          	li	a0,1
   10b98:	094010ef          	jal	ra,11c2c <write>
   10b9c:	fec42783          	lw	a5,-20(s0)
   10ba0:	fff7879b          	addiw	a5,a5,-1
   10ba4:	fef42623          	sw	a5,-20(s0)
   10ba8:	0800006f          	j	10c28 <main+0x140>
   10bac:	fe840793          	addi	a5,s0,-24
   10bb0:	00100613          	li	a2,1
   10bb4:	00078593          	mv	a1,a5
   10bb8:	00100513          	li	a0,1
   10bbc:	070010ef          	jal	ra,11c2c <write>
   10bc0:	fe844783          	lbu	a5,-24(s0)
   10bc4:	00078713          	mv	a4,a5
   10bc8:	00d00793          	li	a5,13
   10bcc:	02f71e63          	bne	a4,a5,10c08 <main+0x120>
   10bd0:	fec42783          	lw	a5,-20(s0)
   10bd4:	ff078793          	addi	a5,a5,-16
   10bd8:	008787b3          	add	a5,a5,s0
   10bdc:	f6078c23          	sb	zero,-136(a5)
   10be0:	fec42703          	lw	a4,-20(s0)
   10be4:	f6840793          	addi	a5,s0,-152
   10be8:	00070593          	mv	a1,a4
   10bec:	00078513          	mv	a0,a5
   10bf0:	f3cff0ef          	jal	ra,1032c <parse_cmd>
   10bf4:	fe042623          	sw	zero,-20(s0)
   10bf8:	00001517          	auipc	a0,0x1
   10bfc:	3d050513          	addi	a0,a0,976 # 11fc8 <lseek+0x124>
   10c00:	6e5000ef          	jal	ra,11ae4 <printf>
   10c04:	f2dff06f          	j	10b30 <main+0x48>
   10c08:	fec42783          	lw	a5,-20(s0)
   10c0c:	0017871b          	addiw	a4,a5,1
   10c10:	fee42623          	sw	a4,-20(s0)
   10c14:	fe844703          	lbu	a4,-24(s0)
   10c18:	ff078793          	addi	a5,a5,-16
   10c1c:	008787b3          	add	a5,a5,s0
   10c20:	f6e78c23          	sb	a4,-136(a5)
   10c24:	f0dff06f          	j	10b30 <main+0x48>
   10c28:	00000013          	nop
   10c2c:	f05ff06f          	j	10b30 <main+0x48>

0000000000010c30 <putc>:
   10c30:	fe010113          	addi	sp,sp,-32
   10c34:	00813c23          	sd	s0,24(sp)
   10c38:	02010413          	addi	s0,sp,32
   10c3c:	00050793          	mv	a5,a0
   10c40:	fef42623          	sw	a5,-20(s0)
   10c44:	00003797          	auipc	a5,0x3
   10c48:	40478793          	addi	a5,a5,1028 # 14048 <tail>
   10c4c:	0007a783          	lw	a5,0(a5)
   10c50:	0017871b          	addiw	a4,a5,1
   10c54:	0007069b          	sext.w	a3,a4
   10c58:	00003717          	auipc	a4,0x3
   10c5c:	3f070713          	addi	a4,a4,1008 # 14048 <tail>
   10c60:	00d72023          	sw	a3,0(a4)
   10c64:	fec42703          	lw	a4,-20(s0)
   10c68:	0ff77713          	zext.b	a4,a4
   10c6c:	00003697          	auipc	a3,0x3
   10c70:	3e468693          	addi	a3,a3,996 # 14050 <buffer>
   10c74:	00f687b3          	add	a5,a3,a5
   10c78:	00e78023          	sb	a4,0(a5)
   10c7c:	fec42783          	lw	a5,-20(s0)
   10c80:	0ff7f793          	zext.b	a5,a5
   10c84:	0007879b          	sext.w	a5,a5
   10c88:	00078513          	mv	a0,a5
   10c8c:	01813403          	ld	s0,24(sp)
   10c90:	02010113          	addi	sp,sp,32
   10c94:	00008067          	ret

0000000000010c98 <isspace>:
   10c98:	fe010113          	addi	sp,sp,-32
   10c9c:	00813c23          	sd	s0,24(sp)
   10ca0:	02010413          	addi	s0,sp,32
   10ca4:	00050793          	mv	a5,a0
   10ca8:	fef42623          	sw	a5,-20(s0)
   10cac:	fec42783          	lw	a5,-20(s0)
   10cb0:	0007871b          	sext.w	a4,a5
   10cb4:	02000793          	li	a5,32
   10cb8:	02f70263          	beq	a4,a5,10cdc <isspace+0x44>
   10cbc:	fec42783          	lw	a5,-20(s0)
   10cc0:	0007871b          	sext.w	a4,a5
   10cc4:	00800793          	li	a5,8
   10cc8:	00e7de63          	bge	a5,a4,10ce4 <isspace+0x4c>
   10ccc:	fec42783          	lw	a5,-20(s0)
   10cd0:	0007871b          	sext.w	a4,a5
   10cd4:	00d00793          	li	a5,13
   10cd8:	00e7c663          	blt	a5,a4,10ce4 <isspace+0x4c>
   10cdc:	00100793          	li	a5,1
   10ce0:	0080006f          	j	10ce8 <isspace+0x50>
   10ce4:	00000793          	li	a5,0
   10ce8:	00078513          	mv	a0,a5
   10cec:	01813403          	ld	s0,24(sp)
   10cf0:	02010113          	addi	sp,sp,32
   10cf4:	00008067          	ret

0000000000010cf8 <strtol>:
   10cf8:	fb010113          	addi	sp,sp,-80
   10cfc:	04113423          	sd	ra,72(sp)
   10d00:	04813023          	sd	s0,64(sp)
   10d04:	05010413          	addi	s0,sp,80
   10d08:	fca43423          	sd	a0,-56(s0)
   10d0c:	fcb43023          	sd	a1,-64(s0)
   10d10:	00060793          	mv	a5,a2
   10d14:	faf42e23          	sw	a5,-68(s0)
   10d18:	fe043423          	sd	zero,-24(s0)
   10d1c:	fe0403a3          	sb	zero,-25(s0)
   10d20:	fc843783          	ld	a5,-56(s0)
   10d24:	fcf43c23          	sd	a5,-40(s0)
   10d28:	0100006f          	j	10d38 <strtol+0x40>
   10d2c:	fd843783          	ld	a5,-40(s0)
   10d30:	00178793          	addi	a5,a5,1
   10d34:	fcf43c23          	sd	a5,-40(s0)
   10d38:	fd843783          	ld	a5,-40(s0)
   10d3c:	0007c783          	lbu	a5,0(a5)
   10d40:	0007879b          	sext.w	a5,a5
   10d44:	00078513          	mv	a0,a5
   10d48:	f51ff0ef          	jal	ra,10c98 <isspace>
   10d4c:	00050793          	mv	a5,a0
   10d50:	fc079ee3          	bnez	a5,10d2c <strtol+0x34>
   10d54:	fd843783          	ld	a5,-40(s0)
   10d58:	0007c783          	lbu	a5,0(a5)
   10d5c:	00078713          	mv	a4,a5
   10d60:	02d00793          	li	a5,45
   10d64:	00f71e63          	bne	a4,a5,10d80 <strtol+0x88>
   10d68:	00100793          	li	a5,1
   10d6c:	fef403a3          	sb	a5,-25(s0)
   10d70:	fd843783          	ld	a5,-40(s0)
   10d74:	00178793          	addi	a5,a5,1
   10d78:	fcf43c23          	sd	a5,-40(s0)
   10d7c:	0240006f          	j	10da0 <strtol+0xa8>
   10d80:	fd843783          	ld	a5,-40(s0)
   10d84:	0007c783          	lbu	a5,0(a5)
   10d88:	00078713          	mv	a4,a5
   10d8c:	02b00793          	li	a5,43
   10d90:	00f71863          	bne	a4,a5,10da0 <strtol+0xa8>
   10d94:	fd843783          	ld	a5,-40(s0)
   10d98:	00178793          	addi	a5,a5,1
   10d9c:	fcf43c23          	sd	a5,-40(s0)
   10da0:	fbc42783          	lw	a5,-68(s0)
   10da4:	0007879b          	sext.w	a5,a5
   10da8:	06079c63          	bnez	a5,10e20 <strtol+0x128>
   10dac:	fd843783          	ld	a5,-40(s0)
   10db0:	0007c783          	lbu	a5,0(a5)
   10db4:	00078713          	mv	a4,a5
   10db8:	03000793          	li	a5,48
   10dbc:	04f71e63          	bne	a4,a5,10e18 <strtol+0x120>
   10dc0:	fd843783          	ld	a5,-40(s0)
   10dc4:	00178793          	addi	a5,a5,1
   10dc8:	fcf43c23          	sd	a5,-40(s0)
   10dcc:	fd843783          	ld	a5,-40(s0)
   10dd0:	0007c783          	lbu	a5,0(a5)
   10dd4:	00078713          	mv	a4,a5
   10dd8:	07800793          	li	a5,120
   10ddc:	00f70c63          	beq	a4,a5,10df4 <strtol+0xfc>
   10de0:	fd843783          	ld	a5,-40(s0)
   10de4:	0007c783          	lbu	a5,0(a5)
   10de8:	00078713          	mv	a4,a5
   10dec:	05800793          	li	a5,88
   10df0:	00f71e63          	bne	a4,a5,10e0c <strtol+0x114>
   10df4:	01000793          	li	a5,16
   10df8:	faf42e23          	sw	a5,-68(s0)
   10dfc:	fd843783          	ld	a5,-40(s0)
   10e00:	00178793          	addi	a5,a5,1
   10e04:	fcf43c23          	sd	a5,-40(s0)
   10e08:	0180006f          	j	10e20 <strtol+0x128>
   10e0c:	00800793          	li	a5,8
   10e10:	faf42e23          	sw	a5,-68(s0)
   10e14:	00c0006f          	j	10e20 <strtol+0x128>
   10e18:	00a00793          	li	a5,10
   10e1c:	faf42e23          	sw	a5,-68(s0)
   10e20:	fd843783          	ld	a5,-40(s0)
   10e24:	0007c783          	lbu	a5,0(a5)
   10e28:	00078713          	mv	a4,a5
   10e2c:	02f00793          	li	a5,47
   10e30:	02e7f863          	bgeu	a5,a4,10e60 <strtol+0x168>
   10e34:	fd843783          	ld	a5,-40(s0)
   10e38:	0007c783          	lbu	a5,0(a5)
   10e3c:	00078713          	mv	a4,a5
   10e40:	03900793          	li	a5,57
   10e44:	00e7ee63          	bltu	a5,a4,10e60 <strtol+0x168>
   10e48:	fd843783          	ld	a5,-40(s0)
   10e4c:	0007c783          	lbu	a5,0(a5)
   10e50:	0007879b          	sext.w	a5,a5
   10e54:	fd07879b          	addiw	a5,a5,-48
   10e58:	fcf42a23          	sw	a5,-44(s0)
   10e5c:	0800006f          	j	10edc <strtol+0x1e4>
   10e60:	fd843783          	ld	a5,-40(s0)
   10e64:	0007c783          	lbu	a5,0(a5)
   10e68:	00078713          	mv	a4,a5
   10e6c:	06000793          	li	a5,96
   10e70:	02e7f863          	bgeu	a5,a4,10ea0 <strtol+0x1a8>
   10e74:	fd843783          	ld	a5,-40(s0)
   10e78:	0007c783          	lbu	a5,0(a5)
   10e7c:	00078713          	mv	a4,a5
   10e80:	07a00793          	li	a5,122
   10e84:	00e7ee63          	bltu	a5,a4,10ea0 <strtol+0x1a8>
   10e88:	fd843783          	ld	a5,-40(s0)
   10e8c:	0007c783          	lbu	a5,0(a5)
   10e90:	0007879b          	sext.w	a5,a5
   10e94:	fa97879b          	addiw	a5,a5,-87
   10e98:	fcf42a23          	sw	a5,-44(s0)
   10e9c:	0400006f          	j	10edc <strtol+0x1e4>
   10ea0:	fd843783          	ld	a5,-40(s0)
   10ea4:	0007c783          	lbu	a5,0(a5)
   10ea8:	00078713          	mv	a4,a5
   10eac:	04000793          	li	a5,64
   10eb0:	06e7f863          	bgeu	a5,a4,10f20 <strtol+0x228>
   10eb4:	fd843783          	ld	a5,-40(s0)
   10eb8:	0007c783          	lbu	a5,0(a5)
   10ebc:	00078713          	mv	a4,a5
   10ec0:	05a00793          	li	a5,90
   10ec4:	04e7ee63          	bltu	a5,a4,10f20 <strtol+0x228>
   10ec8:	fd843783          	ld	a5,-40(s0)
   10ecc:	0007c783          	lbu	a5,0(a5)
   10ed0:	0007879b          	sext.w	a5,a5
   10ed4:	fc97879b          	addiw	a5,a5,-55
   10ed8:	fcf42a23          	sw	a5,-44(s0)
   10edc:	fd442783          	lw	a5,-44(s0)
   10ee0:	00078713          	mv	a4,a5
   10ee4:	fbc42783          	lw	a5,-68(s0)
   10ee8:	0007071b          	sext.w	a4,a4
   10eec:	0007879b          	sext.w	a5,a5
   10ef0:	02f75663          	bge	a4,a5,10f1c <strtol+0x224>
   10ef4:	fbc42703          	lw	a4,-68(s0)
   10ef8:	fe843783          	ld	a5,-24(s0)
   10efc:	02f70733          	mul	a4,a4,a5
   10f00:	fd442783          	lw	a5,-44(s0)
   10f04:	00f707b3          	add	a5,a4,a5
   10f08:	fef43423          	sd	a5,-24(s0)
   10f0c:	fd843783          	ld	a5,-40(s0)
   10f10:	00178793          	addi	a5,a5,1
   10f14:	fcf43c23          	sd	a5,-40(s0)
   10f18:	f09ff06f          	j	10e20 <strtol+0x128>
   10f1c:	00000013          	nop
   10f20:	fc043783          	ld	a5,-64(s0)
   10f24:	00078863          	beqz	a5,10f34 <strtol+0x23c>
   10f28:	fc043783          	ld	a5,-64(s0)
   10f2c:	fd843703          	ld	a4,-40(s0)
   10f30:	00e7b023          	sd	a4,0(a5)
   10f34:	fe744783          	lbu	a5,-25(s0)
   10f38:	0ff7f793          	zext.b	a5,a5
   10f3c:	00078863          	beqz	a5,10f4c <strtol+0x254>
   10f40:	fe843783          	ld	a5,-24(s0)
   10f44:	40f007b3          	neg	a5,a5
   10f48:	0080006f          	j	10f50 <strtol+0x258>
   10f4c:	fe843783          	ld	a5,-24(s0)
   10f50:	00078513          	mv	a0,a5
   10f54:	04813083          	ld	ra,72(sp)
   10f58:	04013403          	ld	s0,64(sp)
   10f5c:	05010113          	addi	sp,sp,80
   10f60:	00008067          	ret

0000000000010f64 <puts_wo_nl>:
   10f64:	fd010113          	addi	sp,sp,-48
   10f68:	02113423          	sd	ra,40(sp)
   10f6c:	02813023          	sd	s0,32(sp)
   10f70:	03010413          	addi	s0,sp,48
   10f74:	fca43c23          	sd	a0,-40(s0)
   10f78:	fcb43823          	sd	a1,-48(s0)
   10f7c:	fd043783          	ld	a5,-48(s0)
   10f80:	00079863          	bnez	a5,10f90 <puts_wo_nl+0x2c>
   10f84:	00001797          	auipc	a5,0x1
   10f88:	07478793          	addi	a5,a5,116 # 11ff8 <__func__.0+0x10>
   10f8c:	fcf43823          	sd	a5,-48(s0)
   10f90:	fd043783          	ld	a5,-48(s0)
   10f94:	fef43423          	sd	a5,-24(s0)
   10f98:	0240006f          	j	10fbc <puts_wo_nl+0x58>
   10f9c:	fe843783          	ld	a5,-24(s0)
   10fa0:	00178713          	addi	a4,a5,1
   10fa4:	fee43423          	sd	a4,-24(s0)
   10fa8:	0007c783          	lbu	a5,0(a5)
   10fac:	0007871b          	sext.w	a4,a5
   10fb0:	fd843783          	ld	a5,-40(s0)
   10fb4:	00070513          	mv	a0,a4
   10fb8:	000780e7          	jalr	a5
   10fbc:	fe843783          	ld	a5,-24(s0)
   10fc0:	0007c783          	lbu	a5,0(a5)
   10fc4:	fc079ce3          	bnez	a5,10f9c <puts_wo_nl+0x38>
   10fc8:	fe843703          	ld	a4,-24(s0)
   10fcc:	fd043783          	ld	a5,-48(s0)
   10fd0:	40f707b3          	sub	a5,a4,a5
   10fd4:	0007879b          	sext.w	a5,a5
   10fd8:	00078513          	mv	a0,a5
   10fdc:	02813083          	ld	ra,40(sp)
   10fe0:	02013403          	ld	s0,32(sp)
   10fe4:	03010113          	addi	sp,sp,48
   10fe8:	00008067          	ret

0000000000010fec <print_dec_int>:
   10fec:	f9010113          	addi	sp,sp,-112
   10ff0:	06113423          	sd	ra,104(sp)
   10ff4:	06813023          	sd	s0,96(sp)
   10ff8:	07010413          	addi	s0,sp,112
   10ffc:	faa43423          	sd	a0,-88(s0)
   11000:	fab43023          	sd	a1,-96(s0)
   11004:	00060793          	mv	a5,a2
   11008:	f8d43823          	sd	a3,-112(s0)
   1100c:	f8f40fa3          	sb	a5,-97(s0)
   11010:	f9f44783          	lbu	a5,-97(s0)
   11014:	0ff7f793          	zext.b	a5,a5
   11018:	02078663          	beqz	a5,11044 <print_dec_int+0x58>
   1101c:	fa043703          	ld	a4,-96(s0)
   11020:	fff00793          	li	a5,-1
   11024:	03f79793          	slli	a5,a5,0x3f
   11028:	00f71e63          	bne	a4,a5,11044 <print_dec_int+0x58>
   1102c:	00001597          	auipc	a1,0x1
   11030:	fd458593          	addi	a1,a1,-44 # 12000 <__func__.0+0x18>
   11034:	fa843503          	ld	a0,-88(s0)
   11038:	f2dff0ef          	jal	ra,10f64 <puts_wo_nl>
   1103c:	00050793          	mv	a5,a0
   11040:	2a00006f          	j	112e0 <print_dec_int+0x2f4>
   11044:	f9043783          	ld	a5,-112(s0)
   11048:	00c7a783          	lw	a5,12(a5)
   1104c:	00079a63          	bnez	a5,11060 <print_dec_int+0x74>
   11050:	fa043783          	ld	a5,-96(s0)
   11054:	00079663          	bnez	a5,11060 <print_dec_int+0x74>
   11058:	00000793          	li	a5,0
   1105c:	2840006f          	j	112e0 <print_dec_int+0x2f4>
   11060:	fe0407a3          	sb	zero,-17(s0)
   11064:	f9f44783          	lbu	a5,-97(s0)
   11068:	0ff7f793          	zext.b	a5,a5
   1106c:	02078063          	beqz	a5,1108c <print_dec_int+0xa0>
   11070:	fa043783          	ld	a5,-96(s0)
   11074:	0007dc63          	bgez	a5,1108c <print_dec_int+0xa0>
   11078:	00100793          	li	a5,1
   1107c:	fef407a3          	sb	a5,-17(s0)
   11080:	fa043783          	ld	a5,-96(s0)
   11084:	40f007b3          	neg	a5,a5
   11088:	faf43023          	sd	a5,-96(s0)
   1108c:	fe042423          	sw	zero,-24(s0)
   11090:	f9f44783          	lbu	a5,-97(s0)
   11094:	0ff7f793          	zext.b	a5,a5
   11098:	02078863          	beqz	a5,110c8 <print_dec_int+0xdc>
   1109c:	fef44783          	lbu	a5,-17(s0)
   110a0:	0ff7f793          	zext.b	a5,a5
   110a4:	00079e63          	bnez	a5,110c0 <print_dec_int+0xd4>
   110a8:	f9043783          	ld	a5,-112(s0)
   110ac:	0057c783          	lbu	a5,5(a5)
   110b0:	00079863          	bnez	a5,110c0 <print_dec_int+0xd4>
   110b4:	f9043783          	ld	a5,-112(s0)
   110b8:	0047c783          	lbu	a5,4(a5)
   110bc:	00078663          	beqz	a5,110c8 <print_dec_int+0xdc>
   110c0:	00100793          	li	a5,1
   110c4:	0080006f          	j	110cc <print_dec_int+0xe0>
   110c8:	00000793          	li	a5,0
   110cc:	fcf40ba3          	sb	a5,-41(s0)
   110d0:	fd744783          	lbu	a5,-41(s0)
   110d4:	0017f793          	andi	a5,a5,1
   110d8:	fcf40ba3          	sb	a5,-41(s0)
   110dc:	fa043703          	ld	a4,-96(s0)
   110e0:	00a00793          	li	a5,10
   110e4:	02f777b3          	remu	a5,a4,a5
   110e8:	0ff7f713          	zext.b	a4,a5
   110ec:	fe842783          	lw	a5,-24(s0)
   110f0:	0017869b          	addiw	a3,a5,1
   110f4:	fed42423          	sw	a3,-24(s0)
   110f8:	0307071b          	addiw	a4,a4,48
   110fc:	0ff77713          	zext.b	a4,a4
   11100:	ff078793          	addi	a5,a5,-16
   11104:	008787b3          	add	a5,a5,s0
   11108:	fce78423          	sb	a4,-56(a5)
   1110c:	fa043703          	ld	a4,-96(s0)
   11110:	00a00793          	li	a5,10
   11114:	02f757b3          	divu	a5,a4,a5
   11118:	faf43023          	sd	a5,-96(s0)
   1111c:	fa043783          	ld	a5,-96(s0)
   11120:	fa079ee3          	bnez	a5,110dc <print_dec_int+0xf0>
   11124:	f9043783          	ld	a5,-112(s0)
   11128:	00c7a783          	lw	a5,12(a5)
   1112c:	00078713          	mv	a4,a5
   11130:	fff00793          	li	a5,-1
   11134:	02f71063          	bne	a4,a5,11154 <print_dec_int+0x168>
   11138:	f9043783          	ld	a5,-112(s0)
   1113c:	0037c783          	lbu	a5,3(a5)
   11140:	00078a63          	beqz	a5,11154 <print_dec_int+0x168>
   11144:	f9043783          	ld	a5,-112(s0)
   11148:	0087a703          	lw	a4,8(a5)
   1114c:	f9043783          	ld	a5,-112(s0)
   11150:	00e7a623          	sw	a4,12(a5)
   11154:	fe042223          	sw	zero,-28(s0)
   11158:	f9043783          	ld	a5,-112(s0)
   1115c:	0087a703          	lw	a4,8(a5)
   11160:	fe842783          	lw	a5,-24(s0)
   11164:	fcf42823          	sw	a5,-48(s0)
   11168:	f9043783          	ld	a5,-112(s0)
   1116c:	00c7a783          	lw	a5,12(a5)
   11170:	fcf42623          	sw	a5,-52(s0)
   11174:	fd042783          	lw	a5,-48(s0)
   11178:	00078593          	mv	a1,a5
   1117c:	fcc42783          	lw	a5,-52(s0)
   11180:	00078613          	mv	a2,a5
   11184:	0006069b          	sext.w	a3,a2
   11188:	0005879b          	sext.w	a5,a1
   1118c:	00f6d463          	bge	a3,a5,11194 <print_dec_int+0x1a8>
   11190:	00058613          	mv	a2,a1
   11194:	0006079b          	sext.w	a5,a2
   11198:	40f707bb          	subw	a5,a4,a5
   1119c:	0007871b          	sext.w	a4,a5
   111a0:	fd744783          	lbu	a5,-41(s0)
   111a4:	0007879b          	sext.w	a5,a5
   111a8:	40f707bb          	subw	a5,a4,a5
   111ac:	fef42023          	sw	a5,-32(s0)
   111b0:	0280006f          	j	111d8 <print_dec_int+0x1ec>
   111b4:	fa843783          	ld	a5,-88(s0)
   111b8:	02000513          	li	a0,32
   111bc:	000780e7          	jalr	a5
   111c0:	fe442783          	lw	a5,-28(s0)
   111c4:	0017879b          	addiw	a5,a5,1
   111c8:	fef42223          	sw	a5,-28(s0)
   111cc:	fe042783          	lw	a5,-32(s0)
   111d0:	fff7879b          	addiw	a5,a5,-1
   111d4:	fef42023          	sw	a5,-32(s0)
   111d8:	fe042783          	lw	a5,-32(s0)
   111dc:	0007879b          	sext.w	a5,a5
   111e0:	fcf04ae3          	bgtz	a5,111b4 <print_dec_int+0x1c8>
   111e4:	fd744783          	lbu	a5,-41(s0)
   111e8:	0ff7f793          	zext.b	a5,a5
   111ec:	04078463          	beqz	a5,11234 <print_dec_int+0x248>
   111f0:	fef44783          	lbu	a5,-17(s0)
   111f4:	0ff7f793          	zext.b	a5,a5
   111f8:	00078663          	beqz	a5,11204 <print_dec_int+0x218>
   111fc:	02d00793          	li	a5,45
   11200:	01c0006f          	j	1121c <print_dec_int+0x230>
   11204:	f9043783          	ld	a5,-112(s0)
   11208:	0057c783          	lbu	a5,5(a5)
   1120c:	00078663          	beqz	a5,11218 <print_dec_int+0x22c>
   11210:	02b00793          	li	a5,43
   11214:	0080006f          	j	1121c <print_dec_int+0x230>
   11218:	02000793          	li	a5,32
   1121c:	fa843703          	ld	a4,-88(s0)
   11220:	00078513          	mv	a0,a5
   11224:	000700e7          	jalr	a4
   11228:	fe442783          	lw	a5,-28(s0)
   1122c:	0017879b          	addiw	a5,a5,1
   11230:	fef42223          	sw	a5,-28(s0)
   11234:	fe842783          	lw	a5,-24(s0)
   11238:	fcf42e23          	sw	a5,-36(s0)
   1123c:	0280006f          	j	11264 <print_dec_int+0x278>
   11240:	fa843783          	ld	a5,-88(s0)
   11244:	03000513          	li	a0,48
   11248:	000780e7          	jalr	a5
   1124c:	fe442783          	lw	a5,-28(s0)
   11250:	0017879b          	addiw	a5,a5,1
   11254:	fef42223          	sw	a5,-28(s0)
   11258:	fdc42783          	lw	a5,-36(s0)
   1125c:	0017879b          	addiw	a5,a5,1
   11260:	fcf42e23          	sw	a5,-36(s0)
   11264:	f9043783          	ld	a5,-112(s0)
   11268:	00c7a703          	lw	a4,12(a5)
   1126c:	fd744783          	lbu	a5,-41(s0)
   11270:	0007879b          	sext.w	a5,a5
   11274:	40f707bb          	subw	a5,a4,a5
   11278:	0007871b          	sext.w	a4,a5
   1127c:	fdc42783          	lw	a5,-36(s0)
   11280:	0007879b          	sext.w	a5,a5
   11284:	fae7cee3          	blt	a5,a4,11240 <print_dec_int+0x254>
   11288:	fe842783          	lw	a5,-24(s0)
   1128c:	fff7879b          	addiw	a5,a5,-1
   11290:	fcf42c23          	sw	a5,-40(s0)
   11294:	03c0006f          	j	112d0 <print_dec_int+0x2e4>
   11298:	fd842783          	lw	a5,-40(s0)
   1129c:	ff078793          	addi	a5,a5,-16
   112a0:	008787b3          	add	a5,a5,s0
   112a4:	fc87c783          	lbu	a5,-56(a5)
   112a8:	0007871b          	sext.w	a4,a5
   112ac:	fa843783          	ld	a5,-88(s0)
   112b0:	00070513          	mv	a0,a4
   112b4:	000780e7          	jalr	a5
   112b8:	fe442783          	lw	a5,-28(s0)
   112bc:	0017879b          	addiw	a5,a5,1
   112c0:	fef42223          	sw	a5,-28(s0)
   112c4:	fd842783          	lw	a5,-40(s0)
   112c8:	fff7879b          	addiw	a5,a5,-1
   112cc:	fcf42c23          	sw	a5,-40(s0)
   112d0:	fd842783          	lw	a5,-40(s0)
   112d4:	0007879b          	sext.w	a5,a5
   112d8:	fc07d0e3          	bgez	a5,11298 <print_dec_int+0x2ac>
   112dc:	fe442783          	lw	a5,-28(s0)
   112e0:	00078513          	mv	a0,a5
   112e4:	06813083          	ld	ra,104(sp)
   112e8:	06013403          	ld	s0,96(sp)
   112ec:	07010113          	addi	sp,sp,112
   112f0:	00008067          	ret

00000000000112f4 <vprintfmt>:
   112f4:	f4010113          	addi	sp,sp,-192
   112f8:	0a113c23          	sd	ra,184(sp)
   112fc:	0a813823          	sd	s0,176(sp)
   11300:	0c010413          	addi	s0,sp,192
   11304:	f4a43c23          	sd	a0,-168(s0)
   11308:	f4b43823          	sd	a1,-176(s0)
   1130c:	f4c43423          	sd	a2,-184(s0)
   11310:	f8043023          	sd	zero,-128(s0)
   11314:	f8043423          	sd	zero,-120(s0)
   11318:	fe042623          	sw	zero,-20(s0)
   1131c:	7a40006f          	j	11ac0 <vprintfmt+0x7cc>
   11320:	f8044783          	lbu	a5,-128(s0)
   11324:	72078e63          	beqz	a5,11a60 <vprintfmt+0x76c>
   11328:	f5043783          	ld	a5,-176(s0)
   1132c:	0007c783          	lbu	a5,0(a5)
   11330:	00078713          	mv	a4,a5
   11334:	02300793          	li	a5,35
   11338:	00f71863          	bne	a4,a5,11348 <vprintfmt+0x54>
   1133c:	00100793          	li	a5,1
   11340:	f8f40123          	sb	a5,-126(s0)
   11344:	7700006f          	j	11ab4 <vprintfmt+0x7c0>
   11348:	f5043783          	ld	a5,-176(s0)
   1134c:	0007c783          	lbu	a5,0(a5)
   11350:	00078713          	mv	a4,a5
   11354:	03000793          	li	a5,48
   11358:	00f71863          	bne	a4,a5,11368 <vprintfmt+0x74>
   1135c:	00100793          	li	a5,1
   11360:	f8f401a3          	sb	a5,-125(s0)
   11364:	7500006f          	j	11ab4 <vprintfmt+0x7c0>
   11368:	f5043783          	ld	a5,-176(s0)
   1136c:	0007c783          	lbu	a5,0(a5)
   11370:	00078713          	mv	a4,a5
   11374:	06c00793          	li	a5,108
   11378:	04f70063          	beq	a4,a5,113b8 <vprintfmt+0xc4>
   1137c:	f5043783          	ld	a5,-176(s0)
   11380:	0007c783          	lbu	a5,0(a5)
   11384:	00078713          	mv	a4,a5
   11388:	07a00793          	li	a5,122
   1138c:	02f70663          	beq	a4,a5,113b8 <vprintfmt+0xc4>
   11390:	f5043783          	ld	a5,-176(s0)
   11394:	0007c783          	lbu	a5,0(a5)
   11398:	00078713          	mv	a4,a5
   1139c:	07400793          	li	a5,116
   113a0:	00f70c63          	beq	a4,a5,113b8 <vprintfmt+0xc4>
   113a4:	f5043783          	ld	a5,-176(s0)
   113a8:	0007c783          	lbu	a5,0(a5)
   113ac:	00078713          	mv	a4,a5
   113b0:	06a00793          	li	a5,106
   113b4:	00f71863          	bne	a4,a5,113c4 <vprintfmt+0xd0>
   113b8:	00100793          	li	a5,1
   113bc:	f8f400a3          	sb	a5,-127(s0)
   113c0:	6f40006f          	j	11ab4 <vprintfmt+0x7c0>
   113c4:	f5043783          	ld	a5,-176(s0)
   113c8:	0007c783          	lbu	a5,0(a5)
   113cc:	00078713          	mv	a4,a5
   113d0:	02b00793          	li	a5,43
   113d4:	00f71863          	bne	a4,a5,113e4 <vprintfmt+0xf0>
   113d8:	00100793          	li	a5,1
   113dc:	f8f402a3          	sb	a5,-123(s0)
   113e0:	6d40006f          	j	11ab4 <vprintfmt+0x7c0>
   113e4:	f5043783          	ld	a5,-176(s0)
   113e8:	0007c783          	lbu	a5,0(a5)
   113ec:	00078713          	mv	a4,a5
   113f0:	02000793          	li	a5,32
   113f4:	00f71863          	bne	a4,a5,11404 <vprintfmt+0x110>
   113f8:	00100793          	li	a5,1
   113fc:	f8f40223          	sb	a5,-124(s0)
   11400:	6b40006f          	j	11ab4 <vprintfmt+0x7c0>
   11404:	f5043783          	ld	a5,-176(s0)
   11408:	0007c783          	lbu	a5,0(a5)
   1140c:	00078713          	mv	a4,a5
   11410:	02a00793          	li	a5,42
   11414:	00f71e63          	bne	a4,a5,11430 <vprintfmt+0x13c>
   11418:	f4843783          	ld	a5,-184(s0)
   1141c:	00878713          	addi	a4,a5,8
   11420:	f4e43423          	sd	a4,-184(s0)
   11424:	0007a783          	lw	a5,0(a5)
   11428:	f8f42423          	sw	a5,-120(s0)
   1142c:	6880006f          	j	11ab4 <vprintfmt+0x7c0>
   11430:	f5043783          	ld	a5,-176(s0)
   11434:	0007c783          	lbu	a5,0(a5)
   11438:	00078713          	mv	a4,a5
   1143c:	03000793          	li	a5,48
   11440:	04e7f663          	bgeu	a5,a4,1148c <vprintfmt+0x198>
   11444:	f5043783          	ld	a5,-176(s0)
   11448:	0007c783          	lbu	a5,0(a5)
   1144c:	00078713          	mv	a4,a5
   11450:	03900793          	li	a5,57
   11454:	02e7ec63          	bltu	a5,a4,1148c <vprintfmt+0x198>
   11458:	f5043783          	ld	a5,-176(s0)
   1145c:	f5040713          	addi	a4,s0,-176
   11460:	00a00613          	li	a2,10
   11464:	00070593          	mv	a1,a4
   11468:	00078513          	mv	a0,a5
   1146c:	88dff0ef          	jal	ra,10cf8 <strtol>
   11470:	00050793          	mv	a5,a0
   11474:	0007879b          	sext.w	a5,a5
   11478:	f8f42423          	sw	a5,-120(s0)
   1147c:	f5043783          	ld	a5,-176(s0)
   11480:	fff78793          	addi	a5,a5,-1
   11484:	f4f43823          	sd	a5,-176(s0)
   11488:	62c0006f          	j	11ab4 <vprintfmt+0x7c0>
   1148c:	f5043783          	ld	a5,-176(s0)
   11490:	0007c783          	lbu	a5,0(a5)
   11494:	00078713          	mv	a4,a5
   11498:	02e00793          	li	a5,46
   1149c:	06f71863          	bne	a4,a5,1150c <vprintfmt+0x218>
   114a0:	f5043783          	ld	a5,-176(s0)
   114a4:	00178793          	addi	a5,a5,1
   114a8:	f4f43823          	sd	a5,-176(s0)
   114ac:	f5043783          	ld	a5,-176(s0)
   114b0:	0007c783          	lbu	a5,0(a5)
   114b4:	00078713          	mv	a4,a5
   114b8:	02a00793          	li	a5,42
   114bc:	00f71e63          	bne	a4,a5,114d8 <vprintfmt+0x1e4>
   114c0:	f4843783          	ld	a5,-184(s0)
   114c4:	00878713          	addi	a4,a5,8
   114c8:	f4e43423          	sd	a4,-184(s0)
   114cc:	0007a783          	lw	a5,0(a5)
   114d0:	f8f42623          	sw	a5,-116(s0)
   114d4:	5e00006f          	j	11ab4 <vprintfmt+0x7c0>
   114d8:	f5043783          	ld	a5,-176(s0)
   114dc:	f5040713          	addi	a4,s0,-176
   114e0:	00a00613          	li	a2,10
   114e4:	00070593          	mv	a1,a4
   114e8:	00078513          	mv	a0,a5
   114ec:	80dff0ef          	jal	ra,10cf8 <strtol>
   114f0:	00050793          	mv	a5,a0
   114f4:	0007879b          	sext.w	a5,a5
   114f8:	f8f42623          	sw	a5,-116(s0)
   114fc:	f5043783          	ld	a5,-176(s0)
   11500:	fff78793          	addi	a5,a5,-1
   11504:	f4f43823          	sd	a5,-176(s0)
   11508:	5ac0006f          	j	11ab4 <vprintfmt+0x7c0>
   1150c:	f5043783          	ld	a5,-176(s0)
   11510:	0007c783          	lbu	a5,0(a5)
   11514:	00078713          	mv	a4,a5
   11518:	07800793          	li	a5,120
   1151c:	02f70663          	beq	a4,a5,11548 <vprintfmt+0x254>
   11520:	f5043783          	ld	a5,-176(s0)
   11524:	0007c783          	lbu	a5,0(a5)
   11528:	00078713          	mv	a4,a5
   1152c:	05800793          	li	a5,88
   11530:	00f70c63          	beq	a4,a5,11548 <vprintfmt+0x254>
   11534:	f5043783          	ld	a5,-176(s0)
   11538:	0007c783          	lbu	a5,0(a5)
   1153c:	00078713          	mv	a4,a5
   11540:	07000793          	li	a5,112
   11544:	30f71263          	bne	a4,a5,11848 <vprintfmt+0x554>
   11548:	f5043783          	ld	a5,-176(s0)
   1154c:	0007c783          	lbu	a5,0(a5)
   11550:	00078713          	mv	a4,a5
   11554:	07000793          	li	a5,112
   11558:	00f70663          	beq	a4,a5,11564 <vprintfmt+0x270>
   1155c:	f8144783          	lbu	a5,-127(s0)
   11560:	00078663          	beqz	a5,1156c <vprintfmt+0x278>
   11564:	00100793          	li	a5,1
   11568:	0080006f          	j	11570 <vprintfmt+0x27c>
   1156c:	00000793          	li	a5,0
   11570:	faf403a3          	sb	a5,-89(s0)
   11574:	fa744783          	lbu	a5,-89(s0)
   11578:	0017f793          	andi	a5,a5,1
   1157c:	faf403a3          	sb	a5,-89(s0)
   11580:	fa744783          	lbu	a5,-89(s0)
   11584:	0ff7f793          	zext.b	a5,a5
   11588:	00078c63          	beqz	a5,115a0 <vprintfmt+0x2ac>
   1158c:	f4843783          	ld	a5,-184(s0)
   11590:	00878713          	addi	a4,a5,8
   11594:	f4e43423          	sd	a4,-184(s0)
   11598:	0007b783          	ld	a5,0(a5)
   1159c:	01c0006f          	j	115b8 <vprintfmt+0x2c4>
   115a0:	f4843783          	ld	a5,-184(s0)
   115a4:	00878713          	addi	a4,a5,8
   115a8:	f4e43423          	sd	a4,-184(s0)
   115ac:	0007a783          	lw	a5,0(a5)
   115b0:	02079793          	slli	a5,a5,0x20
   115b4:	0207d793          	srli	a5,a5,0x20
   115b8:	fef43023          	sd	a5,-32(s0)
   115bc:	f8c42783          	lw	a5,-116(s0)
   115c0:	02079463          	bnez	a5,115e8 <vprintfmt+0x2f4>
   115c4:	fe043783          	ld	a5,-32(s0)
   115c8:	02079063          	bnez	a5,115e8 <vprintfmt+0x2f4>
   115cc:	f5043783          	ld	a5,-176(s0)
   115d0:	0007c783          	lbu	a5,0(a5)
   115d4:	00078713          	mv	a4,a5
   115d8:	07000793          	li	a5,112
   115dc:	00f70663          	beq	a4,a5,115e8 <vprintfmt+0x2f4>
   115e0:	f8040023          	sb	zero,-128(s0)
   115e4:	4d00006f          	j	11ab4 <vprintfmt+0x7c0>
   115e8:	f5043783          	ld	a5,-176(s0)
   115ec:	0007c783          	lbu	a5,0(a5)
   115f0:	00078713          	mv	a4,a5
   115f4:	07000793          	li	a5,112
   115f8:	00f70a63          	beq	a4,a5,1160c <vprintfmt+0x318>
   115fc:	f8244783          	lbu	a5,-126(s0)
   11600:	00078a63          	beqz	a5,11614 <vprintfmt+0x320>
   11604:	fe043783          	ld	a5,-32(s0)
   11608:	00078663          	beqz	a5,11614 <vprintfmt+0x320>
   1160c:	00100793          	li	a5,1
   11610:	0080006f          	j	11618 <vprintfmt+0x324>
   11614:	00000793          	li	a5,0
   11618:	faf40323          	sb	a5,-90(s0)
   1161c:	fa644783          	lbu	a5,-90(s0)
   11620:	0017f793          	andi	a5,a5,1
   11624:	faf40323          	sb	a5,-90(s0)
   11628:	fc042e23          	sw	zero,-36(s0)
   1162c:	f5043783          	ld	a5,-176(s0)
   11630:	0007c783          	lbu	a5,0(a5)
   11634:	00078713          	mv	a4,a5
   11638:	05800793          	li	a5,88
   1163c:	00f71863          	bne	a4,a5,1164c <vprintfmt+0x358>
   11640:	00001797          	auipc	a5,0x1
   11644:	9d878793          	addi	a5,a5,-1576 # 12018 <upperxdigits.1>
   11648:	00c0006f          	j	11654 <vprintfmt+0x360>
   1164c:	00001797          	auipc	a5,0x1
   11650:	9e478793          	addi	a5,a5,-1564 # 12030 <lowerxdigits.0>
   11654:	f8f43c23          	sd	a5,-104(s0)
   11658:	fe043783          	ld	a5,-32(s0)
   1165c:	00f7f793          	andi	a5,a5,15
   11660:	f9843703          	ld	a4,-104(s0)
   11664:	00f70733          	add	a4,a4,a5
   11668:	fdc42783          	lw	a5,-36(s0)
   1166c:	0017869b          	addiw	a3,a5,1
   11670:	fcd42e23          	sw	a3,-36(s0)
   11674:	00074703          	lbu	a4,0(a4)
   11678:	ff078793          	addi	a5,a5,-16
   1167c:	008787b3          	add	a5,a5,s0
   11680:	f8e78023          	sb	a4,-128(a5)
   11684:	fe043783          	ld	a5,-32(s0)
   11688:	0047d793          	srli	a5,a5,0x4
   1168c:	fef43023          	sd	a5,-32(s0)
   11690:	fe043783          	ld	a5,-32(s0)
   11694:	fc0792e3          	bnez	a5,11658 <vprintfmt+0x364>
   11698:	f8c42783          	lw	a5,-116(s0)
   1169c:	00078713          	mv	a4,a5
   116a0:	fff00793          	li	a5,-1
   116a4:	02f71663          	bne	a4,a5,116d0 <vprintfmt+0x3dc>
   116a8:	f8344783          	lbu	a5,-125(s0)
   116ac:	02078263          	beqz	a5,116d0 <vprintfmt+0x3dc>
   116b0:	f8842703          	lw	a4,-120(s0)
   116b4:	fa644783          	lbu	a5,-90(s0)
   116b8:	0007879b          	sext.w	a5,a5
   116bc:	0017979b          	slliw	a5,a5,0x1
   116c0:	0007879b          	sext.w	a5,a5
   116c4:	40f707bb          	subw	a5,a4,a5
   116c8:	0007879b          	sext.w	a5,a5
   116cc:	f8f42623          	sw	a5,-116(s0)
   116d0:	f8842703          	lw	a4,-120(s0)
   116d4:	fa644783          	lbu	a5,-90(s0)
   116d8:	0007879b          	sext.w	a5,a5
   116dc:	0017979b          	slliw	a5,a5,0x1
   116e0:	0007879b          	sext.w	a5,a5
   116e4:	40f707bb          	subw	a5,a4,a5
   116e8:	0007871b          	sext.w	a4,a5
   116ec:	fdc42783          	lw	a5,-36(s0)
   116f0:	f8f42a23          	sw	a5,-108(s0)
   116f4:	f8c42783          	lw	a5,-116(s0)
   116f8:	f8f42823          	sw	a5,-112(s0)
   116fc:	f9442783          	lw	a5,-108(s0)
   11700:	00078593          	mv	a1,a5
   11704:	f9042783          	lw	a5,-112(s0)
   11708:	00078613          	mv	a2,a5
   1170c:	0006069b          	sext.w	a3,a2
   11710:	0005879b          	sext.w	a5,a1
   11714:	00f6d463          	bge	a3,a5,1171c <vprintfmt+0x428>
   11718:	00058613          	mv	a2,a1
   1171c:	0006079b          	sext.w	a5,a2
   11720:	40f707bb          	subw	a5,a4,a5
   11724:	fcf42c23          	sw	a5,-40(s0)
   11728:	0280006f          	j	11750 <vprintfmt+0x45c>
   1172c:	f5843783          	ld	a5,-168(s0)
   11730:	02000513          	li	a0,32
   11734:	000780e7          	jalr	a5
   11738:	fec42783          	lw	a5,-20(s0)
   1173c:	0017879b          	addiw	a5,a5,1
   11740:	fef42623          	sw	a5,-20(s0)
   11744:	fd842783          	lw	a5,-40(s0)
   11748:	fff7879b          	addiw	a5,a5,-1
   1174c:	fcf42c23          	sw	a5,-40(s0)
   11750:	fd842783          	lw	a5,-40(s0)
   11754:	0007879b          	sext.w	a5,a5
   11758:	fcf04ae3          	bgtz	a5,1172c <vprintfmt+0x438>
   1175c:	fa644783          	lbu	a5,-90(s0)
   11760:	0ff7f793          	zext.b	a5,a5
   11764:	04078463          	beqz	a5,117ac <vprintfmt+0x4b8>
   11768:	f5843783          	ld	a5,-168(s0)
   1176c:	03000513          	li	a0,48
   11770:	000780e7          	jalr	a5
   11774:	f5043783          	ld	a5,-176(s0)
   11778:	0007c783          	lbu	a5,0(a5)
   1177c:	00078713          	mv	a4,a5
   11780:	05800793          	li	a5,88
   11784:	00f71663          	bne	a4,a5,11790 <vprintfmt+0x49c>
   11788:	05800793          	li	a5,88
   1178c:	0080006f          	j	11794 <vprintfmt+0x4a0>
   11790:	07800793          	li	a5,120
   11794:	f5843703          	ld	a4,-168(s0)
   11798:	00078513          	mv	a0,a5
   1179c:	000700e7          	jalr	a4
   117a0:	fec42783          	lw	a5,-20(s0)
   117a4:	0027879b          	addiw	a5,a5,2
   117a8:	fef42623          	sw	a5,-20(s0)
   117ac:	fdc42783          	lw	a5,-36(s0)
   117b0:	fcf42a23          	sw	a5,-44(s0)
   117b4:	0280006f          	j	117dc <vprintfmt+0x4e8>
   117b8:	f5843783          	ld	a5,-168(s0)
   117bc:	03000513          	li	a0,48
   117c0:	000780e7          	jalr	a5
   117c4:	fec42783          	lw	a5,-20(s0)
   117c8:	0017879b          	addiw	a5,a5,1
   117cc:	fef42623          	sw	a5,-20(s0)
   117d0:	fd442783          	lw	a5,-44(s0)
   117d4:	0017879b          	addiw	a5,a5,1
   117d8:	fcf42a23          	sw	a5,-44(s0)
   117dc:	f8c42703          	lw	a4,-116(s0)
   117e0:	fd442783          	lw	a5,-44(s0)
   117e4:	0007879b          	sext.w	a5,a5
   117e8:	fce7c8e3          	blt	a5,a4,117b8 <vprintfmt+0x4c4>
   117ec:	fdc42783          	lw	a5,-36(s0)
   117f0:	fff7879b          	addiw	a5,a5,-1
   117f4:	fcf42823          	sw	a5,-48(s0)
   117f8:	03c0006f          	j	11834 <vprintfmt+0x540>
   117fc:	fd042783          	lw	a5,-48(s0)
   11800:	ff078793          	addi	a5,a5,-16
   11804:	008787b3          	add	a5,a5,s0
   11808:	f807c783          	lbu	a5,-128(a5)
   1180c:	0007871b          	sext.w	a4,a5
   11810:	f5843783          	ld	a5,-168(s0)
   11814:	00070513          	mv	a0,a4
   11818:	000780e7          	jalr	a5
   1181c:	fec42783          	lw	a5,-20(s0)
   11820:	0017879b          	addiw	a5,a5,1
   11824:	fef42623          	sw	a5,-20(s0)
   11828:	fd042783          	lw	a5,-48(s0)
   1182c:	fff7879b          	addiw	a5,a5,-1
   11830:	fcf42823          	sw	a5,-48(s0)
   11834:	fd042783          	lw	a5,-48(s0)
   11838:	0007879b          	sext.w	a5,a5
   1183c:	fc07d0e3          	bgez	a5,117fc <vprintfmt+0x508>
   11840:	f8040023          	sb	zero,-128(s0)
   11844:	2700006f          	j	11ab4 <vprintfmt+0x7c0>
   11848:	f5043783          	ld	a5,-176(s0)
   1184c:	0007c783          	lbu	a5,0(a5)
   11850:	00078713          	mv	a4,a5
   11854:	06400793          	li	a5,100
   11858:	02f70663          	beq	a4,a5,11884 <vprintfmt+0x590>
   1185c:	f5043783          	ld	a5,-176(s0)
   11860:	0007c783          	lbu	a5,0(a5)
   11864:	00078713          	mv	a4,a5
   11868:	06900793          	li	a5,105
   1186c:	00f70c63          	beq	a4,a5,11884 <vprintfmt+0x590>
   11870:	f5043783          	ld	a5,-176(s0)
   11874:	0007c783          	lbu	a5,0(a5)
   11878:	00078713          	mv	a4,a5
   1187c:	07500793          	li	a5,117
   11880:	08f71063          	bne	a4,a5,11900 <vprintfmt+0x60c>
   11884:	f8144783          	lbu	a5,-127(s0)
   11888:	00078c63          	beqz	a5,118a0 <vprintfmt+0x5ac>
   1188c:	f4843783          	ld	a5,-184(s0)
   11890:	00878713          	addi	a4,a5,8
   11894:	f4e43423          	sd	a4,-184(s0)
   11898:	0007b783          	ld	a5,0(a5)
   1189c:	0140006f          	j	118b0 <vprintfmt+0x5bc>
   118a0:	f4843783          	ld	a5,-184(s0)
   118a4:	00878713          	addi	a4,a5,8
   118a8:	f4e43423          	sd	a4,-184(s0)
   118ac:	0007a783          	lw	a5,0(a5)
   118b0:	faf43423          	sd	a5,-88(s0)
   118b4:	fa843583          	ld	a1,-88(s0)
   118b8:	f5043783          	ld	a5,-176(s0)
   118bc:	0007c783          	lbu	a5,0(a5)
   118c0:	0007871b          	sext.w	a4,a5
   118c4:	07500793          	li	a5,117
   118c8:	40f707b3          	sub	a5,a4,a5
   118cc:	00f037b3          	snez	a5,a5
   118d0:	0ff7f793          	zext.b	a5,a5
   118d4:	f8040713          	addi	a4,s0,-128
   118d8:	00070693          	mv	a3,a4
   118dc:	00078613          	mv	a2,a5
   118e0:	f5843503          	ld	a0,-168(s0)
   118e4:	f08ff0ef          	jal	ra,10fec <print_dec_int>
   118e8:	00050793          	mv	a5,a0
   118ec:	fec42703          	lw	a4,-20(s0)
   118f0:	00f707bb          	addw	a5,a4,a5
   118f4:	fef42623          	sw	a5,-20(s0)
   118f8:	f8040023          	sb	zero,-128(s0)
   118fc:	1b80006f          	j	11ab4 <vprintfmt+0x7c0>
   11900:	f5043783          	ld	a5,-176(s0)
   11904:	0007c783          	lbu	a5,0(a5)
   11908:	00078713          	mv	a4,a5
   1190c:	06e00793          	li	a5,110
   11910:	04f71c63          	bne	a4,a5,11968 <vprintfmt+0x674>
   11914:	f8144783          	lbu	a5,-127(s0)
   11918:	02078463          	beqz	a5,11940 <vprintfmt+0x64c>
   1191c:	f4843783          	ld	a5,-184(s0)
   11920:	00878713          	addi	a4,a5,8
   11924:	f4e43423          	sd	a4,-184(s0)
   11928:	0007b783          	ld	a5,0(a5)
   1192c:	faf43823          	sd	a5,-80(s0)
   11930:	fec42703          	lw	a4,-20(s0)
   11934:	fb043783          	ld	a5,-80(s0)
   11938:	00e7b023          	sd	a4,0(a5)
   1193c:	0240006f          	j	11960 <vprintfmt+0x66c>
   11940:	f4843783          	ld	a5,-184(s0)
   11944:	00878713          	addi	a4,a5,8
   11948:	f4e43423          	sd	a4,-184(s0)
   1194c:	0007b783          	ld	a5,0(a5)
   11950:	faf43c23          	sd	a5,-72(s0)
   11954:	fb843783          	ld	a5,-72(s0)
   11958:	fec42703          	lw	a4,-20(s0)
   1195c:	00e7a023          	sw	a4,0(a5)
   11960:	f8040023          	sb	zero,-128(s0)
   11964:	1500006f          	j	11ab4 <vprintfmt+0x7c0>
   11968:	f5043783          	ld	a5,-176(s0)
   1196c:	0007c783          	lbu	a5,0(a5)
   11970:	00078713          	mv	a4,a5
   11974:	07300793          	li	a5,115
   11978:	02f71e63          	bne	a4,a5,119b4 <vprintfmt+0x6c0>
   1197c:	f4843783          	ld	a5,-184(s0)
   11980:	00878713          	addi	a4,a5,8
   11984:	f4e43423          	sd	a4,-184(s0)
   11988:	0007b783          	ld	a5,0(a5)
   1198c:	fcf43023          	sd	a5,-64(s0)
   11990:	fc043583          	ld	a1,-64(s0)
   11994:	f5843503          	ld	a0,-168(s0)
   11998:	dccff0ef          	jal	ra,10f64 <puts_wo_nl>
   1199c:	00050793          	mv	a5,a0
   119a0:	fec42703          	lw	a4,-20(s0)
   119a4:	00f707bb          	addw	a5,a4,a5
   119a8:	fef42623          	sw	a5,-20(s0)
   119ac:	f8040023          	sb	zero,-128(s0)
   119b0:	1040006f          	j	11ab4 <vprintfmt+0x7c0>
   119b4:	f5043783          	ld	a5,-176(s0)
   119b8:	0007c783          	lbu	a5,0(a5)
   119bc:	00078713          	mv	a4,a5
   119c0:	06300793          	li	a5,99
   119c4:	02f71e63          	bne	a4,a5,11a00 <vprintfmt+0x70c>
   119c8:	f4843783          	ld	a5,-184(s0)
   119cc:	00878713          	addi	a4,a5,8
   119d0:	f4e43423          	sd	a4,-184(s0)
   119d4:	0007a783          	lw	a5,0(a5)
   119d8:	fcf42623          	sw	a5,-52(s0)
   119dc:	fcc42703          	lw	a4,-52(s0)
   119e0:	f5843783          	ld	a5,-168(s0)
   119e4:	00070513          	mv	a0,a4
   119e8:	000780e7          	jalr	a5
   119ec:	fec42783          	lw	a5,-20(s0)
   119f0:	0017879b          	addiw	a5,a5,1
   119f4:	fef42623          	sw	a5,-20(s0)
   119f8:	f8040023          	sb	zero,-128(s0)
   119fc:	0b80006f          	j	11ab4 <vprintfmt+0x7c0>
   11a00:	f5043783          	ld	a5,-176(s0)
   11a04:	0007c783          	lbu	a5,0(a5)
   11a08:	00078713          	mv	a4,a5
   11a0c:	02500793          	li	a5,37
   11a10:	02f71263          	bne	a4,a5,11a34 <vprintfmt+0x740>
   11a14:	f5843783          	ld	a5,-168(s0)
   11a18:	02500513          	li	a0,37
   11a1c:	000780e7          	jalr	a5
   11a20:	fec42783          	lw	a5,-20(s0)
   11a24:	0017879b          	addiw	a5,a5,1
   11a28:	fef42623          	sw	a5,-20(s0)
   11a2c:	f8040023          	sb	zero,-128(s0)
   11a30:	0840006f          	j	11ab4 <vprintfmt+0x7c0>
   11a34:	f5043783          	ld	a5,-176(s0)
   11a38:	0007c783          	lbu	a5,0(a5)
   11a3c:	0007871b          	sext.w	a4,a5
   11a40:	f5843783          	ld	a5,-168(s0)
   11a44:	00070513          	mv	a0,a4
   11a48:	000780e7          	jalr	a5
   11a4c:	fec42783          	lw	a5,-20(s0)
   11a50:	0017879b          	addiw	a5,a5,1
   11a54:	fef42623          	sw	a5,-20(s0)
   11a58:	f8040023          	sb	zero,-128(s0)
   11a5c:	0580006f          	j	11ab4 <vprintfmt+0x7c0>
   11a60:	f5043783          	ld	a5,-176(s0)
   11a64:	0007c783          	lbu	a5,0(a5)
   11a68:	00078713          	mv	a4,a5
   11a6c:	02500793          	li	a5,37
   11a70:	02f71063          	bne	a4,a5,11a90 <vprintfmt+0x79c>
   11a74:	f8043023          	sd	zero,-128(s0)
   11a78:	f8043423          	sd	zero,-120(s0)
   11a7c:	00100793          	li	a5,1
   11a80:	f8f40023          	sb	a5,-128(s0)
   11a84:	fff00793          	li	a5,-1
   11a88:	f8f42623          	sw	a5,-116(s0)
   11a8c:	0280006f          	j	11ab4 <vprintfmt+0x7c0>
   11a90:	f5043783          	ld	a5,-176(s0)
   11a94:	0007c783          	lbu	a5,0(a5)
   11a98:	0007871b          	sext.w	a4,a5
   11a9c:	f5843783          	ld	a5,-168(s0)
   11aa0:	00070513          	mv	a0,a4
   11aa4:	000780e7          	jalr	a5
   11aa8:	fec42783          	lw	a5,-20(s0)
   11aac:	0017879b          	addiw	a5,a5,1
   11ab0:	fef42623          	sw	a5,-20(s0)
   11ab4:	f5043783          	ld	a5,-176(s0)
   11ab8:	00178793          	addi	a5,a5,1
   11abc:	f4f43823          	sd	a5,-176(s0)
   11ac0:	f5043783          	ld	a5,-176(s0)
   11ac4:	0007c783          	lbu	a5,0(a5)
   11ac8:	84079ce3          	bnez	a5,11320 <vprintfmt+0x2c>
   11acc:	fec42783          	lw	a5,-20(s0)
   11ad0:	00078513          	mv	a0,a5
   11ad4:	0b813083          	ld	ra,184(sp)
   11ad8:	0b013403          	ld	s0,176(sp)
   11adc:	0c010113          	addi	sp,sp,192
   11ae0:	00008067          	ret

0000000000011ae4 <printf>:
   11ae4:	f8010113          	addi	sp,sp,-128
   11ae8:	02113c23          	sd	ra,56(sp)
   11aec:	02813823          	sd	s0,48(sp)
   11af0:	04010413          	addi	s0,sp,64
   11af4:	fca43423          	sd	a0,-56(s0)
   11af8:	00b43423          	sd	a1,8(s0)
   11afc:	00c43823          	sd	a2,16(s0)
   11b00:	00d43c23          	sd	a3,24(s0)
   11b04:	02e43023          	sd	a4,32(s0)
   11b08:	02f43423          	sd	a5,40(s0)
   11b0c:	03043823          	sd	a6,48(s0)
   11b10:	03143c23          	sd	a7,56(s0)
   11b14:	fe042623          	sw	zero,-20(s0)
   11b18:	04040793          	addi	a5,s0,64
   11b1c:	fcf43023          	sd	a5,-64(s0)
   11b20:	fc043783          	ld	a5,-64(s0)
   11b24:	fc878793          	addi	a5,a5,-56
   11b28:	fcf43823          	sd	a5,-48(s0)
   11b2c:	fd043783          	ld	a5,-48(s0)
   11b30:	00078613          	mv	a2,a5
   11b34:	fc843583          	ld	a1,-56(s0)
   11b38:	fffff517          	auipc	a0,0xfffff
   11b3c:	0f850513          	addi	a0,a0,248 # 10c30 <putc>
   11b40:	fb4ff0ef          	jal	ra,112f4 <vprintfmt>
   11b44:	00050793          	mv	a5,a0
   11b48:	fef42623          	sw	a5,-20(s0)
   11b4c:	00100793          	li	a5,1
   11b50:	fef43023          	sd	a5,-32(s0)
   11b54:	00002797          	auipc	a5,0x2
   11b58:	4f478793          	addi	a5,a5,1268 # 14048 <tail>
   11b5c:	0007a783          	lw	a5,0(a5)
   11b60:	0017871b          	addiw	a4,a5,1
   11b64:	0007069b          	sext.w	a3,a4
   11b68:	00002717          	auipc	a4,0x2
   11b6c:	4e070713          	addi	a4,a4,1248 # 14048 <tail>
   11b70:	00d72023          	sw	a3,0(a4)
   11b74:	00002717          	auipc	a4,0x2
   11b78:	4dc70713          	addi	a4,a4,1244 # 14050 <buffer>
   11b7c:	00f707b3          	add	a5,a4,a5
   11b80:	00078023          	sb	zero,0(a5)
   11b84:	00002797          	auipc	a5,0x2
   11b88:	4c478793          	addi	a5,a5,1220 # 14048 <tail>
   11b8c:	0007a603          	lw	a2,0(a5)
   11b90:	fe043703          	ld	a4,-32(s0)
   11b94:	00002697          	auipc	a3,0x2
   11b98:	4bc68693          	addi	a3,a3,1212 # 14050 <buffer>
   11b9c:	fd843783          	ld	a5,-40(s0)
   11ba0:	04000893          	li	a7,64
   11ba4:	00070513          	mv	a0,a4
   11ba8:	00068593          	mv	a1,a3
   11bac:	00060613          	mv	a2,a2
   11bb0:	00000073          	ecall
   11bb4:	00050793          	mv	a5,a0
   11bb8:	fcf43c23          	sd	a5,-40(s0)
   11bbc:	00002797          	auipc	a5,0x2
   11bc0:	48c78793          	addi	a5,a5,1164 # 14048 <tail>
   11bc4:	0007a023          	sw	zero,0(a5)
   11bc8:	fec42783          	lw	a5,-20(s0)
   11bcc:	00078513          	mv	a0,a5
   11bd0:	03813083          	ld	ra,56(sp)
   11bd4:	03013403          	ld	s0,48(sp)
   11bd8:	08010113          	addi	sp,sp,128
   11bdc:	00008067          	ret

0000000000011be0 <strlen>:
   11be0:	fd010113          	addi	sp,sp,-48
   11be4:	02813423          	sd	s0,40(sp)
   11be8:	03010413          	addi	s0,sp,48
   11bec:	fca43c23          	sd	a0,-40(s0)
   11bf0:	fe042623          	sw	zero,-20(s0)
   11bf4:	0100006f          	j	11c04 <strlen+0x24>
   11bf8:	fec42783          	lw	a5,-20(s0)
   11bfc:	0017879b          	addiw	a5,a5,1
   11c00:	fef42623          	sw	a5,-20(s0)
   11c04:	fd843783          	ld	a5,-40(s0)
   11c08:	00178713          	addi	a4,a5,1
   11c0c:	fce43c23          	sd	a4,-40(s0)
   11c10:	0007c783          	lbu	a5,0(a5)
   11c14:	fe0792e3          	bnez	a5,11bf8 <strlen+0x18>
   11c18:	fec42783          	lw	a5,-20(s0)
   11c1c:	00078513          	mv	a0,a5
   11c20:	02813403          	ld	s0,40(sp)
   11c24:	03010113          	addi	sp,sp,48
   11c28:	00008067          	ret

0000000000011c2c <write>:
   11c2c:	fb010113          	addi	sp,sp,-80
   11c30:	04813423          	sd	s0,72(sp)
   11c34:	05010413          	addi	s0,sp,80
   11c38:	00050693          	mv	a3,a0
   11c3c:	fcb43023          	sd	a1,-64(s0)
   11c40:	fac43c23          	sd	a2,-72(s0)
   11c44:	fcd42623          	sw	a3,-52(s0)
   11c48:	00010693          	mv	a3,sp
   11c4c:	00068593          	mv	a1,a3
   11c50:	fb843683          	ld	a3,-72(s0)
   11c54:	00168693          	addi	a3,a3,1
   11c58:	00068613          	mv	a2,a3
   11c5c:	fff60613          	addi	a2,a2,-1
   11c60:	fec43023          	sd	a2,-32(s0)
   11c64:	00068e13          	mv	t3,a3
   11c68:	00000e93          	li	t4,0
   11c6c:	03de5613          	srli	a2,t3,0x3d
   11c70:	003e9893          	slli	a7,t4,0x3
   11c74:	011668b3          	or	a7,a2,a7
   11c78:	003e1813          	slli	a6,t3,0x3
   11c7c:	00068313          	mv	t1,a3
   11c80:	00000393          	li	t2,0
   11c84:	03d35613          	srli	a2,t1,0x3d
   11c88:	00339793          	slli	a5,t2,0x3
   11c8c:	00f667b3          	or	a5,a2,a5
   11c90:	00331713          	slli	a4,t1,0x3
   11c94:	00f68793          	addi	a5,a3,15
   11c98:	0047d793          	srli	a5,a5,0x4
   11c9c:	00479793          	slli	a5,a5,0x4
   11ca0:	40f10133          	sub	sp,sp,a5
   11ca4:	00010793          	mv	a5,sp
   11ca8:	00078793          	mv	a5,a5
   11cac:	fcf43c23          	sd	a5,-40(s0)
   11cb0:	fe042623          	sw	zero,-20(s0)
   11cb4:	0300006f          	j	11ce4 <write+0xb8>
   11cb8:	fec42783          	lw	a5,-20(s0)
   11cbc:	fc043703          	ld	a4,-64(s0)
   11cc0:	00f707b3          	add	a5,a4,a5
   11cc4:	0007c703          	lbu	a4,0(a5)
   11cc8:	fd843683          	ld	a3,-40(s0)
   11ccc:	fec42783          	lw	a5,-20(s0)
   11cd0:	00f687b3          	add	a5,a3,a5
   11cd4:	00e78023          	sb	a4,0(a5)
   11cd8:	fec42783          	lw	a5,-20(s0)
   11cdc:	0017879b          	addiw	a5,a5,1
   11ce0:	fef42623          	sw	a5,-20(s0)
   11ce4:	fec42783          	lw	a5,-20(s0)
   11ce8:	fb843703          	ld	a4,-72(s0)
   11cec:	fce7e6e3          	bltu	a5,a4,11cb8 <write+0x8c>
   11cf0:	fd843703          	ld	a4,-40(s0)
   11cf4:	fb843783          	ld	a5,-72(s0)
   11cf8:	00f707b3          	add	a5,a4,a5
   11cfc:	00078023          	sb	zero,0(a5)
   11d00:	fcc42703          	lw	a4,-52(s0)
   11d04:	fd843683          	ld	a3,-40(s0)
   11d08:	fb843603          	ld	a2,-72(s0)
   11d0c:	fd043783          	ld	a5,-48(s0)
   11d10:	04000893          	li	a7,64
   11d14:	00070513          	mv	a0,a4
   11d18:	00068593          	mv	a1,a3
   11d1c:	00060613          	mv	a2,a2
   11d20:	00000073          	ecall
   11d24:	00050793          	mv	a5,a0
   11d28:	fcf43823          	sd	a5,-48(s0)
   11d2c:	fd043783          	ld	a5,-48(s0)
   11d30:	0007879b          	sext.w	a5,a5
   11d34:	00058113          	mv	sp,a1
   11d38:	00078513          	mv	a0,a5
   11d3c:	fb040113          	addi	sp,s0,-80
   11d40:	04813403          	ld	s0,72(sp)
   11d44:	05010113          	addi	sp,sp,80
   11d48:	00008067          	ret

0000000000011d4c <read>:
   11d4c:	fc010113          	addi	sp,sp,-64
   11d50:	02813c23          	sd	s0,56(sp)
   11d54:	04010413          	addi	s0,sp,64
   11d58:	00050793          	mv	a5,a0
   11d5c:	fcb43823          	sd	a1,-48(s0)
   11d60:	fcc43423          	sd	a2,-56(s0)
   11d64:	fcf42e23          	sw	a5,-36(s0)
   11d68:	fdc42703          	lw	a4,-36(s0)
   11d6c:	fd043683          	ld	a3,-48(s0)
   11d70:	fc843603          	ld	a2,-56(s0)
   11d74:	fe843783          	ld	a5,-24(s0)
   11d78:	03f00893          	li	a7,63
   11d7c:	00070513          	mv	a0,a4
   11d80:	00068593          	mv	a1,a3
   11d84:	00060613          	mv	a2,a2
   11d88:	00000073          	ecall
   11d8c:	00050793          	mv	a5,a0
   11d90:	fef43423          	sd	a5,-24(s0)
   11d94:	fe843783          	ld	a5,-24(s0)
   11d98:	0007879b          	sext.w	a5,a5
   11d9c:	00078513          	mv	a0,a5
   11da0:	03813403          	ld	s0,56(sp)
   11da4:	04010113          	addi	sp,sp,64
   11da8:	00008067          	ret

0000000000011dac <sys_openat>:
   11dac:	fd010113          	addi	sp,sp,-48
   11db0:	02813423          	sd	s0,40(sp)
   11db4:	03010413          	addi	s0,sp,48
   11db8:	00050793          	mv	a5,a0
   11dbc:	fcb43823          	sd	a1,-48(s0)
   11dc0:	00060713          	mv	a4,a2
   11dc4:	fcf42e23          	sw	a5,-36(s0)
   11dc8:	00070793          	mv	a5,a4
   11dcc:	fcf42c23          	sw	a5,-40(s0)
   11dd0:	fdc42703          	lw	a4,-36(s0)
   11dd4:	fd842603          	lw	a2,-40(s0)
   11dd8:	fd043683          	ld	a3,-48(s0)
   11ddc:	fe843783          	ld	a5,-24(s0)
   11de0:	03800893          	li	a7,56
   11de4:	00070513          	mv	a0,a4
   11de8:	00068593          	mv	a1,a3
   11dec:	00060613          	mv	a2,a2
   11df0:	00000073          	ecall
   11df4:	00050793          	mv	a5,a0
   11df8:	fef43423          	sd	a5,-24(s0)
   11dfc:	fe843783          	ld	a5,-24(s0)
   11e00:	0007879b          	sext.w	a5,a5
   11e04:	00078513          	mv	a0,a5
   11e08:	02813403          	ld	s0,40(sp)
   11e0c:	03010113          	addi	sp,sp,48
   11e10:	00008067          	ret

0000000000011e14 <open>:
   11e14:	fe010113          	addi	sp,sp,-32
   11e18:	00113c23          	sd	ra,24(sp)
   11e1c:	00813823          	sd	s0,16(sp)
   11e20:	02010413          	addi	s0,sp,32
   11e24:	fea43423          	sd	a0,-24(s0)
   11e28:	00058793          	mv	a5,a1
   11e2c:	fef42223          	sw	a5,-28(s0)
   11e30:	fe442783          	lw	a5,-28(s0)
   11e34:	00078613          	mv	a2,a5
   11e38:	fe843583          	ld	a1,-24(s0)
   11e3c:	f9c00513          	li	a0,-100
   11e40:	f6dff0ef          	jal	ra,11dac <sys_openat>
   11e44:	00050793          	mv	a5,a0
   11e48:	00078513          	mv	a0,a5
   11e4c:	01813083          	ld	ra,24(sp)
   11e50:	01013403          	ld	s0,16(sp)
   11e54:	02010113          	addi	sp,sp,32
   11e58:	00008067          	ret

0000000000011e5c <close>:
   11e5c:	fd010113          	addi	sp,sp,-48
   11e60:	02813423          	sd	s0,40(sp)
   11e64:	03010413          	addi	s0,sp,48
   11e68:	00050793          	mv	a5,a0
   11e6c:	fcf42e23          	sw	a5,-36(s0)
   11e70:	fdc42703          	lw	a4,-36(s0)
   11e74:	fe843783          	ld	a5,-24(s0)
   11e78:	03900893          	li	a7,57
   11e7c:	00070513          	mv	a0,a4
   11e80:	00000073          	ecall
   11e84:	00050793          	mv	a5,a0
   11e88:	fef43423          	sd	a5,-24(s0)
   11e8c:	fe843783          	ld	a5,-24(s0)
   11e90:	0007879b          	sext.w	a5,a5
   11e94:	00078513          	mv	a0,a5
   11e98:	02813403          	ld	s0,40(sp)
   11e9c:	03010113          	addi	sp,sp,48
   11ea0:	00008067          	ret

0000000000011ea4 <lseek>:
   11ea4:	fd010113          	addi	sp,sp,-48
   11ea8:	02813423          	sd	s0,40(sp)
   11eac:	03010413          	addi	s0,sp,48
   11eb0:	00050793          	mv	a5,a0
   11eb4:	00058693          	mv	a3,a1
   11eb8:	00060713          	mv	a4,a2
   11ebc:	fcf42e23          	sw	a5,-36(s0)
   11ec0:	00068793          	mv	a5,a3
   11ec4:	fcf42c23          	sw	a5,-40(s0)
   11ec8:	00070793          	mv	a5,a4
   11ecc:	fcf42a23          	sw	a5,-44(s0)
   11ed0:	fdc42703          	lw	a4,-36(s0)
   11ed4:	fd842683          	lw	a3,-40(s0)
   11ed8:	fd442603          	lw	a2,-44(s0)
   11edc:	fe843783          	ld	a5,-24(s0)
   11ee0:	03e00893          	li	a7,62
   11ee4:	00070513          	mv	a0,a4
   11ee8:	00068593          	mv	a1,a3
   11eec:	00060613          	mv	a2,a2
   11ef0:	00000073          	ecall
   11ef4:	00050793          	mv	a5,a0
   11ef8:	fef43423          	sd	a5,-24(s0)
   11efc:	fe843783          	ld	a5,-24(s0)
   11f00:	0007879b          	sext.w	a5,a5
   11f04:	00078513          	mv	a0,a5
   11f08:	02813403          	ld	s0,40(sp)
   11f0c:	03010113          	addi	sp,sp,48
   11f10:	00008067          	ret
