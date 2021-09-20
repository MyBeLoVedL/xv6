
user/_rm:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	4785                	li	a5,1
  10:	02a7d763          	bge	a5,a0,3e <main+0x3e>
  14:	00858493          	addi	s1,a1,8
  18:	ffe5091b          	addiw	s2,a0,-2
  1c:	1902                	slli	s2,s2,0x20
  1e:	02095913          	srli	s2,s2,0x20
  22:	090e                	slli	s2,s2,0x3
  24:	05c1                	addi	a1,a1,16
  26:	992e                	add	s2,s2,a1
  28:	6088                	ld	a0,0(s1)
  2a:	00000097          	auipc	ra,0x0
  2e:	30c080e7          	jalr	780(ra) # 336 <unlink>
  32:	02054463          	bltz	a0,5a <main+0x5a>
  36:	04a1                	addi	s1,s1,8
  38:	ff2498e3          	bne	s1,s2,28 <main+0x28>
  3c:	a80d                	j	6e <main+0x6e>
  3e:	00001597          	auipc	a1,0x1
  42:	85258593          	addi	a1,a1,-1966 # 890 <l_free+0xe>
  46:	4509                	li	a0,2
  48:	00000097          	auipc	ra,0x0
  4c:	5ea080e7          	jalr	1514(ra) # 632 <fprintf>
  50:	4505                	li	a0,1
  52:	00000097          	auipc	ra,0x0
  56:	294080e7          	jalr	660(ra) # 2e6 <exit>
  5a:	6090                	ld	a2,0(s1)
  5c:	00001597          	auipc	a1,0x1
  60:	84c58593          	addi	a1,a1,-1972 # 8a8 <l_free+0x26>
  64:	4509                	li	a0,2
  66:	00000097          	auipc	ra,0x0
  6a:	5cc080e7          	jalr	1484(ra) # 632 <fprintf>
  6e:	4501                	li	a0,0
  70:	00000097          	auipc	ra,0x0
  74:	276080e7          	jalr	630(ra) # 2e6 <exit>

0000000000000078 <strcpy>:
  78:	1141                	addi	sp,sp,-16
  7a:	e422                	sd	s0,8(sp)
  7c:	0800                	addi	s0,sp,16
  7e:	87aa                	mv	a5,a0
  80:	0585                	addi	a1,a1,1
  82:	0785                	addi	a5,a5,1
  84:	fff5c703          	lbu	a4,-1(a1)
  88:	fee78fa3          	sb	a4,-1(a5)
  8c:	fb75                	bnez	a4,80 <strcpy+0x8>
  8e:	6422                	ld	s0,8(sp)
  90:	0141                	addi	sp,sp,16
  92:	8082                	ret

0000000000000094 <strcmp>:
  94:	1141                	addi	sp,sp,-16
  96:	e422                	sd	s0,8(sp)
  98:	0800                	addi	s0,sp,16
  9a:	00054783          	lbu	a5,0(a0)
  9e:	cb91                	beqz	a5,b2 <strcmp+0x1e>
  a0:	0005c703          	lbu	a4,0(a1)
  a4:	00f71763          	bne	a4,a5,b2 <strcmp+0x1e>
  a8:	0505                	addi	a0,a0,1
  aa:	0585                	addi	a1,a1,1
  ac:	00054783          	lbu	a5,0(a0)
  b0:	fbe5                	bnez	a5,a0 <strcmp+0xc>
  b2:	0005c503          	lbu	a0,0(a1)
  b6:	40a7853b          	subw	a0,a5,a0
  ba:	6422                	ld	s0,8(sp)
  bc:	0141                	addi	sp,sp,16
  be:	8082                	ret

00000000000000c0 <strlen>:
  c0:	1141                	addi	sp,sp,-16
  c2:	e422                	sd	s0,8(sp)
  c4:	0800                	addi	s0,sp,16
  c6:	00054783          	lbu	a5,0(a0)
  ca:	cf91                	beqz	a5,e6 <strlen+0x26>
  cc:	0505                	addi	a0,a0,1
  ce:	87aa                	mv	a5,a0
  d0:	4685                	li	a3,1
  d2:	9e89                	subw	a3,a3,a0
  d4:	00f6853b          	addw	a0,a3,a5
  d8:	0785                	addi	a5,a5,1
  da:	fff7c703          	lbu	a4,-1(a5)
  de:	fb7d                	bnez	a4,d4 <strlen+0x14>
  e0:	6422                	ld	s0,8(sp)
  e2:	0141                	addi	sp,sp,16
  e4:	8082                	ret
  e6:	4501                	li	a0,0
  e8:	bfe5                	j	e0 <strlen+0x20>

00000000000000ea <memset>:
  ea:	1141                	addi	sp,sp,-16
  ec:	e422                	sd	s0,8(sp)
  ee:	0800                	addi	s0,sp,16
  f0:	ca19                	beqz	a2,106 <memset+0x1c>
  f2:	87aa                	mv	a5,a0
  f4:	1602                	slli	a2,a2,0x20
  f6:	9201                	srli	a2,a2,0x20
  f8:	00a60733          	add	a4,a2,a0
  fc:	00b78023          	sb	a1,0(a5)
 100:	0785                	addi	a5,a5,1
 102:	fee79de3          	bne	a5,a4,fc <memset+0x12>
 106:	6422                	ld	s0,8(sp)
 108:	0141                	addi	sp,sp,16
 10a:	8082                	ret

000000000000010c <strchr>:
 10c:	1141                	addi	sp,sp,-16
 10e:	e422                	sd	s0,8(sp)
 110:	0800                	addi	s0,sp,16
 112:	00054783          	lbu	a5,0(a0)
 116:	cb99                	beqz	a5,12c <strchr+0x20>
 118:	00f58763          	beq	a1,a5,126 <strchr+0x1a>
 11c:	0505                	addi	a0,a0,1
 11e:	00054783          	lbu	a5,0(a0)
 122:	fbfd                	bnez	a5,118 <strchr+0xc>
 124:	4501                	li	a0,0
 126:	6422                	ld	s0,8(sp)
 128:	0141                	addi	sp,sp,16
 12a:	8082                	ret
 12c:	4501                	li	a0,0
 12e:	bfe5                	j	126 <strchr+0x1a>

0000000000000130 <gets>:
 130:	711d                	addi	sp,sp,-96
 132:	ec86                	sd	ra,88(sp)
 134:	e8a2                	sd	s0,80(sp)
 136:	e4a6                	sd	s1,72(sp)
 138:	e0ca                	sd	s2,64(sp)
 13a:	fc4e                	sd	s3,56(sp)
 13c:	f852                	sd	s4,48(sp)
 13e:	f456                	sd	s5,40(sp)
 140:	f05a                	sd	s6,32(sp)
 142:	ec5e                	sd	s7,24(sp)
 144:	1080                	addi	s0,sp,96
 146:	8baa                	mv	s7,a0
 148:	8a2e                	mv	s4,a1
 14a:	892a                	mv	s2,a0
 14c:	4481                	li	s1,0
 14e:	4aa9                	li	s5,10
 150:	4b35                	li	s6,13
 152:	89a6                	mv	s3,s1
 154:	2485                	addiw	s1,s1,1
 156:	0344d863          	bge	s1,s4,186 <gets+0x56>
 15a:	4605                	li	a2,1
 15c:	faf40593          	addi	a1,s0,-81
 160:	4501                	li	a0,0
 162:	00000097          	auipc	ra,0x0
 166:	19c080e7          	jalr	412(ra) # 2fe <read>
 16a:	00a05e63          	blez	a0,186 <gets+0x56>
 16e:	faf44783          	lbu	a5,-81(s0)
 172:	00f90023          	sb	a5,0(s2)
 176:	01578763          	beq	a5,s5,184 <gets+0x54>
 17a:	0905                	addi	s2,s2,1
 17c:	fd679be3          	bne	a5,s6,152 <gets+0x22>
 180:	89a6                	mv	s3,s1
 182:	a011                	j	186 <gets+0x56>
 184:	89a6                	mv	s3,s1
 186:	99de                	add	s3,s3,s7
 188:	00098023          	sb	zero,0(s3)
 18c:	855e                	mv	a0,s7
 18e:	60e6                	ld	ra,88(sp)
 190:	6446                	ld	s0,80(sp)
 192:	64a6                	ld	s1,72(sp)
 194:	6906                	ld	s2,64(sp)
 196:	79e2                	ld	s3,56(sp)
 198:	7a42                	ld	s4,48(sp)
 19a:	7aa2                	ld	s5,40(sp)
 19c:	7b02                	ld	s6,32(sp)
 19e:	6be2                	ld	s7,24(sp)
 1a0:	6125                	addi	sp,sp,96
 1a2:	8082                	ret

00000000000001a4 <stat>:
 1a4:	1101                	addi	sp,sp,-32
 1a6:	ec06                	sd	ra,24(sp)
 1a8:	e822                	sd	s0,16(sp)
 1aa:	e426                	sd	s1,8(sp)
 1ac:	e04a                	sd	s2,0(sp)
 1ae:	1000                	addi	s0,sp,32
 1b0:	892e                	mv	s2,a1
 1b2:	4581                	li	a1,0
 1b4:	00000097          	auipc	ra,0x0
 1b8:	172080e7          	jalr	370(ra) # 326 <open>
 1bc:	02054563          	bltz	a0,1e6 <stat+0x42>
 1c0:	84aa                	mv	s1,a0
 1c2:	85ca                	mv	a1,s2
 1c4:	00000097          	auipc	ra,0x0
 1c8:	17a080e7          	jalr	378(ra) # 33e <fstat>
 1cc:	892a                	mv	s2,a0
 1ce:	8526                	mv	a0,s1
 1d0:	00000097          	auipc	ra,0x0
 1d4:	13e080e7          	jalr	318(ra) # 30e <close>
 1d8:	854a                	mv	a0,s2
 1da:	60e2                	ld	ra,24(sp)
 1dc:	6442                	ld	s0,16(sp)
 1de:	64a2                	ld	s1,8(sp)
 1e0:	6902                	ld	s2,0(sp)
 1e2:	6105                	addi	sp,sp,32
 1e4:	8082                	ret
 1e6:	597d                	li	s2,-1
 1e8:	bfc5                	j	1d8 <stat+0x34>

00000000000001ea <atoi>:
 1ea:	1141                	addi	sp,sp,-16
 1ec:	e422                	sd	s0,8(sp)
 1ee:	0800                	addi	s0,sp,16
 1f0:	00054603          	lbu	a2,0(a0)
 1f4:	fd06079b          	addiw	a5,a2,-48
 1f8:	0ff7f793          	zext.b	a5,a5
 1fc:	4725                	li	a4,9
 1fe:	02f76963          	bltu	a4,a5,230 <atoi+0x46>
 202:	86aa                	mv	a3,a0
 204:	4501                	li	a0,0
 206:	45a5                	li	a1,9
 208:	0685                	addi	a3,a3,1
 20a:	0025179b          	slliw	a5,a0,0x2
 20e:	9fa9                	addw	a5,a5,a0
 210:	0017979b          	slliw	a5,a5,0x1
 214:	9fb1                	addw	a5,a5,a2
 216:	fd07851b          	addiw	a0,a5,-48
 21a:	0006c603          	lbu	a2,0(a3)
 21e:	fd06071b          	addiw	a4,a2,-48
 222:	0ff77713          	zext.b	a4,a4
 226:	fee5f1e3          	bgeu	a1,a4,208 <atoi+0x1e>
 22a:	6422                	ld	s0,8(sp)
 22c:	0141                	addi	sp,sp,16
 22e:	8082                	ret
 230:	4501                	li	a0,0
 232:	bfe5                	j	22a <atoi+0x40>

0000000000000234 <memmove>:
 234:	1141                	addi	sp,sp,-16
 236:	e422                	sd	s0,8(sp)
 238:	0800                	addi	s0,sp,16
 23a:	02b57463          	bgeu	a0,a1,262 <memmove+0x2e>
 23e:	00c05f63          	blez	a2,25c <memmove+0x28>
 242:	1602                	slli	a2,a2,0x20
 244:	9201                	srli	a2,a2,0x20
 246:	00c507b3          	add	a5,a0,a2
 24a:	872a                	mv	a4,a0
 24c:	0585                	addi	a1,a1,1
 24e:	0705                	addi	a4,a4,1
 250:	fff5c683          	lbu	a3,-1(a1)
 254:	fed70fa3          	sb	a3,-1(a4)
 258:	fee79ae3          	bne	a5,a4,24c <memmove+0x18>
 25c:	6422                	ld	s0,8(sp)
 25e:	0141                	addi	sp,sp,16
 260:	8082                	ret
 262:	00c50733          	add	a4,a0,a2
 266:	95b2                	add	a1,a1,a2
 268:	fec05ae3          	blez	a2,25c <memmove+0x28>
 26c:	fff6079b          	addiw	a5,a2,-1
 270:	1782                	slli	a5,a5,0x20
 272:	9381                	srli	a5,a5,0x20
 274:	fff7c793          	not	a5,a5
 278:	97ba                	add	a5,a5,a4
 27a:	15fd                	addi	a1,a1,-1
 27c:	177d                	addi	a4,a4,-1
 27e:	0005c683          	lbu	a3,0(a1)
 282:	00d70023          	sb	a3,0(a4)
 286:	fee79ae3          	bne	a5,a4,27a <memmove+0x46>
 28a:	bfc9                	j	25c <memmove+0x28>

000000000000028c <memcmp>:
 28c:	1141                	addi	sp,sp,-16
 28e:	e422                	sd	s0,8(sp)
 290:	0800                	addi	s0,sp,16
 292:	ca05                	beqz	a2,2c2 <memcmp+0x36>
 294:	fff6069b          	addiw	a3,a2,-1
 298:	1682                	slli	a3,a3,0x20
 29a:	9281                	srli	a3,a3,0x20
 29c:	0685                	addi	a3,a3,1
 29e:	96aa                	add	a3,a3,a0
 2a0:	00054783          	lbu	a5,0(a0)
 2a4:	0005c703          	lbu	a4,0(a1)
 2a8:	00e79863          	bne	a5,a4,2b8 <memcmp+0x2c>
 2ac:	0505                	addi	a0,a0,1
 2ae:	0585                	addi	a1,a1,1
 2b0:	fed518e3          	bne	a0,a3,2a0 <memcmp+0x14>
 2b4:	4501                	li	a0,0
 2b6:	a019                	j	2bc <memcmp+0x30>
 2b8:	40e7853b          	subw	a0,a5,a4
 2bc:	6422                	ld	s0,8(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret
 2c2:	4501                	li	a0,0
 2c4:	bfe5                	j	2bc <memcmp+0x30>

00000000000002c6 <memcpy>:
 2c6:	1141                	addi	sp,sp,-16
 2c8:	e406                	sd	ra,8(sp)
 2ca:	e022                	sd	s0,0(sp)
 2cc:	0800                	addi	s0,sp,16
 2ce:	00000097          	auipc	ra,0x0
 2d2:	f66080e7          	jalr	-154(ra) # 234 <memmove>
 2d6:	60a2                	ld	ra,8(sp)
 2d8:	6402                	ld	s0,0(sp)
 2da:	0141                	addi	sp,sp,16
 2dc:	8082                	ret

00000000000002de <fork>:
 2de:	4885                	li	a7,1
 2e0:	00000073          	ecall
 2e4:	8082                	ret

00000000000002e6 <exit>:
 2e6:	4889                	li	a7,2
 2e8:	00000073          	ecall
 2ec:	8082                	ret

00000000000002ee <wait>:
 2ee:	488d                	li	a7,3
 2f0:	00000073          	ecall
 2f4:	8082                	ret

00000000000002f6 <pipe>:
 2f6:	4891                	li	a7,4
 2f8:	00000073          	ecall
 2fc:	8082                	ret

00000000000002fe <read>:
 2fe:	4895                	li	a7,5
 300:	00000073          	ecall
 304:	8082                	ret

0000000000000306 <write>:
 306:	48c1                	li	a7,16
 308:	00000073          	ecall
 30c:	8082                	ret

000000000000030e <close>:
 30e:	48d5                	li	a7,21
 310:	00000073          	ecall
 314:	8082                	ret

0000000000000316 <kill>:
 316:	4899                	li	a7,6
 318:	00000073          	ecall
 31c:	8082                	ret

000000000000031e <exec>:
 31e:	489d                	li	a7,7
 320:	00000073          	ecall
 324:	8082                	ret

0000000000000326 <open>:
 326:	48bd                	li	a7,15
 328:	00000073          	ecall
 32c:	8082                	ret

000000000000032e <mknod>:
 32e:	48c5                	li	a7,17
 330:	00000073          	ecall
 334:	8082                	ret

0000000000000336 <unlink>:
 336:	48c9                	li	a7,18
 338:	00000073          	ecall
 33c:	8082                	ret

000000000000033e <fstat>:
 33e:	48a1                	li	a7,8
 340:	00000073          	ecall
 344:	8082                	ret

0000000000000346 <link>:
 346:	48cd                	li	a7,19
 348:	00000073          	ecall
 34c:	8082                	ret

000000000000034e <mkdir>:
 34e:	48d1                	li	a7,20
 350:	00000073          	ecall
 354:	8082                	ret

0000000000000356 <chdir>:
 356:	48a5                	li	a7,9
 358:	00000073          	ecall
 35c:	8082                	ret

000000000000035e <dup>:
 35e:	48a9                	li	a7,10
 360:	00000073          	ecall
 364:	8082                	ret

0000000000000366 <getpid>:
 366:	48ad                	li	a7,11
 368:	00000073          	ecall
 36c:	8082                	ret

000000000000036e <sbrk>:
 36e:	48b1                	li	a7,12
 370:	00000073          	ecall
 374:	8082                	ret

0000000000000376 <sleep>:
 376:	48b5                	li	a7,13
 378:	00000073          	ecall
 37c:	8082                	ret

000000000000037e <uptime>:
 37e:	48b9                	li	a7,14
 380:	00000073          	ecall
 384:	8082                	ret

0000000000000386 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 386:	1101                	addi	sp,sp,-32
 388:	ec06                	sd	ra,24(sp)
 38a:	e822                	sd	s0,16(sp)
 38c:	1000                	addi	s0,sp,32
 38e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 392:	4605                	li	a2,1
 394:	fef40593          	addi	a1,s0,-17
 398:	00000097          	auipc	ra,0x0
 39c:	f6e080e7          	jalr	-146(ra) # 306 <write>
}
 3a0:	60e2                	ld	ra,24(sp)
 3a2:	6442                	ld	s0,16(sp)
 3a4:	6105                	addi	sp,sp,32
 3a6:	8082                	ret

00000000000003a8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3a8:	7139                	addi	sp,sp,-64
 3aa:	fc06                	sd	ra,56(sp)
 3ac:	f822                	sd	s0,48(sp)
 3ae:	f426                	sd	s1,40(sp)
 3b0:	f04a                	sd	s2,32(sp)
 3b2:	ec4e                	sd	s3,24(sp)
 3b4:	0080                	addi	s0,sp,64
 3b6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3b8:	c299                	beqz	a3,3be <printint+0x16>
 3ba:	0805c963          	bltz	a1,44c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3be:	2581                	sext.w	a1,a1
  neg = 0;
 3c0:	4881                	li	a7,0
 3c2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3c6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3c8:	2601                	sext.w	a2,a2
 3ca:	00000517          	auipc	a0,0x0
 3ce:	55e50513          	addi	a0,a0,1374 # 928 <digits>
 3d2:	883a                	mv	a6,a4
 3d4:	2705                	addiw	a4,a4,1
 3d6:	02c5f7bb          	remuw	a5,a1,a2
 3da:	1782                	slli	a5,a5,0x20
 3dc:	9381                	srli	a5,a5,0x20
 3de:	97aa                	add	a5,a5,a0
 3e0:	0007c783          	lbu	a5,0(a5)
 3e4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3e8:	0005879b          	sext.w	a5,a1
 3ec:	02c5d5bb          	divuw	a1,a1,a2
 3f0:	0685                	addi	a3,a3,1
 3f2:	fec7f0e3          	bgeu	a5,a2,3d2 <printint+0x2a>
  if(neg)
 3f6:	00088c63          	beqz	a7,40e <printint+0x66>
    buf[i++] = '-';
 3fa:	fd070793          	addi	a5,a4,-48
 3fe:	00878733          	add	a4,a5,s0
 402:	02d00793          	li	a5,45
 406:	fef70823          	sb	a5,-16(a4)
 40a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 40e:	02e05863          	blez	a4,43e <printint+0x96>
 412:	fc040793          	addi	a5,s0,-64
 416:	00e78933          	add	s2,a5,a4
 41a:	fff78993          	addi	s3,a5,-1
 41e:	99ba                	add	s3,s3,a4
 420:	377d                	addiw	a4,a4,-1
 422:	1702                	slli	a4,a4,0x20
 424:	9301                	srli	a4,a4,0x20
 426:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 42a:	fff94583          	lbu	a1,-1(s2)
 42e:	8526                	mv	a0,s1
 430:	00000097          	auipc	ra,0x0
 434:	f56080e7          	jalr	-170(ra) # 386 <putc>
  while(--i >= 0)
 438:	197d                	addi	s2,s2,-1
 43a:	ff3918e3          	bne	s2,s3,42a <printint+0x82>
}
 43e:	70e2                	ld	ra,56(sp)
 440:	7442                	ld	s0,48(sp)
 442:	74a2                	ld	s1,40(sp)
 444:	7902                	ld	s2,32(sp)
 446:	69e2                	ld	s3,24(sp)
 448:	6121                	addi	sp,sp,64
 44a:	8082                	ret
    x = -xx;
 44c:	40b005bb          	negw	a1,a1
    neg = 1;
 450:	4885                	li	a7,1
    x = -xx;
 452:	bf85                	j	3c2 <printint+0x1a>

0000000000000454 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 454:	7119                	addi	sp,sp,-128
 456:	fc86                	sd	ra,120(sp)
 458:	f8a2                	sd	s0,112(sp)
 45a:	f4a6                	sd	s1,104(sp)
 45c:	f0ca                	sd	s2,96(sp)
 45e:	ecce                	sd	s3,88(sp)
 460:	e8d2                	sd	s4,80(sp)
 462:	e4d6                	sd	s5,72(sp)
 464:	e0da                	sd	s6,64(sp)
 466:	fc5e                	sd	s7,56(sp)
 468:	f862                	sd	s8,48(sp)
 46a:	f466                	sd	s9,40(sp)
 46c:	f06a                	sd	s10,32(sp)
 46e:	ec6e                	sd	s11,24(sp)
 470:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 472:	0005c903          	lbu	s2,0(a1)
 476:	18090f63          	beqz	s2,614 <vprintf+0x1c0>
 47a:	8aaa                	mv	s5,a0
 47c:	8b32                	mv	s6,a2
 47e:	00158493          	addi	s1,a1,1
  state = 0;
 482:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 484:	02500a13          	li	s4,37
 488:	4c55                	li	s8,21
 48a:	00000c97          	auipc	s9,0x0
 48e:	446c8c93          	addi	s9,s9,1094 # 8d0 <l_free+0x4e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 492:	02800d93          	li	s11,40
  putc(fd, 'x');
 496:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 498:	00000b97          	auipc	s7,0x0
 49c:	490b8b93          	addi	s7,s7,1168 # 928 <digits>
 4a0:	a839                	j	4be <vprintf+0x6a>
        putc(fd, c);
 4a2:	85ca                	mv	a1,s2
 4a4:	8556                	mv	a0,s5
 4a6:	00000097          	auipc	ra,0x0
 4aa:	ee0080e7          	jalr	-288(ra) # 386 <putc>
 4ae:	a019                	j	4b4 <vprintf+0x60>
    } else if(state == '%'){
 4b0:	01498d63          	beq	s3,s4,4ca <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 4b4:	0485                	addi	s1,s1,1
 4b6:	fff4c903          	lbu	s2,-1(s1)
 4ba:	14090d63          	beqz	s2,614 <vprintf+0x1c0>
    if(state == 0){
 4be:	fe0999e3          	bnez	s3,4b0 <vprintf+0x5c>
      if(c == '%'){
 4c2:	ff4910e3          	bne	s2,s4,4a2 <vprintf+0x4e>
        state = '%';
 4c6:	89d2                	mv	s3,s4
 4c8:	b7f5                	j	4b4 <vprintf+0x60>
      if(c == 'd'){
 4ca:	11490c63          	beq	s2,s4,5e2 <vprintf+0x18e>
 4ce:	f9d9079b          	addiw	a5,s2,-99
 4d2:	0ff7f793          	zext.b	a5,a5
 4d6:	10fc6e63          	bltu	s8,a5,5f2 <vprintf+0x19e>
 4da:	f9d9079b          	addiw	a5,s2,-99
 4de:	0ff7f713          	zext.b	a4,a5
 4e2:	10ec6863          	bltu	s8,a4,5f2 <vprintf+0x19e>
 4e6:	00271793          	slli	a5,a4,0x2
 4ea:	97e6                	add	a5,a5,s9
 4ec:	439c                	lw	a5,0(a5)
 4ee:	97e6                	add	a5,a5,s9
 4f0:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4f2:	008b0913          	addi	s2,s6,8
 4f6:	4685                	li	a3,1
 4f8:	4629                	li	a2,10
 4fa:	000b2583          	lw	a1,0(s6)
 4fe:	8556                	mv	a0,s5
 500:	00000097          	auipc	ra,0x0
 504:	ea8080e7          	jalr	-344(ra) # 3a8 <printint>
 508:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 50a:	4981                	li	s3,0
 50c:	b765                	j	4b4 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 50e:	008b0913          	addi	s2,s6,8
 512:	4681                	li	a3,0
 514:	4629                	li	a2,10
 516:	000b2583          	lw	a1,0(s6)
 51a:	8556                	mv	a0,s5
 51c:	00000097          	auipc	ra,0x0
 520:	e8c080e7          	jalr	-372(ra) # 3a8 <printint>
 524:	8b4a                	mv	s6,s2
      state = 0;
 526:	4981                	li	s3,0
 528:	b771                	j	4b4 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 52a:	008b0913          	addi	s2,s6,8
 52e:	4681                	li	a3,0
 530:	866a                	mv	a2,s10
 532:	000b2583          	lw	a1,0(s6)
 536:	8556                	mv	a0,s5
 538:	00000097          	auipc	ra,0x0
 53c:	e70080e7          	jalr	-400(ra) # 3a8 <printint>
 540:	8b4a                	mv	s6,s2
      state = 0;
 542:	4981                	li	s3,0
 544:	bf85                	j	4b4 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 546:	008b0793          	addi	a5,s6,8
 54a:	f8f43423          	sd	a5,-120(s0)
 54e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 552:	03000593          	li	a1,48
 556:	8556                	mv	a0,s5
 558:	00000097          	auipc	ra,0x0
 55c:	e2e080e7          	jalr	-466(ra) # 386 <putc>
  putc(fd, 'x');
 560:	07800593          	li	a1,120
 564:	8556                	mv	a0,s5
 566:	00000097          	auipc	ra,0x0
 56a:	e20080e7          	jalr	-480(ra) # 386 <putc>
 56e:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 570:	03c9d793          	srli	a5,s3,0x3c
 574:	97de                	add	a5,a5,s7
 576:	0007c583          	lbu	a1,0(a5)
 57a:	8556                	mv	a0,s5
 57c:	00000097          	auipc	ra,0x0
 580:	e0a080e7          	jalr	-502(ra) # 386 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 584:	0992                	slli	s3,s3,0x4
 586:	397d                	addiw	s2,s2,-1
 588:	fe0914e3          	bnez	s2,570 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 58c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 590:	4981                	li	s3,0
 592:	b70d                	j	4b4 <vprintf+0x60>
        s = va_arg(ap, char*);
 594:	008b0913          	addi	s2,s6,8
 598:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 59c:	02098163          	beqz	s3,5be <vprintf+0x16a>
        while(*s != 0){
 5a0:	0009c583          	lbu	a1,0(s3)
 5a4:	c5ad                	beqz	a1,60e <vprintf+0x1ba>
          putc(fd, *s);
 5a6:	8556                	mv	a0,s5
 5a8:	00000097          	auipc	ra,0x0
 5ac:	dde080e7          	jalr	-546(ra) # 386 <putc>
          s++;
 5b0:	0985                	addi	s3,s3,1
        while(*s != 0){
 5b2:	0009c583          	lbu	a1,0(s3)
 5b6:	f9e5                	bnez	a1,5a6 <vprintf+0x152>
        s = va_arg(ap, char*);
 5b8:	8b4a                	mv	s6,s2
      state = 0;
 5ba:	4981                	li	s3,0
 5bc:	bde5                	j	4b4 <vprintf+0x60>
          s = "(null)";
 5be:	00000997          	auipc	s3,0x0
 5c2:	30a98993          	addi	s3,s3,778 # 8c8 <l_free+0x46>
        while(*s != 0){
 5c6:	85ee                	mv	a1,s11
 5c8:	bff9                	j	5a6 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 5ca:	008b0913          	addi	s2,s6,8
 5ce:	000b4583          	lbu	a1,0(s6)
 5d2:	8556                	mv	a0,s5
 5d4:	00000097          	auipc	ra,0x0
 5d8:	db2080e7          	jalr	-590(ra) # 386 <putc>
 5dc:	8b4a                	mv	s6,s2
      state = 0;
 5de:	4981                	li	s3,0
 5e0:	bdd1                	j	4b4 <vprintf+0x60>
        putc(fd, c);
 5e2:	85d2                	mv	a1,s4
 5e4:	8556                	mv	a0,s5
 5e6:	00000097          	auipc	ra,0x0
 5ea:	da0080e7          	jalr	-608(ra) # 386 <putc>
      state = 0;
 5ee:	4981                	li	s3,0
 5f0:	b5d1                	j	4b4 <vprintf+0x60>
        putc(fd, '%');
 5f2:	85d2                	mv	a1,s4
 5f4:	8556                	mv	a0,s5
 5f6:	00000097          	auipc	ra,0x0
 5fa:	d90080e7          	jalr	-624(ra) # 386 <putc>
        putc(fd, c);
 5fe:	85ca                	mv	a1,s2
 600:	8556                	mv	a0,s5
 602:	00000097          	auipc	ra,0x0
 606:	d84080e7          	jalr	-636(ra) # 386 <putc>
      state = 0;
 60a:	4981                	li	s3,0
 60c:	b565                	j	4b4 <vprintf+0x60>
        s = va_arg(ap, char*);
 60e:	8b4a                	mv	s6,s2
      state = 0;
 610:	4981                	li	s3,0
 612:	b54d                	j	4b4 <vprintf+0x60>
    }
  }
}
 614:	70e6                	ld	ra,120(sp)
 616:	7446                	ld	s0,112(sp)
 618:	74a6                	ld	s1,104(sp)
 61a:	7906                	ld	s2,96(sp)
 61c:	69e6                	ld	s3,88(sp)
 61e:	6a46                	ld	s4,80(sp)
 620:	6aa6                	ld	s5,72(sp)
 622:	6b06                	ld	s6,64(sp)
 624:	7be2                	ld	s7,56(sp)
 626:	7c42                	ld	s8,48(sp)
 628:	7ca2                	ld	s9,40(sp)
 62a:	7d02                	ld	s10,32(sp)
 62c:	6de2                	ld	s11,24(sp)
 62e:	6109                	addi	sp,sp,128
 630:	8082                	ret

0000000000000632 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 632:	715d                	addi	sp,sp,-80
 634:	ec06                	sd	ra,24(sp)
 636:	e822                	sd	s0,16(sp)
 638:	1000                	addi	s0,sp,32
 63a:	e010                	sd	a2,0(s0)
 63c:	e414                	sd	a3,8(s0)
 63e:	e818                	sd	a4,16(s0)
 640:	ec1c                	sd	a5,24(s0)
 642:	03043023          	sd	a6,32(s0)
 646:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 64a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 64e:	8622                	mv	a2,s0
 650:	00000097          	auipc	ra,0x0
 654:	e04080e7          	jalr	-508(ra) # 454 <vprintf>
}
 658:	60e2                	ld	ra,24(sp)
 65a:	6442                	ld	s0,16(sp)
 65c:	6161                	addi	sp,sp,80
 65e:	8082                	ret

0000000000000660 <printf>:

void
printf(const char *fmt, ...)
{
 660:	711d                	addi	sp,sp,-96
 662:	ec06                	sd	ra,24(sp)
 664:	e822                	sd	s0,16(sp)
 666:	1000                	addi	s0,sp,32
 668:	e40c                	sd	a1,8(s0)
 66a:	e810                	sd	a2,16(s0)
 66c:	ec14                	sd	a3,24(s0)
 66e:	f018                	sd	a4,32(s0)
 670:	f41c                	sd	a5,40(s0)
 672:	03043823          	sd	a6,48(s0)
 676:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 67a:	00840613          	addi	a2,s0,8
 67e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 682:	85aa                	mv	a1,a0
 684:	4505                	li	a0,1
 686:	00000097          	auipc	ra,0x0
 68a:	dce080e7          	jalr	-562(ra) # 454 <vprintf>
}
 68e:	60e2                	ld	ra,24(sp)
 690:	6442                	ld	s0,16(sp)
 692:	6125                	addi	sp,sp,96
 694:	8082                	ret

0000000000000696 <free>:
 696:	1141                	addi	sp,sp,-16
 698:	e422                	sd	s0,8(sp)
 69a:	0800                	addi	s0,sp,16
 69c:	ff050693          	addi	a3,a0,-16
 6a0:	00000797          	auipc	a5,0x0
 6a4:	2b07b783          	ld	a5,688(a5) # 950 <freep>
 6a8:	a805                	j	6d8 <free+0x42>
 6aa:	4618                	lw	a4,8(a2)
 6ac:	9db9                	addw	a1,a1,a4
 6ae:	feb52c23          	sw	a1,-8(a0)
 6b2:	6398                	ld	a4,0(a5)
 6b4:	6318                	ld	a4,0(a4)
 6b6:	fee53823          	sd	a4,-16(a0)
 6ba:	a091                	j	6fe <free+0x68>
 6bc:	ff852703          	lw	a4,-8(a0)
 6c0:	9e39                	addw	a2,a2,a4
 6c2:	c790                	sw	a2,8(a5)
 6c4:	ff053703          	ld	a4,-16(a0)
 6c8:	e398                	sd	a4,0(a5)
 6ca:	a099                	j	710 <free+0x7a>
 6cc:	6398                	ld	a4,0(a5)
 6ce:	00e7e463          	bltu	a5,a4,6d6 <free+0x40>
 6d2:	00e6ea63          	bltu	a3,a4,6e6 <free+0x50>
 6d6:	87ba                	mv	a5,a4
 6d8:	fed7fae3          	bgeu	a5,a3,6cc <free+0x36>
 6dc:	6398                	ld	a4,0(a5)
 6de:	00e6e463          	bltu	a3,a4,6e6 <free+0x50>
 6e2:	fee7eae3          	bltu	a5,a4,6d6 <free+0x40>
 6e6:	ff852583          	lw	a1,-8(a0)
 6ea:	6390                	ld	a2,0(a5)
 6ec:	02059713          	slli	a4,a1,0x20
 6f0:	9301                	srli	a4,a4,0x20
 6f2:	0712                	slli	a4,a4,0x4
 6f4:	9736                	add	a4,a4,a3
 6f6:	fae60ae3          	beq	a2,a4,6aa <free+0x14>
 6fa:	fec53823          	sd	a2,-16(a0)
 6fe:	4790                	lw	a2,8(a5)
 700:	02061713          	slli	a4,a2,0x20
 704:	9301                	srli	a4,a4,0x20
 706:	0712                	slli	a4,a4,0x4
 708:	973e                	add	a4,a4,a5
 70a:	fae689e3          	beq	a3,a4,6bc <free+0x26>
 70e:	e394                	sd	a3,0(a5)
 710:	00000717          	auipc	a4,0x0
 714:	24f73023          	sd	a5,576(a4) # 950 <freep>
 718:	6422                	ld	s0,8(sp)
 71a:	0141                	addi	sp,sp,16
 71c:	8082                	ret

000000000000071e <malloc>:
 71e:	7139                	addi	sp,sp,-64
 720:	fc06                	sd	ra,56(sp)
 722:	f822                	sd	s0,48(sp)
 724:	f426                	sd	s1,40(sp)
 726:	f04a                	sd	s2,32(sp)
 728:	ec4e                	sd	s3,24(sp)
 72a:	e852                	sd	s4,16(sp)
 72c:	e456                	sd	s5,8(sp)
 72e:	e05a                	sd	s6,0(sp)
 730:	0080                	addi	s0,sp,64
 732:	02051493          	slli	s1,a0,0x20
 736:	9081                	srli	s1,s1,0x20
 738:	04bd                	addi	s1,s1,15
 73a:	8091                	srli	s1,s1,0x4
 73c:	0014899b          	addiw	s3,s1,1
 740:	0485                	addi	s1,s1,1
 742:	00000517          	auipc	a0,0x0
 746:	20e53503          	ld	a0,526(a0) # 950 <freep>
 74a:	c515                	beqz	a0,776 <malloc+0x58>
 74c:	611c                	ld	a5,0(a0)
 74e:	4798                	lw	a4,8(a5)
 750:	02977f63          	bgeu	a4,s1,78e <malloc+0x70>
 754:	8a4e                	mv	s4,s3
 756:	0009871b          	sext.w	a4,s3
 75a:	6685                	lui	a3,0x1
 75c:	00d77363          	bgeu	a4,a3,762 <malloc+0x44>
 760:	6a05                	lui	s4,0x1
 762:	000a0b1b          	sext.w	s6,s4
 766:	004a1a1b          	slliw	s4,s4,0x4
 76a:	00000917          	auipc	s2,0x0
 76e:	1e690913          	addi	s2,s2,486 # 950 <freep>
 772:	5afd                	li	s5,-1
 774:	a88d                	j	7e6 <malloc+0xc8>
 776:	00000797          	auipc	a5,0x0
 77a:	1e278793          	addi	a5,a5,482 # 958 <base>
 77e:	00000717          	auipc	a4,0x0
 782:	1cf73923          	sd	a5,466(a4) # 950 <freep>
 786:	e39c                	sd	a5,0(a5)
 788:	0007a423          	sw	zero,8(a5)
 78c:	b7e1                	j	754 <malloc+0x36>
 78e:	02e48b63          	beq	s1,a4,7c4 <malloc+0xa6>
 792:	4137073b          	subw	a4,a4,s3
 796:	c798                	sw	a4,8(a5)
 798:	1702                	slli	a4,a4,0x20
 79a:	9301                	srli	a4,a4,0x20
 79c:	0712                	slli	a4,a4,0x4
 79e:	97ba                	add	a5,a5,a4
 7a0:	0137a423          	sw	s3,8(a5)
 7a4:	00000717          	auipc	a4,0x0
 7a8:	1aa73623          	sd	a0,428(a4) # 950 <freep>
 7ac:	01078513          	addi	a0,a5,16
 7b0:	70e2                	ld	ra,56(sp)
 7b2:	7442                	ld	s0,48(sp)
 7b4:	74a2                	ld	s1,40(sp)
 7b6:	7902                	ld	s2,32(sp)
 7b8:	69e2                	ld	s3,24(sp)
 7ba:	6a42                	ld	s4,16(sp)
 7bc:	6aa2                	ld	s5,8(sp)
 7be:	6b02                	ld	s6,0(sp)
 7c0:	6121                	addi	sp,sp,64
 7c2:	8082                	ret
 7c4:	6398                	ld	a4,0(a5)
 7c6:	e118                	sd	a4,0(a0)
 7c8:	bff1                	j	7a4 <malloc+0x86>
 7ca:	01652423          	sw	s6,8(a0)
 7ce:	0541                	addi	a0,a0,16
 7d0:	00000097          	auipc	ra,0x0
 7d4:	ec6080e7          	jalr	-314(ra) # 696 <free>
 7d8:	00093503          	ld	a0,0(s2)
 7dc:	d971                	beqz	a0,7b0 <malloc+0x92>
 7de:	611c                	ld	a5,0(a0)
 7e0:	4798                	lw	a4,8(a5)
 7e2:	fa9776e3          	bgeu	a4,s1,78e <malloc+0x70>
 7e6:	00093703          	ld	a4,0(s2)
 7ea:	853e                	mv	a0,a5
 7ec:	fef719e3          	bne	a4,a5,7de <malloc+0xc0>
 7f0:	8552                	mv	a0,s4
 7f2:	00000097          	auipc	ra,0x0
 7f6:	b7c080e7          	jalr	-1156(ra) # 36e <sbrk>
 7fa:	fd5518e3          	bne	a0,s5,7ca <malloc+0xac>
 7fe:	4501                	li	a0,0
 800:	bf45                	j	7b0 <malloc+0x92>

0000000000000802 <mem_init>:
 802:	1141                	addi	sp,sp,-16
 804:	e406                	sd	ra,8(sp)
 806:	e022                	sd	s0,0(sp)
 808:	0800                	addi	s0,sp,16
 80a:	6505                	lui	a0,0x1
 80c:	00000097          	auipc	ra,0x0
 810:	b62080e7          	jalr	-1182(ra) # 36e <sbrk>
 814:	00000797          	auipc	a5,0x0
 818:	12a7ba23          	sd	a0,308(a5) # 948 <alloc>
 81c:	00850793          	addi	a5,a0,8 # 1008 <__BSS_END__+0x6a0>
 820:	e11c                	sd	a5,0(a0)
 822:	60a2                	ld	ra,8(sp)
 824:	6402                	ld	s0,0(sp)
 826:	0141                	addi	sp,sp,16
 828:	8082                	ret

000000000000082a <l_alloc>:
 82a:	1101                	addi	sp,sp,-32
 82c:	ec06                	sd	ra,24(sp)
 82e:	e822                	sd	s0,16(sp)
 830:	e426                	sd	s1,8(sp)
 832:	1000                	addi	s0,sp,32
 834:	84aa                	mv	s1,a0
 836:	00000797          	auipc	a5,0x0
 83a:	10a7a783          	lw	a5,266(a5) # 940 <if_init>
 83e:	c795                	beqz	a5,86a <l_alloc+0x40>
 840:	00000717          	auipc	a4,0x0
 844:	10873703          	ld	a4,264(a4) # 948 <alloc>
 848:	6308                	ld	a0,0(a4)
 84a:	40e506b3          	sub	a3,a0,a4
 84e:	6785                	lui	a5,0x1
 850:	37e1                	addiw	a5,a5,-8
 852:	9f95                	subw	a5,a5,a3
 854:	02f4f563          	bgeu	s1,a5,87e <l_alloc+0x54>
 858:	1482                	slli	s1,s1,0x20
 85a:	9081                	srli	s1,s1,0x20
 85c:	94aa                	add	s1,s1,a0
 85e:	e304                	sd	s1,0(a4)
 860:	60e2                	ld	ra,24(sp)
 862:	6442                	ld	s0,16(sp)
 864:	64a2                	ld	s1,8(sp)
 866:	6105                	addi	sp,sp,32
 868:	8082                	ret
 86a:	00000097          	auipc	ra,0x0
 86e:	f98080e7          	jalr	-104(ra) # 802 <mem_init>
 872:	4785                	li	a5,1
 874:	00000717          	auipc	a4,0x0
 878:	0cf72623          	sw	a5,204(a4) # 940 <if_init>
 87c:	b7d1                	j	840 <l_alloc+0x16>
 87e:	4501                	li	a0,0
 880:	b7c5                	j	860 <l_alloc+0x36>

0000000000000882 <l_free>:
 882:	1141                	addi	sp,sp,-16
 884:	e422                	sd	s0,8(sp)
 886:	0800                	addi	s0,sp,16
 888:	6422                	ld	s0,8(sp)
 88a:	0141                	addi	sp,sp,16
 88c:	8082                	ret
