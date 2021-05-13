
user/_wrapper:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <Pipe>:
#include "kernel/stat.h"
#include "user.h"
#include "wrapper.h"
int strncmp(const char*s, const char*pat,int n);

int Pipe(int *p) {
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
  i32 res = pipe(p);
   a:	00000097          	auipc	ra,0x0
   e:	59e080e7          	jalr	1438(ra) # 5a8 <pipe>
  12:	84aa                	mv	s1,a0
  if (res < 0) {
  14:	00054863          	bltz	a0,24 <Pipe+0x24>
    fprintf(2, "pipe creation error");
  }
  return res;
}
  18:	8526                	mv	a0,s1
  1a:	60e2                	ld	ra,24(sp)
  1c:	6442                	ld	s0,16(sp)
  1e:	64a2                	ld	s1,8(sp)
  20:	6105                	addi	sp,sp,32
  22:	8082                	ret
    fprintf(2, "pipe creation error");
  24:	00001597          	auipc	a1,0x1
  28:	aac58593          	addi	a1,a1,-1364 # ad0 <malloc+0xea>
  2c:	4509                	li	a0,2
  2e:	00001097          	auipc	ra,0x1
  32:	8cc080e7          	jalr	-1844(ra) # 8fa <fprintf>
  36:	b7cd                	j	18 <Pipe+0x18>

0000000000000038 <Write>:

int Write(int fd, void *buf, int count){
  38:	1141                	addi	sp,sp,-16
  3a:	e406                	sd	ra,8(sp)
  3c:	e022                	sd	s0,0(sp)
  3e:	0800                	addi	s0,sp,16
  i32 res = write(fd, buf, count);
  40:	00000097          	auipc	ra,0x0
  44:	578080e7          	jalr	1400(ra) # 5b8 <write>
  if (res < 0) {
  48:	00054663          	bltz	a0,54 <Write+0x1c>
    fprintf(2, "write error");
    exit(0);
  }
  return res;
}
  4c:	60a2                	ld	ra,8(sp)
  4e:	6402                	ld	s0,0(sp)
  50:	0141                	addi	sp,sp,16
  52:	8082                	ret
    fprintf(2, "write error");
  54:	00001597          	auipc	a1,0x1
  58:	a9458593          	addi	a1,a1,-1388 # ae8 <malloc+0x102>
  5c:	4509                	li	a0,2
  5e:	00001097          	auipc	ra,0x1
  62:	89c080e7          	jalr	-1892(ra) # 8fa <fprintf>
    exit(0);
  66:	4501                	li	a0,0
  68:	00000097          	auipc	ra,0x0
  6c:	530080e7          	jalr	1328(ra) # 598 <exit>

0000000000000070 <Read>:



int Read(int fd,  void*buf, int count){
  70:	1141                	addi	sp,sp,-16
  72:	e406                	sd	ra,8(sp)
  74:	e022                	sd	s0,0(sp)
  76:	0800                	addi	s0,sp,16
  i32 res = read(fd, buf, count);
  78:	00000097          	auipc	ra,0x0
  7c:	538080e7          	jalr	1336(ra) # 5b0 <read>
  if (res < 0) {
  80:	00054663          	bltz	a0,8c <Read+0x1c>
    fprintf(2, "read error");
    exit(0);
  }
  return res;
}
  84:	60a2                	ld	ra,8(sp)
  86:	6402                	ld	s0,0(sp)
  88:	0141                	addi	sp,sp,16
  8a:	8082                	ret
    fprintf(2, "read error");
  8c:	00001597          	auipc	a1,0x1
  90:	a6c58593          	addi	a1,a1,-1428 # af8 <malloc+0x112>
  94:	4509                	li	a0,2
  96:	00001097          	auipc	ra,0x1
  9a:	864080e7          	jalr	-1948(ra) # 8fa <fprintf>
    exit(0);
  9e:	4501                	li	a0,0
  a0:	00000097          	auipc	ra,0x0
  a4:	4f8080e7          	jalr	1272(ra) # 598 <exit>

00000000000000a8 <Open>:


int Open(const char* path, int flag){
  a8:	1141                	addi	sp,sp,-16
  aa:	e406                	sd	ra,8(sp)
  ac:	e022                	sd	s0,0(sp)
  ae:	0800                	addi	s0,sp,16
  i32 res = open(path, flag);
  b0:	00000097          	auipc	ra,0x0
  b4:	528080e7          	jalr	1320(ra) # 5d8 <open>
  if (res < 0) {
  b8:	00054663          	bltz	a0,c4 <Open+0x1c>
    fprintf(2, "open error");
    exit(0);
  }
  return res;
}
  bc:	60a2                	ld	ra,8(sp)
  be:	6402                	ld	s0,0(sp)
  c0:	0141                	addi	sp,sp,16
  c2:	8082                	ret
    fprintf(2, "open error");
  c4:	00001597          	auipc	a1,0x1
  c8:	a4458593          	addi	a1,a1,-1468 # b08 <malloc+0x122>
  cc:	4509                	li	a0,2
  ce:	00001097          	auipc	ra,0x1
  d2:	82c080e7          	jalr	-2004(ra) # 8fa <fprintf>
    exit(0);
  d6:	4501                	li	a0,0
  d8:	00000097          	auipc	ra,0x0
  dc:	4c0080e7          	jalr	1216(ra) # 598 <exit>

00000000000000e0 <Fstat>:


int Fstat(int fd, stat_t *st){
  e0:	1141                	addi	sp,sp,-16
  e2:	e406                	sd	ra,8(sp)
  e4:	e022                	sd	s0,0(sp)
  e6:	0800                	addi	s0,sp,16
  i32 res = fstat(fd, st);
  e8:	00000097          	auipc	ra,0x0
  ec:	508080e7          	jalr	1288(ra) # 5f0 <fstat>
  if (res < 0) {
  f0:	00054663          	bltz	a0,fc <Fstat+0x1c>
    fprintf(2, "get file stat error");
    exit(0);
  }
  return res;
}
  f4:	60a2                	ld	ra,8(sp)
  f6:	6402                	ld	s0,0(sp)
  f8:	0141                	addi	sp,sp,16
  fa:	8082                	ret
    fprintf(2, "get file stat error");
  fc:	00001597          	auipc	a1,0x1
 100:	a1c58593          	addi	a1,a1,-1508 # b18 <malloc+0x132>
 104:	4509                	li	a0,2
 106:	00000097          	auipc	ra,0x0
 10a:	7f4080e7          	jalr	2036(ra) # 8fa <fprintf>
    exit(0);
 10e:	4501                	li	a0,0
 110:	00000097          	auipc	ra,0x0
 114:	488080e7          	jalr	1160(ra) # 598 <exit>

0000000000000118 <Dup>:



int Dup(int fd){
 118:	1141                	addi	sp,sp,-16
 11a:	e406                	sd	ra,8(sp)
 11c:	e022                	sd	s0,0(sp)
 11e:	0800                	addi	s0,sp,16
  i32 res = dup(fd);
 120:	00000097          	auipc	ra,0x0
 124:	4f0080e7          	jalr	1264(ra) # 610 <dup>
  if (res < 0) {
 128:	00054663          	bltz	a0,134 <Dup+0x1c>
    fprintf(2, "dup error");
    exit(0);
  }
  return res;

}
 12c:	60a2                	ld	ra,8(sp)
 12e:	6402                	ld	s0,0(sp)
 130:	0141                	addi	sp,sp,16
 132:	8082                	ret
    fprintf(2, "dup error");
 134:	00001597          	auipc	a1,0x1
 138:	9fc58593          	addi	a1,a1,-1540 # b30 <malloc+0x14a>
 13c:	4509                	li	a0,2
 13e:	00000097          	auipc	ra,0x0
 142:	7bc080e7          	jalr	1980(ra) # 8fa <fprintf>
    exit(0);
 146:	4501                	li	a0,0
 148:	00000097          	auipc	ra,0x0
 14c:	450080e7          	jalr	1104(ra) # 598 <exit>

0000000000000150 <Close>:

int Close(int fd){
 150:	1141                	addi	sp,sp,-16
 152:	e406                	sd	ra,8(sp)
 154:	e022                	sd	s0,0(sp)
 156:	0800                	addi	s0,sp,16
  i32 res = close(fd);
 158:	00000097          	auipc	ra,0x0
 15c:	468080e7          	jalr	1128(ra) # 5c0 <close>
  if (res < 0) {
 160:	00054663          	bltz	a0,16c <Close+0x1c>
    fprintf(2, "file close error~");
    exit(0);
  }
  return res;
}
 164:	60a2                	ld	ra,8(sp)
 166:	6402                	ld	s0,0(sp)
 168:	0141                	addi	sp,sp,16
 16a:	8082                	ret
    fprintf(2, "file close error~");
 16c:	00001597          	auipc	a1,0x1
 170:	9d458593          	addi	a1,a1,-1580 # b40 <malloc+0x15a>
 174:	4509                	li	a0,2
 176:	00000097          	auipc	ra,0x0
 17a:	784080e7          	jalr	1924(ra) # 8fa <fprintf>
    exit(0);
 17e:	4501                	li	a0,0
 180:	00000097          	auipc	ra,0x0
 184:	418080e7          	jalr	1048(ra) # 598 <exit>

0000000000000188 <Dup2>:

int Dup2(int old_fd,int new_fd){
 188:	1101                	addi	sp,sp,-32
 18a:	ec06                	sd	ra,24(sp)
 18c:	e822                	sd	s0,16(sp)
 18e:	e426                	sd	s1,8(sp)
 190:	1000                	addi	s0,sp,32
 192:	84aa                	mv	s1,a0
  Close(new_fd);
 194:	852e                	mv	a0,a1
 196:	00000097          	auipc	ra,0x0
 19a:	fba080e7          	jalr	-70(ra) # 150 <Close>
  i32 res = Dup(old_fd);
 19e:	8526                	mv	a0,s1
 1a0:	00000097          	auipc	ra,0x0
 1a4:	f78080e7          	jalr	-136(ra) # 118 <Dup>
  if (res < 0) {
 1a8:	00054763          	bltz	a0,1b6 <Dup2+0x2e>
    fprintf(2, "dup error");
    exit(0);
  }
  return res;
}
 1ac:	60e2                	ld	ra,24(sp)
 1ae:	6442                	ld	s0,16(sp)
 1b0:	64a2                	ld	s1,8(sp)
 1b2:	6105                	addi	sp,sp,32
 1b4:	8082                	ret
    fprintf(2, "dup error");
 1b6:	00001597          	auipc	a1,0x1
 1ba:	97a58593          	addi	a1,a1,-1670 # b30 <malloc+0x14a>
 1be:	4509                	li	a0,2
 1c0:	00000097          	auipc	ra,0x0
 1c4:	73a080e7          	jalr	1850(ra) # 8fa <fprintf>
    exit(0);
 1c8:	4501                	li	a0,0
 1ca:	00000097          	auipc	ra,0x0
 1ce:	3ce080e7          	jalr	974(ra) # 598 <exit>

00000000000001d2 <Stat>:

int Stat(const char*link,stat_t *st){
 1d2:	1101                	addi	sp,sp,-32
 1d4:	ec06                	sd	ra,24(sp)
 1d6:	e822                	sd	s0,16(sp)
 1d8:	e426                	sd	s1,8(sp)
 1da:	1000                	addi	s0,sp,32
 1dc:	84aa                	mv	s1,a0
  i32 res = stat(link,st);
 1de:	00000097          	auipc	ra,0x0
 1e2:	278080e7          	jalr	632(ra) # 456 <stat>
  if (res < 0) {
 1e6:	00054763          	bltz	a0,1f4 <Stat+0x22>
    fprintf(2, "file %s stat error",link);
    exit(0);
  }
  return res;
}
 1ea:	60e2                	ld	ra,24(sp)
 1ec:	6442                	ld	s0,16(sp)
 1ee:	64a2                	ld	s1,8(sp)
 1f0:	6105                	addi	sp,sp,32
 1f2:	8082                	ret
    fprintf(2, "file %s stat error",link);
 1f4:	8626                	mv	a2,s1
 1f6:	00001597          	auipc	a1,0x1
 1fa:	96258593          	addi	a1,a1,-1694 # b58 <malloc+0x172>
 1fe:	4509                	li	a0,2
 200:	00000097          	auipc	ra,0x0
 204:	6fa080e7          	jalr	1786(ra) # 8fa <fprintf>
    exit(0);
 208:	4501                	li	a0,0
 20a:	00000097          	auipc	ra,0x0
 20e:	38e080e7          	jalr	910(ra) # 598 <exit>

0000000000000212 <strncmp>:
   return -1;
}



int strncmp(const char*s, const char*pat,int n){
 212:	bc010113          	addi	sp,sp,-1088
 216:	42113c23          	sd	ra,1080(sp)
 21a:	42813823          	sd	s0,1072(sp)
 21e:	42913423          	sd	s1,1064(sp)
 222:	43213023          	sd	s2,1056(sp)
 226:	41313c23          	sd	s3,1048(sp)
 22a:	41413823          	sd	s4,1040(sp)
 22e:	41513423          	sd	s5,1032(sp)
 232:	44010413          	addi	s0,sp,1088
 236:	89aa                	mv	s3,a0
 238:	892e                	mv	s2,a1
 23a:	84b2                	mv	s1,a2
  char buf1[512],buf2[512];
  int n1 = MIN(n,strlen(s));
 23c:	00000097          	auipc	ra,0x0
 240:	136080e7          	jalr	310(ra) # 372 <strlen>
 244:	2501                	sext.w	a0,a0
 246:	00048a1b          	sext.w	s4,s1
 24a:	8aa6                	mv	s5,s1
 24c:	06aa7363          	bgeu	s4,a0,2b2 <strncmp+0xa0>
  int n2 = MIN(n,strlen(pat));
 250:	854a                	mv	a0,s2
 252:	00000097          	auipc	ra,0x0
 256:	120080e7          	jalr	288(ra) # 372 <strlen>
 25a:	2501                	sext.w	a0,a0
 25c:	06aa7363          	bgeu	s4,a0,2c2 <strncmp+0xb0>
  memmove(buf1,s,n1);
 260:	8656                	mv	a2,s5
 262:	85ce                	mv	a1,s3
 264:	dc040513          	addi	a0,s0,-576
 268:	00000097          	auipc	ra,0x0
 26c:	27e080e7          	jalr	638(ra) # 4e6 <memmove>
  memmove(buf2,pat,n2);
 270:	8626                	mv	a2,s1
 272:	85ca                	mv	a1,s2
 274:	bc040513          	addi	a0,s0,-1088
 278:	00000097          	auipc	ra,0x0
 27c:	26e080e7          	jalr	622(ra) # 4e6 <memmove>
  return strcmp(buf1,buf2);
 280:	bc040593          	addi	a1,s0,-1088
 284:	dc040513          	addi	a0,s0,-576
 288:	00000097          	auipc	ra,0x0
 28c:	0be080e7          	jalr	190(ra) # 346 <strcmp>
}
 290:	43813083          	ld	ra,1080(sp)
 294:	43013403          	ld	s0,1072(sp)
 298:	42813483          	ld	s1,1064(sp)
 29c:	42013903          	ld	s2,1056(sp)
 2a0:	41813983          	ld	s3,1048(sp)
 2a4:	41013a03          	ld	s4,1040(sp)
 2a8:	40813a83          	ld	s5,1032(sp)
 2ac:	44010113          	addi	sp,sp,1088
 2b0:	8082                	ret
  int n1 = MIN(n,strlen(s));
 2b2:	854e                	mv	a0,s3
 2b4:	00000097          	auipc	ra,0x0
 2b8:	0be080e7          	jalr	190(ra) # 372 <strlen>
 2bc:	00050a9b          	sext.w	s5,a0
 2c0:	bf41                	j	250 <strncmp+0x3e>
  int n2 = MIN(n,strlen(pat));
 2c2:	854a                	mv	a0,s2
 2c4:	00000097          	auipc	ra,0x0
 2c8:	0ae080e7          	jalr	174(ra) # 372 <strlen>
 2cc:	0005049b          	sext.w	s1,a0
 2d0:	bf41                	j	260 <strncmp+0x4e>

00000000000002d2 <strstr>:
   while (*s != 0){
 2d2:	00054783          	lbu	a5,0(a0)
 2d6:	cba1                	beqz	a5,326 <strstr+0x54>
int strstr(char *s,char *p){
 2d8:	7179                	addi	sp,sp,-48
 2da:	f406                	sd	ra,40(sp)
 2dc:	f022                	sd	s0,32(sp)
 2de:	ec26                	sd	s1,24(sp)
 2e0:	e84a                	sd	s2,16(sp)
 2e2:	e44e                	sd	s3,8(sp)
 2e4:	1800                	addi	s0,sp,48
 2e6:	89aa                	mv	s3,a0
 2e8:	892e                	mv	s2,a1
   while (*s != 0){
 2ea:	84aa                	mv	s1,a0
     if (!strncmp(s,p,strlen(p)))
 2ec:	854a                	mv	a0,s2
 2ee:	00000097          	auipc	ra,0x0
 2f2:	084080e7          	jalr	132(ra) # 372 <strlen>
 2f6:	0005061b          	sext.w	a2,a0
 2fa:	85ca                	mv	a1,s2
 2fc:	8526                	mv	a0,s1
 2fe:	00000097          	auipc	ra,0x0
 302:	f14080e7          	jalr	-236(ra) # 212 <strncmp>
 306:	c519                	beqz	a0,314 <strstr+0x42>
     s++;
 308:	0485                	addi	s1,s1,1
   while (*s != 0){
 30a:	0004c783          	lbu	a5,0(s1)
 30e:	fff9                	bnez	a5,2ec <strstr+0x1a>
   return -1;
 310:	557d                	li	a0,-1
 312:	a019                	j	318 <strstr+0x46>
      return s - ori;
 314:	4134853b          	subw	a0,s1,s3
}
 318:	70a2                	ld	ra,40(sp)
 31a:	7402                	ld	s0,32(sp)
 31c:	64e2                	ld	s1,24(sp)
 31e:	6942                	ld	s2,16(sp)
 320:	69a2                	ld	s3,8(sp)
 322:	6145                	addi	sp,sp,48
 324:	8082                	ret
   return -1;
 326:	557d                	li	a0,-1
}
 328:	8082                	ret

000000000000032a <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 32a:	1141                	addi	sp,sp,-16
 32c:	e422                	sd	s0,8(sp)
 32e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 330:	87aa                	mv	a5,a0
 332:	0585                	addi	a1,a1,1
 334:	0785                	addi	a5,a5,1
 336:	fff5c703          	lbu	a4,-1(a1)
 33a:	fee78fa3          	sb	a4,-1(a5)
 33e:	fb75                	bnez	a4,332 <strcpy+0x8>
    ;
  return os;
}
 340:	6422                	ld	s0,8(sp)
 342:	0141                	addi	sp,sp,16
 344:	8082                	ret

0000000000000346 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 346:	1141                	addi	sp,sp,-16
 348:	e422                	sd	s0,8(sp)
 34a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 34c:	00054783          	lbu	a5,0(a0)
 350:	cb91                	beqz	a5,364 <strcmp+0x1e>
 352:	0005c703          	lbu	a4,0(a1)
 356:	00f71763          	bne	a4,a5,364 <strcmp+0x1e>
    p++, q++;
 35a:	0505                	addi	a0,a0,1
 35c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 35e:	00054783          	lbu	a5,0(a0)
 362:	fbe5                	bnez	a5,352 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 364:	0005c503          	lbu	a0,0(a1)
}
 368:	40a7853b          	subw	a0,a5,a0
 36c:	6422                	ld	s0,8(sp)
 36e:	0141                	addi	sp,sp,16
 370:	8082                	ret

0000000000000372 <strlen>:

uint
strlen(const char *s)
{
 372:	1141                	addi	sp,sp,-16
 374:	e422                	sd	s0,8(sp)
 376:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 378:	00054783          	lbu	a5,0(a0)
 37c:	cf91                	beqz	a5,398 <strlen+0x26>
 37e:	0505                	addi	a0,a0,1
 380:	87aa                	mv	a5,a0
 382:	4685                	li	a3,1
 384:	9e89                	subw	a3,a3,a0
 386:	00f6853b          	addw	a0,a3,a5
 38a:	0785                	addi	a5,a5,1
 38c:	fff7c703          	lbu	a4,-1(a5)
 390:	fb7d                	bnez	a4,386 <strlen+0x14>
    ;
  return n;
}
 392:	6422                	ld	s0,8(sp)
 394:	0141                	addi	sp,sp,16
 396:	8082                	ret
  for(n = 0; s[n]; n++)
 398:	4501                	li	a0,0
 39a:	bfe5                	j	392 <strlen+0x20>

000000000000039c <memset>:

void*
memset(void *dst, int c, uint n)
{
 39c:	1141                	addi	sp,sp,-16
 39e:	e422                	sd	s0,8(sp)
 3a0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 3a2:	ca19                	beqz	a2,3b8 <memset+0x1c>
 3a4:	87aa                	mv	a5,a0
 3a6:	1602                	slli	a2,a2,0x20
 3a8:	9201                	srli	a2,a2,0x20
 3aa:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 3ae:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 3b2:	0785                	addi	a5,a5,1
 3b4:	fee79de3          	bne	a5,a4,3ae <memset+0x12>
  }
  return dst;
}
 3b8:	6422                	ld	s0,8(sp)
 3ba:	0141                	addi	sp,sp,16
 3bc:	8082                	ret

00000000000003be <strchr>:

char*
strchr(const char *s, char c)
{
 3be:	1141                	addi	sp,sp,-16
 3c0:	e422                	sd	s0,8(sp)
 3c2:	0800                	addi	s0,sp,16
  for(; *s; s++)
 3c4:	00054783          	lbu	a5,0(a0)
 3c8:	cb99                	beqz	a5,3de <strchr+0x20>
    if(*s == c)
 3ca:	00f58763          	beq	a1,a5,3d8 <strchr+0x1a>
  for(; *s; s++)
 3ce:	0505                	addi	a0,a0,1
 3d0:	00054783          	lbu	a5,0(a0)
 3d4:	fbfd                	bnez	a5,3ca <strchr+0xc>
      return (char*)s;
  return 0;
 3d6:	4501                	li	a0,0
}
 3d8:	6422                	ld	s0,8(sp)
 3da:	0141                	addi	sp,sp,16
 3dc:	8082                	ret
  return 0;
 3de:	4501                	li	a0,0
 3e0:	bfe5                	j	3d8 <strchr+0x1a>

00000000000003e2 <gets>:

char*
gets(char *buf, int max)
{
 3e2:	711d                	addi	sp,sp,-96
 3e4:	ec86                	sd	ra,88(sp)
 3e6:	e8a2                	sd	s0,80(sp)
 3e8:	e4a6                	sd	s1,72(sp)
 3ea:	e0ca                	sd	s2,64(sp)
 3ec:	fc4e                	sd	s3,56(sp)
 3ee:	f852                	sd	s4,48(sp)
 3f0:	f456                	sd	s5,40(sp)
 3f2:	f05a                	sd	s6,32(sp)
 3f4:	ec5e                	sd	s7,24(sp)
 3f6:	1080                	addi	s0,sp,96
 3f8:	8baa                	mv	s7,a0
 3fa:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3fc:	892a                	mv	s2,a0
 3fe:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 400:	4aa9                	li	s5,10
 402:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 404:	89a6                	mv	s3,s1
 406:	2485                	addiw	s1,s1,1
 408:	0344d863          	bge	s1,s4,438 <gets+0x56>
    cc = read(0, &c, 1);
 40c:	4605                	li	a2,1
 40e:	faf40593          	addi	a1,s0,-81
 412:	4501                	li	a0,0
 414:	00000097          	auipc	ra,0x0
 418:	19c080e7          	jalr	412(ra) # 5b0 <read>
    if(cc < 1)
 41c:	00a05e63          	blez	a0,438 <gets+0x56>
    buf[i++] = c;
 420:	faf44783          	lbu	a5,-81(s0)
 424:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 428:	01578763          	beq	a5,s5,436 <gets+0x54>
 42c:	0905                	addi	s2,s2,1
 42e:	fd679be3          	bne	a5,s6,404 <gets+0x22>
  for(i=0; i+1 < max; ){
 432:	89a6                	mv	s3,s1
 434:	a011                	j	438 <gets+0x56>
 436:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 438:	99de                	add	s3,s3,s7
 43a:	00098023          	sb	zero,0(s3)
  return buf;
}
 43e:	855e                	mv	a0,s7
 440:	60e6                	ld	ra,88(sp)
 442:	6446                	ld	s0,80(sp)
 444:	64a6                	ld	s1,72(sp)
 446:	6906                	ld	s2,64(sp)
 448:	79e2                	ld	s3,56(sp)
 44a:	7a42                	ld	s4,48(sp)
 44c:	7aa2                	ld	s5,40(sp)
 44e:	7b02                	ld	s6,32(sp)
 450:	6be2                	ld	s7,24(sp)
 452:	6125                	addi	sp,sp,96
 454:	8082                	ret

0000000000000456 <stat>:

int
stat(const char *n, struct stat *st)
{
 456:	1101                	addi	sp,sp,-32
 458:	ec06                	sd	ra,24(sp)
 45a:	e822                	sd	s0,16(sp)
 45c:	e426                	sd	s1,8(sp)
 45e:	e04a                	sd	s2,0(sp)
 460:	1000                	addi	s0,sp,32
 462:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 464:	4581                	li	a1,0
 466:	00000097          	auipc	ra,0x0
 46a:	172080e7          	jalr	370(ra) # 5d8 <open>
  if(fd < 0)
 46e:	02054563          	bltz	a0,498 <stat+0x42>
 472:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 474:	85ca                	mv	a1,s2
 476:	00000097          	auipc	ra,0x0
 47a:	17a080e7          	jalr	378(ra) # 5f0 <fstat>
 47e:	892a                	mv	s2,a0
  close(fd);
 480:	8526                	mv	a0,s1
 482:	00000097          	auipc	ra,0x0
 486:	13e080e7          	jalr	318(ra) # 5c0 <close>
  return r;
}
 48a:	854a                	mv	a0,s2
 48c:	60e2                	ld	ra,24(sp)
 48e:	6442                	ld	s0,16(sp)
 490:	64a2                	ld	s1,8(sp)
 492:	6902                	ld	s2,0(sp)
 494:	6105                	addi	sp,sp,32
 496:	8082                	ret
    return -1;
 498:	597d                	li	s2,-1
 49a:	bfc5                	j	48a <stat+0x34>

000000000000049c <atoi>:

int
atoi(const char *s)
{
 49c:	1141                	addi	sp,sp,-16
 49e:	e422                	sd	s0,8(sp)
 4a0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4a2:	00054603          	lbu	a2,0(a0)
 4a6:	fd06079b          	addiw	a5,a2,-48
 4aa:	0ff7f793          	andi	a5,a5,255
 4ae:	4725                	li	a4,9
 4b0:	02f76963          	bltu	a4,a5,4e2 <atoi+0x46>
 4b4:	86aa                	mv	a3,a0
  n = 0;
 4b6:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 4b8:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 4ba:	0685                	addi	a3,a3,1
 4bc:	0025179b          	slliw	a5,a0,0x2
 4c0:	9fa9                	addw	a5,a5,a0
 4c2:	0017979b          	slliw	a5,a5,0x1
 4c6:	9fb1                	addw	a5,a5,a2
 4c8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4cc:	0006c603          	lbu	a2,0(a3)
 4d0:	fd06071b          	addiw	a4,a2,-48
 4d4:	0ff77713          	andi	a4,a4,255
 4d8:	fee5f1e3          	bgeu	a1,a4,4ba <atoi+0x1e>
  return n;
}
 4dc:	6422                	ld	s0,8(sp)
 4de:	0141                	addi	sp,sp,16
 4e0:	8082                	ret
  n = 0;
 4e2:	4501                	li	a0,0
 4e4:	bfe5                	j	4dc <atoi+0x40>

00000000000004e6 <memmove>:

// #define memcpy memmove

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4e6:	1141                	addi	sp,sp,-16
 4e8:	e422                	sd	s0,8(sp)
 4ea:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4ec:	02b57463          	bgeu	a0,a1,514 <memmove+0x2e>
    while(n-- > 0)
 4f0:	00c05f63          	blez	a2,50e <memmove+0x28>
 4f4:	1602                	slli	a2,a2,0x20
 4f6:	9201                	srli	a2,a2,0x20
 4f8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4fc:	872a                	mv	a4,a0
      *dst++ = *src++;
 4fe:	0585                	addi	a1,a1,1
 500:	0705                	addi	a4,a4,1
 502:	fff5c683          	lbu	a3,-1(a1)
 506:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 50a:	fee79ae3          	bne	a5,a4,4fe <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 50e:	6422                	ld	s0,8(sp)
 510:	0141                	addi	sp,sp,16
 512:	8082                	ret
    dst += n;
 514:	00c50733          	add	a4,a0,a2
    src += n;
 518:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 51a:	fec05ae3          	blez	a2,50e <memmove+0x28>
 51e:	fff6079b          	addiw	a5,a2,-1
 522:	1782                	slli	a5,a5,0x20
 524:	9381                	srli	a5,a5,0x20
 526:	fff7c793          	not	a5,a5
 52a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 52c:	15fd                	addi	a1,a1,-1
 52e:	177d                	addi	a4,a4,-1
 530:	0005c683          	lbu	a3,0(a1)
 534:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 538:	fee79ae3          	bne	a5,a4,52c <memmove+0x46>
 53c:	bfc9                	j	50e <memmove+0x28>

000000000000053e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 53e:	1141                	addi	sp,sp,-16
 540:	e422                	sd	s0,8(sp)
 542:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 544:	ca05                	beqz	a2,574 <memcmp+0x36>
 546:	fff6069b          	addiw	a3,a2,-1
 54a:	1682                	slli	a3,a3,0x20
 54c:	9281                	srli	a3,a3,0x20
 54e:	0685                	addi	a3,a3,1
 550:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 552:	00054783          	lbu	a5,0(a0)
 556:	0005c703          	lbu	a4,0(a1)
 55a:	00e79863          	bne	a5,a4,56a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 55e:	0505                	addi	a0,a0,1
    p2++;
 560:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 562:	fed518e3          	bne	a0,a3,552 <memcmp+0x14>
  }
  return 0;
 566:	4501                	li	a0,0
 568:	a019                	j	56e <memcmp+0x30>
      return *p1 - *p2;
 56a:	40e7853b          	subw	a0,a5,a4
}
 56e:	6422                	ld	s0,8(sp)
 570:	0141                	addi	sp,sp,16
 572:	8082                	ret
  return 0;
 574:	4501                	li	a0,0
 576:	bfe5                	j	56e <memcmp+0x30>

0000000000000578 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 578:	1141                	addi	sp,sp,-16
 57a:	e406                	sd	ra,8(sp)
 57c:	e022                	sd	s0,0(sp)
 57e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 580:	00000097          	auipc	ra,0x0
 584:	f66080e7          	jalr	-154(ra) # 4e6 <memmove>
}
 588:	60a2                	ld	ra,8(sp)
 58a:	6402                	ld	s0,0(sp)
 58c:	0141                	addi	sp,sp,16
 58e:	8082                	ret

0000000000000590 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 590:	4885                	li	a7,1
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <exit>:
.global exit
exit:
 li a7, SYS_exit
 598:	4889                	li	a7,2
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 5a0:	488d                	li	a7,3
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5a8:	4891                	li	a7,4
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <read>:
.global read
read:
 li a7, SYS_read
 5b0:	4895                	li	a7,5
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <write>:
.global write
write:
 li a7, SYS_write
 5b8:	48c1                	li	a7,16
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <close>:
.global close
close:
 li a7, SYS_close
 5c0:	48d5                	li	a7,21
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 5c8:	4899                	li	a7,6
 ecall
 5ca:	00000073          	ecall
 ret
 5ce:	8082                	ret

00000000000005d0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5d0:	489d                	li	a7,7
 ecall
 5d2:	00000073          	ecall
 ret
 5d6:	8082                	ret

00000000000005d8 <open>:
.global open
open:
 li a7, SYS_open
 5d8:	48bd                	li	a7,15
 ecall
 5da:	00000073          	ecall
 ret
 5de:	8082                	ret

00000000000005e0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5e0:	48c5                	li	a7,17
 ecall
 5e2:	00000073          	ecall
 ret
 5e6:	8082                	ret

00000000000005e8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5e8:	48c9                	li	a7,18
 ecall
 5ea:	00000073          	ecall
 ret
 5ee:	8082                	ret

00000000000005f0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5f0:	48a1                	li	a7,8
 ecall
 5f2:	00000073          	ecall
 ret
 5f6:	8082                	ret

00000000000005f8 <link>:
.global link
link:
 li a7, SYS_link
 5f8:	48cd                	li	a7,19
 ecall
 5fa:	00000073          	ecall
 ret
 5fe:	8082                	ret

0000000000000600 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 600:	48d1                	li	a7,20
 ecall
 602:	00000073          	ecall
 ret
 606:	8082                	ret

0000000000000608 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 608:	48a5                	li	a7,9
 ecall
 60a:	00000073          	ecall
 ret
 60e:	8082                	ret

0000000000000610 <dup>:
.global dup
dup:
 li a7, SYS_dup
 610:	48a9                	li	a7,10
 ecall
 612:	00000073          	ecall
 ret
 616:	8082                	ret

0000000000000618 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 618:	48ad                	li	a7,11
 ecall
 61a:	00000073          	ecall
 ret
 61e:	8082                	ret

0000000000000620 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 620:	48b1                	li	a7,12
 ecall
 622:	00000073          	ecall
 ret
 626:	8082                	ret

0000000000000628 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 628:	48b5                	li	a7,13
 ecall
 62a:	00000073          	ecall
 ret
 62e:	8082                	ret

0000000000000630 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 630:	48b9                	li	a7,14
 ecall
 632:	00000073          	ecall
 ret
 636:	8082                	ret

0000000000000638 <trace>:
.global trace
trace:
 li a7, SYS_trace
 638:	48d9                	li	a7,22
 ecall
 63a:	00000073          	ecall
 ret
 63e:	8082                	ret

0000000000000640 <alarm>:
.global alarm
alarm:
 li a7, SYS_alarm
 640:	48dd                	li	a7,23
 ecall
 642:	00000073          	ecall
 ret
 646:	8082                	ret

0000000000000648 <alarmret>:
.global alarmret
alarmret:
 li a7, SYS_alarmret
 648:	48e1                	li	a7,24
 ecall
 64a:	00000073          	ecall
 ret
 64e:	8082                	ret

0000000000000650 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 650:	1101                	addi	sp,sp,-32
 652:	ec06                	sd	ra,24(sp)
 654:	e822                	sd	s0,16(sp)
 656:	1000                	addi	s0,sp,32
 658:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 65c:	4605                	li	a2,1
 65e:	fef40593          	addi	a1,s0,-17
 662:	00000097          	auipc	ra,0x0
 666:	f56080e7          	jalr	-170(ra) # 5b8 <write>
}
 66a:	60e2                	ld	ra,24(sp)
 66c:	6442                	ld	s0,16(sp)
 66e:	6105                	addi	sp,sp,32
 670:	8082                	ret

0000000000000672 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 672:	7139                	addi	sp,sp,-64
 674:	fc06                	sd	ra,56(sp)
 676:	f822                	sd	s0,48(sp)
 678:	f426                	sd	s1,40(sp)
 67a:	f04a                	sd	s2,32(sp)
 67c:	ec4e                	sd	s3,24(sp)
 67e:	0080                	addi	s0,sp,64
 680:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 682:	c299                	beqz	a3,688 <printint+0x16>
 684:	0805c863          	bltz	a1,714 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 688:	2581                	sext.w	a1,a1
  neg = 0;
 68a:	4881                	li	a7,0
 68c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 690:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 692:	2601                	sext.w	a2,a2
 694:	00000517          	auipc	a0,0x0
 698:	4e450513          	addi	a0,a0,1252 # b78 <digits>
 69c:	883a                	mv	a6,a4
 69e:	2705                	addiw	a4,a4,1
 6a0:	02c5f7bb          	remuw	a5,a1,a2
 6a4:	1782                	slli	a5,a5,0x20
 6a6:	9381                	srli	a5,a5,0x20
 6a8:	97aa                	add	a5,a5,a0
 6aa:	0007c783          	lbu	a5,0(a5)
 6ae:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 6b2:	0005879b          	sext.w	a5,a1
 6b6:	02c5d5bb          	divuw	a1,a1,a2
 6ba:	0685                	addi	a3,a3,1
 6bc:	fec7f0e3          	bgeu	a5,a2,69c <printint+0x2a>
  if(neg)
 6c0:	00088b63          	beqz	a7,6d6 <printint+0x64>
    buf[i++] = '-';
 6c4:	fd040793          	addi	a5,s0,-48
 6c8:	973e                	add	a4,a4,a5
 6ca:	02d00793          	li	a5,45
 6ce:	fef70823          	sb	a5,-16(a4)
 6d2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6d6:	02e05863          	blez	a4,706 <printint+0x94>
 6da:	fc040793          	addi	a5,s0,-64
 6de:	00e78933          	add	s2,a5,a4
 6e2:	fff78993          	addi	s3,a5,-1
 6e6:	99ba                	add	s3,s3,a4
 6e8:	377d                	addiw	a4,a4,-1
 6ea:	1702                	slli	a4,a4,0x20
 6ec:	9301                	srli	a4,a4,0x20
 6ee:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6f2:	fff94583          	lbu	a1,-1(s2)
 6f6:	8526                	mv	a0,s1
 6f8:	00000097          	auipc	ra,0x0
 6fc:	f58080e7          	jalr	-168(ra) # 650 <putc>
  while(--i >= 0)
 700:	197d                	addi	s2,s2,-1
 702:	ff3918e3          	bne	s2,s3,6f2 <printint+0x80>
}
 706:	70e2                	ld	ra,56(sp)
 708:	7442                	ld	s0,48(sp)
 70a:	74a2                	ld	s1,40(sp)
 70c:	7902                	ld	s2,32(sp)
 70e:	69e2                	ld	s3,24(sp)
 710:	6121                	addi	sp,sp,64
 712:	8082                	ret
    x = -xx;
 714:	40b005bb          	negw	a1,a1
    neg = 1;
 718:	4885                	li	a7,1
    x = -xx;
 71a:	bf8d                	j	68c <printint+0x1a>

000000000000071c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 71c:	7119                	addi	sp,sp,-128
 71e:	fc86                	sd	ra,120(sp)
 720:	f8a2                	sd	s0,112(sp)
 722:	f4a6                	sd	s1,104(sp)
 724:	f0ca                	sd	s2,96(sp)
 726:	ecce                	sd	s3,88(sp)
 728:	e8d2                	sd	s4,80(sp)
 72a:	e4d6                	sd	s5,72(sp)
 72c:	e0da                	sd	s6,64(sp)
 72e:	fc5e                	sd	s7,56(sp)
 730:	f862                	sd	s8,48(sp)
 732:	f466                	sd	s9,40(sp)
 734:	f06a                	sd	s10,32(sp)
 736:	ec6e                	sd	s11,24(sp)
 738:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 73a:	0005c903          	lbu	s2,0(a1)
 73e:	18090f63          	beqz	s2,8dc <vprintf+0x1c0>
 742:	8aaa                	mv	s5,a0
 744:	8b32                	mv	s6,a2
 746:	00158493          	addi	s1,a1,1
  state = 0;
 74a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 74c:	02500a13          	li	s4,37
      if(c == 'd'){
 750:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 754:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 758:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 75c:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 760:	00000b97          	auipc	s7,0x0
 764:	418b8b93          	addi	s7,s7,1048 # b78 <digits>
 768:	a839                	j	786 <vprintf+0x6a>
        putc(fd, c);
 76a:	85ca                	mv	a1,s2
 76c:	8556                	mv	a0,s5
 76e:	00000097          	auipc	ra,0x0
 772:	ee2080e7          	jalr	-286(ra) # 650 <putc>
 776:	a019                	j	77c <vprintf+0x60>
    } else if(state == '%'){
 778:	01498f63          	beq	s3,s4,796 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 77c:	0485                	addi	s1,s1,1
 77e:	fff4c903          	lbu	s2,-1(s1)
 782:	14090d63          	beqz	s2,8dc <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 786:	0009079b          	sext.w	a5,s2
    if(state == 0){
 78a:	fe0997e3          	bnez	s3,778 <vprintf+0x5c>
      if(c == '%'){
 78e:	fd479ee3          	bne	a5,s4,76a <vprintf+0x4e>
        state = '%';
 792:	89be                	mv	s3,a5
 794:	b7e5                	j	77c <vprintf+0x60>
      if(c == 'd'){
 796:	05878063          	beq	a5,s8,7d6 <vprintf+0xba>
      } else if(c == 'l') {
 79a:	05978c63          	beq	a5,s9,7f2 <vprintf+0xd6>
      } else if(c == 'x') {
 79e:	07a78863          	beq	a5,s10,80e <vprintf+0xf2>
      } else if(c == 'p') {
 7a2:	09b78463          	beq	a5,s11,82a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 7a6:	07300713          	li	a4,115
 7aa:	0ce78663          	beq	a5,a4,876 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7ae:	06300713          	li	a4,99
 7b2:	0ee78e63          	beq	a5,a4,8ae <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 7b6:	11478863          	beq	a5,s4,8c6 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7ba:	85d2                	mv	a1,s4
 7bc:	8556                	mv	a0,s5
 7be:	00000097          	auipc	ra,0x0
 7c2:	e92080e7          	jalr	-366(ra) # 650 <putc>
        putc(fd, c);
 7c6:	85ca                	mv	a1,s2
 7c8:	8556                	mv	a0,s5
 7ca:	00000097          	auipc	ra,0x0
 7ce:	e86080e7          	jalr	-378(ra) # 650 <putc>
      }
      state = 0;
 7d2:	4981                	li	s3,0
 7d4:	b765                	j	77c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 7d6:	008b0913          	addi	s2,s6,8
 7da:	4685                	li	a3,1
 7dc:	4629                	li	a2,10
 7de:	000b2583          	lw	a1,0(s6)
 7e2:	8556                	mv	a0,s5
 7e4:	00000097          	auipc	ra,0x0
 7e8:	e8e080e7          	jalr	-370(ra) # 672 <printint>
 7ec:	8b4a                	mv	s6,s2
      state = 0;
 7ee:	4981                	li	s3,0
 7f0:	b771                	j	77c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7f2:	008b0913          	addi	s2,s6,8
 7f6:	4681                	li	a3,0
 7f8:	4629                	li	a2,10
 7fa:	000b2583          	lw	a1,0(s6)
 7fe:	8556                	mv	a0,s5
 800:	00000097          	auipc	ra,0x0
 804:	e72080e7          	jalr	-398(ra) # 672 <printint>
 808:	8b4a                	mv	s6,s2
      state = 0;
 80a:	4981                	li	s3,0
 80c:	bf85                	j	77c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 80e:	008b0913          	addi	s2,s6,8
 812:	4681                	li	a3,0
 814:	4641                	li	a2,16
 816:	000b2583          	lw	a1,0(s6)
 81a:	8556                	mv	a0,s5
 81c:	00000097          	auipc	ra,0x0
 820:	e56080e7          	jalr	-426(ra) # 672 <printint>
 824:	8b4a                	mv	s6,s2
      state = 0;
 826:	4981                	li	s3,0
 828:	bf91                	j	77c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 82a:	008b0793          	addi	a5,s6,8
 82e:	f8f43423          	sd	a5,-120(s0)
 832:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 836:	03000593          	li	a1,48
 83a:	8556                	mv	a0,s5
 83c:	00000097          	auipc	ra,0x0
 840:	e14080e7          	jalr	-492(ra) # 650 <putc>
  putc(fd, 'x');
 844:	85ea                	mv	a1,s10
 846:	8556                	mv	a0,s5
 848:	00000097          	auipc	ra,0x0
 84c:	e08080e7          	jalr	-504(ra) # 650 <putc>
 850:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 852:	03c9d793          	srli	a5,s3,0x3c
 856:	97de                	add	a5,a5,s7
 858:	0007c583          	lbu	a1,0(a5)
 85c:	8556                	mv	a0,s5
 85e:	00000097          	auipc	ra,0x0
 862:	df2080e7          	jalr	-526(ra) # 650 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 866:	0992                	slli	s3,s3,0x4
 868:	397d                	addiw	s2,s2,-1
 86a:	fe0914e3          	bnez	s2,852 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 86e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 872:	4981                	li	s3,0
 874:	b721                	j	77c <vprintf+0x60>
        s = va_arg(ap, char*);
 876:	008b0993          	addi	s3,s6,8
 87a:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 87e:	02090163          	beqz	s2,8a0 <vprintf+0x184>
        while(*s != 0){
 882:	00094583          	lbu	a1,0(s2)
 886:	c9a1                	beqz	a1,8d6 <vprintf+0x1ba>
          putc(fd, *s);
 888:	8556                	mv	a0,s5
 88a:	00000097          	auipc	ra,0x0
 88e:	dc6080e7          	jalr	-570(ra) # 650 <putc>
          s++;
 892:	0905                	addi	s2,s2,1
        while(*s != 0){
 894:	00094583          	lbu	a1,0(s2)
 898:	f9e5                	bnez	a1,888 <vprintf+0x16c>
        s = va_arg(ap, char*);
 89a:	8b4e                	mv	s6,s3
      state = 0;
 89c:	4981                	li	s3,0
 89e:	bdf9                	j	77c <vprintf+0x60>
          s = "(null)";
 8a0:	00000917          	auipc	s2,0x0
 8a4:	2d090913          	addi	s2,s2,720 # b70 <malloc+0x18a>
        while(*s != 0){
 8a8:	02800593          	li	a1,40
 8ac:	bff1                	j	888 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 8ae:	008b0913          	addi	s2,s6,8
 8b2:	000b4583          	lbu	a1,0(s6)
 8b6:	8556                	mv	a0,s5
 8b8:	00000097          	auipc	ra,0x0
 8bc:	d98080e7          	jalr	-616(ra) # 650 <putc>
 8c0:	8b4a                	mv	s6,s2
      state = 0;
 8c2:	4981                	li	s3,0
 8c4:	bd65                	j	77c <vprintf+0x60>
        putc(fd, c);
 8c6:	85d2                	mv	a1,s4
 8c8:	8556                	mv	a0,s5
 8ca:	00000097          	auipc	ra,0x0
 8ce:	d86080e7          	jalr	-634(ra) # 650 <putc>
      state = 0;
 8d2:	4981                	li	s3,0
 8d4:	b565                	j	77c <vprintf+0x60>
        s = va_arg(ap, char*);
 8d6:	8b4e                	mv	s6,s3
      state = 0;
 8d8:	4981                	li	s3,0
 8da:	b54d                	j	77c <vprintf+0x60>
    }
  }
}
 8dc:	70e6                	ld	ra,120(sp)
 8de:	7446                	ld	s0,112(sp)
 8e0:	74a6                	ld	s1,104(sp)
 8e2:	7906                	ld	s2,96(sp)
 8e4:	69e6                	ld	s3,88(sp)
 8e6:	6a46                	ld	s4,80(sp)
 8e8:	6aa6                	ld	s5,72(sp)
 8ea:	6b06                	ld	s6,64(sp)
 8ec:	7be2                	ld	s7,56(sp)
 8ee:	7c42                	ld	s8,48(sp)
 8f0:	7ca2                	ld	s9,40(sp)
 8f2:	7d02                	ld	s10,32(sp)
 8f4:	6de2                	ld	s11,24(sp)
 8f6:	6109                	addi	sp,sp,128
 8f8:	8082                	ret

00000000000008fa <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8fa:	715d                	addi	sp,sp,-80
 8fc:	ec06                	sd	ra,24(sp)
 8fe:	e822                	sd	s0,16(sp)
 900:	1000                	addi	s0,sp,32
 902:	e010                	sd	a2,0(s0)
 904:	e414                	sd	a3,8(s0)
 906:	e818                	sd	a4,16(s0)
 908:	ec1c                	sd	a5,24(s0)
 90a:	03043023          	sd	a6,32(s0)
 90e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 912:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 916:	8622                	mv	a2,s0
 918:	00000097          	auipc	ra,0x0
 91c:	e04080e7          	jalr	-508(ra) # 71c <vprintf>
}
 920:	60e2                	ld	ra,24(sp)
 922:	6442                	ld	s0,16(sp)
 924:	6161                	addi	sp,sp,80
 926:	8082                	ret

0000000000000928 <printf>:

void
printf(const char *fmt, ...)
{
 928:	711d                	addi	sp,sp,-96
 92a:	ec06                	sd	ra,24(sp)
 92c:	e822                	sd	s0,16(sp)
 92e:	1000                	addi	s0,sp,32
 930:	e40c                	sd	a1,8(s0)
 932:	e810                	sd	a2,16(s0)
 934:	ec14                	sd	a3,24(s0)
 936:	f018                	sd	a4,32(s0)
 938:	f41c                	sd	a5,40(s0)
 93a:	03043823          	sd	a6,48(s0)
 93e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 942:	00840613          	addi	a2,s0,8
 946:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 94a:	85aa                	mv	a1,a0
 94c:	4505                	li	a0,1
 94e:	00000097          	auipc	ra,0x0
 952:	dce080e7          	jalr	-562(ra) # 71c <vprintf>
}
 956:	60e2                	ld	ra,24(sp)
 958:	6442                	ld	s0,16(sp)
 95a:	6125                	addi	sp,sp,96
 95c:	8082                	ret

000000000000095e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 95e:	1141                	addi	sp,sp,-16
 960:	e422                	sd	s0,8(sp)
 962:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 964:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 968:	00000797          	auipc	a5,0x0
 96c:	2287b783          	ld	a5,552(a5) # b90 <freep>
 970:	a805                	j	9a0 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 972:	4618                	lw	a4,8(a2)
 974:	9db9                	addw	a1,a1,a4
 976:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 97a:	6398                	ld	a4,0(a5)
 97c:	6318                	ld	a4,0(a4)
 97e:	fee53823          	sd	a4,-16(a0)
 982:	a091                	j	9c6 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 984:	ff852703          	lw	a4,-8(a0)
 988:	9e39                	addw	a2,a2,a4
 98a:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 98c:	ff053703          	ld	a4,-16(a0)
 990:	e398                	sd	a4,0(a5)
 992:	a099                	j	9d8 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 994:	6398                	ld	a4,0(a5)
 996:	00e7e463          	bltu	a5,a4,99e <free+0x40>
 99a:	00e6ea63          	bltu	a3,a4,9ae <free+0x50>
{
 99e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9a0:	fed7fae3          	bgeu	a5,a3,994 <free+0x36>
 9a4:	6398                	ld	a4,0(a5)
 9a6:	00e6e463          	bltu	a3,a4,9ae <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9aa:	fee7eae3          	bltu	a5,a4,99e <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 9ae:	ff852583          	lw	a1,-8(a0)
 9b2:	6390                	ld	a2,0(a5)
 9b4:	02059713          	slli	a4,a1,0x20
 9b8:	9301                	srli	a4,a4,0x20
 9ba:	0712                	slli	a4,a4,0x4
 9bc:	9736                	add	a4,a4,a3
 9be:	fae60ae3          	beq	a2,a4,972 <free+0x14>
    bp->s.ptr = p->s.ptr;
 9c2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9c6:	4790                	lw	a2,8(a5)
 9c8:	02061713          	slli	a4,a2,0x20
 9cc:	9301                	srli	a4,a4,0x20
 9ce:	0712                	slli	a4,a4,0x4
 9d0:	973e                	add	a4,a4,a5
 9d2:	fae689e3          	beq	a3,a4,984 <free+0x26>
  } else
    p->s.ptr = bp;
 9d6:	e394                	sd	a3,0(a5)
  freep = p;
 9d8:	00000717          	auipc	a4,0x0
 9dc:	1af73c23          	sd	a5,440(a4) # b90 <freep>
}
 9e0:	6422                	ld	s0,8(sp)
 9e2:	0141                	addi	sp,sp,16
 9e4:	8082                	ret

00000000000009e6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9e6:	7139                	addi	sp,sp,-64
 9e8:	fc06                	sd	ra,56(sp)
 9ea:	f822                	sd	s0,48(sp)
 9ec:	f426                	sd	s1,40(sp)
 9ee:	f04a                	sd	s2,32(sp)
 9f0:	ec4e                	sd	s3,24(sp)
 9f2:	e852                	sd	s4,16(sp)
 9f4:	e456                	sd	s5,8(sp)
 9f6:	e05a                	sd	s6,0(sp)
 9f8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9fa:	02051493          	slli	s1,a0,0x20
 9fe:	9081                	srli	s1,s1,0x20
 a00:	04bd                	addi	s1,s1,15
 a02:	8091                	srli	s1,s1,0x4
 a04:	0014899b          	addiw	s3,s1,1
 a08:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a0a:	00000517          	auipc	a0,0x0
 a0e:	18653503          	ld	a0,390(a0) # b90 <freep>
 a12:	c515                	beqz	a0,a3e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a14:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a16:	4798                	lw	a4,8(a5)
 a18:	02977f63          	bgeu	a4,s1,a56 <malloc+0x70>
 a1c:	8a4e                	mv	s4,s3
 a1e:	0009871b          	sext.w	a4,s3
 a22:	6685                	lui	a3,0x1
 a24:	00d77363          	bgeu	a4,a3,a2a <malloc+0x44>
 a28:	6a05                	lui	s4,0x1
 a2a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a2e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a32:	00000917          	auipc	s2,0x0
 a36:	15e90913          	addi	s2,s2,350 # b90 <freep>
  if(p == (char*)-1)
 a3a:	5afd                	li	s5,-1
 a3c:	a88d                	j	aae <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 a3e:	00000797          	auipc	a5,0x0
 a42:	15a78793          	addi	a5,a5,346 # b98 <base>
 a46:	00000717          	auipc	a4,0x0
 a4a:	14f73523          	sd	a5,330(a4) # b90 <freep>
 a4e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a50:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a54:	b7e1                	j	a1c <malloc+0x36>
      if(p->s.size == nunits)
 a56:	02e48b63          	beq	s1,a4,a8c <malloc+0xa6>
        p->s.size -= nunits;
 a5a:	4137073b          	subw	a4,a4,s3
 a5e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a60:	1702                	slli	a4,a4,0x20
 a62:	9301                	srli	a4,a4,0x20
 a64:	0712                	slli	a4,a4,0x4
 a66:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a68:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a6c:	00000717          	auipc	a4,0x0
 a70:	12a73223          	sd	a0,292(a4) # b90 <freep>
      return (void*)(p + 1);
 a74:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a78:	70e2                	ld	ra,56(sp)
 a7a:	7442                	ld	s0,48(sp)
 a7c:	74a2                	ld	s1,40(sp)
 a7e:	7902                	ld	s2,32(sp)
 a80:	69e2                	ld	s3,24(sp)
 a82:	6a42                	ld	s4,16(sp)
 a84:	6aa2                	ld	s5,8(sp)
 a86:	6b02                	ld	s6,0(sp)
 a88:	6121                	addi	sp,sp,64
 a8a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a8c:	6398                	ld	a4,0(a5)
 a8e:	e118                	sd	a4,0(a0)
 a90:	bff1                	j	a6c <malloc+0x86>
  hp->s.size = nu;
 a92:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a96:	0541                	addi	a0,a0,16
 a98:	00000097          	auipc	ra,0x0
 a9c:	ec6080e7          	jalr	-314(ra) # 95e <free>
  return freep;
 aa0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 aa4:	d971                	beqz	a0,a78 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aa6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 aa8:	4798                	lw	a4,8(a5)
 aaa:	fa9776e3          	bgeu	a4,s1,a56 <malloc+0x70>
    if(p == freep)
 aae:	00093703          	ld	a4,0(s2)
 ab2:	853e                	mv	a0,a5
 ab4:	fef719e3          	bne	a4,a5,aa6 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 ab8:	8552                	mv	a0,s4
 aba:	00000097          	auipc	ra,0x0
 abe:	b66080e7          	jalr	-1178(ra) # 620 <sbrk>
  if(p == (char*)-1)
 ac2:	fd5518e3          	bne	a0,s5,a92 <malloc+0xac>
        return 0;
 ac6:	4501                	li	a0,0
 ac8:	bf45                	j	a78 <malloc+0x92>
