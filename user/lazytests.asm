
user/_lazytests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <sparse_memory>:
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
   8:	40000537          	lui	a0,0x40000
   c:	00000097          	auipc	ra,0x0
  10:	5fc080e7          	jalr	1532(ra) # 608 <sbrk>
  14:	57fd                	li	a5,-1
  16:	02f50b63          	beq	a0,a5,4c <sparse_memory+0x4c>
  1a:	6605                	lui	a2,0x1
  1c:	962a                	add	a2,a2,a0
  1e:	40001737          	lui	a4,0x40001
  22:	972a                	add	a4,a4,a0
  24:	87b2                	mv	a5,a2
  26:	000406b7          	lui	a3,0x40
  2a:	e39c                	sd	a5,0(a5)
  2c:	97b6                	add	a5,a5,a3
  2e:	fee79ee3          	bne	a5,a4,2a <sparse_memory+0x2a>
  32:	000406b7          	lui	a3,0x40
  36:	621c                	ld	a5,0(a2)
  38:	02c79763          	bne	a5,a2,66 <sparse_memory+0x66>
  3c:	9636                	add	a2,a2,a3
  3e:	fee61ce3          	bne	a2,a4,36 <sparse_memory+0x36>
  42:	4501                	li	a0,0
  44:	00000097          	auipc	ra,0x0
  48:	53c080e7          	jalr	1340(ra) # 580 <exit>
  4c:	00001517          	auipc	a0,0x1
  50:	b0c50513          	addi	a0,a0,-1268 # b58 <l_free+0x3c>
  54:	00001097          	auipc	ra,0x1
  58:	8a6080e7          	jalr	-1882(ra) # 8fa <printf>
  5c:	4505                	li	a0,1
  5e:	00000097          	auipc	ra,0x0
  62:	522080e7          	jalr	1314(ra) # 580 <exit>
  66:	00001517          	auipc	a0,0x1
  6a:	b0250513          	addi	a0,a0,-1278 # b68 <l_free+0x4c>
  6e:	00001097          	auipc	ra,0x1
  72:	88c080e7          	jalr	-1908(ra) # 8fa <printf>
  76:	4505                	li	a0,1
  78:	00000097          	auipc	ra,0x0
  7c:	508080e7          	jalr	1288(ra) # 580 <exit>

0000000000000080 <sparse_memory_unmap>:
  80:	7139                	addi	sp,sp,-64
  82:	fc06                	sd	ra,56(sp)
  84:	f822                	sd	s0,48(sp)
  86:	f426                	sd	s1,40(sp)
  88:	f04a                	sd	s2,32(sp)
  8a:	ec4e                	sd	s3,24(sp)
  8c:	0080                	addi	s0,sp,64
  8e:	40000537          	lui	a0,0x40000
  92:	00000097          	auipc	ra,0x0
  96:	576080e7          	jalr	1398(ra) # 608 <sbrk>
  9a:	57fd                	li	a5,-1
  9c:	04f50863          	beq	a0,a5,ec <sparse_memory_unmap+0x6c>
  a0:	6905                	lui	s2,0x1
  a2:	992a                	add	s2,s2,a0
  a4:	400014b7          	lui	s1,0x40001
  a8:	94aa                	add	s1,s1,a0
  aa:	87ca                	mv	a5,s2
  ac:	01000737          	lui	a4,0x1000
  b0:	e39c                	sd	a5,0(a5)
  b2:	97ba                	add	a5,a5,a4
  b4:	fef49ee3          	bne	s1,a5,b0 <sparse_memory_unmap+0x30>
  b8:	010009b7          	lui	s3,0x1000
  bc:	00000097          	auipc	ra,0x0
  c0:	4bc080e7          	jalr	1212(ra) # 578 <fork>
  c4:	04054163          	bltz	a0,106 <sparse_memory_unmap+0x86>
  c8:	cd21                	beqz	a0,120 <sparse_memory_unmap+0xa0>
  ca:	fcc40513          	addi	a0,s0,-52
  ce:	00000097          	auipc	ra,0x0
  d2:	4ba080e7          	jalr	1210(ra) # 588 <wait>
  d6:	fcc42783          	lw	a5,-52(s0)
  da:	c3a5                	beqz	a5,13a <sparse_memory_unmap+0xba>
  dc:	994e                	add	s2,s2,s3
  de:	fd249fe3          	bne	s1,s2,bc <sparse_memory_unmap+0x3c>
  e2:	4501                	li	a0,0
  e4:	00000097          	auipc	ra,0x0
  e8:	49c080e7          	jalr	1180(ra) # 580 <exit>
  ec:	00001517          	auipc	a0,0x1
  f0:	a6c50513          	addi	a0,a0,-1428 # b58 <l_free+0x3c>
  f4:	00001097          	auipc	ra,0x1
  f8:	806080e7          	jalr	-2042(ra) # 8fa <printf>
  fc:	4505                	li	a0,1
  fe:	00000097          	auipc	ra,0x0
 102:	482080e7          	jalr	1154(ra) # 580 <exit>
 106:	00001517          	auipc	a0,0x1
 10a:	a8a50513          	addi	a0,a0,-1398 # b90 <l_free+0x74>
 10e:	00000097          	auipc	ra,0x0
 112:	7ec080e7          	jalr	2028(ra) # 8fa <printf>
 116:	4505                	li	a0,1
 118:	00000097          	auipc	ra,0x0
 11c:	468080e7          	jalr	1128(ra) # 580 <exit>
 120:	c0000537          	lui	a0,0xc0000
 124:	00000097          	auipc	ra,0x0
 128:	4e4080e7          	jalr	1252(ra) # 608 <sbrk>
 12c:	01293023          	sd	s2,0(s2) # 1000 <__BSS_END__+0x2c8>
 130:	4501                	li	a0,0
 132:	00000097          	auipc	ra,0x0
 136:	44e080e7          	jalr	1102(ra) # 580 <exit>
 13a:	00001517          	auipc	a0,0x1
 13e:	a6650513          	addi	a0,a0,-1434 # ba0 <l_free+0x84>
 142:	00000097          	auipc	ra,0x0
 146:	7b8080e7          	jalr	1976(ra) # 8fa <printf>
 14a:	4505                	li	a0,1
 14c:	00000097          	auipc	ra,0x0
 150:	434080e7          	jalr	1076(ra) # 580 <exit>

0000000000000154 <oom>:
 154:	7179                	addi	sp,sp,-48
 156:	f406                	sd	ra,40(sp)
 158:	f022                	sd	s0,32(sp)
 15a:	ec26                	sd	s1,24(sp)
 15c:	1800                	addi	s0,sp,48
 15e:	00000097          	auipc	ra,0x0
 162:	41a080e7          	jalr	1050(ra) # 578 <fork>
 166:	4481                	li	s1,0
 168:	c10d                	beqz	a0,18a <oom+0x36>
 16a:	fdc40513          	addi	a0,s0,-36
 16e:	00000097          	auipc	ra,0x0
 172:	41a080e7          	jalr	1050(ra) # 588 <wait>
 176:	fdc42503          	lw	a0,-36(s0)
 17a:	00153513          	seqz	a0,a0
 17e:	00000097          	auipc	ra,0x0
 182:	402080e7          	jalr	1026(ra) # 580 <exit>
 186:	e104                	sd	s1,0(a0)
 188:	84aa                	mv	s1,a0
 18a:	01000537          	lui	a0,0x1000
 18e:	00001097          	auipc	ra,0x1
 192:	82a080e7          	jalr	-2006(ra) # 9b8 <malloc>
 196:	f965                	bnez	a0,186 <oom+0x32>
 198:	00000097          	auipc	ra,0x0
 19c:	3e8080e7          	jalr	1000(ra) # 580 <exit>

00000000000001a0 <run>:
 1a0:	7179                	addi	sp,sp,-48
 1a2:	f406                	sd	ra,40(sp)
 1a4:	f022                	sd	s0,32(sp)
 1a6:	ec26                	sd	s1,24(sp)
 1a8:	e84a                	sd	s2,16(sp)
 1aa:	1800                	addi	s0,sp,48
 1ac:	892a                	mv	s2,a0
 1ae:	84ae                	mv	s1,a1
 1b0:	00001517          	auipc	a0,0x1
 1b4:	a0850513          	addi	a0,a0,-1528 # bb8 <l_free+0x9c>
 1b8:	00000097          	auipc	ra,0x0
 1bc:	742080e7          	jalr	1858(ra) # 8fa <printf>
 1c0:	00000097          	auipc	ra,0x0
 1c4:	3b8080e7          	jalr	952(ra) # 578 <fork>
 1c8:	02054f63          	bltz	a0,206 <run+0x66>
 1cc:	c931                	beqz	a0,220 <run+0x80>
 1ce:	fdc40513          	addi	a0,s0,-36
 1d2:	00000097          	auipc	ra,0x0
 1d6:	3b6080e7          	jalr	950(ra) # 588 <wait>
 1da:	fdc42783          	lw	a5,-36(s0)
 1de:	cba1                	beqz	a5,22e <run+0x8e>
 1e0:	85a6                	mv	a1,s1
 1e2:	00001517          	auipc	a0,0x1
 1e6:	a0650513          	addi	a0,a0,-1530 # be8 <l_free+0xcc>
 1ea:	00000097          	auipc	ra,0x0
 1ee:	710080e7          	jalr	1808(ra) # 8fa <printf>
 1f2:	fdc42503          	lw	a0,-36(s0)
 1f6:	00153513          	seqz	a0,a0
 1fa:	70a2                	ld	ra,40(sp)
 1fc:	7402                	ld	s0,32(sp)
 1fe:	64e2                	ld	s1,24(sp)
 200:	6942                	ld	s2,16(sp)
 202:	6145                	addi	sp,sp,48
 204:	8082                	ret
 206:	00001517          	auipc	a0,0x1
 20a:	9ca50513          	addi	a0,a0,-1590 # bd0 <l_free+0xb4>
 20e:	00000097          	auipc	ra,0x0
 212:	6ec080e7          	jalr	1772(ra) # 8fa <printf>
 216:	4505                	li	a0,1
 218:	00000097          	auipc	ra,0x0
 21c:	368080e7          	jalr	872(ra) # 580 <exit>
 220:	8526                	mv	a0,s1
 222:	9902                	jalr	s2
 224:	4501                	li	a0,0
 226:	00000097          	auipc	ra,0x0
 22a:	35a080e7          	jalr	858(ra) # 580 <exit>
 22e:	85a6                	mv	a1,s1
 230:	00001517          	auipc	a0,0x1
 234:	9d050513          	addi	a0,a0,-1584 # c00 <l_free+0xe4>
 238:	00000097          	auipc	ra,0x0
 23c:	6c2080e7          	jalr	1730(ra) # 8fa <printf>
 240:	bf4d                	j	1f2 <run+0x52>

0000000000000242 <main>:
 242:	7159                	addi	sp,sp,-112
 244:	f486                	sd	ra,104(sp)
 246:	f0a2                	sd	s0,96(sp)
 248:	eca6                	sd	s1,88(sp)
 24a:	e8ca                	sd	s2,80(sp)
 24c:	e4ce                	sd	s3,72(sp)
 24e:	e0d2                	sd	s4,64(sp)
 250:	1880                	addi	s0,sp,112
 252:	4785                	li	a5,1
 254:	4901                	li	s2,0
 256:	00a7d463          	bge	a5,a0,25e <main+0x1c>
 25a:	0085b903          	ld	s2,8(a1)
 25e:	00001797          	auipc	a5,0x1
 262:	9fa78793          	addi	a5,a5,-1542 # c58 <l_free+0x13c>
 266:	0007b883          	ld	a7,0(a5)
 26a:	0087b803          	ld	a6,8(a5)
 26e:	6b88                	ld	a0,16(a5)
 270:	6f8c                	ld	a1,24(a5)
 272:	7390                	ld	a2,32(a5)
 274:	7794                	ld	a3,40(a5)
 276:	7b98                	ld	a4,48(a5)
 278:	7f9c                	ld	a5,56(a5)
 27a:	f9143823          	sd	a7,-112(s0)
 27e:	f9043c23          	sd	a6,-104(s0)
 282:	faa43023          	sd	a0,-96(s0)
 286:	fab43423          	sd	a1,-88(s0)
 28a:	fac43823          	sd	a2,-80(s0)
 28e:	fad43c23          	sd	a3,-72(s0)
 292:	fce43023          	sd	a4,-64(s0)
 296:	fcf43423          	sd	a5,-56(s0)
 29a:	00001517          	auipc	a0,0x1
 29e:	97650513          	addi	a0,a0,-1674 # c10 <l_free+0xf4>
 2a2:	00000097          	auipc	ra,0x0
 2a6:	658080e7          	jalr	1624(ra) # 8fa <printf>
 2aa:	f9843503          	ld	a0,-104(s0)
 2ae:	c529                	beqz	a0,2f8 <main+0xb6>
 2b0:	f9040493          	addi	s1,s0,-112
 2b4:	4981                	li	s3,0
 2b6:	4a05                	li	s4,1
 2b8:	a021                	j	2c0 <main+0x7e>
 2ba:	04c1                	addi	s1,s1,16
 2bc:	6488                	ld	a0,8(s1)
 2be:	c115                	beqz	a0,2e2 <main+0xa0>
 2c0:	00090863          	beqz	s2,2d0 <main+0x8e>
 2c4:	85ca                	mv	a1,s2
 2c6:	00000097          	auipc	ra,0x0
 2ca:	068080e7          	jalr	104(ra) # 32e <strcmp>
 2ce:	f575                	bnez	a0,2ba <main+0x78>
 2d0:	648c                	ld	a1,8(s1)
 2d2:	6088                	ld	a0,0(s1)
 2d4:	00000097          	auipc	ra,0x0
 2d8:	ecc080e7          	jalr	-308(ra) # 1a0 <run>
 2dc:	fd79                	bnez	a0,2ba <main+0x78>
 2de:	89d2                	mv	s3,s4
 2e0:	bfe9                	j	2ba <main+0x78>
 2e2:	00098b63          	beqz	s3,2f8 <main+0xb6>
 2e6:	00001517          	auipc	a0,0x1
 2ea:	95a50513          	addi	a0,a0,-1702 # c40 <l_free+0x124>
 2ee:	00000097          	auipc	ra,0x0
 2f2:	60c080e7          	jalr	1548(ra) # 8fa <printf>
 2f6:	a809                	j	308 <main+0xc6>
 2f8:	00001517          	auipc	a0,0x1
 2fc:	93050513          	addi	a0,a0,-1744 # c28 <l_free+0x10c>
 300:	00000097          	auipc	ra,0x0
 304:	5fa080e7          	jalr	1530(ra) # 8fa <printf>
 308:	4505                	li	a0,1
 30a:	00000097          	auipc	ra,0x0
 30e:	276080e7          	jalr	630(ra) # 580 <exit>

0000000000000312 <strcpy>:
 312:	1141                	addi	sp,sp,-16
 314:	e422                	sd	s0,8(sp)
 316:	0800                	addi	s0,sp,16
 318:	87aa                	mv	a5,a0
 31a:	0585                	addi	a1,a1,1
 31c:	0785                	addi	a5,a5,1
 31e:	fff5c703          	lbu	a4,-1(a1)
 322:	fee78fa3          	sb	a4,-1(a5)
 326:	fb75                	bnez	a4,31a <strcpy+0x8>
 328:	6422                	ld	s0,8(sp)
 32a:	0141                	addi	sp,sp,16
 32c:	8082                	ret

000000000000032e <strcmp>:
 32e:	1141                	addi	sp,sp,-16
 330:	e422                	sd	s0,8(sp)
 332:	0800                	addi	s0,sp,16
 334:	00054783          	lbu	a5,0(a0)
 338:	cb91                	beqz	a5,34c <strcmp+0x1e>
 33a:	0005c703          	lbu	a4,0(a1)
 33e:	00f71763          	bne	a4,a5,34c <strcmp+0x1e>
 342:	0505                	addi	a0,a0,1
 344:	0585                	addi	a1,a1,1
 346:	00054783          	lbu	a5,0(a0)
 34a:	fbe5                	bnez	a5,33a <strcmp+0xc>
 34c:	0005c503          	lbu	a0,0(a1)
 350:	40a7853b          	subw	a0,a5,a0
 354:	6422                	ld	s0,8(sp)
 356:	0141                	addi	sp,sp,16
 358:	8082                	ret

000000000000035a <strlen>:
 35a:	1141                	addi	sp,sp,-16
 35c:	e422                	sd	s0,8(sp)
 35e:	0800                	addi	s0,sp,16
 360:	00054783          	lbu	a5,0(a0)
 364:	cf91                	beqz	a5,380 <strlen+0x26>
 366:	0505                	addi	a0,a0,1
 368:	87aa                	mv	a5,a0
 36a:	4685                	li	a3,1
 36c:	9e89                	subw	a3,a3,a0
 36e:	00f6853b          	addw	a0,a3,a5
 372:	0785                	addi	a5,a5,1
 374:	fff7c703          	lbu	a4,-1(a5)
 378:	fb7d                	bnez	a4,36e <strlen+0x14>
 37a:	6422                	ld	s0,8(sp)
 37c:	0141                	addi	sp,sp,16
 37e:	8082                	ret
 380:	4501                	li	a0,0
 382:	bfe5                	j	37a <strlen+0x20>

0000000000000384 <memset>:
 384:	1141                	addi	sp,sp,-16
 386:	e422                	sd	s0,8(sp)
 388:	0800                	addi	s0,sp,16
 38a:	ca19                	beqz	a2,3a0 <memset+0x1c>
 38c:	87aa                	mv	a5,a0
 38e:	1602                	slli	a2,a2,0x20
 390:	9201                	srli	a2,a2,0x20
 392:	00a60733          	add	a4,a2,a0
 396:	00b78023          	sb	a1,0(a5)
 39a:	0785                	addi	a5,a5,1
 39c:	fee79de3          	bne	a5,a4,396 <memset+0x12>
 3a0:	6422                	ld	s0,8(sp)
 3a2:	0141                	addi	sp,sp,16
 3a4:	8082                	ret

00000000000003a6 <strchr>:
 3a6:	1141                	addi	sp,sp,-16
 3a8:	e422                	sd	s0,8(sp)
 3aa:	0800                	addi	s0,sp,16
 3ac:	00054783          	lbu	a5,0(a0)
 3b0:	cb99                	beqz	a5,3c6 <strchr+0x20>
 3b2:	00f58763          	beq	a1,a5,3c0 <strchr+0x1a>
 3b6:	0505                	addi	a0,a0,1
 3b8:	00054783          	lbu	a5,0(a0)
 3bc:	fbfd                	bnez	a5,3b2 <strchr+0xc>
 3be:	4501                	li	a0,0
 3c0:	6422                	ld	s0,8(sp)
 3c2:	0141                	addi	sp,sp,16
 3c4:	8082                	ret
 3c6:	4501                	li	a0,0
 3c8:	bfe5                	j	3c0 <strchr+0x1a>

00000000000003ca <gets>:
 3ca:	711d                	addi	sp,sp,-96
 3cc:	ec86                	sd	ra,88(sp)
 3ce:	e8a2                	sd	s0,80(sp)
 3d0:	e4a6                	sd	s1,72(sp)
 3d2:	e0ca                	sd	s2,64(sp)
 3d4:	fc4e                	sd	s3,56(sp)
 3d6:	f852                	sd	s4,48(sp)
 3d8:	f456                	sd	s5,40(sp)
 3da:	f05a                	sd	s6,32(sp)
 3dc:	ec5e                	sd	s7,24(sp)
 3de:	1080                	addi	s0,sp,96
 3e0:	8baa                	mv	s7,a0
 3e2:	8a2e                	mv	s4,a1
 3e4:	892a                	mv	s2,a0
 3e6:	4481                	li	s1,0
 3e8:	4aa9                	li	s5,10
 3ea:	4b35                	li	s6,13
 3ec:	89a6                	mv	s3,s1
 3ee:	2485                	addiw	s1,s1,1
 3f0:	0344d863          	bge	s1,s4,420 <gets+0x56>
 3f4:	4605                	li	a2,1
 3f6:	faf40593          	addi	a1,s0,-81
 3fa:	4501                	li	a0,0
 3fc:	00000097          	auipc	ra,0x0
 400:	19c080e7          	jalr	412(ra) # 598 <read>
 404:	00a05e63          	blez	a0,420 <gets+0x56>
 408:	faf44783          	lbu	a5,-81(s0)
 40c:	00f90023          	sb	a5,0(s2)
 410:	01578763          	beq	a5,s5,41e <gets+0x54>
 414:	0905                	addi	s2,s2,1
 416:	fd679be3          	bne	a5,s6,3ec <gets+0x22>
 41a:	89a6                	mv	s3,s1
 41c:	a011                	j	420 <gets+0x56>
 41e:	89a6                	mv	s3,s1
 420:	99de                	add	s3,s3,s7
 422:	00098023          	sb	zero,0(s3) # 1000000 <__global_pointer$+0xffeaf7>
 426:	855e                	mv	a0,s7
 428:	60e6                	ld	ra,88(sp)
 42a:	6446                	ld	s0,80(sp)
 42c:	64a6                	ld	s1,72(sp)
 42e:	6906                	ld	s2,64(sp)
 430:	79e2                	ld	s3,56(sp)
 432:	7a42                	ld	s4,48(sp)
 434:	7aa2                	ld	s5,40(sp)
 436:	7b02                	ld	s6,32(sp)
 438:	6be2                	ld	s7,24(sp)
 43a:	6125                	addi	sp,sp,96
 43c:	8082                	ret

000000000000043e <stat>:
 43e:	1101                	addi	sp,sp,-32
 440:	ec06                	sd	ra,24(sp)
 442:	e822                	sd	s0,16(sp)
 444:	e426                	sd	s1,8(sp)
 446:	e04a                	sd	s2,0(sp)
 448:	1000                	addi	s0,sp,32
 44a:	892e                	mv	s2,a1
 44c:	4581                	li	a1,0
 44e:	00000097          	auipc	ra,0x0
 452:	172080e7          	jalr	370(ra) # 5c0 <open>
 456:	02054563          	bltz	a0,480 <stat+0x42>
 45a:	84aa                	mv	s1,a0
 45c:	85ca                	mv	a1,s2
 45e:	00000097          	auipc	ra,0x0
 462:	17a080e7          	jalr	378(ra) # 5d8 <fstat>
 466:	892a                	mv	s2,a0
 468:	8526                	mv	a0,s1
 46a:	00000097          	auipc	ra,0x0
 46e:	13e080e7          	jalr	318(ra) # 5a8 <close>
 472:	854a                	mv	a0,s2
 474:	60e2                	ld	ra,24(sp)
 476:	6442                	ld	s0,16(sp)
 478:	64a2                	ld	s1,8(sp)
 47a:	6902                	ld	s2,0(sp)
 47c:	6105                	addi	sp,sp,32
 47e:	8082                	ret
 480:	597d                	li	s2,-1
 482:	bfc5                	j	472 <stat+0x34>

0000000000000484 <atoi>:
 484:	1141                	addi	sp,sp,-16
 486:	e422                	sd	s0,8(sp)
 488:	0800                	addi	s0,sp,16
 48a:	00054603          	lbu	a2,0(a0)
 48e:	fd06079b          	addiw	a5,a2,-48
 492:	0ff7f793          	zext.b	a5,a5
 496:	4725                	li	a4,9
 498:	02f76963          	bltu	a4,a5,4ca <atoi+0x46>
 49c:	86aa                	mv	a3,a0
 49e:	4501                	li	a0,0
 4a0:	45a5                	li	a1,9
 4a2:	0685                	addi	a3,a3,1
 4a4:	0025179b          	slliw	a5,a0,0x2
 4a8:	9fa9                	addw	a5,a5,a0
 4aa:	0017979b          	slliw	a5,a5,0x1
 4ae:	9fb1                	addw	a5,a5,a2
 4b0:	fd07851b          	addiw	a0,a5,-48
 4b4:	0006c603          	lbu	a2,0(a3) # 40000 <__global_pointer$+0x3eaf7>
 4b8:	fd06071b          	addiw	a4,a2,-48
 4bc:	0ff77713          	zext.b	a4,a4
 4c0:	fee5f1e3          	bgeu	a1,a4,4a2 <atoi+0x1e>
 4c4:	6422                	ld	s0,8(sp)
 4c6:	0141                	addi	sp,sp,16
 4c8:	8082                	ret
 4ca:	4501                	li	a0,0
 4cc:	bfe5                	j	4c4 <atoi+0x40>

00000000000004ce <memmove>:
 4ce:	1141                	addi	sp,sp,-16
 4d0:	e422                	sd	s0,8(sp)
 4d2:	0800                	addi	s0,sp,16
 4d4:	02b57463          	bgeu	a0,a1,4fc <memmove+0x2e>
 4d8:	00c05f63          	blez	a2,4f6 <memmove+0x28>
 4dc:	1602                	slli	a2,a2,0x20
 4de:	9201                	srli	a2,a2,0x20
 4e0:	00c507b3          	add	a5,a0,a2
 4e4:	872a                	mv	a4,a0
 4e6:	0585                	addi	a1,a1,1
 4e8:	0705                	addi	a4,a4,1
 4ea:	fff5c683          	lbu	a3,-1(a1)
 4ee:	fed70fa3          	sb	a3,-1(a4) # ffffff <__global_pointer$+0xffeaf6>
 4f2:	fee79ae3          	bne	a5,a4,4e6 <memmove+0x18>
 4f6:	6422                	ld	s0,8(sp)
 4f8:	0141                	addi	sp,sp,16
 4fa:	8082                	ret
 4fc:	00c50733          	add	a4,a0,a2
 500:	95b2                	add	a1,a1,a2
 502:	fec05ae3          	blez	a2,4f6 <memmove+0x28>
 506:	fff6079b          	addiw	a5,a2,-1
 50a:	1782                	slli	a5,a5,0x20
 50c:	9381                	srli	a5,a5,0x20
 50e:	fff7c793          	not	a5,a5
 512:	97ba                	add	a5,a5,a4
 514:	15fd                	addi	a1,a1,-1
 516:	177d                	addi	a4,a4,-1
 518:	0005c683          	lbu	a3,0(a1)
 51c:	00d70023          	sb	a3,0(a4)
 520:	fee79ae3          	bne	a5,a4,514 <memmove+0x46>
 524:	bfc9                	j	4f6 <memmove+0x28>

0000000000000526 <memcmp>:
 526:	1141                	addi	sp,sp,-16
 528:	e422                	sd	s0,8(sp)
 52a:	0800                	addi	s0,sp,16
 52c:	ca05                	beqz	a2,55c <memcmp+0x36>
 52e:	fff6069b          	addiw	a3,a2,-1
 532:	1682                	slli	a3,a3,0x20
 534:	9281                	srli	a3,a3,0x20
 536:	0685                	addi	a3,a3,1
 538:	96aa                	add	a3,a3,a0
 53a:	00054783          	lbu	a5,0(a0)
 53e:	0005c703          	lbu	a4,0(a1)
 542:	00e79863          	bne	a5,a4,552 <memcmp+0x2c>
 546:	0505                	addi	a0,a0,1
 548:	0585                	addi	a1,a1,1
 54a:	fed518e3          	bne	a0,a3,53a <memcmp+0x14>
 54e:	4501                	li	a0,0
 550:	a019                	j	556 <memcmp+0x30>
 552:	40e7853b          	subw	a0,a5,a4
 556:	6422                	ld	s0,8(sp)
 558:	0141                	addi	sp,sp,16
 55a:	8082                	ret
 55c:	4501                	li	a0,0
 55e:	bfe5                	j	556 <memcmp+0x30>

0000000000000560 <memcpy>:
 560:	1141                	addi	sp,sp,-16
 562:	e406                	sd	ra,8(sp)
 564:	e022                	sd	s0,0(sp)
 566:	0800                	addi	s0,sp,16
 568:	00000097          	auipc	ra,0x0
 56c:	f66080e7          	jalr	-154(ra) # 4ce <memmove>
 570:	60a2                	ld	ra,8(sp)
 572:	6402                	ld	s0,0(sp)
 574:	0141                	addi	sp,sp,16
 576:	8082                	ret

0000000000000578 <fork>:
 578:	4885                	li	a7,1
 57a:	00000073          	ecall
 57e:	8082                	ret

0000000000000580 <exit>:
 580:	4889                	li	a7,2
 582:	00000073          	ecall
 586:	8082                	ret

0000000000000588 <wait>:
 588:	488d                	li	a7,3
 58a:	00000073          	ecall
 58e:	8082                	ret

0000000000000590 <pipe>:
 590:	4891                	li	a7,4
 592:	00000073          	ecall
 596:	8082                	ret

0000000000000598 <read>:
 598:	4895                	li	a7,5
 59a:	00000073          	ecall
 59e:	8082                	ret

00000000000005a0 <write>:
 5a0:	48c1                	li	a7,16
 5a2:	00000073          	ecall
 5a6:	8082                	ret

00000000000005a8 <close>:
 5a8:	48d5                	li	a7,21
 5aa:	00000073          	ecall
 5ae:	8082                	ret

00000000000005b0 <kill>:
 5b0:	4899                	li	a7,6
 5b2:	00000073          	ecall
 5b6:	8082                	ret

00000000000005b8 <exec>:
 5b8:	489d                	li	a7,7
 5ba:	00000073          	ecall
 5be:	8082                	ret

00000000000005c0 <open>:
 5c0:	48bd                	li	a7,15
 5c2:	00000073          	ecall
 5c6:	8082                	ret

00000000000005c8 <mknod>:
 5c8:	48c5                	li	a7,17
 5ca:	00000073          	ecall
 5ce:	8082                	ret

00000000000005d0 <unlink>:
 5d0:	48c9                	li	a7,18
 5d2:	00000073          	ecall
 5d6:	8082                	ret

00000000000005d8 <fstat>:
 5d8:	48a1                	li	a7,8
 5da:	00000073          	ecall
 5de:	8082                	ret

00000000000005e0 <link>:
 5e0:	48cd                	li	a7,19
 5e2:	00000073          	ecall
 5e6:	8082                	ret

00000000000005e8 <mkdir>:
 5e8:	48d1                	li	a7,20
 5ea:	00000073          	ecall
 5ee:	8082                	ret

00000000000005f0 <chdir>:
 5f0:	48a5                	li	a7,9
 5f2:	00000073          	ecall
 5f6:	8082                	ret

00000000000005f8 <dup>:
 5f8:	48a9                	li	a7,10
 5fa:	00000073          	ecall
 5fe:	8082                	ret

0000000000000600 <getpid>:
 600:	48ad                	li	a7,11
 602:	00000073          	ecall
 606:	8082                	ret

0000000000000608 <sbrk>:
 608:	48b1                	li	a7,12
 60a:	00000073          	ecall
 60e:	8082                	ret

0000000000000610 <sleep>:
 610:	48b5                	li	a7,13
 612:	00000073          	ecall
 616:	8082                	ret

0000000000000618 <uptime>:
 618:	48b9                	li	a7,14
 61a:	00000073          	ecall
 61e:	8082                	ret

0000000000000620 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 620:	1101                	addi	sp,sp,-32
 622:	ec06                	sd	ra,24(sp)
 624:	e822                	sd	s0,16(sp)
 626:	1000                	addi	s0,sp,32
 628:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 62c:	4605                	li	a2,1
 62e:	fef40593          	addi	a1,s0,-17
 632:	00000097          	auipc	ra,0x0
 636:	f6e080e7          	jalr	-146(ra) # 5a0 <write>
}
 63a:	60e2                	ld	ra,24(sp)
 63c:	6442                	ld	s0,16(sp)
 63e:	6105                	addi	sp,sp,32
 640:	8082                	ret

0000000000000642 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 642:	7139                	addi	sp,sp,-64
 644:	fc06                	sd	ra,56(sp)
 646:	f822                	sd	s0,48(sp)
 648:	f426                	sd	s1,40(sp)
 64a:	f04a                	sd	s2,32(sp)
 64c:	ec4e                	sd	s3,24(sp)
 64e:	0080                	addi	s0,sp,64
 650:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 652:	c299                	beqz	a3,658 <printint+0x16>
 654:	0805c963          	bltz	a1,6e6 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 658:	2581                	sext.w	a1,a1
  neg = 0;
 65a:	4881                	li	a7,0
 65c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 660:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 662:	2601                	sext.w	a2,a2
 664:	00000517          	auipc	a0,0x0
 668:	69450513          	addi	a0,a0,1684 # cf8 <digits>
 66c:	883a                	mv	a6,a4
 66e:	2705                	addiw	a4,a4,1
 670:	02c5f7bb          	remuw	a5,a1,a2
 674:	1782                	slli	a5,a5,0x20
 676:	9381                	srli	a5,a5,0x20
 678:	97aa                	add	a5,a5,a0
 67a:	0007c783          	lbu	a5,0(a5)
 67e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 682:	0005879b          	sext.w	a5,a1
 686:	02c5d5bb          	divuw	a1,a1,a2
 68a:	0685                	addi	a3,a3,1
 68c:	fec7f0e3          	bgeu	a5,a2,66c <printint+0x2a>
  if(neg)
 690:	00088c63          	beqz	a7,6a8 <printint+0x66>
    buf[i++] = '-';
 694:	fd070793          	addi	a5,a4,-48
 698:	00878733          	add	a4,a5,s0
 69c:	02d00793          	li	a5,45
 6a0:	fef70823          	sb	a5,-16(a4)
 6a4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6a8:	02e05863          	blez	a4,6d8 <printint+0x96>
 6ac:	fc040793          	addi	a5,s0,-64
 6b0:	00e78933          	add	s2,a5,a4
 6b4:	fff78993          	addi	s3,a5,-1
 6b8:	99ba                	add	s3,s3,a4
 6ba:	377d                	addiw	a4,a4,-1
 6bc:	1702                	slli	a4,a4,0x20
 6be:	9301                	srli	a4,a4,0x20
 6c0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6c4:	fff94583          	lbu	a1,-1(s2)
 6c8:	8526                	mv	a0,s1
 6ca:	00000097          	auipc	ra,0x0
 6ce:	f56080e7          	jalr	-170(ra) # 620 <putc>
  while(--i >= 0)
 6d2:	197d                	addi	s2,s2,-1
 6d4:	ff3918e3          	bne	s2,s3,6c4 <printint+0x82>
}
 6d8:	70e2                	ld	ra,56(sp)
 6da:	7442                	ld	s0,48(sp)
 6dc:	74a2                	ld	s1,40(sp)
 6de:	7902                	ld	s2,32(sp)
 6e0:	69e2                	ld	s3,24(sp)
 6e2:	6121                	addi	sp,sp,64
 6e4:	8082                	ret
    x = -xx;
 6e6:	40b005bb          	negw	a1,a1
    neg = 1;
 6ea:	4885                	li	a7,1
    x = -xx;
 6ec:	bf85                	j	65c <printint+0x1a>

00000000000006ee <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6ee:	7119                	addi	sp,sp,-128
 6f0:	fc86                	sd	ra,120(sp)
 6f2:	f8a2                	sd	s0,112(sp)
 6f4:	f4a6                	sd	s1,104(sp)
 6f6:	f0ca                	sd	s2,96(sp)
 6f8:	ecce                	sd	s3,88(sp)
 6fa:	e8d2                	sd	s4,80(sp)
 6fc:	e4d6                	sd	s5,72(sp)
 6fe:	e0da                	sd	s6,64(sp)
 700:	fc5e                	sd	s7,56(sp)
 702:	f862                	sd	s8,48(sp)
 704:	f466                	sd	s9,40(sp)
 706:	f06a                	sd	s10,32(sp)
 708:	ec6e                	sd	s11,24(sp)
 70a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 70c:	0005c903          	lbu	s2,0(a1)
 710:	18090f63          	beqz	s2,8ae <vprintf+0x1c0>
 714:	8aaa                	mv	s5,a0
 716:	8b32                	mv	s6,a2
 718:	00158493          	addi	s1,a1,1
  state = 0;
 71c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 71e:	02500a13          	li	s4,37
 722:	4c55                	li	s8,21
 724:	00000c97          	auipc	s9,0x0
 728:	57cc8c93          	addi	s9,s9,1404 # ca0 <l_free+0x184>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 72c:	02800d93          	li	s11,40
  putc(fd, 'x');
 730:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 732:	00000b97          	auipc	s7,0x0
 736:	5c6b8b93          	addi	s7,s7,1478 # cf8 <digits>
 73a:	a839                	j	758 <vprintf+0x6a>
        putc(fd, c);
 73c:	85ca                	mv	a1,s2
 73e:	8556                	mv	a0,s5
 740:	00000097          	auipc	ra,0x0
 744:	ee0080e7          	jalr	-288(ra) # 620 <putc>
 748:	a019                	j	74e <vprintf+0x60>
    } else if(state == '%'){
 74a:	01498d63          	beq	s3,s4,764 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 74e:	0485                	addi	s1,s1,1
 750:	fff4c903          	lbu	s2,-1(s1) # 40000fff <__global_pointer$+0x3ffffaf6>
 754:	14090d63          	beqz	s2,8ae <vprintf+0x1c0>
    if(state == 0){
 758:	fe0999e3          	bnez	s3,74a <vprintf+0x5c>
      if(c == '%'){
 75c:	ff4910e3          	bne	s2,s4,73c <vprintf+0x4e>
        state = '%';
 760:	89d2                	mv	s3,s4
 762:	b7f5                	j	74e <vprintf+0x60>
      if(c == 'd'){
 764:	11490c63          	beq	s2,s4,87c <vprintf+0x18e>
 768:	f9d9079b          	addiw	a5,s2,-99
 76c:	0ff7f793          	zext.b	a5,a5
 770:	10fc6e63          	bltu	s8,a5,88c <vprintf+0x19e>
 774:	f9d9079b          	addiw	a5,s2,-99
 778:	0ff7f713          	zext.b	a4,a5
 77c:	10ec6863          	bltu	s8,a4,88c <vprintf+0x19e>
 780:	00271793          	slli	a5,a4,0x2
 784:	97e6                	add	a5,a5,s9
 786:	439c                	lw	a5,0(a5)
 788:	97e6                	add	a5,a5,s9
 78a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 78c:	008b0913          	addi	s2,s6,8
 790:	4685                	li	a3,1
 792:	4629                	li	a2,10
 794:	000b2583          	lw	a1,0(s6)
 798:	8556                	mv	a0,s5
 79a:	00000097          	auipc	ra,0x0
 79e:	ea8080e7          	jalr	-344(ra) # 642 <printint>
 7a2:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7a4:	4981                	li	s3,0
 7a6:	b765                	j	74e <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7a8:	008b0913          	addi	s2,s6,8
 7ac:	4681                	li	a3,0
 7ae:	4629                	li	a2,10
 7b0:	000b2583          	lw	a1,0(s6)
 7b4:	8556                	mv	a0,s5
 7b6:	00000097          	auipc	ra,0x0
 7ba:	e8c080e7          	jalr	-372(ra) # 642 <printint>
 7be:	8b4a                	mv	s6,s2
      state = 0;
 7c0:	4981                	li	s3,0
 7c2:	b771                	j	74e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7c4:	008b0913          	addi	s2,s6,8
 7c8:	4681                	li	a3,0
 7ca:	866a                	mv	a2,s10
 7cc:	000b2583          	lw	a1,0(s6)
 7d0:	8556                	mv	a0,s5
 7d2:	00000097          	auipc	ra,0x0
 7d6:	e70080e7          	jalr	-400(ra) # 642 <printint>
 7da:	8b4a                	mv	s6,s2
      state = 0;
 7dc:	4981                	li	s3,0
 7de:	bf85                	j	74e <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 7e0:	008b0793          	addi	a5,s6,8
 7e4:	f8f43423          	sd	a5,-120(s0)
 7e8:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 7ec:	03000593          	li	a1,48
 7f0:	8556                	mv	a0,s5
 7f2:	00000097          	auipc	ra,0x0
 7f6:	e2e080e7          	jalr	-466(ra) # 620 <putc>
  putc(fd, 'x');
 7fa:	07800593          	li	a1,120
 7fe:	8556                	mv	a0,s5
 800:	00000097          	auipc	ra,0x0
 804:	e20080e7          	jalr	-480(ra) # 620 <putc>
 808:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 80a:	03c9d793          	srli	a5,s3,0x3c
 80e:	97de                	add	a5,a5,s7
 810:	0007c583          	lbu	a1,0(a5)
 814:	8556                	mv	a0,s5
 816:	00000097          	auipc	ra,0x0
 81a:	e0a080e7          	jalr	-502(ra) # 620 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 81e:	0992                	slli	s3,s3,0x4
 820:	397d                	addiw	s2,s2,-1
 822:	fe0914e3          	bnez	s2,80a <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 826:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 82a:	4981                	li	s3,0
 82c:	b70d                	j	74e <vprintf+0x60>
        s = va_arg(ap, char*);
 82e:	008b0913          	addi	s2,s6,8
 832:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 836:	02098163          	beqz	s3,858 <vprintf+0x16a>
        while(*s != 0){
 83a:	0009c583          	lbu	a1,0(s3)
 83e:	c5ad                	beqz	a1,8a8 <vprintf+0x1ba>
          putc(fd, *s);
 840:	8556                	mv	a0,s5
 842:	00000097          	auipc	ra,0x0
 846:	dde080e7          	jalr	-546(ra) # 620 <putc>
          s++;
 84a:	0985                	addi	s3,s3,1
        while(*s != 0){
 84c:	0009c583          	lbu	a1,0(s3)
 850:	f9e5                	bnez	a1,840 <vprintf+0x152>
        s = va_arg(ap, char*);
 852:	8b4a                	mv	s6,s2
      state = 0;
 854:	4981                	li	s3,0
 856:	bde5                	j	74e <vprintf+0x60>
          s = "(null)";
 858:	00000997          	auipc	s3,0x0
 85c:	44098993          	addi	s3,s3,1088 # c98 <l_free+0x17c>
        while(*s != 0){
 860:	85ee                	mv	a1,s11
 862:	bff9                	j	840 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 864:	008b0913          	addi	s2,s6,8
 868:	000b4583          	lbu	a1,0(s6)
 86c:	8556                	mv	a0,s5
 86e:	00000097          	auipc	ra,0x0
 872:	db2080e7          	jalr	-590(ra) # 620 <putc>
 876:	8b4a                	mv	s6,s2
      state = 0;
 878:	4981                	li	s3,0
 87a:	bdd1                	j	74e <vprintf+0x60>
        putc(fd, c);
 87c:	85d2                	mv	a1,s4
 87e:	8556                	mv	a0,s5
 880:	00000097          	auipc	ra,0x0
 884:	da0080e7          	jalr	-608(ra) # 620 <putc>
      state = 0;
 888:	4981                	li	s3,0
 88a:	b5d1                	j	74e <vprintf+0x60>
        putc(fd, '%');
 88c:	85d2                	mv	a1,s4
 88e:	8556                	mv	a0,s5
 890:	00000097          	auipc	ra,0x0
 894:	d90080e7          	jalr	-624(ra) # 620 <putc>
        putc(fd, c);
 898:	85ca                	mv	a1,s2
 89a:	8556                	mv	a0,s5
 89c:	00000097          	auipc	ra,0x0
 8a0:	d84080e7          	jalr	-636(ra) # 620 <putc>
      state = 0;
 8a4:	4981                	li	s3,0
 8a6:	b565                	j	74e <vprintf+0x60>
        s = va_arg(ap, char*);
 8a8:	8b4a                	mv	s6,s2
      state = 0;
 8aa:	4981                	li	s3,0
 8ac:	b54d                	j	74e <vprintf+0x60>
    }
  }
}
 8ae:	70e6                	ld	ra,120(sp)
 8b0:	7446                	ld	s0,112(sp)
 8b2:	74a6                	ld	s1,104(sp)
 8b4:	7906                	ld	s2,96(sp)
 8b6:	69e6                	ld	s3,88(sp)
 8b8:	6a46                	ld	s4,80(sp)
 8ba:	6aa6                	ld	s5,72(sp)
 8bc:	6b06                	ld	s6,64(sp)
 8be:	7be2                	ld	s7,56(sp)
 8c0:	7c42                	ld	s8,48(sp)
 8c2:	7ca2                	ld	s9,40(sp)
 8c4:	7d02                	ld	s10,32(sp)
 8c6:	6de2                	ld	s11,24(sp)
 8c8:	6109                	addi	sp,sp,128
 8ca:	8082                	ret

00000000000008cc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8cc:	715d                	addi	sp,sp,-80
 8ce:	ec06                	sd	ra,24(sp)
 8d0:	e822                	sd	s0,16(sp)
 8d2:	1000                	addi	s0,sp,32
 8d4:	e010                	sd	a2,0(s0)
 8d6:	e414                	sd	a3,8(s0)
 8d8:	e818                	sd	a4,16(s0)
 8da:	ec1c                	sd	a5,24(s0)
 8dc:	03043023          	sd	a6,32(s0)
 8e0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8e4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8e8:	8622                	mv	a2,s0
 8ea:	00000097          	auipc	ra,0x0
 8ee:	e04080e7          	jalr	-508(ra) # 6ee <vprintf>
}
 8f2:	60e2                	ld	ra,24(sp)
 8f4:	6442                	ld	s0,16(sp)
 8f6:	6161                	addi	sp,sp,80
 8f8:	8082                	ret

00000000000008fa <printf>:

void
printf(const char *fmt, ...)
{
 8fa:	711d                	addi	sp,sp,-96
 8fc:	ec06                	sd	ra,24(sp)
 8fe:	e822                	sd	s0,16(sp)
 900:	1000                	addi	s0,sp,32
 902:	e40c                	sd	a1,8(s0)
 904:	e810                	sd	a2,16(s0)
 906:	ec14                	sd	a3,24(s0)
 908:	f018                	sd	a4,32(s0)
 90a:	f41c                	sd	a5,40(s0)
 90c:	03043823          	sd	a6,48(s0)
 910:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 914:	00840613          	addi	a2,s0,8
 918:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 91c:	85aa                	mv	a1,a0
 91e:	4505                	li	a0,1
 920:	00000097          	auipc	ra,0x0
 924:	dce080e7          	jalr	-562(ra) # 6ee <vprintf>
}
 928:	60e2                	ld	ra,24(sp)
 92a:	6442                	ld	s0,16(sp)
 92c:	6125                	addi	sp,sp,96
 92e:	8082                	ret

0000000000000930 <free>:
 930:	1141                	addi	sp,sp,-16
 932:	e422                	sd	s0,8(sp)
 934:	0800                	addi	s0,sp,16
 936:	ff050693          	addi	a3,a0,-16
 93a:	00000797          	auipc	a5,0x0
 93e:	3e67b783          	ld	a5,998(a5) # d20 <freep>
 942:	a805                	j	972 <free+0x42>
 944:	4618                	lw	a4,8(a2)
 946:	9db9                	addw	a1,a1,a4
 948:	feb52c23          	sw	a1,-8(a0)
 94c:	6398                	ld	a4,0(a5)
 94e:	6318                	ld	a4,0(a4)
 950:	fee53823          	sd	a4,-16(a0)
 954:	a091                	j	998 <free+0x68>
 956:	ff852703          	lw	a4,-8(a0)
 95a:	9e39                	addw	a2,a2,a4
 95c:	c790                	sw	a2,8(a5)
 95e:	ff053703          	ld	a4,-16(a0)
 962:	e398                	sd	a4,0(a5)
 964:	a099                	j	9aa <free+0x7a>
 966:	6398                	ld	a4,0(a5)
 968:	00e7e463          	bltu	a5,a4,970 <free+0x40>
 96c:	00e6ea63          	bltu	a3,a4,980 <free+0x50>
 970:	87ba                	mv	a5,a4
 972:	fed7fae3          	bgeu	a5,a3,966 <free+0x36>
 976:	6398                	ld	a4,0(a5)
 978:	00e6e463          	bltu	a3,a4,980 <free+0x50>
 97c:	fee7eae3          	bltu	a5,a4,970 <free+0x40>
 980:	ff852583          	lw	a1,-8(a0)
 984:	6390                	ld	a2,0(a5)
 986:	02059713          	slli	a4,a1,0x20
 98a:	9301                	srli	a4,a4,0x20
 98c:	0712                	slli	a4,a4,0x4
 98e:	9736                	add	a4,a4,a3
 990:	fae60ae3          	beq	a2,a4,944 <free+0x14>
 994:	fec53823          	sd	a2,-16(a0)
 998:	4790                	lw	a2,8(a5)
 99a:	02061713          	slli	a4,a2,0x20
 99e:	9301                	srli	a4,a4,0x20
 9a0:	0712                	slli	a4,a4,0x4
 9a2:	973e                	add	a4,a4,a5
 9a4:	fae689e3          	beq	a3,a4,956 <free+0x26>
 9a8:	e394                	sd	a3,0(a5)
 9aa:	00000717          	auipc	a4,0x0
 9ae:	36f73b23          	sd	a5,886(a4) # d20 <freep>
 9b2:	6422                	ld	s0,8(sp)
 9b4:	0141                	addi	sp,sp,16
 9b6:	8082                	ret

00000000000009b8 <malloc>:
 9b8:	7139                	addi	sp,sp,-64
 9ba:	fc06                	sd	ra,56(sp)
 9bc:	f822                	sd	s0,48(sp)
 9be:	f426                	sd	s1,40(sp)
 9c0:	f04a                	sd	s2,32(sp)
 9c2:	ec4e                	sd	s3,24(sp)
 9c4:	e852                	sd	s4,16(sp)
 9c6:	e456                	sd	s5,8(sp)
 9c8:	e05a                	sd	s6,0(sp)
 9ca:	0080                	addi	s0,sp,64
 9cc:	02051493          	slli	s1,a0,0x20
 9d0:	9081                	srli	s1,s1,0x20
 9d2:	04bd                	addi	s1,s1,15
 9d4:	8091                	srli	s1,s1,0x4
 9d6:	0014899b          	addiw	s3,s1,1
 9da:	0485                	addi	s1,s1,1
 9dc:	00000517          	auipc	a0,0x0
 9e0:	34453503          	ld	a0,836(a0) # d20 <freep>
 9e4:	c515                	beqz	a0,a10 <malloc+0x58>
 9e6:	611c                	ld	a5,0(a0)
 9e8:	4798                	lw	a4,8(a5)
 9ea:	02977f63          	bgeu	a4,s1,a28 <malloc+0x70>
 9ee:	8a4e                	mv	s4,s3
 9f0:	0009871b          	sext.w	a4,s3
 9f4:	6685                	lui	a3,0x1
 9f6:	00d77363          	bgeu	a4,a3,9fc <malloc+0x44>
 9fa:	6a05                	lui	s4,0x1
 9fc:	000a0b1b          	sext.w	s6,s4
 a00:	004a1a1b          	slliw	s4,s4,0x4
 a04:	00000917          	auipc	s2,0x0
 a08:	31c90913          	addi	s2,s2,796 # d20 <freep>
 a0c:	5afd                	li	s5,-1
 a0e:	a88d                	j	a80 <malloc+0xc8>
 a10:	00000797          	auipc	a5,0x0
 a14:	31878793          	addi	a5,a5,792 # d28 <base>
 a18:	00000717          	auipc	a4,0x0
 a1c:	30f73423          	sd	a5,776(a4) # d20 <freep>
 a20:	e39c                	sd	a5,0(a5)
 a22:	0007a423          	sw	zero,8(a5)
 a26:	b7e1                	j	9ee <malloc+0x36>
 a28:	02e48b63          	beq	s1,a4,a5e <malloc+0xa6>
 a2c:	4137073b          	subw	a4,a4,s3
 a30:	c798                	sw	a4,8(a5)
 a32:	1702                	slli	a4,a4,0x20
 a34:	9301                	srli	a4,a4,0x20
 a36:	0712                	slli	a4,a4,0x4
 a38:	97ba                	add	a5,a5,a4
 a3a:	0137a423          	sw	s3,8(a5)
 a3e:	00000717          	auipc	a4,0x0
 a42:	2ea73123          	sd	a0,738(a4) # d20 <freep>
 a46:	01078513          	addi	a0,a5,16
 a4a:	70e2                	ld	ra,56(sp)
 a4c:	7442                	ld	s0,48(sp)
 a4e:	74a2                	ld	s1,40(sp)
 a50:	7902                	ld	s2,32(sp)
 a52:	69e2                	ld	s3,24(sp)
 a54:	6a42                	ld	s4,16(sp)
 a56:	6aa2                	ld	s5,8(sp)
 a58:	6b02                	ld	s6,0(sp)
 a5a:	6121                	addi	sp,sp,64
 a5c:	8082                	ret
 a5e:	6398                	ld	a4,0(a5)
 a60:	e118                	sd	a4,0(a0)
 a62:	bff1                	j	a3e <malloc+0x86>
 a64:	01652423          	sw	s6,8(a0)
 a68:	0541                	addi	a0,a0,16
 a6a:	00000097          	auipc	ra,0x0
 a6e:	ec6080e7          	jalr	-314(ra) # 930 <free>
 a72:	00093503          	ld	a0,0(s2)
 a76:	d971                	beqz	a0,a4a <malloc+0x92>
 a78:	611c                	ld	a5,0(a0)
 a7a:	4798                	lw	a4,8(a5)
 a7c:	fa9776e3          	bgeu	a4,s1,a28 <malloc+0x70>
 a80:	00093703          	ld	a4,0(s2)
 a84:	853e                	mv	a0,a5
 a86:	fef719e3          	bne	a4,a5,a78 <malloc+0xc0>
 a8a:	8552                	mv	a0,s4
 a8c:	00000097          	auipc	ra,0x0
 a90:	b7c080e7          	jalr	-1156(ra) # 608 <sbrk>
 a94:	fd5518e3          	bne	a0,s5,a64 <malloc+0xac>
 a98:	4501                	li	a0,0
 a9a:	bf45                	j	a4a <malloc+0x92>

0000000000000a9c <mem_init>:
 a9c:	1141                	addi	sp,sp,-16
 a9e:	e406                	sd	ra,8(sp)
 aa0:	e022                	sd	s0,0(sp)
 aa2:	0800                	addi	s0,sp,16
 aa4:	6505                	lui	a0,0x1
 aa6:	00000097          	auipc	ra,0x0
 aaa:	b62080e7          	jalr	-1182(ra) # 608 <sbrk>
 aae:	00000797          	auipc	a5,0x0
 ab2:	26a7b523          	sd	a0,618(a5) # d18 <alloc>
 ab6:	00850793          	addi	a5,a0,8 # 1008 <__BSS_END__+0x2d0>
 aba:	e11c                	sd	a5,0(a0)
 abc:	60a2                	ld	ra,8(sp)
 abe:	6402                	ld	s0,0(sp)
 ac0:	0141                	addi	sp,sp,16
 ac2:	8082                	ret

0000000000000ac4 <l_alloc>:
 ac4:	1101                	addi	sp,sp,-32
 ac6:	ec06                	sd	ra,24(sp)
 ac8:	e822                	sd	s0,16(sp)
 aca:	e426                	sd	s1,8(sp)
 acc:	1000                	addi	s0,sp,32
 ace:	84aa                	mv	s1,a0
 ad0:	00000797          	auipc	a5,0x0
 ad4:	2407a783          	lw	a5,576(a5) # d10 <if_init>
 ad8:	c795                	beqz	a5,b04 <l_alloc+0x40>
 ada:	00000717          	auipc	a4,0x0
 ade:	23e73703          	ld	a4,574(a4) # d18 <alloc>
 ae2:	6308                	ld	a0,0(a4)
 ae4:	40e506b3          	sub	a3,a0,a4
 ae8:	6785                	lui	a5,0x1
 aea:	37e1                	addiw	a5,a5,-8
 aec:	9f95                	subw	a5,a5,a3
 aee:	02f4f563          	bgeu	s1,a5,b18 <l_alloc+0x54>
 af2:	1482                	slli	s1,s1,0x20
 af4:	9081                	srli	s1,s1,0x20
 af6:	94aa                	add	s1,s1,a0
 af8:	e304                	sd	s1,0(a4)
 afa:	60e2                	ld	ra,24(sp)
 afc:	6442                	ld	s0,16(sp)
 afe:	64a2                	ld	s1,8(sp)
 b00:	6105                	addi	sp,sp,32
 b02:	8082                	ret
 b04:	00000097          	auipc	ra,0x0
 b08:	f98080e7          	jalr	-104(ra) # a9c <mem_init>
 b0c:	4785                	li	a5,1
 b0e:	00000717          	auipc	a4,0x0
 b12:	20f72123          	sw	a5,514(a4) # d10 <if_init>
 b16:	b7d1                	j	ada <l_alloc+0x16>
 b18:	4501                	li	a0,0
 b1a:	b7c5                	j	afa <l_alloc+0x36>

0000000000000b1c <l_free>:
 b1c:	1141                	addi	sp,sp,-16
 b1e:	e422                	sd	s0,8(sp)
 b20:	0800                	addi	s0,sp,16
 b22:	6422                	ld	s0,8(sp)
 b24:	0141                	addi	sp,sp,16
 b26:	8082                	ret
