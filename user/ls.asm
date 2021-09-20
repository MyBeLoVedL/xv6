
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	84aa                	mv	s1,a0
  10:	00000097          	auipc	ra,0x0
  14:	30c080e7          	jalr	780(ra) # 31c <strlen>
  18:	02051793          	slli	a5,a0,0x20
  1c:	9381                	srli	a5,a5,0x20
  1e:	97a6                	add	a5,a5,s1
  20:	02f00693          	li	a3,47
  24:	0097e963          	bltu	a5,s1,36 <fmtname+0x36>
  28:	0007c703          	lbu	a4,0(a5)
  2c:	00d70563          	beq	a4,a3,36 <fmtname+0x36>
  30:	17fd                	addi	a5,a5,-1
  32:	fe97fbe3          	bgeu	a5,s1,28 <fmtname+0x28>
  36:	00178493          	addi	s1,a5,1
  3a:	8526                	mv	a0,s1
  3c:	00000097          	auipc	ra,0x0
  40:	2e0080e7          	jalr	736(ra) # 31c <strlen>
  44:	2501                	sext.w	a0,a0
  46:	47b5                	li	a5,13
  48:	00a7fa63          	bgeu	a5,a0,5c <fmtname+0x5c>
  4c:	8526                	mv	a0,s1
  4e:	70a2                	ld	ra,40(sp)
  50:	7402                	ld	s0,32(sp)
  52:	64e2                	ld	s1,24(sp)
  54:	6942                	ld	s2,16(sp)
  56:	69a2                	ld	s3,8(sp)
  58:	6145                	addi	sp,sp,48
  5a:	8082                	ret
  5c:	8526                	mv	a0,s1
  5e:	00000097          	auipc	ra,0x0
  62:	2be080e7          	jalr	702(ra) # 31c <strlen>
  66:	00001997          	auipc	s3,0x1
  6a:	b8a98993          	addi	s3,s3,-1142 # bf0 <buf.0>
  6e:	0005061b          	sext.w	a2,a0
  72:	85a6                	mv	a1,s1
  74:	854e                	mv	a0,s3
  76:	00000097          	auipc	ra,0x0
  7a:	41a080e7          	jalr	1050(ra) # 490 <memmove>
  7e:	8526                	mv	a0,s1
  80:	00000097          	auipc	ra,0x0
  84:	29c080e7          	jalr	668(ra) # 31c <strlen>
  88:	0005091b          	sext.w	s2,a0
  8c:	8526                	mv	a0,s1
  8e:	00000097          	auipc	ra,0x0
  92:	28e080e7          	jalr	654(ra) # 31c <strlen>
  96:	1902                	slli	s2,s2,0x20
  98:	02095913          	srli	s2,s2,0x20
  9c:	4639                	li	a2,14
  9e:	9e09                	subw	a2,a2,a0
  a0:	02000593          	li	a1,32
  a4:	01298533          	add	a0,s3,s2
  a8:	00000097          	auipc	ra,0x0
  ac:	29e080e7          	jalr	670(ra) # 346 <memset>
  b0:	84ce                	mv	s1,s3
  b2:	bf69                	j	4c <fmtname+0x4c>

00000000000000b4 <ls>:
  b4:	d9010113          	addi	sp,sp,-624
  b8:	26113423          	sd	ra,616(sp)
  bc:	26813023          	sd	s0,608(sp)
  c0:	24913c23          	sd	s1,600(sp)
  c4:	25213823          	sd	s2,592(sp)
  c8:	25313423          	sd	s3,584(sp)
  cc:	25413023          	sd	s4,576(sp)
  d0:	23513c23          	sd	s5,568(sp)
  d4:	1c80                	addi	s0,sp,624
  d6:	892a                	mv	s2,a0
  d8:	4581                	li	a1,0
  da:	00000097          	auipc	ra,0x0
  de:	4a8080e7          	jalr	1192(ra) # 582 <open>
  e2:	06054f63          	bltz	a0,160 <ls+0xac>
  e6:	84aa                	mv	s1,a0
  e8:	d9840593          	addi	a1,s0,-616
  ec:	00000097          	auipc	ra,0x0
  f0:	4ae080e7          	jalr	1198(ra) # 59a <fstat>
  f4:	08054163          	bltz	a0,176 <ls+0xc2>
  f8:	da041783          	lh	a5,-608(s0)
  fc:	0007869b          	sext.w	a3,a5
 100:	4705                	li	a4,1
 102:	08e68a63          	beq	a3,a4,196 <ls+0xe2>
 106:	4709                	li	a4,2
 108:	02e69663          	bne	a3,a4,134 <ls+0x80>
 10c:	854a                	mv	a0,s2
 10e:	00000097          	auipc	ra,0x0
 112:	ef2080e7          	jalr	-270(ra) # 0 <fmtname>
 116:	85aa                	mv	a1,a0
 118:	da843703          	ld	a4,-600(s0)
 11c:	d9c42683          	lw	a3,-612(s0)
 120:	da041603          	lh	a2,-608(s0)
 124:	00001517          	auipc	a0,0x1
 128:	9fc50513          	addi	a0,a0,-1540 # b20 <l_free+0x42>
 12c:	00000097          	auipc	ra,0x0
 130:	790080e7          	jalr	1936(ra) # 8bc <printf>
 134:	8526                	mv	a0,s1
 136:	00000097          	auipc	ra,0x0
 13a:	434080e7          	jalr	1076(ra) # 56a <close>
 13e:	26813083          	ld	ra,616(sp)
 142:	26013403          	ld	s0,608(sp)
 146:	25813483          	ld	s1,600(sp)
 14a:	25013903          	ld	s2,592(sp)
 14e:	24813983          	ld	s3,584(sp)
 152:	24013a03          	ld	s4,576(sp)
 156:	23813a83          	ld	s5,568(sp)
 15a:	27010113          	addi	sp,sp,624
 15e:	8082                	ret
 160:	864a                	mv	a2,s2
 162:	00001597          	auipc	a1,0x1
 166:	98e58593          	addi	a1,a1,-1650 # af0 <l_free+0x12>
 16a:	4509                	li	a0,2
 16c:	00000097          	auipc	ra,0x0
 170:	722080e7          	jalr	1826(ra) # 88e <fprintf>
 174:	b7e9                	j	13e <ls+0x8a>
 176:	864a                	mv	a2,s2
 178:	00001597          	auipc	a1,0x1
 17c:	99058593          	addi	a1,a1,-1648 # b08 <l_free+0x2a>
 180:	4509                	li	a0,2
 182:	00000097          	auipc	ra,0x0
 186:	70c080e7          	jalr	1804(ra) # 88e <fprintf>
 18a:	8526                	mv	a0,s1
 18c:	00000097          	auipc	ra,0x0
 190:	3de080e7          	jalr	990(ra) # 56a <close>
 194:	b76d                	j	13e <ls+0x8a>
 196:	854a                	mv	a0,s2
 198:	00000097          	auipc	ra,0x0
 19c:	184080e7          	jalr	388(ra) # 31c <strlen>
 1a0:	2541                	addiw	a0,a0,16
 1a2:	20000793          	li	a5,512
 1a6:	00a7fb63          	bgeu	a5,a0,1bc <ls+0x108>
 1aa:	00001517          	auipc	a0,0x1
 1ae:	98650513          	addi	a0,a0,-1658 # b30 <l_free+0x52>
 1b2:	00000097          	auipc	ra,0x0
 1b6:	70a080e7          	jalr	1802(ra) # 8bc <printf>
 1ba:	bfad                	j	134 <ls+0x80>
 1bc:	85ca                	mv	a1,s2
 1be:	dc040513          	addi	a0,s0,-576
 1c2:	00000097          	auipc	ra,0x0
 1c6:	112080e7          	jalr	274(ra) # 2d4 <strcpy>
 1ca:	dc040513          	addi	a0,s0,-576
 1ce:	00000097          	auipc	ra,0x0
 1d2:	14e080e7          	jalr	334(ra) # 31c <strlen>
 1d6:	02051913          	slli	s2,a0,0x20
 1da:	02095913          	srli	s2,s2,0x20
 1de:	dc040793          	addi	a5,s0,-576
 1e2:	993e                	add	s2,s2,a5
 1e4:	00190993          	addi	s3,s2,1
 1e8:	02f00793          	li	a5,47
 1ec:	00f90023          	sb	a5,0(s2)
 1f0:	00001a17          	auipc	s4,0x1
 1f4:	958a0a13          	addi	s4,s4,-1704 # b48 <l_free+0x6a>
 1f8:	00001a97          	auipc	s5,0x1
 1fc:	910a8a93          	addi	s5,s5,-1776 # b08 <l_free+0x2a>
 200:	a801                	j	210 <ls+0x15c>
 202:	dc040593          	addi	a1,s0,-576
 206:	8556                	mv	a0,s5
 208:	00000097          	auipc	ra,0x0
 20c:	6b4080e7          	jalr	1716(ra) # 8bc <printf>
 210:	4641                	li	a2,16
 212:	db040593          	addi	a1,s0,-592
 216:	8526                	mv	a0,s1
 218:	00000097          	auipc	ra,0x0
 21c:	342080e7          	jalr	834(ra) # 55a <read>
 220:	47c1                	li	a5,16
 222:	f0f519e3          	bne	a0,a5,134 <ls+0x80>
 226:	db045783          	lhu	a5,-592(s0)
 22a:	d3fd                	beqz	a5,210 <ls+0x15c>
 22c:	4639                	li	a2,14
 22e:	db240593          	addi	a1,s0,-590
 232:	854e                	mv	a0,s3
 234:	00000097          	auipc	ra,0x0
 238:	25c080e7          	jalr	604(ra) # 490 <memmove>
 23c:	000907a3          	sb	zero,15(s2)
 240:	d9840593          	addi	a1,s0,-616
 244:	dc040513          	addi	a0,s0,-576
 248:	00000097          	auipc	ra,0x0
 24c:	1b8080e7          	jalr	440(ra) # 400 <stat>
 250:	fa0549e3          	bltz	a0,202 <ls+0x14e>
 254:	dc040513          	addi	a0,s0,-576
 258:	00000097          	auipc	ra,0x0
 25c:	da8080e7          	jalr	-600(ra) # 0 <fmtname>
 260:	85aa                	mv	a1,a0
 262:	da843703          	ld	a4,-600(s0)
 266:	d9c42683          	lw	a3,-612(s0)
 26a:	da041603          	lh	a2,-608(s0)
 26e:	8552                	mv	a0,s4
 270:	00000097          	auipc	ra,0x0
 274:	64c080e7          	jalr	1612(ra) # 8bc <printf>
 278:	bf61                	j	210 <ls+0x15c>

000000000000027a <main>:
 27a:	1101                	addi	sp,sp,-32
 27c:	ec06                	sd	ra,24(sp)
 27e:	e822                	sd	s0,16(sp)
 280:	e426                	sd	s1,8(sp)
 282:	e04a                	sd	s2,0(sp)
 284:	1000                	addi	s0,sp,32
 286:	4785                	li	a5,1
 288:	02a7d963          	bge	a5,a0,2ba <main+0x40>
 28c:	00858493          	addi	s1,a1,8
 290:	ffe5091b          	addiw	s2,a0,-2
 294:	1902                	slli	s2,s2,0x20
 296:	02095913          	srli	s2,s2,0x20
 29a:	090e                	slli	s2,s2,0x3
 29c:	05c1                	addi	a1,a1,16
 29e:	992e                	add	s2,s2,a1
 2a0:	6088                	ld	a0,0(s1)
 2a2:	00000097          	auipc	ra,0x0
 2a6:	e12080e7          	jalr	-494(ra) # b4 <ls>
 2aa:	04a1                	addi	s1,s1,8
 2ac:	ff249ae3          	bne	s1,s2,2a0 <main+0x26>
 2b0:	4501                	li	a0,0
 2b2:	00000097          	auipc	ra,0x0
 2b6:	290080e7          	jalr	656(ra) # 542 <exit>
 2ba:	00001517          	auipc	a0,0x1
 2be:	89e50513          	addi	a0,a0,-1890 # b58 <l_free+0x7a>
 2c2:	00000097          	auipc	ra,0x0
 2c6:	df2080e7          	jalr	-526(ra) # b4 <ls>
 2ca:	4501                	li	a0,0
 2cc:	00000097          	auipc	ra,0x0
 2d0:	276080e7          	jalr	630(ra) # 542 <exit>

00000000000002d4 <strcpy>:
 2d4:	1141                	addi	sp,sp,-16
 2d6:	e422                	sd	s0,8(sp)
 2d8:	0800                	addi	s0,sp,16
 2da:	87aa                	mv	a5,a0
 2dc:	0585                	addi	a1,a1,1
 2de:	0785                	addi	a5,a5,1
 2e0:	fff5c703          	lbu	a4,-1(a1)
 2e4:	fee78fa3          	sb	a4,-1(a5)
 2e8:	fb75                	bnez	a4,2dc <strcpy+0x8>
 2ea:	6422                	ld	s0,8(sp)
 2ec:	0141                	addi	sp,sp,16
 2ee:	8082                	ret

00000000000002f0 <strcmp>:
 2f0:	1141                	addi	sp,sp,-16
 2f2:	e422                	sd	s0,8(sp)
 2f4:	0800                	addi	s0,sp,16
 2f6:	00054783          	lbu	a5,0(a0)
 2fa:	cb91                	beqz	a5,30e <strcmp+0x1e>
 2fc:	0005c703          	lbu	a4,0(a1)
 300:	00f71763          	bne	a4,a5,30e <strcmp+0x1e>
 304:	0505                	addi	a0,a0,1
 306:	0585                	addi	a1,a1,1
 308:	00054783          	lbu	a5,0(a0)
 30c:	fbe5                	bnez	a5,2fc <strcmp+0xc>
 30e:	0005c503          	lbu	a0,0(a1)
 312:	40a7853b          	subw	a0,a5,a0
 316:	6422                	ld	s0,8(sp)
 318:	0141                	addi	sp,sp,16
 31a:	8082                	ret

000000000000031c <strlen>:
 31c:	1141                	addi	sp,sp,-16
 31e:	e422                	sd	s0,8(sp)
 320:	0800                	addi	s0,sp,16
 322:	00054783          	lbu	a5,0(a0)
 326:	cf91                	beqz	a5,342 <strlen+0x26>
 328:	0505                	addi	a0,a0,1
 32a:	87aa                	mv	a5,a0
 32c:	4685                	li	a3,1
 32e:	9e89                	subw	a3,a3,a0
 330:	00f6853b          	addw	a0,a3,a5
 334:	0785                	addi	a5,a5,1
 336:	fff7c703          	lbu	a4,-1(a5)
 33a:	fb7d                	bnez	a4,330 <strlen+0x14>
 33c:	6422                	ld	s0,8(sp)
 33e:	0141                	addi	sp,sp,16
 340:	8082                	ret
 342:	4501                	li	a0,0
 344:	bfe5                	j	33c <strlen+0x20>

0000000000000346 <memset>:
 346:	1141                	addi	sp,sp,-16
 348:	e422                	sd	s0,8(sp)
 34a:	0800                	addi	s0,sp,16
 34c:	ca19                	beqz	a2,362 <memset+0x1c>
 34e:	87aa                	mv	a5,a0
 350:	1602                	slli	a2,a2,0x20
 352:	9201                	srli	a2,a2,0x20
 354:	00a60733          	add	a4,a2,a0
 358:	00b78023          	sb	a1,0(a5)
 35c:	0785                	addi	a5,a5,1
 35e:	fee79de3          	bne	a5,a4,358 <memset+0x12>
 362:	6422                	ld	s0,8(sp)
 364:	0141                	addi	sp,sp,16
 366:	8082                	ret

0000000000000368 <strchr>:
 368:	1141                	addi	sp,sp,-16
 36a:	e422                	sd	s0,8(sp)
 36c:	0800                	addi	s0,sp,16
 36e:	00054783          	lbu	a5,0(a0)
 372:	cb99                	beqz	a5,388 <strchr+0x20>
 374:	00f58763          	beq	a1,a5,382 <strchr+0x1a>
 378:	0505                	addi	a0,a0,1
 37a:	00054783          	lbu	a5,0(a0)
 37e:	fbfd                	bnez	a5,374 <strchr+0xc>
 380:	4501                	li	a0,0
 382:	6422                	ld	s0,8(sp)
 384:	0141                	addi	sp,sp,16
 386:	8082                	ret
 388:	4501                	li	a0,0
 38a:	bfe5                	j	382 <strchr+0x1a>

000000000000038c <gets>:
 38c:	711d                	addi	sp,sp,-96
 38e:	ec86                	sd	ra,88(sp)
 390:	e8a2                	sd	s0,80(sp)
 392:	e4a6                	sd	s1,72(sp)
 394:	e0ca                	sd	s2,64(sp)
 396:	fc4e                	sd	s3,56(sp)
 398:	f852                	sd	s4,48(sp)
 39a:	f456                	sd	s5,40(sp)
 39c:	f05a                	sd	s6,32(sp)
 39e:	ec5e                	sd	s7,24(sp)
 3a0:	1080                	addi	s0,sp,96
 3a2:	8baa                	mv	s7,a0
 3a4:	8a2e                	mv	s4,a1
 3a6:	892a                	mv	s2,a0
 3a8:	4481                	li	s1,0
 3aa:	4aa9                	li	s5,10
 3ac:	4b35                	li	s6,13
 3ae:	89a6                	mv	s3,s1
 3b0:	2485                	addiw	s1,s1,1
 3b2:	0344d863          	bge	s1,s4,3e2 <gets+0x56>
 3b6:	4605                	li	a2,1
 3b8:	faf40593          	addi	a1,s0,-81
 3bc:	4501                	li	a0,0
 3be:	00000097          	auipc	ra,0x0
 3c2:	19c080e7          	jalr	412(ra) # 55a <read>
 3c6:	00a05e63          	blez	a0,3e2 <gets+0x56>
 3ca:	faf44783          	lbu	a5,-81(s0)
 3ce:	00f90023          	sb	a5,0(s2)
 3d2:	01578763          	beq	a5,s5,3e0 <gets+0x54>
 3d6:	0905                	addi	s2,s2,1
 3d8:	fd679be3          	bne	a5,s6,3ae <gets+0x22>
 3dc:	89a6                	mv	s3,s1
 3de:	a011                	j	3e2 <gets+0x56>
 3e0:	89a6                	mv	s3,s1
 3e2:	99de                	add	s3,s3,s7
 3e4:	00098023          	sb	zero,0(s3)
 3e8:	855e                	mv	a0,s7
 3ea:	60e6                	ld	ra,88(sp)
 3ec:	6446                	ld	s0,80(sp)
 3ee:	64a6                	ld	s1,72(sp)
 3f0:	6906                	ld	s2,64(sp)
 3f2:	79e2                	ld	s3,56(sp)
 3f4:	7a42                	ld	s4,48(sp)
 3f6:	7aa2                	ld	s5,40(sp)
 3f8:	7b02                	ld	s6,32(sp)
 3fa:	6be2                	ld	s7,24(sp)
 3fc:	6125                	addi	sp,sp,96
 3fe:	8082                	ret

0000000000000400 <stat>:
 400:	1101                	addi	sp,sp,-32
 402:	ec06                	sd	ra,24(sp)
 404:	e822                	sd	s0,16(sp)
 406:	e426                	sd	s1,8(sp)
 408:	e04a                	sd	s2,0(sp)
 40a:	1000                	addi	s0,sp,32
 40c:	892e                	mv	s2,a1
 40e:	4581                	li	a1,0
 410:	00000097          	auipc	ra,0x0
 414:	172080e7          	jalr	370(ra) # 582 <open>
 418:	02054563          	bltz	a0,442 <stat+0x42>
 41c:	84aa                	mv	s1,a0
 41e:	85ca                	mv	a1,s2
 420:	00000097          	auipc	ra,0x0
 424:	17a080e7          	jalr	378(ra) # 59a <fstat>
 428:	892a                	mv	s2,a0
 42a:	8526                	mv	a0,s1
 42c:	00000097          	auipc	ra,0x0
 430:	13e080e7          	jalr	318(ra) # 56a <close>
 434:	854a                	mv	a0,s2
 436:	60e2                	ld	ra,24(sp)
 438:	6442                	ld	s0,16(sp)
 43a:	64a2                	ld	s1,8(sp)
 43c:	6902                	ld	s2,0(sp)
 43e:	6105                	addi	sp,sp,32
 440:	8082                	ret
 442:	597d                	li	s2,-1
 444:	bfc5                	j	434 <stat+0x34>

0000000000000446 <atoi>:
 446:	1141                	addi	sp,sp,-16
 448:	e422                	sd	s0,8(sp)
 44a:	0800                	addi	s0,sp,16
 44c:	00054603          	lbu	a2,0(a0)
 450:	fd06079b          	addiw	a5,a2,-48
 454:	0ff7f793          	zext.b	a5,a5
 458:	4725                	li	a4,9
 45a:	02f76963          	bltu	a4,a5,48c <atoi+0x46>
 45e:	86aa                	mv	a3,a0
 460:	4501                	li	a0,0
 462:	45a5                	li	a1,9
 464:	0685                	addi	a3,a3,1
 466:	0025179b          	slliw	a5,a0,0x2
 46a:	9fa9                	addw	a5,a5,a0
 46c:	0017979b          	slliw	a5,a5,0x1
 470:	9fb1                	addw	a5,a5,a2
 472:	fd07851b          	addiw	a0,a5,-48
 476:	0006c603          	lbu	a2,0(a3)
 47a:	fd06071b          	addiw	a4,a2,-48
 47e:	0ff77713          	zext.b	a4,a4
 482:	fee5f1e3          	bgeu	a1,a4,464 <atoi+0x1e>
 486:	6422                	ld	s0,8(sp)
 488:	0141                	addi	sp,sp,16
 48a:	8082                	ret
 48c:	4501                	li	a0,0
 48e:	bfe5                	j	486 <atoi+0x40>

0000000000000490 <memmove>:
 490:	1141                	addi	sp,sp,-16
 492:	e422                	sd	s0,8(sp)
 494:	0800                	addi	s0,sp,16
 496:	02b57463          	bgeu	a0,a1,4be <memmove+0x2e>
 49a:	00c05f63          	blez	a2,4b8 <memmove+0x28>
 49e:	1602                	slli	a2,a2,0x20
 4a0:	9201                	srli	a2,a2,0x20
 4a2:	00c507b3          	add	a5,a0,a2
 4a6:	872a                	mv	a4,a0
 4a8:	0585                	addi	a1,a1,1
 4aa:	0705                	addi	a4,a4,1
 4ac:	fff5c683          	lbu	a3,-1(a1)
 4b0:	fed70fa3          	sb	a3,-1(a4)
 4b4:	fee79ae3          	bne	a5,a4,4a8 <memmove+0x18>
 4b8:	6422                	ld	s0,8(sp)
 4ba:	0141                	addi	sp,sp,16
 4bc:	8082                	ret
 4be:	00c50733          	add	a4,a0,a2
 4c2:	95b2                	add	a1,a1,a2
 4c4:	fec05ae3          	blez	a2,4b8 <memmove+0x28>
 4c8:	fff6079b          	addiw	a5,a2,-1
 4cc:	1782                	slli	a5,a5,0x20
 4ce:	9381                	srli	a5,a5,0x20
 4d0:	fff7c793          	not	a5,a5
 4d4:	97ba                	add	a5,a5,a4
 4d6:	15fd                	addi	a1,a1,-1
 4d8:	177d                	addi	a4,a4,-1
 4da:	0005c683          	lbu	a3,0(a1)
 4de:	00d70023          	sb	a3,0(a4)
 4e2:	fee79ae3          	bne	a5,a4,4d6 <memmove+0x46>
 4e6:	bfc9                	j	4b8 <memmove+0x28>

00000000000004e8 <memcmp>:
 4e8:	1141                	addi	sp,sp,-16
 4ea:	e422                	sd	s0,8(sp)
 4ec:	0800                	addi	s0,sp,16
 4ee:	ca05                	beqz	a2,51e <memcmp+0x36>
 4f0:	fff6069b          	addiw	a3,a2,-1
 4f4:	1682                	slli	a3,a3,0x20
 4f6:	9281                	srli	a3,a3,0x20
 4f8:	0685                	addi	a3,a3,1
 4fa:	96aa                	add	a3,a3,a0
 4fc:	00054783          	lbu	a5,0(a0)
 500:	0005c703          	lbu	a4,0(a1)
 504:	00e79863          	bne	a5,a4,514 <memcmp+0x2c>
 508:	0505                	addi	a0,a0,1
 50a:	0585                	addi	a1,a1,1
 50c:	fed518e3          	bne	a0,a3,4fc <memcmp+0x14>
 510:	4501                	li	a0,0
 512:	a019                	j	518 <memcmp+0x30>
 514:	40e7853b          	subw	a0,a5,a4
 518:	6422                	ld	s0,8(sp)
 51a:	0141                	addi	sp,sp,16
 51c:	8082                	ret
 51e:	4501                	li	a0,0
 520:	bfe5                	j	518 <memcmp+0x30>

0000000000000522 <memcpy>:
 522:	1141                	addi	sp,sp,-16
 524:	e406                	sd	ra,8(sp)
 526:	e022                	sd	s0,0(sp)
 528:	0800                	addi	s0,sp,16
 52a:	00000097          	auipc	ra,0x0
 52e:	f66080e7          	jalr	-154(ra) # 490 <memmove>
 532:	60a2                	ld	ra,8(sp)
 534:	6402                	ld	s0,0(sp)
 536:	0141                	addi	sp,sp,16
 538:	8082                	ret

000000000000053a <fork>:
 53a:	4885                	li	a7,1
 53c:	00000073          	ecall
 540:	8082                	ret

0000000000000542 <exit>:
 542:	4889                	li	a7,2
 544:	00000073          	ecall
 548:	8082                	ret

000000000000054a <wait>:
 54a:	488d                	li	a7,3
 54c:	00000073          	ecall
 550:	8082                	ret

0000000000000552 <pipe>:
 552:	4891                	li	a7,4
 554:	00000073          	ecall
 558:	8082                	ret

000000000000055a <read>:
 55a:	4895                	li	a7,5
 55c:	00000073          	ecall
 560:	8082                	ret

0000000000000562 <write>:
 562:	48c1                	li	a7,16
 564:	00000073          	ecall
 568:	8082                	ret

000000000000056a <close>:
 56a:	48d5                	li	a7,21
 56c:	00000073          	ecall
 570:	8082                	ret

0000000000000572 <kill>:
 572:	4899                	li	a7,6
 574:	00000073          	ecall
 578:	8082                	ret

000000000000057a <exec>:
 57a:	489d                	li	a7,7
 57c:	00000073          	ecall
 580:	8082                	ret

0000000000000582 <open>:
 582:	48bd                	li	a7,15
 584:	00000073          	ecall
 588:	8082                	ret

000000000000058a <mknod>:
 58a:	48c5                	li	a7,17
 58c:	00000073          	ecall
 590:	8082                	ret

0000000000000592 <unlink>:
 592:	48c9                	li	a7,18
 594:	00000073          	ecall
 598:	8082                	ret

000000000000059a <fstat>:
 59a:	48a1                	li	a7,8
 59c:	00000073          	ecall
 5a0:	8082                	ret

00000000000005a2 <link>:
 5a2:	48cd                	li	a7,19
 5a4:	00000073          	ecall
 5a8:	8082                	ret

00000000000005aa <mkdir>:
 5aa:	48d1                	li	a7,20
 5ac:	00000073          	ecall
 5b0:	8082                	ret

00000000000005b2 <chdir>:
 5b2:	48a5                	li	a7,9
 5b4:	00000073          	ecall
 5b8:	8082                	ret

00000000000005ba <dup>:
 5ba:	48a9                	li	a7,10
 5bc:	00000073          	ecall
 5c0:	8082                	ret

00000000000005c2 <getpid>:
 5c2:	48ad                	li	a7,11
 5c4:	00000073          	ecall
 5c8:	8082                	ret

00000000000005ca <sbrk>:
 5ca:	48b1                	li	a7,12
 5cc:	00000073          	ecall
 5d0:	8082                	ret

00000000000005d2 <sleep>:
 5d2:	48b5                	li	a7,13
 5d4:	00000073          	ecall
 5d8:	8082                	ret

00000000000005da <uptime>:
 5da:	48b9                	li	a7,14
 5dc:	00000073          	ecall
 5e0:	8082                	ret

00000000000005e2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5e2:	1101                	addi	sp,sp,-32
 5e4:	ec06                	sd	ra,24(sp)
 5e6:	e822                	sd	s0,16(sp)
 5e8:	1000                	addi	s0,sp,32
 5ea:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5ee:	4605                	li	a2,1
 5f0:	fef40593          	addi	a1,s0,-17
 5f4:	00000097          	auipc	ra,0x0
 5f8:	f6e080e7          	jalr	-146(ra) # 562 <write>
}
 5fc:	60e2                	ld	ra,24(sp)
 5fe:	6442                	ld	s0,16(sp)
 600:	6105                	addi	sp,sp,32
 602:	8082                	ret

0000000000000604 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 604:	7139                	addi	sp,sp,-64
 606:	fc06                	sd	ra,56(sp)
 608:	f822                	sd	s0,48(sp)
 60a:	f426                	sd	s1,40(sp)
 60c:	f04a                	sd	s2,32(sp)
 60e:	ec4e                	sd	s3,24(sp)
 610:	0080                	addi	s0,sp,64
 612:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 614:	c299                	beqz	a3,61a <printint+0x16>
 616:	0805c963          	bltz	a1,6a8 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 61a:	2581                	sext.w	a1,a1
  neg = 0;
 61c:	4881                	li	a7,0
 61e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 622:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 624:	2601                	sext.w	a2,a2
 626:	00000517          	auipc	a0,0x0
 62a:	59a50513          	addi	a0,a0,1434 # bc0 <digits>
 62e:	883a                	mv	a6,a4
 630:	2705                	addiw	a4,a4,1
 632:	02c5f7bb          	remuw	a5,a1,a2
 636:	1782                	slli	a5,a5,0x20
 638:	9381                	srli	a5,a5,0x20
 63a:	97aa                	add	a5,a5,a0
 63c:	0007c783          	lbu	a5,0(a5)
 640:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 644:	0005879b          	sext.w	a5,a1
 648:	02c5d5bb          	divuw	a1,a1,a2
 64c:	0685                	addi	a3,a3,1
 64e:	fec7f0e3          	bgeu	a5,a2,62e <printint+0x2a>
  if(neg)
 652:	00088c63          	beqz	a7,66a <printint+0x66>
    buf[i++] = '-';
 656:	fd070793          	addi	a5,a4,-48
 65a:	00878733          	add	a4,a5,s0
 65e:	02d00793          	li	a5,45
 662:	fef70823          	sb	a5,-16(a4)
 666:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 66a:	02e05863          	blez	a4,69a <printint+0x96>
 66e:	fc040793          	addi	a5,s0,-64
 672:	00e78933          	add	s2,a5,a4
 676:	fff78993          	addi	s3,a5,-1
 67a:	99ba                	add	s3,s3,a4
 67c:	377d                	addiw	a4,a4,-1
 67e:	1702                	slli	a4,a4,0x20
 680:	9301                	srli	a4,a4,0x20
 682:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 686:	fff94583          	lbu	a1,-1(s2)
 68a:	8526                	mv	a0,s1
 68c:	00000097          	auipc	ra,0x0
 690:	f56080e7          	jalr	-170(ra) # 5e2 <putc>
  while(--i >= 0)
 694:	197d                	addi	s2,s2,-1
 696:	ff3918e3          	bne	s2,s3,686 <printint+0x82>
}
 69a:	70e2                	ld	ra,56(sp)
 69c:	7442                	ld	s0,48(sp)
 69e:	74a2                	ld	s1,40(sp)
 6a0:	7902                	ld	s2,32(sp)
 6a2:	69e2                	ld	s3,24(sp)
 6a4:	6121                	addi	sp,sp,64
 6a6:	8082                	ret
    x = -xx;
 6a8:	40b005bb          	negw	a1,a1
    neg = 1;
 6ac:	4885                	li	a7,1
    x = -xx;
 6ae:	bf85                	j	61e <printint+0x1a>

00000000000006b0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6b0:	7119                	addi	sp,sp,-128
 6b2:	fc86                	sd	ra,120(sp)
 6b4:	f8a2                	sd	s0,112(sp)
 6b6:	f4a6                	sd	s1,104(sp)
 6b8:	f0ca                	sd	s2,96(sp)
 6ba:	ecce                	sd	s3,88(sp)
 6bc:	e8d2                	sd	s4,80(sp)
 6be:	e4d6                	sd	s5,72(sp)
 6c0:	e0da                	sd	s6,64(sp)
 6c2:	fc5e                	sd	s7,56(sp)
 6c4:	f862                	sd	s8,48(sp)
 6c6:	f466                	sd	s9,40(sp)
 6c8:	f06a                	sd	s10,32(sp)
 6ca:	ec6e                	sd	s11,24(sp)
 6cc:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6ce:	0005c903          	lbu	s2,0(a1)
 6d2:	18090f63          	beqz	s2,870 <vprintf+0x1c0>
 6d6:	8aaa                	mv	s5,a0
 6d8:	8b32                	mv	s6,a2
 6da:	00158493          	addi	s1,a1,1
  state = 0;
 6de:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6e0:	02500a13          	li	s4,37
 6e4:	4c55                	li	s8,21
 6e6:	00000c97          	auipc	s9,0x0
 6ea:	482c8c93          	addi	s9,s9,1154 # b68 <l_free+0x8a>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6ee:	02800d93          	li	s11,40
  putc(fd, 'x');
 6f2:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6f4:	00000b97          	auipc	s7,0x0
 6f8:	4ccb8b93          	addi	s7,s7,1228 # bc0 <digits>
 6fc:	a839                	j	71a <vprintf+0x6a>
        putc(fd, c);
 6fe:	85ca                	mv	a1,s2
 700:	8556                	mv	a0,s5
 702:	00000097          	auipc	ra,0x0
 706:	ee0080e7          	jalr	-288(ra) # 5e2 <putc>
 70a:	a019                	j	710 <vprintf+0x60>
    } else if(state == '%'){
 70c:	01498d63          	beq	s3,s4,726 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 710:	0485                	addi	s1,s1,1
 712:	fff4c903          	lbu	s2,-1(s1)
 716:	14090d63          	beqz	s2,870 <vprintf+0x1c0>
    if(state == 0){
 71a:	fe0999e3          	bnez	s3,70c <vprintf+0x5c>
      if(c == '%'){
 71e:	ff4910e3          	bne	s2,s4,6fe <vprintf+0x4e>
        state = '%';
 722:	89d2                	mv	s3,s4
 724:	b7f5                	j	710 <vprintf+0x60>
      if(c == 'd'){
 726:	11490c63          	beq	s2,s4,83e <vprintf+0x18e>
 72a:	f9d9079b          	addiw	a5,s2,-99
 72e:	0ff7f793          	zext.b	a5,a5
 732:	10fc6e63          	bltu	s8,a5,84e <vprintf+0x19e>
 736:	f9d9079b          	addiw	a5,s2,-99
 73a:	0ff7f713          	zext.b	a4,a5
 73e:	10ec6863          	bltu	s8,a4,84e <vprintf+0x19e>
 742:	00271793          	slli	a5,a4,0x2
 746:	97e6                	add	a5,a5,s9
 748:	439c                	lw	a5,0(a5)
 74a:	97e6                	add	a5,a5,s9
 74c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 74e:	008b0913          	addi	s2,s6,8
 752:	4685                	li	a3,1
 754:	4629                	li	a2,10
 756:	000b2583          	lw	a1,0(s6)
 75a:	8556                	mv	a0,s5
 75c:	00000097          	auipc	ra,0x0
 760:	ea8080e7          	jalr	-344(ra) # 604 <printint>
 764:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 766:	4981                	li	s3,0
 768:	b765                	j	710 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 76a:	008b0913          	addi	s2,s6,8
 76e:	4681                	li	a3,0
 770:	4629                	li	a2,10
 772:	000b2583          	lw	a1,0(s6)
 776:	8556                	mv	a0,s5
 778:	00000097          	auipc	ra,0x0
 77c:	e8c080e7          	jalr	-372(ra) # 604 <printint>
 780:	8b4a                	mv	s6,s2
      state = 0;
 782:	4981                	li	s3,0
 784:	b771                	j	710 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 786:	008b0913          	addi	s2,s6,8
 78a:	4681                	li	a3,0
 78c:	866a                	mv	a2,s10
 78e:	000b2583          	lw	a1,0(s6)
 792:	8556                	mv	a0,s5
 794:	00000097          	auipc	ra,0x0
 798:	e70080e7          	jalr	-400(ra) # 604 <printint>
 79c:	8b4a                	mv	s6,s2
      state = 0;
 79e:	4981                	li	s3,0
 7a0:	bf85                	j	710 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 7a2:	008b0793          	addi	a5,s6,8
 7a6:	f8f43423          	sd	a5,-120(s0)
 7aa:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 7ae:	03000593          	li	a1,48
 7b2:	8556                	mv	a0,s5
 7b4:	00000097          	auipc	ra,0x0
 7b8:	e2e080e7          	jalr	-466(ra) # 5e2 <putc>
  putc(fd, 'x');
 7bc:	07800593          	li	a1,120
 7c0:	8556                	mv	a0,s5
 7c2:	00000097          	auipc	ra,0x0
 7c6:	e20080e7          	jalr	-480(ra) # 5e2 <putc>
 7ca:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7cc:	03c9d793          	srli	a5,s3,0x3c
 7d0:	97de                	add	a5,a5,s7
 7d2:	0007c583          	lbu	a1,0(a5)
 7d6:	8556                	mv	a0,s5
 7d8:	00000097          	auipc	ra,0x0
 7dc:	e0a080e7          	jalr	-502(ra) # 5e2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7e0:	0992                	slli	s3,s3,0x4
 7e2:	397d                	addiw	s2,s2,-1
 7e4:	fe0914e3          	bnez	s2,7cc <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 7e8:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 7ec:	4981                	li	s3,0
 7ee:	b70d                	j	710 <vprintf+0x60>
        s = va_arg(ap, char*);
 7f0:	008b0913          	addi	s2,s6,8
 7f4:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 7f8:	02098163          	beqz	s3,81a <vprintf+0x16a>
        while(*s != 0){
 7fc:	0009c583          	lbu	a1,0(s3)
 800:	c5ad                	beqz	a1,86a <vprintf+0x1ba>
          putc(fd, *s);
 802:	8556                	mv	a0,s5
 804:	00000097          	auipc	ra,0x0
 808:	dde080e7          	jalr	-546(ra) # 5e2 <putc>
          s++;
 80c:	0985                	addi	s3,s3,1
        while(*s != 0){
 80e:	0009c583          	lbu	a1,0(s3)
 812:	f9e5                	bnez	a1,802 <vprintf+0x152>
        s = va_arg(ap, char*);
 814:	8b4a                	mv	s6,s2
      state = 0;
 816:	4981                	li	s3,0
 818:	bde5                	j	710 <vprintf+0x60>
          s = "(null)";
 81a:	00000997          	auipc	s3,0x0
 81e:	34698993          	addi	s3,s3,838 # b60 <l_free+0x82>
        while(*s != 0){
 822:	85ee                	mv	a1,s11
 824:	bff9                	j	802 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 826:	008b0913          	addi	s2,s6,8
 82a:	000b4583          	lbu	a1,0(s6)
 82e:	8556                	mv	a0,s5
 830:	00000097          	auipc	ra,0x0
 834:	db2080e7          	jalr	-590(ra) # 5e2 <putc>
 838:	8b4a                	mv	s6,s2
      state = 0;
 83a:	4981                	li	s3,0
 83c:	bdd1                	j	710 <vprintf+0x60>
        putc(fd, c);
 83e:	85d2                	mv	a1,s4
 840:	8556                	mv	a0,s5
 842:	00000097          	auipc	ra,0x0
 846:	da0080e7          	jalr	-608(ra) # 5e2 <putc>
      state = 0;
 84a:	4981                	li	s3,0
 84c:	b5d1                	j	710 <vprintf+0x60>
        putc(fd, '%');
 84e:	85d2                	mv	a1,s4
 850:	8556                	mv	a0,s5
 852:	00000097          	auipc	ra,0x0
 856:	d90080e7          	jalr	-624(ra) # 5e2 <putc>
        putc(fd, c);
 85a:	85ca                	mv	a1,s2
 85c:	8556                	mv	a0,s5
 85e:	00000097          	auipc	ra,0x0
 862:	d84080e7          	jalr	-636(ra) # 5e2 <putc>
      state = 0;
 866:	4981                	li	s3,0
 868:	b565                	j	710 <vprintf+0x60>
        s = va_arg(ap, char*);
 86a:	8b4a                	mv	s6,s2
      state = 0;
 86c:	4981                	li	s3,0
 86e:	b54d                	j	710 <vprintf+0x60>
    }
  }
}
 870:	70e6                	ld	ra,120(sp)
 872:	7446                	ld	s0,112(sp)
 874:	74a6                	ld	s1,104(sp)
 876:	7906                	ld	s2,96(sp)
 878:	69e6                	ld	s3,88(sp)
 87a:	6a46                	ld	s4,80(sp)
 87c:	6aa6                	ld	s5,72(sp)
 87e:	6b06                	ld	s6,64(sp)
 880:	7be2                	ld	s7,56(sp)
 882:	7c42                	ld	s8,48(sp)
 884:	7ca2                	ld	s9,40(sp)
 886:	7d02                	ld	s10,32(sp)
 888:	6de2                	ld	s11,24(sp)
 88a:	6109                	addi	sp,sp,128
 88c:	8082                	ret

000000000000088e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 88e:	715d                	addi	sp,sp,-80
 890:	ec06                	sd	ra,24(sp)
 892:	e822                	sd	s0,16(sp)
 894:	1000                	addi	s0,sp,32
 896:	e010                	sd	a2,0(s0)
 898:	e414                	sd	a3,8(s0)
 89a:	e818                	sd	a4,16(s0)
 89c:	ec1c                	sd	a5,24(s0)
 89e:	03043023          	sd	a6,32(s0)
 8a2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8a6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8aa:	8622                	mv	a2,s0
 8ac:	00000097          	auipc	ra,0x0
 8b0:	e04080e7          	jalr	-508(ra) # 6b0 <vprintf>
}
 8b4:	60e2                	ld	ra,24(sp)
 8b6:	6442                	ld	s0,16(sp)
 8b8:	6161                	addi	sp,sp,80
 8ba:	8082                	ret

00000000000008bc <printf>:

void
printf(const char *fmt, ...)
{
 8bc:	711d                	addi	sp,sp,-96
 8be:	ec06                	sd	ra,24(sp)
 8c0:	e822                	sd	s0,16(sp)
 8c2:	1000                	addi	s0,sp,32
 8c4:	e40c                	sd	a1,8(s0)
 8c6:	e810                	sd	a2,16(s0)
 8c8:	ec14                	sd	a3,24(s0)
 8ca:	f018                	sd	a4,32(s0)
 8cc:	f41c                	sd	a5,40(s0)
 8ce:	03043823          	sd	a6,48(s0)
 8d2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8d6:	00840613          	addi	a2,s0,8
 8da:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8de:	85aa                	mv	a1,a0
 8e0:	4505                	li	a0,1
 8e2:	00000097          	auipc	ra,0x0
 8e6:	dce080e7          	jalr	-562(ra) # 6b0 <vprintf>
}
 8ea:	60e2                	ld	ra,24(sp)
 8ec:	6442                	ld	s0,16(sp)
 8ee:	6125                	addi	sp,sp,96
 8f0:	8082                	ret

00000000000008f2 <free>:
 8f2:	1141                	addi	sp,sp,-16
 8f4:	e422                	sd	s0,8(sp)
 8f6:	0800                	addi	s0,sp,16
 8f8:	ff050693          	addi	a3,a0,-16
 8fc:	00000797          	auipc	a5,0x0
 900:	2ec7b783          	ld	a5,748(a5) # be8 <freep>
 904:	a805                	j	934 <free+0x42>
 906:	4618                	lw	a4,8(a2)
 908:	9db9                	addw	a1,a1,a4
 90a:	feb52c23          	sw	a1,-8(a0)
 90e:	6398                	ld	a4,0(a5)
 910:	6318                	ld	a4,0(a4)
 912:	fee53823          	sd	a4,-16(a0)
 916:	a091                	j	95a <free+0x68>
 918:	ff852703          	lw	a4,-8(a0)
 91c:	9e39                	addw	a2,a2,a4
 91e:	c790                	sw	a2,8(a5)
 920:	ff053703          	ld	a4,-16(a0)
 924:	e398                	sd	a4,0(a5)
 926:	a099                	j	96c <free+0x7a>
 928:	6398                	ld	a4,0(a5)
 92a:	00e7e463          	bltu	a5,a4,932 <free+0x40>
 92e:	00e6ea63          	bltu	a3,a4,942 <free+0x50>
 932:	87ba                	mv	a5,a4
 934:	fed7fae3          	bgeu	a5,a3,928 <free+0x36>
 938:	6398                	ld	a4,0(a5)
 93a:	00e6e463          	bltu	a3,a4,942 <free+0x50>
 93e:	fee7eae3          	bltu	a5,a4,932 <free+0x40>
 942:	ff852583          	lw	a1,-8(a0)
 946:	6390                	ld	a2,0(a5)
 948:	02059713          	slli	a4,a1,0x20
 94c:	9301                	srli	a4,a4,0x20
 94e:	0712                	slli	a4,a4,0x4
 950:	9736                	add	a4,a4,a3
 952:	fae60ae3          	beq	a2,a4,906 <free+0x14>
 956:	fec53823          	sd	a2,-16(a0)
 95a:	4790                	lw	a2,8(a5)
 95c:	02061713          	slli	a4,a2,0x20
 960:	9301                	srli	a4,a4,0x20
 962:	0712                	slli	a4,a4,0x4
 964:	973e                	add	a4,a4,a5
 966:	fae689e3          	beq	a3,a4,918 <free+0x26>
 96a:	e394                	sd	a3,0(a5)
 96c:	00000717          	auipc	a4,0x0
 970:	26f73e23          	sd	a5,636(a4) # be8 <freep>
 974:	6422                	ld	s0,8(sp)
 976:	0141                	addi	sp,sp,16
 978:	8082                	ret

000000000000097a <malloc>:
 97a:	7139                	addi	sp,sp,-64
 97c:	fc06                	sd	ra,56(sp)
 97e:	f822                	sd	s0,48(sp)
 980:	f426                	sd	s1,40(sp)
 982:	f04a                	sd	s2,32(sp)
 984:	ec4e                	sd	s3,24(sp)
 986:	e852                	sd	s4,16(sp)
 988:	e456                	sd	s5,8(sp)
 98a:	e05a                	sd	s6,0(sp)
 98c:	0080                	addi	s0,sp,64
 98e:	02051493          	slli	s1,a0,0x20
 992:	9081                	srli	s1,s1,0x20
 994:	04bd                	addi	s1,s1,15
 996:	8091                	srli	s1,s1,0x4
 998:	0014899b          	addiw	s3,s1,1
 99c:	0485                	addi	s1,s1,1
 99e:	00000517          	auipc	a0,0x0
 9a2:	24a53503          	ld	a0,586(a0) # be8 <freep>
 9a6:	c515                	beqz	a0,9d2 <malloc+0x58>
 9a8:	611c                	ld	a5,0(a0)
 9aa:	4798                	lw	a4,8(a5)
 9ac:	02977f63          	bgeu	a4,s1,9ea <malloc+0x70>
 9b0:	8a4e                	mv	s4,s3
 9b2:	0009871b          	sext.w	a4,s3
 9b6:	6685                	lui	a3,0x1
 9b8:	00d77363          	bgeu	a4,a3,9be <malloc+0x44>
 9bc:	6a05                	lui	s4,0x1
 9be:	000a0b1b          	sext.w	s6,s4
 9c2:	004a1a1b          	slliw	s4,s4,0x4
 9c6:	00000917          	auipc	s2,0x0
 9ca:	22290913          	addi	s2,s2,546 # be8 <freep>
 9ce:	5afd                	li	s5,-1
 9d0:	a88d                	j	a42 <malloc+0xc8>
 9d2:	00000797          	auipc	a5,0x0
 9d6:	22e78793          	addi	a5,a5,558 # c00 <base>
 9da:	00000717          	auipc	a4,0x0
 9de:	20f73723          	sd	a5,526(a4) # be8 <freep>
 9e2:	e39c                	sd	a5,0(a5)
 9e4:	0007a423          	sw	zero,8(a5)
 9e8:	b7e1                	j	9b0 <malloc+0x36>
 9ea:	02e48b63          	beq	s1,a4,a20 <malloc+0xa6>
 9ee:	4137073b          	subw	a4,a4,s3
 9f2:	c798                	sw	a4,8(a5)
 9f4:	1702                	slli	a4,a4,0x20
 9f6:	9301                	srli	a4,a4,0x20
 9f8:	0712                	slli	a4,a4,0x4
 9fa:	97ba                	add	a5,a5,a4
 9fc:	0137a423          	sw	s3,8(a5)
 a00:	00000717          	auipc	a4,0x0
 a04:	1ea73423          	sd	a0,488(a4) # be8 <freep>
 a08:	01078513          	addi	a0,a5,16
 a0c:	70e2                	ld	ra,56(sp)
 a0e:	7442                	ld	s0,48(sp)
 a10:	74a2                	ld	s1,40(sp)
 a12:	7902                	ld	s2,32(sp)
 a14:	69e2                	ld	s3,24(sp)
 a16:	6a42                	ld	s4,16(sp)
 a18:	6aa2                	ld	s5,8(sp)
 a1a:	6b02                	ld	s6,0(sp)
 a1c:	6121                	addi	sp,sp,64
 a1e:	8082                	ret
 a20:	6398                	ld	a4,0(a5)
 a22:	e118                	sd	a4,0(a0)
 a24:	bff1                	j	a00 <malloc+0x86>
 a26:	01652423          	sw	s6,8(a0)
 a2a:	0541                	addi	a0,a0,16
 a2c:	00000097          	auipc	ra,0x0
 a30:	ec6080e7          	jalr	-314(ra) # 8f2 <free>
 a34:	00093503          	ld	a0,0(s2)
 a38:	d971                	beqz	a0,a0c <malloc+0x92>
 a3a:	611c                	ld	a5,0(a0)
 a3c:	4798                	lw	a4,8(a5)
 a3e:	fa9776e3          	bgeu	a4,s1,9ea <malloc+0x70>
 a42:	00093703          	ld	a4,0(s2)
 a46:	853e                	mv	a0,a5
 a48:	fef719e3          	bne	a4,a5,a3a <malloc+0xc0>
 a4c:	8552                	mv	a0,s4
 a4e:	00000097          	auipc	ra,0x0
 a52:	b7c080e7          	jalr	-1156(ra) # 5ca <sbrk>
 a56:	fd5518e3          	bne	a0,s5,a26 <malloc+0xac>
 a5a:	4501                	li	a0,0
 a5c:	bf45                	j	a0c <malloc+0x92>

0000000000000a5e <mem_init>:
 a5e:	1141                	addi	sp,sp,-16
 a60:	e406                	sd	ra,8(sp)
 a62:	e022                	sd	s0,0(sp)
 a64:	0800                	addi	s0,sp,16
 a66:	6505                	lui	a0,0x1
 a68:	00000097          	auipc	ra,0x0
 a6c:	b62080e7          	jalr	-1182(ra) # 5ca <sbrk>
 a70:	00000797          	auipc	a5,0x0
 a74:	16a7b823          	sd	a0,368(a5) # be0 <alloc>
 a78:	00850793          	addi	a5,a0,8 # 1008 <__BSS_END__+0x3f8>
 a7c:	e11c                	sd	a5,0(a0)
 a7e:	60a2                	ld	ra,8(sp)
 a80:	6402                	ld	s0,0(sp)
 a82:	0141                	addi	sp,sp,16
 a84:	8082                	ret

0000000000000a86 <l_alloc>:
 a86:	1101                	addi	sp,sp,-32
 a88:	ec06                	sd	ra,24(sp)
 a8a:	e822                	sd	s0,16(sp)
 a8c:	e426                	sd	s1,8(sp)
 a8e:	1000                	addi	s0,sp,32
 a90:	84aa                	mv	s1,a0
 a92:	00000797          	auipc	a5,0x0
 a96:	1467a783          	lw	a5,326(a5) # bd8 <if_init>
 a9a:	c795                	beqz	a5,ac6 <l_alloc+0x40>
 a9c:	00000717          	auipc	a4,0x0
 aa0:	14473703          	ld	a4,324(a4) # be0 <alloc>
 aa4:	6308                	ld	a0,0(a4)
 aa6:	40e506b3          	sub	a3,a0,a4
 aaa:	6785                	lui	a5,0x1
 aac:	37e1                	addiw	a5,a5,-8
 aae:	9f95                	subw	a5,a5,a3
 ab0:	02f4f563          	bgeu	s1,a5,ada <l_alloc+0x54>
 ab4:	1482                	slli	s1,s1,0x20
 ab6:	9081                	srli	s1,s1,0x20
 ab8:	94aa                	add	s1,s1,a0
 aba:	e304                	sd	s1,0(a4)
 abc:	60e2                	ld	ra,24(sp)
 abe:	6442                	ld	s0,16(sp)
 ac0:	64a2                	ld	s1,8(sp)
 ac2:	6105                	addi	sp,sp,32
 ac4:	8082                	ret
 ac6:	00000097          	auipc	ra,0x0
 aca:	f98080e7          	jalr	-104(ra) # a5e <mem_init>
 ace:	4785                	li	a5,1
 ad0:	00000717          	auipc	a4,0x0
 ad4:	10f72423          	sw	a5,264(a4) # bd8 <if_init>
 ad8:	b7d1                	j	a9c <l_alloc+0x16>
 ada:	4501                	li	a0,0
 adc:	b7c5                	j	abc <l_alloc+0x36>

0000000000000ade <l_free>:
 ade:	1141                	addi	sp,sp,-16
 ae0:	e422                	sd	s0,8(sp)
 ae2:	0800                	addi	s0,sp,16
 ae4:	6422                	ld	s0,8(sp)
 ae6:	0141                	addi	sp,sp,16
 ae8:	8082                	ret
