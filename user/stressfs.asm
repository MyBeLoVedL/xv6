
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
   0:	dd010113          	addi	sp,sp,-560
   4:	22113423          	sd	ra,552(sp)
   8:	22813023          	sd	s0,544(sp)
   c:	20913c23          	sd	s1,536(sp)
  10:	21213823          	sd	s2,528(sp)
  14:	1c00                	addi	s0,sp,560
  16:	00001797          	auipc	a5,0x1
  1a:	94278793          	addi	a5,a5,-1726 # 958 <l_free+0x42>
  1e:	6398                	ld	a4,0(a5)
  20:	fce43823          	sd	a4,-48(s0)
  24:	0087d783          	lhu	a5,8(a5)
  28:	fcf41c23          	sh	a5,-40(s0)
  2c:	00001517          	auipc	a0,0x1
  30:	8fc50513          	addi	a0,a0,-1796 # 928 <l_free+0x12>
  34:	00000097          	auipc	ra,0x0
  38:	6c0080e7          	jalr	1728(ra) # 6f4 <printf>
  3c:	20000613          	li	a2,512
  40:	06100593          	li	a1,97
  44:	dd040513          	addi	a0,s0,-560
  48:	00000097          	auipc	ra,0x0
  4c:	136080e7          	jalr	310(ra) # 17e <memset>
  50:	4481                	li	s1,0
  52:	4911                	li	s2,4
  54:	00000097          	auipc	ra,0x0
  58:	31e080e7          	jalr	798(ra) # 372 <fork>
  5c:	00a04563          	bgtz	a0,66 <main+0x66>
  60:	2485                	addiw	s1,s1,1
  62:	ff2499e3          	bne	s1,s2,54 <main+0x54>
  66:	85a6                	mv	a1,s1
  68:	00001517          	auipc	a0,0x1
  6c:	8d850513          	addi	a0,a0,-1832 # 940 <l_free+0x2a>
  70:	00000097          	auipc	ra,0x0
  74:	684080e7          	jalr	1668(ra) # 6f4 <printf>
  78:	fd844783          	lbu	a5,-40(s0)
  7c:	9cbd                	addw	s1,s1,a5
  7e:	fc940c23          	sb	s1,-40(s0)
  82:	20200593          	li	a1,514
  86:	fd040513          	addi	a0,s0,-48
  8a:	00000097          	auipc	ra,0x0
  8e:	330080e7          	jalr	816(ra) # 3ba <open>
  92:	892a                	mv	s2,a0
  94:	44d1                	li	s1,20
  96:	20000613          	li	a2,512
  9a:	dd040593          	addi	a1,s0,-560
  9e:	854a                	mv	a0,s2
  a0:	00000097          	auipc	ra,0x0
  a4:	2fa080e7          	jalr	762(ra) # 39a <write>
  a8:	34fd                	addiw	s1,s1,-1
  aa:	f4f5                	bnez	s1,96 <main+0x96>
  ac:	854a                	mv	a0,s2
  ae:	00000097          	auipc	ra,0x0
  b2:	2f4080e7          	jalr	756(ra) # 3a2 <close>
  b6:	00001517          	auipc	a0,0x1
  ba:	89a50513          	addi	a0,a0,-1894 # 950 <l_free+0x3a>
  be:	00000097          	auipc	ra,0x0
  c2:	636080e7          	jalr	1590(ra) # 6f4 <printf>
  c6:	4581                	li	a1,0
  c8:	fd040513          	addi	a0,s0,-48
  cc:	00000097          	auipc	ra,0x0
  d0:	2ee080e7          	jalr	750(ra) # 3ba <open>
  d4:	892a                	mv	s2,a0
  d6:	44d1                	li	s1,20
  d8:	20000613          	li	a2,512
  dc:	dd040593          	addi	a1,s0,-560
  e0:	854a                	mv	a0,s2
  e2:	00000097          	auipc	ra,0x0
  e6:	2b0080e7          	jalr	688(ra) # 392 <read>
  ea:	34fd                	addiw	s1,s1,-1
  ec:	f4f5                	bnez	s1,d8 <main+0xd8>
  ee:	854a                	mv	a0,s2
  f0:	00000097          	auipc	ra,0x0
  f4:	2b2080e7          	jalr	690(ra) # 3a2 <close>
  f8:	4501                	li	a0,0
  fa:	00000097          	auipc	ra,0x0
  fe:	288080e7          	jalr	648(ra) # 382 <wait>
 102:	4501                	li	a0,0
 104:	00000097          	auipc	ra,0x0
 108:	276080e7          	jalr	630(ra) # 37a <exit>

000000000000010c <strcpy>:
 10c:	1141                	addi	sp,sp,-16
 10e:	e422                	sd	s0,8(sp)
 110:	0800                	addi	s0,sp,16
 112:	87aa                	mv	a5,a0
 114:	0585                	addi	a1,a1,1
 116:	0785                	addi	a5,a5,1
 118:	fff5c703          	lbu	a4,-1(a1)
 11c:	fee78fa3          	sb	a4,-1(a5)
 120:	fb75                	bnez	a4,114 <strcpy+0x8>
 122:	6422                	ld	s0,8(sp)
 124:	0141                	addi	sp,sp,16
 126:	8082                	ret

0000000000000128 <strcmp>:
 128:	1141                	addi	sp,sp,-16
 12a:	e422                	sd	s0,8(sp)
 12c:	0800                	addi	s0,sp,16
 12e:	00054783          	lbu	a5,0(a0)
 132:	cb91                	beqz	a5,146 <strcmp+0x1e>
 134:	0005c703          	lbu	a4,0(a1)
 138:	00f71763          	bne	a4,a5,146 <strcmp+0x1e>
 13c:	0505                	addi	a0,a0,1
 13e:	0585                	addi	a1,a1,1
 140:	00054783          	lbu	a5,0(a0)
 144:	fbe5                	bnez	a5,134 <strcmp+0xc>
 146:	0005c503          	lbu	a0,0(a1)
 14a:	40a7853b          	subw	a0,a5,a0
 14e:	6422                	ld	s0,8(sp)
 150:	0141                	addi	sp,sp,16
 152:	8082                	ret

0000000000000154 <strlen>:
 154:	1141                	addi	sp,sp,-16
 156:	e422                	sd	s0,8(sp)
 158:	0800                	addi	s0,sp,16
 15a:	00054783          	lbu	a5,0(a0)
 15e:	cf91                	beqz	a5,17a <strlen+0x26>
 160:	0505                	addi	a0,a0,1
 162:	87aa                	mv	a5,a0
 164:	4685                	li	a3,1
 166:	9e89                	subw	a3,a3,a0
 168:	00f6853b          	addw	a0,a3,a5
 16c:	0785                	addi	a5,a5,1
 16e:	fff7c703          	lbu	a4,-1(a5)
 172:	fb7d                	bnez	a4,168 <strlen+0x14>
 174:	6422                	ld	s0,8(sp)
 176:	0141                	addi	sp,sp,16
 178:	8082                	ret
 17a:	4501                	li	a0,0
 17c:	bfe5                	j	174 <strlen+0x20>

000000000000017e <memset>:
 17e:	1141                	addi	sp,sp,-16
 180:	e422                	sd	s0,8(sp)
 182:	0800                	addi	s0,sp,16
 184:	ca19                	beqz	a2,19a <memset+0x1c>
 186:	87aa                	mv	a5,a0
 188:	1602                	slli	a2,a2,0x20
 18a:	9201                	srli	a2,a2,0x20
 18c:	00a60733          	add	a4,a2,a0
 190:	00b78023          	sb	a1,0(a5)
 194:	0785                	addi	a5,a5,1
 196:	fee79de3          	bne	a5,a4,190 <memset+0x12>
 19a:	6422                	ld	s0,8(sp)
 19c:	0141                	addi	sp,sp,16
 19e:	8082                	ret

00000000000001a0 <strchr>:
 1a0:	1141                	addi	sp,sp,-16
 1a2:	e422                	sd	s0,8(sp)
 1a4:	0800                	addi	s0,sp,16
 1a6:	00054783          	lbu	a5,0(a0)
 1aa:	cb99                	beqz	a5,1c0 <strchr+0x20>
 1ac:	00f58763          	beq	a1,a5,1ba <strchr+0x1a>
 1b0:	0505                	addi	a0,a0,1
 1b2:	00054783          	lbu	a5,0(a0)
 1b6:	fbfd                	bnez	a5,1ac <strchr+0xc>
 1b8:	4501                	li	a0,0
 1ba:	6422                	ld	s0,8(sp)
 1bc:	0141                	addi	sp,sp,16
 1be:	8082                	ret
 1c0:	4501                	li	a0,0
 1c2:	bfe5                	j	1ba <strchr+0x1a>

00000000000001c4 <gets>:
 1c4:	711d                	addi	sp,sp,-96
 1c6:	ec86                	sd	ra,88(sp)
 1c8:	e8a2                	sd	s0,80(sp)
 1ca:	e4a6                	sd	s1,72(sp)
 1cc:	e0ca                	sd	s2,64(sp)
 1ce:	fc4e                	sd	s3,56(sp)
 1d0:	f852                	sd	s4,48(sp)
 1d2:	f456                	sd	s5,40(sp)
 1d4:	f05a                	sd	s6,32(sp)
 1d6:	ec5e                	sd	s7,24(sp)
 1d8:	1080                	addi	s0,sp,96
 1da:	8baa                	mv	s7,a0
 1dc:	8a2e                	mv	s4,a1
 1de:	892a                	mv	s2,a0
 1e0:	4481                	li	s1,0
 1e2:	4aa9                	li	s5,10
 1e4:	4b35                	li	s6,13
 1e6:	89a6                	mv	s3,s1
 1e8:	2485                	addiw	s1,s1,1
 1ea:	0344d863          	bge	s1,s4,21a <gets+0x56>
 1ee:	4605                	li	a2,1
 1f0:	faf40593          	addi	a1,s0,-81
 1f4:	4501                	li	a0,0
 1f6:	00000097          	auipc	ra,0x0
 1fa:	19c080e7          	jalr	412(ra) # 392 <read>
 1fe:	00a05e63          	blez	a0,21a <gets+0x56>
 202:	faf44783          	lbu	a5,-81(s0)
 206:	00f90023          	sb	a5,0(s2)
 20a:	01578763          	beq	a5,s5,218 <gets+0x54>
 20e:	0905                	addi	s2,s2,1
 210:	fd679be3          	bne	a5,s6,1e6 <gets+0x22>
 214:	89a6                	mv	s3,s1
 216:	a011                	j	21a <gets+0x56>
 218:	89a6                	mv	s3,s1
 21a:	99de                	add	s3,s3,s7
 21c:	00098023          	sb	zero,0(s3)
 220:	855e                	mv	a0,s7
 222:	60e6                	ld	ra,88(sp)
 224:	6446                	ld	s0,80(sp)
 226:	64a6                	ld	s1,72(sp)
 228:	6906                	ld	s2,64(sp)
 22a:	79e2                	ld	s3,56(sp)
 22c:	7a42                	ld	s4,48(sp)
 22e:	7aa2                	ld	s5,40(sp)
 230:	7b02                	ld	s6,32(sp)
 232:	6be2                	ld	s7,24(sp)
 234:	6125                	addi	sp,sp,96
 236:	8082                	ret

0000000000000238 <stat>:
 238:	1101                	addi	sp,sp,-32
 23a:	ec06                	sd	ra,24(sp)
 23c:	e822                	sd	s0,16(sp)
 23e:	e426                	sd	s1,8(sp)
 240:	e04a                	sd	s2,0(sp)
 242:	1000                	addi	s0,sp,32
 244:	892e                	mv	s2,a1
 246:	4581                	li	a1,0
 248:	00000097          	auipc	ra,0x0
 24c:	172080e7          	jalr	370(ra) # 3ba <open>
 250:	02054563          	bltz	a0,27a <stat+0x42>
 254:	84aa                	mv	s1,a0
 256:	85ca                	mv	a1,s2
 258:	00000097          	auipc	ra,0x0
 25c:	17a080e7          	jalr	378(ra) # 3d2 <fstat>
 260:	892a                	mv	s2,a0
 262:	8526                	mv	a0,s1
 264:	00000097          	auipc	ra,0x0
 268:	13e080e7          	jalr	318(ra) # 3a2 <close>
 26c:	854a                	mv	a0,s2
 26e:	60e2                	ld	ra,24(sp)
 270:	6442                	ld	s0,16(sp)
 272:	64a2                	ld	s1,8(sp)
 274:	6902                	ld	s2,0(sp)
 276:	6105                	addi	sp,sp,32
 278:	8082                	ret
 27a:	597d                	li	s2,-1
 27c:	bfc5                	j	26c <stat+0x34>

000000000000027e <atoi>:
 27e:	1141                	addi	sp,sp,-16
 280:	e422                	sd	s0,8(sp)
 282:	0800                	addi	s0,sp,16
 284:	00054603          	lbu	a2,0(a0)
 288:	fd06079b          	addiw	a5,a2,-48
 28c:	0ff7f793          	zext.b	a5,a5
 290:	4725                	li	a4,9
 292:	02f76963          	bltu	a4,a5,2c4 <atoi+0x46>
 296:	86aa                	mv	a3,a0
 298:	4501                	li	a0,0
 29a:	45a5                	li	a1,9
 29c:	0685                	addi	a3,a3,1
 29e:	0025179b          	slliw	a5,a0,0x2
 2a2:	9fa9                	addw	a5,a5,a0
 2a4:	0017979b          	slliw	a5,a5,0x1
 2a8:	9fb1                	addw	a5,a5,a2
 2aa:	fd07851b          	addiw	a0,a5,-48
 2ae:	0006c603          	lbu	a2,0(a3)
 2b2:	fd06071b          	addiw	a4,a2,-48
 2b6:	0ff77713          	zext.b	a4,a4
 2ba:	fee5f1e3          	bgeu	a1,a4,29c <atoi+0x1e>
 2be:	6422                	ld	s0,8(sp)
 2c0:	0141                	addi	sp,sp,16
 2c2:	8082                	ret
 2c4:	4501                	li	a0,0
 2c6:	bfe5                	j	2be <atoi+0x40>

00000000000002c8 <memmove>:
 2c8:	1141                	addi	sp,sp,-16
 2ca:	e422                	sd	s0,8(sp)
 2cc:	0800                	addi	s0,sp,16
 2ce:	02b57463          	bgeu	a0,a1,2f6 <memmove+0x2e>
 2d2:	00c05f63          	blez	a2,2f0 <memmove+0x28>
 2d6:	1602                	slli	a2,a2,0x20
 2d8:	9201                	srli	a2,a2,0x20
 2da:	00c507b3          	add	a5,a0,a2
 2de:	872a                	mv	a4,a0
 2e0:	0585                	addi	a1,a1,1
 2e2:	0705                	addi	a4,a4,1
 2e4:	fff5c683          	lbu	a3,-1(a1)
 2e8:	fed70fa3          	sb	a3,-1(a4)
 2ec:	fee79ae3          	bne	a5,a4,2e0 <memmove+0x18>
 2f0:	6422                	ld	s0,8(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret
 2f6:	00c50733          	add	a4,a0,a2
 2fa:	95b2                	add	a1,a1,a2
 2fc:	fec05ae3          	blez	a2,2f0 <memmove+0x28>
 300:	fff6079b          	addiw	a5,a2,-1
 304:	1782                	slli	a5,a5,0x20
 306:	9381                	srli	a5,a5,0x20
 308:	fff7c793          	not	a5,a5
 30c:	97ba                	add	a5,a5,a4
 30e:	15fd                	addi	a1,a1,-1
 310:	177d                	addi	a4,a4,-1
 312:	0005c683          	lbu	a3,0(a1)
 316:	00d70023          	sb	a3,0(a4)
 31a:	fee79ae3          	bne	a5,a4,30e <memmove+0x46>
 31e:	bfc9                	j	2f0 <memmove+0x28>

0000000000000320 <memcmp>:
 320:	1141                	addi	sp,sp,-16
 322:	e422                	sd	s0,8(sp)
 324:	0800                	addi	s0,sp,16
 326:	ca05                	beqz	a2,356 <memcmp+0x36>
 328:	fff6069b          	addiw	a3,a2,-1
 32c:	1682                	slli	a3,a3,0x20
 32e:	9281                	srli	a3,a3,0x20
 330:	0685                	addi	a3,a3,1
 332:	96aa                	add	a3,a3,a0
 334:	00054783          	lbu	a5,0(a0)
 338:	0005c703          	lbu	a4,0(a1)
 33c:	00e79863          	bne	a5,a4,34c <memcmp+0x2c>
 340:	0505                	addi	a0,a0,1
 342:	0585                	addi	a1,a1,1
 344:	fed518e3          	bne	a0,a3,334 <memcmp+0x14>
 348:	4501                	li	a0,0
 34a:	a019                	j	350 <memcmp+0x30>
 34c:	40e7853b          	subw	a0,a5,a4
 350:	6422                	ld	s0,8(sp)
 352:	0141                	addi	sp,sp,16
 354:	8082                	ret
 356:	4501                	li	a0,0
 358:	bfe5                	j	350 <memcmp+0x30>

000000000000035a <memcpy>:
 35a:	1141                	addi	sp,sp,-16
 35c:	e406                	sd	ra,8(sp)
 35e:	e022                	sd	s0,0(sp)
 360:	0800                	addi	s0,sp,16
 362:	00000097          	auipc	ra,0x0
 366:	f66080e7          	jalr	-154(ra) # 2c8 <memmove>
 36a:	60a2                	ld	ra,8(sp)
 36c:	6402                	ld	s0,0(sp)
 36e:	0141                	addi	sp,sp,16
 370:	8082                	ret

0000000000000372 <fork>:
 372:	4885                	li	a7,1
 374:	00000073          	ecall
 378:	8082                	ret

000000000000037a <exit>:
 37a:	4889                	li	a7,2
 37c:	00000073          	ecall
 380:	8082                	ret

0000000000000382 <wait>:
 382:	488d                	li	a7,3
 384:	00000073          	ecall
 388:	8082                	ret

000000000000038a <pipe>:
 38a:	4891                	li	a7,4
 38c:	00000073          	ecall
 390:	8082                	ret

0000000000000392 <read>:
 392:	4895                	li	a7,5
 394:	00000073          	ecall
 398:	8082                	ret

000000000000039a <write>:
 39a:	48c1                	li	a7,16
 39c:	00000073          	ecall
 3a0:	8082                	ret

00000000000003a2 <close>:
 3a2:	48d5                	li	a7,21
 3a4:	00000073          	ecall
 3a8:	8082                	ret

00000000000003aa <kill>:
 3aa:	4899                	li	a7,6
 3ac:	00000073          	ecall
 3b0:	8082                	ret

00000000000003b2 <exec>:
 3b2:	489d                	li	a7,7
 3b4:	00000073          	ecall
 3b8:	8082                	ret

00000000000003ba <open>:
 3ba:	48bd                	li	a7,15
 3bc:	00000073          	ecall
 3c0:	8082                	ret

00000000000003c2 <mknod>:
 3c2:	48c5                	li	a7,17
 3c4:	00000073          	ecall
 3c8:	8082                	ret

00000000000003ca <unlink>:
 3ca:	48c9                	li	a7,18
 3cc:	00000073          	ecall
 3d0:	8082                	ret

00000000000003d2 <fstat>:
 3d2:	48a1                	li	a7,8
 3d4:	00000073          	ecall
 3d8:	8082                	ret

00000000000003da <link>:
 3da:	48cd                	li	a7,19
 3dc:	00000073          	ecall
 3e0:	8082                	ret

00000000000003e2 <mkdir>:
 3e2:	48d1                	li	a7,20
 3e4:	00000073          	ecall
 3e8:	8082                	ret

00000000000003ea <chdir>:
 3ea:	48a5                	li	a7,9
 3ec:	00000073          	ecall
 3f0:	8082                	ret

00000000000003f2 <dup>:
 3f2:	48a9                	li	a7,10
 3f4:	00000073          	ecall
 3f8:	8082                	ret

00000000000003fa <getpid>:
 3fa:	48ad                	li	a7,11
 3fc:	00000073          	ecall
 400:	8082                	ret

0000000000000402 <sbrk>:
 402:	48b1                	li	a7,12
 404:	00000073          	ecall
 408:	8082                	ret

000000000000040a <sleep>:
 40a:	48b5                	li	a7,13
 40c:	00000073          	ecall
 410:	8082                	ret

0000000000000412 <uptime>:
 412:	48b9                	li	a7,14
 414:	00000073          	ecall
 418:	8082                	ret

000000000000041a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 41a:	1101                	addi	sp,sp,-32
 41c:	ec06                	sd	ra,24(sp)
 41e:	e822                	sd	s0,16(sp)
 420:	1000                	addi	s0,sp,32
 422:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 426:	4605                	li	a2,1
 428:	fef40593          	addi	a1,s0,-17
 42c:	00000097          	auipc	ra,0x0
 430:	f6e080e7          	jalr	-146(ra) # 39a <write>
}
 434:	60e2                	ld	ra,24(sp)
 436:	6442                	ld	s0,16(sp)
 438:	6105                	addi	sp,sp,32
 43a:	8082                	ret

000000000000043c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 43c:	7139                	addi	sp,sp,-64
 43e:	fc06                	sd	ra,56(sp)
 440:	f822                	sd	s0,48(sp)
 442:	f426                	sd	s1,40(sp)
 444:	f04a                	sd	s2,32(sp)
 446:	ec4e                	sd	s3,24(sp)
 448:	0080                	addi	s0,sp,64
 44a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 44c:	c299                	beqz	a3,452 <printint+0x16>
 44e:	0805c963          	bltz	a1,4e0 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 452:	2581                	sext.w	a1,a1
  neg = 0;
 454:	4881                	li	a7,0
 456:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 45a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 45c:	2601                	sext.w	a2,a2
 45e:	00000517          	auipc	a0,0x0
 462:	56a50513          	addi	a0,a0,1386 # 9c8 <digits>
 466:	883a                	mv	a6,a4
 468:	2705                	addiw	a4,a4,1
 46a:	02c5f7bb          	remuw	a5,a1,a2
 46e:	1782                	slli	a5,a5,0x20
 470:	9381                	srli	a5,a5,0x20
 472:	97aa                	add	a5,a5,a0
 474:	0007c783          	lbu	a5,0(a5)
 478:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 47c:	0005879b          	sext.w	a5,a1
 480:	02c5d5bb          	divuw	a1,a1,a2
 484:	0685                	addi	a3,a3,1
 486:	fec7f0e3          	bgeu	a5,a2,466 <printint+0x2a>
  if(neg)
 48a:	00088c63          	beqz	a7,4a2 <printint+0x66>
    buf[i++] = '-';
 48e:	fd070793          	addi	a5,a4,-48
 492:	00878733          	add	a4,a5,s0
 496:	02d00793          	li	a5,45
 49a:	fef70823          	sb	a5,-16(a4)
 49e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4a2:	02e05863          	blez	a4,4d2 <printint+0x96>
 4a6:	fc040793          	addi	a5,s0,-64
 4aa:	00e78933          	add	s2,a5,a4
 4ae:	fff78993          	addi	s3,a5,-1
 4b2:	99ba                	add	s3,s3,a4
 4b4:	377d                	addiw	a4,a4,-1
 4b6:	1702                	slli	a4,a4,0x20
 4b8:	9301                	srli	a4,a4,0x20
 4ba:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4be:	fff94583          	lbu	a1,-1(s2)
 4c2:	8526                	mv	a0,s1
 4c4:	00000097          	auipc	ra,0x0
 4c8:	f56080e7          	jalr	-170(ra) # 41a <putc>
  while(--i >= 0)
 4cc:	197d                	addi	s2,s2,-1
 4ce:	ff3918e3          	bne	s2,s3,4be <printint+0x82>
}
 4d2:	70e2                	ld	ra,56(sp)
 4d4:	7442                	ld	s0,48(sp)
 4d6:	74a2                	ld	s1,40(sp)
 4d8:	7902                	ld	s2,32(sp)
 4da:	69e2                	ld	s3,24(sp)
 4dc:	6121                	addi	sp,sp,64
 4de:	8082                	ret
    x = -xx;
 4e0:	40b005bb          	negw	a1,a1
    neg = 1;
 4e4:	4885                	li	a7,1
    x = -xx;
 4e6:	bf85                	j	456 <printint+0x1a>

00000000000004e8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4e8:	7119                	addi	sp,sp,-128
 4ea:	fc86                	sd	ra,120(sp)
 4ec:	f8a2                	sd	s0,112(sp)
 4ee:	f4a6                	sd	s1,104(sp)
 4f0:	f0ca                	sd	s2,96(sp)
 4f2:	ecce                	sd	s3,88(sp)
 4f4:	e8d2                	sd	s4,80(sp)
 4f6:	e4d6                	sd	s5,72(sp)
 4f8:	e0da                	sd	s6,64(sp)
 4fa:	fc5e                	sd	s7,56(sp)
 4fc:	f862                	sd	s8,48(sp)
 4fe:	f466                	sd	s9,40(sp)
 500:	f06a                	sd	s10,32(sp)
 502:	ec6e                	sd	s11,24(sp)
 504:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 506:	0005c903          	lbu	s2,0(a1)
 50a:	18090f63          	beqz	s2,6a8 <vprintf+0x1c0>
 50e:	8aaa                	mv	s5,a0
 510:	8b32                	mv	s6,a2
 512:	00158493          	addi	s1,a1,1
  state = 0;
 516:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 518:	02500a13          	li	s4,37
 51c:	4c55                	li	s8,21
 51e:	00000c97          	auipc	s9,0x0
 522:	452c8c93          	addi	s9,s9,1106 # 970 <l_free+0x5a>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 526:	02800d93          	li	s11,40
  putc(fd, 'x');
 52a:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 52c:	00000b97          	auipc	s7,0x0
 530:	49cb8b93          	addi	s7,s7,1180 # 9c8 <digits>
 534:	a839                	j	552 <vprintf+0x6a>
        putc(fd, c);
 536:	85ca                	mv	a1,s2
 538:	8556                	mv	a0,s5
 53a:	00000097          	auipc	ra,0x0
 53e:	ee0080e7          	jalr	-288(ra) # 41a <putc>
 542:	a019                	j	548 <vprintf+0x60>
    } else if(state == '%'){
 544:	01498d63          	beq	s3,s4,55e <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 548:	0485                	addi	s1,s1,1
 54a:	fff4c903          	lbu	s2,-1(s1)
 54e:	14090d63          	beqz	s2,6a8 <vprintf+0x1c0>
    if(state == 0){
 552:	fe0999e3          	bnez	s3,544 <vprintf+0x5c>
      if(c == '%'){
 556:	ff4910e3          	bne	s2,s4,536 <vprintf+0x4e>
        state = '%';
 55a:	89d2                	mv	s3,s4
 55c:	b7f5                	j	548 <vprintf+0x60>
      if(c == 'd'){
 55e:	11490c63          	beq	s2,s4,676 <vprintf+0x18e>
 562:	f9d9079b          	addiw	a5,s2,-99
 566:	0ff7f793          	zext.b	a5,a5
 56a:	10fc6e63          	bltu	s8,a5,686 <vprintf+0x19e>
 56e:	f9d9079b          	addiw	a5,s2,-99
 572:	0ff7f713          	zext.b	a4,a5
 576:	10ec6863          	bltu	s8,a4,686 <vprintf+0x19e>
 57a:	00271793          	slli	a5,a4,0x2
 57e:	97e6                	add	a5,a5,s9
 580:	439c                	lw	a5,0(a5)
 582:	97e6                	add	a5,a5,s9
 584:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 586:	008b0913          	addi	s2,s6,8
 58a:	4685                	li	a3,1
 58c:	4629                	li	a2,10
 58e:	000b2583          	lw	a1,0(s6)
 592:	8556                	mv	a0,s5
 594:	00000097          	auipc	ra,0x0
 598:	ea8080e7          	jalr	-344(ra) # 43c <printint>
 59c:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 59e:	4981                	li	s3,0
 5a0:	b765                	j	548 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a2:	008b0913          	addi	s2,s6,8
 5a6:	4681                	li	a3,0
 5a8:	4629                	li	a2,10
 5aa:	000b2583          	lw	a1,0(s6)
 5ae:	8556                	mv	a0,s5
 5b0:	00000097          	auipc	ra,0x0
 5b4:	e8c080e7          	jalr	-372(ra) # 43c <printint>
 5b8:	8b4a                	mv	s6,s2
      state = 0;
 5ba:	4981                	li	s3,0
 5bc:	b771                	j	548 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5be:	008b0913          	addi	s2,s6,8
 5c2:	4681                	li	a3,0
 5c4:	866a                	mv	a2,s10
 5c6:	000b2583          	lw	a1,0(s6)
 5ca:	8556                	mv	a0,s5
 5cc:	00000097          	auipc	ra,0x0
 5d0:	e70080e7          	jalr	-400(ra) # 43c <printint>
 5d4:	8b4a                	mv	s6,s2
      state = 0;
 5d6:	4981                	li	s3,0
 5d8:	bf85                	j	548 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5da:	008b0793          	addi	a5,s6,8
 5de:	f8f43423          	sd	a5,-120(s0)
 5e2:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5e6:	03000593          	li	a1,48
 5ea:	8556                	mv	a0,s5
 5ec:	00000097          	auipc	ra,0x0
 5f0:	e2e080e7          	jalr	-466(ra) # 41a <putc>
  putc(fd, 'x');
 5f4:	07800593          	li	a1,120
 5f8:	8556                	mv	a0,s5
 5fa:	00000097          	auipc	ra,0x0
 5fe:	e20080e7          	jalr	-480(ra) # 41a <putc>
 602:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 604:	03c9d793          	srli	a5,s3,0x3c
 608:	97de                	add	a5,a5,s7
 60a:	0007c583          	lbu	a1,0(a5)
 60e:	8556                	mv	a0,s5
 610:	00000097          	auipc	ra,0x0
 614:	e0a080e7          	jalr	-502(ra) # 41a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 618:	0992                	slli	s3,s3,0x4
 61a:	397d                	addiw	s2,s2,-1
 61c:	fe0914e3          	bnez	s2,604 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 620:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 624:	4981                	li	s3,0
 626:	b70d                	j	548 <vprintf+0x60>
        s = va_arg(ap, char*);
 628:	008b0913          	addi	s2,s6,8
 62c:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 630:	02098163          	beqz	s3,652 <vprintf+0x16a>
        while(*s != 0){
 634:	0009c583          	lbu	a1,0(s3)
 638:	c5ad                	beqz	a1,6a2 <vprintf+0x1ba>
          putc(fd, *s);
 63a:	8556                	mv	a0,s5
 63c:	00000097          	auipc	ra,0x0
 640:	dde080e7          	jalr	-546(ra) # 41a <putc>
          s++;
 644:	0985                	addi	s3,s3,1
        while(*s != 0){
 646:	0009c583          	lbu	a1,0(s3)
 64a:	f9e5                	bnez	a1,63a <vprintf+0x152>
        s = va_arg(ap, char*);
 64c:	8b4a                	mv	s6,s2
      state = 0;
 64e:	4981                	li	s3,0
 650:	bde5                	j	548 <vprintf+0x60>
          s = "(null)";
 652:	00000997          	auipc	s3,0x0
 656:	31698993          	addi	s3,s3,790 # 968 <l_free+0x52>
        while(*s != 0){
 65a:	85ee                	mv	a1,s11
 65c:	bff9                	j	63a <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 65e:	008b0913          	addi	s2,s6,8
 662:	000b4583          	lbu	a1,0(s6)
 666:	8556                	mv	a0,s5
 668:	00000097          	auipc	ra,0x0
 66c:	db2080e7          	jalr	-590(ra) # 41a <putc>
 670:	8b4a                	mv	s6,s2
      state = 0;
 672:	4981                	li	s3,0
 674:	bdd1                	j	548 <vprintf+0x60>
        putc(fd, c);
 676:	85d2                	mv	a1,s4
 678:	8556                	mv	a0,s5
 67a:	00000097          	auipc	ra,0x0
 67e:	da0080e7          	jalr	-608(ra) # 41a <putc>
      state = 0;
 682:	4981                	li	s3,0
 684:	b5d1                	j	548 <vprintf+0x60>
        putc(fd, '%');
 686:	85d2                	mv	a1,s4
 688:	8556                	mv	a0,s5
 68a:	00000097          	auipc	ra,0x0
 68e:	d90080e7          	jalr	-624(ra) # 41a <putc>
        putc(fd, c);
 692:	85ca                	mv	a1,s2
 694:	8556                	mv	a0,s5
 696:	00000097          	auipc	ra,0x0
 69a:	d84080e7          	jalr	-636(ra) # 41a <putc>
      state = 0;
 69e:	4981                	li	s3,0
 6a0:	b565                	j	548 <vprintf+0x60>
        s = va_arg(ap, char*);
 6a2:	8b4a                	mv	s6,s2
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	b54d                	j	548 <vprintf+0x60>
    }
  }
}
 6a8:	70e6                	ld	ra,120(sp)
 6aa:	7446                	ld	s0,112(sp)
 6ac:	74a6                	ld	s1,104(sp)
 6ae:	7906                	ld	s2,96(sp)
 6b0:	69e6                	ld	s3,88(sp)
 6b2:	6a46                	ld	s4,80(sp)
 6b4:	6aa6                	ld	s5,72(sp)
 6b6:	6b06                	ld	s6,64(sp)
 6b8:	7be2                	ld	s7,56(sp)
 6ba:	7c42                	ld	s8,48(sp)
 6bc:	7ca2                	ld	s9,40(sp)
 6be:	7d02                	ld	s10,32(sp)
 6c0:	6de2                	ld	s11,24(sp)
 6c2:	6109                	addi	sp,sp,128
 6c4:	8082                	ret

00000000000006c6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6c6:	715d                	addi	sp,sp,-80
 6c8:	ec06                	sd	ra,24(sp)
 6ca:	e822                	sd	s0,16(sp)
 6cc:	1000                	addi	s0,sp,32
 6ce:	e010                	sd	a2,0(s0)
 6d0:	e414                	sd	a3,8(s0)
 6d2:	e818                	sd	a4,16(s0)
 6d4:	ec1c                	sd	a5,24(s0)
 6d6:	03043023          	sd	a6,32(s0)
 6da:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6de:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6e2:	8622                	mv	a2,s0
 6e4:	00000097          	auipc	ra,0x0
 6e8:	e04080e7          	jalr	-508(ra) # 4e8 <vprintf>
}
 6ec:	60e2                	ld	ra,24(sp)
 6ee:	6442                	ld	s0,16(sp)
 6f0:	6161                	addi	sp,sp,80
 6f2:	8082                	ret

00000000000006f4 <printf>:

void
printf(const char *fmt, ...)
{
 6f4:	711d                	addi	sp,sp,-96
 6f6:	ec06                	sd	ra,24(sp)
 6f8:	e822                	sd	s0,16(sp)
 6fa:	1000                	addi	s0,sp,32
 6fc:	e40c                	sd	a1,8(s0)
 6fe:	e810                	sd	a2,16(s0)
 700:	ec14                	sd	a3,24(s0)
 702:	f018                	sd	a4,32(s0)
 704:	f41c                	sd	a5,40(s0)
 706:	03043823          	sd	a6,48(s0)
 70a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 70e:	00840613          	addi	a2,s0,8
 712:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 716:	85aa                	mv	a1,a0
 718:	4505                	li	a0,1
 71a:	00000097          	auipc	ra,0x0
 71e:	dce080e7          	jalr	-562(ra) # 4e8 <vprintf>
}
 722:	60e2                	ld	ra,24(sp)
 724:	6442                	ld	s0,16(sp)
 726:	6125                	addi	sp,sp,96
 728:	8082                	ret

000000000000072a <free>:
 72a:	1141                	addi	sp,sp,-16
 72c:	e422                	sd	s0,8(sp)
 72e:	0800                	addi	s0,sp,16
 730:	ff050693          	addi	a3,a0,-16
 734:	00000797          	auipc	a5,0x0
 738:	2bc7b783          	ld	a5,700(a5) # 9f0 <freep>
 73c:	a805                	j	76c <free+0x42>
 73e:	4618                	lw	a4,8(a2)
 740:	9db9                	addw	a1,a1,a4
 742:	feb52c23          	sw	a1,-8(a0)
 746:	6398                	ld	a4,0(a5)
 748:	6318                	ld	a4,0(a4)
 74a:	fee53823          	sd	a4,-16(a0)
 74e:	a091                	j	792 <free+0x68>
 750:	ff852703          	lw	a4,-8(a0)
 754:	9e39                	addw	a2,a2,a4
 756:	c790                	sw	a2,8(a5)
 758:	ff053703          	ld	a4,-16(a0)
 75c:	e398                	sd	a4,0(a5)
 75e:	a099                	j	7a4 <free+0x7a>
 760:	6398                	ld	a4,0(a5)
 762:	00e7e463          	bltu	a5,a4,76a <free+0x40>
 766:	00e6ea63          	bltu	a3,a4,77a <free+0x50>
 76a:	87ba                	mv	a5,a4
 76c:	fed7fae3          	bgeu	a5,a3,760 <free+0x36>
 770:	6398                	ld	a4,0(a5)
 772:	00e6e463          	bltu	a3,a4,77a <free+0x50>
 776:	fee7eae3          	bltu	a5,a4,76a <free+0x40>
 77a:	ff852583          	lw	a1,-8(a0)
 77e:	6390                	ld	a2,0(a5)
 780:	02059713          	slli	a4,a1,0x20
 784:	9301                	srli	a4,a4,0x20
 786:	0712                	slli	a4,a4,0x4
 788:	9736                	add	a4,a4,a3
 78a:	fae60ae3          	beq	a2,a4,73e <free+0x14>
 78e:	fec53823          	sd	a2,-16(a0)
 792:	4790                	lw	a2,8(a5)
 794:	02061713          	slli	a4,a2,0x20
 798:	9301                	srli	a4,a4,0x20
 79a:	0712                	slli	a4,a4,0x4
 79c:	973e                	add	a4,a4,a5
 79e:	fae689e3          	beq	a3,a4,750 <free+0x26>
 7a2:	e394                	sd	a3,0(a5)
 7a4:	00000717          	auipc	a4,0x0
 7a8:	24f73623          	sd	a5,588(a4) # 9f0 <freep>
 7ac:	6422                	ld	s0,8(sp)
 7ae:	0141                	addi	sp,sp,16
 7b0:	8082                	ret

00000000000007b2 <malloc>:
 7b2:	7139                	addi	sp,sp,-64
 7b4:	fc06                	sd	ra,56(sp)
 7b6:	f822                	sd	s0,48(sp)
 7b8:	f426                	sd	s1,40(sp)
 7ba:	f04a                	sd	s2,32(sp)
 7bc:	ec4e                	sd	s3,24(sp)
 7be:	e852                	sd	s4,16(sp)
 7c0:	e456                	sd	s5,8(sp)
 7c2:	e05a                	sd	s6,0(sp)
 7c4:	0080                	addi	s0,sp,64
 7c6:	02051493          	slli	s1,a0,0x20
 7ca:	9081                	srli	s1,s1,0x20
 7cc:	04bd                	addi	s1,s1,15
 7ce:	8091                	srli	s1,s1,0x4
 7d0:	0014899b          	addiw	s3,s1,1
 7d4:	0485                	addi	s1,s1,1
 7d6:	00000517          	auipc	a0,0x0
 7da:	21a53503          	ld	a0,538(a0) # 9f0 <freep>
 7de:	c515                	beqz	a0,80a <malloc+0x58>
 7e0:	611c                	ld	a5,0(a0)
 7e2:	4798                	lw	a4,8(a5)
 7e4:	02977f63          	bgeu	a4,s1,822 <malloc+0x70>
 7e8:	8a4e                	mv	s4,s3
 7ea:	0009871b          	sext.w	a4,s3
 7ee:	6685                	lui	a3,0x1
 7f0:	00d77363          	bgeu	a4,a3,7f6 <malloc+0x44>
 7f4:	6a05                	lui	s4,0x1
 7f6:	000a0b1b          	sext.w	s6,s4
 7fa:	004a1a1b          	slliw	s4,s4,0x4
 7fe:	00000917          	auipc	s2,0x0
 802:	1f290913          	addi	s2,s2,498 # 9f0 <freep>
 806:	5afd                	li	s5,-1
 808:	a88d                	j	87a <malloc+0xc8>
 80a:	00000797          	auipc	a5,0x0
 80e:	1ee78793          	addi	a5,a5,494 # 9f8 <base>
 812:	00000717          	auipc	a4,0x0
 816:	1cf73f23          	sd	a5,478(a4) # 9f0 <freep>
 81a:	e39c                	sd	a5,0(a5)
 81c:	0007a423          	sw	zero,8(a5)
 820:	b7e1                	j	7e8 <malloc+0x36>
 822:	02e48b63          	beq	s1,a4,858 <malloc+0xa6>
 826:	4137073b          	subw	a4,a4,s3
 82a:	c798                	sw	a4,8(a5)
 82c:	1702                	slli	a4,a4,0x20
 82e:	9301                	srli	a4,a4,0x20
 830:	0712                	slli	a4,a4,0x4
 832:	97ba                	add	a5,a5,a4
 834:	0137a423          	sw	s3,8(a5)
 838:	00000717          	auipc	a4,0x0
 83c:	1aa73c23          	sd	a0,440(a4) # 9f0 <freep>
 840:	01078513          	addi	a0,a5,16
 844:	70e2                	ld	ra,56(sp)
 846:	7442                	ld	s0,48(sp)
 848:	74a2                	ld	s1,40(sp)
 84a:	7902                	ld	s2,32(sp)
 84c:	69e2                	ld	s3,24(sp)
 84e:	6a42                	ld	s4,16(sp)
 850:	6aa2                	ld	s5,8(sp)
 852:	6b02                	ld	s6,0(sp)
 854:	6121                	addi	sp,sp,64
 856:	8082                	ret
 858:	6398                	ld	a4,0(a5)
 85a:	e118                	sd	a4,0(a0)
 85c:	bff1                	j	838 <malloc+0x86>
 85e:	01652423          	sw	s6,8(a0)
 862:	0541                	addi	a0,a0,16
 864:	00000097          	auipc	ra,0x0
 868:	ec6080e7          	jalr	-314(ra) # 72a <free>
 86c:	00093503          	ld	a0,0(s2)
 870:	d971                	beqz	a0,844 <malloc+0x92>
 872:	611c                	ld	a5,0(a0)
 874:	4798                	lw	a4,8(a5)
 876:	fa9776e3          	bgeu	a4,s1,822 <malloc+0x70>
 87a:	00093703          	ld	a4,0(s2)
 87e:	853e                	mv	a0,a5
 880:	fef719e3          	bne	a4,a5,872 <malloc+0xc0>
 884:	8552                	mv	a0,s4
 886:	00000097          	auipc	ra,0x0
 88a:	b7c080e7          	jalr	-1156(ra) # 402 <sbrk>
 88e:	fd5518e3          	bne	a0,s5,85e <malloc+0xac>
 892:	4501                	li	a0,0
 894:	bf45                	j	844 <malloc+0x92>

0000000000000896 <mem_init>:
 896:	1141                	addi	sp,sp,-16
 898:	e406                	sd	ra,8(sp)
 89a:	e022                	sd	s0,0(sp)
 89c:	0800                	addi	s0,sp,16
 89e:	6505                	lui	a0,0x1
 8a0:	00000097          	auipc	ra,0x0
 8a4:	b62080e7          	jalr	-1182(ra) # 402 <sbrk>
 8a8:	00000797          	auipc	a5,0x0
 8ac:	14a7b023          	sd	a0,320(a5) # 9e8 <alloc>
 8b0:	00850793          	addi	a5,a0,8 # 1008 <__BSS_END__+0x600>
 8b4:	e11c                	sd	a5,0(a0)
 8b6:	60a2                	ld	ra,8(sp)
 8b8:	6402                	ld	s0,0(sp)
 8ba:	0141                	addi	sp,sp,16
 8bc:	8082                	ret

00000000000008be <l_alloc>:
 8be:	1101                	addi	sp,sp,-32
 8c0:	ec06                	sd	ra,24(sp)
 8c2:	e822                	sd	s0,16(sp)
 8c4:	e426                	sd	s1,8(sp)
 8c6:	1000                	addi	s0,sp,32
 8c8:	84aa                	mv	s1,a0
 8ca:	00000797          	auipc	a5,0x0
 8ce:	1167a783          	lw	a5,278(a5) # 9e0 <if_init>
 8d2:	c795                	beqz	a5,8fe <l_alloc+0x40>
 8d4:	00000717          	auipc	a4,0x0
 8d8:	11473703          	ld	a4,276(a4) # 9e8 <alloc>
 8dc:	6308                	ld	a0,0(a4)
 8de:	40e506b3          	sub	a3,a0,a4
 8e2:	6785                	lui	a5,0x1
 8e4:	37e1                	addiw	a5,a5,-8
 8e6:	9f95                	subw	a5,a5,a3
 8e8:	02f4f563          	bgeu	s1,a5,912 <l_alloc+0x54>
 8ec:	1482                	slli	s1,s1,0x20
 8ee:	9081                	srli	s1,s1,0x20
 8f0:	94aa                	add	s1,s1,a0
 8f2:	e304                	sd	s1,0(a4)
 8f4:	60e2                	ld	ra,24(sp)
 8f6:	6442                	ld	s0,16(sp)
 8f8:	64a2                	ld	s1,8(sp)
 8fa:	6105                	addi	sp,sp,32
 8fc:	8082                	ret
 8fe:	00000097          	auipc	ra,0x0
 902:	f98080e7          	jalr	-104(ra) # 896 <mem_init>
 906:	4785                	li	a5,1
 908:	00000717          	auipc	a4,0x0
 90c:	0cf72c23          	sw	a5,216(a4) # 9e0 <if_init>
 910:	b7d1                	j	8d4 <l_alloc+0x16>
 912:	4501                	li	a0,0
 914:	b7c5                	j	8f4 <l_alloc+0x36>

0000000000000916 <l_free>:
 916:	1141                	addi	sp,sp,-16
 918:	e422                	sd	s0,8(sp)
 91a:	0800                	addi	s0,sp,16
 91c:	6422                	ld	s0,8(sp)
 91e:	0141                	addi	sp,sp,16
 920:	8082                	ret
