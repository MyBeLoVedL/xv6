
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
    close(fds[1]);
  }
}

// what if you pass ridiculous string pointers to system calls?
void copyinstr1(char *s) {
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = {0x80000000LL, 0xffffffffffffffff};

  for (int ai = 0; ai < 2; ai++) {
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE | O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00005097          	auipc	ra,0x5
      14:	4fc080e7          	jalr	1276(ra) # 550c <open>
    if (fd >= 0) {
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE | O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00005097          	auipc	ra,0x5
      26:	4ea080e7          	jalr	1258(ra) # 550c <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if (fd >= 0) {
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	d4250513          	addi	a0,a0,-702 # 5d80 <l_free+0x31a>
      46:	00005097          	auipc	ra,0x5
      4a:	7fe080e7          	jalr	2046(ra) # 5844 <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00005097          	auipc	ra,0x5
      54:	47c080e7          	jalr	1148(ra) # 54cc <exit>

0000000000000058 <bsstest>:
// does unintialized data start out zero?
char uninit[10000];
void bsstest(char *s) {
  int i;

  for (i = 0; i < sizeof(uninit); i++) {
      58:	00009797          	auipc	a5,0x9
      5c:	25078793          	addi	a5,a5,592 # 92a8 <uninit>
      60:	0000c697          	auipc	a3,0xc
      64:	95868693          	addi	a3,a3,-1704 # b9b8 <buf>
    if (uninit[i] != '\0') {
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for (i = 0; i < sizeof(uninit); i++) {
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
void bsstest(char *s) {
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	d2050513          	addi	a0,a0,-736 # 5da0 <l_free+0x33a>
      88:	00005097          	auipc	ra,0x5
      8c:	7bc080e7          	jalr	1980(ra) # 5844 <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00005097          	auipc	ra,0x5
      96:	43a080e7          	jalr	1082(ra) # 54cc <exit>

000000000000009a <opentest>:
void opentest(char *s) {
      9a:	1101                	addi	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	addi	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	d1050513          	addi	a0,a0,-752 # 5db8 <l_free+0x352>
      b0:	00005097          	auipc	ra,0x5
      b4:	45c080e7          	jalr	1116(ra) # 550c <open>
  if (fd < 0) {
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00005097          	auipc	ra,0x5
      c0:	438080e7          	jalr	1080(ra) # 54f4 <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	d1250513          	addi	a0,a0,-750 # 5dd8 <l_free+0x372>
      ce:	00005097          	auipc	ra,0x5
      d2:	43e080e7          	jalr	1086(ra) # 550c <open>
  if (fd >= 0) {
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	addi	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	cda50513          	addi	a0,a0,-806 # 5dc0 <l_free+0x35a>
      ee:	00005097          	auipc	ra,0x5
      f2:	756080e7          	jalr	1878(ra) # 5844 <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00005097          	auipc	ra,0x5
      fc:	3d4080e7          	jalr	980(ra) # 54cc <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	ce650513          	addi	a0,a0,-794 # 5de8 <l_free+0x382>
     10a:	00005097          	auipc	ra,0x5
     10e:	73a080e7          	jalr	1850(ra) # 5844 <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00005097          	auipc	ra,0x5
     118:	3b8080e7          	jalr	952(ra) # 54cc <exit>

000000000000011c <truncate2>:
void truncate2(char *s) {
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	ce450513          	addi	a0,a0,-796 # 5e10 <l_free+0x3aa>
     134:	00005097          	auipc	ra,0x5
     138:	3e8080e7          	jalr	1000(ra) # 551c <unlink>
  int fd1 = open("truncfile", O_CREATE | O_TRUNC | O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	cd050513          	addi	a0,a0,-816 # 5e10 <l_free+0x3aa>
     148:	00005097          	auipc	ra,0x5
     14c:	3c4080e7          	jalr	964(ra) # 550c <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	ccc58593          	addi	a1,a1,-820 # 5e20 <l_free+0x3ba>
     15c:	00005097          	auipc	ra,0x5
     160:	390080e7          	jalr	912(ra) # 54ec <write>
  int fd2 = open("truncfile", O_TRUNC | O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	ca850513          	addi	a0,a0,-856 # 5e10 <l_free+0x3aa>
     170:	00005097          	auipc	ra,0x5
     174:	39c080e7          	jalr	924(ra) # 550c <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	cac58593          	addi	a1,a1,-852 # 5e28 <l_free+0x3c2>
     184:	8526                	mv	a0,s1
     186:	00005097          	auipc	ra,0x5
     18a:	366080e7          	jalr	870(ra) # 54ec <write>
  if (n != -1) {
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	c7c50513          	addi	a0,a0,-900 # 5e10 <l_free+0x3aa>
     19c:	00005097          	auipc	ra,0x5
     1a0:	380080e7          	jalr	896(ra) # 551c <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00005097          	auipc	ra,0x5
     1aa:	34e080e7          	jalr	846(ra) # 54f4 <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00005097          	auipc	ra,0x5
     1b4:	344080e7          	jalr	836(ra) # 54f4 <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	addi	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	c6650513          	addi	a0,a0,-922 # 5e30 <l_free+0x3ca>
     1d2:	00005097          	auipc	ra,0x5
     1d6:	672080e7          	jalr	1650(ra) # 5844 <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00005097          	auipc	ra,0x5
     1e0:	2f0080e7          	jalr	752(ra) # 54cc <exit>

00000000000001e4 <createtest>:
void createtest(char *s) {
     1e4:	7179                	addi	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	e44e                	sd	s3,8(sp)
     1f0:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1f2:	00008797          	auipc	a5,0x8
     1f6:	f8e78793          	addi	a5,a5,-114 # 8180 <name>
     1fa:	06100713          	li	a4,97
     1fe:	00e78023          	sb	a4,0(a5)
  name[2] = '\0';
     202:	00078123          	sb	zero,2(a5)
     206:	03000493          	li	s1,48
    name[1] = '0' + i;
     20a:	893e                	mv	s2,a5
  for (i = 0; i < N; i++) {
     20c:	06400993          	li	s3,100
    name[1] = '0' + i;
     210:	009900a3          	sb	s1,1(s2)
    fd = open(name, O_CREATE | O_RDWR);
     214:	20200593          	li	a1,514
     218:	854a                	mv	a0,s2
     21a:	00005097          	auipc	ra,0x5
     21e:	2f2080e7          	jalr	754(ra) # 550c <open>
    close(fd);
     222:	00005097          	auipc	ra,0x5
     226:	2d2080e7          	jalr	722(ra) # 54f4 <close>
  for (i = 0; i < N; i++) {
     22a:	2485                	addiw	s1,s1,1
     22c:	0ff4f493          	andi	s1,s1,255
     230:	ff3490e3          	bne	s1,s3,210 <createtest+0x2c>
  name[0] = 'a';
     234:	00008797          	auipc	a5,0x8
     238:	f4c78793          	addi	a5,a5,-180 # 8180 <name>
     23c:	06100713          	li	a4,97
     240:	00e78023          	sb	a4,0(a5)
  name[2] = '\0';
     244:	00078123          	sb	zero,2(a5)
     248:	03000493          	li	s1,48
    name[1] = '0' + i;
     24c:	893e                	mv	s2,a5
  for (i = 0; i < N; i++) {
     24e:	06400993          	li	s3,100
    name[1] = '0' + i;
     252:	009900a3          	sb	s1,1(s2)
    unlink(name);
     256:	854a                	mv	a0,s2
     258:	00005097          	auipc	ra,0x5
     25c:	2c4080e7          	jalr	708(ra) # 551c <unlink>
  for (i = 0; i < N; i++) {
     260:	2485                	addiw	s1,s1,1
     262:	0ff4f493          	andi	s1,s1,255
     266:	ff3496e3          	bne	s1,s3,252 <createtest+0x6e>
}
     26a:	70a2                	ld	ra,40(sp)
     26c:	7402                	ld	s0,32(sp)
     26e:	64e2                	ld	s1,24(sp)
     270:	6942                	ld	s2,16(sp)
     272:	69a2                	ld	s3,8(sp)
     274:	6145                	addi	sp,sp,48
     276:	8082                	ret

0000000000000278 <bigwrite>:
void bigwrite(char *s) {
     278:	715d                	addi	sp,sp,-80
     27a:	e486                	sd	ra,72(sp)
     27c:	e0a2                	sd	s0,64(sp)
     27e:	fc26                	sd	s1,56(sp)
     280:	f84a                	sd	s2,48(sp)
     282:	f44e                	sd	s3,40(sp)
     284:	f052                	sd	s4,32(sp)
     286:	ec56                	sd	s5,24(sp)
     288:	e85a                	sd	s6,16(sp)
     28a:	e45e                	sd	s7,8(sp)
     28c:	0880                	addi	s0,sp,80
     28e:	8baa                	mv	s7,a0
  unlink("bigwrite");
     290:	00006517          	auipc	a0,0x6
     294:	9b050513          	addi	a0,a0,-1616 # 5c40 <l_free+0x1da>
     298:	00005097          	auipc	ra,0x5
     29c:	284080e7          	jalr	644(ra) # 551c <unlink>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     2a0:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a4:	00006a97          	auipc	s5,0x6
     2a8:	99ca8a93          	addi	s5,s5,-1636 # 5c40 <l_free+0x1da>
      int cc = write(fd, buf, sz);
     2ac:	0000ba17          	auipc	s4,0xb
     2b0:	70ca0a13          	addi	s4,s4,1804 # b9b8 <buf>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     2b4:	6b0d                	lui	s6,0x3
     2b6:	1c9b0b13          	addi	s6,s6,457 # 31c9 <subdir+0x5b7>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2ba:	20200593          	li	a1,514
     2be:	8556                	mv	a0,s5
     2c0:	00005097          	auipc	ra,0x5
     2c4:	24c080e7          	jalr	588(ra) # 550c <open>
     2c8:	892a                	mv	s2,a0
    if (fd < 0) {
     2ca:	04054d63          	bltz	a0,324 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ce:	8626                	mv	a2,s1
     2d0:	85d2                	mv	a1,s4
     2d2:	00005097          	auipc	ra,0x5
     2d6:	21a080e7          	jalr	538(ra) # 54ec <write>
     2da:	89aa                	mv	s3,a0
      if (cc != sz) {
     2dc:	06a49463          	bne	s1,a0,344 <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
     2e0:	8626                	mv	a2,s1
     2e2:	85d2                	mv	a1,s4
     2e4:	854a                	mv	a0,s2
     2e6:	00005097          	auipc	ra,0x5
     2ea:	206080e7          	jalr	518(ra) # 54ec <write>
      if (cc != sz) {
     2ee:	04951963          	bne	a0,s1,340 <bigwrite+0xc8>
    close(fd);
     2f2:	854a                	mv	a0,s2
     2f4:	00005097          	auipc	ra,0x5
     2f8:	200080e7          	jalr	512(ra) # 54f4 <close>
    unlink("bigwrite");
     2fc:	8556                	mv	a0,s5
     2fe:	00005097          	auipc	ra,0x5
     302:	21e080e7          	jalr	542(ra) # 551c <unlink>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     306:	1d74849b          	addiw	s1,s1,471
     30a:	fb6498e3          	bne	s1,s6,2ba <bigwrite+0x42>
}
     30e:	60a6                	ld	ra,72(sp)
     310:	6406                	ld	s0,64(sp)
     312:	74e2                	ld	s1,56(sp)
     314:	7942                	ld	s2,48(sp)
     316:	79a2                	ld	s3,40(sp)
     318:	7a02                	ld	s4,32(sp)
     31a:	6ae2                	ld	s5,24(sp)
     31c:	6b42                	ld	s6,16(sp)
     31e:	6ba2                	ld	s7,8(sp)
     320:	6161                	addi	sp,sp,80
     322:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     324:	85de                	mv	a1,s7
     326:	00006517          	auipc	a0,0x6
     32a:	b3250513          	addi	a0,a0,-1230 # 5e58 <l_free+0x3f2>
     32e:	00005097          	auipc	ra,0x5
     332:	516080e7          	jalr	1302(ra) # 5844 <printf>
      exit(1);
     336:	4505                	li	a0,1
     338:	00005097          	auipc	ra,0x5
     33c:	194080e7          	jalr	404(ra) # 54cc <exit>
     340:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     342:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     344:	86ce                	mv	a3,s3
     346:	8626                	mv	a2,s1
     348:	85de                	mv	a1,s7
     34a:	00006517          	auipc	a0,0x6
     34e:	b2e50513          	addi	a0,a0,-1234 # 5e78 <l_free+0x412>
     352:	00005097          	auipc	ra,0x5
     356:	4f2080e7          	jalr	1266(ra) # 5844 <printf>
        exit(1);
     35a:	4505                	li	a0,1
     35c:	00005097          	auipc	ra,0x5
     360:	170080e7          	jalr	368(ra) # 54cc <exit>

0000000000000364 <badwrite>:
// regression test. does write() with an invalid buffer pointer cause
// a block to be allocated for a file that is then not freed when the
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void badwrite(char *s) {
     364:	7179                	addi	sp,sp,-48
     366:	f406                	sd	ra,40(sp)
     368:	f022                	sd	s0,32(sp)
     36a:	ec26                	sd	s1,24(sp)
     36c:	e84a                	sd	s2,16(sp)
     36e:	e44e                	sd	s3,8(sp)
     370:	e052                	sd	s4,0(sp)
     372:	1800                	addi	s0,sp,48
  int assumed_free = 600;

  unlink("junk");
     374:	00006517          	auipc	a0,0x6
     378:	b1c50513          	addi	a0,a0,-1252 # 5e90 <l_free+0x42a>
     37c:	00005097          	auipc	ra,0x5
     380:	1a0080e7          	jalr	416(ra) # 551c <unlink>
     384:	25800913          	li	s2,600
  for (int i = 0; i < assumed_free; i++) {
    int fd = open("junk", O_CREATE | O_WRONLY);
     388:	00006997          	auipc	s3,0x6
     38c:	b0898993          	addi	s3,s3,-1272 # 5e90 <l_free+0x42a>
    if (fd < 0) {
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char *)0xffffffffffL, 1);
     390:	5a7d                	li	s4,-1
     392:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE | O_WRONLY);
     396:	20100593          	li	a1,513
     39a:	854e                	mv	a0,s3
     39c:	00005097          	auipc	ra,0x5
     3a0:	170080e7          	jalr	368(ra) # 550c <open>
     3a4:	84aa                	mv	s1,a0
    if (fd < 0) {
     3a6:	06054b63          	bltz	a0,41c <badwrite+0xb8>
    write(fd, (char *)0xffffffffffL, 1);
     3aa:	4605                	li	a2,1
     3ac:	85d2                	mv	a1,s4
     3ae:	00005097          	auipc	ra,0x5
     3b2:	13e080e7          	jalr	318(ra) # 54ec <write>
    close(fd);
     3b6:	8526                	mv	a0,s1
     3b8:	00005097          	auipc	ra,0x5
     3bc:	13c080e7          	jalr	316(ra) # 54f4 <close>
    unlink("junk");
     3c0:	854e                	mv	a0,s3
     3c2:	00005097          	auipc	ra,0x5
     3c6:	15a080e7          	jalr	346(ra) # 551c <unlink>
  for (int i = 0; i < assumed_free; i++) {
     3ca:	397d                	addiw	s2,s2,-1
     3cc:	fc0915e3          	bnez	s2,396 <badwrite+0x32>
  }

  int fd = open("junk", O_CREATE | O_WRONLY);
     3d0:	20100593          	li	a1,513
     3d4:	00006517          	auipc	a0,0x6
     3d8:	abc50513          	addi	a0,a0,-1348 # 5e90 <l_free+0x42a>
     3dc:	00005097          	auipc	ra,0x5
     3e0:	130080e7          	jalr	304(ra) # 550c <open>
     3e4:	84aa                	mv	s1,a0
  if (fd < 0) {
     3e6:	04054863          	bltz	a0,436 <badwrite+0xd2>
    printf("open junk failed\n");
    exit(1);
  }
  if (write(fd, "x", 1) != 1) {
     3ea:	4605                	li	a2,1
     3ec:	00006597          	auipc	a1,0x6
     3f0:	a3c58593          	addi	a1,a1,-1476 # 5e28 <l_free+0x3c2>
     3f4:	00005097          	auipc	ra,0x5
     3f8:	0f8080e7          	jalr	248(ra) # 54ec <write>
     3fc:	4785                	li	a5,1
     3fe:	04f50963          	beq	a0,a5,450 <badwrite+0xec>
    printf("write failed\n");
     402:	00006517          	auipc	a0,0x6
     406:	aae50513          	addi	a0,a0,-1362 # 5eb0 <l_free+0x44a>
     40a:	00005097          	auipc	ra,0x5
     40e:	43a080e7          	jalr	1082(ra) # 5844 <printf>
    exit(1);
     412:	4505                	li	a0,1
     414:	00005097          	auipc	ra,0x5
     418:	0b8080e7          	jalr	184(ra) # 54cc <exit>
      printf("open junk failed\n");
     41c:	00006517          	auipc	a0,0x6
     420:	a7c50513          	addi	a0,a0,-1412 # 5e98 <l_free+0x432>
     424:	00005097          	auipc	ra,0x5
     428:	420080e7          	jalr	1056(ra) # 5844 <printf>
      exit(1);
     42c:	4505                	li	a0,1
     42e:	00005097          	auipc	ra,0x5
     432:	09e080e7          	jalr	158(ra) # 54cc <exit>
    printf("open junk failed\n");
     436:	00006517          	auipc	a0,0x6
     43a:	a6250513          	addi	a0,a0,-1438 # 5e98 <l_free+0x432>
     43e:	00005097          	auipc	ra,0x5
     442:	406080e7          	jalr	1030(ra) # 5844 <printf>
    exit(1);
     446:	4505                	li	a0,1
     448:	00005097          	auipc	ra,0x5
     44c:	084080e7          	jalr	132(ra) # 54cc <exit>
  }
  close(fd);
     450:	8526                	mv	a0,s1
     452:	00005097          	auipc	ra,0x5
     456:	0a2080e7          	jalr	162(ra) # 54f4 <close>
  unlink("junk");
     45a:	00006517          	auipc	a0,0x6
     45e:	a3650513          	addi	a0,a0,-1482 # 5e90 <l_free+0x42a>
     462:	00005097          	auipc	ra,0x5
     466:	0ba080e7          	jalr	186(ra) # 551c <unlink>

  exit(0);
     46a:	4501                	li	a0,0
     46c:	00005097          	auipc	ra,0x5
     470:	060080e7          	jalr	96(ra) # 54cc <exit>

0000000000000474 <copyin>:
void copyin(char *s) {
     474:	715d                	addi	sp,sp,-80
     476:	e486                	sd	ra,72(sp)
     478:	e0a2                	sd	s0,64(sp)
     47a:	fc26                	sd	s1,56(sp)
     47c:	f84a                	sd	s2,48(sp)
     47e:	f44e                	sd	s3,40(sp)
     480:	f052                	sd	s4,32(sp)
     482:	0880                	addi	s0,sp,80
  uint64 addrs[] = {0x80000000LL, 0xffffffffffffffff};
     484:	4785                	li	a5,1
     486:	07fe                	slli	a5,a5,0x1f
     488:	fcf43023          	sd	a5,-64(s0)
     48c:	57fd                	li	a5,-1
     48e:	fcf43423          	sd	a5,-56(s0)
  for (int ai = 0; ai < 2; ai++) {
     492:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE | O_WRONLY);
     496:	00006a17          	auipc	s4,0x6
     49a:	a2aa0a13          	addi	s4,s4,-1494 # 5ec0 <l_free+0x45a>
    uint64 addr = addrs[ai];
     49e:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE | O_WRONLY);
     4a2:	20100593          	li	a1,513
     4a6:	8552                	mv	a0,s4
     4a8:	00005097          	auipc	ra,0x5
     4ac:	064080e7          	jalr	100(ra) # 550c <open>
     4b0:	84aa                	mv	s1,a0
    if (fd < 0) {
     4b2:	08054863          	bltz	a0,542 <copyin+0xce>
    int n = write(fd, (void *)addr, 8192);
     4b6:	6609                	lui	a2,0x2
     4b8:	85ce                	mv	a1,s3
     4ba:	00005097          	auipc	ra,0x5
     4be:	032080e7          	jalr	50(ra) # 54ec <write>
    if (n >= 0) {
     4c2:	08055d63          	bgez	a0,55c <copyin+0xe8>
    close(fd);
     4c6:	8526                	mv	a0,s1
     4c8:	00005097          	auipc	ra,0x5
     4cc:	02c080e7          	jalr	44(ra) # 54f4 <close>
    unlink("copyin1");
     4d0:	8552                	mv	a0,s4
     4d2:	00005097          	auipc	ra,0x5
     4d6:	04a080e7          	jalr	74(ra) # 551c <unlink>
    n = write(1, (char *)addr, 8192);
     4da:	6609                	lui	a2,0x2
     4dc:	85ce                	mv	a1,s3
     4de:	4505                	li	a0,1
     4e0:	00005097          	auipc	ra,0x5
     4e4:	00c080e7          	jalr	12(ra) # 54ec <write>
    if (n > 0) {
     4e8:	08a04963          	bgtz	a0,57a <copyin+0x106>
    if (pipe(fds) < 0) {
     4ec:	fb840513          	addi	a0,s0,-72
     4f0:	00005097          	auipc	ra,0x5
     4f4:	fec080e7          	jalr	-20(ra) # 54dc <pipe>
     4f8:	0a054063          	bltz	a0,598 <copyin+0x124>
    n = write(fds[1], (char *)addr, 8192);
     4fc:	6609                	lui	a2,0x2
     4fe:	85ce                	mv	a1,s3
     500:	fbc42503          	lw	a0,-68(s0)
     504:	00005097          	auipc	ra,0x5
     508:	fe8080e7          	jalr	-24(ra) # 54ec <write>
    if (n > 0) {
     50c:	0aa04363          	bgtz	a0,5b2 <copyin+0x13e>
    close(fds[0]);
     510:	fb842503          	lw	a0,-72(s0)
     514:	00005097          	auipc	ra,0x5
     518:	fe0080e7          	jalr	-32(ra) # 54f4 <close>
    close(fds[1]);
     51c:	fbc42503          	lw	a0,-68(s0)
     520:	00005097          	auipc	ra,0x5
     524:	fd4080e7          	jalr	-44(ra) # 54f4 <close>
  for (int ai = 0; ai < 2; ai++) {
     528:	0921                	addi	s2,s2,8
     52a:	fd040793          	addi	a5,s0,-48
     52e:	f6f918e3          	bne	s2,a5,49e <copyin+0x2a>
}
     532:	60a6                	ld	ra,72(sp)
     534:	6406                	ld	s0,64(sp)
     536:	74e2                	ld	s1,56(sp)
     538:	7942                	ld	s2,48(sp)
     53a:	79a2                	ld	s3,40(sp)
     53c:	7a02                	ld	s4,32(sp)
     53e:	6161                	addi	sp,sp,80
     540:	8082                	ret
      printf("open(copyin1) failed\n");
     542:	00006517          	auipc	a0,0x6
     546:	98650513          	addi	a0,a0,-1658 # 5ec8 <l_free+0x462>
     54a:	00005097          	auipc	ra,0x5
     54e:	2fa080e7          	jalr	762(ra) # 5844 <printf>
      exit(1);
     552:	4505                	li	a0,1
     554:	00005097          	auipc	ra,0x5
     558:	f78080e7          	jalr	-136(ra) # 54cc <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     55c:	862a                	mv	a2,a0
     55e:	85ce                	mv	a1,s3
     560:	00006517          	auipc	a0,0x6
     564:	98050513          	addi	a0,a0,-1664 # 5ee0 <l_free+0x47a>
     568:	00005097          	auipc	ra,0x5
     56c:	2dc080e7          	jalr	732(ra) # 5844 <printf>
      exit(1);
     570:	4505                	li	a0,1
     572:	00005097          	auipc	ra,0x5
     576:	f5a080e7          	jalr	-166(ra) # 54cc <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     57a:	862a                	mv	a2,a0
     57c:	85ce                	mv	a1,s3
     57e:	00006517          	auipc	a0,0x6
     582:	99250513          	addi	a0,a0,-1646 # 5f10 <l_free+0x4aa>
     586:	00005097          	auipc	ra,0x5
     58a:	2be080e7          	jalr	702(ra) # 5844 <printf>
      exit(1);
     58e:	4505                	li	a0,1
     590:	00005097          	auipc	ra,0x5
     594:	f3c080e7          	jalr	-196(ra) # 54cc <exit>
      printf("pipe() failed\n");
     598:	00006517          	auipc	a0,0x6
     59c:	9a850513          	addi	a0,a0,-1624 # 5f40 <l_free+0x4da>
     5a0:	00005097          	auipc	ra,0x5
     5a4:	2a4080e7          	jalr	676(ra) # 5844 <printf>
      exit(1);
     5a8:	4505                	li	a0,1
     5aa:	00005097          	auipc	ra,0x5
     5ae:	f22080e7          	jalr	-222(ra) # 54cc <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5b2:	862a                	mv	a2,a0
     5b4:	85ce                	mv	a1,s3
     5b6:	00006517          	auipc	a0,0x6
     5ba:	99a50513          	addi	a0,a0,-1638 # 5f50 <l_free+0x4ea>
     5be:	00005097          	auipc	ra,0x5
     5c2:	286080e7          	jalr	646(ra) # 5844 <printf>
      exit(1);
     5c6:	4505                	li	a0,1
     5c8:	00005097          	auipc	ra,0x5
     5cc:	f04080e7          	jalr	-252(ra) # 54cc <exit>

00000000000005d0 <copyout>:
void copyout(char *s) {
     5d0:	711d                	addi	sp,sp,-96
     5d2:	ec86                	sd	ra,88(sp)
     5d4:	e8a2                	sd	s0,80(sp)
     5d6:	e4a6                	sd	s1,72(sp)
     5d8:	e0ca                	sd	s2,64(sp)
     5da:	fc4e                	sd	s3,56(sp)
     5dc:	f852                	sd	s4,48(sp)
     5de:	f456                	sd	s5,40(sp)
     5e0:	1080                	addi	s0,sp,96
  uint64 addrs[] = {0x80000000LL, 0xffffffffffffffff};
     5e2:	4785                	li	a5,1
     5e4:	07fe                	slli	a5,a5,0x1f
     5e6:	faf43823          	sd	a5,-80(s0)
     5ea:	57fd                	li	a5,-1
     5ec:	faf43c23          	sd	a5,-72(s0)
  for (int ai = 0; ai < 2; ai++) {
     5f0:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     5f4:	00006a17          	auipc	s4,0x6
     5f8:	98ca0a13          	addi	s4,s4,-1652 # 5f80 <l_free+0x51a>
    n = write(fds[1], "x", 1);
     5fc:	00006a97          	auipc	s5,0x6
     600:	82ca8a93          	addi	s5,s5,-2004 # 5e28 <l_free+0x3c2>
    uint64 addr = addrs[ai];
     604:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     608:	4581                	li	a1,0
     60a:	8552                	mv	a0,s4
     60c:	00005097          	auipc	ra,0x5
     610:	f00080e7          	jalr	-256(ra) # 550c <open>
     614:	84aa                	mv	s1,a0
    if (fd < 0) {
     616:	08054663          	bltz	a0,6a2 <copyout+0xd2>
    int n = read(fd, (void *)addr, 8192);
     61a:	6609                	lui	a2,0x2
     61c:	85ce                	mv	a1,s3
     61e:	00005097          	auipc	ra,0x5
     622:	ec6080e7          	jalr	-314(ra) # 54e4 <read>
    if (n > 0) {
     626:	08a04b63          	bgtz	a0,6bc <copyout+0xec>
    close(fd);
     62a:	8526                	mv	a0,s1
     62c:	00005097          	auipc	ra,0x5
     630:	ec8080e7          	jalr	-312(ra) # 54f4 <close>
    if (pipe(fds) < 0) {
     634:	fa840513          	addi	a0,s0,-88
     638:	00005097          	auipc	ra,0x5
     63c:	ea4080e7          	jalr	-348(ra) # 54dc <pipe>
     640:	08054d63          	bltz	a0,6da <copyout+0x10a>
    n = write(fds[1], "x", 1);
     644:	4605                	li	a2,1
     646:	85d6                	mv	a1,s5
     648:	fac42503          	lw	a0,-84(s0)
     64c:	00005097          	auipc	ra,0x5
     650:	ea0080e7          	jalr	-352(ra) # 54ec <write>
    if (n != 1) {
     654:	4785                	li	a5,1
     656:	08f51f63          	bne	a0,a5,6f4 <copyout+0x124>
    n = read(fds[0], (void *)addr, 8192);
     65a:	6609                	lui	a2,0x2
     65c:	85ce                	mv	a1,s3
     65e:	fa842503          	lw	a0,-88(s0)
     662:	00005097          	auipc	ra,0x5
     666:	e82080e7          	jalr	-382(ra) # 54e4 <read>
    if (n > 0) {
     66a:	0aa04263          	bgtz	a0,70e <copyout+0x13e>
    close(fds[0]);
     66e:	fa842503          	lw	a0,-88(s0)
     672:	00005097          	auipc	ra,0x5
     676:	e82080e7          	jalr	-382(ra) # 54f4 <close>
    close(fds[1]);
     67a:	fac42503          	lw	a0,-84(s0)
     67e:	00005097          	auipc	ra,0x5
     682:	e76080e7          	jalr	-394(ra) # 54f4 <close>
  for (int ai = 0; ai < 2; ai++) {
     686:	0921                	addi	s2,s2,8
     688:	fc040793          	addi	a5,s0,-64
     68c:	f6f91ce3          	bne	s2,a5,604 <copyout+0x34>
}
     690:	60e6                	ld	ra,88(sp)
     692:	6446                	ld	s0,80(sp)
     694:	64a6                	ld	s1,72(sp)
     696:	6906                	ld	s2,64(sp)
     698:	79e2                	ld	s3,56(sp)
     69a:	7a42                	ld	s4,48(sp)
     69c:	7aa2                	ld	s5,40(sp)
     69e:	6125                	addi	sp,sp,96
     6a0:	8082                	ret
      printf("open(README) failed\n");
     6a2:	00006517          	auipc	a0,0x6
     6a6:	8e650513          	addi	a0,a0,-1818 # 5f88 <l_free+0x522>
     6aa:	00005097          	auipc	ra,0x5
     6ae:	19a080e7          	jalr	410(ra) # 5844 <printf>
      exit(1);
     6b2:	4505                	li	a0,1
     6b4:	00005097          	auipc	ra,0x5
     6b8:	e18080e7          	jalr	-488(ra) # 54cc <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     6bc:	862a                	mv	a2,a0
     6be:	85ce                	mv	a1,s3
     6c0:	00006517          	auipc	a0,0x6
     6c4:	8e050513          	addi	a0,a0,-1824 # 5fa0 <l_free+0x53a>
     6c8:	00005097          	auipc	ra,0x5
     6cc:	17c080e7          	jalr	380(ra) # 5844 <printf>
      exit(1);
     6d0:	4505                	li	a0,1
     6d2:	00005097          	auipc	ra,0x5
     6d6:	dfa080e7          	jalr	-518(ra) # 54cc <exit>
      printf("pipe() failed\n");
     6da:	00006517          	auipc	a0,0x6
     6de:	86650513          	addi	a0,a0,-1946 # 5f40 <l_free+0x4da>
     6e2:	00005097          	auipc	ra,0x5
     6e6:	162080e7          	jalr	354(ra) # 5844 <printf>
      exit(1);
     6ea:	4505                	li	a0,1
     6ec:	00005097          	auipc	ra,0x5
     6f0:	de0080e7          	jalr	-544(ra) # 54cc <exit>
      printf("pipe write failed\n");
     6f4:	00006517          	auipc	a0,0x6
     6f8:	8dc50513          	addi	a0,a0,-1828 # 5fd0 <l_free+0x56a>
     6fc:	00005097          	auipc	ra,0x5
     700:	148080e7          	jalr	328(ra) # 5844 <printf>
      exit(1);
     704:	4505                	li	a0,1
     706:	00005097          	auipc	ra,0x5
     70a:	dc6080e7          	jalr	-570(ra) # 54cc <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     70e:	862a                	mv	a2,a0
     710:	85ce                	mv	a1,s3
     712:	00006517          	auipc	a0,0x6
     716:	8d650513          	addi	a0,a0,-1834 # 5fe8 <l_free+0x582>
     71a:	00005097          	auipc	ra,0x5
     71e:	12a080e7          	jalr	298(ra) # 5844 <printf>
      exit(1);
     722:	4505                	li	a0,1
     724:	00005097          	auipc	ra,0x5
     728:	da8080e7          	jalr	-600(ra) # 54cc <exit>

000000000000072c <truncate1>:
void truncate1(char *s) {
     72c:	711d                	addi	sp,sp,-96
     72e:	ec86                	sd	ra,88(sp)
     730:	e8a2                	sd	s0,80(sp)
     732:	e4a6                	sd	s1,72(sp)
     734:	e0ca                	sd	s2,64(sp)
     736:	fc4e                	sd	s3,56(sp)
     738:	f852                	sd	s4,48(sp)
     73a:	f456                	sd	s5,40(sp)
     73c:	1080                	addi	s0,sp,96
     73e:	8aaa                	mv	s5,a0
  unlink("truncfile");
     740:	00005517          	auipc	a0,0x5
     744:	6d050513          	addi	a0,a0,1744 # 5e10 <l_free+0x3aa>
     748:	00005097          	auipc	ra,0x5
     74c:	dd4080e7          	jalr	-556(ra) # 551c <unlink>
  int fd1 = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
     750:	60100593          	li	a1,1537
     754:	00005517          	auipc	a0,0x5
     758:	6bc50513          	addi	a0,a0,1724 # 5e10 <l_free+0x3aa>
     75c:	00005097          	auipc	ra,0x5
     760:	db0080e7          	jalr	-592(ra) # 550c <open>
     764:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     766:	4611                	li	a2,4
     768:	00005597          	auipc	a1,0x5
     76c:	6b858593          	addi	a1,a1,1720 # 5e20 <l_free+0x3ba>
     770:	00005097          	auipc	ra,0x5
     774:	d7c080e7          	jalr	-644(ra) # 54ec <write>
  close(fd1);
     778:	8526                	mv	a0,s1
     77a:	00005097          	auipc	ra,0x5
     77e:	d7a080e7          	jalr	-646(ra) # 54f4 <close>
  int fd2 = open("truncfile", O_RDONLY);
     782:	4581                	li	a1,0
     784:	00005517          	auipc	a0,0x5
     788:	68c50513          	addi	a0,a0,1676 # 5e10 <l_free+0x3aa>
     78c:	00005097          	auipc	ra,0x5
     790:	d80080e7          	jalr	-640(ra) # 550c <open>
     794:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     796:	02000613          	li	a2,32
     79a:	fa040593          	addi	a1,s0,-96
     79e:	00005097          	auipc	ra,0x5
     7a2:	d46080e7          	jalr	-698(ra) # 54e4 <read>
  if (n != 4) {
     7a6:	4791                	li	a5,4
     7a8:	0cf51e63          	bne	a0,a5,884 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY | O_TRUNC);
     7ac:	40100593          	li	a1,1025
     7b0:	00005517          	auipc	a0,0x5
     7b4:	66050513          	addi	a0,a0,1632 # 5e10 <l_free+0x3aa>
     7b8:	00005097          	auipc	ra,0x5
     7bc:	d54080e7          	jalr	-684(ra) # 550c <open>
     7c0:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     7c2:	4581                	li	a1,0
     7c4:	00005517          	auipc	a0,0x5
     7c8:	64c50513          	addi	a0,a0,1612 # 5e10 <l_free+0x3aa>
     7cc:	00005097          	auipc	ra,0x5
     7d0:	d40080e7          	jalr	-704(ra) # 550c <open>
     7d4:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     7d6:	02000613          	li	a2,32
     7da:	fa040593          	addi	a1,s0,-96
     7de:	00005097          	auipc	ra,0x5
     7e2:	d06080e7          	jalr	-762(ra) # 54e4 <read>
     7e6:	8a2a                	mv	s4,a0
  if (n != 0) {
     7e8:	ed4d                	bnez	a0,8a2 <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     7ea:	02000613          	li	a2,32
     7ee:	fa040593          	addi	a1,s0,-96
     7f2:	8526                	mv	a0,s1
     7f4:	00005097          	auipc	ra,0x5
     7f8:	cf0080e7          	jalr	-784(ra) # 54e4 <read>
     7fc:	8a2a                	mv	s4,a0
  if (n != 0) {
     7fe:	e971                	bnez	a0,8d2 <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     800:	4619                	li	a2,6
     802:	00006597          	auipc	a1,0x6
     806:	87658593          	addi	a1,a1,-1930 # 6078 <l_free+0x612>
     80a:	854e                	mv	a0,s3
     80c:	00005097          	auipc	ra,0x5
     810:	ce0080e7          	jalr	-800(ra) # 54ec <write>
  n = read(fd3, buf, sizeof(buf));
     814:	02000613          	li	a2,32
     818:	fa040593          	addi	a1,s0,-96
     81c:	854a                	mv	a0,s2
     81e:	00005097          	auipc	ra,0x5
     822:	cc6080e7          	jalr	-826(ra) # 54e4 <read>
  if (n != 6) {
     826:	4799                	li	a5,6
     828:	0cf51d63          	bne	a0,a5,902 <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     82c:	02000613          	li	a2,32
     830:	fa040593          	addi	a1,s0,-96
     834:	8526                	mv	a0,s1
     836:	00005097          	auipc	ra,0x5
     83a:	cae080e7          	jalr	-850(ra) # 54e4 <read>
  if (n != 2) {
     83e:	4789                	li	a5,2
     840:	0ef51063          	bne	a0,a5,920 <truncate1+0x1f4>
  unlink("truncfile");
     844:	00005517          	auipc	a0,0x5
     848:	5cc50513          	addi	a0,a0,1484 # 5e10 <l_free+0x3aa>
     84c:	00005097          	auipc	ra,0x5
     850:	cd0080e7          	jalr	-816(ra) # 551c <unlink>
  close(fd1);
     854:	854e                	mv	a0,s3
     856:	00005097          	auipc	ra,0x5
     85a:	c9e080e7          	jalr	-866(ra) # 54f4 <close>
  close(fd2);
     85e:	8526                	mv	a0,s1
     860:	00005097          	auipc	ra,0x5
     864:	c94080e7          	jalr	-876(ra) # 54f4 <close>
  close(fd3);
     868:	854a                	mv	a0,s2
     86a:	00005097          	auipc	ra,0x5
     86e:	c8a080e7          	jalr	-886(ra) # 54f4 <close>
}
     872:	60e6                	ld	ra,88(sp)
     874:	6446                	ld	s0,80(sp)
     876:	64a6                	ld	s1,72(sp)
     878:	6906                	ld	s2,64(sp)
     87a:	79e2                	ld	s3,56(sp)
     87c:	7a42                	ld	s4,48(sp)
     87e:	7aa2                	ld	s5,40(sp)
     880:	6125                	addi	sp,sp,96
     882:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     884:	862a                	mv	a2,a0
     886:	85d6                	mv	a1,s5
     888:	00005517          	auipc	a0,0x5
     88c:	79050513          	addi	a0,a0,1936 # 6018 <l_free+0x5b2>
     890:	00005097          	auipc	ra,0x5
     894:	fb4080e7          	jalr	-76(ra) # 5844 <printf>
    exit(1);
     898:	4505                	li	a0,1
     89a:	00005097          	auipc	ra,0x5
     89e:	c32080e7          	jalr	-974(ra) # 54cc <exit>
    printf("aaa fd3=%d\n", fd3);
     8a2:	85ca                	mv	a1,s2
     8a4:	00005517          	auipc	a0,0x5
     8a8:	79450513          	addi	a0,a0,1940 # 6038 <l_free+0x5d2>
     8ac:	00005097          	auipc	ra,0x5
     8b0:	f98080e7          	jalr	-104(ra) # 5844 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     8b4:	8652                	mv	a2,s4
     8b6:	85d6                	mv	a1,s5
     8b8:	00005517          	auipc	a0,0x5
     8bc:	79050513          	addi	a0,a0,1936 # 6048 <l_free+0x5e2>
     8c0:	00005097          	auipc	ra,0x5
     8c4:	f84080e7          	jalr	-124(ra) # 5844 <printf>
    exit(1);
     8c8:	4505                	li	a0,1
     8ca:	00005097          	auipc	ra,0x5
     8ce:	c02080e7          	jalr	-1022(ra) # 54cc <exit>
    printf("bbb fd2=%d\n", fd2);
     8d2:	85a6                	mv	a1,s1
     8d4:	00005517          	auipc	a0,0x5
     8d8:	79450513          	addi	a0,a0,1940 # 6068 <l_free+0x602>
     8dc:	00005097          	auipc	ra,0x5
     8e0:	f68080e7          	jalr	-152(ra) # 5844 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     8e4:	8652                	mv	a2,s4
     8e6:	85d6                	mv	a1,s5
     8e8:	00005517          	auipc	a0,0x5
     8ec:	76050513          	addi	a0,a0,1888 # 6048 <l_free+0x5e2>
     8f0:	00005097          	auipc	ra,0x5
     8f4:	f54080e7          	jalr	-172(ra) # 5844 <printf>
    exit(1);
     8f8:	4505                	li	a0,1
     8fa:	00005097          	auipc	ra,0x5
     8fe:	bd2080e7          	jalr	-1070(ra) # 54cc <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     902:	862a                	mv	a2,a0
     904:	85d6                	mv	a1,s5
     906:	00005517          	auipc	a0,0x5
     90a:	77a50513          	addi	a0,a0,1914 # 6080 <l_free+0x61a>
     90e:	00005097          	auipc	ra,0x5
     912:	f36080e7          	jalr	-202(ra) # 5844 <printf>
    exit(1);
     916:	4505                	li	a0,1
     918:	00005097          	auipc	ra,0x5
     91c:	bb4080e7          	jalr	-1100(ra) # 54cc <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     920:	862a                	mv	a2,a0
     922:	85d6                	mv	a1,s5
     924:	00005517          	auipc	a0,0x5
     928:	77c50513          	addi	a0,a0,1916 # 60a0 <l_free+0x63a>
     92c:	00005097          	auipc	ra,0x5
     930:	f18080e7          	jalr	-232(ra) # 5844 <printf>
    exit(1);
     934:	4505                	li	a0,1
     936:	00005097          	auipc	ra,0x5
     93a:	b96080e7          	jalr	-1130(ra) # 54cc <exit>

000000000000093e <writetest>:
void writetest(char *s) {
     93e:	7139                	addi	sp,sp,-64
     940:	fc06                	sd	ra,56(sp)
     942:	f822                	sd	s0,48(sp)
     944:	f426                	sd	s1,40(sp)
     946:	f04a                	sd	s2,32(sp)
     948:	ec4e                	sd	s3,24(sp)
     94a:	e852                	sd	s4,16(sp)
     94c:	e456                	sd	s5,8(sp)
     94e:	e05a                	sd	s6,0(sp)
     950:	0080                	addi	s0,sp,64
     952:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE | O_RDWR);
     954:	20200593          	li	a1,514
     958:	00005517          	auipc	a0,0x5
     95c:	76850513          	addi	a0,a0,1896 # 60c0 <l_free+0x65a>
     960:	00005097          	auipc	ra,0x5
     964:	bac080e7          	jalr	-1108(ra) # 550c <open>
  if (fd < 0) {
     968:	0a054d63          	bltz	a0,a22 <writetest+0xe4>
     96c:	892a                	mv	s2,a0
     96e:	4481                	li	s1,0
    if (write(fd, "aaaaaaaaaa", SZ) != SZ) {
     970:	00005997          	auipc	s3,0x5
     974:	77898993          	addi	s3,s3,1912 # 60e8 <l_free+0x682>
    if (write(fd, "bbbbbbbbbb", SZ) != SZ) {
     978:	00005a97          	auipc	s5,0x5
     97c:	7a8a8a93          	addi	s5,s5,1960 # 6120 <l_free+0x6ba>
  for (i = 0; i < N; i++) {
     980:	06400a13          	li	s4,100
    if (write(fd, "aaaaaaaaaa", SZ) != SZ) {
     984:	4629                	li	a2,10
     986:	85ce                	mv	a1,s3
     988:	854a                	mv	a0,s2
     98a:	00005097          	auipc	ra,0x5
     98e:	b62080e7          	jalr	-1182(ra) # 54ec <write>
     992:	47a9                	li	a5,10
     994:	0af51563          	bne	a0,a5,a3e <writetest+0x100>
    if (write(fd, "bbbbbbbbbb", SZ) != SZ) {
     998:	4629                	li	a2,10
     99a:	85d6                	mv	a1,s5
     99c:	854a                	mv	a0,s2
     99e:	00005097          	auipc	ra,0x5
     9a2:	b4e080e7          	jalr	-1202(ra) # 54ec <write>
     9a6:	47a9                	li	a5,10
     9a8:	0af51963          	bne	a0,a5,a5a <writetest+0x11c>
  for (i = 0; i < N; i++) {
     9ac:	2485                	addiw	s1,s1,1
     9ae:	fd449be3          	bne	s1,s4,984 <writetest+0x46>
  close(fd);
     9b2:	854a                	mv	a0,s2
     9b4:	00005097          	auipc	ra,0x5
     9b8:	b40080e7          	jalr	-1216(ra) # 54f4 <close>
  fd = open("small", O_RDONLY);
     9bc:	4581                	li	a1,0
     9be:	00005517          	auipc	a0,0x5
     9c2:	70250513          	addi	a0,a0,1794 # 60c0 <l_free+0x65a>
     9c6:	00005097          	auipc	ra,0x5
     9ca:	b46080e7          	jalr	-1210(ra) # 550c <open>
     9ce:	84aa                	mv	s1,a0
  if (fd < 0) {
     9d0:	0a054363          	bltz	a0,a76 <writetest+0x138>
  i = read(fd, buf, N * SZ * 2);
     9d4:	7d000613          	li	a2,2000
     9d8:	0000b597          	auipc	a1,0xb
     9dc:	fe058593          	addi	a1,a1,-32 # b9b8 <buf>
     9e0:	00005097          	auipc	ra,0x5
     9e4:	b04080e7          	jalr	-1276(ra) # 54e4 <read>
  if (i != N * SZ * 2) {
     9e8:	7d000793          	li	a5,2000
     9ec:	0af51363          	bne	a0,a5,a92 <writetest+0x154>
  close(fd);
     9f0:	8526                	mv	a0,s1
     9f2:	00005097          	auipc	ra,0x5
     9f6:	b02080e7          	jalr	-1278(ra) # 54f4 <close>
  if (unlink("small") < 0) {
     9fa:	00005517          	auipc	a0,0x5
     9fe:	6c650513          	addi	a0,a0,1734 # 60c0 <l_free+0x65a>
     a02:	00005097          	auipc	ra,0x5
     a06:	b1a080e7          	jalr	-1254(ra) # 551c <unlink>
     a0a:	0a054263          	bltz	a0,aae <writetest+0x170>
}
     a0e:	70e2                	ld	ra,56(sp)
     a10:	7442                	ld	s0,48(sp)
     a12:	74a2                	ld	s1,40(sp)
     a14:	7902                	ld	s2,32(sp)
     a16:	69e2                	ld	s3,24(sp)
     a18:	6a42                	ld	s4,16(sp)
     a1a:	6aa2                	ld	s5,8(sp)
     a1c:	6b02                	ld	s6,0(sp)
     a1e:	6121                	addi	sp,sp,64
     a20:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     a22:	85da                	mv	a1,s6
     a24:	00005517          	auipc	a0,0x5
     a28:	6a450513          	addi	a0,a0,1700 # 60c8 <l_free+0x662>
     a2c:	00005097          	auipc	ra,0x5
     a30:	e18080e7          	jalr	-488(ra) # 5844 <printf>
    exit(1);
     a34:	4505                	li	a0,1
     a36:	00005097          	auipc	ra,0x5
     a3a:	a96080e7          	jalr	-1386(ra) # 54cc <exit>
      printf("%s: error: write aa %d new file failed\n", i);
     a3e:	85a6                	mv	a1,s1
     a40:	00005517          	auipc	a0,0x5
     a44:	6b850513          	addi	a0,a0,1720 # 60f8 <l_free+0x692>
     a48:	00005097          	auipc	ra,0x5
     a4c:	dfc080e7          	jalr	-516(ra) # 5844 <printf>
      exit(1);
     a50:	4505                	li	a0,1
     a52:	00005097          	auipc	ra,0x5
     a56:	a7a080e7          	jalr	-1414(ra) # 54cc <exit>
      printf("%s: error: write bb %d new file failed\n", i);
     a5a:	85a6                	mv	a1,s1
     a5c:	00005517          	auipc	a0,0x5
     a60:	6d450513          	addi	a0,a0,1748 # 6130 <l_free+0x6ca>
     a64:	00005097          	auipc	ra,0x5
     a68:	de0080e7          	jalr	-544(ra) # 5844 <printf>
      exit(1);
     a6c:	4505                	li	a0,1
     a6e:	00005097          	auipc	ra,0x5
     a72:	a5e080e7          	jalr	-1442(ra) # 54cc <exit>
    printf("%s: error: open small failed!\n", s);
     a76:	85da                	mv	a1,s6
     a78:	00005517          	auipc	a0,0x5
     a7c:	6e050513          	addi	a0,a0,1760 # 6158 <l_free+0x6f2>
     a80:	00005097          	auipc	ra,0x5
     a84:	dc4080e7          	jalr	-572(ra) # 5844 <printf>
    exit(1);
     a88:	4505                	li	a0,1
     a8a:	00005097          	auipc	ra,0x5
     a8e:	a42080e7          	jalr	-1470(ra) # 54cc <exit>
    printf("%s: read failed\n", s);
     a92:	85da                	mv	a1,s6
     a94:	00005517          	auipc	a0,0x5
     a98:	6e450513          	addi	a0,a0,1764 # 6178 <l_free+0x712>
     a9c:	00005097          	auipc	ra,0x5
     aa0:	da8080e7          	jalr	-600(ra) # 5844 <printf>
    exit(1);
     aa4:	4505                	li	a0,1
     aa6:	00005097          	auipc	ra,0x5
     aaa:	a26080e7          	jalr	-1498(ra) # 54cc <exit>
    printf("%s: unlink small failed\n", s);
     aae:	85da                	mv	a1,s6
     ab0:	00005517          	auipc	a0,0x5
     ab4:	6e050513          	addi	a0,a0,1760 # 6190 <l_free+0x72a>
     ab8:	00005097          	auipc	ra,0x5
     abc:	d8c080e7          	jalr	-628(ra) # 5844 <printf>
    exit(1);
     ac0:	4505                	li	a0,1
     ac2:	00005097          	auipc	ra,0x5
     ac6:	a0a080e7          	jalr	-1526(ra) # 54cc <exit>

0000000000000aca <unlinkread>:
void unlinkread(char *s) {
     aca:	7179                	addi	sp,sp,-48
     acc:	f406                	sd	ra,40(sp)
     ace:	f022                	sd	s0,32(sp)
     ad0:	ec26                	sd	s1,24(sp)
     ad2:	e84a                	sd	s2,16(sp)
     ad4:	e44e                	sd	s3,8(sp)
     ad6:	1800                	addi	s0,sp,48
     ad8:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     ada:	20200593          	li	a1,514
     ade:	00005517          	auipc	a0,0x5
     ae2:	0fa50513          	addi	a0,a0,250 # 5bd8 <l_free+0x172>
     ae6:	00005097          	auipc	ra,0x5
     aea:	a26080e7          	jalr	-1498(ra) # 550c <open>
  if (fd < 0) {
     aee:	0e054563          	bltz	a0,bd8 <unlinkread+0x10e>
     af2:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     af4:	4615                	li	a2,5
     af6:	00005597          	auipc	a1,0x5
     afa:	6da58593          	addi	a1,a1,1754 # 61d0 <l_free+0x76a>
     afe:	00005097          	auipc	ra,0x5
     b02:	9ee080e7          	jalr	-1554(ra) # 54ec <write>
  close(fd);
     b06:	8526                	mv	a0,s1
     b08:	00005097          	auipc	ra,0x5
     b0c:	9ec080e7          	jalr	-1556(ra) # 54f4 <close>
  fd = open("unlinkread", O_RDWR);
     b10:	4589                	li	a1,2
     b12:	00005517          	auipc	a0,0x5
     b16:	0c650513          	addi	a0,a0,198 # 5bd8 <l_free+0x172>
     b1a:	00005097          	auipc	ra,0x5
     b1e:	9f2080e7          	jalr	-1550(ra) # 550c <open>
     b22:	84aa                	mv	s1,a0
  if (fd < 0) {
     b24:	0c054863          	bltz	a0,bf4 <unlinkread+0x12a>
  if (unlink("unlinkread") != 0) {
     b28:	00005517          	auipc	a0,0x5
     b2c:	0b050513          	addi	a0,a0,176 # 5bd8 <l_free+0x172>
     b30:	00005097          	auipc	ra,0x5
     b34:	9ec080e7          	jalr	-1556(ra) # 551c <unlink>
     b38:	ed61                	bnez	a0,c10 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     b3a:	20200593          	li	a1,514
     b3e:	00005517          	auipc	a0,0x5
     b42:	09a50513          	addi	a0,a0,154 # 5bd8 <l_free+0x172>
     b46:	00005097          	auipc	ra,0x5
     b4a:	9c6080e7          	jalr	-1594(ra) # 550c <open>
     b4e:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     b50:	460d                	li	a2,3
     b52:	00005597          	auipc	a1,0x5
     b56:	6c658593          	addi	a1,a1,1734 # 6218 <l_free+0x7b2>
     b5a:	00005097          	auipc	ra,0x5
     b5e:	992080e7          	jalr	-1646(ra) # 54ec <write>
  close(fd1);
     b62:	854a                	mv	a0,s2
     b64:	00005097          	auipc	ra,0x5
     b68:	990080e7          	jalr	-1648(ra) # 54f4 <close>
  if (read(fd, buf, sizeof(buf)) != SZ) {
     b6c:	660d                	lui	a2,0x3
     b6e:	0000b597          	auipc	a1,0xb
     b72:	e4a58593          	addi	a1,a1,-438 # b9b8 <buf>
     b76:	8526                	mv	a0,s1
     b78:	00005097          	auipc	ra,0x5
     b7c:	96c080e7          	jalr	-1684(ra) # 54e4 <read>
     b80:	4795                	li	a5,5
     b82:	0af51563          	bne	a0,a5,c2c <unlinkread+0x162>
  if (buf[0] != 'h') {
     b86:	0000b717          	auipc	a4,0xb
     b8a:	e3274703          	lbu	a4,-462(a4) # b9b8 <buf>
     b8e:	06800793          	li	a5,104
     b92:	0af71b63          	bne	a4,a5,c48 <unlinkread+0x17e>
  if (write(fd, buf, 10) != 10) {
     b96:	4629                	li	a2,10
     b98:	0000b597          	auipc	a1,0xb
     b9c:	e2058593          	addi	a1,a1,-480 # b9b8 <buf>
     ba0:	8526                	mv	a0,s1
     ba2:	00005097          	auipc	ra,0x5
     ba6:	94a080e7          	jalr	-1718(ra) # 54ec <write>
     baa:	47a9                	li	a5,10
     bac:	0af51c63          	bne	a0,a5,c64 <unlinkread+0x19a>
  close(fd);
     bb0:	8526                	mv	a0,s1
     bb2:	00005097          	auipc	ra,0x5
     bb6:	942080e7          	jalr	-1726(ra) # 54f4 <close>
  unlink("unlinkread");
     bba:	00005517          	auipc	a0,0x5
     bbe:	01e50513          	addi	a0,a0,30 # 5bd8 <l_free+0x172>
     bc2:	00005097          	auipc	ra,0x5
     bc6:	95a080e7          	jalr	-1702(ra) # 551c <unlink>
}
     bca:	70a2                	ld	ra,40(sp)
     bcc:	7402                	ld	s0,32(sp)
     bce:	64e2                	ld	s1,24(sp)
     bd0:	6942                	ld	s2,16(sp)
     bd2:	69a2                	ld	s3,8(sp)
     bd4:	6145                	addi	sp,sp,48
     bd6:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     bd8:	85ce                	mv	a1,s3
     bda:	00005517          	auipc	a0,0x5
     bde:	5d650513          	addi	a0,a0,1494 # 61b0 <l_free+0x74a>
     be2:	00005097          	auipc	ra,0x5
     be6:	c62080e7          	jalr	-926(ra) # 5844 <printf>
    exit(1);
     bea:	4505                	li	a0,1
     bec:	00005097          	auipc	ra,0x5
     bf0:	8e0080e7          	jalr	-1824(ra) # 54cc <exit>
    printf("%s: open unlinkread failed\n", s);
     bf4:	85ce                	mv	a1,s3
     bf6:	00005517          	auipc	a0,0x5
     bfa:	5e250513          	addi	a0,a0,1506 # 61d8 <l_free+0x772>
     bfe:	00005097          	auipc	ra,0x5
     c02:	c46080e7          	jalr	-954(ra) # 5844 <printf>
    exit(1);
     c06:	4505                	li	a0,1
     c08:	00005097          	auipc	ra,0x5
     c0c:	8c4080e7          	jalr	-1852(ra) # 54cc <exit>
    printf("%s: unlink unlinkread failed\n", s);
     c10:	85ce                	mv	a1,s3
     c12:	00005517          	auipc	a0,0x5
     c16:	5e650513          	addi	a0,a0,1510 # 61f8 <l_free+0x792>
     c1a:	00005097          	auipc	ra,0x5
     c1e:	c2a080e7          	jalr	-982(ra) # 5844 <printf>
    exit(1);
     c22:	4505                	li	a0,1
     c24:	00005097          	auipc	ra,0x5
     c28:	8a8080e7          	jalr	-1880(ra) # 54cc <exit>
    printf("%s: unlinkread read failed", s);
     c2c:	85ce                	mv	a1,s3
     c2e:	00005517          	auipc	a0,0x5
     c32:	5f250513          	addi	a0,a0,1522 # 6220 <l_free+0x7ba>
     c36:	00005097          	auipc	ra,0x5
     c3a:	c0e080e7          	jalr	-1010(ra) # 5844 <printf>
    exit(1);
     c3e:	4505                	li	a0,1
     c40:	00005097          	auipc	ra,0x5
     c44:	88c080e7          	jalr	-1908(ra) # 54cc <exit>
    printf("%s: unlinkread wrong data\n", s);
     c48:	85ce                	mv	a1,s3
     c4a:	00005517          	auipc	a0,0x5
     c4e:	5f650513          	addi	a0,a0,1526 # 6240 <l_free+0x7da>
     c52:	00005097          	auipc	ra,0x5
     c56:	bf2080e7          	jalr	-1038(ra) # 5844 <printf>
    exit(1);
     c5a:	4505                	li	a0,1
     c5c:	00005097          	auipc	ra,0x5
     c60:	870080e7          	jalr	-1936(ra) # 54cc <exit>
    printf("%s: unlinkread write failed\n", s);
     c64:	85ce                	mv	a1,s3
     c66:	00005517          	auipc	a0,0x5
     c6a:	5fa50513          	addi	a0,a0,1530 # 6260 <l_free+0x7fa>
     c6e:	00005097          	auipc	ra,0x5
     c72:	bd6080e7          	jalr	-1066(ra) # 5844 <printf>
    exit(1);
     c76:	4505                	li	a0,1
     c78:	00005097          	auipc	ra,0x5
     c7c:	854080e7          	jalr	-1964(ra) # 54cc <exit>

0000000000000c80 <linktest>:
void linktest(char *s) {
     c80:	1101                	addi	sp,sp,-32
     c82:	ec06                	sd	ra,24(sp)
     c84:	e822                	sd	s0,16(sp)
     c86:	e426                	sd	s1,8(sp)
     c88:	e04a                	sd	s2,0(sp)
     c8a:	1000                	addi	s0,sp,32
     c8c:	892a                	mv	s2,a0
  unlink("lf1");
     c8e:	00005517          	auipc	a0,0x5
     c92:	5f250513          	addi	a0,a0,1522 # 6280 <l_free+0x81a>
     c96:	00005097          	auipc	ra,0x5
     c9a:	886080e7          	jalr	-1914(ra) # 551c <unlink>
  unlink("lf2");
     c9e:	00005517          	auipc	a0,0x5
     ca2:	5ea50513          	addi	a0,a0,1514 # 6288 <l_free+0x822>
     ca6:	00005097          	auipc	ra,0x5
     caa:	876080e7          	jalr	-1930(ra) # 551c <unlink>
  fd = open("lf1", O_CREATE | O_RDWR);
     cae:	20200593          	li	a1,514
     cb2:	00005517          	auipc	a0,0x5
     cb6:	5ce50513          	addi	a0,a0,1486 # 6280 <l_free+0x81a>
     cba:	00005097          	auipc	ra,0x5
     cbe:	852080e7          	jalr	-1966(ra) # 550c <open>
  if (fd < 0) {
     cc2:	10054763          	bltz	a0,dd0 <linktest+0x150>
     cc6:	84aa                	mv	s1,a0
  if (write(fd, "hello", SZ) != SZ) {
     cc8:	4615                	li	a2,5
     cca:	00005597          	auipc	a1,0x5
     cce:	50658593          	addi	a1,a1,1286 # 61d0 <l_free+0x76a>
     cd2:	00005097          	auipc	ra,0x5
     cd6:	81a080e7          	jalr	-2022(ra) # 54ec <write>
     cda:	4795                	li	a5,5
     cdc:	10f51863          	bne	a0,a5,dec <linktest+0x16c>
  close(fd);
     ce0:	8526                	mv	a0,s1
     ce2:	00005097          	auipc	ra,0x5
     ce6:	812080e7          	jalr	-2030(ra) # 54f4 <close>
  if (link("lf1", "lf2") < 0) {
     cea:	00005597          	auipc	a1,0x5
     cee:	59e58593          	addi	a1,a1,1438 # 6288 <l_free+0x822>
     cf2:	00005517          	auipc	a0,0x5
     cf6:	58e50513          	addi	a0,a0,1422 # 6280 <l_free+0x81a>
     cfa:	00005097          	auipc	ra,0x5
     cfe:	832080e7          	jalr	-1998(ra) # 552c <link>
     d02:	10054363          	bltz	a0,e08 <linktest+0x188>
  unlink("lf1");
     d06:	00005517          	auipc	a0,0x5
     d0a:	57a50513          	addi	a0,a0,1402 # 6280 <l_free+0x81a>
     d0e:	00005097          	auipc	ra,0x5
     d12:	80e080e7          	jalr	-2034(ra) # 551c <unlink>
  if (open("lf1", 0) >= 0) {
     d16:	4581                	li	a1,0
     d18:	00005517          	auipc	a0,0x5
     d1c:	56850513          	addi	a0,a0,1384 # 6280 <l_free+0x81a>
     d20:	00004097          	auipc	ra,0x4
     d24:	7ec080e7          	jalr	2028(ra) # 550c <open>
     d28:	0e055e63          	bgez	a0,e24 <linktest+0x1a4>
  fd = open("lf2", 0);
     d2c:	4581                	li	a1,0
     d2e:	00005517          	auipc	a0,0x5
     d32:	55a50513          	addi	a0,a0,1370 # 6288 <l_free+0x822>
     d36:	00004097          	auipc	ra,0x4
     d3a:	7d6080e7          	jalr	2006(ra) # 550c <open>
     d3e:	84aa                	mv	s1,a0
  if (fd < 0) {
     d40:	10054063          	bltz	a0,e40 <linktest+0x1c0>
  if (read(fd, buf, sizeof(buf)) != SZ) {
     d44:	660d                	lui	a2,0x3
     d46:	0000b597          	auipc	a1,0xb
     d4a:	c7258593          	addi	a1,a1,-910 # b9b8 <buf>
     d4e:	00004097          	auipc	ra,0x4
     d52:	796080e7          	jalr	1942(ra) # 54e4 <read>
     d56:	4795                	li	a5,5
     d58:	10f51263          	bne	a0,a5,e5c <linktest+0x1dc>
  close(fd);
     d5c:	8526                	mv	a0,s1
     d5e:	00004097          	auipc	ra,0x4
     d62:	796080e7          	jalr	1942(ra) # 54f4 <close>
  if (link("lf2", "lf2") >= 0) {
     d66:	00005597          	auipc	a1,0x5
     d6a:	52258593          	addi	a1,a1,1314 # 6288 <l_free+0x822>
     d6e:	852e                	mv	a0,a1
     d70:	00004097          	auipc	ra,0x4
     d74:	7bc080e7          	jalr	1980(ra) # 552c <link>
     d78:	10055063          	bgez	a0,e78 <linktest+0x1f8>
  unlink("lf2");
     d7c:	00005517          	auipc	a0,0x5
     d80:	50c50513          	addi	a0,a0,1292 # 6288 <l_free+0x822>
     d84:	00004097          	auipc	ra,0x4
     d88:	798080e7          	jalr	1944(ra) # 551c <unlink>
  if (link("lf2", "lf1") >= 0) {
     d8c:	00005597          	auipc	a1,0x5
     d90:	4f458593          	addi	a1,a1,1268 # 6280 <l_free+0x81a>
     d94:	00005517          	auipc	a0,0x5
     d98:	4f450513          	addi	a0,a0,1268 # 6288 <l_free+0x822>
     d9c:	00004097          	auipc	ra,0x4
     da0:	790080e7          	jalr	1936(ra) # 552c <link>
     da4:	0e055863          	bgez	a0,e94 <linktest+0x214>
  if (link(".", "lf1") >= 0) {
     da8:	00005597          	auipc	a1,0x5
     dac:	4d858593          	addi	a1,a1,1240 # 6280 <l_free+0x81a>
     db0:	00005517          	auipc	a0,0x5
     db4:	5e050513          	addi	a0,a0,1504 # 6390 <l_free+0x92a>
     db8:	00004097          	auipc	ra,0x4
     dbc:	774080e7          	jalr	1908(ra) # 552c <link>
     dc0:	0e055863          	bgez	a0,eb0 <linktest+0x230>
}
     dc4:	60e2                	ld	ra,24(sp)
     dc6:	6442                	ld	s0,16(sp)
     dc8:	64a2                	ld	s1,8(sp)
     dca:	6902                	ld	s2,0(sp)
     dcc:	6105                	addi	sp,sp,32
     dce:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     dd0:	85ca                	mv	a1,s2
     dd2:	00005517          	auipc	a0,0x5
     dd6:	4be50513          	addi	a0,a0,1214 # 6290 <l_free+0x82a>
     dda:	00005097          	auipc	ra,0x5
     dde:	a6a080e7          	jalr	-1430(ra) # 5844 <printf>
    exit(1);
     de2:	4505                	li	a0,1
     de4:	00004097          	auipc	ra,0x4
     de8:	6e8080e7          	jalr	1768(ra) # 54cc <exit>
    printf("%s: write lf1 failed\n", s);
     dec:	85ca                	mv	a1,s2
     dee:	00005517          	auipc	a0,0x5
     df2:	4ba50513          	addi	a0,a0,1210 # 62a8 <l_free+0x842>
     df6:	00005097          	auipc	ra,0x5
     dfa:	a4e080e7          	jalr	-1458(ra) # 5844 <printf>
    exit(1);
     dfe:	4505                	li	a0,1
     e00:	00004097          	auipc	ra,0x4
     e04:	6cc080e7          	jalr	1740(ra) # 54cc <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     e08:	85ca                	mv	a1,s2
     e0a:	00005517          	auipc	a0,0x5
     e0e:	4b650513          	addi	a0,a0,1206 # 62c0 <l_free+0x85a>
     e12:	00005097          	auipc	ra,0x5
     e16:	a32080e7          	jalr	-1486(ra) # 5844 <printf>
    exit(1);
     e1a:	4505                	li	a0,1
     e1c:	00004097          	auipc	ra,0x4
     e20:	6b0080e7          	jalr	1712(ra) # 54cc <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     e24:	85ca                	mv	a1,s2
     e26:	00005517          	auipc	a0,0x5
     e2a:	4ba50513          	addi	a0,a0,1210 # 62e0 <l_free+0x87a>
     e2e:	00005097          	auipc	ra,0x5
     e32:	a16080e7          	jalr	-1514(ra) # 5844 <printf>
    exit(1);
     e36:	4505                	li	a0,1
     e38:	00004097          	auipc	ra,0x4
     e3c:	694080e7          	jalr	1684(ra) # 54cc <exit>
    printf("%s: open lf2 failed\n", s);
     e40:	85ca                	mv	a1,s2
     e42:	00005517          	auipc	a0,0x5
     e46:	4ce50513          	addi	a0,a0,1230 # 6310 <l_free+0x8aa>
     e4a:	00005097          	auipc	ra,0x5
     e4e:	9fa080e7          	jalr	-1542(ra) # 5844 <printf>
    exit(1);
     e52:	4505                	li	a0,1
     e54:	00004097          	auipc	ra,0x4
     e58:	678080e7          	jalr	1656(ra) # 54cc <exit>
    printf("%s: read lf2 failed\n", s);
     e5c:	85ca                	mv	a1,s2
     e5e:	00005517          	auipc	a0,0x5
     e62:	4ca50513          	addi	a0,a0,1226 # 6328 <l_free+0x8c2>
     e66:	00005097          	auipc	ra,0x5
     e6a:	9de080e7          	jalr	-1570(ra) # 5844 <printf>
    exit(1);
     e6e:	4505                	li	a0,1
     e70:	00004097          	auipc	ra,0x4
     e74:	65c080e7          	jalr	1628(ra) # 54cc <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     e78:	85ca                	mv	a1,s2
     e7a:	00005517          	auipc	a0,0x5
     e7e:	4c650513          	addi	a0,a0,1222 # 6340 <l_free+0x8da>
     e82:	00005097          	auipc	ra,0x5
     e86:	9c2080e7          	jalr	-1598(ra) # 5844 <printf>
    exit(1);
     e8a:	4505                	li	a0,1
     e8c:	00004097          	auipc	ra,0x4
     e90:	640080e7          	jalr	1600(ra) # 54cc <exit>
    printf("%s: link non-existant succeeded! oops\n", s);
     e94:	85ca                	mv	a1,s2
     e96:	00005517          	auipc	a0,0x5
     e9a:	4d250513          	addi	a0,a0,1234 # 6368 <l_free+0x902>
     e9e:	00005097          	auipc	ra,0x5
     ea2:	9a6080e7          	jalr	-1626(ra) # 5844 <printf>
    exit(1);
     ea6:	4505                	li	a0,1
     ea8:	00004097          	auipc	ra,0x4
     eac:	624080e7          	jalr	1572(ra) # 54cc <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     eb0:	85ca                	mv	a1,s2
     eb2:	00005517          	auipc	a0,0x5
     eb6:	4e650513          	addi	a0,a0,1254 # 6398 <l_free+0x932>
     eba:	00005097          	auipc	ra,0x5
     ebe:	98a080e7          	jalr	-1654(ra) # 5844 <printf>
    exit(1);
     ec2:	4505                	li	a0,1
     ec4:	00004097          	auipc	ra,0x4
     ec8:	608080e7          	jalr	1544(ra) # 54cc <exit>

0000000000000ecc <bigdir>:
void bigdir(char *s) {
     ecc:	715d                	addi	sp,sp,-80
     ece:	e486                	sd	ra,72(sp)
     ed0:	e0a2                	sd	s0,64(sp)
     ed2:	fc26                	sd	s1,56(sp)
     ed4:	f84a                	sd	s2,48(sp)
     ed6:	f44e                	sd	s3,40(sp)
     ed8:	f052                	sd	s4,32(sp)
     eda:	ec56                	sd	s5,24(sp)
     edc:	e85a                	sd	s6,16(sp)
     ede:	0880                	addi	s0,sp,80
     ee0:	89aa                	mv	s3,a0
  unlink("bd");
     ee2:	00005517          	auipc	a0,0x5
     ee6:	4d650513          	addi	a0,a0,1238 # 63b8 <l_free+0x952>
     eea:	00004097          	auipc	ra,0x4
     eee:	632080e7          	jalr	1586(ra) # 551c <unlink>
  fd = open("bd", O_CREATE);
     ef2:	20000593          	li	a1,512
     ef6:	00005517          	auipc	a0,0x5
     efa:	4c250513          	addi	a0,a0,1218 # 63b8 <l_free+0x952>
     efe:	00004097          	auipc	ra,0x4
     f02:	60e080e7          	jalr	1550(ra) # 550c <open>
  if (fd < 0) {
     f06:	0c054963          	bltz	a0,fd8 <bigdir+0x10c>
  close(fd);
     f0a:	00004097          	auipc	ra,0x4
     f0e:	5ea080e7          	jalr	1514(ra) # 54f4 <close>
  for (i = 0; i < N; i++) {
     f12:	4901                	li	s2,0
    name[0] = 'x';
     f14:	07800a93          	li	s5,120
    if (link("bd", name) != 0) {
     f18:	00005a17          	auipc	s4,0x5
     f1c:	4a0a0a13          	addi	s4,s4,1184 # 63b8 <l_free+0x952>
  for (i = 0; i < N; i++) {
     f20:	1f400b13          	li	s6,500
    name[0] = 'x';
     f24:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     f28:	41f9579b          	sraiw	a5,s2,0x1f
     f2c:	01a7d71b          	srliw	a4,a5,0x1a
     f30:	012707bb          	addw	a5,a4,s2
     f34:	4067d69b          	sraiw	a3,a5,0x6
     f38:	0306869b          	addiw	a3,a3,48
     f3c:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     f40:	03f7f793          	andi	a5,a5,63
     f44:	9f99                	subw	a5,a5,a4
     f46:	0307879b          	addiw	a5,a5,48
     f4a:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     f4e:	fa0409a3          	sb	zero,-77(s0)
    if (link("bd", name) != 0) {
     f52:	fb040593          	addi	a1,s0,-80
     f56:	8552                	mv	a0,s4
     f58:	00004097          	auipc	ra,0x4
     f5c:	5d4080e7          	jalr	1492(ra) # 552c <link>
     f60:	84aa                	mv	s1,a0
     f62:	e949                	bnez	a0,ff4 <bigdir+0x128>
  for (i = 0; i < N; i++) {
     f64:	2905                	addiw	s2,s2,1
     f66:	fb691fe3          	bne	s2,s6,f24 <bigdir+0x58>
  unlink("bd");
     f6a:	00005517          	auipc	a0,0x5
     f6e:	44e50513          	addi	a0,a0,1102 # 63b8 <l_free+0x952>
     f72:	00004097          	auipc	ra,0x4
     f76:	5aa080e7          	jalr	1450(ra) # 551c <unlink>
    name[0] = 'x';
     f7a:	07800913          	li	s2,120
  for (i = 0; i < N; i++) {
     f7e:	1f400a13          	li	s4,500
    name[0] = 'x';
     f82:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
     f86:	41f4d79b          	sraiw	a5,s1,0x1f
     f8a:	01a7d71b          	srliw	a4,a5,0x1a
     f8e:	009707bb          	addw	a5,a4,s1
     f92:	4067d69b          	sraiw	a3,a5,0x6
     f96:	0306869b          	addiw	a3,a3,48
     f9a:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     f9e:	03f7f793          	andi	a5,a5,63
     fa2:	9f99                	subw	a5,a5,a4
     fa4:	0307879b          	addiw	a5,a5,48
     fa8:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     fac:	fa0409a3          	sb	zero,-77(s0)
    if (unlink(name) != 0) {
     fb0:	fb040513          	addi	a0,s0,-80
     fb4:	00004097          	auipc	ra,0x4
     fb8:	568080e7          	jalr	1384(ra) # 551c <unlink>
     fbc:	ed21                	bnez	a0,1014 <bigdir+0x148>
  for (i = 0; i < N; i++) {
     fbe:	2485                	addiw	s1,s1,1
     fc0:	fd4491e3          	bne	s1,s4,f82 <bigdir+0xb6>
}
     fc4:	60a6                	ld	ra,72(sp)
     fc6:	6406                	ld	s0,64(sp)
     fc8:	74e2                	ld	s1,56(sp)
     fca:	7942                	ld	s2,48(sp)
     fcc:	79a2                	ld	s3,40(sp)
     fce:	7a02                	ld	s4,32(sp)
     fd0:	6ae2                	ld	s5,24(sp)
     fd2:	6b42                	ld	s6,16(sp)
     fd4:	6161                	addi	sp,sp,80
     fd6:	8082                	ret
    printf("%s: bigdir create failed\n", s);
     fd8:	85ce                	mv	a1,s3
     fda:	00005517          	auipc	a0,0x5
     fde:	3e650513          	addi	a0,a0,998 # 63c0 <l_free+0x95a>
     fe2:	00005097          	auipc	ra,0x5
     fe6:	862080e7          	jalr	-1950(ra) # 5844 <printf>
    exit(1);
     fea:	4505                	li	a0,1
     fec:	00004097          	auipc	ra,0x4
     ff0:	4e0080e7          	jalr	1248(ra) # 54cc <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
     ff4:	fb040613          	addi	a2,s0,-80
     ff8:	85ce                	mv	a1,s3
     ffa:	00005517          	auipc	a0,0x5
     ffe:	3e650513          	addi	a0,a0,998 # 63e0 <l_free+0x97a>
    1002:	00005097          	auipc	ra,0x5
    1006:	842080e7          	jalr	-1982(ra) # 5844 <printf>
      exit(1);
    100a:	4505                	li	a0,1
    100c:	00004097          	auipc	ra,0x4
    1010:	4c0080e7          	jalr	1216(ra) # 54cc <exit>
      printf("%s: bigdir unlink failed", s);
    1014:	85ce                	mv	a1,s3
    1016:	00005517          	auipc	a0,0x5
    101a:	3ea50513          	addi	a0,a0,1002 # 6400 <l_free+0x99a>
    101e:	00005097          	auipc	ra,0x5
    1022:	826080e7          	jalr	-2010(ra) # 5844 <printf>
      exit(1);
    1026:	4505                	li	a0,1
    1028:	00004097          	auipc	ra,0x4
    102c:	4a4080e7          	jalr	1188(ra) # 54cc <exit>

0000000000001030 <validatetest>:
void validatetest(char *s) {
    1030:	7139                	addi	sp,sp,-64
    1032:	fc06                	sd	ra,56(sp)
    1034:	f822                	sd	s0,48(sp)
    1036:	f426                	sd	s1,40(sp)
    1038:	f04a                	sd	s2,32(sp)
    103a:	ec4e                	sd	s3,24(sp)
    103c:	e852                	sd	s4,16(sp)
    103e:	e456                	sd	s5,8(sp)
    1040:	e05a                	sd	s6,0(sp)
    1042:	0080                	addi	s0,sp,64
    1044:	8b2a                	mv	s6,a0
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
    1046:	4481                	li	s1,0
    if (link("nosuchfile", (char *)p) != -1) {
    1048:	00005997          	auipc	s3,0x5
    104c:	3d898993          	addi	s3,s3,984 # 6420 <l_free+0x9ba>
    1050:	597d                	li	s2,-1
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
    1052:	6a85                	lui	s5,0x1
    1054:	00114a37          	lui	s4,0x114
    if (link("nosuchfile", (char *)p) != -1) {
    1058:	85a6                	mv	a1,s1
    105a:	854e                	mv	a0,s3
    105c:	00004097          	auipc	ra,0x4
    1060:	4d0080e7          	jalr	1232(ra) # 552c <link>
    1064:	01251f63          	bne	a0,s2,1082 <validatetest+0x52>
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
    1068:	94d6                	add	s1,s1,s5
    106a:	ff4497e3          	bne	s1,s4,1058 <validatetest+0x28>
}
    106e:	70e2                	ld	ra,56(sp)
    1070:	7442                	ld	s0,48(sp)
    1072:	74a2                	ld	s1,40(sp)
    1074:	7902                	ld	s2,32(sp)
    1076:	69e2                	ld	s3,24(sp)
    1078:	6a42                	ld	s4,16(sp)
    107a:	6aa2                	ld	s5,8(sp)
    107c:	6b02                	ld	s6,0(sp)
    107e:	6121                	addi	sp,sp,64
    1080:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1082:	85da                	mv	a1,s6
    1084:	00005517          	auipc	a0,0x5
    1088:	3ac50513          	addi	a0,a0,940 # 6430 <l_free+0x9ca>
    108c:	00004097          	auipc	ra,0x4
    1090:	7b8080e7          	jalr	1976(ra) # 5844 <printf>
      exit(1);
    1094:	4505                	li	a0,1
    1096:	00004097          	auipc	ra,0x4
    109a:	436080e7          	jalr	1078(ra) # 54cc <exit>

000000000000109e <pgbug>:
void pgbug(char *s) {
    109e:	7179                	addi	sp,sp,-48
    10a0:	f406                	sd	ra,40(sp)
    10a2:	f022                	sd	s0,32(sp)
    10a4:	ec26                	sd	s1,24(sp)
    10a6:	1800                	addi	s0,sp,48
  argv[0] = 0;
    10a8:	fc043c23          	sd	zero,-40(s0)
  exec((char *)0xeaeb0b5b00002f5e, argv);
    10ac:	00007497          	auipc	s1,0x7
    10b0:	0c44b483          	ld	s1,196(s1) # 8170 <__SDATA_BEGIN__>
    10b4:	fd840593          	addi	a1,s0,-40
    10b8:	8526                	mv	a0,s1
    10ba:	00004097          	auipc	ra,0x4
    10be:	44a080e7          	jalr	1098(ra) # 5504 <exec>
  pipe((int *)0xeaeb0b5b00002f5e);
    10c2:	8526                	mv	a0,s1
    10c4:	00004097          	auipc	ra,0x4
    10c8:	418080e7          	jalr	1048(ra) # 54dc <pipe>
  exit(0);
    10cc:	4501                	li	a0,0
    10ce:	00004097          	auipc	ra,0x4
    10d2:	3fe080e7          	jalr	1022(ra) # 54cc <exit>

00000000000010d6 <badarg>:
}

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void badarg(char *s) {
    10d6:	7139                	addi	sp,sp,-64
    10d8:	fc06                	sd	ra,56(sp)
    10da:	f822                	sd	s0,48(sp)
    10dc:	f426                	sd	s1,40(sp)
    10de:	f04a                	sd	s2,32(sp)
    10e0:	ec4e                	sd	s3,24(sp)
    10e2:	0080                	addi	s0,sp,64
    10e4:	64b1                	lui	s1,0xc
    10e6:	35048493          	addi	s1,s1,848 # c350 <buf+0x998>
  for (int i = 0; i < 50000; i++) {
    char *argv[2];
    argv[0] = (char *)0xffffffff;
    10ea:	597d                	li	s2,-1
    10ec:	02095913          	srli	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    10f0:	00005997          	auipc	s3,0x5
    10f4:	cc898993          	addi	s3,s3,-824 # 5db8 <l_free+0x352>
    argv[0] = (char *)0xffffffff;
    10f8:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    10fc:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1100:	fc040593          	addi	a1,s0,-64
    1104:	854e                	mv	a0,s3
    1106:	00004097          	auipc	ra,0x4
    110a:	3fe080e7          	jalr	1022(ra) # 5504 <exec>
  for (int i = 0; i < 50000; i++) {
    110e:	34fd                	addiw	s1,s1,-1
    1110:	f4e5                	bnez	s1,10f8 <badarg+0x22>
  }

  exit(0);
    1112:	4501                	li	a0,0
    1114:	00004097          	auipc	ra,0x4
    1118:	3b8080e7          	jalr	952(ra) # 54cc <exit>

000000000000111c <copyinstr2>:
void copyinstr2(char *s) {
    111c:	7155                	addi	sp,sp,-208
    111e:	e586                	sd	ra,200(sp)
    1120:	e1a2                	sd	s0,192(sp)
    1122:	0980                	addi	s0,sp,208
  for (int i = 0; i < MAXPATH; i++)
    1124:	f6840793          	addi	a5,s0,-152
    1128:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    112c:	07800713          	li	a4,120
    1130:	00e78023          	sb	a4,0(a5)
  for (int i = 0; i < MAXPATH; i++)
    1134:	0785                	addi	a5,a5,1
    1136:	fed79de3          	bne	a5,a3,1130 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    113a:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    113e:	f6840513          	addi	a0,s0,-152
    1142:	00004097          	auipc	ra,0x4
    1146:	3da080e7          	jalr	986(ra) # 551c <unlink>
  if (ret != -1) {
    114a:	57fd                	li	a5,-1
    114c:	0ef51063          	bne	a0,a5,122c <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    1150:	20100593          	li	a1,513
    1154:	f6840513          	addi	a0,s0,-152
    1158:	00004097          	auipc	ra,0x4
    115c:	3b4080e7          	jalr	948(ra) # 550c <open>
  if (fd != -1) {
    1160:	57fd                	li	a5,-1
    1162:	0ef51563          	bne	a0,a5,124c <copyinstr2+0x130>
  ret = link(b, b);
    1166:	f6840593          	addi	a1,s0,-152
    116a:	852e                	mv	a0,a1
    116c:	00004097          	auipc	ra,0x4
    1170:	3c0080e7          	jalr	960(ra) # 552c <link>
  if (ret != -1) {
    1174:	57fd                	li	a5,-1
    1176:	0ef51b63          	bne	a0,a5,126c <copyinstr2+0x150>
  char *args[] = {"xx", 0};
    117a:	00006797          	auipc	a5,0x6
    117e:	37e78793          	addi	a5,a5,894 # 74f8 <l_free+0x1a92>
    1182:	f4f43c23          	sd	a5,-168(s0)
    1186:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    118a:	f5840593          	addi	a1,s0,-168
    118e:	f6840513          	addi	a0,s0,-152
    1192:	00004097          	auipc	ra,0x4
    1196:	372080e7          	jalr	882(ra) # 5504 <exec>
  if (ret != -1) {
    119a:	57fd                	li	a5,-1
    119c:	0ef51963          	bne	a0,a5,128e <copyinstr2+0x172>
  int pid = fork();
    11a0:	00004097          	auipc	ra,0x4
    11a4:	324080e7          	jalr	804(ra) # 54c4 <fork>
  if (pid < 0) {
    11a8:	10054363          	bltz	a0,12ae <copyinstr2+0x192>
  if (pid == 0) {
    11ac:	12051463          	bnez	a0,12d4 <copyinstr2+0x1b8>
    11b0:	00007797          	auipc	a5,0x7
    11b4:	0f078793          	addi	a5,a5,240 # 82a0 <big.0>
    11b8:	00008697          	auipc	a3,0x8
    11bc:	0e868693          	addi	a3,a3,232 # 92a0 <__global_pointer$+0x930>
      big[i] = 'x';
    11c0:	07800713          	li	a4,120
    11c4:	00e78023          	sb	a4,0(a5)
    for (int i = 0; i < PGSIZE; i++)
    11c8:	0785                	addi	a5,a5,1
    11ca:	fed79de3          	bne	a5,a3,11c4 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    11ce:	00008797          	auipc	a5,0x8
    11d2:	0c078923          	sb	zero,210(a5) # 92a0 <__global_pointer$+0x930>
    char *args2[] = {big, big, big, 0};
    11d6:	00007797          	auipc	a5,0x7
    11da:	bca78793          	addi	a5,a5,-1078 # 7da0 <l_free+0x233a>
    11de:	6390                	ld	a2,0(a5)
    11e0:	6794                	ld	a3,8(a5)
    11e2:	6b98                	ld	a4,16(a5)
    11e4:	6f9c                	ld	a5,24(a5)
    11e6:	f2c43823          	sd	a2,-208(s0)
    11ea:	f2d43c23          	sd	a3,-200(s0)
    11ee:	f4e43023          	sd	a4,-192(s0)
    11f2:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    11f6:	f3040593          	addi	a1,s0,-208
    11fa:	00005517          	auipc	a0,0x5
    11fe:	bbe50513          	addi	a0,a0,-1090 # 5db8 <l_free+0x352>
    1202:	00004097          	auipc	ra,0x4
    1206:	302080e7          	jalr	770(ra) # 5504 <exec>
    if (ret != -1) {
    120a:	57fd                	li	a5,-1
    120c:	0af50e63          	beq	a0,a5,12c8 <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    1210:	55fd                	li	a1,-1
    1212:	00005517          	auipc	a0,0x5
    1216:	2c650513          	addi	a0,a0,710 # 64d8 <l_free+0xa72>
    121a:	00004097          	auipc	ra,0x4
    121e:	62a080e7          	jalr	1578(ra) # 5844 <printf>
      exit(1);
    1222:	4505                	li	a0,1
    1224:	00004097          	auipc	ra,0x4
    1228:	2a8080e7          	jalr	680(ra) # 54cc <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    122c:	862a                	mv	a2,a0
    122e:	f6840593          	addi	a1,s0,-152
    1232:	00005517          	auipc	a0,0x5
    1236:	21e50513          	addi	a0,a0,542 # 6450 <l_free+0x9ea>
    123a:	00004097          	auipc	ra,0x4
    123e:	60a080e7          	jalr	1546(ra) # 5844 <printf>
    exit(1);
    1242:	4505                	li	a0,1
    1244:	00004097          	auipc	ra,0x4
    1248:	288080e7          	jalr	648(ra) # 54cc <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    124c:	862a                	mv	a2,a0
    124e:	f6840593          	addi	a1,s0,-152
    1252:	00005517          	auipc	a0,0x5
    1256:	21e50513          	addi	a0,a0,542 # 6470 <l_free+0xa0a>
    125a:	00004097          	auipc	ra,0x4
    125e:	5ea080e7          	jalr	1514(ra) # 5844 <printf>
    exit(1);
    1262:	4505                	li	a0,1
    1264:	00004097          	auipc	ra,0x4
    1268:	268080e7          	jalr	616(ra) # 54cc <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    126c:	86aa                	mv	a3,a0
    126e:	f6840613          	addi	a2,s0,-152
    1272:	85b2                	mv	a1,a2
    1274:	00005517          	auipc	a0,0x5
    1278:	21c50513          	addi	a0,a0,540 # 6490 <l_free+0xa2a>
    127c:	00004097          	auipc	ra,0x4
    1280:	5c8080e7          	jalr	1480(ra) # 5844 <printf>
    exit(1);
    1284:	4505                	li	a0,1
    1286:	00004097          	auipc	ra,0x4
    128a:	246080e7          	jalr	582(ra) # 54cc <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    128e:	567d                	li	a2,-1
    1290:	f6840593          	addi	a1,s0,-152
    1294:	00005517          	auipc	a0,0x5
    1298:	22450513          	addi	a0,a0,548 # 64b8 <l_free+0xa52>
    129c:	00004097          	auipc	ra,0x4
    12a0:	5a8080e7          	jalr	1448(ra) # 5844 <printf>
    exit(1);
    12a4:	4505                	li	a0,1
    12a6:	00004097          	auipc	ra,0x4
    12aa:	226080e7          	jalr	550(ra) # 54cc <exit>
    printf("fork failed\n");
    12ae:	00005517          	auipc	a0,0x5
    12b2:	67250513          	addi	a0,a0,1650 # 6920 <l_free+0xeba>
    12b6:	00004097          	auipc	ra,0x4
    12ba:	58e080e7          	jalr	1422(ra) # 5844 <printf>
    exit(1);
    12be:	4505                	li	a0,1
    12c0:	00004097          	auipc	ra,0x4
    12c4:	20c080e7          	jalr	524(ra) # 54cc <exit>
    exit(747); // OK
    12c8:	2eb00513          	li	a0,747
    12cc:	00004097          	auipc	ra,0x4
    12d0:	200080e7          	jalr	512(ra) # 54cc <exit>
  int st = 0;
    12d4:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    12d8:	f5440513          	addi	a0,s0,-172
    12dc:	00004097          	auipc	ra,0x4
    12e0:	1f8080e7          	jalr	504(ra) # 54d4 <wait>
  if (st != 747) {
    12e4:	f5442703          	lw	a4,-172(s0)
    12e8:	2eb00793          	li	a5,747
    12ec:	00f71663          	bne	a4,a5,12f8 <copyinstr2+0x1dc>
}
    12f0:	60ae                	ld	ra,200(sp)
    12f2:	640e                	ld	s0,192(sp)
    12f4:	6169                	addi	sp,sp,208
    12f6:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    12f8:	00005517          	auipc	a0,0x5
    12fc:	20850513          	addi	a0,a0,520 # 6500 <l_free+0xa9a>
    1300:	00004097          	auipc	ra,0x4
    1304:	544080e7          	jalr	1348(ra) # 5844 <printf>
    exit(1);
    1308:	4505                	li	a0,1
    130a:	00004097          	auipc	ra,0x4
    130e:	1c2080e7          	jalr	450(ra) # 54cc <exit>

0000000000001312 <truncate3>:
void truncate3(char *s) {
    1312:	7159                	addi	sp,sp,-112
    1314:	f486                	sd	ra,104(sp)
    1316:	f0a2                	sd	s0,96(sp)
    1318:	eca6                	sd	s1,88(sp)
    131a:	e8ca                	sd	s2,80(sp)
    131c:	e4ce                	sd	s3,72(sp)
    131e:	e0d2                	sd	s4,64(sp)
    1320:	fc56                	sd	s5,56(sp)
    1322:	1880                	addi	s0,sp,112
    1324:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE | O_TRUNC | O_WRONLY));
    1326:	60100593          	li	a1,1537
    132a:	00005517          	auipc	a0,0x5
    132e:	ae650513          	addi	a0,a0,-1306 # 5e10 <l_free+0x3aa>
    1332:	00004097          	auipc	ra,0x4
    1336:	1da080e7          	jalr	474(ra) # 550c <open>
    133a:	00004097          	auipc	ra,0x4
    133e:	1ba080e7          	jalr	442(ra) # 54f4 <close>
  pid = fork();
    1342:	00004097          	auipc	ra,0x4
    1346:	182080e7          	jalr	386(ra) # 54c4 <fork>
  if (pid < 0) {
    134a:	08054063          	bltz	a0,13ca <truncate3+0xb8>
  if (pid == 0) {
    134e:	e969                	bnez	a0,1420 <truncate3+0x10e>
    1350:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    1354:	00005a17          	auipc	s4,0x5
    1358:	abca0a13          	addi	s4,s4,-1348 # 5e10 <l_free+0x3aa>
      int n = write(fd, "1234567890", 10);
    135c:	00005a97          	auipc	s5,0x5
    1360:	204a8a93          	addi	s5,s5,516 # 6560 <l_free+0xafa>
      int fd = open("truncfile", O_WRONLY);
    1364:	4585                	li	a1,1
    1366:	8552                	mv	a0,s4
    1368:	00004097          	auipc	ra,0x4
    136c:	1a4080e7          	jalr	420(ra) # 550c <open>
    1370:	84aa                	mv	s1,a0
      if (fd < 0) {
    1372:	06054a63          	bltz	a0,13e6 <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    1376:	4629                	li	a2,10
    1378:	85d6                	mv	a1,s5
    137a:	00004097          	auipc	ra,0x4
    137e:	172080e7          	jalr	370(ra) # 54ec <write>
      if (n != 10) {
    1382:	47a9                	li	a5,10
    1384:	06f51f63          	bne	a0,a5,1402 <truncate3+0xf0>
      close(fd);
    1388:	8526                	mv	a0,s1
    138a:	00004097          	auipc	ra,0x4
    138e:	16a080e7          	jalr	362(ra) # 54f4 <close>
      fd = open("truncfile", O_RDONLY);
    1392:	4581                	li	a1,0
    1394:	8552                	mv	a0,s4
    1396:	00004097          	auipc	ra,0x4
    139a:	176080e7          	jalr	374(ra) # 550c <open>
    139e:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    13a0:	02000613          	li	a2,32
    13a4:	f9840593          	addi	a1,s0,-104
    13a8:	00004097          	auipc	ra,0x4
    13ac:	13c080e7          	jalr	316(ra) # 54e4 <read>
      close(fd);
    13b0:	8526                	mv	a0,s1
    13b2:	00004097          	auipc	ra,0x4
    13b6:	142080e7          	jalr	322(ra) # 54f4 <close>
    for (int i = 0; i < 100; i++) {
    13ba:	39fd                	addiw	s3,s3,-1
    13bc:	fa0994e3          	bnez	s3,1364 <truncate3+0x52>
    exit(0);
    13c0:	4501                	li	a0,0
    13c2:	00004097          	auipc	ra,0x4
    13c6:	10a080e7          	jalr	266(ra) # 54cc <exit>
    printf("%s: fork failed\n", s);
    13ca:	85ca                	mv	a1,s2
    13cc:	00005517          	auipc	a0,0x5
    13d0:	16450513          	addi	a0,a0,356 # 6530 <l_free+0xaca>
    13d4:	00004097          	auipc	ra,0x4
    13d8:	470080e7          	jalr	1136(ra) # 5844 <printf>
    exit(1);
    13dc:	4505                	li	a0,1
    13de:	00004097          	auipc	ra,0x4
    13e2:	0ee080e7          	jalr	238(ra) # 54cc <exit>
        printf("%s: open failed\n", s);
    13e6:	85ca                	mv	a1,s2
    13e8:	00005517          	auipc	a0,0x5
    13ec:	16050513          	addi	a0,a0,352 # 6548 <l_free+0xae2>
    13f0:	00004097          	auipc	ra,0x4
    13f4:	454080e7          	jalr	1108(ra) # 5844 <printf>
        exit(1);
    13f8:	4505                	li	a0,1
    13fa:	00004097          	auipc	ra,0x4
    13fe:	0d2080e7          	jalr	210(ra) # 54cc <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1402:	862a                	mv	a2,a0
    1404:	85ca                	mv	a1,s2
    1406:	00005517          	auipc	a0,0x5
    140a:	16a50513          	addi	a0,a0,362 # 6570 <l_free+0xb0a>
    140e:	00004097          	auipc	ra,0x4
    1412:	436080e7          	jalr	1078(ra) # 5844 <printf>
        exit(1);
    1416:	4505                	li	a0,1
    1418:	00004097          	auipc	ra,0x4
    141c:	0b4080e7          	jalr	180(ra) # 54cc <exit>
    1420:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
    1424:	00005a17          	auipc	s4,0x5
    1428:	9eca0a13          	addi	s4,s4,-1556 # 5e10 <l_free+0x3aa>
    int n = write(fd, "xxx", 3);
    142c:	00005a97          	auipc	s5,0x5
    1430:	164a8a93          	addi	s5,s5,356 # 6590 <l_free+0xb2a>
    int fd = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
    1434:	60100593          	li	a1,1537
    1438:	8552                	mv	a0,s4
    143a:	00004097          	auipc	ra,0x4
    143e:	0d2080e7          	jalr	210(ra) # 550c <open>
    1442:	84aa                	mv	s1,a0
    if (fd < 0) {
    1444:	04054763          	bltz	a0,1492 <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    1448:	460d                	li	a2,3
    144a:	85d6                	mv	a1,s5
    144c:	00004097          	auipc	ra,0x4
    1450:	0a0080e7          	jalr	160(ra) # 54ec <write>
    if (n != 3) {
    1454:	478d                	li	a5,3
    1456:	04f51c63          	bne	a0,a5,14ae <truncate3+0x19c>
    close(fd);
    145a:	8526                	mv	a0,s1
    145c:	00004097          	auipc	ra,0x4
    1460:	098080e7          	jalr	152(ra) # 54f4 <close>
  for (int i = 0; i < 150; i++) {
    1464:	39fd                	addiw	s3,s3,-1
    1466:	fc0997e3          	bnez	s3,1434 <truncate3+0x122>
  wait(&xstatus);
    146a:	fbc40513          	addi	a0,s0,-68
    146e:	00004097          	auipc	ra,0x4
    1472:	066080e7          	jalr	102(ra) # 54d4 <wait>
  unlink("truncfile");
    1476:	00005517          	auipc	a0,0x5
    147a:	99a50513          	addi	a0,a0,-1638 # 5e10 <l_free+0x3aa>
    147e:	00004097          	auipc	ra,0x4
    1482:	09e080e7          	jalr	158(ra) # 551c <unlink>
  exit(xstatus);
    1486:	fbc42503          	lw	a0,-68(s0)
    148a:	00004097          	auipc	ra,0x4
    148e:	042080e7          	jalr	66(ra) # 54cc <exit>
      printf("%s: open failed\n", s);
    1492:	85ca                	mv	a1,s2
    1494:	00005517          	auipc	a0,0x5
    1498:	0b450513          	addi	a0,a0,180 # 6548 <l_free+0xae2>
    149c:	00004097          	auipc	ra,0x4
    14a0:	3a8080e7          	jalr	936(ra) # 5844 <printf>
      exit(1);
    14a4:	4505                	li	a0,1
    14a6:	00004097          	auipc	ra,0x4
    14aa:	026080e7          	jalr	38(ra) # 54cc <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    14ae:	862a                	mv	a2,a0
    14b0:	85ca                	mv	a1,s2
    14b2:	00005517          	auipc	a0,0x5
    14b6:	0e650513          	addi	a0,a0,230 # 6598 <l_free+0xb32>
    14ba:	00004097          	auipc	ra,0x4
    14be:	38a080e7          	jalr	906(ra) # 5844 <printf>
      exit(1);
    14c2:	4505                	li	a0,1
    14c4:	00004097          	auipc	ra,0x4
    14c8:	008080e7          	jalr	8(ra) # 54cc <exit>

00000000000014cc <exectest>:
void exectest(char *s) {
    14cc:	715d                	addi	sp,sp,-80
    14ce:	e486                	sd	ra,72(sp)
    14d0:	e0a2                	sd	s0,64(sp)
    14d2:	fc26                	sd	s1,56(sp)
    14d4:	f84a                	sd	s2,48(sp)
    14d6:	0880                	addi	s0,sp,80
    14d8:	892a                	mv	s2,a0
  char *echoargv[] = {"echo", "OK", 0};
    14da:	00005797          	auipc	a5,0x5
    14de:	8de78793          	addi	a5,a5,-1826 # 5db8 <l_free+0x352>
    14e2:	fcf43023          	sd	a5,-64(s0)
    14e6:	00005797          	auipc	a5,0x5
    14ea:	0d278793          	addi	a5,a5,210 # 65b8 <l_free+0xb52>
    14ee:	fcf43423          	sd	a5,-56(s0)
    14f2:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    14f6:	00005517          	auipc	a0,0x5
    14fa:	0ca50513          	addi	a0,a0,202 # 65c0 <l_free+0xb5a>
    14fe:	00004097          	auipc	ra,0x4
    1502:	01e080e7          	jalr	30(ra) # 551c <unlink>
  pid = fork();
    1506:	00004097          	auipc	ra,0x4
    150a:	fbe080e7          	jalr	-66(ra) # 54c4 <fork>
  if (pid < 0) {
    150e:	04054663          	bltz	a0,155a <exectest+0x8e>
    1512:	84aa                	mv	s1,a0
  if (pid == 0) {
    1514:	e959                	bnez	a0,15aa <exectest+0xde>
    close(1);
    1516:	4505                	li	a0,1
    1518:	00004097          	auipc	ra,0x4
    151c:	fdc080e7          	jalr	-36(ra) # 54f4 <close>
    fd = open("echo-ok", O_CREATE | O_WRONLY);
    1520:	20100593          	li	a1,513
    1524:	00005517          	auipc	a0,0x5
    1528:	09c50513          	addi	a0,a0,156 # 65c0 <l_free+0xb5a>
    152c:	00004097          	auipc	ra,0x4
    1530:	fe0080e7          	jalr	-32(ra) # 550c <open>
    if (fd < 0) {
    1534:	04054163          	bltz	a0,1576 <exectest+0xaa>
    if (fd != 1) {
    1538:	4785                	li	a5,1
    153a:	04f50c63          	beq	a0,a5,1592 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    153e:	85ca                	mv	a1,s2
    1540:	00005517          	auipc	a0,0x5
    1544:	0a050513          	addi	a0,a0,160 # 65e0 <l_free+0xb7a>
    1548:	00004097          	auipc	ra,0x4
    154c:	2fc080e7          	jalr	764(ra) # 5844 <printf>
      exit(1);
    1550:	4505                	li	a0,1
    1552:	00004097          	auipc	ra,0x4
    1556:	f7a080e7          	jalr	-134(ra) # 54cc <exit>
    printf("%s: fork failed\n", s);
    155a:	85ca                	mv	a1,s2
    155c:	00005517          	auipc	a0,0x5
    1560:	fd450513          	addi	a0,a0,-44 # 6530 <l_free+0xaca>
    1564:	00004097          	auipc	ra,0x4
    1568:	2e0080e7          	jalr	736(ra) # 5844 <printf>
    exit(1);
    156c:	4505                	li	a0,1
    156e:	00004097          	auipc	ra,0x4
    1572:	f5e080e7          	jalr	-162(ra) # 54cc <exit>
      printf("%s: create failed\n", s);
    1576:	85ca                	mv	a1,s2
    1578:	00005517          	auipc	a0,0x5
    157c:	05050513          	addi	a0,a0,80 # 65c8 <l_free+0xb62>
    1580:	00004097          	auipc	ra,0x4
    1584:	2c4080e7          	jalr	708(ra) # 5844 <printf>
      exit(1);
    1588:	4505                	li	a0,1
    158a:	00004097          	auipc	ra,0x4
    158e:	f42080e7          	jalr	-190(ra) # 54cc <exit>
    if (exec("echo", echoargv) < 0) {
    1592:	fc040593          	addi	a1,s0,-64
    1596:	00005517          	auipc	a0,0x5
    159a:	82250513          	addi	a0,a0,-2014 # 5db8 <l_free+0x352>
    159e:	00004097          	auipc	ra,0x4
    15a2:	f66080e7          	jalr	-154(ra) # 5504 <exec>
    15a6:	02054163          	bltz	a0,15c8 <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    15aa:	fdc40513          	addi	a0,s0,-36
    15ae:	00004097          	auipc	ra,0x4
    15b2:	f26080e7          	jalr	-218(ra) # 54d4 <wait>
    15b6:	02951763          	bne	a0,s1,15e4 <exectest+0x118>
  if (xstatus != 0)
    15ba:	fdc42503          	lw	a0,-36(s0)
    15be:	cd0d                	beqz	a0,15f8 <exectest+0x12c>
    exit(xstatus);
    15c0:	00004097          	auipc	ra,0x4
    15c4:	f0c080e7          	jalr	-244(ra) # 54cc <exit>
      printf("%s: exec echo failed\n", s);
    15c8:	85ca                	mv	a1,s2
    15ca:	00005517          	auipc	a0,0x5
    15ce:	02650513          	addi	a0,a0,38 # 65f0 <l_free+0xb8a>
    15d2:	00004097          	auipc	ra,0x4
    15d6:	272080e7          	jalr	626(ra) # 5844 <printf>
      exit(1);
    15da:	4505                	li	a0,1
    15dc:	00004097          	auipc	ra,0x4
    15e0:	ef0080e7          	jalr	-272(ra) # 54cc <exit>
    printf("%s: wait failed!\n", s);
    15e4:	85ca                	mv	a1,s2
    15e6:	00005517          	auipc	a0,0x5
    15ea:	02250513          	addi	a0,a0,34 # 6608 <l_free+0xba2>
    15ee:	00004097          	auipc	ra,0x4
    15f2:	256080e7          	jalr	598(ra) # 5844 <printf>
    15f6:	b7d1                	j	15ba <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    15f8:	4581                	li	a1,0
    15fa:	00005517          	auipc	a0,0x5
    15fe:	fc650513          	addi	a0,a0,-58 # 65c0 <l_free+0xb5a>
    1602:	00004097          	auipc	ra,0x4
    1606:	f0a080e7          	jalr	-246(ra) # 550c <open>
  if (fd < 0) {
    160a:	02054a63          	bltz	a0,163e <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    160e:	4609                	li	a2,2
    1610:	fb840593          	addi	a1,s0,-72
    1614:	00004097          	auipc	ra,0x4
    1618:	ed0080e7          	jalr	-304(ra) # 54e4 <read>
    161c:	4789                	li	a5,2
    161e:	02f50e63          	beq	a0,a5,165a <exectest+0x18e>
    printf("%s: read failed\n", s);
    1622:	85ca                	mv	a1,s2
    1624:	00005517          	auipc	a0,0x5
    1628:	b5450513          	addi	a0,a0,-1196 # 6178 <l_free+0x712>
    162c:	00004097          	auipc	ra,0x4
    1630:	218080e7          	jalr	536(ra) # 5844 <printf>
    exit(1);
    1634:	4505                	li	a0,1
    1636:	00004097          	auipc	ra,0x4
    163a:	e96080e7          	jalr	-362(ra) # 54cc <exit>
    printf("%s: open failed\n", s);
    163e:	85ca                	mv	a1,s2
    1640:	00005517          	auipc	a0,0x5
    1644:	f0850513          	addi	a0,a0,-248 # 6548 <l_free+0xae2>
    1648:	00004097          	auipc	ra,0x4
    164c:	1fc080e7          	jalr	508(ra) # 5844 <printf>
    exit(1);
    1650:	4505                	li	a0,1
    1652:	00004097          	auipc	ra,0x4
    1656:	e7a080e7          	jalr	-390(ra) # 54cc <exit>
  unlink("echo-ok");
    165a:	00005517          	auipc	a0,0x5
    165e:	f6650513          	addi	a0,a0,-154 # 65c0 <l_free+0xb5a>
    1662:	00004097          	auipc	ra,0x4
    1666:	eba080e7          	jalr	-326(ra) # 551c <unlink>
  if (buf[0] == 'O' && buf[1] == 'K')
    166a:	fb844703          	lbu	a4,-72(s0)
    166e:	04f00793          	li	a5,79
    1672:	00f71863          	bne	a4,a5,1682 <exectest+0x1b6>
    1676:	fb944703          	lbu	a4,-71(s0)
    167a:	04b00793          	li	a5,75
    167e:	02f70063          	beq	a4,a5,169e <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    1682:	85ca                	mv	a1,s2
    1684:	00005517          	auipc	a0,0x5
    1688:	f9c50513          	addi	a0,a0,-100 # 6620 <l_free+0xbba>
    168c:	00004097          	auipc	ra,0x4
    1690:	1b8080e7          	jalr	440(ra) # 5844 <printf>
    exit(1);
    1694:	4505                	li	a0,1
    1696:	00004097          	auipc	ra,0x4
    169a:	e36080e7          	jalr	-458(ra) # 54cc <exit>
    exit(0);
    169e:	4501                	li	a0,0
    16a0:	00004097          	auipc	ra,0x4
    16a4:	e2c080e7          	jalr	-468(ra) # 54cc <exit>

00000000000016a8 <pipe1>:
void pipe1(char *s) {
    16a8:	711d                	addi	sp,sp,-96
    16aa:	ec86                	sd	ra,88(sp)
    16ac:	e8a2                	sd	s0,80(sp)
    16ae:	e4a6                	sd	s1,72(sp)
    16b0:	e0ca                	sd	s2,64(sp)
    16b2:	fc4e                	sd	s3,56(sp)
    16b4:	f852                	sd	s4,48(sp)
    16b6:	f456                	sd	s5,40(sp)
    16b8:	f05a                	sd	s6,32(sp)
    16ba:	ec5e                	sd	s7,24(sp)
    16bc:	1080                	addi	s0,sp,96
    16be:	892a                	mv	s2,a0
  if (pipe(fds) != 0) {
    16c0:	fa840513          	addi	a0,s0,-88
    16c4:	00004097          	auipc	ra,0x4
    16c8:	e18080e7          	jalr	-488(ra) # 54dc <pipe>
    16cc:	ed25                	bnez	a0,1744 <pipe1+0x9c>
    16ce:	84aa                	mv	s1,a0
  pid = fork();
    16d0:	00004097          	auipc	ra,0x4
    16d4:	df4080e7          	jalr	-524(ra) # 54c4 <fork>
    16d8:	8a2a                	mv	s4,a0
  if (pid == 0) {
    16da:	c159                	beqz	a0,1760 <pipe1+0xb8>
  } else if (pid > 0) {
    16dc:	16a05e63          	blez	a0,1858 <pipe1+0x1b0>
    close(fds[1]);
    16e0:	fac42503          	lw	a0,-84(s0)
    16e4:	00004097          	auipc	ra,0x4
    16e8:	e10080e7          	jalr	-496(ra) # 54f4 <close>
    total = 0;
    16ec:	8a26                	mv	s4,s1
    cc = 1;
    16ee:	4985                	li	s3,1
    while ((n = read(fds[0], buf, cc)) > 0) {
    16f0:	0000aa97          	auipc	s5,0xa
    16f4:	2c8a8a93          	addi	s5,s5,712 # b9b8 <buf>
      if (cc > sizeof(buf))
    16f8:	6b0d                	lui	s6,0x3
    while ((n = read(fds[0], buf, cc)) > 0) {
    16fa:	864e                	mv	a2,s3
    16fc:	85d6                	mv	a1,s5
    16fe:	fa842503          	lw	a0,-88(s0)
    1702:	00004097          	auipc	ra,0x4
    1706:	de2080e7          	jalr	-542(ra) # 54e4 <read>
    170a:	10a05263          	blez	a0,180e <pipe1+0x166>
      for (i = 0; i < n; i++) {
    170e:	0000a717          	auipc	a4,0xa
    1712:	2aa70713          	addi	a4,a4,682 # b9b8 <buf>
    1716:	00a4863b          	addw	a2,s1,a0
        if ((buf[i] & 0xff) != (seq++ & 0xff)) {
    171a:	00074683          	lbu	a3,0(a4)
    171e:	0ff4f793          	andi	a5,s1,255
    1722:	2485                	addiw	s1,s1,1
    1724:	0cf69163          	bne	a3,a5,17e6 <pipe1+0x13e>
      for (i = 0; i < n; i++) {
    1728:	0705                	addi	a4,a4,1
    172a:	fec498e3          	bne	s1,a2,171a <pipe1+0x72>
      total += n;
    172e:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    1732:	0019979b          	slliw	a5,s3,0x1
    1736:	0007899b          	sext.w	s3,a5
      if (cc > sizeof(buf))
    173a:	013b7363          	bgeu	s6,s3,1740 <pipe1+0x98>
        cc = sizeof(buf);
    173e:	89da                	mv	s3,s6
        if ((buf[i] & 0xff) != (seq++ & 0xff)) {
    1740:	84b2                	mv	s1,a2
    1742:	bf65                	j	16fa <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    1744:	85ca                	mv	a1,s2
    1746:	00005517          	auipc	a0,0x5
    174a:	ef250513          	addi	a0,a0,-270 # 6638 <l_free+0xbd2>
    174e:	00004097          	auipc	ra,0x4
    1752:	0f6080e7          	jalr	246(ra) # 5844 <printf>
    exit(1);
    1756:	4505                	li	a0,1
    1758:	00004097          	auipc	ra,0x4
    175c:	d74080e7          	jalr	-652(ra) # 54cc <exit>
    close(fds[0]);
    1760:	fa842503          	lw	a0,-88(s0)
    1764:	00004097          	auipc	ra,0x4
    1768:	d90080e7          	jalr	-624(ra) # 54f4 <close>
    for (n = 0; n < N; n++) {
    176c:	0000ab17          	auipc	s6,0xa
    1770:	24cb0b13          	addi	s6,s6,588 # b9b8 <buf>
    1774:	416004bb          	negw	s1,s6
    1778:	0ff4f493          	andi	s1,s1,255
    177c:	409b0993          	addi	s3,s6,1033
      if (write(fds[1], buf, SZ) != SZ) {
    1780:	8bda                	mv	s7,s6
    for (n = 0; n < N; n++) {
    1782:	6a85                	lui	s5,0x1
    1784:	42da8a93          	addi	s5,s5,1069 # 142d <truncate3+0x11b>
void pipe1(char *s) {
    1788:	87da                	mv	a5,s6
        buf[i] = seq++;
    178a:	0097873b          	addw	a4,a5,s1
    178e:	00e78023          	sb	a4,0(a5)
      for (i = 0; i < SZ; i++)
    1792:	0785                	addi	a5,a5,1
    1794:	fef99be3          	bne	s3,a5,178a <pipe1+0xe2>
        buf[i] = seq++;
    1798:	409a0a1b          	addiw	s4,s4,1033
      if (write(fds[1], buf, SZ) != SZ) {
    179c:	40900613          	li	a2,1033
    17a0:	85de                	mv	a1,s7
    17a2:	fac42503          	lw	a0,-84(s0)
    17a6:	00004097          	auipc	ra,0x4
    17aa:	d46080e7          	jalr	-698(ra) # 54ec <write>
    17ae:	40900793          	li	a5,1033
    17b2:	00f51c63          	bne	a0,a5,17ca <pipe1+0x122>
    for (n = 0; n < N; n++) {
    17b6:	24a5                	addiw	s1,s1,9
    17b8:	0ff4f493          	andi	s1,s1,255
    17bc:	fd5a16e3          	bne	s4,s5,1788 <pipe1+0xe0>
    exit(0);
    17c0:	4501                	li	a0,0
    17c2:	00004097          	auipc	ra,0x4
    17c6:	d0a080e7          	jalr	-758(ra) # 54cc <exit>
        printf("%s: pipe1 oops 1\n", s);
    17ca:	85ca                	mv	a1,s2
    17cc:	00005517          	auipc	a0,0x5
    17d0:	e8450513          	addi	a0,a0,-380 # 6650 <l_free+0xbea>
    17d4:	00004097          	auipc	ra,0x4
    17d8:	070080e7          	jalr	112(ra) # 5844 <printf>
        exit(1);
    17dc:	4505                	li	a0,1
    17de:	00004097          	auipc	ra,0x4
    17e2:	cee080e7          	jalr	-786(ra) # 54cc <exit>
          printf("%s: pipe1 oops 2\n", s);
    17e6:	85ca                	mv	a1,s2
    17e8:	00005517          	auipc	a0,0x5
    17ec:	e8050513          	addi	a0,a0,-384 # 6668 <l_free+0xc02>
    17f0:	00004097          	auipc	ra,0x4
    17f4:	054080e7          	jalr	84(ra) # 5844 <printf>
}
    17f8:	60e6                	ld	ra,88(sp)
    17fa:	6446                	ld	s0,80(sp)
    17fc:	64a6                	ld	s1,72(sp)
    17fe:	6906                	ld	s2,64(sp)
    1800:	79e2                	ld	s3,56(sp)
    1802:	7a42                	ld	s4,48(sp)
    1804:	7aa2                	ld	s5,40(sp)
    1806:	7b02                	ld	s6,32(sp)
    1808:	6be2                	ld	s7,24(sp)
    180a:	6125                	addi	sp,sp,96
    180c:	8082                	ret
    if (total != N * SZ) {
    180e:	6785                	lui	a5,0x1
    1810:	42d78793          	addi	a5,a5,1069 # 142d <truncate3+0x11b>
    1814:	02fa0063          	beq	s4,a5,1834 <pipe1+0x18c>
      printf("%s: pipe1 oops 3 total %d\n", total);
    1818:	85d2                	mv	a1,s4
    181a:	00005517          	auipc	a0,0x5
    181e:	e6650513          	addi	a0,a0,-410 # 6680 <l_free+0xc1a>
    1822:	00004097          	auipc	ra,0x4
    1826:	022080e7          	jalr	34(ra) # 5844 <printf>
      exit(1);
    182a:	4505                	li	a0,1
    182c:	00004097          	auipc	ra,0x4
    1830:	ca0080e7          	jalr	-864(ra) # 54cc <exit>
    close(fds[0]);
    1834:	fa842503          	lw	a0,-88(s0)
    1838:	00004097          	auipc	ra,0x4
    183c:	cbc080e7          	jalr	-836(ra) # 54f4 <close>
    wait(&xstatus);
    1840:	fa440513          	addi	a0,s0,-92
    1844:	00004097          	auipc	ra,0x4
    1848:	c90080e7          	jalr	-880(ra) # 54d4 <wait>
    exit(xstatus);
    184c:	fa442503          	lw	a0,-92(s0)
    1850:	00004097          	auipc	ra,0x4
    1854:	c7c080e7          	jalr	-900(ra) # 54cc <exit>
    printf("%s: fork() failed\n", s);
    1858:	85ca                	mv	a1,s2
    185a:	00005517          	auipc	a0,0x5
    185e:	e4650513          	addi	a0,a0,-442 # 66a0 <l_free+0xc3a>
    1862:	00004097          	auipc	ra,0x4
    1866:	fe2080e7          	jalr	-30(ra) # 5844 <printf>
    exit(1);
    186a:	4505                	li	a0,1
    186c:	00004097          	auipc	ra,0x4
    1870:	c60080e7          	jalr	-928(ra) # 54cc <exit>

0000000000001874 <exitwait>:
void exitwait(char *s) {
    1874:	7139                	addi	sp,sp,-64
    1876:	fc06                	sd	ra,56(sp)
    1878:	f822                	sd	s0,48(sp)
    187a:	f426                	sd	s1,40(sp)
    187c:	f04a                	sd	s2,32(sp)
    187e:	ec4e                	sd	s3,24(sp)
    1880:	e852                	sd	s4,16(sp)
    1882:	0080                	addi	s0,sp,64
    1884:	8a2a                	mv	s4,a0
  for (i = 0; i < 100; i++) {
    1886:	4901                	li	s2,0
    1888:	06400993          	li	s3,100
    pid = fork();
    188c:	00004097          	auipc	ra,0x4
    1890:	c38080e7          	jalr	-968(ra) # 54c4 <fork>
    1894:	84aa                	mv	s1,a0
    if (pid < 0) {
    1896:	02054a63          	bltz	a0,18ca <exitwait+0x56>
    if (pid) {
    189a:	c151                	beqz	a0,191e <exitwait+0xaa>
      if (wait(&xstate) != pid) {
    189c:	fcc40513          	addi	a0,s0,-52
    18a0:	00004097          	auipc	ra,0x4
    18a4:	c34080e7          	jalr	-972(ra) # 54d4 <wait>
    18a8:	02951f63          	bne	a0,s1,18e6 <exitwait+0x72>
      if (i != xstate) {
    18ac:	fcc42783          	lw	a5,-52(s0)
    18b0:	05279963          	bne	a5,s2,1902 <exitwait+0x8e>
  for (i = 0; i < 100; i++) {
    18b4:	2905                	addiw	s2,s2,1
    18b6:	fd391be3          	bne	s2,s3,188c <exitwait+0x18>
}
    18ba:	70e2                	ld	ra,56(sp)
    18bc:	7442                	ld	s0,48(sp)
    18be:	74a2                	ld	s1,40(sp)
    18c0:	7902                	ld	s2,32(sp)
    18c2:	69e2                	ld	s3,24(sp)
    18c4:	6a42                	ld	s4,16(sp)
    18c6:	6121                	addi	sp,sp,64
    18c8:	8082                	ret
      printf("%s: fork failed\n", s);
    18ca:	85d2                	mv	a1,s4
    18cc:	00005517          	auipc	a0,0x5
    18d0:	c6450513          	addi	a0,a0,-924 # 6530 <l_free+0xaca>
    18d4:	00004097          	auipc	ra,0x4
    18d8:	f70080e7          	jalr	-144(ra) # 5844 <printf>
      exit(1);
    18dc:	4505                	li	a0,1
    18de:	00004097          	auipc	ra,0x4
    18e2:	bee080e7          	jalr	-1042(ra) # 54cc <exit>
        printf("%s: wait wrong pid\n", s);
    18e6:	85d2                	mv	a1,s4
    18e8:	00005517          	auipc	a0,0x5
    18ec:	dd050513          	addi	a0,a0,-560 # 66b8 <l_free+0xc52>
    18f0:	00004097          	auipc	ra,0x4
    18f4:	f54080e7          	jalr	-172(ra) # 5844 <printf>
        exit(1);
    18f8:	4505                	li	a0,1
    18fa:	00004097          	auipc	ra,0x4
    18fe:	bd2080e7          	jalr	-1070(ra) # 54cc <exit>
        printf("%s: wait wrong exit status\n", s);
    1902:	85d2                	mv	a1,s4
    1904:	00005517          	auipc	a0,0x5
    1908:	dcc50513          	addi	a0,a0,-564 # 66d0 <l_free+0xc6a>
    190c:	00004097          	auipc	ra,0x4
    1910:	f38080e7          	jalr	-200(ra) # 5844 <printf>
        exit(1);
    1914:	4505                	li	a0,1
    1916:	00004097          	auipc	ra,0x4
    191a:	bb6080e7          	jalr	-1098(ra) # 54cc <exit>
      exit(i);
    191e:	854a                	mv	a0,s2
    1920:	00004097          	auipc	ra,0x4
    1924:	bac080e7          	jalr	-1108(ra) # 54cc <exit>

0000000000001928 <twochildren>:
void twochildren(char *s) {
    1928:	1101                	addi	sp,sp,-32
    192a:	ec06                	sd	ra,24(sp)
    192c:	e822                	sd	s0,16(sp)
    192e:	e426                	sd	s1,8(sp)
    1930:	e04a                	sd	s2,0(sp)
    1932:	1000                	addi	s0,sp,32
    1934:	892a                	mv	s2,a0
    1936:	3e800493          	li	s1,1000
    int pid1 = fork();
    193a:	00004097          	auipc	ra,0x4
    193e:	b8a080e7          	jalr	-1142(ra) # 54c4 <fork>
    if (pid1 < 0) {
    1942:	02054c63          	bltz	a0,197a <twochildren+0x52>
    if (pid1 == 0) {
    1946:	c921                	beqz	a0,1996 <twochildren+0x6e>
      int pid2 = fork();
    1948:	00004097          	auipc	ra,0x4
    194c:	b7c080e7          	jalr	-1156(ra) # 54c4 <fork>
      if (pid2 < 0) {
    1950:	04054763          	bltz	a0,199e <twochildren+0x76>
      if (pid2 == 0) {
    1954:	c13d                	beqz	a0,19ba <twochildren+0x92>
        wait(0);
    1956:	4501                	li	a0,0
    1958:	00004097          	auipc	ra,0x4
    195c:	b7c080e7          	jalr	-1156(ra) # 54d4 <wait>
        wait(0);
    1960:	4501                	li	a0,0
    1962:	00004097          	auipc	ra,0x4
    1966:	b72080e7          	jalr	-1166(ra) # 54d4 <wait>
  for (int i = 0; i < 1000; i++) {
    196a:	34fd                	addiw	s1,s1,-1
    196c:	f4f9                	bnez	s1,193a <twochildren+0x12>
}
    196e:	60e2                	ld	ra,24(sp)
    1970:	6442                	ld	s0,16(sp)
    1972:	64a2                	ld	s1,8(sp)
    1974:	6902                	ld	s2,0(sp)
    1976:	6105                	addi	sp,sp,32
    1978:	8082                	ret
      printf("%s: fork failed\n", s);
    197a:	85ca                	mv	a1,s2
    197c:	00005517          	auipc	a0,0x5
    1980:	bb450513          	addi	a0,a0,-1100 # 6530 <l_free+0xaca>
    1984:	00004097          	auipc	ra,0x4
    1988:	ec0080e7          	jalr	-320(ra) # 5844 <printf>
      exit(1);
    198c:	4505                	li	a0,1
    198e:	00004097          	auipc	ra,0x4
    1992:	b3e080e7          	jalr	-1218(ra) # 54cc <exit>
      exit(0);
    1996:	00004097          	auipc	ra,0x4
    199a:	b36080e7          	jalr	-1226(ra) # 54cc <exit>
        printf("%s: fork failed\n", s);
    199e:	85ca                	mv	a1,s2
    19a0:	00005517          	auipc	a0,0x5
    19a4:	b9050513          	addi	a0,a0,-1136 # 6530 <l_free+0xaca>
    19a8:	00004097          	auipc	ra,0x4
    19ac:	e9c080e7          	jalr	-356(ra) # 5844 <printf>
        exit(1);
    19b0:	4505                	li	a0,1
    19b2:	00004097          	auipc	ra,0x4
    19b6:	b1a080e7          	jalr	-1254(ra) # 54cc <exit>
        exit(0);
    19ba:	00004097          	auipc	ra,0x4
    19be:	b12080e7          	jalr	-1262(ra) # 54cc <exit>

00000000000019c2 <forkfork>:
void forkfork(char *s) {
    19c2:	7179                	addi	sp,sp,-48
    19c4:	f406                	sd	ra,40(sp)
    19c6:	f022                	sd	s0,32(sp)
    19c8:	ec26                	sd	s1,24(sp)
    19ca:	1800                	addi	s0,sp,48
    19cc:	84aa                	mv	s1,a0
    int pid = fork();
    19ce:	00004097          	auipc	ra,0x4
    19d2:	af6080e7          	jalr	-1290(ra) # 54c4 <fork>
    if (pid < 0) {
    19d6:	04054163          	bltz	a0,1a18 <forkfork+0x56>
    if (pid == 0) {
    19da:	cd29                	beqz	a0,1a34 <forkfork+0x72>
    int pid = fork();
    19dc:	00004097          	auipc	ra,0x4
    19e0:	ae8080e7          	jalr	-1304(ra) # 54c4 <fork>
    if (pid < 0) {
    19e4:	02054a63          	bltz	a0,1a18 <forkfork+0x56>
    if (pid == 0) {
    19e8:	c531                	beqz	a0,1a34 <forkfork+0x72>
    wait(&xstatus);
    19ea:	fdc40513          	addi	a0,s0,-36
    19ee:	00004097          	auipc	ra,0x4
    19f2:	ae6080e7          	jalr	-1306(ra) # 54d4 <wait>
    if (xstatus != 0) {
    19f6:	fdc42783          	lw	a5,-36(s0)
    19fa:	ebbd                	bnez	a5,1a70 <forkfork+0xae>
    wait(&xstatus);
    19fc:	fdc40513          	addi	a0,s0,-36
    1a00:	00004097          	auipc	ra,0x4
    1a04:	ad4080e7          	jalr	-1324(ra) # 54d4 <wait>
    if (xstatus != 0) {
    1a08:	fdc42783          	lw	a5,-36(s0)
    1a0c:	e3b5                	bnez	a5,1a70 <forkfork+0xae>
}
    1a0e:	70a2                	ld	ra,40(sp)
    1a10:	7402                	ld	s0,32(sp)
    1a12:	64e2                	ld	s1,24(sp)
    1a14:	6145                	addi	sp,sp,48
    1a16:	8082                	ret
      printf("%s: fork failed", s);
    1a18:	85a6                	mv	a1,s1
    1a1a:	00005517          	auipc	a0,0x5
    1a1e:	cd650513          	addi	a0,a0,-810 # 66f0 <l_free+0xc8a>
    1a22:	00004097          	auipc	ra,0x4
    1a26:	e22080e7          	jalr	-478(ra) # 5844 <printf>
      exit(1);
    1a2a:	4505                	li	a0,1
    1a2c:	00004097          	auipc	ra,0x4
    1a30:	aa0080e7          	jalr	-1376(ra) # 54cc <exit>
void forkfork(char *s) {
    1a34:	0c800493          	li	s1,200
        int pid1 = fork();
    1a38:	00004097          	auipc	ra,0x4
    1a3c:	a8c080e7          	jalr	-1396(ra) # 54c4 <fork>
        if (pid1 < 0) {
    1a40:	00054f63          	bltz	a0,1a5e <forkfork+0x9c>
        if (pid1 == 0) {
    1a44:	c115                	beqz	a0,1a68 <forkfork+0xa6>
        wait(0);
    1a46:	4501                	li	a0,0
    1a48:	00004097          	auipc	ra,0x4
    1a4c:	a8c080e7          	jalr	-1396(ra) # 54d4 <wait>
      for (int j = 0; j < 200; j++) {
    1a50:	34fd                	addiw	s1,s1,-1
    1a52:	f0fd                	bnez	s1,1a38 <forkfork+0x76>
      exit(0);
    1a54:	4501                	li	a0,0
    1a56:	00004097          	auipc	ra,0x4
    1a5a:	a76080e7          	jalr	-1418(ra) # 54cc <exit>
          exit(1);
    1a5e:	4505                	li	a0,1
    1a60:	00004097          	auipc	ra,0x4
    1a64:	a6c080e7          	jalr	-1428(ra) # 54cc <exit>
          exit(0);
    1a68:	00004097          	auipc	ra,0x4
    1a6c:	a64080e7          	jalr	-1436(ra) # 54cc <exit>
      printf("%s: fork in child failed", s);
    1a70:	85a6                	mv	a1,s1
    1a72:	00005517          	auipc	a0,0x5
    1a76:	c8e50513          	addi	a0,a0,-882 # 6700 <l_free+0xc9a>
    1a7a:	00004097          	auipc	ra,0x4
    1a7e:	dca080e7          	jalr	-566(ra) # 5844 <printf>
      exit(1);
    1a82:	4505                	li	a0,1
    1a84:	00004097          	auipc	ra,0x4
    1a88:	a48080e7          	jalr	-1464(ra) # 54cc <exit>

0000000000001a8c <reparent2>:
void reparent2(char *s) {
    1a8c:	1101                	addi	sp,sp,-32
    1a8e:	ec06                	sd	ra,24(sp)
    1a90:	e822                	sd	s0,16(sp)
    1a92:	e426                	sd	s1,8(sp)
    1a94:	1000                	addi	s0,sp,32
    1a96:	32000493          	li	s1,800
    int pid1 = fork();
    1a9a:	00004097          	auipc	ra,0x4
    1a9e:	a2a080e7          	jalr	-1494(ra) # 54c4 <fork>
    if (pid1 < 0) {
    1aa2:	00054f63          	bltz	a0,1ac0 <reparent2+0x34>
    if (pid1 == 0) {
    1aa6:	c915                	beqz	a0,1ada <reparent2+0x4e>
    wait(0);
    1aa8:	4501                	li	a0,0
    1aaa:	00004097          	auipc	ra,0x4
    1aae:	a2a080e7          	jalr	-1494(ra) # 54d4 <wait>
  for (int i = 0; i < 800; i++) {
    1ab2:	34fd                	addiw	s1,s1,-1
    1ab4:	f0fd                	bnez	s1,1a9a <reparent2+0xe>
  exit(0);
    1ab6:	4501                	li	a0,0
    1ab8:	00004097          	auipc	ra,0x4
    1abc:	a14080e7          	jalr	-1516(ra) # 54cc <exit>
      printf("fork failed\n");
    1ac0:	00005517          	auipc	a0,0x5
    1ac4:	e6050513          	addi	a0,a0,-416 # 6920 <l_free+0xeba>
    1ac8:	00004097          	auipc	ra,0x4
    1acc:	d7c080e7          	jalr	-644(ra) # 5844 <printf>
      exit(1);
    1ad0:	4505                	li	a0,1
    1ad2:	00004097          	auipc	ra,0x4
    1ad6:	9fa080e7          	jalr	-1542(ra) # 54cc <exit>
      fork();
    1ada:	00004097          	auipc	ra,0x4
    1ade:	9ea080e7          	jalr	-1558(ra) # 54c4 <fork>
      fork();
    1ae2:	00004097          	auipc	ra,0x4
    1ae6:	9e2080e7          	jalr	-1566(ra) # 54c4 <fork>
      exit(0);
    1aea:	4501                	li	a0,0
    1aec:	00004097          	auipc	ra,0x4
    1af0:	9e0080e7          	jalr	-1568(ra) # 54cc <exit>

0000000000001af4 <createdelete>:
void createdelete(char *s) {
    1af4:	7175                	addi	sp,sp,-144
    1af6:	e506                	sd	ra,136(sp)
    1af8:	e122                	sd	s0,128(sp)
    1afa:	fca6                	sd	s1,120(sp)
    1afc:	f8ca                	sd	s2,112(sp)
    1afe:	f4ce                	sd	s3,104(sp)
    1b00:	f0d2                	sd	s4,96(sp)
    1b02:	ecd6                	sd	s5,88(sp)
    1b04:	e8da                	sd	s6,80(sp)
    1b06:	e4de                	sd	s7,72(sp)
    1b08:	e0e2                	sd	s8,64(sp)
    1b0a:	fc66                	sd	s9,56(sp)
    1b0c:	0900                	addi	s0,sp,144
    1b0e:	8caa                	mv	s9,a0
  for (pi = 0; pi < NCHILD; pi++) {
    1b10:	4901                	li	s2,0
    1b12:	4991                	li	s3,4
    pid = fork();
    1b14:	00004097          	auipc	ra,0x4
    1b18:	9b0080e7          	jalr	-1616(ra) # 54c4 <fork>
    1b1c:	84aa                	mv	s1,a0
    if (pid < 0) {
    1b1e:	02054f63          	bltz	a0,1b5c <createdelete+0x68>
    if (pid == 0) {
    1b22:	c939                	beqz	a0,1b78 <createdelete+0x84>
  for (pi = 0; pi < NCHILD; pi++) {
    1b24:	2905                	addiw	s2,s2,1
    1b26:	ff3917e3          	bne	s2,s3,1b14 <createdelete+0x20>
    1b2a:	4491                	li	s1,4
    wait(&xstatus);
    1b2c:	f7c40513          	addi	a0,s0,-132
    1b30:	00004097          	auipc	ra,0x4
    1b34:	9a4080e7          	jalr	-1628(ra) # 54d4 <wait>
    if (xstatus != 0)
    1b38:	f7c42903          	lw	s2,-132(s0)
    1b3c:	0e091263          	bnez	s2,1c20 <createdelete+0x12c>
  for (pi = 0; pi < NCHILD; pi++) {
    1b40:	34fd                	addiw	s1,s1,-1
    1b42:	f4ed                	bnez	s1,1b2c <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1b44:	f8040123          	sb	zero,-126(s0)
    1b48:	03000993          	li	s3,48
    1b4c:	5a7d                	li	s4,-1
    1b4e:	07000c13          	li	s8,112
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    1b52:	4b21                	li	s6,8
      if ((i == 0 || i >= N / 2) && fd < 0) {
    1b54:	4ba5                	li	s7,9
    for (pi = 0; pi < NCHILD; pi++) {
    1b56:	07400a93          	li	s5,116
    1b5a:	a29d                	j	1cc0 <createdelete+0x1cc>
      printf("fork failed\n", s);
    1b5c:	85e6                	mv	a1,s9
    1b5e:	00005517          	auipc	a0,0x5
    1b62:	dc250513          	addi	a0,a0,-574 # 6920 <l_free+0xeba>
    1b66:	00004097          	auipc	ra,0x4
    1b6a:	cde080e7          	jalr	-802(ra) # 5844 <printf>
      exit(1);
    1b6e:	4505                	li	a0,1
    1b70:	00004097          	auipc	ra,0x4
    1b74:	95c080e7          	jalr	-1700(ra) # 54cc <exit>
      name[0] = 'p' + pi;
    1b78:	0709091b          	addiw	s2,s2,112
    1b7c:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1b80:	f8040123          	sb	zero,-126(s0)
      for (i = 0; i < N; i++) {
    1b84:	4951                	li	s2,20
    1b86:	a015                	j	1baa <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1b88:	85e6                	mv	a1,s9
    1b8a:	00005517          	auipc	a0,0x5
    1b8e:	a3e50513          	addi	a0,a0,-1474 # 65c8 <l_free+0xb62>
    1b92:	00004097          	auipc	ra,0x4
    1b96:	cb2080e7          	jalr	-846(ra) # 5844 <printf>
          exit(1);
    1b9a:	4505                	li	a0,1
    1b9c:	00004097          	auipc	ra,0x4
    1ba0:	930080e7          	jalr	-1744(ra) # 54cc <exit>
      for (i = 0; i < N; i++) {
    1ba4:	2485                	addiw	s1,s1,1
    1ba6:	07248863          	beq	s1,s2,1c16 <createdelete+0x122>
        name[1] = '0' + i;
    1baa:	0304879b          	addiw	a5,s1,48
    1bae:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1bb2:	20200593          	li	a1,514
    1bb6:	f8040513          	addi	a0,s0,-128
    1bba:	00004097          	auipc	ra,0x4
    1bbe:	952080e7          	jalr	-1710(ra) # 550c <open>
        if (fd < 0) {
    1bc2:	fc0543e3          	bltz	a0,1b88 <createdelete+0x94>
        close(fd);
    1bc6:	00004097          	auipc	ra,0x4
    1bca:	92e080e7          	jalr	-1746(ra) # 54f4 <close>
        if (i > 0 && (i % 2) == 0) {
    1bce:	fc905be3          	blez	s1,1ba4 <createdelete+0xb0>
    1bd2:	0014f793          	andi	a5,s1,1
    1bd6:	f7f9                	bnez	a5,1ba4 <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1bd8:	01f4d79b          	srliw	a5,s1,0x1f
    1bdc:	9fa5                	addw	a5,a5,s1
    1bde:	4017d79b          	sraiw	a5,a5,0x1
    1be2:	0307879b          	addiw	a5,a5,48
    1be6:	f8f400a3          	sb	a5,-127(s0)
          if (unlink(name) < 0) {
    1bea:	f8040513          	addi	a0,s0,-128
    1bee:	00004097          	auipc	ra,0x4
    1bf2:	92e080e7          	jalr	-1746(ra) # 551c <unlink>
    1bf6:	fa0557e3          	bgez	a0,1ba4 <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1bfa:	85e6                	mv	a1,s9
    1bfc:	00005517          	auipc	a0,0x5
    1c00:	b2450513          	addi	a0,a0,-1244 # 6720 <l_free+0xcba>
    1c04:	00004097          	auipc	ra,0x4
    1c08:	c40080e7          	jalr	-960(ra) # 5844 <printf>
            exit(1);
    1c0c:	4505                	li	a0,1
    1c0e:	00004097          	auipc	ra,0x4
    1c12:	8be080e7          	jalr	-1858(ra) # 54cc <exit>
      exit(0);
    1c16:	4501                	li	a0,0
    1c18:	00004097          	auipc	ra,0x4
    1c1c:	8b4080e7          	jalr	-1868(ra) # 54cc <exit>
      exit(1);
    1c20:	4505                	li	a0,1
    1c22:	00004097          	auipc	ra,0x4
    1c26:	8aa080e7          	jalr	-1878(ra) # 54cc <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1c2a:	f8040613          	addi	a2,s0,-128
    1c2e:	85e6                	mv	a1,s9
    1c30:	00005517          	auipc	a0,0x5
    1c34:	b0850513          	addi	a0,a0,-1272 # 6738 <l_free+0xcd2>
    1c38:	00004097          	auipc	ra,0x4
    1c3c:	c0c080e7          	jalr	-1012(ra) # 5844 <printf>
        exit(1);
    1c40:	4505                	li	a0,1
    1c42:	00004097          	auipc	ra,0x4
    1c46:	88a080e7          	jalr	-1910(ra) # 54cc <exit>
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    1c4a:	054b7163          	bgeu	s6,s4,1c8c <createdelete+0x198>
      if (fd >= 0)
    1c4e:	02055a63          	bgez	a0,1c82 <createdelete+0x18e>
    for (pi = 0; pi < NCHILD; pi++) {
    1c52:	2485                	addiw	s1,s1,1
    1c54:	0ff4f493          	andi	s1,s1,255
    1c58:	05548c63          	beq	s1,s5,1cb0 <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1c5c:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1c60:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1c64:	4581                	li	a1,0
    1c66:	f8040513          	addi	a0,s0,-128
    1c6a:	00004097          	auipc	ra,0x4
    1c6e:	8a2080e7          	jalr	-1886(ra) # 550c <open>
      if ((i == 0 || i >= N / 2) && fd < 0) {
    1c72:	00090463          	beqz	s2,1c7a <createdelete+0x186>
    1c76:	fd2bdae3          	bge	s7,s2,1c4a <createdelete+0x156>
    1c7a:	fa0548e3          	bltz	a0,1c2a <createdelete+0x136>
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    1c7e:	014b7963          	bgeu	s6,s4,1c90 <createdelete+0x19c>
        close(fd);
    1c82:	00004097          	auipc	ra,0x4
    1c86:	872080e7          	jalr	-1934(ra) # 54f4 <close>
    1c8a:	b7e1                	j	1c52 <createdelete+0x15e>
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    1c8c:	fc0543e3          	bltz	a0,1c52 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1c90:	f8040613          	addi	a2,s0,-128
    1c94:	85e6                	mv	a1,s9
    1c96:	00005517          	auipc	a0,0x5
    1c9a:	aca50513          	addi	a0,a0,-1334 # 6760 <l_free+0xcfa>
    1c9e:	00004097          	auipc	ra,0x4
    1ca2:	ba6080e7          	jalr	-1114(ra) # 5844 <printf>
        exit(1);
    1ca6:	4505                	li	a0,1
    1ca8:	00004097          	auipc	ra,0x4
    1cac:	824080e7          	jalr	-2012(ra) # 54cc <exit>
  for (i = 0; i < N; i++) {
    1cb0:	2905                	addiw	s2,s2,1
    1cb2:	2a05                	addiw	s4,s4,1
    1cb4:	2985                	addiw	s3,s3,1
    1cb6:	0ff9f993          	andi	s3,s3,255
    1cba:	47d1                	li	a5,20
    1cbc:	02f90a63          	beq	s2,a5,1cf0 <createdelete+0x1fc>
    for (pi = 0; pi < NCHILD; pi++) {
    1cc0:	84e2                	mv	s1,s8
    1cc2:	bf69                	j	1c5c <createdelete+0x168>
  for (i = 0; i < N; i++) {
    1cc4:	2905                	addiw	s2,s2,1
    1cc6:	0ff97913          	andi	s2,s2,255
    1cca:	2985                	addiw	s3,s3,1
    1ccc:	0ff9f993          	andi	s3,s3,255
    1cd0:	03490863          	beq	s2,s4,1d00 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1cd4:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1cd6:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1cda:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1cde:	f8040513          	addi	a0,s0,-128
    1ce2:	00004097          	auipc	ra,0x4
    1ce6:	83a080e7          	jalr	-1990(ra) # 551c <unlink>
    for (pi = 0; pi < NCHILD; pi++) {
    1cea:	34fd                	addiw	s1,s1,-1
    1cec:	f4ed                	bnez	s1,1cd6 <createdelete+0x1e2>
    1cee:	bfd9                	j	1cc4 <createdelete+0x1d0>
    1cf0:	03000993          	li	s3,48
    1cf4:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1cf8:	4a91                	li	s5,4
  for (i = 0; i < N; i++) {
    1cfa:	08400a13          	li	s4,132
    1cfe:	bfd9                	j	1cd4 <createdelete+0x1e0>
}
    1d00:	60aa                	ld	ra,136(sp)
    1d02:	640a                	ld	s0,128(sp)
    1d04:	74e6                	ld	s1,120(sp)
    1d06:	7946                	ld	s2,112(sp)
    1d08:	79a6                	ld	s3,104(sp)
    1d0a:	7a06                	ld	s4,96(sp)
    1d0c:	6ae6                	ld	s5,88(sp)
    1d0e:	6b46                	ld	s6,80(sp)
    1d10:	6ba6                	ld	s7,72(sp)
    1d12:	6c06                	ld	s8,64(sp)
    1d14:	7ce2                	ld	s9,56(sp)
    1d16:	6149                	addi	sp,sp,144
    1d18:	8082                	ret

0000000000001d1a <linkunlink>:
void linkunlink(char *s) {
    1d1a:	711d                	addi	sp,sp,-96
    1d1c:	ec86                	sd	ra,88(sp)
    1d1e:	e8a2                	sd	s0,80(sp)
    1d20:	e4a6                	sd	s1,72(sp)
    1d22:	e0ca                	sd	s2,64(sp)
    1d24:	fc4e                	sd	s3,56(sp)
    1d26:	f852                	sd	s4,48(sp)
    1d28:	f456                	sd	s5,40(sp)
    1d2a:	f05a                	sd	s6,32(sp)
    1d2c:	ec5e                	sd	s7,24(sp)
    1d2e:	e862                	sd	s8,16(sp)
    1d30:	e466                	sd	s9,8(sp)
    1d32:	1080                	addi	s0,sp,96
    1d34:	84aa                	mv	s1,a0
  unlink("x");
    1d36:	00004517          	auipc	a0,0x4
    1d3a:	0f250513          	addi	a0,a0,242 # 5e28 <l_free+0x3c2>
    1d3e:	00003097          	auipc	ra,0x3
    1d42:	7de080e7          	jalr	2014(ra) # 551c <unlink>
  pid = fork();
    1d46:	00003097          	auipc	ra,0x3
    1d4a:	77e080e7          	jalr	1918(ra) # 54c4 <fork>
  if (pid < 0) {
    1d4e:	02054b63          	bltz	a0,1d84 <linkunlink+0x6a>
    1d52:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1d54:	4c85                	li	s9,1
    1d56:	e119                	bnez	a0,1d5c <linkunlink+0x42>
    1d58:	06100c93          	li	s9,97
    1d5c:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1d60:	41c659b7          	lui	s3,0x41c65
    1d64:	e6d9899b          	addiw	s3,s3,-403
    1d68:	690d                	lui	s2,0x3
    1d6a:	0399091b          	addiw	s2,s2,57
    if ((x % 3) == 0) {
    1d6e:	4a0d                	li	s4,3
    } else if ((x % 3) == 1) {
    1d70:	4b05                	li	s6,1
      unlink("x");
    1d72:	00004a97          	auipc	s5,0x4
    1d76:	0b6a8a93          	addi	s5,s5,182 # 5e28 <l_free+0x3c2>
      link("cat", "x");
    1d7a:	00005b97          	auipc	s7,0x5
    1d7e:	a0eb8b93          	addi	s7,s7,-1522 # 6788 <l_free+0xd22>
    1d82:	a825                	j	1dba <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1d84:	85a6                	mv	a1,s1
    1d86:	00004517          	auipc	a0,0x4
    1d8a:	7aa50513          	addi	a0,a0,1962 # 6530 <l_free+0xaca>
    1d8e:	00004097          	auipc	ra,0x4
    1d92:	ab6080e7          	jalr	-1354(ra) # 5844 <printf>
    exit(1);
    1d96:	4505                	li	a0,1
    1d98:	00003097          	auipc	ra,0x3
    1d9c:	734080e7          	jalr	1844(ra) # 54cc <exit>
      close(open("x", O_RDWR | O_CREATE));
    1da0:	20200593          	li	a1,514
    1da4:	8556                	mv	a0,s5
    1da6:	00003097          	auipc	ra,0x3
    1daa:	766080e7          	jalr	1894(ra) # 550c <open>
    1dae:	00003097          	auipc	ra,0x3
    1db2:	746080e7          	jalr	1862(ra) # 54f4 <close>
  for (i = 0; i < 100; i++) {
    1db6:	34fd                	addiw	s1,s1,-1
    1db8:	c88d                	beqz	s1,1dea <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    1dba:	033c87bb          	mulw	a5,s9,s3
    1dbe:	012787bb          	addw	a5,a5,s2
    1dc2:	00078c9b          	sext.w	s9,a5
    if ((x % 3) == 0) {
    1dc6:	0347f7bb          	remuw	a5,a5,s4
    1dca:	dbf9                	beqz	a5,1da0 <linkunlink+0x86>
    } else if ((x % 3) == 1) {
    1dcc:	01678863          	beq	a5,s6,1ddc <linkunlink+0xc2>
      unlink("x");
    1dd0:	8556                	mv	a0,s5
    1dd2:	00003097          	auipc	ra,0x3
    1dd6:	74a080e7          	jalr	1866(ra) # 551c <unlink>
    1dda:	bff1                	j	1db6 <linkunlink+0x9c>
      link("cat", "x");
    1ddc:	85d6                	mv	a1,s5
    1dde:	855e                	mv	a0,s7
    1de0:	00003097          	auipc	ra,0x3
    1de4:	74c080e7          	jalr	1868(ra) # 552c <link>
    1de8:	b7f9                	j	1db6 <linkunlink+0x9c>
  if (pid)
    1dea:	020c0463          	beqz	s8,1e12 <linkunlink+0xf8>
    wait(0);
    1dee:	4501                	li	a0,0
    1df0:	00003097          	auipc	ra,0x3
    1df4:	6e4080e7          	jalr	1764(ra) # 54d4 <wait>
}
    1df8:	60e6                	ld	ra,88(sp)
    1dfa:	6446                	ld	s0,80(sp)
    1dfc:	64a6                	ld	s1,72(sp)
    1dfe:	6906                	ld	s2,64(sp)
    1e00:	79e2                	ld	s3,56(sp)
    1e02:	7a42                	ld	s4,48(sp)
    1e04:	7aa2                	ld	s5,40(sp)
    1e06:	7b02                	ld	s6,32(sp)
    1e08:	6be2                	ld	s7,24(sp)
    1e0a:	6c42                	ld	s8,16(sp)
    1e0c:	6ca2                	ld	s9,8(sp)
    1e0e:	6125                	addi	sp,sp,96
    1e10:	8082                	ret
    exit(0);
    1e12:	4501                	li	a0,0
    1e14:	00003097          	auipc	ra,0x3
    1e18:	6b8080e7          	jalr	1720(ra) # 54cc <exit>

0000000000001e1c <forktest>:
void forktest(char *s) {
    1e1c:	7179                	addi	sp,sp,-48
    1e1e:	f406                	sd	ra,40(sp)
    1e20:	f022                	sd	s0,32(sp)
    1e22:	ec26                	sd	s1,24(sp)
    1e24:	e84a                	sd	s2,16(sp)
    1e26:	e44e                	sd	s3,8(sp)
    1e28:	1800                	addi	s0,sp,48
    1e2a:	89aa                	mv	s3,a0
  for (n = 0; n < N; n++) {
    1e2c:	4481                	li	s1,0
    1e2e:	3e800913          	li	s2,1000
    pid = fork();
    1e32:	00003097          	auipc	ra,0x3
    1e36:	692080e7          	jalr	1682(ra) # 54c4 <fork>
    if (pid < 0)
    1e3a:	02054863          	bltz	a0,1e6a <forktest+0x4e>
    if (pid == 0)
    1e3e:	c115                	beqz	a0,1e62 <forktest+0x46>
  for (n = 0; n < N; n++) {
    1e40:	2485                	addiw	s1,s1,1
    1e42:	ff2498e3          	bne	s1,s2,1e32 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1e46:	85ce                	mv	a1,s3
    1e48:	00005517          	auipc	a0,0x5
    1e4c:	96050513          	addi	a0,a0,-1696 # 67a8 <l_free+0xd42>
    1e50:	00004097          	auipc	ra,0x4
    1e54:	9f4080e7          	jalr	-1548(ra) # 5844 <printf>
    exit(1);
    1e58:	4505                	li	a0,1
    1e5a:	00003097          	auipc	ra,0x3
    1e5e:	672080e7          	jalr	1650(ra) # 54cc <exit>
      exit(0);
    1e62:	00003097          	auipc	ra,0x3
    1e66:	66a080e7          	jalr	1642(ra) # 54cc <exit>
  if (n == 0) {
    1e6a:	cc9d                	beqz	s1,1ea8 <forktest+0x8c>
  if (n == N) {
    1e6c:	3e800793          	li	a5,1000
    1e70:	fcf48be3          	beq	s1,a5,1e46 <forktest+0x2a>
  for (; n > 0; n--) {
    1e74:	00905b63          	blez	s1,1e8a <forktest+0x6e>
    if (wait(0) < 0) {
    1e78:	4501                	li	a0,0
    1e7a:	00003097          	auipc	ra,0x3
    1e7e:	65a080e7          	jalr	1626(ra) # 54d4 <wait>
    1e82:	04054163          	bltz	a0,1ec4 <forktest+0xa8>
  for (; n > 0; n--) {
    1e86:	34fd                	addiw	s1,s1,-1
    1e88:	f8e5                	bnez	s1,1e78 <forktest+0x5c>
  if (wait(0) != -1) {
    1e8a:	4501                	li	a0,0
    1e8c:	00003097          	auipc	ra,0x3
    1e90:	648080e7          	jalr	1608(ra) # 54d4 <wait>
    1e94:	57fd                	li	a5,-1
    1e96:	04f51563          	bne	a0,a5,1ee0 <forktest+0xc4>
}
    1e9a:	70a2                	ld	ra,40(sp)
    1e9c:	7402                	ld	s0,32(sp)
    1e9e:	64e2                	ld	s1,24(sp)
    1ea0:	6942                	ld	s2,16(sp)
    1ea2:	69a2                	ld	s3,8(sp)
    1ea4:	6145                	addi	sp,sp,48
    1ea6:	8082                	ret
    printf("%s: no fork at all!\n", s);
    1ea8:	85ce                	mv	a1,s3
    1eaa:	00005517          	auipc	a0,0x5
    1eae:	8e650513          	addi	a0,a0,-1818 # 6790 <l_free+0xd2a>
    1eb2:	00004097          	auipc	ra,0x4
    1eb6:	992080e7          	jalr	-1646(ra) # 5844 <printf>
    exit(1);
    1eba:	4505                	li	a0,1
    1ebc:	00003097          	auipc	ra,0x3
    1ec0:	610080e7          	jalr	1552(ra) # 54cc <exit>
      printf("%s: wait stopped early\n", s);
    1ec4:	85ce                	mv	a1,s3
    1ec6:	00005517          	auipc	a0,0x5
    1eca:	90a50513          	addi	a0,a0,-1782 # 67d0 <l_free+0xd6a>
    1ece:	00004097          	auipc	ra,0x4
    1ed2:	976080e7          	jalr	-1674(ra) # 5844 <printf>
      exit(1);
    1ed6:	4505                	li	a0,1
    1ed8:	00003097          	auipc	ra,0x3
    1edc:	5f4080e7          	jalr	1524(ra) # 54cc <exit>
    printf("%s: wait got too many\n", s);
    1ee0:	85ce                	mv	a1,s3
    1ee2:	00005517          	auipc	a0,0x5
    1ee6:	90650513          	addi	a0,a0,-1786 # 67e8 <l_free+0xd82>
    1eea:	00004097          	auipc	ra,0x4
    1eee:	95a080e7          	jalr	-1702(ra) # 5844 <printf>
    exit(1);
    1ef2:	4505                	li	a0,1
    1ef4:	00003097          	auipc	ra,0x3
    1ef8:	5d8080e7          	jalr	1496(ra) # 54cc <exit>

0000000000001efc <kernmem>:
void kernmem(char *s) {
    1efc:	715d                	addi	sp,sp,-80
    1efe:	e486                	sd	ra,72(sp)
    1f00:	e0a2                	sd	s0,64(sp)
    1f02:	fc26                	sd	s1,56(sp)
    1f04:	f84a                	sd	s2,48(sp)
    1f06:	f44e                	sd	s3,40(sp)
    1f08:	f052                	sd	s4,32(sp)
    1f0a:	ec56                	sd	s5,24(sp)
    1f0c:	0880                	addi	s0,sp,80
    1f0e:	8a2a                	mv	s4,a0
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    1f10:	4485                	li	s1,1
    1f12:	04fe                	slli	s1,s1,0x1f
    if (xstatus != -1) // did kernel kill child?
    1f14:	5afd                	li	s5,-1
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    1f16:	69b1                	lui	s3,0xc
    1f18:	35098993          	addi	s3,s3,848 # c350 <buf+0x998>
    1f1c:	1003d937          	lui	s2,0x1003d
    1f20:	090e                	slli	s2,s2,0x3
    1f22:	48090913          	addi	s2,s2,1152 # 1003d480 <__BSS_END__+0x1002eab8>
    pid = fork();
    1f26:	00003097          	auipc	ra,0x3
    1f2a:	59e080e7          	jalr	1438(ra) # 54c4 <fork>
    if (pid < 0) {
    1f2e:	02054963          	bltz	a0,1f60 <kernmem+0x64>
    if (pid == 0) {
    1f32:	c529                	beqz	a0,1f7c <kernmem+0x80>
    wait(&xstatus);
    1f34:	fbc40513          	addi	a0,s0,-68
    1f38:	00003097          	auipc	ra,0x3
    1f3c:	59c080e7          	jalr	1436(ra) # 54d4 <wait>
    if (xstatus != -1) // did kernel kill child?
    1f40:	fbc42783          	lw	a5,-68(s0)
    1f44:	05579c63          	bne	a5,s5,1f9c <kernmem+0xa0>
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    1f48:	94ce                	add	s1,s1,s3
    1f4a:	fd249ee3          	bne	s1,s2,1f26 <kernmem+0x2a>
}
    1f4e:	60a6                	ld	ra,72(sp)
    1f50:	6406                	ld	s0,64(sp)
    1f52:	74e2                	ld	s1,56(sp)
    1f54:	7942                	ld	s2,48(sp)
    1f56:	79a2                	ld	s3,40(sp)
    1f58:	7a02                	ld	s4,32(sp)
    1f5a:	6ae2                	ld	s5,24(sp)
    1f5c:	6161                	addi	sp,sp,80
    1f5e:	8082                	ret
      printf("%s: fork failed\n", s);
    1f60:	85d2                	mv	a1,s4
    1f62:	00004517          	auipc	a0,0x4
    1f66:	5ce50513          	addi	a0,a0,1486 # 6530 <l_free+0xaca>
    1f6a:	00004097          	auipc	ra,0x4
    1f6e:	8da080e7          	jalr	-1830(ra) # 5844 <printf>
      exit(1);
    1f72:	4505                	li	a0,1
    1f74:	00003097          	auipc	ra,0x3
    1f78:	558080e7          	jalr	1368(ra) # 54cc <exit>
      printf("%s: oops could read %x = %x\n", a, *a);
    1f7c:	0004c603          	lbu	a2,0(s1)
    1f80:	85a6                	mv	a1,s1
    1f82:	00005517          	auipc	a0,0x5
    1f86:	87e50513          	addi	a0,a0,-1922 # 6800 <l_free+0xd9a>
    1f8a:	00004097          	auipc	ra,0x4
    1f8e:	8ba080e7          	jalr	-1862(ra) # 5844 <printf>
      exit(1);
    1f92:	4505                	li	a0,1
    1f94:	00003097          	auipc	ra,0x3
    1f98:	538080e7          	jalr	1336(ra) # 54cc <exit>
      exit(1);
    1f9c:	4505                	li	a0,1
    1f9e:	00003097          	auipc	ra,0x3
    1fa2:	52e080e7          	jalr	1326(ra) # 54cc <exit>

0000000000001fa6 <bigargtest>:
void bigargtest(char *s) {
    1fa6:	7179                	addi	sp,sp,-48
    1fa8:	f406                	sd	ra,40(sp)
    1faa:	f022                	sd	s0,32(sp)
    1fac:	ec26                	sd	s1,24(sp)
    1fae:	1800                	addi	s0,sp,48
    1fb0:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    1fb2:	00005517          	auipc	a0,0x5
    1fb6:	86e50513          	addi	a0,a0,-1938 # 6820 <l_free+0xdba>
    1fba:	00003097          	auipc	ra,0x3
    1fbe:	562080e7          	jalr	1378(ra) # 551c <unlink>
  pid = fork();
    1fc2:	00003097          	auipc	ra,0x3
    1fc6:	502080e7          	jalr	1282(ra) # 54c4 <fork>
  if (pid == 0) {
    1fca:	c121                	beqz	a0,200a <bigargtest+0x64>
  } else if (pid < 0) {
    1fcc:	0a054063          	bltz	a0,206c <bigargtest+0xc6>
  wait(&xstatus);
    1fd0:	fdc40513          	addi	a0,s0,-36
    1fd4:	00003097          	auipc	ra,0x3
    1fd8:	500080e7          	jalr	1280(ra) # 54d4 <wait>
  if (xstatus != 0)
    1fdc:	fdc42503          	lw	a0,-36(s0)
    1fe0:	e545                	bnez	a0,2088 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    1fe2:	4581                	li	a1,0
    1fe4:	00005517          	auipc	a0,0x5
    1fe8:	83c50513          	addi	a0,a0,-1988 # 6820 <l_free+0xdba>
    1fec:	00003097          	auipc	ra,0x3
    1ff0:	520080e7          	jalr	1312(ra) # 550c <open>
  if (fd < 0) {
    1ff4:	08054e63          	bltz	a0,2090 <bigargtest+0xea>
  close(fd);
    1ff8:	00003097          	auipc	ra,0x3
    1ffc:	4fc080e7          	jalr	1276(ra) # 54f4 <close>
}
    2000:	70a2                	ld	ra,40(sp)
    2002:	7402                	ld	s0,32(sp)
    2004:	64e2                	ld	s1,24(sp)
    2006:	6145                	addi	sp,sp,48
    2008:	8082                	ret
    200a:	00006797          	auipc	a5,0x6
    200e:	19678793          	addi	a5,a5,406 # 81a0 <args.1>
    2012:	00006697          	auipc	a3,0x6
    2016:	28668693          	addi	a3,a3,646 # 8298 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                        "
    201a:	00005717          	auipc	a4,0x5
    201e:	81670713          	addi	a4,a4,-2026 # 6830 <l_free+0xdca>
    2022:	e398                	sd	a4,0(a5)
    for (i = 0; i < MAXARG - 1; i++)
    2024:	07a1                	addi	a5,a5,8
    2026:	fed79ee3          	bne	a5,a3,2022 <bigargtest+0x7c>
    args[MAXARG - 1] = 0;
    202a:	00006597          	auipc	a1,0x6
    202e:	17658593          	addi	a1,a1,374 # 81a0 <args.1>
    2032:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    2036:	00004517          	auipc	a0,0x4
    203a:	d8250513          	addi	a0,a0,-638 # 5db8 <l_free+0x352>
    203e:	00003097          	auipc	ra,0x3
    2042:	4c6080e7          	jalr	1222(ra) # 5504 <exec>
    fd = open("bigarg-ok", O_CREATE);
    2046:	20000593          	li	a1,512
    204a:	00004517          	auipc	a0,0x4
    204e:	7d650513          	addi	a0,a0,2006 # 6820 <l_free+0xdba>
    2052:	00003097          	auipc	ra,0x3
    2056:	4ba080e7          	jalr	1210(ra) # 550c <open>
    close(fd);
    205a:	00003097          	auipc	ra,0x3
    205e:	49a080e7          	jalr	1178(ra) # 54f4 <close>
    exit(0);
    2062:	4501                	li	a0,0
    2064:	00003097          	auipc	ra,0x3
    2068:	468080e7          	jalr	1128(ra) # 54cc <exit>
    printf("%s: bigargtest: fork failed\n", s);
    206c:	85a6                	mv	a1,s1
    206e:	00005517          	auipc	a0,0x5
    2072:	8a250513          	addi	a0,a0,-1886 # 6910 <l_free+0xeaa>
    2076:	00003097          	auipc	ra,0x3
    207a:	7ce080e7          	jalr	1998(ra) # 5844 <printf>
    exit(1);
    207e:	4505                	li	a0,1
    2080:	00003097          	auipc	ra,0x3
    2084:	44c080e7          	jalr	1100(ra) # 54cc <exit>
    exit(xstatus);
    2088:	00003097          	auipc	ra,0x3
    208c:	444080e7          	jalr	1092(ra) # 54cc <exit>
    printf("%s: bigarg test failed!\n", s);
    2090:	85a6                	mv	a1,s1
    2092:	00005517          	auipc	a0,0x5
    2096:	89e50513          	addi	a0,a0,-1890 # 6930 <l_free+0xeca>
    209a:	00003097          	auipc	ra,0x3
    209e:	7aa080e7          	jalr	1962(ra) # 5844 <printf>
    exit(1);
    20a2:	4505                	li	a0,1
    20a4:	00003097          	auipc	ra,0x3
    20a8:	428080e7          	jalr	1064(ra) # 54cc <exit>

00000000000020ac <stacktest>:
void stacktest(char *s) {
    20ac:	7179                	addi	sp,sp,-48
    20ae:	f406                	sd	ra,40(sp)
    20b0:	f022                	sd	s0,32(sp)
    20b2:	ec26                	sd	s1,24(sp)
    20b4:	1800                	addi	s0,sp,48
    20b6:	84aa                	mv	s1,a0
  pid = fork();
    20b8:	00003097          	auipc	ra,0x3
    20bc:	40c080e7          	jalr	1036(ra) # 54c4 <fork>
  if (pid == 0) {
    20c0:	c115                	beqz	a0,20e4 <stacktest+0x38>
  } else if (pid < 0) {
    20c2:	04054363          	bltz	a0,2108 <stacktest+0x5c>
  wait(&xstatus);
    20c6:	fdc40513          	addi	a0,s0,-36
    20ca:	00003097          	auipc	ra,0x3
    20ce:	40a080e7          	jalr	1034(ra) # 54d4 <wait>
  if (xstatus == -1) // kernel killed child?
    20d2:	fdc42503          	lw	a0,-36(s0)
    20d6:	57fd                	li	a5,-1
    20d8:	04f50663          	beq	a0,a5,2124 <stacktest+0x78>
    exit(xstatus);
    20dc:	00003097          	auipc	ra,0x3
    20e0:	3f0080e7          	jalr	1008(ra) # 54cc <exit>
  return (x & SSTATUS_SIE) != 0;
}

static inline uint64 r_sp() {
  uint64 x;
  asm volatile("mv %0, sp" : "=r"(x));
    20e4:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", *sp);
    20e6:	77fd                	lui	a5,0xfffff
    20e8:	97ba                	add	a5,a5,a4
    20ea:	0007c583          	lbu	a1,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff0638>
    20ee:	00005517          	auipc	a0,0x5
    20f2:	86250513          	addi	a0,a0,-1950 # 6950 <l_free+0xeea>
    20f6:	00003097          	auipc	ra,0x3
    20fa:	74e080e7          	jalr	1870(ra) # 5844 <printf>
    exit(1);
    20fe:	4505                	li	a0,1
    2100:	00003097          	auipc	ra,0x3
    2104:	3cc080e7          	jalr	972(ra) # 54cc <exit>
    printf("%s: fork failed\n", s);
    2108:	85a6                	mv	a1,s1
    210a:	00004517          	auipc	a0,0x4
    210e:	42650513          	addi	a0,a0,1062 # 6530 <l_free+0xaca>
    2112:	00003097          	auipc	ra,0x3
    2116:	732080e7          	jalr	1842(ra) # 5844 <printf>
    exit(1);
    211a:	4505                	li	a0,1
    211c:	00003097          	auipc	ra,0x3
    2120:	3b0080e7          	jalr	944(ra) # 54cc <exit>
    exit(0);
    2124:	4501                	li	a0,0
    2126:	00003097          	auipc	ra,0x3
    212a:	3a6080e7          	jalr	934(ra) # 54cc <exit>

000000000000212e <copyinstr3>:
void copyinstr3(char *s) {
    212e:	7179                	addi	sp,sp,-48
    2130:	f406                	sd	ra,40(sp)
    2132:	f022                	sd	s0,32(sp)
    2134:	ec26                	sd	s1,24(sp)
    2136:	1800                	addi	s0,sp,48
  sbrk(8192);
    2138:	6509                	lui	a0,0x2
    213a:	00003097          	auipc	ra,0x3
    213e:	41a080e7          	jalr	1050(ra) # 5554 <sbrk>
  uint64 top = (uint64)sbrk(0);
    2142:	4501                	li	a0,0
    2144:	00003097          	auipc	ra,0x3
    2148:	410080e7          	jalr	1040(ra) # 5554 <sbrk>
  if ((top % PGSIZE) != 0) {
    214c:	03451793          	slli	a5,a0,0x34
    2150:	e3c9                	bnez	a5,21d2 <copyinstr3+0xa4>
  top = (uint64)sbrk(0);
    2152:	4501                	li	a0,0
    2154:	00003097          	auipc	ra,0x3
    2158:	400080e7          	jalr	1024(ra) # 5554 <sbrk>
  if (top % PGSIZE) {
    215c:	03451793          	slli	a5,a0,0x34
    2160:	e3d9                	bnez	a5,21e6 <copyinstr3+0xb8>
  char *b = (char *)(top - 1);
    2162:	fff50493          	addi	s1,a0,-1 # 1fff <bigargtest+0x59>
  *b = 'x';
    2166:	07800793          	li	a5,120
    216a:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    216e:	8526                	mv	a0,s1
    2170:	00003097          	auipc	ra,0x3
    2174:	3ac080e7          	jalr	940(ra) # 551c <unlink>
  if (ret != -1) {
    2178:	57fd                	li	a5,-1
    217a:	08f51363          	bne	a0,a5,2200 <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    217e:	20100593          	li	a1,513
    2182:	8526                	mv	a0,s1
    2184:	00003097          	auipc	ra,0x3
    2188:	388080e7          	jalr	904(ra) # 550c <open>
  if (fd != -1) {
    218c:	57fd                	li	a5,-1
    218e:	08f51863          	bne	a0,a5,221e <copyinstr3+0xf0>
  ret = link(b, b);
    2192:	85a6                	mv	a1,s1
    2194:	8526                	mv	a0,s1
    2196:	00003097          	auipc	ra,0x3
    219a:	396080e7          	jalr	918(ra) # 552c <link>
  if (ret != -1) {
    219e:	57fd                	li	a5,-1
    21a0:	08f51e63          	bne	a0,a5,223c <copyinstr3+0x10e>
  char *args[] = {"xx", 0};
    21a4:	00005797          	auipc	a5,0x5
    21a8:	35478793          	addi	a5,a5,852 # 74f8 <l_free+0x1a92>
    21ac:	fcf43823          	sd	a5,-48(s0)
    21b0:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    21b4:	fd040593          	addi	a1,s0,-48
    21b8:	8526                	mv	a0,s1
    21ba:	00003097          	auipc	ra,0x3
    21be:	34a080e7          	jalr	842(ra) # 5504 <exec>
  if (ret != -1) {
    21c2:	57fd                	li	a5,-1
    21c4:	08f51c63          	bne	a0,a5,225c <copyinstr3+0x12e>
}
    21c8:	70a2                	ld	ra,40(sp)
    21ca:	7402                	ld	s0,32(sp)
    21cc:	64e2                	ld	s1,24(sp)
    21ce:	6145                	addi	sp,sp,48
    21d0:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    21d2:	0347d513          	srli	a0,a5,0x34
    21d6:	6785                	lui	a5,0x1
    21d8:	40a7853b          	subw	a0,a5,a0
    21dc:	00003097          	auipc	ra,0x3
    21e0:	378080e7          	jalr	888(ra) # 5554 <sbrk>
    21e4:	b7bd                	j	2152 <copyinstr3+0x24>
    printf("oops\n");
    21e6:	00004517          	auipc	a0,0x4
    21ea:	79250513          	addi	a0,a0,1938 # 6978 <l_free+0xf12>
    21ee:	00003097          	auipc	ra,0x3
    21f2:	656080e7          	jalr	1622(ra) # 5844 <printf>
    exit(1);
    21f6:	4505                	li	a0,1
    21f8:	00003097          	auipc	ra,0x3
    21fc:	2d4080e7          	jalr	724(ra) # 54cc <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    2200:	862a                	mv	a2,a0
    2202:	85a6                	mv	a1,s1
    2204:	00004517          	auipc	a0,0x4
    2208:	24c50513          	addi	a0,a0,588 # 6450 <l_free+0x9ea>
    220c:	00003097          	auipc	ra,0x3
    2210:	638080e7          	jalr	1592(ra) # 5844 <printf>
    exit(1);
    2214:	4505                	li	a0,1
    2216:	00003097          	auipc	ra,0x3
    221a:	2b6080e7          	jalr	694(ra) # 54cc <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    221e:	862a                	mv	a2,a0
    2220:	85a6                	mv	a1,s1
    2222:	00004517          	auipc	a0,0x4
    2226:	24e50513          	addi	a0,a0,590 # 6470 <l_free+0xa0a>
    222a:	00003097          	auipc	ra,0x3
    222e:	61a080e7          	jalr	1562(ra) # 5844 <printf>
    exit(1);
    2232:	4505                	li	a0,1
    2234:	00003097          	auipc	ra,0x3
    2238:	298080e7          	jalr	664(ra) # 54cc <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    223c:	86aa                	mv	a3,a0
    223e:	8626                	mv	a2,s1
    2240:	85a6                	mv	a1,s1
    2242:	00004517          	auipc	a0,0x4
    2246:	24e50513          	addi	a0,a0,590 # 6490 <l_free+0xa2a>
    224a:	00003097          	auipc	ra,0x3
    224e:	5fa080e7          	jalr	1530(ra) # 5844 <printf>
    exit(1);
    2252:	4505                	li	a0,1
    2254:	00003097          	auipc	ra,0x3
    2258:	278080e7          	jalr	632(ra) # 54cc <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    225c:	567d                	li	a2,-1
    225e:	85a6                	mv	a1,s1
    2260:	00004517          	auipc	a0,0x4
    2264:	25850513          	addi	a0,a0,600 # 64b8 <l_free+0xa52>
    2268:	00003097          	auipc	ra,0x3
    226c:	5dc080e7          	jalr	1500(ra) # 5844 <printf>
    exit(1);
    2270:	4505                	li	a0,1
    2272:	00003097          	auipc	ra,0x3
    2276:	25a080e7          	jalr	602(ra) # 54cc <exit>

000000000000227a <rwsbrk>:
void rwsbrk() {
    227a:	1101                	addi	sp,sp,-32
    227c:	ec06                	sd	ra,24(sp)
    227e:	e822                	sd	s0,16(sp)
    2280:	e426                	sd	s1,8(sp)
    2282:	e04a                	sd	s2,0(sp)
    2284:	1000                	addi	s0,sp,32
  uint64 a = (uint64)sbrk(8192);
    2286:	6509                	lui	a0,0x2
    2288:	00003097          	auipc	ra,0x3
    228c:	2cc080e7          	jalr	716(ra) # 5554 <sbrk>
  if (a == 0xffffffffffffffffLL) {
    2290:	57fd                	li	a5,-1
    2292:	06f50363          	beq	a0,a5,22f8 <rwsbrk+0x7e>
    2296:	84aa                	mv	s1,a0
  if ((uint64)sbrk(-8192) == 0xffffffffffffffffLL) {
    2298:	7579                	lui	a0,0xffffe
    229a:	00003097          	auipc	ra,0x3
    229e:	2ba080e7          	jalr	698(ra) # 5554 <sbrk>
    22a2:	57fd                	li	a5,-1
    22a4:	06f50763          	beq	a0,a5,2312 <rwsbrk+0x98>
  fd = open("rwsbrk", O_CREATE | O_WRONLY);
    22a8:	20100593          	li	a1,513
    22ac:	00004517          	auipc	a0,0x4
    22b0:	83450513          	addi	a0,a0,-1996 # 5ae0 <l_free+0x7a>
    22b4:	00003097          	auipc	ra,0x3
    22b8:	258080e7          	jalr	600(ra) # 550c <open>
    22bc:	892a                	mv	s2,a0
  if (fd < 0) {
    22be:	06054763          	bltz	a0,232c <rwsbrk+0xb2>
  n = write(fd, (void *)(a + 4096), 1024);
    22c2:	6505                	lui	a0,0x1
    22c4:	94aa                	add	s1,s1,a0
    22c6:	40000613          	li	a2,1024
    22ca:	85a6                	mv	a1,s1
    22cc:	854a                	mv	a0,s2
    22ce:	00003097          	auipc	ra,0x3
    22d2:	21e080e7          	jalr	542(ra) # 54ec <write>
    22d6:	862a                	mv	a2,a0
  if (n >= 0) {
    22d8:	06054763          	bltz	a0,2346 <rwsbrk+0xcc>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a + 4096, n);
    22dc:	85a6                	mv	a1,s1
    22de:	00004517          	auipc	a0,0x4
    22e2:	6f250513          	addi	a0,a0,1778 # 69d0 <l_free+0xf6a>
    22e6:	00003097          	auipc	ra,0x3
    22ea:	55e080e7          	jalr	1374(ra) # 5844 <printf>
    exit(1);
    22ee:	4505                	li	a0,1
    22f0:	00003097          	auipc	ra,0x3
    22f4:	1dc080e7          	jalr	476(ra) # 54cc <exit>
    printf("sbrk(rwsbrk) failed\n");
    22f8:	00004517          	auipc	a0,0x4
    22fc:	68850513          	addi	a0,a0,1672 # 6980 <l_free+0xf1a>
    2300:	00003097          	auipc	ra,0x3
    2304:	544080e7          	jalr	1348(ra) # 5844 <printf>
    exit(1);
    2308:	4505                	li	a0,1
    230a:	00003097          	auipc	ra,0x3
    230e:	1c2080e7          	jalr	450(ra) # 54cc <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    2312:	00004517          	auipc	a0,0x4
    2316:	68650513          	addi	a0,a0,1670 # 6998 <l_free+0xf32>
    231a:	00003097          	auipc	ra,0x3
    231e:	52a080e7          	jalr	1322(ra) # 5844 <printf>
    exit(1);
    2322:	4505                	li	a0,1
    2324:	00003097          	auipc	ra,0x3
    2328:	1a8080e7          	jalr	424(ra) # 54cc <exit>
    printf("open(rwsbrk) failed\n");
    232c:	00004517          	auipc	a0,0x4
    2330:	68c50513          	addi	a0,a0,1676 # 69b8 <l_free+0xf52>
    2334:	00003097          	auipc	ra,0x3
    2338:	510080e7          	jalr	1296(ra) # 5844 <printf>
    exit(1);
    233c:	4505                	li	a0,1
    233e:	00003097          	auipc	ra,0x3
    2342:	18e080e7          	jalr	398(ra) # 54cc <exit>
  close(fd);
    2346:	854a                	mv	a0,s2
    2348:	00003097          	auipc	ra,0x3
    234c:	1ac080e7          	jalr	428(ra) # 54f4 <close>
  unlink("rwsbrk");
    2350:	00003517          	auipc	a0,0x3
    2354:	79050513          	addi	a0,a0,1936 # 5ae0 <l_free+0x7a>
    2358:	00003097          	auipc	ra,0x3
    235c:	1c4080e7          	jalr	452(ra) # 551c <unlink>
  fd = open("README", O_RDONLY);
    2360:	4581                	li	a1,0
    2362:	00004517          	auipc	a0,0x4
    2366:	c1e50513          	addi	a0,a0,-994 # 5f80 <l_free+0x51a>
    236a:	00003097          	auipc	ra,0x3
    236e:	1a2080e7          	jalr	418(ra) # 550c <open>
    2372:	892a                	mv	s2,a0
  if (fd < 0) {
    2374:	02054963          	bltz	a0,23a6 <rwsbrk+0x12c>
  n = read(fd, (void *)(a + 4096), 10);
    2378:	4629                	li	a2,10
    237a:	85a6                	mv	a1,s1
    237c:	00003097          	auipc	ra,0x3
    2380:	168080e7          	jalr	360(ra) # 54e4 <read>
    2384:	862a                	mv	a2,a0
  if (n >= 0) {
    2386:	02054d63          	bltz	a0,23c0 <rwsbrk+0x146>
    printf("read(fd, %p, 10) returned %d, not -1\n", a + 4096, n);
    238a:	85a6                	mv	a1,s1
    238c:	00004517          	auipc	a0,0x4
    2390:	67450513          	addi	a0,a0,1652 # 6a00 <l_free+0xf9a>
    2394:	00003097          	auipc	ra,0x3
    2398:	4b0080e7          	jalr	1200(ra) # 5844 <printf>
    exit(1);
    239c:	4505                	li	a0,1
    239e:	00003097          	auipc	ra,0x3
    23a2:	12e080e7          	jalr	302(ra) # 54cc <exit>
    printf("open(rwsbrk) failed\n");
    23a6:	00004517          	auipc	a0,0x4
    23aa:	61250513          	addi	a0,a0,1554 # 69b8 <l_free+0xf52>
    23ae:	00003097          	auipc	ra,0x3
    23b2:	496080e7          	jalr	1174(ra) # 5844 <printf>
    exit(1);
    23b6:	4505                	li	a0,1
    23b8:	00003097          	auipc	ra,0x3
    23bc:	114080e7          	jalr	276(ra) # 54cc <exit>
  close(fd);
    23c0:	854a                	mv	a0,s2
    23c2:	00003097          	auipc	ra,0x3
    23c6:	132080e7          	jalr	306(ra) # 54f4 <close>
  exit(0);
    23ca:	4501                	li	a0,0
    23cc:	00003097          	auipc	ra,0x3
    23d0:	100080e7          	jalr	256(ra) # 54cc <exit>

00000000000023d4 <sbrkmuch>:
void sbrkmuch(char *s) {
    23d4:	7179                	addi	sp,sp,-48
    23d6:	f406                	sd	ra,40(sp)
    23d8:	f022                	sd	s0,32(sp)
    23da:	ec26                	sd	s1,24(sp)
    23dc:	e84a                	sd	s2,16(sp)
    23de:	e44e                	sd	s3,8(sp)
    23e0:	e052                	sd	s4,0(sp)
    23e2:	1800                	addi	s0,sp,48
    23e4:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    23e6:	4501                	li	a0,0
    23e8:	00003097          	auipc	ra,0x3
    23ec:	16c080e7          	jalr	364(ra) # 5554 <sbrk>
    23f0:	892a                	mv	s2,a0
  a = sbrk(0);
    23f2:	4501                	li	a0,0
    23f4:	00003097          	auipc	ra,0x3
    23f8:	160080e7          	jalr	352(ra) # 5554 <sbrk>
    23fc:	84aa                	mv	s1,a0
  p = sbrk(amt);
    23fe:	06400537          	lui	a0,0x6400
    2402:	9d05                	subw	a0,a0,s1
    2404:	00003097          	auipc	ra,0x3
    2408:	150080e7          	jalr	336(ra) # 5554 <sbrk>
  if (p != a) {
    240c:	0ca49863          	bne	s1,a0,24dc <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2410:	4501                	li	a0,0
    2412:	00003097          	auipc	ra,0x3
    2416:	142080e7          	jalr	322(ra) # 5554 <sbrk>
    241a:	87aa                	mv	a5,a0
  for (char *pp = a; pp < eee; pp += 4096)
    241c:	00a4f963          	bgeu	s1,a0,242e <sbrkmuch+0x5a>
    *pp = 1;
    2420:	4685                	li	a3,1
  for (char *pp = a; pp < eee; pp += 4096)
    2422:	6705                	lui	a4,0x1
    *pp = 1;
    2424:	00d48023          	sb	a3,0(s1)
  for (char *pp = a; pp < eee; pp += 4096)
    2428:	94ba                	add	s1,s1,a4
    242a:	fef4ede3          	bltu	s1,a5,2424 <sbrkmuch+0x50>
  *lastaddr = 99;
    242e:	064007b7          	lui	a5,0x6400
    2432:	06300713          	li	a4,99
    2436:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f1637>
  a = sbrk(0);
    243a:	4501                	li	a0,0
    243c:	00003097          	auipc	ra,0x3
    2440:	118080e7          	jalr	280(ra) # 5554 <sbrk>
    2444:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2446:	757d                	lui	a0,0xfffff
    2448:	00003097          	auipc	ra,0x3
    244c:	10c080e7          	jalr	268(ra) # 5554 <sbrk>
  if (c == (char *)0xffffffffffffffffL) {
    2450:	57fd                	li	a5,-1
    2452:	0af50363          	beq	a0,a5,24f8 <sbrkmuch+0x124>
  c = sbrk(0);
    2456:	4501                	li	a0,0
    2458:	00003097          	auipc	ra,0x3
    245c:	0fc080e7          	jalr	252(ra) # 5554 <sbrk>
  if (c != a - PGSIZE) {
    2460:	77fd                	lui	a5,0xfffff
    2462:	97a6                	add	a5,a5,s1
    2464:	0af51863          	bne	a0,a5,2514 <sbrkmuch+0x140>
  a = sbrk(0);
    2468:	4501                	li	a0,0
    246a:	00003097          	auipc	ra,0x3
    246e:	0ea080e7          	jalr	234(ra) # 5554 <sbrk>
    2472:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2474:	6505                	lui	a0,0x1
    2476:	00003097          	auipc	ra,0x3
    247a:	0de080e7          	jalr	222(ra) # 5554 <sbrk>
    247e:	8a2a                	mv	s4,a0
  if (c != a || sbrk(0) != a + PGSIZE) {
    2480:	0aa49963          	bne	s1,a0,2532 <sbrkmuch+0x15e>
    2484:	4501                	li	a0,0
    2486:	00003097          	auipc	ra,0x3
    248a:	0ce080e7          	jalr	206(ra) # 5554 <sbrk>
    248e:	6785                	lui	a5,0x1
    2490:	97a6                	add	a5,a5,s1
    2492:	0af51063          	bne	a0,a5,2532 <sbrkmuch+0x15e>
  if (*lastaddr == 99) {
    2496:	064007b7          	lui	a5,0x6400
    249a:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f1637>
    249e:	06300793          	li	a5,99
    24a2:	0af70763          	beq	a4,a5,2550 <sbrkmuch+0x17c>
  a = sbrk(0);
    24a6:	4501                	li	a0,0
    24a8:	00003097          	auipc	ra,0x3
    24ac:	0ac080e7          	jalr	172(ra) # 5554 <sbrk>
    24b0:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    24b2:	4501                	li	a0,0
    24b4:	00003097          	auipc	ra,0x3
    24b8:	0a0080e7          	jalr	160(ra) # 5554 <sbrk>
    24bc:	40a9053b          	subw	a0,s2,a0
    24c0:	00003097          	auipc	ra,0x3
    24c4:	094080e7          	jalr	148(ra) # 5554 <sbrk>
  if (c != a) {
    24c8:	0aa49263          	bne	s1,a0,256c <sbrkmuch+0x198>
}
    24cc:	70a2                	ld	ra,40(sp)
    24ce:	7402                	ld	s0,32(sp)
    24d0:	64e2                	ld	s1,24(sp)
    24d2:	6942                	ld	s2,16(sp)
    24d4:	69a2                	ld	s3,8(sp)
    24d6:	6a02                	ld	s4,0(sp)
    24d8:	6145                	addi	sp,sp,48
    24da:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n",
    24dc:	85ce                	mv	a1,s3
    24de:	00004517          	auipc	a0,0x4
    24e2:	54a50513          	addi	a0,a0,1354 # 6a28 <l_free+0xfc2>
    24e6:	00003097          	auipc	ra,0x3
    24ea:	35e080e7          	jalr	862(ra) # 5844 <printf>
    exit(1);
    24ee:	4505                	li	a0,1
    24f0:	00003097          	auipc	ra,0x3
    24f4:	fdc080e7          	jalr	-36(ra) # 54cc <exit>
    printf("%s: sbrk could not deallocate\n", s);
    24f8:	85ce                	mv	a1,s3
    24fa:	00004517          	auipc	a0,0x4
    24fe:	57650513          	addi	a0,a0,1398 # 6a70 <l_free+0x100a>
    2502:	00003097          	auipc	ra,0x3
    2506:	342080e7          	jalr	834(ra) # 5844 <printf>
    exit(1);
    250a:	4505                	li	a0,1
    250c:	00003097          	auipc	ra,0x3
    2510:	fc0080e7          	jalr	-64(ra) # 54cc <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    2514:	862a                	mv	a2,a0
    2516:	85a6                	mv	a1,s1
    2518:	00004517          	auipc	a0,0x4
    251c:	57850513          	addi	a0,a0,1400 # 6a90 <l_free+0x102a>
    2520:	00003097          	auipc	ra,0x3
    2524:	324080e7          	jalr	804(ra) # 5844 <printf>
    exit(1);
    2528:	4505                	li	a0,1
    252a:	00003097          	auipc	ra,0x3
    252e:	fa2080e7          	jalr	-94(ra) # 54cc <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", a, c);
    2532:	8652                	mv	a2,s4
    2534:	85a6                	mv	a1,s1
    2536:	00004517          	auipc	a0,0x4
    253a:	59a50513          	addi	a0,a0,1434 # 6ad0 <l_free+0x106a>
    253e:	00003097          	auipc	ra,0x3
    2542:	306080e7          	jalr	774(ra) # 5844 <printf>
    exit(1);
    2546:	4505                	li	a0,1
    2548:	00003097          	auipc	ra,0x3
    254c:	f84080e7          	jalr	-124(ra) # 54cc <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2550:	85ce                	mv	a1,s3
    2552:	00004517          	auipc	a0,0x4
    2556:	5ae50513          	addi	a0,a0,1454 # 6b00 <l_free+0x109a>
    255a:	00003097          	auipc	ra,0x3
    255e:	2ea080e7          	jalr	746(ra) # 5844 <printf>
    exit(1);
    2562:	4505                	li	a0,1
    2564:	00003097          	auipc	ra,0x3
    2568:	f68080e7          	jalr	-152(ra) # 54cc <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", a, c);
    256c:	862a                	mv	a2,a0
    256e:	85a6                	mv	a1,s1
    2570:	00004517          	auipc	a0,0x4
    2574:	5c850513          	addi	a0,a0,1480 # 6b38 <l_free+0x10d2>
    2578:	00003097          	auipc	ra,0x3
    257c:	2cc080e7          	jalr	716(ra) # 5844 <printf>
    exit(1);
    2580:	4505                	li	a0,1
    2582:	00003097          	auipc	ra,0x3
    2586:	f4a080e7          	jalr	-182(ra) # 54cc <exit>

000000000000258a <sbrkarg>:
void sbrkarg(char *s) {
    258a:	7179                	addi	sp,sp,-48
    258c:	f406                	sd	ra,40(sp)
    258e:	f022                	sd	s0,32(sp)
    2590:	ec26                	sd	s1,24(sp)
    2592:	e84a                	sd	s2,16(sp)
    2594:	e44e                	sd	s3,8(sp)
    2596:	1800                	addi	s0,sp,48
    2598:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    259a:	6505                	lui	a0,0x1
    259c:	00003097          	auipc	ra,0x3
    25a0:	fb8080e7          	jalr	-72(ra) # 5554 <sbrk>
    25a4:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE | O_WRONLY);
    25a6:	20100593          	li	a1,513
    25aa:	00004517          	auipc	a0,0x4
    25ae:	5b650513          	addi	a0,a0,1462 # 6b60 <l_free+0x10fa>
    25b2:	00003097          	auipc	ra,0x3
    25b6:	f5a080e7          	jalr	-166(ra) # 550c <open>
    25ba:	84aa                	mv	s1,a0
  unlink("sbrk");
    25bc:	00004517          	auipc	a0,0x4
    25c0:	5a450513          	addi	a0,a0,1444 # 6b60 <l_free+0x10fa>
    25c4:	00003097          	auipc	ra,0x3
    25c8:	f58080e7          	jalr	-168(ra) # 551c <unlink>
  if (fd < 0) {
    25cc:	0404c163          	bltz	s1,260e <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    25d0:	6605                	lui	a2,0x1
    25d2:	85ca                	mv	a1,s2
    25d4:	8526                	mv	a0,s1
    25d6:	00003097          	auipc	ra,0x3
    25da:	f16080e7          	jalr	-234(ra) # 54ec <write>
    25de:	04054663          	bltz	a0,262a <sbrkarg+0xa0>
  close(fd);
    25e2:	8526                	mv	a0,s1
    25e4:	00003097          	auipc	ra,0x3
    25e8:	f10080e7          	jalr	-240(ra) # 54f4 <close>
  a = sbrk(PGSIZE);
    25ec:	6505                	lui	a0,0x1
    25ee:	00003097          	auipc	ra,0x3
    25f2:	f66080e7          	jalr	-154(ra) # 5554 <sbrk>
  if (pipe((int *)a) != 0) {
    25f6:	00003097          	auipc	ra,0x3
    25fa:	ee6080e7          	jalr	-282(ra) # 54dc <pipe>
    25fe:	e521                	bnez	a0,2646 <sbrkarg+0xbc>
}
    2600:	70a2                	ld	ra,40(sp)
    2602:	7402                	ld	s0,32(sp)
    2604:	64e2                	ld	s1,24(sp)
    2606:	6942                	ld	s2,16(sp)
    2608:	69a2                	ld	s3,8(sp)
    260a:	6145                	addi	sp,sp,48
    260c:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    260e:	85ce                	mv	a1,s3
    2610:	00004517          	auipc	a0,0x4
    2614:	55850513          	addi	a0,a0,1368 # 6b68 <l_free+0x1102>
    2618:	00003097          	auipc	ra,0x3
    261c:	22c080e7          	jalr	556(ra) # 5844 <printf>
    exit(1);
    2620:	4505                	li	a0,1
    2622:	00003097          	auipc	ra,0x3
    2626:	eaa080e7          	jalr	-342(ra) # 54cc <exit>
    printf("%s: write sbrk failed\n", s);
    262a:	85ce                	mv	a1,s3
    262c:	00004517          	auipc	a0,0x4
    2630:	55450513          	addi	a0,a0,1364 # 6b80 <l_free+0x111a>
    2634:	00003097          	auipc	ra,0x3
    2638:	210080e7          	jalr	528(ra) # 5844 <printf>
    exit(1);
    263c:	4505                	li	a0,1
    263e:	00003097          	auipc	ra,0x3
    2642:	e8e080e7          	jalr	-370(ra) # 54cc <exit>
    printf("%s: pipe() failed\n", s);
    2646:	85ce                	mv	a1,s3
    2648:	00004517          	auipc	a0,0x4
    264c:	ff050513          	addi	a0,a0,-16 # 6638 <l_free+0xbd2>
    2650:	00003097          	auipc	ra,0x3
    2654:	1f4080e7          	jalr	500(ra) # 5844 <printf>
    exit(1);
    2658:	4505                	li	a0,1
    265a:	00003097          	auipc	ra,0x3
    265e:	e72080e7          	jalr	-398(ra) # 54cc <exit>

0000000000002662 <argptest>:
void argptest(char *s) {
    2662:	1101                	addi	sp,sp,-32
    2664:	ec06                	sd	ra,24(sp)
    2666:	e822                	sd	s0,16(sp)
    2668:	e426                	sd	s1,8(sp)
    266a:	e04a                	sd	s2,0(sp)
    266c:	1000                	addi	s0,sp,32
    266e:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2670:	4581                	li	a1,0
    2672:	00004517          	auipc	a0,0x4
    2676:	52650513          	addi	a0,a0,1318 # 6b98 <l_free+0x1132>
    267a:	00003097          	auipc	ra,0x3
    267e:	e92080e7          	jalr	-366(ra) # 550c <open>
  if (fd < 0) {
    2682:	02054b63          	bltz	a0,26b8 <argptest+0x56>
    2686:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2688:	4501                	li	a0,0
    268a:	00003097          	auipc	ra,0x3
    268e:	eca080e7          	jalr	-310(ra) # 5554 <sbrk>
    2692:	567d                	li	a2,-1
    2694:	fff50593          	addi	a1,a0,-1
    2698:	8526                	mv	a0,s1
    269a:	00003097          	auipc	ra,0x3
    269e:	e4a080e7          	jalr	-438(ra) # 54e4 <read>
  close(fd);
    26a2:	8526                	mv	a0,s1
    26a4:	00003097          	auipc	ra,0x3
    26a8:	e50080e7          	jalr	-432(ra) # 54f4 <close>
}
    26ac:	60e2                	ld	ra,24(sp)
    26ae:	6442                	ld	s0,16(sp)
    26b0:	64a2                	ld	s1,8(sp)
    26b2:	6902                	ld	s2,0(sp)
    26b4:	6105                	addi	sp,sp,32
    26b6:	8082                	ret
    printf("%s: open failed\n", s);
    26b8:	85ca                	mv	a1,s2
    26ba:	00004517          	auipc	a0,0x4
    26be:	e8e50513          	addi	a0,a0,-370 # 6548 <l_free+0xae2>
    26c2:	00003097          	auipc	ra,0x3
    26c6:	182080e7          	jalr	386(ra) # 5844 <printf>
    exit(1);
    26ca:	4505                	li	a0,1
    26cc:	00003097          	auipc	ra,0x3
    26d0:	e00080e7          	jalr	-512(ra) # 54cc <exit>

00000000000026d4 <sbrkbugs>:
void sbrkbugs(char *s) {
    26d4:	1141                	addi	sp,sp,-16
    26d6:	e406                	sd	ra,8(sp)
    26d8:	e022                	sd	s0,0(sp)
    26da:	0800                	addi	s0,sp,16
  int pid = fork();
    26dc:	00003097          	auipc	ra,0x3
    26e0:	de8080e7          	jalr	-536(ra) # 54c4 <fork>
  if (pid < 0) {
    26e4:	02054263          	bltz	a0,2708 <sbrkbugs+0x34>
  if (pid == 0) {
    26e8:	ed0d                	bnez	a0,2722 <sbrkbugs+0x4e>
    int sz = (uint64)sbrk(0);
    26ea:	00003097          	auipc	ra,0x3
    26ee:	e6a080e7          	jalr	-406(ra) # 5554 <sbrk>
    sbrk(-sz);
    26f2:	40a0053b          	negw	a0,a0
    26f6:	00003097          	auipc	ra,0x3
    26fa:	e5e080e7          	jalr	-418(ra) # 5554 <sbrk>
    exit(0);
    26fe:	4501                	li	a0,0
    2700:	00003097          	auipc	ra,0x3
    2704:	dcc080e7          	jalr	-564(ra) # 54cc <exit>
    printf("fork failed\n");
    2708:	00004517          	auipc	a0,0x4
    270c:	21850513          	addi	a0,a0,536 # 6920 <l_free+0xeba>
    2710:	00003097          	auipc	ra,0x3
    2714:	134080e7          	jalr	308(ra) # 5844 <printf>
    exit(1);
    2718:	4505                	li	a0,1
    271a:	00003097          	auipc	ra,0x3
    271e:	db2080e7          	jalr	-590(ra) # 54cc <exit>
  wait(0);
    2722:	4501                	li	a0,0
    2724:	00003097          	auipc	ra,0x3
    2728:	db0080e7          	jalr	-592(ra) # 54d4 <wait>
  pid = fork();
    272c:	00003097          	auipc	ra,0x3
    2730:	d98080e7          	jalr	-616(ra) # 54c4 <fork>
  if (pid < 0) {
    2734:	02054563          	bltz	a0,275e <sbrkbugs+0x8a>
  if (pid == 0) {
    2738:	e121                	bnez	a0,2778 <sbrkbugs+0xa4>
    int sz = (uint64)sbrk(0);
    273a:	00003097          	auipc	ra,0x3
    273e:	e1a080e7          	jalr	-486(ra) # 5554 <sbrk>
    sbrk(-(sz - 3500));
    2742:	6785                	lui	a5,0x1
    2744:	dac7879b          	addiw	a5,a5,-596
    2748:	40a7853b          	subw	a0,a5,a0
    274c:	00003097          	auipc	ra,0x3
    2750:	e08080e7          	jalr	-504(ra) # 5554 <sbrk>
    exit(0);
    2754:	4501                	li	a0,0
    2756:	00003097          	auipc	ra,0x3
    275a:	d76080e7          	jalr	-650(ra) # 54cc <exit>
    printf("fork failed\n");
    275e:	00004517          	auipc	a0,0x4
    2762:	1c250513          	addi	a0,a0,450 # 6920 <l_free+0xeba>
    2766:	00003097          	auipc	ra,0x3
    276a:	0de080e7          	jalr	222(ra) # 5844 <printf>
    exit(1);
    276e:	4505                	li	a0,1
    2770:	00003097          	auipc	ra,0x3
    2774:	d5c080e7          	jalr	-676(ra) # 54cc <exit>
  wait(0);
    2778:	4501                	li	a0,0
    277a:	00003097          	auipc	ra,0x3
    277e:	d5a080e7          	jalr	-678(ra) # 54d4 <wait>
  pid = fork();
    2782:	00003097          	auipc	ra,0x3
    2786:	d42080e7          	jalr	-702(ra) # 54c4 <fork>
  if (pid < 0) {
    278a:	02054a63          	bltz	a0,27be <sbrkbugs+0xea>
  if (pid == 0) {
    278e:	e529                	bnez	a0,27d8 <sbrkbugs+0x104>
    sbrk((10 * 4096 + 2048) - (uint64)sbrk(0));
    2790:	00003097          	auipc	ra,0x3
    2794:	dc4080e7          	jalr	-572(ra) # 5554 <sbrk>
    2798:	67ad                	lui	a5,0xb
    279a:	8007879b          	addiw	a5,a5,-2048
    279e:	40a7853b          	subw	a0,a5,a0
    27a2:	00003097          	auipc	ra,0x3
    27a6:	db2080e7          	jalr	-590(ra) # 5554 <sbrk>
    sbrk(-10);
    27aa:	5559                	li	a0,-10
    27ac:	00003097          	auipc	ra,0x3
    27b0:	da8080e7          	jalr	-600(ra) # 5554 <sbrk>
    exit(0);
    27b4:	4501                	li	a0,0
    27b6:	00003097          	auipc	ra,0x3
    27ba:	d16080e7          	jalr	-746(ra) # 54cc <exit>
    printf("fork failed\n");
    27be:	00004517          	auipc	a0,0x4
    27c2:	16250513          	addi	a0,a0,354 # 6920 <l_free+0xeba>
    27c6:	00003097          	auipc	ra,0x3
    27ca:	07e080e7          	jalr	126(ra) # 5844 <printf>
    exit(1);
    27ce:	4505                	li	a0,1
    27d0:	00003097          	auipc	ra,0x3
    27d4:	cfc080e7          	jalr	-772(ra) # 54cc <exit>
  wait(0);
    27d8:	4501                	li	a0,0
    27da:	00003097          	auipc	ra,0x3
    27de:	cfa080e7          	jalr	-774(ra) # 54d4 <wait>
  exit(0);
    27e2:	4501                	li	a0,0
    27e4:	00003097          	auipc	ra,0x3
    27e8:	ce8080e7          	jalr	-792(ra) # 54cc <exit>

00000000000027ec <execout>:
}

// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void execout(char *s) {
    27ec:	715d                	addi	sp,sp,-80
    27ee:	e486                	sd	ra,72(sp)
    27f0:	e0a2                	sd	s0,64(sp)
    27f2:	fc26                	sd	s1,56(sp)
    27f4:	f84a                	sd	s2,48(sp)
    27f6:	f44e                	sd	s3,40(sp)
    27f8:	f052                	sd	s4,32(sp)
    27fa:	0880                	addi	s0,sp,80
  for (int avail = 0; avail < 15; avail++) {
    27fc:	4901                	li	s2,0
    27fe:	49bd                	li	s3,15
    int pid = fork();
    2800:	00003097          	auipc	ra,0x3
    2804:	cc4080e7          	jalr	-828(ra) # 54c4 <fork>
    2808:	84aa                	mv	s1,a0
    if (pid < 0) {
    280a:	02054063          	bltz	a0,282a <execout+0x3e>
      printf("fork failed\n");
      exit(1);
    } else if (pid == 0) {
    280e:	c91d                	beqz	a0,2844 <execout+0x58>
      close(1);
      char *args[] = {"echo", "x", 0};
      exec("echo", args);
      exit(0);
    } else {
      wait((int *)0);
    2810:	4501                	li	a0,0
    2812:	00003097          	auipc	ra,0x3
    2816:	cc2080e7          	jalr	-830(ra) # 54d4 <wait>
  for (int avail = 0; avail < 15; avail++) {
    281a:	2905                	addiw	s2,s2,1
    281c:	ff3912e3          	bne	s2,s3,2800 <execout+0x14>
    }
  }

  exit(0);
    2820:	4501                	li	a0,0
    2822:	00003097          	auipc	ra,0x3
    2826:	caa080e7          	jalr	-854(ra) # 54cc <exit>
      printf("fork failed\n");
    282a:	00004517          	auipc	a0,0x4
    282e:	0f650513          	addi	a0,a0,246 # 6920 <l_free+0xeba>
    2832:	00003097          	auipc	ra,0x3
    2836:	012080e7          	jalr	18(ra) # 5844 <printf>
      exit(1);
    283a:	4505                	li	a0,1
    283c:	00003097          	auipc	ra,0x3
    2840:	c90080e7          	jalr	-880(ra) # 54cc <exit>
        if (a == 0xffffffffffffffffLL)
    2844:	59fd                	li	s3,-1
        *(char *)(a + 4096 - 1) = 1;
    2846:	4a05                	li	s4,1
        uint64 a = (uint64)sbrk(4096);
    2848:	6505                	lui	a0,0x1
    284a:	00003097          	auipc	ra,0x3
    284e:	d0a080e7          	jalr	-758(ra) # 5554 <sbrk>
        if (a == 0xffffffffffffffffLL)
    2852:	01350763          	beq	a0,s3,2860 <execout+0x74>
        *(char *)(a + 4096 - 1) = 1;
    2856:	6785                	lui	a5,0x1
    2858:	953e                	add	a0,a0,a5
    285a:	ff450fa3          	sb	s4,-1(a0) # fff <bigdir+0x133>
      while (1) {
    285e:	b7ed                	j	2848 <execout+0x5c>
      for (int i = 0; i < avail; i++)
    2860:	01205a63          	blez	s2,2874 <execout+0x88>
        sbrk(-4096);
    2864:	757d                	lui	a0,0xfffff
    2866:	00003097          	auipc	ra,0x3
    286a:	cee080e7          	jalr	-786(ra) # 5554 <sbrk>
      for (int i = 0; i < avail; i++)
    286e:	2485                	addiw	s1,s1,1
    2870:	ff249ae3          	bne	s1,s2,2864 <execout+0x78>
      close(1);
    2874:	4505                	li	a0,1
    2876:	00003097          	auipc	ra,0x3
    287a:	c7e080e7          	jalr	-898(ra) # 54f4 <close>
      char *args[] = {"echo", "x", 0};
    287e:	00003517          	auipc	a0,0x3
    2882:	53a50513          	addi	a0,a0,1338 # 5db8 <l_free+0x352>
    2886:	faa43c23          	sd	a0,-72(s0)
    288a:	00003797          	auipc	a5,0x3
    288e:	59e78793          	addi	a5,a5,1438 # 5e28 <l_free+0x3c2>
    2892:	fcf43023          	sd	a5,-64(s0)
    2896:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    289a:	fb840593          	addi	a1,s0,-72
    289e:	00003097          	auipc	ra,0x3
    28a2:	c66080e7          	jalr	-922(ra) # 5504 <exec>
      exit(0);
    28a6:	4501                	li	a0,0
    28a8:	00003097          	auipc	ra,0x3
    28ac:	c24080e7          	jalr	-988(ra) # 54cc <exit>

00000000000028b0 <fourteen>:
void fourteen(char *s) {
    28b0:	1101                	addi	sp,sp,-32
    28b2:	ec06                	sd	ra,24(sp)
    28b4:	e822                	sd	s0,16(sp)
    28b6:	e426                	sd	s1,8(sp)
    28b8:	1000                	addi	s0,sp,32
    28ba:	84aa                	mv	s1,a0
  if (mkdir("12345678901234") != 0) {
    28bc:	00004517          	auipc	a0,0x4
    28c0:	4b450513          	addi	a0,a0,1204 # 6d70 <l_free+0x130a>
    28c4:	00003097          	auipc	ra,0x3
    28c8:	c70080e7          	jalr	-912(ra) # 5534 <mkdir>
    28cc:	e165                	bnez	a0,29ac <fourteen+0xfc>
  if (mkdir("12345678901234/123456789012345") != 0) {
    28ce:	00004517          	auipc	a0,0x4
    28d2:	2fa50513          	addi	a0,a0,762 # 6bc8 <l_free+0x1162>
    28d6:	00003097          	auipc	ra,0x3
    28da:	c5e080e7          	jalr	-930(ra) # 5534 <mkdir>
    28de:	e56d                	bnez	a0,29c8 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    28e0:	20000593          	li	a1,512
    28e4:	00004517          	auipc	a0,0x4
    28e8:	33c50513          	addi	a0,a0,828 # 6c20 <l_free+0x11ba>
    28ec:	00003097          	auipc	ra,0x3
    28f0:	c20080e7          	jalr	-992(ra) # 550c <open>
  if (fd < 0) {
    28f4:	0e054863          	bltz	a0,29e4 <fourteen+0x134>
  close(fd);
    28f8:	00003097          	auipc	ra,0x3
    28fc:	bfc080e7          	jalr	-1028(ra) # 54f4 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2900:	4581                	li	a1,0
    2902:	00004517          	auipc	a0,0x4
    2906:	39650513          	addi	a0,a0,918 # 6c98 <l_free+0x1232>
    290a:	00003097          	auipc	ra,0x3
    290e:	c02080e7          	jalr	-1022(ra) # 550c <open>
  if (fd < 0) {
    2912:	0e054763          	bltz	a0,2a00 <fourteen+0x150>
  close(fd);
    2916:	00003097          	auipc	ra,0x3
    291a:	bde080e7          	jalr	-1058(ra) # 54f4 <close>
  if (mkdir("12345678901234/12345678901234") == 0) {
    291e:	00004517          	auipc	a0,0x4
    2922:	3ea50513          	addi	a0,a0,1002 # 6d08 <l_free+0x12a2>
    2926:	00003097          	auipc	ra,0x3
    292a:	c0e080e7          	jalr	-1010(ra) # 5534 <mkdir>
    292e:	c57d                	beqz	a0,2a1c <fourteen+0x16c>
  if (mkdir("123456789012345/12345678901234") == 0) {
    2930:	00004517          	auipc	a0,0x4
    2934:	43050513          	addi	a0,a0,1072 # 6d60 <l_free+0x12fa>
    2938:	00003097          	auipc	ra,0x3
    293c:	bfc080e7          	jalr	-1028(ra) # 5534 <mkdir>
    2940:	cd65                	beqz	a0,2a38 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2942:	00004517          	auipc	a0,0x4
    2946:	41e50513          	addi	a0,a0,1054 # 6d60 <l_free+0x12fa>
    294a:	00003097          	auipc	ra,0x3
    294e:	bd2080e7          	jalr	-1070(ra) # 551c <unlink>
  unlink("12345678901234/12345678901234");
    2952:	00004517          	auipc	a0,0x4
    2956:	3b650513          	addi	a0,a0,950 # 6d08 <l_free+0x12a2>
    295a:	00003097          	auipc	ra,0x3
    295e:	bc2080e7          	jalr	-1086(ra) # 551c <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2962:	00004517          	auipc	a0,0x4
    2966:	33650513          	addi	a0,a0,822 # 6c98 <l_free+0x1232>
    296a:	00003097          	auipc	ra,0x3
    296e:	bb2080e7          	jalr	-1102(ra) # 551c <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2972:	00004517          	auipc	a0,0x4
    2976:	2ae50513          	addi	a0,a0,686 # 6c20 <l_free+0x11ba>
    297a:	00003097          	auipc	ra,0x3
    297e:	ba2080e7          	jalr	-1118(ra) # 551c <unlink>
  unlink("12345678901234/123456789012345");
    2982:	00004517          	auipc	a0,0x4
    2986:	24650513          	addi	a0,a0,582 # 6bc8 <l_free+0x1162>
    298a:	00003097          	auipc	ra,0x3
    298e:	b92080e7          	jalr	-1134(ra) # 551c <unlink>
  unlink("12345678901234");
    2992:	00004517          	auipc	a0,0x4
    2996:	3de50513          	addi	a0,a0,990 # 6d70 <l_free+0x130a>
    299a:	00003097          	auipc	ra,0x3
    299e:	b82080e7          	jalr	-1150(ra) # 551c <unlink>
}
    29a2:	60e2                	ld	ra,24(sp)
    29a4:	6442                	ld	s0,16(sp)
    29a6:	64a2                	ld	s1,8(sp)
    29a8:	6105                	addi	sp,sp,32
    29aa:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    29ac:	85a6                	mv	a1,s1
    29ae:	00004517          	auipc	a0,0x4
    29b2:	1f250513          	addi	a0,a0,498 # 6ba0 <l_free+0x113a>
    29b6:	00003097          	auipc	ra,0x3
    29ba:	e8e080e7          	jalr	-370(ra) # 5844 <printf>
    exit(1);
    29be:	4505                	li	a0,1
    29c0:	00003097          	auipc	ra,0x3
    29c4:	b0c080e7          	jalr	-1268(ra) # 54cc <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    29c8:	85a6                	mv	a1,s1
    29ca:	00004517          	auipc	a0,0x4
    29ce:	21e50513          	addi	a0,a0,542 # 6be8 <l_free+0x1182>
    29d2:	00003097          	auipc	ra,0x3
    29d6:	e72080e7          	jalr	-398(ra) # 5844 <printf>
    exit(1);
    29da:	4505                	li	a0,1
    29dc:	00003097          	auipc	ra,0x3
    29e0:	af0080e7          	jalr	-1296(ra) # 54cc <exit>
    printf(
    29e4:	85a6                	mv	a1,s1
    29e6:	00004517          	auipc	a0,0x4
    29ea:	26a50513          	addi	a0,a0,618 # 6c50 <l_free+0x11ea>
    29ee:	00003097          	auipc	ra,0x3
    29f2:	e56080e7          	jalr	-426(ra) # 5844 <printf>
    exit(1);
    29f6:	4505                	li	a0,1
    29f8:	00003097          	auipc	ra,0x3
    29fc:	ad4080e7          	jalr	-1324(ra) # 54cc <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2a00:	85a6                	mv	a1,s1
    2a02:	00004517          	auipc	a0,0x4
    2a06:	2c650513          	addi	a0,a0,710 # 6cc8 <l_free+0x1262>
    2a0a:	00003097          	auipc	ra,0x3
    2a0e:	e3a080e7          	jalr	-454(ra) # 5844 <printf>
    exit(1);
    2a12:	4505                	li	a0,1
    2a14:	00003097          	auipc	ra,0x3
    2a18:	ab8080e7          	jalr	-1352(ra) # 54cc <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2a1c:	85a6                	mv	a1,s1
    2a1e:	00004517          	auipc	a0,0x4
    2a22:	30a50513          	addi	a0,a0,778 # 6d28 <l_free+0x12c2>
    2a26:	00003097          	auipc	ra,0x3
    2a2a:	e1e080e7          	jalr	-482(ra) # 5844 <printf>
    exit(1);
    2a2e:	4505                	li	a0,1
    2a30:	00003097          	auipc	ra,0x3
    2a34:	a9c080e7          	jalr	-1380(ra) # 54cc <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2a38:	85a6                	mv	a1,s1
    2a3a:	00004517          	auipc	a0,0x4
    2a3e:	34650513          	addi	a0,a0,838 # 6d80 <l_free+0x131a>
    2a42:	00003097          	auipc	ra,0x3
    2a46:	e02080e7          	jalr	-510(ra) # 5844 <printf>
    exit(1);
    2a4a:	4505                	li	a0,1
    2a4c:	00003097          	auipc	ra,0x3
    2a50:	a80080e7          	jalr	-1408(ra) # 54cc <exit>

0000000000002a54 <iputtest>:
void iputtest(char *s) {
    2a54:	1101                	addi	sp,sp,-32
    2a56:	ec06                	sd	ra,24(sp)
    2a58:	e822                	sd	s0,16(sp)
    2a5a:	e426                	sd	s1,8(sp)
    2a5c:	1000                	addi	s0,sp,32
    2a5e:	84aa                	mv	s1,a0
  if (mkdir("iputdir") < 0) {
    2a60:	00004517          	auipc	a0,0x4
    2a64:	35850513          	addi	a0,a0,856 # 6db8 <l_free+0x1352>
    2a68:	00003097          	auipc	ra,0x3
    2a6c:	acc080e7          	jalr	-1332(ra) # 5534 <mkdir>
    2a70:	04054563          	bltz	a0,2aba <iputtest+0x66>
  if (chdir("iputdir") < 0) {
    2a74:	00004517          	auipc	a0,0x4
    2a78:	34450513          	addi	a0,a0,836 # 6db8 <l_free+0x1352>
    2a7c:	00003097          	auipc	ra,0x3
    2a80:	ac0080e7          	jalr	-1344(ra) # 553c <chdir>
    2a84:	04054963          	bltz	a0,2ad6 <iputtest+0x82>
  if (unlink("../iputdir") < 0) {
    2a88:	00004517          	auipc	a0,0x4
    2a8c:	37050513          	addi	a0,a0,880 # 6df8 <l_free+0x1392>
    2a90:	00003097          	auipc	ra,0x3
    2a94:	a8c080e7          	jalr	-1396(ra) # 551c <unlink>
    2a98:	04054d63          	bltz	a0,2af2 <iputtest+0x9e>
  if (chdir("/") < 0) {
    2a9c:	00004517          	auipc	a0,0x4
    2aa0:	38c50513          	addi	a0,a0,908 # 6e28 <l_free+0x13c2>
    2aa4:	00003097          	auipc	ra,0x3
    2aa8:	a98080e7          	jalr	-1384(ra) # 553c <chdir>
    2aac:	06054163          	bltz	a0,2b0e <iputtest+0xba>
}
    2ab0:	60e2                	ld	ra,24(sp)
    2ab2:	6442                	ld	s0,16(sp)
    2ab4:	64a2                	ld	s1,8(sp)
    2ab6:	6105                	addi	sp,sp,32
    2ab8:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2aba:	85a6                	mv	a1,s1
    2abc:	00004517          	auipc	a0,0x4
    2ac0:	30450513          	addi	a0,a0,772 # 6dc0 <l_free+0x135a>
    2ac4:	00003097          	auipc	ra,0x3
    2ac8:	d80080e7          	jalr	-640(ra) # 5844 <printf>
    exit(1);
    2acc:	4505                	li	a0,1
    2ace:	00003097          	auipc	ra,0x3
    2ad2:	9fe080e7          	jalr	-1538(ra) # 54cc <exit>
    printf("%s: chdir iputdir failed\n", s);
    2ad6:	85a6                	mv	a1,s1
    2ad8:	00004517          	auipc	a0,0x4
    2adc:	30050513          	addi	a0,a0,768 # 6dd8 <l_free+0x1372>
    2ae0:	00003097          	auipc	ra,0x3
    2ae4:	d64080e7          	jalr	-668(ra) # 5844 <printf>
    exit(1);
    2ae8:	4505                	li	a0,1
    2aea:	00003097          	auipc	ra,0x3
    2aee:	9e2080e7          	jalr	-1566(ra) # 54cc <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2af2:	85a6                	mv	a1,s1
    2af4:	00004517          	auipc	a0,0x4
    2af8:	31450513          	addi	a0,a0,788 # 6e08 <l_free+0x13a2>
    2afc:	00003097          	auipc	ra,0x3
    2b00:	d48080e7          	jalr	-696(ra) # 5844 <printf>
    exit(1);
    2b04:	4505                	li	a0,1
    2b06:	00003097          	auipc	ra,0x3
    2b0a:	9c6080e7          	jalr	-1594(ra) # 54cc <exit>
    printf("%s: chdir / failed\n", s);
    2b0e:	85a6                	mv	a1,s1
    2b10:	00004517          	auipc	a0,0x4
    2b14:	32050513          	addi	a0,a0,800 # 6e30 <l_free+0x13ca>
    2b18:	00003097          	auipc	ra,0x3
    2b1c:	d2c080e7          	jalr	-724(ra) # 5844 <printf>
    exit(1);
    2b20:	4505                	li	a0,1
    2b22:	00003097          	auipc	ra,0x3
    2b26:	9aa080e7          	jalr	-1622(ra) # 54cc <exit>

0000000000002b2a <exitiputtest>:
void exitiputtest(char *s) {
    2b2a:	7179                	addi	sp,sp,-48
    2b2c:	f406                	sd	ra,40(sp)
    2b2e:	f022                	sd	s0,32(sp)
    2b30:	ec26                	sd	s1,24(sp)
    2b32:	1800                	addi	s0,sp,48
    2b34:	84aa                	mv	s1,a0
  pid = fork();
    2b36:	00003097          	auipc	ra,0x3
    2b3a:	98e080e7          	jalr	-1650(ra) # 54c4 <fork>
  if (pid < 0) {
    2b3e:	04054663          	bltz	a0,2b8a <exitiputtest+0x60>
  if (pid == 0) {
    2b42:	ed45                	bnez	a0,2bfa <exitiputtest+0xd0>
    if (mkdir("iputdir") < 0) {
    2b44:	00004517          	auipc	a0,0x4
    2b48:	27450513          	addi	a0,a0,628 # 6db8 <l_free+0x1352>
    2b4c:	00003097          	auipc	ra,0x3
    2b50:	9e8080e7          	jalr	-1560(ra) # 5534 <mkdir>
    2b54:	04054963          	bltz	a0,2ba6 <exitiputtest+0x7c>
    if (chdir("iputdir") < 0) {
    2b58:	00004517          	auipc	a0,0x4
    2b5c:	26050513          	addi	a0,a0,608 # 6db8 <l_free+0x1352>
    2b60:	00003097          	auipc	ra,0x3
    2b64:	9dc080e7          	jalr	-1572(ra) # 553c <chdir>
    2b68:	04054d63          	bltz	a0,2bc2 <exitiputtest+0x98>
    if (unlink("../iputdir") < 0) {
    2b6c:	00004517          	auipc	a0,0x4
    2b70:	28c50513          	addi	a0,a0,652 # 6df8 <l_free+0x1392>
    2b74:	00003097          	auipc	ra,0x3
    2b78:	9a8080e7          	jalr	-1624(ra) # 551c <unlink>
    2b7c:	06054163          	bltz	a0,2bde <exitiputtest+0xb4>
    exit(0);
    2b80:	4501                	li	a0,0
    2b82:	00003097          	auipc	ra,0x3
    2b86:	94a080e7          	jalr	-1718(ra) # 54cc <exit>
    printf("%s: fork failed\n", s);
    2b8a:	85a6                	mv	a1,s1
    2b8c:	00004517          	auipc	a0,0x4
    2b90:	9a450513          	addi	a0,a0,-1628 # 6530 <l_free+0xaca>
    2b94:	00003097          	auipc	ra,0x3
    2b98:	cb0080e7          	jalr	-848(ra) # 5844 <printf>
    exit(1);
    2b9c:	4505                	li	a0,1
    2b9e:	00003097          	auipc	ra,0x3
    2ba2:	92e080e7          	jalr	-1746(ra) # 54cc <exit>
      printf("%s: mkdir failed\n", s);
    2ba6:	85a6                	mv	a1,s1
    2ba8:	00004517          	auipc	a0,0x4
    2bac:	21850513          	addi	a0,a0,536 # 6dc0 <l_free+0x135a>
    2bb0:	00003097          	auipc	ra,0x3
    2bb4:	c94080e7          	jalr	-876(ra) # 5844 <printf>
      exit(1);
    2bb8:	4505                	li	a0,1
    2bba:	00003097          	auipc	ra,0x3
    2bbe:	912080e7          	jalr	-1774(ra) # 54cc <exit>
      printf("%s: child chdir failed\n", s);
    2bc2:	85a6                	mv	a1,s1
    2bc4:	00004517          	auipc	a0,0x4
    2bc8:	28450513          	addi	a0,a0,644 # 6e48 <l_free+0x13e2>
    2bcc:	00003097          	auipc	ra,0x3
    2bd0:	c78080e7          	jalr	-904(ra) # 5844 <printf>
      exit(1);
    2bd4:	4505                	li	a0,1
    2bd6:	00003097          	auipc	ra,0x3
    2bda:	8f6080e7          	jalr	-1802(ra) # 54cc <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2bde:	85a6                	mv	a1,s1
    2be0:	00004517          	auipc	a0,0x4
    2be4:	22850513          	addi	a0,a0,552 # 6e08 <l_free+0x13a2>
    2be8:	00003097          	auipc	ra,0x3
    2bec:	c5c080e7          	jalr	-932(ra) # 5844 <printf>
      exit(1);
    2bf0:	4505                	li	a0,1
    2bf2:	00003097          	auipc	ra,0x3
    2bf6:	8da080e7          	jalr	-1830(ra) # 54cc <exit>
  wait(&xstatus);
    2bfa:	fdc40513          	addi	a0,s0,-36
    2bfe:	00003097          	auipc	ra,0x3
    2c02:	8d6080e7          	jalr	-1834(ra) # 54d4 <wait>
  exit(xstatus);
    2c06:	fdc42503          	lw	a0,-36(s0)
    2c0a:	00003097          	auipc	ra,0x3
    2c0e:	8c2080e7          	jalr	-1854(ra) # 54cc <exit>

0000000000002c12 <subdir>:
void subdir(char *s) {
    2c12:	1101                	addi	sp,sp,-32
    2c14:	ec06                	sd	ra,24(sp)
    2c16:	e822                	sd	s0,16(sp)
    2c18:	e426                	sd	s1,8(sp)
    2c1a:	e04a                	sd	s2,0(sp)
    2c1c:	1000                	addi	s0,sp,32
    2c1e:	892a                	mv	s2,a0
  unlink("ff");
    2c20:	00004517          	auipc	a0,0x4
    2c24:	37050513          	addi	a0,a0,880 # 6f90 <l_free+0x152a>
    2c28:	00003097          	auipc	ra,0x3
    2c2c:	8f4080e7          	jalr	-1804(ra) # 551c <unlink>
  if (mkdir("dd") != 0) {
    2c30:	00004517          	auipc	a0,0x4
    2c34:	23050513          	addi	a0,a0,560 # 6e60 <l_free+0x13fa>
    2c38:	00003097          	auipc	ra,0x3
    2c3c:	8fc080e7          	jalr	-1796(ra) # 5534 <mkdir>
    2c40:	38051663          	bnez	a0,2fcc <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2c44:	20200593          	li	a1,514
    2c48:	00004517          	auipc	a0,0x4
    2c4c:	23850513          	addi	a0,a0,568 # 6e80 <l_free+0x141a>
    2c50:	00003097          	auipc	ra,0x3
    2c54:	8bc080e7          	jalr	-1860(ra) # 550c <open>
    2c58:	84aa                	mv	s1,a0
  if (fd < 0) {
    2c5a:	38054763          	bltz	a0,2fe8 <subdir+0x3d6>
  write(fd, "ff", 2);
    2c5e:	4609                	li	a2,2
    2c60:	00004597          	auipc	a1,0x4
    2c64:	33058593          	addi	a1,a1,816 # 6f90 <l_free+0x152a>
    2c68:	00003097          	auipc	ra,0x3
    2c6c:	884080e7          	jalr	-1916(ra) # 54ec <write>
  close(fd);
    2c70:	8526                	mv	a0,s1
    2c72:	00003097          	auipc	ra,0x3
    2c76:	882080e7          	jalr	-1918(ra) # 54f4 <close>
  if (unlink("dd") >= 0) {
    2c7a:	00004517          	auipc	a0,0x4
    2c7e:	1e650513          	addi	a0,a0,486 # 6e60 <l_free+0x13fa>
    2c82:	00003097          	auipc	ra,0x3
    2c86:	89a080e7          	jalr	-1894(ra) # 551c <unlink>
    2c8a:	36055d63          	bgez	a0,3004 <subdir+0x3f2>
  if (mkdir("/dd/dd") != 0) {
    2c8e:	00004517          	auipc	a0,0x4
    2c92:	24a50513          	addi	a0,a0,586 # 6ed8 <l_free+0x1472>
    2c96:	00003097          	auipc	ra,0x3
    2c9a:	89e080e7          	jalr	-1890(ra) # 5534 <mkdir>
    2c9e:	38051163          	bnez	a0,3020 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2ca2:	20200593          	li	a1,514
    2ca6:	00004517          	auipc	a0,0x4
    2caa:	25a50513          	addi	a0,a0,602 # 6f00 <l_free+0x149a>
    2cae:	00003097          	auipc	ra,0x3
    2cb2:	85e080e7          	jalr	-1954(ra) # 550c <open>
    2cb6:	84aa                	mv	s1,a0
  if (fd < 0) {
    2cb8:	38054263          	bltz	a0,303c <subdir+0x42a>
  write(fd, "FF", 2);
    2cbc:	4609                	li	a2,2
    2cbe:	00004597          	auipc	a1,0x4
    2cc2:	27258593          	addi	a1,a1,626 # 6f30 <l_free+0x14ca>
    2cc6:	00003097          	auipc	ra,0x3
    2cca:	826080e7          	jalr	-2010(ra) # 54ec <write>
  close(fd);
    2cce:	8526                	mv	a0,s1
    2cd0:	00003097          	auipc	ra,0x3
    2cd4:	824080e7          	jalr	-2012(ra) # 54f4 <close>
  fd = open("dd/dd/../ff", 0);
    2cd8:	4581                	li	a1,0
    2cda:	00004517          	auipc	a0,0x4
    2cde:	25e50513          	addi	a0,a0,606 # 6f38 <l_free+0x14d2>
    2ce2:	00003097          	auipc	ra,0x3
    2ce6:	82a080e7          	jalr	-2006(ra) # 550c <open>
    2cea:	84aa                	mv	s1,a0
  if (fd < 0) {
    2cec:	36054663          	bltz	a0,3058 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    2cf0:	660d                	lui	a2,0x3
    2cf2:	00009597          	auipc	a1,0x9
    2cf6:	cc658593          	addi	a1,a1,-826 # b9b8 <buf>
    2cfa:	00002097          	auipc	ra,0x2
    2cfe:	7ea080e7          	jalr	2026(ra) # 54e4 <read>
  if (cc != 2 || buf[0] != 'f') {
    2d02:	4789                	li	a5,2
    2d04:	36f51863          	bne	a0,a5,3074 <subdir+0x462>
    2d08:	00009717          	auipc	a4,0x9
    2d0c:	cb074703          	lbu	a4,-848(a4) # b9b8 <buf>
    2d10:	06600793          	li	a5,102
    2d14:	36f71063          	bne	a4,a5,3074 <subdir+0x462>
  close(fd);
    2d18:	8526                	mv	a0,s1
    2d1a:	00002097          	auipc	ra,0x2
    2d1e:	7da080e7          	jalr	2010(ra) # 54f4 <close>
  if (link("dd/dd/ff", "dd/dd/ffff") != 0) {
    2d22:	00004597          	auipc	a1,0x4
    2d26:	26658593          	addi	a1,a1,614 # 6f88 <l_free+0x1522>
    2d2a:	00004517          	auipc	a0,0x4
    2d2e:	1d650513          	addi	a0,a0,470 # 6f00 <l_free+0x149a>
    2d32:	00002097          	auipc	ra,0x2
    2d36:	7fa080e7          	jalr	2042(ra) # 552c <link>
    2d3a:	34051b63          	bnez	a0,3090 <subdir+0x47e>
  if (unlink("dd/dd/ff") != 0) {
    2d3e:	00004517          	auipc	a0,0x4
    2d42:	1c250513          	addi	a0,a0,450 # 6f00 <l_free+0x149a>
    2d46:	00002097          	auipc	ra,0x2
    2d4a:	7d6080e7          	jalr	2006(ra) # 551c <unlink>
    2d4e:	34051f63          	bnez	a0,30ac <subdir+0x49a>
  if (open("dd/dd/ff", O_RDONLY) >= 0) {
    2d52:	4581                	li	a1,0
    2d54:	00004517          	auipc	a0,0x4
    2d58:	1ac50513          	addi	a0,a0,428 # 6f00 <l_free+0x149a>
    2d5c:	00002097          	auipc	ra,0x2
    2d60:	7b0080e7          	jalr	1968(ra) # 550c <open>
    2d64:	36055263          	bgez	a0,30c8 <subdir+0x4b6>
  if (chdir("dd") != 0) {
    2d68:	00004517          	auipc	a0,0x4
    2d6c:	0f850513          	addi	a0,a0,248 # 6e60 <l_free+0x13fa>
    2d70:	00002097          	auipc	ra,0x2
    2d74:	7cc080e7          	jalr	1996(ra) # 553c <chdir>
    2d78:	36051663          	bnez	a0,30e4 <subdir+0x4d2>
  if (chdir("dd/../../dd") != 0) {
    2d7c:	00004517          	auipc	a0,0x4
    2d80:	2a450513          	addi	a0,a0,676 # 7020 <l_free+0x15ba>
    2d84:	00002097          	auipc	ra,0x2
    2d88:	7b8080e7          	jalr	1976(ra) # 553c <chdir>
    2d8c:	36051a63          	bnez	a0,3100 <subdir+0x4ee>
  if (chdir("dd/../../../dd") != 0) {
    2d90:	00004517          	auipc	a0,0x4
    2d94:	2c050513          	addi	a0,a0,704 # 7050 <l_free+0x15ea>
    2d98:	00002097          	auipc	ra,0x2
    2d9c:	7a4080e7          	jalr	1956(ra) # 553c <chdir>
    2da0:	36051e63          	bnez	a0,311c <subdir+0x50a>
  if (chdir("./..") != 0) {
    2da4:	00004517          	auipc	a0,0x4
    2da8:	2dc50513          	addi	a0,a0,732 # 7080 <l_free+0x161a>
    2dac:	00002097          	auipc	ra,0x2
    2db0:	790080e7          	jalr	1936(ra) # 553c <chdir>
    2db4:	38051263          	bnez	a0,3138 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    2db8:	4581                	li	a1,0
    2dba:	00004517          	auipc	a0,0x4
    2dbe:	1ce50513          	addi	a0,a0,462 # 6f88 <l_free+0x1522>
    2dc2:	00002097          	auipc	ra,0x2
    2dc6:	74a080e7          	jalr	1866(ra) # 550c <open>
    2dca:	84aa                	mv	s1,a0
  if (fd < 0) {
    2dcc:	38054463          	bltz	a0,3154 <subdir+0x542>
  if (read(fd, buf, sizeof(buf)) != 2) {
    2dd0:	660d                	lui	a2,0x3
    2dd2:	00009597          	auipc	a1,0x9
    2dd6:	be658593          	addi	a1,a1,-1050 # b9b8 <buf>
    2dda:	00002097          	auipc	ra,0x2
    2dde:	70a080e7          	jalr	1802(ra) # 54e4 <read>
    2de2:	4789                	li	a5,2
    2de4:	38f51663          	bne	a0,a5,3170 <subdir+0x55e>
  close(fd);
    2de8:	8526                	mv	a0,s1
    2dea:	00002097          	auipc	ra,0x2
    2dee:	70a080e7          	jalr	1802(ra) # 54f4 <close>
  if (open("dd/dd/ff", O_RDONLY) >= 0) {
    2df2:	4581                	li	a1,0
    2df4:	00004517          	auipc	a0,0x4
    2df8:	10c50513          	addi	a0,a0,268 # 6f00 <l_free+0x149a>
    2dfc:	00002097          	auipc	ra,0x2
    2e00:	710080e7          	jalr	1808(ra) # 550c <open>
    2e04:	38055463          	bgez	a0,318c <subdir+0x57a>
  if (open("dd/ff/ff", O_CREATE | O_RDWR) >= 0) {
    2e08:	20200593          	li	a1,514
    2e0c:	00004517          	auipc	a0,0x4
    2e10:	30450513          	addi	a0,a0,772 # 7110 <l_free+0x16aa>
    2e14:	00002097          	auipc	ra,0x2
    2e18:	6f8080e7          	jalr	1784(ra) # 550c <open>
    2e1c:	38055663          	bgez	a0,31a8 <subdir+0x596>
  if (open("dd/xx/ff", O_CREATE | O_RDWR) >= 0) {
    2e20:	20200593          	li	a1,514
    2e24:	00004517          	auipc	a0,0x4
    2e28:	31c50513          	addi	a0,a0,796 # 7140 <l_free+0x16da>
    2e2c:	00002097          	auipc	ra,0x2
    2e30:	6e0080e7          	jalr	1760(ra) # 550c <open>
    2e34:	38055863          	bgez	a0,31c4 <subdir+0x5b2>
  if (open("dd", O_CREATE) >= 0) {
    2e38:	20000593          	li	a1,512
    2e3c:	00004517          	auipc	a0,0x4
    2e40:	02450513          	addi	a0,a0,36 # 6e60 <l_free+0x13fa>
    2e44:	00002097          	auipc	ra,0x2
    2e48:	6c8080e7          	jalr	1736(ra) # 550c <open>
    2e4c:	38055a63          	bgez	a0,31e0 <subdir+0x5ce>
  if (open("dd", O_RDWR) >= 0) {
    2e50:	4589                	li	a1,2
    2e52:	00004517          	auipc	a0,0x4
    2e56:	00e50513          	addi	a0,a0,14 # 6e60 <l_free+0x13fa>
    2e5a:	00002097          	auipc	ra,0x2
    2e5e:	6b2080e7          	jalr	1714(ra) # 550c <open>
    2e62:	38055d63          	bgez	a0,31fc <subdir+0x5ea>
  if (open("dd", O_WRONLY) >= 0) {
    2e66:	4585                	li	a1,1
    2e68:	00004517          	auipc	a0,0x4
    2e6c:	ff850513          	addi	a0,a0,-8 # 6e60 <l_free+0x13fa>
    2e70:	00002097          	auipc	ra,0x2
    2e74:	69c080e7          	jalr	1692(ra) # 550c <open>
    2e78:	3a055063          	bgez	a0,3218 <subdir+0x606>
  if (link("dd/ff/ff", "dd/dd/xx") == 0) {
    2e7c:	00004597          	auipc	a1,0x4
    2e80:	35458593          	addi	a1,a1,852 # 71d0 <l_free+0x176a>
    2e84:	00004517          	auipc	a0,0x4
    2e88:	28c50513          	addi	a0,a0,652 # 7110 <l_free+0x16aa>
    2e8c:	00002097          	auipc	ra,0x2
    2e90:	6a0080e7          	jalr	1696(ra) # 552c <link>
    2e94:	3a050063          	beqz	a0,3234 <subdir+0x622>
  if (link("dd/xx/ff", "dd/dd/xx") == 0) {
    2e98:	00004597          	auipc	a1,0x4
    2e9c:	33858593          	addi	a1,a1,824 # 71d0 <l_free+0x176a>
    2ea0:	00004517          	auipc	a0,0x4
    2ea4:	2a050513          	addi	a0,a0,672 # 7140 <l_free+0x16da>
    2ea8:	00002097          	auipc	ra,0x2
    2eac:	684080e7          	jalr	1668(ra) # 552c <link>
    2eb0:	3a050063          	beqz	a0,3250 <subdir+0x63e>
  if (link("dd/ff", "dd/dd/ffff") == 0) {
    2eb4:	00004597          	auipc	a1,0x4
    2eb8:	0d458593          	addi	a1,a1,212 # 6f88 <l_free+0x1522>
    2ebc:	00004517          	auipc	a0,0x4
    2ec0:	fc450513          	addi	a0,a0,-60 # 6e80 <l_free+0x141a>
    2ec4:	00002097          	auipc	ra,0x2
    2ec8:	668080e7          	jalr	1640(ra) # 552c <link>
    2ecc:	3a050063          	beqz	a0,326c <subdir+0x65a>
  if (mkdir("dd/ff/ff") == 0) {
    2ed0:	00004517          	auipc	a0,0x4
    2ed4:	24050513          	addi	a0,a0,576 # 7110 <l_free+0x16aa>
    2ed8:	00002097          	auipc	ra,0x2
    2edc:	65c080e7          	jalr	1628(ra) # 5534 <mkdir>
    2ee0:	3a050463          	beqz	a0,3288 <subdir+0x676>
  if (mkdir("dd/xx/ff") == 0) {
    2ee4:	00004517          	auipc	a0,0x4
    2ee8:	25c50513          	addi	a0,a0,604 # 7140 <l_free+0x16da>
    2eec:	00002097          	auipc	ra,0x2
    2ef0:	648080e7          	jalr	1608(ra) # 5534 <mkdir>
    2ef4:	3a050863          	beqz	a0,32a4 <subdir+0x692>
  if (mkdir("dd/dd/ffff") == 0) {
    2ef8:	00004517          	auipc	a0,0x4
    2efc:	09050513          	addi	a0,a0,144 # 6f88 <l_free+0x1522>
    2f00:	00002097          	auipc	ra,0x2
    2f04:	634080e7          	jalr	1588(ra) # 5534 <mkdir>
    2f08:	3a050c63          	beqz	a0,32c0 <subdir+0x6ae>
  if (unlink("dd/xx/ff") == 0) {
    2f0c:	00004517          	auipc	a0,0x4
    2f10:	23450513          	addi	a0,a0,564 # 7140 <l_free+0x16da>
    2f14:	00002097          	auipc	ra,0x2
    2f18:	608080e7          	jalr	1544(ra) # 551c <unlink>
    2f1c:	3c050063          	beqz	a0,32dc <subdir+0x6ca>
  if (unlink("dd/ff/ff") == 0) {
    2f20:	00004517          	auipc	a0,0x4
    2f24:	1f050513          	addi	a0,a0,496 # 7110 <l_free+0x16aa>
    2f28:	00002097          	auipc	ra,0x2
    2f2c:	5f4080e7          	jalr	1524(ra) # 551c <unlink>
    2f30:	3c050463          	beqz	a0,32f8 <subdir+0x6e6>
  if (chdir("dd/ff") == 0) {
    2f34:	00004517          	auipc	a0,0x4
    2f38:	f4c50513          	addi	a0,a0,-180 # 6e80 <l_free+0x141a>
    2f3c:	00002097          	auipc	ra,0x2
    2f40:	600080e7          	jalr	1536(ra) # 553c <chdir>
    2f44:	3c050863          	beqz	a0,3314 <subdir+0x702>
  if (chdir("dd/xx") == 0) {
    2f48:	00004517          	auipc	a0,0x4
    2f4c:	3d850513          	addi	a0,a0,984 # 7320 <l_free+0x18ba>
    2f50:	00002097          	auipc	ra,0x2
    2f54:	5ec080e7          	jalr	1516(ra) # 553c <chdir>
    2f58:	3c050c63          	beqz	a0,3330 <subdir+0x71e>
  if (unlink("dd/dd/ffff") != 0) {
    2f5c:	00004517          	auipc	a0,0x4
    2f60:	02c50513          	addi	a0,a0,44 # 6f88 <l_free+0x1522>
    2f64:	00002097          	auipc	ra,0x2
    2f68:	5b8080e7          	jalr	1464(ra) # 551c <unlink>
    2f6c:	3e051063          	bnez	a0,334c <subdir+0x73a>
  if (unlink("dd/ff") != 0) {
    2f70:	00004517          	auipc	a0,0x4
    2f74:	f1050513          	addi	a0,a0,-240 # 6e80 <l_free+0x141a>
    2f78:	00002097          	auipc	ra,0x2
    2f7c:	5a4080e7          	jalr	1444(ra) # 551c <unlink>
    2f80:	3e051463          	bnez	a0,3368 <subdir+0x756>
  if (unlink("dd") == 0) {
    2f84:	00004517          	auipc	a0,0x4
    2f88:	edc50513          	addi	a0,a0,-292 # 6e60 <l_free+0x13fa>
    2f8c:	00002097          	auipc	ra,0x2
    2f90:	590080e7          	jalr	1424(ra) # 551c <unlink>
    2f94:	3e050863          	beqz	a0,3384 <subdir+0x772>
  if (unlink("dd/dd") < 0) {
    2f98:	00004517          	auipc	a0,0x4
    2f9c:	3f850513          	addi	a0,a0,1016 # 7390 <l_free+0x192a>
    2fa0:	00002097          	auipc	ra,0x2
    2fa4:	57c080e7          	jalr	1404(ra) # 551c <unlink>
    2fa8:	3e054c63          	bltz	a0,33a0 <subdir+0x78e>
  if (unlink("dd") < 0) {
    2fac:	00004517          	auipc	a0,0x4
    2fb0:	eb450513          	addi	a0,a0,-332 # 6e60 <l_free+0x13fa>
    2fb4:	00002097          	auipc	ra,0x2
    2fb8:	568080e7          	jalr	1384(ra) # 551c <unlink>
    2fbc:	40054063          	bltz	a0,33bc <subdir+0x7aa>
}
    2fc0:	60e2                	ld	ra,24(sp)
    2fc2:	6442                	ld	s0,16(sp)
    2fc4:	64a2                	ld	s1,8(sp)
    2fc6:	6902                	ld	s2,0(sp)
    2fc8:	6105                	addi	sp,sp,32
    2fca:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    2fcc:	85ca                	mv	a1,s2
    2fce:	00004517          	auipc	a0,0x4
    2fd2:	e9a50513          	addi	a0,a0,-358 # 6e68 <l_free+0x1402>
    2fd6:	00003097          	auipc	ra,0x3
    2fda:	86e080e7          	jalr	-1938(ra) # 5844 <printf>
    exit(1);
    2fde:	4505                	li	a0,1
    2fe0:	00002097          	auipc	ra,0x2
    2fe4:	4ec080e7          	jalr	1260(ra) # 54cc <exit>
    printf("%s: create dd/ff failed\n", s);
    2fe8:	85ca                	mv	a1,s2
    2fea:	00004517          	auipc	a0,0x4
    2fee:	e9e50513          	addi	a0,a0,-354 # 6e88 <l_free+0x1422>
    2ff2:	00003097          	auipc	ra,0x3
    2ff6:	852080e7          	jalr	-1966(ra) # 5844 <printf>
    exit(1);
    2ffa:	4505                	li	a0,1
    2ffc:	00002097          	auipc	ra,0x2
    3000:	4d0080e7          	jalr	1232(ra) # 54cc <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3004:	85ca                	mv	a1,s2
    3006:	00004517          	auipc	a0,0x4
    300a:	ea250513          	addi	a0,a0,-350 # 6ea8 <l_free+0x1442>
    300e:	00003097          	auipc	ra,0x3
    3012:	836080e7          	jalr	-1994(ra) # 5844 <printf>
    exit(1);
    3016:	4505                	li	a0,1
    3018:	00002097          	auipc	ra,0x2
    301c:	4b4080e7          	jalr	1204(ra) # 54cc <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3020:	85ca                	mv	a1,s2
    3022:	00004517          	auipc	a0,0x4
    3026:	ebe50513          	addi	a0,a0,-322 # 6ee0 <l_free+0x147a>
    302a:	00003097          	auipc	ra,0x3
    302e:	81a080e7          	jalr	-2022(ra) # 5844 <printf>
    exit(1);
    3032:	4505                	li	a0,1
    3034:	00002097          	auipc	ra,0x2
    3038:	498080e7          	jalr	1176(ra) # 54cc <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    303c:	85ca                	mv	a1,s2
    303e:	00004517          	auipc	a0,0x4
    3042:	ed250513          	addi	a0,a0,-302 # 6f10 <l_free+0x14aa>
    3046:	00002097          	auipc	ra,0x2
    304a:	7fe080e7          	jalr	2046(ra) # 5844 <printf>
    exit(1);
    304e:	4505                	li	a0,1
    3050:	00002097          	auipc	ra,0x2
    3054:	47c080e7          	jalr	1148(ra) # 54cc <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3058:	85ca                	mv	a1,s2
    305a:	00004517          	auipc	a0,0x4
    305e:	eee50513          	addi	a0,a0,-274 # 6f48 <l_free+0x14e2>
    3062:	00002097          	auipc	ra,0x2
    3066:	7e2080e7          	jalr	2018(ra) # 5844 <printf>
    exit(1);
    306a:	4505                	li	a0,1
    306c:	00002097          	auipc	ra,0x2
    3070:	460080e7          	jalr	1120(ra) # 54cc <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3074:	85ca                	mv	a1,s2
    3076:	00004517          	auipc	a0,0x4
    307a:	ef250513          	addi	a0,a0,-270 # 6f68 <l_free+0x1502>
    307e:	00002097          	auipc	ra,0x2
    3082:	7c6080e7          	jalr	1990(ra) # 5844 <printf>
    exit(1);
    3086:	4505                	li	a0,1
    3088:	00002097          	auipc	ra,0x2
    308c:	444080e7          	jalr	1092(ra) # 54cc <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3090:	85ca                	mv	a1,s2
    3092:	00004517          	auipc	a0,0x4
    3096:	f0650513          	addi	a0,a0,-250 # 6f98 <l_free+0x1532>
    309a:	00002097          	auipc	ra,0x2
    309e:	7aa080e7          	jalr	1962(ra) # 5844 <printf>
    exit(1);
    30a2:	4505                	li	a0,1
    30a4:	00002097          	auipc	ra,0x2
    30a8:	428080e7          	jalr	1064(ra) # 54cc <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    30ac:	85ca                	mv	a1,s2
    30ae:	00004517          	auipc	a0,0x4
    30b2:	f1250513          	addi	a0,a0,-238 # 6fc0 <l_free+0x155a>
    30b6:	00002097          	auipc	ra,0x2
    30ba:	78e080e7          	jalr	1934(ra) # 5844 <printf>
    exit(1);
    30be:	4505                	li	a0,1
    30c0:	00002097          	auipc	ra,0x2
    30c4:	40c080e7          	jalr	1036(ra) # 54cc <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    30c8:	85ca                	mv	a1,s2
    30ca:	00004517          	auipc	a0,0x4
    30ce:	f1650513          	addi	a0,a0,-234 # 6fe0 <l_free+0x157a>
    30d2:	00002097          	auipc	ra,0x2
    30d6:	772080e7          	jalr	1906(ra) # 5844 <printf>
    exit(1);
    30da:	4505                	li	a0,1
    30dc:	00002097          	auipc	ra,0x2
    30e0:	3f0080e7          	jalr	1008(ra) # 54cc <exit>
    printf("%s: chdir dd failed\n", s);
    30e4:	85ca                	mv	a1,s2
    30e6:	00004517          	auipc	a0,0x4
    30ea:	f2250513          	addi	a0,a0,-222 # 7008 <l_free+0x15a2>
    30ee:	00002097          	auipc	ra,0x2
    30f2:	756080e7          	jalr	1878(ra) # 5844 <printf>
    exit(1);
    30f6:	4505                	li	a0,1
    30f8:	00002097          	auipc	ra,0x2
    30fc:	3d4080e7          	jalr	980(ra) # 54cc <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3100:	85ca                	mv	a1,s2
    3102:	00004517          	auipc	a0,0x4
    3106:	f2e50513          	addi	a0,a0,-210 # 7030 <l_free+0x15ca>
    310a:	00002097          	auipc	ra,0x2
    310e:	73a080e7          	jalr	1850(ra) # 5844 <printf>
    exit(1);
    3112:	4505                	li	a0,1
    3114:	00002097          	auipc	ra,0x2
    3118:	3b8080e7          	jalr	952(ra) # 54cc <exit>
    printf("chdir dd/../../dd failed\n", s);
    311c:	85ca                	mv	a1,s2
    311e:	00004517          	auipc	a0,0x4
    3122:	f4250513          	addi	a0,a0,-190 # 7060 <l_free+0x15fa>
    3126:	00002097          	auipc	ra,0x2
    312a:	71e080e7          	jalr	1822(ra) # 5844 <printf>
    exit(1);
    312e:	4505                	li	a0,1
    3130:	00002097          	auipc	ra,0x2
    3134:	39c080e7          	jalr	924(ra) # 54cc <exit>
    printf("%s: chdir ./.. failed\n", s);
    3138:	85ca                	mv	a1,s2
    313a:	00004517          	auipc	a0,0x4
    313e:	f4e50513          	addi	a0,a0,-178 # 7088 <l_free+0x1622>
    3142:	00002097          	auipc	ra,0x2
    3146:	702080e7          	jalr	1794(ra) # 5844 <printf>
    exit(1);
    314a:	4505                	li	a0,1
    314c:	00002097          	auipc	ra,0x2
    3150:	380080e7          	jalr	896(ra) # 54cc <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3154:	85ca                	mv	a1,s2
    3156:	00004517          	auipc	a0,0x4
    315a:	f4a50513          	addi	a0,a0,-182 # 70a0 <l_free+0x163a>
    315e:	00002097          	auipc	ra,0x2
    3162:	6e6080e7          	jalr	1766(ra) # 5844 <printf>
    exit(1);
    3166:	4505                	li	a0,1
    3168:	00002097          	auipc	ra,0x2
    316c:	364080e7          	jalr	868(ra) # 54cc <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3170:	85ca                	mv	a1,s2
    3172:	00004517          	auipc	a0,0x4
    3176:	f4e50513          	addi	a0,a0,-178 # 70c0 <l_free+0x165a>
    317a:	00002097          	auipc	ra,0x2
    317e:	6ca080e7          	jalr	1738(ra) # 5844 <printf>
    exit(1);
    3182:	4505                	li	a0,1
    3184:	00002097          	auipc	ra,0x2
    3188:	348080e7          	jalr	840(ra) # 54cc <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    318c:	85ca                	mv	a1,s2
    318e:	00004517          	auipc	a0,0x4
    3192:	f5250513          	addi	a0,a0,-174 # 70e0 <l_free+0x167a>
    3196:	00002097          	auipc	ra,0x2
    319a:	6ae080e7          	jalr	1710(ra) # 5844 <printf>
    exit(1);
    319e:	4505                	li	a0,1
    31a0:	00002097          	auipc	ra,0x2
    31a4:	32c080e7          	jalr	812(ra) # 54cc <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    31a8:	85ca                	mv	a1,s2
    31aa:	00004517          	auipc	a0,0x4
    31ae:	f7650513          	addi	a0,a0,-138 # 7120 <l_free+0x16ba>
    31b2:	00002097          	auipc	ra,0x2
    31b6:	692080e7          	jalr	1682(ra) # 5844 <printf>
    exit(1);
    31ba:	4505                	li	a0,1
    31bc:	00002097          	auipc	ra,0x2
    31c0:	310080e7          	jalr	784(ra) # 54cc <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    31c4:	85ca                	mv	a1,s2
    31c6:	00004517          	auipc	a0,0x4
    31ca:	f8a50513          	addi	a0,a0,-118 # 7150 <l_free+0x16ea>
    31ce:	00002097          	auipc	ra,0x2
    31d2:	676080e7          	jalr	1654(ra) # 5844 <printf>
    exit(1);
    31d6:	4505                	li	a0,1
    31d8:	00002097          	auipc	ra,0x2
    31dc:	2f4080e7          	jalr	756(ra) # 54cc <exit>
    printf("%s: create dd succeeded!\n", s);
    31e0:	85ca                	mv	a1,s2
    31e2:	00004517          	auipc	a0,0x4
    31e6:	f8e50513          	addi	a0,a0,-114 # 7170 <l_free+0x170a>
    31ea:	00002097          	auipc	ra,0x2
    31ee:	65a080e7          	jalr	1626(ra) # 5844 <printf>
    exit(1);
    31f2:	4505                	li	a0,1
    31f4:	00002097          	auipc	ra,0x2
    31f8:	2d8080e7          	jalr	728(ra) # 54cc <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    31fc:	85ca                	mv	a1,s2
    31fe:	00004517          	auipc	a0,0x4
    3202:	f9250513          	addi	a0,a0,-110 # 7190 <l_free+0x172a>
    3206:	00002097          	auipc	ra,0x2
    320a:	63e080e7          	jalr	1598(ra) # 5844 <printf>
    exit(1);
    320e:	4505                	li	a0,1
    3210:	00002097          	auipc	ra,0x2
    3214:	2bc080e7          	jalr	700(ra) # 54cc <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3218:	85ca                	mv	a1,s2
    321a:	00004517          	auipc	a0,0x4
    321e:	f9650513          	addi	a0,a0,-106 # 71b0 <l_free+0x174a>
    3222:	00002097          	auipc	ra,0x2
    3226:	622080e7          	jalr	1570(ra) # 5844 <printf>
    exit(1);
    322a:	4505                	li	a0,1
    322c:	00002097          	auipc	ra,0x2
    3230:	2a0080e7          	jalr	672(ra) # 54cc <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3234:	85ca                	mv	a1,s2
    3236:	00004517          	auipc	a0,0x4
    323a:	faa50513          	addi	a0,a0,-86 # 71e0 <l_free+0x177a>
    323e:	00002097          	auipc	ra,0x2
    3242:	606080e7          	jalr	1542(ra) # 5844 <printf>
    exit(1);
    3246:	4505                	li	a0,1
    3248:	00002097          	auipc	ra,0x2
    324c:	284080e7          	jalr	644(ra) # 54cc <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3250:	85ca                	mv	a1,s2
    3252:	00004517          	auipc	a0,0x4
    3256:	fb650513          	addi	a0,a0,-74 # 7208 <l_free+0x17a2>
    325a:	00002097          	auipc	ra,0x2
    325e:	5ea080e7          	jalr	1514(ra) # 5844 <printf>
    exit(1);
    3262:	4505                	li	a0,1
    3264:	00002097          	auipc	ra,0x2
    3268:	268080e7          	jalr	616(ra) # 54cc <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    326c:	85ca                	mv	a1,s2
    326e:	00004517          	auipc	a0,0x4
    3272:	fc250513          	addi	a0,a0,-62 # 7230 <l_free+0x17ca>
    3276:	00002097          	auipc	ra,0x2
    327a:	5ce080e7          	jalr	1486(ra) # 5844 <printf>
    exit(1);
    327e:	4505                	li	a0,1
    3280:	00002097          	auipc	ra,0x2
    3284:	24c080e7          	jalr	588(ra) # 54cc <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3288:	85ca                	mv	a1,s2
    328a:	00004517          	auipc	a0,0x4
    328e:	fce50513          	addi	a0,a0,-50 # 7258 <l_free+0x17f2>
    3292:	00002097          	auipc	ra,0x2
    3296:	5b2080e7          	jalr	1458(ra) # 5844 <printf>
    exit(1);
    329a:	4505                	li	a0,1
    329c:	00002097          	auipc	ra,0x2
    32a0:	230080e7          	jalr	560(ra) # 54cc <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    32a4:	85ca                	mv	a1,s2
    32a6:	00004517          	auipc	a0,0x4
    32aa:	fd250513          	addi	a0,a0,-46 # 7278 <l_free+0x1812>
    32ae:	00002097          	auipc	ra,0x2
    32b2:	596080e7          	jalr	1430(ra) # 5844 <printf>
    exit(1);
    32b6:	4505                	li	a0,1
    32b8:	00002097          	auipc	ra,0x2
    32bc:	214080e7          	jalr	532(ra) # 54cc <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    32c0:	85ca                	mv	a1,s2
    32c2:	00004517          	auipc	a0,0x4
    32c6:	fd650513          	addi	a0,a0,-42 # 7298 <l_free+0x1832>
    32ca:	00002097          	auipc	ra,0x2
    32ce:	57a080e7          	jalr	1402(ra) # 5844 <printf>
    exit(1);
    32d2:	4505                	li	a0,1
    32d4:	00002097          	auipc	ra,0x2
    32d8:	1f8080e7          	jalr	504(ra) # 54cc <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    32dc:	85ca                	mv	a1,s2
    32de:	00004517          	auipc	a0,0x4
    32e2:	fe250513          	addi	a0,a0,-30 # 72c0 <l_free+0x185a>
    32e6:	00002097          	auipc	ra,0x2
    32ea:	55e080e7          	jalr	1374(ra) # 5844 <printf>
    exit(1);
    32ee:	4505                	li	a0,1
    32f0:	00002097          	auipc	ra,0x2
    32f4:	1dc080e7          	jalr	476(ra) # 54cc <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    32f8:	85ca                	mv	a1,s2
    32fa:	00004517          	auipc	a0,0x4
    32fe:	fe650513          	addi	a0,a0,-26 # 72e0 <l_free+0x187a>
    3302:	00002097          	auipc	ra,0x2
    3306:	542080e7          	jalr	1346(ra) # 5844 <printf>
    exit(1);
    330a:	4505                	li	a0,1
    330c:	00002097          	auipc	ra,0x2
    3310:	1c0080e7          	jalr	448(ra) # 54cc <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3314:	85ca                	mv	a1,s2
    3316:	00004517          	auipc	a0,0x4
    331a:	fea50513          	addi	a0,a0,-22 # 7300 <l_free+0x189a>
    331e:	00002097          	auipc	ra,0x2
    3322:	526080e7          	jalr	1318(ra) # 5844 <printf>
    exit(1);
    3326:	4505                	li	a0,1
    3328:	00002097          	auipc	ra,0x2
    332c:	1a4080e7          	jalr	420(ra) # 54cc <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3330:	85ca                	mv	a1,s2
    3332:	00004517          	auipc	a0,0x4
    3336:	ff650513          	addi	a0,a0,-10 # 7328 <l_free+0x18c2>
    333a:	00002097          	auipc	ra,0x2
    333e:	50a080e7          	jalr	1290(ra) # 5844 <printf>
    exit(1);
    3342:	4505                	li	a0,1
    3344:	00002097          	auipc	ra,0x2
    3348:	188080e7          	jalr	392(ra) # 54cc <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    334c:	85ca                	mv	a1,s2
    334e:	00004517          	auipc	a0,0x4
    3352:	c7250513          	addi	a0,a0,-910 # 6fc0 <l_free+0x155a>
    3356:	00002097          	auipc	ra,0x2
    335a:	4ee080e7          	jalr	1262(ra) # 5844 <printf>
    exit(1);
    335e:	4505                	li	a0,1
    3360:	00002097          	auipc	ra,0x2
    3364:	16c080e7          	jalr	364(ra) # 54cc <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3368:	85ca                	mv	a1,s2
    336a:	00004517          	auipc	a0,0x4
    336e:	fde50513          	addi	a0,a0,-34 # 7348 <l_free+0x18e2>
    3372:	00002097          	auipc	ra,0x2
    3376:	4d2080e7          	jalr	1234(ra) # 5844 <printf>
    exit(1);
    337a:	4505                	li	a0,1
    337c:	00002097          	auipc	ra,0x2
    3380:	150080e7          	jalr	336(ra) # 54cc <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3384:	85ca                	mv	a1,s2
    3386:	00004517          	auipc	a0,0x4
    338a:	fe250513          	addi	a0,a0,-30 # 7368 <l_free+0x1902>
    338e:	00002097          	auipc	ra,0x2
    3392:	4b6080e7          	jalr	1206(ra) # 5844 <printf>
    exit(1);
    3396:	4505                	li	a0,1
    3398:	00002097          	auipc	ra,0x2
    339c:	134080e7          	jalr	308(ra) # 54cc <exit>
    printf("%s: unlink dd/dd failed\n", s);
    33a0:	85ca                	mv	a1,s2
    33a2:	00004517          	auipc	a0,0x4
    33a6:	ff650513          	addi	a0,a0,-10 # 7398 <l_free+0x1932>
    33aa:	00002097          	auipc	ra,0x2
    33ae:	49a080e7          	jalr	1178(ra) # 5844 <printf>
    exit(1);
    33b2:	4505                	li	a0,1
    33b4:	00002097          	auipc	ra,0x2
    33b8:	118080e7          	jalr	280(ra) # 54cc <exit>
    printf("%s: unlink dd failed\n", s);
    33bc:	85ca                	mv	a1,s2
    33be:	00004517          	auipc	a0,0x4
    33c2:	ffa50513          	addi	a0,a0,-6 # 73b8 <l_free+0x1952>
    33c6:	00002097          	auipc	ra,0x2
    33ca:	47e080e7          	jalr	1150(ra) # 5844 <printf>
    exit(1);
    33ce:	4505                	li	a0,1
    33d0:	00002097          	auipc	ra,0x2
    33d4:	0fc080e7          	jalr	252(ra) # 54cc <exit>

00000000000033d8 <rmdot>:
void rmdot(char *s) {
    33d8:	1101                	addi	sp,sp,-32
    33da:	ec06                	sd	ra,24(sp)
    33dc:	e822                	sd	s0,16(sp)
    33de:	e426                	sd	s1,8(sp)
    33e0:	1000                	addi	s0,sp,32
    33e2:	84aa                	mv	s1,a0
  if (mkdir("dots") != 0) {
    33e4:	00004517          	auipc	a0,0x4
    33e8:	fec50513          	addi	a0,a0,-20 # 73d0 <l_free+0x196a>
    33ec:	00002097          	auipc	ra,0x2
    33f0:	148080e7          	jalr	328(ra) # 5534 <mkdir>
    33f4:	e549                	bnez	a0,347e <rmdot+0xa6>
  if (chdir("dots") != 0) {
    33f6:	00004517          	auipc	a0,0x4
    33fa:	fda50513          	addi	a0,a0,-38 # 73d0 <l_free+0x196a>
    33fe:	00002097          	auipc	ra,0x2
    3402:	13e080e7          	jalr	318(ra) # 553c <chdir>
    3406:	e951                	bnez	a0,349a <rmdot+0xc2>
  if (unlink(".") == 0) {
    3408:	00003517          	auipc	a0,0x3
    340c:	f8850513          	addi	a0,a0,-120 # 6390 <l_free+0x92a>
    3410:	00002097          	auipc	ra,0x2
    3414:	10c080e7          	jalr	268(ra) # 551c <unlink>
    3418:	cd59                	beqz	a0,34b6 <rmdot+0xde>
  if (unlink("..") == 0) {
    341a:	00004517          	auipc	a0,0x4
    341e:	00650513          	addi	a0,a0,6 # 7420 <l_free+0x19ba>
    3422:	00002097          	auipc	ra,0x2
    3426:	0fa080e7          	jalr	250(ra) # 551c <unlink>
    342a:	c545                	beqz	a0,34d2 <rmdot+0xfa>
  if (chdir("/") != 0) {
    342c:	00004517          	auipc	a0,0x4
    3430:	9fc50513          	addi	a0,a0,-1540 # 6e28 <l_free+0x13c2>
    3434:	00002097          	auipc	ra,0x2
    3438:	108080e7          	jalr	264(ra) # 553c <chdir>
    343c:	e94d                	bnez	a0,34ee <rmdot+0x116>
  if (unlink("dots/.") == 0) {
    343e:	00004517          	auipc	a0,0x4
    3442:	00250513          	addi	a0,a0,2 # 7440 <l_free+0x19da>
    3446:	00002097          	auipc	ra,0x2
    344a:	0d6080e7          	jalr	214(ra) # 551c <unlink>
    344e:	cd55                	beqz	a0,350a <rmdot+0x132>
  if (unlink("dots/..") == 0) {
    3450:	00004517          	auipc	a0,0x4
    3454:	01850513          	addi	a0,a0,24 # 7468 <l_free+0x1a02>
    3458:	00002097          	auipc	ra,0x2
    345c:	0c4080e7          	jalr	196(ra) # 551c <unlink>
    3460:	c179                	beqz	a0,3526 <rmdot+0x14e>
  if (unlink("dots") != 0) {
    3462:	00004517          	auipc	a0,0x4
    3466:	f6e50513          	addi	a0,a0,-146 # 73d0 <l_free+0x196a>
    346a:	00002097          	auipc	ra,0x2
    346e:	0b2080e7          	jalr	178(ra) # 551c <unlink>
    3472:	e961                	bnez	a0,3542 <rmdot+0x16a>
}
    3474:	60e2                	ld	ra,24(sp)
    3476:	6442                	ld	s0,16(sp)
    3478:	64a2                	ld	s1,8(sp)
    347a:	6105                	addi	sp,sp,32
    347c:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    347e:	85a6                	mv	a1,s1
    3480:	00004517          	auipc	a0,0x4
    3484:	f5850513          	addi	a0,a0,-168 # 73d8 <l_free+0x1972>
    3488:	00002097          	auipc	ra,0x2
    348c:	3bc080e7          	jalr	956(ra) # 5844 <printf>
    exit(1);
    3490:	4505                	li	a0,1
    3492:	00002097          	auipc	ra,0x2
    3496:	03a080e7          	jalr	58(ra) # 54cc <exit>
    printf("%s: chdir dots failed\n", s);
    349a:	85a6                	mv	a1,s1
    349c:	00004517          	auipc	a0,0x4
    34a0:	f5450513          	addi	a0,a0,-172 # 73f0 <l_free+0x198a>
    34a4:	00002097          	auipc	ra,0x2
    34a8:	3a0080e7          	jalr	928(ra) # 5844 <printf>
    exit(1);
    34ac:	4505                	li	a0,1
    34ae:	00002097          	auipc	ra,0x2
    34b2:	01e080e7          	jalr	30(ra) # 54cc <exit>
    printf("%s: rm . worked!\n", s);
    34b6:	85a6                	mv	a1,s1
    34b8:	00004517          	auipc	a0,0x4
    34bc:	f5050513          	addi	a0,a0,-176 # 7408 <l_free+0x19a2>
    34c0:	00002097          	auipc	ra,0x2
    34c4:	384080e7          	jalr	900(ra) # 5844 <printf>
    exit(1);
    34c8:	4505                	li	a0,1
    34ca:	00002097          	auipc	ra,0x2
    34ce:	002080e7          	jalr	2(ra) # 54cc <exit>
    printf("%s: rm .. worked!\n", s);
    34d2:	85a6                	mv	a1,s1
    34d4:	00004517          	auipc	a0,0x4
    34d8:	f5450513          	addi	a0,a0,-172 # 7428 <l_free+0x19c2>
    34dc:	00002097          	auipc	ra,0x2
    34e0:	368080e7          	jalr	872(ra) # 5844 <printf>
    exit(1);
    34e4:	4505                	li	a0,1
    34e6:	00002097          	auipc	ra,0x2
    34ea:	fe6080e7          	jalr	-26(ra) # 54cc <exit>
    printf("%s: chdir / failed\n", s);
    34ee:	85a6                	mv	a1,s1
    34f0:	00004517          	auipc	a0,0x4
    34f4:	94050513          	addi	a0,a0,-1728 # 6e30 <l_free+0x13ca>
    34f8:	00002097          	auipc	ra,0x2
    34fc:	34c080e7          	jalr	844(ra) # 5844 <printf>
    exit(1);
    3500:	4505                	li	a0,1
    3502:	00002097          	auipc	ra,0x2
    3506:	fca080e7          	jalr	-54(ra) # 54cc <exit>
    printf("%s: unlink dots/. worked!\n", s);
    350a:	85a6                	mv	a1,s1
    350c:	00004517          	auipc	a0,0x4
    3510:	f3c50513          	addi	a0,a0,-196 # 7448 <l_free+0x19e2>
    3514:	00002097          	auipc	ra,0x2
    3518:	330080e7          	jalr	816(ra) # 5844 <printf>
    exit(1);
    351c:	4505                	li	a0,1
    351e:	00002097          	auipc	ra,0x2
    3522:	fae080e7          	jalr	-82(ra) # 54cc <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3526:	85a6                	mv	a1,s1
    3528:	00004517          	auipc	a0,0x4
    352c:	f4850513          	addi	a0,a0,-184 # 7470 <l_free+0x1a0a>
    3530:	00002097          	auipc	ra,0x2
    3534:	314080e7          	jalr	788(ra) # 5844 <printf>
    exit(1);
    3538:	4505                	li	a0,1
    353a:	00002097          	auipc	ra,0x2
    353e:	f92080e7          	jalr	-110(ra) # 54cc <exit>
    printf("%s: unlink dots failed!\n", s);
    3542:	85a6                	mv	a1,s1
    3544:	00004517          	auipc	a0,0x4
    3548:	f4c50513          	addi	a0,a0,-180 # 7490 <l_free+0x1a2a>
    354c:	00002097          	auipc	ra,0x2
    3550:	2f8080e7          	jalr	760(ra) # 5844 <printf>
    exit(1);
    3554:	4505                	li	a0,1
    3556:	00002097          	auipc	ra,0x2
    355a:	f76080e7          	jalr	-138(ra) # 54cc <exit>

000000000000355e <dirfile>:
void dirfile(char *s) {
    355e:	1101                	addi	sp,sp,-32
    3560:	ec06                	sd	ra,24(sp)
    3562:	e822                	sd	s0,16(sp)
    3564:	e426                	sd	s1,8(sp)
    3566:	e04a                	sd	s2,0(sp)
    3568:	1000                	addi	s0,sp,32
    356a:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    356c:	20000593          	li	a1,512
    3570:	00002517          	auipc	a0,0x2
    3574:	7e850513          	addi	a0,a0,2024 # 5d58 <l_free+0x2f2>
    3578:	00002097          	auipc	ra,0x2
    357c:	f94080e7          	jalr	-108(ra) # 550c <open>
  if (fd < 0) {
    3580:	0e054d63          	bltz	a0,367a <dirfile+0x11c>
  close(fd);
    3584:	00002097          	auipc	ra,0x2
    3588:	f70080e7          	jalr	-144(ra) # 54f4 <close>
  if (chdir("dirfile") == 0) {
    358c:	00002517          	auipc	a0,0x2
    3590:	7cc50513          	addi	a0,a0,1996 # 5d58 <l_free+0x2f2>
    3594:	00002097          	auipc	ra,0x2
    3598:	fa8080e7          	jalr	-88(ra) # 553c <chdir>
    359c:	cd6d                	beqz	a0,3696 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    359e:	4581                	li	a1,0
    35a0:	00004517          	auipc	a0,0x4
    35a4:	f5050513          	addi	a0,a0,-176 # 74f0 <l_free+0x1a8a>
    35a8:	00002097          	auipc	ra,0x2
    35ac:	f64080e7          	jalr	-156(ra) # 550c <open>
  if (fd >= 0) {
    35b0:	10055163          	bgez	a0,36b2 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    35b4:	20000593          	li	a1,512
    35b8:	00004517          	auipc	a0,0x4
    35bc:	f3850513          	addi	a0,a0,-200 # 74f0 <l_free+0x1a8a>
    35c0:	00002097          	auipc	ra,0x2
    35c4:	f4c080e7          	jalr	-180(ra) # 550c <open>
  if (fd >= 0) {
    35c8:	10055363          	bgez	a0,36ce <dirfile+0x170>
  if (mkdir("dirfile/xx") == 0) {
    35cc:	00004517          	auipc	a0,0x4
    35d0:	f2450513          	addi	a0,a0,-220 # 74f0 <l_free+0x1a8a>
    35d4:	00002097          	auipc	ra,0x2
    35d8:	f60080e7          	jalr	-160(ra) # 5534 <mkdir>
    35dc:	10050763          	beqz	a0,36ea <dirfile+0x18c>
  if (unlink("dirfile/xx") == 0) {
    35e0:	00004517          	auipc	a0,0x4
    35e4:	f1050513          	addi	a0,a0,-240 # 74f0 <l_free+0x1a8a>
    35e8:	00002097          	auipc	ra,0x2
    35ec:	f34080e7          	jalr	-204(ra) # 551c <unlink>
    35f0:	10050b63          	beqz	a0,3706 <dirfile+0x1a8>
  if (link("README", "dirfile/xx") == 0) {
    35f4:	00004597          	auipc	a1,0x4
    35f8:	efc58593          	addi	a1,a1,-260 # 74f0 <l_free+0x1a8a>
    35fc:	00003517          	auipc	a0,0x3
    3600:	98450513          	addi	a0,a0,-1660 # 5f80 <l_free+0x51a>
    3604:	00002097          	auipc	ra,0x2
    3608:	f28080e7          	jalr	-216(ra) # 552c <link>
    360c:	10050b63          	beqz	a0,3722 <dirfile+0x1c4>
  if (unlink("dirfile") != 0) {
    3610:	00002517          	auipc	a0,0x2
    3614:	74850513          	addi	a0,a0,1864 # 5d58 <l_free+0x2f2>
    3618:	00002097          	auipc	ra,0x2
    361c:	f04080e7          	jalr	-252(ra) # 551c <unlink>
    3620:	10051f63          	bnez	a0,373e <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    3624:	4589                	li	a1,2
    3626:	00003517          	auipc	a0,0x3
    362a:	d6a50513          	addi	a0,a0,-662 # 6390 <l_free+0x92a>
    362e:	00002097          	auipc	ra,0x2
    3632:	ede080e7          	jalr	-290(ra) # 550c <open>
  if (fd >= 0) {
    3636:	12055263          	bgez	a0,375a <dirfile+0x1fc>
  fd = open(".", 0);
    363a:	4581                	li	a1,0
    363c:	00003517          	auipc	a0,0x3
    3640:	d5450513          	addi	a0,a0,-684 # 6390 <l_free+0x92a>
    3644:	00002097          	auipc	ra,0x2
    3648:	ec8080e7          	jalr	-312(ra) # 550c <open>
    364c:	84aa                	mv	s1,a0
  if (write(fd, "x", 1) > 0) {
    364e:	4605                	li	a2,1
    3650:	00002597          	auipc	a1,0x2
    3654:	7d858593          	addi	a1,a1,2008 # 5e28 <l_free+0x3c2>
    3658:	00002097          	auipc	ra,0x2
    365c:	e94080e7          	jalr	-364(ra) # 54ec <write>
    3660:	10a04b63          	bgtz	a0,3776 <dirfile+0x218>
  close(fd);
    3664:	8526                	mv	a0,s1
    3666:	00002097          	auipc	ra,0x2
    366a:	e8e080e7          	jalr	-370(ra) # 54f4 <close>
}
    366e:	60e2                	ld	ra,24(sp)
    3670:	6442                	ld	s0,16(sp)
    3672:	64a2                	ld	s1,8(sp)
    3674:	6902                	ld	s2,0(sp)
    3676:	6105                	addi	sp,sp,32
    3678:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    367a:	85ca                	mv	a1,s2
    367c:	00004517          	auipc	a0,0x4
    3680:	e3450513          	addi	a0,a0,-460 # 74b0 <l_free+0x1a4a>
    3684:	00002097          	auipc	ra,0x2
    3688:	1c0080e7          	jalr	448(ra) # 5844 <printf>
    exit(1);
    368c:	4505                	li	a0,1
    368e:	00002097          	auipc	ra,0x2
    3692:	e3e080e7          	jalr	-450(ra) # 54cc <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3696:	85ca                	mv	a1,s2
    3698:	00004517          	auipc	a0,0x4
    369c:	e3850513          	addi	a0,a0,-456 # 74d0 <l_free+0x1a6a>
    36a0:	00002097          	auipc	ra,0x2
    36a4:	1a4080e7          	jalr	420(ra) # 5844 <printf>
    exit(1);
    36a8:	4505                	li	a0,1
    36aa:	00002097          	auipc	ra,0x2
    36ae:	e22080e7          	jalr	-478(ra) # 54cc <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    36b2:	85ca                	mv	a1,s2
    36b4:	00004517          	auipc	a0,0x4
    36b8:	e4c50513          	addi	a0,a0,-436 # 7500 <l_free+0x1a9a>
    36bc:	00002097          	auipc	ra,0x2
    36c0:	188080e7          	jalr	392(ra) # 5844 <printf>
    exit(1);
    36c4:	4505                	li	a0,1
    36c6:	00002097          	auipc	ra,0x2
    36ca:	e06080e7          	jalr	-506(ra) # 54cc <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    36ce:	85ca                	mv	a1,s2
    36d0:	00004517          	auipc	a0,0x4
    36d4:	e3050513          	addi	a0,a0,-464 # 7500 <l_free+0x1a9a>
    36d8:	00002097          	auipc	ra,0x2
    36dc:	16c080e7          	jalr	364(ra) # 5844 <printf>
    exit(1);
    36e0:	4505                	li	a0,1
    36e2:	00002097          	auipc	ra,0x2
    36e6:	dea080e7          	jalr	-534(ra) # 54cc <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    36ea:	85ca                	mv	a1,s2
    36ec:	00004517          	auipc	a0,0x4
    36f0:	e3c50513          	addi	a0,a0,-452 # 7528 <l_free+0x1ac2>
    36f4:	00002097          	auipc	ra,0x2
    36f8:	150080e7          	jalr	336(ra) # 5844 <printf>
    exit(1);
    36fc:	4505                	li	a0,1
    36fe:	00002097          	auipc	ra,0x2
    3702:	dce080e7          	jalr	-562(ra) # 54cc <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3706:	85ca                	mv	a1,s2
    3708:	00004517          	auipc	a0,0x4
    370c:	e4850513          	addi	a0,a0,-440 # 7550 <l_free+0x1aea>
    3710:	00002097          	auipc	ra,0x2
    3714:	134080e7          	jalr	308(ra) # 5844 <printf>
    exit(1);
    3718:	4505                	li	a0,1
    371a:	00002097          	auipc	ra,0x2
    371e:	db2080e7          	jalr	-590(ra) # 54cc <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3722:	85ca                	mv	a1,s2
    3724:	00004517          	auipc	a0,0x4
    3728:	e5450513          	addi	a0,a0,-428 # 7578 <l_free+0x1b12>
    372c:	00002097          	auipc	ra,0x2
    3730:	118080e7          	jalr	280(ra) # 5844 <printf>
    exit(1);
    3734:	4505                	li	a0,1
    3736:	00002097          	auipc	ra,0x2
    373a:	d96080e7          	jalr	-618(ra) # 54cc <exit>
    printf("%s: unlink dirfile failed!\n", s);
    373e:	85ca                	mv	a1,s2
    3740:	00004517          	auipc	a0,0x4
    3744:	e6050513          	addi	a0,a0,-416 # 75a0 <l_free+0x1b3a>
    3748:	00002097          	auipc	ra,0x2
    374c:	0fc080e7          	jalr	252(ra) # 5844 <printf>
    exit(1);
    3750:	4505                	li	a0,1
    3752:	00002097          	auipc	ra,0x2
    3756:	d7a080e7          	jalr	-646(ra) # 54cc <exit>
    printf("%s: open . for writing succeeded!\n", s);
    375a:	85ca                	mv	a1,s2
    375c:	00004517          	auipc	a0,0x4
    3760:	e6450513          	addi	a0,a0,-412 # 75c0 <l_free+0x1b5a>
    3764:	00002097          	auipc	ra,0x2
    3768:	0e0080e7          	jalr	224(ra) # 5844 <printf>
    exit(1);
    376c:	4505                	li	a0,1
    376e:	00002097          	auipc	ra,0x2
    3772:	d5e080e7          	jalr	-674(ra) # 54cc <exit>
    printf("%s: write . succeeded!\n", s);
    3776:	85ca                	mv	a1,s2
    3778:	00004517          	auipc	a0,0x4
    377c:	e7050513          	addi	a0,a0,-400 # 75e8 <l_free+0x1b82>
    3780:	00002097          	auipc	ra,0x2
    3784:	0c4080e7          	jalr	196(ra) # 5844 <printf>
    exit(1);
    3788:	4505                	li	a0,1
    378a:	00002097          	auipc	ra,0x2
    378e:	d42080e7          	jalr	-702(ra) # 54cc <exit>

0000000000003792 <iref>:
void iref(char *s) {
    3792:	7139                	addi	sp,sp,-64
    3794:	fc06                	sd	ra,56(sp)
    3796:	f822                	sd	s0,48(sp)
    3798:	f426                	sd	s1,40(sp)
    379a:	f04a                	sd	s2,32(sp)
    379c:	ec4e                	sd	s3,24(sp)
    379e:	e852                	sd	s4,16(sp)
    37a0:	e456                	sd	s5,8(sp)
    37a2:	e05a                	sd	s6,0(sp)
    37a4:	0080                	addi	s0,sp,64
    37a6:	8b2a                	mv	s6,a0
    37a8:	03300913          	li	s2,51
    if (mkdir("irefd") != 0) {
    37ac:	00004a17          	auipc	s4,0x4
    37b0:	e54a0a13          	addi	s4,s4,-428 # 7600 <l_free+0x1b9a>
    mkdir("");
    37b4:	00004497          	auipc	s1,0x4
    37b8:	95448493          	addi	s1,s1,-1708 # 7108 <l_free+0x16a2>
    link("README", "");
    37bc:	00002a97          	auipc	s5,0x2
    37c0:	7c4a8a93          	addi	s5,s5,1988 # 5f80 <l_free+0x51a>
    fd = open("xx", O_CREATE);
    37c4:	00004997          	auipc	s3,0x4
    37c8:	d3498993          	addi	s3,s3,-716 # 74f8 <l_free+0x1a92>
    37cc:	a891                	j	3820 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    37ce:	85da                	mv	a1,s6
    37d0:	00004517          	auipc	a0,0x4
    37d4:	e3850513          	addi	a0,a0,-456 # 7608 <l_free+0x1ba2>
    37d8:	00002097          	auipc	ra,0x2
    37dc:	06c080e7          	jalr	108(ra) # 5844 <printf>
      exit(1);
    37e0:	4505                	li	a0,1
    37e2:	00002097          	auipc	ra,0x2
    37e6:	cea080e7          	jalr	-790(ra) # 54cc <exit>
      printf("%s: chdir irefd failed\n", s);
    37ea:	85da                	mv	a1,s6
    37ec:	00004517          	auipc	a0,0x4
    37f0:	e3450513          	addi	a0,a0,-460 # 7620 <l_free+0x1bba>
    37f4:	00002097          	auipc	ra,0x2
    37f8:	050080e7          	jalr	80(ra) # 5844 <printf>
      exit(1);
    37fc:	4505                	li	a0,1
    37fe:	00002097          	auipc	ra,0x2
    3802:	cce080e7          	jalr	-818(ra) # 54cc <exit>
      close(fd);
    3806:	00002097          	auipc	ra,0x2
    380a:	cee080e7          	jalr	-786(ra) # 54f4 <close>
    380e:	a889                	j	3860 <iref+0xce>
    unlink("xx");
    3810:	854e                	mv	a0,s3
    3812:	00002097          	auipc	ra,0x2
    3816:	d0a080e7          	jalr	-758(ra) # 551c <unlink>
  for (i = 0; i < NINODE + 1; i++) {
    381a:	397d                	addiw	s2,s2,-1
    381c:	06090063          	beqz	s2,387c <iref+0xea>
    if (mkdir("irefd") != 0) {
    3820:	8552                	mv	a0,s4
    3822:	00002097          	auipc	ra,0x2
    3826:	d12080e7          	jalr	-750(ra) # 5534 <mkdir>
    382a:	f155                	bnez	a0,37ce <iref+0x3c>
    if (chdir("irefd") != 0) {
    382c:	8552                	mv	a0,s4
    382e:	00002097          	auipc	ra,0x2
    3832:	d0e080e7          	jalr	-754(ra) # 553c <chdir>
    3836:	f955                	bnez	a0,37ea <iref+0x58>
    mkdir("");
    3838:	8526                	mv	a0,s1
    383a:	00002097          	auipc	ra,0x2
    383e:	cfa080e7          	jalr	-774(ra) # 5534 <mkdir>
    link("README", "");
    3842:	85a6                	mv	a1,s1
    3844:	8556                	mv	a0,s5
    3846:	00002097          	auipc	ra,0x2
    384a:	ce6080e7          	jalr	-794(ra) # 552c <link>
    fd = open("", O_CREATE);
    384e:	20000593          	li	a1,512
    3852:	8526                	mv	a0,s1
    3854:	00002097          	auipc	ra,0x2
    3858:	cb8080e7          	jalr	-840(ra) # 550c <open>
    if (fd >= 0)
    385c:	fa0555e3          	bgez	a0,3806 <iref+0x74>
    fd = open("xx", O_CREATE);
    3860:	20000593          	li	a1,512
    3864:	854e                	mv	a0,s3
    3866:	00002097          	auipc	ra,0x2
    386a:	ca6080e7          	jalr	-858(ra) # 550c <open>
    if (fd >= 0)
    386e:	fa0541e3          	bltz	a0,3810 <iref+0x7e>
      close(fd);
    3872:	00002097          	auipc	ra,0x2
    3876:	c82080e7          	jalr	-894(ra) # 54f4 <close>
    387a:	bf59                	j	3810 <iref+0x7e>
    387c:	03300493          	li	s1,51
    chdir("..");
    3880:	00004997          	auipc	s3,0x4
    3884:	ba098993          	addi	s3,s3,-1120 # 7420 <l_free+0x19ba>
    unlink("irefd");
    3888:	00004917          	auipc	s2,0x4
    388c:	d7890913          	addi	s2,s2,-648 # 7600 <l_free+0x1b9a>
    chdir("..");
    3890:	854e                	mv	a0,s3
    3892:	00002097          	auipc	ra,0x2
    3896:	caa080e7          	jalr	-854(ra) # 553c <chdir>
    unlink("irefd");
    389a:	854a                	mv	a0,s2
    389c:	00002097          	auipc	ra,0x2
    38a0:	c80080e7          	jalr	-896(ra) # 551c <unlink>
  for (i = 0; i < NINODE + 1; i++) {
    38a4:	34fd                	addiw	s1,s1,-1
    38a6:	f4ed                	bnez	s1,3890 <iref+0xfe>
  chdir("/");
    38a8:	00003517          	auipc	a0,0x3
    38ac:	58050513          	addi	a0,a0,1408 # 6e28 <l_free+0x13c2>
    38b0:	00002097          	auipc	ra,0x2
    38b4:	c8c080e7          	jalr	-884(ra) # 553c <chdir>
}
    38b8:	70e2                	ld	ra,56(sp)
    38ba:	7442                	ld	s0,48(sp)
    38bc:	74a2                	ld	s1,40(sp)
    38be:	7902                	ld	s2,32(sp)
    38c0:	69e2                	ld	s3,24(sp)
    38c2:	6a42                	ld	s4,16(sp)
    38c4:	6aa2                	ld	s5,8(sp)
    38c6:	6b02                	ld	s6,0(sp)
    38c8:	6121                	addi	sp,sp,64
    38ca:	8082                	ret

00000000000038cc <openiputtest>:
void openiputtest(char *s) {
    38cc:	7179                	addi	sp,sp,-48
    38ce:	f406                	sd	ra,40(sp)
    38d0:	f022                	sd	s0,32(sp)
    38d2:	ec26                	sd	s1,24(sp)
    38d4:	1800                	addi	s0,sp,48
    38d6:	84aa                	mv	s1,a0
  if (mkdir("oidir") < 0) {
    38d8:	00004517          	auipc	a0,0x4
    38dc:	d6050513          	addi	a0,a0,-672 # 7638 <l_free+0x1bd2>
    38e0:	00002097          	auipc	ra,0x2
    38e4:	c54080e7          	jalr	-940(ra) # 5534 <mkdir>
    38e8:	04054263          	bltz	a0,392c <openiputtest+0x60>
  pid = fork();
    38ec:	00002097          	auipc	ra,0x2
    38f0:	bd8080e7          	jalr	-1064(ra) # 54c4 <fork>
  if (pid < 0) {
    38f4:	04054a63          	bltz	a0,3948 <openiputtest+0x7c>
  if (pid == 0) {
    38f8:	e93d                	bnez	a0,396e <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    38fa:	4589                	li	a1,2
    38fc:	00004517          	auipc	a0,0x4
    3900:	d3c50513          	addi	a0,a0,-708 # 7638 <l_free+0x1bd2>
    3904:	00002097          	auipc	ra,0x2
    3908:	c08080e7          	jalr	-1016(ra) # 550c <open>
    if (fd >= 0) {
    390c:	04054c63          	bltz	a0,3964 <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    3910:	85a6                	mv	a1,s1
    3912:	00004517          	auipc	a0,0x4
    3916:	d4650513          	addi	a0,a0,-698 # 7658 <l_free+0x1bf2>
    391a:	00002097          	auipc	ra,0x2
    391e:	f2a080e7          	jalr	-214(ra) # 5844 <printf>
      exit(1);
    3922:	4505                	li	a0,1
    3924:	00002097          	auipc	ra,0x2
    3928:	ba8080e7          	jalr	-1112(ra) # 54cc <exit>
    printf("%s: mkdir oidir failed\n", s);
    392c:	85a6                	mv	a1,s1
    392e:	00004517          	auipc	a0,0x4
    3932:	d1250513          	addi	a0,a0,-750 # 7640 <l_free+0x1bda>
    3936:	00002097          	auipc	ra,0x2
    393a:	f0e080e7          	jalr	-242(ra) # 5844 <printf>
    exit(1);
    393e:	4505                	li	a0,1
    3940:	00002097          	auipc	ra,0x2
    3944:	b8c080e7          	jalr	-1140(ra) # 54cc <exit>
    printf("%s: fork failed\n", s);
    3948:	85a6                	mv	a1,s1
    394a:	00003517          	auipc	a0,0x3
    394e:	be650513          	addi	a0,a0,-1050 # 6530 <l_free+0xaca>
    3952:	00002097          	auipc	ra,0x2
    3956:	ef2080e7          	jalr	-270(ra) # 5844 <printf>
    exit(1);
    395a:	4505                	li	a0,1
    395c:	00002097          	auipc	ra,0x2
    3960:	b70080e7          	jalr	-1168(ra) # 54cc <exit>
    exit(0);
    3964:	4501                	li	a0,0
    3966:	00002097          	auipc	ra,0x2
    396a:	b66080e7          	jalr	-1178(ra) # 54cc <exit>
  sleep(1);
    396e:	4505                	li	a0,1
    3970:	00002097          	auipc	ra,0x2
    3974:	bec080e7          	jalr	-1044(ra) # 555c <sleep>
  if (unlink("oidir") != 0) {
    3978:	00004517          	auipc	a0,0x4
    397c:	cc050513          	addi	a0,a0,-832 # 7638 <l_free+0x1bd2>
    3980:	00002097          	auipc	ra,0x2
    3984:	b9c080e7          	jalr	-1124(ra) # 551c <unlink>
    3988:	cd19                	beqz	a0,39a6 <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    398a:	85a6                	mv	a1,s1
    398c:	00003517          	auipc	a0,0x3
    3990:	d9450513          	addi	a0,a0,-620 # 6720 <l_free+0xcba>
    3994:	00002097          	auipc	ra,0x2
    3998:	eb0080e7          	jalr	-336(ra) # 5844 <printf>
    exit(1);
    399c:	4505                	li	a0,1
    399e:	00002097          	auipc	ra,0x2
    39a2:	b2e080e7          	jalr	-1234(ra) # 54cc <exit>
  wait(&xstatus);
    39a6:	fdc40513          	addi	a0,s0,-36
    39aa:	00002097          	auipc	ra,0x2
    39ae:	b2a080e7          	jalr	-1238(ra) # 54d4 <wait>
  exit(xstatus);
    39b2:	fdc42503          	lw	a0,-36(s0)
    39b6:	00002097          	auipc	ra,0x2
    39ba:	b16080e7          	jalr	-1258(ra) # 54cc <exit>

00000000000039be <forkforkfork>:
void forkforkfork(char *s) {
    39be:	1101                	addi	sp,sp,-32
    39c0:	ec06                	sd	ra,24(sp)
    39c2:	e822                	sd	s0,16(sp)
    39c4:	e426                	sd	s1,8(sp)
    39c6:	1000                	addi	s0,sp,32
    39c8:	84aa                	mv	s1,a0
  unlink("stopforking");
    39ca:	00004517          	auipc	a0,0x4
    39ce:	cb650513          	addi	a0,a0,-842 # 7680 <l_free+0x1c1a>
    39d2:	00002097          	auipc	ra,0x2
    39d6:	b4a080e7          	jalr	-1206(ra) # 551c <unlink>
  int pid = fork();
    39da:	00002097          	auipc	ra,0x2
    39de:	aea080e7          	jalr	-1302(ra) # 54c4 <fork>
  if (pid < 0) {
    39e2:	04054563          	bltz	a0,3a2c <forkforkfork+0x6e>
  if (pid == 0) {
    39e6:	c12d                	beqz	a0,3a48 <forkforkfork+0x8a>
  sleep(20); // two seconds
    39e8:	4551                	li	a0,20
    39ea:	00002097          	auipc	ra,0x2
    39ee:	b72080e7          	jalr	-1166(ra) # 555c <sleep>
  close(open("stopforking", O_CREATE | O_RDWR));
    39f2:	20200593          	li	a1,514
    39f6:	00004517          	auipc	a0,0x4
    39fa:	c8a50513          	addi	a0,a0,-886 # 7680 <l_free+0x1c1a>
    39fe:	00002097          	auipc	ra,0x2
    3a02:	b0e080e7          	jalr	-1266(ra) # 550c <open>
    3a06:	00002097          	auipc	ra,0x2
    3a0a:	aee080e7          	jalr	-1298(ra) # 54f4 <close>
  wait(0);
    3a0e:	4501                	li	a0,0
    3a10:	00002097          	auipc	ra,0x2
    3a14:	ac4080e7          	jalr	-1340(ra) # 54d4 <wait>
  sleep(10); // one second
    3a18:	4529                	li	a0,10
    3a1a:	00002097          	auipc	ra,0x2
    3a1e:	b42080e7          	jalr	-1214(ra) # 555c <sleep>
}
    3a22:	60e2                	ld	ra,24(sp)
    3a24:	6442                	ld	s0,16(sp)
    3a26:	64a2                	ld	s1,8(sp)
    3a28:	6105                	addi	sp,sp,32
    3a2a:	8082                	ret
    printf("%s: fork failed", s);
    3a2c:	85a6                	mv	a1,s1
    3a2e:	00003517          	auipc	a0,0x3
    3a32:	cc250513          	addi	a0,a0,-830 # 66f0 <l_free+0xc8a>
    3a36:	00002097          	auipc	ra,0x2
    3a3a:	e0e080e7          	jalr	-498(ra) # 5844 <printf>
    exit(1);
    3a3e:	4505                	li	a0,1
    3a40:	00002097          	auipc	ra,0x2
    3a44:	a8c080e7          	jalr	-1396(ra) # 54cc <exit>
      int fd = open("stopforking", 0);
    3a48:	00004497          	auipc	s1,0x4
    3a4c:	c3848493          	addi	s1,s1,-968 # 7680 <l_free+0x1c1a>
    3a50:	4581                	li	a1,0
    3a52:	8526                	mv	a0,s1
    3a54:	00002097          	auipc	ra,0x2
    3a58:	ab8080e7          	jalr	-1352(ra) # 550c <open>
      if (fd >= 0) {
    3a5c:	02055463          	bgez	a0,3a84 <forkforkfork+0xc6>
      if (fork() < 0) {
    3a60:	00002097          	auipc	ra,0x2
    3a64:	a64080e7          	jalr	-1436(ra) # 54c4 <fork>
    3a68:	fe0554e3          	bgez	a0,3a50 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE | O_RDWR));
    3a6c:	20200593          	li	a1,514
    3a70:	8526                	mv	a0,s1
    3a72:	00002097          	auipc	ra,0x2
    3a76:	a9a080e7          	jalr	-1382(ra) # 550c <open>
    3a7a:	00002097          	auipc	ra,0x2
    3a7e:	a7a080e7          	jalr	-1414(ra) # 54f4 <close>
    3a82:	b7f9                	j	3a50 <forkforkfork+0x92>
        exit(0);
    3a84:	4501                	li	a0,0
    3a86:	00002097          	auipc	ra,0x2
    3a8a:	a46080e7          	jalr	-1466(ra) # 54cc <exit>

0000000000003a8e <sbrkbasic>:
void sbrkbasic(char *s) {
    3a8e:	7139                	addi	sp,sp,-64
    3a90:	fc06                	sd	ra,56(sp)
    3a92:	f822                	sd	s0,48(sp)
    3a94:	f426                	sd	s1,40(sp)
    3a96:	f04a                	sd	s2,32(sp)
    3a98:	ec4e                	sd	s3,24(sp)
    3a9a:	e852                	sd	s4,16(sp)
    3a9c:	0080                	addi	s0,sp,64
    3a9e:	8a2a                	mv	s4,a0
  pid = fork();
    3aa0:	00002097          	auipc	ra,0x2
    3aa4:	a24080e7          	jalr	-1500(ra) # 54c4 <fork>
  if (pid < 0) {
    3aa8:	02054c63          	bltz	a0,3ae0 <sbrkbasic+0x52>
  if (pid == 0) {
    3aac:	ed21                	bnez	a0,3b04 <sbrkbasic+0x76>
    a = sbrk(TOOMUCH);
    3aae:	40000537          	lui	a0,0x40000
    3ab2:	00002097          	auipc	ra,0x2
    3ab6:	aa2080e7          	jalr	-1374(ra) # 5554 <sbrk>
    if (a == (char *)0xffffffffffffffffL) {
    3aba:	57fd                	li	a5,-1
    3abc:	02f50f63          	beq	a0,a5,3afa <sbrkbasic+0x6c>
    for (b = a; b < a + TOOMUCH; b += 4096) {
    3ac0:	400007b7          	lui	a5,0x40000
    3ac4:	97aa                	add	a5,a5,a0
      *b = 99;
    3ac6:	06300693          	li	a3,99
    for (b = a; b < a + TOOMUCH; b += 4096) {
    3aca:	6705                	lui	a4,0x1
      *b = 99;
    3acc:	00d50023          	sb	a3,0(a0) # 40000000 <__BSS_END__+0x3fff1638>
    for (b = a; b < a + TOOMUCH; b += 4096) {
    3ad0:	953a                	add	a0,a0,a4
    3ad2:	fef51de3          	bne	a0,a5,3acc <sbrkbasic+0x3e>
    exit(1);
    3ad6:	4505                	li	a0,1
    3ad8:	00002097          	auipc	ra,0x2
    3adc:	9f4080e7          	jalr	-1548(ra) # 54cc <exit>
    printf("fork failed in sbrkbasic\n");
    3ae0:	00004517          	auipc	a0,0x4
    3ae4:	bb050513          	addi	a0,a0,-1104 # 7690 <l_free+0x1c2a>
    3ae8:	00002097          	auipc	ra,0x2
    3aec:	d5c080e7          	jalr	-676(ra) # 5844 <printf>
    exit(1);
    3af0:	4505                	li	a0,1
    3af2:	00002097          	auipc	ra,0x2
    3af6:	9da080e7          	jalr	-1574(ra) # 54cc <exit>
      exit(0);
    3afa:	4501                	li	a0,0
    3afc:	00002097          	auipc	ra,0x2
    3b00:	9d0080e7          	jalr	-1584(ra) # 54cc <exit>
  sleep(10);
    3b04:	4529                	li	a0,10
    3b06:	00002097          	auipc	ra,0x2
    3b0a:	a56080e7          	jalr	-1450(ra) # 555c <sleep>
  wait(&xstatus);
    3b0e:	fcc40513          	addi	a0,s0,-52
    3b12:	00002097          	auipc	ra,0x2
    3b16:	9c2080e7          	jalr	-1598(ra) # 54d4 <wait>
  if (xstatus == 1) {
    3b1a:	fcc42703          	lw	a4,-52(s0)
    3b1e:	4785                	li	a5,1
    3b20:	02f70563          	beq	a4,a5,3b4a <sbrkbasic+0xbc>
  char *ss = sbrk(4096);
    3b24:	6505                	lui	a0,0x1
    3b26:	00002097          	auipc	ra,0x2
    3b2a:	a2e080e7          	jalr	-1490(ra) # 5554 <sbrk>
  *ss = 10;
    3b2e:	47a9                	li	a5,10
    3b30:	00f50023          	sb	a5,0(a0) # 1000 <bigdir+0x134>
  a = sbrk(0);
    3b34:	4501                	li	a0,0
    3b36:	00002097          	auipc	ra,0x2
    3b3a:	a1e080e7          	jalr	-1506(ra) # 5554 <sbrk>
    3b3e:	84aa                	mv	s1,a0
  for (i = 0; i < 5000; i++) {
    3b40:	4901                	li	s2,0
    3b42:	6985                	lui	s3,0x1
    3b44:	38898993          	addi	s3,s3,904 # 1388 <truncate3+0x76>
    3b48:	a005                	j	3b68 <sbrkbasic+0xda>
    printf("%s: too much memory allocated!\n", s);
    3b4a:	85d2                	mv	a1,s4
    3b4c:	00004517          	auipc	a0,0x4
    3b50:	b6450513          	addi	a0,a0,-1180 # 76b0 <l_free+0x1c4a>
    3b54:	00002097          	auipc	ra,0x2
    3b58:	cf0080e7          	jalr	-784(ra) # 5844 <printf>
    exit(1);
    3b5c:	4505                	li	a0,1
    3b5e:	00002097          	auipc	ra,0x2
    3b62:	96e080e7          	jalr	-1682(ra) # 54cc <exit>
    a = b + 1;
    3b66:	84be                	mv	s1,a5
    b = sbrk(1);
    3b68:	4505                	li	a0,1
    3b6a:	00002097          	auipc	ra,0x2
    3b6e:	9ea080e7          	jalr	-1558(ra) # 5554 <sbrk>
    if (b != a) {
    3b72:	04951c63          	bne	a0,s1,3bca <sbrkbasic+0x13c>
    *b = 1;
    3b76:	4785                	li	a5,1
    3b78:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    3b7c:	00148793          	addi	a5,s1,1
  for (i = 0; i < 5000; i++) {
    3b80:	2905                	addiw	s2,s2,1
    3b82:	ff3912e3          	bne	s2,s3,3b66 <sbrkbasic+0xd8>
  pid = fork();
    3b86:	00002097          	auipc	ra,0x2
    3b8a:	93e080e7          	jalr	-1730(ra) # 54c4 <fork>
    3b8e:	892a                	mv	s2,a0
  if (pid < 0) {
    3b90:	04054d63          	bltz	a0,3bea <sbrkbasic+0x15c>
  c = sbrk(1);
    3b94:	4505                	li	a0,1
    3b96:	00002097          	auipc	ra,0x2
    3b9a:	9be080e7          	jalr	-1602(ra) # 5554 <sbrk>
  c = sbrk(1);
    3b9e:	4505                	li	a0,1
    3ba0:	00002097          	auipc	ra,0x2
    3ba4:	9b4080e7          	jalr	-1612(ra) # 5554 <sbrk>
  if (c != a + 1) {
    3ba8:	0489                	addi	s1,s1,2
    3baa:	04a48e63          	beq	s1,a0,3c06 <sbrkbasic+0x178>
    printf("%s: sbrk test failed post-fork\n", s);
    3bae:	85d2                	mv	a1,s4
    3bb0:	00004517          	auipc	a0,0x4
    3bb4:	b6050513          	addi	a0,a0,-1184 # 7710 <l_free+0x1caa>
    3bb8:	00002097          	auipc	ra,0x2
    3bbc:	c8c080e7          	jalr	-884(ra) # 5844 <printf>
    exit(1);
    3bc0:	4505                	li	a0,1
    3bc2:	00002097          	auipc	ra,0x2
    3bc6:	90a080e7          	jalr	-1782(ra) # 54cc <exit>
      printf("%s: sbrk test failed %d %x %x\n", i, a, b);
    3bca:	86aa                	mv	a3,a0
    3bcc:	8626                	mv	a2,s1
    3bce:	85ca                	mv	a1,s2
    3bd0:	00004517          	auipc	a0,0x4
    3bd4:	b0050513          	addi	a0,a0,-1280 # 76d0 <l_free+0x1c6a>
    3bd8:	00002097          	auipc	ra,0x2
    3bdc:	c6c080e7          	jalr	-916(ra) # 5844 <printf>
      exit(1);
    3be0:	4505                	li	a0,1
    3be2:	00002097          	auipc	ra,0x2
    3be6:	8ea080e7          	jalr	-1814(ra) # 54cc <exit>
    printf("%s: sbrk test fork failed\n", s);
    3bea:	85d2                	mv	a1,s4
    3bec:	00004517          	auipc	a0,0x4
    3bf0:	b0450513          	addi	a0,a0,-1276 # 76f0 <l_free+0x1c8a>
    3bf4:	00002097          	auipc	ra,0x2
    3bf8:	c50080e7          	jalr	-944(ra) # 5844 <printf>
    exit(1);
    3bfc:	4505                	li	a0,1
    3bfe:	00002097          	auipc	ra,0x2
    3c02:	8ce080e7          	jalr	-1842(ra) # 54cc <exit>
  if (pid == 0)
    3c06:	00091763          	bnez	s2,3c14 <sbrkbasic+0x186>
    exit(0);
    3c0a:	4501                	li	a0,0
    3c0c:	00002097          	auipc	ra,0x2
    3c10:	8c0080e7          	jalr	-1856(ra) # 54cc <exit>
  wait(&xstatus);
    3c14:	fcc40513          	addi	a0,s0,-52
    3c18:	00002097          	auipc	ra,0x2
    3c1c:	8bc080e7          	jalr	-1860(ra) # 54d4 <wait>
  exit(xstatus);
    3c20:	fcc42503          	lw	a0,-52(s0)
    3c24:	00002097          	auipc	ra,0x2
    3c28:	8a8080e7          	jalr	-1880(ra) # 54cc <exit>

0000000000003c2c <preempt>:
void preempt(char *s) {
    3c2c:	7139                	addi	sp,sp,-64
    3c2e:	fc06                	sd	ra,56(sp)
    3c30:	f822                	sd	s0,48(sp)
    3c32:	f426                	sd	s1,40(sp)
    3c34:	f04a                	sd	s2,32(sp)
    3c36:	ec4e                	sd	s3,24(sp)
    3c38:	e852                	sd	s4,16(sp)
    3c3a:	0080                	addi	s0,sp,64
    3c3c:	892a                	mv	s2,a0
  pid1 = fork();
    3c3e:	00002097          	auipc	ra,0x2
    3c42:	886080e7          	jalr	-1914(ra) # 54c4 <fork>
  if (pid1 < 0) {
    3c46:	00054563          	bltz	a0,3c50 <preempt+0x24>
    3c4a:	84aa                	mv	s1,a0
  if (pid1 == 0)
    3c4c:	ed19                	bnez	a0,3c6a <preempt+0x3e>
    for (;;)
    3c4e:	a001                	j	3c4e <preempt+0x22>
    printf("%s: fork failed");
    3c50:	00003517          	auipc	a0,0x3
    3c54:	aa050513          	addi	a0,a0,-1376 # 66f0 <l_free+0xc8a>
    3c58:	00002097          	auipc	ra,0x2
    3c5c:	bec080e7          	jalr	-1044(ra) # 5844 <printf>
    exit(1);
    3c60:	4505                	li	a0,1
    3c62:	00002097          	auipc	ra,0x2
    3c66:	86a080e7          	jalr	-1942(ra) # 54cc <exit>
  pid2 = fork();
    3c6a:	00002097          	auipc	ra,0x2
    3c6e:	85a080e7          	jalr	-1958(ra) # 54c4 <fork>
    3c72:	89aa                	mv	s3,a0
  if (pid2 < 0) {
    3c74:	00054463          	bltz	a0,3c7c <preempt+0x50>
  if (pid2 == 0)
    3c78:	e105                	bnez	a0,3c98 <preempt+0x6c>
    for (;;)
    3c7a:	a001                	j	3c7a <preempt+0x4e>
    printf("%s: fork failed\n", s);
    3c7c:	85ca                	mv	a1,s2
    3c7e:	00003517          	auipc	a0,0x3
    3c82:	8b250513          	addi	a0,a0,-1870 # 6530 <l_free+0xaca>
    3c86:	00002097          	auipc	ra,0x2
    3c8a:	bbe080e7          	jalr	-1090(ra) # 5844 <printf>
    exit(1);
    3c8e:	4505                	li	a0,1
    3c90:	00002097          	auipc	ra,0x2
    3c94:	83c080e7          	jalr	-1988(ra) # 54cc <exit>
  pipe(pfds);
    3c98:	fc840513          	addi	a0,s0,-56
    3c9c:	00002097          	auipc	ra,0x2
    3ca0:	840080e7          	jalr	-1984(ra) # 54dc <pipe>
  pid3 = fork();
    3ca4:	00002097          	auipc	ra,0x2
    3ca8:	820080e7          	jalr	-2016(ra) # 54c4 <fork>
    3cac:	8a2a                	mv	s4,a0
  if (pid3 < 0) {
    3cae:	02054e63          	bltz	a0,3cea <preempt+0xbe>
  if (pid3 == 0) {
    3cb2:	e13d                	bnez	a0,3d18 <preempt+0xec>
    close(pfds[0]);
    3cb4:	fc842503          	lw	a0,-56(s0)
    3cb8:	00002097          	auipc	ra,0x2
    3cbc:	83c080e7          	jalr	-1988(ra) # 54f4 <close>
    if (write(pfds[1], "x", 1) != 1)
    3cc0:	4605                	li	a2,1
    3cc2:	00002597          	auipc	a1,0x2
    3cc6:	16658593          	addi	a1,a1,358 # 5e28 <l_free+0x3c2>
    3cca:	fcc42503          	lw	a0,-52(s0)
    3cce:	00002097          	auipc	ra,0x2
    3cd2:	81e080e7          	jalr	-2018(ra) # 54ec <write>
    3cd6:	4785                	li	a5,1
    3cd8:	02f51763          	bne	a0,a5,3d06 <preempt+0xda>
    close(pfds[1]);
    3cdc:	fcc42503          	lw	a0,-52(s0)
    3ce0:	00002097          	auipc	ra,0x2
    3ce4:	814080e7          	jalr	-2028(ra) # 54f4 <close>
    for (;;)
    3ce8:	a001                	j	3ce8 <preempt+0xbc>
    printf("%s: fork failed\n", s);
    3cea:	85ca                	mv	a1,s2
    3cec:	00003517          	auipc	a0,0x3
    3cf0:	84450513          	addi	a0,a0,-1980 # 6530 <l_free+0xaca>
    3cf4:	00002097          	auipc	ra,0x2
    3cf8:	b50080e7          	jalr	-1200(ra) # 5844 <printf>
    exit(1);
    3cfc:	4505                	li	a0,1
    3cfe:	00001097          	auipc	ra,0x1
    3d02:	7ce080e7          	jalr	1998(ra) # 54cc <exit>
      printf("%s: preempt write error");
    3d06:	00004517          	auipc	a0,0x4
    3d0a:	a2a50513          	addi	a0,a0,-1494 # 7730 <l_free+0x1cca>
    3d0e:	00002097          	auipc	ra,0x2
    3d12:	b36080e7          	jalr	-1226(ra) # 5844 <printf>
    3d16:	b7d9                	j	3cdc <preempt+0xb0>
  close(pfds[1]);
    3d18:	fcc42503          	lw	a0,-52(s0)
    3d1c:	00001097          	auipc	ra,0x1
    3d20:	7d8080e7          	jalr	2008(ra) # 54f4 <close>
  if (read(pfds[0], buf, sizeof(buf)) != 1) {
    3d24:	660d                	lui	a2,0x3
    3d26:	00008597          	auipc	a1,0x8
    3d2a:	c9258593          	addi	a1,a1,-878 # b9b8 <buf>
    3d2e:	fc842503          	lw	a0,-56(s0)
    3d32:	00001097          	auipc	ra,0x1
    3d36:	7b2080e7          	jalr	1970(ra) # 54e4 <read>
    3d3a:	4785                	li	a5,1
    3d3c:	02f50263          	beq	a0,a5,3d60 <preempt+0x134>
    printf("%s: preempt read error");
    3d40:	00004517          	auipc	a0,0x4
    3d44:	a0850513          	addi	a0,a0,-1528 # 7748 <l_free+0x1ce2>
    3d48:	00002097          	auipc	ra,0x2
    3d4c:	afc080e7          	jalr	-1284(ra) # 5844 <printf>
}
    3d50:	70e2                	ld	ra,56(sp)
    3d52:	7442                	ld	s0,48(sp)
    3d54:	74a2                	ld	s1,40(sp)
    3d56:	7902                	ld	s2,32(sp)
    3d58:	69e2                	ld	s3,24(sp)
    3d5a:	6a42                	ld	s4,16(sp)
    3d5c:	6121                	addi	sp,sp,64
    3d5e:	8082                	ret
  close(pfds[0]);
    3d60:	fc842503          	lw	a0,-56(s0)
    3d64:	00001097          	auipc	ra,0x1
    3d68:	790080e7          	jalr	1936(ra) # 54f4 <close>
  printf("kill... ");
    3d6c:	00004517          	auipc	a0,0x4
    3d70:	9f450513          	addi	a0,a0,-1548 # 7760 <l_free+0x1cfa>
    3d74:	00002097          	auipc	ra,0x2
    3d78:	ad0080e7          	jalr	-1328(ra) # 5844 <printf>
  kill(pid1);
    3d7c:	8526                	mv	a0,s1
    3d7e:	00001097          	auipc	ra,0x1
    3d82:	77e080e7          	jalr	1918(ra) # 54fc <kill>
  kill(pid2);
    3d86:	854e                	mv	a0,s3
    3d88:	00001097          	auipc	ra,0x1
    3d8c:	774080e7          	jalr	1908(ra) # 54fc <kill>
  kill(pid3);
    3d90:	8552                	mv	a0,s4
    3d92:	00001097          	auipc	ra,0x1
    3d96:	76a080e7          	jalr	1898(ra) # 54fc <kill>
  printf("wait... ");
    3d9a:	00004517          	auipc	a0,0x4
    3d9e:	9d650513          	addi	a0,a0,-1578 # 7770 <l_free+0x1d0a>
    3da2:	00002097          	auipc	ra,0x2
    3da6:	aa2080e7          	jalr	-1374(ra) # 5844 <printf>
  wait(0);
    3daa:	4501                	li	a0,0
    3dac:	00001097          	auipc	ra,0x1
    3db0:	728080e7          	jalr	1832(ra) # 54d4 <wait>
  wait(0);
    3db4:	4501                	li	a0,0
    3db6:	00001097          	auipc	ra,0x1
    3dba:	71e080e7          	jalr	1822(ra) # 54d4 <wait>
  wait(0);
    3dbe:	4501                	li	a0,0
    3dc0:	00001097          	auipc	ra,0x1
    3dc4:	714080e7          	jalr	1812(ra) # 54d4 <wait>
    3dc8:	b761                	j	3d50 <preempt+0x124>

0000000000003dca <sbrkfail>:
void sbrkfail(char *s) {
    3dca:	7119                	addi	sp,sp,-128
    3dcc:	fc86                	sd	ra,120(sp)
    3dce:	f8a2                	sd	s0,112(sp)
    3dd0:	f4a6                	sd	s1,104(sp)
    3dd2:	f0ca                	sd	s2,96(sp)
    3dd4:	ecce                	sd	s3,88(sp)
    3dd6:	e8d2                	sd	s4,80(sp)
    3dd8:	e4d6                	sd	s5,72(sp)
    3dda:	0100                	addi	s0,sp,128
    3ddc:	8aaa                	mv	s5,a0
  if (pipe(fds) != 0) {
    3dde:	fb040513          	addi	a0,s0,-80
    3de2:	00001097          	auipc	ra,0x1
    3de6:	6fa080e7          	jalr	1786(ra) # 54dc <pipe>
    3dea:	e901                	bnez	a0,3dfa <sbrkfail+0x30>
    3dec:	f8040493          	addi	s1,s0,-128
    3df0:	fa840993          	addi	s3,s0,-88
    3df4:	8926                	mv	s2,s1
    if (pids[i] != -1)
    3df6:	5a7d                	li	s4,-1
    3df8:	a085                	j	3e58 <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    3dfa:	85d6                	mv	a1,s5
    3dfc:	00003517          	auipc	a0,0x3
    3e00:	83c50513          	addi	a0,a0,-1988 # 6638 <l_free+0xbd2>
    3e04:	00002097          	auipc	ra,0x2
    3e08:	a40080e7          	jalr	-1472(ra) # 5844 <printf>
    exit(1);
    3e0c:	4505                	li	a0,1
    3e0e:	00001097          	auipc	ra,0x1
    3e12:	6be080e7          	jalr	1726(ra) # 54cc <exit>
      sbrk(BIG - (uint64)sbrk(0));
    3e16:	00001097          	auipc	ra,0x1
    3e1a:	73e080e7          	jalr	1854(ra) # 5554 <sbrk>
    3e1e:	064007b7          	lui	a5,0x6400
    3e22:	40a7853b          	subw	a0,a5,a0
    3e26:	00001097          	auipc	ra,0x1
    3e2a:	72e080e7          	jalr	1838(ra) # 5554 <sbrk>
      write(fds[1], "x", 1);
    3e2e:	4605                	li	a2,1
    3e30:	00002597          	auipc	a1,0x2
    3e34:	ff858593          	addi	a1,a1,-8 # 5e28 <l_free+0x3c2>
    3e38:	fb442503          	lw	a0,-76(s0)
    3e3c:	00001097          	auipc	ra,0x1
    3e40:	6b0080e7          	jalr	1712(ra) # 54ec <write>
        sleep(1000);
    3e44:	3e800513          	li	a0,1000
    3e48:	00001097          	auipc	ra,0x1
    3e4c:	714080e7          	jalr	1812(ra) # 555c <sleep>
      for (;;)
    3e50:	bfd5                	j	3e44 <sbrkfail+0x7a>
  for (i = 0; i < sizeof(pids) / sizeof(pids[0]); i++) {
    3e52:	0911                	addi	s2,s2,4
    3e54:	03390563          	beq	s2,s3,3e7e <sbrkfail+0xb4>
    if ((pids[i] = fork()) == 0) {
    3e58:	00001097          	auipc	ra,0x1
    3e5c:	66c080e7          	jalr	1644(ra) # 54c4 <fork>
    3e60:	00a92023          	sw	a0,0(s2)
    3e64:	d94d                	beqz	a0,3e16 <sbrkfail+0x4c>
    if (pids[i] != -1)
    3e66:	ff4506e3          	beq	a0,s4,3e52 <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    3e6a:	4605                	li	a2,1
    3e6c:	faf40593          	addi	a1,s0,-81
    3e70:	fb042503          	lw	a0,-80(s0)
    3e74:	00001097          	auipc	ra,0x1
    3e78:	670080e7          	jalr	1648(ra) # 54e4 <read>
    3e7c:	bfd9                	j	3e52 <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    3e7e:	6505                	lui	a0,0x1
    3e80:	00001097          	auipc	ra,0x1
    3e84:	6d4080e7          	jalr	1748(ra) # 5554 <sbrk>
    3e88:	8a2a                	mv	s4,a0
    if (pids[i] == -1)
    3e8a:	597d                	li	s2,-1
    3e8c:	a021                	j	3e94 <sbrkfail+0xca>
  for (i = 0; i < sizeof(pids) / sizeof(pids[0]); i++) {
    3e8e:	0491                	addi	s1,s1,4
    3e90:	01348f63          	beq	s1,s3,3eae <sbrkfail+0xe4>
    if (pids[i] == -1)
    3e94:	4088                	lw	a0,0(s1)
    3e96:	ff250ce3          	beq	a0,s2,3e8e <sbrkfail+0xc4>
    kill(pids[i]);
    3e9a:	00001097          	auipc	ra,0x1
    3e9e:	662080e7          	jalr	1634(ra) # 54fc <kill>
    wait(0);
    3ea2:	4501                	li	a0,0
    3ea4:	00001097          	auipc	ra,0x1
    3ea8:	630080e7          	jalr	1584(ra) # 54d4 <wait>
    3eac:	b7cd                	j	3e8e <sbrkfail+0xc4>
  if (c == (char *)0xffffffffffffffffL) {
    3eae:	57fd                	li	a5,-1
    3eb0:	04fa0163          	beq	s4,a5,3ef2 <sbrkfail+0x128>
  pid = fork();
    3eb4:	00001097          	auipc	ra,0x1
    3eb8:	610080e7          	jalr	1552(ra) # 54c4 <fork>
    3ebc:	84aa                	mv	s1,a0
  if (pid < 0) {
    3ebe:	04054863          	bltz	a0,3f0e <sbrkfail+0x144>
  if (pid == 0) {
    3ec2:	c525                	beqz	a0,3f2a <sbrkfail+0x160>
  wait(&xstatus);
    3ec4:	fbc40513          	addi	a0,s0,-68
    3ec8:	00001097          	auipc	ra,0x1
    3ecc:	60c080e7          	jalr	1548(ra) # 54d4 <wait>
  if (xstatus != -1 && xstatus != 2)
    3ed0:	fbc42783          	lw	a5,-68(s0)
    3ed4:	577d                	li	a4,-1
    3ed6:	00e78563          	beq	a5,a4,3ee0 <sbrkfail+0x116>
    3eda:	4709                	li	a4,2
    3edc:	08e79c63          	bne	a5,a4,3f74 <sbrkfail+0x1aa>
}
    3ee0:	70e6                	ld	ra,120(sp)
    3ee2:	7446                	ld	s0,112(sp)
    3ee4:	74a6                	ld	s1,104(sp)
    3ee6:	7906                	ld	s2,96(sp)
    3ee8:	69e6                	ld	s3,88(sp)
    3eea:	6a46                	ld	s4,80(sp)
    3eec:	6aa6                	ld	s5,72(sp)
    3eee:	6109                	addi	sp,sp,128
    3ef0:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    3ef2:	85d6                	mv	a1,s5
    3ef4:	00004517          	auipc	a0,0x4
    3ef8:	88c50513          	addi	a0,a0,-1908 # 7780 <l_free+0x1d1a>
    3efc:	00002097          	auipc	ra,0x2
    3f00:	948080e7          	jalr	-1720(ra) # 5844 <printf>
    exit(1);
    3f04:	4505                	li	a0,1
    3f06:	00001097          	auipc	ra,0x1
    3f0a:	5c6080e7          	jalr	1478(ra) # 54cc <exit>
    printf("%s: fork failed\n", s);
    3f0e:	85d6                	mv	a1,s5
    3f10:	00002517          	auipc	a0,0x2
    3f14:	62050513          	addi	a0,a0,1568 # 6530 <l_free+0xaca>
    3f18:	00002097          	auipc	ra,0x2
    3f1c:	92c080e7          	jalr	-1748(ra) # 5844 <printf>
    exit(1);
    3f20:	4505                	li	a0,1
    3f22:	00001097          	auipc	ra,0x1
    3f26:	5aa080e7          	jalr	1450(ra) # 54cc <exit>
    a = sbrk(0);
    3f2a:	4501                	li	a0,0
    3f2c:	00001097          	auipc	ra,0x1
    3f30:	628080e7          	jalr	1576(ra) # 5554 <sbrk>
    3f34:	892a                	mv	s2,a0
    sbrk(10 * BIG);
    3f36:	3e800537          	lui	a0,0x3e800
    3f3a:	00001097          	auipc	ra,0x1
    3f3e:	61a080e7          	jalr	1562(ra) # 5554 <sbrk>
    for (i = 0; i < 10 * BIG; i += PGSIZE) {
    3f42:	87ca                	mv	a5,s2
    3f44:	3e800737          	lui	a4,0x3e800
    3f48:	993a                	add	s2,s2,a4
    3f4a:	6705                	lui	a4,0x1
      n += *(a + i);
    3f4c:	0007c683          	lbu	a3,0(a5) # 6400000 <__BSS_END__+0x63f1638>
    3f50:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10 * BIG; i += PGSIZE) {
    3f52:	97ba                	add	a5,a5,a4
    3f54:	ff279ce3          	bne	a5,s2,3f4c <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", n);
    3f58:	85a6                	mv	a1,s1
    3f5a:	00004517          	auipc	a0,0x4
    3f5e:	84650513          	addi	a0,a0,-1978 # 77a0 <l_free+0x1d3a>
    3f62:	00002097          	auipc	ra,0x2
    3f66:	8e2080e7          	jalr	-1822(ra) # 5844 <printf>
    exit(1);
    3f6a:	4505                	li	a0,1
    3f6c:	00001097          	auipc	ra,0x1
    3f70:	560080e7          	jalr	1376(ra) # 54cc <exit>
    exit(1);
    3f74:	4505                	li	a0,1
    3f76:	00001097          	auipc	ra,0x1
    3f7a:	556080e7          	jalr	1366(ra) # 54cc <exit>

0000000000003f7e <reparent>:
void reparent(char *s) {
    3f7e:	7179                	addi	sp,sp,-48
    3f80:	f406                	sd	ra,40(sp)
    3f82:	f022                	sd	s0,32(sp)
    3f84:	ec26                	sd	s1,24(sp)
    3f86:	e84a                	sd	s2,16(sp)
    3f88:	e44e                	sd	s3,8(sp)
    3f8a:	e052                	sd	s4,0(sp)
    3f8c:	1800                	addi	s0,sp,48
    3f8e:	89aa                	mv	s3,a0
  int master_pid = getpid();
    3f90:	00001097          	auipc	ra,0x1
    3f94:	5bc080e7          	jalr	1468(ra) # 554c <getpid>
    3f98:	8a2a                	mv	s4,a0
    3f9a:	0c800913          	li	s2,200
    int pid = fork();
    3f9e:	00001097          	auipc	ra,0x1
    3fa2:	526080e7          	jalr	1318(ra) # 54c4 <fork>
    3fa6:	84aa                	mv	s1,a0
    if (pid < 0) {
    3fa8:	02054263          	bltz	a0,3fcc <reparent+0x4e>
    if (pid) {
    3fac:	cd21                	beqz	a0,4004 <reparent+0x86>
      if (wait(0) != pid) {
    3fae:	4501                	li	a0,0
    3fb0:	00001097          	auipc	ra,0x1
    3fb4:	524080e7          	jalr	1316(ra) # 54d4 <wait>
    3fb8:	02951863          	bne	a0,s1,3fe8 <reparent+0x6a>
  for (int i = 0; i < 200; i++) {
    3fbc:	397d                	addiw	s2,s2,-1
    3fbe:	fe0910e3          	bnez	s2,3f9e <reparent+0x20>
  exit(0);
    3fc2:	4501                	li	a0,0
    3fc4:	00001097          	auipc	ra,0x1
    3fc8:	508080e7          	jalr	1288(ra) # 54cc <exit>
      printf("%s: fork failed\n", s);
    3fcc:	85ce                	mv	a1,s3
    3fce:	00002517          	auipc	a0,0x2
    3fd2:	56250513          	addi	a0,a0,1378 # 6530 <l_free+0xaca>
    3fd6:	00002097          	auipc	ra,0x2
    3fda:	86e080e7          	jalr	-1938(ra) # 5844 <printf>
      exit(1);
    3fde:	4505                	li	a0,1
    3fe0:	00001097          	auipc	ra,0x1
    3fe4:	4ec080e7          	jalr	1260(ra) # 54cc <exit>
        printf("%s: wait wrong pid\n", s);
    3fe8:	85ce                	mv	a1,s3
    3fea:	00002517          	auipc	a0,0x2
    3fee:	6ce50513          	addi	a0,a0,1742 # 66b8 <l_free+0xc52>
    3ff2:	00002097          	auipc	ra,0x2
    3ff6:	852080e7          	jalr	-1966(ra) # 5844 <printf>
        exit(1);
    3ffa:	4505                	li	a0,1
    3ffc:	00001097          	auipc	ra,0x1
    4000:	4d0080e7          	jalr	1232(ra) # 54cc <exit>
      int pid2 = fork();
    4004:	00001097          	auipc	ra,0x1
    4008:	4c0080e7          	jalr	1216(ra) # 54c4 <fork>
      if (pid2 < 0) {
    400c:	00054763          	bltz	a0,401a <reparent+0x9c>
      exit(0);
    4010:	4501                	li	a0,0
    4012:	00001097          	auipc	ra,0x1
    4016:	4ba080e7          	jalr	1210(ra) # 54cc <exit>
        kill(master_pid);
    401a:	8552                	mv	a0,s4
    401c:	00001097          	auipc	ra,0x1
    4020:	4e0080e7          	jalr	1248(ra) # 54fc <kill>
        exit(1);
    4024:	4505                	li	a0,1
    4026:	00001097          	auipc	ra,0x1
    402a:	4a6080e7          	jalr	1190(ra) # 54cc <exit>

000000000000402e <mem>:
void mem(char *s) {
    402e:	7139                	addi	sp,sp,-64
    4030:	fc06                	sd	ra,56(sp)
    4032:	f822                	sd	s0,48(sp)
    4034:	f426                	sd	s1,40(sp)
    4036:	f04a                	sd	s2,32(sp)
    4038:	ec4e                	sd	s3,24(sp)
    403a:	0080                	addi	s0,sp,64
    403c:	89aa                	mv	s3,a0
  if ((pid = fork()) == 0) {
    403e:	00001097          	auipc	ra,0x1
    4042:	486080e7          	jalr	1158(ra) # 54c4 <fork>
    m1 = 0;
    4046:	4481                	li	s1,0
    while ((m2 = malloc(10001)) != 0) {
    4048:	6909                	lui	s2,0x2
    404a:	71190913          	addi	s2,s2,1809 # 2711 <sbrkbugs+0x3d>
  if ((pid = fork()) == 0) {
    404e:	c115                	beqz	a0,4072 <mem+0x44>
    wait(&xstatus);
    4050:	fcc40513          	addi	a0,s0,-52
    4054:	00001097          	auipc	ra,0x1
    4058:	480080e7          	jalr	1152(ra) # 54d4 <wait>
    if (xstatus == -1) {
    405c:	fcc42503          	lw	a0,-52(s0)
    4060:	57fd                	li	a5,-1
    4062:	06f50363          	beq	a0,a5,40c8 <mem+0x9a>
    exit(xstatus);
    4066:	00001097          	auipc	ra,0x1
    406a:	466080e7          	jalr	1126(ra) # 54cc <exit>
      *(char **)m2 = m1;
    406e:	e104                	sd	s1,0(a0)
      m1 = m2;
    4070:	84aa                	mv	s1,a0
    while ((m2 = malloc(10001)) != 0) {
    4072:	854a                	mv	a0,s2
    4074:	00002097          	auipc	ra,0x2
    4078:	88e080e7          	jalr	-1906(ra) # 5902 <malloc>
    407c:	f96d                	bnez	a0,406e <mem+0x40>
    while (m1) {
    407e:	c881                	beqz	s1,408e <mem+0x60>
      m2 = *(char **)m1;
    4080:	8526                	mv	a0,s1
    4082:	6084                	ld	s1,0(s1)
      free(m1);
    4084:	00001097          	auipc	ra,0x1
    4088:	7f6080e7          	jalr	2038(ra) # 587a <free>
    while (m1) {
    408c:	f8f5                	bnez	s1,4080 <mem+0x52>
    m1 = malloc(1024 * 20);
    408e:	6515                	lui	a0,0x5
    4090:	00002097          	auipc	ra,0x2
    4094:	872080e7          	jalr	-1934(ra) # 5902 <malloc>
    if (m1 == 0) {
    4098:	c911                	beqz	a0,40ac <mem+0x7e>
    free(m1);
    409a:	00001097          	auipc	ra,0x1
    409e:	7e0080e7          	jalr	2016(ra) # 587a <free>
    exit(0);
    40a2:	4501                	li	a0,0
    40a4:	00001097          	auipc	ra,0x1
    40a8:	428080e7          	jalr	1064(ra) # 54cc <exit>
      printf("couldn't allocate mem?!!\n", s);
    40ac:	85ce                	mv	a1,s3
    40ae:	00003517          	auipc	a0,0x3
    40b2:	72250513          	addi	a0,a0,1826 # 77d0 <l_free+0x1d6a>
    40b6:	00001097          	auipc	ra,0x1
    40ba:	78e080e7          	jalr	1934(ra) # 5844 <printf>
      exit(1);
    40be:	4505                	li	a0,1
    40c0:	00001097          	auipc	ra,0x1
    40c4:	40c080e7          	jalr	1036(ra) # 54cc <exit>
      exit(0);
    40c8:	4501                	li	a0,0
    40ca:	00001097          	auipc	ra,0x1
    40ce:	402080e7          	jalr	1026(ra) # 54cc <exit>

00000000000040d2 <sharedfd>:
void sharedfd(char *s) {
    40d2:	7159                	addi	sp,sp,-112
    40d4:	f486                	sd	ra,104(sp)
    40d6:	f0a2                	sd	s0,96(sp)
    40d8:	eca6                	sd	s1,88(sp)
    40da:	e8ca                	sd	s2,80(sp)
    40dc:	e4ce                	sd	s3,72(sp)
    40de:	e0d2                	sd	s4,64(sp)
    40e0:	fc56                	sd	s5,56(sp)
    40e2:	f85a                	sd	s6,48(sp)
    40e4:	f45e                	sd	s7,40(sp)
    40e6:	1880                	addi	s0,sp,112
    40e8:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    40ea:	00002517          	auipc	a0,0x2
    40ee:	b2650513          	addi	a0,a0,-1242 # 5c10 <l_free+0x1aa>
    40f2:	00001097          	auipc	ra,0x1
    40f6:	42a080e7          	jalr	1066(ra) # 551c <unlink>
  fd = open("sharedfd", O_CREATE | O_RDWR);
    40fa:	20200593          	li	a1,514
    40fe:	00002517          	auipc	a0,0x2
    4102:	b1250513          	addi	a0,a0,-1262 # 5c10 <l_free+0x1aa>
    4106:	00001097          	auipc	ra,0x1
    410a:	406080e7          	jalr	1030(ra) # 550c <open>
  if (fd < 0) {
    410e:	04054a63          	bltz	a0,4162 <sharedfd+0x90>
    4112:	892a                	mv	s2,a0
  pid = fork();
    4114:	00001097          	auipc	ra,0x1
    4118:	3b0080e7          	jalr	944(ra) # 54c4 <fork>
    411c:	89aa                	mv	s3,a0
  memset(buf, pid == 0 ? 'c' : 'p', sizeof(buf));
    411e:	06300593          	li	a1,99
    4122:	c119                	beqz	a0,4128 <sharedfd+0x56>
    4124:	07000593          	li	a1,112
    4128:	4629                	li	a2,10
    412a:	fa040513          	addi	a0,s0,-96
    412e:	00001097          	auipc	ra,0x1
    4132:	1a2080e7          	jalr	418(ra) # 52d0 <memset>
    4136:	3e800493          	li	s1,1000
    if (write(fd, buf, sizeof(buf)) != sizeof(buf)) {
    413a:	4629                	li	a2,10
    413c:	fa040593          	addi	a1,s0,-96
    4140:	854a                	mv	a0,s2
    4142:	00001097          	auipc	ra,0x1
    4146:	3aa080e7          	jalr	938(ra) # 54ec <write>
    414a:	47a9                	li	a5,10
    414c:	02f51963          	bne	a0,a5,417e <sharedfd+0xac>
  for (i = 0; i < N; i++) {
    4150:	34fd                	addiw	s1,s1,-1
    4152:	f4e5                	bnez	s1,413a <sharedfd+0x68>
  if (pid == 0) {
    4154:	04099363          	bnez	s3,419a <sharedfd+0xc8>
    exit(0);
    4158:	4501                	li	a0,0
    415a:	00001097          	auipc	ra,0x1
    415e:	372080e7          	jalr	882(ra) # 54cc <exit>
    printf("%s: cannot open sharedfd for writing", s);
    4162:	85d2                	mv	a1,s4
    4164:	00003517          	auipc	a0,0x3
    4168:	68c50513          	addi	a0,a0,1676 # 77f0 <l_free+0x1d8a>
    416c:	00001097          	auipc	ra,0x1
    4170:	6d8080e7          	jalr	1752(ra) # 5844 <printf>
    exit(1);
    4174:	4505                	li	a0,1
    4176:	00001097          	auipc	ra,0x1
    417a:	356080e7          	jalr	854(ra) # 54cc <exit>
      printf("%s: write sharedfd failed\n", s);
    417e:	85d2                	mv	a1,s4
    4180:	00003517          	auipc	a0,0x3
    4184:	69850513          	addi	a0,a0,1688 # 7818 <l_free+0x1db2>
    4188:	00001097          	auipc	ra,0x1
    418c:	6bc080e7          	jalr	1724(ra) # 5844 <printf>
      exit(1);
    4190:	4505                	li	a0,1
    4192:	00001097          	auipc	ra,0x1
    4196:	33a080e7          	jalr	826(ra) # 54cc <exit>
    wait(&xstatus);
    419a:	f9c40513          	addi	a0,s0,-100
    419e:	00001097          	auipc	ra,0x1
    41a2:	336080e7          	jalr	822(ra) # 54d4 <wait>
    if (xstatus != 0)
    41a6:	f9c42983          	lw	s3,-100(s0)
    41aa:	00098763          	beqz	s3,41b8 <sharedfd+0xe6>
      exit(xstatus);
    41ae:	854e                	mv	a0,s3
    41b0:	00001097          	auipc	ra,0x1
    41b4:	31c080e7          	jalr	796(ra) # 54cc <exit>
  close(fd);
    41b8:	854a                	mv	a0,s2
    41ba:	00001097          	auipc	ra,0x1
    41be:	33a080e7          	jalr	826(ra) # 54f4 <close>
  fd = open("sharedfd", 0);
    41c2:	4581                	li	a1,0
    41c4:	00002517          	auipc	a0,0x2
    41c8:	a4c50513          	addi	a0,a0,-1460 # 5c10 <l_free+0x1aa>
    41cc:	00001097          	auipc	ra,0x1
    41d0:	340080e7          	jalr	832(ra) # 550c <open>
    41d4:	8baa                	mv	s7,a0
  nc = np = 0;
    41d6:	8ace                	mv	s5,s3
  if (fd < 0) {
    41d8:	02054563          	bltz	a0,4202 <sharedfd+0x130>
    41dc:	faa40913          	addi	s2,s0,-86
      if (buf[i] == 'c')
    41e0:	06300493          	li	s1,99
      if (buf[i] == 'p')
    41e4:	07000b13          	li	s6,112
  while ((n = read(fd, buf, sizeof(buf))) > 0) {
    41e8:	4629                	li	a2,10
    41ea:	fa040593          	addi	a1,s0,-96
    41ee:	855e                	mv	a0,s7
    41f0:	00001097          	auipc	ra,0x1
    41f4:	2f4080e7          	jalr	756(ra) # 54e4 <read>
    41f8:	02a05f63          	blez	a0,4236 <sharedfd+0x164>
    41fc:	fa040793          	addi	a5,s0,-96
    4200:	a01d                	j	4226 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    4202:	85d2                	mv	a1,s4
    4204:	00003517          	auipc	a0,0x3
    4208:	63450513          	addi	a0,a0,1588 # 7838 <l_free+0x1dd2>
    420c:	00001097          	auipc	ra,0x1
    4210:	638080e7          	jalr	1592(ra) # 5844 <printf>
    exit(1);
    4214:	4505                	li	a0,1
    4216:	00001097          	auipc	ra,0x1
    421a:	2b6080e7          	jalr	694(ra) # 54cc <exit>
        nc++;
    421e:	2985                	addiw	s3,s3,1
    for (i = 0; i < sizeof(buf); i++) {
    4220:	0785                	addi	a5,a5,1
    4222:	fd2783e3          	beq	a5,s2,41e8 <sharedfd+0x116>
      if (buf[i] == 'c')
    4226:	0007c703          	lbu	a4,0(a5)
    422a:	fe970ae3          	beq	a4,s1,421e <sharedfd+0x14c>
      if (buf[i] == 'p')
    422e:	ff6719e3          	bne	a4,s6,4220 <sharedfd+0x14e>
        np++;
    4232:	2a85                	addiw	s5,s5,1
    4234:	b7f5                	j	4220 <sharedfd+0x14e>
  close(fd);
    4236:	855e                	mv	a0,s7
    4238:	00001097          	auipc	ra,0x1
    423c:	2bc080e7          	jalr	700(ra) # 54f4 <close>
  unlink("sharedfd");
    4240:	00002517          	auipc	a0,0x2
    4244:	9d050513          	addi	a0,a0,-1584 # 5c10 <l_free+0x1aa>
    4248:	00001097          	auipc	ra,0x1
    424c:	2d4080e7          	jalr	724(ra) # 551c <unlink>
  if (nc == N * SZ && np == N * SZ) {
    4250:	6789                	lui	a5,0x2
    4252:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbugs+0x3c>
    4256:	00f99763          	bne	s3,a5,4264 <sharedfd+0x192>
    425a:	6789                	lui	a5,0x2
    425c:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbugs+0x3c>
    4260:	02fa8063          	beq	s5,a5,4280 <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    4264:	85d2                	mv	a1,s4
    4266:	00003517          	auipc	a0,0x3
    426a:	5fa50513          	addi	a0,a0,1530 # 7860 <l_free+0x1dfa>
    426e:	00001097          	auipc	ra,0x1
    4272:	5d6080e7          	jalr	1494(ra) # 5844 <printf>
    exit(1);
    4276:	4505                	li	a0,1
    4278:	00001097          	auipc	ra,0x1
    427c:	254080e7          	jalr	596(ra) # 54cc <exit>
    exit(0);
    4280:	4501                	li	a0,0
    4282:	00001097          	auipc	ra,0x1
    4286:	24a080e7          	jalr	586(ra) # 54cc <exit>

000000000000428a <fourfiles>:
void fourfiles(char *s) {
    428a:	7171                	addi	sp,sp,-176
    428c:	f506                	sd	ra,168(sp)
    428e:	f122                	sd	s0,160(sp)
    4290:	ed26                	sd	s1,152(sp)
    4292:	e94a                	sd	s2,144(sp)
    4294:	e54e                	sd	s3,136(sp)
    4296:	e152                	sd	s4,128(sp)
    4298:	fcd6                	sd	s5,120(sp)
    429a:	f8da                	sd	s6,112(sp)
    429c:	f4de                	sd	s7,104(sp)
    429e:	f0e2                	sd	s8,96(sp)
    42a0:	ece6                	sd	s9,88(sp)
    42a2:	e8ea                	sd	s10,80(sp)
    42a4:	e4ee                	sd	s11,72(sp)
    42a6:	1900                	addi	s0,sp,176
    42a8:	f4a43c23          	sd	a0,-168(s0)
  char *names[] = {"f0", "f1", "f2", "f3"};
    42ac:	00001797          	auipc	a5,0x1
    42b0:	7cc78793          	addi	a5,a5,1996 # 5a78 <l_free+0x12>
    42b4:	f6f43823          	sd	a5,-144(s0)
    42b8:	00001797          	auipc	a5,0x1
    42bc:	7c878793          	addi	a5,a5,1992 # 5a80 <l_free+0x1a>
    42c0:	f6f43c23          	sd	a5,-136(s0)
    42c4:	00001797          	auipc	a5,0x1
    42c8:	7c478793          	addi	a5,a5,1988 # 5a88 <l_free+0x22>
    42cc:	f8f43023          	sd	a5,-128(s0)
    42d0:	00001797          	auipc	a5,0x1
    42d4:	7c078793          	addi	a5,a5,1984 # 5a90 <l_free+0x2a>
    42d8:	f8f43423          	sd	a5,-120(s0)
  for (pi = 0; pi < NCHILD; pi++) {
    42dc:	f7040c13          	addi	s8,s0,-144
  char *names[] = {"f0", "f1", "f2", "f3"};
    42e0:	8962                	mv	s2,s8
  for (pi = 0; pi < NCHILD; pi++) {
    42e2:	4481                	li	s1,0
    42e4:	4a11                	li	s4,4
    fname = names[pi];
    42e6:	00093983          	ld	s3,0(s2)
    unlink(fname);
    42ea:	854e                	mv	a0,s3
    42ec:	00001097          	auipc	ra,0x1
    42f0:	230080e7          	jalr	560(ra) # 551c <unlink>
    pid = fork();
    42f4:	00001097          	auipc	ra,0x1
    42f8:	1d0080e7          	jalr	464(ra) # 54c4 <fork>
    if (pid < 0) {
    42fc:	04054463          	bltz	a0,4344 <fourfiles+0xba>
    if (pid == 0) {
    4300:	c12d                	beqz	a0,4362 <fourfiles+0xd8>
  for (pi = 0; pi < NCHILD; pi++) {
    4302:	2485                	addiw	s1,s1,1
    4304:	0921                	addi	s2,s2,8
    4306:	ff4490e3          	bne	s1,s4,42e6 <fourfiles+0x5c>
    430a:	4491                	li	s1,4
    wait(&xstatus);
    430c:	f6c40513          	addi	a0,s0,-148
    4310:	00001097          	auipc	ra,0x1
    4314:	1c4080e7          	jalr	452(ra) # 54d4 <wait>
    if (xstatus != 0)
    4318:	f6c42b03          	lw	s6,-148(s0)
    431c:	0c0b1e63          	bnez	s6,43f8 <fourfiles+0x16e>
  for (pi = 0; pi < NCHILD; pi++) {
    4320:	34fd                	addiw	s1,s1,-1
    4322:	f4ed                	bnez	s1,430c <fourfiles+0x82>
    4324:	03000b93          	li	s7,48
    while ((n = read(fd, buf, sizeof(buf))) > 0) {
    4328:	00007a17          	auipc	s4,0x7
    432c:	690a0a13          	addi	s4,s4,1680 # b9b8 <buf>
    4330:	00007a97          	auipc	s5,0x7
    4334:	689a8a93          	addi	s5,s5,1673 # b9b9 <buf+0x1>
    if (total != N * SZ) {
    4338:	6d85                	lui	s11,0x1
    433a:	770d8d93          	addi	s11,s11,1904 # 1770 <pipe1+0xc8>
  for (i = 0; i < NCHILD; i++) {
    433e:	03400d13          	li	s10,52
    4342:	aa1d                	j	4478 <fourfiles+0x1ee>
      printf("fork failed\n", s);
    4344:	f5843583          	ld	a1,-168(s0)
    4348:	00002517          	auipc	a0,0x2
    434c:	5d850513          	addi	a0,a0,1496 # 6920 <l_free+0xeba>
    4350:	00001097          	auipc	ra,0x1
    4354:	4f4080e7          	jalr	1268(ra) # 5844 <printf>
      exit(1);
    4358:	4505                	li	a0,1
    435a:	00001097          	auipc	ra,0x1
    435e:	172080e7          	jalr	370(ra) # 54cc <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4362:	20200593          	li	a1,514
    4366:	854e                	mv	a0,s3
    4368:	00001097          	auipc	ra,0x1
    436c:	1a4080e7          	jalr	420(ra) # 550c <open>
    4370:	892a                	mv	s2,a0
      if (fd < 0) {
    4372:	04054763          	bltz	a0,43c0 <fourfiles+0x136>
      memset(buf, '0' + pi, SZ);
    4376:	1f400613          	li	a2,500
    437a:	0304859b          	addiw	a1,s1,48
    437e:	00007517          	auipc	a0,0x7
    4382:	63a50513          	addi	a0,a0,1594 # b9b8 <buf>
    4386:	00001097          	auipc	ra,0x1
    438a:	f4a080e7          	jalr	-182(ra) # 52d0 <memset>
    438e:	44b1                	li	s1,12
        if ((n = write(fd, buf, SZ)) != SZ) {
    4390:	00007997          	auipc	s3,0x7
    4394:	62898993          	addi	s3,s3,1576 # b9b8 <buf>
    4398:	1f400613          	li	a2,500
    439c:	85ce                	mv	a1,s3
    439e:	854a                	mv	a0,s2
    43a0:	00001097          	auipc	ra,0x1
    43a4:	14c080e7          	jalr	332(ra) # 54ec <write>
    43a8:	85aa                	mv	a1,a0
    43aa:	1f400793          	li	a5,500
    43ae:	02f51863          	bne	a0,a5,43de <fourfiles+0x154>
      for (i = 0; i < N; i++) {
    43b2:	34fd                	addiw	s1,s1,-1
    43b4:	f0f5                	bnez	s1,4398 <fourfiles+0x10e>
      exit(0);
    43b6:	4501                	li	a0,0
    43b8:	00001097          	auipc	ra,0x1
    43bc:	114080e7          	jalr	276(ra) # 54cc <exit>
        printf("create failed\n", s);
    43c0:	f5843583          	ld	a1,-168(s0)
    43c4:	00003517          	auipc	a0,0x3
    43c8:	4b450513          	addi	a0,a0,1204 # 7878 <l_free+0x1e12>
    43cc:	00001097          	auipc	ra,0x1
    43d0:	478080e7          	jalr	1144(ra) # 5844 <printf>
        exit(1);
    43d4:	4505                	li	a0,1
    43d6:	00001097          	auipc	ra,0x1
    43da:	0f6080e7          	jalr	246(ra) # 54cc <exit>
          printf("write failed %d\n", n);
    43de:	00003517          	auipc	a0,0x3
    43e2:	4aa50513          	addi	a0,a0,1194 # 7888 <l_free+0x1e22>
    43e6:	00001097          	auipc	ra,0x1
    43ea:	45e080e7          	jalr	1118(ra) # 5844 <printf>
          exit(1);
    43ee:	4505                	li	a0,1
    43f0:	00001097          	auipc	ra,0x1
    43f4:	0dc080e7          	jalr	220(ra) # 54cc <exit>
      exit(xstatus);
    43f8:	855a                	mv	a0,s6
    43fa:	00001097          	auipc	ra,0x1
    43fe:	0d2080e7          	jalr	210(ra) # 54cc <exit>
          printf("wrong char\n", s);
    4402:	f5843583          	ld	a1,-168(s0)
    4406:	00003517          	auipc	a0,0x3
    440a:	49a50513          	addi	a0,a0,1178 # 78a0 <l_free+0x1e3a>
    440e:	00001097          	auipc	ra,0x1
    4412:	436080e7          	jalr	1078(ra) # 5844 <printf>
          exit(1);
    4416:	4505                	li	a0,1
    4418:	00001097          	auipc	ra,0x1
    441c:	0b4080e7          	jalr	180(ra) # 54cc <exit>
      total += n;
    4420:	00a9093b          	addw	s2,s2,a0
    while ((n = read(fd, buf, sizeof(buf))) > 0) {
    4424:	660d                	lui	a2,0x3
    4426:	85d2                	mv	a1,s4
    4428:	854e                	mv	a0,s3
    442a:	00001097          	auipc	ra,0x1
    442e:	0ba080e7          	jalr	186(ra) # 54e4 <read>
    4432:	02a05363          	blez	a0,4458 <fourfiles+0x1ce>
    4436:	00007797          	auipc	a5,0x7
    443a:	58278793          	addi	a5,a5,1410 # b9b8 <buf>
    443e:	fff5069b          	addiw	a3,a0,-1
    4442:	1682                	slli	a3,a3,0x20
    4444:	9281                	srli	a3,a3,0x20
    4446:	96d6                	add	a3,a3,s5
        if (buf[j] != '0' + i) {
    4448:	0007c703          	lbu	a4,0(a5)
    444c:	fa971be3          	bne	a4,s1,4402 <fourfiles+0x178>
      for (j = 0; j < n; j++) {
    4450:	0785                	addi	a5,a5,1
    4452:	fed79be3          	bne	a5,a3,4448 <fourfiles+0x1be>
    4456:	b7e9                	j	4420 <fourfiles+0x196>
    close(fd);
    4458:	854e                	mv	a0,s3
    445a:	00001097          	auipc	ra,0x1
    445e:	09a080e7          	jalr	154(ra) # 54f4 <close>
    if (total != N * SZ) {
    4462:	03b91863          	bne	s2,s11,4492 <fourfiles+0x208>
    unlink(fname);
    4466:	8566                	mv	a0,s9
    4468:	00001097          	auipc	ra,0x1
    446c:	0b4080e7          	jalr	180(ra) # 551c <unlink>
  for (i = 0; i < NCHILD; i++) {
    4470:	0c21                	addi	s8,s8,8
    4472:	2b85                	addiw	s7,s7,1
    4474:	03ab8d63          	beq	s7,s10,44ae <fourfiles+0x224>
    fname = names[i];
    4478:	000c3c83          	ld	s9,0(s8)
    fd = open(fname, 0);
    447c:	4581                	li	a1,0
    447e:	8566                	mv	a0,s9
    4480:	00001097          	auipc	ra,0x1
    4484:	08c080e7          	jalr	140(ra) # 550c <open>
    4488:	89aa                	mv	s3,a0
    total = 0;
    448a:	895a                	mv	s2,s6
        if (buf[j] != '0' + i) {
    448c:	000b849b          	sext.w	s1,s7
    while ((n = read(fd, buf, sizeof(buf))) > 0) {
    4490:	bf51                	j	4424 <fourfiles+0x19a>
      printf("wrong length %d\n", total);
    4492:	85ca                	mv	a1,s2
    4494:	00003517          	auipc	a0,0x3
    4498:	41c50513          	addi	a0,a0,1052 # 78b0 <l_free+0x1e4a>
    449c:	00001097          	auipc	ra,0x1
    44a0:	3a8080e7          	jalr	936(ra) # 5844 <printf>
      exit(1);
    44a4:	4505                	li	a0,1
    44a6:	00001097          	auipc	ra,0x1
    44aa:	026080e7          	jalr	38(ra) # 54cc <exit>
}
    44ae:	70aa                	ld	ra,168(sp)
    44b0:	740a                	ld	s0,160(sp)
    44b2:	64ea                	ld	s1,152(sp)
    44b4:	694a                	ld	s2,144(sp)
    44b6:	69aa                	ld	s3,136(sp)
    44b8:	6a0a                	ld	s4,128(sp)
    44ba:	7ae6                	ld	s5,120(sp)
    44bc:	7b46                	ld	s6,112(sp)
    44be:	7ba6                	ld	s7,104(sp)
    44c0:	7c06                	ld	s8,96(sp)
    44c2:	6ce6                	ld	s9,88(sp)
    44c4:	6d46                	ld	s10,80(sp)
    44c6:	6da6                	ld	s11,72(sp)
    44c8:	614d                	addi	sp,sp,176
    44ca:	8082                	ret

00000000000044cc <concreate>:
void concreate(char *s) {
    44cc:	7135                	addi	sp,sp,-160
    44ce:	ed06                	sd	ra,152(sp)
    44d0:	e922                	sd	s0,144(sp)
    44d2:	e526                	sd	s1,136(sp)
    44d4:	e14a                	sd	s2,128(sp)
    44d6:	fcce                	sd	s3,120(sp)
    44d8:	f8d2                	sd	s4,112(sp)
    44da:	f4d6                	sd	s5,104(sp)
    44dc:	f0da                	sd	s6,96(sp)
    44de:	ecde                	sd	s7,88(sp)
    44e0:	1100                	addi	s0,sp,160
    44e2:	89aa                	mv	s3,a0
  file[0] = 'C';
    44e4:	04300793          	li	a5,67
    44e8:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    44ec:	fa040523          	sb	zero,-86(s0)
  for (i = 0; i < N; i++) {
    44f0:	4901                	li	s2,0
    if (pid && (i % 3) == 1) {
    44f2:	4b0d                	li	s6,3
    44f4:	4a85                	li	s5,1
      link("C0", file);
    44f6:	00003b97          	auipc	s7,0x3
    44fa:	3d2b8b93          	addi	s7,s7,978 # 78c8 <l_free+0x1e62>
  for (i = 0; i < N; i++) {
    44fe:	02800a13          	li	s4,40
    4502:	acc1                	j	47d2 <concreate+0x306>
      link("C0", file);
    4504:	fa840593          	addi	a1,s0,-88
    4508:	855e                	mv	a0,s7
    450a:	00001097          	auipc	ra,0x1
    450e:	022080e7          	jalr	34(ra) # 552c <link>
    if (pid == 0) {
    4512:	a45d                	j	47b8 <concreate+0x2ec>
    } else if (pid == 0 && (i % 5) == 1) {
    4514:	4795                	li	a5,5
    4516:	02f9693b          	remw	s2,s2,a5
    451a:	4785                	li	a5,1
    451c:	02f90b63          	beq	s2,a5,4552 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4520:	20200593          	li	a1,514
    4524:	fa840513          	addi	a0,s0,-88
    4528:	00001097          	auipc	ra,0x1
    452c:	fe4080e7          	jalr	-28(ra) # 550c <open>
      if (fd < 0) {
    4530:	26055b63          	bgez	a0,47a6 <concreate+0x2da>
        printf("concreate create %s failed\n", file);
    4534:	fa840593          	addi	a1,s0,-88
    4538:	00003517          	auipc	a0,0x3
    453c:	39850513          	addi	a0,a0,920 # 78d0 <l_free+0x1e6a>
    4540:	00001097          	auipc	ra,0x1
    4544:	304080e7          	jalr	772(ra) # 5844 <printf>
        exit(1);
    4548:	4505                	li	a0,1
    454a:	00001097          	auipc	ra,0x1
    454e:	f82080e7          	jalr	-126(ra) # 54cc <exit>
      link("C0", file);
    4552:	fa840593          	addi	a1,s0,-88
    4556:	00003517          	auipc	a0,0x3
    455a:	37250513          	addi	a0,a0,882 # 78c8 <l_free+0x1e62>
    455e:	00001097          	auipc	ra,0x1
    4562:	fce080e7          	jalr	-50(ra) # 552c <link>
      exit(0);
    4566:	4501                	li	a0,0
    4568:	00001097          	auipc	ra,0x1
    456c:	f64080e7          	jalr	-156(ra) # 54cc <exit>
        exit(1);
    4570:	4505                	li	a0,1
    4572:	00001097          	auipc	ra,0x1
    4576:	f5a080e7          	jalr	-166(ra) # 54cc <exit>
  memset(fa, 0, sizeof(fa));
    457a:	02800613          	li	a2,40
    457e:	4581                	li	a1,0
    4580:	f8040513          	addi	a0,s0,-128
    4584:	00001097          	auipc	ra,0x1
    4588:	d4c080e7          	jalr	-692(ra) # 52d0 <memset>
  fd = open(".", 0);
    458c:	4581                	li	a1,0
    458e:	00002517          	auipc	a0,0x2
    4592:	e0250513          	addi	a0,a0,-510 # 6390 <l_free+0x92a>
    4596:	00001097          	auipc	ra,0x1
    459a:	f76080e7          	jalr	-138(ra) # 550c <open>
    459e:	892a                	mv	s2,a0
  n = 0;
    45a0:	8aa6                	mv	s5,s1
    if (de.name[0] == 'C' && de.name[2] == '\0') {
    45a2:	04300a13          	li	s4,67
      if (i < 0 || i >= sizeof(fa)) {
    45a6:	02700b13          	li	s6,39
      fa[i] = 1;
    45aa:	4b85                	li	s7,1
  while (read(fd, &de, sizeof(de)) > 0) {
    45ac:	4641                	li	a2,16
    45ae:	f7040593          	addi	a1,s0,-144
    45b2:	854a                	mv	a0,s2
    45b4:	00001097          	auipc	ra,0x1
    45b8:	f30080e7          	jalr	-208(ra) # 54e4 <read>
    45bc:	08a05163          	blez	a0,463e <concreate+0x172>
    if (de.inum == 0)
    45c0:	f7045783          	lhu	a5,-144(s0)
    45c4:	d7e5                	beqz	a5,45ac <concreate+0xe0>
    if (de.name[0] == 'C' && de.name[2] == '\0') {
    45c6:	f7244783          	lbu	a5,-142(s0)
    45ca:	ff4791e3          	bne	a5,s4,45ac <concreate+0xe0>
    45ce:	f7444783          	lbu	a5,-140(s0)
    45d2:	ffe9                	bnez	a5,45ac <concreate+0xe0>
      i = de.name[1] - '0';
    45d4:	f7344783          	lbu	a5,-141(s0)
    45d8:	fd07879b          	addiw	a5,a5,-48
    45dc:	0007871b          	sext.w	a4,a5
      if (i < 0 || i >= sizeof(fa)) {
    45e0:	00eb6f63          	bltu	s6,a4,45fe <concreate+0x132>
      if (fa[i]) {
    45e4:	fb040793          	addi	a5,s0,-80
    45e8:	97ba                	add	a5,a5,a4
    45ea:	fd07c783          	lbu	a5,-48(a5)
    45ee:	eb85                	bnez	a5,461e <concreate+0x152>
      fa[i] = 1;
    45f0:	fb040793          	addi	a5,s0,-80
    45f4:	973e                	add	a4,a4,a5
    45f6:	fd770823          	sb	s7,-48(a4) # fd0 <bigdir+0x104>
      n++;
    45fa:	2a85                	addiw	s5,s5,1
    45fc:	bf45                	j	45ac <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    45fe:	f7240613          	addi	a2,s0,-142
    4602:	85ce                	mv	a1,s3
    4604:	00003517          	auipc	a0,0x3
    4608:	2ec50513          	addi	a0,a0,748 # 78f0 <l_free+0x1e8a>
    460c:	00001097          	auipc	ra,0x1
    4610:	238080e7          	jalr	568(ra) # 5844 <printf>
        exit(1);
    4614:	4505                	li	a0,1
    4616:	00001097          	auipc	ra,0x1
    461a:	eb6080e7          	jalr	-330(ra) # 54cc <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    461e:	f7240613          	addi	a2,s0,-142
    4622:	85ce                	mv	a1,s3
    4624:	00003517          	auipc	a0,0x3
    4628:	2ec50513          	addi	a0,a0,748 # 7910 <l_free+0x1eaa>
    462c:	00001097          	auipc	ra,0x1
    4630:	218080e7          	jalr	536(ra) # 5844 <printf>
        exit(1);
    4634:	4505                	li	a0,1
    4636:	00001097          	auipc	ra,0x1
    463a:	e96080e7          	jalr	-362(ra) # 54cc <exit>
  close(fd);
    463e:	854a                	mv	a0,s2
    4640:	00001097          	auipc	ra,0x1
    4644:	eb4080e7          	jalr	-332(ra) # 54f4 <close>
  if (n != N) {
    4648:	02800793          	li	a5,40
    464c:	00fa9763          	bne	s5,a5,465a <concreate+0x18e>
    if (((i % 3) == 0 && pid == 0) || ((i % 3) == 1 && pid != 0)) {
    4650:	4a8d                	li	s5,3
    4652:	4b05                	li	s6,1
  for (i = 0; i < N; i++) {
    4654:	02800a13          	li	s4,40
    4658:	a8c9                	j	472a <concreate+0x25e>
    printf("%s: concreate not enough files in directory listing\n", s);
    465a:	85ce                	mv	a1,s3
    465c:	00003517          	auipc	a0,0x3
    4660:	2dc50513          	addi	a0,a0,732 # 7938 <l_free+0x1ed2>
    4664:	00001097          	auipc	ra,0x1
    4668:	1e0080e7          	jalr	480(ra) # 5844 <printf>
    exit(1);
    466c:	4505                	li	a0,1
    466e:	00001097          	auipc	ra,0x1
    4672:	e5e080e7          	jalr	-418(ra) # 54cc <exit>
      printf("%s: fork failed\n", s);
    4676:	85ce                	mv	a1,s3
    4678:	00002517          	auipc	a0,0x2
    467c:	eb850513          	addi	a0,a0,-328 # 6530 <l_free+0xaca>
    4680:	00001097          	auipc	ra,0x1
    4684:	1c4080e7          	jalr	452(ra) # 5844 <printf>
      exit(1);
    4688:	4505                	li	a0,1
    468a:	00001097          	auipc	ra,0x1
    468e:	e42080e7          	jalr	-446(ra) # 54cc <exit>
      close(open(file, 0));
    4692:	4581                	li	a1,0
    4694:	fa840513          	addi	a0,s0,-88
    4698:	00001097          	auipc	ra,0x1
    469c:	e74080e7          	jalr	-396(ra) # 550c <open>
    46a0:	00001097          	auipc	ra,0x1
    46a4:	e54080e7          	jalr	-428(ra) # 54f4 <close>
      close(open(file, 0));
    46a8:	4581                	li	a1,0
    46aa:	fa840513          	addi	a0,s0,-88
    46ae:	00001097          	auipc	ra,0x1
    46b2:	e5e080e7          	jalr	-418(ra) # 550c <open>
    46b6:	00001097          	auipc	ra,0x1
    46ba:	e3e080e7          	jalr	-450(ra) # 54f4 <close>
      close(open(file, 0));
    46be:	4581                	li	a1,0
    46c0:	fa840513          	addi	a0,s0,-88
    46c4:	00001097          	auipc	ra,0x1
    46c8:	e48080e7          	jalr	-440(ra) # 550c <open>
    46cc:	00001097          	auipc	ra,0x1
    46d0:	e28080e7          	jalr	-472(ra) # 54f4 <close>
      close(open(file, 0));
    46d4:	4581                	li	a1,0
    46d6:	fa840513          	addi	a0,s0,-88
    46da:	00001097          	auipc	ra,0x1
    46de:	e32080e7          	jalr	-462(ra) # 550c <open>
    46e2:	00001097          	auipc	ra,0x1
    46e6:	e12080e7          	jalr	-494(ra) # 54f4 <close>
      close(open(file, 0));
    46ea:	4581                	li	a1,0
    46ec:	fa840513          	addi	a0,s0,-88
    46f0:	00001097          	auipc	ra,0x1
    46f4:	e1c080e7          	jalr	-484(ra) # 550c <open>
    46f8:	00001097          	auipc	ra,0x1
    46fc:	dfc080e7          	jalr	-516(ra) # 54f4 <close>
      close(open(file, 0));
    4700:	4581                	li	a1,0
    4702:	fa840513          	addi	a0,s0,-88
    4706:	00001097          	auipc	ra,0x1
    470a:	e06080e7          	jalr	-506(ra) # 550c <open>
    470e:	00001097          	auipc	ra,0x1
    4712:	de6080e7          	jalr	-538(ra) # 54f4 <close>
    if (pid == 0)
    4716:	08090363          	beqz	s2,479c <concreate+0x2d0>
      wait(0);
    471a:	4501                	li	a0,0
    471c:	00001097          	auipc	ra,0x1
    4720:	db8080e7          	jalr	-584(ra) # 54d4 <wait>
  for (i = 0; i < N; i++) {
    4724:	2485                	addiw	s1,s1,1
    4726:	0f448563          	beq	s1,s4,4810 <concreate+0x344>
    file[1] = '0' + i;
    472a:	0304879b          	addiw	a5,s1,48
    472e:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    4732:	00001097          	auipc	ra,0x1
    4736:	d92080e7          	jalr	-622(ra) # 54c4 <fork>
    473a:	892a                	mv	s2,a0
    if (pid < 0) {
    473c:	f2054de3          	bltz	a0,4676 <concreate+0x1aa>
    if (((i % 3) == 0 && pid == 0) || ((i % 3) == 1 && pid != 0)) {
    4740:	0354e73b          	remw	a4,s1,s5
    4744:	00a767b3          	or	a5,a4,a0
    4748:	2781                	sext.w	a5,a5
    474a:	d7a1                	beqz	a5,4692 <concreate+0x1c6>
    474c:	01671363          	bne	a4,s6,4752 <concreate+0x286>
    4750:	f129                	bnez	a0,4692 <concreate+0x1c6>
      unlink(file);
    4752:	fa840513          	addi	a0,s0,-88
    4756:	00001097          	auipc	ra,0x1
    475a:	dc6080e7          	jalr	-570(ra) # 551c <unlink>
      unlink(file);
    475e:	fa840513          	addi	a0,s0,-88
    4762:	00001097          	auipc	ra,0x1
    4766:	dba080e7          	jalr	-582(ra) # 551c <unlink>
      unlink(file);
    476a:	fa840513          	addi	a0,s0,-88
    476e:	00001097          	auipc	ra,0x1
    4772:	dae080e7          	jalr	-594(ra) # 551c <unlink>
      unlink(file);
    4776:	fa840513          	addi	a0,s0,-88
    477a:	00001097          	auipc	ra,0x1
    477e:	da2080e7          	jalr	-606(ra) # 551c <unlink>
      unlink(file);
    4782:	fa840513          	addi	a0,s0,-88
    4786:	00001097          	auipc	ra,0x1
    478a:	d96080e7          	jalr	-618(ra) # 551c <unlink>
      unlink(file);
    478e:	fa840513          	addi	a0,s0,-88
    4792:	00001097          	auipc	ra,0x1
    4796:	d8a080e7          	jalr	-630(ra) # 551c <unlink>
    479a:	bfb5                	j	4716 <concreate+0x24a>
      exit(0);
    479c:	4501                	li	a0,0
    479e:	00001097          	auipc	ra,0x1
    47a2:	d2e080e7          	jalr	-722(ra) # 54cc <exit>
      close(fd);
    47a6:	00001097          	auipc	ra,0x1
    47aa:	d4e080e7          	jalr	-690(ra) # 54f4 <close>
    if (pid == 0) {
    47ae:	bb65                	j	4566 <concreate+0x9a>
      close(fd);
    47b0:	00001097          	auipc	ra,0x1
    47b4:	d44080e7          	jalr	-700(ra) # 54f4 <close>
      wait(&xstatus);
    47b8:	f6c40513          	addi	a0,s0,-148
    47bc:	00001097          	auipc	ra,0x1
    47c0:	d18080e7          	jalr	-744(ra) # 54d4 <wait>
      if (xstatus != 0)
    47c4:	f6c42483          	lw	s1,-148(s0)
    47c8:	da0494e3          	bnez	s1,4570 <concreate+0xa4>
  for (i = 0; i < N; i++) {
    47cc:	2905                	addiw	s2,s2,1
    47ce:	db4906e3          	beq	s2,s4,457a <concreate+0xae>
    file[1] = '0' + i;
    47d2:	0309079b          	addiw	a5,s2,48
    47d6:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    47da:	fa840513          	addi	a0,s0,-88
    47de:	00001097          	auipc	ra,0x1
    47e2:	d3e080e7          	jalr	-706(ra) # 551c <unlink>
    pid = fork();
    47e6:	00001097          	auipc	ra,0x1
    47ea:	cde080e7          	jalr	-802(ra) # 54c4 <fork>
    if (pid && (i % 3) == 1) {
    47ee:	d20503e3          	beqz	a0,4514 <concreate+0x48>
    47f2:	036967bb          	remw	a5,s2,s6
    47f6:	d15787e3          	beq	a5,s5,4504 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    47fa:	20200593          	li	a1,514
    47fe:	fa840513          	addi	a0,s0,-88
    4802:	00001097          	auipc	ra,0x1
    4806:	d0a080e7          	jalr	-758(ra) # 550c <open>
      if (fd < 0) {
    480a:	fa0553e3          	bgez	a0,47b0 <concreate+0x2e4>
    480e:	b31d                	j	4534 <concreate+0x68>
}
    4810:	60ea                	ld	ra,152(sp)
    4812:	644a                	ld	s0,144(sp)
    4814:	64aa                	ld	s1,136(sp)
    4816:	690a                	ld	s2,128(sp)
    4818:	79e6                	ld	s3,120(sp)
    481a:	7a46                	ld	s4,112(sp)
    481c:	7aa6                	ld	s5,104(sp)
    481e:	7b06                	ld	s6,96(sp)
    4820:	6be6                	ld	s7,88(sp)
    4822:	610d                	addi	sp,sp,160
    4824:	8082                	ret

0000000000004826 <bigfile>:
void bigfile(char *s) {
    4826:	7139                	addi	sp,sp,-64
    4828:	fc06                	sd	ra,56(sp)
    482a:	f822                	sd	s0,48(sp)
    482c:	f426                	sd	s1,40(sp)
    482e:	f04a                	sd	s2,32(sp)
    4830:	ec4e                	sd	s3,24(sp)
    4832:	e852                	sd	s4,16(sp)
    4834:	e456                	sd	s5,8(sp)
    4836:	0080                	addi	s0,sp,64
    4838:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    483a:	00003517          	auipc	a0,0x3
    483e:	13650513          	addi	a0,a0,310 # 7970 <l_free+0x1f0a>
    4842:	00001097          	auipc	ra,0x1
    4846:	cda080e7          	jalr	-806(ra) # 551c <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    484a:	20200593          	li	a1,514
    484e:	00003517          	auipc	a0,0x3
    4852:	12250513          	addi	a0,a0,290 # 7970 <l_free+0x1f0a>
    4856:	00001097          	auipc	ra,0x1
    485a:	cb6080e7          	jalr	-842(ra) # 550c <open>
    485e:	89aa                	mv	s3,a0
  for (i = 0; i < N; i++) {
    4860:	4481                	li	s1,0
    memset(buf, i, SZ);
    4862:	00007917          	auipc	s2,0x7
    4866:	15690913          	addi	s2,s2,342 # b9b8 <buf>
  for (i = 0; i < N; i++) {
    486a:	4a51                	li	s4,20
  if (fd < 0) {
    486c:	0a054063          	bltz	a0,490c <bigfile+0xe6>
    memset(buf, i, SZ);
    4870:	25800613          	li	a2,600
    4874:	85a6                	mv	a1,s1
    4876:	854a                	mv	a0,s2
    4878:	00001097          	auipc	ra,0x1
    487c:	a58080e7          	jalr	-1448(ra) # 52d0 <memset>
    if (write(fd, buf, SZ) != SZ) {
    4880:	25800613          	li	a2,600
    4884:	85ca                	mv	a1,s2
    4886:	854e                	mv	a0,s3
    4888:	00001097          	auipc	ra,0x1
    488c:	c64080e7          	jalr	-924(ra) # 54ec <write>
    4890:	25800793          	li	a5,600
    4894:	08f51a63          	bne	a0,a5,4928 <bigfile+0x102>
  for (i = 0; i < N; i++) {
    4898:	2485                	addiw	s1,s1,1
    489a:	fd449be3          	bne	s1,s4,4870 <bigfile+0x4a>
  close(fd);
    489e:	854e                	mv	a0,s3
    48a0:	00001097          	auipc	ra,0x1
    48a4:	c54080e7          	jalr	-940(ra) # 54f4 <close>
  fd = open("bigfile.dat", 0);
    48a8:	4581                	li	a1,0
    48aa:	00003517          	auipc	a0,0x3
    48ae:	0c650513          	addi	a0,a0,198 # 7970 <l_free+0x1f0a>
    48b2:	00001097          	auipc	ra,0x1
    48b6:	c5a080e7          	jalr	-934(ra) # 550c <open>
    48ba:	8a2a                	mv	s4,a0
  total = 0;
    48bc:	4981                	li	s3,0
  for (i = 0;; i++) {
    48be:	4481                	li	s1,0
    cc = read(fd, buf, SZ / 2);
    48c0:	00007917          	auipc	s2,0x7
    48c4:	0f890913          	addi	s2,s2,248 # b9b8 <buf>
  if (fd < 0) {
    48c8:	06054e63          	bltz	a0,4944 <bigfile+0x11e>
    cc = read(fd, buf, SZ / 2);
    48cc:	12c00613          	li	a2,300
    48d0:	85ca                	mv	a1,s2
    48d2:	8552                	mv	a0,s4
    48d4:	00001097          	auipc	ra,0x1
    48d8:	c10080e7          	jalr	-1008(ra) # 54e4 <read>
    if (cc < 0) {
    48dc:	08054263          	bltz	a0,4960 <bigfile+0x13a>
    if (cc == 0)
    48e0:	c971                	beqz	a0,49b4 <bigfile+0x18e>
    if (cc != SZ / 2) {
    48e2:	12c00793          	li	a5,300
    48e6:	08f51b63          	bne	a0,a5,497c <bigfile+0x156>
    if (buf[0] != i / 2 || buf[SZ / 2 - 1] != i / 2) {
    48ea:	01f4d79b          	srliw	a5,s1,0x1f
    48ee:	9fa5                	addw	a5,a5,s1
    48f0:	4017d79b          	sraiw	a5,a5,0x1
    48f4:	00094703          	lbu	a4,0(s2)
    48f8:	0af71063          	bne	a4,a5,4998 <bigfile+0x172>
    48fc:	12b94703          	lbu	a4,299(s2)
    4900:	08f71c63          	bne	a4,a5,4998 <bigfile+0x172>
    total += cc;
    4904:	12c9899b          	addiw	s3,s3,300
  for (i = 0;; i++) {
    4908:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ / 2);
    490a:	b7c9                	j	48cc <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    490c:	85d6                	mv	a1,s5
    490e:	00003517          	auipc	a0,0x3
    4912:	07250513          	addi	a0,a0,114 # 7980 <l_free+0x1f1a>
    4916:	00001097          	auipc	ra,0x1
    491a:	f2e080e7          	jalr	-210(ra) # 5844 <printf>
    exit(1);
    491e:	4505                	li	a0,1
    4920:	00001097          	auipc	ra,0x1
    4924:	bac080e7          	jalr	-1108(ra) # 54cc <exit>
      printf("%s: write bigfile failed\n", s);
    4928:	85d6                	mv	a1,s5
    492a:	00003517          	auipc	a0,0x3
    492e:	07650513          	addi	a0,a0,118 # 79a0 <l_free+0x1f3a>
    4932:	00001097          	auipc	ra,0x1
    4936:	f12080e7          	jalr	-238(ra) # 5844 <printf>
      exit(1);
    493a:	4505                	li	a0,1
    493c:	00001097          	auipc	ra,0x1
    4940:	b90080e7          	jalr	-1136(ra) # 54cc <exit>
    printf("%s: cannot open bigfile\n", s);
    4944:	85d6                	mv	a1,s5
    4946:	00003517          	auipc	a0,0x3
    494a:	07a50513          	addi	a0,a0,122 # 79c0 <l_free+0x1f5a>
    494e:	00001097          	auipc	ra,0x1
    4952:	ef6080e7          	jalr	-266(ra) # 5844 <printf>
    exit(1);
    4956:	4505                	li	a0,1
    4958:	00001097          	auipc	ra,0x1
    495c:	b74080e7          	jalr	-1164(ra) # 54cc <exit>
      printf("%s: read bigfile failed\n", s);
    4960:	85d6                	mv	a1,s5
    4962:	00003517          	auipc	a0,0x3
    4966:	07e50513          	addi	a0,a0,126 # 79e0 <l_free+0x1f7a>
    496a:	00001097          	auipc	ra,0x1
    496e:	eda080e7          	jalr	-294(ra) # 5844 <printf>
      exit(1);
    4972:	4505                	li	a0,1
    4974:	00001097          	auipc	ra,0x1
    4978:	b58080e7          	jalr	-1192(ra) # 54cc <exit>
      printf("%s: short read bigfile\n", s);
    497c:	85d6                	mv	a1,s5
    497e:	00003517          	auipc	a0,0x3
    4982:	08250513          	addi	a0,a0,130 # 7a00 <l_free+0x1f9a>
    4986:	00001097          	auipc	ra,0x1
    498a:	ebe080e7          	jalr	-322(ra) # 5844 <printf>
      exit(1);
    498e:	4505                	li	a0,1
    4990:	00001097          	auipc	ra,0x1
    4994:	b3c080e7          	jalr	-1220(ra) # 54cc <exit>
      printf("%s: read bigfile wrong data\n", s);
    4998:	85d6                	mv	a1,s5
    499a:	00003517          	auipc	a0,0x3
    499e:	07e50513          	addi	a0,a0,126 # 7a18 <l_free+0x1fb2>
    49a2:	00001097          	auipc	ra,0x1
    49a6:	ea2080e7          	jalr	-350(ra) # 5844 <printf>
      exit(1);
    49aa:	4505                	li	a0,1
    49ac:	00001097          	auipc	ra,0x1
    49b0:	b20080e7          	jalr	-1248(ra) # 54cc <exit>
  close(fd);
    49b4:	8552                	mv	a0,s4
    49b6:	00001097          	auipc	ra,0x1
    49ba:	b3e080e7          	jalr	-1218(ra) # 54f4 <close>
  if (total != N * SZ) {
    49be:	678d                	lui	a5,0x3
    49c0:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x2ce>
    49c4:	02f99363          	bne	s3,a5,49ea <bigfile+0x1c4>
  unlink("bigfile.dat");
    49c8:	00003517          	auipc	a0,0x3
    49cc:	fa850513          	addi	a0,a0,-88 # 7970 <l_free+0x1f0a>
    49d0:	00001097          	auipc	ra,0x1
    49d4:	b4c080e7          	jalr	-1204(ra) # 551c <unlink>
}
    49d8:	70e2                	ld	ra,56(sp)
    49da:	7442                	ld	s0,48(sp)
    49dc:	74a2                	ld	s1,40(sp)
    49de:	7902                	ld	s2,32(sp)
    49e0:	69e2                	ld	s3,24(sp)
    49e2:	6a42                	ld	s4,16(sp)
    49e4:	6aa2                	ld	s5,8(sp)
    49e6:	6121                	addi	sp,sp,64
    49e8:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    49ea:	85d6                	mv	a1,s5
    49ec:	00003517          	auipc	a0,0x3
    49f0:	04c50513          	addi	a0,a0,76 # 7a38 <l_free+0x1fd2>
    49f4:	00001097          	auipc	ra,0x1
    49f8:	e50080e7          	jalr	-432(ra) # 5844 <printf>
    exit(1);
    49fc:	4505                	li	a0,1
    49fe:	00001097          	auipc	ra,0x1
    4a02:	ace080e7          	jalr	-1330(ra) # 54cc <exit>

0000000000004a06 <writebig>:
void writebig(char *s) {
    4a06:	7139                	addi	sp,sp,-64
    4a08:	fc06                	sd	ra,56(sp)
    4a0a:	f822                	sd	s0,48(sp)
    4a0c:	f426                	sd	s1,40(sp)
    4a0e:	f04a                	sd	s2,32(sp)
    4a10:	ec4e                	sd	s3,24(sp)
    4a12:	e852                	sd	s4,16(sp)
    4a14:	e456                	sd	s5,8(sp)
    4a16:	0080                	addi	s0,sp,64
    4a18:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE | O_RDWR);
    4a1a:	20200593          	li	a1,514
    4a1e:	00003517          	auipc	a0,0x3
    4a22:	03a50513          	addi	a0,a0,58 # 7a58 <l_free+0x1ff2>
    4a26:	00001097          	auipc	ra,0x1
    4a2a:	ae6080e7          	jalr	-1306(ra) # 550c <open>
    4a2e:	89aa                	mv	s3,a0
  for (i = 0; i < MAXFILE; i++) {
    4a30:	4481                	li	s1,0
    ((int *)buf)[0] = i;
    4a32:	00007917          	auipc	s2,0x7
    4a36:	f8690913          	addi	s2,s2,-122 # b9b8 <buf>
  for (i = 0; i < MAXFILE; i++) {
    4a3a:	10c00a13          	li	s4,268
  if (fd < 0) {
    4a3e:	06054c63          	bltz	a0,4ab6 <writebig+0xb0>
    ((int *)buf)[0] = i;
    4a42:	00992023          	sw	s1,0(s2)
    if (write(fd, buf, BSIZE) != BSIZE) {
    4a46:	40000613          	li	a2,1024
    4a4a:	85ca                	mv	a1,s2
    4a4c:	854e                	mv	a0,s3
    4a4e:	00001097          	auipc	ra,0x1
    4a52:	a9e080e7          	jalr	-1378(ra) # 54ec <write>
    4a56:	40000793          	li	a5,1024
    4a5a:	06f51c63          	bne	a0,a5,4ad2 <writebig+0xcc>
  for (i = 0; i < MAXFILE; i++) {
    4a5e:	2485                	addiw	s1,s1,1
    4a60:	ff4491e3          	bne	s1,s4,4a42 <writebig+0x3c>
  close(fd);
    4a64:	854e                	mv	a0,s3
    4a66:	00001097          	auipc	ra,0x1
    4a6a:	a8e080e7          	jalr	-1394(ra) # 54f4 <close>
  fd = open("big", O_RDONLY);
    4a6e:	4581                	li	a1,0
    4a70:	00003517          	auipc	a0,0x3
    4a74:	fe850513          	addi	a0,a0,-24 # 7a58 <l_free+0x1ff2>
    4a78:	00001097          	auipc	ra,0x1
    4a7c:	a94080e7          	jalr	-1388(ra) # 550c <open>
    4a80:	89aa                	mv	s3,a0
  n = 0;
    4a82:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
    4a84:	00007917          	auipc	s2,0x7
    4a88:	f3490913          	addi	s2,s2,-204 # b9b8 <buf>
  if (fd < 0) {
    4a8c:	06054163          	bltz	a0,4aee <writebig+0xe8>
    i = read(fd, buf, BSIZE);
    4a90:	40000613          	li	a2,1024
    4a94:	85ca                	mv	a1,s2
    4a96:	854e                	mv	a0,s3
    4a98:	00001097          	auipc	ra,0x1
    4a9c:	a4c080e7          	jalr	-1460(ra) # 54e4 <read>
    if (i == 0) {
    4aa0:	c52d                	beqz	a0,4b0a <writebig+0x104>
    } else if (i != BSIZE) {
    4aa2:	40000793          	li	a5,1024
    4aa6:	0af51d63          	bne	a0,a5,4b60 <writebig+0x15a>
    if (((int *)buf)[0] != n) {
    4aaa:	00092603          	lw	a2,0(s2)
    4aae:	0c961763          	bne	a2,s1,4b7c <writebig+0x176>
    n++;
    4ab2:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
    4ab4:	bff1                	j	4a90 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
    4ab6:	85d6                	mv	a1,s5
    4ab8:	00003517          	auipc	a0,0x3
    4abc:	fa850513          	addi	a0,a0,-88 # 7a60 <l_free+0x1ffa>
    4ac0:	00001097          	auipc	ra,0x1
    4ac4:	d84080e7          	jalr	-636(ra) # 5844 <printf>
    exit(1);
    4ac8:	4505                	li	a0,1
    4aca:	00001097          	auipc	ra,0x1
    4ace:	a02080e7          	jalr	-1534(ra) # 54cc <exit>
      printf("%s: error: write big file failed\n", i);
    4ad2:	85a6                	mv	a1,s1
    4ad4:	00003517          	auipc	a0,0x3
    4ad8:	fac50513          	addi	a0,a0,-84 # 7a80 <l_free+0x201a>
    4adc:	00001097          	auipc	ra,0x1
    4ae0:	d68080e7          	jalr	-664(ra) # 5844 <printf>
      exit(1);
    4ae4:	4505                	li	a0,1
    4ae6:	00001097          	auipc	ra,0x1
    4aea:	9e6080e7          	jalr	-1562(ra) # 54cc <exit>
    printf("%s: error: open big failed!\n", s);
    4aee:	85d6                	mv	a1,s5
    4af0:	00003517          	auipc	a0,0x3
    4af4:	fb850513          	addi	a0,a0,-72 # 7aa8 <l_free+0x2042>
    4af8:	00001097          	auipc	ra,0x1
    4afc:	d4c080e7          	jalr	-692(ra) # 5844 <printf>
    exit(1);
    4b00:	4505                	li	a0,1
    4b02:	00001097          	auipc	ra,0x1
    4b06:	9ca080e7          	jalr	-1590(ra) # 54cc <exit>
      if (n == MAXFILE - 1) {
    4b0a:	10b00793          	li	a5,267
    4b0e:	02f48a63          	beq	s1,a5,4b42 <writebig+0x13c>
  close(fd);
    4b12:	854e                	mv	a0,s3
    4b14:	00001097          	auipc	ra,0x1
    4b18:	9e0080e7          	jalr	-1568(ra) # 54f4 <close>
  if (unlink("big") < 0) {
    4b1c:	00003517          	auipc	a0,0x3
    4b20:	f3c50513          	addi	a0,a0,-196 # 7a58 <l_free+0x1ff2>
    4b24:	00001097          	auipc	ra,0x1
    4b28:	9f8080e7          	jalr	-1544(ra) # 551c <unlink>
    4b2c:	06054663          	bltz	a0,4b98 <writebig+0x192>
}
    4b30:	70e2                	ld	ra,56(sp)
    4b32:	7442                	ld	s0,48(sp)
    4b34:	74a2                	ld	s1,40(sp)
    4b36:	7902                	ld	s2,32(sp)
    4b38:	69e2                	ld	s3,24(sp)
    4b3a:	6a42                	ld	s4,16(sp)
    4b3c:	6aa2                	ld	s5,8(sp)
    4b3e:	6121                	addi	sp,sp,64
    4b40:	8082                	ret
        printf("%s: read only %d blocks from big", n);
    4b42:	10b00593          	li	a1,267
    4b46:	00003517          	auipc	a0,0x3
    4b4a:	f8250513          	addi	a0,a0,-126 # 7ac8 <l_free+0x2062>
    4b4e:	00001097          	auipc	ra,0x1
    4b52:	cf6080e7          	jalr	-778(ra) # 5844 <printf>
        exit(1);
    4b56:	4505                	li	a0,1
    4b58:	00001097          	auipc	ra,0x1
    4b5c:	974080e7          	jalr	-1676(ra) # 54cc <exit>
      printf("%s: read failed %d\n", i);
    4b60:	85aa                	mv	a1,a0
    4b62:	00003517          	auipc	a0,0x3
    4b66:	f8e50513          	addi	a0,a0,-114 # 7af0 <l_free+0x208a>
    4b6a:	00001097          	auipc	ra,0x1
    4b6e:	cda080e7          	jalr	-806(ra) # 5844 <printf>
      exit(1);
    4b72:	4505                	li	a0,1
    4b74:	00001097          	auipc	ra,0x1
    4b78:	958080e7          	jalr	-1704(ra) # 54cc <exit>
      printf("%s: read content of block %d is %d\n", n, ((int *)buf)[0]);
    4b7c:	85a6                	mv	a1,s1
    4b7e:	00003517          	auipc	a0,0x3
    4b82:	f8a50513          	addi	a0,a0,-118 # 7b08 <l_free+0x20a2>
    4b86:	00001097          	auipc	ra,0x1
    4b8a:	cbe080e7          	jalr	-834(ra) # 5844 <printf>
      exit(1);
    4b8e:	4505                	li	a0,1
    4b90:	00001097          	auipc	ra,0x1
    4b94:	93c080e7          	jalr	-1732(ra) # 54cc <exit>
    printf("%s: unlink big failed\n", s);
    4b98:	85d6                	mv	a1,s5
    4b9a:	00003517          	auipc	a0,0x3
    4b9e:	f9650513          	addi	a0,a0,-106 # 7b30 <l_free+0x20ca>
    4ba2:	00001097          	auipc	ra,0x1
    4ba6:	ca2080e7          	jalr	-862(ra) # 5844 <printf>
    exit(1);
    4baa:	4505                	li	a0,1
    4bac:	00001097          	auipc	ra,0x1
    4bb0:	920080e7          	jalr	-1760(ra) # 54cc <exit>

0000000000004bb4 <dirtest>:
void dirtest(char *s) {
    4bb4:	1101                	addi	sp,sp,-32
    4bb6:	ec06                	sd	ra,24(sp)
    4bb8:	e822                	sd	s0,16(sp)
    4bba:	e426                	sd	s1,8(sp)
    4bbc:	1000                	addi	s0,sp,32
    4bbe:	84aa                	mv	s1,a0
  printf("mkdir test\n");
    4bc0:	00003517          	auipc	a0,0x3
    4bc4:	f8850513          	addi	a0,a0,-120 # 7b48 <l_free+0x20e2>
    4bc8:	00001097          	auipc	ra,0x1
    4bcc:	c7c080e7          	jalr	-900(ra) # 5844 <printf>
  if (mkdir("dir0") < 0) {
    4bd0:	00003517          	auipc	a0,0x3
    4bd4:	f8850513          	addi	a0,a0,-120 # 7b58 <l_free+0x20f2>
    4bd8:	00001097          	auipc	ra,0x1
    4bdc:	95c080e7          	jalr	-1700(ra) # 5534 <mkdir>
    4be0:	04054d63          	bltz	a0,4c3a <dirtest+0x86>
  if (chdir("dir0") < 0) {
    4be4:	00003517          	auipc	a0,0x3
    4be8:	f7450513          	addi	a0,a0,-140 # 7b58 <l_free+0x20f2>
    4bec:	00001097          	auipc	ra,0x1
    4bf0:	950080e7          	jalr	-1712(ra) # 553c <chdir>
    4bf4:	06054163          	bltz	a0,4c56 <dirtest+0xa2>
  if (chdir("..") < 0) {
    4bf8:	00003517          	auipc	a0,0x3
    4bfc:	82850513          	addi	a0,a0,-2008 # 7420 <l_free+0x19ba>
    4c00:	00001097          	auipc	ra,0x1
    4c04:	93c080e7          	jalr	-1732(ra) # 553c <chdir>
    4c08:	06054563          	bltz	a0,4c72 <dirtest+0xbe>
  if (unlink("dir0") < 0) {
    4c0c:	00003517          	auipc	a0,0x3
    4c10:	f4c50513          	addi	a0,a0,-180 # 7b58 <l_free+0x20f2>
    4c14:	00001097          	auipc	ra,0x1
    4c18:	908080e7          	jalr	-1784(ra) # 551c <unlink>
    4c1c:	06054963          	bltz	a0,4c8e <dirtest+0xda>
  printf("%s: mkdir test ok\n");
    4c20:	00003517          	auipc	a0,0x3
    4c24:	f8850513          	addi	a0,a0,-120 # 7ba8 <l_free+0x2142>
    4c28:	00001097          	auipc	ra,0x1
    4c2c:	c1c080e7          	jalr	-996(ra) # 5844 <printf>
}
    4c30:	60e2                	ld	ra,24(sp)
    4c32:	6442                	ld	s0,16(sp)
    4c34:	64a2                	ld	s1,8(sp)
    4c36:	6105                	addi	sp,sp,32
    4c38:	8082                	ret
    printf("%s: mkdir failed\n", s);
    4c3a:	85a6                	mv	a1,s1
    4c3c:	00002517          	auipc	a0,0x2
    4c40:	18450513          	addi	a0,a0,388 # 6dc0 <l_free+0x135a>
    4c44:	00001097          	auipc	ra,0x1
    4c48:	c00080e7          	jalr	-1024(ra) # 5844 <printf>
    exit(1);
    4c4c:	4505                	li	a0,1
    4c4e:	00001097          	auipc	ra,0x1
    4c52:	87e080e7          	jalr	-1922(ra) # 54cc <exit>
    printf("%s: chdir dir0 failed\n", s);
    4c56:	85a6                	mv	a1,s1
    4c58:	00003517          	auipc	a0,0x3
    4c5c:	f0850513          	addi	a0,a0,-248 # 7b60 <l_free+0x20fa>
    4c60:	00001097          	auipc	ra,0x1
    4c64:	be4080e7          	jalr	-1052(ra) # 5844 <printf>
    exit(1);
    4c68:	4505                	li	a0,1
    4c6a:	00001097          	auipc	ra,0x1
    4c6e:	862080e7          	jalr	-1950(ra) # 54cc <exit>
    printf("%s: chdir .. failed\n", s);
    4c72:	85a6                	mv	a1,s1
    4c74:	00003517          	auipc	a0,0x3
    4c78:	f0450513          	addi	a0,a0,-252 # 7b78 <l_free+0x2112>
    4c7c:	00001097          	auipc	ra,0x1
    4c80:	bc8080e7          	jalr	-1080(ra) # 5844 <printf>
    exit(1);
    4c84:	4505                	li	a0,1
    4c86:	00001097          	auipc	ra,0x1
    4c8a:	846080e7          	jalr	-1978(ra) # 54cc <exit>
    printf("%s: unlink dir0 failed\n", s);
    4c8e:	85a6                	mv	a1,s1
    4c90:	00003517          	auipc	a0,0x3
    4c94:	f0050513          	addi	a0,a0,-256 # 7b90 <l_free+0x212a>
    4c98:	00001097          	auipc	ra,0x1
    4c9c:	bac080e7          	jalr	-1108(ra) # 5844 <printf>
    exit(1);
    4ca0:	4505                	li	a0,1
    4ca2:	00001097          	auipc	ra,0x1
    4ca6:	82a080e7          	jalr	-2006(ra) # 54cc <exit>

0000000000004caa <fsfull>:
void fsfull() {
    4caa:	7171                	addi	sp,sp,-176
    4cac:	f506                	sd	ra,168(sp)
    4cae:	f122                	sd	s0,160(sp)
    4cb0:	ed26                	sd	s1,152(sp)
    4cb2:	e94a                	sd	s2,144(sp)
    4cb4:	e54e                	sd	s3,136(sp)
    4cb6:	e152                	sd	s4,128(sp)
    4cb8:	fcd6                	sd	s5,120(sp)
    4cba:	f8da                	sd	s6,112(sp)
    4cbc:	f4de                	sd	s7,104(sp)
    4cbe:	f0e2                	sd	s8,96(sp)
    4cc0:	ece6                	sd	s9,88(sp)
    4cc2:	e8ea                	sd	s10,80(sp)
    4cc4:	e4ee                	sd	s11,72(sp)
    4cc6:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4cc8:	00003517          	auipc	a0,0x3
    4ccc:	ef850513          	addi	a0,a0,-264 # 7bc0 <l_free+0x215a>
    4cd0:	00001097          	auipc	ra,0x1
    4cd4:	b74080e7          	jalr	-1164(ra) # 5844 <printf>
  for (nfiles = 0;; nfiles++) {
    4cd8:	4481                	li	s1,0
    name[0] = 'f';
    4cda:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4cde:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4ce2:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4ce6:	4b29                	li	s6,10
    printf("%s: writing %s\n", name);
    4ce8:	00003c97          	auipc	s9,0x3
    4cec:	ee8c8c93          	addi	s9,s9,-280 # 7bd0 <l_free+0x216a>
    int total = 0;
    4cf0:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    4cf2:	00007a17          	auipc	s4,0x7
    4cf6:	cc6a0a13          	addi	s4,s4,-826 # b9b8 <buf>
    name[0] = 'f';
    4cfa:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4cfe:	0384c7bb          	divw	a5,s1,s8
    4d02:	0307879b          	addiw	a5,a5,48
    4d06:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4d0a:	0384e7bb          	remw	a5,s1,s8
    4d0e:	0377c7bb          	divw	a5,a5,s7
    4d12:	0307879b          	addiw	a5,a5,48
    4d16:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4d1a:	0374e7bb          	remw	a5,s1,s7
    4d1e:	0367c7bb          	divw	a5,a5,s6
    4d22:	0307879b          	addiw	a5,a5,48
    4d26:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4d2a:	0364e7bb          	remw	a5,s1,s6
    4d2e:	0307879b          	addiw	a5,a5,48
    4d32:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4d36:	f4040aa3          	sb	zero,-171(s0)
    printf("%s: writing %s\n", name);
    4d3a:	f5040593          	addi	a1,s0,-176
    4d3e:	8566                	mv	a0,s9
    4d40:	00001097          	auipc	ra,0x1
    4d44:	b04080e7          	jalr	-1276(ra) # 5844 <printf>
    int fd = open(name, O_CREATE | O_RDWR);
    4d48:	20200593          	li	a1,514
    4d4c:	f5040513          	addi	a0,s0,-176
    4d50:	00000097          	auipc	ra,0x0
    4d54:	7bc080e7          	jalr	1980(ra) # 550c <open>
    4d58:	892a                	mv	s2,a0
    if (fd < 0) {
    4d5a:	0a055663          	bgez	a0,4e06 <fsfull+0x15c>
      printf("%s: open %s failed\n", name);
    4d5e:	f5040593          	addi	a1,s0,-176
    4d62:	00003517          	auipc	a0,0x3
    4d66:	e7e50513          	addi	a0,a0,-386 # 7be0 <l_free+0x217a>
    4d6a:	00001097          	auipc	ra,0x1
    4d6e:	ada080e7          	jalr	-1318(ra) # 5844 <printf>
  while (nfiles >= 0) {
    4d72:	0604c363          	bltz	s1,4dd8 <fsfull+0x12e>
    name[0] = 'f';
    4d76:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4d7a:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4d7e:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    4d82:	4929                	li	s2,10
  while (nfiles >= 0) {
    4d84:	5afd                	li	s5,-1
    name[0] = 'f';
    4d86:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4d8a:	0344c7bb          	divw	a5,s1,s4
    4d8e:	0307879b          	addiw	a5,a5,48
    4d92:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4d96:	0344e7bb          	remw	a5,s1,s4
    4d9a:	0337c7bb          	divw	a5,a5,s3
    4d9e:	0307879b          	addiw	a5,a5,48
    4da2:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4da6:	0334e7bb          	remw	a5,s1,s3
    4daa:	0327c7bb          	divw	a5,a5,s2
    4dae:	0307879b          	addiw	a5,a5,48
    4db2:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4db6:	0324e7bb          	remw	a5,s1,s2
    4dba:	0307879b          	addiw	a5,a5,48
    4dbe:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4dc2:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    4dc6:	f5040513          	addi	a0,s0,-176
    4dca:	00000097          	auipc	ra,0x0
    4dce:	752080e7          	jalr	1874(ra) # 551c <unlink>
    nfiles--;
    4dd2:	34fd                	addiw	s1,s1,-1
  while (nfiles >= 0) {
    4dd4:	fb5499e3          	bne	s1,s5,4d86 <fsfull+0xdc>
  printf("fsfull test finished\n");
    4dd8:	00003517          	auipc	a0,0x3
    4ddc:	e3850513          	addi	a0,a0,-456 # 7c10 <l_free+0x21aa>
    4de0:	00001097          	auipc	ra,0x1
    4de4:	a64080e7          	jalr	-1436(ra) # 5844 <printf>
}
    4de8:	70aa                	ld	ra,168(sp)
    4dea:	740a                	ld	s0,160(sp)
    4dec:	64ea                	ld	s1,152(sp)
    4dee:	694a                	ld	s2,144(sp)
    4df0:	69aa                	ld	s3,136(sp)
    4df2:	6a0a                	ld	s4,128(sp)
    4df4:	7ae6                	ld	s5,120(sp)
    4df6:	7b46                	ld	s6,112(sp)
    4df8:	7ba6                	ld	s7,104(sp)
    4dfa:	7c06                	ld	s8,96(sp)
    4dfc:	6ce6                	ld	s9,88(sp)
    4dfe:	6d46                	ld	s10,80(sp)
    4e00:	6da6                	ld	s11,72(sp)
    4e02:	614d                	addi	sp,sp,176
    4e04:	8082                	ret
    int total = 0;
    4e06:	89ee                	mv	s3,s11
      if (cc < BSIZE)
    4e08:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    4e0c:	40000613          	li	a2,1024
    4e10:	85d2                	mv	a1,s4
    4e12:	854a                	mv	a0,s2
    4e14:	00000097          	auipc	ra,0x0
    4e18:	6d8080e7          	jalr	1752(ra) # 54ec <write>
      if (cc < BSIZE)
    4e1c:	00aad563          	bge	s5,a0,4e26 <fsfull+0x17c>
      total += cc;
    4e20:	00a989bb          	addw	s3,s3,a0
    while (1) {
    4e24:	b7e5                	j	4e0c <fsfull+0x162>
    printf("%s: wrote %d bytes\n", total);
    4e26:	85ce                	mv	a1,s3
    4e28:	00003517          	auipc	a0,0x3
    4e2c:	dd050513          	addi	a0,a0,-560 # 7bf8 <l_free+0x2192>
    4e30:	00001097          	auipc	ra,0x1
    4e34:	a14080e7          	jalr	-1516(ra) # 5844 <printf>
    close(fd);
    4e38:	854a                	mv	a0,s2
    4e3a:	00000097          	auipc	ra,0x0
    4e3e:	6ba080e7          	jalr	1722(ra) # 54f4 <close>
    if (total == 0)
    4e42:	f20988e3          	beqz	s3,4d72 <fsfull+0xc8>
  for (nfiles = 0;; nfiles++) {
    4e46:	2485                	addiw	s1,s1,1
    4e48:	bd4d                	j	4cfa <fsfull+0x50>

0000000000004e4a <rand>:
unsigned int rand() {
    4e4a:	1141                	addi	sp,sp,-16
    4e4c:	e422                	sd	s0,8(sp)
    4e4e:	0800                	addi	s0,sp,16
  randstate = randstate * 1664525 + 1013904223;
    4e50:	00003717          	auipc	a4,0x3
    4e54:	32870713          	addi	a4,a4,808 # 8178 <randstate>
    4e58:	6308                	ld	a0,0(a4)
    4e5a:	001967b7          	lui	a5,0x196
    4e5e:	60d78793          	addi	a5,a5,1549 # 19660d <__BSS_END__+0x187c45>
    4e62:	02f50533          	mul	a0,a0,a5
    4e66:	3c6ef7b7          	lui	a5,0x3c6ef
    4e6a:	35f78793          	addi	a5,a5,863 # 3c6ef35f <__BSS_END__+0x3c6e0997>
    4e6e:	953e                	add	a0,a0,a5
    4e70:	e308                	sd	a0,0(a4)
}
    4e72:	2501                	sext.w	a0,a0
    4e74:	6422                	ld	s0,8(sp)
    4e76:	0141                	addi	sp,sp,16
    4e78:	8082                	ret

0000000000004e7a <countfree>:
// use sbrk() to count how many free physical memory pages there are.
// touches the pages to force allocation.
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int countfree() {
    4e7a:	7139                	addi	sp,sp,-64
    4e7c:	fc06                	sd	ra,56(sp)
    4e7e:	f822                	sd	s0,48(sp)
    4e80:	f426                	sd	s1,40(sp)
    4e82:	f04a                	sd	s2,32(sp)
    4e84:	ec4e                	sd	s3,24(sp)
    4e86:	0080                	addi	s0,sp,64
  int fds[2];

  if (pipe(fds) < 0) {
    4e88:	fc840513          	addi	a0,s0,-56
    4e8c:	00000097          	auipc	ra,0x0
    4e90:	650080e7          	jalr	1616(ra) # 54dc <pipe>
    4e94:	06054763          	bltz	a0,4f02 <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }

  int pid = fork();
    4e98:	00000097          	auipc	ra,0x0
    4e9c:	62c080e7          	jalr	1580(ra) # 54c4 <fork>

  if (pid < 0) {
    4ea0:	06054e63          	bltz	a0,4f1c <countfree+0xa2>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if (pid == 0) {
    4ea4:	ed51                	bnez	a0,4f40 <countfree+0xc6>
    close(fds[0]);
    4ea6:	fc842503          	lw	a0,-56(s0)
    4eaa:	00000097          	auipc	ra,0x0
    4eae:	64a080e7          	jalr	1610(ra) # 54f4 <close>

    while (1) {
      uint64 a = (uint64)sbrk(4096);
      if (a == 0xffffffffffffffff) {
    4eb2:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    4eb4:	4485                	li	s1,1

      // report back one more page.
      if (write(fds[1], "x", 1) != 1) {
    4eb6:	00001997          	auipc	s3,0x1
    4eba:	f7298993          	addi	s3,s3,-142 # 5e28 <l_free+0x3c2>
      uint64 a = (uint64)sbrk(4096);
    4ebe:	6505                	lui	a0,0x1
    4ec0:	00000097          	auipc	ra,0x0
    4ec4:	694080e7          	jalr	1684(ra) # 5554 <sbrk>
      if (a == 0xffffffffffffffff) {
    4ec8:	07250763          	beq	a0,s2,4f36 <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    4ecc:	6785                	lui	a5,0x1
    4ece:	953e                	add	a0,a0,a5
    4ed0:	fe950fa3          	sb	s1,-1(a0) # fff <bigdir+0x133>
      if (write(fds[1], "x", 1) != 1) {
    4ed4:	8626                	mv	a2,s1
    4ed6:	85ce                	mv	a1,s3
    4ed8:	fcc42503          	lw	a0,-52(s0)
    4edc:	00000097          	auipc	ra,0x0
    4ee0:	610080e7          	jalr	1552(ra) # 54ec <write>
    4ee4:	fc950de3          	beq	a0,s1,4ebe <countfree+0x44>
        printf("write() failed in countfree()\n");
    4ee8:	00003517          	auipc	a0,0x3
    4eec:	d8050513          	addi	a0,a0,-640 # 7c68 <l_free+0x2202>
    4ef0:	00001097          	auipc	ra,0x1
    4ef4:	954080e7          	jalr	-1708(ra) # 5844 <printf>
        exit(1);
    4ef8:	4505                	li	a0,1
    4efa:	00000097          	auipc	ra,0x0
    4efe:	5d2080e7          	jalr	1490(ra) # 54cc <exit>
    printf("pipe() failed in countfree()\n");
    4f02:	00003517          	auipc	a0,0x3
    4f06:	d2650513          	addi	a0,a0,-730 # 7c28 <l_free+0x21c2>
    4f0a:	00001097          	auipc	ra,0x1
    4f0e:	93a080e7          	jalr	-1734(ra) # 5844 <printf>
    exit(1);
    4f12:	4505                	li	a0,1
    4f14:	00000097          	auipc	ra,0x0
    4f18:	5b8080e7          	jalr	1464(ra) # 54cc <exit>
    printf("fork failed in countfree()\n");
    4f1c:	00003517          	auipc	a0,0x3
    4f20:	d2c50513          	addi	a0,a0,-724 # 7c48 <l_free+0x21e2>
    4f24:	00001097          	auipc	ra,0x1
    4f28:	920080e7          	jalr	-1760(ra) # 5844 <printf>
    exit(1);
    4f2c:	4505                	li	a0,1
    4f2e:	00000097          	auipc	ra,0x0
    4f32:	59e080e7          	jalr	1438(ra) # 54cc <exit>
      }
    }

    exit(0);
    4f36:	4501                	li	a0,0
    4f38:	00000097          	auipc	ra,0x0
    4f3c:	594080e7          	jalr	1428(ra) # 54cc <exit>
  }

  close(fds[1]);
    4f40:	fcc42503          	lw	a0,-52(s0)
    4f44:	00000097          	auipc	ra,0x0
    4f48:	5b0080e7          	jalr	1456(ra) # 54f4 <close>

  int n = 0;
    4f4c:	4481                	li	s1,0
  while (1) {
    char c;
    int cc = read(fds[0], &c, 1);
    4f4e:	4605                	li	a2,1
    4f50:	fc740593          	addi	a1,s0,-57
    4f54:	fc842503          	lw	a0,-56(s0)
    4f58:	00000097          	auipc	ra,0x0
    4f5c:	58c080e7          	jalr	1420(ra) # 54e4 <read>
    if (cc < 0) {
    4f60:	00054563          	bltz	a0,4f6a <countfree+0xf0>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if (cc == 0)
    4f64:	c105                	beqz	a0,4f84 <countfree+0x10a>
      break;
    n += 1;
    4f66:	2485                	addiw	s1,s1,1
  while (1) {
    4f68:	b7dd                	j	4f4e <countfree+0xd4>
      printf("read() failed in countfree()\n");
    4f6a:	00003517          	auipc	a0,0x3
    4f6e:	d1e50513          	addi	a0,a0,-738 # 7c88 <l_free+0x2222>
    4f72:	00001097          	auipc	ra,0x1
    4f76:	8d2080e7          	jalr	-1838(ra) # 5844 <printf>
      exit(1);
    4f7a:	4505                	li	a0,1
    4f7c:	00000097          	auipc	ra,0x0
    4f80:	550080e7          	jalr	1360(ra) # 54cc <exit>
  }

  close(fds[0]);
    4f84:	fc842503          	lw	a0,-56(s0)
    4f88:	00000097          	auipc	ra,0x0
    4f8c:	56c080e7          	jalr	1388(ra) # 54f4 <close>
  wait((int *)0);
    4f90:	4501                	li	a0,0
    4f92:	00000097          	auipc	ra,0x0
    4f96:	542080e7          	jalr	1346(ra) # 54d4 <wait>

  return n;
}
    4f9a:	8526                	mv	a0,s1
    4f9c:	70e2                	ld	ra,56(sp)
    4f9e:	7442                	ld	s0,48(sp)
    4fa0:	74a2                	ld	s1,40(sp)
    4fa2:	7902                	ld	s2,32(sp)
    4fa4:	69e2                	ld	s3,24(sp)
    4fa6:	6121                	addi	sp,sp,64
    4fa8:	8082                	ret

0000000000004faa <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int run(void f(char *), char *s) {
    4faa:	7179                	addi	sp,sp,-48
    4fac:	f406                	sd	ra,40(sp)
    4fae:	f022                	sd	s0,32(sp)
    4fb0:	ec26                	sd	s1,24(sp)
    4fb2:	e84a                	sd	s2,16(sp)
    4fb4:	1800                	addi	s0,sp,48
    4fb6:	84aa                	mv	s1,a0
    4fb8:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    4fba:	00003517          	auipc	a0,0x3
    4fbe:	cee50513          	addi	a0,a0,-786 # 7ca8 <l_free+0x2242>
    4fc2:	00001097          	auipc	ra,0x1
    4fc6:	882080e7          	jalr	-1918(ra) # 5844 <printf>
  if ((pid = fork()) < 0) {
    4fca:	00000097          	auipc	ra,0x0
    4fce:	4fa080e7          	jalr	1274(ra) # 54c4 <fork>
    4fd2:	02054e63          	bltz	a0,500e <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if (pid == 0) {
    4fd6:	c929                	beqz	a0,5028 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    4fd8:	fdc40513          	addi	a0,s0,-36
    4fdc:	00000097          	auipc	ra,0x0
    4fe0:	4f8080e7          	jalr	1272(ra) # 54d4 <wait>
    if (xstatus != 0)
    4fe4:	fdc42783          	lw	a5,-36(s0)
    4fe8:	c7b9                	beqz	a5,5036 <run+0x8c>
      printf("FAILED\n");
    4fea:	00003517          	auipc	a0,0x3
    4fee:	ce650513          	addi	a0,a0,-794 # 7cd0 <l_free+0x226a>
    4ff2:	00001097          	auipc	ra,0x1
    4ff6:	852080e7          	jalr	-1966(ra) # 5844 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    4ffa:	fdc42503          	lw	a0,-36(s0)
  }
}
    4ffe:	00153513          	seqz	a0,a0
    5002:	70a2                	ld	ra,40(sp)
    5004:	7402                	ld	s0,32(sp)
    5006:	64e2                	ld	s1,24(sp)
    5008:	6942                	ld	s2,16(sp)
    500a:	6145                	addi	sp,sp,48
    500c:	8082                	ret
    printf("runtest: fork error\n");
    500e:	00003517          	auipc	a0,0x3
    5012:	caa50513          	addi	a0,a0,-854 # 7cb8 <l_free+0x2252>
    5016:	00001097          	auipc	ra,0x1
    501a:	82e080e7          	jalr	-2002(ra) # 5844 <printf>
    exit(1);
    501e:	4505                	li	a0,1
    5020:	00000097          	auipc	ra,0x0
    5024:	4ac080e7          	jalr	1196(ra) # 54cc <exit>
    f(s);
    5028:	854a                	mv	a0,s2
    502a:	9482                	jalr	s1
    exit(0);
    502c:	4501                	li	a0,0
    502e:	00000097          	auipc	ra,0x0
    5032:	49e080e7          	jalr	1182(ra) # 54cc <exit>
      printf("OK\n");
    5036:	00003517          	auipc	a0,0x3
    503a:	ca250513          	addi	a0,a0,-862 # 7cd8 <l_free+0x2272>
    503e:	00001097          	auipc	ra,0x1
    5042:	806080e7          	jalr	-2042(ra) # 5844 <printf>
    5046:	bf55                	j	4ffa <run+0x50>

0000000000005048 <main>:

int main(int argc, char *argv[]) {
    5048:	c3010113          	addi	sp,sp,-976
    504c:	3c113423          	sd	ra,968(sp)
    5050:	3c813023          	sd	s0,960(sp)
    5054:	3a913c23          	sd	s1,952(sp)
    5058:	3b213823          	sd	s2,944(sp)
    505c:	3b313423          	sd	s3,936(sp)
    5060:	3b413023          	sd	s4,928(sp)
    5064:	39513c23          	sd	s5,920(sp)
    5068:	39613823          	sd	s6,912(sp)
    506c:	0f80                	addi	s0,sp,976
    506e:	89aa                	mv	s3,a0
  int continuous = 0;
  char *justone = 0;

  if (argc == 2 && strcmp(argv[1], "-c") == 0) {
    5070:	4789                	li	a5,2
    5072:	08f50263          	beq	a0,a5,50f6 <main+0xae>
    continuous = 1;
  } else if (argc == 2 && strcmp(argv[1], "-C") == 0) {
    continuous = 2;
  } else if (argc == 2 && argv[1][0] != '-') {
    justone = argv[1];
  } else if (argc > 1) {
    5076:	4785                	li	a5,1
  char *justone = 0;
    5078:	4901                	li	s2,0
  } else if (argc > 1) {
    507a:	0aa7cb63          	blt	a5,a0,5130 <main+0xe8>
  }

  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    507e:	00003797          	auipc	a5,0x3
    5082:	d4278793          	addi	a5,a5,-702 # 7dc0 <l_free+0x235a>
    5086:	c3040713          	addi	a4,s0,-976
    508a:	00003317          	auipc	t1,0x3
    508e:	0c630313          	addi	t1,t1,198 # 8150 <l_free+0x26ea>
    5092:	0007b883          	ld	a7,0(a5)
    5096:	0087b803          	ld	a6,8(a5)
    509a:	6b88                	ld	a0,16(a5)
    509c:	6f8c                	ld	a1,24(a5)
    509e:	7390                	ld	a2,32(a5)
    50a0:	7794                	ld	a3,40(a5)
    50a2:	01173023          	sd	a7,0(a4)
    50a6:	01073423          	sd	a6,8(a4)
    50aa:	eb08                	sd	a0,16(a4)
    50ac:	ef0c                	sd	a1,24(a4)
    50ae:	f310                	sd	a2,32(a4)
    50b0:	f714                	sd	a3,40(a4)
    50b2:	03078793          	addi	a5,a5,48
    50b6:	03070713          	addi	a4,a4,48
    50ba:	fc679ce3          	bne	a5,t1,5092 <main+0x4a>
          exit(1);
      }
    }
  }

  printf("usertests starting\n");
    50be:	00003517          	auipc	a0,0x3
    50c2:	ca250513          	addi	a0,a0,-862 # 7d60 <l_free+0x22fa>
    50c6:	00000097          	auipc	ra,0x0
    50ca:	77e080e7          	jalr	1918(ra) # 5844 <printf>
  int free0 = 100; // countfree();
  int free1 = 0;
  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    50ce:	c3843503          	ld	a0,-968(s0)
    50d2:	c3040493          	addi	s1,s0,-976
  int fail = 0;
    50d6:	4981                	li	s3,0
    if ((justone == 0) || strcmp(t->s, justone) == 0) {
      if (!run(t->f, t->s))
        fail = 1;
    50d8:	4a05                	li	s4,1
  for (struct test *t = tests; t->s != 0; t++) {
    50da:	ed51                	bnez	a0,5176 <main+0x12e>
    exit(1);
  } else if ((free1 = 100) < free0) {
    printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    exit(1);
  } else {
    printf("ALL TESTS PASSED\n");
    50dc:	00003517          	auipc	a0,0x3
    50e0:	c6c50513          	addi	a0,a0,-916 # 7d48 <l_free+0x22e2>
    50e4:	00000097          	auipc	ra,0x0
    50e8:	760080e7          	jalr	1888(ra) # 5844 <printf>
    exit(0);
    50ec:	4501                	li	a0,0
    50ee:	00000097          	auipc	ra,0x0
    50f2:	3de080e7          	jalr	990(ra) # 54cc <exit>
    50f6:	84ae                	mv	s1,a1
  if (argc == 2 && strcmp(argv[1], "-c") == 0) {
    50f8:	00003597          	auipc	a1,0x3
    50fc:	be858593          	addi	a1,a1,-1048 # 7ce0 <l_free+0x227a>
    5100:	6488                	ld	a0,8(s1)
    5102:	00000097          	auipc	ra,0x0
    5106:	178080e7          	jalr	376(ra) # 527a <strcmp>
    510a:	c57d                	beqz	a0,51f8 <main+0x1b0>
  } else if (argc == 2 && strcmp(argv[1], "-C") == 0) {
    510c:	00003597          	auipc	a1,0x3
    5110:	c8c58593          	addi	a1,a1,-884 # 7d98 <l_free+0x2332>
    5114:	6488                	ld	a0,8(s1)
    5116:	00000097          	auipc	ra,0x0
    511a:	164080e7          	jalr	356(ra) # 527a <strcmp>
    511e:	cd71                	beqz	a0,51fa <main+0x1b2>
  } else if (argc == 2 && argv[1][0] != '-') {
    5120:	0084b903          	ld	s2,8(s1)
    5124:	00094703          	lbu	a4,0(s2)
    5128:	02d00793          	li	a5,45
    512c:	f4f719e3          	bne	a4,a5,507e <main+0x36>
    printf("Usage: usertests [-c] [testname]\n");
    5130:	00003517          	auipc	a0,0x3
    5134:	bb850513          	addi	a0,a0,-1096 # 7ce8 <l_free+0x2282>
    5138:	00000097          	auipc	ra,0x0
    513c:	70c080e7          	jalr	1804(ra) # 5844 <printf>
    exit(1);
    5140:	4505                	li	a0,1
    5142:	00000097          	auipc	ra,0x0
    5146:	38a080e7          	jalr	906(ra) # 54cc <exit>
          exit(1);
    514a:	4505                	li	a0,1
    514c:	00000097          	auipc	ra,0x0
    5150:	380080e7          	jalr	896(ra) # 54cc <exit>
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    5154:	40a905bb          	subw	a1,s2,a0
    5158:	855a                	mv	a0,s6
    515a:	00000097          	auipc	ra,0x0
    515e:	6ea080e7          	jalr	1770(ra) # 5844 <printf>
        if (continuous != 2)
    5162:	07498763          	beq	s3,s4,51d0 <main+0x188>
          exit(1);
    5166:	4505                	li	a0,1
    5168:	00000097          	auipc	ra,0x0
    516c:	364080e7          	jalr	868(ra) # 54cc <exit>
  for (struct test *t = tests; t->s != 0; t++) {
    5170:	04c1                	addi	s1,s1,16
    5172:	6488                	ld	a0,8(s1)
    5174:	c115                	beqz	a0,5198 <main+0x150>
    if ((justone == 0) || strcmp(t->s, justone) == 0) {
    5176:	00090863          	beqz	s2,5186 <main+0x13e>
    517a:	85ca                	mv	a1,s2
    517c:	00000097          	auipc	ra,0x0
    5180:	0fe080e7          	jalr	254(ra) # 527a <strcmp>
    5184:	f575                	bnez	a0,5170 <main+0x128>
      if (!run(t->f, t->s))
    5186:	648c                	ld	a1,8(s1)
    5188:	6088                	ld	a0,0(s1)
    518a:	00000097          	auipc	ra,0x0
    518e:	e20080e7          	jalr	-480(ra) # 4faa <run>
    5192:	fd79                	bnez	a0,5170 <main+0x128>
        fail = 1;
    5194:	89d2                	mv	s3,s4
    5196:	bfe9                	j	5170 <main+0x128>
  if (fail) {
    5198:	f40982e3          	beqz	s3,50dc <main+0x94>
    printf("SOME TESTS FAILED\n");
    519c:	00003517          	auipc	a0,0x3
    51a0:	b9450513          	addi	a0,a0,-1132 # 7d30 <l_free+0x22ca>
    51a4:	00000097          	auipc	ra,0x0
    51a8:	6a0080e7          	jalr	1696(ra) # 5844 <printf>
    exit(1);
    51ac:	4505                	li	a0,1
    51ae:	00000097          	auipc	ra,0x0
    51b2:	31e080e7          	jalr	798(ra) # 54cc <exit>
        printf("SOME TESTS FAILED\n");
    51b6:	8556                	mv	a0,s5
    51b8:	00000097          	auipc	ra,0x0
    51bc:	68c080e7          	jalr	1676(ra) # 5844 <printf>
        if (continuous != 2)
    51c0:	f94995e3          	bne	s3,s4,514a <main+0x102>
      int free1 = countfree();
    51c4:	00000097          	auipc	ra,0x0
    51c8:	cb6080e7          	jalr	-842(ra) # 4e7a <countfree>
      if (free1 < free0) {
    51cc:	f92544e3          	blt	a0,s2,5154 <main+0x10c>
      int free0 = countfree();
    51d0:	00000097          	auipc	ra,0x0
    51d4:	caa080e7          	jalr	-854(ra) # 4e7a <countfree>
    51d8:	892a                	mv	s2,a0
      for (struct test *t = tests; t->s != 0; t++) {
    51da:	c3843583          	ld	a1,-968(s0)
    51de:	d1fd                	beqz	a1,51c4 <main+0x17c>
    51e0:	c3040493          	addi	s1,s0,-976
        if (!run(t->f, t->s)) {
    51e4:	6088                	ld	a0,0(s1)
    51e6:	00000097          	auipc	ra,0x0
    51ea:	dc4080e7          	jalr	-572(ra) # 4faa <run>
    51ee:	d561                	beqz	a0,51b6 <main+0x16e>
      for (struct test *t = tests; t->s != 0; t++) {
    51f0:	04c1                	addi	s1,s1,16
    51f2:	648c                	ld	a1,8(s1)
    51f4:	f9e5                	bnez	a1,51e4 <main+0x19c>
    51f6:	b7f9                	j	51c4 <main+0x17c>
    continuous = 1;
    51f8:	4985                	li	s3,1
  } tests[] = {
    51fa:	00003797          	auipc	a5,0x3
    51fe:	bc678793          	addi	a5,a5,-1082 # 7dc0 <l_free+0x235a>
    5202:	c3040713          	addi	a4,s0,-976
    5206:	00003317          	auipc	t1,0x3
    520a:	f4a30313          	addi	t1,t1,-182 # 8150 <l_free+0x26ea>
    520e:	0007b883          	ld	a7,0(a5)
    5212:	0087b803          	ld	a6,8(a5)
    5216:	6b88                	ld	a0,16(a5)
    5218:	6f8c                	ld	a1,24(a5)
    521a:	7390                	ld	a2,32(a5)
    521c:	7794                	ld	a3,40(a5)
    521e:	01173023          	sd	a7,0(a4)
    5222:	01073423          	sd	a6,8(a4)
    5226:	eb08                	sd	a0,16(a4)
    5228:	ef0c                	sd	a1,24(a4)
    522a:	f310                	sd	a2,32(a4)
    522c:	f714                	sd	a3,40(a4)
    522e:	03078793          	addi	a5,a5,48
    5232:	03070713          	addi	a4,a4,48
    5236:	fc679ce3          	bne	a5,t1,520e <main+0x1c6>
    printf("continuous usertests starting\n");
    523a:	00003517          	auipc	a0,0x3
    523e:	b3e50513          	addi	a0,a0,-1218 # 7d78 <l_free+0x2312>
    5242:	00000097          	auipc	ra,0x0
    5246:	602080e7          	jalr	1538(ra) # 5844 <printf>
        printf("SOME TESTS FAILED\n");
    524a:	00003a97          	auipc	s5,0x3
    524e:	ae6a8a93          	addi	s5,s5,-1306 # 7d30 <l_free+0x22ca>
        if (continuous != 2)
    5252:	4a09                	li	s4,2
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    5254:	00003b17          	auipc	s6,0x3
    5258:	abcb0b13          	addi	s6,s6,-1348 # 7d10 <l_free+0x22aa>
    525c:	bf95                	j	51d0 <main+0x188>

000000000000525e <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    525e:	1141                	addi	sp,sp,-16
    5260:	e422                	sd	s0,8(sp)
    5262:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    5264:	87aa                	mv	a5,a0
    5266:	0585                	addi	a1,a1,1
    5268:	0785                	addi	a5,a5,1
    526a:	fff5c703          	lbu	a4,-1(a1)
    526e:	fee78fa3          	sb	a4,-1(a5)
    5272:	fb75                	bnez	a4,5266 <strcpy+0x8>
    ;
  return os;
}
    5274:	6422                	ld	s0,8(sp)
    5276:	0141                	addi	sp,sp,16
    5278:	8082                	ret

000000000000527a <strcmp>:

int
strcmp(const char *p, const char *q)
{
    527a:	1141                	addi	sp,sp,-16
    527c:	e422                	sd	s0,8(sp)
    527e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    5280:	00054783          	lbu	a5,0(a0)
    5284:	cb91                	beqz	a5,5298 <strcmp+0x1e>
    5286:	0005c703          	lbu	a4,0(a1)
    528a:	00f71763          	bne	a4,a5,5298 <strcmp+0x1e>
    p++, q++;
    528e:	0505                	addi	a0,a0,1
    5290:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    5292:	00054783          	lbu	a5,0(a0)
    5296:	fbe5                	bnez	a5,5286 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    5298:	0005c503          	lbu	a0,0(a1)
}
    529c:	40a7853b          	subw	a0,a5,a0
    52a0:	6422                	ld	s0,8(sp)
    52a2:	0141                	addi	sp,sp,16
    52a4:	8082                	ret

00000000000052a6 <strlen>:

uint
strlen(const char *s)
{
    52a6:	1141                	addi	sp,sp,-16
    52a8:	e422                	sd	s0,8(sp)
    52aa:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    52ac:	00054783          	lbu	a5,0(a0)
    52b0:	cf91                	beqz	a5,52cc <strlen+0x26>
    52b2:	0505                	addi	a0,a0,1
    52b4:	87aa                	mv	a5,a0
    52b6:	4685                	li	a3,1
    52b8:	9e89                	subw	a3,a3,a0
    52ba:	00f6853b          	addw	a0,a3,a5
    52be:	0785                	addi	a5,a5,1
    52c0:	fff7c703          	lbu	a4,-1(a5)
    52c4:	fb7d                	bnez	a4,52ba <strlen+0x14>
    ;
  return n;
}
    52c6:	6422                	ld	s0,8(sp)
    52c8:	0141                	addi	sp,sp,16
    52ca:	8082                	ret
  for(n = 0; s[n]; n++)
    52cc:	4501                	li	a0,0
    52ce:	bfe5                	j	52c6 <strlen+0x20>

00000000000052d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
    52d0:	1141                	addi	sp,sp,-16
    52d2:	e422                	sd	s0,8(sp)
    52d4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    52d6:	ca19                	beqz	a2,52ec <memset+0x1c>
    52d8:	87aa                	mv	a5,a0
    52da:	1602                	slli	a2,a2,0x20
    52dc:	9201                	srli	a2,a2,0x20
    52de:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    52e2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    52e6:	0785                	addi	a5,a5,1
    52e8:	fee79de3          	bne	a5,a4,52e2 <memset+0x12>
  }
  return dst;
}
    52ec:	6422                	ld	s0,8(sp)
    52ee:	0141                	addi	sp,sp,16
    52f0:	8082                	ret

00000000000052f2 <strchr>:

char*
strchr(const char *s, char c)
{
    52f2:	1141                	addi	sp,sp,-16
    52f4:	e422                	sd	s0,8(sp)
    52f6:	0800                	addi	s0,sp,16
  for(; *s; s++)
    52f8:	00054783          	lbu	a5,0(a0)
    52fc:	cb99                	beqz	a5,5312 <strchr+0x20>
    if(*s == c)
    52fe:	00f58763          	beq	a1,a5,530c <strchr+0x1a>
  for(; *s; s++)
    5302:	0505                	addi	a0,a0,1
    5304:	00054783          	lbu	a5,0(a0)
    5308:	fbfd                	bnez	a5,52fe <strchr+0xc>
      return (char*)s;
  return 0;
    530a:	4501                	li	a0,0
}
    530c:	6422                	ld	s0,8(sp)
    530e:	0141                	addi	sp,sp,16
    5310:	8082                	ret
  return 0;
    5312:	4501                	li	a0,0
    5314:	bfe5                	j	530c <strchr+0x1a>

0000000000005316 <gets>:

char*
gets(char *buf, int max)
{
    5316:	711d                	addi	sp,sp,-96
    5318:	ec86                	sd	ra,88(sp)
    531a:	e8a2                	sd	s0,80(sp)
    531c:	e4a6                	sd	s1,72(sp)
    531e:	e0ca                	sd	s2,64(sp)
    5320:	fc4e                	sd	s3,56(sp)
    5322:	f852                	sd	s4,48(sp)
    5324:	f456                	sd	s5,40(sp)
    5326:	f05a                	sd	s6,32(sp)
    5328:	ec5e                	sd	s7,24(sp)
    532a:	1080                	addi	s0,sp,96
    532c:	8baa                	mv	s7,a0
    532e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5330:	892a                	mv	s2,a0
    5332:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5334:	4aa9                	li	s5,10
    5336:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5338:	89a6                	mv	s3,s1
    533a:	2485                	addiw	s1,s1,1
    533c:	0344d863          	bge	s1,s4,536c <gets+0x56>
    cc = read(0, &c, 1);
    5340:	4605                	li	a2,1
    5342:	faf40593          	addi	a1,s0,-81
    5346:	4501                	li	a0,0
    5348:	00000097          	auipc	ra,0x0
    534c:	19c080e7          	jalr	412(ra) # 54e4 <read>
    if(cc < 1)
    5350:	00a05e63          	blez	a0,536c <gets+0x56>
    buf[i++] = c;
    5354:	faf44783          	lbu	a5,-81(s0)
    5358:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    535c:	01578763          	beq	a5,s5,536a <gets+0x54>
    5360:	0905                	addi	s2,s2,1
    5362:	fd679be3          	bne	a5,s6,5338 <gets+0x22>
  for(i=0; i+1 < max; ){
    5366:	89a6                	mv	s3,s1
    5368:	a011                	j	536c <gets+0x56>
    536a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    536c:	99de                	add	s3,s3,s7
    536e:	00098023          	sb	zero,0(s3)
  return buf;
}
    5372:	855e                	mv	a0,s7
    5374:	60e6                	ld	ra,88(sp)
    5376:	6446                	ld	s0,80(sp)
    5378:	64a6                	ld	s1,72(sp)
    537a:	6906                	ld	s2,64(sp)
    537c:	79e2                	ld	s3,56(sp)
    537e:	7a42                	ld	s4,48(sp)
    5380:	7aa2                	ld	s5,40(sp)
    5382:	7b02                	ld	s6,32(sp)
    5384:	6be2                	ld	s7,24(sp)
    5386:	6125                	addi	sp,sp,96
    5388:	8082                	ret

000000000000538a <stat>:

int
stat(const char *n, struct stat *st)
{
    538a:	1101                	addi	sp,sp,-32
    538c:	ec06                	sd	ra,24(sp)
    538e:	e822                	sd	s0,16(sp)
    5390:	e426                	sd	s1,8(sp)
    5392:	e04a                	sd	s2,0(sp)
    5394:	1000                	addi	s0,sp,32
    5396:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5398:	4581                	li	a1,0
    539a:	00000097          	auipc	ra,0x0
    539e:	172080e7          	jalr	370(ra) # 550c <open>
  if(fd < 0)
    53a2:	02054563          	bltz	a0,53cc <stat+0x42>
    53a6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    53a8:	85ca                	mv	a1,s2
    53aa:	00000097          	auipc	ra,0x0
    53ae:	17a080e7          	jalr	378(ra) # 5524 <fstat>
    53b2:	892a                	mv	s2,a0
  close(fd);
    53b4:	8526                	mv	a0,s1
    53b6:	00000097          	auipc	ra,0x0
    53ba:	13e080e7          	jalr	318(ra) # 54f4 <close>
  return r;
}
    53be:	854a                	mv	a0,s2
    53c0:	60e2                	ld	ra,24(sp)
    53c2:	6442                	ld	s0,16(sp)
    53c4:	64a2                	ld	s1,8(sp)
    53c6:	6902                	ld	s2,0(sp)
    53c8:	6105                	addi	sp,sp,32
    53ca:	8082                	ret
    return -1;
    53cc:	597d                	li	s2,-1
    53ce:	bfc5                	j	53be <stat+0x34>

00000000000053d0 <atoi>:

int
atoi(const char *s)
{
    53d0:	1141                	addi	sp,sp,-16
    53d2:	e422                	sd	s0,8(sp)
    53d4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    53d6:	00054603          	lbu	a2,0(a0)
    53da:	fd06079b          	addiw	a5,a2,-48
    53de:	0ff7f793          	andi	a5,a5,255
    53e2:	4725                	li	a4,9
    53e4:	02f76963          	bltu	a4,a5,5416 <atoi+0x46>
    53e8:	86aa                	mv	a3,a0
  n = 0;
    53ea:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    53ec:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    53ee:	0685                	addi	a3,a3,1
    53f0:	0025179b          	slliw	a5,a0,0x2
    53f4:	9fa9                	addw	a5,a5,a0
    53f6:	0017979b          	slliw	a5,a5,0x1
    53fa:	9fb1                	addw	a5,a5,a2
    53fc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5400:	0006c603          	lbu	a2,0(a3)
    5404:	fd06071b          	addiw	a4,a2,-48
    5408:	0ff77713          	andi	a4,a4,255
    540c:	fee5f1e3          	bgeu	a1,a4,53ee <atoi+0x1e>
  return n;
}
    5410:	6422                	ld	s0,8(sp)
    5412:	0141                	addi	sp,sp,16
    5414:	8082                	ret
  n = 0;
    5416:	4501                	li	a0,0
    5418:	bfe5                	j	5410 <atoi+0x40>

000000000000541a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    541a:	1141                	addi	sp,sp,-16
    541c:	e422                	sd	s0,8(sp)
    541e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5420:	02b57463          	bgeu	a0,a1,5448 <memmove+0x2e>
    while(n-- > 0)
    5424:	00c05f63          	blez	a2,5442 <memmove+0x28>
    5428:	1602                	slli	a2,a2,0x20
    542a:	9201                	srli	a2,a2,0x20
    542c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5430:	872a                	mv	a4,a0
      *dst++ = *src++;
    5432:	0585                	addi	a1,a1,1
    5434:	0705                	addi	a4,a4,1
    5436:	fff5c683          	lbu	a3,-1(a1)
    543a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    543e:	fee79ae3          	bne	a5,a4,5432 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5442:	6422                	ld	s0,8(sp)
    5444:	0141                	addi	sp,sp,16
    5446:	8082                	ret
    dst += n;
    5448:	00c50733          	add	a4,a0,a2
    src += n;
    544c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    544e:	fec05ae3          	blez	a2,5442 <memmove+0x28>
    5452:	fff6079b          	addiw	a5,a2,-1
    5456:	1782                	slli	a5,a5,0x20
    5458:	9381                	srli	a5,a5,0x20
    545a:	fff7c793          	not	a5,a5
    545e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5460:	15fd                	addi	a1,a1,-1
    5462:	177d                	addi	a4,a4,-1
    5464:	0005c683          	lbu	a3,0(a1)
    5468:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    546c:	fee79ae3          	bne	a5,a4,5460 <memmove+0x46>
    5470:	bfc9                	j	5442 <memmove+0x28>

0000000000005472 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5472:	1141                	addi	sp,sp,-16
    5474:	e422                	sd	s0,8(sp)
    5476:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5478:	ca05                	beqz	a2,54a8 <memcmp+0x36>
    547a:	fff6069b          	addiw	a3,a2,-1
    547e:	1682                	slli	a3,a3,0x20
    5480:	9281                	srli	a3,a3,0x20
    5482:	0685                	addi	a3,a3,1
    5484:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5486:	00054783          	lbu	a5,0(a0)
    548a:	0005c703          	lbu	a4,0(a1)
    548e:	00e79863          	bne	a5,a4,549e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5492:	0505                	addi	a0,a0,1
    p2++;
    5494:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5496:	fed518e3          	bne	a0,a3,5486 <memcmp+0x14>
  }
  return 0;
    549a:	4501                	li	a0,0
    549c:	a019                	j	54a2 <memcmp+0x30>
      return *p1 - *p2;
    549e:	40e7853b          	subw	a0,a5,a4
}
    54a2:	6422                	ld	s0,8(sp)
    54a4:	0141                	addi	sp,sp,16
    54a6:	8082                	ret
  return 0;
    54a8:	4501                	li	a0,0
    54aa:	bfe5                	j	54a2 <memcmp+0x30>

00000000000054ac <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    54ac:	1141                	addi	sp,sp,-16
    54ae:	e406                	sd	ra,8(sp)
    54b0:	e022                	sd	s0,0(sp)
    54b2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    54b4:	00000097          	auipc	ra,0x0
    54b8:	f66080e7          	jalr	-154(ra) # 541a <memmove>
}
    54bc:	60a2                	ld	ra,8(sp)
    54be:	6402                	ld	s0,0(sp)
    54c0:	0141                	addi	sp,sp,16
    54c2:	8082                	ret

00000000000054c4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    54c4:	4885                	li	a7,1
 ecall
    54c6:	00000073          	ecall
 ret
    54ca:	8082                	ret

00000000000054cc <exit>:
.global exit
exit:
 li a7, SYS_exit
    54cc:	4889                	li	a7,2
 ecall
    54ce:	00000073          	ecall
 ret
    54d2:	8082                	ret

00000000000054d4 <wait>:
.global wait
wait:
 li a7, SYS_wait
    54d4:	488d                	li	a7,3
 ecall
    54d6:	00000073          	ecall
 ret
    54da:	8082                	ret

00000000000054dc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    54dc:	4891                	li	a7,4
 ecall
    54de:	00000073          	ecall
 ret
    54e2:	8082                	ret

00000000000054e4 <read>:
.global read
read:
 li a7, SYS_read
    54e4:	4895                	li	a7,5
 ecall
    54e6:	00000073          	ecall
 ret
    54ea:	8082                	ret

00000000000054ec <write>:
.global write
write:
 li a7, SYS_write
    54ec:	48c1                	li	a7,16
 ecall
    54ee:	00000073          	ecall
 ret
    54f2:	8082                	ret

00000000000054f4 <close>:
.global close
close:
 li a7, SYS_close
    54f4:	48d5                	li	a7,21
 ecall
    54f6:	00000073          	ecall
 ret
    54fa:	8082                	ret

00000000000054fc <kill>:
.global kill
kill:
 li a7, SYS_kill
    54fc:	4899                	li	a7,6
 ecall
    54fe:	00000073          	ecall
 ret
    5502:	8082                	ret

0000000000005504 <exec>:
.global exec
exec:
 li a7, SYS_exec
    5504:	489d                	li	a7,7
 ecall
    5506:	00000073          	ecall
 ret
    550a:	8082                	ret

000000000000550c <open>:
.global open
open:
 li a7, SYS_open
    550c:	48bd                	li	a7,15
 ecall
    550e:	00000073          	ecall
 ret
    5512:	8082                	ret

0000000000005514 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5514:	48c5                	li	a7,17
 ecall
    5516:	00000073          	ecall
 ret
    551a:	8082                	ret

000000000000551c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    551c:	48c9                	li	a7,18
 ecall
    551e:	00000073          	ecall
 ret
    5522:	8082                	ret

0000000000005524 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5524:	48a1                	li	a7,8
 ecall
    5526:	00000073          	ecall
 ret
    552a:	8082                	ret

000000000000552c <link>:
.global link
link:
 li a7, SYS_link
    552c:	48cd                	li	a7,19
 ecall
    552e:	00000073          	ecall
 ret
    5532:	8082                	ret

0000000000005534 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5534:	48d1                	li	a7,20
 ecall
    5536:	00000073          	ecall
 ret
    553a:	8082                	ret

000000000000553c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    553c:	48a5                	li	a7,9
 ecall
    553e:	00000073          	ecall
 ret
    5542:	8082                	ret

0000000000005544 <dup>:
.global dup
dup:
 li a7, SYS_dup
    5544:	48a9                	li	a7,10
 ecall
    5546:	00000073          	ecall
 ret
    554a:	8082                	ret

000000000000554c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    554c:	48ad                	li	a7,11
 ecall
    554e:	00000073          	ecall
 ret
    5552:	8082                	ret

0000000000005554 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5554:	48b1                	li	a7,12
 ecall
    5556:	00000073          	ecall
 ret
    555a:	8082                	ret

000000000000555c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    555c:	48b5                	li	a7,13
 ecall
    555e:	00000073          	ecall
 ret
    5562:	8082                	ret

0000000000005564 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5564:	48b9                	li	a7,14
 ecall
    5566:	00000073          	ecall
 ret
    556a:	8082                	ret

000000000000556c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    556c:	1101                	addi	sp,sp,-32
    556e:	ec06                	sd	ra,24(sp)
    5570:	e822                	sd	s0,16(sp)
    5572:	1000                	addi	s0,sp,32
    5574:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5578:	4605                	li	a2,1
    557a:	fef40593          	addi	a1,s0,-17
    557e:	00000097          	auipc	ra,0x0
    5582:	f6e080e7          	jalr	-146(ra) # 54ec <write>
}
    5586:	60e2                	ld	ra,24(sp)
    5588:	6442                	ld	s0,16(sp)
    558a:	6105                	addi	sp,sp,32
    558c:	8082                	ret

000000000000558e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    558e:	7139                	addi	sp,sp,-64
    5590:	fc06                	sd	ra,56(sp)
    5592:	f822                	sd	s0,48(sp)
    5594:	f426                	sd	s1,40(sp)
    5596:	f04a                	sd	s2,32(sp)
    5598:	ec4e                	sd	s3,24(sp)
    559a:	0080                	addi	s0,sp,64
    559c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    559e:	c299                	beqz	a3,55a4 <printint+0x16>
    55a0:	0805c863          	bltz	a1,5630 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    55a4:	2581                	sext.w	a1,a1
  neg = 0;
    55a6:	4881                	li	a7,0
    55a8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    55ac:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    55ae:	2601                	sext.w	a2,a2
    55b0:	00003517          	auipc	a0,0x3
    55b4:	ba850513          	addi	a0,a0,-1112 # 8158 <digits>
    55b8:	883a                	mv	a6,a4
    55ba:	2705                	addiw	a4,a4,1
    55bc:	02c5f7bb          	remuw	a5,a1,a2
    55c0:	1782                	slli	a5,a5,0x20
    55c2:	9381                	srli	a5,a5,0x20
    55c4:	97aa                	add	a5,a5,a0
    55c6:	0007c783          	lbu	a5,0(a5)
    55ca:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    55ce:	0005879b          	sext.w	a5,a1
    55d2:	02c5d5bb          	divuw	a1,a1,a2
    55d6:	0685                	addi	a3,a3,1
    55d8:	fec7f0e3          	bgeu	a5,a2,55b8 <printint+0x2a>
  if(neg)
    55dc:	00088b63          	beqz	a7,55f2 <printint+0x64>
    buf[i++] = '-';
    55e0:	fd040793          	addi	a5,s0,-48
    55e4:	973e                	add	a4,a4,a5
    55e6:	02d00793          	li	a5,45
    55ea:	fef70823          	sb	a5,-16(a4)
    55ee:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    55f2:	02e05863          	blez	a4,5622 <printint+0x94>
    55f6:	fc040793          	addi	a5,s0,-64
    55fa:	00e78933          	add	s2,a5,a4
    55fe:	fff78993          	addi	s3,a5,-1
    5602:	99ba                	add	s3,s3,a4
    5604:	377d                	addiw	a4,a4,-1
    5606:	1702                	slli	a4,a4,0x20
    5608:	9301                	srli	a4,a4,0x20
    560a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    560e:	fff94583          	lbu	a1,-1(s2)
    5612:	8526                	mv	a0,s1
    5614:	00000097          	auipc	ra,0x0
    5618:	f58080e7          	jalr	-168(ra) # 556c <putc>
  while(--i >= 0)
    561c:	197d                	addi	s2,s2,-1
    561e:	ff3918e3          	bne	s2,s3,560e <printint+0x80>
}
    5622:	70e2                	ld	ra,56(sp)
    5624:	7442                	ld	s0,48(sp)
    5626:	74a2                	ld	s1,40(sp)
    5628:	7902                	ld	s2,32(sp)
    562a:	69e2                	ld	s3,24(sp)
    562c:	6121                	addi	sp,sp,64
    562e:	8082                	ret
    x = -xx;
    5630:	40b005bb          	negw	a1,a1
    neg = 1;
    5634:	4885                	li	a7,1
    x = -xx;
    5636:	bf8d                	j	55a8 <printint+0x1a>

0000000000005638 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5638:	7119                	addi	sp,sp,-128
    563a:	fc86                	sd	ra,120(sp)
    563c:	f8a2                	sd	s0,112(sp)
    563e:	f4a6                	sd	s1,104(sp)
    5640:	f0ca                	sd	s2,96(sp)
    5642:	ecce                	sd	s3,88(sp)
    5644:	e8d2                	sd	s4,80(sp)
    5646:	e4d6                	sd	s5,72(sp)
    5648:	e0da                	sd	s6,64(sp)
    564a:	fc5e                	sd	s7,56(sp)
    564c:	f862                	sd	s8,48(sp)
    564e:	f466                	sd	s9,40(sp)
    5650:	f06a                	sd	s10,32(sp)
    5652:	ec6e                	sd	s11,24(sp)
    5654:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5656:	0005c903          	lbu	s2,0(a1)
    565a:	18090f63          	beqz	s2,57f8 <vprintf+0x1c0>
    565e:	8aaa                	mv	s5,a0
    5660:	8b32                	mv	s6,a2
    5662:	00158493          	addi	s1,a1,1
  state = 0;
    5666:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5668:	02500a13          	li	s4,37
      if(c == 'd'){
    566c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    5670:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    5674:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    5678:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    567c:	00003b97          	auipc	s7,0x3
    5680:	adcb8b93          	addi	s7,s7,-1316 # 8158 <digits>
    5684:	a839                	j	56a2 <vprintf+0x6a>
        putc(fd, c);
    5686:	85ca                	mv	a1,s2
    5688:	8556                	mv	a0,s5
    568a:	00000097          	auipc	ra,0x0
    568e:	ee2080e7          	jalr	-286(ra) # 556c <putc>
    5692:	a019                	j	5698 <vprintf+0x60>
    } else if(state == '%'){
    5694:	01498f63          	beq	s3,s4,56b2 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    5698:	0485                	addi	s1,s1,1
    569a:	fff4c903          	lbu	s2,-1(s1)
    569e:	14090d63          	beqz	s2,57f8 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    56a2:	0009079b          	sext.w	a5,s2
    if(state == 0){
    56a6:	fe0997e3          	bnez	s3,5694 <vprintf+0x5c>
      if(c == '%'){
    56aa:	fd479ee3          	bne	a5,s4,5686 <vprintf+0x4e>
        state = '%';
    56ae:	89be                	mv	s3,a5
    56b0:	b7e5                	j	5698 <vprintf+0x60>
      if(c == 'd'){
    56b2:	05878063          	beq	a5,s8,56f2 <vprintf+0xba>
      } else if(c == 'l') {
    56b6:	05978c63          	beq	a5,s9,570e <vprintf+0xd6>
      } else if(c == 'x') {
    56ba:	07a78863          	beq	a5,s10,572a <vprintf+0xf2>
      } else if(c == 'p') {
    56be:	09b78463          	beq	a5,s11,5746 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    56c2:	07300713          	li	a4,115
    56c6:	0ce78663          	beq	a5,a4,5792 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    56ca:	06300713          	li	a4,99
    56ce:	0ee78e63          	beq	a5,a4,57ca <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    56d2:	11478863          	beq	a5,s4,57e2 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    56d6:	85d2                	mv	a1,s4
    56d8:	8556                	mv	a0,s5
    56da:	00000097          	auipc	ra,0x0
    56de:	e92080e7          	jalr	-366(ra) # 556c <putc>
        putc(fd, c);
    56e2:	85ca                	mv	a1,s2
    56e4:	8556                	mv	a0,s5
    56e6:	00000097          	auipc	ra,0x0
    56ea:	e86080e7          	jalr	-378(ra) # 556c <putc>
      }
      state = 0;
    56ee:	4981                	li	s3,0
    56f0:	b765                	j	5698 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    56f2:	008b0913          	addi	s2,s6,8
    56f6:	4685                	li	a3,1
    56f8:	4629                	li	a2,10
    56fa:	000b2583          	lw	a1,0(s6)
    56fe:	8556                	mv	a0,s5
    5700:	00000097          	auipc	ra,0x0
    5704:	e8e080e7          	jalr	-370(ra) # 558e <printint>
    5708:	8b4a                	mv	s6,s2
      state = 0;
    570a:	4981                	li	s3,0
    570c:	b771                	j	5698 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    570e:	008b0913          	addi	s2,s6,8
    5712:	4681                	li	a3,0
    5714:	4629                	li	a2,10
    5716:	000b2583          	lw	a1,0(s6)
    571a:	8556                	mv	a0,s5
    571c:	00000097          	auipc	ra,0x0
    5720:	e72080e7          	jalr	-398(ra) # 558e <printint>
    5724:	8b4a                	mv	s6,s2
      state = 0;
    5726:	4981                	li	s3,0
    5728:	bf85                	j	5698 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    572a:	008b0913          	addi	s2,s6,8
    572e:	4681                	li	a3,0
    5730:	4641                	li	a2,16
    5732:	000b2583          	lw	a1,0(s6)
    5736:	8556                	mv	a0,s5
    5738:	00000097          	auipc	ra,0x0
    573c:	e56080e7          	jalr	-426(ra) # 558e <printint>
    5740:	8b4a                	mv	s6,s2
      state = 0;
    5742:	4981                	li	s3,0
    5744:	bf91                	j	5698 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    5746:	008b0793          	addi	a5,s6,8
    574a:	f8f43423          	sd	a5,-120(s0)
    574e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    5752:	03000593          	li	a1,48
    5756:	8556                	mv	a0,s5
    5758:	00000097          	auipc	ra,0x0
    575c:	e14080e7          	jalr	-492(ra) # 556c <putc>
  putc(fd, 'x');
    5760:	85ea                	mv	a1,s10
    5762:	8556                	mv	a0,s5
    5764:	00000097          	auipc	ra,0x0
    5768:	e08080e7          	jalr	-504(ra) # 556c <putc>
    576c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    576e:	03c9d793          	srli	a5,s3,0x3c
    5772:	97de                	add	a5,a5,s7
    5774:	0007c583          	lbu	a1,0(a5)
    5778:	8556                	mv	a0,s5
    577a:	00000097          	auipc	ra,0x0
    577e:	df2080e7          	jalr	-526(ra) # 556c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5782:	0992                	slli	s3,s3,0x4
    5784:	397d                	addiw	s2,s2,-1
    5786:	fe0914e3          	bnez	s2,576e <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    578a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    578e:	4981                	li	s3,0
    5790:	b721                	j	5698 <vprintf+0x60>
        s = va_arg(ap, char*);
    5792:	008b0993          	addi	s3,s6,8
    5796:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    579a:	02090163          	beqz	s2,57bc <vprintf+0x184>
        while(*s != 0){
    579e:	00094583          	lbu	a1,0(s2)
    57a2:	c9a1                	beqz	a1,57f2 <vprintf+0x1ba>
          putc(fd, *s);
    57a4:	8556                	mv	a0,s5
    57a6:	00000097          	auipc	ra,0x0
    57aa:	dc6080e7          	jalr	-570(ra) # 556c <putc>
          s++;
    57ae:	0905                	addi	s2,s2,1
        while(*s != 0){
    57b0:	00094583          	lbu	a1,0(s2)
    57b4:	f9e5                	bnez	a1,57a4 <vprintf+0x16c>
        s = va_arg(ap, char*);
    57b6:	8b4e                	mv	s6,s3
      state = 0;
    57b8:	4981                	li	s3,0
    57ba:	bdf9                	j	5698 <vprintf+0x60>
          s = "(null)";
    57bc:	00003917          	auipc	s2,0x3
    57c0:	99490913          	addi	s2,s2,-1644 # 8150 <l_free+0x26ea>
        while(*s != 0){
    57c4:	02800593          	li	a1,40
    57c8:	bff1                	j	57a4 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    57ca:	008b0913          	addi	s2,s6,8
    57ce:	000b4583          	lbu	a1,0(s6)
    57d2:	8556                	mv	a0,s5
    57d4:	00000097          	auipc	ra,0x0
    57d8:	d98080e7          	jalr	-616(ra) # 556c <putc>
    57dc:	8b4a                	mv	s6,s2
      state = 0;
    57de:	4981                	li	s3,0
    57e0:	bd65                	j	5698 <vprintf+0x60>
        putc(fd, c);
    57e2:	85d2                	mv	a1,s4
    57e4:	8556                	mv	a0,s5
    57e6:	00000097          	auipc	ra,0x0
    57ea:	d86080e7          	jalr	-634(ra) # 556c <putc>
      state = 0;
    57ee:	4981                	li	s3,0
    57f0:	b565                	j	5698 <vprintf+0x60>
        s = va_arg(ap, char*);
    57f2:	8b4e                	mv	s6,s3
      state = 0;
    57f4:	4981                	li	s3,0
    57f6:	b54d                	j	5698 <vprintf+0x60>
    }
  }
}
    57f8:	70e6                	ld	ra,120(sp)
    57fa:	7446                	ld	s0,112(sp)
    57fc:	74a6                	ld	s1,104(sp)
    57fe:	7906                	ld	s2,96(sp)
    5800:	69e6                	ld	s3,88(sp)
    5802:	6a46                	ld	s4,80(sp)
    5804:	6aa6                	ld	s5,72(sp)
    5806:	6b06                	ld	s6,64(sp)
    5808:	7be2                	ld	s7,56(sp)
    580a:	7c42                	ld	s8,48(sp)
    580c:	7ca2                	ld	s9,40(sp)
    580e:	7d02                	ld	s10,32(sp)
    5810:	6de2                	ld	s11,24(sp)
    5812:	6109                	addi	sp,sp,128
    5814:	8082                	ret

0000000000005816 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5816:	715d                	addi	sp,sp,-80
    5818:	ec06                	sd	ra,24(sp)
    581a:	e822                	sd	s0,16(sp)
    581c:	1000                	addi	s0,sp,32
    581e:	e010                	sd	a2,0(s0)
    5820:	e414                	sd	a3,8(s0)
    5822:	e818                	sd	a4,16(s0)
    5824:	ec1c                	sd	a5,24(s0)
    5826:	03043023          	sd	a6,32(s0)
    582a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    582e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5832:	8622                	mv	a2,s0
    5834:	00000097          	auipc	ra,0x0
    5838:	e04080e7          	jalr	-508(ra) # 5638 <vprintf>
}
    583c:	60e2                	ld	ra,24(sp)
    583e:	6442                	ld	s0,16(sp)
    5840:	6161                	addi	sp,sp,80
    5842:	8082                	ret

0000000000005844 <printf>:

void
printf(const char *fmt, ...)
{
    5844:	711d                	addi	sp,sp,-96
    5846:	ec06                	sd	ra,24(sp)
    5848:	e822                	sd	s0,16(sp)
    584a:	1000                	addi	s0,sp,32
    584c:	e40c                	sd	a1,8(s0)
    584e:	e810                	sd	a2,16(s0)
    5850:	ec14                	sd	a3,24(s0)
    5852:	f018                	sd	a4,32(s0)
    5854:	f41c                	sd	a5,40(s0)
    5856:	03043823          	sd	a6,48(s0)
    585a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    585e:	00840613          	addi	a2,s0,8
    5862:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5866:	85aa                	mv	a1,a0
    5868:	4505                	li	a0,1
    586a:	00000097          	auipc	ra,0x0
    586e:	dce080e7          	jalr	-562(ra) # 5638 <vprintf>
}
    5872:	60e2                	ld	ra,24(sp)
    5874:	6442                	ld	s0,16(sp)
    5876:	6125                	addi	sp,sp,96
    5878:	8082                	ret

000000000000587a <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
    587a:	1141                	addi	sp,sp,-16
    587c:	e422                	sd	s0,8(sp)
    587e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
    5880:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5884:	00003797          	auipc	a5,0x3
    5888:	9147b783          	ld	a5,-1772(a5) # 8198 <freep>
    588c:	a805                	j	58bc <free+0x42>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
    588e:	4618                	lw	a4,8(a2)
    5890:	9db9                	addw	a1,a1,a4
    5892:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5896:	6398                	ld	a4,0(a5)
    5898:	6318                	ld	a4,0(a4)
    589a:	fee53823          	sd	a4,-16(a0)
    589e:	a091                	j	58e2 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
    58a0:	ff852703          	lw	a4,-8(a0)
    58a4:	9e39                	addw	a2,a2,a4
    58a6:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    58a8:	ff053703          	ld	a4,-16(a0)
    58ac:	e398                	sd	a4,0(a5)
    58ae:	a099                	j	58f4 <free+0x7a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    58b0:	6398                	ld	a4,0(a5)
    58b2:	00e7e463          	bltu	a5,a4,58ba <free+0x40>
    58b6:	00e6ea63          	bltu	a3,a4,58ca <free+0x50>
void free(void *ap) {
    58ba:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    58bc:	fed7fae3          	bgeu	a5,a3,58b0 <free+0x36>
    58c0:	6398                	ld	a4,0(a5)
    58c2:	00e6e463          	bltu	a3,a4,58ca <free+0x50>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    58c6:	fee7eae3          	bltu	a5,a4,58ba <free+0x40>
  if (bp + bp->s.size == p->s.ptr) {
    58ca:	ff852583          	lw	a1,-8(a0)
    58ce:	6390                	ld	a2,0(a5)
    58d0:	02059713          	slli	a4,a1,0x20
    58d4:	9301                	srli	a4,a4,0x20
    58d6:	0712                	slli	a4,a4,0x4
    58d8:	9736                	add	a4,a4,a3
    58da:	fae60ae3          	beq	a2,a4,588e <free+0x14>
    bp->s.ptr = p->s.ptr;
    58de:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
    58e2:	4790                	lw	a2,8(a5)
    58e4:	02061713          	slli	a4,a2,0x20
    58e8:	9301                	srli	a4,a4,0x20
    58ea:	0712                	slli	a4,a4,0x4
    58ec:	973e                	add	a4,a4,a5
    58ee:	fae689e3          	beq	a3,a4,58a0 <free+0x26>
  } else
    p->s.ptr = bp;
    58f2:	e394                	sd	a3,0(a5)
  freep = p;
    58f4:	00003717          	auipc	a4,0x3
    58f8:	8af73223          	sd	a5,-1884(a4) # 8198 <freep>
}
    58fc:	6422                	ld	s0,8(sp)
    58fe:	0141                	addi	sp,sp,16
    5900:	8082                	ret

0000000000005902 <malloc>:
  hp->s.size = nu;
  free((void *)(hp + 1));
  return freep;
}

void *malloc(uint nbytes) {
    5902:	7139                	addi	sp,sp,-64
    5904:	fc06                	sd	ra,56(sp)
    5906:	f822                	sd	s0,48(sp)
    5908:	f426                	sd	s1,40(sp)
    590a:	f04a                	sd	s2,32(sp)
    590c:	ec4e                	sd	s3,24(sp)
    590e:	e852                	sd	s4,16(sp)
    5910:	e456                	sd	s5,8(sp)
    5912:	e05a                	sd	s6,0(sp)
    5914:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
    5916:	02051493          	slli	s1,a0,0x20
    591a:	9081                	srli	s1,s1,0x20
    591c:	04bd                	addi	s1,s1,15
    591e:	8091                	srli	s1,s1,0x4
    5920:	0014899b          	addiw	s3,s1,1
    5924:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
    5926:	00003517          	auipc	a0,0x3
    592a:	87253503          	ld	a0,-1934(a0) # 8198 <freep>
    592e:	c515                	beqz	a0,595a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    5930:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    5932:	4798                	lw	a4,8(a5)
    5934:	02977f63          	bgeu	a4,s1,5972 <malloc+0x70>
    5938:	8a4e                	mv	s4,s3
    593a:	0009871b          	sext.w	a4,s3
    593e:	6685                	lui	a3,0x1
    5940:	00d77363          	bgeu	a4,a3,5946 <malloc+0x44>
    5944:	6a05                	lui	s4,0x1
    5946:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    594a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
    594e:	00003917          	auipc	s2,0x3
    5952:	84a90913          	addi	s2,s2,-1974 # 8198 <freep>
  if (p == (char *)-1)
    5956:	5afd                	li	s5,-1
    5958:	a88d                	j	59ca <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    595a:	00009797          	auipc	a5,0x9
    595e:	05e78793          	addi	a5,a5,94 # e9b8 <base>
    5962:	00003717          	auipc	a4,0x3
    5966:	82f73b23          	sd	a5,-1994(a4) # 8198 <freep>
    596a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    596c:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
    5970:	b7e1                	j	5938 <malloc+0x36>
      if (p->s.size == nunits)
    5972:	02e48b63          	beq	s1,a4,59a8 <malloc+0xa6>
        p->s.size -= nunits;
    5976:	4137073b          	subw	a4,a4,s3
    597a:	c798                	sw	a4,8(a5)
        p += p->s.size;
    597c:	1702                	slli	a4,a4,0x20
    597e:	9301                	srli	a4,a4,0x20
    5980:	0712                	slli	a4,a4,0x4
    5982:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5984:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5988:	00003717          	auipc	a4,0x3
    598c:	80a73823          	sd	a0,-2032(a4) # 8198 <freep>
      return (void *)(p + 1);
    5990:	01078513          	addi	a0,a5,16
      if ((p = morecore(nunits)) == 0)
        return 0;
  }
}
    5994:	70e2                	ld	ra,56(sp)
    5996:	7442                	ld	s0,48(sp)
    5998:	74a2                	ld	s1,40(sp)
    599a:	7902                	ld	s2,32(sp)
    599c:	69e2                	ld	s3,24(sp)
    599e:	6a42                	ld	s4,16(sp)
    59a0:	6aa2                	ld	s5,8(sp)
    59a2:	6b02                	ld	s6,0(sp)
    59a4:	6121                	addi	sp,sp,64
    59a6:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    59a8:	6398                	ld	a4,0(a5)
    59aa:	e118                	sd	a4,0(a0)
    59ac:	bff1                	j	5988 <malloc+0x86>
  hp->s.size = nu;
    59ae:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
    59b2:	0541                	addi	a0,a0,16
    59b4:	00000097          	auipc	ra,0x0
    59b8:	ec6080e7          	jalr	-314(ra) # 587a <free>
  return freep;
    59bc:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0)
    59c0:	d971                	beqz	a0,5994 <malloc+0x92>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    59c2:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    59c4:	4798                	lw	a4,8(a5)
    59c6:	fa9776e3          	bgeu	a4,s1,5972 <malloc+0x70>
    if (p == freep)
    59ca:	00093703          	ld	a4,0(s2)
    59ce:	853e                	mv	a0,a5
    59d0:	fef719e3          	bne	a4,a5,59c2 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    59d4:	8552                	mv	a0,s4
    59d6:	00000097          	auipc	ra,0x0
    59da:	b7e080e7          	jalr	-1154(ra) # 5554 <sbrk>
  if (p == (char *)-1)
    59de:	fd5518e3          	bne	a0,s5,59ae <malloc+0xac>
        return 0;
    59e2:	4501                	li	a0,0
    59e4:	bf45                	j	5994 <malloc+0x92>

00000000000059e6 <mem_init>:
  page_t *next_page;
} allocator_t;

static allocator_t alloc;
static int if_init = 0;
void mem_init() {
    59e6:	1141                	addi	sp,sp,-16
    59e8:	e406                	sd	ra,8(sp)
    59ea:	e022                	sd	s0,0(sp)
    59ec:	0800                	addi	s0,sp,16
  alloc.next_page = (page_t *)sbrk(PGSIZE);
    59ee:	6505                	lui	a0,0x1
    59f0:	00000097          	auipc	ra,0x0
    59f4:	b64080e7          	jalr	-1180(ra) # 5554 <sbrk>
    59f8:	00002797          	auipc	a5,0x2
    59fc:	78a7bc23          	sd	a0,1944(a5) # 8190 <alloc>
  page_t *p = (page_t *)alloc.next_page;
  p->cur = (void *)p + sizeof(page_t);
    5a00:	00850793          	addi	a5,a0,8 # 1008 <bigdir+0x13c>
    5a04:	e11c                	sd	a5,0(a0)
}
    5a06:	60a2                	ld	ra,8(sp)
    5a08:	6402                	ld	s0,0(sp)
    5a0a:	0141                	addi	sp,sp,16
    5a0c:	8082                	ret

0000000000005a0e <l_alloc>:

void *l_alloc(u32 size) {
    5a0e:	1101                	addi	sp,sp,-32
    5a10:	ec06                	sd	ra,24(sp)
    5a12:	e822                	sd	s0,16(sp)
    5a14:	e426                	sd	s1,8(sp)
    5a16:	1000                	addi	s0,sp,32
    5a18:	84aa                	mv	s1,a0
  if (!if_init) {
    5a1a:	00002797          	auipc	a5,0x2
    5a1e:	76e7a783          	lw	a5,1902(a5) # 8188 <if_init>
    5a22:	c795                	beqz	a5,5a4e <l_alloc+0x40>
    mem_init();
    if_init = 1;
  }
  void *res = 0;
  u32 avail = PGSIZE - (alloc.next_page->cur - (void *)(alloc.next_page)) -
    5a24:	00002717          	auipc	a4,0x2
    5a28:	76c73703          	ld	a4,1900(a4) # 8190 <alloc>
    5a2c:	6308                	ld	a0,0(a4)
    5a2e:	40e506b3          	sub	a3,a0,a4
              sizeof(page_t);
  if (avail > size) {
    5a32:	6785                	lui	a5,0x1
    5a34:	37e1                	addiw	a5,a5,-8
    5a36:	9f95                	subw	a5,a5,a3
    5a38:	02f4f563          	bgeu	s1,a5,5a62 <l_alloc+0x54>
    res = alloc.next_page->cur;
    alloc.next_page->cur += size;
    5a3c:	1482                	slli	s1,s1,0x20
    5a3e:	9081                	srli	s1,s1,0x20
    5a40:	94aa                	add	s1,s1,a0
    5a42:	e304                	sd	s1,0(a4)
  } else {
    return 0;
  }
  return res;
}
    5a44:	60e2                	ld	ra,24(sp)
    5a46:	6442                	ld	s0,16(sp)
    5a48:	64a2                	ld	s1,8(sp)
    5a4a:	6105                	addi	sp,sp,32
    5a4c:	8082                	ret
    mem_init();
    5a4e:	00000097          	auipc	ra,0x0
    5a52:	f98080e7          	jalr	-104(ra) # 59e6 <mem_init>
    if_init = 1;
    5a56:	4785                	li	a5,1
    5a58:	00002717          	auipc	a4,0x2
    5a5c:	72f72823          	sw	a5,1840(a4) # 8188 <if_init>
    5a60:	b7d1                	j	5a24 <l_alloc+0x16>
    return 0;
    5a62:	4501                	li	a0,0
    5a64:	b7c5                	j	5a44 <l_alloc+0x36>

0000000000005a66 <l_free>:

    5a66:	1141                	addi	sp,sp,-16
    5a68:	e422                	sd	s0,8(sp)
    5a6a:	0800                	addi	s0,sp,16
    5a6c:	6422                	ld	s0,8(sp)
    5a6e:	0141                	addi	sp,sp,16
    5a70:	8082                	ret
