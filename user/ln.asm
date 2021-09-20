
user/_ln:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	478d                	li	a5,3
   c:	02f50063          	beq	a0,a5,2c <main+0x2c>
  10:	00001597          	auipc	a1,0x1
  14:	86858593          	addi	a1,a1,-1944 # 878 <l_free+0xe>
  18:	4509                	li	a0,2
  1a:	00000097          	auipc	ra,0x0
  1e:	600080e7          	jalr	1536(ra) # 61a <fprintf>
  22:	4505                	li	a0,1
  24:	00000097          	auipc	ra,0x0
  28:	2aa080e7          	jalr	682(ra) # 2ce <exit>
  2c:	84ae                	mv	s1,a1
  2e:	698c                	ld	a1,16(a1)
  30:	6488                	ld	a0,8(s1)
  32:	00000097          	auipc	ra,0x0
  36:	2fc080e7          	jalr	764(ra) # 32e <link>
  3a:	00054763          	bltz	a0,48 <main+0x48>
  3e:	4501                	li	a0,0
  40:	00000097          	auipc	ra,0x0
  44:	28e080e7          	jalr	654(ra) # 2ce <exit>
  48:	6894                	ld	a3,16(s1)
  4a:	6490                	ld	a2,8(s1)
  4c:	00001597          	auipc	a1,0x1
  50:	84458593          	addi	a1,a1,-1980 # 890 <l_free+0x26>
  54:	4509                	li	a0,2
  56:	00000097          	auipc	ra,0x0
  5a:	5c4080e7          	jalr	1476(ra) # 61a <fprintf>
  5e:	b7c5                	j	3e <main+0x3e>

0000000000000060 <strcpy>:
  60:	1141                	addi	sp,sp,-16
  62:	e422                	sd	s0,8(sp)
  64:	0800                	addi	s0,sp,16
  66:	87aa                	mv	a5,a0
  68:	0585                	addi	a1,a1,1
  6a:	0785                	addi	a5,a5,1
  6c:	fff5c703          	lbu	a4,-1(a1)
  70:	fee78fa3          	sb	a4,-1(a5)
  74:	fb75                	bnez	a4,68 <strcpy+0x8>
  76:	6422                	ld	s0,8(sp)
  78:	0141                	addi	sp,sp,16
  7a:	8082                	ret

000000000000007c <strcmp>:
  7c:	1141                	addi	sp,sp,-16
  7e:	e422                	sd	s0,8(sp)
  80:	0800                	addi	s0,sp,16
  82:	00054783          	lbu	a5,0(a0)
  86:	cb91                	beqz	a5,9a <strcmp+0x1e>
  88:	0005c703          	lbu	a4,0(a1)
  8c:	00f71763          	bne	a4,a5,9a <strcmp+0x1e>
  90:	0505                	addi	a0,a0,1
  92:	0585                	addi	a1,a1,1
  94:	00054783          	lbu	a5,0(a0)
  98:	fbe5                	bnez	a5,88 <strcmp+0xc>
  9a:	0005c503          	lbu	a0,0(a1)
  9e:	40a7853b          	subw	a0,a5,a0
  a2:	6422                	ld	s0,8(sp)
  a4:	0141                	addi	sp,sp,16
  a6:	8082                	ret

00000000000000a8 <strlen>:
  a8:	1141                	addi	sp,sp,-16
  aa:	e422                	sd	s0,8(sp)
  ac:	0800                	addi	s0,sp,16
  ae:	00054783          	lbu	a5,0(a0)
  b2:	cf91                	beqz	a5,ce <strlen+0x26>
  b4:	0505                	addi	a0,a0,1
  b6:	87aa                	mv	a5,a0
  b8:	4685                	li	a3,1
  ba:	9e89                	subw	a3,a3,a0
  bc:	00f6853b          	addw	a0,a3,a5
  c0:	0785                	addi	a5,a5,1
  c2:	fff7c703          	lbu	a4,-1(a5)
  c6:	fb7d                	bnez	a4,bc <strlen+0x14>
  c8:	6422                	ld	s0,8(sp)
  ca:	0141                	addi	sp,sp,16
  cc:	8082                	ret
  ce:	4501                	li	a0,0
  d0:	bfe5                	j	c8 <strlen+0x20>

00000000000000d2 <memset>:
  d2:	1141                	addi	sp,sp,-16
  d4:	e422                	sd	s0,8(sp)
  d6:	0800                	addi	s0,sp,16
  d8:	ca19                	beqz	a2,ee <memset+0x1c>
  da:	87aa                	mv	a5,a0
  dc:	1602                	slli	a2,a2,0x20
  de:	9201                	srli	a2,a2,0x20
  e0:	00a60733          	add	a4,a2,a0
  e4:	00b78023          	sb	a1,0(a5)
  e8:	0785                	addi	a5,a5,1
  ea:	fee79de3          	bne	a5,a4,e4 <memset+0x12>
  ee:	6422                	ld	s0,8(sp)
  f0:	0141                	addi	sp,sp,16
  f2:	8082                	ret

00000000000000f4 <strchr>:
  f4:	1141                	addi	sp,sp,-16
  f6:	e422                	sd	s0,8(sp)
  f8:	0800                	addi	s0,sp,16
  fa:	00054783          	lbu	a5,0(a0)
  fe:	cb99                	beqz	a5,114 <strchr+0x20>
 100:	00f58763          	beq	a1,a5,10e <strchr+0x1a>
 104:	0505                	addi	a0,a0,1
 106:	00054783          	lbu	a5,0(a0)
 10a:	fbfd                	bnez	a5,100 <strchr+0xc>
 10c:	4501                	li	a0,0
 10e:	6422                	ld	s0,8(sp)
 110:	0141                	addi	sp,sp,16
 112:	8082                	ret
 114:	4501                	li	a0,0
 116:	bfe5                	j	10e <strchr+0x1a>

0000000000000118 <gets>:
 118:	711d                	addi	sp,sp,-96
 11a:	ec86                	sd	ra,88(sp)
 11c:	e8a2                	sd	s0,80(sp)
 11e:	e4a6                	sd	s1,72(sp)
 120:	e0ca                	sd	s2,64(sp)
 122:	fc4e                	sd	s3,56(sp)
 124:	f852                	sd	s4,48(sp)
 126:	f456                	sd	s5,40(sp)
 128:	f05a                	sd	s6,32(sp)
 12a:	ec5e                	sd	s7,24(sp)
 12c:	1080                	addi	s0,sp,96
 12e:	8baa                	mv	s7,a0
 130:	8a2e                	mv	s4,a1
 132:	892a                	mv	s2,a0
 134:	4481                	li	s1,0
 136:	4aa9                	li	s5,10
 138:	4b35                	li	s6,13
 13a:	89a6                	mv	s3,s1
 13c:	2485                	addiw	s1,s1,1
 13e:	0344d863          	bge	s1,s4,16e <gets+0x56>
 142:	4605                	li	a2,1
 144:	faf40593          	addi	a1,s0,-81
 148:	4501                	li	a0,0
 14a:	00000097          	auipc	ra,0x0
 14e:	19c080e7          	jalr	412(ra) # 2e6 <read>
 152:	00a05e63          	blez	a0,16e <gets+0x56>
 156:	faf44783          	lbu	a5,-81(s0)
 15a:	00f90023          	sb	a5,0(s2)
 15e:	01578763          	beq	a5,s5,16c <gets+0x54>
 162:	0905                	addi	s2,s2,1
 164:	fd679be3          	bne	a5,s6,13a <gets+0x22>
 168:	89a6                	mv	s3,s1
 16a:	a011                	j	16e <gets+0x56>
 16c:	89a6                	mv	s3,s1
 16e:	99de                	add	s3,s3,s7
 170:	00098023          	sb	zero,0(s3)
 174:	855e                	mv	a0,s7
 176:	60e6                	ld	ra,88(sp)
 178:	6446                	ld	s0,80(sp)
 17a:	64a6                	ld	s1,72(sp)
 17c:	6906                	ld	s2,64(sp)
 17e:	79e2                	ld	s3,56(sp)
 180:	7a42                	ld	s4,48(sp)
 182:	7aa2                	ld	s5,40(sp)
 184:	7b02                	ld	s6,32(sp)
 186:	6be2                	ld	s7,24(sp)
 188:	6125                	addi	sp,sp,96
 18a:	8082                	ret

000000000000018c <stat>:
 18c:	1101                	addi	sp,sp,-32
 18e:	ec06                	sd	ra,24(sp)
 190:	e822                	sd	s0,16(sp)
 192:	e426                	sd	s1,8(sp)
 194:	e04a                	sd	s2,0(sp)
 196:	1000                	addi	s0,sp,32
 198:	892e                	mv	s2,a1
 19a:	4581                	li	a1,0
 19c:	00000097          	auipc	ra,0x0
 1a0:	172080e7          	jalr	370(ra) # 30e <open>
 1a4:	02054563          	bltz	a0,1ce <stat+0x42>
 1a8:	84aa                	mv	s1,a0
 1aa:	85ca                	mv	a1,s2
 1ac:	00000097          	auipc	ra,0x0
 1b0:	17a080e7          	jalr	378(ra) # 326 <fstat>
 1b4:	892a                	mv	s2,a0
 1b6:	8526                	mv	a0,s1
 1b8:	00000097          	auipc	ra,0x0
 1bc:	13e080e7          	jalr	318(ra) # 2f6 <close>
 1c0:	854a                	mv	a0,s2
 1c2:	60e2                	ld	ra,24(sp)
 1c4:	6442                	ld	s0,16(sp)
 1c6:	64a2                	ld	s1,8(sp)
 1c8:	6902                	ld	s2,0(sp)
 1ca:	6105                	addi	sp,sp,32
 1cc:	8082                	ret
 1ce:	597d                	li	s2,-1
 1d0:	bfc5                	j	1c0 <stat+0x34>

00000000000001d2 <atoi>:
 1d2:	1141                	addi	sp,sp,-16
 1d4:	e422                	sd	s0,8(sp)
 1d6:	0800                	addi	s0,sp,16
 1d8:	00054603          	lbu	a2,0(a0)
 1dc:	fd06079b          	addiw	a5,a2,-48
 1e0:	0ff7f793          	zext.b	a5,a5
 1e4:	4725                	li	a4,9
 1e6:	02f76963          	bltu	a4,a5,218 <atoi+0x46>
 1ea:	86aa                	mv	a3,a0
 1ec:	4501                	li	a0,0
 1ee:	45a5                	li	a1,9
 1f0:	0685                	addi	a3,a3,1
 1f2:	0025179b          	slliw	a5,a0,0x2
 1f6:	9fa9                	addw	a5,a5,a0
 1f8:	0017979b          	slliw	a5,a5,0x1
 1fc:	9fb1                	addw	a5,a5,a2
 1fe:	fd07851b          	addiw	a0,a5,-48
 202:	0006c603          	lbu	a2,0(a3)
 206:	fd06071b          	addiw	a4,a2,-48
 20a:	0ff77713          	zext.b	a4,a4
 20e:	fee5f1e3          	bgeu	a1,a4,1f0 <atoi+0x1e>
 212:	6422                	ld	s0,8(sp)
 214:	0141                	addi	sp,sp,16
 216:	8082                	ret
 218:	4501                	li	a0,0
 21a:	bfe5                	j	212 <atoi+0x40>

000000000000021c <memmove>:
 21c:	1141                	addi	sp,sp,-16
 21e:	e422                	sd	s0,8(sp)
 220:	0800                	addi	s0,sp,16
 222:	02b57463          	bgeu	a0,a1,24a <memmove+0x2e>
 226:	00c05f63          	blez	a2,244 <memmove+0x28>
 22a:	1602                	slli	a2,a2,0x20
 22c:	9201                	srli	a2,a2,0x20
 22e:	00c507b3          	add	a5,a0,a2
 232:	872a                	mv	a4,a0
 234:	0585                	addi	a1,a1,1
 236:	0705                	addi	a4,a4,1
 238:	fff5c683          	lbu	a3,-1(a1)
 23c:	fed70fa3          	sb	a3,-1(a4)
 240:	fee79ae3          	bne	a5,a4,234 <memmove+0x18>
 244:	6422                	ld	s0,8(sp)
 246:	0141                	addi	sp,sp,16
 248:	8082                	ret
 24a:	00c50733          	add	a4,a0,a2
 24e:	95b2                	add	a1,a1,a2
 250:	fec05ae3          	blez	a2,244 <memmove+0x28>
 254:	fff6079b          	addiw	a5,a2,-1
 258:	1782                	slli	a5,a5,0x20
 25a:	9381                	srli	a5,a5,0x20
 25c:	fff7c793          	not	a5,a5
 260:	97ba                	add	a5,a5,a4
 262:	15fd                	addi	a1,a1,-1
 264:	177d                	addi	a4,a4,-1
 266:	0005c683          	lbu	a3,0(a1)
 26a:	00d70023          	sb	a3,0(a4)
 26e:	fee79ae3          	bne	a5,a4,262 <memmove+0x46>
 272:	bfc9                	j	244 <memmove+0x28>

0000000000000274 <memcmp>:
 274:	1141                	addi	sp,sp,-16
 276:	e422                	sd	s0,8(sp)
 278:	0800                	addi	s0,sp,16
 27a:	ca05                	beqz	a2,2aa <memcmp+0x36>
 27c:	fff6069b          	addiw	a3,a2,-1
 280:	1682                	slli	a3,a3,0x20
 282:	9281                	srli	a3,a3,0x20
 284:	0685                	addi	a3,a3,1
 286:	96aa                	add	a3,a3,a0
 288:	00054783          	lbu	a5,0(a0)
 28c:	0005c703          	lbu	a4,0(a1)
 290:	00e79863          	bne	a5,a4,2a0 <memcmp+0x2c>
 294:	0505                	addi	a0,a0,1
 296:	0585                	addi	a1,a1,1
 298:	fed518e3          	bne	a0,a3,288 <memcmp+0x14>
 29c:	4501                	li	a0,0
 29e:	a019                	j	2a4 <memcmp+0x30>
 2a0:	40e7853b          	subw	a0,a5,a4
 2a4:	6422                	ld	s0,8(sp)
 2a6:	0141                	addi	sp,sp,16
 2a8:	8082                	ret
 2aa:	4501                	li	a0,0
 2ac:	bfe5                	j	2a4 <memcmp+0x30>

00000000000002ae <memcpy>:
 2ae:	1141                	addi	sp,sp,-16
 2b0:	e406                	sd	ra,8(sp)
 2b2:	e022                	sd	s0,0(sp)
 2b4:	0800                	addi	s0,sp,16
 2b6:	00000097          	auipc	ra,0x0
 2ba:	f66080e7          	jalr	-154(ra) # 21c <memmove>
 2be:	60a2                	ld	ra,8(sp)
 2c0:	6402                	ld	s0,0(sp)
 2c2:	0141                	addi	sp,sp,16
 2c4:	8082                	ret

00000000000002c6 <fork>:
 2c6:	4885                	li	a7,1
 2c8:	00000073          	ecall
 2cc:	8082                	ret

00000000000002ce <exit>:
 2ce:	4889                	li	a7,2
 2d0:	00000073          	ecall
 2d4:	8082                	ret

00000000000002d6 <wait>:
 2d6:	488d                	li	a7,3
 2d8:	00000073          	ecall
 2dc:	8082                	ret

00000000000002de <pipe>:
 2de:	4891                	li	a7,4
 2e0:	00000073          	ecall
 2e4:	8082                	ret

00000000000002e6 <read>:
 2e6:	4895                	li	a7,5
 2e8:	00000073          	ecall
 2ec:	8082                	ret

00000000000002ee <write>:
 2ee:	48c1                	li	a7,16
 2f0:	00000073          	ecall
 2f4:	8082                	ret

00000000000002f6 <close>:
 2f6:	48d5                	li	a7,21
 2f8:	00000073          	ecall
 2fc:	8082                	ret

00000000000002fe <kill>:
 2fe:	4899                	li	a7,6
 300:	00000073          	ecall
 304:	8082                	ret

0000000000000306 <exec>:
 306:	489d                	li	a7,7
 308:	00000073          	ecall
 30c:	8082                	ret

000000000000030e <open>:
 30e:	48bd                	li	a7,15
 310:	00000073          	ecall
 314:	8082                	ret

0000000000000316 <mknod>:
 316:	48c5                	li	a7,17
 318:	00000073          	ecall
 31c:	8082                	ret

000000000000031e <unlink>:
 31e:	48c9                	li	a7,18
 320:	00000073          	ecall
 324:	8082                	ret

0000000000000326 <fstat>:
 326:	48a1                	li	a7,8
 328:	00000073          	ecall
 32c:	8082                	ret

000000000000032e <link>:
 32e:	48cd                	li	a7,19
 330:	00000073          	ecall
 334:	8082                	ret

0000000000000336 <mkdir>:
 336:	48d1                	li	a7,20
 338:	00000073          	ecall
 33c:	8082                	ret

000000000000033e <chdir>:
 33e:	48a5                	li	a7,9
 340:	00000073          	ecall
 344:	8082                	ret

0000000000000346 <dup>:
 346:	48a9                	li	a7,10
 348:	00000073          	ecall
 34c:	8082                	ret

000000000000034e <getpid>:
 34e:	48ad                	li	a7,11
 350:	00000073          	ecall
 354:	8082                	ret

0000000000000356 <sbrk>:
 356:	48b1                	li	a7,12
 358:	00000073          	ecall
 35c:	8082                	ret

000000000000035e <sleep>:
 35e:	48b5                	li	a7,13
 360:	00000073          	ecall
 364:	8082                	ret

0000000000000366 <uptime>:
 366:	48b9                	li	a7,14
 368:	00000073          	ecall
 36c:	8082                	ret

000000000000036e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 36e:	1101                	addi	sp,sp,-32
 370:	ec06                	sd	ra,24(sp)
 372:	e822                	sd	s0,16(sp)
 374:	1000                	addi	s0,sp,32
 376:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 37a:	4605                	li	a2,1
 37c:	fef40593          	addi	a1,s0,-17
 380:	00000097          	auipc	ra,0x0
 384:	f6e080e7          	jalr	-146(ra) # 2ee <write>
}
 388:	60e2                	ld	ra,24(sp)
 38a:	6442                	ld	s0,16(sp)
 38c:	6105                	addi	sp,sp,32
 38e:	8082                	ret

0000000000000390 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 390:	7139                	addi	sp,sp,-64
 392:	fc06                	sd	ra,56(sp)
 394:	f822                	sd	s0,48(sp)
 396:	f426                	sd	s1,40(sp)
 398:	f04a                	sd	s2,32(sp)
 39a:	ec4e                	sd	s3,24(sp)
 39c:	0080                	addi	s0,sp,64
 39e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3a0:	c299                	beqz	a3,3a6 <printint+0x16>
 3a2:	0805c963          	bltz	a1,434 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3a6:	2581                	sext.w	a1,a1
  neg = 0;
 3a8:	4881                	li	a7,0
 3aa:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3ae:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3b0:	2601                	sext.w	a2,a2
 3b2:	00000517          	auipc	a0,0x0
 3b6:	55650513          	addi	a0,a0,1366 # 908 <digits>
 3ba:	883a                	mv	a6,a4
 3bc:	2705                	addiw	a4,a4,1
 3be:	02c5f7bb          	remuw	a5,a1,a2
 3c2:	1782                	slli	a5,a5,0x20
 3c4:	9381                	srli	a5,a5,0x20
 3c6:	97aa                	add	a5,a5,a0
 3c8:	0007c783          	lbu	a5,0(a5)
 3cc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3d0:	0005879b          	sext.w	a5,a1
 3d4:	02c5d5bb          	divuw	a1,a1,a2
 3d8:	0685                	addi	a3,a3,1
 3da:	fec7f0e3          	bgeu	a5,a2,3ba <printint+0x2a>
  if(neg)
 3de:	00088c63          	beqz	a7,3f6 <printint+0x66>
    buf[i++] = '-';
 3e2:	fd070793          	addi	a5,a4,-48
 3e6:	00878733          	add	a4,a5,s0
 3ea:	02d00793          	li	a5,45
 3ee:	fef70823          	sb	a5,-16(a4)
 3f2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3f6:	02e05863          	blez	a4,426 <printint+0x96>
 3fa:	fc040793          	addi	a5,s0,-64
 3fe:	00e78933          	add	s2,a5,a4
 402:	fff78993          	addi	s3,a5,-1
 406:	99ba                	add	s3,s3,a4
 408:	377d                	addiw	a4,a4,-1
 40a:	1702                	slli	a4,a4,0x20
 40c:	9301                	srli	a4,a4,0x20
 40e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 412:	fff94583          	lbu	a1,-1(s2)
 416:	8526                	mv	a0,s1
 418:	00000097          	auipc	ra,0x0
 41c:	f56080e7          	jalr	-170(ra) # 36e <putc>
  while(--i >= 0)
 420:	197d                	addi	s2,s2,-1
 422:	ff3918e3          	bne	s2,s3,412 <printint+0x82>
}
 426:	70e2                	ld	ra,56(sp)
 428:	7442                	ld	s0,48(sp)
 42a:	74a2                	ld	s1,40(sp)
 42c:	7902                	ld	s2,32(sp)
 42e:	69e2                	ld	s3,24(sp)
 430:	6121                	addi	sp,sp,64
 432:	8082                	ret
    x = -xx;
 434:	40b005bb          	negw	a1,a1
    neg = 1;
 438:	4885                	li	a7,1
    x = -xx;
 43a:	bf85                	j	3aa <printint+0x1a>

000000000000043c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 43c:	7119                	addi	sp,sp,-128
 43e:	fc86                	sd	ra,120(sp)
 440:	f8a2                	sd	s0,112(sp)
 442:	f4a6                	sd	s1,104(sp)
 444:	f0ca                	sd	s2,96(sp)
 446:	ecce                	sd	s3,88(sp)
 448:	e8d2                	sd	s4,80(sp)
 44a:	e4d6                	sd	s5,72(sp)
 44c:	e0da                	sd	s6,64(sp)
 44e:	fc5e                	sd	s7,56(sp)
 450:	f862                	sd	s8,48(sp)
 452:	f466                	sd	s9,40(sp)
 454:	f06a                	sd	s10,32(sp)
 456:	ec6e                	sd	s11,24(sp)
 458:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 45a:	0005c903          	lbu	s2,0(a1)
 45e:	18090f63          	beqz	s2,5fc <vprintf+0x1c0>
 462:	8aaa                	mv	s5,a0
 464:	8b32                	mv	s6,a2
 466:	00158493          	addi	s1,a1,1
  state = 0;
 46a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 46c:	02500a13          	li	s4,37
 470:	4c55                	li	s8,21
 472:	00000c97          	auipc	s9,0x0
 476:	43ec8c93          	addi	s9,s9,1086 # 8b0 <l_free+0x46>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 47a:	02800d93          	li	s11,40
  putc(fd, 'x');
 47e:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 480:	00000b97          	auipc	s7,0x0
 484:	488b8b93          	addi	s7,s7,1160 # 908 <digits>
 488:	a839                	j	4a6 <vprintf+0x6a>
        putc(fd, c);
 48a:	85ca                	mv	a1,s2
 48c:	8556                	mv	a0,s5
 48e:	00000097          	auipc	ra,0x0
 492:	ee0080e7          	jalr	-288(ra) # 36e <putc>
 496:	a019                	j	49c <vprintf+0x60>
    } else if(state == '%'){
 498:	01498d63          	beq	s3,s4,4b2 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 49c:	0485                	addi	s1,s1,1
 49e:	fff4c903          	lbu	s2,-1(s1)
 4a2:	14090d63          	beqz	s2,5fc <vprintf+0x1c0>
    if(state == 0){
 4a6:	fe0999e3          	bnez	s3,498 <vprintf+0x5c>
      if(c == '%'){
 4aa:	ff4910e3          	bne	s2,s4,48a <vprintf+0x4e>
        state = '%';
 4ae:	89d2                	mv	s3,s4
 4b0:	b7f5                	j	49c <vprintf+0x60>
      if(c == 'd'){
 4b2:	11490c63          	beq	s2,s4,5ca <vprintf+0x18e>
 4b6:	f9d9079b          	addiw	a5,s2,-99
 4ba:	0ff7f793          	zext.b	a5,a5
 4be:	10fc6e63          	bltu	s8,a5,5da <vprintf+0x19e>
 4c2:	f9d9079b          	addiw	a5,s2,-99
 4c6:	0ff7f713          	zext.b	a4,a5
 4ca:	10ec6863          	bltu	s8,a4,5da <vprintf+0x19e>
 4ce:	00271793          	slli	a5,a4,0x2
 4d2:	97e6                	add	a5,a5,s9
 4d4:	439c                	lw	a5,0(a5)
 4d6:	97e6                	add	a5,a5,s9
 4d8:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4da:	008b0913          	addi	s2,s6,8
 4de:	4685                	li	a3,1
 4e0:	4629                	li	a2,10
 4e2:	000b2583          	lw	a1,0(s6)
 4e6:	8556                	mv	a0,s5
 4e8:	00000097          	auipc	ra,0x0
 4ec:	ea8080e7          	jalr	-344(ra) # 390 <printint>
 4f0:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4f2:	4981                	li	s3,0
 4f4:	b765                	j	49c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4f6:	008b0913          	addi	s2,s6,8
 4fa:	4681                	li	a3,0
 4fc:	4629                	li	a2,10
 4fe:	000b2583          	lw	a1,0(s6)
 502:	8556                	mv	a0,s5
 504:	00000097          	auipc	ra,0x0
 508:	e8c080e7          	jalr	-372(ra) # 390 <printint>
 50c:	8b4a                	mv	s6,s2
      state = 0;
 50e:	4981                	li	s3,0
 510:	b771                	j	49c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 512:	008b0913          	addi	s2,s6,8
 516:	4681                	li	a3,0
 518:	866a                	mv	a2,s10
 51a:	000b2583          	lw	a1,0(s6)
 51e:	8556                	mv	a0,s5
 520:	00000097          	auipc	ra,0x0
 524:	e70080e7          	jalr	-400(ra) # 390 <printint>
 528:	8b4a                	mv	s6,s2
      state = 0;
 52a:	4981                	li	s3,0
 52c:	bf85                	j	49c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 52e:	008b0793          	addi	a5,s6,8
 532:	f8f43423          	sd	a5,-120(s0)
 536:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 53a:	03000593          	li	a1,48
 53e:	8556                	mv	a0,s5
 540:	00000097          	auipc	ra,0x0
 544:	e2e080e7          	jalr	-466(ra) # 36e <putc>
  putc(fd, 'x');
 548:	07800593          	li	a1,120
 54c:	8556                	mv	a0,s5
 54e:	00000097          	auipc	ra,0x0
 552:	e20080e7          	jalr	-480(ra) # 36e <putc>
 556:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 558:	03c9d793          	srli	a5,s3,0x3c
 55c:	97de                	add	a5,a5,s7
 55e:	0007c583          	lbu	a1,0(a5)
 562:	8556                	mv	a0,s5
 564:	00000097          	auipc	ra,0x0
 568:	e0a080e7          	jalr	-502(ra) # 36e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 56c:	0992                	slli	s3,s3,0x4
 56e:	397d                	addiw	s2,s2,-1
 570:	fe0914e3          	bnez	s2,558 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 574:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 578:	4981                	li	s3,0
 57a:	b70d                	j	49c <vprintf+0x60>
        s = va_arg(ap, char*);
 57c:	008b0913          	addi	s2,s6,8
 580:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 584:	02098163          	beqz	s3,5a6 <vprintf+0x16a>
        while(*s != 0){
 588:	0009c583          	lbu	a1,0(s3)
 58c:	c5ad                	beqz	a1,5f6 <vprintf+0x1ba>
          putc(fd, *s);
 58e:	8556                	mv	a0,s5
 590:	00000097          	auipc	ra,0x0
 594:	dde080e7          	jalr	-546(ra) # 36e <putc>
          s++;
 598:	0985                	addi	s3,s3,1
        while(*s != 0){
 59a:	0009c583          	lbu	a1,0(s3)
 59e:	f9e5                	bnez	a1,58e <vprintf+0x152>
        s = va_arg(ap, char*);
 5a0:	8b4a                	mv	s6,s2
      state = 0;
 5a2:	4981                	li	s3,0
 5a4:	bde5                	j	49c <vprintf+0x60>
          s = "(null)";
 5a6:	00000997          	auipc	s3,0x0
 5aa:	30298993          	addi	s3,s3,770 # 8a8 <l_free+0x3e>
        while(*s != 0){
 5ae:	85ee                	mv	a1,s11
 5b0:	bff9                	j	58e <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 5b2:	008b0913          	addi	s2,s6,8
 5b6:	000b4583          	lbu	a1,0(s6)
 5ba:	8556                	mv	a0,s5
 5bc:	00000097          	auipc	ra,0x0
 5c0:	db2080e7          	jalr	-590(ra) # 36e <putc>
 5c4:	8b4a                	mv	s6,s2
      state = 0;
 5c6:	4981                	li	s3,0
 5c8:	bdd1                	j	49c <vprintf+0x60>
        putc(fd, c);
 5ca:	85d2                	mv	a1,s4
 5cc:	8556                	mv	a0,s5
 5ce:	00000097          	auipc	ra,0x0
 5d2:	da0080e7          	jalr	-608(ra) # 36e <putc>
      state = 0;
 5d6:	4981                	li	s3,0
 5d8:	b5d1                	j	49c <vprintf+0x60>
        putc(fd, '%');
 5da:	85d2                	mv	a1,s4
 5dc:	8556                	mv	a0,s5
 5de:	00000097          	auipc	ra,0x0
 5e2:	d90080e7          	jalr	-624(ra) # 36e <putc>
        putc(fd, c);
 5e6:	85ca                	mv	a1,s2
 5e8:	8556                	mv	a0,s5
 5ea:	00000097          	auipc	ra,0x0
 5ee:	d84080e7          	jalr	-636(ra) # 36e <putc>
      state = 0;
 5f2:	4981                	li	s3,0
 5f4:	b565                	j	49c <vprintf+0x60>
        s = va_arg(ap, char*);
 5f6:	8b4a                	mv	s6,s2
      state = 0;
 5f8:	4981                	li	s3,0
 5fa:	b54d                	j	49c <vprintf+0x60>
    }
  }
}
 5fc:	70e6                	ld	ra,120(sp)
 5fe:	7446                	ld	s0,112(sp)
 600:	74a6                	ld	s1,104(sp)
 602:	7906                	ld	s2,96(sp)
 604:	69e6                	ld	s3,88(sp)
 606:	6a46                	ld	s4,80(sp)
 608:	6aa6                	ld	s5,72(sp)
 60a:	6b06                	ld	s6,64(sp)
 60c:	7be2                	ld	s7,56(sp)
 60e:	7c42                	ld	s8,48(sp)
 610:	7ca2                	ld	s9,40(sp)
 612:	7d02                	ld	s10,32(sp)
 614:	6de2                	ld	s11,24(sp)
 616:	6109                	addi	sp,sp,128
 618:	8082                	ret

000000000000061a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 61a:	715d                	addi	sp,sp,-80
 61c:	ec06                	sd	ra,24(sp)
 61e:	e822                	sd	s0,16(sp)
 620:	1000                	addi	s0,sp,32
 622:	e010                	sd	a2,0(s0)
 624:	e414                	sd	a3,8(s0)
 626:	e818                	sd	a4,16(s0)
 628:	ec1c                	sd	a5,24(s0)
 62a:	03043023          	sd	a6,32(s0)
 62e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 632:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 636:	8622                	mv	a2,s0
 638:	00000097          	auipc	ra,0x0
 63c:	e04080e7          	jalr	-508(ra) # 43c <vprintf>
}
 640:	60e2                	ld	ra,24(sp)
 642:	6442                	ld	s0,16(sp)
 644:	6161                	addi	sp,sp,80
 646:	8082                	ret

0000000000000648 <printf>:

void
printf(const char *fmt, ...)
{
 648:	711d                	addi	sp,sp,-96
 64a:	ec06                	sd	ra,24(sp)
 64c:	e822                	sd	s0,16(sp)
 64e:	1000                	addi	s0,sp,32
 650:	e40c                	sd	a1,8(s0)
 652:	e810                	sd	a2,16(s0)
 654:	ec14                	sd	a3,24(s0)
 656:	f018                	sd	a4,32(s0)
 658:	f41c                	sd	a5,40(s0)
 65a:	03043823          	sd	a6,48(s0)
 65e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 662:	00840613          	addi	a2,s0,8
 666:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 66a:	85aa                	mv	a1,a0
 66c:	4505                	li	a0,1
 66e:	00000097          	auipc	ra,0x0
 672:	dce080e7          	jalr	-562(ra) # 43c <vprintf>
}
 676:	60e2                	ld	ra,24(sp)
 678:	6442                	ld	s0,16(sp)
 67a:	6125                	addi	sp,sp,96
 67c:	8082                	ret

000000000000067e <free>:
 67e:	1141                	addi	sp,sp,-16
 680:	e422                	sd	s0,8(sp)
 682:	0800                	addi	s0,sp,16
 684:	ff050693          	addi	a3,a0,-16
 688:	00000797          	auipc	a5,0x0
 68c:	2a87b783          	ld	a5,680(a5) # 930 <freep>
 690:	a805                	j	6c0 <free+0x42>
 692:	4618                	lw	a4,8(a2)
 694:	9db9                	addw	a1,a1,a4
 696:	feb52c23          	sw	a1,-8(a0)
 69a:	6398                	ld	a4,0(a5)
 69c:	6318                	ld	a4,0(a4)
 69e:	fee53823          	sd	a4,-16(a0)
 6a2:	a091                	j	6e6 <free+0x68>
 6a4:	ff852703          	lw	a4,-8(a0)
 6a8:	9e39                	addw	a2,a2,a4
 6aa:	c790                	sw	a2,8(a5)
 6ac:	ff053703          	ld	a4,-16(a0)
 6b0:	e398                	sd	a4,0(a5)
 6b2:	a099                	j	6f8 <free+0x7a>
 6b4:	6398                	ld	a4,0(a5)
 6b6:	00e7e463          	bltu	a5,a4,6be <free+0x40>
 6ba:	00e6ea63          	bltu	a3,a4,6ce <free+0x50>
 6be:	87ba                	mv	a5,a4
 6c0:	fed7fae3          	bgeu	a5,a3,6b4 <free+0x36>
 6c4:	6398                	ld	a4,0(a5)
 6c6:	00e6e463          	bltu	a3,a4,6ce <free+0x50>
 6ca:	fee7eae3          	bltu	a5,a4,6be <free+0x40>
 6ce:	ff852583          	lw	a1,-8(a0)
 6d2:	6390                	ld	a2,0(a5)
 6d4:	02059713          	slli	a4,a1,0x20
 6d8:	9301                	srli	a4,a4,0x20
 6da:	0712                	slli	a4,a4,0x4
 6dc:	9736                	add	a4,a4,a3
 6de:	fae60ae3          	beq	a2,a4,692 <free+0x14>
 6e2:	fec53823          	sd	a2,-16(a0)
 6e6:	4790                	lw	a2,8(a5)
 6e8:	02061713          	slli	a4,a2,0x20
 6ec:	9301                	srli	a4,a4,0x20
 6ee:	0712                	slli	a4,a4,0x4
 6f0:	973e                	add	a4,a4,a5
 6f2:	fae689e3          	beq	a3,a4,6a4 <free+0x26>
 6f6:	e394                	sd	a3,0(a5)
 6f8:	00000717          	auipc	a4,0x0
 6fc:	22f73c23          	sd	a5,568(a4) # 930 <freep>
 700:	6422                	ld	s0,8(sp)
 702:	0141                	addi	sp,sp,16
 704:	8082                	ret

0000000000000706 <malloc>:
 706:	7139                	addi	sp,sp,-64
 708:	fc06                	sd	ra,56(sp)
 70a:	f822                	sd	s0,48(sp)
 70c:	f426                	sd	s1,40(sp)
 70e:	f04a                	sd	s2,32(sp)
 710:	ec4e                	sd	s3,24(sp)
 712:	e852                	sd	s4,16(sp)
 714:	e456                	sd	s5,8(sp)
 716:	e05a                	sd	s6,0(sp)
 718:	0080                	addi	s0,sp,64
 71a:	02051493          	slli	s1,a0,0x20
 71e:	9081                	srli	s1,s1,0x20
 720:	04bd                	addi	s1,s1,15
 722:	8091                	srli	s1,s1,0x4
 724:	0014899b          	addiw	s3,s1,1
 728:	0485                	addi	s1,s1,1
 72a:	00000517          	auipc	a0,0x0
 72e:	20653503          	ld	a0,518(a0) # 930 <freep>
 732:	c515                	beqz	a0,75e <malloc+0x58>
 734:	611c                	ld	a5,0(a0)
 736:	4798                	lw	a4,8(a5)
 738:	02977f63          	bgeu	a4,s1,776 <malloc+0x70>
 73c:	8a4e                	mv	s4,s3
 73e:	0009871b          	sext.w	a4,s3
 742:	6685                	lui	a3,0x1
 744:	00d77363          	bgeu	a4,a3,74a <malloc+0x44>
 748:	6a05                	lui	s4,0x1
 74a:	000a0b1b          	sext.w	s6,s4
 74e:	004a1a1b          	slliw	s4,s4,0x4
 752:	00000917          	auipc	s2,0x0
 756:	1de90913          	addi	s2,s2,478 # 930 <freep>
 75a:	5afd                	li	s5,-1
 75c:	a88d                	j	7ce <malloc+0xc8>
 75e:	00000797          	auipc	a5,0x0
 762:	1da78793          	addi	a5,a5,474 # 938 <base>
 766:	00000717          	auipc	a4,0x0
 76a:	1cf73523          	sd	a5,458(a4) # 930 <freep>
 76e:	e39c                	sd	a5,0(a5)
 770:	0007a423          	sw	zero,8(a5)
 774:	b7e1                	j	73c <malloc+0x36>
 776:	02e48b63          	beq	s1,a4,7ac <malloc+0xa6>
 77a:	4137073b          	subw	a4,a4,s3
 77e:	c798                	sw	a4,8(a5)
 780:	1702                	slli	a4,a4,0x20
 782:	9301                	srli	a4,a4,0x20
 784:	0712                	slli	a4,a4,0x4
 786:	97ba                	add	a5,a5,a4
 788:	0137a423          	sw	s3,8(a5)
 78c:	00000717          	auipc	a4,0x0
 790:	1aa73223          	sd	a0,420(a4) # 930 <freep>
 794:	01078513          	addi	a0,a5,16
 798:	70e2                	ld	ra,56(sp)
 79a:	7442                	ld	s0,48(sp)
 79c:	74a2                	ld	s1,40(sp)
 79e:	7902                	ld	s2,32(sp)
 7a0:	69e2                	ld	s3,24(sp)
 7a2:	6a42                	ld	s4,16(sp)
 7a4:	6aa2                	ld	s5,8(sp)
 7a6:	6b02                	ld	s6,0(sp)
 7a8:	6121                	addi	sp,sp,64
 7aa:	8082                	ret
 7ac:	6398                	ld	a4,0(a5)
 7ae:	e118                	sd	a4,0(a0)
 7b0:	bff1                	j	78c <malloc+0x86>
 7b2:	01652423          	sw	s6,8(a0)
 7b6:	0541                	addi	a0,a0,16
 7b8:	00000097          	auipc	ra,0x0
 7bc:	ec6080e7          	jalr	-314(ra) # 67e <free>
 7c0:	00093503          	ld	a0,0(s2)
 7c4:	d971                	beqz	a0,798 <malloc+0x92>
 7c6:	611c                	ld	a5,0(a0)
 7c8:	4798                	lw	a4,8(a5)
 7ca:	fa9776e3          	bgeu	a4,s1,776 <malloc+0x70>
 7ce:	00093703          	ld	a4,0(s2)
 7d2:	853e                	mv	a0,a5
 7d4:	fef719e3          	bne	a4,a5,7c6 <malloc+0xc0>
 7d8:	8552                	mv	a0,s4
 7da:	00000097          	auipc	ra,0x0
 7de:	b7c080e7          	jalr	-1156(ra) # 356 <sbrk>
 7e2:	fd5518e3          	bne	a0,s5,7b2 <malloc+0xac>
 7e6:	4501                	li	a0,0
 7e8:	bf45                	j	798 <malloc+0x92>

00000000000007ea <mem_init>:
 7ea:	1141                	addi	sp,sp,-16
 7ec:	e406                	sd	ra,8(sp)
 7ee:	e022                	sd	s0,0(sp)
 7f0:	0800                	addi	s0,sp,16
 7f2:	6505                	lui	a0,0x1
 7f4:	00000097          	auipc	ra,0x0
 7f8:	b62080e7          	jalr	-1182(ra) # 356 <sbrk>
 7fc:	00000797          	auipc	a5,0x0
 800:	12a7b623          	sd	a0,300(a5) # 928 <alloc>
 804:	00850793          	addi	a5,a0,8 # 1008 <__BSS_END__+0x6c0>
 808:	e11c                	sd	a5,0(a0)
 80a:	60a2                	ld	ra,8(sp)
 80c:	6402                	ld	s0,0(sp)
 80e:	0141                	addi	sp,sp,16
 810:	8082                	ret

0000000000000812 <l_alloc>:
 812:	1101                	addi	sp,sp,-32
 814:	ec06                	sd	ra,24(sp)
 816:	e822                	sd	s0,16(sp)
 818:	e426                	sd	s1,8(sp)
 81a:	1000                	addi	s0,sp,32
 81c:	84aa                	mv	s1,a0
 81e:	00000797          	auipc	a5,0x0
 822:	1027a783          	lw	a5,258(a5) # 920 <if_init>
 826:	c795                	beqz	a5,852 <l_alloc+0x40>
 828:	00000717          	auipc	a4,0x0
 82c:	10073703          	ld	a4,256(a4) # 928 <alloc>
 830:	6308                	ld	a0,0(a4)
 832:	40e506b3          	sub	a3,a0,a4
 836:	6785                	lui	a5,0x1
 838:	37e1                	addiw	a5,a5,-8
 83a:	9f95                	subw	a5,a5,a3
 83c:	02f4f563          	bgeu	s1,a5,866 <l_alloc+0x54>
 840:	1482                	slli	s1,s1,0x20
 842:	9081                	srli	s1,s1,0x20
 844:	94aa                	add	s1,s1,a0
 846:	e304                	sd	s1,0(a4)
 848:	60e2                	ld	ra,24(sp)
 84a:	6442                	ld	s0,16(sp)
 84c:	64a2                	ld	s1,8(sp)
 84e:	6105                	addi	sp,sp,32
 850:	8082                	ret
 852:	00000097          	auipc	ra,0x0
 856:	f98080e7          	jalr	-104(ra) # 7ea <mem_init>
 85a:	4785                	li	a5,1
 85c:	00000717          	auipc	a4,0x0
 860:	0cf72223          	sw	a5,196(a4) # 920 <if_init>
 864:	b7d1                	j	828 <l_alloc+0x16>
 866:	4501                	li	a0,0
 868:	b7c5                	j	848 <l_alloc+0x36>

000000000000086a <l_free>:
 86a:	1141                	addi	sp,sp,-16
 86c:	e422                	sd	s0,8(sp)
 86e:	0800                	addi	s0,sp,16
 870:	6422                	ld	s0,8(sp)
 872:	0141                	addi	sp,sp,16
 874:	8082                	ret
