
user/_hello:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	e05a                	sd	s6,0(sp)
  12:	0080                	addi	s0,sp,64
  14:	4789                	li	a5,2
  16:	00f50f63          	beq	a0,a5,34 <main+0x34>
  1a:	00001517          	auipc	a0,0x1
  1e:	8a650513          	addi	a0,a0,-1882 # 8c0 <l_free+0x10>
  22:	00000097          	auipc	ra,0x0
  26:	66c080e7          	jalr	1644(ra) # 68e <printf>
  2a:	4501                	li	a0,0
  2c:	00000097          	auipc	ra,0x0
  30:	2e8080e7          	jalr	744(ra) # 314 <exit>
  34:	89ae                	mv	s3,a1
  36:	45a1                	li	a1,8
  38:	00001517          	auipc	a0,0x1
  3c:	8a850513          	addi	a0,a0,-1880 # 8e0 <l_free+0x30>
  40:	00000097          	auipc	ra,0x0
  44:	64e080e7          	jalr	1614(ra) # 68e <printf>
  48:	4901                	li	s2,0
  4a:	4b69                	li	s6,26
  4c:	00001a97          	auipc	s5,0x1
  50:	8a4a8a93          	addi	s5,s5,-1884 # 8f0 <l_free+0x40>
  54:	3e800a13          	li	s4,1000
  58:	4525                	li	a0,9
  5a:	00000097          	auipc	ra,0x0
  5e:	7fe080e7          	jalr	2046(ra) # 858 <l_alloc>
  62:	84aa                	mv	s1,a0
  64:	cd05                	beqz	a0,9c <main+0x9c>
  66:	0089b583          	ld	a1,8(s3)
  6a:	00000097          	auipc	ra,0x0
  6e:	03c080e7          	jalr	60(ra) # a6 <strcpy>
  72:	036967bb          	remw	a5,s2,s6
  76:	0617879b          	addiw	a5,a5,97
  7a:	00f48023          	sb	a5,0(s1)
  7e:	8626                	mv	a2,s1
  80:	85a6                	mv	a1,s1
  82:	8556                	mv	a0,s5
  84:	00000097          	auipc	ra,0x0
  88:	60a080e7          	jalr	1546(ra) # 68e <printf>
  8c:	2905                	addiw	s2,s2,1
  8e:	fd4915e3          	bne	s2,s4,58 <main+0x58>
  92:	4501                	li	a0,0
  94:	00000097          	auipc	ra,0x0
  98:	280080e7          	jalr	640(ra) # 314 <exit>
  9c:	4501                	li	a0,0
  9e:	00000097          	auipc	ra,0x0
  a2:	276080e7          	jalr	630(ra) # 314 <exit>

00000000000000a6 <strcpy>:
  a6:	1141                	addi	sp,sp,-16
  a8:	e422                	sd	s0,8(sp)
  aa:	0800                	addi	s0,sp,16
  ac:	87aa                	mv	a5,a0
  ae:	0585                	addi	a1,a1,1
  b0:	0785                	addi	a5,a5,1
  b2:	fff5c703          	lbu	a4,-1(a1)
  b6:	fee78fa3          	sb	a4,-1(a5)
  ba:	fb75                	bnez	a4,ae <strcpy+0x8>
  bc:	6422                	ld	s0,8(sp)
  be:	0141                	addi	sp,sp,16
  c0:	8082                	ret

00000000000000c2 <strcmp>:
  c2:	1141                	addi	sp,sp,-16
  c4:	e422                	sd	s0,8(sp)
  c6:	0800                	addi	s0,sp,16
  c8:	00054783          	lbu	a5,0(a0)
  cc:	cb91                	beqz	a5,e0 <strcmp+0x1e>
  ce:	0005c703          	lbu	a4,0(a1)
  d2:	00f71763          	bne	a4,a5,e0 <strcmp+0x1e>
  d6:	0505                	addi	a0,a0,1
  d8:	0585                	addi	a1,a1,1
  da:	00054783          	lbu	a5,0(a0)
  de:	fbe5                	bnez	a5,ce <strcmp+0xc>
  e0:	0005c503          	lbu	a0,0(a1)
  e4:	40a7853b          	subw	a0,a5,a0
  e8:	6422                	ld	s0,8(sp)
  ea:	0141                	addi	sp,sp,16
  ec:	8082                	ret

00000000000000ee <strlen>:
  ee:	1141                	addi	sp,sp,-16
  f0:	e422                	sd	s0,8(sp)
  f2:	0800                	addi	s0,sp,16
  f4:	00054783          	lbu	a5,0(a0)
  f8:	cf91                	beqz	a5,114 <strlen+0x26>
  fa:	0505                	addi	a0,a0,1
  fc:	87aa                	mv	a5,a0
  fe:	4685                	li	a3,1
 100:	9e89                	subw	a3,a3,a0
 102:	00f6853b          	addw	a0,a3,a5
 106:	0785                	addi	a5,a5,1
 108:	fff7c703          	lbu	a4,-1(a5)
 10c:	fb7d                	bnez	a4,102 <strlen+0x14>
 10e:	6422                	ld	s0,8(sp)
 110:	0141                	addi	sp,sp,16
 112:	8082                	ret
 114:	4501                	li	a0,0
 116:	bfe5                	j	10e <strlen+0x20>

0000000000000118 <memset>:
 118:	1141                	addi	sp,sp,-16
 11a:	e422                	sd	s0,8(sp)
 11c:	0800                	addi	s0,sp,16
 11e:	ca19                	beqz	a2,134 <memset+0x1c>
 120:	87aa                	mv	a5,a0
 122:	1602                	slli	a2,a2,0x20
 124:	9201                	srli	a2,a2,0x20
 126:	00a60733          	add	a4,a2,a0
 12a:	00b78023          	sb	a1,0(a5)
 12e:	0785                	addi	a5,a5,1
 130:	fee79de3          	bne	a5,a4,12a <memset+0x12>
 134:	6422                	ld	s0,8(sp)
 136:	0141                	addi	sp,sp,16
 138:	8082                	ret

000000000000013a <strchr>:
 13a:	1141                	addi	sp,sp,-16
 13c:	e422                	sd	s0,8(sp)
 13e:	0800                	addi	s0,sp,16
 140:	00054783          	lbu	a5,0(a0)
 144:	cb99                	beqz	a5,15a <strchr+0x20>
 146:	00f58763          	beq	a1,a5,154 <strchr+0x1a>
 14a:	0505                	addi	a0,a0,1
 14c:	00054783          	lbu	a5,0(a0)
 150:	fbfd                	bnez	a5,146 <strchr+0xc>
 152:	4501                	li	a0,0
 154:	6422                	ld	s0,8(sp)
 156:	0141                	addi	sp,sp,16
 158:	8082                	ret
 15a:	4501                	li	a0,0
 15c:	bfe5                	j	154 <strchr+0x1a>

000000000000015e <gets>:
 15e:	711d                	addi	sp,sp,-96
 160:	ec86                	sd	ra,88(sp)
 162:	e8a2                	sd	s0,80(sp)
 164:	e4a6                	sd	s1,72(sp)
 166:	e0ca                	sd	s2,64(sp)
 168:	fc4e                	sd	s3,56(sp)
 16a:	f852                	sd	s4,48(sp)
 16c:	f456                	sd	s5,40(sp)
 16e:	f05a                	sd	s6,32(sp)
 170:	ec5e                	sd	s7,24(sp)
 172:	1080                	addi	s0,sp,96
 174:	8baa                	mv	s7,a0
 176:	8a2e                	mv	s4,a1
 178:	892a                	mv	s2,a0
 17a:	4481                	li	s1,0
 17c:	4aa9                	li	s5,10
 17e:	4b35                	li	s6,13
 180:	89a6                	mv	s3,s1
 182:	2485                	addiw	s1,s1,1
 184:	0344d863          	bge	s1,s4,1b4 <gets+0x56>
 188:	4605                	li	a2,1
 18a:	faf40593          	addi	a1,s0,-81
 18e:	4501                	li	a0,0
 190:	00000097          	auipc	ra,0x0
 194:	19c080e7          	jalr	412(ra) # 32c <read>
 198:	00a05e63          	blez	a0,1b4 <gets+0x56>
 19c:	faf44783          	lbu	a5,-81(s0)
 1a0:	00f90023          	sb	a5,0(s2)
 1a4:	01578763          	beq	a5,s5,1b2 <gets+0x54>
 1a8:	0905                	addi	s2,s2,1
 1aa:	fd679be3          	bne	a5,s6,180 <gets+0x22>
 1ae:	89a6                	mv	s3,s1
 1b0:	a011                	j	1b4 <gets+0x56>
 1b2:	89a6                	mv	s3,s1
 1b4:	99de                	add	s3,s3,s7
 1b6:	00098023          	sb	zero,0(s3)
 1ba:	855e                	mv	a0,s7
 1bc:	60e6                	ld	ra,88(sp)
 1be:	6446                	ld	s0,80(sp)
 1c0:	64a6                	ld	s1,72(sp)
 1c2:	6906                	ld	s2,64(sp)
 1c4:	79e2                	ld	s3,56(sp)
 1c6:	7a42                	ld	s4,48(sp)
 1c8:	7aa2                	ld	s5,40(sp)
 1ca:	7b02                	ld	s6,32(sp)
 1cc:	6be2                	ld	s7,24(sp)
 1ce:	6125                	addi	sp,sp,96
 1d0:	8082                	ret

00000000000001d2 <stat>:
 1d2:	1101                	addi	sp,sp,-32
 1d4:	ec06                	sd	ra,24(sp)
 1d6:	e822                	sd	s0,16(sp)
 1d8:	e426                	sd	s1,8(sp)
 1da:	e04a                	sd	s2,0(sp)
 1dc:	1000                	addi	s0,sp,32
 1de:	892e                	mv	s2,a1
 1e0:	4581                	li	a1,0
 1e2:	00000097          	auipc	ra,0x0
 1e6:	172080e7          	jalr	370(ra) # 354 <open>
 1ea:	02054563          	bltz	a0,214 <stat+0x42>
 1ee:	84aa                	mv	s1,a0
 1f0:	85ca                	mv	a1,s2
 1f2:	00000097          	auipc	ra,0x0
 1f6:	17a080e7          	jalr	378(ra) # 36c <fstat>
 1fa:	892a                	mv	s2,a0
 1fc:	8526                	mv	a0,s1
 1fe:	00000097          	auipc	ra,0x0
 202:	13e080e7          	jalr	318(ra) # 33c <close>
 206:	854a                	mv	a0,s2
 208:	60e2                	ld	ra,24(sp)
 20a:	6442                	ld	s0,16(sp)
 20c:	64a2                	ld	s1,8(sp)
 20e:	6902                	ld	s2,0(sp)
 210:	6105                	addi	sp,sp,32
 212:	8082                	ret
 214:	597d                	li	s2,-1
 216:	bfc5                	j	206 <stat+0x34>

0000000000000218 <atoi>:
 218:	1141                	addi	sp,sp,-16
 21a:	e422                	sd	s0,8(sp)
 21c:	0800                	addi	s0,sp,16
 21e:	00054603          	lbu	a2,0(a0)
 222:	fd06079b          	addiw	a5,a2,-48
 226:	0ff7f793          	zext.b	a5,a5
 22a:	4725                	li	a4,9
 22c:	02f76963          	bltu	a4,a5,25e <atoi+0x46>
 230:	86aa                	mv	a3,a0
 232:	4501                	li	a0,0
 234:	45a5                	li	a1,9
 236:	0685                	addi	a3,a3,1
 238:	0025179b          	slliw	a5,a0,0x2
 23c:	9fa9                	addw	a5,a5,a0
 23e:	0017979b          	slliw	a5,a5,0x1
 242:	9fb1                	addw	a5,a5,a2
 244:	fd07851b          	addiw	a0,a5,-48
 248:	0006c603          	lbu	a2,0(a3)
 24c:	fd06071b          	addiw	a4,a2,-48
 250:	0ff77713          	zext.b	a4,a4
 254:	fee5f1e3          	bgeu	a1,a4,236 <atoi+0x1e>
 258:	6422                	ld	s0,8(sp)
 25a:	0141                	addi	sp,sp,16
 25c:	8082                	ret
 25e:	4501                	li	a0,0
 260:	bfe5                	j	258 <atoi+0x40>

0000000000000262 <memmove>:
 262:	1141                	addi	sp,sp,-16
 264:	e422                	sd	s0,8(sp)
 266:	0800                	addi	s0,sp,16
 268:	02b57463          	bgeu	a0,a1,290 <memmove+0x2e>
 26c:	00c05f63          	blez	a2,28a <memmove+0x28>
 270:	1602                	slli	a2,a2,0x20
 272:	9201                	srli	a2,a2,0x20
 274:	00c507b3          	add	a5,a0,a2
 278:	872a                	mv	a4,a0
 27a:	0585                	addi	a1,a1,1
 27c:	0705                	addi	a4,a4,1
 27e:	fff5c683          	lbu	a3,-1(a1)
 282:	fed70fa3          	sb	a3,-1(a4)
 286:	fee79ae3          	bne	a5,a4,27a <memmove+0x18>
 28a:	6422                	ld	s0,8(sp)
 28c:	0141                	addi	sp,sp,16
 28e:	8082                	ret
 290:	00c50733          	add	a4,a0,a2
 294:	95b2                	add	a1,a1,a2
 296:	fec05ae3          	blez	a2,28a <memmove+0x28>
 29a:	fff6079b          	addiw	a5,a2,-1
 29e:	1782                	slli	a5,a5,0x20
 2a0:	9381                	srli	a5,a5,0x20
 2a2:	fff7c793          	not	a5,a5
 2a6:	97ba                	add	a5,a5,a4
 2a8:	15fd                	addi	a1,a1,-1
 2aa:	177d                	addi	a4,a4,-1
 2ac:	0005c683          	lbu	a3,0(a1)
 2b0:	00d70023          	sb	a3,0(a4)
 2b4:	fee79ae3          	bne	a5,a4,2a8 <memmove+0x46>
 2b8:	bfc9                	j	28a <memmove+0x28>

00000000000002ba <memcmp>:
 2ba:	1141                	addi	sp,sp,-16
 2bc:	e422                	sd	s0,8(sp)
 2be:	0800                	addi	s0,sp,16
 2c0:	ca05                	beqz	a2,2f0 <memcmp+0x36>
 2c2:	fff6069b          	addiw	a3,a2,-1
 2c6:	1682                	slli	a3,a3,0x20
 2c8:	9281                	srli	a3,a3,0x20
 2ca:	0685                	addi	a3,a3,1
 2cc:	96aa                	add	a3,a3,a0
 2ce:	00054783          	lbu	a5,0(a0)
 2d2:	0005c703          	lbu	a4,0(a1)
 2d6:	00e79863          	bne	a5,a4,2e6 <memcmp+0x2c>
 2da:	0505                	addi	a0,a0,1
 2dc:	0585                	addi	a1,a1,1
 2de:	fed518e3          	bne	a0,a3,2ce <memcmp+0x14>
 2e2:	4501                	li	a0,0
 2e4:	a019                	j	2ea <memcmp+0x30>
 2e6:	40e7853b          	subw	a0,a5,a4
 2ea:	6422                	ld	s0,8(sp)
 2ec:	0141                	addi	sp,sp,16
 2ee:	8082                	ret
 2f0:	4501                	li	a0,0
 2f2:	bfe5                	j	2ea <memcmp+0x30>

00000000000002f4 <memcpy>:
 2f4:	1141                	addi	sp,sp,-16
 2f6:	e406                	sd	ra,8(sp)
 2f8:	e022                	sd	s0,0(sp)
 2fa:	0800                	addi	s0,sp,16
 2fc:	00000097          	auipc	ra,0x0
 300:	f66080e7          	jalr	-154(ra) # 262 <memmove>
 304:	60a2                	ld	ra,8(sp)
 306:	6402                	ld	s0,0(sp)
 308:	0141                	addi	sp,sp,16
 30a:	8082                	ret

000000000000030c <fork>:
 30c:	4885                	li	a7,1
 30e:	00000073          	ecall
 312:	8082                	ret

0000000000000314 <exit>:
 314:	4889                	li	a7,2
 316:	00000073          	ecall
 31a:	8082                	ret

000000000000031c <wait>:
 31c:	488d                	li	a7,3
 31e:	00000073          	ecall
 322:	8082                	ret

0000000000000324 <pipe>:
 324:	4891                	li	a7,4
 326:	00000073          	ecall
 32a:	8082                	ret

000000000000032c <read>:
 32c:	4895                	li	a7,5
 32e:	00000073          	ecall
 332:	8082                	ret

0000000000000334 <write>:
 334:	48c1                	li	a7,16
 336:	00000073          	ecall
 33a:	8082                	ret

000000000000033c <close>:
 33c:	48d5                	li	a7,21
 33e:	00000073          	ecall
 342:	8082                	ret

0000000000000344 <kill>:
 344:	4899                	li	a7,6
 346:	00000073          	ecall
 34a:	8082                	ret

000000000000034c <exec>:
 34c:	489d                	li	a7,7
 34e:	00000073          	ecall
 352:	8082                	ret

0000000000000354 <open>:
 354:	48bd                	li	a7,15
 356:	00000073          	ecall
 35a:	8082                	ret

000000000000035c <mknod>:
 35c:	48c5                	li	a7,17
 35e:	00000073          	ecall
 362:	8082                	ret

0000000000000364 <unlink>:
 364:	48c9                	li	a7,18
 366:	00000073          	ecall
 36a:	8082                	ret

000000000000036c <fstat>:
 36c:	48a1                	li	a7,8
 36e:	00000073          	ecall
 372:	8082                	ret

0000000000000374 <link>:
 374:	48cd                	li	a7,19
 376:	00000073          	ecall
 37a:	8082                	ret

000000000000037c <mkdir>:
 37c:	48d1                	li	a7,20
 37e:	00000073          	ecall
 382:	8082                	ret

0000000000000384 <chdir>:
 384:	48a5                	li	a7,9
 386:	00000073          	ecall
 38a:	8082                	ret

000000000000038c <dup>:
 38c:	48a9                	li	a7,10
 38e:	00000073          	ecall
 392:	8082                	ret

0000000000000394 <getpid>:
 394:	48ad                	li	a7,11
 396:	00000073          	ecall
 39a:	8082                	ret

000000000000039c <sbrk>:
 39c:	48b1                	li	a7,12
 39e:	00000073          	ecall
 3a2:	8082                	ret

00000000000003a4 <sleep>:
 3a4:	48b5                	li	a7,13
 3a6:	00000073          	ecall
 3aa:	8082                	ret

00000000000003ac <uptime>:
 3ac:	48b9                	li	a7,14
 3ae:	00000073          	ecall
 3b2:	8082                	ret

00000000000003b4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3b4:	1101                	addi	sp,sp,-32
 3b6:	ec06                	sd	ra,24(sp)
 3b8:	e822                	sd	s0,16(sp)
 3ba:	1000                	addi	s0,sp,32
 3bc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3c0:	4605                	li	a2,1
 3c2:	fef40593          	addi	a1,s0,-17
 3c6:	00000097          	auipc	ra,0x0
 3ca:	f6e080e7          	jalr	-146(ra) # 334 <write>
}
 3ce:	60e2                	ld	ra,24(sp)
 3d0:	6442                	ld	s0,16(sp)
 3d2:	6105                	addi	sp,sp,32
 3d4:	8082                	ret

00000000000003d6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3d6:	7139                	addi	sp,sp,-64
 3d8:	fc06                	sd	ra,56(sp)
 3da:	f822                	sd	s0,48(sp)
 3dc:	f426                	sd	s1,40(sp)
 3de:	f04a                	sd	s2,32(sp)
 3e0:	ec4e                	sd	s3,24(sp)
 3e2:	0080                	addi	s0,sp,64
 3e4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3e6:	c299                	beqz	a3,3ec <printint+0x16>
 3e8:	0805c963          	bltz	a1,47a <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3ec:	2581                	sext.w	a1,a1
  neg = 0;
 3ee:	4881                	li	a7,0
 3f0:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3f4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3f6:	2601                	sext.w	a2,a2
 3f8:	00000517          	auipc	a0,0x0
 3fc:	56850513          	addi	a0,a0,1384 # 960 <digits>
 400:	883a                	mv	a6,a4
 402:	2705                	addiw	a4,a4,1
 404:	02c5f7bb          	remuw	a5,a1,a2
 408:	1782                	slli	a5,a5,0x20
 40a:	9381                	srli	a5,a5,0x20
 40c:	97aa                	add	a5,a5,a0
 40e:	0007c783          	lbu	a5,0(a5)
 412:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 416:	0005879b          	sext.w	a5,a1
 41a:	02c5d5bb          	divuw	a1,a1,a2
 41e:	0685                	addi	a3,a3,1
 420:	fec7f0e3          	bgeu	a5,a2,400 <printint+0x2a>
  if(neg)
 424:	00088c63          	beqz	a7,43c <printint+0x66>
    buf[i++] = '-';
 428:	fd070793          	addi	a5,a4,-48
 42c:	00878733          	add	a4,a5,s0
 430:	02d00793          	li	a5,45
 434:	fef70823          	sb	a5,-16(a4)
 438:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 43c:	02e05863          	blez	a4,46c <printint+0x96>
 440:	fc040793          	addi	a5,s0,-64
 444:	00e78933          	add	s2,a5,a4
 448:	fff78993          	addi	s3,a5,-1
 44c:	99ba                	add	s3,s3,a4
 44e:	377d                	addiw	a4,a4,-1
 450:	1702                	slli	a4,a4,0x20
 452:	9301                	srli	a4,a4,0x20
 454:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 458:	fff94583          	lbu	a1,-1(s2)
 45c:	8526                	mv	a0,s1
 45e:	00000097          	auipc	ra,0x0
 462:	f56080e7          	jalr	-170(ra) # 3b4 <putc>
  while(--i >= 0)
 466:	197d                	addi	s2,s2,-1
 468:	ff3918e3          	bne	s2,s3,458 <printint+0x82>
}
 46c:	70e2                	ld	ra,56(sp)
 46e:	7442                	ld	s0,48(sp)
 470:	74a2                	ld	s1,40(sp)
 472:	7902                	ld	s2,32(sp)
 474:	69e2                	ld	s3,24(sp)
 476:	6121                	addi	sp,sp,64
 478:	8082                	ret
    x = -xx;
 47a:	40b005bb          	negw	a1,a1
    neg = 1;
 47e:	4885                	li	a7,1
    x = -xx;
 480:	bf85                	j	3f0 <printint+0x1a>

0000000000000482 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 482:	7119                	addi	sp,sp,-128
 484:	fc86                	sd	ra,120(sp)
 486:	f8a2                	sd	s0,112(sp)
 488:	f4a6                	sd	s1,104(sp)
 48a:	f0ca                	sd	s2,96(sp)
 48c:	ecce                	sd	s3,88(sp)
 48e:	e8d2                	sd	s4,80(sp)
 490:	e4d6                	sd	s5,72(sp)
 492:	e0da                	sd	s6,64(sp)
 494:	fc5e                	sd	s7,56(sp)
 496:	f862                	sd	s8,48(sp)
 498:	f466                	sd	s9,40(sp)
 49a:	f06a                	sd	s10,32(sp)
 49c:	ec6e                	sd	s11,24(sp)
 49e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4a0:	0005c903          	lbu	s2,0(a1)
 4a4:	18090f63          	beqz	s2,642 <vprintf+0x1c0>
 4a8:	8aaa                	mv	s5,a0
 4aa:	8b32                	mv	s6,a2
 4ac:	00158493          	addi	s1,a1,1
  state = 0;
 4b0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4b2:	02500a13          	li	s4,37
 4b6:	4c55                	li	s8,21
 4b8:	00000c97          	auipc	s9,0x0
 4bc:	450c8c93          	addi	s9,s9,1104 # 908 <l_free+0x58>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 4c0:	02800d93          	li	s11,40
  putc(fd, 'x');
 4c4:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4c6:	00000b97          	auipc	s7,0x0
 4ca:	49ab8b93          	addi	s7,s7,1178 # 960 <digits>
 4ce:	a839                	j	4ec <vprintf+0x6a>
        putc(fd, c);
 4d0:	85ca                	mv	a1,s2
 4d2:	8556                	mv	a0,s5
 4d4:	00000097          	auipc	ra,0x0
 4d8:	ee0080e7          	jalr	-288(ra) # 3b4 <putc>
 4dc:	a019                	j	4e2 <vprintf+0x60>
    } else if(state == '%'){
 4de:	01498d63          	beq	s3,s4,4f8 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 4e2:	0485                	addi	s1,s1,1
 4e4:	fff4c903          	lbu	s2,-1(s1)
 4e8:	14090d63          	beqz	s2,642 <vprintf+0x1c0>
    if(state == 0){
 4ec:	fe0999e3          	bnez	s3,4de <vprintf+0x5c>
      if(c == '%'){
 4f0:	ff4910e3          	bne	s2,s4,4d0 <vprintf+0x4e>
        state = '%';
 4f4:	89d2                	mv	s3,s4
 4f6:	b7f5                	j	4e2 <vprintf+0x60>
      if(c == 'd'){
 4f8:	11490c63          	beq	s2,s4,610 <vprintf+0x18e>
 4fc:	f9d9079b          	addiw	a5,s2,-99
 500:	0ff7f793          	zext.b	a5,a5
 504:	10fc6e63          	bltu	s8,a5,620 <vprintf+0x19e>
 508:	f9d9079b          	addiw	a5,s2,-99
 50c:	0ff7f713          	zext.b	a4,a5
 510:	10ec6863          	bltu	s8,a4,620 <vprintf+0x19e>
 514:	00271793          	slli	a5,a4,0x2
 518:	97e6                	add	a5,a5,s9
 51a:	439c                	lw	a5,0(a5)
 51c:	97e6                	add	a5,a5,s9
 51e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 520:	008b0913          	addi	s2,s6,8
 524:	4685                	li	a3,1
 526:	4629                	li	a2,10
 528:	000b2583          	lw	a1,0(s6)
 52c:	8556                	mv	a0,s5
 52e:	00000097          	auipc	ra,0x0
 532:	ea8080e7          	jalr	-344(ra) # 3d6 <printint>
 536:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 538:	4981                	li	s3,0
 53a:	b765                	j	4e2 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 53c:	008b0913          	addi	s2,s6,8
 540:	4681                	li	a3,0
 542:	4629                	li	a2,10
 544:	000b2583          	lw	a1,0(s6)
 548:	8556                	mv	a0,s5
 54a:	00000097          	auipc	ra,0x0
 54e:	e8c080e7          	jalr	-372(ra) # 3d6 <printint>
 552:	8b4a                	mv	s6,s2
      state = 0;
 554:	4981                	li	s3,0
 556:	b771                	j	4e2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 558:	008b0913          	addi	s2,s6,8
 55c:	4681                	li	a3,0
 55e:	866a                	mv	a2,s10
 560:	000b2583          	lw	a1,0(s6)
 564:	8556                	mv	a0,s5
 566:	00000097          	auipc	ra,0x0
 56a:	e70080e7          	jalr	-400(ra) # 3d6 <printint>
 56e:	8b4a                	mv	s6,s2
      state = 0;
 570:	4981                	li	s3,0
 572:	bf85                	j	4e2 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 574:	008b0793          	addi	a5,s6,8
 578:	f8f43423          	sd	a5,-120(s0)
 57c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 580:	03000593          	li	a1,48
 584:	8556                	mv	a0,s5
 586:	00000097          	auipc	ra,0x0
 58a:	e2e080e7          	jalr	-466(ra) # 3b4 <putc>
  putc(fd, 'x');
 58e:	07800593          	li	a1,120
 592:	8556                	mv	a0,s5
 594:	00000097          	auipc	ra,0x0
 598:	e20080e7          	jalr	-480(ra) # 3b4 <putc>
 59c:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 59e:	03c9d793          	srli	a5,s3,0x3c
 5a2:	97de                	add	a5,a5,s7
 5a4:	0007c583          	lbu	a1,0(a5)
 5a8:	8556                	mv	a0,s5
 5aa:	00000097          	auipc	ra,0x0
 5ae:	e0a080e7          	jalr	-502(ra) # 3b4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5b2:	0992                	slli	s3,s3,0x4
 5b4:	397d                	addiw	s2,s2,-1
 5b6:	fe0914e3          	bnez	s2,59e <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 5ba:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5be:	4981                	li	s3,0
 5c0:	b70d                	j	4e2 <vprintf+0x60>
        s = va_arg(ap, char*);
 5c2:	008b0913          	addi	s2,s6,8
 5c6:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 5ca:	02098163          	beqz	s3,5ec <vprintf+0x16a>
        while(*s != 0){
 5ce:	0009c583          	lbu	a1,0(s3)
 5d2:	c5ad                	beqz	a1,63c <vprintf+0x1ba>
          putc(fd, *s);
 5d4:	8556                	mv	a0,s5
 5d6:	00000097          	auipc	ra,0x0
 5da:	dde080e7          	jalr	-546(ra) # 3b4 <putc>
          s++;
 5de:	0985                	addi	s3,s3,1
        while(*s != 0){
 5e0:	0009c583          	lbu	a1,0(s3)
 5e4:	f9e5                	bnez	a1,5d4 <vprintf+0x152>
        s = va_arg(ap, char*);
 5e6:	8b4a                	mv	s6,s2
      state = 0;
 5e8:	4981                	li	s3,0
 5ea:	bde5                	j	4e2 <vprintf+0x60>
          s = "(null)";
 5ec:	00000997          	auipc	s3,0x0
 5f0:	31498993          	addi	s3,s3,788 # 900 <l_free+0x50>
        while(*s != 0){
 5f4:	85ee                	mv	a1,s11
 5f6:	bff9                	j	5d4 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 5f8:	008b0913          	addi	s2,s6,8
 5fc:	000b4583          	lbu	a1,0(s6)
 600:	8556                	mv	a0,s5
 602:	00000097          	auipc	ra,0x0
 606:	db2080e7          	jalr	-590(ra) # 3b4 <putc>
 60a:	8b4a                	mv	s6,s2
      state = 0;
 60c:	4981                	li	s3,0
 60e:	bdd1                	j	4e2 <vprintf+0x60>
        putc(fd, c);
 610:	85d2                	mv	a1,s4
 612:	8556                	mv	a0,s5
 614:	00000097          	auipc	ra,0x0
 618:	da0080e7          	jalr	-608(ra) # 3b4 <putc>
      state = 0;
 61c:	4981                	li	s3,0
 61e:	b5d1                	j	4e2 <vprintf+0x60>
        putc(fd, '%');
 620:	85d2                	mv	a1,s4
 622:	8556                	mv	a0,s5
 624:	00000097          	auipc	ra,0x0
 628:	d90080e7          	jalr	-624(ra) # 3b4 <putc>
        putc(fd, c);
 62c:	85ca                	mv	a1,s2
 62e:	8556                	mv	a0,s5
 630:	00000097          	auipc	ra,0x0
 634:	d84080e7          	jalr	-636(ra) # 3b4 <putc>
      state = 0;
 638:	4981                	li	s3,0
 63a:	b565                	j	4e2 <vprintf+0x60>
        s = va_arg(ap, char*);
 63c:	8b4a                	mv	s6,s2
      state = 0;
 63e:	4981                	li	s3,0
 640:	b54d                	j	4e2 <vprintf+0x60>
    }
  }
}
 642:	70e6                	ld	ra,120(sp)
 644:	7446                	ld	s0,112(sp)
 646:	74a6                	ld	s1,104(sp)
 648:	7906                	ld	s2,96(sp)
 64a:	69e6                	ld	s3,88(sp)
 64c:	6a46                	ld	s4,80(sp)
 64e:	6aa6                	ld	s5,72(sp)
 650:	6b06                	ld	s6,64(sp)
 652:	7be2                	ld	s7,56(sp)
 654:	7c42                	ld	s8,48(sp)
 656:	7ca2                	ld	s9,40(sp)
 658:	7d02                	ld	s10,32(sp)
 65a:	6de2                	ld	s11,24(sp)
 65c:	6109                	addi	sp,sp,128
 65e:	8082                	ret

0000000000000660 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 660:	715d                	addi	sp,sp,-80
 662:	ec06                	sd	ra,24(sp)
 664:	e822                	sd	s0,16(sp)
 666:	1000                	addi	s0,sp,32
 668:	e010                	sd	a2,0(s0)
 66a:	e414                	sd	a3,8(s0)
 66c:	e818                	sd	a4,16(s0)
 66e:	ec1c                	sd	a5,24(s0)
 670:	03043023          	sd	a6,32(s0)
 674:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 678:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 67c:	8622                	mv	a2,s0
 67e:	00000097          	auipc	ra,0x0
 682:	e04080e7          	jalr	-508(ra) # 482 <vprintf>
}
 686:	60e2                	ld	ra,24(sp)
 688:	6442                	ld	s0,16(sp)
 68a:	6161                	addi	sp,sp,80
 68c:	8082                	ret

000000000000068e <printf>:

void
printf(const char *fmt, ...)
{
 68e:	711d                	addi	sp,sp,-96
 690:	ec06                	sd	ra,24(sp)
 692:	e822                	sd	s0,16(sp)
 694:	1000                	addi	s0,sp,32
 696:	e40c                	sd	a1,8(s0)
 698:	e810                	sd	a2,16(s0)
 69a:	ec14                	sd	a3,24(s0)
 69c:	f018                	sd	a4,32(s0)
 69e:	f41c                	sd	a5,40(s0)
 6a0:	03043823          	sd	a6,48(s0)
 6a4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6a8:	00840613          	addi	a2,s0,8
 6ac:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6b0:	85aa                	mv	a1,a0
 6b2:	4505                	li	a0,1
 6b4:	00000097          	auipc	ra,0x0
 6b8:	dce080e7          	jalr	-562(ra) # 482 <vprintf>
}
 6bc:	60e2                	ld	ra,24(sp)
 6be:	6442                	ld	s0,16(sp)
 6c0:	6125                	addi	sp,sp,96
 6c2:	8082                	ret

00000000000006c4 <free>:
 6c4:	1141                	addi	sp,sp,-16
 6c6:	e422                	sd	s0,8(sp)
 6c8:	0800                	addi	s0,sp,16
 6ca:	ff050693          	addi	a3,a0,-16
 6ce:	00000797          	auipc	a5,0x0
 6d2:	2ba7b783          	ld	a5,698(a5) # 988 <freep>
 6d6:	a805                	j	706 <free+0x42>
 6d8:	4618                	lw	a4,8(a2)
 6da:	9db9                	addw	a1,a1,a4
 6dc:	feb52c23          	sw	a1,-8(a0)
 6e0:	6398                	ld	a4,0(a5)
 6e2:	6318                	ld	a4,0(a4)
 6e4:	fee53823          	sd	a4,-16(a0)
 6e8:	a091                	j	72c <free+0x68>
 6ea:	ff852703          	lw	a4,-8(a0)
 6ee:	9e39                	addw	a2,a2,a4
 6f0:	c790                	sw	a2,8(a5)
 6f2:	ff053703          	ld	a4,-16(a0)
 6f6:	e398                	sd	a4,0(a5)
 6f8:	a099                	j	73e <free+0x7a>
 6fa:	6398                	ld	a4,0(a5)
 6fc:	00e7e463          	bltu	a5,a4,704 <free+0x40>
 700:	00e6ea63          	bltu	a3,a4,714 <free+0x50>
 704:	87ba                	mv	a5,a4
 706:	fed7fae3          	bgeu	a5,a3,6fa <free+0x36>
 70a:	6398                	ld	a4,0(a5)
 70c:	00e6e463          	bltu	a3,a4,714 <free+0x50>
 710:	fee7eae3          	bltu	a5,a4,704 <free+0x40>
 714:	ff852583          	lw	a1,-8(a0)
 718:	6390                	ld	a2,0(a5)
 71a:	02059713          	slli	a4,a1,0x20
 71e:	9301                	srli	a4,a4,0x20
 720:	0712                	slli	a4,a4,0x4
 722:	9736                	add	a4,a4,a3
 724:	fae60ae3          	beq	a2,a4,6d8 <free+0x14>
 728:	fec53823          	sd	a2,-16(a0)
 72c:	4790                	lw	a2,8(a5)
 72e:	02061713          	slli	a4,a2,0x20
 732:	9301                	srli	a4,a4,0x20
 734:	0712                	slli	a4,a4,0x4
 736:	973e                	add	a4,a4,a5
 738:	fae689e3          	beq	a3,a4,6ea <free+0x26>
 73c:	e394                	sd	a3,0(a5)
 73e:	00000717          	auipc	a4,0x0
 742:	24f73523          	sd	a5,586(a4) # 988 <freep>
 746:	6422                	ld	s0,8(sp)
 748:	0141                	addi	sp,sp,16
 74a:	8082                	ret

000000000000074c <malloc>:
 74c:	7139                	addi	sp,sp,-64
 74e:	fc06                	sd	ra,56(sp)
 750:	f822                	sd	s0,48(sp)
 752:	f426                	sd	s1,40(sp)
 754:	f04a                	sd	s2,32(sp)
 756:	ec4e                	sd	s3,24(sp)
 758:	e852                	sd	s4,16(sp)
 75a:	e456                	sd	s5,8(sp)
 75c:	e05a                	sd	s6,0(sp)
 75e:	0080                	addi	s0,sp,64
 760:	02051493          	slli	s1,a0,0x20
 764:	9081                	srli	s1,s1,0x20
 766:	04bd                	addi	s1,s1,15
 768:	8091                	srli	s1,s1,0x4
 76a:	0014899b          	addiw	s3,s1,1
 76e:	0485                	addi	s1,s1,1
 770:	00000517          	auipc	a0,0x0
 774:	21853503          	ld	a0,536(a0) # 988 <freep>
 778:	c515                	beqz	a0,7a4 <malloc+0x58>
 77a:	611c                	ld	a5,0(a0)
 77c:	4798                	lw	a4,8(a5)
 77e:	02977f63          	bgeu	a4,s1,7bc <malloc+0x70>
 782:	8a4e                	mv	s4,s3
 784:	0009871b          	sext.w	a4,s3
 788:	6685                	lui	a3,0x1
 78a:	00d77363          	bgeu	a4,a3,790 <malloc+0x44>
 78e:	6a05                	lui	s4,0x1
 790:	000a0b1b          	sext.w	s6,s4
 794:	004a1a1b          	slliw	s4,s4,0x4
 798:	00000917          	auipc	s2,0x0
 79c:	1f090913          	addi	s2,s2,496 # 988 <freep>
 7a0:	5afd                	li	s5,-1
 7a2:	a88d                	j	814 <malloc+0xc8>
 7a4:	00000797          	auipc	a5,0x0
 7a8:	1ec78793          	addi	a5,a5,492 # 990 <base>
 7ac:	00000717          	auipc	a4,0x0
 7b0:	1cf73e23          	sd	a5,476(a4) # 988 <freep>
 7b4:	e39c                	sd	a5,0(a5)
 7b6:	0007a423          	sw	zero,8(a5)
 7ba:	b7e1                	j	782 <malloc+0x36>
 7bc:	02e48b63          	beq	s1,a4,7f2 <malloc+0xa6>
 7c0:	4137073b          	subw	a4,a4,s3
 7c4:	c798                	sw	a4,8(a5)
 7c6:	1702                	slli	a4,a4,0x20
 7c8:	9301                	srli	a4,a4,0x20
 7ca:	0712                	slli	a4,a4,0x4
 7cc:	97ba                	add	a5,a5,a4
 7ce:	0137a423          	sw	s3,8(a5)
 7d2:	00000717          	auipc	a4,0x0
 7d6:	1aa73b23          	sd	a0,438(a4) # 988 <freep>
 7da:	01078513          	addi	a0,a5,16
 7de:	70e2                	ld	ra,56(sp)
 7e0:	7442                	ld	s0,48(sp)
 7e2:	74a2                	ld	s1,40(sp)
 7e4:	7902                	ld	s2,32(sp)
 7e6:	69e2                	ld	s3,24(sp)
 7e8:	6a42                	ld	s4,16(sp)
 7ea:	6aa2                	ld	s5,8(sp)
 7ec:	6b02                	ld	s6,0(sp)
 7ee:	6121                	addi	sp,sp,64
 7f0:	8082                	ret
 7f2:	6398                	ld	a4,0(a5)
 7f4:	e118                	sd	a4,0(a0)
 7f6:	bff1                	j	7d2 <malloc+0x86>
 7f8:	01652423          	sw	s6,8(a0)
 7fc:	0541                	addi	a0,a0,16
 7fe:	00000097          	auipc	ra,0x0
 802:	ec6080e7          	jalr	-314(ra) # 6c4 <free>
 806:	00093503          	ld	a0,0(s2)
 80a:	d971                	beqz	a0,7de <malloc+0x92>
 80c:	611c                	ld	a5,0(a0)
 80e:	4798                	lw	a4,8(a5)
 810:	fa9776e3          	bgeu	a4,s1,7bc <malloc+0x70>
 814:	00093703          	ld	a4,0(s2)
 818:	853e                	mv	a0,a5
 81a:	fef719e3          	bne	a4,a5,80c <malloc+0xc0>
 81e:	8552                	mv	a0,s4
 820:	00000097          	auipc	ra,0x0
 824:	b7c080e7          	jalr	-1156(ra) # 39c <sbrk>
 828:	fd5518e3          	bne	a0,s5,7f8 <malloc+0xac>
 82c:	4501                	li	a0,0
 82e:	bf45                	j	7de <malloc+0x92>

0000000000000830 <mem_init>:
 830:	1141                	addi	sp,sp,-16
 832:	e406                	sd	ra,8(sp)
 834:	e022                	sd	s0,0(sp)
 836:	0800                	addi	s0,sp,16
 838:	6505                	lui	a0,0x1
 83a:	00000097          	auipc	ra,0x0
 83e:	b62080e7          	jalr	-1182(ra) # 39c <sbrk>
 842:	00000797          	auipc	a5,0x0
 846:	12a7bf23          	sd	a0,318(a5) # 980 <alloc>
 84a:	00850793          	addi	a5,a0,8 # 1008 <__BSS_END__+0x668>
 84e:	e11c                	sd	a5,0(a0)
 850:	60a2                	ld	ra,8(sp)
 852:	6402                	ld	s0,0(sp)
 854:	0141                	addi	sp,sp,16
 856:	8082                	ret

0000000000000858 <l_alloc>:
 858:	1101                	addi	sp,sp,-32
 85a:	ec06                	sd	ra,24(sp)
 85c:	e822                	sd	s0,16(sp)
 85e:	e426                	sd	s1,8(sp)
 860:	1000                	addi	s0,sp,32
 862:	84aa                	mv	s1,a0
 864:	00000797          	auipc	a5,0x0
 868:	1147a783          	lw	a5,276(a5) # 978 <if_init>
 86c:	c795                	beqz	a5,898 <l_alloc+0x40>
 86e:	00000717          	auipc	a4,0x0
 872:	11273703          	ld	a4,274(a4) # 980 <alloc>
 876:	6308                	ld	a0,0(a4)
 878:	40e506b3          	sub	a3,a0,a4
 87c:	6785                	lui	a5,0x1
 87e:	37e1                	addiw	a5,a5,-8
 880:	9f95                	subw	a5,a5,a3
 882:	02f4f563          	bgeu	s1,a5,8ac <l_alloc+0x54>
 886:	1482                	slli	s1,s1,0x20
 888:	9081                	srli	s1,s1,0x20
 88a:	94aa                	add	s1,s1,a0
 88c:	e304                	sd	s1,0(a4)
 88e:	60e2                	ld	ra,24(sp)
 890:	6442                	ld	s0,16(sp)
 892:	64a2                	ld	s1,8(sp)
 894:	6105                	addi	sp,sp,32
 896:	8082                	ret
 898:	00000097          	auipc	ra,0x0
 89c:	f98080e7          	jalr	-104(ra) # 830 <mem_init>
 8a0:	4785                	li	a5,1
 8a2:	00000717          	auipc	a4,0x0
 8a6:	0cf72b23          	sw	a5,214(a4) # 978 <if_init>
 8aa:	b7d1                	j	86e <l_alloc+0x16>
 8ac:	4501                	li	a0,0
 8ae:	b7c5                	j	88e <l_alloc+0x36>

00000000000008b0 <l_free>:
 8b0:	1141                	addi	sp,sp,-16
 8b2:	e422                	sd	s0,8(sp)
 8b4:	0800                	addi	s0,sp,16
 8b6:	6422                	ld	s0,8(sp)
 8b8:	0141                	addi	sp,sp,16
 8ba:	8082                	ret
