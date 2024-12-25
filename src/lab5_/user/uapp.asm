
uapp:     file format elf64-littleriscv


Disassembly of section .text:

00000000000100e8 <_start>:
   100e8:	08c0006f          	j	10174 <main>

00000000000100ec <getpid>:
   100ec:	fe010113          	addi	sp,sp,-32
   100f0:	00813c23          	sd	s0,24(sp)
   100f4:	02010413          	addi	s0,sp,32
   100f8:	fe843783          	ld	a5,-24(s0)
   100fc:	0ac00893          	li	a7,172
   10100:	00000073          	ecall
   10104:	00050793          	mv	a5,a0
   10108:	fef43423          	sd	a5,-24(s0)
   1010c:	fe843783          	ld	a5,-24(s0)
   10110:	00078513          	mv	a0,a5
   10114:	01813403          	ld	s0,24(sp)
   10118:	02010113          	addi	sp,sp,32
   1011c:	00008067          	ret

0000000000010120 <wait>:
   10120:	fd010113          	addi	sp,sp,-48
   10124:	02813423          	sd	s0,40(sp)
   10128:	03010413          	addi	s0,sp,48
   1012c:	00050793          	mv	a5,a0
   10130:	fcf42e23          	sw	a5,-36(s0)
   10134:	fe042623          	sw	zero,-20(s0)
   10138:	0100006f          	j	10148 <wait+0x28>
   1013c:	fec42783          	lw	a5,-20(s0)
   10140:	0017879b          	addiw	a5,a5,1
   10144:	fef42623          	sw	a5,-20(s0)
   10148:	fec42783          	lw	a5,-20(s0)
   1014c:	00078713          	mv	a4,a5
   10150:	fdc42783          	lw	a5,-36(s0)
   10154:	0007071b          	sext.w	a4,a4
   10158:	0007879b          	sext.w	a5,a5
   1015c:	fef760e3          	bltu	a4,a5,1013c <wait+0x1c>
   10160:	00000013          	nop
   10164:	00000013          	nop
   10168:	02813403          	ld	s0,40(sp)
   1016c:	03010113          	addi	sp,sp,48
   10170:	00008067          	ret

0000000000010174 <main>:
   10174:	fe010113          	addi	sp,sp,-32
   10178:	00113c23          	sd	ra,24(sp)
   1017c:	00813823          	sd	s0,16(sp)
   10180:	02010413          	addi	s0,sp,32
   10184:	00000097          	auipc	ra,0x0
   10188:	f68080e7          	jalr	-152(ra) # 100ec <getpid>
   1018c:	00050593          	mv	a1,a0
   10190:	00010613          	mv	a2,sp
   10194:	00002797          	auipc	a5,0x2
   10198:	0c478793          	addi	a5,a5,196 # 12258 <counter>
   1019c:	0007a783          	lw	a5,0(a5)
   101a0:	0017879b          	addiw	a5,a5,1
   101a4:	0007871b          	sext.w	a4,a5
   101a8:	00002797          	auipc	a5,0x2
   101ac:	0b078793          	addi	a5,a5,176 # 12258 <counter>
   101b0:	00e7a023          	sw	a4,0(a5)
   101b4:	00002797          	auipc	a5,0x2
   101b8:	0a478793          	addi	a5,a5,164 # 12258 <counter>
   101bc:	0007a783          	lw	a5,0(a5)
   101c0:	00078693          	mv	a3,a5
   101c4:	00001517          	auipc	a0,0x1
   101c8:	00c50513          	addi	a0,a0,12 # 111d0 <printf+0x104>
   101cc:	00001097          	auipc	ra,0x1
   101d0:	f00080e7          	jalr	-256(ra) # 110cc <printf>
   101d4:	fe042623          	sw	zero,-20(s0)
   101d8:	0100006f          	j	101e8 <main+0x74>
   101dc:	fec42783          	lw	a5,-20(s0)
   101e0:	0017879b          	addiw	a5,a5,1
   101e4:	fef42623          	sw	a5,-20(s0)
   101e8:	fec42783          	lw	a5,-20(s0)
   101ec:	0007871b          	sext.w	a4,a5
   101f0:	500007b7          	lui	a5,0x50000
   101f4:	ffe78793          	addi	a5,a5,-2 # 4ffffffe <__global_pointer$+0x4ffed5ad>
   101f8:	fee7f2e3          	bgeu	a5,a4,101dc <main+0x68>
   101fc:	f89ff06f          	j	10184 <main+0x10>

0000000000010200 <putc>:
   10200:	fe010113          	addi	sp,sp,-32
   10204:	00813c23          	sd	s0,24(sp)
   10208:	02010413          	addi	s0,sp,32
   1020c:	00050793          	mv	a5,a0
   10210:	fef42623          	sw	a5,-20(s0)
   10214:	00002797          	auipc	a5,0x2
   10218:	04878793          	addi	a5,a5,72 # 1225c <tail>
   1021c:	0007a783          	lw	a5,0(a5)
   10220:	0017871b          	addiw	a4,a5,1
   10224:	0007069b          	sext.w	a3,a4
   10228:	00002717          	auipc	a4,0x2
   1022c:	03470713          	addi	a4,a4,52 # 1225c <tail>
   10230:	00d72023          	sw	a3,0(a4)
   10234:	fec42703          	lw	a4,-20(s0)
   10238:	0ff77713          	zext.b	a4,a4
   1023c:	00002697          	auipc	a3,0x2
   10240:	02468693          	addi	a3,a3,36 # 12260 <buffer>
   10244:	00f687b3          	add	a5,a3,a5
   10248:	00e78023          	sb	a4,0(a5)
   1024c:	fec42783          	lw	a5,-20(s0)
   10250:	0ff7f793          	zext.b	a5,a5
   10254:	0007879b          	sext.w	a5,a5
   10258:	00078513          	mv	a0,a5
   1025c:	01813403          	ld	s0,24(sp)
   10260:	02010113          	addi	sp,sp,32
   10264:	00008067          	ret

0000000000010268 <isspace>:
   10268:	fe010113          	addi	sp,sp,-32
   1026c:	00813c23          	sd	s0,24(sp)
   10270:	02010413          	addi	s0,sp,32
   10274:	00050793          	mv	a5,a0
   10278:	fef42623          	sw	a5,-20(s0)
   1027c:	fec42783          	lw	a5,-20(s0)
   10280:	0007871b          	sext.w	a4,a5
   10284:	02000793          	li	a5,32
   10288:	02f70263          	beq	a4,a5,102ac <isspace+0x44>
   1028c:	fec42783          	lw	a5,-20(s0)
   10290:	0007871b          	sext.w	a4,a5
   10294:	00800793          	li	a5,8
   10298:	00e7de63          	bge	a5,a4,102b4 <isspace+0x4c>
   1029c:	fec42783          	lw	a5,-20(s0)
   102a0:	0007871b          	sext.w	a4,a5
   102a4:	00d00793          	li	a5,13
   102a8:	00e7c663          	blt	a5,a4,102b4 <isspace+0x4c>
   102ac:	00100793          	li	a5,1
   102b0:	0080006f          	j	102b8 <isspace+0x50>
   102b4:	00000793          	li	a5,0
   102b8:	00078513          	mv	a0,a5
   102bc:	01813403          	ld	s0,24(sp)
   102c0:	02010113          	addi	sp,sp,32
   102c4:	00008067          	ret

00000000000102c8 <strtol>:
   102c8:	fb010113          	addi	sp,sp,-80
   102cc:	04113423          	sd	ra,72(sp)
   102d0:	04813023          	sd	s0,64(sp)
   102d4:	05010413          	addi	s0,sp,80
   102d8:	fca43423          	sd	a0,-56(s0)
   102dc:	fcb43023          	sd	a1,-64(s0)
   102e0:	00060793          	mv	a5,a2
   102e4:	faf42e23          	sw	a5,-68(s0)
   102e8:	fe043423          	sd	zero,-24(s0)
   102ec:	fe0403a3          	sb	zero,-25(s0)
   102f0:	fc843783          	ld	a5,-56(s0)
   102f4:	fcf43c23          	sd	a5,-40(s0)
   102f8:	0100006f          	j	10308 <strtol+0x40>
   102fc:	fd843783          	ld	a5,-40(s0)
   10300:	00178793          	addi	a5,a5,1
   10304:	fcf43c23          	sd	a5,-40(s0)
   10308:	fd843783          	ld	a5,-40(s0)
   1030c:	0007c783          	lbu	a5,0(a5)
   10310:	0007879b          	sext.w	a5,a5
   10314:	00078513          	mv	a0,a5
   10318:	00000097          	auipc	ra,0x0
   1031c:	f50080e7          	jalr	-176(ra) # 10268 <isspace>
   10320:	00050793          	mv	a5,a0
   10324:	fc079ce3          	bnez	a5,102fc <strtol+0x34>
   10328:	fd843783          	ld	a5,-40(s0)
   1032c:	0007c783          	lbu	a5,0(a5)
   10330:	00078713          	mv	a4,a5
   10334:	02d00793          	li	a5,45
   10338:	00f71e63          	bne	a4,a5,10354 <strtol+0x8c>
   1033c:	00100793          	li	a5,1
   10340:	fef403a3          	sb	a5,-25(s0)
   10344:	fd843783          	ld	a5,-40(s0)
   10348:	00178793          	addi	a5,a5,1
   1034c:	fcf43c23          	sd	a5,-40(s0)
   10350:	0240006f          	j	10374 <strtol+0xac>
   10354:	fd843783          	ld	a5,-40(s0)
   10358:	0007c783          	lbu	a5,0(a5)
   1035c:	00078713          	mv	a4,a5
   10360:	02b00793          	li	a5,43
   10364:	00f71863          	bne	a4,a5,10374 <strtol+0xac>
   10368:	fd843783          	ld	a5,-40(s0)
   1036c:	00178793          	addi	a5,a5,1
   10370:	fcf43c23          	sd	a5,-40(s0)
   10374:	fbc42783          	lw	a5,-68(s0)
   10378:	0007879b          	sext.w	a5,a5
   1037c:	06079c63          	bnez	a5,103f4 <strtol+0x12c>
   10380:	fd843783          	ld	a5,-40(s0)
   10384:	0007c783          	lbu	a5,0(a5)
   10388:	00078713          	mv	a4,a5
   1038c:	03000793          	li	a5,48
   10390:	04f71e63          	bne	a4,a5,103ec <strtol+0x124>
   10394:	fd843783          	ld	a5,-40(s0)
   10398:	00178793          	addi	a5,a5,1
   1039c:	fcf43c23          	sd	a5,-40(s0)
   103a0:	fd843783          	ld	a5,-40(s0)
   103a4:	0007c783          	lbu	a5,0(a5)
   103a8:	00078713          	mv	a4,a5
   103ac:	07800793          	li	a5,120
   103b0:	00f70c63          	beq	a4,a5,103c8 <strtol+0x100>
   103b4:	fd843783          	ld	a5,-40(s0)
   103b8:	0007c783          	lbu	a5,0(a5)
   103bc:	00078713          	mv	a4,a5
   103c0:	05800793          	li	a5,88
   103c4:	00f71e63          	bne	a4,a5,103e0 <strtol+0x118>
   103c8:	01000793          	li	a5,16
   103cc:	faf42e23          	sw	a5,-68(s0)
   103d0:	fd843783          	ld	a5,-40(s0)
   103d4:	00178793          	addi	a5,a5,1
   103d8:	fcf43c23          	sd	a5,-40(s0)
   103dc:	0180006f          	j	103f4 <strtol+0x12c>
   103e0:	00800793          	li	a5,8
   103e4:	faf42e23          	sw	a5,-68(s0)
   103e8:	00c0006f          	j	103f4 <strtol+0x12c>
   103ec:	00a00793          	li	a5,10
   103f0:	faf42e23          	sw	a5,-68(s0)
   103f4:	fd843783          	ld	a5,-40(s0)
   103f8:	0007c783          	lbu	a5,0(a5)
   103fc:	00078713          	mv	a4,a5
   10400:	02f00793          	li	a5,47
   10404:	02e7f863          	bgeu	a5,a4,10434 <strtol+0x16c>
   10408:	fd843783          	ld	a5,-40(s0)
   1040c:	0007c783          	lbu	a5,0(a5)
   10410:	00078713          	mv	a4,a5
   10414:	03900793          	li	a5,57
   10418:	00e7ee63          	bltu	a5,a4,10434 <strtol+0x16c>
   1041c:	fd843783          	ld	a5,-40(s0)
   10420:	0007c783          	lbu	a5,0(a5)
   10424:	0007879b          	sext.w	a5,a5
   10428:	fd07879b          	addiw	a5,a5,-48
   1042c:	fcf42a23          	sw	a5,-44(s0)
   10430:	0800006f          	j	104b0 <strtol+0x1e8>
   10434:	fd843783          	ld	a5,-40(s0)
   10438:	0007c783          	lbu	a5,0(a5)
   1043c:	00078713          	mv	a4,a5
   10440:	06000793          	li	a5,96
   10444:	02e7f863          	bgeu	a5,a4,10474 <strtol+0x1ac>
   10448:	fd843783          	ld	a5,-40(s0)
   1044c:	0007c783          	lbu	a5,0(a5)
   10450:	00078713          	mv	a4,a5
   10454:	07a00793          	li	a5,122
   10458:	00e7ee63          	bltu	a5,a4,10474 <strtol+0x1ac>
   1045c:	fd843783          	ld	a5,-40(s0)
   10460:	0007c783          	lbu	a5,0(a5)
   10464:	0007879b          	sext.w	a5,a5
   10468:	fa97879b          	addiw	a5,a5,-87
   1046c:	fcf42a23          	sw	a5,-44(s0)
   10470:	0400006f          	j	104b0 <strtol+0x1e8>
   10474:	fd843783          	ld	a5,-40(s0)
   10478:	0007c783          	lbu	a5,0(a5)
   1047c:	00078713          	mv	a4,a5
   10480:	04000793          	li	a5,64
   10484:	06e7f863          	bgeu	a5,a4,104f4 <strtol+0x22c>
   10488:	fd843783          	ld	a5,-40(s0)
   1048c:	0007c783          	lbu	a5,0(a5)
   10490:	00078713          	mv	a4,a5
   10494:	05a00793          	li	a5,90
   10498:	04e7ee63          	bltu	a5,a4,104f4 <strtol+0x22c>
   1049c:	fd843783          	ld	a5,-40(s0)
   104a0:	0007c783          	lbu	a5,0(a5)
   104a4:	0007879b          	sext.w	a5,a5
   104a8:	fc97879b          	addiw	a5,a5,-55
   104ac:	fcf42a23          	sw	a5,-44(s0)
   104b0:	fd442783          	lw	a5,-44(s0)
   104b4:	00078713          	mv	a4,a5
   104b8:	fbc42783          	lw	a5,-68(s0)
   104bc:	0007071b          	sext.w	a4,a4
   104c0:	0007879b          	sext.w	a5,a5
   104c4:	02f75663          	bge	a4,a5,104f0 <strtol+0x228>
   104c8:	fbc42703          	lw	a4,-68(s0)
   104cc:	fe843783          	ld	a5,-24(s0)
   104d0:	02f70733          	mul	a4,a4,a5
   104d4:	fd442783          	lw	a5,-44(s0)
   104d8:	00f707b3          	add	a5,a4,a5
   104dc:	fef43423          	sd	a5,-24(s0)
   104e0:	fd843783          	ld	a5,-40(s0)
   104e4:	00178793          	addi	a5,a5,1
   104e8:	fcf43c23          	sd	a5,-40(s0)
   104ec:	f09ff06f          	j	103f4 <strtol+0x12c>
   104f0:	00000013          	nop
   104f4:	fc043783          	ld	a5,-64(s0)
   104f8:	00078863          	beqz	a5,10508 <strtol+0x240>
   104fc:	fc043783          	ld	a5,-64(s0)
   10500:	fd843703          	ld	a4,-40(s0)
   10504:	00e7b023          	sd	a4,0(a5)
   10508:	fe744783          	lbu	a5,-25(s0)
   1050c:	0ff7f793          	zext.b	a5,a5
   10510:	00078863          	beqz	a5,10520 <strtol+0x258>
   10514:	fe843783          	ld	a5,-24(s0)
   10518:	40f007b3          	neg	a5,a5
   1051c:	0080006f          	j	10524 <strtol+0x25c>
   10520:	fe843783          	ld	a5,-24(s0)
   10524:	00078513          	mv	a0,a5
   10528:	04813083          	ld	ra,72(sp)
   1052c:	04013403          	ld	s0,64(sp)
   10530:	05010113          	addi	sp,sp,80
   10534:	00008067          	ret

0000000000010538 <puts_wo_nl>:
   10538:	fd010113          	addi	sp,sp,-48
   1053c:	02113423          	sd	ra,40(sp)
   10540:	02813023          	sd	s0,32(sp)
   10544:	03010413          	addi	s0,sp,48
   10548:	fca43c23          	sd	a0,-40(s0)
   1054c:	fcb43823          	sd	a1,-48(s0)
   10550:	fd043783          	ld	a5,-48(s0)
   10554:	00079863          	bnez	a5,10564 <puts_wo_nl+0x2c>
   10558:	00001797          	auipc	a5,0x1
   1055c:	cb078793          	addi	a5,a5,-848 # 11208 <printf+0x13c>
   10560:	fcf43823          	sd	a5,-48(s0)
   10564:	fd043783          	ld	a5,-48(s0)
   10568:	fef43423          	sd	a5,-24(s0)
   1056c:	0240006f          	j	10590 <puts_wo_nl+0x58>
   10570:	fe843783          	ld	a5,-24(s0)
   10574:	00178713          	addi	a4,a5,1
   10578:	fee43423          	sd	a4,-24(s0)
   1057c:	0007c783          	lbu	a5,0(a5)
   10580:	0007871b          	sext.w	a4,a5
   10584:	fd843783          	ld	a5,-40(s0)
   10588:	00070513          	mv	a0,a4
   1058c:	000780e7          	jalr	a5
   10590:	fe843783          	ld	a5,-24(s0)
   10594:	0007c783          	lbu	a5,0(a5)
   10598:	fc079ce3          	bnez	a5,10570 <puts_wo_nl+0x38>
   1059c:	fe843703          	ld	a4,-24(s0)
   105a0:	fd043783          	ld	a5,-48(s0)
   105a4:	40f707b3          	sub	a5,a4,a5
   105a8:	0007879b          	sext.w	a5,a5
   105ac:	00078513          	mv	a0,a5
   105b0:	02813083          	ld	ra,40(sp)
   105b4:	02013403          	ld	s0,32(sp)
   105b8:	03010113          	addi	sp,sp,48
   105bc:	00008067          	ret

00000000000105c0 <print_dec_int>:
   105c0:	f9010113          	addi	sp,sp,-112
   105c4:	06113423          	sd	ra,104(sp)
   105c8:	06813023          	sd	s0,96(sp)
   105cc:	07010413          	addi	s0,sp,112
   105d0:	faa43423          	sd	a0,-88(s0)
   105d4:	fab43023          	sd	a1,-96(s0)
   105d8:	00060793          	mv	a5,a2
   105dc:	f8d43823          	sd	a3,-112(s0)
   105e0:	f8f40fa3          	sb	a5,-97(s0)
   105e4:	f9f44783          	lbu	a5,-97(s0)
   105e8:	0ff7f793          	zext.b	a5,a5
   105ec:	02078863          	beqz	a5,1061c <print_dec_int+0x5c>
   105f0:	fa043703          	ld	a4,-96(s0)
   105f4:	fff00793          	li	a5,-1
   105f8:	03f79793          	slli	a5,a5,0x3f
   105fc:	02f71063          	bne	a4,a5,1061c <print_dec_int+0x5c>
   10600:	00001597          	auipc	a1,0x1
   10604:	c1058593          	addi	a1,a1,-1008 # 11210 <printf+0x144>
   10608:	fa843503          	ld	a0,-88(s0)
   1060c:	00000097          	auipc	ra,0x0
   10610:	f2c080e7          	jalr	-212(ra) # 10538 <puts_wo_nl>
   10614:	00050793          	mv	a5,a0
   10618:	2a00006f          	j	108b8 <print_dec_int+0x2f8>
   1061c:	f9043783          	ld	a5,-112(s0)
   10620:	00c7a783          	lw	a5,12(a5)
   10624:	00079a63          	bnez	a5,10638 <print_dec_int+0x78>
   10628:	fa043783          	ld	a5,-96(s0)
   1062c:	00079663          	bnez	a5,10638 <print_dec_int+0x78>
   10630:	00000793          	li	a5,0
   10634:	2840006f          	j	108b8 <print_dec_int+0x2f8>
   10638:	fe0407a3          	sb	zero,-17(s0)
   1063c:	f9f44783          	lbu	a5,-97(s0)
   10640:	0ff7f793          	zext.b	a5,a5
   10644:	02078063          	beqz	a5,10664 <print_dec_int+0xa4>
   10648:	fa043783          	ld	a5,-96(s0)
   1064c:	0007dc63          	bgez	a5,10664 <print_dec_int+0xa4>
   10650:	00100793          	li	a5,1
   10654:	fef407a3          	sb	a5,-17(s0)
   10658:	fa043783          	ld	a5,-96(s0)
   1065c:	40f007b3          	neg	a5,a5
   10660:	faf43023          	sd	a5,-96(s0)
   10664:	fe042423          	sw	zero,-24(s0)
   10668:	f9f44783          	lbu	a5,-97(s0)
   1066c:	0ff7f793          	zext.b	a5,a5
   10670:	02078863          	beqz	a5,106a0 <print_dec_int+0xe0>
   10674:	fef44783          	lbu	a5,-17(s0)
   10678:	0ff7f793          	zext.b	a5,a5
   1067c:	00079e63          	bnez	a5,10698 <print_dec_int+0xd8>
   10680:	f9043783          	ld	a5,-112(s0)
   10684:	0057c783          	lbu	a5,5(a5)
   10688:	00079863          	bnez	a5,10698 <print_dec_int+0xd8>
   1068c:	f9043783          	ld	a5,-112(s0)
   10690:	0047c783          	lbu	a5,4(a5)
   10694:	00078663          	beqz	a5,106a0 <print_dec_int+0xe0>
   10698:	00100793          	li	a5,1
   1069c:	0080006f          	j	106a4 <print_dec_int+0xe4>
   106a0:	00000793          	li	a5,0
   106a4:	fcf40ba3          	sb	a5,-41(s0)
   106a8:	fd744783          	lbu	a5,-41(s0)
   106ac:	0017f793          	andi	a5,a5,1
   106b0:	fcf40ba3          	sb	a5,-41(s0)
   106b4:	fa043703          	ld	a4,-96(s0)
   106b8:	00a00793          	li	a5,10
   106bc:	02f777b3          	remu	a5,a4,a5
   106c0:	0ff7f713          	zext.b	a4,a5
   106c4:	fe842783          	lw	a5,-24(s0)
   106c8:	0017869b          	addiw	a3,a5,1
   106cc:	fed42423          	sw	a3,-24(s0)
   106d0:	0307071b          	addiw	a4,a4,48
   106d4:	0ff77713          	zext.b	a4,a4
   106d8:	ff078793          	addi	a5,a5,-16
   106dc:	008787b3          	add	a5,a5,s0
   106e0:	fce78423          	sb	a4,-56(a5)
   106e4:	fa043703          	ld	a4,-96(s0)
   106e8:	00a00793          	li	a5,10
   106ec:	02f757b3          	divu	a5,a4,a5
   106f0:	faf43023          	sd	a5,-96(s0)
   106f4:	fa043783          	ld	a5,-96(s0)
   106f8:	fa079ee3          	bnez	a5,106b4 <print_dec_int+0xf4>
   106fc:	f9043783          	ld	a5,-112(s0)
   10700:	00c7a783          	lw	a5,12(a5)
   10704:	00078713          	mv	a4,a5
   10708:	fff00793          	li	a5,-1
   1070c:	02f71063          	bne	a4,a5,1072c <print_dec_int+0x16c>
   10710:	f9043783          	ld	a5,-112(s0)
   10714:	0037c783          	lbu	a5,3(a5)
   10718:	00078a63          	beqz	a5,1072c <print_dec_int+0x16c>
   1071c:	f9043783          	ld	a5,-112(s0)
   10720:	0087a703          	lw	a4,8(a5)
   10724:	f9043783          	ld	a5,-112(s0)
   10728:	00e7a623          	sw	a4,12(a5)
   1072c:	fe042223          	sw	zero,-28(s0)
   10730:	f9043783          	ld	a5,-112(s0)
   10734:	0087a703          	lw	a4,8(a5)
   10738:	fe842783          	lw	a5,-24(s0)
   1073c:	fcf42823          	sw	a5,-48(s0)
   10740:	f9043783          	ld	a5,-112(s0)
   10744:	00c7a783          	lw	a5,12(a5)
   10748:	fcf42623          	sw	a5,-52(s0)
   1074c:	fd042783          	lw	a5,-48(s0)
   10750:	00078593          	mv	a1,a5
   10754:	fcc42783          	lw	a5,-52(s0)
   10758:	00078613          	mv	a2,a5
   1075c:	0006069b          	sext.w	a3,a2
   10760:	0005879b          	sext.w	a5,a1
   10764:	00f6d463          	bge	a3,a5,1076c <print_dec_int+0x1ac>
   10768:	00058613          	mv	a2,a1
   1076c:	0006079b          	sext.w	a5,a2
   10770:	40f707bb          	subw	a5,a4,a5
   10774:	0007871b          	sext.w	a4,a5
   10778:	fd744783          	lbu	a5,-41(s0)
   1077c:	0007879b          	sext.w	a5,a5
   10780:	40f707bb          	subw	a5,a4,a5
   10784:	fef42023          	sw	a5,-32(s0)
   10788:	0280006f          	j	107b0 <print_dec_int+0x1f0>
   1078c:	fa843783          	ld	a5,-88(s0)
   10790:	02000513          	li	a0,32
   10794:	000780e7          	jalr	a5
   10798:	fe442783          	lw	a5,-28(s0)
   1079c:	0017879b          	addiw	a5,a5,1
   107a0:	fef42223          	sw	a5,-28(s0)
   107a4:	fe042783          	lw	a5,-32(s0)
   107a8:	fff7879b          	addiw	a5,a5,-1
   107ac:	fef42023          	sw	a5,-32(s0)
   107b0:	fe042783          	lw	a5,-32(s0)
   107b4:	0007879b          	sext.w	a5,a5
   107b8:	fcf04ae3          	bgtz	a5,1078c <print_dec_int+0x1cc>
   107bc:	fd744783          	lbu	a5,-41(s0)
   107c0:	0ff7f793          	zext.b	a5,a5
   107c4:	04078463          	beqz	a5,1080c <print_dec_int+0x24c>
   107c8:	fef44783          	lbu	a5,-17(s0)
   107cc:	0ff7f793          	zext.b	a5,a5
   107d0:	00078663          	beqz	a5,107dc <print_dec_int+0x21c>
   107d4:	02d00793          	li	a5,45
   107d8:	01c0006f          	j	107f4 <print_dec_int+0x234>
   107dc:	f9043783          	ld	a5,-112(s0)
   107e0:	0057c783          	lbu	a5,5(a5)
   107e4:	00078663          	beqz	a5,107f0 <print_dec_int+0x230>
   107e8:	02b00793          	li	a5,43
   107ec:	0080006f          	j	107f4 <print_dec_int+0x234>
   107f0:	02000793          	li	a5,32
   107f4:	fa843703          	ld	a4,-88(s0)
   107f8:	00078513          	mv	a0,a5
   107fc:	000700e7          	jalr	a4
   10800:	fe442783          	lw	a5,-28(s0)
   10804:	0017879b          	addiw	a5,a5,1
   10808:	fef42223          	sw	a5,-28(s0)
   1080c:	fe842783          	lw	a5,-24(s0)
   10810:	fcf42e23          	sw	a5,-36(s0)
   10814:	0280006f          	j	1083c <print_dec_int+0x27c>
   10818:	fa843783          	ld	a5,-88(s0)
   1081c:	03000513          	li	a0,48
   10820:	000780e7          	jalr	a5
   10824:	fe442783          	lw	a5,-28(s0)
   10828:	0017879b          	addiw	a5,a5,1
   1082c:	fef42223          	sw	a5,-28(s0)
   10830:	fdc42783          	lw	a5,-36(s0)
   10834:	0017879b          	addiw	a5,a5,1
   10838:	fcf42e23          	sw	a5,-36(s0)
   1083c:	f9043783          	ld	a5,-112(s0)
   10840:	00c7a703          	lw	a4,12(a5)
   10844:	fd744783          	lbu	a5,-41(s0)
   10848:	0007879b          	sext.w	a5,a5
   1084c:	40f707bb          	subw	a5,a4,a5
   10850:	0007871b          	sext.w	a4,a5
   10854:	fdc42783          	lw	a5,-36(s0)
   10858:	0007879b          	sext.w	a5,a5
   1085c:	fae7cee3          	blt	a5,a4,10818 <print_dec_int+0x258>
   10860:	fe842783          	lw	a5,-24(s0)
   10864:	fff7879b          	addiw	a5,a5,-1
   10868:	fcf42c23          	sw	a5,-40(s0)
   1086c:	03c0006f          	j	108a8 <print_dec_int+0x2e8>
   10870:	fd842783          	lw	a5,-40(s0)
   10874:	ff078793          	addi	a5,a5,-16
   10878:	008787b3          	add	a5,a5,s0
   1087c:	fc87c783          	lbu	a5,-56(a5)
   10880:	0007871b          	sext.w	a4,a5
   10884:	fa843783          	ld	a5,-88(s0)
   10888:	00070513          	mv	a0,a4
   1088c:	000780e7          	jalr	a5
   10890:	fe442783          	lw	a5,-28(s0)
   10894:	0017879b          	addiw	a5,a5,1
   10898:	fef42223          	sw	a5,-28(s0)
   1089c:	fd842783          	lw	a5,-40(s0)
   108a0:	fff7879b          	addiw	a5,a5,-1
   108a4:	fcf42c23          	sw	a5,-40(s0)
   108a8:	fd842783          	lw	a5,-40(s0)
   108ac:	0007879b          	sext.w	a5,a5
   108b0:	fc07d0e3          	bgez	a5,10870 <print_dec_int+0x2b0>
   108b4:	fe442783          	lw	a5,-28(s0)
   108b8:	00078513          	mv	a0,a5
   108bc:	06813083          	ld	ra,104(sp)
   108c0:	06013403          	ld	s0,96(sp)
   108c4:	07010113          	addi	sp,sp,112
   108c8:	00008067          	ret

00000000000108cc <vprintfmt>:
   108cc:	f4010113          	addi	sp,sp,-192
   108d0:	0a113c23          	sd	ra,184(sp)
   108d4:	0a813823          	sd	s0,176(sp)
   108d8:	0c010413          	addi	s0,sp,192
   108dc:	f4a43c23          	sd	a0,-168(s0)
   108e0:	f4b43823          	sd	a1,-176(s0)
   108e4:	f4c43423          	sd	a2,-184(s0)
   108e8:	f8043023          	sd	zero,-128(s0)
   108ec:	f8043423          	sd	zero,-120(s0)
   108f0:	fe042623          	sw	zero,-20(s0)
   108f4:	7b40006f          	j	110a8 <vprintfmt+0x7dc>
   108f8:	f8044783          	lbu	a5,-128(s0)
   108fc:	74078663          	beqz	a5,11048 <vprintfmt+0x77c>
   10900:	f5043783          	ld	a5,-176(s0)
   10904:	0007c783          	lbu	a5,0(a5)
   10908:	00078713          	mv	a4,a5
   1090c:	02300793          	li	a5,35
   10910:	00f71863          	bne	a4,a5,10920 <vprintfmt+0x54>
   10914:	00100793          	li	a5,1
   10918:	f8f40123          	sb	a5,-126(s0)
   1091c:	7800006f          	j	1109c <vprintfmt+0x7d0>
   10920:	f5043783          	ld	a5,-176(s0)
   10924:	0007c783          	lbu	a5,0(a5)
   10928:	00078713          	mv	a4,a5
   1092c:	03000793          	li	a5,48
   10930:	00f71863          	bne	a4,a5,10940 <vprintfmt+0x74>
   10934:	00100793          	li	a5,1
   10938:	f8f401a3          	sb	a5,-125(s0)
   1093c:	7600006f          	j	1109c <vprintfmt+0x7d0>
   10940:	f5043783          	ld	a5,-176(s0)
   10944:	0007c783          	lbu	a5,0(a5)
   10948:	00078713          	mv	a4,a5
   1094c:	06c00793          	li	a5,108
   10950:	04f70063          	beq	a4,a5,10990 <vprintfmt+0xc4>
   10954:	f5043783          	ld	a5,-176(s0)
   10958:	0007c783          	lbu	a5,0(a5)
   1095c:	00078713          	mv	a4,a5
   10960:	07a00793          	li	a5,122
   10964:	02f70663          	beq	a4,a5,10990 <vprintfmt+0xc4>
   10968:	f5043783          	ld	a5,-176(s0)
   1096c:	0007c783          	lbu	a5,0(a5)
   10970:	00078713          	mv	a4,a5
   10974:	07400793          	li	a5,116
   10978:	00f70c63          	beq	a4,a5,10990 <vprintfmt+0xc4>
   1097c:	f5043783          	ld	a5,-176(s0)
   10980:	0007c783          	lbu	a5,0(a5)
   10984:	00078713          	mv	a4,a5
   10988:	06a00793          	li	a5,106
   1098c:	00f71863          	bne	a4,a5,1099c <vprintfmt+0xd0>
   10990:	00100793          	li	a5,1
   10994:	f8f400a3          	sb	a5,-127(s0)
   10998:	7040006f          	j	1109c <vprintfmt+0x7d0>
   1099c:	f5043783          	ld	a5,-176(s0)
   109a0:	0007c783          	lbu	a5,0(a5)
   109a4:	00078713          	mv	a4,a5
   109a8:	02b00793          	li	a5,43
   109ac:	00f71863          	bne	a4,a5,109bc <vprintfmt+0xf0>
   109b0:	00100793          	li	a5,1
   109b4:	f8f402a3          	sb	a5,-123(s0)
   109b8:	6e40006f          	j	1109c <vprintfmt+0x7d0>
   109bc:	f5043783          	ld	a5,-176(s0)
   109c0:	0007c783          	lbu	a5,0(a5)
   109c4:	00078713          	mv	a4,a5
   109c8:	02000793          	li	a5,32
   109cc:	00f71863          	bne	a4,a5,109dc <vprintfmt+0x110>
   109d0:	00100793          	li	a5,1
   109d4:	f8f40223          	sb	a5,-124(s0)
   109d8:	6c40006f          	j	1109c <vprintfmt+0x7d0>
   109dc:	f5043783          	ld	a5,-176(s0)
   109e0:	0007c783          	lbu	a5,0(a5)
   109e4:	00078713          	mv	a4,a5
   109e8:	02a00793          	li	a5,42
   109ec:	00f71e63          	bne	a4,a5,10a08 <vprintfmt+0x13c>
   109f0:	f4843783          	ld	a5,-184(s0)
   109f4:	00878713          	addi	a4,a5,8
   109f8:	f4e43423          	sd	a4,-184(s0)
   109fc:	0007a783          	lw	a5,0(a5)
   10a00:	f8f42423          	sw	a5,-120(s0)
   10a04:	6980006f          	j	1109c <vprintfmt+0x7d0>
   10a08:	f5043783          	ld	a5,-176(s0)
   10a0c:	0007c783          	lbu	a5,0(a5)
   10a10:	00078713          	mv	a4,a5
   10a14:	03000793          	li	a5,48
   10a18:	04e7f863          	bgeu	a5,a4,10a68 <vprintfmt+0x19c>
   10a1c:	f5043783          	ld	a5,-176(s0)
   10a20:	0007c783          	lbu	a5,0(a5)
   10a24:	00078713          	mv	a4,a5
   10a28:	03900793          	li	a5,57
   10a2c:	02e7ee63          	bltu	a5,a4,10a68 <vprintfmt+0x19c>
   10a30:	f5043783          	ld	a5,-176(s0)
   10a34:	f5040713          	addi	a4,s0,-176
   10a38:	00a00613          	li	a2,10
   10a3c:	00070593          	mv	a1,a4
   10a40:	00078513          	mv	a0,a5
   10a44:	00000097          	auipc	ra,0x0
   10a48:	884080e7          	jalr	-1916(ra) # 102c8 <strtol>
   10a4c:	00050793          	mv	a5,a0
   10a50:	0007879b          	sext.w	a5,a5
   10a54:	f8f42423          	sw	a5,-120(s0)
   10a58:	f5043783          	ld	a5,-176(s0)
   10a5c:	fff78793          	addi	a5,a5,-1
   10a60:	f4f43823          	sd	a5,-176(s0)
   10a64:	6380006f          	j	1109c <vprintfmt+0x7d0>
   10a68:	f5043783          	ld	a5,-176(s0)
   10a6c:	0007c783          	lbu	a5,0(a5)
   10a70:	00078713          	mv	a4,a5
   10a74:	02e00793          	li	a5,46
   10a78:	06f71a63          	bne	a4,a5,10aec <vprintfmt+0x220>
   10a7c:	f5043783          	ld	a5,-176(s0)
   10a80:	00178793          	addi	a5,a5,1
   10a84:	f4f43823          	sd	a5,-176(s0)
   10a88:	f5043783          	ld	a5,-176(s0)
   10a8c:	0007c783          	lbu	a5,0(a5)
   10a90:	00078713          	mv	a4,a5
   10a94:	02a00793          	li	a5,42
   10a98:	00f71e63          	bne	a4,a5,10ab4 <vprintfmt+0x1e8>
   10a9c:	f4843783          	ld	a5,-184(s0)
   10aa0:	00878713          	addi	a4,a5,8
   10aa4:	f4e43423          	sd	a4,-184(s0)
   10aa8:	0007a783          	lw	a5,0(a5)
   10aac:	f8f42623          	sw	a5,-116(s0)
   10ab0:	5ec0006f          	j	1109c <vprintfmt+0x7d0>
   10ab4:	f5043783          	ld	a5,-176(s0)
   10ab8:	f5040713          	addi	a4,s0,-176
   10abc:	00a00613          	li	a2,10
   10ac0:	00070593          	mv	a1,a4
   10ac4:	00078513          	mv	a0,a5
   10ac8:	00000097          	auipc	ra,0x0
   10acc:	800080e7          	jalr	-2048(ra) # 102c8 <strtol>
   10ad0:	00050793          	mv	a5,a0
   10ad4:	0007879b          	sext.w	a5,a5
   10ad8:	f8f42623          	sw	a5,-116(s0)
   10adc:	f5043783          	ld	a5,-176(s0)
   10ae0:	fff78793          	addi	a5,a5,-1
   10ae4:	f4f43823          	sd	a5,-176(s0)
   10ae8:	5b40006f          	j	1109c <vprintfmt+0x7d0>
   10aec:	f5043783          	ld	a5,-176(s0)
   10af0:	0007c783          	lbu	a5,0(a5)
   10af4:	00078713          	mv	a4,a5
   10af8:	07800793          	li	a5,120
   10afc:	02f70663          	beq	a4,a5,10b28 <vprintfmt+0x25c>
   10b00:	f5043783          	ld	a5,-176(s0)
   10b04:	0007c783          	lbu	a5,0(a5)
   10b08:	00078713          	mv	a4,a5
   10b0c:	05800793          	li	a5,88
   10b10:	00f70c63          	beq	a4,a5,10b28 <vprintfmt+0x25c>
   10b14:	f5043783          	ld	a5,-176(s0)
   10b18:	0007c783          	lbu	a5,0(a5)
   10b1c:	00078713          	mv	a4,a5
   10b20:	07000793          	li	a5,112
   10b24:	30f71263          	bne	a4,a5,10e28 <vprintfmt+0x55c>
   10b28:	f5043783          	ld	a5,-176(s0)
   10b2c:	0007c783          	lbu	a5,0(a5)
   10b30:	00078713          	mv	a4,a5
   10b34:	07000793          	li	a5,112
   10b38:	00f70663          	beq	a4,a5,10b44 <vprintfmt+0x278>
   10b3c:	f8144783          	lbu	a5,-127(s0)
   10b40:	00078663          	beqz	a5,10b4c <vprintfmt+0x280>
   10b44:	00100793          	li	a5,1
   10b48:	0080006f          	j	10b50 <vprintfmt+0x284>
   10b4c:	00000793          	li	a5,0
   10b50:	faf403a3          	sb	a5,-89(s0)
   10b54:	fa744783          	lbu	a5,-89(s0)
   10b58:	0017f793          	andi	a5,a5,1
   10b5c:	faf403a3          	sb	a5,-89(s0)
   10b60:	fa744783          	lbu	a5,-89(s0)
   10b64:	0ff7f793          	zext.b	a5,a5
   10b68:	00078c63          	beqz	a5,10b80 <vprintfmt+0x2b4>
   10b6c:	f4843783          	ld	a5,-184(s0)
   10b70:	00878713          	addi	a4,a5,8
   10b74:	f4e43423          	sd	a4,-184(s0)
   10b78:	0007b783          	ld	a5,0(a5)
   10b7c:	01c0006f          	j	10b98 <vprintfmt+0x2cc>
   10b80:	f4843783          	ld	a5,-184(s0)
   10b84:	00878713          	addi	a4,a5,8
   10b88:	f4e43423          	sd	a4,-184(s0)
   10b8c:	0007a783          	lw	a5,0(a5)
   10b90:	02079793          	slli	a5,a5,0x20
   10b94:	0207d793          	srli	a5,a5,0x20
   10b98:	fef43023          	sd	a5,-32(s0)
   10b9c:	f8c42783          	lw	a5,-116(s0)
   10ba0:	02079463          	bnez	a5,10bc8 <vprintfmt+0x2fc>
   10ba4:	fe043783          	ld	a5,-32(s0)
   10ba8:	02079063          	bnez	a5,10bc8 <vprintfmt+0x2fc>
   10bac:	f5043783          	ld	a5,-176(s0)
   10bb0:	0007c783          	lbu	a5,0(a5)
   10bb4:	00078713          	mv	a4,a5
   10bb8:	07000793          	li	a5,112
   10bbc:	00f70663          	beq	a4,a5,10bc8 <vprintfmt+0x2fc>
   10bc0:	f8040023          	sb	zero,-128(s0)
   10bc4:	4d80006f          	j	1109c <vprintfmt+0x7d0>
   10bc8:	f5043783          	ld	a5,-176(s0)
   10bcc:	0007c783          	lbu	a5,0(a5)
   10bd0:	00078713          	mv	a4,a5
   10bd4:	07000793          	li	a5,112
   10bd8:	00f70a63          	beq	a4,a5,10bec <vprintfmt+0x320>
   10bdc:	f8244783          	lbu	a5,-126(s0)
   10be0:	00078a63          	beqz	a5,10bf4 <vprintfmt+0x328>
   10be4:	fe043783          	ld	a5,-32(s0)
   10be8:	00078663          	beqz	a5,10bf4 <vprintfmt+0x328>
   10bec:	00100793          	li	a5,1
   10bf0:	0080006f          	j	10bf8 <vprintfmt+0x32c>
   10bf4:	00000793          	li	a5,0
   10bf8:	faf40323          	sb	a5,-90(s0)
   10bfc:	fa644783          	lbu	a5,-90(s0)
   10c00:	0017f793          	andi	a5,a5,1
   10c04:	faf40323          	sb	a5,-90(s0)
   10c08:	fc042e23          	sw	zero,-36(s0)
   10c0c:	f5043783          	ld	a5,-176(s0)
   10c10:	0007c783          	lbu	a5,0(a5)
   10c14:	00078713          	mv	a4,a5
   10c18:	05800793          	li	a5,88
   10c1c:	00f71863          	bne	a4,a5,10c2c <vprintfmt+0x360>
   10c20:	00000797          	auipc	a5,0x0
   10c24:	60878793          	addi	a5,a5,1544 # 11228 <upperxdigits.1>
   10c28:	00c0006f          	j	10c34 <vprintfmt+0x368>
   10c2c:	00000797          	auipc	a5,0x0
   10c30:	61478793          	addi	a5,a5,1556 # 11240 <lowerxdigits.0>
   10c34:	f8f43c23          	sd	a5,-104(s0)
   10c38:	fe043783          	ld	a5,-32(s0)
   10c3c:	00f7f793          	andi	a5,a5,15
   10c40:	f9843703          	ld	a4,-104(s0)
   10c44:	00f70733          	add	a4,a4,a5
   10c48:	fdc42783          	lw	a5,-36(s0)
   10c4c:	0017869b          	addiw	a3,a5,1
   10c50:	fcd42e23          	sw	a3,-36(s0)
   10c54:	00074703          	lbu	a4,0(a4)
   10c58:	ff078793          	addi	a5,a5,-16
   10c5c:	008787b3          	add	a5,a5,s0
   10c60:	f8e78023          	sb	a4,-128(a5)
   10c64:	fe043783          	ld	a5,-32(s0)
   10c68:	0047d793          	srli	a5,a5,0x4
   10c6c:	fef43023          	sd	a5,-32(s0)
   10c70:	fe043783          	ld	a5,-32(s0)
   10c74:	fc0792e3          	bnez	a5,10c38 <vprintfmt+0x36c>
   10c78:	f8c42783          	lw	a5,-116(s0)
   10c7c:	00078713          	mv	a4,a5
   10c80:	fff00793          	li	a5,-1
   10c84:	02f71663          	bne	a4,a5,10cb0 <vprintfmt+0x3e4>
   10c88:	f8344783          	lbu	a5,-125(s0)
   10c8c:	02078263          	beqz	a5,10cb0 <vprintfmt+0x3e4>
   10c90:	f8842703          	lw	a4,-120(s0)
   10c94:	fa644783          	lbu	a5,-90(s0)
   10c98:	0007879b          	sext.w	a5,a5
   10c9c:	0017979b          	slliw	a5,a5,0x1
   10ca0:	0007879b          	sext.w	a5,a5
   10ca4:	40f707bb          	subw	a5,a4,a5
   10ca8:	0007879b          	sext.w	a5,a5
   10cac:	f8f42623          	sw	a5,-116(s0)
   10cb0:	f8842703          	lw	a4,-120(s0)
   10cb4:	fa644783          	lbu	a5,-90(s0)
   10cb8:	0007879b          	sext.w	a5,a5
   10cbc:	0017979b          	slliw	a5,a5,0x1
   10cc0:	0007879b          	sext.w	a5,a5
   10cc4:	40f707bb          	subw	a5,a4,a5
   10cc8:	0007871b          	sext.w	a4,a5
   10ccc:	fdc42783          	lw	a5,-36(s0)
   10cd0:	f8f42a23          	sw	a5,-108(s0)
   10cd4:	f8c42783          	lw	a5,-116(s0)
   10cd8:	f8f42823          	sw	a5,-112(s0)
   10cdc:	f9442783          	lw	a5,-108(s0)
   10ce0:	00078593          	mv	a1,a5
   10ce4:	f9042783          	lw	a5,-112(s0)
   10ce8:	00078613          	mv	a2,a5
   10cec:	0006069b          	sext.w	a3,a2
   10cf0:	0005879b          	sext.w	a5,a1
   10cf4:	00f6d463          	bge	a3,a5,10cfc <vprintfmt+0x430>
   10cf8:	00058613          	mv	a2,a1
   10cfc:	0006079b          	sext.w	a5,a2
   10d00:	40f707bb          	subw	a5,a4,a5
   10d04:	fcf42c23          	sw	a5,-40(s0)
   10d08:	0280006f          	j	10d30 <vprintfmt+0x464>
   10d0c:	f5843783          	ld	a5,-168(s0)
   10d10:	02000513          	li	a0,32
   10d14:	000780e7          	jalr	a5
   10d18:	fec42783          	lw	a5,-20(s0)
   10d1c:	0017879b          	addiw	a5,a5,1
   10d20:	fef42623          	sw	a5,-20(s0)
   10d24:	fd842783          	lw	a5,-40(s0)
   10d28:	fff7879b          	addiw	a5,a5,-1
   10d2c:	fcf42c23          	sw	a5,-40(s0)
   10d30:	fd842783          	lw	a5,-40(s0)
   10d34:	0007879b          	sext.w	a5,a5
   10d38:	fcf04ae3          	bgtz	a5,10d0c <vprintfmt+0x440>
   10d3c:	fa644783          	lbu	a5,-90(s0)
   10d40:	0ff7f793          	zext.b	a5,a5
   10d44:	04078463          	beqz	a5,10d8c <vprintfmt+0x4c0>
   10d48:	f5843783          	ld	a5,-168(s0)
   10d4c:	03000513          	li	a0,48
   10d50:	000780e7          	jalr	a5
   10d54:	f5043783          	ld	a5,-176(s0)
   10d58:	0007c783          	lbu	a5,0(a5)
   10d5c:	00078713          	mv	a4,a5
   10d60:	05800793          	li	a5,88
   10d64:	00f71663          	bne	a4,a5,10d70 <vprintfmt+0x4a4>
   10d68:	05800793          	li	a5,88
   10d6c:	0080006f          	j	10d74 <vprintfmt+0x4a8>
   10d70:	07800793          	li	a5,120
   10d74:	f5843703          	ld	a4,-168(s0)
   10d78:	00078513          	mv	a0,a5
   10d7c:	000700e7          	jalr	a4
   10d80:	fec42783          	lw	a5,-20(s0)
   10d84:	0027879b          	addiw	a5,a5,2
   10d88:	fef42623          	sw	a5,-20(s0)
   10d8c:	fdc42783          	lw	a5,-36(s0)
   10d90:	fcf42a23          	sw	a5,-44(s0)
   10d94:	0280006f          	j	10dbc <vprintfmt+0x4f0>
   10d98:	f5843783          	ld	a5,-168(s0)
   10d9c:	03000513          	li	a0,48
   10da0:	000780e7          	jalr	a5
   10da4:	fec42783          	lw	a5,-20(s0)
   10da8:	0017879b          	addiw	a5,a5,1
   10dac:	fef42623          	sw	a5,-20(s0)
   10db0:	fd442783          	lw	a5,-44(s0)
   10db4:	0017879b          	addiw	a5,a5,1
   10db8:	fcf42a23          	sw	a5,-44(s0)
   10dbc:	f8c42703          	lw	a4,-116(s0)
   10dc0:	fd442783          	lw	a5,-44(s0)
   10dc4:	0007879b          	sext.w	a5,a5
   10dc8:	fce7c8e3          	blt	a5,a4,10d98 <vprintfmt+0x4cc>
   10dcc:	fdc42783          	lw	a5,-36(s0)
   10dd0:	fff7879b          	addiw	a5,a5,-1
   10dd4:	fcf42823          	sw	a5,-48(s0)
   10dd8:	03c0006f          	j	10e14 <vprintfmt+0x548>
   10ddc:	fd042783          	lw	a5,-48(s0)
   10de0:	ff078793          	addi	a5,a5,-16
   10de4:	008787b3          	add	a5,a5,s0
   10de8:	f807c783          	lbu	a5,-128(a5)
   10dec:	0007871b          	sext.w	a4,a5
   10df0:	f5843783          	ld	a5,-168(s0)
   10df4:	00070513          	mv	a0,a4
   10df8:	000780e7          	jalr	a5
   10dfc:	fec42783          	lw	a5,-20(s0)
   10e00:	0017879b          	addiw	a5,a5,1
   10e04:	fef42623          	sw	a5,-20(s0)
   10e08:	fd042783          	lw	a5,-48(s0)
   10e0c:	fff7879b          	addiw	a5,a5,-1
   10e10:	fcf42823          	sw	a5,-48(s0)
   10e14:	fd042783          	lw	a5,-48(s0)
   10e18:	0007879b          	sext.w	a5,a5
   10e1c:	fc07d0e3          	bgez	a5,10ddc <vprintfmt+0x510>
   10e20:	f8040023          	sb	zero,-128(s0)
   10e24:	2780006f          	j	1109c <vprintfmt+0x7d0>
   10e28:	f5043783          	ld	a5,-176(s0)
   10e2c:	0007c783          	lbu	a5,0(a5)
   10e30:	00078713          	mv	a4,a5
   10e34:	06400793          	li	a5,100
   10e38:	02f70663          	beq	a4,a5,10e64 <vprintfmt+0x598>
   10e3c:	f5043783          	ld	a5,-176(s0)
   10e40:	0007c783          	lbu	a5,0(a5)
   10e44:	00078713          	mv	a4,a5
   10e48:	06900793          	li	a5,105
   10e4c:	00f70c63          	beq	a4,a5,10e64 <vprintfmt+0x598>
   10e50:	f5043783          	ld	a5,-176(s0)
   10e54:	0007c783          	lbu	a5,0(a5)
   10e58:	00078713          	mv	a4,a5
   10e5c:	07500793          	li	a5,117
   10e60:	08f71263          	bne	a4,a5,10ee4 <vprintfmt+0x618>
   10e64:	f8144783          	lbu	a5,-127(s0)
   10e68:	00078c63          	beqz	a5,10e80 <vprintfmt+0x5b4>
   10e6c:	f4843783          	ld	a5,-184(s0)
   10e70:	00878713          	addi	a4,a5,8
   10e74:	f4e43423          	sd	a4,-184(s0)
   10e78:	0007b783          	ld	a5,0(a5)
   10e7c:	0140006f          	j	10e90 <vprintfmt+0x5c4>
   10e80:	f4843783          	ld	a5,-184(s0)
   10e84:	00878713          	addi	a4,a5,8
   10e88:	f4e43423          	sd	a4,-184(s0)
   10e8c:	0007a783          	lw	a5,0(a5)
   10e90:	faf43423          	sd	a5,-88(s0)
   10e94:	fa843583          	ld	a1,-88(s0)
   10e98:	f5043783          	ld	a5,-176(s0)
   10e9c:	0007c783          	lbu	a5,0(a5)
   10ea0:	0007871b          	sext.w	a4,a5
   10ea4:	07500793          	li	a5,117
   10ea8:	40f707b3          	sub	a5,a4,a5
   10eac:	00f037b3          	snez	a5,a5
   10eb0:	0ff7f793          	zext.b	a5,a5
   10eb4:	f8040713          	addi	a4,s0,-128
   10eb8:	00070693          	mv	a3,a4
   10ebc:	00078613          	mv	a2,a5
   10ec0:	f5843503          	ld	a0,-168(s0)
   10ec4:	fffff097          	auipc	ra,0xfffff
   10ec8:	6fc080e7          	jalr	1788(ra) # 105c0 <print_dec_int>
   10ecc:	00050793          	mv	a5,a0
   10ed0:	fec42703          	lw	a4,-20(s0)
   10ed4:	00f707bb          	addw	a5,a4,a5
   10ed8:	fef42623          	sw	a5,-20(s0)
   10edc:	f8040023          	sb	zero,-128(s0)
   10ee0:	1bc0006f          	j	1109c <vprintfmt+0x7d0>
   10ee4:	f5043783          	ld	a5,-176(s0)
   10ee8:	0007c783          	lbu	a5,0(a5)
   10eec:	00078713          	mv	a4,a5
   10ef0:	06e00793          	li	a5,110
   10ef4:	04f71c63          	bne	a4,a5,10f4c <vprintfmt+0x680>
   10ef8:	f8144783          	lbu	a5,-127(s0)
   10efc:	02078463          	beqz	a5,10f24 <vprintfmt+0x658>
   10f00:	f4843783          	ld	a5,-184(s0)
   10f04:	00878713          	addi	a4,a5,8
   10f08:	f4e43423          	sd	a4,-184(s0)
   10f0c:	0007b783          	ld	a5,0(a5)
   10f10:	faf43823          	sd	a5,-80(s0)
   10f14:	fec42703          	lw	a4,-20(s0)
   10f18:	fb043783          	ld	a5,-80(s0)
   10f1c:	00e7b023          	sd	a4,0(a5)
   10f20:	0240006f          	j	10f44 <vprintfmt+0x678>
   10f24:	f4843783          	ld	a5,-184(s0)
   10f28:	00878713          	addi	a4,a5,8
   10f2c:	f4e43423          	sd	a4,-184(s0)
   10f30:	0007b783          	ld	a5,0(a5)
   10f34:	faf43c23          	sd	a5,-72(s0)
   10f38:	fb843783          	ld	a5,-72(s0)
   10f3c:	fec42703          	lw	a4,-20(s0)
   10f40:	00e7a023          	sw	a4,0(a5)
   10f44:	f8040023          	sb	zero,-128(s0)
   10f48:	1540006f          	j	1109c <vprintfmt+0x7d0>
   10f4c:	f5043783          	ld	a5,-176(s0)
   10f50:	0007c783          	lbu	a5,0(a5)
   10f54:	00078713          	mv	a4,a5
   10f58:	07300793          	li	a5,115
   10f5c:	04f71063          	bne	a4,a5,10f9c <vprintfmt+0x6d0>
   10f60:	f4843783          	ld	a5,-184(s0)
   10f64:	00878713          	addi	a4,a5,8
   10f68:	f4e43423          	sd	a4,-184(s0)
   10f6c:	0007b783          	ld	a5,0(a5)
   10f70:	fcf43023          	sd	a5,-64(s0)
   10f74:	fc043583          	ld	a1,-64(s0)
   10f78:	f5843503          	ld	a0,-168(s0)
   10f7c:	fffff097          	auipc	ra,0xfffff
   10f80:	5bc080e7          	jalr	1468(ra) # 10538 <puts_wo_nl>
   10f84:	00050793          	mv	a5,a0
   10f88:	fec42703          	lw	a4,-20(s0)
   10f8c:	00f707bb          	addw	a5,a4,a5
   10f90:	fef42623          	sw	a5,-20(s0)
   10f94:	f8040023          	sb	zero,-128(s0)
   10f98:	1040006f          	j	1109c <vprintfmt+0x7d0>
   10f9c:	f5043783          	ld	a5,-176(s0)
   10fa0:	0007c783          	lbu	a5,0(a5)
   10fa4:	00078713          	mv	a4,a5
   10fa8:	06300793          	li	a5,99
   10fac:	02f71e63          	bne	a4,a5,10fe8 <vprintfmt+0x71c>
   10fb0:	f4843783          	ld	a5,-184(s0)
   10fb4:	00878713          	addi	a4,a5,8
   10fb8:	f4e43423          	sd	a4,-184(s0)
   10fbc:	0007a783          	lw	a5,0(a5)
   10fc0:	fcf42623          	sw	a5,-52(s0)
   10fc4:	fcc42703          	lw	a4,-52(s0)
   10fc8:	f5843783          	ld	a5,-168(s0)
   10fcc:	00070513          	mv	a0,a4
   10fd0:	000780e7          	jalr	a5
   10fd4:	fec42783          	lw	a5,-20(s0)
   10fd8:	0017879b          	addiw	a5,a5,1
   10fdc:	fef42623          	sw	a5,-20(s0)
   10fe0:	f8040023          	sb	zero,-128(s0)
   10fe4:	0b80006f          	j	1109c <vprintfmt+0x7d0>
   10fe8:	f5043783          	ld	a5,-176(s0)
   10fec:	0007c783          	lbu	a5,0(a5)
   10ff0:	00078713          	mv	a4,a5
   10ff4:	02500793          	li	a5,37
   10ff8:	02f71263          	bne	a4,a5,1101c <vprintfmt+0x750>
   10ffc:	f5843783          	ld	a5,-168(s0)
   11000:	02500513          	li	a0,37
   11004:	000780e7          	jalr	a5
   11008:	fec42783          	lw	a5,-20(s0)
   1100c:	0017879b          	addiw	a5,a5,1
   11010:	fef42623          	sw	a5,-20(s0)
   11014:	f8040023          	sb	zero,-128(s0)
   11018:	0840006f          	j	1109c <vprintfmt+0x7d0>
   1101c:	f5043783          	ld	a5,-176(s0)
   11020:	0007c783          	lbu	a5,0(a5)
   11024:	0007871b          	sext.w	a4,a5
   11028:	f5843783          	ld	a5,-168(s0)
   1102c:	00070513          	mv	a0,a4
   11030:	000780e7          	jalr	a5
   11034:	fec42783          	lw	a5,-20(s0)
   11038:	0017879b          	addiw	a5,a5,1
   1103c:	fef42623          	sw	a5,-20(s0)
   11040:	f8040023          	sb	zero,-128(s0)
   11044:	0580006f          	j	1109c <vprintfmt+0x7d0>
   11048:	f5043783          	ld	a5,-176(s0)
   1104c:	0007c783          	lbu	a5,0(a5)
   11050:	00078713          	mv	a4,a5
   11054:	02500793          	li	a5,37
   11058:	02f71063          	bne	a4,a5,11078 <vprintfmt+0x7ac>
   1105c:	f8043023          	sd	zero,-128(s0)
   11060:	f8043423          	sd	zero,-120(s0)
   11064:	00100793          	li	a5,1
   11068:	f8f40023          	sb	a5,-128(s0)
   1106c:	fff00793          	li	a5,-1
   11070:	f8f42623          	sw	a5,-116(s0)
   11074:	0280006f          	j	1109c <vprintfmt+0x7d0>
   11078:	f5043783          	ld	a5,-176(s0)
   1107c:	0007c783          	lbu	a5,0(a5)
   11080:	0007871b          	sext.w	a4,a5
   11084:	f5843783          	ld	a5,-168(s0)
   11088:	00070513          	mv	a0,a4
   1108c:	000780e7          	jalr	a5
   11090:	fec42783          	lw	a5,-20(s0)
   11094:	0017879b          	addiw	a5,a5,1
   11098:	fef42623          	sw	a5,-20(s0)
   1109c:	f5043783          	ld	a5,-176(s0)
   110a0:	00178793          	addi	a5,a5,1
   110a4:	f4f43823          	sd	a5,-176(s0)
   110a8:	f5043783          	ld	a5,-176(s0)
   110ac:	0007c783          	lbu	a5,0(a5)
   110b0:	840794e3          	bnez	a5,108f8 <vprintfmt+0x2c>
   110b4:	fec42783          	lw	a5,-20(s0)
   110b8:	00078513          	mv	a0,a5
   110bc:	0b813083          	ld	ra,184(sp)
   110c0:	0b013403          	ld	s0,176(sp)
   110c4:	0c010113          	addi	sp,sp,192
   110c8:	00008067          	ret

00000000000110cc <printf>:
   110cc:	f8010113          	addi	sp,sp,-128
   110d0:	02113c23          	sd	ra,56(sp)
   110d4:	02813823          	sd	s0,48(sp)
   110d8:	04010413          	addi	s0,sp,64
   110dc:	fca43423          	sd	a0,-56(s0)
   110e0:	00b43423          	sd	a1,8(s0)
   110e4:	00c43823          	sd	a2,16(s0)
   110e8:	00d43c23          	sd	a3,24(s0)
   110ec:	02e43023          	sd	a4,32(s0)
   110f0:	02f43423          	sd	a5,40(s0)
   110f4:	03043823          	sd	a6,48(s0)
   110f8:	03143c23          	sd	a7,56(s0)
   110fc:	fe042623          	sw	zero,-20(s0)
   11100:	04040793          	addi	a5,s0,64
   11104:	fcf43023          	sd	a5,-64(s0)
   11108:	fc043783          	ld	a5,-64(s0)
   1110c:	fc878793          	addi	a5,a5,-56
   11110:	fcf43823          	sd	a5,-48(s0)
   11114:	fd043783          	ld	a5,-48(s0)
   11118:	00078613          	mv	a2,a5
   1111c:	fc843583          	ld	a1,-56(s0)
   11120:	fffff517          	auipc	a0,0xfffff
   11124:	0e050513          	addi	a0,a0,224 # 10200 <putc>
   11128:	fffff097          	auipc	ra,0xfffff
   1112c:	7a4080e7          	jalr	1956(ra) # 108cc <vprintfmt>
   11130:	00050793          	mv	a5,a0
   11134:	fef42623          	sw	a5,-20(s0)
   11138:	00100793          	li	a5,1
   1113c:	fef43023          	sd	a5,-32(s0)
   11140:	00001797          	auipc	a5,0x1
   11144:	11c78793          	addi	a5,a5,284 # 1225c <tail>
   11148:	0007a783          	lw	a5,0(a5)
   1114c:	0017871b          	addiw	a4,a5,1
   11150:	0007069b          	sext.w	a3,a4
   11154:	00001717          	auipc	a4,0x1
   11158:	10870713          	addi	a4,a4,264 # 1225c <tail>
   1115c:	00d72023          	sw	a3,0(a4)
   11160:	00001717          	auipc	a4,0x1
   11164:	10070713          	addi	a4,a4,256 # 12260 <buffer>
   11168:	00f707b3          	add	a5,a4,a5
   1116c:	00078023          	sb	zero,0(a5)
   11170:	00001797          	auipc	a5,0x1
   11174:	0ec78793          	addi	a5,a5,236 # 1225c <tail>
   11178:	0007a603          	lw	a2,0(a5)
   1117c:	fe043703          	ld	a4,-32(s0)
   11180:	00001697          	auipc	a3,0x1
   11184:	0e068693          	addi	a3,a3,224 # 12260 <buffer>
   11188:	fd843783          	ld	a5,-40(s0)
   1118c:	04000893          	li	a7,64
   11190:	00070513          	mv	a0,a4
   11194:	00068593          	mv	a1,a3
   11198:	00060613          	mv	a2,a2
   1119c:	00000073          	ecall
   111a0:	00050793          	mv	a5,a0
   111a4:	fcf43c23          	sd	a5,-40(s0)
   111a8:	00001797          	auipc	a5,0x1
   111ac:	0b478793          	addi	a5,a5,180 # 1225c <tail>
   111b0:	0007a023          	sw	zero,0(a5)
   111b4:	fec42783          	lw	a5,-20(s0)
   111b8:	00078513          	mv	a0,a5
   111bc:	03813083          	ld	ra,56(sp)
   111c0:	03013403          	ld	s0,48(sp)
   111c4:	08010113          	addi	sp,sp,128
   111c8:	00008067          	ret
