
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/fs.h"
#include "user/wrapper.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  10:	00000097          	auipc	ra,0x0
  14:	2aa080e7          	jalr	682(ra) # 2ba <strlen>
  18:	02051793          	slli	a5,a0,0x20
  1c:	9381                	srli	a5,a5,0x20
  1e:	97a6                	add	a5,a5,s1
  20:	02f00693          	li	a3,47
  24:	0097e963          	bltu	a5,s1,36 <fmtname+0x36>
  28:	0007c703          	lbu	a4,0(a5)
  2c:	00d70563          	beq	a4,a3,36 <fmtname+0x36>
  30:	17fd                	addi	a5,a5,-1
  32:	fe97fbe3          	bgeu	a5,s1,28 <fmtname+0x28>
    ;
  p++;
  36:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  3a:	8526                	mv	a0,s1
  3c:	00000097          	auipc	ra,0x0
  40:	27e080e7          	jalr	638(ra) # 2ba <strlen>
  44:	2501                	sext.w	a0,a0
  46:	47b5                	li	a5,13
  48:	00a7fa63          	bgeu	a5,a0,5c <fmtname+0x5c>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  4c:	8526                	mv	a0,s1
  4e:	70a2                	ld	ra,40(sp)
  50:	7402                	ld	s0,32(sp)
  52:	64e2                	ld	s1,24(sp)
  54:	6942                	ld	s2,16(sp)
  56:	69a2                	ld	s3,8(sp)
  58:	6145                	addi	sp,sp,48
  5a:	8082                	ret
  memmove(buf, p, strlen(p));
  5c:	8526                	mv	a0,s1
  5e:	00000097          	auipc	ra,0x0
  62:	25c080e7          	jalr	604(ra) # 2ba <strlen>
  66:	00001997          	auipc	s3,0x1
  6a:	de298993          	addi	s3,s3,-542 # e48 <buf.0>
  6e:	0005061b          	sext.w	a2,a0
  72:	85a6                	mv	a1,s1
  74:	854e                	mv	a0,s3
  76:	00000097          	auipc	ra,0x0
  7a:	3b8080e7          	jalr	952(ra) # 42e <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  7e:	8526                	mv	a0,s1
  80:	00000097          	auipc	ra,0x0
  84:	23a080e7          	jalr	570(ra) # 2ba <strlen>
  88:	0005091b          	sext.w	s2,a0
  8c:	8526                	mv	a0,s1
  8e:	00000097          	auipc	ra,0x0
  92:	22c080e7          	jalr	556(ra) # 2ba <strlen>
  96:	1902                	slli	s2,s2,0x20
  98:	02095913          	srli	s2,s2,0x20
  9c:	4639                	li	a2,14
  9e:	9e09                	subw	a2,a2,a0
  a0:	02000593          	li	a1,32
  a4:	01298533          	add	a0,s3,s2
  a8:	00000097          	auipc	ra,0x0
  ac:	23c080e7          	jalr	572(ra) # 2e4 <memset>
  return buf;
  b0:	84ce                	mv	s1,s3
  b2:	bf69                	j	4c <fmtname+0x4c>

00000000000000b4 <ls>:

void
ls(char *path)
{
  b4:	da010113          	addi	sp,sp,-608
  b8:	24113c23          	sd	ra,600(sp)
  bc:	24813823          	sd	s0,592(sp)
  c0:	24913423          	sd	s1,584(sp)
  c4:	25213023          	sd	s2,576(sp)
  c8:	23313c23          	sd	s3,568(sp)
  cc:	23413823          	sd	s4,560(sp)
  d0:	1480                	addi	s0,sp,608
  d2:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  fd = Open(path, 0);
  d4:	4581                	li	a1,0
  d6:	00001097          	auipc	ra,0x1
  da:	9e4080e7          	jalr	-1564(ra) # aba <Open>
  de:	84aa                	mv	s1,a0
  Fstat(fd, &st);
  e0:	da840593          	addi	a1,s0,-600
  e4:	00001097          	auipc	ra,0x1
  e8:	a0e080e7          	jalr	-1522(ra) # af2 <Fstat>

  switch(st.type){
  ec:	db041783          	lh	a5,-592(s0)
  f0:	0007869b          	sext.w	a3,a5
  f4:	4705                	li	a4,1
  f6:	04e68d63          	beq	a3,a4,150 <ls+0x9c>
  fa:	4709                	li	a4,2
  fc:	02e69663          	bne	a3,a4,128 <ls+0x74>
  case T_FILE:
    printf("%s %d %d %l\n", fmtname(path), st.type, st.ino, st.size);
 100:	854a                	mv	a0,s2
 102:	00000097          	auipc	ra,0x0
 106:	efe080e7          	jalr	-258(ra) # 0 <fmtname>
 10a:	85aa                	mv	a1,a0
 10c:	db843703          	ld	a4,-584(s0)
 110:	dac42683          	lw	a3,-596(s0)
 114:	db041603          	lh	a2,-592(s0)
 118:	00001517          	auipc	a0,0x1
 11c:	c2850513          	addi	a0,a0,-984 # d40 <strstr+0x5c>
 120:	00000097          	auipc	ra,0x0
 124:	750080e7          	jalr	1872(ra) # 870 <printf>
      Stat(buf, &st);
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 128:	8526                	mv	a0,s1
 12a:	00000097          	auipc	ra,0x0
 12e:	3de080e7          	jalr	990(ra) # 508 <close>
}
 132:	25813083          	ld	ra,600(sp)
 136:	25013403          	ld	s0,592(sp)
 13a:	24813483          	ld	s1,584(sp)
 13e:	24013903          	ld	s2,576(sp)
 142:	23813983          	ld	s3,568(sp)
 146:	23013a03          	ld	s4,560(sp)
 14a:	26010113          	addi	sp,sp,608
 14e:	8082                	ret
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 150:	854a                	mv	a0,s2
 152:	00000097          	auipc	ra,0x0
 156:	168080e7          	jalr	360(ra) # 2ba <strlen>
 15a:	2541                	addiw	a0,a0,16
 15c:	20000793          	li	a5,512
 160:	00a7fb63          	bgeu	a5,a0,176 <ls+0xc2>
      printf("ls: path too long\n");
 164:	00001517          	auipc	a0,0x1
 168:	bec50513          	addi	a0,a0,-1044 # d50 <strstr+0x6c>
 16c:	00000097          	auipc	ra,0x0
 170:	704080e7          	jalr	1796(ra) # 870 <printf>
      break;
 174:	bf55                	j	128 <ls+0x74>
    strcpy(buf, path);
 176:	85ca                	mv	a1,s2
 178:	dd040513          	addi	a0,s0,-560
 17c:	00000097          	auipc	ra,0x0
 180:	0f6080e7          	jalr	246(ra) # 272 <strcpy>
    p = buf+strlen(buf);
 184:	dd040513          	addi	a0,s0,-560
 188:	00000097          	auipc	ra,0x0
 18c:	132080e7          	jalr	306(ra) # 2ba <strlen>
 190:	02051913          	slli	s2,a0,0x20
 194:	02095913          	srli	s2,s2,0x20
 198:	dd040793          	addi	a5,s0,-560
 19c:	993e                	add	s2,s2,a5
    *p++ = '/';
 19e:	00190a13          	addi	s4,s2,1
 1a2:	02f00793          	li	a5,47
 1a6:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 1aa:	00001997          	auipc	s3,0x1
 1ae:	bbe98993          	addi	s3,s3,-1090 # d68 <strstr+0x84>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1b2:	4641                	li	a2,16
 1b4:	dc040593          	addi	a1,s0,-576
 1b8:	8526                	mv	a0,s1
 1ba:	00000097          	auipc	ra,0x0
 1be:	33e080e7          	jalr	830(ra) # 4f8 <read>
 1c2:	47c1                	li	a5,16
 1c4:	f6f512e3          	bne	a0,a5,128 <ls+0x74>
      if(de.inum == 0)
 1c8:	dc045783          	lhu	a5,-576(s0)
 1cc:	d3fd                	beqz	a5,1b2 <ls+0xfe>
      memmove(p, de.name, DIRSIZ);
 1ce:	4639                	li	a2,14
 1d0:	dc240593          	addi	a1,s0,-574
 1d4:	8552                	mv	a0,s4
 1d6:	00000097          	auipc	ra,0x0
 1da:	258080e7          	jalr	600(ra) # 42e <memmove>
      p[DIRSIZ] = 0;
 1de:	000907a3          	sb	zero,15(s2)
      Stat(buf, &st);
 1e2:	da840593          	addi	a1,s0,-600
 1e6:	dd040513          	addi	a0,s0,-560
 1ea:	00001097          	auipc	ra,0x1
 1ee:	9fa080e7          	jalr	-1542(ra) # be4 <Stat>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 1f2:	dd040513          	addi	a0,s0,-560
 1f6:	00000097          	auipc	ra,0x0
 1fa:	e0a080e7          	jalr	-502(ra) # 0 <fmtname>
 1fe:	85aa                	mv	a1,a0
 200:	db843703          	ld	a4,-584(s0)
 204:	dac42683          	lw	a3,-596(s0)
 208:	db041603          	lh	a2,-592(s0)
 20c:	854e                	mv	a0,s3
 20e:	00000097          	auipc	ra,0x0
 212:	662080e7          	jalr	1634(ra) # 870 <printf>
 216:	bf71                	j	1b2 <ls+0xfe>

0000000000000218 <main>:

int
main(int argc, char *argv[])
{
 218:	1101                	addi	sp,sp,-32
 21a:	ec06                	sd	ra,24(sp)
 21c:	e822                	sd	s0,16(sp)
 21e:	e426                	sd	s1,8(sp)
 220:	e04a                	sd	s2,0(sp)
 222:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 224:	4785                	li	a5,1
 226:	02a7d963          	bge	a5,a0,258 <main+0x40>
 22a:	00858493          	addi	s1,a1,8
 22e:	ffe5091b          	addiw	s2,a0,-2
 232:	1902                	slli	s2,s2,0x20
 234:	02095913          	srli	s2,s2,0x20
 238:	090e                	slli	s2,s2,0x3
 23a:	05c1                	addi	a1,a1,16
 23c:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 23e:	6088                	ld	a0,0(s1)
 240:	00000097          	auipc	ra,0x0
 244:	e74080e7          	jalr	-396(ra) # b4 <ls>
  for(i=1; i<argc; i++)
 248:	04a1                	addi	s1,s1,8
 24a:	ff249ae3          	bne	s1,s2,23e <main+0x26>
  exit(0);
 24e:	4501                	li	a0,0
 250:	00000097          	auipc	ra,0x0
 254:	290080e7          	jalr	656(ra) # 4e0 <exit>
    ls(".");
 258:	00001517          	auipc	a0,0x1
 25c:	b2050513          	addi	a0,a0,-1248 # d78 <strstr+0x94>
 260:	00000097          	auipc	ra,0x0
 264:	e54080e7          	jalr	-428(ra) # b4 <ls>
    exit(0);
 268:	4501                	li	a0,0
 26a:	00000097          	auipc	ra,0x0
 26e:	276080e7          	jalr	630(ra) # 4e0 <exit>

0000000000000272 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 272:	1141                	addi	sp,sp,-16
 274:	e422                	sd	s0,8(sp)
 276:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 278:	87aa                	mv	a5,a0
 27a:	0585                	addi	a1,a1,1
 27c:	0785                	addi	a5,a5,1
 27e:	fff5c703          	lbu	a4,-1(a1)
 282:	fee78fa3          	sb	a4,-1(a5)
 286:	fb75                	bnez	a4,27a <strcpy+0x8>
    ;
  return os;
}
 288:	6422                	ld	s0,8(sp)
 28a:	0141                	addi	sp,sp,16
 28c:	8082                	ret

000000000000028e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 28e:	1141                	addi	sp,sp,-16
 290:	e422                	sd	s0,8(sp)
 292:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 294:	00054783          	lbu	a5,0(a0)
 298:	cb91                	beqz	a5,2ac <strcmp+0x1e>
 29a:	0005c703          	lbu	a4,0(a1)
 29e:	00f71763          	bne	a4,a5,2ac <strcmp+0x1e>
    p++, q++;
 2a2:	0505                	addi	a0,a0,1
 2a4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2a6:	00054783          	lbu	a5,0(a0)
 2aa:	fbe5                	bnez	a5,29a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2ac:	0005c503          	lbu	a0,0(a1)
}
 2b0:	40a7853b          	subw	a0,a5,a0
 2b4:	6422                	ld	s0,8(sp)
 2b6:	0141                	addi	sp,sp,16
 2b8:	8082                	ret

00000000000002ba <strlen>:

uint
strlen(const char *s)
{
 2ba:	1141                	addi	sp,sp,-16
 2bc:	e422                	sd	s0,8(sp)
 2be:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2c0:	00054783          	lbu	a5,0(a0)
 2c4:	cf91                	beqz	a5,2e0 <strlen+0x26>
 2c6:	0505                	addi	a0,a0,1
 2c8:	87aa                	mv	a5,a0
 2ca:	4685                	li	a3,1
 2cc:	9e89                	subw	a3,a3,a0
 2ce:	00f6853b          	addw	a0,a3,a5
 2d2:	0785                	addi	a5,a5,1
 2d4:	fff7c703          	lbu	a4,-1(a5)
 2d8:	fb7d                	bnez	a4,2ce <strlen+0x14>
    ;
  return n;
}
 2da:	6422                	ld	s0,8(sp)
 2dc:	0141                	addi	sp,sp,16
 2de:	8082                	ret
  for(n = 0; s[n]; n++)
 2e0:	4501                	li	a0,0
 2e2:	bfe5                	j	2da <strlen+0x20>

00000000000002e4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2e4:	1141                	addi	sp,sp,-16
 2e6:	e422                	sd	s0,8(sp)
 2e8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2ea:	ca19                	beqz	a2,300 <memset+0x1c>
 2ec:	87aa                	mv	a5,a0
 2ee:	1602                	slli	a2,a2,0x20
 2f0:	9201                	srli	a2,a2,0x20
 2f2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2f6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2fa:	0785                	addi	a5,a5,1
 2fc:	fee79de3          	bne	a5,a4,2f6 <memset+0x12>
  }
  return dst;
}
 300:	6422                	ld	s0,8(sp)
 302:	0141                	addi	sp,sp,16
 304:	8082                	ret

0000000000000306 <strchr>:

char*
strchr(const char *s, char c)
{
 306:	1141                	addi	sp,sp,-16
 308:	e422                	sd	s0,8(sp)
 30a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 30c:	00054783          	lbu	a5,0(a0)
 310:	cb99                	beqz	a5,326 <strchr+0x20>
    if(*s == c)
 312:	00f58763          	beq	a1,a5,320 <strchr+0x1a>
  for(; *s; s++)
 316:	0505                	addi	a0,a0,1
 318:	00054783          	lbu	a5,0(a0)
 31c:	fbfd                	bnez	a5,312 <strchr+0xc>
      return (char*)s;
  return 0;
 31e:	4501                	li	a0,0
}
 320:	6422                	ld	s0,8(sp)
 322:	0141                	addi	sp,sp,16
 324:	8082                	ret
  return 0;
 326:	4501                	li	a0,0
 328:	bfe5                	j	320 <strchr+0x1a>

000000000000032a <gets>:

char*
gets(char *buf, int max)
{
 32a:	711d                	addi	sp,sp,-96
 32c:	ec86                	sd	ra,88(sp)
 32e:	e8a2                	sd	s0,80(sp)
 330:	e4a6                	sd	s1,72(sp)
 332:	e0ca                	sd	s2,64(sp)
 334:	fc4e                	sd	s3,56(sp)
 336:	f852                	sd	s4,48(sp)
 338:	f456                	sd	s5,40(sp)
 33a:	f05a                	sd	s6,32(sp)
 33c:	ec5e                	sd	s7,24(sp)
 33e:	1080                	addi	s0,sp,96
 340:	8baa                	mv	s7,a0
 342:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 344:	892a                	mv	s2,a0
 346:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 348:	4aa9                	li	s5,10
 34a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 34c:	89a6                	mv	s3,s1
 34e:	2485                	addiw	s1,s1,1
 350:	0344d863          	bge	s1,s4,380 <gets+0x56>
    cc = read(0, &c, 1);
 354:	4605                	li	a2,1
 356:	faf40593          	addi	a1,s0,-81
 35a:	4501                	li	a0,0
 35c:	00000097          	auipc	ra,0x0
 360:	19c080e7          	jalr	412(ra) # 4f8 <read>
    if(cc < 1)
 364:	00a05e63          	blez	a0,380 <gets+0x56>
    buf[i++] = c;
 368:	faf44783          	lbu	a5,-81(s0)
 36c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 370:	01578763          	beq	a5,s5,37e <gets+0x54>
 374:	0905                	addi	s2,s2,1
 376:	fd679be3          	bne	a5,s6,34c <gets+0x22>
  for(i=0; i+1 < max; ){
 37a:	89a6                	mv	s3,s1
 37c:	a011                	j	380 <gets+0x56>
 37e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 380:	99de                	add	s3,s3,s7
 382:	00098023          	sb	zero,0(s3)
  return buf;
}
 386:	855e                	mv	a0,s7
 388:	60e6                	ld	ra,88(sp)
 38a:	6446                	ld	s0,80(sp)
 38c:	64a6                	ld	s1,72(sp)
 38e:	6906                	ld	s2,64(sp)
 390:	79e2                	ld	s3,56(sp)
 392:	7a42                	ld	s4,48(sp)
 394:	7aa2                	ld	s5,40(sp)
 396:	7b02                	ld	s6,32(sp)
 398:	6be2                	ld	s7,24(sp)
 39a:	6125                	addi	sp,sp,96
 39c:	8082                	ret

000000000000039e <stat>:

int
stat(const char *n, struct stat *st)
{
 39e:	1101                	addi	sp,sp,-32
 3a0:	ec06                	sd	ra,24(sp)
 3a2:	e822                	sd	s0,16(sp)
 3a4:	e426                	sd	s1,8(sp)
 3a6:	e04a                	sd	s2,0(sp)
 3a8:	1000                	addi	s0,sp,32
 3aa:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3ac:	4581                	li	a1,0
 3ae:	00000097          	auipc	ra,0x0
 3b2:	172080e7          	jalr	370(ra) # 520 <open>
  if(fd < 0)
 3b6:	02054563          	bltz	a0,3e0 <stat+0x42>
 3ba:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3bc:	85ca                	mv	a1,s2
 3be:	00000097          	auipc	ra,0x0
 3c2:	17a080e7          	jalr	378(ra) # 538 <fstat>
 3c6:	892a                	mv	s2,a0
  close(fd);
 3c8:	8526                	mv	a0,s1
 3ca:	00000097          	auipc	ra,0x0
 3ce:	13e080e7          	jalr	318(ra) # 508 <close>
  return r;
}
 3d2:	854a                	mv	a0,s2
 3d4:	60e2                	ld	ra,24(sp)
 3d6:	6442                	ld	s0,16(sp)
 3d8:	64a2                	ld	s1,8(sp)
 3da:	6902                	ld	s2,0(sp)
 3dc:	6105                	addi	sp,sp,32
 3de:	8082                	ret
    return -1;
 3e0:	597d                	li	s2,-1
 3e2:	bfc5                	j	3d2 <stat+0x34>

00000000000003e4 <atoi>:

int
atoi(const char *s)
{
 3e4:	1141                	addi	sp,sp,-16
 3e6:	e422                	sd	s0,8(sp)
 3e8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3ea:	00054603          	lbu	a2,0(a0)
 3ee:	fd06079b          	addiw	a5,a2,-48
 3f2:	0ff7f793          	andi	a5,a5,255
 3f6:	4725                	li	a4,9
 3f8:	02f76963          	bltu	a4,a5,42a <atoi+0x46>
 3fc:	86aa                	mv	a3,a0
  n = 0;
 3fe:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 400:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 402:	0685                	addi	a3,a3,1
 404:	0025179b          	slliw	a5,a0,0x2
 408:	9fa9                	addw	a5,a5,a0
 40a:	0017979b          	slliw	a5,a5,0x1
 40e:	9fb1                	addw	a5,a5,a2
 410:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 414:	0006c603          	lbu	a2,0(a3)
 418:	fd06071b          	addiw	a4,a2,-48
 41c:	0ff77713          	andi	a4,a4,255
 420:	fee5f1e3          	bgeu	a1,a4,402 <atoi+0x1e>
  return n;
}
 424:	6422                	ld	s0,8(sp)
 426:	0141                	addi	sp,sp,16
 428:	8082                	ret
  n = 0;
 42a:	4501                	li	a0,0
 42c:	bfe5                	j	424 <atoi+0x40>

000000000000042e <memmove>:

// #define memcpy memmove

void*
memmove(void *vdst, const void *vsrc, int n)
{
 42e:	1141                	addi	sp,sp,-16
 430:	e422                	sd	s0,8(sp)
 432:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 434:	02b57463          	bgeu	a0,a1,45c <memmove+0x2e>
    while(n-- > 0)
 438:	00c05f63          	blez	a2,456 <memmove+0x28>
 43c:	1602                	slli	a2,a2,0x20
 43e:	9201                	srli	a2,a2,0x20
 440:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 444:	872a                	mv	a4,a0
      *dst++ = *src++;
 446:	0585                	addi	a1,a1,1
 448:	0705                	addi	a4,a4,1
 44a:	fff5c683          	lbu	a3,-1(a1)
 44e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 452:	fee79ae3          	bne	a5,a4,446 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 456:	6422                	ld	s0,8(sp)
 458:	0141                	addi	sp,sp,16
 45a:	8082                	ret
    dst += n;
 45c:	00c50733          	add	a4,a0,a2
    src += n;
 460:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 462:	fec05ae3          	blez	a2,456 <memmove+0x28>
 466:	fff6079b          	addiw	a5,a2,-1
 46a:	1782                	slli	a5,a5,0x20
 46c:	9381                	srli	a5,a5,0x20
 46e:	fff7c793          	not	a5,a5
 472:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 474:	15fd                	addi	a1,a1,-1
 476:	177d                	addi	a4,a4,-1
 478:	0005c683          	lbu	a3,0(a1)
 47c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 480:	fee79ae3          	bne	a5,a4,474 <memmove+0x46>
 484:	bfc9                	j	456 <memmove+0x28>

0000000000000486 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 486:	1141                	addi	sp,sp,-16
 488:	e422                	sd	s0,8(sp)
 48a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 48c:	ca05                	beqz	a2,4bc <memcmp+0x36>
 48e:	fff6069b          	addiw	a3,a2,-1
 492:	1682                	slli	a3,a3,0x20
 494:	9281                	srli	a3,a3,0x20
 496:	0685                	addi	a3,a3,1
 498:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 49a:	00054783          	lbu	a5,0(a0)
 49e:	0005c703          	lbu	a4,0(a1)
 4a2:	00e79863          	bne	a5,a4,4b2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4a6:	0505                	addi	a0,a0,1
    p2++;
 4a8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4aa:	fed518e3          	bne	a0,a3,49a <memcmp+0x14>
  }
  return 0;
 4ae:	4501                	li	a0,0
 4b0:	a019                	j	4b6 <memcmp+0x30>
      return *p1 - *p2;
 4b2:	40e7853b          	subw	a0,a5,a4
}
 4b6:	6422                	ld	s0,8(sp)
 4b8:	0141                	addi	sp,sp,16
 4ba:	8082                	ret
  return 0;
 4bc:	4501                	li	a0,0
 4be:	bfe5                	j	4b6 <memcmp+0x30>

00000000000004c0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4c0:	1141                	addi	sp,sp,-16
 4c2:	e406                	sd	ra,8(sp)
 4c4:	e022                	sd	s0,0(sp)
 4c6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4c8:	00000097          	auipc	ra,0x0
 4cc:	f66080e7          	jalr	-154(ra) # 42e <memmove>
}
 4d0:	60a2                	ld	ra,8(sp)
 4d2:	6402                	ld	s0,0(sp)
 4d4:	0141                	addi	sp,sp,16
 4d6:	8082                	ret

00000000000004d8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4d8:	4885                	li	a7,1
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4e0:	4889                	li	a7,2
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4e8:	488d                	li	a7,3
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4f0:	4891                	li	a7,4
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <read>:
.global read
read:
 li a7, SYS_read
 4f8:	4895                	li	a7,5
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <write>:
.global write
write:
 li a7, SYS_write
 500:	48c1                	li	a7,16
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <close>:
.global close
close:
 li a7, SYS_close
 508:	48d5                	li	a7,21
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <kill>:
.global kill
kill:
 li a7, SYS_kill
 510:	4899                	li	a7,6
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <exec>:
.global exec
exec:
 li a7, SYS_exec
 518:	489d                	li	a7,7
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <open>:
.global open
open:
 li a7, SYS_open
 520:	48bd                	li	a7,15
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 528:	48c5                	li	a7,17
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 530:	48c9                	li	a7,18
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 538:	48a1                	li	a7,8
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <link>:
.global link
link:
 li a7, SYS_link
 540:	48cd                	li	a7,19
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 548:	48d1                	li	a7,20
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 550:	48a5                	li	a7,9
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <dup>:
.global dup
dup:
 li a7, SYS_dup
 558:	48a9                	li	a7,10
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 560:	48ad                	li	a7,11
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 568:	48b1                	li	a7,12
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 570:	48b5                	li	a7,13
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 578:	48b9                	li	a7,14
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <trace>:
.global trace
trace:
 li a7, SYS_trace
 580:	48d9                	li	a7,22
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <alarm>:
.global alarm
alarm:
 li a7, SYS_alarm
 588:	48dd                	li	a7,23
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <alarmret>:
.global alarmret
alarmret:
 li a7, SYS_alarmret
 590:	48e1                	li	a7,24
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 598:	1101                	addi	sp,sp,-32
 59a:	ec06                	sd	ra,24(sp)
 59c:	e822                	sd	s0,16(sp)
 59e:	1000                	addi	s0,sp,32
 5a0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5a4:	4605                	li	a2,1
 5a6:	fef40593          	addi	a1,s0,-17
 5aa:	00000097          	auipc	ra,0x0
 5ae:	f56080e7          	jalr	-170(ra) # 500 <write>
}
 5b2:	60e2                	ld	ra,24(sp)
 5b4:	6442                	ld	s0,16(sp)
 5b6:	6105                	addi	sp,sp,32
 5b8:	8082                	ret

00000000000005ba <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5ba:	7139                	addi	sp,sp,-64
 5bc:	fc06                	sd	ra,56(sp)
 5be:	f822                	sd	s0,48(sp)
 5c0:	f426                	sd	s1,40(sp)
 5c2:	f04a                	sd	s2,32(sp)
 5c4:	ec4e                	sd	s3,24(sp)
 5c6:	0080                	addi	s0,sp,64
 5c8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5ca:	c299                	beqz	a3,5d0 <printint+0x16>
 5cc:	0805c863          	bltz	a1,65c <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5d0:	2581                	sext.w	a1,a1
  neg = 0;
 5d2:	4881                	li	a7,0
 5d4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5d8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5da:	2601                	sext.w	a2,a2
 5dc:	00000517          	auipc	a0,0x0
 5e0:	7ac50513          	addi	a0,a0,1964 # d88 <digits>
 5e4:	883a                	mv	a6,a4
 5e6:	2705                	addiw	a4,a4,1
 5e8:	02c5f7bb          	remuw	a5,a1,a2
 5ec:	1782                	slli	a5,a5,0x20
 5ee:	9381                	srli	a5,a5,0x20
 5f0:	97aa                	add	a5,a5,a0
 5f2:	0007c783          	lbu	a5,0(a5)
 5f6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5fa:	0005879b          	sext.w	a5,a1
 5fe:	02c5d5bb          	divuw	a1,a1,a2
 602:	0685                	addi	a3,a3,1
 604:	fec7f0e3          	bgeu	a5,a2,5e4 <printint+0x2a>
  if(neg)
 608:	00088b63          	beqz	a7,61e <printint+0x64>
    buf[i++] = '-';
 60c:	fd040793          	addi	a5,s0,-48
 610:	973e                	add	a4,a4,a5
 612:	02d00793          	li	a5,45
 616:	fef70823          	sb	a5,-16(a4)
 61a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 61e:	02e05863          	blez	a4,64e <printint+0x94>
 622:	fc040793          	addi	a5,s0,-64
 626:	00e78933          	add	s2,a5,a4
 62a:	fff78993          	addi	s3,a5,-1
 62e:	99ba                	add	s3,s3,a4
 630:	377d                	addiw	a4,a4,-1
 632:	1702                	slli	a4,a4,0x20
 634:	9301                	srli	a4,a4,0x20
 636:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 63a:	fff94583          	lbu	a1,-1(s2)
 63e:	8526                	mv	a0,s1
 640:	00000097          	auipc	ra,0x0
 644:	f58080e7          	jalr	-168(ra) # 598 <putc>
  while(--i >= 0)
 648:	197d                	addi	s2,s2,-1
 64a:	ff3918e3          	bne	s2,s3,63a <printint+0x80>
}
 64e:	70e2                	ld	ra,56(sp)
 650:	7442                	ld	s0,48(sp)
 652:	74a2                	ld	s1,40(sp)
 654:	7902                	ld	s2,32(sp)
 656:	69e2                	ld	s3,24(sp)
 658:	6121                	addi	sp,sp,64
 65a:	8082                	ret
    x = -xx;
 65c:	40b005bb          	negw	a1,a1
    neg = 1;
 660:	4885                	li	a7,1
    x = -xx;
 662:	bf8d                	j	5d4 <printint+0x1a>

0000000000000664 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 664:	7119                	addi	sp,sp,-128
 666:	fc86                	sd	ra,120(sp)
 668:	f8a2                	sd	s0,112(sp)
 66a:	f4a6                	sd	s1,104(sp)
 66c:	f0ca                	sd	s2,96(sp)
 66e:	ecce                	sd	s3,88(sp)
 670:	e8d2                	sd	s4,80(sp)
 672:	e4d6                	sd	s5,72(sp)
 674:	e0da                	sd	s6,64(sp)
 676:	fc5e                	sd	s7,56(sp)
 678:	f862                	sd	s8,48(sp)
 67a:	f466                	sd	s9,40(sp)
 67c:	f06a                	sd	s10,32(sp)
 67e:	ec6e                	sd	s11,24(sp)
 680:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 682:	0005c903          	lbu	s2,0(a1)
 686:	18090f63          	beqz	s2,824 <vprintf+0x1c0>
 68a:	8aaa                	mv	s5,a0
 68c:	8b32                	mv	s6,a2
 68e:	00158493          	addi	s1,a1,1
  state = 0;
 692:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 694:	02500a13          	li	s4,37
      if(c == 'd'){
 698:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 69c:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 6a0:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 6a4:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6a8:	00000b97          	auipc	s7,0x0
 6ac:	6e0b8b93          	addi	s7,s7,1760 # d88 <digits>
 6b0:	a839                	j	6ce <vprintf+0x6a>
        putc(fd, c);
 6b2:	85ca                	mv	a1,s2
 6b4:	8556                	mv	a0,s5
 6b6:	00000097          	auipc	ra,0x0
 6ba:	ee2080e7          	jalr	-286(ra) # 598 <putc>
 6be:	a019                	j	6c4 <vprintf+0x60>
    } else if(state == '%'){
 6c0:	01498f63          	beq	s3,s4,6de <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 6c4:	0485                	addi	s1,s1,1
 6c6:	fff4c903          	lbu	s2,-1(s1)
 6ca:	14090d63          	beqz	s2,824 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 6ce:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6d2:	fe0997e3          	bnez	s3,6c0 <vprintf+0x5c>
      if(c == '%'){
 6d6:	fd479ee3          	bne	a5,s4,6b2 <vprintf+0x4e>
        state = '%';
 6da:	89be                	mv	s3,a5
 6dc:	b7e5                	j	6c4 <vprintf+0x60>
      if(c == 'd'){
 6de:	05878063          	beq	a5,s8,71e <vprintf+0xba>
      } else if(c == 'l') {
 6e2:	05978c63          	beq	a5,s9,73a <vprintf+0xd6>
      } else if(c == 'x') {
 6e6:	07a78863          	beq	a5,s10,756 <vprintf+0xf2>
      } else if(c == 'p') {
 6ea:	09b78463          	beq	a5,s11,772 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 6ee:	07300713          	li	a4,115
 6f2:	0ce78663          	beq	a5,a4,7be <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6f6:	06300713          	li	a4,99
 6fa:	0ee78e63          	beq	a5,a4,7f6 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 6fe:	11478863          	beq	a5,s4,80e <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 702:	85d2                	mv	a1,s4
 704:	8556                	mv	a0,s5
 706:	00000097          	auipc	ra,0x0
 70a:	e92080e7          	jalr	-366(ra) # 598 <putc>
        putc(fd, c);
 70e:	85ca                	mv	a1,s2
 710:	8556                	mv	a0,s5
 712:	00000097          	auipc	ra,0x0
 716:	e86080e7          	jalr	-378(ra) # 598 <putc>
      }
      state = 0;
 71a:	4981                	li	s3,0
 71c:	b765                	j	6c4 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 71e:	008b0913          	addi	s2,s6,8
 722:	4685                	li	a3,1
 724:	4629                	li	a2,10
 726:	000b2583          	lw	a1,0(s6)
 72a:	8556                	mv	a0,s5
 72c:	00000097          	auipc	ra,0x0
 730:	e8e080e7          	jalr	-370(ra) # 5ba <printint>
 734:	8b4a                	mv	s6,s2
      state = 0;
 736:	4981                	li	s3,0
 738:	b771                	j	6c4 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 73a:	008b0913          	addi	s2,s6,8
 73e:	4681                	li	a3,0
 740:	4629                	li	a2,10
 742:	000b2583          	lw	a1,0(s6)
 746:	8556                	mv	a0,s5
 748:	00000097          	auipc	ra,0x0
 74c:	e72080e7          	jalr	-398(ra) # 5ba <printint>
 750:	8b4a                	mv	s6,s2
      state = 0;
 752:	4981                	li	s3,0
 754:	bf85                	j	6c4 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 756:	008b0913          	addi	s2,s6,8
 75a:	4681                	li	a3,0
 75c:	4641                	li	a2,16
 75e:	000b2583          	lw	a1,0(s6)
 762:	8556                	mv	a0,s5
 764:	00000097          	auipc	ra,0x0
 768:	e56080e7          	jalr	-426(ra) # 5ba <printint>
 76c:	8b4a                	mv	s6,s2
      state = 0;
 76e:	4981                	li	s3,0
 770:	bf91                	j	6c4 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 772:	008b0793          	addi	a5,s6,8
 776:	f8f43423          	sd	a5,-120(s0)
 77a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 77e:	03000593          	li	a1,48
 782:	8556                	mv	a0,s5
 784:	00000097          	auipc	ra,0x0
 788:	e14080e7          	jalr	-492(ra) # 598 <putc>
  putc(fd, 'x');
 78c:	85ea                	mv	a1,s10
 78e:	8556                	mv	a0,s5
 790:	00000097          	auipc	ra,0x0
 794:	e08080e7          	jalr	-504(ra) # 598 <putc>
 798:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 79a:	03c9d793          	srli	a5,s3,0x3c
 79e:	97de                	add	a5,a5,s7
 7a0:	0007c583          	lbu	a1,0(a5)
 7a4:	8556                	mv	a0,s5
 7a6:	00000097          	auipc	ra,0x0
 7aa:	df2080e7          	jalr	-526(ra) # 598 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7ae:	0992                	slli	s3,s3,0x4
 7b0:	397d                	addiw	s2,s2,-1
 7b2:	fe0914e3          	bnez	s2,79a <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 7b6:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 7ba:	4981                	li	s3,0
 7bc:	b721                	j	6c4 <vprintf+0x60>
        s = va_arg(ap, char*);
 7be:	008b0993          	addi	s3,s6,8
 7c2:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 7c6:	02090163          	beqz	s2,7e8 <vprintf+0x184>
        while(*s != 0){
 7ca:	00094583          	lbu	a1,0(s2)
 7ce:	c9a1                	beqz	a1,81e <vprintf+0x1ba>
          putc(fd, *s);
 7d0:	8556                	mv	a0,s5
 7d2:	00000097          	auipc	ra,0x0
 7d6:	dc6080e7          	jalr	-570(ra) # 598 <putc>
          s++;
 7da:	0905                	addi	s2,s2,1
        while(*s != 0){
 7dc:	00094583          	lbu	a1,0(s2)
 7e0:	f9e5                	bnez	a1,7d0 <vprintf+0x16c>
        s = va_arg(ap, char*);
 7e2:	8b4e                	mv	s6,s3
      state = 0;
 7e4:	4981                	li	s3,0
 7e6:	bdf9                	j	6c4 <vprintf+0x60>
          s = "(null)";
 7e8:	00000917          	auipc	s2,0x0
 7ec:	59890913          	addi	s2,s2,1432 # d80 <strstr+0x9c>
        while(*s != 0){
 7f0:	02800593          	li	a1,40
 7f4:	bff1                	j	7d0 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 7f6:	008b0913          	addi	s2,s6,8
 7fa:	000b4583          	lbu	a1,0(s6)
 7fe:	8556                	mv	a0,s5
 800:	00000097          	auipc	ra,0x0
 804:	d98080e7          	jalr	-616(ra) # 598 <putc>
 808:	8b4a                	mv	s6,s2
      state = 0;
 80a:	4981                	li	s3,0
 80c:	bd65                	j	6c4 <vprintf+0x60>
        putc(fd, c);
 80e:	85d2                	mv	a1,s4
 810:	8556                	mv	a0,s5
 812:	00000097          	auipc	ra,0x0
 816:	d86080e7          	jalr	-634(ra) # 598 <putc>
      state = 0;
 81a:	4981                	li	s3,0
 81c:	b565                	j	6c4 <vprintf+0x60>
        s = va_arg(ap, char*);
 81e:	8b4e                	mv	s6,s3
      state = 0;
 820:	4981                	li	s3,0
 822:	b54d                	j	6c4 <vprintf+0x60>
    }
  }
}
 824:	70e6                	ld	ra,120(sp)
 826:	7446                	ld	s0,112(sp)
 828:	74a6                	ld	s1,104(sp)
 82a:	7906                	ld	s2,96(sp)
 82c:	69e6                	ld	s3,88(sp)
 82e:	6a46                	ld	s4,80(sp)
 830:	6aa6                	ld	s5,72(sp)
 832:	6b06                	ld	s6,64(sp)
 834:	7be2                	ld	s7,56(sp)
 836:	7c42                	ld	s8,48(sp)
 838:	7ca2                	ld	s9,40(sp)
 83a:	7d02                	ld	s10,32(sp)
 83c:	6de2                	ld	s11,24(sp)
 83e:	6109                	addi	sp,sp,128
 840:	8082                	ret

0000000000000842 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 842:	715d                	addi	sp,sp,-80
 844:	ec06                	sd	ra,24(sp)
 846:	e822                	sd	s0,16(sp)
 848:	1000                	addi	s0,sp,32
 84a:	e010                	sd	a2,0(s0)
 84c:	e414                	sd	a3,8(s0)
 84e:	e818                	sd	a4,16(s0)
 850:	ec1c                	sd	a5,24(s0)
 852:	03043023          	sd	a6,32(s0)
 856:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 85a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 85e:	8622                	mv	a2,s0
 860:	00000097          	auipc	ra,0x0
 864:	e04080e7          	jalr	-508(ra) # 664 <vprintf>
}
 868:	60e2                	ld	ra,24(sp)
 86a:	6442                	ld	s0,16(sp)
 86c:	6161                	addi	sp,sp,80
 86e:	8082                	ret

0000000000000870 <printf>:

void
printf(const char *fmt, ...)
{
 870:	711d                	addi	sp,sp,-96
 872:	ec06                	sd	ra,24(sp)
 874:	e822                	sd	s0,16(sp)
 876:	1000                	addi	s0,sp,32
 878:	e40c                	sd	a1,8(s0)
 87a:	e810                	sd	a2,16(s0)
 87c:	ec14                	sd	a3,24(s0)
 87e:	f018                	sd	a4,32(s0)
 880:	f41c                	sd	a5,40(s0)
 882:	03043823          	sd	a6,48(s0)
 886:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 88a:	00840613          	addi	a2,s0,8
 88e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 892:	85aa                	mv	a1,a0
 894:	4505                	li	a0,1
 896:	00000097          	auipc	ra,0x0
 89a:	dce080e7          	jalr	-562(ra) # 664 <vprintf>
}
 89e:	60e2                	ld	ra,24(sp)
 8a0:	6442                	ld	s0,16(sp)
 8a2:	6125                	addi	sp,sp,96
 8a4:	8082                	ret

00000000000008a6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8a6:	1141                	addi	sp,sp,-16
 8a8:	e422                	sd	s0,8(sp)
 8aa:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8ac:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b0:	00000797          	auipc	a5,0x0
 8b4:	5907b783          	ld	a5,1424(a5) # e40 <freep>
 8b8:	a805                	j	8e8 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8ba:	4618                	lw	a4,8(a2)
 8bc:	9db9                	addw	a1,a1,a4
 8be:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8c2:	6398                	ld	a4,0(a5)
 8c4:	6318                	ld	a4,0(a4)
 8c6:	fee53823          	sd	a4,-16(a0)
 8ca:	a091                	j	90e <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8cc:	ff852703          	lw	a4,-8(a0)
 8d0:	9e39                	addw	a2,a2,a4
 8d2:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 8d4:	ff053703          	ld	a4,-16(a0)
 8d8:	e398                	sd	a4,0(a5)
 8da:	a099                	j	920 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8dc:	6398                	ld	a4,0(a5)
 8de:	00e7e463          	bltu	a5,a4,8e6 <free+0x40>
 8e2:	00e6ea63          	bltu	a3,a4,8f6 <free+0x50>
{
 8e6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e8:	fed7fae3          	bgeu	a5,a3,8dc <free+0x36>
 8ec:	6398                	ld	a4,0(a5)
 8ee:	00e6e463          	bltu	a3,a4,8f6 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8f2:	fee7eae3          	bltu	a5,a4,8e6 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8f6:	ff852583          	lw	a1,-8(a0)
 8fa:	6390                	ld	a2,0(a5)
 8fc:	02059713          	slli	a4,a1,0x20
 900:	9301                	srli	a4,a4,0x20
 902:	0712                	slli	a4,a4,0x4
 904:	9736                	add	a4,a4,a3
 906:	fae60ae3          	beq	a2,a4,8ba <free+0x14>
    bp->s.ptr = p->s.ptr;
 90a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 90e:	4790                	lw	a2,8(a5)
 910:	02061713          	slli	a4,a2,0x20
 914:	9301                	srli	a4,a4,0x20
 916:	0712                	slli	a4,a4,0x4
 918:	973e                	add	a4,a4,a5
 91a:	fae689e3          	beq	a3,a4,8cc <free+0x26>
  } else
    p->s.ptr = bp;
 91e:	e394                	sd	a3,0(a5)
  freep = p;
 920:	00000717          	auipc	a4,0x0
 924:	52f73023          	sd	a5,1312(a4) # e40 <freep>
}
 928:	6422                	ld	s0,8(sp)
 92a:	0141                	addi	sp,sp,16
 92c:	8082                	ret

000000000000092e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 92e:	7139                	addi	sp,sp,-64
 930:	fc06                	sd	ra,56(sp)
 932:	f822                	sd	s0,48(sp)
 934:	f426                	sd	s1,40(sp)
 936:	f04a                	sd	s2,32(sp)
 938:	ec4e                	sd	s3,24(sp)
 93a:	e852                	sd	s4,16(sp)
 93c:	e456                	sd	s5,8(sp)
 93e:	e05a                	sd	s6,0(sp)
 940:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 942:	02051493          	slli	s1,a0,0x20
 946:	9081                	srli	s1,s1,0x20
 948:	04bd                	addi	s1,s1,15
 94a:	8091                	srli	s1,s1,0x4
 94c:	0014899b          	addiw	s3,s1,1
 950:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 952:	00000517          	auipc	a0,0x0
 956:	4ee53503          	ld	a0,1262(a0) # e40 <freep>
 95a:	c515                	beqz	a0,986 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 95c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 95e:	4798                	lw	a4,8(a5)
 960:	02977f63          	bgeu	a4,s1,99e <malloc+0x70>
 964:	8a4e                	mv	s4,s3
 966:	0009871b          	sext.w	a4,s3
 96a:	6685                	lui	a3,0x1
 96c:	00d77363          	bgeu	a4,a3,972 <malloc+0x44>
 970:	6a05                	lui	s4,0x1
 972:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 976:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 97a:	00000917          	auipc	s2,0x0
 97e:	4c690913          	addi	s2,s2,1222 # e40 <freep>
  if(p == (char*)-1)
 982:	5afd                	li	s5,-1
 984:	a88d                	j	9f6 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 986:	00000797          	auipc	a5,0x0
 98a:	4d278793          	addi	a5,a5,1234 # e58 <base>
 98e:	00000717          	auipc	a4,0x0
 992:	4af73923          	sd	a5,1202(a4) # e40 <freep>
 996:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 998:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 99c:	b7e1                	j	964 <malloc+0x36>
      if(p->s.size == nunits)
 99e:	02e48b63          	beq	s1,a4,9d4 <malloc+0xa6>
        p->s.size -= nunits;
 9a2:	4137073b          	subw	a4,a4,s3
 9a6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9a8:	1702                	slli	a4,a4,0x20
 9aa:	9301                	srli	a4,a4,0x20
 9ac:	0712                	slli	a4,a4,0x4
 9ae:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9b0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9b4:	00000717          	auipc	a4,0x0
 9b8:	48a73623          	sd	a0,1164(a4) # e40 <freep>
      return (void*)(p + 1);
 9bc:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9c0:	70e2                	ld	ra,56(sp)
 9c2:	7442                	ld	s0,48(sp)
 9c4:	74a2                	ld	s1,40(sp)
 9c6:	7902                	ld	s2,32(sp)
 9c8:	69e2                	ld	s3,24(sp)
 9ca:	6a42                	ld	s4,16(sp)
 9cc:	6aa2                	ld	s5,8(sp)
 9ce:	6b02                	ld	s6,0(sp)
 9d0:	6121                	addi	sp,sp,64
 9d2:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9d4:	6398                	ld	a4,0(a5)
 9d6:	e118                	sd	a4,0(a0)
 9d8:	bff1                	j	9b4 <malloc+0x86>
  hp->s.size = nu;
 9da:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9de:	0541                	addi	a0,a0,16
 9e0:	00000097          	auipc	ra,0x0
 9e4:	ec6080e7          	jalr	-314(ra) # 8a6 <free>
  return freep;
 9e8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9ec:	d971                	beqz	a0,9c0 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ee:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9f0:	4798                	lw	a4,8(a5)
 9f2:	fa9776e3          	bgeu	a4,s1,99e <malloc+0x70>
    if(p == freep)
 9f6:	00093703          	ld	a4,0(s2)
 9fa:	853e                	mv	a0,a5
 9fc:	fef719e3          	bne	a4,a5,9ee <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 a00:	8552                	mv	a0,s4
 a02:	00000097          	auipc	ra,0x0
 a06:	b66080e7          	jalr	-1178(ra) # 568 <sbrk>
  if(p == (char*)-1)
 a0a:	fd5518e3          	bne	a0,s5,9da <malloc+0xac>
        return 0;
 a0e:	4501                	li	a0,0
 a10:	bf45                	j	9c0 <malloc+0x92>

0000000000000a12 <Pipe>:
#include "kernel/stat.h"
#include "user.h"
#include "wrapper.h"
int strncmp(const char*s, const char*pat,int n);

int Pipe(int *p) {
 a12:	1101                	addi	sp,sp,-32
 a14:	ec06                	sd	ra,24(sp)
 a16:	e822                	sd	s0,16(sp)
 a18:	e426                	sd	s1,8(sp)
 a1a:	1000                	addi	s0,sp,32
  i32 res = pipe(p);
 a1c:	00000097          	auipc	ra,0x0
 a20:	ad4080e7          	jalr	-1324(ra) # 4f0 <pipe>
 a24:	84aa                	mv	s1,a0
  if (res < 0) {
 a26:	00054863          	bltz	a0,a36 <Pipe+0x24>
    fprintf(2, "pipe creation error");
  }
  return res;
}
 a2a:	8526                	mv	a0,s1
 a2c:	60e2                	ld	ra,24(sp)
 a2e:	6442                	ld	s0,16(sp)
 a30:	64a2                	ld	s1,8(sp)
 a32:	6105                	addi	sp,sp,32
 a34:	8082                	ret
    fprintf(2, "pipe creation error");
 a36:	00000597          	auipc	a1,0x0
 a3a:	36a58593          	addi	a1,a1,874 # da0 <digits+0x18>
 a3e:	4509                	li	a0,2
 a40:	00000097          	auipc	ra,0x0
 a44:	e02080e7          	jalr	-510(ra) # 842 <fprintf>
 a48:	b7cd                	j	a2a <Pipe+0x18>

0000000000000a4a <Write>:

int Write(int fd, void *buf, int count){
 a4a:	1141                	addi	sp,sp,-16
 a4c:	e406                	sd	ra,8(sp)
 a4e:	e022                	sd	s0,0(sp)
 a50:	0800                	addi	s0,sp,16
  i32 res = write(fd, buf, count);
 a52:	00000097          	auipc	ra,0x0
 a56:	aae080e7          	jalr	-1362(ra) # 500 <write>
  if (res < 0) {
 a5a:	00054663          	bltz	a0,a66 <Write+0x1c>
    fprintf(2, "write error");
    exit(0);
  }
  return res;
}
 a5e:	60a2                	ld	ra,8(sp)
 a60:	6402                	ld	s0,0(sp)
 a62:	0141                	addi	sp,sp,16
 a64:	8082                	ret
    fprintf(2, "write error");
 a66:	00000597          	auipc	a1,0x0
 a6a:	35258593          	addi	a1,a1,850 # db8 <digits+0x30>
 a6e:	4509                	li	a0,2
 a70:	00000097          	auipc	ra,0x0
 a74:	dd2080e7          	jalr	-558(ra) # 842 <fprintf>
    exit(0);
 a78:	4501                	li	a0,0
 a7a:	00000097          	auipc	ra,0x0
 a7e:	a66080e7          	jalr	-1434(ra) # 4e0 <exit>

0000000000000a82 <Read>:



int Read(int fd,  void*buf, int count){
 a82:	1141                	addi	sp,sp,-16
 a84:	e406                	sd	ra,8(sp)
 a86:	e022                	sd	s0,0(sp)
 a88:	0800                	addi	s0,sp,16
  i32 res = read(fd, buf, count);
 a8a:	00000097          	auipc	ra,0x0
 a8e:	a6e080e7          	jalr	-1426(ra) # 4f8 <read>
  if (res < 0) {
 a92:	00054663          	bltz	a0,a9e <Read+0x1c>
    fprintf(2, "read error");
    exit(0);
  }
  return res;
}
 a96:	60a2                	ld	ra,8(sp)
 a98:	6402                	ld	s0,0(sp)
 a9a:	0141                	addi	sp,sp,16
 a9c:	8082                	ret
    fprintf(2, "read error");
 a9e:	00000597          	auipc	a1,0x0
 aa2:	32a58593          	addi	a1,a1,810 # dc8 <digits+0x40>
 aa6:	4509                	li	a0,2
 aa8:	00000097          	auipc	ra,0x0
 aac:	d9a080e7          	jalr	-614(ra) # 842 <fprintf>
    exit(0);
 ab0:	4501                	li	a0,0
 ab2:	00000097          	auipc	ra,0x0
 ab6:	a2e080e7          	jalr	-1490(ra) # 4e0 <exit>

0000000000000aba <Open>:


int Open(const char* path, int flag){
 aba:	1141                	addi	sp,sp,-16
 abc:	e406                	sd	ra,8(sp)
 abe:	e022                	sd	s0,0(sp)
 ac0:	0800                	addi	s0,sp,16
  i32 res = open(path, flag);
 ac2:	00000097          	auipc	ra,0x0
 ac6:	a5e080e7          	jalr	-1442(ra) # 520 <open>
  if (res < 0) {
 aca:	00054663          	bltz	a0,ad6 <Open+0x1c>
    fprintf(2, "open error");
    exit(0);
  }
  return res;
}
 ace:	60a2                	ld	ra,8(sp)
 ad0:	6402                	ld	s0,0(sp)
 ad2:	0141                	addi	sp,sp,16
 ad4:	8082                	ret
    fprintf(2, "open error");
 ad6:	00000597          	auipc	a1,0x0
 ada:	30258593          	addi	a1,a1,770 # dd8 <digits+0x50>
 ade:	4509                	li	a0,2
 ae0:	00000097          	auipc	ra,0x0
 ae4:	d62080e7          	jalr	-670(ra) # 842 <fprintf>
    exit(0);
 ae8:	4501                	li	a0,0
 aea:	00000097          	auipc	ra,0x0
 aee:	9f6080e7          	jalr	-1546(ra) # 4e0 <exit>

0000000000000af2 <Fstat>:


int Fstat(int fd, stat_t *st){
 af2:	1141                	addi	sp,sp,-16
 af4:	e406                	sd	ra,8(sp)
 af6:	e022                	sd	s0,0(sp)
 af8:	0800                	addi	s0,sp,16
  i32 res = fstat(fd, st);
 afa:	00000097          	auipc	ra,0x0
 afe:	a3e080e7          	jalr	-1474(ra) # 538 <fstat>
  if (res < 0) {
 b02:	00054663          	bltz	a0,b0e <Fstat+0x1c>
    fprintf(2, "get file stat error");
    exit(0);
  }
  return res;
}
 b06:	60a2                	ld	ra,8(sp)
 b08:	6402                	ld	s0,0(sp)
 b0a:	0141                	addi	sp,sp,16
 b0c:	8082                	ret
    fprintf(2, "get file stat error");
 b0e:	00000597          	auipc	a1,0x0
 b12:	2da58593          	addi	a1,a1,730 # de8 <digits+0x60>
 b16:	4509                	li	a0,2
 b18:	00000097          	auipc	ra,0x0
 b1c:	d2a080e7          	jalr	-726(ra) # 842 <fprintf>
    exit(0);
 b20:	4501                	li	a0,0
 b22:	00000097          	auipc	ra,0x0
 b26:	9be080e7          	jalr	-1602(ra) # 4e0 <exit>

0000000000000b2a <Dup>:



int Dup(int fd){
 b2a:	1141                	addi	sp,sp,-16
 b2c:	e406                	sd	ra,8(sp)
 b2e:	e022                	sd	s0,0(sp)
 b30:	0800                	addi	s0,sp,16
  i32 res = dup(fd);
 b32:	00000097          	auipc	ra,0x0
 b36:	a26080e7          	jalr	-1498(ra) # 558 <dup>
  if (res < 0) {
 b3a:	00054663          	bltz	a0,b46 <Dup+0x1c>
    fprintf(2, "dup error");
    exit(0);
  }
  return res;

}
 b3e:	60a2                	ld	ra,8(sp)
 b40:	6402                	ld	s0,0(sp)
 b42:	0141                	addi	sp,sp,16
 b44:	8082                	ret
    fprintf(2, "dup error");
 b46:	00000597          	auipc	a1,0x0
 b4a:	2ba58593          	addi	a1,a1,698 # e00 <digits+0x78>
 b4e:	4509                	li	a0,2
 b50:	00000097          	auipc	ra,0x0
 b54:	cf2080e7          	jalr	-782(ra) # 842 <fprintf>
    exit(0);
 b58:	4501                	li	a0,0
 b5a:	00000097          	auipc	ra,0x0
 b5e:	986080e7          	jalr	-1658(ra) # 4e0 <exit>

0000000000000b62 <Close>:

int Close(int fd){
 b62:	1141                	addi	sp,sp,-16
 b64:	e406                	sd	ra,8(sp)
 b66:	e022                	sd	s0,0(sp)
 b68:	0800                	addi	s0,sp,16
  i32 res = close(fd);
 b6a:	00000097          	auipc	ra,0x0
 b6e:	99e080e7          	jalr	-1634(ra) # 508 <close>
  if (res < 0) {
 b72:	00054663          	bltz	a0,b7e <Close+0x1c>
    fprintf(2, "file close error~");
    exit(0);
  }
  return res;
}
 b76:	60a2                	ld	ra,8(sp)
 b78:	6402                	ld	s0,0(sp)
 b7a:	0141                	addi	sp,sp,16
 b7c:	8082                	ret
    fprintf(2, "file close error~");
 b7e:	00000597          	auipc	a1,0x0
 b82:	29258593          	addi	a1,a1,658 # e10 <digits+0x88>
 b86:	4509                	li	a0,2
 b88:	00000097          	auipc	ra,0x0
 b8c:	cba080e7          	jalr	-838(ra) # 842 <fprintf>
    exit(0);
 b90:	4501                	li	a0,0
 b92:	00000097          	auipc	ra,0x0
 b96:	94e080e7          	jalr	-1714(ra) # 4e0 <exit>

0000000000000b9a <Dup2>:

int Dup2(int old_fd,int new_fd){
 b9a:	1101                	addi	sp,sp,-32
 b9c:	ec06                	sd	ra,24(sp)
 b9e:	e822                	sd	s0,16(sp)
 ba0:	e426                	sd	s1,8(sp)
 ba2:	1000                	addi	s0,sp,32
 ba4:	84aa                	mv	s1,a0
  Close(new_fd);
 ba6:	852e                	mv	a0,a1
 ba8:	00000097          	auipc	ra,0x0
 bac:	fba080e7          	jalr	-70(ra) # b62 <Close>
  i32 res = Dup(old_fd);
 bb0:	8526                	mv	a0,s1
 bb2:	00000097          	auipc	ra,0x0
 bb6:	f78080e7          	jalr	-136(ra) # b2a <Dup>
  if (res < 0) {
 bba:	00054763          	bltz	a0,bc8 <Dup2+0x2e>
    fprintf(2, "dup error");
    exit(0);
  }
  return res;
}
 bbe:	60e2                	ld	ra,24(sp)
 bc0:	6442                	ld	s0,16(sp)
 bc2:	64a2                	ld	s1,8(sp)
 bc4:	6105                	addi	sp,sp,32
 bc6:	8082                	ret
    fprintf(2, "dup error");
 bc8:	00000597          	auipc	a1,0x0
 bcc:	23858593          	addi	a1,a1,568 # e00 <digits+0x78>
 bd0:	4509                	li	a0,2
 bd2:	00000097          	auipc	ra,0x0
 bd6:	c70080e7          	jalr	-912(ra) # 842 <fprintf>
    exit(0);
 bda:	4501                	li	a0,0
 bdc:	00000097          	auipc	ra,0x0
 be0:	904080e7          	jalr	-1788(ra) # 4e0 <exit>

0000000000000be4 <Stat>:

int Stat(const char*link,stat_t *st){
 be4:	1101                	addi	sp,sp,-32
 be6:	ec06                	sd	ra,24(sp)
 be8:	e822                	sd	s0,16(sp)
 bea:	e426                	sd	s1,8(sp)
 bec:	1000                	addi	s0,sp,32
 bee:	84aa                	mv	s1,a0
  i32 res = stat(link,st);
 bf0:	fffff097          	auipc	ra,0xfffff
 bf4:	7ae080e7          	jalr	1966(ra) # 39e <stat>
  if (res < 0) {
 bf8:	00054763          	bltz	a0,c06 <Stat+0x22>
    fprintf(2, "file %s stat error",link);
    exit(0);
  }
  return res;
}
 bfc:	60e2                	ld	ra,24(sp)
 bfe:	6442                	ld	s0,16(sp)
 c00:	64a2                	ld	s1,8(sp)
 c02:	6105                	addi	sp,sp,32
 c04:	8082                	ret
    fprintf(2, "file %s stat error",link);
 c06:	8626                	mv	a2,s1
 c08:	00000597          	auipc	a1,0x0
 c0c:	22058593          	addi	a1,a1,544 # e28 <digits+0xa0>
 c10:	4509                	li	a0,2
 c12:	00000097          	auipc	ra,0x0
 c16:	c30080e7          	jalr	-976(ra) # 842 <fprintf>
    exit(0);
 c1a:	4501                	li	a0,0
 c1c:	00000097          	auipc	ra,0x0
 c20:	8c4080e7          	jalr	-1852(ra) # 4e0 <exit>

0000000000000c24 <strncmp>:
   return -1;
}



int strncmp(const char*s, const char*pat,int n){
 c24:	bc010113          	addi	sp,sp,-1088
 c28:	42113c23          	sd	ra,1080(sp)
 c2c:	42813823          	sd	s0,1072(sp)
 c30:	42913423          	sd	s1,1064(sp)
 c34:	43213023          	sd	s2,1056(sp)
 c38:	41313c23          	sd	s3,1048(sp)
 c3c:	41413823          	sd	s4,1040(sp)
 c40:	41513423          	sd	s5,1032(sp)
 c44:	44010413          	addi	s0,sp,1088
 c48:	89aa                	mv	s3,a0
 c4a:	892e                	mv	s2,a1
 c4c:	84b2                	mv	s1,a2
  char buf1[512],buf2[512];
  int n1 = MIN(n,strlen(s));
 c4e:	fffff097          	auipc	ra,0xfffff
 c52:	66c080e7          	jalr	1644(ra) # 2ba <strlen>
 c56:	2501                	sext.w	a0,a0
 c58:	00048a1b          	sext.w	s4,s1
 c5c:	8aa6                	mv	s5,s1
 c5e:	06aa7363          	bgeu	s4,a0,cc4 <strncmp+0xa0>
  int n2 = MIN(n,strlen(pat));
 c62:	854a                	mv	a0,s2
 c64:	fffff097          	auipc	ra,0xfffff
 c68:	656080e7          	jalr	1622(ra) # 2ba <strlen>
 c6c:	2501                	sext.w	a0,a0
 c6e:	06aa7363          	bgeu	s4,a0,cd4 <strncmp+0xb0>
  memmove(buf1,s,n1);
 c72:	8656                	mv	a2,s5
 c74:	85ce                	mv	a1,s3
 c76:	dc040513          	addi	a0,s0,-576
 c7a:	fffff097          	auipc	ra,0xfffff
 c7e:	7b4080e7          	jalr	1972(ra) # 42e <memmove>
  memmove(buf2,pat,n2);
 c82:	8626                	mv	a2,s1
 c84:	85ca                	mv	a1,s2
 c86:	bc040513          	addi	a0,s0,-1088
 c8a:	fffff097          	auipc	ra,0xfffff
 c8e:	7a4080e7          	jalr	1956(ra) # 42e <memmove>
  return strcmp(buf1,buf2);
 c92:	bc040593          	addi	a1,s0,-1088
 c96:	dc040513          	addi	a0,s0,-576
 c9a:	fffff097          	auipc	ra,0xfffff
 c9e:	5f4080e7          	jalr	1524(ra) # 28e <strcmp>
}
 ca2:	43813083          	ld	ra,1080(sp)
 ca6:	43013403          	ld	s0,1072(sp)
 caa:	42813483          	ld	s1,1064(sp)
 cae:	42013903          	ld	s2,1056(sp)
 cb2:	41813983          	ld	s3,1048(sp)
 cb6:	41013a03          	ld	s4,1040(sp)
 cba:	40813a83          	ld	s5,1032(sp)
 cbe:	44010113          	addi	sp,sp,1088
 cc2:	8082                	ret
  int n1 = MIN(n,strlen(s));
 cc4:	854e                	mv	a0,s3
 cc6:	fffff097          	auipc	ra,0xfffff
 cca:	5f4080e7          	jalr	1524(ra) # 2ba <strlen>
 cce:	00050a9b          	sext.w	s5,a0
 cd2:	bf41                	j	c62 <strncmp+0x3e>
  int n2 = MIN(n,strlen(pat));
 cd4:	854a                	mv	a0,s2
 cd6:	fffff097          	auipc	ra,0xfffff
 cda:	5e4080e7          	jalr	1508(ra) # 2ba <strlen>
 cde:	0005049b          	sext.w	s1,a0
 ce2:	bf41                	j	c72 <strncmp+0x4e>

0000000000000ce4 <strstr>:
   while (*s != 0){
 ce4:	00054783          	lbu	a5,0(a0)
 ce8:	cba1                	beqz	a5,d38 <strstr+0x54>
int strstr(char *s,char *p){
 cea:	7179                	addi	sp,sp,-48
 cec:	f406                	sd	ra,40(sp)
 cee:	f022                	sd	s0,32(sp)
 cf0:	ec26                	sd	s1,24(sp)
 cf2:	e84a                	sd	s2,16(sp)
 cf4:	e44e                	sd	s3,8(sp)
 cf6:	1800                	addi	s0,sp,48
 cf8:	89aa                	mv	s3,a0
 cfa:	892e                	mv	s2,a1
   while (*s != 0){
 cfc:	84aa                	mv	s1,a0
     if (!strncmp(s,p,strlen(p)))
 cfe:	854a                	mv	a0,s2
 d00:	fffff097          	auipc	ra,0xfffff
 d04:	5ba080e7          	jalr	1466(ra) # 2ba <strlen>
 d08:	0005061b          	sext.w	a2,a0
 d0c:	85ca                	mv	a1,s2
 d0e:	8526                	mv	a0,s1
 d10:	00000097          	auipc	ra,0x0
 d14:	f14080e7          	jalr	-236(ra) # c24 <strncmp>
 d18:	c519                	beqz	a0,d26 <strstr+0x42>
     s++;
 d1a:	0485                	addi	s1,s1,1
   while (*s != 0){
 d1c:	0004c783          	lbu	a5,0(s1)
 d20:	fff9                	bnez	a5,cfe <strstr+0x1a>
   return -1;
 d22:	557d                	li	a0,-1
 d24:	a019                	j	d2a <strstr+0x46>
      return s - ori;
 d26:	4134853b          	subw	a0,s1,s3
}
 d2a:	70a2                	ld	ra,40(sp)
 d2c:	7402                	ld	s0,32(sp)
 d2e:	64e2                	ld	s1,24(sp)
 d30:	6942                	ld	s2,16(sp)
 d32:	69a2                	ld	s3,8(sp)
 d34:	6145                	addi	sp,sp,48
 d36:	8082                	ret
   return -1;
 d38:	557d                	li	a0,-1
}
 d3a:	8082                	ret
