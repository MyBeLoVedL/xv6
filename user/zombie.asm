
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
   8:	00000097          	auipc	ra,0x0
   c:	288080e7          	jalr	648(ra) # 290 <fork>
  10:	00a04763          	bgtz	a0,1e <main+0x1e>
  14:	4501                	li	a0,0
  16:	00000097          	auipc	ra,0x0
  1a:	282080e7          	jalr	642(ra) # 298 <exit>
  1e:	4515                	li	a0,5
  20:	00000097          	auipc	ra,0x0
  24:	308080e7          	jalr	776(ra) # 328 <sleep>
  28:	b7f5                	j	14 <main+0x14>

000000000000002a <strcpy>:
  2a:	1141                	addi	sp,sp,-16
  2c:	e422                	sd	s0,8(sp)
  2e:	0800                	addi	s0,sp,16
  30:	87aa                	mv	a5,a0
  32:	0585                	addi	a1,a1,1
  34:	0785                	addi	a5,a5,1
  36:	fff5c703          	lbu	a4,-1(a1)
  3a:	fee78fa3          	sb	a4,-1(a5)
  3e:	fb75                	bnez	a4,32 <strcpy+0x8>
  40:	6422                	ld	s0,8(sp)
  42:	0141                	addi	sp,sp,16
  44:	8082                	ret

0000000000000046 <strcmp>:
  46:	1141                	addi	sp,sp,-16
  48:	e422                	sd	s0,8(sp)
  4a:	0800                	addi	s0,sp,16
  4c:	00054783          	lbu	a5,0(a0)
  50:	cb91                	beqz	a5,64 <strcmp+0x1e>
  52:	0005c703          	lbu	a4,0(a1)
  56:	00f71763          	bne	a4,a5,64 <strcmp+0x1e>
  5a:	0505                	addi	a0,a0,1
  5c:	0585                	addi	a1,a1,1
  5e:	00054783          	lbu	a5,0(a0)
  62:	fbe5                	bnez	a5,52 <strcmp+0xc>
  64:	0005c503          	lbu	a0,0(a1)
  68:	40a7853b          	subw	a0,a5,a0
  6c:	6422                	ld	s0,8(sp)
  6e:	0141                	addi	sp,sp,16
  70:	8082                	ret

0000000000000072 <strlen>:
  72:	1141                	addi	sp,sp,-16
  74:	e422                	sd	s0,8(sp)
  76:	0800                	addi	s0,sp,16
  78:	00054783          	lbu	a5,0(a0)
  7c:	cf91                	beqz	a5,98 <strlen+0x26>
  7e:	0505                	addi	a0,a0,1
  80:	87aa                	mv	a5,a0
  82:	4685                	li	a3,1
  84:	9e89                	subw	a3,a3,a0
  86:	00f6853b          	addw	a0,a3,a5
  8a:	0785                	addi	a5,a5,1
  8c:	fff7c703          	lbu	a4,-1(a5)
  90:	fb7d                	bnez	a4,86 <strlen+0x14>
  92:	6422                	ld	s0,8(sp)
  94:	0141                	addi	sp,sp,16
  96:	8082                	ret
  98:	4501                	li	a0,0
  9a:	bfe5                	j	92 <strlen+0x20>

000000000000009c <memset>:
  9c:	1141                	addi	sp,sp,-16
  9e:	e422                	sd	s0,8(sp)
  a0:	0800                	addi	s0,sp,16
  a2:	ca19                	beqz	a2,b8 <memset+0x1c>
  a4:	87aa                	mv	a5,a0
  a6:	1602                	slli	a2,a2,0x20
  a8:	9201                	srli	a2,a2,0x20
  aa:	00a60733          	add	a4,a2,a0
  ae:	00b78023          	sb	a1,0(a5)
  b2:	0785                	addi	a5,a5,1
  b4:	fee79de3          	bne	a5,a4,ae <memset+0x12>
  b8:	6422                	ld	s0,8(sp)
  ba:	0141                	addi	sp,sp,16
  bc:	8082                	ret

00000000000000be <strchr>:
  be:	1141                	addi	sp,sp,-16
  c0:	e422                	sd	s0,8(sp)
  c2:	0800                	addi	s0,sp,16
  c4:	00054783          	lbu	a5,0(a0)
  c8:	cb99                	beqz	a5,de <strchr+0x20>
  ca:	00f58763          	beq	a1,a5,d8 <strchr+0x1a>
  ce:	0505                	addi	a0,a0,1
  d0:	00054783          	lbu	a5,0(a0)
  d4:	fbfd                	bnez	a5,ca <strchr+0xc>
  d6:	4501                	li	a0,0
  d8:	6422                	ld	s0,8(sp)
  da:	0141                	addi	sp,sp,16
  dc:	8082                	ret
  de:	4501                	li	a0,0
  e0:	bfe5                	j	d8 <strchr+0x1a>

00000000000000e2 <gets>:
  e2:	711d                	addi	sp,sp,-96
  e4:	ec86                	sd	ra,88(sp)
  e6:	e8a2                	sd	s0,80(sp)
  e8:	e4a6                	sd	s1,72(sp)
  ea:	e0ca                	sd	s2,64(sp)
  ec:	fc4e                	sd	s3,56(sp)
  ee:	f852                	sd	s4,48(sp)
  f0:	f456                	sd	s5,40(sp)
  f2:	f05a                	sd	s6,32(sp)
  f4:	ec5e                	sd	s7,24(sp)
  f6:	1080                	addi	s0,sp,96
  f8:	8baa                	mv	s7,a0
  fa:	8a2e                	mv	s4,a1
  fc:	892a                	mv	s2,a0
  fe:	4481                	li	s1,0
 100:	4aa9                	li	s5,10
 102:	4b35                	li	s6,13
 104:	89a6                	mv	s3,s1
 106:	2485                	addiw	s1,s1,1
 108:	0344d863          	bge	s1,s4,138 <gets+0x56>
 10c:	4605                	li	a2,1
 10e:	faf40593          	addi	a1,s0,-81
 112:	4501                	li	a0,0
 114:	00000097          	auipc	ra,0x0
 118:	19c080e7          	jalr	412(ra) # 2b0 <read>
 11c:	00a05e63          	blez	a0,138 <gets+0x56>
 120:	faf44783          	lbu	a5,-81(s0)
 124:	00f90023          	sb	a5,0(s2)
 128:	01578763          	beq	a5,s5,136 <gets+0x54>
 12c:	0905                	addi	s2,s2,1
 12e:	fd679be3          	bne	a5,s6,104 <gets+0x22>
 132:	89a6                	mv	s3,s1
 134:	a011                	j	138 <gets+0x56>
 136:	89a6                	mv	s3,s1
 138:	99de                	add	s3,s3,s7
 13a:	00098023          	sb	zero,0(s3)
 13e:	855e                	mv	a0,s7
 140:	60e6                	ld	ra,88(sp)
 142:	6446                	ld	s0,80(sp)
 144:	64a6                	ld	s1,72(sp)
 146:	6906                	ld	s2,64(sp)
 148:	79e2                	ld	s3,56(sp)
 14a:	7a42                	ld	s4,48(sp)
 14c:	7aa2                	ld	s5,40(sp)
 14e:	7b02                	ld	s6,32(sp)
 150:	6be2                	ld	s7,24(sp)
 152:	6125                	addi	sp,sp,96
 154:	8082                	ret

0000000000000156 <stat>:
 156:	1101                	addi	sp,sp,-32
 158:	ec06                	sd	ra,24(sp)
 15a:	e822                	sd	s0,16(sp)
 15c:	e426                	sd	s1,8(sp)
 15e:	e04a                	sd	s2,0(sp)
 160:	1000                	addi	s0,sp,32
 162:	892e                	mv	s2,a1
 164:	4581                	li	a1,0
 166:	00000097          	auipc	ra,0x0
 16a:	172080e7          	jalr	370(ra) # 2d8 <open>
 16e:	02054563          	bltz	a0,198 <stat+0x42>
 172:	84aa                	mv	s1,a0
 174:	85ca                	mv	a1,s2
 176:	00000097          	auipc	ra,0x0
 17a:	17a080e7          	jalr	378(ra) # 2f0 <fstat>
 17e:	892a                	mv	s2,a0
 180:	8526                	mv	a0,s1
 182:	00000097          	auipc	ra,0x0
 186:	13e080e7          	jalr	318(ra) # 2c0 <close>
 18a:	854a                	mv	a0,s2
 18c:	60e2                	ld	ra,24(sp)
 18e:	6442                	ld	s0,16(sp)
 190:	64a2                	ld	s1,8(sp)
 192:	6902                	ld	s2,0(sp)
 194:	6105                	addi	sp,sp,32
 196:	8082                	ret
 198:	597d                	li	s2,-1
 19a:	bfc5                	j	18a <stat+0x34>

000000000000019c <atoi>:
 19c:	1141                	addi	sp,sp,-16
 19e:	e422                	sd	s0,8(sp)
 1a0:	0800                	addi	s0,sp,16
 1a2:	00054603          	lbu	a2,0(a0)
 1a6:	fd06079b          	addiw	a5,a2,-48
 1aa:	0ff7f793          	zext.b	a5,a5
 1ae:	4725                	li	a4,9
 1b0:	02f76963          	bltu	a4,a5,1e2 <atoi+0x46>
 1b4:	86aa                	mv	a3,a0
 1b6:	4501                	li	a0,0
 1b8:	45a5                	li	a1,9
 1ba:	0685                	addi	a3,a3,1
 1bc:	0025179b          	slliw	a5,a0,0x2
 1c0:	9fa9                	addw	a5,a5,a0
 1c2:	0017979b          	slliw	a5,a5,0x1
 1c6:	9fb1                	addw	a5,a5,a2
 1c8:	fd07851b          	addiw	a0,a5,-48
 1cc:	0006c603          	lbu	a2,0(a3)
 1d0:	fd06071b          	addiw	a4,a2,-48
 1d4:	0ff77713          	zext.b	a4,a4
 1d8:	fee5f1e3          	bgeu	a1,a4,1ba <atoi+0x1e>
 1dc:	6422                	ld	s0,8(sp)
 1de:	0141                	addi	sp,sp,16
 1e0:	8082                	ret
 1e2:	4501                	li	a0,0
 1e4:	bfe5                	j	1dc <atoi+0x40>

00000000000001e6 <memmove>:
 1e6:	1141                	addi	sp,sp,-16
 1e8:	e422                	sd	s0,8(sp)
 1ea:	0800                	addi	s0,sp,16
 1ec:	02b57463          	bgeu	a0,a1,214 <memmove+0x2e>
 1f0:	00c05f63          	blez	a2,20e <memmove+0x28>
 1f4:	1602                	slli	a2,a2,0x20
 1f6:	9201                	srli	a2,a2,0x20
 1f8:	00c507b3          	add	a5,a0,a2
 1fc:	872a                	mv	a4,a0
 1fe:	0585                	addi	a1,a1,1
 200:	0705                	addi	a4,a4,1
 202:	fff5c683          	lbu	a3,-1(a1)
 206:	fed70fa3          	sb	a3,-1(a4)
 20a:	fee79ae3          	bne	a5,a4,1fe <memmove+0x18>
 20e:	6422                	ld	s0,8(sp)
 210:	0141                	addi	sp,sp,16
 212:	8082                	ret
 214:	00c50733          	add	a4,a0,a2
 218:	95b2                	add	a1,a1,a2
 21a:	fec05ae3          	blez	a2,20e <memmove+0x28>
 21e:	fff6079b          	addiw	a5,a2,-1
 222:	1782                	slli	a5,a5,0x20
 224:	9381                	srli	a5,a5,0x20
 226:	fff7c793          	not	a5,a5
 22a:	97ba                	add	a5,a5,a4
 22c:	15fd                	addi	a1,a1,-1
 22e:	177d                	addi	a4,a4,-1
 230:	0005c683          	lbu	a3,0(a1)
 234:	00d70023          	sb	a3,0(a4)
 238:	fee79ae3          	bne	a5,a4,22c <memmove+0x46>
 23c:	bfc9                	j	20e <memmove+0x28>

000000000000023e <memcmp>:
 23e:	1141                	addi	sp,sp,-16
 240:	e422                	sd	s0,8(sp)
 242:	0800                	addi	s0,sp,16
 244:	ca05                	beqz	a2,274 <memcmp+0x36>
 246:	fff6069b          	addiw	a3,a2,-1
 24a:	1682                	slli	a3,a3,0x20
 24c:	9281                	srli	a3,a3,0x20
 24e:	0685                	addi	a3,a3,1
 250:	96aa                	add	a3,a3,a0
 252:	00054783          	lbu	a5,0(a0)
 256:	0005c703          	lbu	a4,0(a1)
 25a:	00e79863          	bne	a5,a4,26a <memcmp+0x2c>
 25e:	0505                	addi	a0,a0,1
 260:	0585                	addi	a1,a1,1
 262:	fed518e3          	bne	a0,a3,252 <memcmp+0x14>
 266:	4501                	li	a0,0
 268:	a019                	j	26e <memcmp+0x30>
 26a:	40e7853b          	subw	a0,a5,a4
 26e:	6422                	ld	s0,8(sp)
 270:	0141                	addi	sp,sp,16
 272:	8082                	ret
 274:	4501                	li	a0,0
 276:	bfe5                	j	26e <memcmp+0x30>

0000000000000278 <memcpy>:
 278:	1141                	addi	sp,sp,-16
 27a:	e406                	sd	ra,8(sp)
 27c:	e022                	sd	s0,0(sp)
 27e:	0800                	addi	s0,sp,16
 280:	00000097          	auipc	ra,0x0
 284:	f66080e7          	jalr	-154(ra) # 1e6 <memmove>
 288:	60a2                	ld	ra,8(sp)
 28a:	6402                	ld	s0,0(sp)
 28c:	0141                	addi	sp,sp,16
 28e:	8082                	ret

0000000000000290 <fork>:
 290:	4885                	li	a7,1
 292:	00000073          	ecall
 296:	8082                	ret

0000000000000298 <exit>:
 298:	4889                	li	a7,2
 29a:	00000073          	ecall
 29e:	8082                	ret

00000000000002a0 <wait>:
 2a0:	488d                	li	a7,3
 2a2:	00000073          	ecall
 2a6:	8082                	ret

00000000000002a8 <pipe>:
 2a8:	4891                	li	a7,4
 2aa:	00000073          	ecall
 2ae:	8082                	ret

00000000000002b0 <read>:
 2b0:	4895                	li	a7,5
 2b2:	00000073          	ecall
 2b6:	8082                	ret

00000000000002b8 <write>:
 2b8:	48c1                	li	a7,16
 2ba:	00000073          	ecall
 2be:	8082                	ret

00000000000002c0 <close>:
 2c0:	48d5                	li	a7,21
 2c2:	00000073          	ecall
 2c6:	8082                	ret

00000000000002c8 <kill>:
 2c8:	4899                	li	a7,6
 2ca:	00000073          	ecall
 2ce:	8082                	ret

00000000000002d0 <exec>:
 2d0:	489d                	li	a7,7
 2d2:	00000073          	ecall
 2d6:	8082                	ret

00000000000002d8 <open>:
 2d8:	48bd                	li	a7,15
 2da:	00000073          	ecall
 2de:	8082                	ret

00000000000002e0 <mknod>:
 2e0:	48c5                	li	a7,17
 2e2:	00000073          	ecall
 2e6:	8082                	ret

00000000000002e8 <unlink>:
 2e8:	48c9                	li	a7,18
 2ea:	00000073          	ecall
 2ee:	8082                	ret

00000000000002f0 <fstat>:
 2f0:	48a1                	li	a7,8
 2f2:	00000073          	ecall
 2f6:	8082                	ret

00000000000002f8 <link>:
 2f8:	48cd                	li	a7,19
 2fa:	00000073          	ecall
 2fe:	8082                	ret

0000000000000300 <mkdir>:
 300:	48d1                	li	a7,20
 302:	00000073          	ecall
 306:	8082                	ret

0000000000000308 <chdir>:
 308:	48a5                	li	a7,9
 30a:	00000073          	ecall
 30e:	8082                	ret

0000000000000310 <dup>:
 310:	48a9                	li	a7,10
 312:	00000073          	ecall
 316:	8082                	ret

0000000000000318 <getpid>:
 318:	48ad                	li	a7,11
 31a:	00000073          	ecall
 31e:	8082                	ret

0000000000000320 <sbrk>:
 320:	48b1                	li	a7,12
 322:	00000073          	ecall
 326:	8082                	ret

0000000000000328 <sleep>:
 328:	48b5                	li	a7,13
 32a:	00000073          	ecall
 32e:	8082                	ret

0000000000000330 <uptime>:
 330:	48b9                	li	a7,14
 332:	00000073          	ecall
 336:	8082                	ret

0000000000000338 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 338:	1101                	addi	sp,sp,-32
 33a:	ec06                	sd	ra,24(sp)
 33c:	e822                	sd	s0,16(sp)
 33e:	1000                	addi	s0,sp,32
 340:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 344:	4605                	li	a2,1
 346:	fef40593          	addi	a1,s0,-17
 34a:	00000097          	auipc	ra,0x0
 34e:	f6e080e7          	jalr	-146(ra) # 2b8 <write>
}
 352:	60e2                	ld	ra,24(sp)
 354:	6442                	ld	s0,16(sp)
 356:	6105                	addi	sp,sp,32
 358:	8082                	ret

000000000000035a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 35a:	7139                	addi	sp,sp,-64
 35c:	fc06                	sd	ra,56(sp)
 35e:	f822                	sd	s0,48(sp)
 360:	f426                	sd	s1,40(sp)
 362:	f04a                	sd	s2,32(sp)
 364:	ec4e                	sd	s3,24(sp)
 366:	0080                	addi	s0,sp,64
 368:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 36a:	c299                	beqz	a3,370 <printint+0x16>
 36c:	0805c963          	bltz	a1,3fe <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 370:	2581                	sext.w	a1,a1
  neg = 0;
 372:	4881                	li	a7,0
 374:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 378:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 37a:	2601                	sext.w	a2,a2
 37c:	00000517          	auipc	a0,0x0
 380:	52450513          	addi	a0,a0,1316 # 8a0 <digits>
 384:	883a                	mv	a6,a4
 386:	2705                	addiw	a4,a4,1
 388:	02c5f7bb          	remuw	a5,a1,a2
 38c:	1782                	slli	a5,a5,0x20
 38e:	9381                	srli	a5,a5,0x20
 390:	97aa                	add	a5,a5,a0
 392:	0007c783          	lbu	a5,0(a5)
 396:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 39a:	0005879b          	sext.w	a5,a1
 39e:	02c5d5bb          	divuw	a1,a1,a2
 3a2:	0685                	addi	a3,a3,1
 3a4:	fec7f0e3          	bgeu	a5,a2,384 <printint+0x2a>
  if(neg)
 3a8:	00088c63          	beqz	a7,3c0 <printint+0x66>
    buf[i++] = '-';
 3ac:	fd070793          	addi	a5,a4,-48
 3b0:	00878733          	add	a4,a5,s0
 3b4:	02d00793          	li	a5,45
 3b8:	fef70823          	sb	a5,-16(a4)
 3bc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3c0:	02e05863          	blez	a4,3f0 <printint+0x96>
 3c4:	fc040793          	addi	a5,s0,-64
 3c8:	00e78933          	add	s2,a5,a4
 3cc:	fff78993          	addi	s3,a5,-1
 3d0:	99ba                	add	s3,s3,a4
 3d2:	377d                	addiw	a4,a4,-1
 3d4:	1702                	slli	a4,a4,0x20
 3d6:	9301                	srli	a4,a4,0x20
 3d8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3dc:	fff94583          	lbu	a1,-1(s2)
 3e0:	8526                	mv	a0,s1
 3e2:	00000097          	auipc	ra,0x0
 3e6:	f56080e7          	jalr	-170(ra) # 338 <putc>
  while(--i >= 0)
 3ea:	197d                	addi	s2,s2,-1
 3ec:	ff3918e3          	bne	s2,s3,3dc <printint+0x82>
}
 3f0:	70e2                	ld	ra,56(sp)
 3f2:	7442                	ld	s0,48(sp)
 3f4:	74a2                	ld	s1,40(sp)
 3f6:	7902                	ld	s2,32(sp)
 3f8:	69e2                	ld	s3,24(sp)
 3fa:	6121                	addi	sp,sp,64
 3fc:	8082                	ret
    x = -xx;
 3fe:	40b005bb          	negw	a1,a1
    neg = 1;
 402:	4885                	li	a7,1
    x = -xx;
 404:	bf85                	j	374 <printint+0x1a>

0000000000000406 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 406:	7119                	addi	sp,sp,-128
 408:	fc86                	sd	ra,120(sp)
 40a:	f8a2                	sd	s0,112(sp)
 40c:	f4a6                	sd	s1,104(sp)
 40e:	f0ca                	sd	s2,96(sp)
 410:	ecce                	sd	s3,88(sp)
 412:	e8d2                	sd	s4,80(sp)
 414:	e4d6                	sd	s5,72(sp)
 416:	e0da                	sd	s6,64(sp)
 418:	fc5e                	sd	s7,56(sp)
 41a:	f862                	sd	s8,48(sp)
 41c:	f466                	sd	s9,40(sp)
 41e:	f06a                	sd	s10,32(sp)
 420:	ec6e                	sd	s11,24(sp)
 422:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 424:	0005c903          	lbu	s2,0(a1)
 428:	18090f63          	beqz	s2,5c6 <vprintf+0x1c0>
 42c:	8aaa                	mv	s5,a0
 42e:	8b32                	mv	s6,a2
 430:	00158493          	addi	s1,a1,1
  state = 0;
 434:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 436:	02500a13          	li	s4,37
 43a:	4c55                	li	s8,21
 43c:	00000c97          	auipc	s9,0x0
 440:	40cc8c93          	addi	s9,s9,1036 # 848 <l_free+0x14>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 444:	02800d93          	li	s11,40
  putc(fd, 'x');
 448:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 44a:	00000b97          	auipc	s7,0x0
 44e:	456b8b93          	addi	s7,s7,1110 # 8a0 <digits>
 452:	a839                	j	470 <vprintf+0x6a>
        putc(fd, c);
 454:	85ca                	mv	a1,s2
 456:	8556                	mv	a0,s5
 458:	00000097          	auipc	ra,0x0
 45c:	ee0080e7          	jalr	-288(ra) # 338 <putc>
 460:	a019                	j	466 <vprintf+0x60>
    } else if(state == '%'){
 462:	01498d63          	beq	s3,s4,47c <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 466:	0485                	addi	s1,s1,1
 468:	fff4c903          	lbu	s2,-1(s1)
 46c:	14090d63          	beqz	s2,5c6 <vprintf+0x1c0>
    if(state == 0){
 470:	fe0999e3          	bnez	s3,462 <vprintf+0x5c>
      if(c == '%'){
 474:	ff4910e3          	bne	s2,s4,454 <vprintf+0x4e>
        state = '%';
 478:	89d2                	mv	s3,s4
 47a:	b7f5                	j	466 <vprintf+0x60>
      if(c == 'd'){
 47c:	11490c63          	beq	s2,s4,594 <vprintf+0x18e>
 480:	f9d9079b          	addiw	a5,s2,-99
 484:	0ff7f793          	zext.b	a5,a5
 488:	10fc6e63          	bltu	s8,a5,5a4 <vprintf+0x19e>
 48c:	f9d9079b          	addiw	a5,s2,-99
 490:	0ff7f713          	zext.b	a4,a5
 494:	10ec6863          	bltu	s8,a4,5a4 <vprintf+0x19e>
 498:	00271793          	slli	a5,a4,0x2
 49c:	97e6                	add	a5,a5,s9
 49e:	439c                	lw	a5,0(a5)
 4a0:	97e6                	add	a5,a5,s9
 4a2:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4a4:	008b0913          	addi	s2,s6,8
 4a8:	4685                	li	a3,1
 4aa:	4629                	li	a2,10
 4ac:	000b2583          	lw	a1,0(s6)
 4b0:	8556                	mv	a0,s5
 4b2:	00000097          	auipc	ra,0x0
 4b6:	ea8080e7          	jalr	-344(ra) # 35a <printint>
 4ba:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4bc:	4981                	li	s3,0
 4be:	b765                	j	466 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4c0:	008b0913          	addi	s2,s6,8
 4c4:	4681                	li	a3,0
 4c6:	4629                	li	a2,10
 4c8:	000b2583          	lw	a1,0(s6)
 4cc:	8556                	mv	a0,s5
 4ce:	00000097          	auipc	ra,0x0
 4d2:	e8c080e7          	jalr	-372(ra) # 35a <printint>
 4d6:	8b4a                	mv	s6,s2
      state = 0;
 4d8:	4981                	li	s3,0
 4da:	b771                	j	466 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 4dc:	008b0913          	addi	s2,s6,8
 4e0:	4681                	li	a3,0
 4e2:	866a                	mv	a2,s10
 4e4:	000b2583          	lw	a1,0(s6)
 4e8:	8556                	mv	a0,s5
 4ea:	00000097          	auipc	ra,0x0
 4ee:	e70080e7          	jalr	-400(ra) # 35a <printint>
 4f2:	8b4a                	mv	s6,s2
      state = 0;
 4f4:	4981                	li	s3,0
 4f6:	bf85                	j	466 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 4f8:	008b0793          	addi	a5,s6,8
 4fc:	f8f43423          	sd	a5,-120(s0)
 500:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 504:	03000593          	li	a1,48
 508:	8556                	mv	a0,s5
 50a:	00000097          	auipc	ra,0x0
 50e:	e2e080e7          	jalr	-466(ra) # 338 <putc>
  putc(fd, 'x');
 512:	07800593          	li	a1,120
 516:	8556                	mv	a0,s5
 518:	00000097          	auipc	ra,0x0
 51c:	e20080e7          	jalr	-480(ra) # 338 <putc>
 520:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 522:	03c9d793          	srli	a5,s3,0x3c
 526:	97de                	add	a5,a5,s7
 528:	0007c583          	lbu	a1,0(a5)
 52c:	8556                	mv	a0,s5
 52e:	00000097          	auipc	ra,0x0
 532:	e0a080e7          	jalr	-502(ra) # 338 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 536:	0992                	slli	s3,s3,0x4
 538:	397d                	addiw	s2,s2,-1
 53a:	fe0914e3          	bnez	s2,522 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 53e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 542:	4981                	li	s3,0
 544:	b70d                	j	466 <vprintf+0x60>
        s = va_arg(ap, char*);
 546:	008b0913          	addi	s2,s6,8
 54a:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 54e:	02098163          	beqz	s3,570 <vprintf+0x16a>
        while(*s != 0){
 552:	0009c583          	lbu	a1,0(s3)
 556:	c5ad                	beqz	a1,5c0 <vprintf+0x1ba>
          putc(fd, *s);
 558:	8556                	mv	a0,s5
 55a:	00000097          	auipc	ra,0x0
 55e:	dde080e7          	jalr	-546(ra) # 338 <putc>
          s++;
 562:	0985                	addi	s3,s3,1
        while(*s != 0){
 564:	0009c583          	lbu	a1,0(s3)
 568:	f9e5                	bnez	a1,558 <vprintf+0x152>
        s = va_arg(ap, char*);
 56a:	8b4a                	mv	s6,s2
      state = 0;
 56c:	4981                	li	s3,0
 56e:	bde5                	j	466 <vprintf+0x60>
          s = "(null)";
 570:	00000997          	auipc	s3,0x0
 574:	2d098993          	addi	s3,s3,720 # 840 <l_free+0xc>
        while(*s != 0){
 578:	85ee                	mv	a1,s11
 57a:	bff9                	j	558 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 57c:	008b0913          	addi	s2,s6,8
 580:	000b4583          	lbu	a1,0(s6)
 584:	8556                	mv	a0,s5
 586:	00000097          	auipc	ra,0x0
 58a:	db2080e7          	jalr	-590(ra) # 338 <putc>
 58e:	8b4a                	mv	s6,s2
      state = 0;
 590:	4981                	li	s3,0
 592:	bdd1                	j	466 <vprintf+0x60>
        putc(fd, c);
 594:	85d2                	mv	a1,s4
 596:	8556                	mv	a0,s5
 598:	00000097          	auipc	ra,0x0
 59c:	da0080e7          	jalr	-608(ra) # 338 <putc>
      state = 0;
 5a0:	4981                	li	s3,0
 5a2:	b5d1                	j	466 <vprintf+0x60>
        putc(fd, '%');
 5a4:	85d2                	mv	a1,s4
 5a6:	8556                	mv	a0,s5
 5a8:	00000097          	auipc	ra,0x0
 5ac:	d90080e7          	jalr	-624(ra) # 338 <putc>
        putc(fd, c);
 5b0:	85ca                	mv	a1,s2
 5b2:	8556                	mv	a0,s5
 5b4:	00000097          	auipc	ra,0x0
 5b8:	d84080e7          	jalr	-636(ra) # 338 <putc>
      state = 0;
 5bc:	4981                	li	s3,0
 5be:	b565                	j	466 <vprintf+0x60>
        s = va_arg(ap, char*);
 5c0:	8b4a                	mv	s6,s2
      state = 0;
 5c2:	4981                	li	s3,0
 5c4:	b54d                	j	466 <vprintf+0x60>
    }
  }
}
 5c6:	70e6                	ld	ra,120(sp)
 5c8:	7446                	ld	s0,112(sp)
 5ca:	74a6                	ld	s1,104(sp)
 5cc:	7906                	ld	s2,96(sp)
 5ce:	69e6                	ld	s3,88(sp)
 5d0:	6a46                	ld	s4,80(sp)
 5d2:	6aa6                	ld	s5,72(sp)
 5d4:	6b06                	ld	s6,64(sp)
 5d6:	7be2                	ld	s7,56(sp)
 5d8:	7c42                	ld	s8,48(sp)
 5da:	7ca2                	ld	s9,40(sp)
 5dc:	7d02                	ld	s10,32(sp)
 5de:	6de2                	ld	s11,24(sp)
 5e0:	6109                	addi	sp,sp,128
 5e2:	8082                	ret

00000000000005e4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5e4:	715d                	addi	sp,sp,-80
 5e6:	ec06                	sd	ra,24(sp)
 5e8:	e822                	sd	s0,16(sp)
 5ea:	1000                	addi	s0,sp,32
 5ec:	e010                	sd	a2,0(s0)
 5ee:	e414                	sd	a3,8(s0)
 5f0:	e818                	sd	a4,16(s0)
 5f2:	ec1c                	sd	a5,24(s0)
 5f4:	03043023          	sd	a6,32(s0)
 5f8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 5fc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 600:	8622                	mv	a2,s0
 602:	00000097          	auipc	ra,0x0
 606:	e04080e7          	jalr	-508(ra) # 406 <vprintf>
}
 60a:	60e2                	ld	ra,24(sp)
 60c:	6442                	ld	s0,16(sp)
 60e:	6161                	addi	sp,sp,80
 610:	8082                	ret

0000000000000612 <printf>:

void
printf(const char *fmt, ...)
{
 612:	711d                	addi	sp,sp,-96
 614:	ec06                	sd	ra,24(sp)
 616:	e822                	sd	s0,16(sp)
 618:	1000                	addi	s0,sp,32
 61a:	e40c                	sd	a1,8(s0)
 61c:	e810                	sd	a2,16(s0)
 61e:	ec14                	sd	a3,24(s0)
 620:	f018                	sd	a4,32(s0)
 622:	f41c                	sd	a5,40(s0)
 624:	03043823          	sd	a6,48(s0)
 628:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 62c:	00840613          	addi	a2,s0,8
 630:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 634:	85aa                	mv	a1,a0
 636:	4505                	li	a0,1
 638:	00000097          	auipc	ra,0x0
 63c:	dce080e7          	jalr	-562(ra) # 406 <vprintf>
}
 640:	60e2                	ld	ra,24(sp)
 642:	6442                	ld	s0,16(sp)
 644:	6125                	addi	sp,sp,96
 646:	8082                	ret

0000000000000648 <free>:
 648:	1141                	addi	sp,sp,-16
 64a:	e422                	sd	s0,8(sp)
 64c:	0800                	addi	s0,sp,16
 64e:	ff050693          	addi	a3,a0,-16
 652:	00000797          	auipc	a5,0x0
 656:	2767b783          	ld	a5,630(a5) # 8c8 <freep>
 65a:	a805                	j	68a <free+0x42>
 65c:	4618                	lw	a4,8(a2)
 65e:	9db9                	addw	a1,a1,a4
 660:	feb52c23          	sw	a1,-8(a0)
 664:	6398                	ld	a4,0(a5)
 666:	6318                	ld	a4,0(a4)
 668:	fee53823          	sd	a4,-16(a0)
 66c:	a091                	j	6b0 <free+0x68>
 66e:	ff852703          	lw	a4,-8(a0)
 672:	9e39                	addw	a2,a2,a4
 674:	c790                	sw	a2,8(a5)
 676:	ff053703          	ld	a4,-16(a0)
 67a:	e398                	sd	a4,0(a5)
 67c:	a099                	j	6c2 <free+0x7a>
 67e:	6398                	ld	a4,0(a5)
 680:	00e7e463          	bltu	a5,a4,688 <free+0x40>
 684:	00e6ea63          	bltu	a3,a4,698 <free+0x50>
 688:	87ba                	mv	a5,a4
 68a:	fed7fae3          	bgeu	a5,a3,67e <free+0x36>
 68e:	6398                	ld	a4,0(a5)
 690:	00e6e463          	bltu	a3,a4,698 <free+0x50>
 694:	fee7eae3          	bltu	a5,a4,688 <free+0x40>
 698:	ff852583          	lw	a1,-8(a0)
 69c:	6390                	ld	a2,0(a5)
 69e:	02059713          	slli	a4,a1,0x20
 6a2:	9301                	srli	a4,a4,0x20
 6a4:	0712                	slli	a4,a4,0x4
 6a6:	9736                	add	a4,a4,a3
 6a8:	fae60ae3          	beq	a2,a4,65c <free+0x14>
 6ac:	fec53823          	sd	a2,-16(a0)
 6b0:	4790                	lw	a2,8(a5)
 6b2:	02061713          	slli	a4,a2,0x20
 6b6:	9301                	srli	a4,a4,0x20
 6b8:	0712                	slli	a4,a4,0x4
 6ba:	973e                	add	a4,a4,a5
 6bc:	fae689e3          	beq	a3,a4,66e <free+0x26>
 6c0:	e394                	sd	a3,0(a5)
 6c2:	00000717          	auipc	a4,0x0
 6c6:	20f73323          	sd	a5,518(a4) # 8c8 <freep>
 6ca:	6422                	ld	s0,8(sp)
 6cc:	0141                	addi	sp,sp,16
 6ce:	8082                	ret

00000000000006d0 <malloc>:
 6d0:	7139                	addi	sp,sp,-64
 6d2:	fc06                	sd	ra,56(sp)
 6d4:	f822                	sd	s0,48(sp)
 6d6:	f426                	sd	s1,40(sp)
 6d8:	f04a                	sd	s2,32(sp)
 6da:	ec4e                	sd	s3,24(sp)
 6dc:	e852                	sd	s4,16(sp)
 6de:	e456                	sd	s5,8(sp)
 6e0:	e05a                	sd	s6,0(sp)
 6e2:	0080                	addi	s0,sp,64
 6e4:	02051493          	slli	s1,a0,0x20
 6e8:	9081                	srli	s1,s1,0x20
 6ea:	04bd                	addi	s1,s1,15
 6ec:	8091                	srli	s1,s1,0x4
 6ee:	0014899b          	addiw	s3,s1,1
 6f2:	0485                	addi	s1,s1,1
 6f4:	00000517          	auipc	a0,0x0
 6f8:	1d453503          	ld	a0,468(a0) # 8c8 <freep>
 6fc:	c515                	beqz	a0,728 <malloc+0x58>
 6fe:	611c                	ld	a5,0(a0)
 700:	4798                	lw	a4,8(a5)
 702:	02977f63          	bgeu	a4,s1,740 <malloc+0x70>
 706:	8a4e                	mv	s4,s3
 708:	0009871b          	sext.w	a4,s3
 70c:	6685                	lui	a3,0x1
 70e:	00d77363          	bgeu	a4,a3,714 <malloc+0x44>
 712:	6a05                	lui	s4,0x1
 714:	000a0b1b          	sext.w	s6,s4
 718:	004a1a1b          	slliw	s4,s4,0x4
 71c:	00000917          	auipc	s2,0x0
 720:	1ac90913          	addi	s2,s2,428 # 8c8 <freep>
 724:	5afd                	li	s5,-1
 726:	a88d                	j	798 <malloc+0xc8>
 728:	00000797          	auipc	a5,0x0
 72c:	1a878793          	addi	a5,a5,424 # 8d0 <base>
 730:	00000717          	auipc	a4,0x0
 734:	18f73c23          	sd	a5,408(a4) # 8c8 <freep>
 738:	e39c                	sd	a5,0(a5)
 73a:	0007a423          	sw	zero,8(a5)
 73e:	b7e1                	j	706 <malloc+0x36>
 740:	02e48b63          	beq	s1,a4,776 <malloc+0xa6>
 744:	4137073b          	subw	a4,a4,s3
 748:	c798                	sw	a4,8(a5)
 74a:	1702                	slli	a4,a4,0x20
 74c:	9301                	srli	a4,a4,0x20
 74e:	0712                	slli	a4,a4,0x4
 750:	97ba                	add	a5,a5,a4
 752:	0137a423          	sw	s3,8(a5)
 756:	00000717          	auipc	a4,0x0
 75a:	16a73923          	sd	a0,370(a4) # 8c8 <freep>
 75e:	01078513          	addi	a0,a5,16
 762:	70e2                	ld	ra,56(sp)
 764:	7442                	ld	s0,48(sp)
 766:	74a2                	ld	s1,40(sp)
 768:	7902                	ld	s2,32(sp)
 76a:	69e2                	ld	s3,24(sp)
 76c:	6a42                	ld	s4,16(sp)
 76e:	6aa2                	ld	s5,8(sp)
 770:	6b02                	ld	s6,0(sp)
 772:	6121                	addi	sp,sp,64
 774:	8082                	ret
 776:	6398                	ld	a4,0(a5)
 778:	e118                	sd	a4,0(a0)
 77a:	bff1                	j	756 <malloc+0x86>
 77c:	01652423          	sw	s6,8(a0)
 780:	0541                	addi	a0,a0,16
 782:	00000097          	auipc	ra,0x0
 786:	ec6080e7          	jalr	-314(ra) # 648 <free>
 78a:	00093503          	ld	a0,0(s2)
 78e:	d971                	beqz	a0,762 <malloc+0x92>
 790:	611c                	ld	a5,0(a0)
 792:	4798                	lw	a4,8(a5)
 794:	fa9776e3          	bgeu	a4,s1,740 <malloc+0x70>
 798:	00093703          	ld	a4,0(s2)
 79c:	853e                	mv	a0,a5
 79e:	fef719e3          	bne	a4,a5,790 <malloc+0xc0>
 7a2:	8552                	mv	a0,s4
 7a4:	00000097          	auipc	ra,0x0
 7a8:	b7c080e7          	jalr	-1156(ra) # 320 <sbrk>
 7ac:	fd5518e3          	bne	a0,s5,77c <malloc+0xac>
 7b0:	4501                	li	a0,0
 7b2:	bf45                	j	762 <malloc+0x92>

00000000000007b4 <mem_init>:
 7b4:	1141                	addi	sp,sp,-16
 7b6:	e406                	sd	ra,8(sp)
 7b8:	e022                	sd	s0,0(sp)
 7ba:	0800                	addi	s0,sp,16
 7bc:	6505                	lui	a0,0x1
 7be:	00000097          	auipc	ra,0x0
 7c2:	b62080e7          	jalr	-1182(ra) # 320 <sbrk>
 7c6:	00000797          	auipc	a5,0x0
 7ca:	0ea7bd23          	sd	a0,250(a5) # 8c0 <alloc>
 7ce:	00850793          	addi	a5,a0,8 # 1008 <__BSS_END__+0x728>
 7d2:	e11c                	sd	a5,0(a0)
 7d4:	60a2                	ld	ra,8(sp)
 7d6:	6402                	ld	s0,0(sp)
 7d8:	0141                	addi	sp,sp,16
 7da:	8082                	ret

00000000000007dc <l_alloc>:
 7dc:	1101                	addi	sp,sp,-32
 7de:	ec06                	sd	ra,24(sp)
 7e0:	e822                	sd	s0,16(sp)
 7e2:	e426                	sd	s1,8(sp)
 7e4:	1000                	addi	s0,sp,32
 7e6:	84aa                	mv	s1,a0
 7e8:	00000797          	auipc	a5,0x0
 7ec:	0d07a783          	lw	a5,208(a5) # 8b8 <if_init>
 7f0:	c795                	beqz	a5,81c <l_alloc+0x40>
 7f2:	00000717          	auipc	a4,0x0
 7f6:	0ce73703          	ld	a4,206(a4) # 8c0 <alloc>
 7fa:	6308                	ld	a0,0(a4)
 7fc:	40e506b3          	sub	a3,a0,a4
 800:	6785                	lui	a5,0x1
 802:	37e1                	addiw	a5,a5,-8
 804:	9f95                	subw	a5,a5,a3
 806:	02f4f563          	bgeu	s1,a5,830 <l_alloc+0x54>
 80a:	1482                	slli	s1,s1,0x20
 80c:	9081                	srli	s1,s1,0x20
 80e:	94aa                	add	s1,s1,a0
 810:	e304                	sd	s1,0(a4)
 812:	60e2                	ld	ra,24(sp)
 814:	6442                	ld	s0,16(sp)
 816:	64a2                	ld	s1,8(sp)
 818:	6105                	addi	sp,sp,32
 81a:	8082                	ret
 81c:	00000097          	auipc	ra,0x0
 820:	f98080e7          	jalr	-104(ra) # 7b4 <mem_init>
 824:	4785                	li	a5,1
 826:	00000717          	auipc	a4,0x0
 82a:	08f72923          	sw	a5,146(a4) # 8b8 <if_init>
 82e:	b7d1                	j	7f2 <l_alloc+0x16>
 830:	4501                	li	a0,0
 832:	b7c5                	j	812 <l_alloc+0x36>

0000000000000834 <l_free>:
 834:	1141                	addi	sp,sp,-16
 836:	e422                	sd	s0,8(sp)
 838:	0800                	addi	s0,sp,16
 83a:	6422                	ld	s0,8(sp)
 83c:	0141                	addi	sp,sp,16
 83e:	8082                	ret
