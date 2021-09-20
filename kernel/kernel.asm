
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	84010113          	addi	sp,sp,-1984 # 80009840 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	070000ef          	jal	ra,80000086 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
    80000022:	f14027f3          	csrr	a5,mhartid
    80000026:	0037969b          	slliw	a3,a5,0x3
    8000002a:	02004737          	lui	a4,0x2004
    8000002e:	96ba                	add	a3,a3,a4
    80000030:	0200c737          	lui	a4,0x200c
    80000034:	ff873603          	ld	a2,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80000038:	000f4737          	lui	a4,0xf4
    8000003c:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000040:	963a                	add	a2,a2,a4
    80000042:	e290                	sd	a2,0(a3)
    80000044:	0057979b          	slliw	a5,a5,0x5
    80000048:	078e                	slli	a5,a5,0x3
    8000004a:	00009617          	auipc	a2,0x9
    8000004e:	ff660613          	addi	a2,a2,-10 # 80009040 <mscratch0>
    80000052:	97b2                	add	a5,a5,a2
    80000054:	f394                	sd	a3,32(a5)
    80000056:	f798                	sd	a4,40(a5)
    80000058:	34079073          	csrw	mscratch,a5
    8000005c:	00006797          	auipc	a5,0x6
    80000060:	14478793          	addi	a5,a5,324 # 800061a0 <timervec>
    80000064:	30579073          	csrw	mtvec,a5
    80000068:	300027f3          	csrr	a5,mstatus
    8000006c:	0087e793          	ori	a5,a5,8
    80000070:	30079073          	csrw	mstatus,a5
    80000074:	304027f3          	csrr	a5,mie
    80000078:	0807e793          	ori	a5,a5,128
    8000007c:	30479073          	csrw	mie,a5
    80000080:	6422                	ld	s0,8(sp)
    80000082:	0141                	addi	sp,sp,16
    80000084:	8082                	ret

0000000080000086 <start>:
    80000086:	1141                	addi	sp,sp,-16
    80000088:	e406                	sd	ra,8(sp)
    8000008a:	e022                	sd	s0,0(sp)
    8000008c:	0800                	addi	s0,sp,16
    8000008e:	300027f3          	csrr	a5,mstatus
    80000092:	7779                	lui	a4,0xffffe
    80000094:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffb87ff>
    80000098:	8ff9                	and	a5,a5,a4
    8000009a:	6705                	lui	a4,0x1
    8000009c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a0:	8fd9                	or	a5,a5,a4
    800000a2:	30079073          	csrw	mstatus,a5
    800000a6:	00001797          	auipc	a5,0x1
    800000aa:	18278793          	addi	a5,a5,386 # 80001228 <main>
    800000ae:	34179073          	csrw	mepc,a5
    800000b2:	4781                	li	a5,0
    800000b4:	18079073          	csrw	satp,a5
    800000b8:	67c1                	lui	a5,0x10
    800000ba:	17fd                	addi	a5,a5,-1
    800000bc:	30279073          	csrw	medeleg,a5
    800000c0:	30379073          	csrw	mideleg,a5
    800000c4:	104027f3          	csrr	a5,sie
    800000c8:	2227e793          	ori	a5,a5,546
    800000cc:	10479073          	csrw	sie,a5
    800000d0:	00000097          	auipc	ra,0x0
    800000d4:	f4c080e7          	jalr	-180(ra) # 8000001c <timerinit>
    800000d8:	f14027f3          	csrr	a5,mhartid
    800000dc:	2781                	sext.w	a5,a5
    800000de:	823e                	mv	tp,a5
    800000e0:	30200073          	mret
    800000e4:	60a2                	ld	ra,8(sp)
    800000e6:	6402                	ld	s0,0(sp)
    800000e8:	0141                	addi	sp,sp,16
    800000ea:	8082                	ret

00000000800000ec <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000ec:	715d                	addi	sp,sp,-80
    800000ee:	e486                	sd	ra,72(sp)
    800000f0:	e0a2                	sd	s0,64(sp)
    800000f2:	fc26                	sd	s1,56(sp)
    800000f4:	f84a                	sd	s2,48(sp)
    800000f6:	f44e                	sd	s3,40(sp)
    800000f8:	f052                	sd	s4,32(sp)
    800000fa:	ec56                	sd	s5,24(sp)
    800000fc:	0880                	addi	s0,sp,80
    800000fe:	8a2a                	mv	s4,a0
    80000100:	84ae                	mv	s1,a1
    80000102:	89b2                	mv	s3,a2
  int i;

  acquire(&cons.lock);
    80000104:	00011517          	auipc	a0,0x11
    80000108:	73c50513          	addi	a0,a0,1852 # 80011840 <cons>
    8000010c:	00001097          	auipc	ra,0x1
    80000110:	e72080e7          	jalr	-398(ra) # 80000f7e <acquire>
  for(i = 0; i < n; i++){
    80000114:	05305c63          	blez	s3,8000016c <consolewrite+0x80>
    80000118:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000011a:	5afd                	li	s5,-1
    8000011c:	4685                	li	a3,1
    8000011e:	8626                	mv	a2,s1
    80000120:	85d2                	mv	a1,s4
    80000122:	fbf40513          	addi	a0,s0,-65
    80000126:	00003097          	auipc	ra,0x3
    8000012a:	89c080e7          	jalr	-1892(ra) # 800029c2 <either_copyin>
    8000012e:	01550d63          	beq	a0,s5,80000148 <consolewrite+0x5c>
      break;
    uartputc(c);
    80000132:	fbf44503          	lbu	a0,-65(s0)
    80000136:	00001097          	auipc	ra,0x1
    8000013a:	812080e7          	jalr	-2030(ra) # 80000948 <uartputc>
  for(i = 0; i < n; i++){
    8000013e:	2905                	addiw	s2,s2,1
    80000140:	0485                	addi	s1,s1,1
    80000142:	fd299de3          	bne	s3,s2,8000011c <consolewrite+0x30>
    80000146:	894e                	mv	s2,s3
  }
  release(&cons.lock);
    80000148:	00011517          	auipc	a0,0x11
    8000014c:	6f850513          	addi	a0,a0,1784 # 80011840 <cons>
    80000150:	00001097          	auipc	ra,0x1
    80000154:	ee2080e7          	jalr	-286(ra) # 80001032 <release>

  return i;
}
    80000158:	854a                	mv	a0,s2
    8000015a:	60a6                	ld	ra,72(sp)
    8000015c:	6406                	ld	s0,64(sp)
    8000015e:	74e2                	ld	s1,56(sp)
    80000160:	7942                	ld	s2,48(sp)
    80000162:	79a2                	ld	s3,40(sp)
    80000164:	7a02                	ld	s4,32(sp)
    80000166:	6ae2                	ld	s5,24(sp)
    80000168:	6161                	addi	sp,sp,80
    8000016a:	8082                	ret
  for(i = 0; i < n; i++){
    8000016c:	4901                	li	s2,0
    8000016e:	bfe9                	j	80000148 <consolewrite+0x5c>

0000000080000170 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000170:	7159                	addi	sp,sp,-112
    80000172:	f486                	sd	ra,104(sp)
    80000174:	f0a2                	sd	s0,96(sp)
    80000176:	eca6                	sd	s1,88(sp)
    80000178:	e8ca                	sd	s2,80(sp)
    8000017a:	e4ce                	sd	s3,72(sp)
    8000017c:	e0d2                	sd	s4,64(sp)
    8000017e:	fc56                	sd	s5,56(sp)
    80000180:	f85a                	sd	s6,48(sp)
    80000182:	f45e                	sd	s7,40(sp)
    80000184:	f062                	sd	s8,32(sp)
    80000186:	ec66                	sd	s9,24(sp)
    80000188:	e86a                	sd	s10,16(sp)
    8000018a:	1880                	addi	s0,sp,112
    8000018c:	8aaa                	mv	s5,a0
    8000018e:	8a2e                	mv	s4,a1
    80000190:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000192:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000196:	00011517          	auipc	a0,0x11
    8000019a:	6aa50513          	addi	a0,a0,1706 # 80011840 <cons>
    8000019e:	00001097          	auipc	ra,0x1
    800001a2:	de0080e7          	jalr	-544(ra) # 80000f7e <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800001a6:	00011497          	auipc	s1,0x11
    800001aa:	69a48493          	addi	s1,s1,1690 # 80011840 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001ae:	00011917          	auipc	s2,0x11
    800001b2:	72a90913          	addi	s2,s2,1834 # 800118d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800001b6:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001b8:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001ba:	4ca9                	li	s9,10
  while(n > 0){
    800001bc:	07305863          	blez	s3,8000022c <consoleread+0xbc>
    while(cons.r == cons.w){
    800001c0:	0984a783          	lw	a5,152(s1)
    800001c4:	09c4a703          	lw	a4,156(s1)
    800001c8:	02f71463          	bne	a4,a5,800001f0 <consoleread+0x80>
      if(myproc()->killed){
    800001cc:	00002097          	auipc	ra,0x2
    800001d0:	d32080e7          	jalr	-718(ra) # 80001efe <myproc>
    800001d4:	591c                	lw	a5,48(a0)
    800001d6:	e7b5                	bnez	a5,80000242 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    800001d8:	85a6                	mv	a1,s1
    800001da:	854a                	mv	a0,s2
    800001dc:	00002097          	auipc	ra,0x2
    800001e0:	536080e7          	jalr	1334(ra) # 80002712 <sleep>
    while(cons.r == cons.w){
    800001e4:	0984a783          	lw	a5,152(s1)
    800001e8:	09c4a703          	lw	a4,156(s1)
    800001ec:	fef700e3          	beq	a4,a5,800001cc <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800001f0:	0017871b          	addiw	a4,a5,1
    800001f4:	08e4ac23          	sw	a4,152(s1)
    800001f8:	07f7f713          	andi	a4,a5,127
    800001fc:	9726                	add	a4,a4,s1
    800001fe:	01874703          	lbu	a4,24(a4)
    80000202:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80000206:	077d0563          	beq	s10,s7,80000270 <consoleread+0x100>
    cbuf = c;
    8000020a:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000020e:	4685                	li	a3,1
    80000210:	f9f40613          	addi	a2,s0,-97
    80000214:	85d2                	mv	a1,s4
    80000216:	8556                	mv	a0,s5
    80000218:	00002097          	auipc	ra,0x2
    8000021c:	754080e7          	jalr	1876(ra) # 8000296c <either_copyout>
    80000220:	01850663          	beq	a0,s8,8000022c <consoleread+0xbc>
    dst++;
    80000224:	0a05                	addi	s4,s4,1
    --n;
    80000226:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80000228:	f99d1ae3          	bne	s10,s9,800001bc <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    8000022c:	00011517          	auipc	a0,0x11
    80000230:	61450513          	addi	a0,a0,1556 # 80011840 <cons>
    80000234:	00001097          	auipc	ra,0x1
    80000238:	dfe080e7          	jalr	-514(ra) # 80001032 <release>

  return target - n;
    8000023c:	413b053b          	subw	a0,s6,s3
    80000240:	a811                	j	80000254 <consoleread+0xe4>
        release(&cons.lock);
    80000242:	00011517          	auipc	a0,0x11
    80000246:	5fe50513          	addi	a0,a0,1534 # 80011840 <cons>
    8000024a:	00001097          	auipc	ra,0x1
    8000024e:	de8080e7          	jalr	-536(ra) # 80001032 <release>
        return -1;
    80000252:	557d                	li	a0,-1
}
    80000254:	70a6                	ld	ra,104(sp)
    80000256:	7406                	ld	s0,96(sp)
    80000258:	64e6                	ld	s1,88(sp)
    8000025a:	6946                	ld	s2,80(sp)
    8000025c:	69a6                	ld	s3,72(sp)
    8000025e:	6a06                	ld	s4,64(sp)
    80000260:	7ae2                	ld	s5,56(sp)
    80000262:	7b42                	ld	s6,48(sp)
    80000264:	7ba2                	ld	s7,40(sp)
    80000266:	7c02                	ld	s8,32(sp)
    80000268:	6ce2                	ld	s9,24(sp)
    8000026a:	6d42                	ld	s10,16(sp)
    8000026c:	6165                	addi	sp,sp,112
    8000026e:	8082                	ret
      if(n < target){
    80000270:	0009871b          	sext.w	a4,s3
    80000274:	fb677ce3          	bgeu	a4,s6,8000022c <consoleread+0xbc>
        cons.r--;
    80000278:	00011717          	auipc	a4,0x11
    8000027c:	66f72023          	sw	a5,1632(a4) # 800118d8 <cons+0x98>
    80000280:	b775                	j	8000022c <consoleread+0xbc>

0000000080000282 <consputc>:
{
    80000282:	1141                	addi	sp,sp,-16
    80000284:	e406                	sd	ra,8(sp)
    80000286:	e022                	sd	s0,0(sp)
    80000288:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000028a:	10000793          	li	a5,256
    8000028e:	00f50a63          	beq	a0,a5,800002a2 <consputc+0x20>
    uartputc_sync(c);
    80000292:	00000097          	auipc	ra,0x0
    80000296:	5d8080e7          	jalr	1496(ra) # 8000086a <uartputc_sync>
}
    8000029a:	60a2                	ld	ra,8(sp)
    8000029c:	6402                	ld	s0,0(sp)
    8000029e:	0141                	addi	sp,sp,16
    800002a0:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800002a2:	4521                	li	a0,8
    800002a4:	00000097          	auipc	ra,0x0
    800002a8:	5c6080e7          	jalr	1478(ra) # 8000086a <uartputc_sync>
    800002ac:	02000513          	li	a0,32
    800002b0:	00000097          	auipc	ra,0x0
    800002b4:	5ba080e7          	jalr	1466(ra) # 8000086a <uartputc_sync>
    800002b8:	4521                	li	a0,8
    800002ba:	00000097          	auipc	ra,0x0
    800002be:	5b0080e7          	jalr	1456(ra) # 8000086a <uartputc_sync>
    800002c2:	bfe1                	j	8000029a <consputc+0x18>

00000000800002c4 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002c4:	1101                	addi	sp,sp,-32
    800002c6:	ec06                	sd	ra,24(sp)
    800002c8:	e822                	sd	s0,16(sp)
    800002ca:	e426                	sd	s1,8(sp)
    800002cc:	e04a                	sd	s2,0(sp)
    800002ce:	1000                	addi	s0,sp,32
    800002d0:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002d2:	00011517          	auipc	a0,0x11
    800002d6:	56e50513          	addi	a0,a0,1390 # 80011840 <cons>
    800002da:	00001097          	auipc	ra,0x1
    800002de:	ca4080e7          	jalr	-860(ra) # 80000f7e <acquire>

  switch(c){
    800002e2:	47d5                	li	a5,21
    800002e4:	0af48663          	beq	s1,a5,80000390 <consoleintr+0xcc>
    800002e8:	0297ca63          	blt	a5,s1,8000031c <consoleintr+0x58>
    800002ec:	47a1                	li	a5,8
    800002ee:	0ef48763          	beq	s1,a5,800003dc <consoleintr+0x118>
    800002f2:	47c1                	li	a5,16
    800002f4:	10f49a63          	bne	s1,a5,80000408 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002f8:	00002097          	auipc	ra,0x2
    800002fc:	720080e7          	jalr	1824(ra) # 80002a18 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80000300:	00011517          	auipc	a0,0x11
    80000304:	54050513          	addi	a0,a0,1344 # 80011840 <cons>
    80000308:	00001097          	auipc	ra,0x1
    8000030c:	d2a080e7          	jalr	-726(ra) # 80001032 <release>
}
    80000310:	60e2                	ld	ra,24(sp)
    80000312:	6442                	ld	s0,16(sp)
    80000314:	64a2                	ld	s1,8(sp)
    80000316:	6902                	ld	s2,0(sp)
    80000318:	6105                	addi	sp,sp,32
    8000031a:	8082                	ret
  switch(c){
    8000031c:	07f00793          	li	a5,127
    80000320:	0af48e63          	beq	s1,a5,800003dc <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000324:	00011717          	auipc	a4,0x11
    80000328:	51c70713          	addi	a4,a4,1308 # 80011840 <cons>
    8000032c:	0a072783          	lw	a5,160(a4)
    80000330:	09872703          	lw	a4,152(a4)
    80000334:	9f99                	subw	a5,a5,a4
    80000336:	07f00713          	li	a4,127
    8000033a:	fcf763e3          	bltu	a4,a5,80000300 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    8000033e:	47b5                	li	a5,13
    80000340:	0cf48763          	beq	s1,a5,8000040e <consoleintr+0x14a>
      consputc(c);
    80000344:	8526                	mv	a0,s1
    80000346:	00000097          	auipc	ra,0x0
    8000034a:	f3c080e7          	jalr	-196(ra) # 80000282 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    8000034e:	00011797          	auipc	a5,0x11
    80000352:	4f278793          	addi	a5,a5,1266 # 80011840 <cons>
    80000356:	0a07a703          	lw	a4,160(a5)
    8000035a:	0017069b          	addiw	a3,a4,1
    8000035e:	0006861b          	sext.w	a2,a3
    80000362:	0ad7a023          	sw	a3,160(a5)
    80000366:	07f77713          	andi	a4,a4,127
    8000036a:	97ba                	add	a5,a5,a4
    8000036c:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80000370:	47a9                	li	a5,10
    80000372:	0cf48563          	beq	s1,a5,8000043c <consoleintr+0x178>
    80000376:	4791                	li	a5,4
    80000378:	0cf48263          	beq	s1,a5,8000043c <consoleintr+0x178>
    8000037c:	00011797          	auipc	a5,0x11
    80000380:	55c7a783          	lw	a5,1372(a5) # 800118d8 <cons+0x98>
    80000384:	0807879b          	addiw	a5,a5,128
    80000388:	f6f61ce3          	bne	a2,a5,80000300 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    8000038c:	863e                	mv	a2,a5
    8000038e:	a07d                	j	8000043c <consoleintr+0x178>
    while(cons.e != cons.w &&
    80000390:	00011717          	auipc	a4,0x11
    80000394:	4b070713          	addi	a4,a4,1200 # 80011840 <cons>
    80000398:	0a072783          	lw	a5,160(a4)
    8000039c:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003a0:	00011497          	auipc	s1,0x11
    800003a4:	4a048493          	addi	s1,s1,1184 # 80011840 <cons>
    while(cons.e != cons.w &&
    800003a8:	4929                	li	s2,10
    800003aa:	f4f70be3          	beq	a4,a5,80000300 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003ae:	37fd                	addiw	a5,a5,-1
    800003b0:	07f7f713          	andi	a4,a5,127
    800003b4:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003b6:	01874703          	lbu	a4,24(a4)
    800003ba:	f52703e3          	beq	a4,s2,80000300 <consoleintr+0x3c>
      cons.e--;
    800003be:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003c2:	10000513          	li	a0,256
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	ebc080e7          	jalr	-324(ra) # 80000282 <consputc>
    while(cons.e != cons.w &&
    800003ce:	0a04a783          	lw	a5,160(s1)
    800003d2:	09c4a703          	lw	a4,156(s1)
    800003d6:	fcf71ce3          	bne	a4,a5,800003ae <consoleintr+0xea>
    800003da:	b71d                	j	80000300 <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003dc:	00011717          	auipc	a4,0x11
    800003e0:	46470713          	addi	a4,a4,1124 # 80011840 <cons>
    800003e4:	0a072783          	lw	a5,160(a4)
    800003e8:	09c72703          	lw	a4,156(a4)
    800003ec:	f0f70ae3          	beq	a4,a5,80000300 <consoleintr+0x3c>
      cons.e--;
    800003f0:	37fd                	addiw	a5,a5,-1
    800003f2:	00011717          	auipc	a4,0x11
    800003f6:	4ef72723          	sw	a5,1262(a4) # 800118e0 <cons+0xa0>
      consputc(BACKSPACE);
    800003fa:	10000513          	li	a0,256
    800003fe:	00000097          	auipc	ra,0x0
    80000402:	e84080e7          	jalr	-380(ra) # 80000282 <consputc>
    80000406:	bded                	j	80000300 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000408:	ee048ce3          	beqz	s1,80000300 <consoleintr+0x3c>
    8000040c:	bf21                	j	80000324 <consoleintr+0x60>
      consputc(c);
    8000040e:	4529                	li	a0,10
    80000410:	00000097          	auipc	ra,0x0
    80000414:	e72080e7          	jalr	-398(ra) # 80000282 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000418:	00011797          	auipc	a5,0x11
    8000041c:	42878793          	addi	a5,a5,1064 # 80011840 <cons>
    80000420:	0a07a703          	lw	a4,160(a5)
    80000424:	0017069b          	addiw	a3,a4,1
    80000428:	0006861b          	sext.w	a2,a3
    8000042c:	0ad7a023          	sw	a3,160(a5)
    80000430:	07f77713          	andi	a4,a4,127
    80000434:	97ba                	add	a5,a5,a4
    80000436:	4729                	li	a4,10
    80000438:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000043c:	00011797          	auipc	a5,0x11
    80000440:	4ac7a023          	sw	a2,1184(a5) # 800118dc <cons+0x9c>
        wakeup(&cons.r);
    80000444:	00011517          	auipc	a0,0x11
    80000448:	49450513          	addi	a0,a0,1172 # 800118d8 <cons+0x98>
    8000044c:	00002097          	auipc	ra,0x2
    80000450:	446080e7          	jalr	1094(ra) # 80002892 <wakeup>
    80000454:	b575                	j	80000300 <consoleintr+0x3c>

0000000080000456 <consoleinit>:

void
consoleinit(void)
{
    80000456:	1141                	addi	sp,sp,-16
    80000458:	e406                	sd	ra,8(sp)
    8000045a:	e022                	sd	s0,0(sp)
    8000045c:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000045e:	00008597          	auipc	a1,0x8
    80000462:	bb258593          	addi	a1,a1,-1102 # 80008010 <etext+0x10>
    80000466:	00011517          	auipc	a0,0x11
    8000046a:	3da50513          	addi	a0,a0,986 # 80011840 <cons>
    8000046e:	00001097          	auipc	ra,0x1
    80000472:	a80080e7          	jalr	-1408(ra) # 80000eee <initlock>

  uartinit();
    80000476:	00000097          	auipc	ra,0x0
    8000047a:	3a4080e7          	jalr	932(ra) # 8000081a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000047e:	00041797          	auipc	a5,0x41
    80000482:	69278793          	addi	a5,a5,1682 # 80041b10 <devsw>
    80000486:	00000717          	auipc	a4,0x0
    8000048a:	cea70713          	addi	a4,a4,-790 # 80000170 <consoleread>
    8000048e:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000490:	00000717          	auipc	a4,0x0
    80000494:	c5c70713          	addi	a4,a4,-932 # 800000ec <consolewrite>
    80000498:	ef98                	sd	a4,24(a5)
}
    8000049a:	60a2                	ld	ra,8(sp)
    8000049c:	6402                	ld	s0,0(sp)
    8000049e:	0141                	addi	sp,sp,16
    800004a0:	8082                	ret

00000000800004a2 <printint>:
  int locking;
} pr;

static char digits[] = "0123456789abcdef";

static void printint(int xx, int base, int sign) {
    800004a2:	7179                	addi	sp,sp,-48
    800004a4:	f406                	sd	ra,40(sp)
    800004a6:	f022                	sd	s0,32(sp)
    800004a8:	ec26                	sd	s1,24(sp)
    800004aa:	e84a                	sd	s2,16(sp)
    800004ac:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if (sign && (sign = xx < 0))
    800004ae:	c219                	beqz	a2,800004b4 <printint+0x12>
    800004b0:	08054763          	bltz	a0,8000053e <printint+0x9c>
    x = -xx;
  else
    x = xx;
    800004b4:	2501                	sext.w	a0,a0
    800004b6:	4881                	li	a7,0
    800004b8:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004bc:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004be:	2581                	sext.w	a1,a1
    800004c0:	00008617          	auipc	a2,0x8
    800004c4:	ba860613          	addi	a2,a2,-1112 # 80008068 <digits>
    800004c8:	883a                	mv	a6,a4
    800004ca:	2705                	addiw	a4,a4,1
    800004cc:	02b577bb          	remuw	a5,a0,a1
    800004d0:	1782                	slli	a5,a5,0x20
    800004d2:	9381                	srli	a5,a5,0x20
    800004d4:	97b2                	add	a5,a5,a2
    800004d6:	0007c783          	lbu	a5,0(a5)
    800004da:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    800004de:	0005079b          	sext.w	a5,a0
    800004e2:	02b5553b          	divuw	a0,a0,a1
    800004e6:	0685                	addi	a3,a3,1
    800004e8:	feb7f0e3          	bgeu	a5,a1,800004c8 <printint+0x26>

  if (sign)
    800004ec:	00088c63          	beqz	a7,80000504 <printint+0x62>
    buf[i++] = '-';
    800004f0:	fe070793          	addi	a5,a4,-32
    800004f4:	00878733          	add	a4,a5,s0
    800004f8:	02d00793          	li	a5,45
    800004fc:	fef70823          	sb	a5,-16(a4)
    80000500:	0028071b          	addiw	a4,a6,2

  while (--i >= 0)
    80000504:	02e05763          	blez	a4,80000532 <printint+0x90>
    80000508:	fd040793          	addi	a5,s0,-48
    8000050c:	00e784b3          	add	s1,a5,a4
    80000510:	fff78913          	addi	s2,a5,-1
    80000514:	993a                	add	s2,s2,a4
    80000516:	377d                	addiw	a4,a4,-1
    80000518:	1702                	slli	a4,a4,0x20
    8000051a:	9301                	srli	a4,a4,0x20
    8000051c:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000520:	fff4c503          	lbu	a0,-1(s1)
    80000524:	00000097          	auipc	ra,0x0
    80000528:	d5e080e7          	jalr	-674(ra) # 80000282 <consputc>
  while (--i >= 0)
    8000052c:	14fd                	addi	s1,s1,-1
    8000052e:	ff2499e3          	bne	s1,s2,80000520 <printint+0x7e>
}
    80000532:	70a2                	ld	ra,40(sp)
    80000534:	7402                	ld	s0,32(sp)
    80000536:	64e2                	ld	s1,24(sp)
    80000538:	6942                	ld	s2,16(sp)
    8000053a:	6145                	addi	sp,sp,48
    8000053c:	8082                	ret
    x = -xx;
    8000053e:	40a0053b          	negw	a0,a0
  if (sign && (sign = xx < 0))
    80000542:	4885                	li	a7,1
    x = -xx;
    80000544:	bf95                	j	800004b8 <printint+0x16>

0000000080000546 <printfinit>:
  panicked = 1; // freeze uart output from other CPUs
  for (;;)
    ;
}

void printfinit(void) {
    80000546:	1101                	addi	sp,sp,-32
    80000548:	ec06                	sd	ra,24(sp)
    8000054a:	e822                	sd	s0,16(sp)
    8000054c:	e426                	sd	s1,8(sp)
    8000054e:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80000550:	00011497          	auipc	s1,0x11
    80000554:	39848493          	addi	s1,s1,920 # 800118e8 <pr>
    80000558:	00008597          	auipc	a1,0x8
    8000055c:	ac058593          	addi	a1,a1,-1344 # 80008018 <etext+0x18>
    80000560:	8526                	mv	a0,s1
    80000562:	00001097          	auipc	ra,0x1
    80000566:	98c080e7          	jalr	-1652(ra) # 80000eee <initlock>
  pr.locking = 1;
    8000056a:	4785                	li	a5,1
    8000056c:	cc9c                	sw	a5,24(s1)
}
    8000056e:	60e2                	ld	ra,24(sp)
    80000570:	6442                	ld	s0,16(sp)
    80000572:	64a2                	ld	s1,8(sp)
    80000574:	6105                	addi	sp,sp,32
    80000576:	8082                	ret

0000000080000578 <backtrace>:

void backtrace() {
    80000578:	7179                	addi	sp,sp,-48
    8000057a:	f406                	sd	ra,40(sp)
    8000057c:	f022                	sd	s0,32(sp)
    8000057e:	ec26                	sd	s1,24(sp)
    80000580:	e84a                	sd	s2,16(sp)
    80000582:	e44e                	sd	s3,8(sp)
    80000584:	e052                	sd	s4,0(sp)
    80000586:	1800                	addi	s0,sp,48
typedef uint64 pte_t;
typedef uint64 *pagetable_t; // 512 PTEs

static inline uint64 r_fp() {
  uint64 x;
  asm volatile("mv %0, s0" : "=r"(x));
    80000588:	8722                	mv	a4,s0
  uint64 sp = r_fp();
  char *s = (char *)sp;
  uint64 stack_base = PGROUNDUP(sp);
    8000058a:	6905                	lui	s2,0x1
    8000058c:	197d                	addi	s2,s2,-1
    8000058e:	993a                	add	s2,s2,a4
    80000590:	79fd                	lui	s3,0xfffff
    80000592:	01397933          	and	s2,s2,s3
  uint64 stack_up = PGROUNDDOWN(sp);
    80000596:	013779b3          	and	s3,a4,s3
  if (!(sp >= stack_up && sp <= stack_base)) {
    8000059a:	01376963          	bltu	a4,s3,800005ac <backtrace+0x34>
    8000059e:	87ba                	mv	a5,a4
  uint64 ra;
  while ((uint64)s <= stack_base && (uint64)s >= stack_up) {
    ra = *(uint64 *)(s - 8);
    s = (char *)*(uint64 *)(s - 16);
    if (((uint64)s <= stack_base && (uint64)s >= stack_up))
      printf("%p\n", ra);
    800005a0:	00008a17          	auipc	s4,0x8
    800005a4:	aa0a0a13          	addi	s4,s4,-1376 # 80008040 <etext+0x40>
  if (!(sp >= stack_up && sp <= stack_base)) {
    800005a8:	02e97263          	bgeu	s2,a4,800005cc <backtrace+0x54>
    panic("invalid stack frame pointer");
    800005ac:	00008517          	auipc	a0,0x8
    800005b0:	a7450513          	addi	a0,a0,-1420 # 80008020 <etext+0x20>
    800005b4:	00000097          	auipc	ra,0x0
    800005b8:	034080e7          	jalr	52(ra) # 800005e8 <panic>
      printf("%p\n", ra);
    800005bc:	ff87b583          	ld	a1,-8(a5)
    800005c0:	8552                	mv	a0,s4
    800005c2:	00000097          	auipc	ra,0x0
    800005c6:	078080e7          	jalr	120(ra) # 8000063a <printf>
    800005ca:	87a6                	mv	a5,s1
    s = (char *)*(uint64 *)(s - 16);
    800005cc:	ff07b483          	ld	s1,-16(a5)
    if (((uint64)s <= stack_base && (uint64)s >= stack_up))
    800005d0:	00996463          	bltu	s2,s1,800005d8 <backtrace+0x60>
    800005d4:	ff34f4e3          	bgeu	s1,s3,800005bc <backtrace+0x44>
  }
    800005d8:	70a2                	ld	ra,40(sp)
    800005da:	7402                	ld	s0,32(sp)
    800005dc:	64e2                	ld	s1,24(sp)
    800005de:	6942                	ld	s2,16(sp)
    800005e0:	69a2                	ld	s3,8(sp)
    800005e2:	6a02                	ld	s4,0(sp)
    800005e4:	6145                	addi	sp,sp,48
    800005e6:	8082                	ret

00000000800005e8 <panic>:
void panic(char *s) {
    800005e8:	1101                	addi	sp,sp,-32
    800005ea:	ec06                	sd	ra,24(sp)
    800005ec:	e822                	sd	s0,16(sp)
    800005ee:	e426                	sd	s1,8(sp)
    800005f0:	1000                	addi	s0,sp,32
    800005f2:	84aa                	mv	s1,a0
  pr.locking = 0;
    800005f4:	00011797          	auipc	a5,0x11
    800005f8:	3007a623          	sw	zero,780(a5) # 80011900 <pr+0x18>
  printf("panic: ");
    800005fc:	00008517          	auipc	a0,0x8
    80000600:	a4c50513          	addi	a0,a0,-1460 # 80008048 <etext+0x48>
    80000604:	00000097          	auipc	ra,0x0
    80000608:	036080e7          	jalr	54(ra) # 8000063a <printf>
  printf(s);
    8000060c:	8526                	mv	a0,s1
    8000060e:	00000097          	auipc	ra,0x0
    80000612:	02c080e7          	jalr	44(ra) # 8000063a <printf>
  printf("\n");
    80000616:	00008517          	auipc	a0,0x8
    8000061a:	b7250513          	addi	a0,a0,-1166 # 80008188 <digits+0x120>
    8000061e:	00000097          	auipc	ra,0x0
    80000622:	01c080e7          	jalr	28(ra) # 8000063a <printf>
  backtrace();
    80000626:	00000097          	auipc	ra,0x0
    8000062a:	f52080e7          	jalr	-174(ra) # 80000578 <backtrace>
  panicked = 1; // freeze uart output from other CPUs
    8000062e:	4785                	li	a5,1
    80000630:	00009717          	auipc	a4,0x9
    80000634:	9cf72823          	sw	a5,-1584(a4) # 80009000 <panicked>
  for (;;)
    80000638:	a001                	j	80000638 <panic+0x50>

000000008000063a <printf>:
void printf(char *fmt, ...) {
    8000063a:	7131                	addi	sp,sp,-192
    8000063c:	fc86                	sd	ra,120(sp)
    8000063e:	f8a2                	sd	s0,112(sp)
    80000640:	f4a6                	sd	s1,104(sp)
    80000642:	f0ca                	sd	s2,96(sp)
    80000644:	ecce                	sd	s3,88(sp)
    80000646:	e8d2                	sd	s4,80(sp)
    80000648:	e4d6                	sd	s5,72(sp)
    8000064a:	e0da                	sd	s6,64(sp)
    8000064c:	fc5e                	sd	s7,56(sp)
    8000064e:	f862                	sd	s8,48(sp)
    80000650:	f466                	sd	s9,40(sp)
    80000652:	f06a                	sd	s10,32(sp)
    80000654:	ec6e                	sd	s11,24(sp)
    80000656:	0100                	addi	s0,sp,128
    80000658:	8a2a                	mv	s4,a0
    8000065a:	e40c                	sd	a1,8(s0)
    8000065c:	e810                	sd	a2,16(s0)
    8000065e:	ec14                	sd	a3,24(s0)
    80000660:	f018                	sd	a4,32(s0)
    80000662:	f41c                	sd	a5,40(s0)
    80000664:	03043823          	sd	a6,48(s0)
    80000668:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    8000066c:	00011d97          	auipc	s11,0x11
    80000670:	294dad83          	lw	s11,660(s11) # 80011900 <pr+0x18>
  if (locking)
    80000674:	020d9b63          	bnez	s11,800006aa <printf+0x70>
  if (fmt == 0)
    80000678:	040a0263          	beqz	s4,800006bc <printf+0x82>
  va_start(ap, fmt);
    8000067c:	00840793          	addi	a5,s0,8
    80000680:	f8f43423          	sd	a5,-120(s0)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80000684:	000a4503          	lbu	a0,0(s4)
    80000688:	14050f63          	beqz	a0,800007e6 <printf+0x1ac>
    8000068c:	4981                	li	s3,0
    if (c != '%') {
    8000068e:	02500a93          	li	s5,37
    switch (c) {
    80000692:	07000b93          	li	s7,112
  consputc('x');
    80000696:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000698:	00008b17          	auipc	s6,0x8
    8000069c:	9d0b0b13          	addi	s6,s6,-1584 # 80008068 <digits>
    switch (c) {
    800006a0:	07300c93          	li	s9,115
    800006a4:	06400c13          	li	s8,100
    800006a8:	a82d                	j	800006e2 <printf+0xa8>
    acquire(&pr.lock);
    800006aa:	00011517          	auipc	a0,0x11
    800006ae:	23e50513          	addi	a0,a0,574 # 800118e8 <pr>
    800006b2:	00001097          	auipc	ra,0x1
    800006b6:	8cc080e7          	jalr	-1844(ra) # 80000f7e <acquire>
    800006ba:	bf7d                	j	80000678 <printf+0x3e>
    panic("null fmt");
    800006bc:	00008517          	auipc	a0,0x8
    800006c0:	99c50513          	addi	a0,a0,-1636 # 80008058 <etext+0x58>
    800006c4:	00000097          	auipc	ra,0x0
    800006c8:	f24080e7          	jalr	-220(ra) # 800005e8 <panic>
      consputc(c);
    800006cc:	00000097          	auipc	ra,0x0
    800006d0:	bb6080e7          	jalr	-1098(ra) # 80000282 <consputc>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    800006d4:	2985                	addiw	s3,s3,1
    800006d6:	013a07b3          	add	a5,s4,s3
    800006da:	0007c503          	lbu	a0,0(a5)
    800006de:	10050463          	beqz	a0,800007e6 <printf+0x1ac>
    if (c != '%') {
    800006e2:	ff5515e3          	bne	a0,s5,800006cc <printf+0x92>
    c = fmt[++i] & 0xff;
    800006e6:	2985                	addiw	s3,s3,1
    800006e8:	013a07b3          	add	a5,s4,s3
    800006ec:	0007c783          	lbu	a5,0(a5)
    800006f0:	0007849b          	sext.w	s1,a5
    if (c == 0)
    800006f4:	cbed                	beqz	a5,800007e6 <printf+0x1ac>
    switch (c) {
    800006f6:	05778a63          	beq	a5,s7,8000074a <printf+0x110>
    800006fa:	02fbf663          	bgeu	s7,a5,80000726 <printf+0xec>
    800006fe:	09978863          	beq	a5,s9,8000078e <printf+0x154>
    80000702:	07800713          	li	a4,120
    80000706:	0ce79563          	bne	a5,a4,800007d0 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    8000070a:	f8843783          	ld	a5,-120(s0)
    8000070e:	00878713          	addi	a4,a5,8
    80000712:	f8e43423          	sd	a4,-120(s0)
    80000716:	4605                	li	a2,1
    80000718:	85ea                	mv	a1,s10
    8000071a:	4388                	lw	a0,0(a5)
    8000071c:	00000097          	auipc	ra,0x0
    80000720:	d86080e7          	jalr	-634(ra) # 800004a2 <printint>
      break;
    80000724:	bf45                	j	800006d4 <printf+0x9a>
    switch (c) {
    80000726:	09578f63          	beq	a5,s5,800007c4 <printf+0x18a>
    8000072a:	0b879363          	bne	a5,s8,800007d0 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    8000072e:	f8843783          	ld	a5,-120(s0)
    80000732:	00878713          	addi	a4,a5,8
    80000736:	f8e43423          	sd	a4,-120(s0)
    8000073a:	4605                	li	a2,1
    8000073c:	45a9                	li	a1,10
    8000073e:	4388                	lw	a0,0(a5)
    80000740:	00000097          	auipc	ra,0x0
    80000744:	d62080e7          	jalr	-670(ra) # 800004a2 <printint>
      break;
    80000748:	b771                	j	800006d4 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    8000074a:	f8843783          	ld	a5,-120(s0)
    8000074e:	00878713          	addi	a4,a5,8
    80000752:	f8e43423          	sd	a4,-120(s0)
    80000756:	0007b903          	ld	s2,0(a5)
  consputc('0');
    8000075a:	03000513          	li	a0,48
    8000075e:	00000097          	auipc	ra,0x0
    80000762:	b24080e7          	jalr	-1244(ra) # 80000282 <consputc>
  consputc('x');
    80000766:	07800513          	li	a0,120
    8000076a:	00000097          	auipc	ra,0x0
    8000076e:	b18080e7          	jalr	-1256(ra) # 80000282 <consputc>
    80000772:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000774:	03c95793          	srli	a5,s2,0x3c
    80000778:	97da                	add	a5,a5,s6
    8000077a:	0007c503          	lbu	a0,0(a5)
    8000077e:	00000097          	auipc	ra,0x0
    80000782:	b04080e7          	jalr	-1276(ra) # 80000282 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80000786:	0912                	slli	s2,s2,0x4
    80000788:	34fd                	addiw	s1,s1,-1
    8000078a:	f4ed                	bnez	s1,80000774 <printf+0x13a>
    8000078c:	b7a1                	j	800006d4 <printf+0x9a>
      if ((s = va_arg(ap, char *)) == 0)
    8000078e:	f8843783          	ld	a5,-120(s0)
    80000792:	00878713          	addi	a4,a5,8
    80000796:	f8e43423          	sd	a4,-120(s0)
    8000079a:	6384                	ld	s1,0(a5)
    8000079c:	cc89                	beqz	s1,800007b6 <printf+0x17c>
      for (; *s; s++)
    8000079e:	0004c503          	lbu	a0,0(s1)
    800007a2:	d90d                	beqz	a0,800006d4 <printf+0x9a>
        consputc(*s);
    800007a4:	00000097          	auipc	ra,0x0
    800007a8:	ade080e7          	jalr	-1314(ra) # 80000282 <consputc>
      for (; *s; s++)
    800007ac:	0485                	addi	s1,s1,1
    800007ae:	0004c503          	lbu	a0,0(s1)
    800007b2:	f96d                	bnez	a0,800007a4 <printf+0x16a>
    800007b4:	b705                	j	800006d4 <printf+0x9a>
        s = "(null)";
    800007b6:	00008497          	auipc	s1,0x8
    800007ba:	89a48493          	addi	s1,s1,-1894 # 80008050 <etext+0x50>
      for (; *s; s++)
    800007be:	02800513          	li	a0,40
    800007c2:	b7cd                	j	800007a4 <printf+0x16a>
      consputc('%');
    800007c4:	8556                	mv	a0,s5
    800007c6:	00000097          	auipc	ra,0x0
    800007ca:	abc080e7          	jalr	-1348(ra) # 80000282 <consputc>
      break;
    800007ce:	b719                	j	800006d4 <printf+0x9a>
      consputc('%');
    800007d0:	8556                	mv	a0,s5
    800007d2:	00000097          	auipc	ra,0x0
    800007d6:	ab0080e7          	jalr	-1360(ra) # 80000282 <consputc>
      consputc(c);
    800007da:	8526                	mv	a0,s1
    800007dc:	00000097          	auipc	ra,0x0
    800007e0:	aa6080e7          	jalr	-1370(ra) # 80000282 <consputc>
      break;
    800007e4:	bdc5                	j	800006d4 <printf+0x9a>
  if (locking)
    800007e6:	020d9163          	bnez	s11,80000808 <printf+0x1ce>
}
    800007ea:	70e6                	ld	ra,120(sp)
    800007ec:	7446                	ld	s0,112(sp)
    800007ee:	74a6                	ld	s1,104(sp)
    800007f0:	7906                	ld	s2,96(sp)
    800007f2:	69e6                	ld	s3,88(sp)
    800007f4:	6a46                	ld	s4,80(sp)
    800007f6:	6aa6                	ld	s5,72(sp)
    800007f8:	6b06                	ld	s6,64(sp)
    800007fa:	7be2                	ld	s7,56(sp)
    800007fc:	7c42                	ld	s8,48(sp)
    800007fe:	7ca2                	ld	s9,40(sp)
    80000800:	7d02                	ld	s10,32(sp)
    80000802:	6de2                	ld	s11,24(sp)
    80000804:	6129                	addi	sp,sp,192
    80000806:	8082                	ret
    release(&pr.lock);
    80000808:	00011517          	auipc	a0,0x11
    8000080c:	0e050513          	addi	a0,a0,224 # 800118e8 <pr>
    80000810:	00001097          	auipc	ra,0x1
    80000814:	822080e7          	jalr	-2014(ra) # 80001032 <release>
}
    80000818:	bfc9                	j	800007ea <printf+0x1b0>

000000008000081a <uartinit>:
    8000081a:	1141                	addi	sp,sp,-16
    8000081c:	e406                	sd	ra,8(sp)
    8000081e:	e022                	sd	s0,0(sp)
    80000820:	0800                	addi	s0,sp,16
    80000822:	100007b7          	lui	a5,0x10000
    80000826:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>
    8000082a:	f8000713          	li	a4,-128
    8000082e:	00e781a3          	sb	a4,3(a5)
    80000832:	470d                	li	a4,3
    80000834:	00e78023          	sb	a4,0(a5)
    80000838:	000780a3          	sb	zero,1(a5)
    8000083c:	00e781a3          	sb	a4,3(a5)
    80000840:	469d                	li	a3,7
    80000842:	00d78123          	sb	a3,2(a5)
    80000846:	00e780a3          	sb	a4,1(a5)
    8000084a:	00008597          	auipc	a1,0x8
    8000084e:	83658593          	addi	a1,a1,-1994 # 80008080 <digits+0x18>
    80000852:	00011517          	auipc	a0,0x11
    80000856:	0b650513          	addi	a0,a0,182 # 80011908 <uart_tx_lock>
    8000085a:	00000097          	auipc	ra,0x0
    8000085e:	694080e7          	jalr	1684(ra) # 80000eee <initlock>
    80000862:	60a2                	ld	ra,8(sp)
    80000864:	6402                	ld	s0,0(sp)
    80000866:	0141                	addi	sp,sp,16
    80000868:	8082                	ret

000000008000086a <uartputc_sync>:
    8000086a:	1101                	addi	sp,sp,-32
    8000086c:	ec06                	sd	ra,24(sp)
    8000086e:	e822                	sd	s0,16(sp)
    80000870:	e426                	sd	s1,8(sp)
    80000872:	1000                	addi	s0,sp,32
    80000874:	84aa                	mv	s1,a0
    80000876:	00000097          	auipc	ra,0x0
    8000087a:	6bc080e7          	jalr	1724(ra) # 80000f32 <push_off>
    8000087e:	00008797          	auipc	a5,0x8
    80000882:	7827a783          	lw	a5,1922(a5) # 80009000 <panicked>
    80000886:	10000737          	lui	a4,0x10000
    8000088a:	c391                	beqz	a5,8000088e <uartputc_sync+0x24>
    8000088c:	a001                	j	8000088c <uartputc_sync+0x22>
    8000088e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000892:	0207f793          	andi	a5,a5,32
    80000896:	dfe5                	beqz	a5,8000088e <uartputc_sync+0x24>
    80000898:	0ff4f513          	zext.b	a0,s1
    8000089c:	100007b7          	lui	a5,0x10000
    800008a0:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>
    800008a4:	00000097          	auipc	ra,0x0
    800008a8:	72e080e7          	jalr	1838(ra) # 80000fd2 <pop_off>
    800008ac:	60e2                	ld	ra,24(sp)
    800008ae:	6442                	ld	s0,16(sp)
    800008b0:	64a2                	ld	s1,8(sp)
    800008b2:	6105                	addi	sp,sp,32
    800008b4:	8082                	ret

00000000800008b6 <uartstart>:
    800008b6:	00008797          	auipc	a5,0x8
    800008ba:	74e7a783          	lw	a5,1870(a5) # 80009004 <uart_tx_r>
    800008be:	00008717          	auipc	a4,0x8
    800008c2:	74a72703          	lw	a4,1866(a4) # 80009008 <uart_tx_w>
    800008c6:	08f70063          	beq	a4,a5,80000946 <uartstart+0x90>
    800008ca:	7139                	addi	sp,sp,-64
    800008cc:	fc06                	sd	ra,56(sp)
    800008ce:	f822                	sd	s0,48(sp)
    800008d0:	f426                	sd	s1,40(sp)
    800008d2:	f04a                	sd	s2,32(sp)
    800008d4:	ec4e                	sd	s3,24(sp)
    800008d6:	e852                	sd	s4,16(sp)
    800008d8:	e456                	sd	s5,8(sp)
    800008da:	0080                	addi	s0,sp,64
    800008dc:	10000937          	lui	s2,0x10000
    800008e0:	00011a97          	auipc	s5,0x11
    800008e4:	028a8a93          	addi	s5,s5,40 # 80011908 <uart_tx_lock>
    800008e8:	00008497          	auipc	s1,0x8
    800008ec:	71c48493          	addi	s1,s1,1820 # 80009004 <uart_tx_r>
    800008f0:	00008a17          	auipc	s4,0x8
    800008f4:	718a0a13          	addi	s4,s4,1816 # 80009008 <uart_tx_w>
    800008f8:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    800008fc:	02077713          	andi	a4,a4,32
    80000900:	cb15                	beqz	a4,80000934 <uartstart+0x7e>
    80000902:	00fa8733          	add	a4,s5,a5
    80000906:	01874983          	lbu	s3,24(a4)
    8000090a:	2785                	addiw	a5,a5,1
    8000090c:	41f7d71b          	sraiw	a4,a5,0x1f
    80000910:	01b7571b          	srliw	a4,a4,0x1b
    80000914:	9fb9                	addw	a5,a5,a4
    80000916:	8bfd                	andi	a5,a5,31
    80000918:	9f99                	subw	a5,a5,a4
    8000091a:	c09c                	sw	a5,0(s1)
    8000091c:	8526                	mv	a0,s1
    8000091e:	00002097          	auipc	ra,0x2
    80000922:	f74080e7          	jalr	-140(ra) # 80002892 <wakeup>
    80000926:	01390023          	sb	s3,0(s2)
    8000092a:	409c                	lw	a5,0(s1)
    8000092c:	000a2703          	lw	a4,0(s4)
    80000930:	fcf714e3          	bne	a4,a5,800008f8 <uartstart+0x42>
    80000934:	70e2                	ld	ra,56(sp)
    80000936:	7442                	ld	s0,48(sp)
    80000938:	74a2                	ld	s1,40(sp)
    8000093a:	7902                	ld	s2,32(sp)
    8000093c:	69e2                	ld	s3,24(sp)
    8000093e:	6a42                	ld	s4,16(sp)
    80000940:	6aa2                	ld	s5,8(sp)
    80000942:	6121                	addi	sp,sp,64
    80000944:	8082                	ret
    80000946:	8082                	ret

0000000080000948 <uartputc>:
    80000948:	7179                	addi	sp,sp,-48
    8000094a:	f406                	sd	ra,40(sp)
    8000094c:	f022                	sd	s0,32(sp)
    8000094e:	ec26                	sd	s1,24(sp)
    80000950:	e84a                	sd	s2,16(sp)
    80000952:	e44e                	sd	s3,8(sp)
    80000954:	e052                	sd	s4,0(sp)
    80000956:	1800                	addi	s0,sp,48
    80000958:	84aa                	mv	s1,a0
    8000095a:	00011517          	auipc	a0,0x11
    8000095e:	fae50513          	addi	a0,a0,-82 # 80011908 <uart_tx_lock>
    80000962:	00000097          	auipc	ra,0x0
    80000966:	61c080e7          	jalr	1564(ra) # 80000f7e <acquire>
    8000096a:	00008797          	auipc	a5,0x8
    8000096e:	6967a783          	lw	a5,1686(a5) # 80009000 <panicked>
    80000972:	c391                	beqz	a5,80000976 <uartputc+0x2e>
    80000974:	a001                	j	80000974 <uartputc+0x2c>
    80000976:	00008697          	auipc	a3,0x8
    8000097a:	6926a683          	lw	a3,1682(a3) # 80009008 <uart_tx_w>
    8000097e:	0016879b          	addiw	a5,a3,1
    80000982:	41f7d71b          	sraiw	a4,a5,0x1f
    80000986:	01b7571b          	srliw	a4,a4,0x1b
    8000098a:	9fb9                	addw	a5,a5,a4
    8000098c:	8bfd                	andi	a5,a5,31
    8000098e:	9f99                	subw	a5,a5,a4
    80000990:	00008717          	auipc	a4,0x8
    80000994:	67472703          	lw	a4,1652(a4) # 80009004 <uart_tx_r>
    80000998:	04f71363          	bne	a4,a5,800009de <uartputc+0x96>
    8000099c:	00011a17          	auipc	s4,0x11
    800009a0:	f6ca0a13          	addi	s4,s4,-148 # 80011908 <uart_tx_lock>
    800009a4:	00008917          	auipc	s2,0x8
    800009a8:	66090913          	addi	s2,s2,1632 # 80009004 <uart_tx_r>
    800009ac:	00008997          	auipc	s3,0x8
    800009b0:	65c98993          	addi	s3,s3,1628 # 80009008 <uart_tx_w>
    800009b4:	85d2                	mv	a1,s4
    800009b6:	854a                	mv	a0,s2
    800009b8:	00002097          	auipc	ra,0x2
    800009bc:	d5a080e7          	jalr	-678(ra) # 80002712 <sleep>
    800009c0:	0009a683          	lw	a3,0(s3)
    800009c4:	0016879b          	addiw	a5,a3,1
    800009c8:	41f7d71b          	sraiw	a4,a5,0x1f
    800009cc:	01b7571b          	srliw	a4,a4,0x1b
    800009d0:	9fb9                	addw	a5,a5,a4
    800009d2:	8bfd                	andi	a5,a5,31
    800009d4:	9f99                	subw	a5,a5,a4
    800009d6:	00092703          	lw	a4,0(s2)
    800009da:	fcf70de3          	beq	a4,a5,800009b4 <uartputc+0x6c>
    800009de:	00011917          	auipc	s2,0x11
    800009e2:	f2a90913          	addi	s2,s2,-214 # 80011908 <uart_tx_lock>
    800009e6:	96ca                	add	a3,a3,s2
    800009e8:	00968c23          	sb	s1,24(a3)
    800009ec:	00008717          	auipc	a4,0x8
    800009f0:	60f72e23          	sw	a5,1564(a4) # 80009008 <uart_tx_w>
    800009f4:	00000097          	auipc	ra,0x0
    800009f8:	ec2080e7          	jalr	-318(ra) # 800008b6 <uartstart>
    800009fc:	854a                	mv	a0,s2
    800009fe:	00000097          	auipc	ra,0x0
    80000a02:	634080e7          	jalr	1588(ra) # 80001032 <release>
    80000a06:	70a2                	ld	ra,40(sp)
    80000a08:	7402                	ld	s0,32(sp)
    80000a0a:	64e2                	ld	s1,24(sp)
    80000a0c:	6942                	ld	s2,16(sp)
    80000a0e:	69a2                	ld	s3,8(sp)
    80000a10:	6a02                	ld	s4,0(sp)
    80000a12:	6145                	addi	sp,sp,48
    80000a14:	8082                	ret

0000000080000a16 <uartgetc>:
    80000a16:	1141                	addi	sp,sp,-16
    80000a18:	e422                	sd	s0,8(sp)
    80000a1a:	0800                	addi	s0,sp,16
    80000a1c:	100007b7          	lui	a5,0x10000
    80000a20:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000a24:	8b85                	andi	a5,a5,1
    80000a26:	cb91                	beqz	a5,80000a3a <uartgetc+0x24>
    80000a28:	100007b7          	lui	a5,0x10000
    80000a2c:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80000a30:	0ff57513          	zext.b	a0,a0
    80000a34:	6422                	ld	s0,8(sp)
    80000a36:	0141                	addi	sp,sp,16
    80000a38:	8082                	ret
    80000a3a:	557d                	li	a0,-1
    80000a3c:	bfe5                	j	80000a34 <uartgetc+0x1e>

0000000080000a3e <uartintr>:
    80000a3e:	1101                	addi	sp,sp,-32
    80000a40:	ec06                	sd	ra,24(sp)
    80000a42:	e822                	sd	s0,16(sp)
    80000a44:	e426                	sd	s1,8(sp)
    80000a46:	1000                	addi	s0,sp,32
    80000a48:	54fd                	li	s1,-1
    80000a4a:	a029                	j	80000a54 <uartintr+0x16>
    80000a4c:	00000097          	auipc	ra,0x0
    80000a50:	878080e7          	jalr	-1928(ra) # 800002c4 <consoleintr>
    80000a54:	00000097          	auipc	ra,0x0
    80000a58:	fc2080e7          	jalr	-62(ra) # 80000a16 <uartgetc>
    80000a5c:	fe9518e3          	bne	a0,s1,80000a4c <uartintr+0xe>
    80000a60:	00011497          	auipc	s1,0x11
    80000a64:	ea848493          	addi	s1,s1,-344 # 80011908 <uart_tx_lock>
    80000a68:	8526                	mv	a0,s1
    80000a6a:	00000097          	auipc	ra,0x0
    80000a6e:	514080e7          	jalr	1300(ra) # 80000f7e <acquire>
    80000a72:	00000097          	auipc	ra,0x0
    80000a76:	e44080e7          	jalr	-444(ra) # 800008b6 <uartstart>
    80000a7a:	8526                	mv	a0,s1
    80000a7c:	00000097          	auipc	ra,0x0
    80000a80:	5b6080e7          	jalr	1462(ra) # 80001032 <release>
    80000a84:	60e2                	ld	ra,24(sp)
    80000a86:	6442                	ld	s0,16(sp)
    80000a88:	64a2                	ld	s1,8(sp)
    80000a8a:	6105                	addi	sp,sp,32
    80000a8c:	8082                	ret

0000000080000a8e <kfree>:
    80000a8e:	7139                	addi	sp,sp,-64
    80000a90:	fc06                	sd	ra,56(sp)
    80000a92:	f822                	sd	s0,48(sp)
    80000a94:	f426                	sd	s1,40(sp)
    80000a96:	f04a                	sd	s2,32(sp)
    80000a98:	ec4e                	sd	s3,24(sp)
    80000a9a:	e852                	sd	s4,16(sp)
    80000a9c:	e456                	sd	s5,8(sp)
    80000a9e:	0080                	addi	s0,sp,64
    80000aa0:	03451793          	slli	a5,a0,0x34
    80000aa4:	e3ed                	bnez	a5,80000b86 <kfree+0xf8>
    80000aa6:	84aa                	mv	s1,a0
    80000aa8:	00045797          	auipc	a5,0x45
    80000aac:	55878793          	addi	a5,a5,1368 # 80046000 <end>
    80000ab0:	0cf56b63          	bltu	a0,a5,80000b86 <kfree+0xf8>
    80000ab4:	47c5                	li	a5,17
    80000ab6:	07ee                	slli	a5,a5,0x1b
    80000ab8:	0cf57763          	bgeu	a0,a5,80000b86 <kfree+0xf8>
    80000abc:	00011517          	auipc	a0,0x11
    80000ac0:	e8450513          	addi	a0,a0,-380 # 80011940 <ref_lock>
    80000ac4:	00000097          	auipc	ra,0x0
    80000ac8:	4ba080e7          	jalr	1210(ra) # 80000f7e <acquire>
    80000acc:	77fd                	lui	a5,0xfffff
    80000ace:	8fe5                	and	a5,a5,s1
    80000ad0:	80000737          	lui	a4,0x80000
    80000ad4:	97ba                	add	a5,a5,a4
    80000ad6:	00c7d693          	srli	a3,a5,0xc
    80000ada:	83a9                	srli	a5,a5,0xa
    80000adc:	00011717          	auipc	a4,0x11
    80000ae0:	fd470713          	addi	a4,a4,-44 # 80011ab0 <page_ref_count>
    80000ae4:	97ba                	add	a5,a5,a4
    80000ae6:	439c                	lw	a5,0(a5)
    80000ae8:	00f05a63          	blez	a5,80000afc <kfree+0x6e>
    80000aec:	37fd                	addiw	a5,a5,-1
    80000aee:	0007861b          	sext.w	a2,a5
    80000af2:	068a                	slli	a3,a3,0x2
    80000af4:	96ba                	add	a3,a3,a4
    80000af6:	c29c                	sw	a5,0(a3)
    80000af8:	08c04f63          	bgtz	a2,80000b96 <kfree+0x108>
    80000afc:	00011a17          	auipc	s4,0x11
    80000b00:	e44a0a13          	addi	s4,s4,-444 # 80011940 <ref_lock>
    80000b04:	8552                	mv	a0,s4
    80000b06:	00000097          	auipc	ra,0x0
    80000b0a:	52c080e7          	jalr	1324(ra) # 80001032 <release>
    80000b0e:	00000097          	auipc	ra,0x0
    80000b12:	424080e7          	jalr	1060(ra) # 80000f32 <push_off>
    80000b16:	00001097          	auipc	ra,0x1
    80000b1a:	3bc080e7          	jalr	956(ra) # 80001ed2 <cpuid>
    80000b1e:	89aa                	mv	s3,a0
    80000b20:	00000097          	auipc	ra,0x0
    80000b24:	4b2080e7          	jalr	1202(ra) # 80000fd2 <pop_off>
    80000b28:	6605                	lui	a2,0x1
    80000b2a:	4585                	li	a1,1
    80000b2c:	8526                	mv	a0,s1
    80000b2e:	00000097          	auipc	ra,0x0
    80000b32:	54c080e7          	jalr	1356(ra) # 8000107a <memset>
    80000b36:	00299913          	slli	s2,s3,0x2
    80000b3a:	01390ab3          	add	s5,s2,s3
    80000b3e:	003a9793          	slli	a5,s5,0x3
    80000b42:	00011a97          	auipc	s5,0x11
    80000b46:	e16a8a93          	addi	s5,s5,-490 # 80011958 <kmem>
    80000b4a:	9abe                	add	s5,s5,a5
    80000b4c:	8556                	mv	a0,s5
    80000b4e:	00000097          	auipc	ra,0x0
    80000b52:	430080e7          	jalr	1072(ra) # 80000f7e <acquire>
    80000b56:	013907b3          	add	a5,s2,s3
    80000b5a:	078e                	slli	a5,a5,0x3
    80000b5c:	97d2                	add	a5,a5,s4
    80000b5e:	7b98                	ld	a4,48(a5)
    80000b60:	e098                	sd	a4,0(s1)
    80000b62:	fb84                	sd	s1,48(a5)
    80000b64:	5f98                	lw	a4,56(a5)
    80000b66:	2705                	addiw	a4,a4,1
    80000b68:	df98                	sw	a4,56(a5)
    80000b6a:	8556                	mv	a0,s5
    80000b6c:	00000097          	auipc	ra,0x0
    80000b70:	4c6080e7          	jalr	1222(ra) # 80001032 <release>
    80000b74:	70e2                	ld	ra,56(sp)
    80000b76:	7442                	ld	s0,48(sp)
    80000b78:	74a2                	ld	s1,40(sp)
    80000b7a:	7902                	ld	s2,32(sp)
    80000b7c:	69e2                	ld	s3,24(sp)
    80000b7e:	6a42                	ld	s4,16(sp)
    80000b80:	6aa2                	ld	s5,8(sp)
    80000b82:	6121                	addi	sp,sp,64
    80000b84:	8082                	ret
    80000b86:	00007517          	auipc	a0,0x7
    80000b8a:	50250513          	addi	a0,a0,1282 # 80008088 <digits+0x20>
    80000b8e:	00000097          	auipc	ra,0x0
    80000b92:	a5a080e7          	jalr	-1446(ra) # 800005e8 <panic>
    80000b96:	00011517          	auipc	a0,0x11
    80000b9a:	daa50513          	addi	a0,a0,-598 # 80011940 <ref_lock>
    80000b9e:	00000097          	auipc	ra,0x0
    80000ba2:	494080e7          	jalr	1172(ra) # 80001032 <release>
    80000ba6:	b7f9                	j	80000b74 <kfree+0xe6>

0000000080000ba8 <freerange>:
    80000ba8:	7179                	addi	sp,sp,-48
    80000baa:	f406                	sd	ra,40(sp)
    80000bac:	f022                	sd	s0,32(sp)
    80000bae:	ec26                	sd	s1,24(sp)
    80000bb0:	e84a                	sd	s2,16(sp)
    80000bb2:	e44e                	sd	s3,8(sp)
    80000bb4:	e052                	sd	s4,0(sp)
    80000bb6:	1800                	addi	s0,sp,48
    80000bb8:	6785                	lui	a5,0x1
    80000bba:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000bbe:	94aa                	add	s1,s1,a0
    80000bc0:	757d                	lui	a0,0xfffff
    80000bc2:	8ce9                	and	s1,s1,a0
    80000bc4:	94be                	add	s1,s1,a5
    80000bc6:	0095ee63          	bltu	a1,s1,80000be2 <freerange+0x3a>
    80000bca:	892e                	mv	s2,a1
    80000bcc:	7a7d                	lui	s4,0xfffff
    80000bce:	6985                	lui	s3,0x1
    80000bd0:	01448533          	add	a0,s1,s4
    80000bd4:	00000097          	auipc	ra,0x0
    80000bd8:	eba080e7          	jalr	-326(ra) # 80000a8e <kfree>
    80000bdc:	94ce                	add	s1,s1,s3
    80000bde:	fe9979e3          	bgeu	s2,s1,80000bd0 <freerange+0x28>
    80000be2:	70a2                	ld	ra,40(sp)
    80000be4:	7402                	ld	s0,32(sp)
    80000be6:	64e2                	ld	s1,24(sp)
    80000be8:	6942                	ld	s2,16(sp)
    80000bea:	69a2                	ld	s3,8(sp)
    80000bec:	6a02                	ld	s4,0(sp)
    80000bee:	6145                	addi	sp,sp,48
    80000bf0:	8082                	ret

0000000080000bf2 <kinit>:
    80000bf2:	7179                	addi	sp,sp,-48
    80000bf4:	f406                	sd	ra,40(sp)
    80000bf6:	f022                	sd	s0,32(sp)
    80000bf8:	ec26                	sd	s1,24(sp)
    80000bfa:	e84a                	sd	s2,16(sp)
    80000bfc:	e44e                	sd	s3,8(sp)
    80000bfe:	1800                	addi	s0,sp,48
    80000c00:	00011497          	auipc	s1,0x11
    80000c04:	d5848493          	addi	s1,s1,-680 # 80011958 <kmem>
    80000c08:	00011997          	auipc	s3,0x11
    80000c0c:	e9098993          	addi	s3,s3,-368 # 80011a98 <alloc_lock>
    80000c10:	00007917          	auipc	s2,0x7
    80000c14:	48090913          	addi	s2,s2,1152 # 80008090 <digits+0x28>
    80000c18:	85ca                	mv	a1,s2
    80000c1a:	8526                	mv	a0,s1
    80000c1c:	00000097          	auipc	ra,0x0
    80000c20:	2d2080e7          	jalr	722(ra) # 80000eee <initlock>
    80000c24:	0204a023          	sw	zero,32(s1)
    80000c28:	02848493          	addi	s1,s1,40
    80000c2c:	ff3496e3          	bne	s1,s3,80000c18 <kinit+0x26>
    80000c30:	00007597          	auipc	a1,0x7
    80000c34:	46858593          	addi	a1,a1,1128 # 80008098 <digits+0x30>
    80000c38:	00011517          	auipc	a0,0x11
    80000c3c:	e6050513          	addi	a0,a0,-416 # 80011a98 <alloc_lock>
    80000c40:	00000097          	auipc	ra,0x0
    80000c44:	2ae080e7          	jalr	686(ra) # 80000eee <initlock>
    80000c48:	00007597          	auipc	a1,0x7
    80000c4c:	47858593          	addi	a1,a1,1144 # 800080c0 <digits+0x58>
    80000c50:	00011517          	auipc	a0,0x11
    80000c54:	cf050513          	addi	a0,a0,-784 # 80011940 <ref_lock>
    80000c58:	00000097          	auipc	ra,0x0
    80000c5c:	296080e7          	jalr	662(ra) # 80000eee <initlock>
    80000c60:	45c5                	li	a1,17
    80000c62:	05ee                	slli	a1,a1,0x1b
    80000c64:	00045517          	auipc	a0,0x45
    80000c68:	39c50513          	addi	a0,a0,924 # 80046000 <end>
    80000c6c:	00000097          	auipc	ra,0x0
    80000c70:	f3c080e7          	jalr	-196(ra) # 80000ba8 <freerange>
    80000c74:	70a2                	ld	ra,40(sp)
    80000c76:	7402                	ld	s0,32(sp)
    80000c78:	64e2                	ld	s1,24(sp)
    80000c7a:	6942                	ld	s2,16(sp)
    80000c7c:	69a2                	ld	s3,8(sp)
    80000c7e:	6145                	addi	sp,sp,48
    80000c80:	8082                	ret

0000000080000c82 <steal_page>:
    80000c82:	1101                	addi	sp,sp,-32
    80000c84:	ec06                	sd	ra,24(sp)
    80000c86:	e822                	sd	s0,16(sp)
    80000c88:	e426                	sd	s1,8(sp)
    80000c8a:	1000                	addi	s0,sp,32
    80000c8c:	84aa                	mv	s1,a0
    80000c8e:	00011517          	auipc	a0,0x11
    80000c92:	e0a50513          	addi	a0,a0,-502 # 80011a98 <alloc_lock>
    80000c96:	00000097          	auipc	ra,0x0
    80000c9a:	2e8080e7          	jalr	744(ra) # 80000f7e <acquire>
    80000c9e:	00011717          	auipc	a4,0x11
    80000ca2:	cba70713          	addi	a4,a4,-838 # 80011958 <kmem>
    80000ca6:	4781                	li	a5,0
    80000ca8:	4501                	li	a0,0
    80000caa:	4681                	li	a3,0
    80000cac:	45a1                	li	a1,8
    80000cae:	a031                	j	80000cba <steal_page+0x38>
    80000cb0:	2785                	addiw	a5,a5,1
    80000cb2:	02870713          	addi	a4,a4,40
    80000cb6:	00b78a63          	beq	a5,a1,80000cca <steal_page+0x48>
    80000cba:	fef48be3          	beq	s1,a5,80000cb0 <steal_page+0x2e>
    80000cbe:	5310                	lw	a2,32(a4)
    80000cc0:	fec6d8e3          	bge	a3,a2,80000cb0 <steal_page+0x2e>
    80000cc4:	853e                	mv	a0,a5
    80000cc6:	86b2                	mv	a3,a2
    80000cc8:	b7e5                	j	80000cb0 <steal_page+0x2e>
    80000cca:	4785                	li	a5,1
    80000ccc:	08d7d763          	bge	a5,a3,80000d5a <steal_page+0xd8>
    80000cd0:	00251793          	slli	a5,a0,0x2
    80000cd4:	97aa                	add	a5,a5,a0
    80000cd6:	078e                	slli	a5,a5,0x3
    80000cd8:	00011717          	auipc	a4,0x11
    80000cdc:	c6870713          	addi	a4,a4,-920 # 80011940 <ref_lock>
    80000ce0:	97ba                	add	a5,a5,a4
    80000ce2:	0307b883          	ld	a7,48(a5)
    80000ce6:	01f6d81b          	srliw	a6,a3,0x1f
    80000cea:	00d8083b          	addw	a6,a6,a3
    80000cee:	4018581b          	sraiw	a6,a6,0x1
    80000cf2:	0008061b          	sext.w	a2,a6
    80000cf6:	87c6                	mv	a5,a7
    80000cf8:	4701                	li	a4,0
    80000cfa:	85be                	mv	a1,a5
    80000cfc:	639c                	ld	a5,0(a5)
    80000cfe:	2705                	addiw	a4,a4,1
    80000d00:	fec74de3          	blt	a4,a2,80000cfa <steal_page+0x78>
    80000d04:	0005b023          	sd	zero,0(a1)
    80000d08:	00011617          	auipc	a2,0x11
    80000d0c:	c3860613          	addi	a2,a2,-968 # 80011940 <ref_lock>
    80000d10:	00251713          	slli	a4,a0,0x2
    80000d14:	00a705b3          	add	a1,a4,a0
    80000d18:	058e                	slli	a1,a1,0x3
    80000d1a:	95b2                	add	a1,a1,a2
    80000d1c:	f99c                	sd	a5,48(a1)
    80000d1e:	01f6d79b          	srliw	a5,a3,0x1f
    80000d22:	9fb5                	addw	a5,a5,a3
    80000d24:	4017d79b          	sraiw	a5,a5,0x1
    80000d28:	9e9d                	subw	a3,a3,a5
    80000d2a:	dd94                	sw	a3,56(a1)
    80000d2c:	00249793          	slli	a5,s1,0x2
    80000d30:	00978733          	add	a4,a5,s1
    80000d34:	070e                	slli	a4,a4,0x3
    80000d36:	9732                	add	a4,a4,a2
    80000d38:	03173823          	sd	a7,48(a4)
    80000d3c:	03072c23          	sw	a6,56(a4)
    80000d40:	00011517          	auipc	a0,0x11
    80000d44:	d5850513          	addi	a0,a0,-680 # 80011a98 <alloc_lock>
    80000d48:	00000097          	auipc	ra,0x0
    80000d4c:	2ea080e7          	jalr	746(ra) # 80001032 <release>
    80000d50:	60e2                	ld	ra,24(sp)
    80000d52:	6442                	ld	s0,16(sp)
    80000d54:	64a2                	ld	s1,8(sp)
    80000d56:	6105                	addi	sp,sp,32
    80000d58:	8082                	ret
    80000d5a:	00011517          	auipc	a0,0x11
    80000d5e:	d3e50513          	addi	a0,a0,-706 # 80011a98 <alloc_lock>
    80000d62:	00000097          	auipc	ra,0x0
    80000d66:	2d0080e7          	jalr	720(ra) # 80001032 <release>
    80000d6a:	b7dd                	j	80000d50 <steal_page+0xce>

0000000080000d6c <kalloc>:
    80000d6c:	7179                	addi	sp,sp,-48
    80000d6e:	f406                	sd	ra,40(sp)
    80000d70:	f022                	sd	s0,32(sp)
    80000d72:	ec26                	sd	s1,24(sp)
    80000d74:	e84a                	sd	s2,16(sp)
    80000d76:	e44e                	sd	s3,8(sp)
    80000d78:	1800                	addi	s0,sp,48
    80000d7a:	00000097          	auipc	ra,0x0
    80000d7e:	1b8080e7          	jalr	440(ra) # 80000f32 <push_off>
    80000d82:	00001097          	auipc	ra,0x1
    80000d86:	150080e7          	jalr	336(ra) # 80001ed2 <cpuid>
    80000d8a:	84aa                	mv	s1,a0
    80000d8c:	00000097          	auipc	ra,0x0
    80000d90:	246080e7          	jalr	582(ra) # 80000fd2 <pop_off>
    80000d94:	00249913          	slli	s2,s1,0x2
    80000d98:	009909b3          	add	s3,s2,s1
    80000d9c:	00399793          	slli	a5,s3,0x3
    80000da0:	00011997          	auipc	s3,0x11
    80000da4:	bb898993          	addi	s3,s3,-1096 # 80011958 <kmem>
    80000da8:	99be                	add	s3,s3,a5
    80000daa:	854e                	mv	a0,s3
    80000dac:	00000097          	auipc	ra,0x0
    80000db0:	1d2080e7          	jalr	466(ra) # 80000f7e <acquire>
    80000db4:	9926                	add	s2,s2,s1
    80000db6:	090e                	slli	s2,s2,0x3
    80000db8:	00011797          	auipc	a5,0x11
    80000dbc:	b8878793          	addi	a5,a5,-1144 # 80011940 <ref_lock>
    80000dc0:	993e                	add	s2,s2,a5
    80000dc2:	03093903          	ld	s2,48(s2)
    80000dc6:	08090b63          	beqz	s2,80000e5c <kalloc+0xf0>
    80000dca:	00093603          	ld	a2,0(s2)
    80000dce:	86be                	mv	a3,a5
    80000dd0:	00249713          	slli	a4,s1,0x2
    80000dd4:	009707b3          	add	a5,a4,s1
    80000dd8:	078e                	slli	a5,a5,0x3
    80000dda:	97b6                	add	a5,a5,a3
    80000ddc:	fb90                	sd	a2,48(a5)
    80000dde:	5f98                	lw	a4,56(a5)
    80000de0:	377d                	addiw	a4,a4,-1
    80000de2:	df98                	sw	a4,56(a5)
    80000de4:	854e                	mv	a0,s3
    80000de6:	00000097          	auipc	ra,0x0
    80000dea:	24c080e7          	jalr	588(ra) # 80001032 <release>
    80000dee:	6605                	lui	a2,0x1
    80000df0:	4595                	li	a1,5
    80000df2:	854a                	mv	a0,s2
    80000df4:	00000097          	auipc	ra,0x0
    80000df8:	286080e7          	jalr	646(ra) # 8000107a <memset>
    80000dfc:	00011517          	auipc	a0,0x11
    80000e00:	b4450513          	addi	a0,a0,-1212 # 80011940 <ref_lock>
    80000e04:	00000097          	auipc	ra,0x0
    80000e08:	17a080e7          	jalr	378(ra) # 80000f7e <acquire>
    80000e0c:	77fd                	lui	a5,0xfffff
    80000e0e:	00f977b3          	and	a5,s2,a5
    80000e12:	80000737          	lui	a4,0x80000
    80000e16:	97ba                	add	a5,a5,a4
    80000e18:	00c7d693          	srli	a3,a5,0xc
    80000e1c:	83a9                	srli	a5,a5,0xa
    80000e1e:	00011717          	auipc	a4,0x11
    80000e22:	c9270713          	addi	a4,a4,-878 # 80011ab0 <page_ref_count>
    80000e26:	97ba                	add	a5,a5,a4
    80000e28:	438c                	lw	a1,0(a5)
    80000e2a:	edc1                	bnez	a1,80000ec2 <kalloc+0x156>
    80000e2c:	068a                	slli	a3,a3,0x2
    80000e2e:	00011797          	auipc	a5,0x11
    80000e32:	c8278793          	addi	a5,a5,-894 # 80011ab0 <page_ref_count>
    80000e36:	96be                	add	a3,a3,a5
    80000e38:	4785                	li	a5,1
    80000e3a:	c29c                	sw	a5,0(a3)
    80000e3c:	00011517          	auipc	a0,0x11
    80000e40:	b0450513          	addi	a0,a0,-1276 # 80011940 <ref_lock>
    80000e44:	00000097          	auipc	ra,0x0
    80000e48:	1ee080e7          	jalr	494(ra) # 80001032 <release>
    80000e4c:	854a                	mv	a0,s2
    80000e4e:	70a2                	ld	ra,40(sp)
    80000e50:	7402                	ld	s0,32(sp)
    80000e52:	64e2                	ld	s1,24(sp)
    80000e54:	6942                	ld	s2,16(sp)
    80000e56:	69a2                	ld	s3,8(sp)
    80000e58:	6145                	addi	sp,sp,48
    80000e5a:	8082                	ret
    80000e5c:	00249793          	slli	a5,s1,0x2
    80000e60:	97a6                	add	a5,a5,s1
    80000e62:	078e                	slli	a5,a5,0x3
    80000e64:	00011717          	auipc	a4,0x11
    80000e68:	adc70713          	addi	a4,a4,-1316 # 80011940 <ref_lock>
    80000e6c:	97ba                	add	a5,a5,a4
    80000e6e:	5f9c                	lw	a5,56(a5)
    80000e70:	e3a9                	bnez	a5,80000eb2 <kalloc+0x146>
    80000e72:	8526                	mv	a0,s1
    80000e74:	00000097          	auipc	ra,0x0
    80000e78:	e0e080e7          	jalr	-498(ra) # 80000c82 <steal_page>
    80000e7c:	00249793          	slli	a5,s1,0x2
    80000e80:	97a6                	add	a5,a5,s1
    80000e82:	078e                	slli	a5,a5,0x3
    80000e84:	00011717          	auipc	a4,0x11
    80000e88:	abc70713          	addi	a4,a4,-1348 # 80011940 <ref_lock>
    80000e8c:	97ba                	add	a5,a5,a4
    80000e8e:	0307b903          	ld	s2,48(a5)
    80000e92:	04090863          	beqz	s2,80000ee2 <kalloc+0x176>
    80000e96:	00093603          	ld	a2,0(s2)
    80000e9a:	86ba                	mv	a3,a4
    80000e9c:	00249713          	slli	a4,s1,0x2
    80000ea0:	009707b3          	add	a5,a4,s1
    80000ea4:	078e                	slli	a5,a5,0x3
    80000ea6:	97b6                	add	a5,a5,a3
    80000ea8:	fb90                	sd	a2,48(a5)
    80000eaa:	5f98                	lw	a4,56(a5)
    80000eac:	377d                	addiw	a4,a4,-1
    80000eae:	df98                	sw	a4,56(a5)
    80000eb0:	bf15                	j	80000de4 <kalloc+0x78>
    80000eb2:	00007517          	auipc	a0,0x7
    80000eb6:	22e50513          	addi	a0,a0,558 # 800080e0 <digits+0x78>
    80000eba:	fffff097          	auipc	ra,0xfffff
    80000ebe:	72e080e7          	jalr	1838(ra) # 800005e8 <panic>
    80000ec2:	00007517          	auipc	a0,0x7
    80000ec6:	23650513          	addi	a0,a0,566 # 800080f8 <digits+0x90>
    80000eca:	fffff097          	auipc	ra,0xfffff
    80000ece:	770080e7          	jalr	1904(ra) # 8000063a <printf>
    80000ed2:	00007517          	auipc	a0,0x7
    80000ed6:	23e50513          	addi	a0,a0,574 # 80008110 <digits+0xa8>
    80000eda:	fffff097          	auipc	ra,0xfffff
    80000ede:	70e080e7          	jalr	1806(ra) # 800005e8 <panic>
    80000ee2:	854e                	mv	a0,s3
    80000ee4:	00000097          	auipc	ra,0x0
    80000ee8:	14e080e7          	jalr	334(ra) # 80001032 <release>
    80000eec:	b785                	j	80000e4c <kalloc+0xe0>

0000000080000eee <initlock>:
    80000eee:	1141                	addi	sp,sp,-16
    80000ef0:	e422                	sd	s0,8(sp)
    80000ef2:	0800                	addi	s0,sp,16
    80000ef4:	e50c                	sd	a1,8(a0)
    80000ef6:	00052023          	sw	zero,0(a0)
    80000efa:	00053823          	sd	zero,16(a0)
    80000efe:	6422                	ld	s0,8(sp)
    80000f00:	0141                	addi	sp,sp,16
    80000f02:	8082                	ret

0000000080000f04 <holding>:
    80000f04:	411c                	lw	a5,0(a0)
    80000f06:	e399                	bnez	a5,80000f0c <holding+0x8>
    80000f08:	4501                	li	a0,0
    80000f0a:	8082                	ret
    80000f0c:	1101                	addi	sp,sp,-32
    80000f0e:	ec06                	sd	ra,24(sp)
    80000f10:	e822                	sd	s0,16(sp)
    80000f12:	e426                	sd	s1,8(sp)
    80000f14:	1000                	addi	s0,sp,32
    80000f16:	6904                	ld	s1,16(a0)
    80000f18:	00001097          	auipc	ra,0x1
    80000f1c:	fca080e7          	jalr	-54(ra) # 80001ee2 <mycpu>
    80000f20:	40a48533          	sub	a0,s1,a0
    80000f24:	00153513          	seqz	a0,a0
    80000f28:	60e2                	ld	ra,24(sp)
    80000f2a:	6442                	ld	s0,16(sp)
    80000f2c:	64a2                	ld	s1,8(sp)
    80000f2e:	6105                	addi	sp,sp,32
    80000f30:	8082                	ret

0000000080000f32 <push_off>:
    80000f32:	1101                	addi	sp,sp,-32
    80000f34:	ec06                	sd	ra,24(sp)
    80000f36:	e822                	sd	s0,16(sp)
    80000f38:	e426                	sd	s1,8(sp)
    80000f3a:	1000                	addi	s0,sp,32
    80000f3c:	100024f3          	csrr	s1,sstatus
    80000f40:	100027f3          	csrr	a5,sstatus
    80000f44:	9bf5                	andi	a5,a5,-3
    80000f46:	10079073          	csrw	sstatus,a5
    80000f4a:	00001097          	auipc	ra,0x1
    80000f4e:	f98080e7          	jalr	-104(ra) # 80001ee2 <mycpu>
    80000f52:	5d3c                	lw	a5,120(a0)
    80000f54:	cf89                	beqz	a5,80000f6e <push_off+0x3c>
    80000f56:	00001097          	auipc	ra,0x1
    80000f5a:	f8c080e7          	jalr	-116(ra) # 80001ee2 <mycpu>
    80000f5e:	5d3c                	lw	a5,120(a0)
    80000f60:	2785                	addiw	a5,a5,1
    80000f62:	dd3c                	sw	a5,120(a0)
    80000f64:	60e2                	ld	ra,24(sp)
    80000f66:	6442                	ld	s0,16(sp)
    80000f68:	64a2                	ld	s1,8(sp)
    80000f6a:	6105                	addi	sp,sp,32
    80000f6c:	8082                	ret
    80000f6e:	00001097          	auipc	ra,0x1
    80000f72:	f74080e7          	jalr	-140(ra) # 80001ee2 <mycpu>
    80000f76:	8085                	srli	s1,s1,0x1
    80000f78:	8885                	andi	s1,s1,1
    80000f7a:	dd64                	sw	s1,124(a0)
    80000f7c:	bfe9                	j	80000f56 <push_off+0x24>

0000000080000f7e <acquire>:
    80000f7e:	1101                	addi	sp,sp,-32
    80000f80:	ec06                	sd	ra,24(sp)
    80000f82:	e822                	sd	s0,16(sp)
    80000f84:	e426                	sd	s1,8(sp)
    80000f86:	1000                	addi	s0,sp,32
    80000f88:	84aa                	mv	s1,a0
    80000f8a:	00000097          	auipc	ra,0x0
    80000f8e:	fa8080e7          	jalr	-88(ra) # 80000f32 <push_off>
    80000f92:	8526                	mv	a0,s1
    80000f94:	00000097          	auipc	ra,0x0
    80000f98:	f70080e7          	jalr	-144(ra) # 80000f04 <holding>
    80000f9c:	4705                	li	a4,1
    80000f9e:	e115                	bnez	a0,80000fc2 <acquire+0x44>
    80000fa0:	87ba                	mv	a5,a4
    80000fa2:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000fa6:	2781                	sext.w	a5,a5
    80000fa8:	ffe5                	bnez	a5,80000fa0 <acquire+0x22>
    80000faa:	0ff0000f          	fence
    80000fae:	00001097          	auipc	ra,0x1
    80000fb2:	f34080e7          	jalr	-204(ra) # 80001ee2 <mycpu>
    80000fb6:	e888                	sd	a0,16(s1)
    80000fb8:	60e2                	ld	ra,24(sp)
    80000fba:	6442                	ld	s0,16(sp)
    80000fbc:	64a2                	ld	s1,8(sp)
    80000fbe:	6105                	addi	sp,sp,32
    80000fc0:	8082                	ret
    80000fc2:	00007517          	auipc	a0,0x7
    80000fc6:	16e50513          	addi	a0,a0,366 # 80008130 <digits+0xc8>
    80000fca:	fffff097          	auipc	ra,0xfffff
    80000fce:	61e080e7          	jalr	1566(ra) # 800005e8 <panic>

0000000080000fd2 <pop_off>:
    80000fd2:	1141                	addi	sp,sp,-16
    80000fd4:	e406                	sd	ra,8(sp)
    80000fd6:	e022                	sd	s0,0(sp)
    80000fd8:	0800                	addi	s0,sp,16
    80000fda:	00001097          	auipc	ra,0x1
    80000fde:	f08080e7          	jalr	-248(ra) # 80001ee2 <mycpu>
    80000fe2:	100027f3          	csrr	a5,sstatus
    80000fe6:	8b89                	andi	a5,a5,2
    80000fe8:	e78d                	bnez	a5,80001012 <pop_off+0x40>
    80000fea:	5d3c                	lw	a5,120(a0)
    80000fec:	02f05b63          	blez	a5,80001022 <pop_off+0x50>
    80000ff0:	37fd                	addiw	a5,a5,-1
    80000ff2:	0007871b          	sext.w	a4,a5
    80000ff6:	dd3c                	sw	a5,120(a0)
    80000ff8:	eb09                	bnez	a4,8000100a <pop_off+0x38>
    80000ffa:	5d7c                	lw	a5,124(a0)
    80000ffc:	c799                	beqz	a5,8000100a <pop_off+0x38>
    80000ffe:	100027f3          	csrr	a5,sstatus
    80001002:	0027e793          	ori	a5,a5,2
    80001006:	10079073          	csrw	sstatus,a5
    8000100a:	60a2                	ld	ra,8(sp)
    8000100c:	6402                	ld	s0,0(sp)
    8000100e:	0141                	addi	sp,sp,16
    80001010:	8082                	ret
    80001012:	00007517          	auipc	a0,0x7
    80001016:	12650513          	addi	a0,a0,294 # 80008138 <digits+0xd0>
    8000101a:	fffff097          	auipc	ra,0xfffff
    8000101e:	5ce080e7          	jalr	1486(ra) # 800005e8 <panic>
    80001022:	00007517          	auipc	a0,0x7
    80001026:	12e50513          	addi	a0,a0,302 # 80008150 <digits+0xe8>
    8000102a:	fffff097          	auipc	ra,0xfffff
    8000102e:	5be080e7          	jalr	1470(ra) # 800005e8 <panic>

0000000080001032 <release>:
    80001032:	1101                	addi	sp,sp,-32
    80001034:	ec06                	sd	ra,24(sp)
    80001036:	e822                	sd	s0,16(sp)
    80001038:	e426                	sd	s1,8(sp)
    8000103a:	1000                	addi	s0,sp,32
    8000103c:	84aa                	mv	s1,a0
    8000103e:	00000097          	auipc	ra,0x0
    80001042:	ec6080e7          	jalr	-314(ra) # 80000f04 <holding>
    80001046:	c115                	beqz	a0,8000106a <release+0x38>
    80001048:	0004b823          	sd	zero,16(s1)
    8000104c:	0ff0000f          	fence
    80001050:	0f50000f          	fence	iorw,ow
    80001054:	0804a02f          	amoswap.w	zero,zero,(s1)
    80001058:	00000097          	auipc	ra,0x0
    8000105c:	f7a080e7          	jalr	-134(ra) # 80000fd2 <pop_off>
    80001060:	60e2                	ld	ra,24(sp)
    80001062:	6442                	ld	s0,16(sp)
    80001064:	64a2                	ld	s1,8(sp)
    80001066:	6105                	addi	sp,sp,32
    80001068:	8082                	ret
    8000106a:	00007517          	auipc	a0,0x7
    8000106e:	0ee50513          	addi	a0,a0,238 # 80008158 <digits+0xf0>
    80001072:	fffff097          	auipc	ra,0xfffff
    80001076:	576080e7          	jalr	1398(ra) # 800005e8 <panic>

000000008000107a <memset>:
    8000107a:	1141                	addi	sp,sp,-16
    8000107c:	e422                	sd	s0,8(sp)
    8000107e:	0800                	addi	s0,sp,16
    80001080:	ca19                	beqz	a2,80001096 <memset+0x1c>
    80001082:	87aa                	mv	a5,a0
    80001084:	1602                	slli	a2,a2,0x20
    80001086:	9201                	srli	a2,a2,0x20
    80001088:	00a60733          	add	a4,a2,a0
    8000108c:	00b78023          	sb	a1,0(a5)
    80001090:	0785                	addi	a5,a5,1
    80001092:	fee79de3          	bne	a5,a4,8000108c <memset+0x12>
    80001096:	6422                	ld	s0,8(sp)
    80001098:	0141                	addi	sp,sp,16
    8000109a:	8082                	ret

000000008000109c <memcmp>:
    8000109c:	1141                	addi	sp,sp,-16
    8000109e:	e422                	sd	s0,8(sp)
    800010a0:	0800                	addi	s0,sp,16
    800010a2:	ca05                	beqz	a2,800010d2 <memcmp+0x36>
    800010a4:	fff6069b          	addiw	a3,a2,-1
    800010a8:	1682                	slli	a3,a3,0x20
    800010aa:	9281                	srli	a3,a3,0x20
    800010ac:	0685                	addi	a3,a3,1
    800010ae:	96aa                	add	a3,a3,a0
    800010b0:	00054783          	lbu	a5,0(a0)
    800010b4:	0005c703          	lbu	a4,0(a1)
    800010b8:	00e79863          	bne	a5,a4,800010c8 <memcmp+0x2c>
    800010bc:	0505                	addi	a0,a0,1
    800010be:	0585                	addi	a1,a1,1
    800010c0:	fed518e3          	bne	a0,a3,800010b0 <memcmp+0x14>
    800010c4:	4501                	li	a0,0
    800010c6:	a019                	j	800010cc <memcmp+0x30>
    800010c8:	40e7853b          	subw	a0,a5,a4
    800010cc:	6422                	ld	s0,8(sp)
    800010ce:	0141                	addi	sp,sp,16
    800010d0:	8082                	ret
    800010d2:	4501                	li	a0,0
    800010d4:	bfe5                	j	800010cc <memcmp+0x30>

00000000800010d6 <memmove>:
    800010d6:	1141                	addi	sp,sp,-16
    800010d8:	e422                	sd	s0,8(sp)
    800010da:	0800                	addi	s0,sp,16
    800010dc:	02a5e563          	bltu	a1,a0,80001106 <memmove+0x30>
    800010e0:	fff6069b          	addiw	a3,a2,-1
    800010e4:	ce11                	beqz	a2,80001100 <memmove+0x2a>
    800010e6:	1682                	slli	a3,a3,0x20
    800010e8:	9281                	srli	a3,a3,0x20
    800010ea:	0685                	addi	a3,a3,1
    800010ec:	96ae                	add	a3,a3,a1
    800010ee:	87aa                	mv	a5,a0
    800010f0:	0585                	addi	a1,a1,1
    800010f2:	0785                	addi	a5,a5,1
    800010f4:	fff5c703          	lbu	a4,-1(a1)
    800010f8:	fee78fa3          	sb	a4,-1(a5)
    800010fc:	fed59ae3          	bne	a1,a3,800010f0 <memmove+0x1a>
    80001100:	6422                	ld	s0,8(sp)
    80001102:	0141                	addi	sp,sp,16
    80001104:	8082                	ret
    80001106:	02061713          	slli	a4,a2,0x20
    8000110a:	9301                	srli	a4,a4,0x20
    8000110c:	00e587b3          	add	a5,a1,a4
    80001110:	fcf578e3          	bgeu	a0,a5,800010e0 <memmove+0xa>
    80001114:	972a                	add	a4,a4,a0
    80001116:	fff6069b          	addiw	a3,a2,-1
    8000111a:	d27d                	beqz	a2,80001100 <memmove+0x2a>
    8000111c:	02069613          	slli	a2,a3,0x20
    80001120:	9201                	srli	a2,a2,0x20
    80001122:	fff64613          	not	a2,a2
    80001126:	963e                	add	a2,a2,a5
    80001128:	17fd                	addi	a5,a5,-1
    8000112a:	177d                	addi	a4,a4,-1
    8000112c:	0007c683          	lbu	a3,0(a5)
    80001130:	00d70023          	sb	a3,0(a4)
    80001134:	fef61ae3          	bne	a2,a5,80001128 <memmove+0x52>
    80001138:	b7e1                	j	80001100 <memmove+0x2a>

000000008000113a <memcpy>:
    8000113a:	1141                	addi	sp,sp,-16
    8000113c:	e406                	sd	ra,8(sp)
    8000113e:	e022                	sd	s0,0(sp)
    80001140:	0800                	addi	s0,sp,16
    80001142:	00000097          	auipc	ra,0x0
    80001146:	f94080e7          	jalr	-108(ra) # 800010d6 <memmove>
    8000114a:	60a2                	ld	ra,8(sp)
    8000114c:	6402                	ld	s0,0(sp)
    8000114e:	0141                	addi	sp,sp,16
    80001150:	8082                	ret

0000000080001152 <strncmp>:
    80001152:	1141                	addi	sp,sp,-16
    80001154:	e422                	sd	s0,8(sp)
    80001156:	0800                	addi	s0,sp,16
    80001158:	ce11                	beqz	a2,80001174 <strncmp+0x22>
    8000115a:	00054783          	lbu	a5,0(a0)
    8000115e:	cf89                	beqz	a5,80001178 <strncmp+0x26>
    80001160:	0005c703          	lbu	a4,0(a1)
    80001164:	00f71a63          	bne	a4,a5,80001178 <strncmp+0x26>
    80001168:	367d                	addiw	a2,a2,-1
    8000116a:	0505                	addi	a0,a0,1
    8000116c:	0585                	addi	a1,a1,1
    8000116e:	f675                	bnez	a2,8000115a <strncmp+0x8>
    80001170:	4501                	li	a0,0
    80001172:	a809                	j	80001184 <strncmp+0x32>
    80001174:	4501                	li	a0,0
    80001176:	a039                	j	80001184 <strncmp+0x32>
    80001178:	ca09                	beqz	a2,8000118a <strncmp+0x38>
    8000117a:	00054503          	lbu	a0,0(a0)
    8000117e:	0005c783          	lbu	a5,0(a1)
    80001182:	9d1d                	subw	a0,a0,a5
    80001184:	6422                	ld	s0,8(sp)
    80001186:	0141                	addi	sp,sp,16
    80001188:	8082                	ret
    8000118a:	4501                	li	a0,0
    8000118c:	bfe5                	j	80001184 <strncmp+0x32>

000000008000118e <strncpy>:
    8000118e:	1141                	addi	sp,sp,-16
    80001190:	e422                	sd	s0,8(sp)
    80001192:	0800                	addi	s0,sp,16
    80001194:	872a                	mv	a4,a0
    80001196:	8832                	mv	a6,a2
    80001198:	367d                	addiw	a2,a2,-1
    8000119a:	01005963          	blez	a6,800011ac <strncpy+0x1e>
    8000119e:	0705                	addi	a4,a4,1
    800011a0:	0005c783          	lbu	a5,0(a1)
    800011a4:	fef70fa3          	sb	a5,-1(a4)
    800011a8:	0585                	addi	a1,a1,1
    800011aa:	f7f5                	bnez	a5,80001196 <strncpy+0x8>
    800011ac:	86ba                	mv	a3,a4
    800011ae:	00c05c63          	blez	a2,800011c6 <strncpy+0x38>
    800011b2:	0685                	addi	a3,a3,1
    800011b4:	fe068fa3          	sb	zero,-1(a3)
    800011b8:	fff6c793          	not	a5,a3
    800011bc:	9fb9                	addw	a5,a5,a4
    800011be:	010787bb          	addw	a5,a5,a6
    800011c2:	fef048e3          	bgtz	a5,800011b2 <strncpy+0x24>
    800011c6:	6422                	ld	s0,8(sp)
    800011c8:	0141                	addi	sp,sp,16
    800011ca:	8082                	ret

00000000800011cc <safestrcpy>:
    800011cc:	1141                	addi	sp,sp,-16
    800011ce:	e422                	sd	s0,8(sp)
    800011d0:	0800                	addi	s0,sp,16
    800011d2:	02c05363          	blez	a2,800011f8 <safestrcpy+0x2c>
    800011d6:	fff6069b          	addiw	a3,a2,-1
    800011da:	1682                	slli	a3,a3,0x20
    800011dc:	9281                	srli	a3,a3,0x20
    800011de:	96ae                	add	a3,a3,a1
    800011e0:	87aa                	mv	a5,a0
    800011e2:	00d58963          	beq	a1,a3,800011f4 <safestrcpy+0x28>
    800011e6:	0585                	addi	a1,a1,1
    800011e8:	0785                	addi	a5,a5,1
    800011ea:	fff5c703          	lbu	a4,-1(a1)
    800011ee:	fee78fa3          	sb	a4,-1(a5)
    800011f2:	fb65                	bnez	a4,800011e2 <safestrcpy+0x16>
    800011f4:	00078023          	sb	zero,0(a5)
    800011f8:	6422                	ld	s0,8(sp)
    800011fa:	0141                	addi	sp,sp,16
    800011fc:	8082                	ret

00000000800011fe <strlen>:
    800011fe:	1141                	addi	sp,sp,-16
    80001200:	e422                	sd	s0,8(sp)
    80001202:	0800                	addi	s0,sp,16
    80001204:	00054783          	lbu	a5,0(a0)
    80001208:	cf91                	beqz	a5,80001224 <strlen+0x26>
    8000120a:	0505                	addi	a0,a0,1
    8000120c:	87aa                	mv	a5,a0
    8000120e:	4685                	li	a3,1
    80001210:	9e89                	subw	a3,a3,a0
    80001212:	00f6853b          	addw	a0,a3,a5
    80001216:	0785                	addi	a5,a5,1
    80001218:	fff7c703          	lbu	a4,-1(a5)
    8000121c:	fb7d                	bnez	a4,80001212 <strlen+0x14>
    8000121e:	6422                	ld	s0,8(sp)
    80001220:	0141                	addi	sp,sp,16
    80001222:	8082                	ret
    80001224:	4501                	li	a0,0
    80001226:	bfe5                	j	8000121e <strlen+0x20>

0000000080001228 <main>:
    80001228:	1141                	addi	sp,sp,-16
    8000122a:	e406                	sd	ra,8(sp)
    8000122c:	e022                	sd	s0,0(sp)
    8000122e:	0800                	addi	s0,sp,16
    80001230:	00001097          	auipc	ra,0x1
    80001234:	ca2080e7          	jalr	-862(ra) # 80001ed2 <cpuid>
    80001238:	00008717          	auipc	a4,0x8
    8000123c:	dd470713          	addi	a4,a4,-556 # 8000900c <started>
    80001240:	c139                	beqz	a0,80001286 <main+0x5e>
    80001242:	431c                	lw	a5,0(a4)
    80001244:	2781                	sext.w	a5,a5
    80001246:	dff5                	beqz	a5,80001242 <main+0x1a>
    80001248:	0ff0000f          	fence
    8000124c:	00001097          	auipc	ra,0x1
    80001250:	c86080e7          	jalr	-890(ra) # 80001ed2 <cpuid>
    80001254:	85aa                	mv	a1,a0
    80001256:	00007517          	auipc	a0,0x7
    8000125a:	f2250513          	addi	a0,a0,-222 # 80008178 <digits+0x110>
    8000125e:	fffff097          	auipc	ra,0xfffff
    80001262:	3dc080e7          	jalr	988(ra) # 8000063a <printf>
    80001266:	00000097          	auipc	ra,0x0
    8000126a:	0d8080e7          	jalr	216(ra) # 8000133e <kvminithart>
    8000126e:	00002097          	auipc	ra,0x2
    80001272:	8ea080e7          	jalr	-1814(ra) # 80002b58 <trapinithart>
    80001276:	00005097          	auipc	ra,0x5
    8000127a:	f6a080e7          	jalr	-150(ra) # 800061e0 <plicinithart>
    8000127e:	00001097          	auipc	ra,0x1
    80001282:	1b4080e7          	jalr	436(ra) # 80002432 <scheduler>
    80001286:	fffff097          	auipc	ra,0xfffff
    8000128a:	1d0080e7          	jalr	464(ra) # 80000456 <consoleinit>
    8000128e:	fffff097          	auipc	ra,0xfffff
    80001292:	2b8080e7          	jalr	696(ra) # 80000546 <printfinit>
    80001296:	00007517          	auipc	a0,0x7
    8000129a:	ef250513          	addi	a0,a0,-270 # 80008188 <digits+0x120>
    8000129e:	fffff097          	auipc	ra,0xfffff
    800012a2:	39c080e7          	jalr	924(ra) # 8000063a <printf>
    800012a6:	00007517          	auipc	a0,0x7
    800012aa:	eba50513          	addi	a0,a0,-326 # 80008160 <digits+0xf8>
    800012ae:	fffff097          	auipc	ra,0xfffff
    800012b2:	38c080e7          	jalr	908(ra) # 8000063a <printf>
    800012b6:	00007517          	auipc	a0,0x7
    800012ba:	ed250513          	addi	a0,a0,-302 # 80008188 <digits+0x120>
    800012be:	fffff097          	auipc	ra,0xfffff
    800012c2:	37c080e7          	jalr	892(ra) # 8000063a <printf>
    800012c6:	00000097          	auipc	ra,0x0
    800012ca:	92c080e7          	jalr	-1748(ra) # 80000bf2 <kinit>
    800012ce:	00000097          	auipc	ra,0x0
    800012d2:	296080e7          	jalr	662(ra) # 80001564 <kvminit>
    800012d6:	00000097          	auipc	ra,0x0
    800012da:	068080e7          	jalr	104(ra) # 8000133e <kvminithart>
    800012de:	00001097          	auipc	ra,0x1
    800012e2:	b24080e7          	jalr	-1244(ra) # 80001e02 <procinit>
    800012e6:	00002097          	auipc	ra,0x2
    800012ea:	84a080e7          	jalr	-1974(ra) # 80002b30 <trapinit>
    800012ee:	00002097          	auipc	ra,0x2
    800012f2:	86a080e7          	jalr	-1942(ra) # 80002b58 <trapinithart>
    800012f6:	00005097          	auipc	ra,0x5
    800012fa:	ed4080e7          	jalr	-300(ra) # 800061ca <plicinit>
    800012fe:	00005097          	auipc	ra,0x5
    80001302:	ee2080e7          	jalr	-286(ra) # 800061e0 <plicinithart>
    80001306:	00002097          	auipc	ra,0x2
    8000130a:	08e080e7          	jalr	142(ra) # 80003394 <binit>
    8000130e:	00002097          	auipc	ra,0x2
    80001312:	71e080e7          	jalr	1822(ra) # 80003a2c <iinit>
    80001316:	00003097          	auipc	ra,0x3
    8000131a:	6bc080e7          	jalr	1724(ra) # 800049d2 <fileinit>
    8000131e:	00005097          	auipc	ra,0x5
    80001322:	fca080e7          	jalr	-54(ra) # 800062e8 <virtio_disk_init>
    80001326:	00001097          	auipc	ra,0x1
    8000132a:	ea2080e7          	jalr	-350(ra) # 800021c8 <userinit>
    8000132e:	0ff0000f          	fence
    80001332:	4785                	li	a5,1
    80001334:	00008717          	auipc	a4,0x8
    80001338:	ccf72c23          	sw	a5,-808(a4) # 8000900c <started>
    8000133c:	b789                	j	8000127e <main+0x56>

000000008000133e <kvminithart>:
    8000133e:	1141                	addi	sp,sp,-16
    80001340:	e422                	sd	s0,8(sp)
    80001342:	0800                	addi	s0,sp,16
    80001344:	00008797          	auipc	a5,0x8
    80001348:	ccc7b783          	ld	a5,-820(a5) # 80009010 <kernel_pagetable>
    8000134c:	83b1                	srli	a5,a5,0xc
    8000134e:	577d                	li	a4,-1
    80001350:	177e                	slli	a4,a4,0x3f
    80001352:	8fd9                	or	a5,a5,a4
    80001354:	18079073          	csrw	satp,a5
    80001358:	12000073          	sfence.vma
    8000135c:	6422                	ld	s0,8(sp)
    8000135e:	0141                	addi	sp,sp,16
    80001360:	8082                	ret

0000000080001362 <walk>:
    80001362:	57fd                	li	a5,-1
    80001364:	83e9                	srli	a5,a5,0x1a
    80001366:	08b7e863          	bltu	a5,a1,800013f6 <walk+0x94>
    8000136a:	7139                	addi	sp,sp,-64
    8000136c:	fc06                	sd	ra,56(sp)
    8000136e:	f822                	sd	s0,48(sp)
    80001370:	f426                	sd	s1,40(sp)
    80001372:	f04a                	sd	s2,32(sp)
    80001374:	ec4e                	sd	s3,24(sp)
    80001376:	e852                	sd	s4,16(sp)
    80001378:	e456                	sd	s5,8(sp)
    8000137a:	e05a                	sd	s6,0(sp)
    8000137c:	0080                	addi	s0,sp,64
    8000137e:	84aa                	mv	s1,a0
    80001380:	89ae                	mv	s3,a1
    80001382:	8ab2                	mv	s5,a2
    80001384:	4a79                	li	s4,30
    80001386:	4b31                	li	s6,12
    80001388:	a80d                	j	800013ba <walk+0x58>
    8000138a:	060a8863          	beqz	s5,800013fa <walk+0x98>
    8000138e:	00000097          	auipc	ra,0x0
    80001392:	9de080e7          	jalr	-1570(ra) # 80000d6c <kalloc>
    80001396:	84aa                	mv	s1,a0
    80001398:	c529                	beqz	a0,800013e2 <walk+0x80>
    8000139a:	6605                	lui	a2,0x1
    8000139c:	4581                	li	a1,0
    8000139e:	00000097          	auipc	ra,0x0
    800013a2:	cdc080e7          	jalr	-804(ra) # 8000107a <memset>
    800013a6:	00c4d793          	srli	a5,s1,0xc
    800013aa:	07aa                	slli	a5,a5,0xa
    800013ac:	0017e793          	ori	a5,a5,1
    800013b0:	00f93023          	sd	a5,0(s2)
    800013b4:	3a5d                	addiw	s4,s4,-9
    800013b6:	036a0063          	beq	s4,s6,800013d6 <walk+0x74>
    800013ba:	0149d933          	srl	s2,s3,s4
    800013be:	1ff97913          	andi	s2,s2,511
    800013c2:	090e                	slli	s2,s2,0x3
    800013c4:	9926                	add	s2,s2,s1
    800013c6:	00093483          	ld	s1,0(s2)
    800013ca:	0014f793          	andi	a5,s1,1
    800013ce:	dfd5                	beqz	a5,8000138a <walk+0x28>
    800013d0:	80a9                	srli	s1,s1,0xa
    800013d2:	04b2                	slli	s1,s1,0xc
    800013d4:	b7c5                	j	800013b4 <walk+0x52>
    800013d6:	00c9d513          	srli	a0,s3,0xc
    800013da:	1ff57513          	andi	a0,a0,511
    800013de:	050e                	slli	a0,a0,0x3
    800013e0:	9526                	add	a0,a0,s1
    800013e2:	70e2                	ld	ra,56(sp)
    800013e4:	7442                	ld	s0,48(sp)
    800013e6:	74a2                	ld	s1,40(sp)
    800013e8:	7902                	ld	s2,32(sp)
    800013ea:	69e2                	ld	s3,24(sp)
    800013ec:	6a42                	ld	s4,16(sp)
    800013ee:	6aa2                	ld	s5,8(sp)
    800013f0:	6b02                	ld	s6,0(sp)
    800013f2:	6121                	addi	sp,sp,64
    800013f4:	8082                	ret
    800013f6:	4501                	li	a0,0
    800013f8:	8082                	ret
    800013fa:	4501                	li	a0,0
    800013fc:	b7dd                	j	800013e2 <walk+0x80>

00000000800013fe <walkaddr>:
    800013fe:	57fd                	li	a5,-1
    80001400:	83e9                	srli	a5,a5,0x1a
    80001402:	00b7f463          	bgeu	a5,a1,8000140a <walkaddr+0xc>
    80001406:	4501                	li	a0,0
    80001408:	8082                	ret
    8000140a:	1141                	addi	sp,sp,-16
    8000140c:	e406                	sd	ra,8(sp)
    8000140e:	e022                	sd	s0,0(sp)
    80001410:	0800                	addi	s0,sp,16
    80001412:	4601                	li	a2,0
    80001414:	00000097          	auipc	ra,0x0
    80001418:	f4e080e7          	jalr	-178(ra) # 80001362 <walk>
    8000141c:	c105                	beqz	a0,8000143c <walkaddr+0x3e>
    8000141e:	611c                	ld	a5,0(a0)
    80001420:	0117f693          	andi	a3,a5,17
    80001424:	4745                	li	a4,17
    80001426:	4501                	li	a0,0
    80001428:	00e68663          	beq	a3,a4,80001434 <walkaddr+0x36>
    8000142c:	60a2                	ld	ra,8(sp)
    8000142e:	6402                	ld	s0,0(sp)
    80001430:	0141                	addi	sp,sp,16
    80001432:	8082                	ret
    80001434:	00a7d513          	srli	a0,a5,0xa
    80001438:	0532                	slli	a0,a0,0xc
    8000143a:	bfcd                	j	8000142c <walkaddr+0x2e>
    8000143c:	4501                	li	a0,0
    8000143e:	b7fd                	j	8000142c <walkaddr+0x2e>

0000000080001440 <kvmpa>:
    80001440:	1101                	addi	sp,sp,-32
    80001442:	ec06                	sd	ra,24(sp)
    80001444:	e822                	sd	s0,16(sp)
    80001446:	e426                	sd	s1,8(sp)
    80001448:	1000                	addi	s0,sp,32
    8000144a:	85aa                	mv	a1,a0
    8000144c:	1552                	slli	a0,a0,0x34
    8000144e:	03455493          	srli	s1,a0,0x34
    80001452:	4601                	li	a2,0
    80001454:	00008517          	auipc	a0,0x8
    80001458:	bbc53503          	ld	a0,-1092(a0) # 80009010 <kernel_pagetable>
    8000145c:	00000097          	auipc	ra,0x0
    80001460:	f06080e7          	jalr	-250(ra) # 80001362 <walk>
    80001464:	cd09                	beqz	a0,8000147e <kvmpa+0x3e>
    80001466:	6108                	ld	a0,0(a0)
    80001468:	00157793          	andi	a5,a0,1
    8000146c:	c38d                	beqz	a5,8000148e <kvmpa+0x4e>
    8000146e:	8129                	srli	a0,a0,0xa
    80001470:	0532                	slli	a0,a0,0xc
    80001472:	9526                	add	a0,a0,s1
    80001474:	60e2                	ld	ra,24(sp)
    80001476:	6442                	ld	s0,16(sp)
    80001478:	64a2                	ld	s1,8(sp)
    8000147a:	6105                	addi	sp,sp,32
    8000147c:	8082                	ret
    8000147e:	00007517          	auipc	a0,0x7
    80001482:	d1250513          	addi	a0,a0,-750 # 80008190 <digits+0x128>
    80001486:	fffff097          	auipc	ra,0xfffff
    8000148a:	162080e7          	jalr	354(ra) # 800005e8 <panic>
    8000148e:	00007517          	auipc	a0,0x7
    80001492:	d0250513          	addi	a0,a0,-766 # 80008190 <digits+0x128>
    80001496:	fffff097          	auipc	ra,0xfffff
    8000149a:	152080e7          	jalr	338(ra) # 800005e8 <panic>

000000008000149e <mappages>:
    8000149e:	715d                	addi	sp,sp,-80
    800014a0:	e486                	sd	ra,72(sp)
    800014a2:	e0a2                	sd	s0,64(sp)
    800014a4:	fc26                	sd	s1,56(sp)
    800014a6:	f84a                	sd	s2,48(sp)
    800014a8:	f44e                	sd	s3,40(sp)
    800014aa:	f052                	sd	s4,32(sp)
    800014ac:	ec56                	sd	s5,24(sp)
    800014ae:	e85a                	sd	s6,16(sp)
    800014b0:	e45e                	sd	s7,8(sp)
    800014b2:	0880                	addi	s0,sp,80
    800014b4:	8aaa                	mv	s5,a0
    800014b6:	8b3a                	mv	s6,a4
    800014b8:	777d                	lui	a4,0xfffff
    800014ba:	00e5f7b3          	and	a5,a1,a4
    800014be:	167d                	addi	a2,a2,-1
    800014c0:	00b609b3          	add	s3,a2,a1
    800014c4:	00e9f9b3          	and	s3,s3,a4
    800014c8:	893e                	mv	s2,a5
    800014ca:	40f68a33          	sub	s4,a3,a5
    800014ce:	6b85                	lui	s7,0x1
    800014d0:	012a04b3          	add	s1,s4,s2
    800014d4:	4605                	li	a2,1
    800014d6:	85ca                	mv	a1,s2
    800014d8:	8556                	mv	a0,s5
    800014da:	00000097          	auipc	ra,0x0
    800014de:	e88080e7          	jalr	-376(ra) # 80001362 <walk>
    800014e2:	c51d                	beqz	a0,80001510 <mappages+0x72>
    800014e4:	611c                	ld	a5,0(a0)
    800014e6:	8b85                	andi	a5,a5,1
    800014e8:	ef81                	bnez	a5,80001500 <mappages+0x62>
    800014ea:	80b1                	srli	s1,s1,0xc
    800014ec:	04aa                	slli	s1,s1,0xa
    800014ee:	0164e4b3          	or	s1,s1,s6
    800014f2:	0014e493          	ori	s1,s1,1
    800014f6:	e104                	sd	s1,0(a0)
    800014f8:	03390863          	beq	s2,s3,80001528 <mappages+0x8a>
    800014fc:	995e                	add	s2,s2,s7
    800014fe:	bfc9                	j	800014d0 <mappages+0x32>
    80001500:	00007517          	auipc	a0,0x7
    80001504:	c9850513          	addi	a0,a0,-872 # 80008198 <digits+0x130>
    80001508:	fffff097          	auipc	ra,0xfffff
    8000150c:	0e0080e7          	jalr	224(ra) # 800005e8 <panic>
    80001510:	557d                	li	a0,-1
    80001512:	60a6                	ld	ra,72(sp)
    80001514:	6406                	ld	s0,64(sp)
    80001516:	74e2                	ld	s1,56(sp)
    80001518:	7942                	ld	s2,48(sp)
    8000151a:	79a2                	ld	s3,40(sp)
    8000151c:	7a02                	ld	s4,32(sp)
    8000151e:	6ae2                	ld	s5,24(sp)
    80001520:	6b42                	ld	s6,16(sp)
    80001522:	6ba2                	ld	s7,8(sp)
    80001524:	6161                	addi	sp,sp,80
    80001526:	8082                	ret
    80001528:	4501                	li	a0,0
    8000152a:	b7e5                	j	80001512 <mappages+0x74>

000000008000152c <kvmmap>:
    8000152c:	1141                	addi	sp,sp,-16
    8000152e:	e406                	sd	ra,8(sp)
    80001530:	e022                	sd	s0,0(sp)
    80001532:	0800                	addi	s0,sp,16
    80001534:	8736                	mv	a4,a3
    80001536:	86ae                	mv	a3,a1
    80001538:	85aa                	mv	a1,a0
    8000153a:	00008517          	auipc	a0,0x8
    8000153e:	ad653503          	ld	a0,-1322(a0) # 80009010 <kernel_pagetable>
    80001542:	00000097          	auipc	ra,0x0
    80001546:	f5c080e7          	jalr	-164(ra) # 8000149e <mappages>
    8000154a:	e509                	bnez	a0,80001554 <kvmmap+0x28>
    8000154c:	60a2                	ld	ra,8(sp)
    8000154e:	6402                	ld	s0,0(sp)
    80001550:	0141                	addi	sp,sp,16
    80001552:	8082                	ret
    80001554:	00007517          	auipc	a0,0x7
    80001558:	c4c50513          	addi	a0,a0,-948 # 800081a0 <digits+0x138>
    8000155c:	fffff097          	auipc	ra,0xfffff
    80001560:	08c080e7          	jalr	140(ra) # 800005e8 <panic>

0000000080001564 <kvminit>:
    80001564:	1101                	addi	sp,sp,-32
    80001566:	ec06                	sd	ra,24(sp)
    80001568:	e822                	sd	s0,16(sp)
    8000156a:	e426                	sd	s1,8(sp)
    8000156c:	1000                	addi	s0,sp,32
    8000156e:	fffff097          	auipc	ra,0xfffff
    80001572:	7fe080e7          	jalr	2046(ra) # 80000d6c <kalloc>
    80001576:	00008797          	auipc	a5,0x8
    8000157a:	a8a7bd23          	sd	a0,-1382(a5) # 80009010 <kernel_pagetable>
    8000157e:	6605                	lui	a2,0x1
    80001580:	4581                	li	a1,0
    80001582:	00000097          	auipc	ra,0x0
    80001586:	af8080e7          	jalr	-1288(ra) # 8000107a <memset>
    8000158a:	4699                	li	a3,6
    8000158c:	6605                	lui	a2,0x1
    8000158e:	100005b7          	lui	a1,0x10000
    80001592:	10000537          	lui	a0,0x10000
    80001596:	00000097          	auipc	ra,0x0
    8000159a:	f96080e7          	jalr	-106(ra) # 8000152c <kvmmap>
    8000159e:	4699                	li	a3,6
    800015a0:	6605                	lui	a2,0x1
    800015a2:	100015b7          	lui	a1,0x10001
    800015a6:	10001537          	lui	a0,0x10001
    800015aa:	00000097          	auipc	ra,0x0
    800015ae:	f82080e7          	jalr	-126(ra) # 8000152c <kvmmap>
    800015b2:	4699                	li	a3,6
    800015b4:	6641                	lui	a2,0x10
    800015b6:	020005b7          	lui	a1,0x2000
    800015ba:	02000537          	lui	a0,0x2000
    800015be:	00000097          	auipc	ra,0x0
    800015c2:	f6e080e7          	jalr	-146(ra) # 8000152c <kvmmap>
    800015c6:	4699                	li	a3,6
    800015c8:	00400637          	lui	a2,0x400
    800015cc:	0c0005b7          	lui	a1,0xc000
    800015d0:	0c000537          	lui	a0,0xc000
    800015d4:	00000097          	auipc	ra,0x0
    800015d8:	f58080e7          	jalr	-168(ra) # 8000152c <kvmmap>
    800015dc:	00007497          	auipc	s1,0x7
    800015e0:	a2448493          	addi	s1,s1,-1500 # 80008000 <etext>
    800015e4:	46a9                	li	a3,10
    800015e6:	80007617          	auipc	a2,0x80007
    800015ea:	a1a60613          	addi	a2,a2,-1510 # 8000 <_entry-0x7fff8000>
    800015ee:	4585                	li	a1,1
    800015f0:	05fe                	slli	a1,a1,0x1f
    800015f2:	852e                	mv	a0,a1
    800015f4:	00000097          	auipc	ra,0x0
    800015f8:	f38080e7          	jalr	-200(ra) # 8000152c <kvmmap>
    800015fc:	4699                	li	a3,6
    800015fe:	4645                	li	a2,17
    80001600:	066e                	slli	a2,a2,0x1b
    80001602:	8e05                	sub	a2,a2,s1
    80001604:	85a6                	mv	a1,s1
    80001606:	8526                	mv	a0,s1
    80001608:	00000097          	auipc	ra,0x0
    8000160c:	f24080e7          	jalr	-220(ra) # 8000152c <kvmmap>
    80001610:	46a9                	li	a3,10
    80001612:	6605                	lui	a2,0x1
    80001614:	00006597          	auipc	a1,0x6
    80001618:	9ec58593          	addi	a1,a1,-1556 # 80007000 <_trampoline>
    8000161c:	04000537          	lui	a0,0x4000
    80001620:	157d                	addi	a0,a0,-1
    80001622:	0532                	slli	a0,a0,0xc
    80001624:	00000097          	auipc	ra,0x0
    80001628:	f08080e7          	jalr	-248(ra) # 8000152c <kvmmap>
    8000162c:	60e2                	ld	ra,24(sp)
    8000162e:	6442                	ld	s0,16(sp)
    80001630:	64a2                	ld	s1,8(sp)
    80001632:	6105                	addi	sp,sp,32
    80001634:	8082                	ret

0000000080001636 <uvmunmap>:
    80001636:	715d                	addi	sp,sp,-80
    80001638:	e486                	sd	ra,72(sp)
    8000163a:	e0a2                	sd	s0,64(sp)
    8000163c:	fc26                	sd	s1,56(sp)
    8000163e:	f84a                	sd	s2,48(sp)
    80001640:	f44e                	sd	s3,40(sp)
    80001642:	f052                	sd	s4,32(sp)
    80001644:	ec56                	sd	s5,24(sp)
    80001646:	e85a                	sd	s6,16(sp)
    80001648:	e45e                	sd	s7,8(sp)
    8000164a:	0880                	addi	s0,sp,80
    8000164c:	03459793          	slli	a5,a1,0x34
    80001650:	e795                	bnez	a5,8000167c <uvmunmap+0x46>
    80001652:	8a2a                	mv	s4,a0
    80001654:	892e                	mv	s2,a1
    80001656:	8b36                	mv	s6,a3
    80001658:	0632                	slli	a2,a2,0xc
    8000165a:	00b609b3          	add	s3,a2,a1
    8000165e:	4b85                	li	s7,1
    80001660:	6a85                	lui	s5,0x1
    80001662:	0535e263          	bltu	a1,s3,800016a6 <uvmunmap+0x70>
    80001666:	60a6                	ld	ra,72(sp)
    80001668:	6406                	ld	s0,64(sp)
    8000166a:	74e2                	ld	s1,56(sp)
    8000166c:	7942                	ld	s2,48(sp)
    8000166e:	79a2                	ld	s3,40(sp)
    80001670:	7a02                	ld	s4,32(sp)
    80001672:	6ae2                	ld	s5,24(sp)
    80001674:	6b42                	ld	s6,16(sp)
    80001676:	6ba2                	ld	s7,8(sp)
    80001678:	6161                	addi	sp,sp,80
    8000167a:	8082                	ret
    8000167c:	00007517          	auipc	a0,0x7
    80001680:	b2c50513          	addi	a0,a0,-1236 # 800081a8 <digits+0x140>
    80001684:	fffff097          	auipc	ra,0xfffff
    80001688:	f64080e7          	jalr	-156(ra) # 800005e8 <panic>
    8000168c:	00007517          	auipc	a0,0x7
    80001690:	b3450513          	addi	a0,a0,-1228 # 800081c0 <digits+0x158>
    80001694:	fffff097          	auipc	ra,0xfffff
    80001698:	f54080e7          	jalr	-172(ra) # 800005e8 <panic>
    8000169c:	0004b023          	sd	zero,0(s1)
    800016a0:	9956                	add	s2,s2,s5
    800016a2:	fd3972e3          	bgeu	s2,s3,80001666 <uvmunmap+0x30>
    800016a6:	4601                	li	a2,0
    800016a8:	85ca                	mv	a1,s2
    800016aa:	8552                	mv	a0,s4
    800016ac:	00000097          	auipc	ra,0x0
    800016b0:	cb6080e7          	jalr	-842(ra) # 80001362 <walk>
    800016b4:	84aa                	mv	s1,a0
    800016b6:	d56d                	beqz	a0,800016a0 <uvmunmap+0x6a>
    800016b8:	611c                	ld	a5,0(a0)
    800016ba:	0017f713          	andi	a4,a5,1
    800016be:	d36d                	beqz	a4,800016a0 <uvmunmap+0x6a>
    800016c0:	3ff7f713          	andi	a4,a5,1023
    800016c4:	fd7704e3          	beq	a4,s7,8000168c <uvmunmap+0x56>
    800016c8:	fc0b0ae3          	beqz	s6,8000169c <uvmunmap+0x66>
    800016cc:	83a9                	srli	a5,a5,0xa
    800016ce:	00c79513          	slli	a0,a5,0xc
    800016d2:	fffff097          	auipc	ra,0xfffff
    800016d6:	3bc080e7          	jalr	956(ra) # 80000a8e <kfree>
    800016da:	b7c9                	j	8000169c <uvmunmap+0x66>

00000000800016dc <uvmcreate>:
    800016dc:	1101                	addi	sp,sp,-32
    800016de:	ec06                	sd	ra,24(sp)
    800016e0:	e822                	sd	s0,16(sp)
    800016e2:	e426                	sd	s1,8(sp)
    800016e4:	1000                	addi	s0,sp,32
    800016e6:	fffff097          	auipc	ra,0xfffff
    800016ea:	686080e7          	jalr	1670(ra) # 80000d6c <kalloc>
    800016ee:	84aa                	mv	s1,a0
    800016f0:	c519                	beqz	a0,800016fe <uvmcreate+0x22>
    800016f2:	6605                	lui	a2,0x1
    800016f4:	4581                	li	a1,0
    800016f6:	00000097          	auipc	ra,0x0
    800016fa:	984080e7          	jalr	-1660(ra) # 8000107a <memset>
    800016fe:	8526                	mv	a0,s1
    80001700:	60e2                	ld	ra,24(sp)
    80001702:	6442                	ld	s0,16(sp)
    80001704:	64a2                	ld	s1,8(sp)
    80001706:	6105                	addi	sp,sp,32
    80001708:	8082                	ret

000000008000170a <uvminit>:
    8000170a:	7179                	addi	sp,sp,-48
    8000170c:	f406                	sd	ra,40(sp)
    8000170e:	f022                	sd	s0,32(sp)
    80001710:	ec26                	sd	s1,24(sp)
    80001712:	e84a                	sd	s2,16(sp)
    80001714:	e44e                	sd	s3,8(sp)
    80001716:	e052                	sd	s4,0(sp)
    80001718:	1800                	addi	s0,sp,48
    8000171a:	6785                	lui	a5,0x1
    8000171c:	04f67863          	bgeu	a2,a5,8000176c <uvminit+0x62>
    80001720:	8a2a                	mv	s4,a0
    80001722:	89ae                	mv	s3,a1
    80001724:	84b2                	mv	s1,a2
    80001726:	fffff097          	auipc	ra,0xfffff
    8000172a:	646080e7          	jalr	1606(ra) # 80000d6c <kalloc>
    8000172e:	892a                	mv	s2,a0
    80001730:	6605                	lui	a2,0x1
    80001732:	4581                	li	a1,0
    80001734:	00000097          	auipc	ra,0x0
    80001738:	946080e7          	jalr	-1722(ra) # 8000107a <memset>
    8000173c:	4779                	li	a4,30
    8000173e:	86ca                	mv	a3,s2
    80001740:	6605                	lui	a2,0x1
    80001742:	4581                	li	a1,0
    80001744:	8552                	mv	a0,s4
    80001746:	00000097          	auipc	ra,0x0
    8000174a:	d58080e7          	jalr	-680(ra) # 8000149e <mappages>
    8000174e:	8626                	mv	a2,s1
    80001750:	85ce                	mv	a1,s3
    80001752:	854a                	mv	a0,s2
    80001754:	00000097          	auipc	ra,0x0
    80001758:	982080e7          	jalr	-1662(ra) # 800010d6 <memmove>
    8000175c:	70a2                	ld	ra,40(sp)
    8000175e:	7402                	ld	s0,32(sp)
    80001760:	64e2                	ld	s1,24(sp)
    80001762:	6942                	ld	s2,16(sp)
    80001764:	69a2                	ld	s3,8(sp)
    80001766:	6a02                	ld	s4,0(sp)
    80001768:	6145                	addi	sp,sp,48
    8000176a:	8082                	ret
    8000176c:	00007517          	auipc	a0,0x7
    80001770:	a6c50513          	addi	a0,a0,-1428 # 800081d8 <digits+0x170>
    80001774:	fffff097          	auipc	ra,0xfffff
    80001778:	e74080e7          	jalr	-396(ra) # 800005e8 <panic>

000000008000177c <uvmdealloc>:
    8000177c:	1101                	addi	sp,sp,-32
    8000177e:	ec06                	sd	ra,24(sp)
    80001780:	e822                	sd	s0,16(sp)
    80001782:	e426                	sd	s1,8(sp)
    80001784:	1000                	addi	s0,sp,32
    80001786:	84ae                	mv	s1,a1
    80001788:	00b67d63          	bgeu	a2,a1,800017a2 <uvmdealloc+0x26>
    8000178c:	84b2                	mv	s1,a2
    8000178e:	6785                	lui	a5,0x1
    80001790:	17fd                	addi	a5,a5,-1
    80001792:	00f60733          	add	a4,a2,a5
    80001796:	767d                	lui	a2,0xfffff
    80001798:	8f71                	and	a4,a4,a2
    8000179a:	97ae                	add	a5,a5,a1
    8000179c:	8ff1                	and	a5,a5,a2
    8000179e:	00f76863          	bltu	a4,a5,800017ae <uvmdealloc+0x32>
    800017a2:	8526                	mv	a0,s1
    800017a4:	60e2                	ld	ra,24(sp)
    800017a6:	6442                	ld	s0,16(sp)
    800017a8:	64a2                	ld	s1,8(sp)
    800017aa:	6105                	addi	sp,sp,32
    800017ac:	8082                	ret
    800017ae:	8f99                	sub	a5,a5,a4
    800017b0:	83b1                	srli	a5,a5,0xc
    800017b2:	4685                	li	a3,1
    800017b4:	0007861b          	sext.w	a2,a5
    800017b8:	85ba                	mv	a1,a4
    800017ba:	00000097          	auipc	ra,0x0
    800017be:	e7c080e7          	jalr	-388(ra) # 80001636 <uvmunmap>
    800017c2:	b7c5                	j	800017a2 <uvmdealloc+0x26>

00000000800017c4 <uvmalloc>:
    800017c4:	0ab66163          	bltu	a2,a1,80001866 <uvmalloc+0xa2>
    800017c8:	7139                	addi	sp,sp,-64
    800017ca:	fc06                	sd	ra,56(sp)
    800017cc:	f822                	sd	s0,48(sp)
    800017ce:	f426                	sd	s1,40(sp)
    800017d0:	f04a                	sd	s2,32(sp)
    800017d2:	ec4e                	sd	s3,24(sp)
    800017d4:	e852                	sd	s4,16(sp)
    800017d6:	e456                	sd	s5,8(sp)
    800017d8:	0080                	addi	s0,sp,64
    800017da:	8aaa                	mv	s5,a0
    800017dc:	8a32                	mv	s4,a2
    800017de:	6985                	lui	s3,0x1
    800017e0:	19fd                	addi	s3,s3,-1
    800017e2:	95ce                	add	a1,a1,s3
    800017e4:	79fd                	lui	s3,0xfffff
    800017e6:	0135f9b3          	and	s3,a1,s3
    800017ea:	08c9f063          	bgeu	s3,a2,8000186a <uvmalloc+0xa6>
    800017ee:	894e                	mv	s2,s3
    800017f0:	fffff097          	auipc	ra,0xfffff
    800017f4:	57c080e7          	jalr	1404(ra) # 80000d6c <kalloc>
    800017f8:	84aa                	mv	s1,a0
    800017fa:	c51d                	beqz	a0,80001828 <uvmalloc+0x64>
    800017fc:	6605                	lui	a2,0x1
    800017fe:	4581                	li	a1,0
    80001800:	00000097          	auipc	ra,0x0
    80001804:	87a080e7          	jalr	-1926(ra) # 8000107a <memset>
    80001808:	4779                	li	a4,30
    8000180a:	86a6                	mv	a3,s1
    8000180c:	6605                	lui	a2,0x1
    8000180e:	85ca                	mv	a1,s2
    80001810:	8556                	mv	a0,s5
    80001812:	00000097          	auipc	ra,0x0
    80001816:	c8c080e7          	jalr	-884(ra) # 8000149e <mappages>
    8000181a:	e905                	bnez	a0,8000184a <uvmalloc+0x86>
    8000181c:	6785                	lui	a5,0x1
    8000181e:	993e                	add	s2,s2,a5
    80001820:	fd4968e3          	bltu	s2,s4,800017f0 <uvmalloc+0x2c>
    80001824:	8552                	mv	a0,s4
    80001826:	a809                	j	80001838 <uvmalloc+0x74>
    80001828:	864e                	mv	a2,s3
    8000182a:	85ca                	mv	a1,s2
    8000182c:	8556                	mv	a0,s5
    8000182e:	00000097          	auipc	ra,0x0
    80001832:	f4e080e7          	jalr	-178(ra) # 8000177c <uvmdealloc>
    80001836:	4501                	li	a0,0
    80001838:	70e2                	ld	ra,56(sp)
    8000183a:	7442                	ld	s0,48(sp)
    8000183c:	74a2                	ld	s1,40(sp)
    8000183e:	7902                	ld	s2,32(sp)
    80001840:	69e2                	ld	s3,24(sp)
    80001842:	6a42                	ld	s4,16(sp)
    80001844:	6aa2                	ld	s5,8(sp)
    80001846:	6121                	addi	sp,sp,64
    80001848:	8082                	ret
    8000184a:	8526                	mv	a0,s1
    8000184c:	fffff097          	auipc	ra,0xfffff
    80001850:	242080e7          	jalr	578(ra) # 80000a8e <kfree>
    80001854:	864e                	mv	a2,s3
    80001856:	85ca                	mv	a1,s2
    80001858:	8556                	mv	a0,s5
    8000185a:	00000097          	auipc	ra,0x0
    8000185e:	f22080e7          	jalr	-222(ra) # 8000177c <uvmdealloc>
    80001862:	4501                	li	a0,0
    80001864:	bfd1                	j	80001838 <uvmalloc+0x74>
    80001866:	852e                	mv	a0,a1
    80001868:	8082                	ret
    8000186a:	8532                	mv	a0,a2
    8000186c:	b7f1                	j	80001838 <uvmalloc+0x74>

000000008000186e <freewalk>:
    8000186e:	7179                	addi	sp,sp,-48
    80001870:	f406                	sd	ra,40(sp)
    80001872:	f022                	sd	s0,32(sp)
    80001874:	ec26                	sd	s1,24(sp)
    80001876:	e84a                	sd	s2,16(sp)
    80001878:	e44e                	sd	s3,8(sp)
    8000187a:	e052                	sd	s4,0(sp)
    8000187c:	1800                	addi	s0,sp,48
    8000187e:	8a2a                	mv	s4,a0
    80001880:	84aa                	mv	s1,a0
    80001882:	6905                	lui	s2,0x1
    80001884:	992a                	add	s2,s2,a0
    80001886:	4985                	li	s3,1
    80001888:	a821                	j	800018a0 <freewalk+0x32>
    8000188a:	8129                	srli	a0,a0,0xa
    8000188c:	0532                	slli	a0,a0,0xc
    8000188e:	00000097          	auipc	ra,0x0
    80001892:	fe0080e7          	jalr	-32(ra) # 8000186e <freewalk>
    80001896:	0004b023          	sd	zero,0(s1)
    8000189a:	04a1                	addi	s1,s1,8
    8000189c:	03248163          	beq	s1,s2,800018be <freewalk+0x50>
    800018a0:	6088                	ld	a0,0(s1)
    800018a2:	00f57793          	andi	a5,a0,15
    800018a6:	ff3782e3          	beq	a5,s3,8000188a <freewalk+0x1c>
    800018aa:	8905                	andi	a0,a0,1
    800018ac:	d57d                	beqz	a0,8000189a <freewalk+0x2c>
    800018ae:	00007517          	auipc	a0,0x7
    800018b2:	94a50513          	addi	a0,a0,-1718 # 800081f8 <digits+0x190>
    800018b6:	fffff097          	auipc	ra,0xfffff
    800018ba:	d32080e7          	jalr	-718(ra) # 800005e8 <panic>
    800018be:	8552                	mv	a0,s4
    800018c0:	fffff097          	auipc	ra,0xfffff
    800018c4:	1ce080e7          	jalr	462(ra) # 80000a8e <kfree>
    800018c8:	70a2                	ld	ra,40(sp)
    800018ca:	7402                	ld	s0,32(sp)
    800018cc:	64e2                	ld	s1,24(sp)
    800018ce:	6942                	ld	s2,16(sp)
    800018d0:	69a2                	ld	s3,8(sp)
    800018d2:	6a02                	ld	s4,0(sp)
    800018d4:	6145                	addi	sp,sp,48
    800018d6:	8082                	ret

00000000800018d8 <uvmfree>:
    800018d8:	1101                	addi	sp,sp,-32
    800018da:	ec06                	sd	ra,24(sp)
    800018dc:	e822                	sd	s0,16(sp)
    800018de:	e426                	sd	s1,8(sp)
    800018e0:	1000                	addi	s0,sp,32
    800018e2:	84aa                	mv	s1,a0
    800018e4:	e999                	bnez	a1,800018fa <uvmfree+0x22>
    800018e6:	8526                	mv	a0,s1
    800018e8:	00000097          	auipc	ra,0x0
    800018ec:	f86080e7          	jalr	-122(ra) # 8000186e <freewalk>
    800018f0:	60e2                	ld	ra,24(sp)
    800018f2:	6442                	ld	s0,16(sp)
    800018f4:	64a2                	ld	s1,8(sp)
    800018f6:	6105                	addi	sp,sp,32
    800018f8:	8082                	ret
    800018fa:	6605                	lui	a2,0x1
    800018fc:	167d                	addi	a2,a2,-1
    800018fe:	962e                	add	a2,a2,a1
    80001900:	4685                	li	a3,1
    80001902:	8231                	srli	a2,a2,0xc
    80001904:	4581                	li	a1,0
    80001906:	00000097          	auipc	ra,0x0
    8000190a:	d30080e7          	jalr	-720(ra) # 80001636 <uvmunmap>
    8000190e:	bfe1                	j	800018e6 <uvmfree+0xe>

0000000080001910 <uvmcopy>:
    80001910:	ce71                	beqz	a2,800019ec <uvmcopy+0xdc>
    80001912:	711d                	addi	sp,sp,-96
    80001914:	ec86                	sd	ra,88(sp)
    80001916:	e8a2                	sd	s0,80(sp)
    80001918:	e4a6                	sd	s1,72(sp)
    8000191a:	e0ca                	sd	s2,64(sp)
    8000191c:	fc4e                	sd	s3,56(sp)
    8000191e:	f852                	sd	s4,48(sp)
    80001920:	f456                	sd	s5,40(sp)
    80001922:	f05a                	sd	s6,32(sp)
    80001924:	ec5e                	sd	s7,24(sp)
    80001926:	e862                	sd	s8,16(sp)
    80001928:	e466                	sd	s9,8(sp)
    8000192a:	e06a                	sd	s10,0(sp)
    8000192c:	1080                	addi	s0,sp,96
    8000192e:	89aa                	mv	s3,a0
    80001930:	8b2e                	mv	s6,a1
    80001932:	8932                	mv	s2,a2
    80001934:	4481                	li	s1,0
    80001936:	00010a97          	auipc	s5,0x10
    8000193a:	00aa8a93          	addi	s5,s5,10 # 80011940 <ref_lock>
    8000193e:	80000c37          	lui	s8,0x80000
    80001942:	00010b97          	auipc	s7,0x10
    80001946:	16eb8b93          	addi	s7,s7,366 # 80011ab0 <page_ref_count>
    8000194a:	6a05                	lui	s4,0x1
    8000194c:	a839                	j	8000196a <uvmcopy+0x5a>
    8000194e:	4685                	li	a3,1
    80001950:	00c4d613          	srli	a2,s1,0xc
    80001954:	4581                	li	a1,0
    80001956:	855a                	mv	a0,s6
    80001958:	00000097          	auipc	ra,0x0
    8000195c:	cde080e7          	jalr	-802(ra) # 80001636 <uvmunmap>
    80001960:	557d                	li	a0,-1
    80001962:	a0bd                	j	800019d0 <uvmcopy+0xc0>
    80001964:	94d2                	add	s1,s1,s4
    80001966:	0724f463          	bgeu	s1,s2,800019ce <uvmcopy+0xbe>
    8000196a:	4601                	li	a2,0
    8000196c:	85a6                	mv	a1,s1
    8000196e:	854e                	mv	a0,s3
    80001970:	00000097          	auipc	ra,0x0
    80001974:	9f2080e7          	jalr	-1550(ra) # 80001362 <walk>
    80001978:	8caa                	mv	s9,a0
    8000197a:	d56d                	beqz	a0,80001964 <uvmcopy+0x54>
    8000197c:	611c                	ld	a5,0(a0)
    8000197e:	0017f713          	andi	a4,a5,1
    80001982:	d36d                	beqz	a4,80001964 <uvmcopy+0x54>
    80001984:	83a9                	srli	a5,a5,0xa
    80001986:	00c79d13          	slli	s10,a5,0xc
    8000198a:	4605                	li	a2,1
    8000198c:	85a6                	mv	a1,s1
    8000198e:	855a                	mv	a0,s6
    80001990:	00000097          	auipc	ra,0x0
    80001994:	9d2080e7          	jalr	-1582(ra) # 80001362 <walk>
    80001998:	d95d                	beqz	a0,8000194e <uvmcopy+0x3e>
    8000199a:	000cb783          	ld	a5,0(s9)
    8000199e:	9bed                	andi	a5,a5,-5
    800019a0:	1007e793          	ori	a5,a5,256
    800019a4:	00fcb023          	sd	a5,0(s9)
    800019a8:	e11c                	sd	a5,0(a0)
    800019aa:	8556                	mv	a0,s5
    800019ac:	fffff097          	auipc	ra,0xfffff
    800019b0:	5d2080e7          	jalr	1490(ra) # 80000f7e <acquire>
    800019b4:	018d07b3          	add	a5,s10,s8
    800019b8:	83a9                	srli	a5,a5,0xa
    800019ba:	97de                	add	a5,a5,s7
    800019bc:	4398                	lw	a4,0(a5)
    800019be:	2705                	addiw	a4,a4,1
    800019c0:	c398                	sw	a4,0(a5)
    800019c2:	8556                	mv	a0,s5
    800019c4:	fffff097          	auipc	ra,0xfffff
    800019c8:	66e080e7          	jalr	1646(ra) # 80001032 <release>
    800019cc:	bf61                	j	80001964 <uvmcopy+0x54>
    800019ce:	4501                	li	a0,0
    800019d0:	60e6                	ld	ra,88(sp)
    800019d2:	6446                	ld	s0,80(sp)
    800019d4:	64a6                	ld	s1,72(sp)
    800019d6:	6906                	ld	s2,64(sp)
    800019d8:	79e2                	ld	s3,56(sp)
    800019da:	7a42                	ld	s4,48(sp)
    800019dc:	7aa2                	ld	s5,40(sp)
    800019de:	7b02                	ld	s6,32(sp)
    800019e0:	6be2                	ld	s7,24(sp)
    800019e2:	6c42                	ld	s8,16(sp)
    800019e4:	6ca2                	ld	s9,8(sp)
    800019e6:	6d02                	ld	s10,0(sp)
    800019e8:	6125                	addi	sp,sp,96
    800019ea:	8082                	ret
    800019ec:	4501                	li	a0,0
    800019ee:	8082                	ret

00000000800019f0 <uvmclear>:
    800019f0:	1141                	addi	sp,sp,-16
    800019f2:	e406                	sd	ra,8(sp)
    800019f4:	e022                	sd	s0,0(sp)
    800019f6:	0800                	addi	s0,sp,16
    800019f8:	4601                	li	a2,0
    800019fa:	00000097          	auipc	ra,0x0
    800019fe:	968080e7          	jalr	-1688(ra) # 80001362 <walk>
    80001a02:	c901                	beqz	a0,80001a12 <uvmclear+0x22>
    80001a04:	611c                	ld	a5,0(a0)
    80001a06:	9bbd                	andi	a5,a5,-17
    80001a08:	e11c                	sd	a5,0(a0)
    80001a0a:	60a2                	ld	ra,8(sp)
    80001a0c:	6402                	ld	s0,0(sp)
    80001a0e:	0141                	addi	sp,sp,16
    80001a10:	8082                	ret
    80001a12:	00006517          	auipc	a0,0x6
    80001a16:	7f650513          	addi	a0,a0,2038 # 80008208 <digits+0x1a0>
    80001a1a:	fffff097          	auipc	ra,0xfffff
    80001a1e:	bce080e7          	jalr	-1074(ra) # 800005e8 <panic>

0000000080001a22 <copyin>:
    80001a22:	caa5                	beqz	a3,80001a92 <copyin+0x70>
    80001a24:	715d                	addi	sp,sp,-80
    80001a26:	e486                	sd	ra,72(sp)
    80001a28:	e0a2                	sd	s0,64(sp)
    80001a2a:	fc26                	sd	s1,56(sp)
    80001a2c:	f84a                	sd	s2,48(sp)
    80001a2e:	f44e                	sd	s3,40(sp)
    80001a30:	f052                	sd	s4,32(sp)
    80001a32:	ec56                	sd	s5,24(sp)
    80001a34:	e85a                	sd	s6,16(sp)
    80001a36:	e45e                	sd	s7,8(sp)
    80001a38:	e062                	sd	s8,0(sp)
    80001a3a:	0880                	addi	s0,sp,80
    80001a3c:	8b2a                	mv	s6,a0
    80001a3e:	8a2e                	mv	s4,a1
    80001a40:	8c32                	mv	s8,a2
    80001a42:	89b6                	mv	s3,a3
    80001a44:	7bfd                	lui	s7,0xfffff
    80001a46:	6a85                	lui	s5,0x1
    80001a48:	a01d                	j	80001a6e <copyin+0x4c>
    80001a4a:	018505b3          	add	a1,a0,s8
    80001a4e:	0004861b          	sext.w	a2,s1
    80001a52:	412585b3          	sub	a1,a1,s2
    80001a56:	8552                	mv	a0,s4
    80001a58:	fffff097          	auipc	ra,0xfffff
    80001a5c:	67e080e7          	jalr	1662(ra) # 800010d6 <memmove>
    80001a60:	409989b3          	sub	s3,s3,s1
    80001a64:	9a26                	add	s4,s4,s1
    80001a66:	01590c33          	add	s8,s2,s5
    80001a6a:	02098263          	beqz	s3,80001a8e <copyin+0x6c>
    80001a6e:	017c7933          	and	s2,s8,s7
    80001a72:	85ca                	mv	a1,s2
    80001a74:	855a                	mv	a0,s6
    80001a76:	00000097          	auipc	ra,0x0
    80001a7a:	988080e7          	jalr	-1656(ra) # 800013fe <walkaddr>
    80001a7e:	cd01                	beqz	a0,80001a96 <copyin+0x74>
    80001a80:	418904b3          	sub	s1,s2,s8
    80001a84:	94d6                	add	s1,s1,s5
    80001a86:	fc99f2e3          	bgeu	s3,s1,80001a4a <copyin+0x28>
    80001a8a:	84ce                	mv	s1,s3
    80001a8c:	bf7d                	j	80001a4a <copyin+0x28>
    80001a8e:	4501                	li	a0,0
    80001a90:	a021                	j	80001a98 <copyin+0x76>
    80001a92:	4501                	li	a0,0
    80001a94:	8082                	ret
    80001a96:	557d                	li	a0,-1
    80001a98:	60a6                	ld	ra,72(sp)
    80001a9a:	6406                	ld	s0,64(sp)
    80001a9c:	74e2                	ld	s1,56(sp)
    80001a9e:	7942                	ld	s2,48(sp)
    80001aa0:	79a2                	ld	s3,40(sp)
    80001aa2:	7a02                	ld	s4,32(sp)
    80001aa4:	6ae2                	ld	s5,24(sp)
    80001aa6:	6b42                	ld	s6,16(sp)
    80001aa8:	6ba2                	ld	s7,8(sp)
    80001aaa:	6c02                	ld	s8,0(sp)
    80001aac:	6161                	addi	sp,sp,80
    80001aae:	8082                	ret

0000000080001ab0 <copyinstr>:
    80001ab0:	c6c5                	beqz	a3,80001b58 <copyinstr+0xa8>
    80001ab2:	715d                	addi	sp,sp,-80
    80001ab4:	e486                	sd	ra,72(sp)
    80001ab6:	e0a2                	sd	s0,64(sp)
    80001ab8:	fc26                	sd	s1,56(sp)
    80001aba:	f84a                	sd	s2,48(sp)
    80001abc:	f44e                	sd	s3,40(sp)
    80001abe:	f052                	sd	s4,32(sp)
    80001ac0:	ec56                	sd	s5,24(sp)
    80001ac2:	e85a                	sd	s6,16(sp)
    80001ac4:	e45e                	sd	s7,8(sp)
    80001ac6:	0880                	addi	s0,sp,80
    80001ac8:	8a2a                	mv	s4,a0
    80001aca:	8b2e                	mv	s6,a1
    80001acc:	8bb2                	mv	s7,a2
    80001ace:	84b6                	mv	s1,a3
    80001ad0:	7afd                	lui	s5,0xfffff
    80001ad2:	6985                	lui	s3,0x1
    80001ad4:	a035                	j	80001b00 <copyinstr+0x50>
    80001ad6:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001ada:	4785                	li	a5,1
    80001adc:	0017b793          	seqz	a5,a5
    80001ae0:	40f00533          	neg	a0,a5
    80001ae4:	60a6                	ld	ra,72(sp)
    80001ae6:	6406                	ld	s0,64(sp)
    80001ae8:	74e2                	ld	s1,56(sp)
    80001aea:	7942                	ld	s2,48(sp)
    80001aec:	79a2                	ld	s3,40(sp)
    80001aee:	7a02                	ld	s4,32(sp)
    80001af0:	6ae2                	ld	s5,24(sp)
    80001af2:	6b42                	ld	s6,16(sp)
    80001af4:	6ba2                	ld	s7,8(sp)
    80001af6:	6161                	addi	sp,sp,80
    80001af8:	8082                	ret
    80001afa:	01390bb3          	add	s7,s2,s3
    80001afe:	c8a9                	beqz	s1,80001b50 <copyinstr+0xa0>
    80001b00:	015bf933          	and	s2,s7,s5
    80001b04:	85ca                	mv	a1,s2
    80001b06:	8552                	mv	a0,s4
    80001b08:	00000097          	auipc	ra,0x0
    80001b0c:	8f6080e7          	jalr	-1802(ra) # 800013fe <walkaddr>
    80001b10:	c131                	beqz	a0,80001b54 <copyinstr+0xa4>
    80001b12:	41790833          	sub	a6,s2,s7
    80001b16:	984e                	add	a6,a6,s3
    80001b18:	0104f363          	bgeu	s1,a6,80001b1e <copyinstr+0x6e>
    80001b1c:	8826                	mv	a6,s1
    80001b1e:	955e                	add	a0,a0,s7
    80001b20:	41250533          	sub	a0,a0,s2
    80001b24:	fc080be3          	beqz	a6,80001afa <copyinstr+0x4a>
    80001b28:	985a                	add	a6,a6,s6
    80001b2a:	87da                	mv	a5,s6
    80001b2c:	41650633          	sub	a2,a0,s6
    80001b30:	14fd                	addi	s1,s1,-1
    80001b32:	9b26                	add	s6,s6,s1
    80001b34:	00f60733          	add	a4,a2,a5
    80001b38:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffb9000>
    80001b3c:	df49                	beqz	a4,80001ad6 <copyinstr+0x26>
    80001b3e:	00e78023          	sb	a4,0(a5)
    80001b42:	40fb04b3          	sub	s1,s6,a5
    80001b46:	0785                	addi	a5,a5,1
    80001b48:	ff0796e3          	bne	a5,a6,80001b34 <copyinstr+0x84>
    80001b4c:	8b42                	mv	s6,a6
    80001b4e:	b775                	j	80001afa <copyinstr+0x4a>
    80001b50:	4781                	li	a5,0
    80001b52:	b769                	j	80001adc <copyinstr+0x2c>
    80001b54:	557d                	li	a0,-1
    80001b56:	b779                	j	80001ae4 <copyinstr+0x34>
    80001b58:	4781                	li	a5,0
    80001b5a:	0017b793          	seqz	a5,a5
    80001b5e:	40f00533          	neg	a0,a5
    80001b62:	8082                	ret

0000000080001b64 <do_cow>:
    80001b64:	7179                	addi	sp,sp,-48
    80001b66:	f406                	sd	ra,40(sp)
    80001b68:	f022                	sd	s0,32(sp)
    80001b6a:	ec26                	sd	s1,24(sp)
    80001b6c:	e84a                	sd	s2,16(sp)
    80001b6e:	e44e                	sd	s3,8(sp)
    80001b70:	e052                	sd	s4,0(sp)
    80001b72:	1800                	addi	s0,sp,48
    80001b74:	4601                	li	a2,0
    80001b76:	77fd                	lui	a5,0xfffff
    80001b78:	8dfd                	and	a1,a1,a5
    80001b7a:	fffff097          	auipc	ra,0xfffff
    80001b7e:	7e8080e7          	jalr	2024(ra) # 80001362 <walk>
    80001b82:	cd59                	beqz	a0,80001c20 <do_cow+0xbc>
    80001b84:	89aa                	mv	s3,a0
    80001b86:	611c                	ld	a5,0(a0)
    80001b88:	0017f713          	andi	a4,a5,1
    80001b8c:	c355                	beqz	a4,80001c30 <do_cow+0xcc>
    80001b8e:	00a7da13          	srli	s4,a5,0xa
    80001b92:	0a32                	slli	s4,s4,0xc
    80001b94:	2ff7f793          	andi	a5,a5,767
    80001b98:	0047e913          	ori	s2,a5,4
    80001b9c:	00010517          	auipc	a0,0x10
    80001ba0:	da450513          	addi	a0,a0,-604 # 80011940 <ref_lock>
    80001ba4:	fffff097          	auipc	ra,0xfffff
    80001ba8:	3da080e7          	jalr	986(ra) # 80000f7e <acquire>
    80001bac:	800007b7          	lui	a5,0x80000
    80001bb0:	97d2                	add	a5,a5,s4
    80001bb2:	00c7d693          	srli	a3,a5,0xc
    80001bb6:	83a9                	srli	a5,a5,0xa
    80001bb8:	00010717          	auipc	a4,0x10
    80001bbc:	ef870713          	addi	a4,a4,-264 # 80011ab0 <page_ref_count>
    80001bc0:	97ba                	add	a5,a5,a4
    80001bc2:	439c                	lw	a5,0(a5)
    80001bc4:	4705                	li	a4,1
    80001bc6:	06e78d63          	beq	a5,a4,80001c40 <do_cow+0xdc>
    80001bca:	068a                	slli	a3,a3,0x2
    80001bcc:	00010717          	auipc	a4,0x10
    80001bd0:	ee470713          	addi	a4,a4,-284 # 80011ab0 <page_ref_count>
    80001bd4:	96ba                	add	a3,a3,a4
    80001bd6:	37fd                	addiw	a5,a5,-1
    80001bd8:	c29c                	sw	a5,0(a3)
    80001bda:	00010517          	auipc	a0,0x10
    80001bde:	d6650513          	addi	a0,a0,-666 # 80011940 <ref_lock>
    80001be2:	fffff097          	auipc	ra,0xfffff
    80001be6:	450080e7          	jalr	1104(ra) # 80001032 <release>
    80001bea:	fffff097          	auipc	ra,0xfffff
    80001bee:	182080e7          	jalr	386(ra) # 80000d6c <kalloc>
    80001bf2:	84aa                	mv	s1,a0
    80001bf4:	c925                	beqz	a0,80001c64 <do_cow+0x100>
    80001bf6:	6605                	lui	a2,0x1
    80001bf8:	85d2                	mv	a1,s4
    80001bfa:	fffff097          	auipc	ra,0xfffff
    80001bfe:	4dc080e7          	jalr	1244(ra) # 800010d6 <memmove>
    80001c02:	80b1                	srli	s1,s1,0xc
    80001c04:	04aa                	slli	s1,s1,0xa
    80001c06:	009967b3          	or	a5,s2,s1
    80001c0a:	00f9b023          	sd	a5,0(s3) # 1000 <_entry-0x7ffff000>
    80001c0e:	4501                	li	a0,0
    80001c10:	70a2                	ld	ra,40(sp)
    80001c12:	7402                	ld	s0,32(sp)
    80001c14:	64e2                	ld	s1,24(sp)
    80001c16:	6942                	ld	s2,16(sp)
    80001c18:	69a2                	ld	s3,8(sp)
    80001c1a:	6a02                	ld	s4,0(sp)
    80001c1c:	6145                	addi	sp,sp,48
    80001c1e:	8082                	ret
    80001c20:	00006517          	auipc	a0,0x6
    80001c24:	5f850513          	addi	a0,a0,1528 # 80008218 <digits+0x1b0>
    80001c28:	fffff097          	auipc	ra,0xfffff
    80001c2c:	9c0080e7          	jalr	-1600(ra) # 800005e8 <panic>
    80001c30:	00006517          	auipc	a0,0x6
    80001c34:	60850513          	addi	a0,a0,1544 # 80008238 <digits+0x1d0>
    80001c38:	fffff097          	auipc	ra,0xfffff
    80001c3c:	9b0080e7          	jalr	-1616(ra) # 800005e8 <panic>
    80001c40:	0009b783          	ld	a5,0(s3)
    80001c44:	eff7f793          	andi	a5,a5,-257
    80001c48:	0047e793          	ori	a5,a5,4
    80001c4c:	00f9b023          	sd	a5,0(s3)
    80001c50:	00010517          	auipc	a0,0x10
    80001c54:	cf050513          	addi	a0,a0,-784 # 80011940 <ref_lock>
    80001c58:	fffff097          	auipc	ra,0xfffff
    80001c5c:	3da080e7          	jalr	986(ra) # 80001032 <release>
    80001c60:	4501                	li	a0,0
    80001c62:	b77d                	j	80001c10 <do_cow+0xac>
    80001c64:	557d                	li	a0,-1
    80001c66:	b76d                	j	80001c10 <do_cow+0xac>

0000000080001c68 <do_lazy_allocation>:
    80001c68:	7179                	addi	sp,sp,-48
    80001c6a:	f406                	sd	ra,40(sp)
    80001c6c:	f022                	sd	s0,32(sp)
    80001c6e:	ec26                	sd	s1,24(sp)
    80001c70:	e84a                	sd	s2,16(sp)
    80001c72:	e44e                	sd	s3,8(sp)
    80001c74:	1800                	addi	s0,sp,48
    80001c76:	892a                	mv	s2,a0
    80001c78:	79fd                	lui	s3,0xfffff
    80001c7a:	0135f9b3          	and	s3,a1,s3
    80001c7e:	fffff097          	auipc	ra,0xfffff
    80001c82:	0ee080e7          	jalr	238(ra) # 80000d6c <kalloc>
    80001c86:	c121                	beqz	a0,80001cc6 <do_lazy_allocation+0x5e>
    80001c88:	84aa                	mv	s1,a0
    80001c8a:	6605                	lui	a2,0x1
    80001c8c:	4581                	li	a1,0
    80001c8e:	fffff097          	auipc	ra,0xfffff
    80001c92:	3ec080e7          	jalr	1004(ra) # 8000107a <memset>
    80001c96:	4779                	li	a4,30
    80001c98:	86a6                	mv	a3,s1
    80001c9a:	6605                	lui	a2,0x1
    80001c9c:	85ce                	mv	a1,s3
    80001c9e:	854a                	mv	a0,s2
    80001ca0:	fffff097          	auipc	ra,0xfffff
    80001ca4:	7fe080e7          	jalr	2046(ra) # 8000149e <mappages>
    80001ca8:	e901                	bnez	a0,80001cb8 <do_lazy_allocation+0x50>
    80001caa:	70a2                	ld	ra,40(sp)
    80001cac:	7402                	ld	s0,32(sp)
    80001cae:	64e2                	ld	s1,24(sp)
    80001cb0:	6942                	ld	s2,16(sp)
    80001cb2:	69a2                	ld	s3,8(sp)
    80001cb4:	6145                	addi	sp,sp,48
    80001cb6:	8082                	ret
    80001cb8:	8526                	mv	a0,s1
    80001cba:	fffff097          	auipc	ra,0xfffff
    80001cbe:	dd4080e7          	jalr	-556(ra) # 80000a8e <kfree>
    80001cc2:	5579                	li	a0,-2
    80001cc4:	b7dd                	j	80001caa <do_lazy_allocation+0x42>
    80001cc6:	557d                	li	a0,-1
    80001cc8:	b7cd                	j	80001caa <do_lazy_allocation+0x42>

0000000080001cca <copyout>:
    80001cca:	c695                	beqz	a3,80001cf6 <copyout+0x2c>
    80001ccc:	715d                	addi	sp,sp,-80
    80001cce:	e486                	sd	ra,72(sp)
    80001cd0:	e0a2                	sd	s0,64(sp)
    80001cd2:	fc26                	sd	s1,56(sp)
    80001cd4:	f84a                	sd	s2,48(sp)
    80001cd6:	f44e                	sd	s3,40(sp)
    80001cd8:	f052                	sd	s4,32(sp)
    80001cda:	ec56                	sd	s5,24(sp)
    80001cdc:	e85a                	sd	s6,16(sp)
    80001cde:	e45e                	sd	s7,8(sp)
    80001ce0:	e062                	sd	s8,0(sp)
    80001ce2:	0880                	addi	s0,sp,80
    80001ce4:	8b2a                	mv	s6,a0
    80001ce6:	89ae                	mv	s3,a1
    80001ce8:	8ab2                	mv	s5,a2
    80001cea:	8a36                	mv	s4,a3
    80001cec:	7c7d                	lui	s8,0xfffff
    80001cee:	6b85                	lui	s7,0x1
    80001cf0:	a061                	j	80001d78 <copyout+0xae>
    80001cf2:	4501                	li	a0,0
    80001cf4:	a031                	j	80001d00 <copyout+0x36>
    80001cf6:	4501                	li	a0,0
    80001cf8:	8082                	ret
    80001cfa:	557d                	li	a0,-1
    80001cfc:	a011                	j	80001d00 <copyout+0x36>
    80001cfe:	557d                	li	a0,-1
    80001d00:	60a6                	ld	ra,72(sp)
    80001d02:	6406                	ld	s0,64(sp)
    80001d04:	74e2                	ld	s1,56(sp)
    80001d06:	7942                	ld	s2,48(sp)
    80001d08:	79a2                	ld	s3,40(sp)
    80001d0a:	7a02                	ld	s4,32(sp)
    80001d0c:	6ae2                	ld	s5,24(sp)
    80001d0e:	6b42                	ld	s6,16(sp)
    80001d10:	6ba2                	ld	s7,8(sp)
    80001d12:	6c02                	ld	s8,0(sp)
    80001d14:	6161                	addi	sp,sp,80
    80001d16:	8082                	ret
    80001d18:	00000097          	auipc	ra,0x0
    80001d1c:	1e6080e7          	jalr	486(ra) # 80001efe <myproc>
    80001d20:	653c                	ld	a5,72(a0)
    80001d22:	06f97963          	bgeu	s2,a5,80001d94 <copyout+0xca>
    80001d26:	00000097          	auipc	ra,0x0
    80001d2a:	1d8080e7          	jalr	472(ra) # 80001efe <myproc>
    80001d2e:	85ca                	mv	a1,s2
    80001d30:	6928                	ld	a0,80(a0)
    80001d32:	00000097          	auipc	ra,0x0
    80001d36:	f36080e7          	jalr	-202(ra) # 80001c68 <do_lazy_allocation>
    80001d3a:	f161                	bnez	a0,80001cfa <copyout+0x30>
    80001d3c:	85ca                	mv	a1,s2
    80001d3e:	855a                	mv	a0,s6
    80001d40:	fffff097          	auipc	ra,0xfffff
    80001d44:	6be080e7          	jalr	1726(ra) # 800013fe <walkaddr>
    80001d48:	d95d                	beqz	a0,80001cfe <copyout+0x34>
    80001d4a:	413904b3          	sub	s1,s2,s3
    80001d4e:	94de                	add	s1,s1,s7
    80001d50:	009a7363          	bgeu	s4,s1,80001d56 <copyout+0x8c>
    80001d54:	84d2                	mv	s1,s4
    80001d56:	412989b3          	sub	s3,s3,s2
    80001d5a:	0004861b          	sext.w	a2,s1
    80001d5e:	85d6                	mv	a1,s5
    80001d60:	954e                	add	a0,a0,s3
    80001d62:	fffff097          	auipc	ra,0xfffff
    80001d66:	374080e7          	jalr	884(ra) # 800010d6 <memmove>
    80001d6a:	409a0a33          	sub	s4,s4,s1
    80001d6e:	9aa6                	add	s5,s5,s1
    80001d70:	017909b3          	add	s3,s2,s7
    80001d74:	f60a0fe3          	beqz	s4,80001cf2 <copyout+0x28>
    80001d78:	0189f933          	and	s2,s3,s8
    80001d7c:	4601                	li	a2,0
    80001d7e:	85ca                	mv	a1,s2
    80001d80:	855a                	mv	a0,s6
    80001d82:	fffff097          	auipc	ra,0xfffff
    80001d86:	5e0080e7          	jalr	1504(ra) # 80001362 <walk>
    80001d8a:	84aa                	mv	s1,a0
    80001d8c:	c10d                	beqz	a0,80001dae <copyout+0xe4>
    80001d8e:	611c                	ld	a5,0(a0)
    80001d90:	8b85                	andi	a5,a5,1
    80001d92:	d3d9                	beqz	a5,80001d18 <copyout+0x4e>
    80001d94:	609c                	ld	a5,0(s1)
    80001d96:	1007f793          	andi	a5,a5,256
    80001d9a:	d3cd                	beqz	a5,80001d3c <copyout+0x72>
    80001d9c:	85ca                	mv	a1,s2
    80001d9e:	855a                	mv	a0,s6
    80001da0:	00000097          	auipc	ra,0x0
    80001da4:	dc4080e7          	jalr	-572(ra) # 80001b64 <do_cow>
    80001da8:	d951                	beqz	a0,80001d3c <copyout+0x72>
    80001daa:	5579                	li	a0,-2
    80001dac:	bf91                	j	80001d00 <copyout+0x36>
    80001dae:	00000097          	auipc	ra,0x0
    80001db2:	150080e7          	jalr	336(ra) # 80001efe <myproc>
    80001db6:	653c                	ld	a5,72(a0)
    80001db8:	f8f972e3          	bgeu	s2,a5,80001d3c <copyout+0x72>
    80001dbc:	b7ad                	j	80001d26 <copyout+0x5c>

0000000080001dbe <wakeup1>:
    80001dbe:	1101                	addi	sp,sp,-32
    80001dc0:	ec06                	sd	ra,24(sp)
    80001dc2:	e822                	sd	s0,16(sp)
    80001dc4:	e426                	sd	s1,8(sp)
    80001dc6:	1000                	addi	s0,sp,32
    80001dc8:	84aa                	mv	s1,a0
    80001dca:	fffff097          	auipc	ra,0xfffff
    80001dce:	13a080e7          	jalr	314(ra) # 80000f04 <holding>
    80001dd2:	c909                	beqz	a0,80001de4 <wakeup1+0x26>
    80001dd4:	749c                	ld	a5,40(s1)
    80001dd6:	00978f63          	beq	a5,s1,80001df4 <wakeup1+0x36>
    80001dda:	60e2                	ld	ra,24(sp)
    80001ddc:	6442                	ld	s0,16(sp)
    80001dde:	64a2                	ld	s1,8(sp)
    80001de0:	6105                	addi	sp,sp,32
    80001de2:	8082                	ret
    80001de4:	00006517          	auipc	a0,0x6
    80001de8:	47450513          	addi	a0,a0,1140 # 80008258 <digits+0x1f0>
    80001dec:	ffffe097          	auipc	ra,0xffffe
    80001df0:	7fc080e7          	jalr	2044(ra) # 800005e8 <panic>
    80001df4:	4c98                	lw	a4,24(s1)
    80001df6:	4785                	li	a5,1
    80001df8:	fef711e3          	bne	a4,a5,80001dda <wakeup1+0x1c>
    80001dfc:	4789                	li	a5,2
    80001dfe:	cc9c                	sw	a5,24(s1)
    80001e00:	bfe9                	j	80001dda <wakeup1+0x1c>

0000000080001e02 <procinit>:
    80001e02:	715d                	addi	sp,sp,-80
    80001e04:	e486                	sd	ra,72(sp)
    80001e06:	e0a2                	sd	s0,64(sp)
    80001e08:	fc26                	sd	s1,56(sp)
    80001e0a:	f84a                	sd	s2,48(sp)
    80001e0c:	f44e                	sd	s3,40(sp)
    80001e0e:	f052                	sd	s4,32(sp)
    80001e10:	ec56                	sd	s5,24(sp)
    80001e12:	e85a                	sd	s6,16(sp)
    80001e14:	e45e                	sd	s7,8(sp)
    80001e16:	0880                	addi	s0,sp,80
    80001e18:	00006597          	auipc	a1,0x6
    80001e1c:	44858593          	addi	a1,a1,1096 # 80008260 <digits+0x1f8>
    80001e20:	00030517          	auipc	a0,0x30
    80001e24:	c9050513          	addi	a0,a0,-880 # 80031ab0 <pid_lock>
    80001e28:	fffff097          	auipc	ra,0xfffff
    80001e2c:	0c6080e7          	jalr	198(ra) # 80000eee <initlock>
    80001e30:	00030917          	auipc	s2,0x30
    80001e34:	09890913          	addi	s2,s2,152 # 80031ec8 <proc>
    80001e38:	00006b97          	auipc	s7,0x6
    80001e3c:	430b8b93          	addi	s7,s7,1072 # 80008268 <digits+0x200>
    80001e40:	8b4a                	mv	s6,s2
    80001e42:	00006a97          	auipc	s5,0x6
    80001e46:	1bea8a93          	addi	s5,s5,446 # 80008000 <etext>
    80001e4a:	040009b7          	lui	s3,0x4000
    80001e4e:	19fd                	addi	s3,s3,-1
    80001e50:	09b2                	slli	s3,s3,0xc
    80001e52:	00036a17          	auipc	s4,0x36
    80001e56:	a76a0a13          	addi	s4,s4,-1418 # 800378c8 <tickslock>
    80001e5a:	85de                	mv	a1,s7
    80001e5c:	854a                	mv	a0,s2
    80001e5e:	fffff097          	auipc	ra,0xfffff
    80001e62:	090080e7          	jalr	144(ra) # 80000eee <initlock>
    80001e66:	fffff097          	auipc	ra,0xfffff
    80001e6a:	f06080e7          	jalr	-250(ra) # 80000d6c <kalloc>
    80001e6e:	85aa                	mv	a1,a0
    80001e70:	c929                	beqz	a0,80001ec2 <procinit+0xc0>
    80001e72:	416904b3          	sub	s1,s2,s6
    80001e76:	848d                	srai	s1,s1,0x3
    80001e78:	000ab783          	ld	a5,0(s5)
    80001e7c:	02f484b3          	mul	s1,s1,a5
    80001e80:	2485                	addiw	s1,s1,1
    80001e82:	00d4949b          	slliw	s1,s1,0xd
    80001e86:	409984b3          	sub	s1,s3,s1
    80001e8a:	4699                	li	a3,6
    80001e8c:	6605                	lui	a2,0x1
    80001e8e:	8526                	mv	a0,s1
    80001e90:	fffff097          	auipc	ra,0xfffff
    80001e94:	69c080e7          	jalr	1692(ra) # 8000152c <kvmmap>
    80001e98:	04993023          	sd	s1,64(s2)
    80001e9c:	16890913          	addi	s2,s2,360
    80001ea0:	fb491de3          	bne	s2,s4,80001e5a <procinit+0x58>
    80001ea4:	fffff097          	auipc	ra,0xfffff
    80001ea8:	49a080e7          	jalr	1178(ra) # 8000133e <kvminithart>
    80001eac:	60a6                	ld	ra,72(sp)
    80001eae:	6406                	ld	s0,64(sp)
    80001eb0:	74e2                	ld	s1,56(sp)
    80001eb2:	7942                	ld	s2,48(sp)
    80001eb4:	79a2                	ld	s3,40(sp)
    80001eb6:	7a02                	ld	s4,32(sp)
    80001eb8:	6ae2                	ld	s5,24(sp)
    80001eba:	6b42                	ld	s6,16(sp)
    80001ebc:	6ba2                	ld	s7,8(sp)
    80001ebe:	6161                	addi	sp,sp,80
    80001ec0:	8082                	ret
    80001ec2:	00006517          	auipc	a0,0x6
    80001ec6:	3ae50513          	addi	a0,a0,942 # 80008270 <digits+0x208>
    80001eca:	ffffe097          	auipc	ra,0xffffe
    80001ece:	71e080e7          	jalr	1822(ra) # 800005e8 <panic>

0000000080001ed2 <cpuid>:
    80001ed2:	1141                	addi	sp,sp,-16
    80001ed4:	e422                	sd	s0,8(sp)
    80001ed6:	0800                	addi	s0,sp,16
    80001ed8:	8512                	mv	a0,tp
    80001eda:	2501                	sext.w	a0,a0
    80001edc:	6422                	ld	s0,8(sp)
    80001ede:	0141                	addi	sp,sp,16
    80001ee0:	8082                	ret

0000000080001ee2 <mycpu>:
    80001ee2:	1141                	addi	sp,sp,-16
    80001ee4:	e422                	sd	s0,8(sp)
    80001ee6:	0800                	addi	s0,sp,16
    80001ee8:	8792                	mv	a5,tp
    80001eea:	2781                	sext.w	a5,a5
    80001eec:	079e                	slli	a5,a5,0x7
    80001eee:	00030517          	auipc	a0,0x30
    80001ef2:	bda50513          	addi	a0,a0,-1062 # 80031ac8 <cpus>
    80001ef6:	953e                	add	a0,a0,a5
    80001ef8:	6422                	ld	s0,8(sp)
    80001efa:	0141                	addi	sp,sp,16
    80001efc:	8082                	ret

0000000080001efe <myproc>:
    80001efe:	1101                	addi	sp,sp,-32
    80001f00:	ec06                	sd	ra,24(sp)
    80001f02:	e822                	sd	s0,16(sp)
    80001f04:	e426                	sd	s1,8(sp)
    80001f06:	1000                	addi	s0,sp,32
    80001f08:	fffff097          	auipc	ra,0xfffff
    80001f0c:	02a080e7          	jalr	42(ra) # 80000f32 <push_off>
    80001f10:	8792                	mv	a5,tp
    80001f12:	2781                	sext.w	a5,a5
    80001f14:	079e                	slli	a5,a5,0x7
    80001f16:	00030717          	auipc	a4,0x30
    80001f1a:	b9a70713          	addi	a4,a4,-1126 # 80031ab0 <pid_lock>
    80001f1e:	97ba                	add	a5,a5,a4
    80001f20:	6f84                	ld	s1,24(a5)
    80001f22:	fffff097          	auipc	ra,0xfffff
    80001f26:	0b0080e7          	jalr	176(ra) # 80000fd2 <pop_off>
    80001f2a:	8526                	mv	a0,s1
    80001f2c:	60e2                	ld	ra,24(sp)
    80001f2e:	6442                	ld	s0,16(sp)
    80001f30:	64a2                	ld	s1,8(sp)
    80001f32:	6105                	addi	sp,sp,32
    80001f34:	8082                	ret

0000000080001f36 <forkret>:
    80001f36:	1141                	addi	sp,sp,-16
    80001f38:	e406                	sd	ra,8(sp)
    80001f3a:	e022                	sd	s0,0(sp)
    80001f3c:	0800                	addi	s0,sp,16
    80001f3e:	00000097          	auipc	ra,0x0
    80001f42:	fc0080e7          	jalr	-64(ra) # 80001efe <myproc>
    80001f46:	fffff097          	auipc	ra,0xfffff
    80001f4a:	0ec080e7          	jalr	236(ra) # 80001032 <release>
    80001f4e:	00007797          	auipc	a5,0x7
    80001f52:	9c27a783          	lw	a5,-1598(a5) # 80008910 <first.1>
    80001f56:	eb89                	bnez	a5,80001f68 <forkret+0x32>
    80001f58:	00001097          	auipc	ra,0x1
    80001f5c:	c18080e7          	jalr	-1000(ra) # 80002b70 <usertrapret>
    80001f60:	60a2                	ld	ra,8(sp)
    80001f62:	6402                	ld	s0,0(sp)
    80001f64:	0141                	addi	sp,sp,16
    80001f66:	8082                	ret
    80001f68:	00007797          	auipc	a5,0x7
    80001f6c:	9a07a423          	sw	zero,-1624(a5) # 80008910 <first.1>
    80001f70:	4505                	li	a0,1
    80001f72:	00002097          	auipc	ra,0x2
    80001f76:	a3a080e7          	jalr	-1478(ra) # 800039ac <fsinit>
    80001f7a:	bff9                	j	80001f58 <forkret+0x22>

0000000080001f7c <allocpid>:
    80001f7c:	1101                	addi	sp,sp,-32
    80001f7e:	ec06                	sd	ra,24(sp)
    80001f80:	e822                	sd	s0,16(sp)
    80001f82:	e426                	sd	s1,8(sp)
    80001f84:	e04a                	sd	s2,0(sp)
    80001f86:	1000                	addi	s0,sp,32
    80001f88:	00030917          	auipc	s2,0x30
    80001f8c:	b2890913          	addi	s2,s2,-1240 # 80031ab0 <pid_lock>
    80001f90:	854a                	mv	a0,s2
    80001f92:	fffff097          	auipc	ra,0xfffff
    80001f96:	fec080e7          	jalr	-20(ra) # 80000f7e <acquire>
    80001f9a:	00007797          	auipc	a5,0x7
    80001f9e:	97a78793          	addi	a5,a5,-1670 # 80008914 <nextpid>
    80001fa2:	4384                	lw	s1,0(a5)
    80001fa4:	0014871b          	addiw	a4,s1,1
    80001fa8:	c398                	sw	a4,0(a5)
    80001faa:	854a                	mv	a0,s2
    80001fac:	fffff097          	auipc	ra,0xfffff
    80001fb0:	086080e7          	jalr	134(ra) # 80001032 <release>
    80001fb4:	8526                	mv	a0,s1
    80001fb6:	60e2                	ld	ra,24(sp)
    80001fb8:	6442                	ld	s0,16(sp)
    80001fba:	64a2                	ld	s1,8(sp)
    80001fbc:	6902                	ld	s2,0(sp)
    80001fbe:	6105                	addi	sp,sp,32
    80001fc0:	8082                	ret

0000000080001fc2 <proc_pagetable>:
    80001fc2:	1101                	addi	sp,sp,-32
    80001fc4:	ec06                	sd	ra,24(sp)
    80001fc6:	e822                	sd	s0,16(sp)
    80001fc8:	e426                	sd	s1,8(sp)
    80001fca:	e04a                	sd	s2,0(sp)
    80001fcc:	1000                	addi	s0,sp,32
    80001fce:	892a                	mv	s2,a0
    80001fd0:	fffff097          	auipc	ra,0xfffff
    80001fd4:	70c080e7          	jalr	1804(ra) # 800016dc <uvmcreate>
    80001fd8:	84aa                	mv	s1,a0
    80001fda:	c121                	beqz	a0,8000201a <proc_pagetable+0x58>
    80001fdc:	4729                	li	a4,10
    80001fde:	00005697          	auipc	a3,0x5
    80001fe2:	02268693          	addi	a3,a3,34 # 80007000 <_trampoline>
    80001fe6:	6605                	lui	a2,0x1
    80001fe8:	040005b7          	lui	a1,0x4000
    80001fec:	15fd                	addi	a1,a1,-1
    80001fee:	05b2                	slli	a1,a1,0xc
    80001ff0:	fffff097          	auipc	ra,0xfffff
    80001ff4:	4ae080e7          	jalr	1198(ra) # 8000149e <mappages>
    80001ff8:	02054863          	bltz	a0,80002028 <proc_pagetable+0x66>
    80001ffc:	4719                	li	a4,6
    80001ffe:	05893683          	ld	a3,88(s2)
    80002002:	6605                	lui	a2,0x1
    80002004:	020005b7          	lui	a1,0x2000
    80002008:	15fd                	addi	a1,a1,-1
    8000200a:	05b6                	slli	a1,a1,0xd
    8000200c:	8526                	mv	a0,s1
    8000200e:	fffff097          	auipc	ra,0xfffff
    80002012:	490080e7          	jalr	1168(ra) # 8000149e <mappages>
    80002016:	02054163          	bltz	a0,80002038 <proc_pagetable+0x76>
    8000201a:	8526                	mv	a0,s1
    8000201c:	60e2                	ld	ra,24(sp)
    8000201e:	6442                	ld	s0,16(sp)
    80002020:	64a2                	ld	s1,8(sp)
    80002022:	6902                	ld	s2,0(sp)
    80002024:	6105                	addi	sp,sp,32
    80002026:	8082                	ret
    80002028:	4581                	li	a1,0
    8000202a:	8526                	mv	a0,s1
    8000202c:	00000097          	auipc	ra,0x0
    80002030:	8ac080e7          	jalr	-1876(ra) # 800018d8 <uvmfree>
    80002034:	4481                	li	s1,0
    80002036:	b7d5                	j	8000201a <proc_pagetable+0x58>
    80002038:	4681                	li	a3,0
    8000203a:	4605                	li	a2,1
    8000203c:	040005b7          	lui	a1,0x4000
    80002040:	15fd                	addi	a1,a1,-1
    80002042:	05b2                	slli	a1,a1,0xc
    80002044:	8526                	mv	a0,s1
    80002046:	fffff097          	auipc	ra,0xfffff
    8000204a:	5f0080e7          	jalr	1520(ra) # 80001636 <uvmunmap>
    8000204e:	4581                	li	a1,0
    80002050:	8526                	mv	a0,s1
    80002052:	00000097          	auipc	ra,0x0
    80002056:	886080e7          	jalr	-1914(ra) # 800018d8 <uvmfree>
    8000205a:	4481                	li	s1,0
    8000205c:	bf7d                	j	8000201a <proc_pagetable+0x58>

000000008000205e <proc_freepagetable>:
    8000205e:	1101                	addi	sp,sp,-32
    80002060:	ec06                	sd	ra,24(sp)
    80002062:	e822                	sd	s0,16(sp)
    80002064:	e426                	sd	s1,8(sp)
    80002066:	e04a                	sd	s2,0(sp)
    80002068:	1000                	addi	s0,sp,32
    8000206a:	84aa                	mv	s1,a0
    8000206c:	892e                	mv	s2,a1
    8000206e:	4681                	li	a3,0
    80002070:	4605                	li	a2,1
    80002072:	040005b7          	lui	a1,0x4000
    80002076:	15fd                	addi	a1,a1,-1
    80002078:	05b2                	slli	a1,a1,0xc
    8000207a:	fffff097          	auipc	ra,0xfffff
    8000207e:	5bc080e7          	jalr	1468(ra) # 80001636 <uvmunmap>
    80002082:	4681                	li	a3,0
    80002084:	4605                	li	a2,1
    80002086:	020005b7          	lui	a1,0x2000
    8000208a:	15fd                	addi	a1,a1,-1
    8000208c:	05b6                	slli	a1,a1,0xd
    8000208e:	8526                	mv	a0,s1
    80002090:	fffff097          	auipc	ra,0xfffff
    80002094:	5a6080e7          	jalr	1446(ra) # 80001636 <uvmunmap>
    80002098:	85ca                	mv	a1,s2
    8000209a:	8526                	mv	a0,s1
    8000209c:	00000097          	auipc	ra,0x0
    800020a0:	83c080e7          	jalr	-1988(ra) # 800018d8 <uvmfree>
    800020a4:	60e2                	ld	ra,24(sp)
    800020a6:	6442                	ld	s0,16(sp)
    800020a8:	64a2                	ld	s1,8(sp)
    800020aa:	6902                	ld	s2,0(sp)
    800020ac:	6105                	addi	sp,sp,32
    800020ae:	8082                	ret

00000000800020b0 <freeproc>:
    800020b0:	1101                	addi	sp,sp,-32
    800020b2:	ec06                	sd	ra,24(sp)
    800020b4:	e822                	sd	s0,16(sp)
    800020b6:	e426                	sd	s1,8(sp)
    800020b8:	1000                	addi	s0,sp,32
    800020ba:	84aa                	mv	s1,a0
    800020bc:	6d28                	ld	a0,88(a0)
    800020be:	c509                	beqz	a0,800020c8 <freeproc+0x18>
    800020c0:	fffff097          	auipc	ra,0xfffff
    800020c4:	9ce080e7          	jalr	-1586(ra) # 80000a8e <kfree>
    800020c8:	0404bc23          	sd	zero,88(s1)
    800020cc:	68a8                	ld	a0,80(s1)
    800020ce:	c511                	beqz	a0,800020da <freeproc+0x2a>
    800020d0:	64ac                	ld	a1,72(s1)
    800020d2:	00000097          	auipc	ra,0x0
    800020d6:	f8c080e7          	jalr	-116(ra) # 8000205e <proc_freepagetable>
    800020da:	0404b823          	sd	zero,80(s1)
    800020de:	0404b423          	sd	zero,72(s1)
    800020e2:	0204ac23          	sw	zero,56(s1)
    800020e6:	0204b023          	sd	zero,32(s1)
    800020ea:	14048c23          	sb	zero,344(s1)
    800020ee:	0204b423          	sd	zero,40(s1)
    800020f2:	0204a823          	sw	zero,48(s1)
    800020f6:	0204aa23          	sw	zero,52(s1)
    800020fa:	0004ac23          	sw	zero,24(s1)
    800020fe:	60e2                	ld	ra,24(sp)
    80002100:	6442                	ld	s0,16(sp)
    80002102:	64a2                	ld	s1,8(sp)
    80002104:	6105                	addi	sp,sp,32
    80002106:	8082                	ret

0000000080002108 <allocproc>:
    80002108:	1101                	addi	sp,sp,-32
    8000210a:	ec06                	sd	ra,24(sp)
    8000210c:	e822                	sd	s0,16(sp)
    8000210e:	e426                	sd	s1,8(sp)
    80002110:	e04a                	sd	s2,0(sp)
    80002112:	1000                	addi	s0,sp,32
    80002114:	00030497          	auipc	s1,0x30
    80002118:	db448493          	addi	s1,s1,-588 # 80031ec8 <proc>
    8000211c:	00035917          	auipc	s2,0x35
    80002120:	7ac90913          	addi	s2,s2,1964 # 800378c8 <tickslock>
    80002124:	8526                	mv	a0,s1
    80002126:	fffff097          	auipc	ra,0xfffff
    8000212a:	e58080e7          	jalr	-424(ra) # 80000f7e <acquire>
    8000212e:	4c9c                	lw	a5,24(s1)
    80002130:	cf81                	beqz	a5,80002148 <allocproc+0x40>
    80002132:	8526                	mv	a0,s1
    80002134:	fffff097          	auipc	ra,0xfffff
    80002138:	efe080e7          	jalr	-258(ra) # 80001032 <release>
    8000213c:	16848493          	addi	s1,s1,360
    80002140:	ff2492e3          	bne	s1,s2,80002124 <allocproc+0x1c>
    80002144:	4481                	li	s1,0
    80002146:	a0b9                	j	80002194 <allocproc+0x8c>
    80002148:	00000097          	auipc	ra,0x0
    8000214c:	e34080e7          	jalr	-460(ra) # 80001f7c <allocpid>
    80002150:	dc88                	sw	a0,56(s1)
    80002152:	fffff097          	auipc	ra,0xfffff
    80002156:	c1a080e7          	jalr	-998(ra) # 80000d6c <kalloc>
    8000215a:	892a                	mv	s2,a0
    8000215c:	eca8                	sd	a0,88(s1)
    8000215e:	c131                	beqz	a0,800021a2 <allocproc+0x9a>
    80002160:	8526                	mv	a0,s1
    80002162:	00000097          	auipc	ra,0x0
    80002166:	e60080e7          	jalr	-416(ra) # 80001fc2 <proc_pagetable>
    8000216a:	892a                	mv	s2,a0
    8000216c:	e8a8                	sd	a0,80(s1)
    8000216e:	c129                	beqz	a0,800021b0 <allocproc+0xa8>
    80002170:	07000613          	li	a2,112
    80002174:	4581                	li	a1,0
    80002176:	06048513          	addi	a0,s1,96
    8000217a:	fffff097          	auipc	ra,0xfffff
    8000217e:	f00080e7          	jalr	-256(ra) # 8000107a <memset>
    80002182:	00000797          	auipc	a5,0x0
    80002186:	db478793          	addi	a5,a5,-588 # 80001f36 <forkret>
    8000218a:	f0bc                	sd	a5,96(s1)
    8000218c:	60bc                	ld	a5,64(s1)
    8000218e:	6705                	lui	a4,0x1
    80002190:	97ba                	add	a5,a5,a4
    80002192:	f4bc                	sd	a5,104(s1)
    80002194:	8526                	mv	a0,s1
    80002196:	60e2                	ld	ra,24(sp)
    80002198:	6442                	ld	s0,16(sp)
    8000219a:	64a2                	ld	s1,8(sp)
    8000219c:	6902                	ld	s2,0(sp)
    8000219e:	6105                	addi	sp,sp,32
    800021a0:	8082                	ret
    800021a2:	8526                	mv	a0,s1
    800021a4:	fffff097          	auipc	ra,0xfffff
    800021a8:	e8e080e7          	jalr	-370(ra) # 80001032 <release>
    800021ac:	84ca                	mv	s1,s2
    800021ae:	b7dd                	j	80002194 <allocproc+0x8c>
    800021b0:	8526                	mv	a0,s1
    800021b2:	00000097          	auipc	ra,0x0
    800021b6:	efe080e7          	jalr	-258(ra) # 800020b0 <freeproc>
    800021ba:	8526                	mv	a0,s1
    800021bc:	fffff097          	auipc	ra,0xfffff
    800021c0:	e76080e7          	jalr	-394(ra) # 80001032 <release>
    800021c4:	84ca                	mv	s1,s2
    800021c6:	b7f9                	j	80002194 <allocproc+0x8c>

00000000800021c8 <userinit>:
    800021c8:	1101                	addi	sp,sp,-32
    800021ca:	ec06                	sd	ra,24(sp)
    800021cc:	e822                	sd	s0,16(sp)
    800021ce:	e426                	sd	s1,8(sp)
    800021d0:	1000                	addi	s0,sp,32
    800021d2:	00000097          	auipc	ra,0x0
    800021d6:	f36080e7          	jalr	-202(ra) # 80002108 <allocproc>
    800021da:	84aa                	mv	s1,a0
    800021dc:	00007797          	auipc	a5,0x7
    800021e0:	e2a7be23          	sd	a0,-452(a5) # 80009018 <initproc>
    800021e4:	03400613          	li	a2,52
    800021e8:	00006597          	auipc	a1,0x6
    800021ec:	73858593          	addi	a1,a1,1848 # 80008920 <initcode>
    800021f0:	6928                	ld	a0,80(a0)
    800021f2:	fffff097          	auipc	ra,0xfffff
    800021f6:	518080e7          	jalr	1304(ra) # 8000170a <uvminit>
    800021fa:	6785                	lui	a5,0x1
    800021fc:	e4bc                	sd	a5,72(s1)
    800021fe:	6cb8                	ld	a4,88(s1)
    80002200:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    80002204:	6cb8                	ld	a4,88(s1)
    80002206:	fb1c                	sd	a5,48(a4)
    80002208:	4641                	li	a2,16
    8000220a:	00006597          	auipc	a1,0x6
    8000220e:	06e58593          	addi	a1,a1,110 # 80008278 <digits+0x210>
    80002212:	15848513          	addi	a0,s1,344
    80002216:	fffff097          	auipc	ra,0xfffff
    8000221a:	fb6080e7          	jalr	-74(ra) # 800011cc <safestrcpy>
    8000221e:	00006517          	auipc	a0,0x6
    80002222:	06a50513          	addi	a0,a0,106 # 80008288 <digits+0x220>
    80002226:	00002097          	auipc	ra,0x2
    8000222a:	1b2080e7          	jalr	434(ra) # 800043d8 <namei>
    8000222e:	14a4b823          	sd	a0,336(s1)
    80002232:	4789                	li	a5,2
    80002234:	cc9c                	sw	a5,24(s1)
    80002236:	8526                	mv	a0,s1
    80002238:	fffff097          	auipc	ra,0xfffff
    8000223c:	dfa080e7          	jalr	-518(ra) # 80001032 <release>
    80002240:	60e2                	ld	ra,24(sp)
    80002242:	6442                	ld	s0,16(sp)
    80002244:	64a2                	ld	s1,8(sp)
    80002246:	6105                	addi	sp,sp,32
    80002248:	8082                	ret

000000008000224a <growproc>:
    8000224a:	1101                	addi	sp,sp,-32
    8000224c:	ec06                	sd	ra,24(sp)
    8000224e:	e822                	sd	s0,16(sp)
    80002250:	e426                	sd	s1,8(sp)
    80002252:	e04a                	sd	s2,0(sp)
    80002254:	1000                	addi	s0,sp,32
    80002256:	84aa                	mv	s1,a0
    80002258:	00000097          	auipc	ra,0x0
    8000225c:	ca6080e7          	jalr	-858(ra) # 80001efe <myproc>
    80002260:	892a                	mv	s2,a0
    80002262:	652c                	ld	a1,72(a0)
    80002264:	0005861b          	sext.w	a2,a1
    80002268:	00904f63          	bgtz	s1,80002286 <growproc+0x3c>
    8000226c:	0204cc63          	bltz	s1,800022a4 <growproc+0x5a>
    80002270:	1602                	slli	a2,a2,0x20
    80002272:	9201                	srli	a2,a2,0x20
    80002274:	04c93423          	sd	a2,72(s2)
    80002278:	4501                	li	a0,0
    8000227a:	60e2                	ld	ra,24(sp)
    8000227c:	6442                	ld	s0,16(sp)
    8000227e:	64a2                	ld	s1,8(sp)
    80002280:	6902                	ld	s2,0(sp)
    80002282:	6105                	addi	sp,sp,32
    80002284:	8082                	ret
    80002286:	9e25                	addw	a2,a2,s1
    80002288:	1602                	slli	a2,a2,0x20
    8000228a:	9201                	srli	a2,a2,0x20
    8000228c:	1582                	slli	a1,a1,0x20
    8000228e:	9181                	srli	a1,a1,0x20
    80002290:	6928                	ld	a0,80(a0)
    80002292:	fffff097          	auipc	ra,0xfffff
    80002296:	532080e7          	jalr	1330(ra) # 800017c4 <uvmalloc>
    8000229a:	0005061b          	sext.w	a2,a0
    8000229e:	fa69                	bnez	a2,80002270 <growproc+0x26>
    800022a0:	557d                	li	a0,-1
    800022a2:	bfe1                	j	8000227a <growproc+0x30>
    800022a4:	9e25                	addw	a2,a2,s1
    800022a6:	1602                	slli	a2,a2,0x20
    800022a8:	9201                	srli	a2,a2,0x20
    800022aa:	1582                	slli	a1,a1,0x20
    800022ac:	9181                	srli	a1,a1,0x20
    800022ae:	6928                	ld	a0,80(a0)
    800022b0:	fffff097          	auipc	ra,0xfffff
    800022b4:	4cc080e7          	jalr	1228(ra) # 8000177c <uvmdealloc>
    800022b8:	0005061b          	sext.w	a2,a0
    800022bc:	bf55                	j	80002270 <growproc+0x26>

00000000800022be <fork>:
    800022be:	7139                	addi	sp,sp,-64
    800022c0:	fc06                	sd	ra,56(sp)
    800022c2:	f822                	sd	s0,48(sp)
    800022c4:	f426                	sd	s1,40(sp)
    800022c6:	f04a                	sd	s2,32(sp)
    800022c8:	ec4e                	sd	s3,24(sp)
    800022ca:	e852                	sd	s4,16(sp)
    800022cc:	e456                	sd	s5,8(sp)
    800022ce:	0080                	addi	s0,sp,64
    800022d0:	00000097          	auipc	ra,0x0
    800022d4:	c2e080e7          	jalr	-978(ra) # 80001efe <myproc>
    800022d8:	8aaa                	mv	s5,a0
    800022da:	00000097          	auipc	ra,0x0
    800022de:	e2e080e7          	jalr	-466(ra) # 80002108 <allocproc>
    800022e2:	c17d                	beqz	a0,800023c8 <fork+0x10a>
    800022e4:	8a2a                	mv	s4,a0
    800022e6:	048ab603          	ld	a2,72(s5)
    800022ea:	692c                	ld	a1,80(a0)
    800022ec:	050ab503          	ld	a0,80(s5)
    800022f0:	fffff097          	auipc	ra,0xfffff
    800022f4:	620080e7          	jalr	1568(ra) # 80001910 <uvmcopy>
    800022f8:	04054a63          	bltz	a0,8000234c <fork+0x8e>
    800022fc:	048ab783          	ld	a5,72(s5)
    80002300:	04fa3423          	sd	a5,72(s4)
    80002304:	035a3023          	sd	s5,32(s4)
    80002308:	058ab683          	ld	a3,88(s5)
    8000230c:	87b6                	mv	a5,a3
    8000230e:	058a3703          	ld	a4,88(s4)
    80002312:	12068693          	addi	a3,a3,288
    80002316:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000231a:	6788                	ld	a0,8(a5)
    8000231c:	6b8c                	ld	a1,16(a5)
    8000231e:	6f90                	ld	a2,24(a5)
    80002320:	01073023          	sd	a6,0(a4)
    80002324:	e708                	sd	a0,8(a4)
    80002326:	eb0c                	sd	a1,16(a4)
    80002328:	ef10                	sd	a2,24(a4)
    8000232a:	02078793          	addi	a5,a5,32
    8000232e:	02070713          	addi	a4,a4,32
    80002332:	fed792e3          	bne	a5,a3,80002316 <fork+0x58>
    80002336:	058a3783          	ld	a5,88(s4)
    8000233a:	0607b823          	sd	zero,112(a5)
    8000233e:	0d0a8493          	addi	s1,s5,208
    80002342:	0d0a0913          	addi	s2,s4,208
    80002346:	150a8993          	addi	s3,s5,336
    8000234a:	a00d                	j	8000236c <fork+0xae>
    8000234c:	8552                	mv	a0,s4
    8000234e:	00000097          	auipc	ra,0x0
    80002352:	d62080e7          	jalr	-670(ra) # 800020b0 <freeproc>
    80002356:	8552                	mv	a0,s4
    80002358:	fffff097          	auipc	ra,0xfffff
    8000235c:	cda080e7          	jalr	-806(ra) # 80001032 <release>
    80002360:	54fd                	li	s1,-1
    80002362:	a889                	j	800023b4 <fork+0xf6>
    80002364:	04a1                	addi	s1,s1,8
    80002366:	0921                	addi	s2,s2,8
    80002368:	01348b63          	beq	s1,s3,8000237e <fork+0xc0>
    8000236c:	6088                	ld	a0,0(s1)
    8000236e:	d97d                	beqz	a0,80002364 <fork+0xa6>
    80002370:	00002097          	auipc	ra,0x2
    80002374:	6f4080e7          	jalr	1780(ra) # 80004a64 <filedup>
    80002378:	00a93023          	sd	a0,0(s2)
    8000237c:	b7e5                	j	80002364 <fork+0xa6>
    8000237e:	150ab503          	ld	a0,336(s5)
    80002382:	00002097          	auipc	ra,0x2
    80002386:	864080e7          	jalr	-1948(ra) # 80003be6 <idup>
    8000238a:	14aa3823          	sd	a0,336(s4)
    8000238e:	4641                	li	a2,16
    80002390:	158a8593          	addi	a1,s5,344
    80002394:	158a0513          	addi	a0,s4,344
    80002398:	fffff097          	auipc	ra,0xfffff
    8000239c:	e34080e7          	jalr	-460(ra) # 800011cc <safestrcpy>
    800023a0:	038a2483          	lw	s1,56(s4)
    800023a4:	4789                	li	a5,2
    800023a6:	00fa2c23          	sw	a5,24(s4)
    800023aa:	8552                	mv	a0,s4
    800023ac:	fffff097          	auipc	ra,0xfffff
    800023b0:	c86080e7          	jalr	-890(ra) # 80001032 <release>
    800023b4:	8526                	mv	a0,s1
    800023b6:	70e2                	ld	ra,56(sp)
    800023b8:	7442                	ld	s0,48(sp)
    800023ba:	74a2                	ld	s1,40(sp)
    800023bc:	7902                	ld	s2,32(sp)
    800023be:	69e2                	ld	s3,24(sp)
    800023c0:	6a42                	ld	s4,16(sp)
    800023c2:	6aa2                	ld	s5,8(sp)
    800023c4:	6121                	addi	sp,sp,64
    800023c6:	8082                	ret
    800023c8:	54fd                	li	s1,-1
    800023ca:	b7ed                	j	800023b4 <fork+0xf6>

00000000800023cc <reparent>:
    800023cc:	7179                	addi	sp,sp,-48
    800023ce:	f406                	sd	ra,40(sp)
    800023d0:	f022                	sd	s0,32(sp)
    800023d2:	ec26                	sd	s1,24(sp)
    800023d4:	e84a                	sd	s2,16(sp)
    800023d6:	e44e                	sd	s3,8(sp)
    800023d8:	e052                	sd	s4,0(sp)
    800023da:	1800                	addi	s0,sp,48
    800023dc:	892a                	mv	s2,a0
    800023de:	00030497          	auipc	s1,0x30
    800023e2:	aea48493          	addi	s1,s1,-1302 # 80031ec8 <proc>
    800023e6:	00007a17          	auipc	s4,0x7
    800023ea:	c32a0a13          	addi	s4,s4,-974 # 80009018 <initproc>
    800023ee:	00035997          	auipc	s3,0x35
    800023f2:	4da98993          	addi	s3,s3,1242 # 800378c8 <tickslock>
    800023f6:	a029                	j	80002400 <reparent+0x34>
    800023f8:	16848493          	addi	s1,s1,360
    800023fc:	03348363          	beq	s1,s3,80002422 <reparent+0x56>
    80002400:	709c                	ld	a5,32(s1)
    80002402:	ff279be3          	bne	a5,s2,800023f8 <reparent+0x2c>
    80002406:	8526                	mv	a0,s1
    80002408:	fffff097          	auipc	ra,0xfffff
    8000240c:	b76080e7          	jalr	-1162(ra) # 80000f7e <acquire>
    80002410:	000a3783          	ld	a5,0(s4)
    80002414:	f09c                	sd	a5,32(s1)
    80002416:	8526                	mv	a0,s1
    80002418:	fffff097          	auipc	ra,0xfffff
    8000241c:	c1a080e7          	jalr	-998(ra) # 80001032 <release>
    80002420:	bfe1                	j	800023f8 <reparent+0x2c>
    80002422:	70a2                	ld	ra,40(sp)
    80002424:	7402                	ld	s0,32(sp)
    80002426:	64e2                	ld	s1,24(sp)
    80002428:	6942                	ld	s2,16(sp)
    8000242a:	69a2                	ld	s3,8(sp)
    8000242c:	6a02                	ld	s4,0(sp)
    8000242e:	6145                	addi	sp,sp,48
    80002430:	8082                	ret

0000000080002432 <scheduler>:
    80002432:	711d                	addi	sp,sp,-96
    80002434:	ec86                	sd	ra,88(sp)
    80002436:	e8a2                	sd	s0,80(sp)
    80002438:	e4a6                	sd	s1,72(sp)
    8000243a:	e0ca                	sd	s2,64(sp)
    8000243c:	fc4e                	sd	s3,56(sp)
    8000243e:	f852                	sd	s4,48(sp)
    80002440:	f456                	sd	s5,40(sp)
    80002442:	f05a                	sd	s6,32(sp)
    80002444:	ec5e                	sd	s7,24(sp)
    80002446:	e862                	sd	s8,16(sp)
    80002448:	e466                	sd	s9,8(sp)
    8000244a:	1080                	addi	s0,sp,96
    8000244c:	8792                	mv	a5,tp
    8000244e:	2781                	sext.w	a5,a5
    80002450:	00779c13          	slli	s8,a5,0x7
    80002454:	0002f717          	auipc	a4,0x2f
    80002458:	65c70713          	addi	a4,a4,1628 # 80031ab0 <pid_lock>
    8000245c:	9762                	add	a4,a4,s8
    8000245e:	00073c23          	sd	zero,24(a4)
    80002462:	0002f717          	auipc	a4,0x2f
    80002466:	66e70713          	addi	a4,a4,1646 # 80031ad0 <cpus+0x8>
    8000246a:	9c3a                	add	s8,s8,a4
    8000246c:	4c81                	li	s9,0
    8000246e:	4a89                	li	s5,2
    80002470:	079e                	slli	a5,a5,0x7
    80002472:	0002fb17          	auipc	s6,0x2f
    80002476:	63eb0b13          	addi	s6,s6,1598 # 80031ab0 <pid_lock>
    8000247a:	9b3e                	add	s6,s6,a5
    8000247c:	00035a17          	auipc	s4,0x35
    80002480:	44ca0a13          	addi	s4,s4,1100 # 800378c8 <tickslock>
    80002484:	a8a1                	j	800024dc <scheduler+0xaa>
    80002486:	8526                	mv	a0,s1
    80002488:	fffff097          	auipc	ra,0xfffff
    8000248c:	baa080e7          	jalr	-1110(ra) # 80001032 <release>
    80002490:	16848493          	addi	s1,s1,360
    80002494:	03448a63          	beq	s1,s4,800024c8 <scheduler+0x96>
    80002498:	8526                	mv	a0,s1
    8000249a:	fffff097          	auipc	ra,0xfffff
    8000249e:	ae4080e7          	jalr	-1308(ra) # 80000f7e <acquire>
    800024a2:	4c9c                	lw	a5,24(s1)
    800024a4:	d3ed                	beqz	a5,80002486 <scheduler+0x54>
    800024a6:	2985                	addiw	s3,s3,1
    800024a8:	fd579fe3          	bne	a5,s5,80002486 <scheduler+0x54>
    800024ac:	0174ac23          	sw	s7,24(s1)
    800024b0:	009b3c23          	sd	s1,24(s6)
    800024b4:	06048593          	addi	a1,s1,96
    800024b8:	8562                	mv	a0,s8
    800024ba:	00000097          	auipc	ra,0x0
    800024be:	60c080e7          	jalr	1548(ra) # 80002ac6 <swtch>
    800024c2:	000b3c23          	sd	zero,24(s6)
    800024c6:	b7c1                	j	80002486 <scheduler+0x54>
    800024c8:	013aca63          	blt	s5,s3,800024dc <scheduler+0xaa>
    800024cc:	100027f3          	csrr	a5,sstatus
    800024d0:	0027e793          	ori	a5,a5,2
    800024d4:	10079073          	csrw	sstatus,a5
    800024d8:	10500073          	wfi
    800024dc:	100027f3          	csrr	a5,sstatus
    800024e0:	0027e793          	ori	a5,a5,2
    800024e4:	10079073          	csrw	sstatus,a5
    800024e8:	89e6                	mv	s3,s9
    800024ea:	00030497          	auipc	s1,0x30
    800024ee:	9de48493          	addi	s1,s1,-1570 # 80031ec8 <proc>
    800024f2:	4b8d                	li	s7,3
    800024f4:	b755                	j	80002498 <scheduler+0x66>

00000000800024f6 <sched>:
    800024f6:	7179                	addi	sp,sp,-48
    800024f8:	f406                	sd	ra,40(sp)
    800024fa:	f022                	sd	s0,32(sp)
    800024fc:	ec26                	sd	s1,24(sp)
    800024fe:	e84a                	sd	s2,16(sp)
    80002500:	e44e                	sd	s3,8(sp)
    80002502:	1800                	addi	s0,sp,48
    80002504:	00000097          	auipc	ra,0x0
    80002508:	9fa080e7          	jalr	-1542(ra) # 80001efe <myproc>
    8000250c:	84aa                	mv	s1,a0
    8000250e:	fffff097          	auipc	ra,0xfffff
    80002512:	9f6080e7          	jalr	-1546(ra) # 80000f04 <holding>
    80002516:	c93d                	beqz	a0,8000258c <sched+0x96>
    80002518:	8792                	mv	a5,tp
    8000251a:	2781                	sext.w	a5,a5
    8000251c:	079e                	slli	a5,a5,0x7
    8000251e:	0002f717          	auipc	a4,0x2f
    80002522:	59270713          	addi	a4,a4,1426 # 80031ab0 <pid_lock>
    80002526:	97ba                	add	a5,a5,a4
    80002528:	0907a703          	lw	a4,144(a5)
    8000252c:	4785                	li	a5,1
    8000252e:	06f71763          	bne	a4,a5,8000259c <sched+0xa6>
    80002532:	4c98                	lw	a4,24(s1)
    80002534:	478d                	li	a5,3
    80002536:	06f70b63          	beq	a4,a5,800025ac <sched+0xb6>
    8000253a:	100027f3          	csrr	a5,sstatus
    8000253e:	8b89                	andi	a5,a5,2
    80002540:	efb5                	bnez	a5,800025bc <sched+0xc6>
    80002542:	8792                	mv	a5,tp
    80002544:	0002f917          	auipc	s2,0x2f
    80002548:	56c90913          	addi	s2,s2,1388 # 80031ab0 <pid_lock>
    8000254c:	2781                	sext.w	a5,a5
    8000254e:	079e                	slli	a5,a5,0x7
    80002550:	97ca                	add	a5,a5,s2
    80002552:	0947a983          	lw	s3,148(a5)
    80002556:	8792                	mv	a5,tp
    80002558:	2781                	sext.w	a5,a5
    8000255a:	079e                	slli	a5,a5,0x7
    8000255c:	0002f597          	auipc	a1,0x2f
    80002560:	57458593          	addi	a1,a1,1396 # 80031ad0 <cpus+0x8>
    80002564:	95be                	add	a1,a1,a5
    80002566:	06048513          	addi	a0,s1,96
    8000256a:	00000097          	auipc	ra,0x0
    8000256e:	55c080e7          	jalr	1372(ra) # 80002ac6 <swtch>
    80002572:	8792                	mv	a5,tp
    80002574:	2781                	sext.w	a5,a5
    80002576:	079e                	slli	a5,a5,0x7
    80002578:	97ca                	add	a5,a5,s2
    8000257a:	0937aa23          	sw	s3,148(a5)
    8000257e:	70a2                	ld	ra,40(sp)
    80002580:	7402                	ld	s0,32(sp)
    80002582:	64e2                	ld	s1,24(sp)
    80002584:	6942                	ld	s2,16(sp)
    80002586:	69a2                	ld	s3,8(sp)
    80002588:	6145                	addi	sp,sp,48
    8000258a:	8082                	ret
    8000258c:	00006517          	auipc	a0,0x6
    80002590:	d0450513          	addi	a0,a0,-764 # 80008290 <digits+0x228>
    80002594:	ffffe097          	auipc	ra,0xffffe
    80002598:	054080e7          	jalr	84(ra) # 800005e8 <panic>
    8000259c:	00006517          	auipc	a0,0x6
    800025a0:	d0450513          	addi	a0,a0,-764 # 800082a0 <digits+0x238>
    800025a4:	ffffe097          	auipc	ra,0xffffe
    800025a8:	044080e7          	jalr	68(ra) # 800005e8 <panic>
    800025ac:	00006517          	auipc	a0,0x6
    800025b0:	d0450513          	addi	a0,a0,-764 # 800082b0 <digits+0x248>
    800025b4:	ffffe097          	auipc	ra,0xffffe
    800025b8:	034080e7          	jalr	52(ra) # 800005e8 <panic>
    800025bc:	00006517          	auipc	a0,0x6
    800025c0:	d0450513          	addi	a0,a0,-764 # 800082c0 <digits+0x258>
    800025c4:	ffffe097          	auipc	ra,0xffffe
    800025c8:	024080e7          	jalr	36(ra) # 800005e8 <panic>

00000000800025cc <exit>:
    800025cc:	7179                	addi	sp,sp,-48
    800025ce:	f406                	sd	ra,40(sp)
    800025d0:	f022                	sd	s0,32(sp)
    800025d2:	ec26                	sd	s1,24(sp)
    800025d4:	e84a                	sd	s2,16(sp)
    800025d6:	e44e                	sd	s3,8(sp)
    800025d8:	e052                	sd	s4,0(sp)
    800025da:	1800                	addi	s0,sp,48
    800025dc:	8a2a                	mv	s4,a0
    800025de:	00000097          	auipc	ra,0x0
    800025e2:	920080e7          	jalr	-1760(ra) # 80001efe <myproc>
    800025e6:	89aa                	mv	s3,a0
    800025e8:	00007797          	auipc	a5,0x7
    800025ec:	a307b783          	ld	a5,-1488(a5) # 80009018 <initproc>
    800025f0:	0d050493          	addi	s1,a0,208
    800025f4:	15050913          	addi	s2,a0,336
    800025f8:	02a79363          	bne	a5,a0,8000261e <exit+0x52>
    800025fc:	00006517          	auipc	a0,0x6
    80002600:	cdc50513          	addi	a0,a0,-804 # 800082d8 <digits+0x270>
    80002604:	ffffe097          	auipc	ra,0xffffe
    80002608:	fe4080e7          	jalr	-28(ra) # 800005e8 <panic>
    8000260c:	00002097          	auipc	ra,0x2
    80002610:	4aa080e7          	jalr	1194(ra) # 80004ab6 <fileclose>
    80002614:	0004b023          	sd	zero,0(s1)
    80002618:	04a1                	addi	s1,s1,8
    8000261a:	01248563          	beq	s1,s2,80002624 <exit+0x58>
    8000261e:	6088                	ld	a0,0(s1)
    80002620:	f575                	bnez	a0,8000260c <exit+0x40>
    80002622:	bfdd                	j	80002618 <exit+0x4c>
    80002624:	00002097          	auipc	ra,0x2
    80002628:	fc0080e7          	jalr	-64(ra) # 800045e4 <begin_op>
    8000262c:	1509b503          	ld	a0,336(s3)
    80002630:	00001097          	auipc	ra,0x1
    80002634:	7ae080e7          	jalr	1966(ra) # 80003dde <iput>
    80002638:	00002097          	auipc	ra,0x2
    8000263c:	02c080e7          	jalr	44(ra) # 80004664 <end_op>
    80002640:	1409b823          	sd	zero,336(s3)
    80002644:	00007497          	auipc	s1,0x7
    80002648:	9d448493          	addi	s1,s1,-1580 # 80009018 <initproc>
    8000264c:	6088                	ld	a0,0(s1)
    8000264e:	fffff097          	auipc	ra,0xfffff
    80002652:	930080e7          	jalr	-1744(ra) # 80000f7e <acquire>
    80002656:	6088                	ld	a0,0(s1)
    80002658:	fffff097          	auipc	ra,0xfffff
    8000265c:	766080e7          	jalr	1894(ra) # 80001dbe <wakeup1>
    80002660:	6088                	ld	a0,0(s1)
    80002662:	fffff097          	auipc	ra,0xfffff
    80002666:	9d0080e7          	jalr	-1584(ra) # 80001032 <release>
    8000266a:	854e                	mv	a0,s3
    8000266c:	fffff097          	auipc	ra,0xfffff
    80002670:	912080e7          	jalr	-1774(ra) # 80000f7e <acquire>
    80002674:	0209b483          	ld	s1,32(s3)
    80002678:	854e                	mv	a0,s3
    8000267a:	fffff097          	auipc	ra,0xfffff
    8000267e:	9b8080e7          	jalr	-1608(ra) # 80001032 <release>
    80002682:	8526                	mv	a0,s1
    80002684:	fffff097          	auipc	ra,0xfffff
    80002688:	8fa080e7          	jalr	-1798(ra) # 80000f7e <acquire>
    8000268c:	854e                	mv	a0,s3
    8000268e:	fffff097          	auipc	ra,0xfffff
    80002692:	8f0080e7          	jalr	-1808(ra) # 80000f7e <acquire>
    80002696:	854e                	mv	a0,s3
    80002698:	00000097          	auipc	ra,0x0
    8000269c:	d34080e7          	jalr	-716(ra) # 800023cc <reparent>
    800026a0:	8526                	mv	a0,s1
    800026a2:	fffff097          	auipc	ra,0xfffff
    800026a6:	71c080e7          	jalr	1820(ra) # 80001dbe <wakeup1>
    800026aa:	0349aa23          	sw	s4,52(s3)
    800026ae:	4791                	li	a5,4
    800026b0:	00f9ac23          	sw	a5,24(s3)
    800026b4:	8526                	mv	a0,s1
    800026b6:	fffff097          	auipc	ra,0xfffff
    800026ba:	97c080e7          	jalr	-1668(ra) # 80001032 <release>
    800026be:	00000097          	auipc	ra,0x0
    800026c2:	e38080e7          	jalr	-456(ra) # 800024f6 <sched>
    800026c6:	00006517          	auipc	a0,0x6
    800026ca:	c2250513          	addi	a0,a0,-990 # 800082e8 <digits+0x280>
    800026ce:	ffffe097          	auipc	ra,0xffffe
    800026d2:	f1a080e7          	jalr	-230(ra) # 800005e8 <panic>

00000000800026d6 <yield>:
    800026d6:	1101                	addi	sp,sp,-32
    800026d8:	ec06                	sd	ra,24(sp)
    800026da:	e822                	sd	s0,16(sp)
    800026dc:	e426                	sd	s1,8(sp)
    800026de:	1000                	addi	s0,sp,32
    800026e0:	00000097          	auipc	ra,0x0
    800026e4:	81e080e7          	jalr	-2018(ra) # 80001efe <myproc>
    800026e8:	84aa                	mv	s1,a0
    800026ea:	fffff097          	auipc	ra,0xfffff
    800026ee:	894080e7          	jalr	-1900(ra) # 80000f7e <acquire>
    800026f2:	4789                	li	a5,2
    800026f4:	cc9c                	sw	a5,24(s1)
    800026f6:	00000097          	auipc	ra,0x0
    800026fa:	e00080e7          	jalr	-512(ra) # 800024f6 <sched>
    800026fe:	8526                	mv	a0,s1
    80002700:	fffff097          	auipc	ra,0xfffff
    80002704:	932080e7          	jalr	-1742(ra) # 80001032 <release>
    80002708:	60e2                	ld	ra,24(sp)
    8000270a:	6442                	ld	s0,16(sp)
    8000270c:	64a2                	ld	s1,8(sp)
    8000270e:	6105                	addi	sp,sp,32
    80002710:	8082                	ret

0000000080002712 <sleep>:
    80002712:	7179                	addi	sp,sp,-48
    80002714:	f406                	sd	ra,40(sp)
    80002716:	f022                	sd	s0,32(sp)
    80002718:	ec26                	sd	s1,24(sp)
    8000271a:	e84a                	sd	s2,16(sp)
    8000271c:	e44e                	sd	s3,8(sp)
    8000271e:	1800                	addi	s0,sp,48
    80002720:	89aa                	mv	s3,a0
    80002722:	892e                	mv	s2,a1
    80002724:	fffff097          	auipc	ra,0xfffff
    80002728:	7da080e7          	jalr	2010(ra) # 80001efe <myproc>
    8000272c:	84aa                	mv	s1,a0
    8000272e:	05250663          	beq	a0,s2,8000277a <sleep+0x68>
    80002732:	fffff097          	auipc	ra,0xfffff
    80002736:	84c080e7          	jalr	-1972(ra) # 80000f7e <acquire>
    8000273a:	854a                	mv	a0,s2
    8000273c:	fffff097          	auipc	ra,0xfffff
    80002740:	8f6080e7          	jalr	-1802(ra) # 80001032 <release>
    80002744:	0334b423          	sd	s3,40(s1)
    80002748:	4785                	li	a5,1
    8000274a:	cc9c                	sw	a5,24(s1)
    8000274c:	00000097          	auipc	ra,0x0
    80002750:	daa080e7          	jalr	-598(ra) # 800024f6 <sched>
    80002754:	0204b423          	sd	zero,40(s1)
    80002758:	8526                	mv	a0,s1
    8000275a:	fffff097          	auipc	ra,0xfffff
    8000275e:	8d8080e7          	jalr	-1832(ra) # 80001032 <release>
    80002762:	854a                	mv	a0,s2
    80002764:	fffff097          	auipc	ra,0xfffff
    80002768:	81a080e7          	jalr	-2022(ra) # 80000f7e <acquire>
    8000276c:	70a2                	ld	ra,40(sp)
    8000276e:	7402                	ld	s0,32(sp)
    80002770:	64e2                	ld	s1,24(sp)
    80002772:	6942                	ld	s2,16(sp)
    80002774:	69a2                	ld	s3,8(sp)
    80002776:	6145                	addi	sp,sp,48
    80002778:	8082                	ret
    8000277a:	03353423          	sd	s3,40(a0)
    8000277e:	4785                	li	a5,1
    80002780:	cd1c                	sw	a5,24(a0)
    80002782:	00000097          	auipc	ra,0x0
    80002786:	d74080e7          	jalr	-652(ra) # 800024f6 <sched>
    8000278a:	0204b423          	sd	zero,40(s1)
    8000278e:	bff9                	j	8000276c <sleep+0x5a>

0000000080002790 <wait>:
    80002790:	715d                	addi	sp,sp,-80
    80002792:	e486                	sd	ra,72(sp)
    80002794:	e0a2                	sd	s0,64(sp)
    80002796:	fc26                	sd	s1,56(sp)
    80002798:	f84a                	sd	s2,48(sp)
    8000279a:	f44e                	sd	s3,40(sp)
    8000279c:	f052                	sd	s4,32(sp)
    8000279e:	ec56                	sd	s5,24(sp)
    800027a0:	e85a                	sd	s6,16(sp)
    800027a2:	e45e                	sd	s7,8(sp)
    800027a4:	0880                	addi	s0,sp,80
    800027a6:	8b2a                	mv	s6,a0
    800027a8:	fffff097          	auipc	ra,0xfffff
    800027ac:	756080e7          	jalr	1878(ra) # 80001efe <myproc>
    800027b0:	892a                	mv	s2,a0
    800027b2:	ffffe097          	auipc	ra,0xffffe
    800027b6:	7cc080e7          	jalr	1996(ra) # 80000f7e <acquire>
    800027ba:	4b81                	li	s7,0
    800027bc:	4a11                	li	s4,4
    800027be:	4a85                	li	s5,1
    800027c0:	00035997          	auipc	s3,0x35
    800027c4:	10898993          	addi	s3,s3,264 # 800378c8 <tickslock>
    800027c8:	875e                	mv	a4,s7
    800027ca:	0002f497          	auipc	s1,0x2f
    800027ce:	6fe48493          	addi	s1,s1,1790 # 80031ec8 <proc>
    800027d2:	a08d                	j	80002834 <wait+0xa4>
    800027d4:	0384a983          	lw	s3,56(s1)
    800027d8:	8526                	mv	a0,s1
    800027da:	00000097          	auipc	ra,0x0
    800027de:	8d6080e7          	jalr	-1834(ra) # 800020b0 <freeproc>
    800027e2:	000b0e63          	beqz	s6,800027fe <wait+0x6e>
    800027e6:	4691                	li	a3,4
    800027e8:	03448613          	addi	a2,s1,52
    800027ec:	85da                	mv	a1,s6
    800027ee:	05093503          	ld	a0,80(s2)
    800027f2:	fffff097          	auipc	ra,0xfffff
    800027f6:	4d8080e7          	jalr	1240(ra) # 80001cca <copyout>
    800027fa:	00054d63          	bltz	a0,80002814 <wait+0x84>
    800027fe:	8526                	mv	a0,s1
    80002800:	fffff097          	auipc	ra,0xfffff
    80002804:	832080e7          	jalr	-1998(ra) # 80001032 <release>
    80002808:	854a                	mv	a0,s2
    8000280a:	fffff097          	auipc	ra,0xfffff
    8000280e:	828080e7          	jalr	-2008(ra) # 80001032 <release>
    80002812:	a8a9                	j	8000286c <wait+0xdc>
    80002814:	8526                	mv	a0,s1
    80002816:	fffff097          	auipc	ra,0xfffff
    8000281a:	81c080e7          	jalr	-2020(ra) # 80001032 <release>
    8000281e:	854a                	mv	a0,s2
    80002820:	fffff097          	auipc	ra,0xfffff
    80002824:	812080e7          	jalr	-2030(ra) # 80001032 <release>
    80002828:	59fd                	li	s3,-1
    8000282a:	a089                	j	8000286c <wait+0xdc>
    8000282c:	16848493          	addi	s1,s1,360
    80002830:	03348463          	beq	s1,s3,80002858 <wait+0xc8>
    80002834:	709c                	ld	a5,32(s1)
    80002836:	ff279be3          	bne	a5,s2,8000282c <wait+0x9c>
    8000283a:	8526                	mv	a0,s1
    8000283c:	ffffe097          	auipc	ra,0xffffe
    80002840:	742080e7          	jalr	1858(ra) # 80000f7e <acquire>
    80002844:	4c9c                	lw	a5,24(s1)
    80002846:	f94787e3          	beq	a5,s4,800027d4 <wait+0x44>
    8000284a:	8526                	mv	a0,s1
    8000284c:	ffffe097          	auipc	ra,0xffffe
    80002850:	7e6080e7          	jalr	2022(ra) # 80001032 <release>
    80002854:	8756                	mv	a4,s5
    80002856:	bfd9                	j	8000282c <wait+0x9c>
    80002858:	c701                	beqz	a4,80002860 <wait+0xd0>
    8000285a:	03092783          	lw	a5,48(s2)
    8000285e:	c39d                	beqz	a5,80002884 <wait+0xf4>
    80002860:	854a                	mv	a0,s2
    80002862:	ffffe097          	auipc	ra,0xffffe
    80002866:	7d0080e7          	jalr	2000(ra) # 80001032 <release>
    8000286a:	59fd                	li	s3,-1
    8000286c:	854e                	mv	a0,s3
    8000286e:	60a6                	ld	ra,72(sp)
    80002870:	6406                	ld	s0,64(sp)
    80002872:	74e2                	ld	s1,56(sp)
    80002874:	7942                	ld	s2,48(sp)
    80002876:	79a2                	ld	s3,40(sp)
    80002878:	7a02                	ld	s4,32(sp)
    8000287a:	6ae2                	ld	s5,24(sp)
    8000287c:	6b42                	ld	s6,16(sp)
    8000287e:	6ba2                	ld	s7,8(sp)
    80002880:	6161                	addi	sp,sp,80
    80002882:	8082                	ret
    80002884:	85ca                	mv	a1,s2
    80002886:	854a                	mv	a0,s2
    80002888:	00000097          	auipc	ra,0x0
    8000288c:	e8a080e7          	jalr	-374(ra) # 80002712 <sleep>
    80002890:	bf25                	j	800027c8 <wait+0x38>

0000000080002892 <wakeup>:
    80002892:	7139                	addi	sp,sp,-64
    80002894:	fc06                	sd	ra,56(sp)
    80002896:	f822                	sd	s0,48(sp)
    80002898:	f426                	sd	s1,40(sp)
    8000289a:	f04a                	sd	s2,32(sp)
    8000289c:	ec4e                	sd	s3,24(sp)
    8000289e:	e852                	sd	s4,16(sp)
    800028a0:	e456                	sd	s5,8(sp)
    800028a2:	0080                	addi	s0,sp,64
    800028a4:	8a2a                	mv	s4,a0
    800028a6:	0002f497          	auipc	s1,0x2f
    800028aa:	62248493          	addi	s1,s1,1570 # 80031ec8 <proc>
    800028ae:	4985                	li	s3,1
    800028b0:	4a89                	li	s5,2
    800028b2:	00035917          	auipc	s2,0x35
    800028b6:	01690913          	addi	s2,s2,22 # 800378c8 <tickslock>
    800028ba:	a811                	j	800028ce <wakeup+0x3c>
    800028bc:	8526                	mv	a0,s1
    800028be:	ffffe097          	auipc	ra,0xffffe
    800028c2:	774080e7          	jalr	1908(ra) # 80001032 <release>
    800028c6:	16848493          	addi	s1,s1,360
    800028ca:	03248063          	beq	s1,s2,800028ea <wakeup+0x58>
    800028ce:	8526                	mv	a0,s1
    800028d0:	ffffe097          	auipc	ra,0xffffe
    800028d4:	6ae080e7          	jalr	1710(ra) # 80000f7e <acquire>
    800028d8:	4c9c                	lw	a5,24(s1)
    800028da:	ff3791e3          	bne	a5,s3,800028bc <wakeup+0x2a>
    800028de:	749c                	ld	a5,40(s1)
    800028e0:	fd479ee3          	bne	a5,s4,800028bc <wakeup+0x2a>
    800028e4:	0154ac23          	sw	s5,24(s1)
    800028e8:	bfd1                	j	800028bc <wakeup+0x2a>
    800028ea:	70e2                	ld	ra,56(sp)
    800028ec:	7442                	ld	s0,48(sp)
    800028ee:	74a2                	ld	s1,40(sp)
    800028f0:	7902                	ld	s2,32(sp)
    800028f2:	69e2                	ld	s3,24(sp)
    800028f4:	6a42                	ld	s4,16(sp)
    800028f6:	6aa2                	ld	s5,8(sp)
    800028f8:	6121                	addi	sp,sp,64
    800028fa:	8082                	ret

00000000800028fc <kill>:
    800028fc:	7179                	addi	sp,sp,-48
    800028fe:	f406                	sd	ra,40(sp)
    80002900:	f022                	sd	s0,32(sp)
    80002902:	ec26                	sd	s1,24(sp)
    80002904:	e84a                	sd	s2,16(sp)
    80002906:	e44e                	sd	s3,8(sp)
    80002908:	1800                	addi	s0,sp,48
    8000290a:	892a                	mv	s2,a0
    8000290c:	0002f497          	auipc	s1,0x2f
    80002910:	5bc48493          	addi	s1,s1,1468 # 80031ec8 <proc>
    80002914:	00035997          	auipc	s3,0x35
    80002918:	fb498993          	addi	s3,s3,-76 # 800378c8 <tickslock>
    8000291c:	8526                	mv	a0,s1
    8000291e:	ffffe097          	auipc	ra,0xffffe
    80002922:	660080e7          	jalr	1632(ra) # 80000f7e <acquire>
    80002926:	5c9c                	lw	a5,56(s1)
    80002928:	01278d63          	beq	a5,s2,80002942 <kill+0x46>
    8000292c:	8526                	mv	a0,s1
    8000292e:	ffffe097          	auipc	ra,0xffffe
    80002932:	704080e7          	jalr	1796(ra) # 80001032 <release>
    80002936:	16848493          	addi	s1,s1,360
    8000293a:	ff3491e3          	bne	s1,s3,8000291c <kill+0x20>
    8000293e:	557d                	li	a0,-1
    80002940:	a821                	j	80002958 <kill+0x5c>
    80002942:	4785                	li	a5,1
    80002944:	d89c                	sw	a5,48(s1)
    80002946:	4c98                	lw	a4,24(s1)
    80002948:	00f70f63          	beq	a4,a5,80002966 <kill+0x6a>
    8000294c:	8526                	mv	a0,s1
    8000294e:	ffffe097          	auipc	ra,0xffffe
    80002952:	6e4080e7          	jalr	1764(ra) # 80001032 <release>
    80002956:	4501                	li	a0,0
    80002958:	70a2                	ld	ra,40(sp)
    8000295a:	7402                	ld	s0,32(sp)
    8000295c:	64e2                	ld	s1,24(sp)
    8000295e:	6942                	ld	s2,16(sp)
    80002960:	69a2                	ld	s3,8(sp)
    80002962:	6145                	addi	sp,sp,48
    80002964:	8082                	ret
    80002966:	4789                	li	a5,2
    80002968:	cc9c                	sw	a5,24(s1)
    8000296a:	b7cd                	j	8000294c <kill+0x50>

000000008000296c <either_copyout>:
    8000296c:	7179                	addi	sp,sp,-48
    8000296e:	f406                	sd	ra,40(sp)
    80002970:	f022                	sd	s0,32(sp)
    80002972:	ec26                	sd	s1,24(sp)
    80002974:	e84a                	sd	s2,16(sp)
    80002976:	e44e                	sd	s3,8(sp)
    80002978:	e052                	sd	s4,0(sp)
    8000297a:	1800                	addi	s0,sp,48
    8000297c:	84aa                	mv	s1,a0
    8000297e:	892e                	mv	s2,a1
    80002980:	89b2                	mv	s3,a2
    80002982:	8a36                	mv	s4,a3
    80002984:	fffff097          	auipc	ra,0xfffff
    80002988:	57a080e7          	jalr	1402(ra) # 80001efe <myproc>
    8000298c:	c08d                	beqz	s1,800029ae <either_copyout+0x42>
    8000298e:	86d2                	mv	a3,s4
    80002990:	864e                	mv	a2,s3
    80002992:	85ca                	mv	a1,s2
    80002994:	6928                	ld	a0,80(a0)
    80002996:	fffff097          	auipc	ra,0xfffff
    8000299a:	334080e7          	jalr	820(ra) # 80001cca <copyout>
    8000299e:	70a2                	ld	ra,40(sp)
    800029a0:	7402                	ld	s0,32(sp)
    800029a2:	64e2                	ld	s1,24(sp)
    800029a4:	6942                	ld	s2,16(sp)
    800029a6:	69a2                	ld	s3,8(sp)
    800029a8:	6a02                	ld	s4,0(sp)
    800029aa:	6145                	addi	sp,sp,48
    800029ac:	8082                	ret
    800029ae:	000a061b          	sext.w	a2,s4
    800029b2:	85ce                	mv	a1,s3
    800029b4:	854a                	mv	a0,s2
    800029b6:	ffffe097          	auipc	ra,0xffffe
    800029ba:	720080e7          	jalr	1824(ra) # 800010d6 <memmove>
    800029be:	8526                	mv	a0,s1
    800029c0:	bff9                	j	8000299e <either_copyout+0x32>

00000000800029c2 <either_copyin>:
    800029c2:	7179                	addi	sp,sp,-48
    800029c4:	f406                	sd	ra,40(sp)
    800029c6:	f022                	sd	s0,32(sp)
    800029c8:	ec26                	sd	s1,24(sp)
    800029ca:	e84a                	sd	s2,16(sp)
    800029cc:	e44e                	sd	s3,8(sp)
    800029ce:	e052                	sd	s4,0(sp)
    800029d0:	1800                	addi	s0,sp,48
    800029d2:	892a                	mv	s2,a0
    800029d4:	84ae                	mv	s1,a1
    800029d6:	89b2                	mv	s3,a2
    800029d8:	8a36                	mv	s4,a3
    800029da:	fffff097          	auipc	ra,0xfffff
    800029de:	524080e7          	jalr	1316(ra) # 80001efe <myproc>
    800029e2:	c08d                	beqz	s1,80002a04 <either_copyin+0x42>
    800029e4:	86d2                	mv	a3,s4
    800029e6:	864e                	mv	a2,s3
    800029e8:	85ca                	mv	a1,s2
    800029ea:	6928                	ld	a0,80(a0)
    800029ec:	fffff097          	auipc	ra,0xfffff
    800029f0:	036080e7          	jalr	54(ra) # 80001a22 <copyin>
    800029f4:	70a2                	ld	ra,40(sp)
    800029f6:	7402                	ld	s0,32(sp)
    800029f8:	64e2                	ld	s1,24(sp)
    800029fa:	6942                	ld	s2,16(sp)
    800029fc:	69a2                	ld	s3,8(sp)
    800029fe:	6a02                	ld	s4,0(sp)
    80002a00:	6145                	addi	sp,sp,48
    80002a02:	8082                	ret
    80002a04:	000a061b          	sext.w	a2,s4
    80002a08:	85ce                	mv	a1,s3
    80002a0a:	854a                	mv	a0,s2
    80002a0c:	ffffe097          	auipc	ra,0xffffe
    80002a10:	6ca080e7          	jalr	1738(ra) # 800010d6 <memmove>
    80002a14:	8526                	mv	a0,s1
    80002a16:	bff9                	j	800029f4 <either_copyin+0x32>

0000000080002a18 <procdump>:
    80002a18:	715d                	addi	sp,sp,-80
    80002a1a:	e486                	sd	ra,72(sp)
    80002a1c:	e0a2                	sd	s0,64(sp)
    80002a1e:	fc26                	sd	s1,56(sp)
    80002a20:	f84a                	sd	s2,48(sp)
    80002a22:	f44e                	sd	s3,40(sp)
    80002a24:	f052                	sd	s4,32(sp)
    80002a26:	ec56                	sd	s5,24(sp)
    80002a28:	e85a                	sd	s6,16(sp)
    80002a2a:	e45e                	sd	s7,8(sp)
    80002a2c:	0880                	addi	s0,sp,80
    80002a2e:	00005517          	auipc	a0,0x5
    80002a32:	75a50513          	addi	a0,a0,1882 # 80008188 <digits+0x120>
    80002a36:	ffffe097          	auipc	ra,0xffffe
    80002a3a:	c04080e7          	jalr	-1020(ra) # 8000063a <printf>
    80002a3e:	0002f497          	auipc	s1,0x2f
    80002a42:	5e248493          	addi	s1,s1,1506 # 80032020 <proc+0x158>
    80002a46:	00035917          	auipc	s2,0x35
    80002a4a:	fda90913          	addi	s2,s2,-38 # 80037a20 <bcache+0x140>
    80002a4e:	4b11                	li	s6,4
    80002a50:	00006997          	auipc	s3,0x6
    80002a54:	8a898993          	addi	s3,s3,-1880 # 800082f8 <digits+0x290>
    80002a58:	00006a97          	auipc	s5,0x6
    80002a5c:	8a8a8a93          	addi	s5,s5,-1880 # 80008300 <digits+0x298>
    80002a60:	00005a17          	auipc	s4,0x5
    80002a64:	728a0a13          	addi	s4,s4,1832 # 80008188 <digits+0x120>
    80002a68:	00006b97          	auipc	s7,0x6
    80002a6c:	8d0b8b93          	addi	s7,s7,-1840 # 80008338 <states.0>
    80002a70:	a00d                	j	80002a92 <procdump+0x7a>
    80002a72:	ee06a583          	lw	a1,-288(a3)
    80002a76:	8556                	mv	a0,s5
    80002a78:	ffffe097          	auipc	ra,0xffffe
    80002a7c:	bc2080e7          	jalr	-1086(ra) # 8000063a <printf>
    80002a80:	8552                	mv	a0,s4
    80002a82:	ffffe097          	auipc	ra,0xffffe
    80002a86:	bb8080e7          	jalr	-1096(ra) # 8000063a <printf>
    80002a8a:	16848493          	addi	s1,s1,360
    80002a8e:	03248163          	beq	s1,s2,80002ab0 <procdump+0x98>
    80002a92:	86a6                	mv	a3,s1
    80002a94:	ec04a783          	lw	a5,-320(s1)
    80002a98:	dbed                	beqz	a5,80002a8a <procdump+0x72>
    80002a9a:	864e                	mv	a2,s3
    80002a9c:	fcfb6be3          	bltu	s6,a5,80002a72 <procdump+0x5a>
    80002aa0:	1782                	slli	a5,a5,0x20
    80002aa2:	9381                	srli	a5,a5,0x20
    80002aa4:	078e                	slli	a5,a5,0x3
    80002aa6:	97de                	add	a5,a5,s7
    80002aa8:	6390                	ld	a2,0(a5)
    80002aaa:	f661                	bnez	a2,80002a72 <procdump+0x5a>
    80002aac:	864e                	mv	a2,s3
    80002aae:	b7d1                	j	80002a72 <procdump+0x5a>
    80002ab0:	60a6                	ld	ra,72(sp)
    80002ab2:	6406                	ld	s0,64(sp)
    80002ab4:	74e2                	ld	s1,56(sp)
    80002ab6:	7942                	ld	s2,48(sp)
    80002ab8:	79a2                	ld	s3,40(sp)
    80002aba:	7a02                	ld	s4,32(sp)
    80002abc:	6ae2                	ld	s5,24(sp)
    80002abe:	6b42                	ld	s6,16(sp)
    80002ac0:	6ba2                	ld	s7,8(sp)
    80002ac2:	6161                	addi	sp,sp,80
    80002ac4:	8082                	ret

0000000080002ac6 <swtch>:
    80002ac6:	00153023          	sd	ra,0(a0)
    80002aca:	00253423          	sd	sp,8(a0)
    80002ace:	e900                	sd	s0,16(a0)
    80002ad0:	ed04                	sd	s1,24(a0)
    80002ad2:	03253023          	sd	s2,32(a0)
    80002ad6:	03353423          	sd	s3,40(a0)
    80002ada:	03453823          	sd	s4,48(a0)
    80002ade:	03553c23          	sd	s5,56(a0)
    80002ae2:	05653023          	sd	s6,64(a0)
    80002ae6:	05753423          	sd	s7,72(a0)
    80002aea:	05853823          	sd	s8,80(a0)
    80002aee:	05953c23          	sd	s9,88(a0)
    80002af2:	07a53023          	sd	s10,96(a0)
    80002af6:	07b53423          	sd	s11,104(a0)
    80002afa:	0005b083          	ld	ra,0(a1)
    80002afe:	0085b103          	ld	sp,8(a1)
    80002b02:	6980                	ld	s0,16(a1)
    80002b04:	6d84                	ld	s1,24(a1)
    80002b06:	0205b903          	ld	s2,32(a1)
    80002b0a:	0285b983          	ld	s3,40(a1)
    80002b0e:	0305ba03          	ld	s4,48(a1)
    80002b12:	0385ba83          	ld	s5,56(a1)
    80002b16:	0405bb03          	ld	s6,64(a1)
    80002b1a:	0485bb83          	ld	s7,72(a1)
    80002b1e:	0505bc03          	ld	s8,80(a1)
    80002b22:	0585bc83          	ld	s9,88(a1)
    80002b26:	0605bd03          	ld	s10,96(a1)
    80002b2a:	0685bd83          	ld	s11,104(a1)
    80002b2e:	8082                	ret

0000000080002b30 <trapinit>:
    80002b30:	1141                	addi	sp,sp,-16
    80002b32:	e406                	sd	ra,8(sp)
    80002b34:	e022                	sd	s0,0(sp)
    80002b36:	0800                	addi	s0,sp,16
    80002b38:	00006597          	auipc	a1,0x6
    80002b3c:	82858593          	addi	a1,a1,-2008 # 80008360 <states.0+0x28>
    80002b40:	00035517          	auipc	a0,0x35
    80002b44:	d8850513          	addi	a0,a0,-632 # 800378c8 <tickslock>
    80002b48:	ffffe097          	auipc	ra,0xffffe
    80002b4c:	3a6080e7          	jalr	934(ra) # 80000eee <initlock>
    80002b50:	60a2                	ld	ra,8(sp)
    80002b52:	6402                	ld	s0,0(sp)
    80002b54:	0141                	addi	sp,sp,16
    80002b56:	8082                	ret

0000000080002b58 <trapinithart>:
    80002b58:	1141                	addi	sp,sp,-16
    80002b5a:	e422                	sd	s0,8(sp)
    80002b5c:	0800                	addi	s0,sp,16
    80002b5e:	00003797          	auipc	a5,0x3
    80002b62:	5b278793          	addi	a5,a5,1458 # 80006110 <kernelvec>
    80002b66:	10579073          	csrw	stvec,a5
    80002b6a:	6422                	ld	s0,8(sp)
    80002b6c:	0141                	addi	sp,sp,16
    80002b6e:	8082                	ret

0000000080002b70 <usertrapret>:
    80002b70:	1141                	addi	sp,sp,-16
    80002b72:	e406                	sd	ra,8(sp)
    80002b74:	e022                	sd	s0,0(sp)
    80002b76:	0800                	addi	s0,sp,16
    80002b78:	fffff097          	auipc	ra,0xfffff
    80002b7c:	386080e7          	jalr	902(ra) # 80001efe <myproc>
    80002b80:	100027f3          	csrr	a5,sstatus
    80002b84:	9bf5                	andi	a5,a5,-3
    80002b86:	10079073          	csrw	sstatus,a5
    80002b8a:	00004617          	auipc	a2,0x4
    80002b8e:	47660613          	addi	a2,a2,1142 # 80007000 <_trampoline>
    80002b92:	00004697          	auipc	a3,0x4
    80002b96:	46e68693          	addi	a3,a3,1134 # 80007000 <_trampoline>
    80002b9a:	8e91                	sub	a3,a3,a2
    80002b9c:	040007b7          	lui	a5,0x4000
    80002ba0:	17fd                	addi	a5,a5,-1
    80002ba2:	07b2                	slli	a5,a5,0xc
    80002ba4:	96be                	add	a3,a3,a5
    80002ba6:	10569073          	csrw	stvec,a3
    80002baa:	6d38                	ld	a4,88(a0)
    80002bac:	180026f3          	csrr	a3,satp
    80002bb0:	e314                	sd	a3,0(a4)
    80002bb2:	6d38                	ld	a4,88(a0)
    80002bb4:	6134                	ld	a3,64(a0)
    80002bb6:	6585                	lui	a1,0x1
    80002bb8:	96ae                	add	a3,a3,a1
    80002bba:	e714                	sd	a3,8(a4)
    80002bbc:	6d38                	ld	a4,88(a0)
    80002bbe:	00000697          	auipc	a3,0x0
    80002bc2:	13868693          	addi	a3,a3,312 # 80002cf6 <usertrap>
    80002bc6:	eb14                	sd	a3,16(a4)
    80002bc8:	6d38                	ld	a4,88(a0)
    80002bca:	8692                	mv	a3,tp
    80002bcc:	f314                	sd	a3,32(a4)
    80002bce:	100026f3          	csrr	a3,sstatus
    80002bd2:	eff6f693          	andi	a3,a3,-257
    80002bd6:	0206e693          	ori	a3,a3,32
    80002bda:	10069073          	csrw	sstatus,a3
    80002bde:	6d38                	ld	a4,88(a0)
    80002be0:	6f18                	ld	a4,24(a4)
    80002be2:	14171073          	csrw	sepc,a4
    80002be6:	692c                	ld	a1,80(a0)
    80002be8:	81b1                	srli	a1,a1,0xc
    80002bea:	00004717          	auipc	a4,0x4
    80002bee:	4a670713          	addi	a4,a4,1190 # 80007090 <userret>
    80002bf2:	8f11                	sub	a4,a4,a2
    80002bf4:	97ba                	add	a5,a5,a4
    80002bf6:	577d                	li	a4,-1
    80002bf8:	177e                	slli	a4,a4,0x3f
    80002bfa:	8dd9                	or	a1,a1,a4
    80002bfc:	02000537          	lui	a0,0x2000
    80002c00:	157d                	addi	a0,a0,-1
    80002c02:	0536                	slli	a0,a0,0xd
    80002c04:	9782                	jalr	a5
    80002c06:	60a2                	ld	ra,8(sp)
    80002c08:	6402                	ld	s0,0(sp)
    80002c0a:	0141                	addi	sp,sp,16
    80002c0c:	8082                	ret

0000000080002c0e <clockintr>:
    80002c0e:	1101                	addi	sp,sp,-32
    80002c10:	ec06                	sd	ra,24(sp)
    80002c12:	e822                	sd	s0,16(sp)
    80002c14:	e426                	sd	s1,8(sp)
    80002c16:	1000                	addi	s0,sp,32
    80002c18:	00035497          	auipc	s1,0x35
    80002c1c:	cb048493          	addi	s1,s1,-848 # 800378c8 <tickslock>
    80002c20:	8526                	mv	a0,s1
    80002c22:	ffffe097          	auipc	ra,0xffffe
    80002c26:	35c080e7          	jalr	860(ra) # 80000f7e <acquire>
    80002c2a:	00006517          	auipc	a0,0x6
    80002c2e:	3f650513          	addi	a0,a0,1014 # 80009020 <ticks>
    80002c32:	411c                	lw	a5,0(a0)
    80002c34:	2785                	addiw	a5,a5,1
    80002c36:	c11c                	sw	a5,0(a0)
    80002c38:	00000097          	auipc	ra,0x0
    80002c3c:	c5a080e7          	jalr	-934(ra) # 80002892 <wakeup>
    80002c40:	8526                	mv	a0,s1
    80002c42:	ffffe097          	auipc	ra,0xffffe
    80002c46:	3f0080e7          	jalr	1008(ra) # 80001032 <release>
    80002c4a:	60e2                	ld	ra,24(sp)
    80002c4c:	6442                	ld	s0,16(sp)
    80002c4e:	64a2                	ld	s1,8(sp)
    80002c50:	6105                	addi	sp,sp,32
    80002c52:	8082                	ret

0000000080002c54 <devintr>:
    80002c54:	1101                	addi	sp,sp,-32
    80002c56:	ec06                	sd	ra,24(sp)
    80002c58:	e822                	sd	s0,16(sp)
    80002c5a:	e426                	sd	s1,8(sp)
    80002c5c:	1000                	addi	s0,sp,32
    80002c5e:	14202773          	csrr	a4,scause
    80002c62:	00074d63          	bltz	a4,80002c7c <devintr+0x28>
    80002c66:	57fd                	li	a5,-1
    80002c68:	17fe                	slli	a5,a5,0x3f
    80002c6a:	0785                	addi	a5,a5,1
    80002c6c:	4501                	li	a0,0
    80002c6e:	06f70363          	beq	a4,a5,80002cd4 <devintr+0x80>
    80002c72:	60e2                	ld	ra,24(sp)
    80002c74:	6442                	ld	s0,16(sp)
    80002c76:	64a2                	ld	s1,8(sp)
    80002c78:	6105                	addi	sp,sp,32
    80002c7a:	8082                	ret
    80002c7c:	0ff77793          	zext.b	a5,a4
    80002c80:	46a5                	li	a3,9
    80002c82:	fed792e3          	bne	a5,a3,80002c66 <devintr+0x12>
    80002c86:	00003097          	auipc	ra,0x3
    80002c8a:	592080e7          	jalr	1426(ra) # 80006218 <plic_claim>
    80002c8e:	84aa                	mv	s1,a0
    80002c90:	47a9                	li	a5,10
    80002c92:	02f50763          	beq	a0,a5,80002cc0 <devintr+0x6c>
    80002c96:	4785                	li	a5,1
    80002c98:	02f50963          	beq	a0,a5,80002cca <devintr+0x76>
    80002c9c:	4505                	li	a0,1
    80002c9e:	d8f1                	beqz	s1,80002c72 <devintr+0x1e>
    80002ca0:	85a6                	mv	a1,s1
    80002ca2:	00005517          	auipc	a0,0x5
    80002ca6:	6c650513          	addi	a0,a0,1734 # 80008368 <states.0+0x30>
    80002caa:	ffffe097          	auipc	ra,0xffffe
    80002cae:	990080e7          	jalr	-1648(ra) # 8000063a <printf>
    80002cb2:	8526                	mv	a0,s1
    80002cb4:	00003097          	auipc	ra,0x3
    80002cb8:	588080e7          	jalr	1416(ra) # 8000623c <plic_complete>
    80002cbc:	4505                	li	a0,1
    80002cbe:	bf55                	j	80002c72 <devintr+0x1e>
    80002cc0:	ffffe097          	auipc	ra,0xffffe
    80002cc4:	d7e080e7          	jalr	-642(ra) # 80000a3e <uartintr>
    80002cc8:	b7ed                	j	80002cb2 <devintr+0x5e>
    80002cca:	00004097          	auipc	ra,0x4
    80002cce:	9ec080e7          	jalr	-1556(ra) # 800066b6 <virtio_disk_intr>
    80002cd2:	b7c5                	j	80002cb2 <devintr+0x5e>
    80002cd4:	fffff097          	auipc	ra,0xfffff
    80002cd8:	1fe080e7          	jalr	510(ra) # 80001ed2 <cpuid>
    80002cdc:	c901                	beqz	a0,80002cec <devintr+0x98>
    80002cde:	144027f3          	csrr	a5,sip
    80002ce2:	9bf5                	andi	a5,a5,-3
    80002ce4:	14479073          	csrw	sip,a5
    80002ce8:	4509                	li	a0,2
    80002cea:	b761                	j	80002c72 <devintr+0x1e>
    80002cec:	00000097          	auipc	ra,0x0
    80002cf0:	f22080e7          	jalr	-222(ra) # 80002c0e <clockintr>
    80002cf4:	b7ed                	j	80002cde <devintr+0x8a>

0000000080002cf6 <usertrap>:
    80002cf6:	7179                	addi	sp,sp,-48
    80002cf8:	f406                	sd	ra,40(sp)
    80002cfa:	f022                	sd	s0,32(sp)
    80002cfc:	ec26                	sd	s1,24(sp)
    80002cfe:	e84a                	sd	s2,16(sp)
    80002d00:	e44e                	sd	s3,8(sp)
    80002d02:	1800                	addi	s0,sp,48
    80002d04:	100027f3          	csrr	a5,sstatus
    80002d08:	1007f793          	andi	a5,a5,256
    80002d0c:	e3bd                	bnez	a5,80002d72 <usertrap+0x7c>
    80002d0e:	00003797          	auipc	a5,0x3
    80002d12:	40278793          	addi	a5,a5,1026 # 80006110 <kernelvec>
    80002d16:	10579073          	csrw	stvec,a5
    80002d1a:	fffff097          	auipc	ra,0xfffff
    80002d1e:	1e4080e7          	jalr	484(ra) # 80001efe <myproc>
    80002d22:	84aa                	mv	s1,a0
    80002d24:	6d3c                	ld	a5,88(a0)
    80002d26:	14102773          	csrr	a4,sepc
    80002d2a:	ef98                	sd	a4,24(a5)
    80002d2c:	14202773          	csrr	a4,scause
    80002d30:	47a1                	li	a5,8
    80002d32:	04f71e63          	bne	a4,a5,80002d8e <usertrap+0x98>
    80002d36:	591c                	lw	a5,48(a0)
    80002d38:	e7a9                	bnez	a5,80002d82 <usertrap+0x8c>
    80002d3a:	6cb8                	ld	a4,88(s1)
    80002d3c:	6f1c                	ld	a5,24(a4)
    80002d3e:	0791                	addi	a5,a5,4
    80002d40:	ef1c                	sd	a5,24(a4)
    80002d42:	100027f3          	csrr	a5,sstatus
    80002d46:	0027e793          	ori	a5,a5,2
    80002d4a:	10079073          	csrw	sstatus,a5
    80002d4e:	00000097          	auipc	ra,0x0
    80002d52:	396080e7          	jalr	918(ra) # 800030e4 <syscall>
    80002d56:	589c                	lw	a5,48(s1)
    80002d58:	12079163          	bnez	a5,80002e7a <usertrap+0x184>
    80002d5c:	00000097          	auipc	ra,0x0
    80002d60:	e14080e7          	jalr	-492(ra) # 80002b70 <usertrapret>
    80002d64:	70a2                	ld	ra,40(sp)
    80002d66:	7402                	ld	s0,32(sp)
    80002d68:	64e2                	ld	s1,24(sp)
    80002d6a:	6942                	ld	s2,16(sp)
    80002d6c:	69a2                	ld	s3,8(sp)
    80002d6e:	6145                	addi	sp,sp,48
    80002d70:	8082                	ret
    80002d72:	00005517          	auipc	a0,0x5
    80002d76:	61650513          	addi	a0,a0,1558 # 80008388 <states.0+0x50>
    80002d7a:	ffffe097          	auipc	ra,0xffffe
    80002d7e:	86e080e7          	jalr	-1938(ra) # 800005e8 <panic>
    80002d82:	557d                	li	a0,-1
    80002d84:	00000097          	auipc	ra,0x0
    80002d88:	848080e7          	jalr	-1976(ra) # 800025cc <exit>
    80002d8c:	b77d                	j	80002d3a <usertrap+0x44>
    80002d8e:	00000097          	auipc	ra,0x0
    80002d92:	ec6080e7          	jalr	-314(ra) # 80002c54 <devintr>
    80002d96:	892a                	mv	s2,a0
    80002d98:	ed71                	bnez	a0,80002e74 <usertrap+0x17e>
    80002d9a:	14202773          	csrr	a4,scause
    80002d9e:	47b5                	li	a5,13
    80002da0:	00f70763          	beq	a4,a5,80002dae <usertrap+0xb8>
    80002da4:	14202773          	csrr	a4,scause
    80002da8:	47bd                	li	a5,15
    80002daa:	08f71b63          	bne	a4,a5,80002e40 <usertrap+0x14a>
    80002dae:	143029f3          	csrr	s3,stval
    80002db2:	4785                	li	a5,1
    80002db4:	179a                	slli	a5,a5,0x26
    80002db6:	0537e863          	bltu	a5,s3,80002e06 <usertrap+0x110>
    80002dba:	4601                	li	a2,0
    80002dbc:	85ce                	mv	a1,s3
    80002dbe:	68a8                	ld	a0,80(s1)
    80002dc0:	ffffe097          	auipc	ra,0xffffe
    80002dc4:	5a2080e7          	jalr	1442(ra) # 80001362 <walk>
    80002dc8:	c95d                	beqz	a0,80002e7e <usertrap+0x188>
    80002dca:	611c                	ld	a5,0(a0)
    80002dcc:	0017f713          	andi	a4,a5,1
    80002dd0:	c769                	beqz	a4,80002e9a <usertrap+0x1a4>
    80002dd2:	1007f793          	andi	a5,a5,256
    80002dd6:	e3b9                	bnez	a5,80002e1c <usertrap+0x126>
    80002dd8:	00005517          	auipc	a0,0x5
    80002ddc:	5f050513          	addi	a0,a0,1520 # 800083c8 <states.0+0x90>
    80002de0:	ffffe097          	auipc	ra,0xffffe
    80002de4:	85a080e7          	jalr	-1958(ra) # 8000063a <printf>
    80002de8:	4785                	li	a5,1
    80002dea:	d89c                	sw	a5,48(s1)
    80002dec:	557d                	li	a0,-1
    80002dee:	fffff097          	auipc	ra,0xfffff
    80002df2:	7de080e7          	jalr	2014(ra) # 800025cc <exit>
    80002df6:	4789                	li	a5,2
    80002df8:	f6f912e3          	bne	s2,a5,80002d5c <usertrap+0x66>
    80002dfc:	00000097          	auipc	ra,0x0
    80002e00:	8da080e7          	jalr	-1830(ra) # 800026d6 <yield>
    80002e04:	bfa1                	j	80002d5c <usertrap+0x66>
    80002e06:	00005517          	auipc	a0,0x5
    80002e0a:	5a250513          	addi	a0,a0,1442 # 800083a8 <states.0+0x70>
    80002e0e:	ffffe097          	auipc	ra,0xffffe
    80002e12:	82c080e7          	jalr	-2004(ra) # 8000063a <printf>
    80002e16:	4785                	li	a5,1
    80002e18:	d89c                	sw	a5,48(s1)
    80002e1a:	b745                	j	80002dba <usertrap+0xc4>
    80002e1c:	85ce                	mv	a1,s3
    80002e1e:	68a8                	ld	a0,80(s1)
    80002e20:	fffff097          	auipc	ra,0xfffff
    80002e24:	d44080e7          	jalr	-700(ra) # 80001b64 <do_cow>
    80002e28:	d51d                	beqz	a0,80002d56 <usertrap+0x60>
    80002e2a:	00005517          	auipc	a0,0x5
    80002e2e:	58e50513          	addi	a0,a0,1422 # 800083b8 <states.0+0x80>
    80002e32:	ffffe097          	auipc	ra,0xffffe
    80002e36:	808080e7          	jalr	-2040(ra) # 8000063a <printf>
    80002e3a:	4785                	li	a5,1
    80002e3c:	d89c                	sw	a5,48(s1)
    80002e3e:	b77d                	j	80002dec <usertrap+0xf6>
    80002e40:	142025f3          	csrr	a1,scause
    80002e44:	5c90                	lw	a2,56(s1)
    80002e46:	00005517          	auipc	a0,0x5
    80002e4a:	59a50513          	addi	a0,a0,1434 # 800083e0 <states.0+0xa8>
    80002e4e:	ffffd097          	auipc	ra,0xffffd
    80002e52:	7ec080e7          	jalr	2028(ra) # 8000063a <printf>
    80002e56:	141025f3          	csrr	a1,sepc
    80002e5a:	14302673          	csrr	a2,stval
    80002e5e:	00005517          	auipc	a0,0x5
    80002e62:	5b250513          	addi	a0,a0,1458 # 80008410 <states.0+0xd8>
    80002e66:	ffffd097          	auipc	ra,0xffffd
    80002e6a:	7d4080e7          	jalr	2004(ra) # 8000063a <printf>
    80002e6e:	4785                	li	a5,1
    80002e70:	d89c                	sw	a5,48(s1)
    80002e72:	bfad                	j	80002dec <usertrap+0xf6>
    80002e74:	589c                	lw	a5,48(s1)
    80002e76:	d3c1                	beqz	a5,80002df6 <usertrap+0x100>
    80002e78:	bf95                	j	80002dec <usertrap+0xf6>
    80002e7a:	4901                	li	s2,0
    80002e7c:	bf85                	j	80002dec <usertrap+0xf6>
    80002e7e:	64bc                	ld	a5,72(s1)
    80002e80:	f4f9fce3          	bgeu	s3,a5,80002dd8 <usertrap+0xe2>
    80002e84:	85ce                	mv	a1,s3
    80002e86:	68a8                	ld	a0,80(s1)
    80002e88:	fffff097          	auipc	ra,0xfffff
    80002e8c:	de0080e7          	jalr	-544(ra) # 80001c68 <do_lazy_allocation>
    80002e90:	ec0503e3          	beqz	a0,80002d56 <usertrap+0x60>
    80002e94:	4785                	li	a5,1
    80002e96:	d89c                	sw	a5,48(s1)
    80002e98:	bf91                	j	80002dec <usertrap+0xf6>
    80002e9a:	64b8                	ld	a4,72(s1)
    80002e9c:	f2e9fbe3          	bgeu	s3,a4,80002dd2 <usertrap+0xdc>
    80002ea0:	b7d5                	j	80002e84 <usertrap+0x18e>

0000000080002ea2 <kerneltrap>:
    80002ea2:	7179                	addi	sp,sp,-48
    80002ea4:	f406                	sd	ra,40(sp)
    80002ea6:	f022                	sd	s0,32(sp)
    80002ea8:	ec26                	sd	s1,24(sp)
    80002eaa:	e84a                	sd	s2,16(sp)
    80002eac:	e44e                	sd	s3,8(sp)
    80002eae:	1800                	addi	s0,sp,48
    80002eb0:	14102973          	csrr	s2,sepc
    80002eb4:	100024f3          	csrr	s1,sstatus
    80002eb8:	142029f3          	csrr	s3,scause
    80002ebc:	1004f793          	andi	a5,s1,256
    80002ec0:	cb85                	beqz	a5,80002ef0 <kerneltrap+0x4e>
    80002ec2:	100027f3          	csrr	a5,sstatus
    80002ec6:	8b89                	andi	a5,a5,2
    80002ec8:	ef85                	bnez	a5,80002f00 <kerneltrap+0x5e>
    80002eca:	00000097          	auipc	ra,0x0
    80002ece:	d8a080e7          	jalr	-630(ra) # 80002c54 <devintr>
    80002ed2:	cd1d                	beqz	a0,80002f10 <kerneltrap+0x6e>
    80002ed4:	4789                	li	a5,2
    80002ed6:	06f50a63          	beq	a0,a5,80002f4a <kerneltrap+0xa8>
    80002eda:	14191073          	csrw	sepc,s2
    80002ede:	10049073          	csrw	sstatus,s1
    80002ee2:	70a2                	ld	ra,40(sp)
    80002ee4:	7402                	ld	s0,32(sp)
    80002ee6:	64e2                	ld	s1,24(sp)
    80002ee8:	6942                	ld	s2,16(sp)
    80002eea:	69a2                	ld	s3,8(sp)
    80002eec:	6145                	addi	sp,sp,48
    80002eee:	8082                	ret
    80002ef0:	00005517          	auipc	a0,0x5
    80002ef4:	54050513          	addi	a0,a0,1344 # 80008430 <states.0+0xf8>
    80002ef8:	ffffd097          	auipc	ra,0xffffd
    80002efc:	6f0080e7          	jalr	1776(ra) # 800005e8 <panic>
    80002f00:	00005517          	auipc	a0,0x5
    80002f04:	55850513          	addi	a0,a0,1368 # 80008458 <states.0+0x120>
    80002f08:	ffffd097          	auipc	ra,0xffffd
    80002f0c:	6e0080e7          	jalr	1760(ra) # 800005e8 <panic>
    80002f10:	85ce                	mv	a1,s3
    80002f12:	00005517          	auipc	a0,0x5
    80002f16:	56650513          	addi	a0,a0,1382 # 80008478 <states.0+0x140>
    80002f1a:	ffffd097          	auipc	ra,0xffffd
    80002f1e:	720080e7          	jalr	1824(ra) # 8000063a <printf>
    80002f22:	141025f3          	csrr	a1,sepc
    80002f26:	14302673          	csrr	a2,stval
    80002f2a:	00005517          	auipc	a0,0x5
    80002f2e:	55e50513          	addi	a0,a0,1374 # 80008488 <states.0+0x150>
    80002f32:	ffffd097          	auipc	ra,0xffffd
    80002f36:	708080e7          	jalr	1800(ra) # 8000063a <printf>
    80002f3a:	00005517          	auipc	a0,0x5
    80002f3e:	56650513          	addi	a0,a0,1382 # 800084a0 <states.0+0x168>
    80002f42:	ffffd097          	auipc	ra,0xffffd
    80002f46:	6a6080e7          	jalr	1702(ra) # 800005e8 <panic>
    80002f4a:	fffff097          	auipc	ra,0xfffff
    80002f4e:	fb4080e7          	jalr	-76(ra) # 80001efe <myproc>
    80002f52:	d541                	beqz	a0,80002eda <kerneltrap+0x38>
    80002f54:	fffff097          	auipc	ra,0xfffff
    80002f58:	faa080e7          	jalr	-86(ra) # 80001efe <myproc>
    80002f5c:	4d18                	lw	a4,24(a0)
    80002f5e:	478d                	li	a5,3
    80002f60:	f6f71de3          	bne	a4,a5,80002eda <kerneltrap+0x38>
    80002f64:	fffff097          	auipc	ra,0xfffff
    80002f68:	772080e7          	jalr	1906(ra) # 800026d6 <yield>
    80002f6c:	b7bd                	j	80002eda <kerneltrap+0x38>

0000000080002f6e <argraw>:
    80002f6e:	1101                	addi	sp,sp,-32
    80002f70:	ec06                	sd	ra,24(sp)
    80002f72:	e822                	sd	s0,16(sp)
    80002f74:	e426                	sd	s1,8(sp)
    80002f76:	1000                	addi	s0,sp,32
    80002f78:	84aa                	mv	s1,a0
    80002f7a:	fffff097          	auipc	ra,0xfffff
    80002f7e:	f84080e7          	jalr	-124(ra) # 80001efe <myproc>
    80002f82:	4795                	li	a5,5
    80002f84:	0497e163          	bltu	a5,s1,80002fc6 <argraw+0x58>
    80002f88:	048a                	slli	s1,s1,0x2
    80002f8a:	00005717          	auipc	a4,0x5
    80002f8e:	54e70713          	addi	a4,a4,1358 # 800084d8 <states.0+0x1a0>
    80002f92:	94ba                	add	s1,s1,a4
    80002f94:	409c                	lw	a5,0(s1)
    80002f96:	97ba                	add	a5,a5,a4
    80002f98:	8782                	jr	a5
    80002f9a:	6d3c                	ld	a5,88(a0)
    80002f9c:	7ba8                	ld	a0,112(a5)
    80002f9e:	60e2                	ld	ra,24(sp)
    80002fa0:	6442                	ld	s0,16(sp)
    80002fa2:	64a2                	ld	s1,8(sp)
    80002fa4:	6105                	addi	sp,sp,32
    80002fa6:	8082                	ret
    80002fa8:	6d3c                	ld	a5,88(a0)
    80002faa:	7fa8                	ld	a0,120(a5)
    80002fac:	bfcd                	j	80002f9e <argraw+0x30>
    80002fae:	6d3c                	ld	a5,88(a0)
    80002fb0:	63c8                	ld	a0,128(a5)
    80002fb2:	b7f5                	j	80002f9e <argraw+0x30>
    80002fb4:	6d3c                	ld	a5,88(a0)
    80002fb6:	67c8                	ld	a0,136(a5)
    80002fb8:	b7dd                	j	80002f9e <argraw+0x30>
    80002fba:	6d3c                	ld	a5,88(a0)
    80002fbc:	6bc8                	ld	a0,144(a5)
    80002fbe:	b7c5                	j	80002f9e <argraw+0x30>
    80002fc0:	6d3c                	ld	a5,88(a0)
    80002fc2:	6fc8                	ld	a0,152(a5)
    80002fc4:	bfe9                	j	80002f9e <argraw+0x30>
    80002fc6:	00005517          	auipc	a0,0x5
    80002fca:	4ea50513          	addi	a0,a0,1258 # 800084b0 <states.0+0x178>
    80002fce:	ffffd097          	auipc	ra,0xffffd
    80002fd2:	61a080e7          	jalr	1562(ra) # 800005e8 <panic>

0000000080002fd6 <fetchaddr>:
    80002fd6:	1101                	addi	sp,sp,-32
    80002fd8:	ec06                	sd	ra,24(sp)
    80002fda:	e822                	sd	s0,16(sp)
    80002fdc:	e426                	sd	s1,8(sp)
    80002fde:	e04a                	sd	s2,0(sp)
    80002fe0:	1000                	addi	s0,sp,32
    80002fe2:	84aa                	mv	s1,a0
    80002fe4:	892e                	mv	s2,a1
    80002fe6:	fffff097          	auipc	ra,0xfffff
    80002fea:	f18080e7          	jalr	-232(ra) # 80001efe <myproc>
    80002fee:	653c                	ld	a5,72(a0)
    80002ff0:	02f4f863          	bgeu	s1,a5,80003020 <fetchaddr+0x4a>
    80002ff4:	00848713          	addi	a4,s1,8
    80002ff8:	02e7e663          	bltu	a5,a4,80003024 <fetchaddr+0x4e>
    80002ffc:	46a1                	li	a3,8
    80002ffe:	8626                	mv	a2,s1
    80003000:	85ca                	mv	a1,s2
    80003002:	6928                	ld	a0,80(a0)
    80003004:	fffff097          	auipc	ra,0xfffff
    80003008:	a1e080e7          	jalr	-1506(ra) # 80001a22 <copyin>
    8000300c:	00a03533          	snez	a0,a0
    80003010:	40a00533          	neg	a0,a0
    80003014:	60e2                	ld	ra,24(sp)
    80003016:	6442                	ld	s0,16(sp)
    80003018:	64a2                	ld	s1,8(sp)
    8000301a:	6902                	ld	s2,0(sp)
    8000301c:	6105                	addi	sp,sp,32
    8000301e:	8082                	ret
    80003020:	557d                	li	a0,-1
    80003022:	bfcd                	j	80003014 <fetchaddr+0x3e>
    80003024:	557d                	li	a0,-1
    80003026:	b7fd                	j	80003014 <fetchaddr+0x3e>

0000000080003028 <fetchstr>:
    80003028:	7179                	addi	sp,sp,-48
    8000302a:	f406                	sd	ra,40(sp)
    8000302c:	f022                	sd	s0,32(sp)
    8000302e:	ec26                	sd	s1,24(sp)
    80003030:	e84a                	sd	s2,16(sp)
    80003032:	e44e                	sd	s3,8(sp)
    80003034:	1800                	addi	s0,sp,48
    80003036:	892a                	mv	s2,a0
    80003038:	84ae                	mv	s1,a1
    8000303a:	89b2                	mv	s3,a2
    8000303c:	fffff097          	auipc	ra,0xfffff
    80003040:	ec2080e7          	jalr	-318(ra) # 80001efe <myproc>
    80003044:	86ce                	mv	a3,s3
    80003046:	864a                	mv	a2,s2
    80003048:	85a6                	mv	a1,s1
    8000304a:	6928                	ld	a0,80(a0)
    8000304c:	fffff097          	auipc	ra,0xfffff
    80003050:	a64080e7          	jalr	-1436(ra) # 80001ab0 <copyinstr>
    80003054:	00054763          	bltz	a0,80003062 <fetchstr+0x3a>
    80003058:	8526                	mv	a0,s1
    8000305a:	ffffe097          	auipc	ra,0xffffe
    8000305e:	1a4080e7          	jalr	420(ra) # 800011fe <strlen>
    80003062:	70a2                	ld	ra,40(sp)
    80003064:	7402                	ld	s0,32(sp)
    80003066:	64e2                	ld	s1,24(sp)
    80003068:	6942                	ld	s2,16(sp)
    8000306a:	69a2                	ld	s3,8(sp)
    8000306c:	6145                	addi	sp,sp,48
    8000306e:	8082                	ret

0000000080003070 <argint>:
    80003070:	1101                	addi	sp,sp,-32
    80003072:	ec06                	sd	ra,24(sp)
    80003074:	e822                	sd	s0,16(sp)
    80003076:	e426                	sd	s1,8(sp)
    80003078:	1000                	addi	s0,sp,32
    8000307a:	84ae                	mv	s1,a1
    8000307c:	00000097          	auipc	ra,0x0
    80003080:	ef2080e7          	jalr	-270(ra) # 80002f6e <argraw>
    80003084:	c088                	sw	a0,0(s1)
    80003086:	4501                	li	a0,0
    80003088:	60e2                	ld	ra,24(sp)
    8000308a:	6442                	ld	s0,16(sp)
    8000308c:	64a2                	ld	s1,8(sp)
    8000308e:	6105                	addi	sp,sp,32
    80003090:	8082                	ret

0000000080003092 <argaddr>:
    80003092:	1101                	addi	sp,sp,-32
    80003094:	ec06                	sd	ra,24(sp)
    80003096:	e822                	sd	s0,16(sp)
    80003098:	e426                	sd	s1,8(sp)
    8000309a:	1000                	addi	s0,sp,32
    8000309c:	84ae                	mv	s1,a1
    8000309e:	00000097          	auipc	ra,0x0
    800030a2:	ed0080e7          	jalr	-304(ra) # 80002f6e <argraw>
    800030a6:	e088                	sd	a0,0(s1)
    800030a8:	4501                	li	a0,0
    800030aa:	60e2                	ld	ra,24(sp)
    800030ac:	6442                	ld	s0,16(sp)
    800030ae:	64a2                	ld	s1,8(sp)
    800030b0:	6105                	addi	sp,sp,32
    800030b2:	8082                	ret

00000000800030b4 <argstr>:
    800030b4:	1101                	addi	sp,sp,-32
    800030b6:	ec06                	sd	ra,24(sp)
    800030b8:	e822                	sd	s0,16(sp)
    800030ba:	e426                	sd	s1,8(sp)
    800030bc:	e04a                	sd	s2,0(sp)
    800030be:	1000                	addi	s0,sp,32
    800030c0:	84ae                	mv	s1,a1
    800030c2:	8932                	mv	s2,a2
    800030c4:	00000097          	auipc	ra,0x0
    800030c8:	eaa080e7          	jalr	-342(ra) # 80002f6e <argraw>
    800030cc:	864a                	mv	a2,s2
    800030ce:	85a6                	mv	a1,s1
    800030d0:	00000097          	auipc	ra,0x0
    800030d4:	f58080e7          	jalr	-168(ra) # 80003028 <fetchstr>
    800030d8:	60e2                	ld	ra,24(sp)
    800030da:	6442                	ld	s0,16(sp)
    800030dc:	64a2                	ld	s1,8(sp)
    800030de:	6902                	ld	s2,0(sp)
    800030e0:	6105                	addi	sp,sp,32
    800030e2:	8082                	ret

00000000800030e4 <syscall>:
    800030e4:	1101                	addi	sp,sp,-32
    800030e6:	ec06                	sd	ra,24(sp)
    800030e8:	e822                	sd	s0,16(sp)
    800030ea:	e426                	sd	s1,8(sp)
    800030ec:	e04a                	sd	s2,0(sp)
    800030ee:	1000                	addi	s0,sp,32
    800030f0:	fffff097          	auipc	ra,0xfffff
    800030f4:	e0e080e7          	jalr	-498(ra) # 80001efe <myproc>
    800030f8:	84aa                	mv	s1,a0
    800030fa:	05853903          	ld	s2,88(a0)
    800030fe:	0a893783          	ld	a5,168(s2)
    80003102:	0007869b          	sext.w	a3,a5
    80003106:	37fd                	addiw	a5,a5,-1
    80003108:	4751                	li	a4,20
    8000310a:	00f76f63          	bltu	a4,a5,80003128 <syscall+0x44>
    8000310e:	00369713          	slli	a4,a3,0x3
    80003112:	00005797          	auipc	a5,0x5
    80003116:	3de78793          	addi	a5,a5,990 # 800084f0 <syscalls>
    8000311a:	97ba                	add	a5,a5,a4
    8000311c:	639c                	ld	a5,0(a5)
    8000311e:	c789                	beqz	a5,80003128 <syscall+0x44>
    80003120:	9782                	jalr	a5
    80003122:	06a93823          	sd	a0,112(s2)
    80003126:	a839                	j	80003144 <syscall+0x60>
    80003128:	15848613          	addi	a2,s1,344
    8000312c:	5c8c                	lw	a1,56(s1)
    8000312e:	00005517          	auipc	a0,0x5
    80003132:	38a50513          	addi	a0,a0,906 # 800084b8 <states.0+0x180>
    80003136:	ffffd097          	auipc	ra,0xffffd
    8000313a:	504080e7          	jalr	1284(ra) # 8000063a <printf>
    8000313e:	6cbc                	ld	a5,88(s1)
    80003140:	577d                	li	a4,-1
    80003142:	fbb8                	sd	a4,112(a5)
    80003144:	60e2                	ld	ra,24(sp)
    80003146:	6442                	ld	s0,16(sp)
    80003148:	64a2                	ld	s1,8(sp)
    8000314a:	6902                	ld	s2,0(sp)
    8000314c:	6105                	addi	sp,sp,32
    8000314e:	8082                	ret

0000000080003150 <sys_exit>:
    80003150:	1101                	addi	sp,sp,-32
    80003152:	ec06                	sd	ra,24(sp)
    80003154:	e822                	sd	s0,16(sp)
    80003156:	1000                	addi	s0,sp,32
    80003158:	fec40593          	addi	a1,s0,-20
    8000315c:	4501                	li	a0,0
    8000315e:	00000097          	auipc	ra,0x0
    80003162:	f12080e7          	jalr	-238(ra) # 80003070 <argint>
    80003166:	57fd                	li	a5,-1
    80003168:	00054963          	bltz	a0,8000317a <sys_exit+0x2a>
    8000316c:	fec42503          	lw	a0,-20(s0)
    80003170:	fffff097          	auipc	ra,0xfffff
    80003174:	45c080e7          	jalr	1116(ra) # 800025cc <exit>
    80003178:	4781                	li	a5,0
    8000317a:	853e                	mv	a0,a5
    8000317c:	60e2                	ld	ra,24(sp)
    8000317e:	6442                	ld	s0,16(sp)
    80003180:	6105                	addi	sp,sp,32
    80003182:	8082                	ret

0000000080003184 <sys_getpid>:
    80003184:	1141                	addi	sp,sp,-16
    80003186:	e406                	sd	ra,8(sp)
    80003188:	e022                	sd	s0,0(sp)
    8000318a:	0800                	addi	s0,sp,16
    8000318c:	fffff097          	auipc	ra,0xfffff
    80003190:	d72080e7          	jalr	-654(ra) # 80001efe <myproc>
    80003194:	5d08                	lw	a0,56(a0)
    80003196:	60a2                	ld	ra,8(sp)
    80003198:	6402                	ld	s0,0(sp)
    8000319a:	0141                	addi	sp,sp,16
    8000319c:	8082                	ret

000000008000319e <sys_fork>:
    8000319e:	1141                	addi	sp,sp,-16
    800031a0:	e406                	sd	ra,8(sp)
    800031a2:	e022                	sd	s0,0(sp)
    800031a4:	0800                	addi	s0,sp,16
    800031a6:	fffff097          	auipc	ra,0xfffff
    800031aa:	118080e7          	jalr	280(ra) # 800022be <fork>
    800031ae:	60a2                	ld	ra,8(sp)
    800031b0:	6402                	ld	s0,0(sp)
    800031b2:	0141                	addi	sp,sp,16
    800031b4:	8082                	ret

00000000800031b6 <sys_wait>:
    800031b6:	1101                	addi	sp,sp,-32
    800031b8:	ec06                	sd	ra,24(sp)
    800031ba:	e822                	sd	s0,16(sp)
    800031bc:	1000                	addi	s0,sp,32
    800031be:	fe840593          	addi	a1,s0,-24
    800031c2:	4501                	li	a0,0
    800031c4:	00000097          	auipc	ra,0x0
    800031c8:	ece080e7          	jalr	-306(ra) # 80003092 <argaddr>
    800031cc:	87aa                	mv	a5,a0
    800031ce:	557d                	li	a0,-1
    800031d0:	0007c863          	bltz	a5,800031e0 <sys_wait+0x2a>
    800031d4:	fe843503          	ld	a0,-24(s0)
    800031d8:	fffff097          	auipc	ra,0xfffff
    800031dc:	5b8080e7          	jalr	1464(ra) # 80002790 <wait>
    800031e0:	60e2                	ld	ra,24(sp)
    800031e2:	6442                	ld	s0,16(sp)
    800031e4:	6105                	addi	sp,sp,32
    800031e6:	8082                	ret

00000000800031e8 <sys_sbrk>:
    800031e8:	7179                	addi	sp,sp,-48
    800031ea:	f406                	sd	ra,40(sp)
    800031ec:	f022                	sd	s0,32(sp)
    800031ee:	ec26                	sd	s1,24(sp)
    800031f0:	e84a                	sd	s2,16(sp)
    800031f2:	1800                	addi	s0,sp,48
    800031f4:	fdc40593          	addi	a1,s0,-36
    800031f8:	4501                	li	a0,0
    800031fa:	00000097          	auipc	ra,0x0
    800031fe:	e76080e7          	jalr	-394(ra) # 80003070 <argint>
    80003202:	87aa                	mv	a5,a0
    80003204:	557d                	li	a0,-1
    80003206:	0207c763          	bltz	a5,80003234 <sys_sbrk+0x4c>
    8000320a:	fffff097          	auipc	ra,0xfffff
    8000320e:	cf4080e7          	jalr	-780(ra) # 80001efe <myproc>
    80003212:	892a                	mv	s2,a0
    80003214:	6538                	ld	a4,72(a0)
    80003216:	0007049b          	sext.w	s1,a4
    8000321a:	fdc42783          	lw	a5,-36(s0)
    8000321e:	97ba                	add	a5,a5,a4
    80003220:	e53c                	sd	a5,72(a0)
    80003222:	577d                	li	a4,-1
    80003224:	8369                	srli	a4,a4,0x1a
    80003226:	00f76d63          	bltu	a4,a5,80003240 <sys_sbrk+0x58>
    8000322a:	fdc42783          	lw	a5,-36(s0)
    8000322e:	0207c963          	bltz	a5,80003260 <sys_sbrk+0x78>
    80003232:	8526                	mv	a0,s1
    80003234:	70a2                	ld	ra,40(sp)
    80003236:	7402                	ld	s0,32(sp)
    80003238:	64e2                	ld	s1,24(sp)
    8000323a:	6942                	ld	s2,16(sp)
    8000323c:	6145                	addi	sp,sp,48
    8000323e:	8082                	ret
    80003240:	4785                	li	a5,1
    80003242:	d91c                	sw	a5,48(a0)
    80003244:	00005517          	auipc	a0,0x5
    80003248:	35c50513          	addi	a0,a0,860 # 800085a0 <syscalls+0xb0>
    8000324c:	ffffd097          	auipc	ra,0xffffd
    80003250:	3ee080e7          	jalr	1006(ra) # 8000063a <printf>
    80003254:	557d                	li	a0,-1
    80003256:	fffff097          	auipc	ra,0xfffff
    8000325a:	376080e7          	jalr	886(ra) # 800025cc <exit>
    8000325e:	b7f1                	j	8000322a <sys_sbrk+0x42>
    80003260:	04893603          	ld	a2,72(s2)
    80003264:	85a6                	mv	a1,s1
    80003266:	05093503          	ld	a0,80(s2)
    8000326a:	ffffe097          	auipc	ra,0xffffe
    8000326e:	512080e7          	jalr	1298(ra) # 8000177c <uvmdealloc>
    80003272:	b7c1                	j	80003232 <sys_sbrk+0x4a>

0000000080003274 <sys_sleep>:
    80003274:	7139                	addi	sp,sp,-64
    80003276:	fc06                	sd	ra,56(sp)
    80003278:	f822                	sd	s0,48(sp)
    8000327a:	f426                	sd	s1,40(sp)
    8000327c:	f04a                	sd	s2,32(sp)
    8000327e:	ec4e                	sd	s3,24(sp)
    80003280:	0080                	addi	s0,sp,64
    80003282:	fcc40593          	addi	a1,s0,-52
    80003286:	4501                	li	a0,0
    80003288:	00000097          	auipc	ra,0x0
    8000328c:	de8080e7          	jalr	-536(ra) # 80003070 <argint>
    80003290:	57fd                	li	a5,-1
    80003292:	06054563          	bltz	a0,800032fc <sys_sleep+0x88>
    80003296:	00034517          	auipc	a0,0x34
    8000329a:	63250513          	addi	a0,a0,1586 # 800378c8 <tickslock>
    8000329e:	ffffe097          	auipc	ra,0xffffe
    800032a2:	ce0080e7          	jalr	-800(ra) # 80000f7e <acquire>
    800032a6:	00006917          	auipc	s2,0x6
    800032aa:	d7a92903          	lw	s2,-646(s2) # 80009020 <ticks>
    800032ae:	fcc42783          	lw	a5,-52(s0)
    800032b2:	cf85                	beqz	a5,800032ea <sys_sleep+0x76>
    800032b4:	00034997          	auipc	s3,0x34
    800032b8:	61498993          	addi	s3,s3,1556 # 800378c8 <tickslock>
    800032bc:	00006497          	auipc	s1,0x6
    800032c0:	d6448493          	addi	s1,s1,-668 # 80009020 <ticks>
    800032c4:	fffff097          	auipc	ra,0xfffff
    800032c8:	c3a080e7          	jalr	-966(ra) # 80001efe <myproc>
    800032cc:	591c                	lw	a5,48(a0)
    800032ce:	ef9d                	bnez	a5,8000330c <sys_sleep+0x98>
    800032d0:	85ce                	mv	a1,s3
    800032d2:	8526                	mv	a0,s1
    800032d4:	fffff097          	auipc	ra,0xfffff
    800032d8:	43e080e7          	jalr	1086(ra) # 80002712 <sleep>
    800032dc:	409c                	lw	a5,0(s1)
    800032de:	412787bb          	subw	a5,a5,s2
    800032e2:	fcc42703          	lw	a4,-52(s0)
    800032e6:	fce7efe3          	bltu	a5,a4,800032c4 <sys_sleep+0x50>
    800032ea:	00034517          	auipc	a0,0x34
    800032ee:	5de50513          	addi	a0,a0,1502 # 800378c8 <tickslock>
    800032f2:	ffffe097          	auipc	ra,0xffffe
    800032f6:	d40080e7          	jalr	-704(ra) # 80001032 <release>
    800032fa:	4781                	li	a5,0
    800032fc:	853e                	mv	a0,a5
    800032fe:	70e2                	ld	ra,56(sp)
    80003300:	7442                	ld	s0,48(sp)
    80003302:	74a2                	ld	s1,40(sp)
    80003304:	7902                	ld	s2,32(sp)
    80003306:	69e2                	ld	s3,24(sp)
    80003308:	6121                	addi	sp,sp,64
    8000330a:	8082                	ret
    8000330c:	00034517          	auipc	a0,0x34
    80003310:	5bc50513          	addi	a0,a0,1468 # 800378c8 <tickslock>
    80003314:	ffffe097          	auipc	ra,0xffffe
    80003318:	d1e080e7          	jalr	-738(ra) # 80001032 <release>
    8000331c:	57fd                	li	a5,-1
    8000331e:	bff9                	j	800032fc <sys_sleep+0x88>

0000000080003320 <sys_kill>:
    80003320:	1101                	addi	sp,sp,-32
    80003322:	ec06                	sd	ra,24(sp)
    80003324:	e822                	sd	s0,16(sp)
    80003326:	1000                	addi	s0,sp,32
    80003328:	fec40593          	addi	a1,s0,-20
    8000332c:	4501                	li	a0,0
    8000332e:	00000097          	auipc	ra,0x0
    80003332:	d42080e7          	jalr	-702(ra) # 80003070 <argint>
    80003336:	87aa                	mv	a5,a0
    80003338:	557d                	li	a0,-1
    8000333a:	0007c863          	bltz	a5,8000334a <sys_kill+0x2a>
    8000333e:	fec42503          	lw	a0,-20(s0)
    80003342:	fffff097          	auipc	ra,0xfffff
    80003346:	5ba080e7          	jalr	1466(ra) # 800028fc <kill>
    8000334a:	60e2                	ld	ra,24(sp)
    8000334c:	6442                	ld	s0,16(sp)
    8000334e:	6105                	addi	sp,sp,32
    80003350:	8082                	ret

0000000080003352 <sys_uptime>:
    80003352:	1101                	addi	sp,sp,-32
    80003354:	ec06                	sd	ra,24(sp)
    80003356:	e822                	sd	s0,16(sp)
    80003358:	e426                	sd	s1,8(sp)
    8000335a:	1000                	addi	s0,sp,32
    8000335c:	00034517          	auipc	a0,0x34
    80003360:	56c50513          	addi	a0,a0,1388 # 800378c8 <tickslock>
    80003364:	ffffe097          	auipc	ra,0xffffe
    80003368:	c1a080e7          	jalr	-998(ra) # 80000f7e <acquire>
    8000336c:	00006497          	auipc	s1,0x6
    80003370:	cb44a483          	lw	s1,-844(s1) # 80009020 <ticks>
    80003374:	00034517          	auipc	a0,0x34
    80003378:	55450513          	addi	a0,a0,1364 # 800378c8 <tickslock>
    8000337c:	ffffe097          	auipc	ra,0xffffe
    80003380:	cb6080e7          	jalr	-842(ra) # 80001032 <release>
    80003384:	02049513          	slli	a0,s1,0x20
    80003388:	9101                	srli	a0,a0,0x20
    8000338a:	60e2                	ld	ra,24(sp)
    8000338c:	6442                	ld	s0,16(sp)
    8000338e:	64a2                	ld	s1,8(sp)
    80003390:	6105                	addi	sp,sp,32
    80003392:	8082                	ret

0000000080003394 <binit>:
    80003394:	7179                	addi	sp,sp,-48
    80003396:	f406                	sd	ra,40(sp)
    80003398:	f022                	sd	s0,32(sp)
    8000339a:	ec26                	sd	s1,24(sp)
    8000339c:	e84a                	sd	s2,16(sp)
    8000339e:	e44e                	sd	s3,8(sp)
    800033a0:	e052                	sd	s4,0(sp)
    800033a2:	1800                	addi	s0,sp,48
    800033a4:	00005597          	auipc	a1,0x5
    800033a8:	21458593          	addi	a1,a1,532 # 800085b8 <syscalls+0xc8>
    800033ac:	00034517          	auipc	a0,0x34
    800033b0:	53450513          	addi	a0,a0,1332 # 800378e0 <bcache>
    800033b4:	ffffe097          	auipc	ra,0xffffe
    800033b8:	b3a080e7          	jalr	-1222(ra) # 80000eee <initlock>
    800033bc:	0003c797          	auipc	a5,0x3c
    800033c0:	52478793          	addi	a5,a5,1316 # 8003f8e0 <bcache+0x8000>
    800033c4:	0003c717          	auipc	a4,0x3c
    800033c8:	78470713          	addi	a4,a4,1924 # 8003fb48 <bcache+0x8268>
    800033cc:	2ae7b823          	sd	a4,688(a5)
    800033d0:	2ae7bc23          	sd	a4,696(a5)
    800033d4:	00034497          	auipc	s1,0x34
    800033d8:	52448493          	addi	s1,s1,1316 # 800378f8 <bcache+0x18>
    800033dc:	893e                	mv	s2,a5
    800033de:	89ba                	mv	s3,a4
    800033e0:	00005a17          	auipc	s4,0x5
    800033e4:	1e0a0a13          	addi	s4,s4,480 # 800085c0 <syscalls+0xd0>
    800033e8:	2b893783          	ld	a5,696(s2)
    800033ec:	e8bc                	sd	a5,80(s1)
    800033ee:	0534b423          	sd	s3,72(s1)
    800033f2:	85d2                	mv	a1,s4
    800033f4:	01048513          	addi	a0,s1,16
    800033f8:	00001097          	auipc	ra,0x1
    800033fc:	4b0080e7          	jalr	1200(ra) # 800048a8 <initsleeplock>
    80003400:	2b893783          	ld	a5,696(s2)
    80003404:	e7a4                	sd	s1,72(a5)
    80003406:	2a993c23          	sd	s1,696(s2)
    8000340a:	45848493          	addi	s1,s1,1112
    8000340e:	fd349de3          	bne	s1,s3,800033e8 <binit+0x54>
    80003412:	70a2                	ld	ra,40(sp)
    80003414:	7402                	ld	s0,32(sp)
    80003416:	64e2                	ld	s1,24(sp)
    80003418:	6942                	ld	s2,16(sp)
    8000341a:	69a2                	ld	s3,8(sp)
    8000341c:	6a02                	ld	s4,0(sp)
    8000341e:	6145                	addi	sp,sp,48
    80003420:	8082                	ret

0000000080003422 <bread>:
    80003422:	7179                	addi	sp,sp,-48
    80003424:	f406                	sd	ra,40(sp)
    80003426:	f022                	sd	s0,32(sp)
    80003428:	ec26                	sd	s1,24(sp)
    8000342a:	e84a                	sd	s2,16(sp)
    8000342c:	e44e                	sd	s3,8(sp)
    8000342e:	1800                	addi	s0,sp,48
    80003430:	892a                	mv	s2,a0
    80003432:	89ae                	mv	s3,a1
    80003434:	00034517          	auipc	a0,0x34
    80003438:	4ac50513          	addi	a0,a0,1196 # 800378e0 <bcache>
    8000343c:	ffffe097          	auipc	ra,0xffffe
    80003440:	b42080e7          	jalr	-1214(ra) # 80000f7e <acquire>
    80003444:	0003c497          	auipc	s1,0x3c
    80003448:	7544b483          	ld	s1,1876(s1) # 8003fb98 <bcache+0x82b8>
    8000344c:	0003c797          	auipc	a5,0x3c
    80003450:	6fc78793          	addi	a5,a5,1788 # 8003fb48 <bcache+0x8268>
    80003454:	02f48f63          	beq	s1,a5,80003492 <bread+0x70>
    80003458:	873e                	mv	a4,a5
    8000345a:	a021                	j	80003462 <bread+0x40>
    8000345c:	68a4                	ld	s1,80(s1)
    8000345e:	02e48a63          	beq	s1,a4,80003492 <bread+0x70>
    80003462:	449c                	lw	a5,8(s1)
    80003464:	ff279ce3          	bne	a5,s2,8000345c <bread+0x3a>
    80003468:	44dc                	lw	a5,12(s1)
    8000346a:	ff3799e3          	bne	a5,s3,8000345c <bread+0x3a>
    8000346e:	40bc                	lw	a5,64(s1)
    80003470:	2785                	addiw	a5,a5,1
    80003472:	c0bc                	sw	a5,64(s1)
    80003474:	00034517          	auipc	a0,0x34
    80003478:	46c50513          	addi	a0,a0,1132 # 800378e0 <bcache>
    8000347c:	ffffe097          	auipc	ra,0xffffe
    80003480:	bb6080e7          	jalr	-1098(ra) # 80001032 <release>
    80003484:	01048513          	addi	a0,s1,16
    80003488:	00001097          	auipc	ra,0x1
    8000348c:	45a080e7          	jalr	1114(ra) # 800048e2 <acquiresleep>
    80003490:	a8b9                	j	800034ee <bread+0xcc>
    80003492:	0003c497          	auipc	s1,0x3c
    80003496:	6fe4b483          	ld	s1,1790(s1) # 8003fb90 <bcache+0x82b0>
    8000349a:	0003c797          	auipc	a5,0x3c
    8000349e:	6ae78793          	addi	a5,a5,1710 # 8003fb48 <bcache+0x8268>
    800034a2:	00f48863          	beq	s1,a5,800034b2 <bread+0x90>
    800034a6:	873e                	mv	a4,a5
    800034a8:	40bc                	lw	a5,64(s1)
    800034aa:	cf81                	beqz	a5,800034c2 <bread+0xa0>
    800034ac:	64a4                	ld	s1,72(s1)
    800034ae:	fee49de3          	bne	s1,a4,800034a8 <bread+0x86>
    800034b2:	00005517          	auipc	a0,0x5
    800034b6:	11650513          	addi	a0,a0,278 # 800085c8 <syscalls+0xd8>
    800034ba:	ffffd097          	auipc	ra,0xffffd
    800034be:	12e080e7          	jalr	302(ra) # 800005e8 <panic>
    800034c2:	0124a423          	sw	s2,8(s1)
    800034c6:	0134a623          	sw	s3,12(s1)
    800034ca:	0004a023          	sw	zero,0(s1)
    800034ce:	4785                	li	a5,1
    800034d0:	c0bc                	sw	a5,64(s1)
    800034d2:	00034517          	auipc	a0,0x34
    800034d6:	40e50513          	addi	a0,a0,1038 # 800378e0 <bcache>
    800034da:	ffffe097          	auipc	ra,0xffffe
    800034de:	b58080e7          	jalr	-1192(ra) # 80001032 <release>
    800034e2:	01048513          	addi	a0,s1,16
    800034e6:	00001097          	auipc	ra,0x1
    800034ea:	3fc080e7          	jalr	1020(ra) # 800048e2 <acquiresleep>
    800034ee:	409c                	lw	a5,0(s1)
    800034f0:	cb89                	beqz	a5,80003502 <bread+0xe0>
    800034f2:	8526                	mv	a0,s1
    800034f4:	70a2                	ld	ra,40(sp)
    800034f6:	7402                	ld	s0,32(sp)
    800034f8:	64e2                	ld	s1,24(sp)
    800034fa:	6942                	ld	s2,16(sp)
    800034fc:	69a2                	ld	s3,8(sp)
    800034fe:	6145                	addi	sp,sp,48
    80003500:	8082                	ret
    80003502:	4581                	li	a1,0
    80003504:	8526                	mv	a0,s1
    80003506:	00003097          	auipc	ra,0x3
    8000350a:	f26080e7          	jalr	-218(ra) # 8000642c <virtio_disk_rw>
    8000350e:	4785                	li	a5,1
    80003510:	c09c                	sw	a5,0(s1)
    80003512:	b7c5                	j	800034f2 <bread+0xd0>

0000000080003514 <bwrite>:
    80003514:	1101                	addi	sp,sp,-32
    80003516:	ec06                	sd	ra,24(sp)
    80003518:	e822                	sd	s0,16(sp)
    8000351a:	e426                	sd	s1,8(sp)
    8000351c:	1000                	addi	s0,sp,32
    8000351e:	84aa                	mv	s1,a0
    80003520:	0541                	addi	a0,a0,16
    80003522:	00001097          	auipc	ra,0x1
    80003526:	45a080e7          	jalr	1114(ra) # 8000497c <holdingsleep>
    8000352a:	cd01                	beqz	a0,80003542 <bwrite+0x2e>
    8000352c:	4585                	li	a1,1
    8000352e:	8526                	mv	a0,s1
    80003530:	00003097          	auipc	ra,0x3
    80003534:	efc080e7          	jalr	-260(ra) # 8000642c <virtio_disk_rw>
    80003538:	60e2                	ld	ra,24(sp)
    8000353a:	6442                	ld	s0,16(sp)
    8000353c:	64a2                	ld	s1,8(sp)
    8000353e:	6105                	addi	sp,sp,32
    80003540:	8082                	ret
    80003542:	00005517          	auipc	a0,0x5
    80003546:	09e50513          	addi	a0,a0,158 # 800085e0 <syscalls+0xf0>
    8000354a:	ffffd097          	auipc	ra,0xffffd
    8000354e:	09e080e7          	jalr	158(ra) # 800005e8 <panic>

0000000080003552 <brelse>:
    80003552:	1101                	addi	sp,sp,-32
    80003554:	ec06                	sd	ra,24(sp)
    80003556:	e822                	sd	s0,16(sp)
    80003558:	e426                	sd	s1,8(sp)
    8000355a:	e04a                	sd	s2,0(sp)
    8000355c:	1000                	addi	s0,sp,32
    8000355e:	84aa                	mv	s1,a0
    80003560:	01050913          	addi	s2,a0,16
    80003564:	854a                	mv	a0,s2
    80003566:	00001097          	auipc	ra,0x1
    8000356a:	416080e7          	jalr	1046(ra) # 8000497c <holdingsleep>
    8000356e:	c92d                	beqz	a0,800035e0 <brelse+0x8e>
    80003570:	854a                	mv	a0,s2
    80003572:	00001097          	auipc	ra,0x1
    80003576:	3c6080e7          	jalr	966(ra) # 80004938 <releasesleep>
    8000357a:	00034517          	auipc	a0,0x34
    8000357e:	36650513          	addi	a0,a0,870 # 800378e0 <bcache>
    80003582:	ffffe097          	auipc	ra,0xffffe
    80003586:	9fc080e7          	jalr	-1540(ra) # 80000f7e <acquire>
    8000358a:	40bc                	lw	a5,64(s1)
    8000358c:	37fd                	addiw	a5,a5,-1
    8000358e:	0007871b          	sext.w	a4,a5
    80003592:	c0bc                	sw	a5,64(s1)
    80003594:	eb05                	bnez	a4,800035c4 <brelse+0x72>
    80003596:	68bc                	ld	a5,80(s1)
    80003598:	64b8                	ld	a4,72(s1)
    8000359a:	e7b8                	sd	a4,72(a5)
    8000359c:	64bc                	ld	a5,72(s1)
    8000359e:	68b8                	ld	a4,80(s1)
    800035a0:	ebb8                	sd	a4,80(a5)
    800035a2:	0003c797          	auipc	a5,0x3c
    800035a6:	33e78793          	addi	a5,a5,830 # 8003f8e0 <bcache+0x8000>
    800035aa:	2b87b703          	ld	a4,696(a5)
    800035ae:	e8b8                	sd	a4,80(s1)
    800035b0:	0003c717          	auipc	a4,0x3c
    800035b4:	59870713          	addi	a4,a4,1432 # 8003fb48 <bcache+0x8268>
    800035b8:	e4b8                	sd	a4,72(s1)
    800035ba:	2b87b703          	ld	a4,696(a5)
    800035be:	e724                	sd	s1,72(a4)
    800035c0:	2a97bc23          	sd	s1,696(a5)
    800035c4:	00034517          	auipc	a0,0x34
    800035c8:	31c50513          	addi	a0,a0,796 # 800378e0 <bcache>
    800035cc:	ffffe097          	auipc	ra,0xffffe
    800035d0:	a66080e7          	jalr	-1434(ra) # 80001032 <release>
    800035d4:	60e2                	ld	ra,24(sp)
    800035d6:	6442                	ld	s0,16(sp)
    800035d8:	64a2                	ld	s1,8(sp)
    800035da:	6902                	ld	s2,0(sp)
    800035dc:	6105                	addi	sp,sp,32
    800035de:	8082                	ret
    800035e0:	00005517          	auipc	a0,0x5
    800035e4:	00850513          	addi	a0,a0,8 # 800085e8 <syscalls+0xf8>
    800035e8:	ffffd097          	auipc	ra,0xffffd
    800035ec:	000080e7          	jalr	ra # 800005e8 <panic>

00000000800035f0 <bpin>:
    800035f0:	1101                	addi	sp,sp,-32
    800035f2:	ec06                	sd	ra,24(sp)
    800035f4:	e822                	sd	s0,16(sp)
    800035f6:	e426                	sd	s1,8(sp)
    800035f8:	1000                	addi	s0,sp,32
    800035fa:	84aa                	mv	s1,a0
    800035fc:	00034517          	auipc	a0,0x34
    80003600:	2e450513          	addi	a0,a0,740 # 800378e0 <bcache>
    80003604:	ffffe097          	auipc	ra,0xffffe
    80003608:	97a080e7          	jalr	-1670(ra) # 80000f7e <acquire>
    8000360c:	40bc                	lw	a5,64(s1)
    8000360e:	2785                	addiw	a5,a5,1
    80003610:	c0bc                	sw	a5,64(s1)
    80003612:	00034517          	auipc	a0,0x34
    80003616:	2ce50513          	addi	a0,a0,718 # 800378e0 <bcache>
    8000361a:	ffffe097          	auipc	ra,0xffffe
    8000361e:	a18080e7          	jalr	-1512(ra) # 80001032 <release>
    80003622:	60e2                	ld	ra,24(sp)
    80003624:	6442                	ld	s0,16(sp)
    80003626:	64a2                	ld	s1,8(sp)
    80003628:	6105                	addi	sp,sp,32
    8000362a:	8082                	ret

000000008000362c <bunpin>:
    8000362c:	1101                	addi	sp,sp,-32
    8000362e:	ec06                	sd	ra,24(sp)
    80003630:	e822                	sd	s0,16(sp)
    80003632:	e426                	sd	s1,8(sp)
    80003634:	1000                	addi	s0,sp,32
    80003636:	84aa                	mv	s1,a0
    80003638:	00034517          	auipc	a0,0x34
    8000363c:	2a850513          	addi	a0,a0,680 # 800378e0 <bcache>
    80003640:	ffffe097          	auipc	ra,0xffffe
    80003644:	93e080e7          	jalr	-1730(ra) # 80000f7e <acquire>
    80003648:	40bc                	lw	a5,64(s1)
    8000364a:	37fd                	addiw	a5,a5,-1
    8000364c:	c0bc                	sw	a5,64(s1)
    8000364e:	00034517          	auipc	a0,0x34
    80003652:	29250513          	addi	a0,a0,658 # 800378e0 <bcache>
    80003656:	ffffe097          	auipc	ra,0xffffe
    8000365a:	9dc080e7          	jalr	-1572(ra) # 80001032 <release>
    8000365e:	60e2                	ld	ra,24(sp)
    80003660:	6442                	ld	s0,16(sp)
    80003662:	64a2                	ld	s1,8(sp)
    80003664:	6105                	addi	sp,sp,32
    80003666:	8082                	ret

0000000080003668 <bfree>:
    80003668:	1101                	addi	sp,sp,-32
    8000366a:	ec06                	sd	ra,24(sp)
    8000366c:	e822                	sd	s0,16(sp)
    8000366e:	e426                	sd	s1,8(sp)
    80003670:	e04a                	sd	s2,0(sp)
    80003672:	1000                	addi	s0,sp,32
    80003674:	84ae                	mv	s1,a1
    80003676:	00d5d59b          	srliw	a1,a1,0xd
    8000367a:	0003d797          	auipc	a5,0x3d
    8000367e:	9427a783          	lw	a5,-1726(a5) # 8003ffbc <sb+0x1c>
    80003682:	9dbd                	addw	a1,a1,a5
    80003684:	00000097          	auipc	ra,0x0
    80003688:	d9e080e7          	jalr	-610(ra) # 80003422 <bread>
    8000368c:	0074f713          	andi	a4,s1,7
    80003690:	4785                	li	a5,1
    80003692:	00e797bb          	sllw	a5,a5,a4
    80003696:	14ce                	slli	s1,s1,0x33
    80003698:	90d9                	srli	s1,s1,0x36
    8000369a:	00950733          	add	a4,a0,s1
    8000369e:	05874703          	lbu	a4,88(a4)
    800036a2:	00e7f6b3          	and	a3,a5,a4
    800036a6:	c69d                	beqz	a3,800036d4 <bfree+0x6c>
    800036a8:	892a                	mv	s2,a0
    800036aa:	94aa                	add	s1,s1,a0
    800036ac:	fff7c793          	not	a5,a5
    800036b0:	8ff9                	and	a5,a5,a4
    800036b2:	04f48c23          	sb	a5,88(s1)
    800036b6:	00001097          	auipc	ra,0x1
    800036ba:	104080e7          	jalr	260(ra) # 800047ba <log_write>
    800036be:	854a                	mv	a0,s2
    800036c0:	00000097          	auipc	ra,0x0
    800036c4:	e92080e7          	jalr	-366(ra) # 80003552 <brelse>
    800036c8:	60e2                	ld	ra,24(sp)
    800036ca:	6442                	ld	s0,16(sp)
    800036cc:	64a2                	ld	s1,8(sp)
    800036ce:	6902                	ld	s2,0(sp)
    800036d0:	6105                	addi	sp,sp,32
    800036d2:	8082                	ret
    800036d4:	00005517          	auipc	a0,0x5
    800036d8:	f1c50513          	addi	a0,a0,-228 # 800085f0 <syscalls+0x100>
    800036dc:	ffffd097          	auipc	ra,0xffffd
    800036e0:	f0c080e7          	jalr	-244(ra) # 800005e8 <panic>

00000000800036e4 <balloc>:
    800036e4:	711d                	addi	sp,sp,-96
    800036e6:	ec86                	sd	ra,88(sp)
    800036e8:	e8a2                	sd	s0,80(sp)
    800036ea:	e4a6                	sd	s1,72(sp)
    800036ec:	e0ca                	sd	s2,64(sp)
    800036ee:	fc4e                	sd	s3,56(sp)
    800036f0:	f852                	sd	s4,48(sp)
    800036f2:	f456                	sd	s5,40(sp)
    800036f4:	f05a                	sd	s6,32(sp)
    800036f6:	ec5e                	sd	s7,24(sp)
    800036f8:	e862                	sd	s8,16(sp)
    800036fa:	e466                	sd	s9,8(sp)
    800036fc:	1080                	addi	s0,sp,96
    800036fe:	0003d797          	auipc	a5,0x3d
    80003702:	8a67a783          	lw	a5,-1882(a5) # 8003ffa4 <sb+0x4>
    80003706:	cbd1                	beqz	a5,8000379a <balloc+0xb6>
    80003708:	8baa                	mv	s7,a0
    8000370a:	4a81                	li	s5,0
    8000370c:	0003db17          	auipc	s6,0x3d
    80003710:	894b0b13          	addi	s6,s6,-1900 # 8003ffa0 <sb>
    80003714:	4c01                	li	s8,0
    80003716:	4985                	li	s3,1
    80003718:	6a09                	lui	s4,0x2
    8000371a:	6c89                	lui	s9,0x2
    8000371c:	a831                	j	80003738 <balloc+0x54>
    8000371e:	854a                	mv	a0,s2
    80003720:	00000097          	auipc	ra,0x0
    80003724:	e32080e7          	jalr	-462(ra) # 80003552 <brelse>
    80003728:	015c87bb          	addw	a5,s9,s5
    8000372c:	00078a9b          	sext.w	s5,a5
    80003730:	004b2703          	lw	a4,4(s6)
    80003734:	06eaf363          	bgeu	s5,a4,8000379a <balloc+0xb6>
    80003738:	41fad79b          	sraiw	a5,s5,0x1f
    8000373c:	0137d79b          	srliw	a5,a5,0x13
    80003740:	015787bb          	addw	a5,a5,s5
    80003744:	40d7d79b          	sraiw	a5,a5,0xd
    80003748:	01cb2583          	lw	a1,28(s6)
    8000374c:	9dbd                	addw	a1,a1,a5
    8000374e:	855e                	mv	a0,s7
    80003750:	00000097          	auipc	ra,0x0
    80003754:	cd2080e7          	jalr	-814(ra) # 80003422 <bread>
    80003758:	892a                	mv	s2,a0
    8000375a:	004b2503          	lw	a0,4(s6)
    8000375e:	000a849b          	sext.w	s1,s5
    80003762:	8662                	mv	a2,s8
    80003764:	faa4fde3          	bgeu	s1,a0,8000371e <balloc+0x3a>
    80003768:	41f6579b          	sraiw	a5,a2,0x1f
    8000376c:	01d7d69b          	srliw	a3,a5,0x1d
    80003770:	00c6873b          	addw	a4,a3,a2
    80003774:	00777793          	andi	a5,a4,7
    80003778:	9f95                	subw	a5,a5,a3
    8000377a:	00f997bb          	sllw	a5,s3,a5
    8000377e:	4037571b          	sraiw	a4,a4,0x3
    80003782:	00e906b3          	add	a3,s2,a4
    80003786:	0586c683          	lbu	a3,88(a3)
    8000378a:	00d7f5b3          	and	a1,a5,a3
    8000378e:	cd91                	beqz	a1,800037aa <balloc+0xc6>
    80003790:	2605                	addiw	a2,a2,1
    80003792:	2485                	addiw	s1,s1,1
    80003794:	fd4618e3          	bne	a2,s4,80003764 <balloc+0x80>
    80003798:	b759                	j	8000371e <balloc+0x3a>
    8000379a:	00005517          	auipc	a0,0x5
    8000379e:	e6e50513          	addi	a0,a0,-402 # 80008608 <syscalls+0x118>
    800037a2:	ffffd097          	auipc	ra,0xffffd
    800037a6:	e46080e7          	jalr	-442(ra) # 800005e8 <panic>
    800037aa:	974a                	add	a4,a4,s2
    800037ac:	8fd5                	or	a5,a5,a3
    800037ae:	04f70c23          	sb	a5,88(a4)
    800037b2:	854a                	mv	a0,s2
    800037b4:	00001097          	auipc	ra,0x1
    800037b8:	006080e7          	jalr	6(ra) # 800047ba <log_write>
    800037bc:	854a                	mv	a0,s2
    800037be:	00000097          	auipc	ra,0x0
    800037c2:	d94080e7          	jalr	-620(ra) # 80003552 <brelse>
    800037c6:	85a6                	mv	a1,s1
    800037c8:	855e                	mv	a0,s7
    800037ca:	00000097          	auipc	ra,0x0
    800037ce:	c58080e7          	jalr	-936(ra) # 80003422 <bread>
    800037d2:	892a                	mv	s2,a0
    800037d4:	40000613          	li	a2,1024
    800037d8:	4581                	li	a1,0
    800037da:	05850513          	addi	a0,a0,88
    800037de:	ffffe097          	auipc	ra,0xffffe
    800037e2:	89c080e7          	jalr	-1892(ra) # 8000107a <memset>
    800037e6:	854a                	mv	a0,s2
    800037e8:	00001097          	auipc	ra,0x1
    800037ec:	fd2080e7          	jalr	-46(ra) # 800047ba <log_write>
    800037f0:	854a                	mv	a0,s2
    800037f2:	00000097          	auipc	ra,0x0
    800037f6:	d60080e7          	jalr	-672(ra) # 80003552 <brelse>
    800037fa:	8526                	mv	a0,s1
    800037fc:	60e6                	ld	ra,88(sp)
    800037fe:	6446                	ld	s0,80(sp)
    80003800:	64a6                	ld	s1,72(sp)
    80003802:	6906                	ld	s2,64(sp)
    80003804:	79e2                	ld	s3,56(sp)
    80003806:	7a42                	ld	s4,48(sp)
    80003808:	7aa2                	ld	s5,40(sp)
    8000380a:	7b02                	ld	s6,32(sp)
    8000380c:	6be2                	ld	s7,24(sp)
    8000380e:	6c42                	ld	s8,16(sp)
    80003810:	6ca2                	ld	s9,8(sp)
    80003812:	6125                	addi	sp,sp,96
    80003814:	8082                	ret

0000000080003816 <bmap>:
    80003816:	7179                	addi	sp,sp,-48
    80003818:	f406                	sd	ra,40(sp)
    8000381a:	f022                	sd	s0,32(sp)
    8000381c:	ec26                	sd	s1,24(sp)
    8000381e:	e84a                	sd	s2,16(sp)
    80003820:	e44e                	sd	s3,8(sp)
    80003822:	e052                	sd	s4,0(sp)
    80003824:	1800                	addi	s0,sp,48
    80003826:	892a                	mv	s2,a0
    80003828:	47ad                	li	a5,11
    8000382a:	04b7fe63          	bgeu	a5,a1,80003886 <bmap+0x70>
    8000382e:	ff45849b          	addiw	s1,a1,-12
    80003832:	0004871b          	sext.w	a4,s1
    80003836:	0ff00793          	li	a5,255
    8000383a:	0ae7e363          	bltu	a5,a4,800038e0 <bmap+0xca>
    8000383e:	08052583          	lw	a1,128(a0)
    80003842:	c5ad                	beqz	a1,800038ac <bmap+0x96>
    80003844:	00092503          	lw	a0,0(s2)
    80003848:	00000097          	auipc	ra,0x0
    8000384c:	bda080e7          	jalr	-1062(ra) # 80003422 <bread>
    80003850:	8a2a                	mv	s4,a0
    80003852:	05850793          	addi	a5,a0,88
    80003856:	02049593          	slli	a1,s1,0x20
    8000385a:	9181                	srli	a1,a1,0x20
    8000385c:	058a                	slli	a1,a1,0x2
    8000385e:	00b784b3          	add	s1,a5,a1
    80003862:	0004a983          	lw	s3,0(s1)
    80003866:	04098d63          	beqz	s3,800038c0 <bmap+0xaa>
    8000386a:	8552                	mv	a0,s4
    8000386c:	00000097          	auipc	ra,0x0
    80003870:	ce6080e7          	jalr	-794(ra) # 80003552 <brelse>
    80003874:	854e                	mv	a0,s3
    80003876:	70a2                	ld	ra,40(sp)
    80003878:	7402                	ld	s0,32(sp)
    8000387a:	64e2                	ld	s1,24(sp)
    8000387c:	6942                	ld	s2,16(sp)
    8000387e:	69a2                	ld	s3,8(sp)
    80003880:	6a02                	ld	s4,0(sp)
    80003882:	6145                	addi	sp,sp,48
    80003884:	8082                	ret
    80003886:	02059493          	slli	s1,a1,0x20
    8000388a:	9081                	srli	s1,s1,0x20
    8000388c:	048a                	slli	s1,s1,0x2
    8000388e:	94aa                	add	s1,s1,a0
    80003890:	0504a983          	lw	s3,80(s1)
    80003894:	fe0990e3          	bnez	s3,80003874 <bmap+0x5e>
    80003898:	4108                	lw	a0,0(a0)
    8000389a:	00000097          	auipc	ra,0x0
    8000389e:	e4a080e7          	jalr	-438(ra) # 800036e4 <balloc>
    800038a2:	0005099b          	sext.w	s3,a0
    800038a6:	0534a823          	sw	s3,80(s1)
    800038aa:	b7e9                	j	80003874 <bmap+0x5e>
    800038ac:	4108                	lw	a0,0(a0)
    800038ae:	00000097          	auipc	ra,0x0
    800038b2:	e36080e7          	jalr	-458(ra) # 800036e4 <balloc>
    800038b6:	0005059b          	sext.w	a1,a0
    800038ba:	08b92023          	sw	a1,128(s2)
    800038be:	b759                	j	80003844 <bmap+0x2e>
    800038c0:	00092503          	lw	a0,0(s2)
    800038c4:	00000097          	auipc	ra,0x0
    800038c8:	e20080e7          	jalr	-480(ra) # 800036e4 <balloc>
    800038cc:	0005099b          	sext.w	s3,a0
    800038d0:	0134a023          	sw	s3,0(s1)
    800038d4:	8552                	mv	a0,s4
    800038d6:	00001097          	auipc	ra,0x1
    800038da:	ee4080e7          	jalr	-284(ra) # 800047ba <log_write>
    800038de:	b771                	j	8000386a <bmap+0x54>
    800038e0:	00005517          	auipc	a0,0x5
    800038e4:	d4050513          	addi	a0,a0,-704 # 80008620 <syscalls+0x130>
    800038e8:	ffffd097          	auipc	ra,0xffffd
    800038ec:	d00080e7          	jalr	-768(ra) # 800005e8 <panic>

00000000800038f0 <iget>:
    800038f0:	7179                	addi	sp,sp,-48
    800038f2:	f406                	sd	ra,40(sp)
    800038f4:	f022                	sd	s0,32(sp)
    800038f6:	ec26                	sd	s1,24(sp)
    800038f8:	e84a                	sd	s2,16(sp)
    800038fa:	e44e                	sd	s3,8(sp)
    800038fc:	e052                	sd	s4,0(sp)
    800038fe:	1800                	addi	s0,sp,48
    80003900:	89aa                	mv	s3,a0
    80003902:	8a2e                	mv	s4,a1
    80003904:	0003c517          	auipc	a0,0x3c
    80003908:	6bc50513          	addi	a0,a0,1724 # 8003ffc0 <icache>
    8000390c:	ffffd097          	auipc	ra,0xffffd
    80003910:	672080e7          	jalr	1650(ra) # 80000f7e <acquire>
    80003914:	4901                	li	s2,0
    80003916:	0003c497          	auipc	s1,0x3c
    8000391a:	6c248493          	addi	s1,s1,1730 # 8003ffd8 <icache+0x18>
    8000391e:	0003e697          	auipc	a3,0x3e
    80003922:	14a68693          	addi	a3,a3,330 # 80041a68 <log>
    80003926:	a039                	j	80003934 <iget+0x44>
    80003928:	02090b63          	beqz	s2,8000395e <iget+0x6e>
    8000392c:	08848493          	addi	s1,s1,136
    80003930:	02d48a63          	beq	s1,a3,80003964 <iget+0x74>
    80003934:	449c                	lw	a5,8(s1)
    80003936:	fef059e3          	blez	a5,80003928 <iget+0x38>
    8000393a:	4098                	lw	a4,0(s1)
    8000393c:	ff3716e3          	bne	a4,s3,80003928 <iget+0x38>
    80003940:	40d8                	lw	a4,4(s1)
    80003942:	ff4713e3          	bne	a4,s4,80003928 <iget+0x38>
    80003946:	2785                	addiw	a5,a5,1
    80003948:	c49c                	sw	a5,8(s1)
    8000394a:	0003c517          	auipc	a0,0x3c
    8000394e:	67650513          	addi	a0,a0,1654 # 8003ffc0 <icache>
    80003952:	ffffd097          	auipc	ra,0xffffd
    80003956:	6e0080e7          	jalr	1760(ra) # 80001032 <release>
    8000395a:	8926                	mv	s2,s1
    8000395c:	a03d                	j	8000398a <iget+0x9a>
    8000395e:	f7f9                	bnez	a5,8000392c <iget+0x3c>
    80003960:	8926                	mv	s2,s1
    80003962:	b7e9                	j	8000392c <iget+0x3c>
    80003964:	02090c63          	beqz	s2,8000399c <iget+0xac>
    80003968:	01392023          	sw	s3,0(s2)
    8000396c:	01492223          	sw	s4,4(s2)
    80003970:	4785                	li	a5,1
    80003972:	00f92423          	sw	a5,8(s2)
    80003976:	04092023          	sw	zero,64(s2)
    8000397a:	0003c517          	auipc	a0,0x3c
    8000397e:	64650513          	addi	a0,a0,1606 # 8003ffc0 <icache>
    80003982:	ffffd097          	auipc	ra,0xffffd
    80003986:	6b0080e7          	jalr	1712(ra) # 80001032 <release>
    8000398a:	854a                	mv	a0,s2
    8000398c:	70a2                	ld	ra,40(sp)
    8000398e:	7402                	ld	s0,32(sp)
    80003990:	64e2                	ld	s1,24(sp)
    80003992:	6942                	ld	s2,16(sp)
    80003994:	69a2                	ld	s3,8(sp)
    80003996:	6a02                	ld	s4,0(sp)
    80003998:	6145                	addi	sp,sp,48
    8000399a:	8082                	ret
    8000399c:	00005517          	auipc	a0,0x5
    800039a0:	c9c50513          	addi	a0,a0,-868 # 80008638 <syscalls+0x148>
    800039a4:	ffffd097          	auipc	ra,0xffffd
    800039a8:	c44080e7          	jalr	-956(ra) # 800005e8 <panic>

00000000800039ac <fsinit>:
    800039ac:	7179                	addi	sp,sp,-48
    800039ae:	f406                	sd	ra,40(sp)
    800039b0:	f022                	sd	s0,32(sp)
    800039b2:	ec26                	sd	s1,24(sp)
    800039b4:	e84a                	sd	s2,16(sp)
    800039b6:	e44e                	sd	s3,8(sp)
    800039b8:	1800                	addi	s0,sp,48
    800039ba:	892a                	mv	s2,a0
    800039bc:	4585                	li	a1,1
    800039be:	00000097          	auipc	ra,0x0
    800039c2:	a64080e7          	jalr	-1436(ra) # 80003422 <bread>
    800039c6:	84aa                	mv	s1,a0
    800039c8:	0003c997          	auipc	s3,0x3c
    800039cc:	5d898993          	addi	s3,s3,1496 # 8003ffa0 <sb>
    800039d0:	02000613          	li	a2,32
    800039d4:	05850593          	addi	a1,a0,88
    800039d8:	854e                	mv	a0,s3
    800039da:	ffffd097          	auipc	ra,0xffffd
    800039de:	6fc080e7          	jalr	1788(ra) # 800010d6 <memmove>
    800039e2:	8526                	mv	a0,s1
    800039e4:	00000097          	auipc	ra,0x0
    800039e8:	b6e080e7          	jalr	-1170(ra) # 80003552 <brelse>
    800039ec:	0009a703          	lw	a4,0(s3)
    800039f0:	102037b7          	lui	a5,0x10203
    800039f4:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800039f8:	02f71263          	bne	a4,a5,80003a1c <fsinit+0x70>
    800039fc:	0003c597          	auipc	a1,0x3c
    80003a00:	5a458593          	addi	a1,a1,1444 # 8003ffa0 <sb>
    80003a04:	854a                	mv	a0,s2
    80003a06:	00001097          	auipc	ra,0x1
    80003a0a:	b3c080e7          	jalr	-1220(ra) # 80004542 <initlog>
    80003a0e:	70a2                	ld	ra,40(sp)
    80003a10:	7402                	ld	s0,32(sp)
    80003a12:	64e2                	ld	s1,24(sp)
    80003a14:	6942                	ld	s2,16(sp)
    80003a16:	69a2                	ld	s3,8(sp)
    80003a18:	6145                	addi	sp,sp,48
    80003a1a:	8082                	ret
    80003a1c:	00005517          	auipc	a0,0x5
    80003a20:	c2c50513          	addi	a0,a0,-980 # 80008648 <syscalls+0x158>
    80003a24:	ffffd097          	auipc	ra,0xffffd
    80003a28:	bc4080e7          	jalr	-1084(ra) # 800005e8 <panic>

0000000080003a2c <iinit>:
    80003a2c:	7179                	addi	sp,sp,-48
    80003a2e:	f406                	sd	ra,40(sp)
    80003a30:	f022                	sd	s0,32(sp)
    80003a32:	ec26                	sd	s1,24(sp)
    80003a34:	e84a                	sd	s2,16(sp)
    80003a36:	e44e                	sd	s3,8(sp)
    80003a38:	1800                	addi	s0,sp,48
    80003a3a:	00005597          	auipc	a1,0x5
    80003a3e:	c2658593          	addi	a1,a1,-986 # 80008660 <syscalls+0x170>
    80003a42:	0003c517          	auipc	a0,0x3c
    80003a46:	57e50513          	addi	a0,a0,1406 # 8003ffc0 <icache>
    80003a4a:	ffffd097          	auipc	ra,0xffffd
    80003a4e:	4a4080e7          	jalr	1188(ra) # 80000eee <initlock>
    80003a52:	0003c497          	auipc	s1,0x3c
    80003a56:	59648493          	addi	s1,s1,1430 # 8003ffe8 <icache+0x28>
    80003a5a:	0003e997          	auipc	s3,0x3e
    80003a5e:	01e98993          	addi	s3,s3,30 # 80041a78 <log+0x10>
    80003a62:	00005917          	auipc	s2,0x5
    80003a66:	c0690913          	addi	s2,s2,-1018 # 80008668 <syscalls+0x178>
    80003a6a:	85ca                	mv	a1,s2
    80003a6c:	8526                	mv	a0,s1
    80003a6e:	00001097          	auipc	ra,0x1
    80003a72:	e3a080e7          	jalr	-454(ra) # 800048a8 <initsleeplock>
    80003a76:	08848493          	addi	s1,s1,136
    80003a7a:	ff3498e3          	bne	s1,s3,80003a6a <iinit+0x3e>
    80003a7e:	70a2                	ld	ra,40(sp)
    80003a80:	7402                	ld	s0,32(sp)
    80003a82:	64e2                	ld	s1,24(sp)
    80003a84:	6942                	ld	s2,16(sp)
    80003a86:	69a2                	ld	s3,8(sp)
    80003a88:	6145                	addi	sp,sp,48
    80003a8a:	8082                	ret

0000000080003a8c <ialloc>:
    80003a8c:	715d                	addi	sp,sp,-80
    80003a8e:	e486                	sd	ra,72(sp)
    80003a90:	e0a2                	sd	s0,64(sp)
    80003a92:	fc26                	sd	s1,56(sp)
    80003a94:	f84a                	sd	s2,48(sp)
    80003a96:	f44e                	sd	s3,40(sp)
    80003a98:	f052                	sd	s4,32(sp)
    80003a9a:	ec56                	sd	s5,24(sp)
    80003a9c:	e85a                	sd	s6,16(sp)
    80003a9e:	e45e                	sd	s7,8(sp)
    80003aa0:	0880                	addi	s0,sp,80
    80003aa2:	0003c717          	auipc	a4,0x3c
    80003aa6:	50a72703          	lw	a4,1290(a4) # 8003ffac <sb+0xc>
    80003aaa:	4785                	li	a5,1
    80003aac:	04e7fa63          	bgeu	a5,a4,80003b00 <ialloc+0x74>
    80003ab0:	8aaa                	mv	s5,a0
    80003ab2:	8bae                	mv	s7,a1
    80003ab4:	4485                	li	s1,1
    80003ab6:	0003ca17          	auipc	s4,0x3c
    80003aba:	4eaa0a13          	addi	s4,s4,1258 # 8003ffa0 <sb>
    80003abe:	00048b1b          	sext.w	s6,s1
    80003ac2:	0044d793          	srli	a5,s1,0x4
    80003ac6:	018a2583          	lw	a1,24(s4)
    80003aca:	9dbd                	addw	a1,a1,a5
    80003acc:	8556                	mv	a0,s5
    80003ace:	00000097          	auipc	ra,0x0
    80003ad2:	954080e7          	jalr	-1708(ra) # 80003422 <bread>
    80003ad6:	892a                	mv	s2,a0
    80003ad8:	05850993          	addi	s3,a0,88
    80003adc:	00f4f793          	andi	a5,s1,15
    80003ae0:	079a                	slli	a5,a5,0x6
    80003ae2:	99be                	add	s3,s3,a5
    80003ae4:	00099783          	lh	a5,0(s3)
    80003ae8:	c785                	beqz	a5,80003b10 <ialloc+0x84>
    80003aea:	00000097          	auipc	ra,0x0
    80003aee:	a68080e7          	jalr	-1432(ra) # 80003552 <brelse>
    80003af2:	0485                	addi	s1,s1,1
    80003af4:	00ca2703          	lw	a4,12(s4)
    80003af8:	0004879b          	sext.w	a5,s1
    80003afc:	fce7e1e3          	bltu	a5,a4,80003abe <ialloc+0x32>
    80003b00:	00005517          	auipc	a0,0x5
    80003b04:	b7050513          	addi	a0,a0,-1168 # 80008670 <syscalls+0x180>
    80003b08:	ffffd097          	auipc	ra,0xffffd
    80003b0c:	ae0080e7          	jalr	-1312(ra) # 800005e8 <panic>
    80003b10:	04000613          	li	a2,64
    80003b14:	4581                	li	a1,0
    80003b16:	854e                	mv	a0,s3
    80003b18:	ffffd097          	auipc	ra,0xffffd
    80003b1c:	562080e7          	jalr	1378(ra) # 8000107a <memset>
    80003b20:	01799023          	sh	s7,0(s3)
    80003b24:	854a                	mv	a0,s2
    80003b26:	00001097          	auipc	ra,0x1
    80003b2a:	c94080e7          	jalr	-876(ra) # 800047ba <log_write>
    80003b2e:	854a                	mv	a0,s2
    80003b30:	00000097          	auipc	ra,0x0
    80003b34:	a22080e7          	jalr	-1502(ra) # 80003552 <brelse>
    80003b38:	85da                	mv	a1,s6
    80003b3a:	8556                	mv	a0,s5
    80003b3c:	00000097          	auipc	ra,0x0
    80003b40:	db4080e7          	jalr	-588(ra) # 800038f0 <iget>
    80003b44:	60a6                	ld	ra,72(sp)
    80003b46:	6406                	ld	s0,64(sp)
    80003b48:	74e2                	ld	s1,56(sp)
    80003b4a:	7942                	ld	s2,48(sp)
    80003b4c:	79a2                	ld	s3,40(sp)
    80003b4e:	7a02                	ld	s4,32(sp)
    80003b50:	6ae2                	ld	s5,24(sp)
    80003b52:	6b42                	ld	s6,16(sp)
    80003b54:	6ba2                	ld	s7,8(sp)
    80003b56:	6161                	addi	sp,sp,80
    80003b58:	8082                	ret

0000000080003b5a <iupdate>:
    80003b5a:	1101                	addi	sp,sp,-32
    80003b5c:	ec06                	sd	ra,24(sp)
    80003b5e:	e822                	sd	s0,16(sp)
    80003b60:	e426                	sd	s1,8(sp)
    80003b62:	e04a                	sd	s2,0(sp)
    80003b64:	1000                	addi	s0,sp,32
    80003b66:	84aa                	mv	s1,a0
    80003b68:	415c                	lw	a5,4(a0)
    80003b6a:	0047d79b          	srliw	a5,a5,0x4
    80003b6e:	0003c597          	auipc	a1,0x3c
    80003b72:	44a5a583          	lw	a1,1098(a1) # 8003ffb8 <sb+0x18>
    80003b76:	9dbd                	addw	a1,a1,a5
    80003b78:	4108                	lw	a0,0(a0)
    80003b7a:	00000097          	auipc	ra,0x0
    80003b7e:	8a8080e7          	jalr	-1880(ra) # 80003422 <bread>
    80003b82:	892a                	mv	s2,a0
    80003b84:	05850793          	addi	a5,a0,88
    80003b88:	40c8                	lw	a0,4(s1)
    80003b8a:	893d                	andi	a0,a0,15
    80003b8c:	051a                	slli	a0,a0,0x6
    80003b8e:	953e                	add	a0,a0,a5
    80003b90:	04449703          	lh	a4,68(s1)
    80003b94:	00e51023          	sh	a4,0(a0)
    80003b98:	04649703          	lh	a4,70(s1)
    80003b9c:	00e51123          	sh	a4,2(a0)
    80003ba0:	04849703          	lh	a4,72(s1)
    80003ba4:	00e51223          	sh	a4,4(a0)
    80003ba8:	04a49703          	lh	a4,74(s1)
    80003bac:	00e51323          	sh	a4,6(a0)
    80003bb0:	44f8                	lw	a4,76(s1)
    80003bb2:	c518                	sw	a4,8(a0)
    80003bb4:	03400613          	li	a2,52
    80003bb8:	05048593          	addi	a1,s1,80
    80003bbc:	0531                	addi	a0,a0,12
    80003bbe:	ffffd097          	auipc	ra,0xffffd
    80003bc2:	518080e7          	jalr	1304(ra) # 800010d6 <memmove>
    80003bc6:	854a                	mv	a0,s2
    80003bc8:	00001097          	auipc	ra,0x1
    80003bcc:	bf2080e7          	jalr	-1038(ra) # 800047ba <log_write>
    80003bd0:	854a                	mv	a0,s2
    80003bd2:	00000097          	auipc	ra,0x0
    80003bd6:	980080e7          	jalr	-1664(ra) # 80003552 <brelse>
    80003bda:	60e2                	ld	ra,24(sp)
    80003bdc:	6442                	ld	s0,16(sp)
    80003bde:	64a2                	ld	s1,8(sp)
    80003be0:	6902                	ld	s2,0(sp)
    80003be2:	6105                	addi	sp,sp,32
    80003be4:	8082                	ret

0000000080003be6 <idup>:
    80003be6:	1101                	addi	sp,sp,-32
    80003be8:	ec06                	sd	ra,24(sp)
    80003bea:	e822                	sd	s0,16(sp)
    80003bec:	e426                	sd	s1,8(sp)
    80003bee:	1000                	addi	s0,sp,32
    80003bf0:	84aa                	mv	s1,a0
    80003bf2:	0003c517          	auipc	a0,0x3c
    80003bf6:	3ce50513          	addi	a0,a0,974 # 8003ffc0 <icache>
    80003bfa:	ffffd097          	auipc	ra,0xffffd
    80003bfe:	384080e7          	jalr	900(ra) # 80000f7e <acquire>
    80003c02:	449c                	lw	a5,8(s1)
    80003c04:	2785                	addiw	a5,a5,1
    80003c06:	c49c                	sw	a5,8(s1)
    80003c08:	0003c517          	auipc	a0,0x3c
    80003c0c:	3b850513          	addi	a0,a0,952 # 8003ffc0 <icache>
    80003c10:	ffffd097          	auipc	ra,0xffffd
    80003c14:	422080e7          	jalr	1058(ra) # 80001032 <release>
    80003c18:	8526                	mv	a0,s1
    80003c1a:	60e2                	ld	ra,24(sp)
    80003c1c:	6442                	ld	s0,16(sp)
    80003c1e:	64a2                	ld	s1,8(sp)
    80003c20:	6105                	addi	sp,sp,32
    80003c22:	8082                	ret

0000000080003c24 <ilock>:
    80003c24:	1101                	addi	sp,sp,-32
    80003c26:	ec06                	sd	ra,24(sp)
    80003c28:	e822                	sd	s0,16(sp)
    80003c2a:	e426                	sd	s1,8(sp)
    80003c2c:	e04a                	sd	s2,0(sp)
    80003c2e:	1000                	addi	s0,sp,32
    80003c30:	c115                	beqz	a0,80003c54 <ilock+0x30>
    80003c32:	84aa                	mv	s1,a0
    80003c34:	451c                	lw	a5,8(a0)
    80003c36:	00f05f63          	blez	a5,80003c54 <ilock+0x30>
    80003c3a:	0541                	addi	a0,a0,16
    80003c3c:	00001097          	auipc	ra,0x1
    80003c40:	ca6080e7          	jalr	-858(ra) # 800048e2 <acquiresleep>
    80003c44:	40bc                	lw	a5,64(s1)
    80003c46:	cf99                	beqz	a5,80003c64 <ilock+0x40>
    80003c48:	60e2                	ld	ra,24(sp)
    80003c4a:	6442                	ld	s0,16(sp)
    80003c4c:	64a2                	ld	s1,8(sp)
    80003c4e:	6902                	ld	s2,0(sp)
    80003c50:	6105                	addi	sp,sp,32
    80003c52:	8082                	ret
    80003c54:	00005517          	auipc	a0,0x5
    80003c58:	a3450513          	addi	a0,a0,-1484 # 80008688 <syscalls+0x198>
    80003c5c:	ffffd097          	auipc	ra,0xffffd
    80003c60:	98c080e7          	jalr	-1652(ra) # 800005e8 <panic>
    80003c64:	40dc                	lw	a5,4(s1)
    80003c66:	0047d79b          	srliw	a5,a5,0x4
    80003c6a:	0003c597          	auipc	a1,0x3c
    80003c6e:	34e5a583          	lw	a1,846(a1) # 8003ffb8 <sb+0x18>
    80003c72:	9dbd                	addw	a1,a1,a5
    80003c74:	4088                	lw	a0,0(s1)
    80003c76:	fffff097          	auipc	ra,0xfffff
    80003c7a:	7ac080e7          	jalr	1964(ra) # 80003422 <bread>
    80003c7e:	892a                	mv	s2,a0
    80003c80:	05850593          	addi	a1,a0,88
    80003c84:	40dc                	lw	a5,4(s1)
    80003c86:	8bbd                	andi	a5,a5,15
    80003c88:	079a                	slli	a5,a5,0x6
    80003c8a:	95be                	add	a1,a1,a5
    80003c8c:	00059783          	lh	a5,0(a1)
    80003c90:	04f49223          	sh	a5,68(s1)
    80003c94:	00259783          	lh	a5,2(a1)
    80003c98:	04f49323          	sh	a5,70(s1)
    80003c9c:	00459783          	lh	a5,4(a1)
    80003ca0:	04f49423          	sh	a5,72(s1)
    80003ca4:	00659783          	lh	a5,6(a1)
    80003ca8:	04f49523          	sh	a5,74(s1)
    80003cac:	459c                	lw	a5,8(a1)
    80003cae:	c4fc                	sw	a5,76(s1)
    80003cb0:	03400613          	li	a2,52
    80003cb4:	05b1                	addi	a1,a1,12
    80003cb6:	05048513          	addi	a0,s1,80
    80003cba:	ffffd097          	auipc	ra,0xffffd
    80003cbe:	41c080e7          	jalr	1052(ra) # 800010d6 <memmove>
    80003cc2:	854a                	mv	a0,s2
    80003cc4:	00000097          	auipc	ra,0x0
    80003cc8:	88e080e7          	jalr	-1906(ra) # 80003552 <brelse>
    80003ccc:	4785                	li	a5,1
    80003cce:	c0bc                	sw	a5,64(s1)
    80003cd0:	04449783          	lh	a5,68(s1)
    80003cd4:	fbb5                	bnez	a5,80003c48 <ilock+0x24>
    80003cd6:	00005517          	auipc	a0,0x5
    80003cda:	9ba50513          	addi	a0,a0,-1606 # 80008690 <syscalls+0x1a0>
    80003cde:	ffffd097          	auipc	ra,0xffffd
    80003ce2:	90a080e7          	jalr	-1782(ra) # 800005e8 <panic>

0000000080003ce6 <iunlock>:
    80003ce6:	1101                	addi	sp,sp,-32
    80003ce8:	ec06                	sd	ra,24(sp)
    80003cea:	e822                	sd	s0,16(sp)
    80003cec:	e426                	sd	s1,8(sp)
    80003cee:	e04a                	sd	s2,0(sp)
    80003cf0:	1000                	addi	s0,sp,32
    80003cf2:	c905                	beqz	a0,80003d22 <iunlock+0x3c>
    80003cf4:	84aa                	mv	s1,a0
    80003cf6:	01050913          	addi	s2,a0,16
    80003cfa:	854a                	mv	a0,s2
    80003cfc:	00001097          	auipc	ra,0x1
    80003d00:	c80080e7          	jalr	-896(ra) # 8000497c <holdingsleep>
    80003d04:	cd19                	beqz	a0,80003d22 <iunlock+0x3c>
    80003d06:	449c                	lw	a5,8(s1)
    80003d08:	00f05d63          	blez	a5,80003d22 <iunlock+0x3c>
    80003d0c:	854a                	mv	a0,s2
    80003d0e:	00001097          	auipc	ra,0x1
    80003d12:	c2a080e7          	jalr	-982(ra) # 80004938 <releasesleep>
    80003d16:	60e2                	ld	ra,24(sp)
    80003d18:	6442                	ld	s0,16(sp)
    80003d1a:	64a2                	ld	s1,8(sp)
    80003d1c:	6902                	ld	s2,0(sp)
    80003d1e:	6105                	addi	sp,sp,32
    80003d20:	8082                	ret
    80003d22:	00005517          	auipc	a0,0x5
    80003d26:	97e50513          	addi	a0,a0,-1666 # 800086a0 <syscalls+0x1b0>
    80003d2a:	ffffd097          	auipc	ra,0xffffd
    80003d2e:	8be080e7          	jalr	-1858(ra) # 800005e8 <panic>

0000000080003d32 <itrunc>:
    80003d32:	7179                	addi	sp,sp,-48
    80003d34:	f406                	sd	ra,40(sp)
    80003d36:	f022                	sd	s0,32(sp)
    80003d38:	ec26                	sd	s1,24(sp)
    80003d3a:	e84a                	sd	s2,16(sp)
    80003d3c:	e44e                	sd	s3,8(sp)
    80003d3e:	e052                	sd	s4,0(sp)
    80003d40:	1800                	addi	s0,sp,48
    80003d42:	89aa                	mv	s3,a0
    80003d44:	05050493          	addi	s1,a0,80
    80003d48:	08050913          	addi	s2,a0,128
    80003d4c:	a021                	j	80003d54 <itrunc+0x22>
    80003d4e:	0491                	addi	s1,s1,4
    80003d50:	01248d63          	beq	s1,s2,80003d6a <itrunc+0x38>
    80003d54:	408c                	lw	a1,0(s1)
    80003d56:	dde5                	beqz	a1,80003d4e <itrunc+0x1c>
    80003d58:	0009a503          	lw	a0,0(s3)
    80003d5c:	00000097          	auipc	ra,0x0
    80003d60:	90c080e7          	jalr	-1780(ra) # 80003668 <bfree>
    80003d64:	0004a023          	sw	zero,0(s1)
    80003d68:	b7dd                	j	80003d4e <itrunc+0x1c>
    80003d6a:	0809a583          	lw	a1,128(s3)
    80003d6e:	e185                	bnez	a1,80003d8e <itrunc+0x5c>
    80003d70:	0409a623          	sw	zero,76(s3)
    80003d74:	854e                	mv	a0,s3
    80003d76:	00000097          	auipc	ra,0x0
    80003d7a:	de4080e7          	jalr	-540(ra) # 80003b5a <iupdate>
    80003d7e:	70a2                	ld	ra,40(sp)
    80003d80:	7402                	ld	s0,32(sp)
    80003d82:	64e2                	ld	s1,24(sp)
    80003d84:	6942                	ld	s2,16(sp)
    80003d86:	69a2                	ld	s3,8(sp)
    80003d88:	6a02                	ld	s4,0(sp)
    80003d8a:	6145                	addi	sp,sp,48
    80003d8c:	8082                	ret
    80003d8e:	0009a503          	lw	a0,0(s3)
    80003d92:	fffff097          	auipc	ra,0xfffff
    80003d96:	690080e7          	jalr	1680(ra) # 80003422 <bread>
    80003d9a:	8a2a                	mv	s4,a0
    80003d9c:	05850493          	addi	s1,a0,88
    80003da0:	45850913          	addi	s2,a0,1112
    80003da4:	a021                	j	80003dac <itrunc+0x7a>
    80003da6:	0491                	addi	s1,s1,4
    80003da8:	01248b63          	beq	s1,s2,80003dbe <itrunc+0x8c>
    80003dac:	408c                	lw	a1,0(s1)
    80003dae:	dde5                	beqz	a1,80003da6 <itrunc+0x74>
    80003db0:	0009a503          	lw	a0,0(s3)
    80003db4:	00000097          	auipc	ra,0x0
    80003db8:	8b4080e7          	jalr	-1868(ra) # 80003668 <bfree>
    80003dbc:	b7ed                	j	80003da6 <itrunc+0x74>
    80003dbe:	8552                	mv	a0,s4
    80003dc0:	fffff097          	auipc	ra,0xfffff
    80003dc4:	792080e7          	jalr	1938(ra) # 80003552 <brelse>
    80003dc8:	0809a583          	lw	a1,128(s3)
    80003dcc:	0009a503          	lw	a0,0(s3)
    80003dd0:	00000097          	auipc	ra,0x0
    80003dd4:	898080e7          	jalr	-1896(ra) # 80003668 <bfree>
    80003dd8:	0809a023          	sw	zero,128(s3)
    80003ddc:	bf51                	j	80003d70 <itrunc+0x3e>

0000000080003dde <iput>:
    80003dde:	1101                	addi	sp,sp,-32
    80003de0:	ec06                	sd	ra,24(sp)
    80003de2:	e822                	sd	s0,16(sp)
    80003de4:	e426                	sd	s1,8(sp)
    80003de6:	e04a                	sd	s2,0(sp)
    80003de8:	1000                	addi	s0,sp,32
    80003dea:	84aa                	mv	s1,a0
    80003dec:	0003c517          	auipc	a0,0x3c
    80003df0:	1d450513          	addi	a0,a0,468 # 8003ffc0 <icache>
    80003df4:	ffffd097          	auipc	ra,0xffffd
    80003df8:	18a080e7          	jalr	394(ra) # 80000f7e <acquire>
    80003dfc:	4498                	lw	a4,8(s1)
    80003dfe:	4785                	li	a5,1
    80003e00:	02f70363          	beq	a4,a5,80003e26 <iput+0x48>
    80003e04:	449c                	lw	a5,8(s1)
    80003e06:	37fd                	addiw	a5,a5,-1
    80003e08:	c49c                	sw	a5,8(s1)
    80003e0a:	0003c517          	auipc	a0,0x3c
    80003e0e:	1b650513          	addi	a0,a0,438 # 8003ffc0 <icache>
    80003e12:	ffffd097          	auipc	ra,0xffffd
    80003e16:	220080e7          	jalr	544(ra) # 80001032 <release>
    80003e1a:	60e2                	ld	ra,24(sp)
    80003e1c:	6442                	ld	s0,16(sp)
    80003e1e:	64a2                	ld	s1,8(sp)
    80003e20:	6902                	ld	s2,0(sp)
    80003e22:	6105                	addi	sp,sp,32
    80003e24:	8082                	ret
    80003e26:	40bc                	lw	a5,64(s1)
    80003e28:	dff1                	beqz	a5,80003e04 <iput+0x26>
    80003e2a:	04a49783          	lh	a5,74(s1)
    80003e2e:	fbf9                	bnez	a5,80003e04 <iput+0x26>
    80003e30:	01048913          	addi	s2,s1,16
    80003e34:	854a                	mv	a0,s2
    80003e36:	00001097          	auipc	ra,0x1
    80003e3a:	aac080e7          	jalr	-1364(ra) # 800048e2 <acquiresleep>
    80003e3e:	0003c517          	auipc	a0,0x3c
    80003e42:	18250513          	addi	a0,a0,386 # 8003ffc0 <icache>
    80003e46:	ffffd097          	auipc	ra,0xffffd
    80003e4a:	1ec080e7          	jalr	492(ra) # 80001032 <release>
    80003e4e:	8526                	mv	a0,s1
    80003e50:	00000097          	auipc	ra,0x0
    80003e54:	ee2080e7          	jalr	-286(ra) # 80003d32 <itrunc>
    80003e58:	04049223          	sh	zero,68(s1)
    80003e5c:	8526                	mv	a0,s1
    80003e5e:	00000097          	auipc	ra,0x0
    80003e62:	cfc080e7          	jalr	-772(ra) # 80003b5a <iupdate>
    80003e66:	0404a023          	sw	zero,64(s1)
    80003e6a:	854a                	mv	a0,s2
    80003e6c:	00001097          	auipc	ra,0x1
    80003e70:	acc080e7          	jalr	-1332(ra) # 80004938 <releasesleep>
    80003e74:	0003c517          	auipc	a0,0x3c
    80003e78:	14c50513          	addi	a0,a0,332 # 8003ffc0 <icache>
    80003e7c:	ffffd097          	auipc	ra,0xffffd
    80003e80:	102080e7          	jalr	258(ra) # 80000f7e <acquire>
    80003e84:	b741                	j	80003e04 <iput+0x26>

0000000080003e86 <iunlockput>:
    80003e86:	1101                	addi	sp,sp,-32
    80003e88:	ec06                	sd	ra,24(sp)
    80003e8a:	e822                	sd	s0,16(sp)
    80003e8c:	e426                	sd	s1,8(sp)
    80003e8e:	1000                	addi	s0,sp,32
    80003e90:	84aa                	mv	s1,a0
    80003e92:	00000097          	auipc	ra,0x0
    80003e96:	e54080e7          	jalr	-428(ra) # 80003ce6 <iunlock>
    80003e9a:	8526                	mv	a0,s1
    80003e9c:	00000097          	auipc	ra,0x0
    80003ea0:	f42080e7          	jalr	-190(ra) # 80003dde <iput>
    80003ea4:	60e2                	ld	ra,24(sp)
    80003ea6:	6442                	ld	s0,16(sp)
    80003ea8:	64a2                	ld	s1,8(sp)
    80003eaa:	6105                	addi	sp,sp,32
    80003eac:	8082                	ret

0000000080003eae <stati>:
    80003eae:	1141                	addi	sp,sp,-16
    80003eb0:	e422                	sd	s0,8(sp)
    80003eb2:	0800                	addi	s0,sp,16
    80003eb4:	411c                	lw	a5,0(a0)
    80003eb6:	c19c                	sw	a5,0(a1)
    80003eb8:	415c                	lw	a5,4(a0)
    80003eba:	c1dc                	sw	a5,4(a1)
    80003ebc:	04451783          	lh	a5,68(a0)
    80003ec0:	00f59423          	sh	a5,8(a1)
    80003ec4:	04a51783          	lh	a5,74(a0)
    80003ec8:	00f59523          	sh	a5,10(a1)
    80003ecc:	04c56783          	lwu	a5,76(a0)
    80003ed0:	e99c                	sd	a5,16(a1)
    80003ed2:	6422                	ld	s0,8(sp)
    80003ed4:	0141                	addi	sp,sp,16
    80003ed6:	8082                	ret

0000000080003ed8 <readi>:
    80003ed8:	457c                	lw	a5,76(a0)
    80003eda:	0ed7e963          	bltu	a5,a3,80003fcc <readi+0xf4>
    80003ede:	7159                	addi	sp,sp,-112
    80003ee0:	f486                	sd	ra,104(sp)
    80003ee2:	f0a2                	sd	s0,96(sp)
    80003ee4:	eca6                	sd	s1,88(sp)
    80003ee6:	e8ca                	sd	s2,80(sp)
    80003ee8:	e4ce                	sd	s3,72(sp)
    80003eea:	e0d2                	sd	s4,64(sp)
    80003eec:	fc56                	sd	s5,56(sp)
    80003eee:	f85a                	sd	s6,48(sp)
    80003ef0:	f45e                	sd	s7,40(sp)
    80003ef2:	f062                	sd	s8,32(sp)
    80003ef4:	ec66                	sd	s9,24(sp)
    80003ef6:	e86a                	sd	s10,16(sp)
    80003ef8:	e46e                	sd	s11,8(sp)
    80003efa:	1880                	addi	s0,sp,112
    80003efc:	8baa                	mv	s7,a0
    80003efe:	8c2e                	mv	s8,a1
    80003f00:	8ab2                	mv	s5,a2
    80003f02:	84b6                	mv	s1,a3
    80003f04:	8b3a                	mv	s6,a4
    80003f06:	9f35                	addw	a4,a4,a3
    80003f08:	4501                	li	a0,0
    80003f0a:	0ad76063          	bltu	a4,a3,80003faa <readi+0xd2>
    80003f0e:	00e7f463          	bgeu	a5,a4,80003f16 <readi+0x3e>
    80003f12:	40d78b3b          	subw	s6,a5,a3
    80003f16:	0a0b0963          	beqz	s6,80003fc8 <readi+0xf0>
    80003f1a:	4981                	li	s3,0
    80003f1c:	40000d13          	li	s10,1024
    80003f20:	5cfd                	li	s9,-1
    80003f22:	a82d                	j	80003f5c <readi+0x84>
    80003f24:	020a1d93          	slli	s11,s4,0x20
    80003f28:	020ddd93          	srli	s11,s11,0x20
    80003f2c:	05890793          	addi	a5,s2,88
    80003f30:	86ee                	mv	a3,s11
    80003f32:	963e                	add	a2,a2,a5
    80003f34:	85d6                	mv	a1,s5
    80003f36:	8562                	mv	a0,s8
    80003f38:	fffff097          	auipc	ra,0xfffff
    80003f3c:	a34080e7          	jalr	-1484(ra) # 8000296c <either_copyout>
    80003f40:	05950d63          	beq	a0,s9,80003f9a <readi+0xc2>
    80003f44:	854a                	mv	a0,s2
    80003f46:	fffff097          	auipc	ra,0xfffff
    80003f4a:	60c080e7          	jalr	1548(ra) # 80003552 <brelse>
    80003f4e:	013a09bb          	addw	s3,s4,s3
    80003f52:	009a04bb          	addw	s1,s4,s1
    80003f56:	9aee                	add	s5,s5,s11
    80003f58:	0569f763          	bgeu	s3,s6,80003fa6 <readi+0xce>
    80003f5c:	000ba903          	lw	s2,0(s7)
    80003f60:	00a4d59b          	srliw	a1,s1,0xa
    80003f64:	855e                	mv	a0,s7
    80003f66:	00000097          	auipc	ra,0x0
    80003f6a:	8b0080e7          	jalr	-1872(ra) # 80003816 <bmap>
    80003f6e:	0005059b          	sext.w	a1,a0
    80003f72:	854a                	mv	a0,s2
    80003f74:	fffff097          	auipc	ra,0xfffff
    80003f78:	4ae080e7          	jalr	1198(ra) # 80003422 <bread>
    80003f7c:	892a                	mv	s2,a0
    80003f7e:	3ff4f613          	andi	a2,s1,1023
    80003f82:	40cd07bb          	subw	a5,s10,a2
    80003f86:	413b073b          	subw	a4,s6,s3
    80003f8a:	8a3e                	mv	s4,a5
    80003f8c:	2781                	sext.w	a5,a5
    80003f8e:	0007069b          	sext.w	a3,a4
    80003f92:	f8f6f9e3          	bgeu	a3,a5,80003f24 <readi+0x4c>
    80003f96:	8a3a                	mv	s4,a4
    80003f98:	b771                	j	80003f24 <readi+0x4c>
    80003f9a:	854a                	mv	a0,s2
    80003f9c:	fffff097          	auipc	ra,0xfffff
    80003fa0:	5b6080e7          	jalr	1462(ra) # 80003552 <brelse>
    80003fa4:	59fd                	li	s3,-1
    80003fa6:	0009851b          	sext.w	a0,s3
    80003faa:	70a6                	ld	ra,104(sp)
    80003fac:	7406                	ld	s0,96(sp)
    80003fae:	64e6                	ld	s1,88(sp)
    80003fb0:	6946                	ld	s2,80(sp)
    80003fb2:	69a6                	ld	s3,72(sp)
    80003fb4:	6a06                	ld	s4,64(sp)
    80003fb6:	7ae2                	ld	s5,56(sp)
    80003fb8:	7b42                	ld	s6,48(sp)
    80003fba:	7ba2                	ld	s7,40(sp)
    80003fbc:	7c02                	ld	s8,32(sp)
    80003fbe:	6ce2                	ld	s9,24(sp)
    80003fc0:	6d42                	ld	s10,16(sp)
    80003fc2:	6da2                	ld	s11,8(sp)
    80003fc4:	6165                	addi	sp,sp,112
    80003fc6:	8082                	ret
    80003fc8:	89da                	mv	s3,s6
    80003fca:	bff1                	j	80003fa6 <readi+0xce>
    80003fcc:	4501                	li	a0,0
    80003fce:	8082                	ret

0000000080003fd0 <writei>:
    80003fd0:	457c                	lw	a5,76(a0)
    80003fd2:	10d7e763          	bltu	a5,a3,800040e0 <writei+0x110>
    80003fd6:	7159                	addi	sp,sp,-112
    80003fd8:	f486                	sd	ra,104(sp)
    80003fda:	f0a2                	sd	s0,96(sp)
    80003fdc:	eca6                	sd	s1,88(sp)
    80003fde:	e8ca                	sd	s2,80(sp)
    80003fe0:	e4ce                	sd	s3,72(sp)
    80003fe2:	e0d2                	sd	s4,64(sp)
    80003fe4:	fc56                	sd	s5,56(sp)
    80003fe6:	f85a                	sd	s6,48(sp)
    80003fe8:	f45e                	sd	s7,40(sp)
    80003fea:	f062                	sd	s8,32(sp)
    80003fec:	ec66                	sd	s9,24(sp)
    80003fee:	e86a                	sd	s10,16(sp)
    80003ff0:	e46e                	sd	s11,8(sp)
    80003ff2:	1880                	addi	s0,sp,112
    80003ff4:	8baa                	mv	s7,a0
    80003ff6:	8c2e                	mv	s8,a1
    80003ff8:	8ab2                	mv	s5,a2
    80003ffa:	8936                	mv	s2,a3
    80003ffc:	8b3a                	mv	s6,a4
    80003ffe:	00e687bb          	addw	a5,a3,a4
    80004002:	0ed7e163          	bltu	a5,a3,800040e4 <writei+0x114>
    80004006:	00043737          	lui	a4,0x43
    8000400a:	0cf76f63          	bltu	a4,a5,800040e8 <writei+0x118>
    8000400e:	0a0b0863          	beqz	s6,800040be <writei+0xee>
    80004012:	4a01                	li	s4,0
    80004014:	40000d13          	li	s10,1024
    80004018:	5cfd                	li	s9,-1
    8000401a:	a091                	j	8000405e <writei+0x8e>
    8000401c:	02099d93          	slli	s11,s3,0x20
    80004020:	020ddd93          	srli	s11,s11,0x20
    80004024:	05848793          	addi	a5,s1,88
    80004028:	86ee                	mv	a3,s11
    8000402a:	8656                	mv	a2,s5
    8000402c:	85e2                	mv	a1,s8
    8000402e:	953e                	add	a0,a0,a5
    80004030:	fffff097          	auipc	ra,0xfffff
    80004034:	992080e7          	jalr	-1646(ra) # 800029c2 <either_copyin>
    80004038:	07950263          	beq	a0,s9,8000409c <writei+0xcc>
    8000403c:	8526                	mv	a0,s1
    8000403e:	00000097          	auipc	ra,0x0
    80004042:	77c080e7          	jalr	1916(ra) # 800047ba <log_write>
    80004046:	8526                	mv	a0,s1
    80004048:	fffff097          	auipc	ra,0xfffff
    8000404c:	50a080e7          	jalr	1290(ra) # 80003552 <brelse>
    80004050:	01498a3b          	addw	s4,s3,s4
    80004054:	0129893b          	addw	s2,s3,s2
    80004058:	9aee                	add	s5,s5,s11
    8000405a:	056a7763          	bgeu	s4,s6,800040a8 <writei+0xd8>
    8000405e:	000ba483          	lw	s1,0(s7)
    80004062:	00a9559b          	srliw	a1,s2,0xa
    80004066:	855e                	mv	a0,s7
    80004068:	fffff097          	auipc	ra,0xfffff
    8000406c:	7ae080e7          	jalr	1966(ra) # 80003816 <bmap>
    80004070:	0005059b          	sext.w	a1,a0
    80004074:	8526                	mv	a0,s1
    80004076:	fffff097          	auipc	ra,0xfffff
    8000407a:	3ac080e7          	jalr	940(ra) # 80003422 <bread>
    8000407e:	84aa                	mv	s1,a0
    80004080:	3ff97513          	andi	a0,s2,1023
    80004084:	40ad07bb          	subw	a5,s10,a0
    80004088:	414b073b          	subw	a4,s6,s4
    8000408c:	89be                	mv	s3,a5
    8000408e:	2781                	sext.w	a5,a5
    80004090:	0007069b          	sext.w	a3,a4
    80004094:	f8f6f4e3          	bgeu	a3,a5,8000401c <writei+0x4c>
    80004098:	89ba                	mv	s3,a4
    8000409a:	b749                	j	8000401c <writei+0x4c>
    8000409c:	8526                	mv	a0,s1
    8000409e:	fffff097          	auipc	ra,0xfffff
    800040a2:	4b4080e7          	jalr	1204(ra) # 80003552 <brelse>
    800040a6:	5b7d                	li	s6,-1
    800040a8:	04cba783          	lw	a5,76(s7)
    800040ac:	0127f463          	bgeu	a5,s2,800040b4 <writei+0xe4>
    800040b0:	052ba623          	sw	s2,76(s7)
    800040b4:	855e                	mv	a0,s7
    800040b6:	00000097          	auipc	ra,0x0
    800040ba:	aa4080e7          	jalr	-1372(ra) # 80003b5a <iupdate>
    800040be:	000b051b          	sext.w	a0,s6
    800040c2:	70a6                	ld	ra,104(sp)
    800040c4:	7406                	ld	s0,96(sp)
    800040c6:	64e6                	ld	s1,88(sp)
    800040c8:	6946                	ld	s2,80(sp)
    800040ca:	69a6                	ld	s3,72(sp)
    800040cc:	6a06                	ld	s4,64(sp)
    800040ce:	7ae2                	ld	s5,56(sp)
    800040d0:	7b42                	ld	s6,48(sp)
    800040d2:	7ba2                	ld	s7,40(sp)
    800040d4:	7c02                	ld	s8,32(sp)
    800040d6:	6ce2                	ld	s9,24(sp)
    800040d8:	6d42                	ld	s10,16(sp)
    800040da:	6da2                	ld	s11,8(sp)
    800040dc:	6165                	addi	sp,sp,112
    800040de:	8082                	ret
    800040e0:	557d                	li	a0,-1
    800040e2:	8082                	ret
    800040e4:	557d                	li	a0,-1
    800040e6:	bff1                	j	800040c2 <writei+0xf2>
    800040e8:	557d                	li	a0,-1
    800040ea:	bfe1                	j	800040c2 <writei+0xf2>

00000000800040ec <namecmp>:
    800040ec:	1141                	addi	sp,sp,-16
    800040ee:	e406                	sd	ra,8(sp)
    800040f0:	e022                	sd	s0,0(sp)
    800040f2:	0800                	addi	s0,sp,16
    800040f4:	4639                	li	a2,14
    800040f6:	ffffd097          	auipc	ra,0xffffd
    800040fa:	05c080e7          	jalr	92(ra) # 80001152 <strncmp>
    800040fe:	60a2                	ld	ra,8(sp)
    80004100:	6402                	ld	s0,0(sp)
    80004102:	0141                	addi	sp,sp,16
    80004104:	8082                	ret

0000000080004106 <dirlookup>:
    80004106:	7139                	addi	sp,sp,-64
    80004108:	fc06                	sd	ra,56(sp)
    8000410a:	f822                	sd	s0,48(sp)
    8000410c:	f426                	sd	s1,40(sp)
    8000410e:	f04a                	sd	s2,32(sp)
    80004110:	ec4e                	sd	s3,24(sp)
    80004112:	e852                	sd	s4,16(sp)
    80004114:	0080                	addi	s0,sp,64
    80004116:	04451703          	lh	a4,68(a0)
    8000411a:	4785                	li	a5,1
    8000411c:	00f71a63          	bne	a4,a5,80004130 <dirlookup+0x2a>
    80004120:	892a                	mv	s2,a0
    80004122:	89ae                	mv	s3,a1
    80004124:	8a32                	mv	s4,a2
    80004126:	457c                	lw	a5,76(a0)
    80004128:	4481                	li	s1,0
    8000412a:	4501                	li	a0,0
    8000412c:	e79d                	bnez	a5,8000415a <dirlookup+0x54>
    8000412e:	a8a5                	j	800041a6 <dirlookup+0xa0>
    80004130:	00004517          	auipc	a0,0x4
    80004134:	57850513          	addi	a0,a0,1400 # 800086a8 <syscalls+0x1b8>
    80004138:	ffffc097          	auipc	ra,0xffffc
    8000413c:	4b0080e7          	jalr	1200(ra) # 800005e8 <panic>
    80004140:	00004517          	auipc	a0,0x4
    80004144:	58050513          	addi	a0,a0,1408 # 800086c0 <syscalls+0x1d0>
    80004148:	ffffc097          	auipc	ra,0xffffc
    8000414c:	4a0080e7          	jalr	1184(ra) # 800005e8 <panic>
    80004150:	24c1                	addiw	s1,s1,16
    80004152:	04c92783          	lw	a5,76(s2)
    80004156:	04f4f763          	bgeu	s1,a5,800041a4 <dirlookup+0x9e>
    8000415a:	4741                	li	a4,16
    8000415c:	86a6                	mv	a3,s1
    8000415e:	fc040613          	addi	a2,s0,-64
    80004162:	4581                	li	a1,0
    80004164:	854a                	mv	a0,s2
    80004166:	00000097          	auipc	ra,0x0
    8000416a:	d72080e7          	jalr	-654(ra) # 80003ed8 <readi>
    8000416e:	47c1                	li	a5,16
    80004170:	fcf518e3          	bne	a0,a5,80004140 <dirlookup+0x3a>
    80004174:	fc045783          	lhu	a5,-64(s0)
    80004178:	dfe1                	beqz	a5,80004150 <dirlookup+0x4a>
    8000417a:	fc240593          	addi	a1,s0,-62
    8000417e:	854e                	mv	a0,s3
    80004180:	00000097          	auipc	ra,0x0
    80004184:	f6c080e7          	jalr	-148(ra) # 800040ec <namecmp>
    80004188:	f561                	bnez	a0,80004150 <dirlookup+0x4a>
    8000418a:	000a0463          	beqz	s4,80004192 <dirlookup+0x8c>
    8000418e:	009a2023          	sw	s1,0(s4)
    80004192:	fc045583          	lhu	a1,-64(s0)
    80004196:	00092503          	lw	a0,0(s2)
    8000419a:	fffff097          	auipc	ra,0xfffff
    8000419e:	756080e7          	jalr	1878(ra) # 800038f0 <iget>
    800041a2:	a011                	j	800041a6 <dirlookup+0xa0>
    800041a4:	4501                	li	a0,0
    800041a6:	70e2                	ld	ra,56(sp)
    800041a8:	7442                	ld	s0,48(sp)
    800041aa:	74a2                	ld	s1,40(sp)
    800041ac:	7902                	ld	s2,32(sp)
    800041ae:	69e2                	ld	s3,24(sp)
    800041b0:	6a42                	ld	s4,16(sp)
    800041b2:	6121                	addi	sp,sp,64
    800041b4:	8082                	ret

00000000800041b6 <namex>:
    800041b6:	711d                	addi	sp,sp,-96
    800041b8:	ec86                	sd	ra,88(sp)
    800041ba:	e8a2                	sd	s0,80(sp)
    800041bc:	e4a6                	sd	s1,72(sp)
    800041be:	e0ca                	sd	s2,64(sp)
    800041c0:	fc4e                	sd	s3,56(sp)
    800041c2:	f852                	sd	s4,48(sp)
    800041c4:	f456                	sd	s5,40(sp)
    800041c6:	f05a                	sd	s6,32(sp)
    800041c8:	ec5e                	sd	s7,24(sp)
    800041ca:	e862                	sd	s8,16(sp)
    800041cc:	e466                	sd	s9,8(sp)
    800041ce:	1080                	addi	s0,sp,96
    800041d0:	84aa                	mv	s1,a0
    800041d2:	8aae                	mv	s5,a1
    800041d4:	8a32                	mv	s4,a2
    800041d6:	00054703          	lbu	a4,0(a0)
    800041da:	02f00793          	li	a5,47
    800041de:	02f70363          	beq	a4,a5,80004204 <namex+0x4e>
    800041e2:	ffffe097          	auipc	ra,0xffffe
    800041e6:	d1c080e7          	jalr	-740(ra) # 80001efe <myproc>
    800041ea:	15053503          	ld	a0,336(a0)
    800041ee:	00000097          	auipc	ra,0x0
    800041f2:	9f8080e7          	jalr	-1544(ra) # 80003be6 <idup>
    800041f6:	89aa                	mv	s3,a0
    800041f8:	02f00913          	li	s2,47
    800041fc:	4b01                	li	s6,0
    800041fe:	4c35                	li	s8,13
    80004200:	4b85                	li	s7,1
    80004202:	a865                	j	800042ba <namex+0x104>
    80004204:	4585                	li	a1,1
    80004206:	4505                	li	a0,1
    80004208:	fffff097          	auipc	ra,0xfffff
    8000420c:	6e8080e7          	jalr	1768(ra) # 800038f0 <iget>
    80004210:	89aa                	mv	s3,a0
    80004212:	b7dd                	j	800041f8 <namex+0x42>
    80004214:	854e                	mv	a0,s3
    80004216:	00000097          	auipc	ra,0x0
    8000421a:	c70080e7          	jalr	-912(ra) # 80003e86 <iunlockput>
    8000421e:	4981                	li	s3,0
    80004220:	854e                	mv	a0,s3
    80004222:	60e6                	ld	ra,88(sp)
    80004224:	6446                	ld	s0,80(sp)
    80004226:	64a6                	ld	s1,72(sp)
    80004228:	6906                	ld	s2,64(sp)
    8000422a:	79e2                	ld	s3,56(sp)
    8000422c:	7a42                	ld	s4,48(sp)
    8000422e:	7aa2                	ld	s5,40(sp)
    80004230:	7b02                	ld	s6,32(sp)
    80004232:	6be2                	ld	s7,24(sp)
    80004234:	6c42                	ld	s8,16(sp)
    80004236:	6ca2                	ld	s9,8(sp)
    80004238:	6125                	addi	sp,sp,96
    8000423a:	8082                	ret
    8000423c:	854e                	mv	a0,s3
    8000423e:	00000097          	auipc	ra,0x0
    80004242:	aa8080e7          	jalr	-1368(ra) # 80003ce6 <iunlock>
    80004246:	bfe9                	j	80004220 <namex+0x6a>
    80004248:	854e                	mv	a0,s3
    8000424a:	00000097          	auipc	ra,0x0
    8000424e:	c3c080e7          	jalr	-964(ra) # 80003e86 <iunlockput>
    80004252:	89e6                	mv	s3,s9
    80004254:	b7f1                	j	80004220 <namex+0x6a>
    80004256:	40b48633          	sub	a2,s1,a1
    8000425a:	00060c9b          	sext.w	s9,a2
    8000425e:	099c5463          	bge	s8,s9,800042e6 <namex+0x130>
    80004262:	4639                	li	a2,14
    80004264:	8552                	mv	a0,s4
    80004266:	ffffd097          	auipc	ra,0xffffd
    8000426a:	e70080e7          	jalr	-400(ra) # 800010d6 <memmove>
    8000426e:	0004c783          	lbu	a5,0(s1)
    80004272:	01279763          	bne	a5,s2,80004280 <namex+0xca>
    80004276:	0485                	addi	s1,s1,1
    80004278:	0004c783          	lbu	a5,0(s1)
    8000427c:	ff278de3          	beq	a5,s2,80004276 <namex+0xc0>
    80004280:	854e                	mv	a0,s3
    80004282:	00000097          	auipc	ra,0x0
    80004286:	9a2080e7          	jalr	-1630(ra) # 80003c24 <ilock>
    8000428a:	04499783          	lh	a5,68(s3)
    8000428e:	f97793e3          	bne	a5,s7,80004214 <namex+0x5e>
    80004292:	000a8563          	beqz	s5,8000429c <namex+0xe6>
    80004296:	0004c783          	lbu	a5,0(s1)
    8000429a:	d3cd                	beqz	a5,8000423c <namex+0x86>
    8000429c:	865a                	mv	a2,s6
    8000429e:	85d2                	mv	a1,s4
    800042a0:	854e                	mv	a0,s3
    800042a2:	00000097          	auipc	ra,0x0
    800042a6:	e64080e7          	jalr	-412(ra) # 80004106 <dirlookup>
    800042aa:	8caa                	mv	s9,a0
    800042ac:	dd51                	beqz	a0,80004248 <namex+0x92>
    800042ae:	854e                	mv	a0,s3
    800042b0:	00000097          	auipc	ra,0x0
    800042b4:	bd6080e7          	jalr	-1066(ra) # 80003e86 <iunlockput>
    800042b8:	89e6                	mv	s3,s9
    800042ba:	0004c783          	lbu	a5,0(s1)
    800042be:	05279763          	bne	a5,s2,8000430c <namex+0x156>
    800042c2:	0485                	addi	s1,s1,1
    800042c4:	0004c783          	lbu	a5,0(s1)
    800042c8:	ff278de3          	beq	a5,s2,800042c2 <namex+0x10c>
    800042cc:	c79d                	beqz	a5,800042fa <namex+0x144>
    800042ce:	85a6                	mv	a1,s1
    800042d0:	8cda                	mv	s9,s6
    800042d2:	865a                	mv	a2,s6
    800042d4:	01278963          	beq	a5,s2,800042e6 <namex+0x130>
    800042d8:	dfbd                	beqz	a5,80004256 <namex+0xa0>
    800042da:	0485                	addi	s1,s1,1
    800042dc:	0004c783          	lbu	a5,0(s1)
    800042e0:	ff279ce3          	bne	a5,s2,800042d8 <namex+0x122>
    800042e4:	bf8d                	j	80004256 <namex+0xa0>
    800042e6:	2601                	sext.w	a2,a2
    800042e8:	8552                	mv	a0,s4
    800042ea:	ffffd097          	auipc	ra,0xffffd
    800042ee:	dec080e7          	jalr	-532(ra) # 800010d6 <memmove>
    800042f2:	9cd2                	add	s9,s9,s4
    800042f4:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800042f8:	bf9d                	j	8000426e <namex+0xb8>
    800042fa:	f20a83e3          	beqz	s5,80004220 <namex+0x6a>
    800042fe:	854e                	mv	a0,s3
    80004300:	00000097          	auipc	ra,0x0
    80004304:	ade080e7          	jalr	-1314(ra) # 80003dde <iput>
    80004308:	4981                	li	s3,0
    8000430a:	bf19                	j	80004220 <namex+0x6a>
    8000430c:	d7fd                	beqz	a5,800042fa <namex+0x144>
    8000430e:	0004c783          	lbu	a5,0(s1)
    80004312:	85a6                	mv	a1,s1
    80004314:	b7d1                	j	800042d8 <namex+0x122>

0000000080004316 <dirlink>:
    80004316:	7139                	addi	sp,sp,-64
    80004318:	fc06                	sd	ra,56(sp)
    8000431a:	f822                	sd	s0,48(sp)
    8000431c:	f426                	sd	s1,40(sp)
    8000431e:	f04a                	sd	s2,32(sp)
    80004320:	ec4e                	sd	s3,24(sp)
    80004322:	e852                	sd	s4,16(sp)
    80004324:	0080                	addi	s0,sp,64
    80004326:	892a                	mv	s2,a0
    80004328:	8a2e                	mv	s4,a1
    8000432a:	89b2                	mv	s3,a2
    8000432c:	4601                	li	a2,0
    8000432e:	00000097          	auipc	ra,0x0
    80004332:	dd8080e7          	jalr	-552(ra) # 80004106 <dirlookup>
    80004336:	e93d                	bnez	a0,800043ac <dirlink+0x96>
    80004338:	04c92483          	lw	s1,76(s2)
    8000433c:	c49d                	beqz	s1,8000436a <dirlink+0x54>
    8000433e:	4481                	li	s1,0
    80004340:	4741                	li	a4,16
    80004342:	86a6                	mv	a3,s1
    80004344:	fc040613          	addi	a2,s0,-64
    80004348:	4581                	li	a1,0
    8000434a:	854a                	mv	a0,s2
    8000434c:	00000097          	auipc	ra,0x0
    80004350:	b8c080e7          	jalr	-1140(ra) # 80003ed8 <readi>
    80004354:	47c1                	li	a5,16
    80004356:	06f51163          	bne	a0,a5,800043b8 <dirlink+0xa2>
    8000435a:	fc045783          	lhu	a5,-64(s0)
    8000435e:	c791                	beqz	a5,8000436a <dirlink+0x54>
    80004360:	24c1                	addiw	s1,s1,16
    80004362:	04c92783          	lw	a5,76(s2)
    80004366:	fcf4ede3          	bltu	s1,a5,80004340 <dirlink+0x2a>
    8000436a:	4639                	li	a2,14
    8000436c:	85d2                	mv	a1,s4
    8000436e:	fc240513          	addi	a0,s0,-62
    80004372:	ffffd097          	auipc	ra,0xffffd
    80004376:	e1c080e7          	jalr	-484(ra) # 8000118e <strncpy>
    8000437a:	fd341023          	sh	s3,-64(s0)
    8000437e:	4741                	li	a4,16
    80004380:	86a6                	mv	a3,s1
    80004382:	fc040613          	addi	a2,s0,-64
    80004386:	4581                	li	a1,0
    80004388:	854a                	mv	a0,s2
    8000438a:	00000097          	auipc	ra,0x0
    8000438e:	c46080e7          	jalr	-954(ra) # 80003fd0 <writei>
    80004392:	872a                	mv	a4,a0
    80004394:	47c1                	li	a5,16
    80004396:	4501                	li	a0,0
    80004398:	02f71863          	bne	a4,a5,800043c8 <dirlink+0xb2>
    8000439c:	70e2                	ld	ra,56(sp)
    8000439e:	7442                	ld	s0,48(sp)
    800043a0:	74a2                	ld	s1,40(sp)
    800043a2:	7902                	ld	s2,32(sp)
    800043a4:	69e2                	ld	s3,24(sp)
    800043a6:	6a42                	ld	s4,16(sp)
    800043a8:	6121                	addi	sp,sp,64
    800043aa:	8082                	ret
    800043ac:	00000097          	auipc	ra,0x0
    800043b0:	a32080e7          	jalr	-1486(ra) # 80003dde <iput>
    800043b4:	557d                	li	a0,-1
    800043b6:	b7dd                	j	8000439c <dirlink+0x86>
    800043b8:	00004517          	auipc	a0,0x4
    800043bc:	31850513          	addi	a0,a0,792 # 800086d0 <syscalls+0x1e0>
    800043c0:	ffffc097          	auipc	ra,0xffffc
    800043c4:	228080e7          	jalr	552(ra) # 800005e8 <panic>
    800043c8:	00004517          	auipc	a0,0x4
    800043cc:	42850513          	addi	a0,a0,1064 # 800087f0 <syscalls+0x300>
    800043d0:	ffffc097          	auipc	ra,0xffffc
    800043d4:	218080e7          	jalr	536(ra) # 800005e8 <panic>

00000000800043d8 <namei>:
    800043d8:	1101                	addi	sp,sp,-32
    800043da:	ec06                	sd	ra,24(sp)
    800043dc:	e822                	sd	s0,16(sp)
    800043de:	1000                	addi	s0,sp,32
    800043e0:	fe040613          	addi	a2,s0,-32
    800043e4:	4581                	li	a1,0
    800043e6:	00000097          	auipc	ra,0x0
    800043ea:	dd0080e7          	jalr	-560(ra) # 800041b6 <namex>
    800043ee:	60e2                	ld	ra,24(sp)
    800043f0:	6442                	ld	s0,16(sp)
    800043f2:	6105                	addi	sp,sp,32
    800043f4:	8082                	ret

00000000800043f6 <nameiparent>:
    800043f6:	1141                	addi	sp,sp,-16
    800043f8:	e406                	sd	ra,8(sp)
    800043fa:	e022                	sd	s0,0(sp)
    800043fc:	0800                	addi	s0,sp,16
    800043fe:	862e                	mv	a2,a1
    80004400:	4585                	li	a1,1
    80004402:	00000097          	auipc	ra,0x0
    80004406:	db4080e7          	jalr	-588(ra) # 800041b6 <namex>
    8000440a:	60a2                	ld	ra,8(sp)
    8000440c:	6402                	ld	s0,0(sp)
    8000440e:	0141                	addi	sp,sp,16
    80004410:	8082                	ret

0000000080004412 <write_head>:
    80004412:	1101                	addi	sp,sp,-32
    80004414:	ec06                	sd	ra,24(sp)
    80004416:	e822                	sd	s0,16(sp)
    80004418:	e426                	sd	s1,8(sp)
    8000441a:	e04a                	sd	s2,0(sp)
    8000441c:	1000                	addi	s0,sp,32
    8000441e:	0003d917          	auipc	s2,0x3d
    80004422:	64a90913          	addi	s2,s2,1610 # 80041a68 <log>
    80004426:	01892583          	lw	a1,24(s2)
    8000442a:	02892503          	lw	a0,40(s2)
    8000442e:	fffff097          	auipc	ra,0xfffff
    80004432:	ff4080e7          	jalr	-12(ra) # 80003422 <bread>
    80004436:	84aa                	mv	s1,a0
    80004438:	02c92683          	lw	a3,44(s2)
    8000443c:	cd34                	sw	a3,88(a0)
    8000443e:	02d05763          	blez	a3,8000446c <write_head+0x5a>
    80004442:	0003d797          	auipc	a5,0x3d
    80004446:	65678793          	addi	a5,a5,1622 # 80041a98 <log+0x30>
    8000444a:	05c50713          	addi	a4,a0,92
    8000444e:	36fd                	addiw	a3,a3,-1
    80004450:	1682                	slli	a3,a3,0x20
    80004452:	9281                	srli	a3,a3,0x20
    80004454:	068a                	slli	a3,a3,0x2
    80004456:	0003d617          	auipc	a2,0x3d
    8000445a:	64660613          	addi	a2,a2,1606 # 80041a9c <log+0x34>
    8000445e:	96b2                	add	a3,a3,a2
    80004460:	4390                	lw	a2,0(a5)
    80004462:	c310                	sw	a2,0(a4)
    80004464:	0791                	addi	a5,a5,4
    80004466:	0711                	addi	a4,a4,4
    80004468:	fed79ce3          	bne	a5,a3,80004460 <write_head+0x4e>
    8000446c:	8526                	mv	a0,s1
    8000446e:	fffff097          	auipc	ra,0xfffff
    80004472:	0a6080e7          	jalr	166(ra) # 80003514 <bwrite>
    80004476:	8526                	mv	a0,s1
    80004478:	fffff097          	auipc	ra,0xfffff
    8000447c:	0da080e7          	jalr	218(ra) # 80003552 <brelse>
    80004480:	60e2                	ld	ra,24(sp)
    80004482:	6442                	ld	s0,16(sp)
    80004484:	64a2                	ld	s1,8(sp)
    80004486:	6902                	ld	s2,0(sp)
    80004488:	6105                	addi	sp,sp,32
    8000448a:	8082                	ret

000000008000448c <install_trans>:
    8000448c:	0003d797          	auipc	a5,0x3d
    80004490:	6087a783          	lw	a5,1544(a5) # 80041a94 <log+0x2c>
    80004494:	0af05663          	blez	a5,80004540 <install_trans+0xb4>
    80004498:	7139                	addi	sp,sp,-64
    8000449a:	fc06                	sd	ra,56(sp)
    8000449c:	f822                	sd	s0,48(sp)
    8000449e:	f426                	sd	s1,40(sp)
    800044a0:	f04a                	sd	s2,32(sp)
    800044a2:	ec4e                	sd	s3,24(sp)
    800044a4:	e852                	sd	s4,16(sp)
    800044a6:	e456                	sd	s5,8(sp)
    800044a8:	0080                	addi	s0,sp,64
    800044aa:	0003da97          	auipc	s5,0x3d
    800044ae:	5eea8a93          	addi	s5,s5,1518 # 80041a98 <log+0x30>
    800044b2:	4a01                	li	s4,0
    800044b4:	0003d997          	auipc	s3,0x3d
    800044b8:	5b498993          	addi	s3,s3,1460 # 80041a68 <log>
    800044bc:	0189a583          	lw	a1,24(s3)
    800044c0:	014585bb          	addw	a1,a1,s4
    800044c4:	2585                	addiw	a1,a1,1
    800044c6:	0289a503          	lw	a0,40(s3)
    800044ca:	fffff097          	auipc	ra,0xfffff
    800044ce:	f58080e7          	jalr	-168(ra) # 80003422 <bread>
    800044d2:	892a                	mv	s2,a0
    800044d4:	000aa583          	lw	a1,0(s5)
    800044d8:	0289a503          	lw	a0,40(s3)
    800044dc:	fffff097          	auipc	ra,0xfffff
    800044e0:	f46080e7          	jalr	-186(ra) # 80003422 <bread>
    800044e4:	84aa                	mv	s1,a0
    800044e6:	40000613          	li	a2,1024
    800044ea:	05890593          	addi	a1,s2,88
    800044ee:	05850513          	addi	a0,a0,88
    800044f2:	ffffd097          	auipc	ra,0xffffd
    800044f6:	be4080e7          	jalr	-1052(ra) # 800010d6 <memmove>
    800044fa:	8526                	mv	a0,s1
    800044fc:	fffff097          	auipc	ra,0xfffff
    80004500:	018080e7          	jalr	24(ra) # 80003514 <bwrite>
    80004504:	8526                	mv	a0,s1
    80004506:	fffff097          	auipc	ra,0xfffff
    8000450a:	126080e7          	jalr	294(ra) # 8000362c <bunpin>
    8000450e:	854a                	mv	a0,s2
    80004510:	fffff097          	auipc	ra,0xfffff
    80004514:	042080e7          	jalr	66(ra) # 80003552 <brelse>
    80004518:	8526                	mv	a0,s1
    8000451a:	fffff097          	auipc	ra,0xfffff
    8000451e:	038080e7          	jalr	56(ra) # 80003552 <brelse>
    80004522:	2a05                	addiw	s4,s4,1
    80004524:	0a91                	addi	s5,s5,4
    80004526:	02c9a783          	lw	a5,44(s3)
    8000452a:	f8fa49e3          	blt	s4,a5,800044bc <install_trans+0x30>
    8000452e:	70e2                	ld	ra,56(sp)
    80004530:	7442                	ld	s0,48(sp)
    80004532:	74a2                	ld	s1,40(sp)
    80004534:	7902                	ld	s2,32(sp)
    80004536:	69e2                	ld	s3,24(sp)
    80004538:	6a42                	ld	s4,16(sp)
    8000453a:	6aa2                	ld	s5,8(sp)
    8000453c:	6121                	addi	sp,sp,64
    8000453e:	8082                	ret
    80004540:	8082                	ret

0000000080004542 <initlog>:
    80004542:	7179                	addi	sp,sp,-48
    80004544:	f406                	sd	ra,40(sp)
    80004546:	f022                	sd	s0,32(sp)
    80004548:	ec26                	sd	s1,24(sp)
    8000454a:	e84a                	sd	s2,16(sp)
    8000454c:	e44e                	sd	s3,8(sp)
    8000454e:	1800                	addi	s0,sp,48
    80004550:	892a                	mv	s2,a0
    80004552:	89ae                	mv	s3,a1
    80004554:	0003d497          	auipc	s1,0x3d
    80004558:	51448493          	addi	s1,s1,1300 # 80041a68 <log>
    8000455c:	00004597          	auipc	a1,0x4
    80004560:	18458593          	addi	a1,a1,388 # 800086e0 <syscalls+0x1f0>
    80004564:	8526                	mv	a0,s1
    80004566:	ffffd097          	auipc	ra,0xffffd
    8000456a:	988080e7          	jalr	-1656(ra) # 80000eee <initlock>
    8000456e:	0149a583          	lw	a1,20(s3)
    80004572:	cc8c                	sw	a1,24(s1)
    80004574:	0109a783          	lw	a5,16(s3)
    80004578:	ccdc                	sw	a5,28(s1)
    8000457a:	0324a423          	sw	s2,40(s1)
    8000457e:	854a                	mv	a0,s2
    80004580:	fffff097          	auipc	ra,0xfffff
    80004584:	ea2080e7          	jalr	-350(ra) # 80003422 <bread>
    80004588:	4d34                	lw	a3,88(a0)
    8000458a:	d4d4                	sw	a3,44(s1)
    8000458c:	02d05563          	blez	a3,800045b6 <initlog+0x74>
    80004590:	05c50793          	addi	a5,a0,92
    80004594:	0003d717          	auipc	a4,0x3d
    80004598:	50470713          	addi	a4,a4,1284 # 80041a98 <log+0x30>
    8000459c:	36fd                	addiw	a3,a3,-1
    8000459e:	1682                	slli	a3,a3,0x20
    800045a0:	9281                	srli	a3,a3,0x20
    800045a2:	068a                	slli	a3,a3,0x2
    800045a4:	06050613          	addi	a2,a0,96
    800045a8:	96b2                	add	a3,a3,a2
    800045aa:	4390                	lw	a2,0(a5)
    800045ac:	c310                	sw	a2,0(a4)
    800045ae:	0791                	addi	a5,a5,4
    800045b0:	0711                	addi	a4,a4,4
    800045b2:	fed79ce3          	bne	a5,a3,800045aa <initlog+0x68>
    800045b6:	fffff097          	auipc	ra,0xfffff
    800045ba:	f9c080e7          	jalr	-100(ra) # 80003552 <brelse>
    800045be:	00000097          	auipc	ra,0x0
    800045c2:	ece080e7          	jalr	-306(ra) # 8000448c <install_trans>
    800045c6:	0003d797          	auipc	a5,0x3d
    800045ca:	4c07a723          	sw	zero,1230(a5) # 80041a94 <log+0x2c>
    800045ce:	00000097          	auipc	ra,0x0
    800045d2:	e44080e7          	jalr	-444(ra) # 80004412 <write_head>
    800045d6:	70a2                	ld	ra,40(sp)
    800045d8:	7402                	ld	s0,32(sp)
    800045da:	64e2                	ld	s1,24(sp)
    800045dc:	6942                	ld	s2,16(sp)
    800045de:	69a2                	ld	s3,8(sp)
    800045e0:	6145                	addi	sp,sp,48
    800045e2:	8082                	ret

00000000800045e4 <begin_op>:
    800045e4:	1101                	addi	sp,sp,-32
    800045e6:	ec06                	sd	ra,24(sp)
    800045e8:	e822                	sd	s0,16(sp)
    800045ea:	e426                	sd	s1,8(sp)
    800045ec:	e04a                	sd	s2,0(sp)
    800045ee:	1000                	addi	s0,sp,32
    800045f0:	0003d517          	auipc	a0,0x3d
    800045f4:	47850513          	addi	a0,a0,1144 # 80041a68 <log>
    800045f8:	ffffd097          	auipc	ra,0xffffd
    800045fc:	986080e7          	jalr	-1658(ra) # 80000f7e <acquire>
    80004600:	0003d497          	auipc	s1,0x3d
    80004604:	46848493          	addi	s1,s1,1128 # 80041a68 <log>
    80004608:	4979                	li	s2,30
    8000460a:	a039                	j	80004618 <begin_op+0x34>
    8000460c:	85a6                	mv	a1,s1
    8000460e:	8526                	mv	a0,s1
    80004610:	ffffe097          	auipc	ra,0xffffe
    80004614:	102080e7          	jalr	258(ra) # 80002712 <sleep>
    80004618:	50dc                	lw	a5,36(s1)
    8000461a:	fbed                	bnez	a5,8000460c <begin_op+0x28>
    8000461c:	509c                	lw	a5,32(s1)
    8000461e:	0017871b          	addiw	a4,a5,1
    80004622:	0007069b          	sext.w	a3,a4
    80004626:	0027179b          	slliw	a5,a4,0x2
    8000462a:	9fb9                	addw	a5,a5,a4
    8000462c:	0017979b          	slliw	a5,a5,0x1
    80004630:	54d8                	lw	a4,44(s1)
    80004632:	9fb9                	addw	a5,a5,a4
    80004634:	00f95963          	bge	s2,a5,80004646 <begin_op+0x62>
    80004638:	85a6                	mv	a1,s1
    8000463a:	8526                	mv	a0,s1
    8000463c:	ffffe097          	auipc	ra,0xffffe
    80004640:	0d6080e7          	jalr	214(ra) # 80002712 <sleep>
    80004644:	bfd1                	j	80004618 <begin_op+0x34>
    80004646:	0003d517          	auipc	a0,0x3d
    8000464a:	42250513          	addi	a0,a0,1058 # 80041a68 <log>
    8000464e:	d114                	sw	a3,32(a0)
    80004650:	ffffd097          	auipc	ra,0xffffd
    80004654:	9e2080e7          	jalr	-1566(ra) # 80001032 <release>
    80004658:	60e2                	ld	ra,24(sp)
    8000465a:	6442                	ld	s0,16(sp)
    8000465c:	64a2                	ld	s1,8(sp)
    8000465e:	6902                	ld	s2,0(sp)
    80004660:	6105                	addi	sp,sp,32
    80004662:	8082                	ret

0000000080004664 <end_op>:
    80004664:	7139                	addi	sp,sp,-64
    80004666:	fc06                	sd	ra,56(sp)
    80004668:	f822                	sd	s0,48(sp)
    8000466a:	f426                	sd	s1,40(sp)
    8000466c:	f04a                	sd	s2,32(sp)
    8000466e:	ec4e                	sd	s3,24(sp)
    80004670:	e852                	sd	s4,16(sp)
    80004672:	e456                	sd	s5,8(sp)
    80004674:	0080                	addi	s0,sp,64
    80004676:	0003d497          	auipc	s1,0x3d
    8000467a:	3f248493          	addi	s1,s1,1010 # 80041a68 <log>
    8000467e:	8526                	mv	a0,s1
    80004680:	ffffd097          	auipc	ra,0xffffd
    80004684:	8fe080e7          	jalr	-1794(ra) # 80000f7e <acquire>
    80004688:	509c                	lw	a5,32(s1)
    8000468a:	37fd                	addiw	a5,a5,-1
    8000468c:	0007891b          	sext.w	s2,a5
    80004690:	d09c                	sw	a5,32(s1)
    80004692:	50dc                	lw	a5,36(s1)
    80004694:	e7b9                	bnez	a5,800046e2 <end_op+0x7e>
    80004696:	04091e63          	bnez	s2,800046f2 <end_op+0x8e>
    8000469a:	0003d497          	auipc	s1,0x3d
    8000469e:	3ce48493          	addi	s1,s1,974 # 80041a68 <log>
    800046a2:	4785                	li	a5,1
    800046a4:	d0dc                	sw	a5,36(s1)
    800046a6:	8526                	mv	a0,s1
    800046a8:	ffffd097          	auipc	ra,0xffffd
    800046ac:	98a080e7          	jalr	-1654(ra) # 80001032 <release>
    800046b0:	54dc                	lw	a5,44(s1)
    800046b2:	06f04763          	bgtz	a5,80004720 <end_op+0xbc>
    800046b6:	0003d497          	auipc	s1,0x3d
    800046ba:	3b248493          	addi	s1,s1,946 # 80041a68 <log>
    800046be:	8526                	mv	a0,s1
    800046c0:	ffffd097          	auipc	ra,0xffffd
    800046c4:	8be080e7          	jalr	-1858(ra) # 80000f7e <acquire>
    800046c8:	0204a223          	sw	zero,36(s1)
    800046cc:	8526                	mv	a0,s1
    800046ce:	ffffe097          	auipc	ra,0xffffe
    800046d2:	1c4080e7          	jalr	452(ra) # 80002892 <wakeup>
    800046d6:	8526                	mv	a0,s1
    800046d8:	ffffd097          	auipc	ra,0xffffd
    800046dc:	95a080e7          	jalr	-1702(ra) # 80001032 <release>
    800046e0:	a03d                	j	8000470e <end_op+0xaa>
    800046e2:	00004517          	auipc	a0,0x4
    800046e6:	00650513          	addi	a0,a0,6 # 800086e8 <syscalls+0x1f8>
    800046ea:	ffffc097          	auipc	ra,0xffffc
    800046ee:	efe080e7          	jalr	-258(ra) # 800005e8 <panic>
    800046f2:	0003d497          	auipc	s1,0x3d
    800046f6:	37648493          	addi	s1,s1,886 # 80041a68 <log>
    800046fa:	8526                	mv	a0,s1
    800046fc:	ffffe097          	auipc	ra,0xffffe
    80004700:	196080e7          	jalr	406(ra) # 80002892 <wakeup>
    80004704:	8526                	mv	a0,s1
    80004706:	ffffd097          	auipc	ra,0xffffd
    8000470a:	92c080e7          	jalr	-1748(ra) # 80001032 <release>
    8000470e:	70e2                	ld	ra,56(sp)
    80004710:	7442                	ld	s0,48(sp)
    80004712:	74a2                	ld	s1,40(sp)
    80004714:	7902                	ld	s2,32(sp)
    80004716:	69e2                	ld	s3,24(sp)
    80004718:	6a42                	ld	s4,16(sp)
    8000471a:	6aa2                	ld	s5,8(sp)
    8000471c:	6121                	addi	sp,sp,64
    8000471e:	8082                	ret
    80004720:	0003da97          	auipc	s5,0x3d
    80004724:	378a8a93          	addi	s5,s5,888 # 80041a98 <log+0x30>
    80004728:	0003da17          	auipc	s4,0x3d
    8000472c:	340a0a13          	addi	s4,s4,832 # 80041a68 <log>
    80004730:	018a2583          	lw	a1,24(s4)
    80004734:	012585bb          	addw	a1,a1,s2
    80004738:	2585                	addiw	a1,a1,1
    8000473a:	028a2503          	lw	a0,40(s4)
    8000473e:	fffff097          	auipc	ra,0xfffff
    80004742:	ce4080e7          	jalr	-796(ra) # 80003422 <bread>
    80004746:	84aa                	mv	s1,a0
    80004748:	000aa583          	lw	a1,0(s5)
    8000474c:	028a2503          	lw	a0,40(s4)
    80004750:	fffff097          	auipc	ra,0xfffff
    80004754:	cd2080e7          	jalr	-814(ra) # 80003422 <bread>
    80004758:	89aa                	mv	s3,a0
    8000475a:	40000613          	li	a2,1024
    8000475e:	05850593          	addi	a1,a0,88
    80004762:	05848513          	addi	a0,s1,88
    80004766:	ffffd097          	auipc	ra,0xffffd
    8000476a:	970080e7          	jalr	-1680(ra) # 800010d6 <memmove>
    8000476e:	8526                	mv	a0,s1
    80004770:	fffff097          	auipc	ra,0xfffff
    80004774:	da4080e7          	jalr	-604(ra) # 80003514 <bwrite>
    80004778:	854e                	mv	a0,s3
    8000477a:	fffff097          	auipc	ra,0xfffff
    8000477e:	dd8080e7          	jalr	-552(ra) # 80003552 <brelse>
    80004782:	8526                	mv	a0,s1
    80004784:	fffff097          	auipc	ra,0xfffff
    80004788:	dce080e7          	jalr	-562(ra) # 80003552 <brelse>
    8000478c:	2905                	addiw	s2,s2,1
    8000478e:	0a91                	addi	s5,s5,4
    80004790:	02ca2783          	lw	a5,44(s4)
    80004794:	f8f94ee3          	blt	s2,a5,80004730 <end_op+0xcc>
    80004798:	00000097          	auipc	ra,0x0
    8000479c:	c7a080e7          	jalr	-902(ra) # 80004412 <write_head>
    800047a0:	00000097          	auipc	ra,0x0
    800047a4:	cec080e7          	jalr	-788(ra) # 8000448c <install_trans>
    800047a8:	0003d797          	auipc	a5,0x3d
    800047ac:	2e07a623          	sw	zero,748(a5) # 80041a94 <log+0x2c>
    800047b0:	00000097          	auipc	ra,0x0
    800047b4:	c62080e7          	jalr	-926(ra) # 80004412 <write_head>
    800047b8:	bdfd                	j	800046b6 <end_op+0x52>

00000000800047ba <log_write>:
    800047ba:	1101                	addi	sp,sp,-32
    800047bc:	ec06                	sd	ra,24(sp)
    800047be:	e822                	sd	s0,16(sp)
    800047c0:	e426                	sd	s1,8(sp)
    800047c2:	e04a                	sd	s2,0(sp)
    800047c4:	1000                	addi	s0,sp,32
    800047c6:	0003d717          	auipc	a4,0x3d
    800047ca:	2ce72703          	lw	a4,718(a4) # 80041a94 <log+0x2c>
    800047ce:	47f5                	li	a5,29
    800047d0:	08e7c063          	blt	a5,a4,80004850 <log_write+0x96>
    800047d4:	84aa                	mv	s1,a0
    800047d6:	0003d797          	auipc	a5,0x3d
    800047da:	2ae7a783          	lw	a5,686(a5) # 80041a84 <log+0x1c>
    800047de:	37fd                	addiw	a5,a5,-1
    800047e0:	06f75863          	bge	a4,a5,80004850 <log_write+0x96>
    800047e4:	0003d797          	auipc	a5,0x3d
    800047e8:	2a47a783          	lw	a5,676(a5) # 80041a88 <log+0x20>
    800047ec:	06f05a63          	blez	a5,80004860 <log_write+0xa6>
    800047f0:	0003d917          	auipc	s2,0x3d
    800047f4:	27890913          	addi	s2,s2,632 # 80041a68 <log>
    800047f8:	854a                	mv	a0,s2
    800047fa:	ffffc097          	auipc	ra,0xffffc
    800047fe:	784080e7          	jalr	1924(ra) # 80000f7e <acquire>
    80004802:	02c92603          	lw	a2,44(s2)
    80004806:	06c05563          	blez	a2,80004870 <log_write+0xb6>
    8000480a:	44cc                	lw	a1,12(s1)
    8000480c:	0003d717          	auipc	a4,0x3d
    80004810:	28c70713          	addi	a4,a4,652 # 80041a98 <log+0x30>
    80004814:	4781                	li	a5,0
    80004816:	4314                	lw	a3,0(a4)
    80004818:	04b68d63          	beq	a3,a1,80004872 <log_write+0xb8>
    8000481c:	2785                	addiw	a5,a5,1
    8000481e:	0711                	addi	a4,a4,4
    80004820:	fec79be3          	bne	a5,a2,80004816 <log_write+0x5c>
    80004824:	0621                	addi	a2,a2,8
    80004826:	060a                	slli	a2,a2,0x2
    80004828:	0003d797          	auipc	a5,0x3d
    8000482c:	24078793          	addi	a5,a5,576 # 80041a68 <log>
    80004830:	963e                	add	a2,a2,a5
    80004832:	44dc                	lw	a5,12(s1)
    80004834:	ca1c                	sw	a5,16(a2)
    80004836:	8526                	mv	a0,s1
    80004838:	fffff097          	auipc	ra,0xfffff
    8000483c:	db8080e7          	jalr	-584(ra) # 800035f0 <bpin>
    80004840:	0003d717          	auipc	a4,0x3d
    80004844:	22870713          	addi	a4,a4,552 # 80041a68 <log>
    80004848:	575c                	lw	a5,44(a4)
    8000484a:	2785                	addiw	a5,a5,1
    8000484c:	d75c                	sw	a5,44(a4)
    8000484e:	a83d                	j	8000488c <log_write+0xd2>
    80004850:	00004517          	auipc	a0,0x4
    80004854:	ea850513          	addi	a0,a0,-344 # 800086f8 <syscalls+0x208>
    80004858:	ffffc097          	auipc	ra,0xffffc
    8000485c:	d90080e7          	jalr	-624(ra) # 800005e8 <panic>
    80004860:	00004517          	auipc	a0,0x4
    80004864:	eb050513          	addi	a0,a0,-336 # 80008710 <syscalls+0x220>
    80004868:	ffffc097          	auipc	ra,0xffffc
    8000486c:	d80080e7          	jalr	-640(ra) # 800005e8 <panic>
    80004870:	4781                	li	a5,0
    80004872:	00878713          	addi	a4,a5,8
    80004876:	00271693          	slli	a3,a4,0x2
    8000487a:	0003d717          	auipc	a4,0x3d
    8000487e:	1ee70713          	addi	a4,a4,494 # 80041a68 <log>
    80004882:	9736                	add	a4,a4,a3
    80004884:	44d4                	lw	a3,12(s1)
    80004886:	cb14                	sw	a3,16(a4)
    80004888:	faf607e3          	beq	a2,a5,80004836 <log_write+0x7c>
    8000488c:	0003d517          	auipc	a0,0x3d
    80004890:	1dc50513          	addi	a0,a0,476 # 80041a68 <log>
    80004894:	ffffc097          	auipc	ra,0xffffc
    80004898:	79e080e7          	jalr	1950(ra) # 80001032 <release>
    8000489c:	60e2                	ld	ra,24(sp)
    8000489e:	6442                	ld	s0,16(sp)
    800048a0:	64a2                	ld	s1,8(sp)
    800048a2:	6902                	ld	s2,0(sp)
    800048a4:	6105                	addi	sp,sp,32
    800048a6:	8082                	ret

00000000800048a8 <initsleeplock>:
    800048a8:	1101                	addi	sp,sp,-32
    800048aa:	ec06                	sd	ra,24(sp)
    800048ac:	e822                	sd	s0,16(sp)
    800048ae:	e426                	sd	s1,8(sp)
    800048b0:	e04a                	sd	s2,0(sp)
    800048b2:	1000                	addi	s0,sp,32
    800048b4:	84aa                	mv	s1,a0
    800048b6:	892e                	mv	s2,a1
    800048b8:	00004597          	auipc	a1,0x4
    800048bc:	e7858593          	addi	a1,a1,-392 # 80008730 <syscalls+0x240>
    800048c0:	0521                	addi	a0,a0,8
    800048c2:	ffffc097          	auipc	ra,0xffffc
    800048c6:	62c080e7          	jalr	1580(ra) # 80000eee <initlock>
    800048ca:	0324b023          	sd	s2,32(s1)
    800048ce:	0004a023          	sw	zero,0(s1)
    800048d2:	0204a423          	sw	zero,40(s1)
    800048d6:	60e2                	ld	ra,24(sp)
    800048d8:	6442                	ld	s0,16(sp)
    800048da:	64a2                	ld	s1,8(sp)
    800048dc:	6902                	ld	s2,0(sp)
    800048de:	6105                	addi	sp,sp,32
    800048e0:	8082                	ret

00000000800048e2 <acquiresleep>:
    800048e2:	1101                	addi	sp,sp,-32
    800048e4:	ec06                	sd	ra,24(sp)
    800048e6:	e822                	sd	s0,16(sp)
    800048e8:	e426                	sd	s1,8(sp)
    800048ea:	e04a                	sd	s2,0(sp)
    800048ec:	1000                	addi	s0,sp,32
    800048ee:	84aa                	mv	s1,a0
    800048f0:	00850913          	addi	s2,a0,8
    800048f4:	854a                	mv	a0,s2
    800048f6:	ffffc097          	auipc	ra,0xffffc
    800048fa:	688080e7          	jalr	1672(ra) # 80000f7e <acquire>
    800048fe:	409c                	lw	a5,0(s1)
    80004900:	cb89                	beqz	a5,80004912 <acquiresleep+0x30>
    80004902:	85ca                	mv	a1,s2
    80004904:	8526                	mv	a0,s1
    80004906:	ffffe097          	auipc	ra,0xffffe
    8000490a:	e0c080e7          	jalr	-500(ra) # 80002712 <sleep>
    8000490e:	409c                	lw	a5,0(s1)
    80004910:	fbed                	bnez	a5,80004902 <acquiresleep+0x20>
    80004912:	4785                	li	a5,1
    80004914:	c09c                	sw	a5,0(s1)
    80004916:	ffffd097          	auipc	ra,0xffffd
    8000491a:	5e8080e7          	jalr	1512(ra) # 80001efe <myproc>
    8000491e:	5d1c                	lw	a5,56(a0)
    80004920:	d49c                	sw	a5,40(s1)
    80004922:	854a                	mv	a0,s2
    80004924:	ffffc097          	auipc	ra,0xffffc
    80004928:	70e080e7          	jalr	1806(ra) # 80001032 <release>
    8000492c:	60e2                	ld	ra,24(sp)
    8000492e:	6442                	ld	s0,16(sp)
    80004930:	64a2                	ld	s1,8(sp)
    80004932:	6902                	ld	s2,0(sp)
    80004934:	6105                	addi	sp,sp,32
    80004936:	8082                	ret

0000000080004938 <releasesleep>:
    80004938:	1101                	addi	sp,sp,-32
    8000493a:	ec06                	sd	ra,24(sp)
    8000493c:	e822                	sd	s0,16(sp)
    8000493e:	e426                	sd	s1,8(sp)
    80004940:	e04a                	sd	s2,0(sp)
    80004942:	1000                	addi	s0,sp,32
    80004944:	84aa                	mv	s1,a0
    80004946:	00850913          	addi	s2,a0,8
    8000494a:	854a                	mv	a0,s2
    8000494c:	ffffc097          	auipc	ra,0xffffc
    80004950:	632080e7          	jalr	1586(ra) # 80000f7e <acquire>
    80004954:	0004a023          	sw	zero,0(s1)
    80004958:	0204a423          	sw	zero,40(s1)
    8000495c:	8526                	mv	a0,s1
    8000495e:	ffffe097          	auipc	ra,0xffffe
    80004962:	f34080e7          	jalr	-204(ra) # 80002892 <wakeup>
    80004966:	854a                	mv	a0,s2
    80004968:	ffffc097          	auipc	ra,0xffffc
    8000496c:	6ca080e7          	jalr	1738(ra) # 80001032 <release>
    80004970:	60e2                	ld	ra,24(sp)
    80004972:	6442                	ld	s0,16(sp)
    80004974:	64a2                	ld	s1,8(sp)
    80004976:	6902                	ld	s2,0(sp)
    80004978:	6105                	addi	sp,sp,32
    8000497a:	8082                	ret

000000008000497c <holdingsleep>:
    8000497c:	7179                	addi	sp,sp,-48
    8000497e:	f406                	sd	ra,40(sp)
    80004980:	f022                	sd	s0,32(sp)
    80004982:	ec26                	sd	s1,24(sp)
    80004984:	e84a                	sd	s2,16(sp)
    80004986:	e44e                	sd	s3,8(sp)
    80004988:	1800                	addi	s0,sp,48
    8000498a:	84aa                	mv	s1,a0
    8000498c:	00850913          	addi	s2,a0,8
    80004990:	854a                	mv	a0,s2
    80004992:	ffffc097          	auipc	ra,0xffffc
    80004996:	5ec080e7          	jalr	1516(ra) # 80000f7e <acquire>
    8000499a:	409c                	lw	a5,0(s1)
    8000499c:	ef99                	bnez	a5,800049ba <holdingsleep+0x3e>
    8000499e:	4481                	li	s1,0
    800049a0:	854a                	mv	a0,s2
    800049a2:	ffffc097          	auipc	ra,0xffffc
    800049a6:	690080e7          	jalr	1680(ra) # 80001032 <release>
    800049aa:	8526                	mv	a0,s1
    800049ac:	70a2                	ld	ra,40(sp)
    800049ae:	7402                	ld	s0,32(sp)
    800049b0:	64e2                	ld	s1,24(sp)
    800049b2:	6942                	ld	s2,16(sp)
    800049b4:	69a2                	ld	s3,8(sp)
    800049b6:	6145                	addi	sp,sp,48
    800049b8:	8082                	ret
    800049ba:	0284a983          	lw	s3,40(s1)
    800049be:	ffffd097          	auipc	ra,0xffffd
    800049c2:	540080e7          	jalr	1344(ra) # 80001efe <myproc>
    800049c6:	5d04                	lw	s1,56(a0)
    800049c8:	413484b3          	sub	s1,s1,s3
    800049cc:	0014b493          	seqz	s1,s1
    800049d0:	bfc1                	j	800049a0 <holdingsleep+0x24>

00000000800049d2 <fileinit>:
    800049d2:	1141                	addi	sp,sp,-16
    800049d4:	e406                	sd	ra,8(sp)
    800049d6:	e022                	sd	s0,0(sp)
    800049d8:	0800                	addi	s0,sp,16
    800049da:	00004597          	auipc	a1,0x4
    800049de:	d6658593          	addi	a1,a1,-666 # 80008740 <syscalls+0x250>
    800049e2:	0003d517          	auipc	a0,0x3d
    800049e6:	1ce50513          	addi	a0,a0,462 # 80041bb0 <ftable>
    800049ea:	ffffc097          	auipc	ra,0xffffc
    800049ee:	504080e7          	jalr	1284(ra) # 80000eee <initlock>
    800049f2:	60a2                	ld	ra,8(sp)
    800049f4:	6402                	ld	s0,0(sp)
    800049f6:	0141                	addi	sp,sp,16
    800049f8:	8082                	ret

00000000800049fa <filealloc>:
    800049fa:	1101                	addi	sp,sp,-32
    800049fc:	ec06                	sd	ra,24(sp)
    800049fe:	e822                	sd	s0,16(sp)
    80004a00:	e426                	sd	s1,8(sp)
    80004a02:	1000                	addi	s0,sp,32
    80004a04:	0003d517          	auipc	a0,0x3d
    80004a08:	1ac50513          	addi	a0,a0,428 # 80041bb0 <ftable>
    80004a0c:	ffffc097          	auipc	ra,0xffffc
    80004a10:	572080e7          	jalr	1394(ra) # 80000f7e <acquire>
    80004a14:	0003d497          	auipc	s1,0x3d
    80004a18:	1b448493          	addi	s1,s1,436 # 80041bc8 <ftable+0x18>
    80004a1c:	0003e717          	auipc	a4,0x3e
    80004a20:	14c70713          	addi	a4,a4,332 # 80042b68 <ftable+0xfb8>
    80004a24:	40dc                	lw	a5,4(s1)
    80004a26:	cf99                	beqz	a5,80004a44 <filealloc+0x4a>
    80004a28:	02848493          	addi	s1,s1,40
    80004a2c:	fee49ce3          	bne	s1,a4,80004a24 <filealloc+0x2a>
    80004a30:	0003d517          	auipc	a0,0x3d
    80004a34:	18050513          	addi	a0,a0,384 # 80041bb0 <ftable>
    80004a38:	ffffc097          	auipc	ra,0xffffc
    80004a3c:	5fa080e7          	jalr	1530(ra) # 80001032 <release>
    80004a40:	4481                	li	s1,0
    80004a42:	a819                	j	80004a58 <filealloc+0x5e>
    80004a44:	4785                	li	a5,1
    80004a46:	c0dc                	sw	a5,4(s1)
    80004a48:	0003d517          	auipc	a0,0x3d
    80004a4c:	16850513          	addi	a0,a0,360 # 80041bb0 <ftable>
    80004a50:	ffffc097          	auipc	ra,0xffffc
    80004a54:	5e2080e7          	jalr	1506(ra) # 80001032 <release>
    80004a58:	8526                	mv	a0,s1
    80004a5a:	60e2                	ld	ra,24(sp)
    80004a5c:	6442                	ld	s0,16(sp)
    80004a5e:	64a2                	ld	s1,8(sp)
    80004a60:	6105                	addi	sp,sp,32
    80004a62:	8082                	ret

0000000080004a64 <filedup>:
    80004a64:	1101                	addi	sp,sp,-32
    80004a66:	ec06                	sd	ra,24(sp)
    80004a68:	e822                	sd	s0,16(sp)
    80004a6a:	e426                	sd	s1,8(sp)
    80004a6c:	1000                	addi	s0,sp,32
    80004a6e:	84aa                	mv	s1,a0
    80004a70:	0003d517          	auipc	a0,0x3d
    80004a74:	14050513          	addi	a0,a0,320 # 80041bb0 <ftable>
    80004a78:	ffffc097          	auipc	ra,0xffffc
    80004a7c:	506080e7          	jalr	1286(ra) # 80000f7e <acquire>
    80004a80:	40dc                	lw	a5,4(s1)
    80004a82:	02f05263          	blez	a5,80004aa6 <filedup+0x42>
    80004a86:	2785                	addiw	a5,a5,1
    80004a88:	c0dc                	sw	a5,4(s1)
    80004a8a:	0003d517          	auipc	a0,0x3d
    80004a8e:	12650513          	addi	a0,a0,294 # 80041bb0 <ftable>
    80004a92:	ffffc097          	auipc	ra,0xffffc
    80004a96:	5a0080e7          	jalr	1440(ra) # 80001032 <release>
    80004a9a:	8526                	mv	a0,s1
    80004a9c:	60e2                	ld	ra,24(sp)
    80004a9e:	6442                	ld	s0,16(sp)
    80004aa0:	64a2                	ld	s1,8(sp)
    80004aa2:	6105                	addi	sp,sp,32
    80004aa4:	8082                	ret
    80004aa6:	00004517          	auipc	a0,0x4
    80004aaa:	ca250513          	addi	a0,a0,-862 # 80008748 <syscalls+0x258>
    80004aae:	ffffc097          	auipc	ra,0xffffc
    80004ab2:	b3a080e7          	jalr	-1222(ra) # 800005e8 <panic>

0000000080004ab6 <fileclose>:
    80004ab6:	7139                	addi	sp,sp,-64
    80004ab8:	fc06                	sd	ra,56(sp)
    80004aba:	f822                	sd	s0,48(sp)
    80004abc:	f426                	sd	s1,40(sp)
    80004abe:	f04a                	sd	s2,32(sp)
    80004ac0:	ec4e                	sd	s3,24(sp)
    80004ac2:	e852                	sd	s4,16(sp)
    80004ac4:	e456                	sd	s5,8(sp)
    80004ac6:	0080                	addi	s0,sp,64
    80004ac8:	84aa                	mv	s1,a0
    80004aca:	0003d517          	auipc	a0,0x3d
    80004ace:	0e650513          	addi	a0,a0,230 # 80041bb0 <ftable>
    80004ad2:	ffffc097          	auipc	ra,0xffffc
    80004ad6:	4ac080e7          	jalr	1196(ra) # 80000f7e <acquire>
    80004ada:	40dc                	lw	a5,4(s1)
    80004adc:	06f05163          	blez	a5,80004b3e <fileclose+0x88>
    80004ae0:	37fd                	addiw	a5,a5,-1
    80004ae2:	0007871b          	sext.w	a4,a5
    80004ae6:	c0dc                	sw	a5,4(s1)
    80004ae8:	06e04363          	bgtz	a4,80004b4e <fileclose+0x98>
    80004aec:	0004a903          	lw	s2,0(s1)
    80004af0:	0094ca83          	lbu	s5,9(s1)
    80004af4:	0104ba03          	ld	s4,16(s1)
    80004af8:	0184b983          	ld	s3,24(s1)
    80004afc:	0004a223          	sw	zero,4(s1)
    80004b00:	0004a023          	sw	zero,0(s1)
    80004b04:	0003d517          	auipc	a0,0x3d
    80004b08:	0ac50513          	addi	a0,a0,172 # 80041bb0 <ftable>
    80004b0c:	ffffc097          	auipc	ra,0xffffc
    80004b10:	526080e7          	jalr	1318(ra) # 80001032 <release>
    80004b14:	4785                	li	a5,1
    80004b16:	04f90d63          	beq	s2,a5,80004b70 <fileclose+0xba>
    80004b1a:	3979                	addiw	s2,s2,-2
    80004b1c:	4785                	li	a5,1
    80004b1e:	0527e063          	bltu	a5,s2,80004b5e <fileclose+0xa8>
    80004b22:	00000097          	auipc	ra,0x0
    80004b26:	ac2080e7          	jalr	-1342(ra) # 800045e4 <begin_op>
    80004b2a:	854e                	mv	a0,s3
    80004b2c:	fffff097          	auipc	ra,0xfffff
    80004b30:	2b2080e7          	jalr	690(ra) # 80003dde <iput>
    80004b34:	00000097          	auipc	ra,0x0
    80004b38:	b30080e7          	jalr	-1232(ra) # 80004664 <end_op>
    80004b3c:	a00d                	j	80004b5e <fileclose+0xa8>
    80004b3e:	00004517          	auipc	a0,0x4
    80004b42:	c1250513          	addi	a0,a0,-1006 # 80008750 <syscalls+0x260>
    80004b46:	ffffc097          	auipc	ra,0xffffc
    80004b4a:	aa2080e7          	jalr	-1374(ra) # 800005e8 <panic>
    80004b4e:	0003d517          	auipc	a0,0x3d
    80004b52:	06250513          	addi	a0,a0,98 # 80041bb0 <ftable>
    80004b56:	ffffc097          	auipc	ra,0xffffc
    80004b5a:	4dc080e7          	jalr	1244(ra) # 80001032 <release>
    80004b5e:	70e2                	ld	ra,56(sp)
    80004b60:	7442                	ld	s0,48(sp)
    80004b62:	74a2                	ld	s1,40(sp)
    80004b64:	7902                	ld	s2,32(sp)
    80004b66:	69e2                	ld	s3,24(sp)
    80004b68:	6a42                	ld	s4,16(sp)
    80004b6a:	6aa2                	ld	s5,8(sp)
    80004b6c:	6121                	addi	sp,sp,64
    80004b6e:	8082                	ret
    80004b70:	85d6                	mv	a1,s5
    80004b72:	8552                	mv	a0,s4
    80004b74:	00000097          	auipc	ra,0x0
    80004b78:	372080e7          	jalr	882(ra) # 80004ee6 <pipeclose>
    80004b7c:	b7cd                	j	80004b5e <fileclose+0xa8>

0000000080004b7e <filestat>:
    80004b7e:	715d                	addi	sp,sp,-80
    80004b80:	e486                	sd	ra,72(sp)
    80004b82:	e0a2                	sd	s0,64(sp)
    80004b84:	fc26                	sd	s1,56(sp)
    80004b86:	f84a                	sd	s2,48(sp)
    80004b88:	f44e                	sd	s3,40(sp)
    80004b8a:	0880                	addi	s0,sp,80
    80004b8c:	84aa                	mv	s1,a0
    80004b8e:	89ae                	mv	s3,a1
    80004b90:	ffffd097          	auipc	ra,0xffffd
    80004b94:	36e080e7          	jalr	878(ra) # 80001efe <myproc>
    80004b98:	409c                	lw	a5,0(s1)
    80004b9a:	37f9                	addiw	a5,a5,-2
    80004b9c:	4705                	li	a4,1
    80004b9e:	04f76763          	bltu	a4,a5,80004bec <filestat+0x6e>
    80004ba2:	892a                	mv	s2,a0
    80004ba4:	6c88                	ld	a0,24(s1)
    80004ba6:	fffff097          	auipc	ra,0xfffff
    80004baa:	07e080e7          	jalr	126(ra) # 80003c24 <ilock>
    80004bae:	fb840593          	addi	a1,s0,-72
    80004bb2:	6c88                	ld	a0,24(s1)
    80004bb4:	fffff097          	auipc	ra,0xfffff
    80004bb8:	2fa080e7          	jalr	762(ra) # 80003eae <stati>
    80004bbc:	6c88                	ld	a0,24(s1)
    80004bbe:	fffff097          	auipc	ra,0xfffff
    80004bc2:	128080e7          	jalr	296(ra) # 80003ce6 <iunlock>
    80004bc6:	46e1                	li	a3,24
    80004bc8:	fb840613          	addi	a2,s0,-72
    80004bcc:	85ce                	mv	a1,s3
    80004bce:	05093503          	ld	a0,80(s2)
    80004bd2:	ffffd097          	auipc	ra,0xffffd
    80004bd6:	0f8080e7          	jalr	248(ra) # 80001cca <copyout>
    80004bda:	41f5551b          	sraiw	a0,a0,0x1f
    80004bde:	60a6                	ld	ra,72(sp)
    80004be0:	6406                	ld	s0,64(sp)
    80004be2:	74e2                	ld	s1,56(sp)
    80004be4:	7942                	ld	s2,48(sp)
    80004be6:	79a2                	ld	s3,40(sp)
    80004be8:	6161                	addi	sp,sp,80
    80004bea:	8082                	ret
    80004bec:	557d                	li	a0,-1
    80004bee:	bfc5                	j	80004bde <filestat+0x60>

0000000080004bf0 <fileread>:
    80004bf0:	7179                	addi	sp,sp,-48
    80004bf2:	f406                	sd	ra,40(sp)
    80004bf4:	f022                	sd	s0,32(sp)
    80004bf6:	ec26                	sd	s1,24(sp)
    80004bf8:	e84a                	sd	s2,16(sp)
    80004bfa:	e44e                	sd	s3,8(sp)
    80004bfc:	1800                	addi	s0,sp,48
    80004bfe:	00854783          	lbu	a5,8(a0)
    80004c02:	c3d5                	beqz	a5,80004ca6 <fileread+0xb6>
    80004c04:	84aa                	mv	s1,a0
    80004c06:	89ae                	mv	s3,a1
    80004c08:	8932                	mv	s2,a2
    80004c0a:	411c                	lw	a5,0(a0)
    80004c0c:	4705                	li	a4,1
    80004c0e:	04e78963          	beq	a5,a4,80004c60 <fileread+0x70>
    80004c12:	470d                	li	a4,3
    80004c14:	04e78d63          	beq	a5,a4,80004c6e <fileread+0x7e>
    80004c18:	4709                	li	a4,2
    80004c1a:	06e79e63          	bne	a5,a4,80004c96 <fileread+0xa6>
    80004c1e:	6d08                	ld	a0,24(a0)
    80004c20:	fffff097          	auipc	ra,0xfffff
    80004c24:	004080e7          	jalr	4(ra) # 80003c24 <ilock>
    80004c28:	874a                	mv	a4,s2
    80004c2a:	5094                	lw	a3,32(s1)
    80004c2c:	864e                	mv	a2,s3
    80004c2e:	4585                	li	a1,1
    80004c30:	6c88                	ld	a0,24(s1)
    80004c32:	fffff097          	auipc	ra,0xfffff
    80004c36:	2a6080e7          	jalr	678(ra) # 80003ed8 <readi>
    80004c3a:	892a                	mv	s2,a0
    80004c3c:	00a05563          	blez	a0,80004c46 <fileread+0x56>
    80004c40:	509c                	lw	a5,32(s1)
    80004c42:	9fa9                	addw	a5,a5,a0
    80004c44:	d09c                	sw	a5,32(s1)
    80004c46:	6c88                	ld	a0,24(s1)
    80004c48:	fffff097          	auipc	ra,0xfffff
    80004c4c:	09e080e7          	jalr	158(ra) # 80003ce6 <iunlock>
    80004c50:	854a                	mv	a0,s2
    80004c52:	70a2                	ld	ra,40(sp)
    80004c54:	7402                	ld	s0,32(sp)
    80004c56:	64e2                	ld	s1,24(sp)
    80004c58:	6942                	ld	s2,16(sp)
    80004c5a:	69a2                	ld	s3,8(sp)
    80004c5c:	6145                	addi	sp,sp,48
    80004c5e:	8082                	ret
    80004c60:	6908                	ld	a0,16(a0)
    80004c62:	00000097          	auipc	ra,0x0
    80004c66:	3f4080e7          	jalr	1012(ra) # 80005056 <piperead>
    80004c6a:	892a                	mv	s2,a0
    80004c6c:	b7d5                	j	80004c50 <fileread+0x60>
    80004c6e:	02451783          	lh	a5,36(a0)
    80004c72:	03079693          	slli	a3,a5,0x30
    80004c76:	92c1                	srli	a3,a3,0x30
    80004c78:	4725                	li	a4,9
    80004c7a:	02d76863          	bltu	a4,a3,80004caa <fileread+0xba>
    80004c7e:	0792                	slli	a5,a5,0x4
    80004c80:	0003d717          	auipc	a4,0x3d
    80004c84:	e9070713          	addi	a4,a4,-368 # 80041b10 <devsw>
    80004c88:	97ba                	add	a5,a5,a4
    80004c8a:	639c                	ld	a5,0(a5)
    80004c8c:	c38d                	beqz	a5,80004cae <fileread+0xbe>
    80004c8e:	4505                	li	a0,1
    80004c90:	9782                	jalr	a5
    80004c92:	892a                	mv	s2,a0
    80004c94:	bf75                	j	80004c50 <fileread+0x60>
    80004c96:	00004517          	auipc	a0,0x4
    80004c9a:	aca50513          	addi	a0,a0,-1334 # 80008760 <syscalls+0x270>
    80004c9e:	ffffc097          	auipc	ra,0xffffc
    80004ca2:	94a080e7          	jalr	-1718(ra) # 800005e8 <panic>
    80004ca6:	597d                	li	s2,-1
    80004ca8:	b765                	j	80004c50 <fileread+0x60>
    80004caa:	597d                	li	s2,-1
    80004cac:	b755                	j	80004c50 <fileread+0x60>
    80004cae:	597d                	li	s2,-1
    80004cb0:	b745                	j	80004c50 <fileread+0x60>

0000000080004cb2 <filewrite>:
    80004cb2:	00954783          	lbu	a5,9(a0)
    80004cb6:	14078563          	beqz	a5,80004e00 <filewrite+0x14e>
    80004cba:	715d                	addi	sp,sp,-80
    80004cbc:	e486                	sd	ra,72(sp)
    80004cbe:	e0a2                	sd	s0,64(sp)
    80004cc0:	fc26                	sd	s1,56(sp)
    80004cc2:	f84a                	sd	s2,48(sp)
    80004cc4:	f44e                	sd	s3,40(sp)
    80004cc6:	f052                	sd	s4,32(sp)
    80004cc8:	ec56                	sd	s5,24(sp)
    80004cca:	e85a                	sd	s6,16(sp)
    80004ccc:	e45e                	sd	s7,8(sp)
    80004cce:	e062                	sd	s8,0(sp)
    80004cd0:	0880                	addi	s0,sp,80
    80004cd2:	892a                	mv	s2,a0
    80004cd4:	8aae                	mv	s5,a1
    80004cd6:	8a32                	mv	s4,a2
    80004cd8:	411c                	lw	a5,0(a0)
    80004cda:	4705                	li	a4,1
    80004cdc:	02e78263          	beq	a5,a4,80004d00 <filewrite+0x4e>
    80004ce0:	470d                	li	a4,3
    80004ce2:	02e78563          	beq	a5,a4,80004d0c <filewrite+0x5a>
    80004ce6:	4709                	li	a4,2
    80004ce8:	10e79463          	bne	a5,a4,80004df0 <filewrite+0x13e>
    80004cec:	0ec05e63          	blez	a2,80004de8 <filewrite+0x136>
    80004cf0:	4981                	li	s3,0
    80004cf2:	6b05                	lui	s6,0x1
    80004cf4:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004cf8:	6b85                	lui	s7,0x1
    80004cfa:	c00b8b9b          	addiw	s7,s7,-1024
    80004cfe:	a851                	j	80004d92 <filewrite+0xe0>
    80004d00:	6908                	ld	a0,16(a0)
    80004d02:	00000097          	auipc	ra,0x0
    80004d06:	254080e7          	jalr	596(ra) # 80004f56 <pipewrite>
    80004d0a:	a85d                	j	80004dc0 <filewrite+0x10e>
    80004d0c:	02451783          	lh	a5,36(a0)
    80004d10:	03079693          	slli	a3,a5,0x30
    80004d14:	92c1                	srli	a3,a3,0x30
    80004d16:	4725                	li	a4,9
    80004d18:	0ed76663          	bltu	a4,a3,80004e04 <filewrite+0x152>
    80004d1c:	0792                	slli	a5,a5,0x4
    80004d1e:	0003d717          	auipc	a4,0x3d
    80004d22:	df270713          	addi	a4,a4,-526 # 80041b10 <devsw>
    80004d26:	97ba                	add	a5,a5,a4
    80004d28:	679c                	ld	a5,8(a5)
    80004d2a:	cff9                	beqz	a5,80004e08 <filewrite+0x156>
    80004d2c:	4505                	li	a0,1
    80004d2e:	9782                	jalr	a5
    80004d30:	a841                	j	80004dc0 <filewrite+0x10e>
    80004d32:	00048c1b          	sext.w	s8,s1
    80004d36:	00000097          	auipc	ra,0x0
    80004d3a:	8ae080e7          	jalr	-1874(ra) # 800045e4 <begin_op>
    80004d3e:	01893503          	ld	a0,24(s2)
    80004d42:	fffff097          	auipc	ra,0xfffff
    80004d46:	ee2080e7          	jalr	-286(ra) # 80003c24 <ilock>
    80004d4a:	8762                	mv	a4,s8
    80004d4c:	02092683          	lw	a3,32(s2)
    80004d50:	01598633          	add	a2,s3,s5
    80004d54:	4585                	li	a1,1
    80004d56:	01893503          	ld	a0,24(s2)
    80004d5a:	fffff097          	auipc	ra,0xfffff
    80004d5e:	276080e7          	jalr	630(ra) # 80003fd0 <writei>
    80004d62:	84aa                	mv	s1,a0
    80004d64:	02a05f63          	blez	a0,80004da2 <filewrite+0xf0>
    80004d68:	02092783          	lw	a5,32(s2)
    80004d6c:	9fa9                	addw	a5,a5,a0
    80004d6e:	02f92023          	sw	a5,32(s2)
    80004d72:	01893503          	ld	a0,24(s2)
    80004d76:	fffff097          	auipc	ra,0xfffff
    80004d7a:	f70080e7          	jalr	-144(ra) # 80003ce6 <iunlock>
    80004d7e:	00000097          	auipc	ra,0x0
    80004d82:	8e6080e7          	jalr	-1818(ra) # 80004664 <end_op>
    80004d86:	049c1963          	bne	s8,s1,80004dd8 <filewrite+0x126>
    80004d8a:	013489bb          	addw	s3,s1,s3
    80004d8e:	0349d663          	bge	s3,s4,80004dba <filewrite+0x108>
    80004d92:	413a07bb          	subw	a5,s4,s3
    80004d96:	84be                	mv	s1,a5
    80004d98:	2781                	sext.w	a5,a5
    80004d9a:	f8fb5ce3          	bge	s6,a5,80004d32 <filewrite+0x80>
    80004d9e:	84de                	mv	s1,s7
    80004da0:	bf49                	j	80004d32 <filewrite+0x80>
    80004da2:	01893503          	ld	a0,24(s2)
    80004da6:	fffff097          	auipc	ra,0xfffff
    80004daa:	f40080e7          	jalr	-192(ra) # 80003ce6 <iunlock>
    80004dae:	00000097          	auipc	ra,0x0
    80004db2:	8b6080e7          	jalr	-1866(ra) # 80004664 <end_op>
    80004db6:	fc04d8e3          	bgez	s1,80004d86 <filewrite+0xd4>
    80004dba:	8552                	mv	a0,s4
    80004dbc:	033a1863          	bne	s4,s3,80004dec <filewrite+0x13a>
    80004dc0:	60a6                	ld	ra,72(sp)
    80004dc2:	6406                	ld	s0,64(sp)
    80004dc4:	74e2                	ld	s1,56(sp)
    80004dc6:	7942                	ld	s2,48(sp)
    80004dc8:	79a2                	ld	s3,40(sp)
    80004dca:	7a02                	ld	s4,32(sp)
    80004dcc:	6ae2                	ld	s5,24(sp)
    80004dce:	6b42                	ld	s6,16(sp)
    80004dd0:	6ba2                	ld	s7,8(sp)
    80004dd2:	6c02                	ld	s8,0(sp)
    80004dd4:	6161                	addi	sp,sp,80
    80004dd6:	8082                	ret
    80004dd8:	00004517          	auipc	a0,0x4
    80004ddc:	99850513          	addi	a0,a0,-1640 # 80008770 <syscalls+0x280>
    80004de0:	ffffc097          	auipc	ra,0xffffc
    80004de4:	808080e7          	jalr	-2040(ra) # 800005e8 <panic>
    80004de8:	4981                	li	s3,0
    80004dea:	bfc1                	j	80004dba <filewrite+0x108>
    80004dec:	557d                	li	a0,-1
    80004dee:	bfc9                	j	80004dc0 <filewrite+0x10e>
    80004df0:	00004517          	auipc	a0,0x4
    80004df4:	99050513          	addi	a0,a0,-1648 # 80008780 <syscalls+0x290>
    80004df8:	ffffb097          	auipc	ra,0xffffb
    80004dfc:	7f0080e7          	jalr	2032(ra) # 800005e8 <panic>
    80004e00:	557d                	li	a0,-1
    80004e02:	8082                	ret
    80004e04:	557d                	li	a0,-1
    80004e06:	bf6d                	j	80004dc0 <filewrite+0x10e>
    80004e08:	557d                	li	a0,-1
    80004e0a:	bf5d                	j	80004dc0 <filewrite+0x10e>

0000000080004e0c <pipealloc>:
    80004e0c:	7179                	addi	sp,sp,-48
    80004e0e:	f406                	sd	ra,40(sp)
    80004e10:	f022                	sd	s0,32(sp)
    80004e12:	ec26                	sd	s1,24(sp)
    80004e14:	e84a                	sd	s2,16(sp)
    80004e16:	e44e                	sd	s3,8(sp)
    80004e18:	e052                	sd	s4,0(sp)
    80004e1a:	1800                	addi	s0,sp,48
    80004e1c:	84aa                	mv	s1,a0
    80004e1e:	8a2e                	mv	s4,a1
    80004e20:	0005b023          	sd	zero,0(a1)
    80004e24:	00053023          	sd	zero,0(a0)
    80004e28:	00000097          	auipc	ra,0x0
    80004e2c:	bd2080e7          	jalr	-1070(ra) # 800049fa <filealloc>
    80004e30:	e088                	sd	a0,0(s1)
    80004e32:	c551                	beqz	a0,80004ebe <pipealloc+0xb2>
    80004e34:	00000097          	auipc	ra,0x0
    80004e38:	bc6080e7          	jalr	-1082(ra) # 800049fa <filealloc>
    80004e3c:	00aa3023          	sd	a0,0(s4)
    80004e40:	c92d                	beqz	a0,80004eb2 <pipealloc+0xa6>
    80004e42:	ffffc097          	auipc	ra,0xffffc
    80004e46:	f2a080e7          	jalr	-214(ra) # 80000d6c <kalloc>
    80004e4a:	892a                	mv	s2,a0
    80004e4c:	c125                	beqz	a0,80004eac <pipealloc+0xa0>
    80004e4e:	4985                	li	s3,1
    80004e50:	23352023          	sw	s3,544(a0)
    80004e54:	23352223          	sw	s3,548(a0)
    80004e58:	20052e23          	sw	zero,540(a0)
    80004e5c:	20052c23          	sw	zero,536(a0)
    80004e60:	00004597          	auipc	a1,0x4
    80004e64:	93058593          	addi	a1,a1,-1744 # 80008790 <syscalls+0x2a0>
    80004e68:	ffffc097          	auipc	ra,0xffffc
    80004e6c:	086080e7          	jalr	134(ra) # 80000eee <initlock>
    80004e70:	609c                	ld	a5,0(s1)
    80004e72:	0137a023          	sw	s3,0(a5)
    80004e76:	609c                	ld	a5,0(s1)
    80004e78:	01378423          	sb	s3,8(a5)
    80004e7c:	609c                	ld	a5,0(s1)
    80004e7e:	000784a3          	sb	zero,9(a5)
    80004e82:	609c                	ld	a5,0(s1)
    80004e84:	0127b823          	sd	s2,16(a5)
    80004e88:	000a3783          	ld	a5,0(s4)
    80004e8c:	0137a023          	sw	s3,0(a5)
    80004e90:	000a3783          	ld	a5,0(s4)
    80004e94:	00078423          	sb	zero,8(a5)
    80004e98:	000a3783          	ld	a5,0(s4)
    80004e9c:	013784a3          	sb	s3,9(a5)
    80004ea0:	000a3783          	ld	a5,0(s4)
    80004ea4:	0127b823          	sd	s2,16(a5)
    80004ea8:	4501                	li	a0,0
    80004eaa:	a025                	j	80004ed2 <pipealloc+0xc6>
    80004eac:	6088                	ld	a0,0(s1)
    80004eae:	e501                	bnez	a0,80004eb6 <pipealloc+0xaa>
    80004eb0:	a039                	j	80004ebe <pipealloc+0xb2>
    80004eb2:	6088                	ld	a0,0(s1)
    80004eb4:	c51d                	beqz	a0,80004ee2 <pipealloc+0xd6>
    80004eb6:	00000097          	auipc	ra,0x0
    80004eba:	c00080e7          	jalr	-1024(ra) # 80004ab6 <fileclose>
    80004ebe:	000a3783          	ld	a5,0(s4)
    80004ec2:	557d                	li	a0,-1
    80004ec4:	c799                	beqz	a5,80004ed2 <pipealloc+0xc6>
    80004ec6:	853e                	mv	a0,a5
    80004ec8:	00000097          	auipc	ra,0x0
    80004ecc:	bee080e7          	jalr	-1042(ra) # 80004ab6 <fileclose>
    80004ed0:	557d                	li	a0,-1
    80004ed2:	70a2                	ld	ra,40(sp)
    80004ed4:	7402                	ld	s0,32(sp)
    80004ed6:	64e2                	ld	s1,24(sp)
    80004ed8:	6942                	ld	s2,16(sp)
    80004eda:	69a2                	ld	s3,8(sp)
    80004edc:	6a02                	ld	s4,0(sp)
    80004ede:	6145                	addi	sp,sp,48
    80004ee0:	8082                	ret
    80004ee2:	557d                	li	a0,-1
    80004ee4:	b7fd                	j	80004ed2 <pipealloc+0xc6>

0000000080004ee6 <pipeclose>:
    80004ee6:	1101                	addi	sp,sp,-32
    80004ee8:	ec06                	sd	ra,24(sp)
    80004eea:	e822                	sd	s0,16(sp)
    80004eec:	e426                	sd	s1,8(sp)
    80004eee:	e04a                	sd	s2,0(sp)
    80004ef0:	1000                	addi	s0,sp,32
    80004ef2:	84aa                	mv	s1,a0
    80004ef4:	892e                	mv	s2,a1
    80004ef6:	ffffc097          	auipc	ra,0xffffc
    80004efa:	088080e7          	jalr	136(ra) # 80000f7e <acquire>
    80004efe:	02090d63          	beqz	s2,80004f38 <pipeclose+0x52>
    80004f02:	2204a223          	sw	zero,548(s1)
    80004f06:	21848513          	addi	a0,s1,536
    80004f0a:	ffffe097          	auipc	ra,0xffffe
    80004f0e:	988080e7          	jalr	-1656(ra) # 80002892 <wakeup>
    80004f12:	2204b783          	ld	a5,544(s1)
    80004f16:	eb95                	bnez	a5,80004f4a <pipeclose+0x64>
    80004f18:	8526                	mv	a0,s1
    80004f1a:	ffffc097          	auipc	ra,0xffffc
    80004f1e:	118080e7          	jalr	280(ra) # 80001032 <release>
    80004f22:	8526                	mv	a0,s1
    80004f24:	ffffc097          	auipc	ra,0xffffc
    80004f28:	b6a080e7          	jalr	-1174(ra) # 80000a8e <kfree>
    80004f2c:	60e2                	ld	ra,24(sp)
    80004f2e:	6442                	ld	s0,16(sp)
    80004f30:	64a2                	ld	s1,8(sp)
    80004f32:	6902                	ld	s2,0(sp)
    80004f34:	6105                	addi	sp,sp,32
    80004f36:	8082                	ret
    80004f38:	2204a023          	sw	zero,544(s1)
    80004f3c:	21c48513          	addi	a0,s1,540
    80004f40:	ffffe097          	auipc	ra,0xffffe
    80004f44:	952080e7          	jalr	-1710(ra) # 80002892 <wakeup>
    80004f48:	b7e9                	j	80004f12 <pipeclose+0x2c>
    80004f4a:	8526                	mv	a0,s1
    80004f4c:	ffffc097          	auipc	ra,0xffffc
    80004f50:	0e6080e7          	jalr	230(ra) # 80001032 <release>
    80004f54:	bfe1                	j	80004f2c <pipeclose+0x46>

0000000080004f56 <pipewrite>:
    80004f56:	711d                	addi	sp,sp,-96
    80004f58:	ec86                	sd	ra,88(sp)
    80004f5a:	e8a2                	sd	s0,80(sp)
    80004f5c:	e4a6                	sd	s1,72(sp)
    80004f5e:	e0ca                	sd	s2,64(sp)
    80004f60:	fc4e                	sd	s3,56(sp)
    80004f62:	f852                	sd	s4,48(sp)
    80004f64:	f456                	sd	s5,40(sp)
    80004f66:	f05a                	sd	s6,32(sp)
    80004f68:	ec5e                	sd	s7,24(sp)
    80004f6a:	e862                	sd	s8,16(sp)
    80004f6c:	1080                	addi	s0,sp,96
    80004f6e:	84aa                	mv	s1,a0
    80004f70:	8b2e                	mv	s6,a1
    80004f72:	8ab2                	mv	s5,a2
    80004f74:	ffffd097          	auipc	ra,0xffffd
    80004f78:	f8a080e7          	jalr	-118(ra) # 80001efe <myproc>
    80004f7c:	892a                	mv	s2,a0
    80004f7e:	8526                	mv	a0,s1
    80004f80:	ffffc097          	auipc	ra,0xffffc
    80004f84:	ffe080e7          	jalr	-2(ra) # 80000f7e <acquire>
    80004f88:	09505763          	blez	s5,80005016 <pipewrite+0xc0>
    80004f8c:	4b81                	li	s7,0
    80004f8e:	21848a13          	addi	s4,s1,536
    80004f92:	21c48993          	addi	s3,s1,540
    80004f96:	5c7d                	li	s8,-1
    80004f98:	2184a783          	lw	a5,536(s1)
    80004f9c:	21c4a703          	lw	a4,540(s1)
    80004fa0:	2007879b          	addiw	a5,a5,512
    80004fa4:	02f71b63          	bne	a4,a5,80004fda <pipewrite+0x84>
    80004fa8:	2204a783          	lw	a5,544(s1)
    80004fac:	c3d1                	beqz	a5,80005030 <pipewrite+0xda>
    80004fae:	03092783          	lw	a5,48(s2)
    80004fb2:	efbd                	bnez	a5,80005030 <pipewrite+0xda>
    80004fb4:	8552                	mv	a0,s4
    80004fb6:	ffffe097          	auipc	ra,0xffffe
    80004fba:	8dc080e7          	jalr	-1828(ra) # 80002892 <wakeup>
    80004fbe:	85a6                	mv	a1,s1
    80004fc0:	854e                	mv	a0,s3
    80004fc2:	ffffd097          	auipc	ra,0xffffd
    80004fc6:	750080e7          	jalr	1872(ra) # 80002712 <sleep>
    80004fca:	2184a783          	lw	a5,536(s1)
    80004fce:	21c4a703          	lw	a4,540(s1)
    80004fd2:	2007879b          	addiw	a5,a5,512
    80004fd6:	fcf709e3          	beq	a4,a5,80004fa8 <pipewrite+0x52>
    80004fda:	4685                	li	a3,1
    80004fdc:	865a                	mv	a2,s6
    80004fde:	faf40593          	addi	a1,s0,-81
    80004fe2:	05093503          	ld	a0,80(s2)
    80004fe6:	ffffd097          	auipc	ra,0xffffd
    80004fea:	a3c080e7          	jalr	-1476(ra) # 80001a22 <copyin>
    80004fee:	03850563          	beq	a0,s8,80005018 <pipewrite+0xc2>
    80004ff2:	21c4a783          	lw	a5,540(s1)
    80004ff6:	0017871b          	addiw	a4,a5,1
    80004ffa:	20e4ae23          	sw	a4,540(s1)
    80004ffe:	1ff7f793          	andi	a5,a5,511
    80005002:	97a6                	add	a5,a5,s1
    80005004:	faf44703          	lbu	a4,-81(s0)
    80005008:	00e78c23          	sb	a4,24(a5)
    8000500c:	2b85                	addiw	s7,s7,1
    8000500e:	0b05                	addi	s6,s6,1
    80005010:	f97a94e3          	bne	s5,s7,80004f98 <pipewrite+0x42>
    80005014:	a011                	j	80005018 <pipewrite+0xc2>
    80005016:	4b81                	li	s7,0
    80005018:	21848513          	addi	a0,s1,536
    8000501c:	ffffe097          	auipc	ra,0xffffe
    80005020:	876080e7          	jalr	-1930(ra) # 80002892 <wakeup>
    80005024:	8526                	mv	a0,s1
    80005026:	ffffc097          	auipc	ra,0xffffc
    8000502a:	00c080e7          	jalr	12(ra) # 80001032 <release>
    8000502e:	a039                	j	8000503c <pipewrite+0xe6>
    80005030:	8526                	mv	a0,s1
    80005032:	ffffc097          	auipc	ra,0xffffc
    80005036:	000080e7          	jalr	ra # 80001032 <release>
    8000503a:	5bfd                	li	s7,-1
    8000503c:	855e                	mv	a0,s7
    8000503e:	60e6                	ld	ra,88(sp)
    80005040:	6446                	ld	s0,80(sp)
    80005042:	64a6                	ld	s1,72(sp)
    80005044:	6906                	ld	s2,64(sp)
    80005046:	79e2                	ld	s3,56(sp)
    80005048:	7a42                	ld	s4,48(sp)
    8000504a:	7aa2                	ld	s5,40(sp)
    8000504c:	7b02                	ld	s6,32(sp)
    8000504e:	6be2                	ld	s7,24(sp)
    80005050:	6c42                	ld	s8,16(sp)
    80005052:	6125                	addi	sp,sp,96
    80005054:	8082                	ret

0000000080005056 <piperead>:
    80005056:	715d                	addi	sp,sp,-80
    80005058:	e486                	sd	ra,72(sp)
    8000505a:	e0a2                	sd	s0,64(sp)
    8000505c:	fc26                	sd	s1,56(sp)
    8000505e:	f84a                	sd	s2,48(sp)
    80005060:	f44e                	sd	s3,40(sp)
    80005062:	f052                	sd	s4,32(sp)
    80005064:	ec56                	sd	s5,24(sp)
    80005066:	e85a                	sd	s6,16(sp)
    80005068:	0880                	addi	s0,sp,80
    8000506a:	84aa                	mv	s1,a0
    8000506c:	892e                	mv	s2,a1
    8000506e:	8ab2                	mv	s5,a2
    80005070:	ffffd097          	auipc	ra,0xffffd
    80005074:	e8e080e7          	jalr	-370(ra) # 80001efe <myproc>
    80005078:	8a2a                	mv	s4,a0
    8000507a:	8526                	mv	a0,s1
    8000507c:	ffffc097          	auipc	ra,0xffffc
    80005080:	f02080e7          	jalr	-254(ra) # 80000f7e <acquire>
    80005084:	2184a703          	lw	a4,536(s1)
    80005088:	21c4a783          	lw	a5,540(s1)
    8000508c:	21848993          	addi	s3,s1,536
    80005090:	02f71463          	bne	a4,a5,800050b8 <piperead+0x62>
    80005094:	2244a783          	lw	a5,548(s1)
    80005098:	c385                	beqz	a5,800050b8 <piperead+0x62>
    8000509a:	030a2783          	lw	a5,48(s4)
    8000509e:	ebc1                	bnez	a5,8000512e <piperead+0xd8>
    800050a0:	85a6                	mv	a1,s1
    800050a2:	854e                	mv	a0,s3
    800050a4:	ffffd097          	auipc	ra,0xffffd
    800050a8:	66e080e7          	jalr	1646(ra) # 80002712 <sleep>
    800050ac:	2184a703          	lw	a4,536(s1)
    800050b0:	21c4a783          	lw	a5,540(s1)
    800050b4:	fef700e3          	beq	a4,a5,80005094 <piperead+0x3e>
    800050b8:	4981                	li	s3,0
    800050ba:	5b7d                	li	s6,-1
    800050bc:	05505363          	blez	s5,80005102 <piperead+0xac>
    800050c0:	2184a783          	lw	a5,536(s1)
    800050c4:	21c4a703          	lw	a4,540(s1)
    800050c8:	02f70d63          	beq	a4,a5,80005102 <piperead+0xac>
    800050cc:	0017871b          	addiw	a4,a5,1
    800050d0:	20e4ac23          	sw	a4,536(s1)
    800050d4:	1ff7f793          	andi	a5,a5,511
    800050d8:	97a6                	add	a5,a5,s1
    800050da:	0187c783          	lbu	a5,24(a5)
    800050de:	faf40fa3          	sb	a5,-65(s0)
    800050e2:	4685                	li	a3,1
    800050e4:	fbf40613          	addi	a2,s0,-65
    800050e8:	85ca                	mv	a1,s2
    800050ea:	050a3503          	ld	a0,80(s4)
    800050ee:	ffffd097          	auipc	ra,0xffffd
    800050f2:	bdc080e7          	jalr	-1060(ra) # 80001cca <copyout>
    800050f6:	01650663          	beq	a0,s6,80005102 <piperead+0xac>
    800050fa:	2985                	addiw	s3,s3,1
    800050fc:	0905                	addi	s2,s2,1
    800050fe:	fd3a91e3          	bne	s5,s3,800050c0 <piperead+0x6a>
    80005102:	21c48513          	addi	a0,s1,540
    80005106:	ffffd097          	auipc	ra,0xffffd
    8000510a:	78c080e7          	jalr	1932(ra) # 80002892 <wakeup>
    8000510e:	8526                	mv	a0,s1
    80005110:	ffffc097          	auipc	ra,0xffffc
    80005114:	f22080e7          	jalr	-222(ra) # 80001032 <release>
    80005118:	854e                	mv	a0,s3
    8000511a:	60a6                	ld	ra,72(sp)
    8000511c:	6406                	ld	s0,64(sp)
    8000511e:	74e2                	ld	s1,56(sp)
    80005120:	7942                	ld	s2,48(sp)
    80005122:	79a2                	ld	s3,40(sp)
    80005124:	7a02                	ld	s4,32(sp)
    80005126:	6ae2                	ld	s5,24(sp)
    80005128:	6b42                	ld	s6,16(sp)
    8000512a:	6161                	addi	sp,sp,80
    8000512c:	8082                	ret
    8000512e:	8526                	mv	a0,s1
    80005130:	ffffc097          	auipc	ra,0xffffc
    80005134:	f02080e7          	jalr	-254(ra) # 80001032 <release>
    80005138:	59fd                	li	s3,-1
    8000513a:	bff9                	j	80005118 <piperead+0xc2>

000000008000513c <exec>:
    8000513c:	de010113          	addi	sp,sp,-544
    80005140:	20113c23          	sd	ra,536(sp)
    80005144:	20813823          	sd	s0,528(sp)
    80005148:	20913423          	sd	s1,520(sp)
    8000514c:	21213023          	sd	s2,512(sp)
    80005150:	ffce                	sd	s3,504(sp)
    80005152:	fbd2                	sd	s4,496(sp)
    80005154:	f7d6                	sd	s5,488(sp)
    80005156:	f3da                	sd	s6,480(sp)
    80005158:	efde                	sd	s7,472(sp)
    8000515a:	ebe2                	sd	s8,464(sp)
    8000515c:	e7e6                	sd	s9,456(sp)
    8000515e:	e3ea                	sd	s10,448(sp)
    80005160:	ff6e                	sd	s11,440(sp)
    80005162:	1400                	addi	s0,sp,544
    80005164:	892a                	mv	s2,a0
    80005166:	dea43423          	sd	a0,-536(s0)
    8000516a:	deb43823          	sd	a1,-528(s0)
    8000516e:	ffffd097          	auipc	ra,0xffffd
    80005172:	d90080e7          	jalr	-624(ra) # 80001efe <myproc>
    80005176:	84aa                	mv	s1,a0
    80005178:	fffff097          	auipc	ra,0xfffff
    8000517c:	46c080e7          	jalr	1132(ra) # 800045e4 <begin_op>
    80005180:	854a                	mv	a0,s2
    80005182:	fffff097          	auipc	ra,0xfffff
    80005186:	256080e7          	jalr	598(ra) # 800043d8 <namei>
    8000518a:	c93d                	beqz	a0,80005200 <exec+0xc4>
    8000518c:	8aaa                	mv	s5,a0
    8000518e:	fffff097          	auipc	ra,0xfffff
    80005192:	a96080e7          	jalr	-1386(ra) # 80003c24 <ilock>
    80005196:	04000713          	li	a4,64
    8000519a:	4681                	li	a3,0
    8000519c:	e4840613          	addi	a2,s0,-440
    800051a0:	4581                	li	a1,0
    800051a2:	8556                	mv	a0,s5
    800051a4:	fffff097          	auipc	ra,0xfffff
    800051a8:	d34080e7          	jalr	-716(ra) # 80003ed8 <readi>
    800051ac:	04000793          	li	a5,64
    800051b0:	00f51a63          	bne	a0,a5,800051c4 <exec+0x88>
    800051b4:	e4842703          	lw	a4,-440(s0)
    800051b8:	464c47b7          	lui	a5,0x464c4
    800051bc:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800051c0:	04f70663          	beq	a4,a5,8000520c <exec+0xd0>
    800051c4:	8556                	mv	a0,s5
    800051c6:	fffff097          	auipc	ra,0xfffff
    800051ca:	cc0080e7          	jalr	-832(ra) # 80003e86 <iunlockput>
    800051ce:	fffff097          	auipc	ra,0xfffff
    800051d2:	496080e7          	jalr	1174(ra) # 80004664 <end_op>
    800051d6:	557d                	li	a0,-1
    800051d8:	21813083          	ld	ra,536(sp)
    800051dc:	21013403          	ld	s0,528(sp)
    800051e0:	20813483          	ld	s1,520(sp)
    800051e4:	20013903          	ld	s2,512(sp)
    800051e8:	79fe                	ld	s3,504(sp)
    800051ea:	7a5e                	ld	s4,496(sp)
    800051ec:	7abe                	ld	s5,488(sp)
    800051ee:	7b1e                	ld	s6,480(sp)
    800051f0:	6bfe                	ld	s7,472(sp)
    800051f2:	6c5e                	ld	s8,464(sp)
    800051f4:	6cbe                	ld	s9,456(sp)
    800051f6:	6d1e                	ld	s10,448(sp)
    800051f8:	7dfa                	ld	s11,440(sp)
    800051fa:	22010113          	addi	sp,sp,544
    800051fe:	8082                	ret
    80005200:	fffff097          	auipc	ra,0xfffff
    80005204:	464080e7          	jalr	1124(ra) # 80004664 <end_op>
    80005208:	557d                	li	a0,-1
    8000520a:	b7f9                	j	800051d8 <exec+0x9c>
    8000520c:	8526                	mv	a0,s1
    8000520e:	ffffd097          	auipc	ra,0xffffd
    80005212:	db4080e7          	jalr	-588(ra) # 80001fc2 <proc_pagetable>
    80005216:	8b2a                	mv	s6,a0
    80005218:	d555                	beqz	a0,800051c4 <exec+0x88>
    8000521a:	e6842783          	lw	a5,-408(s0)
    8000521e:	e8045703          	lhu	a4,-384(s0)
    80005222:	c735                	beqz	a4,8000528e <exec+0x152>
    80005224:	4481                	li	s1,0
    80005226:	e0043423          	sd	zero,-504(s0)
    8000522a:	6a05                	lui	s4,0x1
    8000522c:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80005230:	dee43023          	sd	a4,-544(s0)
    80005234:	6d85                	lui	s11,0x1
    80005236:	7d7d                	lui	s10,0xfffff
    80005238:	ac1d                	j	8000546e <exec+0x332>
    8000523a:	00003517          	auipc	a0,0x3
    8000523e:	55e50513          	addi	a0,a0,1374 # 80008798 <syscalls+0x2a8>
    80005242:	ffffb097          	auipc	ra,0xffffb
    80005246:	3a6080e7          	jalr	934(ra) # 800005e8 <panic>
    8000524a:	874a                	mv	a4,s2
    8000524c:	009c86bb          	addw	a3,s9,s1
    80005250:	4581                	li	a1,0
    80005252:	8556                	mv	a0,s5
    80005254:	fffff097          	auipc	ra,0xfffff
    80005258:	c84080e7          	jalr	-892(ra) # 80003ed8 <readi>
    8000525c:	2501                	sext.w	a0,a0
    8000525e:	1aa91863          	bne	s2,a0,8000540e <exec+0x2d2>
    80005262:	009d84bb          	addw	s1,s11,s1
    80005266:	013d09bb          	addw	s3,s10,s3
    8000526a:	1f74f263          	bgeu	s1,s7,8000544e <exec+0x312>
    8000526e:	02049593          	slli	a1,s1,0x20
    80005272:	9181                	srli	a1,a1,0x20
    80005274:	95e2                	add	a1,a1,s8
    80005276:	855a                	mv	a0,s6
    80005278:	ffffc097          	auipc	ra,0xffffc
    8000527c:	186080e7          	jalr	390(ra) # 800013fe <walkaddr>
    80005280:	862a                	mv	a2,a0
    80005282:	dd45                	beqz	a0,8000523a <exec+0xfe>
    80005284:	8952                	mv	s2,s4
    80005286:	fd49f2e3          	bgeu	s3,s4,8000524a <exec+0x10e>
    8000528a:	894e                	mv	s2,s3
    8000528c:	bf7d                	j	8000524a <exec+0x10e>
    8000528e:	4481                	li	s1,0
    80005290:	8556                	mv	a0,s5
    80005292:	fffff097          	auipc	ra,0xfffff
    80005296:	bf4080e7          	jalr	-1036(ra) # 80003e86 <iunlockput>
    8000529a:	fffff097          	auipc	ra,0xfffff
    8000529e:	3ca080e7          	jalr	970(ra) # 80004664 <end_op>
    800052a2:	ffffd097          	auipc	ra,0xffffd
    800052a6:	c5c080e7          	jalr	-932(ra) # 80001efe <myproc>
    800052aa:	8baa                	mv	s7,a0
    800052ac:	04853d03          	ld	s10,72(a0)
    800052b0:	6785                	lui	a5,0x1
    800052b2:	17fd                	addi	a5,a5,-1
    800052b4:	94be                	add	s1,s1,a5
    800052b6:	77fd                	lui	a5,0xfffff
    800052b8:	8fe5                	and	a5,a5,s1
    800052ba:	def43c23          	sd	a5,-520(s0)
    800052be:	6609                	lui	a2,0x2
    800052c0:	963e                	add	a2,a2,a5
    800052c2:	85be                	mv	a1,a5
    800052c4:	855a                	mv	a0,s6
    800052c6:	ffffc097          	auipc	ra,0xffffc
    800052ca:	4fe080e7          	jalr	1278(ra) # 800017c4 <uvmalloc>
    800052ce:	8c2a                	mv	s8,a0
    800052d0:	4a81                	li	s5,0
    800052d2:	12050e63          	beqz	a0,8000540e <exec+0x2d2>
    800052d6:	75f9                	lui	a1,0xffffe
    800052d8:	95aa                	add	a1,a1,a0
    800052da:	855a                	mv	a0,s6
    800052dc:	ffffc097          	auipc	ra,0xffffc
    800052e0:	714080e7          	jalr	1812(ra) # 800019f0 <uvmclear>
    800052e4:	7afd                	lui	s5,0xfffff
    800052e6:	9ae2                	add	s5,s5,s8
    800052e8:	df043783          	ld	a5,-528(s0)
    800052ec:	6388                	ld	a0,0(a5)
    800052ee:	c925                	beqz	a0,8000535e <exec+0x222>
    800052f0:	e8840993          	addi	s3,s0,-376
    800052f4:	f8840c93          	addi	s9,s0,-120
    800052f8:	8962                	mv	s2,s8
    800052fa:	4481                	li	s1,0
    800052fc:	ffffc097          	auipc	ra,0xffffc
    80005300:	f02080e7          	jalr	-254(ra) # 800011fe <strlen>
    80005304:	0015079b          	addiw	a5,a0,1
    80005308:	40f90933          	sub	s2,s2,a5
    8000530c:	ff097913          	andi	s2,s2,-16
    80005310:	13596363          	bltu	s2,s5,80005436 <exec+0x2fa>
    80005314:	df043d83          	ld	s11,-528(s0)
    80005318:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    8000531c:	8552                	mv	a0,s4
    8000531e:	ffffc097          	auipc	ra,0xffffc
    80005322:	ee0080e7          	jalr	-288(ra) # 800011fe <strlen>
    80005326:	0015069b          	addiw	a3,a0,1
    8000532a:	8652                	mv	a2,s4
    8000532c:	85ca                	mv	a1,s2
    8000532e:	855a                	mv	a0,s6
    80005330:	ffffd097          	auipc	ra,0xffffd
    80005334:	99a080e7          	jalr	-1638(ra) # 80001cca <copyout>
    80005338:	10054363          	bltz	a0,8000543e <exec+0x302>
    8000533c:	0129b023          	sd	s2,0(s3)
    80005340:	0485                	addi	s1,s1,1
    80005342:	008d8793          	addi	a5,s11,8
    80005346:	def43823          	sd	a5,-528(s0)
    8000534a:	008db503          	ld	a0,8(s11)
    8000534e:	c911                	beqz	a0,80005362 <exec+0x226>
    80005350:	09a1                	addi	s3,s3,8
    80005352:	fb3c95e3          	bne	s9,s3,800052fc <exec+0x1c0>
    80005356:	df843c23          	sd	s8,-520(s0)
    8000535a:	4a81                	li	s5,0
    8000535c:	a84d                	j	8000540e <exec+0x2d2>
    8000535e:	8962                	mv	s2,s8
    80005360:	4481                	li	s1,0
    80005362:	00349793          	slli	a5,s1,0x3
    80005366:	f9040713          	addi	a4,s0,-112
    8000536a:	97ba                	add	a5,a5,a4
    8000536c:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ffb8ef8>
    80005370:	00148693          	addi	a3,s1,1
    80005374:	068e                	slli	a3,a3,0x3
    80005376:	40d90933          	sub	s2,s2,a3
    8000537a:	ff097913          	andi	s2,s2,-16
    8000537e:	01597663          	bgeu	s2,s5,8000538a <exec+0x24e>
    80005382:	df843c23          	sd	s8,-520(s0)
    80005386:	4a81                	li	s5,0
    80005388:	a059                	j	8000540e <exec+0x2d2>
    8000538a:	e8840613          	addi	a2,s0,-376
    8000538e:	85ca                	mv	a1,s2
    80005390:	855a                	mv	a0,s6
    80005392:	ffffd097          	auipc	ra,0xffffd
    80005396:	938080e7          	jalr	-1736(ra) # 80001cca <copyout>
    8000539a:	0a054663          	bltz	a0,80005446 <exec+0x30a>
    8000539e:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    800053a2:	0727bc23          	sd	s2,120(a5)
    800053a6:	de843783          	ld	a5,-536(s0)
    800053aa:	0007c703          	lbu	a4,0(a5)
    800053ae:	cf11                	beqz	a4,800053ca <exec+0x28e>
    800053b0:	0785                	addi	a5,a5,1
    800053b2:	02f00693          	li	a3,47
    800053b6:	a039                	j	800053c4 <exec+0x288>
    800053b8:	def43423          	sd	a5,-536(s0)
    800053bc:	0785                	addi	a5,a5,1
    800053be:	fff7c703          	lbu	a4,-1(a5)
    800053c2:	c701                	beqz	a4,800053ca <exec+0x28e>
    800053c4:	fed71ce3          	bne	a4,a3,800053bc <exec+0x280>
    800053c8:	bfc5                	j	800053b8 <exec+0x27c>
    800053ca:	4641                	li	a2,16
    800053cc:	de843583          	ld	a1,-536(s0)
    800053d0:	158b8513          	addi	a0,s7,344
    800053d4:	ffffc097          	auipc	ra,0xffffc
    800053d8:	df8080e7          	jalr	-520(ra) # 800011cc <safestrcpy>
    800053dc:	050bb503          	ld	a0,80(s7)
    800053e0:	056bb823          	sd	s6,80(s7)
    800053e4:	058bb423          	sd	s8,72(s7)
    800053e8:	058bb783          	ld	a5,88(s7)
    800053ec:	e6043703          	ld	a4,-416(s0)
    800053f0:	ef98                	sd	a4,24(a5)
    800053f2:	058bb783          	ld	a5,88(s7)
    800053f6:	0327b823          	sd	s2,48(a5)
    800053fa:	85ea                	mv	a1,s10
    800053fc:	ffffd097          	auipc	ra,0xffffd
    80005400:	c62080e7          	jalr	-926(ra) # 8000205e <proc_freepagetable>
    80005404:	0004851b          	sext.w	a0,s1
    80005408:	bbc1                	j	800051d8 <exec+0x9c>
    8000540a:	de943c23          	sd	s1,-520(s0)
    8000540e:	df843583          	ld	a1,-520(s0)
    80005412:	855a                	mv	a0,s6
    80005414:	ffffd097          	auipc	ra,0xffffd
    80005418:	c4a080e7          	jalr	-950(ra) # 8000205e <proc_freepagetable>
    8000541c:	da0a94e3          	bnez	s5,800051c4 <exec+0x88>
    80005420:	557d                	li	a0,-1
    80005422:	bb5d                	j	800051d8 <exec+0x9c>
    80005424:	de943c23          	sd	s1,-520(s0)
    80005428:	b7dd                	j	8000540e <exec+0x2d2>
    8000542a:	de943c23          	sd	s1,-520(s0)
    8000542e:	b7c5                	j	8000540e <exec+0x2d2>
    80005430:	de943c23          	sd	s1,-520(s0)
    80005434:	bfe9                	j	8000540e <exec+0x2d2>
    80005436:	df843c23          	sd	s8,-520(s0)
    8000543a:	4a81                	li	s5,0
    8000543c:	bfc9                	j	8000540e <exec+0x2d2>
    8000543e:	df843c23          	sd	s8,-520(s0)
    80005442:	4a81                	li	s5,0
    80005444:	b7e9                	j	8000540e <exec+0x2d2>
    80005446:	df843c23          	sd	s8,-520(s0)
    8000544a:	4a81                	li	s5,0
    8000544c:	b7c9                	j	8000540e <exec+0x2d2>
    8000544e:	df843483          	ld	s1,-520(s0)
    80005452:	e0843783          	ld	a5,-504(s0)
    80005456:	0017869b          	addiw	a3,a5,1
    8000545a:	e0d43423          	sd	a3,-504(s0)
    8000545e:	e0043783          	ld	a5,-512(s0)
    80005462:	0387879b          	addiw	a5,a5,56
    80005466:	e8045703          	lhu	a4,-384(s0)
    8000546a:	e2e6d3e3          	bge	a3,a4,80005290 <exec+0x154>
    8000546e:	2781                	sext.w	a5,a5
    80005470:	e0f43023          	sd	a5,-512(s0)
    80005474:	03800713          	li	a4,56
    80005478:	86be                	mv	a3,a5
    8000547a:	e1040613          	addi	a2,s0,-496
    8000547e:	4581                	li	a1,0
    80005480:	8556                	mv	a0,s5
    80005482:	fffff097          	auipc	ra,0xfffff
    80005486:	a56080e7          	jalr	-1450(ra) # 80003ed8 <readi>
    8000548a:	03800793          	li	a5,56
    8000548e:	f6f51ee3          	bne	a0,a5,8000540a <exec+0x2ce>
    80005492:	e1042783          	lw	a5,-496(s0)
    80005496:	4705                	li	a4,1
    80005498:	fae79de3          	bne	a5,a4,80005452 <exec+0x316>
    8000549c:	e3843603          	ld	a2,-456(s0)
    800054a0:	e3043783          	ld	a5,-464(s0)
    800054a4:	f8f660e3          	bltu	a2,a5,80005424 <exec+0x2e8>
    800054a8:	e2043783          	ld	a5,-480(s0)
    800054ac:	963e                	add	a2,a2,a5
    800054ae:	f6f66ee3          	bltu	a2,a5,8000542a <exec+0x2ee>
    800054b2:	85a6                	mv	a1,s1
    800054b4:	855a                	mv	a0,s6
    800054b6:	ffffc097          	auipc	ra,0xffffc
    800054ba:	30e080e7          	jalr	782(ra) # 800017c4 <uvmalloc>
    800054be:	dea43c23          	sd	a0,-520(s0)
    800054c2:	d53d                	beqz	a0,80005430 <exec+0x2f4>
    800054c4:	e2043c03          	ld	s8,-480(s0)
    800054c8:	de043783          	ld	a5,-544(s0)
    800054cc:	00fc77b3          	and	a5,s8,a5
    800054d0:	ff9d                	bnez	a5,8000540e <exec+0x2d2>
    800054d2:	e1842c83          	lw	s9,-488(s0)
    800054d6:	e3042b83          	lw	s7,-464(s0)
    800054da:	f60b8ae3          	beqz	s7,8000544e <exec+0x312>
    800054de:	89de                	mv	s3,s7
    800054e0:	4481                	li	s1,0
    800054e2:	b371                	j	8000526e <exec+0x132>

00000000800054e4 <argfd>:
    800054e4:	7179                	addi	sp,sp,-48
    800054e6:	f406                	sd	ra,40(sp)
    800054e8:	f022                	sd	s0,32(sp)
    800054ea:	ec26                	sd	s1,24(sp)
    800054ec:	e84a                	sd	s2,16(sp)
    800054ee:	1800                	addi	s0,sp,48
    800054f0:	892e                	mv	s2,a1
    800054f2:	84b2                	mv	s1,a2
    800054f4:	fdc40593          	addi	a1,s0,-36
    800054f8:	ffffe097          	auipc	ra,0xffffe
    800054fc:	b78080e7          	jalr	-1160(ra) # 80003070 <argint>
    80005500:	04054063          	bltz	a0,80005540 <argfd+0x5c>
    80005504:	fdc42703          	lw	a4,-36(s0)
    80005508:	47bd                	li	a5,15
    8000550a:	02e7ed63          	bltu	a5,a4,80005544 <argfd+0x60>
    8000550e:	ffffd097          	auipc	ra,0xffffd
    80005512:	9f0080e7          	jalr	-1552(ra) # 80001efe <myproc>
    80005516:	fdc42703          	lw	a4,-36(s0)
    8000551a:	01a70793          	addi	a5,a4,26
    8000551e:	078e                	slli	a5,a5,0x3
    80005520:	953e                	add	a0,a0,a5
    80005522:	611c                	ld	a5,0(a0)
    80005524:	c395                	beqz	a5,80005548 <argfd+0x64>
    80005526:	00090463          	beqz	s2,8000552e <argfd+0x4a>
    8000552a:	00e92023          	sw	a4,0(s2)
    8000552e:	4501                	li	a0,0
    80005530:	c091                	beqz	s1,80005534 <argfd+0x50>
    80005532:	e09c                	sd	a5,0(s1)
    80005534:	70a2                	ld	ra,40(sp)
    80005536:	7402                	ld	s0,32(sp)
    80005538:	64e2                	ld	s1,24(sp)
    8000553a:	6942                	ld	s2,16(sp)
    8000553c:	6145                	addi	sp,sp,48
    8000553e:	8082                	ret
    80005540:	557d                	li	a0,-1
    80005542:	bfcd                	j	80005534 <argfd+0x50>
    80005544:	557d                	li	a0,-1
    80005546:	b7fd                	j	80005534 <argfd+0x50>
    80005548:	557d                	li	a0,-1
    8000554a:	b7ed                	j	80005534 <argfd+0x50>

000000008000554c <fdalloc>:
    8000554c:	1101                	addi	sp,sp,-32
    8000554e:	ec06                	sd	ra,24(sp)
    80005550:	e822                	sd	s0,16(sp)
    80005552:	e426                	sd	s1,8(sp)
    80005554:	1000                	addi	s0,sp,32
    80005556:	84aa                	mv	s1,a0
    80005558:	ffffd097          	auipc	ra,0xffffd
    8000555c:	9a6080e7          	jalr	-1626(ra) # 80001efe <myproc>
    80005560:	862a                	mv	a2,a0
    80005562:	0d050793          	addi	a5,a0,208
    80005566:	4501                	li	a0,0
    80005568:	46c1                	li	a3,16
    8000556a:	6398                	ld	a4,0(a5)
    8000556c:	cb19                	beqz	a4,80005582 <fdalloc+0x36>
    8000556e:	2505                	addiw	a0,a0,1
    80005570:	07a1                	addi	a5,a5,8
    80005572:	fed51ce3          	bne	a0,a3,8000556a <fdalloc+0x1e>
    80005576:	557d                	li	a0,-1
    80005578:	60e2                	ld	ra,24(sp)
    8000557a:	6442                	ld	s0,16(sp)
    8000557c:	64a2                	ld	s1,8(sp)
    8000557e:	6105                	addi	sp,sp,32
    80005580:	8082                	ret
    80005582:	01a50793          	addi	a5,a0,26
    80005586:	078e                	slli	a5,a5,0x3
    80005588:	963e                	add	a2,a2,a5
    8000558a:	e204                	sd	s1,0(a2)
    8000558c:	b7f5                	j	80005578 <fdalloc+0x2c>

000000008000558e <create>:
    8000558e:	715d                	addi	sp,sp,-80
    80005590:	e486                	sd	ra,72(sp)
    80005592:	e0a2                	sd	s0,64(sp)
    80005594:	fc26                	sd	s1,56(sp)
    80005596:	f84a                	sd	s2,48(sp)
    80005598:	f44e                	sd	s3,40(sp)
    8000559a:	f052                	sd	s4,32(sp)
    8000559c:	ec56                	sd	s5,24(sp)
    8000559e:	0880                	addi	s0,sp,80
    800055a0:	89ae                	mv	s3,a1
    800055a2:	8ab2                	mv	s5,a2
    800055a4:	8a36                	mv	s4,a3
    800055a6:	fb040593          	addi	a1,s0,-80
    800055aa:	fffff097          	auipc	ra,0xfffff
    800055ae:	e4c080e7          	jalr	-436(ra) # 800043f6 <nameiparent>
    800055b2:	892a                	mv	s2,a0
    800055b4:	12050e63          	beqz	a0,800056f0 <create+0x162>
    800055b8:	ffffe097          	auipc	ra,0xffffe
    800055bc:	66c080e7          	jalr	1644(ra) # 80003c24 <ilock>
    800055c0:	4601                	li	a2,0
    800055c2:	fb040593          	addi	a1,s0,-80
    800055c6:	854a                	mv	a0,s2
    800055c8:	fffff097          	auipc	ra,0xfffff
    800055cc:	b3e080e7          	jalr	-1218(ra) # 80004106 <dirlookup>
    800055d0:	84aa                	mv	s1,a0
    800055d2:	c921                	beqz	a0,80005622 <create+0x94>
    800055d4:	854a                	mv	a0,s2
    800055d6:	fffff097          	auipc	ra,0xfffff
    800055da:	8b0080e7          	jalr	-1872(ra) # 80003e86 <iunlockput>
    800055de:	8526                	mv	a0,s1
    800055e0:	ffffe097          	auipc	ra,0xffffe
    800055e4:	644080e7          	jalr	1604(ra) # 80003c24 <ilock>
    800055e8:	2981                	sext.w	s3,s3
    800055ea:	4789                	li	a5,2
    800055ec:	02f99463          	bne	s3,a5,80005614 <create+0x86>
    800055f0:	0444d783          	lhu	a5,68(s1)
    800055f4:	37f9                	addiw	a5,a5,-2
    800055f6:	17c2                	slli	a5,a5,0x30
    800055f8:	93c1                	srli	a5,a5,0x30
    800055fa:	4705                	li	a4,1
    800055fc:	00f76c63          	bltu	a4,a5,80005614 <create+0x86>
    80005600:	8526                	mv	a0,s1
    80005602:	60a6                	ld	ra,72(sp)
    80005604:	6406                	ld	s0,64(sp)
    80005606:	74e2                	ld	s1,56(sp)
    80005608:	7942                	ld	s2,48(sp)
    8000560a:	79a2                	ld	s3,40(sp)
    8000560c:	7a02                	ld	s4,32(sp)
    8000560e:	6ae2                	ld	s5,24(sp)
    80005610:	6161                	addi	sp,sp,80
    80005612:	8082                	ret
    80005614:	8526                	mv	a0,s1
    80005616:	fffff097          	auipc	ra,0xfffff
    8000561a:	870080e7          	jalr	-1936(ra) # 80003e86 <iunlockput>
    8000561e:	4481                	li	s1,0
    80005620:	b7c5                	j	80005600 <create+0x72>
    80005622:	85ce                	mv	a1,s3
    80005624:	00092503          	lw	a0,0(s2)
    80005628:	ffffe097          	auipc	ra,0xffffe
    8000562c:	464080e7          	jalr	1124(ra) # 80003a8c <ialloc>
    80005630:	84aa                	mv	s1,a0
    80005632:	c521                	beqz	a0,8000567a <create+0xec>
    80005634:	ffffe097          	auipc	ra,0xffffe
    80005638:	5f0080e7          	jalr	1520(ra) # 80003c24 <ilock>
    8000563c:	05549323          	sh	s5,70(s1)
    80005640:	05449423          	sh	s4,72(s1)
    80005644:	4a05                	li	s4,1
    80005646:	05449523          	sh	s4,74(s1)
    8000564a:	8526                	mv	a0,s1
    8000564c:	ffffe097          	auipc	ra,0xffffe
    80005650:	50e080e7          	jalr	1294(ra) # 80003b5a <iupdate>
    80005654:	2981                	sext.w	s3,s3
    80005656:	03498a63          	beq	s3,s4,8000568a <create+0xfc>
    8000565a:	40d0                	lw	a2,4(s1)
    8000565c:	fb040593          	addi	a1,s0,-80
    80005660:	854a                	mv	a0,s2
    80005662:	fffff097          	auipc	ra,0xfffff
    80005666:	cb4080e7          	jalr	-844(ra) # 80004316 <dirlink>
    8000566a:	06054b63          	bltz	a0,800056e0 <create+0x152>
    8000566e:	854a                	mv	a0,s2
    80005670:	fffff097          	auipc	ra,0xfffff
    80005674:	816080e7          	jalr	-2026(ra) # 80003e86 <iunlockput>
    80005678:	b761                	j	80005600 <create+0x72>
    8000567a:	00003517          	auipc	a0,0x3
    8000567e:	13e50513          	addi	a0,a0,318 # 800087b8 <syscalls+0x2c8>
    80005682:	ffffb097          	auipc	ra,0xffffb
    80005686:	f66080e7          	jalr	-154(ra) # 800005e8 <panic>
    8000568a:	04a95783          	lhu	a5,74(s2)
    8000568e:	2785                	addiw	a5,a5,1
    80005690:	04f91523          	sh	a5,74(s2)
    80005694:	854a                	mv	a0,s2
    80005696:	ffffe097          	auipc	ra,0xffffe
    8000569a:	4c4080e7          	jalr	1220(ra) # 80003b5a <iupdate>
    8000569e:	40d0                	lw	a2,4(s1)
    800056a0:	00003597          	auipc	a1,0x3
    800056a4:	12858593          	addi	a1,a1,296 # 800087c8 <syscalls+0x2d8>
    800056a8:	8526                	mv	a0,s1
    800056aa:	fffff097          	auipc	ra,0xfffff
    800056ae:	c6c080e7          	jalr	-916(ra) # 80004316 <dirlink>
    800056b2:	00054f63          	bltz	a0,800056d0 <create+0x142>
    800056b6:	00492603          	lw	a2,4(s2)
    800056ba:	00003597          	auipc	a1,0x3
    800056be:	11658593          	addi	a1,a1,278 # 800087d0 <syscalls+0x2e0>
    800056c2:	8526                	mv	a0,s1
    800056c4:	fffff097          	auipc	ra,0xfffff
    800056c8:	c52080e7          	jalr	-942(ra) # 80004316 <dirlink>
    800056cc:	f80557e3          	bgez	a0,8000565a <create+0xcc>
    800056d0:	00003517          	auipc	a0,0x3
    800056d4:	10850513          	addi	a0,a0,264 # 800087d8 <syscalls+0x2e8>
    800056d8:	ffffb097          	auipc	ra,0xffffb
    800056dc:	f10080e7          	jalr	-240(ra) # 800005e8 <panic>
    800056e0:	00003517          	auipc	a0,0x3
    800056e4:	10850513          	addi	a0,a0,264 # 800087e8 <syscalls+0x2f8>
    800056e8:	ffffb097          	auipc	ra,0xffffb
    800056ec:	f00080e7          	jalr	-256(ra) # 800005e8 <panic>
    800056f0:	84aa                	mv	s1,a0
    800056f2:	b739                	j	80005600 <create+0x72>

00000000800056f4 <sys_dup>:
    800056f4:	7179                	addi	sp,sp,-48
    800056f6:	f406                	sd	ra,40(sp)
    800056f8:	f022                	sd	s0,32(sp)
    800056fa:	ec26                	sd	s1,24(sp)
    800056fc:	1800                	addi	s0,sp,48
    800056fe:	fd840613          	addi	a2,s0,-40
    80005702:	4581                	li	a1,0
    80005704:	4501                	li	a0,0
    80005706:	00000097          	auipc	ra,0x0
    8000570a:	dde080e7          	jalr	-546(ra) # 800054e4 <argfd>
    8000570e:	57fd                	li	a5,-1
    80005710:	02054363          	bltz	a0,80005736 <sys_dup+0x42>
    80005714:	fd843503          	ld	a0,-40(s0)
    80005718:	00000097          	auipc	ra,0x0
    8000571c:	e34080e7          	jalr	-460(ra) # 8000554c <fdalloc>
    80005720:	84aa                	mv	s1,a0
    80005722:	57fd                	li	a5,-1
    80005724:	00054963          	bltz	a0,80005736 <sys_dup+0x42>
    80005728:	fd843503          	ld	a0,-40(s0)
    8000572c:	fffff097          	auipc	ra,0xfffff
    80005730:	338080e7          	jalr	824(ra) # 80004a64 <filedup>
    80005734:	87a6                	mv	a5,s1
    80005736:	853e                	mv	a0,a5
    80005738:	70a2                	ld	ra,40(sp)
    8000573a:	7402                	ld	s0,32(sp)
    8000573c:	64e2                	ld	s1,24(sp)
    8000573e:	6145                	addi	sp,sp,48
    80005740:	8082                	ret

0000000080005742 <sys_read>:
    80005742:	7179                	addi	sp,sp,-48
    80005744:	f406                	sd	ra,40(sp)
    80005746:	f022                	sd	s0,32(sp)
    80005748:	1800                	addi	s0,sp,48
    8000574a:	fe840613          	addi	a2,s0,-24
    8000574e:	4581                	li	a1,0
    80005750:	4501                	li	a0,0
    80005752:	00000097          	auipc	ra,0x0
    80005756:	d92080e7          	jalr	-622(ra) # 800054e4 <argfd>
    8000575a:	57fd                	li	a5,-1
    8000575c:	04054163          	bltz	a0,8000579e <sys_read+0x5c>
    80005760:	fe440593          	addi	a1,s0,-28
    80005764:	4509                	li	a0,2
    80005766:	ffffe097          	auipc	ra,0xffffe
    8000576a:	90a080e7          	jalr	-1782(ra) # 80003070 <argint>
    8000576e:	57fd                	li	a5,-1
    80005770:	02054763          	bltz	a0,8000579e <sys_read+0x5c>
    80005774:	fd840593          	addi	a1,s0,-40
    80005778:	4505                	li	a0,1
    8000577a:	ffffe097          	auipc	ra,0xffffe
    8000577e:	918080e7          	jalr	-1768(ra) # 80003092 <argaddr>
    80005782:	57fd                	li	a5,-1
    80005784:	00054d63          	bltz	a0,8000579e <sys_read+0x5c>
    80005788:	fe442603          	lw	a2,-28(s0)
    8000578c:	fd843583          	ld	a1,-40(s0)
    80005790:	fe843503          	ld	a0,-24(s0)
    80005794:	fffff097          	auipc	ra,0xfffff
    80005798:	45c080e7          	jalr	1116(ra) # 80004bf0 <fileread>
    8000579c:	87aa                	mv	a5,a0
    8000579e:	853e                	mv	a0,a5
    800057a0:	70a2                	ld	ra,40(sp)
    800057a2:	7402                	ld	s0,32(sp)
    800057a4:	6145                	addi	sp,sp,48
    800057a6:	8082                	ret

00000000800057a8 <sys_write>:
    800057a8:	7179                	addi	sp,sp,-48
    800057aa:	f406                	sd	ra,40(sp)
    800057ac:	f022                	sd	s0,32(sp)
    800057ae:	1800                	addi	s0,sp,48
    800057b0:	fe840613          	addi	a2,s0,-24
    800057b4:	4581                	li	a1,0
    800057b6:	4501                	li	a0,0
    800057b8:	00000097          	auipc	ra,0x0
    800057bc:	d2c080e7          	jalr	-724(ra) # 800054e4 <argfd>
    800057c0:	57fd                	li	a5,-1
    800057c2:	04054163          	bltz	a0,80005804 <sys_write+0x5c>
    800057c6:	fe440593          	addi	a1,s0,-28
    800057ca:	4509                	li	a0,2
    800057cc:	ffffe097          	auipc	ra,0xffffe
    800057d0:	8a4080e7          	jalr	-1884(ra) # 80003070 <argint>
    800057d4:	57fd                	li	a5,-1
    800057d6:	02054763          	bltz	a0,80005804 <sys_write+0x5c>
    800057da:	fd840593          	addi	a1,s0,-40
    800057de:	4505                	li	a0,1
    800057e0:	ffffe097          	auipc	ra,0xffffe
    800057e4:	8b2080e7          	jalr	-1870(ra) # 80003092 <argaddr>
    800057e8:	57fd                	li	a5,-1
    800057ea:	00054d63          	bltz	a0,80005804 <sys_write+0x5c>
    800057ee:	fe442603          	lw	a2,-28(s0)
    800057f2:	fd843583          	ld	a1,-40(s0)
    800057f6:	fe843503          	ld	a0,-24(s0)
    800057fa:	fffff097          	auipc	ra,0xfffff
    800057fe:	4b8080e7          	jalr	1208(ra) # 80004cb2 <filewrite>
    80005802:	87aa                	mv	a5,a0
    80005804:	853e                	mv	a0,a5
    80005806:	70a2                	ld	ra,40(sp)
    80005808:	7402                	ld	s0,32(sp)
    8000580a:	6145                	addi	sp,sp,48
    8000580c:	8082                	ret

000000008000580e <sys_close>:
    8000580e:	1101                	addi	sp,sp,-32
    80005810:	ec06                	sd	ra,24(sp)
    80005812:	e822                	sd	s0,16(sp)
    80005814:	1000                	addi	s0,sp,32
    80005816:	fe040613          	addi	a2,s0,-32
    8000581a:	fec40593          	addi	a1,s0,-20
    8000581e:	4501                	li	a0,0
    80005820:	00000097          	auipc	ra,0x0
    80005824:	cc4080e7          	jalr	-828(ra) # 800054e4 <argfd>
    80005828:	57fd                	li	a5,-1
    8000582a:	02054463          	bltz	a0,80005852 <sys_close+0x44>
    8000582e:	ffffc097          	auipc	ra,0xffffc
    80005832:	6d0080e7          	jalr	1744(ra) # 80001efe <myproc>
    80005836:	fec42783          	lw	a5,-20(s0)
    8000583a:	07e9                	addi	a5,a5,26
    8000583c:	078e                	slli	a5,a5,0x3
    8000583e:	97aa                	add	a5,a5,a0
    80005840:	0007b023          	sd	zero,0(a5)
    80005844:	fe043503          	ld	a0,-32(s0)
    80005848:	fffff097          	auipc	ra,0xfffff
    8000584c:	26e080e7          	jalr	622(ra) # 80004ab6 <fileclose>
    80005850:	4781                	li	a5,0
    80005852:	853e                	mv	a0,a5
    80005854:	60e2                	ld	ra,24(sp)
    80005856:	6442                	ld	s0,16(sp)
    80005858:	6105                	addi	sp,sp,32
    8000585a:	8082                	ret

000000008000585c <sys_fstat>:
    8000585c:	1101                	addi	sp,sp,-32
    8000585e:	ec06                	sd	ra,24(sp)
    80005860:	e822                	sd	s0,16(sp)
    80005862:	1000                	addi	s0,sp,32
    80005864:	fe840613          	addi	a2,s0,-24
    80005868:	4581                	li	a1,0
    8000586a:	4501                	li	a0,0
    8000586c:	00000097          	auipc	ra,0x0
    80005870:	c78080e7          	jalr	-904(ra) # 800054e4 <argfd>
    80005874:	57fd                	li	a5,-1
    80005876:	02054563          	bltz	a0,800058a0 <sys_fstat+0x44>
    8000587a:	fe040593          	addi	a1,s0,-32
    8000587e:	4505                	li	a0,1
    80005880:	ffffe097          	auipc	ra,0xffffe
    80005884:	812080e7          	jalr	-2030(ra) # 80003092 <argaddr>
    80005888:	57fd                	li	a5,-1
    8000588a:	00054b63          	bltz	a0,800058a0 <sys_fstat+0x44>
    8000588e:	fe043583          	ld	a1,-32(s0)
    80005892:	fe843503          	ld	a0,-24(s0)
    80005896:	fffff097          	auipc	ra,0xfffff
    8000589a:	2e8080e7          	jalr	744(ra) # 80004b7e <filestat>
    8000589e:	87aa                	mv	a5,a0
    800058a0:	853e                	mv	a0,a5
    800058a2:	60e2                	ld	ra,24(sp)
    800058a4:	6442                	ld	s0,16(sp)
    800058a6:	6105                	addi	sp,sp,32
    800058a8:	8082                	ret

00000000800058aa <sys_link>:
    800058aa:	7169                	addi	sp,sp,-304
    800058ac:	f606                	sd	ra,296(sp)
    800058ae:	f222                	sd	s0,288(sp)
    800058b0:	ee26                	sd	s1,280(sp)
    800058b2:	ea4a                	sd	s2,272(sp)
    800058b4:	1a00                	addi	s0,sp,304
    800058b6:	08000613          	li	a2,128
    800058ba:	ed040593          	addi	a1,s0,-304
    800058be:	4501                	li	a0,0
    800058c0:	ffffd097          	auipc	ra,0xffffd
    800058c4:	7f4080e7          	jalr	2036(ra) # 800030b4 <argstr>
    800058c8:	57fd                	li	a5,-1
    800058ca:	10054e63          	bltz	a0,800059e6 <sys_link+0x13c>
    800058ce:	08000613          	li	a2,128
    800058d2:	f5040593          	addi	a1,s0,-176
    800058d6:	4505                	li	a0,1
    800058d8:	ffffd097          	auipc	ra,0xffffd
    800058dc:	7dc080e7          	jalr	2012(ra) # 800030b4 <argstr>
    800058e0:	57fd                	li	a5,-1
    800058e2:	10054263          	bltz	a0,800059e6 <sys_link+0x13c>
    800058e6:	fffff097          	auipc	ra,0xfffff
    800058ea:	cfe080e7          	jalr	-770(ra) # 800045e4 <begin_op>
    800058ee:	ed040513          	addi	a0,s0,-304
    800058f2:	fffff097          	auipc	ra,0xfffff
    800058f6:	ae6080e7          	jalr	-1306(ra) # 800043d8 <namei>
    800058fa:	84aa                	mv	s1,a0
    800058fc:	c551                	beqz	a0,80005988 <sys_link+0xde>
    800058fe:	ffffe097          	auipc	ra,0xffffe
    80005902:	326080e7          	jalr	806(ra) # 80003c24 <ilock>
    80005906:	04449703          	lh	a4,68(s1)
    8000590a:	4785                	li	a5,1
    8000590c:	08f70463          	beq	a4,a5,80005994 <sys_link+0xea>
    80005910:	04a4d783          	lhu	a5,74(s1)
    80005914:	2785                	addiw	a5,a5,1
    80005916:	04f49523          	sh	a5,74(s1)
    8000591a:	8526                	mv	a0,s1
    8000591c:	ffffe097          	auipc	ra,0xffffe
    80005920:	23e080e7          	jalr	574(ra) # 80003b5a <iupdate>
    80005924:	8526                	mv	a0,s1
    80005926:	ffffe097          	auipc	ra,0xffffe
    8000592a:	3c0080e7          	jalr	960(ra) # 80003ce6 <iunlock>
    8000592e:	fd040593          	addi	a1,s0,-48
    80005932:	f5040513          	addi	a0,s0,-176
    80005936:	fffff097          	auipc	ra,0xfffff
    8000593a:	ac0080e7          	jalr	-1344(ra) # 800043f6 <nameiparent>
    8000593e:	892a                	mv	s2,a0
    80005940:	c935                	beqz	a0,800059b4 <sys_link+0x10a>
    80005942:	ffffe097          	auipc	ra,0xffffe
    80005946:	2e2080e7          	jalr	738(ra) # 80003c24 <ilock>
    8000594a:	00092703          	lw	a4,0(s2)
    8000594e:	409c                	lw	a5,0(s1)
    80005950:	04f71d63          	bne	a4,a5,800059aa <sys_link+0x100>
    80005954:	40d0                	lw	a2,4(s1)
    80005956:	fd040593          	addi	a1,s0,-48
    8000595a:	854a                	mv	a0,s2
    8000595c:	fffff097          	auipc	ra,0xfffff
    80005960:	9ba080e7          	jalr	-1606(ra) # 80004316 <dirlink>
    80005964:	04054363          	bltz	a0,800059aa <sys_link+0x100>
    80005968:	854a                	mv	a0,s2
    8000596a:	ffffe097          	auipc	ra,0xffffe
    8000596e:	51c080e7          	jalr	1308(ra) # 80003e86 <iunlockput>
    80005972:	8526                	mv	a0,s1
    80005974:	ffffe097          	auipc	ra,0xffffe
    80005978:	46a080e7          	jalr	1130(ra) # 80003dde <iput>
    8000597c:	fffff097          	auipc	ra,0xfffff
    80005980:	ce8080e7          	jalr	-792(ra) # 80004664 <end_op>
    80005984:	4781                	li	a5,0
    80005986:	a085                	j	800059e6 <sys_link+0x13c>
    80005988:	fffff097          	auipc	ra,0xfffff
    8000598c:	cdc080e7          	jalr	-804(ra) # 80004664 <end_op>
    80005990:	57fd                	li	a5,-1
    80005992:	a891                	j	800059e6 <sys_link+0x13c>
    80005994:	8526                	mv	a0,s1
    80005996:	ffffe097          	auipc	ra,0xffffe
    8000599a:	4f0080e7          	jalr	1264(ra) # 80003e86 <iunlockput>
    8000599e:	fffff097          	auipc	ra,0xfffff
    800059a2:	cc6080e7          	jalr	-826(ra) # 80004664 <end_op>
    800059a6:	57fd                	li	a5,-1
    800059a8:	a83d                	j	800059e6 <sys_link+0x13c>
    800059aa:	854a                	mv	a0,s2
    800059ac:	ffffe097          	auipc	ra,0xffffe
    800059b0:	4da080e7          	jalr	1242(ra) # 80003e86 <iunlockput>
    800059b4:	8526                	mv	a0,s1
    800059b6:	ffffe097          	auipc	ra,0xffffe
    800059ba:	26e080e7          	jalr	622(ra) # 80003c24 <ilock>
    800059be:	04a4d783          	lhu	a5,74(s1)
    800059c2:	37fd                	addiw	a5,a5,-1
    800059c4:	04f49523          	sh	a5,74(s1)
    800059c8:	8526                	mv	a0,s1
    800059ca:	ffffe097          	auipc	ra,0xffffe
    800059ce:	190080e7          	jalr	400(ra) # 80003b5a <iupdate>
    800059d2:	8526                	mv	a0,s1
    800059d4:	ffffe097          	auipc	ra,0xffffe
    800059d8:	4b2080e7          	jalr	1202(ra) # 80003e86 <iunlockput>
    800059dc:	fffff097          	auipc	ra,0xfffff
    800059e0:	c88080e7          	jalr	-888(ra) # 80004664 <end_op>
    800059e4:	57fd                	li	a5,-1
    800059e6:	853e                	mv	a0,a5
    800059e8:	70b2                	ld	ra,296(sp)
    800059ea:	7412                	ld	s0,288(sp)
    800059ec:	64f2                	ld	s1,280(sp)
    800059ee:	6952                	ld	s2,272(sp)
    800059f0:	6155                	addi	sp,sp,304
    800059f2:	8082                	ret

00000000800059f4 <sys_unlink>:
    800059f4:	7151                	addi	sp,sp,-240
    800059f6:	f586                	sd	ra,232(sp)
    800059f8:	f1a2                	sd	s0,224(sp)
    800059fa:	eda6                	sd	s1,216(sp)
    800059fc:	e9ca                	sd	s2,208(sp)
    800059fe:	e5ce                	sd	s3,200(sp)
    80005a00:	1980                	addi	s0,sp,240
    80005a02:	08000613          	li	a2,128
    80005a06:	f3040593          	addi	a1,s0,-208
    80005a0a:	4501                	li	a0,0
    80005a0c:	ffffd097          	auipc	ra,0xffffd
    80005a10:	6a8080e7          	jalr	1704(ra) # 800030b4 <argstr>
    80005a14:	18054163          	bltz	a0,80005b96 <sys_unlink+0x1a2>
    80005a18:	fffff097          	auipc	ra,0xfffff
    80005a1c:	bcc080e7          	jalr	-1076(ra) # 800045e4 <begin_op>
    80005a20:	fb040593          	addi	a1,s0,-80
    80005a24:	f3040513          	addi	a0,s0,-208
    80005a28:	fffff097          	auipc	ra,0xfffff
    80005a2c:	9ce080e7          	jalr	-1586(ra) # 800043f6 <nameiparent>
    80005a30:	84aa                	mv	s1,a0
    80005a32:	c979                	beqz	a0,80005b08 <sys_unlink+0x114>
    80005a34:	ffffe097          	auipc	ra,0xffffe
    80005a38:	1f0080e7          	jalr	496(ra) # 80003c24 <ilock>
    80005a3c:	00003597          	auipc	a1,0x3
    80005a40:	d8c58593          	addi	a1,a1,-628 # 800087c8 <syscalls+0x2d8>
    80005a44:	fb040513          	addi	a0,s0,-80
    80005a48:	ffffe097          	auipc	ra,0xffffe
    80005a4c:	6a4080e7          	jalr	1700(ra) # 800040ec <namecmp>
    80005a50:	14050a63          	beqz	a0,80005ba4 <sys_unlink+0x1b0>
    80005a54:	00003597          	auipc	a1,0x3
    80005a58:	d7c58593          	addi	a1,a1,-644 # 800087d0 <syscalls+0x2e0>
    80005a5c:	fb040513          	addi	a0,s0,-80
    80005a60:	ffffe097          	auipc	ra,0xffffe
    80005a64:	68c080e7          	jalr	1676(ra) # 800040ec <namecmp>
    80005a68:	12050e63          	beqz	a0,80005ba4 <sys_unlink+0x1b0>
    80005a6c:	f2c40613          	addi	a2,s0,-212
    80005a70:	fb040593          	addi	a1,s0,-80
    80005a74:	8526                	mv	a0,s1
    80005a76:	ffffe097          	auipc	ra,0xffffe
    80005a7a:	690080e7          	jalr	1680(ra) # 80004106 <dirlookup>
    80005a7e:	892a                	mv	s2,a0
    80005a80:	12050263          	beqz	a0,80005ba4 <sys_unlink+0x1b0>
    80005a84:	ffffe097          	auipc	ra,0xffffe
    80005a88:	1a0080e7          	jalr	416(ra) # 80003c24 <ilock>
    80005a8c:	04a91783          	lh	a5,74(s2)
    80005a90:	08f05263          	blez	a5,80005b14 <sys_unlink+0x120>
    80005a94:	04491703          	lh	a4,68(s2)
    80005a98:	4785                	li	a5,1
    80005a9a:	08f70563          	beq	a4,a5,80005b24 <sys_unlink+0x130>
    80005a9e:	4641                	li	a2,16
    80005aa0:	4581                	li	a1,0
    80005aa2:	fc040513          	addi	a0,s0,-64
    80005aa6:	ffffb097          	auipc	ra,0xffffb
    80005aaa:	5d4080e7          	jalr	1492(ra) # 8000107a <memset>
    80005aae:	4741                	li	a4,16
    80005ab0:	f2c42683          	lw	a3,-212(s0)
    80005ab4:	fc040613          	addi	a2,s0,-64
    80005ab8:	4581                	li	a1,0
    80005aba:	8526                	mv	a0,s1
    80005abc:	ffffe097          	auipc	ra,0xffffe
    80005ac0:	514080e7          	jalr	1300(ra) # 80003fd0 <writei>
    80005ac4:	47c1                	li	a5,16
    80005ac6:	0af51563          	bne	a0,a5,80005b70 <sys_unlink+0x17c>
    80005aca:	04491703          	lh	a4,68(s2)
    80005ace:	4785                	li	a5,1
    80005ad0:	0af70863          	beq	a4,a5,80005b80 <sys_unlink+0x18c>
    80005ad4:	8526                	mv	a0,s1
    80005ad6:	ffffe097          	auipc	ra,0xffffe
    80005ada:	3b0080e7          	jalr	944(ra) # 80003e86 <iunlockput>
    80005ade:	04a95783          	lhu	a5,74(s2)
    80005ae2:	37fd                	addiw	a5,a5,-1
    80005ae4:	04f91523          	sh	a5,74(s2)
    80005ae8:	854a                	mv	a0,s2
    80005aea:	ffffe097          	auipc	ra,0xffffe
    80005aee:	070080e7          	jalr	112(ra) # 80003b5a <iupdate>
    80005af2:	854a                	mv	a0,s2
    80005af4:	ffffe097          	auipc	ra,0xffffe
    80005af8:	392080e7          	jalr	914(ra) # 80003e86 <iunlockput>
    80005afc:	fffff097          	auipc	ra,0xfffff
    80005b00:	b68080e7          	jalr	-1176(ra) # 80004664 <end_op>
    80005b04:	4501                	li	a0,0
    80005b06:	a84d                	j	80005bb8 <sys_unlink+0x1c4>
    80005b08:	fffff097          	auipc	ra,0xfffff
    80005b0c:	b5c080e7          	jalr	-1188(ra) # 80004664 <end_op>
    80005b10:	557d                	li	a0,-1
    80005b12:	a05d                	j	80005bb8 <sys_unlink+0x1c4>
    80005b14:	00003517          	auipc	a0,0x3
    80005b18:	ce450513          	addi	a0,a0,-796 # 800087f8 <syscalls+0x308>
    80005b1c:	ffffb097          	auipc	ra,0xffffb
    80005b20:	acc080e7          	jalr	-1332(ra) # 800005e8 <panic>
    80005b24:	04c92703          	lw	a4,76(s2)
    80005b28:	02000793          	li	a5,32
    80005b2c:	f6e7f9e3          	bgeu	a5,a4,80005a9e <sys_unlink+0xaa>
    80005b30:	02000993          	li	s3,32
    80005b34:	4741                	li	a4,16
    80005b36:	86ce                	mv	a3,s3
    80005b38:	f1840613          	addi	a2,s0,-232
    80005b3c:	4581                	li	a1,0
    80005b3e:	854a                	mv	a0,s2
    80005b40:	ffffe097          	auipc	ra,0xffffe
    80005b44:	398080e7          	jalr	920(ra) # 80003ed8 <readi>
    80005b48:	47c1                	li	a5,16
    80005b4a:	00f51b63          	bne	a0,a5,80005b60 <sys_unlink+0x16c>
    80005b4e:	f1845783          	lhu	a5,-232(s0)
    80005b52:	e7a1                	bnez	a5,80005b9a <sys_unlink+0x1a6>
    80005b54:	29c1                	addiw	s3,s3,16
    80005b56:	04c92783          	lw	a5,76(s2)
    80005b5a:	fcf9ede3          	bltu	s3,a5,80005b34 <sys_unlink+0x140>
    80005b5e:	b781                	j	80005a9e <sys_unlink+0xaa>
    80005b60:	00003517          	auipc	a0,0x3
    80005b64:	cb050513          	addi	a0,a0,-848 # 80008810 <syscalls+0x320>
    80005b68:	ffffb097          	auipc	ra,0xffffb
    80005b6c:	a80080e7          	jalr	-1408(ra) # 800005e8 <panic>
    80005b70:	00003517          	auipc	a0,0x3
    80005b74:	cb850513          	addi	a0,a0,-840 # 80008828 <syscalls+0x338>
    80005b78:	ffffb097          	auipc	ra,0xffffb
    80005b7c:	a70080e7          	jalr	-1424(ra) # 800005e8 <panic>
    80005b80:	04a4d783          	lhu	a5,74(s1)
    80005b84:	37fd                	addiw	a5,a5,-1
    80005b86:	04f49523          	sh	a5,74(s1)
    80005b8a:	8526                	mv	a0,s1
    80005b8c:	ffffe097          	auipc	ra,0xffffe
    80005b90:	fce080e7          	jalr	-50(ra) # 80003b5a <iupdate>
    80005b94:	b781                	j	80005ad4 <sys_unlink+0xe0>
    80005b96:	557d                	li	a0,-1
    80005b98:	a005                	j	80005bb8 <sys_unlink+0x1c4>
    80005b9a:	854a                	mv	a0,s2
    80005b9c:	ffffe097          	auipc	ra,0xffffe
    80005ba0:	2ea080e7          	jalr	746(ra) # 80003e86 <iunlockput>
    80005ba4:	8526                	mv	a0,s1
    80005ba6:	ffffe097          	auipc	ra,0xffffe
    80005baa:	2e0080e7          	jalr	736(ra) # 80003e86 <iunlockput>
    80005bae:	fffff097          	auipc	ra,0xfffff
    80005bb2:	ab6080e7          	jalr	-1354(ra) # 80004664 <end_op>
    80005bb6:	557d                	li	a0,-1
    80005bb8:	70ae                	ld	ra,232(sp)
    80005bba:	740e                	ld	s0,224(sp)
    80005bbc:	64ee                	ld	s1,216(sp)
    80005bbe:	694e                	ld	s2,208(sp)
    80005bc0:	69ae                	ld	s3,200(sp)
    80005bc2:	616d                	addi	sp,sp,240
    80005bc4:	8082                	ret

0000000080005bc6 <sys_open>:
    80005bc6:	7131                	addi	sp,sp,-192
    80005bc8:	fd06                	sd	ra,184(sp)
    80005bca:	f922                	sd	s0,176(sp)
    80005bcc:	f526                	sd	s1,168(sp)
    80005bce:	f14a                	sd	s2,160(sp)
    80005bd0:	ed4e                	sd	s3,152(sp)
    80005bd2:	0180                	addi	s0,sp,192
    80005bd4:	08000613          	li	a2,128
    80005bd8:	f5040593          	addi	a1,s0,-176
    80005bdc:	4501                	li	a0,0
    80005bde:	ffffd097          	auipc	ra,0xffffd
    80005be2:	4d6080e7          	jalr	1238(ra) # 800030b4 <argstr>
    80005be6:	54fd                	li	s1,-1
    80005be8:	0c054163          	bltz	a0,80005caa <sys_open+0xe4>
    80005bec:	f4c40593          	addi	a1,s0,-180
    80005bf0:	4505                	li	a0,1
    80005bf2:	ffffd097          	auipc	ra,0xffffd
    80005bf6:	47e080e7          	jalr	1150(ra) # 80003070 <argint>
    80005bfa:	0a054863          	bltz	a0,80005caa <sys_open+0xe4>
    80005bfe:	fffff097          	auipc	ra,0xfffff
    80005c02:	9e6080e7          	jalr	-1562(ra) # 800045e4 <begin_op>
    80005c06:	f4c42783          	lw	a5,-180(s0)
    80005c0a:	2007f793          	andi	a5,a5,512
    80005c0e:	cbdd                	beqz	a5,80005cc4 <sys_open+0xfe>
    80005c10:	4681                	li	a3,0
    80005c12:	4601                	li	a2,0
    80005c14:	4589                	li	a1,2
    80005c16:	f5040513          	addi	a0,s0,-176
    80005c1a:	00000097          	auipc	ra,0x0
    80005c1e:	974080e7          	jalr	-1676(ra) # 8000558e <create>
    80005c22:	892a                	mv	s2,a0
    80005c24:	c959                	beqz	a0,80005cba <sys_open+0xf4>
    80005c26:	04491703          	lh	a4,68(s2)
    80005c2a:	478d                	li	a5,3
    80005c2c:	00f71763          	bne	a4,a5,80005c3a <sys_open+0x74>
    80005c30:	04695703          	lhu	a4,70(s2)
    80005c34:	47a5                	li	a5,9
    80005c36:	0ce7ec63          	bltu	a5,a4,80005d0e <sys_open+0x148>
    80005c3a:	fffff097          	auipc	ra,0xfffff
    80005c3e:	dc0080e7          	jalr	-576(ra) # 800049fa <filealloc>
    80005c42:	89aa                	mv	s3,a0
    80005c44:	10050263          	beqz	a0,80005d48 <sys_open+0x182>
    80005c48:	00000097          	auipc	ra,0x0
    80005c4c:	904080e7          	jalr	-1788(ra) # 8000554c <fdalloc>
    80005c50:	84aa                	mv	s1,a0
    80005c52:	0e054663          	bltz	a0,80005d3e <sys_open+0x178>
    80005c56:	04491703          	lh	a4,68(s2)
    80005c5a:	478d                	li	a5,3
    80005c5c:	0cf70463          	beq	a4,a5,80005d24 <sys_open+0x15e>
    80005c60:	4789                	li	a5,2
    80005c62:	00f9a023          	sw	a5,0(s3)
    80005c66:	0209a023          	sw	zero,32(s3)
    80005c6a:	0129bc23          	sd	s2,24(s3)
    80005c6e:	f4c42783          	lw	a5,-180(s0)
    80005c72:	0017c713          	xori	a4,a5,1
    80005c76:	8b05                	andi	a4,a4,1
    80005c78:	00e98423          	sb	a4,8(s3)
    80005c7c:	0037f713          	andi	a4,a5,3
    80005c80:	00e03733          	snez	a4,a4
    80005c84:	00e984a3          	sb	a4,9(s3)
    80005c88:	4007f793          	andi	a5,a5,1024
    80005c8c:	c791                	beqz	a5,80005c98 <sys_open+0xd2>
    80005c8e:	04491703          	lh	a4,68(s2)
    80005c92:	4789                	li	a5,2
    80005c94:	08f70f63          	beq	a4,a5,80005d32 <sys_open+0x16c>
    80005c98:	854a                	mv	a0,s2
    80005c9a:	ffffe097          	auipc	ra,0xffffe
    80005c9e:	04c080e7          	jalr	76(ra) # 80003ce6 <iunlock>
    80005ca2:	fffff097          	auipc	ra,0xfffff
    80005ca6:	9c2080e7          	jalr	-1598(ra) # 80004664 <end_op>
    80005caa:	8526                	mv	a0,s1
    80005cac:	70ea                	ld	ra,184(sp)
    80005cae:	744a                	ld	s0,176(sp)
    80005cb0:	74aa                	ld	s1,168(sp)
    80005cb2:	790a                	ld	s2,160(sp)
    80005cb4:	69ea                	ld	s3,152(sp)
    80005cb6:	6129                	addi	sp,sp,192
    80005cb8:	8082                	ret
    80005cba:	fffff097          	auipc	ra,0xfffff
    80005cbe:	9aa080e7          	jalr	-1622(ra) # 80004664 <end_op>
    80005cc2:	b7e5                	j	80005caa <sys_open+0xe4>
    80005cc4:	f5040513          	addi	a0,s0,-176
    80005cc8:	ffffe097          	auipc	ra,0xffffe
    80005ccc:	710080e7          	jalr	1808(ra) # 800043d8 <namei>
    80005cd0:	892a                	mv	s2,a0
    80005cd2:	c905                	beqz	a0,80005d02 <sys_open+0x13c>
    80005cd4:	ffffe097          	auipc	ra,0xffffe
    80005cd8:	f50080e7          	jalr	-176(ra) # 80003c24 <ilock>
    80005cdc:	04491703          	lh	a4,68(s2)
    80005ce0:	4785                	li	a5,1
    80005ce2:	f4f712e3          	bne	a4,a5,80005c26 <sys_open+0x60>
    80005ce6:	f4c42783          	lw	a5,-180(s0)
    80005cea:	dba1                	beqz	a5,80005c3a <sys_open+0x74>
    80005cec:	854a                	mv	a0,s2
    80005cee:	ffffe097          	auipc	ra,0xffffe
    80005cf2:	198080e7          	jalr	408(ra) # 80003e86 <iunlockput>
    80005cf6:	fffff097          	auipc	ra,0xfffff
    80005cfa:	96e080e7          	jalr	-1682(ra) # 80004664 <end_op>
    80005cfe:	54fd                	li	s1,-1
    80005d00:	b76d                	j	80005caa <sys_open+0xe4>
    80005d02:	fffff097          	auipc	ra,0xfffff
    80005d06:	962080e7          	jalr	-1694(ra) # 80004664 <end_op>
    80005d0a:	54fd                	li	s1,-1
    80005d0c:	bf79                	j	80005caa <sys_open+0xe4>
    80005d0e:	854a                	mv	a0,s2
    80005d10:	ffffe097          	auipc	ra,0xffffe
    80005d14:	176080e7          	jalr	374(ra) # 80003e86 <iunlockput>
    80005d18:	fffff097          	auipc	ra,0xfffff
    80005d1c:	94c080e7          	jalr	-1716(ra) # 80004664 <end_op>
    80005d20:	54fd                	li	s1,-1
    80005d22:	b761                	j	80005caa <sys_open+0xe4>
    80005d24:	00f9a023          	sw	a5,0(s3)
    80005d28:	04691783          	lh	a5,70(s2)
    80005d2c:	02f99223          	sh	a5,36(s3)
    80005d30:	bf2d                	j	80005c6a <sys_open+0xa4>
    80005d32:	854a                	mv	a0,s2
    80005d34:	ffffe097          	auipc	ra,0xffffe
    80005d38:	ffe080e7          	jalr	-2(ra) # 80003d32 <itrunc>
    80005d3c:	bfb1                	j	80005c98 <sys_open+0xd2>
    80005d3e:	854e                	mv	a0,s3
    80005d40:	fffff097          	auipc	ra,0xfffff
    80005d44:	d76080e7          	jalr	-650(ra) # 80004ab6 <fileclose>
    80005d48:	854a                	mv	a0,s2
    80005d4a:	ffffe097          	auipc	ra,0xffffe
    80005d4e:	13c080e7          	jalr	316(ra) # 80003e86 <iunlockput>
    80005d52:	fffff097          	auipc	ra,0xfffff
    80005d56:	912080e7          	jalr	-1774(ra) # 80004664 <end_op>
    80005d5a:	54fd                	li	s1,-1
    80005d5c:	b7b9                	j	80005caa <sys_open+0xe4>

0000000080005d5e <sys_mkdir>:
    80005d5e:	7175                	addi	sp,sp,-144
    80005d60:	e506                	sd	ra,136(sp)
    80005d62:	e122                	sd	s0,128(sp)
    80005d64:	0900                	addi	s0,sp,144
    80005d66:	fffff097          	auipc	ra,0xfffff
    80005d6a:	87e080e7          	jalr	-1922(ra) # 800045e4 <begin_op>
    80005d6e:	08000613          	li	a2,128
    80005d72:	f7040593          	addi	a1,s0,-144
    80005d76:	4501                	li	a0,0
    80005d78:	ffffd097          	auipc	ra,0xffffd
    80005d7c:	33c080e7          	jalr	828(ra) # 800030b4 <argstr>
    80005d80:	02054963          	bltz	a0,80005db2 <sys_mkdir+0x54>
    80005d84:	4681                	li	a3,0
    80005d86:	4601                	li	a2,0
    80005d88:	4585                	li	a1,1
    80005d8a:	f7040513          	addi	a0,s0,-144
    80005d8e:	00000097          	auipc	ra,0x0
    80005d92:	800080e7          	jalr	-2048(ra) # 8000558e <create>
    80005d96:	cd11                	beqz	a0,80005db2 <sys_mkdir+0x54>
    80005d98:	ffffe097          	auipc	ra,0xffffe
    80005d9c:	0ee080e7          	jalr	238(ra) # 80003e86 <iunlockput>
    80005da0:	fffff097          	auipc	ra,0xfffff
    80005da4:	8c4080e7          	jalr	-1852(ra) # 80004664 <end_op>
    80005da8:	4501                	li	a0,0
    80005daa:	60aa                	ld	ra,136(sp)
    80005dac:	640a                	ld	s0,128(sp)
    80005dae:	6149                	addi	sp,sp,144
    80005db0:	8082                	ret
    80005db2:	fffff097          	auipc	ra,0xfffff
    80005db6:	8b2080e7          	jalr	-1870(ra) # 80004664 <end_op>
    80005dba:	557d                	li	a0,-1
    80005dbc:	b7fd                	j	80005daa <sys_mkdir+0x4c>

0000000080005dbe <sys_mknod>:
    80005dbe:	7135                	addi	sp,sp,-160
    80005dc0:	ed06                	sd	ra,152(sp)
    80005dc2:	e922                	sd	s0,144(sp)
    80005dc4:	1100                	addi	s0,sp,160
    80005dc6:	fffff097          	auipc	ra,0xfffff
    80005dca:	81e080e7          	jalr	-2018(ra) # 800045e4 <begin_op>
    80005dce:	08000613          	li	a2,128
    80005dd2:	f7040593          	addi	a1,s0,-144
    80005dd6:	4501                	li	a0,0
    80005dd8:	ffffd097          	auipc	ra,0xffffd
    80005ddc:	2dc080e7          	jalr	732(ra) # 800030b4 <argstr>
    80005de0:	04054a63          	bltz	a0,80005e34 <sys_mknod+0x76>
    80005de4:	f6c40593          	addi	a1,s0,-148
    80005de8:	4505                	li	a0,1
    80005dea:	ffffd097          	auipc	ra,0xffffd
    80005dee:	286080e7          	jalr	646(ra) # 80003070 <argint>
    80005df2:	04054163          	bltz	a0,80005e34 <sys_mknod+0x76>
    80005df6:	f6840593          	addi	a1,s0,-152
    80005dfa:	4509                	li	a0,2
    80005dfc:	ffffd097          	auipc	ra,0xffffd
    80005e00:	274080e7          	jalr	628(ra) # 80003070 <argint>
    80005e04:	02054863          	bltz	a0,80005e34 <sys_mknod+0x76>
    80005e08:	f6841683          	lh	a3,-152(s0)
    80005e0c:	f6c41603          	lh	a2,-148(s0)
    80005e10:	458d                	li	a1,3
    80005e12:	f7040513          	addi	a0,s0,-144
    80005e16:	fffff097          	auipc	ra,0xfffff
    80005e1a:	778080e7          	jalr	1912(ra) # 8000558e <create>
    80005e1e:	c919                	beqz	a0,80005e34 <sys_mknod+0x76>
    80005e20:	ffffe097          	auipc	ra,0xffffe
    80005e24:	066080e7          	jalr	102(ra) # 80003e86 <iunlockput>
    80005e28:	fffff097          	auipc	ra,0xfffff
    80005e2c:	83c080e7          	jalr	-1988(ra) # 80004664 <end_op>
    80005e30:	4501                	li	a0,0
    80005e32:	a031                	j	80005e3e <sys_mknod+0x80>
    80005e34:	fffff097          	auipc	ra,0xfffff
    80005e38:	830080e7          	jalr	-2000(ra) # 80004664 <end_op>
    80005e3c:	557d                	li	a0,-1
    80005e3e:	60ea                	ld	ra,152(sp)
    80005e40:	644a                	ld	s0,144(sp)
    80005e42:	610d                	addi	sp,sp,160
    80005e44:	8082                	ret

0000000080005e46 <sys_chdir>:
    80005e46:	7135                	addi	sp,sp,-160
    80005e48:	ed06                	sd	ra,152(sp)
    80005e4a:	e922                	sd	s0,144(sp)
    80005e4c:	e526                	sd	s1,136(sp)
    80005e4e:	e14a                	sd	s2,128(sp)
    80005e50:	1100                	addi	s0,sp,160
    80005e52:	ffffc097          	auipc	ra,0xffffc
    80005e56:	0ac080e7          	jalr	172(ra) # 80001efe <myproc>
    80005e5a:	892a                	mv	s2,a0
    80005e5c:	ffffe097          	auipc	ra,0xffffe
    80005e60:	788080e7          	jalr	1928(ra) # 800045e4 <begin_op>
    80005e64:	08000613          	li	a2,128
    80005e68:	f6040593          	addi	a1,s0,-160
    80005e6c:	4501                	li	a0,0
    80005e6e:	ffffd097          	auipc	ra,0xffffd
    80005e72:	246080e7          	jalr	582(ra) # 800030b4 <argstr>
    80005e76:	04054b63          	bltz	a0,80005ecc <sys_chdir+0x86>
    80005e7a:	f6040513          	addi	a0,s0,-160
    80005e7e:	ffffe097          	auipc	ra,0xffffe
    80005e82:	55a080e7          	jalr	1370(ra) # 800043d8 <namei>
    80005e86:	84aa                	mv	s1,a0
    80005e88:	c131                	beqz	a0,80005ecc <sys_chdir+0x86>
    80005e8a:	ffffe097          	auipc	ra,0xffffe
    80005e8e:	d9a080e7          	jalr	-614(ra) # 80003c24 <ilock>
    80005e92:	04449703          	lh	a4,68(s1)
    80005e96:	4785                	li	a5,1
    80005e98:	04f71063          	bne	a4,a5,80005ed8 <sys_chdir+0x92>
    80005e9c:	8526                	mv	a0,s1
    80005e9e:	ffffe097          	auipc	ra,0xffffe
    80005ea2:	e48080e7          	jalr	-440(ra) # 80003ce6 <iunlock>
    80005ea6:	15093503          	ld	a0,336(s2)
    80005eaa:	ffffe097          	auipc	ra,0xffffe
    80005eae:	f34080e7          	jalr	-204(ra) # 80003dde <iput>
    80005eb2:	ffffe097          	auipc	ra,0xffffe
    80005eb6:	7b2080e7          	jalr	1970(ra) # 80004664 <end_op>
    80005eba:	14993823          	sd	s1,336(s2)
    80005ebe:	4501                	li	a0,0
    80005ec0:	60ea                	ld	ra,152(sp)
    80005ec2:	644a                	ld	s0,144(sp)
    80005ec4:	64aa                	ld	s1,136(sp)
    80005ec6:	690a                	ld	s2,128(sp)
    80005ec8:	610d                	addi	sp,sp,160
    80005eca:	8082                	ret
    80005ecc:	ffffe097          	auipc	ra,0xffffe
    80005ed0:	798080e7          	jalr	1944(ra) # 80004664 <end_op>
    80005ed4:	557d                	li	a0,-1
    80005ed6:	b7ed                	j	80005ec0 <sys_chdir+0x7a>
    80005ed8:	8526                	mv	a0,s1
    80005eda:	ffffe097          	auipc	ra,0xffffe
    80005ede:	fac080e7          	jalr	-84(ra) # 80003e86 <iunlockput>
    80005ee2:	ffffe097          	auipc	ra,0xffffe
    80005ee6:	782080e7          	jalr	1922(ra) # 80004664 <end_op>
    80005eea:	557d                	li	a0,-1
    80005eec:	bfd1                	j	80005ec0 <sys_chdir+0x7a>

0000000080005eee <sys_exec>:
    80005eee:	7145                	addi	sp,sp,-464
    80005ef0:	e786                	sd	ra,456(sp)
    80005ef2:	e3a2                	sd	s0,448(sp)
    80005ef4:	ff26                	sd	s1,440(sp)
    80005ef6:	fb4a                	sd	s2,432(sp)
    80005ef8:	f74e                	sd	s3,424(sp)
    80005efa:	f352                	sd	s4,416(sp)
    80005efc:	ef56                	sd	s5,408(sp)
    80005efe:	0b80                	addi	s0,sp,464
    80005f00:	08000613          	li	a2,128
    80005f04:	f4040593          	addi	a1,s0,-192
    80005f08:	4501                	li	a0,0
    80005f0a:	ffffd097          	auipc	ra,0xffffd
    80005f0e:	1aa080e7          	jalr	426(ra) # 800030b4 <argstr>
    80005f12:	597d                	li	s2,-1
    80005f14:	0c054a63          	bltz	a0,80005fe8 <sys_exec+0xfa>
    80005f18:	e3840593          	addi	a1,s0,-456
    80005f1c:	4505                	li	a0,1
    80005f1e:	ffffd097          	auipc	ra,0xffffd
    80005f22:	174080e7          	jalr	372(ra) # 80003092 <argaddr>
    80005f26:	0c054163          	bltz	a0,80005fe8 <sys_exec+0xfa>
    80005f2a:	10000613          	li	a2,256
    80005f2e:	4581                	li	a1,0
    80005f30:	e4040513          	addi	a0,s0,-448
    80005f34:	ffffb097          	auipc	ra,0xffffb
    80005f38:	146080e7          	jalr	326(ra) # 8000107a <memset>
    80005f3c:	e4040493          	addi	s1,s0,-448
    80005f40:	89a6                	mv	s3,s1
    80005f42:	4901                	li	s2,0
    80005f44:	02000a13          	li	s4,32
    80005f48:	00090a9b          	sext.w	s5,s2
    80005f4c:	00391793          	slli	a5,s2,0x3
    80005f50:	e3040593          	addi	a1,s0,-464
    80005f54:	e3843503          	ld	a0,-456(s0)
    80005f58:	953e                	add	a0,a0,a5
    80005f5a:	ffffd097          	auipc	ra,0xffffd
    80005f5e:	07c080e7          	jalr	124(ra) # 80002fd6 <fetchaddr>
    80005f62:	02054a63          	bltz	a0,80005f96 <sys_exec+0xa8>
    80005f66:	e3043783          	ld	a5,-464(s0)
    80005f6a:	c3b9                	beqz	a5,80005fb0 <sys_exec+0xc2>
    80005f6c:	ffffb097          	auipc	ra,0xffffb
    80005f70:	e00080e7          	jalr	-512(ra) # 80000d6c <kalloc>
    80005f74:	85aa                	mv	a1,a0
    80005f76:	00a9b023          	sd	a0,0(s3)
    80005f7a:	cd11                	beqz	a0,80005f96 <sys_exec+0xa8>
    80005f7c:	6605                	lui	a2,0x1
    80005f7e:	e3043503          	ld	a0,-464(s0)
    80005f82:	ffffd097          	auipc	ra,0xffffd
    80005f86:	0a6080e7          	jalr	166(ra) # 80003028 <fetchstr>
    80005f8a:	00054663          	bltz	a0,80005f96 <sys_exec+0xa8>
    80005f8e:	0905                	addi	s2,s2,1
    80005f90:	09a1                	addi	s3,s3,8
    80005f92:	fb491be3          	bne	s2,s4,80005f48 <sys_exec+0x5a>
    80005f96:	10048913          	addi	s2,s1,256
    80005f9a:	6088                	ld	a0,0(s1)
    80005f9c:	c529                	beqz	a0,80005fe6 <sys_exec+0xf8>
    80005f9e:	ffffb097          	auipc	ra,0xffffb
    80005fa2:	af0080e7          	jalr	-1296(ra) # 80000a8e <kfree>
    80005fa6:	04a1                	addi	s1,s1,8
    80005fa8:	ff2499e3          	bne	s1,s2,80005f9a <sys_exec+0xac>
    80005fac:	597d                	li	s2,-1
    80005fae:	a82d                	j	80005fe8 <sys_exec+0xfa>
    80005fb0:	0a8e                	slli	s5,s5,0x3
    80005fb2:	fc040793          	addi	a5,s0,-64
    80005fb6:	9abe                	add	s5,s5,a5
    80005fb8:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffb8e80>
    80005fbc:	e4040593          	addi	a1,s0,-448
    80005fc0:	f4040513          	addi	a0,s0,-192
    80005fc4:	fffff097          	auipc	ra,0xfffff
    80005fc8:	178080e7          	jalr	376(ra) # 8000513c <exec>
    80005fcc:	892a                	mv	s2,a0
    80005fce:	10048993          	addi	s3,s1,256
    80005fd2:	6088                	ld	a0,0(s1)
    80005fd4:	c911                	beqz	a0,80005fe8 <sys_exec+0xfa>
    80005fd6:	ffffb097          	auipc	ra,0xffffb
    80005fda:	ab8080e7          	jalr	-1352(ra) # 80000a8e <kfree>
    80005fde:	04a1                	addi	s1,s1,8
    80005fe0:	ff3499e3          	bne	s1,s3,80005fd2 <sys_exec+0xe4>
    80005fe4:	a011                	j	80005fe8 <sys_exec+0xfa>
    80005fe6:	597d                	li	s2,-1
    80005fe8:	854a                	mv	a0,s2
    80005fea:	60be                	ld	ra,456(sp)
    80005fec:	641e                	ld	s0,448(sp)
    80005fee:	74fa                	ld	s1,440(sp)
    80005ff0:	795a                	ld	s2,432(sp)
    80005ff2:	79ba                	ld	s3,424(sp)
    80005ff4:	7a1a                	ld	s4,416(sp)
    80005ff6:	6afa                	ld	s5,408(sp)
    80005ff8:	6179                	addi	sp,sp,464
    80005ffa:	8082                	ret

0000000080005ffc <sys_pipe>:
    80005ffc:	7139                	addi	sp,sp,-64
    80005ffe:	fc06                	sd	ra,56(sp)
    80006000:	f822                	sd	s0,48(sp)
    80006002:	f426                	sd	s1,40(sp)
    80006004:	0080                	addi	s0,sp,64
    80006006:	ffffc097          	auipc	ra,0xffffc
    8000600a:	ef8080e7          	jalr	-264(ra) # 80001efe <myproc>
    8000600e:	84aa                	mv	s1,a0
    80006010:	fd840593          	addi	a1,s0,-40
    80006014:	4501                	li	a0,0
    80006016:	ffffd097          	auipc	ra,0xffffd
    8000601a:	07c080e7          	jalr	124(ra) # 80003092 <argaddr>
    8000601e:	57fd                	li	a5,-1
    80006020:	0e054063          	bltz	a0,80006100 <sys_pipe+0x104>
    80006024:	fc840593          	addi	a1,s0,-56
    80006028:	fd040513          	addi	a0,s0,-48
    8000602c:	fffff097          	auipc	ra,0xfffff
    80006030:	de0080e7          	jalr	-544(ra) # 80004e0c <pipealloc>
    80006034:	57fd                	li	a5,-1
    80006036:	0c054563          	bltz	a0,80006100 <sys_pipe+0x104>
    8000603a:	fcf42223          	sw	a5,-60(s0)
    8000603e:	fd043503          	ld	a0,-48(s0)
    80006042:	fffff097          	auipc	ra,0xfffff
    80006046:	50a080e7          	jalr	1290(ra) # 8000554c <fdalloc>
    8000604a:	fca42223          	sw	a0,-60(s0)
    8000604e:	08054c63          	bltz	a0,800060e6 <sys_pipe+0xea>
    80006052:	fc843503          	ld	a0,-56(s0)
    80006056:	fffff097          	auipc	ra,0xfffff
    8000605a:	4f6080e7          	jalr	1270(ra) # 8000554c <fdalloc>
    8000605e:	fca42023          	sw	a0,-64(s0)
    80006062:	06054863          	bltz	a0,800060d2 <sys_pipe+0xd6>
    80006066:	4691                	li	a3,4
    80006068:	fc440613          	addi	a2,s0,-60
    8000606c:	fd843583          	ld	a1,-40(s0)
    80006070:	68a8                	ld	a0,80(s1)
    80006072:	ffffc097          	auipc	ra,0xffffc
    80006076:	c58080e7          	jalr	-936(ra) # 80001cca <copyout>
    8000607a:	02054063          	bltz	a0,8000609a <sys_pipe+0x9e>
    8000607e:	4691                	li	a3,4
    80006080:	fc040613          	addi	a2,s0,-64
    80006084:	fd843583          	ld	a1,-40(s0)
    80006088:	0591                	addi	a1,a1,4
    8000608a:	68a8                	ld	a0,80(s1)
    8000608c:	ffffc097          	auipc	ra,0xffffc
    80006090:	c3e080e7          	jalr	-962(ra) # 80001cca <copyout>
    80006094:	4781                	li	a5,0
    80006096:	06055563          	bgez	a0,80006100 <sys_pipe+0x104>
    8000609a:	fc442783          	lw	a5,-60(s0)
    8000609e:	07e9                	addi	a5,a5,26
    800060a0:	078e                	slli	a5,a5,0x3
    800060a2:	97a6                	add	a5,a5,s1
    800060a4:	0007b023          	sd	zero,0(a5)
    800060a8:	fc042503          	lw	a0,-64(s0)
    800060ac:	0569                	addi	a0,a0,26
    800060ae:	050e                	slli	a0,a0,0x3
    800060b0:	9526                	add	a0,a0,s1
    800060b2:	00053023          	sd	zero,0(a0)
    800060b6:	fd043503          	ld	a0,-48(s0)
    800060ba:	fffff097          	auipc	ra,0xfffff
    800060be:	9fc080e7          	jalr	-1540(ra) # 80004ab6 <fileclose>
    800060c2:	fc843503          	ld	a0,-56(s0)
    800060c6:	fffff097          	auipc	ra,0xfffff
    800060ca:	9f0080e7          	jalr	-1552(ra) # 80004ab6 <fileclose>
    800060ce:	57fd                	li	a5,-1
    800060d0:	a805                	j	80006100 <sys_pipe+0x104>
    800060d2:	fc442783          	lw	a5,-60(s0)
    800060d6:	0007c863          	bltz	a5,800060e6 <sys_pipe+0xea>
    800060da:	01a78513          	addi	a0,a5,26
    800060de:	050e                	slli	a0,a0,0x3
    800060e0:	9526                	add	a0,a0,s1
    800060e2:	00053023          	sd	zero,0(a0)
    800060e6:	fd043503          	ld	a0,-48(s0)
    800060ea:	fffff097          	auipc	ra,0xfffff
    800060ee:	9cc080e7          	jalr	-1588(ra) # 80004ab6 <fileclose>
    800060f2:	fc843503          	ld	a0,-56(s0)
    800060f6:	fffff097          	auipc	ra,0xfffff
    800060fa:	9c0080e7          	jalr	-1600(ra) # 80004ab6 <fileclose>
    800060fe:	57fd                	li	a5,-1
    80006100:	853e                	mv	a0,a5
    80006102:	70e2                	ld	ra,56(sp)
    80006104:	7442                	ld	s0,48(sp)
    80006106:	74a2                	ld	s1,40(sp)
    80006108:	6121                	addi	sp,sp,64
    8000610a:	8082                	ret
    8000610c:	0000                	unimp
	...

0000000080006110 <kernelvec>:
    80006110:	7111                	addi	sp,sp,-256
    80006112:	e006                	sd	ra,0(sp)
    80006114:	e40a                	sd	sp,8(sp)
    80006116:	e80e                	sd	gp,16(sp)
    80006118:	ec12                	sd	tp,24(sp)
    8000611a:	f016                	sd	t0,32(sp)
    8000611c:	f41a                	sd	t1,40(sp)
    8000611e:	f81e                	sd	t2,48(sp)
    80006120:	fc22                	sd	s0,56(sp)
    80006122:	e0a6                	sd	s1,64(sp)
    80006124:	e4aa                	sd	a0,72(sp)
    80006126:	e8ae                	sd	a1,80(sp)
    80006128:	ecb2                	sd	a2,88(sp)
    8000612a:	f0b6                	sd	a3,96(sp)
    8000612c:	f4ba                	sd	a4,104(sp)
    8000612e:	f8be                	sd	a5,112(sp)
    80006130:	fcc2                	sd	a6,120(sp)
    80006132:	e146                	sd	a7,128(sp)
    80006134:	e54a                	sd	s2,136(sp)
    80006136:	e94e                	sd	s3,144(sp)
    80006138:	ed52                	sd	s4,152(sp)
    8000613a:	f156                	sd	s5,160(sp)
    8000613c:	f55a                	sd	s6,168(sp)
    8000613e:	f95e                	sd	s7,176(sp)
    80006140:	fd62                	sd	s8,184(sp)
    80006142:	e1e6                	sd	s9,192(sp)
    80006144:	e5ea                	sd	s10,200(sp)
    80006146:	e9ee                	sd	s11,208(sp)
    80006148:	edf2                	sd	t3,216(sp)
    8000614a:	f1f6                	sd	t4,224(sp)
    8000614c:	f5fa                	sd	t5,232(sp)
    8000614e:	f9fe                	sd	t6,240(sp)
    80006150:	d53fc0ef          	jal	ra,80002ea2 <kerneltrap>
    80006154:	6082                	ld	ra,0(sp)
    80006156:	6122                	ld	sp,8(sp)
    80006158:	61c2                	ld	gp,16(sp)
    8000615a:	7282                	ld	t0,32(sp)
    8000615c:	7322                	ld	t1,40(sp)
    8000615e:	73c2                	ld	t2,48(sp)
    80006160:	7462                	ld	s0,56(sp)
    80006162:	6486                	ld	s1,64(sp)
    80006164:	6526                	ld	a0,72(sp)
    80006166:	65c6                	ld	a1,80(sp)
    80006168:	6666                	ld	a2,88(sp)
    8000616a:	7686                	ld	a3,96(sp)
    8000616c:	7726                	ld	a4,104(sp)
    8000616e:	77c6                	ld	a5,112(sp)
    80006170:	7866                	ld	a6,120(sp)
    80006172:	688a                	ld	a7,128(sp)
    80006174:	692a                	ld	s2,136(sp)
    80006176:	69ca                	ld	s3,144(sp)
    80006178:	6a6a                	ld	s4,152(sp)
    8000617a:	7a8a                	ld	s5,160(sp)
    8000617c:	7b2a                	ld	s6,168(sp)
    8000617e:	7bca                	ld	s7,176(sp)
    80006180:	7c6a                	ld	s8,184(sp)
    80006182:	6c8e                	ld	s9,192(sp)
    80006184:	6d2e                	ld	s10,200(sp)
    80006186:	6dce                	ld	s11,208(sp)
    80006188:	6e6e                	ld	t3,216(sp)
    8000618a:	7e8e                	ld	t4,224(sp)
    8000618c:	7f2e                	ld	t5,232(sp)
    8000618e:	7fce                	ld	t6,240(sp)
    80006190:	6111                	addi	sp,sp,256
    80006192:	10200073          	sret
    80006196:	00000013          	nop
    8000619a:	00000013          	nop
    8000619e:	0001                	nop

00000000800061a0 <timervec>:
    800061a0:	34051573          	csrrw	a0,mscratch,a0
    800061a4:	e10c                	sd	a1,0(a0)
    800061a6:	e510                	sd	a2,8(a0)
    800061a8:	e914                	sd	a3,16(a0)
    800061aa:	710c                	ld	a1,32(a0)
    800061ac:	7510                	ld	a2,40(a0)
    800061ae:	6194                	ld	a3,0(a1)
    800061b0:	96b2                	add	a3,a3,a2
    800061b2:	e194                	sd	a3,0(a1)
    800061b4:	4589                	li	a1,2
    800061b6:	14459073          	csrw	sip,a1
    800061ba:	6914                	ld	a3,16(a0)
    800061bc:	6510                	ld	a2,8(a0)
    800061be:	610c                	ld	a1,0(a0)
    800061c0:	34051573          	csrrw	a0,mscratch,a0
    800061c4:	30200073          	mret
	...

00000000800061ca <plicinit>:
    800061ca:	1141                	addi	sp,sp,-16
    800061cc:	e422                	sd	s0,8(sp)
    800061ce:	0800                	addi	s0,sp,16
    800061d0:	0c0007b7          	lui	a5,0xc000
    800061d4:	4705                	li	a4,1
    800061d6:	d798                	sw	a4,40(a5)
    800061d8:	c3d8                	sw	a4,4(a5)
    800061da:	6422                	ld	s0,8(sp)
    800061dc:	0141                	addi	sp,sp,16
    800061de:	8082                	ret

00000000800061e0 <plicinithart>:
    800061e0:	1141                	addi	sp,sp,-16
    800061e2:	e406                	sd	ra,8(sp)
    800061e4:	e022                	sd	s0,0(sp)
    800061e6:	0800                	addi	s0,sp,16
    800061e8:	ffffc097          	auipc	ra,0xffffc
    800061ec:	cea080e7          	jalr	-790(ra) # 80001ed2 <cpuid>
    800061f0:	0085171b          	slliw	a4,a0,0x8
    800061f4:	0c0027b7          	lui	a5,0xc002
    800061f8:	97ba                	add	a5,a5,a4
    800061fa:	40200713          	li	a4,1026
    800061fe:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>
    80006202:	00d5151b          	slliw	a0,a0,0xd
    80006206:	0c2017b7          	lui	a5,0xc201
    8000620a:	953e                	add	a0,a0,a5
    8000620c:	00052023          	sw	zero,0(a0)
    80006210:	60a2                	ld	ra,8(sp)
    80006212:	6402                	ld	s0,0(sp)
    80006214:	0141                	addi	sp,sp,16
    80006216:	8082                	ret

0000000080006218 <plic_claim>:
    80006218:	1141                	addi	sp,sp,-16
    8000621a:	e406                	sd	ra,8(sp)
    8000621c:	e022                	sd	s0,0(sp)
    8000621e:	0800                	addi	s0,sp,16
    80006220:	ffffc097          	auipc	ra,0xffffc
    80006224:	cb2080e7          	jalr	-846(ra) # 80001ed2 <cpuid>
    80006228:	00d5179b          	slliw	a5,a0,0xd
    8000622c:	0c201537          	lui	a0,0xc201
    80006230:	953e                	add	a0,a0,a5
    80006232:	4148                	lw	a0,4(a0)
    80006234:	60a2                	ld	ra,8(sp)
    80006236:	6402                	ld	s0,0(sp)
    80006238:	0141                	addi	sp,sp,16
    8000623a:	8082                	ret

000000008000623c <plic_complete>:
    8000623c:	1101                	addi	sp,sp,-32
    8000623e:	ec06                	sd	ra,24(sp)
    80006240:	e822                	sd	s0,16(sp)
    80006242:	e426                	sd	s1,8(sp)
    80006244:	1000                	addi	s0,sp,32
    80006246:	84aa                	mv	s1,a0
    80006248:	ffffc097          	auipc	ra,0xffffc
    8000624c:	c8a080e7          	jalr	-886(ra) # 80001ed2 <cpuid>
    80006250:	00d5151b          	slliw	a0,a0,0xd
    80006254:	0c2017b7          	lui	a5,0xc201
    80006258:	97aa                	add	a5,a5,a0
    8000625a:	c3c4                	sw	s1,4(a5)
    8000625c:	60e2                	ld	ra,24(sp)
    8000625e:	6442                	ld	s0,16(sp)
    80006260:	64a2                	ld	s1,8(sp)
    80006262:	6105                	addi	sp,sp,32
    80006264:	8082                	ret

0000000080006266 <free_desc>:
    80006266:	1141                	addi	sp,sp,-16
    80006268:	e406                	sd	ra,8(sp)
    8000626a:	e022                	sd	s0,0(sp)
    8000626c:	0800                	addi	s0,sp,16
    8000626e:	479d                	li	a5,7
    80006270:	04a7cc63          	blt	a5,a0,800062c8 <free_desc+0x62>
    80006274:	0003d797          	auipc	a5,0x3d
    80006278:	d8c78793          	addi	a5,a5,-628 # 80043000 <disk>
    8000627c:	00a78733          	add	a4,a5,a0
    80006280:	6789                	lui	a5,0x2
    80006282:	97ba                	add	a5,a5,a4
    80006284:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80006288:	eba1                	bnez	a5,800062d8 <free_desc+0x72>
    8000628a:	00451713          	slli	a4,a0,0x4
    8000628e:	0003f797          	auipc	a5,0x3f
    80006292:	d727b783          	ld	a5,-654(a5) # 80045000 <disk+0x2000>
    80006296:	97ba                	add	a5,a5,a4
    80006298:	0007b023          	sd	zero,0(a5)
    8000629c:	0003d797          	auipc	a5,0x3d
    800062a0:	d6478793          	addi	a5,a5,-668 # 80043000 <disk>
    800062a4:	97aa                	add	a5,a5,a0
    800062a6:	6509                	lui	a0,0x2
    800062a8:	953e                	add	a0,a0,a5
    800062aa:	4785                	li	a5,1
    800062ac:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
    800062b0:	0003f517          	auipc	a0,0x3f
    800062b4:	d6850513          	addi	a0,a0,-664 # 80045018 <disk+0x2018>
    800062b8:	ffffc097          	auipc	ra,0xffffc
    800062bc:	5da080e7          	jalr	1498(ra) # 80002892 <wakeup>
    800062c0:	60a2                	ld	ra,8(sp)
    800062c2:	6402                	ld	s0,0(sp)
    800062c4:	0141                	addi	sp,sp,16
    800062c6:	8082                	ret
    800062c8:	00002517          	auipc	a0,0x2
    800062cc:	57050513          	addi	a0,a0,1392 # 80008838 <syscalls+0x348>
    800062d0:	ffffa097          	auipc	ra,0xffffa
    800062d4:	318080e7          	jalr	792(ra) # 800005e8 <panic>
    800062d8:	00002517          	auipc	a0,0x2
    800062dc:	57850513          	addi	a0,a0,1400 # 80008850 <syscalls+0x360>
    800062e0:	ffffa097          	auipc	ra,0xffffa
    800062e4:	308080e7          	jalr	776(ra) # 800005e8 <panic>

00000000800062e8 <virtio_disk_init>:
    800062e8:	1101                	addi	sp,sp,-32
    800062ea:	ec06                	sd	ra,24(sp)
    800062ec:	e822                	sd	s0,16(sp)
    800062ee:	e426                	sd	s1,8(sp)
    800062f0:	1000                	addi	s0,sp,32
    800062f2:	00002597          	auipc	a1,0x2
    800062f6:	57658593          	addi	a1,a1,1398 # 80008868 <syscalls+0x378>
    800062fa:	0003f517          	auipc	a0,0x3f
    800062fe:	dae50513          	addi	a0,a0,-594 # 800450a8 <disk+0x20a8>
    80006302:	ffffb097          	auipc	ra,0xffffb
    80006306:	bec080e7          	jalr	-1044(ra) # 80000eee <initlock>
    8000630a:	100017b7          	lui	a5,0x10001
    8000630e:	4398                	lw	a4,0(a5)
    80006310:	2701                	sext.w	a4,a4
    80006312:	747277b7          	lui	a5,0x74727
    80006316:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000631a:	0ef71163          	bne	a4,a5,800063fc <virtio_disk_init+0x114>
    8000631e:	100017b7          	lui	a5,0x10001
    80006322:	43dc                	lw	a5,4(a5)
    80006324:	2781                	sext.w	a5,a5
    80006326:	4705                	li	a4,1
    80006328:	0ce79a63          	bne	a5,a4,800063fc <virtio_disk_init+0x114>
    8000632c:	100017b7          	lui	a5,0x10001
    80006330:	479c                	lw	a5,8(a5)
    80006332:	2781                	sext.w	a5,a5
    80006334:	4709                	li	a4,2
    80006336:	0ce79363          	bne	a5,a4,800063fc <virtio_disk_init+0x114>
    8000633a:	100017b7          	lui	a5,0x10001
    8000633e:	47d8                	lw	a4,12(a5)
    80006340:	2701                	sext.w	a4,a4
    80006342:	554d47b7          	lui	a5,0x554d4
    80006346:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000634a:	0af71963          	bne	a4,a5,800063fc <virtio_disk_init+0x114>
    8000634e:	100017b7          	lui	a5,0x10001
    80006352:	4705                	li	a4,1
    80006354:	dbb8                	sw	a4,112(a5)
    80006356:	470d                	li	a4,3
    80006358:	dbb8                	sw	a4,112(a5)
    8000635a:	4b94                	lw	a3,16(a5)
    8000635c:	c7ffe737          	lui	a4,0xc7ffe
    80006360:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fb875f>
    80006364:	8f75                	and	a4,a4,a3
    80006366:	2701                	sext.w	a4,a4
    80006368:	d398                	sw	a4,32(a5)
    8000636a:	472d                	li	a4,11
    8000636c:	dbb8                	sw	a4,112(a5)
    8000636e:	473d                	li	a4,15
    80006370:	dbb8                	sw	a4,112(a5)
    80006372:	6705                	lui	a4,0x1
    80006374:	d798                	sw	a4,40(a5)
    80006376:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
    8000637a:	5bdc                	lw	a5,52(a5)
    8000637c:	2781                	sext.w	a5,a5
    8000637e:	c7d9                	beqz	a5,8000640c <virtio_disk_init+0x124>
    80006380:	471d                	li	a4,7
    80006382:	08f77d63          	bgeu	a4,a5,8000641c <virtio_disk_init+0x134>
    80006386:	100014b7          	lui	s1,0x10001
    8000638a:	47a1                	li	a5,8
    8000638c:	dc9c                	sw	a5,56(s1)
    8000638e:	6609                	lui	a2,0x2
    80006390:	4581                	li	a1,0
    80006392:	0003d517          	auipc	a0,0x3d
    80006396:	c6e50513          	addi	a0,a0,-914 # 80043000 <disk>
    8000639a:	ffffb097          	auipc	ra,0xffffb
    8000639e:	ce0080e7          	jalr	-800(ra) # 8000107a <memset>
    800063a2:	0003d717          	auipc	a4,0x3d
    800063a6:	c5e70713          	addi	a4,a4,-930 # 80043000 <disk>
    800063aa:	00c75793          	srli	a5,a4,0xc
    800063ae:	2781                	sext.w	a5,a5
    800063b0:	c0bc                	sw	a5,64(s1)
    800063b2:	0003f797          	auipc	a5,0x3f
    800063b6:	c4e78793          	addi	a5,a5,-946 # 80045000 <disk+0x2000>
    800063ba:	e398                	sd	a4,0(a5)
    800063bc:	0003d717          	auipc	a4,0x3d
    800063c0:	cc470713          	addi	a4,a4,-828 # 80043080 <disk+0x80>
    800063c4:	e798                	sd	a4,8(a5)
    800063c6:	0003e717          	auipc	a4,0x3e
    800063ca:	c3a70713          	addi	a4,a4,-966 # 80044000 <disk+0x1000>
    800063ce:	eb98                	sd	a4,16(a5)
    800063d0:	4705                	li	a4,1
    800063d2:	00e78c23          	sb	a4,24(a5)
    800063d6:	00e78ca3          	sb	a4,25(a5)
    800063da:	00e78d23          	sb	a4,26(a5)
    800063de:	00e78da3          	sb	a4,27(a5)
    800063e2:	00e78e23          	sb	a4,28(a5)
    800063e6:	00e78ea3          	sb	a4,29(a5)
    800063ea:	00e78f23          	sb	a4,30(a5)
    800063ee:	00e78fa3          	sb	a4,31(a5)
    800063f2:	60e2                	ld	ra,24(sp)
    800063f4:	6442                	ld	s0,16(sp)
    800063f6:	64a2                	ld	s1,8(sp)
    800063f8:	6105                	addi	sp,sp,32
    800063fa:	8082                	ret
    800063fc:	00002517          	auipc	a0,0x2
    80006400:	47c50513          	addi	a0,a0,1148 # 80008878 <syscalls+0x388>
    80006404:	ffffa097          	auipc	ra,0xffffa
    80006408:	1e4080e7          	jalr	484(ra) # 800005e8 <panic>
    8000640c:	00002517          	auipc	a0,0x2
    80006410:	48c50513          	addi	a0,a0,1164 # 80008898 <syscalls+0x3a8>
    80006414:	ffffa097          	auipc	ra,0xffffa
    80006418:	1d4080e7          	jalr	468(ra) # 800005e8 <panic>
    8000641c:	00002517          	auipc	a0,0x2
    80006420:	49c50513          	addi	a0,a0,1180 # 800088b8 <syscalls+0x3c8>
    80006424:	ffffa097          	auipc	ra,0xffffa
    80006428:	1c4080e7          	jalr	452(ra) # 800005e8 <panic>

000000008000642c <virtio_disk_rw>:
    8000642c:	7175                	addi	sp,sp,-144
    8000642e:	e506                	sd	ra,136(sp)
    80006430:	e122                	sd	s0,128(sp)
    80006432:	fca6                	sd	s1,120(sp)
    80006434:	f8ca                	sd	s2,112(sp)
    80006436:	f4ce                	sd	s3,104(sp)
    80006438:	f0d2                	sd	s4,96(sp)
    8000643a:	ecd6                	sd	s5,88(sp)
    8000643c:	e8da                	sd	s6,80(sp)
    8000643e:	e4de                	sd	s7,72(sp)
    80006440:	e0e2                	sd	s8,64(sp)
    80006442:	fc66                	sd	s9,56(sp)
    80006444:	f86a                	sd	s10,48(sp)
    80006446:	f46e                	sd	s11,40(sp)
    80006448:	0900                	addi	s0,sp,144
    8000644a:	8aaa                	mv	s5,a0
    8000644c:	8d2e                	mv	s10,a1
    8000644e:	00c52c83          	lw	s9,12(a0)
    80006452:	001c9c9b          	slliw	s9,s9,0x1
    80006456:	1c82                	slli	s9,s9,0x20
    80006458:	020cdc93          	srli	s9,s9,0x20
    8000645c:	0003f517          	auipc	a0,0x3f
    80006460:	c4c50513          	addi	a0,a0,-948 # 800450a8 <disk+0x20a8>
    80006464:	ffffb097          	auipc	ra,0xffffb
    80006468:	b1a080e7          	jalr	-1254(ra) # 80000f7e <acquire>
    8000646c:	4981                	li	s3,0
    8000646e:	44a1                	li	s1,8
    80006470:	0003dc17          	auipc	s8,0x3d
    80006474:	b90c0c13          	addi	s8,s8,-1136 # 80043000 <disk>
    80006478:	6b89                	lui	s7,0x2
    8000647a:	4b0d                	li	s6,3
    8000647c:	a0ad                	j	800064e6 <virtio_disk_rw+0xba>
    8000647e:	00fc0733          	add	a4,s8,a5
    80006482:	975e                	add	a4,a4,s7
    80006484:	00070c23          	sb	zero,24(a4)
    80006488:	c19c                	sw	a5,0(a1)
    8000648a:	0207c563          	bltz	a5,800064b4 <virtio_disk_rw+0x88>
    8000648e:	2905                	addiw	s2,s2,1
    80006490:	0611                	addi	a2,a2,4
    80006492:	19690d63          	beq	s2,s6,8000662c <virtio_disk_rw+0x200>
    80006496:	85b2                	mv	a1,a2
    80006498:	0003f717          	auipc	a4,0x3f
    8000649c:	b8070713          	addi	a4,a4,-1152 # 80045018 <disk+0x2018>
    800064a0:	87ce                	mv	a5,s3
    800064a2:	00074683          	lbu	a3,0(a4)
    800064a6:	fee1                	bnez	a3,8000647e <virtio_disk_rw+0x52>
    800064a8:	2785                	addiw	a5,a5,1
    800064aa:	0705                	addi	a4,a4,1
    800064ac:	fe979be3          	bne	a5,s1,800064a2 <virtio_disk_rw+0x76>
    800064b0:	57fd                	li	a5,-1
    800064b2:	c19c                	sw	a5,0(a1)
    800064b4:	01205d63          	blez	s2,800064ce <virtio_disk_rw+0xa2>
    800064b8:	8dce                	mv	s11,s3
    800064ba:	000a2503          	lw	a0,0(s4)
    800064be:	00000097          	auipc	ra,0x0
    800064c2:	da8080e7          	jalr	-600(ra) # 80006266 <free_desc>
    800064c6:	2d85                	addiw	s11,s11,1
    800064c8:	0a11                	addi	s4,s4,4
    800064ca:	ffb918e3          	bne	s2,s11,800064ba <virtio_disk_rw+0x8e>
    800064ce:	0003f597          	auipc	a1,0x3f
    800064d2:	bda58593          	addi	a1,a1,-1062 # 800450a8 <disk+0x20a8>
    800064d6:	0003f517          	auipc	a0,0x3f
    800064da:	b4250513          	addi	a0,a0,-1214 # 80045018 <disk+0x2018>
    800064de:	ffffc097          	auipc	ra,0xffffc
    800064e2:	234080e7          	jalr	564(ra) # 80002712 <sleep>
    800064e6:	f8040a13          	addi	s4,s0,-128
    800064ea:	8652                	mv	a2,s4
    800064ec:	894e                	mv	s2,s3
    800064ee:	b765                	j	80006496 <virtio_disk_rw+0x6a>
    800064f0:	0003f717          	auipc	a4,0x3f
    800064f4:	b1073703          	ld	a4,-1264(a4) # 80045000 <disk+0x2000>
    800064f8:	973e                	add	a4,a4,a5
    800064fa:	00071623          	sh	zero,12(a4)
    800064fe:	0003d517          	auipc	a0,0x3d
    80006502:	b0250513          	addi	a0,a0,-1278 # 80043000 <disk>
    80006506:	0003f717          	auipc	a4,0x3f
    8000650a:	afa70713          	addi	a4,a4,-1286 # 80045000 <disk+0x2000>
    8000650e:	6314                	ld	a3,0(a4)
    80006510:	96be                	add	a3,a3,a5
    80006512:	00c6d603          	lhu	a2,12(a3)
    80006516:	00166613          	ori	a2,a2,1
    8000651a:	00c69623          	sh	a2,12(a3)
    8000651e:	f8842683          	lw	a3,-120(s0)
    80006522:	6310                	ld	a2,0(a4)
    80006524:	97b2                	add	a5,a5,a2
    80006526:	00d79723          	sh	a3,14(a5)
    8000652a:	20048613          	addi	a2,s1,512 # 10001200 <_entry-0x6fffee00>
    8000652e:	0612                	slli	a2,a2,0x4
    80006530:	962a                	add	a2,a2,a0
    80006532:	02060823          	sb	zero,48(a2) # 2030 <_entry-0x7fffdfd0>
    80006536:	00469793          	slli	a5,a3,0x4
    8000653a:	630c                	ld	a1,0(a4)
    8000653c:	95be                	add	a1,a1,a5
    8000653e:	6689                	lui	a3,0x2
    80006540:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80006544:	96ca                	add	a3,a3,s2
    80006546:	96aa                	add	a3,a3,a0
    80006548:	e194                	sd	a3,0(a1)
    8000654a:	6314                	ld	a3,0(a4)
    8000654c:	96be                	add	a3,a3,a5
    8000654e:	4585                	li	a1,1
    80006550:	c68c                	sw	a1,8(a3)
    80006552:	6314                	ld	a3,0(a4)
    80006554:	96be                	add	a3,a3,a5
    80006556:	4509                	li	a0,2
    80006558:	00a69623          	sh	a0,12(a3)
    8000655c:	6314                	ld	a3,0(a4)
    8000655e:	97b6                	add	a5,a5,a3
    80006560:	00079723          	sh	zero,14(a5)
    80006564:	00baa223          	sw	a1,4(s5)
    80006568:	03563423          	sd	s5,40(a2)
    8000656c:	6714                	ld	a3,8(a4)
    8000656e:	0026d783          	lhu	a5,2(a3)
    80006572:	8b9d                	andi	a5,a5,7
    80006574:	0789                	addi	a5,a5,2
    80006576:	0786                	slli	a5,a5,0x1
    80006578:	97b6                	add	a5,a5,a3
    8000657a:	00979023          	sh	s1,0(a5)
    8000657e:	0ff0000f          	fence
    80006582:	6718                	ld	a4,8(a4)
    80006584:	00275783          	lhu	a5,2(a4)
    80006588:	2785                	addiw	a5,a5,1
    8000658a:	00f71123          	sh	a5,2(a4)
    8000658e:	100017b7          	lui	a5,0x10001
    80006592:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>
    80006596:	004aa783          	lw	a5,4(s5)
    8000659a:	02b79163          	bne	a5,a1,800065bc <virtio_disk_rw+0x190>
    8000659e:	0003f917          	auipc	s2,0x3f
    800065a2:	b0a90913          	addi	s2,s2,-1270 # 800450a8 <disk+0x20a8>
    800065a6:	4485                	li	s1,1
    800065a8:	85ca                	mv	a1,s2
    800065aa:	8556                	mv	a0,s5
    800065ac:	ffffc097          	auipc	ra,0xffffc
    800065b0:	166080e7          	jalr	358(ra) # 80002712 <sleep>
    800065b4:	004aa783          	lw	a5,4(s5)
    800065b8:	fe9788e3          	beq	a5,s1,800065a8 <virtio_disk_rw+0x17c>
    800065bc:	f8042483          	lw	s1,-128(s0)
    800065c0:	20048793          	addi	a5,s1,512
    800065c4:	00479713          	slli	a4,a5,0x4
    800065c8:	0003d797          	auipc	a5,0x3d
    800065cc:	a3878793          	addi	a5,a5,-1480 # 80043000 <disk>
    800065d0:	97ba                	add	a5,a5,a4
    800065d2:	0207b423          	sd	zero,40(a5)
    800065d6:	0003f917          	auipc	s2,0x3f
    800065da:	a2a90913          	addi	s2,s2,-1494 # 80045000 <disk+0x2000>
    800065de:	a019                	j	800065e4 <virtio_disk_rw+0x1b8>
    800065e0:	00e4d483          	lhu	s1,14(s1)
    800065e4:	8526                	mv	a0,s1
    800065e6:	00000097          	auipc	ra,0x0
    800065ea:	c80080e7          	jalr	-896(ra) # 80006266 <free_desc>
    800065ee:	0492                	slli	s1,s1,0x4
    800065f0:	00093783          	ld	a5,0(s2)
    800065f4:	94be                	add	s1,s1,a5
    800065f6:	00c4d783          	lhu	a5,12(s1)
    800065fa:	8b85                	andi	a5,a5,1
    800065fc:	f3f5                	bnez	a5,800065e0 <virtio_disk_rw+0x1b4>
    800065fe:	0003f517          	auipc	a0,0x3f
    80006602:	aaa50513          	addi	a0,a0,-1366 # 800450a8 <disk+0x20a8>
    80006606:	ffffb097          	auipc	ra,0xffffb
    8000660a:	a2c080e7          	jalr	-1492(ra) # 80001032 <release>
    8000660e:	60aa                	ld	ra,136(sp)
    80006610:	640a                	ld	s0,128(sp)
    80006612:	74e6                	ld	s1,120(sp)
    80006614:	7946                	ld	s2,112(sp)
    80006616:	79a6                	ld	s3,104(sp)
    80006618:	7a06                	ld	s4,96(sp)
    8000661a:	6ae6                	ld	s5,88(sp)
    8000661c:	6b46                	ld	s6,80(sp)
    8000661e:	6ba6                	ld	s7,72(sp)
    80006620:	6c06                	ld	s8,64(sp)
    80006622:	7ce2                	ld	s9,56(sp)
    80006624:	7d42                	ld	s10,48(sp)
    80006626:	7da2                	ld	s11,40(sp)
    80006628:	6149                	addi	sp,sp,144
    8000662a:	8082                	ret
    8000662c:	01a037b3          	snez	a5,s10
    80006630:	f6f42823          	sw	a5,-144(s0)
    80006634:	f6042a23          	sw	zero,-140(s0)
    80006638:	f7943c23          	sd	s9,-136(s0)
    8000663c:	f8042483          	lw	s1,-128(s0)
    80006640:	00449913          	slli	s2,s1,0x4
    80006644:	0003f997          	auipc	s3,0x3f
    80006648:	9bc98993          	addi	s3,s3,-1604 # 80045000 <disk+0x2000>
    8000664c:	0009ba03          	ld	s4,0(s3)
    80006650:	9a4a                	add	s4,s4,s2
    80006652:	f7040513          	addi	a0,s0,-144
    80006656:	ffffb097          	auipc	ra,0xffffb
    8000665a:	dea080e7          	jalr	-534(ra) # 80001440 <kvmpa>
    8000665e:	00aa3023          	sd	a0,0(s4)
    80006662:	0009b783          	ld	a5,0(s3)
    80006666:	97ca                	add	a5,a5,s2
    80006668:	4741                	li	a4,16
    8000666a:	c798                	sw	a4,8(a5)
    8000666c:	0009b783          	ld	a5,0(s3)
    80006670:	97ca                	add	a5,a5,s2
    80006672:	4705                	li	a4,1
    80006674:	00e79623          	sh	a4,12(a5)
    80006678:	f8442783          	lw	a5,-124(s0)
    8000667c:	0009b703          	ld	a4,0(s3)
    80006680:	974a                	add	a4,a4,s2
    80006682:	00f71723          	sh	a5,14(a4)
    80006686:	0792                	slli	a5,a5,0x4
    80006688:	0009b703          	ld	a4,0(s3)
    8000668c:	973e                	add	a4,a4,a5
    8000668e:	058a8693          	addi	a3,s5,88
    80006692:	e314                	sd	a3,0(a4)
    80006694:	0009b703          	ld	a4,0(s3)
    80006698:	973e                	add	a4,a4,a5
    8000669a:	40000693          	li	a3,1024
    8000669e:	c714                	sw	a3,8(a4)
    800066a0:	e40d18e3          	bnez	s10,800064f0 <virtio_disk_rw+0xc4>
    800066a4:	0003f717          	auipc	a4,0x3f
    800066a8:	95c73703          	ld	a4,-1700(a4) # 80045000 <disk+0x2000>
    800066ac:	973e                	add	a4,a4,a5
    800066ae:	4689                	li	a3,2
    800066b0:	00d71623          	sh	a3,12(a4)
    800066b4:	b5a9                	j	800064fe <virtio_disk_rw+0xd2>

00000000800066b6 <virtio_disk_intr>:
    800066b6:	1101                	addi	sp,sp,-32
    800066b8:	ec06                	sd	ra,24(sp)
    800066ba:	e822                	sd	s0,16(sp)
    800066bc:	e426                	sd	s1,8(sp)
    800066be:	e04a                	sd	s2,0(sp)
    800066c0:	1000                	addi	s0,sp,32
    800066c2:	0003f517          	auipc	a0,0x3f
    800066c6:	9e650513          	addi	a0,a0,-1562 # 800450a8 <disk+0x20a8>
    800066ca:	ffffb097          	auipc	ra,0xffffb
    800066ce:	8b4080e7          	jalr	-1868(ra) # 80000f7e <acquire>
    800066d2:	0003f717          	auipc	a4,0x3f
    800066d6:	92e70713          	addi	a4,a4,-1746 # 80045000 <disk+0x2000>
    800066da:	02075783          	lhu	a5,32(a4)
    800066de:	6b18                	ld	a4,16(a4)
    800066e0:	00275683          	lhu	a3,2(a4)
    800066e4:	8ebd                	xor	a3,a3,a5
    800066e6:	8a9d                	andi	a3,a3,7
    800066e8:	cab9                	beqz	a3,8000673e <virtio_disk_intr+0x88>
    800066ea:	0003d917          	auipc	s2,0x3d
    800066ee:	91690913          	addi	s2,s2,-1770 # 80043000 <disk>
    800066f2:	0003f497          	auipc	s1,0x3f
    800066f6:	90e48493          	addi	s1,s1,-1778 # 80045000 <disk+0x2000>
    800066fa:	078e                	slli	a5,a5,0x3
    800066fc:	97ba                	add	a5,a5,a4
    800066fe:	43dc                	lw	a5,4(a5)
    80006700:	20078713          	addi	a4,a5,512
    80006704:	0712                	slli	a4,a4,0x4
    80006706:	974a                	add	a4,a4,s2
    80006708:	03074703          	lbu	a4,48(a4)
    8000670c:	ef21                	bnez	a4,80006764 <virtio_disk_intr+0xae>
    8000670e:	20078793          	addi	a5,a5,512
    80006712:	0792                	slli	a5,a5,0x4
    80006714:	97ca                	add	a5,a5,s2
    80006716:	7798                	ld	a4,40(a5)
    80006718:	00072223          	sw	zero,4(a4)
    8000671c:	7788                	ld	a0,40(a5)
    8000671e:	ffffc097          	auipc	ra,0xffffc
    80006722:	174080e7          	jalr	372(ra) # 80002892 <wakeup>
    80006726:	0204d783          	lhu	a5,32(s1)
    8000672a:	2785                	addiw	a5,a5,1
    8000672c:	8b9d                	andi	a5,a5,7
    8000672e:	02f49023          	sh	a5,32(s1)
    80006732:	6898                	ld	a4,16(s1)
    80006734:	00275683          	lhu	a3,2(a4)
    80006738:	8a9d                	andi	a3,a3,7
    8000673a:	fcf690e3          	bne	a3,a5,800066fa <virtio_disk_intr+0x44>
    8000673e:	10001737          	lui	a4,0x10001
    80006742:	533c                	lw	a5,96(a4)
    80006744:	8b8d                	andi	a5,a5,3
    80006746:	d37c                	sw	a5,100(a4)
    80006748:	0003f517          	auipc	a0,0x3f
    8000674c:	96050513          	addi	a0,a0,-1696 # 800450a8 <disk+0x20a8>
    80006750:	ffffb097          	auipc	ra,0xffffb
    80006754:	8e2080e7          	jalr	-1822(ra) # 80001032 <release>
    80006758:	60e2                	ld	ra,24(sp)
    8000675a:	6442                	ld	s0,16(sp)
    8000675c:	64a2                	ld	s1,8(sp)
    8000675e:	6902                	ld	s2,0(sp)
    80006760:	6105                	addi	sp,sp,32
    80006762:	8082                	ret
    80006764:	00002517          	auipc	a0,0x2
    80006768:	17450513          	addi	a0,a0,372 # 800088d8 <syscalls+0x3e8>
    8000676c:	ffffa097          	auipc	ra,0xffffa
    80006770:	e7c080e7          	jalr	-388(ra) # 800005e8 <panic>

0000000080006774 <mem_init>:
    80006774:	1141                	addi	sp,sp,-16
    80006776:	e406                	sd	ra,8(sp)
    80006778:	e022                	sd	s0,0(sp)
    8000677a:	0800                	addi	s0,sp,16
    8000677c:	ffffa097          	auipc	ra,0xffffa
    80006780:	5f0080e7          	jalr	1520(ra) # 80000d6c <kalloc>
    80006784:	00003797          	auipc	a5,0x3
    80006788:	8aa7b623          	sd	a0,-1876(a5) # 80009030 <alloc>
    8000678c:	00850793          	addi	a5,a0,8
    80006790:	e11c                	sd	a5,0(a0)
    80006792:	60a2                	ld	ra,8(sp)
    80006794:	6402                	ld	s0,0(sp)
    80006796:	0141                	addi	sp,sp,16
    80006798:	8082                	ret

000000008000679a <mallo>:
    8000679a:	1101                	addi	sp,sp,-32
    8000679c:	ec06                	sd	ra,24(sp)
    8000679e:	e822                	sd	s0,16(sp)
    800067a0:	e426                	sd	s1,8(sp)
    800067a2:	1000                	addi	s0,sp,32
    800067a4:	84aa                	mv	s1,a0
    800067a6:	00003797          	auipc	a5,0x3
    800067aa:	8827a783          	lw	a5,-1918(a5) # 80009028 <if_init>
    800067ae:	cf9d                	beqz	a5,800067ec <mallo+0x52>
    800067b0:	85a6                	mv	a1,s1
    800067b2:	00002517          	auipc	a0,0x2
    800067b6:	13e50513          	addi	a0,a0,318 # 800088f0 <syscalls+0x400>
    800067ba:	ffffa097          	auipc	ra,0xffffa
    800067be:	e80080e7          	jalr	-384(ra) # 8000063a <printf>
    800067c2:	00003717          	auipc	a4,0x3
    800067c6:	86e73703          	ld	a4,-1938(a4) # 80009030 <alloc>
    800067ca:	6308                	ld	a0,0(a4)
    800067cc:	40e506b3          	sub	a3,a0,a4
    800067d0:	6785                	lui	a5,0x1
    800067d2:	37e1                	addiw	a5,a5,-8
    800067d4:	9f95                	subw	a5,a5,a3
    800067d6:	02f4f563          	bgeu	s1,a5,80006800 <mallo+0x66>
    800067da:	1482                	slli	s1,s1,0x20
    800067dc:	9081                	srli	s1,s1,0x20
    800067de:	94aa                	add	s1,s1,a0
    800067e0:	e304                	sd	s1,0(a4)
    800067e2:	60e2                	ld	ra,24(sp)
    800067e4:	6442                	ld	s0,16(sp)
    800067e6:	64a2                	ld	s1,8(sp)
    800067e8:	6105                	addi	sp,sp,32
    800067ea:	8082                	ret
    800067ec:	00000097          	auipc	ra,0x0
    800067f0:	f88080e7          	jalr	-120(ra) # 80006774 <mem_init>
    800067f4:	4785                	li	a5,1
    800067f6:	00003717          	auipc	a4,0x3
    800067fa:	82f72923          	sw	a5,-1998(a4) # 80009028 <if_init>
    800067fe:	bf4d                	j	800067b0 <mallo+0x16>
    80006800:	00002517          	auipc	a0,0x2
    80006804:	10050513          	addi	a0,a0,256 # 80008900 <syscalls+0x410>
    80006808:	ffffa097          	auipc	ra,0xffffa
    8000680c:	e32080e7          	jalr	-462(ra) # 8000063a <printf>
    80006810:	4501                	li	a0,0
    80006812:	bfc1                	j	800067e2 <mallo+0x48>

0000000080006814 <free>:
    80006814:	1141                	addi	sp,sp,-16
    80006816:	e422                	sd	s0,8(sp)
    80006818:	0800                	addi	s0,sp,16
    8000681a:	6422                	ld	s0,8(sp)
    8000681c:	0141                	addi	sp,sp,16
    8000681e:	8082                	ret
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
