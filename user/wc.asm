
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  26:	4981                	li	s3,0
  28:	4c81                	li	s9,0
  2a:	4c01                	li	s8,0
  2c:	4b81                	li	s7,0
  2e:	00001d97          	auipc	s11,0x1
  32:	a5bd8d93          	addi	s11,s11,-1445 # a89 <buf+0x1>
  36:	4aa9                	li	s5,10
  38:	00001a17          	auipc	s4,0x1
  3c:	978a0a13          	addi	s4,s4,-1672 # 9b0 <l_free+0x10>
  40:	4b01                	li	s6,0
  42:	a805                	j	72 <wc+0x72>
  44:	8552                	mv	a0,s4
  46:	00000097          	auipc	ra,0x0
  4a:	1e4080e7          	jalr	484(ra) # 22a <strchr>
  4e:	c919                	beqz	a0,64 <wc+0x64>
  50:	89da                	mv	s3,s6
  52:	0485                	addi	s1,s1,1
  54:	01248d63          	beq	s1,s2,6e <wc+0x6e>
  58:	0004c583          	lbu	a1,0(s1)
  5c:	ff5594e3          	bne	a1,s5,44 <wc+0x44>
  60:	2b85                	addiw	s7,s7,1
  62:	b7cd                	j	44 <wc+0x44>
  64:	fe0997e3          	bnez	s3,52 <wc+0x52>
  68:	2c05                	addiw	s8,s8,1
  6a:	4985                	li	s3,1
  6c:	b7dd                	j	52 <wc+0x52>
  6e:	01ac8cbb          	addw	s9,s9,s10
  72:	20000613          	li	a2,512
  76:	00001597          	auipc	a1,0x1
  7a:	a1258593          	addi	a1,a1,-1518 # a88 <buf>
  7e:	f8843503          	ld	a0,-120(s0)
  82:	00000097          	auipc	ra,0x0
  86:	39a080e7          	jalr	922(ra) # 41c <read>
  8a:	00a05f63          	blez	a0,a8 <wc+0xa8>
  8e:	00001497          	auipc	s1,0x1
  92:	9fa48493          	addi	s1,s1,-1542 # a88 <buf>
  96:	00050d1b          	sext.w	s10,a0
  9a:	fff5091b          	addiw	s2,a0,-1
  9e:	1902                	slli	s2,s2,0x20
  a0:	02095913          	srli	s2,s2,0x20
  a4:	996e                	add	s2,s2,s11
  a6:	bf4d                	j	58 <wc+0x58>
  a8:	02054e63          	bltz	a0,e4 <wc+0xe4>
  ac:	f8043703          	ld	a4,-128(s0)
  b0:	86e6                	mv	a3,s9
  b2:	8662                	mv	a2,s8
  b4:	85de                	mv	a1,s7
  b6:	00001517          	auipc	a0,0x1
  ba:	91250513          	addi	a0,a0,-1774 # 9c8 <l_free+0x28>
  be:	00000097          	auipc	ra,0x0
  c2:	6c0080e7          	jalr	1728(ra) # 77e <printf>
  c6:	70e6                	ld	ra,120(sp)
  c8:	7446                	ld	s0,112(sp)
  ca:	74a6                	ld	s1,104(sp)
  cc:	7906                	ld	s2,96(sp)
  ce:	69e6                	ld	s3,88(sp)
  d0:	6a46                	ld	s4,80(sp)
  d2:	6aa6                	ld	s5,72(sp)
  d4:	6b06                	ld	s6,64(sp)
  d6:	7be2                	ld	s7,56(sp)
  d8:	7c42                	ld	s8,48(sp)
  da:	7ca2                	ld	s9,40(sp)
  dc:	7d02                	ld	s10,32(sp)
  de:	6de2                	ld	s11,24(sp)
  e0:	6109                	addi	sp,sp,128
  e2:	8082                	ret
  e4:	00001517          	auipc	a0,0x1
  e8:	8d450513          	addi	a0,a0,-1836 # 9b8 <l_free+0x18>
  ec:	00000097          	auipc	ra,0x0
  f0:	692080e7          	jalr	1682(ra) # 77e <printf>
  f4:	4505                	li	a0,1
  f6:	00000097          	auipc	ra,0x0
  fa:	30e080e7          	jalr	782(ra) # 404 <exit>

00000000000000fe <main>:
  fe:	7179                	addi	sp,sp,-48
 100:	f406                	sd	ra,40(sp)
 102:	f022                	sd	s0,32(sp)
 104:	ec26                	sd	s1,24(sp)
 106:	e84a                	sd	s2,16(sp)
 108:	e44e                	sd	s3,8(sp)
 10a:	e052                	sd	s4,0(sp)
 10c:	1800                	addi	s0,sp,48
 10e:	4785                	li	a5,1
 110:	04a7d763          	bge	a5,a0,15e <main+0x60>
 114:	00858493          	addi	s1,a1,8
 118:	ffe5099b          	addiw	s3,a0,-2
 11c:	1982                	slli	s3,s3,0x20
 11e:	0209d993          	srli	s3,s3,0x20
 122:	098e                	slli	s3,s3,0x3
 124:	05c1                	addi	a1,a1,16
 126:	99ae                	add	s3,s3,a1
 128:	4581                	li	a1,0
 12a:	6088                	ld	a0,0(s1)
 12c:	00000097          	auipc	ra,0x0
 130:	318080e7          	jalr	792(ra) # 444 <open>
 134:	892a                	mv	s2,a0
 136:	04054263          	bltz	a0,17a <main+0x7c>
 13a:	608c                	ld	a1,0(s1)
 13c:	00000097          	auipc	ra,0x0
 140:	ec4080e7          	jalr	-316(ra) # 0 <wc>
 144:	854a                	mv	a0,s2
 146:	00000097          	auipc	ra,0x0
 14a:	2e6080e7          	jalr	742(ra) # 42c <close>
 14e:	04a1                	addi	s1,s1,8
 150:	fd349ce3          	bne	s1,s3,128 <main+0x2a>
 154:	4501                	li	a0,0
 156:	00000097          	auipc	ra,0x0
 15a:	2ae080e7          	jalr	686(ra) # 404 <exit>
 15e:	00001597          	auipc	a1,0x1
 162:	87a58593          	addi	a1,a1,-1926 # 9d8 <l_free+0x38>
 166:	4501                	li	a0,0
 168:	00000097          	auipc	ra,0x0
 16c:	e98080e7          	jalr	-360(ra) # 0 <wc>
 170:	4501                	li	a0,0
 172:	00000097          	auipc	ra,0x0
 176:	292080e7          	jalr	658(ra) # 404 <exit>
 17a:	608c                	ld	a1,0(s1)
 17c:	00001517          	auipc	a0,0x1
 180:	86450513          	addi	a0,a0,-1948 # 9e0 <l_free+0x40>
 184:	00000097          	auipc	ra,0x0
 188:	5fa080e7          	jalr	1530(ra) # 77e <printf>
 18c:	4505                	li	a0,1
 18e:	00000097          	auipc	ra,0x0
 192:	276080e7          	jalr	630(ra) # 404 <exit>

0000000000000196 <strcpy>:
 196:	1141                	addi	sp,sp,-16
 198:	e422                	sd	s0,8(sp)
 19a:	0800                	addi	s0,sp,16
 19c:	87aa                	mv	a5,a0
 19e:	0585                	addi	a1,a1,1
 1a0:	0785                	addi	a5,a5,1
 1a2:	fff5c703          	lbu	a4,-1(a1)
 1a6:	fee78fa3          	sb	a4,-1(a5)
 1aa:	fb75                	bnez	a4,19e <strcpy+0x8>
 1ac:	6422                	ld	s0,8(sp)
 1ae:	0141                	addi	sp,sp,16
 1b0:	8082                	ret

00000000000001b2 <strcmp>:
 1b2:	1141                	addi	sp,sp,-16
 1b4:	e422                	sd	s0,8(sp)
 1b6:	0800                	addi	s0,sp,16
 1b8:	00054783          	lbu	a5,0(a0)
 1bc:	cb91                	beqz	a5,1d0 <strcmp+0x1e>
 1be:	0005c703          	lbu	a4,0(a1)
 1c2:	00f71763          	bne	a4,a5,1d0 <strcmp+0x1e>
 1c6:	0505                	addi	a0,a0,1
 1c8:	0585                	addi	a1,a1,1
 1ca:	00054783          	lbu	a5,0(a0)
 1ce:	fbe5                	bnez	a5,1be <strcmp+0xc>
 1d0:	0005c503          	lbu	a0,0(a1)
 1d4:	40a7853b          	subw	a0,a5,a0
 1d8:	6422                	ld	s0,8(sp)
 1da:	0141                	addi	sp,sp,16
 1dc:	8082                	ret

00000000000001de <strlen>:
 1de:	1141                	addi	sp,sp,-16
 1e0:	e422                	sd	s0,8(sp)
 1e2:	0800                	addi	s0,sp,16
 1e4:	00054783          	lbu	a5,0(a0)
 1e8:	cf91                	beqz	a5,204 <strlen+0x26>
 1ea:	0505                	addi	a0,a0,1
 1ec:	87aa                	mv	a5,a0
 1ee:	4685                	li	a3,1
 1f0:	9e89                	subw	a3,a3,a0
 1f2:	00f6853b          	addw	a0,a3,a5
 1f6:	0785                	addi	a5,a5,1
 1f8:	fff7c703          	lbu	a4,-1(a5)
 1fc:	fb7d                	bnez	a4,1f2 <strlen+0x14>
 1fe:	6422                	ld	s0,8(sp)
 200:	0141                	addi	sp,sp,16
 202:	8082                	ret
 204:	4501                	li	a0,0
 206:	bfe5                	j	1fe <strlen+0x20>

0000000000000208 <memset>:
 208:	1141                	addi	sp,sp,-16
 20a:	e422                	sd	s0,8(sp)
 20c:	0800                	addi	s0,sp,16
 20e:	ca19                	beqz	a2,224 <memset+0x1c>
 210:	87aa                	mv	a5,a0
 212:	1602                	slli	a2,a2,0x20
 214:	9201                	srli	a2,a2,0x20
 216:	00a60733          	add	a4,a2,a0
 21a:	00b78023          	sb	a1,0(a5)
 21e:	0785                	addi	a5,a5,1
 220:	fee79de3          	bne	a5,a4,21a <memset+0x12>
 224:	6422                	ld	s0,8(sp)
 226:	0141                	addi	sp,sp,16
 228:	8082                	ret

000000000000022a <strchr>:
 22a:	1141                	addi	sp,sp,-16
 22c:	e422                	sd	s0,8(sp)
 22e:	0800                	addi	s0,sp,16
 230:	00054783          	lbu	a5,0(a0)
 234:	cb99                	beqz	a5,24a <strchr+0x20>
 236:	00f58763          	beq	a1,a5,244 <strchr+0x1a>
 23a:	0505                	addi	a0,a0,1
 23c:	00054783          	lbu	a5,0(a0)
 240:	fbfd                	bnez	a5,236 <strchr+0xc>
 242:	4501                	li	a0,0
 244:	6422                	ld	s0,8(sp)
 246:	0141                	addi	sp,sp,16
 248:	8082                	ret
 24a:	4501                	li	a0,0
 24c:	bfe5                	j	244 <strchr+0x1a>

000000000000024e <gets>:
 24e:	711d                	addi	sp,sp,-96
 250:	ec86                	sd	ra,88(sp)
 252:	e8a2                	sd	s0,80(sp)
 254:	e4a6                	sd	s1,72(sp)
 256:	e0ca                	sd	s2,64(sp)
 258:	fc4e                	sd	s3,56(sp)
 25a:	f852                	sd	s4,48(sp)
 25c:	f456                	sd	s5,40(sp)
 25e:	f05a                	sd	s6,32(sp)
 260:	ec5e                	sd	s7,24(sp)
 262:	1080                	addi	s0,sp,96
 264:	8baa                	mv	s7,a0
 266:	8a2e                	mv	s4,a1
 268:	892a                	mv	s2,a0
 26a:	4481                	li	s1,0
 26c:	4aa9                	li	s5,10
 26e:	4b35                	li	s6,13
 270:	89a6                	mv	s3,s1
 272:	2485                	addiw	s1,s1,1
 274:	0344d863          	bge	s1,s4,2a4 <gets+0x56>
 278:	4605                	li	a2,1
 27a:	faf40593          	addi	a1,s0,-81
 27e:	4501                	li	a0,0
 280:	00000097          	auipc	ra,0x0
 284:	19c080e7          	jalr	412(ra) # 41c <read>
 288:	00a05e63          	blez	a0,2a4 <gets+0x56>
 28c:	faf44783          	lbu	a5,-81(s0)
 290:	00f90023          	sb	a5,0(s2)
 294:	01578763          	beq	a5,s5,2a2 <gets+0x54>
 298:	0905                	addi	s2,s2,1
 29a:	fd679be3          	bne	a5,s6,270 <gets+0x22>
 29e:	89a6                	mv	s3,s1
 2a0:	a011                	j	2a4 <gets+0x56>
 2a2:	89a6                	mv	s3,s1
 2a4:	99de                	add	s3,s3,s7
 2a6:	00098023          	sb	zero,0(s3)
 2aa:	855e                	mv	a0,s7
 2ac:	60e6                	ld	ra,88(sp)
 2ae:	6446                	ld	s0,80(sp)
 2b0:	64a6                	ld	s1,72(sp)
 2b2:	6906                	ld	s2,64(sp)
 2b4:	79e2                	ld	s3,56(sp)
 2b6:	7a42                	ld	s4,48(sp)
 2b8:	7aa2                	ld	s5,40(sp)
 2ba:	7b02                	ld	s6,32(sp)
 2bc:	6be2                	ld	s7,24(sp)
 2be:	6125                	addi	sp,sp,96
 2c0:	8082                	ret

00000000000002c2 <stat>:
 2c2:	1101                	addi	sp,sp,-32
 2c4:	ec06                	sd	ra,24(sp)
 2c6:	e822                	sd	s0,16(sp)
 2c8:	e426                	sd	s1,8(sp)
 2ca:	e04a                	sd	s2,0(sp)
 2cc:	1000                	addi	s0,sp,32
 2ce:	892e                	mv	s2,a1
 2d0:	4581                	li	a1,0
 2d2:	00000097          	auipc	ra,0x0
 2d6:	172080e7          	jalr	370(ra) # 444 <open>
 2da:	02054563          	bltz	a0,304 <stat+0x42>
 2de:	84aa                	mv	s1,a0
 2e0:	85ca                	mv	a1,s2
 2e2:	00000097          	auipc	ra,0x0
 2e6:	17a080e7          	jalr	378(ra) # 45c <fstat>
 2ea:	892a                	mv	s2,a0
 2ec:	8526                	mv	a0,s1
 2ee:	00000097          	auipc	ra,0x0
 2f2:	13e080e7          	jalr	318(ra) # 42c <close>
 2f6:	854a                	mv	a0,s2
 2f8:	60e2                	ld	ra,24(sp)
 2fa:	6442                	ld	s0,16(sp)
 2fc:	64a2                	ld	s1,8(sp)
 2fe:	6902                	ld	s2,0(sp)
 300:	6105                	addi	sp,sp,32
 302:	8082                	ret
 304:	597d                	li	s2,-1
 306:	bfc5                	j	2f6 <stat+0x34>

0000000000000308 <atoi>:
 308:	1141                	addi	sp,sp,-16
 30a:	e422                	sd	s0,8(sp)
 30c:	0800                	addi	s0,sp,16
 30e:	00054603          	lbu	a2,0(a0)
 312:	fd06079b          	addiw	a5,a2,-48
 316:	0ff7f793          	zext.b	a5,a5
 31a:	4725                	li	a4,9
 31c:	02f76963          	bltu	a4,a5,34e <atoi+0x46>
 320:	86aa                	mv	a3,a0
 322:	4501                	li	a0,0
 324:	45a5                	li	a1,9
 326:	0685                	addi	a3,a3,1
 328:	0025179b          	slliw	a5,a0,0x2
 32c:	9fa9                	addw	a5,a5,a0
 32e:	0017979b          	slliw	a5,a5,0x1
 332:	9fb1                	addw	a5,a5,a2
 334:	fd07851b          	addiw	a0,a5,-48
 338:	0006c603          	lbu	a2,0(a3)
 33c:	fd06071b          	addiw	a4,a2,-48
 340:	0ff77713          	zext.b	a4,a4
 344:	fee5f1e3          	bgeu	a1,a4,326 <atoi+0x1e>
 348:	6422                	ld	s0,8(sp)
 34a:	0141                	addi	sp,sp,16
 34c:	8082                	ret
 34e:	4501                	li	a0,0
 350:	bfe5                	j	348 <atoi+0x40>

0000000000000352 <memmove>:
 352:	1141                	addi	sp,sp,-16
 354:	e422                	sd	s0,8(sp)
 356:	0800                	addi	s0,sp,16
 358:	02b57463          	bgeu	a0,a1,380 <memmove+0x2e>
 35c:	00c05f63          	blez	a2,37a <memmove+0x28>
 360:	1602                	slli	a2,a2,0x20
 362:	9201                	srli	a2,a2,0x20
 364:	00c507b3          	add	a5,a0,a2
 368:	872a                	mv	a4,a0
 36a:	0585                	addi	a1,a1,1
 36c:	0705                	addi	a4,a4,1
 36e:	fff5c683          	lbu	a3,-1(a1)
 372:	fed70fa3          	sb	a3,-1(a4)
 376:	fee79ae3          	bne	a5,a4,36a <memmove+0x18>
 37a:	6422                	ld	s0,8(sp)
 37c:	0141                	addi	sp,sp,16
 37e:	8082                	ret
 380:	00c50733          	add	a4,a0,a2
 384:	95b2                	add	a1,a1,a2
 386:	fec05ae3          	blez	a2,37a <memmove+0x28>
 38a:	fff6079b          	addiw	a5,a2,-1
 38e:	1782                	slli	a5,a5,0x20
 390:	9381                	srli	a5,a5,0x20
 392:	fff7c793          	not	a5,a5
 396:	97ba                	add	a5,a5,a4
 398:	15fd                	addi	a1,a1,-1
 39a:	177d                	addi	a4,a4,-1
 39c:	0005c683          	lbu	a3,0(a1)
 3a0:	00d70023          	sb	a3,0(a4)
 3a4:	fee79ae3          	bne	a5,a4,398 <memmove+0x46>
 3a8:	bfc9                	j	37a <memmove+0x28>

00000000000003aa <memcmp>:
 3aa:	1141                	addi	sp,sp,-16
 3ac:	e422                	sd	s0,8(sp)
 3ae:	0800                	addi	s0,sp,16
 3b0:	ca05                	beqz	a2,3e0 <memcmp+0x36>
 3b2:	fff6069b          	addiw	a3,a2,-1
 3b6:	1682                	slli	a3,a3,0x20
 3b8:	9281                	srli	a3,a3,0x20
 3ba:	0685                	addi	a3,a3,1
 3bc:	96aa                	add	a3,a3,a0
 3be:	00054783          	lbu	a5,0(a0)
 3c2:	0005c703          	lbu	a4,0(a1)
 3c6:	00e79863          	bne	a5,a4,3d6 <memcmp+0x2c>
 3ca:	0505                	addi	a0,a0,1
 3cc:	0585                	addi	a1,a1,1
 3ce:	fed518e3          	bne	a0,a3,3be <memcmp+0x14>
 3d2:	4501                	li	a0,0
 3d4:	a019                	j	3da <memcmp+0x30>
 3d6:	40e7853b          	subw	a0,a5,a4
 3da:	6422                	ld	s0,8(sp)
 3dc:	0141                	addi	sp,sp,16
 3de:	8082                	ret
 3e0:	4501                	li	a0,0
 3e2:	bfe5                	j	3da <memcmp+0x30>

00000000000003e4 <memcpy>:
 3e4:	1141                	addi	sp,sp,-16
 3e6:	e406                	sd	ra,8(sp)
 3e8:	e022                	sd	s0,0(sp)
 3ea:	0800                	addi	s0,sp,16
 3ec:	00000097          	auipc	ra,0x0
 3f0:	f66080e7          	jalr	-154(ra) # 352 <memmove>
 3f4:	60a2                	ld	ra,8(sp)
 3f6:	6402                	ld	s0,0(sp)
 3f8:	0141                	addi	sp,sp,16
 3fa:	8082                	ret

00000000000003fc <fork>:
 3fc:	4885                	li	a7,1
 3fe:	00000073          	ecall
 402:	8082                	ret

0000000000000404 <exit>:
 404:	4889                	li	a7,2
 406:	00000073          	ecall
 40a:	8082                	ret

000000000000040c <wait>:
 40c:	488d                	li	a7,3
 40e:	00000073          	ecall
 412:	8082                	ret

0000000000000414 <pipe>:
 414:	4891                	li	a7,4
 416:	00000073          	ecall
 41a:	8082                	ret

000000000000041c <read>:
 41c:	4895                	li	a7,5
 41e:	00000073          	ecall
 422:	8082                	ret

0000000000000424 <write>:
 424:	48c1                	li	a7,16
 426:	00000073          	ecall
 42a:	8082                	ret

000000000000042c <close>:
 42c:	48d5                	li	a7,21
 42e:	00000073          	ecall
 432:	8082                	ret

0000000000000434 <kill>:
 434:	4899                	li	a7,6
 436:	00000073          	ecall
 43a:	8082                	ret

000000000000043c <exec>:
 43c:	489d                	li	a7,7
 43e:	00000073          	ecall
 442:	8082                	ret

0000000000000444 <open>:
 444:	48bd                	li	a7,15
 446:	00000073          	ecall
 44a:	8082                	ret

000000000000044c <mknod>:
 44c:	48c5                	li	a7,17
 44e:	00000073          	ecall
 452:	8082                	ret

0000000000000454 <unlink>:
 454:	48c9                	li	a7,18
 456:	00000073          	ecall
 45a:	8082                	ret

000000000000045c <fstat>:
 45c:	48a1                	li	a7,8
 45e:	00000073          	ecall
 462:	8082                	ret

0000000000000464 <link>:
 464:	48cd                	li	a7,19
 466:	00000073          	ecall
 46a:	8082                	ret

000000000000046c <mkdir>:
 46c:	48d1                	li	a7,20
 46e:	00000073          	ecall
 472:	8082                	ret

0000000000000474 <chdir>:
 474:	48a5                	li	a7,9
 476:	00000073          	ecall
 47a:	8082                	ret

000000000000047c <dup>:
 47c:	48a9                	li	a7,10
 47e:	00000073          	ecall
 482:	8082                	ret

0000000000000484 <getpid>:
 484:	48ad                	li	a7,11
 486:	00000073          	ecall
 48a:	8082                	ret

000000000000048c <sbrk>:
 48c:	48b1                	li	a7,12
 48e:	00000073          	ecall
 492:	8082                	ret

0000000000000494 <sleep>:
 494:	48b5                	li	a7,13
 496:	00000073          	ecall
 49a:	8082                	ret

000000000000049c <uptime>:
 49c:	48b9                	li	a7,14
 49e:	00000073          	ecall
 4a2:	8082                	ret

00000000000004a4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4a4:	1101                	addi	sp,sp,-32
 4a6:	ec06                	sd	ra,24(sp)
 4a8:	e822                	sd	s0,16(sp)
 4aa:	1000                	addi	s0,sp,32
 4ac:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4b0:	4605                	li	a2,1
 4b2:	fef40593          	addi	a1,s0,-17
 4b6:	00000097          	auipc	ra,0x0
 4ba:	f6e080e7          	jalr	-146(ra) # 424 <write>
}
 4be:	60e2                	ld	ra,24(sp)
 4c0:	6442                	ld	s0,16(sp)
 4c2:	6105                	addi	sp,sp,32
 4c4:	8082                	ret

00000000000004c6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4c6:	7139                	addi	sp,sp,-64
 4c8:	fc06                	sd	ra,56(sp)
 4ca:	f822                	sd	s0,48(sp)
 4cc:	f426                	sd	s1,40(sp)
 4ce:	f04a                	sd	s2,32(sp)
 4d0:	ec4e                	sd	s3,24(sp)
 4d2:	0080                	addi	s0,sp,64
 4d4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4d6:	c299                	beqz	a3,4dc <printint+0x16>
 4d8:	0805c963          	bltz	a1,56a <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4dc:	2581                	sext.w	a1,a1
  neg = 0;
 4de:	4881                	li	a7,0
 4e0:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4e4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4e6:	2601                	sext.w	a2,a2
 4e8:	00000517          	auipc	a0,0x0
 4ec:	57050513          	addi	a0,a0,1392 # a58 <digits>
 4f0:	883a                	mv	a6,a4
 4f2:	2705                	addiw	a4,a4,1
 4f4:	02c5f7bb          	remuw	a5,a1,a2
 4f8:	1782                	slli	a5,a5,0x20
 4fa:	9381                	srli	a5,a5,0x20
 4fc:	97aa                	add	a5,a5,a0
 4fe:	0007c783          	lbu	a5,0(a5)
 502:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 506:	0005879b          	sext.w	a5,a1
 50a:	02c5d5bb          	divuw	a1,a1,a2
 50e:	0685                	addi	a3,a3,1
 510:	fec7f0e3          	bgeu	a5,a2,4f0 <printint+0x2a>
  if(neg)
 514:	00088c63          	beqz	a7,52c <printint+0x66>
    buf[i++] = '-';
 518:	fd070793          	addi	a5,a4,-48
 51c:	00878733          	add	a4,a5,s0
 520:	02d00793          	li	a5,45
 524:	fef70823          	sb	a5,-16(a4)
 528:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 52c:	02e05863          	blez	a4,55c <printint+0x96>
 530:	fc040793          	addi	a5,s0,-64
 534:	00e78933          	add	s2,a5,a4
 538:	fff78993          	addi	s3,a5,-1
 53c:	99ba                	add	s3,s3,a4
 53e:	377d                	addiw	a4,a4,-1
 540:	1702                	slli	a4,a4,0x20
 542:	9301                	srli	a4,a4,0x20
 544:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 548:	fff94583          	lbu	a1,-1(s2)
 54c:	8526                	mv	a0,s1
 54e:	00000097          	auipc	ra,0x0
 552:	f56080e7          	jalr	-170(ra) # 4a4 <putc>
  while(--i >= 0)
 556:	197d                	addi	s2,s2,-1
 558:	ff3918e3          	bne	s2,s3,548 <printint+0x82>
}
 55c:	70e2                	ld	ra,56(sp)
 55e:	7442                	ld	s0,48(sp)
 560:	74a2                	ld	s1,40(sp)
 562:	7902                	ld	s2,32(sp)
 564:	69e2                	ld	s3,24(sp)
 566:	6121                	addi	sp,sp,64
 568:	8082                	ret
    x = -xx;
 56a:	40b005bb          	negw	a1,a1
    neg = 1;
 56e:	4885                	li	a7,1
    x = -xx;
 570:	bf85                	j	4e0 <printint+0x1a>

0000000000000572 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 572:	7119                	addi	sp,sp,-128
 574:	fc86                	sd	ra,120(sp)
 576:	f8a2                	sd	s0,112(sp)
 578:	f4a6                	sd	s1,104(sp)
 57a:	f0ca                	sd	s2,96(sp)
 57c:	ecce                	sd	s3,88(sp)
 57e:	e8d2                	sd	s4,80(sp)
 580:	e4d6                	sd	s5,72(sp)
 582:	e0da                	sd	s6,64(sp)
 584:	fc5e                	sd	s7,56(sp)
 586:	f862                	sd	s8,48(sp)
 588:	f466                	sd	s9,40(sp)
 58a:	f06a                	sd	s10,32(sp)
 58c:	ec6e                	sd	s11,24(sp)
 58e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 590:	0005c903          	lbu	s2,0(a1)
 594:	18090f63          	beqz	s2,732 <vprintf+0x1c0>
 598:	8aaa                	mv	s5,a0
 59a:	8b32                	mv	s6,a2
 59c:	00158493          	addi	s1,a1,1
  state = 0;
 5a0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5a2:	02500a13          	li	s4,37
 5a6:	4c55                	li	s8,21
 5a8:	00000c97          	auipc	s9,0x0
 5ac:	458c8c93          	addi	s9,s9,1112 # a00 <l_free+0x60>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5b0:	02800d93          	li	s11,40
  putc(fd, 'x');
 5b4:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5b6:	00000b97          	auipc	s7,0x0
 5ba:	4a2b8b93          	addi	s7,s7,1186 # a58 <digits>
 5be:	a839                	j	5dc <vprintf+0x6a>
        putc(fd, c);
 5c0:	85ca                	mv	a1,s2
 5c2:	8556                	mv	a0,s5
 5c4:	00000097          	auipc	ra,0x0
 5c8:	ee0080e7          	jalr	-288(ra) # 4a4 <putc>
 5cc:	a019                	j	5d2 <vprintf+0x60>
    } else if(state == '%'){
 5ce:	01498d63          	beq	s3,s4,5e8 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 5d2:	0485                	addi	s1,s1,1
 5d4:	fff4c903          	lbu	s2,-1(s1)
 5d8:	14090d63          	beqz	s2,732 <vprintf+0x1c0>
    if(state == 0){
 5dc:	fe0999e3          	bnez	s3,5ce <vprintf+0x5c>
      if(c == '%'){
 5e0:	ff4910e3          	bne	s2,s4,5c0 <vprintf+0x4e>
        state = '%';
 5e4:	89d2                	mv	s3,s4
 5e6:	b7f5                	j	5d2 <vprintf+0x60>
      if(c == 'd'){
 5e8:	11490c63          	beq	s2,s4,700 <vprintf+0x18e>
 5ec:	f9d9079b          	addiw	a5,s2,-99
 5f0:	0ff7f793          	zext.b	a5,a5
 5f4:	10fc6e63          	bltu	s8,a5,710 <vprintf+0x19e>
 5f8:	f9d9079b          	addiw	a5,s2,-99
 5fc:	0ff7f713          	zext.b	a4,a5
 600:	10ec6863          	bltu	s8,a4,710 <vprintf+0x19e>
 604:	00271793          	slli	a5,a4,0x2
 608:	97e6                	add	a5,a5,s9
 60a:	439c                	lw	a5,0(a5)
 60c:	97e6                	add	a5,a5,s9
 60e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 610:	008b0913          	addi	s2,s6,8
 614:	4685                	li	a3,1
 616:	4629                	li	a2,10
 618:	000b2583          	lw	a1,0(s6)
 61c:	8556                	mv	a0,s5
 61e:	00000097          	auipc	ra,0x0
 622:	ea8080e7          	jalr	-344(ra) # 4c6 <printint>
 626:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 628:	4981                	li	s3,0
 62a:	b765                	j	5d2 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 62c:	008b0913          	addi	s2,s6,8
 630:	4681                	li	a3,0
 632:	4629                	li	a2,10
 634:	000b2583          	lw	a1,0(s6)
 638:	8556                	mv	a0,s5
 63a:	00000097          	auipc	ra,0x0
 63e:	e8c080e7          	jalr	-372(ra) # 4c6 <printint>
 642:	8b4a                	mv	s6,s2
      state = 0;
 644:	4981                	li	s3,0
 646:	b771                	j	5d2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 648:	008b0913          	addi	s2,s6,8
 64c:	4681                	li	a3,0
 64e:	866a                	mv	a2,s10
 650:	000b2583          	lw	a1,0(s6)
 654:	8556                	mv	a0,s5
 656:	00000097          	auipc	ra,0x0
 65a:	e70080e7          	jalr	-400(ra) # 4c6 <printint>
 65e:	8b4a                	mv	s6,s2
      state = 0;
 660:	4981                	li	s3,0
 662:	bf85                	j	5d2 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 664:	008b0793          	addi	a5,s6,8
 668:	f8f43423          	sd	a5,-120(s0)
 66c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 670:	03000593          	li	a1,48
 674:	8556                	mv	a0,s5
 676:	00000097          	auipc	ra,0x0
 67a:	e2e080e7          	jalr	-466(ra) # 4a4 <putc>
  putc(fd, 'x');
 67e:	07800593          	li	a1,120
 682:	8556                	mv	a0,s5
 684:	00000097          	auipc	ra,0x0
 688:	e20080e7          	jalr	-480(ra) # 4a4 <putc>
 68c:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 68e:	03c9d793          	srli	a5,s3,0x3c
 692:	97de                	add	a5,a5,s7
 694:	0007c583          	lbu	a1,0(a5)
 698:	8556                	mv	a0,s5
 69a:	00000097          	auipc	ra,0x0
 69e:	e0a080e7          	jalr	-502(ra) # 4a4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6a2:	0992                	slli	s3,s3,0x4
 6a4:	397d                	addiw	s2,s2,-1
 6a6:	fe0914e3          	bnez	s2,68e <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 6aa:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6ae:	4981                	li	s3,0
 6b0:	b70d                	j	5d2 <vprintf+0x60>
        s = va_arg(ap, char*);
 6b2:	008b0913          	addi	s2,s6,8
 6b6:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 6ba:	02098163          	beqz	s3,6dc <vprintf+0x16a>
        while(*s != 0){
 6be:	0009c583          	lbu	a1,0(s3)
 6c2:	c5ad                	beqz	a1,72c <vprintf+0x1ba>
          putc(fd, *s);
 6c4:	8556                	mv	a0,s5
 6c6:	00000097          	auipc	ra,0x0
 6ca:	dde080e7          	jalr	-546(ra) # 4a4 <putc>
          s++;
 6ce:	0985                	addi	s3,s3,1
        while(*s != 0){
 6d0:	0009c583          	lbu	a1,0(s3)
 6d4:	f9e5                	bnez	a1,6c4 <vprintf+0x152>
        s = va_arg(ap, char*);
 6d6:	8b4a                	mv	s6,s2
      state = 0;
 6d8:	4981                	li	s3,0
 6da:	bde5                	j	5d2 <vprintf+0x60>
          s = "(null)";
 6dc:	00000997          	auipc	s3,0x0
 6e0:	31c98993          	addi	s3,s3,796 # 9f8 <l_free+0x58>
        while(*s != 0){
 6e4:	85ee                	mv	a1,s11
 6e6:	bff9                	j	6c4 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 6e8:	008b0913          	addi	s2,s6,8
 6ec:	000b4583          	lbu	a1,0(s6)
 6f0:	8556                	mv	a0,s5
 6f2:	00000097          	auipc	ra,0x0
 6f6:	db2080e7          	jalr	-590(ra) # 4a4 <putc>
 6fa:	8b4a                	mv	s6,s2
      state = 0;
 6fc:	4981                	li	s3,0
 6fe:	bdd1                	j	5d2 <vprintf+0x60>
        putc(fd, c);
 700:	85d2                	mv	a1,s4
 702:	8556                	mv	a0,s5
 704:	00000097          	auipc	ra,0x0
 708:	da0080e7          	jalr	-608(ra) # 4a4 <putc>
      state = 0;
 70c:	4981                	li	s3,0
 70e:	b5d1                	j	5d2 <vprintf+0x60>
        putc(fd, '%');
 710:	85d2                	mv	a1,s4
 712:	8556                	mv	a0,s5
 714:	00000097          	auipc	ra,0x0
 718:	d90080e7          	jalr	-624(ra) # 4a4 <putc>
        putc(fd, c);
 71c:	85ca                	mv	a1,s2
 71e:	8556                	mv	a0,s5
 720:	00000097          	auipc	ra,0x0
 724:	d84080e7          	jalr	-636(ra) # 4a4 <putc>
      state = 0;
 728:	4981                	li	s3,0
 72a:	b565                	j	5d2 <vprintf+0x60>
        s = va_arg(ap, char*);
 72c:	8b4a                	mv	s6,s2
      state = 0;
 72e:	4981                	li	s3,0
 730:	b54d                	j	5d2 <vprintf+0x60>
    }
  }
}
 732:	70e6                	ld	ra,120(sp)
 734:	7446                	ld	s0,112(sp)
 736:	74a6                	ld	s1,104(sp)
 738:	7906                	ld	s2,96(sp)
 73a:	69e6                	ld	s3,88(sp)
 73c:	6a46                	ld	s4,80(sp)
 73e:	6aa6                	ld	s5,72(sp)
 740:	6b06                	ld	s6,64(sp)
 742:	7be2                	ld	s7,56(sp)
 744:	7c42                	ld	s8,48(sp)
 746:	7ca2                	ld	s9,40(sp)
 748:	7d02                	ld	s10,32(sp)
 74a:	6de2                	ld	s11,24(sp)
 74c:	6109                	addi	sp,sp,128
 74e:	8082                	ret

0000000000000750 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 750:	715d                	addi	sp,sp,-80
 752:	ec06                	sd	ra,24(sp)
 754:	e822                	sd	s0,16(sp)
 756:	1000                	addi	s0,sp,32
 758:	e010                	sd	a2,0(s0)
 75a:	e414                	sd	a3,8(s0)
 75c:	e818                	sd	a4,16(s0)
 75e:	ec1c                	sd	a5,24(s0)
 760:	03043023          	sd	a6,32(s0)
 764:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 768:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 76c:	8622                	mv	a2,s0
 76e:	00000097          	auipc	ra,0x0
 772:	e04080e7          	jalr	-508(ra) # 572 <vprintf>
}
 776:	60e2                	ld	ra,24(sp)
 778:	6442                	ld	s0,16(sp)
 77a:	6161                	addi	sp,sp,80
 77c:	8082                	ret

000000000000077e <printf>:

void
printf(const char *fmt, ...)
{
 77e:	711d                	addi	sp,sp,-96
 780:	ec06                	sd	ra,24(sp)
 782:	e822                	sd	s0,16(sp)
 784:	1000                	addi	s0,sp,32
 786:	e40c                	sd	a1,8(s0)
 788:	e810                	sd	a2,16(s0)
 78a:	ec14                	sd	a3,24(s0)
 78c:	f018                	sd	a4,32(s0)
 78e:	f41c                	sd	a5,40(s0)
 790:	03043823          	sd	a6,48(s0)
 794:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 798:	00840613          	addi	a2,s0,8
 79c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7a0:	85aa                	mv	a1,a0
 7a2:	4505                	li	a0,1
 7a4:	00000097          	auipc	ra,0x0
 7a8:	dce080e7          	jalr	-562(ra) # 572 <vprintf>
}
 7ac:	60e2                	ld	ra,24(sp)
 7ae:	6442                	ld	s0,16(sp)
 7b0:	6125                	addi	sp,sp,96
 7b2:	8082                	ret

00000000000007b4 <free>:
 7b4:	1141                	addi	sp,sp,-16
 7b6:	e422                	sd	s0,8(sp)
 7b8:	0800                	addi	s0,sp,16
 7ba:	ff050693          	addi	a3,a0,-16
 7be:	00000797          	auipc	a5,0x0
 7c2:	2c27b783          	ld	a5,706(a5) # a80 <freep>
 7c6:	a805                	j	7f6 <free+0x42>
 7c8:	4618                	lw	a4,8(a2)
 7ca:	9db9                	addw	a1,a1,a4
 7cc:	feb52c23          	sw	a1,-8(a0)
 7d0:	6398                	ld	a4,0(a5)
 7d2:	6318                	ld	a4,0(a4)
 7d4:	fee53823          	sd	a4,-16(a0)
 7d8:	a091                	j	81c <free+0x68>
 7da:	ff852703          	lw	a4,-8(a0)
 7de:	9e39                	addw	a2,a2,a4
 7e0:	c790                	sw	a2,8(a5)
 7e2:	ff053703          	ld	a4,-16(a0)
 7e6:	e398                	sd	a4,0(a5)
 7e8:	a099                	j	82e <free+0x7a>
 7ea:	6398                	ld	a4,0(a5)
 7ec:	00e7e463          	bltu	a5,a4,7f4 <free+0x40>
 7f0:	00e6ea63          	bltu	a3,a4,804 <free+0x50>
 7f4:	87ba                	mv	a5,a4
 7f6:	fed7fae3          	bgeu	a5,a3,7ea <free+0x36>
 7fa:	6398                	ld	a4,0(a5)
 7fc:	00e6e463          	bltu	a3,a4,804 <free+0x50>
 800:	fee7eae3          	bltu	a5,a4,7f4 <free+0x40>
 804:	ff852583          	lw	a1,-8(a0)
 808:	6390                	ld	a2,0(a5)
 80a:	02059713          	slli	a4,a1,0x20
 80e:	9301                	srli	a4,a4,0x20
 810:	0712                	slli	a4,a4,0x4
 812:	9736                	add	a4,a4,a3
 814:	fae60ae3          	beq	a2,a4,7c8 <free+0x14>
 818:	fec53823          	sd	a2,-16(a0)
 81c:	4790                	lw	a2,8(a5)
 81e:	02061713          	slli	a4,a2,0x20
 822:	9301                	srli	a4,a4,0x20
 824:	0712                	slli	a4,a4,0x4
 826:	973e                	add	a4,a4,a5
 828:	fae689e3          	beq	a3,a4,7da <free+0x26>
 82c:	e394                	sd	a3,0(a5)
 82e:	00000717          	auipc	a4,0x0
 832:	24f73923          	sd	a5,594(a4) # a80 <freep>
 836:	6422                	ld	s0,8(sp)
 838:	0141                	addi	sp,sp,16
 83a:	8082                	ret

000000000000083c <malloc>:
 83c:	7139                	addi	sp,sp,-64
 83e:	fc06                	sd	ra,56(sp)
 840:	f822                	sd	s0,48(sp)
 842:	f426                	sd	s1,40(sp)
 844:	f04a                	sd	s2,32(sp)
 846:	ec4e                	sd	s3,24(sp)
 848:	e852                	sd	s4,16(sp)
 84a:	e456                	sd	s5,8(sp)
 84c:	e05a                	sd	s6,0(sp)
 84e:	0080                	addi	s0,sp,64
 850:	02051493          	slli	s1,a0,0x20
 854:	9081                	srli	s1,s1,0x20
 856:	04bd                	addi	s1,s1,15
 858:	8091                	srli	s1,s1,0x4
 85a:	0014899b          	addiw	s3,s1,1
 85e:	0485                	addi	s1,s1,1
 860:	00000517          	auipc	a0,0x0
 864:	22053503          	ld	a0,544(a0) # a80 <freep>
 868:	c515                	beqz	a0,894 <malloc+0x58>
 86a:	611c                	ld	a5,0(a0)
 86c:	4798                	lw	a4,8(a5)
 86e:	02977f63          	bgeu	a4,s1,8ac <malloc+0x70>
 872:	8a4e                	mv	s4,s3
 874:	0009871b          	sext.w	a4,s3
 878:	6685                	lui	a3,0x1
 87a:	00d77363          	bgeu	a4,a3,880 <malloc+0x44>
 87e:	6a05                	lui	s4,0x1
 880:	000a0b1b          	sext.w	s6,s4
 884:	004a1a1b          	slliw	s4,s4,0x4
 888:	00000917          	auipc	s2,0x0
 88c:	1f890913          	addi	s2,s2,504 # a80 <freep>
 890:	5afd                	li	s5,-1
 892:	a88d                	j	904 <malloc+0xc8>
 894:	00000797          	auipc	a5,0x0
 898:	3f478793          	addi	a5,a5,1012 # c88 <base>
 89c:	00000717          	auipc	a4,0x0
 8a0:	1ef73223          	sd	a5,484(a4) # a80 <freep>
 8a4:	e39c                	sd	a5,0(a5)
 8a6:	0007a423          	sw	zero,8(a5)
 8aa:	b7e1                	j	872 <malloc+0x36>
 8ac:	02e48b63          	beq	s1,a4,8e2 <malloc+0xa6>
 8b0:	4137073b          	subw	a4,a4,s3
 8b4:	c798                	sw	a4,8(a5)
 8b6:	1702                	slli	a4,a4,0x20
 8b8:	9301                	srli	a4,a4,0x20
 8ba:	0712                	slli	a4,a4,0x4
 8bc:	97ba                	add	a5,a5,a4
 8be:	0137a423          	sw	s3,8(a5)
 8c2:	00000717          	auipc	a4,0x0
 8c6:	1aa73f23          	sd	a0,446(a4) # a80 <freep>
 8ca:	01078513          	addi	a0,a5,16
 8ce:	70e2                	ld	ra,56(sp)
 8d0:	7442                	ld	s0,48(sp)
 8d2:	74a2                	ld	s1,40(sp)
 8d4:	7902                	ld	s2,32(sp)
 8d6:	69e2                	ld	s3,24(sp)
 8d8:	6a42                	ld	s4,16(sp)
 8da:	6aa2                	ld	s5,8(sp)
 8dc:	6b02                	ld	s6,0(sp)
 8de:	6121                	addi	sp,sp,64
 8e0:	8082                	ret
 8e2:	6398                	ld	a4,0(a5)
 8e4:	e118                	sd	a4,0(a0)
 8e6:	bff1                	j	8c2 <malloc+0x86>
 8e8:	01652423          	sw	s6,8(a0)
 8ec:	0541                	addi	a0,a0,16
 8ee:	00000097          	auipc	ra,0x0
 8f2:	ec6080e7          	jalr	-314(ra) # 7b4 <free>
 8f6:	00093503          	ld	a0,0(s2)
 8fa:	d971                	beqz	a0,8ce <malloc+0x92>
 8fc:	611c                	ld	a5,0(a0)
 8fe:	4798                	lw	a4,8(a5)
 900:	fa9776e3          	bgeu	a4,s1,8ac <malloc+0x70>
 904:	00093703          	ld	a4,0(s2)
 908:	853e                	mv	a0,a5
 90a:	fef719e3          	bne	a4,a5,8fc <malloc+0xc0>
 90e:	8552                	mv	a0,s4
 910:	00000097          	auipc	ra,0x0
 914:	b7c080e7          	jalr	-1156(ra) # 48c <sbrk>
 918:	fd5518e3          	bne	a0,s5,8e8 <malloc+0xac>
 91c:	4501                	li	a0,0
 91e:	bf45                	j	8ce <malloc+0x92>

0000000000000920 <mem_init>:
 920:	1141                	addi	sp,sp,-16
 922:	e406                	sd	ra,8(sp)
 924:	e022                	sd	s0,0(sp)
 926:	0800                	addi	s0,sp,16
 928:	6505                	lui	a0,0x1
 92a:	00000097          	auipc	ra,0x0
 92e:	b62080e7          	jalr	-1182(ra) # 48c <sbrk>
 932:	00000797          	auipc	a5,0x0
 936:	14a7b323          	sd	a0,326(a5) # a78 <alloc>
 93a:	00850793          	addi	a5,a0,8 # 1008 <__BSS_END__+0x370>
 93e:	e11c                	sd	a5,0(a0)
 940:	60a2                	ld	ra,8(sp)
 942:	6402                	ld	s0,0(sp)
 944:	0141                	addi	sp,sp,16
 946:	8082                	ret

0000000000000948 <l_alloc>:
 948:	1101                	addi	sp,sp,-32
 94a:	ec06                	sd	ra,24(sp)
 94c:	e822                	sd	s0,16(sp)
 94e:	e426                	sd	s1,8(sp)
 950:	1000                	addi	s0,sp,32
 952:	84aa                	mv	s1,a0
 954:	00000797          	auipc	a5,0x0
 958:	11c7a783          	lw	a5,284(a5) # a70 <if_init>
 95c:	c795                	beqz	a5,988 <l_alloc+0x40>
 95e:	00000717          	auipc	a4,0x0
 962:	11a73703          	ld	a4,282(a4) # a78 <alloc>
 966:	6308                	ld	a0,0(a4)
 968:	40e506b3          	sub	a3,a0,a4
 96c:	6785                	lui	a5,0x1
 96e:	37e1                	addiw	a5,a5,-8
 970:	9f95                	subw	a5,a5,a3
 972:	02f4f563          	bgeu	s1,a5,99c <l_alloc+0x54>
 976:	1482                	slli	s1,s1,0x20
 978:	9081                	srli	s1,s1,0x20
 97a:	94aa                	add	s1,s1,a0
 97c:	e304                	sd	s1,0(a4)
 97e:	60e2                	ld	ra,24(sp)
 980:	6442                	ld	s0,16(sp)
 982:	64a2                	ld	s1,8(sp)
 984:	6105                	addi	sp,sp,32
 986:	8082                	ret
 988:	00000097          	auipc	ra,0x0
 98c:	f98080e7          	jalr	-104(ra) # 920 <mem_init>
 990:	4785                	li	a5,1
 992:	00000717          	auipc	a4,0x0
 996:	0cf72f23          	sw	a5,222(a4) # a70 <if_init>
 99a:	b7d1                	j	95e <l_alloc+0x16>
 99c:	4501                	li	a0,0
 99e:	b7c5                	j	97e <l_alloc+0x36>

00000000000009a0 <l_free>:
 9a0:	1141                	addi	sp,sp,-16
 9a2:	e422                	sd	s0,8(sp)
 9a4:	0800                	addi	s0,sp,16
 9a6:	6422                	ld	s0,8(sp)
 9a8:	0141                	addi	sp,sp,16
 9aa:	8082                	ret
