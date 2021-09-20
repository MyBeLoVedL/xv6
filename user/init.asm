
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	90250513          	addi	a0,a0,-1790 # 910 <l_free+0xe>
  16:	00000097          	auipc	ra,0x0
  1a:	390080e7          	jalr	912(ra) # 3a6 <open>
  1e:	06054363          	bltz	a0,84 <main+0x84>
  22:	4501                	li	a0,0
  24:	00000097          	auipc	ra,0x0
  28:	3ba080e7          	jalr	954(ra) # 3de <dup>
  2c:	4501                	li	a0,0
  2e:	00000097          	auipc	ra,0x0
  32:	3b0080e7          	jalr	944(ra) # 3de <dup>
  36:	00001917          	auipc	s2,0x1
  3a:	8e290913          	addi	s2,s2,-1822 # 918 <l_free+0x16>
  3e:	854a                	mv	a0,s2
  40:	00000097          	auipc	ra,0x0
  44:	6a0080e7          	jalr	1696(ra) # 6e0 <printf>
  48:	00000097          	auipc	ra,0x0
  4c:	316080e7          	jalr	790(ra) # 35e <fork>
  50:	84aa                	mv	s1,a0
  52:	04054d63          	bltz	a0,ac <main+0xac>
  56:	c925                	beqz	a0,c6 <main+0xc6>
  58:	4501                	li	a0,0
  5a:	00000097          	auipc	ra,0x0
  5e:	314080e7          	jalr	788(ra) # 36e <wait>
  62:	fca48ee3          	beq	s1,a0,3e <main+0x3e>
  66:	fe0559e3          	bgez	a0,58 <main+0x58>
  6a:	00001517          	auipc	a0,0x1
  6e:	8fe50513          	addi	a0,a0,-1794 # 968 <l_free+0x66>
  72:	00000097          	auipc	ra,0x0
  76:	66e080e7          	jalr	1646(ra) # 6e0 <printf>
  7a:	4505                	li	a0,1
  7c:	00000097          	auipc	ra,0x0
  80:	2ea080e7          	jalr	746(ra) # 366 <exit>
  84:	4601                	li	a2,0
  86:	4585                	li	a1,1
  88:	00001517          	auipc	a0,0x1
  8c:	88850513          	addi	a0,a0,-1912 # 910 <l_free+0xe>
  90:	00000097          	auipc	ra,0x0
  94:	31e080e7          	jalr	798(ra) # 3ae <mknod>
  98:	4589                	li	a1,2
  9a:	00001517          	auipc	a0,0x1
  9e:	87650513          	addi	a0,a0,-1930 # 910 <l_free+0xe>
  a2:	00000097          	auipc	ra,0x0
  a6:	304080e7          	jalr	772(ra) # 3a6 <open>
  aa:	bfa5                	j	22 <main+0x22>
  ac:	00001517          	auipc	a0,0x1
  b0:	88450513          	addi	a0,a0,-1916 # 930 <l_free+0x2e>
  b4:	00000097          	auipc	ra,0x0
  b8:	62c080e7          	jalr	1580(ra) # 6e0 <printf>
  bc:	4505                	li	a0,1
  be:	00000097          	auipc	ra,0x0
  c2:	2a8080e7          	jalr	680(ra) # 366 <exit>
  c6:	00001597          	auipc	a1,0x1
  ca:	93a58593          	addi	a1,a1,-1734 # a00 <argv>
  ce:	00001517          	auipc	a0,0x1
  d2:	87a50513          	addi	a0,a0,-1926 # 948 <l_free+0x46>
  d6:	00000097          	auipc	ra,0x0
  da:	2c8080e7          	jalr	712(ra) # 39e <exec>
  de:	00001517          	auipc	a0,0x1
  e2:	87250513          	addi	a0,a0,-1934 # 950 <l_free+0x4e>
  e6:	00000097          	auipc	ra,0x0
  ea:	5fa080e7          	jalr	1530(ra) # 6e0 <printf>
  ee:	4505                	li	a0,1
  f0:	00000097          	auipc	ra,0x0
  f4:	276080e7          	jalr	630(ra) # 366 <exit>

00000000000000f8 <strcpy>:
  f8:	1141                	addi	sp,sp,-16
  fa:	e422                	sd	s0,8(sp)
  fc:	0800                	addi	s0,sp,16
  fe:	87aa                	mv	a5,a0
 100:	0585                	addi	a1,a1,1
 102:	0785                	addi	a5,a5,1
 104:	fff5c703          	lbu	a4,-1(a1)
 108:	fee78fa3          	sb	a4,-1(a5)
 10c:	fb75                	bnez	a4,100 <strcpy+0x8>
 10e:	6422                	ld	s0,8(sp)
 110:	0141                	addi	sp,sp,16
 112:	8082                	ret

0000000000000114 <strcmp>:
 114:	1141                	addi	sp,sp,-16
 116:	e422                	sd	s0,8(sp)
 118:	0800                	addi	s0,sp,16
 11a:	00054783          	lbu	a5,0(a0)
 11e:	cb91                	beqz	a5,132 <strcmp+0x1e>
 120:	0005c703          	lbu	a4,0(a1)
 124:	00f71763          	bne	a4,a5,132 <strcmp+0x1e>
 128:	0505                	addi	a0,a0,1
 12a:	0585                	addi	a1,a1,1
 12c:	00054783          	lbu	a5,0(a0)
 130:	fbe5                	bnez	a5,120 <strcmp+0xc>
 132:	0005c503          	lbu	a0,0(a1)
 136:	40a7853b          	subw	a0,a5,a0
 13a:	6422                	ld	s0,8(sp)
 13c:	0141                	addi	sp,sp,16
 13e:	8082                	ret

0000000000000140 <strlen>:
 140:	1141                	addi	sp,sp,-16
 142:	e422                	sd	s0,8(sp)
 144:	0800                	addi	s0,sp,16
 146:	00054783          	lbu	a5,0(a0)
 14a:	cf91                	beqz	a5,166 <strlen+0x26>
 14c:	0505                	addi	a0,a0,1
 14e:	87aa                	mv	a5,a0
 150:	4685                	li	a3,1
 152:	9e89                	subw	a3,a3,a0
 154:	00f6853b          	addw	a0,a3,a5
 158:	0785                	addi	a5,a5,1
 15a:	fff7c703          	lbu	a4,-1(a5)
 15e:	fb7d                	bnez	a4,154 <strlen+0x14>
 160:	6422                	ld	s0,8(sp)
 162:	0141                	addi	sp,sp,16
 164:	8082                	ret
 166:	4501                	li	a0,0
 168:	bfe5                	j	160 <strlen+0x20>

000000000000016a <memset>:
 16a:	1141                	addi	sp,sp,-16
 16c:	e422                	sd	s0,8(sp)
 16e:	0800                	addi	s0,sp,16
 170:	ca19                	beqz	a2,186 <memset+0x1c>
 172:	87aa                	mv	a5,a0
 174:	1602                	slli	a2,a2,0x20
 176:	9201                	srli	a2,a2,0x20
 178:	00a60733          	add	a4,a2,a0
 17c:	00b78023          	sb	a1,0(a5)
 180:	0785                	addi	a5,a5,1
 182:	fee79de3          	bne	a5,a4,17c <memset+0x12>
 186:	6422                	ld	s0,8(sp)
 188:	0141                	addi	sp,sp,16
 18a:	8082                	ret

000000000000018c <strchr>:
 18c:	1141                	addi	sp,sp,-16
 18e:	e422                	sd	s0,8(sp)
 190:	0800                	addi	s0,sp,16
 192:	00054783          	lbu	a5,0(a0)
 196:	cb99                	beqz	a5,1ac <strchr+0x20>
 198:	00f58763          	beq	a1,a5,1a6 <strchr+0x1a>
 19c:	0505                	addi	a0,a0,1
 19e:	00054783          	lbu	a5,0(a0)
 1a2:	fbfd                	bnez	a5,198 <strchr+0xc>
 1a4:	4501                	li	a0,0
 1a6:	6422                	ld	s0,8(sp)
 1a8:	0141                	addi	sp,sp,16
 1aa:	8082                	ret
 1ac:	4501                	li	a0,0
 1ae:	bfe5                	j	1a6 <strchr+0x1a>

00000000000001b0 <gets>:
 1b0:	711d                	addi	sp,sp,-96
 1b2:	ec86                	sd	ra,88(sp)
 1b4:	e8a2                	sd	s0,80(sp)
 1b6:	e4a6                	sd	s1,72(sp)
 1b8:	e0ca                	sd	s2,64(sp)
 1ba:	fc4e                	sd	s3,56(sp)
 1bc:	f852                	sd	s4,48(sp)
 1be:	f456                	sd	s5,40(sp)
 1c0:	f05a                	sd	s6,32(sp)
 1c2:	ec5e                	sd	s7,24(sp)
 1c4:	1080                	addi	s0,sp,96
 1c6:	8baa                	mv	s7,a0
 1c8:	8a2e                	mv	s4,a1
 1ca:	892a                	mv	s2,a0
 1cc:	4481                	li	s1,0
 1ce:	4aa9                	li	s5,10
 1d0:	4b35                	li	s6,13
 1d2:	89a6                	mv	s3,s1
 1d4:	2485                	addiw	s1,s1,1
 1d6:	0344d863          	bge	s1,s4,206 <gets+0x56>
 1da:	4605                	li	a2,1
 1dc:	faf40593          	addi	a1,s0,-81
 1e0:	4501                	li	a0,0
 1e2:	00000097          	auipc	ra,0x0
 1e6:	19c080e7          	jalr	412(ra) # 37e <read>
 1ea:	00a05e63          	blez	a0,206 <gets+0x56>
 1ee:	faf44783          	lbu	a5,-81(s0)
 1f2:	00f90023          	sb	a5,0(s2)
 1f6:	01578763          	beq	a5,s5,204 <gets+0x54>
 1fa:	0905                	addi	s2,s2,1
 1fc:	fd679be3          	bne	a5,s6,1d2 <gets+0x22>
 200:	89a6                	mv	s3,s1
 202:	a011                	j	206 <gets+0x56>
 204:	89a6                	mv	s3,s1
 206:	99de                	add	s3,s3,s7
 208:	00098023          	sb	zero,0(s3)
 20c:	855e                	mv	a0,s7
 20e:	60e6                	ld	ra,88(sp)
 210:	6446                	ld	s0,80(sp)
 212:	64a6                	ld	s1,72(sp)
 214:	6906                	ld	s2,64(sp)
 216:	79e2                	ld	s3,56(sp)
 218:	7a42                	ld	s4,48(sp)
 21a:	7aa2                	ld	s5,40(sp)
 21c:	7b02                	ld	s6,32(sp)
 21e:	6be2                	ld	s7,24(sp)
 220:	6125                	addi	sp,sp,96
 222:	8082                	ret

0000000000000224 <stat>:
 224:	1101                	addi	sp,sp,-32
 226:	ec06                	sd	ra,24(sp)
 228:	e822                	sd	s0,16(sp)
 22a:	e426                	sd	s1,8(sp)
 22c:	e04a                	sd	s2,0(sp)
 22e:	1000                	addi	s0,sp,32
 230:	892e                	mv	s2,a1
 232:	4581                	li	a1,0
 234:	00000097          	auipc	ra,0x0
 238:	172080e7          	jalr	370(ra) # 3a6 <open>
 23c:	02054563          	bltz	a0,266 <stat+0x42>
 240:	84aa                	mv	s1,a0
 242:	85ca                	mv	a1,s2
 244:	00000097          	auipc	ra,0x0
 248:	17a080e7          	jalr	378(ra) # 3be <fstat>
 24c:	892a                	mv	s2,a0
 24e:	8526                	mv	a0,s1
 250:	00000097          	auipc	ra,0x0
 254:	13e080e7          	jalr	318(ra) # 38e <close>
 258:	854a                	mv	a0,s2
 25a:	60e2                	ld	ra,24(sp)
 25c:	6442                	ld	s0,16(sp)
 25e:	64a2                	ld	s1,8(sp)
 260:	6902                	ld	s2,0(sp)
 262:	6105                	addi	sp,sp,32
 264:	8082                	ret
 266:	597d                	li	s2,-1
 268:	bfc5                	j	258 <stat+0x34>

000000000000026a <atoi>:
 26a:	1141                	addi	sp,sp,-16
 26c:	e422                	sd	s0,8(sp)
 26e:	0800                	addi	s0,sp,16
 270:	00054603          	lbu	a2,0(a0)
 274:	fd06079b          	addiw	a5,a2,-48
 278:	0ff7f793          	zext.b	a5,a5
 27c:	4725                	li	a4,9
 27e:	02f76963          	bltu	a4,a5,2b0 <atoi+0x46>
 282:	86aa                	mv	a3,a0
 284:	4501                	li	a0,0
 286:	45a5                	li	a1,9
 288:	0685                	addi	a3,a3,1
 28a:	0025179b          	slliw	a5,a0,0x2
 28e:	9fa9                	addw	a5,a5,a0
 290:	0017979b          	slliw	a5,a5,0x1
 294:	9fb1                	addw	a5,a5,a2
 296:	fd07851b          	addiw	a0,a5,-48
 29a:	0006c603          	lbu	a2,0(a3)
 29e:	fd06071b          	addiw	a4,a2,-48
 2a2:	0ff77713          	zext.b	a4,a4
 2a6:	fee5f1e3          	bgeu	a1,a4,288 <atoi+0x1e>
 2aa:	6422                	ld	s0,8(sp)
 2ac:	0141                	addi	sp,sp,16
 2ae:	8082                	ret
 2b0:	4501                	li	a0,0
 2b2:	bfe5                	j	2aa <atoi+0x40>

00000000000002b4 <memmove>:
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e422                	sd	s0,8(sp)
 2b8:	0800                	addi	s0,sp,16
 2ba:	02b57463          	bgeu	a0,a1,2e2 <memmove+0x2e>
 2be:	00c05f63          	blez	a2,2dc <memmove+0x28>
 2c2:	1602                	slli	a2,a2,0x20
 2c4:	9201                	srli	a2,a2,0x20
 2c6:	00c507b3          	add	a5,a0,a2
 2ca:	872a                	mv	a4,a0
 2cc:	0585                	addi	a1,a1,1
 2ce:	0705                	addi	a4,a4,1
 2d0:	fff5c683          	lbu	a3,-1(a1)
 2d4:	fed70fa3          	sb	a3,-1(a4)
 2d8:	fee79ae3          	bne	a5,a4,2cc <memmove+0x18>
 2dc:	6422                	ld	s0,8(sp)
 2de:	0141                	addi	sp,sp,16
 2e0:	8082                	ret
 2e2:	00c50733          	add	a4,a0,a2
 2e6:	95b2                	add	a1,a1,a2
 2e8:	fec05ae3          	blez	a2,2dc <memmove+0x28>
 2ec:	fff6079b          	addiw	a5,a2,-1
 2f0:	1782                	slli	a5,a5,0x20
 2f2:	9381                	srli	a5,a5,0x20
 2f4:	fff7c793          	not	a5,a5
 2f8:	97ba                	add	a5,a5,a4
 2fa:	15fd                	addi	a1,a1,-1
 2fc:	177d                	addi	a4,a4,-1
 2fe:	0005c683          	lbu	a3,0(a1)
 302:	00d70023          	sb	a3,0(a4)
 306:	fee79ae3          	bne	a5,a4,2fa <memmove+0x46>
 30a:	bfc9                	j	2dc <memmove+0x28>

000000000000030c <memcmp>:
 30c:	1141                	addi	sp,sp,-16
 30e:	e422                	sd	s0,8(sp)
 310:	0800                	addi	s0,sp,16
 312:	ca05                	beqz	a2,342 <memcmp+0x36>
 314:	fff6069b          	addiw	a3,a2,-1
 318:	1682                	slli	a3,a3,0x20
 31a:	9281                	srli	a3,a3,0x20
 31c:	0685                	addi	a3,a3,1
 31e:	96aa                	add	a3,a3,a0
 320:	00054783          	lbu	a5,0(a0)
 324:	0005c703          	lbu	a4,0(a1)
 328:	00e79863          	bne	a5,a4,338 <memcmp+0x2c>
 32c:	0505                	addi	a0,a0,1
 32e:	0585                	addi	a1,a1,1
 330:	fed518e3          	bne	a0,a3,320 <memcmp+0x14>
 334:	4501                	li	a0,0
 336:	a019                	j	33c <memcmp+0x30>
 338:	40e7853b          	subw	a0,a5,a4
 33c:	6422                	ld	s0,8(sp)
 33e:	0141                	addi	sp,sp,16
 340:	8082                	ret
 342:	4501                	li	a0,0
 344:	bfe5                	j	33c <memcmp+0x30>

0000000000000346 <memcpy>:
 346:	1141                	addi	sp,sp,-16
 348:	e406                	sd	ra,8(sp)
 34a:	e022                	sd	s0,0(sp)
 34c:	0800                	addi	s0,sp,16
 34e:	00000097          	auipc	ra,0x0
 352:	f66080e7          	jalr	-154(ra) # 2b4 <memmove>
 356:	60a2                	ld	ra,8(sp)
 358:	6402                	ld	s0,0(sp)
 35a:	0141                	addi	sp,sp,16
 35c:	8082                	ret

000000000000035e <fork>:
 35e:	4885                	li	a7,1
 360:	00000073          	ecall
 364:	8082                	ret

0000000000000366 <exit>:
 366:	4889                	li	a7,2
 368:	00000073          	ecall
 36c:	8082                	ret

000000000000036e <wait>:
 36e:	488d                	li	a7,3
 370:	00000073          	ecall
 374:	8082                	ret

0000000000000376 <pipe>:
 376:	4891                	li	a7,4
 378:	00000073          	ecall
 37c:	8082                	ret

000000000000037e <read>:
 37e:	4895                	li	a7,5
 380:	00000073          	ecall
 384:	8082                	ret

0000000000000386 <write>:
 386:	48c1                	li	a7,16
 388:	00000073          	ecall
 38c:	8082                	ret

000000000000038e <close>:
 38e:	48d5                	li	a7,21
 390:	00000073          	ecall
 394:	8082                	ret

0000000000000396 <kill>:
 396:	4899                	li	a7,6
 398:	00000073          	ecall
 39c:	8082                	ret

000000000000039e <exec>:
 39e:	489d                	li	a7,7
 3a0:	00000073          	ecall
 3a4:	8082                	ret

00000000000003a6 <open>:
 3a6:	48bd                	li	a7,15
 3a8:	00000073          	ecall
 3ac:	8082                	ret

00000000000003ae <mknod>:
 3ae:	48c5                	li	a7,17
 3b0:	00000073          	ecall
 3b4:	8082                	ret

00000000000003b6 <unlink>:
 3b6:	48c9                	li	a7,18
 3b8:	00000073          	ecall
 3bc:	8082                	ret

00000000000003be <fstat>:
 3be:	48a1                	li	a7,8
 3c0:	00000073          	ecall
 3c4:	8082                	ret

00000000000003c6 <link>:
 3c6:	48cd                	li	a7,19
 3c8:	00000073          	ecall
 3cc:	8082                	ret

00000000000003ce <mkdir>:
 3ce:	48d1                	li	a7,20
 3d0:	00000073          	ecall
 3d4:	8082                	ret

00000000000003d6 <chdir>:
 3d6:	48a5                	li	a7,9
 3d8:	00000073          	ecall
 3dc:	8082                	ret

00000000000003de <dup>:
 3de:	48a9                	li	a7,10
 3e0:	00000073          	ecall
 3e4:	8082                	ret

00000000000003e6 <getpid>:
 3e6:	48ad                	li	a7,11
 3e8:	00000073          	ecall
 3ec:	8082                	ret

00000000000003ee <sbrk>:
 3ee:	48b1                	li	a7,12
 3f0:	00000073          	ecall
 3f4:	8082                	ret

00000000000003f6 <sleep>:
 3f6:	48b5                	li	a7,13
 3f8:	00000073          	ecall
 3fc:	8082                	ret

00000000000003fe <uptime>:
 3fe:	48b9                	li	a7,14
 400:	00000073          	ecall
 404:	8082                	ret

0000000000000406 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 406:	1101                	addi	sp,sp,-32
 408:	ec06                	sd	ra,24(sp)
 40a:	e822                	sd	s0,16(sp)
 40c:	1000                	addi	s0,sp,32
 40e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 412:	4605                	li	a2,1
 414:	fef40593          	addi	a1,s0,-17
 418:	00000097          	auipc	ra,0x0
 41c:	f6e080e7          	jalr	-146(ra) # 386 <write>
}
 420:	60e2                	ld	ra,24(sp)
 422:	6442                	ld	s0,16(sp)
 424:	6105                	addi	sp,sp,32
 426:	8082                	ret

0000000000000428 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 428:	7139                	addi	sp,sp,-64
 42a:	fc06                	sd	ra,56(sp)
 42c:	f822                	sd	s0,48(sp)
 42e:	f426                	sd	s1,40(sp)
 430:	f04a                	sd	s2,32(sp)
 432:	ec4e                	sd	s3,24(sp)
 434:	0080                	addi	s0,sp,64
 436:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 438:	c299                	beqz	a3,43e <printint+0x16>
 43a:	0805c963          	bltz	a1,4cc <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 43e:	2581                	sext.w	a1,a1
  neg = 0;
 440:	4881                	li	a7,0
 442:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 446:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 448:	2601                	sext.w	a2,a2
 44a:	00000517          	auipc	a0,0x0
 44e:	59e50513          	addi	a0,a0,1438 # 9e8 <digits>
 452:	883a                	mv	a6,a4
 454:	2705                	addiw	a4,a4,1
 456:	02c5f7bb          	remuw	a5,a1,a2
 45a:	1782                	slli	a5,a5,0x20
 45c:	9381                	srli	a5,a5,0x20
 45e:	97aa                	add	a5,a5,a0
 460:	0007c783          	lbu	a5,0(a5)
 464:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 468:	0005879b          	sext.w	a5,a1
 46c:	02c5d5bb          	divuw	a1,a1,a2
 470:	0685                	addi	a3,a3,1
 472:	fec7f0e3          	bgeu	a5,a2,452 <printint+0x2a>
  if(neg)
 476:	00088c63          	beqz	a7,48e <printint+0x66>
    buf[i++] = '-';
 47a:	fd070793          	addi	a5,a4,-48
 47e:	00878733          	add	a4,a5,s0
 482:	02d00793          	li	a5,45
 486:	fef70823          	sb	a5,-16(a4)
 48a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 48e:	02e05863          	blez	a4,4be <printint+0x96>
 492:	fc040793          	addi	a5,s0,-64
 496:	00e78933          	add	s2,a5,a4
 49a:	fff78993          	addi	s3,a5,-1
 49e:	99ba                	add	s3,s3,a4
 4a0:	377d                	addiw	a4,a4,-1
 4a2:	1702                	slli	a4,a4,0x20
 4a4:	9301                	srli	a4,a4,0x20
 4a6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4aa:	fff94583          	lbu	a1,-1(s2)
 4ae:	8526                	mv	a0,s1
 4b0:	00000097          	auipc	ra,0x0
 4b4:	f56080e7          	jalr	-170(ra) # 406 <putc>
  while(--i >= 0)
 4b8:	197d                	addi	s2,s2,-1
 4ba:	ff3918e3          	bne	s2,s3,4aa <printint+0x82>
}
 4be:	70e2                	ld	ra,56(sp)
 4c0:	7442                	ld	s0,48(sp)
 4c2:	74a2                	ld	s1,40(sp)
 4c4:	7902                	ld	s2,32(sp)
 4c6:	69e2                	ld	s3,24(sp)
 4c8:	6121                	addi	sp,sp,64
 4ca:	8082                	ret
    x = -xx;
 4cc:	40b005bb          	negw	a1,a1
    neg = 1;
 4d0:	4885                	li	a7,1
    x = -xx;
 4d2:	bf85                	j	442 <printint+0x1a>

00000000000004d4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4d4:	7119                	addi	sp,sp,-128
 4d6:	fc86                	sd	ra,120(sp)
 4d8:	f8a2                	sd	s0,112(sp)
 4da:	f4a6                	sd	s1,104(sp)
 4dc:	f0ca                	sd	s2,96(sp)
 4de:	ecce                	sd	s3,88(sp)
 4e0:	e8d2                	sd	s4,80(sp)
 4e2:	e4d6                	sd	s5,72(sp)
 4e4:	e0da                	sd	s6,64(sp)
 4e6:	fc5e                	sd	s7,56(sp)
 4e8:	f862                	sd	s8,48(sp)
 4ea:	f466                	sd	s9,40(sp)
 4ec:	f06a                	sd	s10,32(sp)
 4ee:	ec6e                	sd	s11,24(sp)
 4f0:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4f2:	0005c903          	lbu	s2,0(a1)
 4f6:	18090f63          	beqz	s2,694 <vprintf+0x1c0>
 4fa:	8aaa                	mv	s5,a0
 4fc:	8b32                	mv	s6,a2
 4fe:	00158493          	addi	s1,a1,1
  state = 0;
 502:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 504:	02500a13          	li	s4,37
 508:	4c55                	li	s8,21
 50a:	00000c97          	auipc	s9,0x0
 50e:	486c8c93          	addi	s9,s9,1158 # 990 <l_free+0x8e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 512:	02800d93          	li	s11,40
  putc(fd, 'x');
 516:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 518:	00000b97          	auipc	s7,0x0
 51c:	4d0b8b93          	addi	s7,s7,1232 # 9e8 <digits>
 520:	a839                	j	53e <vprintf+0x6a>
        putc(fd, c);
 522:	85ca                	mv	a1,s2
 524:	8556                	mv	a0,s5
 526:	00000097          	auipc	ra,0x0
 52a:	ee0080e7          	jalr	-288(ra) # 406 <putc>
 52e:	a019                	j	534 <vprintf+0x60>
    } else if(state == '%'){
 530:	01498d63          	beq	s3,s4,54a <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 534:	0485                	addi	s1,s1,1
 536:	fff4c903          	lbu	s2,-1(s1)
 53a:	14090d63          	beqz	s2,694 <vprintf+0x1c0>
    if(state == 0){
 53e:	fe0999e3          	bnez	s3,530 <vprintf+0x5c>
      if(c == '%'){
 542:	ff4910e3          	bne	s2,s4,522 <vprintf+0x4e>
        state = '%';
 546:	89d2                	mv	s3,s4
 548:	b7f5                	j	534 <vprintf+0x60>
      if(c == 'd'){
 54a:	11490c63          	beq	s2,s4,662 <vprintf+0x18e>
 54e:	f9d9079b          	addiw	a5,s2,-99
 552:	0ff7f793          	zext.b	a5,a5
 556:	10fc6e63          	bltu	s8,a5,672 <vprintf+0x19e>
 55a:	f9d9079b          	addiw	a5,s2,-99
 55e:	0ff7f713          	zext.b	a4,a5
 562:	10ec6863          	bltu	s8,a4,672 <vprintf+0x19e>
 566:	00271793          	slli	a5,a4,0x2
 56a:	97e6                	add	a5,a5,s9
 56c:	439c                	lw	a5,0(a5)
 56e:	97e6                	add	a5,a5,s9
 570:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 572:	008b0913          	addi	s2,s6,8
 576:	4685                	li	a3,1
 578:	4629                	li	a2,10
 57a:	000b2583          	lw	a1,0(s6)
 57e:	8556                	mv	a0,s5
 580:	00000097          	auipc	ra,0x0
 584:	ea8080e7          	jalr	-344(ra) # 428 <printint>
 588:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 58a:	4981                	li	s3,0
 58c:	b765                	j	534 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 58e:	008b0913          	addi	s2,s6,8
 592:	4681                	li	a3,0
 594:	4629                	li	a2,10
 596:	000b2583          	lw	a1,0(s6)
 59a:	8556                	mv	a0,s5
 59c:	00000097          	auipc	ra,0x0
 5a0:	e8c080e7          	jalr	-372(ra) # 428 <printint>
 5a4:	8b4a                	mv	s6,s2
      state = 0;
 5a6:	4981                	li	s3,0
 5a8:	b771                	j	534 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5aa:	008b0913          	addi	s2,s6,8
 5ae:	4681                	li	a3,0
 5b0:	866a                	mv	a2,s10
 5b2:	000b2583          	lw	a1,0(s6)
 5b6:	8556                	mv	a0,s5
 5b8:	00000097          	auipc	ra,0x0
 5bc:	e70080e7          	jalr	-400(ra) # 428 <printint>
 5c0:	8b4a                	mv	s6,s2
      state = 0;
 5c2:	4981                	li	s3,0
 5c4:	bf85                	j	534 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5c6:	008b0793          	addi	a5,s6,8
 5ca:	f8f43423          	sd	a5,-120(s0)
 5ce:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5d2:	03000593          	li	a1,48
 5d6:	8556                	mv	a0,s5
 5d8:	00000097          	auipc	ra,0x0
 5dc:	e2e080e7          	jalr	-466(ra) # 406 <putc>
  putc(fd, 'x');
 5e0:	07800593          	li	a1,120
 5e4:	8556                	mv	a0,s5
 5e6:	00000097          	auipc	ra,0x0
 5ea:	e20080e7          	jalr	-480(ra) # 406 <putc>
 5ee:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5f0:	03c9d793          	srli	a5,s3,0x3c
 5f4:	97de                	add	a5,a5,s7
 5f6:	0007c583          	lbu	a1,0(a5)
 5fa:	8556                	mv	a0,s5
 5fc:	00000097          	auipc	ra,0x0
 600:	e0a080e7          	jalr	-502(ra) # 406 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 604:	0992                	slli	s3,s3,0x4
 606:	397d                	addiw	s2,s2,-1
 608:	fe0914e3          	bnez	s2,5f0 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 60c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 610:	4981                	li	s3,0
 612:	b70d                	j	534 <vprintf+0x60>
        s = va_arg(ap, char*);
 614:	008b0913          	addi	s2,s6,8
 618:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 61c:	02098163          	beqz	s3,63e <vprintf+0x16a>
        while(*s != 0){
 620:	0009c583          	lbu	a1,0(s3)
 624:	c5ad                	beqz	a1,68e <vprintf+0x1ba>
          putc(fd, *s);
 626:	8556                	mv	a0,s5
 628:	00000097          	auipc	ra,0x0
 62c:	dde080e7          	jalr	-546(ra) # 406 <putc>
          s++;
 630:	0985                	addi	s3,s3,1
        while(*s != 0){
 632:	0009c583          	lbu	a1,0(s3)
 636:	f9e5                	bnez	a1,626 <vprintf+0x152>
        s = va_arg(ap, char*);
 638:	8b4a                	mv	s6,s2
      state = 0;
 63a:	4981                	li	s3,0
 63c:	bde5                	j	534 <vprintf+0x60>
          s = "(null)";
 63e:	00000997          	auipc	s3,0x0
 642:	34a98993          	addi	s3,s3,842 # 988 <l_free+0x86>
        while(*s != 0){
 646:	85ee                	mv	a1,s11
 648:	bff9                	j	626 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 64a:	008b0913          	addi	s2,s6,8
 64e:	000b4583          	lbu	a1,0(s6)
 652:	8556                	mv	a0,s5
 654:	00000097          	auipc	ra,0x0
 658:	db2080e7          	jalr	-590(ra) # 406 <putc>
 65c:	8b4a                	mv	s6,s2
      state = 0;
 65e:	4981                	li	s3,0
 660:	bdd1                	j	534 <vprintf+0x60>
        putc(fd, c);
 662:	85d2                	mv	a1,s4
 664:	8556                	mv	a0,s5
 666:	00000097          	auipc	ra,0x0
 66a:	da0080e7          	jalr	-608(ra) # 406 <putc>
      state = 0;
 66e:	4981                	li	s3,0
 670:	b5d1                	j	534 <vprintf+0x60>
        putc(fd, '%');
 672:	85d2                	mv	a1,s4
 674:	8556                	mv	a0,s5
 676:	00000097          	auipc	ra,0x0
 67a:	d90080e7          	jalr	-624(ra) # 406 <putc>
        putc(fd, c);
 67e:	85ca                	mv	a1,s2
 680:	8556                	mv	a0,s5
 682:	00000097          	auipc	ra,0x0
 686:	d84080e7          	jalr	-636(ra) # 406 <putc>
      state = 0;
 68a:	4981                	li	s3,0
 68c:	b565                	j	534 <vprintf+0x60>
        s = va_arg(ap, char*);
 68e:	8b4a                	mv	s6,s2
      state = 0;
 690:	4981                	li	s3,0
 692:	b54d                	j	534 <vprintf+0x60>
    }
  }
}
 694:	70e6                	ld	ra,120(sp)
 696:	7446                	ld	s0,112(sp)
 698:	74a6                	ld	s1,104(sp)
 69a:	7906                	ld	s2,96(sp)
 69c:	69e6                	ld	s3,88(sp)
 69e:	6a46                	ld	s4,80(sp)
 6a0:	6aa6                	ld	s5,72(sp)
 6a2:	6b06                	ld	s6,64(sp)
 6a4:	7be2                	ld	s7,56(sp)
 6a6:	7c42                	ld	s8,48(sp)
 6a8:	7ca2                	ld	s9,40(sp)
 6aa:	7d02                	ld	s10,32(sp)
 6ac:	6de2                	ld	s11,24(sp)
 6ae:	6109                	addi	sp,sp,128
 6b0:	8082                	ret

00000000000006b2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6b2:	715d                	addi	sp,sp,-80
 6b4:	ec06                	sd	ra,24(sp)
 6b6:	e822                	sd	s0,16(sp)
 6b8:	1000                	addi	s0,sp,32
 6ba:	e010                	sd	a2,0(s0)
 6bc:	e414                	sd	a3,8(s0)
 6be:	e818                	sd	a4,16(s0)
 6c0:	ec1c                	sd	a5,24(s0)
 6c2:	03043023          	sd	a6,32(s0)
 6c6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6ca:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6ce:	8622                	mv	a2,s0
 6d0:	00000097          	auipc	ra,0x0
 6d4:	e04080e7          	jalr	-508(ra) # 4d4 <vprintf>
}
 6d8:	60e2                	ld	ra,24(sp)
 6da:	6442                	ld	s0,16(sp)
 6dc:	6161                	addi	sp,sp,80
 6de:	8082                	ret

00000000000006e0 <printf>:

void
printf(const char *fmt, ...)
{
 6e0:	711d                	addi	sp,sp,-96
 6e2:	ec06                	sd	ra,24(sp)
 6e4:	e822                	sd	s0,16(sp)
 6e6:	1000                	addi	s0,sp,32
 6e8:	e40c                	sd	a1,8(s0)
 6ea:	e810                	sd	a2,16(s0)
 6ec:	ec14                	sd	a3,24(s0)
 6ee:	f018                	sd	a4,32(s0)
 6f0:	f41c                	sd	a5,40(s0)
 6f2:	03043823          	sd	a6,48(s0)
 6f6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6fa:	00840613          	addi	a2,s0,8
 6fe:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 702:	85aa                	mv	a1,a0
 704:	4505                	li	a0,1
 706:	00000097          	auipc	ra,0x0
 70a:	dce080e7          	jalr	-562(ra) # 4d4 <vprintf>
}
 70e:	60e2                	ld	ra,24(sp)
 710:	6442                	ld	s0,16(sp)
 712:	6125                	addi	sp,sp,96
 714:	8082                	ret

0000000000000716 <free>:
 716:	1141                	addi	sp,sp,-16
 718:	e422                	sd	s0,8(sp)
 71a:	0800                	addi	s0,sp,16
 71c:	ff050693          	addi	a3,a0,-16
 720:	00000797          	auipc	a5,0x0
 724:	3007b783          	ld	a5,768(a5) # a20 <freep>
 728:	a805                	j	758 <free+0x42>
 72a:	4618                	lw	a4,8(a2)
 72c:	9db9                	addw	a1,a1,a4
 72e:	feb52c23          	sw	a1,-8(a0)
 732:	6398                	ld	a4,0(a5)
 734:	6318                	ld	a4,0(a4)
 736:	fee53823          	sd	a4,-16(a0)
 73a:	a091                	j	77e <free+0x68>
 73c:	ff852703          	lw	a4,-8(a0)
 740:	9e39                	addw	a2,a2,a4
 742:	c790                	sw	a2,8(a5)
 744:	ff053703          	ld	a4,-16(a0)
 748:	e398                	sd	a4,0(a5)
 74a:	a099                	j	790 <free+0x7a>
 74c:	6398                	ld	a4,0(a5)
 74e:	00e7e463          	bltu	a5,a4,756 <free+0x40>
 752:	00e6ea63          	bltu	a3,a4,766 <free+0x50>
 756:	87ba                	mv	a5,a4
 758:	fed7fae3          	bgeu	a5,a3,74c <free+0x36>
 75c:	6398                	ld	a4,0(a5)
 75e:	00e6e463          	bltu	a3,a4,766 <free+0x50>
 762:	fee7eae3          	bltu	a5,a4,756 <free+0x40>
 766:	ff852583          	lw	a1,-8(a0)
 76a:	6390                	ld	a2,0(a5)
 76c:	02059713          	slli	a4,a1,0x20
 770:	9301                	srli	a4,a4,0x20
 772:	0712                	slli	a4,a4,0x4
 774:	9736                	add	a4,a4,a3
 776:	fae60ae3          	beq	a2,a4,72a <free+0x14>
 77a:	fec53823          	sd	a2,-16(a0)
 77e:	4790                	lw	a2,8(a5)
 780:	02061713          	slli	a4,a2,0x20
 784:	9301                	srli	a4,a4,0x20
 786:	0712                	slli	a4,a4,0x4
 788:	973e                	add	a4,a4,a5
 78a:	fae689e3          	beq	a3,a4,73c <free+0x26>
 78e:	e394                	sd	a3,0(a5)
 790:	00000717          	auipc	a4,0x0
 794:	28f73823          	sd	a5,656(a4) # a20 <freep>
 798:	6422                	ld	s0,8(sp)
 79a:	0141                	addi	sp,sp,16
 79c:	8082                	ret

000000000000079e <malloc>:
 79e:	7139                	addi	sp,sp,-64
 7a0:	fc06                	sd	ra,56(sp)
 7a2:	f822                	sd	s0,48(sp)
 7a4:	f426                	sd	s1,40(sp)
 7a6:	f04a                	sd	s2,32(sp)
 7a8:	ec4e                	sd	s3,24(sp)
 7aa:	e852                	sd	s4,16(sp)
 7ac:	e456                	sd	s5,8(sp)
 7ae:	e05a                	sd	s6,0(sp)
 7b0:	0080                	addi	s0,sp,64
 7b2:	02051493          	slli	s1,a0,0x20
 7b6:	9081                	srli	s1,s1,0x20
 7b8:	04bd                	addi	s1,s1,15
 7ba:	8091                	srli	s1,s1,0x4
 7bc:	0014899b          	addiw	s3,s1,1
 7c0:	0485                	addi	s1,s1,1
 7c2:	00000517          	auipc	a0,0x0
 7c6:	25e53503          	ld	a0,606(a0) # a20 <freep>
 7ca:	c515                	beqz	a0,7f6 <malloc+0x58>
 7cc:	611c                	ld	a5,0(a0)
 7ce:	4798                	lw	a4,8(a5)
 7d0:	02977f63          	bgeu	a4,s1,80e <malloc+0x70>
 7d4:	8a4e                	mv	s4,s3
 7d6:	0009871b          	sext.w	a4,s3
 7da:	6685                	lui	a3,0x1
 7dc:	00d77363          	bgeu	a4,a3,7e2 <malloc+0x44>
 7e0:	6a05                	lui	s4,0x1
 7e2:	000a0b1b          	sext.w	s6,s4
 7e6:	004a1a1b          	slliw	s4,s4,0x4
 7ea:	00000917          	auipc	s2,0x0
 7ee:	23690913          	addi	s2,s2,566 # a20 <freep>
 7f2:	5afd                	li	s5,-1
 7f4:	a88d                	j	866 <malloc+0xc8>
 7f6:	00000797          	auipc	a5,0x0
 7fa:	23278793          	addi	a5,a5,562 # a28 <base>
 7fe:	00000717          	auipc	a4,0x0
 802:	22f73123          	sd	a5,546(a4) # a20 <freep>
 806:	e39c                	sd	a5,0(a5)
 808:	0007a423          	sw	zero,8(a5)
 80c:	b7e1                	j	7d4 <malloc+0x36>
 80e:	02e48b63          	beq	s1,a4,844 <malloc+0xa6>
 812:	4137073b          	subw	a4,a4,s3
 816:	c798                	sw	a4,8(a5)
 818:	1702                	slli	a4,a4,0x20
 81a:	9301                	srli	a4,a4,0x20
 81c:	0712                	slli	a4,a4,0x4
 81e:	97ba                	add	a5,a5,a4
 820:	0137a423          	sw	s3,8(a5)
 824:	00000717          	auipc	a4,0x0
 828:	1ea73e23          	sd	a0,508(a4) # a20 <freep>
 82c:	01078513          	addi	a0,a5,16
 830:	70e2                	ld	ra,56(sp)
 832:	7442                	ld	s0,48(sp)
 834:	74a2                	ld	s1,40(sp)
 836:	7902                	ld	s2,32(sp)
 838:	69e2                	ld	s3,24(sp)
 83a:	6a42                	ld	s4,16(sp)
 83c:	6aa2                	ld	s5,8(sp)
 83e:	6b02                	ld	s6,0(sp)
 840:	6121                	addi	sp,sp,64
 842:	8082                	ret
 844:	6398                	ld	a4,0(a5)
 846:	e118                	sd	a4,0(a0)
 848:	bff1                	j	824 <malloc+0x86>
 84a:	01652423          	sw	s6,8(a0)
 84e:	0541                	addi	a0,a0,16
 850:	00000097          	auipc	ra,0x0
 854:	ec6080e7          	jalr	-314(ra) # 716 <free>
 858:	00093503          	ld	a0,0(s2)
 85c:	d971                	beqz	a0,830 <malloc+0x92>
 85e:	611c                	ld	a5,0(a0)
 860:	4798                	lw	a4,8(a5)
 862:	fa9776e3          	bgeu	a4,s1,80e <malloc+0x70>
 866:	00093703          	ld	a4,0(s2)
 86a:	853e                	mv	a0,a5
 86c:	fef719e3          	bne	a4,a5,85e <malloc+0xc0>
 870:	8552                	mv	a0,s4
 872:	00000097          	auipc	ra,0x0
 876:	b7c080e7          	jalr	-1156(ra) # 3ee <sbrk>
 87a:	fd5518e3          	bne	a0,s5,84a <malloc+0xac>
 87e:	4501                	li	a0,0
 880:	bf45                	j	830 <malloc+0x92>

0000000000000882 <mem_init>:
 882:	1141                	addi	sp,sp,-16
 884:	e406                	sd	ra,8(sp)
 886:	e022                	sd	s0,0(sp)
 888:	0800                	addi	s0,sp,16
 88a:	6505                	lui	a0,0x1
 88c:	00000097          	auipc	ra,0x0
 890:	b62080e7          	jalr	-1182(ra) # 3ee <sbrk>
 894:	00000797          	auipc	a5,0x0
 898:	18a7b223          	sd	a0,388(a5) # a18 <alloc>
 89c:	00850793          	addi	a5,a0,8 # 1008 <__BSS_END__+0x5d0>
 8a0:	e11c                	sd	a5,0(a0)
 8a2:	60a2                	ld	ra,8(sp)
 8a4:	6402                	ld	s0,0(sp)
 8a6:	0141                	addi	sp,sp,16
 8a8:	8082                	ret

00000000000008aa <l_alloc>:
 8aa:	1101                	addi	sp,sp,-32
 8ac:	ec06                	sd	ra,24(sp)
 8ae:	e822                	sd	s0,16(sp)
 8b0:	e426                	sd	s1,8(sp)
 8b2:	1000                	addi	s0,sp,32
 8b4:	84aa                	mv	s1,a0
 8b6:	00000797          	auipc	a5,0x0
 8ba:	15a7a783          	lw	a5,346(a5) # a10 <if_init>
 8be:	c795                	beqz	a5,8ea <l_alloc+0x40>
 8c0:	00000717          	auipc	a4,0x0
 8c4:	15873703          	ld	a4,344(a4) # a18 <alloc>
 8c8:	6308                	ld	a0,0(a4)
 8ca:	40e506b3          	sub	a3,a0,a4
 8ce:	6785                	lui	a5,0x1
 8d0:	37e1                	addiw	a5,a5,-8
 8d2:	9f95                	subw	a5,a5,a3
 8d4:	02f4f563          	bgeu	s1,a5,8fe <l_alloc+0x54>
 8d8:	1482                	slli	s1,s1,0x20
 8da:	9081                	srli	s1,s1,0x20
 8dc:	94aa                	add	s1,s1,a0
 8de:	e304                	sd	s1,0(a4)
 8e0:	60e2                	ld	ra,24(sp)
 8e2:	6442                	ld	s0,16(sp)
 8e4:	64a2                	ld	s1,8(sp)
 8e6:	6105                	addi	sp,sp,32
 8e8:	8082                	ret
 8ea:	00000097          	auipc	ra,0x0
 8ee:	f98080e7          	jalr	-104(ra) # 882 <mem_init>
 8f2:	4785                	li	a5,1
 8f4:	00000717          	auipc	a4,0x0
 8f8:	10f72e23          	sw	a5,284(a4) # a10 <if_init>
 8fc:	b7d1                	j	8c0 <l_alloc+0x16>
 8fe:	4501                	li	a0,0
 900:	b7c5                	j	8e0 <l_alloc+0x36>

0000000000000902 <l_free>:
 902:	1141                	addi	sp,sp,-16
 904:	e422                	sd	s0,8(sp)
 906:	0800                	addi	s0,sp,16
 908:	6422                	ld	s0,8(sp)
 90a:	0141                	addi	sp,sp,16
 90c:	8082                	ret
