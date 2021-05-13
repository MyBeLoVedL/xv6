
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
   c:	bb050513          	addi	a0,a0,-1104 # bb8 <strstr+0x5e>
  10:	00000097          	auipc	ra,0x0
  14:	6d6080e7          	jalr	1750(ra) # 6e6 <printf>
  alarm(10, sayyou);
  18:	00000597          	auipc	a1,0x0
  1c:	02258593          	addi	a1,a1,34 # 3a <sayyou>
  20:	4529                	li	a0,10
  22:	00000097          	auipc	ra,0x0
  26:	3dc080e7          	jalr	988(ra) # 3fe <alarm>
  alarmret();
  2a:	00000097          	auipc	ra,0x0
  2e:	3dc080e7          	jalr	988(ra) # 406 <alarmret>
}
  32:	60a2                	ld	ra,8(sp)
  34:	6402                	ld	s0,0(sp)
  36:	0141                	addi	sp,sp,16
  38:	8082                	ret

000000000000003a <sayyou>:

void sayyou() {
  3a:	1141                	addi	sp,sp,-16
  3c:	e406                	sd	ra,8(sp)
  3e:	e022                	sd	s0,0(sp)
  40:	0800                	addi	s0,sp,16
  printf("you~\n");
  42:	00001517          	auipc	a0,0x1
  46:	b7e50513          	addi	a0,a0,-1154 # bc0 <strstr+0x66>
  4a:	00000097          	auipc	ra,0x0
  4e:	69c080e7          	jalr	1692(ra) # 6e6 <printf>
  alarm(10, sayhi);
  52:	00000597          	auipc	a1,0x0
  56:	fae58593          	addi	a1,a1,-82 # 0 <sayhi>
  5a:	4529                	li	a0,10
  5c:	00000097          	auipc	ra,0x0
  60:	3a2080e7          	jalr	930(ra) # 3fe <alarm>
  alarmret();
  64:	00000097          	auipc	ra,0x0
  68:	3a2080e7          	jalr	930(ra) # 406 <alarmret>
}
  6c:	60a2                	ld	ra,8(sp)
  6e:	6402                	ld	s0,0(sp)
  70:	0141                	addi	sp,sp,16
  72:	8082                	ret

0000000000000074 <main>:

int main(int argc, char **argv) {
  74:	1101                	addi	sp,sp,-32
  76:	ec06                	sd	ra,24(sp)
  78:	e822                	sd	s0,16(sp)
  7a:	e426                	sd	s1,8(sp)
  7c:	1000                	addi	s0,sp,32
  char *s = sbrk(0);
  7e:	4501                	li	a0,0
  80:	00000097          	auipc	ra,0x0
  84:	35e080e7          	jalr	862(ra) # 3de <sbrk>
  char ch;
  alarm(10, sayyou);
  88:	00000597          	auipc	a1,0x0
  8c:	fb258593          	addi	a1,a1,-78 # 3a <sayyou>
  90:	4529                	li	a0,10
  92:	00000097          	auipc	ra,0x0
  96:	36c080e7          	jalr	876(ra) # 3fe <alarm>
  printf("address of hi %p\n", sayhi);
  9a:	00000597          	auipc	a1,0x0
  9e:	f6658593          	addi	a1,a1,-154 # 0 <sayhi>
  a2:	00001517          	auipc	a0,0x1
  a6:	b2650513          	addi	a0,a0,-1242 # bc8 <strstr+0x6e>
  aa:	00000097          	auipc	ra,0x0
  ae:	63c080e7          	jalr	1596(ra) # 6e6 <printf>
  printf("address of you %p\n", sayyou);
  b2:	00000597          	auipc	a1,0x0
  b6:	f8858593          	addi	a1,a1,-120 # 3a <sayyou>
  ba:	00001517          	auipc	a0,0x1
  be:	b2650513          	addi	a0,a0,-1242 # be0 <strstr+0x86>
  c2:	00000097          	auipc	ra,0x0
  c6:	624080e7          	jalr	1572(ra) # 6e6 <printf>
  while (1) {
    for (u64 i = 0; i <= 0xfffffff; i++)
      ch = 9;
    printf("I am in user mode~\n");
  ca:	00001497          	auipc	s1,0x1
  ce:	b2e48493          	addi	s1,s1,-1234 # bf8 <strstr+0x9e>
  d2:	a031                	j	de <main+0x6a>
  d4:	8526                	mv	a0,s1
  d6:	00000097          	auipc	ra,0x0
  da:	610080e7          	jalr	1552(ra) # 6e6 <printf>
int main(int argc, char **argv) {
  de:	100007b7          	lui	a5,0x10000
    for (u64 i = 0; i <= 0xfffffff; i++)
  e2:	17fd                	addi	a5,a5,-1
  e4:	fffd                	bnez	a5,e2 <main+0x6e>
  e6:	b7fd                	j	d4 <main+0x60>

00000000000000e8 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  e8:	1141                	addi	sp,sp,-16
  ea:	e422                	sd	s0,8(sp)
  ec:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ee:	87aa                	mv	a5,a0
  f0:	0585                	addi	a1,a1,1
  f2:	0785                	addi	a5,a5,1
  f4:	fff5c703          	lbu	a4,-1(a1)
  f8:	fee78fa3          	sb	a4,-1(a5) # fffffff <__global_pointer$+0xfffeb34>
  fc:	fb75                	bnez	a4,f0 <strcpy+0x8>
    ;
  return os;
}
  fe:	6422                	ld	s0,8(sp)
 100:	0141                	addi	sp,sp,16
 102:	8082                	ret

0000000000000104 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 104:	1141                	addi	sp,sp,-16
 106:	e422                	sd	s0,8(sp)
 108:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 10a:	00054783          	lbu	a5,0(a0)
 10e:	cb91                	beqz	a5,122 <strcmp+0x1e>
 110:	0005c703          	lbu	a4,0(a1)
 114:	00f71763          	bne	a4,a5,122 <strcmp+0x1e>
    p++, q++;
 118:	0505                	addi	a0,a0,1
 11a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 11c:	00054783          	lbu	a5,0(a0)
 120:	fbe5                	bnez	a5,110 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 122:	0005c503          	lbu	a0,0(a1)
}
 126:	40a7853b          	subw	a0,a5,a0
 12a:	6422                	ld	s0,8(sp)
 12c:	0141                	addi	sp,sp,16
 12e:	8082                	ret

0000000000000130 <strlen>:

uint
strlen(const char *s)
{
 130:	1141                	addi	sp,sp,-16
 132:	e422                	sd	s0,8(sp)
 134:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 136:	00054783          	lbu	a5,0(a0)
 13a:	cf91                	beqz	a5,156 <strlen+0x26>
 13c:	0505                	addi	a0,a0,1
 13e:	87aa                	mv	a5,a0
 140:	4685                	li	a3,1
 142:	9e89                	subw	a3,a3,a0
 144:	00f6853b          	addw	a0,a3,a5
 148:	0785                	addi	a5,a5,1
 14a:	fff7c703          	lbu	a4,-1(a5)
 14e:	fb7d                	bnez	a4,144 <strlen+0x14>
    ;
  return n;
}
 150:	6422                	ld	s0,8(sp)
 152:	0141                	addi	sp,sp,16
 154:	8082                	ret
  for(n = 0; s[n]; n++)
 156:	4501                	li	a0,0
 158:	bfe5                	j	150 <strlen+0x20>

000000000000015a <memset>:

void*
memset(void *dst, int c, uint n)
{
 15a:	1141                	addi	sp,sp,-16
 15c:	e422                	sd	s0,8(sp)
 15e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 160:	ca19                	beqz	a2,176 <memset+0x1c>
 162:	87aa                	mv	a5,a0
 164:	1602                	slli	a2,a2,0x20
 166:	9201                	srli	a2,a2,0x20
 168:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 16c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 170:	0785                	addi	a5,a5,1
 172:	fee79de3          	bne	a5,a4,16c <memset+0x12>
  }
  return dst;
}
 176:	6422                	ld	s0,8(sp)
 178:	0141                	addi	sp,sp,16
 17a:	8082                	ret

000000000000017c <strchr>:

char*
strchr(const char *s, char c)
{
 17c:	1141                	addi	sp,sp,-16
 17e:	e422                	sd	s0,8(sp)
 180:	0800                	addi	s0,sp,16
  for(; *s; s++)
 182:	00054783          	lbu	a5,0(a0)
 186:	cb99                	beqz	a5,19c <strchr+0x20>
    if(*s == c)
 188:	00f58763          	beq	a1,a5,196 <strchr+0x1a>
  for(; *s; s++)
 18c:	0505                	addi	a0,a0,1
 18e:	00054783          	lbu	a5,0(a0)
 192:	fbfd                	bnez	a5,188 <strchr+0xc>
      return (char*)s;
  return 0;
 194:	4501                	li	a0,0
}
 196:	6422                	ld	s0,8(sp)
 198:	0141                	addi	sp,sp,16
 19a:	8082                	ret
  return 0;
 19c:	4501                	li	a0,0
 19e:	bfe5                	j	196 <strchr+0x1a>

00000000000001a0 <gets>:

char*
gets(char *buf, int max)
{
 1a0:	711d                	addi	sp,sp,-96
 1a2:	ec86                	sd	ra,88(sp)
 1a4:	e8a2                	sd	s0,80(sp)
 1a6:	e4a6                	sd	s1,72(sp)
 1a8:	e0ca                	sd	s2,64(sp)
 1aa:	fc4e                	sd	s3,56(sp)
 1ac:	f852                	sd	s4,48(sp)
 1ae:	f456                	sd	s5,40(sp)
 1b0:	f05a                	sd	s6,32(sp)
 1b2:	ec5e                	sd	s7,24(sp)
 1b4:	1080                	addi	s0,sp,96
 1b6:	8baa                	mv	s7,a0
 1b8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ba:	892a                	mv	s2,a0
 1bc:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1be:	4aa9                	li	s5,10
 1c0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1c2:	89a6                	mv	s3,s1
 1c4:	2485                	addiw	s1,s1,1
 1c6:	0344d863          	bge	s1,s4,1f6 <gets+0x56>
    cc = read(0, &c, 1);
 1ca:	4605                	li	a2,1
 1cc:	faf40593          	addi	a1,s0,-81
 1d0:	4501                	li	a0,0
 1d2:	00000097          	auipc	ra,0x0
 1d6:	19c080e7          	jalr	412(ra) # 36e <read>
    if(cc < 1)
 1da:	00a05e63          	blez	a0,1f6 <gets+0x56>
    buf[i++] = c;
 1de:	faf44783          	lbu	a5,-81(s0)
 1e2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1e6:	01578763          	beq	a5,s5,1f4 <gets+0x54>
 1ea:	0905                	addi	s2,s2,1
 1ec:	fd679be3          	bne	a5,s6,1c2 <gets+0x22>
  for(i=0; i+1 < max; ){
 1f0:	89a6                	mv	s3,s1
 1f2:	a011                	j	1f6 <gets+0x56>
 1f4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1f6:	99de                	add	s3,s3,s7
 1f8:	00098023          	sb	zero,0(s3)
  return buf;
}
 1fc:	855e                	mv	a0,s7
 1fe:	60e6                	ld	ra,88(sp)
 200:	6446                	ld	s0,80(sp)
 202:	64a6                	ld	s1,72(sp)
 204:	6906                	ld	s2,64(sp)
 206:	79e2                	ld	s3,56(sp)
 208:	7a42                	ld	s4,48(sp)
 20a:	7aa2                	ld	s5,40(sp)
 20c:	7b02                	ld	s6,32(sp)
 20e:	6be2                	ld	s7,24(sp)
 210:	6125                	addi	sp,sp,96
 212:	8082                	ret

0000000000000214 <stat>:

int
stat(const char *n, struct stat *st)
{
 214:	1101                	addi	sp,sp,-32
 216:	ec06                	sd	ra,24(sp)
 218:	e822                	sd	s0,16(sp)
 21a:	e426                	sd	s1,8(sp)
 21c:	e04a                	sd	s2,0(sp)
 21e:	1000                	addi	s0,sp,32
 220:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 222:	4581                	li	a1,0
 224:	00000097          	auipc	ra,0x0
 228:	172080e7          	jalr	370(ra) # 396 <open>
  if(fd < 0)
 22c:	02054563          	bltz	a0,256 <stat+0x42>
 230:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 232:	85ca                	mv	a1,s2
 234:	00000097          	auipc	ra,0x0
 238:	17a080e7          	jalr	378(ra) # 3ae <fstat>
 23c:	892a                	mv	s2,a0
  close(fd);
 23e:	8526                	mv	a0,s1
 240:	00000097          	auipc	ra,0x0
 244:	13e080e7          	jalr	318(ra) # 37e <close>
  return r;
}
 248:	854a                	mv	a0,s2
 24a:	60e2                	ld	ra,24(sp)
 24c:	6442                	ld	s0,16(sp)
 24e:	64a2                	ld	s1,8(sp)
 250:	6902                	ld	s2,0(sp)
 252:	6105                	addi	sp,sp,32
 254:	8082                	ret
    return -1;
 256:	597d                	li	s2,-1
 258:	bfc5                	j	248 <stat+0x34>

000000000000025a <atoi>:

int
atoi(const char *s)
{
 25a:	1141                	addi	sp,sp,-16
 25c:	e422                	sd	s0,8(sp)
 25e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 260:	00054603          	lbu	a2,0(a0)
 264:	fd06079b          	addiw	a5,a2,-48
 268:	0ff7f793          	andi	a5,a5,255
 26c:	4725                	li	a4,9
 26e:	02f76963          	bltu	a4,a5,2a0 <atoi+0x46>
 272:	86aa                	mv	a3,a0
  n = 0;
 274:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 276:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 278:	0685                	addi	a3,a3,1
 27a:	0025179b          	slliw	a5,a0,0x2
 27e:	9fa9                	addw	a5,a5,a0
 280:	0017979b          	slliw	a5,a5,0x1
 284:	9fb1                	addw	a5,a5,a2
 286:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 28a:	0006c603          	lbu	a2,0(a3)
 28e:	fd06071b          	addiw	a4,a2,-48
 292:	0ff77713          	andi	a4,a4,255
 296:	fee5f1e3          	bgeu	a1,a4,278 <atoi+0x1e>
  return n;
}
 29a:	6422                	ld	s0,8(sp)
 29c:	0141                	addi	sp,sp,16
 29e:	8082                	ret
  n = 0;
 2a0:	4501                	li	a0,0
 2a2:	bfe5                	j	29a <atoi+0x40>

00000000000002a4 <memmove>:

// #define memcpy memmove

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a4:	1141                	addi	sp,sp,-16
 2a6:	e422                	sd	s0,8(sp)
 2a8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2aa:	02b57463          	bgeu	a0,a1,2d2 <memmove+0x2e>
    while(n-- > 0)
 2ae:	00c05f63          	blez	a2,2cc <memmove+0x28>
 2b2:	1602                	slli	a2,a2,0x20
 2b4:	9201                	srli	a2,a2,0x20
 2b6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2ba:	872a                	mv	a4,a0
      *dst++ = *src++;
 2bc:	0585                	addi	a1,a1,1
 2be:	0705                	addi	a4,a4,1
 2c0:	fff5c683          	lbu	a3,-1(a1)
 2c4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2c8:	fee79ae3          	bne	a5,a4,2bc <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2cc:	6422                	ld	s0,8(sp)
 2ce:	0141                	addi	sp,sp,16
 2d0:	8082                	ret
    dst += n;
 2d2:	00c50733          	add	a4,a0,a2
    src += n;
 2d6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2d8:	fec05ae3          	blez	a2,2cc <memmove+0x28>
 2dc:	fff6079b          	addiw	a5,a2,-1
 2e0:	1782                	slli	a5,a5,0x20
 2e2:	9381                	srli	a5,a5,0x20
 2e4:	fff7c793          	not	a5,a5
 2e8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2ea:	15fd                	addi	a1,a1,-1
 2ec:	177d                	addi	a4,a4,-1
 2ee:	0005c683          	lbu	a3,0(a1)
 2f2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2f6:	fee79ae3          	bne	a5,a4,2ea <memmove+0x46>
 2fa:	bfc9                	j	2cc <memmove+0x28>

00000000000002fc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2fc:	1141                	addi	sp,sp,-16
 2fe:	e422                	sd	s0,8(sp)
 300:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 302:	ca05                	beqz	a2,332 <memcmp+0x36>
 304:	fff6069b          	addiw	a3,a2,-1
 308:	1682                	slli	a3,a3,0x20
 30a:	9281                	srli	a3,a3,0x20
 30c:	0685                	addi	a3,a3,1
 30e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 310:	00054783          	lbu	a5,0(a0)
 314:	0005c703          	lbu	a4,0(a1)
 318:	00e79863          	bne	a5,a4,328 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 31c:	0505                	addi	a0,a0,1
    p2++;
 31e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 320:	fed518e3          	bne	a0,a3,310 <memcmp+0x14>
  }
  return 0;
 324:	4501                	li	a0,0
 326:	a019                	j	32c <memcmp+0x30>
      return *p1 - *p2;
 328:	40e7853b          	subw	a0,a5,a4
}
 32c:	6422                	ld	s0,8(sp)
 32e:	0141                	addi	sp,sp,16
 330:	8082                	ret
  return 0;
 332:	4501                	li	a0,0
 334:	bfe5                	j	32c <memcmp+0x30>

0000000000000336 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 336:	1141                	addi	sp,sp,-16
 338:	e406                	sd	ra,8(sp)
 33a:	e022                	sd	s0,0(sp)
 33c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 33e:	00000097          	auipc	ra,0x0
 342:	f66080e7          	jalr	-154(ra) # 2a4 <memmove>
}
 346:	60a2                	ld	ra,8(sp)
 348:	6402                	ld	s0,0(sp)
 34a:	0141                	addi	sp,sp,16
 34c:	8082                	ret

000000000000034e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 34e:	4885                	li	a7,1
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <exit>:
.global exit
exit:
 li a7, SYS_exit
 356:	4889                	li	a7,2
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <wait>:
.global wait
wait:
 li a7, SYS_wait
 35e:	488d                	li	a7,3
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 366:	4891                	li	a7,4
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <read>:
.global read
read:
 li a7, SYS_read
 36e:	4895                	li	a7,5
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <write>:
.global write
write:
 li a7, SYS_write
 376:	48c1                	li	a7,16
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <close>:
.global close
close:
 li a7, SYS_close
 37e:	48d5                	li	a7,21
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <kill>:
.global kill
kill:
 li a7, SYS_kill
 386:	4899                	li	a7,6
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <exec>:
.global exec
exec:
 li a7, SYS_exec
 38e:	489d                	li	a7,7
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <open>:
.global open
open:
 li a7, SYS_open
 396:	48bd                	li	a7,15
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 39e:	48c5                	li	a7,17
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3a6:	48c9                	li	a7,18
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3ae:	48a1                	li	a7,8
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <link>:
.global link
link:
 li a7, SYS_link
 3b6:	48cd                	li	a7,19
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3be:	48d1                	li	a7,20
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3c6:	48a5                	li	a7,9
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <dup>:
.global dup
dup:
 li a7, SYS_dup
 3ce:	48a9                	li	a7,10
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3d6:	48ad                	li	a7,11
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3de:	48b1                	li	a7,12
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3e6:	48b5                	li	a7,13
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3ee:	48b9                	li	a7,14
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <trace>:
.global trace
trace:
 li a7, SYS_trace
 3f6:	48d9                	li	a7,22
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <alarm>:
.global alarm
alarm:
 li a7, SYS_alarm
 3fe:	48dd                	li	a7,23
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <alarmret>:
.global alarmret
alarmret:
 li a7, SYS_alarmret
 406:	48e1                	li	a7,24
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 40e:	1101                	addi	sp,sp,-32
 410:	ec06                	sd	ra,24(sp)
 412:	e822                	sd	s0,16(sp)
 414:	1000                	addi	s0,sp,32
 416:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 41a:	4605                	li	a2,1
 41c:	fef40593          	addi	a1,s0,-17
 420:	00000097          	auipc	ra,0x0
 424:	f56080e7          	jalr	-170(ra) # 376 <write>
}
 428:	60e2                	ld	ra,24(sp)
 42a:	6442                	ld	s0,16(sp)
 42c:	6105                	addi	sp,sp,32
 42e:	8082                	ret

0000000000000430 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 430:	7139                	addi	sp,sp,-64
 432:	fc06                	sd	ra,56(sp)
 434:	f822                	sd	s0,48(sp)
 436:	f426                	sd	s1,40(sp)
 438:	f04a                	sd	s2,32(sp)
 43a:	ec4e                	sd	s3,24(sp)
 43c:	0080                	addi	s0,sp,64
 43e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 440:	c299                	beqz	a3,446 <printint+0x16>
 442:	0805c863          	bltz	a1,4d2 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 446:	2581                	sext.w	a1,a1
  neg = 0;
 448:	4881                	li	a7,0
 44a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 44e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 450:	2601                	sext.w	a2,a2
 452:	00000517          	auipc	a0,0x0
 456:	7c650513          	addi	a0,a0,1990 # c18 <digits>
 45a:	883a                	mv	a6,a4
 45c:	2705                	addiw	a4,a4,1
 45e:	02c5f7bb          	remuw	a5,a1,a2
 462:	1782                	slli	a5,a5,0x20
 464:	9381                	srli	a5,a5,0x20
 466:	97aa                	add	a5,a5,a0
 468:	0007c783          	lbu	a5,0(a5)
 46c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 470:	0005879b          	sext.w	a5,a1
 474:	02c5d5bb          	divuw	a1,a1,a2
 478:	0685                	addi	a3,a3,1
 47a:	fec7f0e3          	bgeu	a5,a2,45a <printint+0x2a>
  if(neg)
 47e:	00088b63          	beqz	a7,494 <printint+0x64>
    buf[i++] = '-';
 482:	fd040793          	addi	a5,s0,-48
 486:	973e                	add	a4,a4,a5
 488:	02d00793          	li	a5,45
 48c:	fef70823          	sb	a5,-16(a4)
 490:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 494:	02e05863          	blez	a4,4c4 <printint+0x94>
 498:	fc040793          	addi	a5,s0,-64
 49c:	00e78933          	add	s2,a5,a4
 4a0:	fff78993          	addi	s3,a5,-1
 4a4:	99ba                	add	s3,s3,a4
 4a6:	377d                	addiw	a4,a4,-1
 4a8:	1702                	slli	a4,a4,0x20
 4aa:	9301                	srli	a4,a4,0x20
 4ac:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4b0:	fff94583          	lbu	a1,-1(s2)
 4b4:	8526                	mv	a0,s1
 4b6:	00000097          	auipc	ra,0x0
 4ba:	f58080e7          	jalr	-168(ra) # 40e <putc>
  while(--i >= 0)
 4be:	197d                	addi	s2,s2,-1
 4c0:	ff3918e3          	bne	s2,s3,4b0 <printint+0x80>
}
 4c4:	70e2                	ld	ra,56(sp)
 4c6:	7442                	ld	s0,48(sp)
 4c8:	74a2                	ld	s1,40(sp)
 4ca:	7902                	ld	s2,32(sp)
 4cc:	69e2                	ld	s3,24(sp)
 4ce:	6121                	addi	sp,sp,64
 4d0:	8082                	ret
    x = -xx;
 4d2:	40b005bb          	negw	a1,a1
    neg = 1;
 4d6:	4885                	li	a7,1
    x = -xx;
 4d8:	bf8d                	j	44a <printint+0x1a>

00000000000004da <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4da:	7119                	addi	sp,sp,-128
 4dc:	fc86                	sd	ra,120(sp)
 4de:	f8a2                	sd	s0,112(sp)
 4e0:	f4a6                	sd	s1,104(sp)
 4e2:	f0ca                	sd	s2,96(sp)
 4e4:	ecce                	sd	s3,88(sp)
 4e6:	e8d2                	sd	s4,80(sp)
 4e8:	e4d6                	sd	s5,72(sp)
 4ea:	e0da                	sd	s6,64(sp)
 4ec:	fc5e                	sd	s7,56(sp)
 4ee:	f862                	sd	s8,48(sp)
 4f0:	f466                	sd	s9,40(sp)
 4f2:	f06a                	sd	s10,32(sp)
 4f4:	ec6e                	sd	s11,24(sp)
 4f6:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4f8:	0005c903          	lbu	s2,0(a1)
 4fc:	18090f63          	beqz	s2,69a <vprintf+0x1c0>
 500:	8aaa                	mv	s5,a0
 502:	8b32                	mv	s6,a2
 504:	00158493          	addi	s1,a1,1
  state = 0;
 508:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 50a:	02500a13          	li	s4,37
      if(c == 'd'){
 50e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 512:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 516:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 51a:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 51e:	00000b97          	auipc	s7,0x0
 522:	6fab8b93          	addi	s7,s7,1786 # c18 <digits>
 526:	a839                	j	544 <vprintf+0x6a>
        putc(fd, c);
 528:	85ca                	mv	a1,s2
 52a:	8556                	mv	a0,s5
 52c:	00000097          	auipc	ra,0x0
 530:	ee2080e7          	jalr	-286(ra) # 40e <putc>
 534:	a019                	j	53a <vprintf+0x60>
    } else if(state == '%'){
 536:	01498f63          	beq	s3,s4,554 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 53a:	0485                	addi	s1,s1,1
 53c:	fff4c903          	lbu	s2,-1(s1)
 540:	14090d63          	beqz	s2,69a <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 544:	0009079b          	sext.w	a5,s2
    if(state == 0){
 548:	fe0997e3          	bnez	s3,536 <vprintf+0x5c>
      if(c == '%'){
 54c:	fd479ee3          	bne	a5,s4,528 <vprintf+0x4e>
        state = '%';
 550:	89be                	mv	s3,a5
 552:	b7e5                	j	53a <vprintf+0x60>
      if(c == 'd'){
 554:	05878063          	beq	a5,s8,594 <vprintf+0xba>
      } else if(c == 'l') {
 558:	05978c63          	beq	a5,s9,5b0 <vprintf+0xd6>
      } else if(c == 'x') {
 55c:	07a78863          	beq	a5,s10,5cc <vprintf+0xf2>
      } else if(c == 'p') {
 560:	09b78463          	beq	a5,s11,5e8 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 564:	07300713          	li	a4,115
 568:	0ce78663          	beq	a5,a4,634 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 56c:	06300713          	li	a4,99
 570:	0ee78e63          	beq	a5,a4,66c <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 574:	11478863          	beq	a5,s4,684 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 578:	85d2                	mv	a1,s4
 57a:	8556                	mv	a0,s5
 57c:	00000097          	auipc	ra,0x0
 580:	e92080e7          	jalr	-366(ra) # 40e <putc>
        putc(fd, c);
 584:	85ca                	mv	a1,s2
 586:	8556                	mv	a0,s5
 588:	00000097          	auipc	ra,0x0
 58c:	e86080e7          	jalr	-378(ra) # 40e <putc>
      }
      state = 0;
 590:	4981                	li	s3,0
 592:	b765                	j	53a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 594:	008b0913          	addi	s2,s6,8
 598:	4685                	li	a3,1
 59a:	4629                	li	a2,10
 59c:	000b2583          	lw	a1,0(s6)
 5a0:	8556                	mv	a0,s5
 5a2:	00000097          	auipc	ra,0x0
 5a6:	e8e080e7          	jalr	-370(ra) # 430 <printint>
 5aa:	8b4a                	mv	s6,s2
      state = 0;
 5ac:	4981                	li	s3,0
 5ae:	b771                	j	53a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b0:	008b0913          	addi	s2,s6,8
 5b4:	4681                	li	a3,0
 5b6:	4629                	li	a2,10
 5b8:	000b2583          	lw	a1,0(s6)
 5bc:	8556                	mv	a0,s5
 5be:	00000097          	auipc	ra,0x0
 5c2:	e72080e7          	jalr	-398(ra) # 430 <printint>
 5c6:	8b4a                	mv	s6,s2
      state = 0;
 5c8:	4981                	li	s3,0
 5ca:	bf85                	j	53a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5cc:	008b0913          	addi	s2,s6,8
 5d0:	4681                	li	a3,0
 5d2:	4641                	li	a2,16
 5d4:	000b2583          	lw	a1,0(s6)
 5d8:	8556                	mv	a0,s5
 5da:	00000097          	auipc	ra,0x0
 5de:	e56080e7          	jalr	-426(ra) # 430 <printint>
 5e2:	8b4a                	mv	s6,s2
      state = 0;
 5e4:	4981                	li	s3,0
 5e6:	bf91                	j	53a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5e8:	008b0793          	addi	a5,s6,8
 5ec:	f8f43423          	sd	a5,-120(s0)
 5f0:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5f4:	03000593          	li	a1,48
 5f8:	8556                	mv	a0,s5
 5fa:	00000097          	auipc	ra,0x0
 5fe:	e14080e7          	jalr	-492(ra) # 40e <putc>
  putc(fd, 'x');
 602:	85ea                	mv	a1,s10
 604:	8556                	mv	a0,s5
 606:	00000097          	auipc	ra,0x0
 60a:	e08080e7          	jalr	-504(ra) # 40e <putc>
 60e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 610:	03c9d793          	srli	a5,s3,0x3c
 614:	97de                	add	a5,a5,s7
 616:	0007c583          	lbu	a1,0(a5)
 61a:	8556                	mv	a0,s5
 61c:	00000097          	auipc	ra,0x0
 620:	df2080e7          	jalr	-526(ra) # 40e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 624:	0992                	slli	s3,s3,0x4
 626:	397d                	addiw	s2,s2,-1
 628:	fe0914e3          	bnez	s2,610 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 62c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 630:	4981                	li	s3,0
 632:	b721                	j	53a <vprintf+0x60>
        s = va_arg(ap, char*);
 634:	008b0993          	addi	s3,s6,8
 638:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 63c:	02090163          	beqz	s2,65e <vprintf+0x184>
        while(*s != 0){
 640:	00094583          	lbu	a1,0(s2)
 644:	c9a1                	beqz	a1,694 <vprintf+0x1ba>
          putc(fd, *s);
 646:	8556                	mv	a0,s5
 648:	00000097          	auipc	ra,0x0
 64c:	dc6080e7          	jalr	-570(ra) # 40e <putc>
          s++;
 650:	0905                	addi	s2,s2,1
        while(*s != 0){
 652:	00094583          	lbu	a1,0(s2)
 656:	f9e5                	bnez	a1,646 <vprintf+0x16c>
        s = va_arg(ap, char*);
 658:	8b4e                	mv	s6,s3
      state = 0;
 65a:	4981                	li	s3,0
 65c:	bdf9                	j	53a <vprintf+0x60>
          s = "(null)";
 65e:	00000917          	auipc	s2,0x0
 662:	5b290913          	addi	s2,s2,1458 # c10 <strstr+0xb6>
        while(*s != 0){
 666:	02800593          	li	a1,40
 66a:	bff1                	j	646 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 66c:	008b0913          	addi	s2,s6,8
 670:	000b4583          	lbu	a1,0(s6)
 674:	8556                	mv	a0,s5
 676:	00000097          	auipc	ra,0x0
 67a:	d98080e7          	jalr	-616(ra) # 40e <putc>
 67e:	8b4a                	mv	s6,s2
      state = 0;
 680:	4981                	li	s3,0
 682:	bd65                	j	53a <vprintf+0x60>
        putc(fd, c);
 684:	85d2                	mv	a1,s4
 686:	8556                	mv	a0,s5
 688:	00000097          	auipc	ra,0x0
 68c:	d86080e7          	jalr	-634(ra) # 40e <putc>
      state = 0;
 690:	4981                	li	s3,0
 692:	b565                	j	53a <vprintf+0x60>
        s = va_arg(ap, char*);
 694:	8b4e                	mv	s6,s3
      state = 0;
 696:	4981                	li	s3,0
 698:	b54d                	j	53a <vprintf+0x60>
    }
  }
}
 69a:	70e6                	ld	ra,120(sp)
 69c:	7446                	ld	s0,112(sp)
 69e:	74a6                	ld	s1,104(sp)
 6a0:	7906                	ld	s2,96(sp)
 6a2:	69e6                	ld	s3,88(sp)
 6a4:	6a46                	ld	s4,80(sp)
 6a6:	6aa6                	ld	s5,72(sp)
 6a8:	6b06                	ld	s6,64(sp)
 6aa:	7be2                	ld	s7,56(sp)
 6ac:	7c42                	ld	s8,48(sp)
 6ae:	7ca2                	ld	s9,40(sp)
 6b0:	7d02                	ld	s10,32(sp)
 6b2:	6de2                	ld	s11,24(sp)
 6b4:	6109                	addi	sp,sp,128
 6b6:	8082                	ret

00000000000006b8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6b8:	715d                	addi	sp,sp,-80
 6ba:	ec06                	sd	ra,24(sp)
 6bc:	e822                	sd	s0,16(sp)
 6be:	1000                	addi	s0,sp,32
 6c0:	e010                	sd	a2,0(s0)
 6c2:	e414                	sd	a3,8(s0)
 6c4:	e818                	sd	a4,16(s0)
 6c6:	ec1c                	sd	a5,24(s0)
 6c8:	03043023          	sd	a6,32(s0)
 6cc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6d0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6d4:	8622                	mv	a2,s0
 6d6:	00000097          	auipc	ra,0x0
 6da:	e04080e7          	jalr	-508(ra) # 4da <vprintf>
}
 6de:	60e2                	ld	ra,24(sp)
 6e0:	6442                	ld	s0,16(sp)
 6e2:	6161                	addi	sp,sp,80
 6e4:	8082                	ret

00000000000006e6 <printf>:

void
printf(const char *fmt, ...)
{
 6e6:	711d                	addi	sp,sp,-96
 6e8:	ec06                	sd	ra,24(sp)
 6ea:	e822                	sd	s0,16(sp)
 6ec:	1000                	addi	s0,sp,32
 6ee:	e40c                	sd	a1,8(s0)
 6f0:	e810                	sd	a2,16(s0)
 6f2:	ec14                	sd	a3,24(s0)
 6f4:	f018                	sd	a4,32(s0)
 6f6:	f41c                	sd	a5,40(s0)
 6f8:	03043823          	sd	a6,48(s0)
 6fc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 700:	00840613          	addi	a2,s0,8
 704:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 708:	85aa                	mv	a1,a0
 70a:	4505                	li	a0,1
 70c:	00000097          	auipc	ra,0x0
 710:	dce080e7          	jalr	-562(ra) # 4da <vprintf>
}
 714:	60e2                	ld	ra,24(sp)
 716:	6442                	ld	s0,16(sp)
 718:	6125                	addi	sp,sp,96
 71a:	8082                	ret

000000000000071c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 71c:	1141                	addi	sp,sp,-16
 71e:	e422                	sd	s0,8(sp)
 720:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 722:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 726:	00000797          	auipc	a5,0x0
 72a:	5aa7b783          	ld	a5,1450(a5) # cd0 <freep>
 72e:	a805                	j	75e <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 730:	4618                	lw	a4,8(a2)
 732:	9db9                	addw	a1,a1,a4
 734:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 738:	6398                	ld	a4,0(a5)
 73a:	6318                	ld	a4,0(a4)
 73c:	fee53823          	sd	a4,-16(a0)
 740:	a091                	j	784 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 742:	ff852703          	lw	a4,-8(a0)
 746:	9e39                	addw	a2,a2,a4
 748:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 74a:	ff053703          	ld	a4,-16(a0)
 74e:	e398                	sd	a4,0(a5)
 750:	a099                	j	796 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 752:	6398                	ld	a4,0(a5)
 754:	00e7e463          	bltu	a5,a4,75c <free+0x40>
 758:	00e6ea63          	bltu	a3,a4,76c <free+0x50>
{
 75c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75e:	fed7fae3          	bgeu	a5,a3,752 <free+0x36>
 762:	6398                	ld	a4,0(a5)
 764:	00e6e463          	bltu	a3,a4,76c <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 768:	fee7eae3          	bltu	a5,a4,75c <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 76c:	ff852583          	lw	a1,-8(a0)
 770:	6390                	ld	a2,0(a5)
 772:	02059713          	slli	a4,a1,0x20
 776:	9301                	srli	a4,a4,0x20
 778:	0712                	slli	a4,a4,0x4
 77a:	9736                	add	a4,a4,a3
 77c:	fae60ae3          	beq	a2,a4,730 <free+0x14>
    bp->s.ptr = p->s.ptr;
 780:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 784:	4790                	lw	a2,8(a5)
 786:	02061713          	slli	a4,a2,0x20
 78a:	9301                	srli	a4,a4,0x20
 78c:	0712                	slli	a4,a4,0x4
 78e:	973e                	add	a4,a4,a5
 790:	fae689e3          	beq	a3,a4,742 <free+0x26>
  } else
    p->s.ptr = bp;
 794:	e394                	sd	a3,0(a5)
  freep = p;
 796:	00000717          	auipc	a4,0x0
 79a:	52f73d23          	sd	a5,1338(a4) # cd0 <freep>
}
 79e:	6422                	ld	s0,8(sp)
 7a0:	0141                	addi	sp,sp,16
 7a2:	8082                	ret

00000000000007a4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7a4:	7139                	addi	sp,sp,-64
 7a6:	fc06                	sd	ra,56(sp)
 7a8:	f822                	sd	s0,48(sp)
 7aa:	f426                	sd	s1,40(sp)
 7ac:	f04a                	sd	s2,32(sp)
 7ae:	ec4e                	sd	s3,24(sp)
 7b0:	e852                	sd	s4,16(sp)
 7b2:	e456                	sd	s5,8(sp)
 7b4:	e05a                	sd	s6,0(sp)
 7b6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b8:	02051493          	slli	s1,a0,0x20
 7bc:	9081                	srli	s1,s1,0x20
 7be:	04bd                	addi	s1,s1,15
 7c0:	8091                	srli	s1,s1,0x4
 7c2:	0014899b          	addiw	s3,s1,1
 7c6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7c8:	00000517          	auipc	a0,0x0
 7cc:	50853503          	ld	a0,1288(a0) # cd0 <freep>
 7d0:	c515                	beqz	a0,7fc <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7d4:	4798                	lw	a4,8(a5)
 7d6:	02977f63          	bgeu	a4,s1,814 <malloc+0x70>
 7da:	8a4e                	mv	s4,s3
 7dc:	0009871b          	sext.w	a4,s3
 7e0:	6685                	lui	a3,0x1
 7e2:	00d77363          	bgeu	a4,a3,7e8 <malloc+0x44>
 7e6:	6a05                	lui	s4,0x1
 7e8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7ec:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7f0:	00000917          	auipc	s2,0x0
 7f4:	4e090913          	addi	s2,s2,1248 # cd0 <freep>
  if(p == (char*)-1)
 7f8:	5afd                	li	s5,-1
 7fa:	a88d                	j	86c <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 7fc:	00000797          	auipc	a5,0x0
 800:	4dc78793          	addi	a5,a5,1244 # cd8 <base>
 804:	00000717          	auipc	a4,0x0
 808:	4cf73623          	sd	a5,1228(a4) # cd0 <freep>
 80c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 80e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 812:	b7e1                	j	7da <malloc+0x36>
      if(p->s.size == nunits)
 814:	02e48b63          	beq	s1,a4,84a <malloc+0xa6>
        p->s.size -= nunits;
 818:	4137073b          	subw	a4,a4,s3
 81c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 81e:	1702                	slli	a4,a4,0x20
 820:	9301                	srli	a4,a4,0x20
 822:	0712                	slli	a4,a4,0x4
 824:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 826:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 82a:	00000717          	auipc	a4,0x0
 82e:	4aa73323          	sd	a0,1190(a4) # cd0 <freep>
      return (void*)(p + 1);
 832:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 836:	70e2                	ld	ra,56(sp)
 838:	7442                	ld	s0,48(sp)
 83a:	74a2                	ld	s1,40(sp)
 83c:	7902                	ld	s2,32(sp)
 83e:	69e2                	ld	s3,24(sp)
 840:	6a42                	ld	s4,16(sp)
 842:	6aa2                	ld	s5,8(sp)
 844:	6b02                	ld	s6,0(sp)
 846:	6121                	addi	sp,sp,64
 848:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 84a:	6398                	ld	a4,0(a5)
 84c:	e118                	sd	a4,0(a0)
 84e:	bff1                	j	82a <malloc+0x86>
  hp->s.size = nu;
 850:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 854:	0541                	addi	a0,a0,16
 856:	00000097          	auipc	ra,0x0
 85a:	ec6080e7          	jalr	-314(ra) # 71c <free>
  return freep;
 85e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 862:	d971                	beqz	a0,836 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 864:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 866:	4798                	lw	a4,8(a5)
 868:	fa9776e3          	bgeu	a4,s1,814 <malloc+0x70>
    if(p == freep)
 86c:	00093703          	ld	a4,0(s2)
 870:	853e                	mv	a0,a5
 872:	fef719e3          	bne	a4,a5,864 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 876:	8552                	mv	a0,s4
 878:	00000097          	auipc	ra,0x0
 87c:	b66080e7          	jalr	-1178(ra) # 3de <sbrk>
  if(p == (char*)-1)
 880:	fd5518e3          	bne	a0,s5,850 <malloc+0xac>
        return 0;
 884:	4501                	li	a0,0
 886:	bf45                	j	836 <malloc+0x92>

0000000000000888 <Pipe>:
#include "kernel/stat.h"
#include "user.h"
#include "wrapper.h"
int strncmp(const char*s, const char*pat,int n);

int Pipe(int *p) {
 888:	1101                	addi	sp,sp,-32
 88a:	ec06                	sd	ra,24(sp)
 88c:	e822                	sd	s0,16(sp)
 88e:	e426                	sd	s1,8(sp)
 890:	1000                	addi	s0,sp,32
  i32 res = pipe(p);
 892:	00000097          	auipc	ra,0x0
 896:	ad4080e7          	jalr	-1324(ra) # 366 <pipe>
 89a:	84aa                	mv	s1,a0
  if (res < 0) {
 89c:	00054863          	bltz	a0,8ac <Pipe+0x24>
    fprintf(2, "pipe creation error");
  }
  return res;
}
 8a0:	8526                	mv	a0,s1
 8a2:	60e2                	ld	ra,24(sp)
 8a4:	6442                	ld	s0,16(sp)
 8a6:	64a2                	ld	s1,8(sp)
 8a8:	6105                	addi	sp,sp,32
 8aa:	8082                	ret
    fprintf(2, "pipe creation error");
 8ac:	00000597          	auipc	a1,0x0
 8b0:	38458593          	addi	a1,a1,900 # c30 <digits+0x18>
 8b4:	4509                	li	a0,2
 8b6:	00000097          	auipc	ra,0x0
 8ba:	e02080e7          	jalr	-510(ra) # 6b8 <fprintf>
 8be:	b7cd                	j	8a0 <Pipe+0x18>

00000000000008c0 <Write>:

int Write(int fd, void *buf, int count){
 8c0:	1141                	addi	sp,sp,-16
 8c2:	e406                	sd	ra,8(sp)
 8c4:	e022                	sd	s0,0(sp)
 8c6:	0800                	addi	s0,sp,16
  i32 res = write(fd, buf, count);
 8c8:	00000097          	auipc	ra,0x0
 8cc:	aae080e7          	jalr	-1362(ra) # 376 <write>
  if (res < 0) {
 8d0:	00054663          	bltz	a0,8dc <Write+0x1c>
    fprintf(2, "write error");
    exit(0);
  }
  return res;
}
 8d4:	60a2                	ld	ra,8(sp)
 8d6:	6402                	ld	s0,0(sp)
 8d8:	0141                	addi	sp,sp,16
 8da:	8082                	ret
    fprintf(2, "write error");
 8dc:	00000597          	auipc	a1,0x0
 8e0:	36c58593          	addi	a1,a1,876 # c48 <digits+0x30>
 8e4:	4509                	li	a0,2
 8e6:	00000097          	auipc	ra,0x0
 8ea:	dd2080e7          	jalr	-558(ra) # 6b8 <fprintf>
    exit(0);
 8ee:	4501                	li	a0,0
 8f0:	00000097          	auipc	ra,0x0
 8f4:	a66080e7          	jalr	-1434(ra) # 356 <exit>

00000000000008f8 <Read>:



int Read(int fd,  void*buf, int count){
 8f8:	1141                	addi	sp,sp,-16
 8fa:	e406                	sd	ra,8(sp)
 8fc:	e022                	sd	s0,0(sp)
 8fe:	0800                	addi	s0,sp,16
  i32 res = read(fd, buf, count);
 900:	00000097          	auipc	ra,0x0
 904:	a6e080e7          	jalr	-1426(ra) # 36e <read>
  if (res < 0) {
 908:	00054663          	bltz	a0,914 <Read+0x1c>
    fprintf(2, "read error");
    exit(0);
  }
  return res;
}
 90c:	60a2                	ld	ra,8(sp)
 90e:	6402                	ld	s0,0(sp)
 910:	0141                	addi	sp,sp,16
 912:	8082                	ret
    fprintf(2, "read error");
 914:	00000597          	auipc	a1,0x0
 918:	34458593          	addi	a1,a1,836 # c58 <digits+0x40>
 91c:	4509                	li	a0,2
 91e:	00000097          	auipc	ra,0x0
 922:	d9a080e7          	jalr	-614(ra) # 6b8 <fprintf>
    exit(0);
 926:	4501                	li	a0,0
 928:	00000097          	auipc	ra,0x0
 92c:	a2e080e7          	jalr	-1490(ra) # 356 <exit>

0000000000000930 <Open>:


int Open(const char* path, int flag){
 930:	1141                	addi	sp,sp,-16
 932:	e406                	sd	ra,8(sp)
 934:	e022                	sd	s0,0(sp)
 936:	0800                	addi	s0,sp,16
  i32 res = open(path, flag);
 938:	00000097          	auipc	ra,0x0
 93c:	a5e080e7          	jalr	-1442(ra) # 396 <open>
  if (res < 0) {
 940:	00054663          	bltz	a0,94c <Open+0x1c>
    fprintf(2, "open error");
    exit(0);
  }
  return res;
}
 944:	60a2                	ld	ra,8(sp)
 946:	6402                	ld	s0,0(sp)
 948:	0141                	addi	sp,sp,16
 94a:	8082                	ret
    fprintf(2, "open error");
 94c:	00000597          	auipc	a1,0x0
 950:	31c58593          	addi	a1,a1,796 # c68 <digits+0x50>
 954:	4509                	li	a0,2
 956:	00000097          	auipc	ra,0x0
 95a:	d62080e7          	jalr	-670(ra) # 6b8 <fprintf>
    exit(0);
 95e:	4501                	li	a0,0
 960:	00000097          	auipc	ra,0x0
 964:	9f6080e7          	jalr	-1546(ra) # 356 <exit>

0000000000000968 <Fstat>:


int Fstat(int fd, stat_t *st){
 968:	1141                	addi	sp,sp,-16
 96a:	e406                	sd	ra,8(sp)
 96c:	e022                	sd	s0,0(sp)
 96e:	0800                	addi	s0,sp,16
  i32 res = fstat(fd, st);
 970:	00000097          	auipc	ra,0x0
 974:	a3e080e7          	jalr	-1474(ra) # 3ae <fstat>
  if (res < 0) {
 978:	00054663          	bltz	a0,984 <Fstat+0x1c>
    fprintf(2, "get file stat error");
    exit(0);
  }
  return res;
}
 97c:	60a2                	ld	ra,8(sp)
 97e:	6402                	ld	s0,0(sp)
 980:	0141                	addi	sp,sp,16
 982:	8082                	ret
    fprintf(2, "get file stat error");
 984:	00000597          	auipc	a1,0x0
 988:	2f458593          	addi	a1,a1,756 # c78 <digits+0x60>
 98c:	4509                	li	a0,2
 98e:	00000097          	auipc	ra,0x0
 992:	d2a080e7          	jalr	-726(ra) # 6b8 <fprintf>
    exit(0);
 996:	4501                	li	a0,0
 998:	00000097          	auipc	ra,0x0
 99c:	9be080e7          	jalr	-1602(ra) # 356 <exit>

00000000000009a0 <Dup>:



int Dup(int fd){
 9a0:	1141                	addi	sp,sp,-16
 9a2:	e406                	sd	ra,8(sp)
 9a4:	e022                	sd	s0,0(sp)
 9a6:	0800                	addi	s0,sp,16
  i32 res = dup(fd);
 9a8:	00000097          	auipc	ra,0x0
 9ac:	a26080e7          	jalr	-1498(ra) # 3ce <dup>
  if (res < 0) {
 9b0:	00054663          	bltz	a0,9bc <Dup+0x1c>
    fprintf(2, "dup error");
    exit(0);
  }
  return res;

}
 9b4:	60a2                	ld	ra,8(sp)
 9b6:	6402                	ld	s0,0(sp)
 9b8:	0141                	addi	sp,sp,16
 9ba:	8082                	ret
    fprintf(2, "dup error");
 9bc:	00000597          	auipc	a1,0x0
 9c0:	2d458593          	addi	a1,a1,724 # c90 <digits+0x78>
 9c4:	4509                	li	a0,2
 9c6:	00000097          	auipc	ra,0x0
 9ca:	cf2080e7          	jalr	-782(ra) # 6b8 <fprintf>
    exit(0);
 9ce:	4501                	li	a0,0
 9d0:	00000097          	auipc	ra,0x0
 9d4:	986080e7          	jalr	-1658(ra) # 356 <exit>

00000000000009d8 <Close>:

int Close(int fd){
 9d8:	1141                	addi	sp,sp,-16
 9da:	e406                	sd	ra,8(sp)
 9dc:	e022                	sd	s0,0(sp)
 9de:	0800                	addi	s0,sp,16
  i32 res = close(fd);
 9e0:	00000097          	auipc	ra,0x0
 9e4:	99e080e7          	jalr	-1634(ra) # 37e <close>
  if (res < 0) {
 9e8:	00054663          	bltz	a0,9f4 <Close+0x1c>
    fprintf(2, "file close error~");
    exit(0);
  }
  return res;
}
 9ec:	60a2                	ld	ra,8(sp)
 9ee:	6402                	ld	s0,0(sp)
 9f0:	0141                	addi	sp,sp,16
 9f2:	8082                	ret
    fprintf(2, "file close error~");
 9f4:	00000597          	auipc	a1,0x0
 9f8:	2ac58593          	addi	a1,a1,684 # ca0 <digits+0x88>
 9fc:	4509                	li	a0,2
 9fe:	00000097          	auipc	ra,0x0
 a02:	cba080e7          	jalr	-838(ra) # 6b8 <fprintf>
    exit(0);
 a06:	4501                	li	a0,0
 a08:	00000097          	auipc	ra,0x0
 a0c:	94e080e7          	jalr	-1714(ra) # 356 <exit>

0000000000000a10 <Dup2>:

int Dup2(int old_fd,int new_fd){
 a10:	1101                	addi	sp,sp,-32
 a12:	ec06                	sd	ra,24(sp)
 a14:	e822                	sd	s0,16(sp)
 a16:	e426                	sd	s1,8(sp)
 a18:	1000                	addi	s0,sp,32
 a1a:	84aa                	mv	s1,a0
  Close(new_fd);
 a1c:	852e                	mv	a0,a1
 a1e:	00000097          	auipc	ra,0x0
 a22:	fba080e7          	jalr	-70(ra) # 9d8 <Close>
  i32 res = Dup(old_fd);
 a26:	8526                	mv	a0,s1
 a28:	00000097          	auipc	ra,0x0
 a2c:	f78080e7          	jalr	-136(ra) # 9a0 <Dup>
  if (res < 0) {
 a30:	00054763          	bltz	a0,a3e <Dup2+0x2e>
    fprintf(2, "dup error");
    exit(0);
  }
  return res;
}
 a34:	60e2                	ld	ra,24(sp)
 a36:	6442                	ld	s0,16(sp)
 a38:	64a2                	ld	s1,8(sp)
 a3a:	6105                	addi	sp,sp,32
 a3c:	8082                	ret
    fprintf(2, "dup error");
 a3e:	00000597          	auipc	a1,0x0
 a42:	25258593          	addi	a1,a1,594 # c90 <digits+0x78>
 a46:	4509                	li	a0,2
 a48:	00000097          	auipc	ra,0x0
 a4c:	c70080e7          	jalr	-912(ra) # 6b8 <fprintf>
    exit(0);
 a50:	4501                	li	a0,0
 a52:	00000097          	auipc	ra,0x0
 a56:	904080e7          	jalr	-1788(ra) # 356 <exit>

0000000000000a5a <Stat>:

int Stat(const char*link,stat_t *st){
 a5a:	1101                	addi	sp,sp,-32
 a5c:	ec06                	sd	ra,24(sp)
 a5e:	e822                	sd	s0,16(sp)
 a60:	e426                	sd	s1,8(sp)
 a62:	1000                	addi	s0,sp,32
 a64:	84aa                	mv	s1,a0
  i32 res = stat(link,st);
 a66:	fffff097          	auipc	ra,0xfffff
 a6a:	7ae080e7          	jalr	1966(ra) # 214 <stat>
  if (res < 0) {
 a6e:	00054763          	bltz	a0,a7c <Stat+0x22>
    fprintf(2, "file %s stat error",link);
    exit(0);
  }
  return res;
}
 a72:	60e2                	ld	ra,24(sp)
 a74:	6442                	ld	s0,16(sp)
 a76:	64a2                	ld	s1,8(sp)
 a78:	6105                	addi	sp,sp,32
 a7a:	8082                	ret
    fprintf(2, "file %s stat error",link);
 a7c:	8626                	mv	a2,s1
 a7e:	00000597          	auipc	a1,0x0
 a82:	23a58593          	addi	a1,a1,570 # cb8 <digits+0xa0>
 a86:	4509                	li	a0,2
 a88:	00000097          	auipc	ra,0x0
 a8c:	c30080e7          	jalr	-976(ra) # 6b8 <fprintf>
    exit(0);
 a90:	4501                	li	a0,0
 a92:	00000097          	auipc	ra,0x0
 a96:	8c4080e7          	jalr	-1852(ra) # 356 <exit>

0000000000000a9a <strncmp>:
   return -1;
}



int strncmp(const char*s, const char*pat,int n){
 a9a:	bc010113          	addi	sp,sp,-1088
 a9e:	42113c23          	sd	ra,1080(sp)
 aa2:	42813823          	sd	s0,1072(sp)
 aa6:	42913423          	sd	s1,1064(sp)
 aaa:	43213023          	sd	s2,1056(sp)
 aae:	41313c23          	sd	s3,1048(sp)
 ab2:	41413823          	sd	s4,1040(sp)
 ab6:	41513423          	sd	s5,1032(sp)
 aba:	44010413          	addi	s0,sp,1088
 abe:	89aa                	mv	s3,a0
 ac0:	892e                	mv	s2,a1
 ac2:	84b2                	mv	s1,a2
  char buf1[512],buf2[512];
  int n1 = MIN(n,strlen(s));
 ac4:	fffff097          	auipc	ra,0xfffff
 ac8:	66c080e7          	jalr	1644(ra) # 130 <strlen>
 acc:	2501                	sext.w	a0,a0
 ace:	00048a1b          	sext.w	s4,s1
 ad2:	8aa6                	mv	s5,s1
 ad4:	06aa7363          	bgeu	s4,a0,b3a <strncmp+0xa0>
  int n2 = MIN(n,strlen(pat));
 ad8:	854a                	mv	a0,s2
 ada:	fffff097          	auipc	ra,0xfffff
 ade:	656080e7          	jalr	1622(ra) # 130 <strlen>
 ae2:	2501                	sext.w	a0,a0
 ae4:	06aa7363          	bgeu	s4,a0,b4a <strncmp+0xb0>
  memmove(buf1,s,n1);
 ae8:	8656                	mv	a2,s5
 aea:	85ce                	mv	a1,s3
 aec:	dc040513          	addi	a0,s0,-576
 af0:	fffff097          	auipc	ra,0xfffff
 af4:	7b4080e7          	jalr	1972(ra) # 2a4 <memmove>
  memmove(buf2,pat,n2);
 af8:	8626                	mv	a2,s1
 afa:	85ca                	mv	a1,s2
 afc:	bc040513          	addi	a0,s0,-1088
 b00:	fffff097          	auipc	ra,0xfffff
 b04:	7a4080e7          	jalr	1956(ra) # 2a4 <memmove>
  return strcmp(buf1,buf2);
 b08:	bc040593          	addi	a1,s0,-1088
 b0c:	dc040513          	addi	a0,s0,-576
 b10:	fffff097          	auipc	ra,0xfffff
 b14:	5f4080e7          	jalr	1524(ra) # 104 <strcmp>
}
 b18:	43813083          	ld	ra,1080(sp)
 b1c:	43013403          	ld	s0,1072(sp)
 b20:	42813483          	ld	s1,1064(sp)
 b24:	42013903          	ld	s2,1056(sp)
 b28:	41813983          	ld	s3,1048(sp)
 b2c:	41013a03          	ld	s4,1040(sp)
 b30:	40813a83          	ld	s5,1032(sp)
 b34:	44010113          	addi	sp,sp,1088
 b38:	8082                	ret
  int n1 = MIN(n,strlen(s));
 b3a:	854e                	mv	a0,s3
 b3c:	fffff097          	auipc	ra,0xfffff
 b40:	5f4080e7          	jalr	1524(ra) # 130 <strlen>
 b44:	00050a9b          	sext.w	s5,a0
 b48:	bf41                	j	ad8 <strncmp+0x3e>
  int n2 = MIN(n,strlen(pat));
 b4a:	854a                	mv	a0,s2
 b4c:	fffff097          	auipc	ra,0xfffff
 b50:	5e4080e7          	jalr	1508(ra) # 130 <strlen>
 b54:	0005049b          	sext.w	s1,a0
 b58:	bf41                	j	ae8 <strncmp+0x4e>

0000000000000b5a <strstr>:
   while (*s != 0){
 b5a:	00054783          	lbu	a5,0(a0)
 b5e:	cba1                	beqz	a5,bae <strstr+0x54>
int strstr(char *s,char *p){
 b60:	7179                	addi	sp,sp,-48
 b62:	f406                	sd	ra,40(sp)
 b64:	f022                	sd	s0,32(sp)
 b66:	ec26                	sd	s1,24(sp)
 b68:	e84a                	sd	s2,16(sp)
 b6a:	e44e                	sd	s3,8(sp)
 b6c:	1800                	addi	s0,sp,48
 b6e:	89aa                	mv	s3,a0
 b70:	892e                	mv	s2,a1
   while (*s != 0){
 b72:	84aa                	mv	s1,a0
     if (!strncmp(s,p,strlen(p)))
 b74:	854a                	mv	a0,s2
 b76:	fffff097          	auipc	ra,0xfffff
 b7a:	5ba080e7          	jalr	1466(ra) # 130 <strlen>
 b7e:	0005061b          	sext.w	a2,a0
 b82:	85ca                	mv	a1,s2
 b84:	8526                	mv	a0,s1
 b86:	00000097          	auipc	ra,0x0
 b8a:	f14080e7          	jalr	-236(ra) # a9a <strncmp>
 b8e:	c519                	beqz	a0,b9c <strstr+0x42>
     s++;
 b90:	0485                	addi	s1,s1,1
   while (*s != 0){
 b92:	0004c783          	lbu	a5,0(s1)
 b96:	fff9                	bnez	a5,b74 <strstr+0x1a>
   return -1;
 b98:	557d                	li	a0,-1
 b9a:	a019                	j	ba0 <strstr+0x46>
      return s - ori;
 b9c:	4134853b          	subw	a0,s1,s3
}
 ba0:	70a2                	ld	ra,40(sp)
 ba2:	7402                	ld	s0,32(sp)
 ba4:	64e2                	ld	s1,24(sp)
 ba6:	6942                	ld	s2,16(sp)
 ba8:	69a2                	ld	s3,8(sp)
 baa:	6145                	addi	sp,sp,48
 bac:	8082                	ret
   return -1;
 bae:	557d                	li	a0,-1
}
 bb0:	8082                	ret
