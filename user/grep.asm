
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  16:	02e00a13          	li	s4,46
  1a:	85a6                	mv	a1,s1
  1c:	854e                	mv	a0,s3
  1e:	00000097          	auipc	ra,0x0
  22:	030080e7          	jalr	48(ra) # 4e <matchhere>
  26:	e919                	bnez	a0,3c <matchstar+0x3c>
  28:	0004c783          	lbu	a5,0(s1)
  2c:	cb89                	beqz	a5,3e <matchstar+0x3e>
  2e:	0485                	addi	s1,s1,1
  30:	2781                	sext.w	a5,a5
  32:	ff2784e3          	beq	a5,s2,1a <matchstar+0x1a>
  36:	ff4902e3          	beq	s2,s4,1a <matchstar+0x1a>
  3a:	a011                	j	3e <matchstar+0x3e>
  3c:	4505                	li	a0,1
  3e:	70a2                	ld	ra,40(sp)
  40:	7402                	ld	s0,32(sp)
  42:	64e2                	ld	s1,24(sp)
  44:	6942                	ld	s2,16(sp)
  46:	69a2                	ld	s3,8(sp)
  48:	6a02                	ld	s4,0(sp)
  4a:	6145                	addi	sp,sp,48
  4c:	8082                	ret

000000000000004e <matchhere>:
  4e:	00054703          	lbu	a4,0(a0)
  52:	cb3d                	beqz	a4,c8 <matchhere+0x7a>
  54:	1141                	addi	sp,sp,-16
  56:	e406                	sd	ra,8(sp)
  58:	e022                	sd	s0,0(sp)
  5a:	0800                	addi	s0,sp,16
  5c:	87aa                	mv	a5,a0
  5e:	00154683          	lbu	a3,1(a0)
  62:	02a00613          	li	a2,42
  66:	02c68563          	beq	a3,a2,90 <matchhere+0x42>
  6a:	02400613          	li	a2,36
  6e:	02c70a63          	beq	a4,a2,a2 <matchhere+0x54>
  72:	0005c683          	lbu	a3,0(a1)
  76:	4501                	li	a0,0
  78:	ca81                	beqz	a3,88 <matchhere+0x3a>
  7a:	02e00613          	li	a2,46
  7e:	02c70d63          	beq	a4,a2,b8 <matchhere+0x6a>
  82:	4501                	li	a0,0
  84:	02d70a63          	beq	a4,a3,b8 <matchhere+0x6a>
  88:	60a2                	ld	ra,8(sp)
  8a:	6402                	ld	s0,0(sp)
  8c:	0141                	addi	sp,sp,16
  8e:	8082                	ret
  90:	862e                	mv	a2,a1
  92:	00250593          	addi	a1,a0,2
  96:	853a                	mv	a0,a4
  98:	00000097          	auipc	ra,0x0
  9c:	f68080e7          	jalr	-152(ra) # 0 <matchstar>
  a0:	b7e5                	j	88 <matchhere+0x3a>
  a2:	c691                	beqz	a3,ae <matchhere+0x60>
  a4:	0005c683          	lbu	a3,0(a1)
  a8:	fee9                	bnez	a3,82 <matchhere+0x34>
  aa:	4501                	li	a0,0
  ac:	bff1                	j	88 <matchhere+0x3a>
  ae:	0005c503          	lbu	a0,0(a1)
  b2:	00153513          	seqz	a0,a0
  b6:	bfc9                	j	88 <matchhere+0x3a>
  b8:	0585                	addi	a1,a1,1
  ba:	00178513          	addi	a0,a5,1
  be:	00000097          	auipc	ra,0x0
  c2:	f90080e7          	jalr	-112(ra) # 4e <matchhere>
  c6:	b7c9                	j	88 <matchhere+0x3a>
  c8:	4505                	li	a0,1
  ca:	8082                	ret

00000000000000cc <match>:
  cc:	1101                	addi	sp,sp,-32
  ce:	ec06                	sd	ra,24(sp)
  d0:	e822                	sd	s0,16(sp)
  d2:	e426                	sd	s1,8(sp)
  d4:	e04a                	sd	s2,0(sp)
  d6:	1000                	addi	s0,sp,32
  d8:	892a                	mv	s2,a0
  da:	84ae                	mv	s1,a1
  dc:	00054703          	lbu	a4,0(a0)
  e0:	05e00793          	li	a5,94
  e4:	00f70e63          	beq	a4,a5,100 <match+0x34>
  e8:	85a6                	mv	a1,s1
  ea:	854a                	mv	a0,s2
  ec:	00000097          	auipc	ra,0x0
  f0:	f62080e7          	jalr	-158(ra) # 4e <matchhere>
  f4:	ed01                	bnez	a0,10c <match+0x40>
  f6:	0485                	addi	s1,s1,1
  f8:	fff4c783          	lbu	a5,-1(s1)
  fc:	f7f5                	bnez	a5,e8 <match+0x1c>
  fe:	a801                	j	10e <match+0x42>
 100:	0505                	addi	a0,a0,1
 102:	00000097          	auipc	ra,0x0
 106:	f4c080e7          	jalr	-180(ra) # 4e <matchhere>
 10a:	a011                	j	10e <match+0x42>
 10c:	4505                	li	a0,1
 10e:	60e2                	ld	ra,24(sp)
 110:	6442                	ld	s0,16(sp)
 112:	64a2                	ld	s1,8(sp)
 114:	6902                	ld	s2,0(sp)
 116:	6105                	addi	sp,sp,32
 118:	8082                	ret

000000000000011a <grep>:
 11a:	715d                	addi	sp,sp,-80
 11c:	e486                	sd	ra,72(sp)
 11e:	e0a2                	sd	s0,64(sp)
 120:	fc26                	sd	s1,56(sp)
 122:	f84a                	sd	s2,48(sp)
 124:	f44e                	sd	s3,40(sp)
 126:	f052                	sd	s4,32(sp)
 128:	ec56                	sd	s5,24(sp)
 12a:	e85a                	sd	s6,16(sp)
 12c:	e45e                	sd	s7,8(sp)
 12e:	0880                	addi	s0,sp,80
 130:	89aa                	mv	s3,a0
 132:	8b2e                	mv	s6,a1
 134:	4a01                	li	s4,0
 136:	3ff00b93          	li	s7,1023
 13a:	00001a97          	auipc	s5,0x1
 13e:	a46a8a93          	addi	s5,s5,-1466 # b80 <buf>
 142:	a0a1                	j	18a <grep+0x70>
 144:	00148913          	addi	s2,s1,1
 148:	45a9                	li	a1,10
 14a:	854a                	mv	a0,s2
 14c:	00000097          	auipc	ra,0x0
 150:	1e6080e7          	jalr	486(ra) # 332 <strchr>
 154:	84aa                	mv	s1,a0
 156:	c905                	beqz	a0,186 <grep+0x6c>
 158:	00048023          	sb	zero,0(s1)
 15c:	85ca                	mv	a1,s2
 15e:	854e                	mv	a0,s3
 160:	00000097          	auipc	ra,0x0
 164:	f6c080e7          	jalr	-148(ra) # cc <match>
 168:	dd71                	beqz	a0,144 <grep+0x2a>
 16a:	47a9                	li	a5,10
 16c:	00f48023          	sb	a5,0(s1)
 170:	00148613          	addi	a2,s1,1
 174:	4126063b          	subw	a2,a2,s2
 178:	85ca                	mv	a1,s2
 17a:	4505                	li	a0,1
 17c:	00000097          	auipc	ra,0x0
 180:	3b0080e7          	jalr	944(ra) # 52c <write>
 184:	b7c1                	j	144 <grep+0x2a>
 186:	03404563          	bgtz	s4,1b0 <grep+0x96>
 18a:	414b863b          	subw	a2,s7,s4
 18e:	014a85b3          	add	a1,s5,s4
 192:	855a                	mv	a0,s6
 194:	00000097          	auipc	ra,0x0
 198:	390080e7          	jalr	912(ra) # 524 <read>
 19c:	02a05663          	blez	a0,1c8 <grep+0xae>
 1a0:	00aa0a3b          	addw	s4,s4,a0
 1a4:	014a87b3          	add	a5,s5,s4
 1a8:	00078023          	sb	zero,0(a5)
 1ac:	8956                	mv	s2,s5
 1ae:	bf69                	j	148 <grep+0x2e>
 1b0:	415907b3          	sub	a5,s2,s5
 1b4:	40fa0a3b          	subw	s4,s4,a5
 1b8:	8652                	mv	a2,s4
 1ba:	85ca                	mv	a1,s2
 1bc:	8556                	mv	a0,s5
 1be:	00000097          	auipc	ra,0x0
 1c2:	29c080e7          	jalr	668(ra) # 45a <memmove>
 1c6:	b7d1                	j	18a <grep+0x70>
 1c8:	60a6                	ld	ra,72(sp)
 1ca:	6406                	ld	s0,64(sp)
 1cc:	74e2                	ld	s1,56(sp)
 1ce:	7942                	ld	s2,48(sp)
 1d0:	79a2                	ld	s3,40(sp)
 1d2:	7a02                	ld	s4,32(sp)
 1d4:	6ae2                	ld	s5,24(sp)
 1d6:	6b42                	ld	s6,16(sp)
 1d8:	6ba2                	ld	s7,8(sp)
 1da:	6161                	addi	sp,sp,80
 1dc:	8082                	ret

00000000000001de <main>:
 1de:	7139                	addi	sp,sp,-64
 1e0:	fc06                	sd	ra,56(sp)
 1e2:	f822                	sd	s0,48(sp)
 1e4:	f426                	sd	s1,40(sp)
 1e6:	f04a                	sd	s2,32(sp)
 1e8:	ec4e                	sd	s3,24(sp)
 1ea:	e852                	sd	s4,16(sp)
 1ec:	e456                	sd	s5,8(sp)
 1ee:	0080                	addi	s0,sp,64
 1f0:	4785                	li	a5,1
 1f2:	04a7de63          	bge	a5,a0,24e <main+0x70>
 1f6:	0085ba03          	ld	s4,8(a1)
 1fa:	4789                	li	a5,2
 1fc:	06a7d763          	bge	a5,a0,26a <main+0x8c>
 200:	01058913          	addi	s2,a1,16
 204:	ffd5099b          	addiw	s3,a0,-3
 208:	1982                	slli	s3,s3,0x20
 20a:	0209d993          	srli	s3,s3,0x20
 20e:	098e                	slli	s3,s3,0x3
 210:	05e1                	addi	a1,a1,24
 212:	99ae                	add	s3,s3,a1
 214:	4581                	li	a1,0
 216:	00093503          	ld	a0,0(s2)
 21a:	00000097          	auipc	ra,0x0
 21e:	332080e7          	jalr	818(ra) # 54c <open>
 222:	84aa                	mv	s1,a0
 224:	04054e63          	bltz	a0,280 <main+0xa2>
 228:	85aa                	mv	a1,a0
 22a:	8552                	mv	a0,s4
 22c:	00000097          	auipc	ra,0x0
 230:	eee080e7          	jalr	-274(ra) # 11a <grep>
 234:	8526                	mv	a0,s1
 236:	00000097          	auipc	ra,0x0
 23a:	2fe080e7          	jalr	766(ra) # 534 <close>
 23e:	0921                	addi	s2,s2,8
 240:	fd391ae3          	bne	s2,s3,214 <main+0x36>
 244:	4501                	li	a0,0
 246:	00000097          	auipc	ra,0x0
 24a:	2c6080e7          	jalr	710(ra) # 50c <exit>
 24e:	00001597          	auipc	a1,0x1
 252:	86a58593          	addi	a1,a1,-1942 # ab8 <l_free+0x10>
 256:	4509                	li	a0,2
 258:	00000097          	auipc	ra,0x0
 25c:	600080e7          	jalr	1536(ra) # 858 <fprintf>
 260:	4505                	li	a0,1
 262:	00000097          	auipc	ra,0x0
 266:	2aa080e7          	jalr	682(ra) # 50c <exit>
 26a:	4581                	li	a1,0
 26c:	8552                	mv	a0,s4
 26e:	00000097          	auipc	ra,0x0
 272:	eac080e7          	jalr	-340(ra) # 11a <grep>
 276:	4501                	li	a0,0
 278:	00000097          	auipc	ra,0x0
 27c:	294080e7          	jalr	660(ra) # 50c <exit>
 280:	00093583          	ld	a1,0(s2)
 284:	00001517          	auipc	a0,0x1
 288:	85450513          	addi	a0,a0,-1964 # ad8 <l_free+0x30>
 28c:	00000097          	auipc	ra,0x0
 290:	5fa080e7          	jalr	1530(ra) # 886 <printf>
 294:	4505                	li	a0,1
 296:	00000097          	auipc	ra,0x0
 29a:	276080e7          	jalr	630(ra) # 50c <exit>

000000000000029e <strcpy>:
 29e:	1141                	addi	sp,sp,-16
 2a0:	e422                	sd	s0,8(sp)
 2a2:	0800                	addi	s0,sp,16
 2a4:	87aa                	mv	a5,a0
 2a6:	0585                	addi	a1,a1,1
 2a8:	0785                	addi	a5,a5,1
 2aa:	fff5c703          	lbu	a4,-1(a1)
 2ae:	fee78fa3          	sb	a4,-1(a5)
 2b2:	fb75                	bnez	a4,2a6 <strcpy+0x8>
 2b4:	6422                	ld	s0,8(sp)
 2b6:	0141                	addi	sp,sp,16
 2b8:	8082                	ret

00000000000002ba <strcmp>:
 2ba:	1141                	addi	sp,sp,-16
 2bc:	e422                	sd	s0,8(sp)
 2be:	0800                	addi	s0,sp,16
 2c0:	00054783          	lbu	a5,0(a0)
 2c4:	cb91                	beqz	a5,2d8 <strcmp+0x1e>
 2c6:	0005c703          	lbu	a4,0(a1)
 2ca:	00f71763          	bne	a4,a5,2d8 <strcmp+0x1e>
 2ce:	0505                	addi	a0,a0,1
 2d0:	0585                	addi	a1,a1,1
 2d2:	00054783          	lbu	a5,0(a0)
 2d6:	fbe5                	bnez	a5,2c6 <strcmp+0xc>
 2d8:	0005c503          	lbu	a0,0(a1)
 2dc:	40a7853b          	subw	a0,a5,a0
 2e0:	6422                	ld	s0,8(sp)
 2e2:	0141                	addi	sp,sp,16
 2e4:	8082                	ret

00000000000002e6 <strlen>:
 2e6:	1141                	addi	sp,sp,-16
 2e8:	e422                	sd	s0,8(sp)
 2ea:	0800                	addi	s0,sp,16
 2ec:	00054783          	lbu	a5,0(a0)
 2f0:	cf91                	beqz	a5,30c <strlen+0x26>
 2f2:	0505                	addi	a0,a0,1
 2f4:	87aa                	mv	a5,a0
 2f6:	4685                	li	a3,1
 2f8:	9e89                	subw	a3,a3,a0
 2fa:	00f6853b          	addw	a0,a3,a5
 2fe:	0785                	addi	a5,a5,1
 300:	fff7c703          	lbu	a4,-1(a5)
 304:	fb7d                	bnez	a4,2fa <strlen+0x14>
 306:	6422                	ld	s0,8(sp)
 308:	0141                	addi	sp,sp,16
 30a:	8082                	ret
 30c:	4501                	li	a0,0
 30e:	bfe5                	j	306 <strlen+0x20>

0000000000000310 <memset>:
 310:	1141                	addi	sp,sp,-16
 312:	e422                	sd	s0,8(sp)
 314:	0800                	addi	s0,sp,16
 316:	ca19                	beqz	a2,32c <memset+0x1c>
 318:	87aa                	mv	a5,a0
 31a:	1602                	slli	a2,a2,0x20
 31c:	9201                	srli	a2,a2,0x20
 31e:	00a60733          	add	a4,a2,a0
 322:	00b78023          	sb	a1,0(a5)
 326:	0785                	addi	a5,a5,1
 328:	fee79de3          	bne	a5,a4,322 <memset+0x12>
 32c:	6422                	ld	s0,8(sp)
 32e:	0141                	addi	sp,sp,16
 330:	8082                	ret

0000000000000332 <strchr>:
 332:	1141                	addi	sp,sp,-16
 334:	e422                	sd	s0,8(sp)
 336:	0800                	addi	s0,sp,16
 338:	00054783          	lbu	a5,0(a0)
 33c:	cb99                	beqz	a5,352 <strchr+0x20>
 33e:	00f58763          	beq	a1,a5,34c <strchr+0x1a>
 342:	0505                	addi	a0,a0,1
 344:	00054783          	lbu	a5,0(a0)
 348:	fbfd                	bnez	a5,33e <strchr+0xc>
 34a:	4501                	li	a0,0
 34c:	6422                	ld	s0,8(sp)
 34e:	0141                	addi	sp,sp,16
 350:	8082                	ret
 352:	4501                	li	a0,0
 354:	bfe5                	j	34c <strchr+0x1a>

0000000000000356 <gets>:
 356:	711d                	addi	sp,sp,-96
 358:	ec86                	sd	ra,88(sp)
 35a:	e8a2                	sd	s0,80(sp)
 35c:	e4a6                	sd	s1,72(sp)
 35e:	e0ca                	sd	s2,64(sp)
 360:	fc4e                	sd	s3,56(sp)
 362:	f852                	sd	s4,48(sp)
 364:	f456                	sd	s5,40(sp)
 366:	f05a                	sd	s6,32(sp)
 368:	ec5e                	sd	s7,24(sp)
 36a:	1080                	addi	s0,sp,96
 36c:	8baa                	mv	s7,a0
 36e:	8a2e                	mv	s4,a1
 370:	892a                	mv	s2,a0
 372:	4481                	li	s1,0
 374:	4aa9                	li	s5,10
 376:	4b35                	li	s6,13
 378:	89a6                	mv	s3,s1
 37a:	2485                	addiw	s1,s1,1
 37c:	0344d863          	bge	s1,s4,3ac <gets+0x56>
 380:	4605                	li	a2,1
 382:	faf40593          	addi	a1,s0,-81
 386:	4501                	li	a0,0
 388:	00000097          	auipc	ra,0x0
 38c:	19c080e7          	jalr	412(ra) # 524 <read>
 390:	00a05e63          	blez	a0,3ac <gets+0x56>
 394:	faf44783          	lbu	a5,-81(s0)
 398:	00f90023          	sb	a5,0(s2)
 39c:	01578763          	beq	a5,s5,3aa <gets+0x54>
 3a0:	0905                	addi	s2,s2,1
 3a2:	fd679be3          	bne	a5,s6,378 <gets+0x22>
 3a6:	89a6                	mv	s3,s1
 3a8:	a011                	j	3ac <gets+0x56>
 3aa:	89a6                	mv	s3,s1
 3ac:	99de                	add	s3,s3,s7
 3ae:	00098023          	sb	zero,0(s3)
 3b2:	855e                	mv	a0,s7
 3b4:	60e6                	ld	ra,88(sp)
 3b6:	6446                	ld	s0,80(sp)
 3b8:	64a6                	ld	s1,72(sp)
 3ba:	6906                	ld	s2,64(sp)
 3bc:	79e2                	ld	s3,56(sp)
 3be:	7a42                	ld	s4,48(sp)
 3c0:	7aa2                	ld	s5,40(sp)
 3c2:	7b02                	ld	s6,32(sp)
 3c4:	6be2                	ld	s7,24(sp)
 3c6:	6125                	addi	sp,sp,96
 3c8:	8082                	ret

00000000000003ca <stat>:
 3ca:	1101                	addi	sp,sp,-32
 3cc:	ec06                	sd	ra,24(sp)
 3ce:	e822                	sd	s0,16(sp)
 3d0:	e426                	sd	s1,8(sp)
 3d2:	e04a                	sd	s2,0(sp)
 3d4:	1000                	addi	s0,sp,32
 3d6:	892e                	mv	s2,a1
 3d8:	4581                	li	a1,0
 3da:	00000097          	auipc	ra,0x0
 3de:	172080e7          	jalr	370(ra) # 54c <open>
 3e2:	02054563          	bltz	a0,40c <stat+0x42>
 3e6:	84aa                	mv	s1,a0
 3e8:	85ca                	mv	a1,s2
 3ea:	00000097          	auipc	ra,0x0
 3ee:	17a080e7          	jalr	378(ra) # 564 <fstat>
 3f2:	892a                	mv	s2,a0
 3f4:	8526                	mv	a0,s1
 3f6:	00000097          	auipc	ra,0x0
 3fa:	13e080e7          	jalr	318(ra) # 534 <close>
 3fe:	854a                	mv	a0,s2
 400:	60e2                	ld	ra,24(sp)
 402:	6442                	ld	s0,16(sp)
 404:	64a2                	ld	s1,8(sp)
 406:	6902                	ld	s2,0(sp)
 408:	6105                	addi	sp,sp,32
 40a:	8082                	ret
 40c:	597d                	li	s2,-1
 40e:	bfc5                	j	3fe <stat+0x34>

0000000000000410 <atoi>:
 410:	1141                	addi	sp,sp,-16
 412:	e422                	sd	s0,8(sp)
 414:	0800                	addi	s0,sp,16
 416:	00054603          	lbu	a2,0(a0)
 41a:	fd06079b          	addiw	a5,a2,-48
 41e:	0ff7f793          	zext.b	a5,a5
 422:	4725                	li	a4,9
 424:	02f76963          	bltu	a4,a5,456 <atoi+0x46>
 428:	86aa                	mv	a3,a0
 42a:	4501                	li	a0,0
 42c:	45a5                	li	a1,9
 42e:	0685                	addi	a3,a3,1
 430:	0025179b          	slliw	a5,a0,0x2
 434:	9fa9                	addw	a5,a5,a0
 436:	0017979b          	slliw	a5,a5,0x1
 43a:	9fb1                	addw	a5,a5,a2
 43c:	fd07851b          	addiw	a0,a5,-48
 440:	0006c603          	lbu	a2,0(a3)
 444:	fd06071b          	addiw	a4,a2,-48
 448:	0ff77713          	zext.b	a4,a4
 44c:	fee5f1e3          	bgeu	a1,a4,42e <atoi+0x1e>
 450:	6422                	ld	s0,8(sp)
 452:	0141                	addi	sp,sp,16
 454:	8082                	ret
 456:	4501                	li	a0,0
 458:	bfe5                	j	450 <atoi+0x40>

000000000000045a <memmove>:
 45a:	1141                	addi	sp,sp,-16
 45c:	e422                	sd	s0,8(sp)
 45e:	0800                	addi	s0,sp,16
 460:	02b57463          	bgeu	a0,a1,488 <memmove+0x2e>
 464:	00c05f63          	blez	a2,482 <memmove+0x28>
 468:	1602                	slli	a2,a2,0x20
 46a:	9201                	srli	a2,a2,0x20
 46c:	00c507b3          	add	a5,a0,a2
 470:	872a                	mv	a4,a0
 472:	0585                	addi	a1,a1,1
 474:	0705                	addi	a4,a4,1
 476:	fff5c683          	lbu	a3,-1(a1)
 47a:	fed70fa3          	sb	a3,-1(a4)
 47e:	fee79ae3          	bne	a5,a4,472 <memmove+0x18>
 482:	6422                	ld	s0,8(sp)
 484:	0141                	addi	sp,sp,16
 486:	8082                	ret
 488:	00c50733          	add	a4,a0,a2
 48c:	95b2                	add	a1,a1,a2
 48e:	fec05ae3          	blez	a2,482 <memmove+0x28>
 492:	fff6079b          	addiw	a5,a2,-1
 496:	1782                	slli	a5,a5,0x20
 498:	9381                	srli	a5,a5,0x20
 49a:	fff7c793          	not	a5,a5
 49e:	97ba                	add	a5,a5,a4
 4a0:	15fd                	addi	a1,a1,-1
 4a2:	177d                	addi	a4,a4,-1
 4a4:	0005c683          	lbu	a3,0(a1)
 4a8:	00d70023          	sb	a3,0(a4)
 4ac:	fee79ae3          	bne	a5,a4,4a0 <memmove+0x46>
 4b0:	bfc9                	j	482 <memmove+0x28>

00000000000004b2 <memcmp>:
 4b2:	1141                	addi	sp,sp,-16
 4b4:	e422                	sd	s0,8(sp)
 4b6:	0800                	addi	s0,sp,16
 4b8:	ca05                	beqz	a2,4e8 <memcmp+0x36>
 4ba:	fff6069b          	addiw	a3,a2,-1
 4be:	1682                	slli	a3,a3,0x20
 4c0:	9281                	srli	a3,a3,0x20
 4c2:	0685                	addi	a3,a3,1
 4c4:	96aa                	add	a3,a3,a0
 4c6:	00054783          	lbu	a5,0(a0)
 4ca:	0005c703          	lbu	a4,0(a1)
 4ce:	00e79863          	bne	a5,a4,4de <memcmp+0x2c>
 4d2:	0505                	addi	a0,a0,1
 4d4:	0585                	addi	a1,a1,1
 4d6:	fed518e3          	bne	a0,a3,4c6 <memcmp+0x14>
 4da:	4501                	li	a0,0
 4dc:	a019                	j	4e2 <memcmp+0x30>
 4de:	40e7853b          	subw	a0,a5,a4
 4e2:	6422                	ld	s0,8(sp)
 4e4:	0141                	addi	sp,sp,16
 4e6:	8082                	ret
 4e8:	4501                	li	a0,0
 4ea:	bfe5                	j	4e2 <memcmp+0x30>

00000000000004ec <memcpy>:
 4ec:	1141                	addi	sp,sp,-16
 4ee:	e406                	sd	ra,8(sp)
 4f0:	e022                	sd	s0,0(sp)
 4f2:	0800                	addi	s0,sp,16
 4f4:	00000097          	auipc	ra,0x0
 4f8:	f66080e7          	jalr	-154(ra) # 45a <memmove>
 4fc:	60a2                	ld	ra,8(sp)
 4fe:	6402                	ld	s0,0(sp)
 500:	0141                	addi	sp,sp,16
 502:	8082                	ret

0000000000000504 <fork>:
 504:	4885                	li	a7,1
 506:	00000073          	ecall
 50a:	8082                	ret

000000000000050c <exit>:
 50c:	4889                	li	a7,2
 50e:	00000073          	ecall
 512:	8082                	ret

0000000000000514 <wait>:
 514:	488d                	li	a7,3
 516:	00000073          	ecall
 51a:	8082                	ret

000000000000051c <pipe>:
 51c:	4891                	li	a7,4
 51e:	00000073          	ecall
 522:	8082                	ret

0000000000000524 <read>:
 524:	4895                	li	a7,5
 526:	00000073          	ecall
 52a:	8082                	ret

000000000000052c <write>:
 52c:	48c1                	li	a7,16
 52e:	00000073          	ecall
 532:	8082                	ret

0000000000000534 <close>:
 534:	48d5                	li	a7,21
 536:	00000073          	ecall
 53a:	8082                	ret

000000000000053c <kill>:
 53c:	4899                	li	a7,6
 53e:	00000073          	ecall
 542:	8082                	ret

0000000000000544 <exec>:
 544:	489d                	li	a7,7
 546:	00000073          	ecall
 54a:	8082                	ret

000000000000054c <open>:
 54c:	48bd                	li	a7,15
 54e:	00000073          	ecall
 552:	8082                	ret

0000000000000554 <mknod>:
 554:	48c5                	li	a7,17
 556:	00000073          	ecall
 55a:	8082                	ret

000000000000055c <unlink>:
 55c:	48c9                	li	a7,18
 55e:	00000073          	ecall
 562:	8082                	ret

0000000000000564 <fstat>:
 564:	48a1                	li	a7,8
 566:	00000073          	ecall
 56a:	8082                	ret

000000000000056c <link>:
 56c:	48cd                	li	a7,19
 56e:	00000073          	ecall
 572:	8082                	ret

0000000000000574 <mkdir>:
 574:	48d1                	li	a7,20
 576:	00000073          	ecall
 57a:	8082                	ret

000000000000057c <chdir>:
 57c:	48a5                	li	a7,9
 57e:	00000073          	ecall
 582:	8082                	ret

0000000000000584 <dup>:
 584:	48a9                	li	a7,10
 586:	00000073          	ecall
 58a:	8082                	ret

000000000000058c <getpid>:
 58c:	48ad                	li	a7,11
 58e:	00000073          	ecall
 592:	8082                	ret

0000000000000594 <sbrk>:
 594:	48b1                	li	a7,12
 596:	00000073          	ecall
 59a:	8082                	ret

000000000000059c <sleep>:
 59c:	48b5                	li	a7,13
 59e:	00000073          	ecall
 5a2:	8082                	ret

00000000000005a4 <uptime>:
 5a4:	48b9                	li	a7,14
 5a6:	00000073          	ecall
 5aa:	8082                	ret

00000000000005ac <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5ac:	1101                	addi	sp,sp,-32
 5ae:	ec06                	sd	ra,24(sp)
 5b0:	e822                	sd	s0,16(sp)
 5b2:	1000                	addi	s0,sp,32
 5b4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5b8:	4605                	li	a2,1
 5ba:	fef40593          	addi	a1,s0,-17
 5be:	00000097          	auipc	ra,0x0
 5c2:	f6e080e7          	jalr	-146(ra) # 52c <write>
}
 5c6:	60e2                	ld	ra,24(sp)
 5c8:	6442                	ld	s0,16(sp)
 5ca:	6105                	addi	sp,sp,32
 5cc:	8082                	ret

00000000000005ce <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5ce:	7139                	addi	sp,sp,-64
 5d0:	fc06                	sd	ra,56(sp)
 5d2:	f822                	sd	s0,48(sp)
 5d4:	f426                	sd	s1,40(sp)
 5d6:	f04a                	sd	s2,32(sp)
 5d8:	ec4e                	sd	s3,24(sp)
 5da:	0080                	addi	s0,sp,64
 5dc:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5de:	c299                	beqz	a3,5e4 <printint+0x16>
 5e0:	0805c963          	bltz	a1,672 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5e4:	2581                	sext.w	a1,a1
  neg = 0;
 5e6:	4881                	li	a7,0
 5e8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5ec:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5ee:	2601                	sext.w	a2,a2
 5f0:	00000517          	auipc	a0,0x0
 5f4:	56050513          	addi	a0,a0,1376 # b50 <digits>
 5f8:	883a                	mv	a6,a4
 5fa:	2705                	addiw	a4,a4,1
 5fc:	02c5f7bb          	remuw	a5,a1,a2
 600:	1782                	slli	a5,a5,0x20
 602:	9381                	srli	a5,a5,0x20
 604:	97aa                	add	a5,a5,a0
 606:	0007c783          	lbu	a5,0(a5)
 60a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 60e:	0005879b          	sext.w	a5,a1
 612:	02c5d5bb          	divuw	a1,a1,a2
 616:	0685                	addi	a3,a3,1
 618:	fec7f0e3          	bgeu	a5,a2,5f8 <printint+0x2a>
  if(neg)
 61c:	00088c63          	beqz	a7,634 <printint+0x66>
    buf[i++] = '-';
 620:	fd070793          	addi	a5,a4,-48
 624:	00878733          	add	a4,a5,s0
 628:	02d00793          	li	a5,45
 62c:	fef70823          	sb	a5,-16(a4)
 630:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 634:	02e05863          	blez	a4,664 <printint+0x96>
 638:	fc040793          	addi	a5,s0,-64
 63c:	00e78933          	add	s2,a5,a4
 640:	fff78993          	addi	s3,a5,-1
 644:	99ba                	add	s3,s3,a4
 646:	377d                	addiw	a4,a4,-1
 648:	1702                	slli	a4,a4,0x20
 64a:	9301                	srli	a4,a4,0x20
 64c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 650:	fff94583          	lbu	a1,-1(s2)
 654:	8526                	mv	a0,s1
 656:	00000097          	auipc	ra,0x0
 65a:	f56080e7          	jalr	-170(ra) # 5ac <putc>
  while(--i >= 0)
 65e:	197d                	addi	s2,s2,-1
 660:	ff3918e3          	bne	s2,s3,650 <printint+0x82>
}
 664:	70e2                	ld	ra,56(sp)
 666:	7442                	ld	s0,48(sp)
 668:	74a2                	ld	s1,40(sp)
 66a:	7902                	ld	s2,32(sp)
 66c:	69e2                	ld	s3,24(sp)
 66e:	6121                	addi	sp,sp,64
 670:	8082                	ret
    x = -xx;
 672:	40b005bb          	negw	a1,a1
    neg = 1;
 676:	4885                	li	a7,1
    x = -xx;
 678:	bf85                	j	5e8 <printint+0x1a>

000000000000067a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 67a:	7119                	addi	sp,sp,-128
 67c:	fc86                	sd	ra,120(sp)
 67e:	f8a2                	sd	s0,112(sp)
 680:	f4a6                	sd	s1,104(sp)
 682:	f0ca                	sd	s2,96(sp)
 684:	ecce                	sd	s3,88(sp)
 686:	e8d2                	sd	s4,80(sp)
 688:	e4d6                	sd	s5,72(sp)
 68a:	e0da                	sd	s6,64(sp)
 68c:	fc5e                	sd	s7,56(sp)
 68e:	f862                	sd	s8,48(sp)
 690:	f466                	sd	s9,40(sp)
 692:	f06a                	sd	s10,32(sp)
 694:	ec6e                	sd	s11,24(sp)
 696:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 698:	0005c903          	lbu	s2,0(a1)
 69c:	18090f63          	beqz	s2,83a <vprintf+0x1c0>
 6a0:	8aaa                	mv	s5,a0
 6a2:	8b32                	mv	s6,a2
 6a4:	00158493          	addi	s1,a1,1
  state = 0;
 6a8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6aa:	02500a13          	li	s4,37
 6ae:	4c55                	li	s8,21
 6b0:	00000c97          	auipc	s9,0x0
 6b4:	448c8c93          	addi	s9,s9,1096 # af8 <l_free+0x50>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6b8:	02800d93          	li	s11,40
  putc(fd, 'x');
 6bc:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6be:	00000b97          	auipc	s7,0x0
 6c2:	492b8b93          	addi	s7,s7,1170 # b50 <digits>
 6c6:	a839                	j	6e4 <vprintf+0x6a>
        putc(fd, c);
 6c8:	85ca                	mv	a1,s2
 6ca:	8556                	mv	a0,s5
 6cc:	00000097          	auipc	ra,0x0
 6d0:	ee0080e7          	jalr	-288(ra) # 5ac <putc>
 6d4:	a019                	j	6da <vprintf+0x60>
    } else if(state == '%'){
 6d6:	01498d63          	beq	s3,s4,6f0 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 6da:	0485                	addi	s1,s1,1
 6dc:	fff4c903          	lbu	s2,-1(s1)
 6e0:	14090d63          	beqz	s2,83a <vprintf+0x1c0>
    if(state == 0){
 6e4:	fe0999e3          	bnez	s3,6d6 <vprintf+0x5c>
      if(c == '%'){
 6e8:	ff4910e3          	bne	s2,s4,6c8 <vprintf+0x4e>
        state = '%';
 6ec:	89d2                	mv	s3,s4
 6ee:	b7f5                	j	6da <vprintf+0x60>
      if(c == 'd'){
 6f0:	11490c63          	beq	s2,s4,808 <vprintf+0x18e>
 6f4:	f9d9079b          	addiw	a5,s2,-99
 6f8:	0ff7f793          	zext.b	a5,a5
 6fc:	10fc6e63          	bltu	s8,a5,818 <vprintf+0x19e>
 700:	f9d9079b          	addiw	a5,s2,-99
 704:	0ff7f713          	zext.b	a4,a5
 708:	10ec6863          	bltu	s8,a4,818 <vprintf+0x19e>
 70c:	00271793          	slli	a5,a4,0x2
 710:	97e6                	add	a5,a5,s9
 712:	439c                	lw	a5,0(a5)
 714:	97e6                	add	a5,a5,s9
 716:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 718:	008b0913          	addi	s2,s6,8
 71c:	4685                	li	a3,1
 71e:	4629                	li	a2,10
 720:	000b2583          	lw	a1,0(s6)
 724:	8556                	mv	a0,s5
 726:	00000097          	auipc	ra,0x0
 72a:	ea8080e7          	jalr	-344(ra) # 5ce <printint>
 72e:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 730:	4981                	li	s3,0
 732:	b765                	j	6da <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 734:	008b0913          	addi	s2,s6,8
 738:	4681                	li	a3,0
 73a:	4629                	li	a2,10
 73c:	000b2583          	lw	a1,0(s6)
 740:	8556                	mv	a0,s5
 742:	00000097          	auipc	ra,0x0
 746:	e8c080e7          	jalr	-372(ra) # 5ce <printint>
 74a:	8b4a                	mv	s6,s2
      state = 0;
 74c:	4981                	li	s3,0
 74e:	b771                	j	6da <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 750:	008b0913          	addi	s2,s6,8
 754:	4681                	li	a3,0
 756:	866a                	mv	a2,s10
 758:	000b2583          	lw	a1,0(s6)
 75c:	8556                	mv	a0,s5
 75e:	00000097          	auipc	ra,0x0
 762:	e70080e7          	jalr	-400(ra) # 5ce <printint>
 766:	8b4a                	mv	s6,s2
      state = 0;
 768:	4981                	li	s3,0
 76a:	bf85                	j	6da <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 76c:	008b0793          	addi	a5,s6,8
 770:	f8f43423          	sd	a5,-120(s0)
 774:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 778:	03000593          	li	a1,48
 77c:	8556                	mv	a0,s5
 77e:	00000097          	auipc	ra,0x0
 782:	e2e080e7          	jalr	-466(ra) # 5ac <putc>
  putc(fd, 'x');
 786:	07800593          	li	a1,120
 78a:	8556                	mv	a0,s5
 78c:	00000097          	auipc	ra,0x0
 790:	e20080e7          	jalr	-480(ra) # 5ac <putc>
 794:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 796:	03c9d793          	srli	a5,s3,0x3c
 79a:	97de                	add	a5,a5,s7
 79c:	0007c583          	lbu	a1,0(a5)
 7a0:	8556                	mv	a0,s5
 7a2:	00000097          	auipc	ra,0x0
 7a6:	e0a080e7          	jalr	-502(ra) # 5ac <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7aa:	0992                	slli	s3,s3,0x4
 7ac:	397d                	addiw	s2,s2,-1
 7ae:	fe0914e3          	bnez	s2,796 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 7b2:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 7b6:	4981                	li	s3,0
 7b8:	b70d                	j	6da <vprintf+0x60>
        s = va_arg(ap, char*);
 7ba:	008b0913          	addi	s2,s6,8
 7be:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 7c2:	02098163          	beqz	s3,7e4 <vprintf+0x16a>
        while(*s != 0){
 7c6:	0009c583          	lbu	a1,0(s3)
 7ca:	c5ad                	beqz	a1,834 <vprintf+0x1ba>
          putc(fd, *s);
 7cc:	8556                	mv	a0,s5
 7ce:	00000097          	auipc	ra,0x0
 7d2:	dde080e7          	jalr	-546(ra) # 5ac <putc>
          s++;
 7d6:	0985                	addi	s3,s3,1
        while(*s != 0){
 7d8:	0009c583          	lbu	a1,0(s3)
 7dc:	f9e5                	bnez	a1,7cc <vprintf+0x152>
        s = va_arg(ap, char*);
 7de:	8b4a                	mv	s6,s2
      state = 0;
 7e0:	4981                	li	s3,0
 7e2:	bde5                	j	6da <vprintf+0x60>
          s = "(null)";
 7e4:	00000997          	auipc	s3,0x0
 7e8:	30c98993          	addi	s3,s3,780 # af0 <l_free+0x48>
        while(*s != 0){
 7ec:	85ee                	mv	a1,s11
 7ee:	bff9                	j	7cc <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 7f0:	008b0913          	addi	s2,s6,8
 7f4:	000b4583          	lbu	a1,0(s6)
 7f8:	8556                	mv	a0,s5
 7fa:	00000097          	auipc	ra,0x0
 7fe:	db2080e7          	jalr	-590(ra) # 5ac <putc>
 802:	8b4a                	mv	s6,s2
      state = 0;
 804:	4981                	li	s3,0
 806:	bdd1                	j	6da <vprintf+0x60>
        putc(fd, c);
 808:	85d2                	mv	a1,s4
 80a:	8556                	mv	a0,s5
 80c:	00000097          	auipc	ra,0x0
 810:	da0080e7          	jalr	-608(ra) # 5ac <putc>
      state = 0;
 814:	4981                	li	s3,0
 816:	b5d1                	j	6da <vprintf+0x60>
        putc(fd, '%');
 818:	85d2                	mv	a1,s4
 81a:	8556                	mv	a0,s5
 81c:	00000097          	auipc	ra,0x0
 820:	d90080e7          	jalr	-624(ra) # 5ac <putc>
        putc(fd, c);
 824:	85ca                	mv	a1,s2
 826:	8556                	mv	a0,s5
 828:	00000097          	auipc	ra,0x0
 82c:	d84080e7          	jalr	-636(ra) # 5ac <putc>
      state = 0;
 830:	4981                	li	s3,0
 832:	b565                	j	6da <vprintf+0x60>
        s = va_arg(ap, char*);
 834:	8b4a                	mv	s6,s2
      state = 0;
 836:	4981                	li	s3,0
 838:	b54d                	j	6da <vprintf+0x60>
    }
  }
}
 83a:	70e6                	ld	ra,120(sp)
 83c:	7446                	ld	s0,112(sp)
 83e:	74a6                	ld	s1,104(sp)
 840:	7906                	ld	s2,96(sp)
 842:	69e6                	ld	s3,88(sp)
 844:	6a46                	ld	s4,80(sp)
 846:	6aa6                	ld	s5,72(sp)
 848:	6b06                	ld	s6,64(sp)
 84a:	7be2                	ld	s7,56(sp)
 84c:	7c42                	ld	s8,48(sp)
 84e:	7ca2                	ld	s9,40(sp)
 850:	7d02                	ld	s10,32(sp)
 852:	6de2                	ld	s11,24(sp)
 854:	6109                	addi	sp,sp,128
 856:	8082                	ret

0000000000000858 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 858:	715d                	addi	sp,sp,-80
 85a:	ec06                	sd	ra,24(sp)
 85c:	e822                	sd	s0,16(sp)
 85e:	1000                	addi	s0,sp,32
 860:	e010                	sd	a2,0(s0)
 862:	e414                	sd	a3,8(s0)
 864:	e818                	sd	a4,16(s0)
 866:	ec1c                	sd	a5,24(s0)
 868:	03043023          	sd	a6,32(s0)
 86c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 870:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 874:	8622                	mv	a2,s0
 876:	00000097          	auipc	ra,0x0
 87a:	e04080e7          	jalr	-508(ra) # 67a <vprintf>
}
 87e:	60e2                	ld	ra,24(sp)
 880:	6442                	ld	s0,16(sp)
 882:	6161                	addi	sp,sp,80
 884:	8082                	ret

0000000000000886 <printf>:

void
printf(const char *fmt, ...)
{
 886:	711d                	addi	sp,sp,-96
 888:	ec06                	sd	ra,24(sp)
 88a:	e822                	sd	s0,16(sp)
 88c:	1000                	addi	s0,sp,32
 88e:	e40c                	sd	a1,8(s0)
 890:	e810                	sd	a2,16(s0)
 892:	ec14                	sd	a3,24(s0)
 894:	f018                	sd	a4,32(s0)
 896:	f41c                	sd	a5,40(s0)
 898:	03043823          	sd	a6,48(s0)
 89c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8a0:	00840613          	addi	a2,s0,8
 8a4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8a8:	85aa                	mv	a1,a0
 8aa:	4505                	li	a0,1
 8ac:	00000097          	auipc	ra,0x0
 8b0:	dce080e7          	jalr	-562(ra) # 67a <vprintf>
}
 8b4:	60e2                	ld	ra,24(sp)
 8b6:	6442                	ld	s0,16(sp)
 8b8:	6125                	addi	sp,sp,96
 8ba:	8082                	ret

00000000000008bc <free>:
 8bc:	1141                	addi	sp,sp,-16
 8be:	e422                	sd	s0,8(sp)
 8c0:	0800                	addi	s0,sp,16
 8c2:	ff050693          	addi	a3,a0,-16
 8c6:	00000797          	auipc	a5,0x0
 8ca:	2b27b783          	ld	a5,690(a5) # b78 <freep>
 8ce:	a805                	j	8fe <free+0x42>
 8d0:	4618                	lw	a4,8(a2)
 8d2:	9db9                	addw	a1,a1,a4
 8d4:	feb52c23          	sw	a1,-8(a0)
 8d8:	6398                	ld	a4,0(a5)
 8da:	6318                	ld	a4,0(a4)
 8dc:	fee53823          	sd	a4,-16(a0)
 8e0:	a091                	j	924 <free+0x68>
 8e2:	ff852703          	lw	a4,-8(a0)
 8e6:	9e39                	addw	a2,a2,a4
 8e8:	c790                	sw	a2,8(a5)
 8ea:	ff053703          	ld	a4,-16(a0)
 8ee:	e398                	sd	a4,0(a5)
 8f0:	a099                	j	936 <free+0x7a>
 8f2:	6398                	ld	a4,0(a5)
 8f4:	00e7e463          	bltu	a5,a4,8fc <free+0x40>
 8f8:	00e6ea63          	bltu	a3,a4,90c <free+0x50>
 8fc:	87ba                	mv	a5,a4
 8fe:	fed7fae3          	bgeu	a5,a3,8f2 <free+0x36>
 902:	6398                	ld	a4,0(a5)
 904:	00e6e463          	bltu	a3,a4,90c <free+0x50>
 908:	fee7eae3          	bltu	a5,a4,8fc <free+0x40>
 90c:	ff852583          	lw	a1,-8(a0)
 910:	6390                	ld	a2,0(a5)
 912:	02059713          	slli	a4,a1,0x20
 916:	9301                	srli	a4,a4,0x20
 918:	0712                	slli	a4,a4,0x4
 91a:	9736                	add	a4,a4,a3
 91c:	fae60ae3          	beq	a2,a4,8d0 <free+0x14>
 920:	fec53823          	sd	a2,-16(a0)
 924:	4790                	lw	a2,8(a5)
 926:	02061713          	slli	a4,a2,0x20
 92a:	9301                	srli	a4,a4,0x20
 92c:	0712                	slli	a4,a4,0x4
 92e:	973e                	add	a4,a4,a5
 930:	fae689e3          	beq	a3,a4,8e2 <free+0x26>
 934:	e394                	sd	a3,0(a5)
 936:	00000717          	auipc	a4,0x0
 93a:	24f73123          	sd	a5,578(a4) # b78 <freep>
 93e:	6422                	ld	s0,8(sp)
 940:	0141                	addi	sp,sp,16
 942:	8082                	ret

0000000000000944 <malloc>:
 944:	7139                	addi	sp,sp,-64
 946:	fc06                	sd	ra,56(sp)
 948:	f822                	sd	s0,48(sp)
 94a:	f426                	sd	s1,40(sp)
 94c:	f04a                	sd	s2,32(sp)
 94e:	ec4e                	sd	s3,24(sp)
 950:	e852                	sd	s4,16(sp)
 952:	e456                	sd	s5,8(sp)
 954:	e05a                	sd	s6,0(sp)
 956:	0080                	addi	s0,sp,64
 958:	02051493          	slli	s1,a0,0x20
 95c:	9081                	srli	s1,s1,0x20
 95e:	04bd                	addi	s1,s1,15
 960:	8091                	srli	s1,s1,0x4
 962:	0014899b          	addiw	s3,s1,1
 966:	0485                	addi	s1,s1,1
 968:	00000517          	auipc	a0,0x0
 96c:	21053503          	ld	a0,528(a0) # b78 <freep>
 970:	c515                	beqz	a0,99c <malloc+0x58>
 972:	611c                	ld	a5,0(a0)
 974:	4798                	lw	a4,8(a5)
 976:	02977f63          	bgeu	a4,s1,9b4 <malloc+0x70>
 97a:	8a4e                	mv	s4,s3
 97c:	0009871b          	sext.w	a4,s3
 980:	6685                	lui	a3,0x1
 982:	00d77363          	bgeu	a4,a3,988 <malloc+0x44>
 986:	6a05                	lui	s4,0x1
 988:	000a0b1b          	sext.w	s6,s4
 98c:	004a1a1b          	slliw	s4,s4,0x4
 990:	00000917          	auipc	s2,0x0
 994:	1e890913          	addi	s2,s2,488 # b78 <freep>
 998:	5afd                	li	s5,-1
 99a:	a88d                	j	a0c <malloc+0xc8>
 99c:	00000797          	auipc	a5,0x0
 9a0:	5e478793          	addi	a5,a5,1508 # f80 <base>
 9a4:	00000717          	auipc	a4,0x0
 9a8:	1cf73a23          	sd	a5,468(a4) # b78 <freep>
 9ac:	e39c                	sd	a5,0(a5)
 9ae:	0007a423          	sw	zero,8(a5)
 9b2:	b7e1                	j	97a <malloc+0x36>
 9b4:	02e48b63          	beq	s1,a4,9ea <malloc+0xa6>
 9b8:	4137073b          	subw	a4,a4,s3
 9bc:	c798                	sw	a4,8(a5)
 9be:	1702                	slli	a4,a4,0x20
 9c0:	9301                	srli	a4,a4,0x20
 9c2:	0712                	slli	a4,a4,0x4
 9c4:	97ba                	add	a5,a5,a4
 9c6:	0137a423          	sw	s3,8(a5)
 9ca:	00000717          	auipc	a4,0x0
 9ce:	1aa73723          	sd	a0,430(a4) # b78 <freep>
 9d2:	01078513          	addi	a0,a5,16
 9d6:	70e2                	ld	ra,56(sp)
 9d8:	7442                	ld	s0,48(sp)
 9da:	74a2                	ld	s1,40(sp)
 9dc:	7902                	ld	s2,32(sp)
 9de:	69e2                	ld	s3,24(sp)
 9e0:	6a42                	ld	s4,16(sp)
 9e2:	6aa2                	ld	s5,8(sp)
 9e4:	6b02                	ld	s6,0(sp)
 9e6:	6121                	addi	sp,sp,64
 9e8:	8082                	ret
 9ea:	6398                	ld	a4,0(a5)
 9ec:	e118                	sd	a4,0(a0)
 9ee:	bff1                	j	9ca <malloc+0x86>
 9f0:	01652423          	sw	s6,8(a0)
 9f4:	0541                	addi	a0,a0,16
 9f6:	00000097          	auipc	ra,0x0
 9fa:	ec6080e7          	jalr	-314(ra) # 8bc <free>
 9fe:	00093503          	ld	a0,0(s2)
 a02:	d971                	beqz	a0,9d6 <malloc+0x92>
 a04:	611c                	ld	a5,0(a0)
 a06:	4798                	lw	a4,8(a5)
 a08:	fa9776e3          	bgeu	a4,s1,9b4 <malloc+0x70>
 a0c:	00093703          	ld	a4,0(s2)
 a10:	853e                	mv	a0,a5
 a12:	fef719e3          	bne	a4,a5,a04 <malloc+0xc0>
 a16:	8552                	mv	a0,s4
 a18:	00000097          	auipc	ra,0x0
 a1c:	b7c080e7          	jalr	-1156(ra) # 594 <sbrk>
 a20:	fd5518e3          	bne	a0,s5,9f0 <malloc+0xac>
 a24:	4501                	li	a0,0
 a26:	bf45                	j	9d6 <malloc+0x92>

0000000000000a28 <mem_init>:
 a28:	1141                	addi	sp,sp,-16
 a2a:	e406                	sd	ra,8(sp)
 a2c:	e022                	sd	s0,0(sp)
 a2e:	0800                	addi	s0,sp,16
 a30:	6505                	lui	a0,0x1
 a32:	00000097          	auipc	ra,0x0
 a36:	b62080e7          	jalr	-1182(ra) # 594 <sbrk>
 a3a:	00000797          	auipc	a5,0x0
 a3e:	12a7bb23          	sd	a0,310(a5) # b70 <alloc>
 a42:	00850793          	addi	a5,a0,8 # 1008 <__BSS_END__+0x78>
 a46:	e11c                	sd	a5,0(a0)
 a48:	60a2                	ld	ra,8(sp)
 a4a:	6402                	ld	s0,0(sp)
 a4c:	0141                	addi	sp,sp,16
 a4e:	8082                	ret

0000000000000a50 <l_alloc>:
 a50:	1101                	addi	sp,sp,-32
 a52:	ec06                	sd	ra,24(sp)
 a54:	e822                	sd	s0,16(sp)
 a56:	e426                	sd	s1,8(sp)
 a58:	1000                	addi	s0,sp,32
 a5a:	84aa                	mv	s1,a0
 a5c:	00000797          	auipc	a5,0x0
 a60:	10c7a783          	lw	a5,268(a5) # b68 <if_init>
 a64:	c795                	beqz	a5,a90 <l_alloc+0x40>
 a66:	00000717          	auipc	a4,0x0
 a6a:	10a73703          	ld	a4,266(a4) # b70 <alloc>
 a6e:	6308                	ld	a0,0(a4)
 a70:	40e506b3          	sub	a3,a0,a4
 a74:	6785                	lui	a5,0x1
 a76:	37e1                	addiw	a5,a5,-8
 a78:	9f95                	subw	a5,a5,a3
 a7a:	02f4f563          	bgeu	s1,a5,aa4 <l_alloc+0x54>
 a7e:	1482                	slli	s1,s1,0x20
 a80:	9081                	srli	s1,s1,0x20
 a82:	94aa                	add	s1,s1,a0
 a84:	e304                	sd	s1,0(a4)
 a86:	60e2                	ld	ra,24(sp)
 a88:	6442                	ld	s0,16(sp)
 a8a:	64a2                	ld	s1,8(sp)
 a8c:	6105                	addi	sp,sp,32
 a8e:	8082                	ret
 a90:	00000097          	auipc	ra,0x0
 a94:	f98080e7          	jalr	-104(ra) # a28 <mem_init>
 a98:	4785                	li	a5,1
 a9a:	00000717          	auipc	a4,0x0
 a9e:	0cf72723          	sw	a5,206(a4) # b68 <if_init>
 aa2:	b7d1                	j	a66 <l_alloc+0x16>
 aa4:	4501                	li	a0,0
 aa6:	b7c5                	j	a86 <l_alloc+0x36>

0000000000000aa8 <l_free>:
 aa8:	1141                	addi	sp,sp,-16
 aaa:	e422                	sd	s0,8(sp)
 aac:	0800                	addi	s0,sp,16
 aae:	6422                	ld	s0,8(sp)
 ab0:	0141                	addi	sp,sp,16
 ab2:	8082                	ret
