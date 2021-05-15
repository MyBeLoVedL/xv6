
user/_alarmtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <periodic>:
  exit(0);
}

volatile static int count;

void periodic() {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  count = count + 1;
   8:	00001797          	auipc	a5,0x1
   c:	1387a783          	lw	a5,312(a5) # 1140 <count>
  10:	2785                	addiw	a5,a5,1
  12:	00001717          	auipc	a4,0x1
  16:	12f72723          	sw	a5,302(a4) # 1140 <count>
  printf("alarm!\n");
  1a:	00001517          	auipc	a0,0x1
  1e:	ea650513          	addi	a0,a0,-346 # ec0 <strstr+0x58>
  22:	00001097          	auipc	ra,0x1
  26:	9d2080e7          	jalr	-1582(ra) # 9f4 <printf>
  alarmret();
  2a:	00000097          	auipc	ra,0x0
  2e:	6ea080e7          	jalr	1770(ra) # 714 <alarmret>
}
  32:	60a2                	ld	ra,8(sp)
  34:	6402                	ld	s0,0(sp)
  36:	0141                	addi	sp,sp,16
  38:	8082                	ret

000000000000003a <slow_handler>:
  if (status == 0) {
    printf("test2 passed\n");
  }
}

void slow_handler() {
  3a:	1101                	addi	sp,sp,-32
  3c:	ec06                	sd	ra,24(sp)
  3e:	e822                	sd	s0,16(sp)
  40:	e426                	sd	s1,8(sp)
  42:	1000                	addi	s0,sp,32
  printf("count : %d\n", count);
  44:	00001597          	auipc	a1,0x1
  48:	0fc5a583          	lw	a1,252(a1) # 1140 <count>
  4c:	00001517          	auipc	a0,0x1
  50:	e7c50513          	addi	a0,a0,-388 # ec8 <strstr+0x60>
  54:	00001097          	auipc	ra,0x1
  58:	9a0080e7          	jalr	-1632(ra) # 9f4 <printf>
  count++;
  5c:	00001497          	auipc	s1,0x1
  60:	0e448493          	addi	s1,s1,228 # 1140 <count>
  64:	00001797          	auipc	a5,0x1
  68:	0dc7a783          	lw	a5,220(a5) # 1140 <count>
  6c:	2785                	addiw	a5,a5,1
  6e:	c09c                	sw	a5,0(s1)
  printf("alarm!\n");
  70:	00001517          	auipc	a0,0x1
  74:	e5050513          	addi	a0,a0,-432 # ec0 <strstr+0x58>
  78:	00001097          	auipc	ra,0x1
  7c:	97c080e7          	jalr	-1668(ra) # 9f4 <printf>
  if (count > 1) {
  80:	4098                	lw	a4,0(s1)
  82:	2701                	sext.w	a4,a4
  84:	4685                	li	a3,1
  86:	1dcd67b7          	lui	a5,0x1dcd6
  8a:	50078793          	addi	a5,a5,1280 # 1dcd6500 <__global_pointer$+0x1dcd4bc5>
  8e:	02e6c463          	blt	a3,a4,b6 <slow_handler+0x7c>
    printf("test2 failed: alarm handler called more than once\n");
    exit(1);
  }
  for (int i = 0; i < 1000 * 500000; i++) {
    asm volatile("nop"); // avoid compiler optimizing away loop
  92:	0001                	nop
  for (int i = 0; i < 1000 * 500000; i++) {
  94:	37fd                	addiw	a5,a5,-1
  96:	fff5                	bnez	a5,92 <slow_handler+0x58>
  }
  alarm(0, 0);
  98:	4581                	li	a1,0
  9a:	4501                	li	a0,0
  9c:	00000097          	auipc	ra,0x0
  a0:	670080e7          	jalr	1648(ra) # 70c <alarm>
  alarmret();
  a4:	00000097          	auipc	ra,0x0
  a8:	670080e7          	jalr	1648(ra) # 714 <alarmret>
}
  ac:	60e2                	ld	ra,24(sp)
  ae:	6442                	ld	s0,16(sp)
  b0:	64a2                	ld	s1,8(sp)
  b2:	6105                	addi	sp,sp,32
  b4:	8082                	ret
    printf("test2 failed: alarm handler called more than once\n");
  b6:	00001517          	auipc	a0,0x1
  ba:	e2250513          	addi	a0,a0,-478 # ed8 <strstr+0x70>
  be:	00001097          	auipc	ra,0x1
  c2:	936080e7          	jalr	-1738(ra) # 9f4 <printf>
    exit(1);
  c6:	4505                	li	a0,1
  c8:	00000097          	auipc	ra,0x0
  cc:	59c080e7          	jalr	1436(ra) # 664 <exit>

00000000000000d0 <test0>:
void test0() {
  d0:	7139                	addi	sp,sp,-64
  d2:	fc06                	sd	ra,56(sp)
  d4:	f822                	sd	s0,48(sp)
  d6:	f426                	sd	s1,40(sp)
  d8:	f04a                	sd	s2,32(sp)
  da:	ec4e                	sd	s3,24(sp)
  dc:	e852                	sd	s4,16(sp)
  de:	e456                	sd	s5,8(sp)
  e0:	0080                	addi	s0,sp,64
  printf("test0 start\n");
  e2:	00001517          	auipc	a0,0x1
  e6:	e2e50513          	addi	a0,a0,-466 # f10 <strstr+0xa8>
  ea:	00001097          	auipc	ra,0x1
  ee:	90a080e7          	jalr	-1782(ra) # 9f4 <printf>
  count = 0;
  f2:	00001797          	auipc	a5,0x1
  f6:	0407a723          	sw	zero,78(a5) # 1140 <count>
  alarm(2, periodic);
  fa:	00000597          	auipc	a1,0x0
  fe:	f0658593          	addi	a1,a1,-250 # 0 <periodic>
 102:	4509                	li	a0,2
 104:	00000097          	auipc	ra,0x0
 108:	608080e7          	jalr	1544(ra) # 70c <alarm>
  for (i = 0; i < 1000 * 500000; i++) {
 10c:	4481                	li	s1,0
    if ((i % 1000000) == 0)
 10e:	000f4937          	lui	s2,0xf4
 112:	2409091b          	addiw	s2,s2,576
      write(2, ".", 1);
 116:	00001a97          	auipc	s5,0x1
 11a:	e0aa8a93          	addi	s5,s5,-502 # f20 <strstr+0xb8>
    if (count > 0)
 11e:	00001a17          	auipc	s4,0x1
 122:	022a0a13          	addi	s4,s4,34 # 1140 <count>
  for (i = 0; i < 1000 * 500000; i++) {
 126:	1dcd69b7          	lui	s3,0x1dcd6
 12a:	50098993          	addi	s3,s3,1280 # 1dcd6500 <__global_pointer$+0x1dcd4bc5>
 12e:	a809                	j	140 <test0+0x70>
    if (count > 0)
 130:	000a2783          	lw	a5,0(s4)
 134:	2781                	sext.w	a5,a5
 136:	02f04063          	bgtz	a5,156 <test0+0x86>
  for (i = 0; i < 1000 * 500000; i++) {
 13a:	2485                	addiw	s1,s1,1
 13c:	01348d63          	beq	s1,s3,156 <test0+0x86>
    if ((i % 1000000) == 0)
 140:	0324e7bb          	remw	a5,s1,s2
 144:	f7f5                	bnez	a5,130 <test0+0x60>
      write(2, ".", 1);
 146:	4605                	li	a2,1
 148:	85d6                	mv	a1,s5
 14a:	4509                	li	a0,2
 14c:	00000097          	auipc	ra,0x0
 150:	538080e7          	jalr	1336(ra) # 684 <write>
 154:	bff1                	j	130 <test0+0x60>
  alarm(0, 0);
 156:	4581                	li	a1,0
 158:	4501                	li	a0,0
 15a:	00000097          	auipc	ra,0x0
 15e:	5b2080e7          	jalr	1458(ra) # 70c <alarm>
  if (count > 0) {
 162:	00001797          	auipc	a5,0x1
 166:	fde7a783          	lw	a5,-34(a5) # 1140 <count>
 16a:	02f05363          	blez	a5,190 <test0+0xc0>
    printf("test0 passed\n");
 16e:	00001517          	auipc	a0,0x1
 172:	dba50513          	addi	a0,a0,-582 # f28 <strstr+0xc0>
 176:	00001097          	auipc	ra,0x1
 17a:	87e080e7          	jalr	-1922(ra) # 9f4 <printf>
}
 17e:	70e2                	ld	ra,56(sp)
 180:	7442                	ld	s0,48(sp)
 182:	74a2                	ld	s1,40(sp)
 184:	7902                	ld	s2,32(sp)
 186:	69e2                	ld	s3,24(sp)
 188:	6a42                	ld	s4,16(sp)
 18a:	6aa2                	ld	s5,8(sp)
 18c:	6121                	addi	sp,sp,64
 18e:	8082                	ret
    printf("\ntest0 failed: the kernel never called the alarm handler\n");
 190:	00001517          	auipc	a0,0x1
 194:	da850513          	addi	a0,a0,-600 # f38 <strstr+0xd0>
 198:	00001097          	auipc	ra,0x1
 19c:	85c080e7          	jalr	-1956(ra) # 9f4 <printf>
}
 1a0:	bff9                	j	17e <test0+0xae>

00000000000001a2 <foo>:
void __attribute__((noinline)) foo(int i, int *j) {
 1a2:	1101                	addi	sp,sp,-32
 1a4:	ec06                	sd	ra,24(sp)
 1a6:	e822                	sd	s0,16(sp)
 1a8:	e426                	sd	s1,8(sp)
 1aa:	1000                	addi	s0,sp,32
 1ac:	84ae                	mv	s1,a1
  if ((i % 2500000) == 0) {
 1ae:	002627b7          	lui	a5,0x262
 1b2:	5a07879b          	addiw	a5,a5,1440
 1b6:	02f5653b          	remw	a0,a0,a5
 1ba:	c909                	beqz	a0,1cc <foo+0x2a>
  *j += 1;
 1bc:	409c                	lw	a5,0(s1)
 1be:	2785                	addiw	a5,a5,1
 1c0:	c09c                	sw	a5,0(s1)
}
 1c2:	60e2                	ld	ra,24(sp)
 1c4:	6442                	ld	s0,16(sp)
 1c6:	64a2                	ld	s1,8(sp)
 1c8:	6105                	addi	sp,sp,32
 1ca:	8082                	ret
    write(2, ".", 1);
 1cc:	4605                	li	a2,1
 1ce:	00001597          	auipc	a1,0x1
 1d2:	d5258593          	addi	a1,a1,-686 # f20 <strstr+0xb8>
 1d6:	4509                	li	a0,2
 1d8:	00000097          	auipc	ra,0x0
 1dc:	4ac080e7          	jalr	1196(ra) # 684 <write>
 1e0:	bff1                	j	1bc <foo+0x1a>

00000000000001e2 <test1>:
void test1() {
 1e2:	7139                	addi	sp,sp,-64
 1e4:	fc06                	sd	ra,56(sp)
 1e6:	f822                	sd	s0,48(sp)
 1e8:	f426                	sd	s1,40(sp)
 1ea:	f04a                	sd	s2,32(sp)
 1ec:	ec4e                	sd	s3,24(sp)
 1ee:	e852                	sd	s4,16(sp)
 1f0:	0080                	addi	s0,sp,64
  printf("test1 start\n");
 1f2:	00001517          	auipc	a0,0x1
 1f6:	d8650513          	addi	a0,a0,-634 # f78 <strstr+0x110>
 1fa:	00000097          	auipc	ra,0x0
 1fe:	7fa080e7          	jalr	2042(ra) # 9f4 <printf>
  count = 0;
 202:	00001797          	auipc	a5,0x1
 206:	f207af23          	sw	zero,-194(a5) # 1140 <count>
  j = 0;
 20a:	fc042623          	sw	zero,-52(s0)
  alarm(2, periodic);
 20e:	00000597          	auipc	a1,0x0
 212:	df258593          	addi	a1,a1,-526 # 0 <periodic>
 216:	4509                	li	a0,2
 218:	00000097          	auipc	ra,0x0
 21c:	4f4080e7          	jalr	1268(ra) # 70c <alarm>
  for (i = 0; i < 500000000; i++) {
 220:	4481                	li	s1,0
    if (count >= 10)
 222:	00001a17          	auipc	s4,0x1
 226:	f1ea0a13          	addi	s4,s4,-226 # 1140 <count>
 22a:	49a5                	li	s3,9
  for (i = 0; i < 500000000; i++) {
 22c:	1dcd6937          	lui	s2,0x1dcd6
 230:	50090913          	addi	s2,s2,1280 # 1dcd6500 <__global_pointer$+0x1dcd4bc5>
    if (count >= 10)
 234:	000a2783          	lw	a5,0(s4)
 238:	2781                	sext.w	a5,a5
 23a:	00f9cc63          	blt	s3,a5,252 <test1+0x70>
    foo(i, &j);
 23e:	fcc40593          	addi	a1,s0,-52
 242:	8526                	mv	a0,s1
 244:	00000097          	auipc	ra,0x0
 248:	f5e080e7          	jalr	-162(ra) # 1a2 <foo>
  for (i = 0; i < 500000000; i++) {
 24c:	2485                	addiw	s1,s1,1
 24e:	ff2493e3          	bne	s1,s2,234 <test1+0x52>
  if (count < 10) {
 252:	00001717          	auipc	a4,0x1
 256:	eee72703          	lw	a4,-274(a4) # 1140 <count>
 25a:	47a5                	li	a5,9
 25c:	02e7d663          	bge	a5,a4,288 <test1+0xa6>
  } else if (i != j) {
 260:	fcc42783          	lw	a5,-52(s0)
 264:	02978b63          	beq	a5,s1,29a <test1+0xb8>
    printf("\ntest1 failed: foo() executed fewer times than it was called\n");
 268:	00001517          	auipc	a0,0x1
 26c:	d5050513          	addi	a0,a0,-688 # fb8 <strstr+0x150>
 270:	00000097          	auipc	ra,0x0
 274:	784080e7          	jalr	1924(ra) # 9f4 <printf>
}
 278:	70e2                	ld	ra,56(sp)
 27a:	7442                	ld	s0,48(sp)
 27c:	74a2                	ld	s1,40(sp)
 27e:	7902                	ld	s2,32(sp)
 280:	69e2                	ld	s3,24(sp)
 282:	6a42                	ld	s4,16(sp)
 284:	6121                	addi	sp,sp,64
 286:	8082                	ret
    printf("\ntest1 failed: too few calls to the handler\n");
 288:	00001517          	auipc	a0,0x1
 28c:	d0050513          	addi	a0,a0,-768 # f88 <strstr+0x120>
 290:	00000097          	auipc	ra,0x0
 294:	764080e7          	jalr	1892(ra) # 9f4 <printf>
 298:	b7c5                	j	278 <test1+0x96>
    printf("test1 passed\n");
 29a:	00001517          	auipc	a0,0x1
 29e:	d5e50513          	addi	a0,a0,-674 # ff8 <strstr+0x190>
 2a2:	00000097          	auipc	ra,0x0
 2a6:	752080e7          	jalr	1874(ra) # 9f4 <printf>
}
 2aa:	b7f9                	j	278 <test1+0x96>

00000000000002ac <test2>:
void test2() {
 2ac:	715d                	addi	sp,sp,-80
 2ae:	e486                	sd	ra,72(sp)
 2b0:	e0a2                	sd	s0,64(sp)
 2b2:	fc26                	sd	s1,56(sp)
 2b4:	f84a                	sd	s2,48(sp)
 2b6:	f44e                	sd	s3,40(sp)
 2b8:	f052                	sd	s4,32(sp)
 2ba:	ec56                	sd	s5,24(sp)
 2bc:	0880                	addi	s0,sp,80
  printf("test2 start\n");
 2be:	00001517          	auipc	a0,0x1
 2c2:	d4a50513          	addi	a0,a0,-694 # 1008 <strstr+0x1a0>
 2c6:	00000097          	auipc	ra,0x0
 2ca:	72e080e7          	jalr	1838(ra) # 9f4 <printf>
  if ((pid = fork()) < 0) {
 2ce:	00000097          	auipc	ra,0x0
 2d2:	38e080e7          	jalr	910(ra) # 65c <fork>
 2d6:	04054e63          	bltz	a0,332 <test2+0x86>
 2da:	84aa                	mv	s1,a0
  if (pid == 0) {
 2dc:	e13d                	bnez	a0,342 <test2+0x96>
    count = 0;
 2de:	00001797          	auipc	a5,0x1
 2e2:	e6278793          	addi	a5,a5,-414 # 1140 <count>
 2e6:	0007a023          	sw	zero,0(a5)
    printf("before count:%d\n", count);
 2ea:	438c                	lw	a1,0(a5)
 2ec:	2581                	sext.w	a1,a1
 2ee:	00001517          	auipc	a0,0x1
 2f2:	d4250513          	addi	a0,a0,-702 # 1030 <strstr+0x1c8>
 2f6:	00000097          	auipc	ra,0x0
 2fa:	6fe080e7          	jalr	1790(ra) # 9f4 <printf>
    alarm(2, slow_handler);
 2fe:	00000597          	auipc	a1,0x0
 302:	d3c58593          	addi	a1,a1,-708 # 3a <slow_handler>
 306:	4509                	li	a0,2
 308:	00000097          	auipc	ra,0x0
 30c:	404080e7          	jalr	1028(ra) # 70c <alarm>
      if ((i % 1000000) == 0)
 310:	000f4937          	lui	s2,0xf4
 314:	2409091b          	addiw	s2,s2,576
        write(2, ".", 1);
 318:	00001a97          	auipc	s5,0x1
 31c:	c08a8a93          	addi	s5,s5,-1016 # f20 <strstr+0xb8>
      if (count > 0)
 320:	00001a17          	auipc	s4,0x1
 324:	e20a0a13          	addi	s4,s4,-480 # 1140 <count>
    for (i = 0; i < 1000 * 500000; i++) {
 328:	1dcd69b7          	lui	s3,0x1dcd6
 32c:	50098993          	addi	s3,s3,1280 # 1dcd6500 <__global_pointer$+0x1dcd4bc5>
 330:	a099                	j	376 <test2+0xca>
    printf("test2: fork failed\n");
 332:	00001517          	auipc	a0,0x1
 336:	ce650513          	addi	a0,a0,-794 # 1018 <strstr+0x1b0>
 33a:	00000097          	auipc	ra,0x0
 33e:	6ba080e7          	jalr	1722(ra) # 9f4 <printf>
  wait(&status);
 342:	fbc40513          	addi	a0,s0,-68
 346:	00000097          	auipc	ra,0x0
 34a:	326080e7          	jalr	806(ra) # 66c <wait>
  if (status == 0) {
 34e:	fbc42783          	lw	a5,-68(s0)
 352:	c7a5                	beqz	a5,3ba <test2+0x10e>
}
 354:	60a6                	ld	ra,72(sp)
 356:	6406                	ld	s0,64(sp)
 358:	74e2                	ld	s1,56(sp)
 35a:	7942                	ld	s2,48(sp)
 35c:	79a2                	ld	s3,40(sp)
 35e:	7a02                	ld	s4,32(sp)
 360:	6ae2                	ld	s5,24(sp)
 362:	6161                	addi	sp,sp,80
 364:	8082                	ret
      if (count > 0)
 366:	000a2783          	lw	a5,0(s4)
 36a:	2781                	sext.w	a5,a5
 36c:	02f04063          	bgtz	a5,38c <test2+0xe0>
    for (i = 0; i < 1000 * 500000; i++) {
 370:	2485                	addiw	s1,s1,1
 372:	01348d63          	beq	s1,s3,38c <test2+0xe0>
      if ((i % 1000000) == 0)
 376:	0324e7bb          	remw	a5,s1,s2
 37a:	f7f5                	bnez	a5,366 <test2+0xba>
        write(2, ".", 1);
 37c:	4605                	li	a2,1
 37e:	85d6                	mv	a1,s5
 380:	4509                	li	a0,2
 382:	00000097          	auipc	ra,0x0
 386:	302080e7          	jalr	770(ra) # 684 <write>
 38a:	bff1                	j	366 <test2+0xba>
    if (count == 0) {
 38c:	00001797          	auipc	a5,0x1
 390:	db47a783          	lw	a5,-588(a5) # 1140 <count>
 394:	ef91                	bnez	a5,3b0 <test2+0x104>
      printf("\ntest2 failed: alarm not called\n");
 396:	00001517          	auipc	a0,0x1
 39a:	cb250513          	addi	a0,a0,-846 # 1048 <strstr+0x1e0>
 39e:	00000097          	auipc	ra,0x0
 3a2:	656080e7          	jalr	1622(ra) # 9f4 <printf>
      exit(1);
 3a6:	4505                	li	a0,1
 3a8:	00000097          	auipc	ra,0x0
 3ac:	2bc080e7          	jalr	700(ra) # 664 <exit>
    exit(0);
 3b0:	4501                	li	a0,0
 3b2:	00000097          	auipc	ra,0x0
 3b6:	2b2080e7          	jalr	690(ra) # 664 <exit>
    printf("test2 passed\n");
 3ba:	00001517          	auipc	a0,0x1
 3be:	cb650513          	addi	a0,a0,-842 # 1070 <strstr+0x208>
 3c2:	00000097          	auipc	ra,0x0
 3c6:	632080e7          	jalr	1586(ra) # 9f4 <printf>
}
 3ca:	b769                	j	354 <test2+0xa8>

00000000000003cc <main>:
int main(int argc, char *argv[]) {
 3cc:	1141                	addi	sp,sp,-16
 3ce:	e406                	sd	ra,8(sp)
 3d0:	e022                	sd	s0,0(sp)
 3d2:	0800                	addi	s0,sp,16
  test0();
 3d4:	00000097          	auipc	ra,0x0
 3d8:	cfc080e7          	jalr	-772(ra) # d0 <test0>
  test1();
 3dc:	00000097          	auipc	ra,0x0
 3e0:	e06080e7          	jalr	-506(ra) # 1e2 <test1>
  test2();
 3e4:	00000097          	auipc	ra,0x0
 3e8:	ec8080e7          	jalr	-312(ra) # 2ac <test2>
  exit(0);
 3ec:	4501                	li	a0,0
 3ee:	00000097          	auipc	ra,0x0
 3f2:	276080e7          	jalr	630(ra) # 664 <exit>

00000000000003f6 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 3f6:	1141                	addi	sp,sp,-16
 3f8:	e422                	sd	s0,8(sp)
 3fa:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3fc:	87aa                	mv	a5,a0
 3fe:	0585                	addi	a1,a1,1
 400:	0785                	addi	a5,a5,1
 402:	fff5c703          	lbu	a4,-1(a1)
 406:	fee78fa3          	sb	a4,-1(a5)
 40a:	fb75                	bnez	a4,3fe <strcpy+0x8>
    ;
  return os;
}
 40c:	6422                	ld	s0,8(sp)
 40e:	0141                	addi	sp,sp,16
 410:	8082                	ret

0000000000000412 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 412:	1141                	addi	sp,sp,-16
 414:	e422                	sd	s0,8(sp)
 416:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 418:	00054783          	lbu	a5,0(a0)
 41c:	cb91                	beqz	a5,430 <strcmp+0x1e>
 41e:	0005c703          	lbu	a4,0(a1)
 422:	00f71763          	bne	a4,a5,430 <strcmp+0x1e>
    p++, q++;
 426:	0505                	addi	a0,a0,1
 428:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 42a:	00054783          	lbu	a5,0(a0)
 42e:	fbe5                	bnez	a5,41e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 430:	0005c503          	lbu	a0,0(a1)
}
 434:	40a7853b          	subw	a0,a5,a0
 438:	6422                	ld	s0,8(sp)
 43a:	0141                	addi	sp,sp,16
 43c:	8082                	ret

000000000000043e <strlen>:

uint
strlen(const char *s)
{
 43e:	1141                	addi	sp,sp,-16
 440:	e422                	sd	s0,8(sp)
 442:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 444:	00054783          	lbu	a5,0(a0)
 448:	cf91                	beqz	a5,464 <strlen+0x26>
 44a:	0505                	addi	a0,a0,1
 44c:	87aa                	mv	a5,a0
 44e:	4685                	li	a3,1
 450:	9e89                	subw	a3,a3,a0
 452:	00f6853b          	addw	a0,a3,a5
 456:	0785                	addi	a5,a5,1
 458:	fff7c703          	lbu	a4,-1(a5)
 45c:	fb7d                	bnez	a4,452 <strlen+0x14>
    ;
  return n;
}
 45e:	6422                	ld	s0,8(sp)
 460:	0141                	addi	sp,sp,16
 462:	8082                	ret
  for(n = 0; s[n]; n++)
 464:	4501                	li	a0,0
 466:	bfe5                	j	45e <strlen+0x20>

0000000000000468 <memset>:

void*
memset(void *dst, int c, uint n)
{
 468:	1141                	addi	sp,sp,-16
 46a:	e422                	sd	s0,8(sp)
 46c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 46e:	ca19                	beqz	a2,484 <memset+0x1c>
 470:	87aa                	mv	a5,a0
 472:	1602                	slli	a2,a2,0x20
 474:	9201                	srli	a2,a2,0x20
 476:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 47a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 47e:	0785                	addi	a5,a5,1
 480:	fee79de3          	bne	a5,a4,47a <memset+0x12>
  }
  return dst;
}
 484:	6422                	ld	s0,8(sp)
 486:	0141                	addi	sp,sp,16
 488:	8082                	ret

000000000000048a <strchr>:

char*
strchr(const char *s, char c)
{
 48a:	1141                	addi	sp,sp,-16
 48c:	e422                	sd	s0,8(sp)
 48e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 490:	00054783          	lbu	a5,0(a0)
 494:	cb99                	beqz	a5,4aa <strchr+0x20>
    if(*s == c)
 496:	00f58763          	beq	a1,a5,4a4 <strchr+0x1a>
  for(; *s; s++)
 49a:	0505                	addi	a0,a0,1
 49c:	00054783          	lbu	a5,0(a0)
 4a0:	fbfd                	bnez	a5,496 <strchr+0xc>
      return (char*)s;
  return 0;
 4a2:	4501                	li	a0,0
}
 4a4:	6422                	ld	s0,8(sp)
 4a6:	0141                	addi	sp,sp,16
 4a8:	8082                	ret
  return 0;
 4aa:	4501                	li	a0,0
 4ac:	bfe5                	j	4a4 <strchr+0x1a>

00000000000004ae <gets>:

char*
gets(char *buf, int max)
{
 4ae:	711d                	addi	sp,sp,-96
 4b0:	ec86                	sd	ra,88(sp)
 4b2:	e8a2                	sd	s0,80(sp)
 4b4:	e4a6                	sd	s1,72(sp)
 4b6:	e0ca                	sd	s2,64(sp)
 4b8:	fc4e                	sd	s3,56(sp)
 4ba:	f852                	sd	s4,48(sp)
 4bc:	f456                	sd	s5,40(sp)
 4be:	f05a                	sd	s6,32(sp)
 4c0:	ec5e                	sd	s7,24(sp)
 4c2:	1080                	addi	s0,sp,96
 4c4:	8baa                	mv	s7,a0
 4c6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4c8:	892a                	mv	s2,a0
 4ca:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 4cc:	4aa9                	li	s5,10
 4ce:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 4d0:	89a6                	mv	s3,s1
 4d2:	2485                	addiw	s1,s1,1
 4d4:	0344d863          	bge	s1,s4,504 <gets+0x56>
    cc = read(0, &c, 1);
 4d8:	4605                	li	a2,1
 4da:	faf40593          	addi	a1,s0,-81
 4de:	4501                	li	a0,0
 4e0:	00000097          	auipc	ra,0x0
 4e4:	19c080e7          	jalr	412(ra) # 67c <read>
    if(cc < 1)
 4e8:	00a05e63          	blez	a0,504 <gets+0x56>
    buf[i++] = c;
 4ec:	faf44783          	lbu	a5,-81(s0)
 4f0:	00f90023          	sb	a5,0(s2) # f4000 <__global_pointer$+0xf26c5>
    if(c == '\n' || c == '\r')
 4f4:	01578763          	beq	a5,s5,502 <gets+0x54>
 4f8:	0905                	addi	s2,s2,1
 4fa:	fd679be3          	bne	a5,s6,4d0 <gets+0x22>
  for(i=0; i+1 < max; ){
 4fe:	89a6                	mv	s3,s1
 500:	a011                	j	504 <gets+0x56>
 502:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 504:	99de                	add	s3,s3,s7
 506:	00098023          	sb	zero,0(s3)
  return buf;
}
 50a:	855e                	mv	a0,s7
 50c:	60e6                	ld	ra,88(sp)
 50e:	6446                	ld	s0,80(sp)
 510:	64a6                	ld	s1,72(sp)
 512:	6906                	ld	s2,64(sp)
 514:	79e2                	ld	s3,56(sp)
 516:	7a42                	ld	s4,48(sp)
 518:	7aa2                	ld	s5,40(sp)
 51a:	7b02                	ld	s6,32(sp)
 51c:	6be2                	ld	s7,24(sp)
 51e:	6125                	addi	sp,sp,96
 520:	8082                	ret

0000000000000522 <stat>:

int
stat(const char *n, struct stat *st)
{
 522:	1101                	addi	sp,sp,-32
 524:	ec06                	sd	ra,24(sp)
 526:	e822                	sd	s0,16(sp)
 528:	e426                	sd	s1,8(sp)
 52a:	e04a                	sd	s2,0(sp)
 52c:	1000                	addi	s0,sp,32
 52e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 530:	4581                	li	a1,0
 532:	00000097          	auipc	ra,0x0
 536:	172080e7          	jalr	370(ra) # 6a4 <open>
  if(fd < 0)
 53a:	02054563          	bltz	a0,564 <stat+0x42>
 53e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 540:	85ca                	mv	a1,s2
 542:	00000097          	auipc	ra,0x0
 546:	17a080e7          	jalr	378(ra) # 6bc <fstat>
 54a:	892a                	mv	s2,a0
  close(fd);
 54c:	8526                	mv	a0,s1
 54e:	00000097          	auipc	ra,0x0
 552:	13e080e7          	jalr	318(ra) # 68c <close>
  return r;
}
 556:	854a                	mv	a0,s2
 558:	60e2                	ld	ra,24(sp)
 55a:	6442                	ld	s0,16(sp)
 55c:	64a2                	ld	s1,8(sp)
 55e:	6902                	ld	s2,0(sp)
 560:	6105                	addi	sp,sp,32
 562:	8082                	ret
    return -1;
 564:	597d                	li	s2,-1
 566:	bfc5                	j	556 <stat+0x34>

0000000000000568 <atoi>:

int
atoi(const char *s)
{
 568:	1141                	addi	sp,sp,-16
 56a:	e422                	sd	s0,8(sp)
 56c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 56e:	00054603          	lbu	a2,0(a0)
 572:	fd06079b          	addiw	a5,a2,-48
 576:	0ff7f793          	andi	a5,a5,255
 57a:	4725                	li	a4,9
 57c:	02f76963          	bltu	a4,a5,5ae <atoi+0x46>
 580:	86aa                	mv	a3,a0
  n = 0;
 582:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 584:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 586:	0685                	addi	a3,a3,1
 588:	0025179b          	slliw	a5,a0,0x2
 58c:	9fa9                	addw	a5,a5,a0
 58e:	0017979b          	slliw	a5,a5,0x1
 592:	9fb1                	addw	a5,a5,a2
 594:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 598:	0006c603          	lbu	a2,0(a3)
 59c:	fd06071b          	addiw	a4,a2,-48
 5a0:	0ff77713          	andi	a4,a4,255
 5a4:	fee5f1e3          	bgeu	a1,a4,586 <atoi+0x1e>
  return n;
}
 5a8:	6422                	ld	s0,8(sp)
 5aa:	0141                	addi	sp,sp,16
 5ac:	8082                	ret
  n = 0;
 5ae:	4501                	li	a0,0
 5b0:	bfe5                	j	5a8 <atoi+0x40>

00000000000005b2 <memmove>:

// #define memcpy memmove

void*
memmove(void *vdst, const void *vsrc, int n)
{
 5b2:	1141                	addi	sp,sp,-16
 5b4:	e422                	sd	s0,8(sp)
 5b6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 5b8:	02b57463          	bgeu	a0,a1,5e0 <memmove+0x2e>
    while(n-- > 0)
 5bc:	00c05f63          	blez	a2,5da <memmove+0x28>
 5c0:	1602                	slli	a2,a2,0x20
 5c2:	9201                	srli	a2,a2,0x20
 5c4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 5c8:	872a                	mv	a4,a0
      *dst++ = *src++;
 5ca:	0585                	addi	a1,a1,1
 5cc:	0705                	addi	a4,a4,1
 5ce:	fff5c683          	lbu	a3,-1(a1)
 5d2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 5d6:	fee79ae3          	bne	a5,a4,5ca <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 5da:	6422                	ld	s0,8(sp)
 5dc:	0141                	addi	sp,sp,16
 5de:	8082                	ret
    dst += n;
 5e0:	00c50733          	add	a4,a0,a2
    src += n;
 5e4:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 5e6:	fec05ae3          	blez	a2,5da <memmove+0x28>
 5ea:	fff6079b          	addiw	a5,a2,-1
 5ee:	1782                	slli	a5,a5,0x20
 5f0:	9381                	srli	a5,a5,0x20
 5f2:	fff7c793          	not	a5,a5
 5f6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 5f8:	15fd                	addi	a1,a1,-1
 5fa:	177d                	addi	a4,a4,-1
 5fc:	0005c683          	lbu	a3,0(a1)
 600:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 604:	fee79ae3          	bne	a5,a4,5f8 <memmove+0x46>
 608:	bfc9                	j	5da <memmove+0x28>

000000000000060a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 60a:	1141                	addi	sp,sp,-16
 60c:	e422                	sd	s0,8(sp)
 60e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 610:	ca05                	beqz	a2,640 <memcmp+0x36>
 612:	fff6069b          	addiw	a3,a2,-1
 616:	1682                	slli	a3,a3,0x20
 618:	9281                	srli	a3,a3,0x20
 61a:	0685                	addi	a3,a3,1
 61c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 61e:	00054783          	lbu	a5,0(a0)
 622:	0005c703          	lbu	a4,0(a1)
 626:	00e79863          	bne	a5,a4,636 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 62a:	0505                	addi	a0,a0,1
    p2++;
 62c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 62e:	fed518e3          	bne	a0,a3,61e <memcmp+0x14>
  }
  return 0;
 632:	4501                	li	a0,0
 634:	a019                	j	63a <memcmp+0x30>
      return *p1 - *p2;
 636:	40e7853b          	subw	a0,a5,a4
}
 63a:	6422                	ld	s0,8(sp)
 63c:	0141                	addi	sp,sp,16
 63e:	8082                	ret
  return 0;
 640:	4501                	li	a0,0
 642:	bfe5                	j	63a <memcmp+0x30>

0000000000000644 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 644:	1141                	addi	sp,sp,-16
 646:	e406                	sd	ra,8(sp)
 648:	e022                	sd	s0,0(sp)
 64a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 64c:	00000097          	auipc	ra,0x0
 650:	f66080e7          	jalr	-154(ra) # 5b2 <memmove>
}
 654:	60a2                	ld	ra,8(sp)
 656:	6402                	ld	s0,0(sp)
 658:	0141                	addi	sp,sp,16
 65a:	8082                	ret

000000000000065c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 65c:	4885                	li	a7,1
 ecall
 65e:	00000073          	ecall
 ret
 662:	8082                	ret

0000000000000664 <exit>:
.global exit
exit:
 li a7, SYS_exit
 664:	4889                	li	a7,2
 ecall
 666:	00000073          	ecall
 ret
 66a:	8082                	ret

000000000000066c <wait>:
.global wait
wait:
 li a7, SYS_wait
 66c:	488d                	li	a7,3
 ecall
 66e:	00000073          	ecall
 ret
 672:	8082                	ret

0000000000000674 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 674:	4891                	li	a7,4
 ecall
 676:	00000073          	ecall
 ret
 67a:	8082                	ret

000000000000067c <read>:
.global read
read:
 li a7, SYS_read
 67c:	4895                	li	a7,5
 ecall
 67e:	00000073          	ecall
 ret
 682:	8082                	ret

0000000000000684 <write>:
.global write
write:
 li a7, SYS_write
 684:	48c1                	li	a7,16
 ecall
 686:	00000073          	ecall
 ret
 68a:	8082                	ret

000000000000068c <close>:
.global close
close:
 li a7, SYS_close
 68c:	48d5                	li	a7,21
 ecall
 68e:	00000073          	ecall
 ret
 692:	8082                	ret

0000000000000694 <kill>:
.global kill
kill:
 li a7, SYS_kill
 694:	4899                	li	a7,6
 ecall
 696:	00000073          	ecall
 ret
 69a:	8082                	ret

000000000000069c <exec>:
.global exec
exec:
 li a7, SYS_exec
 69c:	489d                	li	a7,7
 ecall
 69e:	00000073          	ecall
 ret
 6a2:	8082                	ret

00000000000006a4 <open>:
.global open
open:
 li a7, SYS_open
 6a4:	48bd                	li	a7,15
 ecall
 6a6:	00000073          	ecall
 ret
 6aa:	8082                	ret

00000000000006ac <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 6ac:	48c5                	li	a7,17
 ecall
 6ae:	00000073          	ecall
 ret
 6b2:	8082                	ret

00000000000006b4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 6b4:	48c9                	li	a7,18
 ecall
 6b6:	00000073          	ecall
 ret
 6ba:	8082                	ret

00000000000006bc <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 6bc:	48a1                	li	a7,8
 ecall
 6be:	00000073          	ecall
 ret
 6c2:	8082                	ret

00000000000006c4 <link>:
.global link
link:
 li a7, SYS_link
 6c4:	48cd                	li	a7,19
 ecall
 6c6:	00000073          	ecall
 ret
 6ca:	8082                	ret

00000000000006cc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 6cc:	48d1                	li	a7,20
 ecall
 6ce:	00000073          	ecall
 ret
 6d2:	8082                	ret

00000000000006d4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 6d4:	48a5                	li	a7,9
 ecall
 6d6:	00000073          	ecall
 ret
 6da:	8082                	ret

00000000000006dc <dup>:
.global dup
dup:
 li a7, SYS_dup
 6dc:	48a9                	li	a7,10
 ecall
 6de:	00000073          	ecall
 ret
 6e2:	8082                	ret

00000000000006e4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6e4:	48ad                	li	a7,11
 ecall
 6e6:	00000073          	ecall
 ret
 6ea:	8082                	ret

00000000000006ec <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6ec:	48b1                	li	a7,12
 ecall
 6ee:	00000073          	ecall
 ret
 6f2:	8082                	ret

00000000000006f4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6f4:	48b5                	li	a7,13
 ecall
 6f6:	00000073          	ecall
 ret
 6fa:	8082                	ret

00000000000006fc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6fc:	48b9                	li	a7,14
 ecall
 6fe:	00000073          	ecall
 ret
 702:	8082                	ret

0000000000000704 <trace>:
.global trace
trace:
 li a7, SYS_trace
 704:	48d9                	li	a7,22
 ecall
 706:	00000073          	ecall
 ret
 70a:	8082                	ret

000000000000070c <alarm>:
.global alarm
alarm:
 li a7, SYS_alarm
 70c:	48dd                	li	a7,23
 ecall
 70e:	00000073          	ecall
 ret
 712:	8082                	ret

0000000000000714 <alarmret>:
.global alarmret
alarmret:
 li a7, SYS_alarmret
 714:	48e1                	li	a7,24
 ecall
 716:	00000073          	ecall
 ret
 71a:	8082                	ret

000000000000071c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 71c:	1101                	addi	sp,sp,-32
 71e:	ec06                	sd	ra,24(sp)
 720:	e822                	sd	s0,16(sp)
 722:	1000                	addi	s0,sp,32
 724:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 728:	4605                	li	a2,1
 72a:	fef40593          	addi	a1,s0,-17
 72e:	00000097          	auipc	ra,0x0
 732:	f56080e7          	jalr	-170(ra) # 684 <write>
}
 736:	60e2                	ld	ra,24(sp)
 738:	6442                	ld	s0,16(sp)
 73a:	6105                	addi	sp,sp,32
 73c:	8082                	ret

000000000000073e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 73e:	7139                	addi	sp,sp,-64
 740:	fc06                	sd	ra,56(sp)
 742:	f822                	sd	s0,48(sp)
 744:	f426                	sd	s1,40(sp)
 746:	f04a                	sd	s2,32(sp)
 748:	ec4e                	sd	s3,24(sp)
 74a:	0080                	addi	s0,sp,64
 74c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 74e:	c299                	beqz	a3,754 <printint+0x16>
 750:	0805c863          	bltz	a1,7e0 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 754:	2581                	sext.w	a1,a1
  neg = 0;
 756:	4881                	li	a7,0
 758:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 75c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 75e:	2601                	sext.w	a2,a2
 760:	00001517          	auipc	a0,0x1
 764:	92850513          	addi	a0,a0,-1752 # 1088 <digits>
 768:	883a                	mv	a6,a4
 76a:	2705                	addiw	a4,a4,1
 76c:	02c5f7bb          	remuw	a5,a1,a2
 770:	1782                	slli	a5,a5,0x20
 772:	9381                	srli	a5,a5,0x20
 774:	97aa                	add	a5,a5,a0
 776:	0007c783          	lbu	a5,0(a5)
 77a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 77e:	0005879b          	sext.w	a5,a1
 782:	02c5d5bb          	divuw	a1,a1,a2
 786:	0685                	addi	a3,a3,1
 788:	fec7f0e3          	bgeu	a5,a2,768 <printint+0x2a>
  if(neg)
 78c:	00088b63          	beqz	a7,7a2 <printint+0x64>
    buf[i++] = '-';
 790:	fd040793          	addi	a5,s0,-48
 794:	973e                	add	a4,a4,a5
 796:	02d00793          	li	a5,45
 79a:	fef70823          	sb	a5,-16(a4)
 79e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 7a2:	02e05863          	blez	a4,7d2 <printint+0x94>
 7a6:	fc040793          	addi	a5,s0,-64
 7aa:	00e78933          	add	s2,a5,a4
 7ae:	fff78993          	addi	s3,a5,-1
 7b2:	99ba                	add	s3,s3,a4
 7b4:	377d                	addiw	a4,a4,-1
 7b6:	1702                	slli	a4,a4,0x20
 7b8:	9301                	srli	a4,a4,0x20
 7ba:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 7be:	fff94583          	lbu	a1,-1(s2)
 7c2:	8526                	mv	a0,s1
 7c4:	00000097          	auipc	ra,0x0
 7c8:	f58080e7          	jalr	-168(ra) # 71c <putc>
  while(--i >= 0)
 7cc:	197d                	addi	s2,s2,-1
 7ce:	ff3918e3          	bne	s2,s3,7be <printint+0x80>
}
 7d2:	70e2                	ld	ra,56(sp)
 7d4:	7442                	ld	s0,48(sp)
 7d6:	74a2                	ld	s1,40(sp)
 7d8:	7902                	ld	s2,32(sp)
 7da:	69e2                	ld	s3,24(sp)
 7dc:	6121                	addi	sp,sp,64
 7de:	8082                	ret
    x = -xx;
 7e0:	40b005bb          	negw	a1,a1
    neg = 1;
 7e4:	4885                	li	a7,1
    x = -xx;
 7e6:	bf8d                	j	758 <printint+0x1a>

00000000000007e8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7e8:	7119                	addi	sp,sp,-128
 7ea:	fc86                	sd	ra,120(sp)
 7ec:	f8a2                	sd	s0,112(sp)
 7ee:	f4a6                	sd	s1,104(sp)
 7f0:	f0ca                	sd	s2,96(sp)
 7f2:	ecce                	sd	s3,88(sp)
 7f4:	e8d2                	sd	s4,80(sp)
 7f6:	e4d6                	sd	s5,72(sp)
 7f8:	e0da                	sd	s6,64(sp)
 7fa:	fc5e                	sd	s7,56(sp)
 7fc:	f862                	sd	s8,48(sp)
 7fe:	f466                	sd	s9,40(sp)
 800:	f06a                	sd	s10,32(sp)
 802:	ec6e                	sd	s11,24(sp)
 804:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 806:	0005c903          	lbu	s2,0(a1)
 80a:	18090f63          	beqz	s2,9a8 <vprintf+0x1c0>
 80e:	8aaa                	mv	s5,a0
 810:	8b32                	mv	s6,a2
 812:	00158493          	addi	s1,a1,1
  state = 0;
 816:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 818:	02500a13          	li	s4,37
      if(c == 'd'){
 81c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 820:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 824:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 828:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 82c:	00001b97          	auipc	s7,0x1
 830:	85cb8b93          	addi	s7,s7,-1956 # 1088 <digits>
 834:	a839                	j	852 <vprintf+0x6a>
        putc(fd, c);
 836:	85ca                	mv	a1,s2
 838:	8556                	mv	a0,s5
 83a:	00000097          	auipc	ra,0x0
 83e:	ee2080e7          	jalr	-286(ra) # 71c <putc>
 842:	a019                	j	848 <vprintf+0x60>
    } else if(state == '%'){
 844:	01498f63          	beq	s3,s4,862 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 848:	0485                	addi	s1,s1,1
 84a:	fff4c903          	lbu	s2,-1(s1)
 84e:	14090d63          	beqz	s2,9a8 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 852:	0009079b          	sext.w	a5,s2
    if(state == 0){
 856:	fe0997e3          	bnez	s3,844 <vprintf+0x5c>
      if(c == '%'){
 85a:	fd479ee3          	bne	a5,s4,836 <vprintf+0x4e>
        state = '%';
 85e:	89be                	mv	s3,a5
 860:	b7e5                	j	848 <vprintf+0x60>
      if(c == 'd'){
 862:	05878063          	beq	a5,s8,8a2 <vprintf+0xba>
      } else if(c == 'l') {
 866:	05978c63          	beq	a5,s9,8be <vprintf+0xd6>
      } else if(c == 'x') {
 86a:	07a78863          	beq	a5,s10,8da <vprintf+0xf2>
      } else if(c == 'p') {
 86e:	09b78463          	beq	a5,s11,8f6 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 872:	07300713          	li	a4,115
 876:	0ce78663          	beq	a5,a4,942 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 87a:	06300713          	li	a4,99
 87e:	0ee78e63          	beq	a5,a4,97a <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 882:	11478863          	beq	a5,s4,992 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 886:	85d2                	mv	a1,s4
 888:	8556                	mv	a0,s5
 88a:	00000097          	auipc	ra,0x0
 88e:	e92080e7          	jalr	-366(ra) # 71c <putc>
        putc(fd, c);
 892:	85ca                	mv	a1,s2
 894:	8556                	mv	a0,s5
 896:	00000097          	auipc	ra,0x0
 89a:	e86080e7          	jalr	-378(ra) # 71c <putc>
      }
      state = 0;
 89e:	4981                	li	s3,0
 8a0:	b765                	j	848 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 8a2:	008b0913          	addi	s2,s6,8
 8a6:	4685                	li	a3,1
 8a8:	4629                	li	a2,10
 8aa:	000b2583          	lw	a1,0(s6)
 8ae:	8556                	mv	a0,s5
 8b0:	00000097          	auipc	ra,0x0
 8b4:	e8e080e7          	jalr	-370(ra) # 73e <printint>
 8b8:	8b4a                	mv	s6,s2
      state = 0;
 8ba:	4981                	li	s3,0
 8bc:	b771                	j	848 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8be:	008b0913          	addi	s2,s6,8
 8c2:	4681                	li	a3,0
 8c4:	4629                	li	a2,10
 8c6:	000b2583          	lw	a1,0(s6)
 8ca:	8556                	mv	a0,s5
 8cc:	00000097          	auipc	ra,0x0
 8d0:	e72080e7          	jalr	-398(ra) # 73e <printint>
 8d4:	8b4a                	mv	s6,s2
      state = 0;
 8d6:	4981                	li	s3,0
 8d8:	bf85                	j	848 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 8da:	008b0913          	addi	s2,s6,8
 8de:	4681                	li	a3,0
 8e0:	4641                	li	a2,16
 8e2:	000b2583          	lw	a1,0(s6)
 8e6:	8556                	mv	a0,s5
 8e8:	00000097          	auipc	ra,0x0
 8ec:	e56080e7          	jalr	-426(ra) # 73e <printint>
 8f0:	8b4a                	mv	s6,s2
      state = 0;
 8f2:	4981                	li	s3,0
 8f4:	bf91                	j	848 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 8f6:	008b0793          	addi	a5,s6,8
 8fa:	f8f43423          	sd	a5,-120(s0)
 8fe:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 902:	03000593          	li	a1,48
 906:	8556                	mv	a0,s5
 908:	00000097          	auipc	ra,0x0
 90c:	e14080e7          	jalr	-492(ra) # 71c <putc>
  putc(fd, 'x');
 910:	85ea                	mv	a1,s10
 912:	8556                	mv	a0,s5
 914:	00000097          	auipc	ra,0x0
 918:	e08080e7          	jalr	-504(ra) # 71c <putc>
 91c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 91e:	03c9d793          	srli	a5,s3,0x3c
 922:	97de                	add	a5,a5,s7
 924:	0007c583          	lbu	a1,0(a5)
 928:	8556                	mv	a0,s5
 92a:	00000097          	auipc	ra,0x0
 92e:	df2080e7          	jalr	-526(ra) # 71c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 932:	0992                	slli	s3,s3,0x4
 934:	397d                	addiw	s2,s2,-1
 936:	fe0914e3          	bnez	s2,91e <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 93a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 93e:	4981                	li	s3,0
 940:	b721                	j	848 <vprintf+0x60>
        s = va_arg(ap, char*);
 942:	008b0993          	addi	s3,s6,8
 946:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 94a:	02090163          	beqz	s2,96c <vprintf+0x184>
        while(*s != 0){
 94e:	00094583          	lbu	a1,0(s2)
 952:	c9a1                	beqz	a1,9a2 <vprintf+0x1ba>
          putc(fd, *s);
 954:	8556                	mv	a0,s5
 956:	00000097          	auipc	ra,0x0
 95a:	dc6080e7          	jalr	-570(ra) # 71c <putc>
          s++;
 95e:	0905                	addi	s2,s2,1
        while(*s != 0){
 960:	00094583          	lbu	a1,0(s2)
 964:	f9e5                	bnez	a1,954 <vprintf+0x16c>
        s = va_arg(ap, char*);
 966:	8b4e                	mv	s6,s3
      state = 0;
 968:	4981                	li	s3,0
 96a:	bdf9                	j	848 <vprintf+0x60>
          s = "(null)";
 96c:	00000917          	auipc	s2,0x0
 970:	71490913          	addi	s2,s2,1812 # 1080 <strstr+0x218>
        while(*s != 0){
 974:	02800593          	li	a1,40
 978:	bff1                	j	954 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 97a:	008b0913          	addi	s2,s6,8
 97e:	000b4583          	lbu	a1,0(s6)
 982:	8556                	mv	a0,s5
 984:	00000097          	auipc	ra,0x0
 988:	d98080e7          	jalr	-616(ra) # 71c <putc>
 98c:	8b4a                	mv	s6,s2
      state = 0;
 98e:	4981                	li	s3,0
 990:	bd65                	j	848 <vprintf+0x60>
        putc(fd, c);
 992:	85d2                	mv	a1,s4
 994:	8556                	mv	a0,s5
 996:	00000097          	auipc	ra,0x0
 99a:	d86080e7          	jalr	-634(ra) # 71c <putc>
      state = 0;
 99e:	4981                	li	s3,0
 9a0:	b565                	j	848 <vprintf+0x60>
        s = va_arg(ap, char*);
 9a2:	8b4e                	mv	s6,s3
      state = 0;
 9a4:	4981                	li	s3,0
 9a6:	b54d                	j	848 <vprintf+0x60>
    }
  }
}
 9a8:	70e6                	ld	ra,120(sp)
 9aa:	7446                	ld	s0,112(sp)
 9ac:	74a6                	ld	s1,104(sp)
 9ae:	7906                	ld	s2,96(sp)
 9b0:	69e6                	ld	s3,88(sp)
 9b2:	6a46                	ld	s4,80(sp)
 9b4:	6aa6                	ld	s5,72(sp)
 9b6:	6b06                	ld	s6,64(sp)
 9b8:	7be2                	ld	s7,56(sp)
 9ba:	7c42                	ld	s8,48(sp)
 9bc:	7ca2                	ld	s9,40(sp)
 9be:	7d02                	ld	s10,32(sp)
 9c0:	6de2                	ld	s11,24(sp)
 9c2:	6109                	addi	sp,sp,128
 9c4:	8082                	ret

00000000000009c6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9c6:	715d                	addi	sp,sp,-80
 9c8:	ec06                	sd	ra,24(sp)
 9ca:	e822                	sd	s0,16(sp)
 9cc:	1000                	addi	s0,sp,32
 9ce:	e010                	sd	a2,0(s0)
 9d0:	e414                	sd	a3,8(s0)
 9d2:	e818                	sd	a4,16(s0)
 9d4:	ec1c                	sd	a5,24(s0)
 9d6:	03043023          	sd	a6,32(s0)
 9da:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9de:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9e2:	8622                	mv	a2,s0
 9e4:	00000097          	auipc	ra,0x0
 9e8:	e04080e7          	jalr	-508(ra) # 7e8 <vprintf>
}
 9ec:	60e2                	ld	ra,24(sp)
 9ee:	6442                	ld	s0,16(sp)
 9f0:	6161                	addi	sp,sp,80
 9f2:	8082                	ret

00000000000009f4 <printf>:

void
printf(const char *fmt, ...)
{
 9f4:	711d                	addi	sp,sp,-96
 9f6:	ec06                	sd	ra,24(sp)
 9f8:	e822                	sd	s0,16(sp)
 9fa:	1000                	addi	s0,sp,32
 9fc:	e40c                	sd	a1,8(s0)
 9fe:	e810                	sd	a2,16(s0)
 a00:	ec14                	sd	a3,24(s0)
 a02:	f018                	sd	a4,32(s0)
 a04:	f41c                	sd	a5,40(s0)
 a06:	03043823          	sd	a6,48(s0)
 a0a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a0e:	00840613          	addi	a2,s0,8
 a12:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a16:	85aa                	mv	a1,a0
 a18:	4505                	li	a0,1
 a1a:	00000097          	auipc	ra,0x0
 a1e:	dce080e7          	jalr	-562(ra) # 7e8 <vprintf>
}
 a22:	60e2                	ld	ra,24(sp)
 a24:	6442                	ld	s0,16(sp)
 a26:	6125                	addi	sp,sp,96
 a28:	8082                	ret

0000000000000a2a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a2a:	1141                	addi	sp,sp,-16
 a2c:	e422                	sd	s0,8(sp)
 a2e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a30:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a34:	00000797          	auipc	a5,0x0
 a38:	7147b783          	ld	a5,1812(a5) # 1148 <freep>
 a3c:	a805                	j	a6c <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a3e:	4618                	lw	a4,8(a2)
 a40:	9db9                	addw	a1,a1,a4
 a42:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a46:	6398                	ld	a4,0(a5)
 a48:	6318                	ld	a4,0(a4)
 a4a:	fee53823          	sd	a4,-16(a0)
 a4e:	a091                	j	a92 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a50:	ff852703          	lw	a4,-8(a0)
 a54:	9e39                	addw	a2,a2,a4
 a56:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 a58:	ff053703          	ld	a4,-16(a0)
 a5c:	e398                	sd	a4,0(a5)
 a5e:	a099                	j	aa4 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a60:	6398                	ld	a4,0(a5)
 a62:	00e7e463          	bltu	a5,a4,a6a <free+0x40>
 a66:	00e6ea63          	bltu	a3,a4,a7a <free+0x50>
{
 a6a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a6c:	fed7fae3          	bgeu	a5,a3,a60 <free+0x36>
 a70:	6398                	ld	a4,0(a5)
 a72:	00e6e463          	bltu	a3,a4,a7a <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a76:	fee7eae3          	bltu	a5,a4,a6a <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 a7a:	ff852583          	lw	a1,-8(a0)
 a7e:	6390                	ld	a2,0(a5)
 a80:	02059713          	slli	a4,a1,0x20
 a84:	9301                	srli	a4,a4,0x20
 a86:	0712                	slli	a4,a4,0x4
 a88:	9736                	add	a4,a4,a3
 a8a:	fae60ae3          	beq	a2,a4,a3e <free+0x14>
    bp->s.ptr = p->s.ptr;
 a8e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a92:	4790                	lw	a2,8(a5)
 a94:	02061713          	slli	a4,a2,0x20
 a98:	9301                	srli	a4,a4,0x20
 a9a:	0712                	slli	a4,a4,0x4
 a9c:	973e                	add	a4,a4,a5
 a9e:	fae689e3          	beq	a3,a4,a50 <free+0x26>
  } else
    p->s.ptr = bp;
 aa2:	e394                	sd	a3,0(a5)
  freep = p;
 aa4:	00000717          	auipc	a4,0x0
 aa8:	6af73223          	sd	a5,1700(a4) # 1148 <freep>
}
 aac:	6422                	ld	s0,8(sp)
 aae:	0141                	addi	sp,sp,16
 ab0:	8082                	ret

0000000000000ab2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 ab2:	7139                	addi	sp,sp,-64
 ab4:	fc06                	sd	ra,56(sp)
 ab6:	f822                	sd	s0,48(sp)
 ab8:	f426                	sd	s1,40(sp)
 aba:	f04a                	sd	s2,32(sp)
 abc:	ec4e                	sd	s3,24(sp)
 abe:	e852                	sd	s4,16(sp)
 ac0:	e456                	sd	s5,8(sp)
 ac2:	e05a                	sd	s6,0(sp)
 ac4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ac6:	02051493          	slli	s1,a0,0x20
 aca:	9081                	srli	s1,s1,0x20
 acc:	04bd                	addi	s1,s1,15
 ace:	8091                	srli	s1,s1,0x4
 ad0:	0014899b          	addiw	s3,s1,1
 ad4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 ad6:	00000517          	auipc	a0,0x0
 ada:	67253503          	ld	a0,1650(a0) # 1148 <freep>
 ade:	c515                	beqz	a0,b0a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ae0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ae2:	4798                	lw	a4,8(a5)
 ae4:	02977f63          	bgeu	a4,s1,b22 <malloc+0x70>
 ae8:	8a4e                	mv	s4,s3
 aea:	0009871b          	sext.w	a4,s3
 aee:	6685                	lui	a3,0x1
 af0:	00d77363          	bgeu	a4,a3,af6 <malloc+0x44>
 af4:	6a05                	lui	s4,0x1
 af6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 afa:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 afe:	00000917          	auipc	s2,0x0
 b02:	64a90913          	addi	s2,s2,1610 # 1148 <freep>
  if(p == (char*)-1)
 b06:	5afd                	li	s5,-1
 b08:	a88d                	j	b7a <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 b0a:	00000797          	auipc	a5,0x0
 b0e:	64678793          	addi	a5,a5,1606 # 1150 <base>
 b12:	00000717          	auipc	a4,0x0
 b16:	62f73b23          	sd	a5,1590(a4) # 1148 <freep>
 b1a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b1c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b20:	b7e1                	j	ae8 <malloc+0x36>
      if(p->s.size == nunits)
 b22:	02e48b63          	beq	s1,a4,b58 <malloc+0xa6>
        p->s.size -= nunits;
 b26:	4137073b          	subw	a4,a4,s3
 b2a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b2c:	1702                	slli	a4,a4,0x20
 b2e:	9301                	srli	a4,a4,0x20
 b30:	0712                	slli	a4,a4,0x4
 b32:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b34:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b38:	00000717          	auipc	a4,0x0
 b3c:	60a73823          	sd	a0,1552(a4) # 1148 <freep>
      return (void*)(p + 1);
 b40:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 b44:	70e2                	ld	ra,56(sp)
 b46:	7442                	ld	s0,48(sp)
 b48:	74a2                	ld	s1,40(sp)
 b4a:	7902                	ld	s2,32(sp)
 b4c:	69e2                	ld	s3,24(sp)
 b4e:	6a42                	ld	s4,16(sp)
 b50:	6aa2                	ld	s5,8(sp)
 b52:	6b02                	ld	s6,0(sp)
 b54:	6121                	addi	sp,sp,64
 b56:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 b58:	6398                	ld	a4,0(a5)
 b5a:	e118                	sd	a4,0(a0)
 b5c:	bff1                	j	b38 <malloc+0x86>
  hp->s.size = nu;
 b5e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b62:	0541                	addi	a0,a0,16
 b64:	00000097          	auipc	ra,0x0
 b68:	ec6080e7          	jalr	-314(ra) # a2a <free>
  return freep;
 b6c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b70:	d971                	beqz	a0,b44 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b72:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b74:	4798                	lw	a4,8(a5)
 b76:	fa9776e3          	bgeu	a4,s1,b22 <malloc+0x70>
    if(p == freep)
 b7a:	00093703          	ld	a4,0(s2)
 b7e:	853e                	mv	a0,a5
 b80:	fef719e3          	bne	a4,a5,b72 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 b84:	8552                	mv	a0,s4
 b86:	00000097          	auipc	ra,0x0
 b8a:	b66080e7          	jalr	-1178(ra) # 6ec <sbrk>
  if(p == (char*)-1)
 b8e:	fd5518e3          	bne	a0,s5,b5e <malloc+0xac>
        return 0;
 b92:	4501                	li	a0,0
 b94:	bf45                	j	b44 <malloc+0x92>

0000000000000b96 <Pipe>:
#include "kernel/stat.h"
#include "user.h"
#include "wrapper.h"
int strncmp(const char*s, const char*pat,int n);

int Pipe(int *p) {
 b96:	1101                	addi	sp,sp,-32
 b98:	ec06                	sd	ra,24(sp)
 b9a:	e822                	sd	s0,16(sp)
 b9c:	e426                	sd	s1,8(sp)
 b9e:	1000                	addi	s0,sp,32
  i32 res = pipe(p);
 ba0:	00000097          	auipc	ra,0x0
 ba4:	ad4080e7          	jalr	-1324(ra) # 674 <pipe>
 ba8:	84aa                	mv	s1,a0
  if (res < 0) {
 baa:	00054863          	bltz	a0,bba <Pipe+0x24>
    fprintf(2, "pipe creation error");
  }
  return res;
}
 bae:	8526                	mv	a0,s1
 bb0:	60e2                	ld	ra,24(sp)
 bb2:	6442                	ld	s0,16(sp)
 bb4:	64a2                	ld	s1,8(sp)
 bb6:	6105                	addi	sp,sp,32
 bb8:	8082                	ret
    fprintf(2, "pipe creation error");
 bba:	00000597          	auipc	a1,0x0
 bbe:	4e658593          	addi	a1,a1,1254 # 10a0 <digits+0x18>
 bc2:	4509                	li	a0,2
 bc4:	00000097          	auipc	ra,0x0
 bc8:	e02080e7          	jalr	-510(ra) # 9c6 <fprintf>
 bcc:	b7cd                	j	bae <Pipe+0x18>

0000000000000bce <Write>:

int Write(int fd, void *buf, int count){
 bce:	1141                	addi	sp,sp,-16
 bd0:	e406                	sd	ra,8(sp)
 bd2:	e022                	sd	s0,0(sp)
 bd4:	0800                	addi	s0,sp,16
  i32 res = write(fd, buf, count);
 bd6:	00000097          	auipc	ra,0x0
 bda:	aae080e7          	jalr	-1362(ra) # 684 <write>
  if (res < 0) {
 bde:	00054663          	bltz	a0,bea <Write+0x1c>
    fprintf(2, "write error");
    exit(0);
  }
  return res;
}
 be2:	60a2                	ld	ra,8(sp)
 be4:	6402                	ld	s0,0(sp)
 be6:	0141                	addi	sp,sp,16
 be8:	8082                	ret
    fprintf(2, "write error");
 bea:	00000597          	auipc	a1,0x0
 bee:	4ce58593          	addi	a1,a1,1230 # 10b8 <digits+0x30>
 bf2:	4509                	li	a0,2
 bf4:	00000097          	auipc	ra,0x0
 bf8:	dd2080e7          	jalr	-558(ra) # 9c6 <fprintf>
    exit(0);
 bfc:	4501                	li	a0,0
 bfe:	00000097          	auipc	ra,0x0
 c02:	a66080e7          	jalr	-1434(ra) # 664 <exit>

0000000000000c06 <Read>:



int Read(int fd,  void*buf, int count){
 c06:	1141                	addi	sp,sp,-16
 c08:	e406                	sd	ra,8(sp)
 c0a:	e022                	sd	s0,0(sp)
 c0c:	0800                	addi	s0,sp,16
  i32 res = read(fd, buf, count);
 c0e:	00000097          	auipc	ra,0x0
 c12:	a6e080e7          	jalr	-1426(ra) # 67c <read>
  if (res < 0) {
 c16:	00054663          	bltz	a0,c22 <Read+0x1c>
    fprintf(2, "read error");
    exit(0);
  }
  return res;
}
 c1a:	60a2                	ld	ra,8(sp)
 c1c:	6402                	ld	s0,0(sp)
 c1e:	0141                	addi	sp,sp,16
 c20:	8082                	ret
    fprintf(2, "read error");
 c22:	00000597          	auipc	a1,0x0
 c26:	4a658593          	addi	a1,a1,1190 # 10c8 <digits+0x40>
 c2a:	4509                	li	a0,2
 c2c:	00000097          	auipc	ra,0x0
 c30:	d9a080e7          	jalr	-614(ra) # 9c6 <fprintf>
    exit(0);
 c34:	4501                	li	a0,0
 c36:	00000097          	auipc	ra,0x0
 c3a:	a2e080e7          	jalr	-1490(ra) # 664 <exit>

0000000000000c3e <Open>:


int Open(const char* path, int flag){
 c3e:	1141                	addi	sp,sp,-16
 c40:	e406                	sd	ra,8(sp)
 c42:	e022                	sd	s0,0(sp)
 c44:	0800                	addi	s0,sp,16
  i32 res = open(path, flag);
 c46:	00000097          	auipc	ra,0x0
 c4a:	a5e080e7          	jalr	-1442(ra) # 6a4 <open>
  if (res < 0) {
 c4e:	00054663          	bltz	a0,c5a <Open+0x1c>
    fprintf(2, "open error");
    exit(0);
  }
  return res;
}
 c52:	60a2                	ld	ra,8(sp)
 c54:	6402                	ld	s0,0(sp)
 c56:	0141                	addi	sp,sp,16
 c58:	8082                	ret
    fprintf(2, "open error");
 c5a:	00000597          	auipc	a1,0x0
 c5e:	47e58593          	addi	a1,a1,1150 # 10d8 <digits+0x50>
 c62:	4509                	li	a0,2
 c64:	00000097          	auipc	ra,0x0
 c68:	d62080e7          	jalr	-670(ra) # 9c6 <fprintf>
    exit(0);
 c6c:	4501                	li	a0,0
 c6e:	00000097          	auipc	ra,0x0
 c72:	9f6080e7          	jalr	-1546(ra) # 664 <exit>

0000000000000c76 <Fstat>:


int Fstat(int fd, stat_t *st){
 c76:	1141                	addi	sp,sp,-16
 c78:	e406                	sd	ra,8(sp)
 c7a:	e022                	sd	s0,0(sp)
 c7c:	0800                	addi	s0,sp,16
  i32 res = fstat(fd, st);
 c7e:	00000097          	auipc	ra,0x0
 c82:	a3e080e7          	jalr	-1474(ra) # 6bc <fstat>
  if (res < 0) {
 c86:	00054663          	bltz	a0,c92 <Fstat+0x1c>
    fprintf(2, "get file stat error");
    exit(0);
  }
  return res;
}
 c8a:	60a2                	ld	ra,8(sp)
 c8c:	6402                	ld	s0,0(sp)
 c8e:	0141                	addi	sp,sp,16
 c90:	8082                	ret
    fprintf(2, "get file stat error");
 c92:	00000597          	auipc	a1,0x0
 c96:	45658593          	addi	a1,a1,1110 # 10e8 <digits+0x60>
 c9a:	4509                	li	a0,2
 c9c:	00000097          	auipc	ra,0x0
 ca0:	d2a080e7          	jalr	-726(ra) # 9c6 <fprintf>
    exit(0);
 ca4:	4501                	li	a0,0
 ca6:	00000097          	auipc	ra,0x0
 caa:	9be080e7          	jalr	-1602(ra) # 664 <exit>

0000000000000cae <Dup>:



int Dup(int fd){
 cae:	1141                	addi	sp,sp,-16
 cb0:	e406                	sd	ra,8(sp)
 cb2:	e022                	sd	s0,0(sp)
 cb4:	0800                	addi	s0,sp,16
  i32 res = dup(fd);
 cb6:	00000097          	auipc	ra,0x0
 cba:	a26080e7          	jalr	-1498(ra) # 6dc <dup>
  if (res < 0) {
 cbe:	00054663          	bltz	a0,cca <Dup+0x1c>
    fprintf(2, "dup error");
    exit(0);
  }
  return res;

}
 cc2:	60a2                	ld	ra,8(sp)
 cc4:	6402                	ld	s0,0(sp)
 cc6:	0141                	addi	sp,sp,16
 cc8:	8082                	ret
    fprintf(2, "dup error");
 cca:	00000597          	auipc	a1,0x0
 cce:	43658593          	addi	a1,a1,1078 # 1100 <digits+0x78>
 cd2:	4509                	li	a0,2
 cd4:	00000097          	auipc	ra,0x0
 cd8:	cf2080e7          	jalr	-782(ra) # 9c6 <fprintf>
    exit(0);
 cdc:	4501                	li	a0,0
 cde:	00000097          	auipc	ra,0x0
 ce2:	986080e7          	jalr	-1658(ra) # 664 <exit>

0000000000000ce6 <Close>:

int Close(int fd){
 ce6:	1141                	addi	sp,sp,-16
 ce8:	e406                	sd	ra,8(sp)
 cea:	e022                	sd	s0,0(sp)
 cec:	0800                	addi	s0,sp,16
  i32 res = close(fd);
 cee:	00000097          	auipc	ra,0x0
 cf2:	99e080e7          	jalr	-1634(ra) # 68c <close>
  if (res < 0) {
 cf6:	00054663          	bltz	a0,d02 <Close+0x1c>
    fprintf(2, "file close error~");
    exit(0);
  }
  return res;
}
 cfa:	60a2                	ld	ra,8(sp)
 cfc:	6402                	ld	s0,0(sp)
 cfe:	0141                	addi	sp,sp,16
 d00:	8082                	ret
    fprintf(2, "file close error~");
 d02:	00000597          	auipc	a1,0x0
 d06:	40e58593          	addi	a1,a1,1038 # 1110 <digits+0x88>
 d0a:	4509                	li	a0,2
 d0c:	00000097          	auipc	ra,0x0
 d10:	cba080e7          	jalr	-838(ra) # 9c6 <fprintf>
    exit(0);
 d14:	4501                	li	a0,0
 d16:	00000097          	auipc	ra,0x0
 d1a:	94e080e7          	jalr	-1714(ra) # 664 <exit>

0000000000000d1e <Dup2>:

int Dup2(int old_fd,int new_fd){
 d1e:	1101                	addi	sp,sp,-32
 d20:	ec06                	sd	ra,24(sp)
 d22:	e822                	sd	s0,16(sp)
 d24:	e426                	sd	s1,8(sp)
 d26:	1000                	addi	s0,sp,32
 d28:	84aa                	mv	s1,a0
  Close(new_fd);
 d2a:	852e                	mv	a0,a1
 d2c:	00000097          	auipc	ra,0x0
 d30:	fba080e7          	jalr	-70(ra) # ce6 <Close>
  i32 res = Dup(old_fd);
 d34:	8526                	mv	a0,s1
 d36:	00000097          	auipc	ra,0x0
 d3a:	f78080e7          	jalr	-136(ra) # cae <Dup>
  if (res < 0) {
 d3e:	00054763          	bltz	a0,d4c <Dup2+0x2e>
    fprintf(2, "dup error");
    exit(0);
  }
  return res;
}
 d42:	60e2                	ld	ra,24(sp)
 d44:	6442                	ld	s0,16(sp)
 d46:	64a2                	ld	s1,8(sp)
 d48:	6105                	addi	sp,sp,32
 d4a:	8082                	ret
    fprintf(2, "dup error");
 d4c:	00000597          	auipc	a1,0x0
 d50:	3b458593          	addi	a1,a1,948 # 1100 <digits+0x78>
 d54:	4509                	li	a0,2
 d56:	00000097          	auipc	ra,0x0
 d5a:	c70080e7          	jalr	-912(ra) # 9c6 <fprintf>
    exit(0);
 d5e:	4501                	li	a0,0
 d60:	00000097          	auipc	ra,0x0
 d64:	904080e7          	jalr	-1788(ra) # 664 <exit>

0000000000000d68 <Stat>:

int Stat(const char*link,stat_t *st){
 d68:	1101                	addi	sp,sp,-32
 d6a:	ec06                	sd	ra,24(sp)
 d6c:	e822                	sd	s0,16(sp)
 d6e:	e426                	sd	s1,8(sp)
 d70:	1000                	addi	s0,sp,32
 d72:	84aa                	mv	s1,a0
  i32 res = stat(link,st);
 d74:	fffff097          	auipc	ra,0xfffff
 d78:	7ae080e7          	jalr	1966(ra) # 522 <stat>
  if (res < 0) {
 d7c:	00054763          	bltz	a0,d8a <Stat+0x22>
    fprintf(2, "file %s stat error",link);
    exit(0);
  }
  return res;
}
 d80:	60e2                	ld	ra,24(sp)
 d82:	6442                	ld	s0,16(sp)
 d84:	64a2                	ld	s1,8(sp)
 d86:	6105                	addi	sp,sp,32
 d88:	8082                	ret
    fprintf(2, "file %s stat error",link);
 d8a:	8626                	mv	a2,s1
 d8c:	00000597          	auipc	a1,0x0
 d90:	39c58593          	addi	a1,a1,924 # 1128 <digits+0xa0>
 d94:	4509                	li	a0,2
 d96:	00000097          	auipc	ra,0x0
 d9a:	c30080e7          	jalr	-976(ra) # 9c6 <fprintf>
    exit(0);
 d9e:	4501                	li	a0,0
 da0:	00000097          	auipc	ra,0x0
 da4:	8c4080e7          	jalr	-1852(ra) # 664 <exit>

0000000000000da8 <strncmp>:
   return -1;
}



int strncmp(const char*s, const char*pat,int n){
 da8:	bc010113          	addi	sp,sp,-1088
 dac:	42113c23          	sd	ra,1080(sp)
 db0:	42813823          	sd	s0,1072(sp)
 db4:	42913423          	sd	s1,1064(sp)
 db8:	43213023          	sd	s2,1056(sp)
 dbc:	41313c23          	sd	s3,1048(sp)
 dc0:	41413823          	sd	s4,1040(sp)
 dc4:	41513423          	sd	s5,1032(sp)
 dc8:	44010413          	addi	s0,sp,1088
 dcc:	89aa                	mv	s3,a0
 dce:	892e                	mv	s2,a1
 dd0:	84b2                	mv	s1,a2
  char buf1[512],buf2[512];
  int n1 = MIN(n,strlen(s));
 dd2:	fffff097          	auipc	ra,0xfffff
 dd6:	66c080e7          	jalr	1644(ra) # 43e <strlen>
 dda:	2501                	sext.w	a0,a0
 ddc:	00048a1b          	sext.w	s4,s1
 de0:	8aa6                	mv	s5,s1
 de2:	06aa7363          	bgeu	s4,a0,e48 <strncmp+0xa0>
  int n2 = MIN(n,strlen(pat));
 de6:	854a                	mv	a0,s2
 de8:	fffff097          	auipc	ra,0xfffff
 dec:	656080e7          	jalr	1622(ra) # 43e <strlen>
 df0:	2501                	sext.w	a0,a0
 df2:	06aa7363          	bgeu	s4,a0,e58 <strncmp+0xb0>
  memmove(buf1,s,n1);
 df6:	8656                	mv	a2,s5
 df8:	85ce                	mv	a1,s3
 dfa:	dc040513          	addi	a0,s0,-576
 dfe:	fffff097          	auipc	ra,0xfffff
 e02:	7b4080e7          	jalr	1972(ra) # 5b2 <memmove>
  memmove(buf2,pat,n2);
 e06:	8626                	mv	a2,s1
 e08:	85ca                	mv	a1,s2
 e0a:	bc040513          	addi	a0,s0,-1088
 e0e:	fffff097          	auipc	ra,0xfffff
 e12:	7a4080e7          	jalr	1956(ra) # 5b2 <memmove>
  return strcmp(buf1,buf2);
 e16:	bc040593          	addi	a1,s0,-1088
 e1a:	dc040513          	addi	a0,s0,-576
 e1e:	fffff097          	auipc	ra,0xfffff
 e22:	5f4080e7          	jalr	1524(ra) # 412 <strcmp>
}
 e26:	43813083          	ld	ra,1080(sp)
 e2a:	43013403          	ld	s0,1072(sp)
 e2e:	42813483          	ld	s1,1064(sp)
 e32:	42013903          	ld	s2,1056(sp)
 e36:	41813983          	ld	s3,1048(sp)
 e3a:	41013a03          	ld	s4,1040(sp)
 e3e:	40813a83          	ld	s5,1032(sp)
 e42:	44010113          	addi	sp,sp,1088
 e46:	8082                	ret
  int n1 = MIN(n,strlen(s));
 e48:	854e                	mv	a0,s3
 e4a:	fffff097          	auipc	ra,0xfffff
 e4e:	5f4080e7          	jalr	1524(ra) # 43e <strlen>
 e52:	00050a9b          	sext.w	s5,a0
 e56:	bf41                	j	de6 <strncmp+0x3e>
  int n2 = MIN(n,strlen(pat));
 e58:	854a                	mv	a0,s2
 e5a:	fffff097          	auipc	ra,0xfffff
 e5e:	5e4080e7          	jalr	1508(ra) # 43e <strlen>
 e62:	0005049b          	sext.w	s1,a0
 e66:	bf41                	j	df6 <strncmp+0x4e>

0000000000000e68 <strstr>:
   while (*s != 0){
 e68:	00054783          	lbu	a5,0(a0)
 e6c:	cba1                	beqz	a5,ebc <strstr+0x54>
int strstr(char *s,char *p){
 e6e:	7179                	addi	sp,sp,-48
 e70:	f406                	sd	ra,40(sp)
 e72:	f022                	sd	s0,32(sp)
 e74:	ec26                	sd	s1,24(sp)
 e76:	e84a                	sd	s2,16(sp)
 e78:	e44e                	sd	s3,8(sp)
 e7a:	1800                	addi	s0,sp,48
 e7c:	89aa                	mv	s3,a0
 e7e:	892e                	mv	s2,a1
   while (*s != 0){
 e80:	84aa                	mv	s1,a0
     if (!strncmp(s,p,strlen(p)))
 e82:	854a                	mv	a0,s2
 e84:	fffff097          	auipc	ra,0xfffff
 e88:	5ba080e7          	jalr	1466(ra) # 43e <strlen>
 e8c:	0005061b          	sext.w	a2,a0
 e90:	85ca                	mv	a1,s2
 e92:	8526                	mv	a0,s1
 e94:	00000097          	auipc	ra,0x0
 e98:	f14080e7          	jalr	-236(ra) # da8 <strncmp>
 e9c:	c519                	beqz	a0,eaa <strstr+0x42>
     s++;
 e9e:	0485                	addi	s1,s1,1
   while (*s != 0){
 ea0:	0004c783          	lbu	a5,0(s1)
 ea4:	fff9                	bnez	a5,e82 <strstr+0x1a>
   return -1;
 ea6:	557d                	li	a0,-1
 ea8:	a019                	j	eae <strstr+0x46>
      return s - ori;
 eaa:	4134853b          	subw	a0,s1,s3
}
 eae:	70a2                	ld	ra,40(sp)
 eb0:	7402                	ld	s0,32(sp)
 eb2:	64e2                	ld	s1,24(sp)
 eb4:	6942                	ld	s2,16(sp)
 eb6:	69a2                	ld	s3,8(sp)
 eb8:	6145                	addi	sp,sp,48
 eba:	8082                	ret
   return -1;
 ebc:	557d                	li	a0,-1
}
 ebe:	8082                	ret
