
user/_touch:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fcntl.h"
#include "kernel/stat.h"
#include "kernel/types.h"


int main(int argc, char** argv){
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
    if (argc < 2){
   a:	4785                	li	a5,1
   c:	02a7d463          	bge	a5,a0,34 <main+0x34>
        printf("usage: <file to be created>");
        exit(0);
    }

    char **p = argv + 1;
  10:	00858493          	addi	s1,a1,8
    while (*p != (void*)0){
  14:	6588                	ld	a0,8(a1)
  16:	c911                	beqz	a0,2a <main+0x2a>
        Open(*p,O_WRONLY|O_CREATE);
  18:	20100593          	li	a1,513
  1c:	00001097          	auipc	ra,0x1
  20:	86a080e7          	jalr	-1942(ra) # 886 <Open>
        p++;
  24:	04a1                	addi	s1,s1,8
    while (*p != (void*)0){
  26:	6088                	ld	a0,0(s1)
  28:	f965                	bnez	a0,18 <main+0x18>
    }
    exit(0);
  2a:	4501                	li	a0,0
  2c:	00000097          	auipc	ra,0x0
  30:	290080e7          	jalr	656(ra) # 2bc <exit>
        printf("usage: <file to be created>");
  34:	00001517          	auipc	a0,0x1
  38:	ad450513          	addi	a0,a0,-1324 # b08 <strstr+0x58>
  3c:	00000097          	auipc	ra,0x0
  40:	600080e7          	jalr	1536(ra) # 63c <printf>
        exit(0);
  44:	4501                	li	a0,0
  46:	00000097          	auipc	ra,0x0
  4a:	276080e7          	jalr	630(ra) # 2bc <exit>

000000000000004e <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  4e:	1141                	addi	sp,sp,-16
  50:	e422                	sd	s0,8(sp)
  52:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  54:	87aa                	mv	a5,a0
  56:	0585                	addi	a1,a1,1
  58:	0785                	addi	a5,a5,1
  5a:	fff5c703          	lbu	a4,-1(a1)
  5e:	fee78fa3          	sb	a4,-1(a5)
  62:	fb75                	bnez	a4,56 <strcpy+0x8>
    ;
  return os;
}
  64:	6422                	ld	s0,8(sp)
  66:	0141                	addi	sp,sp,16
  68:	8082                	ret

000000000000006a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  6a:	1141                	addi	sp,sp,-16
  6c:	e422                	sd	s0,8(sp)
  6e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  70:	00054783          	lbu	a5,0(a0)
  74:	cb91                	beqz	a5,88 <strcmp+0x1e>
  76:	0005c703          	lbu	a4,0(a1)
  7a:	00f71763          	bne	a4,a5,88 <strcmp+0x1e>
    p++, q++;
  7e:	0505                	addi	a0,a0,1
  80:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  82:	00054783          	lbu	a5,0(a0)
  86:	fbe5                	bnez	a5,76 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  88:	0005c503          	lbu	a0,0(a1)
}
  8c:	40a7853b          	subw	a0,a5,a0
  90:	6422                	ld	s0,8(sp)
  92:	0141                	addi	sp,sp,16
  94:	8082                	ret

0000000000000096 <strlen>:

uint
strlen(const char *s)
{
  96:	1141                	addi	sp,sp,-16
  98:	e422                	sd	s0,8(sp)
  9a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  9c:	00054783          	lbu	a5,0(a0)
  a0:	cf91                	beqz	a5,bc <strlen+0x26>
  a2:	0505                	addi	a0,a0,1
  a4:	87aa                	mv	a5,a0
  a6:	4685                	li	a3,1
  a8:	9e89                	subw	a3,a3,a0
  aa:	00f6853b          	addw	a0,a3,a5
  ae:	0785                	addi	a5,a5,1
  b0:	fff7c703          	lbu	a4,-1(a5)
  b4:	fb7d                	bnez	a4,aa <strlen+0x14>
    ;
  return n;
}
  b6:	6422                	ld	s0,8(sp)
  b8:	0141                	addi	sp,sp,16
  ba:	8082                	ret
  for(n = 0; s[n]; n++)
  bc:	4501                	li	a0,0
  be:	bfe5                	j	b6 <strlen+0x20>

00000000000000c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  c0:	1141                	addi	sp,sp,-16
  c2:	e422                	sd	s0,8(sp)
  c4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  c6:	ca19                	beqz	a2,dc <memset+0x1c>
  c8:	87aa                	mv	a5,a0
  ca:	1602                	slli	a2,a2,0x20
  cc:	9201                	srli	a2,a2,0x20
  ce:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  d2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  d6:	0785                	addi	a5,a5,1
  d8:	fee79de3          	bne	a5,a4,d2 <memset+0x12>
  }
  return dst;
}
  dc:	6422                	ld	s0,8(sp)
  de:	0141                	addi	sp,sp,16
  e0:	8082                	ret

00000000000000e2 <strchr>:

char*
strchr(const char *s, char c)
{
  e2:	1141                	addi	sp,sp,-16
  e4:	e422                	sd	s0,8(sp)
  e6:	0800                	addi	s0,sp,16
  for(; *s; s++)
  e8:	00054783          	lbu	a5,0(a0)
  ec:	cb99                	beqz	a5,102 <strchr+0x20>
    if(*s == c)
  ee:	00f58763          	beq	a1,a5,fc <strchr+0x1a>
  for(; *s; s++)
  f2:	0505                	addi	a0,a0,1
  f4:	00054783          	lbu	a5,0(a0)
  f8:	fbfd                	bnez	a5,ee <strchr+0xc>
      return (char*)s;
  return 0;
  fa:	4501                	li	a0,0
}
  fc:	6422                	ld	s0,8(sp)
  fe:	0141                	addi	sp,sp,16
 100:	8082                	ret
  return 0;
 102:	4501                	li	a0,0
 104:	bfe5                	j	fc <strchr+0x1a>

0000000000000106 <gets>:

char*
gets(char *buf, int max)
{
 106:	711d                	addi	sp,sp,-96
 108:	ec86                	sd	ra,88(sp)
 10a:	e8a2                	sd	s0,80(sp)
 10c:	e4a6                	sd	s1,72(sp)
 10e:	e0ca                	sd	s2,64(sp)
 110:	fc4e                	sd	s3,56(sp)
 112:	f852                	sd	s4,48(sp)
 114:	f456                	sd	s5,40(sp)
 116:	f05a                	sd	s6,32(sp)
 118:	ec5e                	sd	s7,24(sp)
 11a:	1080                	addi	s0,sp,96
 11c:	8baa                	mv	s7,a0
 11e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 120:	892a                	mv	s2,a0
 122:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 124:	4aa9                	li	s5,10
 126:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 128:	89a6                	mv	s3,s1
 12a:	2485                	addiw	s1,s1,1
 12c:	0344d863          	bge	s1,s4,15c <gets+0x56>
    cc = read(0, &c, 1);
 130:	4605                	li	a2,1
 132:	faf40593          	addi	a1,s0,-81
 136:	4501                	li	a0,0
 138:	00000097          	auipc	ra,0x0
 13c:	19c080e7          	jalr	412(ra) # 2d4 <read>
    if(cc < 1)
 140:	00a05e63          	blez	a0,15c <gets+0x56>
    buf[i++] = c;
 144:	faf44783          	lbu	a5,-81(s0)
 148:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 14c:	01578763          	beq	a5,s5,15a <gets+0x54>
 150:	0905                	addi	s2,s2,1
 152:	fd679be3          	bne	a5,s6,128 <gets+0x22>
  for(i=0; i+1 < max; ){
 156:	89a6                	mv	s3,s1
 158:	a011                	j	15c <gets+0x56>
 15a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 15c:	99de                	add	s3,s3,s7
 15e:	00098023          	sb	zero,0(s3)
  return buf;
}
 162:	855e                	mv	a0,s7
 164:	60e6                	ld	ra,88(sp)
 166:	6446                	ld	s0,80(sp)
 168:	64a6                	ld	s1,72(sp)
 16a:	6906                	ld	s2,64(sp)
 16c:	79e2                	ld	s3,56(sp)
 16e:	7a42                	ld	s4,48(sp)
 170:	7aa2                	ld	s5,40(sp)
 172:	7b02                	ld	s6,32(sp)
 174:	6be2                	ld	s7,24(sp)
 176:	6125                	addi	sp,sp,96
 178:	8082                	ret

000000000000017a <stat>:

int
stat(const char *n, struct stat *st)
{
 17a:	1101                	addi	sp,sp,-32
 17c:	ec06                	sd	ra,24(sp)
 17e:	e822                	sd	s0,16(sp)
 180:	e426                	sd	s1,8(sp)
 182:	e04a                	sd	s2,0(sp)
 184:	1000                	addi	s0,sp,32
 186:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 188:	4581                	li	a1,0
 18a:	00000097          	auipc	ra,0x0
 18e:	172080e7          	jalr	370(ra) # 2fc <open>
  if(fd < 0)
 192:	02054563          	bltz	a0,1bc <stat+0x42>
 196:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 198:	85ca                	mv	a1,s2
 19a:	00000097          	auipc	ra,0x0
 19e:	17a080e7          	jalr	378(ra) # 314 <fstat>
 1a2:	892a                	mv	s2,a0
  close(fd);
 1a4:	8526                	mv	a0,s1
 1a6:	00000097          	auipc	ra,0x0
 1aa:	13e080e7          	jalr	318(ra) # 2e4 <close>
  return r;
}
 1ae:	854a                	mv	a0,s2
 1b0:	60e2                	ld	ra,24(sp)
 1b2:	6442                	ld	s0,16(sp)
 1b4:	64a2                	ld	s1,8(sp)
 1b6:	6902                	ld	s2,0(sp)
 1b8:	6105                	addi	sp,sp,32
 1ba:	8082                	ret
    return -1;
 1bc:	597d                	li	s2,-1
 1be:	bfc5                	j	1ae <stat+0x34>

00000000000001c0 <atoi>:

int
atoi(const char *s)
{
 1c0:	1141                	addi	sp,sp,-16
 1c2:	e422                	sd	s0,8(sp)
 1c4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1c6:	00054603          	lbu	a2,0(a0)
 1ca:	fd06079b          	addiw	a5,a2,-48
 1ce:	0ff7f793          	andi	a5,a5,255
 1d2:	4725                	li	a4,9
 1d4:	02f76963          	bltu	a4,a5,206 <atoi+0x46>
 1d8:	86aa                	mv	a3,a0
  n = 0;
 1da:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1dc:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1de:	0685                	addi	a3,a3,1
 1e0:	0025179b          	slliw	a5,a0,0x2
 1e4:	9fa9                	addw	a5,a5,a0
 1e6:	0017979b          	slliw	a5,a5,0x1
 1ea:	9fb1                	addw	a5,a5,a2
 1ec:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1f0:	0006c603          	lbu	a2,0(a3)
 1f4:	fd06071b          	addiw	a4,a2,-48
 1f8:	0ff77713          	andi	a4,a4,255
 1fc:	fee5f1e3          	bgeu	a1,a4,1de <atoi+0x1e>
  return n;
}
 200:	6422                	ld	s0,8(sp)
 202:	0141                	addi	sp,sp,16
 204:	8082                	ret
  n = 0;
 206:	4501                	li	a0,0
 208:	bfe5                	j	200 <atoi+0x40>

000000000000020a <memmove>:

// #define memcpy memmove

void*
memmove(void *vdst, const void *vsrc, int n)
{
 20a:	1141                	addi	sp,sp,-16
 20c:	e422                	sd	s0,8(sp)
 20e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 210:	02b57463          	bgeu	a0,a1,238 <memmove+0x2e>
    while(n-- > 0)
 214:	00c05f63          	blez	a2,232 <memmove+0x28>
 218:	1602                	slli	a2,a2,0x20
 21a:	9201                	srli	a2,a2,0x20
 21c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 220:	872a                	mv	a4,a0
      *dst++ = *src++;
 222:	0585                	addi	a1,a1,1
 224:	0705                	addi	a4,a4,1
 226:	fff5c683          	lbu	a3,-1(a1)
 22a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 22e:	fee79ae3          	bne	a5,a4,222 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 232:	6422                	ld	s0,8(sp)
 234:	0141                	addi	sp,sp,16
 236:	8082                	ret
    dst += n;
 238:	00c50733          	add	a4,a0,a2
    src += n;
 23c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 23e:	fec05ae3          	blez	a2,232 <memmove+0x28>
 242:	fff6079b          	addiw	a5,a2,-1
 246:	1782                	slli	a5,a5,0x20
 248:	9381                	srli	a5,a5,0x20
 24a:	fff7c793          	not	a5,a5
 24e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 250:	15fd                	addi	a1,a1,-1
 252:	177d                	addi	a4,a4,-1
 254:	0005c683          	lbu	a3,0(a1)
 258:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 25c:	fee79ae3          	bne	a5,a4,250 <memmove+0x46>
 260:	bfc9                	j	232 <memmove+0x28>

0000000000000262 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 262:	1141                	addi	sp,sp,-16
 264:	e422                	sd	s0,8(sp)
 266:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 268:	ca05                	beqz	a2,298 <memcmp+0x36>
 26a:	fff6069b          	addiw	a3,a2,-1
 26e:	1682                	slli	a3,a3,0x20
 270:	9281                	srli	a3,a3,0x20
 272:	0685                	addi	a3,a3,1
 274:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 276:	00054783          	lbu	a5,0(a0)
 27a:	0005c703          	lbu	a4,0(a1)
 27e:	00e79863          	bne	a5,a4,28e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 282:	0505                	addi	a0,a0,1
    p2++;
 284:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 286:	fed518e3          	bne	a0,a3,276 <memcmp+0x14>
  }
  return 0;
 28a:	4501                	li	a0,0
 28c:	a019                	j	292 <memcmp+0x30>
      return *p1 - *p2;
 28e:	40e7853b          	subw	a0,a5,a4
}
 292:	6422                	ld	s0,8(sp)
 294:	0141                	addi	sp,sp,16
 296:	8082                	ret
  return 0;
 298:	4501                	li	a0,0
 29a:	bfe5                	j	292 <memcmp+0x30>

000000000000029c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 29c:	1141                	addi	sp,sp,-16
 29e:	e406                	sd	ra,8(sp)
 2a0:	e022                	sd	s0,0(sp)
 2a2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2a4:	00000097          	auipc	ra,0x0
 2a8:	f66080e7          	jalr	-154(ra) # 20a <memmove>
}
 2ac:	60a2                	ld	ra,8(sp)
 2ae:	6402                	ld	s0,0(sp)
 2b0:	0141                	addi	sp,sp,16
 2b2:	8082                	ret

00000000000002b4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2b4:	4885                	li	a7,1
 ecall
 2b6:	00000073          	ecall
 ret
 2ba:	8082                	ret

00000000000002bc <exit>:
.global exit
exit:
 li a7, SYS_exit
 2bc:	4889                	li	a7,2
 ecall
 2be:	00000073          	ecall
 ret
 2c2:	8082                	ret

00000000000002c4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2c4:	488d                	li	a7,3
 ecall
 2c6:	00000073          	ecall
 ret
 2ca:	8082                	ret

00000000000002cc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2cc:	4891                	li	a7,4
 ecall
 2ce:	00000073          	ecall
 ret
 2d2:	8082                	ret

00000000000002d4 <read>:
.global read
read:
 li a7, SYS_read
 2d4:	4895                	li	a7,5
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <write>:
.global write
write:
 li a7, SYS_write
 2dc:	48c1                	li	a7,16
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <close>:
.global close
close:
 li a7, SYS_close
 2e4:	48d5                	li	a7,21
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <kill>:
.global kill
kill:
 li a7, SYS_kill
 2ec:	4899                	li	a7,6
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2f4:	489d                	li	a7,7
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <open>:
.global open
open:
 li a7, SYS_open
 2fc:	48bd                	li	a7,15
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 304:	48c5                	li	a7,17
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 30c:	48c9                	li	a7,18
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 314:	48a1                	li	a7,8
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <link>:
.global link
link:
 li a7, SYS_link
 31c:	48cd                	li	a7,19
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 324:	48d1                	li	a7,20
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 32c:	48a5                	li	a7,9
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <dup>:
.global dup
dup:
 li a7, SYS_dup
 334:	48a9                	li	a7,10
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 33c:	48ad                	li	a7,11
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 344:	48b1                	li	a7,12
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 34c:	48b5                	li	a7,13
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 354:	48b9                	li	a7,14
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <trace>:
.global trace
trace:
 li a7, SYS_trace
 35c:	48d9                	li	a7,22
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 364:	1101                	addi	sp,sp,-32
 366:	ec06                	sd	ra,24(sp)
 368:	e822                	sd	s0,16(sp)
 36a:	1000                	addi	s0,sp,32
 36c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 370:	4605                	li	a2,1
 372:	fef40593          	addi	a1,s0,-17
 376:	00000097          	auipc	ra,0x0
 37a:	f66080e7          	jalr	-154(ra) # 2dc <write>
}
 37e:	60e2                	ld	ra,24(sp)
 380:	6442                	ld	s0,16(sp)
 382:	6105                	addi	sp,sp,32
 384:	8082                	ret

0000000000000386 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 386:	7139                	addi	sp,sp,-64
 388:	fc06                	sd	ra,56(sp)
 38a:	f822                	sd	s0,48(sp)
 38c:	f426                	sd	s1,40(sp)
 38e:	f04a                	sd	s2,32(sp)
 390:	ec4e                	sd	s3,24(sp)
 392:	0080                	addi	s0,sp,64
 394:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 396:	c299                	beqz	a3,39c <printint+0x16>
 398:	0805c863          	bltz	a1,428 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 39c:	2581                	sext.w	a1,a1
  neg = 0;
 39e:	4881                	li	a7,0
 3a0:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3a4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3a6:	2601                	sext.w	a2,a2
 3a8:	00000517          	auipc	a0,0x0
 3ac:	78850513          	addi	a0,a0,1928 # b30 <digits>
 3b0:	883a                	mv	a6,a4
 3b2:	2705                	addiw	a4,a4,1
 3b4:	02c5f7bb          	remuw	a5,a1,a2
 3b8:	1782                	slli	a5,a5,0x20
 3ba:	9381                	srli	a5,a5,0x20
 3bc:	97aa                	add	a5,a5,a0
 3be:	0007c783          	lbu	a5,0(a5)
 3c2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3c6:	0005879b          	sext.w	a5,a1
 3ca:	02c5d5bb          	divuw	a1,a1,a2
 3ce:	0685                	addi	a3,a3,1
 3d0:	fec7f0e3          	bgeu	a5,a2,3b0 <printint+0x2a>
  if(neg)
 3d4:	00088b63          	beqz	a7,3ea <printint+0x64>
    buf[i++] = '-';
 3d8:	fd040793          	addi	a5,s0,-48
 3dc:	973e                	add	a4,a4,a5
 3de:	02d00793          	li	a5,45
 3e2:	fef70823          	sb	a5,-16(a4)
 3e6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3ea:	02e05863          	blez	a4,41a <printint+0x94>
 3ee:	fc040793          	addi	a5,s0,-64
 3f2:	00e78933          	add	s2,a5,a4
 3f6:	fff78993          	addi	s3,a5,-1
 3fa:	99ba                	add	s3,s3,a4
 3fc:	377d                	addiw	a4,a4,-1
 3fe:	1702                	slli	a4,a4,0x20
 400:	9301                	srli	a4,a4,0x20
 402:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 406:	fff94583          	lbu	a1,-1(s2)
 40a:	8526                	mv	a0,s1
 40c:	00000097          	auipc	ra,0x0
 410:	f58080e7          	jalr	-168(ra) # 364 <putc>
  while(--i >= 0)
 414:	197d                	addi	s2,s2,-1
 416:	ff3918e3          	bne	s2,s3,406 <printint+0x80>
}
 41a:	70e2                	ld	ra,56(sp)
 41c:	7442                	ld	s0,48(sp)
 41e:	74a2                	ld	s1,40(sp)
 420:	7902                	ld	s2,32(sp)
 422:	69e2                	ld	s3,24(sp)
 424:	6121                	addi	sp,sp,64
 426:	8082                	ret
    x = -xx;
 428:	40b005bb          	negw	a1,a1
    neg = 1;
 42c:	4885                	li	a7,1
    x = -xx;
 42e:	bf8d                	j	3a0 <printint+0x1a>

0000000000000430 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 430:	7119                	addi	sp,sp,-128
 432:	fc86                	sd	ra,120(sp)
 434:	f8a2                	sd	s0,112(sp)
 436:	f4a6                	sd	s1,104(sp)
 438:	f0ca                	sd	s2,96(sp)
 43a:	ecce                	sd	s3,88(sp)
 43c:	e8d2                	sd	s4,80(sp)
 43e:	e4d6                	sd	s5,72(sp)
 440:	e0da                	sd	s6,64(sp)
 442:	fc5e                	sd	s7,56(sp)
 444:	f862                	sd	s8,48(sp)
 446:	f466                	sd	s9,40(sp)
 448:	f06a                	sd	s10,32(sp)
 44a:	ec6e                	sd	s11,24(sp)
 44c:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 44e:	0005c903          	lbu	s2,0(a1)
 452:	18090f63          	beqz	s2,5f0 <vprintf+0x1c0>
 456:	8aaa                	mv	s5,a0
 458:	8b32                	mv	s6,a2
 45a:	00158493          	addi	s1,a1,1
  state = 0;
 45e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 460:	02500a13          	li	s4,37
      if(c == 'd'){
 464:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 468:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 46c:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 470:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 474:	00000b97          	auipc	s7,0x0
 478:	6bcb8b93          	addi	s7,s7,1724 # b30 <digits>
 47c:	a839                	j	49a <vprintf+0x6a>
        putc(fd, c);
 47e:	85ca                	mv	a1,s2
 480:	8556                	mv	a0,s5
 482:	00000097          	auipc	ra,0x0
 486:	ee2080e7          	jalr	-286(ra) # 364 <putc>
 48a:	a019                	j	490 <vprintf+0x60>
    } else if(state == '%'){
 48c:	01498f63          	beq	s3,s4,4aa <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 490:	0485                	addi	s1,s1,1
 492:	fff4c903          	lbu	s2,-1(s1)
 496:	14090d63          	beqz	s2,5f0 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 49a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 49e:	fe0997e3          	bnez	s3,48c <vprintf+0x5c>
      if(c == '%'){
 4a2:	fd479ee3          	bne	a5,s4,47e <vprintf+0x4e>
        state = '%';
 4a6:	89be                	mv	s3,a5
 4a8:	b7e5                	j	490 <vprintf+0x60>
      if(c == 'd'){
 4aa:	05878063          	beq	a5,s8,4ea <vprintf+0xba>
      } else if(c == 'l') {
 4ae:	05978c63          	beq	a5,s9,506 <vprintf+0xd6>
      } else if(c == 'x') {
 4b2:	07a78863          	beq	a5,s10,522 <vprintf+0xf2>
      } else if(c == 'p') {
 4b6:	09b78463          	beq	a5,s11,53e <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 4ba:	07300713          	li	a4,115
 4be:	0ce78663          	beq	a5,a4,58a <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4c2:	06300713          	li	a4,99
 4c6:	0ee78e63          	beq	a5,a4,5c2 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 4ca:	11478863          	beq	a5,s4,5da <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4ce:	85d2                	mv	a1,s4
 4d0:	8556                	mv	a0,s5
 4d2:	00000097          	auipc	ra,0x0
 4d6:	e92080e7          	jalr	-366(ra) # 364 <putc>
        putc(fd, c);
 4da:	85ca                	mv	a1,s2
 4dc:	8556                	mv	a0,s5
 4de:	00000097          	auipc	ra,0x0
 4e2:	e86080e7          	jalr	-378(ra) # 364 <putc>
      }
      state = 0;
 4e6:	4981                	li	s3,0
 4e8:	b765                	j	490 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 4ea:	008b0913          	addi	s2,s6,8
 4ee:	4685                	li	a3,1
 4f0:	4629                	li	a2,10
 4f2:	000b2583          	lw	a1,0(s6)
 4f6:	8556                	mv	a0,s5
 4f8:	00000097          	auipc	ra,0x0
 4fc:	e8e080e7          	jalr	-370(ra) # 386 <printint>
 500:	8b4a                	mv	s6,s2
      state = 0;
 502:	4981                	li	s3,0
 504:	b771                	j	490 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 506:	008b0913          	addi	s2,s6,8
 50a:	4681                	li	a3,0
 50c:	4629                	li	a2,10
 50e:	000b2583          	lw	a1,0(s6)
 512:	8556                	mv	a0,s5
 514:	00000097          	auipc	ra,0x0
 518:	e72080e7          	jalr	-398(ra) # 386 <printint>
 51c:	8b4a                	mv	s6,s2
      state = 0;
 51e:	4981                	li	s3,0
 520:	bf85                	j	490 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 522:	008b0913          	addi	s2,s6,8
 526:	4681                	li	a3,0
 528:	4641                	li	a2,16
 52a:	000b2583          	lw	a1,0(s6)
 52e:	8556                	mv	a0,s5
 530:	00000097          	auipc	ra,0x0
 534:	e56080e7          	jalr	-426(ra) # 386 <printint>
 538:	8b4a                	mv	s6,s2
      state = 0;
 53a:	4981                	li	s3,0
 53c:	bf91                	j	490 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 53e:	008b0793          	addi	a5,s6,8
 542:	f8f43423          	sd	a5,-120(s0)
 546:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 54a:	03000593          	li	a1,48
 54e:	8556                	mv	a0,s5
 550:	00000097          	auipc	ra,0x0
 554:	e14080e7          	jalr	-492(ra) # 364 <putc>
  putc(fd, 'x');
 558:	85ea                	mv	a1,s10
 55a:	8556                	mv	a0,s5
 55c:	00000097          	auipc	ra,0x0
 560:	e08080e7          	jalr	-504(ra) # 364 <putc>
 564:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 566:	03c9d793          	srli	a5,s3,0x3c
 56a:	97de                	add	a5,a5,s7
 56c:	0007c583          	lbu	a1,0(a5)
 570:	8556                	mv	a0,s5
 572:	00000097          	auipc	ra,0x0
 576:	df2080e7          	jalr	-526(ra) # 364 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 57a:	0992                	slli	s3,s3,0x4
 57c:	397d                	addiw	s2,s2,-1
 57e:	fe0914e3          	bnez	s2,566 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 582:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 586:	4981                	li	s3,0
 588:	b721                	j	490 <vprintf+0x60>
        s = va_arg(ap, char*);
 58a:	008b0993          	addi	s3,s6,8
 58e:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 592:	02090163          	beqz	s2,5b4 <vprintf+0x184>
        while(*s != 0){
 596:	00094583          	lbu	a1,0(s2)
 59a:	c9a1                	beqz	a1,5ea <vprintf+0x1ba>
          putc(fd, *s);
 59c:	8556                	mv	a0,s5
 59e:	00000097          	auipc	ra,0x0
 5a2:	dc6080e7          	jalr	-570(ra) # 364 <putc>
          s++;
 5a6:	0905                	addi	s2,s2,1
        while(*s != 0){
 5a8:	00094583          	lbu	a1,0(s2)
 5ac:	f9e5                	bnez	a1,59c <vprintf+0x16c>
        s = va_arg(ap, char*);
 5ae:	8b4e                	mv	s6,s3
      state = 0;
 5b0:	4981                	li	s3,0
 5b2:	bdf9                	j	490 <vprintf+0x60>
          s = "(null)";
 5b4:	00000917          	auipc	s2,0x0
 5b8:	57490913          	addi	s2,s2,1396 # b28 <strstr+0x78>
        while(*s != 0){
 5bc:	02800593          	li	a1,40
 5c0:	bff1                	j	59c <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 5c2:	008b0913          	addi	s2,s6,8
 5c6:	000b4583          	lbu	a1,0(s6)
 5ca:	8556                	mv	a0,s5
 5cc:	00000097          	auipc	ra,0x0
 5d0:	d98080e7          	jalr	-616(ra) # 364 <putc>
 5d4:	8b4a                	mv	s6,s2
      state = 0;
 5d6:	4981                	li	s3,0
 5d8:	bd65                	j	490 <vprintf+0x60>
        putc(fd, c);
 5da:	85d2                	mv	a1,s4
 5dc:	8556                	mv	a0,s5
 5de:	00000097          	auipc	ra,0x0
 5e2:	d86080e7          	jalr	-634(ra) # 364 <putc>
      state = 0;
 5e6:	4981                	li	s3,0
 5e8:	b565                	j	490 <vprintf+0x60>
        s = va_arg(ap, char*);
 5ea:	8b4e                	mv	s6,s3
      state = 0;
 5ec:	4981                	li	s3,0
 5ee:	b54d                	j	490 <vprintf+0x60>
    }
  }
}
 5f0:	70e6                	ld	ra,120(sp)
 5f2:	7446                	ld	s0,112(sp)
 5f4:	74a6                	ld	s1,104(sp)
 5f6:	7906                	ld	s2,96(sp)
 5f8:	69e6                	ld	s3,88(sp)
 5fa:	6a46                	ld	s4,80(sp)
 5fc:	6aa6                	ld	s5,72(sp)
 5fe:	6b06                	ld	s6,64(sp)
 600:	7be2                	ld	s7,56(sp)
 602:	7c42                	ld	s8,48(sp)
 604:	7ca2                	ld	s9,40(sp)
 606:	7d02                	ld	s10,32(sp)
 608:	6de2                	ld	s11,24(sp)
 60a:	6109                	addi	sp,sp,128
 60c:	8082                	ret

000000000000060e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 60e:	715d                	addi	sp,sp,-80
 610:	ec06                	sd	ra,24(sp)
 612:	e822                	sd	s0,16(sp)
 614:	1000                	addi	s0,sp,32
 616:	e010                	sd	a2,0(s0)
 618:	e414                	sd	a3,8(s0)
 61a:	e818                	sd	a4,16(s0)
 61c:	ec1c                	sd	a5,24(s0)
 61e:	03043023          	sd	a6,32(s0)
 622:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 626:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 62a:	8622                	mv	a2,s0
 62c:	00000097          	auipc	ra,0x0
 630:	e04080e7          	jalr	-508(ra) # 430 <vprintf>
}
 634:	60e2                	ld	ra,24(sp)
 636:	6442                	ld	s0,16(sp)
 638:	6161                	addi	sp,sp,80
 63a:	8082                	ret

000000000000063c <printf>:

void
printf(const char *fmt, ...)
{
 63c:	711d                	addi	sp,sp,-96
 63e:	ec06                	sd	ra,24(sp)
 640:	e822                	sd	s0,16(sp)
 642:	1000                	addi	s0,sp,32
 644:	e40c                	sd	a1,8(s0)
 646:	e810                	sd	a2,16(s0)
 648:	ec14                	sd	a3,24(s0)
 64a:	f018                	sd	a4,32(s0)
 64c:	f41c                	sd	a5,40(s0)
 64e:	03043823          	sd	a6,48(s0)
 652:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 656:	00840613          	addi	a2,s0,8
 65a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 65e:	85aa                	mv	a1,a0
 660:	4505                	li	a0,1
 662:	00000097          	auipc	ra,0x0
 666:	dce080e7          	jalr	-562(ra) # 430 <vprintf>
}
 66a:	60e2                	ld	ra,24(sp)
 66c:	6442                	ld	s0,16(sp)
 66e:	6125                	addi	sp,sp,96
 670:	8082                	ret

0000000000000672 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 672:	1141                	addi	sp,sp,-16
 674:	e422                	sd	s0,8(sp)
 676:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 678:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 67c:	00000797          	auipc	a5,0x0
 680:	56c7b783          	ld	a5,1388(a5) # be8 <freep>
 684:	a805                	j	6b4 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 686:	4618                	lw	a4,8(a2)
 688:	9db9                	addw	a1,a1,a4
 68a:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 68e:	6398                	ld	a4,0(a5)
 690:	6318                	ld	a4,0(a4)
 692:	fee53823          	sd	a4,-16(a0)
 696:	a091                	j	6da <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 698:	ff852703          	lw	a4,-8(a0)
 69c:	9e39                	addw	a2,a2,a4
 69e:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 6a0:	ff053703          	ld	a4,-16(a0)
 6a4:	e398                	sd	a4,0(a5)
 6a6:	a099                	j	6ec <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a8:	6398                	ld	a4,0(a5)
 6aa:	00e7e463          	bltu	a5,a4,6b2 <free+0x40>
 6ae:	00e6ea63          	bltu	a3,a4,6c2 <free+0x50>
{
 6b2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b4:	fed7fae3          	bgeu	a5,a3,6a8 <free+0x36>
 6b8:	6398                	ld	a4,0(a5)
 6ba:	00e6e463          	bltu	a3,a4,6c2 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6be:	fee7eae3          	bltu	a5,a4,6b2 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 6c2:	ff852583          	lw	a1,-8(a0)
 6c6:	6390                	ld	a2,0(a5)
 6c8:	02059713          	slli	a4,a1,0x20
 6cc:	9301                	srli	a4,a4,0x20
 6ce:	0712                	slli	a4,a4,0x4
 6d0:	9736                	add	a4,a4,a3
 6d2:	fae60ae3          	beq	a2,a4,686 <free+0x14>
    bp->s.ptr = p->s.ptr;
 6d6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6da:	4790                	lw	a2,8(a5)
 6dc:	02061713          	slli	a4,a2,0x20
 6e0:	9301                	srli	a4,a4,0x20
 6e2:	0712                	slli	a4,a4,0x4
 6e4:	973e                	add	a4,a4,a5
 6e6:	fae689e3          	beq	a3,a4,698 <free+0x26>
  } else
    p->s.ptr = bp;
 6ea:	e394                	sd	a3,0(a5)
  freep = p;
 6ec:	00000717          	auipc	a4,0x0
 6f0:	4ef73e23          	sd	a5,1276(a4) # be8 <freep>
}
 6f4:	6422                	ld	s0,8(sp)
 6f6:	0141                	addi	sp,sp,16
 6f8:	8082                	ret

00000000000006fa <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6fa:	7139                	addi	sp,sp,-64
 6fc:	fc06                	sd	ra,56(sp)
 6fe:	f822                	sd	s0,48(sp)
 700:	f426                	sd	s1,40(sp)
 702:	f04a                	sd	s2,32(sp)
 704:	ec4e                	sd	s3,24(sp)
 706:	e852                	sd	s4,16(sp)
 708:	e456                	sd	s5,8(sp)
 70a:	e05a                	sd	s6,0(sp)
 70c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 70e:	02051493          	slli	s1,a0,0x20
 712:	9081                	srli	s1,s1,0x20
 714:	04bd                	addi	s1,s1,15
 716:	8091                	srli	s1,s1,0x4
 718:	0014899b          	addiw	s3,s1,1
 71c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 71e:	00000517          	auipc	a0,0x0
 722:	4ca53503          	ld	a0,1226(a0) # be8 <freep>
 726:	c515                	beqz	a0,752 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 728:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 72a:	4798                	lw	a4,8(a5)
 72c:	02977f63          	bgeu	a4,s1,76a <malloc+0x70>
 730:	8a4e                	mv	s4,s3
 732:	0009871b          	sext.w	a4,s3
 736:	6685                	lui	a3,0x1
 738:	00d77363          	bgeu	a4,a3,73e <malloc+0x44>
 73c:	6a05                	lui	s4,0x1
 73e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 742:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 746:	00000917          	auipc	s2,0x0
 74a:	4a290913          	addi	s2,s2,1186 # be8 <freep>
  if(p == (char*)-1)
 74e:	5afd                	li	s5,-1
 750:	a88d                	j	7c2 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 752:	00000797          	auipc	a5,0x0
 756:	49e78793          	addi	a5,a5,1182 # bf0 <base>
 75a:	00000717          	auipc	a4,0x0
 75e:	48f73723          	sd	a5,1166(a4) # be8 <freep>
 762:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 764:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 768:	b7e1                	j	730 <malloc+0x36>
      if(p->s.size == nunits)
 76a:	02e48b63          	beq	s1,a4,7a0 <malloc+0xa6>
        p->s.size -= nunits;
 76e:	4137073b          	subw	a4,a4,s3
 772:	c798                	sw	a4,8(a5)
        p += p->s.size;
 774:	1702                	slli	a4,a4,0x20
 776:	9301                	srli	a4,a4,0x20
 778:	0712                	slli	a4,a4,0x4
 77a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 77c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 780:	00000717          	auipc	a4,0x0
 784:	46a73423          	sd	a0,1128(a4) # be8 <freep>
      return (void*)(p + 1);
 788:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 78c:	70e2                	ld	ra,56(sp)
 78e:	7442                	ld	s0,48(sp)
 790:	74a2                	ld	s1,40(sp)
 792:	7902                	ld	s2,32(sp)
 794:	69e2                	ld	s3,24(sp)
 796:	6a42                	ld	s4,16(sp)
 798:	6aa2                	ld	s5,8(sp)
 79a:	6b02                	ld	s6,0(sp)
 79c:	6121                	addi	sp,sp,64
 79e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7a0:	6398                	ld	a4,0(a5)
 7a2:	e118                	sd	a4,0(a0)
 7a4:	bff1                	j	780 <malloc+0x86>
  hp->s.size = nu;
 7a6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7aa:	0541                	addi	a0,a0,16
 7ac:	00000097          	auipc	ra,0x0
 7b0:	ec6080e7          	jalr	-314(ra) # 672 <free>
  return freep;
 7b4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7b8:	d971                	beqz	a0,78c <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ba:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7bc:	4798                	lw	a4,8(a5)
 7be:	fa9776e3          	bgeu	a4,s1,76a <malloc+0x70>
    if(p == freep)
 7c2:	00093703          	ld	a4,0(s2)
 7c6:	853e                	mv	a0,a5
 7c8:	fef719e3          	bne	a4,a5,7ba <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 7cc:	8552                	mv	a0,s4
 7ce:	00000097          	auipc	ra,0x0
 7d2:	b76080e7          	jalr	-1162(ra) # 344 <sbrk>
  if(p == (char*)-1)
 7d6:	fd5518e3          	bne	a0,s5,7a6 <malloc+0xac>
        return 0;
 7da:	4501                	li	a0,0
 7dc:	bf45                	j	78c <malloc+0x92>

00000000000007de <Pipe>:
#include "kernel/stat.h"
#include "user.h"
#include "wrapper.h"
int strncmp(const char*s, const char*pat,int n);

int Pipe(int *p) {
 7de:	1101                	addi	sp,sp,-32
 7e0:	ec06                	sd	ra,24(sp)
 7e2:	e822                	sd	s0,16(sp)
 7e4:	e426                	sd	s1,8(sp)
 7e6:	1000                	addi	s0,sp,32
  i32 res = pipe(p);
 7e8:	00000097          	auipc	ra,0x0
 7ec:	ae4080e7          	jalr	-1308(ra) # 2cc <pipe>
 7f0:	84aa                	mv	s1,a0
  if (res < 0) {
 7f2:	00054863          	bltz	a0,802 <Pipe+0x24>
    fprintf(2, "pipe creation error");
  }
  return res;
}
 7f6:	8526                	mv	a0,s1
 7f8:	60e2                	ld	ra,24(sp)
 7fa:	6442                	ld	s0,16(sp)
 7fc:	64a2                	ld	s1,8(sp)
 7fe:	6105                	addi	sp,sp,32
 800:	8082                	ret
    fprintf(2, "pipe creation error");
 802:	00000597          	auipc	a1,0x0
 806:	34658593          	addi	a1,a1,838 # b48 <digits+0x18>
 80a:	4509                	li	a0,2
 80c:	00000097          	auipc	ra,0x0
 810:	e02080e7          	jalr	-510(ra) # 60e <fprintf>
 814:	b7cd                	j	7f6 <Pipe+0x18>

0000000000000816 <Write>:

int Write(int fd, void *buf, int count){
 816:	1141                	addi	sp,sp,-16
 818:	e406                	sd	ra,8(sp)
 81a:	e022                	sd	s0,0(sp)
 81c:	0800                	addi	s0,sp,16
  i32 res = write(fd, buf, count);
 81e:	00000097          	auipc	ra,0x0
 822:	abe080e7          	jalr	-1346(ra) # 2dc <write>
  if (res < 0) {
 826:	00054663          	bltz	a0,832 <Write+0x1c>
    fprintf(2, "write error");
    exit(0);
  }
  return res;
}
 82a:	60a2                	ld	ra,8(sp)
 82c:	6402                	ld	s0,0(sp)
 82e:	0141                	addi	sp,sp,16
 830:	8082                	ret
    fprintf(2, "write error");
 832:	00000597          	auipc	a1,0x0
 836:	32e58593          	addi	a1,a1,814 # b60 <digits+0x30>
 83a:	4509                	li	a0,2
 83c:	00000097          	auipc	ra,0x0
 840:	dd2080e7          	jalr	-558(ra) # 60e <fprintf>
    exit(0);
 844:	4501                	li	a0,0
 846:	00000097          	auipc	ra,0x0
 84a:	a76080e7          	jalr	-1418(ra) # 2bc <exit>

000000000000084e <Read>:



int Read(int fd,  void*buf, int count){
 84e:	1141                	addi	sp,sp,-16
 850:	e406                	sd	ra,8(sp)
 852:	e022                	sd	s0,0(sp)
 854:	0800                	addi	s0,sp,16
  i32 res = read(fd, buf, count);
 856:	00000097          	auipc	ra,0x0
 85a:	a7e080e7          	jalr	-1410(ra) # 2d4 <read>
  if (res < 0) {
 85e:	00054663          	bltz	a0,86a <Read+0x1c>
    fprintf(2, "read error");
    exit(0);
  }
  return res;
}
 862:	60a2                	ld	ra,8(sp)
 864:	6402                	ld	s0,0(sp)
 866:	0141                	addi	sp,sp,16
 868:	8082                	ret
    fprintf(2, "read error");
 86a:	00000597          	auipc	a1,0x0
 86e:	30658593          	addi	a1,a1,774 # b70 <digits+0x40>
 872:	4509                	li	a0,2
 874:	00000097          	auipc	ra,0x0
 878:	d9a080e7          	jalr	-614(ra) # 60e <fprintf>
    exit(0);
 87c:	4501                	li	a0,0
 87e:	00000097          	auipc	ra,0x0
 882:	a3e080e7          	jalr	-1474(ra) # 2bc <exit>

0000000000000886 <Open>:


int Open(const char* path, int flag){
 886:	1141                	addi	sp,sp,-16
 888:	e406                	sd	ra,8(sp)
 88a:	e022                	sd	s0,0(sp)
 88c:	0800                	addi	s0,sp,16
  i32 res = open(path, flag);
 88e:	00000097          	auipc	ra,0x0
 892:	a6e080e7          	jalr	-1426(ra) # 2fc <open>
  if (res < 0) {
 896:	00054663          	bltz	a0,8a2 <Open+0x1c>
    fprintf(2, "open error");
    exit(0);
  }
  return res;
}
 89a:	60a2                	ld	ra,8(sp)
 89c:	6402                	ld	s0,0(sp)
 89e:	0141                	addi	sp,sp,16
 8a0:	8082                	ret
    fprintf(2, "open error");
 8a2:	00000597          	auipc	a1,0x0
 8a6:	2de58593          	addi	a1,a1,734 # b80 <digits+0x50>
 8aa:	4509                	li	a0,2
 8ac:	00000097          	auipc	ra,0x0
 8b0:	d62080e7          	jalr	-670(ra) # 60e <fprintf>
    exit(0);
 8b4:	4501                	li	a0,0
 8b6:	00000097          	auipc	ra,0x0
 8ba:	a06080e7          	jalr	-1530(ra) # 2bc <exit>

00000000000008be <Fstat>:


int Fstat(int fd, stat_t *st){
 8be:	1141                	addi	sp,sp,-16
 8c0:	e406                	sd	ra,8(sp)
 8c2:	e022                	sd	s0,0(sp)
 8c4:	0800                	addi	s0,sp,16
  i32 res = fstat(fd, st);
 8c6:	00000097          	auipc	ra,0x0
 8ca:	a4e080e7          	jalr	-1458(ra) # 314 <fstat>
  if (res < 0) {
 8ce:	00054663          	bltz	a0,8da <Fstat+0x1c>
    fprintf(2, "get file stat error");
    exit(0);
  }
  return res;
}
 8d2:	60a2                	ld	ra,8(sp)
 8d4:	6402                	ld	s0,0(sp)
 8d6:	0141                	addi	sp,sp,16
 8d8:	8082                	ret
    fprintf(2, "get file stat error");
 8da:	00000597          	auipc	a1,0x0
 8de:	2b658593          	addi	a1,a1,694 # b90 <digits+0x60>
 8e2:	4509                	li	a0,2
 8e4:	00000097          	auipc	ra,0x0
 8e8:	d2a080e7          	jalr	-726(ra) # 60e <fprintf>
    exit(0);
 8ec:	4501                	li	a0,0
 8ee:	00000097          	auipc	ra,0x0
 8f2:	9ce080e7          	jalr	-1586(ra) # 2bc <exit>

00000000000008f6 <Dup>:



int Dup(int fd){
 8f6:	1141                	addi	sp,sp,-16
 8f8:	e406                	sd	ra,8(sp)
 8fa:	e022                	sd	s0,0(sp)
 8fc:	0800                	addi	s0,sp,16
  i32 res = dup(fd);
 8fe:	00000097          	auipc	ra,0x0
 902:	a36080e7          	jalr	-1482(ra) # 334 <dup>
  if (res < 0) {
 906:	00054663          	bltz	a0,912 <Dup+0x1c>
    fprintf(2, "dup error");
    exit(0);
  }
  return res;

}
 90a:	60a2                	ld	ra,8(sp)
 90c:	6402                	ld	s0,0(sp)
 90e:	0141                	addi	sp,sp,16
 910:	8082                	ret
    fprintf(2, "dup error");
 912:	00000597          	auipc	a1,0x0
 916:	29658593          	addi	a1,a1,662 # ba8 <digits+0x78>
 91a:	4509                	li	a0,2
 91c:	00000097          	auipc	ra,0x0
 920:	cf2080e7          	jalr	-782(ra) # 60e <fprintf>
    exit(0);
 924:	4501                	li	a0,0
 926:	00000097          	auipc	ra,0x0
 92a:	996080e7          	jalr	-1642(ra) # 2bc <exit>

000000000000092e <Close>:

int Close(int fd){
 92e:	1141                	addi	sp,sp,-16
 930:	e406                	sd	ra,8(sp)
 932:	e022                	sd	s0,0(sp)
 934:	0800                	addi	s0,sp,16
  i32 res = close(fd);
 936:	00000097          	auipc	ra,0x0
 93a:	9ae080e7          	jalr	-1618(ra) # 2e4 <close>
  if (res < 0) {
 93e:	00054663          	bltz	a0,94a <Close+0x1c>
    fprintf(2, "file close error~");
    exit(0);
  }
  return res;
}
 942:	60a2                	ld	ra,8(sp)
 944:	6402                	ld	s0,0(sp)
 946:	0141                	addi	sp,sp,16
 948:	8082                	ret
    fprintf(2, "file close error~");
 94a:	00000597          	auipc	a1,0x0
 94e:	26e58593          	addi	a1,a1,622 # bb8 <digits+0x88>
 952:	4509                	li	a0,2
 954:	00000097          	auipc	ra,0x0
 958:	cba080e7          	jalr	-838(ra) # 60e <fprintf>
    exit(0);
 95c:	4501                	li	a0,0
 95e:	00000097          	auipc	ra,0x0
 962:	95e080e7          	jalr	-1698(ra) # 2bc <exit>

0000000000000966 <Dup2>:

int Dup2(int old_fd,int new_fd){
 966:	1101                	addi	sp,sp,-32
 968:	ec06                	sd	ra,24(sp)
 96a:	e822                	sd	s0,16(sp)
 96c:	e426                	sd	s1,8(sp)
 96e:	1000                	addi	s0,sp,32
 970:	84aa                	mv	s1,a0
  Close(new_fd);
 972:	852e                	mv	a0,a1
 974:	00000097          	auipc	ra,0x0
 978:	fba080e7          	jalr	-70(ra) # 92e <Close>
  i32 res = Dup(old_fd);
 97c:	8526                	mv	a0,s1
 97e:	00000097          	auipc	ra,0x0
 982:	f78080e7          	jalr	-136(ra) # 8f6 <Dup>
  if (res < 0) {
 986:	00054763          	bltz	a0,994 <Dup2+0x2e>
    fprintf(2, "dup error");
    exit(0);
  }
  return res;
}
 98a:	60e2                	ld	ra,24(sp)
 98c:	6442                	ld	s0,16(sp)
 98e:	64a2                	ld	s1,8(sp)
 990:	6105                	addi	sp,sp,32
 992:	8082                	ret
    fprintf(2, "dup error");
 994:	00000597          	auipc	a1,0x0
 998:	21458593          	addi	a1,a1,532 # ba8 <digits+0x78>
 99c:	4509                	li	a0,2
 99e:	00000097          	auipc	ra,0x0
 9a2:	c70080e7          	jalr	-912(ra) # 60e <fprintf>
    exit(0);
 9a6:	4501                	li	a0,0
 9a8:	00000097          	auipc	ra,0x0
 9ac:	914080e7          	jalr	-1772(ra) # 2bc <exit>

00000000000009b0 <Stat>:

int Stat(const char*link,stat_t *st){
 9b0:	1101                	addi	sp,sp,-32
 9b2:	ec06                	sd	ra,24(sp)
 9b4:	e822                	sd	s0,16(sp)
 9b6:	e426                	sd	s1,8(sp)
 9b8:	1000                	addi	s0,sp,32
 9ba:	84aa                	mv	s1,a0
  i32 res = stat(link,st);
 9bc:	fffff097          	auipc	ra,0xfffff
 9c0:	7be080e7          	jalr	1982(ra) # 17a <stat>
  if (res < 0) {
 9c4:	00054763          	bltz	a0,9d2 <Stat+0x22>
    fprintf(2, "file %s stat error",link);
    exit(0);
  }
  return res;
}
 9c8:	60e2                	ld	ra,24(sp)
 9ca:	6442                	ld	s0,16(sp)
 9cc:	64a2                	ld	s1,8(sp)
 9ce:	6105                	addi	sp,sp,32
 9d0:	8082                	ret
    fprintf(2, "file %s stat error",link);
 9d2:	8626                	mv	a2,s1
 9d4:	00000597          	auipc	a1,0x0
 9d8:	1fc58593          	addi	a1,a1,508 # bd0 <digits+0xa0>
 9dc:	4509                	li	a0,2
 9de:	00000097          	auipc	ra,0x0
 9e2:	c30080e7          	jalr	-976(ra) # 60e <fprintf>
    exit(0);
 9e6:	4501                	li	a0,0
 9e8:	00000097          	auipc	ra,0x0
 9ec:	8d4080e7          	jalr	-1836(ra) # 2bc <exit>

00000000000009f0 <strncmp>:
   return -1;
}



int strncmp(const char*s, const char*pat,int n){
 9f0:	bc010113          	addi	sp,sp,-1088
 9f4:	42113c23          	sd	ra,1080(sp)
 9f8:	42813823          	sd	s0,1072(sp)
 9fc:	42913423          	sd	s1,1064(sp)
 a00:	43213023          	sd	s2,1056(sp)
 a04:	41313c23          	sd	s3,1048(sp)
 a08:	41413823          	sd	s4,1040(sp)
 a0c:	41513423          	sd	s5,1032(sp)
 a10:	44010413          	addi	s0,sp,1088
 a14:	89aa                	mv	s3,a0
 a16:	892e                	mv	s2,a1
 a18:	84b2                	mv	s1,a2
  char buf1[512],buf2[512];
  int n1 = MIN(n,strlen(s));
 a1a:	fffff097          	auipc	ra,0xfffff
 a1e:	67c080e7          	jalr	1660(ra) # 96 <strlen>
 a22:	2501                	sext.w	a0,a0
 a24:	00048a1b          	sext.w	s4,s1
 a28:	8aa6                	mv	s5,s1
 a2a:	06aa7363          	bgeu	s4,a0,a90 <strncmp+0xa0>
  int n2 = MIN(n,strlen(pat));
 a2e:	854a                	mv	a0,s2
 a30:	fffff097          	auipc	ra,0xfffff
 a34:	666080e7          	jalr	1638(ra) # 96 <strlen>
 a38:	2501                	sext.w	a0,a0
 a3a:	06aa7363          	bgeu	s4,a0,aa0 <strncmp+0xb0>
  memmove(buf1,s,n1);
 a3e:	8656                	mv	a2,s5
 a40:	85ce                	mv	a1,s3
 a42:	dc040513          	addi	a0,s0,-576
 a46:	fffff097          	auipc	ra,0xfffff
 a4a:	7c4080e7          	jalr	1988(ra) # 20a <memmove>
  memmove(buf2,pat,n2);
 a4e:	8626                	mv	a2,s1
 a50:	85ca                	mv	a1,s2
 a52:	bc040513          	addi	a0,s0,-1088
 a56:	fffff097          	auipc	ra,0xfffff
 a5a:	7b4080e7          	jalr	1972(ra) # 20a <memmove>
  return strcmp(buf1,buf2);
 a5e:	bc040593          	addi	a1,s0,-1088
 a62:	dc040513          	addi	a0,s0,-576
 a66:	fffff097          	auipc	ra,0xfffff
 a6a:	604080e7          	jalr	1540(ra) # 6a <strcmp>
}
 a6e:	43813083          	ld	ra,1080(sp)
 a72:	43013403          	ld	s0,1072(sp)
 a76:	42813483          	ld	s1,1064(sp)
 a7a:	42013903          	ld	s2,1056(sp)
 a7e:	41813983          	ld	s3,1048(sp)
 a82:	41013a03          	ld	s4,1040(sp)
 a86:	40813a83          	ld	s5,1032(sp)
 a8a:	44010113          	addi	sp,sp,1088
 a8e:	8082                	ret
  int n1 = MIN(n,strlen(s));
 a90:	854e                	mv	a0,s3
 a92:	fffff097          	auipc	ra,0xfffff
 a96:	604080e7          	jalr	1540(ra) # 96 <strlen>
 a9a:	00050a9b          	sext.w	s5,a0
 a9e:	bf41                	j	a2e <strncmp+0x3e>
  int n2 = MIN(n,strlen(pat));
 aa0:	854a                	mv	a0,s2
 aa2:	fffff097          	auipc	ra,0xfffff
 aa6:	5f4080e7          	jalr	1524(ra) # 96 <strlen>
 aaa:	0005049b          	sext.w	s1,a0
 aae:	bf41                	j	a3e <strncmp+0x4e>

0000000000000ab0 <strstr>:
   while (*s != 0){
 ab0:	00054783          	lbu	a5,0(a0)
 ab4:	cba1                	beqz	a5,b04 <strstr+0x54>
int strstr(char *s,char *p){
 ab6:	7179                	addi	sp,sp,-48
 ab8:	f406                	sd	ra,40(sp)
 aba:	f022                	sd	s0,32(sp)
 abc:	ec26                	sd	s1,24(sp)
 abe:	e84a                	sd	s2,16(sp)
 ac0:	e44e                	sd	s3,8(sp)
 ac2:	1800                	addi	s0,sp,48
 ac4:	89aa                	mv	s3,a0
 ac6:	892e                	mv	s2,a1
   while (*s != 0){
 ac8:	84aa                	mv	s1,a0
     if (!strncmp(s,p,strlen(p)))
 aca:	854a                	mv	a0,s2
 acc:	fffff097          	auipc	ra,0xfffff
 ad0:	5ca080e7          	jalr	1482(ra) # 96 <strlen>
 ad4:	0005061b          	sext.w	a2,a0
 ad8:	85ca                	mv	a1,s2
 ada:	8526                	mv	a0,s1
 adc:	00000097          	auipc	ra,0x0
 ae0:	f14080e7          	jalr	-236(ra) # 9f0 <strncmp>
 ae4:	c519                	beqz	a0,af2 <strstr+0x42>
     s++;
 ae6:	0485                	addi	s1,s1,1
   while (*s != 0){
 ae8:	0004c783          	lbu	a5,0(s1)
 aec:	fff9                	bnez	a5,aca <strstr+0x1a>
   return -1;
 aee:	557d                	li	a0,-1
 af0:	a019                	j	af6 <strstr+0x46>
      return s - ori;
 af2:	4134853b          	subw	a0,s1,s3
}
 af6:	70a2                	ld	ra,40(sp)
 af8:	7402                	ld	s0,32(sp)
 afa:	64e2                	ld	s1,24(sp)
 afc:	6942                	ld	s2,16(sp)
 afe:	69a2                	ld	s3,8(sp)
 b00:	6145                	addi	sp,sp,48
 b02:	8082                	ret
   return -1;
 b04:	557d                	li	a0,-1
}
 b06:	8082                	ret
