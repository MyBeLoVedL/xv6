
user/_hello:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user/user.h"

int main(int argc, char** argv){
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    char *s = sbrk(0);
   8:	4501                	li	a0,0
   a:	00000097          	auipc	ra,0x0
   e:	31a080e7          	jalr	794(ra) # 324 <sbrk>
  12:	85aa                	mv	a1,a0
    printf("init: %p\n",s);
  14:	00001517          	auipc	a0,0x1
  18:	ad450513          	addi	a0,a0,-1324 # ae8 <strstr+0x58>
  1c:	00000097          	auipc	ra,0x0
  20:	600080e7          	jalr	1536(ra) # 61c <printf>
    exit(0);
  24:	4501                	li	a0,0
  26:	00000097          	auipc	ra,0x0
  2a:	276080e7          	jalr	630(ra) # 29c <exit>

000000000000002e <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  2e:	1141                	addi	sp,sp,-16
  30:	e422                	sd	s0,8(sp)
  32:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  34:	87aa                	mv	a5,a0
  36:	0585                	addi	a1,a1,1
  38:	0785                	addi	a5,a5,1
  3a:	fff5c703          	lbu	a4,-1(a1)
  3e:	fee78fa3          	sb	a4,-1(a5)
  42:	fb75                	bnez	a4,36 <strcpy+0x8>
    ;
  return os;
}
  44:	6422                	ld	s0,8(sp)
  46:	0141                	addi	sp,sp,16
  48:	8082                	ret

000000000000004a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4a:	1141                	addi	sp,sp,-16
  4c:	e422                	sd	s0,8(sp)
  4e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  50:	00054783          	lbu	a5,0(a0)
  54:	cb91                	beqz	a5,68 <strcmp+0x1e>
  56:	0005c703          	lbu	a4,0(a1)
  5a:	00f71763          	bne	a4,a5,68 <strcmp+0x1e>
    p++, q++;
  5e:	0505                	addi	a0,a0,1
  60:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  62:	00054783          	lbu	a5,0(a0)
  66:	fbe5                	bnez	a5,56 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  68:	0005c503          	lbu	a0,0(a1)
}
  6c:	40a7853b          	subw	a0,a5,a0
  70:	6422                	ld	s0,8(sp)
  72:	0141                	addi	sp,sp,16
  74:	8082                	ret

0000000000000076 <strlen>:

uint
strlen(const char *s)
{
  76:	1141                	addi	sp,sp,-16
  78:	e422                	sd	s0,8(sp)
  7a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  7c:	00054783          	lbu	a5,0(a0)
  80:	cf91                	beqz	a5,9c <strlen+0x26>
  82:	0505                	addi	a0,a0,1
  84:	87aa                	mv	a5,a0
  86:	4685                	li	a3,1
  88:	9e89                	subw	a3,a3,a0
  8a:	00f6853b          	addw	a0,a3,a5
  8e:	0785                	addi	a5,a5,1
  90:	fff7c703          	lbu	a4,-1(a5)
  94:	fb7d                	bnez	a4,8a <strlen+0x14>
    ;
  return n;
}
  96:	6422                	ld	s0,8(sp)
  98:	0141                	addi	sp,sp,16
  9a:	8082                	ret
  for(n = 0; s[n]; n++)
  9c:	4501                	li	a0,0
  9e:	bfe5                	j	96 <strlen+0x20>

00000000000000a0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  a0:	1141                	addi	sp,sp,-16
  a2:	e422                	sd	s0,8(sp)
  a4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a6:	ca19                	beqz	a2,bc <memset+0x1c>
  a8:	87aa                	mv	a5,a0
  aa:	1602                	slli	a2,a2,0x20
  ac:	9201                	srli	a2,a2,0x20
  ae:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  b2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b6:	0785                	addi	a5,a5,1
  b8:	fee79de3          	bne	a5,a4,b2 <memset+0x12>
  }
  return dst;
}
  bc:	6422                	ld	s0,8(sp)
  be:	0141                	addi	sp,sp,16
  c0:	8082                	ret

00000000000000c2 <strchr>:

char*
strchr(const char *s, char c)
{
  c2:	1141                	addi	sp,sp,-16
  c4:	e422                	sd	s0,8(sp)
  c6:	0800                	addi	s0,sp,16
  for(; *s; s++)
  c8:	00054783          	lbu	a5,0(a0)
  cc:	cb99                	beqz	a5,e2 <strchr+0x20>
    if(*s == c)
  ce:	00f58763          	beq	a1,a5,dc <strchr+0x1a>
  for(; *s; s++)
  d2:	0505                	addi	a0,a0,1
  d4:	00054783          	lbu	a5,0(a0)
  d8:	fbfd                	bnez	a5,ce <strchr+0xc>
      return (char*)s;
  return 0;
  da:	4501                	li	a0,0
}
  dc:	6422                	ld	s0,8(sp)
  de:	0141                	addi	sp,sp,16
  e0:	8082                	ret
  return 0;
  e2:	4501                	li	a0,0
  e4:	bfe5                	j	dc <strchr+0x1a>

00000000000000e6 <gets>:

char*
gets(char *buf, int max)
{
  e6:	711d                	addi	sp,sp,-96
  e8:	ec86                	sd	ra,88(sp)
  ea:	e8a2                	sd	s0,80(sp)
  ec:	e4a6                	sd	s1,72(sp)
  ee:	e0ca                	sd	s2,64(sp)
  f0:	fc4e                	sd	s3,56(sp)
  f2:	f852                	sd	s4,48(sp)
  f4:	f456                	sd	s5,40(sp)
  f6:	f05a                	sd	s6,32(sp)
  f8:	ec5e                	sd	s7,24(sp)
  fa:	1080                	addi	s0,sp,96
  fc:	8baa                	mv	s7,a0
  fe:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 100:	892a                	mv	s2,a0
 102:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 104:	4aa9                	li	s5,10
 106:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 108:	89a6                	mv	s3,s1
 10a:	2485                	addiw	s1,s1,1
 10c:	0344d863          	bge	s1,s4,13c <gets+0x56>
    cc = read(0, &c, 1);
 110:	4605                	li	a2,1
 112:	faf40593          	addi	a1,s0,-81
 116:	4501                	li	a0,0
 118:	00000097          	auipc	ra,0x0
 11c:	19c080e7          	jalr	412(ra) # 2b4 <read>
    if(cc < 1)
 120:	00a05e63          	blez	a0,13c <gets+0x56>
    buf[i++] = c;
 124:	faf44783          	lbu	a5,-81(s0)
 128:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 12c:	01578763          	beq	a5,s5,13a <gets+0x54>
 130:	0905                	addi	s2,s2,1
 132:	fd679be3          	bne	a5,s6,108 <gets+0x22>
  for(i=0; i+1 < max; ){
 136:	89a6                	mv	s3,s1
 138:	a011                	j	13c <gets+0x56>
 13a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 13c:	99de                	add	s3,s3,s7
 13e:	00098023          	sb	zero,0(s3)
  return buf;
}
 142:	855e                	mv	a0,s7
 144:	60e6                	ld	ra,88(sp)
 146:	6446                	ld	s0,80(sp)
 148:	64a6                	ld	s1,72(sp)
 14a:	6906                	ld	s2,64(sp)
 14c:	79e2                	ld	s3,56(sp)
 14e:	7a42                	ld	s4,48(sp)
 150:	7aa2                	ld	s5,40(sp)
 152:	7b02                	ld	s6,32(sp)
 154:	6be2                	ld	s7,24(sp)
 156:	6125                	addi	sp,sp,96
 158:	8082                	ret

000000000000015a <stat>:

int
stat(const char *n, struct stat *st)
{
 15a:	1101                	addi	sp,sp,-32
 15c:	ec06                	sd	ra,24(sp)
 15e:	e822                	sd	s0,16(sp)
 160:	e426                	sd	s1,8(sp)
 162:	e04a                	sd	s2,0(sp)
 164:	1000                	addi	s0,sp,32
 166:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 168:	4581                	li	a1,0
 16a:	00000097          	auipc	ra,0x0
 16e:	172080e7          	jalr	370(ra) # 2dc <open>
  if(fd < 0)
 172:	02054563          	bltz	a0,19c <stat+0x42>
 176:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 178:	85ca                	mv	a1,s2
 17a:	00000097          	auipc	ra,0x0
 17e:	17a080e7          	jalr	378(ra) # 2f4 <fstat>
 182:	892a                	mv	s2,a0
  close(fd);
 184:	8526                	mv	a0,s1
 186:	00000097          	auipc	ra,0x0
 18a:	13e080e7          	jalr	318(ra) # 2c4 <close>
  return r;
}
 18e:	854a                	mv	a0,s2
 190:	60e2                	ld	ra,24(sp)
 192:	6442                	ld	s0,16(sp)
 194:	64a2                	ld	s1,8(sp)
 196:	6902                	ld	s2,0(sp)
 198:	6105                	addi	sp,sp,32
 19a:	8082                	ret
    return -1;
 19c:	597d                	li	s2,-1
 19e:	bfc5                	j	18e <stat+0x34>

00000000000001a0 <atoi>:

int
atoi(const char *s)
{
 1a0:	1141                	addi	sp,sp,-16
 1a2:	e422                	sd	s0,8(sp)
 1a4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1a6:	00054603          	lbu	a2,0(a0)
 1aa:	fd06079b          	addiw	a5,a2,-48
 1ae:	0ff7f793          	andi	a5,a5,255
 1b2:	4725                	li	a4,9
 1b4:	02f76963          	bltu	a4,a5,1e6 <atoi+0x46>
 1b8:	86aa                	mv	a3,a0
  n = 0;
 1ba:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1bc:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1be:	0685                	addi	a3,a3,1
 1c0:	0025179b          	slliw	a5,a0,0x2
 1c4:	9fa9                	addw	a5,a5,a0
 1c6:	0017979b          	slliw	a5,a5,0x1
 1ca:	9fb1                	addw	a5,a5,a2
 1cc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1d0:	0006c603          	lbu	a2,0(a3)
 1d4:	fd06071b          	addiw	a4,a2,-48
 1d8:	0ff77713          	andi	a4,a4,255
 1dc:	fee5f1e3          	bgeu	a1,a4,1be <atoi+0x1e>
  return n;
}
 1e0:	6422                	ld	s0,8(sp)
 1e2:	0141                	addi	sp,sp,16
 1e4:	8082                	ret
  n = 0;
 1e6:	4501                	li	a0,0
 1e8:	bfe5                	j	1e0 <atoi+0x40>

00000000000001ea <memmove>:

// #define memcpy memmove

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1ea:	1141                	addi	sp,sp,-16
 1ec:	e422                	sd	s0,8(sp)
 1ee:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1f0:	02b57463          	bgeu	a0,a1,218 <memmove+0x2e>
    while(n-- > 0)
 1f4:	00c05f63          	blez	a2,212 <memmove+0x28>
 1f8:	1602                	slli	a2,a2,0x20
 1fa:	9201                	srli	a2,a2,0x20
 1fc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 200:	872a                	mv	a4,a0
      *dst++ = *src++;
 202:	0585                	addi	a1,a1,1
 204:	0705                	addi	a4,a4,1
 206:	fff5c683          	lbu	a3,-1(a1)
 20a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 20e:	fee79ae3          	bne	a5,a4,202 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 212:	6422                	ld	s0,8(sp)
 214:	0141                	addi	sp,sp,16
 216:	8082                	ret
    dst += n;
 218:	00c50733          	add	a4,a0,a2
    src += n;
 21c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 21e:	fec05ae3          	blez	a2,212 <memmove+0x28>
 222:	fff6079b          	addiw	a5,a2,-1
 226:	1782                	slli	a5,a5,0x20
 228:	9381                	srli	a5,a5,0x20
 22a:	fff7c793          	not	a5,a5
 22e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 230:	15fd                	addi	a1,a1,-1
 232:	177d                	addi	a4,a4,-1
 234:	0005c683          	lbu	a3,0(a1)
 238:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 23c:	fee79ae3          	bne	a5,a4,230 <memmove+0x46>
 240:	bfc9                	j	212 <memmove+0x28>

0000000000000242 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 242:	1141                	addi	sp,sp,-16
 244:	e422                	sd	s0,8(sp)
 246:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 248:	ca05                	beqz	a2,278 <memcmp+0x36>
 24a:	fff6069b          	addiw	a3,a2,-1
 24e:	1682                	slli	a3,a3,0x20
 250:	9281                	srli	a3,a3,0x20
 252:	0685                	addi	a3,a3,1
 254:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 256:	00054783          	lbu	a5,0(a0)
 25a:	0005c703          	lbu	a4,0(a1)
 25e:	00e79863          	bne	a5,a4,26e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 262:	0505                	addi	a0,a0,1
    p2++;
 264:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 266:	fed518e3          	bne	a0,a3,256 <memcmp+0x14>
  }
  return 0;
 26a:	4501                	li	a0,0
 26c:	a019                	j	272 <memcmp+0x30>
      return *p1 - *p2;
 26e:	40e7853b          	subw	a0,a5,a4
}
 272:	6422                	ld	s0,8(sp)
 274:	0141                	addi	sp,sp,16
 276:	8082                	ret
  return 0;
 278:	4501                	li	a0,0
 27a:	bfe5                	j	272 <memcmp+0x30>

000000000000027c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 27c:	1141                	addi	sp,sp,-16
 27e:	e406                	sd	ra,8(sp)
 280:	e022                	sd	s0,0(sp)
 282:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 284:	00000097          	auipc	ra,0x0
 288:	f66080e7          	jalr	-154(ra) # 1ea <memmove>
}
 28c:	60a2                	ld	ra,8(sp)
 28e:	6402                	ld	s0,0(sp)
 290:	0141                	addi	sp,sp,16
 292:	8082                	ret

0000000000000294 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 294:	4885                	li	a7,1
 ecall
 296:	00000073          	ecall
 ret
 29a:	8082                	ret

000000000000029c <exit>:
.global exit
exit:
 li a7, SYS_exit
 29c:	4889                	li	a7,2
 ecall
 29e:	00000073          	ecall
 ret
 2a2:	8082                	ret

00000000000002a4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2a4:	488d                	li	a7,3
 ecall
 2a6:	00000073          	ecall
 ret
 2aa:	8082                	ret

00000000000002ac <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2ac:	4891                	li	a7,4
 ecall
 2ae:	00000073          	ecall
 ret
 2b2:	8082                	ret

00000000000002b4 <read>:
.global read
read:
 li a7, SYS_read
 2b4:	4895                	li	a7,5
 ecall
 2b6:	00000073          	ecall
 ret
 2ba:	8082                	ret

00000000000002bc <write>:
.global write
write:
 li a7, SYS_write
 2bc:	48c1                	li	a7,16
 ecall
 2be:	00000073          	ecall
 ret
 2c2:	8082                	ret

00000000000002c4 <close>:
.global close
close:
 li a7, SYS_close
 2c4:	48d5                	li	a7,21
 ecall
 2c6:	00000073          	ecall
 ret
 2ca:	8082                	ret

00000000000002cc <kill>:
.global kill
kill:
 li a7, SYS_kill
 2cc:	4899                	li	a7,6
 ecall
 2ce:	00000073          	ecall
 ret
 2d2:	8082                	ret

00000000000002d4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2d4:	489d                	li	a7,7
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <open>:
.global open
open:
 li a7, SYS_open
 2dc:	48bd                	li	a7,15
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2e4:	48c5                	li	a7,17
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2ec:	48c9                	li	a7,18
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2f4:	48a1                	li	a7,8
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <link>:
.global link
link:
 li a7, SYS_link
 2fc:	48cd                	li	a7,19
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 304:	48d1                	li	a7,20
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 30c:	48a5                	li	a7,9
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <dup>:
.global dup
dup:
 li a7, SYS_dup
 314:	48a9                	li	a7,10
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 31c:	48ad                	li	a7,11
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 324:	48b1                	li	a7,12
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 32c:	48b5                	li	a7,13
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 334:	48b9                	li	a7,14
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <trace>:
.global trace
trace:
 li a7, SYS_trace
 33c:	48d9                	li	a7,22
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 344:	1101                	addi	sp,sp,-32
 346:	ec06                	sd	ra,24(sp)
 348:	e822                	sd	s0,16(sp)
 34a:	1000                	addi	s0,sp,32
 34c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 350:	4605                	li	a2,1
 352:	fef40593          	addi	a1,s0,-17
 356:	00000097          	auipc	ra,0x0
 35a:	f66080e7          	jalr	-154(ra) # 2bc <write>
}
 35e:	60e2                	ld	ra,24(sp)
 360:	6442                	ld	s0,16(sp)
 362:	6105                	addi	sp,sp,32
 364:	8082                	ret

0000000000000366 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 366:	7139                	addi	sp,sp,-64
 368:	fc06                	sd	ra,56(sp)
 36a:	f822                	sd	s0,48(sp)
 36c:	f426                	sd	s1,40(sp)
 36e:	f04a                	sd	s2,32(sp)
 370:	ec4e                	sd	s3,24(sp)
 372:	0080                	addi	s0,sp,64
 374:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 376:	c299                	beqz	a3,37c <printint+0x16>
 378:	0805c863          	bltz	a1,408 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 37c:	2581                	sext.w	a1,a1
  neg = 0;
 37e:	4881                	li	a7,0
 380:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 384:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 386:	2601                	sext.w	a2,a2
 388:	00000517          	auipc	a0,0x0
 38c:	77850513          	addi	a0,a0,1912 # b00 <digits>
 390:	883a                	mv	a6,a4
 392:	2705                	addiw	a4,a4,1
 394:	02c5f7bb          	remuw	a5,a1,a2
 398:	1782                	slli	a5,a5,0x20
 39a:	9381                	srli	a5,a5,0x20
 39c:	97aa                	add	a5,a5,a0
 39e:	0007c783          	lbu	a5,0(a5)
 3a2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3a6:	0005879b          	sext.w	a5,a1
 3aa:	02c5d5bb          	divuw	a1,a1,a2
 3ae:	0685                	addi	a3,a3,1
 3b0:	fec7f0e3          	bgeu	a5,a2,390 <printint+0x2a>
  if(neg)
 3b4:	00088b63          	beqz	a7,3ca <printint+0x64>
    buf[i++] = '-';
 3b8:	fd040793          	addi	a5,s0,-48
 3bc:	973e                	add	a4,a4,a5
 3be:	02d00793          	li	a5,45
 3c2:	fef70823          	sb	a5,-16(a4)
 3c6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3ca:	02e05863          	blez	a4,3fa <printint+0x94>
 3ce:	fc040793          	addi	a5,s0,-64
 3d2:	00e78933          	add	s2,a5,a4
 3d6:	fff78993          	addi	s3,a5,-1
 3da:	99ba                	add	s3,s3,a4
 3dc:	377d                	addiw	a4,a4,-1
 3de:	1702                	slli	a4,a4,0x20
 3e0:	9301                	srli	a4,a4,0x20
 3e2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3e6:	fff94583          	lbu	a1,-1(s2)
 3ea:	8526                	mv	a0,s1
 3ec:	00000097          	auipc	ra,0x0
 3f0:	f58080e7          	jalr	-168(ra) # 344 <putc>
  while(--i >= 0)
 3f4:	197d                	addi	s2,s2,-1
 3f6:	ff3918e3          	bne	s2,s3,3e6 <printint+0x80>
}
 3fa:	70e2                	ld	ra,56(sp)
 3fc:	7442                	ld	s0,48(sp)
 3fe:	74a2                	ld	s1,40(sp)
 400:	7902                	ld	s2,32(sp)
 402:	69e2                	ld	s3,24(sp)
 404:	6121                	addi	sp,sp,64
 406:	8082                	ret
    x = -xx;
 408:	40b005bb          	negw	a1,a1
    neg = 1;
 40c:	4885                	li	a7,1
    x = -xx;
 40e:	bf8d                	j	380 <printint+0x1a>

0000000000000410 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 410:	7119                	addi	sp,sp,-128
 412:	fc86                	sd	ra,120(sp)
 414:	f8a2                	sd	s0,112(sp)
 416:	f4a6                	sd	s1,104(sp)
 418:	f0ca                	sd	s2,96(sp)
 41a:	ecce                	sd	s3,88(sp)
 41c:	e8d2                	sd	s4,80(sp)
 41e:	e4d6                	sd	s5,72(sp)
 420:	e0da                	sd	s6,64(sp)
 422:	fc5e                	sd	s7,56(sp)
 424:	f862                	sd	s8,48(sp)
 426:	f466                	sd	s9,40(sp)
 428:	f06a                	sd	s10,32(sp)
 42a:	ec6e                	sd	s11,24(sp)
 42c:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 42e:	0005c903          	lbu	s2,0(a1)
 432:	18090f63          	beqz	s2,5d0 <vprintf+0x1c0>
 436:	8aaa                	mv	s5,a0
 438:	8b32                	mv	s6,a2
 43a:	00158493          	addi	s1,a1,1
  state = 0;
 43e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 440:	02500a13          	li	s4,37
      if(c == 'd'){
 444:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 448:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 44c:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 450:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 454:	00000b97          	auipc	s7,0x0
 458:	6acb8b93          	addi	s7,s7,1708 # b00 <digits>
 45c:	a839                	j	47a <vprintf+0x6a>
        putc(fd, c);
 45e:	85ca                	mv	a1,s2
 460:	8556                	mv	a0,s5
 462:	00000097          	auipc	ra,0x0
 466:	ee2080e7          	jalr	-286(ra) # 344 <putc>
 46a:	a019                	j	470 <vprintf+0x60>
    } else if(state == '%'){
 46c:	01498f63          	beq	s3,s4,48a <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 470:	0485                	addi	s1,s1,1
 472:	fff4c903          	lbu	s2,-1(s1)
 476:	14090d63          	beqz	s2,5d0 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 47a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 47e:	fe0997e3          	bnez	s3,46c <vprintf+0x5c>
      if(c == '%'){
 482:	fd479ee3          	bne	a5,s4,45e <vprintf+0x4e>
        state = '%';
 486:	89be                	mv	s3,a5
 488:	b7e5                	j	470 <vprintf+0x60>
      if(c == 'd'){
 48a:	05878063          	beq	a5,s8,4ca <vprintf+0xba>
      } else if(c == 'l') {
 48e:	05978c63          	beq	a5,s9,4e6 <vprintf+0xd6>
      } else if(c == 'x') {
 492:	07a78863          	beq	a5,s10,502 <vprintf+0xf2>
      } else if(c == 'p') {
 496:	09b78463          	beq	a5,s11,51e <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 49a:	07300713          	li	a4,115
 49e:	0ce78663          	beq	a5,a4,56a <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4a2:	06300713          	li	a4,99
 4a6:	0ee78e63          	beq	a5,a4,5a2 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 4aa:	11478863          	beq	a5,s4,5ba <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4ae:	85d2                	mv	a1,s4
 4b0:	8556                	mv	a0,s5
 4b2:	00000097          	auipc	ra,0x0
 4b6:	e92080e7          	jalr	-366(ra) # 344 <putc>
        putc(fd, c);
 4ba:	85ca                	mv	a1,s2
 4bc:	8556                	mv	a0,s5
 4be:	00000097          	auipc	ra,0x0
 4c2:	e86080e7          	jalr	-378(ra) # 344 <putc>
      }
      state = 0;
 4c6:	4981                	li	s3,0
 4c8:	b765                	j	470 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 4ca:	008b0913          	addi	s2,s6,8
 4ce:	4685                	li	a3,1
 4d0:	4629                	li	a2,10
 4d2:	000b2583          	lw	a1,0(s6)
 4d6:	8556                	mv	a0,s5
 4d8:	00000097          	auipc	ra,0x0
 4dc:	e8e080e7          	jalr	-370(ra) # 366 <printint>
 4e0:	8b4a                	mv	s6,s2
      state = 0;
 4e2:	4981                	li	s3,0
 4e4:	b771                	j	470 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4e6:	008b0913          	addi	s2,s6,8
 4ea:	4681                	li	a3,0
 4ec:	4629                	li	a2,10
 4ee:	000b2583          	lw	a1,0(s6)
 4f2:	8556                	mv	a0,s5
 4f4:	00000097          	auipc	ra,0x0
 4f8:	e72080e7          	jalr	-398(ra) # 366 <printint>
 4fc:	8b4a                	mv	s6,s2
      state = 0;
 4fe:	4981                	li	s3,0
 500:	bf85                	j	470 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 502:	008b0913          	addi	s2,s6,8
 506:	4681                	li	a3,0
 508:	4641                	li	a2,16
 50a:	000b2583          	lw	a1,0(s6)
 50e:	8556                	mv	a0,s5
 510:	00000097          	auipc	ra,0x0
 514:	e56080e7          	jalr	-426(ra) # 366 <printint>
 518:	8b4a                	mv	s6,s2
      state = 0;
 51a:	4981                	li	s3,0
 51c:	bf91                	j	470 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 51e:	008b0793          	addi	a5,s6,8
 522:	f8f43423          	sd	a5,-120(s0)
 526:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 52a:	03000593          	li	a1,48
 52e:	8556                	mv	a0,s5
 530:	00000097          	auipc	ra,0x0
 534:	e14080e7          	jalr	-492(ra) # 344 <putc>
  putc(fd, 'x');
 538:	85ea                	mv	a1,s10
 53a:	8556                	mv	a0,s5
 53c:	00000097          	auipc	ra,0x0
 540:	e08080e7          	jalr	-504(ra) # 344 <putc>
 544:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 546:	03c9d793          	srli	a5,s3,0x3c
 54a:	97de                	add	a5,a5,s7
 54c:	0007c583          	lbu	a1,0(a5)
 550:	8556                	mv	a0,s5
 552:	00000097          	auipc	ra,0x0
 556:	df2080e7          	jalr	-526(ra) # 344 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 55a:	0992                	slli	s3,s3,0x4
 55c:	397d                	addiw	s2,s2,-1
 55e:	fe0914e3          	bnez	s2,546 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 562:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 566:	4981                	li	s3,0
 568:	b721                	j	470 <vprintf+0x60>
        s = va_arg(ap, char*);
 56a:	008b0993          	addi	s3,s6,8
 56e:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 572:	02090163          	beqz	s2,594 <vprintf+0x184>
        while(*s != 0){
 576:	00094583          	lbu	a1,0(s2)
 57a:	c9a1                	beqz	a1,5ca <vprintf+0x1ba>
          putc(fd, *s);
 57c:	8556                	mv	a0,s5
 57e:	00000097          	auipc	ra,0x0
 582:	dc6080e7          	jalr	-570(ra) # 344 <putc>
          s++;
 586:	0905                	addi	s2,s2,1
        while(*s != 0){
 588:	00094583          	lbu	a1,0(s2)
 58c:	f9e5                	bnez	a1,57c <vprintf+0x16c>
        s = va_arg(ap, char*);
 58e:	8b4e                	mv	s6,s3
      state = 0;
 590:	4981                	li	s3,0
 592:	bdf9                	j	470 <vprintf+0x60>
          s = "(null)";
 594:	00000917          	auipc	s2,0x0
 598:	56490913          	addi	s2,s2,1380 # af8 <strstr+0x68>
        while(*s != 0){
 59c:	02800593          	li	a1,40
 5a0:	bff1                	j	57c <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 5a2:	008b0913          	addi	s2,s6,8
 5a6:	000b4583          	lbu	a1,0(s6)
 5aa:	8556                	mv	a0,s5
 5ac:	00000097          	auipc	ra,0x0
 5b0:	d98080e7          	jalr	-616(ra) # 344 <putc>
 5b4:	8b4a                	mv	s6,s2
      state = 0;
 5b6:	4981                	li	s3,0
 5b8:	bd65                	j	470 <vprintf+0x60>
        putc(fd, c);
 5ba:	85d2                	mv	a1,s4
 5bc:	8556                	mv	a0,s5
 5be:	00000097          	auipc	ra,0x0
 5c2:	d86080e7          	jalr	-634(ra) # 344 <putc>
      state = 0;
 5c6:	4981                	li	s3,0
 5c8:	b565                	j	470 <vprintf+0x60>
        s = va_arg(ap, char*);
 5ca:	8b4e                	mv	s6,s3
      state = 0;
 5cc:	4981                	li	s3,0
 5ce:	b54d                	j	470 <vprintf+0x60>
    }
  }
}
 5d0:	70e6                	ld	ra,120(sp)
 5d2:	7446                	ld	s0,112(sp)
 5d4:	74a6                	ld	s1,104(sp)
 5d6:	7906                	ld	s2,96(sp)
 5d8:	69e6                	ld	s3,88(sp)
 5da:	6a46                	ld	s4,80(sp)
 5dc:	6aa6                	ld	s5,72(sp)
 5de:	6b06                	ld	s6,64(sp)
 5e0:	7be2                	ld	s7,56(sp)
 5e2:	7c42                	ld	s8,48(sp)
 5e4:	7ca2                	ld	s9,40(sp)
 5e6:	7d02                	ld	s10,32(sp)
 5e8:	6de2                	ld	s11,24(sp)
 5ea:	6109                	addi	sp,sp,128
 5ec:	8082                	ret

00000000000005ee <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5ee:	715d                	addi	sp,sp,-80
 5f0:	ec06                	sd	ra,24(sp)
 5f2:	e822                	sd	s0,16(sp)
 5f4:	1000                	addi	s0,sp,32
 5f6:	e010                	sd	a2,0(s0)
 5f8:	e414                	sd	a3,8(s0)
 5fa:	e818                	sd	a4,16(s0)
 5fc:	ec1c                	sd	a5,24(s0)
 5fe:	03043023          	sd	a6,32(s0)
 602:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 606:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 60a:	8622                	mv	a2,s0
 60c:	00000097          	auipc	ra,0x0
 610:	e04080e7          	jalr	-508(ra) # 410 <vprintf>
}
 614:	60e2                	ld	ra,24(sp)
 616:	6442                	ld	s0,16(sp)
 618:	6161                	addi	sp,sp,80
 61a:	8082                	ret

000000000000061c <printf>:

void
printf(const char *fmt, ...)
{
 61c:	711d                	addi	sp,sp,-96
 61e:	ec06                	sd	ra,24(sp)
 620:	e822                	sd	s0,16(sp)
 622:	1000                	addi	s0,sp,32
 624:	e40c                	sd	a1,8(s0)
 626:	e810                	sd	a2,16(s0)
 628:	ec14                	sd	a3,24(s0)
 62a:	f018                	sd	a4,32(s0)
 62c:	f41c                	sd	a5,40(s0)
 62e:	03043823          	sd	a6,48(s0)
 632:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 636:	00840613          	addi	a2,s0,8
 63a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 63e:	85aa                	mv	a1,a0
 640:	4505                	li	a0,1
 642:	00000097          	auipc	ra,0x0
 646:	dce080e7          	jalr	-562(ra) # 410 <vprintf>
}
 64a:	60e2                	ld	ra,24(sp)
 64c:	6442                	ld	s0,16(sp)
 64e:	6125                	addi	sp,sp,96
 650:	8082                	ret

0000000000000652 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 652:	1141                	addi	sp,sp,-16
 654:	e422                	sd	s0,8(sp)
 656:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 658:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 65c:	00000797          	auipc	a5,0x0
 660:	55c7b783          	ld	a5,1372(a5) # bb8 <freep>
 664:	a805                	j	694 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 666:	4618                	lw	a4,8(a2)
 668:	9db9                	addw	a1,a1,a4
 66a:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 66e:	6398                	ld	a4,0(a5)
 670:	6318                	ld	a4,0(a4)
 672:	fee53823          	sd	a4,-16(a0)
 676:	a091                	j	6ba <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 678:	ff852703          	lw	a4,-8(a0)
 67c:	9e39                	addw	a2,a2,a4
 67e:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 680:	ff053703          	ld	a4,-16(a0)
 684:	e398                	sd	a4,0(a5)
 686:	a099                	j	6cc <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 688:	6398                	ld	a4,0(a5)
 68a:	00e7e463          	bltu	a5,a4,692 <free+0x40>
 68e:	00e6ea63          	bltu	a3,a4,6a2 <free+0x50>
{
 692:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 694:	fed7fae3          	bgeu	a5,a3,688 <free+0x36>
 698:	6398                	ld	a4,0(a5)
 69a:	00e6e463          	bltu	a3,a4,6a2 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 69e:	fee7eae3          	bltu	a5,a4,692 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 6a2:	ff852583          	lw	a1,-8(a0)
 6a6:	6390                	ld	a2,0(a5)
 6a8:	02059713          	slli	a4,a1,0x20
 6ac:	9301                	srli	a4,a4,0x20
 6ae:	0712                	slli	a4,a4,0x4
 6b0:	9736                	add	a4,a4,a3
 6b2:	fae60ae3          	beq	a2,a4,666 <free+0x14>
    bp->s.ptr = p->s.ptr;
 6b6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6ba:	4790                	lw	a2,8(a5)
 6bc:	02061713          	slli	a4,a2,0x20
 6c0:	9301                	srli	a4,a4,0x20
 6c2:	0712                	slli	a4,a4,0x4
 6c4:	973e                	add	a4,a4,a5
 6c6:	fae689e3          	beq	a3,a4,678 <free+0x26>
  } else
    p->s.ptr = bp;
 6ca:	e394                	sd	a3,0(a5)
  freep = p;
 6cc:	00000717          	auipc	a4,0x0
 6d0:	4ef73623          	sd	a5,1260(a4) # bb8 <freep>
}
 6d4:	6422                	ld	s0,8(sp)
 6d6:	0141                	addi	sp,sp,16
 6d8:	8082                	ret

00000000000006da <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6da:	7139                	addi	sp,sp,-64
 6dc:	fc06                	sd	ra,56(sp)
 6de:	f822                	sd	s0,48(sp)
 6e0:	f426                	sd	s1,40(sp)
 6e2:	f04a                	sd	s2,32(sp)
 6e4:	ec4e                	sd	s3,24(sp)
 6e6:	e852                	sd	s4,16(sp)
 6e8:	e456                	sd	s5,8(sp)
 6ea:	e05a                	sd	s6,0(sp)
 6ec:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6ee:	02051493          	slli	s1,a0,0x20
 6f2:	9081                	srli	s1,s1,0x20
 6f4:	04bd                	addi	s1,s1,15
 6f6:	8091                	srli	s1,s1,0x4
 6f8:	0014899b          	addiw	s3,s1,1
 6fc:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 6fe:	00000517          	auipc	a0,0x0
 702:	4ba53503          	ld	a0,1210(a0) # bb8 <freep>
 706:	c515                	beqz	a0,732 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 708:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 70a:	4798                	lw	a4,8(a5)
 70c:	02977f63          	bgeu	a4,s1,74a <malloc+0x70>
 710:	8a4e                	mv	s4,s3
 712:	0009871b          	sext.w	a4,s3
 716:	6685                	lui	a3,0x1
 718:	00d77363          	bgeu	a4,a3,71e <malloc+0x44>
 71c:	6a05                	lui	s4,0x1
 71e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 722:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 726:	00000917          	auipc	s2,0x0
 72a:	49290913          	addi	s2,s2,1170 # bb8 <freep>
  if(p == (char*)-1)
 72e:	5afd                	li	s5,-1
 730:	a88d                	j	7a2 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 732:	00000797          	auipc	a5,0x0
 736:	48e78793          	addi	a5,a5,1166 # bc0 <base>
 73a:	00000717          	auipc	a4,0x0
 73e:	46f73f23          	sd	a5,1150(a4) # bb8 <freep>
 742:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 744:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 748:	b7e1                	j	710 <malloc+0x36>
      if(p->s.size == nunits)
 74a:	02e48b63          	beq	s1,a4,780 <malloc+0xa6>
        p->s.size -= nunits;
 74e:	4137073b          	subw	a4,a4,s3
 752:	c798                	sw	a4,8(a5)
        p += p->s.size;
 754:	1702                	slli	a4,a4,0x20
 756:	9301                	srli	a4,a4,0x20
 758:	0712                	slli	a4,a4,0x4
 75a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 75c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 760:	00000717          	auipc	a4,0x0
 764:	44a73c23          	sd	a0,1112(a4) # bb8 <freep>
      return (void*)(p + 1);
 768:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 76c:	70e2                	ld	ra,56(sp)
 76e:	7442                	ld	s0,48(sp)
 770:	74a2                	ld	s1,40(sp)
 772:	7902                	ld	s2,32(sp)
 774:	69e2                	ld	s3,24(sp)
 776:	6a42                	ld	s4,16(sp)
 778:	6aa2                	ld	s5,8(sp)
 77a:	6b02                	ld	s6,0(sp)
 77c:	6121                	addi	sp,sp,64
 77e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 780:	6398                	ld	a4,0(a5)
 782:	e118                	sd	a4,0(a0)
 784:	bff1                	j	760 <malloc+0x86>
  hp->s.size = nu;
 786:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 78a:	0541                	addi	a0,a0,16
 78c:	00000097          	auipc	ra,0x0
 790:	ec6080e7          	jalr	-314(ra) # 652 <free>
  return freep;
 794:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 798:	d971                	beqz	a0,76c <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 79a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 79c:	4798                	lw	a4,8(a5)
 79e:	fa9776e3          	bgeu	a4,s1,74a <malloc+0x70>
    if(p == freep)
 7a2:	00093703          	ld	a4,0(s2)
 7a6:	853e                	mv	a0,a5
 7a8:	fef719e3          	bne	a4,a5,79a <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 7ac:	8552                	mv	a0,s4
 7ae:	00000097          	auipc	ra,0x0
 7b2:	b76080e7          	jalr	-1162(ra) # 324 <sbrk>
  if(p == (char*)-1)
 7b6:	fd5518e3          	bne	a0,s5,786 <malloc+0xac>
        return 0;
 7ba:	4501                	li	a0,0
 7bc:	bf45                	j	76c <malloc+0x92>

00000000000007be <Pipe>:
#include "kernel/stat.h"
#include "user.h"
#include "wrapper.h"
int strncmp(const char*s, const char*pat,int n);

int Pipe(int *p) {
 7be:	1101                	addi	sp,sp,-32
 7c0:	ec06                	sd	ra,24(sp)
 7c2:	e822                	sd	s0,16(sp)
 7c4:	e426                	sd	s1,8(sp)
 7c6:	1000                	addi	s0,sp,32
  i32 res = pipe(p);
 7c8:	00000097          	auipc	ra,0x0
 7cc:	ae4080e7          	jalr	-1308(ra) # 2ac <pipe>
 7d0:	84aa                	mv	s1,a0
  if (res < 0) {
 7d2:	00054863          	bltz	a0,7e2 <Pipe+0x24>
    fprintf(2, "pipe creation error");
  }
  return res;
}
 7d6:	8526                	mv	a0,s1
 7d8:	60e2                	ld	ra,24(sp)
 7da:	6442                	ld	s0,16(sp)
 7dc:	64a2                	ld	s1,8(sp)
 7de:	6105                	addi	sp,sp,32
 7e0:	8082                	ret
    fprintf(2, "pipe creation error");
 7e2:	00000597          	auipc	a1,0x0
 7e6:	33658593          	addi	a1,a1,822 # b18 <digits+0x18>
 7ea:	4509                	li	a0,2
 7ec:	00000097          	auipc	ra,0x0
 7f0:	e02080e7          	jalr	-510(ra) # 5ee <fprintf>
 7f4:	b7cd                	j	7d6 <Pipe+0x18>

00000000000007f6 <Write>:

int Write(int fd, void *buf, int count){
 7f6:	1141                	addi	sp,sp,-16
 7f8:	e406                	sd	ra,8(sp)
 7fa:	e022                	sd	s0,0(sp)
 7fc:	0800                	addi	s0,sp,16
  i32 res = write(fd, buf, count);
 7fe:	00000097          	auipc	ra,0x0
 802:	abe080e7          	jalr	-1346(ra) # 2bc <write>
  if (res < 0) {
 806:	00054663          	bltz	a0,812 <Write+0x1c>
    fprintf(2, "write error");
    exit(0);
  }
  return res;
}
 80a:	60a2                	ld	ra,8(sp)
 80c:	6402                	ld	s0,0(sp)
 80e:	0141                	addi	sp,sp,16
 810:	8082                	ret
    fprintf(2, "write error");
 812:	00000597          	auipc	a1,0x0
 816:	31e58593          	addi	a1,a1,798 # b30 <digits+0x30>
 81a:	4509                	li	a0,2
 81c:	00000097          	auipc	ra,0x0
 820:	dd2080e7          	jalr	-558(ra) # 5ee <fprintf>
    exit(0);
 824:	4501                	li	a0,0
 826:	00000097          	auipc	ra,0x0
 82a:	a76080e7          	jalr	-1418(ra) # 29c <exit>

000000000000082e <Read>:



int Read(int fd,  void*buf, int count){
 82e:	1141                	addi	sp,sp,-16
 830:	e406                	sd	ra,8(sp)
 832:	e022                	sd	s0,0(sp)
 834:	0800                	addi	s0,sp,16
  i32 res = read(fd, buf, count);
 836:	00000097          	auipc	ra,0x0
 83a:	a7e080e7          	jalr	-1410(ra) # 2b4 <read>
  if (res < 0) {
 83e:	00054663          	bltz	a0,84a <Read+0x1c>
    fprintf(2, "read error");
    exit(0);
  }
  return res;
}
 842:	60a2                	ld	ra,8(sp)
 844:	6402                	ld	s0,0(sp)
 846:	0141                	addi	sp,sp,16
 848:	8082                	ret
    fprintf(2, "read error");
 84a:	00000597          	auipc	a1,0x0
 84e:	2f658593          	addi	a1,a1,758 # b40 <digits+0x40>
 852:	4509                	li	a0,2
 854:	00000097          	auipc	ra,0x0
 858:	d9a080e7          	jalr	-614(ra) # 5ee <fprintf>
    exit(0);
 85c:	4501                	li	a0,0
 85e:	00000097          	auipc	ra,0x0
 862:	a3e080e7          	jalr	-1474(ra) # 29c <exit>

0000000000000866 <Open>:


int Open(const char* path, int flag){
 866:	1141                	addi	sp,sp,-16
 868:	e406                	sd	ra,8(sp)
 86a:	e022                	sd	s0,0(sp)
 86c:	0800                	addi	s0,sp,16
  i32 res = open(path, flag);
 86e:	00000097          	auipc	ra,0x0
 872:	a6e080e7          	jalr	-1426(ra) # 2dc <open>
  if (res < 0) {
 876:	00054663          	bltz	a0,882 <Open+0x1c>
    fprintf(2, "open error");
    exit(0);
  }
  return res;
}
 87a:	60a2                	ld	ra,8(sp)
 87c:	6402                	ld	s0,0(sp)
 87e:	0141                	addi	sp,sp,16
 880:	8082                	ret
    fprintf(2, "open error");
 882:	00000597          	auipc	a1,0x0
 886:	2ce58593          	addi	a1,a1,718 # b50 <digits+0x50>
 88a:	4509                	li	a0,2
 88c:	00000097          	auipc	ra,0x0
 890:	d62080e7          	jalr	-670(ra) # 5ee <fprintf>
    exit(0);
 894:	4501                	li	a0,0
 896:	00000097          	auipc	ra,0x0
 89a:	a06080e7          	jalr	-1530(ra) # 29c <exit>

000000000000089e <Fstat>:


int Fstat(int fd, stat_t *st){
 89e:	1141                	addi	sp,sp,-16
 8a0:	e406                	sd	ra,8(sp)
 8a2:	e022                	sd	s0,0(sp)
 8a4:	0800                	addi	s0,sp,16
  i32 res = fstat(fd, st);
 8a6:	00000097          	auipc	ra,0x0
 8aa:	a4e080e7          	jalr	-1458(ra) # 2f4 <fstat>
  if (res < 0) {
 8ae:	00054663          	bltz	a0,8ba <Fstat+0x1c>
    fprintf(2, "get file stat error");
    exit(0);
  }
  return res;
}
 8b2:	60a2                	ld	ra,8(sp)
 8b4:	6402                	ld	s0,0(sp)
 8b6:	0141                	addi	sp,sp,16
 8b8:	8082                	ret
    fprintf(2, "get file stat error");
 8ba:	00000597          	auipc	a1,0x0
 8be:	2a658593          	addi	a1,a1,678 # b60 <digits+0x60>
 8c2:	4509                	li	a0,2
 8c4:	00000097          	auipc	ra,0x0
 8c8:	d2a080e7          	jalr	-726(ra) # 5ee <fprintf>
    exit(0);
 8cc:	4501                	li	a0,0
 8ce:	00000097          	auipc	ra,0x0
 8d2:	9ce080e7          	jalr	-1586(ra) # 29c <exit>

00000000000008d6 <Dup>:



int Dup(int fd){
 8d6:	1141                	addi	sp,sp,-16
 8d8:	e406                	sd	ra,8(sp)
 8da:	e022                	sd	s0,0(sp)
 8dc:	0800                	addi	s0,sp,16
  i32 res = dup(fd);
 8de:	00000097          	auipc	ra,0x0
 8e2:	a36080e7          	jalr	-1482(ra) # 314 <dup>
  if (res < 0) {
 8e6:	00054663          	bltz	a0,8f2 <Dup+0x1c>
    fprintf(2, "dup error");
    exit(0);
  }
  return res;

}
 8ea:	60a2                	ld	ra,8(sp)
 8ec:	6402                	ld	s0,0(sp)
 8ee:	0141                	addi	sp,sp,16
 8f0:	8082                	ret
    fprintf(2, "dup error");
 8f2:	00000597          	auipc	a1,0x0
 8f6:	28658593          	addi	a1,a1,646 # b78 <digits+0x78>
 8fa:	4509                	li	a0,2
 8fc:	00000097          	auipc	ra,0x0
 900:	cf2080e7          	jalr	-782(ra) # 5ee <fprintf>
    exit(0);
 904:	4501                	li	a0,0
 906:	00000097          	auipc	ra,0x0
 90a:	996080e7          	jalr	-1642(ra) # 29c <exit>

000000000000090e <Close>:

int Close(int fd){
 90e:	1141                	addi	sp,sp,-16
 910:	e406                	sd	ra,8(sp)
 912:	e022                	sd	s0,0(sp)
 914:	0800                	addi	s0,sp,16
  i32 res = close(fd);
 916:	00000097          	auipc	ra,0x0
 91a:	9ae080e7          	jalr	-1618(ra) # 2c4 <close>
  if (res < 0) {
 91e:	00054663          	bltz	a0,92a <Close+0x1c>
    fprintf(2, "file close error~");
    exit(0);
  }
  return res;
}
 922:	60a2                	ld	ra,8(sp)
 924:	6402                	ld	s0,0(sp)
 926:	0141                	addi	sp,sp,16
 928:	8082                	ret
    fprintf(2, "file close error~");
 92a:	00000597          	auipc	a1,0x0
 92e:	25e58593          	addi	a1,a1,606 # b88 <digits+0x88>
 932:	4509                	li	a0,2
 934:	00000097          	auipc	ra,0x0
 938:	cba080e7          	jalr	-838(ra) # 5ee <fprintf>
    exit(0);
 93c:	4501                	li	a0,0
 93e:	00000097          	auipc	ra,0x0
 942:	95e080e7          	jalr	-1698(ra) # 29c <exit>

0000000000000946 <Dup2>:

int Dup2(int old_fd,int new_fd){
 946:	1101                	addi	sp,sp,-32
 948:	ec06                	sd	ra,24(sp)
 94a:	e822                	sd	s0,16(sp)
 94c:	e426                	sd	s1,8(sp)
 94e:	1000                	addi	s0,sp,32
 950:	84aa                	mv	s1,a0
  Close(new_fd);
 952:	852e                	mv	a0,a1
 954:	00000097          	auipc	ra,0x0
 958:	fba080e7          	jalr	-70(ra) # 90e <Close>
  i32 res = Dup(old_fd);
 95c:	8526                	mv	a0,s1
 95e:	00000097          	auipc	ra,0x0
 962:	f78080e7          	jalr	-136(ra) # 8d6 <Dup>
  if (res < 0) {
 966:	00054763          	bltz	a0,974 <Dup2+0x2e>
    fprintf(2, "dup error");
    exit(0);
  }
  return res;
}
 96a:	60e2                	ld	ra,24(sp)
 96c:	6442                	ld	s0,16(sp)
 96e:	64a2                	ld	s1,8(sp)
 970:	6105                	addi	sp,sp,32
 972:	8082                	ret
    fprintf(2, "dup error");
 974:	00000597          	auipc	a1,0x0
 978:	20458593          	addi	a1,a1,516 # b78 <digits+0x78>
 97c:	4509                	li	a0,2
 97e:	00000097          	auipc	ra,0x0
 982:	c70080e7          	jalr	-912(ra) # 5ee <fprintf>
    exit(0);
 986:	4501                	li	a0,0
 988:	00000097          	auipc	ra,0x0
 98c:	914080e7          	jalr	-1772(ra) # 29c <exit>

0000000000000990 <Stat>:

int Stat(const char*link,stat_t *st){
 990:	1101                	addi	sp,sp,-32
 992:	ec06                	sd	ra,24(sp)
 994:	e822                	sd	s0,16(sp)
 996:	e426                	sd	s1,8(sp)
 998:	1000                	addi	s0,sp,32
 99a:	84aa                	mv	s1,a0
  i32 res = stat(link,st);
 99c:	fffff097          	auipc	ra,0xfffff
 9a0:	7be080e7          	jalr	1982(ra) # 15a <stat>
  if (res < 0) {
 9a4:	00054763          	bltz	a0,9b2 <Stat+0x22>
    fprintf(2, "file %s stat error",link);
    exit(0);
  }
  return res;
}
 9a8:	60e2                	ld	ra,24(sp)
 9aa:	6442                	ld	s0,16(sp)
 9ac:	64a2                	ld	s1,8(sp)
 9ae:	6105                	addi	sp,sp,32
 9b0:	8082                	ret
    fprintf(2, "file %s stat error",link);
 9b2:	8626                	mv	a2,s1
 9b4:	00000597          	auipc	a1,0x0
 9b8:	1ec58593          	addi	a1,a1,492 # ba0 <digits+0xa0>
 9bc:	4509                	li	a0,2
 9be:	00000097          	auipc	ra,0x0
 9c2:	c30080e7          	jalr	-976(ra) # 5ee <fprintf>
    exit(0);
 9c6:	4501                	li	a0,0
 9c8:	00000097          	auipc	ra,0x0
 9cc:	8d4080e7          	jalr	-1836(ra) # 29c <exit>

00000000000009d0 <strncmp>:
   return -1;
}



int strncmp(const char*s, const char*pat,int n){
 9d0:	bc010113          	addi	sp,sp,-1088
 9d4:	42113c23          	sd	ra,1080(sp)
 9d8:	42813823          	sd	s0,1072(sp)
 9dc:	42913423          	sd	s1,1064(sp)
 9e0:	43213023          	sd	s2,1056(sp)
 9e4:	41313c23          	sd	s3,1048(sp)
 9e8:	41413823          	sd	s4,1040(sp)
 9ec:	41513423          	sd	s5,1032(sp)
 9f0:	44010413          	addi	s0,sp,1088
 9f4:	89aa                	mv	s3,a0
 9f6:	892e                	mv	s2,a1
 9f8:	84b2                	mv	s1,a2
  char buf1[512],buf2[512];
  int n1 = MIN(n,strlen(s));
 9fa:	fffff097          	auipc	ra,0xfffff
 9fe:	67c080e7          	jalr	1660(ra) # 76 <strlen>
 a02:	2501                	sext.w	a0,a0
 a04:	00048a1b          	sext.w	s4,s1
 a08:	8aa6                	mv	s5,s1
 a0a:	06aa7363          	bgeu	s4,a0,a70 <strncmp+0xa0>
  int n2 = MIN(n,strlen(pat));
 a0e:	854a                	mv	a0,s2
 a10:	fffff097          	auipc	ra,0xfffff
 a14:	666080e7          	jalr	1638(ra) # 76 <strlen>
 a18:	2501                	sext.w	a0,a0
 a1a:	06aa7363          	bgeu	s4,a0,a80 <strncmp+0xb0>
  memmove(buf1,s,n1);
 a1e:	8656                	mv	a2,s5
 a20:	85ce                	mv	a1,s3
 a22:	dc040513          	addi	a0,s0,-576
 a26:	fffff097          	auipc	ra,0xfffff
 a2a:	7c4080e7          	jalr	1988(ra) # 1ea <memmove>
  memmove(buf2,pat,n2);
 a2e:	8626                	mv	a2,s1
 a30:	85ca                	mv	a1,s2
 a32:	bc040513          	addi	a0,s0,-1088
 a36:	fffff097          	auipc	ra,0xfffff
 a3a:	7b4080e7          	jalr	1972(ra) # 1ea <memmove>
  return strcmp(buf1,buf2);
 a3e:	bc040593          	addi	a1,s0,-1088
 a42:	dc040513          	addi	a0,s0,-576
 a46:	fffff097          	auipc	ra,0xfffff
 a4a:	604080e7          	jalr	1540(ra) # 4a <strcmp>
}
 a4e:	43813083          	ld	ra,1080(sp)
 a52:	43013403          	ld	s0,1072(sp)
 a56:	42813483          	ld	s1,1064(sp)
 a5a:	42013903          	ld	s2,1056(sp)
 a5e:	41813983          	ld	s3,1048(sp)
 a62:	41013a03          	ld	s4,1040(sp)
 a66:	40813a83          	ld	s5,1032(sp)
 a6a:	44010113          	addi	sp,sp,1088
 a6e:	8082                	ret
  int n1 = MIN(n,strlen(s));
 a70:	854e                	mv	a0,s3
 a72:	fffff097          	auipc	ra,0xfffff
 a76:	604080e7          	jalr	1540(ra) # 76 <strlen>
 a7a:	00050a9b          	sext.w	s5,a0
 a7e:	bf41                	j	a0e <strncmp+0x3e>
  int n2 = MIN(n,strlen(pat));
 a80:	854a                	mv	a0,s2
 a82:	fffff097          	auipc	ra,0xfffff
 a86:	5f4080e7          	jalr	1524(ra) # 76 <strlen>
 a8a:	0005049b          	sext.w	s1,a0
 a8e:	bf41                	j	a1e <strncmp+0x4e>

0000000000000a90 <strstr>:
   while (*s != 0){
 a90:	00054783          	lbu	a5,0(a0)
 a94:	cba1                	beqz	a5,ae4 <strstr+0x54>
int strstr(char *s,char *p){
 a96:	7179                	addi	sp,sp,-48
 a98:	f406                	sd	ra,40(sp)
 a9a:	f022                	sd	s0,32(sp)
 a9c:	ec26                	sd	s1,24(sp)
 a9e:	e84a                	sd	s2,16(sp)
 aa0:	e44e                	sd	s3,8(sp)
 aa2:	1800                	addi	s0,sp,48
 aa4:	89aa                	mv	s3,a0
 aa6:	892e                	mv	s2,a1
   while (*s != 0){
 aa8:	84aa                	mv	s1,a0
     if (!strncmp(s,p,strlen(p)))
 aaa:	854a                	mv	a0,s2
 aac:	fffff097          	auipc	ra,0xfffff
 ab0:	5ca080e7          	jalr	1482(ra) # 76 <strlen>
 ab4:	0005061b          	sext.w	a2,a0
 ab8:	85ca                	mv	a1,s2
 aba:	8526                	mv	a0,s1
 abc:	00000097          	auipc	ra,0x0
 ac0:	f14080e7          	jalr	-236(ra) # 9d0 <strncmp>
 ac4:	c519                	beqz	a0,ad2 <strstr+0x42>
     s++;
 ac6:	0485                	addi	s1,s1,1
   while (*s != 0){
 ac8:	0004c783          	lbu	a5,0(s1)
 acc:	fff9                	bnez	a5,aaa <strstr+0x1a>
   return -1;
 ace:	557d                	li	a0,-1
 ad0:	a019                	j	ad6 <strstr+0x46>
      return s - ori;
 ad2:	4134853b          	subw	a0,s1,s3
}
 ad6:	70a2                	ld	ra,40(sp)
 ad8:	7402                	ld	s0,32(sp)
 ada:	64e2                	ld	s1,24(sp)
 adc:	6942                	ld	s2,16(sp)
 ade:	69a2                	ld	s3,8(sp)
 ae0:	6145                	addi	sp,sp,48
 ae2:	8082                	ret
   return -1;
 ae4:	557d                	li	a0,-1
}
 ae6:	8082                	ret
