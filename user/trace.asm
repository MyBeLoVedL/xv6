
user/_trace:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user.h"
#include "kernel/types.h"

int main(int argc, char** argv){
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84ae                	mv	s1,a1
    i32 mask = atoi(argv[1]);
   c:	6588                	ld	a0,8(a1)
   e:	00000097          	auipc	ra,0x0
  12:	1d4080e7          	jalr	468(ra) # 1e2 <atoi>
    if (trace(mask) < 0 ) {
  16:	00000097          	auipc	ra,0x0
  1a:	368080e7          	jalr	872(ra) # 37e <trace>
  1e:	02054463          	bltz	a0,46 <main+0x46>
        printf("trace error\n");
        exit(1);
    }
    if (fork() == 0){
  22:	00000097          	auipc	ra,0x0
  26:	2b4080e7          	jalr	692(ra) # 2d6 <fork>
  2a:	c91d                	beqz	a0,60 <main+0x60>
        exec(argv[2],argv + 2);
    }
    printf("trace end\n");
  2c:	00001517          	auipc	a0,0x1
  30:	b2450513          	addi	a0,a0,-1244 # b50 <strstr+0x6e>
  34:	00000097          	auipc	ra,0x0
  38:	63a080e7          	jalr	1594(ra) # 66e <printf>
    exit(0);
  3c:	4501                	li	a0,0
  3e:	00000097          	auipc	ra,0x0
  42:	2a0080e7          	jalr	672(ra) # 2de <exit>
        printf("trace error\n");
  46:	00001517          	auipc	a0,0x1
  4a:	afa50513          	addi	a0,a0,-1286 # b40 <strstr+0x5e>
  4e:	00000097          	auipc	ra,0x0
  52:	620080e7          	jalr	1568(ra) # 66e <printf>
        exit(1);
  56:	4505                	li	a0,1
  58:	00000097          	auipc	ra,0x0
  5c:	286080e7          	jalr	646(ra) # 2de <exit>
        exec(argv[2],argv + 2);
  60:	01048593          	addi	a1,s1,16
  64:	6888                	ld	a0,16(s1)
  66:	00000097          	auipc	ra,0x0
  6a:	2b0080e7          	jalr	688(ra) # 316 <exec>
  6e:	bf7d                	j	2c <main+0x2c>

0000000000000070 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  70:	1141                	addi	sp,sp,-16
  72:	e422                	sd	s0,8(sp)
  74:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  76:	87aa                	mv	a5,a0
  78:	0585                	addi	a1,a1,1
  7a:	0785                	addi	a5,a5,1
  7c:	fff5c703          	lbu	a4,-1(a1)
  80:	fee78fa3          	sb	a4,-1(a5)
  84:	fb75                	bnez	a4,78 <strcpy+0x8>
    ;
  return os;
}
  86:	6422                	ld	s0,8(sp)
  88:	0141                	addi	sp,sp,16
  8a:	8082                	ret

000000000000008c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8c:	1141                	addi	sp,sp,-16
  8e:	e422                	sd	s0,8(sp)
  90:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  92:	00054783          	lbu	a5,0(a0)
  96:	cb91                	beqz	a5,aa <strcmp+0x1e>
  98:	0005c703          	lbu	a4,0(a1)
  9c:	00f71763          	bne	a4,a5,aa <strcmp+0x1e>
    p++, q++;
  a0:	0505                	addi	a0,a0,1
  a2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  a4:	00054783          	lbu	a5,0(a0)
  a8:	fbe5                	bnez	a5,98 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  aa:	0005c503          	lbu	a0,0(a1)
}
  ae:	40a7853b          	subw	a0,a5,a0
  b2:	6422                	ld	s0,8(sp)
  b4:	0141                	addi	sp,sp,16
  b6:	8082                	ret

00000000000000b8 <strlen>:

uint
strlen(const char *s)
{
  b8:	1141                	addi	sp,sp,-16
  ba:	e422                	sd	s0,8(sp)
  bc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  be:	00054783          	lbu	a5,0(a0)
  c2:	cf91                	beqz	a5,de <strlen+0x26>
  c4:	0505                	addi	a0,a0,1
  c6:	87aa                	mv	a5,a0
  c8:	4685                	li	a3,1
  ca:	9e89                	subw	a3,a3,a0
  cc:	00f6853b          	addw	a0,a3,a5
  d0:	0785                	addi	a5,a5,1
  d2:	fff7c703          	lbu	a4,-1(a5)
  d6:	fb7d                	bnez	a4,cc <strlen+0x14>
    ;
  return n;
}
  d8:	6422                	ld	s0,8(sp)
  da:	0141                	addi	sp,sp,16
  dc:	8082                	ret
  for(n = 0; s[n]; n++)
  de:	4501                	li	a0,0
  e0:	bfe5                	j	d8 <strlen+0x20>

00000000000000e2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e2:	1141                	addi	sp,sp,-16
  e4:	e422                	sd	s0,8(sp)
  e6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  e8:	ca19                	beqz	a2,fe <memset+0x1c>
  ea:	87aa                	mv	a5,a0
  ec:	1602                	slli	a2,a2,0x20
  ee:	9201                	srli	a2,a2,0x20
  f0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  f4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  f8:	0785                	addi	a5,a5,1
  fa:	fee79de3          	bne	a5,a4,f4 <memset+0x12>
  }
  return dst;
}
  fe:	6422                	ld	s0,8(sp)
 100:	0141                	addi	sp,sp,16
 102:	8082                	ret

0000000000000104 <strchr>:

char*
strchr(const char *s, char c)
{
 104:	1141                	addi	sp,sp,-16
 106:	e422                	sd	s0,8(sp)
 108:	0800                	addi	s0,sp,16
  for(; *s; s++)
 10a:	00054783          	lbu	a5,0(a0)
 10e:	cb99                	beqz	a5,124 <strchr+0x20>
    if(*s == c)
 110:	00f58763          	beq	a1,a5,11e <strchr+0x1a>
  for(; *s; s++)
 114:	0505                	addi	a0,a0,1
 116:	00054783          	lbu	a5,0(a0)
 11a:	fbfd                	bnez	a5,110 <strchr+0xc>
      return (char*)s;
  return 0;
 11c:	4501                	li	a0,0
}
 11e:	6422                	ld	s0,8(sp)
 120:	0141                	addi	sp,sp,16
 122:	8082                	ret
  return 0;
 124:	4501                	li	a0,0
 126:	bfe5                	j	11e <strchr+0x1a>

0000000000000128 <gets>:

char*
gets(char *buf, int max)
{
 128:	711d                	addi	sp,sp,-96
 12a:	ec86                	sd	ra,88(sp)
 12c:	e8a2                	sd	s0,80(sp)
 12e:	e4a6                	sd	s1,72(sp)
 130:	e0ca                	sd	s2,64(sp)
 132:	fc4e                	sd	s3,56(sp)
 134:	f852                	sd	s4,48(sp)
 136:	f456                	sd	s5,40(sp)
 138:	f05a                	sd	s6,32(sp)
 13a:	ec5e                	sd	s7,24(sp)
 13c:	1080                	addi	s0,sp,96
 13e:	8baa                	mv	s7,a0
 140:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 142:	892a                	mv	s2,a0
 144:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 146:	4aa9                	li	s5,10
 148:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 14a:	89a6                	mv	s3,s1
 14c:	2485                	addiw	s1,s1,1
 14e:	0344d863          	bge	s1,s4,17e <gets+0x56>
    cc = read(0, &c, 1);
 152:	4605                	li	a2,1
 154:	faf40593          	addi	a1,s0,-81
 158:	4501                	li	a0,0
 15a:	00000097          	auipc	ra,0x0
 15e:	19c080e7          	jalr	412(ra) # 2f6 <read>
    if(cc < 1)
 162:	00a05e63          	blez	a0,17e <gets+0x56>
    buf[i++] = c;
 166:	faf44783          	lbu	a5,-81(s0)
 16a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 16e:	01578763          	beq	a5,s5,17c <gets+0x54>
 172:	0905                	addi	s2,s2,1
 174:	fd679be3          	bne	a5,s6,14a <gets+0x22>
  for(i=0; i+1 < max; ){
 178:	89a6                	mv	s3,s1
 17a:	a011                	j	17e <gets+0x56>
 17c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 17e:	99de                	add	s3,s3,s7
 180:	00098023          	sb	zero,0(s3)
  return buf;
}
 184:	855e                	mv	a0,s7
 186:	60e6                	ld	ra,88(sp)
 188:	6446                	ld	s0,80(sp)
 18a:	64a6                	ld	s1,72(sp)
 18c:	6906                	ld	s2,64(sp)
 18e:	79e2                	ld	s3,56(sp)
 190:	7a42                	ld	s4,48(sp)
 192:	7aa2                	ld	s5,40(sp)
 194:	7b02                	ld	s6,32(sp)
 196:	6be2                	ld	s7,24(sp)
 198:	6125                	addi	sp,sp,96
 19a:	8082                	ret

000000000000019c <stat>:

int
stat(const char *n, struct stat *st)
{
 19c:	1101                	addi	sp,sp,-32
 19e:	ec06                	sd	ra,24(sp)
 1a0:	e822                	sd	s0,16(sp)
 1a2:	e426                	sd	s1,8(sp)
 1a4:	e04a                	sd	s2,0(sp)
 1a6:	1000                	addi	s0,sp,32
 1a8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1aa:	4581                	li	a1,0
 1ac:	00000097          	auipc	ra,0x0
 1b0:	172080e7          	jalr	370(ra) # 31e <open>
  if(fd < 0)
 1b4:	02054563          	bltz	a0,1de <stat+0x42>
 1b8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1ba:	85ca                	mv	a1,s2
 1bc:	00000097          	auipc	ra,0x0
 1c0:	17a080e7          	jalr	378(ra) # 336 <fstat>
 1c4:	892a                	mv	s2,a0
  close(fd);
 1c6:	8526                	mv	a0,s1
 1c8:	00000097          	auipc	ra,0x0
 1cc:	13e080e7          	jalr	318(ra) # 306 <close>
  return r;
}
 1d0:	854a                	mv	a0,s2
 1d2:	60e2                	ld	ra,24(sp)
 1d4:	6442                	ld	s0,16(sp)
 1d6:	64a2                	ld	s1,8(sp)
 1d8:	6902                	ld	s2,0(sp)
 1da:	6105                	addi	sp,sp,32
 1dc:	8082                	ret
    return -1;
 1de:	597d                	li	s2,-1
 1e0:	bfc5                	j	1d0 <stat+0x34>

00000000000001e2 <atoi>:

int
atoi(const char *s)
{
 1e2:	1141                	addi	sp,sp,-16
 1e4:	e422                	sd	s0,8(sp)
 1e6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1e8:	00054603          	lbu	a2,0(a0)
 1ec:	fd06079b          	addiw	a5,a2,-48
 1f0:	0ff7f793          	andi	a5,a5,255
 1f4:	4725                	li	a4,9
 1f6:	02f76963          	bltu	a4,a5,228 <atoi+0x46>
 1fa:	86aa                	mv	a3,a0
  n = 0;
 1fc:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1fe:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 200:	0685                	addi	a3,a3,1
 202:	0025179b          	slliw	a5,a0,0x2
 206:	9fa9                	addw	a5,a5,a0
 208:	0017979b          	slliw	a5,a5,0x1
 20c:	9fb1                	addw	a5,a5,a2
 20e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 212:	0006c603          	lbu	a2,0(a3)
 216:	fd06071b          	addiw	a4,a2,-48
 21a:	0ff77713          	andi	a4,a4,255
 21e:	fee5f1e3          	bgeu	a1,a4,200 <atoi+0x1e>
  return n;
}
 222:	6422                	ld	s0,8(sp)
 224:	0141                	addi	sp,sp,16
 226:	8082                	ret
  n = 0;
 228:	4501                	li	a0,0
 22a:	bfe5                	j	222 <atoi+0x40>

000000000000022c <memmove>:

// #define memcpy memmove

void*
memmove(void *vdst, const void *vsrc, int n)
{
 22c:	1141                	addi	sp,sp,-16
 22e:	e422                	sd	s0,8(sp)
 230:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 232:	02b57463          	bgeu	a0,a1,25a <memmove+0x2e>
    while(n-- > 0)
 236:	00c05f63          	blez	a2,254 <memmove+0x28>
 23a:	1602                	slli	a2,a2,0x20
 23c:	9201                	srli	a2,a2,0x20
 23e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 242:	872a                	mv	a4,a0
      *dst++ = *src++;
 244:	0585                	addi	a1,a1,1
 246:	0705                	addi	a4,a4,1
 248:	fff5c683          	lbu	a3,-1(a1)
 24c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 250:	fee79ae3          	bne	a5,a4,244 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 254:	6422                	ld	s0,8(sp)
 256:	0141                	addi	sp,sp,16
 258:	8082                	ret
    dst += n;
 25a:	00c50733          	add	a4,a0,a2
    src += n;
 25e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 260:	fec05ae3          	blez	a2,254 <memmove+0x28>
 264:	fff6079b          	addiw	a5,a2,-1
 268:	1782                	slli	a5,a5,0x20
 26a:	9381                	srli	a5,a5,0x20
 26c:	fff7c793          	not	a5,a5
 270:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 272:	15fd                	addi	a1,a1,-1
 274:	177d                	addi	a4,a4,-1
 276:	0005c683          	lbu	a3,0(a1)
 27a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 27e:	fee79ae3          	bne	a5,a4,272 <memmove+0x46>
 282:	bfc9                	j	254 <memmove+0x28>

0000000000000284 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 284:	1141                	addi	sp,sp,-16
 286:	e422                	sd	s0,8(sp)
 288:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 28a:	ca05                	beqz	a2,2ba <memcmp+0x36>
 28c:	fff6069b          	addiw	a3,a2,-1
 290:	1682                	slli	a3,a3,0x20
 292:	9281                	srli	a3,a3,0x20
 294:	0685                	addi	a3,a3,1
 296:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 298:	00054783          	lbu	a5,0(a0)
 29c:	0005c703          	lbu	a4,0(a1)
 2a0:	00e79863          	bne	a5,a4,2b0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2a4:	0505                	addi	a0,a0,1
    p2++;
 2a6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2a8:	fed518e3          	bne	a0,a3,298 <memcmp+0x14>
  }
  return 0;
 2ac:	4501                	li	a0,0
 2ae:	a019                	j	2b4 <memcmp+0x30>
      return *p1 - *p2;
 2b0:	40e7853b          	subw	a0,a5,a4
}
 2b4:	6422                	ld	s0,8(sp)
 2b6:	0141                	addi	sp,sp,16
 2b8:	8082                	ret
  return 0;
 2ba:	4501                	li	a0,0
 2bc:	bfe5                	j	2b4 <memcmp+0x30>

00000000000002be <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2be:	1141                	addi	sp,sp,-16
 2c0:	e406                	sd	ra,8(sp)
 2c2:	e022                	sd	s0,0(sp)
 2c4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2c6:	00000097          	auipc	ra,0x0
 2ca:	f66080e7          	jalr	-154(ra) # 22c <memmove>
}
 2ce:	60a2                	ld	ra,8(sp)
 2d0:	6402                	ld	s0,0(sp)
 2d2:	0141                	addi	sp,sp,16
 2d4:	8082                	ret

00000000000002d6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2d6:	4885                	li	a7,1
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <exit>:
.global exit
exit:
 li a7, SYS_exit
 2de:	4889                	li	a7,2
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2e6:	488d                	li	a7,3
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2ee:	4891                	li	a7,4
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <read>:
.global read
read:
 li a7, SYS_read
 2f6:	4895                	li	a7,5
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <write>:
.global write
write:
 li a7, SYS_write
 2fe:	48c1                	li	a7,16
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <close>:
.global close
close:
 li a7, SYS_close
 306:	48d5                	li	a7,21
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <kill>:
.global kill
kill:
 li a7, SYS_kill
 30e:	4899                	li	a7,6
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <exec>:
.global exec
exec:
 li a7, SYS_exec
 316:	489d                	li	a7,7
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <open>:
.global open
open:
 li a7, SYS_open
 31e:	48bd                	li	a7,15
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 326:	48c5                	li	a7,17
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 32e:	48c9                	li	a7,18
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 336:	48a1                	li	a7,8
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <link>:
.global link
link:
 li a7, SYS_link
 33e:	48cd                	li	a7,19
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 346:	48d1                	li	a7,20
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 34e:	48a5                	li	a7,9
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <dup>:
.global dup
dup:
 li a7, SYS_dup
 356:	48a9                	li	a7,10
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 35e:	48ad                	li	a7,11
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 366:	48b1                	li	a7,12
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 36e:	48b5                	li	a7,13
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 376:	48b9                	li	a7,14
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <trace>:
.global trace
trace:
 li a7, SYS_trace
 37e:	48d9                	li	a7,22
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <alarm>:
.global alarm
alarm:
 li a7, SYS_alarm
 386:	48dd                	li	a7,23
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <alarmret>:
.global alarmret
alarmret:
 li a7, SYS_alarmret
 38e:	48e1                	li	a7,24
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 396:	1101                	addi	sp,sp,-32
 398:	ec06                	sd	ra,24(sp)
 39a:	e822                	sd	s0,16(sp)
 39c:	1000                	addi	s0,sp,32
 39e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3a2:	4605                	li	a2,1
 3a4:	fef40593          	addi	a1,s0,-17
 3a8:	00000097          	auipc	ra,0x0
 3ac:	f56080e7          	jalr	-170(ra) # 2fe <write>
}
 3b0:	60e2                	ld	ra,24(sp)
 3b2:	6442                	ld	s0,16(sp)
 3b4:	6105                	addi	sp,sp,32
 3b6:	8082                	ret

00000000000003b8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3b8:	7139                	addi	sp,sp,-64
 3ba:	fc06                	sd	ra,56(sp)
 3bc:	f822                	sd	s0,48(sp)
 3be:	f426                	sd	s1,40(sp)
 3c0:	f04a                	sd	s2,32(sp)
 3c2:	ec4e                	sd	s3,24(sp)
 3c4:	0080                	addi	s0,sp,64
 3c6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3c8:	c299                	beqz	a3,3ce <printint+0x16>
 3ca:	0805c863          	bltz	a1,45a <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3ce:	2581                	sext.w	a1,a1
  neg = 0;
 3d0:	4881                	li	a7,0
 3d2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3d6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3d8:	2601                	sext.w	a2,a2
 3da:	00000517          	auipc	a0,0x0
 3de:	78e50513          	addi	a0,a0,1934 # b68 <digits>
 3e2:	883a                	mv	a6,a4
 3e4:	2705                	addiw	a4,a4,1
 3e6:	02c5f7bb          	remuw	a5,a1,a2
 3ea:	1782                	slli	a5,a5,0x20
 3ec:	9381                	srli	a5,a5,0x20
 3ee:	97aa                	add	a5,a5,a0
 3f0:	0007c783          	lbu	a5,0(a5)
 3f4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3f8:	0005879b          	sext.w	a5,a1
 3fc:	02c5d5bb          	divuw	a1,a1,a2
 400:	0685                	addi	a3,a3,1
 402:	fec7f0e3          	bgeu	a5,a2,3e2 <printint+0x2a>
  if(neg)
 406:	00088b63          	beqz	a7,41c <printint+0x64>
    buf[i++] = '-';
 40a:	fd040793          	addi	a5,s0,-48
 40e:	973e                	add	a4,a4,a5
 410:	02d00793          	li	a5,45
 414:	fef70823          	sb	a5,-16(a4)
 418:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 41c:	02e05863          	blez	a4,44c <printint+0x94>
 420:	fc040793          	addi	a5,s0,-64
 424:	00e78933          	add	s2,a5,a4
 428:	fff78993          	addi	s3,a5,-1
 42c:	99ba                	add	s3,s3,a4
 42e:	377d                	addiw	a4,a4,-1
 430:	1702                	slli	a4,a4,0x20
 432:	9301                	srli	a4,a4,0x20
 434:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 438:	fff94583          	lbu	a1,-1(s2)
 43c:	8526                	mv	a0,s1
 43e:	00000097          	auipc	ra,0x0
 442:	f58080e7          	jalr	-168(ra) # 396 <putc>
  while(--i >= 0)
 446:	197d                	addi	s2,s2,-1
 448:	ff3918e3          	bne	s2,s3,438 <printint+0x80>
}
 44c:	70e2                	ld	ra,56(sp)
 44e:	7442                	ld	s0,48(sp)
 450:	74a2                	ld	s1,40(sp)
 452:	7902                	ld	s2,32(sp)
 454:	69e2                	ld	s3,24(sp)
 456:	6121                	addi	sp,sp,64
 458:	8082                	ret
    x = -xx;
 45a:	40b005bb          	negw	a1,a1
    neg = 1;
 45e:	4885                	li	a7,1
    x = -xx;
 460:	bf8d                	j	3d2 <printint+0x1a>

0000000000000462 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 462:	7119                	addi	sp,sp,-128
 464:	fc86                	sd	ra,120(sp)
 466:	f8a2                	sd	s0,112(sp)
 468:	f4a6                	sd	s1,104(sp)
 46a:	f0ca                	sd	s2,96(sp)
 46c:	ecce                	sd	s3,88(sp)
 46e:	e8d2                	sd	s4,80(sp)
 470:	e4d6                	sd	s5,72(sp)
 472:	e0da                	sd	s6,64(sp)
 474:	fc5e                	sd	s7,56(sp)
 476:	f862                	sd	s8,48(sp)
 478:	f466                	sd	s9,40(sp)
 47a:	f06a                	sd	s10,32(sp)
 47c:	ec6e                	sd	s11,24(sp)
 47e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 480:	0005c903          	lbu	s2,0(a1)
 484:	18090f63          	beqz	s2,622 <vprintf+0x1c0>
 488:	8aaa                	mv	s5,a0
 48a:	8b32                	mv	s6,a2
 48c:	00158493          	addi	s1,a1,1
  state = 0;
 490:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 492:	02500a13          	li	s4,37
      if(c == 'd'){
 496:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 49a:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 49e:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 4a2:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4a6:	00000b97          	auipc	s7,0x0
 4aa:	6c2b8b93          	addi	s7,s7,1730 # b68 <digits>
 4ae:	a839                	j	4cc <vprintf+0x6a>
        putc(fd, c);
 4b0:	85ca                	mv	a1,s2
 4b2:	8556                	mv	a0,s5
 4b4:	00000097          	auipc	ra,0x0
 4b8:	ee2080e7          	jalr	-286(ra) # 396 <putc>
 4bc:	a019                	j	4c2 <vprintf+0x60>
    } else if(state == '%'){
 4be:	01498f63          	beq	s3,s4,4dc <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4c2:	0485                	addi	s1,s1,1
 4c4:	fff4c903          	lbu	s2,-1(s1)
 4c8:	14090d63          	beqz	s2,622 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 4cc:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4d0:	fe0997e3          	bnez	s3,4be <vprintf+0x5c>
      if(c == '%'){
 4d4:	fd479ee3          	bne	a5,s4,4b0 <vprintf+0x4e>
        state = '%';
 4d8:	89be                	mv	s3,a5
 4da:	b7e5                	j	4c2 <vprintf+0x60>
      if(c == 'd'){
 4dc:	05878063          	beq	a5,s8,51c <vprintf+0xba>
      } else if(c == 'l') {
 4e0:	05978c63          	beq	a5,s9,538 <vprintf+0xd6>
      } else if(c == 'x') {
 4e4:	07a78863          	beq	a5,s10,554 <vprintf+0xf2>
      } else if(c == 'p') {
 4e8:	09b78463          	beq	a5,s11,570 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 4ec:	07300713          	li	a4,115
 4f0:	0ce78663          	beq	a5,a4,5bc <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4f4:	06300713          	li	a4,99
 4f8:	0ee78e63          	beq	a5,a4,5f4 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 4fc:	11478863          	beq	a5,s4,60c <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 500:	85d2                	mv	a1,s4
 502:	8556                	mv	a0,s5
 504:	00000097          	auipc	ra,0x0
 508:	e92080e7          	jalr	-366(ra) # 396 <putc>
        putc(fd, c);
 50c:	85ca                	mv	a1,s2
 50e:	8556                	mv	a0,s5
 510:	00000097          	auipc	ra,0x0
 514:	e86080e7          	jalr	-378(ra) # 396 <putc>
      }
      state = 0;
 518:	4981                	li	s3,0
 51a:	b765                	j	4c2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 51c:	008b0913          	addi	s2,s6,8
 520:	4685                	li	a3,1
 522:	4629                	li	a2,10
 524:	000b2583          	lw	a1,0(s6)
 528:	8556                	mv	a0,s5
 52a:	00000097          	auipc	ra,0x0
 52e:	e8e080e7          	jalr	-370(ra) # 3b8 <printint>
 532:	8b4a                	mv	s6,s2
      state = 0;
 534:	4981                	li	s3,0
 536:	b771                	j	4c2 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 538:	008b0913          	addi	s2,s6,8
 53c:	4681                	li	a3,0
 53e:	4629                	li	a2,10
 540:	000b2583          	lw	a1,0(s6)
 544:	8556                	mv	a0,s5
 546:	00000097          	auipc	ra,0x0
 54a:	e72080e7          	jalr	-398(ra) # 3b8 <printint>
 54e:	8b4a                	mv	s6,s2
      state = 0;
 550:	4981                	li	s3,0
 552:	bf85                	j	4c2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 554:	008b0913          	addi	s2,s6,8
 558:	4681                	li	a3,0
 55a:	4641                	li	a2,16
 55c:	000b2583          	lw	a1,0(s6)
 560:	8556                	mv	a0,s5
 562:	00000097          	auipc	ra,0x0
 566:	e56080e7          	jalr	-426(ra) # 3b8 <printint>
 56a:	8b4a                	mv	s6,s2
      state = 0;
 56c:	4981                	li	s3,0
 56e:	bf91                	j	4c2 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 570:	008b0793          	addi	a5,s6,8
 574:	f8f43423          	sd	a5,-120(s0)
 578:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 57c:	03000593          	li	a1,48
 580:	8556                	mv	a0,s5
 582:	00000097          	auipc	ra,0x0
 586:	e14080e7          	jalr	-492(ra) # 396 <putc>
  putc(fd, 'x');
 58a:	85ea                	mv	a1,s10
 58c:	8556                	mv	a0,s5
 58e:	00000097          	auipc	ra,0x0
 592:	e08080e7          	jalr	-504(ra) # 396 <putc>
 596:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 598:	03c9d793          	srli	a5,s3,0x3c
 59c:	97de                	add	a5,a5,s7
 59e:	0007c583          	lbu	a1,0(a5)
 5a2:	8556                	mv	a0,s5
 5a4:	00000097          	auipc	ra,0x0
 5a8:	df2080e7          	jalr	-526(ra) # 396 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5ac:	0992                	slli	s3,s3,0x4
 5ae:	397d                	addiw	s2,s2,-1
 5b0:	fe0914e3          	bnez	s2,598 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 5b4:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	b721                	j	4c2 <vprintf+0x60>
        s = va_arg(ap, char*);
 5bc:	008b0993          	addi	s3,s6,8
 5c0:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 5c4:	02090163          	beqz	s2,5e6 <vprintf+0x184>
        while(*s != 0){
 5c8:	00094583          	lbu	a1,0(s2)
 5cc:	c9a1                	beqz	a1,61c <vprintf+0x1ba>
          putc(fd, *s);
 5ce:	8556                	mv	a0,s5
 5d0:	00000097          	auipc	ra,0x0
 5d4:	dc6080e7          	jalr	-570(ra) # 396 <putc>
          s++;
 5d8:	0905                	addi	s2,s2,1
        while(*s != 0){
 5da:	00094583          	lbu	a1,0(s2)
 5de:	f9e5                	bnez	a1,5ce <vprintf+0x16c>
        s = va_arg(ap, char*);
 5e0:	8b4e                	mv	s6,s3
      state = 0;
 5e2:	4981                	li	s3,0
 5e4:	bdf9                	j	4c2 <vprintf+0x60>
          s = "(null)";
 5e6:	00000917          	auipc	s2,0x0
 5ea:	57a90913          	addi	s2,s2,1402 # b60 <strstr+0x7e>
        while(*s != 0){
 5ee:	02800593          	li	a1,40
 5f2:	bff1                	j	5ce <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 5f4:	008b0913          	addi	s2,s6,8
 5f8:	000b4583          	lbu	a1,0(s6)
 5fc:	8556                	mv	a0,s5
 5fe:	00000097          	auipc	ra,0x0
 602:	d98080e7          	jalr	-616(ra) # 396 <putc>
 606:	8b4a                	mv	s6,s2
      state = 0;
 608:	4981                	li	s3,0
 60a:	bd65                	j	4c2 <vprintf+0x60>
        putc(fd, c);
 60c:	85d2                	mv	a1,s4
 60e:	8556                	mv	a0,s5
 610:	00000097          	auipc	ra,0x0
 614:	d86080e7          	jalr	-634(ra) # 396 <putc>
      state = 0;
 618:	4981                	li	s3,0
 61a:	b565                	j	4c2 <vprintf+0x60>
        s = va_arg(ap, char*);
 61c:	8b4e                	mv	s6,s3
      state = 0;
 61e:	4981                	li	s3,0
 620:	b54d                	j	4c2 <vprintf+0x60>
    }
  }
}
 622:	70e6                	ld	ra,120(sp)
 624:	7446                	ld	s0,112(sp)
 626:	74a6                	ld	s1,104(sp)
 628:	7906                	ld	s2,96(sp)
 62a:	69e6                	ld	s3,88(sp)
 62c:	6a46                	ld	s4,80(sp)
 62e:	6aa6                	ld	s5,72(sp)
 630:	6b06                	ld	s6,64(sp)
 632:	7be2                	ld	s7,56(sp)
 634:	7c42                	ld	s8,48(sp)
 636:	7ca2                	ld	s9,40(sp)
 638:	7d02                	ld	s10,32(sp)
 63a:	6de2                	ld	s11,24(sp)
 63c:	6109                	addi	sp,sp,128
 63e:	8082                	ret

0000000000000640 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 640:	715d                	addi	sp,sp,-80
 642:	ec06                	sd	ra,24(sp)
 644:	e822                	sd	s0,16(sp)
 646:	1000                	addi	s0,sp,32
 648:	e010                	sd	a2,0(s0)
 64a:	e414                	sd	a3,8(s0)
 64c:	e818                	sd	a4,16(s0)
 64e:	ec1c                	sd	a5,24(s0)
 650:	03043023          	sd	a6,32(s0)
 654:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 658:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 65c:	8622                	mv	a2,s0
 65e:	00000097          	auipc	ra,0x0
 662:	e04080e7          	jalr	-508(ra) # 462 <vprintf>
}
 666:	60e2                	ld	ra,24(sp)
 668:	6442                	ld	s0,16(sp)
 66a:	6161                	addi	sp,sp,80
 66c:	8082                	ret

000000000000066e <printf>:

void
printf(const char *fmt, ...)
{
 66e:	711d                	addi	sp,sp,-96
 670:	ec06                	sd	ra,24(sp)
 672:	e822                	sd	s0,16(sp)
 674:	1000                	addi	s0,sp,32
 676:	e40c                	sd	a1,8(s0)
 678:	e810                	sd	a2,16(s0)
 67a:	ec14                	sd	a3,24(s0)
 67c:	f018                	sd	a4,32(s0)
 67e:	f41c                	sd	a5,40(s0)
 680:	03043823          	sd	a6,48(s0)
 684:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 688:	00840613          	addi	a2,s0,8
 68c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 690:	85aa                	mv	a1,a0
 692:	4505                	li	a0,1
 694:	00000097          	auipc	ra,0x0
 698:	dce080e7          	jalr	-562(ra) # 462 <vprintf>
}
 69c:	60e2                	ld	ra,24(sp)
 69e:	6442                	ld	s0,16(sp)
 6a0:	6125                	addi	sp,sp,96
 6a2:	8082                	ret

00000000000006a4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6a4:	1141                	addi	sp,sp,-16
 6a6:	e422                	sd	s0,8(sp)
 6a8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6aa:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ae:	00000797          	auipc	a5,0x0
 6b2:	5727b783          	ld	a5,1394(a5) # c20 <freep>
 6b6:	a805                	j	6e6 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6b8:	4618                	lw	a4,8(a2)
 6ba:	9db9                	addw	a1,a1,a4
 6bc:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6c0:	6398                	ld	a4,0(a5)
 6c2:	6318                	ld	a4,0(a4)
 6c4:	fee53823          	sd	a4,-16(a0)
 6c8:	a091                	j	70c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6ca:	ff852703          	lw	a4,-8(a0)
 6ce:	9e39                	addw	a2,a2,a4
 6d0:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 6d2:	ff053703          	ld	a4,-16(a0)
 6d6:	e398                	sd	a4,0(a5)
 6d8:	a099                	j	71e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6da:	6398                	ld	a4,0(a5)
 6dc:	00e7e463          	bltu	a5,a4,6e4 <free+0x40>
 6e0:	00e6ea63          	bltu	a3,a4,6f4 <free+0x50>
{
 6e4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e6:	fed7fae3          	bgeu	a5,a3,6da <free+0x36>
 6ea:	6398                	ld	a4,0(a5)
 6ec:	00e6e463          	bltu	a3,a4,6f4 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f0:	fee7eae3          	bltu	a5,a4,6e4 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 6f4:	ff852583          	lw	a1,-8(a0)
 6f8:	6390                	ld	a2,0(a5)
 6fa:	02059713          	slli	a4,a1,0x20
 6fe:	9301                	srli	a4,a4,0x20
 700:	0712                	slli	a4,a4,0x4
 702:	9736                	add	a4,a4,a3
 704:	fae60ae3          	beq	a2,a4,6b8 <free+0x14>
    bp->s.ptr = p->s.ptr;
 708:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 70c:	4790                	lw	a2,8(a5)
 70e:	02061713          	slli	a4,a2,0x20
 712:	9301                	srli	a4,a4,0x20
 714:	0712                	slli	a4,a4,0x4
 716:	973e                	add	a4,a4,a5
 718:	fae689e3          	beq	a3,a4,6ca <free+0x26>
  } else
    p->s.ptr = bp;
 71c:	e394                	sd	a3,0(a5)
  freep = p;
 71e:	00000717          	auipc	a4,0x0
 722:	50f73123          	sd	a5,1282(a4) # c20 <freep>
}
 726:	6422                	ld	s0,8(sp)
 728:	0141                	addi	sp,sp,16
 72a:	8082                	ret

000000000000072c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 72c:	7139                	addi	sp,sp,-64
 72e:	fc06                	sd	ra,56(sp)
 730:	f822                	sd	s0,48(sp)
 732:	f426                	sd	s1,40(sp)
 734:	f04a                	sd	s2,32(sp)
 736:	ec4e                	sd	s3,24(sp)
 738:	e852                	sd	s4,16(sp)
 73a:	e456                	sd	s5,8(sp)
 73c:	e05a                	sd	s6,0(sp)
 73e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 740:	02051493          	slli	s1,a0,0x20
 744:	9081                	srli	s1,s1,0x20
 746:	04bd                	addi	s1,s1,15
 748:	8091                	srli	s1,s1,0x4
 74a:	0014899b          	addiw	s3,s1,1
 74e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 750:	00000517          	auipc	a0,0x0
 754:	4d053503          	ld	a0,1232(a0) # c20 <freep>
 758:	c515                	beqz	a0,784 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 75a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 75c:	4798                	lw	a4,8(a5)
 75e:	02977f63          	bgeu	a4,s1,79c <malloc+0x70>
 762:	8a4e                	mv	s4,s3
 764:	0009871b          	sext.w	a4,s3
 768:	6685                	lui	a3,0x1
 76a:	00d77363          	bgeu	a4,a3,770 <malloc+0x44>
 76e:	6a05                	lui	s4,0x1
 770:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 774:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 778:	00000917          	auipc	s2,0x0
 77c:	4a890913          	addi	s2,s2,1192 # c20 <freep>
  if(p == (char*)-1)
 780:	5afd                	li	s5,-1
 782:	a88d                	j	7f4 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 784:	00000797          	auipc	a5,0x0
 788:	4a478793          	addi	a5,a5,1188 # c28 <base>
 78c:	00000717          	auipc	a4,0x0
 790:	48f73a23          	sd	a5,1172(a4) # c20 <freep>
 794:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 796:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 79a:	b7e1                	j	762 <malloc+0x36>
      if(p->s.size == nunits)
 79c:	02e48b63          	beq	s1,a4,7d2 <malloc+0xa6>
        p->s.size -= nunits;
 7a0:	4137073b          	subw	a4,a4,s3
 7a4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7a6:	1702                	slli	a4,a4,0x20
 7a8:	9301                	srli	a4,a4,0x20
 7aa:	0712                	slli	a4,a4,0x4
 7ac:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7ae:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7b2:	00000717          	auipc	a4,0x0
 7b6:	46a73723          	sd	a0,1134(a4) # c20 <freep>
      return (void*)(p + 1);
 7ba:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7be:	70e2                	ld	ra,56(sp)
 7c0:	7442                	ld	s0,48(sp)
 7c2:	74a2                	ld	s1,40(sp)
 7c4:	7902                	ld	s2,32(sp)
 7c6:	69e2                	ld	s3,24(sp)
 7c8:	6a42                	ld	s4,16(sp)
 7ca:	6aa2                	ld	s5,8(sp)
 7cc:	6b02                	ld	s6,0(sp)
 7ce:	6121                	addi	sp,sp,64
 7d0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7d2:	6398                	ld	a4,0(a5)
 7d4:	e118                	sd	a4,0(a0)
 7d6:	bff1                	j	7b2 <malloc+0x86>
  hp->s.size = nu;
 7d8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7dc:	0541                	addi	a0,a0,16
 7de:	00000097          	auipc	ra,0x0
 7e2:	ec6080e7          	jalr	-314(ra) # 6a4 <free>
  return freep;
 7e6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7ea:	d971                	beqz	a0,7be <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ec:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ee:	4798                	lw	a4,8(a5)
 7f0:	fa9776e3          	bgeu	a4,s1,79c <malloc+0x70>
    if(p == freep)
 7f4:	00093703          	ld	a4,0(s2)
 7f8:	853e                	mv	a0,a5
 7fa:	fef719e3          	bne	a4,a5,7ec <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 7fe:	8552                	mv	a0,s4
 800:	00000097          	auipc	ra,0x0
 804:	b66080e7          	jalr	-1178(ra) # 366 <sbrk>
  if(p == (char*)-1)
 808:	fd5518e3          	bne	a0,s5,7d8 <malloc+0xac>
        return 0;
 80c:	4501                	li	a0,0
 80e:	bf45                	j	7be <malloc+0x92>

0000000000000810 <Pipe>:
#include "kernel/stat.h"
#include "user.h"
#include "wrapper.h"
int strncmp(const char*s, const char*pat,int n);

int Pipe(int *p) {
 810:	1101                	addi	sp,sp,-32
 812:	ec06                	sd	ra,24(sp)
 814:	e822                	sd	s0,16(sp)
 816:	e426                	sd	s1,8(sp)
 818:	1000                	addi	s0,sp,32
  i32 res = pipe(p);
 81a:	00000097          	auipc	ra,0x0
 81e:	ad4080e7          	jalr	-1324(ra) # 2ee <pipe>
 822:	84aa                	mv	s1,a0
  if (res < 0) {
 824:	00054863          	bltz	a0,834 <Pipe+0x24>
    fprintf(2, "pipe creation error");
  }
  return res;
}
 828:	8526                	mv	a0,s1
 82a:	60e2                	ld	ra,24(sp)
 82c:	6442                	ld	s0,16(sp)
 82e:	64a2                	ld	s1,8(sp)
 830:	6105                	addi	sp,sp,32
 832:	8082                	ret
    fprintf(2, "pipe creation error");
 834:	00000597          	auipc	a1,0x0
 838:	34c58593          	addi	a1,a1,844 # b80 <digits+0x18>
 83c:	4509                	li	a0,2
 83e:	00000097          	auipc	ra,0x0
 842:	e02080e7          	jalr	-510(ra) # 640 <fprintf>
 846:	b7cd                	j	828 <Pipe+0x18>

0000000000000848 <Write>:

int Write(int fd, void *buf, int count){
 848:	1141                	addi	sp,sp,-16
 84a:	e406                	sd	ra,8(sp)
 84c:	e022                	sd	s0,0(sp)
 84e:	0800                	addi	s0,sp,16
  i32 res = write(fd, buf, count);
 850:	00000097          	auipc	ra,0x0
 854:	aae080e7          	jalr	-1362(ra) # 2fe <write>
  if (res < 0) {
 858:	00054663          	bltz	a0,864 <Write+0x1c>
    fprintf(2, "write error");
    exit(0);
  }
  return res;
}
 85c:	60a2                	ld	ra,8(sp)
 85e:	6402                	ld	s0,0(sp)
 860:	0141                	addi	sp,sp,16
 862:	8082                	ret
    fprintf(2, "write error");
 864:	00000597          	auipc	a1,0x0
 868:	33458593          	addi	a1,a1,820 # b98 <digits+0x30>
 86c:	4509                	li	a0,2
 86e:	00000097          	auipc	ra,0x0
 872:	dd2080e7          	jalr	-558(ra) # 640 <fprintf>
    exit(0);
 876:	4501                	li	a0,0
 878:	00000097          	auipc	ra,0x0
 87c:	a66080e7          	jalr	-1434(ra) # 2de <exit>

0000000000000880 <Read>:



int Read(int fd,  void*buf, int count){
 880:	1141                	addi	sp,sp,-16
 882:	e406                	sd	ra,8(sp)
 884:	e022                	sd	s0,0(sp)
 886:	0800                	addi	s0,sp,16
  i32 res = read(fd, buf, count);
 888:	00000097          	auipc	ra,0x0
 88c:	a6e080e7          	jalr	-1426(ra) # 2f6 <read>
  if (res < 0) {
 890:	00054663          	bltz	a0,89c <Read+0x1c>
    fprintf(2, "read error");
    exit(0);
  }
  return res;
}
 894:	60a2                	ld	ra,8(sp)
 896:	6402                	ld	s0,0(sp)
 898:	0141                	addi	sp,sp,16
 89a:	8082                	ret
    fprintf(2, "read error");
 89c:	00000597          	auipc	a1,0x0
 8a0:	30c58593          	addi	a1,a1,780 # ba8 <digits+0x40>
 8a4:	4509                	li	a0,2
 8a6:	00000097          	auipc	ra,0x0
 8aa:	d9a080e7          	jalr	-614(ra) # 640 <fprintf>
    exit(0);
 8ae:	4501                	li	a0,0
 8b0:	00000097          	auipc	ra,0x0
 8b4:	a2e080e7          	jalr	-1490(ra) # 2de <exit>

00000000000008b8 <Open>:


int Open(const char* path, int flag){
 8b8:	1141                	addi	sp,sp,-16
 8ba:	e406                	sd	ra,8(sp)
 8bc:	e022                	sd	s0,0(sp)
 8be:	0800                	addi	s0,sp,16
  i32 res = open(path, flag);
 8c0:	00000097          	auipc	ra,0x0
 8c4:	a5e080e7          	jalr	-1442(ra) # 31e <open>
  if (res < 0) {
 8c8:	00054663          	bltz	a0,8d4 <Open+0x1c>
    fprintf(2, "open error");
    exit(0);
  }
  return res;
}
 8cc:	60a2                	ld	ra,8(sp)
 8ce:	6402                	ld	s0,0(sp)
 8d0:	0141                	addi	sp,sp,16
 8d2:	8082                	ret
    fprintf(2, "open error");
 8d4:	00000597          	auipc	a1,0x0
 8d8:	2e458593          	addi	a1,a1,740 # bb8 <digits+0x50>
 8dc:	4509                	li	a0,2
 8de:	00000097          	auipc	ra,0x0
 8e2:	d62080e7          	jalr	-670(ra) # 640 <fprintf>
    exit(0);
 8e6:	4501                	li	a0,0
 8e8:	00000097          	auipc	ra,0x0
 8ec:	9f6080e7          	jalr	-1546(ra) # 2de <exit>

00000000000008f0 <Fstat>:


int Fstat(int fd, stat_t *st){
 8f0:	1141                	addi	sp,sp,-16
 8f2:	e406                	sd	ra,8(sp)
 8f4:	e022                	sd	s0,0(sp)
 8f6:	0800                	addi	s0,sp,16
  i32 res = fstat(fd, st);
 8f8:	00000097          	auipc	ra,0x0
 8fc:	a3e080e7          	jalr	-1474(ra) # 336 <fstat>
  if (res < 0) {
 900:	00054663          	bltz	a0,90c <Fstat+0x1c>
    fprintf(2, "get file stat error");
    exit(0);
  }
  return res;
}
 904:	60a2                	ld	ra,8(sp)
 906:	6402                	ld	s0,0(sp)
 908:	0141                	addi	sp,sp,16
 90a:	8082                	ret
    fprintf(2, "get file stat error");
 90c:	00000597          	auipc	a1,0x0
 910:	2bc58593          	addi	a1,a1,700 # bc8 <digits+0x60>
 914:	4509                	li	a0,2
 916:	00000097          	auipc	ra,0x0
 91a:	d2a080e7          	jalr	-726(ra) # 640 <fprintf>
    exit(0);
 91e:	4501                	li	a0,0
 920:	00000097          	auipc	ra,0x0
 924:	9be080e7          	jalr	-1602(ra) # 2de <exit>

0000000000000928 <Dup>:



int Dup(int fd){
 928:	1141                	addi	sp,sp,-16
 92a:	e406                	sd	ra,8(sp)
 92c:	e022                	sd	s0,0(sp)
 92e:	0800                	addi	s0,sp,16
  i32 res = dup(fd);
 930:	00000097          	auipc	ra,0x0
 934:	a26080e7          	jalr	-1498(ra) # 356 <dup>
  if (res < 0) {
 938:	00054663          	bltz	a0,944 <Dup+0x1c>
    fprintf(2, "dup error");
    exit(0);
  }
  return res;

}
 93c:	60a2                	ld	ra,8(sp)
 93e:	6402                	ld	s0,0(sp)
 940:	0141                	addi	sp,sp,16
 942:	8082                	ret
    fprintf(2, "dup error");
 944:	00000597          	auipc	a1,0x0
 948:	29c58593          	addi	a1,a1,668 # be0 <digits+0x78>
 94c:	4509                	li	a0,2
 94e:	00000097          	auipc	ra,0x0
 952:	cf2080e7          	jalr	-782(ra) # 640 <fprintf>
    exit(0);
 956:	4501                	li	a0,0
 958:	00000097          	auipc	ra,0x0
 95c:	986080e7          	jalr	-1658(ra) # 2de <exit>

0000000000000960 <Close>:

int Close(int fd){
 960:	1141                	addi	sp,sp,-16
 962:	e406                	sd	ra,8(sp)
 964:	e022                	sd	s0,0(sp)
 966:	0800                	addi	s0,sp,16
  i32 res = close(fd);
 968:	00000097          	auipc	ra,0x0
 96c:	99e080e7          	jalr	-1634(ra) # 306 <close>
  if (res < 0) {
 970:	00054663          	bltz	a0,97c <Close+0x1c>
    fprintf(2, "file close error~");
    exit(0);
  }
  return res;
}
 974:	60a2                	ld	ra,8(sp)
 976:	6402                	ld	s0,0(sp)
 978:	0141                	addi	sp,sp,16
 97a:	8082                	ret
    fprintf(2, "file close error~");
 97c:	00000597          	auipc	a1,0x0
 980:	27458593          	addi	a1,a1,628 # bf0 <digits+0x88>
 984:	4509                	li	a0,2
 986:	00000097          	auipc	ra,0x0
 98a:	cba080e7          	jalr	-838(ra) # 640 <fprintf>
    exit(0);
 98e:	4501                	li	a0,0
 990:	00000097          	auipc	ra,0x0
 994:	94e080e7          	jalr	-1714(ra) # 2de <exit>

0000000000000998 <Dup2>:

int Dup2(int old_fd,int new_fd){
 998:	1101                	addi	sp,sp,-32
 99a:	ec06                	sd	ra,24(sp)
 99c:	e822                	sd	s0,16(sp)
 99e:	e426                	sd	s1,8(sp)
 9a0:	1000                	addi	s0,sp,32
 9a2:	84aa                	mv	s1,a0
  Close(new_fd);
 9a4:	852e                	mv	a0,a1
 9a6:	00000097          	auipc	ra,0x0
 9aa:	fba080e7          	jalr	-70(ra) # 960 <Close>
  i32 res = Dup(old_fd);
 9ae:	8526                	mv	a0,s1
 9b0:	00000097          	auipc	ra,0x0
 9b4:	f78080e7          	jalr	-136(ra) # 928 <Dup>
  if (res < 0) {
 9b8:	00054763          	bltz	a0,9c6 <Dup2+0x2e>
    fprintf(2, "dup error");
    exit(0);
  }
  return res;
}
 9bc:	60e2                	ld	ra,24(sp)
 9be:	6442                	ld	s0,16(sp)
 9c0:	64a2                	ld	s1,8(sp)
 9c2:	6105                	addi	sp,sp,32
 9c4:	8082                	ret
    fprintf(2, "dup error");
 9c6:	00000597          	auipc	a1,0x0
 9ca:	21a58593          	addi	a1,a1,538 # be0 <digits+0x78>
 9ce:	4509                	li	a0,2
 9d0:	00000097          	auipc	ra,0x0
 9d4:	c70080e7          	jalr	-912(ra) # 640 <fprintf>
    exit(0);
 9d8:	4501                	li	a0,0
 9da:	00000097          	auipc	ra,0x0
 9de:	904080e7          	jalr	-1788(ra) # 2de <exit>

00000000000009e2 <Stat>:

int Stat(const char*link,stat_t *st){
 9e2:	1101                	addi	sp,sp,-32
 9e4:	ec06                	sd	ra,24(sp)
 9e6:	e822                	sd	s0,16(sp)
 9e8:	e426                	sd	s1,8(sp)
 9ea:	1000                	addi	s0,sp,32
 9ec:	84aa                	mv	s1,a0
  i32 res = stat(link,st);
 9ee:	fffff097          	auipc	ra,0xfffff
 9f2:	7ae080e7          	jalr	1966(ra) # 19c <stat>
  if (res < 0) {
 9f6:	00054763          	bltz	a0,a04 <Stat+0x22>
    fprintf(2, "file %s stat error",link);
    exit(0);
  }
  return res;
}
 9fa:	60e2                	ld	ra,24(sp)
 9fc:	6442                	ld	s0,16(sp)
 9fe:	64a2                	ld	s1,8(sp)
 a00:	6105                	addi	sp,sp,32
 a02:	8082                	ret
    fprintf(2, "file %s stat error",link);
 a04:	8626                	mv	a2,s1
 a06:	00000597          	auipc	a1,0x0
 a0a:	20258593          	addi	a1,a1,514 # c08 <digits+0xa0>
 a0e:	4509                	li	a0,2
 a10:	00000097          	auipc	ra,0x0
 a14:	c30080e7          	jalr	-976(ra) # 640 <fprintf>
    exit(0);
 a18:	4501                	li	a0,0
 a1a:	00000097          	auipc	ra,0x0
 a1e:	8c4080e7          	jalr	-1852(ra) # 2de <exit>

0000000000000a22 <strncmp>:
   return -1;
}



int strncmp(const char*s, const char*pat,int n){
 a22:	bc010113          	addi	sp,sp,-1088
 a26:	42113c23          	sd	ra,1080(sp)
 a2a:	42813823          	sd	s0,1072(sp)
 a2e:	42913423          	sd	s1,1064(sp)
 a32:	43213023          	sd	s2,1056(sp)
 a36:	41313c23          	sd	s3,1048(sp)
 a3a:	41413823          	sd	s4,1040(sp)
 a3e:	41513423          	sd	s5,1032(sp)
 a42:	44010413          	addi	s0,sp,1088
 a46:	89aa                	mv	s3,a0
 a48:	892e                	mv	s2,a1
 a4a:	84b2                	mv	s1,a2
  char buf1[512],buf2[512];
  int n1 = MIN(n,strlen(s));
 a4c:	fffff097          	auipc	ra,0xfffff
 a50:	66c080e7          	jalr	1644(ra) # b8 <strlen>
 a54:	2501                	sext.w	a0,a0
 a56:	00048a1b          	sext.w	s4,s1
 a5a:	8aa6                	mv	s5,s1
 a5c:	06aa7363          	bgeu	s4,a0,ac2 <strncmp+0xa0>
  int n2 = MIN(n,strlen(pat));
 a60:	854a                	mv	a0,s2
 a62:	fffff097          	auipc	ra,0xfffff
 a66:	656080e7          	jalr	1622(ra) # b8 <strlen>
 a6a:	2501                	sext.w	a0,a0
 a6c:	06aa7363          	bgeu	s4,a0,ad2 <strncmp+0xb0>
  memmove(buf1,s,n1);
 a70:	8656                	mv	a2,s5
 a72:	85ce                	mv	a1,s3
 a74:	dc040513          	addi	a0,s0,-576
 a78:	fffff097          	auipc	ra,0xfffff
 a7c:	7b4080e7          	jalr	1972(ra) # 22c <memmove>
  memmove(buf2,pat,n2);
 a80:	8626                	mv	a2,s1
 a82:	85ca                	mv	a1,s2
 a84:	bc040513          	addi	a0,s0,-1088
 a88:	fffff097          	auipc	ra,0xfffff
 a8c:	7a4080e7          	jalr	1956(ra) # 22c <memmove>
  return strcmp(buf1,buf2);
 a90:	bc040593          	addi	a1,s0,-1088
 a94:	dc040513          	addi	a0,s0,-576
 a98:	fffff097          	auipc	ra,0xfffff
 a9c:	5f4080e7          	jalr	1524(ra) # 8c <strcmp>
}
 aa0:	43813083          	ld	ra,1080(sp)
 aa4:	43013403          	ld	s0,1072(sp)
 aa8:	42813483          	ld	s1,1064(sp)
 aac:	42013903          	ld	s2,1056(sp)
 ab0:	41813983          	ld	s3,1048(sp)
 ab4:	41013a03          	ld	s4,1040(sp)
 ab8:	40813a83          	ld	s5,1032(sp)
 abc:	44010113          	addi	sp,sp,1088
 ac0:	8082                	ret
  int n1 = MIN(n,strlen(s));
 ac2:	854e                	mv	a0,s3
 ac4:	fffff097          	auipc	ra,0xfffff
 ac8:	5f4080e7          	jalr	1524(ra) # b8 <strlen>
 acc:	00050a9b          	sext.w	s5,a0
 ad0:	bf41                	j	a60 <strncmp+0x3e>
  int n2 = MIN(n,strlen(pat));
 ad2:	854a                	mv	a0,s2
 ad4:	fffff097          	auipc	ra,0xfffff
 ad8:	5e4080e7          	jalr	1508(ra) # b8 <strlen>
 adc:	0005049b          	sext.w	s1,a0
 ae0:	bf41                	j	a70 <strncmp+0x4e>

0000000000000ae2 <strstr>:
   while (*s != 0){
 ae2:	00054783          	lbu	a5,0(a0)
 ae6:	cba1                	beqz	a5,b36 <strstr+0x54>
int strstr(char *s,char *p){
 ae8:	7179                	addi	sp,sp,-48
 aea:	f406                	sd	ra,40(sp)
 aec:	f022                	sd	s0,32(sp)
 aee:	ec26                	sd	s1,24(sp)
 af0:	e84a                	sd	s2,16(sp)
 af2:	e44e                	sd	s3,8(sp)
 af4:	1800                	addi	s0,sp,48
 af6:	89aa                	mv	s3,a0
 af8:	892e                	mv	s2,a1
   while (*s != 0){
 afa:	84aa                	mv	s1,a0
     if (!strncmp(s,p,strlen(p)))
 afc:	854a                	mv	a0,s2
 afe:	fffff097          	auipc	ra,0xfffff
 b02:	5ba080e7          	jalr	1466(ra) # b8 <strlen>
 b06:	0005061b          	sext.w	a2,a0
 b0a:	85ca                	mv	a1,s2
 b0c:	8526                	mv	a0,s1
 b0e:	00000097          	auipc	ra,0x0
 b12:	f14080e7          	jalr	-236(ra) # a22 <strncmp>
 b16:	c519                	beqz	a0,b24 <strstr+0x42>
     s++;
 b18:	0485                	addi	s1,s1,1
   while (*s != 0){
 b1a:	0004c783          	lbu	a5,0(s1)
 b1e:	fff9                	bnez	a5,afc <strstr+0x1a>
   return -1;
 b20:	557d                	li	a0,-1
 b22:	a019                	j	b28 <strstr+0x46>
      return s - ori;
 b24:	4134853b          	subw	a0,s1,s3
}
 b28:	70a2                	ld	ra,40(sp)
 b2a:	7402                	ld	s0,32(sp)
 b2c:	64e2                	ld	s1,24(sp)
 b2e:	6942                	ld	s2,16(sp)
 b30:	69a2                	ld	s3,8(sp)
 b32:	6145                	addi	sp,sp,48
 b34:	8082                	ret
   return -1;
 b36:	557d                	li	a0,-1
}
 b38:	8082                	ret
