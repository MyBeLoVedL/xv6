
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
       0:	1141                	addi	sp,sp,-16
       2:	e422                	sd	s0,8(sp)
       4:	0800                	addi	s0,sp,16
       6:	611c                	ld	a5,0(a0)
       8:	80000737          	lui	a4,0x80000
       c:	ffe74713          	xori	a4,a4,-2
      10:	02e7f7b3          	remu	a5,a5,a4
      14:	0785                	addi	a5,a5,1
      16:	66fd                	lui	a3,0x1f
      18:	31d68693          	addi	a3,a3,797 # 1f31d <__global_pointer$+0x1d3cc>
      1c:	02d7e733          	rem	a4,a5,a3
      20:	6611                	lui	a2,0x4
      22:	1a760613          	addi	a2,a2,423 # 41a7 <__global_pointer$+0x2256>
      26:	02c70733          	mul	a4,a4,a2
      2a:	02d7c7b3          	div	a5,a5,a3
      2e:	76fd                	lui	a3,0xfffff
      30:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <__global_pointer$+0xffffffffffffd59b>
      34:	02d787b3          	mul	a5,a5,a3
      38:	97ba                	add	a5,a5,a4
      3a:	0007c963          	bltz	a5,4c <do_rand+0x4c>
      3e:	17fd                	addi	a5,a5,-1
      40:	e11c                	sd	a5,0(a0)
      42:	0007851b          	sext.w	a0,a5
      46:	6422                	ld	s0,8(sp)
      48:	0141                	addi	sp,sp,16
      4a:	8082                	ret
      4c:	80000737          	lui	a4,0x80000
      50:	fff74713          	not	a4,a4
      54:	97ba                	add	a5,a5,a4
      56:	b7e5                	j	3e <do_rand+0x3e>

0000000000000058 <rand>:
      58:	1141                	addi	sp,sp,-16
      5a:	e406                	sd	ra,8(sp)
      5c:	e022                	sd	s0,0(sp)
      5e:	0800                	addi	s0,sp,16
      60:	00001517          	auipc	a0,0x1
      64:	6f850513          	addi	a0,a0,1784 # 1758 <rand_next>
      68:	00000097          	auipc	ra,0x0
      6c:	f98080e7          	jalr	-104(ra) # 0 <do_rand>
      70:	60a2                	ld	ra,8(sp)
      72:	6402                	ld	s0,0(sp)
      74:	0141                	addi	sp,sp,16
      76:	8082                	ret

0000000000000078 <go>:
      78:	7159                	addi	sp,sp,-112
      7a:	f486                	sd	ra,104(sp)
      7c:	f0a2                	sd	s0,96(sp)
      7e:	eca6                	sd	s1,88(sp)
      80:	e8ca                	sd	s2,80(sp)
      82:	e4ce                	sd	s3,72(sp)
      84:	e0d2                	sd	s4,64(sp)
      86:	fc56                	sd	s5,56(sp)
      88:	f85a                	sd	s6,48(sp)
      8a:	1880                	addi	s0,sp,112
      8c:	84aa                	mv	s1,a0
      8e:	4501                	li	a0,0
      90:	00001097          	auipc	ra,0x1
      94:	e4e080e7          	jalr	-434(ra) # ede <sbrk>
      98:	8a2a                	mv	s4,a0
      9a:	00001517          	auipc	a0,0x1
      9e:	36650513          	addi	a0,a0,870 # 1400 <l_free+0xe>
      a2:	00001097          	auipc	ra,0x1
      a6:	e1c080e7          	jalr	-484(ra) # ebe <mkdir>
      aa:	00001517          	auipc	a0,0x1
      ae:	35650513          	addi	a0,a0,854 # 1400 <l_free+0xe>
      b2:	00001097          	auipc	ra,0x1
      b6:	e14080e7          	jalr	-492(ra) # ec6 <chdir>
      ba:	cd11                	beqz	a0,d6 <go+0x5e>
      bc:	00001517          	auipc	a0,0x1
      c0:	34c50513          	addi	a0,a0,844 # 1408 <l_free+0x16>
      c4:	00001097          	auipc	ra,0x1
      c8:	10c080e7          	jalr	268(ra) # 11d0 <printf>
      cc:	4505                	li	a0,1
      ce:	00001097          	auipc	ra,0x1
      d2:	d88080e7          	jalr	-632(ra) # e56 <exit>
      d6:	00001517          	auipc	a0,0x1
      da:	35250513          	addi	a0,a0,850 # 1428 <l_free+0x36>
      de:	00001097          	auipc	ra,0x1
      e2:	de8080e7          	jalr	-536(ra) # ec6 <chdir>
      e6:	00001997          	auipc	s3,0x1
      ea:	35298993          	addi	s3,s3,850 # 1438 <l_free+0x46>
      ee:	c489                	beqz	s1,f8 <go+0x80>
      f0:	00001997          	auipc	s3,0x1
      f4:	34098993          	addi	s3,s3,832 # 1430 <l_free+0x3e>
      f8:	4485                	li	s1,1
      fa:	597d                	li	s2,-1
      fc:	6a85                	lui	s5,0x1
      fe:	77ba8a93          	addi	s5,s5,1915 # 177b <buf.0+0x3>
     102:	a825                	j	13a <go+0xc2>
     104:	20200593          	li	a1,514
     108:	00001517          	auipc	a0,0x1
     10c:	33850513          	addi	a0,a0,824 # 1440 <l_free+0x4e>
     110:	00001097          	auipc	ra,0x1
     114:	d86080e7          	jalr	-634(ra) # e96 <open>
     118:	00001097          	auipc	ra,0x1
     11c:	d66080e7          	jalr	-666(ra) # e7e <close>
     120:	0485                	addi	s1,s1,1
     122:	1f400793          	li	a5,500
     126:	02f4f7b3          	remu	a5,s1,a5
     12a:	eb81                	bnez	a5,13a <go+0xc2>
     12c:	4605                	li	a2,1
     12e:	85ce                	mv	a1,s3
     130:	4505                	li	a0,1
     132:	00001097          	auipc	ra,0x1
     136:	d44080e7          	jalr	-700(ra) # e76 <write>
     13a:	00000097          	auipc	ra,0x0
     13e:	f1e080e7          	jalr	-226(ra) # 58 <rand>
     142:	47dd                	li	a5,23
     144:	02f5653b          	remw	a0,a0,a5
     148:	4785                	li	a5,1
     14a:	faf50de3          	beq	a0,a5,104 <go+0x8c>
     14e:	4789                	li	a5,2
     150:	16f50e63          	beq	a0,a5,2cc <go+0x254>
     154:	478d                	li	a5,3
     156:	18f50a63          	beq	a0,a5,2ea <go+0x272>
     15a:	4791                	li	a5,4
     15c:	1af50063          	beq	a0,a5,2fc <go+0x284>
     160:	4795                	li	a5,5
     162:	1ef50463          	beq	a0,a5,34a <go+0x2d2>
     166:	4799                	li	a5,6
     168:	20f50263          	beq	a0,a5,36c <go+0x2f4>
     16c:	479d                	li	a5,7
     16e:	22f50063          	beq	a0,a5,38e <go+0x316>
     172:	47a1                	li	a5,8
     174:	22f50963          	beq	a0,a5,3a6 <go+0x32e>
     178:	47a5                	li	a5,9
     17a:	24f50263          	beq	a0,a5,3be <go+0x346>
     17e:	47a9                	li	a5,10
     180:	26f50e63          	beq	a0,a5,3fc <go+0x384>
     184:	47ad                	li	a5,11
     186:	2af50a63          	beq	a0,a5,43a <go+0x3c2>
     18a:	47b1                	li	a5,12
     18c:	2cf50c63          	beq	a0,a5,464 <go+0x3ec>
     190:	47b5                	li	a5,13
     192:	2ef50e63          	beq	a0,a5,48e <go+0x416>
     196:	47b9                	li	a5,14
     198:	32f50963          	beq	a0,a5,4ca <go+0x452>
     19c:	47bd                	li	a5,15
     19e:	36f50d63          	beq	a0,a5,518 <go+0x4a0>
     1a2:	47c1                	li	a5,16
     1a4:	38f50063          	beq	a0,a5,524 <go+0x4ac>
     1a8:	47c5                	li	a5,17
     1aa:	3af50063          	beq	a0,a5,54a <go+0x4d2>
     1ae:	47c9                	li	a5,18
     1b0:	42f50663          	beq	a0,a5,5dc <go+0x564>
     1b4:	47cd                	li	a5,19
     1b6:	46f50a63          	beq	a0,a5,62a <go+0x5b2>
     1ba:	47d1                	li	a5,20
     1bc:	54f50b63          	beq	a0,a5,712 <go+0x69a>
     1c0:	47d5                	li	a5,21
     1c2:	5ef50963          	beq	a0,a5,7b4 <go+0x73c>
     1c6:	47d9                	li	a5,22
     1c8:	f4f51ce3          	bne	a0,a5,120 <go+0xa8>
     1cc:	f9840513          	addi	a0,s0,-104
     1d0:	00001097          	auipc	ra,0x1
     1d4:	c96080e7          	jalr	-874(ra) # e66 <pipe>
     1d8:	6e054263          	bltz	a0,8bc <go+0x844>
     1dc:	fa040513          	addi	a0,s0,-96
     1e0:	00001097          	auipc	ra,0x1
     1e4:	c86080e7          	jalr	-890(ra) # e66 <pipe>
     1e8:	6e054863          	bltz	a0,8d8 <go+0x860>
     1ec:	00001097          	auipc	ra,0x1
     1f0:	c62080e7          	jalr	-926(ra) # e4e <fork>
     1f4:	70050063          	beqz	a0,8f4 <go+0x87c>
     1f8:	7a054863          	bltz	a0,9a8 <go+0x930>
     1fc:	00001097          	auipc	ra,0x1
     200:	c52080e7          	jalr	-942(ra) # e4e <fork>
     204:	7c050063          	beqz	a0,9c4 <go+0x94c>
     208:	08054ce3          	bltz	a0,aa0 <go+0xa28>
     20c:	f9842503          	lw	a0,-104(s0)
     210:	00001097          	auipc	ra,0x1
     214:	c6e080e7          	jalr	-914(ra) # e7e <close>
     218:	f9c42503          	lw	a0,-100(s0)
     21c:	00001097          	auipc	ra,0x1
     220:	c62080e7          	jalr	-926(ra) # e7e <close>
     224:	fa442503          	lw	a0,-92(s0)
     228:	00001097          	auipc	ra,0x1
     22c:	c56080e7          	jalr	-938(ra) # e7e <close>
     230:	f8041823          	sh	zero,-112(s0)
     234:	f8040923          	sb	zero,-110(s0)
     238:	4605                	li	a2,1
     23a:	f9040593          	addi	a1,s0,-112
     23e:	fa042503          	lw	a0,-96(s0)
     242:	00001097          	auipc	ra,0x1
     246:	c2c080e7          	jalr	-980(ra) # e6e <read>
     24a:	4605                	li	a2,1
     24c:	f9140593          	addi	a1,s0,-111
     250:	fa042503          	lw	a0,-96(s0)
     254:	00001097          	auipc	ra,0x1
     258:	c1a080e7          	jalr	-998(ra) # e6e <read>
     25c:	fa042503          	lw	a0,-96(s0)
     260:	00001097          	auipc	ra,0x1
     264:	c1e080e7          	jalr	-994(ra) # e7e <close>
     268:	f9440513          	addi	a0,s0,-108
     26c:	00001097          	auipc	ra,0x1
     270:	bf2080e7          	jalr	-1038(ra) # e5e <wait>
     274:	fa840513          	addi	a0,s0,-88
     278:	00001097          	auipc	ra,0x1
     27c:	be6080e7          	jalr	-1050(ra) # e5e <wait>
     280:	f9442783          	lw	a5,-108(s0)
     284:	fa842703          	lw	a4,-88(s0)
     288:	8fd9                	or	a5,a5,a4
     28a:	2781                	sext.w	a5,a5
     28c:	ef89                	bnez	a5,2a6 <go+0x22e>
     28e:	00001597          	auipc	a1,0x1
     292:	3d258593          	addi	a1,a1,978 # 1660 <l_free+0x26e>
     296:	f9040513          	addi	a0,s0,-112
     29a:	00001097          	auipc	ra,0x1
     29e:	96a080e7          	jalr	-1686(ra) # c04 <strcmp>
     2a2:	e6050fe3          	beqz	a0,120 <go+0xa8>
     2a6:	f9040693          	addi	a3,s0,-112
     2aa:	fa842603          	lw	a2,-88(s0)
     2ae:	f9442583          	lw	a1,-108(s0)
     2b2:	00001517          	auipc	a0,0x1
     2b6:	40650513          	addi	a0,a0,1030 # 16b8 <l_free+0x2c6>
     2ba:	00001097          	auipc	ra,0x1
     2be:	f16080e7          	jalr	-234(ra) # 11d0 <printf>
     2c2:	4505                	li	a0,1
     2c4:	00001097          	auipc	ra,0x1
     2c8:	b92080e7          	jalr	-1134(ra) # e56 <exit>
     2cc:	20200593          	li	a1,514
     2d0:	00001517          	auipc	a0,0x1
     2d4:	18050513          	addi	a0,a0,384 # 1450 <l_free+0x5e>
     2d8:	00001097          	auipc	ra,0x1
     2dc:	bbe080e7          	jalr	-1090(ra) # e96 <open>
     2e0:	00001097          	auipc	ra,0x1
     2e4:	b9e080e7          	jalr	-1122(ra) # e7e <close>
     2e8:	bd25                	j	120 <go+0xa8>
     2ea:	00001517          	auipc	a0,0x1
     2ee:	15650513          	addi	a0,a0,342 # 1440 <l_free+0x4e>
     2f2:	00001097          	auipc	ra,0x1
     2f6:	bb4080e7          	jalr	-1100(ra) # ea6 <unlink>
     2fa:	b51d                	j	120 <go+0xa8>
     2fc:	00001517          	auipc	a0,0x1
     300:	10450513          	addi	a0,a0,260 # 1400 <l_free+0xe>
     304:	00001097          	auipc	ra,0x1
     308:	bc2080e7          	jalr	-1086(ra) # ec6 <chdir>
     30c:	e115                	bnez	a0,330 <go+0x2b8>
     30e:	00001517          	auipc	a0,0x1
     312:	15a50513          	addi	a0,a0,346 # 1468 <l_free+0x76>
     316:	00001097          	auipc	ra,0x1
     31a:	b90080e7          	jalr	-1136(ra) # ea6 <unlink>
     31e:	00001517          	auipc	a0,0x1
     322:	10a50513          	addi	a0,a0,266 # 1428 <l_free+0x36>
     326:	00001097          	auipc	ra,0x1
     32a:	ba0080e7          	jalr	-1120(ra) # ec6 <chdir>
     32e:	bbcd                	j	120 <go+0xa8>
     330:	00001517          	auipc	a0,0x1
     334:	0d850513          	addi	a0,a0,216 # 1408 <l_free+0x16>
     338:	00001097          	auipc	ra,0x1
     33c:	e98080e7          	jalr	-360(ra) # 11d0 <printf>
     340:	4505                	li	a0,1
     342:	00001097          	auipc	ra,0x1
     346:	b14080e7          	jalr	-1260(ra) # e56 <exit>
     34a:	854a                	mv	a0,s2
     34c:	00001097          	auipc	ra,0x1
     350:	b32080e7          	jalr	-1230(ra) # e7e <close>
     354:	20200593          	li	a1,514
     358:	00001517          	auipc	a0,0x1
     35c:	11850513          	addi	a0,a0,280 # 1470 <l_free+0x7e>
     360:	00001097          	auipc	ra,0x1
     364:	b36080e7          	jalr	-1226(ra) # e96 <open>
     368:	892a                	mv	s2,a0
     36a:	bb5d                	j	120 <go+0xa8>
     36c:	854a                	mv	a0,s2
     36e:	00001097          	auipc	ra,0x1
     372:	b10080e7          	jalr	-1264(ra) # e7e <close>
     376:	20200593          	li	a1,514
     37a:	00001517          	auipc	a0,0x1
     37e:	10650513          	addi	a0,a0,262 # 1480 <l_free+0x8e>
     382:	00001097          	auipc	ra,0x1
     386:	b14080e7          	jalr	-1260(ra) # e96 <open>
     38a:	892a                	mv	s2,a0
     38c:	bb51                	j	120 <go+0xa8>
     38e:	3e700613          	li	a2,999
     392:	00001597          	auipc	a1,0x1
     396:	3e658593          	addi	a1,a1,998 # 1778 <buf.0>
     39a:	854a                	mv	a0,s2
     39c:	00001097          	auipc	ra,0x1
     3a0:	ada080e7          	jalr	-1318(ra) # e76 <write>
     3a4:	bbb5                	j	120 <go+0xa8>
     3a6:	3e700613          	li	a2,999
     3aa:	00001597          	auipc	a1,0x1
     3ae:	3ce58593          	addi	a1,a1,974 # 1778 <buf.0>
     3b2:	854a                	mv	a0,s2
     3b4:	00001097          	auipc	ra,0x1
     3b8:	aba080e7          	jalr	-1350(ra) # e6e <read>
     3bc:	b395                	j	120 <go+0xa8>
     3be:	00001517          	auipc	a0,0x1
     3c2:	08250513          	addi	a0,a0,130 # 1440 <l_free+0x4e>
     3c6:	00001097          	auipc	ra,0x1
     3ca:	af8080e7          	jalr	-1288(ra) # ebe <mkdir>
     3ce:	20200593          	li	a1,514
     3d2:	00001517          	auipc	a0,0x1
     3d6:	0c650513          	addi	a0,a0,198 # 1498 <l_free+0xa6>
     3da:	00001097          	auipc	ra,0x1
     3de:	abc080e7          	jalr	-1348(ra) # e96 <open>
     3e2:	00001097          	auipc	ra,0x1
     3e6:	a9c080e7          	jalr	-1380(ra) # e7e <close>
     3ea:	00001517          	auipc	a0,0x1
     3ee:	0be50513          	addi	a0,a0,190 # 14a8 <l_free+0xb6>
     3f2:	00001097          	auipc	ra,0x1
     3f6:	ab4080e7          	jalr	-1356(ra) # ea6 <unlink>
     3fa:	b31d                	j	120 <go+0xa8>
     3fc:	00001517          	auipc	a0,0x1
     400:	0b450513          	addi	a0,a0,180 # 14b0 <l_free+0xbe>
     404:	00001097          	auipc	ra,0x1
     408:	aba080e7          	jalr	-1350(ra) # ebe <mkdir>
     40c:	20200593          	li	a1,514
     410:	00001517          	auipc	a0,0x1
     414:	0a850513          	addi	a0,a0,168 # 14b8 <l_free+0xc6>
     418:	00001097          	auipc	ra,0x1
     41c:	a7e080e7          	jalr	-1410(ra) # e96 <open>
     420:	00001097          	auipc	ra,0x1
     424:	a5e080e7          	jalr	-1442(ra) # e7e <close>
     428:	00001517          	auipc	a0,0x1
     42c:	0a050513          	addi	a0,a0,160 # 14c8 <l_free+0xd6>
     430:	00001097          	auipc	ra,0x1
     434:	a76080e7          	jalr	-1418(ra) # ea6 <unlink>
     438:	b1e5                	j	120 <go+0xa8>
     43a:	00001517          	auipc	a0,0x1
     43e:	05650513          	addi	a0,a0,86 # 1490 <l_free+0x9e>
     442:	00001097          	auipc	ra,0x1
     446:	a64080e7          	jalr	-1436(ra) # ea6 <unlink>
     44a:	00001597          	auipc	a1,0x1
     44e:	01e58593          	addi	a1,a1,30 # 1468 <l_free+0x76>
     452:	00001517          	auipc	a0,0x1
     456:	07e50513          	addi	a0,a0,126 # 14d0 <l_free+0xde>
     45a:	00001097          	auipc	ra,0x1
     45e:	a5c080e7          	jalr	-1444(ra) # eb6 <link>
     462:	b97d                	j	120 <go+0xa8>
     464:	00001517          	auipc	a0,0x1
     468:	08450513          	addi	a0,a0,132 # 14e8 <l_free+0xf6>
     46c:	00001097          	auipc	ra,0x1
     470:	a3a080e7          	jalr	-1478(ra) # ea6 <unlink>
     474:	00001597          	auipc	a1,0x1
     478:	ffc58593          	addi	a1,a1,-4 # 1470 <l_free+0x7e>
     47c:	00001517          	auipc	a0,0x1
     480:	07c50513          	addi	a0,a0,124 # 14f8 <l_free+0x106>
     484:	00001097          	auipc	ra,0x1
     488:	a32080e7          	jalr	-1486(ra) # eb6 <link>
     48c:	b951                	j	120 <go+0xa8>
     48e:	00001097          	auipc	ra,0x1
     492:	9c0080e7          	jalr	-1600(ra) # e4e <fork>
     496:	c909                	beqz	a0,4a8 <go+0x430>
     498:	00054c63          	bltz	a0,4b0 <go+0x438>
     49c:	4501                	li	a0,0
     49e:	00001097          	auipc	ra,0x1
     4a2:	9c0080e7          	jalr	-1600(ra) # e5e <wait>
     4a6:	b9ad                	j	120 <go+0xa8>
     4a8:	00001097          	auipc	ra,0x1
     4ac:	9ae080e7          	jalr	-1618(ra) # e56 <exit>
     4b0:	00001517          	auipc	a0,0x1
     4b4:	05050513          	addi	a0,a0,80 # 1500 <l_free+0x10e>
     4b8:	00001097          	auipc	ra,0x1
     4bc:	d18080e7          	jalr	-744(ra) # 11d0 <printf>
     4c0:	4505                	li	a0,1
     4c2:	00001097          	auipc	ra,0x1
     4c6:	994080e7          	jalr	-1644(ra) # e56 <exit>
     4ca:	00001097          	auipc	ra,0x1
     4ce:	984080e7          	jalr	-1660(ra) # e4e <fork>
     4d2:	c909                	beqz	a0,4e4 <go+0x46c>
     4d4:	02054563          	bltz	a0,4fe <go+0x486>
     4d8:	4501                	li	a0,0
     4da:	00001097          	auipc	ra,0x1
     4de:	984080e7          	jalr	-1660(ra) # e5e <wait>
     4e2:	b93d                	j	120 <go+0xa8>
     4e4:	00001097          	auipc	ra,0x1
     4e8:	96a080e7          	jalr	-1686(ra) # e4e <fork>
     4ec:	00001097          	auipc	ra,0x1
     4f0:	962080e7          	jalr	-1694(ra) # e4e <fork>
     4f4:	4501                	li	a0,0
     4f6:	00001097          	auipc	ra,0x1
     4fa:	960080e7          	jalr	-1696(ra) # e56 <exit>
     4fe:	00001517          	auipc	a0,0x1
     502:	00250513          	addi	a0,a0,2 # 1500 <l_free+0x10e>
     506:	00001097          	auipc	ra,0x1
     50a:	cca080e7          	jalr	-822(ra) # 11d0 <printf>
     50e:	4505                	li	a0,1
     510:	00001097          	auipc	ra,0x1
     514:	946080e7          	jalr	-1722(ra) # e56 <exit>
     518:	8556                	mv	a0,s5
     51a:	00001097          	auipc	ra,0x1
     51e:	9c4080e7          	jalr	-1596(ra) # ede <sbrk>
     522:	befd                	j	120 <go+0xa8>
     524:	4501                	li	a0,0
     526:	00001097          	auipc	ra,0x1
     52a:	9b8080e7          	jalr	-1608(ra) # ede <sbrk>
     52e:	beaa79e3          	bgeu	s4,a0,120 <go+0xa8>
     532:	4501                	li	a0,0
     534:	00001097          	auipc	ra,0x1
     538:	9aa080e7          	jalr	-1622(ra) # ede <sbrk>
     53c:	40aa053b          	subw	a0,s4,a0
     540:	00001097          	auipc	ra,0x1
     544:	99e080e7          	jalr	-1634(ra) # ede <sbrk>
     548:	bee1                	j	120 <go+0xa8>
     54a:	00001097          	auipc	ra,0x1
     54e:	904080e7          	jalr	-1788(ra) # e4e <fork>
     552:	8b2a                	mv	s6,a0
     554:	c51d                	beqz	a0,582 <go+0x50a>
     556:	04054963          	bltz	a0,5a8 <go+0x530>
     55a:	00001517          	auipc	a0,0x1
     55e:	fbe50513          	addi	a0,a0,-66 # 1518 <l_free+0x126>
     562:	00001097          	auipc	ra,0x1
     566:	964080e7          	jalr	-1692(ra) # ec6 <chdir>
     56a:	ed21                	bnez	a0,5c2 <go+0x54a>
     56c:	855a                	mv	a0,s6
     56e:	00001097          	auipc	ra,0x1
     572:	918080e7          	jalr	-1768(ra) # e86 <kill>
     576:	4501                	li	a0,0
     578:	00001097          	auipc	ra,0x1
     57c:	8e6080e7          	jalr	-1818(ra) # e5e <wait>
     580:	b645                	j	120 <go+0xa8>
     582:	20200593          	li	a1,514
     586:	00001517          	auipc	a0,0x1
     58a:	f5a50513          	addi	a0,a0,-166 # 14e0 <l_free+0xee>
     58e:	00001097          	auipc	ra,0x1
     592:	908080e7          	jalr	-1784(ra) # e96 <open>
     596:	00001097          	auipc	ra,0x1
     59a:	8e8080e7          	jalr	-1816(ra) # e7e <close>
     59e:	4501                	li	a0,0
     5a0:	00001097          	auipc	ra,0x1
     5a4:	8b6080e7          	jalr	-1866(ra) # e56 <exit>
     5a8:	00001517          	auipc	a0,0x1
     5ac:	f5850513          	addi	a0,a0,-168 # 1500 <l_free+0x10e>
     5b0:	00001097          	auipc	ra,0x1
     5b4:	c20080e7          	jalr	-992(ra) # 11d0 <printf>
     5b8:	4505                	li	a0,1
     5ba:	00001097          	auipc	ra,0x1
     5be:	89c080e7          	jalr	-1892(ra) # e56 <exit>
     5c2:	00001517          	auipc	a0,0x1
     5c6:	f6650513          	addi	a0,a0,-154 # 1528 <l_free+0x136>
     5ca:	00001097          	auipc	ra,0x1
     5ce:	c06080e7          	jalr	-1018(ra) # 11d0 <printf>
     5d2:	4505                	li	a0,1
     5d4:	00001097          	auipc	ra,0x1
     5d8:	882080e7          	jalr	-1918(ra) # e56 <exit>
     5dc:	00001097          	auipc	ra,0x1
     5e0:	872080e7          	jalr	-1934(ra) # e4e <fork>
     5e4:	c909                	beqz	a0,5f6 <go+0x57e>
     5e6:	02054563          	bltz	a0,610 <go+0x598>
     5ea:	4501                	li	a0,0
     5ec:	00001097          	auipc	ra,0x1
     5f0:	872080e7          	jalr	-1934(ra) # e5e <wait>
     5f4:	b635                	j	120 <go+0xa8>
     5f6:	00001097          	auipc	ra,0x1
     5fa:	8e0080e7          	jalr	-1824(ra) # ed6 <getpid>
     5fe:	00001097          	auipc	ra,0x1
     602:	888080e7          	jalr	-1912(ra) # e86 <kill>
     606:	4501                	li	a0,0
     608:	00001097          	auipc	ra,0x1
     60c:	84e080e7          	jalr	-1970(ra) # e56 <exit>
     610:	00001517          	auipc	a0,0x1
     614:	ef050513          	addi	a0,a0,-272 # 1500 <l_free+0x10e>
     618:	00001097          	auipc	ra,0x1
     61c:	bb8080e7          	jalr	-1096(ra) # 11d0 <printf>
     620:	4505                	li	a0,1
     622:	00001097          	auipc	ra,0x1
     626:	834080e7          	jalr	-1996(ra) # e56 <exit>
     62a:	fa840513          	addi	a0,s0,-88
     62e:	00001097          	auipc	ra,0x1
     632:	838080e7          	jalr	-1992(ra) # e66 <pipe>
     636:	02054b63          	bltz	a0,66c <go+0x5f4>
     63a:	00001097          	auipc	ra,0x1
     63e:	814080e7          	jalr	-2028(ra) # e4e <fork>
     642:	c131                	beqz	a0,686 <go+0x60e>
     644:	0a054a63          	bltz	a0,6f8 <go+0x680>
     648:	fa842503          	lw	a0,-88(s0)
     64c:	00001097          	auipc	ra,0x1
     650:	832080e7          	jalr	-1998(ra) # e7e <close>
     654:	fac42503          	lw	a0,-84(s0)
     658:	00001097          	auipc	ra,0x1
     65c:	826080e7          	jalr	-2010(ra) # e7e <close>
     660:	4501                	li	a0,0
     662:	00000097          	auipc	ra,0x0
     666:	7fc080e7          	jalr	2044(ra) # e5e <wait>
     66a:	bc5d                	j	120 <go+0xa8>
     66c:	00001517          	auipc	a0,0x1
     670:	ed450513          	addi	a0,a0,-300 # 1540 <l_free+0x14e>
     674:	00001097          	auipc	ra,0x1
     678:	b5c080e7          	jalr	-1188(ra) # 11d0 <printf>
     67c:	4505                	li	a0,1
     67e:	00000097          	auipc	ra,0x0
     682:	7d8080e7          	jalr	2008(ra) # e56 <exit>
     686:	00000097          	auipc	ra,0x0
     68a:	7c8080e7          	jalr	1992(ra) # e4e <fork>
     68e:	00000097          	auipc	ra,0x0
     692:	7c0080e7          	jalr	1984(ra) # e4e <fork>
     696:	4605                	li	a2,1
     698:	00001597          	auipc	a1,0x1
     69c:	ec058593          	addi	a1,a1,-320 # 1558 <l_free+0x166>
     6a0:	fac42503          	lw	a0,-84(s0)
     6a4:	00000097          	auipc	ra,0x0
     6a8:	7d2080e7          	jalr	2002(ra) # e76 <write>
     6ac:	4785                	li	a5,1
     6ae:	02f51363          	bne	a0,a5,6d4 <go+0x65c>
     6b2:	4605                	li	a2,1
     6b4:	fa040593          	addi	a1,s0,-96
     6b8:	fa842503          	lw	a0,-88(s0)
     6bc:	00000097          	auipc	ra,0x0
     6c0:	7b2080e7          	jalr	1970(ra) # e6e <read>
     6c4:	4785                	li	a5,1
     6c6:	02f51063          	bne	a0,a5,6e6 <go+0x66e>
     6ca:	4501                	li	a0,0
     6cc:	00000097          	auipc	ra,0x0
     6d0:	78a080e7          	jalr	1930(ra) # e56 <exit>
     6d4:	00001517          	auipc	a0,0x1
     6d8:	e8c50513          	addi	a0,a0,-372 # 1560 <l_free+0x16e>
     6dc:	00001097          	auipc	ra,0x1
     6e0:	af4080e7          	jalr	-1292(ra) # 11d0 <printf>
     6e4:	b7f9                	j	6b2 <go+0x63a>
     6e6:	00001517          	auipc	a0,0x1
     6ea:	e9a50513          	addi	a0,a0,-358 # 1580 <l_free+0x18e>
     6ee:	00001097          	auipc	ra,0x1
     6f2:	ae2080e7          	jalr	-1310(ra) # 11d0 <printf>
     6f6:	bfd1                	j	6ca <go+0x652>
     6f8:	00001517          	auipc	a0,0x1
     6fc:	e0850513          	addi	a0,a0,-504 # 1500 <l_free+0x10e>
     700:	00001097          	auipc	ra,0x1
     704:	ad0080e7          	jalr	-1328(ra) # 11d0 <printf>
     708:	4505                	li	a0,1
     70a:	00000097          	auipc	ra,0x0
     70e:	74c080e7          	jalr	1868(ra) # e56 <exit>
     712:	00000097          	auipc	ra,0x0
     716:	73c080e7          	jalr	1852(ra) # e4e <fork>
     71a:	c909                	beqz	a0,72c <go+0x6b4>
     71c:	06054f63          	bltz	a0,79a <go+0x722>
     720:	4501                	li	a0,0
     722:	00000097          	auipc	ra,0x0
     726:	73c080e7          	jalr	1852(ra) # e5e <wait>
     72a:	badd                	j	120 <go+0xa8>
     72c:	00001517          	auipc	a0,0x1
     730:	db450513          	addi	a0,a0,-588 # 14e0 <l_free+0xee>
     734:	00000097          	auipc	ra,0x0
     738:	772080e7          	jalr	1906(ra) # ea6 <unlink>
     73c:	00001517          	auipc	a0,0x1
     740:	da450513          	addi	a0,a0,-604 # 14e0 <l_free+0xee>
     744:	00000097          	auipc	ra,0x0
     748:	77a080e7          	jalr	1914(ra) # ebe <mkdir>
     74c:	00001517          	auipc	a0,0x1
     750:	d9450513          	addi	a0,a0,-620 # 14e0 <l_free+0xee>
     754:	00000097          	auipc	ra,0x0
     758:	772080e7          	jalr	1906(ra) # ec6 <chdir>
     75c:	00001517          	auipc	a0,0x1
     760:	cec50513          	addi	a0,a0,-788 # 1448 <l_free+0x56>
     764:	00000097          	auipc	ra,0x0
     768:	742080e7          	jalr	1858(ra) # ea6 <unlink>
     76c:	20200593          	li	a1,514
     770:	00001517          	auipc	a0,0x1
     774:	de850513          	addi	a0,a0,-536 # 1558 <l_free+0x166>
     778:	00000097          	auipc	ra,0x0
     77c:	71e080e7          	jalr	1822(ra) # e96 <open>
     780:	00001517          	auipc	a0,0x1
     784:	dd850513          	addi	a0,a0,-552 # 1558 <l_free+0x166>
     788:	00000097          	auipc	ra,0x0
     78c:	71e080e7          	jalr	1822(ra) # ea6 <unlink>
     790:	4501                	li	a0,0
     792:	00000097          	auipc	ra,0x0
     796:	6c4080e7          	jalr	1732(ra) # e56 <exit>
     79a:	00001517          	auipc	a0,0x1
     79e:	d6650513          	addi	a0,a0,-666 # 1500 <l_free+0x10e>
     7a2:	00001097          	auipc	ra,0x1
     7a6:	a2e080e7          	jalr	-1490(ra) # 11d0 <printf>
     7aa:	4505                	li	a0,1
     7ac:	00000097          	auipc	ra,0x0
     7b0:	6aa080e7          	jalr	1706(ra) # e56 <exit>
     7b4:	00001517          	auipc	a0,0x1
     7b8:	dec50513          	addi	a0,a0,-532 # 15a0 <l_free+0x1ae>
     7bc:	00000097          	auipc	ra,0x0
     7c0:	6ea080e7          	jalr	1770(ra) # ea6 <unlink>
     7c4:	20200593          	li	a1,514
     7c8:	00001517          	auipc	a0,0x1
     7cc:	dd850513          	addi	a0,a0,-552 # 15a0 <l_free+0x1ae>
     7d0:	00000097          	auipc	ra,0x0
     7d4:	6c6080e7          	jalr	1734(ra) # e96 <open>
     7d8:	8b2a                	mv	s6,a0
     7da:	04054f63          	bltz	a0,838 <go+0x7c0>
     7de:	4605                	li	a2,1
     7e0:	00001597          	auipc	a1,0x1
     7e4:	d7858593          	addi	a1,a1,-648 # 1558 <l_free+0x166>
     7e8:	00000097          	auipc	ra,0x0
     7ec:	68e080e7          	jalr	1678(ra) # e76 <write>
     7f0:	4785                	li	a5,1
     7f2:	06f51063          	bne	a0,a5,852 <go+0x7da>
     7f6:	fa840593          	addi	a1,s0,-88
     7fa:	855a                	mv	a0,s6
     7fc:	00000097          	auipc	ra,0x0
     800:	6b2080e7          	jalr	1714(ra) # eae <fstat>
     804:	e525                	bnez	a0,86c <go+0x7f4>
     806:	fb843583          	ld	a1,-72(s0)
     80a:	4785                	li	a5,1
     80c:	06f59d63          	bne	a1,a5,886 <go+0x80e>
     810:	fac42583          	lw	a1,-84(s0)
     814:	0c800793          	li	a5,200
     818:	08b7e563          	bltu	a5,a1,8a2 <go+0x82a>
     81c:	855a                	mv	a0,s6
     81e:	00000097          	auipc	ra,0x0
     822:	660080e7          	jalr	1632(ra) # e7e <close>
     826:	00001517          	auipc	a0,0x1
     82a:	d7a50513          	addi	a0,a0,-646 # 15a0 <l_free+0x1ae>
     82e:	00000097          	auipc	ra,0x0
     832:	678080e7          	jalr	1656(ra) # ea6 <unlink>
     836:	b0ed                	j	120 <go+0xa8>
     838:	00001517          	auipc	a0,0x1
     83c:	d7050513          	addi	a0,a0,-656 # 15a8 <l_free+0x1b6>
     840:	00001097          	auipc	ra,0x1
     844:	990080e7          	jalr	-1648(ra) # 11d0 <printf>
     848:	4505                	li	a0,1
     84a:	00000097          	auipc	ra,0x0
     84e:	60c080e7          	jalr	1548(ra) # e56 <exit>
     852:	00001517          	auipc	a0,0x1
     856:	d6e50513          	addi	a0,a0,-658 # 15c0 <l_free+0x1ce>
     85a:	00001097          	auipc	ra,0x1
     85e:	976080e7          	jalr	-1674(ra) # 11d0 <printf>
     862:	4505                	li	a0,1
     864:	00000097          	auipc	ra,0x0
     868:	5f2080e7          	jalr	1522(ra) # e56 <exit>
     86c:	00001517          	auipc	a0,0x1
     870:	d6c50513          	addi	a0,a0,-660 # 15d8 <l_free+0x1e6>
     874:	00001097          	auipc	ra,0x1
     878:	95c080e7          	jalr	-1700(ra) # 11d0 <printf>
     87c:	4505                	li	a0,1
     87e:	00000097          	auipc	ra,0x0
     882:	5d8080e7          	jalr	1496(ra) # e56 <exit>
     886:	2581                	sext.w	a1,a1
     888:	00001517          	auipc	a0,0x1
     88c:	d6850513          	addi	a0,a0,-664 # 15f0 <l_free+0x1fe>
     890:	00001097          	auipc	ra,0x1
     894:	940080e7          	jalr	-1728(ra) # 11d0 <printf>
     898:	4505                	li	a0,1
     89a:	00000097          	auipc	ra,0x0
     89e:	5bc080e7          	jalr	1468(ra) # e56 <exit>
     8a2:	00001517          	auipc	a0,0x1
     8a6:	d7650513          	addi	a0,a0,-650 # 1618 <l_free+0x226>
     8aa:	00001097          	auipc	ra,0x1
     8ae:	926080e7          	jalr	-1754(ra) # 11d0 <printf>
     8b2:	4505                	li	a0,1
     8b4:	00000097          	auipc	ra,0x0
     8b8:	5a2080e7          	jalr	1442(ra) # e56 <exit>
     8bc:	00001597          	auipc	a1,0x1
     8c0:	c8458593          	addi	a1,a1,-892 # 1540 <l_free+0x14e>
     8c4:	4509                	li	a0,2
     8c6:	00001097          	auipc	ra,0x1
     8ca:	8dc080e7          	jalr	-1828(ra) # 11a2 <fprintf>
     8ce:	4505                	li	a0,1
     8d0:	00000097          	auipc	ra,0x0
     8d4:	586080e7          	jalr	1414(ra) # e56 <exit>
     8d8:	00001597          	auipc	a1,0x1
     8dc:	c6858593          	addi	a1,a1,-920 # 1540 <l_free+0x14e>
     8e0:	4509                	li	a0,2
     8e2:	00001097          	auipc	ra,0x1
     8e6:	8c0080e7          	jalr	-1856(ra) # 11a2 <fprintf>
     8ea:	4505                	li	a0,1
     8ec:	00000097          	auipc	ra,0x0
     8f0:	56a080e7          	jalr	1386(ra) # e56 <exit>
     8f4:	fa042503          	lw	a0,-96(s0)
     8f8:	00000097          	auipc	ra,0x0
     8fc:	586080e7          	jalr	1414(ra) # e7e <close>
     900:	fa442503          	lw	a0,-92(s0)
     904:	00000097          	auipc	ra,0x0
     908:	57a080e7          	jalr	1402(ra) # e7e <close>
     90c:	f9842503          	lw	a0,-104(s0)
     910:	00000097          	auipc	ra,0x0
     914:	56e080e7          	jalr	1390(ra) # e7e <close>
     918:	4505                	li	a0,1
     91a:	00000097          	auipc	ra,0x0
     91e:	564080e7          	jalr	1380(ra) # e7e <close>
     922:	f9c42503          	lw	a0,-100(s0)
     926:	00000097          	auipc	ra,0x0
     92a:	5a8080e7          	jalr	1448(ra) # ece <dup>
     92e:	4785                	li	a5,1
     930:	02f50063          	beq	a0,a5,950 <go+0x8d8>
     934:	00001597          	auipc	a1,0x1
     938:	d0c58593          	addi	a1,a1,-756 # 1640 <l_free+0x24e>
     93c:	4509                	li	a0,2
     93e:	00001097          	auipc	ra,0x1
     942:	864080e7          	jalr	-1948(ra) # 11a2 <fprintf>
     946:	4505                	li	a0,1
     948:	00000097          	auipc	ra,0x0
     94c:	50e080e7          	jalr	1294(ra) # e56 <exit>
     950:	f9c42503          	lw	a0,-100(s0)
     954:	00000097          	auipc	ra,0x0
     958:	52a080e7          	jalr	1322(ra) # e7e <close>
     95c:	00001797          	auipc	a5,0x1
     960:	cfc78793          	addi	a5,a5,-772 # 1658 <l_free+0x266>
     964:	faf43423          	sd	a5,-88(s0)
     968:	00001797          	auipc	a5,0x1
     96c:	cf878793          	addi	a5,a5,-776 # 1660 <l_free+0x26e>
     970:	faf43823          	sd	a5,-80(s0)
     974:	fa043c23          	sd	zero,-72(s0)
     978:	fa840593          	addi	a1,s0,-88
     97c:	00001517          	auipc	a0,0x1
     980:	cec50513          	addi	a0,a0,-788 # 1668 <l_free+0x276>
     984:	00000097          	auipc	ra,0x0
     988:	50a080e7          	jalr	1290(ra) # e8e <exec>
     98c:	00001597          	auipc	a1,0x1
     990:	cec58593          	addi	a1,a1,-788 # 1678 <l_free+0x286>
     994:	4509                	li	a0,2
     996:	00001097          	auipc	ra,0x1
     99a:	80c080e7          	jalr	-2036(ra) # 11a2 <fprintf>
     99e:	4509                	li	a0,2
     9a0:	00000097          	auipc	ra,0x0
     9a4:	4b6080e7          	jalr	1206(ra) # e56 <exit>
     9a8:	00001597          	auipc	a1,0x1
     9ac:	b5858593          	addi	a1,a1,-1192 # 1500 <l_free+0x10e>
     9b0:	4509                	li	a0,2
     9b2:	00000097          	auipc	ra,0x0
     9b6:	7f0080e7          	jalr	2032(ra) # 11a2 <fprintf>
     9ba:	450d                	li	a0,3
     9bc:	00000097          	auipc	ra,0x0
     9c0:	49a080e7          	jalr	1178(ra) # e56 <exit>
     9c4:	f9c42503          	lw	a0,-100(s0)
     9c8:	00000097          	auipc	ra,0x0
     9cc:	4b6080e7          	jalr	1206(ra) # e7e <close>
     9d0:	fa042503          	lw	a0,-96(s0)
     9d4:	00000097          	auipc	ra,0x0
     9d8:	4aa080e7          	jalr	1194(ra) # e7e <close>
     9dc:	4501                	li	a0,0
     9de:	00000097          	auipc	ra,0x0
     9e2:	4a0080e7          	jalr	1184(ra) # e7e <close>
     9e6:	f9842503          	lw	a0,-104(s0)
     9ea:	00000097          	auipc	ra,0x0
     9ee:	4e4080e7          	jalr	1252(ra) # ece <dup>
     9f2:	cd19                	beqz	a0,a10 <go+0x998>
     9f4:	00001597          	auipc	a1,0x1
     9f8:	c4c58593          	addi	a1,a1,-948 # 1640 <l_free+0x24e>
     9fc:	4509                	li	a0,2
     9fe:	00000097          	auipc	ra,0x0
     a02:	7a4080e7          	jalr	1956(ra) # 11a2 <fprintf>
     a06:	4511                	li	a0,4
     a08:	00000097          	auipc	ra,0x0
     a0c:	44e080e7          	jalr	1102(ra) # e56 <exit>
     a10:	f9842503          	lw	a0,-104(s0)
     a14:	00000097          	auipc	ra,0x0
     a18:	46a080e7          	jalr	1130(ra) # e7e <close>
     a1c:	4505                	li	a0,1
     a1e:	00000097          	auipc	ra,0x0
     a22:	460080e7          	jalr	1120(ra) # e7e <close>
     a26:	fa442503          	lw	a0,-92(s0)
     a2a:	00000097          	auipc	ra,0x0
     a2e:	4a4080e7          	jalr	1188(ra) # ece <dup>
     a32:	4785                	li	a5,1
     a34:	02f50063          	beq	a0,a5,a54 <go+0x9dc>
     a38:	00001597          	auipc	a1,0x1
     a3c:	c0858593          	addi	a1,a1,-1016 # 1640 <l_free+0x24e>
     a40:	4509                	li	a0,2
     a42:	00000097          	auipc	ra,0x0
     a46:	760080e7          	jalr	1888(ra) # 11a2 <fprintf>
     a4a:	4515                	li	a0,5
     a4c:	00000097          	auipc	ra,0x0
     a50:	40a080e7          	jalr	1034(ra) # e56 <exit>
     a54:	fa442503          	lw	a0,-92(s0)
     a58:	00000097          	auipc	ra,0x0
     a5c:	426080e7          	jalr	1062(ra) # e7e <close>
     a60:	00001797          	auipc	a5,0x1
     a64:	c3078793          	addi	a5,a5,-976 # 1690 <l_free+0x29e>
     a68:	faf43423          	sd	a5,-88(s0)
     a6c:	fa043823          	sd	zero,-80(s0)
     a70:	fa840593          	addi	a1,s0,-88
     a74:	00001517          	auipc	a0,0x1
     a78:	c2450513          	addi	a0,a0,-988 # 1698 <l_free+0x2a6>
     a7c:	00000097          	auipc	ra,0x0
     a80:	412080e7          	jalr	1042(ra) # e8e <exec>
     a84:	00001597          	auipc	a1,0x1
     a88:	c1c58593          	addi	a1,a1,-996 # 16a0 <l_free+0x2ae>
     a8c:	4509                	li	a0,2
     a8e:	00000097          	auipc	ra,0x0
     a92:	714080e7          	jalr	1812(ra) # 11a2 <fprintf>
     a96:	4519                	li	a0,6
     a98:	00000097          	auipc	ra,0x0
     a9c:	3be080e7          	jalr	958(ra) # e56 <exit>
     aa0:	00001597          	auipc	a1,0x1
     aa4:	a6058593          	addi	a1,a1,-1440 # 1500 <l_free+0x10e>
     aa8:	4509                	li	a0,2
     aaa:	00000097          	auipc	ra,0x0
     aae:	6f8080e7          	jalr	1784(ra) # 11a2 <fprintf>
     ab2:	451d                	li	a0,7
     ab4:	00000097          	auipc	ra,0x0
     ab8:	3a2080e7          	jalr	930(ra) # e56 <exit>

0000000000000abc <iter>:
     abc:	7179                	addi	sp,sp,-48
     abe:	f406                	sd	ra,40(sp)
     ac0:	f022                	sd	s0,32(sp)
     ac2:	ec26                	sd	s1,24(sp)
     ac4:	e84a                	sd	s2,16(sp)
     ac6:	1800                	addi	s0,sp,48
     ac8:	00001517          	auipc	a0,0x1
     acc:	a1850513          	addi	a0,a0,-1512 # 14e0 <l_free+0xee>
     ad0:	00000097          	auipc	ra,0x0
     ad4:	3d6080e7          	jalr	982(ra) # ea6 <unlink>
     ad8:	00001517          	auipc	a0,0x1
     adc:	9b850513          	addi	a0,a0,-1608 # 1490 <l_free+0x9e>
     ae0:	00000097          	auipc	ra,0x0
     ae4:	3c6080e7          	jalr	966(ra) # ea6 <unlink>
     ae8:	00000097          	auipc	ra,0x0
     aec:	366080e7          	jalr	870(ra) # e4e <fork>
     af0:	00054e63          	bltz	a0,b0c <iter+0x50>
     af4:	84aa                	mv	s1,a0
     af6:	e905                	bnez	a0,b26 <iter+0x6a>
     af8:	47fd                	li	a5,31
     afa:	00001717          	auipc	a4,0x1
     afe:	c4f73f23          	sd	a5,-930(a4) # 1758 <rand_next>
     b02:	4501                	li	a0,0
     b04:	fffff097          	auipc	ra,0xfffff
     b08:	574080e7          	jalr	1396(ra) # 78 <go>
     b0c:	00001517          	auipc	a0,0x1
     b10:	9f450513          	addi	a0,a0,-1548 # 1500 <l_free+0x10e>
     b14:	00000097          	auipc	ra,0x0
     b18:	6bc080e7          	jalr	1724(ra) # 11d0 <printf>
     b1c:	4505                	li	a0,1
     b1e:	00000097          	auipc	ra,0x0
     b22:	338080e7          	jalr	824(ra) # e56 <exit>
     b26:	00000097          	auipc	ra,0x0
     b2a:	328080e7          	jalr	808(ra) # e4e <fork>
     b2e:	892a                	mv	s2,a0
     b30:	00054f63          	bltz	a0,b4e <iter+0x92>
     b34:	e915                	bnez	a0,b68 <iter+0xac>
     b36:	6789                	lui	a5,0x2
     b38:	c0978793          	addi	a5,a5,-1015 # 1c09 <__BSS_END__+0x99>
     b3c:	00001717          	auipc	a4,0x1
     b40:	c0f73e23          	sd	a5,-996(a4) # 1758 <rand_next>
     b44:	4505                	li	a0,1
     b46:	fffff097          	auipc	ra,0xfffff
     b4a:	532080e7          	jalr	1330(ra) # 78 <go>
     b4e:	00001517          	auipc	a0,0x1
     b52:	9b250513          	addi	a0,a0,-1614 # 1500 <l_free+0x10e>
     b56:	00000097          	auipc	ra,0x0
     b5a:	67a080e7          	jalr	1658(ra) # 11d0 <printf>
     b5e:	4505                	li	a0,1
     b60:	00000097          	auipc	ra,0x0
     b64:	2f6080e7          	jalr	758(ra) # e56 <exit>
     b68:	57fd                	li	a5,-1
     b6a:	fcf42e23          	sw	a5,-36(s0)
     b6e:	fdc40513          	addi	a0,s0,-36
     b72:	00000097          	auipc	ra,0x0
     b76:	2ec080e7          	jalr	748(ra) # e5e <wait>
     b7a:	fdc42783          	lw	a5,-36(s0)
     b7e:	ef99                	bnez	a5,b9c <iter+0xe0>
     b80:	57fd                	li	a5,-1
     b82:	fcf42c23          	sw	a5,-40(s0)
     b86:	fd840513          	addi	a0,s0,-40
     b8a:	00000097          	auipc	ra,0x0
     b8e:	2d4080e7          	jalr	724(ra) # e5e <wait>
     b92:	4501                	li	a0,0
     b94:	00000097          	auipc	ra,0x0
     b98:	2c2080e7          	jalr	706(ra) # e56 <exit>
     b9c:	8526                	mv	a0,s1
     b9e:	00000097          	auipc	ra,0x0
     ba2:	2e8080e7          	jalr	744(ra) # e86 <kill>
     ba6:	854a                	mv	a0,s2
     ba8:	00000097          	auipc	ra,0x0
     bac:	2de080e7          	jalr	734(ra) # e86 <kill>
     bb0:	bfc1                	j	b80 <iter+0xc4>

0000000000000bb2 <main>:
     bb2:	1141                	addi	sp,sp,-16
     bb4:	e406                	sd	ra,8(sp)
     bb6:	e022                	sd	s0,0(sp)
     bb8:	0800                	addi	s0,sp,16
     bba:	a811                	j	bce <main+0x1c>
     bbc:	00000097          	auipc	ra,0x0
     bc0:	f00080e7          	jalr	-256(ra) # abc <iter>
     bc4:	4551                	li	a0,20
     bc6:	00000097          	auipc	ra,0x0
     bca:	320080e7          	jalr	800(ra) # ee6 <sleep>
     bce:	00000097          	auipc	ra,0x0
     bd2:	280080e7          	jalr	640(ra) # e4e <fork>
     bd6:	d17d                	beqz	a0,bbc <main+0xa>
     bd8:	fea056e3          	blez	a0,bc4 <main+0x12>
     bdc:	4501                	li	a0,0
     bde:	00000097          	auipc	ra,0x0
     be2:	280080e7          	jalr	640(ra) # e5e <wait>
     be6:	bff9                	j	bc4 <main+0x12>

0000000000000be8 <strcpy>:
     be8:	1141                	addi	sp,sp,-16
     bea:	e422                	sd	s0,8(sp)
     bec:	0800                	addi	s0,sp,16
     bee:	87aa                	mv	a5,a0
     bf0:	0585                	addi	a1,a1,1
     bf2:	0785                	addi	a5,a5,1
     bf4:	fff5c703          	lbu	a4,-1(a1)
     bf8:	fee78fa3          	sb	a4,-1(a5)
     bfc:	fb75                	bnez	a4,bf0 <strcpy+0x8>
     bfe:	6422                	ld	s0,8(sp)
     c00:	0141                	addi	sp,sp,16
     c02:	8082                	ret

0000000000000c04 <strcmp>:
     c04:	1141                	addi	sp,sp,-16
     c06:	e422                	sd	s0,8(sp)
     c08:	0800                	addi	s0,sp,16
     c0a:	00054783          	lbu	a5,0(a0)
     c0e:	cb91                	beqz	a5,c22 <strcmp+0x1e>
     c10:	0005c703          	lbu	a4,0(a1)
     c14:	00f71763          	bne	a4,a5,c22 <strcmp+0x1e>
     c18:	0505                	addi	a0,a0,1
     c1a:	0585                	addi	a1,a1,1
     c1c:	00054783          	lbu	a5,0(a0)
     c20:	fbe5                	bnez	a5,c10 <strcmp+0xc>
     c22:	0005c503          	lbu	a0,0(a1)
     c26:	40a7853b          	subw	a0,a5,a0
     c2a:	6422                	ld	s0,8(sp)
     c2c:	0141                	addi	sp,sp,16
     c2e:	8082                	ret

0000000000000c30 <strlen>:
     c30:	1141                	addi	sp,sp,-16
     c32:	e422                	sd	s0,8(sp)
     c34:	0800                	addi	s0,sp,16
     c36:	00054783          	lbu	a5,0(a0)
     c3a:	cf91                	beqz	a5,c56 <strlen+0x26>
     c3c:	0505                	addi	a0,a0,1
     c3e:	87aa                	mv	a5,a0
     c40:	4685                	li	a3,1
     c42:	9e89                	subw	a3,a3,a0
     c44:	00f6853b          	addw	a0,a3,a5
     c48:	0785                	addi	a5,a5,1
     c4a:	fff7c703          	lbu	a4,-1(a5)
     c4e:	fb7d                	bnez	a4,c44 <strlen+0x14>
     c50:	6422                	ld	s0,8(sp)
     c52:	0141                	addi	sp,sp,16
     c54:	8082                	ret
     c56:	4501                	li	a0,0
     c58:	bfe5                	j	c50 <strlen+0x20>

0000000000000c5a <memset>:
     c5a:	1141                	addi	sp,sp,-16
     c5c:	e422                	sd	s0,8(sp)
     c5e:	0800                	addi	s0,sp,16
     c60:	ca19                	beqz	a2,c76 <memset+0x1c>
     c62:	87aa                	mv	a5,a0
     c64:	1602                	slli	a2,a2,0x20
     c66:	9201                	srli	a2,a2,0x20
     c68:	00a60733          	add	a4,a2,a0
     c6c:	00b78023          	sb	a1,0(a5)
     c70:	0785                	addi	a5,a5,1
     c72:	fee79de3          	bne	a5,a4,c6c <memset+0x12>
     c76:	6422                	ld	s0,8(sp)
     c78:	0141                	addi	sp,sp,16
     c7a:	8082                	ret

0000000000000c7c <strchr>:
     c7c:	1141                	addi	sp,sp,-16
     c7e:	e422                	sd	s0,8(sp)
     c80:	0800                	addi	s0,sp,16
     c82:	00054783          	lbu	a5,0(a0)
     c86:	cb99                	beqz	a5,c9c <strchr+0x20>
     c88:	00f58763          	beq	a1,a5,c96 <strchr+0x1a>
     c8c:	0505                	addi	a0,a0,1
     c8e:	00054783          	lbu	a5,0(a0)
     c92:	fbfd                	bnez	a5,c88 <strchr+0xc>
     c94:	4501                	li	a0,0
     c96:	6422                	ld	s0,8(sp)
     c98:	0141                	addi	sp,sp,16
     c9a:	8082                	ret
     c9c:	4501                	li	a0,0
     c9e:	bfe5                	j	c96 <strchr+0x1a>

0000000000000ca0 <gets>:
     ca0:	711d                	addi	sp,sp,-96
     ca2:	ec86                	sd	ra,88(sp)
     ca4:	e8a2                	sd	s0,80(sp)
     ca6:	e4a6                	sd	s1,72(sp)
     ca8:	e0ca                	sd	s2,64(sp)
     caa:	fc4e                	sd	s3,56(sp)
     cac:	f852                	sd	s4,48(sp)
     cae:	f456                	sd	s5,40(sp)
     cb0:	f05a                	sd	s6,32(sp)
     cb2:	ec5e                	sd	s7,24(sp)
     cb4:	1080                	addi	s0,sp,96
     cb6:	8baa                	mv	s7,a0
     cb8:	8a2e                	mv	s4,a1
     cba:	892a                	mv	s2,a0
     cbc:	4481                	li	s1,0
     cbe:	4aa9                	li	s5,10
     cc0:	4b35                	li	s6,13
     cc2:	89a6                	mv	s3,s1
     cc4:	2485                	addiw	s1,s1,1
     cc6:	0344d863          	bge	s1,s4,cf6 <gets+0x56>
     cca:	4605                	li	a2,1
     ccc:	faf40593          	addi	a1,s0,-81
     cd0:	4501                	li	a0,0
     cd2:	00000097          	auipc	ra,0x0
     cd6:	19c080e7          	jalr	412(ra) # e6e <read>
     cda:	00a05e63          	blez	a0,cf6 <gets+0x56>
     cde:	faf44783          	lbu	a5,-81(s0)
     ce2:	00f90023          	sb	a5,0(s2)
     ce6:	01578763          	beq	a5,s5,cf4 <gets+0x54>
     cea:	0905                	addi	s2,s2,1
     cec:	fd679be3          	bne	a5,s6,cc2 <gets+0x22>
     cf0:	89a6                	mv	s3,s1
     cf2:	a011                	j	cf6 <gets+0x56>
     cf4:	89a6                	mv	s3,s1
     cf6:	99de                	add	s3,s3,s7
     cf8:	00098023          	sb	zero,0(s3)
     cfc:	855e                	mv	a0,s7
     cfe:	60e6                	ld	ra,88(sp)
     d00:	6446                	ld	s0,80(sp)
     d02:	64a6                	ld	s1,72(sp)
     d04:	6906                	ld	s2,64(sp)
     d06:	79e2                	ld	s3,56(sp)
     d08:	7a42                	ld	s4,48(sp)
     d0a:	7aa2                	ld	s5,40(sp)
     d0c:	7b02                	ld	s6,32(sp)
     d0e:	6be2                	ld	s7,24(sp)
     d10:	6125                	addi	sp,sp,96
     d12:	8082                	ret

0000000000000d14 <stat>:
     d14:	1101                	addi	sp,sp,-32
     d16:	ec06                	sd	ra,24(sp)
     d18:	e822                	sd	s0,16(sp)
     d1a:	e426                	sd	s1,8(sp)
     d1c:	e04a                	sd	s2,0(sp)
     d1e:	1000                	addi	s0,sp,32
     d20:	892e                	mv	s2,a1
     d22:	4581                	li	a1,0
     d24:	00000097          	auipc	ra,0x0
     d28:	172080e7          	jalr	370(ra) # e96 <open>
     d2c:	02054563          	bltz	a0,d56 <stat+0x42>
     d30:	84aa                	mv	s1,a0
     d32:	85ca                	mv	a1,s2
     d34:	00000097          	auipc	ra,0x0
     d38:	17a080e7          	jalr	378(ra) # eae <fstat>
     d3c:	892a                	mv	s2,a0
     d3e:	8526                	mv	a0,s1
     d40:	00000097          	auipc	ra,0x0
     d44:	13e080e7          	jalr	318(ra) # e7e <close>
     d48:	854a                	mv	a0,s2
     d4a:	60e2                	ld	ra,24(sp)
     d4c:	6442                	ld	s0,16(sp)
     d4e:	64a2                	ld	s1,8(sp)
     d50:	6902                	ld	s2,0(sp)
     d52:	6105                	addi	sp,sp,32
     d54:	8082                	ret
     d56:	597d                	li	s2,-1
     d58:	bfc5                	j	d48 <stat+0x34>

0000000000000d5a <atoi>:
     d5a:	1141                	addi	sp,sp,-16
     d5c:	e422                	sd	s0,8(sp)
     d5e:	0800                	addi	s0,sp,16
     d60:	00054603          	lbu	a2,0(a0)
     d64:	fd06079b          	addiw	a5,a2,-48
     d68:	0ff7f793          	zext.b	a5,a5
     d6c:	4725                	li	a4,9
     d6e:	02f76963          	bltu	a4,a5,da0 <atoi+0x46>
     d72:	86aa                	mv	a3,a0
     d74:	4501                	li	a0,0
     d76:	45a5                	li	a1,9
     d78:	0685                	addi	a3,a3,1
     d7a:	0025179b          	slliw	a5,a0,0x2
     d7e:	9fa9                	addw	a5,a5,a0
     d80:	0017979b          	slliw	a5,a5,0x1
     d84:	9fb1                	addw	a5,a5,a2
     d86:	fd07851b          	addiw	a0,a5,-48
     d8a:	0006c603          	lbu	a2,0(a3)
     d8e:	fd06071b          	addiw	a4,a2,-48
     d92:	0ff77713          	zext.b	a4,a4
     d96:	fee5f1e3          	bgeu	a1,a4,d78 <atoi+0x1e>
     d9a:	6422                	ld	s0,8(sp)
     d9c:	0141                	addi	sp,sp,16
     d9e:	8082                	ret
     da0:	4501                	li	a0,0
     da2:	bfe5                	j	d9a <atoi+0x40>

0000000000000da4 <memmove>:
     da4:	1141                	addi	sp,sp,-16
     da6:	e422                	sd	s0,8(sp)
     da8:	0800                	addi	s0,sp,16
     daa:	02b57463          	bgeu	a0,a1,dd2 <memmove+0x2e>
     dae:	00c05f63          	blez	a2,dcc <memmove+0x28>
     db2:	1602                	slli	a2,a2,0x20
     db4:	9201                	srli	a2,a2,0x20
     db6:	00c507b3          	add	a5,a0,a2
     dba:	872a                	mv	a4,a0
     dbc:	0585                	addi	a1,a1,1
     dbe:	0705                	addi	a4,a4,1
     dc0:	fff5c683          	lbu	a3,-1(a1)
     dc4:	fed70fa3          	sb	a3,-1(a4)
     dc8:	fee79ae3          	bne	a5,a4,dbc <memmove+0x18>
     dcc:	6422                	ld	s0,8(sp)
     dce:	0141                	addi	sp,sp,16
     dd0:	8082                	ret
     dd2:	00c50733          	add	a4,a0,a2
     dd6:	95b2                	add	a1,a1,a2
     dd8:	fec05ae3          	blez	a2,dcc <memmove+0x28>
     ddc:	fff6079b          	addiw	a5,a2,-1
     de0:	1782                	slli	a5,a5,0x20
     de2:	9381                	srli	a5,a5,0x20
     de4:	fff7c793          	not	a5,a5
     de8:	97ba                	add	a5,a5,a4
     dea:	15fd                	addi	a1,a1,-1
     dec:	177d                	addi	a4,a4,-1
     dee:	0005c683          	lbu	a3,0(a1)
     df2:	00d70023          	sb	a3,0(a4)
     df6:	fee79ae3          	bne	a5,a4,dea <memmove+0x46>
     dfa:	bfc9                	j	dcc <memmove+0x28>

0000000000000dfc <memcmp>:
     dfc:	1141                	addi	sp,sp,-16
     dfe:	e422                	sd	s0,8(sp)
     e00:	0800                	addi	s0,sp,16
     e02:	ca05                	beqz	a2,e32 <memcmp+0x36>
     e04:	fff6069b          	addiw	a3,a2,-1
     e08:	1682                	slli	a3,a3,0x20
     e0a:	9281                	srli	a3,a3,0x20
     e0c:	0685                	addi	a3,a3,1
     e0e:	96aa                	add	a3,a3,a0
     e10:	00054783          	lbu	a5,0(a0)
     e14:	0005c703          	lbu	a4,0(a1)
     e18:	00e79863          	bne	a5,a4,e28 <memcmp+0x2c>
     e1c:	0505                	addi	a0,a0,1
     e1e:	0585                	addi	a1,a1,1
     e20:	fed518e3          	bne	a0,a3,e10 <memcmp+0x14>
     e24:	4501                	li	a0,0
     e26:	a019                	j	e2c <memcmp+0x30>
     e28:	40e7853b          	subw	a0,a5,a4
     e2c:	6422                	ld	s0,8(sp)
     e2e:	0141                	addi	sp,sp,16
     e30:	8082                	ret
     e32:	4501                	li	a0,0
     e34:	bfe5                	j	e2c <memcmp+0x30>

0000000000000e36 <memcpy>:
     e36:	1141                	addi	sp,sp,-16
     e38:	e406                	sd	ra,8(sp)
     e3a:	e022                	sd	s0,0(sp)
     e3c:	0800                	addi	s0,sp,16
     e3e:	00000097          	auipc	ra,0x0
     e42:	f66080e7          	jalr	-154(ra) # da4 <memmove>
     e46:	60a2                	ld	ra,8(sp)
     e48:	6402                	ld	s0,0(sp)
     e4a:	0141                	addi	sp,sp,16
     e4c:	8082                	ret

0000000000000e4e <fork>:
     e4e:	4885                	li	a7,1
     e50:	00000073          	ecall
     e54:	8082                	ret

0000000000000e56 <exit>:
     e56:	4889                	li	a7,2
     e58:	00000073          	ecall
     e5c:	8082                	ret

0000000000000e5e <wait>:
     e5e:	488d                	li	a7,3
     e60:	00000073          	ecall
     e64:	8082                	ret

0000000000000e66 <pipe>:
     e66:	4891                	li	a7,4
     e68:	00000073          	ecall
     e6c:	8082                	ret

0000000000000e6e <read>:
     e6e:	4895                	li	a7,5
     e70:	00000073          	ecall
     e74:	8082                	ret

0000000000000e76 <write>:
     e76:	48c1                	li	a7,16
     e78:	00000073          	ecall
     e7c:	8082                	ret

0000000000000e7e <close>:
     e7e:	48d5                	li	a7,21
     e80:	00000073          	ecall
     e84:	8082                	ret

0000000000000e86 <kill>:
     e86:	4899                	li	a7,6
     e88:	00000073          	ecall
     e8c:	8082                	ret

0000000000000e8e <exec>:
     e8e:	489d                	li	a7,7
     e90:	00000073          	ecall
     e94:	8082                	ret

0000000000000e96 <open>:
     e96:	48bd                	li	a7,15
     e98:	00000073          	ecall
     e9c:	8082                	ret

0000000000000e9e <mknod>:
     e9e:	48c5                	li	a7,17
     ea0:	00000073          	ecall
     ea4:	8082                	ret

0000000000000ea6 <unlink>:
     ea6:	48c9                	li	a7,18
     ea8:	00000073          	ecall
     eac:	8082                	ret

0000000000000eae <fstat>:
     eae:	48a1                	li	a7,8
     eb0:	00000073          	ecall
     eb4:	8082                	ret

0000000000000eb6 <link>:
     eb6:	48cd                	li	a7,19
     eb8:	00000073          	ecall
     ebc:	8082                	ret

0000000000000ebe <mkdir>:
     ebe:	48d1                	li	a7,20
     ec0:	00000073          	ecall
     ec4:	8082                	ret

0000000000000ec6 <chdir>:
     ec6:	48a5                	li	a7,9
     ec8:	00000073          	ecall
     ecc:	8082                	ret

0000000000000ece <dup>:
     ece:	48a9                	li	a7,10
     ed0:	00000073          	ecall
     ed4:	8082                	ret

0000000000000ed6 <getpid>:
     ed6:	48ad                	li	a7,11
     ed8:	00000073          	ecall
     edc:	8082                	ret

0000000000000ede <sbrk>:
     ede:	48b1                	li	a7,12
     ee0:	00000073          	ecall
     ee4:	8082                	ret

0000000000000ee6 <sleep>:
     ee6:	48b5                	li	a7,13
     ee8:	00000073          	ecall
     eec:	8082                	ret

0000000000000eee <uptime>:
     eee:	48b9                	li	a7,14
     ef0:	00000073          	ecall
     ef4:	8082                	ret

0000000000000ef6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     ef6:	1101                	addi	sp,sp,-32
     ef8:	ec06                	sd	ra,24(sp)
     efa:	e822                	sd	s0,16(sp)
     efc:	1000                	addi	s0,sp,32
     efe:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     f02:	4605                	li	a2,1
     f04:	fef40593          	addi	a1,s0,-17
     f08:	00000097          	auipc	ra,0x0
     f0c:	f6e080e7          	jalr	-146(ra) # e76 <write>
}
     f10:	60e2                	ld	ra,24(sp)
     f12:	6442                	ld	s0,16(sp)
     f14:	6105                	addi	sp,sp,32
     f16:	8082                	ret

0000000000000f18 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     f18:	7139                	addi	sp,sp,-64
     f1a:	fc06                	sd	ra,56(sp)
     f1c:	f822                	sd	s0,48(sp)
     f1e:	f426                	sd	s1,40(sp)
     f20:	f04a                	sd	s2,32(sp)
     f22:	ec4e                	sd	s3,24(sp)
     f24:	0080                	addi	s0,sp,64
     f26:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     f28:	c299                	beqz	a3,f2e <printint+0x16>
     f2a:	0805c963          	bltz	a1,fbc <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     f2e:	2581                	sext.w	a1,a1
  neg = 0;
     f30:	4881                	li	a7,0
     f32:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     f36:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     f38:	2601                	sext.w	a2,a2
     f3a:	00001517          	auipc	a0,0x1
     f3e:	80650513          	addi	a0,a0,-2042 # 1740 <digits>
     f42:	883a                	mv	a6,a4
     f44:	2705                	addiw	a4,a4,1
     f46:	02c5f7bb          	remuw	a5,a1,a2
     f4a:	1782                	slli	a5,a5,0x20
     f4c:	9381                	srli	a5,a5,0x20
     f4e:	97aa                	add	a5,a5,a0
     f50:	0007c783          	lbu	a5,0(a5)
     f54:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     f58:	0005879b          	sext.w	a5,a1
     f5c:	02c5d5bb          	divuw	a1,a1,a2
     f60:	0685                	addi	a3,a3,1
     f62:	fec7f0e3          	bgeu	a5,a2,f42 <printint+0x2a>
  if(neg)
     f66:	00088c63          	beqz	a7,f7e <printint+0x66>
    buf[i++] = '-';
     f6a:	fd070793          	addi	a5,a4,-48
     f6e:	00878733          	add	a4,a5,s0
     f72:	02d00793          	li	a5,45
     f76:	fef70823          	sb	a5,-16(a4)
     f7a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     f7e:	02e05863          	blez	a4,fae <printint+0x96>
     f82:	fc040793          	addi	a5,s0,-64
     f86:	00e78933          	add	s2,a5,a4
     f8a:	fff78993          	addi	s3,a5,-1
     f8e:	99ba                	add	s3,s3,a4
     f90:	377d                	addiw	a4,a4,-1
     f92:	1702                	slli	a4,a4,0x20
     f94:	9301                	srli	a4,a4,0x20
     f96:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     f9a:	fff94583          	lbu	a1,-1(s2)
     f9e:	8526                	mv	a0,s1
     fa0:	00000097          	auipc	ra,0x0
     fa4:	f56080e7          	jalr	-170(ra) # ef6 <putc>
  while(--i >= 0)
     fa8:	197d                	addi	s2,s2,-1
     faa:	ff3918e3          	bne	s2,s3,f9a <printint+0x82>
}
     fae:	70e2                	ld	ra,56(sp)
     fb0:	7442                	ld	s0,48(sp)
     fb2:	74a2                	ld	s1,40(sp)
     fb4:	7902                	ld	s2,32(sp)
     fb6:	69e2                	ld	s3,24(sp)
     fb8:	6121                	addi	sp,sp,64
     fba:	8082                	ret
    x = -xx;
     fbc:	40b005bb          	negw	a1,a1
    neg = 1;
     fc0:	4885                	li	a7,1
    x = -xx;
     fc2:	bf85                	j	f32 <printint+0x1a>

0000000000000fc4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     fc4:	7119                	addi	sp,sp,-128
     fc6:	fc86                	sd	ra,120(sp)
     fc8:	f8a2                	sd	s0,112(sp)
     fca:	f4a6                	sd	s1,104(sp)
     fcc:	f0ca                	sd	s2,96(sp)
     fce:	ecce                	sd	s3,88(sp)
     fd0:	e8d2                	sd	s4,80(sp)
     fd2:	e4d6                	sd	s5,72(sp)
     fd4:	e0da                	sd	s6,64(sp)
     fd6:	fc5e                	sd	s7,56(sp)
     fd8:	f862                	sd	s8,48(sp)
     fda:	f466                	sd	s9,40(sp)
     fdc:	f06a                	sd	s10,32(sp)
     fde:	ec6e                	sd	s11,24(sp)
     fe0:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     fe2:	0005c903          	lbu	s2,0(a1)
     fe6:	18090f63          	beqz	s2,1184 <vprintf+0x1c0>
     fea:	8aaa                	mv	s5,a0
     fec:	8b32                	mv	s6,a2
     fee:	00158493          	addi	s1,a1,1
  state = 0;
     ff2:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     ff4:	02500a13          	li	s4,37
     ff8:	4c55                	li	s8,21
     ffa:	00000c97          	auipc	s9,0x0
     ffe:	6eec8c93          	addi	s9,s9,1774 # 16e8 <l_free+0x2f6>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1002:	02800d93          	li	s11,40
  putc(fd, 'x');
    1006:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1008:	00000b97          	auipc	s7,0x0
    100c:	738b8b93          	addi	s7,s7,1848 # 1740 <digits>
    1010:	a839                	j	102e <vprintf+0x6a>
        putc(fd, c);
    1012:	85ca                	mv	a1,s2
    1014:	8556                	mv	a0,s5
    1016:	00000097          	auipc	ra,0x0
    101a:	ee0080e7          	jalr	-288(ra) # ef6 <putc>
    101e:	a019                	j	1024 <vprintf+0x60>
    } else if(state == '%'){
    1020:	01498d63          	beq	s3,s4,103a <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
    1024:	0485                	addi	s1,s1,1
    1026:	fff4c903          	lbu	s2,-1(s1)
    102a:	14090d63          	beqz	s2,1184 <vprintf+0x1c0>
    if(state == 0){
    102e:	fe0999e3          	bnez	s3,1020 <vprintf+0x5c>
      if(c == '%'){
    1032:	ff4910e3          	bne	s2,s4,1012 <vprintf+0x4e>
        state = '%';
    1036:	89d2                	mv	s3,s4
    1038:	b7f5                	j	1024 <vprintf+0x60>
      if(c == 'd'){
    103a:	11490c63          	beq	s2,s4,1152 <vprintf+0x18e>
    103e:	f9d9079b          	addiw	a5,s2,-99
    1042:	0ff7f793          	zext.b	a5,a5
    1046:	10fc6e63          	bltu	s8,a5,1162 <vprintf+0x19e>
    104a:	f9d9079b          	addiw	a5,s2,-99
    104e:	0ff7f713          	zext.b	a4,a5
    1052:	10ec6863          	bltu	s8,a4,1162 <vprintf+0x19e>
    1056:	00271793          	slli	a5,a4,0x2
    105a:	97e6                	add	a5,a5,s9
    105c:	439c                	lw	a5,0(a5)
    105e:	97e6                	add	a5,a5,s9
    1060:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    1062:	008b0913          	addi	s2,s6,8
    1066:	4685                	li	a3,1
    1068:	4629                	li	a2,10
    106a:	000b2583          	lw	a1,0(s6)
    106e:	8556                	mv	a0,s5
    1070:	00000097          	auipc	ra,0x0
    1074:	ea8080e7          	jalr	-344(ra) # f18 <printint>
    1078:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    107a:	4981                	li	s3,0
    107c:	b765                	j	1024 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    107e:	008b0913          	addi	s2,s6,8
    1082:	4681                	li	a3,0
    1084:	4629                	li	a2,10
    1086:	000b2583          	lw	a1,0(s6)
    108a:	8556                	mv	a0,s5
    108c:	00000097          	auipc	ra,0x0
    1090:	e8c080e7          	jalr	-372(ra) # f18 <printint>
    1094:	8b4a                	mv	s6,s2
      state = 0;
    1096:	4981                	li	s3,0
    1098:	b771                	j	1024 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    109a:	008b0913          	addi	s2,s6,8
    109e:	4681                	li	a3,0
    10a0:	866a                	mv	a2,s10
    10a2:	000b2583          	lw	a1,0(s6)
    10a6:	8556                	mv	a0,s5
    10a8:	00000097          	auipc	ra,0x0
    10ac:	e70080e7          	jalr	-400(ra) # f18 <printint>
    10b0:	8b4a                	mv	s6,s2
      state = 0;
    10b2:	4981                	li	s3,0
    10b4:	bf85                	j	1024 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    10b6:	008b0793          	addi	a5,s6,8
    10ba:	f8f43423          	sd	a5,-120(s0)
    10be:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    10c2:	03000593          	li	a1,48
    10c6:	8556                	mv	a0,s5
    10c8:	00000097          	auipc	ra,0x0
    10cc:	e2e080e7          	jalr	-466(ra) # ef6 <putc>
  putc(fd, 'x');
    10d0:	07800593          	li	a1,120
    10d4:	8556                	mv	a0,s5
    10d6:	00000097          	auipc	ra,0x0
    10da:	e20080e7          	jalr	-480(ra) # ef6 <putc>
    10de:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    10e0:	03c9d793          	srli	a5,s3,0x3c
    10e4:	97de                	add	a5,a5,s7
    10e6:	0007c583          	lbu	a1,0(a5)
    10ea:	8556                	mv	a0,s5
    10ec:	00000097          	auipc	ra,0x0
    10f0:	e0a080e7          	jalr	-502(ra) # ef6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    10f4:	0992                	slli	s3,s3,0x4
    10f6:	397d                	addiw	s2,s2,-1
    10f8:	fe0914e3          	bnez	s2,10e0 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
    10fc:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    1100:	4981                	li	s3,0
    1102:	b70d                	j	1024 <vprintf+0x60>
        s = va_arg(ap, char*);
    1104:	008b0913          	addi	s2,s6,8
    1108:	000b3983          	ld	s3,0(s6)
        if(s == 0)
    110c:	02098163          	beqz	s3,112e <vprintf+0x16a>
        while(*s != 0){
    1110:	0009c583          	lbu	a1,0(s3)
    1114:	c5ad                	beqz	a1,117e <vprintf+0x1ba>
          putc(fd, *s);
    1116:	8556                	mv	a0,s5
    1118:	00000097          	auipc	ra,0x0
    111c:	dde080e7          	jalr	-546(ra) # ef6 <putc>
          s++;
    1120:	0985                	addi	s3,s3,1
        while(*s != 0){
    1122:	0009c583          	lbu	a1,0(s3)
    1126:	f9e5                	bnez	a1,1116 <vprintf+0x152>
        s = va_arg(ap, char*);
    1128:	8b4a                	mv	s6,s2
      state = 0;
    112a:	4981                	li	s3,0
    112c:	bde5                	j	1024 <vprintf+0x60>
          s = "(null)";
    112e:	00000997          	auipc	s3,0x0
    1132:	5b298993          	addi	s3,s3,1458 # 16e0 <l_free+0x2ee>
        while(*s != 0){
    1136:	85ee                	mv	a1,s11
    1138:	bff9                	j	1116 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
    113a:	008b0913          	addi	s2,s6,8
    113e:	000b4583          	lbu	a1,0(s6)
    1142:	8556                	mv	a0,s5
    1144:	00000097          	auipc	ra,0x0
    1148:	db2080e7          	jalr	-590(ra) # ef6 <putc>
    114c:	8b4a                	mv	s6,s2
      state = 0;
    114e:	4981                	li	s3,0
    1150:	bdd1                	j	1024 <vprintf+0x60>
        putc(fd, c);
    1152:	85d2                	mv	a1,s4
    1154:	8556                	mv	a0,s5
    1156:	00000097          	auipc	ra,0x0
    115a:	da0080e7          	jalr	-608(ra) # ef6 <putc>
      state = 0;
    115e:	4981                	li	s3,0
    1160:	b5d1                	j	1024 <vprintf+0x60>
        putc(fd, '%');
    1162:	85d2                	mv	a1,s4
    1164:	8556                	mv	a0,s5
    1166:	00000097          	auipc	ra,0x0
    116a:	d90080e7          	jalr	-624(ra) # ef6 <putc>
        putc(fd, c);
    116e:	85ca                	mv	a1,s2
    1170:	8556                	mv	a0,s5
    1172:	00000097          	auipc	ra,0x0
    1176:	d84080e7          	jalr	-636(ra) # ef6 <putc>
      state = 0;
    117a:	4981                	li	s3,0
    117c:	b565                	j	1024 <vprintf+0x60>
        s = va_arg(ap, char*);
    117e:	8b4a                	mv	s6,s2
      state = 0;
    1180:	4981                	li	s3,0
    1182:	b54d                	j	1024 <vprintf+0x60>
    }
  }
}
    1184:	70e6                	ld	ra,120(sp)
    1186:	7446                	ld	s0,112(sp)
    1188:	74a6                	ld	s1,104(sp)
    118a:	7906                	ld	s2,96(sp)
    118c:	69e6                	ld	s3,88(sp)
    118e:	6a46                	ld	s4,80(sp)
    1190:	6aa6                	ld	s5,72(sp)
    1192:	6b06                	ld	s6,64(sp)
    1194:	7be2                	ld	s7,56(sp)
    1196:	7c42                	ld	s8,48(sp)
    1198:	7ca2                	ld	s9,40(sp)
    119a:	7d02                	ld	s10,32(sp)
    119c:	6de2                	ld	s11,24(sp)
    119e:	6109                	addi	sp,sp,128
    11a0:	8082                	ret

00000000000011a2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    11a2:	715d                	addi	sp,sp,-80
    11a4:	ec06                	sd	ra,24(sp)
    11a6:	e822                	sd	s0,16(sp)
    11a8:	1000                	addi	s0,sp,32
    11aa:	e010                	sd	a2,0(s0)
    11ac:	e414                	sd	a3,8(s0)
    11ae:	e818                	sd	a4,16(s0)
    11b0:	ec1c                	sd	a5,24(s0)
    11b2:	03043023          	sd	a6,32(s0)
    11b6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    11ba:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    11be:	8622                	mv	a2,s0
    11c0:	00000097          	auipc	ra,0x0
    11c4:	e04080e7          	jalr	-508(ra) # fc4 <vprintf>
}
    11c8:	60e2                	ld	ra,24(sp)
    11ca:	6442                	ld	s0,16(sp)
    11cc:	6161                	addi	sp,sp,80
    11ce:	8082                	ret

00000000000011d0 <printf>:

void
printf(const char *fmt, ...)
{
    11d0:	711d                	addi	sp,sp,-96
    11d2:	ec06                	sd	ra,24(sp)
    11d4:	e822                	sd	s0,16(sp)
    11d6:	1000                	addi	s0,sp,32
    11d8:	e40c                	sd	a1,8(s0)
    11da:	e810                	sd	a2,16(s0)
    11dc:	ec14                	sd	a3,24(s0)
    11de:	f018                	sd	a4,32(s0)
    11e0:	f41c                	sd	a5,40(s0)
    11e2:	03043823          	sd	a6,48(s0)
    11e6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    11ea:	00840613          	addi	a2,s0,8
    11ee:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    11f2:	85aa                	mv	a1,a0
    11f4:	4505                	li	a0,1
    11f6:	00000097          	auipc	ra,0x0
    11fa:	dce080e7          	jalr	-562(ra) # fc4 <vprintf>
}
    11fe:	60e2                	ld	ra,24(sp)
    1200:	6442                	ld	s0,16(sp)
    1202:	6125                	addi	sp,sp,96
    1204:	8082                	ret

0000000000001206 <free>:
    1206:	1141                	addi	sp,sp,-16
    1208:	e422                	sd	s0,8(sp)
    120a:	0800                	addi	s0,sp,16
    120c:	ff050693          	addi	a3,a0,-16
    1210:	00000797          	auipc	a5,0x0
    1214:	5607b783          	ld	a5,1376(a5) # 1770 <freep>
    1218:	a805                	j	1248 <free+0x42>
    121a:	4618                	lw	a4,8(a2)
    121c:	9db9                	addw	a1,a1,a4
    121e:	feb52c23          	sw	a1,-8(a0)
    1222:	6398                	ld	a4,0(a5)
    1224:	6318                	ld	a4,0(a4)
    1226:	fee53823          	sd	a4,-16(a0)
    122a:	a091                	j	126e <free+0x68>
    122c:	ff852703          	lw	a4,-8(a0)
    1230:	9e39                	addw	a2,a2,a4
    1232:	c790                	sw	a2,8(a5)
    1234:	ff053703          	ld	a4,-16(a0)
    1238:	e398                	sd	a4,0(a5)
    123a:	a099                	j	1280 <free+0x7a>
    123c:	6398                	ld	a4,0(a5)
    123e:	00e7e463          	bltu	a5,a4,1246 <free+0x40>
    1242:	00e6ea63          	bltu	a3,a4,1256 <free+0x50>
    1246:	87ba                	mv	a5,a4
    1248:	fed7fae3          	bgeu	a5,a3,123c <free+0x36>
    124c:	6398                	ld	a4,0(a5)
    124e:	00e6e463          	bltu	a3,a4,1256 <free+0x50>
    1252:	fee7eae3          	bltu	a5,a4,1246 <free+0x40>
    1256:	ff852583          	lw	a1,-8(a0)
    125a:	6390                	ld	a2,0(a5)
    125c:	02059713          	slli	a4,a1,0x20
    1260:	9301                	srli	a4,a4,0x20
    1262:	0712                	slli	a4,a4,0x4
    1264:	9736                	add	a4,a4,a3
    1266:	fae60ae3          	beq	a2,a4,121a <free+0x14>
    126a:	fec53823          	sd	a2,-16(a0)
    126e:	4790                	lw	a2,8(a5)
    1270:	02061713          	slli	a4,a2,0x20
    1274:	9301                	srli	a4,a4,0x20
    1276:	0712                	slli	a4,a4,0x4
    1278:	973e                	add	a4,a4,a5
    127a:	fae689e3          	beq	a3,a4,122c <free+0x26>
    127e:	e394                	sd	a3,0(a5)
    1280:	00000717          	auipc	a4,0x0
    1284:	4ef73823          	sd	a5,1264(a4) # 1770 <freep>
    1288:	6422                	ld	s0,8(sp)
    128a:	0141                	addi	sp,sp,16
    128c:	8082                	ret

000000000000128e <malloc>:
    128e:	7139                	addi	sp,sp,-64
    1290:	fc06                	sd	ra,56(sp)
    1292:	f822                	sd	s0,48(sp)
    1294:	f426                	sd	s1,40(sp)
    1296:	f04a                	sd	s2,32(sp)
    1298:	ec4e                	sd	s3,24(sp)
    129a:	e852                	sd	s4,16(sp)
    129c:	e456                	sd	s5,8(sp)
    129e:	e05a                	sd	s6,0(sp)
    12a0:	0080                	addi	s0,sp,64
    12a2:	02051493          	slli	s1,a0,0x20
    12a6:	9081                	srli	s1,s1,0x20
    12a8:	04bd                	addi	s1,s1,15
    12aa:	8091                	srli	s1,s1,0x4
    12ac:	0014899b          	addiw	s3,s1,1
    12b0:	0485                	addi	s1,s1,1
    12b2:	00000517          	auipc	a0,0x0
    12b6:	4be53503          	ld	a0,1214(a0) # 1770 <freep>
    12ba:	c515                	beqz	a0,12e6 <malloc+0x58>
    12bc:	611c                	ld	a5,0(a0)
    12be:	4798                	lw	a4,8(a5)
    12c0:	02977f63          	bgeu	a4,s1,12fe <malloc+0x70>
    12c4:	8a4e                	mv	s4,s3
    12c6:	0009871b          	sext.w	a4,s3
    12ca:	6685                	lui	a3,0x1
    12cc:	00d77363          	bgeu	a4,a3,12d2 <malloc+0x44>
    12d0:	6a05                	lui	s4,0x1
    12d2:	000a0b1b          	sext.w	s6,s4
    12d6:	004a1a1b          	slliw	s4,s4,0x4
    12da:	00000917          	auipc	s2,0x0
    12de:	49690913          	addi	s2,s2,1174 # 1770 <freep>
    12e2:	5afd                	li	s5,-1
    12e4:	a88d                	j	1356 <malloc+0xc8>
    12e6:	00001797          	auipc	a5,0x1
    12ea:	87a78793          	addi	a5,a5,-1926 # 1b60 <base>
    12ee:	00000717          	auipc	a4,0x0
    12f2:	48f73123          	sd	a5,1154(a4) # 1770 <freep>
    12f6:	e39c                	sd	a5,0(a5)
    12f8:	0007a423          	sw	zero,8(a5)
    12fc:	b7e1                	j	12c4 <malloc+0x36>
    12fe:	02e48b63          	beq	s1,a4,1334 <malloc+0xa6>
    1302:	4137073b          	subw	a4,a4,s3
    1306:	c798                	sw	a4,8(a5)
    1308:	1702                	slli	a4,a4,0x20
    130a:	9301                	srli	a4,a4,0x20
    130c:	0712                	slli	a4,a4,0x4
    130e:	97ba                	add	a5,a5,a4
    1310:	0137a423          	sw	s3,8(a5)
    1314:	00000717          	auipc	a4,0x0
    1318:	44a73e23          	sd	a0,1116(a4) # 1770 <freep>
    131c:	01078513          	addi	a0,a5,16
    1320:	70e2                	ld	ra,56(sp)
    1322:	7442                	ld	s0,48(sp)
    1324:	74a2                	ld	s1,40(sp)
    1326:	7902                	ld	s2,32(sp)
    1328:	69e2                	ld	s3,24(sp)
    132a:	6a42                	ld	s4,16(sp)
    132c:	6aa2                	ld	s5,8(sp)
    132e:	6b02                	ld	s6,0(sp)
    1330:	6121                	addi	sp,sp,64
    1332:	8082                	ret
    1334:	6398                	ld	a4,0(a5)
    1336:	e118                	sd	a4,0(a0)
    1338:	bff1                	j	1314 <malloc+0x86>
    133a:	01652423          	sw	s6,8(a0)
    133e:	0541                	addi	a0,a0,16
    1340:	00000097          	auipc	ra,0x0
    1344:	ec6080e7          	jalr	-314(ra) # 1206 <free>
    1348:	00093503          	ld	a0,0(s2)
    134c:	d971                	beqz	a0,1320 <malloc+0x92>
    134e:	611c                	ld	a5,0(a0)
    1350:	4798                	lw	a4,8(a5)
    1352:	fa9776e3          	bgeu	a4,s1,12fe <malloc+0x70>
    1356:	00093703          	ld	a4,0(s2)
    135a:	853e                	mv	a0,a5
    135c:	fef719e3          	bne	a4,a5,134e <malloc+0xc0>
    1360:	8552                	mv	a0,s4
    1362:	00000097          	auipc	ra,0x0
    1366:	b7c080e7          	jalr	-1156(ra) # ede <sbrk>
    136a:	fd5518e3          	bne	a0,s5,133a <malloc+0xac>
    136e:	4501                	li	a0,0
    1370:	bf45                	j	1320 <malloc+0x92>

0000000000001372 <mem_init>:
    1372:	1141                	addi	sp,sp,-16
    1374:	e406                	sd	ra,8(sp)
    1376:	e022                	sd	s0,0(sp)
    1378:	0800                	addi	s0,sp,16
    137a:	6505                	lui	a0,0x1
    137c:	00000097          	auipc	ra,0x0
    1380:	b62080e7          	jalr	-1182(ra) # ede <sbrk>
    1384:	00000797          	auipc	a5,0x0
    1388:	3ea7b223          	sd	a0,996(a5) # 1768 <alloc>
    138c:	00850793          	addi	a5,a0,8 # 1008 <vprintf+0x44>
    1390:	e11c                	sd	a5,0(a0)
    1392:	60a2                	ld	ra,8(sp)
    1394:	6402                	ld	s0,0(sp)
    1396:	0141                	addi	sp,sp,16
    1398:	8082                	ret

000000000000139a <l_alloc>:
    139a:	1101                	addi	sp,sp,-32
    139c:	ec06                	sd	ra,24(sp)
    139e:	e822                	sd	s0,16(sp)
    13a0:	e426                	sd	s1,8(sp)
    13a2:	1000                	addi	s0,sp,32
    13a4:	84aa                	mv	s1,a0
    13a6:	00000797          	auipc	a5,0x0
    13aa:	3ba7a783          	lw	a5,954(a5) # 1760 <if_init>
    13ae:	c795                	beqz	a5,13da <l_alloc+0x40>
    13b0:	00000717          	auipc	a4,0x0
    13b4:	3b873703          	ld	a4,952(a4) # 1768 <alloc>
    13b8:	6308                	ld	a0,0(a4)
    13ba:	40e506b3          	sub	a3,a0,a4
    13be:	6785                	lui	a5,0x1
    13c0:	37e1                	addiw	a5,a5,-8
    13c2:	9f95                	subw	a5,a5,a3
    13c4:	02f4f563          	bgeu	s1,a5,13ee <l_alloc+0x54>
    13c8:	1482                	slli	s1,s1,0x20
    13ca:	9081                	srli	s1,s1,0x20
    13cc:	94aa                	add	s1,s1,a0
    13ce:	e304                	sd	s1,0(a4)
    13d0:	60e2                	ld	ra,24(sp)
    13d2:	6442                	ld	s0,16(sp)
    13d4:	64a2                	ld	s1,8(sp)
    13d6:	6105                	addi	sp,sp,32
    13d8:	8082                	ret
    13da:	00000097          	auipc	ra,0x0
    13de:	f98080e7          	jalr	-104(ra) # 1372 <mem_init>
    13e2:	4785                	li	a5,1
    13e4:	00000717          	auipc	a4,0x0
    13e8:	36f72e23          	sw	a5,892(a4) # 1760 <if_init>
    13ec:	b7d1                	j	13b0 <l_alloc+0x16>
    13ee:	4501                	li	a0,0
    13f0:	b7c5                	j	13d0 <l_alloc+0x36>

00000000000013f2 <l_free>:
    13f2:	1141                	addi	sp,sp,-16
    13f4:	e422                	sd	s0,8(sp)
    13f6:	0800                	addi	s0,sp,16
    13f8:	6422                	ld	s0,8(sp)
    13fa:	0141                	addi	sp,sp,16
    13fc:	8082                	ret
