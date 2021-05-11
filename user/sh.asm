
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  fprintf(2, "$ ");
      10:	00001597          	auipc	a1,0x1
      14:	60058593          	addi	a1,a1,1536 # 1610 <strstr+0x5a>
      18:	4509                	li	a0,2
      1a:	00001097          	auipc	ra,0x1
      1e:	0fa080e7          	jalr	250(ra) # 1114 <fprintf>
  memset(buf, 0, nbuf);
      22:	864a                	mv	a2,s2
      24:	4581                	li	a1,0
      26:	8526                	mv	a0,s1
      28:	00001097          	auipc	ra,0x1
      2c:	b9e080e7          	jalr	-1122(ra) # bc6 <memset>
  gets(buf, nbuf);
      30:	85ca                	mv	a1,s2
      32:	8526                	mv	a0,s1
      34:	00001097          	auipc	ra,0x1
      38:	bd8080e7          	jalr	-1064(ra) # c0c <gets>
  if(buf[0] == 0) // EOF
      3c:	0004c503          	lbu	a0,0(s1)
      40:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      44:	40a00533          	neg	a0,a0
      48:	60e2                	ld	ra,24(sp)
      4a:	6442                	ld	s0,16(sp)
      4c:	64a2                	ld	s1,8(sp)
      4e:	6902                	ld	s2,0(sp)
      50:	6105                	addi	sp,sp,32
      52:	8082                	ret

0000000000000054 <panic>:
  exit(0);
}

void
panic(char *s)
{
      54:	1141                	addi	sp,sp,-16
      56:	e406                	sd	ra,8(sp)
      58:	e022                	sd	s0,0(sp)
      5a:	0800                	addi	s0,sp,16
      5c:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      5e:	00001597          	auipc	a1,0x1
      62:	5ba58593          	addi	a1,a1,1466 # 1618 <strstr+0x62>
      66:	4509                	li	a0,2
      68:	00001097          	auipc	ra,0x1
      6c:	0ac080e7          	jalr	172(ra) # 1114 <fprintf>
  exit(1);
      70:	4505                	li	a0,1
      72:	00001097          	auipc	ra,0x1
      76:	d50080e7          	jalr	-688(ra) # dc2 <exit>

000000000000007a <fork1>:
}

int
fork1(void)
{
      7a:	1141                	addi	sp,sp,-16
      7c:	e406                	sd	ra,8(sp)
      7e:	e022                	sd	s0,0(sp)
      80:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
      82:	00001097          	auipc	ra,0x1
      86:	d38080e7          	jalr	-712(ra) # dba <fork>
  if(pid == -1)
      8a:	57fd                	li	a5,-1
      8c:	00f50663          	beq	a0,a5,98 <fork1+0x1e>
    panic("fork");
  return pid;
}
      90:	60a2                	ld	ra,8(sp)
      92:	6402                	ld	s0,0(sp)
      94:	0141                	addi	sp,sp,16
      96:	8082                	ret
    panic("fork");
      98:	00001517          	auipc	a0,0x1
      9c:	58850513          	addi	a0,a0,1416 # 1620 <strstr+0x6a>
      a0:	00000097          	auipc	ra,0x0
      a4:	fb4080e7          	jalr	-76(ra) # 54 <panic>

00000000000000a8 <runcmd>:
{
      a8:	7179                	addi	sp,sp,-48
      aa:	f406                	sd	ra,40(sp)
      ac:	f022                	sd	s0,32(sp)
      ae:	ec26                	sd	s1,24(sp)
      b0:	1800                	addi	s0,sp,48
  if(cmd == 0)
      b2:	c10d                	beqz	a0,d4 <runcmd+0x2c>
      b4:	84aa                	mv	s1,a0
  switch(cmd->type){
      b6:	4118                	lw	a4,0(a0)
      b8:	4795                	li	a5,5
      ba:	02e7e263          	bltu	a5,a4,de <runcmd+0x36>
      be:	00056783          	lwu	a5,0(a0)
      c2:	078a                	slli	a5,a5,0x2
      c4:	00001717          	auipc	a4,0x1
      c8:	65c70713          	addi	a4,a4,1628 # 1720 <strstr+0x16a>
      cc:	97ba                	add	a5,a5,a4
      ce:	439c                	lw	a5,0(a5)
      d0:	97ba                	add	a5,a5,a4
      d2:	8782                	jr	a5
    exit(1);
      d4:	4505                	li	a0,1
      d6:	00001097          	auipc	ra,0x1
      da:	cec080e7          	jalr	-788(ra) # dc2 <exit>
    panic("runcmd");
      de:	00001517          	auipc	a0,0x1
      e2:	54a50513          	addi	a0,a0,1354 # 1628 <strstr+0x72>
      e6:	00000097          	auipc	ra,0x0
      ea:	f6e080e7          	jalr	-146(ra) # 54 <panic>
    if(ecmd->argv[0] == 0)
      ee:	6508                	ld	a0,8(a0)
      f0:	c515                	beqz	a0,11c <runcmd+0x74>
    exec(ecmd->argv[0], ecmd->argv);
      f2:	00848593          	addi	a1,s1,8
      f6:	00001097          	auipc	ra,0x1
      fa:	d04080e7          	jalr	-764(ra) # dfa <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
      fe:	6490                	ld	a2,8(s1)
     100:	00001597          	auipc	a1,0x1
     104:	53058593          	addi	a1,a1,1328 # 1630 <strstr+0x7a>
     108:	4509                	li	a0,2
     10a:	00001097          	auipc	ra,0x1
     10e:	00a080e7          	jalr	10(ra) # 1114 <fprintf>
  exit(0);
     112:	4501                	li	a0,0
     114:	00001097          	auipc	ra,0x1
     118:	cae080e7          	jalr	-850(ra) # dc2 <exit>
      exit(1);
     11c:	4505                	li	a0,1
     11e:	00001097          	auipc	ra,0x1
     122:	ca4080e7          	jalr	-860(ra) # dc2 <exit>
    close(rcmd->fd);
     126:	5148                	lw	a0,36(a0)
     128:	00001097          	auipc	ra,0x1
     12c:	cc2080e7          	jalr	-830(ra) # dea <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     130:	508c                	lw	a1,32(s1)
     132:	6888                	ld	a0,16(s1)
     134:	00001097          	auipc	ra,0x1
     138:	cce080e7          	jalr	-818(ra) # e02 <open>
     13c:	00054763          	bltz	a0,14a <runcmd+0xa2>
    runcmd(rcmd->cmd);
     140:	6488                	ld	a0,8(s1)
     142:	00000097          	auipc	ra,0x0
     146:	f66080e7          	jalr	-154(ra) # a8 <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     14a:	6890                	ld	a2,16(s1)
     14c:	00001597          	auipc	a1,0x1
     150:	4f458593          	addi	a1,a1,1268 # 1640 <strstr+0x8a>
     154:	4509                	li	a0,2
     156:	00001097          	auipc	ra,0x1
     15a:	fbe080e7          	jalr	-66(ra) # 1114 <fprintf>
      exit(1);
     15e:	4505                	li	a0,1
     160:	00001097          	auipc	ra,0x1
     164:	c62080e7          	jalr	-926(ra) # dc2 <exit>
    if(fork1() == 0)
     168:	00000097          	auipc	ra,0x0
     16c:	f12080e7          	jalr	-238(ra) # 7a <fork1>
     170:	c919                	beqz	a0,186 <runcmd+0xde>
    wait(0);
     172:	4501                	li	a0,0
     174:	00001097          	auipc	ra,0x1
     178:	c56080e7          	jalr	-938(ra) # dca <wait>
    runcmd(lcmd->right);
     17c:	6888                	ld	a0,16(s1)
     17e:	00000097          	auipc	ra,0x0
     182:	f2a080e7          	jalr	-214(ra) # a8 <runcmd>
      runcmd(lcmd->left);
     186:	6488                	ld	a0,8(s1)
     188:	00000097          	auipc	ra,0x0
     18c:	f20080e7          	jalr	-224(ra) # a8 <runcmd>
    if(pipe(p) < 0)
     190:	fd840513          	addi	a0,s0,-40
     194:	00001097          	auipc	ra,0x1
     198:	c3e080e7          	jalr	-962(ra) # dd2 <pipe>
     19c:	04054363          	bltz	a0,1e2 <runcmd+0x13a>
    if(fork1() == 0){
     1a0:	00000097          	auipc	ra,0x0
     1a4:	eda080e7          	jalr	-294(ra) # 7a <fork1>
     1a8:	c529                	beqz	a0,1f2 <runcmd+0x14a>
    if(fork1() == 0){
     1aa:	00000097          	auipc	ra,0x0
     1ae:	ed0080e7          	jalr	-304(ra) # 7a <fork1>
     1b2:	cd25                	beqz	a0,22a <runcmd+0x182>
    close(p[0]);
     1b4:	fd842503          	lw	a0,-40(s0)
     1b8:	00001097          	auipc	ra,0x1
     1bc:	c32080e7          	jalr	-974(ra) # dea <close>
    close(p[1]);
     1c0:	fdc42503          	lw	a0,-36(s0)
     1c4:	00001097          	auipc	ra,0x1
     1c8:	c26080e7          	jalr	-986(ra) # dea <close>
    wait(0);
     1cc:	4501                	li	a0,0
     1ce:	00001097          	auipc	ra,0x1
     1d2:	bfc080e7          	jalr	-1028(ra) # dca <wait>
    wait(0);
     1d6:	4501                	li	a0,0
     1d8:	00001097          	auipc	ra,0x1
     1dc:	bf2080e7          	jalr	-1038(ra) # dca <wait>
    break;
     1e0:	bf0d                	j	112 <runcmd+0x6a>
      panic("pipe");
     1e2:	00001517          	auipc	a0,0x1
     1e6:	46e50513          	addi	a0,a0,1134 # 1650 <strstr+0x9a>
     1ea:	00000097          	auipc	ra,0x0
     1ee:	e6a080e7          	jalr	-406(ra) # 54 <panic>
      close(1);
     1f2:	4505                	li	a0,1
     1f4:	00001097          	auipc	ra,0x1
     1f8:	bf6080e7          	jalr	-1034(ra) # dea <close>
      dup(p[1]);
     1fc:	fdc42503          	lw	a0,-36(s0)
     200:	00001097          	auipc	ra,0x1
     204:	c3a080e7          	jalr	-966(ra) # e3a <dup>
      close(p[0]);
     208:	fd842503          	lw	a0,-40(s0)
     20c:	00001097          	auipc	ra,0x1
     210:	bde080e7          	jalr	-1058(ra) # dea <close>
      close(p[1]);
     214:	fdc42503          	lw	a0,-36(s0)
     218:	00001097          	auipc	ra,0x1
     21c:	bd2080e7          	jalr	-1070(ra) # dea <close>
      runcmd(pcmd->left);
     220:	6488                	ld	a0,8(s1)
     222:	00000097          	auipc	ra,0x0
     226:	e86080e7          	jalr	-378(ra) # a8 <runcmd>
      close(0);
     22a:	00001097          	auipc	ra,0x1
     22e:	bc0080e7          	jalr	-1088(ra) # dea <close>
      dup(p[0]);
     232:	fd842503          	lw	a0,-40(s0)
     236:	00001097          	auipc	ra,0x1
     23a:	c04080e7          	jalr	-1020(ra) # e3a <dup>
      close(p[0]);
     23e:	fd842503          	lw	a0,-40(s0)
     242:	00001097          	auipc	ra,0x1
     246:	ba8080e7          	jalr	-1112(ra) # dea <close>
      close(p[1]);
     24a:	fdc42503          	lw	a0,-36(s0)
     24e:	00001097          	auipc	ra,0x1
     252:	b9c080e7          	jalr	-1124(ra) # dea <close>
      runcmd(pcmd->right);
     256:	6888                	ld	a0,16(s1)
     258:	00000097          	auipc	ra,0x0
     25c:	e50080e7          	jalr	-432(ra) # a8 <runcmd>
    if(fork1() == 0)
     260:	00000097          	auipc	ra,0x0
     264:	e1a080e7          	jalr	-486(ra) # 7a <fork1>
     268:	ea0515e3          	bnez	a0,112 <runcmd+0x6a>
      runcmd(bcmd->cmd);
     26c:	6488                	ld	a0,8(s1)
     26e:	00000097          	auipc	ra,0x0
     272:	e3a080e7          	jalr	-454(ra) # a8 <runcmd>

0000000000000276 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     276:	1101                	addi	sp,sp,-32
     278:	ec06                	sd	ra,24(sp)
     27a:	e822                	sd	s0,16(sp)
     27c:	e426                	sd	s1,8(sp)
     27e:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     280:	0a800513          	li	a0,168
     284:	00001097          	auipc	ra,0x1
     288:	f7c080e7          	jalr	-132(ra) # 1200 <malloc>
     28c:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     28e:	0a800613          	li	a2,168
     292:	4581                	li	a1,0
     294:	00001097          	auipc	ra,0x1
     298:	932080e7          	jalr	-1742(ra) # bc6 <memset>
  cmd->type = EXEC;
     29c:	4785                	li	a5,1
     29e:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     2a0:	8526                	mv	a0,s1
     2a2:	60e2                	ld	ra,24(sp)
     2a4:	6442                	ld	s0,16(sp)
     2a6:	64a2                	ld	s1,8(sp)
     2a8:	6105                	addi	sp,sp,32
     2aa:	8082                	ret

00000000000002ac <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     2ac:	7139                	addi	sp,sp,-64
     2ae:	fc06                	sd	ra,56(sp)
     2b0:	f822                	sd	s0,48(sp)
     2b2:	f426                	sd	s1,40(sp)
     2b4:	f04a                	sd	s2,32(sp)
     2b6:	ec4e                	sd	s3,24(sp)
     2b8:	e852                	sd	s4,16(sp)
     2ba:	e456                	sd	s5,8(sp)
     2bc:	e05a                	sd	s6,0(sp)
     2be:	0080                	addi	s0,sp,64
     2c0:	8b2a                	mv	s6,a0
     2c2:	8aae                	mv	s5,a1
     2c4:	8a32                	mv	s4,a2
     2c6:	89b6                	mv	s3,a3
     2c8:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2ca:	02800513          	li	a0,40
     2ce:	00001097          	auipc	ra,0x1
     2d2:	f32080e7          	jalr	-206(ra) # 1200 <malloc>
     2d6:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2d8:	02800613          	li	a2,40
     2dc:	4581                	li	a1,0
     2de:	00001097          	auipc	ra,0x1
     2e2:	8e8080e7          	jalr	-1816(ra) # bc6 <memset>
  cmd->type = REDIR;
     2e6:	4789                	li	a5,2
     2e8:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     2ea:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     2ee:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     2f2:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     2f6:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     2fa:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     2fe:	8526                	mv	a0,s1
     300:	70e2                	ld	ra,56(sp)
     302:	7442                	ld	s0,48(sp)
     304:	74a2                	ld	s1,40(sp)
     306:	7902                	ld	s2,32(sp)
     308:	69e2                	ld	s3,24(sp)
     30a:	6a42                	ld	s4,16(sp)
     30c:	6aa2                	ld	s5,8(sp)
     30e:	6b02                	ld	s6,0(sp)
     310:	6121                	addi	sp,sp,64
     312:	8082                	ret

0000000000000314 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     314:	7179                	addi	sp,sp,-48
     316:	f406                	sd	ra,40(sp)
     318:	f022                	sd	s0,32(sp)
     31a:	ec26                	sd	s1,24(sp)
     31c:	e84a                	sd	s2,16(sp)
     31e:	e44e                	sd	s3,8(sp)
     320:	1800                	addi	s0,sp,48
     322:	89aa                	mv	s3,a0
     324:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     326:	4561                	li	a0,24
     328:	00001097          	auipc	ra,0x1
     32c:	ed8080e7          	jalr	-296(ra) # 1200 <malloc>
     330:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     332:	4661                	li	a2,24
     334:	4581                	li	a1,0
     336:	00001097          	auipc	ra,0x1
     33a:	890080e7          	jalr	-1904(ra) # bc6 <memset>
  cmd->type = PIPE;
     33e:	478d                	li	a5,3
     340:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     342:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     346:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     34a:	8526                	mv	a0,s1
     34c:	70a2                	ld	ra,40(sp)
     34e:	7402                	ld	s0,32(sp)
     350:	64e2                	ld	s1,24(sp)
     352:	6942                	ld	s2,16(sp)
     354:	69a2                	ld	s3,8(sp)
     356:	6145                	addi	sp,sp,48
     358:	8082                	ret

000000000000035a <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     35a:	7179                	addi	sp,sp,-48
     35c:	f406                	sd	ra,40(sp)
     35e:	f022                	sd	s0,32(sp)
     360:	ec26                	sd	s1,24(sp)
     362:	e84a                	sd	s2,16(sp)
     364:	e44e                	sd	s3,8(sp)
     366:	1800                	addi	s0,sp,48
     368:	89aa                	mv	s3,a0
     36a:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     36c:	4561                	li	a0,24
     36e:	00001097          	auipc	ra,0x1
     372:	e92080e7          	jalr	-366(ra) # 1200 <malloc>
     376:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     378:	4661                	li	a2,24
     37a:	4581                	li	a1,0
     37c:	00001097          	auipc	ra,0x1
     380:	84a080e7          	jalr	-1974(ra) # bc6 <memset>
  cmd->type = LIST;
     384:	4791                	li	a5,4
     386:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     388:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     38c:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     390:	8526                	mv	a0,s1
     392:	70a2                	ld	ra,40(sp)
     394:	7402                	ld	s0,32(sp)
     396:	64e2                	ld	s1,24(sp)
     398:	6942                	ld	s2,16(sp)
     39a:	69a2                	ld	s3,8(sp)
     39c:	6145                	addi	sp,sp,48
     39e:	8082                	ret

00000000000003a0 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     3a0:	1101                	addi	sp,sp,-32
     3a2:	ec06                	sd	ra,24(sp)
     3a4:	e822                	sd	s0,16(sp)
     3a6:	e426                	sd	s1,8(sp)
     3a8:	e04a                	sd	s2,0(sp)
     3aa:	1000                	addi	s0,sp,32
     3ac:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3ae:	4541                	li	a0,16
     3b0:	00001097          	auipc	ra,0x1
     3b4:	e50080e7          	jalr	-432(ra) # 1200 <malloc>
     3b8:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     3ba:	4641                	li	a2,16
     3bc:	4581                	li	a1,0
     3be:	00001097          	auipc	ra,0x1
     3c2:	808080e7          	jalr	-2040(ra) # bc6 <memset>
  cmd->type = BACK;
     3c6:	4795                	li	a5,5
     3c8:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     3ca:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     3ce:	8526                	mv	a0,s1
     3d0:	60e2                	ld	ra,24(sp)
     3d2:	6442                	ld	s0,16(sp)
     3d4:	64a2                	ld	s1,8(sp)
     3d6:	6902                	ld	s2,0(sp)
     3d8:	6105                	addi	sp,sp,32
     3da:	8082                	ret

00000000000003dc <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     3dc:	7139                	addi	sp,sp,-64
     3de:	fc06                	sd	ra,56(sp)
     3e0:	f822                	sd	s0,48(sp)
     3e2:	f426                	sd	s1,40(sp)
     3e4:	f04a                	sd	s2,32(sp)
     3e6:	ec4e                	sd	s3,24(sp)
     3e8:	e852                	sd	s4,16(sp)
     3ea:	e456                	sd	s5,8(sp)
     3ec:	e05a                	sd	s6,0(sp)
     3ee:	0080                	addi	s0,sp,64
     3f0:	8a2a                	mv	s4,a0
     3f2:	892e                	mv	s2,a1
     3f4:	8ab2                	mv	s5,a2
     3f6:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     3f8:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     3fa:	00001997          	auipc	s3,0x1
     3fe:	41e98993          	addi	s3,s3,1054 # 1818 <whitespace>
     402:	00b4fd63          	bgeu	s1,a1,41c <gettoken+0x40>
     406:	0004c583          	lbu	a1,0(s1)
     40a:	854e                	mv	a0,s3
     40c:	00000097          	auipc	ra,0x0
     410:	7dc080e7          	jalr	2012(ra) # be8 <strchr>
     414:	c501                	beqz	a0,41c <gettoken+0x40>
    s++;
     416:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     418:	fe9917e3          	bne	s2,s1,406 <gettoken+0x2a>
  if(q)
     41c:	000a8463          	beqz	s5,424 <gettoken+0x48>
    *q = s;
     420:	009ab023          	sd	s1,0(s5)
  ret = *s;
     424:	0004c783          	lbu	a5,0(s1)
     428:	00078a9b          	sext.w	s5,a5
  switch(*s){
     42c:	03c00713          	li	a4,60
     430:	06f76563          	bltu	a4,a5,49a <gettoken+0xbe>
     434:	03a00713          	li	a4,58
     438:	00f76e63          	bltu	a4,a5,454 <gettoken+0x78>
     43c:	cf89                	beqz	a5,456 <gettoken+0x7a>
     43e:	02600713          	li	a4,38
     442:	00e78963          	beq	a5,a4,454 <gettoken+0x78>
     446:	fd87879b          	addiw	a5,a5,-40
     44a:	0ff7f793          	andi	a5,a5,255
     44e:	4705                	li	a4,1
     450:	06f76c63          	bltu	a4,a5,4c8 <gettoken+0xec>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     454:	0485                	addi	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     456:	000b0463          	beqz	s6,45e <gettoken+0x82>
    *eq = s;
     45a:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     45e:	00001997          	auipc	s3,0x1
     462:	3ba98993          	addi	s3,s3,954 # 1818 <whitespace>
     466:	0124fd63          	bgeu	s1,s2,480 <gettoken+0xa4>
     46a:	0004c583          	lbu	a1,0(s1)
     46e:	854e                	mv	a0,s3
     470:	00000097          	auipc	ra,0x0
     474:	778080e7          	jalr	1912(ra) # be8 <strchr>
     478:	c501                	beqz	a0,480 <gettoken+0xa4>
    s++;
     47a:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     47c:	fe9917e3          	bne	s2,s1,46a <gettoken+0x8e>
  *ps = s;
     480:	009a3023          	sd	s1,0(s4)
  return ret;
}
     484:	8556                	mv	a0,s5
     486:	70e2                	ld	ra,56(sp)
     488:	7442                	ld	s0,48(sp)
     48a:	74a2                	ld	s1,40(sp)
     48c:	7902                	ld	s2,32(sp)
     48e:	69e2                	ld	s3,24(sp)
     490:	6a42                	ld	s4,16(sp)
     492:	6aa2                	ld	s5,8(sp)
     494:	6b02                	ld	s6,0(sp)
     496:	6121                	addi	sp,sp,64
     498:	8082                	ret
  switch(*s){
     49a:	03e00713          	li	a4,62
     49e:	02e79163          	bne	a5,a4,4c0 <gettoken+0xe4>
    s++;
     4a2:	00148693          	addi	a3,s1,1
    if(*s == '>'){
     4a6:	0014c703          	lbu	a4,1(s1)
     4aa:	03e00793          	li	a5,62
      s++;
     4ae:	0489                	addi	s1,s1,2
      ret = '+';
     4b0:	02b00a93          	li	s5,43
    if(*s == '>'){
     4b4:	faf701e3          	beq	a4,a5,456 <gettoken+0x7a>
    s++;
     4b8:	84b6                	mv	s1,a3
  ret = *s;
     4ba:	03e00a93          	li	s5,62
     4be:	bf61                	j	456 <gettoken+0x7a>
  switch(*s){
     4c0:	07c00713          	li	a4,124
     4c4:	f8e788e3          	beq	a5,a4,454 <gettoken+0x78>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     4c8:	00001997          	auipc	s3,0x1
     4cc:	35098993          	addi	s3,s3,848 # 1818 <whitespace>
     4d0:	00001a97          	auipc	s5,0x1
     4d4:	340a8a93          	addi	s5,s5,832 # 1810 <symbols>
     4d8:	0324f563          	bgeu	s1,s2,502 <gettoken+0x126>
     4dc:	0004c583          	lbu	a1,0(s1)
     4e0:	854e                	mv	a0,s3
     4e2:	00000097          	auipc	ra,0x0
     4e6:	706080e7          	jalr	1798(ra) # be8 <strchr>
     4ea:	e505                	bnez	a0,512 <gettoken+0x136>
     4ec:	0004c583          	lbu	a1,0(s1)
     4f0:	8556                	mv	a0,s5
     4f2:	00000097          	auipc	ra,0x0
     4f6:	6f6080e7          	jalr	1782(ra) # be8 <strchr>
     4fa:	e909                	bnez	a0,50c <gettoken+0x130>
      s++;
     4fc:	0485                	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     4fe:	fc991fe3          	bne	s2,s1,4dc <gettoken+0x100>
  if(eq)
     502:	06100a93          	li	s5,97
     506:	f40b1ae3          	bnez	s6,45a <gettoken+0x7e>
     50a:	bf9d                	j	480 <gettoken+0xa4>
    ret = 'a';
     50c:	06100a93          	li	s5,97
     510:	b799                	j	456 <gettoken+0x7a>
     512:	06100a93          	li	s5,97
     516:	b781                	j	456 <gettoken+0x7a>

0000000000000518 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     518:	7139                	addi	sp,sp,-64
     51a:	fc06                	sd	ra,56(sp)
     51c:	f822                	sd	s0,48(sp)
     51e:	f426                	sd	s1,40(sp)
     520:	f04a                	sd	s2,32(sp)
     522:	ec4e                	sd	s3,24(sp)
     524:	e852                	sd	s4,16(sp)
     526:	e456                	sd	s5,8(sp)
     528:	0080                	addi	s0,sp,64
     52a:	8a2a                	mv	s4,a0
     52c:	892e                	mv	s2,a1
     52e:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     530:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     532:	00001997          	auipc	s3,0x1
     536:	2e698993          	addi	s3,s3,742 # 1818 <whitespace>
     53a:	00b4fd63          	bgeu	s1,a1,554 <peek+0x3c>
     53e:	0004c583          	lbu	a1,0(s1)
     542:	854e                	mv	a0,s3
     544:	00000097          	auipc	ra,0x0
     548:	6a4080e7          	jalr	1700(ra) # be8 <strchr>
     54c:	c501                	beqz	a0,554 <peek+0x3c>
    s++;
     54e:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     550:	fe9917e3          	bne	s2,s1,53e <peek+0x26>
  *ps = s;
     554:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     558:	0004c583          	lbu	a1,0(s1)
     55c:	4501                	li	a0,0
     55e:	e991                	bnez	a1,572 <peek+0x5a>
}
     560:	70e2                	ld	ra,56(sp)
     562:	7442                	ld	s0,48(sp)
     564:	74a2                	ld	s1,40(sp)
     566:	7902                	ld	s2,32(sp)
     568:	69e2                	ld	s3,24(sp)
     56a:	6a42                	ld	s4,16(sp)
     56c:	6aa2                	ld	s5,8(sp)
     56e:	6121                	addi	sp,sp,64
     570:	8082                	ret
  return *s && strchr(toks, *s);
     572:	8556                	mv	a0,s5
     574:	00000097          	auipc	ra,0x0
     578:	674080e7          	jalr	1652(ra) # be8 <strchr>
     57c:	00a03533          	snez	a0,a0
     580:	b7c5                	j	560 <peek+0x48>

0000000000000582 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     582:	7159                	addi	sp,sp,-112
     584:	f486                	sd	ra,104(sp)
     586:	f0a2                	sd	s0,96(sp)
     588:	eca6                	sd	s1,88(sp)
     58a:	e8ca                	sd	s2,80(sp)
     58c:	e4ce                	sd	s3,72(sp)
     58e:	e0d2                	sd	s4,64(sp)
     590:	fc56                	sd	s5,56(sp)
     592:	f85a                	sd	s6,48(sp)
     594:	f45e                	sd	s7,40(sp)
     596:	f062                	sd	s8,32(sp)
     598:	ec66                	sd	s9,24(sp)
     59a:	1880                	addi	s0,sp,112
     59c:	8a2a                	mv	s4,a0
     59e:	89ae                	mv	s3,a1
     5a0:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     5a2:	00001b97          	auipc	s7,0x1
     5a6:	0d6b8b93          	addi	s7,s7,214 # 1678 <strstr+0xc2>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     5aa:	06100c13          	li	s8,97
      panic("missing file for redirection");
    switch(tok){
     5ae:	03c00c93          	li	s9,60
  while(peek(ps, es, "<>")){
     5b2:	a02d                	j	5dc <parseredirs+0x5a>
      panic("missing file for redirection");
     5b4:	00001517          	auipc	a0,0x1
     5b8:	0a450513          	addi	a0,a0,164 # 1658 <strstr+0xa2>
     5bc:	00000097          	auipc	ra,0x0
     5c0:	a98080e7          	jalr	-1384(ra) # 54 <panic>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     5c4:	4701                	li	a4,0
     5c6:	4681                	li	a3,0
     5c8:	f9043603          	ld	a2,-112(s0)
     5cc:	f9843583          	ld	a1,-104(s0)
     5d0:	8552                	mv	a0,s4
     5d2:	00000097          	auipc	ra,0x0
     5d6:	cda080e7          	jalr	-806(ra) # 2ac <redircmd>
     5da:	8a2a                	mv	s4,a0
    switch(tok){
     5dc:	03e00b13          	li	s6,62
     5e0:	02b00a93          	li	s5,43
  while(peek(ps, es, "<>")){
     5e4:	865e                	mv	a2,s7
     5e6:	85ca                	mv	a1,s2
     5e8:	854e                	mv	a0,s3
     5ea:	00000097          	auipc	ra,0x0
     5ee:	f2e080e7          	jalr	-210(ra) # 518 <peek>
     5f2:	c925                	beqz	a0,662 <parseredirs+0xe0>
    tok = gettoken(ps, es, 0, 0);
     5f4:	4681                	li	a3,0
     5f6:	4601                	li	a2,0
     5f8:	85ca                	mv	a1,s2
     5fa:	854e                	mv	a0,s3
     5fc:	00000097          	auipc	ra,0x0
     600:	de0080e7          	jalr	-544(ra) # 3dc <gettoken>
     604:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     606:	f9040693          	addi	a3,s0,-112
     60a:	f9840613          	addi	a2,s0,-104
     60e:	85ca                	mv	a1,s2
     610:	854e                	mv	a0,s3
     612:	00000097          	auipc	ra,0x0
     616:	dca080e7          	jalr	-566(ra) # 3dc <gettoken>
     61a:	f9851de3          	bne	a0,s8,5b4 <parseredirs+0x32>
    switch(tok){
     61e:	fb9483e3          	beq	s1,s9,5c4 <parseredirs+0x42>
     622:	03648263          	beq	s1,s6,646 <parseredirs+0xc4>
     626:	fb549fe3          	bne	s1,s5,5e4 <parseredirs+0x62>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     62a:	4705                	li	a4,1
     62c:	20100693          	li	a3,513
     630:	f9043603          	ld	a2,-112(s0)
     634:	f9843583          	ld	a1,-104(s0)
     638:	8552                	mv	a0,s4
     63a:	00000097          	auipc	ra,0x0
     63e:	c72080e7          	jalr	-910(ra) # 2ac <redircmd>
     642:	8a2a                	mv	s4,a0
      break;
     644:	bf61                	j	5dc <parseredirs+0x5a>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     646:	4705                	li	a4,1
     648:	60100693          	li	a3,1537
     64c:	f9043603          	ld	a2,-112(s0)
     650:	f9843583          	ld	a1,-104(s0)
     654:	8552                	mv	a0,s4
     656:	00000097          	auipc	ra,0x0
     65a:	c56080e7          	jalr	-938(ra) # 2ac <redircmd>
     65e:	8a2a                	mv	s4,a0
      break;
     660:	bfb5                	j	5dc <parseredirs+0x5a>
    }
  }
  return cmd;
}
     662:	8552                	mv	a0,s4
     664:	70a6                	ld	ra,104(sp)
     666:	7406                	ld	s0,96(sp)
     668:	64e6                	ld	s1,88(sp)
     66a:	6946                	ld	s2,80(sp)
     66c:	69a6                	ld	s3,72(sp)
     66e:	6a06                	ld	s4,64(sp)
     670:	7ae2                	ld	s5,56(sp)
     672:	7b42                	ld	s6,48(sp)
     674:	7ba2                	ld	s7,40(sp)
     676:	7c02                	ld	s8,32(sp)
     678:	6ce2                	ld	s9,24(sp)
     67a:	6165                	addi	sp,sp,112
     67c:	8082                	ret

000000000000067e <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     67e:	7159                	addi	sp,sp,-112
     680:	f486                	sd	ra,104(sp)
     682:	f0a2                	sd	s0,96(sp)
     684:	eca6                	sd	s1,88(sp)
     686:	e8ca                	sd	s2,80(sp)
     688:	e4ce                	sd	s3,72(sp)
     68a:	e0d2                	sd	s4,64(sp)
     68c:	fc56                	sd	s5,56(sp)
     68e:	f85a                	sd	s6,48(sp)
     690:	f45e                	sd	s7,40(sp)
     692:	f062                	sd	s8,32(sp)
     694:	ec66                	sd	s9,24(sp)
     696:	1880                	addi	s0,sp,112
     698:	8a2a                	mv	s4,a0
     69a:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     69c:	00001617          	auipc	a2,0x1
     6a0:	fe460613          	addi	a2,a2,-28 # 1680 <strstr+0xca>
     6a4:	00000097          	auipc	ra,0x0
     6a8:	e74080e7          	jalr	-396(ra) # 518 <peek>
     6ac:	e905                	bnez	a0,6dc <parseexec+0x5e>
     6ae:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     6b0:	00000097          	auipc	ra,0x0
     6b4:	bc6080e7          	jalr	-1082(ra) # 276 <execcmd>
     6b8:	8c2a                	mv	s8,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     6ba:	8656                	mv	a2,s5
     6bc:	85d2                	mv	a1,s4
     6be:	00000097          	auipc	ra,0x0
     6c2:	ec4080e7          	jalr	-316(ra) # 582 <parseredirs>
     6c6:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     6c8:	008c0913          	addi	s2,s8,8
     6cc:	00001b17          	auipc	s6,0x1
     6d0:	fd4b0b13          	addi	s6,s6,-44 # 16a0 <strstr+0xea>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
     6d4:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     6d8:	4ba9                	li	s7,10
  while(!peek(ps, es, "|)&;")){
     6da:	a0b1                	j	726 <parseexec+0xa8>
    return parseblock(ps, es);
     6dc:	85d6                	mv	a1,s5
     6de:	8552                	mv	a0,s4
     6e0:	00000097          	auipc	ra,0x0
     6e4:	1bc080e7          	jalr	444(ra) # 89c <parseblock>
     6e8:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     6ea:	8526                	mv	a0,s1
     6ec:	70a6                	ld	ra,104(sp)
     6ee:	7406                	ld	s0,96(sp)
     6f0:	64e6                	ld	s1,88(sp)
     6f2:	6946                	ld	s2,80(sp)
     6f4:	69a6                	ld	s3,72(sp)
     6f6:	6a06                	ld	s4,64(sp)
     6f8:	7ae2                	ld	s5,56(sp)
     6fa:	7b42                	ld	s6,48(sp)
     6fc:	7ba2                	ld	s7,40(sp)
     6fe:	7c02                	ld	s8,32(sp)
     700:	6ce2                	ld	s9,24(sp)
     702:	6165                	addi	sp,sp,112
     704:	8082                	ret
      panic("syntax");
     706:	00001517          	auipc	a0,0x1
     70a:	f8250513          	addi	a0,a0,-126 # 1688 <strstr+0xd2>
     70e:	00000097          	auipc	ra,0x0
     712:	946080e7          	jalr	-1722(ra) # 54 <panic>
    ret = parseredirs(ret, ps, es);
     716:	8656                	mv	a2,s5
     718:	85d2                	mv	a1,s4
     71a:	8526                	mv	a0,s1
     71c:	00000097          	auipc	ra,0x0
     720:	e66080e7          	jalr	-410(ra) # 582 <parseredirs>
     724:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     726:	865a                	mv	a2,s6
     728:	85d6                	mv	a1,s5
     72a:	8552                	mv	a0,s4
     72c:	00000097          	auipc	ra,0x0
     730:	dec080e7          	jalr	-532(ra) # 518 <peek>
     734:	e131                	bnez	a0,778 <parseexec+0xfa>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     736:	f9040693          	addi	a3,s0,-112
     73a:	f9840613          	addi	a2,s0,-104
     73e:	85d6                	mv	a1,s5
     740:	8552                	mv	a0,s4
     742:	00000097          	auipc	ra,0x0
     746:	c9a080e7          	jalr	-870(ra) # 3dc <gettoken>
     74a:	c51d                	beqz	a0,778 <parseexec+0xfa>
    if(tok != 'a')
     74c:	fb951de3          	bne	a0,s9,706 <parseexec+0x88>
    cmd->argv[argc] = q;
     750:	f9843783          	ld	a5,-104(s0)
     754:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     758:	f9043783          	ld	a5,-112(s0)
     75c:	04f93823          	sd	a5,80(s2)
    argc++;
     760:	2985                	addiw	s3,s3,1
    if(argc >= MAXARGS)
     762:	0921                	addi	s2,s2,8
     764:	fb7999e3          	bne	s3,s7,716 <parseexec+0x98>
      panic("too many args");
     768:	00001517          	auipc	a0,0x1
     76c:	f2850513          	addi	a0,a0,-216 # 1690 <strstr+0xda>
     770:	00000097          	auipc	ra,0x0
     774:	8e4080e7          	jalr	-1820(ra) # 54 <panic>
  cmd->argv[argc] = 0;
     778:	098e                	slli	s3,s3,0x3
     77a:	99e2                	add	s3,s3,s8
     77c:	0009b423          	sd	zero,8(s3)
  cmd->eargv[argc] = 0;
     780:	0409bc23          	sd	zero,88(s3)
  return ret;
     784:	b79d                	j	6ea <parseexec+0x6c>

0000000000000786 <parsepipe>:
{
     786:	7179                	addi	sp,sp,-48
     788:	f406                	sd	ra,40(sp)
     78a:	f022                	sd	s0,32(sp)
     78c:	ec26                	sd	s1,24(sp)
     78e:	e84a                	sd	s2,16(sp)
     790:	e44e                	sd	s3,8(sp)
     792:	1800                	addi	s0,sp,48
     794:	892a                	mv	s2,a0
     796:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     798:	00000097          	auipc	ra,0x0
     79c:	ee6080e7          	jalr	-282(ra) # 67e <parseexec>
     7a0:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
     7a2:	00001617          	auipc	a2,0x1
     7a6:	f0660613          	addi	a2,a2,-250 # 16a8 <strstr+0xf2>
     7aa:	85ce                	mv	a1,s3
     7ac:	854a                	mv	a0,s2
     7ae:	00000097          	auipc	ra,0x0
     7b2:	d6a080e7          	jalr	-662(ra) # 518 <peek>
     7b6:	e909                	bnez	a0,7c8 <parsepipe+0x42>
}
     7b8:	8526                	mv	a0,s1
     7ba:	70a2                	ld	ra,40(sp)
     7bc:	7402                	ld	s0,32(sp)
     7be:	64e2                	ld	s1,24(sp)
     7c0:	6942                	ld	s2,16(sp)
     7c2:	69a2                	ld	s3,8(sp)
     7c4:	6145                	addi	sp,sp,48
     7c6:	8082                	ret
    gettoken(ps, es, 0, 0);
     7c8:	4681                	li	a3,0
     7ca:	4601                	li	a2,0
     7cc:	85ce                	mv	a1,s3
     7ce:	854a                	mv	a0,s2
     7d0:	00000097          	auipc	ra,0x0
     7d4:	c0c080e7          	jalr	-1012(ra) # 3dc <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     7d8:	85ce                	mv	a1,s3
     7da:	854a                	mv	a0,s2
     7dc:	00000097          	auipc	ra,0x0
     7e0:	faa080e7          	jalr	-86(ra) # 786 <parsepipe>
     7e4:	85aa                	mv	a1,a0
     7e6:	8526                	mv	a0,s1
     7e8:	00000097          	auipc	ra,0x0
     7ec:	b2c080e7          	jalr	-1236(ra) # 314 <pipecmd>
     7f0:	84aa                	mv	s1,a0
  return cmd;
     7f2:	b7d9                	j	7b8 <parsepipe+0x32>

00000000000007f4 <parseline>:
{
     7f4:	7179                	addi	sp,sp,-48
     7f6:	f406                	sd	ra,40(sp)
     7f8:	f022                	sd	s0,32(sp)
     7fa:	ec26                	sd	s1,24(sp)
     7fc:	e84a                	sd	s2,16(sp)
     7fe:	e44e                	sd	s3,8(sp)
     800:	e052                	sd	s4,0(sp)
     802:	1800                	addi	s0,sp,48
     804:	892a                	mv	s2,a0
     806:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     808:	00000097          	auipc	ra,0x0
     80c:	f7e080e7          	jalr	-130(ra) # 786 <parsepipe>
     810:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     812:	00001a17          	auipc	s4,0x1
     816:	e9ea0a13          	addi	s4,s4,-354 # 16b0 <strstr+0xfa>
     81a:	a839                	j	838 <parseline+0x44>
    gettoken(ps, es, 0, 0);
     81c:	4681                	li	a3,0
     81e:	4601                	li	a2,0
     820:	85ce                	mv	a1,s3
     822:	854a                	mv	a0,s2
     824:	00000097          	auipc	ra,0x0
     828:	bb8080e7          	jalr	-1096(ra) # 3dc <gettoken>
    cmd = backcmd(cmd);
     82c:	8526                	mv	a0,s1
     82e:	00000097          	auipc	ra,0x0
     832:	b72080e7          	jalr	-1166(ra) # 3a0 <backcmd>
     836:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     838:	8652                	mv	a2,s4
     83a:	85ce                	mv	a1,s3
     83c:	854a                	mv	a0,s2
     83e:	00000097          	auipc	ra,0x0
     842:	cda080e7          	jalr	-806(ra) # 518 <peek>
     846:	f979                	bnez	a0,81c <parseline+0x28>
  if(peek(ps, es, ";")){
     848:	00001617          	auipc	a2,0x1
     84c:	e7060613          	addi	a2,a2,-400 # 16b8 <strstr+0x102>
     850:	85ce                	mv	a1,s3
     852:	854a                	mv	a0,s2
     854:	00000097          	auipc	ra,0x0
     858:	cc4080e7          	jalr	-828(ra) # 518 <peek>
     85c:	e911                	bnez	a0,870 <parseline+0x7c>
}
     85e:	8526                	mv	a0,s1
     860:	70a2                	ld	ra,40(sp)
     862:	7402                	ld	s0,32(sp)
     864:	64e2                	ld	s1,24(sp)
     866:	6942                	ld	s2,16(sp)
     868:	69a2                	ld	s3,8(sp)
     86a:	6a02                	ld	s4,0(sp)
     86c:	6145                	addi	sp,sp,48
     86e:	8082                	ret
    gettoken(ps, es, 0, 0);
     870:	4681                	li	a3,0
     872:	4601                	li	a2,0
     874:	85ce                	mv	a1,s3
     876:	854a                	mv	a0,s2
     878:	00000097          	auipc	ra,0x0
     87c:	b64080e7          	jalr	-1180(ra) # 3dc <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     880:	85ce                	mv	a1,s3
     882:	854a                	mv	a0,s2
     884:	00000097          	auipc	ra,0x0
     888:	f70080e7          	jalr	-144(ra) # 7f4 <parseline>
     88c:	85aa                	mv	a1,a0
     88e:	8526                	mv	a0,s1
     890:	00000097          	auipc	ra,0x0
     894:	aca080e7          	jalr	-1334(ra) # 35a <listcmd>
     898:	84aa                	mv	s1,a0
  return cmd;
     89a:	b7d1                	j	85e <parseline+0x6a>

000000000000089c <parseblock>:
{
     89c:	7179                	addi	sp,sp,-48
     89e:	f406                	sd	ra,40(sp)
     8a0:	f022                	sd	s0,32(sp)
     8a2:	ec26                	sd	s1,24(sp)
     8a4:	e84a                	sd	s2,16(sp)
     8a6:	e44e                	sd	s3,8(sp)
     8a8:	1800                	addi	s0,sp,48
     8aa:	84aa                	mv	s1,a0
     8ac:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     8ae:	00001617          	auipc	a2,0x1
     8b2:	dd260613          	addi	a2,a2,-558 # 1680 <strstr+0xca>
     8b6:	00000097          	auipc	ra,0x0
     8ba:	c62080e7          	jalr	-926(ra) # 518 <peek>
     8be:	c12d                	beqz	a0,920 <parseblock+0x84>
  gettoken(ps, es, 0, 0);
     8c0:	4681                	li	a3,0
     8c2:	4601                	li	a2,0
     8c4:	85ca                	mv	a1,s2
     8c6:	8526                	mv	a0,s1
     8c8:	00000097          	auipc	ra,0x0
     8cc:	b14080e7          	jalr	-1260(ra) # 3dc <gettoken>
  cmd = parseline(ps, es);
     8d0:	85ca                	mv	a1,s2
     8d2:	8526                	mv	a0,s1
     8d4:	00000097          	auipc	ra,0x0
     8d8:	f20080e7          	jalr	-224(ra) # 7f4 <parseline>
     8dc:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     8de:	00001617          	auipc	a2,0x1
     8e2:	df260613          	addi	a2,a2,-526 # 16d0 <strstr+0x11a>
     8e6:	85ca                	mv	a1,s2
     8e8:	8526                	mv	a0,s1
     8ea:	00000097          	auipc	ra,0x0
     8ee:	c2e080e7          	jalr	-978(ra) # 518 <peek>
     8f2:	cd1d                	beqz	a0,930 <parseblock+0x94>
  gettoken(ps, es, 0, 0);
     8f4:	4681                	li	a3,0
     8f6:	4601                	li	a2,0
     8f8:	85ca                	mv	a1,s2
     8fa:	8526                	mv	a0,s1
     8fc:	00000097          	auipc	ra,0x0
     900:	ae0080e7          	jalr	-1312(ra) # 3dc <gettoken>
  cmd = parseredirs(cmd, ps, es);
     904:	864a                	mv	a2,s2
     906:	85a6                	mv	a1,s1
     908:	854e                	mv	a0,s3
     90a:	00000097          	auipc	ra,0x0
     90e:	c78080e7          	jalr	-904(ra) # 582 <parseredirs>
}
     912:	70a2                	ld	ra,40(sp)
     914:	7402                	ld	s0,32(sp)
     916:	64e2                	ld	s1,24(sp)
     918:	6942                	ld	s2,16(sp)
     91a:	69a2                	ld	s3,8(sp)
     91c:	6145                	addi	sp,sp,48
     91e:	8082                	ret
    panic("parseblock");
     920:	00001517          	auipc	a0,0x1
     924:	da050513          	addi	a0,a0,-608 # 16c0 <strstr+0x10a>
     928:	fffff097          	auipc	ra,0xfffff
     92c:	72c080e7          	jalr	1836(ra) # 54 <panic>
    panic("syntax - missing )");
     930:	00001517          	auipc	a0,0x1
     934:	da850513          	addi	a0,a0,-600 # 16d8 <strstr+0x122>
     938:	fffff097          	auipc	ra,0xfffff
     93c:	71c080e7          	jalr	1820(ra) # 54 <panic>

0000000000000940 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     940:	1101                	addi	sp,sp,-32
     942:	ec06                	sd	ra,24(sp)
     944:	e822                	sd	s0,16(sp)
     946:	e426                	sd	s1,8(sp)
     948:	1000                	addi	s0,sp,32
     94a:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     94c:	c521                	beqz	a0,994 <nulterminate+0x54>
    return 0;

  switch(cmd->type){
     94e:	4118                	lw	a4,0(a0)
     950:	4795                	li	a5,5
     952:	04e7e163          	bltu	a5,a4,994 <nulterminate+0x54>
     956:	00056783          	lwu	a5,0(a0)
     95a:	078a                	slli	a5,a5,0x2
     95c:	00001717          	auipc	a4,0x1
     960:	ddc70713          	addi	a4,a4,-548 # 1738 <strstr+0x182>
     964:	97ba                	add	a5,a5,a4
     966:	439c                	lw	a5,0(a5)
     968:	97ba                	add	a5,a5,a4
     96a:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     96c:	651c                	ld	a5,8(a0)
     96e:	c39d                	beqz	a5,994 <nulterminate+0x54>
     970:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     974:	67b8                	ld	a4,72(a5)
     976:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     97a:	07a1                	addi	a5,a5,8
     97c:	ff87b703          	ld	a4,-8(a5)
     980:	fb75                	bnez	a4,974 <nulterminate+0x34>
     982:	a809                	j	994 <nulterminate+0x54>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     984:	6508                	ld	a0,8(a0)
     986:	00000097          	auipc	ra,0x0
     98a:	fba080e7          	jalr	-70(ra) # 940 <nulterminate>
    *rcmd->efile = 0;
     98e:	6c9c                	ld	a5,24(s1)
     990:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     994:	8526                	mv	a0,s1
     996:	60e2                	ld	ra,24(sp)
     998:	6442                	ld	s0,16(sp)
     99a:	64a2                	ld	s1,8(sp)
     99c:	6105                	addi	sp,sp,32
     99e:	8082                	ret
    nulterminate(pcmd->left);
     9a0:	6508                	ld	a0,8(a0)
     9a2:	00000097          	auipc	ra,0x0
     9a6:	f9e080e7          	jalr	-98(ra) # 940 <nulterminate>
    nulterminate(pcmd->right);
     9aa:	6888                	ld	a0,16(s1)
     9ac:	00000097          	auipc	ra,0x0
     9b0:	f94080e7          	jalr	-108(ra) # 940 <nulterminate>
    break;
     9b4:	b7c5                	j	994 <nulterminate+0x54>
    nulterminate(lcmd->left);
     9b6:	6508                	ld	a0,8(a0)
     9b8:	00000097          	auipc	ra,0x0
     9bc:	f88080e7          	jalr	-120(ra) # 940 <nulterminate>
    nulterminate(lcmd->right);
     9c0:	6888                	ld	a0,16(s1)
     9c2:	00000097          	auipc	ra,0x0
     9c6:	f7e080e7          	jalr	-130(ra) # 940 <nulterminate>
    break;
     9ca:	b7e9                	j	994 <nulterminate+0x54>
    nulterminate(bcmd->cmd);
     9cc:	6508                	ld	a0,8(a0)
     9ce:	00000097          	auipc	ra,0x0
     9d2:	f72080e7          	jalr	-142(ra) # 940 <nulterminate>
    break;
     9d6:	bf7d                	j	994 <nulterminate+0x54>

00000000000009d8 <parsecmd>:
{
     9d8:	7179                	addi	sp,sp,-48
     9da:	f406                	sd	ra,40(sp)
     9dc:	f022                	sd	s0,32(sp)
     9de:	ec26                	sd	s1,24(sp)
     9e0:	e84a                	sd	s2,16(sp)
     9e2:	1800                	addi	s0,sp,48
     9e4:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
     9e8:	84aa                	mv	s1,a0
     9ea:	00000097          	auipc	ra,0x0
     9ee:	1b2080e7          	jalr	434(ra) # b9c <strlen>
     9f2:	1502                	slli	a0,a0,0x20
     9f4:	9101                	srli	a0,a0,0x20
     9f6:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     9f8:	85a6                	mv	a1,s1
     9fa:	fd840513          	addi	a0,s0,-40
     9fe:	00000097          	auipc	ra,0x0
     a02:	df6080e7          	jalr	-522(ra) # 7f4 <parseline>
     a06:	892a                	mv	s2,a0
  peek(&s, es, "");
     a08:	00001617          	auipc	a2,0x1
     a0c:	ce860613          	addi	a2,a2,-792 # 16f0 <strstr+0x13a>
     a10:	85a6                	mv	a1,s1
     a12:	fd840513          	addi	a0,s0,-40
     a16:	00000097          	auipc	ra,0x0
     a1a:	b02080e7          	jalr	-1278(ra) # 518 <peek>
  if(s != es){
     a1e:	fd843603          	ld	a2,-40(s0)
     a22:	00961e63          	bne	a2,s1,a3e <parsecmd+0x66>
  nulterminate(cmd);
     a26:	854a                	mv	a0,s2
     a28:	00000097          	auipc	ra,0x0
     a2c:	f18080e7          	jalr	-232(ra) # 940 <nulterminate>
}
     a30:	854a                	mv	a0,s2
     a32:	70a2                	ld	ra,40(sp)
     a34:	7402                	ld	s0,32(sp)
     a36:	64e2                	ld	s1,24(sp)
     a38:	6942                	ld	s2,16(sp)
     a3a:	6145                	addi	sp,sp,48
     a3c:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     a3e:	00001597          	auipc	a1,0x1
     a42:	cba58593          	addi	a1,a1,-838 # 16f8 <strstr+0x142>
     a46:	4509                	li	a0,2
     a48:	00000097          	auipc	ra,0x0
     a4c:	6cc080e7          	jalr	1740(ra) # 1114 <fprintf>
    panic("syntax");
     a50:	00001517          	auipc	a0,0x1
     a54:	c3850513          	addi	a0,a0,-968 # 1688 <strstr+0xd2>
     a58:	fffff097          	auipc	ra,0xfffff
     a5c:	5fc080e7          	jalr	1532(ra) # 54 <panic>

0000000000000a60 <main>:
{
     a60:	7139                	addi	sp,sp,-64
     a62:	fc06                	sd	ra,56(sp)
     a64:	f822                	sd	s0,48(sp)
     a66:	f426                	sd	s1,40(sp)
     a68:	f04a                	sd	s2,32(sp)
     a6a:	ec4e                	sd	s3,24(sp)
     a6c:	e852                	sd	s4,16(sp)
     a6e:	e456                	sd	s5,8(sp)
     a70:	0080                	addi	s0,sp,64
  while((fd = open("console", O_RDWR)) >= 0){
     a72:	00001497          	auipc	s1,0x1
     a76:	c9648493          	addi	s1,s1,-874 # 1708 <strstr+0x152>
     a7a:	4589                	li	a1,2
     a7c:	8526                	mv	a0,s1
     a7e:	00000097          	auipc	ra,0x0
     a82:	384080e7          	jalr	900(ra) # e02 <open>
     a86:	00054963          	bltz	a0,a98 <main+0x38>
    if(fd >= 3){
     a8a:	4789                	li	a5,2
     a8c:	fea7d7e3          	bge	a5,a0,a7a <main+0x1a>
      close(fd);
     a90:	00000097          	auipc	ra,0x0
     a94:	35a080e7          	jalr	858(ra) # dea <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     a98:	00001497          	auipc	s1,0x1
     a9c:	d9048493          	addi	s1,s1,-624 # 1828 <buf.0>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     aa0:	06300913          	li	s2,99
     aa4:	02000993          	li	s3,32
      if(chdir(buf+3) < 0)
     aa8:	00001a17          	auipc	s4,0x1
     aac:	d83a0a13          	addi	s4,s4,-637 # 182b <buf.0+0x3>
        fprintf(2, "cannot cd %s\n", buf+3);
     ab0:	00001a97          	auipc	s5,0x1
     ab4:	c60a8a93          	addi	s5,s5,-928 # 1710 <strstr+0x15a>
     ab8:	a819                	j	ace <main+0x6e>
    if(fork1() == 0)
     aba:	fffff097          	auipc	ra,0xfffff
     abe:	5c0080e7          	jalr	1472(ra) # 7a <fork1>
     ac2:	c925                	beqz	a0,b32 <main+0xd2>
    wait(0);
     ac4:	4501                	li	a0,0
     ac6:	00000097          	auipc	ra,0x0
     aca:	304080e7          	jalr	772(ra) # dca <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     ace:	06400593          	li	a1,100
     ad2:	8526                	mv	a0,s1
     ad4:	fffff097          	auipc	ra,0xfffff
     ad8:	52c080e7          	jalr	1324(ra) # 0 <getcmd>
     adc:	06054763          	bltz	a0,b4a <main+0xea>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     ae0:	0004c783          	lbu	a5,0(s1)
     ae4:	fd279be3          	bne	a5,s2,aba <main+0x5a>
     ae8:	0014c703          	lbu	a4,1(s1)
     aec:	06400793          	li	a5,100
     af0:	fcf715e3          	bne	a4,a5,aba <main+0x5a>
     af4:	0024c783          	lbu	a5,2(s1)
     af8:	fd3791e3          	bne	a5,s3,aba <main+0x5a>
      buf[strlen(buf)-1] = 0;  // chop \n
     afc:	8526                	mv	a0,s1
     afe:	00000097          	auipc	ra,0x0
     b02:	09e080e7          	jalr	158(ra) # b9c <strlen>
     b06:	fff5079b          	addiw	a5,a0,-1
     b0a:	1782                	slli	a5,a5,0x20
     b0c:	9381                	srli	a5,a5,0x20
     b0e:	97a6                	add	a5,a5,s1
     b10:	00078023          	sb	zero,0(a5)
      if(chdir(buf+3) < 0)
     b14:	8552                	mv	a0,s4
     b16:	00000097          	auipc	ra,0x0
     b1a:	31c080e7          	jalr	796(ra) # e32 <chdir>
     b1e:	fa0558e3          	bgez	a0,ace <main+0x6e>
        fprintf(2, "cannot cd %s\n", buf+3);
     b22:	8652                	mv	a2,s4
     b24:	85d6                	mv	a1,s5
     b26:	4509                	li	a0,2
     b28:	00000097          	auipc	ra,0x0
     b2c:	5ec080e7          	jalr	1516(ra) # 1114 <fprintf>
     b30:	bf79                	j	ace <main+0x6e>
      runcmd(parsecmd(buf));
     b32:	00001517          	auipc	a0,0x1
     b36:	cf650513          	addi	a0,a0,-778 # 1828 <buf.0>
     b3a:	00000097          	auipc	ra,0x0
     b3e:	e9e080e7          	jalr	-354(ra) # 9d8 <parsecmd>
     b42:	fffff097          	auipc	ra,0xfffff
     b46:	566080e7          	jalr	1382(ra) # a8 <runcmd>
  exit(0);
     b4a:	4501                	li	a0,0
     b4c:	00000097          	auipc	ra,0x0
     b50:	276080e7          	jalr	630(ra) # dc2 <exit>

0000000000000b54 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
     b54:	1141                	addi	sp,sp,-16
     b56:	e422                	sd	s0,8(sp)
     b58:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     b5a:	87aa                	mv	a5,a0
     b5c:	0585                	addi	a1,a1,1
     b5e:	0785                	addi	a5,a5,1
     b60:	fff5c703          	lbu	a4,-1(a1)
     b64:	fee78fa3          	sb	a4,-1(a5)
     b68:	fb75                	bnez	a4,b5c <strcpy+0x8>
    ;
  return os;
}
     b6a:	6422                	ld	s0,8(sp)
     b6c:	0141                	addi	sp,sp,16
     b6e:	8082                	ret

0000000000000b70 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     b70:	1141                	addi	sp,sp,-16
     b72:	e422                	sd	s0,8(sp)
     b74:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     b76:	00054783          	lbu	a5,0(a0)
     b7a:	cb91                	beqz	a5,b8e <strcmp+0x1e>
     b7c:	0005c703          	lbu	a4,0(a1)
     b80:	00f71763          	bne	a4,a5,b8e <strcmp+0x1e>
    p++, q++;
     b84:	0505                	addi	a0,a0,1
     b86:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     b88:	00054783          	lbu	a5,0(a0)
     b8c:	fbe5                	bnez	a5,b7c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     b8e:	0005c503          	lbu	a0,0(a1)
}
     b92:	40a7853b          	subw	a0,a5,a0
     b96:	6422                	ld	s0,8(sp)
     b98:	0141                	addi	sp,sp,16
     b9a:	8082                	ret

0000000000000b9c <strlen>:

uint
strlen(const char *s)
{
     b9c:	1141                	addi	sp,sp,-16
     b9e:	e422                	sd	s0,8(sp)
     ba0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     ba2:	00054783          	lbu	a5,0(a0)
     ba6:	cf91                	beqz	a5,bc2 <strlen+0x26>
     ba8:	0505                	addi	a0,a0,1
     baa:	87aa                	mv	a5,a0
     bac:	4685                	li	a3,1
     bae:	9e89                	subw	a3,a3,a0
     bb0:	00f6853b          	addw	a0,a3,a5
     bb4:	0785                	addi	a5,a5,1
     bb6:	fff7c703          	lbu	a4,-1(a5)
     bba:	fb7d                	bnez	a4,bb0 <strlen+0x14>
    ;
  return n;
}
     bbc:	6422                	ld	s0,8(sp)
     bbe:	0141                	addi	sp,sp,16
     bc0:	8082                	ret
  for(n = 0; s[n]; n++)
     bc2:	4501                	li	a0,0
     bc4:	bfe5                	j	bbc <strlen+0x20>

0000000000000bc6 <memset>:

void*
memset(void *dst, int c, uint n)
{
     bc6:	1141                	addi	sp,sp,-16
     bc8:	e422                	sd	s0,8(sp)
     bca:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     bcc:	ca19                	beqz	a2,be2 <memset+0x1c>
     bce:	87aa                	mv	a5,a0
     bd0:	1602                	slli	a2,a2,0x20
     bd2:	9201                	srli	a2,a2,0x20
     bd4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     bd8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     bdc:	0785                	addi	a5,a5,1
     bde:	fee79de3          	bne	a5,a4,bd8 <memset+0x12>
  }
  return dst;
}
     be2:	6422                	ld	s0,8(sp)
     be4:	0141                	addi	sp,sp,16
     be6:	8082                	ret

0000000000000be8 <strchr>:

char*
strchr(const char *s, char c)
{
     be8:	1141                	addi	sp,sp,-16
     bea:	e422                	sd	s0,8(sp)
     bec:	0800                	addi	s0,sp,16
  for(; *s; s++)
     bee:	00054783          	lbu	a5,0(a0)
     bf2:	cb99                	beqz	a5,c08 <strchr+0x20>
    if(*s == c)
     bf4:	00f58763          	beq	a1,a5,c02 <strchr+0x1a>
  for(; *s; s++)
     bf8:	0505                	addi	a0,a0,1
     bfa:	00054783          	lbu	a5,0(a0)
     bfe:	fbfd                	bnez	a5,bf4 <strchr+0xc>
      return (char*)s;
  return 0;
     c00:	4501                	li	a0,0
}
     c02:	6422                	ld	s0,8(sp)
     c04:	0141                	addi	sp,sp,16
     c06:	8082                	ret
  return 0;
     c08:	4501                	li	a0,0
     c0a:	bfe5                	j	c02 <strchr+0x1a>

0000000000000c0c <gets>:

char*
gets(char *buf, int max)
{
     c0c:	711d                	addi	sp,sp,-96
     c0e:	ec86                	sd	ra,88(sp)
     c10:	e8a2                	sd	s0,80(sp)
     c12:	e4a6                	sd	s1,72(sp)
     c14:	e0ca                	sd	s2,64(sp)
     c16:	fc4e                	sd	s3,56(sp)
     c18:	f852                	sd	s4,48(sp)
     c1a:	f456                	sd	s5,40(sp)
     c1c:	f05a                	sd	s6,32(sp)
     c1e:	ec5e                	sd	s7,24(sp)
     c20:	1080                	addi	s0,sp,96
     c22:	8baa                	mv	s7,a0
     c24:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c26:	892a                	mv	s2,a0
     c28:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     c2a:	4aa9                	li	s5,10
     c2c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     c2e:	89a6                	mv	s3,s1
     c30:	2485                	addiw	s1,s1,1
     c32:	0344d863          	bge	s1,s4,c62 <gets+0x56>
    cc = read(0, &c, 1);
     c36:	4605                	li	a2,1
     c38:	faf40593          	addi	a1,s0,-81
     c3c:	4501                	li	a0,0
     c3e:	00000097          	auipc	ra,0x0
     c42:	19c080e7          	jalr	412(ra) # dda <read>
    if(cc < 1)
     c46:	00a05e63          	blez	a0,c62 <gets+0x56>
    buf[i++] = c;
     c4a:	faf44783          	lbu	a5,-81(s0)
     c4e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     c52:	01578763          	beq	a5,s5,c60 <gets+0x54>
     c56:	0905                	addi	s2,s2,1
     c58:	fd679be3          	bne	a5,s6,c2e <gets+0x22>
  for(i=0; i+1 < max; ){
     c5c:	89a6                	mv	s3,s1
     c5e:	a011                	j	c62 <gets+0x56>
     c60:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     c62:	99de                	add	s3,s3,s7
     c64:	00098023          	sb	zero,0(s3)
  return buf;
}
     c68:	855e                	mv	a0,s7
     c6a:	60e6                	ld	ra,88(sp)
     c6c:	6446                	ld	s0,80(sp)
     c6e:	64a6                	ld	s1,72(sp)
     c70:	6906                	ld	s2,64(sp)
     c72:	79e2                	ld	s3,56(sp)
     c74:	7a42                	ld	s4,48(sp)
     c76:	7aa2                	ld	s5,40(sp)
     c78:	7b02                	ld	s6,32(sp)
     c7a:	6be2                	ld	s7,24(sp)
     c7c:	6125                	addi	sp,sp,96
     c7e:	8082                	ret

0000000000000c80 <stat>:

int
stat(const char *n, struct stat *st)
{
     c80:	1101                	addi	sp,sp,-32
     c82:	ec06                	sd	ra,24(sp)
     c84:	e822                	sd	s0,16(sp)
     c86:	e426                	sd	s1,8(sp)
     c88:	e04a                	sd	s2,0(sp)
     c8a:	1000                	addi	s0,sp,32
     c8c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     c8e:	4581                	li	a1,0
     c90:	00000097          	auipc	ra,0x0
     c94:	172080e7          	jalr	370(ra) # e02 <open>
  if(fd < 0)
     c98:	02054563          	bltz	a0,cc2 <stat+0x42>
     c9c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     c9e:	85ca                	mv	a1,s2
     ca0:	00000097          	auipc	ra,0x0
     ca4:	17a080e7          	jalr	378(ra) # e1a <fstat>
     ca8:	892a                	mv	s2,a0
  close(fd);
     caa:	8526                	mv	a0,s1
     cac:	00000097          	auipc	ra,0x0
     cb0:	13e080e7          	jalr	318(ra) # dea <close>
  return r;
}
     cb4:	854a                	mv	a0,s2
     cb6:	60e2                	ld	ra,24(sp)
     cb8:	6442                	ld	s0,16(sp)
     cba:	64a2                	ld	s1,8(sp)
     cbc:	6902                	ld	s2,0(sp)
     cbe:	6105                	addi	sp,sp,32
     cc0:	8082                	ret
    return -1;
     cc2:	597d                	li	s2,-1
     cc4:	bfc5                	j	cb4 <stat+0x34>

0000000000000cc6 <atoi>:

int
atoi(const char *s)
{
     cc6:	1141                	addi	sp,sp,-16
     cc8:	e422                	sd	s0,8(sp)
     cca:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     ccc:	00054603          	lbu	a2,0(a0)
     cd0:	fd06079b          	addiw	a5,a2,-48
     cd4:	0ff7f793          	andi	a5,a5,255
     cd8:	4725                	li	a4,9
     cda:	02f76963          	bltu	a4,a5,d0c <atoi+0x46>
     cde:	86aa                	mv	a3,a0
  n = 0;
     ce0:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     ce2:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     ce4:	0685                	addi	a3,a3,1
     ce6:	0025179b          	slliw	a5,a0,0x2
     cea:	9fa9                	addw	a5,a5,a0
     cec:	0017979b          	slliw	a5,a5,0x1
     cf0:	9fb1                	addw	a5,a5,a2
     cf2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     cf6:	0006c603          	lbu	a2,0(a3)
     cfa:	fd06071b          	addiw	a4,a2,-48
     cfe:	0ff77713          	andi	a4,a4,255
     d02:	fee5f1e3          	bgeu	a1,a4,ce4 <atoi+0x1e>
  return n;
}
     d06:	6422                	ld	s0,8(sp)
     d08:	0141                	addi	sp,sp,16
     d0a:	8082                	ret
  n = 0;
     d0c:	4501                	li	a0,0
     d0e:	bfe5                	j	d06 <atoi+0x40>

0000000000000d10 <memmove>:

// #define memcpy memmove

void*
memmove(void *vdst, const void *vsrc, int n)
{
     d10:	1141                	addi	sp,sp,-16
     d12:	e422                	sd	s0,8(sp)
     d14:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     d16:	02b57463          	bgeu	a0,a1,d3e <memmove+0x2e>
    while(n-- > 0)
     d1a:	00c05f63          	blez	a2,d38 <memmove+0x28>
     d1e:	1602                	slli	a2,a2,0x20
     d20:	9201                	srli	a2,a2,0x20
     d22:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     d26:	872a                	mv	a4,a0
      *dst++ = *src++;
     d28:	0585                	addi	a1,a1,1
     d2a:	0705                	addi	a4,a4,1
     d2c:	fff5c683          	lbu	a3,-1(a1)
     d30:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     d34:	fee79ae3          	bne	a5,a4,d28 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     d38:	6422                	ld	s0,8(sp)
     d3a:	0141                	addi	sp,sp,16
     d3c:	8082                	ret
    dst += n;
     d3e:	00c50733          	add	a4,a0,a2
    src += n;
     d42:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     d44:	fec05ae3          	blez	a2,d38 <memmove+0x28>
     d48:	fff6079b          	addiw	a5,a2,-1
     d4c:	1782                	slli	a5,a5,0x20
     d4e:	9381                	srli	a5,a5,0x20
     d50:	fff7c793          	not	a5,a5
     d54:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     d56:	15fd                	addi	a1,a1,-1
     d58:	177d                	addi	a4,a4,-1
     d5a:	0005c683          	lbu	a3,0(a1)
     d5e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     d62:	fee79ae3          	bne	a5,a4,d56 <memmove+0x46>
     d66:	bfc9                	j	d38 <memmove+0x28>

0000000000000d68 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     d68:	1141                	addi	sp,sp,-16
     d6a:	e422                	sd	s0,8(sp)
     d6c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     d6e:	ca05                	beqz	a2,d9e <memcmp+0x36>
     d70:	fff6069b          	addiw	a3,a2,-1
     d74:	1682                	slli	a3,a3,0x20
     d76:	9281                	srli	a3,a3,0x20
     d78:	0685                	addi	a3,a3,1
     d7a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     d7c:	00054783          	lbu	a5,0(a0)
     d80:	0005c703          	lbu	a4,0(a1)
     d84:	00e79863          	bne	a5,a4,d94 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     d88:	0505                	addi	a0,a0,1
    p2++;
     d8a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     d8c:	fed518e3          	bne	a0,a3,d7c <memcmp+0x14>
  }
  return 0;
     d90:	4501                	li	a0,0
     d92:	a019                	j	d98 <memcmp+0x30>
      return *p1 - *p2;
     d94:	40e7853b          	subw	a0,a5,a4
}
     d98:	6422                	ld	s0,8(sp)
     d9a:	0141                	addi	sp,sp,16
     d9c:	8082                	ret
  return 0;
     d9e:	4501                	li	a0,0
     da0:	bfe5                	j	d98 <memcmp+0x30>

0000000000000da2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     da2:	1141                	addi	sp,sp,-16
     da4:	e406                	sd	ra,8(sp)
     da6:	e022                	sd	s0,0(sp)
     da8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     daa:	00000097          	auipc	ra,0x0
     dae:	f66080e7          	jalr	-154(ra) # d10 <memmove>
}
     db2:	60a2                	ld	ra,8(sp)
     db4:	6402                	ld	s0,0(sp)
     db6:	0141                	addi	sp,sp,16
     db8:	8082                	ret

0000000000000dba <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     dba:	4885                	li	a7,1
 ecall
     dbc:	00000073          	ecall
 ret
     dc0:	8082                	ret

0000000000000dc2 <exit>:
.global exit
exit:
 li a7, SYS_exit
     dc2:	4889                	li	a7,2
 ecall
     dc4:	00000073          	ecall
 ret
     dc8:	8082                	ret

0000000000000dca <wait>:
.global wait
wait:
 li a7, SYS_wait
     dca:	488d                	li	a7,3
 ecall
     dcc:	00000073          	ecall
 ret
     dd0:	8082                	ret

0000000000000dd2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     dd2:	4891                	li	a7,4
 ecall
     dd4:	00000073          	ecall
 ret
     dd8:	8082                	ret

0000000000000dda <read>:
.global read
read:
 li a7, SYS_read
     dda:	4895                	li	a7,5
 ecall
     ddc:	00000073          	ecall
 ret
     de0:	8082                	ret

0000000000000de2 <write>:
.global write
write:
 li a7, SYS_write
     de2:	48c1                	li	a7,16
 ecall
     de4:	00000073          	ecall
 ret
     de8:	8082                	ret

0000000000000dea <close>:
.global close
close:
 li a7, SYS_close
     dea:	48d5                	li	a7,21
 ecall
     dec:	00000073          	ecall
 ret
     df0:	8082                	ret

0000000000000df2 <kill>:
.global kill
kill:
 li a7, SYS_kill
     df2:	4899                	li	a7,6
 ecall
     df4:	00000073          	ecall
 ret
     df8:	8082                	ret

0000000000000dfa <exec>:
.global exec
exec:
 li a7, SYS_exec
     dfa:	489d                	li	a7,7
 ecall
     dfc:	00000073          	ecall
 ret
     e00:	8082                	ret

0000000000000e02 <open>:
.global open
open:
 li a7, SYS_open
     e02:	48bd                	li	a7,15
 ecall
     e04:	00000073          	ecall
 ret
     e08:	8082                	ret

0000000000000e0a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     e0a:	48c5                	li	a7,17
 ecall
     e0c:	00000073          	ecall
 ret
     e10:	8082                	ret

0000000000000e12 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     e12:	48c9                	li	a7,18
 ecall
     e14:	00000073          	ecall
 ret
     e18:	8082                	ret

0000000000000e1a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     e1a:	48a1                	li	a7,8
 ecall
     e1c:	00000073          	ecall
 ret
     e20:	8082                	ret

0000000000000e22 <link>:
.global link
link:
 li a7, SYS_link
     e22:	48cd                	li	a7,19
 ecall
     e24:	00000073          	ecall
 ret
     e28:	8082                	ret

0000000000000e2a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     e2a:	48d1                	li	a7,20
 ecall
     e2c:	00000073          	ecall
 ret
     e30:	8082                	ret

0000000000000e32 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     e32:	48a5                	li	a7,9
 ecall
     e34:	00000073          	ecall
 ret
     e38:	8082                	ret

0000000000000e3a <dup>:
.global dup
dup:
 li a7, SYS_dup
     e3a:	48a9                	li	a7,10
 ecall
     e3c:	00000073          	ecall
 ret
     e40:	8082                	ret

0000000000000e42 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     e42:	48ad                	li	a7,11
 ecall
     e44:	00000073          	ecall
 ret
     e48:	8082                	ret

0000000000000e4a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     e4a:	48b1                	li	a7,12
 ecall
     e4c:	00000073          	ecall
 ret
     e50:	8082                	ret

0000000000000e52 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     e52:	48b5                	li	a7,13
 ecall
     e54:	00000073          	ecall
 ret
     e58:	8082                	ret

0000000000000e5a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     e5a:	48b9                	li	a7,14
 ecall
     e5c:	00000073          	ecall
 ret
     e60:	8082                	ret

0000000000000e62 <trace>:
.global trace
trace:
 li a7, SYS_trace
     e62:	48d9                	li	a7,22
 ecall
     e64:	00000073          	ecall
 ret
     e68:	8082                	ret

0000000000000e6a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     e6a:	1101                	addi	sp,sp,-32
     e6c:	ec06                	sd	ra,24(sp)
     e6e:	e822                	sd	s0,16(sp)
     e70:	1000                	addi	s0,sp,32
     e72:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     e76:	4605                	li	a2,1
     e78:	fef40593          	addi	a1,s0,-17
     e7c:	00000097          	auipc	ra,0x0
     e80:	f66080e7          	jalr	-154(ra) # de2 <write>
}
     e84:	60e2                	ld	ra,24(sp)
     e86:	6442                	ld	s0,16(sp)
     e88:	6105                	addi	sp,sp,32
     e8a:	8082                	ret

0000000000000e8c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     e8c:	7139                	addi	sp,sp,-64
     e8e:	fc06                	sd	ra,56(sp)
     e90:	f822                	sd	s0,48(sp)
     e92:	f426                	sd	s1,40(sp)
     e94:	f04a                	sd	s2,32(sp)
     e96:	ec4e                	sd	s3,24(sp)
     e98:	0080                	addi	s0,sp,64
     e9a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     e9c:	c299                	beqz	a3,ea2 <printint+0x16>
     e9e:	0805c863          	bltz	a1,f2e <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     ea2:	2581                	sext.w	a1,a1
  neg = 0;
     ea4:	4881                	li	a7,0
     ea6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     eaa:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     eac:	2601                	sext.w	a2,a2
     eae:	00001517          	auipc	a0,0x1
     eb2:	8aa50513          	addi	a0,a0,-1878 # 1758 <digits>
     eb6:	883a                	mv	a6,a4
     eb8:	2705                	addiw	a4,a4,1
     eba:	02c5f7bb          	remuw	a5,a1,a2
     ebe:	1782                	slli	a5,a5,0x20
     ec0:	9381                	srli	a5,a5,0x20
     ec2:	97aa                	add	a5,a5,a0
     ec4:	0007c783          	lbu	a5,0(a5)
     ec8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     ecc:	0005879b          	sext.w	a5,a1
     ed0:	02c5d5bb          	divuw	a1,a1,a2
     ed4:	0685                	addi	a3,a3,1
     ed6:	fec7f0e3          	bgeu	a5,a2,eb6 <printint+0x2a>
  if(neg)
     eda:	00088b63          	beqz	a7,ef0 <printint+0x64>
    buf[i++] = '-';
     ede:	fd040793          	addi	a5,s0,-48
     ee2:	973e                	add	a4,a4,a5
     ee4:	02d00793          	li	a5,45
     ee8:	fef70823          	sb	a5,-16(a4)
     eec:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     ef0:	02e05863          	blez	a4,f20 <printint+0x94>
     ef4:	fc040793          	addi	a5,s0,-64
     ef8:	00e78933          	add	s2,a5,a4
     efc:	fff78993          	addi	s3,a5,-1
     f00:	99ba                	add	s3,s3,a4
     f02:	377d                	addiw	a4,a4,-1
     f04:	1702                	slli	a4,a4,0x20
     f06:	9301                	srli	a4,a4,0x20
     f08:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     f0c:	fff94583          	lbu	a1,-1(s2)
     f10:	8526                	mv	a0,s1
     f12:	00000097          	auipc	ra,0x0
     f16:	f58080e7          	jalr	-168(ra) # e6a <putc>
  while(--i >= 0)
     f1a:	197d                	addi	s2,s2,-1
     f1c:	ff3918e3          	bne	s2,s3,f0c <printint+0x80>
}
     f20:	70e2                	ld	ra,56(sp)
     f22:	7442                	ld	s0,48(sp)
     f24:	74a2                	ld	s1,40(sp)
     f26:	7902                	ld	s2,32(sp)
     f28:	69e2                	ld	s3,24(sp)
     f2a:	6121                	addi	sp,sp,64
     f2c:	8082                	ret
    x = -xx;
     f2e:	40b005bb          	negw	a1,a1
    neg = 1;
     f32:	4885                	li	a7,1
    x = -xx;
     f34:	bf8d                	j	ea6 <printint+0x1a>

0000000000000f36 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     f36:	7119                	addi	sp,sp,-128
     f38:	fc86                	sd	ra,120(sp)
     f3a:	f8a2                	sd	s0,112(sp)
     f3c:	f4a6                	sd	s1,104(sp)
     f3e:	f0ca                	sd	s2,96(sp)
     f40:	ecce                	sd	s3,88(sp)
     f42:	e8d2                	sd	s4,80(sp)
     f44:	e4d6                	sd	s5,72(sp)
     f46:	e0da                	sd	s6,64(sp)
     f48:	fc5e                	sd	s7,56(sp)
     f4a:	f862                	sd	s8,48(sp)
     f4c:	f466                	sd	s9,40(sp)
     f4e:	f06a                	sd	s10,32(sp)
     f50:	ec6e                	sd	s11,24(sp)
     f52:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     f54:	0005c903          	lbu	s2,0(a1)
     f58:	18090f63          	beqz	s2,10f6 <vprintf+0x1c0>
     f5c:	8aaa                	mv	s5,a0
     f5e:	8b32                	mv	s6,a2
     f60:	00158493          	addi	s1,a1,1
  state = 0;
     f64:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     f66:	02500a13          	li	s4,37
      if(c == 'd'){
     f6a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
     f6e:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
     f72:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
     f76:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     f7a:	00000b97          	auipc	s7,0x0
     f7e:	7deb8b93          	addi	s7,s7,2014 # 1758 <digits>
     f82:	a839                	j	fa0 <vprintf+0x6a>
        putc(fd, c);
     f84:	85ca                	mv	a1,s2
     f86:	8556                	mv	a0,s5
     f88:	00000097          	auipc	ra,0x0
     f8c:	ee2080e7          	jalr	-286(ra) # e6a <putc>
     f90:	a019                	j	f96 <vprintf+0x60>
    } else if(state == '%'){
     f92:	01498f63          	beq	s3,s4,fb0 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
     f96:	0485                	addi	s1,s1,1
     f98:	fff4c903          	lbu	s2,-1(s1)
     f9c:	14090d63          	beqz	s2,10f6 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
     fa0:	0009079b          	sext.w	a5,s2
    if(state == 0){
     fa4:	fe0997e3          	bnez	s3,f92 <vprintf+0x5c>
      if(c == '%'){
     fa8:	fd479ee3          	bne	a5,s4,f84 <vprintf+0x4e>
        state = '%';
     fac:	89be                	mv	s3,a5
     fae:	b7e5                	j	f96 <vprintf+0x60>
      if(c == 'd'){
     fb0:	05878063          	beq	a5,s8,ff0 <vprintf+0xba>
      } else if(c == 'l') {
     fb4:	05978c63          	beq	a5,s9,100c <vprintf+0xd6>
      } else if(c == 'x') {
     fb8:	07a78863          	beq	a5,s10,1028 <vprintf+0xf2>
      } else if(c == 'p') {
     fbc:	09b78463          	beq	a5,s11,1044 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
     fc0:	07300713          	li	a4,115
     fc4:	0ce78663          	beq	a5,a4,1090 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     fc8:	06300713          	li	a4,99
     fcc:	0ee78e63          	beq	a5,a4,10c8 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
     fd0:	11478863          	beq	a5,s4,10e0 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     fd4:	85d2                	mv	a1,s4
     fd6:	8556                	mv	a0,s5
     fd8:	00000097          	auipc	ra,0x0
     fdc:	e92080e7          	jalr	-366(ra) # e6a <putc>
        putc(fd, c);
     fe0:	85ca                	mv	a1,s2
     fe2:	8556                	mv	a0,s5
     fe4:	00000097          	auipc	ra,0x0
     fe8:	e86080e7          	jalr	-378(ra) # e6a <putc>
      }
      state = 0;
     fec:	4981                	li	s3,0
     fee:	b765                	j	f96 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
     ff0:	008b0913          	addi	s2,s6,8
     ff4:	4685                	li	a3,1
     ff6:	4629                	li	a2,10
     ff8:	000b2583          	lw	a1,0(s6)
     ffc:	8556                	mv	a0,s5
     ffe:	00000097          	auipc	ra,0x0
    1002:	e8e080e7          	jalr	-370(ra) # e8c <printint>
    1006:	8b4a                	mv	s6,s2
      state = 0;
    1008:	4981                	li	s3,0
    100a:	b771                	j	f96 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    100c:	008b0913          	addi	s2,s6,8
    1010:	4681                	li	a3,0
    1012:	4629                	li	a2,10
    1014:	000b2583          	lw	a1,0(s6)
    1018:	8556                	mv	a0,s5
    101a:	00000097          	auipc	ra,0x0
    101e:	e72080e7          	jalr	-398(ra) # e8c <printint>
    1022:	8b4a                	mv	s6,s2
      state = 0;
    1024:	4981                	li	s3,0
    1026:	bf85                	j	f96 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    1028:	008b0913          	addi	s2,s6,8
    102c:	4681                	li	a3,0
    102e:	4641                	li	a2,16
    1030:	000b2583          	lw	a1,0(s6)
    1034:	8556                	mv	a0,s5
    1036:	00000097          	auipc	ra,0x0
    103a:	e56080e7          	jalr	-426(ra) # e8c <printint>
    103e:	8b4a                	mv	s6,s2
      state = 0;
    1040:	4981                	li	s3,0
    1042:	bf91                	j	f96 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    1044:	008b0793          	addi	a5,s6,8
    1048:	f8f43423          	sd	a5,-120(s0)
    104c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    1050:	03000593          	li	a1,48
    1054:	8556                	mv	a0,s5
    1056:	00000097          	auipc	ra,0x0
    105a:	e14080e7          	jalr	-492(ra) # e6a <putc>
  putc(fd, 'x');
    105e:	85ea                	mv	a1,s10
    1060:	8556                	mv	a0,s5
    1062:	00000097          	auipc	ra,0x0
    1066:	e08080e7          	jalr	-504(ra) # e6a <putc>
    106a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    106c:	03c9d793          	srli	a5,s3,0x3c
    1070:	97de                	add	a5,a5,s7
    1072:	0007c583          	lbu	a1,0(a5)
    1076:	8556                	mv	a0,s5
    1078:	00000097          	auipc	ra,0x0
    107c:	df2080e7          	jalr	-526(ra) # e6a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1080:	0992                	slli	s3,s3,0x4
    1082:	397d                	addiw	s2,s2,-1
    1084:	fe0914e3          	bnez	s2,106c <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    1088:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    108c:	4981                	li	s3,0
    108e:	b721                	j	f96 <vprintf+0x60>
        s = va_arg(ap, char*);
    1090:	008b0993          	addi	s3,s6,8
    1094:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    1098:	02090163          	beqz	s2,10ba <vprintf+0x184>
        while(*s != 0){
    109c:	00094583          	lbu	a1,0(s2)
    10a0:	c9a1                	beqz	a1,10f0 <vprintf+0x1ba>
          putc(fd, *s);
    10a2:	8556                	mv	a0,s5
    10a4:	00000097          	auipc	ra,0x0
    10a8:	dc6080e7          	jalr	-570(ra) # e6a <putc>
          s++;
    10ac:	0905                	addi	s2,s2,1
        while(*s != 0){
    10ae:	00094583          	lbu	a1,0(s2)
    10b2:	f9e5                	bnez	a1,10a2 <vprintf+0x16c>
        s = va_arg(ap, char*);
    10b4:	8b4e                	mv	s6,s3
      state = 0;
    10b6:	4981                	li	s3,0
    10b8:	bdf9                	j	f96 <vprintf+0x60>
          s = "(null)";
    10ba:	00000917          	auipc	s2,0x0
    10be:	69690913          	addi	s2,s2,1686 # 1750 <strstr+0x19a>
        while(*s != 0){
    10c2:	02800593          	li	a1,40
    10c6:	bff1                	j	10a2 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    10c8:	008b0913          	addi	s2,s6,8
    10cc:	000b4583          	lbu	a1,0(s6)
    10d0:	8556                	mv	a0,s5
    10d2:	00000097          	auipc	ra,0x0
    10d6:	d98080e7          	jalr	-616(ra) # e6a <putc>
    10da:	8b4a                	mv	s6,s2
      state = 0;
    10dc:	4981                	li	s3,0
    10de:	bd65                	j	f96 <vprintf+0x60>
        putc(fd, c);
    10e0:	85d2                	mv	a1,s4
    10e2:	8556                	mv	a0,s5
    10e4:	00000097          	auipc	ra,0x0
    10e8:	d86080e7          	jalr	-634(ra) # e6a <putc>
      state = 0;
    10ec:	4981                	li	s3,0
    10ee:	b565                	j	f96 <vprintf+0x60>
        s = va_arg(ap, char*);
    10f0:	8b4e                	mv	s6,s3
      state = 0;
    10f2:	4981                	li	s3,0
    10f4:	b54d                	j	f96 <vprintf+0x60>
    }
  }
}
    10f6:	70e6                	ld	ra,120(sp)
    10f8:	7446                	ld	s0,112(sp)
    10fa:	74a6                	ld	s1,104(sp)
    10fc:	7906                	ld	s2,96(sp)
    10fe:	69e6                	ld	s3,88(sp)
    1100:	6a46                	ld	s4,80(sp)
    1102:	6aa6                	ld	s5,72(sp)
    1104:	6b06                	ld	s6,64(sp)
    1106:	7be2                	ld	s7,56(sp)
    1108:	7c42                	ld	s8,48(sp)
    110a:	7ca2                	ld	s9,40(sp)
    110c:	7d02                	ld	s10,32(sp)
    110e:	6de2                	ld	s11,24(sp)
    1110:	6109                	addi	sp,sp,128
    1112:	8082                	ret

0000000000001114 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1114:	715d                	addi	sp,sp,-80
    1116:	ec06                	sd	ra,24(sp)
    1118:	e822                	sd	s0,16(sp)
    111a:	1000                	addi	s0,sp,32
    111c:	e010                	sd	a2,0(s0)
    111e:	e414                	sd	a3,8(s0)
    1120:	e818                	sd	a4,16(s0)
    1122:	ec1c                	sd	a5,24(s0)
    1124:	03043023          	sd	a6,32(s0)
    1128:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    112c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1130:	8622                	mv	a2,s0
    1132:	00000097          	auipc	ra,0x0
    1136:	e04080e7          	jalr	-508(ra) # f36 <vprintf>
}
    113a:	60e2                	ld	ra,24(sp)
    113c:	6442                	ld	s0,16(sp)
    113e:	6161                	addi	sp,sp,80
    1140:	8082                	ret

0000000000001142 <printf>:

void
printf(const char *fmt, ...)
{
    1142:	711d                	addi	sp,sp,-96
    1144:	ec06                	sd	ra,24(sp)
    1146:	e822                	sd	s0,16(sp)
    1148:	1000                	addi	s0,sp,32
    114a:	e40c                	sd	a1,8(s0)
    114c:	e810                	sd	a2,16(s0)
    114e:	ec14                	sd	a3,24(s0)
    1150:	f018                	sd	a4,32(s0)
    1152:	f41c                	sd	a5,40(s0)
    1154:	03043823          	sd	a6,48(s0)
    1158:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    115c:	00840613          	addi	a2,s0,8
    1160:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1164:	85aa                	mv	a1,a0
    1166:	4505                	li	a0,1
    1168:	00000097          	auipc	ra,0x0
    116c:	dce080e7          	jalr	-562(ra) # f36 <vprintf>
}
    1170:	60e2                	ld	ra,24(sp)
    1172:	6442                	ld	s0,16(sp)
    1174:	6125                	addi	sp,sp,96
    1176:	8082                	ret

0000000000001178 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1178:	1141                	addi	sp,sp,-16
    117a:	e422                	sd	s0,8(sp)
    117c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    117e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1182:	00000797          	auipc	a5,0x0
    1186:	69e7b783          	ld	a5,1694(a5) # 1820 <freep>
    118a:	a805                	j	11ba <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    118c:	4618                	lw	a4,8(a2)
    118e:	9db9                	addw	a1,a1,a4
    1190:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1194:	6398                	ld	a4,0(a5)
    1196:	6318                	ld	a4,0(a4)
    1198:	fee53823          	sd	a4,-16(a0)
    119c:	a091                	j	11e0 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    119e:	ff852703          	lw	a4,-8(a0)
    11a2:	9e39                	addw	a2,a2,a4
    11a4:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    11a6:	ff053703          	ld	a4,-16(a0)
    11aa:	e398                	sd	a4,0(a5)
    11ac:	a099                	j	11f2 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11ae:	6398                	ld	a4,0(a5)
    11b0:	00e7e463          	bltu	a5,a4,11b8 <free+0x40>
    11b4:	00e6ea63          	bltu	a3,a4,11c8 <free+0x50>
{
    11b8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11ba:	fed7fae3          	bgeu	a5,a3,11ae <free+0x36>
    11be:	6398                	ld	a4,0(a5)
    11c0:	00e6e463          	bltu	a3,a4,11c8 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11c4:	fee7eae3          	bltu	a5,a4,11b8 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    11c8:	ff852583          	lw	a1,-8(a0)
    11cc:	6390                	ld	a2,0(a5)
    11ce:	02059713          	slli	a4,a1,0x20
    11d2:	9301                	srli	a4,a4,0x20
    11d4:	0712                	slli	a4,a4,0x4
    11d6:	9736                	add	a4,a4,a3
    11d8:	fae60ae3          	beq	a2,a4,118c <free+0x14>
    bp->s.ptr = p->s.ptr;
    11dc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    11e0:	4790                	lw	a2,8(a5)
    11e2:	02061713          	slli	a4,a2,0x20
    11e6:	9301                	srli	a4,a4,0x20
    11e8:	0712                	slli	a4,a4,0x4
    11ea:	973e                	add	a4,a4,a5
    11ec:	fae689e3          	beq	a3,a4,119e <free+0x26>
  } else
    p->s.ptr = bp;
    11f0:	e394                	sd	a3,0(a5)
  freep = p;
    11f2:	00000717          	auipc	a4,0x0
    11f6:	62f73723          	sd	a5,1582(a4) # 1820 <freep>
}
    11fa:	6422                	ld	s0,8(sp)
    11fc:	0141                	addi	sp,sp,16
    11fe:	8082                	ret

0000000000001200 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1200:	7139                	addi	sp,sp,-64
    1202:	fc06                	sd	ra,56(sp)
    1204:	f822                	sd	s0,48(sp)
    1206:	f426                	sd	s1,40(sp)
    1208:	f04a                	sd	s2,32(sp)
    120a:	ec4e                	sd	s3,24(sp)
    120c:	e852                	sd	s4,16(sp)
    120e:	e456                	sd	s5,8(sp)
    1210:	e05a                	sd	s6,0(sp)
    1212:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1214:	02051493          	slli	s1,a0,0x20
    1218:	9081                	srli	s1,s1,0x20
    121a:	04bd                	addi	s1,s1,15
    121c:	8091                	srli	s1,s1,0x4
    121e:	0014899b          	addiw	s3,s1,1
    1222:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1224:	00000517          	auipc	a0,0x0
    1228:	5fc53503          	ld	a0,1532(a0) # 1820 <freep>
    122c:	c515                	beqz	a0,1258 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    122e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1230:	4798                	lw	a4,8(a5)
    1232:	02977f63          	bgeu	a4,s1,1270 <malloc+0x70>
    1236:	8a4e                	mv	s4,s3
    1238:	0009871b          	sext.w	a4,s3
    123c:	6685                	lui	a3,0x1
    123e:	00d77363          	bgeu	a4,a3,1244 <malloc+0x44>
    1242:	6a05                	lui	s4,0x1
    1244:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1248:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    124c:	00000917          	auipc	s2,0x0
    1250:	5d490913          	addi	s2,s2,1492 # 1820 <freep>
  if(p == (char*)-1)
    1254:	5afd                	li	s5,-1
    1256:	a88d                	j	12c8 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    1258:	00000797          	auipc	a5,0x0
    125c:	63878793          	addi	a5,a5,1592 # 1890 <base>
    1260:	00000717          	auipc	a4,0x0
    1264:	5cf73023          	sd	a5,1472(a4) # 1820 <freep>
    1268:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    126a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    126e:	b7e1                	j	1236 <malloc+0x36>
      if(p->s.size == nunits)
    1270:	02e48b63          	beq	s1,a4,12a6 <malloc+0xa6>
        p->s.size -= nunits;
    1274:	4137073b          	subw	a4,a4,s3
    1278:	c798                	sw	a4,8(a5)
        p += p->s.size;
    127a:	1702                	slli	a4,a4,0x20
    127c:	9301                	srli	a4,a4,0x20
    127e:	0712                	slli	a4,a4,0x4
    1280:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1282:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1286:	00000717          	auipc	a4,0x0
    128a:	58a73d23          	sd	a0,1434(a4) # 1820 <freep>
      return (void*)(p + 1);
    128e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1292:	70e2                	ld	ra,56(sp)
    1294:	7442                	ld	s0,48(sp)
    1296:	74a2                	ld	s1,40(sp)
    1298:	7902                	ld	s2,32(sp)
    129a:	69e2                	ld	s3,24(sp)
    129c:	6a42                	ld	s4,16(sp)
    129e:	6aa2                	ld	s5,8(sp)
    12a0:	6b02                	ld	s6,0(sp)
    12a2:	6121                	addi	sp,sp,64
    12a4:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    12a6:	6398                	ld	a4,0(a5)
    12a8:	e118                	sd	a4,0(a0)
    12aa:	bff1                	j	1286 <malloc+0x86>
  hp->s.size = nu;
    12ac:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    12b0:	0541                	addi	a0,a0,16
    12b2:	00000097          	auipc	ra,0x0
    12b6:	ec6080e7          	jalr	-314(ra) # 1178 <free>
  return freep;
    12ba:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    12be:	d971                	beqz	a0,1292 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12c0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    12c2:	4798                	lw	a4,8(a5)
    12c4:	fa9776e3          	bgeu	a4,s1,1270 <malloc+0x70>
    if(p == freep)
    12c8:	00093703          	ld	a4,0(s2)
    12cc:	853e                	mv	a0,a5
    12ce:	fef719e3          	bne	a4,a5,12c0 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    12d2:	8552                	mv	a0,s4
    12d4:	00000097          	auipc	ra,0x0
    12d8:	b76080e7          	jalr	-1162(ra) # e4a <sbrk>
  if(p == (char*)-1)
    12dc:	fd5518e3          	bne	a0,s5,12ac <malloc+0xac>
        return 0;
    12e0:	4501                	li	a0,0
    12e2:	bf45                	j	1292 <malloc+0x92>

00000000000012e4 <Pipe>:
#include "kernel/stat.h"
#include "user.h"
#include "wrapper.h"
int strncmp(const char*s, const char*pat,int n);

int Pipe(int *p) {
    12e4:	1101                	addi	sp,sp,-32
    12e6:	ec06                	sd	ra,24(sp)
    12e8:	e822                	sd	s0,16(sp)
    12ea:	e426                	sd	s1,8(sp)
    12ec:	1000                	addi	s0,sp,32
  i32 res = pipe(p);
    12ee:	00000097          	auipc	ra,0x0
    12f2:	ae4080e7          	jalr	-1308(ra) # dd2 <pipe>
    12f6:	84aa                	mv	s1,a0
  if (res < 0) {
    12f8:	00054863          	bltz	a0,1308 <Pipe+0x24>
    fprintf(2, "pipe creation error");
  }
  return res;
}
    12fc:	8526                	mv	a0,s1
    12fe:	60e2                	ld	ra,24(sp)
    1300:	6442                	ld	s0,16(sp)
    1302:	64a2                	ld	s1,8(sp)
    1304:	6105                	addi	sp,sp,32
    1306:	8082                	ret
    fprintf(2, "pipe creation error");
    1308:	00000597          	auipc	a1,0x0
    130c:	46858593          	addi	a1,a1,1128 # 1770 <digits+0x18>
    1310:	4509                	li	a0,2
    1312:	00000097          	auipc	ra,0x0
    1316:	e02080e7          	jalr	-510(ra) # 1114 <fprintf>
    131a:	b7cd                	j	12fc <Pipe+0x18>

000000000000131c <Write>:

int Write(int fd, void *buf, int count){
    131c:	1141                	addi	sp,sp,-16
    131e:	e406                	sd	ra,8(sp)
    1320:	e022                	sd	s0,0(sp)
    1322:	0800                	addi	s0,sp,16
  i32 res = write(fd, buf, count);
    1324:	00000097          	auipc	ra,0x0
    1328:	abe080e7          	jalr	-1346(ra) # de2 <write>
  if (res < 0) {
    132c:	00054663          	bltz	a0,1338 <Write+0x1c>
    fprintf(2, "write error");
    exit(0);
  }
  return res;
}
    1330:	60a2                	ld	ra,8(sp)
    1332:	6402                	ld	s0,0(sp)
    1334:	0141                	addi	sp,sp,16
    1336:	8082                	ret
    fprintf(2, "write error");
    1338:	00000597          	auipc	a1,0x0
    133c:	45058593          	addi	a1,a1,1104 # 1788 <digits+0x30>
    1340:	4509                	li	a0,2
    1342:	00000097          	auipc	ra,0x0
    1346:	dd2080e7          	jalr	-558(ra) # 1114 <fprintf>
    exit(0);
    134a:	4501                	li	a0,0
    134c:	00000097          	auipc	ra,0x0
    1350:	a76080e7          	jalr	-1418(ra) # dc2 <exit>

0000000000001354 <Read>:



int Read(int fd,  void*buf, int count){
    1354:	1141                	addi	sp,sp,-16
    1356:	e406                	sd	ra,8(sp)
    1358:	e022                	sd	s0,0(sp)
    135a:	0800                	addi	s0,sp,16
  i32 res = read(fd, buf, count);
    135c:	00000097          	auipc	ra,0x0
    1360:	a7e080e7          	jalr	-1410(ra) # dda <read>
  if (res < 0) {
    1364:	00054663          	bltz	a0,1370 <Read+0x1c>
    fprintf(2, "read error");
    exit(0);
  }
  return res;
}
    1368:	60a2                	ld	ra,8(sp)
    136a:	6402                	ld	s0,0(sp)
    136c:	0141                	addi	sp,sp,16
    136e:	8082                	ret
    fprintf(2, "read error");
    1370:	00000597          	auipc	a1,0x0
    1374:	42858593          	addi	a1,a1,1064 # 1798 <digits+0x40>
    1378:	4509                	li	a0,2
    137a:	00000097          	auipc	ra,0x0
    137e:	d9a080e7          	jalr	-614(ra) # 1114 <fprintf>
    exit(0);
    1382:	4501                	li	a0,0
    1384:	00000097          	auipc	ra,0x0
    1388:	a3e080e7          	jalr	-1474(ra) # dc2 <exit>

000000000000138c <Open>:


int Open(const char* path, int flag){
    138c:	1141                	addi	sp,sp,-16
    138e:	e406                	sd	ra,8(sp)
    1390:	e022                	sd	s0,0(sp)
    1392:	0800                	addi	s0,sp,16
  i32 res = open(path, flag);
    1394:	00000097          	auipc	ra,0x0
    1398:	a6e080e7          	jalr	-1426(ra) # e02 <open>
  if (res < 0) {
    139c:	00054663          	bltz	a0,13a8 <Open+0x1c>
    fprintf(2, "open error");
    exit(0);
  }
  return res;
}
    13a0:	60a2                	ld	ra,8(sp)
    13a2:	6402                	ld	s0,0(sp)
    13a4:	0141                	addi	sp,sp,16
    13a6:	8082                	ret
    fprintf(2, "open error");
    13a8:	00000597          	auipc	a1,0x0
    13ac:	40058593          	addi	a1,a1,1024 # 17a8 <digits+0x50>
    13b0:	4509                	li	a0,2
    13b2:	00000097          	auipc	ra,0x0
    13b6:	d62080e7          	jalr	-670(ra) # 1114 <fprintf>
    exit(0);
    13ba:	4501                	li	a0,0
    13bc:	00000097          	auipc	ra,0x0
    13c0:	a06080e7          	jalr	-1530(ra) # dc2 <exit>

00000000000013c4 <Fstat>:


int Fstat(int fd, stat_t *st){
    13c4:	1141                	addi	sp,sp,-16
    13c6:	e406                	sd	ra,8(sp)
    13c8:	e022                	sd	s0,0(sp)
    13ca:	0800                	addi	s0,sp,16
  i32 res = fstat(fd, st);
    13cc:	00000097          	auipc	ra,0x0
    13d0:	a4e080e7          	jalr	-1458(ra) # e1a <fstat>
  if (res < 0) {
    13d4:	00054663          	bltz	a0,13e0 <Fstat+0x1c>
    fprintf(2, "get file stat error");
    exit(0);
  }
  return res;
}
    13d8:	60a2                	ld	ra,8(sp)
    13da:	6402                	ld	s0,0(sp)
    13dc:	0141                	addi	sp,sp,16
    13de:	8082                	ret
    fprintf(2, "get file stat error");
    13e0:	00000597          	auipc	a1,0x0
    13e4:	3d858593          	addi	a1,a1,984 # 17b8 <digits+0x60>
    13e8:	4509                	li	a0,2
    13ea:	00000097          	auipc	ra,0x0
    13ee:	d2a080e7          	jalr	-726(ra) # 1114 <fprintf>
    exit(0);
    13f2:	4501                	li	a0,0
    13f4:	00000097          	auipc	ra,0x0
    13f8:	9ce080e7          	jalr	-1586(ra) # dc2 <exit>

00000000000013fc <Dup>:



int Dup(int fd){
    13fc:	1141                	addi	sp,sp,-16
    13fe:	e406                	sd	ra,8(sp)
    1400:	e022                	sd	s0,0(sp)
    1402:	0800                	addi	s0,sp,16
  i32 res = dup(fd);
    1404:	00000097          	auipc	ra,0x0
    1408:	a36080e7          	jalr	-1482(ra) # e3a <dup>
  if (res < 0) {
    140c:	00054663          	bltz	a0,1418 <Dup+0x1c>
    fprintf(2, "dup error");
    exit(0);
  }
  return res;

}
    1410:	60a2                	ld	ra,8(sp)
    1412:	6402                	ld	s0,0(sp)
    1414:	0141                	addi	sp,sp,16
    1416:	8082                	ret
    fprintf(2, "dup error");
    1418:	00000597          	auipc	a1,0x0
    141c:	3b858593          	addi	a1,a1,952 # 17d0 <digits+0x78>
    1420:	4509                	li	a0,2
    1422:	00000097          	auipc	ra,0x0
    1426:	cf2080e7          	jalr	-782(ra) # 1114 <fprintf>
    exit(0);
    142a:	4501                	li	a0,0
    142c:	00000097          	auipc	ra,0x0
    1430:	996080e7          	jalr	-1642(ra) # dc2 <exit>

0000000000001434 <Close>:

int Close(int fd){
    1434:	1141                	addi	sp,sp,-16
    1436:	e406                	sd	ra,8(sp)
    1438:	e022                	sd	s0,0(sp)
    143a:	0800                	addi	s0,sp,16
  i32 res = close(fd);
    143c:	00000097          	auipc	ra,0x0
    1440:	9ae080e7          	jalr	-1618(ra) # dea <close>
  if (res < 0) {
    1444:	00054663          	bltz	a0,1450 <Close+0x1c>
    fprintf(2, "file close error~");
    exit(0);
  }
  return res;
}
    1448:	60a2                	ld	ra,8(sp)
    144a:	6402                	ld	s0,0(sp)
    144c:	0141                	addi	sp,sp,16
    144e:	8082                	ret
    fprintf(2, "file close error~");
    1450:	00000597          	auipc	a1,0x0
    1454:	39058593          	addi	a1,a1,912 # 17e0 <digits+0x88>
    1458:	4509                	li	a0,2
    145a:	00000097          	auipc	ra,0x0
    145e:	cba080e7          	jalr	-838(ra) # 1114 <fprintf>
    exit(0);
    1462:	4501                	li	a0,0
    1464:	00000097          	auipc	ra,0x0
    1468:	95e080e7          	jalr	-1698(ra) # dc2 <exit>

000000000000146c <Dup2>:

int Dup2(int old_fd,int new_fd){
    146c:	1101                	addi	sp,sp,-32
    146e:	ec06                	sd	ra,24(sp)
    1470:	e822                	sd	s0,16(sp)
    1472:	e426                	sd	s1,8(sp)
    1474:	1000                	addi	s0,sp,32
    1476:	84aa                	mv	s1,a0
  Close(new_fd);
    1478:	852e                	mv	a0,a1
    147a:	00000097          	auipc	ra,0x0
    147e:	fba080e7          	jalr	-70(ra) # 1434 <Close>
  i32 res = Dup(old_fd);
    1482:	8526                	mv	a0,s1
    1484:	00000097          	auipc	ra,0x0
    1488:	f78080e7          	jalr	-136(ra) # 13fc <Dup>
  if (res < 0) {
    148c:	00054763          	bltz	a0,149a <Dup2+0x2e>
    fprintf(2, "dup error");
    exit(0);
  }
  return res;
}
    1490:	60e2                	ld	ra,24(sp)
    1492:	6442                	ld	s0,16(sp)
    1494:	64a2                	ld	s1,8(sp)
    1496:	6105                	addi	sp,sp,32
    1498:	8082                	ret
    fprintf(2, "dup error");
    149a:	00000597          	auipc	a1,0x0
    149e:	33658593          	addi	a1,a1,822 # 17d0 <digits+0x78>
    14a2:	4509                	li	a0,2
    14a4:	00000097          	auipc	ra,0x0
    14a8:	c70080e7          	jalr	-912(ra) # 1114 <fprintf>
    exit(0);
    14ac:	4501                	li	a0,0
    14ae:	00000097          	auipc	ra,0x0
    14b2:	914080e7          	jalr	-1772(ra) # dc2 <exit>

00000000000014b6 <Stat>:

int Stat(const char*link,stat_t *st){
    14b6:	1101                	addi	sp,sp,-32
    14b8:	ec06                	sd	ra,24(sp)
    14ba:	e822                	sd	s0,16(sp)
    14bc:	e426                	sd	s1,8(sp)
    14be:	1000                	addi	s0,sp,32
    14c0:	84aa                	mv	s1,a0
  i32 res = stat(link,st);
    14c2:	fffff097          	auipc	ra,0xfffff
    14c6:	7be080e7          	jalr	1982(ra) # c80 <stat>
  if (res < 0) {
    14ca:	00054763          	bltz	a0,14d8 <Stat+0x22>
    fprintf(2, "file %s stat error",link);
    exit(0);
  }
  return res;
}
    14ce:	60e2                	ld	ra,24(sp)
    14d0:	6442                	ld	s0,16(sp)
    14d2:	64a2                	ld	s1,8(sp)
    14d4:	6105                	addi	sp,sp,32
    14d6:	8082                	ret
    fprintf(2, "file %s stat error",link);
    14d8:	8626                	mv	a2,s1
    14da:	00000597          	auipc	a1,0x0
    14de:	31e58593          	addi	a1,a1,798 # 17f8 <digits+0xa0>
    14e2:	4509                	li	a0,2
    14e4:	00000097          	auipc	ra,0x0
    14e8:	c30080e7          	jalr	-976(ra) # 1114 <fprintf>
    exit(0);
    14ec:	4501                	li	a0,0
    14ee:	00000097          	auipc	ra,0x0
    14f2:	8d4080e7          	jalr	-1836(ra) # dc2 <exit>

00000000000014f6 <strncmp>:
   return -1;
}



int strncmp(const char*s, const char*pat,int n){
    14f6:	bc010113          	addi	sp,sp,-1088
    14fa:	42113c23          	sd	ra,1080(sp)
    14fe:	42813823          	sd	s0,1072(sp)
    1502:	42913423          	sd	s1,1064(sp)
    1506:	43213023          	sd	s2,1056(sp)
    150a:	41313c23          	sd	s3,1048(sp)
    150e:	41413823          	sd	s4,1040(sp)
    1512:	41513423          	sd	s5,1032(sp)
    1516:	44010413          	addi	s0,sp,1088
    151a:	89aa                	mv	s3,a0
    151c:	892e                	mv	s2,a1
    151e:	84b2                	mv	s1,a2
  char buf1[512],buf2[512];
  int n1 = MIN(n,strlen(s));
    1520:	fffff097          	auipc	ra,0xfffff
    1524:	67c080e7          	jalr	1660(ra) # b9c <strlen>
    1528:	2501                	sext.w	a0,a0
    152a:	00048a1b          	sext.w	s4,s1
    152e:	8aa6                	mv	s5,s1
    1530:	06aa7363          	bgeu	s4,a0,1596 <strncmp+0xa0>
  int n2 = MIN(n,strlen(pat));
    1534:	854a                	mv	a0,s2
    1536:	fffff097          	auipc	ra,0xfffff
    153a:	666080e7          	jalr	1638(ra) # b9c <strlen>
    153e:	2501                	sext.w	a0,a0
    1540:	06aa7363          	bgeu	s4,a0,15a6 <strncmp+0xb0>
  memmove(buf1,s,n1);
    1544:	8656                	mv	a2,s5
    1546:	85ce                	mv	a1,s3
    1548:	dc040513          	addi	a0,s0,-576
    154c:	fffff097          	auipc	ra,0xfffff
    1550:	7c4080e7          	jalr	1988(ra) # d10 <memmove>
  memmove(buf2,pat,n2);
    1554:	8626                	mv	a2,s1
    1556:	85ca                	mv	a1,s2
    1558:	bc040513          	addi	a0,s0,-1088
    155c:	fffff097          	auipc	ra,0xfffff
    1560:	7b4080e7          	jalr	1972(ra) # d10 <memmove>
  return strcmp(buf1,buf2);
    1564:	bc040593          	addi	a1,s0,-1088
    1568:	dc040513          	addi	a0,s0,-576
    156c:	fffff097          	auipc	ra,0xfffff
    1570:	604080e7          	jalr	1540(ra) # b70 <strcmp>
}
    1574:	43813083          	ld	ra,1080(sp)
    1578:	43013403          	ld	s0,1072(sp)
    157c:	42813483          	ld	s1,1064(sp)
    1580:	42013903          	ld	s2,1056(sp)
    1584:	41813983          	ld	s3,1048(sp)
    1588:	41013a03          	ld	s4,1040(sp)
    158c:	40813a83          	ld	s5,1032(sp)
    1590:	44010113          	addi	sp,sp,1088
    1594:	8082                	ret
  int n1 = MIN(n,strlen(s));
    1596:	854e                	mv	a0,s3
    1598:	fffff097          	auipc	ra,0xfffff
    159c:	604080e7          	jalr	1540(ra) # b9c <strlen>
    15a0:	00050a9b          	sext.w	s5,a0
    15a4:	bf41                	j	1534 <strncmp+0x3e>
  int n2 = MIN(n,strlen(pat));
    15a6:	854a                	mv	a0,s2
    15a8:	fffff097          	auipc	ra,0xfffff
    15ac:	5f4080e7          	jalr	1524(ra) # b9c <strlen>
    15b0:	0005049b          	sext.w	s1,a0
    15b4:	bf41                	j	1544 <strncmp+0x4e>

00000000000015b6 <strstr>:
   while (*s != 0){
    15b6:	00054783          	lbu	a5,0(a0)
    15ba:	cba1                	beqz	a5,160a <strstr+0x54>
int strstr(char *s,char *p){
    15bc:	7179                	addi	sp,sp,-48
    15be:	f406                	sd	ra,40(sp)
    15c0:	f022                	sd	s0,32(sp)
    15c2:	ec26                	sd	s1,24(sp)
    15c4:	e84a                	sd	s2,16(sp)
    15c6:	e44e                	sd	s3,8(sp)
    15c8:	1800                	addi	s0,sp,48
    15ca:	89aa                	mv	s3,a0
    15cc:	892e                	mv	s2,a1
   while (*s != 0){
    15ce:	84aa                	mv	s1,a0
     if (!strncmp(s,p,strlen(p)))
    15d0:	854a                	mv	a0,s2
    15d2:	fffff097          	auipc	ra,0xfffff
    15d6:	5ca080e7          	jalr	1482(ra) # b9c <strlen>
    15da:	0005061b          	sext.w	a2,a0
    15de:	85ca                	mv	a1,s2
    15e0:	8526                	mv	a0,s1
    15e2:	00000097          	auipc	ra,0x0
    15e6:	f14080e7          	jalr	-236(ra) # 14f6 <strncmp>
    15ea:	c519                	beqz	a0,15f8 <strstr+0x42>
     s++;
    15ec:	0485                	addi	s1,s1,1
   while (*s != 0){
    15ee:	0004c783          	lbu	a5,0(s1)
    15f2:	fff9                	bnez	a5,15d0 <strstr+0x1a>
   return -1;
    15f4:	557d                	li	a0,-1
    15f6:	a019                	j	15fc <strstr+0x46>
      return s - ori;
    15f8:	4134853b          	subw	a0,s1,s3
}
    15fc:	70a2                	ld	ra,40(sp)
    15fe:	7402                	ld	s0,32(sp)
    1600:	64e2                	ld	s1,24(sp)
    1602:	6942                	ld	s2,16(sp)
    1604:	69a2                	ld	s3,8(sp)
    1606:	6145                	addi	sp,sp,48
    1608:	8082                	ret
   return -1;
    160a:	557d                	li	a0,-1
}
    160c:	8082                	ret
