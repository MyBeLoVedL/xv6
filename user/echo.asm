
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  int i;

  for(i = 1; i < argc; i++){
  10:	4785                	li	a5,1
  12:	06a7d463          	bge	a5,a0,7a <main+0x7a>
  16:	00858493          	addi	s1,a1,8
  1a:	ffe5099b          	addiw	s3,a0,-2
  1e:	1982                	slli	s3,s3,0x20
  20:	0209d993          	srli	s3,s3,0x20
  24:	098e                	slli	s3,s3,0x3
  26:	05c1                	addi	a1,a1,16
  28:	99ae                	add	s3,s3,a1
    write(1, argv[i], strlen(argv[i]));
    if(i + 1 < argc){
      write(1, " ", 1);
  2a:	00001a17          	auipc	s4,0x1
  2e:	b26a0a13          	addi	s4,s4,-1242 # b50 <strstr+0x5a>
    write(1, argv[i], strlen(argv[i]));
  32:	0004b903          	ld	s2,0(s1)
  36:	854a                	mv	a0,s2
  38:	00000097          	auipc	ra,0x0
  3c:	094080e7          	jalr	148(ra) # cc <strlen>
  40:	0005061b          	sext.w	a2,a0
  44:	85ca                	mv	a1,s2
  46:	4505                	li	a0,1
  48:	00000097          	auipc	ra,0x0
  4c:	2ca080e7          	jalr	714(ra) # 312 <write>
    if(i + 1 < argc){
  50:	04a1                	addi	s1,s1,8
  52:	01348a63          	beq	s1,s3,66 <main+0x66>
      write(1, " ", 1);
  56:	4605                	li	a2,1
  58:	85d2                	mv	a1,s4
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	2b6080e7          	jalr	694(ra) # 312 <write>
  for(i = 1; i < argc; i++){
  64:	b7f9                	j	32 <main+0x32>
    } else {
      write(1, "\n", 1);
  66:	4605                	li	a2,1
  68:	00001597          	auipc	a1,0x1
  6c:	af058593          	addi	a1,a1,-1296 # b58 <strstr+0x62>
  70:	4505                	li	a0,1
  72:	00000097          	auipc	ra,0x0
  76:	2a0080e7          	jalr	672(ra) # 312 <write>
    }
  }
  exit(0);
  7a:	4501                	li	a0,0
  7c:	00000097          	auipc	ra,0x0
  80:	276080e7          	jalr	630(ra) # 2f2 <exit>

0000000000000084 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  84:	1141                	addi	sp,sp,-16
  86:	e422                	sd	s0,8(sp)
  88:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  8a:	87aa                	mv	a5,a0
  8c:	0585                	addi	a1,a1,1
  8e:	0785                	addi	a5,a5,1
  90:	fff5c703          	lbu	a4,-1(a1)
  94:	fee78fa3          	sb	a4,-1(a5)
  98:	fb75                	bnez	a4,8c <strcpy+0x8>
    ;
  return os;
}
  9a:	6422                	ld	s0,8(sp)
  9c:	0141                	addi	sp,sp,16
  9e:	8082                	ret

00000000000000a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a0:	1141                	addi	sp,sp,-16
  a2:	e422                	sd	s0,8(sp)
  a4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  a6:	00054783          	lbu	a5,0(a0)
  aa:	cb91                	beqz	a5,be <strcmp+0x1e>
  ac:	0005c703          	lbu	a4,0(a1)
  b0:	00f71763          	bne	a4,a5,be <strcmp+0x1e>
    p++, q++;
  b4:	0505                	addi	a0,a0,1
  b6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  b8:	00054783          	lbu	a5,0(a0)
  bc:	fbe5                	bnez	a5,ac <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  be:	0005c503          	lbu	a0,0(a1)
}
  c2:	40a7853b          	subw	a0,a5,a0
  c6:	6422                	ld	s0,8(sp)
  c8:	0141                	addi	sp,sp,16
  ca:	8082                	ret

00000000000000cc <strlen>:

uint
strlen(const char *s)
{
  cc:	1141                	addi	sp,sp,-16
  ce:	e422                	sd	s0,8(sp)
  d0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  d2:	00054783          	lbu	a5,0(a0)
  d6:	cf91                	beqz	a5,f2 <strlen+0x26>
  d8:	0505                	addi	a0,a0,1
  da:	87aa                	mv	a5,a0
  dc:	4685                	li	a3,1
  de:	9e89                	subw	a3,a3,a0
  e0:	00f6853b          	addw	a0,a3,a5
  e4:	0785                	addi	a5,a5,1
  e6:	fff7c703          	lbu	a4,-1(a5)
  ea:	fb7d                	bnez	a4,e0 <strlen+0x14>
    ;
  return n;
}
  ec:	6422                	ld	s0,8(sp)
  ee:	0141                	addi	sp,sp,16
  f0:	8082                	ret
  for(n = 0; s[n]; n++)
  f2:	4501                	li	a0,0
  f4:	bfe5                	j	ec <strlen+0x20>

00000000000000f6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e422                	sd	s0,8(sp)
  fa:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  fc:	ca19                	beqz	a2,112 <memset+0x1c>
  fe:	87aa                	mv	a5,a0
 100:	1602                	slli	a2,a2,0x20
 102:	9201                	srli	a2,a2,0x20
 104:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 108:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 10c:	0785                	addi	a5,a5,1
 10e:	fee79de3          	bne	a5,a4,108 <memset+0x12>
  }
  return dst;
}
 112:	6422                	ld	s0,8(sp)
 114:	0141                	addi	sp,sp,16
 116:	8082                	ret

0000000000000118 <strchr>:

char*
strchr(const char *s, char c)
{
 118:	1141                	addi	sp,sp,-16
 11a:	e422                	sd	s0,8(sp)
 11c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 11e:	00054783          	lbu	a5,0(a0)
 122:	cb99                	beqz	a5,138 <strchr+0x20>
    if(*s == c)
 124:	00f58763          	beq	a1,a5,132 <strchr+0x1a>
  for(; *s; s++)
 128:	0505                	addi	a0,a0,1
 12a:	00054783          	lbu	a5,0(a0)
 12e:	fbfd                	bnez	a5,124 <strchr+0xc>
      return (char*)s;
  return 0;
 130:	4501                	li	a0,0
}
 132:	6422                	ld	s0,8(sp)
 134:	0141                	addi	sp,sp,16
 136:	8082                	ret
  return 0;
 138:	4501                	li	a0,0
 13a:	bfe5                	j	132 <strchr+0x1a>

000000000000013c <gets>:

char*
gets(char *buf, int max)
{
 13c:	711d                	addi	sp,sp,-96
 13e:	ec86                	sd	ra,88(sp)
 140:	e8a2                	sd	s0,80(sp)
 142:	e4a6                	sd	s1,72(sp)
 144:	e0ca                	sd	s2,64(sp)
 146:	fc4e                	sd	s3,56(sp)
 148:	f852                	sd	s4,48(sp)
 14a:	f456                	sd	s5,40(sp)
 14c:	f05a                	sd	s6,32(sp)
 14e:	ec5e                	sd	s7,24(sp)
 150:	1080                	addi	s0,sp,96
 152:	8baa                	mv	s7,a0
 154:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 156:	892a                	mv	s2,a0
 158:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 15a:	4aa9                	li	s5,10
 15c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 15e:	89a6                	mv	s3,s1
 160:	2485                	addiw	s1,s1,1
 162:	0344d863          	bge	s1,s4,192 <gets+0x56>
    cc = read(0, &c, 1);
 166:	4605                	li	a2,1
 168:	faf40593          	addi	a1,s0,-81
 16c:	4501                	li	a0,0
 16e:	00000097          	auipc	ra,0x0
 172:	19c080e7          	jalr	412(ra) # 30a <read>
    if(cc < 1)
 176:	00a05e63          	blez	a0,192 <gets+0x56>
    buf[i++] = c;
 17a:	faf44783          	lbu	a5,-81(s0)
 17e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 182:	01578763          	beq	a5,s5,190 <gets+0x54>
 186:	0905                	addi	s2,s2,1
 188:	fd679be3          	bne	a5,s6,15e <gets+0x22>
  for(i=0; i+1 < max; ){
 18c:	89a6                	mv	s3,s1
 18e:	a011                	j	192 <gets+0x56>
 190:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 192:	99de                	add	s3,s3,s7
 194:	00098023          	sb	zero,0(s3)
  return buf;
}
 198:	855e                	mv	a0,s7
 19a:	60e6                	ld	ra,88(sp)
 19c:	6446                	ld	s0,80(sp)
 19e:	64a6                	ld	s1,72(sp)
 1a0:	6906                	ld	s2,64(sp)
 1a2:	79e2                	ld	s3,56(sp)
 1a4:	7a42                	ld	s4,48(sp)
 1a6:	7aa2                	ld	s5,40(sp)
 1a8:	7b02                	ld	s6,32(sp)
 1aa:	6be2                	ld	s7,24(sp)
 1ac:	6125                	addi	sp,sp,96
 1ae:	8082                	ret

00000000000001b0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1b0:	1101                	addi	sp,sp,-32
 1b2:	ec06                	sd	ra,24(sp)
 1b4:	e822                	sd	s0,16(sp)
 1b6:	e426                	sd	s1,8(sp)
 1b8:	e04a                	sd	s2,0(sp)
 1ba:	1000                	addi	s0,sp,32
 1bc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1be:	4581                	li	a1,0
 1c0:	00000097          	auipc	ra,0x0
 1c4:	172080e7          	jalr	370(ra) # 332 <open>
  if(fd < 0)
 1c8:	02054563          	bltz	a0,1f2 <stat+0x42>
 1cc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1ce:	85ca                	mv	a1,s2
 1d0:	00000097          	auipc	ra,0x0
 1d4:	17a080e7          	jalr	378(ra) # 34a <fstat>
 1d8:	892a                	mv	s2,a0
  close(fd);
 1da:	8526                	mv	a0,s1
 1dc:	00000097          	auipc	ra,0x0
 1e0:	13e080e7          	jalr	318(ra) # 31a <close>
  return r;
}
 1e4:	854a                	mv	a0,s2
 1e6:	60e2                	ld	ra,24(sp)
 1e8:	6442                	ld	s0,16(sp)
 1ea:	64a2                	ld	s1,8(sp)
 1ec:	6902                	ld	s2,0(sp)
 1ee:	6105                	addi	sp,sp,32
 1f0:	8082                	ret
    return -1;
 1f2:	597d                	li	s2,-1
 1f4:	bfc5                	j	1e4 <stat+0x34>

00000000000001f6 <atoi>:

int
atoi(const char *s)
{
 1f6:	1141                	addi	sp,sp,-16
 1f8:	e422                	sd	s0,8(sp)
 1fa:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1fc:	00054603          	lbu	a2,0(a0)
 200:	fd06079b          	addiw	a5,a2,-48
 204:	0ff7f793          	andi	a5,a5,255
 208:	4725                	li	a4,9
 20a:	02f76963          	bltu	a4,a5,23c <atoi+0x46>
 20e:	86aa                	mv	a3,a0
  n = 0;
 210:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 212:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 214:	0685                	addi	a3,a3,1
 216:	0025179b          	slliw	a5,a0,0x2
 21a:	9fa9                	addw	a5,a5,a0
 21c:	0017979b          	slliw	a5,a5,0x1
 220:	9fb1                	addw	a5,a5,a2
 222:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 226:	0006c603          	lbu	a2,0(a3)
 22a:	fd06071b          	addiw	a4,a2,-48
 22e:	0ff77713          	andi	a4,a4,255
 232:	fee5f1e3          	bgeu	a1,a4,214 <atoi+0x1e>
  return n;
}
 236:	6422                	ld	s0,8(sp)
 238:	0141                	addi	sp,sp,16
 23a:	8082                	ret
  n = 0;
 23c:	4501                	li	a0,0
 23e:	bfe5                	j	236 <atoi+0x40>

0000000000000240 <memmove>:

// #define memcpy memmove

void*
memmove(void *vdst, const void *vsrc, int n)
{
 240:	1141                	addi	sp,sp,-16
 242:	e422                	sd	s0,8(sp)
 244:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 246:	02b57463          	bgeu	a0,a1,26e <memmove+0x2e>
    while(n-- > 0)
 24a:	00c05f63          	blez	a2,268 <memmove+0x28>
 24e:	1602                	slli	a2,a2,0x20
 250:	9201                	srli	a2,a2,0x20
 252:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 256:	872a                	mv	a4,a0
      *dst++ = *src++;
 258:	0585                	addi	a1,a1,1
 25a:	0705                	addi	a4,a4,1
 25c:	fff5c683          	lbu	a3,-1(a1)
 260:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 264:	fee79ae3          	bne	a5,a4,258 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 268:	6422                	ld	s0,8(sp)
 26a:	0141                	addi	sp,sp,16
 26c:	8082                	ret
    dst += n;
 26e:	00c50733          	add	a4,a0,a2
    src += n;
 272:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 274:	fec05ae3          	blez	a2,268 <memmove+0x28>
 278:	fff6079b          	addiw	a5,a2,-1
 27c:	1782                	slli	a5,a5,0x20
 27e:	9381                	srli	a5,a5,0x20
 280:	fff7c793          	not	a5,a5
 284:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 286:	15fd                	addi	a1,a1,-1
 288:	177d                	addi	a4,a4,-1
 28a:	0005c683          	lbu	a3,0(a1)
 28e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 292:	fee79ae3          	bne	a5,a4,286 <memmove+0x46>
 296:	bfc9                	j	268 <memmove+0x28>

0000000000000298 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 298:	1141                	addi	sp,sp,-16
 29a:	e422                	sd	s0,8(sp)
 29c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 29e:	ca05                	beqz	a2,2ce <memcmp+0x36>
 2a0:	fff6069b          	addiw	a3,a2,-1
 2a4:	1682                	slli	a3,a3,0x20
 2a6:	9281                	srli	a3,a3,0x20
 2a8:	0685                	addi	a3,a3,1
 2aa:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2ac:	00054783          	lbu	a5,0(a0)
 2b0:	0005c703          	lbu	a4,0(a1)
 2b4:	00e79863          	bne	a5,a4,2c4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2b8:	0505                	addi	a0,a0,1
    p2++;
 2ba:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2bc:	fed518e3          	bne	a0,a3,2ac <memcmp+0x14>
  }
  return 0;
 2c0:	4501                	li	a0,0
 2c2:	a019                	j	2c8 <memcmp+0x30>
      return *p1 - *p2;
 2c4:	40e7853b          	subw	a0,a5,a4
}
 2c8:	6422                	ld	s0,8(sp)
 2ca:	0141                	addi	sp,sp,16
 2cc:	8082                	ret
  return 0;
 2ce:	4501                	li	a0,0
 2d0:	bfe5                	j	2c8 <memcmp+0x30>

00000000000002d2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2d2:	1141                	addi	sp,sp,-16
 2d4:	e406                	sd	ra,8(sp)
 2d6:	e022                	sd	s0,0(sp)
 2d8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2da:	00000097          	auipc	ra,0x0
 2de:	f66080e7          	jalr	-154(ra) # 240 <memmove>
}
 2e2:	60a2                	ld	ra,8(sp)
 2e4:	6402                	ld	s0,0(sp)
 2e6:	0141                	addi	sp,sp,16
 2e8:	8082                	ret

00000000000002ea <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2ea:	4885                	li	a7,1
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2f2:	4889                	li	a7,2
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <wait>:
.global wait
wait:
 li a7, SYS_wait
 2fa:	488d                	li	a7,3
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 302:	4891                	li	a7,4
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <read>:
.global read
read:
 li a7, SYS_read
 30a:	4895                	li	a7,5
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <write>:
.global write
write:
 li a7, SYS_write
 312:	48c1                	li	a7,16
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <close>:
.global close
close:
 li a7, SYS_close
 31a:	48d5                	li	a7,21
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <kill>:
.global kill
kill:
 li a7, SYS_kill
 322:	4899                	li	a7,6
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <exec>:
.global exec
exec:
 li a7, SYS_exec
 32a:	489d                	li	a7,7
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <open>:
.global open
open:
 li a7, SYS_open
 332:	48bd                	li	a7,15
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 33a:	48c5                	li	a7,17
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 342:	48c9                	li	a7,18
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 34a:	48a1                	li	a7,8
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <link>:
.global link
link:
 li a7, SYS_link
 352:	48cd                	li	a7,19
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 35a:	48d1                	li	a7,20
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 362:	48a5                	li	a7,9
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <dup>:
.global dup
dup:
 li a7, SYS_dup
 36a:	48a9                	li	a7,10
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 372:	48ad                	li	a7,11
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 37a:	48b1                	li	a7,12
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 382:	48b5                	li	a7,13
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 38a:	48b9                	li	a7,14
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <trace>:
.global trace
trace:
 li a7, SYS_trace
 392:	48d9                	li	a7,22
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <alarm>:
.global alarm
alarm:
 li a7, SYS_alarm
 39a:	48dd                	li	a7,23
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <alarmret>:
.global alarmret
alarmret:
 li a7, SYS_alarmret
 3a2:	48e1                	li	a7,24
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3aa:	1101                	addi	sp,sp,-32
 3ac:	ec06                	sd	ra,24(sp)
 3ae:	e822                	sd	s0,16(sp)
 3b0:	1000                	addi	s0,sp,32
 3b2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3b6:	4605                	li	a2,1
 3b8:	fef40593          	addi	a1,s0,-17
 3bc:	00000097          	auipc	ra,0x0
 3c0:	f56080e7          	jalr	-170(ra) # 312 <write>
}
 3c4:	60e2                	ld	ra,24(sp)
 3c6:	6442                	ld	s0,16(sp)
 3c8:	6105                	addi	sp,sp,32
 3ca:	8082                	ret

00000000000003cc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3cc:	7139                	addi	sp,sp,-64
 3ce:	fc06                	sd	ra,56(sp)
 3d0:	f822                	sd	s0,48(sp)
 3d2:	f426                	sd	s1,40(sp)
 3d4:	f04a                	sd	s2,32(sp)
 3d6:	ec4e                	sd	s3,24(sp)
 3d8:	0080                	addi	s0,sp,64
 3da:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3dc:	c299                	beqz	a3,3e2 <printint+0x16>
 3de:	0805c863          	bltz	a1,46e <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3e2:	2581                	sext.w	a1,a1
  neg = 0;
 3e4:	4881                	li	a7,0
 3e6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3ea:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3ec:	2601                	sext.w	a2,a2
 3ee:	00000517          	auipc	a0,0x0
 3f2:	77a50513          	addi	a0,a0,1914 # b68 <digits>
 3f6:	883a                	mv	a6,a4
 3f8:	2705                	addiw	a4,a4,1
 3fa:	02c5f7bb          	remuw	a5,a1,a2
 3fe:	1782                	slli	a5,a5,0x20
 400:	9381                	srli	a5,a5,0x20
 402:	97aa                	add	a5,a5,a0
 404:	0007c783          	lbu	a5,0(a5)
 408:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 40c:	0005879b          	sext.w	a5,a1
 410:	02c5d5bb          	divuw	a1,a1,a2
 414:	0685                	addi	a3,a3,1
 416:	fec7f0e3          	bgeu	a5,a2,3f6 <printint+0x2a>
  if(neg)
 41a:	00088b63          	beqz	a7,430 <printint+0x64>
    buf[i++] = '-';
 41e:	fd040793          	addi	a5,s0,-48
 422:	973e                	add	a4,a4,a5
 424:	02d00793          	li	a5,45
 428:	fef70823          	sb	a5,-16(a4)
 42c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 430:	02e05863          	blez	a4,460 <printint+0x94>
 434:	fc040793          	addi	a5,s0,-64
 438:	00e78933          	add	s2,a5,a4
 43c:	fff78993          	addi	s3,a5,-1
 440:	99ba                	add	s3,s3,a4
 442:	377d                	addiw	a4,a4,-1
 444:	1702                	slli	a4,a4,0x20
 446:	9301                	srli	a4,a4,0x20
 448:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 44c:	fff94583          	lbu	a1,-1(s2)
 450:	8526                	mv	a0,s1
 452:	00000097          	auipc	ra,0x0
 456:	f58080e7          	jalr	-168(ra) # 3aa <putc>
  while(--i >= 0)
 45a:	197d                	addi	s2,s2,-1
 45c:	ff3918e3          	bne	s2,s3,44c <printint+0x80>
}
 460:	70e2                	ld	ra,56(sp)
 462:	7442                	ld	s0,48(sp)
 464:	74a2                	ld	s1,40(sp)
 466:	7902                	ld	s2,32(sp)
 468:	69e2                	ld	s3,24(sp)
 46a:	6121                	addi	sp,sp,64
 46c:	8082                	ret
    x = -xx;
 46e:	40b005bb          	negw	a1,a1
    neg = 1;
 472:	4885                	li	a7,1
    x = -xx;
 474:	bf8d                	j	3e6 <printint+0x1a>

0000000000000476 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 476:	7119                	addi	sp,sp,-128
 478:	fc86                	sd	ra,120(sp)
 47a:	f8a2                	sd	s0,112(sp)
 47c:	f4a6                	sd	s1,104(sp)
 47e:	f0ca                	sd	s2,96(sp)
 480:	ecce                	sd	s3,88(sp)
 482:	e8d2                	sd	s4,80(sp)
 484:	e4d6                	sd	s5,72(sp)
 486:	e0da                	sd	s6,64(sp)
 488:	fc5e                	sd	s7,56(sp)
 48a:	f862                	sd	s8,48(sp)
 48c:	f466                	sd	s9,40(sp)
 48e:	f06a                	sd	s10,32(sp)
 490:	ec6e                	sd	s11,24(sp)
 492:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 494:	0005c903          	lbu	s2,0(a1)
 498:	18090f63          	beqz	s2,636 <vprintf+0x1c0>
 49c:	8aaa                	mv	s5,a0
 49e:	8b32                	mv	s6,a2
 4a0:	00158493          	addi	s1,a1,1
  state = 0;
 4a4:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4a6:	02500a13          	li	s4,37
      if(c == 'd'){
 4aa:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 4ae:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 4b2:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 4b6:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4ba:	00000b97          	auipc	s7,0x0
 4be:	6aeb8b93          	addi	s7,s7,1710 # b68 <digits>
 4c2:	a839                	j	4e0 <vprintf+0x6a>
        putc(fd, c);
 4c4:	85ca                	mv	a1,s2
 4c6:	8556                	mv	a0,s5
 4c8:	00000097          	auipc	ra,0x0
 4cc:	ee2080e7          	jalr	-286(ra) # 3aa <putc>
 4d0:	a019                	j	4d6 <vprintf+0x60>
    } else if(state == '%'){
 4d2:	01498f63          	beq	s3,s4,4f0 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4d6:	0485                	addi	s1,s1,1
 4d8:	fff4c903          	lbu	s2,-1(s1)
 4dc:	14090d63          	beqz	s2,636 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 4e0:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4e4:	fe0997e3          	bnez	s3,4d2 <vprintf+0x5c>
      if(c == '%'){
 4e8:	fd479ee3          	bne	a5,s4,4c4 <vprintf+0x4e>
        state = '%';
 4ec:	89be                	mv	s3,a5
 4ee:	b7e5                	j	4d6 <vprintf+0x60>
      if(c == 'd'){
 4f0:	05878063          	beq	a5,s8,530 <vprintf+0xba>
      } else if(c == 'l') {
 4f4:	05978c63          	beq	a5,s9,54c <vprintf+0xd6>
      } else if(c == 'x') {
 4f8:	07a78863          	beq	a5,s10,568 <vprintf+0xf2>
      } else if(c == 'p') {
 4fc:	09b78463          	beq	a5,s11,584 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 500:	07300713          	li	a4,115
 504:	0ce78663          	beq	a5,a4,5d0 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 508:	06300713          	li	a4,99
 50c:	0ee78e63          	beq	a5,a4,608 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 510:	11478863          	beq	a5,s4,620 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 514:	85d2                	mv	a1,s4
 516:	8556                	mv	a0,s5
 518:	00000097          	auipc	ra,0x0
 51c:	e92080e7          	jalr	-366(ra) # 3aa <putc>
        putc(fd, c);
 520:	85ca                	mv	a1,s2
 522:	8556                	mv	a0,s5
 524:	00000097          	auipc	ra,0x0
 528:	e86080e7          	jalr	-378(ra) # 3aa <putc>
      }
      state = 0;
 52c:	4981                	li	s3,0
 52e:	b765                	j	4d6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 530:	008b0913          	addi	s2,s6,8
 534:	4685                	li	a3,1
 536:	4629                	li	a2,10
 538:	000b2583          	lw	a1,0(s6)
 53c:	8556                	mv	a0,s5
 53e:	00000097          	auipc	ra,0x0
 542:	e8e080e7          	jalr	-370(ra) # 3cc <printint>
 546:	8b4a                	mv	s6,s2
      state = 0;
 548:	4981                	li	s3,0
 54a:	b771                	j	4d6 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 54c:	008b0913          	addi	s2,s6,8
 550:	4681                	li	a3,0
 552:	4629                	li	a2,10
 554:	000b2583          	lw	a1,0(s6)
 558:	8556                	mv	a0,s5
 55a:	00000097          	auipc	ra,0x0
 55e:	e72080e7          	jalr	-398(ra) # 3cc <printint>
 562:	8b4a                	mv	s6,s2
      state = 0;
 564:	4981                	li	s3,0
 566:	bf85                	j	4d6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 568:	008b0913          	addi	s2,s6,8
 56c:	4681                	li	a3,0
 56e:	4641                	li	a2,16
 570:	000b2583          	lw	a1,0(s6)
 574:	8556                	mv	a0,s5
 576:	00000097          	auipc	ra,0x0
 57a:	e56080e7          	jalr	-426(ra) # 3cc <printint>
 57e:	8b4a                	mv	s6,s2
      state = 0;
 580:	4981                	li	s3,0
 582:	bf91                	j	4d6 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 584:	008b0793          	addi	a5,s6,8
 588:	f8f43423          	sd	a5,-120(s0)
 58c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 590:	03000593          	li	a1,48
 594:	8556                	mv	a0,s5
 596:	00000097          	auipc	ra,0x0
 59a:	e14080e7          	jalr	-492(ra) # 3aa <putc>
  putc(fd, 'x');
 59e:	85ea                	mv	a1,s10
 5a0:	8556                	mv	a0,s5
 5a2:	00000097          	auipc	ra,0x0
 5a6:	e08080e7          	jalr	-504(ra) # 3aa <putc>
 5aa:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5ac:	03c9d793          	srli	a5,s3,0x3c
 5b0:	97de                	add	a5,a5,s7
 5b2:	0007c583          	lbu	a1,0(a5)
 5b6:	8556                	mv	a0,s5
 5b8:	00000097          	auipc	ra,0x0
 5bc:	df2080e7          	jalr	-526(ra) # 3aa <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5c0:	0992                	slli	s3,s3,0x4
 5c2:	397d                	addiw	s2,s2,-1
 5c4:	fe0914e3          	bnez	s2,5ac <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 5c8:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5cc:	4981                	li	s3,0
 5ce:	b721                	j	4d6 <vprintf+0x60>
        s = va_arg(ap, char*);
 5d0:	008b0993          	addi	s3,s6,8
 5d4:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 5d8:	02090163          	beqz	s2,5fa <vprintf+0x184>
        while(*s != 0){
 5dc:	00094583          	lbu	a1,0(s2)
 5e0:	c9a1                	beqz	a1,630 <vprintf+0x1ba>
          putc(fd, *s);
 5e2:	8556                	mv	a0,s5
 5e4:	00000097          	auipc	ra,0x0
 5e8:	dc6080e7          	jalr	-570(ra) # 3aa <putc>
          s++;
 5ec:	0905                	addi	s2,s2,1
        while(*s != 0){
 5ee:	00094583          	lbu	a1,0(s2)
 5f2:	f9e5                	bnez	a1,5e2 <vprintf+0x16c>
        s = va_arg(ap, char*);
 5f4:	8b4e                	mv	s6,s3
      state = 0;
 5f6:	4981                	li	s3,0
 5f8:	bdf9                	j	4d6 <vprintf+0x60>
          s = "(null)";
 5fa:	00000917          	auipc	s2,0x0
 5fe:	56690913          	addi	s2,s2,1382 # b60 <strstr+0x6a>
        while(*s != 0){
 602:	02800593          	li	a1,40
 606:	bff1                	j	5e2 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 608:	008b0913          	addi	s2,s6,8
 60c:	000b4583          	lbu	a1,0(s6)
 610:	8556                	mv	a0,s5
 612:	00000097          	auipc	ra,0x0
 616:	d98080e7          	jalr	-616(ra) # 3aa <putc>
 61a:	8b4a                	mv	s6,s2
      state = 0;
 61c:	4981                	li	s3,0
 61e:	bd65                	j	4d6 <vprintf+0x60>
        putc(fd, c);
 620:	85d2                	mv	a1,s4
 622:	8556                	mv	a0,s5
 624:	00000097          	auipc	ra,0x0
 628:	d86080e7          	jalr	-634(ra) # 3aa <putc>
      state = 0;
 62c:	4981                	li	s3,0
 62e:	b565                	j	4d6 <vprintf+0x60>
        s = va_arg(ap, char*);
 630:	8b4e                	mv	s6,s3
      state = 0;
 632:	4981                	li	s3,0
 634:	b54d                	j	4d6 <vprintf+0x60>
    }
  }
}
 636:	70e6                	ld	ra,120(sp)
 638:	7446                	ld	s0,112(sp)
 63a:	74a6                	ld	s1,104(sp)
 63c:	7906                	ld	s2,96(sp)
 63e:	69e6                	ld	s3,88(sp)
 640:	6a46                	ld	s4,80(sp)
 642:	6aa6                	ld	s5,72(sp)
 644:	6b06                	ld	s6,64(sp)
 646:	7be2                	ld	s7,56(sp)
 648:	7c42                	ld	s8,48(sp)
 64a:	7ca2                	ld	s9,40(sp)
 64c:	7d02                	ld	s10,32(sp)
 64e:	6de2                	ld	s11,24(sp)
 650:	6109                	addi	sp,sp,128
 652:	8082                	ret

0000000000000654 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 654:	715d                	addi	sp,sp,-80
 656:	ec06                	sd	ra,24(sp)
 658:	e822                	sd	s0,16(sp)
 65a:	1000                	addi	s0,sp,32
 65c:	e010                	sd	a2,0(s0)
 65e:	e414                	sd	a3,8(s0)
 660:	e818                	sd	a4,16(s0)
 662:	ec1c                	sd	a5,24(s0)
 664:	03043023          	sd	a6,32(s0)
 668:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 66c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 670:	8622                	mv	a2,s0
 672:	00000097          	auipc	ra,0x0
 676:	e04080e7          	jalr	-508(ra) # 476 <vprintf>
}
 67a:	60e2                	ld	ra,24(sp)
 67c:	6442                	ld	s0,16(sp)
 67e:	6161                	addi	sp,sp,80
 680:	8082                	ret

0000000000000682 <printf>:

void
printf(const char *fmt, ...)
{
 682:	711d                	addi	sp,sp,-96
 684:	ec06                	sd	ra,24(sp)
 686:	e822                	sd	s0,16(sp)
 688:	1000                	addi	s0,sp,32
 68a:	e40c                	sd	a1,8(s0)
 68c:	e810                	sd	a2,16(s0)
 68e:	ec14                	sd	a3,24(s0)
 690:	f018                	sd	a4,32(s0)
 692:	f41c                	sd	a5,40(s0)
 694:	03043823          	sd	a6,48(s0)
 698:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 69c:	00840613          	addi	a2,s0,8
 6a0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6a4:	85aa                	mv	a1,a0
 6a6:	4505                	li	a0,1
 6a8:	00000097          	auipc	ra,0x0
 6ac:	dce080e7          	jalr	-562(ra) # 476 <vprintf>
}
 6b0:	60e2                	ld	ra,24(sp)
 6b2:	6442                	ld	s0,16(sp)
 6b4:	6125                	addi	sp,sp,96
 6b6:	8082                	ret

00000000000006b8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6b8:	1141                	addi	sp,sp,-16
 6ba:	e422                	sd	s0,8(sp)
 6bc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6be:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c2:	00000797          	auipc	a5,0x0
 6c6:	55e7b783          	ld	a5,1374(a5) # c20 <freep>
 6ca:	a805                	j	6fa <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6cc:	4618                	lw	a4,8(a2)
 6ce:	9db9                	addw	a1,a1,a4
 6d0:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6d4:	6398                	ld	a4,0(a5)
 6d6:	6318                	ld	a4,0(a4)
 6d8:	fee53823          	sd	a4,-16(a0)
 6dc:	a091                	j	720 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6de:	ff852703          	lw	a4,-8(a0)
 6e2:	9e39                	addw	a2,a2,a4
 6e4:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 6e6:	ff053703          	ld	a4,-16(a0)
 6ea:	e398                	sd	a4,0(a5)
 6ec:	a099                	j	732 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ee:	6398                	ld	a4,0(a5)
 6f0:	00e7e463          	bltu	a5,a4,6f8 <free+0x40>
 6f4:	00e6ea63          	bltu	a3,a4,708 <free+0x50>
{
 6f8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6fa:	fed7fae3          	bgeu	a5,a3,6ee <free+0x36>
 6fe:	6398                	ld	a4,0(a5)
 700:	00e6e463          	bltu	a3,a4,708 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 704:	fee7eae3          	bltu	a5,a4,6f8 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 708:	ff852583          	lw	a1,-8(a0)
 70c:	6390                	ld	a2,0(a5)
 70e:	02059713          	slli	a4,a1,0x20
 712:	9301                	srli	a4,a4,0x20
 714:	0712                	slli	a4,a4,0x4
 716:	9736                	add	a4,a4,a3
 718:	fae60ae3          	beq	a2,a4,6cc <free+0x14>
    bp->s.ptr = p->s.ptr;
 71c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 720:	4790                	lw	a2,8(a5)
 722:	02061713          	slli	a4,a2,0x20
 726:	9301                	srli	a4,a4,0x20
 728:	0712                	slli	a4,a4,0x4
 72a:	973e                	add	a4,a4,a5
 72c:	fae689e3          	beq	a3,a4,6de <free+0x26>
  } else
    p->s.ptr = bp;
 730:	e394                	sd	a3,0(a5)
  freep = p;
 732:	00000717          	auipc	a4,0x0
 736:	4ef73723          	sd	a5,1262(a4) # c20 <freep>
}
 73a:	6422                	ld	s0,8(sp)
 73c:	0141                	addi	sp,sp,16
 73e:	8082                	ret

0000000000000740 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 740:	7139                	addi	sp,sp,-64
 742:	fc06                	sd	ra,56(sp)
 744:	f822                	sd	s0,48(sp)
 746:	f426                	sd	s1,40(sp)
 748:	f04a                	sd	s2,32(sp)
 74a:	ec4e                	sd	s3,24(sp)
 74c:	e852                	sd	s4,16(sp)
 74e:	e456                	sd	s5,8(sp)
 750:	e05a                	sd	s6,0(sp)
 752:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 754:	02051493          	slli	s1,a0,0x20
 758:	9081                	srli	s1,s1,0x20
 75a:	04bd                	addi	s1,s1,15
 75c:	8091                	srli	s1,s1,0x4
 75e:	0014899b          	addiw	s3,s1,1
 762:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 764:	00000517          	auipc	a0,0x0
 768:	4bc53503          	ld	a0,1212(a0) # c20 <freep>
 76c:	c515                	beqz	a0,798 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 76e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 770:	4798                	lw	a4,8(a5)
 772:	02977f63          	bgeu	a4,s1,7b0 <malloc+0x70>
 776:	8a4e                	mv	s4,s3
 778:	0009871b          	sext.w	a4,s3
 77c:	6685                	lui	a3,0x1
 77e:	00d77363          	bgeu	a4,a3,784 <malloc+0x44>
 782:	6a05                	lui	s4,0x1
 784:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 788:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 78c:	00000917          	auipc	s2,0x0
 790:	49490913          	addi	s2,s2,1172 # c20 <freep>
  if(p == (char*)-1)
 794:	5afd                	li	s5,-1
 796:	a88d                	j	808 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 798:	00000797          	auipc	a5,0x0
 79c:	49078793          	addi	a5,a5,1168 # c28 <base>
 7a0:	00000717          	auipc	a4,0x0
 7a4:	48f73023          	sd	a5,1152(a4) # c20 <freep>
 7a8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7aa:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7ae:	b7e1                	j	776 <malloc+0x36>
      if(p->s.size == nunits)
 7b0:	02e48b63          	beq	s1,a4,7e6 <malloc+0xa6>
        p->s.size -= nunits;
 7b4:	4137073b          	subw	a4,a4,s3
 7b8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7ba:	1702                	slli	a4,a4,0x20
 7bc:	9301                	srli	a4,a4,0x20
 7be:	0712                	slli	a4,a4,0x4
 7c0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7c2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7c6:	00000717          	auipc	a4,0x0
 7ca:	44a73d23          	sd	a0,1114(a4) # c20 <freep>
      return (void*)(p + 1);
 7ce:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7d2:	70e2                	ld	ra,56(sp)
 7d4:	7442                	ld	s0,48(sp)
 7d6:	74a2                	ld	s1,40(sp)
 7d8:	7902                	ld	s2,32(sp)
 7da:	69e2                	ld	s3,24(sp)
 7dc:	6a42                	ld	s4,16(sp)
 7de:	6aa2                	ld	s5,8(sp)
 7e0:	6b02                	ld	s6,0(sp)
 7e2:	6121                	addi	sp,sp,64
 7e4:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7e6:	6398                	ld	a4,0(a5)
 7e8:	e118                	sd	a4,0(a0)
 7ea:	bff1                	j	7c6 <malloc+0x86>
  hp->s.size = nu;
 7ec:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7f0:	0541                	addi	a0,a0,16
 7f2:	00000097          	auipc	ra,0x0
 7f6:	ec6080e7          	jalr	-314(ra) # 6b8 <free>
  return freep;
 7fa:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7fe:	d971                	beqz	a0,7d2 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 800:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 802:	4798                	lw	a4,8(a5)
 804:	fa9776e3          	bgeu	a4,s1,7b0 <malloc+0x70>
    if(p == freep)
 808:	00093703          	ld	a4,0(s2)
 80c:	853e                	mv	a0,a5
 80e:	fef719e3          	bne	a4,a5,800 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 812:	8552                	mv	a0,s4
 814:	00000097          	auipc	ra,0x0
 818:	b66080e7          	jalr	-1178(ra) # 37a <sbrk>
  if(p == (char*)-1)
 81c:	fd5518e3          	bne	a0,s5,7ec <malloc+0xac>
        return 0;
 820:	4501                	li	a0,0
 822:	bf45                	j	7d2 <malloc+0x92>

0000000000000824 <Pipe>:
#include "kernel/stat.h"
#include "user.h"
#include "wrapper.h"
int strncmp(const char*s, const char*pat,int n);

int Pipe(int *p) {
 824:	1101                	addi	sp,sp,-32
 826:	ec06                	sd	ra,24(sp)
 828:	e822                	sd	s0,16(sp)
 82a:	e426                	sd	s1,8(sp)
 82c:	1000                	addi	s0,sp,32
  i32 res = pipe(p);
 82e:	00000097          	auipc	ra,0x0
 832:	ad4080e7          	jalr	-1324(ra) # 302 <pipe>
 836:	84aa                	mv	s1,a0
  if (res < 0) {
 838:	00054863          	bltz	a0,848 <Pipe+0x24>
    fprintf(2, "pipe creation error");
  }
  return res;
}
 83c:	8526                	mv	a0,s1
 83e:	60e2                	ld	ra,24(sp)
 840:	6442                	ld	s0,16(sp)
 842:	64a2                	ld	s1,8(sp)
 844:	6105                	addi	sp,sp,32
 846:	8082                	ret
    fprintf(2, "pipe creation error");
 848:	00000597          	auipc	a1,0x0
 84c:	33858593          	addi	a1,a1,824 # b80 <digits+0x18>
 850:	4509                	li	a0,2
 852:	00000097          	auipc	ra,0x0
 856:	e02080e7          	jalr	-510(ra) # 654 <fprintf>
 85a:	b7cd                	j	83c <Pipe+0x18>

000000000000085c <Write>:

int Write(int fd, void *buf, int count){
 85c:	1141                	addi	sp,sp,-16
 85e:	e406                	sd	ra,8(sp)
 860:	e022                	sd	s0,0(sp)
 862:	0800                	addi	s0,sp,16
  i32 res = write(fd, buf, count);
 864:	00000097          	auipc	ra,0x0
 868:	aae080e7          	jalr	-1362(ra) # 312 <write>
  if (res < 0) {
 86c:	00054663          	bltz	a0,878 <Write+0x1c>
    fprintf(2, "write error");
    exit(0);
  }
  return res;
}
 870:	60a2                	ld	ra,8(sp)
 872:	6402                	ld	s0,0(sp)
 874:	0141                	addi	sp,sp,16
 876:	8082                	ret
    fprintf(2, "write error");
 878:	00000597          	auipc	a1,0x0
 87c:	32058593          	addi	a1,a1,800 # b98 <digits+0x30>
 880:	4509                	li	a0,2
 882:	00000097          	auipc	ra,0x0
 886:	dd2080e7          	jalr	-558(ra) # 654 <fprintf>
    exit(0);
 88a:	4501                	li	a0,0
 88c:	00000097          	auipc	ra,0x0
 890:	a66080e7          	jalr	-1434(ra) # 2f2 <exit>

0000000000000894 <Read>:



int Read(int fd,  void*buf, int count){
 894:	1141                	addi	sp,sp,-16
 896:	e406                	sd	ra,8(sp)
 898:	e022                	sd	s0,0(sp)
 89a:	0800                	addi	s0,sp,16
  i32 res = read(fd, buf, count);
 89c:	00000097          	auipc	ra,0x0
 8a0:	a6e080e7          	jalr	-1426(ra) # 30a <read>
  if (res < 0) {
 8a4:	00054663          	bltz	a0,8b0 <Read+0x1c>
    fprintf(2, "read error");
    exit(0);
  }
  return res;
}
 8a8:	60a2                	ld	ra,8(sp)
 8aa:	6402                	ld	s0,0(sp)
 8ac:	0141                	addi	sp,sp,16
 8ae:	8082                	ret
    fprintf(2, "read error");
 8b0:	00000597          	auipc	a1,0x0
 8b4:	2f858593          	addi	a1,a1,760 # ba8 <digits+0x40>
 8b8:	4509                	li	a0,2
 8ba:	00000097          	auipc	ra,0x0
 8be:	d9a080e7          	jalr	-614(ra) # 654 <fprintf>
    exit(0);
 8c2:	4501                	li	a0,0
 8c4:	00000097          	auipc	ra,0x0
 8c8:	a2e080e7          	jalr	-1490(ra) # 2f2 <exit>

00000000000008cc <Open>:


int Open(const char* path, int flag){
 8cc:	1141                	addi	sp,sp,-16
 8ce:	e406                	sd	ra,8(sp)
 8d0:	e022                	sd	s0,0(sp)
 8d2:	0800                	addi	s0,sp,16
  i32 res = open(path, flag);
 8d4:	00000097          	auipc	ra,0x0
 8d8:	a5e080e7          	jalr	-1442(ra) # 332 <open>
  if (res < 0) {
 8dc:	00054663          	bltz	a0,8e8 <Open+0x1c>
    fprintf(2, "open error");
    exit(0);
  }
  return res;
}
 8e0:	60a2                	ld	ra,8(sp)
 8e2:	6402                	ld	s0,0(sp)
 8e4:	0141                	addi	sp,sp,16
 8e6:	8082                	ret
    fprintf(2, "open error");
 8e8:	00000597          	auipc	a1,0x0
 8ec:	2d058593          	addi	a1,a1,720 # bb8 <digits+0x50>
 8f0:	4509                	li	a0,2
 8f2:	00000097          	auipc	ra,0x0
 8f6:	d62080e7          	jalr	-670(ra) # 654 <fprintf>
    exit(0);
 8fa:	4501                	li	a0,0
 8fc:	00000097          	auipc	ra,0x0
 900:	9f6080e7          	jalr	-1546(ra) # 2f2 <exit>

0000000000000904 <Fstat>:


int Fstat(int fd, stat_t *st){
 904:	1141                	addi	sp,sp,-16
 906:	e406                	sd	ra,8(sp)
 908:	e022                	sd	s0,0(sp)
 90a:	0800                	addi	s0,sp,16
  i32 res = fstat(fd, st);
 90c:	00000097          	auipc	ra,0x0
 910:	a3e080e7          	jalr	-1474(ra) # 34a <fstat>
  if (res < 0) {
 914:	00054663          	bltz	a0,920 <Fstat+0x1c>
    fprintf(2, "get file stat error");
    exit(0);
  }
  return res;
}
 918:	60a2                	ld	ra,8(sp)
 91a:	6402                	ld	s0,0(sp)
 91c:	0141                	addi	sp,sp,16
 91e:	8082                	ret
    fprintf(2, "get file stat error");
 920:	00000597          	auipc	a1,0x0
 924:	2a858593          	addi	a1,a1,680 # bc8 <digits+0x60>
 928:	4509                	li	a0,2
 92a:	00000097          	auipc	ra,0x0
 92e:	d2a080e7          	jalr	-726(ra) # 654 <fprintf>
    exit(0);
 932:	4501                	li	a0,0
 934:	00000097          	auipc	ra,0x0
 938:	9be080e7          	jalr	-1602(ra) # 2f2 <exit>

000000000000093c <Dup>:



int Dup(int fd){
 93c:	1141                	addi	sp,sp,-16
 93e:	e406                	sd	ra,8(sp)
 940:	e022                	sd	s0,0(sp)
 942:	0800                	addi	s0,sp,16
  i32 res = dup(fd);
 944:	00000097          	auipc	ra,0x0
 948:	a26080e7          	jalr	-1498(ra) # 36a <dup>
  if (res < 0) {
 94c:	00054663          	bltz	a0,958 <Dup+0x1c>
    fprintf(2, "dup error");
    exit(0);
  }
  return res;

}
 950:	60a2                	ld	ra,8(sp)
 952:	6402                	ld	s0,0(sp)
 954:	0141                	addi	sp,sp,16
 956:	8082                	ret
    fprintf(2, "dup error");
 958:	00000597          	auipc	a1,0x0
 95c:	28858593          	addi	a1,a1,648 # be0 <digits+0x78>
 960:	4509                	li	a0,2
 962:	00000097          	auipc	ra,0x0
 966:	cf2080e7          	jalr	-782(ra) # 654 <fprintf>
    exit(0);
 96a:	4501                	li	a0,0
 96c:	00000097          	auipc	ra,0x0
 970:	986080e7          	jalr	-1658(ra) # 2f2 <exit>

0000000000000974 <Close>:

int Close(int fd){
 974:	1141                	addi	sp,sp,-16
 976:	e406                	sd	ra,8(sp)
 978:	e022                	sd	s0,0(sp)
 97a:	0800                	addi	s0,sp,16
  i32 res = close(fd);
 97c:	00000097          	auipc	ra,0x0
 980:	99e080e7          	jalr	-1634(ra) # 31a <close>
  if (res < 0) {
 984:	00054663          	bltz	a0,990 <Close+0x1c>
    fprintf(2, "file close error~");
    exit(0);
  }
  return res;
}
 988:	60a2                	ld	ra,8(sp)
 98a:	6402                	ld	s0,0(sp)
 98c:	0141                	addi	sp,sp,16
 98e:	8082                	ret
    fprintf(2, "file close error~");
 990:	00000597          	auipc	a1,0x0
 994:	26058593          	addi	a1,a1,608 # bf0 <digits+0x88>
 998:	4509                	li	a0,2
 99a:	00000097          	auipc	ra,0x0
 99e:	cba080e7          	jalr	-838(ra) # 654 <fprintf>
    exit(0);
 9a2:	4501                	li	a0,0
 9a4:	00000097          	auipc	ra,0x0
 9a8:	94e080e7          	jalr	-1714(ra) # 2f2 <exit>

00000000000009ac <Dup2>:

int Dup2(int old_fd,int new_fd){
 9ac:	1101                	addi	sp,sp,-32
 9ae:	ec06                	sd	ra,24(sp)
 9b0:	e822                	sd	s0,16(sp)
 9b2:	e426                	sd	s1,8(sp)
 9b4:	1000                	addi	s0,sp,32
 9b6:	84aa                	mv	s1,a0
  Close(new_fd);
 9b8:	852e                	mv	a0,a1
 9ba:	00000097          	auipc	ra,0x0
 9be:	fba080e7          	jalr	-70(ra) # 974 <Close>
  i32 res = Dup(old_fd);
 9c2:	8526                	mv	a0,s1
 9c4:	00000097          	auipc	ra,0x0
 9c8:	f78080e7          	jalr	-136(ra) # 93c <Dup>
  if (res < 0) {
 9cc:	00054763          	bltz	a0,9da <Dup2+0x2e>
    fprintf(2, "dup error");
    exit(0);
  }
  return res;
}
 9d0:	60e2                	ld	ra,24(sp)
 9d2:	6442                	ld	s0,16(sp)
 9d4:	64a2                	ld	s1,8(sp)
 9d6:	6105                	addi	sp,sp,32
 9d8:	8082                	ret
    fprintf(2, "dup error");
 9da:	00000597          	auipc	a1,0x0
 9de:	20658593          	addi	a1,a1,518 # be0 <digits+0x78>
 9e2:	4509                	li	a0,2
 9e4:	00000097          	auipc	ra,0x0
 9e8:	c70080e7          	jalr	-912(ra) # 654 <fprintf>
    exit(0);
 9ec:	4501                	li	a0,0
 9ee:	00000097          	auipc	ra,0x0
 9f2:	904080e7          	jalr	-1788(ra) # 2f2 <exit>

00000000000009f6 <Stat>:

int Stat(const char*link,stat_t *st){
 9f6:	1101                	addi	sp,sp,-32
 9f8:	ec06                	sd	ra,24(sp)
 9fa:	e822                	sd	s0,16(sp)
 9fc:	e426                	sd	s1,8(sp)
 9fe:	1000                	addi	s0,sp,32
 a00:	84aa                	mv	s1,a0
  i32 res = stat(link,st);
 a02:	fffff097          	auipc	ra,0xfffff
 a06:	7ae080e7          	jalr	1966(ra) # 1b0 <stat>
  if (res < 0) {
 a0a:	00054763          	bltz	a0,a18 <Stat+0x22>
    fprintf(2, "file %s stat error",link);
    exit(0);
  }
  return res;
}
 a0e:	60e2                	ld	ra,24(sp)
 a10:	6442                	ld	s0,16(sp)
 a12:	64a2                	ld	s1,8(sp)
 a14:	6105                	addi	sp,sp,32
 a16:	8082                	ret
    fprintf(2, "file %s stat error",link);
 a18:	8626                	mv	a2,s1
 a1a:	00000597          	auipc	a1,0x0
 a1e:	1ee58593          	addi	a1,a1,494 # c08 <digits+0xa0>
 a22:	4509                	li	a0,2
 a24:	00000097          	auipc	ra,0x0
 a28:	c30080e7          	jalr	-976(ra) # 654 <fprintf>
    exit(0);
 a2c:	4501                	li	a0,0
 a2e:	00000097          	auipc	ra,0x0
 a32:	8c4080e7          	jalr	-1852(ra) # 2f2 <exit>

0000000000000a36 <strncmp>:
   return -1;
}



int strncmp(const char*s, const char*pat,int n){
 a36:	bc010113          	addi	sp,sp,-1088
 a3a:	42113c23          	sd	ra,1080(sp)
 a3e:	42813823          	sd	s0,1072(sp)
 a42:	42913423          	sd	s1,1064(sp)
 a46:	43213023          	sd	s2,1056(sp)
 a4a:	41313c23          	sd	s3,1048(sp)
 a4e:	41413823          	sd	s4,1040(sp)
 a52:	41513423          	sd	s5,1032(sp)
 a56:	44010413          	addi	s0,sp,1088
 a5a:	89aa                	mv	s3,a0
 a5c:	892e                	mv	s2,a1
 a5e:	84b2                	mv	s1,a2
  char buf1[512],buf2[512];
  int n1 = MIN(n,strlen(s));
 a60:	fffff097          	auipc	ra,0xfffff
 a64:	66c080e7          	jalr	1644(ra) # cc <strlen>
 a68:	2501                	sext.w	a0,a0
 a6a:	00048a1b          	sext.w	s4,s1
 a6e:	8aa6                	mv	s5,s1
 a70:	06aa7363          	bgeu	s4,a0,ad6 <strncmp+0xa0>
  int n2 = MIN(n,strlen(pat));
 a74:	854a                	mv	a0,s2
 a76:	fffff097          	auipc	ra,0xfffff
 a7a:	656080e7          	jalr	1622(ra) # cc <strlen>
 a7e:	2501                	sext.w	a0,a0
 a80:	06aa7363          	bgeu	s4,a0,ae6 <strncmp+0xb0>
  memmove(buf1,s,n1);
 a84:	8656                	mv	a2,s5
 a86:	85ce                	mv	a1,s3
 a88:	dc040513          	addi	a0,s0,-576
 a8c:	fffff097          	auipc	ra,0xfffff
 a90:	7b4080e7          	jalr	1972(ra) # 240 <memmove>
  memmove(buf2,pat,n2);
 a94:	8626                	mv	a2,s1
 a96:	85ca                	mv	a1,s2
 a98:	bc040513          	addi	a0,s0,-1088
 a9c:	fffff097          	auipc	ra,0xfffff
 aa0:	7a4080e7          	jalr	1956(ra) # 240 <memmove>
  return strcmp(buf1,buf2);
 aa4:	bc040593          	addi	a1,s0,-1088
 aa8:	dc040513          	addi	a0,s0,-576
 aac:	fffff097          	auipc	ra,0xfffff
 ab0:	5f4080e7          	jalr	1524(ra) # a0 <strcmp>
}
 ab4:	43813083          	ld	ra,1080(sp)
 ab8:	43013403          	ld	s0,1072(sp)
 abc:	42813483          	ld	s1,1064(sp)
 ac0:	42013903          	ld	s2,1056(sp)
 ac4:	41813983          	ld	s3,1048(sp)
 ac8:	41013a03          	ld	s4,1040(sp)
 acc:	40813a83          	ld	s5,1032(sp)
 ad0:	44010113          	addi	sp,sp,1088
 ad4:	8082                	ret
  int n1 = MIN(n,strlen(s));
 ad6:	854e                	mv	a0,s3
 ad8:	fffff097          	auipc	ra,0xfffff
 adc:	5f4080e7          	jalr	1524(ra) # cc <strlen>
 ae0:	00050a9b          	sext.w	s5,a0
 ae4:	bf41                	j	a74 <strncmp+0x3e>
  int n2 = MIN(n,strlen(pat));
 ae6:	854a                	mv	a0,s2
 ae8:	fffff097          	auipc	ra,0xfffff
 aec:	5e4080e7          	jalr	1508(ra) # cc <strlen>
 af0:	0005049b          	sext.w	s1,a0
 af4:	bf41                	j	a84 <strncmp+0x4e>

0000000000000af6 <strstr>:
   while (*s != 0){
 af6:	00054783          	lbu	a5,0(a0)
 afa:	cba1                	beqz	a5,b4a <strstr+0x54>
int strstr(char *s,char *p){
 afc:	7179                	addi	sp,sp,-48
 afe:	f406                	sd	ra,40(sp)
 b00:	f022                	sd	s0,32(sp)
 b02:	ec26                	sd	s1,24(sp)
 b04:	e84a                	sd	s2,16(sp)
 b06:	e44e                	sd	s3,8(sp)
 b08:	1800                	addi	s0,sp,48
 b0a:	89aa                	mv	s3,a0
 b0c:	892e                	mv	s2,a1
   while (*s != 0){
 b0e:	84aa                	mv	s1,a0
     if (!strncmp(s,p,strlen(p)))
 b10:	854a                	mv	a0,s2
 b12:	fffff097          	auipc	ra,0xfffff
 b16:	5ba080e7          	jalr	1466(ra) # cc <strlen>
 b1a:	0005061b          	sext.w	a2,a0
 b1e:	85ca                	mv	a1,s2
 b20:	8526                	mv	a0,s1
 b22:	00000097          	auipc	ra,0x0
 b26:	f14080e7          	jalr	-236(ra) # a36 <strncmp>
 b2a:	c519                	beqz	a0,b38 <strstr+0x42>
     s++;
 b2c:	0485                	addi	s1,s1,1
   while (*s != 0){
 b2e:	0004c783          	lbu	a5,0(s1)
 b32:	fff9                	bnez	a5,b10 <strstr+0x1a>
   return -1;
 b34:	557d                	li	a0,-1
 b36:	a019                	j	b3c <strstr+0x46>
      return s - ori;
 b38:	4134853b          	subw	a0,s1,s3
}
 b3c:	70a2                	ld	ra,40(sp)
 b3e:	7402                	ld	s0,32(sp)
 b40:	64e2                	ld	s1,24(sp)
 b42:	6942                	ld	s2,16(sp)
 b44:	69a2                	ld	s3,8(sp)
 b46:	6145                	addi	sp,sp,48
 b48:	8082                	ret
   return -1;
 b4a:	557d                	li	a0,-1
}
 b4c:	8082                	ret
