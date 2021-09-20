
user/_cowtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <simpletest>:
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	00001517          	auipc	a0,0x1
  12:	ce250513          	addi	a0,a0,-798 # cf0 <l_free+0x12>
  16:	00001097          	auipc	ra,0x1
  1a:	aa6080e7          	jalr	-1370(ra) # abc <printf>
  1e:	05555537          	lui	a0,0x5555
  22:	55450513          	addi	a0,a0,1364 # 5555554 <__BSS_END__+0x555068c>
  26:	00000097          	auipc	ra,0x0
  2a:	7a4080e7          	jalr	1956(ra) # 7ca <sbrk>
  2e:	57fd                	li	a5,-1
  30:	06f50563          	beq	a0,a5,9a <simpletest+0x9a>
  34:	84aa                	mv	s1,a0
  36:	05556937          	lui	s2,0x5556
  3a:	992a                	add	s2,s2,a0
  3c:	6985                	lui	s3,0x1
  3e:	00000097          	auipc	ra,0x0
  42:	784080e7          	jalr	1924(ra) # 7c2 <getpid>
  46:	c088                	sw	a0,0(s1)
  48:	94ce                	add	s1,s1,s3
  4a:	fe991ae3          	bne	s2,s1,3e <simpletest+0x3e>
  4e:	00000097          	auipc	ra,0x0
  52:	6ec080e7          	jalr	1772(ra) # 73a <fork>
  56:	06054363          	bltz	a0,bc <simpletest+0xbc>
  5a:	cd35                	beqz	a0,d6 <simpletest+0xd6>
  5c:	4501                	li	a0,0
  5e:	00000097          	auipc	ra,0x0
  62:	6ec080e7          	jalr	1772(ra) # 74a <wait>
  66:	faaab537          	lui	a0,0xfaaab
  6a:	aac50513          	addi	a0,a0,-1364 # fffffffffaaaaaac <__BSS_END__+0xfffffffffaaa5be4>
  6e:	00000097          	auipc	ra,0x0
  72:	75c080e7          	jalr	1884(ra) # 7ca <sbrk>
  76:	57fd                	li	a5,-1
  78:	06f50363          	beq	a0,a5,de <simpletest+0xde>
  7c:	00001517          	auipc	a0,0x1
  80:	cc450513          	addi	a0,a0,-828 # d40 <l_free+0x62>
  84:	00001097          	auipc	ra,0x1
  88:	a38080e7          	jalr	-1480(ra) # abc <printf>
  8c:	70a2                	ld	ra,40(sp)
  8e:	7402                	ld	s0,32(sp)
  90:	64e2                	ld	s1,24(sp)
  92:	6942                	ld	s2,16(sp)
  94:	69a2                	ld	s3,8(sp)
  96:	6145                	addi	sp,sp,48
  98:	8082                	ret
  9a:	055555b7          	lui	a1,0x5555
  9e:	55458593          	addi	a1,a1,1364 # 5555554 <__BSS_END__+0x555068c>
  a2:	00001517          	auipc	a0,0x1
  a6:	c5e50513          	addi	a0,a0,-930 # d00 <l_free+0x22>
  aa:	00001097          	auipc	ra,0x1
  ae:	a12080e7          	jalr	-1518(ra) # abc <printf>
  b2:	557d                	li	a0,-1
  b4:	00000097          	auipc	ra,0x0
  b8:	68e080e7          	jalr	1678(ra) # 742 <exit>
  bc:	00001517          	auipc	a0,0x1
  c0:	c5c50513          	addi	a0,a0,-932 # d18 <l_free+0x3a>
  c4:	00001097          	auipc	ra,0x1
  c8:	9f8080e7          	jalr	-1544(ra) # abc <printf>
  cc:	557d                	li	a0,-1
  ce:	00000097          	auipc	ra,0x0
  d2:	674080e7          	jalr	1652(ra) # 742 <exit>
  d6:	00000097          	auipc	ra,0x0
  da:	66c080e7          	jalr	1644(ra) # 742 <exit>
  de:	055555b7          	lui	a1,0x5555
  e2:	55458593          	addi	a1,a1,1364 # 5555554 <__BSS_END__+0x555068c>
  e6:	00001517          	auipc	a0,0x1
  ea:	c4250513          	addi	a0,a0,-958 # d28 <l_free+0x4a>
  ee:	00001097          	auipc	ra,0x1
  f2:	9ce080e7          	jalr	-1586(ra) # abc <printf>
  f6:	557d                	li	a0,-1
  f8:	00000097          	auipc	ra,0x0
  fc:	64a080e7          	jalr	1610(ra) # 742 <exit>

0000000000000100 <threetest>:
 100:	7179                	addi	sp,sp,-48
 102:	f406                	sd	ra,40(sp)
 104:	f022                	sd	s0,32(sp)
 106:	ec26                	sd	s1,24(sp)
 108:	e84a                	sd	s2,16(sp)
 10a:	e44e                	sd	s3,8(sp)
 10c:	e052                	sd	s4,0(sp)
 10e:	1800                	addi	s0,sp,48
 110:	00001517          	auipc	a0,0x1
 114:	c3850513          	addi	a0,a0,-968 # d48 <l_free+0x6a>
 118:	00001097          	auipc	ra,0x1
 11c:	9a4080e7          	jalr	-1628(ra) # abc <printf>
 120:	02000537          	lui	a0,0x2000
 124:	00000097          	auipc	ra,0x0
 128:	6a6080e7          	jalr	1702(ra) # 7ca <sbrk>
 12c:	57fd                	li	a5,-1
 12e:	08f50763          	beq	a0,a5,1bc <threetest+0xbc>
 132:	84aa                	mv	s1,a0
 134:	00000097          	auipc	ra,0x0
 138:	606080e7          	jalr	1542(ra) # 73a <fork>
 13c:	08054f63          	bltz	a0,1da <threetest+0xda>
 140:	c955                	beqz	a0,1f4 <threetest+0xf4>
 142:	020009b7          	lui	s3,0x2000
 146:	99a6                	add	s3,s3,s1
 148:	8926                	mv	s2,s1
 14a:	6a05                	lui	s4,0x1
 14c:	00000097          	auipc	ra,0x0
 150:	676080e7          	jalr	1654(ra) # 7c2 <getpid>
 154:	00a92023          	sw	a0,0(s2) # 5556000 <__BSS_END__+0x5551138>
 158:	9952                	add	s2,s2,s4
 15a:	ff3919e3          	bne	s2,s3,14c <threetest+0x4c>
 15e:	4501                	li	a0,0
 160:	00000097          	auipc	ra,0x0
 164:	5ea080e7          	jalr	1514(ra) # 74a <wait>
 168:	4505                	li	a0,1
 16a:	00000097          	auipc	ra,0x0
 16e:	668080e7          	jalr	1640(ra) # 7d2 <sleep>
 172:	6a05                	lui	s4,0x1
 174:	0004a903          	lw	s2,0(s1)
 178:	00000097          	auipc	ra,0x0
 17c:	64a080e7          	jalr	1610(ra) # 7c2 <getpid>
 180:	10a91a63          	bne	s2,a0,294 <threetest+0x194>
 184:	94d2                	add	s1,s1,s4
 186:	ff3497e3          	bne	s1,s3,174 <threetest+0x74>
 18a:	fe000537          	lui	a0,0xfe000
 18e:	00000097          	auipc	ra,0x0
 192:	63c080e7          	jalr	1596(ra) # 7ca <sbrk>
 196:	57fd                	li	a5,-1
 198:	10f50b63          	beq	a0,a5,2ae <threetest+0x1ae>
 19c:	00001517          	auipc	a0,0x1
 1a0:	ba450513          	addi	a0,a0,-1116 # d40 <l_free+0x62>
 1a4:	00001097          	auipc	ra,0x1
 1a8:	918080e7          	jalr	-1768(ra) # abc <printf>
 1ac:	70a2                	ld	ra,40(sp)
 1ae:	7402                	ld	s0,32(sp)
 1b0:	64e2                	ld	s1,24(sp)
 1b2:	6942                	ld	s2,16(sp)
 1b4:	69a2                	ld	s3,8(sp)
 1b6:	6a02                	ld	s4,0(sp)
 1b8:	6145                	addi	sp,sp,48
 1ba:	8082                	ret
 1bc:	020005b7          	lui	a1,0x2000
 1c0:	00001517          	auipc	a0,0x1
 1c4:	b4050513          	addi	a0,a0,-1216 # d00 <l_free+0x22>
 1c8:	00001097          	auipc	ra,0x1
 1cc:	8f4080e7          	jalr	-1804(ra) # abc <printf>
 1d0:	557d                	li	a0,-1
 1d2:	00000097          	auipc	ra,0x0
 1d6:	570080e7          	jalr	1392(ra) # 742 <exit>
 1da:	00001517          	auipc	a0,0x1
 1de:	b7650513          	addi	a0,a0,-1162 # d50 <l_free+0x72>
 1e2:	00001097          	auipc	ra,0x1
 1e6:	8da080e7          	jalr	-1830(ra) # abc <printf>
 1ea:	557d                	li	a0,-1
 1ec:	00000097          	auipc	ra,0x0
 1f0:	556080e7          	jalr	1366(ra) # 742 <exit>
 1f4:	00000097          	auipc	ra,0x0
 1f8:	546080e7          	jalr	1350(ra) # 73a <fork>
 1fc:	04054263          	bltz	a0,240 <threetest+0x140>
 200:	ed29                	bnez	a0,25a <threetest+0x15a>
 202:	0199a9b7          	lui	s3,0x199a
 206:	99a6                	add	s3,s3,s1
 208:	8926                	mv	s2,s1
 20a:	6a05                	lui	s4,0x1
 20c:	00000097          	auipc	ra,0x0
 210:	5b6080e7          	jalr	1462(ra) # 7c2 <getpid>
 214:	00a92023          	sw	a0,0(s2)
 218:	9952                	add	s2,s2,s4
 21a:	ff2999e3          	bne	s3,s2,20c <threetest+0x10c>
 21e:	6a05                	lui	s4,0x1
 220:	0004a903          	lw	s2,0(s1)
 224:	00000097          	auipc	ra,0x0
 228:	59e080e7          	jalr	1438(ra) # 7c2 <getpid>
 22c:	04a91763          	bne	s2,a0,27a <threetest+0x17a>
 230:	94d2                	add	s1,s1,s4
 232:	fe9997e3          	bne	s3,s1,220 <threetest+0x120>
 236:	557d                	li	a0,-1
 238:	00000097          	auipc	ra,0x0
 23c:	50a080e7          	jalr	1290(ra) # 742 <exit>
 240:	00001517          	auipc	a0,0x1
 244:	b2050513          	addi	a0,a0,-1248 # d60 <l_free+0x82>
 248:	00001097          	auipc	ra,0x1
 24c:	874080e7          	jalr	-1932(ra) # abc <printf>
 250:	557d                	li	a0,-1
 252:	00000097          	auipc	ra,0x0
 256:	4f0080e7          	jalr	1264(ra) # 742 <exit>
 25a:	01000737          	lui	a4,0x1000
 25e:	9726                	add	a4,a4,s1
 260:	6789                	lui	a5,0x2
 262:	70f78793          	addi	a5,a5,1807 # 270f <buf+0x857>
 266:	6685                	lui	a3,0x1
 268:	c09c                	sw	a5,0(s1)
 26a:	94b6                	add	s1,s1,a3
 26c:	fee49ee3          	bne	s1,a4,268 <threetest+0x168>
 270:	4501                	li	a0,0
 272:	00000097          	auipc	ra,0x0
 276:	4d0080e7          	jalr	1232(ra) # 742 <exit>
 27a:	00001517          	auipc	a0,0x1
 27e:	af650513          	addi	a0,a0,-1290 # d70 <l_free+0x92>
 282:	00001097          	auipc	ra,0x1
 286:	83a080e7          	jalr	-1990(ra) # abc <printf>
 28a:	557d                	li	a0,-1
 28c:	00000097          	auipc	ra,0x0
 290:	4b6080e7          	jalr	1206(ra) # 742 <exit>
 294:	00001517          	auipc	a0,0x1
 298:	adc50513          	addi	a0,a0,-1316 # d70 <l_free+0x92>
 29c:	00001097          	auipc	ra,0x1
 2a0:	820080e7          	jalr	-2016(ra) # abc <printf>
 2a4:	557d                	li	a0,-1
 2a6:	00000097          	auipc	ra,0x0
 2aa:	49c080e7          	jalr	1180(ra) # 742 <exit>
 2ae:	020005b7          	lui	a1,0x2000
 2b2:	00001517          	auipc	a0,0x1
 2b6:	a7650513          	addi	a0,a0,-1418 # d28 <l_free+0x4a>
 2ba:	00001097          	auipc	ra,0x1
 2be:	802080e7          	jalr	-2046(ra) # abc <printf>
 2c2:	557d                	li	a0,-1
 2c4:	00000097          	auipc	ra,0x0
 2c8:	47e080e7          	jalr	1150(ra) # 742 <exit>

00000000000002cc <filetest>:
 2cc:	7179                	addi	sp,sp,-48
 2ce:	f406                	sd	ra,40(sp)
 2d0:	f022                	sd	s0,32(sp)
 2d2:	ec26                	sd	s1,24(sp)
 2d4:	e84a                	sd	s2,16(sp)
 2d6:	1800                	addi	s0,sp,48
 2d8:	00001517          	auipc	a0,0x1
 2dc:	aa850513          	addi	a0,a0,-1368 # d80 <l_free+0xa2>
 2e0:	00000097          	auipc	ra,0x0
 2e4:	7dc080e7          	jalr	2012(ra) # abc <printf>
 2e8:	06300793          	li	a5,99
 2ec:	00002717          	auipc	a4,0x2
 2f0:	bcf70623          	sb	a5,-1076(a4) # 1eb8 <buf>
 2f4:	fc042c23          	sw	zero,-40(s0)
 2f8:	00001497          	auipc	s1,0x1
 2fc:	ba048493          	addi	s1,s1,-1120 # e98 <fds>
 300:	490d                	li	s2,3
 302:	8526                	mv	a0,s1
 304:	00000097          	auipc	ra,0x0
 308:	44e080e7          	jalr	1102(ra) # 752 <pipe>
 30c:	e149                	bnez	a0,38e <filetest+0xc2>
 30e:	00000097          	auipc	ra,0x0
 312:	42c080e7          	jalr	1068(ra) # 73a <fork>
 316:	08054963          	bltz	a0,3a8 <filetest+0xdc>
 31a:	c545                	beqz	a0,3c2 <filetest+0xf6>
 31c:	4611                	li	a2,4
 31e:	fd840593          	addi	a1,s0,-40
 322:	40c8                	lw	a0,4(s1)
 324:	00000097          	auipc	ra,0x0
 328:	43e080e7          	jalr	1086(ra) # 762 <write>
 32c:	4791                	li	a5,4
 32e:	10f51b63          	bne	a0,a5,444 <filetest+0x178>
 332:	fd842783          	lw	a5,-40(s0)
 336:	2785                	addiw	a5,a5,1
 338:	0007871b          	sext.w	a4,a5
 33c:	fcf42c23          	sw	a5,-40(s0)
 340:	fce951e3          	bge	s2,a4,302 <filetest+0x36>
 344:	fc042e23          	sw	zero,-36(s0)
 348:	4491                	li	s1,4
 34a:	fdc40513          	addi	a0,s0,-36
 34e:	00000097          	auipc	ra,0x0
 352:	3fc080e7          	jalr	1020(ra) # 74a <wait>
 356:	fdc42783          	lw	a5,-36(s0)
 35a:	10079263          	bnez	a5,45e <filetest+0x192>
 35e:	34fd                	addiw	s1,s1,-1
 360:	f4ed                	bnez	s1,34a <filetest+0x7e>
 362:	00002717          	auipc	a4,0x2
 366:	b5674703          	lbu	a4,-1194(a4) # 1eb8 <buf>
 36a:	06300793          	li	a5,99
 36e:	0ef71d63          	bne	a4,a5,468 <filetest+0x19c>
 372:	00001517          	auipc	a0,0x1
 376:	9ce50513          	addi	a0,a0,-1586 # d40 <l_free+0x62>
 37a:	00000097          	auipc	ra,0x0
 37e:	742080e7          	jalr	1858(ra) # abc <printf>
 382:	70a2                	ld	ra,40(sp)
 384:	7402                	ld	s0,32(sp)
 386:	64e2                	ld	s1,24(sp)
 388:	6942                	ld	s2,16(sp)
 38a:	6145                	addi	sp,sp,48
 38c:	8082                	ret
 38e:	00001517          	auipc	a0,0x1
 392:	9fa50513          	addi	a0,a0,-1542 # d88 <l_free+0xaa>
 396:	00000097          	auipc	ra,0x0
 39a:	726080e7          	jalr	1830(ra) # abc <printf>
 39e:	557d                	li	a0,-1
 3a0:	00000097          	auipc	ra,0x0
 3a4:	3a2080e7          	jalr	930(ra) # 742 <exit>
 3a8:	00001517          	auipc	a0,0x1
 3ac:	9a850513          	addi	a0,a0,-1624 # d50 <l_free+0x72>
 3b0:	00000097          	auipc	ra,0x0
 3b4:	70c080e7          	jalr	1804(ra) # abc <printf>
 3b8:	557d                	li	a0,-1
 3ba:	00000097          	auipc	ra,0x0
 3be:	388080e7          	jalr	904(ra) # 742 <exit>
 3c2:	4505                	li	a0,1
 3c4:	00000097          	auipc	ra,0x0
 3c8:	40e080e7          	jalr	1038(ra) # 7d2 <sleep>
 3cc:	4611                	li	a2,4
 3ce:	00002597          	auipc	a1,0x2
 3d2:	aea58593          	addi	a1,a1,-1302 # 1eb8 <buf>
 3d6:	00001517          	auipc	a0,0x1
 3da:	ac252503          	lw	a0,-1342(a0) # e98 <fds>
 3de:	00000097          	auipc	ra,0x0
 3e2:	37c080e7          	jalr	892(ra) # 75a <read>
 3e6:	4791                	li	a5,4
 3e8:	02f51c63          	bne	a0,a5,420 <filetest+0x154>
 3ec:	4505                	li	a0,1
 3ee:	00000097          	auipc	ra,0x0
 3f2:	3e4080e7          	jalr	996(ra) # 7d2 <sleep>
 3f6:	fd842703          	lw	a4,-40(s0)
 3fa:	00002797          	auipc	a5,0x2
 3fe:	abe7a783          	lw	a5,-1346(a5) # 1eb8 <buf>
 402:	02f70c63          	beq	a4,a5,43a <filetest+0x16e>
 406:	00001517          	auipc	a0,0x1
 40a:	9aa50513          	addi	a0,a0,-1622 # db0 <l_free+0xd2>
 40e:	00000097          	auipc	ra,0x0
 412:	6ae080e7          	jalr	1710(ra) # abc <printf>
 416:	4505                	li	a0,1
 418:	00000097          	auipc	ra,0x0
 41c:	32a080e7          	jalr	810(ra) # 742 <exit>
 420:	00001517          	auipc	a0,0x1
 424:	97850513          	addi	a0,a0,-1672 # d98 <l_free+0xba>
 428:	00000097          	auipc	ra,0x0
 42c:	694080e7          	jalr	1684(ra) # abc <printf>
 430:	4505                	li	a0,1
 432:	00000097          	auipc	ra,0x0
 436:	310080e7          	jalr	784(ra) # 742 <exit>
 43a:	4501                	li	a0,0
 43c:	00000097          	auipc	ra,0x0
 440:	306080e7          	jalr	774(ra) # 742 <exit>
 444:	00001517          	auipc	a0,0x1
 448:	98c50513          	addi	a0,a0,-1652 # dd0 <l_free+0xf2>
 44c:	00000097          	auipc	ra,0x0
 450:	670080e7          	jalr	1648(ra) # abc <printf>
 454:	557d                	li	a0,-1
 456:	00000097          	auipc	ra,0x0
 45a:	2ec080e7          	jalr	748(ra) # 742 <exit>
 45e:	4505                	li	a0,1
 460:	00000097          	auipc	ra,0x0
 464:	2e2080e7          	jalr	738(ra) # 742 <exit>
 468:	00001517          	auipc	a0,0x1
 46c:	98050513          	addi	a0,a0,-1664 # de8 <l_free+0x10a>
 470:	00000097          	auipc	ra,0x0
 474:	64c080e7          	jalr	1612(ra) # abc <printf>
 478:	4505                	li	a0,1
 47a:	00000097          	auipc	ra,0x0
 47e:	2c8080e7          	jalr	712(ra) # 742 <exit>

0000000000000482 <main>:
 482:	1141                	addi	sp,sp,-16
 484:	e406                	sd	ra,8(sp)
 486:	e022                	sd	s0,0(sp)
 488:	0800                	addi	s0,sp,16
 48a:	00000097          	auipc	ra,0x0
 48e:	b76080e7          	jalr	-1162(ra) # 0 <simpletest>
 492:	00000097          	auipc	ra,0x0
 496:	b6e080e7          	jalr	-1170(ra) # 0 <simpletest>
 49a:	00000097          	auipc	ra,0x0
 49e:	c66080e7          	jalr	-922(ra) # 100 <threetest>
 4a2:	00000097          	auipc	ra,0x0
 4a6:	c5e080e7          	jalr	-930(ra) # 100 <threetest>
 4aa:	00000097          	auipc	ra,0x0
 4ae:	c56080e7          	jalr	-938(ra) # 100 <threetest>
 4b2:	00000097          	auipc	ra,0x0
 4b6:	e1a080e7          	jalr	-486(ra) # 2cc <filetest>
 4ba:	00001517          	auipc	a0,0x1
 4be:	94e50513          	addi	a0,a0,-1714 # e08 <l_free+0x12a>
 4c2:	00000097          	auipc	ra,0x0
 4c6:	5fa080e7          	jalr	1530(ra) # abc <printf>
 4ca:	4501                	li	a0,0
 4cc:	00000097          	auipc	ra,0x0
 4d0:	276080e7          	jalr	630(ra) # 742 <exit>

00000000000004d4 <strcpy>:
 4d4:	1141                	addi	sp,sp,-16
 4d6:	e422                	sd	s0,8(sp)
 4d8:	0800                	addi	s0,sp,16
 4da:	87aa                	mv	a5,a0
 4dc:	0585                	addi	a1,a1,1
 4de:	0785                	addi	a5,a5,1
 4e0:	fff5c703          	lbu	a4,-1(a1)
 4e4:	fee78fa3          	sb	a4,-1(a5)
 4e8:	fb75                	bnez	a4,4dc <strcpy+0x8>
 4ea:	6422                	ld	s0,8(sp)
 4ec:	0141                	addi	sp,sp,16
 4ee:	8082                	ret

00000000000004f0 <strcmp>:
 4f0:	1141                	addi	sp,sp,-16
 4f2:	e422                	sd	s0,8(sp)
 4f4:	0800                	addi	s0,sp,16
 4f6:	00054783          	lbu	a5,0(a0)
 4fa:	cb91                	beqz	a5,50e <strcmp+0x1e>
 4fc:	0005c703          	lbu	a4,0(a1)
 500:	00f71763          	bne	a4,a5,50e <strcmp+0x1e>
 504:	0505                	addi	a0,a0,1
 506:	0585                	addi	a1,a1,1
 508:	00054783          	lbu	a5,0(a0)
 50c:	fbe5                	bnez	a5,4fc <strcmp+0xc>
 50e:	0005c503          	lbu	a0,0(a1)
 512:	40a7853b          	subw	a0,a5,a0
 516:	6422                	ld	s0,8(sp)
 518:	0141                	addi	sp,sp,16
 51a:	8082                	ret

000000000000051c <strlen>:
 51c:	1141                	addi	sp,sp,-16
 51e:	e422                	sd	s0,8(sp)
 520:	0800                	addi	s0,sp,16
 522:	00054783          	lbu	a5,0(a0)
 526:	cf91                	beqz	a5,542 <strlen+0x26>
 528:	0505                	addi	a0,a0,1
 52a:	87aa                	mv	a5,a0
 52c:	4685                	li	a3,1
 52e:	9e89                	subw	a3,a3,a0
 530:	00f6853b          	addw	a0,a3,a5
 534:	0785                	addi	a5,a5,1
 536:	fff7c703          	lbu	a4,-1(a5)
 53a:	fb7d                	bnez	a4,530 <strlen+0x14>
 53c:	6422                	ld	s0,8(sp)
 53e:	0141                	addi	sp,sp,16
 540:	8082                	ret
 542:	4501                	li	a0,0
 544:	bfe5                	j	53c <strlen+0x20>

0000000000000546 <memset>:
 546:	1141                	addi	sp,sp,-16
 548:	e422                	sd	s0,8(sp)
 54a:	0800                	addi	s0,sp,16
 54c:	ca19                	beqz	a2,562 <memset+0x1c>
 54e:	87aa                	mv	a5,a0
 550:	1602                	slli	a2,a2,0x20
 552:	9201                	srli	a2,a2,0x20
 554:	00a60733          	add	a4,a2,a0
 558:	00b78023          	sb	a1,0(a5)
 55c:	0785                	addi	a5,a5,1
 55e:	fee79de3          	bne	a5,a4,558 <memset+0x12>
 562:	6422                	ld	s0,8(sp)
 564:	0141                	addi	sp,sp,16
 566:	8082                	ret

0000000000000568 <strchr>:
 568:	1141                	addi	sp,sp,-16
 56a:	e422                	sd	s0,8(sp)
 56c:	0800                	addi	s0,sp,16
 56e:	00054783          	lbu	a5,0(a0)
 572:	cb99                	beqz	a5,588 <strchr+0x20>
 574:	00f58763          	beq	a1,a5,582 <strchr+0x1a>
 578:	0505                	addi	a0,a0,1
 57a:	00054783          	lbu	a5,0(a0)
 57e:	fbfd                	bnez	a5,574 <strchr+0xc>
 580:	4501                	li	a0,0
 582:	6422                	ld	s0,8(sp)
 584:	0141                	addi	sp,sp,16
 586:	8082                	ret
 588:	4501                	li	a0,0
 58a:	bfe5                	j	582 <strchr+0x1a>

000000000000058c <gets>:
 58c:	711d                	addi	sp,sp,-96
 58e:	ec86                	sd	ra,88(sp)
 590:	e8a2                	sd	s0,80(sp)
 592:	e4a6                	sd	s1,72(sp)
 594:	e0ca                	sd	s2,64(sp)
 596:	fc4e                	sd	s3,56(sp)
 598:	f852                	sd	s4,48(sp)
 59a:	f456                	sd	s5,40(sp)
 59c:	f05a                	sd	s6,32(sp)
 59e:	ec5e                	sd	s7,24(sp)
 5a0:	1080                	addi	s0,sp,96
 5a2:	8baa                	mv	s7,a0
 5a4:	8a2e                	mv	s4,a1
 5a6:	892a                	mv	s2,a0
 5a8:	4481                	li	s1,0
 5aa:	4aa9                	li	s5,10
 5ac:	4b35                	li	s6,13
 5ae:	89a6                	mv	s3,s1
 5b0:	2485                	addiw	s1,s1,1
 5b2:	0344d863          	bge	s1,s4,5e2 <gets+0x56>
 5b6:	4605                	li	a2,1
 5b8:	faf40593          	addi	a1,s0,-81
 5bc:	4501                	li	a0,0
 5be:	00000097          	auipc	ra,0x0
 5c2:	19c080e7          	jalr	412(ra) # 75a <read>
 5c6:	00a05e63          	blez	a0,5e2 <gets+0x56>
 5ca:	faf44783          	lbu	a5,-81(s0)
 5ce:	00f90023          	sb	a5,0(s2)
 5d2:	01578763          	beq	a5,s5,5e0 <gets+0x54>
 5d6:	0905                	addi	s2,s2,1
 5d8:	fd679be3          	bne	a5,s6,5ae <gets+0x22>
 5dc:	89a6                	mv	s3,s1
 5de:	a011                	j	5e2 <gets+0x56>
 5e0:	89a6                	mv	s3,s1
 5e2:	99de                	add	s3,s3,s7
 5e4:	00098023          	sb	zero,0(s3) # 199a000 <__BSS_END__+0x1995138>
 5e8:	855e                	mv	a0,s7
 5ea:	60e6                	ld	ra,88(sp)
 5ec:	6446                	ld	s0,80(sp)
 5ee:	64a6                	ld	s1,72(sp)
 5f0:	6906                	ld	s2,64(sp)
 5f2:	79e2                	ld	s3,56(sp)
 5f4:	7a42                	ld	s4,48(sp)
 5f6:	7aa2                	ld	s5,40(sp)
 5f8:	7b02                	ld	s6,32(sp)
 5fa:	6be2                	ld	s7,24(sp)
 5fc:	6125                	addi	sp,sp,96
 5fe:	8082                	ret

0000000000000600 <stat>:
 600:	1101                	addi	sp,sp,-32
 602:	ec06                	sd	ra,24(sp)
 604:	e822                	sd	s0,16(sp)
 606:	e426                	sd	s1,8(sp)
 608:	e04a                	sd	s2,0(sp)
 60a:	1000                	addi	s0,sp,32
 60c:	892e                	mv	s2,a1
 60e:	4581                	li	a1,0
 610:	00000097          	auipc	ra,0x0
 614:	172080e7          	jalr	370(ra) # 782 <open>
 618:	02054563          	bltz	a0,642 <stat+0x42>
 61c:	84aa                	mv	s1,a0
 61e:	85ca                	mv	a1,s2
 620:	00000097          	auipc	ra,0x0
 624:	17a080e7          	jalr	378(ra) # 79a <fstat>
 628:	892a                	mv	s2,a0
 62a:	8526                	mv	a0,s1
 62c:	00000097          	auipc	ra,0x0
 630:	13e080e7          	jalr	318(ra) # 76a <close>
 634:	854a                	mv	a0,s2
 636:	60e2                	ld	ra,24(sp)
 638:	6442                	ld	s0,16(sp)
 63a:	64a2                	ld	s1,8(sp)
 63c:	6902                	ld	s2,0(sp)
 63e:	6105                	addi	sp,sp,32
 640:	8082                	ret
 642:	597d                	li	s2,-1
 644:	bfc5                	j	634 <stat+0x34>

0000000000000646 <atoi>:
 646:	1141                	addi	sp,sp,-16
 648:	e422                	sd	s0,8(sp)
 64a:	0800                	addi	s0,sp,16
 64c:	00054603          	lbu	a2,0(a0)
 650:	fd06079b          	addiw	a5,a2,-48
 654:	0ff7f793          	zext.b	a5,a5
 658:	4725                	li	a4,9
 65a:	02f76963          	bltu	a4,a5,68c <atoi+0x46>
 65e:	86aa                	mv	a3,a0
 660:	4501                	li	a0,0
 662:	45a5                	li	a1,9
 664:	0685                	addi	a3,a3,1
 666:	0025179b          	slliw	a5,a0,0x2
 66a:	9fa9                	addw	a5,a5,a0
 66c:	0017979b          	slliw	a5,a5,0x1
 670:	9fb1                	addw	a5,a5,a2
 672:	fd07851b          	addiw	a0,a5,-48
 676:	0006c603          	lbu	a2,0(a3) # 1000 <junk3+0x148>
 67a:	fd06071b          	addiw	a4,a2,-48
 67e:	0ff77713          	zext.b	a4,a4
 682:	fee5f1e3          	bgeu	a1,a4,664 <atoi+0x1e>
 686:	6422                	ld	s0,8(sp)
 688:	0141                	addi	sp,sp,16
 68a:	8082                	ret
 68c:	4501                	li	a0,0
 68e:	bfe5                	j	686 <atoi+0x40>

0000000000000690 <memmove>:
 690:	1141                	addi	sp,sp,-16
 692:	e422                	sd	s0,8(sp)
 694:	0800                	addi	s0,sp,16
 696:	02b57463          	bgeu	a0,a1,6be <memmove+0x2e>
 69a:	00c05f63          	blez	a2,6b8 <memmove+0x28>
 69e:	1602                	slli	a2,a2,0x20
 6a0:	9201                	srli	a2,a2,0x20
 6a2:	00c507b3          	add	a5,a0,a2
 6a6:	872a                	mv	a4,a0
 6a8:	0585                	addi	a1,a1,1
 6aa:	0705                	addi	a4,a4,1
 6ac:	fff5c683          	lbu	a3,-1(a1)
 6b0:	fed70fa3          	sb	a3,-1(a4)
 6b4:	fee79ae3          	bne	a5,a4,6a8 <memmove+0x18>
 6b8:	6422                	ld	s0,8(sp)
 6ba:	0141                	addi	sp,sp,16
 6bc:	8082                	ret
 6be:	00c50733          	add	a4,a0,a2
 6c2:	95b2                	add	a1,a1,a2
 6c4:	fec05ae3          	blez	a2,6b8 <memmove+0x28>
 6c8:	fff6079b          	addiw	a5,a2,-1
 6cc:	1782                	slli	a5,a5,0x20
 6ce:	9381                	srli	a5,a5,0x20
 6d0:	fff7c793          	not	a5,a5
 6d4:	97ba                	add	a5,a5,a4
 6d6:	15fd                	addi	a1,a1,-1
 6d8:	177d                	addi	a4,a4,-1
 6da:	0005c683          	lbu	a3,0(a1)
 6de:	00d70023          	sb	a3,0(a4)
 6e2:	fee79ae3          	bne	a5,a4,6d6 <memmove+0x46>
 6e6:	bfc9                	j	6b8 <memmove+0x28>

00000000000006e8 <memcmp>:
 6e8:	1141                	addi	sp,sp,-16
 6ea:	e422                	sd	s0,8(sp)
 6ec:	0800                	addi	s0,sp,16
 6ee:	ca05                	beqz	a2,71e <memcmp+0x36>
 6f0:	fff6069b          	addiw	a3,a2,-1
 6f4:	1682                	slli	a3,a3,0x20
 6f6:	9281                	srli	a3,a3,0x20
 6f8:	0685                	addi	a3,a3,1
 6fa:	96aa                	add	a3,a3,a0
 6fc:	00054783          	lbu	a5,0(a0)
 700:	0005c703          	lbu	a4,0(a1)
 704:	00e79863          	bne	a5,a4,714 <memcmp+0x2c>
 708:	0505                	addi	a0,a0,1
 70a:	0585                	addi	a1,a1,1
 70c:	fed518e3          	bne	a0,a3,6fc <memcmp+0x14>
 710:	4501                	li	a0,0
 712:	a019                	j	718 <memcmp+0x30>
 714:	40e7853b          	subw	a0,a5,a4
 718:	6422                	ld	s0,8(sp)
 71a:	0141                	addi	sp,sp,16
 71c:	8082                	ret
 71e:	4501                	li	a0,0
 720:	bfe5                	j	718 <memcmp+0x30>

0000000000000722 <memcpy>:
 722:	1141                	addi	sp,sp,-16
 724:	e406                	sd	ra,8(sp)
 726:	e022                	sd	s0,0(sp)
 728:	0800                	addi	s0,sp,16
 72a:	00000097          	auipc	ra,0x0
 72e:	f66080e7          	jalr	-154(ra) # 690 <memmove>
 732:	60a2                	ld	ra,8(sp)
 734:	6402                	ld	s0,0(sp)
 736:	0141                	addi	sp,sp,16
 738:	8082                	ret

000000000000073a <fork>:
 73a:	4885                	li	a7,1
 73c:	00000073          	ecall
 740:	8082                	ret

0000000000000742 <exit>:
 742:	4889                	li	a7,2
 744:	00000073          	ecall
 748:	8082                	ret

000000000000074a <wait>:
 74a:	488d                	li	a7,3
 74c:	00000073          	ecall
 750:	8082                	ret

0000000000000752 <pipe>:
 752:	4891                	li	a7,4
 754:	00000073          	ecall
 758:	8082                	ret

000000000000075a <read>:
 75a:	4895                	li	a7,5
 75c:	00000073          	ecall
 760:	8082                	ret

0000000000000762 <write>:
 762:	48c1                	li	a7,16
 764:	00000073          	ecall
 768:	8082                	ret

000000000000076a <close>:
 76a:	48d5                	li	a7,21
 76c:	00000073          	ecall
 770:	8082                	ret

0000000000000772 <kill>:
 772:	4899                	li	a7,6
 774:	00000073          	ecall
 778:	8082                	ret

000000000000077a <exec>:
 77a:	489d                	li	a7,7
 77c:	00000073          	ecall
 780:	8082                	ret

0000000000000782 <open>:
 782:	48bd                	li	a7,15
 784:	00000073          	ecall
 788:	8082                	ret

000000000000078a <mknod>:
 78a:	48c5                	li	a7,17
 78c:	00000073          	ecall
 790:	8082                	ret

0000000000000792 <unlink>:
 792:	48c9                	li	a7,18
 794:	00000073          	ecall
 798:	8082                	ret

000000000000079a <fstat>:
 79a:	48a1                	li	a7,8
 79c:	00000073          	ecall
 7a0:	8082                	ret

00000000000007a2 <link>:
 7a2:	48cd                	li	a7,19
 7a4:	00000073          	ecall
 7a8:	8082                	ret

00000000000007aa <mkdir>:
 7aa:	48d1                	li	a7,20
 7ac:	00000073          	ecall
 7b0:	8082                	ret

00000000000007b2 <chdir>:
 7b2:	48a5                	li	a7,9
 7b4:	00000073          	ecall
 7b8:	8082                	ret

00000000000007ba <dup>:
 7ba:	48a9                	li	a7,10
 7bc:	00000073          	ecall
 7c0:	8082                	ret

00000000000007c2 <getpid>:
 7c2:	48ad                	li	a7,11
 7c4:	00000073          	ecall
 7c8:	8082                	ret

00000000000007ca <sbrk>:
 7ca:	48b1                	li	a7,12
 7cc:	00000073          	ecall
 7d0:	8082                	ret

00000000000007d2 <sleep>:
 7d2:	48b5                	li	a7,13
 7d4:	00000073          	ecall
 7d8:	8082                	ret

00000000000007da <uptime>:
 7da:	48b9                	li	a7,14
 7dc:	00000073          	ecall
 7e0:	8082                	ret

00000000000007e2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 7e2:	1101                	addi	sp,sp,-32
 7e4:	ec06                	sd	ra,24(sp)
 7e6:	e822                	sd	s0,16(sp)
 7e8:	1000                	addi	s0,sp,32
 7ea:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 7ee:	4605                	li	a2,1
 7f0:	fef40593          	addi	a1,s0,-17
 7f4:	00000097          	auipc	ra,0x0
 7f8:	f6e080e7          	jalr	-146(ra) # 762 <write>
}
 7fc:	60e2                	ld	ra,24(sp)
 7fe:	6442                	ld	s0,16(sp)
 800:	6105                	addi	sp,sp,32
 802:	8082                	ret

0000000000000804 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 804:	7139                	addi	sp,sp,-64
 806:	fc06                	sd	ra,56(sp)
 808:	f822                	sd	s0,48(sp)
 80a:	f426                	sd	s1,40(sp)
 80c:	f04a                	sd	s2,32(sp)
 80e:	ec4e                	sd	s3,24(sp)
 810:	0080                	addi	s0,sp,64
 812:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 814:	c299                	beqz	a3,81a <printint+0x16>
 816:	0805c963          	bltz	a1,8a8 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 81a:	2581                	sext.w	a1,a1
  neg = 0;
 81c:	4881                	li	a7,0
 81e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 822:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 824:	2601                	sext.w	a2,a2
 826:	00000517          	auipc	a0,0x0
 82a:	65a50513          	addi	a0,a0,1626 # e80 <digits>
 82e:	883a                	mv	a6,a4
 830:	2705                	addiw	a4,a4,1
 832:	02c5f7bb          	remuw	a5,a1,a2
 836:	1782                	slli	a5,a5,0x20
 838:	9381                	srli	a5,a5,0x20
 83a:	97aa                	add	a5,a5,a0
 83c:	0007c783          	lbu	a5,0(a5)
 840:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 844:	0005879b          	sext.w	a5,a1
 848:	02c5d5bb          	divuw	a1,a1,a2
 84c:	0685                	addi	a3,a3,1
 84e:	fec7f0e3          	bgeu	a5,a2,82e <printint+0x2a>
  if(neg)
 852:	00088c63          	beqz	a7,86a <printint+0x66>
    buf[i++] = '-';
 856:	fd070793          	addi	a5,a4,-48
 85a:	00878733          	add	a4,a5,s0
 85e:	02d00793          	li	a5,45
 862:	fef70823          	sb	a5,-16(a4)
 866:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 86a:	02e05863          	blez	a4,89a <printint+0x96>
 86e:	fc040793          	addi	a5,s0,-64
 872:	00e78933          	add	s2,a5,a4
 876:	fff78993          	addi	s3,a5,-1
 87a:	99ba                	add	s3,s3,a4
 87c:	377d                	addiw	a4,a4,-1
 87e:	1702                	slli	a4,a4,0x20
 880:	9301                	srli	a4,a4,0x20
 882:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 886:	fff94583          	lbu	a1,-1(s2)
 88a:	8526                	mv	a0,s1
 88c:	00000097          	auipc	ra,0x0
 890:	f56080e7          	jalr	-170(ra) # 7e2 <putc>
  while(--i >= 0)
 894:	197d                	addi	s2,s2,-1
 896:	ff3918e3          	bne	s2,s3,886 <printint+0x82>
}
 89a:	70e2                	ld	ra,56(sp)
 89c:	7442                	ld	s0,48(sp)
 89e:	74a2                	ld	s1,40(sp)
 8a0:	7902                	ld	s2,32(sp)
 8a2:	69e2                	ld	s3,24(sp)
 8a4:	6121                	addi	sp,sp,64
 8a6:	8082                	ret
    x = -xx;
 8a8:	40b005bb          	negw	a1,a1
    neg = 1;
 8ac:	4885                	li	a7,1
    x = -xx;
 8ae:	bf85                	j	81e <printint+0x1a>

00000000000008b0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 8b0:	7119                	addi	sp,sp,-128
 8b2:	fc86                	sd	ra,120(sp)
 8b4:	f8a2                	sd	s0,112(sp)
 8b6:	f4a6                	sd	s1,104(sp)
 8b8:	f0ca                	sd	s2,96(sp)
 8ba:	ecce                	sd	s3,88(sp)
 8bc:	e8d2                	sd	s4,80(sp)
 8be:	e4d6                	sd	s5,72(sp)
 8c0:	e0da                	sd	s6,64(sp)
 8c2:	fc5e                	sd	s7,56(sp)
 8c4:	f862                	sd	s8,48(sp)
 8c6:	f466                	sd	s9,40(sp)
 8c8:	f06a                	sd	s10,32(sp)
 8ca:	ec6e                	sd	s11,24(sp)
 8cc:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 8ce:	0005c903          	lbu	s2,0(a1)
 8d2:	18090f63          	beqz	s2,a70 <vprintf+0x1c0>
 8d6:	8aaa                	mv	s5,a0
 8d8:	8b32                	mv	s6,a2
 8da:	00158493          	addi	s1,a1,1
  state = 0;
 8de:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 8e0:	02500a13          	li	s4,37
 8e4:	4c55                	li	s8,21
 8e6:	00000c97          	auipc	s9,0x0
 8ea:	542c8c93          	addi	s9,s9,1346 # e28 <l_free+0x14a>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 8ee:	02800d93          	li	s11,40
  putc(fd, 'x');
 8f2:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8f4:	00000b97          	auipc	s7,0x0
 8f8:	58cb8b93          	addi	s7,s7,1420 # e80 <digits>
 8fc:	a839                	j	91a <vprintf+0x6a>
        putc(fd, c);
 8fe:	85ca                	mv	a1,s2
 900:	8556                	mv	a0,s5
 902:	00000097          	auipc	ra,0x0
 906:	ee0080e7          	jalr	-288(ra) # 7e2 <putc>
 90a:	a019                	j	910 <vprintf+0x60>
    } else if(state == '%'){
 90c:	01498d63          	beq	s3,s4,926 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 910:	0485                	addi	s1,s1,1
 912:	fff4c903          	lbu	s2,-1(s1)
 916:	14090d63          	beqz	s2,a70 <vprintf+0x1c0>
    if(state == 0){
 91a:	fe0999e3          	bnez	s3,90c <vprintf+0x5c>
      if(c == '%'){
 91e:	ff4910e3          	bne	s2,s4,8fe <vprintf+0x4e>
        state = '%';
 922:	89d2                	mv	s3,s4
 924:	b7f5                	j	910 <vprintf+0x60>
      if(c == 'd'){
 926:	11490c63          	beq	s2,s4,a3e <vprintf+0x18e>
 92a:	f9d9079b          	addiw	a5,s2,-99
 92e:	0ff7f793          	zext.b	a5,a5
 932:	10fc6e63          	bltu	s8,a5,a4e <vprintf+0x19e>
 936:	f9d9079b          	addiw	a5,s2,-99
 93a:	0ff7f713          	zext.b	a4,a5
 93e:	10ec6863          	bltu	s8,a4,a4e <vprintf+0x19e>
 942:	00271793          	slli	a5,a4,0x2
 946:	97e6                	add	a5,a5,s9
 948:	439c                	lw	a5,0(a5)
 94a:	97e6                	add	a5,a5,s9
 94c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 94e:	008b0913          	addi	s2,s6,8
 952:	4685                	li	a3,1
 954:	4629                	li	a2,10
 956:	000b2583          	lw	a1,0(s6)
 95a:	8556                	mv	a0,s5
 95c:	00000097          	auipc	ra,0x0
 960:	ea8080e7          	jalr	-344(ra) # 804 <printint>
 964:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 966:	4981                	li	s3,0
 968:	b765                	j	910 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 96a:	008b0913          	addi	s2,s6,8
 96e:	4681                	li	a3,0
 970:	4629                	li	a2,10
 972:	000b2583          	lw	a1,0(s6)
 976:	8556                	mv	a0,s5
 978:	00000097          	auipc	ra,0x0
 97c:	e8c080e7          	jalr	-372(ra) # 804 <printint>
 980:	8b4a                	mv	s6,s2
      state = 0;
 982:	4981                	li	s3,0
 984:	b771                	j	910 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 986:	008b0913          	addi	s2,s6,8
 98a:	4681                	li	a3,0
 98c:	866a                	mv	a2,s10
 98e:	000b2583          	lw	a1,0(s6)
 992:	8556                	mv	a0,s5
 994:	00000097          	auipc	ra,0x0
 998:	e70080e7          	jalr	-400(ra) # 804 <printint>
 99c:	8b4a                	mv	s6,s2
      state = 0;
 99e:	4981                	li	s3,0
 9a0:	bf85                	j	910 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 9a2:	008b0793          	addi	a5,s6,8
 9a6:	f8f43423          	sd	a5,-120(s0)
 9aa:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 9ae:	03000593          	li	a1,48
 9b2:	8556                	mv	a0,s5
 9b4:	00000097          	auipc	ra,0x0
 9b8:	e2e080e7          	jalr	-466(ra) # 7e2 <putc>
  putc(fd, 'x');
 9bc:	07800593          	li	a1,120
 9c0:	8556                	mv	a0,s5
 9c2:	00000097          	auipc	ra,0x0
 9c6:	e20080e7          	jalr	-480(ra) # 7e2 <putc>
 9ca:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9cc:	03c9d793          	srli	a5,s3,0x3c
 9d0:	97de                	add	a5,a5,s7
 9d2:	0007c583          	lbu	a1,0(a5)
 9d6:	8556                	mv	a0,s5
 9d8:	00000097          	auipc	ra,0x0
 9dc:	e0a080e7          	jalr	-502(ra) # 7e2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 9e0:	0992                	slli	s3,s3,0x4
 9e2:	397d                	addiw	s2,s2,-1
 9e4:	fe0914e3          	bnez	s2,9cc <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 9e8:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 9ec:	4981                	li	s3,0
 9ee:	b70d                	j	910 <vprintf+0x60>
        s = va_arg(ap, char*);
 9f0:	008b0913          	addi	s2,s6,8
 9f4:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 9f8:	02098163          	beqz	s3,a1a <vprintf+0x16a>
        while(*s != 0){
 9fc:	0009c583          	lbu	a1,0(s3)
 a00:	c5ad                	beqz	a1,a6a <vprintf+0x1ba>
          putc(fd, *s);
 a02:	8556                	mv	a0,s5
 a04:	00000097          	auipc	ra,0x0
 a08:	dde080e7          	jalr	-546(ra) # 7e2 <putc>
          s++;
 a0c:	0985                	addi	s3,s3,1
        while(*s != 0){
 a0e:	0009c583          	lbu	a1,0(s3)
 a12:	f9e5                	bnez	a1,a02 <vprintf+0x152>
        s = va_arg(ap, char*);
 a14:	8b4a                	mv	s6,s2
      state = 0;
 a16:	4981                	li	s3,0
 a18:	bde5                	j	910 <vprintf+0x60>
          s = "(null)";
 a1a:	00000997          	auipc	s3,0x0
 a1e:	40698993          	addi	s3,s3,1030 # e20 <l_free+0x142>
        while(*s != 0){
 a22:	85ee                	mv	a1,s11
 a24:	bff9                	j	a02 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 a26:	008b0913          	addi	s2,s6,8
 a2a:	000b4583          	lbu	a1,0(s6)
 a2e:	8556                	mv	a0,s5
 a30:	00000097          	auipc	ra,0x0
 a34:	db2080e7          	jalr	-590(ra) # 7e2 <putc>
 a38:	8b4a                	mv	s6,s2
      state = 0;
 a3a:	4981                	li	s3,0
 a3c:	bdd1                	j	910 <vprintf+0x60>
        putc(fd, c);
 a3e:	85d2                	mv	a1,s4
 a40:	8556                	mv	a0,s5
 a42:	00000097          	auipc	ra,0x0
 a46:	da0080e7          	jalr	-608(ra) # 7e2 <putc>
      state = 0;
 a4a:	4981                	li	s3,0
 a4c:	b5d1                	j	910 <vprintf+0x60>
        putc(fd, '%');
 a4e:	85d2                	mv	a1,s4
 a50:	8556                	mv	a0,s5
 a52:	00000097          	auipc	ra,0x0
 a56:	d90080e7          	jalr	-624(ra) # 7e2 <putc>
        putc(fd, c);
 a5a:	85ca                	mv	a1,s2
 a5c:	8556                	mv	a0,s5
 a5e:	00000097          	auipc	ra,0x0
 a62:	d84080e7          	jalr	-636(ra) # 7e2 <putc>
      state = 0;
 a66:	4981                	li	s3,0
 a68:	b565                	j	910 <vprintf+0x60>
        s = va_arg(ap, char*);
 a6a:	8b4a                	mv	s6,s2
      state = 0;
 a6c:	4981                	li	s3,0
 a6e:	b54d                	j	910 <vprintf+0x60>
    }
  }
}
 a70:	70e6                	ld	ra,120(sp)
 a72:	7446                	ld	s0,112(sp)
 a74:	74a6                	ld	s1,104(sp)
 a76:	7906                	ld	s2,96(sp)
 a78:	69e6                	ld	s3,88(sp)
 a7a:	6a46                	ld	s4,80(sp)
 a7c:	6aa6                	ld	s5,72(sp)
 a7e:	6b06                	ld	s6,64(sp)
 a80:	7be2                	ld	s7,56(sp)
 a82:	7c42                	ld	s8,48(sp)
 a84:	7ca2                	ld	s9,40(sp)
 a86:	7d02                	ld	s10,32(sp)
 a88:	6de2                	ld	s11,24(sp)
 a8a:	6109                	addi	sp,sp,128
 a8c:	8082                	ret

0000000000000a8e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a8e:	715d                	addi	sp,sp,-80
 a90:	ec06                	sd	ra,24(sp)
 a92:	e822                	sd	s0,16(sp)
 a94:	1000                	addi	s0,sp,32
 a96:	e010                	sd	a2,0(s0)
 a98:	e414                	sd	a3,8(s0)
 a9a:	e818                	sd	a4,16(s0)
 a9c:	ec1c                	sd	a5,24(s0)
 a9e:	03043023          	sd	a6,32(s0)
 aa2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 aa6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 aaa:	8622                	mv	a2,s0
 aac:	00000097          	auipc	ra,0x0
 ab0:	e04080e7          	jalr	-508(ra) # 8b0 <vprintf>
}
 ab4:	60e2                	ld	ra,24(sp)
 ab6:	6442                	ld	s0,16(sp)
 ab8:	6161                	addi	sp,sp,80
 aba:	8082                	ret

0000000000000abc <printf>:

void
printf(const char *fmt, ...)
{
 abc:	711d                	addi	sp,sp,-96
 abe:	ec06                	sd	ra,24(sp)
 ac0:	e822                	sd	s0,16(sp)
 ac2:	1000                	addi	s0,sp,32
 ac4:	e40c                	sd	a1,8(s0)
 ac6:	e810                	sd	a2,16(s0)
 ac8:	ec14                	sd	a3,24(s0)
 aca:	f018                	sd	a4,32(s0)
 acc:	f41c                	sd	a5,40(s0)
 ace:	03043823          	sd	a6,48(s0)
 ad2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 ad6:	00840613          	addi	a2,s0,8
 ada:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 ade:	85aa                	mv	a1,a0
 ae0:	4505                	li	a0,1
 ae2:	00000097          	auipc	ra,0x0
 ae6:	dce080e7          	jalr	-562(ra) # 8b0 <vprintf>
}
 aea:	60e2                	ld	ra,24(sp)
 aec:	6442                	ld	s0,16(sp)
 aee:	6125                	addi	sp,sp,96
 af0:	8082                	ret

0000000000000af2 <free>:
 af2:	1141                	addi	sp,sp,-16
 af4:	e422                	sd	s0,8(sp)
 af6:	0800                	addi	s0,sp,16
 af8:	ff050693          	addi	a3,a0,-16
 afc:	00000797          	auipc	a5,0x0
 b00:	3b47b783          	ld	a5,948(a5) # eb0 <freep>
 b04:	a805                	j	b34 <free+0x42>
 b06:	4618                	lw	a4,8(a2)
 b08:	9db9                	addw	a1,a1,a4
 b0a:	feb52c23          	sw	a1,-8(a0)
 b0e:	6398                	ld	a4,0(a5)
 b10:	6318                	ld	a4,0(a4)
 b12:	fee53823          	sd	a4,-16(a0)
 b16:	a091                	j	b5a <free+0x68>
 b18:	ff852703          	lw	a4,-8(a0)
 b1c:	9e39                	addw	a2,a2,a4
 b1e:	c790                	sw	a2,8(a5)
 b20:	ff053703          	ld	a4,-16(a0)
 b24:	e398                	sd	a4,0(a5)
 b26:	a099                	j	b6c <free+0x7a>
 b28:	6398                	ld	a4,0(a5)
 b2a:	00e7e463          	bltu	a5,a4,b32 <free+0x40>
 b2e:	00e6ea63          	bltu	a3,a4,b42 <free+0x50>
 b32:	87ba                	mv	a5,a4
 b34:	fed7fae3          	bgeu	a5,a3,b28 <free+0x36>
 b38:	6398                	ld	a4,0(a5)
 b3a:	00e6e463          	bltu	a3,a4,b42 <free+0x50>
 b3e:	fee7eae3          	bltu	a5,a4,b32 <free+0x40>
 b42:	ff852583          	lw	a1,-8(a0)
 b46:	6390                	ld	a2,0(a5)
 b48:	02059713          	slli	a4,a1,0x20
 b4c:	9301                	srli	a4,a4,0x20
 b4e:	0712                	slli	a4,a4,0x4
 b50:	9736                	add	a4,a4,a3
 b52:	fae60ae3          	beq	a2,a4,b06 <free+0x14>
 b56:	fec53823          	sd	a2,-16(a0)
 b5a:	4790                	lw	a2,8(a5)
 b5c:	02061713          	slli	a4,a2,0x20
 b60:	9301                	srli	a4,a4,0x20
 b62:	0712                	slli	a4,a4,0x4
 b64:	973e                	add	a4,a4,a5
 b66:	fae689e3          	beq	a3,a4,b18 <free+0x26>
 b6a:	e394                	sd	a3,0(a5)
 b6c:	00000717          	auipc	a4,0x0
 b70:	34f73223          	sd	a5,836(a4) # eb0 <freep>
 b74:	6422                	ld	s0,8(sp)
 b76:	0141                	addi	sp,sp,16
 b78:	8082                	ret

0000000000000b7a <malloc>:
 b7a:	7139                	addi	sp,sp,-64
 b7c:	fc06                	sd	ra,56(sp)
 b7e:	f822                	sd	s0,48(sp)
 b80:	f426                	sd	s1,40(sp)
 b82:	f04a                	sd	s2,32(sp)
 b84:	ec4e                	sd	s3,24(sp)
 b86:	e852                	sd	s4,16(sp)
 b88:	e456                	sd	s5,8(sp)
 b8a:	e05a                	sd	s6,0(sp)
 b8c:	0080                	addi	s0,sp,64
 b8e:	02051493          	slli	s1,a0,0x20
 b92:	9081                	srli	s1,s1,0x20
 b94:	04bd                	addi	s1,s1,15
 b96:	8091                	srli	s1,s1,0x4
 b98:	0014899b          	addiw	s3,s1,1
 b9c:	0485                	addi	s1,s1,1
 b9e:	00000517          	auipc	a0,0x0
 ba2:	31253503          	ld	a0,786(a0) # eb0 <freep>
 ba6:	c515                	beqz	a0,bd2 <malloc+0x58>
 ba8:	611c                	ld	a5,0(a0)
 baa:	4798                	lw	a4,8(a5)
 bac:	02977f63          	bgeu	a4,s1,bea <malloc+0x70>
 bb0:	8a4e                	mv	s4,s3
 bb2:	0009871b          	sext.w	a4,s3
 bb6:	6685                	lui	a3,0x1
 bb8:	00d77363          	bgeu	a4,a3,bbe <malloc+0x44>
 bbc:	6a05                	lui	s4,0x1
 bbe:	000a0b1b          	sext.w	s6,s4
 bc2:	004a1a1b          	slliw	s4,s4,0x4
 bc6:	00000917          	auipc	s2,0x0
 bca:	2ea90913          	addi	s2,s2,746 # eb0 <freep>
 bce:	5afd                	li	s5,-1
 bd0:	a88d                	j	c42 <malloc+0xc8>
 bd2:	00004797          	auipc	a5,0x4
 bd6:	2e678793          	addi	a5,a5,742 # 4eb8 <base>
 bda:	00000717          	auipc	a4,0x0
 bde:	2cf73b23          	sd	a5,726(a4) # eb0 <freep>
 be2:	e39c                	sd	a5,0(a5)
 be4:	0007a423          	sw	zero,8(a5)
 be8:	b7e1                	j	bb0 <malloc+0x36>
 bea:	02e48b63          	beq	s1,a4,c20 <malloc+0xa6>
 bee:	4137073b          	subw	a4,a4,s3
 bf2:	c798                	sw	a4,8(a5)
 bf4:	1702                	slli	a4,a4,0x20
 bf6:	9301                	srli	a4,a4,0x20
 bf8:	0712                	slli	a4,a4,0x4
 bfa:	97ba                	add	a5,a5,a4
 bfc:	0137a423          	sw	s3,8(a5)
 c00:	00000717          	auipc	a4,0x0
 c04:	2aa73823          	sd	a0,688(a4) # eb0 <freep>
 c08:	01078513          	addi	a0,a5,16
 c0c:	70e2                	ld	ra,56(sp)
 c0e:	7442                	ld	s0,48(sp)
 c10:	74a2                	ld	s1,40(sp)
 c12:	7902                	ld	s2,32(sp)
 c14:	69e2                	ld	s3,24(sp)
 c16:	6a42                	ld	s4,16(sp)
 c18:	6aa2                	ld	s5,8(sp)
 c1a:	6b02                	ld	s6,0(sp)
 c1c:	6121                	addi	sp,sp,64
 c1e:	8082                	ret
 c20:	6398                	ld	a4,0(a5)
 c22:	e118                	sd	a4,0(a0)
 c24:	bff1                	j	c00 <malloc+0x86>
 c26:	01652423          	sw	s6,8(a0)
 c2a:	0541                	addi	a0,a0,16
 c2c:	00000097          	auipc	ra,0x0
 c30:	ec6080e7          	jalr	-314(ra) # af2 <free>
 c34:	00093503          	ld	a0,0(s2)
 c38:	d971                	beqz	a0,c0c <malloc+0x92>
 c3a:	611c                	ld	a5,0(a0)
 c3c:	4798                	lw	a4,8(a5)
 c3e:	fa9776e3          	bgeu	a4,s1,bea <malloc+0x70>
 c42:	00093703          	ld	a4,0(s2)
 c46:	853e                	mv	a0,a5
 c48:	fef719e3          	bne	a4,a5,c3a <malloc+0xc0>
 c4c:	8552                	mv	a0,s4
 c4e:	00000097          	auipc	ra,0x0
 c52:	b7c080e7          	jalr	-1156(ra) # 7ca <sbrk>
 c56:	fd5518e3          	bne	a0,s5,c26 <malloc+0xac>
 c5a:	4501                	li	a0,0
 c5c:	bf45                	j	c0c <malloc+0x92>

0000000000000c5e <mem_init>:
 c5e:	1141                	addi	sp,sp,-16
 c60:	e406                	sd	ra,8(sp)
 c62:	e022                	sd	s0,0(sp)
 c64:	0800                	addi	s0,sp,16
 c66:	6505                	lui	a0,0x1
 c68:	00000097          	auipc	ra,0x0
 c6c:	b62080e7          	jalr	-1182(ra) # 7ca <sbrk>
 c70:	00000797          	auipc	a5,0x0
 c74:	22a7bc23          	sd	a0,568(a5) # ea8 <alloc>
 c78:	00850793          	addi	a5,a0,8 # 1008 <junk3+0x150>
 c7c:	e11c                	sd	a5,0(a0)
 c7e:	60a2                	ld	ra,8(sp)
 c80:	6402                	ld	s0,0(sp)
 c82:	0141                	addi	sp,sp,16
 c84:	8082                	ret

0000000000000c86 <l_alloc>:
 c86:	1101                	addi	sp,sp,-32
 c88:	ec06                	sd	ra,24(sp)
 c8a:	e822                	sd	s0,16(sp)
 c8c:	e426                	sd	s1,8(sp)
 c8e:	1000                	addi	s0,sp,32
 c90:	84aa                	mv	s1,a0
 c92:	00000797          	auipc	a5,0x0
 c96:	20e7a783          	lw	a5,526(a5) # ea0 <if_init>
 c9a:	c795                	beqz	a5,cc6 <l_alloc+0x40>
 c9c:	00000717          	auipc	a4,0x0
 ca0:	20c73703          	ld	a4,524(a4) # ea8 <alloc>
 ca4:	6308                	ld	a0,0(a4)
 ca6:	40e506b3          	sub	a3,a0,a4
 caa:	6785                	lui	a5,0x1
 cac:	37e1                	addiw	a5,a5,-8
 cae:	9f95                	subw	a5,a5,a3
 cb0:	02f4f563          	bgeu	s1,a5,cda <l_alloc+0x54>
 cb4:	1482                	slli	s1,s1,0x20
 cb6:	9081                	srli	s1,s1,0x20
 cb8:	94aa                	add	s1,s1,a0
 cba:	e304                	sd	s1,0(a4)
 cbc:	60e2                	ld	ra,24(sp)
 cbe:	6442                	ld	s0,16(sp)
 cc0:	64a2                	ld	s1,8(sp)
 cc2:	6105                	addi	sp,sp,32
 cc4:	8082                	ret
 cc6:	00000097          	auipc	ra,0x0
 cca:	f98080e7          	jalr	-104(ra) # c5e <mem_init>
 cce:	4785                	li	a5,1
 cd0:	00000717          	auipc	a4,0x0
 cd4:	1cf72823          	sw	a5,464(a4) # ea0 <if_init>
 cd8:	b7d1                	j	c9c <l_alloc+0x16>
 cda:	4501                	li	a0,0
 cdc:	b7c5                	j	cbc <l_alloc+0x36>

0000000000000cde <l_free>:
 cde:	1141                	addi	sp,sp,-16
 ce0:	e422                	sd	s0,8(sp)
 ce2:	0800                	addi	s0,sp,16
 ce4:	6422                	ld	s0,8(sp)
 ce6:	0141                	addi	sp,sp,16
 ce8:	8082                	ret
