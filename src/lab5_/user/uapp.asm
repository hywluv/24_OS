
uapp:     file format elf64-littleriscv


Disassembly of section .text:

00000000000100e8 <_start>:
   100e8:	0c00006f          	j	101a8 <main>

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

0000000000010120 <fork>:
   10120:	fe010113          	addi	sp,sp,-32
   10124:	00813c23          	sd	s0,24(sp)
   10128:	02010413          	addi	s0,sp,32
   1012c:	fe843783          	ld	a5,-24(s0)
   10130:	0dc00893          	li	a7,220
   10134:	00000073          	ecall
   10138:	00050793          	mv	a5,a0
   1013c:	fef43423          	sd	a5,-24(s0)
   10140:	fe843783          	ld	a5,-24(s0)
   10144:	00078513          	mv	a0,a5
   10148:	01813403          	ld	s0,24(sp)
   1014c:	02010113          	addi	sp,sp,32
   10150:	00008067          	ret

0000000000010154 <wait>:
   10154:	fd010113          	addi	sp,sp,-48
   10158:	02813423          	sd	s0,40(sp)
   1015c:	03010413          	addi	s0,sp,48
   10160:	00050793          	mv	a5,a0
   10164:	fcf42e23          	sw	a5,-36(s0)
   10168:	fe042623          	sw	zero,-20(s0)
   1016c:	0100006f          	j	1017c <wait+0x28>
   10170:	fec42783          	lw	a5,-20(s0)
   10174:	0017879b          	addiw	a5,a5,1
   10178:	fef42623          	sw	a5,-20(s0)
   1017c:	fec42783          	lw	a5,-20(s0)
   10180:	00078713          	mv	a4,a5
   10184:	fdc42783          	lw	a5,-36(s0)
   10188:	0007071b          	sext.w	a4,a4
   1018c:	0007879b          	sext.w	a5,a5
   10190:	fef760e3          	bltu	a4,a5,10170 <wait+0x1c>
   10194:	00000013          	nop
   10198:	00000013          	nop
   1019c:	02813403          	ld	s0,40(sp)
   101a0:	03010113          	addi	sp,sp,48
   101a4:	00008067          	ret

00000000000101a8 <main>:
   101a8:	fe010113          	addi	sp,sp,-32
   101ac:	00113c23          	sd	ra,24(sp)
   101b0:	00813823          	sd	s0,16(sp)
   101b4:	02010413          	addi	s0,sp,32
   101b8:	00000097          	auipc	ra,0x0
   101bc:	f68080e7          	jalr	-152(ra) # 10120 <fork>
   101c0:	00050793          	mv	a5,a0
   101c4:	fef42623          	sw	a5,-20(s0)
   101c8:	fec42783          	lw	a5,-20(s0)
   101cc:	0007879b          	sext.w	a5,a5
   101d0:	04079c63          	bnez	a5,10228 <main+0x80>
   101d4:	00000097          	auipc	ra,0x0
   101d8:	f18080e7          	jalr	-232(ra) # 100ec <getpid>
   101dc:	00050593          	mv	a1,a0
   101e0:	00002797          	auipc	a5,0x2
   101e4:	12878793          	addi	a5,a5,296 # 12308 <global_variable>
   101e8:	0007a783          	lw	a5,0(a5)
   101ec:	0017871b          	addiw	a4,a5,1
   101f0:	0007069b          	sext.w	a3,a4
   101f4:	00002717          	auipc	a4,0x2
   101f8:	11470713          	addi	a4,a4,276 # 12308 <global_variable>
   101fc:	00d72023          	sw	a3,0(a4)
   10200:	00078613          	mv	a2,a5
   10204:	00001517          	auipc	a0,0x1
   10208:	04450513          	addi	a0,a0,68 # 11248 <printf+0x100>
   1020c:	00001097          	auipc	ra,0x1
   10210:	f3c080e7          	jalr	-196(ra) # 11148 <printf>
   10214:	500007b7          	lui	a5,0x50000
   10218:	fff78513          	addi	a0,a5,-1 # 4fffffff <__global_pointer$+0x4ffed4fe>
   1021c:	00000097          	auipc	ra,0x0
   10220:	f38080e7          	jalr	-200(ra) # 10154 <wait>
   10224:	fb1ff06f          	j	101d4 <main+0x2c>
   10228:	00000097          	auipc	ra,0x0
   1022c:	ec4080e7          	jalr	-316(ra) # 100ec <getpid>
   10230:	00050593          	mv	a1,a0
   10234:	00002797          	auipc	a5,0x2
   10238:	0d478793          	addi	a5,a5,212 # 12308 <global_variable>
   1023c:	0007a783          	lw	a5,0(a5)
   10240:	0017871b          	addiw	a4,a5,1
   10244:	0007069b          	sext.w	a3,a4
   10248:	00002717          	auipc	a4,0x2
   1024c:	0c070713          	addi	a4,a4,192 # 12308 <global_variable>
   10250:	00d72023          	sw	a3,0(a4)
   10254:	00078613          	mv	a2,a5
   10258:	00001517          	auipc	a0,0x1
   1025c:	02850513          	addi	a0,a0,40 # 11280 <printf+0x138>
   10260:	00001097          	auipc	ra,0x1
   10264:	ee8080e7          	jalr	-280(ra) # 11148 <printf>
   10268:	500007b7          	lui	a5,0x50000
   1026c:	fff78513          	addi	a0,a5,-1 # 4fffffff <__global_pointer$+0x4ffed4fe>
   10270:	00000097          	auipc	ra,0x0
   10274:	ee4080e7          	jalr	-284(ra) # 10154 <wait>
   10278:	fb1ff06f          	j	10228 <main+0x80>

000000000001027c <putc>:
   1027c:	fe010113          	addi	sp,sp,-32
   10280:	00813c23          	sd	s0,24(sp)
   10284:	02010413          	addi	s0,sp,32
   10288:	00050793          	mv	a5,a0
   1028c:	fef42623          	sw	a5,-20(s0)
   10290:	00002797          	auipc	a5,0x2
   10294:	07c78793          	addi	a5,a5,124 # 1230c <tail>
   10298:	0007a783          	lw	a5,0(a5)
   1029c:	0017871b          	addiw	a4,a5,1
   102a0:	0007069b          	sext.w	a3,a4
   102a4:	00002717          	auipc	a4,0x2
   102a8:	06870713          	addi	a4,a4,104 # 1230c <tail>
   102ac:	00d72023          	sw	a3,0(a4)
   102b0:	fec42703          	lw	a4,-20(s0)
   102b4:	0ff77713          	zext.b	a4,a4
   102b8:	00002697          	auipc	a3,0x2
   102bc:	05868693          	addi	a3,a3,88 # 12310 <buffer>
   102c0:	00f687b3          	add	a5,a3,a5
   102c4:	00e78023          	sb	a4,0(a5)
   102c8:	fec42783          	lw	a5,-20(s0)
   102cc:	0ff7f793          	zext.b	a5,a5
   102d0:	0007879b          	sext.w	a5,a5
   102d4:	00078513          	mv	a0,a5
   102d8:	01813403          	ld	s0,24(sp)
   102dc:	02010113          	addi	sp,sp,32
   102e0:	00008067          	ret

00000000000102e4 <isspace>:
   102e4:	fe010113          	addi	sp,sp,-32
   102e8:	00813c23          	sd	s0,24(sp)
   102ec:	02010413          	addi	s0,sp,32
   102f0:	00050793          	mv	a5,a0
   102f4:	fef42623          	sw	a5,-20(s0)
   102f8:	fec42783          	lw	a5,-20(s0)
   102fc:	0007871b          	sext.w	a4,a5
   10300:	02000793          	li	a5,32
   10304:	02f70263          	beq	a4,a5,10328 <isspace+0x44>
   10308:	fec42783          	lw	a5,-20(s0)
   1030c:	0007871b          	sext.w	a4,a5
   10310:	00800793          	li	a5,8
   10314:	00e7de63          	bge	a5,a4,10330 <isspace+0x4c>
   10318:	fec42783          	lw	a5,-20(s0)
   1031c:	0007871b          	sext.w	a4,a5
   10320:	00d00793          	li	a5,13
   10324:	00e7c663          	blt	a5,a4,10330 <isspace+0x4c>
   10328:	00100793          	li	a5,1
   1032c:	0080006f          	j	10334 <isspace+0x50>
   10330:	00000793          	li	a5,0
   10334:	00078513          	mv	a0,a5
   10338:	01813403          	ld	s0,24(sp)
   1033c:	02010113          	addi	sp,sp,32
   10340:	00008067          	ret

0000000000010344 <strtol>:
   10344:	fb010113          	addi	sp,sp,-80
   10348:	04113423          	sd	ra,72(sp)
   1034c:	04813023          	sd	s0,64(sp)
   10350:	05010413          	addi	s0,sp,80
   10354:	fca43423          	sd	a0,-56(s0)
   10358:	fcb43023          	sd	a1,-64(s0)
   1035c:	00060793          	mv	a5,a2
   10360:	faf42e23          	sw	a5,-68(s0)
   10364:	fe043423          	sd	zero,-24(s0)
   10368:	fe0403a3          	sb	zero,-25(s0)
   1036c:	fc843783          	ld	a5,-56(s0)
   10370:	fcf43c23          	sd	a5,-40(s0)
   10374:	0100006f          	j	10384 <strtol+0x40>
   10378:	fd843783          	ld	a5,-40(s0)
   1037c:	00178793          	addi	a5,a5,1
   10380:	fcf43c23          	sd	a5,-40(s0)
   10384:	fd843783          	ld	a5,-40(s0)
   10388:	0007c783          	lbu	a5,0(a5)
   1038c:	0007879b          	sext.w	a5,a5
   10390:	00078513          	mv	a0,a5
   10394:	00000097          	auipc	ra,0x0
   10398:	f50080e7          	jalr	-176(ra) # 102e4 <isspace>
   1039c:	00050793          	mv	a5,a0
   103a0:	fc079ce3          	bnez	a5,10378 <strtol+0x34>
   103a4:	fd843783          	ld	a5,-40(s0)
   103a8:	0007c783          	lbu	a5,0(a5)
   103ac:	00078713          	mv	a4,a5
   103b0:	02d00793          	li	a5,45
   103b4:	00f71e63          	bne	a4,a5,103d0 <strtol+0x8c>
   103b8:	00100793          	li	a5,1
   103bc:	fef403a3          	sb	a5,-25(s0)
   103c0:	fd843783          	ld	a5,-40(s0)
   103c4:	00178793          	addi	a5,a5,1
   103c8:	fcf43c23          	sd	a5,-40(s0)
   103cc:	0240006f          	j	103f0 <strtol+0xac>
   103d0:	fd843783          	ld	a5,-40(s0)
   103d4:	0007c783          	lbu	a5,0(a5)
   103d8:	00078713          	mv	a4,a5
   103dc:	02b00793          	li	a5,43
   103e0:	00f71863          	bne	a4,a5,103f0 <strtol+0xac>
   103e4:	fd843783          	ld	a5,-40(s0)
   103e8:	00178793          	addi	a5,a5,1
   103ec:	fcf43c23          	sd	a5,-40(s0)
   103f0:	fbc42783          	lw	a5,-68(s0)
   103f4:	0007879b          	sext.w	a5,a5
   103f8:	06079c63          	bnez	a5,10470 <strtol+0x12c>
   103fc:	fd843783          	ld	a5,-40(s0)
   10400:	0007c783          	lbu	a5,0(a5)
   10404:	00078713          	mv	a4,a5
   10408:	03000793          	li	a5,48
   1040c:	04f71e63          	bne	a4,a5,10468 <strtol+0x124>
   10410:	fd843783          	ld	a5,-40(s0)
   10414:	00178793          	addi	a5,a5,1
   10418:	fcf43c23          	sd	a5,-40(s0)
   1041c:	fd843783          	ld	a5,-40(s0)
   10420:	0007c783          	lbu	a5,0(a5)
   10424:	00078713          	mv	a4,a5
   10428:	07800793          	li	a5,120
   1042c:	00f70c63          	beq	a4,a5,10444 <strtol+0x100>
   10430:	fd843783          	ld	a5,-40(s0)
   10434:	0007c783          	lbu	a5,0(a5)
   10438:	00078713          	mv	a4,a5
   1043c:	05800793          	li	a5,88
   10440:	00f71e63          	bne	a4,a5,1045c <strtol+0x118>
   10444:	01000793          	li	a5,16
   10448:	faf42e23          	sw	a5,-68(s0)
   1044c:	fd843783          	ld	a5,-40(s0)
   10450:	00178793          	addi	a5,a5,1
   10454:	fcf43c23          	sd	a5,-40(s0)
   10458:	0180006f          	j	10470 <strtol+0x12c>
   1045c:	00800793          	li	a5,8
   10460:	faf42e23          	sw	a5,-68(s0)
   10464:	00c0006f          	j	10470 <strtol+0x12c>
   10468:	00a00793          	li	a5,10
   1046c:	faf42e23          	sw	a5,-68(s0)
   10470:	fd843783          	ld	a5,-40(s0)
   10474:	0007c783          	lbu	a5,0(a5)
   10478:	00078713          	mv	a4,a5
   1047c:	02f00793          	li	a5,47
   10480:	02e7f863          	bgeu	a5,a4,104b0 <strtol+0x16c>
   10484:	fd843783          	ld	a5,-40(s0)
   10488:	0007c783          	lbu	a5,0(a5)
   1048c:	00078713          	mv	a4,a5
   10490:	03900793          	li	a5,57
   10494:	00e7ee63          	bltu	a5,a4,104b0 <strtol+0x16c>
   10498:	fd843783          	ld	a5,-40(s0)
   1049c:	0007c783          	lbu	a5,0(a5)
   104a0:	0007879b          	sext.w	a5,a5
   104a4:	fd07879b          	addiw	a5,a5,-48
   104a8:	fcf42a23          	sw	a5,-44(s0)
   104ac:	0800006f          	j	1052c <strtol+0x1e8>
   104b0:	fd843783          	ld	a5,-40(s0)
   104b4:	0007c783          	lbu	a5,0(a5)
   104b8:	00078713          	mv	a4,a5
   104bc:	06000793          	li	a5,96
   104c0:	02e7f863          	bgeu	a5,a4,104f0 <strtol+0x1ac>
   104c4:	fd843783          	ld	a5,-40(s0)
   104c8:	0007c783          	lbu	a5,0(a5)
   104cc:	00078713          	mv	a4,a5
   104d0:	07a00793          	li	a5,122
   104d4:	00e7ee63          	bltu	a5,a4,104f0 <strtol+0x1ac>
   104d8:	fd843783          	ld	a5,-40(s0)
   104dc:	0007c783          	lbu	a5,0(a5)
   104e0:	0007879b          	sext.w	a5,a5
   104e4:	fa97879b          	addiw	a5,a5,-87
   104e8:	fcf42a23          	sw	a5,-44(s0)
   104ec:	0400006f          	j	1052c <strtol+0x1e8>
   104f0:	fd843783          	ld	a5,-40(s0)
   104f4:	0007c783          	lbu	a5,0(a5)
   104f8:	00078713          	mv	a4,a5
   104fc:	04000793          	li	a5,64
   10500:	06e7f863          	bgeu	a5,a4,10570 <strtol+0x22c>
   10504:	fd843783          	ld	a5,-40(s0)
   10508:	0007c783          	lbu	a5,0(a5)
   1050c:	00078713          	mv	a4,a5
   10510:	05a00793          	li	a5,90
   10514:	04e7ee63          	bltu	a5,a4,10570 <strtol+0x22c>
   10518:	fd843783          	ld	a5,-40(s0)
   1051c:	0007c783          	lbu	a5,0(a5)
   10520:	0007879b          	sext.w	a5,a5
   10524:	fc97879b          	addiw	a5,a5,-55
   10528:	fcf42a23          	sw	a5,-44(s0)
   1052c:	fd442783          	lw	a5,-44(s0)
   10530:	00078713          	mv	a4,a5
   10534:	fbc42783          	lw	a5,-68(s0)
   10538:	0007071b          	sext.w	a4,a4
   1053c:	0007879b          	sext.w	a5,a5
   10540:	02f75663          	bge	a4,a5,1056c <strtol+0x228>
   10544:	fbc42703          	lw	a4,-68(s0)
   10548:	fe843783          	ld	a5,-24(s0)
   1054c:	02f70733          	mul	a4,a4,a5
   10550:	fd442783          	lw	a5,-44(s0)
   10554:	00f707b3          	add	a5,a4,a5
   10558:	fef43423          	sd	a5,-24(s0)
   1055c:	fd843783          	ld	a5,-40(s0)
   10560:	00178793          	addi	a5,a5,1
   10564:	fcf43c23          	sd	a5,-40(s0)
   10568:	f09ff06f          	j	10470 <strtol+0x12c>
   1056c:	00000013          	nop
   10570:	fc043783          	ld	a5,-64(s0)
   10574:	00078863          	beqz	a5,10584 <strtol+0x240>
   10578:	fc043783          	ld	a5,-64(s0)
   1057c:	fd843703          	ld	a4,-40(s0)
   10580:	00e7b023          	sd	a4,0(a5)
   10584:	fe744783          	lbu	a5,-25(s0)
   10588:	0ff7f793          	zext.b	a5,a5
   1058c:	00078863          	beqz	a5,1059c <strtol+0x258>
   10590:	fe843783          	ld	a5,-24(s0)
   10594:	40f007b3          	neg	a5,a5
   10598:	0080006f          	j	105a0 <strtol+0x25c>
   1059c:	fe843783          	ld	a5,-24(s0)
   105a0:	00078513          	mv	a0,a5
   105a4:	04813083          	ld	ra,72(sp)
   105a8:	04013403          	ld	s0,64(sp)
   105ac:	05010113          	addi	sp,sp,80
   105b0:	00008067          	ret

00000000000105b4 <puts_wo_nl>:
   105b4:	fd010113          	addi	sp,sp,-48
   105b8:	02113423          	sd	ra,40(sp)
   105bc:	02813023          	sd	s0,32(sp)
   105c0:	03010413          	addi	s0,sp,48
   105c4:	fca43c23          	sd	a0,-40(s0)
   105c8:	fcb43823          	sd	a1,-48(s0)
   105cc:	fd043783          	ld	a5,-48(s0)
   105d0:	00079863          	bnez	a5,105e0 <puts_wo_nl+0x2c>
   105d4:	00001797          	auipc	a5,0x1
   105d8:	ce478793          	addi	a5,a5,-796 # 112b8 <printf+0x170>
   105dc:	fcf43823          	sd	a5,-48(s0)
   105e0:	fd043783          	ld	a5,-48(s0)
   105e4:	fef43423          	sd	a5,-24(s0)
   105e8:	0240006f          	j	1060c <puts_wo_nl+0x58>
   105ec:	fe843783          	ld	a5,-24(s0)
   105f0:	00178713          	addi	a4,a5,1
   105f4:	fee43423          	sd	a4,-24(s0)
   105f8:	0007c783          	lbu	a5,0(a5)
   105fc:	0007871b          	sext.w	a4,a5
   10600:	fd843783          	ld	a5,-40(s0)
   10604:	00070513          	mv	a0,a4
   10608:	000780e7          	jalr	a5
   1060c:	fe843783          	ld	a5,-24(s0)
   10610:	0007c783          	lbu	a5,0(a5)
   10614:	fc079ce3          	bnez	a5,105ec <puts_wo_nl+0x38>
   10618:	fe843703          	ld	a4,-24(s0)
   1061c:	fd043783          	ld	a5,-48(s0)
   10620:	40f707b3          	sub	a5,a4,a5
   10624:	0007879b          	sext.w	a5,a5
   10628:	00078513          	mv	a0,a5
   1062c:	02813083          	ld	ra,40(sp)
   10630:	02013403          	ld	s0,32(sp)
   10634:	03010113          	addi	sp,sp,48
   10638:	00008067          	ret

000000000001063c <print_dec_int>:
   1063c:	f9010113          	addi	sp,sp,-112
   10640:	06113423          	sd	ra,104(sp)
   10644:	06813023          	sd	s0,96(sp)
   10648:	07010413          	addi	s0,sp,112
   1064c:	faa43423          	sd	a0,-88(s0)
   10650:	fab43023          	sd	a1,-96(s0)
   10654:	00060793          	mv	a5,a2
   10658:	f8d43823          	sd	a3,-112(s0)
   1065c:	f8f40fa3          	sb	a5,-97(s0)
   10660:	f9f44783          	lbu	a5,-97(s0)
   10664:	0ff7f793          	zext.b	a5,a5
   10668:	02078863          	beqz	a5,10698 <print_dec_int+0x5c>
   1066c:	fa043703          	ld	a4,-96(s0)
   10670:	fff00793          	li	a5,-1
   10674:	03f79793          	slli	a5,a5,0x3f
   10678:	02f71063          	bne	a4,a5,10698 <print_dec_int+0x5c>
   1067c:	00001597          	auipc	a1,0x1
   10680:	c4458593          	addi	a1,a1,-956 # 112c0 <printf+0x178>
   10684:	fa843503          	ld	a0,-88(s0)
   10688:	00000097          	auipc	ra,0x0
   1068c:	f2c080e7          	jalr	-212(ra) # 105b4 <puts_wo_nl>
   10690:	00050793          	mv	a5,a0
   10694:	2a00006f          	j	10934 <print_dec_int+0x2f8>
   10698:	f9043783          	ld	a5,-112(s0)
   1069c:	00c7a783          	lw	a5,12(a5)
   106a0:	00079a63          	bnez	a5,106b4 <print_dec_int+0x78>
   106a4:	fa043783          	ld	a5,-96(s0)
   106a8:	00079663          	bnez	a5,106b4 <print_dec_int+0x78>
   106ac:	00000793          	li	a5,0
   106b0:	2840006f          	j	10934 <print_dec_int+0x2f8>
   106b4:	fe0407a3          	sb	zero,-17(s0)
   106b8:	f9f44783          	lbu	a5,-97(s0)
   106bc:	0ff7f793          	zext.b	a5,a5
   106c0:	02078063          	beqz	a5,106e0 <print_dec_int+0xa4>
   106c4:	fa043783          	ld	a5,-96(s0)
   106c8:	0007dc63          	bgez	a5,106e0 <print_dec_int+0xa4>
   106cc:	00100793          	li	a5,1
   106d0:	fef407a3          	sb	a5,-17(s0)
   106d4:	fa043783          	ld	a5,-96(s0)
   106d8:	40f007b3          	neg	a5,a5
   106dc:	faf43023          	sd	a5,-96(s0)
   106e0:	fe042423          	sw	zero,-24(s0)
   106e4:	f9f44783          	lbu	a5,-97(s0)
   106e8:	0ff7f793          	zext.b	a5,a5
   106ec:	02078863          	beqz	a5,1071c <print_dec_int+0xe0>
   106f0:	fef44783          	lbu	a5,-17(s0)
   106f4:	0ff7f793          	zext.b	a5,a5
   106f8:	00079e63          	bnez	a5,10714 <print_dec_int+0xd8>
   106fc:	f9043783          	ld	a5,-112(s0)
   10700:	0057c783          	lbu	a5,5(a5)
   10704:	00079863          	bnez	a5,10714 <print_dec_int+0xd8>
   10708:	f9043783          	ld	a5,-112(s0)
   1070c:	0047c783          	lbu	a5,4(a5)
   10710:	00078663          	beqz	a5,1071c <print_dec_int+0xe0>
   10714:	00100793          	li	a5,1
   10718:	0080006f          	j	10720 <print_dec_int+0xe4>
   1071c:	00000793          	li	a5,0
   10720:	fcf40ba3          	sb	a5,-41(s0)
   10724:	fd744783          	lbu	a5,-41(s0)
   10728:	0017f793          	andi	a5,a5,1
   1072c:	fcf40ba3          	sb	a5,-41(s0)
   10730:	fa043703          	ld	a4,-96(s0)
   10734:	00a00793          	li	a5,10
   10738:	02f777b3          	remu	a5,a4,a5
   1073c:	0ff7f713          	zext.b	a4,a5
   10740:	fe842783          	lw	a5,-24(s0)
   10744:	0017869b          	addiw	a3,a5,1
   10748:	fed42423          	sw	a3,-24(s0)
   1074c:	0307071b          	addiw	a4,a4,48
   10750:	0ff77713          	zext.b	a4,a4
   10754:	ff078793          	addi	a5,a5,-16
   10758:	008787b3          	add	a5,a5,s0
   1075c:	fce78423          	sb	a4,-56(a5)
   10760:	fa043703          	ld	a4,-96(s0)
   10764:	00a00793          	li	a5,10
   10768:	02f757b3          	divu	a5,a4,a5
   1076c:	faf43023          	sd	a5,-96(s0)
   10770:	fa043783          	ld	a5,-96(s0)
   10774:	fa079ee3          	bnez	a5,10730 <print_dec_int+0xf4>
   10778:	f9043783          	ld	a5,-112(s0)
   1077c:	00c7a783          	lw	a5,12(a5)
   10780:	00078713          	mv	a4,a5
   10784:	fff00793          	li	a5,-1
   10788:	02f71063          	bne	a4,a5,107a8 <print_dec_int+0x16c>
   1078c:	f9043783          	ld	a5,-112(s0)
   10790:	0037c783          	lbu	a5,3(a5)
   10794:	00078a63          	beqz	a5,107a8 <print_dec_int+0x16c>
   10798:	f9043783          	ld	a5,-112(s0)
   1079c:	0087a703          	lw	a4,8(a5)
   107a0:	f9043783          	ld	a5,-112(s0)
   107a4:	00e7a623          	sw	a4,12(a5)
   107a8:	fe042223          	sw	zero,-28(s0)
   107ac:	f9043783          	ld	a5,-112(s0)
   107b0:	0087a703          	lw	a4,8(a5)
   107b4:	fe842783          	lw	a5,-24(s0)
   107b8:	fcf42823          	sw	a5,-48(s0)
   107bc:	f9043783          	ld	a5,-112(s0)
   107c0:	00c7a783          	lw	a5,12(a5)
   107c4:	fcf42623          	sw	a5,-52(s0)
   107c8:	fd042783          	lw	a5,-48(s0)
   107cc:	00078593          	mv	a1,a5
   107d0:	fcc42783          	lw	a5,-52(s0)
   107d4:	00078613          	mv	a2,a5
   107d8:	0006069b          	sext.w	a3,a2
   107dc:	0005879b          	sext.w	a5,a1
   107e0:	00f6d463          	bge	a3,a5,107e8 <print_dec_int+0x1ac>
   107e4:	00058613          	mv	a2,a1
   107e8:	0006079b          	sext.w	a5,a2
   107ec:	40f707bb          	subw	a5,a4,a5
   107f0:	0007871b          	sext.w	a4,a5
   107f4:	fd744783          	lbu	a5,-41(s0)
   107f8:	0007879b          	sext.w	a5,a5
   107fc:	40f707bb          	subw	a5,a4,a5
   10800:	fef42023          	sw	a5,-32(s0)
   10804:	0280006f          	j	1082c <print_dec_int+0x1f0>
   10808:	fa843783          	ld	a5,-88(s0)
   1080c:	02000513          	li	a0,32
   10810:	000780e7          	jalr	a5
   10814:	fe442783          	lw	a5,-28(s0)
   10818:	0017879b          	addiw	a5,a5,1
   1081c:	fef42223          	sw	a5,-28(s0)
   10820:	fe042783          	lw	a5,-32(s0)
   10824:	fff7879b          	addiw	a5,a5,-1
   10828:	fef42023          	sw	a5,-32(s0)
   1082c:	fe042783          	lw	a5,-32(s0)
   10830:	0007879b          	sext.w	a5,a5
   10834:	fcf04ae3          	bgtz	a5,10808 <print_dec_int+0x1cc>
   10838:	fd744783          	lbu	a5,-41(s0)
   1083c:	0ff7f793          	zext.b	a5,a5
   10840:	04078463          	beqz	a5,10888 <print_dec_int+0x24c>
   10844:	fef44783          	lbu	a5,-17(s0)
   10848:	0ff7f793          	zext.b	a5,a5
   1084c:	00078663          	beqz	a5,10858 <print_dec_int+0x21c>
   10850:	02d00793          	li	a5,45
   10854:	01c0006f          	j	10870 <print_dec_int+0x234>
   10858:	f9043783          	ld	a5,-112(s0)
   1085c:	0057c783          	lbu	a5,5(a5)
   10860:	00078663          	beqz	a5,1086c <print_dec_int+0x230>
   10864:	02b00793          	li	a5,43
   10868:	0080006f          	j	10870 <print_dec_int+0x234>
   1086c:	02000793          	li	a5,32
   10870:	fa843703          	ld	a4,-88(s0)
   10874:	00078513          	mv	a0,a5
   10878:	000700e7          	jalr	a4
   1087c:	fe442783          	lw	a5,-28(s0)
   10880:	0017879b          	addiw	a5,a5,1
   10884:	fef42223          	sw	a5,-28(s0)
   10888:	fe842783          	lw	a5,-24(s0)
   1088c:	fcf42e23          	sw	a5,-36(s0)
   10890:	0280006f          	j	108b8 <print_dec_int+0x27c>
   10894:	fa843783          	ld	a5,-88(s0)
   10898:	03000513          	li	a0,48
   1089c:	000780e7          	jalr	a5
   108a0:	fe442783          	lw	a5,-28(s0)
   108a4:	0017879b          	addiw	a5,a5,1
   108a8:	fef42223          	sw	a5,-28(s0)
   108ac:	fdc42783          	lw	a5,-36(s0)
   108b0:	0017879b          	addiw	a5,a5,1
   108b4:	fcf42e23          	sw	a5,-36(s0)
   108b8:	f9043783          	ld	a5,-112(s0)
   108bc:	00c7a703          	lw	a4,12(a5)
   108c0:	fd744783          	lbu	a5,-41(s0)
   108c4:	0007879b          	sext.w	a5,a5
   108c8:	40f707bb          	subw	a5,a4,a5
   108cc:	0007871b          	sext.w	a4,a5
   108d0:	fdc42783          	lw	a5,-36(s0)
   108d4:	0007879b          	sext.w	a5,a5
   108d8:	fae7cee3          	blt	a5,a4,10894 <print_dec_int+0x258>
   108dc:	fe842783          	lw	a5,-24(s0)
   108e0:	fff7879b          	addiw	a5,a5,-1
   108e4:	fcf42c23          	sw	a5,-40(s0)
   108e8:	03c0006f          	j	10924 <print_dec_int+0x2e8>
   108ec:	fd842783          	lw	a5,-40(s0)
   108f0:	ff078793          	addi	a5,a5,-16
   108f4:	008787b3          	add	a5,a5,s0
   108f8:	fc87c783          	lbu	a5,-56(a5)
   108fc:	0007871b          	sext.w	a4,a5
   10900:	fa843783          	ld	a5,-88(s0)
   10904:	00070513          	mv	a0,a4
   10908:	000780e7          	jalr	a5
   1090c:	fe442783          	lw	a5,-28(s0)
   10910:	0017879b          	addiw	a5,a5,1
   10914:	fef42223          	sw	a5,-28(s0)
   10918:	fd842783          	lw	a5,-40(s0)
   1091c:	fff7879b          	addiw	a5,a5,-1
   10920:	fcf42c23          	sw	a5,-40(s0)
   10924:	fd842783          	lw	a5,-40(s0)
   10928:	0007879b          	sext.w	a5,a5
   1092c:	fc07d0e3          	bgez	a5,108ec <print_dec_int+0x2b0>
   10930:	fe442783          	lw	a5,-28(s0)
   10934:	00078513          	mv	a0,a5
   10938:	06813083          	ld	ra,104(sp)
   1093c:	06013403          	ld	s0,96(sp)
   10940:	07010113          	addi	sp,sp,112
   10944:	00008067          	ret

0000000000010948 <vprintfmt>:
   10948:	f4010113          	addi	sp,sp,-192
   1094c:	0a113c23          	sd	ra,184(sp)
   10950:	0a813823          	sd	s0,176(sp)
   10954:	0c010413          	addi	s0,sp,192
   10958:	f4a43c23          	sd	a0,-168(s0)
   1095c:	f4b43823          	sd	a1,-176(s0)
   10960:	f4c43423          	sd	a2,-184(s0)
   10964:	f8043023          	sd	zero,-128(s0)
   10968:	f8043423          	sd	zero,-120(s0)
   1096c:	fe042623          	sw	zero,-20(s0)
   10970:	7b40006f          	j	11124 <vprintfmt+0x7dc>
   10974:	f8044783          	lbu	a5,-128(s0)
   10978:	74078663          	beqz	a5,110c4 <vprintfmt+0x77c>
   1097c:	f5043783          	ld	a5,-176(s0)
   10980:	0007c783          	lbu	a5,0(a5)
   10984:	00078713          	mv	a4,a5
   10988:	02300793          	li	a5,35
   1098c:	00f71863          	bne	a4,a5,1099c <vprintfmt+0x54>
   10990:	00100793          	li	a5,1
   10994:	f8f40123          	sb	a5,-126(s0)
   10998:	7800006f          	j	11118 <vprintfmt+0x7d0>
   1099c:	f5043783          	ld	a5,-176(s0)
   109a0:	0007c783          	lbu	a5,0(a5)
   109a4:	00078713          	mv	a4,a5
   109a8:	03000793          	li	a5,48
   109ac:	00f71863          	bne	a4,a5,109bc <vprintfmt+0x74>
   109b0:	00100793          	li	a5,1
   109b4:	f8f401a3          	sb	a5,-125(s0)
   109b8:	7600006f          	j	11118 <vprintfmt+0x7d0>
   109bc:	f5043783          	ld	a5,-176(s0)
   109c0:	0007c783          	lbu	a5,0(a5)
   109c4:	00078713          	mv	a4,a5
   109c8:	06c00793          	li	a5,108
   109cc:	04f70063          	beq	a4,a5,10a0c <vprintfmt+0xc4>
   109d0:	f5043783          	ld	a5,-176(s0)
   109d4:	0007c783          	lbu	a5,0(a5)
   109d8:	00078713          	mv	a4,a5
   109dc:	07a00793          	li	a5,122
   109e0:	02f70663          	beq	a4,a5,10a0c <vprintfmt+0xc4>
   109e4:	f5043783          	ld	a5,-176(s0)
   109e8:	0007c783          	lbu	a5,0(a5)
   109ec:	00078713          	mv	a4,a5
   109f0:	07400793          	li	a5,116
   109f4:	00f70c63          	beq	a4,a5,10a0c <vprintfmt+0xc4>
   109f8:	f5043783          	ld	a5,-176(s0)
   109fc:	0007c783          	lbu	a5,0(a5)
   10a00:	00078713          	mv	a4,a5
   10a04:	06a00793          	li	a5,106
   10a08:	00f71863          	bne	a4,a5,10a18 <vprintfmt+0xd0>
   10a0c:	00100793          	li	a5,1
   10a10:	f8f400a3          	sb	a5,-127(s0)
   10a14:	7040006f          	j	11118 <vprintfmt+0x7d0>
   10a18:	f5043783          	ld	a5,-176(s0)
   10a1c:	0007c783          	lbu	a5,0(a5)
   10a20:	00078713          	mv	a4,a5
   10a24:	02b00793          	li	a5,43
   10a28:	00f71863          	bne	a4,a5,10a38 <vprintfmt+0xf0>
   10a2c:	00100793          	li	a5,1
   10a30:	f8f402a3          	sb	a5,-123(s0)
   10a34:	6e40006f          	j	11118 <vprintfmt+0x7d0>
   10a38:	f5043783          	ld	a5,-176(s0)
   10a3c:	0007c783          	lbu	a5,0(a5)
   10a40:	00078713          	mv	a4,a5
   10a44:	02000793          	li	a5,32
   10a48:	00f71863          	bne	a4,a5,10a58 <vprintfmt+0x110>
   10a4c:	00100793          	li	a5,1
   10a50:	f8f40223          	sb	a5,-124(s0)
   10a54:	6c40006f          	j	11118 <vprintfmt+0x7d0>
   10a58:	f5043783          	ld	a5,-176(s0)
   10a5c:	0007c783          	lbu	a5,0(a5)
   10a60:	00078713          	mv	a4,a5
   10a64:	02a00793          	li	a5,42
   10a68:	00f71e63          	bne	a4,a5,10a84 <vprintfmt+0x13c>
   10a6c:	f4843783          	ld	a5,-184(s0)
   10a70:	00878713          	addi	a4,a5,8
   10a74:	f4e43423          	sd	a4,-184(s0)
   10a78:	0007a783          	lw	a5,0(a5)
   10a7c:	f8f42423          	sw	a5,-120(s0)
   10a80:	6980006f          	j	11118 <vprintfmt+0x7d0>
   10a84:	f5043783          	ld	a5,-176(s0)
   10a88:	0007c783          	lbu	a5,0(a5)
   10a8c:	00078713          	mv	a4,a5
   10a90:	03000793          	li	a5,48
   10a94:	04e7f863          	bgeu	a5,a4,10ae4 <vprintfmt+0x19c>
   10a98:	f5043783          	ld	a5,-176(s0)
   10a9c:	0007c783          	lbu	a5,0(a5)
   10aa0:	00078713          	mv	a4,a5
   10aa4:	03900793          	li	a5,57
   10aa8:	02e7ee63          	bltu	a5,a4,10ae4 <vprintfmt+0x19c>
   10aac:	f5043783          	ld	a5,-176(s0)
   10ab0:	f5040713          	addi	a4,s0,-176
   10ab4:	00a00613          	li	a2,10
   10ab8:	00070593          	mv	a1,a4
   10abc:	00078513          	mv	a0,a5
   10ac0:	00000097          	auipc	ra,0x0
   10ac4:	884080e7          	jalr	-1916(ra) # 10344 <strtol>
   10ac8:	00050793          	mv	a5,a0
   10acc:	0007879b          	sext.w	a5,a5
   10ad0:	f8f42423          	sw	a5,-120(s0)
   10ad4:	f5043783          	ld	a5,-176(s0)
   10ad8:	fff78793          	addi	a5,a5,-1
   10adc:	f4f43823          	sd	a5,-176(s0)
   10ae0:	6380006f          	j	11118 <vprintfmt+0x7d0>
   10ae4:	f5043783          	ld	a5,-176(s0)
   10ae8:	0007c783          	lbu	a5,0(a5)
   10aec:	00078713          	mv	a4,a5
   10af0:	02e00793          	li	a5,46
   10af4:	06f71a63          	bne	a4,a5,10b68 <vprintfmt+0x220>
   10af8:	f5043783          	ld	a5,-176(s0)
   10afc:	00178793          	addi	a5,a5,1
   10b00:	f4f43823          	sd	a5,-176(s0)
   10b04:	f5043783          	ld	a5,-176(s0)
   10b08:	0007c783          	lbu	a5,0(a5)
   10b0c:	00078713          	mv	a4,a5
   10b10:	02a00793          	li	a5,42
   10b14:	00f71e63          	bne	a4,a5,10b30 <vprintfmt+0x1e8>
   10b18:	f4843783          	ld	a5,-184(s0)
   10b1c:	00878713          	addi	a4,a5,8
   10b20:	f4e43423          	sd	a4,-184(s0)
   10b24:	0007a783          	lw	a5,0(a5)
   10b28:	f8f42623          	sw	a5,-116(s0)
   10b2c:	5ec0006f          	j	11118 <vprintfmt+0x7d0>
   10b30:	f5043783          	ld	a5,-176(s0)
   10b34:	f5040713          	addi	a4,s0,-176
   10b38:	00a00613          	li	a2,10
   10b3c:	00070593          	mv	a1,a4
   10b40:	00078513          	mv	a0,a5
   10b44:	00000097          	auipc	ra,0x0
   10b48:	800080e7          	jalr	-2048(ra) # 10344 <strtol>
   10b4c:	00050793          	mv	a5,a0
   10b50:	0007879b          	sext.w	a5,a5
   10b54:	f8f42623          	sw	a5,-116(s0)
   10b58:	f5043783          	ld	a5,-176(s0)
   10b5c:	fff78793          	addi	a5,a5,-1
   10b60:	f4f43823          	sd	a5,-176(s0)
   10b64:	5b40006f          	j	11118 <vprintfmt+0x7d0>
   10b68:	f5043783          	ld	a5,-176(s0)
   10b6c:	0007c783          	lbu	a5,0(a5)
   10b70:	00078713          	mv	a4,a5
   10b74:	07800793          	li	a5,120
   10b78:	02f70663          	beq	a4,a5,10ba4 <vprintfmt+0x25c>
   10b7c:	f5043783          	ld	a5,-176(s0)
   10b80:	0007c783          	lbu	a5,0(a5)
   10b84:	00078713          	mv	a4,a5
   10b88:	05800793          	li	a5,88
   10b8c:	00f70c63          	beq	a4,a5,10ba4 <vprintfmt+0x25c>
   10b90:	f5043783          	ld	a5,-176(s0)
   10b94:	0007c783          	lbu	a5,0(a5)
   10b98:	00078713          	mv	a4,a5
   10b9c:	07000793          	li	a5,112
   10ba0:	30f71263          	bne	a4,a5,10ea4 <vprintfmt+0x55c>
   10ba4:	f5043783          	ld	a5,-176(s0)
   10ba8:	0007c783          	lbu	a5,0(a5)
   10bac:	00078713          	mv	a4,a5
   10bb0:	07000793          	li	a5,112
   10bb4:	00f70663          	beq	a4,a5,10bc0 <vprintfmt+0x278>
   10bb8:	f8144783          	lbu	a5,-127(s0)
   10bbc:	00078663          	beqz	a5,10bc8 <vprintfmt+0x280>
   10bc0:	00100793          	li	a5,1
   10bc4:	0080006f          	j	10bcc <vprintfmt+0x284>
   10bc8:	00000793          	li	a5,0
   10bcc:	faf403a3          	sb	a5,-89(s0)
   10bd0:	fa744783          	lbu	a5,-89(s0)
   10bd4:	0017f793          	andi	a5,a5,1
   10bd8:	faf403a3          	sb	a5,-89(s0)
   10bdc:	fa744783          	lbu	a5,-89(s0)
   10be0:	0ff7f793          	zext.b	a5,a5
   10be4:	00078c63          	beqz	a5,10bfc <vprintfmt+0x2b4>
   10be8:	f4843783          	ld	a5,-184(s0)
   10bec:	00878713          	addi	a4,a5,8
   10bf0:	f4e43423          	sd	a4,-184(s0)
   10bf4:	0007b783          	ld	a5,0(a5)
   10bf8:	01c0006f          	j	10c14 <vprintfmt+0x2cc>
   10bfc:	f4843783          	ld	a5,-184(s0)
   10c00:	00878713          	addi	a4,a5,8
   10c04:	f4e43423          	sd	a4,-184(s0)
   10c08:	0007a783          	lw	a5,0(a5)
   10c0c:	02079793          	slli	a5,a5,0x20
   10c10:	0207d793          	srli	a5,a5,0x20
   10c14:	fef43023          	sd	a5,-32(s0)
   10c18:	f8c42783          	lw	a5,-116(s0)
   10c1c:	02079463          	bnez	a5,10c44 <vprintfmt+0x2fc>
   10c20:	fe043783          	ld	a5,-32(s0)
   10c24:	02079063          	bnez	a5,10c44 <vprintfmt+0x2fc>
   10c28:	f5043783          	ld	a5,-176(s0)
   10c2c:	0007c783          	lbu	a5,0(a5)
   10c30:	00078713          	mv	a4,a5
   10c34:	07000793          	li	a5,112
   10c38:	00f70663          	beq	a4,a5,10c44 <vprintfmt+0x2fc>
   10c3c:	f8040023          	sb	zero,-128(s0)
   10c40:	4d80006f          	j	11118 <vprintfmt+0x7d0>
   10c44:	f5043783          	ld	a5,-176(s0)
   10c48:	0007c783          	lbu	a5,0(a5)
   10c4c:	00078713          	mv	a4,a5
   10c50:	07000793          	li	a5,112
   10c54:	00f70a63          	beq	a4,a5,10c68 <vprintfmt+0x320>
   10c58:	f8244783          	lbu	a5,-126(s0)
   10c5c:	00078a63          	beqz	a5,10c70 <vprintfmt+0x328>
   10c60:	fe043783          	ld	a5,-32(s0)
   10c64:	00078663          	beqz	a5,10c70 <vprintfmt+0x328>
   10c68:	00100793          	li	a5,1
   10c6c:	0080006f          	j	10c74 <vprintfmt+0x32c>
   10c70:	00000793          	li	a5,0
   10c74:	faf40323          	sb	a5,-90(s0)
   10c78:	fa644783          	lbu	a5,-90(s0)
   10c7c:	0017f793          	andi	a5,a5,1
   10c80:	faf40323          	sb	a5,-90(s0)
   10c84:	fc042e23          	sw	zero,-36(s0)
   10c88:	f5043783          	ld	a5,-176(s0)
   10c8c:	0007c783          	lbu	a5,0(a5)
   10c90:	00078713          	mv	a4,a5
   10c94:	05800793          	li	a5,88
   10c98:	00f71863          	bne	a4,a5,10ca8 <vprintfmt+0x360>
   10c9c:	00000797          	auipc	a5,0x0
   10ca0:	63c78793          	addi	a5,a5,1596 # 112d8 <upperxdigits.1>
   10ca4:	00c0006f          	j	10cb0 <vprintfmt+0x368>
   10ca8:	00000797          	auipc	a5,0x0
   10cac:	64878793          	addi	a5,a5,1608 # 112f0 <lowerxdigits.0>
   10cb0:	f8f43c23          	sd	a5,-104(s0)
   10cb4:	fe043783          	ld	a5,-32(s0)
   10cb8:	00f7f793          	andi	a5,a5,15
   10cbc:	f9843703          	ld	a4,-104(s0)
   10cc0:	00f70733          	add	a4,a4,a5
   10cc4:	fdc42783          	lw	a5,-36(s0)
   10cc8:	0017869b          	addiw	a3,a5,1
   10ccc:	fcd42e23          	sw	a3,-36(s0)
   10cd0:	00074703          	lbu	a4,0(a4)
   10cd4:	ff078793          	addi	a5,a5,-16
   10cd8:	008787b3          	add	a5,a5,s0
   10cdc:	f8e78023          	sb	a4,-128(a5)
   10ce0:	fe043783          	ld	a5,-32(s0)
   10ce4:	0047d793          	srli	a5,a5,0x4
   10ce8:	fef43023          	sd	a5,-32(s0)
   10cec:	fe043783          	ld	a5,-32(s0)
   10cf0:	fc0792e3          	bnez	a5,10cb4 <vprintfmt+0x36c>
   10cf4:	f8c42783          	lw	a5,-116(s0)
   10cf8:	00078713          	mv	a4,a5
   10cfc:	fff00793          	li	a5,-1
   10d00:	02f71663          	bne	a4,a5,10d2c <vprintfmt+0x3e4>
   10d04:	f8344783          	lbu	a5,-125(s0)
   10d08:	02078263          	beqz	a5,10d2c <vprintfmt+0x3e4>
   10d0c:	f8842703          	lw	a4,-120(s0)
   10d10:	fa644783          	lbu	a5,-90(s0)
   10d14:	0007879b          	sext.w	a5,a5
   10d18:	0017979b          	slliw	a5,a5,0x1
   10d1c:	0007879b          	sext.w	a5,a5
   10d20:	40f707bb          	subw	a5,a4,a5
   10d24:	0007879b          	sext.w	a5,a5
   10d28:	f8f42623          	sw	a5,-116(s0)
   10d2c:	f8842703          	lw	a4,-120(s0)
   10d30:	fa644783          	lbu	a5,-90(s0)
   10d34:	0007879b          	sext.w	a5,a5
   10d38:	0017979b          	slliw	a5,a5,0x1
   10d3c:	0007879b          	sext.w	a5,a5
   10d40:	40f707bb          	subw	a5,a4,a5
   10d44:	0007871b          	sext.w	a4,a5
   10d48:	fdc42783          	lw	a5,-36(s0)
   10d4c:	f8f42a23          	sw	a5,-108(s0)
   10d50:	f8c42783          	lw	a5,-116(s0)
   10d54:	f8f42823          	sw	a5,-112(s0)
   10d58:	f9442783          	lw	a5,-108(s0)
   10d5c:	00078593          	mv	a1,a5
   10d60:	f9042783          	lw	a5,-112(s0)
   10d64:	00078613          	mv	a2,a5
   10d68:	0006069b          	sext.w	a3,a2
   10d6c:	0005879b          	sext.w	a5,a1
   10d70:	00f6d463          	bge	a3,a5,10d78 <vprintfmt+0x430>
   10d74:	00058613          	mv	a2,a1
   10d78:	0006079b          	sext.w	a5,a2
   10d7c:	40f707bb          	subw	a5,a4,a5
   10d80:	fcf42c23          	sw	a5,-40(s0)
   10d84:	0280006f          	j	10dac <vprintfmt+0x464>
   10d88:	f5843783          	ld	a5,-168(s0)
   10d8c:	02000513          	li	a0,32
   10d90:	000780e7          	jalr	a5
   10d94:	fec42783          	lw	a5,-20(s0)
   10d98:	0017879b          	addiw	a5,a5,1
   10d9c:	fef42623          	sw	a5,-20(s0)
   10da0:	fd842783          	lw	a5,-40(s0)
   10da4:	fff7879b          	addiw	a5,a5,-1
   10da8:	fcf42c23          	sw	a5,-40(s0)
   10dac:	fd842783          	lw	a5,-40(s0)
   10db0:	0007879b          	sext.w	a5,a5
   10db4:	fcf04ae3          	bgtz	a5,10d88 <vprintfmt+0x440>
   10db8:	fa644783          	lbu	a5,-90(s0)
   10dbc:	0ff7f793          	zext.b	a5,a5
   10dc0:	04078463          	beqz	a5,10e08 <vprintfmt+0x4c0>
   10dc4:	f5843783          	ld	a5,-168(s0)
   10dc8:	03000513          	li	a0,48
   10dcc:	000780e7          	jalr	a5
   10dd0:	f5043783          	ld	a5,-176(s0)
   10dd4:	0007c783          	lbu	a5,0(a5)
   10dd8:	00078713          	mv	a4,a5
   10ddc:	05800793          	li	a5,88
   10de0:	00f71663          	bne	a4,a5,10dec <vprintfmt+0x4a4>
   10de4:	05800793          	li	a5,88
   10de8:	0080006f          	j	10df0 <vprintfmt+0x4a8>
   10dec:	07800793          	li	a5,120
   10df0:	f5843703          	ld	a4,-168(s0)
   10df4:	00078513          	mv	a0,a5
   10df8:	000700e7          	jalr	a4
   10dfc:	fec42783          	lw	a5,-20(s0)
   10e00:	0027879b          	addiw	a5,a5,2
   10e04:	fef42623          	sw	a5,-20(s0)
   10e08:	fdc42783          	lw	a5,-36(s0)
   10e0c:	fcf42a23          	sw	a5,-44(s0)
   10e10:	0280006f          	j	10e38 <vprintfmt+0x4f0>
   10e14:	f5843783          	ld	a5,-168(s0)
   10e18:	03000513          	li	a0,48
   10e1c:	000780e7          	jalr	a5
   10e20:	fec42783          	lw	a5,-20(s0)
   10e24:	0017879b          	addiw	a5,a5,1
   10e28:	fef42623          	sw	a5,-20(s0)
   10e2c:	fd442783          	lw	a5,-44(s0)
   10e30:	0017879b          	addiw	a5,a5,1
   10e34:	fcf42a23          	sw	a5,-44(s0)
   10e38:	f8c42703          	lw	a4,-116(s0)
   10e3c:	fd442783          	lw	a5,-44(s0)
   10e40:	0007879b          	sext.w	a5,a5
   10e44:	fce7c8e3          	blt	a5,a4,10e14 <vprintfmt+0x4cc>
   10e48:	fdc42783          	lw	a5,-36(s0)
   10e4c:	fff7879b          	addiw	a5,a5,-1
   10e50:	fcf42823          	sw	a5,-48(s0)
   10e54:	03c0006f          	j	10e90 <vprintfmt+0x548>
   10e58:	fd042783          	lw	a5,-48(s0)
   10e5c:	ff078793          	addi	a5,a5,-16
   10e60:	008787b3          	add	a5,a5,s0
   10e64:	f807c783          	lbu	a5,-128(a5)
   10e68:	0007871b          	sext.w	a4,a5
   10e6c:	f5843783          	ld	a5,-168(s0)
   10e70:	00070513          	mv	a0,a4
   10e74:	000780e7          	jalr	a5
   10e78:	fec42783          	lw	a5,-20(s0)
   10e7c:	0017879b          	addiw	a5,a5,1
   10e80:	fef42623          	sw	a5,-20(s0)
   10e84:	fd042783          	lw	a5,-48(s0)
   10e88:	fff7879b          	addiw	a5,a5,-1
   10e8c:	fcf42823          	sw	a5,-48(s0)
   10e90:	fd042783          	lw	a5,-48(s0)
   10e94:	0007879b          	sext.w	a5,a5
   10e98:	fc07d0e3          	bgez	a5,10e58 <vprintfmt+0x510>
   10e9c:	f8040023          	sb	zero,-128(s0)
   10ea0:	2780006f          	j	11118 <vprintfmt+0x7d0>
   10ea4:	f5043783          	ld	a5,-176(s0)
   10ea8:	0007c783          	lbu	a5,0(a5)
   10eac:	00078713          	mv	a4,a5
   10eb0:	06400793          	li	a5,100
   10eb4:	02f70663          	beq	a4,a5,10ee0 <vprintfmt+0x598>
   10eb8:	f5043783          	ld	a5,-176(s0)
   10ebc:	0007c783          	lbu	a5,0(a5)
   10ec0:	00078713          	mv	a4,a5
   10ec4:	06900793          	li	a5,105
   10ec8:	00f70c63          	beq	a4,a5,10ee0 <vprintfmt+0x598>
   10ecc:	f5043783          	ld	a5,-176(s0)
   10ed0:	0007c783          	lbu	a5,0(a5)
   10ed4:	00078713          	mv	a4,a5
   10ed8:	07500793          	li	a5,117
   10edc:	08f71263          	bne	a4,a5,10f60 <vprintfmt+0x618>
   10ee0:	f8144783          	lbu	a5,-127(s0)
   10ee4:	00078c63          	beqz	a5,10efc <vprintfmt+0x5b4>
   10ee8:	f4843783          	ld	a5,-184(s0)
   10eec:	00878713          	addi	a4,a5,8
   10ef0:	f4e43423          	sd	a4,-184(s0)
   10ef4:	0007b783          	ld	a5,0(a5)
   10ef8:	0140006f          	j	10f0c <vprintfmt+0x5c4>
   10efc:	f4843783          	ld	a5,-184(s0)
   10f00:	00878713          	addi	a4,a5,8
   10f04:	f4e43423          	sd	a4,-184(s0)
   10f08:	0007a783          	lw	a5,0(a5)
   10f0c:	faf43423          	sd	a5,-88(s0)
   10f10:	fa843583          	ld	a1,-88(s0)
   10f14:	f5043783          	ld	a5,-176(s0)
   10f18:	0007c783          	lbu	a5,0(a5)
   10f1c:	0007871b          	sext.w	a4,a5
   10f20:	07500793          	li	a5,117
   10f24:	40f707b3          	sub	a5,a4,a5
   10f28:	00f037b3          	snez	a5,a5
   10f2c:	0ff7f793          	zext.b	a5,a5
   10f30:	f8040713          	addi	a4,s0,-128
   10f34:	00070693          	mv	a3,a4
   10f38:	00078613          	mv	a2,a5
   10f3c:	f5843503          	ld	a0,-168(s0)
   10f40:	fffff097          	auipc	ra,0xfffff
   10f44:	6fc080e7          	jalr	1788(ra) # 1063c <print_dec_int>
   10f48:	00050793          	mv	a5,a0
   10f4c:	fec42703          	lw	a4,-20(s0)
   10f50:	00f707bb          	addw	a5,a4,a5
   10f54:	fef42623          	sw	a5,-20(s0)
   10f58:	f8040023          	sb	zero,-128(s0)
   10f5c:	1bc0006f          	j	11118 <vprintfmt+0x7d0>
   10f60:	f5043783          	ld	a5,-176(s0)
   10f64:	0007c783          	lbu	a5,0(a5)
   10f68:	00078713          	mv	a4,a5
   10f6c:	06e00793          	li	a5,110
   10f70:	04f71c63          	bne	a4,a5,10fc8 <vprintfmt+0x680>
   10f74:	f8144783          	lbu	a5,-127(s0)
   10f78:	02078463          	beqz	a5,10fa0 <vprintfmt+0x658>
   10f7c:	f4843783          	ld	a5,-184(s0)
   10f80:	00878713          	addi	a4,a5,8
   10f84:	f4e43423          	sd	a4,-184(s0)
   10f88:	0007b783          	ld	a5,0(a5)
   10f8c:	faf43823          	sd	a5,-80(s0)
   10f90:	fec42703          	lw	a4,-20(s0)
   10f94:	fb043783          	ld	a5,-80(s0)
   10f98:	00e7b023          	sd	a4,0(a5)
   10f9c:	0240006f          	j	10fc0 <vprintfmt+0x678>
   10fa0:	f4843783          	ld	a5,-184(s0)
   10fa4:	00878713          	addi	a4,a5,8
   10fa8:	f4e43423          	sd	a4,-184(s0)
   10fac:	0007b783          	ld	a5,0(a5)
   10fb0:	faf43c23          	sd	a5,-72(s0)
   10fb4:	fb843783          	ld	a5,-72(s0)
   10fb8:	fec42703          	lw	a4,-20(s0)
   10fbc:	00e7a023          	sw	a4,0(a5)
   10fc0:	f8040023          	sb	zero,-128(s0)
   10fc4:	1540006f          	j	11118 <vprintfmt+0x7d0>
   10fc8:	f5043783          	ld	a5,-176(s0)
   10fcc:	0007c783          	lbu	a5,0(a5)
   10fd0:	00078713          	mv	a4,a5
   10fd4:	07300793          	li	a5,115
   10fd8:	04f71063          	bne	a4,a5,11018 <vprintfmt+0x6d0>
   10fdc:	f4843783          	ld	a5,-184(s0)
   10fe0:	00878713          	addi	a4,a5,8
   10fe4:	f4e43423          	sd	a4,-184(s0)
   10fe8:	0007b783          	ld	a5,0(a5)
   10fec:	fcf43023          	sd	a5,-64(s0)
   10ff0:	fc043583          	ld	a1,-64(s0)
   10ff4:	f5843503          	ld	a0,-168(s0)
   10ff8:	fffff097          	auipc	ra,0xfffff
   10ffc:	5bc080e7          	jalr	1468(ra) # 105b4 <puts_wo_nl>
   11000:	00050793          	mv	a5,a0
   11004:	fec42703          	lw	a4,-20(s0)
   11008:	00f707bb          	addw	a5,a4,a5
   1100c:	fef42623          	sw	a5,-20(s0)
   11010:	f8040023          	sb	zero,-128(s0)
   11014:	1040006f          	j	11118 <vprintfmt+0x7d0>
   11018:	f5043783          	ld	a5,-176(s0)
   1101c:	0007c783          	lbu	a5,0(a5)
   11020:	00078713          	mv	a4,a5
   11024:	06300793          	li	a5,99
   11028:	02f71e63          	bne	a4,a5,11064 <vprintfmt+0x71c>
   1102c:	f4843783          	ld	a5,-184(s0)
   11030:	00878713          	addi	a4,a5,8
   11034:	f4e43423          	sd	a4,-184(s0)
   11038:	0007a783          	lw	a5,0(a5)
   1103c:	fcf42623          	sw	a5,-52(s0)
   11040:	fcc42703          	lw	a4,-52(s0)
   11044:	f5843783          	ld	a5,-168(s0)
   11048:	00070513          	mv	a0,a4
   1104c:	000780e7          	jalr	a5
   11050:	fec42783          	lw	a5,-20(s0)
   11054:	0017879b          	addiw	a5,a5,1
   11058:	fef42623          	sw	a5,-20(s0)
   1105c:	f8040023          	sb	zero,-128(s0)
   11060:	0b80006f          	j	11118 <vprintfmt+0x7d0>
   11064:	f5043783          	ld	a5,-176(s0)
   11068:	0007c783          	lbu	a5,0(a5)
   1106c:	00078713          	mv	a4,a5
   11070:	02500793          	li	a5,37
   11074:	02f71263          	bne	a4,a5,11098 <vprintfmt+0x750>
   11078:	f5843783          	ld	a5,-168(s0)
   1107c:	02500513          	li	a0,37
   11080:	000780e7          	jalr	a5
   11084:	fec42783          	lw	a5,-20(s0)
   11088:	0017879b          	addiw	a5,a5,1
   1108c:	fef42623          	sw	a5,-20(s0)
   11090:	f8040023          	sb	zero,-128(s0)
   11094:	0840006f          	j	11118 <vprintfmt+0x7d0>
   11098:	f5043783          	ld	a5,-176(s0)
   1109c:	0007c783          	lbu	a5,0(a5)
   110a0:	0007871b          	sext.w	a4,a5
   110a4:	f5843783          	ld	a5,-168(s0)
   110a8:	00070513          	mv	a0,a4
   110ac:	000780e7          	jalr	a5
   110b0:	fec42783          	lw	a5,-20(s0)
   110b4:	0017879b          	addiw	a5,a5,1
   110b8:	fef42623          	sw	a5,-20(s0)
   110bc:	f8040023          	sb	zero,-128(s0)
   110c0:	0580006f          	j	11118 <vprintfmt+0x7d0>
   110c4:	f5043783          	ld	a5,-176(s0)
   110c8:	0007c783          	lbu	a5,0(a5)
   110cc:	00078713          	mv	a4,a5
   110d0:	02500793          	li	a5,37
   110d4:	02f71063          	bne	a4,a5,110f4 <vprintfmt+0x7ac>
   110d8:	f8043023          	sd	zero,-128(s0)
   110dc:	f8043423          	sd	zero,-120(s0)
   110e0:	00100793          	li	a5,1
   110e4:	f8f40023          	sb	a5,-128(s0)
   110e8:	fff00793          	li	a5,-1
   110ec:	f8f42623          	sw	a5,-116(s0)
   110f0:	0280006f          	j	11118 <vprintfmt+0x7d0>
   110f4:	f5043783          	ld	a5,-176(s0)
   110f8:	0007c783          	lbu	a5,0(a5)
   110fc:	0007871b          	sext.w	a4,a5
   11100:	f5843783          	ld	a5,-168(s0)
   11104:	00070513          	mv	a0,a4
   11108:	000780e7          	jalr	a5
   1110c:	fec42783          	lw	a5,-20(s0)
   11110:	0017879b          	addiw	a5,a5,1
   11114:	fef42623          	sw	a5,-20(s0)
   11118:	f5043783          	ld	a5,-176(s0)
   1111c:	00178793          	addi	a5,a5,1
   11120:	f4f43823          	sd	a5,-176(s0)
   11124:	f5043783          	ld	a5,-176(s0)
   11128:	0007c783          	lbu	a5,0(a5)
   1112c:	840794e3          	bnez	a5,10974 <vprintfmt+0x2c>
   11130:	fec42783          	lw	a5,-20(s0)
   11134:	00078513          	mv	a0,a5
   11138:	0b813083          	ld	ra,184(sp)
   1113c:	0b013403          	ld	s0,176(sp)
   11140:	0c010113          	addi	sp,sp,192
   11144:	00008067          	ret

0000000000011148 <printf>:
   11148:	f8010113          	addi	sp,sp,-128
   1114c:	02113c23          	sd	ra,56(sp)
   11150:	02813823          	sd	s0,48(sp)
   11154:	04010413          	addi	s0,sp,64
   11158:	fca43423          	sd	a0,-56(s0)
   1115c:	00b43423          	sd	a1,8(s0)
   11160:	00c43823          	sd	a2,16(s0)
   11164:	00d43c23          	sd	a3,24(s0)
   11168:	02e43023          	sd	a4,32(s0)
   1116c:	02f43423          	sd	a5,40(s0)
   11170:	03043823          	sd	a6,48(s0)
   11174:	03143c23          	sd	a7,56(s0)
   11178:	fe042623          	sw	zero,-20(s0)
   1117c:	04040793          	addi	a5,s0,64
   11180:	fcf43023          	sd	a5,-64(s0)
   11184:	fc043783          	ld	a5,-64(s0)
   11188:	fc878793          	addi	a5,a5,-56
   1118c:	fcf43823          	sd	a5,-48(s0)
   11190:	fd043783          	ld	a5,-48(s0)
   11194:	00078613          	mv	a2,a5
   11198:	fc843583          	ld	a1,-56(s0)
   1119c:	fffff517          	auipc	a0,0xfffff
   111a0:	0e050513          	addi	a0,a0,224 # 1027c <putc>
   111a4:	fffff097          	auipc	ra,0xfffff
   111a8:	7a4080e7          	jalr	1956(ra) # 10948 <vprintfmt>
   111ac:	00050793          	mv	a5,a0
   111b0:	fef42623          	sw	a5,-20(s0)
   111b4:	00100793          	li	a5,1
   111b8:	fef43023          	sd	a5,-32(s0)
   111bc:	00001797          	auipc	a5,0x1
   111c0:	15078793          	addi	a5,a5,336 # 1230c <tail>
   111c4:	0007a783          	lw	a5,0(a5)
   111c8:	0017871b          	addiw	a4,a5,1
   111cc:	0007069b          	sext.w	a3,a4
   111d0:	00001717          	auipc	a4,0x1
   111d4:	13c70713          	addi	a4,a4,316 # 1230c <tail>
   111d8:	00d72023          	sw	a3,0(a4)
   111dc:	00001717          	auipc	a4,0x1
   111e0:	13470713          	addi	a4,a4,308 # 12310 <buffer>
   111e4:	00f707b3          	add	a5,a4,a5
   111e8:	00078023          	sb	zero,0(a5)
   111ec:	00001797          	auipc	a5,0x1
   111f0:	12078793          	addi	a5,a5,288 # 1230c <tail>
   111f4:	0007a603          	lw	a2,0(a5)
   111f8:	fe043703          	ld	a4,-32(s0)
   111fc:	00001697          	auipc	a3,0x1
   11200:	11468693          	addi	a3,a3,276 # 12310 <buffer>
   11204:	fd843783          	ld	a5,-40(s0)
   11208:	04000893          	li	a7,64
   1120c:	00070513          	mv	a0,a4
   11210:	00068593          	mv	a1,a3
   11214:	00060613          	mv	a2,a2
   11218:	00000073          	ecall
   1121c:	00050793          	mv	a5,a0
   11220:	fcf43c23          	sd	a5,-40(s0)
   11224:	00001797          	auipc	a5,0x1
   11228:	0e878793          	addi	a5,a5,232 # 1230c <tail>
   1122c:	0007a023          	sw	zero,0(a5)
   11230:	fec42783          	lw	a5,-20(s0)
   11234:	00078513          	mv	a0,a5
   11238:	03813083          	ld	ra,56(sp)
   1123c:	03013403          	ld	s0,48(sp)
   11240:	08010113          	addi	sp,sp,128
   11244:	00008067          	ret
