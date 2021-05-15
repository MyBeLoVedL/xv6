
user/_lazytests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <sparse_memory>:

#define REGION_SZ (1024 * 1024 * 1024)

void
sparse_memory(char *s)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  char *i, *prev_end, *new_end;
  
  prev_end = sbrk(REGION_SZ);
   8:	40000537          	lui	a0,0x40000
   c:	00000097          	auipc	ra,0x0
  10:	5fc080e7          	jalr	1532(ra) # 608 <sbrk>
  if (prev_end == (char*)0xffffffffffffffffL) {
  14:	57fd                	li	a5,-1
  16:	02f50b63          	beq	a0,a5,4c <sparse_memory+0x4c>
    printf("sbrk() failed\n");
    exit(1);
  }
  new_end = prev_end + REGION_SZ;

  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
  1a:	6605                	lui	a2,0x1
  1c:	962a                	add	a2,a2,a0
  1e:	40001737          	lui	a4,0x40001
  22:	972a                	add	a4,a4,a0
  24:	87b2                	mv	a5,a2
  26:	000406b7          	lui	a3,0x40
    *(char **)i = i;
  2a:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
  2c:	97b6                	add	a5,a5,a3
  2e:	fee79ee3          	bne	a5,a4,2a <sparse_memory+0x2a>

  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
  32:	000406b7          	lui	a3,0x40
    if (*(char **)i != i) {
  36:	621c                	ld	a5,0(a2)
  38:	02c79763          	bne	a5,a2,66 <sparse_memory+0x66>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
  3c:	9636                	add	a2,a2,a3
  3e:	fee61ce3          	bne	a2,a4,36 <sparse_memory+0x36>
      printf("failed to read value from memory\n");
      exit(1);
    }
  }

  exit(0);
  42:	4501                	li	a0,0
  44:	00000097          	auipc	ra,0x0
  48:	53c080e7          	jalr	1340(ra) # 580 <exit>
    printf("sbrk() failed\n");
  4c:	00001517          	auipc	a0,0x1
  50:	dc450513          	addi	a0,a0,-572 # e10 <strstr+0x8c>
  54:	00001097          	auipc	ra,0x1
  58:	8bc080e7          	jalr	-1860(ra) # 910 <printf>
    exit(1);
  5c:	4505                	li	a0,1
  5e:	00000097          	auipc	ra,0x0
  62:	522080e7          	jalr	1314(ra) # 580 <exit>
      printf("failed to read value from memory\n");
  66:	00001517          	auipc	a0,0x1
  6a:	dba50513          	addi	a0,a0,-582 # e20 <strstr+0x9c>
  6e:	00001097          	auipc	ra,0x1
  72:	8a2080e7          	jalr	-1886(ra) # 910 <printf>
      exit(1);
  76:	4505                	li	a0,1
  78:	00000097          	auipc	ra,0x0
  7c:	508080e7          	jalr	1288(ra) # 580 <exit>

0000000000000080 <sparse_memory_unmap>:
}

void
sparse_memory_unmap(char *s)
{
  80:	7139                	addi	sp,sp,-64
  82:	fc06                	sd	ra,56(sp)
  84:	f822                	sd	s0,48(sp)
  86:	f426                	sd	s1,40(sp)
  88:	f04a                	sd	s2,32(sp)
  8a:	ec4e                	sd	s3,24(sp)
  8c:	0080                	addi	s0,sp,64
  int pid;
  char *i, *prev_end, *new_end;

  prev_end = sbrk(REGION_SZ);
  8e:	40000537          	lui	a0,0x40000
  92:	00000097          	auipc	ra,0x0
  96:	576080e7          	jalr	1398(ra) # 608 <sbrk>
  if (prev_end == (char*)0xffffffffffffffffL) {
  9a:	57fd                	li	a5,-1
  9c:	04f50863          	beq	a0,a5,ec <sparse_memory_unmap+0x6c>
    printf("sbrk() failed\n");
    exit(1);
  }
  new_end = prev_end + REGION_SZ;

  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
  a0:	6905                	lui	s2,0x1
  a2:	992a                	add	s2,s2,a0
  a4:	400014b7          	lui	s1,0x40001
  a8:	94aa                	add	s1,s1,a0
  aa:	87ca                	mv	a5,s2
  ac:	01000737          	lui	a4,0x1000
    *(char **)i = i;
  b0:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
  b2:	97ba                	add	a5,a5,a4
  b4:	fef49ee3          	bne	s1,a5,b0 <sparse_memory_unmap+0x30>

  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
  b8:	010009b7          	lui	s3,0x1000
    pid = fork();
  bc:	00000097          	auipc	ra,0x0
  c0:	4bc080e7          	jalr	1212(ra) # 578 <fork>
    if (pid < 0) {
  c4:	04054163          	bltz	a0,106 <sparse_memory_unmap+0x86>
      printf("error forking\n");
      exit(1);
    } else if (pid == 0) {
  c8:	cd21                	beqz	a0,120 <sparse_memory_unmap+0xa0>
      sbrk(-1L * REGION_SZ);
      *(char **)i = i;
      exit(0);
    } else {
      int status;
      wait(&status);
  ca:	fcc40513          	addi	a0,s0,-52
  ce:	00000097          	auipc	ra,0x0
  d2:	4ba080e7          	jalr	1210(ra) # 588 <wait>
      if (status == 0) {
  d6:	fcc42783          	lw	a5,-52(s0)
  da:	c3a5                	beqz	a5,13a <sparse_memory_unmap+0xba>
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
  dc:	994e                	add	s2,s2,s3
  de:	fd249fe3          	bne	s1,s2,bc <sparse_memory_unmap+0x3c>
        exit(1);
      }
    }
  }

  exit(0);
  e2:	4501                	li	a0,0
  e4:	00000097          	auipc	ra,0x0
  e8:	49c080e7          	jalr	1180(ra) # 580 <exit>
    printf("sbrk() failed\n");
  ec:	00001517          	auipc	a0,0x1
  f0:	d2450513          	addi	a0,a0,-732 # e10 <strstr+0x8c>
  f4:	00001097          	auipc	ra,0x1
  f8:	81c080e7          	jalr	-2020(ra) # 910 <printf>
    exit(1);
  fc:	4505                	li	a0,1
  fe:	00000097          	auipc	ra,0x0
 102:	482080e7          	jalr	1154(ra) # 580 <exit>
      printf("error forking\n");
 106:	00001517          	auipc	a0,0x1
 10a:	d4250513          	addi	a0,a0,-702 # e48 <strstr+0xc4>
 10e:	00001097          	auipc	ra,0x1
 112:	802080e7          	jalr	-2046(ra) # 910 <printf>
      exit(1);
 116:	4505                	li	a0,1
 118:	00000097          	auipc	ra,0x0
 11c:	468080e7          	jalr	1128(ra) # 580 <exit>
      sbrk(-1L * REGION_SZ);
 120:	c0000537          	lui	a0,0xc0000
 124:	00000097          	auipc	ra,0x0
 128:	4e4080e7          	jalr	1252(ra) # 608 <sbrk>
      *(char **)i = i;
 12c:	01293023          	sd	s2,0(s2) # 1000 <digits+0xa8>
      exit(0);
 130:	4501                	li	a0,0
 132:	00000097          	auipc	ra,0x0
 136:	44e080e7          	jalr	1102(ra) # 580 <exit>
        printf("memory not unmapped\n");
 13a:	00001517          	auipc	a0,0x1
 13e:	d1e50513          	addi	a0,a0,-738 # e58 <strstr+0xd4>
 142:	00000097          	auipc	ra,0x0
 146:	7ce080e7          	jalr	1998(ra) # 910 <printf>
        exit(1);
 14a:	4505                	li	a0,1
 14c:	00000097          	auipc	ra,0x0
 150:	434080e7          	jalr	1076(ra) # 580 <exit>

0000000000000154 <oom>:
}

void
oom(char *s)
{
 154:	7179                	addi	sp,sp,-48
 156:	f406                	sd	ra,40(sp)
 158:	f022                	sd	s0,32(sp)
 15a:	ec26                	sd	s1,24(sp)
 15c:	1800                	addi	s0,sp,48
  void *m1, *m2;
  int pid;

  if((pid = fork()) == 0){
 15e:	00000097          	auipc	ra,0x0
 162:	41a080e7          	jalr	1050(ra) # 578 <fork>
    m1 = 0;
 166:	4481                	li	s1,0
  if((pid = fork()) == 0){
 168:	c10d                	beqz	a0,18a <oom+0x36>
      m1 = m2;
    }
    exit(0);
  } else {
    int xstatus;
    wait(&xstatus);
 16a:	fdc40513          	addi	a0,s0,-36
 16e:	00000097          	auipc	ra,0x0
 172:	41a080e7          	jalr	1050(ra) # 588 <wait>
    exit(xstatus == 0);
 176:	fdc42503          	lw	a0,-36(s0)
 17a:	00153513          	seqz	a0,a0
 17e:	00000097          	auipc	ra,0x0
 182:	402080e7          	jalr	1026(ra) # 580 <exit>
      *(char**)m2 = m1;
 186:	e104                	sd	s1,0(a0)
      m1 = m2;
 188:	84aa                	mv	s1,a0
    while((m2 = malloc(4096*4096)) != 0){
 18a:	01000537          	lui	a0,0x1000
 18e:	00001097          	auipc	ra,0x1
 192:	840080e7          	jalr	-1984(ra) # 9ce <malloc>
 196:	f965                	bnez	a0,186 <oom+0x32>
    exit(0);
 198:	00000097          	auipc	ra,0x0
 19c:	3e8080e7          	jalr	1000(ra) # 580 <exit>

00000000000001a0 <run>:
}

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
 1a0:	7179                	addi	sp,sp,-48
 1a2:	f406                	sd	ra,40(sp)
 1a4:	f022                	sd	s0,32(sp)
 1a6:	ec26                	sd	s1,24(sp)
 1a8:	e84a                	sd	s2,16(sp)
 1aa:	1800                	addi	s0,sp,48
 1ac:	892a                	mv	s2,a0
 1ae:	84ae                	mv	s1,a1
  int pid;
  int xstatus;
  
  printf("running test %s\n", s);
 1b0:	00001517          	auipc	a0,0x1
 1b4:	cc050513          	addi	a0,a0,-832 # e70 <strstr+0xec>
 1b8:	00000097          	auipc	ra,0x0
 1bc:	758080e7          	jalr	1880(ra) # 910 <printf>
  if((pid = fork()) < 0) {
 1c0:	00000097          	auipc	ra,0x0
 1c4:	3b8080e7          	jalr	952(ra) # 578 <fork>
 1c8:	02054f63          	bltz	a0,206 <run+0x66>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
 1cc:	c931                	beqz	a0,220 <run+0x80>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
 1ce:	fdc40513          	addi	a0,s0,-36
 1d2:	00000097          	auipc	ra,0x0
 1d6:	3b6080e7          	jalr	950(ra) # 588 <wait>
    if(xstatus != 0) 
 1da:	fdc42783          	lw	a5,-36(s0)
 1de:	cba1                	beqz	a5,22e <run+0x8e>
      printf("test %s: FAILED\n", s);
 1e0:	85a6                	mv	a1,s1
 1e2:	00001517          	auipc	a0,0x1
 1e6:	cbe50513          	addi	a0,a0,-834 # ea0 <strstr+0x11c>
 1ea:	00000097          	auipc	ra,0x0
 1ee:	726080e7          	jalr	1830(ra) # 910 <printf>
    else
      printf("test %s: OK\n", s);
    return xstatus == 0;
 1f2:	fdc42503          	lw	a0,-36(s0)
  }
}
 1f6:	00153513          	seqz	a0,a0
 1fa:	70a2                	ld	ra,40(sp)
 1fc:	7402                	ld	s0,32(sp)
 1fe:	64e2                	ld	s1,24(sp)
 200:	6942                	ld	s2,16(sp)
 202:	6145                	addi	sp,sp,48
 204:	8082                	ret
    printf("runtest: fork error\n");
 206:	00001517          	auipc	a0,0x1
 20a:	c8250513          	addi	a0,a0,-894 # e88 <strstr+0x104>
 20e:	00000097          	auipc	ra,0x0
 212:	702080e7          	jalr	1794(ra) # 910 <printf>
    exit(1);
 216:	4505                	li	a0,1
 218:	00000097          	auipc	ra,0x0
 21c:	368080e7          	jalr	872(ra) # 580 <exit>
    f(s);
 220:	8526                	mv	a0,s1
 222:	9902                	jalr	s2
    exit(0);
 224:	4501                	li	a0,0
 226:	00000097          	auipc	ra,0x0
 22a:	35a080e7          	jalr	858(ra) # 580 <exit>
      printf("test %s: OK\n", s);
 22e:	85a6                	mv	a1,s1
 230:	00001517          	auipc	a0,0x1
 234:	c8850513          	addi	a0,a0,-888 # eb8 <strstr+0x134>
 238:	00000097          	auipc	ra,0x0
 23c:	6d8080e7          	jalr	1752(ra) # 910 <printf>
 240:	bf4d                	j	1f2 <run+0x52>

0000000000000242 <main>:

int
main(int argc, char *argv[])
{
 242:	7159                	addi	sp,sp,-112
 244:	f486                	sd	ra,104(sp)
 246:	f0a2                	sd	s0,96(sp)
 248:	eca6                	sd	s1,88(sp)
 24a:	e8ca                	sd	s2,80(sp)
 24c:	e4ce                	sd	s3,72(sp)
 24e:	e0d2                	sd	s4,64(sp)
 250:	1880                	addi	s0,sp,112
  char *n = 0;
  if(argc > 1) {
 252:	4785                	li	a5,1
  char *n = 0;
 254:	4901                	li	s2,0
  if(argc > 1) {
 256:	00a7d463          	bge	a5,a0,25e <main+0x1c>
    n = argv[1];
 25a:	0085b903          	ld	s2,8(a1)
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
 25e:	00001797          	auipc	a5,0x1
 262:	cb278793          	addi	a5,a5,-846 # f10 <strstr+0x18c>
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
    { sparse_memory_unmap, "lazy unmap"},
    { oom, "out of memory"},
    { 0, 0},
  };
    
  printf("lazytests starting\n");
 29a:	00001517          	auipc	a0,0x1
 29e:	c2e50513          	addi	a0,a0,-978 # ec8 <strstr+0x144>
 2a2:	00000097          	auipc	ra,0x0
 2a6:	66e080e7          	jalr	1646(ra) # 910 <printf>

  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
 2aa:	f9843503          	ld	a0,-104(s0)
 2ae:	c529                	beqz	a0,2f8 <main+0xb6>
 2b0:	f9040493          	addi	s1,s0,-112
  int fail = 0;
 2b4:	4981                	li	s3,0
    if((n == 0) || strcmp(t->s, n) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
 2b6:	4a05                	li	s4,1
 2b8:	a021                	j	2c0 <main+0x7e>
  for (struct test *t = tests; t->s != 0; t++) {
 2ba:	04c1                	addi	s1,s1,16
 2bc:	6488                	ld	a0,8(s1)
 2be:	c115                	beqz	a0,2e2 <main+0xa0>
    if((n == 0) || strcmp(t->s, n) == 0) {
 2c0:	00090863          	beqz	s2,2d0 <main+0x8e>
 2c4:	85ca                	mv	a1,s2
 2c6:	00000097          	auipc	ra,0x0
 2ca:	068080e7          	jalr	104(ra) # 32e <strcmp>
 2ce:	f575                	bnez	a0,2ba <main+0x78>
      if(!run(t->f, t->s))
 2d0:	648c                	ld	a1,8(s1)
 2d2:	6088                	ld	a0,0(s1)
 2d4:	00000097          	auipc	ra,0x0
 2d8:	ecc080e7          	jalr	-308(ra) # 1a0 <run>
 2dc:	fd79                	bnez	a0,2ba <main+0x78>
        fail = 1;
 2de:	89d2                	mv	s3,s4
 2e0:	bfe9                	j	2ba <main+0x78>
    }
  }
  if(!fail)
 2e2:	00098b63          	beqz	s3,2f8 <main+0xb6>
    printf("ALL TESTS PASSED\n");
  else
    printf("SOME TESTS FAILED\n");
 2e6:	00001517          	auipc	a0,0x1
 2ea:	c1250513          	addi	a0,a0,-1006 # ef8 <strstr+0x174>
 2ee:	00000097          	auipc	ra,0x0
 2f2:	622080e7          	jalr	1570(ra) # 910 <printf>
 2f6:	a809                	j	308 <main+0xc6>
    printf("ALL TESTS PASSED\n");
 2f8:	00001517          	auipc	a0,0x1
 2fc:	be850513          	addi	a0,a0,-1048 # ee0 <strstr+0x15c>
 300:	00000097          	auipc	ra,0x0
 304:	610080e7          	jalr	1552(ra) # 910 <printf>
  exit(1);   // not reached.
 308:	4505                	li	a0,1
 30a:	00000097          	auipc	ra,0x0
 30e:	276080e7          	jalr	630(ra) # 580 <exit>

0000000000000312 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 312:	1141                	addi	sp,sp,-16
 314:	e422                	sd	s0,8(sp)
 316:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 318:	87aa                	mv	a5,a0
 31a:	0585                	addi	a1,a1,1
 31c:	0785                	addi	a5,a5,1
 31e:	fff5c703          	lbu	a4,-1(a1)
 322:	fee78fa3          	sb	a4,-1(a5)
 326:	fb75                	bnez	a4,31a <strcpy+0x8>
    ;
  return os;
}
 328:	6422                	ld	s0,8(sp)
 32a:	0141                	addi	sp,sp,16
 32c:	8082                	ret

000000000000032e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 32e:	1141                	addi	sp,sp,-16
 330:	e422                	sd	s0,8(sp)
 332:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 334:	00054783          	lbu	a5,0(a0)
 338:	cb91                	beqz	a5,34c <strcmp+0x1e>
 33a:	0005c703          	lbu	a4,0(a1)
 33e:	00f71763          	bne	a4,a5,34c <strcmp+0x1e>
    p++, q++;
 342:	0505                	addi	a0,a0,1
 344:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 346:	00054783          	lbu	a5,0(a0)
 34a:	fbe5                	bnez	a5,33a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 34c:	0005c503          	lbu	a0,0(a1)
}
 350:	40a7853b          	subw	a0,a5,a0
 354:	6422                	ld	s0,8(sp)
 356:	0141                	addi	sp,sp,16
 358:	8082                	ret

000000000000035a <strlen>:

uint
strlen(const char *s)
{
 35a:	1141                	addi	sp,sp,-16
 35c:	e422                	sd	s0,8(sp)
 35e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
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
    ;
  return n;
}
 37a:	6422                	ld	s0,8(sp)
 37c:	0141                	addi	sp,sp,16
 37e:	8082                	ret
  for(n = 0; s[n]; n++)
 380:	4501                	li	a0,0
 382:	bfe5                	j	37a <strlen+0x20>

0000000000000384 <memset>:

void*
memset(void *dst, int c, uint n)
{
 384:	1141                	addi	sp,sp,-16
 386:	e422                	sd	s0,8(sp)
 388:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 38a:	ca19                	beqz	a2,3a0 <memset+0x1c>
 38c:	87aa                	mv	a5,a0
 38e:	1602                	slli	a2,a2,0x20
 390:	9201                	srli	a2,a2,0x20
 392:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 396:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 39a:	0785                	addi	a5,a5,1
 39c:	fee79de3          	bne	a5,a4,396 <memset+0x12>
  }
  return dst;
}
 3a0:	6422                	ld	s0,8(sp)
 3a2:	0141                	addi	sp,sp,16
 3a4:	8082                	ret

00000000000003a6 <strchr>:

char*
strchr(const char *s, char c)
{
 3a6:	1141                	addi	sp,sp,-16
 3a8:	e422                	sd	s0,8(sp)
 3aa:	0800                	addi	s0,sp,16
  for(; *s; s++)
 3ac:	00054783          	lbu	a5,0(a0)
 3b0:	cb99                	beqz	a5,3c6 <strchr+0x20>
    if(*s == c)
 3b2:	00f58763          	beq	a1,a5,3c0 <strchr+0x1a>
  for(; *s; s++)
 3b6:	0505                	addi	a0,a0,1
 3b8:	00054783          	lbu	a5,0(a0)
 3bc:	fbfd                	bnez	a5,3b2 <strchr+0xc>
      return (char*)s;
  return 0;
 3be:	4501                	li	a0,0
}
 3c0:	6422                	ld	s0,8(sp)
 3c2:	0141                	addi	sp,sp,16
 3c4:	8082                	ret
  return 0;
 3c6:	4501                	li	a0,0
 3c8:	bfe5                	j	3c0 <strchr+0x1a>

00000000000003ca <gets>:

char*
gets(char *buf, int max)
{
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
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3e4:	892a                	mv	s2,a0
 3e6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3e8:	4aa9                	li	s5,10
 3ea:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3ec:	89a6                	mv	s3,s1
 3ee:	2485                	addiw	s1,s1,1
 3f0:	0344d863          	bge	s1,s4,420 <gets+0x56>
    cc = read(0, &c, 1);
 3f4:	4605                	li	a2,1
 3f6:	faf40593          	addi	a1,s0,-81
 3fa:	4501                	li	a0,0
 3fc:	00000097          	auipc	ra,0x0
 400:	19c080e7          	jalr	412(ra) # 598 <read>
    if(cc < 1)
 404:	00a05e63          	blez	a0,420 <gets+0x56>
    buf[i++] = c;
 408:	faf44783          	lbu	a5,-81(s0)
 40c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 410:	01578763          	beq	a5,s5,41e <gets+0x54>
 414:	0905                	addi	s2,s2,1
 416:	fd679be3          	bne	a5,s6,3ec <gets+0x22>
  for(i=0; i+1 < max; ){
 41a:	89a6                	mv	s3,s1
 41c:	a011                	j	420 <gets+0x56>
 41e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 420:	99de                	add	s3,s3,s7
 422:	00098023          	sb	zero,0(s3) # 1000000 <__global_pointer$+0xffe7f5>
  return buf;
}
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

int
stat(const char *n, struct stat *st)
{
 43e:	1101                	addi	sp,sp,-32
 440:	ec06                	sd	ra,24(sp)
 442:	e822                	sd	s0,16(sp)
 444:	e426                	sd	s1,8(sp)
 446:	e04a                	sd	s2,0(sp)
 448:	1000                	addi	s0,sp,32
 44a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 44c:	4581                	li	a1,0
 44e:	00000097          	auipc	ra,0x0
 452:	172080e7          	jalr	370(ra) # 5c0 <open>
  if(fd < 0)
 456:	02054563          	bltz	a0,480 <stat+0x42>
 45a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 45c:	85ca                	mv	a1,s2
 45e:	00000097          	auipc	ra,0x0
 462:	17a080e7          	jalr	378(ra) # 5d8 <fstat>
 466:	892a                	mv	s2,a0
  close(fd);
 468:	8526                	mv	a0,s1
 46a:	00000097          	auipc	ra,0x0
 46e:	13e080e7          	jalr	318(ra) # 5a8 <close>
  return r;
}
 472:	854a                	mv	a0,s2
 474:	60e2                	ld	ra,24(sp)
 476:	6442                	ld	s0,16(sp)
 478:	64a2                	ld	s1,8(sp)
 47a:	6902                	ld	s2,0(sp)
 47c:	6105                	addi	sp,sp,32
 47e:	8082                	ret
    return -1;
 480:	597d                	li	s2,-1
 482:	bfc5                	j	472 <stat+0x34>

0000000000000484 <atoi>:

int
atoi(const char *s)
{
 484:	1141                	addi	sp,sp,-16
 486:	e422                	sd	s0,8(sp)
 488:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 48a:	00054603          	lbu	a2,0(a0)
 48e:	fd06079b          	addiw	a5,a2,-48
 492:	0ff7f793          	andi	a5,a5,255
 496:	4725                	li	a4,9
 498:	02f76963          	bltu	a4,a5,4ca <atoi+0x46>
 49c:	86aa                	mv	a3,a0
  n = 0;
 49e:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 4a0:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 4a2:	0685                	addi	a3,a3,1
 4a4:	0025179b          	slliw	a5,a0,0x2
 4a8:	9fa9                	addw	a5,a5,a0
 4aa:	0017979b          	slliw	a5,a5,0x1
 4ae:	9fb1                	addw	a5,a5,a2
 4b0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4b4:	0006c603          	lbu	a2,0(a3) # 40000 <__global_pointer$+0x3e7f5>
 4b8:	fd06071b          	addiw	a4,a2,-48
 4bc:	0ff77713          	andi	a4,a4,255
 4c0:	fee5f1e3          	bgeu	a1,a4,4a2 <atoi+0x1e>
  return n;
}
 4c4:	6422                	ld	s0,8(sp)
 4c6:	0141                	addi	sp,sp,16
 4c8:	8082                	ret
  n = 0;
 4ca:	4501                	li	a0,0
 4cc:	bfe5                	j	4c4 <atoi+0x40>

00000000000004ce <memmove>:

// #define memcpy memmove

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4ce:	1141                	addi	sp,sp,-16
 4d0:	e422                	sd	s0,8(sp)
 4d2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4d4:	02b57463          	bgeu	a0,a1,4fc <memmove+0x2e>
    while(n-- > 0)
 4d8:	00c05f63          	blez	a2,4f6 <memmove+0x28>
 4dc:	1602                	slli	a2,a2,0x20
 4de:	9201                	srli	a2,a2,0x20
 4e0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4e4:	872a                	mv	a4,a0
      *dst++ = *src++;
 4e6:	0585                	addi	a1,a1,1
 4e8:	0705                	addi	a4,a4,1
 4ea:	fff5c683          	lbu	a3,-1(a1)
 4ee:	fed70fa3          	sb	a3,-1(a4) # ffffff <__global_pointer$+0xffe7f4>
    while(n-- > 0)
 4f2:	fee79ae3          	bne	a5,a4,4e6 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4f6:	6422                	ld	s0,8(sp)
 4f8:	0141                	addi	sp,sp,16
 4fa:	8082                	ret
    dst += n;
 4fc:	00c50733          	add	a4,a0,a2
    src += n;
 500:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 502:	fec05ae3          	blez	a2,4f6 <memmove+0x28>
 506:	fff6079b          	addiw	a5,a2,-1
 50a:	1782                	slli	a5,a5,0x20
 50c:	9381                	srli	a5,a5,0x20
 50e:	fff7c793          	not	a5,a5
 512:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 514:	15fd                	addi	a1,a1,-1
 516:	177d                	addi	a4,a4,-1
 518:	0005c683          	lbu	a3,0(a1)
 51c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 520:	fee79ae3          	bne	a5,a4,514 <memmove+0x46>
 524:	bfc9                	j	4f6 <memmove+0x28>

0000000000000526 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 526:	1141                	addi	sp,sp,-16
 528:	e422                	sd	s0,8(sp)
 52a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 52c:	ca05                	beqz	a2,55c <memcmp+0x36>
 52e:	fff6069b          	addiw	a3,a2,-1
 532:	1682                	slli	a3,a3,0x20
 534:	9281                	srli	a3,a3,0x20
 536:	0685                	addi	a3,a3,1
 538:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 53a:	00054783          	lbu	a5,0(a0)
 53e:	0005c703          	lbu	a4,0(a1)
 542:	00e79863          	bne	a5,a4,552 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 546:	0505                	addi	a0,a0,1
    p2++;
 548:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 54a:	fed518e3          	bne	a0,a3,53a <memcmp+0x14>
  }
  return 0;
 54e:	4501                	li	a0,0
 550:	a019                	j	556 <memcmp+0x30>
      return *p1 - *p2;
 552:	40e7853b          	subw	a0,a5,a4
}
 556:	6422                	ld	s0,8(sp)
 558:	0141                	addi	sp,sp,16
 55a:	8082                	ret
  return 0;
 55c:	4501                	li	a0,0
 55e:	bfe5                	j	556 <memcmp+0x30>

0000000000000560 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 560:	1141                	addi	sp,sp,-16
 562:	e406                	sd	ra,8(sp)
 564:	e022                	sd	s0,0(sp)
 566:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 568:	00000097          	auipc	ra,0x0
 56c:	f66080e7          	jalr	-154(ra) # 4ce <memmove>
}
 570:	60a2                	ld	ra,8(sp)
 572:	6402                	ld	s0,0(sp)
 574:	0141                	addi	sp,sp,16
 576:	8082                	ret

0000000000000578 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 578:	4885                	li	a7,1
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <exit>:
.global exit
exit:
 li a7, SYS_exit
 580:	4889                	li	a7,2
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <wait>:
.global wait
wait:
 li a7, SYS_wait
 588:	488d                	li	a7,3
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 590:	4891                	li	a7,4
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <read>:
.global read
read:
 li a7, SYS_read
 598:	4895                	li	a7,5
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <write>:
.global write
write:
 li a7, SYS_write
 5a0:	48c1                	li	a7,16
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <close>:
.global close
close:
 li a7, SYS_close
 5a8:	48d5                	li	a7,21
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 5b0:	4899                	li	a7,6
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5b8:	489d                	li	a7,7
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <open>:
.global open
open:
 li a7, SYS_open
 5c0:	48bd                	li	a7,15
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5c8:	48c5                	li	a7,17
 ecall
 5ca:	00000073          	ecall
 ret
 5ce:	8082                	ret

00000000000005d0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5d0:	48c9                	li	a7,18
 ecall
 5d2:	00000073          	ecall
 ret
 5d6:	8082                	ret

00000000000005d8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5d8:	48a1                	li	a7,8
 ecall
 5da:	00000073          	ecall
 ret
 5de:	8082                	ret

00000000000005e0 <link>:
.global link
link:
 li a7, SYS_link
 5e0:	48cd                	li	a7,19
 ecall
 5e2:	00000073          	ecall
 ret
 5e6:	8082                	ret

00000000000005e8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5e8:	48d1                	li	a7,20
 ecall
 5ea:	00000073          	ecall
 ret
 5ee:	8082                	ret

00000000000005f0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5f0:	48a5                	li	a7,9
 ecall
 5f2:	00000073          	ecall
 ret
 5f6:	8082                	ret

00000000000005f8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5f8:	48a9                	li	a7,10
 ecall
 5fa:	00000073          	ecall
 ret
 5fe:	8082                	ret

0000000000000600 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 600:	48ad                	li	a7,11
 ecall
 602:	00000073          	ecall
 ret
 606:	8082                	ret

0000000000000608 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 608:	48b1                	li	a7,12
 ecall
 60a:	00000073          	ecall
 ret
 60e:	8082                	ret

0000000000000610 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 610:	48b5                	li	a7,13
 ecall
 612:	00000073          	ecall
 ret
 616:	8082                	ret

0000000000000618 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 618:	48b9                	li	a7,14
 ecall
 61a:	00000073          	ecall
 ret
 61e:	8082                	ret

0000000000000620 <trace>:
.global trace
trace:
 li a7, SYS_trace
 620:	48d9                	li	a7,22
 ecall
 622:	00000073          	ecall
 ret
 626:	8082                	ret

0000000000000628 <alarm>:
.global alarm
alarm:
 li a7, SYS_alarm
 628:	48dd                	li	a7,23
 ecall
 62a:	00000073          	ecall
 ret
 62e:	8082                	ret

0000000000000630 <alarmret>:
.global alarmret
alarmret:
 li a7, SYS_alarmret
 630:	48e1                	li	a7,24
 ecall
 632:	00000073          	ecall
 ret
 636:	8082                	ret

0000000000000638 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 638:	1101                	addi	sp,sp,-32
 63a:	ec06                	sd	ra,24(sp)
 63c:	e822                	sd	s0,16(sp)
 63e:	1000                	addi	s0,sp,32
 640:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 644:	4605                	li	a2,1
 646:	fef40593          	addi	a1,s0,-17
 64a:	00000097          	auipc	ra,0x0
 64e:	f56080e7          	jalr	-170(ra) # 5a0 <write>
}
 652:	60e2                	ld	ra,24(sp)
 654:	6442                	ld	s0,16(sp)
 656:	6105                	addi	sp,sp,32
 658:	8082                	ret

000000000000065a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 65a:	7139                	addi	sp,sp,-64
 65c:	fc06                	sd	ra,56(sp)
 65e:	f822                	sd	s0,48(sp)
 660:	f426                	sd	s1,40(sp)
 662:	f04a                	sd	s2,32(sp)
 664:	ec4e                	sd	s3,24(sp)
 666:	0080                	addi	s0,sp,64
 668:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 66a:	c299                	beqz	a3,670 <printint+0x16>
 66c:	0805c863          	bltz	a1,6fc <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 670:	2581                	sext.w	a1,a1
  neg = 0;
 672:	4881                	li	a7,0
 674:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 678:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 67a:	2601                	sext.w	a2,a2
 67c:	00001517          	auipc	a0,0x1
 680:	8dc50513          	addi	a0,a0,-1828 # f58 <digits>
 684:	883a                	mv	a6,a4
 686:	2705                	addiw	a4,a4,1
 688:	02c5f7bb          	remuw	a5,a1,a2
 68c:	1782                	slli	a5,a5,0x20
 68e:	9381                	srli	a5,a5,0x20
 690:	97aa                	add	a5,a5,a0
 692:	0007c783          	lbu	a5,0(a5)
 696:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 69a:	0005879b          	sext.w	a5,a1
 69e:	02c5d5bb          	divuw	a1,a1,a2
 6a2:	0685                	addi	a3,a3,1
 6a4:	fec7f0e3          	bgeu	a5,a2,684 <printint+0x2a>
  if(neg)
 6a8:	00088b63          	beqz	a7,6be <printint+0x64>
    buf[i++] = '-';
 6ac:	fd040793          	addi	a5,s0,-48
 6b0:	973e                	add	a4,a4,a5
 6b2:	02d00793          	li	a5,45
 6b6:	fef70823          	sb	a5,-16(a4)
 6ba:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6be:	02e05863          	blez	a4,6ee <printint+0x94>
 6c2:	fc040793          	addi	a5,s0,-64
 6c6:	00e78933          	add	s2,a5,a4
 6ca:	fff78993          	addi	s3,a5,-1
 6ce:	99ba                	add	s3,s3,a4
 6d0:	377d                	addiw	a4,a4,-1
 6d2:	1702                	slli	a4,a4,0x20
 6d4:	9301                	srli	a4,a4,0x20
 6d6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6da:	fff94583          	lbu	a1,-1(s2)
 6de:	8526                	mv	a0,s1
 6e0:	00000097          	auipc	ra,0x0
 6e4:	f58080e7          	jalr	-168(ra) # 638 <putc>
  while(--i >= 0)
 6e8:	197d                	addi	s2,s2,-1
 6ea:	ff3918e3          	bne	s2,s3,6da <printint+0x80>
}
 6ee:	70e2                	ld	ra,56(sp)
 6f0:	7442                	ld	s0,48(sp)
 6f2:	74a2                	ld	s1,40(sp)
 6f4:	7902                	ld	s2,32(sp)
 6f6:	69e2                	ld	s3,24(sp)
 6f8:	6121                	addi	sp,sp,64
 6fa:	8082                	ret
    x = -xx;
 6fc:	40b005bb          	negw	a1,a1
    neg = 1;
 700:	4885                	li	a7,1
    x = -xx;
 702:	bf8d                	j	674 <printint+0x1a>

0000000000000704 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 704:	7119                	addi	sp,sp,-128
 706:	fc86                	sd	ra,120(sp)
 708:	f8a2                	sd	s0,112(sp)
 70a:	f4a6                	sd	s1,104(sp)
 70c:	f0ca                	sd	s2,96(sp)
 70e:	ecce                	sd	s3,88(sp)
 710:	e8d2                	sd	s4,80(sp)
 712:	e4d6                	sd	s5,72(sp)
 714:	e0da                	sd	s6,64(sp)
 716:	fc5e                	sd	s7,56(sp)
 718:	f862                	sd	s8,48(sp)
 71a:	f466                	sd	s9,40(sp)
 71c:	f06a                	sd	s10,32(sp)
 71e:	ec6e                	sd	s11,24(sp)
 720:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 722:	0005c903          	lbu	s2,0(a1)
 726:	18090f63          	beqz	s2,8c4 <vprintf+0x1c0>
 72a:	8aaa                	mv	s5,a0
 72c:	8b32                	mv	s6,a2
 72e:	00158493          	addi	s1,a1,1
  state = 0;
 732:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 734:	02500a13          	li	s4,37
      if(c == 'd'){
 738:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 73c:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 740:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 744:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 748:	00001b97          	auipc	s7,0x1
 74c:	810b8b93          	addi	s7,s7,-2032 # f58 <digits>
 750:	a839                	j	76e <vprintf+0x6a>
        putc(fd, c);
 752:	85ca                	mv	a1,s2
 754:	8556                	mv	a0,s5
 756:	00000097          	auipc	ra,0x0
 75a:	ee2080e7          	jalr	-286(ra) # 638 <putc>
 75e:	a019                	j	764 <vprintf+0x60>
    } else if(state == '%'){
 760:	01498f63          	beq	s3,s4,77e <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 764:	0485                	addi	s1,s1,1
 766:	fff4c903          	lbu	s2,-1(s1) # 40000fff <__global_pointer$+0x3ffff7f4>
 76a:	14090d63          	beqz	s2,8c4 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 76e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 772:	fe0997e3          	bnez	s3,760 <vprintf+0x5c>
      if(c == '%'){
 776:	fd479ee3          	bne	a5,s4,752 <vprintf+0x4e>
        state = '%';
 77a:	89be                	mv	s3,a5
 77c:	b7e5                	j	764 <vprintf+0x60>
      if(c == 'd'){
 77e:	05878063          	beq	a5,s8,7be <vprintf+0xba>
      } else if(c == 'l') {
 782:	05978c63          	beq	a5,s9,7da <vprintf+0xd6>
      } else if(c == 'x') {
 786:	07a78863          	beq	a5,s10,7f6 <vprintf+0xf2>
      } else if(c == 'p') {
 78a:	09b78463          	beq	a5,s11,812 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 78e:	07300713          	li	a4,115
 792:	0ce78663          	beq	a5,a4,85e <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 796:	06300713          	li	a4,99
 79a:	0ee78e63          	beq	a5,a4,896 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 79e:	11478863          	beq	a5,s4,8ae <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7a2:	85d2                	mv	a1,s4
 7a4:	8556                	mv	a0,s5
 7a6:	00000097          	auipc	ra,0x0
 7aa:	e92080e7          	jalr	-366(ra) # 638 <putc>
        putc(fd, c);
 7ae:	85ca                	mv	a1,s2
 7b0:	8556                	mv	a0,s5
 7b2:	00000097          	auipc	ra,0x0
 7b6:	e86080e7          	jalr	-378(ra) # 638 <putc>
      }
      state = 0;
 7ba:	4981                	li	s3,0
 7bc:	b765                	j	764 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 7be:	008b0913          	addi	s2,s6,8
 7c2:	4685                	li	a3,1
 7c4:	4629                	li	a2,10
 7c6:	000b2583          	lw	a1,0(s6)
 7ca:	8556                	mv	a0,s5
 7cc:	00000097          	auipc	ra,0x0
 7d0:	e8e080e7          	jalr	-370(ra) # 65a <printint>
 7d4:	8b4a                	mv	s6,s2
      state = 0;
 7d6:	4981                	li	s3,0
 7d8:	b771                	j	764 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7da:	008b0913          	addi	s2,s6,8
 7de:	4681                	li	a3,0
 7e0:	4629                	li	a2,10
 7e2:	000b2583          	lw	a1,0(s6)
 7e6:	8556                	mv	a0,s5
 7e8:	00000097          	auipc	ra,0x0
 7ec:	e72080e7          	jalr	-398(ra) # 65a <printint>
 7f0:	8b4a                	mv	s6,s2
      state = 0;
 7f2:	4981                	li	s3,0
 7f4:	bf85                	j	764 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7f6:	008b0913          	addi	s2,s6,8
 7fa:	4681                	li	a3,0
 7fc:	4641                	li	a2,16
 7fe:	000b2583          	lw	a1,0(s6)
 802:	8556                	mv	a0,s5
 804:	00000097          	auipc	ra,0x0
 808:	e56080e7          	jalr	-426(ra) # 65a <printint>
 80c:	8b4a                	mv	s6,s2
      state = 0;
 80e:	4981                	li	s3,0
 810:	bf91                	j	764 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 812:	008b0793          	addi	a5,s6,8
 816:	f8f43423          	sd	a5,-120(s0)
 81a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 81e:	03000593          	li	a1,48
 822:	8556                	mv	a0,s5
 824:	00000097          	auipc	ra,0x0
 828:	e14080e7          	jalr	-492(ra) # 638 <putc>
  putc(fd, 'x');
 82c:	85ea                	mv	a1,s10
 82e:	8556                	mv	a0,s5
 830:	00000097          	auipc	ra,0x0
 834:	e08080e7          	jalr	-504(ra) # 638 <putc>
 838:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 83a:	03c9d793          	srli	a5,s3,0x3c
 83e:	97de                	add	a5,a5,s7
 840:	0007c583          	lbu	a1,0(a5)
 844:	8556                	mv	a0,s5
 846:	00000097          	auipc	ra,0x0
 84a:	df2080e7          	jalr	-526(ra) # 638 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 84e:	0992                	slli	s3,s3,0x4
 850:	397d                	addiw	s2,s2,-1
 852:	fe0914e3          	bnez	s2,83a <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 856:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 85a:	4981                	li	s3,0
 85c:	b721                	j	764 <vprintf+0x60>
        s = va_arg(ap, char*);
 85e:	008b0993          	addi	s3,s6,8
 862:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 866:	02090163          	beqz	s2,888 <vprintf+0x184>
        while(*s != 0){
 86a:	00094583          	lbu	a1,0(s2)
 86e:	c9a1                	beqz	a1,8be <vprintf+0x1ba>
          putc(fd, *s);
 870:	8556                	mv	a0,s5
 872:	00000097          	auipc	ra,0x0
 876:	dc6080e7          	jalr	-570(ra) # 638 <putc>
          s++;
 87a:	0905                	addi	s2,s2,1
        while(*s != 0){
 87c:	00094583          	lbu	a1,0(s2)
 880:	f9e5                	bnez	a1,870 <vprintf+0x16c>
        s = va_arg(ap, char*);
 882:	8b4e                	mv	s6,s3
      state = 0;
 884:	4981                	li	s3,0
 886:	bdf9                	j	764 <vprintf+0x60>
          s = "(null)";
 888:	00000917          	auipc	s2,0x0
 88c:	6c890913          	addi	s2,s2,1736 # f50 <strstr+0x1cc>
        while(*s != 0){
 890:	02800593          	li	a1,40
 894:	bff1                	j	870 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 896:	008b0913          	addi	s2,s6,8
 89a:	000b4583          	lbu	a1,0(s6)
 89e:	8556                	mv	a0,s5
 8a0:	00000097          	auipc	ra,0x0
 8a4:	d98080e7          	jalr	-616(ra) # 638 <putc>
 8a8:	8b4a                	mv	s6,s2
      state = 0;
 8aa:	4981                	li	s3,0
 8ac:	bd65                	j	764 <vprintf+0x60>
        putc(fd, c);
 8ae:	85d2                	mv	a1,s4
 8b0:	8556                	mv	a0,s5
 8b2:	00000097          	auipc	ra,0x0
 8b6:	d86080e7          	jalr	-634(ra) # 638 <putc>
      state = 0;
 8ba:	4981                	li	s3,0
 8bc:	b565                	j	764 <vprintf+0x60>
        s = va_arg(ap, char*);
 8be:	8b4e                	mv	s6,s3
      state = 0;
 8c0:	4981                	li	s3,0
 8c2:	b54d                	j	764 <vprintf+0x60>
    }
  }
}
 8c4:	70e6                	ld	ra,120(sp)
 8c6:	7446                	ld	s0,112(sp)
 8c8:	74a6                	ld	s1,104(sp)
 8ca:	7906                	ld	s2,96(sp)
 8cc:	69e6                	ld	s3,88(sp)
 8ce:	6a46                	ld	s4,80(sp)
 8d0:	6aa6                	ld	s5,72(sp)
 8d2:	6b06                	ld	s6,64(sp)
 8d4:	7be2                	ld	s7,56(sp)
 8d6:	7c42                	ld	s8,48(sp)
 8d8:	7ca2                	ld	s9,40(sp)
 8da:	7d02                	ld	s10,32(sp)
 8dc:	6de2                	ld	s11,24(sp)
 8de:	6109                	addi	sp,sp,128
 8e0:	8082                	ret

00000000000008e2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8e2:	715d                	addi	sp,sp,-80
 8e4:	ec06                	sd	ra,24(sp)
 8e6:	e822                	sd	s0,16(sp)
 8e8:	1000                	addi	s0,sp,32
 8ea:	e010                	sd	a2,0(s0)
 8ec:	e414                	sd	a3,8(s0)
 8ee:	e818                	sd	a4,16(s0)
 8f0:	ec1c                	sd	a5,24(s0)
 8f2:	03043023          	sd	a6,32(s0)
 8f6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8fa:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8fe:	8622                	mv	a2,s0
 900:	00000097          	auipc	ra,0x0
 904:	e04080e7          	jalr	-508(ra) # 704 <vprintf>
}
 908:	60e2                	ld	ra,24(sp)
 90a:	6442                	ld	s0,16(sp)
 90c:	6161                	addi	sp,sp,80
 90e:	8082                	ret

0000000000000910 <printf>:

void
printf(const char *fmt, ...)
{
 910:	711d                	addi	sp,sp,-96
 912:	ec06                	sd	ra,24(sp)
 914:	e822                	sd	s0,16(sp)
 916:	1000                	addi	s0,sp,32
 918:	e40c                	sd	a1,8(s0)
 91a:	e810                	sd	a2,16(s0)
 91c:	ec14                	sd	a3,24(s0)
 91e:	f018                	sd	a4,32(s0)
 920:	f41c                	sd	a5,40(s0)
 922:	03043823          	sd	a6,48(s0)
 926:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 92a:	00840613          	addi	a2,s0,8
 92e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 932:	85aa                	mv	a1,a0
 934:	4505                	li	a0,1
 936:	00000097          	auipc	ra,0x0
 93a:	dce080e7          	jalr	-562(ra) # 704 <vprintf>
}
 93e:	60e2                	ld	ra,24(sp)
 940:	6442                	ld	s0,16(sp)
 942:	6125                	addi	sp,sp,96
 944:	8082                	ret

0000000000000946 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 946:	1141                	addi	sp,sp,-16
 948:	e422                	sd	s0,8(sp)
 94a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 94c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 950:	00000797          	auipc	a5,0x0
 954:	6c07b783          	ld	a5,1728(a5) # 1010 <freep>
 958:	a805                	j	988 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 95a:	4618                	lw	a4,8(a2)
 95c:	9db9                	addw	a1,a1,a4
 95e:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 962:	6398                	ld	a4,0(a5)
 964:	6318                	ld	a4,0(a4)
 966:	fee53823          	sd	a4,-16(a0)
 96a:	a091                	j	9ae <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 96c:	ff852703          	lw	a4,-8(a0)
 970:	9e39                	addw	a2,a2,a4
 972:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 974:	ff053703          	ld	a4,-16(a0)
 978:	e398                	sd	a4,0(a5)
 97a:	a099                	j	9c0 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 97c:	6398                	ld	a4,0(a5)
 97e:	00e7e463          	bltu	a5,a4,986 <free+0x40>
 982:	00e6ea63          	bltu	a3,a4,996 <free+0x50>
{
 986:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 988:	fed7fae3          	bgeu	a5,a3,97c <free+0x36>
 98c:	6398                	ld	a4,0(a5)
 98e:	00e6e463          	bltu	a3,a4,996 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 992:	fee7eae3          	bltu	a5,a4,986 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 996:	ff852583          	lw	a1,-8(a0)
 99a:	6390                	ld	a2,0(a5)
 99c:	02059713          	slli	a4,a1,0x20
 9a0:	9301                	srli	a4,a4,0x20
 9a2:	0712                	slli	a4,a4,0x4
 9a4:	9736                	add	a4,a4,a3
 9a6:	fae60ae3          	beq	a2,a4,95a <free+0x14>
    bp->s.ptr = p->s.ptr;
 9aa:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9ae:	4790                	lw	a2,8(a5)
 9b0:	02061713          	slli	a4,a2,0x20
 9b4:	9301                	srli	a4,a4,0x20
 9b6:	0712                	slli	a4,a4,0x4
 9b8:	973e                	add	a4,a4,a5
 9ba:	fae689e3          	beq	a3,a4,96c <free+0x26>
  } else
    p->s.ptr = bp;
 9be:	e394                	sd	a3,0(a5)
  freep = p;
 9c0:	00000717          	auipc	a4,0x0
 9c4:	64f73823          	sd	a5,1616(a4) # 1010 <freep>
}
 9c8:	6422                	ld	s0,8(sp)
 9ca:	0141                	addi	sp,sp,16
 9cc:	8082                	ret

00000000000009ce <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9ce:	7139                	addi	sp,sp,-64
 9d0:	fc06                	sd	ra,56(sp)
 9d2:	f822                	sd	s0,48(sp)
 9d4:	f426                	sd	s1,40(sp)
 9d6:	f04a                	sd	s2,32(sp)
 9d8:	ec4e                	sd	s3,24(sp)
 9da:	e852                	sd	s4,16(sp)
 9dc:	e456                	sd	s5,8(sp)
 9de:	e05a                	sd	s6,0(sp)
 9e0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9e2:	02051493          	slli	s1,a0,0x20
 9e6:	9081                	srli	s1,s1,0x20
 9e8:	04bd                	addi	s1,s1,15
 9ea:	8091                	srli	s1,s1,0x4
 9ec:	0014899b          	addiw	s3,s1,1
 9f0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9f2:	00000517          	auipc	a0,0x0
 9f6:	61e53503          	ld	a0,1566(a0) # 1010 <freep>
 9fa:	c515                	beqz	a0,a26 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9fc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9fe:	4798                	lw	a4,8(a5)
 a00:	02977f63          	bgeu	a4,s1,a3e <malloc+0x70>
 a04:	8a4e                	mv	s4,s3
 a06:	0009871b          	sext.w	a4,s3
 a0a:	6685                	lui	a3,0x1
 a0c:	00d77363          	bgeu	a4,a3,a12 <malloc+0x44>
 a10:	6a05                	lui	s4,0x1
 a12:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a16:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a1a:	00000917          	auipc	s2,0x0
 a1e:	5f690913          	addi	s2,s2,1526 # 1010 <freep>
  if(p == (char*)-1)
 a22:	5afd                	li	s5,-1
 a24:	a88d                	j	a96 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 a26:	00000797          	auipc	a5,0x0
 a2a:	5f278793          	addi	a5,a5,1522 # 1018 <base>
 a2e:	00000717          	auipc	a4,0x0
 a32:	5ef73123          	sd	a5,1506(a4) # 1010 <freep>
 a36:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a38:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a3c:	b7e1                	j	a04 <malloc+0x36>
      if(p->s.size == nunits)
 a3e:	02e48b63          	beq	s1,a4,a74 <malloc+0xa6>
        p->s.size -= nunits;
 a42:	4137073b          	subw	a4,a4,s3
 a46:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a48:	1702                	slli	a4,a4,0x20
 a4a:	9301                	srli	a4,a4,0x20
 a4c:	0712                	slli	a4,a4,0x4
 a4e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a50:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a54:	00000717          	auipc	a4,0x0
 a58:	5aa73e23          	sd	a0,1468(a4) # 1010 <freep>
      return (void*)(p + 1);
 a5c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a60:	70e2                	ld	ra,56(sp)
 a62:	7442                	ld	s0,48(sp)
 a64:	74a2                	ld	s1,40(sp)
 a66:	7902                	ld	s2,32(sp)
 a68:	69e2                	ld	s3,24(sp)
 a6a:	6a42                	ld	s4,16(sp)
 a6c:	6aa2                	ld	s5,8(sp)
 a6e:	6b02                	ld	s6,0(sp)
 a70:	6121                	addi	sp,sp,64
 a72:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a74:	6398                	ld	a4,0(a5)
 a76:	e118                	sd	a4,0(a0)
 a78:	bff1                	j	a54 <malloc+0x86>
  hp->s.size = nu;
 a7a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a7e:	0541                	addi	a0,a0,16
 a80:	00000097          	auipc	ra,0x0
 a84:	ec6080e7          	jalr	-314(ra) # 946 <free>
  return freep;
 a88:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a8c:	d971                	beqz	a0,a60 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a8e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a90:	4798                	lw	a4,8(a5)
 a92:	fa9776e3          	bgeu	a4,s1,a3e <malloc+0x70>
    if(p == freep)
 a96:	00093703          	ld	a4,0(s2)
 a9a:	853e                	mv	a0,a5
 a9c:	fef719e3          	bne	a4,a5,a8e <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 aa0:	8552                	mv	a0,s4
 aa2:	00000097          	auipc	ra,0x0
 aa6:	b66080e7          	jalr	-1178(ra) # 608 <sbrk>
  if(p == (char*)-1)
 aaa:	fd5518e3          	bne	a0,s5,a7a <malloc+0xac>
        return 0;
 aae:	4501                	li	a0,0
 ab0:	bf45                	j	a60 <malloc+0x92>

0000000000000ab2 <Pipe>:
#include "kernel/stat.h"
#include "user.h"
#include "wrapper.h"
int strncmp(const char*s, const char*pat,int n);

int Pipe(int *p) {
 ab2:	1101                	addi	sp,sp,-32
 ab4:	ec06                	sd	ra,24(sp)
 ab6:	e822                	sd	s0,16(sp)
 ab8:	e426                	sd	s1,8(sp)
 aba:	1000                	addi	s0,sp,32
  i32 res = pipe(p);
 abc:	00000097          	auipc	ra,0x0
 ac0:	ad4080e7          	jalr	-1324(ra) # 590 <pipe>
 ac4:	84aa                	mv	s1,a0
  if (res < 0) {
 ac6:	00054863          	bltz	a0,ad6 <Pipe+0x24>
    fprintf(2, "pipe creation error");
  }
  return res;
}
 aca:	8526                	mv	a0,s1
 acc:	60e2                	ld	ra,24(sp)
 ace:	6442                	ld	s0,16(sp)
 ad0:	64a2                	ld	s1,8(sp)
 ad2:	6105                	addi	sp,sp,32
 ad4:	8082                	ret
    fprintf(2, "pipe creation error");
 ad6:	00000597          	auipc	a1,0x0
 ada:	49a58593          	addi	a1,a1,1178 # f70 <digits+0x18>
 ade:	4509                	li	a0,2
 ae0:	00000097          	auipc	ra,0x0
 ae4:	e02080e7          	jalr	-510(ra) # 8e2 <fprintf>
 ae8:	b7cd                	j	aca <Pipe+0x18>

0000000000000aea <Write>:

int Write(int fd, void *buf, int count){
 aea:	1141                	addi	sp,sp,-16
 aec:	e406                	sd	ra,8(sp)
 aee:	e022                	sd	s0,0(sp)
 af0:	0800                	addi	s0,sp,16
  i32 res = write(fd, buf, count);
 af2:	00000097          	auipc	ra,0x0
 af6:	aae080e7          	jalr	-1362(ra) # 5a0 <write>
  if (res < 0) {
 afa:	00054663          	bltz	a0,b06 <Write+0x1c>
    fprintf(2, "write error");
    exit(0);
  }
  return res;
}
 afe:	60a2                	ld	ra,8(sp)
 b00:	6402                	ld	s0,0(sp)
 b02:	0141                	addi	sp,sp,16
 b04:	8082                	ret
    fprintf(2, "write error");
 b06:	00000597          	auipc	a1,0x0
 b0a:	48258593          	addi	a1,a1,1154 # f88 <digits+0x30>
 b0e:	4509                	li	a0,2
 b10:	00000097          	auipc	ra,0x0
 b14:	dd2080e7          	jalr	-558(ra) # 8e2 <fprintf>
    exit(0);
 b18:	4501                	li	a0,0
 b1a:	00000097          	auipc	ra,0x0
 b1e:	a66080e7          	jalr	-1434(ra) # 580 <exit>

0000000000000b22 <Read>:



int Read(int fd,  void*buf, int count){
 b22:	1141                	addi	sp,sp,-16
 b24:	e406                	sd	ra,8(sp)
 b26:	e022                	sd	s0,0(sp)
 b28:	0800                	addi	s0,sp,16
  i32 res = read(fd, buf, count);
 b2a:	00000097          	auipc	ra,0x0
 b2e:	a6e080e7          	jalr	-1426(ra) # 598 <read>
  if (res < 0) {
 b32:	00054663          	bltz	a0,b3e <Read+0x1c>
    fprintf(2, "read error");
    exit(0);
  }
  return res;
}
 b36:	60a2                	ld	ra,8(sp)
 b38:	6402                	ld	s0,0(sp)
 b3a:	0141                	addi	sp,sp,16
 b3c:	8082                	ret
    fprintf(2, "read error");
 b3e:	00000597          	auipc	a1,0x0
 b42:	45a58593          	addi	a1,a1,1114 # f98 <digits+0x40>
 b46:	4509                	li	a0,2
 b48:	00000097          	auipc	ra,0x0
 b4c:	d9a080e7          	jalr	-614(ra) # 8e2 <fprintf>
    exit(0);
 b50:	4501                	li	a0,0
 b52:	00000097          	auipc	ra,0x0
 b56:	a2e080e7          	jalr	-1490(ra) # 580 <exit>

0000000000000b5a <Open>:


int Open(const char* path, int flag){
 b5a:	1141                	addi	sp,sp,-16
 b5c:	e406                	sd	ra,8(sp)
 b5e:	e022                	sd	s0,0(sp)
 b60:	0800                	addi	s0,sp,16
  i32 res = open(path, flag);
 b62:	00000097          	auipc	ra,0x0
 b66:	a5e080e7          	jalr	-1442(ra) # 5c0 <open>
  if (res < 0) {
 b6a:	00054663          	bltz	a0,b76 <Open+0x1c>
    fprintf(2, "open error");
    exit(0);
  }
  return res;
}
 b6e:	60a2                	ld	ra,8(sp)
 b70:	6402                	ld	s0,0(sp)
 b72:	0141                	addi	sp,sp,16
 b74:	8082                	ret
    fprintf(2, "open error");
 b76:	00000597          	auipc	a1,0x0
 b7a:	43258593          	addi	a1,a1,1074 # fa8 <digits+0x50>
 b7e:	4509                	li	a0,2
 b80:	00000097          	auipc	ra,0x0
 b84:	d62080e7          	jalr	-670(ra) # 8e2 <fprintf>
    exit(0);
 b88:	4501                	li	a0,0
 b8a:	00000097          	auipc	ra,0x0
 b8e:	9f6080e7          	jalr	-1546(ra) # 580 <exit>

0000000000000b92 <Fstat>:


int Fstat(int fd, stat_t *st){
 b92:	1141                	addi	sp,sp,-16
 b94:	e406                	sd	ra,8(sp)
 b96:	e022                	sd	s0,0(sp)
 b98:	0800                	addi	s0,sp,16
  i32 res = fstat(fd, st);
 b9a:	00000097          	auipc	ra,0x0
 b9e:	a3e080e7          	jalr	-1474(ra) # 5d8 <fstat>
  if (res < 0) {
 ba2:	00054663          	bltz	a0,bae <Fstat+0x1c>
    fprintf(2, "get file stat error");
    exit(0);
  }
  return res;
}
 ba6:	60a2                	ld	ra,8(sp)
 ba8:	6402                	ld	s0,0(sp)
 baa:	0141                	addi	sp,sp,16
 bac:	8082                	ret
    fprintf(2, "get file stat error");
 bae:	00000597          	auipc	a1,0x0
 bb2:	40a58593          	addi	a1,a1,1034 # fb8 <digits+0x60>
 bb6:	4509                	li	a0,2
 bb8:	00000097          	auipc	ra,0x0
 bbc:	d2a080e7          	jalr	-726(ra) # 8e2 <fprintf>
    exit(0);
 bc0:	4501                	li	a0,0
 bc2:	00000097          	auipc	ra,0x0
 bc6:	9be080e7          	jalr	-1602(ra) # 580 <exit>

0000000000000bca <Dup>:



int Dup(int fd){
 bca:	1141                	addi	sp,sp,-16
 bcc:	e406                	sd	ra,8(sp)
 bce:	e022                	sd	s0,0(sp)
 bd0:	0800                	addi	s0,sp,16
  i32 res = dup(fd);
 bd2:	00000097          	auipc	ra,0x0
 bd6:	a26080e7          	jalr	-1498(ra) # 5f8 <dup>
  if (res < 0) {
 bda:	00054663          	bltz	a0,be6 <Dup+0x1c>
    fprintf(2, "dup error");
    exit(0);
  }
  return res;

}
 bde:	60a2                	ld	ra,8(sp)
 be0:	6402                	ld	s0,0(sp)
 be2:	0141                	addi	sp,sp,16
 be4:	8082                	ret
    fprintf(2, "dup error");
 be6:	00000597          	auipc	a1,0x0
 bea:	3ea58593          	addi	a1,a1,1002 # fd0 <digits+0x78>
 bee:	4509                	li	a0,2
 bf0:	00000097          	auipc	ra,0x0
 bf4:	cf2080e7          	jalr	-782(ra) # 8e2 <fprintf>
    exit(0);
 bf8:	4501                	li	a0,0
 bfa:	00000097          	auipc	ra,0x0
 bfe:	986080e7          	jalr	-1658(ra) # 580 <exit>

0000000000000c02 <Close>:

int Close(int fd){
 c02:	1141                	addi	sp,sp,-16
 c04:	e406                	sd	ra,8(sp)
 c06:	e022                	sd	s0,0(sp)
 c08:	0800                	addi	s0,sp,16
  i32 res = close(fd);
 c0a:	00000097          	auipc	ra,0x0
 c0e:	99e080e7          	jalr	-1634(ra) # 5a8 <close>
  if (res < 0) {
 c12:	00054663          	bltz	a0,c1e <Close+0x1c>
    fprintf(2, "file close error~");
    exit(0);
  }
  return res;
}
 c16:	60a2                	ld	ra,8(sp)
 c18:	6402                	ld	s0,0(sp)
 c1a:	0141                	addi	sp,sp,16
 c1c:	8082                	ret
    fprintf(2, "file close error~");
 c1e:	00000597          	auipc	a1,0x0
 c22:	3c258593          	addi	a1,a1,962 # fe0 <digits+0x88>
 c26:	4509                	li	a0,2
 c28:	00000097          	auipc	ra,0x0
 c2c:	cba080e7          	jalr	-838(ra) # 8e2 <fprintf>
    exit(0);
 c30:	4501                	li	a0,0
 c32:	00000097          	auipc	ra,0x0
 c36:	94e080e7          	jalr	-1714(ra) # 580 <exit>

0000000000000c3a <Dup2>:

int Dup2(int old_fd,int new_fd){
 c3a:	1101                	addi	sp,sp,-32
 c3c:	ec06                	sd	ra,24(sp)
 c3e:	e822                	sd	s0,16(sp)
 c40:	e426                	sd	s1,8(sp)
 c42:	1000                	addi	s0,sp,32
 c44:	84aa                	mv	s1,a0
  Close(new_fd);
 c46:	852e                	mv	a0,a1
 c48:	00000097          	auipc	ra,0x0
 c4c:	fba080e7          	jalr	-70(ra) # c02 <Close>
  i32 res = Dup(old_fd);
 c50:	8526                	mv	a0,s1
 c52:	00000097          	auipc	ra,0x0
 c56:	f78080e7          	jalr	-136(ra) # bca <Dup>
  if (res < 0) {
 c5a:	00054763          	bltz	a0,c68 <Dup2+0x2e>
    fprintf(2, "dup error");
    exit(0);
  }
  return res;
}
 c5e:	60e2                	ld	ra,24(sp)
 c60:	6442                	ld	s0,16(sp)
 c62:	64a2                	ld	s1,8(sp)
 c64:	6105                	addi	sp,sp,32
 c66:	8082                	ret
    fprintf(2, "dup error");
 c68:	00000597          	auipc	a1,0x0
 c6c:	36858593          	addi	a1,a1,872 # fd0 <digits+0x78>
 c70:	4509                	li	a0,2
 c72:	00000097          	auipc	ra,0x0
 c76:	c70080e7          	jalr	-912(ra) # 8e2 <fprintf>
    exit(0);
 c7a:	4501                	li	a0,0
 c7c:	00000097          	auipc	ra,0x0
 c80:	904080e7          	jalr	-1788(ra) # 580 <exit>

0000000000000c84 <Stat>:

int Stat(const char*link,stat_t *st){
 c84:	1101                	addi	sp,sp,-32
 c86:	ec06                	sd	ra,24(sp)
 c88:	e822                	sd	s0,16(sp)
 c8a:	e426                	sd	s1,8(sp)
 c8c:	1000                	addi	s0,sp,32
 c8e:	84aa                	mv	s1,a0
  i32 res = stat(link,st);
 c90:	fffff097          	auipc	ra,0xfffff
 c94:	7ae080e7          	jalr	1966(ra) # 43e <stat>
  if (res < 0) {
 c98:	00054763          	bltz	a0,ca6 <Stat+0x22>
    fprintf(2, "file %s stat error",link);
    exit(0);
  }
  return res;
}
 c9c:	60e2                	ld	ra,24(sp)
 c9e:	6442                	ld	s0,16(sp)
 ca0:	64a2                	ld	s1,8(sp)
 ca2:	6105                	addi	sp,sp,32
 ca4:	8082                	ret
    fprintf(2, "file %s stat error",link);
 ca6:	8626                	mv	a2,s1
 ca8:	00000597          	auipc	a1,0x0
 cac:	35058593          	addi	a1,a1,848 # ff8 <digits+0xa0>
 cb0:	4509                	li	a0,2
 cb2:	00000097          	auipc	ra,0x0
 cb6:	c30080e7          	jalr	-976(ra) # 8e2 <fprintf>
    exit(0);
 cba:	4501                	li	a0,0
 cbc:	00000097          	auipc	ra,0x0
 cc0:	8c4080e7          	jalr	-1852(ra) # 580 <exit>

0000000000000cc4 <strncmp>:
   return -1;
}



int strncmp(const char*s, const char*pat,int n){
 cc4:	bc010113          	addi	sp,sp,-1088
 cc8:	42113c23          	sd	ra,1080(sp)
 ccc:	42813823          	sd	s0,1072(sp)
 cd0:	42913423          	sd	s1,1064(sp)
 cd4:	43213023          	sd	s2,1056(sp)
 cd8:	41313c23          	sd	s3,1048(sp)
 cdc:	41413823          	sd	s4,1040(sp)
 ce0:	41513423          	sd	s5,1032(sp)
 ce4:	44010413          	addi	s0,sp,1088
 ce8:	89aa                	mv	s3,a0
 cea:	892e                	mv	s2,a1
 cec:	84b2                	mv	s1,a2
  char buf1[512],buf2[512];
  int n1 = MIN(n,strlen(s));
 cee:	fffff097          	auipc	ra,0xfffff
 cf2:	66c080e7          	jalr	1644(ra) # 35a <strlen>
 cf6:	2501                	sext.w	a0,a0
 cf8:	00048a1b          	sext.w	s4,s1
 cfc:	8aa6                	mv	s5,s1
 cfe:	06aa7363          	bgeu	s4,a0,d64 <strncmp+0xa0>
  int n2 = MIN(n,strlen(pat));
 d02:	854a                	mv	a0,s2
 d04:	fffff097          	auipc	ra,0xfffff
 d08:	656080e7          	jalr	1622(ra) # 35a <strlen>
 d0c:	2501                	sext.w	a0,a0
 d0e:	06aa7363          	bgeu	s4,a0,d74 <strncmp+0xb0>
  memmove(buf1,s,n1);
 d12:	8656                	mv	a2,s5
 d14:	85ce                	mv	a1,s3
 d16:	dc040513          	addi	a0,s0,-576
 d1a:	fffff097          	auipc	ra,0xfffff
 d1e:	7b4080e7          	jalr	1972(ra) # 4ce <memmove>
  memmove(buf2,pat,n2);
 d22:	8626                	mv	a2,s1
 d24:	85ca                	mv	a1,s2
 d26:	bc040513          	addi	a0,s0,-1088
 d2a:	fffff097          	auipc	ra,0xfffff
 d2e:	7a4080e7          	jalr	1956(ra) # 4ce <memmove>
  return strcmp(buf1,buf2);
 d32:	bc040593          	addi	a1,s0,-1088
 d36:	dc040513          	addi	a0,s0,-576
 d3a:	fffff097          	auipc	ra,0xfffff
 d3e:	5f4080e7          	jalr	1524(ra) # 32e <strcmp>
}
 d42:	43813083          	ld	ra,1080(sp)
 d46:	43013403          	ld	s0,1072(sp)
 d4a:	42813483          	ld	s1,1064(sp)
 d4e:	42013903          	ld	s2,1056(sp)
 d52:	41813983          	ld	s3,1048(sp)
 d56:	41013a03          	ld	s4,1040(sp)
 d5a:	40813a83          	ld	s5,1032(sp)
 d5e:	44010113          	addi	sp,sp,1088
 d62:	8082                	ret
  int n1 = MIN(n,strlen(s));
 d64:	854e                	mv	a0,s3
 d66:	fffff097          	auipc	ra,0xfffff
 d6a:	5f4080e7          	jalr	1524(ra) # 35a <strlen>
 d6e:	00050a9b          	sext.w	s5,a0
 d72:	bf41                	j	d02 <strncmp+0x3e>
  int n2 = MIN(n,strlen(pat));
 d74:	854a                	mv	a0,s2
 d76:	fffff097          	auipc	ra,0xfffff
 d7a:	5e4080e7          	jalr	1508(ra) # 35a <strlen>
 d7e:	0005049b          	sext.w	s1,a0
 d82:	bf41                	j	d12 <strncmp+0x4e>

0000000000000d84 <strstr>:
   while (*s != 0){
 d84:	00054783          	lbu	a5,0(a0)
 d88:	cba1                	beqz	a5,dd8 <strstr+0x54>
int strstr(char *s,char *p){
 d8a:	7179                	addi	sp,sp,-48
 d8c:	f406                	sd	ra,40(sp)
 d8e:	f022                	sd	s0,32(sp)
 d90:	ec26                	sd	s1,24(sp)
 d92:	e84a                	sd	s2,16(sp)
 d94:	e44e                	sd	s3,8(sp)
 d96:	1800                	addi	s0,sp,48
 d98:	89aa                	mv	s3,a0
 d9a:	892e                	mv	s2,a1
   while (*s != 0){
 d9c:	84aa                	mv	s1,a0
     if (!strncmp(s,p,strlen(p)))
 d9e:	854a                	mv	a0,s2
 da0:	fffff097          	auipc	ra,0xfffff
 da4:	5ba080e7          	jalr	1466(ra) # 35a <strlen>
 da8:	0005061b          	sext.w	a2,a0
 dac:	85ca                	mv	a1,s2
 dae:	8526                	mv	a0,s1
 db0:	00000097          	auipc	ra,0x0
 db4:	f14080e7          	jalr	-236(ra) # cc4 <strncmp>
 db8:	c519                	beqz	a0,dc6 <strstr+0x42>
     s++;
 dba:	0485                	addi	s1,s1,1
   while (*s != 0){
 dbc:	0004c783          	lbu	a5,0(s1)
 dc0:	fff9                	bnez	a5,d9e <strstr+0x1a>
   return -1;
 dc2:	557d                	li	a0,-1
 dc4:	a019                	j	dca <strstr+0x46>
      return s - ori;
 dc6:	4134853b          	subw	a0,s1,s3
}
 dca:	70a2                	ld	ra,40(sp)
 dcc:	7402                	ld	s0,32(sp)
 dce:	64e2                	ld	s1,24(sp)
 dd0:	6942                	ld	s2,16(sp)
 dd2:	69a2                	ld	s3,8(sp)
 dd4:	6145                	addi	sp,sp,48
 dd6:	8082                	ret
   return -1;
 dd8:	557d                	li	a0,-1
}
 dda:	8082                	ret
