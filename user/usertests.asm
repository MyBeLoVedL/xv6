
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
      14:	4dc080e7          	jalr	1244(ra) # 54ec <open>
    if (fd >= 0) {
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE | O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00005097          	auipc	ra,0x5
      26:	4ca080e7          	jalr	1226(ra) # 54ec <open>
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
      42:	d3250513          	addi	a0,a0,-718 # 5d70 <l_free+0x32a>
      46:	00005097          	auipc	ra,0x5
      4a:	7de080e7          	jalr	2014(ra) # 5824 <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00005097          	auipc	ra,0x5
      54:	45c080e7          	jalr	1116(ra) # 54ac <exit>

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
      84:	d1050513          	addi	a0,a0,-752 # 5d90 <l_free+0x34a>
      88:	00005097          	auipc	ra,0x5
      8c:	79c080e7          	jalr	1948(ra) # 5824 <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00005097          	auipc	ra,0x5
      96:	41a080e7          	jalr	1050(ra) # 54ac <exit>

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
      ac:	d0050513          	addi	a0,a0,-768 # 5da8 <l_free+0x362>
      b0:	00005097          	auipc	ra,0x5
      b4:	43c080e7          	jalr	1084(ra) # 54ec <open>
  if (fd < 0) {
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00005097          	auipc	ra,0x5
      c0:	418080e7          	jalr	1048(ra) # 54d4 <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	d0250513          	addi	a0,a0,-766 # 5dc8 <l_free+0x382>
      ce:	00005097          	auipc	ra,0x5
      d2:	41e080e7          	jalr	1054(ra) # 54ec <open>
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
      ea:	cca50513          	addi	a0,a0,-822 # 5db0 <l_free+0x36a>
      ee:	00005097          	auipc	ra,0x5
      f2:	736080e7          	jalr	1846(ra) # 5824 <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00005097          	auipc	ra,0x5
      fc:	3b4080e7          	jalr	948(ra) # 54ac <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	cd650513          	addi	a0,a0,-810 # 5dd8 <l_free+0x392>
     10a:	00005097          	auipc	ra,0x5
     10e:	71a080e7          	jalr	1818(ra) # 5824 <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00005097          	auipc	ra,0x5
     118:	398080e7          	jalr	920(ra) # 54ac <exit>

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
     130:	cd450513          	addi	a0,a0,-812 # 5e00 <l_free+0x3ba>
     134:	00005097          	auipc	ra,0x5
     138:	3c8080e7          	jalr	968(ra) # 54fc <unlink>
  int fd1 = open("truncfile", O_CREATE | O_TRUNC | O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	cc050513          	addi	a0,a0,-832 # 5e00 <l_free+0x3ba>
     148:	00005097          	auipc	ra,0x5
     14c:	3a4080e7          	jalr	932(ra) # 54ec <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	cbc58593          	addi	a1,a1,-836 # 5e10 <l_free+0x3ca>
     15c:	00005097          	auipc	ra,0x5
     160:	370080e7          	jalr	880(ra) # 54cc <write>
  int fd2 = open("truncfile", O_TRUNC | O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	c9850513          	addi	a0,a0,-872 # 5e00 <l_free+0x3ba>
     170:	00005097          	auipc	ra,0x5
     174:	37c080e7          	jalr	892(ra) # 54ec <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	c9c58593          	addi	a1,a1,-868 # 5e18 <l_free+0x3d2>
     184:	8526                	mv	a0,s1
     186:	00005097          	auipc	ra,0x5
     18a:	346080e7          	jalr	838(ra) # 54cc <write>
  if (n != -1) {
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	c6c50513          	addi	a0,a0,-916 # 5e00 <l_free+0x3ba>
     19c:	00005097          	auipc	ra,0x5
     1a0:	360080e7          	jalr	864(ra) # 54fc <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00005097          	auipc	ra,0x5
     1aa:	32e080e7          	jalr	814(ra) # 54d4 <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00005097          	auipc	ra,0x5
     1b4:	324080e7          	jalr	804(ra) # 54d4 <close>
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
     1ce:	c5650513          	addi	a0,a0,-938 # 5e20 <l_free+0x3da>
     1d2:	00005097          	auipc	ra,0x5
     1d6:	652080e7          	jalr	1618(ra) # 5824 <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00005097          	auipc	ra,0x5
     1e0:	2d0080e7          	jalr	720(ra) # 54ac <exit>

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
     21e:	2d2080e7          	jalr	722(ra) # 54ec <open>
    close(fd);
     222:	00005097          	auipc	ra,0x5
     226:	2b2080e7          	jalr	690(ra) # 54d4 <close>
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
     25c:	2a4080e7          	jalr	676(ra) # 54fc <unlink>
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
     294:	99050513          	addi	a0,a0,-1648 # 5c20 <l_free+0x1da>
     298:	00005097          	auipc	ra,0x5
     29c:	264080e7          	jalr	612(ra) # 54fc <unlink>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     2a0:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a4:	00006a97          	auipc	s5,0x6
     2a8:	97ca8a93          	addi	s5,s5,-1668 # 5c20 <l_free+0x1da>
      int cc = write(fd, buf, sz);
     2ac:	0000ba17          	auipc	s4,0xb
     2b0:	70ca0a13          	addi	s4,s4,1804 # b9b8 <buf>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     2b4:	6b0d                	lui	s6,0x3
     2b6:	1c9b0b13          	addi	s6,s6,457 # 31c9 <subdir+0x409>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2ba:	20200593          	li	a1,514
     2be:	8556                	mv	a0,s5
     2c0:	00005097          	auipc	ra,0x5
     2c4:	22c080e7          	jalr	556(ra) # 54ec <open>
     2c8:	892a                	mv	s2,a0
    if (fd < 0) {
     2ca:	04054d63          	bltz	a0,324 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ce:	8626                	mv	a2,s1
     2d0:	85d2                	mv	a1,s4
     2d2:	00005097          	auipc	ra,0x5
     2d6:	1fa080e7          	jalr	506(ra) # 54cc <write>
     2da:	89aa                	mv	s3,a0
      if (cc != sz) {
     2dc:	06a49463          	bne	s1,a0,344 <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
     2e0:	8626                	mv	a2,s1
     2e2:	85d2                	mv	a1,s4
     2e4:	854a                	mv	a0,s2
     2e6:	00005097          	auipc	ra,0x5
     2ea:	1e6080e7          	jalr	486(ra) # 54cc <write>
      if (cc != sz) {
     2ee:	04951963          	bne	a0,s1,340 <bigwrite+0xc8>
    close(fd);
     2f2:	854a                	mv	a0,s2
     2f4:	00005097          	auipc	ra,0x5
     2f8:	1e0080e7          	jalr	480(ra) # 54d4 <close>
    unlink("bigwrite");
     2fc:	8556                	mv	a0,s5
     2fe:	00005097          	auipc	ra,0x5
     302:	1fe080e7          	jalr	510(ra) # 54fc <unlink>
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
     32a:	b2250513          	addi	a0,a0,-1246 # 5e48 <l_free+0x402>
     32e:	00005097          	auipc	ra,0x5
     332:	4f6080e7          	jalr	1270(ra) # 5824 <printf>
      exit(1);
     336:	4505                	li	a0,1
     338:	00005097          	auipc	ra,0x5
     33c:	174080e7          	jalr	372(ra) # 54ac <exit>
     340:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     342:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     344:	86ce                	mv	a3,s3
     346:	8626                	mv	a2,s1
     348:	85de                	mv	a1,s7
     34a:	00006517          	auipc	a0,0x6
     34e:	b1e50513          	addi	a0,a0,-1250 # 5e68 <l_free+0x422>
     352:	00005097          	auipc	ra,0x5
     356:	4d2080e7          	jalr	1234(ra) # 5824 <printf>
        exit(1);
     35a:	4505                	li	a0,1
     35c:	00005097          	auipc	ra,0x5
     360:	150080e7          	jalr	336(ra) # 54ac <exit>

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
     378:	b0c50513          	addi	a0,a0,-1268 # 5e80 <l_free+0x43a>
     37c:	00005097          	auipc	ra,0x5
     380:	180080e7          	jalr	384(ra) # 54fc <unlink>
     384:	25800913          	li	s2,600
  for (int i = 0; i < assumed_free; i++) {
    int fd = open("junk", O_CREATE | O_WRONLY);
     388:	00006997          	auipc	s3,0x6
     38c:	af898993          	addi	s3,s3,-1288 # 5e80 <l_free+0x43a>
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
     3a0:	150080e7          	jalr	336(ra) # 54ec <open>
     3a4:	84aa                	mv	s1,a0
    if (fd < 0) {
     3a6:	06054b63          	bltz	a0,41c <badwrite+0xb8>
    write(fd, (char *)0xffffffffffL, 1);
     3aa:	4605                	li	a2,1
     3ac:	85d2                	mv	a1,s4
     3ae:	00005097          	auipc	ra,0x5
     3b2:	11e080e7          	jalr	286(ra) # 54cc <write>
    close(fd);
     3b6:	8526                	mv	a0,s1
     3b8:	00005097          	auipc	ra,0x5
     3bc:	11c080e7          	jalr	284(ra) # 54d4 <close>
    unlink("junk");
     3c0:	854e                	mv	a0,s3
     3c2:	00005097          	auipc	ra,0x5
     3c6:	13a080e7          	jalr	314(ra) # 54fc <unlink>
  for (int i = 0; i < assumed_free; i++) {
     3ca:	397d                	addiw	s2,s2,-1
     3cc:	fc0915e3          	bnez	s2,396 <badwrite+0x32>
  }

  int fd = open("junk", O_CREATE | O_WRONLY);
     3d0:	20100593          	li	a1,513
     3d4:	00006517          	auipc	a0,0x6
     3d8:	aac50513          	addi	a0,a0,-1364 # 5e80 <l_free+0x43a>
     3dc:	00005097          	auipc	ra,0x5
     3e0:	110080e7          	jalr	272(ra) # 54ec <open>
     3e4:	84aa                	mv	s1,a0
  if (fd < 0) {
     3e6:	04054863          	bltz	a0,436 <badwrite+0xd2>
    printf("open junk failed\n");
    exit(1);
  }
  if (write(fd, "x", 1) != 1) {
     3ea:	4605                	li	a2,1
     3ec:	00006597          	auipc	a1,0x6
     3f0:	a2c58593          	addi	a1,a1,-1492 # 5e18 <l_free+0x3d2>
     3f4:	00005097          	auipc	ra,0x5
     3f8:	0d8080e7          	jalr	216(ra) # 54cc <write>
     3fc:	4785                	li	a5,1
     3fe:	04f50963          	beq	a0,a5,450 <badwrite+0xec>
    printf("write failed\n");
     402:	00006517          	auipc	a0,0x6
     406:	a9e50513          	addi	a0,a0,-1378 # 5ea0 <l_free+0x45a>
     40a:	00005097          	auipc	ra,0x5
     40e:	41a080e7          	jalr	1050(ra) # 5824 <printf>
    exit(1);
     412:	4505                	li	a0,1
     414:	00005097          	auipc	ra,0x5
     418:	098080e7          	jalr	152(ra) # 54ac <exit>
      printf("open junk failed\n");
     41c:	00006517          	auipc	a0,0x6
     420:	a6c50513          	addi	a0,a0,-1428 # 5e88 <l_free+0x442>
     424:	00005097          	auipc	ra,0x5
     428:	400080e7          	jalr	1024(ra) # 5824 <printf>
      exit(1);
     42c:	4505                	li	a0,1
     42e:	00005097          	auipc	ra,0x5
     432:	07e080e7          	jalr	126(ra) # 54ac <exit>
    printf("open junk failed\n");
     436:	00006517          	auipc	a0,0x6
     43a:	a5250513          	addi	a0,a0,-1454 # 5e88 <l_free+0x442>
     43e:	00005097          	auipc	ra,0x5
     442:	3e6080e7          	jalr	998(ra) # 5824 <printf>
    exit(1);
     446:	4505                	li	a0,1
     448:	00005097          	auipc	ra,0x5
     44c:	064080e7          	jalr	100(ra) # 54ac <exit>
  }
  close(fd);
     450:	8526                	mv	a0,s1
     452:	00005097          	auipc	ra,0x5
     456:	082080e7          	jalr	130(ra) # 54d4 <close>
  unlink("junk");
     45a:	00006517          	auipc	a0,0x6
     45e:	a2650513          	addi	a0,a0,-1498 # 5e80 <l_free+0x43a>
     462:	00005097          	auipc	ra,0x5
     466:	09a080e7          	jalr	154(ra) # 54fc <unlink>

  exit(0);
     46a:	4501                	li	a0,0
     46c:	00005097          	auipc	ra,0x5
     470:	040080e7          	jalr	64(ra) # 54ac <exit>

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
     49a:	a1aa0a13          	addi	s4,s4,-1510 # 5eb0 <l_free+0x46a>
    uint64 addr = addrs[ai];
     49e:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE | O_WRONLY);
     4a2:	20100593          	li	a1,513
     4a6:	8552                	mv	a0,s4
     4a8:	00005097          	auipc	ra,0x5
     4ac:	044080e7          	jalr	68(ra) # 54ec <open>
     4b0:	84aa                	mv	s1,a0
    if (fd < 0) {
     4b2:	08054863          	bltz	a0,542 <copyin+0xce>
    int n = write(fd, (void *)addr, 8192);
     4b6:	6609                	lui	a2,0x2
     4b8:	85ce                	mv	a1,s3
     4ba:	00005097          	auipc	ra,0x5
     4be:	012080e7          	jalr	18(ra) # 54cc <write>
    if (n >= 0) {
     4c2:	08055d63          	bgez	a0,55c <copyin+0xe8>
    close(fd);
     4c6:	8526                	mv	a0,s1
     4c8:	00005097          	auipc	ra,0x5
     4cc:	00c080e7          	jalr	12(ra) # 54d4 <close>
    unlink("copyin1");
     4d0:	8552                	mv	a0,s4
     4d2:	00005097          	auipc	ra,0x5
     4d6:	02a080e7          	jalr	42(ra) # 54fc <unlink>
    n = write(1, (char *)addr, 8192);
     4da:	6609                	lui	a2,0x2
     4dc:	85ce                	mv	a1,s3
     4de:	4505                	li	a0,1
     4e0:	00005097          	auipc	ra,0x5
     4e4:	fec080e7          	jalr	-20(ra) # 54cc <write>
    if (n > 0) {
     4e8:	08a04963          	bgtz	a0,57a <copyin+0x106>
    if (pipe(fds) < 0) {
     4ec:	fb840513          	addi	a0,s0,-72
     4f0:	00005097          	auipc	ra,0x5
     4f4:	fcc080e7          	jalr	-52(ra) # 54bc <pipe>
     4f8:	0a054063          	bltz	a0,598 <copyin+0x124>
    n = write(fds[1], (char *)addr, 8192);
     4fc:	6609                	lui	a2,0x2
     4fe:	85ce                	mv	a1,s3
     500:	fbc42503          	lw	a0,-68(s0)
     504:	00005097          	auipc	ra,0x5
     508:	fc8080e7          	jalr	-56(ra) # 54cc <write>
    if (n > 0) {
     50c:	0aa04363          	bgtz	a0,5b2 <copyin+0x13e>
    close(fds[0]);
     510:	fb842503          	lw	a0,-72(s0)
     514:	00005097          	auipc	ra,0x5
     518:	fc0080e7          	jalr	-64(ra) # 54d4 <close>
    close(fds[1]);
     51c:	fbc42503          	lw	a0,-68(s0)
     520:	00005097          	auipc	ra,0x5
     524:	fb4080e7          	jalr	-76(ra) # 54d4 <close>
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
     546:	97650513          	addi	a0,a0,-1674 # 5eb8 <l_free+0x472>
     54a:	00005097          	auipc	ra,0x5
     54e:	2da080e7          	jalr	730(ra) # 5824 <printf>
      exit(1);
     552:	4505                	li	a0,1
     554:	00005097          	auipc	ra,0x5
     558:	f58080e7          	jalr	-168(ra) # 54ac <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     55c:	862a                	mv	a2,a0
     55e:	85ce                	mv	a1,s3
     560:	00006517          	auipc	a0,0x6
     564:	97050513          	addi	a0,a0,-1680 # 5ed0 <l_free+0x48a>
     568:	00005097          	auipc	ra,0x5
     56c:	2bc080e7          	jalr	700(ra) # 5824 <printf>
      exit(1);
     570:	4505                	li	a0,1
     572:	00005097          	auipc	ra,0x5
     576:	f3a080e7          	jalr	-198(ra) # 54ac <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     57a:	862a                	mv	a2,a0
     57c:	85ce                	mv	a1,s3
     57e:	00006517          	auipc	a0,0x6
     582:	98250513          	addi	a0,a0,-1662 # 5f00 <l_free+0x4ba>
     586:	00005097          	auipc	ra,0x5
     58a:	29e080e7          	jalr	670(ra) # 5824 <printf>
      exit(1);
     58e:	4505                	li	a0,1
     590:	00005097          	auipc	ra,0x5
     594:	f1c080e7          	jalr	-228(ra) # 54ac <exit>
      printf("pipe() failed\n");
     598:	00006517          	auipc	a0,0x6
     59c:	99850513          	addi	a0,a0,-1640 # 5f30 <l_free+0x4ea>
     5a0:	00005097          	auipc	ra,0x5
     5a4:	284080e7          	jalr	644(ra) # 5824 <printf>
      exit(1);
     5a8:	4505                	li	a0,1
     5aa:	00005097          	auipc	ra,0x5
     5ae:	f02080e7          	jalr	-254(ra) # 54ac <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5b2:	862a                	mv	a2,a0
     5b4:	85ce                	mv	a1,s3
     5b6:	00006517          	auipc	a0,0x6
     5ba:	98a50513          	addi	a0,a0,-1654 # 5f40 <l_free+0x4fa>
     5be:	00005097          	auipc	ra,0x5
     5c2:	266080e7          	jalr	614(ra) # 5824 <printf>
      exit(1);
     5c6:	4505                	li	a0,1
     5c8:	00005097          	auipc	ra,0x5
     5cc:	ee4080e7          	jalr	-284(ra) # 54ac <exit>

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
     5f8:	97ca0a13          	addi	s4,s4,-1668 # 5f70 <l_free+0x52a>
    n = write(fds[1], "x", 1);
     5fc:	00006a97          	auipc	s5,0x6
     600:	81ca8a93          	addi	s5,s5,-2020 # 5e18 <l_free+0x3d2>
    uint64 addr = addrs[ai];
     604:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     608:	4581                	li	a1,0
     60a:	8552                	mv	a0,s4
     60c:	00005097          	auipc	ra,0x5
     610:	ee0080e7          	jalr	-288(ra) # 54ec <open>
     614:	84aa                	mv	s1,a0
    if (fd < 0) {
     616:	08054663          	bltz	a0,6a2 <copyout+0xd2>
    int n = read(fd, (void *)addr, 8192);
     61a:	6609                	lui	a2,0x2
     61c:	85ce                	mv	a1,s3
     61e:	00005097          	auipc	ra,0x5
     622:	ea6080e7          	jalr	-346(ra) # 54c4 <read>
    if (n > 0) {
     626:	08a04b63          	bgtz	a0,6bc <copyout+0xec>
    close(fd);
     62a:	8526                	mv	a0,s1
     62c:	00005097          	auipc	ra,0x5
     630:	ea8080e7          	jalr	-344(ra) # 54d4 <close>
    if (pipe(fds) < 0) {
     634:	fa840513          	addi	a0,s0,-88
     638:	00005097          	auipc	ra,0x5
     63c:	e84080e7          	jalr	-380(ra) # 54bc <pipe>
     640:	08054d63          	bltz	a0,6da <copyout+0x10a>
    n = write(fds[1], "x", 1);
     644:	4605                	li	a2,1
     646:	85d6                	mv	a1,s5
     648:	fac42503          	lw	a0,-84(s0)
     64c:	00005097          	auipc	ra,0x5
     650:	e80080e7          	jalr	-384(ra) # 54cc <write>
    if (n != 1) {
     654:	4785                	li	a5,1
     656:	08f51f63          	bne	a0,a5,6f4 <copyout+0x124>
    n = read(fds[0], (void *)addr, 8192);
     65a:	6609                	lui	a2,0x2
     65c:	85ce                	mv	a1,s3
     65e:	fa842503          	lw	a0,-88(s0)
     662:	00005097          	auipc	ra,0x5
     666:	e62080e7          	jalr	-414(ra) # 54c4 <read>
    if (n > 0) {
     66a:	0aa04263          	bgtz	a0,70e <copyout+0x13e>
    close(fds[0]);
     66e:	fa842503          	lw	a0,-88(s0)
     672:	00005097          	auipc	ra,0x5
     676:	e62080e7          	jalr	-414(ra) # 54d4 <close>
    close(fds[1]);
     67a:	fac42503          	lw	a0,-84(s0)
     67e:	00005097          	auipc	ra,0x5
     682:	e56080e7          	jalr	-426(ra) # 54d4 <close>
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
     6a6:	8d650513          	addi	a0,a0,-1834 # 5f78 <l_free+0x532>
     6aa:	00005097          	auipc	ra,0x5
     6ae:	17a080e7          	jalr	378(ra) # 5824 <printf>
      exit(1);
     6b2:	4505                	li	a0,1
     6b4:	00005097          	auipc	ra,0x5
     6b8:	df8080e7          	jalr	-520(ra) # 54ac <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     6bc:	862a                	mv	a2,a0
     6be:	85ce                	mv	a1,s3
     6c0:	00006517          	auipc	a0,0x6
     6c4:	8d050513          	addi	a0,a0,-1840 # 5f90 <l_free+0x54a>
     6c8:	00005097          	auipc	ra,0x5
     6cc:	15c080e7          	jalr	348(ra) # 5824 <printf>
      exit(1);
     6d0:	4505                	li	a0,1
     6d2:	00005097          	auipc	ra,0x5
     6d6:	dda080e7          	jalr	-550(ra) # 54ac <exit>
      printf("pipe() failed\n");
     6da:	00006517          	auipc	a0,0x6
     6de:	85650513          	addi	a0,a0,-1962 # 5f30 <l_free+0x4ea>
     6e2:	00005097          	auipc	ra,0x5
     6e6:	142080e7          	jalr	322(ra) # 5824 <printf>
      exit(1);
     6ea:	4505                	li	a0,1
     6ec:	00005097          	auipc	ra,0x5
     6f0:	dc0080e7          	jalr	-576(ra) # 54ac <exit>
      printf("pipe write failed\n");
     6f4:	00006517          	auipc	a0,0x6
     6f8:	8cc50513          	addi	a0,a0,-1844 # 5fc0 <l_free+0x57a>
     6fc:	00005097          	auipc	ra,0x5
     700:	128080e7          	jalr	296(ra) # 5824 <printf>
      exit(1);
     704:	4505                	li	a0,1
     706:	00005097          	auipc	ra,0x5
     70a:	da6080e7          	jalr	-602(ra) # 54ac <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     70e:	862a                	mv	a2,a0
     710:	85ce                	mv	a1,s3
     712:	00006517          	auipc	a0,0x6
     716:	8c650513          	addi	a0,a0,-1850 # 5fd8 <l_free+0x592>
     71a:	00005097          	auipc	ra,0x5
     71e:	10a080e7          	jalr	266(ra) # 5824 <printf>
      exit(1);
     722:	4505                	li	a0,1
     724:	00005097          	auipc	ra,0x5
     728:	d88080e7          	jalr	-632(ra) # 54ac <exit>

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
     744:	6c050513          	addi	a0,a0,1728 # 5e00 <l_free+0x3ba>
     748:	00005097          	auipc	ra,0x5
     74c:	db4080e7          	jalr	-588(ra) # 54fc <unlink>
  int fd1 = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
     750:	60100593          	li	a1,1537
     754:	00005517          	auipc	a0,0x5
     758:	6ac50513          	addi	a0,a0,1708 # 5e00 <l_free+0x3ba>
     75c:	00005097          	auipc	ra,0x5
     760:	d90080e7          	jalr	-624(ra) # 54ec <open>
     764:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     766:	4611                	li	a2,4
     768:	00005597          	auipc	a1,0x5
     76c:	6a858593          	addi	a1,a1,1704 # 5e10 <l_free+0x3ca>
     770:	00005097          	auipc	ra,0x5
     774:	d5c080e7          	jalr	-676(ra) # 54cc <write>
  close(fd1);
     778:	8526                	mv	a0,s1
     77a:	00005097          	auipc	ra,0x5
     77e:	d5a080e7          	jalr	-678(ra) # 54d4 <close>
  int fd2 = open("truncfile", O_RDONLY);
     782:	4581                	li	a1,0
     784:	00005517          	auipc	a0,0x5
     788:	67c50513          	addi	a0,a0,1660 # 5e00 <l_free+0x3ba>
     78c:	00005097          	auipc	ra,0x5
     790:	d60080e7          	jalr	-672(ra) # 54ec <open>
     794:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     796:	02000613          	li	a2,32
     79a:	fa040593          	addi	a1,s0,-96
     79e:	00005097          	auipc	ra,0x5
     7a2:	d26080e7          	jalr	-730(ra) # 54c4 <read>
  if (n != 4) {
     7a6:	4791                	li	a5,4
     7a8:	0cf51e63          	bne	a0,a5,884 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY | O_TRUNC);
     7ac:	40100593          	li	a1,1025
     7b0:	00005517          	auipc	a0,0x5
     7b4:	65050513          	addi	a0,a0,1616 # 5e00 <l_free+0x3ba>
     7b8:	00005097          	auipc	ra,0x5
     7bc:	d34080e7          	jalr	-716(ra) # 54ec <open>
     7c0:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     7c2:	4581                	li	a1,0
     7c4:	00005517          	auipc	a0,0x5
     7c8:	63c50513          	addi	a0,a0,1596 # 5e00 <l_free+0x3ba>
     7cc:	00005097          	auipc	ra,0x5
     7d0:	d20080e7          	jalr	-736(ra) # 54ec <open>
     7d4:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     7d6:	02000613          	li	a2,32
     7da:	fa040593          	addi	a1,s0,-96
     7de:	00005097          	auipc	ra,0x5
     7e2:	ce6080e7          	jalr	-794(ra) # 54c4 <read>
     7e6:	8a2a                	mv	s4,a0
  if (n != 0) {
     7e8:	ed4d                	bnez	a0,8a2 <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     7ea:	02000613          	li	a2,32
     7ee:	fa040593          	addi	a1,s0,-96
     7f2:	8526                	mv	a0,s1
     7f4:	00005097          	auipc	ra,0x5
     7f8:	cd0080e7          	jalr	-816(ra) # 54c4 <read>
     7fc:	8a2a                	mv	s4,a0
  if (n != 0) {
     7fe:	e971                	bnez	a0,8d2 <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     800:	4619                	li	a2,6
     802:	00006597          	auipc	a1,0x6
     806:	86658593          	addi	a1,a1,-1946 # 6068 <l_free+0x622>
     80a:	854e                	mv	a0,s3
     80c:	00005097          	auipc	ra,0x5
     810:	cc0080e7          	jalr	-832(ra) # 54cc <write>
  n = read(fd3, buf, sizeof(buf));
     814:	02000613          	li	a2,32
     818:	fa040593          	addi	a1,s0,-96
     81c:	854a                	mv	a0,s2
     81e:	00005097          	auipc	ra,0x5
     822:	ca6080e7          	jalr	-858(ra) # 54c4 <read>
  if (n != 6) {
     826:	4799                	li	a5,6
     828:	0cf51d63          	bne	a0,a5,902 <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     82c:	02000613          	li	a2,32
     830:	fa040593          	addi	a1,s0,-96
     834:	8526                	mv	a0,s1
     836:	00005097          	auipc	ra,0x5
     83a:	c8e080e7          	jalr	-882(ra) # 54c4 <read>
  if (n != 2) {
     83e:	4789                	li	a5,2
     840:	0ef51063          	bne	a0,a5,920 <truncate1+0x1f4>
  unlink("truncfile");
     844:	00005517          	auipc	a0,0x5
     848:	5bc50513          	addi	a0,a0,1468 # 5e00 <l_free+0x3ba>
     84c:	00005097          	auipc	ra,0x5
     850:	cb0080e7          	jalr	-848(ra) # 54fc <unlink>
  close(fd1);
     854:	854e                	mv	a0,s3
     856:	00005097          	auipc	ra,0x5
     85a:	c7e080e7          	jalr	-898(ra) # 54d4 <close>
  close(fd2);
     85e:	8526                	mv	a0,s1
     860:	00005097          	auipc	ra,0x5
     864:	c74080e7          	jalr	-908(ra) # 54d4 <close>
  close(fd3);
     868:	854a                	mv	a0,s2
     86a:	00005097          	auipc	ra,0x5
     86e:	c6a080e7          	jalr	-918(ra) # 54d4 <close>
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
     88c:	78050513          	addi	a0,a0,1920 # 6008 <l_free+0x5c2>
     890:	00005097          	auipc	ra,0x5
     894:	f94080e7          	jalr	-108(ra) # 5824 <printf>
    exit(1);
     898:	4505                	li	a0,1
     89a:	00005097          	auipc	ra,0x5
     89e:	c12080e7          	jalr	-1006(ra) # 54ac <exit>
    printf("aaa fd3=%d\n", fd3);
     8a2:	85ca                	mv	a1,s2
     8a4:	00005517          	auipc	a0,0x5
     8a8:	78450513          	addi	a0,a0,1924 # 6028 <l_free+0x5e2>
     8ac:	00005097          	auipc	ra,0x5
     8b0:	f78080e7          	jalr	-136(ra) # 5824 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     8b4:	8652                	mv	a2,s4
     8b6:	85d6                	mv	a1,s5
     8b8:	00005517          	auipc	a0,0x5
     8bc:	78050513          	addi	a0,a0,1920 # 6038 <l_free+0x5f2>
     8c0:	00005097          	auipc	ra,0x5
     8c4:	f64080e7          	jalr	-156(ra) # 5824 <printf>
    exit(1);
     8c8:	4505                	li	a0,1
     8ca:	00005097          	auipc	ra,0x5
     8ce:	be2080e7          	jalr	-1054(ra) # 54ac <exit>
    printf("bbb fd2=%d\n", fd2);
     8d2:	85a6                	mv	a1,s1
     8d4:	00005517          	auipc	a0,0x5
     8d8:	78450513          	addi	a0,a0,1924 # 6058 <l_free+0x612>
     8dc:	00005097          	auipc	ra,0x5
     8e0:	f48080e7          	jalr	-184(ra) # 5824 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     8e4:	8652                	mv	a2,s4
     8e6:	85d6                	mv	a1,s5
     8e8:	00005517          	auipc	a0,0x5
     8ec:	75050513          	addi	a0,a0,1872 # 6038 <l_free+0x5f2>
     8f0:	00005097          	auipc	ra,0x5
     8f4:	f34080e7          	jalr	-204(ra) # 5824 <printf>
    exit(1);
     8f8:	4505                	li	a0,1
     8fa:	00005097          	auipc	ra,0x5
     8fe:	bb2080e7          	jalr	-1102(ra) # 54ac <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     902:	862a                	mv	a2,a0
     904:	85d6                	mv	a1,s5
     906:	00005517          	auipc	a0,0x5
     90a:	76a50513          	addi	a0,a0,1898 # 6070 <l_free+0x62a>
     90e:	00005097          	auipc	ra,0x5
     912:	f16080e7          	jalr	-234(ra) # 5824 <printf>
    exit(1);
     916:	4505                	li	a0,1
     918:	00005097          	auipc	ra,0x5
     91c:	b94080e7          	jalr	-1132(ra) # 54ac <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     920:	862a                	mv	a2,a0
     922:	85d6                	mv	a1,s5
     924:	00005517          	auipc	a0,0x5
     928:	76c50513          	addi	a0,a0,1900 # 6090 <l_free+0x64a>
     92c:	00005097          	auipc	ra,0x5
     930:	ef8080e7          	jalr	-264(ra) # 5824 <printf>
    exit(1);
     934:	4505                	li	a0,1
     936:	00005097          	auipc	ra,0x5
     93a:	b76080e7          	jalr	-1162(ra) # 54ac <exit>

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
     95c:	75850513          	addi	a0,a0,1880 # 60b0 <l_free+0x66a>
     960:	00005097          	auipc	ra,0x5
     964:	b8c080e7          	jalr	-1140(ra) # 54ec <open>
  if (fd < 0) {
     968:	0a054d63          	bltz	a0,a22 <writetest+0xe4>
     96c:	892a                	mv	s2,a0
     96e:	4481                	li	s1,0
    if (write(fd, "aaaaaaaaaa", SZ) != SZ) {
     970:	00005997          	auipc	s3,0x5
     974:	76898993          	addi	s3,s3,1896 # 60d8 <l_free+0x692>
    if (write(fd, "bbbbbbbbbb", SZ) != SZ) {
     978:	00005a97          	auipc	s5,0x5
     97c:	798a8a93          	addi	s5,s5,1944 # 6110 <l_free+0x6ca>
  for (i = 0; i < N; i++) {
     980:	06400a13          	li	s4,100
    if (write(fd, "aaaaaaaaaa", SZ) != SZ) {
     984:	4629                	li	a2,10
     986:	85ce                	mv	a1,s3
     988:	854a                	mv	a0,s2
     98a:	00005097          	auipc	ra,0x5
     98e:	b42080e7          	jalr	-1214(ra) # 54cc <write>
     992:	47a9                	li	a5,10
     994:	0af51563          	bne	a0,a5,a3e <writetest+0x100>
    if (write(fd, "bbbbbbbbbb", SZ) != SZ) {
     998:	4629                	li	a2,10
     99a:	85d6                	mv	a1,s5
     99c:	854a                	mv	a0,s2
     99e:	00005097          	auipc	ra,0x5
     9a2:	b2e080e7          	jalr	-1234(ra) # 54cc <write>
     9a6:	47a9                	li	a5,10
     9a8:	0af51963          	bne	a0,a5,a5a <writetest+0x11c>
  for (i = 0; i < N; i++) {
     9ac:	2485                	addiw	s1,s1,1
     9ae:	fd449be3          	bne	s1,s4,984 <writetest+0x46>
  close(fd);
     9b2:	854a                	mv	a0,s2
     9b4:	00005097          	auipc	ra,0x5
     9b8:	b20080e7          	jalr	-1248(ra) # 54d4 <close>
  fd = open("small", O_RDONLY);
     9bc:	4581                	li	a1,0
     9be:	00005517          	auipc	a0,0x5
     9c2:	6f250513          	addi	a0,a0,1778 # 60b0 <l_free+0x66a>
     9c6:	00005097          	auipc	ra,0x5
     9ca:	b26080e7          	jalr	-1242(ra) # 54ec <open>
     9ce:	84aa                	mv	s1,a0
  if (fd < 0) {
     9d0:	0a054363          	bltz	a0,a76 <writetest+0x138>
  i = read(fd, buf, N * SZ * 2);
     9d4:	7d000613          	li	a2,2000
     9d8:	0000b597          	auipc	a1,0xb
     9dc:	fe058593          	addi	a1,a1,-32 # b9b8 <buf>
     9e0:	00005097          	auipc	ra,0x5
     9e4:	ae4080e7          	jalr	-1308(ra) # 54c4 <read>
  if (i != N * SZ * 2) {
     9e8:	7d000793          	li	a5,2000
     9ec:	0af51363          	bne	a0,a5,a92 <writetest+0x154>
  close(fd);
     9f0:	8526                	mv	a0,s1
     9f2:	00005097          	auipc	ra,0x5
     9f6:	ae2080e7          	jalr	-1310(ra) # 54d4 <close>
  if (unlink("small") < 0) {
     9fa:	00005517          	auipc	a0,0x5
     9fe:	6b650513          	addi	a0,a0,1718 # 60b0 <l_free+0x66a>
     a02:	00005097          	auipc	ra,0x5
     a06:	afa080e7          	jalr	-1286(ra) # 54fc <unlink>
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
     a28:	69450513          	addi	a0,a0,1684 # 60b8 <l_free+0x672>
     a2c:	00005097          	auipc	ra,0x5
     a30:	df8080e7          	jalr	-520(ra) # 5824 <printf>
    exit(1);
     a34:	4505                	li	a0,1
     a36:	00005097          	auipc	ra,0x5
     a3a:	a76080e7          	jalr	-1418(ra) # 54ac <exit>
      printf("%s: error: write aa %d new file failed\n", i);
     a3e:	85a6                	mv	a1,s1
     a40:	00005517          	auipc	a0,0x5
     a44:	6a850513          	addi	a0,a0,1704 # 60e8 <l_free+0x6a2>
     a48:	00005097          	auipc	ra,0x5
     a4c:	ddc080e7          	jalr	-548(ra) # 5824 <printf>
      exit(1);
     a50:	4505                	li	a0,1
     a52:	00005097          	auipc	ra,0x5
     a56:	a5a080e7          	jalr	-1446(ra) # 54ac <exit>
      printf("%s: error: write bb %d new file failed\n", i);
     a5a:	85a6                	mv	a1,s1
     a5c:	00005517          	auipc	a0,0x5
     a60:	6c450513          	addi	a0,a0,1732 # 6120 <l_free+0x6da>
     a64:	00005097          	auipc	ra,0x5
     a68:	dc0080e7          	jalr	-576(ra) # 5824 <printf>
      exit(1);
     a6c:	4505                	li	a0,1
     a6e:	00005097          	auipc	ra,0x5
     a72:	a3e080e7          	jalr	-1474(ra) # 54ac <exit>
    printf("%s: error: open small failed!\n", s);
     a76:	85da                	mv	a1,s6
     a78:	00005517          	auipc	a0,0x5
     a7c:	6d050513          	addi	a0,a0,1744 # 6148 <l_free+0x702>
     a80:	00005097          	auipc	ra,0x5
     a84:	da4080e7          	jalr	-604(ra) # 5824 <printf>
    exit(1);
     a88:	4505                	li	a0,1
     a8a:	00005097          	auipc	ra,0x5
     a8e:	a22080e7          	jalr	-1502(ra) # 54ac <exit>
    printf("%s: read failed\n", s);
     a92:	85da                	mv	a1,s6
     a94:	00005517          	auipc	a0,0x5
     a98:	6d450513          	addi	a0,a0,1748 # 6168 <l_free+0x722>
     a9c:	00005097          	auipc	ra,0x5
     aa0:	d88080e7          	jalr	-632(ra) # 5824 <printf>
    exit(1);
     aa4:	4505                	li	a0,1
     aa6:	00005097          	auipc	ra,0x5
     aaa:	a06080e7          	jalr	-1530(ra) # 54ac <exit>
    printf("%s: unlink small failed\n", s);
     aae:	85da                	mv	a1,s6
     ab0:	00005517          	auipc	a0,0x5
     ab4:	6d050513          	addi	a0,a0,1744 # 6180 <l_free+0x73a>
     ab8:	00005097          	auipc	ra,0x5
     abc:	d6c080e7          	jalr	-660(ra) # 5824 <printf>
    exit(1);
     ac0:	4505                	li	a0,1
     ac2:	00005097          	auipc	ra,0x5
     ac6:	9ea080e7          	jalr	-1558(ra) # 54ac <exit>

0000000000000aca <writebig>:
void writebig(char *s) {
     aca:	7139                	addi	sp,sp,-64
     acc:	fc06                	sd	ra,56(sp)
     ace:	f822                	sd	s0,48(sp)
     ad0:	f426                	sd	s1,40(sp)
     ad2:	f04a                	sd	s2,32(sp)
     ad4:	ec4e                	sd	s3,24(sp)
     ad6:	e852                	sd	s4,16(sp)
     ad8:	e456                	sd	s5,8(sp)
     ada:	0080                	addi	s0,sp,64
     adc:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE | O_RDWR);
     ade:	20200593          	li	a1,514
     ae2:	00005517          	auipc	a0,0x5
     ae6:	6be50513          	addi	a0,a0,1726 # 61a0 <l_free+0x75a>
     aea:	00005097          	auipc	ra,0x5
     aee:	a02080e7          	jalr	-1534(ra) # 54ec <open>
     af2:	89aa                	mv	s3,a0
  for (i = 0; i < MAXFILE; i++) {
     af4:	4481                	li	s1,0
    ((int *)buf)[0] = i;
     af6:	0000b917          	auipc	s2,0xb
     afa:	ec290913          	addi	s2,s2,-318 # b9b8 <buf>
  for (i = 0; i < MAXFILE; i++) {
     afe:	10c00a13          	li	s4,268
  if (fd < 0) {
     b02:	06054c63          	bltz	a0,b7a <writebig+0xb0>
    ((int *)buf)[0] = i;
     b06:	00992023          	sw	s1,0(s2)
    if (write(fd, buf, BSIZE) != BSIZE) {
     b0a:	40000613          	li	a2,1024
     b0e:	85ca                	mv	a1,s2
     b10:	854e                	mv	a0,s3
     b12:	00005097          	auipc	ra,0x5
     b16:	9ba080e7          	jalr	-1606(ra) # 54cc <write>
     b1a:	40000793          	li	a5,1024
     b1e:	06f51c63          	bne	a0,a5,b96 <writebig+0xcc>
  for (i = 0; i < MAXFILE; i++) {
     b22:	2485                	addiw	s1,s1,1
     b24:	ff4491e3          	bne	s1,s4,b06 <writebig+0x3c>
  close(fd);
     b28:	854e                	mv	a0,s3
     b2a:	00005097          	auipc	ra,0x5
     b2e:	9aa080e7          	jalr	-1622(ra) # 54d4 <close>
  fd = open("big", O_RDONLY);
     b32:	4581                	li	a1,0
     b34:	00005517          	auipc	a0,0x5
     b38:	66c50513          	addi	a0,a0,1644 # 61a0 <l_free+0x75a>
     b3c:	00005097          	auipc	ra,0x5
     b40:	9b0080e7          	jalr	-1616(ra) # 54ec <open>
     b44:	89aa                	mv	s3,a0
  n = 0;
     b46:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     b48:	0000b917          	auipc	s2,0xb
     b4c:	e7090913          	addi	s2,s2,-400 # b9b8 <buf>
  if (fd < 0) {
     b50:	06054163          	bltz	a0,bb2 <writebig+0xe8>
    i = read(fd, buf, BSIZE);
     b54:	40000613          	li	a2,1024
     b58:	85ca                	mv	a1,s2
     b5a:	854e                	mv	a0,s3
     b5c:	00005097          	auipc	ra,0x5
     b60:	968080e7          	jalr	-1688(ra) # 54c4 <read>
    if (i == 0) {
     b64:	c52d                	beqz	a0,bce <writebig+0x104>
    } else if (i != BSIZE) {
     b66:	40000793          	li	a5,1024
     b6a:	0af51d63          	bne	a0,a5,c24 <writebig+0x15a>
    if (((int *)buf)[0] != n) {
     b6e:	00092603          	lw	a2,0(s2)
     b72:	0c961763          	bne	a2,s1,c40 <writebig+0x176>
    n++;
     b76:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     b78:	bff1                	j	b54 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     b7a:	85d6                	mv	a1,s5
     b7c:	00005517          	auipc	a0,0x5
     b80:	62c50513          	addi	a0,a0,1580 # 61a8 <l_free+0x762>
     b84:	00005097          	auipc	ra,0x5
     b88:	ca0080e7          	jalr	-864(ra) # 5824 <printf>
    exit(1);
     b8c:	4505                	li	a0,1
     b8e:	00005097          	auipc	ra,0x5
     b92:	91e080e7          	jalr	-1762(ra) # 54ac <exit>
      printf("%s: error: write big file failed\n", i);
     b96:	85a6                	mv	a1,s1
     b98:	00005517          	auipc	a0,0x5
     b9c:	63050513          	addi	a0,a0,1584 # 61c8 <l_free+0x782>
     ba0:	00005097          	auipc	ra,0x5
     ba4:	c84080e7          	jalr	-892(ra) # 5824 <printf>
      exit(1);
     ba8:	4505                	li	a0,1
     baa:	00005097          	auipc	ra,0x5
     bae:	902080e7          	jalr	-1790(ra) # 54ac <exit>
    printf("%s: error: open big failed!\n", s);
     bb2:	85d6                	mv	a1,s5
     bb4:	00005517          	auipc	a0,0x5
     bb8:	63c50513          	addi	a0,a0,1596 # 61f0 <l_free+0x7aa>
     bbc:	00005097          	auipc	ra,0x5
     bc0:	c68080e7          	jalr	-920(ra) # 5824 <printf>
    exit(1);
     bc4:	4505                	li	a0,1
     bc6:	00005097          	auipc	ra,0x5
     bca:	8e6080e7          	jalr	-1818(ra) # 54ac <exit>
      if (n == MAXFILE - 1) {
     bce:	10b00793          	li	a5,267
     bd2:	02f48a63          	beq	s1,a5,c06 <writebig+0x13c>
  close(fd);
     bd6:	854e                	mv	a0,s3
     bd8:	00005097          	auipc	ra,0x5
     bdc:	8fc080e7          	jalr	-1796(ra) # 54d4 <close>
  if (unlink("big") < 0) {
     be0:	00005517          	auipc	a0,0x5
     be4:	5c050513          	addi	a0,a0,1472 # 61a0 <l_free+0x75a>
     be8:	00005097          	auipc	ra,0x5
     bec:	914080e7          	jalr	-1772(ra) # 54fc <unlink>
     bf0:	06054663          	bltz	a0,c5c <writebig+0x192>
}
     bf4:	70e2                	ld	ra,56(sp)
     bf6:	7442                	ld	s0,48(sp)
     bf8:	74a2                	ld	s1,40(sp)
     bfa:	7902                	ld	s2,32(sp)
     bfc:	69e2                	ld	s3,24(sp)
     bfe:	6a42                	ld	s4,16(sp)
     c00:	6aa2                	ld	s5,8(sp)
     c02:	6121                	addi	sp,sp,64
     c04:	8082                	ret
        printf("%s: read only %d blocks from big", n);
     c06:	10b00593          	li	a1,267
     c0a:	00005517          	auipc	a0,0x5
     c0e:	60650513          	addi	a0,a0,1542 # 6210 <l_free+0x7ca>
     c12:	00005097          	auipc	ra,0x5
     c16:	c12080e7          	jalr	-1006(ra) # 5824 <printf>
        exit(1);
     c1a:	4505                	li	a0,1
     c1c:	00005097          	auipc	ra,0x5
     c20:	890080e7          	jalr	-1904(ra) # 54ac <exit>
      printf("%s: read failed %d\n", i);
     c24:	85aa                	mv	a1,a0
     c26:	00005517          	auipc	a0,0x5
     c2a:	61250513          	addi	a0,a0,1554 # 6238 <l_free+0x7f2>
     c2e:	00005097          	auipc	ra,0x5
     c32:	bf6080e7          	jalr	-1034(ra) # 5824 <printf>
      exit(1);
     c36:	4505                	li	a0,1
     c38:	00005097          	auipc	ra,0x5
     c3c:	874080e7          	jalr	-1932(ra) # 54ac <exit>
      printf("%s: read content of block %d is %d\n", n, ((int *)buf)[0]);
     c40:	85a6                	mv	a1,s1
     c42:	00005517          	auipc	a0,0x5
     c46:	60e50513          	addi	a0,a0,1550 # 6250 <l_free+0x80a>
     c4a:	00005097          	auipc	ra,0x5
     c4e:	bda080e7          	jalr	-1062(ra) # 5824 <printf>
      exit(1);
     c52:	4505                	li	a0,1
     c54:	00005097          	auipc	ra,0x5
     c58:	858080e7          	jalr	-1960(ra) # 54ac <exit>
    printf("%s: unlink big failed\n", s);
     c5c:	85d6                	mv	a1,s5
     c5e:	00005517          	auipc	a0,0x5
     c62:	61a50513          	addi	a0,a0,1562 # 6278 <l_free+0x832>
     c66:	00005097          	auipc	ra,0x5
     c6a:	bbe080e7          	jalr	-1090(ra) # 5824 <printf>
    exit(1);
     c6e:	4505                	li	a0,1
     c70:	00005097          	auipc	ra,0x5
     c74:	83c080e7          	jalr	-1988(ra) # 54ac <exit>

0000000000000c78 <unlinkread>:
void unlinkread(char *s) {
     c78:	7179                	addi	sp,sp,-48
     c7a:	f406                	sd	ra,40(sp)
     c7c:	f022                	sd	s0,32(sp)
     c7e:	ec26                	sd	s1,24(sp)
     c80:	e84a                	sd	s2,16(sp)
     c82:	e44e                	sd	s3,8(sp)
     c84:	1800                	addi	s0,sp,48
     c86:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     c88:	20200593          	li	a1,514
     c8c:	00005517          	auipc	a0,0x5
     c90:	f2c50513          	addi	a0,a0,-212 # 5bb8 <l_free+0x172>
     c94:	00005097          	auipc	ra,0x5
     c98:	858080e7          	jalr	-1960(ra) # 54ec <open>
  if (fd < 0) {
     c9c:	0e054563          	bltz	a0,d86 <unlinkread+0x10e>
     ca0:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     ca2:	4615                	li	a2,5
     ca4:	00005597          	auipc	a1,0x5
     ca8:	60c58593          	addi	a1,a1,1548 # 62b0 <l_free+0x86a>
     cac:	00005097          	auipc	ra,0x5
     cb0:	820080e7          	jalr	-2016(ra) # 54cc <write>
  close(fd);
     cb4:	8526                	mv	a0,s1
     cb6:	00005097          	auipc	ra,0x5
     cba:	81e080e7          	jalr	-2018(ra) # 54d4 <close>
  fd = open("unlinkread", O_RDWR);
     cbe:	4589                	li	a1,2
     cc0:	00005517          	auipc	a0,0x5
     cc4:	ef850513          	addi	a0,a0,-264 # 5bb8 <l_free+0x172>
     cc8:	00005097          	auipc	ra,0x5
     ccc:	824080e7          	jalr	-2012(ra) # 54ec <open>
     cd0:	84aa                	mv	s1,a0
  if (fd < 0) {
     cd2:	0c054863          	bltz	a0,da2 <unlinkread+0x12a>
  if (unlink("unlinkread") != 0) {
     cd6:	00005517          	auipc	a0,0x5
     cda:	ee250513          	addi	a0,a0,-286 # 5bb8 <l_free+0x172>
     cde:	00005097          	auipc	ra,0x5
     ce2:	81e080e7          	jalr	-2018(ra) # 54fc <unlink>
     ce6:	ed61                	bnez	a0,dbe <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     ce8:	20200593          	li	a1,514
     cec:	00005517          	auipc	a0,0x5
     cf0:	ecc50513          	addi	a0,a0,-308 # 5bb8 <l_free+0x172>
     cf4:	00004097          	auipc	ra,0x4
     cf8:	7f8080e7          	jalr	2040(ra) # 54ec <open>
     cfc:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     cfe:	460d                	li	a2,3
     d00:	00005597          	auipc	a1,0x5
     d04:	5f858593          	addi	a1,a1,1528 # 62f8 <l_free+0x8b2>
     d08:	00004097          	auipc	ra,0x4
     d0c:	7c4080e7          	jalr	1988(ra) # 54cc <write>
  close(fd1);
     d10:	854a                	mv	a0,s2
     d12:	00004097          	auipc	ra,0x4
     d16:	7c2080e7          	jalr	1986(ra) # 54d4 <close>
  if (read(fd, buf, sizeof(buf)) != SZ) {
     d1a:	660d                	lui	a2,0x3
     d1c:	0000b597          	auipc	a1,0xb
     d20:	c9c58593          	addi	a1,a1,-868 # b9b8 <buf>
     d24:	8526                	mv	a0,s1
     d26:	00004097          	auipc	ra,0x4
     d2a:	79e080e7          	jalr	1950(ra) # 54c4 <read>
     d2e:	4795                	li	a5,5
     d30:	0af51563          	bne	a0,a5,dda <unlinkread+0x162>
  if (buf[0] != 'h') {
     d34:	0000b717          	auipc	a4,0xb
     d38:	c8474703          	lbu	a4,-892(a4) # b9b8 <buf>
     d3c:	06800793          	li	a5,104
     d40:	0af71b63          	bne	a4,a5,df6 <unlinkread+0x17e>
  if (write(fd, buf, 10) != 10) {
     d44:	4629                	li	a2,10
     d46:	0000b597          	auipc	a1,0xb
     d4a:	c7258593          	addi	a1,a1,-910 # b9b8 <buf>
     d4e:	8526                	mv	a0,s1
     d50:	00004097          	auipc	ra,0x4
     d54:	77c080e7          	jalr	1916(ra) # 54cc <write>
     d58:	47a9                	li	a5,10
     d5a:	0af51c63          	bne	a0,a5,e12 <unlinkread+0x19a>
  close(fd);
     d5e:	8526                	mv	a0,s1
     d60:	00004097          	auipc	ra,0x4
     d64:	774080e7          	jalr	1908(ra) # 54d4 <close>
  unlink("unlinkread");
     d68:	00005517          	auipc	a0,0x5
     d6c:	e5050513          	addi	a0,a0,-432 # 5bb8 <l_free+0x172>
     d70:	00004097          	auipc	ra,0x4
     d74:	78c080e7          	jalr	1932(ra) # 54fc <unlink>
}
     d78:	70a2                	ld	ra,40(sp)
     d7a:	7402                	ld	s0,32(sp)
     d7c:	64e2                	ld	s1,24(sp)
     d7e:	6942                	ld	s2,16(sp)
     d80:	69a2                	ld	s3,8(sp)
     d82:	6145                	addi	sp,sp,48
     d84:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     d86:	85ce                	mv	a1,s3
     d88:	00005517          	auipc	a0,0x5
     d8c:	50850513          	addi	a0,a0,1288 # 6290 <l_free+0x84a>
     d90:	00005097          	auipc	ra,0x5
     d94:	a94080e7          	jalr	-1388(ra) # 5824 <printf>
    exit(1);
     d98:	4505                	li	a0,1
     d9a:	00004097          	auipc	ra,0x4
     d9e:	712080e7          	jalr	1810(ra) # 54ac <exit>
    printf("%s: open unlinkread failed\n", s);
     da2:	85ce                	mv	a1,s3
     da4:	00005517          	auipc	a0,0x5
     da8:	51450513          	addi	a0,a0,1300 # 62b8 <l_free+0x872>
     dac:	00005097          	auipc	ra,0x5
     db0:	a78080e7          	jalr	-1416(ra) # 5824 <printf>
    exit(1);
     db4:	4505                	li	a0,1
     db6:	00004097          	auipc	ra,0x4
     dba:	6f6080e7          	jalr	1782(ra) # 54ac <exit>
    printf("%s: unlink unlinkread failed\n", s);
     dbe:	85ce                	mv	a1,s3
     dc0:	00005517          	auipc	a0,0x5
     dc4:	51850513          	addi	a0,a0,1304 # 62d8 <l_free+0x892>
     dc8:	00005097          	auipc	ra,0x5
     dcc:	a5c080e7          	jalr	-1444(ra) # 5824 <printf>
    exit(1);
     dd0:	4505                	li	a0,1
     dd2:	00004097          	auipc	ra,0x4
     dd6:	6da080e7          	jalr	1754(ra) # 54ac <exit>
    printf("%s: unlinkread read failed", s);
     dda:	85ce                	mv	a1,s3
     ddc:	00005517          	auipc	a0,0x5
     de0:	52450513          	addi	a0,a0,1316 # 6300 <l_free+0x8ba>
     de4:	00005097          	auipc	ra,0x5
     de8:	a40080e7          	jalr	-1472(ra) # 5824 <printf>
    exit(1);
     dec:	4505                	li	a0,1
     dee:	00004097          	auipc	ra,0x4
     df2:	6be080e7          	jalr	1726(ra) # 54ac <exit>
    printf("%s: unlinkread wrong data\n", s);
     df6:	85ce                	mv	a1,s3
     df8:	00005517          	auipc	a0,0x5
     dfc:	52850513          	addi	a0,a0,1320 # 6320 <l_free+0x8da>
     e00:	00005097          	auipc	ra,0x5
     e04:	a24080e7          	jalr	-1500(ra) # 5824 <printf>
    exit(1);
     e08:	4505                	li	a0,1
     e0a:	00004097          	auipc	ra,0x4
     e0e:	6a2080e7          	jalr	1698(ra) # 54ac <exit>
    printf("%s: unlinkread write failed\n", s);
     e12:	85ce                	mv	a1,s3
     e14:	00005517          	auipc	a0,0x5
     e18:	52c50513          	addi	a0,a0,1324 # 6340 <l_free+0x8fa>
     e1c:	00005097          	auipc	ra,0x5
     e20:	a08080e7          	jalr	-1528(ra) # 5824 <printf>
    exit(1);
     e24:	4505                	li	a0,1
     e26:	00004097          	auipc	ra,0x4
     e2a:	686080e7          	jalr	1670(ra) # 54ac <exit>

0000000000000e2e <linktest>:
void linktest(char *s) {
     e2e:	1101                	addi	sp,sp,-32
     e30:	ec06                	sd	ra,24(sp)
     e32:	e822                	sd	s0,16(sp)
     e34:	e426                	sd	s1,8(sp)
     e36:	e04a                	sd	s2,0(sp)
     e38:	1000                	addi	s0,sp,32
     e3a:	892a                	mv	s2,a0
  unlink("lf1");
     e3c:	00005517          	auipc	a0,0x5
     e40:	52450513          	addi	a0,a0,1316 # 6360 <l_free+0x91a>
     e44:	00004097          	auipc	ra,0x4
     e48:	6b8080e7          	jalr	1720(ra) # 54fc <unlink>
  unlink("lf2");
     e4c:	00005517          	auipc	a0,0x5
     e50:	51c50513          	addi	a0,a0,1308 # 6368 <l_free+0x922>
     e54:	00004097          	auipc	ra,0x4
     e58:	6a8080e7          	jalr	1704(ra) # 54fc <unlink>
  fd = open("lf1", O_CREATE | O_RDWR);
     e5c:	20200593          	li	a1,514
     e60:	00005517          	auipc	a0,0x5
     e64:	50050513          	addi	a0,a0,1280 # 6360 <l_free+0x91a>
     e68:	00004097          	auipc	ra,0x4
     e6c:	684080e7          	jalr	1668(ra) # 54ec <open>
  if (fd < 0) {
     e70:	10054763          	bltz	a0,f7e <linktest+0x150>
     e74:	84aa                	mv	s1,a0
  if (write(fd, "hello", SZ) != SZ) {
     e76:	4615                	li	a2,5
     e78:	00005597          	auipc	a1,0x5
     e7c:	43858593          	addi	a1,a1,1080 # 62b0 <l_free+0x86a>
     e80:	00004097          	auipc	ra,0x4
     e84:	64c080e7          	jalr	1612(ra) # 54cc <write>
     e88:	4795                	li	a5,5
     e8a:	10f51863          	bne	a0,a5,f9a <linktest+0x16c>
  close(fd);
     e8e:	8526                	mv	a0,s1
     e90:	00004097          	auipc	ra,0x4
     e94:	644080e7          	jalr	1604(ra) # 54d4 <close>
  if (link("lf1", "lf2") < 0) {
     e98:	00005597          	auipc	a1,0x5
     e9c:	4d058593          	addi	a1,a1,1232 # 6368 <l_free+0x922>
     ea0:	00005517          	auipc	a0,0x5
     ea4:	4c050513          	addi	a0,a0,1216 # 6360 <l_free+0x91a>
     ea8:	00004097          	auipc	ra,0x4
     eac:	664080e7          	jalr	1636(ra) # 550c <link>
     eb0:	10054363          	bltz	a0,fb6 <linktest+0x188>
  unlink("lf1");
     eb4:	00005517          	auipc	a0,0x5
     eb8:	4ac50513          	addi	a0,a0,1196 # 6360 <l_free+0x91a>
     ebc:	00004097          	auipc	ra,0x4
     ec0:	640080e7          	jalr	1600(ra) # 54fc <unlink>
  if (open("lf1", 0) >= 0) {
     ec4:	4581                	li	a1,0
     ec6:	00005517          	auipc	a0,0x5
     eca:	49a50513          	addi	a0,a0,1178 # 6360 <l_free+0x91a>
     ece:	00004097          	auipc	ra,0x4
     ed2:	61e080e7          	jalr	1566(ra) # 54ec <open>
     ed6:	0e055e63          	bgez	a0,fd2 <linktest+0x1a4>
  fd = open("lf2", 0);
     eda:	4581                	li	a1,0
     edc:	00005517          	auipc	a0,0x5
     ee0:	48c50513          	addi	a0,a0,1164 # 6368 <l_free+0x922>
     ee4:	00004097          	auipc	ra,0x4
     ee8:	608080e7          	jalr	1544(ra) # 54ec <open>
     eec:	84aa                	mv	s1,a0
  if (fd < 0) {
     eee:	10054063          	bltz	a0,fee <linktest+0x1c0>
  if (read(fd, buf, sizeof(buf)) != SZ) {
     ef2:	660d                	lui	a2,0x3
     ef4:	0000b597          	auipc	a1,0xb
     ef8:	ac458593          	addi	a1,a1,-1340 # b9b8 <buf>
     efc:	00004097          	auipc	ra,0x4
     f00:	5c8080e7          	jalr	1480(ra) # 54c4 <read>
     f04:	4795                	li	a5,5
     f06:	10f51263          	bne	a0,a5,100a <linktest+0x1dc>
  close(fd);
     f0a:	8526                	mv	a0,s1
     f0c:	00004097          	auipc	ra,0x4
     f10:	5c8080e7          	jalr	1480(ra) # 54d4 <close>
  if (link("lf2", "lf2") >= 0) {
     f14:	00005597          	auipc	a1,0x5
     f18:	45458593          	addi	a1,a1,1108 # 6368 <l_free+0x922>
     f1c:	852e                	mv	a0,a1
     f1e:	00004097          	auipc	ra,0x4
     f22:	5ee080e7          	jalr	1518(ra) # 550c <link>
     f26:	10055063          	bgez	a0,1026 <linktest+0x1f8>
  unlink("lf2");
     f2a:	00005517          	auipc	a0,0x5
     f2e:	43e50513          	addi	a0,a0,1086 # 6368 <l_free+0x922>
     f32:	00004097          	auipc	ra,0x4
     f36:	5ca080e7          	jalr	1482(ra) # 54fc <unlink>
  if (link("lf2", "lf1") >= 0) {
     f3a:	00005597          	auipc	a1,0x5
     f3e:	42658593          	addi	a1,a1,1062 # 6360 <l_free+0x91a>
     f42:	00005517          	auipc	a0,0x5
     f46:	42650513          	addi	a0,a0,1062 # 6368 <l_free+0x922>
     f4a:	00004097          	auipc	ra,0x4
     f4e:	5c2080e7          	jalr	1474(ra) # 550c <link>
     f52:	0e055863          	bgez	a0,1042 <linktest+0x214>
  if (link(".", "lf1") >= 0) {
     f56:	00005597          	auipc	a1,0x5
     f5a:	40a58593          	addi	a1,a1,1034 # 6360 <l_free+0x91a>
     f5e:	00005517          	auipc	a0,0x5
     f62:	51250513          	addi	a0,a0,1298 # 6470 <l_free+0xa2a>
     f66:	00004097          	auipc	ra,0x4
     f6a:	5a6080e7          	jalr	1446(ra) # 550c <link>
     f6e:	0e055863          	bgez	a0,105e <linktest+0x230>
}
     f72:	60e2                	ld	ra,24(sp)
     f74:	6442                	ld	s0,16(sp)
     f76:	64a2                	ld	s1,8(sp)
     f78:	6902                	ld	s2,0(sp)
     f7a:	6105                	addi	sp,sp,32
     f7c:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     f7e:	85ca                	mv	a1,s2
     f80:	00005517          	auipc	a0,0x5
     f84:	3f050513          	addi	a0,a0,1008 # 6370 <l_free+0x92a>
     f88:	00005097          	auipc	ra,0x5
     f8c:	89c080e7          	jalr	-1892(ra) # 5824 <printf>
    exit(1);
     f90:	4505                	li	a0,1
     f92:	00004097          	auipc	ra,0x4
     f96:	51a080e7          	jalr	1306(ra) # 54ac <exit>
    printf("%s: write lf1 failed\n", s);
     f9a:	85ca                	mv	a1,s2
     f9c:	00005517          	auipc	a0,0x5
     fa0:	3ec50513          	addi	a0,a0,1004 # 6388 <l_free+0x942>
     fa4:	00005097          	auipc	ra,0x5
     fa8:	880080e7          	jalr	-1920(ra) # 5824 <printf>
    exit(1);
     fac:	4505                	li	a0,1
     fae:	00004097          	auipc	ra,0x4
     fb2:	4fe080e7          	jalr	1278(ra) # 54ac <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     fb6:	85ca                	mv	a1,s2
     fb8:	00005517          	auipc	a0,0x5
     fbc:	3e850513          	addi	a0,a0,1000 # 63a0 <l_free+0x95a>
     fc0:	00005097          	auipc	ra,0x5
     fc4:	864080e7          	jalr	-1948(ra) # 5824 <printf>
    exit(1);
     fc8:	4505                	li	a0,1
     fca:	00004097          	auipc	ra,0x4
     fce:	4e2080e7          	jalr	1250(ra) # 54ac <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     fd2:	85ca                	mv	a1,s2
     fd4:	00005517          	auipc	a0,0x5
     fd8:	3ec50513          	addi	a0,a0,1004 # 63c0 <l_free+0x97a>
     fdc:	00005097          	auipc	ra,0x5
     fe0:	848080e7          	jalr	-1976(ra) # 5824 <printf>
    exit(1);
     fe4:	4505                	li	a0,1
     fe6:	00004097          	auipc	ra,0x4
     fea:	4c6080e7          	jalr	1222(ra) # 54ac <exit>
    printf("%s: open lf2 failed\n", s);
     fee:	85ca                	mv	a1,s2
     ff0:	00005517          	auipc	a0,0x5
     ff4:	40050513          	addi	a0,a0,1024 # 63f0 <l_free+0x9aa>
     ff8:	00005097          	auipc	ra,0x5
     ffc:	82c080e7          	jalr	-2004(ra) # 5824 <printf>
    exit(1);
    1000:	4505                	li	a0,1
    1002:	00004097          	auipc	ra,0x4
    1006:	4aa080e7          	jalr	1194(ra) # 54ac <exit>
    printf("%s: read lf2 failed\n", s);
    100a:	85ca                	mv	a1,s2
    100c:	00005517          	auipc	a0,0x5
    1010:	3fc50513          	addi	a0,a0,1020 # 6408 <l_free+0x9c2>
    1014:	00005097          	auipc	ra,0x5
    1018:	810080e7          	jalr	-2032(ra) # 5824 <printf>
    exit(1);
    101c:	4505                	li	a0,1
    101e:	00004097          	auipc	ra,0x4
    1022:	48e080e7          	jalr	1166(ra) # 54ac <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    1026:	85ca                	mv	a1,s2
    1028:	00005517          	auipc	a0,0x5
    102c:	3f850513          	addi	a0,a0,1016 # 6420 <l_free+0x9da>
    1030:	00004097          	auipc	ra,0x4
    1034:	7f4080e7          	jalr	2036(ra) # 5824 <printf>
    exit(1);
    1038:	4505                	li	a0,1
    103a:	00004097          	auipc	ra,0x4
    103e:	472080e7          	jalr	1138(ra) # 54ac <exit>
    printf("%s: link non-existant succeeded! oops\n", s);
    1042:	85ca                	mv	a1,s2
    1044:	00005517          	auipc	a0,0x5
    1048:	40450513          	addi	a0,a0,1028 # 6448 <l_free+0xa02>
    104c:	00004097          	auipc	ra,0x4
    1050:	7d8080e7          	jalr	2008(ra) # 5824 <printf>
    exit(1);
    1054:	4505                	li	a0,1
    1056:	00004097          	auipc	ra,0x4
    105a:	456080e7          	jalr	1110(ra) # 54ac <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    105e:	85ca                	mv	a1,s2
    1060:	00005517          	auipc	a0,0x5
    1064:	41850513          	addi	a0,a0,1048 # 6478 <l_free+0xa32>
    1068:	00004097          	auipc	ra,0x4
    106c:	7bc080e7          	jalr	1980(ra) # 5824 <printf>
    exit(1);
    1070:	4505                	li	a0,1
    1072:	00004097          	auipc	ra,0x4
    1076:	43a080e7          	jalr	1082(ra) # 54ac <exit>

000000000000107a <bigdir>:
void bigdir(char *s) {
    107a:	715d                	addi	sp,sp,-80
    107c:	e486                	sd	ra,72(sp)
    107e:	e0a2                	sd	s0,64(sp)
    1080:	fc26                	sd	s1,56(sp)
    1082:	f84a                	sd	s2,48(sp)
    1084:	f44e                	sd	s3,40(sp)
    1086:	f052                	sd	s4,32(sp)
    1088:	ec56                	sd	s5,24(sp)
    108a:	e85a                	sd	s6,16(sp)
    108c:	0880                	addi	s0,sp,80
    108e:	89aa                	mv	s3,a0
  unlink("bd");
    1090:	00005517          	auipc	a0,0x5
    1094:	40850513          	addi	a0,a0,1032 # 6498 <l_free+0xa52>
    1098:	00004097          	auipc	ra,0x4
    109c:	464080e7          	jalr	1124(ra) # 54fc <unlink>
  fd = open("bd", O_CREATE);
    10a0:	20000593          	li	a1,512
    10a4:	00005517          	auipc	a0,0x5
    10a8:	3f450513          	addi	a0,a0,1012 # 6498 <l_free+0xa52>
    10ac:	00004097          	auipc	ra,0x4
    10b0:	440080e7          	jalr	1088(ra) # 54ec <open>
  if (fd < 0) {
    10b4:	0c054963          	bltz	a0,1186 <bigdir+0x10c>
  close(fd);
    10b8:	00004097          	auipc	ra,0x4
    10bc:	41c080e7          	jalr	1052(ra) # 54d4 <close>
  for (i = 0; i < N; i++) {
    10c0:	4901                	li	s2,0
    name[0] = 'x';
    10c2:	07800a93          	li	s5,120
    if (link("bd", name) != 0) {
    10c6:	00005a17          	auipc	s4,0x5
    10ca:	3d2a0a13          	addi	s4,s4,978 # 6498 <l_free+0xa52>
  for (i = 0; i < N; i++) {
    10ce:	1f400b13          	li	s6,500
    name[0] = 'x';
    10d2:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    10d6:	41f9579b          	sraiw	a5,s2,0x1f
    10da:	01a7d71b          	srliw	a4,a5,0x1a
    10de:	012707bb          	addw	a5,a4,s2
    10e2:	4067d69b          	sraiw	a3,a5,0x6
    10e6:	0306869b          	addiw	a3,a3,48
    10ea:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    10ee:	03f7f793          	andi	a5,a5,63
    10f2:	9f99                	subw	a5,a5,a4
    10f4:	0307879b          	addiw	a5,a5,48
    10f8:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    10fc:	fa0409a3          	sb	zero,-77(s0)
    if (link("bd", name) != 0) {
    1100:	fb040593          	addi	a1,s0,-80
    1104:	8552                	mv	a0,s4
    1106:	00004097          	auipc	ra,0x4
    110a:	406080e7          	jalr	1030(ra) # 550c <link>
    110e:	84aa                	mv	s1,a0
    1110:	e949                	bnez	a0,11a2 <bigdir+0x128>
  for (i = 0; i < N; i++) {
    1112:	2905                	addiw	s2,s2,1
    1114:	fb691fe3          	bne	s2,s6,10d2 <bigdir+0x58>
  unlink("bd");
    1118:	00005517          	auipc	a0,0x5
    111c:	38050513          	addi	a0,a0,896 # 6498 <l_free+0xa52>
    1120:	00004097          	auipc	ra,0x4
    1124:	3dc080e7          	jalr	988(ra) # 54fc <unlink>
    name[0] = 'x';
    1128:	07800913          	li	s2,120
  for (i = 0; i < N; i++) {
    112c:	1f400a13          	li	s4,500
    name[0] = 'x';
    1130:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    1134:	41f4d79b          	sraiw	a5,s1,0x1f
    1138:	01a7d71b          	srliw	a4,a5,0x1a
    113c:	009707bb          	addw	a5,a4,s1
    1140:	4067d69b          	sraiw	a3,a5,0x6
    1144:	0306869b          	addiw	a3,a3,48
    1148:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    114c:	03f7f793          	andi	a5,a5,63
    1150:	9f99                	subw	a5,a5,a4
    1152:	0307879b          	addiw	a5,a5,48
    1156:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    115a:	fa0409a3          	sb	zero,-77(s0)
    if (unlink(name) != 0) {
    115e:	fb040513          	addi	a0,s0,-80
    1162:	00004097          	auipc	ra,0x4
    1166:	39a080e7          	jalr	922(ra) # 54fc <unlink>
    116a:	ed21                	bnez	a0,11c2 <bigdir+0x148>
  for (i = 0; i < N; i++) {
    116c:	2485                	addiw	s1,s1,1
    116e:	fd4491e3          	bne	s1,s4,1130 <bigdir+0xb6>
}
    1172:	60a6                	ld	ra,72(sp)
    1174:	6406                	ld	s0,64(sp)
    1176:	74e2                	ld	s1,56(sp)
    1178:	7942                	ld	s2,48(sp)
    117a:	79a2                	ld	s3,40(sp)
    117c:	7a02                	ld	s4,32(sp)
    117e:	6ae2                	ld	s5,24(sp)
    1180:	6b42                	ld	s6,16(sp)
    1182:	6161                	addi	sp,sp,80
    1184:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    1186:	85ce                	mv	a1,s3
    1188:	00005517          	auipc	a0,0x5
    118c:	31850513          	addi	a0,a0,792 # 64a0 <l_free+0xa5a>
    1190:	00004097          	auipc	ra,0x4
    1194:	694080e7          	jalr	1684(ra) # 5824 <printf>
    exit(1);
    1198:	4505                	li	a0,1
    119a:	00004097          	auipc	ra,0x4
    119e:	312080e7          	jalr	786(ra) # 54ac <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    11a2:	fb040613          	addi	a2,s0,-80
    11a6:	85ce                	mv	a1,s3
    11a8:	00005517          	auipc	a0,0x5
    11ac:	31850513          	addi	a0,a0,792 # 64c0 <l_free+0xa7a>
    11b0:	00004097          	auipc	ra,0x4
    11b4:	674080e7          	jalr	1652(ra) # 5824 <printf>
      exit(1);
    11b8:	4505                	li	a0,1
    11ba:	00004097          	auipc	ra,0x4
    11be:	2f2080e7          	jalr	754(ra) # 54ac <exit>
      printf("%s: bigdir unlink failed", s);
    11c2:	85ce                	mv	a1,s3
    11c4:	00005517          	auipc	a0,0x5
    11c8:	31c50513          	addi	a0,a0,796 # 64e0 <l_free+0xa9a>
    11cc:	00004097          	auipc	ra,0x4
    11d0:	658080e7          	jalr	1624(ra) # 5824 <printf>
      exit(1);
    11d4:	4505                	li	a0,1
    11d6:	00004097          	auipc	ra,0x4
    11da:	2d6080e7          	jalr	726(ra) # 54ac <exit>

00000000000011de <validatetest>:
void validatetest(char *s) {
    11de:	7139                	addi	sp,sp,-64
    11e0:	fc06                	sd	ra,56(sp)
    11e2:	f822                	sd	s0,48(sp)
    11e4:	f426                	sd	s1,40(sp)
    11e6:	f04a                	sd	s2,32(sp)
    11e8:	ec4e                	sd	s3,24(sp)
    11ea:	e852                	sd	s4,16(sp)
    11ec:	e456                	sd	s5,8(sp)
    11ee:	e05a                	sd	s6,0(sp)
    11f0:	0080                	addi	s0,sp,64
    11f2:	8b2a                	mv	s6,a0
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
    11f4:	4481                	li	s1,0
    if (link("nosuchfile", (char *)p) != -1) {
    11f6:	00005997          	auipc	s3,0x5
    11fa:	30a98993          	addi	s3,s3,778 # 6500 <l_free+0xaba>
    11fe:	597d                	li	s2,-1
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
    1200:	6a85                	lui	s5,0x1
    1202:	00114a37          	lui	s4,0x114
    if (link("nosuchfile", (char *)p) != -1) {
    1206:	85a6                	mv	a1,s1
    1208:	854e                	mv	a0,s3
    120a:	00004097          	auipc	ra,0x4
    120e:	302080e7          	jalr	770(ra) # 550c <link>
    1212:	01251f63          	bne	a0,s2,1230 <validatetest+0x52>
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
    1216:	94d6                	add	s1,s1,s5
    1218:	ff4497e3          	bne	s1,s4,1206 <validatetest+0x28>
}
    121c:	70e2                	ld	ra,56(sp)
    121e:	7442                	ld	s0,48(sp)
    1220:	74a2                	ld	s1,40(sp)
    1222:	7902                	ld	s2,32(sp)
    1224:	69e2                	ld	s3,24(sp)
    1226:	6a42                	ld	s4,16(sp)
    1228:	6aa2                	ld	s5,8(sp)
    122a:	6b02                	ld	s6,0(sp)
    122c:	6121                	addi	sp,sp,64
    122e:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1230:	85da                	mv	a1,s6
    1232:	00005517          	auipc	a0,0x5
    1236:	2de50513          	addi	a0,a0,734 # 6510 <l_free+0xaca>
    123a:	00004097          	auipc	ra,0x4
    123e:	5ea080e7          	jalr	1514(ra) # 5824 <printf>
      exit(1);
    1242:	4505                	li	a0,1
    1244:	00004097          	auipc	ra,0x4
    1248:	268080e7          	jalr	616(ra) # 54ac <exit>

000000000000124c <pgbug>:
void pgbug(char *s) {
    124c:	7179                	addi	sp,sp,-48
    124e:	f406                	sd	ra,40(sp)
    1250:	f022                	sd	s0,32(sp)
    1252:	ec26                	sd	s1,24(sp)
    1254:	1800                	addi	s0,sp,48
  argv[0] = 0;
    1256:	fc043c23          	sd	zero,-40(s0)
  exec((char *)0xeaeb0b5b00002f5e, argv);
    125a:	00007497          	auipc	s1,0x7
    125e:	f164b483          	ld	s1,-234(s1) # 8170 <__SDATA_BEGIN__>
    1262:	fd840593          	addi	a1,s0,-40
    1266:	8526                	mv	a0,s1
    1268:	00004097          	auipc	ra,0x4
    126c:	27c080e7          	jalr	636(ra) # 54e4 <exec>
  pipe((int *)0xeaeb0b5b00002f5e);
    1270:	8526                	mv	a0,s1
    1272:	00004097          	auipc	ra,0x4
    1276:	24a080e7          	jalr	586(ra) # 54bc <pipe>
  exit(0);
    127a:	4501                	li	a0,0
    127c:	00004097          	auipc	ra,0x4
    1280:	230080e7          	jalr	560(ra) # 54ac <exit>

0000000000001284 <badarg>:
}

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void badarg(char *s) {
    1284:	7139                	addi	sp,sp,-64
    1286:	fc06                	sd	ra,56(sp)
    1288:	f822                	sd	s0,48(sp)
    128a:	f426                	sd	s1,40(sp)
    128c:	f04a                	sd	s2,32(sp)
    128e:	ec4e                	sd	s3,24(sp)
    1290:	0080                	addi	s0,sp,64
    1292:	64b1                	lui	s1,0xc
    1294:	35048493          	addi	s1,s1,848 # c350 <buf+0x998>
  for (int i = 0; i < 50000; i++) {
    char *argv[2];
    argv[0] = (char *)0xffffffff;
    1298:	597d                	li	s2,-1
    129a:	02095913          	srli	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    129e:	00005997          	auipc	s3,0x5
    12a2:	b0a98993          	addi	s3,s3,-1270 # 5da8 <l_free+0x362>
    argv[0] = (char *)0xffffffff;
    12a6:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    12aa:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    12ae:	fc040593          	addi	a1,s0,-64
    12b2:	854e                	mv	a0,s3
    12b4:	00004097          	auipc	ra,0x4
    12b8:	230080e7          	jalr	560(ra) # 54e4 <exec>
  for (int i = 0; i < 50000; i++) {
    12bc:	34fd                	addiw	s1,s1,-1
    12be:	f4e5                	bnez	s1,12a6 <badarg+0x22>
  }

  exit(0);
    12c0:	4501                	li	a0,0
    12c2:	00004097          	auipc	ra,0x4
    12c6:	1ea080e7          	jalr	490(ra) # 54ac <exit>

00000000000012ca <copyinstr2>:
void copyinstr2(char *s) {
    12ca:	7155                	addi	sp,sp,-208
    12cc:	e586                	sd	ra,200(sp)
    12ce:	e1a2                	sd	s0,192(sp)
    12d0:	0980                	addi	s0,sp,208
  for (int i = 0; i < MAXPATH; i++)
    12d2:	f6840793          	addi	a5,s0,-152
    12d6:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    12da:	07800713          	li	a4,120
    12de:	00e78023          	sb	a4,0(a5)
  for (int i = 0; i < MAXPATH; i++)
    12e2:	0785                	addi	a5,a5,1
    12e4:	fed79de3          	bne	a5,a3,12de <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    12e8:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    12ec:	f6840513          	addi	a0,s0,-152
    12f0:	00004097          	auipc	ra,0x4
    12f4:	20c080e7          	jalr	524(ra) # 54fc <unlink>
  if (ret != -1) {
    12f8:	57fd                	li	a5,-1
    12fa:	0ef51063          	bne	a0,a5,13da <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    12fe:	20100593          	li	a1,513
    1302:	f6840513          	addi	a0,s0,-152
    1306:	00004097          	auipc	ra,0x4
    130a:	1e6080e7          	jalr	486(ra) # 54ec <open>
  if (fd != -1) {
    130e:	57fd                	li	a5,-1
    1310:	0ef51563          	bne	a0,a5,13fa <copyinstr2+0x130>
  ret = link(b, b);
    1314:	f6840593          	addi	a1,s0,-152
    1318:	852e                	mv	a0,a1
    131a:	00004097          	auipc	ra,0x4
    131e:	1f2080e7          	jalr	498(ra) # 550c <link>
  if (ret != -1) {
    1322:	57fd                	li	a5,-1
    1324:	0ef51b63          	bne	a0,a5,141a <copyinstr2+0x150>
  char *args[] = {"xx", 0};
    1328:	00006797          	auipc	a5,0x6
    132c:	2b078793          	addi	a5,a5,688 # 75d8 <l_free+0x1b92>
    1330:	f4f43c23          	sd	a5,-168(s0)
    1334:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1338:	f5840593          	addi	a1,s0,-168
    133c:	f6840513          	addi	a0,s0,-152
    1340:	00004097          	auipc	ra,0x4
    1344:	1a4080e7          	jalr	420(ra) # 54e4 <exec>
  if (ret != -1) {
    1348:	57fd                	li	a5,-1
    134a:	0ef51963          	bne	a0,a5,143c <copyinstr2+0x172>
  int pid = fork();
    134e:	00004097          	auipc	ra,0x4
    1352:	156080e7          	jalr	342(ra) # 54a4 <fork>
  if (pid < 0) {
    1356:	10054363          	bltz	a0,145c <copyinstr2+0x192>
  if (pid == 0) {
    135a:	12051463          	bnez	a0,1482 <copyinstr2+0x1b8>
    135e:	00007797          	auipc	a5,0x7
    1362:	f4278793          	addi	a5,a5,-190 # 82a0 <big.0>
    1366:	00008697          	auipc	a3,0x8
    136a:	f3a68693          	addi	a3,a3,-198 # 92a0 <__global_pointer$+0x930>
      big[i] = 'x';
    136e:	07800713          	li	a4,120
    1372:	00e78023          	sb	a4,0(a5)
    for (int i = 0; i < PGSIZE; i++)
    1376:	0785                	addi	a5,a5,1
    1378:	fed79de3          	bne	a5,a3,1372 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    137c:	00008797          	auipc	a5,0x8
    1380:	f2078223          	sb	zero,-220(a5) # 92a0 <__global_pointer$+0x930>
    char *args2[] = {big, big, big, 0};
    1384:	00007797          	auipc	a5,0x7
    1388:	a0c78793          	addi	a5,a5,-1524 # 7d90 <l_free+0x234a>
    138c:	6390                	ld	a2,0(a5)
    138e:	6794                	ld	a3,8(a5)
    1390:	6b98                	ld	a4,16(a5)
    1392:	6f9c                	ld	a5,24(a5)
    1394:	f2c43823          	sd	a2,-208(s0)
    1398:	f2d43c23          	sd	a3,-200(s0)
    139c:	f4e43023          	sd	a4,-192(s0)
    13a0:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    13a4:	f3040593          	addi	a1,s0,-208
    13a8:	00005517          	auipc	a0,0x5
    13ac:	a0050513          	addi	a0,a0,-1536 # 5da8 <l_free+0x362>
    13b0:	00004097          	auipc	ra,0x4
    13b4:	134080e7          	jalr	308(ra) # 54e4 <exec>
    if (ret != -1) {
    13b8:	57fd                	li	a5,-1
    13ba:	0af50e63          	beq	a0,a5,1476 <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    13be:	55fd                	li	a1,-1
    13c0:	00005517          	auipc	a0,0x5
    13c4:	1f850513          	addi	a0,a0,504 # 65b8 <l_free+0xb72>
    13c8:	00004097          	auipc	ra,0x4
    13cc:	45c080e7          	jalr	1116(ra) # 5824 <printf>
      exit(1);
    13d0:	4505                	li	a0,1
    13d2:	00004097          	auipc	ra,0x4
    13d6:	0da080e7          	jalr	218(ra) # 54ac <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    13da:	862a                	mv	a2,a0
    13dc:	f6840593          	addi	a1,s0,-152
    13e0:	00005517          	auipc	a0,0x5
    13e4:	15050513          	addi	a0,a0,336 # 6530 <l_free+0xaea>
    13e8:	00004097          	auipc	ra,0x4
    13ec:	43c080e7          	jalr	1084(ra) # 5824 <printf>
    exit(1);
    13f0:	4505                	li	a0,1
    13f2:	00004097          	auipc	ra,0x4
    13f6:	0ba080e7          	jalr	186(ra) # 54ac <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    13fa:	862a                	mv	a2,a0
    13fc:	f6840593          	addi	a1,s0,-152
    1400:	00005517          	auipc	a0,0x5
    1404:	15050513          	addi	a0,a0,336 # 6550 <l_free+0xb0a>
    1408:	00004097          	auipc	ra,0x4
    140c:	41c080e7          	jalr	1052(ra) # 5824 <printf>
    exit(1);
    1410:	4505                	li	a0,1
    1412:	00004097          	auipc	ra,0x4
    1416:	09a080e7          	jalr	154(ra) # 54ac <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    141a:	86aa                	mv	a3,a0
    141c:	f6840613          	addi	a2,s0,-152
    1420:	85b2                	mv	a1,a2
    1422:	00005517          	auipc	a0,0x5
    1426:	14e50513          	addi	a0,a0,334 # 6570 <l_free+0xb2a>
    142a:	00004097          	auipc	ra,0x4
    142e:	3fa080e7          	jalr	1018(ra) # 5824 <printf>
    exit(1);
    1432:	4505                	li	a0,1
    1434:	00004097          	auipc	ra,0x4
    1438:	078080e7          	jalr	120(ra) # 54ac <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    143c:	567d                	li	a2,-1
    143e:	f6840593          	addi	a1,s0,-152
    1442:	00005517          	auipc	a0,0x5
    1446:	15650513          	addi	a0,a0,342 # 6598 <l_free+0xb52>
    144a:	00004097          	auipc	ra,0x4
    144e:	3da080e7          	jalr	986(ra) # 5824 <printf>
    exit(1);
    1452:	4505                	li	a0,1
    1454:	00004097          	auipc	ra,0x4
    1458:	058080e7          	jalr	88(ra) # 54ac <exit>
    printf("fork failed\n");
    145c:	00005517          	auipc	a0,0x5
    1460:	5a450513          	addi	a0,a0,1444 # 6a00 <l_free+0xfba>
    1464:	00004097          	auipc	ra,0x4
    1468:	3c0080e7          	jalr	960(ra) # 5824 <printf>
    exit(1);
    146c:	4505                	li	a0,1
    146e:	00004097          	auipc	ra,0x4
    1472:	03e080e7          	jalr	62(ra) # 54ac <exit>
    exit(747); // OK
    1476:	2eb00513          	li	a0,747
    147a:	00004097          	auipc	ra,0x4
    147e:	032080e7          	jalr	50(ra) # 54ac <exit>
  int st = 0;
    1482:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1486:	f5440513          	addi	a0,s0,-172
    148a:	00004097          	auipc	ra,0x4
    148e:	02a080e7          	jalr	42(ra) # 54b4 <wait>
  if (st != 747) {
    1492:	f5442703          	lw	a4,-172(s0)
    1496:	2eb00793          	li	a5,747
    149a:	00f71663          	bne	a4,a5,14a6 <copyinstr2+0x1dc>
}
    149e:	60ae                	ld	ra,200(sp)
    14a0:	640e                	ld	s0,192(sp)
    14a2:	6169                	addi	sp,sp,208
    14a4:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    14a6:	00005517          	auipc	a0,0x5
    14aa:	13a50513          	addi	a0,a0,314 # 65e0 <l_free+0xb9a>
    14ae:	00004097          	auipc	ra,0x4
    14b2:	376080e7          	jalr	886(ra) # 5824 <printf>
    exit(1);
    14b6:	4505                	li	a0,1
    14b8:	00004097          	auipc	ra,0x4
    14bc:	ff4080e7          	jalr	-12(ra) # 54ac <exit>

00000000000014c0 <truncate3>:
void truncate3(char *s) {
    14c0:	7159                	addi	sp,sp,-112
    14c2:	f486                	sd	ra,104(sp)
    14c4:	f0a2                	sd	s0,96(sp)
    14c6:	eca6                	sd	s1,88(sp)
    14c8:	e8ca                	sd	s2,80(sp)
    14ca:	e4ce                	sd	s3,72(sp)
    14cc:	e0d2                	sd	s4,64(sp)
    14ce:	fc56                	sd	s5,56(sp)
    14d0:	1880                	addi	s0,sp,112
    14d2:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE | O_TRUNC | O_WRONLY));
    14d4:	60100593          	li	a1,1537
    14d8:	00005517          	auipc	a0,0x5
    14dc:	92850513          	addi	a0,a0,-1752 # 5e00 <l_free+0x3ba>
    14e0:	00004097          	auipc	ra,0x4
    14e4:	00c080e7          	jalr	12(ra) # 54ec <open>
    14e8:	00004097          	auipc	ra,0x4
    14ec:	fec080e7          	jalr	-20(ra) # 54d4 <close>
  pid = fork();
    14f0:	00004097          	auipc	ra,0x4
    14f4:	fb4080e7          	jalr	-76(ra) # 54a4 <fork>
  if (pid < 0) {
    14f8:	08054063          	bltz	a0,1578 <truncate3+0xb8>
  if (pid == 0) {
    14fc:	e969                	bnez	a0,15ce <truncate3+0x10e>
    14fe:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    1502:	00005a17          	auipc	s4,0x5
    1506:	8fea0a13          	addi	s4,s4,-1794 # 5e00 <l_free+0x3ba>
      int n = write(fd, "1234567890", 10);
    150a:	00005a97          	auipc	s5,0x5
    150e:	136a8a93          	addi	s5,s5,310 # 6640 <l_free+0xbfa>
      int fd = open("truncfile", O_WRONLY);
    1512:	4585                	li	a1,1
    1514:	8552                	mv	a0,s4
    1516:	00004097          	auipc	ra,0x4
    151a:	fd6080e7          	jalr	-42(ra) # 54ec <open>
    151e:	84aa                	mv	s1,a0
      if (fd < 0) {
    1520:	06054a63          	bltz	a0,1594 <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    1524:	4629                	li	a2,10
    1526:	85d6                	mv	a1,s5
    1528:	00004097          	auipc	ra,0x4
    152c:	fa4080e7          	jalr	-92(ra) # 54cc <write>
      if (n != 10) {
    1530:	47a9                	li	a5,10
    1532:	06f51f63          	bne	a0,a5,15b0 <truncate3+0xf0>
      close(fd);
    1536:	8526                	mv	a0,s1
    1538:	00004097          	auipc	ra,0x4
    153c:	f9c080e7          	jalr	-100(ra) # 54d4 <close>
      fd = open("truncfile", O_RDONLY);
    1540:	4581                	li	a1,0
    1542:	8552                	mv	a0,s4
    1544:	00004097          	auipc	ra,0x4
    1548:	fa8080e7          	jalr	-88(ra) # 54ec <open>
    154c:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    154e:	02000613          	li	a2,32
    1552:	f9840593          	addi	a1,s0,-104
    1556:	00004097          	auipc	ra,0x4
    155a:	f6e080e7          	jalr	-146(ra) # 54c4 <read>
      close(fd);
    155e:	8526                	mv	a0,s1
    1560:	00004097          	auipc	ra,0x4
    1564:	f74080e7          	jalr	-140(ra) # 54d4 <close>
    for (int i = 0; i < 100; i++) {
    1568:	39fd                	addiw	s3,s3,-1
    156a:	fa0994e3          	bnez	s3,1512 <truncate3+0x52>
    exit(0);
    156e:	4501                	li	a0,0
    1570:	00004097          	auipc	ra,0x4
    1574:	f3c080e7          	jalr	-196(ra) # 54ac <exit>
    printf("%s: fork failed\n", s);
    1578:	85ca                	mv	a1,s2
    157a:	00005517          	auipc	a0,0x5
    157e:	09650513          	addi	a0,a0,150 # 6610 <l_free+0xbca>
    1582:	00004097          	auipc	ra,0x4
    1586:	2a2080e7          	jalr	674(ra) # 5824 <printf>
    exit(1);
    158a:	4505                	li	a0,1
    158c:	00004097          	auipc	ra,0x4
    1590:	f20080e7          	jalr	-224(ra) # 54ac <exit>
        printf("%s: open failed\n", s);
    1594:	85ca                	mv	a1,s2
    1596:	00005517          	auipc	a0,0x5
    159a:	09250513          	addi	a0,a0,146 # 6628 <l_free+0xbe2>
    159e:	00004097          	auipc	ra,0x4
    15a2:	286080e7          	jalr	646(ra) # 5824 <printf>
        exit(1);
    15a6:	4505                	li	a0,1
    15a8:	00004097          	auipc	ra,0x4
    15ac:	f04080e7          	jalr	-252(ra) # 54ac <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    15b0:	862a                	mv	a2,a0
    15b2:	85ca                	mv	a1,s2
    15b4:	00005517          	auipc	a0,0x5
    15b8:	09c50513          	addi	a0,a0,156 # 6650 <l_free+0xc0a>
    15bc:	00004097          	auipc	ra,0x4
    15c0:	268080e7          	jalr	616(ra) # 5824 <printf>
        exit(1);
    15c4:	4505                	li	a0,1
    15c6:	00004097          	auipc	ra,0x4
    15ca:	ee6080e7          	jalr	-282(ra) # 54ac <exit>
    15ce:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
    15d2:	00005a17          	auipc	s4,0x5
    15d6:	82ea0a13          	addi	s4,s4,-2002 # 5e00 <l_free+0x3ba>
    int n = write(fd, "xxx", 3);
    15da:	00005a97          	auipc	s5,0x5
    15de:	096a8a93          	addi	s5,s5,150 # 6670 <l_free+0xc2a>
    int fd = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
    15e2:	60100593          	li	a1,1537
    15e6:	8552                	mv	a0,s4
    15e8:	00004097          	auipc	ra,0x4
    15ec:	f04080e7          	jalr	-252(ra) # 54ec <open>
    15f0:	84aa                	mv	s1,a0
    if (fd < 0) {
    15f2:	04054763          	bltz	a0,1640 <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    15f6:	460d                	li	a2,3
    15f8:	85d6                	mv	a1,s5
    15fa:	00004097          	auipc	ra,0x4
    15fe:	ed2080e7          	jalr	-302(ra) # 54cc <write>
    if (n != 3) {
    1602:	478d                	li	a5,3
    1604:	04f51c63          	bne	a0,a5,165c <truncate3+0x19c>
    close(fd);
    1608:	8526                	mv	a0,s1
    160a:	00004097          	auipc	ra,0x4
    160e:	eca080e7          	jalr	-310(ra) # 54d4 <close>
  for (int i = 0; i < 150; i++) {
    1612:	39fd                	addiw	s3,s3,-1
    1614:	fc0997e3          	bnez	s3,15e2 <truncate3+0x122>
  wait(&xstatus);
    1618:	fbc40513          	addi	a0,s0,-68
    161c:	00004097          	auipc	ra,0x4
    1620:	e98080e7          	jalr	-360(ra) # 54b4 <wait>
  unlink("truncfile");
    1624:	00004517          	auipc	a0,0x4
    1628:	7dc50513          	addi	a0,a0,2012 # 5e00 <l_free+0x3ba>
    162c:	00004097          	auipc	ra,0x4
    1630:	ed0080e7          	jalr	-304(ra) # 54fc <unlink>
  exit(xstatus);
    1634:	fbc42503          	lw	a0,-68(s0)
    1638:	00004097          	auipc	ra,0x4
    163c:	e74080e7          	jalr	-396(ra) # 54ac <exit>
      printf("%s: open failed\n", s);
    1640:	85ca                	mv	a1,s2
    1642:	00005517          	auipc	a0,0x5
    1646:	fe650513          	addi	a0,a0,-26 # 6628 <l_free+0xbe2>
    164a:	00004097          	auipc	ra,0x4
    164e:	1da080e7          	jalr	474(ra) # 5824 <printf>
      exit(1);
    1652:	4505                	li	a0,1
    1654:	00004097          	auipc	ra,0x4
    1658:	e58080e7          	jalr	-424(ra) # 54ac <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    165c:	862a                	mv	a2,a0
    165e:	85ca                	mv	a1,s2
    1660:	00005517          	auipc	a0,0x5
    1664:	01850513          	addi	a0,a0,24 # 6678 <l_free+0xc32>
    1668:	00004097          	auipc	ra,0x4
    166c:	1bc080e7          	jalr	444(ra) # 5824 <printf>
      exit(1);
    1670:	4505                	li	a0,1
    1672:	00004097          	auipc	ra,0x4
    1676:	e3a080e7          	jalr	-454(ra) # 54ac <exit>

000000000000167a <exectest>:
void exectest(char *s) {
    167a:	715d                	addi	sp,sp,-80
    167c:	e486                	sd	ra,72(sp)
    167e:	e0a2                	sd	s0,64(sp)
    1680:	fc26                	sd	s1,56(sp)
    1682:	f84a                	sd	s2,48(sp)
    1684:	0880                	addi	s0,sp,80
    1686:	892a                	mv	s2,a0
  char *echoargv[] = {"echo", "OK", 0};
    1688:	00004797          	auipc	a5,0x4
    168c:	72078793          	addi	a5,a5,1824 # 5da8 <l_free+0x362>
    1690:	fcf43023          	sd	a5,-64(s0)
    1694:	00005797          	auipc	a5,0x5
    1698:	00478793          	addi	a5,a5,4 # 6698 <l_free+0xc52>
    169c:	fcf43423          	sd	a5,-56(s0)
    16a0:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    16a4:	00005517          	auipc	a0,0x5
    16a8:	ffc50513          	addi	a0,a0,-4 # 66a0 <l_free+0xc5a>
    16ac:	00004097          	auipc	ra,0x4
    16b0:	e50080e7          	jalr	-432(ra) # 54fc <unlink>
  pid = fork();
    16b4:	00004097          	auipc	ra,0x4
    16b8:	df0080e7          	jalr	-528(ra) # 54a4 <fork>
  if (pid < 0) {
    16bc:	04054663          	bltz	a0,1708 <exectest+0x8e>
    16c0:	84aa                	mv	s1,a0
  if (pid == 0) {
    16c2:	e959                	bnez	a0,1758 <exectest+0xde>
    close(1);
    16c4:	4505                	li	a0,1
    16c6:	00004097          	auipc	ra,0x4
    16ca:	e0e080e7          	jalr	-498(ra) # 54d4 <close>
    fd = open("echo-ok", O_CREATE | O_WRONLY);
    16ce:	20100593          	li	a1,513
    16d2:	00005517          	auipc	a0,0x5
    16d6:	fce50513          	addi	a0,a0,-50 # 66a0 <l_free+0xc5a>
    16da:	00004097          	auipc	ra,0x4
    16de:	e12080e7          	jalr	-494(ra) # 54ec <open>
    if (fd < 0) {
    16e2:	04054163          	bltz	a0,1724 <exectest+0xaa>
    if (fd != 1) {
    16e6:	4785                	li	a5,1
    16e8:	04f50c63          	beq	a0,a5,1740 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    16ec:	85ca                	mv	a1,s2
    16ee:	00005517          	auipc	a0,0x5
    16f2:	fd250513          	addi	a0,a0,-46 # 66c0 <l_free+0xc7a>
    16f6:	00004097          	auipc	ra,0x4
    16fa:	12e080e7          	jalr	302(ra) # 5824 <printf>
      exit(1);
    16fe:	4505                	li	a0,1
    1700:	00004097          	auipc	ra,0x4
    1704:	dac080e7          	jalr	-596(ra) # 54ac <exit>
    printf("%s: fork failed\n", s);
    1708:	85ca                	mv	a1,s2
    170a:	00005517          	auipc	a0,0x5
    170e:	f0650513          	addi	a0,a0,-250 # 6610 <l_free+0xbca>
    1712:	00004097          	auipc	ra,0x4
    1716:	112080e7          	jalr	274(ra) # 5824 <printf>
    exit(1);
    171a:	4505                	li	a0,1
    171c:	00004097          	auipc	ra,0x4
    1720:	d90080e7          	jalr	-624(ra) # 54ac <exit>
      printf("%s: create failed\n", s);
    1724:	85ca                	mv	a1,s2
    1726:	00005517          	auipc	a0,0x5
    172a:	f8250513          	addi	a0,a0,-126 # 66a8 <l_free+0xc62>
    172e:	00004097          	auipc	ra,0x4
    1732:	0f6080e7          	jalr	246(ra) # 5824 <printf>
      exit(1);
    1736:	4505                	li	a0,1
    1738:	00004097          	auipc	ra,0x4
    173c:	d74080e7          	jalr	-652(ra) # 54ac <exit>
    if (exec("echo", echoargv) < 0) {
    1740:	fc040593          	addi	a1,s0,-64
    1744:	00004517          	auipc	a0,0x4
    1748:	66450513          	addi	a0,a0,1636 # 5da8 <l_free+0x362>
    174c:	00004097          	auipc	ra,0x4
    1750:	d98080e7          	jalr	-616(ra) # 54e4 <exec>
    1754:	02054163          	bltz	a0,1776 <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1758:	fdc40513          	addi	a0,s0,-36
    175c:	00004097          	auipc	ra,0x4
    1760:	d58080e7          	jalr	-680(ra) # 54b4 <wait>
    1764:	02951763          	bne	a0,s1,1792 <exectest+0x118>
  if (xstatus != 0)
    1768:	fdc42503          	lw	a0,-36(s0)
    176c:	cd0d                	beqz	a0,17a6 <exectest+0x12c>
    exit(xstatus);
    176e:	00004097          	auipc	ra,0x4
    1772:	d3e080e7          	jalr	-706(ra) # 54ac <exit>
      printf("%s: exec echo failed\n", s);
    1776:	85ca                	mv	a1,s2
    1778:	00005517          	auipc	a0,0x5
    177c:	f5850513          	addi	a0,a0,-168 # 66d0 <l_free+0xc8a>
    1780:	00004097          	auipc	ra,0x4
    1784:	0a4080e7          	jalr	164(ra) # 5824 <printf>
      exit(1);
    1788:	4505                	li	a0,1
    178a:	00004097          	auipc	ra,0x4
    178e:	d22080e7          	jalr	-734(ra) # 54ac <exit>
    printf("%s: wait failed!\n", s);
    1792:	85ca                	mv	a1,s2
    1794:	00005517          	auipc	a0,0x5
    1798:	f5450513          	addi	a0,a0,-172 # 66e8 <l_free+0xca2>
    179c:	00004097          	auipc	ra,0x4
    17a0:	088080e7          	jalr	136(ra) # 5824 <printf>
    17a4:	b7d1                	j	1768 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    17a6:	4581                	li	a1,0
    17a8:	00005517          	auipc	a0,0x5
    17ac:	ef850513          	addi	a0,a0,-264 # 66a0 <l_free+0xc5a>
    17b0:	00004097          	auipc	ra,0x4
    17b4:	d3c080e7          	jalr	-708(ra) # 54ec <open>
  if (fd < 0) {
    17b8:	02054a63          	bltz	a0,17ec <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    17bc:	4609                	li	a2,2
    17be:	fb840593          	addi	a1,s0,-72
    17c2:	00004097          	auipc	ra,0x4
    17c6:	d02080e7          	jalr	-766(ra) # 54c4 <read>
    17ca:	4789                	li	a5,2
    17cc:	02f50e63          	beq	a0,a5,1808 <exectest+0x18e>
    printf("%s: read failed\n", s);
    17d0:	85ca                	mv	a1,s2
    17d2:	00005517          	auipc	a0,0x5
    17d6:	99650513          	addi	a0,a0,-1642 # 6168 <l_free+0x722>
    17da:	00004097          	auipc	ra,0x4
    17de:	04a080e7          	jalr	74(ra) # 5824 <printf>
    exit(1);
    17e2:	4505                	li	a0,1
    17e4:	00004097          	auipc	ra,0x4
    17e8:	cc8080e7          	jalr	-824(ra) # 54ac <exit>
    printf("%s: open failed\n", s);
    17ec:	85ca                	mv	a1,s2
    17ee:	00005517          	auipc	a0,0x5
    17f2:	e3a50513          	addi	a0,a0,-454 # 6628 <l_free+0xbe2>
    17f6:	00004097          	auipc	ra,0x4
    17fa:	02e080e7          	jalr	46(ra) # 5824 <printf>
    exit(1);
    17fe:	4505                	li	a0,1
    1800:	00004097          	auipc	ra,0x4
    1804:	cac080e7          	jalr	-852(ra) # 54ac <exit>
  unlink("echo-ok");
    1808:	00005517          	auipc	a0,0x5
    180c:	e9850513          	addi	a0,a0,-360 # 66a0 <l_free+0xc5a>
    1810:	00004097          	auipc	ra,0x4
    1814:	cec080e7          	jalr	-788(ra) # 54fc <unlink>
  if (buf[0] == 'O' && buf[1] == 'K')
    1818:	fb844703          	lbu	a4,-72(s0)
    181c:	04f00793          	li	a5,79
    1820:	00f71863          	bne	a4,a5,1830 <exectest+0x1b6>
    1824:	fb944703          	lbu	a4,-71(s0)
    1828:	04b00793          	li	a5,75
    182c:	02f70063          	beq	a4,a5,184c <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    1830:	85ca                	mv	a1,s2
    1832:	00005517          	auipc	a0,0x5
    1836:	ece50513          	addi	a0,a0,-306 # 6700 <l_free+0xcba>
    183a:	00004097          	auipc	ra,0x4
    183e:	fea080e7          	jalr	-22(ra) # 5824 <printf>
    exit(1);
    1842:	4505                	li	a0,1
    1844:	00004097          	auipc	ra,0x4
    1848:	c68080e7          	jalr	-920(ra) # 54ac <exit>
    exit(0);
    184c:	4501                	li	a0,0
    184e:	00004097          	auipc	ra,0x4
    1852:	c5e080e7          	jalr	-930(ra) # 54ac <exit>

0000000000001856 <pipe1>:
void pipe1(char *s) {
    1856:	711d                	addi	sp,sp,-96
    1858:	ec86                	sd	ra,88(sp)
    185a:	e8a2                	sd	s0,80(sp)
    185c:	e4a6                	sd	s1,72(sp)
    185e:	e0ca                	sd	s2,64(sp)
    1860:	fc4e                	sd	s3,56(sp)
    1862:	f852                	sd	s4,48(sp)
    1864:	f456                	sd	s5,40(sp)
    1866:	f05a                	sd	s6,32(sp)
    1868:	ec5e                	sd	s7,24(sp)
    186a:	1080                	addi	s0,sp,96
    186c:	892a                	mv	s2,a0
  if (pipe(fds) != 0) {
    186e:	fa840513          	addi	a0,s0,-88
    1872:	00004097          	auipc	ra,0x4
    1876:	c4a080e7          	jalr	-950(ra) # 54bc <pipe>
    187a:	ed25                	bnez	a0,18f2 <pipe1+0x9c>
    187c:	84aa                	mv	s1,a0
  pid = fork();
    187e:	00004097          	auipc	ra,0x4
    1882:	c26080e7          	jalr	-986(ra) # 54a4 <fork>
    1886:	8a2a                	mv	s4,a0
  if (pid == 0) {
    1888:	c159                	beqz	a0,190e <pipe1+0xb8>
  } else if (pid > 0) {
    188a:	16a05e63          	blez	a0,1a06 <pipe1+0x1b0>
    close(fds[1]);
    188e:	fac42503          	lw	a0,-84(s0)
    1892:	00004097          	auipc	ra,0x4
    1896:	c42080e7          	jalr	-958(ra) # 54d4 <close>
    total = 0;
    189a:	8a26                	mv	s4,s1
    cc = 1;
    189c:	4985                	li	s3,1
    while ((n = read(fds[0], buf, cc)) > 0) {
    189e:	0000aa97          	auipc	s5,0xa
    18a2:	11aa8a93          	addi	s5,s5,282 # b9b8 <buf>
      if (cc > sizeof(buf))
    18a6:	6b0d                	lui	s6,0x3
    while ((n = read(fds[0], buf, cc)) > 0) {
    18a8:	864e                	mv	a2,s3
    18aa:	85d6                	mv	a1,s5
    18ac:	fa842503          	lw	a0,-88(s0)
    18b0:	00004097          	auipc	ra,0x4
    18b4:	c14080e7          	jalr	-1004(ra) # 54c4 <read>
    18b8:	10a05263          	blez	a0,19bc <pipe1+0x166>
      for (i = 0; i < n; i++) {
    18bc:	0000a717          	auipc	a4,0xa
    18c0:	0fc70713          	addi	a4,a4,252 # b9b8 <buf>
    18c4:	00a4863b          	addw	a2,s1,a0
        if ((buf[i] & 0xff) != (seq++ & 0xff)) {
    18c8:	00074683          	lbu	a3,0(a4)
    18cc:	0ff4f793          	andi	a5,s1,255
    18d0:	2485                	addiw	s1,s1,1
    18d2:	0cf69163          	bne	a3,a5,1994 <pipe1+0x13e>
      for (i = 0; i < n; i++) {
    18d6:	0705                	addi	a4,a4,1
    18d8:	fec498e3          	bne	s1,a2,18c8 <pipe1+0x72>
      total += n;
    18dc:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    18e0:	0019979b          	slliw	a5,s3,0x1
    18e4:	0007899b          	sext.w	s3,a5
      if (cc > sizeof(buf))
    18e8:	013b7363          	bgeu	s6,s3,18ee <pipe1+0x98>
        cc = sizeof(buf);
    18ec:	89da                	mv	s3,s6
        if ((buf[i] & 0xff) != (seq++ & 0xff)) {
    18ee:	84b2                	mv	s1,a2
    18f0:	bf65                	j	18a8 <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    18f2:	85ca                	mv	a1,s2
    18f4:	00005517          	auipc	a0,0x5
    18f8:	e2450513          	addi	a0,a0,-476 # 6718 <l_free+0xcd2>
    18fc:	00004097          	auipc	ra,0x4
    1900:	f28080e7          	jalr	-216(ra) # 5824 <printf>
    exit(1);
    1904:	4505                	li	a0,1
    1906:	00004097          	auipc	ra,0x4
    190a:	ba6080e7          	jalr	-1114(ra) # 54ac <exit>
    close(fds[0]);
    190e:	fa842503          	lw	a0,-88(s0)
    1912:	00004097          	auipc	ra,0x4
    1916:	bc2080e7          	jalr	-1086(ra) # 54d4 <close>
    for (n = 0; n < N; n++) {
    191a:	0000ab17          	auipc	s6,0xa
    191e:	09eb0b13          	addi	s6,s6,158 # b9b8 <buf>
    1922:	416004bb          	negw	s1,s6
    1926:	0ff4f493          	andi	s1,s1,255
    192a:	409b0993          	addi	s3,s6,1033
      if (write(fds[1], buf, SZ) != SZ) {
    192e:	8bda                	mv	s7,s6
    for (n = 0; n < N; n++) {
    1930:	6a85                	lui	s5,0x1
    1932:	42da8a93          	addi	s5,s5,1069 # 142d <copyinstr2+0x163>
void pipe1(char *s) {
    1936:	87da                	mv	a5,s6
        buf[i] = seq++;
    1938:	0097873b          	addw	a4,a5,s1
    193c:	00e78023          	sb	a4,0(a5)
      for (i = 0; i < SZ; i++)
    1940:	0785                	addi	a5,a5,1
    1942:	fef99be3          	bne	s3,a5,1938 <pipe1+0xe2>
        buf[i] = seq++;
    1946:	409a0a1b          	addiw	s4,s4,1033
      if (write(fds[1], buf, SZ) != SZ) {
    194a:	40900613          	li	a2,1033
    194e:	85de                	mv	a1,s7
    1950:	fac42503          	lw	a0,-84(s0)
    1954:	00004097          	auipc	ra,0x4
    1958:	b78080e7          	jalr	-1160(ra) # 54cc <write>
    195c:	40900793          	li	a5,1033
    1960:	00f51c63          	bne	a0,a5,1978 <pipe1+0x122>
    for (n = 0; n < N; n++) {
    1964:	24a5                	addiw	s1,s1,9
    1966:	0ff4f493          	andi	s1,s1,255
    196a:	fd5a16e3          	bne	s4,s5,1936 <pipe1+0xe0>
    exit(0);
    196e:	4501                	li	a0,0
    1970:	00004097          	auipc	ra,0x4
    1974:	b3c080e7          	jalr	-1220(ra) # 54ac <exit>
        printf("%s: pipe1 oops 1\n", s);
    1978:	85ca                	mv	a1,s2
    197a:	00005517          	auipc	a0,0x5
    197e:	db650513          	addi	a0,a0,-586 # 6730 <l_free+0xcea>
    1982:	00004097          	auipc	ra,0x4
    1986:	ea2080e7          	jalr	-350(ra) # 5824 <printf>
        exit(1);
    198a:	4505                	li	a0,1
    198c:	00004097          	auipc	ra,0x4
    1990:	b20080e7          	jalr	-1248(ra) # 54ac <exit>
          printf("%s: pipe1 oops 2\n", s);
    1994:	85ca                	mv	a1,s2
    1996:	00005517          	auipc	a0,0x5
    199a:	db250513          	addi	a0,a0,-590 # 6748 <l_free+0xd02>
    199e:	00004097          	auipc	ra,0x4
    19a2:	e86080e7          	jalr	-378(ra) # 5824 <printf>
}
    19a6:	60e6                	ld	ra,88(sp)
    19a8:	6446                	ld	s0,80(sp)
    19aa:	64a6                	ld	s1,72(sp)
    19ac:	6906                	ld	s2,64(sp)
    19ae:	79e2                	ld	s3,56(sp)
    19b0:	7a42                	ld	s4,48(sp)
    19b2:	7aa2                	ld	s5,40(sp)
    19b4:	7b02                	ld	s6,32(sp)
    19b6:	6be2                	ld	s7,24(sp)
    19b8:	6125                	addi	sp,sp,96
    19ba:	8082                	ret
    if (total != N * SZ) {
    19bc:	6785                	lui	a5,0x1
    19be:	42d78793          	addi	a5,a5,1069 # 142d <copyinstr2+0x163>
    19c2:	02fa0063          	beq	s4,a5,19e2 <pipe1+0x18c>
      printf("%s: pipe1 oops 3 total %d\n", total);
    19c6:	85d2                	mv	a1,s4
    19c8:	00005517          	auipc	a0,0x5
    19cc:	d9850513          	addi	a0,a0,-616 # 6760 <l_free+0xd1a>
    19d0:	00004097          	auipc	ra,0x4
    19d4:	e54080e7          	jalr	-428(ra) # 5824 <printf>
      exit(1);
    19d8:	4505                	li	a0,1
    19da:	00004097          	auipc	ra,0x4
    19de:	ad2080e7          	jalr	-1326(ra) # 54ac <exit>
    close(fds[0]);
    19e2:	fa842503          	lw	a0,-88(s0)
    19e6:	00004097          	auipc	ra,0x4
    19ea:	aee080e7          	jalr	-1298(ra) # 54d4 <close>
    wait(&xstatus);
    19ee:	fa440513          	addi	a0,s0,-92
    19f2:	00004097          	auipc	ra,0x4
    19f6:	ac2080e7          	jalr	-1342(ra) # 54b4 <wait>
    exit(xstatus);
    19fa:	fa442503          	lw	a0,-92(s0)
    19fe:	00004097          	auipc	ra,0x4
    1a02:	aae080e7          	jalr	-1362(ra) # 54ac <exit>
    printf("%s: fork() failed\n", s);
    1a06:	85ca                	mv	a1,s2
    1a08:	00005517          	auipc	a0,0x5
    1a0c:	d7850513          	addi	a0,a0,-648 # 6780 <l_free+0xd3a>
    1a10:	00004097          	auipc	ra,0x4
    1a14:	e14080e7          	jalr	-492(ra) # 5824 <printf>
    exit(1);
    1a18:	4505                	li	a0,1
    1a1a:	00004097          	auipc	ra,0x4
    1a1e:	a92080e7          	jalr	-1390(ra) # 54ac <exit>

0000000000001a22 <exitwait>:
void exitwait(char *s) {
    1a22:	7139                	addi	sp,sp,-64
    1a24:	fc06                	sd	ra,56(sp)
    1a26:	f822                	sd	s0,48(sp)
    1a28:	f426                	sd	s1,40(sp)
    1a2a:	f04a                	sd	s2,32(sp)
    1a2c:	ec4e                	sd	s3,24(sp)
    1a2e:	e852                	sd	s4,16(sp)
    1a30:	0080                	addi	s0,sp,64
    1a32:	8a2a                	mv	s4,a0
  for (i = 0; i < 100; i++) {
    1a34:	4901                	li	s2,0
    1a36:	06400993          	li	s3,100
    pid = fork();
    1a3a:	00004097          	auipc	ra,0x4
    1a3e:	a6a080e7          	jalr	-1430(ra) # 54a4 <fork>
    1a42:	84aa                	mv	s1,a0
    if (pid < 0) {
    1a44:	02054a63          	bltz	a0,1a78 <exitwait+0x56>
    if (pid) {
    1a48:	c151                	beqz	a0,1acc <exitwait+0xaa>
      if (wait(&xstate) != pid) {
    1a4a:	fcc40513          	addi	a0,s0,-52
    1a4e:	00004097          	auipc	ra,0x4
    1a52:	a66080e7          	jalr	-1434(ra) # 54b4 <wait>
    1a56:	02951f63          	bne	a0,s1,1a94 <exitwait+0x72>
      if (i != xstate) {
    1a5a:	fcc42783          	lw	a5,-52(s0)
    1a5e:	05279963          	bne	a5,s2,1ab0 <exitwait+0x8e>
  for (i = 0; i < 100; i++) {
    1a62:	2905                	addiw	s2,s2,1
    1a64:	fd391be3          	bne	s2,s3,1a3a <exitwait+0x18>
}
    1a68:	70e2                	ld	ra,56(sp)
    1a6a:	7442                	ld	s0,48(sp)
    1a6c:	74a2                	ld	s1,40(sp)
    1a6e:	7902                	ld	s2,32(sp)
    1a70:	69e2                	ld	s3,24(sp)
    1a72:	6a42                	ld	s4,16(sp)
    1a74:	6121                	addi	sp,sp,64
    1a76:	8082                	ret
      printf("%s: fork failed\n", s);
    1a78:	85d2                	mv	a1,s4
    1a7a:	00005517          	auipc	a0,0x5
    1a7e:	b9650513          	addi	a0,a0,-1130 # 6610 <l_free+0xbca>
    1a82:	00004097          	auipc	ra,0x4
    1a86:	da2080e7          	jalr	-606(ra) # 5824 <printf>
      exit(1);
    1a8a:	4505                	li	a0,1
    1a8c:	00004097          	auipc	ra,0x4
    1a90:	a20080e7          	jalr	-1504(ra) # 54ac <exit>
        printf("%s: wait wrong pid\n", s);
    1a94:	85d2                	mv	a1,s4
    1a96:	00005517          	auipc	a0,0x5
    1a9a:	d0250513          	addi	a0,a0,-766 # 6798 <l_free+0xd52>
    1a9e:	00004097          	auipc	ra,0x4
    1aa2:	d86080e7          	jalr	-634(ra) # 5824 <printf>
        exit(1);
    1aa6:	4505                	li	a0,1
    1aa8:	00004097          	auipc	ra,0x4
    1aac:	a04080e7          	jalr	-1532(ra) # 54ac <exit>
        printf("%s: wait wrong exit status\n", s);
    1ab0:	85d2                	mv	a1,s4
    1ab2:	00005517          	auipc	a0,0x5
    1ab6:	cfe50513          	addi	a0,a0,-770 # 67b0 <l_free+0xd6a>
    1aba:	00004097          	auipc	ra,0x4
    1abe:	d6a080e7          	jalr	-662(ra) # 5824 <printf>
        exit(1);
    1ac2:	4505                	li	a0,1
    1ac4:	00004097          	auipc	ra,0x4
    1ac8:	9e8080e7          	jalr	-1560(ra) # 54ac <exit>
      exit(i);
    1acc:	854a                	mv	a0,s2
    1ace:	00004097          	auipc	ra,0x4
    1ad2:	9de080e7          	jalr	-1570(ra) # 54ac <exit>

0000000000001ad6 <twochildren>:
void twochildren(char *s) {
    1ad6:	1101                	addi	sp,sp,-32
    1ad8:	ec06                	sd	ra,24(sp)
    1ada:	e822                	sd	s0,16(sp)
    1adc:	e426                	sd	s1,8(sp)
    1ade:	e04a                	sd	s2,0(sp)
    1ae0:	1000                	addi	s0,sp,32
    1ae2:	892a                	mv	s2,a0
    1ae4:	3e800493          	li	s1,1000
    int pid1 = fork();
    1ae8:	00004097          	auipc	ra,0x4
    1aec:	9bc080e7          	jalr	-1604(ra) # 54a4 <fork>
    if (pid1 < 0) {
    1af0:	02054c63          	bltz	a0,1b28 <twochildren+0x52>
    if (pid1 == 0) {
    1af4:	c921                	beqz	a0,1b44 <twochildren+0x6e>
      int pid2 = fork();
    1af6:	00004097          	auipc	ra,0x4
    1afa:	9ae080e7          	jalr	-1618(ra) # 54a4 <fork>
      if (pid2 < 0) {
    1afe:	04054763          	bltz	a0,1b4c <twochildren+0x76>
      if (pid2 == 0) {
    1b02:	c13d                	beqz	a0,1b68 <twochildren+0x92>
        wait(0);
    1b04:	4501                	li	a0,0
    1b06:	00004097          	auipc	ra,0x4
    1b0a:	9ae080e7          	jalr	-1618(ra) # 54b4 <wait>
        wait(0);
    1b0e:	4501                	li	a0,0
    1b10:	00004097          	auipc	ra,0x4
    1b14:	9a4080e7          	jalr	-1628(ra) # 54b4 <wait>
  for (int i = 0; i < 1000; i++) {
    1b18:	34fd                	addiw	s1,s1,-1
    1b1a:	f4f9                	bnez	s1,1ae8 <twochildren+0x12>
}
    1b1c:	60e2                	ld	ra,24(sp)
    1b1e:	6442                	ld	s0,16(sp)
    1b20:	64a2                	ld	s1,8(sp)
    1b22:	6902                	ld	s2,0(sp)
    1b24:	6105                	addi	sp,sp,32
    1b26:	8082                	ret
      printf("%s: fork failed\n", s);
    1b28:	85ca                	mv	a1,s2
    1b2a:	00005517          	auipc	a0,0x5
    1b2e:	ae650513          	addi	a0,a0,-1306 # 6610 <l_free+0xbca>
    1b32:	00004097          	auipc	ra,0x4
    1b36:	cf2080e7          	jalr	-782(ra) # 5824 <printf>
      exit(1);
    1b3a:	4505                	li	a0,1
    1b3c:	00004097          	auipc	ra,0x4
    1b40:	970080e7          	jalr	-1680(ra) # 54ac <exit>
      exit(0);
    1b44:	00004097          	auipc	ra,0x4
    1b48:	968080e7          	jalr	-1688(ra) # 54ac <exit>
        printf("%s: fork failed\n", s);
    1b4c:	85ca                	mv	a1,s2
    1b4e:	00005517          	auipc	a0,0x5
    1b52:	ac250513          	addi	a0,a0,-1342 # 6610 <l_free+0xbca>
    1b56:	00004097          	auipc	ra,0x4
    1b5a:	cce080e7          	jalr	-818(ra) # 5824 <printf>
        exit(1);
    1b5e:	4505                	li	a0,1
    1b60:	00004097          	auipc	ra,0x4
    1b64:	94c080e7          	jalr	-1716(ra) # 54ac <exit>
        exit(0);
    1b68:	00004097          	auipc	ra,0x4
    1b6c:	944080e7          	jalr	-1724(ra) # 54ac <exit>

0000000000001b70 <forkfork>:
void forkfork(char *s) {
    1b70:	7179                	addi	sp,sp,-48
    1b72:	f406                	sd	ra,40(sp)
    1b74:	f022                	sd	s0,32(sp)
    1b76:	ec26                	sd	s1,24(sp)
    1b78:	1800                	addi	s0,sp,48
    1b7a:	84aa                	mv	s1,a0
    int pid = fork();
    1b7c:	00004097          	auipc	ra,0x4
    1b80:	928080e7          	jalr	-1752(ra) # 54a4 <fork>
    if (pid < 0) {
    1b84:	04054163          	bltz	a0,1bc6 <forkfork+0x56>
    if (pid == 0) {
    1b88:	cd29                	beqz	a0,1be2 <forkfork+0x72>
    int pid = fork();
    1b8a:	00004097          	auipc	ra,0x4
    1b8e:	91a080e7          	jalr	-1766(ra) # 54a4 <fork>
    if (pid < 0) {
    1b92:	02054a63          	bltz	a0,1bc6 <forkfork+0x56>
    if (pid == 0) {
    1b96:	c531                	beqz	a0,1be2 <forkfork+0x72>
    wait(&xstatus);
    1b98:	fdc40513          	addi	a0,s0,-36
    1b9c:	00004097          	auipc	ra,0x4
    1ba0:	918080e7          	jalr	-1768(ra) # 54b4 <wait>
    if (xstatus != 0) {
    1ba4:	fdc42783          	lw	a5,-36(s0)
    1ba8:	ebbd                	bnez	a5,1c1e <forkfork+0xae>
    wait(&xstatus);
    1baa:	fdc40513          	addi	a0,s0,-36
    1bae:	00004097          	auipc	ra,0x4
    1bb2:	906080e7          	jalr	-1786(ra) # 54b4 <wait>
    if (xstatus != 0) {
    1bb6:	fdc42783          	lw	a5,-36(s0)
    1bba:	e3b5                	bnez	a5,1c1e <forkfork+0xae>
}
    1bbc:	70a2                	ld	ra,40(sp)
    1bbe:	7402                	ld	s0,32(sp)
    1bc0:	64e2                	ld	s1,24(sp)
    1bc2:	6145                	addi	sp,sp,48
    1bc4:	8082                	ret
      printf("%s: fork failed", s);
    1bc6:	85a6                	mv	a1,s1
    1bc8:	00005517          	auipc	a0,0x5
    1bcc:	c0850513          	addi	a0,a0,-1016 # 67d0 <l_free+0xd8a>
    1bd0:	00004097          	auipc	ra,0x4
    1bd4:	c54080e7          	jalr	-940(ra) # 5824 <printf>
      exit(1);
    1bd8:	4505                	li	a0,1
    1bda:	00004097          	auipc	ra,0x4
    1bde:	8d2080e7          	jalr	-1838(ra) # 54ac <exit>
void forkfork(char *s) {
    1be2:	0c800493          	li	s1,200
        int pid1 = fork();
    1be6:	00004097          	auipc	ra,0x4
    1bea:	8be080e7          	jalr	-1858(ra) # 54a4 <fork>
        if (pid1 < 0) {
    1bee:	00054f63          	bltz	a0,1c0c <forkfork+0x9c>
        if (pid1 == 0) {
    1bf2:	c115                	beqz	a0,1c16 <forkfork+0xa6>
        wait(0);
    1bf4:	4501                	li	a0,0
    1bf6:	00004097          	auipc	ra,0x4
    1bfa:	8be080e7          	jalr	-1858(ra) # 54b4 <wait>
      for (int j = 0; j < 200; j++) {
    1bfe:	34fd                	addiw	s1,s1,-1
    1c00:	f0fd                	bnez	s1,1be6 <forkfork+0x76>
      exit(0);
    1c02:	4501                	li	a0,0
    1c04:	00004097          	auipc	ra,0x4
    1c08:	8a8080e7          	jalr	-1880(ra) # 54ac <exit>
          exit(1);
    1c0c:	4505                	li	a0,1
    1c0e:	00004097          	auipc	ra,0x4
    1c12:	89e080e7          	jalr	-1890(ra) # 54ac <exit>
          exit(0);
    1c16:	00004097          	auipc	ra,0x4
    1c1a:	896080e7          	jalr	-1898(ra) # 54ac <exit>
      printf("%s: fork in child failed", s);
    1c1e:	85a6                	mv	a1,s1
    1c20:	00005517          	auipc	a0,0x5
    1c24:	bc050513          	addi	a0,a0,-1088 # 67e0 <l_free+0xd9a>
    1c28:	00004097          	auipc	ra,0x4
    1c2c:	bfc080e7          	jalr	-1028(ra) # 5824 <printf>
      exit(1);
    1c30:	4505                	li	a0,1
    1c32:	00004097          	auipc	ra,0x4
    1c36:	87a080e7          	jalr	-1926(ra) # 54ac <exit>

0000000000001c3a <reparent2>:
void reparent2(char *s) {
    1c3a:	1101                	addi	sp,sp,-32
    1c3c:	ec06                	sd	ra,24(sp)
    1c3e:	e822                	sd	s0,16(sp)
    1c40:	e426                	sd	s1,8(sp)
    1c42:	1000                	addi	s0,sp,32
    1c44:	32000493          	li	s1,800
    int pid1 = fork();
    1c48:	00004097          	auipc	ra,0x4
    1c4c:	85c080e7          	jalr	-1956(ra) # 54a4 <fork>
    if (pid1 < 0) {
    1c50:	00054f63          	bltz	a0,1c6e <reparent2+0x34>
    if (pid1 == 0) {
    1c54:	c915                	beqz	a0,1c88 <reparent2+0x4e>
    wait(0);
    1c56:	4501                	li	a0,0
    1c58:	00004097          	auipc	ra,0x4
    1c5c:	85c080e7          	jalr	-1956(ra) # 54b4 <wait>
  for (int i = 0; i < 800; i++) {
    1c60:	34fd                	addiw	s1,s1,-1
    1c62:	f0fd                	bnez	s1,1c48 <reparent2+0xe>
  exit(0);
    1c64:	4501                	li	a0,0
    1c66:	00004097          	auipc	ra,0x4
    1c6a:	846080e7          	jalr	-1978(ra) # 54ac <exit>
      printf("fork failed\n");
    1c6e:	00005517          	auipc	a0,0x5
    1c72:	d9250513          	addi	a0,a0,-622 # 6a00 <l_free+0xfba>
    1c76:	00004097          	auipc	ra,0x4
    1c7a:	bae080e7          	jalr	-1106(ra) # 5824 <printf>
      exit(1);
    1c7e:	4505                	li	a0,1
    1c80:	00004097          	auipc	ra,0x4
    1c84:	82c080e7          	jalr	-2004(ra) # 54ac <exit>
      fork();
    1c88:	00004097          	auipc	ra,0x4
    1c8c:	81c080e7          	jalr	-2020(ra) # 54a4 <fork>
      fork();
    1c90:	00004097          	auipc	ra,0x4
    1c94:	814080e7          	jalr	-2028(ra) # 54a4 <fork>
      exit(0);
    1c98:	4501                	li	a0,0
    1c9a:	00004097          	auipc	ra,0x4
    1c9e:	812080e7          	jalr	-2030(ra) # 54ac <exit>

0000000000001ca2 <createdelete>:
void createdelete(char *s) {
    1ca2:	7175                	addi	sp,sp,-144
    1ca4:	e506                	sd	ra,136(sp)
    1ca6:	e122                	sd	s0,128(sp)
    1ca8:	fca6                	sd	s1,120(sp)
    1caa:	f8ca                	sd	s2,112(sp)
    1cac:	f4ce                	sd	s3,104(sp)
    1cae:	f0d2                	sd	s4,96(sp)
    1cb0:	ecd6                	sd	s5,88(sp)
    1cb2:	e8da                	sd	s6,80(sp)
    1cb4:	e4de                	sd	s7,72(sp)
    1cb6:	e0e2                	sd	s8,64(sp)
    1cb8:	fc66                	sd	s9,56(sp)
    1cba:	0900                	addi	s0,sp,144
    1cbc:	8caa                	mv	s9,a0
  for (pi = 0; pi < NCHILD; pi++) {
    1cbe:	4901                	li	s2,0
    1cc0:	4991                	li	s3,4
    pid = fork();
    1cc2:	00003097          	auipc	ra,0x3
    1cc6:	7e2080e7          	jalr	2018(ra) # 54a4 <fork>
    1cca:	84aa                	mv	s1,a0
    if (pid < 0) {
    1ccc:	02054f63          	bltz	a0,1d0a <createdelete+0x68>
    if (pid == 0) {
    1cd0:	c939                	beqz	a0,1d26 <createdelete+0x84>
  for (pi = 0; pi < NCHILD; pi++) {
    1cd2:	2905                	addiw	s2,s2,1
    1cd4:	ff3917e3          	bne	s2,s3,1cc2 <createdelete+0x20>
    1cd8:	4491                	li	s1,4
    wait(&xstatus);
    1cda:	f7c40513          	addi	a0,s0,-132
    1cde:	00003097          	auipc	ra,0x3
    1ce2:	7d6080e7          	jalr	2006(ra) # 54b4 <wait>
    if (xstatus != 0)
    1ce6:	f7c42903          	lw	s2,-132(s0)
    1cea:	0e091263          	bnez	s2,1dce <createdelete+0x12c>
  for (pi = 0; pi < NCHILD; pi++) {
    1cee:	34fd                	addiw	s1,s1,-1
    1cf0:	f4ed                	bnez	s1,1cda <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1cf2:	f8040123          	sb	zero,-126(s0)
    1cf6:	03000993          	li	s3,48
    1cfa:	5a7d                	li	s4,-1
    1cfc:	07000c13          	li	s8,112
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    1d00:	4b21                	li	s6,8
      if ((i == 0 || i >= N / 2) && fd < 0) {
    1d02:	4ba5                	li	s7,9
    for (pi = 0; pi < NCHILD; pi++) {
    1d04:	07400a93          	li	s5,116
    1d08:	a29d                	j	1e6e <createdelete+0x1cc>
      printf("fork failed\n", s);
    1d0a:	85e6                	mv	a1,s9
    1d0c:	00005517          	auipc	a0,0x5
    1d10:	cf450513          	addi	a0,a0,-780 # 6a00 <l_free+0xfba>
    1d14:	00004097          	auipc	ra,0x4
    1d18:	b10080e7          	jalr	-1264(ra) # 5824 <printf>
      exit(1);
    1d1c:	4505                	li	a0,1
    1d1e:	00003097          	auipc	ra,0x3
    1d22:	78e080e7          	jalr	1934(ra) # 54ac <exit>
      name[0] = 'p' + pi;
    1d26:	0709091b          	addiw	s2,s2,112
    1d2a:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1d2e:	f8040123          	sb	zero,-126(s0)
      for (i = 0; i < N; i++) {
    1d32:	4951                	li	s2,20
    1d34:	a015                	j	1d58 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1d36:	85e6                	mv	a1,s9
    1d38:	00005517          	auipc	a0,0x5
    1d3c:	97050513          	addi	a0,a0,-1680 # 66a8 <l_free+0xc62>
    1d40:	00004097          	auipc	ra,0x4
    1d44:	ae4080e7          	jalr	-1308(ra) # 5824 <printf>
          exit(1);
    1d48:	4505                	li	a0,1
    1d4a:	00003097          	auipc	ra,0x3
    1d4e:	762080e7          	jalr	1890(ra) # 54ac <exit>
      for (i = 0; i < N; i++) {
    1d52:	2485                	addiw	s1,s1,1
    1d54:	07248863          	beq	s1,s2,1dc4 <createdelete+0x122>
        name[1] = '0' + i;
    1d58:	0304879b          	addiw	a5,s1,48
    1d5c:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1d60:	20200593          	li	a1,514
    1d64:	f8040513          	addi	a0,s0,-128
    1d68:	00003097          	auipc	ra,0x3
    1d6c:	784080e7          	jalr	1924(ra) # 54ec <open>
        if (fd < 0) {
    1d70:	fc0543e3          	bltz	a0,1d36 <createdelete+0x94>
        close(fd);
    1d74:	00003097          	auipc	ra,0x3
    1d78:	760080e7          	jalr	1888(ra) # 54d4 <close>
        if (i > 0 && (i % 2) == 0) {
    1d7c:	fc905be3          	blez	s1,1d52 <createdelete+0xb0>
    1d80:	0014f793          	andi	a5,s1,1
    1d84:	f7f9                	bnez	a5,1d52 <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1d86:	01f4d79b          	srliw	a5,s1,0x1f
    1d8a:	9fa5                	addw	a5,a5,s1
    1d8c:	4017d79b          	sraiw	a5,a5,0x1
    1d90:	0307879b          	addiw	a5,a5,48
    1d94:	f8f400a3          	sb	a5,-127(s0)
          if (unlink(name) < 0) {
    1d98:	f8040513          	addi	a0,s0,-128
    1d9c:	00003097          	auipc	ra,0x3
    1da0:	760080e7          	jalr	1888(ra) # 54fc <unlink>
    1da4:	fa0557e3          	bgez	a0,1d52 <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1da8:	85e6                	mv	a1,s9
    1daa:	00005517          	auipc	a0,0x5
    1dae:	a5650513          	addi	a0,a0,-1450 # 6800 <l_free+0xdba>
    1db2:	00004097          	auipc	ra,0x4
    1db6:	a72080e7          	jalr	-1422(ra) # 5824 <printf>
            exit(1);
    1dba:	4505                	li	a0,1
    1dbc:	00003097          	auipc	ra,0x3
    1dc0:	6f0080e7          	jalr	1776(ra) # 54ac <exit>
      exit(0);
    1dc4:	4501                	li	a0,0
    1dc6:	00003097          	auipc	ra,0x3
    1dca:	6e6080e7          	jalr	1766(ra) # 54ac <exit>
      exit(1);
    1dce:	4505                	li	a0,1
    1dd0:	00003097          	auipc	ra,0x3
    1dd4:	6dc080e7          	jalr	1756(ra) # 54ac <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1dd8:	f8040613          	addi	a2,s0,-128
    1ddc:	85e6                	mv	a1,s9
    1dde:	00005517          	auipc	a0,0x5
    1de2:	a3a50513          	addi	a0,a0,-1478 # 6818 <l_free+0xdd2>
    1de6:	00004097          	auipc	ra,0x4
    1dea:	a3e080e7          	jalr	-1474(ra) # 5824 <printf>
        exit(1);
    1dee:	4505                	li	a0,1
    1df0:	00003097          	auipc	ra,0x3
    1df4:	6bc080e7          	jalr	1724(ra) # 54ac <exit>
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    1df8:	054b7163          	bgeu	s6,s4,1e3a <createdelete+0x198>
      if (fd >= 0)
    1dfc:	02055a63          	bgez	a0,1e30 <createdelete+0x18e>
    for (pi = 0; pi < NCHILD; pi++) {
    1e00:	2485                	addiw	s1,s1,1
    1e02:	0ff4f493          	andi	s1,s1,255
    1e06:	05548c63          	beq	s1,s5,1e5e <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1e0a:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1e0e:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1e12:	4581                	li	a1,0
    1e14:	f8040513          	addi	a0,s0,-128
    1e18:	00003097          	auipc	ra,0x3
    1e1c:	6d4080e7          	jalr	1748(ra) # 54ec <open>
      if ((i == 0 || i >= N / 2) && fd < 0) {
    1e20:	00090463          	beqz	s2,1e28 <createdelete+0x186>
    1e24:	fd2bdae3          	bge	s7,s2,1df8 <createdelete+0x156>
    1e28:	fa0548e3          	bltz	a0,1dd8 <createdelete+0x136>
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    1e2c:	014b7963          	bgeu	s6,s4,1e3e <createdelete+0x19c>
        close(fd);
    1e30:	00003097          	auipc	ra,0x3
    1e34:	6a4080e7          	jalr	1700(ra) # 54d4 <close>
    1e38:	b7e1                	j	1e00 <createdelete+0x15e>
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    1e3a:	fc0543e3          	bltz	a0,1e00 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1e3e:	f8040613          	addi	a2,s0,-128
    1e42:	85e6                	mv	a1,s9
    1e44:	00005517          	auipc	a0,0x5
    1e48:	9fc50513          	addi	a0,a0,-1540 # 6840 <l_free+0xdfa>
    1e4c:	00004097          	auipc	ra,0x4
    1e50:	9d8080e7          	jalr	-1576(ra) # 5824 <printf>
        exit(1);
    1e54:	4505                	li	a0,1
    1e56:	00003097          	auipc	ra,0x3
    1e5a:	656080e7          	jalr	1622(ra) # 54ac <exit>
  for (i = 0; i < N; i++) {
    1e5e:	2905                	addiw	s2,s2,1
    1e60:	2a05                	addiw	s4,s4,1
    1e62:	2985                	addiw	s3,s3,1
    1e64:	0ff9f993          	andi	s3,s3,255
    1e68:	47d1                	li	a5,20
    1e6a:	02f90a63          	beq	s2,a5,1e9e <createdelete+0x1fc>
    for (pi = 0; pi < NCHILD; pi++) {
    1e6e:	84e2                	mv	s1,s8
    1e70:	bf69                	j	1e0a <createdelete+0x168>
  for (i = 0; i < N; i++) {
    1e72:	2905                	addiw	s2,s2,1
    1e74:	0ff97913          	andi	s2,s2,255
    1e78:	2985                	addiw	s3,s3,1
    1e7a:	0ff9f993          	andi	s3,s3,255
    1e7e:	03490863          	beq	s2,s4,1eae <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1e82:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1e84:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1e88:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1e8c:	f8040513          	addi	a0,s0,-128
    1e90:	00003097          	auipc	ra,0x3
    1e94:	66c080e7          	jalr	1644(ra) # 54fc <unlink>
    for (pi = 0; pi < NCHILD; pi++) {
    1e98:	34fd                	addiw	s1,s1,-1
    1e9a:	f4ed                	bnez	s1,1e84 <createdelete+0x1e2>
    1e9c:	bfd9                	j	1e72 <createdelete+0x1d0>
    1e9e:	03000993          	li	s3,48
    1ea2:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1ea6:	4a91                	li	s5,4
  for (i = 0; i < N; i++) {
    1ea8:	08400a13          	li	s4,132
    1eac:	bfd9                	j	1e82 <createdelete+0x1e0>
}
    1eae:	60aa                	ld	ra,136(sp)
    1eb0:	640a                	ld	s0,128(sp)
    1eb2:	74e6                	ld	s1,120(sp)
    1eb4:	7946                	ld	s2,112(sp)
    1eb6:	79a6                	ld	s3,104(sp)
    1eb8:	7a06                	ld	s4,96(sp)
    1eba:	6ae6                	ld	s5,88(sp)
    1ebc:	6b46                	ld	s6,80(sp)
    1ebe:	6ba6                	ld	s7,72(sp)
    1ec0:	6c06                	ld	s8,64(sp)
    1ec2:	7ce2                	ld	s9,56(sp)
    1ec4:	6149                	addi	sp,sp,144
    1ec6:	8082                	ret

0000000000001ec8 <linkunlink>:
void linkunlink(char *s) {
    1ec8:	711d                	addi	sp,sp,-96
    1eca:	ec86                	sd	ra,88(sp)
    1ecc:	e8a2                	sd	s0,80(sp)
    1ece:	e4a6                	sd	s1,72(sp)
    1ed0:	e0ca                	sd	s2,64(sp)
    1ed2:	fc4e                	sd	s3,56(sp)
    1ed4:	f852                	sd	s4,48(sp)
    1ed6:	f456                	sd	s5,40(sp)
    1ed8:	f05a                	sd	s6,32(sp)
    1eda:	ec5e                	sd	s7,24(sp)
    1edc:	e862                	sd	s8,16(sp)
    1ede:	e466                	sd	s9,8(sp)
    1ee0:	1080                	addi	s0,sp,96
    1ee2:	84aa                	mv	s1,a0
  unlink("x");
    1ee4:	00004517          	auipc	a0,0x4
    1ee8:	f3450513          	addi	a0,a0,-204 # 5e18 <l_free+0x3d2>
    1eec:	00003097          	auipc	ra,0x3
    1ef0:	610080e7          	jalr	1552(ra) # 54fc <unlink>
  pid = fork();
    1ef4:	00003097          	auipc	ra,0x3
    1ef8:	5b0080e7          	jalr	1456(ra) # 54a4 <fork>
  if (pid < 0) {
    1efc:	02054b63          	bltz	a0,1f32 <linkunlink+0x6a>
    1f00:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1f02:	4c85                	li	s9,1
    1f04:	e119                	bnez	a0,1f0a <linkunlink+0x42>
    1f06:	06100c93          	li	s9,97
    1f0a:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1f0e:	41c659b7          	lui	s3,0x41c65
    1f12:	e6d9899b          	addiw	s3,s3,-403
    1f16:	690d                	lui	s2,0x3
    1f18:	0399091b          	addiw	s2,s2,57
    if ((x % 3) == 0) {
    1f1c:	4a0d                	li	s4,3
    } else if ((x % 3) == 1) {
    1f1e:	4b05                	li	s6,1
      unlink("x");
    1f20:	00004a97          	auipc	s5,0x4
    1f24:	ef8a8a93          	addi	s5,s5,-264 # 5e18 <l_free+0x3d2>
      link("cat", "x");
    1f28:	00005b97          	auipc	s7,0x5
    1f2c:	940b8b93          	addi	s7,s7,-1728 # 6868 <l_free+0xe22>
    1f30:	a825                	j	1f68 <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1f32:	85a6                	mv	a1,s1
    1f34:	00004517          	auipc	a0,0x4
    1f38:	6dc50513          	addi	a0,a0,1756 # 6610 <l_free+0xbca>
    1f3c:	00004097          	auipc	ra,0x4
    1f40:	8e8080e7          	jalr	-1816(ra) # 5824 <printf>
    exit(1);
    1f44:	4505                	li	a0,1
    1f46:	00003097          	auipc	ra,0x3
    1f4a:	566080e7          	jalr	1382(ra) # 54ac <exit>
      close(open("x", O_RDWR | O_CREATE));
    1f4e:	20200593          	li	a1,514
    1f52:	8556                	mv	a0,s5
    1f54:	00003097          	auipc	ra,0x3
    1f58:	598080e7          	jalr	1432(ra) # 54ec <open>
    1f5c:	00003097          	auipc	ra,0x3
    1f60:	578080e7          	jalr	1400(ra) # 54d4 <close>
  for (i = 0; i < 100; i++) {
    1f64:	34fd                	addiw	s1,s1,-1
    1f66:	c88d                	beqz	s1,1f98 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    1f68:	033c87bb          	mulw	a5,s9,s3
    1f6c:	012787bb          	addw	a5,a5,s2
    1f70:	00078c9b          	sext.w	s9,a5
    if ((x % 3) == 0) {
    1f74:	0347f7bb          	remuw	a5,a5,s4
    1f78:	dbf9                	beqz	a5,1f4e <linkunlink+0x86>
    } else if ((x % 3) == 1) {
    1f7a:	01678863          	beq	a5,s6,1f8a <linkunlink+0xc2>
      unlink("x");
    1f7e:	8556                	mv	a0,s5
    1f80:	00003097          	auipc	ra,0x3
    1f84:	57c080e7          	jalr	1404(ra) # 54fc <unlink>
    1f88:	bff1                	j	1f64 <linkunlink+0x9c>
      link("cat", "x");
    1f8a:	85d6                	mv	a1,s5
    1f8c:	855e                	mv	a0,s7
    1f8e:	00003097          	auipc	ra,0x3
    1f92:	57e080e7          	jalr	1406(ra) # 550c <link>
    1f96:	b7f9                	j	1f64 <linkunlink+0x9c>
  if (pid)
    1f98:	020c0463          	beqz	s8,1fc0 <linkunlink+0xf8>
    wait(0);
    1f9c:	4501                	li	a0,0
    1f9e:	00003097          	auipc	ra,0x3
    1fa2:	516080e7          	jalr	1302(ra) # 54b4 <wait>
}
    1fa6:	60e6                	ld	ra,88(sp)
    1fa8:	6446                	ld	s0,80(sp)
    1faa:	64a6                	ld	s1,72(sp)
    1fac:	6906                	ld	s2,64(sp)
    1fae:	79e2                	ld	s3,56(sp)
    1fb0:	7a42                	ld	s4,48(sp)
    1fb2:	7aa2                	ld	s5,40(sp)
    1fb4:	7b02                	ld	s6,32(sp)
    1fb6:	6be2                	ld	s7,24(sp)
    1fb8:	6c42                	ld	s8,16(sp)
    1fba:	6ca2                	ld	s9,8(sp)
    1fbc:	6125                	addi	sp,sp,96
    1fbe:	8082                	ret
    exit(0);
    1fc0:	4501                	li	a0,0
    1fc2:	00003097          	auipc	ra,0x3
    1fc6:	4ea080e7          	jalr	1258(ra) # 54ac <exit>

0000000000001fca <forktest>:
void forktest(char *s) {
    1fca:	7179                	addi	sp,sp,-48
    1fcc:	f406                	sd	ra,40(sp)
    1fce:	f022                	sd	s0,32(sp)
    1fd0:	ec26                	sd	s1,24(sp)
    1fd2:	e84a                	sd	s2,16(sp)
    1fd4:	e44e                	sd	s3,8(sp)
    1fd6:	1800                	addi	s0,sp,48
    1fd8:	89aa                	mv	s3,a0
  for (n = 0; n < N; n++) {
    1fda:	4481                	li	s1,0
    1fdc:	3e800913          	li	s2,1000
    pid = fork();
    1fe0:	00003097          	auipc	ra,0x3
    1fe4:	4c4080e7          	jalr	1220(ra) # 54a4 <fork>
    if (pid < 0)
    1fe8:	02054863          	bltz	a0,2018 <forktest+0x4e>
    if (pid == 0)
    1fec:	c115                	beqz	a0,2010 <forktest+0x46>
  for (n = 0; n < N; n++) {
    1fee:	2485                	addiw	s1,s1,1
    1ff0:	ff2498e3          	bne	s1,s2,1fe0 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1ff4:	85ce                	mv	a1,s3
    1ff6:	00005517          	auipc	a0,0x5
    1ffa:	89250513          	addi	a0,a0,-1902 # 6888 <l_free+0xe42>
    1ffe:	00004097          	auipc	ra,0x4
    2002:	826080e7          	jalr	-2010(ra) # 5824 <printf>
    exit(1);
    2006:	4505                	li	a0,1
    2008:	00003097          	auipc	ra,0x3
    200c:	4a4080e7          	jalr	1188(ra) # 54ac <exit>
      exit(0);
    2010:	00003097          	auipc	ra,0x3
    2014:	49c080e7          	jalr	1180(ra) # 54ac <exit>
  if (n == 0) {
    2018:	cc9d                	beqz	s1,2056 <forktest+0x8c>
  if (n == N) {
    201a:	3e800793          	li	a5,1000
    201e:	fcf48be3          	beq	s1,a5,1ff4 <forktest+0x2a>
  for (; n > 0; n--) {
    2022:	00905b63          	blez	s1,2038 <forktest+0x6e>
    if (wait(0) < 0) {
    2026:	4501                	li	a0,0
    2028:	00003097          	auipc	ra,0x3
    202c:	48c080e7          	jalr	1164(ra) # 54b4 <wait>
    2030:	04054163          	bltz	a0,2072 <forktest+0xa8>
  for (; n > 0; n--) {
    2034:	34fd                	addiw	s1,s1,-1
    2036:	f8e5                	bnez	s1,2026 <forktest+0x5c>
  if (wait(0) != -1) {
    2038:	4501                	li	a0,0
    203a:	00003097          	auipc	ra,0x3
    203e:	47a080e7          	jalr	1146(ra) # 54b4 <wait>
    2042:	57fd                	li	a5,-1
    2044:	04f51563          	bne	a0,a5,208e <forktest+0xc4>
}
    2048:	70a2                	ld	ra,40(sp)
    204a:	7402                	ld	s0,32(sp)
    204c:	64e2                	ld	s1,24(sp)
    204e:	6942                	ld	s2,16(sp)
    2050:	69a2                	ld	s3,8(sp)
    2052:	6145                	addi	sp,sp,48
    2054:	8082                	ret
    printf("%s: no fork at all!\n", s);
    2056:	85ce                	mv	a1,s3
    2058:	00005517          	auipc	a0,0x5
    205c:	81850513          	addi	a0,a0,-2024 # 6870 <l_free+0xe2a>
    2060:	00003097          	auipc	ra,0x3
    2064:	7c4080e7          	jalr	1988(ra) # 5824 <printf>
    exit(1);
    2068:	4505                	li	a0,1
    206a:	00003097          	auipc	ra,0x3
    206e:	442080e7          	jalr	1090(ra) # 54ac <exit>
      printf("%s: wait stopped early\n", s);
    2072:	85ce                	mv	a1,s3
    2074:	00005517          	auipc	a0,0x5
    2078:	83c50513          	addi	a0,a0,-1988 # 68b0 <l_free+0xe6a>
    207c:	00003097          	auipc	ra,0x3
    2080:	7a8080e7          	jalr	1960(ra) # 5824 <printf>
      exit(1);
    2084:	4505                	li	a0,1
    2086:	00003097          	auipc	ra,0x3
    208a:	426080e7          	jalr	1062(ra) # 54ac <exit>
    printf("%s: wait got too many\n", s);
    208e:	85ce                	mv	a1,s3
    2090:	00005517          	auipc	a0,0x5
    2094:	83850513          	addi	a0,a0,-1992 # 68c8 <l_free+0xe82>
    2098:	00003097          	auipc	ra,0x3
    209c:	78c080e7          	jalr	1932(ra) # 5824 <printf>
    exit(1);
    20a0:	4505                	li	a0,1
    20a2:	00003097          	auipc	ra,0x3
    20a6:	40a080e7          	jalr	1034(ra) # 54ac <exit>

00000000000020aa <kernmem>:
void kernmem(char *s) {
    20aa:	715d                	addi	sp,sp,-80
    20ac:	e486                	sd	ra,72(sp)
    20ae:	e0a2                	sd	s0,64(sp)
    20b0:	fc26                	sd	s1,56(sp)
    20b2:	f84a                	sd	s2,48(sp)
    20b4:	f44e                	sd	s3,40(sp)
    20b6:	f052                	sd	s4,32(sp)
    20b8:	ec56                	sd	s5,24(sp)
    20ba:	0880                	addi	s0,sp,80
    20bc:	8a2a                	mv	s4,a0
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    20be:	4485                	li	s1,1
    20c0:	04fe                	slli	s1,s1,0x1f
    if (xstatus != -1) // did kernel kill child?
    20c2:	5afd                	li	s5,-1
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    20c4:	69b1                	lui	s3,0xc
    20c6:	35098993          	addi	s3,s3,848 # c350 <buf+0x998>
    20ca:	1003d937          	lui	s2,0x1003d
    20ce:	090e                	slli	s2,s2,0x3
    20d0:	48090913          	addi	s2,s2,1152 # 1003d480 <__BSS_END__+0x1002eab8>
    pid = fork();
    20d4:	00003097          	auipc	ra,0x3
    20d8:	3d0080e7          	jalr	976(ra) # 54a4 <fork>
    if (pid < 0) {
    20dc:	02054963          	bltz	a0,210e <kernmem+0x64>
    if (pid == 0) {
    20e0:	c529                	beqz	a0,212a <kernmem+0x80>
    wait(&xstatus);
    20e2:	fbc40513          	addi	a0,s0,-68
    20e6:	00003097          	auipc	ra,0x3
    20ea:	3ce080e7          	jalr	974(ra) # 54b4 <wait>
    if (xstatus != -1) // did kernel kill child?
    20ee:	fbc42783          	lw	a5,-68(s0)
    20f2:	05579c63          	bne	a5,s5,214a <kernmem+0xa0>
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    20f6:	94ce                	add	s1,s1,s3
    20f8:	fd249ee3          	bne	s1,s2,20d4 <kernmem+0x2a>
}
    20fc:	60a6                	ld	ra,72(sp)
    20fe:	6406                	ld	s0,64(sp)
    2100:	74e2                	ld	s1,56(sp)
    2102:	7942                	ld	s2,48(sp)
    2104:	79a2                	ld	s3,40(sp)
    2106:	7a02                	ld	s4,32(sp)
    2108:	6ae2                	ld	s5,24(sp)
    210a:	6161                	addi	sp,sp,80
    210c:	8082                	ret
      printf("%s: fork failed\n", s);
    210e:	85d2                	mv	a1,s4
    2110:	00004517          	auipc	a0,0x4
    2114:	50050513          	addi	a0,a0,1280 # 6610 <l_free+0xbca>
    2118:	00003097          	auipc	ra,0x3
    211c:	70c080e7          	jalr	1804(ra) # 5824 <printf>
      exit(1);
    2120:	4505                	li	a0,1
    2122:	00003097          	auipc	ra,0x3
    2126:	38a080e7          	jalr	906(ra) # 54ac <exit>
      printf("%s: oops could read %x = %x\n", a, *a);
    212a:	0004c603          	lbu	a2,0(s1)
    212e:	85a6                	mv	a1,s1
    2130:	00004517          	auipc	a0,0x4
    2134:	7b050513          	addi	a0,a0,1968 # 68e0 <l_free+0xe9a>
    2138:	00003097          	auipc	ra,0x3
    213c:	6ec080e7          	jalr	1772(ra) # 5824 <printf>
      exit(1);
    2140:	4505                	li	a0,1
    2142:	00003097          	auipc	ra,0x3
    2146:	36a080e7          	jalr	874(ra) # 54ac <exit>
      exit(1);
    214a:	4505                	li	a0,1
    214c:	00003097          	auipc	ra,0x3
    2150:	360080e7          	jalr	864(ra) # 54ac <exit>

0000000000002154 <bigargtest>:
void bigargtest(char *s) {
    2154:	7179                	addi	sp,sp,-48
    2156:	f406                	sd	ra,40(sp)
    2158:	f022                	sd	s0,32(sp)
    215a:	ec26                	sd	s1,24(sp)
    215c:	1800                	addi	s0,sp,48
    215e:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    2160:	00004517          	auipc	a0,0x4
    2164:	7a050513          	addi	a0,a0,1952 # 6900 <l_free+0xeba>
    2168:	00003097          	auipc	ra,0x3
    216c:	394080e7          	jalr	916(ra) # 54fc <unlink>
  pid = fork();
    2170:	00003097          	auipc	ra,0x3
    2174:	334080e7          	jalr	820(ra) # 54a4 <fork>
  if (pid == 0) {
    2178:	c121                	beqz	a0,21b8 <bigargtest+0x64>
  } else if (pid < 0) {
    217a:	0a054063          	bltz	a0,221a <bigargtest+0xc6>
  wait(&xstatus);
    217e:	fdc40513          	addi	a0,s0,-36
    2182:	00003097          	auipc	ra,0x3
    2186:	332080e7          	jalr	818(ra) # 54b4 <wait>
  if (xstatus != 0)
    218a:	fdc42503          	lw	a0,-36(s0)
    218e:	e545                	bnez	a0,2236 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    2190:	4581                	li	a1,0
    2192:	00004517          	auipc	a0,0x4
    2196:	76e50513          	addi	a0,a0,1902 # 6900 <l_free+0xeba>
    219a:	00003097          	auipc	ra,0x3
    219e:	352080e7          	jalr	850(ra) # 54ec <open>
  if (fd < 0) {
    21a2:	08054e63          	bltz	a0,223e <bigargtest+0xea>
  close(fd);
    21a6:	00003097          	auipc	ra,0x3
    21aa:	32e080e7          	jalr	814(ra) # 54d4 <close>
}
    21ae:	70a2                	ld	ra,40(sp)
    21b0:	7402                	ld	s0,32(sp)
    21b2:	64e2                	ld	s1,24(sp)
    21b4:	6145                	addi	sp,sp,48
    21b6:	8082                	ret
    21b8:	00006797          	auipc	a5,0x6
    21bc:	fe878793          	addi	a5,a5,-24 # 81a0 <args.1>
    21c0:	00006697          	auipc	a3,0x6
    21c4:	0d868693          	addi	a3,a3,216 # 8298 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                        "
    21c8:	00004717          	auipc	a4,0x4
    21cc:	74870713          	addi	a4,a4,1864 # 6910 <l_free+0xeca>
    21d0:	e398                	sd	a4,0(a5)
    for (i = 0; i < MAXARG - 1; i++)
    21d2:	07a1                	addi	a5,a5,8
    21d4:	fed79ee3          	bne	a5,a3,21d0 <bigargtest+0x7c>
    args[MAXARG - 1] = 0;
    21d8:	00006597          	auipc	a1,0x6
    21dc:	fc858593          	addi	a1,a1,-56 # 81a0 <args.1>
    21e0:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    21e4:	00004517          	auipc	a0,0x4
    21e8:	bc450513          	addi	a0,a0,-1084 # 5da8 <l_free+0x362>
    21ec:	00003097          	auipc	ra,0x3
    21f0:	2f8080e7          	jalr	760(ra) # 54e4 <exec>
    fd = open("bigarg-ok", O_CREATE);
    21f4:	20000593          	li	a1,512
    21f8:	00004517          	auipc	a0,0x4
    21fc:	70850513          	addi	a0,a0,1800 # 6900 <l_free+0xeba>
    2200:	00003097          	auipc	ra,0x3
    2204:	2ec080e7          	jalr	748(ra) # 54ec <open>
    close(fd);
    2208:	00003097          	auipc	ra,0x3
    220c:	2cc080e7          	jalr	716(ra) # 54d4 <close>
    exit(0);
    2210:	4501                	li	a0,0
    2212:	00003097          	auipc	ra,0x3
    2216:	29a080e7          	jalr	666(ra) # 54ac <exit>
    printf("%s: bigargtest: fork failed\n", s);
    221a:	85a6                	mv	a1,s1
    221c:	00004517          	auipc	a0,0x4
    2220:	7d450513          	addi	a0,a0,2004 # 69f0 <l_free+0xfaa>
    2224:	00003097          	auipc	ra,0x3
    2228:	600080e7          	jalr	1536(ra) # 5824 <printf>
    exit(1);
    222c:	4505                	li	a0,1
    222e:	00003097          	auipc	ra,0x3
    2232:	27e080e7          	jalr	638(ra) # 54ac <exit>
    exit(xstatus);
    2236:	00003097          	auipc	ra,0x3
    223a:	276080e7          	jalr	630(ra) # 54ac <exit>
    printf("%s: bigarg test failed!\n", s);
    223e:	85a6                	mv	a1,s1
    2240:	00004517          	auipc	a0,0x4
    2244:	7d050513          	addi	a0,a0,2000 # 6a10 <l_free+0xfca>
    2248:	00003097          	auipc	ra,0x3
    224c:	5dc080e7          	jalr	1500(ra) # 5824 <printf>
    exit(1);
    2250:	4505                	li	a0,1
    2252:	00003097          	auipc	ra,0x3
    2256:	25a080e7          	jalr	602(ra) # 54ac <exit>

000000000000225a <stacktest>:
void stacktest(char *s) {
    225a:	7179                	addi	sp,sp,-48
    225c:	f406                	sd	ra,40(sp)
    225e:	f022                	sd	s0,32(sp)
    2260:	ec26                	sd	s1,24(sp)
    2262:	1800                	addi	s0,sp,48
    2264:	84aa                	mv	s1,a0
  pid = fork();
    2266:	00003097          	auipc	ra,0x3
    226a:	23e080e7          	jalr	574(ra) # 54a4 <fork>
  if (pid == 0) {
    226e:	c115                	beqz	a0,2292 <stacktest+0x38>
  } else if (pid < 0) {
    2270:	04054363          	bltz	a0,22b6 <stacktest+0x5c>
  wait(&xstatus);
    2274:	fdc40513          	addi	a0,s0,-36
    2278:	00003097          	auipc	ra,0x3
    227c:	23c080e7          	jalr	572(ra) # 54b4 <wait>
  if (xstatus == -1) // kernel killed child?
    2280:	fdc42503          	lw	a0,-36(s0)
    2284:	57fd                	li	a5,-1
    2286:	04f50663          	beq	a0,a5,22d2 <stacktest+0x78>
    exit(xstatus);
    228a:	00003097          	auipc	ra,0x3
    228e:	222080e7          	jalr	546(ra) # 54ac <exit>
  return (x & SSTATUS_SIE) != 0;
}

static inline uint64 r_sp() {
  uint64 x;
  asm volatile("mv %0, sp" : "=r"(x));
    2292:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", *sp);
    2294:	77fd                	lui	a5,0xfffff
    2296:	97ba                	add	a5,a5,a4
    2298:	0007c583          	lbu	a1,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff0638>
    229c:	00004517          	auipc	a0,0x4
    22a0:	79450513          	addi	a0,a0,1940 # 6a30 <l_free+0xfea>
    22a4:	00003097          	auipc	ra,0x3
    22a8:	580080e7          	jalr	1408(ra) # 5824 <printf>
    exit(1);
    22ac:	4505                	li	a0,1
    22ae:	00003097          	auipc	ra,0x3
    22b2:	1fe080e7          	jalr	510(ra) # 54ac <exit>
    printf("%s: fork failed\n", s);
    22b6:	85a6                	mv	a1,s1
    22b8:	00004517          	auipc	a0,0x4
    22bc:	35850513          	addi	a0,a0,856 # 6610 <l_free+0xbca>
    22c0:	00003097          	auipc	ra,0x3
    22c4:	564080e7          	jalr	1380(ra) # 5824 <printf>
    exit(1);
    22c8:	4505                	li	a0,1
    22ca:	00003097          	auipc	ra,0x3
    22ce:	1e2080e7          	jalr	482(ra) # 54ac <exit>
    exit(0);
    22d2:	4501                	li	a0,0
    22d4:	00003097          	auipc	ra,0x3
    22d8:	1d8080e7          	jalr	472(ra) # 54ac <exit>

00000000000022dc <copyinstr3>:
void copyinstr3(char *s) {
    22dc:	7179                	addi	sp,sp,-48
    22de:	f406                	sd	ra,40(sp)
    22e0:	f022                	sd	s0,32(sp)
    22e2:	ec26                	sd	s1,24(sp)
    22e4:	1800                	addi	s0,sp,48
  sbrk(8192);
    22e6:	6509                	lui	a0,0x2
    22e8:	00003097          	auipc	ra,0x3
    22ec:	24c080e7          	jalr	588(ra) # 5534 <sbrk>
  uint64 top = (uint64)sbrk(0);
    22f0:	4501                	li	a0,0
    22f2:	00003097          	auipc	ra,0x3
    22f6:	242080e7          	jalr	578(ra) # 5534 <sbrk>
  if ((top % PGSIZE) != 0) {
    22fa:	03451793          	slli	a5,a0,0x34
    22fe:	e3c9                	bnez	a5,2380 <copyinstr3+0xa4>
  top = (uint64)sbrk(0);
    2300:	4501                	li	a0,0
    2302:	00003097          	auipc	ra,0x3
    2306:	232080e7          	jalr	562(ra) # 5534 <sbrk>
  if (top % PGSIZE) {
    230a:	03451793          	slli	a5,a0,0x34
    230e:	e3d9                	bnez	a5,2394 <copyinstr3+0xb8>
  char *b = (char *)(top - 1);
    2310:	fff50493          	addi	s1,a0,-1 # 1fff <forktest+0x35>
  *b = 'x';
    2314:	07800793          	li	a5,120
    2318:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    231c:	8526                	mv	a0,s1
    231e:	00003097          	auipc	ra,0x3
    2322:	1de080e7          	jalr	478(ra) # 54fc <unlink>
  if (ret != -1) {
    2326:	57fd                	li	a5,-1
    2328:	08f51363          	bne	a0,a5,23ae <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    232c:	20100593          	li	a1,513
    2330:	8526                	mv	a0,s1
    2332:	00003097          	auipc	ra,0x3
    2336:	1ba080e7          	jalr	442(ra) # 54ec <open>
  if (fd != -1) {
    233a:	57fd                	li	a5,-1
    233c:	08f51863          	bne	a0,a5,23cc <copyinstr3+0xf0>
  ret = link(b, b);
    2340:	85a6                	mv	a1,s1
    2342:	8526                	mv	a0,s1
    2344:	00003097          	auipc	ra,0x3
    2348:	1c8080e7          	jalr	456(ra) # 550c <link>
  if (ret != -1) {
    234c:	57fd                	li	a5,-1
    234e:	08f51e63          	bne	a0,a5,23ea <copyinstr3+0x10e>
  char *args[] = {"xx", 0};
    2352:	00005797          	auipc	a5,0x5
    2356:	28678793          	addi	a5,a5,646 # 75d8 <l_free+0x1b92>
    235a:	fcf43823          	sd	a5,-48(s0)
    235e:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2362:	fd040593          	addi	a1,s0,-48
    2366:	8526                	mv	a0,s1
    2368:	00003097          	auipc	ra,0x3
    236c:	17c080e7          	jalr	380(ra) # 54e4 <exec>
  if (ret != -1) {
    2370:	57fd                	li	a5,-1
    2372:	08f51c63          	bne	a0,a5,240a <copyinstr3+0x12e>
}
    2376:	70a2                	ld	ra,40(sp)
    2378:	7402                	ld	s0,32(sp)
    237a:	64e2                	ld	s1,24(sp)
    237c:	6145                	addi	sp,sp,48
    237e:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2380:	0347d513          	srli	a0,a5,0x34
    2384:	6785                	lui	a5,0x1
    2386:	40a7853b          	subw	a0,a5,a0
    238a:	00003097          	auipc	ra,0x3
    238e:	1aa080e7          	jalr	426(ra) # 5534 <sbrk>
    2392:	b7bd                	j	2300 <copyinstr3+0x24>
    printf("oops\n");
    2394:	00004517          	auipc	a0,0x4
    2398:	6c450513          	addi	a0,a0,1732 # 6a58 <l_free+0x1012>
    239c:	00003097          	auipc	ra,0x3
    23a0:	488080e7          	jalr	1160(ra) # 5824 <printf>
    exit(1);
    23a4:	4505                	li	a0,1
    23a6:	00003097          	auipc	ra,0x3
    23aa:	106080e7          	jalr	262(ra) # 54ac <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    23ae:	862a                	mv	a2,a0
    23b0:	85a6                	mv	a1,s1
    23b2:	00004517          	auipc	a0,0x4
    23b6:	17e50513          	addi	a0,a0,382 # 6530 <l_free+0xaea>
    23ba:	00003097          	auipc	ra,0x3
    23be:	46a080e7          	jalr	1130(ra) # 5824 <printf>
    exit(1);
    23c2:	4505                	li	a0,1
    23c4:	00003097          	auipc	ra,0x3
    23c8:	0e8080e7          	jalr	232(ra) # 54ac <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    23cc:	862a                	mv	a2,a0
    23ce:	85a6                	mv	a1,s1
    23d0:	00004517          	auipc	a0,0x4
    23d4:	18050513          	addi	a0,a0,384 # 6550 <l_free+0xb0a>
    23d8:	00003097          	auipc	ra,0x3
    23dc:	44c080e7          	jalr	1100(ra) # 5824 <printf>
    exit(1);
    23e0:	4505                	li	a0,1
    23e2:	00003097          	auipc	ra,0x3
    23e6:	0ca080e7          	jalr	202(ra) # 54ac <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    23ea:	86aa                	mv	a3,a0
    23ec:	8626                	mv	a2,s1
    23ee:	85a6                	mv	a1,s1
    23f0:	00004517          	auipc	a0,0x4
    23f4:	18050513          	addi	a0,a0,384 # 6570 <l_free+0xb2a>
    23f8:	00003097          	auipc	ra,0x3
    23fc:	42c080e7          	jalr	1068(ra) # 5824 <printf>
    exit(1);
    2400:	4505                	li	a0,1
    2402:	00003097          	auipc	ra,0x3
    2406:	0aa080e7          	jalr	170(ra) # 54ac <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    240a:	567d                	li	a2,-1
    240c:	85a6                	mv	a1,s1
    240e:	00004517          	auipc	a0,0x4
    2412:	18a50513          	addi	a0,a0,394 # 6598 <l_free+0xb52>
    2416:	00003097          	auipc	ra,0x3
    241a:	40e080e7          	jalr	1038(ra) # 5824 <printf>
    exit(1);
    241e:	4505                	li	a0,1
    2420:	00003097          	auipc	ra,0x3
    2424:	08c080e7          	jalr	140(ra) # 54ac <exit>

0000000000002428 <rwsbrk>:
void rwsbrk() {
    2428:	1101                	addi	sp,sp,-32
    242a:	ec06                	sd	ra,24(sp)
    242c:	e822                	sd	s0,16(sp)
    242e:	e426                	sd	s1,8(sp)
    2430:	e04a                	sd	s2,0(sp)
    2432:	1000                	addi	s0,sp,32
  uint64 a = (uint64)sbrk(8192);
    2434:	6509                	lui	a0,0x2
    2436:	00003097          	auipc	ra,0x3
    243a:	0fe080e7          	jalr	254(ra) # 5534 <sbrk>
  if (a == 0xffffffffffffffffLL) {
    243e:	57fd                	li	a5,-1
    2440:	06f50363          	beq	a0,a5,24a6 <rwsbrk+0x7e>
    2444:	84aa                	mv	s1,a0
  if ((uint64)sbrk(-8192) == 0xffffffffffffffffLL) {
    2446:	7579                	lui	a0,0xffffe
    2448:	00003097          	auipc	ra,0x3
    244c:	0ec080e7          	jalr	236(ra) # 5534 <sbrk>
    2450:	57fd                	li	a5,-1
    2452:	06f50763          	beq	a0,a5,24c0 <rwsbrk+0x98>
  fd = open("rwsbrk", O_CREATE | O_WRONLY);
    2456:	20100593          	li	a1,513
    245a:	00003517          	auipc	a0,0x3
    245e:	66650513          	addi	a0,a0,1638 # 5ac0 <l_free+0x7a>
    2462:	00003097          	auipc	ra,0x3
    2466:	08a080e7          	jalr	138(ra) # 54ec <open>
    246a:	892a                	mv	s2,a0
  if (fd < 0) {
    246c:	06054763          	bltz	a0,24da <rwsbrk+0xb2>
  n = write(fd, (void *)(a + 4096), 1024);
    2470:	6505                	lui	a0,0x1
    2472:	94aa                	add	s1,s1,a0
    2474:	40000613          	li	a2,1024
    2478:	85a6                	mv	a1,s1
    247a:	854a                	mv	a0,s2
    247c:	00003097          	auipc	ra,0x3
    2480:	050080e7          	jalr	80(ra) # 54cc <write>
    2484:	862a                	mv	a2,a0
  if (n >= 0) {
    2486:	06054763          	bltz	a0,24f4 <rwsbrk+0xcc>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a + 4096, n);
    248a:	85a6                	mv	a1,s1
    248c:	00004517          	auipc	a0,0x4
    2490:	62450513          	addi	a0,a0,1572 # 6ab0 <l_free+0x106a>
    2494:	00003097          	auipc	ra,0x3
    2498:	390080e7          	jalr	912(ra) # 5824 <printf>
    exit(1);
    249c:	4505                	li	a0,1
    249e:	00003097          	auipc	ra,0x3
    24a2:	00e080e7          	jalr	14(ra) # 54ac <exit>
    printf("sbrk(rwsbrk) failed\n");
    24a6:	00004517          	auipc	a0,0x4
    24aa:	5ba50513          	addi	a0,a0,1466 # 6a60 <l_free+0x101a>
    24ae:	00003097          	auipc	ra,0x3
    24b2:	376080e7          	jalr	886(ra) # 5824 <printf>
    exit(1);
    24b6:	4505                	li	a0,1
    24b8:	00003097          	auipc	ra,0x3
    24bc:	ff4080e7          	jalr	-12(ra) # 54ac <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    24c0:	00004517          	auipc	a0,0x4
    24c4:	5b850513          	addi	a0,a0,1464 # 6a78 <l_free+0x1032>
    24c8:	00003097          	auipc	ra,0x3
    24cc:	35c080e7          	jalr	860(ra) # 5824 <printf>
    exit(1);
    24d0:	4505                	li	a0,1
    24d2:	00003097          	auipc	ra,0x3
    24d6:	fda080e7          	jalr	-38(ra) # 54ac <exit>
    printf("open(rwsbrk) failed\n");
    24da:	00004517          	auipc	a0,0x4
    24de:	5be50513          	addi	a0,a0,1470 # 6a98 <l_free+0x1052>
    24e2:	00003097          	auipc	ra,0x3
    24e6:	342080e7          	jalr	834(ra) # 5824 <printf>
    exit(1);
    24ea:	4505                	li	a0,1
    24ec:	00003097          	auipc	ra,0x3
    24f0:	fc0080e7          	jalr	-64(ra) # 54ac <exit>
  close(fd);
    24f4:	854a                	mv	a0,s2
    24f6:	00003097          	auipc	ra,0x3
    24fa:	fde080e7          	jalr	-34(ra) # 54d4 <close>
  unlink("rwsbrk");
    24fe:	00003517          	auipc	a0,0x3
    2502:	5c250513          	addi	a0,a0,1474 # 5ac0 <l_free+0x7a>
    2506:	00003097          	auipc	ra,0x3
    250a:	ff6080e7          	jalr	-10(ra) # 54fc <unlink>
  fd = open("README", O_RDONLY);
    250e:	4581                	li	a1,0
    2510:	00004517          	auipc	a0,0x4
    2514:	a6050513          	addi	a0,a0,-1440 # 5f70 <l_free+0x52a>
    2518:	00003097          	auipc	ra,0x3
    251c:	fd4080e7          	jalr	-44(ra) # 54ec <open>
    2520:	892a                	mv	s2,a0
  if (fd < 0) {
    2522:	02054963          	bltz	a0,2554 <rwsbrk+0x12c>
  n = read(fd, (void *)(a + 4096), 10);
    2526:	4629                	li	a2,10
    2528:	85a6                	mv	a1,s1
    252a:	00003097          	auipc	ra,0x3
    252e:	f9a080e7          	jalr	-102(ra) # 54c4 <read>
    2532:	862a                	mv	a2,a0
  if (n >= 0) {
    2534:	02054d63          	bltz	a0,256e <rwsbrk+0x146>
    printf("read(fd, %p, 10) returned %d, not -1\n", a + 4096, n);
    2538:	85a6                	mv	a1,s1
    253a:	00004517          	auipc	a0,0x4
    253e:	5a650513          	addi	a0,a0,1446 # 6ae0 <l_free+0x109a>
    2542:	00003097          	auipc	ra,0x3
    2546:	2e2080e7          	jalr	738(ra) # 5824 <printf>
    exit(1);
    254a:	4505                	li	a0,1
    254c:	00003097          	auipc	ra,0x3
    2550:	f60080e7          	jalr	-160(ra) # 54ac <exit>
    printf("open(rwsbrk) failed\n");
    2554:	00004517          	auipc	a0,0x4
    2558:	54450513          	addi	a0,a0,1348 # 6a98 <l_free+0x1052>
    255c:	00003097          	auipc	ra,0x3
    2560:	2c8080e7          	jalr	712(ra) # 5824 <printf>
    exit(1);
    2564:	4505                	li	a0,1
    2566:	00003097          	auipc	ra,0x3
    256a:	f46080e7          	jalr	-186(ra) # 54ac <exit>
  close(fd);
    256e:	854a                	mv	a0,s2
    2570:	00003097          	auipc	ra,0x3
    2574:	f64080e7          	jalr	-156(ra) # 54d4 <close>
  exit(0);
    2578:	4501                	li	a0,0
    257a:	00003097          	auipc	ra,0x3
    257e:	f32080e7          	jalr	-206(ra) # 54ac <exit>

0000000000002582 <sbrkmuch>:
void sbrkmuch(char *s) {
    2582:	7179                	addi	sp,sp,-48
    2584:	f406                	sd	ra,40(sp)
    2586:	f022                	sd	s0,32(sp)
    2588:	ec26                	sd	s1,24(sp)
    258a:	e84a                	sd	s2,16(sp)
    258c:	e44e                	sd	s3,8(sp)
    258e:	e052                	sd	s4,0(sp)
    2590:	1800                	addi	s0,sp,48
    2592:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2594:	4501                	li	a0,0
    2596:	00003097          	auipc	ra,0x3
    259a:	f9e080e7          	jalr	-98(ra) # 5534 <sbrk>
    259e:	892a                	mv	s2,a0
  a = sbrk(0);
    25a0:	4501                	li	a0,0
    25a2:	00003097          	auipc	ra,0x3
    25a6:	f92080e7          	jalr	-110(ra) # 5534 <sbrk>
    25aa:	84aa                	mv	s1,a0
  p = sbrk(amt);
    25ac:	06400537          	lui	a0,0x6400
    25b0:	9d05                	subw	a0,a0,s1
    25b2:	00003097          	auipc	ra,0x3
    25b6:	f82080e7          	jalr	-126(ra) # 5534 <sbrk>
  if (p != a) {
    25ba:	0ca49863          	bne	s1,a0,268a <sbrkmuch+0x108>
  char *eee = sbrk(0);
    25be:	4501                	li	a0,0
    25c0:	00003097          	auipc	ra,0x3
    25c4:	f74080e7          	jalr	-140(ra) # 5534 <sbrk>
    25c8:	87aa                	mv	a5,a0
  for (char *pp = a; pp < eee; pp += 4096)
    25ca:	00a4f963          	bgeu	s1,a0,25dc <sbrkmuch+0x5a>
    *pp = 1;
    25ce:	4685                	li	a3,1
  for (char *pp = a; pp < eee; pp += 4096)
    25d0:	6705                	lui	a4,0x1
    *pp = 1;
    25d2:	00d48023          	sb	a3,0(s1)
  for (char *pp = a; pp < eee; pp += 4096)
    25d6:	94ba                	add	s1,s1,a4
    25d8:	fef4ede3          	bltu	s1,a5,25d2 <sbrkmuch+0x50>
  *lastaddr = 99;
    25dc:	064007b7          	lui	a5,0x6400
    25e0:	06300713          	li	a4,99
    25e4:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f1637>
  a = sbrk(0);
    25e8:	4501                	li	a0,0
    25ea:	00003097          	auipc	ra,0x3
    25ee:	f4a080e7          	jalr	-182(ra) # 5534 <sbrk>
    25f2:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    25f4:	757d                	lui	a0,0xfffff
    25f6:	00003097          	auipc	ra,0x3
    25fa:	f3e080e7          	jalr	-194(ra) # 5534 <sbrk>
  if (c == (char *)0xffffffffffffffffL) {
    25fe:	57fd                	li	a5,-1
    2600:	0af50363          	beq	a0,a5,26a6 <sbrkmuch+0x124>
  c = sbrk(0);
    2604:	4501                	li	a0,0
    2606:	00003097          	auipc	ra,0x3
    260a:	f2e080e7          	jalr	-210(ra) # 5534 <sbrk>
  if (c != a - PGSIZE) {
    260e:	77fd                	lui	a5,0xfffff
    2610:	97a6                	add	a5,a5,s1
    2612:	0af51863          	bne	a0,a5,26c2 <sbrkmuch+0x140>
  a = sbrk(0);
    2616:	4501                	li	a0,0
    2618:	00003097          	auipc	ra,0x3
    261c:	f1c080e7          	jalr	-228(ra) # 5534 <sbrk>
    2620:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2622:	6505                	lui	a0,0x1
    2624:	00003097          	auipc	ra,0x3
    2628:	f10080e7          	jalr	-240(ra) # 5534 <sbrk>
    262c:	8a2a                	mv	s4,a0
  if (c != a || sbrk(0) != a + PGSIZE) {
    262e:	0aa49963          	bne	s1,a0,26e0 <sbrkmuch+0x15e>
    2632:	4501                	li	a0,0
    2634:	00003097          	auipc	ra,0x3
    2638:	f00080e7          	jalr	-256(ra) # 5534 <sbrk>
    263c:	6785                	lui	a5,0x1
    263e:	97a6                	add	a5,a5,s1
    2640:	0af51063          	bne	a0,a5,26e0 <sbrkmuch+0x15e>
  if (*lastaddr == 99) {
    2644:	064007b7          	lui	a5,0x6400
    2648:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f1637>
    264c:	06300793          	li	a5,99
    2650:	0af70763          	beq	a4,a5,26fe <sbrkmuch+0x17c>
  a = sbrk(0);
    2654:	4501                	li	a0,0
    2656:	00003097          	auipc	ra,0x3
    265a:	ede080e7          	jalr	-290(ra) # 5534 <sbrk>
    265e:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2660:	4501                	li	a0,0
    2662:	00003097          	auipc	ra,0x3
    2666:	ed2080e7          	jalr	-302(ra) # 5534 <sbrk>
    266a:	40a9053b          	subw	a0,s2,a0
    266e:	00003097          	auipc	ra,0x3
    2672:	ec6080e7          	jalr	-314(ra) # 5534 <sbrk>
  if (c != a) {
    2676:	0aa49263          	bne	s1,a0,271a <sbrkmuch+0x198>
}
    267a:	70a2                	ld	ra,40(sp)
    267c:	7402                	ld	s0,32(sp)
    267e:	64e2                	ld	s1,24(sp)
    2680:	6942                	ld	s2,16(sp)
    2682:	69a2                	ld	s3,8(sp)
    2684:	6a02                	ld	s4,0(sp)
    2686:	6145                	addi	sp,sp,48
    2688:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n",
    268a:	85ce                	mv	a1,s3
    268c:	00004517          	auipc	a0,0x4
    2690:	47c50513          	addi	a0,a0,1148 # 6b08 <l_free+0x10c2>
    2694:	00003097          	auipc	ra,0x3
    2698:	190080e7          	jalr	400(ra) # 5824 <printf>
    exit(1);
    269c:	4505                	li	a0,1
    269e:	00003097          	auipc	ra,0x3
    26a2:	e0e080e7          	jalr	-498(ra) # 54ac <exit>
    printf("%s: sbrk could not deallocate\n", s);
    26a6:	85ce                	mv	a1,s3
    26a8:	00004517          	auipc	a0,0x4
    26ac:	4a850513          	addi	a0,a0,1192 # 6b50 <l_free+0x110a>
    26b0:	00003097          	auipc	ra,0x3
    26b4:	174080e7          	jalr	372(ra) # 5824 <printf>
    exit(1);
    26b8:	4505                	li	a0,1
    26ba:	00003097          	auipc	ra,0x3
    26be:	df2080e7          	jalr	-526(ra) # 54ac <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    26c2:	862a                	mv	a2,a0
    26c4:	85a6                	mv	a1,s1
    26c6:	00004517          	auipc	a0,0x4
    26ca:	4aa50513          	addi	a0,a0,1194 # 6b70 <l_free+0x112a>
    26ce:	00003097          	auipc	ra,0x3
    26d2:	156080e7          	jalr	342(ra) # 5824 <printf>
    exit(1);
    26d6:	4505                	li	a0,1
    26d8:	00003097          	auipc	ra,0x3
    26dc:	dd4080e7          	jalr	-556(ra) # 54ac <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", a, c);
    26e0:	8652                	mv	a2,s4
    26e2:	85a6                	mv	a1,s1
    26e4:	00004517          	auipc	a0,0x4
    26e8:	4cc50513          	addi	a0,a0,1228 # 6bb0 <l_free+0x116a>
    26ec:	00003097          	auipc	ra,0x3
    26f0:	138080e7          	jalr	312(ra) # 5824 <printf>
    exit(1);
    26f4:	4505                	li	a0,1
    26f6:	00003097          	auipc	ra,0x3
    26fa:	db6080e7          	jalr	-586(ra) # 54ac <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    26fe:	85ce                	mv	a1,s3
    2700:	00004517          	auipc	a0,0x4
    2704:	4e050513          	addi	a0,a0,1248 # 6be0 <l_free+0x119a>
    2708:	00003097          	auipc	ra,0x3
    270c:	11c080e7          	jalr	284(ra) # 5824 <printf>
    exit(1);
    2710:	4505                	li	a0,1
    2712:	00003097          	auipc	ra,0x3
    2716:	d9a080e7          	jalr	-614(ra) # 54ac <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", a, c);
    271a:	862a                	mv	a2,a0
    271c:	85a6                	mv	a1,s1
    271e:	00004517          	auipc	a0,0x4
    2722:	4fa50513          	addi	a0,a0,1274 # 6c18 <l_free+0x11d2>
    2726:	00003097          	auipc	ra,0x3
    272a:	0fe080e7          	jalr	254(ra) # 5824 <printf>
    exit(1);
    272e:	4505                	li	a0,1
    2730:	00003097          	auipc	ra,0x3
    2734:	d7c080e7          	jalr	-644(ra) # 54ac <exit>

0000000000002738 <sbrkarg>:
void sbrkarg(char *s) {
    2738:	7179                	addi	sp,sp,-48
    273a:	f406                	sd	ra,40(sp)
    273c:	f022                	sd	s0,32(sp)
    273e:	ec26                	sd	s1,24(sp)
    2740:	e84a                	sd	s2,16(sp)
    2742:	e44e                	sd	s3,8(sp)
    2744:	1800                	addi	s0,sp,48
    2746:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2748:	6505                	lui	a0,0x1
    274a:	00003097          	auipc	ra,0x3
    274e:	dea080e7          	jalr	-534(ra) # 5534 <sbrk>
    2752:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE | O_WRONLY);
    2754:	20100593          	li	a1,513
    2758:	00004517          	auipc	a0,0x4
    275c:	4e850513          	addi	a0,a0,1256 # 6c40 <l_free+0x11fa>
    2760:	00003097          	auipc	ra,0x3
    2764:	d8c080e7          	jalr	-628(ra) # 54ec <open>
    2768:	84aa                	mv	s1,a0
  unlink("sbrk");
    276a:	00004517          	auipc	a0,0x4
    276e:	4d650513          	addi	a0,a0,1238 # 6c40 <l_free+0x11fa>
    2772:	00003097          	auipc	ra,0x3
    2776:	d8a080e7          	jalr	-630(ra) # 54fc <unlink>
  if (fd < 0) {
    277a:	0404c163          	bltz	s1,27bc <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    277e:	6605                	lui	a2,0x1
    2780:	85ca                	mv	a1,s2
    2782:	8526                	mv	a0,s1
    2784:	00003097          	auipc	ra,0x3
    2788:	d48080e7          	jalr	-696(ra) # 54cc <write>
    278c:	04054663          	bltz	a0,27d8 <sbrkarg+0xa0>
  close(fd);
    2790:	8526                	mv	a0,s1
    2792:	00003097          	auipc	ra,0x3
    2796:	d42080e7          	jalr	-702(ra) # 54d4 <close>
  a = sbrk(PGSIZE);
    279a:	6505                	lui	a0,0x1
    279c:	00003097          	auipc	ra,0x3
    27a0:	d98080e7          	jalr	-616(ra) # 5534 <sbrk>
  if (pipe((int *)a) != 0) {
    27a4:	00003097          	auipc	ra,0x3
    27a8:	d18080e7          	jalr	-744(ra) # 54bc <pipe>
    27ac:	e521                	bnez	a0,27f4 <sbrkarg+0xbc>
}
    27ae:	70a2                	ld	ra,40(sp)
    27b0:	7402                	ld	s0,32(sp)
    27b2:	64e2                	ld	s1,24(sp)
    27b4:	6942                	ld	s2,16(sp)
    27b6:	69a2                	ld	s3,8(sp)
    27b8:	6145                	addi	sp,sp,48
    27ba:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    27bc:	85ce                	mv	a1,s3
    27be:	00004517          	auipc	a0,0x4
    27c2:	48a50513          	addi	a0,a0,1162 # 6c48 <l_free+0x1202>
    27c6:	00003097          	auipc	ra,0x3
    27ca:	05e080e7          	jalr	94(ra) # 5824 <printf>
    exit(1);
    27ce:	4505                	li	a0,1
    27d0:	00003097          	auipc	ra,0x3
    27d4:	cdc080e7          	jalr	-804(ra) # 54ac <exit>
    printf("%s: write sbrk failed\n", s);
    27d8:	85ce                	mv	a1,s3
    27da:	00004517          	auipc	a0,0x4
    27de:	48650513          	addi	a0,a0,1158 # 6c60 <l_free+0x121a>
    27e2:	00003097          	auipc	ra,0x3
    27e6:	042080e7          	jalr	66(ra) # 5824 <printf>
    exit(1);
    27ea:	4505                	li	a0,1
    27ec:	00003097          	auipc	ra,0x3
    27f0:	cc0080e7          	jalr	-832(ra) # 54ac <exit>
    printf("%s: pipe() failed\n", s);
    27f4:	85ce                	mv	a1,s3
    27f6:	00004517          	auipc	a0,0x4
    27fa:	f2250513          	addi	a0,a0,-222 # 6718 <l_free+0xcd2>
    27fe:	00003097          	auipc	ra,0x3
    2802:	026080e7          	jalr	38(ra) # 5824 <printf>
    exit(1);
    2806:	4505                	li	a0,1
    2808:	00003097          	auipc	ra,0x3
    280c:	ca4080e7          	jalr	-860(ra) # 54ac <exit>

0000000000002810 <argptest>:
void argptest(char *s) {
    2810:	1101                	addi	sp,sp,-32
    2812:	ec06                	sd	ra,24(sp)
    2814:	e822                	sd	s0,16(sp)
    2816:	e426                	sd	s1,8(sp)
    2818:	e04a                	sd	s2,0(sp)
    281a:	1000                	addi	s0,sp,32
    281c:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    281e:	4581                	li	a1,0
    2820:	00004517          	auipc	a0,0x4
    2824:	45850513          	addi	a0,a0,1112 # 6c78 <l_free+0x1232>
    2828:	00003097          	auipc	ra,0x3
    282c:	cc4080e7          	jalr	-828(ra) # 54ec <open>
  if (fd < 0) {
    2830:	02054b63          	bltz	a0,2866 <argptest+0x56>
    2834:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2836:	4501                	li	a0,0
    2838:	00003097          	auipc	ra,0x3
    283c:	cfc080e7          	jalr	-772(ra) # 5534 <sbrk>
    2840:	567d                	li	a2,-1
    2842:	fff50593          	addi	a1,a0,-1
    2846:	8526                	mv	a0,s1
    2848:	00003097          	auipc	ra,0x3
    284c:	c7c080e7          	jalr	-900(ra) # 54c4 <read>
  close(fd);
    2850:	8526                	mv	a0,s1
    2852:	00003097          	auipc	ra,0x3
    2856:	c82080e7          	jalr	-894(ra) # 54d4 <close>
}
    285a:	60e2                	ld	ra,24(sp)
    285c:	6442                	ld	s0,16(sp)
    285e:	64a2                	ld	s1,8(sp)
    2860:	6902                	ld	s2,0(sp)
    2862:	6105                	addi	sp,sp,32
    2864:	8082                	ret
    printf("%s: open failed\n", s);
    2866:	85ca                	mv	a1,s2
    2868:	00004517          	auipc	a0,0x4
    286c:	dc050513          	addi	a0,a0,-576 # 6628 <l_free+0xbe2>
    2870:	00003097          	auipc	ra,0x3
    2874:	fb4080e7          	jalr	-76(ra) # 5824 <printf>
    exit(1);
    2878:	4505                	li	a0,1
    287a:	00003097          	auipc	ra,0x3
    287e:	c32080e7          	jalr	-974(ra) # 54ac <exit>

0000000000002882 <sbrkbugs>:
void sbrkbugs(char *s) {
    2882:	1141                	addi	sp,sp,-16
    2884:	e406                	sd	ra,8(sp)
    2886:	e022                	sd	s0,0(sp)
    2888:	0800                	addi	s0,sp,16
  int pid = fork();
    288a:	00003097          	auipc	ra,0x3
    288e:	c1a080e7          	jalr	-998(ra) # 54a4 <fork>
  if (pid < 0) {
    2892:	02054263          	bltz	a0,28b6 <sbrkbugs+0x34>
  if (pid == 0) {
    2896:	ed0d                	bnez	a0,28d0 <sbrkbugs+0x4e>
    int sz = (uint64)sbrk(0);
    2898:	00003097          	auipc	ra,0x3
    289c:	c9c080e7          	jalr	-868(ra) # 5534 <sbrk>
    sbrk(-sz);
    28a0:	40a0053b          	negw	a0,a0
    28a4:	00003097          	auipc	ra,0x3
    28a8:	c90080e7          	jalr	-880(ra) # 5534 <sbrk>
    exit(0);
    28ac:	4501                	li	a0,0
    28ae:	00003097          	auipc	ra,0x3
    28b2:	bfe080e7          	jalr	-1026(ra) # 54ac <exit>
    printf("fork failed\n");
    28b6:	00004517          	auipc	a0,0x4
    28ba:	14a50513          	addi	a0,a0,330 # 6a00 <l_free+0xfba>
    28be:	00003097          	auipc	ra,0x3
    28c2:	f66080e7          	jalr	-154(ra) # 5824 <printf>
    exit(1);
    28c6:	4505                	li	a0,1
    28c8:	00003097          	auipc	ra,0x3
    28cc:	be4080e7          	jalr	-1052(ra) # 54ac <exit>
  wait(0);
    28d0:	4501                	li	a0,0
    28d2:	00003097          	auipc	ra,0x3
    28d6:	be2080e7          	jalr	-1054(ra) # 54b4 <wait>
  pid = fork();
    28da:	00003097          	auipc	ra,0x3
    28de:	bca080e7          	jalr	-1078(ra) # 54a4 <fork>
  if (pid < 0) {
    28e2:	02054563          	bltz	a0,290c <sbrkbugs+0x8a>
  if (pid == 0) {
    28e6:	e121                	bnez	a0,2926 <sbrkbugs+0xa4>
    int sz = (uint64)sbrk(0);
    28e8:	00003097          	auipc	ra,0x3
    28ec:	c4c080e7          	jalr	-948(ra) # 5534 <sbrk>
    sbrk(-(sz - 3500));
    28f0:	6785                	lui	a5,0x1
    28f2:	dac7879b          	addiw	a5,a5,-596
    28f6:	40a7853b          	subw	a0,a5,a0
    28fa:	00003097          	auipc	ra,0x3
    28fe:	c3a080e7          	jalr	-966(ra) # 5534 <sbrk>
    exit(0);
    2902:	4501                	li	a0,0
    2904:	00003097          	auipc	ra,0x3
    2908:	ba8080e7          	jalr	-1112(ra) # 54ac <exit>
    printf("fork failed\n");
    290c:	00004517          	auipc	a0,0x4
    2910:	0f450513          	addi	a0,a0,244 # 6a00 <l_free+0xfba>
    2914:	00003097          	auipc	ra,0x3
    2918:	f10080e7          	jalr	-240(ra) # 5824 <printf>
    exit(1);
    291c:	4505                	li	a0,1
    291e:	00003097          	auipc	ra,0x3
    2922:	b8e080e7          	jalr	-1138(ra) # 54ac <exit>
  wait(0);
    2926:	4501                	li	a0,0
    2928:	00003097          	auipc	ra,0x3
    292c:	b8c080e7          	jalr	-1140(ra) # 54b4 <wait>
  pid = fork();
    2930:	00003097          	auipc	ra,0x3
    2934:	b74080e7          	jalr	-1164(ra) # 54a4 <fork>
  if (pid < 0) {
    2938:	02054a63          	bltz	a0,296c <sbrkbugs+0xea>
  if (pid == 0) {
    293c:	e529                	bnez	a0,2986 <sbrkbugs+0x104>
    sbrk((10 * 4096 + 2048) - (uint64)sbrk(0));
    293e:	00003097          	auipc	ra,0x3
    2942:	bf6080e7          	jalr	-1034(ra) # 5534 <sbrk>
    2946:	67ad                	lui	a5,0xb
    2948:	8007879b          	addiw	a5,a5,-2048
    294c:	40a7853b          	subw	a0,a5,a0
    2950:	00003097          	auipc	ra,0x3
    2954:	be4080e7          	jalr	-1052(ra) # 5534 <sbrk>
    sbrk(-10);
    2958:	5559                	li	a0,-10
    295a:	00003097          	auipc	ra,0x3
    295e:	bda080e7          	jalr	-1062(ra) # 5534 <sbrk>
    exit(0);
    2962:	4501                	li	a0,0
    2964:	00003097          	auipc	ra,0x3
    2968:	b48080e7          	jalr	-1208(ra) # 54ac <exit>
    printf("fork failed\n");
    296c:	00004517          	auipc	a0,0x4
    2970:	09450513          	addi	a0,a0,148 # 6a00 <l_free+0xfba>
    2974:	00003097          	auipc	ra,0x3
    2978:	eb0080e7          	jalr	-336(ra) # 5824 <printf>
    exit(1);
    297c:	4505                	li	a0,1
    297e:	00003097          	auipc	ra,0x3
    2982:	b2e080e7          	jalr	-1234(ra) # 54ac <exit>
  wait(0);
    2986:	4501                	li	a0,0
    2988:	00003097          	auipc	ra,0x3
    298c:	b2c080e7          	jalr	-1236(ra) # 54b4 <wait>
  exit(0);
    2990:	4501                	li	a0,0
    2992:	00003097          	auipc	ra,0x3
    2996:	b1a080e7          	jalr	-1254(ra) # 54ac <exit>

000000000000299a <execout>:
}

// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void execout(char *s) {
    299a:	715d                	addi	sp,sp,-80
    299c:	e486                	sd	ra,72(sp)
    299e:	e0a2                	sd	s0,64(sp)
    29a0:	fc26                	sd	s1,56(sp)
    29a2:	f84a                	sd	s2,48(sp)
    29a4:	f44e                	sd	s3,40(sp)
    29a6:	f052                	sd	s4,32(sp)
    29a8:	0880                	addi	s0,sp,80
  for (int avail = 0; avail < 15; avail++) {
    29aa:	4901                	li	s2,0
    29ac:	49bd                	li	s3,15
    int pid = fork();
    29ae:	00003097          	auipc	ra,0x3
    29b2:	af6080e7          	jalr	-1290(ra) # 54a4 <fork>
    29b6:	84aa                	mv	s1,a0
    if (pid < 0) {
    29b8:	02054063          	bltz	a0,29d8 <execout+0x3e>
      printf("fork failed\n");
      exit(1);
    } else if (pid == 0) {
    29bc:	c91d                	beqz	a0,29f2 <execout+0x58>
      close(1);
      char *args[] = {"echo", "x", 0};
      exec("echo", args);
      exit(0);
    } else {
      wait((int *)0);
    29be:	4501                	li	a0,0
    29c0:	00003097          	auipc	ra,0x3
    29c4:	af4080e7          	jalr	-1292(ra) # 54b4 <wait>
  for (int avail = 0; avail < 15; avail++) {
    29c8:	2905                	addiw	s2,s2,1
    29ca:	ff3912e3          	bne	s2,s3,29ae <execout+0x14>
    }
  }

  exit(0);
    29ce:	4501                	li	a0,0
    29d0:	00003097          	auipc	ra,0x3
    29d4:	adc080e7          	jalr	-1316(ra) # 54ac <exit>
      printf("fork failed\n");
    29d8:	00004517          	auipc	a0,0x4
    29dc:	02850513          	addi	a0,a0,40 # 6a00 <l_free+0xfba>
    29e0:	00003097          	auipc	ra,0x3
    29e4:	e44080e7          	jalr	-444(ra) # 5824 <printf>
      exit(1);
    29e8:	4505                	li	a0,1
    29ea:	00003097          	auipc	ra,0x3
    29ee:	ac2080e7          	jalr	-1342(ra) # 54ac <exit>
        if (a == 0xffffffffffffffffLL)
    29f2:	59fd                	li	s3,-1
        *(char *)(a + 4096 - 1) = 1;
    29f4:	4a05                	li	s4,1
        uint64 a = (uint64)sbrk(4096);
    29f6:	6505                	lui	a0,0x1
    29f8:	00003097          	auipc	ra,0x3
    29fc:	b3c080e7          	jalr	-1220(ra) # 5534 <sbrk>
        if (a == 0xffffffffffffffffLL)
    2a00:	01350763          	beq	a0,s3,2a0e <execout+0x74>
        *(char *)(a + 4096 - 1) = 1;
    2a04:	6785                	lui	a5,0x1
    2a06:	953e                	add	a0,a0,a5
    2a08:	ff450fa3          	sb	s4,-1(a0) # fff <linktest+0x1d1>
      while (1) {
    2a0c:	b7ed                	j	29f6 <execout+0x5c>
      for (int i = 0; i < avail; i++)
    2a0e:	01205a63          	blez	s2,2a22 <execout+0x88>
        sbrk(-4096);
    2a12:	757d                	lui	a0,0xfffff
    2a14:	00003097          	auipc	ra,0x3
    2a18:	b20080e7          	jalr	-1248(ra) # 5534 <sbrk>
      for (int i = 0; i < avail; i++)
    2a1c:	2485                	addiw	s1,s1,1
    2a1e:	ff249ae3          	bne	s1,s2,2a12 <execout+0x78>
      close(1);
    2a22:	4505                	li	a0,1
    2a24:	00003097          	auipc	ra,0x3
    2a28:	ab0080e7          	jalr	-1360(ra) # 54d4 <close>
      char *args[] = {"echo", "x", 0};
    2a2c:	00003517          	auipc	a0,0x3
    2a30:	37c50513          	addi	a0,a0,892 # 5da8 <l_free+0x362>
    2a34:	faa43c23          	sd	a0,-72(s0)
    2a38:	00003797          	auipc	a5,0x3
    2a3c:	3e078793          	addi	a5,a5,992 # 5e18 <l_free+0x3d2>
    2a40:	fcf43023          	sd	a5,-64(s0)
    2a44:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2a48:	fb840593          	addi	a1,s0,-72
    2a4c:	00003097          	auipc	ra,0x3
    2a50:	a98080e7          	jalr	-1384(ra) # 54e4 <exec>
      exit(0);
    2a54:	4501                	li	a0,0
    2a56:	00003097          	auipc	ra,0x3
    2a5a:	a56080e7          	jalr	-1450(ra) # 54ac <exit>

0000000000002a5e <fourteen>:
void fourteen(char *s) {
    2a5e:	1101                	addi	sp,sp,-32
    2a60:	ec06                	sd	ra,24(sp)
    2a62:	e822                	sd	s0,16(sp)
    2a64:	e426                	sd	s1,8(sp)
    2a66:	1000                	addi	s0,sp,32
    2a68:	84aa                	mv	s1,a0
  if (mkdir("12345678901234") != 0) {
    2a6a:	00004517          	auipc	a0,0x4
    2a6e:	3e650513          	addi	a0,a0,998 # 6e50 <l_free+0x140a>
    2a72:	00003097          	auipc	ra,0x3
    2a76:	aa2080e7          	jalr	-1374(ra) # 5514 <mkdir>
    2a7a:	e165                	bnez	a0,2b5a <fourteen+0xfc>
  if (mkdir("12345678901234/123456789012345") != 0) {
    2a7c:	00004517          	auipc	a0,0x4
    2a80:	22c50513          	addi	a0,a0,556 # 6ca8 <l_free+0x1262>
    2a84:	00003097          	auipc	ra,0x3
    2a88:	a90080e7          	jalr	-1392(ra) # 5514 <mkdir>
    2a8c:	e56d                	bnez	a0,2b76 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2a8e:	20000593          	li	a1,512
    2a92:	00004517          	auipc	a0,0x4
    2a96:	26e50513          	addi	a0,a0,622 # 6d00 <l_free+0x12ba>
    2a9a:	00003097          	auipc	ra,0x3
    2a9e:	a52080e7          	jalr	-1454(ra) # 54ec <open>
  if (fd < 0) {
    2aa2:	0e054863          	bltz	a0,2b92 <fourteen+0x134>
  close(fd);
    2aa6:	00003097          	auipc	ra,0x3
    2aaa:	a2e080e7          	jalr	-1490(ra) # 54d4 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2aae:	4581                	li	a1,0
    2ab0:	00004517          	auipc	a0,0x4
    2ab4:	2c850513          	addi	a0,a0,712 # 6d78 <l_free+0x1332>
    2ab8:	00003097          	auipc	ra,0x3
    2abc:	a34080e7          	jalr	-1484(ra) # 54ec <open>
  if (fd < 0) {
    2ac0:	0e054763          	bltz	a0,2bae <fourteen+0x150>
  close(fd);
    2ac4:	00003097          	auipc	ra,0x3
    2ac8:	a10080e7          	jalr	-1520(ra) # 54d4 <close>
  if (mkdir("12345678901234/12345678901234") == 0) {
    2acc:	00004517          	auipc	a0,0x4
    2ad0:	31c50513          	addi	a0,a0,796 # 6de8 <l_free+0x13a2>
    2ad4:	00003097          	auipc	ra,0x3
    2ad8:	a40080e7          	jalr	-1472(ra) # 5514 <mkdir>
    2adc:	c57d                	beqz	a0,2bca <fourteen+0x16c>
  if (mkdir("123456789012345/12345678901234") == 0) {
    2ade:	00004517          	auipc	a0,0x4
    2ae2:	36250513          	addi	a0,a0,866 # 6e40 <l_free+0x13fa>
    2ae6:	00003097          	auipc	ra,0x3
    2aea:	a2e080e7          	jalr	-1490(ra) # 5514 <mkdir>
    2aee:	cd65                	beqz	a0,2be6 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2af0:	00004517          	auipc	a0,0x4
    2af4:	35050513          	addi	a0,a0,848 # 6e40 <l_free+0x13fa>
    2af8:	00003097          	auipc	ra,0x3
    2afc:	a04080e7          	jalr	-1532(ra) # 54fc <unlink>
  unlink("12345678901234/12345678901234");
    2b00:	00004517          	auipc	a0,0x4
    2b04:	2e850513          	addi	a0,a0,744 # 6de8 <l_free+0x13a2>
    2b08:	00003097          	auipc	ra,0x3
    2b0c:	9f4080e7          	jalr	-1548(ra) # 54fc <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2b10:	00004517          	auipc	a0,0x4
    2b14:	26850513          	addi	a0,a0,616 # 6d78 <l_free+0x1332>
    2b18:	00003097          	auipc	ra,0x3
    2b1c:	9e4080e7          	jalr	-1564(ra) # 54fc <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2b20:	00004517          	auipc	a0,0x4
    2b24:	1e050513          	addi	a0,a0,480 # 6d00 <l_free+0x12ba>
    2b28:	00003097          	auipc	ra,0x3
    2b2c:	9d4080e7          	jalr	-1580(ra) # 54fc <unlink>
  unlink("12345678901234/123456789012345");
    2b30:	00004517          	auipc	a0,0x4
    2b34:	17850513          	addi	a0,a0,376 # 6ca8 <l_free+0x1262>
    2b38:	00003097          	auipc	ra,0x3
    2b3c:	9c4080e7          	jalr	-1596(ra) # 54fc <unlink>
  unlink("12345678901234");
    2b40:	00004517          	auipc	a0,0x4
    2b44:	31050513          	addi	a0,a0,784 # 6e50 <l_free+0x140a>
    2b48:	00003097          	auipc	ra,0x3
    2b4c:	9b4080e7          	jalr	-1612(ra) # 54fc <unlink>
}
    2b50:	60e2                	ld	ra,24(sp)
    2b52:	6442                	ld	s0,16(sp)
    2b54:	64a2                	ld	s1,8(sp)
    2b56:	6105                	addi	sp,sp,32
    2b58:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2b5a:	85a6                	mv	a1,s1
    2b5c:	00004517          	auipc	a0,0x4
    2b60:	12450513          	addi	a0,a0,292 # 6c80 <l_free+0x123a>
    2b64:	00003097          	auipc	ra,0x3
    2b68:	cc0080e7          	jalr	-832(ra) # 5824 <printf>
    exit(1);
    2b6c:	4505                	li	a0,1
    2b6e:	00003097          	auipc	ra,0x3
    2b72:	93e080e7          	jalr	-1730(ra) # 54ac <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2b76:	85a6                	mv	a1,s1
    2b78:	00004517          	auipc	a0,0x4
    2b7c:	15050513          	addi	a0,a0,336 # 6cc8 <l_free+0x1282>
    2b80:	00003097          	auipc	ra,0x3
    2b84:	ca4080e7          	jalr	-860(ra) # 5824 <printf>
    exit(1);
    2b88:	4505                	li	a0,1
    2b8a:	00003097          	auipc	ra,0x3
    2b8e:	922080e7          	jalr	-1758(ra) # 54ac <exit>
    printf(
    2b92:	85a6                	mv	a1,s1
    2b94:	00004517          	auipc	a0,0x4
    2b98:	19c50513          	addi	a0,a0,412 # 6d30 <l_free+0x12ea>
    2b9c:	00003097          	auipc	ra,0x3
    2ba0:	c88080e7          	jalr	-888(ra) # 5824 <printf>
    exit(1);
    2ba4:	4505                	li	a0,1
    2ba6:	00003097          	auipc	ra,0x3
    2baa:	906080e7          	jalr	-1786(ra) # 54ac <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2bae:	85a6                	mv	a1,s1
    2bb0:	00004517          	auipc	a0,0x4
    2bb4:	1f850513          	addi	a0,a0,504 # 6da8 <l_free+0x1362>
    2bb8:	00003097          	auipc	ra,0x3
    2bbc:	c6c080e7          	jalr	-916(ra) # 5824 <printf>
    exit(1);
    2bc0:	4505                	li	a0,1
    2bc2:	00003097          	auipc	ra,0x3
    2bc6:	8ea080e7          	jalr	-1814(ra) # 54ac <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2bca:	85a6                	mv	a1,s1
    2bcc:	00004517          	auipc	a0,0x4
    2bd0:	23c50513          	addi	a0,a0,572 # 6e08 <l_free+0x13c2>
    2bd4:	00003097          	auipc	ra,0x3
    2bd8:	c50080e7          	jalr	-944(ra) # 5824 <printf>
    exit(1);
    2bdc:	4505                	li	a0,1
    2bde:	00003097          	auipc	ra,0x3
    2be2:	8ce080e7          	jalr	-1842(ra) # 54ac <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2be6:	85a6                	mv	a1,s1
    2be8:	00004517          	auipc	a0,0x4
    2bec:	27850513          	addi	a0,a0,632 # 6e60 <l_free+0x141a>
    2bf0:	00003097          	auipc	ra,0x3
    2bf4:	c34080e7          	jalr	-972(ra) # 5824 <printf>
    exit(1);
    2bf8:	4505                	li	a0,1
    2bfa:	00003097          	auipc	ra,0x3
    2bfe:	8b2080e7          	jalr	-1870(ra) # 54ac <exit>

0000000000002c02 <iputtest>:
void iputtest(char *s) {
    2c02:	1101                	addi	sp,sp,-32
    2c04:	ec06                	sd	ra,24(sp)
    2c06:	e822                	sd	s0,16(sp)
    2c08:	e426                	sd	s1,8(sp)
    2c0a:	1000                	addi	s0,sp,32
    2c0c:	84aa                	mv	s1,a0
  if (mkdir("iputdir") < 0) {
    2c0e:	00004517          	auipc	a0,0x4
    2c12:	28a50513          	addi	a0,a0,650 # 6e98 <l_free+0x1452>
    2c16:	00003097          	auipc	ra,0x3
    2c1a:	8fe080e7          	jalr	-1794(ra) # 5514 <mkdir>
    2c1e:	04054563          	bltz	a0,2c68 <iputtest+0x66>
  if (chdir("iputdir") < 0) {
    2c22:	00004517          	auipc	a0,0x4
    2c26:	27650513          	addi	a0,a0,630 # 6e98 <l_free+0x1452>
    2c2a:	00003097          	auipc	ra,0x3
    2c2e:	8f2080e7          	jalr	-1806(ra) # 551c <chdir>
    2c32:	04054963          	bltz	a0,2c84 <iputtest+0x82>
  if (unlink("../iputdir") < 0) {
    2c36:	00004517          	auipc	a0,0x4
    2c3a:	2a250513          	addi	a0,a0,674 # 6ed8 <l_free+0x1492>
    2c3e:	00003097          	auipc	ra,0x3
    2c42:	8be080e7          	jalr	-1858(ra) # 54fc <unlink>
    2c46:	04054d63          	bltz	a0,2ca0 <iputtest+0x9e>
  if (chdir("/") < 0) {
    2c4a:	00004517          	auipc	a0,0x4
    2c4e:	2be50513          	addi	a0,a0,702 # 6f08 <l_free+0x14c2>
    2c52:	00003097          	auipc	ra,0x3
    2c56:	8ca080e7          	jalr	-1846(ra) # 551c <chdir>
    2c5a:	06054163          	bltz	a0,2cbc <iputtest+0xba>
}
    2c5e:	60e2                	ld	ra,24(sp)
    2c60:	6442                	ld	s0,16(sp)
    2c62:	64a2                	ld	s1,8(sp)
    2c64:	6105                	addi	sp,sp,32
    2c66:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2c68:	85a6                	mv	a1,s1
    2c6a:	00004517          	auipc	a0,0x4
    2c6e:	23650513          	addi	a0,a0,566 # 6ea0 <l_free+0x145a>
    2c72:	00003097          	auipc	ra,0x3
    2c76:	bb2080e7          	jalr	-1102(ra) # 5824 <printf>
    exit(1);
    2c7a:	4505                	li	a0,1
    2c7c:	00003097          	auipc	ra,0x3
    2c80:	830080e7          	jalr	-2000(ra) # 54ac <exit>
    printf("%s: chdir iputdir failed\n", s);
    2c84:	85a6                	mv	a1,s1
    2c86:	00004517          	auipc	a0,0x4
    2c8a:	23250513          	addi	a0,a0,562 # 6eb8 <l_free+0x1472>
    2c8e:	00003097          	auipc	ra,0x3
    2c92:	b96080e7          	jalr	-1130(ra) # 5824 <printf>
    exit(1);
    2c96:	4505                	li	a0,1
    2c98:	00003097          	auipc	ra,0x3
    2c9c:	814080e7          	jalr	-2028(ra) # 54ac <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2ca0:	85a6                	mv	a1,s1
    2ca2:	00004517          	auipc	a0,0x4
    2ca6:	24650513          	addi	a0,a0,582 # 6ee8 <l_free+0x14a2>
    2caa:	00003097          	auipc	ra,0x3
    2cae:	b7a080e7          	jalr	-1158(ra) # 5824 <printf>
    exit(1);
    2cb2:	4505                	li	a0,1
    2cb4:	00002097          	auipc	ra,0x2
    2cb8:	7f8080e7          	jalr	2040(ra) # 54ac <exit>
    printf("%s: chdir / failed\n", s);
    2cbc:	85a6                	mv	a1,s1
    2cbe:	00004517          	auipc	a0,0x4
    2cc2:	25250513          	addi	a0,a0,594 # 6f10 <l_free+0x14ca>
    2cc6:	00003097          	auipc	ra,0x3
    2cca:	b5e080e7          	jalr	-1186(ra) # 5824 <printf>
    exit(1);
    2cce:	4505                	li	a0,1
    2cd0:	00002097          	auipc	ra,0x2
    2cd4:	7dc080e7          	jalr	2012(ra) # 54ac <exit>

0000000000002cd8 <exitiputtest>:
void exitiputtest(char *s) {
    2cd8:	7179                	addi	sp,sp,-48
    2cda:	f406                	sd	ra,40(sp)
    2cdc:	f022                	sd	s0,32(sp)
    2cde:	ec26                	sd	s1,24(sp)
    2ce0:	1800                	addi	s0,sp,48
    2ce2:	84aa                	mv	s1,a0
  pid = fork();
    2ce4:	00002097          	auipc	ra,0x2
    2ce8:	7c0080e7          	jalr	1984(ra) # 54a4 <fork>
  if (pid < 0) {
    2cec:	04054663          	bltz	a0,2d38 <exitiputtest+0x60>
  if (pid == 0) {
    2cf0:	ed45                	bnez	a0,2da8 <exitiputtest+0xd0>
    if (mkdir("iputdir") < 0) {
    2cf2:	00004517          	auipc	a0,0x4
    2cf6:	1a650513          	addi	a0,a0,422 # 6e98 <l_free+0x1452>
    2cfa:	00003097          	auipc	ra,0x3
    2cfe:	81a080e7          	jalr	-2022(ra) # 5514 <mkdir>
    2d02:	04054963          	bltz	a0,2d54 <exitiputtest+0x7c>
    if (chdir("iputdir") < 0) {
    2d06:	00004517          	auipc	a0,0x4
    2d0a:	19250513          	addi	a0,a0,402 # 6e98 <l_free+0x1452>
    2d0e:	00003097          	auipc	ra,0x3
    2d12:	80e080e7          	jalr	-2034(ra) # 551c <chdir>
    2d16:	04054d63          	bltz	a0,2d70 <exitiputtest+0x98>
    if (unlink("../iputdir") < 0) {
    2d1a:	00004517          	auipc	a0,0x4
    2d1e:	1be50513          	addi	a0,a0,446 # 6ed8 <l_free+0x1492>
    2d22:	00002097          	auipc	ra,0x2
    2d26:	7da080e7          	jalr	2010(ra) # 54fc <unlink>
    2d2a:	06054163          	bltz	a0,2d8c <exitiputtest+0xb4>
    exit(0);
    2d2e:	4501                	li	a0,0
    2d30:	00002097          	auipc	ra,0x2
    2d34:	77c080e7          	jalr	1916(ra) # 54ac <exit>
    printf("%s: fork failed\n", s);
    2d38:	85a6                	mv	a1,s1
    2d3a:	00004517          	auipc	a0,0x4
    2d3e:	8d650513          	addi	a0,a0,-1834 # 6610 <l_free+0xbca>
    2d42:	00003097          	auipc	ra,0x3
    2d46:	ae2080e7          	jalr	-1310(ra) # 5824 <printf>
    exit(1);
    2d4a:	4505                	li	a0,1
    2d4c:	00002097          	auipc	ra,0x2
    2d50:	760080e7          	jalr	1888(ra) # 54ac <exit>
      printf("%s: mkdir failed\n", s);
    2d54:	85a6                	mv	a1,s1
    2d56:	00004517          	auipc	a0,0x4
    2d5a:	14a50513          	addi	a0,a0,330 # 6ea0 <l_free+0x145a>
    2d5e:	00003097          	auipc	ra,0x3
    2d62:	ac6080e7          	jalr	-1338(ra) # 5824 <printf>
      exit(1);
    2d66:	4505                	li	a0,1
    2d68:	00002097          	auipc	ra,0x2
    2d6c:	744080e7          	jalr	1860(ra) # 54ac <exit>
      printf("%s: child chdir failed\n", s);
    2d70:	85a6                	mv	a1,s1
    2d72:	00004517          	auipc	a0,0x4
    2d76:	1b650513          	addi	a0,a0,438 # 6f28 <l_free+0x14e2>
    2d7a:	00003097          	auipc	ra,0x3
    2d7e:	aaa080e7          	jalr	-1366(ra) # 5824 <printf>
      exit(1);
    2d82:	4505                	li	a0,1
    2d84:	00002097          	auipc	ra,0x2
    2d88:	728080e7          	jalr	1832(ra) # 54ac <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2d8c:	85a6                	mv	a1,s1
    2d8e:	00004517          	auipc	a0,0x4
    2d92:	15a50513          	addi	a0,a0,346 # 6ee8 <l_free+0x14a2>
    2d96:	00003097          	auipc	ra,0x3
    2d9a:	a8e080e7          	jalr	-1394(ra) # 5824 <printf>
      exit(1);
    2d9e:	4505                	li	a0,1
    2da0:	00002097          	auipc	ra,0x2
    2da4:	70c080e7          	jalr	1804(ra) # 54ac <exit>
  wait(&xstatus);
    2da8:	fdc40513          	addi	a0,s0,-36
    2dac:	00002097          	auipc	ra,0x2
    2db0:	708080e7          	jalr	1800(ra) # 54b4 <wait>
  exit(xstatus);
    2db4:	fdc42503          	lw	a0,-36(s0)
    2db8:	00002097          	auipc	ra,0x2
    2dbc:	6f4080e7          	jalr	1780(ra) # 54ac <exit>

0000000000002dc0 <subdir>:
void subdir(char *s) {
    2dc0:	1101                	addi	sp,sp,-32
    2dc2:	ec06                	sd	ra,24(sp)
    2dc4:	e822                	sd	s0,16(sp)
    2dc6:	e426                	sd	s1,8(sp)
    2dc8:	e04a                	sd	s2,0(sp)
    2dca:	1000                	addi	s0,sp,32
    2dcc:	892a                	mv	s2,a0
  unlink("ff");
    2dce:	00004517          	auipc	a0,0x4
    2dd2:	2a250513          	addi	a0,a0,674 # 7070 <l_free+0x162a>
    2dd6:	00002097          	auipc	ra,0x2
    2dda:	726080e7          	jalr	1830(ra) # 54fc <unlink>
  if (mkdir("dd") != 0) {
    2dde:	00004517          	auipc	a0,0x4
    2de2:	16250513          	addi	a0,a0,354 # 6f40 <l_free+0x14fa>
    2de6:	00002097          	auipc	ra,0x2
    2dea:	72e080e7          	jalr	1838(ra) # 5514 <mkdir>
    2dee:	38051663          	bnez	a0,317a <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2df2:	20200593          	li	a1,514
    2df6:	00004517          	auipc	a0,0x4
    2dfa:	16a50513          	addi	a0,a0,362 # 6f60 <l_free+0x151a>
    2dfe:	00002097          	auipc	ra,0x2
    2e02:	6ee080e7          	jalr	1774(ra) # 54ec <open>
    2e06:	84aa                	mv	s1,a0
  if (fd < 0) {
    2e08:	38054763          	bltz	a0,3196 <subdir+0x3d6>
  write(fd, "ff", 2);
    2e0c:	4609                	li	a2,2
    2e0e:	00004597          	auipc	a1,0x4
    2e12:	26258593          	addi	a1,a1,610 # 7070 <l_free+0x162a>
    2e16:	00002097          	auipc	ra,0x2
    2e1a:	6b6080e7          	jalr	1718(ra) # 54cc <write>
  close(fd);
    2e1e:	8526                	mv	a0,s1
    2e20:	00002097          	auipc	ra,0x2
    2e24:	6b4080e7          	jalr	1716(ra) # 54d4 <close>
  if (unlink("dd") >= 0) {
    2e28:	00004517          	auipc	a0,0x4
    2e2c:	11850513          	addi	a0,a0,280 # 6f40 <l_free+0x14fa>
    2e30:	00002097          	auipc	ra,0x2
    2e34:	6cc080e7          	jalr	1740(ra) # 54fc <unlink>
    2e38:	36055d63          	bgez	a0,31b2 <subdir+0x3f2>
  if (mkdir("/dd/dd") != 0) {
    2e3c:	00004517          	auipc	a0,0x4
    2e40:	17c50513          	addi	a0,a0,380 # 6fb8 <l_free+0x1572>
    2e44:	00002097          	auipc	ra,0x2
    2e48:	6d0080e7          	jalr	1744(ra) # 5514 <mkdir>
    2e4c:	38051163          	bnez	a0,31ce <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2e50:	20200593          	li	a1,514
    2e54:	00004517          	auipc	a0,0x4
    2e58:	18c50513          	addi	a0,a0,396 # 6fe0 <l_free+0x159a>
    2e5c:	00002097          	auipc	ra,0x2
    2e60:	690080e7          	jalr	1680(ra) # 54ec <open>
    2e64:	84aa                	mv	s1,a0
  if (fd < 0) {
    2e66:	38054263          	bltz	a0,31ea <subdir+0x42a>
  write(fd, "FF", 2);
    2e6a:	4609                	li	a2,2
    2e6c:	00004597          	auipc	a1,0x4
    2e70:	1a458593          	addi	a1,a1,420 # 7010 <l_free+0x15ca>
    2e74:	00002097          	auipc	ra,0x2
    2e78:	658080e7          	jalr	1624(ra) # 54cc <write>
  close(fd);
    2e7c:	8526                	mv	a0,s1
    2e7e:	00002097          	auipc	ra,0x2
    2e82:	656080e7          	jalr	1622(ra) # 54d4 <close>
  fd = open("dd/dd/../ff", 0);
    2e86:	4581                	li	a1,0
    2e88:	00004517          	auipc	a0,0x4
    2e8c:	19050513          	addi	a0,a0,400 # 7018 <l_free+0x15d2>
    2e90:	00002097          	auipc	ra,0x2
    2e94:	65c080e7          	jalr	1628(ra) # 54ec <open>
    2e98:	84aa                	mv	s1,a0
  if (fd < 0) {
    2e9a:	36054663          	bltz	a0,3206 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    2e9e:	660d                	lui	a2,0x3
    2ea0:	00009597          	auipc	a1,0x9
    2ea4:	b1858593          	addi	a1,a1,-1256 # b9b8 <buf>
    2ea8:	00002097          	auipc	ra,0x2
    2eac:	61c080e7          	jalr	1564(ra) # 54c4 <read>
  if (cc != 2 || buf[0] != 'f') {
    2eb0:	4789                	li	a5,2
    2eb2:	36f51863          	bne	a0,a5,3222 <subdir+0x462>
    2eb6:	00009717          	auipc	a4,0x9
    2eba:	b0274703          	lbu	a4,-1278(a4) # b9b8 <buf>
    2ebe:	06600793          	li	a5,102
    2ec2:	36f71063          	bne	a4,a5,3222 <subdir+0x462>
  close(fd);
    2ec6:	8526                	mv	a0,s1
    2ec8:	00002097          	auipc	ra,0x2
    2ecc:	60c080e7          	jalr	1548(ra) # 54d4 <close>
  if (link("dd/dd/ff", "dd/dd/ffff") != 0) {
    2ed0:	00004597          	auipc	a1,0x4
    2ed4:	19858593          	addi	a1,a1,408 # 7068 <l_free+0x1622>
    2ed8:	00004517          	auipc	a0,0x4
    2edc:	10850513          	addi	a0,a0,264 # 6fe0 <l_free+0x159a>
    2ee0:	00002097          	auipc	ra,0x2
    2ee4:	62c080e7          	jalr	1580(ra) # 550c <link>
    2ee8:	34051b63          	bnez	a0,323e <subdir+0x47e>
  if (unlink("dd/dd/ff") != 0) {
    2eec:	00004517          	auipc	a0,0x4
    2ef0:	0f450513          	addi	a0,a0,244 # 6fe0 <l_free+0x159a>
    2ef4:	00002097          	auipc	ra,0x2
    2ef8:	608080e7          	jalr	1544(ra) # 54fc <unlink>
    2efc:	34051f63          	bnez	a0,325a <subdir+0x49a>
  if (open("dd/dd/ff", O_RDONLY) >= 0) {
    2f00:	4581                	li	a1,0
    2f02:	00004517          	auipc	a0,0x4
    2f06:	0de50513          	addi	a0,a0,222 # 6fe0 <l_free+0x159a>
    2f0a:	00002097          	auipc	ra,0x2
    2f0e:	5e2080e7          	jalr	1506(ra) # 54ec <open>
    2f12:	36055263          	bgez	a0,3276 <subdir+0x4b6>
  if (chdir("dd") != 0) {
    2f16:	00004517          	auipc	a0,0x4
    2f1a:	02a50513          	addi	a0,a0,42 # 6f40 <l_free+0x14fa>
    2f1e:	00002097          	auipc	ra,0x2
    2f22:	5fe080e7          	jalr	1534(ra) # 551c <chdir>
    2f26:	36051663          	bnez	a0,3292 <subdir+0x4d2>
  if (chdir("dd/../../dd") != 0) {
    2f2a:	00004517          	auipc	a0,0x4
    2f2e:	1d650513          	addi	a0,a0,470 # 7100 <l_free+0x16ba>
    2f32:	00002097          	auipc	ra,0x2
    2f36:	5ea080e7          	jalr	1514(ra) # 551c <chdir>
    2f3a:	36051a63          	bnez	a0,32ae <subdir+0x4ee>
  if (chdir("dd/../../../dd") != 0) {
    2f3e:	00004517          	auipc	a0,0x4
    2f42:	1f250513          	addi	a0,a0,498 # 7130 <l_free+0x16ea>
    2f46:	00002097          	auipc	ra,0x2
    2f4a:	5d6080e7          	jalr	1494(ra) # 551c <chdir>
    2f4e:	36051e63          	bnez	a0,32ca <subdir+0x50a>
  if (chdir("./..") != 0) {
    2f52:	00004517          	auipc	a0,0x4
    2f56:	20e50513          	addi	a0,a0,526 # 7160 <l_free+0x171a>
    2f5a:	00002097          	auipc	ra,0x2
    2f5e:	5c2080e7          	jalr	1474(ra) # 551c <chdir>
    2f62:	38051263          	bnez	a0,32e6 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    2f66:	4581                	li	a1,0
    2f68:	00004517          	auipc	a0,0x4
    2f6c:	10050513          	addi	a0,a0,256 # 7068 <l_free+0x1622>
    2f70:	00002097          	auipc	ra,0x2
    2f74:	57c080e7          	jalr	1404(ra) # 54ec <open>
    2f78:	84aa                	mv	s1,a0
  if (fd < 0) {
    2f7a:	38054463          	bltz	a0,3302 <subdir+0x542>
  if (read(fd, buf, sizeof(buf)) != 2) {
    2f7e:	660d                	lui	a2,0x3
    2f80:	00009597          	auipc	a1,0x9
    2f84:	a3858593          	addi	a1,a1,-1480 # b9b8 <buf>
    2f88:	00002097          	auipc	ra,0x2
    2f8c:	53c080e7          	jalr	1340(ra) # 54c4 <read>
    2f90:	4789                	li	a5,2
    2f92:	38f51663          	bne	a0,a5,331e <subdir+0x55e>
  close(fd);
    2f96:	8526                	mv	a0,s1
    2f98:	00002097          	auipc	ra,0x2
    2f9c:	53c080e7          	jalr	1340(ra) # 54d4 <close>
  if (open("dd/dd/ff", O_RDONLY) >= 0) {
    2fa0:	4581                	li	a1,0
    2fa2:	00004517          	auipc	a0,0x4
    2fa6:	03e50513          	addi	a0,a0,62 # 6fe0 <l_free+0x159a>
    2faa:	00002097          	auipc	ra,0x2
    2fae:	542080e7          	jalr	1346(ra) # 54ec <open>
    2fb2:	38055463          	bgez	a0,333a <subdir+0x57a>
  if (open("dd/ff/ff", O_CREATE | O_RDWR) >= 0) {
    2fb6:	20200593          	li	a1,514
    2fba:	00004517          	auipc	a0,0x4
    2fbe:	23650513          	addi	a0,a0,566 # 71f0 <l_free+0x17aa>
    2fc2:	00002097          	auipc	ra,0x2
    2fc6:	52a080e7          	jalr	1322(ra) # 54ec <open>
    2fca:	38055663          	bgez	a0,3356 <subdir+0x596>
  if (open("dd/xx/ff", O_CREATE | O_RDWR) >= 0) {
    2fce:	20200593          	li	a1,514
    2fd2:	00004517          	auipc	a0,0x4
    2fd6:	24e50513          	addi	a0,a0,590 # 7220 <l_free+0x17da>
    2fda:	00002097          	auipc	ra,0x2
    2fde:	512080e7          	jalr	1298(ra) # 54ec <open>
    2fe2:	38055863          	bgez	a0,3372 <subdir+0x5b2>
  if (open("dd", O_CREATE) >= 0) {
    2fe6:	20000593          	li	a1,512
    2fea:	00004517          	auipc	a0,0x4
    2fee:	f5650513          	addi	a0,a0,-170 # 6f40 <l_free+0x14fa>
    2ff2:	00002097          	auipc	ra,0x2
    2ff6:	4fa080e7          	jalr	1274(ra) # 54ec <open>
    2ffa:	38055a63          	bgez	a0,338e <subdir+0x5ce>
  if (open("dd", O_RDWR) >= 0) {
    2ffe:	4589                	li	a1,2
    3000:	00004517          	auipc	a0,0x4
    3004:	f4050513          	addi	a0,a0,-192 # 6f40 <l_free+0x14fa>
    3008:	00002097          	auipc	ra,0x2
    300c:	4e4080e7          	jalr	1252(ra) # 54ec <open>
    3010:	38055d63          	bgez	a0,33aa <subdir+0x5ea>
  if (open("dd", O_WRONLY) >= 0) {
    3014:	4585                	li	a1,1
    3016:	00004517          	auipc	a0,0x4
    301a:	f2a50513          	addi	a0,a0,-214 # 6f40 <l_free+0x14fa>
    301e:	00002097          	auipc	ra,0x2
    3022:	4ce080e7          	jalr	1230(ra) # 54ec <open>
    3026:	3a055063          	bgez	a0,33c6 <subdir+0x606>
  if (link("dd/ff/ff", "dd/dd/xx") == 0) {
    302a:	00004597          	auipc	a1,0x4
    302e:	28658593          	addi	a1,a1,646 # 72b0 <l_free+0x186a>
    3032:	00004517          	auipc	a0,0x4
    3036:	1be50513          	addi	a0,a0,446 # 71f0 <l_free+0x17aa>
    303a:	00002097          	auipc	ra,0x2
    303e:	4d2080e7          	jalr	1234(ra) # 550c <link>
    3042:	3a050063          	beqz	a0,33e2 <subdir+0x622>
  if (link("dd/xx/ff", "dd/dd/xx") == 0) {
    3046:	00004597          	auipc	a1,0x4
    304a:	26a58593          	addi	a1,a1,618 # 72b0 <l_free+0x186a>
    304e:	00004517          	auipc	a0,0x4
    3052:	1d250513          	addi	a0,a0,466 # 7220 <l_free+0x17da>
    3056:	00002097          	auipc	ra,0x2
    305a:	4b6080e7          	jalr	1206(ra) # 550c <link>
    305e:	3a050063          	beqz	a0,33fe <subdir+0x63e>
  if (link("dd/ff", "dd/dd/ffff") == 0) {
    3062:	00004597          	auipc	a1,0x4
    3066:	00658593          	addi	a1,a1,6 # 7068 <l_free+0x1622>
    306a:	00004517          	auipc	a0,0x4
    306e:	ef650513          	addi	a0,a0,-266 # 6f60 <l_free+0x151a>
    3072:	00002097          	auipc	ra,0x2
    3076:	49a080e7          	jalr	1178(ra) # 550c <link>
    307a:	3a050063          	beqz	a0,341a <subdir+0x65a>
  if (mkdir("dd/ff/ff") == 0) {
    307e:	00004517          	auipc	a0,0x4
    3082:	17250513          	addi	a0,a0,370 # 71f0 <l_free+0x17aa>
    3086:	00002097          	auipc	ra,0x2
    308a:	48e080e7          	jalr	1166(ra) # 5514 <mkdir>
    308e:	3a050463          	beqz	a0,3436 <subdir+0x676>
  if (mkdir("dd/xx/ff") == 0) {
    3092:	00004517          	auipc	a0,0x4
    3096:	18e50513          	addi	a0,a0,398 # 7220 <l_free+0x17da>
    309a:	00002097          	auipc	ra,0x2
    309e:	47a080e7          	jalr	1146(ra) # 5514 <mkdir>
    30a2:	3a050863          	beqz	a0,3452 <subdir+0x692>
  if (mkdir("dd/dd/ffff") == 0) {
    30a6:	00004517          	auipc	a0,0x4
    30aa:	fc250513          	addi	a0,a0,-62 # 7068 <l_free+0x1622>
    30ae:	00002097          	auipc	ra,0x2
    30b2:	466080e7          	jalr	1126(ra) # 5514 <mkdir>
    30b6:	3a050c63          	beqz	a0,346e <subdir+0x6ae>
  if (unlink("dd/xx/ff") == 0) {
    30ba:	00004517          	auipc	a0,0x4
    30be:	16650513          	addi	a0,a0,358 # 7220 <l_free+0x17da>
    30c2:	00002097          	auipc	ra,0x2
    30c6:	43a080e7          	jalr	1082(ra) # 54fc <unlink>
    30ca:	3c050063          	beqz	a0,348a <subdir+0x6ca>
  if (unlink("dd/ff/ff") == 0) {
    30ce:	00004517          	auipc	a0,0x4
    30d2:	12250513          	addi	a0,a0,290 # 71f0 <l_free+0x17aa>
    30d6:	00002097          	auipc	ra,0x2
    30da:	426080e7          	jalr	1062(ra) # 54fc <unlink>
    30de:	3c050463          	beqz	a0,34a6 <subdir+0x6e6>
  if (chdir("dd/ff") == 0) {
    30e2:	00004517          	auipc	a0,0x4
    30e6:	e7e50513          	addi	a0,a0,-386 # 6f60 <l_free+0x151a>
    30ea:	00002097          	auipc	ra,0x2
    30ee:	432080e7          	jalr	1074(ra) # 551c <chdir>
    30f2:	3c050863          	beqz	a0,34c2 <subdir+0x702>
  if (chdir("dd/xx") == 0) {
    30f6:	00004517          	auipc	a0,0x4
    30fa:	30a50513          	addi	a0,a0,778 # 7400 <l_free+0x19ba>
    30fe:	00002097          	auipc	ra,0x2
    3102:	41e080e7          	jalr	1054(ra) # 551c <chdir>
    3106:	3c050c63          	beqz	a0,34de <subdir+0x71e>
  if (unlink("dd/dd/ffff") != 0) {
    310a:	00004517          	auipc	a0,0x4
    310e:	f5e50513          	addi	a0,a0,-162 # 7068 <l_free+0x1622>
    3112:	00002097          	auipc	ra,0x2
    3116:	3ea080e7          	jalr	1002(ra) # 54fc <unlink>
    311a:	3e051063          	bnez	a0,34fa <subdir+0x73a>
  if (unlink("dd/ff") != 0) {
    311e:	00004517          	auipc	a0,0x4
    3122:	e4250513          	addi	a0,a0,-446 # 6f60 <l_free+0x151a>
    3126:	00002097          	auipc	ra,0x2
    312a:	3d6080e7          	jalr	982(ra) # 54fc <unlink>
    312e:	3e051463          	bnez	a0,3516 <subdir+0x756>
  if (unlink("dd") == 0) {
    3132:	00004517          	auipc	a0,0x4
    3136:	e0e50513          	addi	a0,a0,-498 # 6f40 <l_free+0x14fa>
    313a:	00002097          	auipc	ra,0x2
    313e:	3c2080e7          	jalr	962(ra) # 54fc <unlink>
    3142:	3e050863          	beqz	a0,3532 <subdir+0x772>
  if (unlink("dd/dd") < 0) {
    3146:	00004517          	auipc	a0,0x4
    314a:	32a50513          	addi	a0,a0,810 # 7470 <l_free+0x1a2a>
    314e:	00002097          	auipc	ra,0x2
    3152:	3ae080e7          	jalr	942(ra) # 54fc <unlink>
    3156:	3e054c63          	bltz	a0,354e <subdir+0x78e>
  if (unlink("dd") < 0) {
    315a:	00004517          	auipc	a0,0x4
    315e:	de650513          	addi	a0,a0,-538 # 6f40 <l_free+0x14fa>
    3162:	00002097          	auipc	ra,0x2
    3166:	39a080e7          	jalr	922(ra) # 54fc <unlink>
    316a:	40054063          	bltz	a0,356a <subdir+0x7aa>
}
    316e:	60e2                	ld	ra,24(sp)
    3170:	6442                	ld	s0,16(sp)
    3172:	64a2                	ld	s1,8(sp)
    3174:	6902                	ld	s2,0(sp)
    3176:	6105                	addi	sp,sp,32
    3178:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    317a:	85ca                	mv	a1,s2
    317c:	00004517          	auipc	a0,0x4
    3180:	dcc50513          	addi	a0,a0,-564 # 6f48 <l_free+0x1502>
    3184:	00002097          	auipc	ra,0x2
    3188:	6a0080e7          	jalr	1696(ra) # 5824 <printf>
    exit(1);
    318c:	4505                	li	a0,1
    318e:	00002097          	auipc	ra,0x2
    3192:	31e080e7          	jalr	798(ra) # 54ac <exit>
    printf("%s: create dd/ff failed\n", s);
    3196:	85ca                	mv	a1,s2
    3198:	00004517          	auipc	a0,0x4
    319c:	dd050513          	addi	a0,a0,-560 # 6f68 <l_free+0x1522>
    31a0:	00002097          	auipc	ra,0x2
    31a4:	684080e7          	jalr	1668(ra) # 5824 <printf>
    exit(1);
    31a8:	4505                	li	a0,1
    31aa:	00002097          	auipc	ra,0x2
    31ae:	302080e7          	jalr	770(ra) # 54ac <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    31b2:	85ca                	mv	a1,s2
    31b4:	00004517          	auipc	a0,0x4
    31b8:	dd450513          	addi	a0,a0,-556 # 6f88 <l_free+0x1542>
    31bc:	00002097          	auipc	ra,0x2
    31c0:	668080e7          	jalr	1640(ra) # 5824 <printf>
    exit(1);
    31c4:	4505                	li	a0,1
    31c6:	00002097          	auipc	ra,0x2
    31ca:	2e6080e7          	jalr	742(ra) # 54ac <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    31ce:	85ca                	mv	a1,s2
    31d0:	00004517          	auipc	a0,0x4
    31d4:	df050513          	addi	a0,a0,-528 # 6fc0 <l_free+0x157a>
    31d8:	00002097          	auipc	ra,0x2
    31dc:	64c080e7          	jalr	1612(ra) # 5824 <printf>
    exit(1);
    31e0:	4505                	li	a0,1
    31e2:	00002097          	auipc	ra,0x2
    31e6:	2ca080e7          	jalr	714(ra) # 54ac <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    31ea:	85ca                	mv	a1,s2
    31ec:	00004517          	auipc	a0,0x4
    31f0:	e0450513          	addi	a0,a0,-508 # 6ff0 <l_free+0x15aa>
    31f4:	00002097          	auipc	ra,0x2
    31f8:	630080e7          	jalr	1584(ra) # 5824 <printf>
    exit(1);
    31fc:	4505                	li	a0,1
    31fe:	00002097          	auipc	ra,0x2
    3202:	2ae080e7          	jalr	686(ra) # 54ac <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3206:	85ca                	mv	a1,s2
    3208:	00004517          	auipc	a0,0x4
    320c:	e2050513          	addi	a0,a0,-480 # 7028 <l_free+0x15e2>
    3210:	00002097          	auipc	ra,0x2
    3214:	614080e7          	jalr	1556(ra) # 5824 <printf>
    exit(1);
    3218:	4505                	li	a0,1
    321a:	00002097          	auipc	ra,0x2
    321e:	292080e7          	jalr	658(ra) # 54ac <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3222:	85ca                	mv	a1,s2
    3224:	00004517          	auipc	a0,0x4
    3228:	e2450513          	addi	a0,a0,-476 # 7048 <l_free+0x1602>
    322c:	00002097          	auipc	ra,0x2
    3230:	5f8080e7          	jalr	1528(ra) # 5824 <printf>
    exit(1);
    3234:	4505                	li	a0,1
    3236:	00002097          	auipc	ra,0x2
    323a:	276080e7          	jalr	630(ra) # 54ac <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    323e:	85ca                	mv	a1,s2
    3240:	00004517          	auipc	a0,0x4
    3244:	e3850513          	addi	a0,a0,-456 # 7078 <l_free+0x1632>
    3248:	00002097          	auipc	ra,0x2
    324c:	5dc080e7          	jalr	1500(ra) # 5824 <printf>
    exit(1);
    3250:	4505                	li	a0,1
    3252:	00002097          	auipc	ra,0x2
    3256:	25a080e7          	jalr	602(ra) # 54ac <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    325a:	85ca                	mv	a1,s2
    325c:	00004517          	auipc	a0,0x4
    3260:	e4450513          	addi	a0,a0,-444 # 70a0 <l_free+0x165a>
    3264:	00002097          	auipc	ra,0x2
    3268:	5c0080e7          	jalr	1472(ra) # 5824 <printf>
    exit(1);
    326c:	4505                	li	a0,1
    326e:	00002097          	auipc	ra,0x2
    3272:	23e080e7          	jalr	574(ra) # 54ac <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3276:	85ca                	mv	a1,s2
    3278:	00004517          	auipc	a0,0x4
    327c:	e4850513          	addi	a0,a0,-440 # 70c0 <l_free+0x167a>
    3280:	00002097          	auipc	ra,0x2
    3284:	5a4080e7          	jalr	1444(ra) # 5824 <printf>
    exit(1);
    3288:	4505                	li	a0,1
    328a:	00002097          	auipc	ra,0x2
    328e:	222080e7          	jalr	546(ra) # 54ac <exit>
    printf("%s: chdir dd failed\n", s);
    3292:	85ca                	mv	a1,s2
    3294:	00004517          	auipc	a0,0x4
    3298:	e5450513          	addi	a0,a0,-428 # 70e8 <l_free+0x16a2>
    329c:	00002097          	auipc	ra,0x2
    32a0:	588080e7          	jalr	1416(ra) # 5824 <printf>
    exit(1);
    32a4:	4505                	li	a0,1
    32a6:	00002097          	auipc	ra,0x2
    32aa:	206080e7          	jalr	518(ra) # 54ac <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    32ae:	85ca                	mv	a1,s2
    32b0:	00004517          	auipc	a0,0x4
    32b4:	e6050513          	addi	a0,a0,-416 # 7110 <l_free+0x16ca>
    32b8:	00002097          	auipc	ra,0x2
    32bc:	56c080e7          	jalr	1388(ra) # 5824 <printf>
    exit(1);
    32c0:	4505                	li	a0,1
    32c2:	00002097          	auipc	ra,0x2
    32c6:	1ea080e7          	jalr	490(ra) # 54ac <exit>
    printf("chdir dd/../../dd failed\n", s);
    32ca:	85ca                	mv	a1,s2
    32cc:	00004517          	auipc	a0,0x4
    32d0:	e7450513          	addi	a0,a0,-396 # 7140 <l_free+0x16fa>
    32d4:	00002097          	auipc	ra,0x2
    32d8:	550080e7          	jalr	1360(ra) # 5824 <printf>
    exit(1);
    32dc:	4505                	li	a0,1
    32de:	00002097          	auipc	ra,0x2
    32e2:	1ce080e7          	jalr	462(ra) # 54ac <exit>
    printf("%s: chdir ./.. failed\n", s);
    32e6:	85ca                	mv	a1,s2
    32e8:	00004517          	auipc	a0,0x4
    32ec:	e8050513          	addi	a0,a0,-384 # 7168 <l_free+0x1722>
    32f0:	00002097          	auipc	ra,0x2
    32f4:	534080e7          	jalr	1332(ra) # 5824 <printf>
    exit(1);
    32f8:	4505                	li	a0,1
    32fa:	00002097          	auipc	ra,0x2
    32fe:	1b2080e7          	jalr	434(ra) # 54ac <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3302:	85ca                	mv	a1,s2
    3304:	00004517          	auipc	a0,0x4
    3308:	e7c50513          	addi	a0,a0,-388 # 7180 <l_free+0x173a>
    330c:	00002097          	auipc	ra,0x2
    3310:	518080e7          	jalr	1304(ra) # 5824 <printf>
    exit(1);
    3314:	4505                	li	a0,1
    3316:	00002097          	auipc	ra,0x2
    331a:	196080e7          	jalr	406(ra) # 54ac <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    331e:	85ca                	mv	a1,s2
    3320:	00004517          	auipc	a0,0x4
    3324:	e8050513          	addi	a0,a0,-384 # 71a0 <l_free+0x175a>
    3328:	00002097          	auipc	ra,0x2
    332c:	4fc080e7          	jalr	1276(ra) # 5824 <printf>
    exit(1);
    3330:	4505                	li	a0,1
    3332:	00002097          	auipc	ra,0x2
    3336:	17a080e7          	jalr	378(ra) # 54ac <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    333a:	85ca                	mv	a1,s2
    333c:	00004517          	auipc	a0,0x4
    3340:	e8450513          	addi	a0,a0,-380 # 71c0 <l_free+0x177a>
    3344:	00002097          	auipc	ra,0x2
    3348:	4e0080e7          	jalr	1248(ra) # 5824 <printf>
    exit(1);
    334c:	4505                	li	a0,1
    334e:	00002097          	auipc	ra,0x2
    3352:	15e080e7          	jalr	350(ra) # 54ac <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3356:	85ca                	mv	a1,s2
    3358:	00004517          	auipc	a0,0x4
    335c:	ea850513          	addi	a0,a0,-344 # 7200 <l_free+0x17ba>
    3360:	00002097          	auipc	ra,0x2
    3364:	4c4080e7          	jalr	1220(ra) # 5824 <printf>
    exit(1);
    3368:	4505                	li	a0,1
    336a:	00002097          	auipc	ra,0x2
    336e:	142080e7          	jalr	322(ra) # 54ac <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3372:	85ca                	mv	a1,s2
    3374:	00004517          	auipc	a0,0x4
    3378:	ebc50513          	addi	a0,a0,-324 # 7230 <l_free+0x17ea>
    337c:	00002097          	auipc	ra,0x2
    3380:	4a8080e7          	jalr	1192(ra) # 5824 <printf>
    exit(1);
    3384:	4505                	li	a0,1
    3386:	00002097          	auipc	ra,0x2
    338a:	126080e7          	jalr	294(ra) # 54ac <exit>
    printf("%s: create dd succeeded!\n", s);
    338e:	85ca                	mv	a1,s2
    3390:	00004517          	auipc	a0,0x4
    3394:	ec050513          	addi	a0,a0,-320 # 7250 <l_free+0x180a>
    3398:	00002097          	auipc	ra,0x2
    339c:	48c080e7          	jalr	1164(ra) # 5824 <printf>
    exit(1);
    33a0:	4505                	li	a0,1
    33a2:	00002097          	auipc	ra,0x2
    33a6:	10a080e7          	jalr	266(ra) # 54ac <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    33aa:	85ca                	mv	a1,s2
    33ac:	00004517          	auipc	a0,0x4
    33b0:	ec450513          	addi	a0,a0,-316 # 7270 <l_free+0x182a>
    33b4:	00002097          	auipc	ra,0x2
    33b8:	470080e7          	jalr	1136(ra) # 5824 <printf>
    exit(1);
    33bc:	4505                	li	a0,1
    33be:	00002097          	auipc	ra,0x2
    33c2:	0ee080e7          	jalr	238(ra) # 54ac <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    33c6:	85ca                	mv	a1,s2
    33c8:	00004517          	auipc	a0,0x4
    33cc:	ec850513          	addi	a0,a0,-312 # 7290 <l_free+0x184a>
    33d0:	00002097          	auipc	ra,0x2
    33d4:	454080e7          	jalr	1108(ra) # 5824 <printf>
    exit(1);
    33d8:	4505                	li	a0,1
    33da:	00002097          	auipc	ra,0x2
    33de:	0d2080e7          	jalr	210(ra) # 54ac <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    33e2:	85ca                	mv	a1,s2
    33e4:	00004517          	auipc	a0,0x4
    33e8:	edc50513          	addi	a0,a0,-292 # 72c0 <l_free+0x187a>
    33ec:	00002097          	auipc	ra,0x2
    33f0:	438080e7          	jalr	1080(ra) # 5824 <printf>
    exit(1);
    33f4:	4505                	li	a0,1
    33f6:	00002097          	auipc	ra,0x2
    33fa:	0b6080e7          	jalr	182(ra) # 54ac <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    33fe:	85ca                	mv	a1,s2
    3400:	00004517          	auipc	a0,0x4
    3404:	ee850513          	addi	a0,a0,-280 # 72e8 <l_free+0x18a2>
    3408:	00002097          	auipc	ra,0x2
    340c:	41c080e7          	jalr	1052(ra) # 5824 <printf>
    exit(1);
    3410:	4505                	li	a0,1
    3412:	00002097          	auipc	ra,0x2
    3416:	09a080e7          	jalr	154(ra) # 54ac <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    341a:	85ca                	mv	a1,s2
    341c:	00004517          	auipc	a0,0x4
    3420:	ef450513          	addi	a0,a0,-268 # 7310 <l_free+0x18ca>
    3424:	00002097          	auipc	ra,0x2
    3428:	400080e7          	jalr	1024(ra) # 5824 <printf>
    exit(1);
    342c:	4505                	li	a0,1
    342e:	00002097          	auipc	ra,0x2
    3432:	07e080e7          	jalr	126(ra) # 54ac <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3436:	85ca                	mv	a1,s2
    3438:	00004517          	auipc	a0,0x4
    343c:	f0050513          	addi	a0,a0,-256 # 7338 <l_free+0x18f2>
    3440:	00002097          	auipc	ra,0x2
    3444:	3e4080e7          	jalr	996(ra) # 5824 <printf>
    exit(1);
    3448:	4505                	li	a0,1
    344a:	00002097          	auipc	ra,0x2
    344e:	062080e7          	jalr	98(ra) # 54ac <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3452:	85ca                	mv	a1,s2
    3454:	00004517          	auipc	a0,0x4
    3458:	f0450513          	addi	a0,a0,-252 # 7358 <l_free+0x1912>
    345c:	00002097          	auipc	ra,0x2
    3460:	3c8080e7          	jalr	968(ra) # 5824 <printf>
    exit(1);
    3464:	4505                	li	a0,1
    3466:	00002097          	auipc	ra,0x2
    346a:	046080e7          	jalr	70(ra) # 54ac <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    346e:	85ca                	mv	a1,s2
    3470:	00004517          	auipc	a0,0x4
    3474:	f0850513          	addi	a0,a0,-248 # 7378 <l_free+0x1932>
    3478:	00002097          	auipc	ra,0x2
    347c:	3ac080e7          	jalr	940(ra) # 5824 <printf>
    exit(1);
    3480:	4505                	li	a0,1
    3482:	00002097          	auipc	ra,0x2
    3486:	02a080e7          	jalr	42(ra) # 54ac <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    348a:	85ca                	mv	a1,s2
    348c:	00004517          	auipc	a0,0x4
    3490:	f1450513          	addi	a0,a0,-236 # 73a0 <l_free+0x195a>
    3494:	00002097          	auipc	ra,0x2
    3498:	390080e7          	jalr	912(ra) # 5824 <printf>
    exit(1);
    349c:	4505                	li	a0,1
    349e:	00002097          	auipc	ra,0x2
    34a2:	00e080e7          	jalr	14(ra) # 54ac <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    34a6:	85ca                	mv	a1,s2
    34a8:	00004517          	auipc	a0,0x4
    34ac:	f1850513          	addi	a0,a0,-232 # 73c0 <l_free+0x197a>
    34b0:	00002097          	auipc	ra,0x2
    34b4:	374080e7          	jalr	884(ra) # 5824 <printf>
    exit(1);
    34b8:	4505                	li	a0,1
    34ba:	00002097          	auipc	ra,0x2
    34be:	ff2080e7          	jalr	-14(ra) # 54ac <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    34c2:	85ca                	mv	a1,s2
    34c4:	00004517          	auipc	a0,0x4
    34c8:	f1c50513          	addi	a0,a0,-228 # 73e0 <l_free+0x199a>
    34cc:	00002097          	auipc	ra,0x2
    34d0:	358080e7          	jalr	856(ra) # 5824 <printf>
    exit(1);
    34d4:	4505                	li	a0,1
    34d6:	00002097          	auipc	ra,0x2
    34da:	fd6080e7          	jalr	-42(ra) # 54ac <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    34de:	85ca                	mv	a1,s2
    34e0:	00004517          	auipc	a0,0x4
    34e4:	f2850513          	addi	a0,a0,-216 # 7408 <l_free+0x19c2>
    34e8:	00002097          	auipc	ra,0x2
    34ec:	33c080e7          	jalr	828(ra) # 5824 <printf>
    exit(1);
    34f0:	4505                	li	a0,1
    34f2:	00002097          	auipc	ra,0x2
    34f6:	fba080e7          	jalr	-70(ra) # 54ac <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    34fa:	85ca                	mv	a1,s2
    34fc:	00004517          	auipc	a0,0x4
    3500:	ba450513          	addi	a0,a0,-1116 # 70a0 <l_free+0x165a>
    3504:	00002097          	auipc	ra,0x2
    3508:	320080e7          	jalr	800(ra) # 5824 <printf>
    exit(1);
    350c:	4505                	li	a0,1
    350e:	00002097          	auipc	ra,0x2
    3512:	f9e080e7          	jalr	-98(ra) # 54ac <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3516:	85ca                	mv	a1,s2
    3518:	00004517          	auipc	a0,0x4
    351c:	f1050513          	addi	a0,a0,-240 # 7428 <l_free+0x19e2>
    3520:	00002097          	auipc	ra,0x2
    3524:	304080e7          	jalr	772(ra) # 5824 <printf>
    exit(1);
    3528:	4505                	li	a0,1
    352a:	00002097          	auipc	ra,0x2
    352e:	f82080e7          	jalr	-126(ra) # 54ac <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3532:	85ca                	mv	a1,s2
    3534:	00004517          	auipc	a0,0x4
    3538:	f1450513          	addi	a0,a0,-236 # 7448 <l_free+0x1a02>
    353c:	00002097          	auipc	ra,0x2
    3540:	2e8080e7          	jalr	744(ra) # 5824 <printf>
    exit(1);
    3544:	4505                	li	a0,1
    3546:	00002097          	auipc	ra,0x2
    354a:	f66080e7          	jalr	-154(ra) # 54ac <exit>
    printf("%s: unlink dd/dd failed\n", s);
    354e:	85ca                	mv	a1,s2
    3550:	00004517          	auipc	a0,0x4
    3554:	f2850513          	addi	a0,a0,-216 # 7478 <l_free+0x1a32>
    3558:	00002097          	auipc	ra,0x2
    355c:	2cc080e7          	jalr	716(ra) # 5824 <printf>
    exit(1);
    3560:	4505                	li	a0,1
    3562:	00002097          	auipc	ra,0x2
    3566:	f4a080e7          	jalr	-182(ra) # 54ac <exit>
    printf("%s: unlink dd failed\n", s);
    356a:	85ca                	mv	a1,s2
    356c:	00004517          	auipc	a0,0x4
    3570:	f2c50513          	addi	a0,a0,-212 # 7498 <l_free+0x1a52>
    3574:	00002097          	auipc	ra,0x2
    3578:	2b0080e7          	jalr	688(ra) # 5824 <printf>
    exit(1);
    357c:	4505                	li	a0,1
    357e:	00002097          	auipc	ra,0x2
    3582:	f2e080e7          	jalr	-210(ra) # 54ac <exit>

0000000000003586 <rmdot>:
void rmdot(char *s) {
    3586:	1101                	addi	sp,sp,-32
    3588:	ec06                	sd	ra,24(sp)
    358a:	e822                	sd	s0,16(sp)
    358c:	e426                	sd	s1,8(sp)
    358e:	1000                	addi	s0,sp,32
    3590:	84aa                	mv	s1,a0
  if (mkdir("dots") != 0) {
    3592:	00004517          	auipc	a0,0x4
    3596:	f1e50513          	addi	a0,a0,-226 # 74b0 <l_free+0x1a6a>
    359a:	00002097          	auipc	ra,0x2
    359e:	f7a080e7          	jalr	-134(ra) # 5514 <mkdir>
    35a2:	e549                	bnez	a0,362c <rmdot+0xa6>
  if (chdir("dots") != 0) {
    35a4:	00004517          	auipc	a0,0x4
    35a8:	f0c50513          	addi	a0,a0,-244 # 74b0 <l_free+0x1a6a>
    35ac:	00002097          	auipc	ra,0x2
    35b0:	f70080e7          	jalr	-144(ra) # 551c <chdir>
    35b4:	e951                	bnez	a0,3648 <rmdot+0xc2>
  if (unlink(".") == 0) {
    35b6:	00003517          	auipc	a0,0x3
    35ba:	eba50513          	addi	a0,a0,-326 # 6470 <l_free+0xa2a>
    35be:	00002097          	auipc	ra,0x2
    35c2:	f3e080e7          	jalr	-194(ra) # 54fc <unlink>
    35c6:	cd59                	beqz	a0,3664 <rmdot+0xde>
  if (unlink("..") == 0) {
    35c8:	00004517          	auipc	a0,0x4
    35cc:	f3850513          	addi	a0,a0,-200 # 7500 <l_free+0x1aba>
    35d0:	00002097          	auipc	ra,0x2
    35d4:	f2c080e7          	jalr	-212(ra) # 54fc <unlink>
    35d8:	c545                	beqz	a0,3680 <rmdot+0xfa>
  if (chdir("/") != 0) {
    35da:	00004517          	auipc	a0,0x4
    35de:	92e50513          	addi	a0,a0,-1746 # 6f08 <l_free+0x14c2>
    35e2:	00002097          	auipc	ra,0x2
    35e6:	f3a080e7          	jalr	-198(ra) # 551c <chdir>
    35ea:	e94d                	bnez	a0,369c <rmdot+0x116>
  if (unlink("dots/.") == 0) {
    35ec:	00004517          	auipc	a0,0x4
    35f0:	f3450513          	addi	a0,a0,-204 # 7520 <l_free+0x1ada>
    35f4:	00002097          	auipc	ra,0x2
    35f8:	f08080e7          	jalr	-248(ra) # 54fc <unlink>
    35fc:	cd55                	beqz	a0,36b8 <rmdot+0x132>
  if (unlink("dots/..") == 0) {
    35fe:	00004517          	auipc	a0,0x4
    3602:	f4a50513          	addi	a0,a0,-182 # 7548 <l_free+0x1b02>
    3606:	00002097          	auipc	ra,0x2
    360a:	ef6080e7          	jalr	-266(ra) # 54fc <unlink>
    360e:	c179                	beqz	a0,36d4 <rmdot+0x14e>
  if (unlink("dots") != 0) {
    3610:	00004517          	auipc	a0,0x4
    3614:	ea050513          	addi	a0,a0,-352 # 74b0 <l_free+0x1a6a>
    3618:	00002097          	auipc	ra,0x2
    361c:	ee4080e7          	jalr	-284(ra) # 54fc <unlink>
    3620:	e961                	bnez	a0,36f0 <rmdot+0x16a>
}
    3622:	60e2                	ld	ra,24(sp)
    3624:	6442                	ld	s0,16(sp)
    3626:	64a2                	ld	s1,8(sp)
    3628:	6105                	addi	sp,sp,32
    362a:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    362c:	85a6                	mv	a1,s1
    362e:	00004517          	auipc	a0,0x4
    3632:	e8a50513          	addi	a0,a0,-374 # 74b8 <l_free+0x1a72>
    3636:	00002097          	auipc	ra,0x2
    363a:	1ee080e7          	jalr	494(ra) # 5824 <printf>
    exit(1);
    363e:	4505                	li	a0,1
    3640:	00002097          	auipc	ra,0x2
    3644:	e6c080e7          	jalr	-404(ra) # 54ac <exit>
    printf("%s: chdir dots failed\n", s);
    3648:	85a6                	mv	a1,s1
    364a:	00004517          	auipc	a0,0x4
    364e:	e8650513          	addi	a0,a0,-378 # 74d0 <l_free+0x1a8a>
    3652:	00002097          	auipc	ra,0x2
    3656:	1d2080e7          	jalr	466(ra) # 5824 <printf>
    exit(1);
    365a:	4505                	li	a0,1
    365c:	00002097          	auipc	ra,0x2
    3660:	e50080e7          	jalr	-432(ra) # 54ac <exit>
    printf("%s: rm . worked!\n", s);
    3664:	85a6                	mv	a1,s1
    3666:	00004517          	auipc	a0,0x4
    366a:	e8250513          	addi	a0,a0,-382 # 74e8 <l_free+0x1aa2>
    366e:	00002097          	auipc	ra,0x2
    3672:	1b6080e7          	jalr	438(ra) # 5824 <printf>
    exit(1);
    3676:	4505                	li	a0,1
    3678:	00002097          	auipc	ra,0x2
    367c:	e34080e7          	jalr	-460(ra) # 54ac <exit>
    printf("%s: rm .. worked!\n", s);
    3680:	85a6                	mv	a1,s1
    3682:	00004517          	auipc	a0,0x4
    3686:	e8650513          	addi	a0,a0,-378 # 7508 <l_free+0x1ac2>
    368a:	00002097          	auipc	ra,0x2
    368e:	19a080e7          	jalr	410(ra) # 5824 <printf>
    exit(1);
    3692:	4505                	li	a0,1
    3694:	00002097          	auipc	ra,0x2
    3698:	e18080e7          	jalr	-488(ra) # 54ac <exit>
    printf("%s: chdir / failed\n", s);
    369c:	85a6                	mv	a1,s1
    369e:	00004517          	auipc	a0,0x4
    36a2:	87250513          	addi	a0,a0,-1934 # 6f10 <l_free+0x14ca>
    36a6:	00002097          	auipc	ra,0x2
    36aa:	17e080e7          	jalr	382(ra) # 5824 <printf>
    exit(1);
    36ae:	4505                	li	a0,1
    36b0:	00002097          	auipc	ra,0x2
    36b4:	dfc080e7          	jalr	-516(ra) # 54ac <exit>
    printf("%s: unlink dots/. worked!\n", s);
    36b8:	85a6                	mv	a1,s1
    36ba:	00004517          	auipc	a0,0x4
    36be:	e6e50513          	addi	a0,a0,-402 # 7528 <l_free+0x1ae2>
    36c2:	00002097          	auipc	ra,0x2
    36c6:	162080e7          	jalr	354(ra) # 5824 <printf>
    exit(1);
    36ca:	4505                	li	a0,1
    36cc:	00002097          	auipc	ra,0x2
    36d0:	de0080e7          	jalr	-544(ra) # 54ac <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    36d4:	85a6                	mv	a1,s1
    36d6:	00004517          	auipc	a0,0x4
    36da:	e7a50513          	addi	a0,a0,-390 # 7550 <l_free+0x1b0a>
    36de:	00002097          	auipc	ra,0x2
    36e2:	146080e7          	jalr	326(ra) # 5824 <printf>
    exit(1);
    36e6:	4505                	li	a0,1
    36e8:	00002097          	auipc	ra,0x2
    36ec:	dc4080e7          	jalr	-572(ra) # 54ac <exit>
    printf("%s: unlink dots failed!\n", s);
    36f0:	85a6                	mv	a1,s1
    36f2:	00004517          	auipc	a0,0x4
    36f6:	e7e50513          	addi	a0,a0,-386 # 7570 <l_free+0x1b2a>
    36fa:	00002097          	auipc	ra,0x2
    36fe:	12a080e7          	jalr	298(ra) # 5824 <printf>
    exit(1);
    3702:	4505                	li	a0,1
    3704:	00002097          	auipc	ra,0x2
    3708:	da8080e7          	jalr	-600(ra) # 54ac <exit>

000000000000370c <dirfile>:
void dirfile(char *s) {
    370c:	1101                	addi	sp,sp,-32
    370e:	ec06                	sd	ra,24(sp)
    3710:	e822                	sd	s0,16(sp)
    3712:	e426                	sd	s1,8(sp)
    3714:	e04a                	sd	s2,0(sp)
    3716:	1000                	addi	s0,sp,32
    3718:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    371a:	20000593          	li	a1,512
    371e:	00002517          	auipc	a0,0x2
    3722:	62a50513          	addi	a0,a0,1578 # 5d48 <l_free+0x302>
    3726:	00002097          	auipc	ra,0x2
    372a:	dc6080e7          	jalr	-570(ra) # 54ec <open>
  if (fd < 0) {
    372e:	0e054d63          	bltz	a0,3828 <dirfile+0x11c>
  close(fd);
    3732:	00002097          	auipc	ra,0x2
    3736:	da2080e7          	jalr	-606(ra) # 54d4 <close>
  if (chdir("dirfile") == 0) {
    373a:	00002517          	auipc	a0,0x2
    373e:	60e50513          	addi	a0,a0,1550 # 5d48 <l_free+0x302>
    3742:	00002097          	auipc	ra,0x2
    3746:	dda080e7          	jalr	-550(ra) # 551c <chdir>
    374a:	cd6d                	beqz	a0,3844 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    374c:	4581                	li	a1,0
    374e:	00004517          	auipc	a0,0x4
    3752:	e8250513          	addi	a0,a0,-382 # 75d0 <l_free+0x1b8a>
    3756:	00002097          	auipc	ra,0x2
    375a:	d96080e7          	jalr	-618(ra) # 54ec <open>
  if (fd >= 0) {
    375e:	10055163          	bgez	a0,3860 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    3762:	20000593          	li	a1,512
    3766:	00004517          	auipc	a0,0x4
    376a:	e6a50513          	addi	a0,a0,-406 # 75d0 <l_free+0x1b8a>
    376e:	00002097          	auipc	ra,0x2
    3772:	d7e080e7          	jalr	-642(ra) # 54ec <open>
  if (fd >= 0) {
    3776:	10055363          	bgez	a0,387c <dirfile+0x170>
  if (mkdir("dirfile/xx") == 0) {
    377a:	00004517          	auipc	a0,0x4
    377e:	e5650513          	addi	a0,a0,-426 # 75d0 <l_free+0x1b8a>
    3782:	00002097          	auipc	ra,0x2
    3786:	d92080e7          	jalr	-622(ra) # 5514 <mkdir>
    378a:	10050763          	beqz	a0,3898 <dirfile+0x18c>
  if (unlink("dirfile/xx") == 0) {
    378e:	00004517          	auipc	a0,0x4
    3792:	e4250513          	addi	a0,a0,-446 # 75d0 <l_free+0x1b8a>
    3796:	00002097          	auipc	ra,0x2
    379a:	d66080e7          	jalr	-666(ra) # 54fc <unlink>
    379e:	10050b63          	beqz	a0,38b4 <dirfile+0x1a8>
  if (link("README", "dirfile/xx") == 0) {
    37a2:	00004597          	auipc	a1,0x4
    37a6:	e2e58593          	addi	a1,a1,-466 # 75d0 <l_free+0x1b8a>
    37aa:	00002517          	auipc	a0,0x2
    37ae:	7c650513          	addi	a0,a0,1990 # 5f70 <l_free+0x52a>
    37b2:	00002097          	auipc	ra,0x2
    37b6:	d5a080e7          	jalr	-678(ra) # 550c <link>
    37ba:	10050b63          	beqz	a0,38d0 <dirfile+0x1c4>
  if (unlink("dirfile") != 0) {
    37be:	00002517          	auipc	a0,0x2
    37c2:	58a50513          	addi	a0,a0,1418 # 5d48 <l_free+0x302>
    37c6:	00002097          	auipc	ra,0x2
    37ca:	d36080e7          	jalr	-714(ra) # 54fc <unlink>
    37ce:	10051f63          	bnez	a0,38ec <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    37d2:	4589                	li	a1,2
    37d4:	00003517          	auipc	a0,0x3
    37d8:	c9c50513          	addi	a0,a0,-868 # 6470 <l_free+0xa2a>
    37dc:	00002097          	auipc	ra,0x2
    37e0:	d10080e7          	jalr	-752(ra) # 54ec <open>
  if (fd >= 0) {
    37e4:	12055263          	bgez	a0,3908 <dirfile+0x1fc>
  fd = open(".", 0);
    37e8:	4581                	li	a1,0
    37ea:	00003517          	auipc	a0,0x3
    37ee:	c8650513          	addi	a0,a0,-890 # 6470 <l_free+0xa2a>
    37f2:	00002097          	auipc	ra,0x2
    37f6:	cfa080e7          	jalr	-774(ra) # 54ec <open>
    37fa:	84aa                	mv	s1,a0
  if (write(fd, "x", 1) > 0) {
    37fc:	4605                	li	a2,1
    37fe:	00002597          	auipc	a1,0x2
    3802:	61a58593          	addi	a1,a1,1562 # 5e18 <l_free+0x3d2>
    3806:	00002097          	auipc	ra,0x2
    380a:	cc6080e7          	jalr	-826(ra) # 54cc <write>
    380e:	10a04b63          	bgtz	a0,3924 <dirfile+0x218>
  close(fd);
    3812:	8526                	mv	a0,s1
    3814:	00002097          	auipc	ra,0x2
    3818:	cc0080e7          	jalr	-832(ra) # 54d4 <close>
}
    381c:	60e2                	ld	ra,24(sp)
    381e:	6442                	ld	s0,16(sp)
    3820:	64a2                	ld	s1,8(sp)
    3822:	6902                	ld	s2,0(sp)
    3824:	6105                	addi	sp,sp,32
    3826:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3828:	85ca                	mv	a1,s2
    382a:	00004517          	auipc	a0,0x4
    382e:	d6650513          	addi	a0,a0,-666 # 7590 <l_free+0x1b4a>
    3832:	00002097          	auipc	ra,0x2
    3836:	ff2080e7          	jalr	-14(ra) # 5824 <printf>
    exit(1);
    383a:	4505                	li	a0,1
    383c:	00002097          	auipc	ra,0x2
    3840:	c70080e7          	jalr	-912(ra) # 54ac <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3844:	85ca                	mv	a1,s2
    3846:	00004517          	auipc	a0,0x4
    384a:	d6a50513          	addi	a0,a0,-662 # 75b0 <l_free+0x1b6a>
    384e:	00002097          	auipc	ra,0x2
    3852:	fd6080e7          	jalr	-42(ra) # 5824 <printf>
    exit(1);
    3856:	4505                	li	a0,1
    3858:	00002097          	auipc	ra,0x2
    385c:	c54080e7          	jalr	-940(ra) # 54ac <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3860:	85ca                	mv	a1,s2
    3862:	00004517          	auipc	a0,0x4
    3866:	d7e50513          	addi	a0,a0,-642 # 75e0 <l_free+0x1b9a>
    386a:	00002097          	auipc	ra,0x2
    386e:	fba080e7          	jalr	-70(ra) # 5824 <printf>
    exit(1);
    3872:	4505                	li	a0,1
    3874:	00002097          	auipc	ra,0x2
    3878:	c38080e7          	jalr	-968(ra) # 54ac <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    387c:	85ca                	mv	a1,s2
    387e:	00004517          	auipc	a0,0x4
    3882:	d6250513          	addi	a0,a0,-670 # 75e0 <l_free+0x1b9a>
    3886:	00002097          	auipc	ra,0x2
    388a:	f9e080e7          	jalr	-98(ra) # 5824 <printf>
    exit(1);
    388e:	4505                	li	a0,1
    3890:	00002097          	auipc	ra,0x2
    3894:	c1c080e7          	jalr	-996(ra) # 54ac <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    3898:	85ca                	mv	a1,s2
    389a:	00004517          	auipc	a0,0x4
    389e:	d6e50513          	addi	a0,a0,-658 # 7608 <l_free+0x1bc2>
    38a2:	00002097          	auipc	ra,0x2
    38a6:	f82080e7          	jalr	-126(ra) # 5824 <printf>
    exit(1);
    38aa:	4505                	li	a0,1
    38ac:	00002097          	auipc	ra,0x2
    38b0:	c00080e7          	jalr	-1024(ra) # 54ac <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    38b4:	85ca                	mv	a1,s2
    38b6:	00004517          	auipc	a0,0x4
    38ba:	d7a50513          	addi	a0,a0,-646 # 7630 <l_free+0x1bea>
    38be:	00002097          	auipc	ra,0x2
    38c2:	f66080e7          	jalr	-154(ra) # 5824 <printf>
    exit(1);
    38c6:	4505                	li	a0,1
    38c8:	00002097          	auipc	ra,0x2
    38cc:	be4080e7          	jalr	-1052(ra) # 54ac <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    38d0:	85ca                	mv	a1,s2
    38d2:	00004517          	auipc	a0,0x4
    38d6:	d8650513          	addi	a0,a0,-634 # 7658 <l_free+0x1c12>
    38da:	00002097          	auipc	ra,0x2
    38de:	f4a080e7          	jalr	-182(ra) # 5824 <printf>
    exit(1);
    38e2:	4505                	li	a0,1
    38e4:	00002097          	auipc	ra,0x2
    38e8:	bc8080e7          	jalr	-1080(ra) # 54ac <exit>
    printf("%s: unlink dirfile failed!\n", s);
    38ec:	85ca                	mv	a1,s2
    38ee:	00004517          	auipc	a0,0x4
    38f2:	d9250513          	addi	a0,a0,-622 # 7680 <l_free+0x1c3a>
    38f6:	00002097          	auipc	ra,0x2
    38fa:	f2e080e7          	jalr	-210(ra) # 5824 <printf>
    exit(1);
    38fe:	4505                	li	a0,1
    3900:	00002097          	auipc	ra,0x2
    3904:	bac080e7          	jalr	-1108(ra) # 54ac <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3908:	85ca                	mv	a1,s2
    390a:	00004517          	auipc	a0,0x4
    390e:	d9650513          	addi	a0,a0,-618 # 76a0 <l_free+0x1c5a>
    3912:	00002097          	auipc	ra,0x2
    3916:	f12080e7          	jalr	-238(ra) # 5824 <printf>
    exit(1);
    391a:	4505                	li	a0,1
    391c:	00002097          	auipc	ra,0x2
    3920:	b90080e7          	jalr	-1136(ra) # 54ac <exit>
    printf("%s: write . succeeded!\n", s);
    3924:	85ca                	mv	a1,s2
    3926:	00004517          	auipc	a0,0x4
    392a:	da250513          	addi	a0,a0,-606 # 76c8 <l_free+0x1c82>
    392e:	00002097          	auipc	ra,0x2
    3932:	ef6080e7          	jalr	-266(ra) # 5824 <printf>
    exit(1);
    3936:	4505                	li	a0,1
    3938:	00002097          	auipc	ra,0x2
    393c:	b74080e7          	jalr	-1164(ra) # 54ac <exit>

0000000000003940 <iref>:
void iref(char *s) {
    3940:	7139                	addi	sp,sp,-64
    3942:	fc06                	sd	ra,56(sp)
    3944:	f822                	sd	s0,48(sp)
    3946:	f426                	sd	s1,40(sp)
    3948:	f04a                	sd	s2,32(sp)
    394a:	ec4e                	sd	s3,24(sp)
    394c:	e852                	sd	s4,16(sp)
    394e:	e456                	sd	s5,8(sp)
    3950:	e05a                	sd	s6,0(sp)
    3952:	0080                	addi	s0,sp,64
    3954:	8b2a                	mv	s6,a0
    3956:	03300913          	li	s2,51
    if (mkdir("irefd") != 0) {
    395a:	00004a17          	auipc	s4,0x4
    395e:	d86a0a13          	addi	s4,s4,-634 # 76e0 <l_free+0x1c9a>
    mkdir("");
    3962:	00004497          	auipc	s1,0x4
    3966:	88648493          	addi	s1,s1,-1914 # 71e8 <l_free+0x17a2>
    link("README", "");
    396a:	00002a97          	auipc	s5,0x2
    396e:	606a8a93          	addi	s5,s5,1542 # 5f70 <l_free+0x52a>
    fd = open("xx", O_CREATE);
    3972:	00004997          	auipc	s3,0x4
    3976:	c6698993          	addi	s3,s3,-922 # 75d8 <l_free+0x1b92>
    397a:	a891                	j	39ce <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    397c:	85da                	mv	a1,s6
    397e:	00004517          	auipc	a0,0x4
    3982:	d6a50513          	addi	a0,a0,-662 # 76e8 <l_free+0x1ca2>
    3986:	00002097          	auipc	ra,0x2
    398a:	e9e080e7          	jalr	-354(ra) # 5824 <printf>
      exit(1);
    398e:	4505                	li	a0,1
    3990:	00002097          	auipc	ra,0x2
    3994:	b1c080e7          	jalr	-1252(ra) # 54ac <exit>
      printf("%s: chdir irefd failed\n", s);
    3998:	85da                	mv	a1,s6
    399a:	00004517          	auipc	a0,0x4
    399e:	d6650513          	addi	a0,a0,-666 # 7700 <l_free+0x1cba>
    39a2:	00002097          	auipc	ra,0x2
    39a6:	e82080e7          	jalr	-382(ra) # 5824 <printf>
      exit(1);
    39aa:	4505                	li	a0,1
    39ac:	00002097          	auipc	ra,0x2
    39b0:	b00080e7          	jalr	-1280(ra) # 54ac <exit>
      close(fd);
    39b4:	00002097          	auipc	ra,0x2
    39b8:	b20080e7          	jalr	-1248(ra) # 54d4 <close>
    39bc:	a889                	j	3a0e <iref+0xce>
    unlink("xx");
    39be:	854e                	mv	a0,s3
    39c0:	00002097          	auipc	ra,0x2
    39c4:	b3c080e7          	jalr	-1220(ra) # 54fc <unlink>
  for (i = 0; i < NINODE + 1; i++) {
    39c8:	397d                	addiw	s2,s2,-1
    39ca:	06090063          	beqz	s2,3a2a <iref+0xea>
    if (mkdir("irefd") != 0) {
    39ce:	8552                	mv	a0,s4
    39d0:	00002097          	auipc	ra,0x2
    39d4:	b44080e7          	jalr	-1212(ra) # 5514 <mkdir>
    39d8:	f155                	bnez	a0,397c <iref+0x3c>
    if (chdir("irefd") != 0) {
    39da:	8552                	mv	a0,s4
    39dc:	00002097          	auipc	ra,0x2
    39e0:	b40080e7          	jalr	-1216(ra) # 551c <chdir>
    39e4:	f955                	bnez	a0,3998 <iref+0x58>
    mkdir("");
    39e6:	8526                	mv	a0,s1
    39e8:	00002097          	auipc	ra,0x2
    39ec:	b2c080e7          	jalr	-1236(ra) # 5514 <mkdir>
    link("README", "");
    39f0:	85a6                	mv	a1,s1
    39f2:	8556                	mv	a0,s5
    39f4:	00002097          	auipc	ra,0x2
    39f8:	b18080e7          	jalr	-1256(ra) # 550c <link>
    fd = open("", O_CREATE);
    39fc:	20000593          	li	a1,512
    3a00:	8526                	mv	a0,s1
    3a02:	00002097          	auipc	ra,0x2
    3a06:	aea080e7          	jalr	-1302(ra) # 54ec <open>
    if (fd >= 0)
    3a0a:	fa0555e3          	bgez	a0,39b4 <iref+0x74>
    fd = open("xx", O_CREATE);
    3a0e:	20000593          	li	a1,512
    3a12:	854e                	mv	a0,s3
    3a14:	00002097          	auipc	ra,0x2
    3a18:	ad8080e7          	jalr	-1320(ra) # 54ec <open>
    if (fd >= 0)
    3a1c:	fa0541e3          	bltz	a0,39be <iref+0x7e>
      close(fd);
    3a20:	00002097          	auipc	ra,0x2
    3a24:	ab4080e7          	jalr	-1356(ra) # 54d4 <close>
    3a28:	bf59                	j	39be <iref+0x7e>
    3a2a:	03300493          	li	s1,51
    chdir("..");
    3a2e:	00004997          	auipc	s3,0x4
    3a32:	ad298993          	addi	s3,s3,-1326 # 7500 <l_free+0x1aba>
    unlink("irefd");
    3a36:	00004917          	auipc	s2,0x4
    3a3a:	caa90913          	addi	s2,s2,-854 # 76e0 <l_free+0x1c9a>
    chdir("..");
    3a3e:	854e                	mv	a0,s3
    3a40:	00002097          	auipc	ra,0x2
    3a44:	adc080e7          	jalr	-1316(ra) # 551c <chdir>
    unlink("irefd");
    3a48:	854a                	mv	a0,s2
    3a4a:	00002097          	auipc	ra,0x2
    3a4e:	ab2080e7          	jalr	-1358(ra) # 54fc <unlink>
  for (i = 0; i < NINODE + 1; i++) {
    3a52:	34fd                	addiw	s1,s1,-1
    3a54:	f4ed                	bnez	s1,3a3e <iref+0xfe>
  chdir("/");
    3a56:	00003517          	auipc	a0,0x3
    3a5a:	4b250513          	addi	a0,a0,1202 # 6f08 <l_free+0x14c2>
    3a5e:	00002097          	auipc	ra,0x2
    3a62:	abe080e7          	jalr	-1346(ra) # 551c <chdir>
}
    3a66:	70e2                	ld	ra,56(sp)
    3a68:	7442                	ld	s0,48(sp)
    3a6a:	74a2                	ld	s1,40(sp)
    3a6c:	7902                	ld	s2,32(sp)
    3a6e:	69e2                	ld	s3,24(sp)
    3a70:	6a42                	ld	s4,16(sp)
    3a72:	6aa2                	ld	s5,8(sp)
    3a74:	6b02                	ld	s6,0(sp)
    3a76:	6121                	addi	sp,sp,64
    3a78:	8082                	ret

0000000000003a7a <openiputtest>:
void openiputtest(char *s) {
    3a7a:	7179                	addi	sp,sp,-48
    3a7c:	f406                	sd	ra,40(sp)
    3a7e:	f022                	sd	s0,32(sp)
    3a80:	ec26                	sd	s1,24(sp)
    3a82:	1800                	addi	s0,sp,48
    3a84:	84aa                	mv	s1,a0
  if (mkdir("oidir") < 0) {
    3a86:	00004517          	auipc	a0,0x4
    3a8a:	c9250513          	addi	a0,a0,-878 # 7718 <l_free+0x1cd2>
    3a8e:	00002097          	auipc	ra,0x2
    3a92:	a86080e7          	jalr	-1402(ra) # 5514 <mkdir>
    3a96:	04054263          	bltz	a0,3ada <openiputtest+0x60>
  pid = fork();
    3a9a:	00002097          	auipc	ra,0x2
    3a9e:	a0a080e7          	jalr	-1526(ra) # 54a4 <fork>
  if (pid < 0) {
    3aa2:	04054a63          	bltz	a0,3af6 <openiputtest+0x7c>
  if (pid == 0) {
    3aa6:	e93d                	bnez	a0,3b1c <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    3aa8:	4589                	li	a1,2
    3aaa:	00004517          	auipc	a0,0x4
    3aae:	c6e50513          	addi	a0,a0,-914 # 7718 <l_free+0x1cd2>
    3ab2:	00002097          	auipc	ra,0x2
    3ab6:	a3a080e7          	jalr	-1478(ra) # 54ec <open>
    if (fd >= 0) {
    3aba:	04054c63          	bltz	a0,3b12 <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    3abe:	85a6                	mv	a1,s1
    3ac0:	00004517          	auipc	a0,0x4
    3ac4:	c7850513          	addi	a0,a0,-904 # 7738 <l_free+0x1cf2>
    3ac8:	00002097          	auipc	ra,0x2
    3acc:	d5c080e7          	jalr	-676(ra) # 5824 <printf>
      exit(1);
    3ad0:	4505                	li	a0,1
    3ad2:	00002097          	auipc	ra,0x2
    3ad6:	9da080e7          	jalr	-1574(ra) # 54ac <exit>
    printf("%s: mkdir oidir failed\n", s);
    3ada:	85a6                	mv	a1,s1
    3adc:	00004517          	auipc	a0,0x4
    3ae0:	c4450513          	addi	a0,a0,-956 # 7720 <l_free+0x1cda>
    3ae4:	00002097          	auipc	ra,0x2
    3ae8:	d40080e7          	jalr	-704(ra) # 5824 <printf>
    exit(1);
    3aec:	4505                	li	a0,1
    3aee:	00002097          	auipc	ra,0x2
    3af2:	9be080e7          	jalr	-1602(ra) # 54ac <exit>
    printf("%s: fork failed\n", s);
    3af6:	85a6                	mv	a1,s1
    3af8:	00003517          	auipc	a0,0x3
    3afc:	b1850513          	addi	a0,a0,-1256 # 6610 <l_free+0xbca>
    3b00:	00002097          	auipc	ra,0x2
    3b04:	d24080e7          	jalr	-732(ra) # 5824 <printf>
    exit(1);
    3b08:	4505                	li	a0,1
    3b0a:	00002097          	auipc	ra,0x2
    3b0e:	9a2080e7          	jalr	-1630(ra) # 54ac <exit>
    exit(0);
    3b12:	4501                	li	a0,0
    3b14:	00002097          	auipc	ra,0x2
    3b18:	998080e7          	jalr	-1640(ra) # 54ac <exit>
  sleep(1);
    3b1c:	4505                	li	a0,1
    3b1e:	00002097          	auipc	ra,0x2
    3b22:	a1e080e7          	jalr	-1506(ra) # 553c <sleep>
  if (unlink("oidir") != 0) {
    3b26:	00004517          	auipc	a0,0x4
    3b2a:	bf250513          	addi	a0,a0,-1038 # 7718 <l_free+0x1cd2>
    3b2e:	00002097          	auipc	ra,0x2
    3b32:	9ce080e7          	jalr	-1586(ra) # 54fc <unlink>
    3b36:	cd19                	beqz	a0,3b54 <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    3b38:	85a6                	mv	a1,s1
    3b3a:	00003517          	auipc	a0,0x3
    3b3e:	cc650513          	addi	a0,a0,-826 # 6800 <l_free+0xdba>
    3b42:	00002097          	auipc	ra,0x2
    3b46:	ce2080e7          	jalr	-798(ra) # 5824 <printf>
    exit(1);
    3b4a:	4505                	li	a0,1
    3b4c:	00002097          	auipc	ra,0x2
    3b50:	960080e7          	jalr	-1696(ra) # 54ac <exit>
  wait(&xstatus);
    3b54:	fdc40513          	addi	a0,s0,-36
    3b58:	00002097          	auipc	ra,0x2
    3b5c:	95c080e7          	jalr	-1700(ra) # 54b4 <wait>
  exit(xstatus);
    3b60:	fdc42503          	lw	a0,-36(s0)
    3b64:	00002097          	auipc	ra,0x2
    3b68:	948080e7          	jalr	-1720(ra) # 54ac <exit>

0000000000003b6c <forkforkfork>:
void forkforkfork(char *s) {
    3b6c:	1101                	addi	sp,sp,-32
    3b6e:	ec06                	sd	ra,24(sp)
    3b70:	e822                	sd	s0,16(sp)
    3b72:	e426                	sd	s1,8(sp)
    3b74:	1000                	addi	s0,sp,32
    3b76:	84aa                	mv	s1,a0
  unlink("stopforking");
    3b78:	00004517          	auipc	a0,0x4
    3b7c:	be850513          	addi	a0,a0,-1048 # 7760 <l_free+0x1d1a>
    3b80:	00002097          	auipc	ra,0x2
    3b84:	97c080e7          	jalr	-1668(ra) # 54fc <unlink>
  int pid = fork();
    3b88:	00002097          	auipc	ra,0x2
    3b8c:	91c080e7          	jalr	-1764(ra) # 54a4 <fork>
  if (pid < 0) {
    3b90:	04054563          	bltz	a0,3bda <forkforkfork+0x6e>
  if (pid == 0) {
    3b94:	c12d                	beqz	a0,3bf6 <forkforkfork+0x8a>
  sleep(20); // two seconds
    3b96:	4551                	li	a0,20
    3b98:	00002097          	auipc	ra,0x2
    3b9c:	9a4080e7          	jalr	-1628(ra) # 553c <sleep>
  close(open("stopforking", O_CREATE | O_RDWR));
    3ba0:	20200593          	li	a1,514
    3ba4:	00004517          	auipc	a0,0x4
    3ba8:	bbc50513          	addi	a0,a0,-1092 # 7760 <l_free+0x1d1a>
    3bac:	00002097          	auipc	ra,0x2
    3bb0:	940080e7          	jalr	-1728(ra) # 54ec <open>
    3bb4:	00002097          	auipc	ra,0x2
    3bb8:	920080e7          	jalr	-1760(ra) # 54d4 <close>
  wait(0);
    3bbc:	4501                	li	a0,0
    3bbe:	00002097          	auipc	ra,0x2
    3bc2:	8f6080e7          	jalr	-1802(ra) # 54b4 <wait>
  sleep(10); // one second
    3bc6:	4529                	li	a0,10
    3bc8:	00002097          	auipc	ra,0x2
    3bcc:	974080e7          	jalr	-1676(ra) # 553c <sleep>
}
    3bd0:	60e2                	ld	ra,24(sp)
    3bd2:	6442                	ld	s0,16(sp)
    3bd4:	64a2                	ld	s1,8(sp)
    3bd6:	6105                	addi	sp,sp,32
    3bd8:	8082                	ret
    printf("%s: fork failed", s);
    3bda:	85a6                	mv	a1,s1
    3bdc:	00003517          	auipc	a0,0x3
    3be0:	bf450513          	addi	a0,a0,-1036 # 67d0 <l_free+0xd8a>
    3be4:	00002097          	auipc	ra,0x2
    3be8:	c40080e7          	jalr	-960(ra) # 5824 <printf>
    exit(1);
    3bec:	4505                	li	a0,1
    3bee:	00002097          	auipc	ra,0x2
    3bf2:	8be080e7          	jalr	-1858(ra) # 54ac <exit>
      int fd = open("stopforking", 0);
    3bf6:	00004497          	auipc	s1,0x4
    3bfa:	b6a48493          	addi	s1,s1,-1174 # 7760 <l_free+0x1d1a>
    3bfe:	4581                	li	a1,0
    3c00:	8526                	mv	a0,s1
    3c02:	00002097          	auipc	ra,0x2
    3c06:	8ea080e7          	jalr	-1814(ra) # 54ec <open>
      if (fd >= 0) {
    3c0a:	02055463          	bgez	a0,3c32 <forkforkfork+0xc6>
      if (fork() < 0) {
    3c0e:	00002097          	auipc	ra,0x2
    3c12:	896080e7          	jalr	-1898(ra) # 54a4 <fork>
    3c16:	fe0554e3          	bgez	a0,3bfe <forkforkfork+0x92>
        close(open("stopforking", O_CREATE | O_RDWR));
    3c1a:	20200593          	li	a1,514
    3c1e:	8526                	mv	a0,s1
    3c20:	00002097          	auipc	ra,0x2
    3c24:	8cc080e7          	jalr	-1844(ra) # 54ec <open>
    3c28:	00002097          	auipc	ra,0x2
    3c2c:	8ac080e7          	jalr	-1876(ra) # 54d4 <close>
    3c30:	b7f9                	j	3bfe <forkforkfork+0x92>
        exit(0);
    3c32:	4501                	li	a0,0
    3c34:	00002097          	auipc	ra,0x2
    3c38:	878080e7          	jalr	-1928(ra) # 54ac <exit>

0000000000003c3c <sbrkbasic>:
void sbrkbasic(char *s) {
    3c3c:	7139                	addi	sp,sp,-64
    3c3e:	fc06                	sd	ra,56(sp)
    3c40:	f822                	sd	s0,48(sp)
    3c42:	f426                	sd	s1,40(sp)
    3c44:	f04a                	sd	s2,32(sp)
    3c46:	ec4e                	sd	s3,24(sp)
    3c48:	e852                	sd	s4,16(sp)
    3c4a:	0080                	addi	s0,sp,64
    3c4c:	8a2a                	mv	s4,a0
  pid = fork();
    3c4e:	00002097          	auipc	ra,0x2
    3c52:	856080e7          	jalr	-1962(ra) # 54a4 <fork>
  if (pid < 0) {
    3c56:	02054c63          	bltz	a0,3c8e <sbrkbasic+0x52>
  if (pid == 0) {
    3c5a:	ed21                	bnez	a0,3cb2 <sbrkbasic+0x76>
    a = sbrk(TOOMUCH);
    3c5c:	40000537          	lui	a0,0x40000
    3c60:	00002097          	auipc	ra,0x2
    3c64:	8d4080e7          	jalr	-1836(ra) # 5534 <sbrk>
    if (a == (char *)0xffffffffffffffffL) {
    3c68:	57fd                	li	a5,-1
    3c6a:	02f50f63          	beq	a0,a5,3ca8 <sbrkbasic+0x6c>
    for (b = a; b < a + TOOMUCH; b += 4096) {
    3c6e:	400007b7          	lui	a5,0x40000
    3c72:	97aa                	add	a5,a5,a0
      *b = 99;
    3c74:	06300693          	li	a3,99
    for (b = a; b < a + TOOMUCH; b += 4096) {
    3c78:	6705                	lui	a4,0x1
      *b = 99;
    3c7a:	00d50023          	sb	a3,0(a0) # 40000000 <__BSS_END__+0x3fff1638>
    for (b = a; b < a + TOOMUCH; b += 4096) {
    3c7e:	953a                	add	a0,a0,a4
    3c80:	fef51de3          	bne	a0,a5,3c7a <sbrkbasic+0x3e>
    exit(1);
    3c84:	4505                	li	a0,1
    3c86:	00002097          	auipc	ra,0x2
    3c8a:	826080e7          	jalr	-2010(ra) # 54ac <exit>
    printf("fork failed in sbrkbasic\n");
    3c8e:	00004517          	auipc	a0,0x4
    3c92:	ae250513          	addi	a0,a0,-1310 # 7770 <l_free+0x1d2a>
    3c96:	00002097          	auipc	ra,0x2
    3c9a:	b8e080e7          	jalr	-1138(ra) # 5824 <printf>
    exit(1);
    3c9e:	4505                	li	a0,1
    3ca0:	00002097          	auipc	ra,0x2
    3ca4:	80c080e7          	jalr	-2036(ra) # 54ac <exit>
      exit(0);
    3ca8:	4501                	li	a0,0
    3caa:	00002097          	auipc	ra,0x2
    3cae:	802080e7          	jalr	-2046(ra) # 54ac <exit>
  sleep(10);
    3cb2:	4529                	li	a0,10
    3cb4:	00002097          	auipc	ra,0x2
    3cb8:	888080e7          	jalr	-1912(ra) # 553c <sleep>
  wait(&xstatus);
    3cbc:	fcc40513          	addi	a0,s0,-52
    3cc0:	00001097          	auipc	ra,0x1
    3cc4:	7f4080e7          	jalr	2036(ra) # 54b4 <wait>
  if (xstatus == 1) {
    3cc8:	fcc42703          	lw	a4,-52(s0)
    3ccc:	4785                	li	a5,1
    3cce:	02f70563          	beq	a4,a5,3cf8 <sbrkbasic+0xbc>
  char *ss = sbrk(4096);
    3cd2:	6505                	lui	a0,0x1
    3cd4:	00002097          	auipc	ra,0x2
    3cd8:	860080e7          	jalr	-1952(ra) # 5534 <sbrk>
  *ss = 10;
    3cdc:	47a9                	li	a5,10
    3cde:	00f50023          	sb	a5,0(a0) # 1000 <linktest+0x1d2>
  a = sbrk(0);
    3ce2:	4501                	li	a0,0
    3ce4:	00002097          	auipc	ra,0x2
    3ce8:	850080e7          	jalr	-1968(ra) # 5534 <sbrk>
    3cec:	84aa                	mv	s1,a0
  for (i = 0; i < 5000; i++) {
    3cee:	4901                	li	s2,0
    3cf0:	6985                	lui	s3,0x1
    3cf2:	38898993          	addi	s3,s3,904 # 1388 <copyinstr2+0xbe>
    3cf6:	a005                	j	3d16 <sbrkbasic+0xda>
    printf("%s: too much memory allocated!\n", s);
    3cf8:	85d2                	mv	a1,s4
    3cfa:	00004517          	auipc	a0,0x4
    3cfe:	a9650513          	addi	a0,a0,-1386 # 7790 <l_free+0x1d4a>
    3d02:	00002097          	auipc	ra,0x2
    3d06:	b22080e7          	jalr	-1246(ra) # 5824 <printf>
    exit(1);
    3d0a:	4505                	li	a0,1
    3d0c:	00001097          	auipc	ra,0x1
    3d10:	7a0080e7          	jalr	1952(ra) # 54ac <exit>
    a = b + 1;
    3d14:	84be                	mv	s1,a5
    b = sbrk(1);
    3d16:	4505                	li	a0,1
    3d18:	00002097          	auipc	ra,0x2
    3d1c:	81c080e7          	jalr	-2020(ra) # 5534 <sbrk>
    if (b != a) {
    3d20:	04951c63          	bne	a0,s1,3d78 <sbrkbasic+0x13c>
    *b = 1;
    3d24:	4785                	li	a5,1
    3d26:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    3d2a:	00148793          	addi	a5,s1,1
  for (i = 0; i < 5000; i++) {
    3d2e:	2905                	addiw	s2,s2,1
    3d30:	ff3912e3          	bne	s2,s3,3d14 <sbrkbasic+0xd8>
  pid = fork();
    3d34:	00001097          	auipc	ra,0x1
    3d38:	770080e7          	jalr	1904(ra) # 54a4 <fork>
    3d3c:	892a                	mv	s2,a0
  if (pid < 0) {
    3d3e:	04054d63          	bltz	a0,3d98 <sbrkbasic+0x15c>
  c = sbrk(1);
    3d42:	4505                	li	a0,1
    3d44:	00001097          	auipc	ra,0x1
    3d48:	7f0080e7          	jalr	2032(ra) # 5534 <sbrk>
  c = sbrk(1);
    3d4c:	4505                	li	a0,1
    3d4e:	00001097          	auipc	ra,0x1
    3d52:	7e6080e7          	jalr	2022(ra) # 5534 <sbrk>
  if (c != a + 1) {
    3d56:	0489                	addi	s1,s1,2
    3d58:	04a48e63          	beq	s1,a0,3db4 <sbrkbasic+0x178>
    printf("%s: sbrk test failed post-fork\n", s);
    3d5c:	85d2                	mv	a1,s4
    3d5e:	00004517          	auipc	a0,0x4
    3d62:	a9250513          	addi	a0,a0,-1390 # 77f0 <l_free+0x1daa>
    3d66:	00002097          	auipc	ra,0x2
    3d6a:	abe080e7          	jalr	-1346(ra) # 5824 <printf>
    exit(1);
    3d6e:	4505                	li	a0,1
    3d70:	00001097          	auipc	ra,0x1
    3d74:	73c080e7          	jalr	1852(ra) # 54ac <exit>
      printf("%s: sbrk test failed %d %x %x\n", i, a, b);
    3d78:	86aa                	mv	a3,a0
    3d7a:	8626                	mv	a2,s1
    3d7c:	85ca                	mv	a1,s2
    3d7e:	00004517          	auipc	a0,0x4
    3d82:	a3250513          	addi	a0,a0,-1486 # 77b0 <l_free+0x1d6a>
    3d86:	00002097          	auipc	ra,0x2
    3d8a:	a9e080e7          	jalr	-1378(ra) # 5824 <printf>
      exit(1);
    3d8e:	4505                	li	a0,1
    3d90:	00001097          	auipc	ra,0x1
    3d94:	71c080e7          	jalr	1820(ra) # 54ac <exit>
    printf("%s: sbrk test fork failed\n", s);
    3d98:	85d2                	mv	a1,s4
    3d9a:	00004517          	auipc	a0,0x4
    3d9e:	a3650513          	addi	a0,a0,-1482 # 77d0 <l_free+0x1d8a>
    3da2:	00002097          	auipc	ra,0x2
    3da6:	a82080e7          	jalr	-1406(ra) # 5824 <printf>
    exit(1);
    3daa:	4505                	li	a0,1
    3dac:	00001097          	auipc	ra,0x1
    3db0:	700080e7          	jalr	1792(ra) # 54ac <exit>
  if (pid == 0)
    3db4:	00091763          	bnez	s2,3dc2 <sbrkbasic+0x186>
    exit(0);
    3db8:	4501                	li	a0,0
    3dba:	00001097          	auipc	ra,0x1
    3dbe:	6f2080e7          	jalr	1778(ra) # 54ac <exit>
  wait(&xstatus);
    3dc2:	fcc40513          	addi	a0,s0,-52
    3dc6:	00001097          	auipc	ra,0x1
    3dca:	6ee080e7          	jalr	1774(ra) # 54b4 <wait>
  exit(xstatus);
    3dce:	fcc42503          	lw	a0,-52(s0)
    3dd2:	00001097          	auipc	ra,0x1
    3dd6:	6da080e7          	jalr	1754(ra) # 54ac <exit>

0000000000003dda <preempt>:
void preempt(char *s) {
    3dda:	7139                	addi	sp,sp,-64
    3ddc:	fc06                	sd	ra,56(sp)
    3dde:	f822                	sd	s0,48(sp)
    3de0:	f426                	sd	s1,40(sp)
    3de2:	f04a                	sd	s2,32(sp)
    3de4:	ec4e                	sd	s3,24(sp)
    3de6:	e852                	sd	s4,16(sp)
    3de8:	0080                	addi	s0,sp,64
    3dea:	892a                	mv	s2,a0
  pid1 = fork();
    3dec:	00001097          	auipc	ra,0x1
    3df0:	6b8080e7          	jalr	1720(ra) # 54a4 <fork>
  if (pid1 < 0) {
    3df4:	00054563          	bltz	a0,3dfe <preempt+0x24>
    3df8:	84aa                	mv	s1,a0
  if (pid1 == 0)
    3dfa:	ed19                	bnez	a0,3e18 <preempt+0x3e>
    for (;;)
    3dfc:	a001                	j	3dfc <preempt+0x22>
    printf("%s: fork failed");
    3dfe:	00003517          	auipc	a0,0x3
    3e02:	9d250513          	addi	a0,a0,-1582 # 67d0 <l_free+0xd8a>
    3e06:	00002097          	auipc	ra,0x2
    3e0a:	a1e080e7          	jalr	-1506(ra) # 5824 <printf>
    exit(1);
    3e0e:	4505                	li	a0,1
    3e10:	00001097          	auipc	ra,0x1
    3e14:	69c080e7          	jalr	1692(ra) # 54ac <exit>
  pid2 = fork();
    3e18:	00001097          	auipc	ra,0x1
    3e1c:	68c080e7          	jalr	1676(ra) # 54a4 <fork>
    3e20:	89aa                	mv	s3,a0
  if (pid2 < 0) {
    3e22:	00054463          	bltz	a0,3e2a <preempt+0x50>
  if (pid2 == 0)
    3e26:	e105                	bnez	a0,3e46 <preempt+0x6c>
    for (;;)
    3e28:	a001                	j	3e28 <preempt+0x4e>
    printf("%s: fork failed\n", s);
    3e2a:	85ca                	mv	a1,s2
    3e2c:	00002517          	auipc	a0,0x2
    3e30:	7e450513          	addi	a0,a0,2020 # 6610 <l_free+0xbca>
    3e34:	00002097          	auipc	ra,0x2
    3e38:	9f0080e7          	jalr	-1552(ra) # 5824 <printf>
    exit(1);
    3e3c:	4505                	li	a0,1
    3e3e:	00001097          	auipc	ra,0x1
    3e42:	66e080e7          	jalr	1646(ra) # 54ac <exit>
  pipe(pfds);
    3e46:	fc840513          	addi	a0,s0,-56
    3e4a:	00001097          	auipc	ra,0x1
    3e4e:	672080e7          	jalr	1650(ra) # 54bc <pipe>
  pid3 = fork();
    3e52:	00001097          	auipc	ra,0x1
    3e56:	652080e7          	jalr	1618(ra) # 54a4 <fork>
    3e5a:	8a2a                	mv	s4,a0
  if (pid3 < 0) {
    3e5c:	02054e63          	bltz	a0,3e98 <preempt+0xbe>
  if (pid3 == 0) {
    3e60:	e13d                	bnez	a0,3ec6 <preempt+0xec>
    close(pfds[0]);
    3e62:	fc842503          	lw	a0,-56(s0)
    3e66:	00001097          	auipc	ra,0x1
    3e6a:	66e080e7          	jalr	1646(ra) # 54d4 <close>
    if (write(pfds[1], "x", 1) != 1)
    3e6e:	4605                	li	a2,1
    3e70:	00002597          	auipc	a1,0x2
    3e74:	fa858593          	addi	a1,a1,-88 # 5e18 <l_free+0x3d2>
    3e78:	fcc42503          	lw	a0,-52(s0)
    3e7c:	00001097          	auipc	ra,0x1
    3e80:	650080e7          	jalr	1616(ra) # 54cc <write>
    3e84:	4785                	li	a5,1
    3e86:	02f51763          	bne	a0,a5,3eb4 <preempt+0xda>
    close(pfds[1]);
    3e8a:	fcc42503          	lw	a0,-52(s0)
    3e8e:	00001097          	auipc	ra,0x1
    3e92:	646080e7          	jalr	1606(ra) # 54d4 <close>
    for (;;)
    3e96:	a001                	j	3e96 <preempt+0xbc>
    printf("%s: fork failed\n", s);
    3e98:	85ca                	mv	a1,s2
    3e9a:	00002517          	auipc	a0,0x2
    3e9e:	77650513          	addi	a0,a0,1910 # 6610 <l_free+0xbca>
    3ea2:	00002097          	auipc	ra,0x2
    3ea6:	982080e7          	jalr	-1662(ra) # 5824 <printf>
    exit(1);
    3eaa:	4505                	li	a0,1
    3eac:	00001097          	auipc	ra,0x1
    3eb0:	600080e7          	jalr	1536(ra) # 54ac <exit>
      printf("%s: preempt write error");
    3eb4:	00004517          	auipc	a0,0x4
    3eb8:	95c50513          	addi	a0,a0,-1700 # 7810 <l_free+0x1dca>
    3ebc:	00002097          	auipc	ra,0x2
    3ec0:	968080e7          	jalr	-1688(ra) # 5824 <printf>
    3ec4:	b7d9                	j	3e8a <preempt+0xb0>
  close(pfds[1]);
    3ec6:	fcc42503          	lw	a0,-52(s0)
    3eca:	00001097          	auipc	ra,0x1
    3ece:	60a080e7          	jalr	1546(ra) # 54d4 <close>
  if (read(pfds[0], buf, sizeof(buf)) != 1) {
    3ed2:	660d                	lui	a2,0x3
    3ed4:	00008597          	auipc	a1,0x8
    3ed8:	ae458593          	addi	a1,a1,-1308 # b9b8 <buf>
    3edc:	fc842503          	lw	a0,-56(s0)
    3ee0:	00001097          	auipc	ra,0x1
    3ee4:	5e4080e7          	jalr	1508(ra) # 54c4 <read>
    3ee8:	4785                	li	a5,1
    3eea:	02f50263          	beq	a0,a5,3f0e <preempt+0x134>
    printf("%s: preempt read error");
    3eee:	00004517          	auipc	a0,0x4
    3ef2:	93a50513          	addi	a0,a0,-1734 # 7828 <l_free+0x1de2>
    3ef6:	00002097          	auipc	ra,0x2
    3efa:	92e080e7          	jalr	-1746(ra) # 5824 <printf>
}
    3efe:	70e2                	ld	ra,56(sp)
    3f00:	7442                	ld	s0,48(sp)
    3f02:	74a2                	ld	s1,40(sp)
    3f04:	7902                	ld	s2,32(sp)
    3f06:	69e2                	ld	s3,24(sp)
    3f08:	6a42                	ld	s4,16(sp)
    3f0a:	6121                	addi	sp,sp,64
    3f0c:	8082                	ret
  close(pfds[0]);
    3f0e:	fc842503          	lw	a0,-56(s0)
    3f12:	00001097          	auipc	ra,0x1
    3f16:	5c2080e7          	jalr	1474(ra) # 54d4 <close>
  printf("kill... ");
    3f1a:	00004517          	auipc	a0,0x4
    3f1e:	92650513          	addi	a0,a0,-1754 # 7840 <l_free+0x1dfa>
    3f22:	00002097          	auipc	ra,0x2
    3f26:	902080e7          	jalr	-1790(ra) # 5824 <printf>
  kill(pid1);
    3f2a:	8526                	mv	a0,s1
    3f2c:	00001097          	auipc	ra,0x1
    3f30:	5b0080e7          	jalr	1456(ra) # 54dc <kill>
  kill(pid2);
    3f34:	854e                	mv	a0,s3
    3f36:	00001097          	auipc	ra,0x1
    3f3a:	5a6080e7          	jalr	1446(ra) # 54dc <kill>
  kill(pid3);
    3f3e:	8552                	mv	a0,s4
    3f40:	00001097          	auipc	ra,0x1
    3f44:	59c080e7          	jalr	1436(ra) # 54dc <kill>
  printf("wait... ");
    3f48:	00004517          	auipc	a0,0x4
    3f4c:	90850513          	addi	a0,a0,-1784 # 7850 <l_free+0x1e0a>
    3f50:	00002097          	auipc	ra,0x2
    3f54:	8d4080e7          	jalr	-1836(ra) # 5824 <printf>
  wait(0);
    3f58:	4501                	li	a0,0
    3f5a:	00001097          	auipc	ra,0x1
    3f5e:	55a080e7          	jalr	1370(ra) # 54b4 <wait>
  wait(0);
    3f62:	4501                	li	a0,0
    3f64:	00001097          	auipc	ra,0x1
    3f68:	550080e7          	jalr	1360(ra) # 54b4 <wait>
  wait(0);
    3f6c:	4501                	li	a0,0
    3f6e:	00001097          	auipc	ra,0x1
    3f72:	546080e7          	jalr	1350(ra) # 54b4 <wait>
    3f76:	b761                	j	3efe <preempt+0x124>

0000000000003f78 <sbrkfail>:
void sbrkfail(char *s) {
    3f78:	7119                	addi	sp,sp,-128
    3f7a:	fc86                	sd	ra,120(sp)
    3f7c:	f8a2                	sd	s0,112(sp)
    3f7e:	f4a6                	sd	s1,104(sp)
    3f80:	f0ca                	sd	s2,96(sp)
    3f82:	ecce                	sd	s3,88(sp)
    3f84:	e8d2                	sd	s4,80(sp)
    3f86:	e4d6                	sd	s5,72(sp)
    3f88:	0100                	addi	s0,sp,128
    3f8a:	8aaa                	mv	s5,a0
  if (pipe(fds) != 0) {
    3f8c:	fb040513          	addi	a0,s0,-80
    3f90:	00001097          	auipc	ra,0x1
    3f94:	52c080e7          	jalr	1324(ra) # 54bc <pipe>
    3f98:	e901                	bnez	a0,3fa8 <sbrkfail+0x30>
    3f9a:	f8040493          	addi	s1,s0,-128
    3f9e:	fa840993          	addi	s3,s0,-88
    3fa2:	8926                	mv	s2,s1
    if (pids[i] != -1)
    3fa4:	5a7d                	li	s4,-1
    3fa6:	a085                	j	4006 <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    3fa8:	85d6                	mv	a1,s5
    3faa:	00002517          	auipc	a0,0x2
    3fae:	76e50513          	addi	a0,a0,1902 # 6718 <l_free+0xcd2>
    3fb2:	00002097          	auipc	ra,0x2
    3fb6:	872080e7          	jalr	-1934(ra) # 5824 <printf>
    exit(1);
    3fba:	4505                	li	a0,1
    3fbc:	00001097          	auipc	ra,0x1
    3fc0:	4f0080e7          	jalr	1264(ra) # 54ac <exit>
      sbrk(BIG - (uint64)sbrk(0));
    3fc4:	00001097          	auipc	ra,0x1
    3fc8:	570080e7          	jalr	1392(ra) # 5534 <sbrk>
    3fcc:	064007b7          	lui	a5,0x6400
    3fd0:	40a7853b          	subw	a0,a5,a0
    3fd4:	00001097          	auipc	ra,0x1
    3fd8:	560080e7          	jalr	1376(ra) # 5534 <sbrk>
      write(fds[1], "x", 1);
    3fdc:	4605                	li	a2,1
    3fde:	00002597          	auipc	a1,0x2
    3fe2:	e3a58593          	addi	a1,a1,-454 # 5e18 <l_free+0x3d2>
    3fe6:	fb442503          	lw	a0,-76(s0)
    3fea:	00001097          	auipc	ra,0x1
    3fee:	4e2080e7          	jalr	1250(ra) # 54cc <write>
        sleep(1000);
    3ff2:	3e800513          	li	a0,1000
    3ff6:	00001097          	auipc	ra,0x1
    3ffa:	546080e7          	jalr	1350(ra) # 553c <sleep>
      for (;;)
    3ffe:	bfd5                	j	3ff2 <sbrkfail+0x7a>
  for (i = 0; i < sizeof(pids) / sizeof(pids[0]); i++) {
    4000:	0911                	addi	s2,s2,4
    4002:	03390563          	beq	s2,s3,402c <sbrkfail+0xb4>
    if ((pids[i] = fork()) == 0) {
    4006:	00001097          	auipc	ra,0x1
    400a:	49e080e7          	jalr	1182(ra) # 54a4 <fork>
    400e:	00a92023          	sw	a0,0(s2)
    4012:	d94d                	beqz	a0,3fc4 <sbrkfail+0x4c>
    if (pids[i] != -1)
    4014:	ff4506e3          	beq	a0,s4,4000 <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    4018:	4605                	li	a2,1
    401a:	faf40593          	addi	a1,s0,-81
    401e:	fb042503          	lw	a0,-80(s0)
    4022:	00001097          	auipc	ra,0x1
    4026:	4a2080e7          	jalr	1186(ra) # 54c4 <read>
    402a:	bfd9                	j	4000 <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    402c:	6505                	lui	a0,0x1
    402e:	00001097          	auipc	ra,0x1
    4032:	506080e7          	jalr	1286(ra) # 5534 <sbrk>
    4036:	8a2a                	mv	s4,a0
    if (pids[i] == -1)
    4038:	597d                	li	s2,-1
    403a:	a021                	j	4042 <sbrkfail+0xca>
  for (i = 0; i < sizeof(pids) / sizeof(pids[0]); i++) {
    403c:	0491                	addi	s1,s1,4
    403e:	01348f63          	beq	s1,s3,405c <sbrkfail+0xe4>
    if (pids[i] == -1)
    4042:	4088                	lw	a0,0(s1)
    4044:	ff250ce3          	beq	a0,s2,403c <sbrkfail+0xc4>
    kill(pids[i]);
    4048:	00001097          	auipc	ra,0x1
    404c:	494080e7          	jalr	1172(ra) # 54dc <kill>
    wait(0);
    4050:	4501                	li	a0,0
    4052:	00001097          	auipc	ra,0x1
    4056:	462080e7          	jalr	1122(ra) # 54b4 <wait>
    405a:	b7cd                	j	403c <sbrkfail+0xc4>
  if (c == (char *)0xffffffffffffffffL) {
    405c:	57fd                	li	a5,-1
    405e:	04fa0163          	beq	s4,a5,40a0 <sbrkfail+0x128>
  pid = fork();
    4062:	00001097          	auipc	ra,0x1
    4066:	442080e7          	jalr	1090(ra) # 54a4 <fork>
    406a:	84aa                	mv	s1,a0
  if (pid < 0) {
    406c:	04054863          	bltz	a0,40bc <sbrkfail+0x144>
  if (pid == 0) {
    4070:	c525                	beqz	a0,40d8 <sbrkfail+0x160>
  wait(&xstatus);
    4072:	fbc40513          	addi	a0,s0,-68
    4076:	00001097          	auipc	ra,0x1
    407a:	43e080e7          	jalr	1086(ra) # 54b4 <wait>
  if (xstatus != -1 && xstatus != 2)
    407e:	fbc42783          	lw	a5,-68(s0)
    4082:	577d                	li	a4,-1
    4084:	00e78563          	beq	a5,a4,408e <sbrkfail+0x116>
    4088:	4709                	li	a4,2
    408a:	08e79c63          	bne	a5,a4,4122 <sbrkfail+0x1aa>
}
    408e:	70e6                	ld	ra,120(sp)
    4090:	7446                	ld	s0,112(sp)
    4092:	74a6                	ld	s1,104(sp)
    4094:	7906                	ld	s2,96(sp)
    4096:	69e6                	ld	s3,88(sp)
    4098:	6a46                	ld	s4,80(sp)
    409a:	6aa6                	ld	s5,72(sp)
    409c:	6109                	addi	sp,sp,128
    409e:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    40a0:	85d6                	mv	a1,s5
    40a2:	00003517          	auipc	a0,0x3
    40a6:	7be50513          	addi	a0,a0,1982 # 7860 <l_free+0x1e1a>
    40aa:	00001097          	auipc	ra,0x1
    40ae:	77a080e7          	jalr	1914(ra) # 5824 <printf>
    exit(1);
    40b2:	4505                	li	a0,1
    40b4:	00001097          	auipc	ra,0x1
    40b8:	3f8080e7          	jalr	1016(ra) # 54ac <exit>
    printf("%s: fork failed\n", s);
    40bc:	85d6                	mv	a1,s5
    40be:	00002517          	auipc	a0,0x2
    40c2:	55250513          	addi	a0,a0,1362 # 6610 <l_free+0xbca>
    40c6:	00001097          	auipc	ra,0x1
    40ca:	75e080e7          	jalr	1886(ra) # 5824 <printf>
    exit(1);
    40ce:	4505                	li	a0,1
    40d0:	00001097          	auipc	ra,0x1
    40d4:	3dc080e7          	jalr	988(ra) # 54ac <exit>
    a = sbrk(0);
    40d8:	4501                	li	a0,0
    40da:	00001097          	auipc	ra,0x1
    40de:	45a080e7          	jalr	1114(ra) # 5534 <sbrk>
    40e2:	892a                	mv	s2,a0
    sbrk(10 * BIG);
    40e4:	3e800537          	lui	a0,0x3e800
    40e8:	00001097          	auipc	ra,0x1
    40ec:	44c080e7          	jalr	1100(ra) # 5534 <sbrk>
    for (i = 0; i < 10 * BIG; i += PGSIZE) {
    40f0:	87ca                	mv	a5,s2
    40f2:	3e800737          	lui	a4,0x3e800
    40f6:	993a                	add	s2,s2,a4
    40f8:	6705                	lui	a4,0x1
      n += *(a + i);
    40fa:	0007c683          	lbu	a3,0(a5) # 6400000 <__BSS_END__+0x63f1638>
    40fe:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10 * BIG; i += PGSIZE) {
    4100:	97ba                	add	a5,a5,a4
    4102:	ff279ce3          	bne	a5,s2,40fa <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", n);
    4106:	85a6                	mv	a1,s1
    4108:	00003517          	auipc	a0,0x3
    410c:	77850513          	addi	a0,a0,1912 # 7880 <l_free+0x1e3a>
    4110:	00001097          	auipc	ra,0x1
    4114:	714080e7          	jalr	1812(ra) # 5824 <printf>
    exit(1);
    4118:	4505                	li	a0,1
    411a:	00001097          	auipc	ra,0x1
    411e:	392080e7          	jalr	914(ra) # 54ac <exit>
    exit(1);
    4122:	4505                	li	a0,1
    4124:	00001097          	auipc	ra,0x1
    4128:	388080e7          	jalr	904(ra) # 54ac <exit>

000000000000412c <reparent>:
void reparent(char *s) {
    412c:	7179                	addi	sp,sp,-48
    412e:	f406                	sd	ra,40(sp)
    4130:	f022                	sd	s0,32(sp)
    4132:	ec26                	sd	s1,24(sp)
    4134:	e84a                	sd	s2,16(sp)
    4136:	e44e                	sd	s3,8(sp)
    4138:	e052                	sd	s4,0(sp)
    413a:	1800                	addi	s0,sp,48
    413c:	89aa                	mv	s3,a0
  int master_pid = getpid();
    413e:	00001097          	auipc	ra,0x1
    4142:	3ee080e7          	jalr	1006(ra) # 552c <getpid>
    4146:	8a2a                	mv	s4,a0
    4148:	0c800913          	li	s2,200
    int pid = fork();
    414c:	00001097          	auipc	ra,0x1
    4150:	358080e7          	jalr	856(ra) # 54a4 <fork>
    4154:	84aa                	mv	s1,a0
    if (pid < 0) {
    4156:	02054263          	bltz	a0,417a <reparent+0x4e>
    if (pid) {
    415a:	cd21                	beqz	a0,41b2 <reparent+0x86>
      if (wait(0) != pid) {
    415c:	4501                	li	a0,0
    415e:	00001097          	auipc	ra,0x1
    4162:	356080e7          	jalr	854(ra) # 54b4 <wait>
    4166:	02951863          	bne	a0,s1,4196 <reparent+0x6a>
  for (int i = 0; i < 200; i++) {
    416a:	397d                	addiw	s2,s2,-1
    416c:	fe0910e3          	bnez	s2,414c <reparent+0x20>
  exit(0);
    4170:	4501                	li	a0,0
    4172:	00001097          	auipc	ra,0x1
    4176:	33a080e7          	jalr	826(ra) # 54ac <exit>
      printf("%s: fork failed\n", s);
    417a:	85ce                	mv	a1,s3
    417c:	00002517          	auipc	a0,0x2
    4180:	49450513          	addi	a0,a0,1172 # 6610 <l_free+0xbca>
    4184:	00001097          	auipc	ra,0x1
    4188:	6a0080e7          	jalr	1696(ra) # 5824 <printf>
      exit(1);
    418c:	4505                	li	a0,1
    418e:	00001097          	auipc	ra,0x1
    4192:	31e080e7          	jalr	798(ra) # 54ac <exit>
        printf("%s: wait wrong pid\n", s);
    4196:	85ce                	mv	a1,s3
    4198:	00002517          	auipc	a0,0x2
    419c:	60050513          	addi	a0,a0,1536 # 6798 <l_free+0xd52>
    41a0:	00001097          	auipc	ra,0x1
    41a4:	684080e7          	jalr	1668(ra) # 5824 <printf>
        exit(1);
    41a8:	4505                	li	a0,1
    41aa:	00001097          	auipc	ra,0x1
    41ae:	302080e7          	jalr	770(ra) # 54ac <exit>
      int pid2 = fork();
    41b2:	00001097          	auipc	ra,0x1
    41b6:	2f2080e7          	jalr	754(ra) # 54a4 <fork>
      if (pid2 < 0) {
    41ba:	00054763          	bltz	a0,41c8 <reparent+0x9c>
      exit(0);
    41be:	4501                	li	a0,0
    41c0:	00001097          	auipc	ra,0x1
    41c4:	2ec080e7          	jalr	748(ra) # 54ac <exit>
        kill(master_pid);
    41c8:	8552                	mv	a0,s4
    41ca:	00001097          	auipc	ra,0x1
    41ce:	312080e7          	jalr	786(ra) # 54dc <kill>
        exit(1);
    41d2:	4505                	li	a0,1
    41d4:	00001097          	auipc	ra,0x1
    41d8:	2d8080e7          	jalr	728(ra) # 54ac <exit>

00000000000041dc <mem>:
void mem(char *s) {
    41dc:	7139                	addi	sp,sp,-64
    41de:	fc06                	sd	ra,56(sp)
    41e0:	f822                	sd	s0,48(sp)
    41e2:	f426                	sd	s1,40(sp)
    41e4:	f04a                	sd	s2,32(sp)
    41e6:	ec4e                	sd	s3,24(sp)
    41e8:	0080                	addi	s0,sp,64
    41ea:	89aa                	mv	s3,a0
  if ((pid = fork()) == 0) {
    41ec:	00001097          	auipc	ra,0x1
    41f0:	2b8080e7          	jalr	696(ra) # 54a4 <fork>
    m1 = 0;
    41f4:	4481                	li	s1,0
    while ((m2 = malloc(10001)) != 0) {
    41f6:	6909                	lui	s2,0x2
    41f8:	71190913          	addi	s2,s2,1809 # 2711 <sbrkmuch+0x18f>
  if ((pid = fork()) == 0) {
    41fc:	c115                	beqz	a0,4220 <mem+0x44>
    wait(&xstatus);
    41fe:	fcc40513          	addi	a0,s0,-52
    4202:	00001097          	auipc	ra,0x1
    4206:	2b2080e7          	jalr	690(ra) # 54b4 <wait>
    if (xstatus == -1) {
    420a:	fcc42503          	lw	a0,-52(s0)
    420e:	57fd                	li	a5,-1
    4210:	06f50363          	beq	a0,a5,4276 <mem+0x9a>
    exit(xstatus);
    4214:	00001097          	auipc	ra,0x1
    4218:	298080e7          	jalr	664(ra) # 54ac <exit>
      *(char **)m2 = m1;
    421c:	e104                	sd	s1,0(a0)
      m1 = m2;
    421e:	84aa                	mv	s1,a0
    while ((m2 = malloc(10001)) != 0) {
    4220:	854a                	mv	a0,s2
    4222:	00001097          	auipc	ra,0x1
    4226:	6c0080e7          	jalr	1728(ra) # 58e2 <malloc>
    422a:	f96d                	bnez	a0,421c <mem+0x40>
    while (m1) {
    422c:	c881                	beqz	s1,423c <mem+0x60>
      m2 = *(char **)m1;
    422e:	8526                	mv	a0,s1
    4230:	6084                	ld	s1,0(s1)
      free(m1);
    4232:	00001097          	auipc	ra,0x1
    4236:	628080e7          	jalr	1576(ra) # 585a <free>
    while (m1) {
    423a:	f8f5                	bnez	s1,422e <mem+0x52>
    m1 = malloc(1024 * 20);
    423c:	6515                	lui	a0,0x5
    423e:	00001097          	auipc	ra,0x1
    4242:	6a4080e7          	jalr	1700(ra) # 58e2 <malloc>
    if (m1 == 0) {
    4246:	c911                	beqz	a0,425a <mem+0x7e>
    free(m1);
    4248:	00001097          	auipc	ra,0x1
    424c:	612080e7          	jalr	1554(ra) # 585a <free>
    exit(0);
    4250:	4501                	li	a0,0
    4252:	00001097          	auipc	ra,0x1
    4256:	25a080e7          	jalr	602(ra) # 54ac <exit>
      printf("couldn't allocate mem?!!\n", s);
    425a:	85ce                	mv	a1,s3
    425c:	00003517          	auipc	a0,0x3
    4260:	65450513          	addi	a0,a0,1620 # 78b0 <l_free+0x1e6a>
    4264:	00001097          	auipc	ra,0x1
    4268:	5c0080e7          	jalr	1472(ra) # 5824 <printf>
      exit(1);
    426c:	4505                	li	a0,1
    426e:	00001097          	auipc	ra,0x1
    4272:	23e080e7          	jalr	574(ra) # 54ac <exit>
      exit(0);
    4276:	4501                	li	a0,0
    4278:	00001097          	auipc	ra,0x1
    427c:	234080e7          	jalr	564(ra) # 54ac <exit>

0000000000004280 <sharedfd>:
void sharedfd(char *s) {
    4280:	7159                	addi	sp,sp,-112
    4282:	f486                	sd	ra,104(sp)
    4284:	f0a2                	sd	s0,96(sp)
    4286:	eca6                	sd	s1,88(sp)
    4288:	e8ca                	sd	s2,80(sp)
    428a:	e4ce                	sd	s3,72(sp)
    428c:	e0d2                	sd	s4,64(sp)
    428e:	fc56                	sd	s5,56(sp)
    4290:	f85a                	sd	s6,48(sp)
    4292:	f45e                	sd	s7,40(sp)
    4294:	1880                	addi	s0,sp,112
    4296:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4298:	00002517          	auipc	a0,0x2
    429c:	95850513          	addi	a0,a0,-1704 # 5bf0 <l_free+0x1aa>
    42a0:	00001097          	auipc	ra,0x1
    42a4:	25c080e7          	jalr	604(ra) # 54fc <unlink>
  fd = open("sharedfd", O_CREATE | O_RDWR);
    42a8:	20200593          	li	a1,514
    42ac:	00002517          	auipc	a0,0x2
    42b0:	94450513          	addi	a0,a0,-1724 # 5bf0 <l_free+0x1aa>
    42b4:	00001097          	auipc	ra,0x1
    42b8:	238080e7          	jalr	568(ra) # 54ec <open>
  if (fd < 0) {
    42bc:	04054a63          	bltz	a0,4310 <sharedfd+0x90>
    42c0:	892a                	mv	s2,a0
  pid = fork();
    42c2:	00001097          	auipc	ra,0x1
    42c6:	1e2080e7          	jalr	482(ra) # 54a4 <fork>
    42ca:	89aa                	mv	s3,a0
  memset(buf, pid == 0 ? 'c' : 'p', sizeof(buf));
    42cc:	06300593          	li	a1,99
    42d0:	c119                	beqz	a0,42d6 <sharedfd+0x56>
    42d2:	07000593          	li	a1,112
    42d6:	4629                	li	a2,10
    42d8:	fa040513          	addi	a0,s0,-96
    42dc:	00001097          	auipc	ra,0x1
    42e0:	fd4080e7          	jalr	-44(ra) # 52b0 <memset>
    42e4:	3e800493          	li	s1,1000
    if (write(fd, buf, sizeof(buf)) != sizeof(buf)) {
    42e8:	4629                	li	a2,10
    42ea:	fa040593          	addi	a1,s0,-96
    42ee:	854a                	mv	a0,s2
    42f0:	00001097          	auipc	ra,0x1
    42f4:	1dc080e7          	jalr	476(ra) # 54cc <write>
    42f8:	47a9                	li	a5,10
    42fa:	02f51963          	bne	a0,a5,432c <sharedfd+0xac>
  for (i = 0; i < N; i++) {
    42fe:	34fd                	addiw	s1,s1,-1
    4300:	f4e5                	bnez	s1,42e8 <sharedfd+0x68>
  if (pid == 0) {
    4302:	04099363          	bnez	s3,4348 <sharedfd+0xc8>
    exit(0);
    4306:	4501                	li	a0,0
    4308:	00001097          	auipc	ra,0x1
    430c:	1a4080e7          	jalr	420(ra) # 54ac <exit>
    printf("%s: cannot open sharedfd for writing", s);
    4310:	85d2                	mv	a1,s4
    4312:	00003517          	auipc	a0,0x3
    4316:	5be50513          	addi	a0,a0,1470 # 78d0 <l_free+0x1e8a>
    431a:	00001097          	auipc	ra,0x1
    431e:	50a080e7          	jalr	1290(ra) # 5824 <printf>
    exit(1);
    4322:	4505                	li	a0,1
    4324:	00001097          	auipc	ra,0x1
    4328:	188080e7          	jalr	392(ra) # 54ac <exit>
      printf("%s: write sharedfd failed\n", s);
    432c:	85d2                	mv	a1,s4
    432e:	00003517          	auipc	a0,0x3
    4332:	5ca50513          	addi	a0,a0,1482 # 78f8 <l_free+0x1eb2>
    4336:	00001097          	auipc	ra,0x1
    433a:	4ee080e7          	jalr	1262(ra) # 5824 <printf>
      exit(1);
    433e:	4505                	li	a0,1
    4340:	00001097          	auipc	ra,0x1
    4344:	16c080e7          	jalr	364(ra) # 54ac <exit>
    wait(&xstatus);
    4348:	f9c40513          	addi	a0,s0,-100
    434c:	00001097          	auipc	ra,0x1
    4350:	168080e7          	jalr	360(ra) # 54b4 <wait>
    if (xstatus != 0)
    4354:	f9c42983          	lw	s3,-100(s0)
    4358:	00098763          	beqz	s3,4366 <sharedfd+0xe6>
      exit(xstatus);
    435c:	854e                	mv	a0,s3
    435e:	00001097          	auipc	ra,0x1
    4362:	14e080e7          	jalr	334(ra) # 54ac <exit>
  close(fd);
    4366:	854a                	mv	a0,s2
    4368:	00001097          	auipc	ra,0x1
    436c:	16c080e7          	jalr	364(ra) # 54d4 <close>
  fd = open("sharedfd", 0);
    4370:	4581                	li	a1,0
    4372:	00002517          	auipc	a0,0x2
    4376:	87e50513          	addi	a0,a0,-1922 # 5bf0 <l_free+0x1aa>
    437a:	00001097          	auipc	ra,0x1
    437e:	172080e7          	jalr	370(ra) # 54ec <open>
    4382:	8baa                	mv	s7,a0
  nc = np = 0;
    4384:	8ace                	mv	s5,s3
  if (fd < 0) {
    4386:	02054563          	bltz	a0,43b0 <sharedfd+0x130>
    438a:	faa40913          	addi	s2,s0,-86
      if (buf[i] == 'c')
    438e:	06300493          	li	s1,99
      if (buf[i] == 'p')
    4392:	07000b13          	li	s6,112
  while ((n = read(fd, buf, sizeof(buf))) > 0) {
    4396:	4629                	li	a2,10
    4398:	fa040593          	addi	a1,s0,-96
    439c:	855e                	mv	a0,s7
    439e:	00001097          	auipc	ra,0x1
    43a2:	126080e7          	jalr	294(ra) # 54c4 <read>
    43a6:	02a05f63          	blez	a0,43e4 <sharedfd+0x164>
    43aa:	fa040793          	addi	a5,s0,-96
    43ae:	a01d                	j	43d4 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    43b0:	85d2                	mv	a1,s4
    43b2:	00003517          	auipc	a0,0x3
    43b6:	56650513          	addi	a0,a0,1382 # 7918 <l_free+0x1ed2>
    43ba:	00001097          	auipc	ra,0x1
    43be:	46a080e7          	jalr	1130(ra) # 5824 <printf>
    exit(1);
    43c2:	4505                	li	a0,1
    43c4:	00001097          	auipc	ra,0x1
    43c8:	0e8080e7          	jalr	232(ra) # 54ac <exit>
        nc++;
    43cc:	2985                	addiw	s3,s3,1
    for (i = 0; i < sizeof(buf); i++) {
    43ce:	0785                	addi	a5,a5,1
    43d0:	fd2783e3          	beq	a5,s2,4396 <sharedfd+0x116>
      if (buf[i] == 'c')
    43d4:	0007c703          	lbu	a4,0(a5)
    43d8:	fe970ae3          	beq	a4,s1,43cc <sharedfd+0x14c>
      if (buf[i] == 'p')
    43dc:	ff6719e3          	bne	a4,s6,43ce <sharedfd+0x14e>
        np++;
    43e0:	2a85                	addiw	s5,s5,1
    43e2:	b7f5                	j	43ce <sharedfd+0x14e>
  close(fd);
    43e4:	855e                	mv	a0,s7
    43e6:	00001097          	auipc	ra,0x1
    43ea:	0ee080e7          	jalr	238(ra) # 54d4 <close>
  unlink("sharedfd");
    43ee:	00002517          	auipc	a0,0x2
    43f2:	80250513          	addi	a0,a0,-2046 # 5bf0 <l_free+0x1aa>
    43f6:	00001097          	auipc	ra,0x1
    43fa:	106080e7          	jalr	262(ra) # 54fc <unlink>
  if (nc == N * SZ && np == N * SZ) {
    43fe:	6789                	lui	a5,0x2
    4400:	71078793          	addi	a5,a5,1808 # 2710 <sbrkmuch+0x18e>
    4404:	00f99763          	bne	s3,a5,4412 <sharedfd+0x192>
    4408:	6789                	lui	a5,0x2
    440a:	71078793          	addi	a5,a5,1808 # 2710 <sbrkmuch+0x18e>
    440e:	02fa8063          	beq	s5,a5,442e <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    4412:	85d2                	mv	a1,s4
    4414:	00003517          	auipc	a0,0x3
    4418:	52c50513          	addi	a0,a0,1324 # 7940 <l_free+0x1efa>
    441c:	00001097          	auipc	ra,0x1
    4420:	408080e7          	jalr	1032(ra) # 5824 <printf>
    exit(1);
    4424:	4505                	li	a0,1
    4426:	00001097          	auipc	ra,0x1
    442a:	086080e7          	jalr	134(ra) # 54ac <exit>
    exit(0);
    442e:	4501                	li	a0,0
    4430:	00001097          	auipc	ra,0x1
    4434:	07c080e7          	jalr	124(ra) # 54ac <exit>

0000000000004438 <fourfiles>:
void fourfiles(char *s) {
    4438:	7171                	addi	sp,sp,-176
    443a:	f506                	sd	ra,168(sp)
    443c:	f122                	sd	s0,160(sp)
    443e:	ed26                	sd	s1,152(sp)
    4440:	e94a                	sd	s2,144(sp)
    4442:	e54e                	sd	s3,136(sp)
    4444:	e152                	sd	s4,128(sp)
    4446:	fcd6                	sd	s5,120(sp)
    4448:	f8da                	sd	s6,112(sp)
    444a:	f4de                	sd	s7,104(sp)
    444c:	f0e2                	sd	s8,96(sp)
    444e:	ece6                	sd	s9,88(sp)
    4450:	e8ea                	sd	s10,80(sp)
    4452:	e4ee                	sd	s11,72(sp)
    4454:	1900                	addi	s0,sp,176
    4456:	f4a43c23          	sd	a0,-168(s0)
  char *names[] = {"f0", "f1", "f2", "f3"};
    445a:	00001797          	auipc	a5,0x1
    445e:	5fe78793          	addi	a5,a5,1534 # 5a58 <l_free+0x12>
    4462:	f6f43823          	sd	a5,-144(s0)
    4466:	00001797          	auipc	a5,0x1
    446a:	5fa78793          	addi	a5,a5,1530 # 5a60 <l_free+0x1a>
    446e:	f6f43c23          	sd	a5,-136(s0)
    4472:	00001797          	auipc	a5,0x1
    4476:	5f678793          	addi	a5,a5,1526 # 5a68 <l_free+0x22>
    447a:	f8f43023          	sd	a5,-128(s0)
    447e:	00001797          	auipc	a5,0x1
    4482:	5f278793          	addi	a5,a5,1522 # 5a70 <l_free+0x2a>
    4486:	f8f43423          	sd	a5,-120(s0)
  for (pi = 0; pi < NCHILD; pi++) {
    448a:	f7040c13          	addi	s8,s0,-144
  char *names[] = {"f0", "f1", "f2", "f3"};
    448e:	8962                	mv	s2,s8
  for (pi = 0; pi < NCHILD; pi++) {
    4490:	4481                	li	s1,0
    4492:	4a11                	li	s4,4
    fname = names[pi];
    4494:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4498:	854e                	mv	a0,s3
    449a:	00001097          	auipc	ra,0x1
    449e:	062080e7          	jalr	98(ra) # 54fc <unlink>
    pid = fork();
    44a2:	00001097          	auipc	ra,0x1
    44a6:	002080e7          	jalr	2(ra) # 54a4 <fork>
    if (pid < 0) {
    44aa:	04054463          	bltz	a0,44f2 <fourfiles+0xba>
    if (pid == 0) {
    44ae:	c12d                	beqz	a0,4510 <fourfiles+0xd8>
  for (pi = 0; pi < NCHILD; pi++) {
    44b0:	2485                	addiw	s1,s1,1
    44b2:	0921                	addi	s2,s2,8
    44b4:	ff4490e3          	bne	s1,s4,4494 <fourfiles+0x5c>
    44b8:	4491                	li	s1,4
    wait(&xstatus);
    44ba:	f6c40513          	addi	a0,s0,-148
    44be:	00001097          	auipc	ra,0x1
    44c2:	ff6080e7          	jalr	-10(ra) # 54b4 <wait>
    if (xstatus != 0)
    44c6:	f6c42b03          	lw	s6,-148(s0)
    44ca:	0c0b1e63          	bnez	s6,45a6 <fourfiles+0x16e>
  for (pi = 0; pi < NCHILD; pi++) {
    44ce:	34fd                	addiw	s1,s1,-1
    44d0:	f4ed                	bnez	s1,44ba <fourfiles+0x82>
    44d2:	03000b93          	li	s7,48
    while ((n = read(fd, buf, sizeof(buf))) > 0) {
    44d6:	00007a17          	auipc	s4,0x7
    44da:	4e2a0a13          	addi	s4,s4,1250 # b9b8 <buf>
    44de:	00007a97          	auipc	s5,0x7
    44e2:	4dba8a93          	addi	s5,s5,1243 # b9b9 <buf+0x1>
    if (total != N * SZ) {
    44e6:	6d85                	lui	s11,0x1
    44e8:	770d8d93          	addi	s11,s11,1904 # 1770 <exectest+0xf6>
  for (i = 0; i < NCHILD; i++) {
    44ec:	03400d13          	li	s10,52
    44f0:	aa1d                	j	4626 <fourfiles+0x1ee>
      printf("fork failed\n", s);
    44f2:	f5843583          	ld	a1,-168(s0)
    44f6:	00002517          	auipc	a0,0x2
    44fa:	50a50513          	addi	a0,a0,1290 # 6a00 <l_free+0xfba>
    44fe:	00001097          	auipc	ra,0x1
    4502:	326080e7          	jalr	806(ra) # 5824 <printf>
      exit(1);
    4506:	4505                	li	a0,1
    4508:	00001097          	auipc	ra,0x1
    450c:	fa4080e7          	jalr	-92(ra) # 54ac <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4510:	20200593          	li	a1,514
    4514:	854e                	mv	a0,s3
    4516:	00001097          	auipc	ra,0x1
    451a:	fd6080e7          	jalr	-42(ra) # 54ec <open>
    451e:	892a                	mv	s2,a0
      if (fd < 0) {
    4520:	04054763          	bltz	a0,456e <fourfiles+0x136>
      memset(buf, '0' + pi, SZ);
    4524:	1f400613          	li	a2,500
    4528:	0304859b          	addiw	a1,s1,48
    452c:	00007517          	auipc	a0,0x7
    4530:	48c50513          	addi	a0,a0,1164 # b9b8 <buf>
    4534:	00001097          	auipc	ra,0x1
    4538:	d7c080e7          	jalr	-644(ra) # 52b0 <memset>
    453c:	44b1                	li	s1,12
        if ((n = write(fd, buf, SZ)) != SZ) {
    453e:	00007997          	auipc	s3,0x7
    4542:	47a98993          	addi	s3,s3,1146 # b9b8 <buf>
    4546:	1f400613          	li	a2,500
    454a:	85ce                	mv	a1,s3
    454c:	854a                	mv	a0,s2
    454e:	00001097          	auipc	ra,0x1
    4552:	f7e080e7          	jalr	-130(ra) # 54cc <write>
    4556:	85aa                	mv	a1,a0
    4558:	1f400793          	li	a5,500
    455c:	02f51863          	bne	a0,a5,458c <fourfiles+0x154>
      for (i = 0; i < N; i++) {
    4560:	34fd                	addiw	s1,s1,-1
    4562:	f0f5                	bnez	s1,4546 <fourfiles+0x10e>
      exit(0);
    4564:	4501                	li	a0,0
    4566:	00001097          	auipc	ra,0x1
    456a:	f46080e7          	jalr	-186(ra) # 54ac <exit>
        printf("create failed\n", s);
    456e:	f5843583          	ld	a1,-168(s0)
    4572:	00003517          	auipc	a0,0x3
    4576:	3e650513          	addi	a0,a0,998 # 7958 <l_free+0x1f12>
    457a:	00001097          	auipc	ra,0x1
    457e:	2aa080e7          	jalr	682(ra) # 5824 <printf>
        exit(1);
    4582:	4505                	li	a0,1
    4584:	00001097          	auipc	ra,0x1
    4588:	f28080e7          	jalr	-216(ra) # 54ac <exit>
          printf("write failed %d\n", n);
    458c:	00003517          	auipc	a0,0x3
    4590:	3dc50513          	addi	a0,a0,988 # 7968 <l_free+0x1f22>
    4594:	00001097          	auipc	ra,0x1
    4598:	290080e7          	jalr	656(ra) # 5824 <printf>
          exit(1);
    459c:	4505                	li	a0,1
    459e:	00001097          	auipc	ra,0x1
    45a2:	f0e080e7          	jalr	-242(ra) # 54ac <exit>
      exit(xstatus);
    45a6:	855a                	mv	a0,s6
    45a8:	00001097          	auipc	ra,0x1
    45ac:	f04080e7          	jalr	-252(ra) # 54ac <exit>
          printf("wrong char\n", s);
    45b0:	f5843583          	ld	a1,-168(s0)
    45b4:	00003517          	auipc	a0,0x3
    45b8:	3cc50513          	addi	a0,a0,972 # 7980 <l_free+0x1f3a>
    45bc:	00001097          	auipc	ra,0x1
    45c0:	268080e7          	jalr	616(ra) # 5824 <printf>
          exit(1);
    45c4:	4505                	li	a0,1
    45c6:	00001097          	auipc	ra,0x1
    45ca:	ee6080e7          	jalr	-282(ra) # 54ac <exit>
      total += n;
    45ce:	00a9093b          	addw	s2,s2,a0
    while ((n = read(fd, buf, sizeof(buf))) > 0) {
    45d2:	660d                	lui	a2,0x3
    45d4:	85d2                	mv	a1,s4
    45d6:	854e                	mv	a0,s3
    45d8:	00001097          	auipc	ra,0x1
    45dc:	eec080e7          	jalr	-276(ra) # 54c4 <read>
    45e0:	02a05363          	blez	a0,4606 <fourfiles+0x1ce>
    45e4:	00007797          	auipc	a5,0x7
    45e8:	3d478793          	addi	a5,a5,980 # b9b8 <buf>
    45ec:	fff5069b          	addiw	a3,a0,-1
    45f0:	1682                	slli	a3,a3,0x20
    45f2:	9281                	srli	a3,a3,0x20
    45f4:	96d6                	add	a3,a3,s5
        if (buf[j] != '0' + i) {
    45f6:	0007c703          	lbu	a4,0(a5)
    45fa:	fa971be3          	bne	a4,s1,45b0 <fourfiles+0x178>
      for (j = 0; j < n; j++) {
    45fe:	0785                	addi	a5,a5,1
    4600:	fed79be3          	bne	a5,a3,45f6 <fourfiles+0x1be>
    4604:	b7e9                	j	45ce <fourfiles+0x196>
    close(fd);
    4606:	854e                	mv	a0,s3
    4608:	00001097          	auipc	ra,0x1
    460c:	ecc080e7          	jalr	-308(ra) # 54d4 <close>
    if (total != N * SZ) {
    4610:	03b91863          	bne	s2,s11,4640 <fourfiles+0x208>
    unlink(fname);
    4614:	8566                	mv	a0,s9
    4616:	00001097          	auipc	ra,0x1
    461a:	ee6080e7          	jalr	-282(ra) # 54fc <unlink>
  for (i = 0; i < NCHILD; i++) {
    461e:	0c21                	addi	s8,s8,8
    4620:	2b85                	addiw	s7,s7,1
    4622:	03ab8d63          	beq	s7,s10,465c <fourfiles+0x224>
    fname = names[i];
    4626:	000c3c83          	ld	s9,0(s8)
    fd = open(fname, 0);
    462a:	4581                	li	a1,0
    462c:	8566                	mv	a0,s9
    462e:	00001097          	auipc	ra,0x1
    4632:	ebe080e7          	jalr	-322(ra) # 54ec <open>
    4636:	89aa                	mv	s3,a0
    total = 0;
    4638:	895a                	mv	s2,s6
        if (buf[j] != '0' + i) {
    463a:	000b849b          	sext.w	s1,s7
    while ((n = read(fd, buf, sizeof(buf))) > 0) {
    463e:	bf51                	j	45d2 <fourfiles+0x19a>
      printf("wrong length %d\n", total);
    4640:	85ca                	mv	a1,s2
    4642:	00003517          	auipc	a0,0x3
    4646:	34e50513          	addi	a0,a0,846 # 7990 <l_free+0x1f4a>
    464a:	00001097          	auipc	ra,0x1
    464e:	1da080e7          	jalr	474(ra) # 5824 <printf>
      exit(1);
    4652:	4505                	li	a0,1
    4654:	00001097          	auipc	ra,0x1
    4658:	e58080e7          	jalr	-424(ra) # 54ac <exit>
}
    465c:	70aa                	ld	ra,168(sp)
    465e:	740a                	ld	s0,160(sp)
    4660:	64ea                	ld	s1,152(sp)
    4662:	694a                	ld	s2,144(sp)
    4664:	69aa                	ld	s3,136(sp)
    4666:	6a0a                	ld	s4,128(sp)
    4668:	7ae6                	ld	s5,120(sp)
    466a:	7b46                	ld	s6,112(sp)
    466c:	7ba6                	ld	s7,104(sp)
    466e:	7c06                	ld	s8,96(sp)
    4670:	6ce6                	ld	s9,88(sp)
    4672:	6d46                	ld	s10,80(sp)
    4674:	6da6                	ld	s11,72(sp)
    4676:	614d                	addi	sp,sp,176
    4678:	8082                	ret

000000000000467a <concreate>:
void concreate(char *s) {
    467a:	7135                	addi	sp,sp,-160
    467c:	ed06                	sd	ra,152(sp)
    467e:	e922                	sd	s0,144(sp)
    4680:	e526                	sd	s1,136(sp)
    4682:	e14a                	sd	s2,128(sp)
    4684:	fcce                	sd	s3,120(sp)
    4686:	f8d2                	sd	s4,112(sp)
    4688:	f4d6                	sd	s5,104(sp)
    468a:	f0da                	sd	s6,96(sp)
    468c:	ecde                	sd	s7,88(sp)
    468e:	1100                	addi	s0,sp,160
    4690:	89aa                	mv	s3,a0
  file[0] = 'C';
    4692:	04300793          	li	a5,67
    4696:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    469a:	fa040523          	sb	zero,-86(s0)
  for (i = 0; i < N; i++) {
    469e:	4901                	li	s2,0
    if (pid && (i % 3) == 1) {
    46a0:	4b0d                	li	s6,3
    46a2:	4a85                	li	s5,1
      link("C0", file);
    46a4:	00003b97          	auipc	s7,0x3
    46a8:	304b8b93          	addi	s7,s7,772 # 79a8 <l_free+0x1f62>
  for (i = 0; i < N; i++) {
    46ac:	02800a13          	li	s4,40
    46b0:	acc1                	j	4980 <concreate+0x306>
      link("C0", file);
    46b2:	fa840593          	addi	a1,s0,-88
    46b6:	855e                	mv	a0,s7
    46b8:	00001097          	auipc	ra,0x1
    46bc:	e54080e7          	jalr	-428(ra) # 550c <link>
    if (pid == 0) {
    46c0:	a45d                	j	4966 <concreate+0x2ec>
    } else if (pid == 0 && (i % 5) == 1) {
    46c2:	4795                	li	a5,5
    46c4:	02f9693b          	remw	s2,s2,a5
    46c8:	4785                	li	a5,1
    46ca:	02f90b63          	beq	s2,a5,4700 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    46ce:	20200593          	li	a1,514
    46d2:	fa840513          	addi	a0,s0,-88
    46d6:	00001097          	auipc	ra,0x1
    46da:	e16080e7          	jalr	-490(ra) # 54ec <open>
      if (fd < 0) {
    46de:	26055b63          	bgez	a0,4954 <concreate+0x2da>
        printf("concreate create %s failed\n", file);
    46e2:	fa840593          	addi	a1,s0,-88
    46e6:	00003517          	auipc	a0,0x3
    46ea:	2ca50513          	addi	a0,a0,714 # 79b0 <l_free+0x1f6a>
    46ee:	00001097          	auipc	ra,0x1
    46f2:	136080e7          	jalr	310(ra) # 5824 <printf>
        exit(1);
    46f6:	4505                	li	a0,1
    46f8:	00001097          	auipc	ra,0x1
    46fc:	db4080e7          	jalr	-588(ra) # 54ac <exit>
      link("C0", file);
    4700:	fa840593          	addi	a1,s0,-88
    4704:	00003517          	auipc	a0,0x3
    4708:	2a450513          	addi	a0,a0,676 # 79a8 <l_free+0x1f62>
    470c:	00001097          	auipc	ra,0x1
    4710:	e00080e7          	jalr	-512(ra) # 550c <link>
      exit(0);
    4714:	4501                	li	a0,0
    4716:	00001097          	auipc	ra,0x1
    471a:	d96080e7          	jalr	-618(ra) # 54ac <exit>
        exit(1);
    471e:	4505                	li	a0,1
    4720:	00001097          	auipc	ra,0x1
    4724:	d8c080e7          	jalr	-628(ra) # 54ac <exit>
  memset(fa, 0, sizeof(fa));
    4728:	02800613          	li	a2,40
    472c:	4581                	li	a1,0
    472e:	f8040513          	addi	a0,s0,-128
    4732:	00001097          	auipc	ra,0x1
    4736:	b7e080e7          	jalr	-1154(ra) # 52b0 <memset>
  fd = open(".", 0);
    473a:	4581                	li	a1,0
    473c:	00002517          	auipc	a0,0x2
    4740:	d3450513          	addi	a0,a0,-716 # 6470 <l_free+0xa2a>
    4744:	00001097          	auipc	ra,0x1
    4748:	da8080e7          	jalr	-600(ra) # 54ec <open>
    474c:	892a                	mv	s2,a0
  n = 0;
    474e:	8aa6                	mv	s5,s1
    if (de.name[0] == 'C' && de.name[2] == '\0') {
    4750:	04300a13          	li	s4,67
      if (i < 0 || i >= sizeof(fa)) {
    4754:	02700b13          	li	s6,39
      fa[i] = 1;
    4758:	4b85                	li	s7,1
  while (read(fd, &de, sizeof(de)) > 0) {
    475a:	4641                	li	a2,16
    475c:	f7040593          	addi	a1,s0,-144
    4760:	854a                	mv	a0,s2
    4762:	00001097          	auipc	ra,0x1
    4766:	d62080e7          	jalr	-670(ra) # 54c4 <read>
    476a:	08a05163          	blez	a0,47ec <concreate+0x172>
    if (de.inum == 0)
    476e:	f7045783          	lhu	a5,-144(s0)
    4772:	d7e5                	beqz	a5,475a <concreate+0xe0>
    if (de.name[0] == 'C' && de.name[2] == '\0') {
    4774:	f7244783          	lbu	a5,-142(s0)
    4778:	ff4791e3          	bne	a5,s4,475a <concreate+0xe0>
    477c:	f7444783          	lbu	a5,-140(s0)
    4780:	ffe9                	bnez	a5,475a <concreate+0xe0>
      i = de.name[1] - '0';
    4782:	f7344783          	lbu	a5,-141(s0)
    4786:	fd07879b          	addiw	a5,a5,-48
    478a:	0007871b          	sext.w	a4,a5
      if (i < 0 || i >= sizeof(fa)) {
    478e:	00eb6f63          	bltu	s6,a4,47ac <concreate+0x132>
      if (fa[i]) {
    4792:	fb040793          	addi	a5,s0,-80
    4796:	97ba                	add	a5,a5,a4
    4798:	fd07c783          	lbu	a5,-48(a5)
    479c:	eb85                	bnez	a5,47cc <concreate+0x152>
      fa[i] = 1;
    479e:	fb040793          	addi	a5,s0,-80
    47a2:	973e                	add	a4,a4,a5
    47a4:	fd770823          	sb	s7,-48(a4) # fd0 <linktest+0x1a2>
      n++;
    47a8:	2a85                	addiw	s5,s5,1
    47aa:	bf45                	j	475a <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    47ac:	f7240613          	addi	a2,s0,-142
    47b0:	85ce                	mv	a1,s3
    47b2:	00003517          	auipc	a0,0x3
    47b6:	21e50513          	addi	a0,a0,542 # 79d0 <l_free+0x1f8a>
    47ba:	00001097          	auipc	ra,0x1
    47be:	06a080e7          	jalr	106(ra) # 5824 <printf>
        exit(1);
    47c2:	4505                	li	a0,1
    47c4:	00001097          	auipc	ra,0x1
    47c8:	ce8080e7          	jalr	-792(ra) # 54ac <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    47cc:	f7240613          	addi	a2,s0,-142
    47d0:	85ce                	mv	a1,s3
    47d2:	00003517          	auipc	a0,0x3
    47d6:	21e50513          	addi	a0,a0,542 # 79f0 <l_free+0x1faa>
    47da:	00001097          	auipc	ra,0x1
    47de:	04a080e7          	jalr	74(ra) # 5824 <printf>
        exit(1);
    47e2:	4505                	li	a0,1
    47e4:	00001097          	auipc	ra,0x1
    47e8:	cc8080e7          	jalr	-824(ra) # 54ac <exit>
  close(fd);
    47ec:	854a                	mv	a0,s2
    47ee:	00001097          	auipc	ra,0x1
    47f2:	ce6080e7          	jalr	-794(ra) # 54d4 <close>
  if (n != N) {
    47f6:	02800793          	li	a5,40
    47fa:	00fa9763          	bne	s5,a5,4808 <concreate+0x18e>
    if (((i % 3) == 0 && pid == 0) || ((i % 3) == 1 && pid != 0)) {
    47fe:	4a8d                	li	s5,3
    4800:	4b05                	li	s6,1
  for (i = 0; i < N; i++) {
    4802:	02800a13          	li	s4,40
    4806:	a8c9                	j	48d8 <concreate+0x25e>
    printf("%s: concreate not enough files in directory listing\n", s);
    4808:	85ce                	mv	a1,s3
    480a:	00003517          	auipc	a0,0x3
    480e:	20e50513          	addi	a0,a0,526 # 7a18 <l_free+0x1fd2>
    4812:	00001097          	auipc	ra,0x1
    4816:	012080e7          	jalr	18(ra) # 5824 <printf>
    exit(1);
    481a:	4505                	li	a0,1
    481c:	00001097          	auipc	ra,0x1
    4820:	c90080e7          	jalr	-880(ra) # 54ac <exit>
      printf("%s: fork failed\n", s);
    4824:	85ce                	mv	a1,s3
    4826:	00002517          	auipc	a0,0x2
    482a:	dea50513          	addi	a0,a0,-534 # 6610 <l_free+0xbca>
    482e:	00001097          	auipc	ra,0x1
    4832:	ff6080e7          	jalr	-10(ra) # 5824 <printf>
      exit(1);
    4836:	4505                	li	a0,1
    4838:	00001097          	auipc	ra,0x1
    483c:	c74080e7          	jalr	-908(ra) # 54ac <exit>
      close(open(file, 0));
    4840:	4581                	li	a1,0
    4842:	fa840513          	addi	a0,s0,-88
    4846:	00001097          	auipc	ra,0x1
    484a:	ca6080e7          	jalr	-858(ra) # 54ec <open>
    484e:	00001097          	auipc	ra,0x1
    4852:	c86080e7          	jalr	-890(ra) # 54d4 <close>
      close(open(file, 0));
    4856:	4581                	li	a1,0
    4858:	fa840513          	addi	a0,s0,-88
    485c:	00001097          	auipc	ra,0x1
    4860:	c90080e7          	jalr	-880(ra) # 54ec <open>
    4864:	00001097          	auipc	ra,0x1
    4868:	c70080e7          	jalr	-912(ra) # 54d4 <close>
      close(open(file, 0));
    486c:	4581                	li	a1,0
    486e:	fa840513          	addi	a0,s0,-88
    4872:	00001097          	auipc	ra,0x1
    4876:	c7a080e7          	jalr	-902(ra) # 54ec <open>
    487a:	00001097          	auipc	ra,0x1
    487e:	c5a080e7          	jalr	-934(ra) # 54d4 <close>
      close(open(file, 0));
    4882:	4581                	li	a1,0
    4884:	fa840513          	addi	a0,s0,-88
    4888:	00001097          	auipc	ra,0x1
    488c:	c64080e7          	jalr	-924(ra) # 54ec <open>
    4890:	00001097          	auipc	ra,0x1
    4894:	c44080e7          	jalr	-956(ra) # 54d4 <close>
      close(open(file, 0));
    4898:	4581                	li	a1,0
    489a:	fa840513          	addi	a0,s0,-88
    489e:	00001097          	auipc	ra,0x1
    48a2:	c4e080e7          	jalr	-946(ra) # 54ec <open>
    48a6:	00001097          	auipc	ra,0x1
    48aa:	c2e080e7          	jalr	-978(ra) # 54d4 <close>
      close(open(file, 0));
    48ae:	4581                	li	a1,0
    48b0:	fa840513          	addi	a0,s0,-88
    48b4:	00001097          	auipc	ra,0x1
    48b8:	c38080e7          	jalr	-968(ra) # 54ec <open>
    48bc:	00001097          	auipc	ra,0x1
    48c0:	c18080e7          	jalr	-1000(ra) # 54d4 <close>
    if (pid == 0)
    48c4:	08090363          	beqz	s2,494a <concreate+0x2d0>
      wait(0);
    48c8:	4501                	li	a0,0
    48ca:	00001097          	auipc	ra,0x1
    48ce:	bea080e7          	jalr	-1046(ra) # 54b4 <wait>
  for (i = 0; i < N; i++) {
    48d2:	2485                	addiw	s1,s1,1
    48d4:	0f448563          	beq	s1,s4,49be <concreate+0x344>
    file[1] = '0' + i;
    48d8:	0304879b          	addiw	a5,s1,48
    48dc:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    48e0:	00001097          	auipc	ra,0x1
    48e4:	bc4080e7          	jalr	-1084(ra) # 54a4 <fork>
    48e8:	892a                	mv	s2,a0
    if (pid < 0) {
    48ea:	f2054de3          	bltz	a0,4824 <concreate+0x1aa>
    if (((i % 3) == 0 && pid == 0) || ((i % 3) == 1 && pid != 0)) {
    48ee:	0354e73b          	remw	a4,s1,s5
    48f2:	00a767b3          	or	a5,a4,a0
    48f6:	2781                	sext.w	a5,a5
    48f8:	d7a1                	beqz	a5,4840 <concreate+0x1c6>
    48fa:	01671363          	bne	a4,s6,4900 <concreate+0x286>
    48fe:	f129                	bnez	a0,4840 <concreate+0x1c6>
      unlink(file);
    4900:	fa840513          	addi	a0,s0,-88
    4904:	00001097          	auipc	ra,0x1
    4908:	bf8080e7          	jalr	-1032(ra) # 54fc <unlink>
      unlink(file);
    490c:	fa840513          	addi	a0,s0,-88
    4910:	00001097          	auipc	ra,0x1
    4914:	bec080e7          	jalr	-1044(ra) # 54fc <unlink>
      unlink(file);
    4918:	fa840513          	addi	a0,s0,-88
    491c:	00001097          	auipc	ra,0x1
    4920:	be0080e7          	jalr	-1056(ra) # 54fc <unlink>
      unlink(file);
    4924:	fa840513          	addi	a0,s0,-88
    4928:	00001097          	auipc	ra,0x1
    492c:	bd4080e7          	jalr	-1068(ra) # 54fc <unlink>
      unlink(file);
    4930:	fa840513          	addi	a0,s0,-88
    4934:	00001097          	auipc	ra,0x1
    4938:	bc8080e7          	jalr	-1080(ra) # 54fc <unlink>
      unlink(file);
    493c:	fa840513          	addi	a0,s0,-88
    4940:	00001097          	auipc	ra,0x1
    4944:	bbc080e7          	jalr	-1092(ra) # 54fc <unlink>
    4948:	bfb5                	j	48c4 <concreate+0x24a>
      exit(0);
    494a:	4501                	li	a0,0
    494c:	00001097          	auipc	ra,0x1
    4950:	b60080e7          	jalr	-1184(ra) # 54ac <exit>
      close(fd);
    4954:	00001097          	auipc	ra,0x1
    4958:	b80080e7          	jalr	-1152(ra) # 54d4 <close>
    if (pid == 0) {
    495c:	bb65                	j	4714 <concreate+0x9a>
      close(fd);
    495e:	00001097          	auipc	ra,0x1
    4962:	b76080e7          	jalr	-1162(ra) # 54d4 <close>
      wait(&xstatus);
    4966:	f6c40513          	addi	a0,s0,-148
    496a:	00001097          	auipc	ra,0x1
    496e:	b4a080e7          	jalr	-1206(ra) # 54b4 <wait>
      if (xstatus != 0)
    4972:	f6c42483          	lw	s1,-148(s0)
    4976:	da0494e3          	bnez	s1,471e <concreate+0xa4>
  for (i = 0; i < N; i++) {
    497a:	2905                	addiw	s2,s2,1
    497c:	db4906e3          	beq	s2,s4,4728 <concreate+0xae>
    file[1] = '0' + i;
    4980:	0309079b          	addiw	a5,s2,48
    4984:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    4988:	fa840513          	addi	a0,s0,-88
    498c:	00001097          	auipc	ra,0x1
    4990:	b70080e7          	jalr	-1168(ra) # 54fc <unlink>
    pid = fork();
    4994:	00001097          	auipc	ra,0x1
    4998:	b10080e7          	jalr	-1264(ra) # 54a4 <fork>
    if (pid && (i % 3) == 1) {
    499c:	d20503e3          	beqz	a0,46c2 <concreate+0x48>
    49a0:	036967bb          	remw	a5,s2,s6
    49a4:	d15787e3          	beq	a5,s5,46b2 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    49a8:	20200593          	li	a1,514
    49ac:	fa840513          	addi	a0,s0,-88
    49b0:	00001097          	auipc	ra,0x1
    49b4:	b3c080e7          	jalr	-1220(ra) # 54ec <open>
      if (fd < 0) {
    49b8:	fa0553e3          	bgez	a0,495e <concreate+0x2e4>
    49bc:	b31d                	j	46e2 <concreate+0x68>
}
    49be:	60ea                	ld	ra,152(sp)
    49c0:	644a                	ld	s0,144(sp)
    49c2:	64aa                	ld	s1,136(sp)
    49c4:	690a                	ld	s2,128(sp)
    49c6:	79e6                	ld	s3,120(sp)
    49c8:	7a46                	ld	s4,112(sp)
    49ca:	7aa6                	ld	s5,104(sp)
    49cc:	7b06                	ld	s6,96(sp)
    49ce:	6be6                	ld	s7,88(sp)
    49d0:	610d                	addi	sp,sp,160
    49d2:	8082                	ret

00000000000049d4 <bigfile>:
void bigfile(char *s) {
    49d4:	7139                	addi	sp,sp,-64
    49d6:	fc06                	sd	ra,56(sp)
    49d8:	f822                	sd	s0,48(sp)
    49da:	f426                	sd	s1,40(sp)
    49dc:	f04a                	sd	s2,32(sp)
    49de:	ec4e                	sd	s3,24(sp)
    49e0:	e852                	sd	s4,16(sp)
    49e2:	e456                	sd	s5,8(sp)
    49e4:	0080                	addi	s0,sp,64
    49e6:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    49e8:	00003517          	auipc	a0,0x3
    49ec:	06850513          	addi	a0,a0,104 # 7a50 <l_free+0x200a>
    49f0:	00001097          	auipc	ra,0x1
    49f4:	b0c080e7          	jalr	-1268(ra) # 54fc <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    49f8:	20200593          	li	a1,514
    49fc:	00003517          	auipc	a0,0x3
    4a00:	05450513          	addi	a0,a0,84 # 7a50 <l_free+0x200a>
    4a04:	00001097          	auipc	ra,0x1
    4a08:	ae8080e7          	jalr	-1304(ra) # 54ec <open>
    4a0c:	89aa                	mv	s3,a0
  for (i = 0; i < N; i++) {
    4a0e:	4481                	li	s1,0
    memset(buf, i, SZ);
    4a10:	00007917          	auipc	s2,0x7
    4a14:	fa890913          	addi	s2,s2,-88 # b9b8 <buf>
  for (i = 0; i < N; i++) {
    4a18:	4a51                	li	s4,20
  if (fd < 0) {
    4a1a:	0a054063          	bltz	a0,4aba <bigfile+0xe6>
    memset(buf, i, SZ);
    4a1e:	25800613          	li	a2,600
    4a22:	85a6                	mv	a1,s1
    4a24:	854a                	mv	a0,s2
    4a26:	00001097          	auipc	ra,0x1
    4a2a:	88a080e7          	jalr	-1910(ra) # 52b0 <memset>
    if (write(fd, buf, SZ) != SZ) {
    4a2e:	25800613          	li	a2,600
    4a32:	85ca                	mv	a1,s2
    4a34:	854e                	mv	a0,s3
    4a36:	00001097          	auipc	ra,0x1
    4a3a:	a96080e7          	jalr	-1386(ra) # 54cc <write>
    4a3e:	25800793          	li	a5,600
    4a42:	08f51a63          	bne	a0,a5,4ad6 <bigfile+0x102>
  for (i = 0; i < N; i++) {
    4a46:	2485                	addiw	s1,s1,1
    4a48:	fd449be3          	bne	s1,s4,4a1e <bigfile+0x4a>
  close(fd);
    4a4c:	854e                	mv	a0,s3
    4a4e:	00001097          	auipc	ra,0x1
    4a52:	a86080e7          	jalr	-1402(ra) # 54d4 <close>
  fd = open("bigfile.dat", 0);
    4a56:	4581                	li	a1,0
    4a58:	00003517          	auipc	a0,0x3
    4a5c:	ff850513          	addi	a0,a0,-8 # 7a50 <l_free+0x200a>
    4a60:	00001097          	auipc	ra,0x1
    4a64:	a8c080e7          	jalr	-1396(ra) # 54ec <open>
    4a68:	8a2a                	mv	s4,a0
  total = 0;
    4a6a:	4981                	li	s3,0
  for (i = 0;; i++) {
    4a6c:	4481                	li	s1,0
    cc = read(fd, buf, SZ / 2);
    4a6e:	00007917          	auipc	s2,0x7
    4a72:	f4a90913          	addi	s2,s2,-182 # b9b8 <buf>
  if (fd < 0) {
    4a76:	06054e63          	bltz	a0,4af2 <bigfile+0x11e>
    cc = read(fd, buf, SZ / 2);
    4a7a:	12c00613          	li	a2,300
    4a7e:	85ca                	mv	a1,s2
    4a80:	8552                	mv	a0,s4
    4a82:	00001097          	auipc	ra,0x1
    4a86:	a42080e7          	jalr	-1470(ra) # 54c4 <read>
    if (cc < 0) {
    4a8a:	08054263          	bltz	a0,4b0e <bigfile+0x13a>
    if (cc == 0)
    4a8e:	c971                	beqz	a0,4b62 <bigfile+0x18e>
    if (cc != SZ / 2) {
    4a90:	12c00793          	li	a5,300
    4a94:	08f51b63          	bne	a0,a5,4b2a <bigfile+0x156>
    if (buf[0] != i / 2 || buf[SZ / 2 - 1] != i / 2) {
    4a98:	01f4d79b          	srliw	a5,s1,0x1f
    4a9c:	9fa5                	addw	a5,a5,s1
    4a9e:	4017d79b          	sraiw	a5,a5,0x1
    4aa2:	00094703          	lbu	a4,0(s2)
    4aa6:	0af71063          	bne	a4,a5,4b46 <bigfile+0x172>
    4aaa:	12b94703          	lbu	a4,299(s2)
    4aae:	08f71c63          	bne	a4,a5,4b46 <bigfile+0x172>
    total += cc;
    4ab2:	12c9899b          	addiw	s3,s3,300
  for (i = 0;; i++) {
    4ab6:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ / 2);
    4ab8:	b7c9                	j	4a7a <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    4aba:	85d6                	mv	a1,s5
    4abc:	00003517          	auipc	a0,0x3
    4ac0:	fa450513          	addi	a0,a0,-92 # 7a60 <l_free+0x201a>
    4ac4:	00001097          	auipc	ra,0x1
    4ac8:	d60080e7          	jalr	-672(ra) # 5824 <printf>
    exit(1);
    4acc:	4505                	li	a0,1
    4ace:	00001097          	auipc	ra,0x1
    4ad2:	9de080e7          	jalr	-1570(ra) # 54ac <exit>
      printf("%s: write bigfile failed\n", s);
    4ad6:	85d6                	mv	a1,s5
    4ad8:	00003517          	auipc	a0,0x3
    4adc:	fa850513          	addi	a0,a0,-88 # 7a80 <l_free+0x203a>
    4ae0:	00001097          	auipc	ra,0x1
    4ae4:	d44080e7          	jalr	-700(ra) # 5824 <printf>
      exit(1);
    4ae8:	4505                	li	a0,1
    4aea:	00001097          	auipc	ra,0x1
    4aee:	9c2080e7          	jalr	-1598(ra) # 54ac <exit>
    printf("%s: cannot open bigfile\n", s);
    4af2:	85d6                	mv	a1,s5
    4af4:	00003517          	auipc	a0,0x3
    4af8:	fac50513          	addi	a0,a0,-84 # 7aa0 <l_free+0x205a>
    4afc:	00001097          	auipc	ra,0x1
    4b00:	d28080e7          	jalr	-728(ra) # 5824 <printf>
    exit(1);
    4b04:	4505                	li	a0,1
    4b06:	00001097          	auipc	ra,0x1
    4b0a:	9a6080e7          	jalr	-1626(ra) # 54ac <exit>
      printf("%s: read bigfile failed\n", s);
    4b0e:	85d6                	mv	a1,s5
    4b10:	00003517          	auipc	a0,0x3
    4b14:	fb050513          	addi	a0,a0,-80 # 7ac0 <l_free+0x207a>
    4b18:	00001097          	auipc	ra,0x1
    4b1c:	d0c080e7          	jalr	-756(ra) # 5824 <printf>
      exit(1);
    4b20:	4505                	li	a0,1
    4b22:	00001097          	auipc	ra,0x1
    4b26:	98a080e7          	jalr	-1654(ra) # 54ac <exit>
      printf("%s: short read bigfile\n", s);
    4b2a:	85d6                	mv	a1,s5
    4b2c:	00003517          	auipc	a0,0x3
    4b30:	fb450513          	addi	a0,a0,-76 # 7ae0 <l_free+0x209a>
    4b34:	00001097          	auipc	ra,0x1
    4b38:	cf0080e7          	jalr	-784(ra) # 5824 <printf>
      exit(1);
    4b3c:	4505                	li	a0,1
    4b3e:	00001097          	auipc	ra,0x1
    4b42:	96e080e7          	jalr	-1682(ra) # 54ac <exit>
      printf("%s: read bigfile wrong data\n", s);
    4b46:	85d6                	mv	a1,s5
    4b48:	00003517          	auipc	a0,0x3
    4b4c:	fb050513          	addi	a0,a0,-80 # 7af8 <l_free+0x20b2>
    4b50:	00001097          	auipc	ra,0x1
    4b54:	cd4080e7          	jalr	-812(ra) # 5824 <printf>
      exit(1);
    4b58:	4505                	li	a0,1
    4b5a:	00001097          	auipc	ra,0x1
    4b5e:	952080e7          	jalr	-1710(ra) # 54ac <exit>
  close(fd);
    4b62:	8552                	mv	a0,s4
    4b64:	00001097          	auipc	ra,0x1
    4b68:	970080e7          	jalr	-1680(ra) # 54d4 <close>
  if (total != N * SZ) {
    4b6c:	678d                	lui	a5,0x3
    4b6e:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x120>
    4b72:	02f99363          	bne	s3,a5,4b98 <bigfile+0x1c4>
  unlink("bigfile.dat");
    4b76:	00003517          	auipc	a0,0x3
    4b7a:	eda50513          	addi	a0,a0,-294 # 7a50 <l_free+0x200a>
    4b7e:	00001097          	auipc	ra,0x1
    4b82:	97e080e7          	jalr	-1666(ra) # 54fc <unlink>
}
    4b86:	70e2                	ld	ra,56(sp)
    4b88:	7442                	ld	s0,48(sp)
    4b8a:	74a2                	ld	s1,40(sp)
    4b8c:	7902                	ld	s2,32(sp)
    4b8e:	69e2                	ld	s3,24(sp)
    4b90:	6a42                	ld	s4,16(sp)
    4b92:	6aa2                	ld	s5,8(sp)
    4b94:	6121                	addi	sp,sp,64
    4b96:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4b98:	85d6                	mv	a1,s5
    4b9a:	00003517          	auipc	a0,0x3
    4b9e:	f7e50513          	addi	a0,a0,-130 # 7b18 <l_free+0x20d2>
    4ba2:	00001097          	auipc	ra,0x1
    4ba6:	c82080e7          	jalr	-894(ra) # 5824 <printf>
    exit(1);
    4baa:	4505                	li	a0,1
    4bac:	00001097          	auipc	ra,0x1
    4bb0:	900080e7          	jalr	-1792(ra) # 54ac <exit>

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
    4bc4:	f7850513          	addi	a0,a0,-136 # 7b38 <l_free+0x20f2>
    4bc8:	00001097          	auipc	ra,0x1
    4bcc:	c5c080e7          	jalr	-932(ra) # 5824 <printf>
  if (mkdir("dir0") < 0) {
    4bd0:	00003517          	auipc	a0,0x3
    4bd4:	f7850513          	addi	a0,a0,-136 # 7b48 <l_free+0x2102>
    4bd8:	00001097          	auipc	ra,0x1
    4bdc:	93c080e7          	jalr	-1732(ra) # 5514 <mkdir>
    4be0:	04054d63          	bltz	a0,4c3a <dirtest+0x86>
  if (chdir("dir0") < 0) {
    4be4:	00003517          	auipc	a0,0x3
    4be8:	f6450513          	addi	a0,a0,-156 # 7b48 <l_free+0x2102>
    4bec:	00001097          	auipc	ra,0x1
    4bf0:	930080e7          	jalr	-1744(ra) # 551c <chdir>
    4bf4:	06054163          	bltz	a0,4c56 <dirtest+0xa2>
  if (chdir("..") < 0) {
    4bf8:	00003517          	auipc	a0,0x3
    4bfc:	90850513          	addi	a0,a0,-1784 # 7500 <l_free+0x1aba>
    4c00:	00001097          	auipc	ra,0x1
    4c04:	91c080e7          	jalr	-1764(ra) # 551c <chdir>
    4c08:	06054563          	bltz	a0,4c72 <dirtest+0xbe>
  if (unlink("dir0") < 0) {
    4c0c:	00003517          	auipc	a0,0x3
    4c10:	f3c50513          	addi	a0,a0,-196 # 7b48 <l_free+0x2102>
    4c14:	00001097          	auipc	ra,0x1
    4c18:	8e8080e7          	jalr	-1816(ra) # 54fc <unlink>
    4c1c:	06054963          	bltz	a0,4c8e <dirtest+0xda>
  printf("%s: mkdir test ok\n");
    4c20:	00003517          	auipc	a0,0x3
    4c24:	f7850513          	addi	a0,a0,-136 # 7b98 <l_free+0x2152>
    4c28:	00001097          	auipc	ra,0x1
    4c2c:	bfc080e7          	jalr	-1028(ra) # 5824 <printf>
}
    4c30:	60e2                	ld	ra,24(sp)
    4c32:	6442                	ld	s0,16(sp)
    4c34:	64a2                	ld	s1,8(sp)
    4c36:	6105                	addi	sp,sp,32
    4c38:	8082                	ret
    printf("%s: mkdir failed\n", s);
    4c3a:	85a6                	mv	a1,s1
    4c3c:	00002517          	auipc	a0,0x2
    4c40:	26450513          	addi	a0,a0,612 # 6ea0 <l_free+0x145a>
    4c44:	00001097          	auipc	ra,0x1
    4c48:	be0080e7          	jalr	-1056(ra) # 5824 <printf>
    exit(1);
    4c4c:	4505                	li	a0,1
    4c4e:	00001097          	auipc	ra,0x1
    4c52:	85e080e7          	jalr	-1954(ra) # 54ac <exit>
    printf("%s: chdir dir0 failed\n", s);
    4c56:	85a6                	mv	a1,s1
    4c58:	00003517          	auipc	a0,0x3
    4c5c:	ef850513          	addi	a0,a0,-264 # 7b50 <l_free+0x210a>
    4c60:	00001097          	auipc	ra,0x1
    4c64:	bc4080e7          	jalr	-1084(ra) # 5824 <printf>
    exit(1);
    4c68:	4505                	li	a0,1
    4c6a:	00001097          	auipc	ra,0x1
    4c6e:	842080e7          	jalr	-1982(ra) # 54ac <exit>
    printf("%s: chdir .. failed\n", s);
    4c72:	85a6                	mv	a1,s1
    4c74:	00003517          	auipc	a0,0x3
    4c78:	ef450513          	addi	a0,a0,-268 # 7b68 <l_free+0x2122>
    4c7c:	00001097          	auipc	ra,0x1
    4c80:	ba8080e7          	jalr	-1112(ra) # 5824 <printf>
    exit(1);
    4c84:	4505                	li	a0,1
    4c86:	00001097          	auipc	ra,0x1
    4c8a:	826080e7          	jalr	-2010(ra) # 54ac <exit>
    printf("%s: unlink dir0 failed\n", s);
    4c8e:	85a6                	mv	a1,s1
    4c90:	00003517          	auipc	a0,0x3
    4c94:	ef050513          	addi	a0,a0,-272 # 7b80 <l_free+0x213a>
    4c98:	00001097          	auipc	ra,0x1
    4c9c:	b8c080e7          	jalr	-1140(ra) # 5824 <printf>
    exit(1);
    4ca0:	4505                	li	a0,1
    4ca2:	00001097          	auipc	ra,0x1
    4ca6:	80a080e7          	jalr	-2038(ra) # 54ac <exit>

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
    4ccc:	ee850513          	addi	a0,a0,-280 # 7bb0 <l_free+0x216a>
    4cd0:	00001097          	auipc	ra,0x1
    4cd4:	b54080e7          	jalr	-1196(ra) # 5824 <printf>
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
    4cec:	ed8c8c93          	addi	s9,s9,-296 # 7bc0 <l_free+0x217a>
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
    4d44:	ae4080e7          	jalr	-1308(ra) # 5824 <printf>
    int fd = open(name, O_CREATE | O_RDWR);
    4d48:	20200593          	li	a1,514
    4d4c:	f5040513          	addi	a0,s0,-176
    4d50:	00000097          	auipc	ra,0x0
    4d54:	79c080e7          	jalr	1948(ra) # 54ec <open>
    4d58:	892a                	mv	s2,a0
    if (fd < 0) {
    4d5a:	0a055663          	bgez	a0,4e06 <fsfull+0x15c>
      printf("%s: open %s failed\n", name);
    4d5e:	f5040593          	addi	a1,s0,-176
    4d62:	00003517          	auipc	a0,0x3
    4d66:	e6e50513          	addi	a0,a0,-402 # 7bd0 <l_free+0x218a>
    4d6a:	00001097          	auipc	ra,0x1
    4d6e:	aba080e7          	jalr	-1350(ra) # 5824 <printf>
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
    4dce:	732080e7          	jalr	1842(ra) # 54fc <unlink>
    nfiles--;
    4dd2:	34fd                	addiw	s1,s1,-1
  while (nfiles >= 0) {
    4dd4:	fb5499e3          	bne	s1,s5,4d86 <fsfull+0xdc>
  printf("fsfull test finished\n");
    4dd8:	00003517          	auipc	a0,0x3
    4ddc:	e2850513          	addi	a0,a0,-472 # 7c00 <l_free+0x21ba>
    4de0:	00001097          	auipc	ra,0x1
    4de4:	a44080e7          	jalr	-1468(ra) # 5824 <printf>
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
    4e18:	6b8080e7          	jalr	1720(ra) # 54cc <write>
      if (cc < BSIZE)
    4e1c:	00aad563          	bge	s5,a0,4e26 <fsfull+0x17c>
      total += cc;
    4e20:	00a989bb          	addw	s3,s3,a0
    while (1) {
    4e24:	b7e5                	j	4e0c <fsfull+0x162>
    printf("%s: wrote %d bytes\n", total);
    4e26:	85ce                	mv	a1,s3
    4e28:	00003517          	auipc	a0,0x3
    4e2c:	dc050513          	addi	a0,a0,-576 # 7be8 <l_free+0x21a2>
    4e30:	00001097          	auipc	ra,0x1
    4e34:	9f4080e7          	jalr	-1548(ra) # 5824 <printf>
    close(fd);
    4e38:	854a                	mv	a0,s2
    4e3a:	00000097          	auipc	ra,0x0
    4e3e:	69a080e7          	jalr	1690(ra) # 54d4 <close>
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
    4e90:	630080e7          	jalr	1584(ra) # 54bc <pipe>
    4e94:	06054763          	bltz	a0,4f02 <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }

  int pid = fork();
    4e98:	00000097          	auipc	ra,0x0
    4e9c:	60c080e7          	jalr	1548(ra) # 54a4 <fork>

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
    4eae:	62a080e7          	jalr	1578(ra) # 54d4 <close>

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
    4eba:	f6298993          	addi	s3,s3,-158 # 5e18 <l_free+0x3d2>
      uint64 a = (uint64)sbrk(4096);
    4ebe:	6505                	lui	a0,0x1
    4ec0:	00000097          	auipc	ra,0x0
    4ec4:	674080e7          	jalr	1652(ra) # 5534 <sbrk>
      if (a == 0xffffffffffffffff) {
    4ec8:	07250763          	beq	a0,s2,4f36 <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    4ecc:	6785                	lui	a5,0x1
    4ece:	953e                	add	a0,a0,a5
    4ed0:	fe950fa3          	sb	s1,-1(a0) # fff <linktest+0x1d1>
      if (write(fds[1], "x", 1) != 1) {
    4ed4:	8626                	mv	a2,s1
    4ed6:	85ce                	mv	a1,s3
    4ed8:	fcc42503          	lw	a0,-52(s0)
    4edc:	00000097          	auipc	ra,0x0
    4ee0:	5f0080e7          	jalr	1520(ra) # 54cc <write>
    4ee4:	fc950de3          	beq	a0,s1,4ebe <countfree+0x44>
        printf("write() failed in countfree()\n");
    4ee8:	00003517          	auipc	a0,0x3
    4eec:	d7050513          	addi	a0,a0,-656 # 7c58 <l_free+0x2212>
    4ef0:	00001097          	auipc	ra,0x1
    4ef4:	934080e7          	jalr	-1740(ra) # 5824 <printf>
        exit(1);
    4ef8:	4505                	li	a0,1
    4efa:	00000097          	auipc	ra,0x0
    4efe:	5b2080e7          	jalr	1458(ra) # 54ac <exit>
    printf("pipe() failed in countfree()\n");
    4f02:	00003517          	auipc	a0,0x3
    4f06:	d1650513          	addi	a0,a0,-746 # 7c18 <l_free+0x21d2>
    4f0a:	00001097          	auipc	ra,0x1
    4f0e:	91a080e7          	jalr	-1766(ra) # 5824 <printf>
    exit(1);
    4f12:	4505                	li	a0,1
    4f14:	00000097          	auipc	ra,0x0
    4f18:	598080e7          	jalr	1432(ra) # 54ac <exit>
    printf("fork failed in countfree()\n");
    4f1c:	00003517          	auipc	a0,0x3
    4f20:	d1c50513          	addi	a0,a0,-740 # 7c38 <l_free+0x21f2>
    4f24:	00001097          	auipc	ra,0x1
    4f28:	900080e7          	jalr	-1792(ra) # 5824 <printf>
    exit(1);
    4f2c:	4505                	li	a0,1
    4f2e:	00000097          	auipc	ra,0x0
    4f32:	57e080e7          	jalr	1406(ra) # 54ac <exit>
      }
    }

    exit(0);
    4f36:	4501                	li	a0,0
    4f38:	00000097          	auipc	ra,0x0
    4f3c:	574080e7          	jalr	1396(ra) # 54ac <exit>
  }

  close(fds[1]);
    4f40:	fcc42503          	lw	a0,-52(s0)
    4f44:	00000097          	auipc	ra,0x0
    4f48:	590080e7          	jalr	1424(ra) # 54d4 <close>

  int n = 0;
    4f4c:	4481                	li	s1,0
  while (1) {
    char c;
    int cc = read(fds[0], &c, 1);
    4f4e:	4605                	li	a2,1
    4f50:	fc740593          	addi	a1,s0,-57
    4f54:	fc842503          	lw	a0,-56(s0)
    4f58:	00000097          	auipc	ra,0x0
    4f5c:	56c080e7          	jalr	1388(ra) # 54c4 <read>
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
    4f6e:	d0e50513          	addi	a0,a0,-754 # 7c78 <l_free+0x2232>
    4f72:	00001097          	auipc	ra,0x1
    4f76:	8b2080e7          	jalr	-1870(ra) # 5824 <printf>
      exit(1);
    4f7a:	4505                	li	a0,1
    4f7c:	00000097          	auipc	ra,0x0
    4f80:	530080e7          	jalr	1328(ra) # 54ac <exit>
  }

  close(fds[0]);
    4f84:	fc842503          	lw	a0,-56(s0)
    4f88:	00000097          	auipc	ra,0x0
    4f8c:	54c080e7          	jalr	1356(ra) # 54d4 <close>
  wait((int *)0);
    4f90:	4501                	li	a0,0
    4f92:	00000097          	auipc	ra,0x0
    4f96:	522080e7          	jalr	1314(ra) # 54b4 <wait>

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
    4fbe:	cde50513          	addi	a0,a0,-802 # 7c98 <l_free+0x2252>
    4fc2:	00001097          	auipc	ra,0x1
    4fc6:	862080e7          	jalr	-1950(ra) # 5824 <printf>
  if ((pid = fork()) < 0) {
    4fca:	00000097          	auipc	ra,0x0
    4fce:	4da080e7          	jalr	1242(ra) # 54a4 <fork>
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
    4fe0:	4d8080e7          	jalr	1240(ra) # 54b4 <wait>
    if (xstatus != 0)
    4fe4:	fdc42783          	lw	a5,-36(s0)
    4fe8:	c7b9                	beqz	a5,5036 <run+0x8c>
      printf("FAILED\n");
    4fea:	00003517          	auipc	a0,0x3
    4fee:	cd650513          	addi	a0,a0,-810 # 7cc0 <l_free+0x227a>
    4ff2:	00001097          	auipc	ra,0x1
    4ff6:	832080e7          	jalr	-1998(ra) # 5824 <printf>
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
    5012:	c9a50513          	addi	a0,a0,-870 # 7ca8 <l_free+0x2262>
    5016:	00001097          	auipc	ra,0x1
    501a:	80e080e7          	jalr	-2034(ra) # 5824 <printf>
    exit(1);
    501e:	4505                	li	a0,1
    5020:	00000097          	auipc	ra,0x0
    5024:	48c080e7          	jalr	1164(ra) # 54ac <exit>
    f(s);
    5028:	854a                	mv	a0,s2
    502a:	9482                	jalr	s1
    exit(0);
    502c:	4501                	li	a0,0
    502e:	00000097          	auipc	ra,0x0
    5032:	47e080e7          	jalr	1150(ra) # 54ac <exit>
      printf("OK\n");
    5036:	00003517          	auipc	a0,0x3
    503a:	c9250513          	addi	a0,a0,-878 # 7cc8 <l_free+0x2282>
    503e:	00000097          	auipc	ra,0x0
    5042:	7e6080e7          	jalr	2022(ra) # 5824 <printf>
    5046:	bf55                	j	4ffa <run+0x50>

0000000000005048 <main>:

int main(int argc, char *argv[]) {
    5048:	c2010113          	addi	sp,sp,-992
    504c:	3c113c23          	sd	ra,984(sp)
    5050:	3c813823          	sd	s0,976(sp)
    5054:	3c913423          	sd	s1,968(sp)
    5058:	3d213023          	sd	s2,960(sp)
    505c:	3b313c23          	sd	s3,952(sp)
    5060:	3b413823          	sd	s4,944(sp)
    5064:	3b513423          	sd	s5,936(sp)
    5068:	3b613023          	sd	s6,928(sp)
    506c:	1780                	addi	s0,sp,992
    506e:	89aa                	mv	s3,a0
  int continuous = 0;
  char *justone = 0;

  if (argc == 2 && strcmp(argv[1], "-c") == 0) {
    5070:	4789                	li	a5,2
    5072:	06f50a63          	beq	a0,a5,50e6 <main+0x9e>
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
    507a:	0aa7c363          	blt	a5,a0,5120 <main+0xd8>
  }

  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    507e:	00003797          	auipc	a5,0x3
    5082:	d3278793          	addi	a5,a5,-718 # 7db0 <l_free+0x236a>
    5086:	c2040713          	addi	a4,s0,-992
    508a:	00003817          	auipc	a6,0x3
    508e:	0c680813          	addi	a6,a6,198 # 8150 <l_free+0x270a>
    5092:	6388                	ld	a0,0(a5)
    5094:	678c                	ld	a1,8(a5)
    5096:	6b90                	ld	a2,16(a5)
    5098:	6f94                	ld	a3,24(a5)
    509a:	e308                	sd	a0,0(a4)
    509c:	e70c                	sd	a1,8(a4)
    509e:	eb10                	sd	a2,16(a4)
    50a0:	ef14                	sd	a3,24(a4)
    50a2:	02078793          	addi	a5,a5,32
    50a6:	02070713          	addi	a4,a4,32
    50aa:	ff0794e3          	bne	a5,a6,5092 <main+0x4a>
          exit(1);
      }
    }
  }

  printf("usertests starting\n");
    50ae:	00003517          	auipc	a0,0x3
    50b2:	ca250513          	addi	a0,a0,-862 # 7d50 <l_free+0x230a>
    50b6:	00000097          	auipc	ra,0x0
    50ba:	76e080e7          	jalr	1902(ra) # 5824 <printf>
  int free0 = 100; // countfree();
  int free1 = 0;
  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    50be:	c2843503          	ld	a0,-984(s0)
    50c2:	c2040493          	addi	s1,s0,-992
  int fail = 0;
    50c6:	4981                	li	s3,0
    if ((justone == 0) || strcmp(t->s, justone) == 0) {
      if (!run(t->f, t->s))
        fail = 1;
    50c8:	4a05                	li	s4,1
  for (struct test *t = tests; t->s != 0; t++) {
    50ca:	ed51                	bnez	a0,5166 <main+0x11e>
    exit(1);
  } else if ((free1 = 100) < free0) {
    printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    exit(1);
  } else {
    printf("ALL TESTS PASSED\n");
    50cc:	00003517          	auipc	a0,0x3
    50d0:	c6c50513          	addi	a0,a0,-916 # 7d38 <l_free+0x22f2>
    50d4:	00000097          	auipc	ra,0x0
    50d8:	750080e7          	jalr	1872(ra) # 5824 <printf>
    exit(0);
    50dc:	4501                	li	a0,0
    50de:	00000097          	auipc	ra,0x0
    50e2:	3ce080e7          	jalr	974(ra) # 54ac <exit>
    50e6:	84ae                	mv	s1,a1
  if (argc == 2 && strcmp(argv[1], "-c") == 0) {
    50e8:	00003597          	auipc	a1,0x3
    50ec:	be858593          	addi	a1,a1,-1048 # 7cd0 <l_free+0x228a>
    50f0:	6488                	ld	a0,8(s1)
    50f2:	00000097          	auipc	ra,0x0
    50f6:	168080e7          	jalr	360(ra) # 525a <strcmp>
    50fa:	c57d                	beqz	a0,51e8 <main+0x1a0>
  } else if (argc == 2 && strcmp(argv[1], "-C") == 0) {
    50fc:	00003597          	auipc	a1,0x3
    5100:	c8c58593          	addi	a1,a1,-884 # 7d88 <l_free+0x2342>
    5104:	6488                	ld	a0,8(s1)
    5106:	00000097          	auipc	ra,0x0
    510a:	154080e7          	jalr	340(ra) # 525a <strcmp>
    510e:	cd71                	beqz	a0,51ea <main+0x1a2>
  } else if (argc == 2 && argv[1][0] != '-') {
    5110:	0084b903          	ld	s2,8(s1)
    5114:	00094703          	lbu	a4,0(s2)
    5118:	02d00793          	li	a5,45
    511c:	f6f711e3          	bne	a4,a5,507e <main+0x36>
    printf("Usage: usertests [-c] [testname]\n");
    5120:	00003517          	auipc	a0,0x3
    5124:	bb850513          	addi	a0,a0,-1096 # 7cd8 <l_free+0x2292>
    5128:	00000097          	auipc	ra,0x0
    512c:	6fc080e7          	jalr	1788(ra) # 5824 <printf>
    exit(1);
    5130:	4505                	li	a0,1
    5132:	00000097          	auipc	ra,0x0
    5136:	37a080e7          	jalr	890(ra) # 54ac <exit>
          exit(1);
    513a:	4505                	li	a0,1
    513c:	00000097          	auipc	ra,0x0
    5140:	370080e7          	jalr	880(ra) # 54ac <exit>
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    5144:	40a905bb          	subw	a1,s2,a0
    5148:	855a                	mv	a0,s6
    514a:	00000097          	auipc	ra,0x0
    514e:	6da080e7          	jalr	1754(ra) # 5824 <printf>
        if (continuous != 2)
    5152:	07498763          	beq	s3,s4,51c0 <main+0x178>
          exit(1);
    5156:	4505                	li	a0,1
    5158:	00000097          	auipc	ra,0x0
    515c:	354080e7          	jalr	852(ra) # 54ac <exit>
  for (struct test *t = tests; t->s != 0; t++) {
    5160:	04c1                	addi	s1,s1,16
    5162:	6488                	ld	a0,8(s1)
    5164:	c115                	beqz	a0,5188 <main+0x140>
    if ((justone == 0) || strcmp(t->s, justone) == 0) {
    5166:	00090863          	beqz	s2,5176 <main+0x12e>
    516a:	85ca                	mv	a1,s2
    516c:	00000097          	auipc	ra,0x0
    5170:	0ee080e7          	jalr	238(ra) # 525a <strcmp>
    5174:	f575                	bnez	a0,5160 <main+0x118>
      if (!run(t->f, t->s))
    5176:	648c                	ld	a1,8(s1)
    5178:	6088                	ld	a0,0(s1)
    517a:	00000097          	auipc	ra,0x0
    517e:	e30080e7          	jalr	-464(ra) # 4faa <run>
    5182:	fd79                	bnez	a0,5160 <main+0x118>
        fail = 1;
    5184:	89d2                	mv	s3,s4
    5186:	bfe9                	j	5160 <main+0x118>
  if (fail) {
    5188:	f40982e3          	beqz	s3,50cc <main+0x84>
    printf("SOME TESTS FAILED\n");
    518c:	00003517          	auipc	a0,0x3
    5190:	b9450513          	addi	a0,a0,-1132 # 7d20 <l_free+0x22da>
    5194:	00000097          	auipc	ra,0x0
    5198:	690080e7          	jalr	1680(ra) # 5824 <printf>
    exit(1);
    519c:	4505                	li	a0,1
    519e:	00000097          	auipc	ra,0x0
    51a2:	30e080e7          	jalr	782(ra) # 54ac <exit>
        printf("SOME TESTS FAILED\n");
    51a6:	8556                	mv	a0,s5
    51a8:	00000097          	auipc	ra,0x0
    51ac:	67c080e7          	jalr	1660(ra) # 5824 <printf>
        if (continuous != 2)
    51b0:	f94995e3          	bne	s3,s4,513a <main+0xf2>
      int free1 = countfree();
    51b4:	00000097          	auipc	ra,0x0
    51b8:	cc6080e7          	jalr	-826(ra) # 4e7a <countfree>
      if (free1 < free0) {
    51bc:	f92544e3          	blt	a0,s2,5144 <main+0xfc>
      int free0 = countfree();
    51c0:	00000097          	auipc	ra,0x0
    51c4:	cba080e7          	jalr	-838(ra) # 4e7a <countfree>
    51c8:	892a                	mv	s2,a0
      for (struct test *t = tests; t->s != 0; t++) {
    51ca:	c2843583          	ld	a1,-984(s0)
    51ce:	d1fd                	beqz	a1,51b4 <main+0x16c>
    51d0:	c2040493          	addi	s1,s0,-992
        if (!run(t->f, t->s)) {
    51d4:	6088                	ld	a0,0(s1)
    51d6:	00000097          	auipc	ra,0x0
    51da:	dd4080e7          	jalr	-556(ra) # 4faa <run>
    51de:	d561                	beqz	a0,51a6 <main+0x15e>
      for (struct test *t = tests; t->s != 0; t++) {
    51e0:	04c1                	addi	s1,s1,16
    51e2:	648c                	ld	a1,8(s1)
    51e4:	f9e5                	bnez	a1,51d4 <main+0x18c>
    51e6:	b7f9                	j	51b4 <main+0x16c>
    continuous = 1;
    51e8:	4985                	li	s3,1
  } tests[] = {
    51ea:	00003797          	auipc	a5,0x3
    51ee:	bc678793          	addi	a5,a5,-1082 # 7db0 <l_free+0x236a>
    51f2:	c2040713          	addi	a4,s0,-992
    51f6:	00003817          	auipc	a6,0x3
    51fa:	f5a80813          	addi	a6,a6,-166 # 8150 <l_free+0x270a>
    51fe:	6388                	ld	a0,0(a5)
    5200:	678c                	ld	a1,8(a5)
    5202:	6b90                	ld	a2,16(a5)
    5204:	6f94                	ld	a3,24(a5)
    5206:	e308                	sd	a0,0(a4)
    5208:	e70c                	sd	a1,8(a4)
    520a:	eb10                	sd	a2,16(a4)
    520c:	ef14                	sd	a3,24(a4)
    520e:	02078793          	addi	a5,a5,32
    5212:	02070713          	addi	a4,a4,32
    5216:	ff0794e3          	bne	a5,a6,51fe <main+0x1b6>
    printf("continuous usertests starting\n");
    521a:	00003517          	auipc	a0,0x3
    521e:	b4e50513          	addi	a0,a0,-1202 # 7d68 <l_free+0x2322>
    5222:	00000097          	auipc	ra,0x0
    5226:	602080e7          	jalr	1538(ra) # 5824 <printf>
        printf("SOME TESTS FAILED\n");
    522a:	00003a97          	auipc	s5,0x3
    522e:	af6a8a93          	addi	s5,s5,-1290 # 7d20 <l_free+0x22da>
        if (continuous != 2)
    5232:	4a09                	li	s4,2
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    5234:	00003b17          	auipc	s6,0x3
    5238:	accb0b13          	addi	s6,s6,-1332 # 7d00 <l_free+0x22ba>
    523c:	b751                	j	51c0 <main+0x178>

000000000000523e <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    523e:	1141                	addi	sp,sp,-16
    5240:	e422                	sd	s0,8(sp)
    5242:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    5244:	87aa                	mv	a5,a0
    5246:	0585                	addi	a1,a1,1
    5248:	0785                	addi	a5,a5,1
    524a:	fff5c703          	lbu	a4,-1(a1)
    524e:	fee78fa3          	sb	a4,-1(a5)
    5252:	fb75                	bnez	a4,5246 <strcpy+0x8>
    ;
  return os;
}
    5254:	6422                	ld	s0,8(sp)
    5256:	0141                	addi	sp,sp,16
    5258:	8082                	ret

000000000000525a <strcmp>:

int
strcmp(const char *p, const char *q)
{
    525a:	1141                	addi	sp,sp,-16
    525c:	e422                	sd	s0,8(sp)
    525e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    5260:	00054783          	lbu	a5,0(a0)
    5264:	cb91                	beqz	a5,5278 <strcmp+0x1e>
    5266:	0005c703          	lbu	a4,0(a1)
    526a:	00f71763          	bne	a4,a5,5278 <strcmp+0x1e>
    p++, q++;
    526e:	0505                	addi	a0,a0,1
    5270:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    5272:	00054783          	lbu	a5,0(a0)
    5276:	fbe5                	bnez	a5,5266 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    5278:	0005c503          	lbu	a0,0(a1)
}
    527c:	40a7853b          	subw	a0,a5,a0
    5280:	6422                	ld	s0,8(sp)
    5282:	0141                	addi	sp,sp,16
    5284:	8082                	ret

0000000000005286 <strlen>:

uint
strlen(const char *s)
{
    5286:	1141                	addi	sp,sp,-16
    5288:	e422                	sd	s0,8(sp)
    528a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    528c:	00054783          	lbu	a5,0(a0)
    5290:	cf91                	beqz	a5,52ac <strlen+0x26>
    5292:	0505                	addi	a0,a0,1
    5294:	87aa                	mv	a5,a0
    5296:	4685                	li	a3,1
    5298:	9e89                	subw	a3,a3,a0
    529a:	00f6853b          	addw	a0,a3,a5
    529e:	0785                	addi	a5,a5,1
    52a0:	fff7c703          	lbu	a4,-1(a5)
    52a4:	fb7d                	bnez	a4,529a <strlen+0x14>
    ;
  return n;
}
    52a6:	6422                	ld	s0,8(sp)
    52a8:	0141                	addi	sp,sp,16
    52aa:	8082                	ret
  for(n = 0; s[n]; n++)
    52ac:	4501                	li	a0,0
    52ae:	bfe5                	j	52a6 <strlen+0x20>

00000000000052b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
    52b0:	1141                	addi	sp,sp,-16
    52b2:	e422                	sd	s0,8(sp)
    52b4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    52b6:	ca19                	beqz	a2,52cc <memset+0x1c>
    52b8:	87aa                	mv	a5,a0
    52ba:	1602                	slli	a2,a2,0x20
    52bc:	9201                	srli	a2,a2,0x20
    52be:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    52c2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    52c6:	0785                	addi	a5,a5,1
    52c8:	fee79de3          	bne	a5,a4,52c2 <memset+0x12>
  }
  return dst;
}
    52cc:	6422                	ld	s0,8(sp)
    52ce:	0141                	addi	sp,sp,16
    52d0:	8082                	ret

00000000000052d2 <strchr>:

char*
strchr(const char *s, char c)
{
    52d2:	1141                	addi	sp,sp,-16
    52d4:	e422                	sd	s0,8(sp)
    52d6:	0800                	addi	s0,sp,16
  for(; *s; s++)
    52d8:	00054783          	lbu	a5,0(a0)
    52dc:	cb99                	beqz	a5,52f2 <strchr+0x20>
    if(*s == c)
    52de:	00f58763          	beq	a1,a5,52ec <strchr+0x1a>
  for(; *s; s++)
    52e2:	0505                	addi	a0,a0,1
    52e4:	00054783          	lbu	a5,0(a0)
    52e8:	fbfd                	bnez	a5,52de <strchr+0xc>
      return (char*)s;
  return 0;
    52ea:	4501                	li	a0,0
}
    52ec:	6422                	ld	s0,8(sp)
    52ee:	0141                	addi	sp,sp,16
    52f0:	8082                	ret
  return 0;
    52f2:	4501                	li	a0,0
    52f4:	bfe5                	j	52ec <strchr+0x1a>

00000000000052f6 <gets>:

char*
gets(char *buf, int max)
{
    52f6:	711d                	addi	sp,sp,-96
    52f8:	ec86                	sd	ra,88(sp)
    52fa:	e8a2                	sd	s0,80(sp)
    52fc:	e4a6                	sd	s1,72(sp)
    52fe:	e0ca                	sd	s2,64(sp)
    5300:	fc4e                	sd	s3,56(sp)
    5302:	f852                	sd	s4,48(sp)
    5304:	f456                	sd	s5,40(sp)
    5306:	f05a                	sd	s6,32(sp)
    5308:	ec5e                	sd	s7,24(sp)
    530a:	1080                	addi	s0,sp,96
    530c:	8baa                	mv	s7,a0
    530e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5310:	892a                	mv	s2,a0
    5312:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5314:	4aa9                	li	s5,10
    5316:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5318:	89a6                	mv	s3,s1
    531a:	2485                	addiw	s1,s1,1
    531c:	0344d863          	bge	s1,s4,534c <gets+0x56>
    cc = read(0, &c, 1);
    5320:	4605                	li	a2,1
    5322:	faf40593          	addi	a1,s0,-81
    5326:	4501                	li	a0,0
    5328:	00000097          	auipc	ra,0x0
    532c:	19c080e7          	jalr	412(ra) # 54c4 <read>
    if(cc < 1)
    5330:	00a05e63          	blez	a0,534c <gets+0x56>
    buf[i++] = c;
    5334:	faf44783          	lbu	a5,-81(s0)
    5338:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    533c:	01578763          	beq	a5,s5,534a <gets+0x54>
    5340:	0905                	addi	s2,s2,1
    5342:	fd679be3          	bne	a5,s6,5318 <gets+0x22>
  for(i=0; i+1 < max; ){
    5346:	89a6                	mv	s3,s1
    5348:	a011                	j	534c <gets+0x56>
    534a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    534c:	99de                	add	s3,s3,s7
    534e:	00098023          	sb	zero,0(s3)
  return buf;
}
    5352:	855e                	mv	a0,s7
    5354:	60e6                	ld	ra,88(sp)
    5356:	6446                	ld	s0,80(sp)
    5358:	64a6                	ld	s1,72(sp)
    535a:	6906                	ld	s2,64(sp)
    535c:	79e2                	ld	s3,56(sp)
    535e:	7a42                	ld	s4,48(sp)
    5360:	7aa2                	ld	s5,40(sp)
    5362:	7b02                	ld	s6,32(sp)
    5364:	6be2                	ld	s7,24(sp)
    5366:	6125                	addi	sp,sp,96
    5368:	8082                	ret

000000000000536a <stat>:

int
stat(const char *n, struct stat *st)
{
    536a:	1101                	addi	sp,sp,-32
    536c:	ec06                	sd	ra,24(sp)
    536e:	e822                	sd	s0,16(sp)
    5370:	e426                	sd	s1,8(sp)
    5372:	e04a                	sd	s2,0(sp)
    5374:	1000                	addi	s0,sp,32
    5376:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5378:	4581                	li	a1,0
    537a:	00000097          	auipc	ra,0x0
    537e:	172080e7          	jalr	370(ra) # 54ec <open>
  if(fd < 0)
    5382:	02054563          	bltz	a0,53ac <stat+0x42>
    5386:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5388:	85ca                	mv	a1,s2
    538a:	00000097          	auipc	ra,0x0
    538e:	17a080e7          	jalr	378(ra) # 5504 <fstat>
    5392:	892a                	mv	s2,a0
  close(fd);
    5394:	8526                	mv	a0,s1
    5396:	00000097          	auipc	ra,0x0
    539a:	13e080e7          	jalr	318(ra) # 54d4 <close>
  return r;
}
    539e:	854a                	mv	a0,s2
    53a0:	60e2                	ld	ra,24(sp)
    53a2:	6442                	ld	s0,16(sp)
    53a4:	64a2                	ld	s1,8(sp)
    53a6:	6902                	ld	s2,0(sp)
    53a8:	6105                	addi	sp,sp,32
    53aa:	8082                	ret
    return -1;
    53ac:	597d                	li	s2,-1
    53ae:	bfc5                	j	539e <stat+0x34>

00000000000053b0 <atoi>:

int
atoi(const char *s)
{
    53b0:	1141                	addi	sp,sp,-16
    53b2:	e422                	sd	s0,8(sp)
    53b4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    53b6:	00054603          	lbu	a2,0(a0)
    53ba:	fd06079b          	addiw	a5,a2,-48
    53be:	0ff7f793          	andi	a5,a5,255
    53c2:	4725                	li	a4,9
    53c4:	02f76963          	bltu	a4,a5,53f6 <atoi+0x46>
    53c8:	86aa                	mv	a3,a0
  n = 0;
    53ca:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    53cc:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    53ce:	0685                	addi	a3,a3,1
    53d0:	0025179b          	slliw	a5,a0,0x2
    53d4:	9fa9                	addw	a5,a5,a0
    53d6:	0017979b          	slliw	a5,a5,0x1
    53da:	9fb1                	addw	a5,a5,a2
    53dc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    53e0:	0006c603          	lbu	a2,0(a3)
    53e4:	fd06071b          	addiw	a4,a2,-48
    53e8:	0ff77713          	andi	a4,a4,255
    53ec:	fee5f1e3          	bgeu	a1,a4,53ce <atoi+0x1e>
  return n;
}
    53f0:	6422                	ld	s0,8(sp)
    53f2:	0141                	addi	sp,sp,16
    53f4:	8082                	ret
  n = 0;
    53f6:	4501                	li	a0,0
    53f8:	bfe5                	j	53f0 <atoi+0x40>

00000000000053fa <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    53fa:	1141                	addi	sp,sp,-16
    53fc:	e422                	sd	s0,8(sp)
    53fe:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5400:	02b57463          	bgeu	a0,a1,5428 <memmove+0x2e>
    while(n-- > 0)
    5404:	00c05f63          	blez	a2,5422 <memmove+0x28>
    5408:	1602                	slli	a2,a2,0x20
    540a:	9201                	srli	a2,a2,0x20
    540c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5410:	872a                	mv	a4,a0
      *dst++ = *src++;
    5412:	0585                	addi	a1,a1,1
    5414:	0705                	addi	a4,a4,1
    5416:	fff5c683          	lbu	a3,-1(a1)
    541a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    541e:	fee79ae3          	bne	a5,a4,5412 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5422:	6422                	ld	s0,8(sp)
    5424:	0141                	addi	sp,sp,16
    5426:	8082                	ret
    dst += n;
    5428:	00c50733          	add	a4,a0,a2
    src += n;
    542c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    542e:	fec05ae3          	blez	a2,5422 <memmove+0x28>
    5432:	fff6079b          	addiw	a5,a2,-1
    5436:	1782                	slli	a5,a5,0x20
    5438:	9381                	srli	a5,a5,0x20
    543a:	fff7c793          	not	a5,a5
    543e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5440:	15fd                	addi	a1,a1,-1
    5442:	177d                	addi	a4,a4,-1
    5444:	0005c683          	lbu	a3,0(a1)
    5448:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    544c:	fee79ae3          	bne	a5,a4,5440 <memmove+0x46>
    5450:	bfc9                	j	5422 <memmove+0x28>

0000000000005452 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5452:	1141                	addi	sp,sp,-16
    5454:	e422                	sd	s0,8(sp)
    5456:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5458:	ca05                	beqz	a2,5488 <memcmp+0x36>
    545a:	fff6069b          	addiw	a3,a2,-1
    545e:	1682                	slli	a3,a3,0x20
    5460:	9281                	srli	a3,a3,0x20
    5462:	0685                	addi	a3,a3,1
    5464:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5466:	00054783          	lbu	a5,0(a0)
    546a:	0005c703          	lbu	a4,0(a1)
    546e:	00e79863          	bne	a5,a4,547e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5472:	0505                	addi	a0,a0,1
    p2++;
    5474:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5476:	fed518e3          	bne	a0,a3,5466 <memcmp+0x14>
  }
  return 0;
    547a:	4501                	li	a0,0
    547c:	a019                	j	5482 <memcmp+0x30>
      return *p1 - *p2;
    547e:	40e7853b          	subw	a0,a5,a4
}
    5482:	6422                	ld	s0,8(sp)
    5484:	0141                	addi	sp,sp,16
    5486:	8082                	ret
  return 0;
    5488:	4501                	li	a0,0
    548a:	bfe5                	j	5482 <memcmp+0x30>

000000000000548c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    548c:	1141                	addi	sp,sp,-16
    548e:	e406                	sd	ra,8(sp)
    5490:	e022                	sd	s0,0(sp)
    5492:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5494:	00000097          	auipc	ra,0x0
    5498:	f66080e7          	jalr	-154(ra) # 53fa <memmove>
}
    549c:	60a2                	ld	ra,8(sp)
    549e:	6402                	ld	s0,0(sp)
    54a0:	0141                	addi	sp,sp,16
    54a2:	8082                	ret

00000000000054a4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    54a4:	4885                	li	a7,1
 ecall
    54a6:	00000073          	ecall
 ret
    54aa:	8082                	ret

00000000000054ac <exit>:
.global exit
exit:
 li a7, SYS_exit
    54ac:	4889                	li	a7,2
 ecall
    54ae:	00000073          	ecall
 ret
    54b2:	8082                	ret

00000000000054b4 <wait>:
.global wait
wait:
 li a7, SYS_wait
    54b4:	488d                	li	a7,3
 ecall
    54b6:	00000073          	ecall
 ret
    54ba:	8082                	ret

00000000000054bc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    54bc:	4891                	li	a7,4
 ecall
    54be:	00000073          	ecall
 ret
    54c2:	8082                	ret

00000000000054c4 <read>:
.global read
read:
 li a7, SYS_read
    54c4:	4895                	li	a7,5
 ecall
    54c6:	00000073          	ecall
 ret
    54ca:	8082                	ret

00000000000054cc <write>:
.global write
write:
 li a7, SYS_write
    54cc:	48c1                	li	a7,16
 ecall
    54ce:	00000073          	ecall
 ret
    54d2:	8082                	ret

00000000000054d4 <close>:
.global close
close:
 li a7, SYS_close
    54d4:	48d5                	li	a7,21
 ecall
    54d6:	00000073          	ecall
 ret
    54da:	8082                	ret

00000000000054dc <kill>:
.global kill
kill:
 li a7, SYS_kill
    54dc:	4899                	li	a7,6
 ecall
    54de:	00000073          	ecall
 ret
    54e2:	8082                	ret

00000000000054e4 <exec>:
.global exec
exec:
 li a7, SYS_exec
    54e4:	489d                	li	a7,7
 ecall
    54e6:	00000073          	ecall
 ret
    54ea:	8082                	ret

00000000000054ec <open>:
.global open
open:
 li a7, SYS_open
    54ec:	48bd                	li	a7,15
 ecall
    54ee:	00000073          	ecall
 ret
    54f2:	8082                	ret

00000000000054f4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    54f4:	48c5                	li	a7,17
 ecall
    54f6:	00000073          	ecall
 ret
    54fa:	8082                	ret

00000000000054fc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    54fc:	48c9                	li	a7,18
 ecall
    54fe:	00000073          	ecall
 ret
    5502:	8082                	ret

0000000000005504 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5504:	48a1                	li	a7,8
 ecall
    5506:	00000073          	ecall
 ret
    550a:	8082                	ret

000000000000550c <link>:
.global link
link:
 li a7, SYS_link
    550c:	48cd                	li	a7,19
 ecall
    550e:	00000073          	ecall
 ret
    5512:	8082                	ret

0000000000005514 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5514:	48d1                	li	a7,20
 ecall
    5516:	00000073          	ecall
 ret
    551a:	8082                	ret

000000000000551c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    551c:	48a5                	li	a7,9
 ecall
    551e:	00000073          	ecall
 ret
    5522:	8082                	ret

0000000000005524 <dup>:
.global dup
dup:
 li a7, SYS_dup
    5524:	48a9                	li	a7,10
 ecall
    5526:	00000073          	ecall
 ret
    552a:	8082                	ret

000000000000552c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    552c:	48ad                	li	a7,11
 ecall
    552e:	00000073          	ecall
 ret
    5532:	8082                	ret

0000000000005534 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5534:	48b1                	li	a7,12
 ecall
    5536:	00000073          	ecall
 ret
    553a:	8082                	ret

000000000000553c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    553c:	48b5                	li	a7,13
 ecall
    553e:	00000073          	ecall
 ret
    5542:	8082                	ret

0000000000005544 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5544:	48b9                	li	a7,14
 ecall
    5546:	00000073          	ecall
 ret
    554a:	8082                	ret

000000000000554c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    554c:	1101                	addi	sp,sp,-32
    554e:	ec06                	sd	ra,24(sp)
    5550:	e822                	sd	s0,16(sp)
    5552:	1000                	addi	s0,sp,32
    5554:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5558:	4605                	li	a2,1
    555a:	fef40593          	addi	a1,s0,-17
    555e:	00000097          	auipc	ra,0x0
    5562:	f6e080e7          	jalr	-146(ra) # 54cc <write>
}
    5566:	60e2                	ld	ra,24(sp)
    5568:	6442                	ld	s0,16(sp)
    556a:	6105                	addi	sp,sp,32
    556c:	8082                	ret

000000000000556e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    556e:	7139                	addi	sp,sp,-64
    5570:	fc06                	sd	ra,56(sp)
    5572:	f822                	sd	s0,48(sp)
    5574:	f426                	sd	s1,40(sp)
    5576:	f04a                	sd	s2,32(sp)
    5578:	ec4e                	sd	s3,24(sp)
    557a:	0080                	addi	s0,sp,64
    557c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    557e:	c299                	beqz	a3,5584 <printint+0x16>
    5580:	0805c863          	bltz	a1,5610 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5584:	2581                	sext.w	a1,a1
  neg = 0;
    5586:	4881                	li	a7,0
    5588:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    558c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    558e:	2601                	sext.w	a2,a2
    5590:	00003517          	auipc	a0,0x3
    5594:	bc850513          	addi	a0,a0,-1080 # 8158 <digits>
    5598:	883a                	mv	a6,a4
    559a:	2705                	addiw	a4,a4,1
    559c:	02c5f7bb          	remuw	a5,a1,a2
    55a0:	1782                	slli	a5,a5,0x20
    55a2:	9381                	srli	a5,a5,0x20
    55a4:	97aa                	add	a5,a5,a0
    55a6:	0007c783          	lbu	a5,0(a5)
    55aa:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    55ae:	0005879b          	sext.w	a5,a1
    55b2:	02c5d5bb          	divuw	a1,a1,a2
    55b6:	0685                	addi	a3,a3,1
    55b8:	fec7f0e3          	bgeu	a5,a2,5598 <printint+0x2a>
  if(neg)
    55bc:	00088b63          	beqz	a7,55d2 <printint+0x64>
    buf[i++] = '-';
    55c0:	fd040793          	addi	a5,s0,-48
    55c4:	973e                	add	a4,a4,a5
    55c6:	02d00793          	li	a5,45
    55ca:	fef70823          	sb	a5,-16(a4)
    55ce:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    55d2:	02e05863          	blez	a4,5602 <printint+0x94>
    55d6:	fc040793          	addi	a5,s0,-64
    55da:	00e78933          	add	s2,a5,a4
    55de:	fff78993          	addi	s3,a5,-1
    55e2:	99ba                	add	s3,s3,a4
    55e4:	377d                	addiw	a4,a4,-1
    55e6:	1702                	slli	a4,a4,0x20
    55e8:	9301                	srli	a4,a4,0x20
    55ea:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    55ee:	fff94583          	lbu	a1,-1(s2)
    55f2:	8526                	mv	a0,s1
    55f4:	00000097          	auipc	ra,0x0
    55f8:	f58080e7          	jalr	-168(ra) # 554c <putc>
  while(--i >= 0)
    55fc:	197d                	addi	s2,s2,-1
    55fe:	ff3918e3          	bne	s2,s3,55ee <printint+0x80>
}
    5602:	70e2                	ld	ra,56(sp)
    5604:	7442                	ld	s0,48(sp)
    5606:	74a2                	ld	s1,40(sp)
    5608:	7902                	ld	s2,32(sp)
    560a:	69e2                	ld	s3,24(sp)
    560c:	6121                	addi	sp,sp,64
    560e:	8082                	ret
    x = -xx;
    5610:	40b005bb          	negw	a1,a1
    neg = 1;
    5614:	4885                	li	a7,1
    x = -xx;
    5616:	bf8d                	j	5588 <printint+0x1a>

0000000000005618 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5618:	7119                	addi	sp,sp,-128
    561a:	fc86                	sd	ra,120(sp)
    561c:	f8a2                	sd	s0,112(sp)
    561e:	f4a6                	sd	s1,104(sp)
    5620:	f0ca                	sd	s2,96(sp)
    5622:	ecce                	sd	s3,88(sp)
    5624:	e8d2                	sd	s4,80(sp)
    5626:	e4d6                	sd	s5,72(sp)
    5628:	e0da                	sd	s6,64(sp)
    562a:	fc5e                	sd	s7,56(sp)
    562c:	f862                	sd	s8,48(sp)
    562e:	f466                	sd	s9,40(sp)
    5630:	f06a                	sd	s10,32(sp)
    5632:	ec6e                	sd	s11,24(sp)
    5634:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5636:	0005c903          	lbu	s2,0(a1)
    563a:	18090f63          	beqz	s2,57d8 <vprintf+0x1c0>
    563e:	8aaa                	mv	s5,a0
    5640:	8b32                	mv	s6,a2
    5642:	00158493          	addi	s1,a1,1
  state = 0;
    5646:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5648:	02500a13          	li	s4,37
      if(c == 'd'){
    564c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    5650:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    5654:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    5658:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    565c:	00003b97          	auipc	s7,0x3
    5660:	afcb8b93          	addi	s7,s7,-1284 # 8158 <digits>
    5664:	a839                	j	5682 <vprintf+0x6a>
        putc(fd, c);
    5666:	85ca                	mv	a1,s2
    5668:	8556                	mv	a0,s5
    566a:	00000097          	auipc	ra,0x0
    566e:	ee2080e7          	jalr	-286(ra) # 554c <putc>
    5672:	a019                	j	5678 <vprintf+0x60>
    } else if(state == '%'){
    5674:	01498f63          	beq	s3,s4,5692 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    5678:	0485                	addi	s1,s1,1
    567a:	fff4c903          	lbu	s2,-1(s1)
    567e:	14090d63          	beqz	s2,57d8 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    5682:	0009079b          	sext.w	a5,s2
    if(state == 0){
    5686:	fe0997e3          	bnez	s3,5674 <vprintf+0x5c>
      if(c == '%'){
    568a:	fd479ee3          	bne	a5,s4,5666 <vprintf+0x4e>
        state = '%';
    568e:	89be                	mv	s3,a5
    5690:	b7e5                	j	5678 <vprintf+0x60>
      if(c == 'd'){
    5692:	05878063          	beq	a5,s8,56d2 <vprintf+0xba>
      } else if(c == 'l') {
    5696:	05978c63          	beq	a5,s9,56ee <vprintf+0xd6>
      } else if(c == 'x') {
    569a:	07a78863          	beq	a5,s10,570a <vprintf+0xf2>
      } else if(c == 'p') {
    569e:	09b78463          	beq	a5,s11,5726 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    56a2:	07300713          	li	a4,115
    56a6:	0ce78663          	beq	a5,a4,5772 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    56aa:	06300713          	li	a4,99
    56ae:	0ee78e63          	beq	a5,a4,57aa <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    56b2:	11478863          	beq	a5,s4,57c2 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    56b6:	85d2                	mv	a1,s4
    56b8:	8556                	mv	a0,s5
    56ba:	00000097          	auipc	ra,0x0
    56be:	e92080e7          	jalr	-366(ra) # 554c <putc>
        putc(fd, c);
    56c2:	85ca                	mv	a1,s2
    56c4:	8556                	mv	a0,s5
    56c6:	00000097          	auipc	ra,0x0
    56ca:	e86080e7          	jalr	-378(ra) # 554c <putc>
      }
      state = 0;
    56ce:	4981                	li	s3,0
    56d0:	b765                	j	5678 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    56d2:	008b0913          	addi	s2,s6,8
    56d6:	4685                	li	a3,1
    56d8:	4629                	li	a2,10
    56da:	000b2583          	lw	a1,0(s6)
    56de:	8556                	mv	a0,s5
    56e0:	00000097          	auipc	ra,0x0
    56e4:	e8e080e7          	jalr	-370(ra) # 556e <printint>
    56e8:	8b4a                	mv	s6,s2
      state = 0;
    56ea:	4981                	li	s3,0
    56ec:	b771                	j	5678 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    56ee:	008b0913          	addi	s2,s6,8
    56f2:	4681                	li	a3,0
    56f4:	4629                	li	a2,10
    56f6:	000b2583          	lw	a1,0(s6)
    56fa:	8556                	mv	a0,s5
    56fc:	00000097          	auipc	ra,0x0
    5700:	e72080e7          	jalr	-398(ra) # 556e <printint>
    5704:	8b4a                	mv	s6,s2
      state = 0;
    5706:	4981                	li	s3,0
    5708:	bf85                	j	5678 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    570a:	008b0913          	addi	s2,s6,8
    570e:	4681                	li	a3,0
    5710:	4641                	li	a2,16
    5712:	000b2583          	lw	a1,0(s6)
    5716:	8556                	mv	a0,s5
    5718:	00000097          	auipc	ra,0x0
    571c:	e56080e7          	jalr	-426(ra) # 556e <printint>
    5720:	8b4a                	mv	s6,s2
      state = 0;
    5722:	4981                	li	s3,0
    5724:	bf91                	j	5678 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    5726:	008b0793          	addi	a5,s6,8
    572a:	f8f43423          	sd	a5,-120(s0)
    572e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    5732:	03000593          	li	a1,48
    5736:	8556                	mv	a0,s5
    5738:	00000097          	auipc	ra,0x0
    573c:	e14080e7          	jalr	-492(ra) # 554c <putc>
  putc(fd, 'x');
    5740:	85ea                	mv	a1,s10
    5742:	8556                	mv	a0,s5
    5744:	00000097          	auipc	ra,0x0
    5748:	e08080e7          	jalr	-504(ra) # 554c <putc>
    574c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    574e:	03c9d793          	srli	a5,s3,0x3c
    5752:	97de                	add	a5,a5,s7
    5754:	0007c583          	lbu	a1,0(a5)
    5758:	8556                	mv	a0,s5
    575a:	00000097          	auipc	ra,0x0
    575e:	df2080e7          	jalr	-526(ra) # 554c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5762:	0992                	slli	s3,s3,0x4
    5764:	397d                	addiw	s2,s2,-1
    5766:	fe0914e3          	bnez	s2,574e <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    576a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    576e:	4981                	li	s3,0
    5770:	b721                	j	5678 <vprintf+0x60>
        s = va_arg(ap, char*);
    5772:	008b0993          	addi	s3,s6,8
    5776:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    577a:	02090163          	beqz	s2,579c <vprintf+0x184>
        while(*s != 0){
    577e:	00094583          	lbu	a1,0(s2)
    5782:	c9a1                	beqz	a1,57d2 <vprintf+0x1ba>
          putc(fd, *s);
    5784:	8556                	mv	a0,s5
    5786:	00000097          	auipc	ra,0x0
    578a:	dc6080e7          	jalr	-570(ra) # 554c <putc>
          s++;
    578e:	0905                	addi	s2,s2,1
        while(*s != 0){
    5790:	00094583          	lbu	a1,0(s2)
    5794:	f9e5                	bnez	a1,5784 <vprintf+0x16c>
        s = va_arg(ap, char*);
    5796:	8b4e                	mv	s6,s3
      state = 0;
    5798:	4981                	li	s3,0
    579a:	bdf9                	j	5678 <vprintf+0x60>
          s = "(null)";
    579c:	00003917          	auipc	s2,0x3
    57a0:	9b490913          	addi	s2,s2,-1612 # 8150 <l_free+0x270a>
        while(*s != 0){
    57a4:	02800593          	li	a1,40
    57a8:	bff1                	j	5784 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    57aa:	008b0913          	addi	s2,s6,8
    57ae:	000b4583          	lbu	a1,0(s6)
    57b2:	8556                	mv	a0,s5
    57b4:	00000097          	auipc	ra,0x0
    57b8:	d98080e7          	jalr	-616(ra) # 554c <putc>
    57bc:	8b4a                	mv	s6,s2
      state = 0;
    57be:	4981                	li	s3,0
    57c0:	bd65                	j	5678 <vprintf+0x60>
        putc(fd, c);
    57c2:	85d2                	mv	a1,s4
    57c4:	8556                	mv	a0,s5
    57c6:	00000097          	auipc	ra,0x0
    57ca:	d86080e7          	jalr	-634(ra) # 554c <putc>
      state = 0;
    57ce:	4981                	li	s3,0
    57d0:	b565                	j	5678 <vprintf+0x60>
        s = va_arg(ap, char*);
    57d2:	8b4e                	mv	s6,s3
      state = 0;
    57d4:	4981                	li	s3,0
    57d6:	b54d                	j	5678 <vprintf+0x60>
    }
  }
}
    57d8:	70e6                	ld	ra,120(sp)
    57da:	7446                	ld	s0,112(sp)
    57dc:	74a6                	ld	s1,104(sp)
    57de:	7906                	ld	s2,96(sp)
    57e0:	69e6                	ld	s3,88(sp)
    57e2:	6a46                	ld	s4,80(sp)
    57e4:	6aa6                	ld	s5,72(sp)
    57e6:	6b06                	ld	s6,64(sp)
    57e8:	7be2                	ld	s7,56(sp)
    57ea:	7c42                	ld	s8,48(sp)
    57ec:	7ca2                	ld	s9,40(sp)
    57ee:	7d02                	ld	s10,32(sp)
    57f0:	6de2                	ld	s11,24(sp)
    57f2:	6109                	addi	sp,sp,128
    57f4:	8082                	ret

00000000000057f6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    57f6:	715d                	addi	sp,sp,-80
    57f8:	ec06                	sd	ra,24(sp)
    57fa:	e822                	sd	s0,16(sp)
    57fc:	1000                	addi	s0,sp,32
    57fe:	e010                	sd	a2,0(s0)
    5800:	e414                	sd	a3,8(s0)
    5802:	e818                	sd	a4,16(s0)
    5804:	ec1c                	sd	a5,24(s0)
    5806:	03043023          	sd	a6,32(s0)
    580a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    580e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5812:	8622                	mv	a2,s0
    5814:	00000097          	auipc	ra,0x0
    5818:	e04080e7          	jalr	-508(ra) # 5618 <vprintf>
}
    581c:	60e2                	ld	ra,24(sp)
    581e:	6442                	ld	s0,16(sp)
    5820:	6161                	addi	sp,sp,80
    5822:	8082                	ret

0000000000005824 <printf>:

void
printf(const char *fmt, ...)
{
    5824:	711d                	addi	sp,sp,-96
    5826:	ec06                	sd	ra,24(sp)
    5828:	e822                	sd	s0,16(sp)
    582a:	1000                	addi	s0,sp,32
    582c:	e40c                	sd	a1,8(s0)
    582e:	e810                	sd	a2,16(s0)
    5830:	ec14                	sd	a3,24(s0)
    5832:	f018                	sd	a4,32(s0)
    5834:	f41c                	sd	a5,40(s0)
    5836:	03043823          	sd	a6,48(s0)
    583a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    583e:	00840613          	addi	a2,s0,8
    5842:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5846:	85aa                	mv	a1,a0
    5848:	4505                	li	a0,1
    584a:	00000097          	auipc	ra,0x0
    584e:	dce080e7          	jalr	-562(ra) # 5618 <vprintf>
}
    5852:	60e2                	ld	ra,24(sp)
    5854:	6442                	ld	s0,16(sp)
    5856:	6125                	addi	sp,sp,96
    5858:	8082                	ret

000000000000585a <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
    585a:	1141                	addi	sp,sp,-16
    585c:	e422                	sd	s0,8(sp)
    585e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
    5860:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5864:	00003797          	auipc	a5,0x3
    5868:	9347b783          	ld	a5,-1740(a5) # 8198 <freep>
    586c:	a805                	j	589c <free+0x42>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
    586e:	4618                	lw	a4,8(a2)
    5870:	9db9                	addw	a1,a1,a4
    5872:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5876:	6398                	ld	a4,0(a5)
    5878:	6318                	ld	a4,0(a4)
    587a:	fee53823          	sd	a4,-16(a0)
    587e:	a091                	j	58c2 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
    5880:	ff852703          	lw	a4,-8(a0)
    5884:	9e39                	addw	a2,a2,a4
    5886:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    5888:	ff053703          	ld	a4,-16(a0)
    588c:	e398                	sd	a4,0(a5)
    588e:	a099                	j	58d4 <free+0x7a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5890:	6398                	ld	a4,0(a5)
    5892:	00e7e463          	bltu	a5,a4,589a <free+0x40>
    5896:	00e6ea63          	bltu	a3,a4,58aa <free+0x50>
void free(void *ap) {
    589a:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    589c:	fed7fae3          	bgeu	a5,a3,5890 <free+0x36>
    58a0:	6398                	ld	a4,0(a5)
    58a2:	00e6e463          	bltu	a3,a4,58aa <free+0x50>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    58a6:	fee7eae3          	bltu	a5,a4,589a <free+0x40>
  if (bp + bp->s.size == p->s.ptr) {
    58aa:	ff852583          	lw	a1,-8(a0)
    58ae:	6390                	ld	a2,0(a5)
    58b0:	02059713          	slli	a4,a1,0x20
    58b4:	9301                	srli	a4,a4,0x20
    58b6:	0712                	slli	a4,a4,0x4
    58b8:	9736                	add	a4,a4,a3
    58ba:	fae60ae3          	beq	a2,a4,586e <free+0x14>
    bp->s.ptr = p->s.ptr;
    58be:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
    58c2:	4790                	lw	a2,8(a5)
    58c4:	02061713          	slli	a4,a2,0x20
    58c8:	9301                	srli	a4,a4,0x20
    58ca:	0712                	slli	a4,a4,0x4
    58cc:	973e                	add	a4,a4,a5
    58ce:	fae689e3          	beq	a3,a4,5880 <free+0x26>
  } else
    p->s.ptr = bp;
    58d2:	e394                	sd	a3,0(a5)
  freep = p;
    58d4:	00003717          	auipc	a4,0x3
    58d8:	8cf73223          	sd	a5,-1852(a4) # 8198 <freep>
}
    58dc:	6422                	ld	s0,8(sp)
    58de:	0141                	addi	sp,sp,16
    58e0:	8082                	ret

00000000000058e2 <malloc>:
  hp->s.size = nu;
  free((void *)(hp + 1));
  return freep;
}

void *malloc(uint nbytes) {
    58e2:	7139                	addi	sp,sp,-64
    58e4:	fc06                	sd	ra,56(sp)
    58e6:	f822                	sd	s0,48(sp)
    58e8:	f426                	sd	s1,40(sp)
    58ea:	f04a                	sd	s2,32(sp)
    58ec:	ec4e                	sd	s3,24(sp)
    58ee:	e852                	sd	s4,16(sp)
    58f0:	e456                	sd	s5,8(sp)
    58f2:	e05a                	sd	s6,0(sp)
    58f4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
    58f6:	02051493          	slli	s1,a0,0x20
    58fa:	9081                	srli	s1,s1,0x20
    58fc:	04bd                	addi	s1,s1,15
    58fe:	8091                	srli	s1,s1,0x4
    5900:	0014899b          	addiw	s3,s1,1
    5904:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
    5906:	00003517          	auipc	a0,0x3
    590a:	89253503          	ld	a0,-1902(a0) # 8198 <freep>
    590e:	c515                	beqz	a0,593a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    5910:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    5912:	4798                	lw	a4,8(a5)
    5914:	02977f63          	bgeu	a4,s1,5952 <malloc+0x70>
    5918:	8a4e                	mv	s4,s3
    591a:	0009871b          	sext.w	a4,s3
    591e:	6685                	lui	a3,0x1
    5920:	00d77363          	bgeu	a4,a3,5926 <malloc+0x44>
    5924:	6a05                	lui	s4,0x1
    5926:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    592a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
    592e:	00003917          	auipc	s2,0x3
    5932:	86a90913          	addi	s2,s2,-1942 # 8198 <freep>
  if (p == (char *)-1)
    5936:	5afd                	li	s5,-1
    5938:	a88d                	j	59aa <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    593a:	00009797          	auipc	a5,0x9
    593e:	07e78793          	addi	a5,a5,126 # e9b8 <base>
    5942:	00003717          	auipc	a4,0x3
    5946:	84f73b23          	sd	a5,-1962(a4) # 8198 <freep>
    594a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    594c:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
    5950:	b7e1                	j	5918 <malloc+0x36>
      if (p->s.size == nunits)
    5952:	02e48b63          	beq	s1,a4,5988 <malloc+0xa6>
        p->s.size -= nunits;
    5956:	4137073b          	subw	a4,a4,s3
    595a:	c798                	sw	a4,8(a5)
        p += p->s.size;
    595c:	1702                	slli	a4,a4,0x20
    595e:	9301                	srli	a4,a4,0x20
    5960:	0712                	slli	a4,a4,0x4
    5962:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5964:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5968:	00003717          	auipc	a4,0x3
    596c:	82a73823          	sd	a0,-2000(a4) # 8198 <freep>
      return (void *)(p + 1);
    5970:	01078513          	addi	a0,a5,16
      if ((p = morecore(nunits)) == 0)
        return 0;
  }
}
    5974:	70e2                	ld	ra,56(sp)
    5976:	7442                	ld	s0,48(sp)
    5978:	74a2                	ld	s1,40(sp)
    597a:	7902                	ld	s2,32(sp)
    597c:	69e2                	ld	s3,24(sp)
    597e:	6a42                	ld	s4,16(sp)
    5980:	6aa2                	ld	s5,8(sp)
    5982:	6b02                	ld	s6,0(sp)
    5984:	6121                	addi	sp,sp,64
    5986:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    5988:	6398                	ld	a4,0(a5)
    598a:	e118                	sd	a4,0(a0)
    598c:	bff1                	j	5968 <malloc+0x86>
  hp->s.size = nu;
    598e:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
    5992:	0541                	addi	a0,a0,16
    5994:	00000097          	auipc	ra,0x0
    5998:	ec6080e7          	jalr	-314(ra) # 585a <free>
  return freep;
    599c:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0)
    59a0:	d971                	beqz	a0,5974 <malloc+0x92>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    59a2:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    59a4:	4798                	lw	a4,8(a5)
    59a6:	fa9776e3          	bgeu	a4,s1,5952 <malloc+0x70>
    if (p == freep)
    59aa:	00093703          	ld	a4,0(s2)
    59ae:	853e                	mv	a0,a5
    59b0:	fef719e3          	bne	a4,a5,59a2 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    59b4:	8552                	mv	a0,s4
    59b6:	00000097          	auipc	ra,0x0
    59ba:	b7e080e7          	jalr	-1154(ra) # 5534 <sbrk>
  if (p == (char *)-1)
    59be:	fd5518e3          	bne	a0,s5,598e <malloc+0xac>
        return 0;
    59c2:	4501                	li	a0,0
    59c4:	bf45                	j	5974 <malloc+0x92>

00000000000059c6 <mem_init>:
  page_t *next_page;
} allocator_t;

static allocator_t alloc;
static int if_init = 0;
void mem_init() {
    59c6:	1141                	addi	sp,sp,-16
    59c8:	e406                	sd	ra,8(sp)
    59ca:	e022                	sd	s0,0(sp)
    59cc:	0800                	addi	s0,sp,16
  alloc.next_page = (page_t *)sbrk(PGSIZE);
    59ce:	6505                	lui	a0,0x1
    59d0:	00000097          	auipc	ra,0x0
    59d4:	b64080e7          	jalr	-1180(ra) # 5534 <sbrk>
    59d8:	00002797          	auipc	a5,0x2
    59dc:	7aa7bc23          	sd	a0,1976(a5) # 8190 <alloc>
  page_t *p = (page_t *)alloc.next_page;
  p->cur = (void *)p + sizeof(page_t);
    59e0:	00850793          	addi	a5,a0,8 # 1008 <linktest+0x1da>
    59e4:	e11c                	sd	a5,0(a0)
}
    59e6:	60a2                	ld	ra,8(sp)
    59e8:	6402                	ld	s0,0(sp)
    59ea:	0141                	addi	sp,sp,16
    59ec:	8082                	ret

00000000000059ee <l_alloc>:

void *l_alloc(u32 size) {
    59ee:	1101                	addi	sp,sp,-32
    59f0:	ec06                	sd	ra,24(sp)
    59f2:	e822                	sd	s0,16(sp)
    59f4:	e426                	sd	s1,8(sp)
    59f6:	1000                	addi	s0,sp,32
    59f8:	84aa                	mv	s1,a0
  if (!if_init) {
    59fa:	00002797          	auipc	a5,0x2
    59fe:	78e7a783          	lw	a5,1934(a5) # 8188 <if_init>
    5a02:	c795                	beqz	a5,5a2e <l_alloc+0x40>
    mem_init();
    if_init = 1;
  }
  void *res = 0;
  u32 avail = PGSIZE - (alloc.next_page->cur - (void *)(alloc.next_page)) -
    5a04:	00002717          	auipc	a4,0x2
    5a08:	78c73703          	ld	a4,1932(a4) # 8190 <alloc>
    5a0c:	6308                	ld	a0,0(a4)
    5a0e:	40e506b3          	sub	a3,a0,a4
              sizeof(page_t);
  if (avail > size) {
    5a12:	6785                	lui	a5,0x1
    5a14:	37e1                	addiw	a5,a5,-8
    5a16:	9f95                	subw	a5,a5,a3
    5a18:	02f4f563          	bgeu	s1,a5,5a42 <l_alloc+0x54>
    res = alloc.next_page->cur;
    alloc.next_page->cur += size;
    5a1c:	1482                	slli	s1,s1,0x20
    5a1e:	9081                	srli	s1,s1,0x20
    5a20:	94aa                	add	s1,s1,a0
    5a22:	e304                	sd	s1,0(a4)
  } else {
    return 0;
  }
  return res;
}
    5a24:	60e2                	ld	ra,24(sp)
    5a26:	6442                	ld	s0,16(sp)
    5a28:	64a2                	ld	s1,8(sp)
    5a2a:	6105                	addi	sp,sp,32
    5a2c:	8082                	ret
    mem_init();
    5a2e:	00000097          	auipc	ra,0x0
    5a32:	f98080e7          	jalr	-104(ra) # 59c6 <mem_init>
    if_init = 1;
    5a36:	4785                	li	a5,1
    5a38:	00002717          	auipc	a4,0x2
    5a3c:	74f72823          	sw	a5,1872(a4) # 8188 <if_init>
    5a40:	b7d1                	j	5a04 <l_alloc+0x16>
    return 0;
    5a42:	4501                	li	a0,0
    5a44:	b7c5                	j	5a24 <l_alloc+0x36>

0000000000005a46 <l_free>:

    5a46:	1141                	addi	sp,sp,-16
    5a48:	e422                	sd	s0,8(sp)
    5a4a:	0800                	addi	s0,sp,16
    5a4c:	6422                	ld	s0,8(sp)
    5a4e:	0141                	addi	sp,sp,16
    5a50:	8082                	ret
