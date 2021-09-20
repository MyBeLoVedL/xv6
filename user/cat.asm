
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	89aa                	mv	s3,a0
  10:	00001917          	auipc	s2,0x1
  14:	a0090913          	addi	s2,s2,-1536 # a10 <buf>
  18:	20000613          	li	a2,512
  1c:	85ca                	mv	a1,s2
  1e:	854e                	mv	a0,s3
  20:	00000097          	auipc	ra,0x0
  24:	384080e7          	jalr	900(ra) # 3a4 <read>
  28:	84aa                	mv	s1,a0
  2a:	02a05963          	blez	a0,5c <cat+0x5c>
  2e:	8626                	mv	a2,s1
  30:	85ca                	mv	a1,s2
  32:	4505                	li	a0,1
  34:	00000097          	auipc	ra,0x0
  38:	378080e7          	jalr	888(ra) # 3ac <write>
  3c:	fc950ee3          	beq	a0,s1,18 <cat+0x18>
  40:	00001597          	auipc	a1,0x1
  44:	8f858593          	addi	a1,a1,-1800 # 938 <l_free+0x10>
  48:	4509                	li	a0,2
  4a:	00000097          	auipc	ra,0x0
  4e:	68e080e7          	jalr	1678(ra) # 6d8 <fprintf>
  52:	4505                	li	a0,1
  54:	00000097          	auipc	ra,0x0
  58:	338080e7          	jalr	824(ra) # 38c <exit>
  5c:	00054963          	bltz	a0,6e <cat+0x6e>
  60:	70a2                	ld	ra,40(sp)
  62:	7402                	ld	s0,32(sp)
  64:	64e2                	ld	s1,24(sp)
  66:	6942                	ld	s2,16(sp)
  68:	69a2                	ld	s3,8(sp)
  6a:	6145                	addi	sp,sp,48
  6c:	8082                	ret
  6e:	00001597          	auipc	a1,0x1
  72:	8e258593          	addi	a1,a1,-1822 # 950 <l_free+0x28>
  76:	4509                	li	a0,2
  78:	00000097          	auipc	ra,0x0
  7c:	660080e7          	jalr	1632(ra) # 6d8 <fprintf>
  80:	4505                	li	a0,1
  82:	00000097          	auipc	ra,0x0
  86:	30a080e7          	jalr	778(ra) # 38c <exit>

000000000000008a <main>:
  8a:	7179                	addi	sp,sp,-48
  8c:	f406                	sd	ra,40(sp)
  8e:	f022                	sd	s0,32(sp)
  90:	ec26                	sd	s1,24(sp)
  92:	e84a                	sd	s2,16(sp)
  94:	e44e                	sd	s3,8(sp)
  96:	e052                	sd	s4,0(sp)
  98:	1800                	addi	s0,sp,48
  9a:	4785                	li	a5,1
  9c:	04a7d763          	bge	a5,a0,ea <main+0x60>
  a0:	00858913          	addi	s2,a1,8
  a4:	ffe5099b          	addiw	s3,a0,-2
  a8:	1982                	slli	s3,s3,0x20
  aa:	0209d993          	srli	s3,s3,0x20
  ae:	098e                	slli	s3,s3,0x3
  b0:	05c1                	addi	a1,a1,16
  b2:	99ae                	add	s3,s3,a1
  b4:	4581                	li	a1,0
  b6:	00093503          	ld	a0,0(s2)
  ba:	00000097          	auipc	ra,0x0
  be:	312080e7          	jalr	786(ra) # 3cc <open>
  c2:	84aa                	mv	s1,a0
  c4:	02054d63          	bltz	a0,fe <main+0x74>
  c8:	00000097          	auipc	ra,0x0
  cc:	f38080e7          	jalr	-200(ra) # 0 <cat>
  d0:	8526                	mv	a0,s1
  d2:	00000097          	auipc	ra,0x0
  d6:	2e2080e7          	jalr	738(ra) # 3b4 <close>
  da:	0921                	addi	s2,s2,8
  dc:	fd391ce3          	bne	s2,s3,b4 <main+0x2a>
  e0:	4501                	li	a0,0
  e2:	00000097          	auipc	ra,0x0
  e6:	2aa080e7          	jalr	682(ra) # 38c <exit>
  ea:	4501                	li	a0,0
  ec:	00000097          	auipc	ra,0x0
  f0:	f14080e7          	jalr	-236(ra) # 0 <cat>
  f4:	4501                	li	a0,0
  f6:	00000097          	auipc	ra,0x0
  fa:	296080e7          	jalr	662(ra) # 38c <exit>
  fe:	00093603          	ld	a2,0(s2)
 102:	00001597          	auipc	a1,0x1
 106:	86658593          	addi	a1,a1,-1946 # 968 <l_free+0x40>
 10a:	4509                	li	a0,2
 10c:	00000097          	auipc	ra,0x0
 110:	5cc080e7          	jalr	1484(ra) # 6d8 <fprintf>
 114:	4505                	li	a0,1
 116:	00000097          	auipc	ra,0x0
 11a:	276080e7          	jalr	630(ra) # 38c <exit>

000000000000011e <strcpy>:
 11e:	1141                	addi	sp,sp,-16
 120:	e422                	sd	s0,8(sp)
 122:	0800                	addi	s0,sp,16
 124:	87aa                	mv	a5,a0
 126:	0585                	addi	a1,a1,1
 128:	0785                	addi	a5,a5,1
 12a:	fff5c703          	lbu	a4,-1(a1)
 12e:	fee78fa3          	sb	a4,-1(a5)
 132:	fb75                	bnez	a4,126 <strcpy+0x8>
 134:	6422                	ld	s0,8(sp)
 136:	0141                	addi	sp,sp,16
 138:	8082                	ret

000000000000013a <strcmp>:
 13a:	1141                	addi	sp,sp,-16
 13c:	e422                	sd	s0,8(sp)
 13e:	0800                	addi	s0,sp,16
 140:	00054783          	lbu	a5,0(a0)
 144:	cb91                	beqz	a5,158 <strcmp+0x1e>
 146:	0005c703          	lbu	a4,0(a1)
 14a:	00f71763          	bne	a4,a5,158 <strcmp+0x1e>
 14e:	0505                	addi	a0,a0,1
 150:	0585                	addi	a1,a1,1
 152:	00054783          	lbu	a5,0(a0)
 156:	fbe5                	bnez	a5,146 <strcmp+0xc>
 158:	0005c503          	lbu	a0,0(a1)
 15c:	40a7853b          	subw	a0,a5,a0
 160:	6422                	ld	s0,8(sp)
 162:	0141                	addi	sp,sp,16
 164:	8082                	ret

0000000000000166 <strlen>:
 166:	1141                	addi	sp,sp,-16
 168:	e422                	sd	s0,8(sp)
 16a:	0800                	addi	s0,sp,16
 16c:	00054783          	lbu	a5,0(a0)
 170:	cf91                	beqz	a5,18c <strlen+0x26>
 172:	0505                	addi	a0,a0,1
 174:	87aa                	mv	a5,a0
 176:	4685                	li	a3,1
 178:	9e89                	subw	a3,a3,a0
 17a:	00f6853b          	addw	a0,a3,a5
 17e:	0785                	addi	a5,a5,1
 180:	fff7c703          	lbu	a4,-1(a5)
 184:	fb7d                	bnez	a4,17a <strlen+0x14>
 186:	6422                	ld	s0,8(sp)
 188:	0141                	addi	sp,sp,16
 18a:	8082                	ret
 18c:	4501                	li	a0,0
 18e:	bfe5                	j	186 <strlen+0x20>

0000000000000190 <memset>:
 190:	1141                	addi	sp,sp,-16
 192:	e422                	sd	s0,8(sp)
 194:	0800                	addi	s0,sp,16
 196:	ca19                	beqz	a2,1ac <memset+0x1c>
 198:	87aa                	mv	a5,a0
 19a:	1602                	slli	a2,a2,0x20
 19c:	9201                	srli	a2,a2,0x20
 19e:	00a60733          	add	a4,a2,a0
 1a2:	00b78023          	sb	a1,0(a5)
 1a6:	0785                	addi	a5,a5,1
 1a8:	fee79de3          	bne	a5,a4,1a2 <memset+0x12>
 1ac:	6422                	ld	s0,8(sp)
 1ae:	0141                	addi	sp,sp,16
 1b0:	8082                	ret

00000000000001b2 <strchr>:
 1b2:	1141                	addi	sp,sp,-16
 1b4:	e422                	sd	s0,8(sp)
 1b6:	0800                	addi	s0,sp,16
 1b8:	00054783          	lbu	a5,0(a0)
 1bc:	cb99                	beqz	a5,1d2 <strchr+0x20>
 1be:	00f58763          	beq	a1,a5,1cc <strchr+0x1a>
 1c2:	0505                	addi	a0,a0,1
 1c4:	00054783          	lbu	a5,0(a0)
 1c8:	fbfd                	bnez	a5,1be <strchr+0xc>
 1ca:	4501                	li	a0,0
 1cc:	6422                	ld	s0,8(sp)
 1ce:	0141                	addi	sp,sp,16
 1d0:	8082                	ret
 1d2:	4501                	li	a0,0
 1d4:	bfe5                	j	1cc <strchr+0x1a>

00000000000001d6 <gets>:
 1d6:	711d                	addi	sp,sp,-96
 1d8:	ec86                	sd	ra,88(sp)
 1da:	e8a2                	sd	s0,80(sp)
 1dc:	e4a6                	sd	s1,72(sp)
 1de:	e0ca                	sd	s2,64(sp)
 1e0:	fc4e                	sd	s3,56(sp)
 1e2:	f852                	sd	s4,48(sp)
 1e4:	f456                	sd	s5,40(sp)
 1e6:	f05a                	sd	s6,32(sp)
 1e8:	ec5e                	sd	s7,24(sp)
 1ea:	1080                	addi	s0,sp,96
 1ec:	8baa                	mv	s7,a0
 1ee:	8a2e                	mv	s4,a1
 1f0:	892a                	mv	s2,a0
 1f2:	4481                	li	s1,0
 1f4:	4aa9                	li	s5,10
 1f6:	4b35                	li	s6,13
 1f8:	89a6                	mv	s3,s1
 1fa:	2485                	addiw	s1,s1,1
 1fc:	0344d863          	bge	s1,s4,22c <gets+0x56>
 200:	4605                	li	a2,1
 202:	faf40593          	addi	a1,s0,-81
 206:	4501                	li	a0,0
 208:	00000097          	auipc	ra,0x0
 20c:	19c080e7          	jalr	412(ra) # 3a4 <read>
 210:	00a05e63          	blez	a0,22c <gets+0x56>
 214:	faf44783          	lbu	a5,-81(s0)
 218:	00f90023          	sb	a5,0(s2)
 21c:	01578763          	beq	a5,s5,22a <gets+0x54>
 220:	0905                	addi	s2,s2,1
 222:	fd679be3          	bne	a5,s6,1f8 <gets+0x22>
 226:	89a6                	mv	s3,s1
 228:	a011                	j	22c <gets+0x56>
 22a:	89a6                	mv	s3,s1
 22c:	99de                	add	s3,s3,s7
 22e:	00098023          	sb	zero,0(s3)
 232:	855e                	mv	a0,s7
 234:	60e6                	ld	ra,88(sp)
 236:	6446                	ld	s0,80(sp)
 238:	64a6                	ld	s1,72(sp)
 23a:	6906                	ld	s2,64(sp)
 23c:	79e2                	ld	s3,56(sp)
 23e:	7a42                	ld	s4,48(sp)
 240:	7aa2                	ld	s5,40(sp)
 242:	7b02                	ld	s6,32(sp)
 244:	6be2                	ld	s7,24(sp)
 246:	6125                	addi	sp,sp,96
 248:	8082                	ret

000000000000024a <stat>:
 24a:	1101                	addi	sp,sp,-32
 24c:	ec06                	sd	ra,24(sp)
 24e:	e822                	sd	s0,16(sp)
 250:	e426                	sd	s1,8(sp)
 252:	e04a                	sd	s2,0(sp)
 254:	1000                	addi	s0,sp,32
 256:	892e                	mv	s2,a1
 258:	4581                	li	a1,0
 25a:	00000097          	auipc	ra,0x0
 25e:	172080e7          	jalr	370(ra) # 3cc <open>
 262:	02054563          	bltz	a0,28c <stat+0x42>
 266:	84aa                	mv	s1,a0
 268:	85ca                	mv	a1,s2
 26a:	00000097          	auipc	ra,0x0
 26e:	17a080e7          	jalr	378(ra) # 3e4 <fstat>
 272:	892a                	mv	s2,a0
 274:	8526                	mv	a0,s1
 276:	00000097          	auipc	ra,0x0
 27a:	13e080e7          	jalr	318(ra) # 3b4 <close>
 27e:	854a                	mv	a0,s2
 280:	60e2                	ld	ra,24(sp)
 282:	6442                	ld	s0,16(sp)
 284:	64a2                	ld	s1,8(sp)
 286:	6902                	ld	s2,0(sp)
 288:	6105                	addi	sp,sp,32
 28a:	8082                	ret
 28c:	597d                	li	s2,-1
 28e:	bfc5                	j	27e <stat+0x34>

0000000000000290 <atoi>:
 290:	1141                	addi	sp,sp,-16
 292:	e422                	sd	s0,8(sp)
 294:	0800                	addi	s0,sp,16
 296:	00054603          	lbu	a2,0(a0)
 29a:	fd06079b          	addiw	a5,a2,-48
 29e:	0ff7f793          	zext.b	a5,a5
 2a2:	4725                	li	a4,9
 2a4:	02f76963          	bltu	a4,a5,2d6 <atoi+0x46>
 2a8:	86aa                	mv	a3,a0
 2aa:	4501                	li	a0,0
 2ac:	45a5                	li	a1,9
 2ae:	0685                	addi	a3,a3,1
 2b0:	0025179b          	slliw	a5,a0,0x2
 2b4:	9fa9                	addw	a5,a5,a0
 2b6:	0017979b          	slliw	a5,a5,0x1
 2ba:	9fb1                	addw	a5,a5,a2
 2bc:	fd07851b          	addiw	a0,a5,-48
 2c0:	0006c603          	lbu	a2,0(a3)
 2c4:	fd06071b          	addiw	a4,a2,-48
 2c8:	0ff77713          	zext.b	a4,a4
 2cc:	fee5f1e3          	bgeu	a1,a4,2ae <atoi+0x1e>
 2d0:	6422                	ld	s0,8(sp)
 2d2:	0141                	addi	sp,sp,16
 2d4:	8082                	ret
 2d6:	4501                	li	a0,0
 2d8:	bfe5                	j	2d0 <atoi+0x40>

00000000000002da <memmove>:
 2da:	1141                	addi	sp,sp,-16
 2dc:	e422                	sd	s0,8(sp)
 2de:	0800                	addi	s0,sp,16
 2e0:	02b57463          	bgeu	a0,a1,308 <memmove+0x2e>
 2e4:	00c05f63          	blez	a2,302 <memmove+0x28>
 2e8:	1602                	slli	a2,a2,0x20
 2ea:	9201                	srli	a2,a2,0x20
 2ec:	00c507b3          	add	a5,a0,a2
 2f0:	872a                	mv	a4,a0
 2f2:	0585                	addi	a1,a1,1
 2f4:	0705                	addi	a4,a4,1
 2f6:	fff5c683          	lbu	a3,-1(a1)
 2fa:	fed70fa3          	sb	a3,-1(a4)
 2fe:	fee79ae3          	bne	a5,a4,2f2 <memmove+0x18>
 302:	6422                	ld	s0,8(sp)
 304:	0141                	addi	sp,sp,16
 306:	8082                	ret
 308:	00c50733          	add	a4,a0,a2
 30c:	95b2                	add	a1,a1,a2
 30e:	fec05ae3          	blez	a2,302 <memmove+0x28>
 312:	fff6079b          	addiw	a5,a2,-1
 316:	1782                	slli	a5,a5,0x20
 318:	9381                	srli	a5,a5,0x20
 31a:	fff7c793          	not	a5,a5
 31e:	97ba                	add	a5,a5,a4
 320:	15fd                	addi	a1,a1,-1
 322:	177d                	addi	a4,a4,-1
 324:	0005c683          	lbu	a3,0(a1)
 328:	00d70023          	sb	a3,0(a4)
 32c:	fee79ae3          	bne	a5,a4,320 <memmove+0x46>
 330:	bfc9                	j	302 <memmove+0x28>

0000000000000332 <memcmp>:
 332:	1141                	addi	sp,sp,-16
 334:	e422                	sd	s0,8(sp)
 336:	0800                	addi	s0,sp,16
 338:	ca05                	beqz	a2,368 <memcmp+0x36>
 33a:	fff6069b          	addiw	a3,a2,-1
 33e:	1682                	slli	a3,a3,0x20
 340:	9281                	srli	a3,a3,0x20
 342:	0685                	addi	a3,a3,1
 344:	96aa                	add	a3,a3,a0
 346:	00054783          	lbu	a5,0(a0)
 34a:	0005c703          	lbu	a4,0(a1)
 34e:	00e79863          	bne	a5,a4,35e <memcmp+0x2c>
 352:	0505                	addi	a0,a0,1
 354:	0585                	addi	a1,a1,1
 356:	fed518e3          	bne	a0,a3,346 <memcmp+0x14>
 35a:	4501                	li	a0,0
 35c:	a019                	j	362 <memcmp+0x30>
 35e:	40e7853b          	subw	a0,a5,a4
 362:	6422                	ld	s0,8(sp)
 364:	0141                	addi	sp,sp,16
 366:	8082                	ret
 368:	4501                	li	a0,0
 36a:	bfe5                	j	362 <memcmp+0x30>

000000000000036c <memcpy>:
 36c:	1141                	addi	sp,sp,-16
 36e:	e406                	sd	ra,8(sp)
 370:	e022                	sd	s0,0(sp)
 372:	0800                	addi	s0,sp,16
 374:	00000097          	auipc	ra,0x0
 378:	f66080e7          	jalr	-154(ra) # 2da <memmove>
 37c:	60a2                	ld	ra,8(sp)
 37e:	6402                	ld	s0,0(sp)
 380:	0141                	addi	sp,sp,16
 382:	8082                	ret

0000000000000384 <fork>:
 384:	4885                	li	a7,1
 386:	00000073          	ecall
 38a:	8082                	ret

000000000000038c <exit>:
 38c:	4889                	li	a7,2
 38e:	00000073          	ecall
 392:	8082                	ret

0000000000000394 <wait>:
 394:	488d                	li	a7,3
 396:	00000073          	ecall
 39a:	8082                	ret

000000000000039c <pipe>:
 39c:	4891                	li	a7,4
 39e:	00000073          	ecall
 3a2:	8082                	ret

00000000000003a4 <read>:
 3a4:	4895                	li	a7,5
 3a6:	00000073          	ecall
 3aa:	8082                	ret

00000000000003ac <write>:
 3ac:	48c1                	li	a7,16
 3ae:	00000073          	ecall
 3b2:	8082                	ret

00000000000003b4 <close>:
 3b4:	48d5                	li	a7,21
 3b6:	00000073          	ecall
 3ba:	8082                	ret

00000000000003bc <kill>:
 3bc:	4899                	li	a7,6
 3be:	00000073          	ecall
 3c2:	8082                	ret

00000000000003c4 <exec>:
 3c4:	489d                	li	a7,7
 3c6:	00000073          	ecall
 3ca:	8082                	ret

00000000000003cc <open>:
 3cc:	48bd                	li	a7,15
 3ce:	00000073          	ecall
 3d2:	8082                	ret

00000000000003d4 <mknod>:
 3d4:	48c5                	li	a7,17
 3d6:	00000073          	ecall
 3da:	8082                	ret

00000000000003dc <unlink>:
 3dc:	48c9                	li	a7,18
 3de:	00000073          	ecall
 3e2:	8082                	ret

00000000000003e4 <fstat>:
 3e4:	48a1                	li	a7,8
 3e6:	00000073          	ecall
 3ea:	8082                	ret

00000000000003ec <link>:
 3ec:	48cd                	li	a7,19
 3ee:	00000073          	ecall
 3f2:	8082                	ret

00000000000003f4 <mkdir>:
 3f4:	48d1                	li	a7,20
 3f6:	00000073          	ecall
 3fa:	8082                	ret

00000000000003fc <chdir>:
 3fc:	48a5                	li	a7,9
 3fe:	00000073          	ecall
 402:	8082                	ret

0000000000000404 <dup>:
 404:	48a9                	li	a7,10
 406:	00000073          	ecall
 40a:	8082                	ret

000000000000040c <getpid>:
 40c:	48ad                	li	a7,11
 40e:	00000073          	ecall
 412:	8082                	ret

0000000000000414 <sbrk>:
 414:	48b1                	li	a7,12
 416:	00000073          	ecall
 41a:	8082                	ret

000000000000041c <sleep>:
 41c:	48b5                	li	a7,13
 41e:	00000073          	ecall
 422:	8082                	ret

0000000000000424 <uptime>:
 424:	48b9                	li	a7,14
 426:	00000073          	ecall
 42a:	8082                	ret

000000000000042c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 42c:	1101                	addi	sp,sp,-32
 42e:	ec06                	sd	ra,24(sp)
 430:	e822                	sd	s0,16(sp)
 432:	1000                	addi	s0,sp,32
 434:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 438:	4605                	li	a2,1
 43a:	fef40593          	addi	a1,s0,-17
 43e:	00000097          	auipc	ra,0x0
 442:	f6e080e7          	jalr	-146(ra) # 3ac <write>
}
 446:	60e2                	ld	ra,24(sp)
 448:	6442                	ld	s0,16(sp)
 44a:	6105                	addi	sp,sp,32
 44c:	8082                	ret

000000000000044e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 44e:	7139                	addi	sp,sp,-64
 450:	fc06                	sd	ra,56(sp)
 452:	f822                	sd	s0,48(sp)
 454:	f426                	sd	s1,40(sp)
 456:	f04a                	sd	s2,32(sp)
 458:	ec4e                	sd	s3,24(sp)
 45a:	0080                	addi	s0,sp,64
 45c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 45e:	c299                	beqz	a3,464 <printint+0x16>
 460:	0805c963          	bltz	a1,4f2 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 464:	2581                	sext.w	a1,a1
  neg = 0;
 466:	4881                	li	a7,0
 468:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 46c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 46e:	2601                	sext.w	a2,a2
 470:	00000517          	auipc	a0,0x0
 474:	57050513          	addi	a0,a0,1392 # 9e0 <digits>
 478:	883a                	mv	a6,a4
 47a:	2705                	addiw	a4,a4,1
 47c:	02c5f7bb          	remuw	a5,a1,a2
 480:	1782                	slli	a5,a5,0x20
 482:	9381                	srli	a5,a5,0x20
 484:	97aa                	add	a5,a5,a0
 486:	0007c783          	lbu	a5,0(a5)
 48a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 48e:	0005879b          	sext.w	a5,a1
 492:	02c5d5bb          	divuw	a1,a1,a2
 496:	0685                	addi	a3,a3,1
 498:	fec7f0e3          	bgeu	a5,a2,478 <printint+0x2a>
  if(neg)
 49c:	00088c63          	beqz	a7,4b4 <printint+0x66>
    buf[i++] = '-';
 4a0:	fd070793          	addi	a5,a4,-48
 4a4:	00878733          	add	a4,a5,s0
 4a8:	02d00793          	li	a5,45
 4ac:	fef70823          	sb	a5,-16(a4)
 4b0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4b4:	02e05863          	blez	a4,4e4 <printint+0x96>
 4b8:	fc040793          	addi	a5,s0,-64
 4bc:	00e78933          	add	s2,a5,a4
 4c0:	fff78993          	addi	s3,a5,-1
 4c4:	99ba                	add	s3,s3,a4
 4c6:	377d                	addiw	a4,a4,-1
 4c8:	1702                	slli	a4,a4,0x20
 4ca:	9301                	srli	a4,a4,0x20
 4cc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4d0:	fff94583          	lbu	a1,-1(s2)
 4d4:	8526                	mv	a0,s1
 4d6:	00000097          	auipc	ra,0x0
 4da:	f56080e7          	jalr	-170(ra) # 42c <putc>
  while(--i >= 0)
 4de:	197d                	addi	s2,s2,-1
 4e0:	ff3918e3          	bne	s2,s3,4d0 <printint+0x82>
}
 4e4:	70e2                	ld	ra,56(sp)
 4e6:	7442                	ld	s0,48(sp)
 4e8:	74a2                	ld	s1,40(sp)
 4ea:	7902                	ld	s2,32(sp)
 4ec:	69e2                	ld	s3,24(sp)
 4ee:	6121                	addi	sp,sp,64
 4f0:	8082                	ret
    x = -xx;
 4f2:	40b005bb          	negw	a1,a1
    neg = 1;
 4f6:	4885                	li	a7,1
    x = -xx;
 4f8:	bf85                	j	468 <printint+0x1a>

00000000000004fa <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4fa:	7119                	addi	sp,sp,-128
 4fc:	fc86                	sd	ra,120(sp)
 4fe:	f8a2                	sd	s0,112(sp)
 500:	f4a6                	sd	s1,104(sp)
 502:	f0ca                	sd	s2,96(sp)
 504:	ecce                	sd	s3,88(sp)
 506:	e8d2                	sd	s4,80(sp)
 508:	e4d6                	sd	s5,72(sp)
 50a:	e0da                	sd	s6,64(sp)
 50c:	fc5e                	sd	s7,56(sp)
 50e:	f862                	sd	s8,48(sp)
 510:	f466                	sd	s9,40(sp)
 512:	f06a                	sd	s10,32(sp)
 514:	ec6e                	sd	s11,24(sp)
 516:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 518:	0005c903          	lbu	s2,0(a1)
 51c:	18090f63          	beqz	s2,6ba <vprintf+0x1c0>
 520:	8aaa                	mv	s5,a0
 522:	8b32                	mv	s6,a2
 524:	00158493          	addi	s1,a1,1
  state = 0;
 528:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 52a:	02500a13          	li	s4,37
 52e:	4c55                	li	s8,21
 530:	00000c97          	auipc	s9,0x0
 534:	458c8c93          	addi	s9,s9,1112 # 988 <l_free+0x60>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 538:	02800d93          	li	s11,40
  putc(fd, 'x');
 53c:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 53e:	00000b97          	auipc	s7,0x0
 542:	4a2b8b93          	addi	s7,s7,1186 # 9e0 <digits>
 546:	a839                	j	564 <vprintf+0x6a>
        putc(fd, c);
 548:	85ca                	mv	a1,s2
 54a:	8556                	mv	a0,s5
 54c:	00000097          	auipc	ra,0x0
 550:	ee0080e7          	jalr	-288(ra) # 42c <putc>
 554:	a019                	j	55a <vprintf+0x60>
    } else if(state == '%'){
 556:	01498d63          	beq	s3,s4,570 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 55a:	0485                	addi	s1,s1,1
 55c:	fff4c903          	lbu	s2,-1(s1)
 560:	14090d63          	beqz	s2,6ba <vprintf+0x1c0>
    if(state == 0){
 564:	fe0999e3          	bnez	s3,556 <vprintf+0x5c>
      if(c == '%'){
 568:	ff4910e3          	bne	s2,s4,548 <vprintf+0x4e>
        state = '%';
 56c:	89d2                	mv	s3,s4
 56e:	b7f5                	j	55a <vprintf+0x60>
      if(c == 'd'){
 570:	11490c63          	beq	s2,s4,688 <vprintf+0x18e>
 574:	f9d9079b          	addiw	a5,s2,-99
 578:	0ff7f793          	zext.b	a5,a5
 57c:	10fc6e63          	bltu	s8,a5,698 <vprintf+0x19e>
 580:	f9d9079b          	addiw	a5,s2,-99
 584:	0ff7f713          	zext.b	a4,a5
 588:	10ec6863          	bltu	s8,a4,698 <vprintf+0x19e>
 58c:	00271793          	slli	a5,a4,0x2
 590:	97e6                	add	a5,a5,s9
 592:	439c                	lw	a5,0(a5)
 594:	97e6                	add	a5,a5,s9
 596:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 598:	008b0913          	addi	s2,s6,8
 59c:	4685                	li	a3,1
 59e:	4629                	li	a2,10
 5a0:	000b2583          	lw	a1,0(s6)
 5a4:	8556                	mv	a0,s5
 5a6:	00000097          	auipc	ra,0x0
 5aa:	ea8080e7          	jalr	-344(ra) # 44e <printint>
 5ae:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5b0:	4981                	li	s3,0
 5b2:	b765                	j	55a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b4:	008b0913          	addi	s2,s6,8
 5b8:	4681                	li	a3,0
 5ba:	4629                	li	a2,10
 5bc:	000b2583          	lw	a1,0(s6)
 5c0:	8556                	mv	a0,s5
 5c2:	00000097          	auipc	ra,0x0
 5c6:	e8c080e7          	jalr	-372(ra) # 44e <printint>
 5ca:	8b4a                	mv	s6,s2
      state = 0;
 5cc:	4981                	li	s3,0
 5ce:	b771                	j	55a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5d0:	008b0913          	addi	s2,s6,8
 5d4:	4681                	li	a3,0
 5d6:	866a                	mv	a2,s10
 5d8:	000b2583          	lw	a1,0(s6)
 5dc:	8556                	mv	a0,s5
 5de:	00000097          	auipc	ra,0x0
 5e2:	e70080e7          	jalr	-400(ra) # 44e <printint>
 5e6:	8b4a                	mv	s6,s2
      state = 0;
 5e8:	4981                	li	s3,0
 5ea:	bf85                	j	55a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5ec:	008b0793          	addi	a5,s6,8
 5f0:	f8f43423          	sd	a5,-120(s0)
 5f4:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5f8:	03000593          	li	a1,48
 5fc:	8556                	mv	a0,s5
 5fe:	00000097          	auipc	ra,0x0
 602:	e2e080e7          	jalr	-466(ra) # 42c <putc>
  putc(fd, 'x');
 606:	07800593          	li	a1,120
 60a:	8556                	mv	a0,s5
 60c:	00000097          	auipc	ra,0x0
 610:	e20080e7          	jalr	-480(ra) # 42c <putc>
 614:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 616:	03c9d793          	srli	a5,s3,0x3c
 61a:	97de                	add	a5,a5,s7
 61c:	0007c583          	lbu	a1,0(a5)
 620:	8556                	mv	a0,s5
 622:	00000097          	auipc	ra,0x0
 626:	e0a080e7          	jalr	-502(ra) # 42c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 62a:	0992                	slli	s3,s3,0x4
 62c:	397d                	addiw	s2,s2,-1
 62e:	fe0914e3          	bnez	s2,616 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 632:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 636:	4981                	li	s3,0
 638:	b70d                	j	55a <vprintf+0x60>
        s = va_arg(ap, char*);
 63a:	008b0913          	addi	s2,s6,8
 63e:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 642:	02098163          	beqz	s3,664 <vprintf+0x16a>
        while(*s != 0){
 646:	0009c583          	lbu	a1,0(s3)
 64a:	c5ad                	beqz	a1,6b4 <vprintf+0x1ba>
          putc(fd, *s);
 64c:	8556                	mv	a0,s5
 64e:	00000097          	auipc	ra,0x0
 652:	dde080e7          	jalr	-546(ra) # 42c <putc>
          s++;
 656:	0985                	addi	s3,s3,1
        while(*s != 0){
 658:	0009c583          	lbu	a1,0(s3)
 65c:	f9e5                	bnez	a1,64c <vprintf+0x152>
        s = va_arg(ap, char*);
 65e:	8b4a                	mv	s6,s2
      state = 0;
 660:	4981                	li	s3,0
 662:	bde5                	j	55a <vprintf+0x60>
          s = "(null)";
 664:	00000997          	auipc	s3,0x0
 668:	31c98993          	addi	s3,s3,796 # 980 <l_free+0x58>
        while(*s != 0){
 66c:	85ee                	mv	a1,s11
 66e:	bff9                	j	64c <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 670:	008b0913          	addi	s2,s6,8
 674:	000b4583          	lbu	a1,0(s6)
 678:	8556                	mv	a0,s5
 67a:	00000097          	auipc	ra,0x0
 67e:	db2080e7          	jalr	-590(ra) # 42c <putc>
 682:	8b4a                	mv	s6,s2
      state = 0;
 684:	4981                	li	s3,0
 686:	bdd1                	j	55a <vprintf+0x60>
        putc(fd, c);
 688:	85d2                	mv	a1,s4
 68a:	8556                	mv	a0,s5
 68c:	00000097          	auipc	ra,0x0
 690:	da0080e7          	jalr	-608(ra) # 42c <putc>
      state = 0;
 694:	4981                	li	s3,0
 696:	b5d1                	j	55a <vprintf+0x60>
        putc(fd, '%');
 698:	85d2                	mv	a1,s4
 69a:	8556                	mv	a0,s5
 69c:	00000097          	auipc	ra,0x0
 6a0:	d90080e7          	jalr	-624(ra) # 42c <putc>
        putc(fd, c);
 6a4:	85ca                	mv	a1,s2
 6a6:	8556                	mv	a0,s5
 6a8:	00000097          	auipc	ra,0x0
 6ac:	d84080e7          	jalr	-636(ra) # 42c <putc>
      state = 0;
 6b0:	4981                	li	s3,0
 6b2:	b565                	j	55a <vprintf+0x60>
        s = va_arg(ap, char*);
 6b4:	8b4a                	mv	s6,s2
      state = 0;
 6b6:	4981                	li	s3,0
 6b8:	b54d                	j	55a <vprintf+0x60>
    }
  }
}
 6ba:	70e6                	ld	ra,120(sp)
 6bc:	7446                	ld	s0,112(sp)
 6be:	74a6                	ld	s1,104(sp)
 6c0:	7906                	ld	s2,96(sp)
 6c2:	69e6                	ld	s3,88(sp)
 6c4:	6a46                	ld	s4,80(sp)
 6c6:	6aa6                	ld	s5,72(sp)
 6c8:	6b06                	ld	s6,64(sp)
 6ca:	7be2                	ld	s7,56(sp)
 6cc:	7c42                	ld	s8,48(sp)
 6ce:	7ca2                	ld	s9,40(sp)
 6d0:	7d02                	ld	s10,32(sp)
 6d2:	6de2                	ld	s11,24(sp)
 6d4:	6109                	addi	sp,sp,128
 6d6:	8082                	ret

00000000000006d8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6d8:	715d                	addi	sp,sp,-80
 6da:	ec06                	sd	ra,24(sp)
 6dc:	e822                	sd	s0,16(sp)
 6de:	1000                	addi	s0,sp,32
 6e0:	e010                	sd	a2,0(s0)
 6e2:	e414                	sd	a3,8(s0)
 6e4:	e818                	sd	a4,16(s0)
 6e6:	ec1c                	sd	a5,24(s0)
 6e8:	03043023          	sd	a6,32(s0)
 6ec:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6f0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6f4:	8622                	mv	a2,s0
 6f6:	00000097          	auipc	ra,0x0
 6fa:	e04080e7          	jalr	-508(ra) # 4fa <vprintf>
}
 6fe:	60e2                	ld	ra,24(sp)
 700:	6442                	ld	s0,16(sp)
 702:	6161                	addi	sp,sp,80
 704:	8082                	ret

0000000000000706 <printf>:

void
printf(const char *fmt, ...)
{
 706:	711d                	addi	sp,sp,-96
 708:	ec06                	sd	ra,24(sp)
 70a:	e822                	sd	s0,16(sp)
 70c:	1000                	addi	s0,sp,32
 70e:	e40c                	sd	a1,8(s0)
 710:	e810                	sd	a2,16(s0)
 712:	ec14                	sd	a3,24(s0)
 714:	f018                	sd	a4,32(s0)
 716:	f41c                	sd	a5,40(s0)
 718:	03043823          	sd	a6,48(s0)
 71c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 720:	00840613          	addi	a2,s0,8
 724:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 728:	85aa                	mv	a1,a0
 72a:	4505                	li	a0,1
 72c:	00000097          	auipc	ra,0x0
 730:	dce080e7          	jalr	-562(ra) # 4fa <vprintf>
}
 734:	60e2                	ld	ra,24(sp)
 736:	6442                	ld	s0,16(sp)
 738:	6125                	addi	sp,sp,96
 73a:	8082                	ret

000000000000073c <free>:
 73c:	1141                	addi	sp,sp,-16
 73e:	e422                	sd	s0,8(sp)
 740:	0800                	addi	s0,sp,16
 742:	ff050693          	addi	a3,a0,-16
 746:	00000797          	auipc	a5,0x0
 74a:	2c27b783          	ld	a5,706(a5) # a08 <freep>
 74e:	a805                	j	77e <free+0x42>
 750:	4618                	lw	a4,8(a2)
 752:	9db9                	addw	a1,a1,a4
 754:	feb52c23          	sw	a1,-8(a0)
 758:	6398                	ld	a4,0(a5)
 75a:	6318                	ld	a4,0(a4)
 75c:	fee53823          	sd	a4,-16(a0)
 760:	a091                	j	7a4 <free+0x68>
 762:	ff852703          	lw	a4,-8(a0)
 766:	9e39                	addw	a2,a2,a4
 768:	c790                	sw	a2,8(a5)
 76a:	ff053703          	ld	a4,-16(a0)
 76e:	e398                	sd	a4,0(a5)
 770:	a099                	j	7b6 <free+0x7a>
 772:	6398                	ld	a4,0(a5)
 774:	00e7e463          	bltu	a5,a4,77c <free+0x40>
 778:	00e6ea63          	bltu	a3,a4,78c <free+0x50>
 77c:	87ba                	mv	a5,a4
 77e:	fed7fae3          	bgeu	a5,a3,772 <free+0x36>
 782:	6398                	ld	a4,0(a5)
 784:	00e6e463          	bltu	a3,a4,78c <free+0x50>
 788:	fee7eae3          	bltu	a5,a4,77c <free+0x40>
 78c:	ff852583          	lw	a1,-8(a0)
 790:	6390                	ld	a2,0(a5)
 792:	02059713          	slli	a4,a1,0x20
 796:	9301                	srli	a4,a4,0x20
 798:	0712                	slli	a4,a4,0x4
 79a:	9736                	add	a4,a4,a3
 79c:	fae60ae3          	beq	a2,a4,750 <free+0x14>
 7a0:	fec53823          	sd	a2,-16(a0)
 7a4:	4790                	lw	a2,8(a5)
 7a6:	02061713          	slli	a4,a2,0x20
 7aa:	9301                	srli	a4,a4,0x20
 7ac:	0712                	slli	a4,a4,0x4
 7ae:	973e                	add	a4,a4,a5
 7b0:	fae689e3          	beq	a3,a4,762 <free+0x26>
 7b4:	e394                	sd	a3,0(a5)
 7b6:	00000717          	auipc	a4,0x0
 7ba:	24f73923          	sd	a5,594(a4) # a08 <freep>
 7be:	6422                	ld	s0,8(sp)
 7c0:	0141                	addi	sp,sp,16
 7c2:	8082                	ret

00000000000007c4 <malloc>:
 7c4:	7139                	addi	sp,sp,-64
 7c6:	fc06                	sd	ra,56(sp)
 7c8:	f822                	sd	s0,48(sp)
 7ca:	f426                	sd	s1,40(sp)
 7cc:	f04a                	sd	s2,32(sp)
 7ce:	ec4e                	sd	s3,24(sp)
 7d0:	e852                	sd	s4,16(sp)
 7d2:	e456                	sd	s5,8(sp)
 7d4:	e05a                	sd	s6,0(sp)
 7d6:	0080                	addi	s0,sp,64
 7d8:	02051493          	slli	s1,a0,0x20
 7dc:	9081                	srli	s1,s1,0x20
 7de:	04bd                	addi	s1,s1,15
 7e0:	8091                	srli	s1,s1,0x4
 7e2:	0014899b          	addiw	s3,s1,1
 7e6:	0485                	addi	s1,s1,1
 7e8:	00000517          	auipc	a0,0x0
 7ec:	22053503          	ld	a0,544(a0) # a08 <freep>
 7f0:	c515                	beqz	a0,81c <malloc+0x58>
 7f2:	611c                	ld	a5,0(a0)
 7f4:	4798                	lw	a4,8(a5)
 7f6:	02977f63          	bgeu	a4,s1,834 <malloc+0x70>
 7fa:	8a4e                	mv	s4,s3
 7fc:	0009871b          	sext.w	a4,s3
 800:	6685                	lui	a3,0x1
 802:	00d77363          	bgeu	a4,a3,808 <malloc+0x44>
 806:	6a05                	lui	s4,0x1
 808:	000a0b1b          	sext.w	s6,s4
 80c:	004a1a1b          	slliw	s4,s4,0x4
 810:	00000917          	auipc	s2,0x0
 814:	1f890913          	addi	s2,s2,504 # a08 <freep>
 818:	5afd                	li	s5,-1
 81a:	a88d                	j	88c <malloc+0xc8>
 81c:	00000797          	auipc	a5,0x0
 820:	3f478793          	addi	a5,a5,1012 # c10 <base>
 824:	00000717          	auipc	a4,0x0
 828:	1ef73223          	sd	a5,484(a4) # a08 <freep>
 82c:	e39c                	sd	a5,0(a5)
 82e:	0007a423          	sw	zero,8(a5)
 832:	b7e1                	j	7fa <malloc+0x36>
 834:	02e48b63          	beq	s1,a4,86a <malloc+0xa6>
 838:	4137073b          	subw	a4,a4,s3
 83c:	c798                	sw	a4,8(a5)
 83e:	1702                	slli	a4,a4,0x20
 840:	9301                	srli	a4,a4,0x20
 842:	0712                	slli	a4,a4,0x4
 844:	97ba                	add	a5,a5,a4
 846:	0137a423          	sw	s3,8(a5)
 84a:	00000717          	auipc	a4,0x0
 84e:	1aa73f23          	sd	a0,446(a4) # a08 <freep>
 852:	01078513          	addi	a0,a5,16
 856:	70e2                	ld	ra,56(sp)
 858:	7442                	ld	s0,48(sp)
 85a:	74a2                	ld	s1,40(sp)
 85c:	7902                	ld	s2,32(sp)
 85e:	69e2                	ld	s3,24(sp)
 860:	6a42                	ld	s4,16(sp)
 862:	6aa2                	ld	s5,8(sp)
 864:	6b02                	ld	s6,0(sp)
 866:	6121                	addi	sp,sp,64
 868:	8082                	ret
 86a:	6398                	ld	a4,0(a5)
 86c:	e118                	sd	a4,0(a0)
 86e:	bff1                	j	84a <malloc+0x86>
 870:	01652423          	sw	s6,8(a0)
 874:	0541                	addi	a0,a0,16
 876:	00000097          	auipc	ra,0x0
 87a:	ec6080e7          	jalr	-314(ra) # 73c <free>
 87e:	00093503          	ld	a0,0(s2)
 882:	d971                	beqz	a0,856 <malloc+0x92>
 884:	611c                	ld	a5,0(a0)
 886:	4798                	lw	a4,8(a5)
 888:	fa9776e3          	bgeu	a4,s1,834 <malloc+0x70>
 88c:	00093703          	ld	a4,0(s2)
 890:	853e                	mv	a0,a5
 892:	fef719e3          	bne	a4,a5,884 <malloc+0xc0>
 896:	8552                	mv	a0,s4
 898:	00000097          	auipc	ra,0x0
 89c:	b7c080e7          	jalr	-1156(ra) # 414 <sbrk>
 8a0:	fd5518e3          	bne	a0,s5,870 <malloc+0xac>
 8a4:	4501                	li	a0,0
 8a6:	bf45                	j	856 <malloc+0x92>

00000000000008a8 <mem_init>:
 8a8:	1141                	addi	sp,sp,-16
 8aa:	e406                	sd	ra,8(sp)
 8ac:	e022                	sd	s0,0(sp)
 8ae:	0800                	addi	s0,sp,16
 8b0:	6505                	lui	a0,0x1
 8b2:	00000097          	auipc	ra,0x0
 8b6:	b62080e7          	jalr	-1182(ra) # 414 <sbrk>
 8ba:	00000797          	auipc	a5,0x0
 8be:	14a7b323          	sd	a0,326(a5) # a00 <alloc>
 8c2:	00850793          	addi	a5,a0,8 # 1008 <__BSS_END__+0x3e8>
 8c6:	e11c                	sd	a5,0(a0)
 8c8:	60a2                	ld	ra,8(sp)
 8ca:	6402                	ld	s0,0(sp)
 8cc:	0141                	addi	sp,sp,16
 8ce:	8082                	ret

00000000000008d0 <l_alloc>:
 8d0:	1101                	addi	sp,sp,-32
 8d2:	ec06                	sd	ra,24(sp)
 8d4:	e822                	sd	s0,16(sp)
 8d6:	e426                	sd	s1,8(sp)
 8d8:	1000                	addi	s0,sp,32
 8da:	84aa                	mv	s1,a0
 8dc:	00000797          	auipc	a5,0x0
 8e0:	11c7a783          	lw	a5,284(a5) # 9f8 <if_init>
 8e4:	c795                	beqz	a5,910 <l_alloc+0x40>
 8e6:	00000717          	auipc	a4,0x0
 8ea:	11a73703          	ld	a4,282(a4) # a00 <alloc>
 8ee:	6308                	ld	a0,0(a4)
 8f0:	40e506b3          	sub	a3,a0,a4
 8f4:	6785                	lui	a5,0x1
 8f6:	37e1                	addiw	a5,a5,-8
 8f8:	9f95                	subw	a5,a5,a3
 8fa:	02f4f563          	bgeu	s1,a5,924 <l_alloc+0x54>
 8fe:	1482                	slli	s1,s1,0x20
 900:	9081                	srli	s1,s1,0x20
 902:	94aa                	add	s1,s1,a0
 904:	e304                	sd	s1,0(a4)
 906:	60e2                	ld	ra,24(sp)
 908:	6442                	ld	s0,16(sp)
 90a:	64a2                	ld	s1,8(sp)
 90c:	6105                	addi	sp,sp,32
 90e:	8082                	ret
 910:	00000097          	auipc	ra,0x0
 914:	f98080e7          	jalr	-104(ra) # 8a8 <mem_init>
 918:	4785                	li	a5,1
 91a:	00000717          	auipc	a4,0x0
 91e:	0cf72f23          	sw	a5,222(a4) # 9f8 <if_init>
 922:	b7d1                	j	8e6 <l_alloc+0x16>
 924:	4501                	li	a0,0
 926:	b7c5                	j	906 <l_alloc+0x36>

0000000000000928 <l_free>:
 928:	1141                	addi	sp,sp,-16
 92a:	e422                	sd	s0,8(sp)
 92c:	0800                	addi	s0,sp,16
 92e:	6422                	ld	s0,8(sp)
 930:	0141                	addi	sp,sp,16
 932:	8082                	ret
