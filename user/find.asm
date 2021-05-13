
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <search>:
#include "kernel/types.h"
#include "kernel/fcntl.h"
#include "kernel/stat.h"
#include "kernel/fs.h"

void search(char *cwd,char *pat){
   0:	d7010113          	addi	sp,sp,-656
   4:	28113423          	sd	ra,648(sp)
   8:	28813023          	sd	s0,640(sp)
   c:	26913c23          	sd	s1,632(sp)
  10:	27213823          	sd	s2,624(sp)
  14:	27313423          	sd	s3,616(sp)
  18:	27413023          	sd	s4,608(sp)
  1c:	25513c23          	sd	s5,600(sp)
  20:	25613823          	sd	s6,592(sp)
  24:	25713423          	sd	s7,584(sp)
  28:	25813023          	sd	s8,576(sp)
  2c:	23913c23          	sd	s9,568(sp)
  30:	0d00                	addi	s0,sp,656
  32:	84aa                	mv	s1,a0
  34:	8b2e                	mv	s6,a1
    char buf[512],*cur;
    struct stat st;
    i32 fd = Open(cwd, O_RDONLY);
  36:	4581                	li	a1,0
  38:	00001097          	auipc	ra,0x1
  3c:	a10080e7          	jalr	-1520(ra) # a48 <Open>
  40:	8a2a                	mv	s4,a0
    Fstat(fd, &st);
  42:	d8840593          	addi	a1,s0,-632
  46:	00001097          	auipc	ra,0x1
  4a:	a3a080e7          	jalr	-1478(ra) # a80 <Fstat>
    if (st.type != T_DIR){
  4e:	d9041703          	lh	a4,-624(s0)
  52:	4785                	li	a5,1
  54:	06f71e63          	bne	a4,a5,d0 <search+0xd0>
        printf("cwd is not a directory");
        exit(0);
    }

    struct dirent child;
    strcpy(buf,cwd);
  58:	85a6                	mv	a1,s1
  5a:	da040513          	addi	a0,s0,-608
  5e:	00000097          	auipc	ra,0x0
  62:	1a2080e7          	jalr	418(ra) # 200 <strcpy>
    cur = buf + strlen(buf);
  66:	da040513          	addi	a0,s0,-608
  6a:	00000097          	auipc	ra,0x0
  6e:	1de080e7          	jalr	478(ra) # 248 <strlen>
  72:	02051993          	slli	s3,a0,0x20
  76:	0209d993          	srli	s3,s3,0x20
  7a:	da040793          	addi	a5,s0,-608
  7e:	99be                	add	s3,s3,a5
    *cur++ = '/';
  80:	00198a93          	addi	s5,s3,1
  84:	02f00793          	li	a5,47
  88:	00f98023          	sb	a5,0(s3)
    int index;
    for_(2)
        read(fd, &child, sizeof(child));
  8c:	4641                	li	a2,16
  8e:	d7840593          	addi	a1,s0,-648
  92:	8552                	mv	a0,s4
  94:	00000097          	auipc	ra,0x0
  98:	3f2080e7          	jalr	1010(ra) # 486 <read>
  9c:	4641                	li	a2,16
  9e:	d7840593          	addi	a1,s0,-648
  a2:	8552                	mv	a0,s4
  a4:	00000097          	auipc	ra,0x0
  a8:	3e2080e7          	jalr	994(ra) # 486 <read>
    int entries = st.size / (sizeof (struct dirent) );
  ac:	d9843903          	ld	s2,-616(s0)
  b0:	00495913          	srli	s2,s2,0x4
    for_(entries -2 ){
  b4:	0009071b          	sext.w	a4,s2
  b8:	4789                	li	a5,2
  ba:	0ce7d263          	bge	a5,a4,17e <search+0x17e>
  be:	3979                	addiw	s2,s2,-2
  c0:	4481                	li	s1,0
        *(cur + DIRSIZ) = '\0';
        char *real = strchr(cur,' ');
        if (real != (void*)0)
            *real = '\0';
        Stat(buf,&st);
        switch (st.type)
  c2:	4c05                	li	s8,1
  c4:	4b89                	li	s7,2
        {
        case T_FILE:
            if ( (index = strstr(child.name,pat)) >= 0){
                printf("%s \n",buf);
  c6:	00001c97          	auipc	s9,0x1
  ca:	c22c8c93          	addi	s9,s9,-990 # ce8 <strstr+0x76>
  ce:	a805                	j	fe <search+0xfe>
        printf("cwd is not a directory");
  d0:	00001517          	auipc	a0,0x1
  d4:	c0050513          	addi	a0,a0,-1024 # cd0 <strstr+0x5e>
  d8:	00000097          	auipc	ra,0x0
  dc:	726080e7          	jalr	1830(ra) # 7fe <printf>
        exit(0);
  e0:	4501                	li	a0,0
  e2:	00000097          	auipc	ra,0x0
  e6:	38c080e7          	jalr	908(ra) # 46e <exit>
            }
            // else
            //     printf("index %d\n",index); 
            break;
        case T_DIR:
            search(buf,pat);
  ea:	85da                	mv	a1,s6
  ec:	da040513          	addi	a0,s0,-608
  f0:	00000097          	auipc	ra,0x0
  f4:	f10080e7          	jalr	-240(ra) # 0 <search>
    for_(entries -2 ){
  f8:	2485                	addiw	s1,s1,1
  fa:	09248263          	beq	s1,s2,17e <search+0x17e>
        Read(fd, &child, sizeof(child));
  fe:	4641                	li	a2,16
 100:	d7840593          	addi	a1,s0,-648
 104:	8552                	mv	a0,s4
 106:	00001097          	auipc	ra,0x1
 10a:	90a080e7          	jalr	-1782(ra) # a10 <Read>
        if(child.inum == 0)
 10e:	d7845783          	lhu	a5,-648(s0)
 112:	d3fd                	beqz	a5,f8 <search+0xf8>
        memcpy(cur,child.name,DIRSIZ);
 114:	4639                	li	a2,14
 116:	d7a40593          	addi	a1,s0,-646
 11a:	8556                	mv	a0,s5
 11c:	00000097          	auipc	ra,0x0
 120:	332080e7          	jalr	818(ra) # 44e <memcpy>
        *(cur + DIRSIZ) = '\0';
 124:	000987a3          	sb	zero,15(s3)
        char *real = strchr(cur,' ');
 128:	02000593          	li	a1,32
 12c:	8556                	mv	a0,s5
 12e:	00000097          	auipc	ra,0x0
 132:	166080e7          	jalr	358(ra) # 294 <strchr>
        if (real != (void*)0)
 136:	c119                	beqz	a0,13c <search+0x13c>
            *real = '\0';
 138:	00050023          	sb	zero,0(a0)
        Stat(buf,&st);
 13c:	d8840593          	addi	a1,s0,-632
 140:	da040513          	addi	a0,s0,-608
 144:	00001097          	auipc	ra,0x1
 148:	a2e080e7          	jalr	-1490(ra) # b72 <Stat>
        switch (st.type)
 14c:	d9041783          	lh	a5,-624(s0)
 150:	0007871b          	sext.w	a4,a5
 154:	f9870be3          	beq	a4,s8,ea <search+0xea>
 158:	fb7710e3          	bne	a4,s7,f8 <search+0xf8>
            if ( (index = strstr(child.name,pat)) >= 0){
 15c:	85da                	mv	a1,s6
 15e:	d7a40513          	addi	a0,s0,-646
 162:	00001097          	auipc	ra,0x1
 166:	b10080e7          	jalr	-1264(ra) # c72 <strstr>
 16a:	f80547e3          	bltz	a0,f8 <search+0xf8>
                printf("%s \n",buf);
 16e:	da040593          	addi	a1,s0,-608
 172:	8566                	mv	a0,s9
 174:	00000097          	auipc	ra,0x0
 178:	68a080e7          	jalr	1674(ra) # 7fe <printf>
 17c:	bfb5                	j	f8 <search+0xf8>
        default:
            break;
        }
    }

}
 17e:	28813083          	ld	ra,648(sp)
 182:	28013403          	ld	s0,640(sp)
 186:	27813483          	ld	s1,632(sp)
 18a:	27013903          	ld	s2,624(sp)
 18e:	26813983          	ld	s3,616(sp)
 192:	26013a03          	ld	s4,608(sp)
 196:	25813a83          	ld	s5,600(sp)
 19a:	25013b03          	ld	s6,592(sp)
 19e:	24813b83          	ld	s7,584(sp)
 1a2:	24013c03          	ld	s8,576(sp)
 1a6:	23813c83          	ld	s9,568(sp)
 1aa:	29010113          	addi	sp,sp,656
 1ae:	8082                	ret

00000000000001b0 <main>:


int main(int argc, char** argv){
 1b0:	1141                	addi	sp,sp,-16
 1b2:	e406                	sd	ra,8(sp)
 1b4:	e022                	sd	s0,0(sp)
 1b6:	0800                	addi	s0,sp,16
    char *cwd,*pat;
    if (argc == 2){
 1b8:	4789                	li	a5,2
 1ba:	00f50863          	beq	a0,a5,1ca <main+0x1a>
        cwd = ".";
        pat = argv[1];
    }
    else if (argc == 3){
 1be:	478d                	li	a5,3
 1c0:	02f51363          	bne	a0,a5,1e6 <main+0x36>
        cwd = argv[1];
 1c4:	6588                	ld	a0,8(a1)
        pat = argv[2];
 1c6:	698c                	ld	a1,16(a1)
 1c8:	a031                	j	1d4 <main+0x24>
        pat = argv[1];
 1ca:	658c                	ld	a1,8(a1)
        cwd = ".";
 1cc:	00001517          	auipc	a0,0x1
 1d0:	b2450513          	addi	a0,a0,-1244 # cf0 <strstr+0x7e>
    }
    else {
        printf("usage : find <path> <pattern>\n");
        exit(0);
    }
    search(cwd,pat);
 1d4:	00000097          	auipc	ra,0x0
 1d8:	e2c080e7          	jalr	-468(ra) # 0 <search>
    exit(0);
 1dc:	4501                	li	a0,0
 1de:	00000097          	auipc	ra,0x0
 1e2:	290080e7          	jalr	656(ra) # 46e <exit>
        printf("usage : find <path> <pattern>\n");
 1e6:	00001517          	auipc	a0,0x1
 1ea:	b1250513          	addi	a0,a0,-1262 # cf8 <strstr+0x86>
 1ee:	00000097          	auipc	ra,0x0
 1f2:	610080e7          	jalr	1552(ra) # 7fe <printf>
        exit(0);
 1f6:	4501                	li	a0,0
 1f8:	00000097          	auipc	ra,0x0
 1fc:	276080e7          	jalr	630(ra) # 46e <exit>

0000000000000200 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 200:	1141                	addi	sp,sp,-16
 202:	e422                	sd	s0,8(sp)
 204:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 206:	87aa                	mv	a5,a0
 208:	0585                	addi	a1,a1,1
 20a:	0785                	addi	a5,a5,1
 20c:	fff5c703          	lbu	a4,-1(a1)
 210:	fee78fa3          	sb	a4,-1(a5)
 214:	fb75                	bnez	a4,208 <strcpy+0x8>
    ;
  return os;
}
 216:	6422                	ld	s0,8(sp)
 218:	0141                	addi	sp,sp,16
 21a:	8082                	ret

000000000000021c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 21c:	1141                	addi	sp,sp,-16
 21e:	e422                	sd	s0,8(sp)
 220:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 222:	00054783          	lbu	a5,0(a0)
 226:	cb91                	beqz	a5,23a <strcmp+0x1e>
 228:	0005c703          	lbu	a4,0(a1)
 22c:	00f71763          	bne	a4,a5,23a <strcmp+0x1e>
    p++, q++;
 230:	0505                	addi	a0,a0,1
 232:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 234:	00054783          	lbu	a5,0(a0)
 238:	fbe5                	bnez	a5,228 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 23a:	0005c503          	lbu	a0,0(a1)
}
 23e:	40a7853b          	subw	a0,a5,a0
 242:	6422                	ld	s0,8(sp)
 244:	0141                	addi	sp,sp,16
 246:	8082                	ret

0000000000000248 <strlen>:

uint
strlen(const char *s)
{
 248:	1141                	addi	sp,sp,-16
 24a:	e422                	sd	s0,8(sp)
 24c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 24e:	00054783          	lbu	a5,0(a0)
 252:	cf91                	beqz	a5,26e <strlen+0x26>
 254:	0505                	addi	a0,a0,1
 256:	87aa                	mv	a5,a0
 258:	4685                	li	a3,1
 25a:	9e89                	subw	a3,a3,a0
 25c:	00f6853b          	addw	a0,a3,a5
 260:	0785                	addi	a5,a5,1
 262:	fff7c703          	lbu	a4,-1(a5)
 266:	fb7d                	bnez	a4,25c <strlen+0x14>
    ;
  return n;
}
 268:	6422                	ld	s0,8(sp)
 26a:	0141                	addi	sp,sp,16
 26c:	8082                	ret
  for(n = 0; s[n]; n++)
 26e:	4501                	li	a0,0
 270:	bfe5                	j	268 <strlen+0x20>

0000000000000272 <memset>:

void*
memset(void *dst, int c, uint n)
{
 272:	1141                	addi	sp,sp,-16
 274:	e422                	sd	s0,8(sp)
 276:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 278:	ca19                	beqz	a2,28e <memset+0x1c>
 27a:	87aa                	mv	a5,a0
 27c:	1602                	slli	a2,a2,0x20
 27e:	9201                	srli	a2,a2,0x20
 280:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 284:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 288:	0785                	addi	a5,a5,1
 28a:	fee79de3          	bne	a5,a4,284 <memset+0x12>
  }
  return dst;
}
 28e:	6422                	ld	s0,8(sp)
 290:	0141                	addi	sp,sp,16
 292:	8082                	ret

0000000000000294 <strchr>:

char*
strchr(const char *s, char c)
{
 294:	1141                	addi	sp,sp,-16
 296:	e422                	sd	s0,8(sp)
 298:	0800                	addi	s0,sp,16
  for(; *s; s++)
 29a:	00054783          	lbu	a5,0(a0)
 29e:	cb99                	beqz	a5,2b4 <strchr+0x20>
    if(*s == c)
 2a0:	00f58763          	beq	a1,a5,2ae <strchr+0x1a>
  for(; *s; s++)
 2a4:	0505                	addi	a0,a0,1
 2a6:	00054783          	lbu	a5,0(a0)
 2aa:	fbfd                	bnez	a5,2a0 <strchr+0xc>
      return (char*)s;
  return 0;
 2ac:	4501                	li	a0,0
}
 2ae:	6422                	ld	s0,8(sp)
 2b0:	0141                	addi	sp,sp,16
 2b2:	8082                	ret
  return 0;
 2b4:	4501                	li	a0,0
 2b6:	bfe5                	j	2ae <strchr+0x1a>

00000000000002b8 <gets>:

char*
gets(char *buf, int max)
{
 2b8:	711d                	addi	sp,sp,-96
 2ba:	ec86                	sd	ra,88(sp)
 2bc:	e8a2                	sd	s0,80(sp)
 2be:	e4a6                	sd	s1,72(sp)
 2c0:	e0ca                	sd	s2,64(sp)
 2c2:	fc4e                	sd	s3,56(sp)
 2c4:	f852                	sd	s4,48(sp)
 2c6:	f456                	sd	s5,40(sp)
 2c8:	f05a                	sd	s6,32(sp)
 2ca:	ec5e                	sd	s7,24(sp)
 2cc:	1080                	addi	s0,sp,96
 2ce:	8baa                	mv	s7,a0
 2d0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2d2:	892a                	mv	s2,a0
 2d4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2d6:	4aa9                	li	s5,10
 2d8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2da:	89a6                	mv	s3,s1
 2dc:	2485                	addiw	s1,s1,1
 2de:	0344d863          	bge	s1,s4,30e <gets+0x56>
    cc = read(0, &c, 1);
 2e2:	4605                	li	a2,1
 2e4:	faf40593          	addi	a1,s0,-81
 2e8:	4501                	li	a0,0
 2ea:	00000097          	auipc	ra,0x0
 2ee:	19c080e7          	jalr	412(ra) # 486 <read>
    if(cc < 1)
 2f2:	00a05e63          	blez	a0,30e <gets+0x56>
    buf[i++] = c;
 2f6:	faf44783          	lbu	a5,-81(s0)
 2fa:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2fe:	01578763          	beq	a5,s5,30c <gets+0x54>
 302:	0905                	addi	s2,s2,1
 304:	fd679be3          	bne	a5,s6,2da <gets+0x22>
  for(i=0; i+1 < max; ){
 308:	89a6                	mv	s3,s1
 30a:	a011                	j	30e <gets+0x56>
 30c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 30e:	99de                	add	s3,s3,s7
 310:	00098023          	sb	zero,0(s3)
  return buf;
}
 314:	855e                	mv	a0,s7
 316:	60e6                	ld	ra,88(sp)
 318:	6446                	ld	s0,80(sp)
 31a:	64a6                	ld	s1,72(sp)
 31c:	6906                	ld	s2,64(sp)
 31e:	79e2                	ld	s3,56(sp)
 320:	7a42                	ld	s4,48(sp)
 322:	7aa2                	ld	s5,40(sp)
 324:	7b02                	ld	s6,32(sp)
 326:	6be2                	ld	s7,24(sp)
 328:	6125                	addi	sp,sp,96
 32a:	8082                	ret

000000000000032c <stat>:

int
stat(const char *n, struct stat *st)
{
 32c:	1101                	addi	sp,sp,-32
 32e:	ec06                	sd	ra,24(sp)
 330:	e822                	sd	s0,16(sp)
 332:	e426                	sd	s1,8(sp)
 334:	e04a                	sd	s2,0(sp)
 336:	1000                	addi	s0,sp,32
 338:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 33a:	4581                	li	a1,0
 33c:	00000097          	auipc	ra,0x0
 340:	172080e7          	jalr	370(ra) # 4ae <open>
  if(fd < 0)
 344:	02054563          	bltz	a0,36e <stat+0x42>
 348:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 34a:	85ca                	mv	a1,s2
 34c:	00000097          	auipc	ra,0x0
 350:	17a080e7          	jalr	378(ra) # 4c6 <fstat>
 354:	892a                	mv	s2,a0
  close(fd);
 356:	8526                	mv	a0,s1
 358:	00000097          	auipc	ra,0x0
 35c:	13e080e7          	jalr	318(ra) # 496 <close>
  return r;
}
 360:	854a                	mv	a0,s2
 362:	60e2                	ld	ra,24(sp)
 364:	6442                	ld	s0,16(sp)
 366:	64a2                	ld	s1,8(sp)
 368:	6902                	ld	s2,0(sp)
 36a:	6105                	addi	sp,sp,32
 36c:	8082                	ret
    return -1;
 36e:	597d                	li	s2,-1
 370:	bfc5                	j	360 <stat+0x34>

0000000000000372 <atoi>:

int
atoi(const char *s)
{
 372:	1141                	addi	sp,sp,-16
 374:	e422                	sd	s0,8(sp)
 376:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 378:	00054603          	lbu	a2,0(a0)
 37c:	fd06079b          	addiw	a5,a2,-48
 380:	0ff7f793          	andi	a5,a5,255
 384:	4725                	li	a4,9
 386:	02f76963          	bltu	a4,a5,3b8 <atoi+0x46>
 38a:	86aa                	mv	a3,a0
  n = 0;
 38c:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 38e:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 390:	0685                	addi	a3,a3,1
 392:	0025179b          	slliw	a5,a0,0x2
 396:	9fa9                	addw	a5,a5,a0
 398:	0017979b          	slliw	a5,a5,0x1
 39c:	9fb1                	addw	a5,a5,a2
 39e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3a2:	0006c603          	lbu	a2,0(a3)
 3a6:	fd06071b          	addiw	a4,a2,-48
 3aa:	0ff77713          	andi	a4,a4,255
 3ae:	fee5f1e3          	bgeu	a1,a4,390 <atoi+0x1e>
  return n;
}
 3b2:	6422                	ld	s0,8(sp)
 3b4:	0141                	addi	sp,sp,16
 3b6:	8082                	ret
  n = 0;
 3b8:	4501                	li	a0,0
 3ba:	bfe5                	j	3b2 <atoi+0x40>

00000000000003bc <memmove>:

// #define memcpy memmove

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3bc:	1141                	addi	sp,sp,-16
 3be:	e422                	sd	s0,8(sp)
 3c0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3c2:	02b57463          	bgeu	a0,a1,3ea <memmove+0x2e>
    while(n-- > 0)
 3c6:	00c05f63          	blez	a2,3e4 <memmove+0x28>
 3ca:	1602                	slli	a2,a2,0x20
 3cc:	9201                	srli	a2,a2,0x20
 3ce:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3d2:	872a                	mv	a4,a0
      *dst++ = *src++;
 3d4:	0585                	addi	a1,a1,1
 3d6:	0705                	addi	a4,a4,1
 3d8:	fff5c683          	lbu	a3,-1(a1)
 3dc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3e0:	fee79ae3          	bne	a5,a4,3d4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3e4:	6422                	ld	s0,8(sp)
 3e6:	0141                	addi	sp,sp,16
 3e8:	8082                	ret
    dst += n;
 3ea:	00c50733          	add	a4,a0,a2
    src += n;
 3ee:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3f0:	fec05ae3          	blez	a2,3e4 <memmove+0x28>
 3f4:	fff6079b          	addiw	a5,a2,-1
 3f8:	1782                	slli	a5,a5,0x20
 3fa:	9381                	srli	a5,a5,0x20
 3fc:	fff7c793          	not	a5,a5
 400:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 402:	15fd                	addi	a1,a1,-1
 404:	177d                	addi	a4,a4,-1
 406:	0005c683          	lbu	a3,0(a1)
 40a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 40e:	fee79ae3          	bne	a5,a4,402 <memmove+0x46>
 412:	bfc9                	j	3e4 <memmove+0x28>

0000000000000414 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 414:	1141                	addi	sp,sp,-16
 416:	e422                	sd	s0,8(sp)
 418:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 41a:	ca05                	beqz	a2,44a <memcmp+0x36>
 41c:	fff6069b          	addiw	a3,a2,-1
 420:	1682                	slli	a3,a3,0x20
 422:	9281                	srli	a3,a3,0x20
 424:	0685                	addi	a3,a3,1
 426:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 428:	00054783          	lbu	a5,0(a0)
 42c:	0005c703          	lbu	a4,0(a1)
 430:	00e79863          	bne	a5,a4,440 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 434:	0505                	addi	a0,a0,1
    p2++;
 436:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 438:	fed518e3          	bne	a0,a3,428 <memcmp+0x14>
  }
  return 0;
 43c:	4501                	li	a0,0
 43e:	a019                	j	444 <memcmp+0x30>
      return *p1 - *p2;
 440:	40e7853b          	subw	a0,a5,a4
}
 444:	6422                	ld	s0,8(sp)
 446:	0141                	addi	sp,sp,16
 448:	8082                	ret
  return 0;
 44a:	4501                	li	a0,0
 44c:	bfe5                	j	444 <memcmp+0x30>

000000000000044e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 44e:	1141                	addi	sp,sp,-16
 450:	e406                	sd	ra,8(sp)
 452:	e022                	sd	s0,0(sp)
 454:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 456:	00000097          	auipc	ra,0x0
 45a:	f66080e7          	jalr	-154(ra) # 3bc <memmove>
}
 45e:	60a2                	ld	ra,8(sp)
 460:	6402                	ld	s0,0(sp)
 462:	0141                	addi	sp,sp,16
 464:	8082                	ret

0000000000000466 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 466:	4885                	li	a7,1
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <exit>:
.global exit
exit:
 li a7, SYS_exit
 46e:	4889                	li	a7,2
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <wait>:
.global wait
wait:
 li a7, SYS_wait
 476:	488d                	li	a7,3
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 47e:	4891                	li	a7,4
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <read>:
.global read
read:
 li a7, SYS_read
 486:	4895                	li	a7,5
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <write>:
.global write
write:
 li a7, SYS_write
 48e:	48c1                	li	a7,16
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <close>:
.global close
close:
 li a7, SYS_close
 496:	48d5                	li	a7,21
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <kill>:
.global kill
kill:
 li a7, SYS_kill
 49e:	4899                	li	a7,6
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4a6:	489d                	li	a7,7
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <open>:
.global open
open:
 li a7, SYS_open
 4ae:	48bd                	li	a7,15
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4b6:	48c5                	li	a7,17
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4be:	48c9                	li	a7,18
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4c6:	48a1                	li	a7,8
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <link>:
.global link
link:
 li a7, SYS_link
 4ce:	48cd                	li	a7,19
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4d6:	48d1                	li	a7,20
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4de:	48a5                	li	a7,9
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4e6:	48a9                	li	a7,10
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4ee:	48ad                	li	a7,11
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4f6:	48b1                	li	a7,12
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4fe:	48b5                	li	a7,13
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 506:	48b9                	li	a7,14
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <trace>:
.global trace
trace:
 li a7, SYS_trace
 50e:	48d9                	li	a7,22
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <alarm>:
.global alarm
alarm:
 li a7, SYS_alarm
 516:	48dd                	li	a7,23
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <alarmret>:
.global alarmret
alarmret:
 li a7, SYS_alarmret
 51e:	48e1                	li	a7,24
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 526:	1101                	addi	sp,sp,-32
 528:	ec06                	sd	ra,24(sp)
 52a:	e822                	sd	s0,16(sp)
 52c:	1000                	addi	s0,sp,32
 52e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 532:	4605                	li	a2,1
 534:	fef40593          	addi	a1,s0,-17
 538:	00000097          	auipc	ra,0x0
 53c:	f56080e7          	jalr	-170(ra) # 48e <write>
}
 540:	60e2                	ld	ra,24(sp)
 542:	6442                	ld	s0,16(sp)
 544:	6105                	addi	sp,sp,32
 546:	8082                	ret

0000000000000548 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 548:	7139                	addi	sp,sp,-64
 54a:	fc06                	sd	ra,56(sp)
 54c:	f822                	sd	s0,48(sp)
 54e:	f426                	sd	s1,40(sp)
 550:	f04a                	sd	s2,32(sp)
 552:	ec4e                	sd	s3,24(sp)
 554:	0080                	addi	s0,sp,64
 556:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 558:	c299                	beqz	a3,55e <printint+0x16>
 55a:	0805c863          	bltz	a1,5ea <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 55e:	2581                	sext.w	a1,a1
  neg = 0;
 560:	4881                	li	a7,0
 562:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 566:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 568:	2601                	sext.w	a2,a2
 56a:	00000517          	auipc	a0,0x0
 56e:	7b650513          	addi	a0,a0,1974 # d20 <digits>
 572:	883a                	mv	a6,a4
 574:	2705                	addiw	a4,a4,1
 576:	02c5f7bb          	remuw	a5,a1,a2
 57a:	1782                	slli	a5,a5,0x20
 57c:	9381                	srli	a5,a5,0x20
 57e:	97aa                	add	a5,a5,a0
 580:	0007c783          	lbu	a5,0(a5)
 584:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 588:	0005879b          	sext.w	a5,a1
 58c:	02c5d5bb          	divuw	a1,a1,a2
 590:	0685                	addi	a3,a3,1
 592:	fec7f0e3          	bgeu	a5,a2,572 <printint+0x2a>
  if(neg)
 596:	00088b63          	beqz	a7,5ac <printint+0x64>
    buf[i++] = '-';
 59a:	fd040793          	addi	a5,s0,-48
 59e:	973e                	add	a4,a4,a5
 5a0:	02d00793          	li	a5,45
 5a4:	fef70823          	sb	a5,-16(a4)
 5a8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5ac:	02e05863          	blez	a4,5dc <printint+0x94>
 5b0:	fc040793          	addi	a5,s0,-64
 5b4:	00e78933          	add	s2,a5,a4
 5b8:	fff78993          	addi	s3,a5,-1
 5bc:	99ba                	add	s3,s3,a4
 5be:	377d                	addiw	a4,a4,-1
 5c0:	1702                	slli	a4,a4,0x20
 5c2:	9301                	srli	a4,a4,0x20
 5c4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5c8:	fff94583          	lbu	a1,-1(s2)
 5cc:	8526                	mv	a0,s1
 5ce:	00000097          	auipc	ra,0x0
 5d2:	f58080e7          	jalr	-168(ra) # 526 <putc>
  while(--i >= 0)
 5d6:	197d                	addi	s2,s2,-1
 5d8:	ff3918e3          	bne	s2,s3,5c8 <printint+0x80>
}
 5dc:	70e2                	ld	ra,56(sp)
 5de:	7442                	ld	s0,48(sp)
 5e0:	74a2                	ld	s1,40(sp)
 5e2:	7902                	ld	s2,32(sp)
 5e4:	69e2                	ld	s3,24(sp)
 5e6:	6121                	addi	sp,sp,64
 5e8:	8082                	ret
    x = -xx;
 5ea:	40b005bb          	negw	a1,a1
    neg = 1;
 5ee:	4885                	li	a7,1
    x = -xx;
 5f0:	bf8d                	j	562 <printint+0x1a>

00000000000005f2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5f2:	7119                	addi	sp,sp,-128
 5f4:	fc86                	sd	ra,120(sp)
 5f6:	f8a2                	sd	s0,112(sp)
 5f8:	f4a6                	sd	s1,104(sp)
 5fa:	f0ca                	sd	s2,96(sp)
 5fc:	ecce                	sd	s3,88(sp)
 5fe:	e8d2                	sd	s4,80(sp)
 600:	e4d6                	sd	s5,72(sp)
 602:	e0da                	sd	s6,64(sp)
 604:	fc5e                	sd	s7,56(sp)
 606:	f862                	sd	s8,48(sp)
 608:	f466                	sd	s9,40(sp)
 60a:	f06a                	sd	s10,32(sp)
 60c:	ec6e                	sd	s11,24(sp)
 60e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 610:	0005c903          	lbu	s2,0(a1)
 614:	18090f63          	beqz	s2,7b2 <vprintf+0x1c0>
 618:	8aaa                	mv	s5,a0
 61a:	8b32                	mv	s6,a2
 61c:	00158493          	addi	s1,a1,1
  state = 0;
 620:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 622:	02500a13          	li	s4,37
      if(c == 'd'){
 626:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 62a:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 62e:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 632:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 636:	00000b97          	auipc	s7,0x0
 63a:	6eab8b93          	addi	s7,s7,1770 # d20 <digits>
 63e:	a839                	j	65c <vprintf+0x6a>
        putc(fd, c);
 640:	85ca                	mv	a1,s2
 642:	8556                	mv	a0,s5
 644:	00000097          	auipc	ra,0x0
 648:	ee2080e7          	jalr	-286(ra) # 526 <putc>
 64c:	a019                	j	652 <vprintf+0x60>
    } else if(state == '%'){
 64e:	01498f63          	beq	s3,s4,66c <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 652:	0485                	addi	s1,s1,1
 654:	fff4c903          	lbu	s2,-1(s1)
 658:	14090d63          	beqz	s2,7b2 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 65c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 660:	fe0997e3          	bnez	s3,64e <vprintf+0x5c>
      if(c == '%'){
 664:	fd479ee3          	bne	a5,s4,640 <vprintf+0x4e>
        state = '%';
 668:	89be                	mv	s3,a5
 66a:	b7e5                	j	652 <vprintf+0x60>
      if(c == 'd'){
 66c:	05878063          	beq	a5,s8,6ac <vprintf+0xba>
      } else if(c == 'l') {
 670:	05978c63          	beq	a5,s9,6c8 <vprintf+0xd6>
      } else if(c == 'x') {
 674:	07a78863          	beq	a5,s10,6e4 <vprintf+0xf2>
      } else if(c == 'p') {
 678:	09b78463          	beq	a5,s11,700 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 67c:	07300713          	li	a4,115
 680:	0ce78663          	beq	a5,a4,74c <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 684:	06300713          	li	a4,99
 688:	0ee78e63          	beq	a5,a4,784 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 68c:	11478863          	beq	a5,s4,79c <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 690:	85d2                	mv	a1,s4
 692:	8556                	mv	a0,s5
 694:	00000097          	auipc	ra,0x0
 698:	e92080e7          	jalr	-366(ra) # 526 <putc>
        putc(fd, c);
 69c:	85ca                	mv	a1,s2
 69e:	8556                	mv	a0,s5
 6a0:	00000097          	auipc	ra,0x0
 6a4:	e86080e7          	jalr	-378(ra) # 526 <putc>
      }
      state = 0;
 6a8:	4981                	li	s3,0
 6aa:	b765                	j	652 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 6ac:	008b0913          	addi	s2,s6,8
 6b0:	4685                	li	a3,1
 6b2:	4629                	li	a2,10
 6b4:	000b2583          	lw	a1,0(s6)
 6b8:	8556                	mv	a0,s5
 6ba:	00000097          	auipc	ra,0x0
 6be:	e8e080e7          	jalr	-370(ra) # 548 <printint>
 6c2:	8b4a                	mv	s6,s2
      state = 0;
 6c4:	4981                	li	s3,0
 6c6:	b771                	j	652 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c8:	008b0913          	addi	s2,s6,8
 6cc:	4681                	li	a3,0
 6ce:	4629                	li	a2,10
 6d0:	000b2583          	lw	a1,0(s6)
 6d4:	8556                	mv	a0,s5
 6d6:	00000097          	auipc	ra,0x0
 6da:	e72080e7          	jalr	-398(ra) # 548 <printint>
 6de:	8b4a                	mv	s6,s2
      state = 0;
 6e0:	4981                	li	s3,0
 6e2:	bf85                	j	652 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6e4:	008b0913          	addi	s2,s6,8
 6e8:	4681                	li	a3,0
 6ea:	4641                	li	a2,16
 6ec:	000b2583          	lw	a1,0(s6)
 6f0:	8556                	mv	a0,s5
 6f2:	00000097          	auipc	ra,0x0
 6f6:	e56080e7          	jalr	-426(ra) # 548 <printint>
 6fa:	8b4a                	mv	s6,s2
      state = 0;
 6fc:	4981                	li	s3,0
 6fe:	bf91                	j	652 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 700:	008b0793          	addi	a5,s6,8
 704:	f8f43423          	sd	a5,-120(s0)
 708:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 70c:	03000593          	li	a1,48
 710:	8556                	mv	a0,s5
 712:	00000097          	auipc	ra,0x0
 716:	e14080e7          	jalr	-492(ra) # 526 <putc>
  putc(fd, 'x');
 71a:	85ea                	mv	a1,s10
 71c:	8556                	mv	a0,s5
 71e:	00000097          	auipc	ra,0x0
 722:	e08080e7          	jalr	-504(ra) # 526 <putc>
 726:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 728:	03c9d793          	srli	a5,s3,0x3c
 72c:	97de                	add	a5,a5,s7
 72e:	0007c583          	lbu	a1,0(a5)
 732:	8556                	mv	a0,s5
 734:	00000097          	auipc	ra,0x0
 738:	df2080e7          	jalr	-526(ra) # 526 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 73c:	0992                	slli	s3,s3,0x4
 73e:	397d                	addiw	s2,s2,-1
 740:	fe0914e3          	bnez	s2,728 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 744:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 748:	4981                	li	s3,0
 74a:	b721                	j	652 <vprintf+0x60>
        s = va_arg(ap, char*);
 74c:	008b0993          	addi	s3,s6,8
 750:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 754:	02090163          	beqz	s2,776 <vprintf+0x184>
        while(*s != 0){
 758:	00094583          	lbu	a1,0(s2)
 75c:	c9a1                	beqz	a1,7ac <vprintf+0x1ba>
          putc(fd, *s);
 75e:	8556                	mv	a0,s5
 760:	00000097          	auipc	ra,0x0
 764:	dc6080e7          	jalr	-570(ra) # 526 <putc>
          s++;
 768:	0905                	addi	s2,s2,1
        while(*s != 0){
 76a:	00094583          	lbu	a1,0(s2)
 76e:	f9e5                	bnez	a1,75e <vprintf+0x16c>
        s = va_arg(ap, char*);
 770:	8b4e                	mv	s6,s3
      state = 0;
 772:	4981                	li	s3,0
 774:	bdf9                	j	652 <vprintf+0x60>
          s = "(null)";
 776:	00000917          	auipc	s2,0x0
 77a:	5a290913          	addi	s2,s2,1442 # d18 <strstr+0xa6>
        while(*s != 0){
 77e:	02800593          	li	a1,40
 782:	bff1                	j	75e <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 784:	008b0913          	addi	s2,s6,8
 788:	000b4583          	lbu	a1,0(s6)
 78c:	8556                	mv	a0,s5
 78e:	00000097          	auipc	ra,0x0
 792:	d98080e7          	jalr	-616(ra) # 526 <putc>
 796:	8b4a                	mv	s6,s2
      state = 0;
 798:	4981                	li	s3,0
 79a:	bd65                	j	652 <vprintf+0x60>
        putc(fd, c);
 79c:	85d2                	mv	a1,s4
 79e:	8556                	mv	a0,s5
 7a0:	00000097          	auipc	ra,0x0
 7a4:	d86080e7          	jalr	-634(ra) # 526 <putc>
      state = 0;
 7a8:	4981                	li	s3,0
 7aa:	b565                	j	652 <vprintf+0x60>
        s = va_arg(ap, char*);
 7ac:	8b4e                	mv	s6,s3
      state = 0;
 7ae:	4981                	li	s3,0
 7b0:	b54d                	j	652 <vprintf+0x60>
    }
  }
}
 7b2:	70e6                	ld	ra,120(sp)
 7b4:	7446                	ld	s0,112(sp)
 7b6:	74a6                	ld	s1,104(sp)
 7b8:	7906                	ld	s2,96(sp)
 7ba:	69e6                	ld	s3,88(sp)
 7bc:	6a46                	ld	s4,80(sp)
 7be:	6aa6                	ld	s5,72(sp)
 7c0:	6b06                	ld	s6,64(sp)
 7c2:	7be2                	ld	s7,56(sp)
 7c4:	7c42                	ld	s8,48(sp)
 7c6:	7ca2                	ld	s9,40(sp)
 7c8:	7d02                	ld	s10,32(sp)
 7ca:	6de2                	ld	s11,24(sp)
 7cc:	6109                	addi	sp,sp,128
 7ce:	8082                	ret

00000000000007d0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7d0:	715d                	addi	sp,sp,-80
 7d2:	ec06                	sd	ra,24(sp)
 7d4:	e822                	sd	s0,16(sp)
 7d6:	1000                	addi	s0,sp,32
 7d8:	e010                	sd	a2,0(s0)
 7da:	e414                	sd	a3,8(s0)
 7dc:	e818                	sd	a4,16(s0)
 7de:	ec1c                	sd	a5,24(s0)
 7e0:	03043023          	sd	a6,32(s0)
 7e4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7e8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7ec:	8622                	mv	a2,s0
 7ee:	00000097          	auipc	ra,0x0
 7f2:	e04080e7          	jalr	-508(ra) # 5f2 <vprintf>
}
 7f6:	60e2                	ld	ra,24(sp)
 7f8:	6442                	ld	s0,16(sp)
 7fa:	6161                	addi	sp,sp,80
 7fc:	8082                	ret

00000000000007fe <printf>:

void
printf(const char *fmt, ...)
{
 7fe:	711d                	addi	sp,sp,-96
 800:	ec06                	sd	ra,24(sp)
 802:	e822                	sd	s0,16(sp)
 804:	1000                	addi	s0,sp,32
 806:	e40c                	sd	a1,8(s0)
 808:	e810                	sd	a2,16(s0)
 80a:	ec14                	sd	a3,24(s0)
 80c:	f018                	sd	a4,32(s0)
 80e:	f41c                	sd	a5,40(s0)
 810:	03043823          	sd	a6,48(s0)
 814:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 818:	00840613          	addi	a2,s0,8
 81c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 820:	85aa                	mv	a1,a0
 822:	4505                	li	a0,1
 824:	00000097          	auipc	ra,0x0
 828:	dce080e7          	jalr	-562(ra) # 5f2 <vprintf>
}
 82c:	60e2                	ld	ra,24(sp)
 82e:	6442                	ld	s0,16(sp)
 830:	6125                	addi	sp,sp,96
 832:	8082                	ret

0000000000000834 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 834:	1141                	addi	sp,sp,-16
 836:	e422                	sd	s0,8(sp)
 838:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 83a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 83e:	00000797          	auipc	a5,0x0
 842:	59a7b783          	ld	a5,1434(a5) # dd8 <freep>
 846:	a805                	j	876 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 848:	4618                	lw	a4,8(a2)
 84a:	9db9                	addw	a1,a1,a4
 84c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 850:	6398                	ld	a4,0(a5)
 852:	6318                	ld	a4,0(a4)
 854:	fee53823          	sd	a4,-16(a0)
 858:	a091                	j	89c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 85a:	ff852703          	lw	a4,-8(a0)
 85e:	9e39                	addw	a2,a2,a4
 860:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 862:	ff053703          	ld	a4,-16(a0)
 866:	e398                	sd	a4,0(a5)
 868:	a099                	j	8ae <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 86a:	6398                	ld	a4,0(a5)
 86c:	00e7e463          	bltu	a5,a4,874 <free+0x40>
 870:	00e6ea63          	bltu	a3,a4,884 <free+0x50>
{
 874:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 876:	fed7fae3          	bgeu	a5,a3,86a <free+0x36>
 87a:	6398                	ld	a4,0(a5)
 87c:	00e6e463          	bltu	a3,a4,884 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 880:	fee7eae3          	bltu	a5,a4,874 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 884:	ff852583          	lw	a1,-8(a0)
 888:	6390                	ld	a2,0(a5)
 88a:	02059713          	slli	a4,a1,0x20
 88e:	9301                	srli	a4,a4,0x20
 890:	0712                	slli	a4,a4,0x4
 892:	9736                	add	a4,a4,a3
 894:	fae60ae3          	beq	a2,a4,848 <free+0x14>
    bp->s.ptr = p->s.ptr;
 898:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 89c:	4790                	lw	a2,8(a5)
 89e:	02061713          	slli	a4,a2,0x20
 8a2:	9301                	srli	a4,a4,0x20
 8a4:	0712                	slli	a4,a4,0x4
 8a6:	973e                	add	a4,a4,a5
 8a8:	fae689e3          	beq	a3,a4,85a <free+0x26>
  } else
    p->s.ptr = bp;
 8ac:	e394                	sd	a3,0(a5)
  freep = p;
 8ae:	00000717          	auipc	a4,0x0
 8b2:	52f73523          	sd	a5,1322(a4) # dd8 <freep>
}
 8b6:	6422                	ld	s0,8(sp)
 8b8:	0141                	addi	sp,sp,16
 8ba:	8082                	ret

00000000000008bc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8bc:	7139                	addi	sp,sp,-64
 8be:	fc06                	sd	ra,56(sp)
 8c0:	f822                	sd	s0,48(sp)
 8c2:	f426                	sd	s1,40(sp)
 8c4:	f04a                	sd	s2,32(sp)
 8c6:	ec4e                	sd	s3,24(sp)
 8c8:	e852                	sd	s4,16(sp)
 8ca:	e456                	sd	s5,8(sp)
 8cc:	e05a                	sd	s6,0(sp)
 8ce:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8d0:	02051493          	slli	s1,a0,0x20
 8d4:	9081                	srli	s1,s1,0x20
 8d6:	04bd                	addi	s1,s1,15
 8d8:	8091                	srli	s1,s1,0x4
 8da:	0014899b          	addiw	s3,s1,1
 8de:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8e0:	00000517          	auipc	a0,0x0
 8e4:	4f853503          	ld	a0,1272(a0) # dd8 <freep>
 8e8:	c515                	beqz	a0,914 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ea:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ec:	4798                	lw	a4,8(a5)
 8ee:	02977f63          	bgeu	a4,s1,92c <malloc+0x70>
 8f2:	8a4e                	mv	s4,s3
 8f4:	0009871b          	sext.w	a4,s3
 8f8:	6685                	lui	a3,0x1
 8fa:	00d77363          	bgeu	a4,a3,900 <malloc+0x44>
 8fe:	6a05                	lui	s4,0x1
 900:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 904:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 908:	00000917          	auipc	s2,0x0
 90c:	4d090913          	addi	s2,s2,1232 # dd8 <freep>
  if(p == (char*)-1)
 910:	5afd                	li	s5,-1
 912:	a88d                	j	984 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 914:	00000797          	auipc	a5,0x0
 918:	4cc78793          	addi	a5,a5,1228 # de0 <base>
 91c:	00000717          	auipc	a4,0x0
 920:	4af73e23          	sd	a5,1212(a4) # dd8 <freep>
 924:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 926:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 92a:	b7e1                	j	8f2 <malloc+0x36>
      if(p->s.size == nunits)
 92c:	02e48b63          	beq	s1,a4,962 <malloc+0xa6>
        p->s.size -= nunits;
 930:	4137073b          	subw	a4,a4,s3
 934:	c798                	sw	a4,8(a5)
        p += p->s.size;
 936:	1702                	slli	a4,a4,0x20
 938:	9301                	srli	a4,a4,0x20
 93a:	0712                	slli	a4,a4,0x4
 93c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 93e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 942:	00000717          	auipc	a4,0x0
 946:	48a73b23          	sd	a0,1174(a4) # dd8 <freep>
      return (void*)(p + 1);
 94a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 94e:	70e2                	ld	ra,56(sp)
 950:	7442                	ld	s0,48(sp)
 952:	74a2                	ld	s1,40(sp)
 954:	7902                	ld	s2,32(sp)
 956:	69e2                	ld	s3,24(sp)
 958:	6a42                	ld	s4,16(sp)
 95a:	6aa2                	ld	s5,8(sp)
 95c:	6b02                	ld	s6,0(sp)
 95e:	6121                	addi	sp,sp,64
 960:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 962:	6398                	ld	a4,0(a5)
 964:	e118                	sd	a4,0(a0)
 966:	bff1                	j	942 <malloc+0x86>
  hp->s.size = nu;
 968:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 96c:	0541                	addi	a0,a0,16
 96e:	00000097          	auipc	ra,0x0
 972:	ec6080e7          	jalr	-314(ra) # 834 <free>
  return freep;
 976:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 97a:	d971                	beqz	a0,94e <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 97c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 97e:	4798                	lw	a4,8(a5)
 980:	fa9776e3          	bgeu	a4,s1,92c <malloc+0x70>
    if(p == freep)
 984:	00093703          	ld	a4,0(s2)
 988:	853e                	mv	a0,a5
 98a:	fef719e3          	bne	a4,a5,97c <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 98e:	8552                	mv	a0,s4
 990:	00000097          	auipc	ra,0x0
 994:	b66080e7          	jalr	-1178(ra) # 4f6 <sbrk>
  if(p == (char*)-1)
 998:	fd5518e3          	bne	a0,s5,968 <malloc+0xac>
        return 0;
 99c:	4501                	li	a0,0
 99e:	bf45                	j	94e <malloc+0x92>

00000000000009a0 <Pipe>:
#include "kernel/stat.h"
#include "user.h"
#include "wrapper.h"
int strncmp(const char*s, const char*pat,int n);

int Pipe(int *p) {
 9a0:	1101                	addi	sp,sp,-32
 9a2:	ec06                	sd	ra,24(sp)
 9a4:	e822                	sd	s0,16(sp)
 9a6:	e426                	sd	s1,8(sp)
 9a8:	1000                	addi	s0,sp,32
  i32 res = pipe(p);
 9aa:	00000097          	auipc	ra,0x0
 9ae:	ad4080e7          	jalr	-1324(ra) # 47e <pipe>
 9b2:	84aa                	mv	s1,a0
  if (res < 0) {
 9b4:	00054863          	bltz	a0,9c4 <Pipe+0x24>
    fprintf(2, "pipe creation error");
  }
  return res;
}
 9b8:	8526                	mv	a0,s1
 9ba:	60e2                	ld	ra,24(sp)
 9bc:	6442                	ld	s0,16(sp)
 9be:	64a2                	ld	s1,8(sp)
 9c0:	6105                	addi	sp,sp,32
 9c2:	8082                	ret
    fprintf(2, "pipe creation error");
 9c4:	00000597          	auipc	a1,0x0
 9c8:	37458593          	addi	a1,a1,884 # d38 <digits+0x18>
 9cc:	4509                	li	a0,2
 9ce:	00000097          	auipc	ra,0x0
 9d2:	e02080e7          	jalr	-510(ra) # 7d0 <fprintf>
 9d6:	b7cd                	j	9b8 <Pipe+0x18>

00000000000009d8 <Write>:

int Write(int fd, void *buf, int count){
 9d8:	1141                	addi	sp,sp,-16
 9da:	e406                	sd	ra,8(sp)
 9dc:	e022                	sd	s0,0(sp)
 9de:	0800                	addi	s0,sp,16
  i32 res = write(fd, buf, count);
 9e0:	00000097          	auipc	ra,0x0
 9e4:	aae080e7          	jalr	-1362(ra) # 48e <write>
  if (res < 0) {
 9e8:	00054663          	bltz	a0,9f4 <Write+0x1c>
    fprintf(2, "write error");
    exit(0);
  }
  return res;
}
 9ec:	60a2                	ld	ra,8(sp)
 9ee:	6402                	ld	s0,0(sp)
 9f0:	0141                	addi	sp,sp,16
 9f2:	8082                	ret
    fprintf(2, "write error");
 9f4:	00000597          	auipc	a1,0x0
 9f8:	35c58593          	addi	a1,a1,860 # d50 <digits+0x30>
 9fc:	4509                	li	a0,2
 9fe:	00000097          	auipc	ra,0x0
 a02:	dd2080e7          	jalr	-558(ra) # 7d0 <fprintf>
    exit(0);
 a06:	4501                	li	a0,0
 a08:	00000097          	auipc	ra,0x0
 a0c:	a66080e7          	jalr	-1434(ra) # 46e <exit>

0000000000000a10 <Read>:



int Read(int fd,  void*buf, int count){
 a10:	1141                	addi	sp,sp,-16
 a12:	e406                	sd	ra,8(sp)
 a14:	e022                	sd	s0,0(sp)
 a16:	0800                	addi	s0,sp,16
  i32 res = read(fd, buf, count);
 a18:	00000097          	auipc	ra,0x0
 a1c:	a6e080e7          	jalr	-1426(ra) # 486 <read>
  if (res < 0) {
 a20:	00054663          	bltz	a0,a2c <Read+0x1c>
    fprintf(2, "read error");
    exit(0);
  }
  return res;
}
 a24:	60a2                	ld	ra,8(sp)
 a26:	6402                	ld	s0,0(sp)
 a28:	0141                	addi	sp,sp,16
 a2a:	8082                	ret
    fprintf(2, "read error");
 a2c:	00000597          	auipc	a1,0x0
 a30:	33458593          	addi	a1,a1,820 # d60 <digits+0x40>
 a34:	4509                	li	a0,2
 a36:	00000097          	auipc	ra,0x0
 a3a:	d9a080e7          	jalr	-614(ra) # 7d0 <fprintf>
    exit(0);
 a3e:	4501                	li	a0,0
 a40:	00000097          	auipc	ra,0x0
 a44:	a2e080e7          	jalr	-1490(ra) # 46e <exit>

0000000000000a48 <Open>:


int Open(const char* path, int flag){
 a48:	1141                	addi	sp,sp,-16
 a4a:	e406                	sd	ra,8(sp)
 a4c:	e022                	sd	s0,0(sp)
 a4e:	0800                	addi	s0,sp,16
  i32 res = open(path, flag);
 a50:	00000097          	auipc	ra,0x0
 a54:	a5e080e7          	jalr	-1442(ra) # 4ae <open>
  if (res < 0) {
 a58:	00054663          	bltz	a0,a64 <Open+0x1c>
    fprintf(2, "open error");
    exit(0);
  }
  return res;
}
 a5c:	60a2                	ld	ra,8(sp)
 a5e:	6402                	ld	s0,0(sp)
 a60:	0141                	addi	sp,sp,16
 a62:	8082                	ret
    fprintf(2, "open error");
 a64:	00000597          	auipc	a1,0x0
 a68:	30c58593          	addi	a1,a1,780 # d70 <digits+0x50>
 a6c:	4509                	li	a0,2
 a6e:	00000097          	auipc	ra,0x0
 a72:	d62080e7          	jalr	-670(ra) # 7d0 <fprintf>
    exit(0);
 a76:	4501                	li	a0,0
 a78:	00000097          	auipc	ra,0x0
 a7c:	9f6080e7          	jalr	-1546(ra) # 46e <exit>

0000000000000a80 <Fstat>:


int Fstat(int fd, stat_t *st){
 a80:	1141                	addi	sp,sp,-16
 a82:	e406                	sd	ra,8(sp)
 a84:	e022                	sd	s0,0(sp)
 a86:	0800                	addi	s0,sp,16
  i32 res = fstat(fd, st);
 a88:	00000097          	auipc	ra,0x0
 a8c:	a3e080e7          	jalr	-1474(ra) # 4c6 <fstat>
  if (res < 0) {
 a90:	00054663          	bltz	a0,a9c <Fstat+0x1c>
    fprintf(2, "get file stat error");
    exit(0);
  }
  return res;
}
 a94:	60a2                	ld	ra,8(sp)
 a96:	6402                	ld	s0,0(sp)
 a98:	0141                	addi	sp,sp,16
 a9a:	8082                	ret
    fprintf(2, "get file stat error");
 a9c:	00000597          	auipc	a1,0x0
 aa0:	2e458593          	addi	a1,a1,740 # d80 <digits+0x60>
 aa4:	4509                	li	a0,2
 aa6:	00000097          	auipc	ra,0x0
 aaa:	d2a080e7          	jalr	-726(ra) # 7d0 <fprintf>
    exit(0);
 aae:	4501                	li	a0,0
 ab0:	00000097          	auipc	ra,0x0
 ab4:	9be080e7          	jalr	-1602(ra) # 46e <exit>

0000000000000ab8 <Dup>:



int Dup(int fd){
 ab8:	1141                	addi	sp,sp,-16
 aba:	e406                	sd	ra,8(sp)
 abc:	e022                	sd	s0,0(sp)
 abe:	0800                	addi	s0,sp,16
  i32 res = dup(fd);
 ac0:	00000097          	auipc	ra,0x0
 ac4:	a26080e7          	jalr	-1498(ra) # 4e6 <dup>
  if (res < 0) {
 ac8:	00054663          	bltz	a0,ad4 <Dup+0x1c>
    fprintf(2, "dup error");
    exit(0);
  }
  return res;

}
 acc:	60a2                	ld	ra,8(sp)
 ace:	6402                	ld	s0,0(sp)
 ad0:	0141                	addi	sp,sp,16
 ad2:	8082                	ret
    fprintf(2, "dup error");
 ad4:	00000597          	auipc	a1,0x0
 ad8:	2c458593          	addi	a1,a1,708 # d98 <digits+0x78>
 adc:	4509                	li	a0,2
 ade:	00000097          	auipc	ra,0x0
 ae2:	cf2080e7          	jalr	-782(ra) # 7d0 <fprintf>
    exit(0);
 ae6:	4501                	li	a0,0
 ae8:	00000097          	auipc	ra,0x0
 aec:	986080e7          	jalr	-1658(ra) # 46e <exit>

0000000000000af0 <Close>:

int Close(int fd){
 af0:	1141                	addi	sp,sp,-16
 af2:	e406                	sd	ra,8(sp)
 af4:	e022                	sd	s0,0(sp)
 af6:	0800                	addi	s0,sp,16
  i32 res = close(fd);
 af8:	00000097          	auipc	ra,0x0
 afc:	99e080e7          	jalr	-1634(ra) # 496 <close>
  if (res < 0) {
 b00:	00054663          	bltz	a0,b0c <Close+0x1c>
    fprintf(2, "file close error~");
    exit(0);
  }
  return res;
}
 b04:	60a2                	ld	ra,8(sp)
 b06:	6402                	ld	s0,0(sp)
 b08:	0141                	addi	sp,sp,16
 b0a:	8082                	ret
    fprintf(2, "file close error~");
 b0c:	00000597          	auipc	a1,0x0
 b10:	29c58593          	addi	a1,a1,668 # da8 <digits+0x88>
 b14:	4509                	li	a0,2
 b16:	00000097          	auipc	ra,0x0
 b1a:	cba080e7          	jalr	-838(ra) # 7d0 <fprintf>
    exit(0);
 b1e:	4501                	li	a0,0
 b20:	00000097          	auipc	ra,0x0
 b24:	94e080e7          	jalr	-1714(ra) # 46e <exit>

0000000000000b28 <Dup2>:

int Dup2(int old_fd,int new_fd){
 b28:	1101                	addi	sp,sp,-32
 b2a:	ec06                	sd	ra,24(sp)
 b2c:	e822                	sd	s0,16(sp)
 b2e:	e426                	sd	s1,8(sp)
 b30:	1000                	addi	s0,sp,32
 b32:	84aa                	mv	s1,a0
  Close(new_fd);
 b34:	852e                	mv	a0,a1
 b36:	00000097          	auipc	ra,0x0
 b3a:	fba080e7          	jalr	-70(ra) # af0 <Close>
  i32 res = Dup(old_fd);
 b3e:	8526                	mv	a0,s1
 b40:	00000097          	auipc	ra,0x0
 b44:	f78080e7          	jalr	-136(ra) # ab8 <Dup>
  if (res < 0) {
 b48:	00054763          	bltz	a0,b56 <Dup2+0x2e>
    fprintf(2, "dup error");
    exit(0);
  }
  return res;
}
 b4c:	60e2                	ld	ra,24(sp)
 b4e:	6442                	ld	s0,16(sp)
 b50:	64a2                	ld	s1,8(sp)
 b52:	6105                	addi	sp,sp,32
 b54:	8082                	ret
    fprintf(2, "dup error");
 b56:	00000597          	auipc	a1,0x0
 b5a:	24258593          	addi	a1,a1,578 # d98 <digits+0x78>
 b5e:	4509                	li	a0,2
 b60:	00000097          	auipc	ra,0x0
 b64:	c70080e7          	jalr	-912(ra) # 7d0 <fprintf>
    exit(0);
 b68:	4501                	li	a0,0
 b6a:	00000097          	auipc	ra,0x0
 b6e:	904080e7          	jalr	-1788(ra) # 46e <exit>

0000000000000b72 <Stat>:

int Stat(const char*link,stat_t *st){
 b72:	1101                	addi	sp,sp,-32
 b74:	ec06                	sd	ra,24(sp)
 b76:	e822                	sd	s0,16(sp)
 b78:	e426                	sd	s1,8(sp)
 b7a:	1000                	addi	s0,sp,32
 b7c:	84aa                	mv	s1,a0
  i32 res = stat(link,st);
 b7e:	fffff097          	auipc	ra,0xfffff
 b82:	7ae080e7          	jalr	1966(ra) # 32c <stat>
  if (res < 0) {
 b86:	00054763          	bltz	a0,b94 <Stat+0x22>
    fprintf(2, "file %s stat error",link);
    exit(0);
  }
  return res;
}
 b8a:	60e2                	ld	ra,24(sp)
 b8c:	6442                	ld	s0,16(sp)
 b8e:	64a2                	ld	s1,8(sp)
 b90:	6105                	addi	sp,sp,32
 b92:	8082                	ret
    fprintf(2, "file %s stat error",link);
 b94:	8626                	mv	a2,s1
 b96:	00000597          	auipc	a1,0x0
 b9a:	22a58593          	addi	a1,a1,554 # dc0 <digits+0xa0>
 b9e:	4509                	li	a0,2
 ba0:	00000097          	auipc	ra,0x0
 ba4:	c30080e7          	jalr	-976(ra) # 7d0 <fprintf>
    exit(0);
 ba8:	4501                	li	a0,0
 baa:	00000097          	auipc	ra,0x0
 bae:	8c4080e7          	jalr	-1852(ra) # 46e <exit>

0000000000000bb2 <strncmp>:
   return -1;
}



int strncmp(const char*s, const char*pat,int n){
 bb2:	bc010113          	addi	sp,sp,-1088
 bb6:	42113c23          	sd	ra,1080(sp)
 bba:	42813823          	sd	s0,1072(sp)
 bbe:	42913423          	sd	s1,1064(sp)
 bc2:	43213023          	sd	s2,1056(sp)
 bc6:	41313c23          	sd	s3,1048(sp)
 bca:	41413823          	sd	s4,1040(sp)
 bce:	41513423          	sd	s5,1032(sp)
 bd2:	44010413          	addi	s0,sp,1088
 bd6:	89aa                	mv	s3,a0
 bd8:	892e                	mv	s2,a1
 bda:	84b2                	mv	s1,a2
  char buf1[512],buf2[512];
  int n1 = MIN(n,strlen(s));
 bdc:	fffff097          	auipc	ra,0xfffff
 be0:	66c080e7          	jalr	1644(ra) # 248 <strlen>
 be4:	2501                	sext.w	a0,a0
 be6:	00048a1b          	sext.w	s4,s1
 bea:	8aa6                	mv	s5,s1
 bec:	06aa7363          	bgeu	s4,a0,c52 <strncmp+0xa0>
  int n2 = MIN(n,strlen(pat));
 bf0:	854a                	mv	a0,s2
 bf2:	fffff097          	auipc	ra,0xfffff
 bf6:	656080e7          	jalr	1622(ra) # 248 <strlen>
 bfa:	2501                	sext.w	a0,a0
 bfc:	06aa7363          	bgeu	s4,a0,c62 <strncmp+0xb0>
  memmove(buf1,s,n1);
 c00:	8656                	mv	a2,s5
 c02:	85ce                	mv	a1,s3
 c04:	dc040513          	addi	a0,s0,-576
 c08:	fffff097          	auipc	ra,0xfffff
 c0c:	7b4080e7          	jalr	1972(ra) # 3bc <memmove>
  memmove(buf2,pat,n2);
 c10:	8626                	mv	a2,s1
 c12:	85ca                	mv	a1,s2
 c14:	bc040513          	addi	a0,s0,-1088
 c18:	fffff097          	auipc	ra,0xfffff
 c1c:	7a4080e7          	jalr	1956(ra) # 3bc <memmove>
  return strcmp(buf1,buf2);
 c20:	bc040593          	addi	a1,s0,-1088
 c24:	dc040513          	addi	a0,s0,-576
 c28:	fffff097          	auipc	ra,0xfffff
 c2c:	5f4080e7          	jalr	1524(ra) # 21c <strcmp>
}
 c30:	43813083          	ld	ra,1080(sp)
 c34:	43013403          	ld	s0,1072(sp)
 c38:	42813483          	ld	s1,1064(sp)
 c3c:	42013903          	ld	s2,1056(sp)
 c40:	41813983          	ld	s3,1048(sp)
 c44:	41013a03          	ld	s4,1040(sp)
 c48:	40813a83          	ld	s5,1032(sp)
 c4c:	44010113          	addi	sp,sp,1088
 c50:	8082                	ret
  int n1 = MIN(n,strlen(s));
 c52:	854e                	mv	a0,s3
 c54:	fffff097          	auipc	ra,0xfffff
 c58:	5f4080e7          	jalr	1524(ra) # 248 <strlen>
 c5c:	00050a9b          	sext.w	s5,a0
 c60:	bf41                	j	bf0 <strncmp+0x3e>
  int n2 = MIN(n,strlen(pat));
 c62:	854a                	mv	a0,s2
 c64:	fffff097          	auipc	ra,0xfffff
 c68:	5e4080e7          	jalr	1508(ra) # 248 <strlen>
 c6c:	0005049b          	sext.w	s1,a0
 c70:	bf41                	j	c00 <strncmp+0x4e>

0000000000000c72 <strstr>:
   while (*s != 0){
 c72:	00054783          	lbu	a5,0(a0)
 c76:	cba1                	beqz	a5,cc6 <strstr+0x54>
int strstr(char *s,char *p){
 c78:	7179                	addi	sp,sp,-48
 c7a:	f406                	sd	ra,40(sp)
 c7c:	f022                	sd	s0,32(sp)
 c7e:	ec26                	sd	s1,24(sp)
 c80:	e84a                	sd	s2,16(sp)
 c82:	e44e                	sd	s3,8(sp)
 c84:	1800                	addi	s0,sp,48
 c86:	89aa                	mv	s3,a0
 c88:	892e                	mv	s2,a1
   while (*s != 0){
 c8a:	84aa                	mv	s1,a0
     if (!strncmp(s,p,strlen(p)))
 c8c:	854a                	mv	a0,s2
 c8e:	fffff097          	auipc	ra,0xfffff
 c92:	5ba080e7          	jalr	1466(ra) # 248 <strlen>
 c96:	0005061b          	sext.w	a2,a0
 c9a:	85ca                	mv	a1,s2
 c9c:	8526                	mv	a0,s1
 c9e:	00000097          	auipc	ra,0x0
 ca2:	f14080e7          	jalr	-236(ra) # bb2 <strncmp>
 ca6:	c519                	beqz	a0,cb4 <strstr+0x42>
     s++;
 ca8:	0485                	addi	s1,s1,1
   while (*s != 0){
 caa:	0004c783          	lbu	a5,0(s1)
 cae:	fff9                	bnez	a5,c8c <strstr+0x1a>
   return -1;
 cb0:	557d                	li	a0,-1
 cb2:	a019                	j	cb8 <strstr+0x46>
      return s - ori;
 cb4:	4134853b          	subw	a0,s1,s3
}
 cb8:	70a2                	ld	ra,40(sp)
 cba:	7402                	ld	s0,32(sp)
 cbc:	64e2                	ld	s1,24(sp)
 cbe:	6942                	ld	s2,16(sp)
 cc0:	69a2                	ld	s3,8(sp)
 cc2:	6145                	addi	sp,sp,48
 cc4:	8082                	ret
   return -1;
 cc6:	557d                	li	a0,-1
}
 cc8:	8082                	ret
