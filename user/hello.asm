
user/_hello:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <sayhi>:
#include "user.h"
void sayyou();

void sayhi() {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  printf("hi~\n");
   8:	00001517          	auipc	a0,0x1
   c:	b8850513          	addi	a0,a0,-1144 # b90 <strstr+0x5a>
  10:	00000097          	auipc	ra,0x0
  14:	6b2080e7          	jalr	1714(ra) # 6c2 <printf>
  // alarm(10, sayyou);
  alarmret();
  18:	00000097          	auipc	ra,0x0
  1c:	3ca080e7          	jalr	970(ra) # 3e2 <alarmret>
}
  20:	60a2                	ld	ra,8(sp)
  22:	6402                	ld	s0,0(sp)
  24:	0141                	addi	sp,sp,16
  26:	8082                	ret

0000000000000028 <sayyou>:

void sayyou() {
  28:	1141                	addi	sp,sp,-16
  2a:	e406                	sd	ra,8(sp)
  2c:	e022                	sd	s0,0(sp)
  2e:	0800                	addi	s0,sp,16
  printf("you~\n");
  30:	00001517          	auipc	a0,0x1
  34:	b6850513          	addi	a0,a0,-1176 # b98 <strstr+0x62>
  38:	00000097          	auipc	ra,0x0
  3c:	68a080e7          	jalr	1674(ra) # 6c2 <printf>
  // alarm(10, sayhi);
  alarmret();
  40:	00000097          	auipc	ra,0x0
  44:	3a2080e7          	jalr	930(ra) # 3e2 <alarmret>
}
  48:	60a2                	ld	ra,8(sp)
  4a:	6402                	ld	s0,0(sp)
  4c:	0141                	addi	sp,sp,16
  4e:	8082                	ret

0000000000000050 <main>:

int main(int argc, char **argv) {
  50:	1101                	addi	sp,sp,-32
  52:	ec06                	sd	ra,24(sp)
  54:	e822                	sd	s0,16(sp)
  56:	e426                	sd	s1,8(sp)
  58:	1000                	addi	s0,sp,32
  char *s = sbrk(0);
  5a:	4501                	li	a0,0
  5c:	00000097          	auipc	ra,0x0
  60:	35e080e7          	jalr	862(ra) # 3ba <sbrk>
  char ch;
  alarm(10, sayyou);
  64:	00000597          	auipc	a1,0x0
  68:	fc458593          	addi	a1,a1,-60 # 28 <sayyou>
  6c:	4529                	li	a0,10
  6e:	00000097          	auipc	ra,0x0
  72:	36c080e7          	jalr	876(ra) # 3da <alarm>
  printf("address of hi %p\n", sayhi);
  76:	00000597          	auipc	a1,0x0
  7a:	f8a58593          	addi	a1,a1,-118 # 0 <sayhi>
  7e:	00001517          	auipc	a0,0x1
  82:	b2250513          	addi	a0,a0,-1246 # ba0 <strstr+0x6a>
  86:	00000097          	auipc	ra,0x0
  8a:	63c080e7          	jalr	1596(ra) # 6c2 <printf>
  printf("address of you %p\n", sayyou);
  8e:	00000597          	auipc	a1,0x0
  92:	f9a58593          	addi	a1,a1,-102 # 28 <sayyou>
  96:	00001517          	auipc	a0,0x1
  9a:	b2250513          	addi	a0,a0,-1246 # bb8 <strstr+0x82>
  9e:	00000097          	auipc	ra,0x0
  a2:	624080e7          	jalr	1572(ra) # 6c2 <printf>
  while (1) {
    for (u64 i = 0; i <= 0xfffffff; i++)
      ch = 9;
    printf("I am in user mode~\n");
  a6:	00001497          	auipc	s1,0x1
  aa:	b2a48493          	addi	s1,s1,-1238 # bd0 <strstr+0x9a>
  ae:	a031                	j	ba <main+0x6a>
  b0:	8526                	mv	a0,s1
  b2:	00000097          	auipc	ra,0x0
  b6:	610080e7          	jalr	1552(ra) # 6c2 <printf>
int main(int argc, char **argv) {
  ba:	100007b7          	lui	a5,0x10000
    for (u64 i = 0; i <= 0xfffffff; i++)
  be:	17fd                	addi	a5,a5,-1
  c0:	fffd                	bnez	a5,be <main+0x6e>
  c2:	b7fd                	j	b0 <main+0x60>

00000000000000c4 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  c4:	1141                	addi	sp,sp,-16
  c6:	e422                	sd	s0,8(sp)
  c8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ca:	87aa                	mv	a5,a0
  cc:	0585                	addi	a1,a1,1
  ce:	0785                	addi	a5,a5,1
  d0:	fff5c703          	lbu	a4,-1(a1)
  d4:	fee78fa3          	sb	a4,-1(a5) # fffffff <__global_pointer$+0xfffeb5c>
  d8:	fb75                	bnez	a4,cc <strcpy+0x8>
    ;
  return os;
}
  da:	6422                	ld	s0,8(sp)
  dc:	0141                	addi	sp,sp,16
  de:	8082                	ret

00000000000000e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e0:	1141                	addi	sp,sp,-16
  e2:	e422                	sd	s0,8(sp)
  e4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  e6:	00054783          	lbu	a5,0(a0)
  ea:	cb91                	beqz	a5,fe <strcmp+0x1e>
  ec:	0005c703          	lbu	a4,0(a1)
  f0:	00f71763          	bne	a4,a5,fe <strcmp+0x1e>
    p++, q++;
  f4:	0505                	addi	a0,a0,1
  f6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  f8:	00054783          	lbu	a5,0(a0)
  fc:	fbe5                	bnez	a5,ec <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  fe:	0005c503          	lbu	a0,0(a1)
}
 102:	40a7853b          	subw	a0,a5,a0
 106:	6422                	ld	s0,8(sp)
 108:	0141                	addi	sp,sp,16
 10a:	8082                	ret

000000000000010c <strlen>:

uint
strlen(const char *s)
{
 10c:	1141                	addi	sp,sp,-16
 10e:	e422                	sd	s0,8(sp)
 110:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 112:	00054783          	lbu	a5,0(a0)
 116:	cf91                	beqz	a5,132 <strlen+0x26>
 118:	0505                	addi	a0,a0,1
 11a:	87aa                	mv	a5,a0
 11c:	4685                	li	a3,1
 11e:	9e89                	subw	a3,a3,a0
 120:	00f6853b          	addw	a0,a3,a5
 124:	0785                	addi	a5,a5,1
 126:	fff7c703          	lbu	a4,-1(a5)
 12a:	fb7d                	bnez	a4,120 <strlen+0x14>
    ;
  return n;
}
 12c:	6422                	ld	s0,8(sp)
 12e:	0141                	addi	sp,sp,16
 130:	8082                	ret
  for(n = 0; s[n]; n++)
 132:	4501                	li	a0,0
 134:	bfe5                	j	12c <strlen+0x20>

0000000000000136 <memset>:

void*
memset(void *dst, int c, uint n)
{
 136:	1141                	addi	sp,sp,-16
 138:	e422                	sd	s0,8(sp)
 13a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 13c:	ca19                	beqz	a2,152 <memset+0x1c>
 13e:	87aa                	mv	a5,a0
 140:	1602                	slli	a2,a2,0x20
 142:	9201                	srli	a2,a2,0x20
 144:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 148:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 14c:	0785                	addi	a5,a5,1
 14e:	fee79de3          	bne	a5,a4,148 <memset+0x12>
  }
  return dst;
}
 152:	6422                	ld	s0,8(sp)
 154:	0141                	addi	sp,sp,16
 156:	8082                	ret

0000000000000158 <strchr>:

char*
strchr(const char *s, char c)
{
 158:	1141                	addi	sp,sp,-16
 15a:	e422                	sd	s0,8(sp)
 15c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 15e:	00054783          	lbu	a5,0(a0)
 162:	cb99                	beqz	a5,178 <strchr+0x20>
    if(*s == c)
 164:	00f58763          	beq	a1,a5,172 <strchr+0x1a>
  for(; *s; s++)
 168:	0505                	addi	a0,a0,1
 16a:	00054783          	lbu	a5,0(a0)
 16e:	fbfd                	bnez	a5,164 <strchr+0xc>
      return (char*)s;
  return 0;
 170:	4501                	li	a0,0
}
 172:	6422                	ld	s0,8(sp)
 174:	0141                	addi	sp,sp,16
 176:	8082                	ret
  return 0;
 178:	4501                	li	a0,0
 17a:	bfe5                	j	172 <strchr+0x1a>

000000000000017c <gets>:

char*
gets(char *buf, int max)
{
 17c:	711d                	addi	sp,sp,-96
 17e:	ec86                	sd	ra,88(sp)
 180:	e8a2                	sd	s0,80(sp)
 182:	e4a6                	sd	s1,72(sp)
 184:	e0ca                	sd	s2,64(sp)
 186:	fc4e                	sd	s3,56(sp)
 188:	f852                	sd	s4,48(sp)
 18a:	f456                	sd	s5,40(sp)
 18c:	f05a                	sd	s6,32(sp)
 18e:	ec5e                	sd	s7,24(sp)
 190:	1080                	addi	s0,sp,96
 192:	8baa                	mv	s7,a0
 194:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 196:	892a                	mv	s2,a0
 198:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 19a:	4aa9                	li	s5,10
 19c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 19e:	89a6                	mv	s3,s1
 1a0:	2485                	addiw	s1,s1,1
 1a2:	0344d863          	bge	s1,s4,1d2 <gets+0x56>
    cc = read(0, &c, 1);
 1a6:	4605                	li	a2,1
 1a8:	faf40593          	addi	a1,s0,-81
 1ac:	4501                	li	a0,0
 1ae:	00000097          	auipc	ra,0x0
 1b2:	19c080e7          	jalr	412(ra) # 34a <read>
    if(cc < 1)
 1b6:	00a05e63          	blez	a0,1d2 <gets+0x56>
    buf[i++] = c;
 1ba:	faf44783          	lbu	a5,-81(s0)
 1be:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1c2:	01578763          	beq	a5,s5,1d0 <gets+0x54>
 1c6:	0905                	addi	s2,s2,1
 1c8:	fd679be3          	bne	a5,s6,19e <gets+0x22>
  for(i=0; i+1 < max; ){
 1cc:	89a6                	mv	s3,s1
 1ce:	a011                	j	1d2 <gets+0x56>
 1d0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1d2:	99de                	add	s3,s3,s7
 1d4:	00098023          	sb	zero,0(s3)
  return buf;
}
 1d8:	855e                	mv	a0,s7
 1da:	60e6                	ld	ra,88(sp)
 1dc:	6446                	ld	s0,80(sp)
 1de:	64a6                	ld	s1,72(sp)
 1e0:	6906                	ld	s2,64(sp)
 1e2:	79e2                	ld	s3,56(sp)
 1e4:	7a42                	ld	s4,48(sp)
 1e6:	7aa2                	ld	s5,40(sp)
 1e8:	7b02                	ld	s6,32(sp)
 1ea:	6be2                	ld	s7,24(sp)
 1ec:	6125                	addi	sp,sp,96
 1ee:	8082                	ret

00000000000001f0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1f0:	1101                	addi	sp,sp,-32
 1f2:	ec06                	sd	ra,24(sp)
 1f4:	e822                	sd	s0,16(sp)
 1f6:	e426                	sd	s1,8(sp)
 1f8:	e04a                	sd	s2,0(sp)
 1fa:	1000                	addi	s0,sp,32
 1fc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1fe:	4581                	li	a1,0
 200:	00000097          	auipc	ra,0x0
 204:	172080e7          	jalr	370(ra) # 372 <open>
  if(fd < 0)
 208:	02054563          	bltz	a0,232 <stat+0x42>
 20c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 20e:	85ca                	mv	a1,s2
 210:	00000097          	auipc	ra,0x0
 214:	17a080e7          	jalr	378(ra) # 38a <fstat>
 218:	892a                	mv	s2,a0
  close(fd);
 21a:	8526                	mv	a0,s1
 21c:	00000097          	auipc	ra,0x0
 220:	13e080e7          	jalr	318(ra) # 35a <close>
  return r;
}
 224:	854a                	mv	a0,s2
 226:	60e2                	ld	ra,24(sp)
 228:	6442                	ld	s0,16(sp)
 22a:	64a2                	ld	s1,8(sp)
 22c:	6902                	ld	s2,0(sp)
 22e:	6105                	addi	sp,sp,32
 230:	8082                	ret
    return -1;
 232:	597d                	li	s2,-1
 234:	bfc5                	j	224 <stat+0x34>

0000000000000236 <atoi>:

int
atoi(const char *s)
{
 236:	1141                	addi	sp,sp,-16
 238:	e422                	sd	s0,8(sp)
 23a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 23c:	00054603          	lbu	a2,0(a0)
 240:	fd06079b          	addiw	a5,a2,-48
 244:	0ff7f793          	andi	a5,a5,255
 248:	4725                	li	a4,9
 24a:	02f76963          	bltu	a4,a5,27c <atoi+0x46>
 24e:	86aa                	mv	a3,a0
  n = 0;
 250:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 252:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 254:	0685                	addi	a3,a3,1
 256:	0025179b          	slliw	a5,a0,0x2
 25a:	9fa9                	addw	a5,a5,a0
 25c:	0017979b          	slliw	a5,a5,0x1
 260:	9fb1                	addw	a5,a5,a2
 262:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 266:	0006c603          	lbu	a2,0(a3)
 26a:	fd06071b          	addiw	a4,a2,-48
 26e:	0ff77713          	andi	a4,a4,255
 272:	fee5f1e3          	bgeu	a1,a4,254 <atoi+0x1e>
  return n;
}
 276:	6422                	ld	s0,8(sp)
 278:	0141                	addi	sp,sp,16
 27a:	8082                	ret
  n = 0;
 27c:	4501                	li	a0,0
 27e:	bfe5                	j	276 <atoi+0x40>

0000000000000280 <memmove>:

// #define memcpy memmove

void*
memmove(void *vdst, const void *vsrc, int n)
{
 280:	1141                	addi	sp,sp,-16
 282:	e422                	sd	s0,8(sp)
 284:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 286:	02b57463          	bgeu	a0,a1,2ae <memmove+0x2e>
    while(n-- > 0)
 28a:	00c05f63          	blez	a2,2a8 <memmove+0x28>
 28e:	1602                	slli	a2,a2,0x20
 290:	9201                	srli	a2,a2,0x20
 292:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 296:	872a                	mv	a4,a0
      *dst++ = *src++;
 298:	0585                	addi	a1,a1,1
 29a:	0705                	addi	a4,a4,1
 29c:	fff5c683          	lbu	a3,-1(a1)
 2a0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2a4:	fee79ae3          	bne	a5,a4,298 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2a8:	6422                	ld	s0,8(sp)
 2aa:	0141                	addi	sp,sp,16
 2ac:	8082                	ret
    dst += n;
 2ae:	00c50733          	add	a4,a0,a2
    src += n;
 2b2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2b4:	fec05ae3          	blez	a2,2a8 <memmove+0x28>
 2b8:	fff6079b          	addiw	a5,a2,-1
 2bc:	1782                	slli	a5,a5,0x20
 2be:	9381                	srli	a5,a5,0x20
 2c0:	fff7c793          	not	a5,a5
 2c4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2c6:	15fd                	addi	a1,a1,-1
 2c8:	177d                	addi	a4,a4,-1
 2ca:	0005c683          	lbu	a3,0(a1)
 2ce:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2d2:	fee79ae3          	bne	a5,a4,2c6 <memmove+0x46>
 2d6:	bfc9                	j	2a8 <memmove+0x28>

00000000000002d8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2d8:	1141                	addi	sp,sp,-16
 2da:	e422                	sd	s0,8(sp)
 2dc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2de:	ca05                	beqz	a2,30e <memcmp+0x36>
 2e0:	fff6069b          	addiw	a3,a2,-1
 2e4:	1682                	slli	a3,a3,0x20
 2e6:	9281                	srli	a3,a3,0x20
 2e8:	0685                	addi	a3,a3,1
 2ea:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2ec:	00054783          	lbu	a5,0(a0)
 2f0:	0005c703          	lbu	a4,0(a1)
 2f4:	00e79863          	bne	a5,a4,304 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2f8:	0505                	addi	a0,a0,1
    p2++;
 2fa:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2fc:	fed518e3          	bne	a0,a3,2ec <memcmp+0x14>
  }
  return 0;
 300:	4501                	li	a0,0
 302:	a019                	j	308 <memcmp+0x30>
      return *p1 - *p2;
 304:	40e7853b          	subw	a0,a5,a4
}
 308:	6422                	ld	s0,8(sp)
 30a:	0141                	addi	sp,sp,16
 30c:	8082                	ret
  return 0;
 30e:	4501                	li	a0,0
 310:	bfe5                	j	308 <memcmp+0x30>

0000000000000312 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 312:	1141                	addi	sp,sp,-16
 314:	e406                	sd	ra,8(sp)
 316:	e022                	sd	s0,0(sp)
 318:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 31a:	00000097          	auipc	ra,0x0
 31e:	f66080e7          	jalr	-154(ra) # 280 <memmove>
}
 322:	60a2                	ld	ra,8(sp)
 324:	6402                	ld	s0,0(sp)
 326:	0141                	addi	sp,sp,16
 328:	8082                	ret

000000000000032a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 32a:	4885                	li	a7,1
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <exit>:
.global exit
exit:
 li a7, SYS_exit
 332:	4889                	li	a7,2
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <wait>:
.global wait
wait:
 li a7, SYS_wait
 33a:	488d                	li	a7,3
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 342:	4891                	li	a7,4
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <read>:
.global read
read:
 li a7, SYS_read
 34a:	4895                	li	a7,5
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <write>:
.global write
write:
 li a7, SYS_write
 352:	48c1                	li	a7,16
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <close>:
.global close
close:
 li a7, SYS_close
 35a:	48d5                	li	a7,21
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <kill>:
.global kill
kill:
 li a7, SYS_kill
 362:	4899                	li	a7,6
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <exec>:
.global exec
exec:
 li a7, SYS_exec
 36a:	489d                	li	a7,7
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <open>:
.global open
open:
 li a7, SYS_open
 372:	48bd                	li	a7,15
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 37a:	48c5                	li	a7,17
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 382:	48c9                	li	a7,18
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 38a:	48a1                	li	a7,8
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <link>:
.global link
link:
 li a7, SYS_link
 392:	48cd                	li	a7,19
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 39a:	48d1                	li	a7,20
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3a2:	48a5                	li	a7,9
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <dup>:
.global dup
dup:
 li a7, SYS_dup
 3aa:	48a9                	li	a7,10
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3b2:	48ad                	li	a7,11
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3ba:	48b1                	li	a7,12
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3c2:	48b5                	li	a7,13
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3ca:	48b9                	li	a7,14
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <trace>:
.global trace
trace:
 li a7, SYS_trace
 3d2:	48d9                	li	a7,22
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <alarm>:
.global alarm
alarm:
 li a7, SYS_alarm
 3da:	48dd                	li	a7,23
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <alarmret>:
.global alarmret
alarmret:
 li a7, SYS_alarmret
 3e2:	48e1                	li	a7,24
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ea:	1101                	addi	sp,sp,-32
 3ec:	ec06                	sd	ra,24(sp)
 3ee:	e822                	sd	s0,16(sp)
 3f0:	1000                	addi	s0,sp,32
 3f2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3f6:	4605                	li	a2,1
 3f8:	fef40593          	addi	a1,s0,-17
 3fc:	00000097          	auipc	ra,0x0
 400:	f56080e7          	jalr	-170(ra) # 352 <write>
}
 404:	60e2                	ld	ra,24(sp)
 406:	6442                	ld	s0,16(sp)
 408:	6105                	addi	sp,sp,32
 40a:	8082                	ret

000000000000040c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 40c:	7139                	addi	sp,sp,-64
 40e:	fc06                	sd	ra,56(sp)
 410:	f822                	sd	s0,48(sp)
 412:	f426                	sd	s1,40(sp)
 414:	f04a                	sd	s2,32(sp)
 416:	ec4e                	sd	s3,24(sp)
 418:	0080                	addi	s0,sp,64
 41a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 41c:	c299                	beqz	a3,422 <printint+0x16>
 41e:	0805c863          	bltz	a1,4ae <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 422:	2581                	sext.w	a1,a1
  neg = 0;
 424:	4881                	li	a7,0
 426:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 42a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 42c:	2601                	sext.w	a2,a2
 42e:	00000517          	auipc	a0,0x0
 432:	7c250513          	addi	a0,a0,1986 # bf0 <digits>
 436:	883a                	mv	a6,a4
 438:	2705                	addiw	a4,a4,1
 43a:	02c5f7bb          	remuw	a5,a1,a2
 43e:	1782                	slli	a5,a5,0x20
 440:	9381                	srli	a5,a5,0x20
 442:	97aa                	add	a5,a5,a0
 444:	0007c783          	lbu	a5,0(a5)
 448:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 44c:	0005879b          	sext.w	a5,a1
 450:	02c5d5bb          	divuw	a1,a1,a2
 454:	0685                	addi	a3,a3,1
 456:	fec7f0e3          	bgeu	a5,a2,436 <printint+0x2a>
  if(neg)
 45a:	00088b63          	beqz	a7,470 <printint+0x64>
    buf[i++] = '-';
 45e:	fd040793          	addi	a5,s0,-48
 462:	973e                	add	a4,a4,a5
 464:	02d00793          	li	a5,45
 468:	fef70823          	sb	a5,-16(a4)
 46c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 470:	02e05863          	blez	a4,4a0 <printint+0x94>
 474:	fc040793          	addi	a5,s0,-64
 478:	00e78933          	add	s2,a5,a4
 47c:	fff78993          	addi	s3,a5,-1
 480:	99ba                	add	s3,s3,a4
 482:	377d                	addiw	a4,a4,-1
 484:	1702                	slli	a4,a4,0x20
 486:	9301                	srli	a4,a4,0x20
 488:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 48c:	fff94583          	lbu	a1,-1(s2)
 490:	8526                	mv	a0,s1
 492:	00000097          	auipc	ra,0x0
 496:	f58080e7          	jalr	-168(ra) # 3ea <putc>
  while(--i >= 0)
 49a:	197d                	addi	s2,s2,-1
 49c:	ff3918e3          	bne	s2,s3,48c <printint+0x80>
}
 4a0:	70e2                	ld	ra,56(sp)
 4a2:	7442                	ld	s0,48(sp)
 4a4:	74a2                	ld	s1,40(sp)
 4a6:	7902                	ld	s2,32(sp)
 4a8:	69e2                	ld	s3,24(sp)
 4aa:	6121                	addi	sp,sp,64
 4ac:	8082                	ret
    x = -xx;
 4ae:	40b005bb          	negw	a1,a1
    neg = 1;
 4b2:	4885                	li	a7,1
    x = -xx;
 4b4:	bf8d                	j	426 <printint+0x1a>

00000000000004b6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4b6:	7119                	addi	sp,sp,-128
 4b8:	fc86                	sd	ra,120(sp)
 4ba:	f8a2                	sd	s0,112(sp)
 4bc:	f4a6                	sd	s1,104(sp)
 4be:	f0ca                	sd	s2,96(sp)
 4c0:	ecce                	sd	s3,88(sp)
 4c2:	e8d2                	sd	s4,80(sp)
 4c4:	e4d6                	sd	s5,72(sp)
 4c6:	e0da                	sd	s6,64(sp)
 4c8:	fc5e                	sd	s7,56(sp)
 4ca:	f862                	sd	s8,48(sp)
 4cc:	f466                	sd	s9,40(sp)
 4ce:	f06a                	sd	s10,32(sp)
 4d0:	ec6e                	sd	s11,24(sp)
 4d2:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4d4:	0005c903          	lbu	s2,0(a1)
 4d8:	18090f63          	beqz	s2,676 <vprintf+0x1c0>
 4dc:	8aaa                	mv	s5,a0
 4de:	8b32                	mv	s6,a2
 4e0:	00158493          	addi	s1,a1,1
  state = 0;
 4e4:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4e6:	02500a13          	li	s4,37
      if(c == 'd'){
 4ea:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 4ee:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 4f2:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 4f6:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4fa:	00000b97          	auipc	s7,0x0
 4fe:	6f6b8b93          	addi	s7,s7,1782 # bf0 <digits>
 502:	a839                	j	520 <vprintf+0x6a>
        putc(fd, c);
 504:	85ca                	mv	a1,s2
 506:	8556                	mv	a0,s5
 508:	00000097          	auipc	ra,0x0
 50c:	ee2080e7          	jalr	-286(ra) # 3ea <putc>
 510:	a019                	j	516 <vprintf+0x60>
    } else if(state == '%'){
 512:	01498f63          	beq	s3,s4,530 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 516:	0485                	addi	s1,s1,1
 518:	fff4c903          	lbu	s2,-1(s1)
 51c:	14090d63          	beqz	s2,676 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 520:	0009079b          	sext.w	a5,s2
    if(state == 0){
 524:	fe0997e3          	bnez	s3,512 <vprintf+0x5c>
      if(c == '%'){
 528:	fd479ee3          	bne	a5,s4,504 <vprintf+0x4e>
        state = '%';
 52c:	89be                	mv	s3,a5
 52e:	b7e5                	j	516 <vprintf+0x60>
      if(c == 'd'){
 530:	05878063          	beq	a5,s8,570 <vprintf+0xba>
      } else if(c == 'l') {
 534:	05978c63          	beq	a5,s9,58c <vprintf+0xd6>
      } else if(c == 'x') {
 538:	07a78863          	beq	a5,s10,5a8 <vprintf+0xf2>
      } else if(c == 'p') {
 53c:	09b78463          	beq	a5,s11,5c4 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 540:	07300713          	li	a4,115
 544:	0ce78663          	beq	a5,a4,610 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 548:	06300713          	li	a4,99
 54c:	0ee78e63          	beq	a5,a4,648 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 550:	11478863          	beq	a5,s4,660 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 554:	85d2                	mv	a1,s4
 556:	8556                	mv	a0,s5
 558:	00000097          	auipc	ra,0x0
 55c:	e92080e7          	jalr	-366(ra) # 3ea <putc>
        putc(fd, c);
 560:	85ca                	mv	a1,s2
 562:	8556                	mv	a0,s5
 564:	00000097          	auipc	ra,0x0
 568:	e86080e7          	jalr	-378(ra) # 3ea <putc>
      }
      state = 0;
 56c:	4981                	li	s3,0
 56e:	b765                	j	516 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 570:	008b0913          	addi	s2,s6,8
 574:	4685                	li	a3,1
 576:	4629                	li	a2,10
 578:	000b2583          	lw	a1,0(s6)
 57c:	8556                	mv	a0,s5
 57e:	00000097          	auipc	ra,0x0
 582:	e8e080e7          	jalr	-370(ra) # 40c <printint>
 586:	8b4a                	mv	s6,s2
      state = 0;
 588:	4981                	li	s3,0
 58a:	b771                	j	516 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 58c:	008b0913          	addi	s2,s6,8
 590:	4681                	li	a3,0
 592:	4629                	li	a2,10
 594:	000b2583          	lw	a1,0(s6)
 598:	8556                	mv	a0,s5
 59a:	00000097          	auipc	ra,0x0
 59e:	e72080e7          	jalr	-398(ra) # 40c <printint>
 5a2:	8b4a                	mv	s6,s2
      state = 0;
 5a4:	4981                	li	s3,0
 5a6:	bf85                	j	516 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5a8:	008b0913          	addi	s2,s6,8
 5ac:	4681                	li	a3,0
 5ae:	4641                	li	a2,16
 5b0:	000b2583          	lw	a1,0(s6)
 5b4:	8556                	mv	a0,s5
 5b6:	00000097          	auipc	ra,0x0
 5ba:	e56080e7          	jalr	-426(ra) # 40c <printint>
 5be:	8b4a                	mv	s6,s2
      state = 0;
 5c0:	4981                	li	s3,0
 5c2:	bf91                	j	516 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5c4:	008b0793          	addi	a5,s6,8
 5c8:	f8f43423          	sd	a5,-120(s0)
 5cc:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5d0:	03000593          	li	a1,48
 5d4:	8556                	mv	a0,s5
 5d6:	00000097          	auipc	ra,0x0
 5da:	e14080e7          	jalr	-492(ra) # 3ea <putc>
  putc(fd, 'x');
 5de:	85ea                	mv	a1,s10
 5e0:	8556                	mv	a0,s5
 5e2:	00000097          	auipc	ra,0x0
 5e6:	e08080e7          	jalr	-504(ra) # 3ea <putc>
 5ea:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5ec:	03c9d793          	srli	a5,s3,0x3c
 5f0:	97de                	add	a5,a5,s7
 5f2:	0007c583          	lbu	a1,0(a5)
 5f6:	8556                	mv	a0,s5
 5f8:	00000097          	auipc	ra,0x0
 5fc:	df2080e7          	jalr	-526(ra) # 3ea <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 600:	0992                	slli	s3,s3,0x4
 602:	397d                	addiw	s2,s2,-1
 604:	fe0914e3          	bnez	s2,5ec <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 608:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 60c:	4981                	li	s3,0
 60e:	b721                	j	516 <vprintf+0x60>
        s = va_arg(ap, char*);
 610:	008b0993          	addi	s3,s6,8
 614:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 618:	02090163          	beqz	s2,63a <vprintf+0x184>
        while(*s != 0){
 61c:	00094583          	lbu	a1,0(s2)
 620:	c9a1                	beqz	a1,670 <vprintf+0x1ba>
          putc(fd, *s);
 622:	8556                	mv	a0,s5
 624:	00000097          	auipc	ra,0x0
 628:	dc6080e7          	jalr	-570(ra) # 3ea <putc>
          s++;
 62c:	0905                	addi	s2,s2,1
        while(*s != 0){
 62e:	00094583          	lbu	a1,0(s2)
 632:	f9e5                	bnez	a1,622 <vprintf+0x16c>
        s = va_arg(ap, char*);
 634:	8b4e                	mv	s6,s3
      state = 0;
 636:	4981                	li	s3,0
 638:	bdf9                	j	516 <vprintf+0x60>
          s = "(null)";
 63a:	00000917          	auipc	s2,0x0
 63e:	5ae90913          	addi	s2,s2,1454 # be8 <strstr+0xb2>
        while(*s != 0){
 642:	02800593          	li	a1,40
 646:	bff1                	j	622 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 648:	008b0913          	addi	s2,s6,8
 64c:	000b4583          	lbu	a1,0(s6)
 650:	8556                	mv	a0,s5
 652:	00000097          	auipc	ra,0x0
 656:	d98080e7          	jalr	-616(ra) # 3ea <putc>
 65a:	8b4a                	mv	s6,s2
      state = 0;
 65c:	4981                	li	s3,0
 65e:	bd65                	j	516 <vprintf+0x60>
        putc(fd, c);
 660:	85d2                	mv	a1,s4
 662:	8556                	mv	a0,s5
 664:	00000097          	auipc	ra,0x0
 668:	d86080e7          	jalr	-634(ra) # 3ea <putc>
      state = 0;
 66c:	4981                	li	s3,0
 66e:	b565                	j	516 <vprintf+0x60>
        s = va_arg(ap, char*);
 670:	8b4e                	mv	s6,s3
      state = 0;
 672:	4981                	li	s3,0
 674:	b54d                	j	516 <vprintf+0x60>
    }
  }
}
 676:	70e6                	ld	ra,120(sp)
 678:	7446                	ld	s0,112(sp)
 67a:	74a6                	ld	s1,104(sp)
 67c:	7906                	ld	s2,96(sp)
 67e:	69e6                	ld	s3,88(sp)
 680:	6a46                	ld	s4,80(sp)
 682:	6aa6                	ld	s5,72(sp)
 684:	6b06                	ld	s6,64(sp)
 686:	7be2                	ld	s7,56(sp)
 688:	7c42                	ld	s8,48(sp)
 68a:	7ca2                	ld	s9,40(sp)
 68c:	7d02                	ld	s10,32(sp)
 68e:	6de2                	ld	s11,24(sp)
 690:	6109                	addi	sp,sp,128
 692:	8082                	ret

0000000000000694 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 694:	715d                	addi	sp,sp,-80
 696:	ec06                	sd	ra,24(sp)
 698:	e822                	sd	s0,16(sp)
 69a:	1000                	addi	s0,sp,32
 69c:	e010                	sd	a2,0(s0)
 69e:	e414                	sd	a3,8(s0)
 6a0:	e818                	sd	a4,16(s0)
 6a2:	ec1c                	sd	a5,24(s0)
 6a4:	03043023          	sd	a6,32(s0)
 6a8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6ac:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6b0:	8622                	mv	a2,s0
 6b2:	00000097          	auipc	ra,0x0
 6b6:	e04080e7          	jalr	-508(ra) # 4b6 <vprintf>
}
 6ba:	60e2                	ld	ra,24(sp)
 6bc:	6442                	ld	s0,16(sp)
 6be:	6161                	addi	sp,sp,80
 6c0:	8082                	ret

00000000000006c2 <printf>:

void
printf(const char *fmt, ...)
{
 6c2:	711d                	addi	sp,sp,-96
 6c4:	ec06                	sd	ra,24(sp)
 6c6:	e822                	sd	s0,16(sp)
 6c8:	1000                	addi	s0,sp,32
 6ca:	e40c                	sd	a1,8(s0)
 6cc:	e810                	sd	a2,16(s0)
 6ce:	ec14                	sd	a3,24(s0)
 6d0:	f018                	sd	a4,32(s0)
 6d2:	f41c                	sd	a5,40(s0)
 6d4:	03043823          	sd	a6,48(s0)
 6d8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6dc:	00840613          	addi	a2,s0,8
 6e0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6e4:	85aa                	mv	a1,a0
 6e6:	4505                	li	a0,1
 6e8:	00000097          	auipc	ra,0x0
 6ec:	dce080e7          	jalr	-562(ra) # 4b6 <vprintf>
}
 6f0:	60e2                	ld	ra,24(sp)
 6f2:	6442                	ld	s0,16(sp)
 6f4:	6125                	addi	sp,sp,96
 6f6:	8082                	ret

00000000000006f8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6f8:	1141                	addi	sp,sp,-16
 6fa:	e422                	sd	s0,8(sp)
 6fc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6fe:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 702:	00000797          	auipc	a5,0x0
 706:	5a67b783          	ld	a5,1446(a5) # ca8 <freep>
 70a:	a805                	j	73a <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 70c:	4618                	lw	a4,8(a2)
 70e:	9db9                	addw	a1,a1,a4
 710:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 714:	6398                	ld	a4,0(a5)
 716:	6318                	ld	a4,0(a4)
 718:	fee53823          	sd	a4,-16(a0)
 71c:	a091                	j	760 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 71e:	ff852703          	lw	a4,-8(a0)
 722:	9e39                	addw	a2,a2,a4
 724:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 726:	ff053703          	ld	a4,-16(a0)
 72a:	e398                	sd	a4,0(a5)
 72c:	a099                	j	772 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 72e:	6398                	ld	a4,0(a5)
 730:	00e7e463          	bltu	a5,a4,738 <free+0x40>
 734:	00e6ea63          	bltu	a3,a4,748 <free+0x50>
{
 738:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 73a:	fed7fae3          	bgeu	a5,a3,72e <free+0x36>
 73e:	6398                	ld	a4,0(a5)
 740:	00e6e463          	bltu	a3,a4,748 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 744:	fee7eae3          	bltu	a5,a4,738 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 748:	ff852583          	lw	a1,-8(a0)
 74c:	6390                	ld	a2,0(a5)
 74e:	02059713          	slli	a4,a1,0x20
 752:	9301                	srli	a4,a4,0x20
 754:	0712                	slli	a4,a4,0x4
 756:	9736                	add	a4,a4,a3
 758:	fae60ae3          	beq	a2,a4,70c <free+0x14>
    bp->s.ptr = p->s.ptr;
 75c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 760:	4790                	lw	a2,8(a5)
 762:	02061713          	slli	a4,a2,0x20
 766:	9301                	srli	a4,a4,0x20
 768:	0712                	slli	a4,a4,0x4
 76a:	973e                	add	a4,a4,a5
 76c:	fae689e3          	beq	a3,a4,71e <free+0x26>
  } else
    p->s.ptr = bp;
 770:	e394                	sd	a3,0(a5)
  freep = p;
 772:	00000717          	auipc	a4,0x0
 776:	52f73b23          	sd	a5,1334(a4) # ca8 <freep>
}
 77a:	6422                	ld	s0,8(sp)
 77c:	0141                	addi	sp,sp,16
 77e:	8082                	ret

0000000000000780 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 780:	7139                	addi	sp,sp,-64
 782:	fc06                	sd	ra,56(sp)
 784:	f822                	sd	s0,48(sp)
 786:	f426                	sd	s1,40(sp)
 788:	f04a                	sd	s2,32(sp)
 78a:	ec4e                	sd	s3,24(sp)
 78c:	e852                	sd	s4,16(sp)
 78e:	e456                	sd	s5,8(sp)
 790:	e05a                	sd	s6,0(sp)
 792:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 794:	02051493          	slli	s1,a0,0x20
 798:	9081                	srli	s1,s1,0x20
 79a:	04bd                	addi	s1,s1,15
 79c:	8091                	srli	s1,s1,0x4
 79e:	0014899b          	addiw	s3,s1,1
 7a2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7a4:	00000517          	auipc	a0,0x0
 7a8:	50453503          	ld	a0,1284(a0) # ca8 <freep>
 7ac:	c515                	beqz	a0,7d8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ae:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7b0:	4798                	lw	a4,8(a5)
 7b2:	02977f63          	bgeu	a4,s1,7f0 <malloc+0x70>
 7b6:	8a4e                	mv	s4,s3
 7b8:	0009871b          	sext.w	a4,s3
 7bc:	6685                	lui	a3,0x1
 7be:	00d77363          	bgeu	a4,a3,7c4 <malloc+0x44>
 7c2:	6a05                	lui	s4,0x1
 7c4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7c8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7cc:	00000917          	auipc	s2,0x0
 7d0:	4dc90913          	addi	s2,s2,1244 # ca8 <freep>
  if(p == (char*)-1)
 7d4:	5afd                	li	s5,-1
 7d6:	a88d                	j	848 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 7d8:	00000797          	auipc	a5,0x0
 7dc:	4d878793          	addi	a5,a5,1240 # cb0 <base>
 7e0:	00000717          	auipc	a4,0x0
 7e4:	4cf73423          	sd	a5,1224(a4) # ca8 <freep>
 7e8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7ea:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7ee:	b7e1                	j	7b6 <malloc+0x36>
      if(p->s.size == nunits)
 7f0:	02e48b63          	beq	s1,a4,826 <malloc+0xa6>
        p->s.size -= nunits;
 7f4:	4137073b          	subw	a4,a4,s3
 7f8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7fa:	1702                	slli	a4,a4,0x20
 7fc:	9301                	srli	a4,a4,0x20
 7fe:	0712                	slli	a4,a4,0x4
 800:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 802:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 806:	00000717          	auipc	a4,0x0
 80a:	4aa73123          	sd	a0,1186(a4) # ca8 <freep>
      return (void*)(p + 1);
 80e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 812:	70e2                	ld	ra,56(sp)
 814:	7442                	ld	s0,48(sp)
 816:	74a2                	ld	s1,40(sp)
 818:	7902                	ld	s2,32(sp)
 81a:	69e2                	ld	s3,24(sp)
 81c:	6a42                	ld	s4,16(sp)
 81e:	6aa2                	ld	s5,8(sp)
 820:	6b02                	ld	s6,0(sp)
 822:	6121                	addi	sp,sp,64
 824:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 826:	6398                	ld	a4,0(a5)
 828:	e118                	sd	a4,0(a0)
 82a:	bff1                	j	806 <malloc+0x86>
  hp->s.size = nu;
 82c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 830:	0541                	addi	a0,a0,16
 832:	00000097          	auipc	ra,0x0
 836:	ec6080e7          	jalr	-314(ra) # 6f8 <free>
  return freep;
 83a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 83e:	d971                	beqz	a0,812 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 840:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 842:	4798                	lw	a4,8(a5)
 844:	fa9776e3          	bgeu	a4,s1,7f0 <malloc+0x70>
    if(p == freep)
 848:	00093703          	ld	a4,0(s2)
 84c:	853e                	mv	a0,a5
 84e:	fef719e3          	bne	a4,a5,840 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 852:	8552                	mv	a0,s4
 854:	00000097          	auipc	ra,0x0
 858:	b66080e7          	jalr	-1178(ra) # 3ba <sbrk>
  if(p == (char*)-1)
 85c:	fd5518e3          	bne	a0,s5,82c <malloc+0xac>
        return 0;
 860:	4501                	li	a0,0
 862:	bf45                	j	812 <malloc+0x92>

0000000000000864 <Pipe>:
#include "kernel/stat.h"
#include "user.h"
#include "wrapper.h"
int strncmp(const char*s, const char*pat,int n);

int Pipe(int *p) {
 864:	1101                	addi	sp,sp,-32
 866:	ec06                	sd	ra,24(sp)
 868:	e822                	sd	s0,16(sp)
 86a:	e426                	sd	s1,8(sp)
 86c:	1000                	addi	s0,sp,32
  i32 res = pipe(p);
 86e:	00000097          	auipc	ra,0x0
 872:	ad4080e7          	jalr	-1324(ra) # 342 <pipe>
 876:	84aa                	mv	s1,a0
  if (res < 0) {
 878:	00054863          	bltz	a0,888 <Pipe+0x24>
    fprintf(2, "pipe creation error");
  }
  return res;
}
 87c:	8526                	mv	a0,s1
 87e:	60e2                	ld	ra,24(sp)
 880:	6442                	ld	s0,16(sp)
 882:	64a2                	ld	s1,8(sp)
 884:	6105                	addi	sp,sp,32
 886:	8082                	ret
    fprintf(2, "pipe creation error");
 888:	00000597          	auipc	a1,0x0
 88c:	38058593          	addi	a1,a1,896 # c08 <digits+0x18>
 890:	4509                	li	a0,2
 892:	00000097          	auipc	ra,0x0
 896:	e02080e7          	jalr	-510(ra) # 694 <fprintf>
 89a:	b7cd                	j	87c <Pipe+0x18>

000000000000089c <Write>:

int Write(int fd, void *buf, int count){
 89c:	1141                	addi	sp,sp,-16
 89e:	e406                	sd	ra,8(sp)
 8a0:	e022                	sd	s0,0(sp)
 8a2:	0800                	addi	s0,sp,16
  i32 res = write(fd, buf, count);
 8a4:	00000097          	auipc	ra,0x0
 8a8:	aae080e7          	jalr	-1362(ra) # 352 <write>
  if (res < 0) {
 8ac:	00054663          	bltz	a0,8b8 <Write+0x1c>
    fprintf(2, "write error");
    exit(0);
  }
  return res;
}
 8b0:	60a2                	ld	ra,8(sp)
 8b2:	6402                	ld	s0,0(sp)
 8b4:	0141                	addi	sp,sp,16
 8b6:	8082                	ret
    fprintf(2, "write error");
 8b8:	00000597          	auipc	a1,0x0
 8bc:	36858593          	addi	a1,a1,872 # c20 <digits+0x30>
 8c0:	4509                	li	a0,2
 8c2:	00000097          	auipc	ra,0x0
 8c6:	dd2080e7          	jalr	-558(ra) # 694 <fprintf>
    exit(0);
 8ca:	4501                	li	a0,0
 8cc:	00000097          	auipc	ra,0x0
 8d0:	a66080e7          	jalr	-1434(ra) # 332 <exit>

00000000000008d4 <Read>:



int Read(int fd,  void*buf, int count){
 8d4:	1141                	addi	sp,sp,-16
 8d6:	e406                	sd	ra,8(sp)
 8d8:	e022                	sd	s0,0(sp)
 8da:	0800                	addi	s0,sp,16
  i32 res = read(fd, buf, count);
 8dc:	00000097          	auipc	ra,0x0
 8e0:	a6e080e7          	jalr	-1426(ra) # 34a <read>
  if (res < 0) {
 8e4:	00054663          	bltz	a0,8f0 <Read+0x1c>
    fprintf(2, "read error");
    exit(0);
  }
  return res;
}
 8e8:	60a2                	ld	ra,8(sp)
 8ea:	6402                	ld	s0,0(sp)
 8ec:	0141                	addi	sp,sp,16
 8ee:	8082                	ret
    fprintf(2, "read error");
 8f0:	00000597          	auipc	a1,0x0
 8f4:	34058593          	addi	a1,a1,832 # c30 <digits+0x40>
 8f8:	4509                	li	a0,2
 8fa:	00000097          	auipc	ra,0x0
 8fe:	d9a080e7          	jalr	-614(ra) # 694 <fprintf>
    exit(0);
 902:	4501                	li	a0,0
 904:	00000097          	auipc	ra,0x0
 908:	a2e080e7          	jalr	-1490(ra) # 332 <exit>

000000000000090c <Open>:


int Open(const char* path, int flag){
 90c:	1141                	addi	sp,sp,-16
 90e:	e406                	sd	ra,8(sp)
 910:	e022                	sd	s0,0(sp)
 912:	0800                	addi	s0,sp,16
  i32 res = open(path, flag);
 914:	00000097          	auipc	ra,0x0
 918:	a5e080e7          	jalr	-1442(ra) # 372 <open>
  if (res < 0) {
 91c:	00054663          	bltz	a0,928 <Open+0x1c>
    fprintf(2, "open error");
    exit(0);
  }
  return res;
}
 920:	60a2                	ld	ra,8(sp)
 922:	6402                	ld	s0,0(sp)
 924:	0141                	addi	sp,sp,16
 926:	8082                	ret
    fprintf(2, "open error");
 928:	00000597          	auipc	a1,0x0
 92c:	31858593          	addi	a1,a1,792 # c40 <digits+0x50>
 930:	4509                	li	a0,2
 932:	00000097          	auipc	ra,0x0
 936:	d62080e7          	jalr	-670(ra) # 694 <fprintf>
    exit(0);
 93a:	4501                	li	a0,0
 93c:	00000097          	auipc	ra,0x0
 940:	9f6080e7          	jalr	-1546(ra) # 332 <exit>

0000000000000944 <Fstat>:


int Fstat(int fd, stat_t *st){
 944:	1141                	addi	sp,sp,-16
 946:	e406                	sd	ra,8(sp)
 948:	e022                	sd	s0,0(sp)
 94a:	0800                	addi	s0,sp,16
  i32 res = fstat(fd, st);
 94c:	00000097          	auipc	ra,0x0
 950:	a3e080e7          	jalr	-1474(ra) # 38a <fstat>
  if (res < 0) {
 954:	00054663          	bltz	a0,960 <Fstat+0x1c>
    fprintf(2, "get file stat error");
    exit(0);
  }
  return res;
}
 958:	60a2                	ld	ra,8(sp)
 95a:	6402                	ld	s0,0(sp)
 95c:	0141                	addi	sp,sp,16
 95e:	8082                	ret
    fprintf(2, "get file stat error");
 960:	00000597          	auipc	a1,0x0
 964:	2f058593          	addi	a1,a1,752 # c50 <digits+0x60>
 968:	4509                	li	a0,2
 96a:	00000097          	auipc	ra,0x0
 96e:	d2a080e7          	jalr	-726(ra) # 694 <fprintf>
    exit(0);
 972:	4501                	li	a0,0
 974:	00000097          	auipc	ra,0x0
 978:	9be080e7          	jalr	-1602(ra) # 332 <exit>

000000000000097c <Dup>:



int Dup(int fd){
 97c:	1141                	addi	sp,sp,-16
 97e:	e406                	sd	ra,8(sp)
 980:	e022                	sd	s0,0(sp)
 982:	0800                	addi	s0,sp,16
  i32 res = dup(fd);
 984:	00000097          	auipc	ra,0x0
 988:	a26080e7          	jalr	-1498(ra) # 3aa <dup>
  if (res < 0) {
 98c:	00054663          	bltz	a0,998 <Dup+0x1c>
    fprintf(2, "dup error");
    exit(0);
  }
  return res;

}
 990:	60a2                	ld	ra,8(sp)
 992:	6402                	ld	s0,0(sp)
 994:	0141                	addi	sp,sp,16
 996:	8082                	ret
    fprintf(2, "dup error");
 998:	00000597          	auipc	a1,0x0
 99c:	2d058593          	addi	a1,a1,720 # c68 <digits+0x78>
 9a0:	4509                	li	a0,2
 9a2:	00000097          	auipc	ra,0x0
 9a6:	cf2080e7          	jalr	-782(ra) # 694 <fprintf>
    exit(0);
 9aa:	4501                	li	a0,0
 9ac:	00000097          	auipc	ra,0x0
 9b0:	986080e7          	jalr	-1658(ra) # 332 <exit>

00000000000009b4 <Close>:

int Close(int fd){
 9b4:	1141                	addi	sp,sp,-16
 9b6:	e406                	sd	ra,8(sp)
 9b8:	e022                	sd	s0,0(sp)
 9ba:	0800                	addi	s0,sp,16
  i32 res = close(fd);
 9bc:	00000097          	auipc	ra,0x0
 9c0:	99e080e7          	jalr	-1634(ra) # 35a <close>
  if (res < 0) {
 9c4:	00054663          	bltz	a0,9d0 <Close+0x1c>
    fprintf(2, "file close error~");
    exit(0);
  }
  return res;
}
 9c8:	60a2                	ld	ra,8(sp)
 9ca:	6402                	ld	s0,0(sp)
 9cc:	0141                	addi	sp,sp,16
 9ce:	8082                	ret
    fprintf(2, "file close error~");
 9d0:	00000597          	auipc	a1,0x0
 9d4:	2a858593          	addi	a1,a1,680 # c78 <digits+0x88>
 9d8:	4509                	li	a0,2
 9da:	00000097          	auipc	ra,0x0
 9de:	cba080e7          	jalr	-838(ra) # 694 <fprintf>
    exit(0);
 9e2:	4501                	li	a0,0
 9e4:	00000097          	auipc	ra,0x0
 9e8:	94e080e7          	jalr	-1714(ra) # 332 <exit>

00000000000009ec <Dup2>:

int Dup2(int old_fd,int new_fd){
 9ec:	1101                	addi	sp,sp,-32
 9ee:	ec06                	sd	ra,24(sp)
 9f0:	e822                	sd	s0,16(sp)
 9f2:	e426                	sd	s1,8(sp)
 9f4:	1000                	addi	s0,sp,32
 9f6:	84aa                	mv	s1,a0
  Close(new_fd);
 9f8:	852e                	mv	a0,a1
 9fa:	00000097          	auipc	ra,0x0
 9fe:	fba080e7          	jalr	-70(ra) # 9b4 <Close>
  i32 res = Dup(old_fd);
 a02:	8526                	mv	a0,s1
 a04:	00000097          	auipc	ra,0x0
 a08:	f78080e7          	jalr	-136(ra) # 97c <Dup>
  if (res < 0) {
 a0c:	00054763          	bltz	a0,a1a <Dup2+0x2e>
    fprintf(2, "dup error");
    exit(0);
  }
  return res;
}
 a10:	60e2                	ld	ra,24(sp)
 a12:	6442                	ld	s0,16(sp)
 a14:	64a2                	ld	s1,8(sp)
 a16:	6105                	addi	sp,sp,32
 a18:	8082                	ret
    fprintf(2, "dup error");
 a1a:	00000597          	auipc	a1,0x0
 a1e:	24e58593          	addi	a1,a1,590 # c68 <digits+0x78>
 a22:	4509                	li	a0,2
 a24:	00000097          	auipc	ra,0x0
 a28:	c70080e7          	jalr	-912(ra) # 694 <fprintf>
    exit(0);
 a2c:	4501                	li	a0,0
 a2e:	00000097          	auipc	ra,0x0
 a32:	904080e7          	jalr	-1788(ra) # 332 <exit>

0000000000000a36 <Stat>:

int Stat(const char*link,stat_t *st){
 a36:	1101                	addi	sp,sp,-32
 a38:	ec06                	sd	ra,24(sp)
 a3a:	e822                	sd	s0,16(sp)
 a3c:	e426                	sd	s1,8(sp)
 a3e:	1000                	addi	s0,sp,32
 a40:	84aa                	mv	s1,a0
  i32 res = stat(link,st);
 a42:	fffff097          	auipc	ra,0xfffff
 a46:	7ae080e7          	jalr	1966(ra) # 1f0 <stat>
  if (res < 0) {
 a4a:	00054763          	bltz	a0,a58 <Stat+0x22>
    fprintf(2, "file %s stat error",link);
    exit(0);
  }
  return res;
}
 a4e:	60e2                	ld	ra,24(sp)
 a50:	6442                	ld	s0,16(sp)
 a52:	64a2                	ld	s1,8(sp)
 a54:	6105                	addi	sp,sp,32
 a56:	8082                	ret
    fprintf(2, "file %s stat error",link);
 a58:	8626                	mv	a2,s1
 a5a:	00000597          	auipc	a1,0x0
 a5e:	23658593          	addi	a1,a1,566 # c90 <digits+0xa0>
 a62:	4509                	li	a0,2
 a64:	00000097          	auipc	ra,0x0
 a68:	c30080e7          	jalr	-976(ra) # 694 <fprintf>
    exit(0);
 a6c:	4501                	li	a0,0
 a6e:	00000097          	auipc	ra,0x0
 a72:	8c4080e7          	jalr	-1852(ra) # 332 <exit>

0000000000000a76 <strncmp>:
   return -1;
}



int strncmp(const char*s, const char*pat,int n){
 a76:	bc010113          	addi	sp,sp,-1088
 a7a:	42113c23          	sd	ra,1080(sp)
 a7e:	42813823          	sd	s0,1072(sp)
 a82:	42913423          	sd	s1,1064(sp)
 a86:	43213023          	sd	s2,1056(sp)
 a8a:	41313c23          	sd	s3,1048(sp)
 a8e:	41413823          	sd	s4,1040(sp)
 a92:	41513423          	sd	s5,1032(sp)
 a96:	44010413          	addi	s0,sp,1088
 a9a:	89aa                	mv	s3,a0
 a9c:	892e                	mv	s2,a1
 a9e:	84b2                	mv	s1,a2
  char buf1[512],buf2[512];
  int n1 = MIN(n,strlen(s));
 aa0:	fffff097          	auipc	ra,0xfffff
 aa4:	66c080e7          	jalr	1644(ra) # 10c <strlen>
 aa8:	2501                	sext.w	a0,a0
 aaa:	00048a1b          	sext.w	s4,s1
 aae:	8aa6                	mv	s5,s1
 ab0:	06aa7363          	bgeu	s4,a0,b16 <strncmp+0xa0>
  int n2 = MIN(n,strlen(pat));
 ab4:	854a                	mv	a0,s2
 ab6:	fffff097          	auipc	ra,0xfffff
 aba:	656080e7          	jalr	1622(ra) # 10c <strlen>
 abe:	2501                	sext.w	a0,a0
 ac0:	06aa7363          	bgeu	s4,a0,b26 <strncmp+0xb0>
  memmove(buf1,s,n1);
 ac4:	8656                	mv	a2,s5
 ac6:	85ce                	mv	a1,s3
 ac8:	dc040513          	addi	a0,s0,-576
 acc:	fffff097          	auipc	ra,0xfffff
 ad0:	7b4080e7          	jalr	1972(ra) # 280 <memmove>
  memmove(buf2,pat,n2);
 ad4:	8626                	mv	a2,s1
 ad6:	85ca                	mv	a1,s2
 ad8:	bc040513          	addi	a0,s0,-1088
 adc:	fffff097          	auipc	ra,0xfffff
 ae0:	7a4080e7          	jalr	1956(ra) # 280 <memmove>
  return strcmp(buf1,buf2);
 ae4:	bc040593          	addi	a1,s0,-1088
 ae8:	dc040513          	addi	a0,s0,-576
 aec:	fffff097          	auipc	ra,0xfffff
 af0:	5f4080e7          	jalr	1524(ra) # e0 <strcmp>
}
 af4:	43813083          	ld	ra,1080(sp)
 af8:	43013403          	ld	s0,1072(sp)
 afc:	42813483          	ld	s1,1064(sp)
 b00:	42013903          	ld	s2,1056(sp)
 b04:	41813983          	ld	s3,1048(sp)
 b08:	41013a03          	ld	s4,1040(sp)
 b0c:	40813a83          	ld	s5,1032(sp)
 b10:	44010113          	addi	sp,sp,1088
 b14:	8082                	ret
  int n1 = MIN(n,strlen(s));
 b16:	854e                	mv	a0,s3
 b18:	fffff097          	auipc	ra,0xfffff
 b1c:	5f4080e7          	jalr	1524(ra) # 10c <strlen>
 b20:	00050a9b          	sext.w	s5,a0
 b24:	bf41                	j	ab4 <strncmp+0x3e>
  int n2 = MIN(n,strlen(pat));
 b26:	854a                	mv	a0,s2
 b28:	fffff097          	auipc	ra,0xfffff
 b2c:	5e4080e7          	jalr	1508(ra) # 10c <strlen>
 b30:	0005049b          	sext.w	s1,a0
 b34:	bf41                	j	ac4 <strncmp+0x4e>

0000000000000b36 <strstr>:
   while (*s != 0){
 b36:	00054783          	lbu	a5,0(a0)
 b3a:	cba1                	beqz	a5,b8a <strstr+0x54>
int strstr(char *s,char *p){
 b3c:	7179                	addi	sp,sp,-48
 b3e:	f406                	sd	ra,40(sp)
 b40:	f022                	sd	s0,32(sp)
 b42:	ec26                	sd	s1,24(sp)
 b44:	e84a                	sd	s2,16(sp)
 b46:	e44e                	sd	s3,8(sp)
 b48:	1800                	addi	s0,sp,48
 b4a:	89aa                	mv	s3,a0
 b4c:	892e                	mv	s2,a1
   while (*s != 0){
 b4e:	84aa                	mv	s1,a0
     if (!strncmp(s,p,strlen(p)))
 b50:	854a                	mv	a0,s2
 b52:	fffff097          	auipc	ra,0xfffff
 b56:	5ba080e7          	jalr	1466(ra) # 10c <strlen>
 b5a:	0005061b          	sext.w	a2,a0
 b5e:	85ca                	mv	a1,s2
 b60:	8526                	mv	a0,s1
 b62:	00000097          	auipc	ra,0x0
 b66:	f14080e7          	jalr	-236(ra) # a76 <strncmp>
 b6a:	c519                	beqz	a0,b78 <strstr+0x42>
     s++;
 b6c:	0485                	addi	s1,s1,1
   while (*s != 0){
 b6e:	0004c783          	lbu	a5,0(s1)
 b72:	fff9                	bnez	a5,b50 <strstr+0x1a>
   return -1;
 b74:	557d                	li	a0,-1
 b76:	a019                	j	b7c <strstr+0x46>
      return s - ori;
 b78:	4134853b          	subw	a0,s1,s3
}
 b7c:	70a2                	ld	ra,40(sp)
 b7e:	7402                	ld	s0,32(sp)
 b80:	64e2                	ld	s1,24(sp)
 b82:	6942                	ld	s2,16(sp)
 b84:	69a2                	ld	s3,8(sp)
 b86:	6145                	addi	sp,sp,48
 b88:	8082                	ret
   return -1;
 b8a:	557d                	li	a0,-1
}
 b8c:	8082                	ret
