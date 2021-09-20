
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	4785                	li	a5,1
  12:	06a7d463          	bge	a5,a0,7a <main+0x7a>
  16:	00858493          	addi	s1,a1,8
  1a:	ffe5099b          	addiw	s3,a0,-2
  1e:	1982                	slli	s3,s3,0x20
  20:	0209d993          	srli	s3,s3,0x20
  24:	098e                	slli	s3,s3,0x3
  26:	05c1                	addi	a1,a1,16
  28:	99ae                	add	s3,s3,a1
  2a:	00001a17          	auipc	s4,0x1
  2e:	876a0a13          	addi	s4,s4,-1930 # 8a0 <l_free+0x12>
  32:	0004b903          	ld	s2,0(s1)
  36:	854a                	mv	a0,s2
  38:	00000097          	auipc	ra,0x0
  3c:	094080e7          	jalr	148(ra) # cc <strlen>
  40:	0005061b          	sext.w	a2,a0
  44:	85ca                	mv	a1,s2
  46:	4505                	li	a0,1
  48:	00000097          	auipc	ra,0x0
  4c:	2ca080e7          	jalr	714(ra) # 312 <write>
  50:	04a1                	addi	s1,s1,8
  52:	01348a63          	beq	s1,s3,66 <main+0x66>
  56:	4605                	li	a2,1
  58:	85d2                	mv	a1,s4
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	2b6080e7          	jalr	694(ra) # 312 <write>
  64:	b7f9                	j	32 <main+0x32>
  66:	4605                	li	a2,1
  68:	00001597          	auipc	a1,0x1
  6c:	84058593          	addi	a1,a1,-1984 # 8a8 <l_free+0x1a>
  70:	4505                	li	a0,1
  72:	00000097          	auipc	ra,0x0
  76:	2a0080e7          	jalr	672(ra) # 312 <write>
  7a:	4501                	li	a0,0
  7c:	00000097          	auipc	ra,0x0
  80:	276080e7          	jalr	630(ra) # 2f2 <exit>

0000000000000084 <strcpy>:
  84:	1141                	addi	sp,sp,-16
  86:	e422                	sd	s0,8(sp)
  88:	0800                	addi	s0,sp,16
  8a:	87aa                	mv	a5,a0
  8c:	0585                	addi	a1,a1,1
  8e:	0785                	addi	a5,a5,1
  90:	fff5c703          	lbu	a4,-1(a1)
  94:	fee78fa3          	sb	a4,-1(a5)
  98:	fb75                	bnez	a4,8c <strcpy+0x8>
  9a:	6422                	ld	s0,8(sp)
  9c:	0141                	addi	sp,sp,16
  9e:	8082                	ret

00000000000000a0 <strcmp>:
  a0:	1141                	addi	sp,sp,-16
  a2:	e422                	sd	s0,8(sp)
  a4:	0800                	addi	s0,sp,16
  a6:	00054783          	lbu	a5,0(a0)
  aa:	cb91                	beqz	a5,be <strcmp+0x1e>
  ac:	0005c703          	lbu	a4,0(a1)
  b0:	00f71763          	bne	a4,a5,be <strcmp+0x1e>
  b4:	0505                	addi	a0,a0,1
  b6:	0585                	addi	a1,a1,1
  b8:	00054783          	lbu	a5,0(a0)
  bc:	fbe5                	bnez	a5,ac <strcmp+0xc>
  be:	0005c503          	lbu	a0,0(a1)
  c2:	40a7853b          	subw	a0,a5,a0
  c6:	6422                	ld	s0,8(sp)
  c8:	0141                	addi	sp,sp,16
  ca:	8082                	ret

00000000000000cc <strlen>:
  cc:	1141                	addi	sp,sp,-16
  ce:	e422                	sd	s0,8(sp)
  d0:	0800                	addi	s0,sp,16
  d2:	00054783          	lbu	a5,0(a0)
  d6:	cf91                	beqz	a5,f2 <strlen+0x26>
  d8:	0505                	addi	a0,a0,1
  da:	87aa                	mv	a5,a0
  dc:	4685                	li	a3,1
  de:	9e89                	subw	a3,a3,a0
  e0:	00f6853b          	addw	a0,a3,a5
  e4:	0785                	addi	a5,a5,1
  e6:	fff7c703          	lbu	a4,-1(a5)
  ea:	fb7d                	bnez	a4,e0 <strlen+0x14>
  ec:	6422                	ld	s0,8(sp)
  ee:	0141                	addi	sp,sp,16
  f0:	8082                	ret
  f2:	4501                	li	a0,0
  f4:	bfe5                	j	ec <strlen+0x20>

00000000000000f6 <memset>:
  f6:	1141                	addi	sp,sp,-16
  f8:	e422                	sd	s0,8(sp)
  fa:	0800                	addi	s0,sp,16
  fc:	ca19                	beqz	a2,112 <memset+0x1c>
  fe:	87aa                	mv	a5,a0
 100:	1602                	slli	a2,a2,0x20
 102:	9201                	srli	a2,a2,0x20
 104:	00a60733          	add	a4,a2,a0
 108:	00b78023          	sb	a1,0(a5)
 10c:	0785                	addi	a5,a5,1
 10e:	fee79de3          	bne	a5,a4,108 <memset+0x12>
 112:	6422                	ld	s0,8(sp)
 114:	0141                	addi	sp,sp,16
 116:	8082                	ret

0000000000000118 <strchr>:
 118:	1141                	addi	sp,sp,-16
 11a:	e422                	sd	s0,8(sp)
 11c:	0800                	addi	s0,sp,16
 11e:	00054783          	lbu	a5,0(a0)
 122:	cb99                	beqz	a5,138 <strchr+0x20>
 124:	00f58763          	beq	a1,a5,132 <strchr+0x1a>
 128:	0505                	addi	a0,a0,1
 12a:	00054783          	lbu	a5,0(a0)
 12e:	fbfd                	bnez	a5,124 <strchr+0xc>
 130:	4501                	li	a0,0
 132:	6422                	ld	s0,8(sp)
 134:	0141                	addi	sp,sp,16
 136:	8082                	ret
 138:	4501                	li	a0,0
 13a:	bfe5                	j	132 <strchr+0x1a>

000000000000013c <gets>:
 13c:	711d                	addi	sp,sp,-96
 13e:	ec86                	sd	ra,88(sp)
 140:	e8a2                	sd	s0,80(sp)
 142:	e4a6                	sd	s1,72(sp)
 144:	e0ca                	sd	s2,64(sp)
 146:	fc4e                	sd	s3,56(sp)
 148:	f852                	sd	s4,48(sp)
 14a:	f456                	sd	s5,40(sp)
 14c:	f05a                	sd	s6,32(sp)
 14e:	ec5e                	sd	s7,24(sp)
 150:	1080                	addi	s0,sp,96
 152:	8baa                	mv	s7,a0
 154:	8a2e                	mv	s4,a1
 156:	892a                	mv	s2,a0
 158:	4481                	li	s1,0
 15a:	4aa9                	li	s5,10
 15c:	4b35                	li	s6,13
 15e:	89a6                	mv	s3,s1
 160:	2485                	addiw	s1,s1,1
 162:	0344d863          	bge	s1,s4,192 <gets+0x56>
 166:	4605                	li	a2,1
 168:	faf40593          	addi	a1,s0,-81
 16c:	4501                	li	a0,0
 16e:	00000097          	auipc	ra,0x0
 172:	19c080e7          	jalr	412(ra) # 30a <read>
 176:	00a05e63          	blez	a0,192 <gets+0x56>
 17a:	faf44783          	lbu	a5,-81(s0)
 17e:	00f90023          	sb	a5,0(s2)
 182:	01578763          	beq	a5,s5,190 <gets+0x54>
 186:	0905                	addi	s2,s2,1
 188:	fd679be3          	bne	a5,s6,15e <gets+0x22>
 18c:	89a6                	mv	s3,s1
 18e:	a011                	j	192 <gets+0x56>
 190:	89a6                	mv	s3,s1
 192:	99de                	add	s3,s3,s7
 194:	00098023          	sb	zero,0(s3)
 198:	855e                	mv	a0,s7
 19a:	60e6                	ld	ra,88(sp)
 19c:	6446                	ld	s0,80(sp)
 19e:	64a6                	ld	s1,72(sp)
 1a0:	6906                	ld	s2,64(sp)
 1a2:	79e2                	ld	s3,56(sp)
 1a4:	7a42                	ld	s4,48(sp)
 1a6:	7aa2                	ld	s5,40(sp)
 1a8:	7b02                	ld	s6,32(sp)
 1aa:	6be2                	ld	s7,24(sp)
 1ac:	6125                	addi	sp,sp,96
 1ae:	8082                	ret

00000000000001b0 <stat>:
 1b0:	1101                	addi	sp,sp,-32
 1b2:	ec06                	sd	ra,24(sp)
 1b4:	e822                	sd	s0,16(sp)
 1b6:	e426                	sd	s1,8(sp)
 1b8:	e04a                	sd	s2,0(sp)
 1ba:	1000                	addi	s0,sp,32
 1bc:	892e                	mv	s2,a1
 1be:	4581                	li	a1,0
 1c0:	00000097          	auipc	ra,0x0
 1c4:	172080e7          	jalr	370(ra) # 332 <open>
 1c8:	02054563          	bltz	a0,1f2 <stat+0x42>
 1cc:	84aa                	mv	s1,a0
 1ce:	85ca                	mv	a1,s2
 1d0:	00000097          	auipc	ra,0x0
 1d4:	17a080e7          	jalr	378(ra) # 34a <fstat>
 1d8:	892a                	mv	s2,a0
 1da:	8526                	mv	a0,s1
 1dc:	00000097          	auipc	ra,0x0
 1e0:	13e080e7          	jalr	318(ra) # 31a <close>
 1e4:	854a                	mv	a0,s2
 1e6:	60e2                	ld	ra,24(sp)
 1e8:	6442                	ld	s0,16(sp)
 1ea:	64a2                	ld	s1,8(sp)
 1ec:	6902                	ld	s2,0(sp)
 1ee:	6105                	addi	sp,sp,32
 1f0:	8082                	ret
 1f2:	597d                	li	s2,-1
 1f4:	bfc5                	j	1e4 <stat+0x34>

00000000000001f6 <atoi>:
 1f6:	1141                	addi	sp,sp,-16
 1f8:	e422                	sd	s0,8(sp)
 1fa:	0800                	addi	s0,sp,16
 1fc:	00054603          	lbu	a2,0(a0)
 200:	fd06079b          	addiw	a5,a2,-48
 204:	0ff7f793          	zext.b	a5,a5
 208:	4725                	li	a4,9
 20a:	02f76963          	bltu	a4,a5,23c <atoi+0x46>
 20e:	86aa                	mv	a3,a0
 210:	4501                	li	a0,0
 212:	45a5                	li	a1,9
 214:	0685                	addi	a3,a3,1
 216:	0025179b          	slliw	a5,a0,0x2
 21a:	9fa9                	addw	a5,a5,a0
 21c:	0017979b          	slliw	a5,a5,0x1
 220:	9fb1                	addw	a5,a5,a2
 222:	fd07851b          	addiw	a0,a5,-48
 226:	0006c603          	lbu	a2,0(a3)
 22a:	fd06071b          	addiw	a4,a2,-48
 22e:	0ff77713          	zext.b	a4,a4
 232:	fee5f1e3          	bgeu	a1,a4,214 <atoi+0x1e>
 236:	6422                	ld	s0,8(sp)
 238:	0141                	addi	sp,sp,16
 23a:	8082                	ret
 23c:	4501                	li	a0,0
 23e:	bfe5                	j	236 <atoi+0x40>

0000000000000240 <memmove>:
 240:	1141                	addi	sp,sp,-16
 242:	e422                	sd	s0,8(sp)
 244:	0800                	addi	s0,sp,16
 246:	02b57463          	bgeu	a0,a1,26e <memmove+0x2e>
 24a:	00c05f63          	blez	a2,268 <memmove+0x28>
 24e:	1602                	slli	a2,a2,0x20
 250:	9201                	srli	a2,a2,0x20
 252:	00c507b3          	add	a5,a0,a2
 256:	872a                	mv	a4,a0
 258:	0585                	addi	a1,a1,1
 25a:	0705                	addi	a4,a4,1
 25c:	fff5c683          	lbu	a3,-1(a1)
 260:	fed70fa3          	sb	a3,-1(a4)
 264:	fee79ae3          	bne	a5,a4,258 <memmove+0x18>
 268:	6422                	ld	s0,8(sp)
 26a:	0141                	addi	sp,sp,16
 26c:	8082                	ret
 26e:	00c50733          	add	a4,a0,a2
 272:	95b2                	add	a1,a1,a2
 274:	fec05ae3          	blez	a2,268 <memmove+0x28>
 278:	fff6079b          	addiw	a5,a2,-1
 27c:	1782                	slli	a5,a5,0x20
 27e:	9381                	srli	a5,a5,0x20
 280:	fff7c793          	not	a5,a5
 284:	97ba                	add	a5,a5,a4
 286:	15fd                	addi	a1,a1,-1
 288:	177d                	addi	a4,a4,-1
 28a:	0005c683          	lbu	a3,0(a1)
 28e:	00d70023          	sb	a3,0(a4)
 292:	fee79ae3          	bne	a5,a4,286 <memmove+0x46>
 296:	bfc9                	j	268 <memmove+0x28>

0000000000000298 <memcmp>:
 298:	1141                	addi	sp,sp,-16
 29a:	e422                	sd	s0,8(sp)
 29c:	0800                	addi	s0,sp,16
 29e:	ca05                	beqz	a2,2ce <memcmp+0x36>
 2a0:	fff6069b          	addiw	a3,a2,-1
 2a4:	1682                	slli	a3,a3,0x20
 2a6:	9281                	srli	a3,a3,0x20
 2a8:	0685                	addi	a3,a3,1
 2aa:	96aa                	add	a3,a3,a0
 2ac:	00054783          	lbu	a5,0(a0)
 2b0:	0005c703          	lbu	a4,0(a1)
 2b4:	00e79863          	bne	a5,a4,2c4 <memcmp+0x2c>
 2b8:	0505                	addi	a0,a0,1
 2ba:	0585                	addi	a1,a1,1
 2bc:	fed518e3          	bne	a0,a3,2ac <memcmp+0x14>
 2c0:	4501                	li	a0,0
 2c2:	a019                	j	2c8 <memcmp+0x30>
 2c4:	40e7853b          	subw	a0,a5,a4
 2c8:	6422                	ld	s0,8(sp)
 2ca:	0141                	addi	sp,sp,16
 2cc:	8082                	ret
 2ce:	4501                	li	a0,0
 2d0:	bfe5                	j	2c8 <memcmp+0x30>

00000000000002d2 <memcpy>:
 2d2:	1141                	addi	sp,sp,-16
 2d4:	e406                	sd	ra,8(sp)
 2d6:	e022                	sd	s0,0(sp)
 2d8:	0800                	addi	s0,sp,16
 2da:	00000097          	auipc	ra,0x0
 2de:	f66080e7          	jalr	-154(ra) # 240 <memmove>
 2e2:	60a2                	ld	ra,8(sp)
 2e4:	6402                	ld	s0,0(sp)
 2e6:	0141                	addi	sp,sp,16
 2e8:	8082                	ret

00000000000002ea <fork>:
 2ea:	4885                	li	a7,1
 2ec:	00000073          	ecall
 2f0:	8082                	ret

00000000000002f2 <exit>:
 2f2:	4889                	li	a7,2
 2f4:	00000073          	ecall
 2f8:	8082                	ret

00000000000002fa <wait>:
 2fa:	488d                	li	a7,3
 2fc:	00000073          	ecall
 300:	8082                	ret

0000000000000302 <pipe>:
 302:	4891                	li	a7,4
 304:	00000073          	ecall
 308:	8082                	ret

000000000000030a <read>:
 30a:	4895                	li	a7,5
 30c:	00000073          	ecall
 310:	8082                	ret

0000000000000312 <write>:
 312:	48c1                	li	a7,16
 314:	00000073          	ecall
 318:	8082                	ret

000000000000031a <close>:
 31a:	48d5                	li	a7,21
 31c:	00000073          	ecall
 320:	8082                	ret

0000000000000322 <kill>:
 322:	4899                	li	a7,6
 324:	00000073          	ecall
 328:	8082                	ret

000000000000032a <exec>:
 32a:	489d                	li	a7,7
 32c:	00000073          	ecall
 330:	8082                	ret

0000000000000332 <open>:
 332:	48bd                	li	a7,15
 334:	00000073          	ecall
 338:	8082                	ret

000000000000033a <mknod>:
 33a:	48c5                	li	a7,17
 33c:	00000073          	ecall
 340:	8082                	ret

0000000000000342 <unlink>:
 342:	48c9                	li	a7,18
 344:	00000073          	ecall
 348:	8082                	ret

000000000000034a <fstat>:
 34a:	48a1                	li	a7,8
 34c:	00000073          	ecall
 350:	8082                	ret

0000000000000352 <link>:
 352:	48cd                	li	a7,19
 354:	00000073          	ecall
 358:	8082                	ret

000000000000035a <mkdir>:
 35a:	48d1                	li	a7,20
 35c:	00000073          	ecall
 360:	8082                	ret

0000000000000362 <chdir>:
 362:	48a5                	li	a7,9
 364:	00000073          	ecall
 368:	8082                	ret

000000000000036a <dup>:
 36a:	48a9                	li	a7,10
 36c:	00000073          	ecall
 370:	8082                	ret

0000000000000372 <getpid>:
 372:	48ad                	li	a7,11
 374:	00000073          	ecall
 378:	8082                	ret

000000000000037a <sbrk>:
 37a:	48b1                	li	a7,12
 37c:	00000073          	ecall
 380:	8082                	ret

0000000000000382 <sleep>:
 382:	48b5                	li	a7,13
 384:	00000073          	ecall
 388:	8082                	ret

000000000000038a <uptime>:
 38a:	48b9                	li	a7,14
 38c:	00000073          	ecall
 390:	8082                	ret

0000000000000392 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 392:	1101                	addi	sp,sp,-32
 394:	ec06                	sd	ra,24(sp)
 396:	e822                	sd	s0,16(sp)
 398:	1000                	addi	s0,sp,32
 39a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 39e:	4605                	li	a2,1
 3a0:	fef40593          	addi	a1,s0,-17
 3a4:	00000097          	auipc	ra,0x0
 3a8:	f6e080e7          	jalr	-146(ra) # 312 <write>
}
 3ac:	60e2                	ld	ra,24(sp)
 3ae:	6442                	ld	s0,16(sp)
 3b0:	6105                	addi	sp,sp,32
 3b2:	8082                	ret

00000000000003b4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3b4:	7139                	addi	sp,sp,-64
 3b6:	fc06                	sd	ra,56(sp)
 3b8:	f822                	sd	s0,48(sp)
 3ba:	f426                	sd	s1,40(sp)
 3bc:	f04a                	sd	s2,32(sp)
 3be:	ec4e                	sd	s3,24(sp)
 3c0:	0080                	addi	s0,sp,64
 3c2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3c4:	c299                	beqz	a3,3ca <printint+0x16>
 3c6:	0805c963          	bltz	a1,458 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3ca:	2581                	sext.w	a1,a1
  neg = 0;
 3cc:	4881                	li	a7,0
 3ce:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3d2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3d4:	2601                	sext.w	a2,a2
 3d6:	00000517          	auipc	a0,0x0
 3da:	53a50513          	addi	a0,a0,1338 # 910 <digits>
 3de:	883a                	mv	a6,a4
 3e0:	2705                	addiw	a4,a4,1
 3e2:	02c5f7bb          	remuw	a5,a1,a2
 3e6:	1782                	slli	a5,a5,0x20
 3e8:	9381                	srli	a5,a5,0x20
 3ea:	97aa                	add	a5,a5,a0
 3ec:	0007c783          	lbu	a5,0(a5)
 3f0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3f4:	0005879b          	sext.w	a5,a1
 3f8:	02c5d5bb          	divuw	a1,a1,a2
 3fc:	0685                	addi	a3,a3,1
 3fe:	fec7f0e3          	bgeu	a5,a2,3de <printint+0x2a>
  if(neg)
 402:	00088c63          	beqz	a7,41a <printint+0x66>
    buf[i++] = '-';
 406:	fd070793          	addi	a5,a4,-48
 40a:	00878733          	add	a4,a5,s0
 40e:	02d00793          	li	a5,45
 412:	fef70823          	sb	a5,-16(a4)
 416:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 41a:	02e05863          	blez	a4,44a <printint+0x96>
 41e:	fc040793          	addi	a5,s0,-64
 422:	00e78933          	add	s2,a5,a4
 426:	fff78993          	addi	s3,a5,-1
 42a:	99ba                	add	s3,s3,a4
 42c:	377d                	addiw	a4,a4,-1
 42e:	1702                	slli	a4,a4,0x20
 430:	9301                	srli	a4,a4,0x20
 432:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 436:	fff94583          	lbu	a1,-1(s2)
 43a:	8526                	mv	a0,s1
 43c:	00000097          	auipc	ra,0x0
 440:	f56080e7          	jalr	-170(ra) # 392 <putc>
  while(--i >= 0)
 444:	197d                	addi	s2,s2,-1
 446:	ff3918e3          	bne	s2,s3,436 <printint+0x82>
}
 44a:	70e2                	ld	ra,56(sp)
 44c:	7442                	ld	s0,48(sp)
 44e:	74a2                	ld	s1,40(sp)
 450:	7902                	ld	s2,32(sp)
 452:	69e2                	ld	s3,24(sp)
 454:	6121                	addi	sp,sp,64
 456:	8082                	ret
    x = -xx;
 458:	40b005bb          	negw	a1,a1
    neg = 1;
 45c:	4885                	li	a7,1
    x = -xx;
 45e:	bf85                	j	3ce <printint+0x1a>

0000000000000460 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 460:	7119                	addi	sp,sp,-128
 462:	fc86                	sd	ra,120(sp)
 464:	f8a2                	sd	s0,112(sp)
 466:	f4a6                	sd	s1,104(sp)
 468:	f0ca                	sd	s2,96(sp)
 46a:	ecce                	sd	s3,88(sp)
 46c:	e8d2                	sd	s4,80(sp)
 46e:	e4d6                	sd	s5,72(sp)
 470:	e0da                	sd	s6,64(sp)
 472:	fc5e                	sd	s7,56(sp)
 474:	f862                	sd	s8,48(sp)
 476:	f466                	sd	s9,40(sp)
 478:	f06a                	sd	s10,32(sp)
 47a:	ec6e                	sd	s11,24(sp)
 47c:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 47e:	0005c903          	lbu	s2,0(a1)
 482:	18090f63          	beqz	s2,620 <vprintf+0x1c0>
 486:	8aaa                	mv	s5,a0
 488:	8b32                	mv	s6,a2
 48a:	00158493          	addi	s1,a1,1
  state = 0;
 48e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 490:	02500a13          	li	s4,37
 494:	4c55                	li	s8,21
 496:	00000c97          	auipc	s9,0x0
 49a:	422c8c93          	addi	s9,s9,1058 # 8b8 <l_free+0x2a>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 49e:	02800d93          	li	s11,40
  putc(fd, 'x');
 4a2:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4a4:	00000b97          	auipc	s7,0x0
 4a8:	46cb8b93          	addi	s7,s7,1132 # 910 <digits>
 4ac:	a839                	j	4ca <vprintf+0x6a>
        putc(fd, c);
 4ae:	85ca                	mv	a1,s2
 4b0:	8556                	mv	a0,s5
 4b2:	00000097          	auipc	ra,0x0
 4b6:	ee0080e7          	jalr	-288(ra) # 392 <putc>
 4ba:	a019                	j	4c0 <vprintf+0x60>
    } else if(state == '%'){
 4bc:	01498d63          	beq	s3,s4,4d6 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 4c0:	0485                	addi	s1,s1,1
 4c2:	fff4c903          	lbu	s2,-1(s1)
 4c6:	14090d63          	beqz	s2,620 <vprintf+0x1c0>
    if(state == 0){
 4ca:	fe0999e3          	bnez	s3,4bc <vprintf+0x5c>
      if(c == '%'){
 4ce:	ff4910e3          	bne	s2,s4,4ae <vprintf+0x4e>
        state = '%';
 4d2:	89d2                	mv	s3,s4
 4d4:	b7f5                	j	4c0 <vprintf+0x60>
      if(c == 'd'){
 4d6:	11490c63          	beq	s2,s4,5ee <vprintf+0x18e>
 4da:	f9d9079b          	addiw	a5,s2,-99
 4de:	0ff7f793          	zext.b	a5,a5
 4e2:	10fc6e63          	bltu	s8,a5,5fe <vprintf+0x19e>
 4e6:	f9d9079b          	addiw	a5,s2,-99
 4ea:	0ff7f713          	zext.b	a4,a5
 4ee:	10ec6863          	bltu	s8,a4,5fe <vprintf+0x19e>
 4f2:	00271793          	slli	a5,a4,0x2
 4f6:	97e6                	add	a5,a5,s9
 4f8:	439c                	lw	a5,0(a5)
 4fa:	97e6                	add	a5,a5,s9
 4fc:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4fe:	008b0913          	addi	s2,s6,8
 502:	4685                	li	a3,1
 504:	4629                	li	a2,10
 506:	000b2583          	lw	a1,0(s6)
 50a:	8556                	mv	a0,s5
 50c:	00000097          	auipc	ra,0x0
 510:	ea8080e7          	jalr	-344(ra) # 3b4 <printint>
 514:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 516:	4981                	li	s3,0
 518:	b765                	j	4c0 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 51a:	008b0913          	addi	s2,s6,8
 51e:	4681                	li	a3,0
 520:	4629                	li	a2,10
 522:	000b2583          	lw	a1,0(s6)
 526:	8556                	mv	a0,s5
 528:	00000097          	auipc	ra,0x0
 52c:	e8c080e7          	jalr	-372(ra) # 3b4 <printint>
 530:	8b4a                	mv	s6,s2
      state = 0;
 532:	4981                	li	s3,0
 534:	b771                	j	4c0 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 536:	008b0913          	addi	s2,s6,8
 53a:	4681                	li	a3,0
 53c:	866a                	mv	a2,s10
 53e:	000b2583          	lw	a1,0(s6)
 542:	8556                	mv	a0,s5
 544:	00000097          	auipc	ra,0x0
 548:	e70080e7          	jalr	-400(ra) # 3b4 <printint>
 54c:	8b4a                	mv	s6,s2
      state = 0;
 54e:	4981                	li	s3,0
 550:	bf85                	j	4c0 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 552:	008b0793          	addi	a5,s6,8
 556:	f8f43423          	sd	a5,-120(s0)
 55a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 55e:	03000593          	li	a1,48
 562:	8556                	mv	a0,s5
 564:	00000097          	auipc	ra,0x0
 568:	e2e080e7          	jalr	-466(ra) # 392 <putc>
  putc(fd, 'x');
 56c:	07800593          	li	a1,120
 570:	8556                	mv	a0,s5
 572:	00000097          	auipc	ra,0x0
 576:	e20080e7          	jalr	-480(ra) # 392 <putc>
 57a:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 57c:	03c9d793          	srli	a5,s3,0x3c
 580:	97de                	add	a5,a5,s7
 582:	0007c583          	lbu	a1,0(a5)
 586:	8556                	mv	a0,s5
 588:	00000097          	auipc	ra,0x0
 58c:	e0a080e7          	jalr	-502(ra) # 392 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 590:	0992                	slli	s3,s3,0x4
 592:	397d                	addiw	s2,s2,-1
 594:	fe0914e3          	bnez	s2,57c <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 598:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 59c:	4981                	li	s3,0
 59e:	b70d                	j	4c0 <vprintf+0x60>
        s = va_arg(ap, char*);
 5a0:	008b0913          	addi	s2,s6,8
 5a4:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 5a8:	02098163          	beqz	s3,5ca <vprintf+0x16a>
        while(*s != 0){
 5ac:	0009c583          	lbu	a1,0(s3)
 5b0:	c5ad                	beqz	a1,61a <vprintf+0x1ba>
          putc(fd, *s);
 5b2:	8556                	mv	a0,s5
 5b4:	00000097          	auipc	ra,0x0
 5b8:	dde080e7          	jalr	-546(ra) # 392 <putc>
          s++;
 5bc:	0985                	addi	s3,s3,1
        while(*s != 0){
 5be:	0009c583          	lbu	a1,0(s3)
 5c2:	f9e5                	bnez	a1,5b2 <vprintf+0x152>
        s = va_arg(ap, char*);
 5c4:	8b4a                	mv	s6,s2
      state = 0;
 5c6:	4981                	li	s3,0
 5c8:	bde5                	j	4c0 <vprintf+0x60>
          s = "(null)";
 5ca:	00000997          	auipc	s3,0x0
 5ce:	2e698993          	addi	s3,s3,742 # 8b0 <l_free+0x22>
        while(*s != 0){
 5d2:	85ee                	mv	a1,s11
 5d4:	bff9                	j	5b2 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 5d6:	008b0913          	addi	s2,s6,8
 5da:	000b4583          	lbu	a1,0(s6)
 5de:	8556                	mv	a0,s5
 5e0:	00000097          	auipc	ra,0x0
 5e4:	db2080e7          	jalr	-590(ra) # 392 <putc>
 5e8:	8b4a                	mv	s6,s2
      state = 0;
 5ea:	4981                	li	s3,0
 5ec:	bdd1                	j	4c0 <vprintf+0x60>
        putc(fd, c);
 5ee:	85d2                	mv	a1,s4
 5f0:	8556                	mv	a0,s5
 5f2:	00000097          	auipc	ra,0x0
 5f6:	da0080e7          	jalr	-608(ra) # 392 <putc>
      state = 0;
 5fa:	4981                	li	s3,0
 5fc:	b5d1                	j	4c0 <vprintf+0x60>
        putc(fd, '%');
 5fe:	85d2                	mv	a1,s4
 600:	8556                	mv	a0,s5
 602:	00000097          	auipc	ra,0x0
 606:	d90080e7          	jalr	-624(ra) # 392 <putc>
        putc(fd, c);
 60a:	85ca                	mv	a1,s2
 60c:	8556                	mv	a0,s5
 60e:	00000097          	auipc	ra,0x0
 612:	d84080e7          	jalr	-636(ra) # 392 <putc>
      state = 0;
 616:	4981                	li	s3,0
 618:	b565                	j	4c0 <vprintf+0x60>
        s = va_arg(ap, char*);
 61a:	8b4a                	mv	s6,s2
      state = 0;
 61c:	4981                	li	s3,0
 61e:	b54d                	j	4c0 <vprintf+0x60>
    }
  }
}
 620:	70e6                	ld	ra,120(sp)
 622:	7446                	ld	s0,112(sp)
 624:	74a6                	ld	s1,104(sp)
 626:	7906                	ld	s2,96(sp)
 628:	69e6                	ld	s3,88(sp)
 62a:	6a46                	ld	s4,80(sp)
 62c:	6aa6                	ld	s5,72(sp)
 62e:	6b06                	ld	s6,64(sp)
 630:	7be2                	ld	s7,56(sp)
 632:	7c42                	ld	s8,48(sp)
 634:	7ca2                	ld	s9,40(sp)
 636:	7d02                	ld	s10,32(sp)
 638:	6de2                	ld	s11,24(sp)
 63a:	6109                	addi	sp,sp,128
 63c:	8082                	ret

000000000000063e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 63e:	715d                	addi	sp,sp,-80
 640:	ec06                	sd	ra,24(sp)
 642:	e822                	sd	s0,16(sp)
 644:	1000                	addi	s0,sp,32
 646:	e010                	sd	a2,0(s0)
 648:	e414                	sd	a3,8(s0)
 64a:	e818                	sd	a4,16(s0)
 64c:	ec1c                	sd	a5,24(s0)
 64e:	03043023          	sd	a6,32(s0)
 652:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 656:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 65a:	8622                	mv	a2,s0
 65c:	00000097          	auipc	ra,0x0
 660:	e04080e7          	jalr	-508(ra) # 460 <vprintf>
}
 664:	60e2                	ld	ra,24(sp)
 666:	6442                	ld	s0,16(sp)
 668:	6161                	addi	sp,sp,80
 66a:	8082                	ret

000000000000066c <printf>:

void
printf(const char *fmt, ...)
{
 66c:	711d                	addi	sp,sp,-96
 66e:	ec06                	sd	ra,24(sp)
 670:	e822                	sd	s0,16(sp)
 672:	1000                	addi	s0,sp,32
 674:	e40c                	sd	a1,8(s0)
 676:	e810                	sd	a2,16(s0)
 678:	ec14                	sd	a3,24(s0)
 67a:	f018                	sd	a4,32(s0)
 67c:	f41c                	sd	a5,40(s0)
 67e:	03043823          	sd	a6,48(s0)
 682:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 686:	00840613          	addi	a2,s0,8
 68a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 68e:	85aa                	mv	a1,a0
 690:	4505                	li	a0,1
 692:	00000097          	auipc	ra,0x0
 696:	dce080e7          	jalr	-562(ra) # 460 <vprintf>
}
 69a:	60e2                	ld	ra,24(sp)
 69c:	6442                	ld	s0,16(sp)
 69e:	6125                	addi	sp,sp,96
 6a0:	8082                	ret

00000000000006a2 <free>:
 6a2:	1141                	addi	sp,sp,-16
 6a4:	e422                	sd	s0,8(sp)
 6a6:	0800                	addi	s0,sp,16
 6a8:	ff050693          	addi	a3,a0,-16
 6ac:	00000797          	auipc	a5,0x0
 6b0:	28c7b783          	ld	a5,652(a5) # 938 <freep>
 6b4:	a805                	j	6e4 <free+0x42>
 6b6:	4618                	lw	a4,8(a2)
 6b8:	9db9                	addw	a1,a1,a4
 6ba:	feb52c23          	sw	a1,-8(a0)
 6be:	6398                	ld	a4,0(a5)
 6c0:	6318                	ld	a4,0(a4)
 6c2:	fee53823          	sd	a4,-16(a0)
 6c6:	a091                	j	70a <free+0x68>
 6c8:	ff852703          	lw	a4,-8(a0)
 6cc:	9e39                	addw	a2,a2,a4
 6ce:	c790                	sw	a2,8(a5)
 6d0:	ff053703          	ld	a4,-16(a0)
 6d4:	e398                	sd	a4,0(a5)
 6d6:	a099                	j	71c <free+0x7a>
 6d8:	6398                	ld	a4,0(a5)
 6da:	00e7e463          	bltu	a5,a4,6e2 <free+0x40>
 6de:	00e6ea63          	bltu	a3,a4,6f2 <free+0x50>
 6e2:	87ba                	mv	a5,a4
 6e4:	fed7fae3          	bgeu	a5,a3,6d8 <free+0x36>
 6e8:	6398                	ld	a4,0(a5)
 6ea:	00e6e463          	bltu	a3,a4,6f2 <free+0x50>
 6ee:	fee7eae3          	bltu	a5,a4,6e2 <free+0x40>
 6f2:	ff852583          	lw	a1,-8(a0)
 6f6:	6390                	ld	a2,0(a5)
 6f8:	02059713          	slli	a4,a1,0x20
 6fc:	9301                	srli	a4,a4,0x20
 6fe:	0712                	slli	a4,a4,0x4
 700:	9736                	add	a4,a4,a3
 702:	fae60ae3          	beq	a2,a4,6b6 <free+0x14>
 706:	fec53823          	sd	a2,-16(a0)
 70a:	4790                	lw	a2,8(a5)
 70c:	02061713          	slli	a4,a2,0x20
 710:	9301                	srli	a4,a4,0x20
 712:	0712                	slli	a4,a4,0x4
 714:	973e                	add	a4,a4,a5
 716:	fae689e3          	beq	a3,a4,6c8 <free+0x26>
 71a:	e394                	sd	a3,0(a5)
 71c:	00000717          	auipc	a4,0x0
 720:	20f73e23          	sd	a5,540(a4) # 938 <freep>
 724:	6422                	ld	s0,8(sp)
 726:	0141                	addi	sp,sp,16
 728:	8082                	ret

000000000000072a <malloc>:
 72a:	7139                	addi	sp,sp,-64
 72c:	fc06                	sd	ra,56(sp)
 72e:	f822                	sd	s0,48(sp)
 730:	f426                	sd	s1,40(sp)
 732:	f04a                	sd	s2,32(sp)
 734:	ec4e                	sd	s3,24(sp)
 736:	e852                	sd	s4,16(sp)
 738:	e456                	sd	s5,8(sp)
 73a:	e05a                	sd	s6,0(sp)
 73c:	0080                	addi	s0,sp,64
 73e:	02051493          	slli	s1,a0,0x20
 742:	9081                	srli	s1,s1,0x20
 744:	04bd                	addi	s1,s1,15
 746:	8091                	srli	s1,s1,0x4
 748:	0014899b          	addiw	s3,s1,1
 74c:	0485                	addi	s1,s1,1
 74e:	00000517          	auipc	a0,0x0
 752:	1ea53503          	ld	a0,490(a0) # 938 <freep>
 756:	c515                	beqz	a0,782 <malloc+0x58>
 758:	611c                	ld	a5,0(a0)
 75a:	4798                	lw	a4,8(a5)
 75c:	02977f63          	bgeu	a4,s1,79a <malloc+0x70>
 760:	8a4e                	mv	s4,s3
 762:	0009871b          	sext.w	a4,s3
 766:	6685                	lui	a3,0x1
 768:	00d77363          	bgeu	a4,a3,76e <malloc+0x44>
 76c:	6a05                	lui	s4,0x1
 76e:	000a0b1b          	sext.w	s6,s4
 772:	004a1a1b          	slliw	s4,s4,0x4
 776:	00000917          	auipc	s2,0x0
 77a:	1c290913          	addi	s2,s2,450 # 938 <freep>
 77e:	5afd                	li	s5,-1
 780:	a88d                	j	7f2 <malloc+0xc8>
 782:	00000797          	auipc	a5,0x0
 786:	1be78793          	addi	a5,a5,446 # 940 <base>
 78a:	00000717          	auipc	a4,0x0
 78e:	1af73723          	sd	a5,430(a4) # 938 <freep>
 792:	e39c                	sd	a5,0(a5)
 794:	0007a423          	sw	zero,8(a5)
 798:	b7e1                	j	760 <malloc+0x36>
 79a:	02e48b63          	beq	s1,a4,7d0 <malloc+0xa6>
 79e:	4137073b          	subw	a4,a4,s3
 7a2:	c798                	sw	a4,8(a5)
 7a4:	1702                	slli	a4,a4,0x20
 7a6:	9301                	srli	a4,a4,0x20
 7a8:	0712                	slli	a4,a4,0x4
 7aa:	97ba                	add	a5,a5,a4
 7ac:	0137a423          	sw	s3,8(a5)
 7b0:	00000717          	auipc	a4,0x0
 7b4:	18a73423          	sd	a0,392(a4) # 938 <freep>
 7b8:	01078513          	addi	a0,a5,16
 7bc:	70e2                	ld	ra,56(sp)
 7be:	7442                	ld	s0,48(sp)
 7c0:	74a2                	ld	s1,40(sp)
 7c2:	7902                	ld	s2,32(sp)
 7c4:	69e2                	ld	s3,24(sp)
 7c6:	6a42                	ld	s4,16(sp)
 7c8:	6aa2                	ld	s5,8(sp)
 7ca:	6b02                	ld	s6,0(sp)
 7cc:	6121                	addi	sp,sp,64
 7ce:	8082                	ret
 7d0:	6398                	ld	a4,0(a5)
 7d2:	e118                	sd	a4,0(a0)
 7d4:	bff1                	j	7b0 <malloc+0x86>
 7d6:	01652423          	sw	s6,8(a0)
 7da:	0541                	addi	a0,a0,16
 7dc:	00000097          	auipc	ra,0x0
 7e0:	ec6080e7          	jalr	-314(ra) # 6a2 <free>
 7e4:	00093503          	ld	a0,0(s2)
 7e8:	d971                	beqz	a0,7bc <malloc+0x92>
 7ea:	611c                	ld	a5,0(a0)
 7ec:	4798                	lw	a4,8(a5)
 7ee:	fa9776e3          	bgeu	a4,s1,79a <malloc+0x70>
 7f2:	00093703          	ld	a4,0(s2)
 7f6:	853e                	mv	a0,a5
 7f8:	fef719e3          	bne	a4,a5,7ea <malloc+0xc0>
 7fc:	8552                	mv	a0,s4
 7fe:	00000097          	auipc	ra,0x0
 802:	b7c080e7          	jalr	-1156(ra) # 37a <sbrk>
 806:	fd5518e3          	bne	a0,s5,7d6 <malloc+0xac>
 80a:	4501                	li	a0,0
 80c:	bf45                	j	7bc <malloc+0x92>

000000000000080e <mem_init>:
 80e:	1141                	addi	sp,sp,-16
 810:	e406                	sd	ra,8(sp)
 812:	e022                	sd	s0,0(sp)
 814:	0800                	addi	s0,sp,16
 816:	6505                	lui	a0,0x1
 818:	00000097          	auipc	ra,0x0
 81c:	b62080e7          	jalr	-1182(ra) # 37a <sbrk>
 820:	00000797          	auipc	a5,0x0
 824:	10a7b823          	sd	a0,272(a5) # 930 <alloc>
 828:	00850793          	addi	a5,a0,8 # 1008 <__BSS_END__+0x6b8>
 82c:	e11c                	sd	a5,0(a0)
 82e:	60a2                	ld	ra,8(sp)
 830:	6402                	ld	s0,0(sp)
 832:	0141                	addi	sp,sp,16
 834:	8082                	ret

0000000000000836 <l_alloc>:
 836:	1101                	addi	sp,sp,-32
 838:	ec06                	sd	ra,24(sp)
 83a:	e822                	sd	s0,16(sp)
 83c:	e426                	sd	s1,8(sp)
 83e:	1000                	addi	s0,sp,32
 840:	84aa                	mv	s1,a0
 842:	00000797          	auipc	a5,0x0
 846:	0e67a783          	lw	a5,230(a5) # 928 <if_init>
 84a:	c795                	beqz	a5,876 <l_alloc+0x40>
 84c:	00000717          	auipc	a4,0x0
 850:	0e473703          	ld	a4,228(a4) # 930 <alloc>
 854:	6308                	ld	a0,0(a4)
 856:	40e506b3          	sub	a3,a0,a4
 85a:	6785                	lui	a5,0x1
 85c:	37e1                	addiw	a5,a5,-8
 85e:	9f95                	subw	a5,a5,a3
 860:	02f4f563          	bgeu	s1,a5,88a <l_alloc+0x54>
 864:	1482                	slli	s1,s1,0x20
 866:	9081                	srli	s1,s1,0x20
 868:	94aa                	add	s1,s1,a0
 86a:	e304                	sd	s1,0(a4)
 86c:	60e2                	ld	ra,24(sp)
 86e:	6442                	ld	s0,16(sp)
 870:	64a2                	ld	s1,8(sp)
 872:	6105                	addi	sp,sp,32
 874:	8082                	ret
 876:	00000097          	auipc	ra,0x0
 87a:	f98080e7          	jalr	-104(ra) # 80e <mem_init>
 87e:	4785                	li	a5,1
 880:	00000717          	auipc	a4,0x0
 884:	0af72423          	sw	a5,168(a4) # 928 <if_init>
 888:	b7d1                	j	84c <l_alloc+0x16>
 88a:	4501                	li	a0,0
 88c:	b7c5                	j	86c <l_alloc+0x36>

000000000000088e <l_free>:
 88e:	1141                	addi	sp,sp,-16
 890:	e422                	sd	s0,8(sp)
 892:	0800                	addi	s0,sp,16
 894:	6422                	ld	s0,8(sp)
 896:	0141                	addi	sp,sp,16
 898:	8082                	ret
