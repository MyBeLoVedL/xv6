
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	18010113          	addi	sp,sp,384 # 80009180 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	078000ef          	jal	ra,8000008e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	95b2                	add	a1,a1,a2
    80000046:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00269713          	slli	a4,a3,0x2
    8000004c:	9736                	add	a4,a4,a3
    8000004e:	00371693          	slli	a3,a4,0x3
    80000052:	00009717          	auipc	a4,0x9
    80000056:	fee70713          	addi	a4,a4,-18 # 80009040 <timer_scratch>
    8000005a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005e:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80000060:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000064:	00006797          	auipc	a5,0x6
    80000068:	f6c78793          	addi	a5,a5,-148 # 80005fd0 <timervec>
    8000006c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000070:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000074:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000078:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000080:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000084:	30479073          	csrw	mie,a5
}
    80000088:	6422                	ld	s0,8(sp)
    8000008a:	0141                	addi	sp,sp,16
    8000008c:	8082                	ret

000000008000008e <start>:
{
    8000008e:	1141                	addi	sp,sp,-16
    80000090:	e406                	sd	ra,8(sp)
    80000092:	e022                	sd	s0,0(sp)
    80000094:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000096:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000009a:	7779                	lui	a4,0xffffe
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd87ff>
    800000a0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a2:	6705                	lui	a4,0x1
    800000a4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000aa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ae:	00001797          	auipc	a5,0x1
    800000b2:	dbe78793          	addi	a5,a5,-578 # 80000e6c <main>
    800000b6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000ba:	4781                	li	a5,0
    800000bc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000c0:	67c1                	lui	a5,0x10
    800000c2:	17fd                	addi	a5,a5,-1
    800000c4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000cc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000d0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d4:	10479073          	csrw	sie,a5
  timerinit();
    800000d8:	00000097          	auipc	ra,0x0
    800000dc:	f44080e7          	jalr	-188(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000e0:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000e4:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000e6:	823e                	mv	tp,a5
  asm volatile("mret");
    800000e8:	30200073          	mret
}
    800000ec:	60a2                	ld	ra,8(sp)
    800000ee:	6402                	ld	s0,0(sp)
    800000f0:	0141                	addi	sp,sp,16
    800000f2:	8082                	ret

00000000800000f4 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000f4:	715d                	addi	sp,sp,-80
    800000f6:	e486                	sd	ra,72(sp)
    800000f8:	e0a2                	sd	s0,64(sp)
    800000fa:	fc26                	sd	s1,56(sp)
    800000fc:	f84a                	sd	s2,48(sp)
    800000fe:	f44e                	sd	s3,40(sp)
    80000100:	f052                	sd	s4,32(sp)
    80000102:	ec56                	sd	s5,24(sp)
    80000104:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80000106:	04c05663          	blez	a2,80000152 <consolewrite+0x5e>
    8000010a:	8a2a                	mv	s4,a0
    8000010c:	84ae                	mv	s1,a1
    8000010e:	89b2                	mv	s3,a2
    80000110:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80000112:	5afd                	li	s5,-1
    80000114:	4685                	li	a3,1
    80000116:	8626                	mv	a2,s1
    80000118:	85d2                	mv	a1,s4
    8000011a:	fbf40513          	addi	a0,s0,-65
    8000011e:	00002097          	auipc	ra,0x2
    80000122:	740080e7          	jalr	1856(ra) # 8000285e <either_copyin>
    80000126:	01550c63          	beq	a0,s5,8000013e <consolewrite+0x4a>
      break;
    uartputc(c);
    8000012a:	fbf44503          	lbu	a0,-65(s0)
    8000012e:	00000097          	auipc	ra,0x0
    80000132:	77a080e7          	jalr	1914(ra) # 800008a8 <uartputc>
  for(i = 0; i < n; i++){
    80000136:	2905                	addiw	s2,s2,1
    80000138:	0485                	addi	s1,s1,1
    8000013a:	fd299de3          	bne	s3,s2,80000114 <consolewrite+0x20>
  }

  return i;
}
    8000013e:	854a                	mv	a0,s2
    80000140:	60a6                	ld	ra,72(sp)
    80000142:	6406                	ld	s0,64(sp)
    80000144:	74e2                	ld	s1,56(sp)
    80000146:	7942                	ld	s2,48(sp)
    80000148:	79a2                	ld	s3,40(sp)
    8000014a:	7a02                	ld	s4,32(sp)
    8000014c:	6ae2                	ld	s5,24(sp)
    8000014e:	6161                	addi	sp,sp,80
    80000150:	8082                	ret
  for(i = 0; i < n; i++){
    80000152:	4901                	li	s2,0
    80000154:	b7ed                	j	8000013e <consolewrite+0x4a>

0000000080000156 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000156:	7159                	addi	sp,sp,-112
    80000158:	f486                	sd	ra,104(sp)
    8000015a:	f0a2                	sd	s0,96(sp)
    8000015c:	eca6                	sd	s1,88(sp)
    8000015e:	e8ca                	sd	s2,80(sp)
    80000160:	e4ce                	sd	s3,72(sp)
    80000162:	e0d2                	sd	s4,64(sp)
    80000164:	fc56                	sd	s5,56(sp)
    80000166:	f85a                	sd	s6,48(sp)
    80000168:	f45e                	sd	s7,40(sp)
    8000016a:	f062                	sd	s8,32(sp)
    8000016c:	ec66                	sd	s9,24(sp)
    8000016e:	e86a                	sd	s10,16(sp)
    80000170:	1880                	addi	s0,sp,112
    80000172:	8aaa                	mv	s5,a0
    80000174:	8a2e                	mv	s4,a1
    80000176:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000178:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000017c:	00011517          	auipc	a0,0x11
    80000180:	00450513          	addi	a0,a0,4 # 80011180 <cons>
    80000184:	00001097          	auipc	ra,0x1
    80000188:	a3e080e7          	jalr	-1474(ra) # 80000bc2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000018c:	00011497          	auipc	s1,0x11
    80000190:	ff448493          	addi	s1,s1,-12 # 80011180 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000194:	00011917          	auipc	s2,0x11
    80000198:	08490913          	addi	s2,s2,132 # 80011218 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    8000019c:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000019e:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001a0:	4ca9                	li	s9,10
  while(n > 0){
    800001a2:	07305863          	blez	s3,80000212 <consoleread+0xbc>
    while(cons.r == cons.w){
    800001a6:	0984a783          	lw	a5,152(s1)
    800001aa:	09c4a703          	lw	a4,156(s1)
    800001ae:	02f71463          	bne	a4,a5,800001d6 <consoleread+0x80>
      if(myproc()->killed){
    800001b2:	00002097          	auipc	ra,0x2
    800001b6:	a42080e7          	jalr	-1470(ra) # 80001bf4 <myproc>
    800001ba:	551c                	lw	a5,40(a0)
    800001bc:	e7b5                	bnez	a5,80000228 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    800001be:	85a6                	mv	a1,s1
    800001c0:	854a                	mv	a0,s2
    800001c2:	00002097          	auipc	ra,0x2
    800001c6:	2a2080e7          	jalr	674(ra) # 80002464 <sleep>
    while(cons.r == cons.w){
    800001ca:	0984a783          	lw	a5,152(s1)
    800001ce:	09c4a703          	lw	a4,156(s1)
    800001d2:	fef700e3          	beq	a4,a5,800001b2 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800001d6:	0017871b          	addiw	a4,a5,1
    800001da:	08e4ac23          	sw	a4,152(s1)
    800001de:	07f7f713          	andi	a4,a5,127
    800001e2:	9726                	add	a4,a4,s1
    800001e4:	01874703          	lbu	a4,24(a4)
    800001e8:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    800001ec:	077d0563          	beq	s10,s7,80000256 <consoleread+0x100>
    cbuf = c;
    800001f0:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001f4:	4685                	li	a3,1
    800001f6:	f9f40613          	addi	a2,s0,-97
    800001fa:	85d2                	mv	a1,s4
    800001fc:	8556                	mv	a0,s5
    800001fe:	00002097          	auipc	ra,0x2
    80000202:	60a080e7          	jalr	1546(ra) # 80002808 <either_copyout>
    80000206:	01850663          	beq	a0,s8,80000212 <consoleread+0xbc>
    dst++;
    8000020a:	0a05                	addi	s4,s4,1
    --n;
    8000020c:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    8000020e:	f99d1ae3          	bne	s10,s9,800001a2 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80000212:	00011517          	auipc	a0,0x11
    80000216:	f6e50513          	addi	a0,a0,-146 # 80011180 <cons>
    8000021a:	00001097          	auipc	ra,0x1
    8000021e:	a5c080e7          	jalr	-1444(ra) # 80000c76 <release>

  return target - n;
    80000222:	413b053b          	subw	a0,s6,s3
    80000226:	a811                	j	8000023a <consoleread+0xe4>
        release(&cons.lock);
    80000228:	00011517          	auipc	a0,0x11
    8000022c:	f5850513          	addi	a0,a0,-168 # 80011180 <cons>
    80000230:	00001097          	auipc	ra,0x1
    80000234:	a46080e7          	jalr	-1466(ra) # 80000c76 <release>
        return -1;
    80000238:	557d                	li	a0,-1
}
    8000023a:	70a6                	ld	ra,104(sp)
    8000023c:	7406                	ld	s0,96(sp)
    8000023e:	64e6                	ld	s1,88(sp)
    80000240:	6946                	ld	s2,80(sp)
    80000242:	69a6                	ld	s3,72(sp)
    80000244:	6a06                	ld	s4,64(sp)
    80000246:	7ae2                	ld	s5,56(sp)
    80000248:	7b42                	ld	s6,48(sp)
    8000024a:	7ba2                	ld	s7,40(sp)
    8000024c:	7c02                	ld	s8,32(sp)
    8000024e:	6ce2                	ld	s9,24(sp)
    80000250:	6d42                	ld	s10,16(sp)
    80000252:	6165                	addi	sp,sp,112
    80000254:	8082                	ret
      if(n < target){
    80000256:	0009871b          	sext.w	a4,s3
    8000025a:	fb677ce3          	bgeu	a4,s6,80000212 <consoleread+0xbc>
        cons.r--;
    8000025e:	00011717          	auipc	a4,0x11
    80000262:	faf72d23          	sw	a5,-70(a4) # 80011218 <cons+0x98>
    80000266:	b775                	j	80000212 <consoleread+0xbc>

0000000080000268 <consputc>:
{
    80000268:	1141                	addi	sp,sp,-16
    8000026a:	e406                	sd	ra,8(sp)
    8000026c:	e022                	sd	s0,0(sp)
    8000026e:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000270:	10000793          	li	a5,256
    80000274:	00f50a63          	beq	a0,a5,80000288 <consputc+0x20>
    uartputc_sync(c);
    80000278:	00000097          	auipc	ra,0x0
    8000027c:	55e080e7          	jalr	1374(ra) # 800007d6 <uartputc_sync>
}
    80000280:	60a2                	ld	ra,8(sp)
    80000282:	6402                	ld	s0,0(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000288:	4521                	li	a0,8
    8000028a:	00000097          	auipc	ra,0x0
    8000028e:	54c080e7          	jalr	1356(ra) # 800007d6 <uartputc_sync>
    80000292:	02000513          	li	a0,32
    80000296:	00000097          	auipc	ra,0x0
    8000029a:	540080e7          	jalr	1344(ra) # 800007d6 <uartputc_sync>
    8000029e:	4521                	li	a0,8
    800002a0:	00000097          	auipc	ra,0x0
    800002a4:	536080e7          	jalr	1334(ra) # 800007d6 <uartputc_sync>
    800002a8:	bfe1                	j	80000280 <consputc+0x18>

00000000800002aa <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002aa:	1101                	addi	sp,sp,-32
    800002ac:	ec06                	sd	ra,24(sp)
    800002ae:	e822                	sd	s0,16(sp)
    800002b0:	e426                	sd	s1,8(sp)
    800002b2:	e04a                	sd	s2,0(sp)
    800002b4:	1000                	addi	s0,sp,32
    800002b6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002b8:	00011517          	auipc	a0,0x11
    800002bc:	ec850513          	addi	a0,a0,-312 # 80011180 <cons>
    800002c0:	00001097          	auipc	ra,0x1
    800002c4:	902080e7          	jalr	-1790(ra) # 80000bc2 <acquire>

  switch(c){
    800002c8:	47d5                	li	a5,21
    800002ca:	0af48663          	beq	s1,a5,80000376 <consoleintr+0xcc>
    800002ce:	0297ca63          	blt	a5,s1,80000302 <consoleintr+0x58>
    800002d2:	47a1                	li	a5,8
    800002d4:	0ef48763          	beq	s1,a5,800003c2 <consoleintr+0x118>
    800002d8:	47c1                	li	a5,16
    800002da:	10f49a63          	bne	s1,a5,800003ee <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002de:	00002097          	auipc	ra,0x2
    800002e2:	5d6080e7          	jalr	1494(ra) # 800028b4 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002e6:	00011517          	auipc	a0,0x11
    800002ea:	e9a50513          	addi	a0,a0,-358 # 80011180 <cons>
    800002ee:	00001097          	auipc	ra,0x1
    800002f2:	988080e7          	jalr	-1656(ra) # 80000c76 <release>
}
    800002f6:	60e2                	ld	ra,24(sp)
    800002f8:	6442                	ld	s0,16(sp)
    800002fa:	64a2                	ld	s1,8(sp)
    800002fc:	6902                	ld	s2,0(sp)
    800002fe:	6105                	addi	sp,sp,32
    80000300:	8082                	ret
  switch(c){
    80000302:	07f00793          	li	a5,127
    80000306:	0af48e63          	beq	s1,a5,800003c2 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    8000030a:	00011717          	auipc	a4,0x11
    8000030e:	e7670713          	addi	a4,a4,-394 # 80011180 <cons>
    80000312:	0a072783          	lw	a5,160(a4)
    80000316:	09872703          	lw	a4,152(a4)
    8000031a:	9f99                	subw	a5,a5,a4
    8000031c:	07f00713          	li	a4,127
    80000320:	fcf763e3          	bltu	a4,a5,800002e6 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000324:	47b5                	li	a5,13
    80000326:	0cf48763          	beq	s1,a5,800003f4 <consoleintr+0x14a>
      consputc(c);
    8000032a:	8526                	mv	a0,s1
    8000032c:	00000097          	auipc	ra,0x0
    80000330:	f3c080e7          	jalr	-196(ra) # 80000268 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000334:	00011797          	auipc	a5,0x11
    80000338:	e4c78793          	addi	a5,a5,-436 # 80011180 <cons>
    8000033c:	0a07a703          	lw	a4,160(a5)
    80000340:	0017069b          	addiw	a3,a4,1
    80000344:	0006861b          	sext.w	a2,a3
    80000348:	0ad7a023          	sw	a3,160(a5)
    8000034c:	07f77713          	andi	a4,a4,127
    80000350:	97ba                	add	a5,a5,a4
    80000352:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80000356:	47a9                	li	a5,10
    80000358:	0cf48563          	beq	s1,a5,80000422 <consoleintr+0x178>
    8000035c:	4791                	li	a5,4
    8000035e:	0cf48263          	beq	s1,a5,80000422 <consoleintr+0x178>
    80000362:	00011797          	auipc	a5,0x11
    80000366:	eb67a783          	lw	a5,-330(a5) # 80011218 <cons+0x98>
    8000036a:	0807879b          	addiw	a5,a5,128
    8000036e:	f6f61ce3          	bne	a2,a5,800002e6 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000372:	863e                	mv	a2,a5
    80000374:	a07d                	j	80000422 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80000376:	00011717          	auipc	a4,0x11
    8000037a:	e0a70713          	addi	a4,a4,-502 # 80011180 <cons>
    8000037e:	0a072783          	lw	a5,160(a4)
    80000382:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80000386:	00011497          	auipc	s1,0x11
    8000038a:	dfa48493          	addi	s1,s1,-518 # 80011180 <cons>
    while(cons.e != cons.w &&
    8000038e:	4929                	li	s2,10
    80000390:	f4f70be3          	beq	a4,a5,800002e6 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80000394:	37fd                	addiw	a5,a5,-1
    80000396:	07f7f713          	andi	a4,a5,127
    8000039a:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8000039c:	01874703          	lbu	a4,24(a4)
    800003a0:	f52703e3          	beq	a4,s2,800002e6 <consoleintr+0x3c>
      cons.e--;
    800003a4:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003a8:	10000513          	li	a0,256
    800003ac:	00000097          	auipc	ra,0x0
    800003b0:	ebc080e7          	jalr	-324(ra) # 80000268 <consputc>
    while(cons.e != cons.w &&
    800003b4:	0a04a783          	lw	a5,160(s1)
    800003b8:	09c4a703          	lw	a4,156(s1)
    800003bc:	fcf71ce3          	bne	a4,a5,80000394 <consoleintr+0xea>
    800003c0:	b71d                	j	800002e6 <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003c2:	00011717          	auipc	a4,0x11
    800003c6:	dbe70713          	addi	a4,a4,-578 # 80011180 <cons>
    800003ca:	0a072783          	lw	a5,160(a4)
    800003ce:	09c72703          	lw	a4,156(a4)
    800003d2:	f0f70ae3          	beq	a4,a5,800002e6 <consoleintr+0x3c>
      cons.e--;
    800003d6:	37fd                	addiw	a5,a5,-1
    800003d8:	00011717          	auipc	a4,0x11
    800003dc:	e4f72423          	sw	a5,-440(a4) # 80011220 <cons+0xa0>
      consputc(BACKSPACE);
    800003e0:	10000513          	li	a0,256
    800003e4:	00000097          	auipc	ra,0x0
    800003e8:	e84080e7          	jalr	-380(ra) # 80000268 <consputc>
    800003ec:	bded                	j	800002e6 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    800003ee:	ee048ce3          	beqz	s1,800002e6 <consoleintr+0x3c>
    800003f2:	bf21                	j	8000030a <consoleintr+0x60>
      consputc(c);
    800003f4:	4529                	li	a0,10
    800003f6:	00000097          	auipc	ra,0x0
    800003fa:	e72080e7          	jalr	-398(ra) # 80000268 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    800003fe:	00011797          	auipc	a5,0x11
    80000402:	d8278793          	addi	a5,a5,-638 # 80011180 <cons>
    80000406:	0a07a703          	lw	a4,160(a5)
    8000040a:	0017069b          	addiw	a3,a4,1
    8000040e:	0006861b          	sext.w	a2,a3
    80000412:	0ad7a023          	sw	a3,160(a5)
    80000416:	07f77713          	andi	a4,a4,127
    8000041a:	97ba                	add	a5,a5,a4
    8000041c:	4729                	li	a4,10
    8000041e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000422:	00011797          	auipc	a5,0x11
    80000426:	dec7ad23          	sw	a2,-518(a5) # 8001121c <cons+0x9c>
        wakeup(&cons.r);
    8000042a:	00011517          	auipc	a0,0x11
    8000042e:	dee50513          	addi	a0,a0,-530 # 80011218 <cons+0x98>
    80000432:	00002097          	auipc	ra,0x2
    80000436:	1be080e7          	jalr	446(ra) # 800025f0 <wakeup>
    8000043a:	b575                	j	800002e6 <consoleintr+0x3c>

000000008000043c <consoleinit>:

void
consoleinit(void)
{
    8000043c:	1141                	addi	sp,sp,-16
    8000043e:	e406                	sd	ra,8(sp)
    80000440:	e022                	sd	s0,0(sp)
    80000442:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000444:	00008597          	auipc	a1,0x8
    80000448:	bcc58593          	addi	a1,a1,-1076 # 80008010 <etext+0x10>
    8000044c:	00011517          	auipc	a0,0x11
    80000450:	d3450513          	addi	a0,a0,-716 # 80011180 <cons>
    80000454:	00000097          	auipc	ra,0x0
    80000458:	6de080e7          	jalr	1758(ra) # 80000b32 <initlock>

  uartinit();
    8000045c:	00000097          	auipc	ra,0x0
    80000460:	32a080e7          	jalr	810(ra) # 80000786 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000464:	00021797          	auipc	a5,0x21
    80000468:	2b478793          	addi	a5,a5,692 # 80021718 <devsw>
    8000046c:	00000717          	auipc	a4,0x0
    80000470:	cea70713          	addi	a4,a4,-790 # 80000156 <consoleread>
    80000474:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000476:	00000717          	auipc	a4,0x0
    8000047a:	c7e70713          	addi	a4,a4,-898 # 800000f4 <consolewrite>
    8000047e:	ef98                	sd	a4,24(a5)
}
    80000480:	60a2                	ld	ra,8(sp)
    80000482:	6402                	ld	s0,0(sp)
    80000484:	0141                	addi	sp,sp,16
    80000486:	8082                	ret

0000000080000488 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80000488:	7179                	addi	sp,sp,-48
    8000048a:	f406                	sd	ra,40(sp)
    8000048c:	f022                	sd	s0,32(sp)
    8000048e:	ec26                	sd	s1,24(sp)
    80000490:	e84a                	sd	s2,16(sp)
    80000492:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80000494:	c219                	beqz	a2,8000049a <printint+0x12>
    80000496:	08054663          	bltz	a0,80000522 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    8000049a:	2501                	sext.w	a0,a0
    8000049c:	4881                	li	a7,0
    8000049e:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004a2:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004a4:	2581                	sext.w	a1,a1
    800004a6:	00008617          	auipc	a2,0x8
    800004aa:	b9a60613          	addi	a2,a2,-1126 # 80008040 <digits>
    800004ae:	883a                	mv	a6,a4
    800004b0:	2705                	addiw	a4,a4,1
    800004b2:	02b577bb          	remuw	a5,a0,a1
    800004b6:	1782                	slli	a5,a5,0x20
    800004b8:	9381                	srli	a5,a5,0x20
    800004ba:	97b2                	add	a5,a5,a2
    800004bc:	0007c783          	lbu	a5,0(a5)
    800004c0:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004c4:	0005079b          	sext.w	a5,a0
    800004c8:	02b5553b          	divuw	a0,a0,a1
    800004cc:	0685                	addi	a3,a3,1
    800004ce:	feb7f0e3          	bgeu	a5,a1,800004ae <printint+0x26>

  if(sign)
    800004d2:	00088b63          	beqz	a7,800004e8 <printint+0x60>
    buf[i++] = '-';
    800004d6:	fe040793          	addi	a5,s0,-32
    800004da:	973e                	add	a4,a4,a5
    800004dc:	02d00793          	li	a5,45
    800004e0:	fef70823          	sb	a5,-16(a4)
    800004e4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800004e8:	02e05763          	blez	a4,80000516 <printint+0x8e>
    800004ec:	fd040793          	addi	a5,s0,-48
    800004f0:	00e784b3          	add	s1,a5,a4
    800004f4:	fff78913          	addi	s2,a5,-1
    800004f8:	993a                	add	s2,s2,a4
    800004fa:	377d                	addiw	a4,a4,-1
    800004fc:	1702                	slli	a4,a4,0x20
    800004fe:	9301                	srli	a4,a4,0x20
    80000500:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000504:	fff4c503          	lbu	a0,-1(s1)
    80000508:	00000097          	auipc	ra,0x0
    8000050c:	d60080e7          	jalr	-672(ra) # 80000268 <consputc>
  while(--i >= 0)
    80000510:	14fd                	addi	s1,s1,-1
    80000512:	ff2499e3          	bne	s1,s2,80000504 <printint+0x7c>
}
    80000516:	70a2                	ld	ra,40(sp)
    80000518:	7402                	ld	s0,32(sp)
    8000051a:	64e2                	ld	s1,24(sp)
    8000051c:	6942                	ld	s2,16(sp)
    8000051e:	6145                	addi	sp,sp,48
    80000520:	8082                	ret
    x = -xx;
    80000522:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80000526:	4885                	li	a7,1
    x = -xx;
    80000528:	bf9d                	j	8000049e <printint+0x16>

000000008000052a <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000052a:	1101                	addi	sp,sp,-32
    8000052c:	ec06                	sd	ra,24(sp)
    8000052e:	e822                	sd	s0,16(sp)
    80000530:	e426                	sd	s1,8(sp)
    80000532:	1000                	addi	s0,sp,32
    80000534:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000536:	00011797          	auipc	a5,0x11
    8000053a:	d007a523          	sw	zero,-758(a5) # 80011240 <pr+0x18>
  printf("panic: ");
    8000053e:	00008517          	auipc	a0,0x8
    80000542:	ada50513          	addi	a0,a0,-1318 # 80008018 <etext+0x18>
    80000546:	00000097          	auipc	ra,0x0
    8000054a:	02e080e7          	jalr	46(ra) # 80000574 <printf>
  printf(s);
    8000054e:	8526                	mv	a0,s1
    80000550:	00000097          	auipc	ra,0x0
    80000554:	024080e7          	jalr	36(ra) # 80000574 <printf>
  printf("\n");
    80000558:	00008517          	auipc	a0,0x8
    8000055c:	b7050513          	addi	a0,a0,-1168 # 800080c8 <digits+0x88>
    80000560:	00000097          	auipc	ra,0x0
    80000564:	014080e7          	jalr	20(ra) # 80000574 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000568:	4785                	li	a5,1
    8000056a:	00009717          	auipc	a4,0x9
    8000056e:	a8f72b23          	sw	a5,-1386(a4) # 80009000 <panicked>
  for(;;)
    80000572:	a001                	j	80000572 <panic+0x48>

0000000080000574 <printf>:
{
    80000574:	7131                	addi	sp,sp,-192
    80000576:	fc86                	sd	ra,120(sp)
    80000578:	f8a2                	sd	s0,112(sp)
    8000057a:	f4a6                	sd	s1,104(sp)
    8000057c:	f0ca                	sd	s2,96(sp)
    8000057e:	ecce                	sd	s3,88(sp)
    80000580:	e8d2                	sd	s4,80(sp)
    80000582:	e4d6                	sd	s5,72(sp)
    80000584:	e0da                	sd	s6,64(sp)
    80000586:	fc5e                	sd	s7,56(sp)
    80000588:	f862                	sd	s8,48(sp)
    8000058a:	f466                	sd	s9,40(sp)
    8000058c:	f06a                	sd	s10,32(sp)
    8000058e:	ec6e                	sd	s11,24(sp)
    80000590:	0100                	addi	s0,sp,128
    80000592:	8a2a                	mv	s4,a0
    80000594:	e40c                	sd	a1,8(s0)
    80000596:	e810                	sd	a2,16(s0)
    80000598:	ec14                	sd	a3,24(s0)
    8000059a:	f018                	sd	a4,32(s0)
    8000059c:	f41c                	sd	a5,40(s0)
    8000059e:	03043823          	sd	a6,48(s0)
    800005a2:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005a6:	00011d97          	auipc	s11,0x11
    800005aa:	c9adad83          	lw	s11,-870(s11) # 80011240 <pr+0x18>
  if(locking)
    800005ae:	020d9b63          	bnez	s11,800005e4 <printf+0x70>
  if (fmt == 0)
    800005b2:	040a0263          	beqz	s4,800005f6 <printf+0x82>
  va_start(ap, fmt);
    800005b6:	00840793          	addi	a5,s0,8
    800005ba:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005be:	000a4503          	lbu	a0,0(s4)
    800005c2:	14050f63          	beqz	a0,80000720 <printf+0x1ac>
    800005c6:	4981                	li	s3,0
    if(c != '%'){
    800005c8:	02500a93          	li	s5,37
    switch(c){
    800005cc:	07000b93          	li	s7,112
  consputc('x');
    800005d0:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005d2:	00008b17          	auipc	s6,0x8
    800005d6:	a6eb0b13          	addi	s6,s6,-1426 # 80008040 <digits>
    switch(c){
    800005da:	07300c93          	li	s9,115
    800005de:	06400c13          	li	s8,100
    800005e2:	a82d                	j	8000061c <printf+0xa8>
    acquire(&pr.lock);
    800005e4:	00011517          	auipc	a0,0x11
    800005e8:	c4450513          	addi	a0,a0,-956 # 80011228 <pr>
    800005ec:	00000097          	auipc	ra,0x0
    800005f0:	5d6080e7          	jalr	1494(ra) # 80000bc2 <acquire>
    800005f4:	bf7d                	j	800005b2 <printf+0x3e>
    panic("null fmt");
    800005f6:	00008517          	auipc	a0,0x8
    800005fa:	a3250513          	addi	a0,a0,-1486 # 80008028 <etext+0x28>
    800005fe:	00000097          	auipc	ra,0x0
    80000602:	f2c080e7          	jalr	-212(ra) # 8000052a <panic>
      consputc(c);
    80000606:	00000097          	auipc	ra,0x0
    8000060a:	c62080e7          	jalr	-926(ra) # 80000268 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000060e:	2985                	addiw	s3,s3,1
    80000610:	013a07b3          	add	a5,s4,s3
    80000614:	0007c503          	lbu	a0,0(a5)
    80000618:	10050463          	beqz	a0,80000720 <printf+0x1ac>
    if(c != '%'){
    8000061c:	ff5515e3          	bne	a0,s5,80000606 <printf+0x92>
    c = fmt[++i] & 0xff;
    80000620:	2985                	addiw	s3,s3,1
    80000622:	013a07b3          	add	a5,s4,s3
    80000626:	0007c783          	lbu	a5,0(a5)
    8000062a:	0007849b          	sext.w	s1,a5
    if(c == 0)
    8000062e:	cbed                	beqz	a5,80000720 <printf+0x1ac>
    switch(c){
    80000630:	05778a63          	beq	a5,s7,80000684 <printf+0x110>
    80000634:	02fbf663          	bgeu	s7,a5,80000660 <printf+0xec>
    80000638:	09978863          	beq	a5,s9,800006c8 <printf+0x154>
    8000063c:	07800713          	li	a4,120
    80000640:	0ce79563          	bne	a5,a4,8000070a <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80000644:	f8843783          	ld	a5,-120(s0)
    80000648:	00878713          	addi	a4,a5,8
    8000064c:	f8e43423          	sd	a4,-120(s0)
    80000650:	4605                	li	a2,1
    80000652:	85ea                	mv	a1,s10
    80000654:	4388                	lw	a0,0(a5)
    80000656:	00000097          	auipc	ra,0x0
    8000065a:	e32080e7          	jalr	-462(ra) # 80000488 <printint>
      break;
    8000065e:	bf45                	j	8000060e <printf+0x9a>
    switch(c){
    80000660:	09578f63          	beq	a5,s5,800006fe <printf+0x18a>
    80000664:	0b879363          	bne	a5,s8,8000070a <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80000668:	f8843783          	ld	a5,-120(s0)
    8000066c:	00878713          	addi	a4,a5,8
    80000670:	f8e43423          	sd	a4,-120(s0)
    80000674:	4605                	li	a2,1
    80000676:	45a9                	li	a1,10
    80000678:	4388                	lw	a0,0(a5)
    8000067a:	00000097          	auipc	ra,0x0
    8000067e:	e0e080e7          	jalr	-498(ra) # 80000488 <printint>
      break;
    80000682:	b771                	j	8000060e <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80000684:	f8843783          	ld	a5,-120(s0)
    80000688:	00878713          	addi	a4,a5,8
    8000068c:	f8e43423          	sd	a4,-120(s0)
    80000690:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80000694:	03000513          	li	a0,48
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	bd0080e7          	jalr	-1072(ra) # 80000268 <consputc>
  consputc('x');
    800006a0:	07800513          	li	a0,120
    800006a4:	00000097          	auipc	ra,0x0
    800006a8:	bc4080e7          	jalr	-1084(ra) # 80000268 <consputc>
    800006ac:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006ae:	03c95793          	srli	a5,s2,0x3c
    800006b2:	97da                	add	a5,a5,s6
    800006b4:	0007c503          	lbu	a0,0(a5)
    800006b8:	00000097          	auipc	ra,0x0
    800006bc:	bb0080e7          	jalr	-1104(ra) # 80000268 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006c0:	0912                	slli	s2,s2,0x4
    800006c2:	34fd                	addiw	s1,s1,-1
    800006c4:	f4ed                	bnez	s1,800006ae <printf+0x13a>
    800006c6:	b7a1                	j	8000060e <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006c8:	f8843783          	ld	a5,-120(s0)
    800006cc:	00878713          	addi	a4,a5,8
    800006d0:	f8e43423          	sd	a4,-120(s0)
    800006d4:	6384                	ld	s1,0(a5)
    800006d6:	cc89                	beqz	s1,800006f0 <printf+0x17c>
      for(; *s; s++)
    800006d8:	0004c503          	lbu	a0,0(s1)
    800006dc:	d90d                	beqz	a0,8000060e <printf+0x9a>
        consputc(*s);
    800006de:	00000097          	auipc	ra,0x0
    800006e2:	b8a080e7          	jalr	-1142(ra) # 80000268 <consputc>
      for(; *s; s++)
    800006e6:	0485                	addi	s1,s1,1
    800006e8:	0004c503          	lbu	a0,0(s1)
    800006ec:	f96d                	bnez	a0,800006de <printf+0x16a>
    800006ee:	b705                	j	8000060e <printf+0x9a>
        s = "(null)";
    800006f0:	00008497          	auipc	s1,0x8
    800006f4:	93048493          	addi	s1,s1,-1744 # 80008020 <etext+0x20>
      for(; *s; s++)
    800006f8:	02800513          	li	a0,40
    800006fc:	b7cd                	j	800006de <printf+0x16a>
      consputc('%');
    800006fe:	8556                	mv	a0,s5
    80000700:	00000097          	auipc	ra,0x0
    80000704:	b68080e7          	jalr	-1176(ra) # 80000268 <consputc>
      break;
    80000708:	b719                	j	8000060e <printf+0x9a>
      consputc('%');
    8000070a:	8556                	mv	a0,s5
    8000070c:	00000097          	auipc	ra,0x0
    80000710:	b5c080e7          	jalr	-1188(ra) # 80000268 <consputc>
      consputc(c);
    80000714:	8526                	mv	a0,s1
    80000716:	00000097          	auipc	ra,0x0
    8000071a:	b52080e7          	jalr	-1198(ra) # 80000268 <consputc>
      break;
    8000071e:	bdc5                	j	8000060e <printf+0x9a>
  if(locking)
    80000720:	020d9163          	bnez	s11,80000742 <printf+0x1ce>
}
    80000724:	70e6                	ld	ra,120(sp)
    80000726:	7446                	ld	s0,112(sp)
    80000728:	74a6                	ld	s1,104(sp)
    8000072a:	7906                	ld	s2,96(sp)
    8000072c:	69e6                	ld	s3,88(sp)
    8000072e:	6a46                	ld	s4,80(sp)
    80000730:	6aa6                	ld	s5,72(sp)
    80000732:	6b06                	ld	s6,64(sp)
    80000734:	7be2                	ld	s7,56(sp)
    80000736:	7c42                	ld	s8,48(sp)
    80000738:	7ca2                	ld	s9,40(sp)
    8000073a:	7d02                	ld	s10,32(sp)
    8000073c:	6de2                	ld	s11,24(sp)
    8000073e:	6129                	addi	sp,sp,192
    80000740:	8082                	ret
    release(&pr.lock);
    80000742:	00011517          	auipc	a0,0x11
    80000746:	ae650513          	addi	a0,a0,-1306 # 80011228 <pr>
    8000074a:	00000097          	auipc	ra,0x0
    8000074e:	52c080e7          	jalr	1324(ra) # 80000c76 <release>
}
    80000752:	bfc9                	j	80000724 <printf+0x1b0>

0000000080000754 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000754:	1101                	addi	sp,sp,-32
    80000756:	ec06                	sd	ra,24(sp)
    80000758:	e822                	sd	s0,16(sp)
    8000075a:	e426                	sd	s1,8(sp)
    8000075c:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000075e:	00011497          	auipc	s1,0x11
    80000762:	aca48493          	addi	s1,s1,-1334 # 80011228 <pr>
    80000766:	00008597          	auipc	a1,0x8
    8000076a:	8d258593          	addi	a1,a1,-1838 # 80008038 <etext+0x38>
    8000076e:	8526                	mv	a0,s1
    80000770:	00000097          	auipc	ra,0x0
    80000774:	3c2080e7          	jalr	962(ra) # 80000b32 <initlock>
  pr.locking = 1;
    80000778:	4785                	li	a5,1
    8000077a:	cc9c                	sw	a5,24(s1)
}
    8000077c:	60e2                	ld	ra,24(sp)
    8000077e:	6442                	ld	s0,16(sp)
    80000780:	64a2                	ld	s1,8(sp)
    80000782:	6105                	addi	sp,sp,32
    80000784:	8082                	ret

0000000080000786 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80000786:	1141                	addi	sp,sp,-16
    80000788:	e406                	sd	ra,8(sp)
    8000078a:	e022                	sd	s0,0(sp)
    8000078c:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000078e:	100007b7          	lui	a5,0x10000
    80000792:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80000796:	f8000713          	li	a4,-128
    8000079a:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000079e:	470d                	li	a4,3
    800007a0:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007a4:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007a8:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007ac:	469d                	li	a3,7
    800007ae:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007b2:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007b6:	00008597          	auipc	a1,0x8
    800007ba:	8a258593          	addi	a1,a1,-1886 # 80008058 <digits+0x18>
    800007be:	00011517          	auipc	a0,0x11
    800007c2:	a8a50513          	addi	a0,a0,-1398 # 80011248 <uart_tx_lock>
    800007c6:	00000097          	auipc	ra,0x0
    800007ca:	36c080e7          	jalr	876(ra) # 80000b32 <initlock>
}
    800007ce:	60a2                	ld	ra,8(sp)
    800007d0:	6402                	ld	s0,0(sp)
    800007d2:	0141                	addi	sp,sp,16
    800007d4:	8082                	ret

00000000800007d6 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007d6:	1101                	addi	sp,sp,-32
    800007d8:	ec06                	sd	ra,24(sp)
    800007da:	e822                	sd	s0,16(sp)
    800007dc:	e426                	sd	s1,8(sp)
    800007de:	1000                	addi	s0,sp,32
    800007e0:	84aa                	mv	s1,a0
  push_off();
    800007e2:	00000097          	auipc	ra,0x0
    800007e6:	394080e7          	jalr	916(ra) # 80000b76 <push_off>

  if(panicked){
    800007ea:	00009797          	auipc	a5,0x9
    800007ee:	8167a783          	lw	a5,-2026(a5) # 80009000 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800007f2:	10000737          	lui	a4,0x10000
  if(panicked){
    800007f6:	c391                	beqz	a5,800007fa <uartputc_sync+0x24>
    for(;;)
    800007f8:	a001                	j	800007f8 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800007fa:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800007fe:	0207f793          	andi	a5,a5,32
    80000802:	dfe5                	beqz	a5,800007fa <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000804:	0ff4f513          	andi	a0,s1,255
    80000808:	100007b7          	lui	a5,0x10000
    8000080c:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000810:	00000097          	auipc	ra,0x0
    80000814:	406080e7          	jalr	1030(ra) # 80000c16 <pop_off>
}
    80000818:	60e2                	ld	ra,24(sp)
    8000081a:	6442                	ld	s0,16(sp)
    8000081c:	64a2                	ld	s1,8(sp)
    8000081e:	6105                	addi	sp,sp,32
    80000820:	8082                	ret

0000000080000822 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000822:	00008797          	auipc	a5,0x8
    80000826:	7e67b783          	ld	a5,2022(a5) # 80009008 <uart_tx_r>
    8000082a:	00008717          	auipc	a4,0x8
    8000082e:	7e673703          	ld	a4,2022(a4) # 80009010 <uart_tx_w>
    80000832:	06f70a63          	beq	a4,a5,800008a6 <uartstart+0x84>
{
    80000836:	7139                	addi	sp,sp,-64
    80000838:	fc06                	sd	ra,56(sp)
    8000083a:	f822                	sd	s0,48(sp)
    8000083c:	f426                	sd	s1,40(sp)
    8000083e:	f04a                	sd	s2,32(sp)
    80000840:	ec4e                	sd	s3,24(sp)
    80000842:	e852                	sd	s4,16(sp)
    80000844:	e456                	sd	s5,8(sp)
    80000846:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000848:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000084c:	00011a17          	auipc	s4,0x11
    80000850:	9fca0a13          	addi	s4,s4,-1540 # 80011248 <uart_tx_lock>
    uart_tx_r += 1;
    80000854:	00008497          	auipc	s1,0x8
    80000858:	7b448493          	addi	s1,s1,1972 # 80009008 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000085c:	00008997          	auipc	s3,0x8
    80000860:	7b498993          	addi	s3,s3,1972 # 80009010 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000864:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80000868:	02077713          	andi	a4,a4,32
    8000086c:	c705                	beqz	a4,80000894 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000086e:	01f7f713          	andi	a4,a5,31
    80000872:	9752                	add	a4,a4,s4
    80000874:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80000878:	0785                	addi	a5,a5,1
    8000087a:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    8000087c:	8526                	mv	a0,s1
    8000087e:	00002097          	auipc	ra,0x2
    80000882:	d72080e7          	jalr	-654(ra) # 800025f0 <wakeup>
    
    WriteReg(THR, c);
    80000886:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000088a:	609c                	ld	a5,0(s1)
    8000088c:	0009b703          	ld	a4,0(s3)
    80000890:	fcf71ae3          	bne	a4,a5,80000864 <uartstart+0x42>
  }
}
    80000894:	70e2                	ld	ra,56(sp)
    80000896:	7442                	ld	s0,48(sp)
    80000898:	74a2                	ld	s1,40(sp)
    8000089a:	7902                	ld	s2,32(sp)
    8000089c:	69e2                	ld	s3,24(sp)
    8000089e:	6a42                	ld	s4,16(sp)
    800008a0:	6aa2                	ld	s5,8(sp)
    800008a2:	6121                	addi	sp,sp,64
    800008a4:	8082                	ret
    800008a6:	8082                	ret

00000000800008a8 <uartputc>:
{
    800008a8:	7179                	addi	sp,sp,-48
    800008aa:	f406                	sd	ra,40(sp)
    800008ac:	f022                	sd	s0,32(sp)
    800008ae:	ec26                	sd	s1,24(sp)
    800008b0:	e84a                	sd	s2,16(sp)
    800008b2:	e44e                	sd	s3,8(sp)
    800008b4:	e052                	sd	s4,0(sp)
    800008b6:	1800                	addi	s0,sp,48
    800008b8:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800008ba:	00011517          	auipc	a0,0x11
    800008be:	98e50513          	addi	a0,a0,-1650 # 80011248 <uart_tx_lock>
    800008c2:	00000097          	auipc	ra,0x0
    800008c6:	300080e7          	jalr	768(ra) # 80000bc2 <acquire>
  if(panicked){
    800008ca:	00008797          	auipc	a5,0x8
    800008ce:	7367a783          	lw	a5,1846(a5) # 80009000 <panicked>
    800008d2:	c391                	beqz	a5,800008d6 <uartputc+0x2e>
    for(;;)
    800008d4:	a001                	j	800008d4 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008d6:	00008717          	auipc	a4,0x8
    800008da:	73a73703          	ld	a4,1850(a4) # 80009010 <uart_tx_w>
    800008de:	00008797          	auipc	a5,0x8
    800008e2:	72a7b783          	ld	a5,1834(a5) # 80009008 <uart_tx_r>
    800008e6:	02078793          	addi	a5,a5,32
    800008ea:	02e79b63          	bne	a5,a4,80000920 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    800008ee:	00011997          	auipc	s3,0x11
    800008f2:	95a98993          	addi	s3,s3,-1702 # 80011248 <uart_tx_lock>
    800008f6:	00008497          	auipc	s1,0x8
    800008fa:	71248493          	addi	s1,s1,1810 # 80009008 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008fe:	00008917          	auipc	s2,0x8
    80000902:	71290913          	addi	s2,s2,1810 # 80009010 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80000906:	85ce                	mv	a1,s3
    80000908:	8526                	mv	a0,s1
    8000090a:	00002097          	auipc	ra,0x2
    8000090e:	b5a080e7          	jalr	-1190(ra) # 80002464 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000912:	00093703          	ld	a4,0(s2)
    80000916:	609c                	ld	a5,0(s1)
    80000918:	02078793          	addi	a5,a5,32
    8000091c:	fee785e3          	beq	a5,a4,80000906 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000920:	00011497          	auipc	s1,0x11
    80000924:	92848493          	addi	s1,s1,-1752 # 80011248 <uart_tx_lock>
    80000928:	01f77793          	andi	a5,a4,31
    8000092c:	97a6                	add	a5,a5,s1
    8000092e:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80000932:	0705                	addi	a4,a4,1
    80000934:	00008797          	auipc	a5,0x8
    80000938:	6ce7be23          	sd	a4,1756(a5) # 80009010 <uart_tx_w>
      uartstart();
    8000093c:	00000097          	auipc	ra,0x0
    80000940:	ee6080e7          	jalr	-282(ra) # 80000822 <uartstart>
      release(&uart_tx_lock);
    80000944:	8526                	mv	a0,s1
    80000946:	00000097          	auipc	ra,0x0
    8000094a:	330080e7          	jalr	816(ra) # 80000c76 <release>
}
    8000094e:	70a2                	ld	ra,40(sp)
    80000950:	7402                	ld	s0,32(sp)
    80000952:	64e2                	ld	s1,24(sp)
    80000954:	6942                	ld	s2,16(sp)
    80000956:	69a2                	ld	s3,8(sp)
    80000958:	6a02                	ld	s4,0(sp)
    8000095a:	6145                	addi	sp,sp,48
    8000095c:	8082                	ret

000000008000095e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000095e:	1141                	addi	sp,sp,-16
    80000960:	e422                	sd	s0,8(sp)
    80000962:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000964:	100007b7          	lui	a5,0x10000
    80000968:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000096c:	8b85                	andi	a5,a5,1
    8000096e:	cb91                	beqz	a5,80000982 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80000970:	100007b7          	lui	a5,0x10000
    80000974:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80000978:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    8000097c:	6422                	ld	s0,8(sp)
    8000097e:	0141                	addi	sp,sp,16
    80000980:	8082                	ret
    return -1;
    80000982:	557d                	li	a0,-1
    80000984:	bfe5                	j	8000097c <uartgetc+0x1e>

0000000080000986 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80000986:	1101                	addi	sp,sp,-32
    80000988:	ec06                	sd	ra,24(sp)
    8000098a:	e822                	sd	s0,16(sp)
    8000098c:	e426                	sd	s1,8(sp)
    8000098e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000990:	54fd                	li	s1,-1
    80000992:	a029                	j	8000099c <uartintr+0x16>
      break;
    consoleintr(c);
    80000994:	00000097          	auipc	ra,0x0
    80000998:	916080e7          	jalr	-1770(ra) # 800002aa <consoleintr>
    int c = uartgetc();
    8000099c:	00000097          	auipc	ra,0x0
    800009a0:	fc2080e7          	jalr	-62(ra) # 8000095e <uartgetc>
    if(c == -1)
    800009a4:	fe9518e3          	bne	a0,s1,80000994 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009a8:	00011497          	auipc	s1,0x11
    800009ac:	8a048493          	addi	s1,s1,-1888 # 80011248 <uart_tx_lock>
    800009b0:	8526                	mv	a0,s1
    800009b2:	00000097          	auipc	ra,0x0
    800009b6:	210080e7          	jalr	528(ra) # 80000bc2 <acquire>
  uartstart();
    800009ba:	00000097          	auipc	ra,0x0
    800009be:	e68080e7          	jalr	-408(ra) # 80000822 <uartstart>
  release(&uart_tx_lock);
    800009c2:	8526                	mv	a0,s1
    800009c4:	00000097          	auipc	ra,0x0
    800009c8:	2b2080e7          	jalr	690(ra) # 80000c76 <release>
}
    800009cc:	60e2                	ld	ra,24(sp)
    800009ce:	6442                	ld	s0,16(sp)
    800009d0:	64a2                	ld	s1,8(sp)
    800009d2:	6105                	addi	sp,sp,32
    800009d4:	8082                	ret

00000000800009d6 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800009d6:	1101                	addi	sp,sp,-32
    800009d8:	ec06                	sd	ra,24(sp)
    800009da:	e822                	sd	s0,16(sp)
    800009dc:	e426                	sd	s1,8(sp)
    800009de:	e04a                	sd	s2,0(sp)
    800009e0:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800009e2:	03451793          	slli	a5,a0,0x34
    800009e6:	ebb9                	bnez	a5,80000a3c <kfree+0x66>
    800009e8:	84aa                	mv	s1,a0
    800009ea:	00025797          	auipc	a5,0x25
    800009ee:	61678793          	addi	a5,a5,1558 # 80026000 <end>
    800009f2:	04f56563          	bltu	a0,a5,80000a3c <kfree+0x66>
    800009f6:	47c5                	li	a5,17
    800009f8:	07ee                	slli	a5,a5,0x1b
    800009fa:	04f57163          	bgeu	a0,a5,80000a3c <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    800009fe:	6605                	lui	a2,0x1
    80000a00:	4585                	li	a1,1
    80000a02:	00000097          	auipc	ra,0x0
    80000a06:	2bc080e7          	jalr	700(ra) # 80000cbe <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a0a:	00011917          	auipc	s2,0x11
    80000a0e:	87690913          	addi	s2,s2,-1930 # 80011280 <kmem>
    80000a12:	854a                	mv	a0,s2
    80000a14:	00000097          	auipc	ra,0x0
    80000a18:	1ae080e7          	jalr	430(ra) # 80000bc2 <acquire>
  r->next = kmem.freelist;
    80000a1c:	01893783          	ld	a5,24(s2)
    80000a20:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a22:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a26:	854a                	mv	a0,s2
    80000a28:	00000097          	auipc	ra,0x0
    80000a2c:	24e080e7          	jalr	590(ra) # 80000c76 <release>
}
    80000a30:	60e2                	ld	ra,24(sp)
    80000a32:	6442                	ld	s0,16(sp)
    80000a34:	64a2                	ld	s1,8(sp)
    80000a36:	6902                	ld	s2,0(sp)
    80000a38:	6105                	addi	sp,sp,32
    80000a3a:	8082                	ret
    panic("kfree");
    80000a3c:	00007517          	auipc	a0,0x7
    80000a40:	62450513          	addi	a0,a0,1572 # 80008060 <digits+0x20>
    80000a44:	00000097          	auipc	ra,0x0
    80000a48:	ae6080e7          	jalr	-1306(ra) # 8000052a <panic>

0000000080000a4c <freerange>:
{
    80000a4c:	7179                	addi	sp,sp,-48
    80000a4e:	f406                	sd	ra,40(sp)
    80000a50:	f022                	sd	s0,32(sp)
    80000a52:	ec26                	sd	s1,24(sp)
    80000a54:	e84a                	sd	s2,16(sp)
    80000a56:	e44e                	sd	s3,8(sp)
    80000a58:	e052                	sd	s4,0(sp)
    80000a5a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a5c:	6785                	lui	a5,0x1
    80000a5e:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000a62:	94aa                	add	s1,s1,a0
    80000a64:	757d                	lui	a0,0xfffff
    80000a66:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a68:	94be                	add	s1,s1,a5
    80000a6a:	0095ee63          	bltu	a1,s1,80000a86 <freerange+0x3a>
    80000a6e:	892e                	mv	s2,a1
    kfree(p);
    80000a70:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a72:	6985                	lui	s3,0x1
    kfree(p);
    80000a74:	01448533          	add	a0,s1,s4
    80000a78:	00000097          	auipc	ra,0x0
    80000a7c:	f5e080e7          	jalr	-162(ra) # 800009d6 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a80:	94ce                	add	s1,s1,s3
    80000a82:	fe9979e3          	bgeu	s2,s1,80000a74 <freerange+0x28>
}
    80000a86:	70a2                	ld	ra,40(sp)
    80000a88:	7402                	ld	s0,32(sp)
    80000a8a:	64e2                	ld	s1,24(sp)
    80000a8c:	6942                	ld	s2,16(sp)
    80000a8e:	69a2                	ld	s3,8(sp)
    80000a90:	6a02                	ld	s4,0(sp)
    80000a92:	6145                	addi	sp,sp,48
    80000a94:	8082                	ret

0000000080000a96 <kinit>:
{
    80000a96:	1141                	addi	sp,sp,-16
    80000a98:	e406                	sd	ra,8(sp)
    80000a9a:	e022                	sd	s0,0(sp)
    80000a9c:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000a9e:	00007597          	auipc	a1,0x7
    80000aa2:	5ca58593          	addi	a1,a1,1482 # 80008068 <digits+0x28>
    80000aa6:	00010517          	auipc	a0,0x10
    80000aaa:	7da50513          	addi	a0,a0,2010 # 80011280 <kmem>
    80000aae:	00000097          	auipc	ra,0x0
    80000ab2:	084080e7          	jalr	132(ra) # 80000b32 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000ab6:	45c5                	li	a1,17
    80000ab8:	05ee                	slli	a1,a1,0x1b
    80000aba:	00025517          	auipc	a0,0x25
    80000abe:	54650513          	addi	a0,a0,1350 # 80026000 <end>
    80000ac2:	00000097          	auipc	ra,0x0
    80000ac6:	f8a080e7          	jalr	-118(ra) # 80000a4c <freerange>
}
    80000aca:	60a2                	ld	ra,8(sp)
    80000acc:	6402                	ld	s0,0(sp)
    80000ace:	0141                	addi	sp,sp,16
    80000ad0:	8082                	ret

0000000080000ad2 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000ad2:	1101                	addi	sp,sp,-32
    80000ad4:	ec06                	sd	ra,24(sp)
    80000ad6:	e822                	sd	s0,16(sp)
    80000ad8:	e426                	sd	s1,8(sp)
    80000ada:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000adc:	00010497          	auipc	s1,0x10
    80000ae0:	7a448493          	addi	s1,s1,1956 # 80011280 <kmem>
    80000ae4:	8526                	mv	a0,s1
    80000ae6:	00000097          	auipc	ra,0x0
    80000aea:	0dc080e7          	jalr	220(ra) # 80000bc2 <acquire>
  r = kmem.freelist;
    80000aee:	6c84                	ld	s1,24(s1)
  if(r)
    80000af0:	c885                	beqz	s1,80000b20 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000af2:	609c                	ld	a5,0(s1)
    80000af4:	00010517          	auipc	a0,0x10
    80000af8:	78c50513          	addi	a0,a0,1932 # 80011280 <kmem>
    80000afc:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000afe:	00000097          	auipc	ra,0x0
    80000b02:	178080e7          	jalr	376(ra) # 80000c76 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b06:	6605                	lui	a2,0x1
    80000b08:	4595                	li	a1,5
    80000b0a:	8526                	mv	a0,s1
    80000b0c:	00000097          	auipc	ra,0x0
    80000b10:	1b2080e7          	jalr	434(ra) # 80000cbe <memset>
  return (void*)r;
}
    80000b14:	8526                	mv	a0,s1
    80000b16:	60e2                	ld	ra,24(sp)
    80000b18:	6442                	ld	s0,16(sp)
    80000b1a:	64a2                	ld	s1,8(sp)
    80000b1c:	6105                	addi	sp,sp,32
    80000b1e:	8082                	ret
  release(&kmem.lock);
    80000b20:	00010517          	auipc	a0,0x10
    80000b24:	76050513          	addi	a0,a0,1888 # 80011280 <kmem>
    80000b28:	00000097          	auipc	ra,0x0
    80000b2c:	14e080e7          	jalr	334(ra) # 80000c76 <release>
  if(r)
    80000b30:	b7d5                	j	80000b14 <kalloc+0x42>

0000000080000b32 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b32:	1141                	addi	sp,sp,-16
    80000b34:	e422                	sd	s0,8(sp)
    80000b36:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b38:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b3a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b3e:	00053823          	sd	zero,16(a0)
}
    80000b42:	6422                	ld	s0,8(sp)
    80000b44:	0141                	addi	sp,sp,16
    80000b46:	8082                	ret

0000000080000b48 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b48:	411c                	lw	a5,0(a0)
    80000b4a:	e399                	bnez	a5,80000b50 <holding+0x8>
    80000b4c:	4501                	li	a0,0
  return r;
}
    80000b4e:	8082                	ret
{
    80000b50:	1101                	addi	sp,sp,-32
    80000b52:	ec06                	sd	ra,24(sp)
    80000b54:	e822                	sd	s0,16(sp)
    80000b56:	e426                	sd	s1,8(sp)
    80000b58:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b5a:	6904                	ld	s1,16(a0)
    80000b5c:	00001097          	auipc	ra,0x1
    80000b60:	07c080e7          	jalr	124(ra) # 80001bd8 <mycpu>
    80000b64:	40a48533          	sub	a0,s1,a0
    80000b68:	00153513          	seqz	a0,a0
}
    80000b6c:	60e2                	ld	ra,24(sp)
    80000b6e:	6442                	ld	s0,16(sp)
    80000b70:	64a2                	ld	s1,8(sp)
    80000b72:	6105                	addi	sp,sp,32
    80000b74:	8082                	ret

0000000080000b76 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000b76:	1101                	addi	sp,sp,-32
    80000b78:	ec06                	sd	ra,24(sp)
    80000b7a:	e822                	sd	s0,16(sp)
    80000b7c:	e426                	sd	s1,8(sp)
    80000b7e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b80:	100024f3          	csrr	s1,sstatus
    80000b84:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000b88:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000b8a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000b8e:	00001097          	auipc	ra,0x1
    80000b92:	04a080e7          	jalr	74(ra) # 80001bd8 <mycpu>
    80000b96:	5d3c                	lw	a5,120(a0)
    80000b98:	cf89                	beqz	a5,80000bb2 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000b9a:	00001097          	auipc	ra,0x1
    80000b9e:	03e080e7          	jalr	62(ra) # 80001bd8 <mycpu>
    80000ba2:	5d3c                	lw	a5,120(a0)
    80000ba4:	2785                	addiw	a5,a5,1
    80000ba6:	dd3c                	sw	a5,120(a0)
}
    80000ba8:	60e2                	ld	ra,24(sp)
    80000baa:	6442                	ld	s0,16(sp)
    80000bac:	64a2                	ld	s1,8(sp)
    80000bae:	6105                	addi	sp,sp,32
    80000bb0:	8082                	ret
    mycpu()->intena = old;
    80000bb2:	00001097          	auipc	ra,0x1
    80000bb6:	026080e7          	jalr	38(ra) # 80001bd8 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bba:	8085                	srli	s1,s1,0x1
    80000bbc:	8885                	andi	s1,s1,1
    80000bbe:	dd64                	sw	s1,124(a0)
    80000bc0:	bfe9                	j	80000b9a <push_off+0x24>

0000000080000bc2 <acquire>:
{
    80000bc2:	1101                	addi	sp,sp,-32
    80000bc4:	ec06                	sd	ra,24(sp)
    80000bc6:	e822                	sd	s0,16(sp)
    80000bc8:	e426                	sd	s1,8(sp)
    80000bca:	1000                	addi	s0,sp,32
    80000bcc:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000bce:	00000097          	auipc	ra,0x0
    80000bd2:	fa8080e7          	jalr	-88(ra) # 80000b76 <push_off>
  if(holding(lk))
    80000bd6:	8526                	mv	a0,s1
    80000bd8:	00000097          	auipc	ra,0x0
    80000bdc:	f70080e7          	jalr	-144(ra) # 80000b48 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000be0:	4705                	li	a4,1
  if(holding(lk))
    80000be2:	e115                	bnez	a0,80000c06 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000be4:	87ba                	mv	a5,a4
    80000be6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000bea:	2781                	sext.w	a5,a5
    80000bec:	ffe5                	bnez	a5,80000be4 <acquire+0x22>
  __sync_synchronize();
    80000bee:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000bf2:	00001097          	auipc	ra,0x1
    80000bf6:	fe6080e7          	jalr	-26(ra) # 80001bd8 <mycpu>
    80000bfa:	e888                	sd	a0,16(s1)
}
    80000bfc:	60e2                	ld	ra,24(sp)
    80000bfe:	6442                	ld	s0,16(sp)
    80000c00:	64a2                	ld	s1,8(sp)
    80000c02:	6105                	addi	sp,sp,32
    80000c04:	8082                	ret
    panic("acquire");
    80000c06:	00007517          	auipc	a0,0x7
    80000c0a:	46a50513          	addi	a0,a0,1130 # 80008070 <digits+0x30>
    80000c0e:	00000097          	auipc	ra,0x0
    80000c12:	91c080e7          	jalr	-1764(ra) # 8000052a <panic>

0000000080000c16 <pop_off>:

void
pop_off(void)
{
    80000c16:	1141                	addi	sp,sp,-16
    80000c18:	e406                	sd	ra,8(sp)
    80000c1a:	e022                	sd	s0,0(sp)
    80000c1c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c1e:	00001097          	auipc	ra,0x1
    80000c22:	fba080e7          	jalr	-70(ra) # 80001bd8 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c26:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c2a:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c2c:	e78d                	bnez	a5,80000c56 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c2e:	5d3c                	lw	a5,120(a0)
    80000c30:	02f05b63          	blez	a5,80000c66 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000c34:	37fd                	addiw	a5,a5,-1
    80000c36:	0007871b          	sext.w	a4,a5
    80000c3a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c3c:	eb09                	bnez	a4,80000c4e <pop_off+0x38>
    80000c3e:	5d7c                	lw	a5,124(a0)
    80000c40:	c799                	beqz	a5,80000c4e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c42:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c46:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c4a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c4e:	60a2                	ld	ra,8(sp)
    80000c50:	6402                	ld	s0,0(sp)
    80000c52:	0141                	addi	sp,sp,16
    80000c54:	8082                	ret
    panic("pop_off - interruptible");
    80000c56:	00007517          	auipc	a0,0x7
    80000c5a:	42250513          	addi	a0,a0,1058 # 80008078 <digits+0x38>
    80000c5e:	00000097          	auipc	ra,0x0
    80000c62:	8cc080e7          	jalr	-1844(ra) # 8000052a <panic>
    panic("pop_off");
    80000c66:	00007517          	auipc	a0,0x7
    80000c6a:	42a50513          	addi	a0,a0,1066 # 80008090 <digits+0x50>
    80000c6e:	00000097          	auipc	ra,0x0
    80000c72:	8bc080e7          	jalr	-1860(ra) # 8000052a <panic>

0000000080000c76 <release>:
{
    80000c76:	1101                	addi	sp,sp,-32
    80000c78:	ec06                	sd	ra,24(sp)
    80000c7a:	e822                	sd	s0,16(sp)
    80000c7c:	e426                	sd	s1,8(sp)
    80000c7e:	1000                	addi	s0,sp,32
    80000c80:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c82:	00000097          	auipc	ra,0x0
    80000c86:	ec6080e7          	jalr	-314(ra) # 80000b48 <holding>
    80000c8a:	c115                	beqz	a0,80000cae <release+0x38>
  lk->cpu = 0;
    80000c8c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000c90:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000c94:	0f50000f          	fence	iorw,ow
    80000c98:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000c9c:	00000097          	auipc	ra,0x0
    80000ca0:	f7a080e7          	jalr	-134(ra) # 80000c16 <pop_off>
}
    80000ca4:	60e2                	ld	ra,24(sp)
    80000ca6:	6442                	ld	s0,16(sp)
    80000ca8:	64a2                	ld	s1,8(sp)
    80000caa:	6105                	addi	sp,sp,32
    80000cac:	8082                	ret
    panic("release");
    80000cae:	00007517          	auipc	a0,0x7
    80000cb2:	3ea50513          	addi	a0,a0,1002 # 80008098 <digits+0x58>
    80000cb6:	00000097          	auipc	ra,0x0
    80000cba:	874080e7          	jalr	-1932(ra) # 8000052a <panic>

0000000080000cbe <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cbe:	1141                	addi	sp,sp,-16
    80000cc0:	e422                	sd	s0,8(sp)
    80000cc2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cc4:	ca19                	beqz	a2,80000cda <memset+0x1c>
    80000cc6:	87aa                	mv	a5,a0
    80000cc8:	1602                	slli	a2,a2,0x20
    80000cca:	9201                	srli	a2,a2,0x20
    80000ccc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000cd0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000cd4:	0785                	addi	a5,a5,1
    80000cd6:	fee79de3          	bne	a5,a4,80000cd0 <memset+0x12>
  }
  return dst;
}
    80000cda:	6422                	ld	s0,8(sp)
    80000cdc:	0141                	addi	sp,sp,16
    80000cde:	8082                	ret

0000000080000ce0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000ce0:	1141                	addi	sp,sp,-16
    80000ce2:	e422                	sd	s0,8(sp)
    80000ce4:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000ce6:	ca05                	beqz	a2,80000d16 <memcmp+0x36>
    80000ce8:	fff6069b          	addiw	a3,a2,-1
    80000cec:	1682                	slli	a3,a3,0x20
    80000cee:	9281                	srli	a3,a3,0x20
    80000cf0:	0685                	addi	a3,a3,1
    80000cf2:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000cf4:	00054783          	lbu	a5,0(a0)
    80000cf8:	0005c703          	lbu	a4,0(a1)
    80000cfc:	00e79863          	bne	a5,a4,80000d0c <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d00:	0505                	addi	a0,a0,1
    80000d02:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d04:	fed518e3          	bne	a0,a3,80000cf4 <memcmp+0x14>
  }

  return 0;
    80000d08:	4501                	li	a0,0
    80000d0a:	a019                	j	80000d10 <memcmp+0x30>
      return *s1 - *s2;
    80000d0c:	40e7853b          	subw	a0,a5,a4
}
    80000d10:	6422                	ld	s0,8(sp)
    80000d12:	0141                	addi	sp,sp,16
    80000d14:	8082                	ret
  return 0;
    80000d16:	4501                	li	a0,0
    80000d18:	bfe5                	j	80000d10 <memcmp+0x30>

0000000080000d1a <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d1a:	1141                	addi	sp,sp,-16
    80000d1c:	e422                	sd	s0,8(sp)
    80000d1e:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d20:	02a5e563          	bltu	a1,a0,80000d4a <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d24:	fff6069b          	addiw	a3,a2,-1
    80000d28:	ce11                	beqz	a2,80000d44 <memmove+0x2a>
    80000d2a:	1682                	slli	a3,a3,0x20
    80000d2c:	9281                	srli	a3,a3,0x20
    80000d2e:	0685                	addi	a3,a3,1
    80000d30:	96ae                	add	a3,a3,a1
    80000d32:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000d34:	0585                	addi	a1,a1,1
    80000d36:	0785                	addi	a5,a5,1
    80000d38:	fff5c703          	lbu	a4,-1(a1)
    80000d3c:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000d40:	fed59ae3          	bne	a1,a3,80000d34 <memmove+0x1a>

  return dst;
}
    80000d44:	6422                	ld	s0,8(sp)
    80000d46:	0141                	addi	sp,sp,16
    80000d48:	8082                	ret
  if(s < d && s + n > d){
    80000d4a:	02061713          	slli	a4,a2,0x20
    80000d4e:	9301                	srli	a4,a4,0x20
    80000d50:	00e587b3          	add	a5,a1,a4
    80000d54:	fcf578e3          	bgeu	a0,a5,80000d24 <memmove+0xa>
    d += n;
    80000d58:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000d5a:	fff6069b          	addiw	a3,a2,-1
    80000d5e:	d27d                	beqz	a2,80000d44 <memmove+0x2a>
    80000d60:	02069613          	slli	a2,a3,0x20
    80000d64:	9201                	srli	a2,a2,0x20
    80000d66:	fff64613          	not	a2,a2
    80000d6a:	963e                	add	a2,a2,a5
      *--d = *--s;
    80000d6c:	17fd                	addi	a5,a5,-1
    80000d6e:	177d                	addi	a4,a4,-1
    80000d70:	0007c683          	lbu	a3,0(a5)
    80000d74:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000d78:	fef61ae3          	bne	a2,a5,80000d6c <memmove+0x52>
    80000d7c:	b7e1                	j	80000d44 <memmove+0x2a>

0000000080000d7e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d7e:	1141                	addi	sp,sp,-16
    80000d80:	e406                	sd	ra,8(sp)
    80000d82:	e022                	sd	s0,0(sp)
    80000d84:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d86:	00000097          	auipc	ra,0x0
    80000d8a:	f94080e7          	jalr	-108(ra) # 80000d1a <memmove>
}
    80000d8e:	60a2                	ld	ra,8(sp)
    80000d90:	6402                	ld	s0,0(sp)
    80000d92:	0141                	addi	sp,sp,16
    80000d94:	8082                	ret

0000000080000d96 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d96:	1141                	addi	sp,sp,-16
    80000d98:	e422                	sd	s0,8(sp)
    80000d9a:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000d9c:	ce11                	beqz	a2,80000db8 <strncmp+0x22>
    80000d9e:	00054783          	lbu	a5,0(a0)
    80000da2:	cf89                	beqz	a5,80000dbc <strncmp+0x26>
    80000da4:	0005c703          	lbu	a4,0(a1)
    80000da8:	00f71a63          	bne	a4,a5,80000dbc <strncmp+0x26>
    n--, p++, q++;
    80000dac:	367d                	addiw	a2,a2,-1
    80000dae:	0505                	addi	a0,a0,1
    80000db0:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000db2:	f675                	bnez	a2,80000d9e <strncmp+0x8>
  if(n == 0)
    return 0;
    80000db4:	4501                	li	a0,0
    80000db6:	a809                	j	80000dc8 <strncmp+0x32>
    80000db8:	4501                	li	a0,0
    80000dba:	a039                	j	80000dc8 <strncmp+0x32>
  if(n == 0)
    80000dbc:	ca09                	beqz	a2,80000dce <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000dbe:	00054503          	lbu	a0,0(a0)
    80000dc2:	0005c783          	lbu	a5,0(a1)
    80000dc6:	9d1d                	subw	a0,a0,a5
}
    80000dc8:	6422                	ld	s0,8(sp)
    80000dca:	0141                	addi	sp,sp,16
    80000dcc:	8082                	ret
    return 0;
    80000dce:	4501                	li	a0,0
    80000dd0:	bfe5                	j	80000dc8 <strncmp+0x32>

0000000080000dd2 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000dd2:	1141                	addi	sp,sp,-16
    80000dd4:	e422                	sd	s0,8(sp)
    80000dd6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000dd8:	872a                	mv	a4,a0
    80000dda:	8832                	mv	a6,a2
    80000ddc:	367d                	addiw	a2,a2,-1
    80000dde:	01005963          	blez	a6,80000df0 <strncpy+0x1e>
    80000de2:	0705                	addi	a4,a4,1
    80000de4:	0005c783          	lbu	a5,0(a1)
    80000de8:	fef70fa3          	sb	a5,-1(a4)
    80000dec:	0585                	addi	a1,a1,1
    80000dee:	f7f5                	bnez	a5,80000dda <strncpy+0x8>
    ;
  while(n-- > 0)
    80000df0:	86ba                	mv	a3,a4
    80000df2:	00c05c63          	blez	a2,80000e0a <strncpy+0x38>
    *s++ = 0;
    80000df6:	0685                	addi	a3,a3,1
    80000df8:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000dfc:	fff6c793          	not	a5,a3
    80000e00:	9fb9                	addw	a5,a5,a4
    80000e02:	010787bb          	addw	a5,a5,a6
    80000e06:	fef048e3          	bgtz	a5,80000df6 <strncpy+0x24>
  return os;
}
    80000e0a:	6422                	ld	s0,8(sp)
    80000e0c:	0141                	addi	sp,sp,16
    80000e0e:	8082                	ret

0000000080000e10 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e10:	1141                	addi	sp,sp,-16
    80000e12:	e422                	sd	s0,8(sp)
    80000e14:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e16:	02c05363          	blez	a2,80000e3c <safestrcpy+0x2c>
    80000e1a:	fff6069b          	addiw	a3,a2,-1
    80000e1e:	1682                	slli	a3,a3,0x20
    80000e20:	9281                	srli	a3,a3,0x20
    80000e22:	96ae                	add	a3,a3,a1
    80000e24:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e26:	00d58963          	beq	a1,a3,80000e38 <safestrcpy+0x28>
    80000e2a:	0585                	addi	a1,a1,1
    80000e2c:	0785                	addi	a5,a5,1
    80000e2e:	fff5c703          	lbu	a4,-1(a1)
    80000e32:	fee78fa3          	sb	a4,-1(a5)
    80000e36:	fb65                	bnez	a4,80000e26 <safestrcpy+0x16>
    ;
  *s = 0;
    80000e38:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e3c:	6422                	ld	s0,8(sp)
    80000e3e:	0141                	addi	sp,sp,16
    80000e40:	8082                	ret

0000000080000e42 <strlen>:

int
strlen(const char *s)
{
    80000e42:	1141                	addi	sp,sp,-16
    80000e44:	e422                	sd	s0,8(sp)
    80000e46:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e48:	00054783          	lbu	a5,0(a0)
    80000e4c:	cf91                	beqz	a5,80000e68 <strlen+0x26>
    80000e4e:	0505                	addi	a0,a0,1
    80000e50:	87aa                	mv	a5,a0
    80000e52:	4685                	li	a3,1
    80000e54:	9e89                	subw	a3,a3,a0
    80000e56:	00f6853b          	addw	a0,a3,a5
    80000e5a:	0785                	addi	a5,a5,1
    80000e5c:	fff7c703          	lbu	a4,-1(a5)
    80000e60:	fb7d                	bnez	a4,80000e56 <strlen+0x14>
    ;
  return n;
}
    80000e62:	6422                	ld	s0,8(sp)
    80000e64:	0141                	addi	sp,sp,16
    80000e66:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e68:	4501                	li	a0,0
    80000e6a:	bfe5                	j	80000e62 <strlen+0x20>

0000000080000e6c <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e6c:	1141                	addi	sp,sp,-16
    80000e6e:	e406                	sd	ra,8(sp)
    80000e70:	e022                	sd	s0,0(sp)
    80000e72:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e74:	00001097          	auipc	ra,0x1
    80000e78:	d54080e7          	jalr	-684(ra) # 80001bc8 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e7c:	00008717          	auipc	a4,0x8
    80000e80:	19c70713          	addi	a4,a4,412 # 80009018 <started>
  if(cpuid() == 0){
    80000e84:	c139                	beqz	a0,80000eca <main+0x5e>
    while(started == 0)
    80000e86:	431c                	lw	a5,0(a4)
    80000e88:	2781                	sext.w	a5,a5
    80000e8a:	dff5                	beqz	a5,80000e86 <main+0x1a>
      ;
    __sync_synchronize();
    80000e8c:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000e90:	00001097          	auipc	ra,0x1
    80000e94:	d38080e7          	jalr	-712(ra) # 80001bc8 <cpuid>
    80000e98:	85aa                	mv	a1,a0
    80000e9a:	00007517          	auipc	a0,0x7
    80000e9e:	21e50513          	addi	a0,a0,542 # 800080b8 <digits+0x78>
    80000ea2:	fffff097          	auipc	ra,0xfffff
    80000ea6:	6d2080e7          	jalr	1746(ra) # 80000574 <printf>
    kvminithart();    // turn on paging
    80000eaa:	00000097          	auipc	ra,0x0
    80000eae:	0d8080e7          	jalr	216(ra) # 80000f82 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000eb2:	00002097          	auipc	ra,0x2
    80000eb6:	b42080e7          	jalr	-1214(ra) # 800029f4 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000eba:	00005097          	auipc	ra,0x5
    80000ebe:	156080e7          	jalr	342(ra) # 80006010 <plicinithart>
  }

  scheduler();        
    80000ec2:	00001097          	auipc	ra,0x1
    80000ec6:	3a0080e7          	jalr	928(ra) # 80002262 <scheduler>
    consoleinit();
    80000eca:	fffff097          	auipc	ra,0xfffff
    80000ece:	572080e7          	jalr	1394(ra) # 8000043c <consoleinit>
    printfinit();
    80000ed2:	00000097          	auipc	ra,0x0
    80000ed6:	882080e7          	jalr	-1918(ra) # 80000754 <printfinit>
    printf("\n");
    80000eda:	00007517          	auipc	a0,0x7
    80000ede:	1ee50513          	addi	a0,a0,494 # 800080c8 <digits+0x88>
    80000ee2:	fffff097          	auipc	ra,0xfffff
    80000ee6:	692080e7          	jalr	1682(ra) # 80000574 <printf>
    printf("xv6 kernel is booting\n");
    80000eea:	00007517          	auipc	a0,0x7
    80000eee:	1b650513          	addi	a0,a0,438 # 800080a0 <digits+0x60>
    80000ef2:	fffff097          	auipc	ra,0xfffff
    80000ef6:	682080e7          	jalr	1666(ra) # 80000574 <printf>
    printf("\n");
    80000efa:	00007517          	auipc	a0,0x7
    80000efe:	1ce50513          	addi	a0,a0,462 # 800080c8 <digits+0x88>
    80000f02:	fffff097          	auipc	ra,0xfffff
    80000f06:	672080e7          	jalr	1650(ra) # 80000574 <printf>
    kinit();         // physical page allocator
    80000f0a:	00000097          	auipc	ra,0x0
    80000f0e:	b8c080e7          	jalr	-1140(ra) # 80000a96 <kinit>
    kvminit();       // create kernel page table
    80000f12:	00000097          	auipc	ra,0x0
    80000f16:	306080e7          	jalr	774(ra) # 80001218 <kvminit>
    kvminithart();   // turn on paging
    80000f1a:	00000097          	auipc	ra,0x0
    80000f1e:	068080e7          	jalr	104(ra) # 80000f82 <kvminithart>
    procinit();      // process table
    80000f22:	00001097          	auipc	ra,0x1
    80000f26:	bf6080e7          	jalr	-1034(ra) # 80001b18 <procinit>
    trapinit();      // trap vectors
    80000f2a:	00002097          	auipc	ra,0x2
    80000f2e:	aa2080e7          	jalr	-1374(ra) # 800029cc <trapinit>
    trapinithart();  // install kernel trap vector
    80000f32:	00002097          	auipc	ra,0x2
    80000f36:	ac2080e7          	jalr	-1342(ra) # 800029f4 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f3a:	00005097          	auipc	ra,0x5
    80000f3e:	0c0080e7          	jalr	192(ra) # 80005ffa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f42:	00005097          	auipc	ra,0x5
    80000f46:	0ce080e7          	jalr	206(ra) # 80006010 <plicinithart>
    binit();         // buffer cache
    80000f4a:	00002097          	auipc	ra,0x2
    80000f4e:	262080e7          	jalr	610(ra) # 800031ac <binit>
    iinit();         // inode cache
    80000f52:	00003097          	auipc	ra,0x3
    80000f56:	8f2080e7          	jalr	-1806(ra) # 80003844 <iinit>
    fileinit();      // file table
    80000f5a:	00004097          	auipc	ra,0x4
    80000f5e:	89c080e7          	jalr	-1892(ra) # 800047f6 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f62:	00005097          	auipc	ra,0x5
    80000f66:	1d0080e7          	jalr	464(ra) # 80006132 <virtio_disk_init>
    userinit();      // first user process
    80000f6a:	00001097          	auipc	ra,0x1
    80000f6e:	00a080e7          	jalr	10(ra) # 80001f74 <userinit>
    __sync_synchronize();
    80000f72:	0ff0000f          	fence
    started = 1;
    80000f76:	4785                	li	a5,1
    80000f78:	00008717          	auipc	a4,0x8
    80000f7c:	0af72023          	sw	a5,160(a4) # 80009018 <started>
    80000f80:	b789                	j	80000ec2 <main+0x56>

0000000080000f82 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f82:	1141                	addi	sp,sp,-16
    80000f84:	e422                	sd	s0,8(sp)
    80000f86:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000f88:	00008797          	auipc	a5,0x8
    80000f8c:	0987b783          	ld	a5,152(a5) # 80009020 <kernel_pagetable>
    80000f90:	83b1                	srli	a5,a5,0xc
    80000f92:	577d                	li	a4,-1
    80000f94:	177e                	slli	a4,a4,0x3f
    80000f96:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f98:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f9c:	12000073          	sfence.vma
  sfence_vma();
}
    80000fa0:	6422                	ld	s0,8(sp)
    80000fa2:	0141                	addi	sp,sp,16
    80000fa4:	8082                	ret

0000000080000fa6 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000fa6:	7139                	addi	sp,sp,-64
    80000fa8:	fc06                	sd	ra,56(sp)
    80000faa:	f822                	sd	s0,48(sp)
    80000fac:	f426                	sd	s1,40(sp)
    80000fae:	f04a                	sd	s2,32(sp)
    80000fb0:	ec4e                	sd	s3,24(sp)
    80000fb2:	e852                	sd	s4,16(sp)
    80000fb4:	e456                	sd	s5,8(sp)
    80000fb6:	e05a                	sd	s6,0(sp)
    80000fb8:	0080                	addi	s0,sp,64
    80000fba:	84aa                	mv	s1,a0
    80000fbc:	89ae                	mv	s3,a1
    80000fbe:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000fc0:	57fd                	li	a5,-1
    80000fc2:	83e9                	srli	a5,a5,0x1a
    80000fc4:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000fc6:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000fc8:	04b7f263          	bgeu	a5,a1,8000100c <walk+0x66>
    panic("walk");
    80000fcc:	00007517          	auipc	a0,0x7
    80000fd0:	10450513          	addi	a0,a0,260 # 800080d0 <digits+0x90>
    80000fd4:	fffff097          	auipc	ra,0xfffff
    80000fd8:	556080e7          	jalr	1366(ra) # 8000052a <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000fdc:	060a8663          	beqz	s5,80001048 <walk+0xa2>
    80000fe0:	00000097          	auipc	ra,0x0
    80000fe4:	af2080e7          	jalr	-1294(ra) # 80000ad2 <kalloc>
    80000fe8:	84aa                	mv	s1,a0
    80000fea:	c529                	beqz	a0,80001034 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000fec:	6605                	lui	a2,0x1
    80000fee:	4581                	li	a1,0
    80000ff0:	00000097          	auipc	ra,0x0
    80000ff4:	cce080e7          	jalr	-818(ra) # 80000cbe <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000ff8:	00c4d793          	srli	a5,s1,0xc
    80000ffc:	07aa                	slli	a5,a5,0xa
    80000ffe:	0017e793          	ori	a5,a5,1
    80001002:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001006:	3a5d                	addiw	s4,s4,-9
    80001008:	036a0063          	beq	s4,s6,80001028 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    8000100c:	0149d933          	srl	s2,s3,s4
    80001010:	1ff97913          	andi	s2,s2,511
    80001014:	090e                	slli	s2,s2,0x3
    80001016:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001018:	00093483          	ld	s1,0(s2)
    8000101c:	0014f793          	andi	a5,s1,1
    80001020:	dfd5                	beqz	a5,80000fdc <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001022:	80a9                	srli	s1,s1,0xa
    80001024:	04b2                	slli	s1,s1,0xc
    80001026:	b7c5                	j	80001006 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80001028:	00c9d513          	srli	a0,s3,0xc
    8000102c:	1ff57513          	andi	a0,a0,511
    80001030:	050e                	slli	a0,a0,0x3
    80001032:	9526                	add	a0,a0,s1
}
    80001034:	70e2                	ld	ra,56(sp)
    80001036:	7442                	ld	s0,48(sp)
    80001038:	74a2                	ld	s1,40(sp)
    8000103a:	7902                	ld	s2,32(sp)
    8000103c:	69e2                	ld	s3,24(sp)
    8000103e:	6a42                	ld	s4,16(sp)
    80001040:	6aa2                	ld	s5,8(sp)
    80001042:	6b02                	ld	s6,0(sp)
    80001044:	6121                	addi	sp,sp,64
    80001046:	8082                	ret
        return 0;
    80001048:	4501                	li	a0,0
    8000104a:	b7ed                	j	80001034 <walk+0x8e>

000000008000104c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000104c:	57fd                	li	a5,-1
    8000104e:	83e9                	srli	a5,a5,0x1a
    80001050:	00b7f463          	bgeu	a5,a1,80001058 <walkaddr+0xc>
    return 0;
    80001054:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001056:	8082                	ret
{
    80001058:	1141                	addi	sp,sp,-16
    8000105a:	e406                	sd	ra,8(sp)
    8000105c:	e022                	sd	s0,0(sp)
    8000105e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001060:	4601                	li	a2,0
    80001062:	00000097          	auipc	ra,0x0
    80001066:	f44080e7          	jalr	-188(ra) # 80000fa6 <walk>
  if(pte == 0)
    8000106a:	c105                	beqz	a0,8000108a <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000106c:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000106e:	0117f693          	andi	a3,a5,17
    80001072:	4745                	li	a4,17
    return 0;
    80001074:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001076:	00e68663          	beq	a3,a4,80001082 <walkaddr+0x36>
}
    8000107a:	60a2                	ld	ra,8(sp)
    8000107c:	6402                	ld	s0,0(sp)
    8000107e:	0141                	addi	sp,sp,16
    80001080:	8082                	ret
  pa = PTE2PA(*pte);
    80001082:	00a7d513          	srli	a0,a5,0xa
    80001086:	0532                	slli	a0,a0,0xc
  return pa;
    80001088:	bfcd                	j	8000107a <walkaddr+0x2e>
    return 0;
    8000108a:	4501                	li	a0,0
    8000108c:	b7fd                	j	8000107a <walkaddr+0x2e>

000000008000108e <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000108e:	715d                	addi	sp,sp,-80
    80001090:	e486                	sd	ra,72(sp)
    80001092:	e0a2                	sd	s0,64(sp)
    80001094:	fc26                	sd	s1,56(sp)
    80001096:	f84a                	sd	s2,48(sp)
    80001098:	f44e                	sd	s3,40(sp)
    8000109a:	f052                	sd	s4,32(sp)
    8000109c:	ec56                	sd	s5,24(sp)
    8000109e:	e85a                	sd	s6,16(sp)
    800010a0:	e45e                	sd	s7,8(sp)
    800010a2:	0880                	addi	s0,sp,80
    800010a4:	8aaa                	mv	s5,a0
    800010a6:	8b3a                	mv	s6,a4
  uint64 a, last;
  pte_t *pte;

  a = PGROUNDDOWN(va);
    800010a8:	777d                	lui	a4,0xfffff
    800010aa:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800010ae:	167d                	addi	a2,a2,-1
    800010b0:	00b609b3          	add	s3,a2,a1
    800010b4:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800010b8:	893e                	mv	s2,a5
    800010ba:	40f68a33          	sub	s4,a3,a5
    *pte = PA2PTE(pa) | perm | PTE_V;
    // if (a == va)
    //   printf("pte in map page %p\n",pte);
    if(a == last)
      break;
    a += PGSIZE;
    800010be:	6b85                	lui	s7,0x1
    800010c0:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800010c4:	4605                	li	a2,1
    800010c6:	85ca                	mv	a1,s2
    800010c8:	8556                	mv	a0,s5
    800010ca:	00000097          	auipc	ra,0x0
    800010ce:	edc080e7          	jalr	-292(ra) # 80000fa6 <walk>
    800010d2:	c51d                	beqz	a0,80001100 <mappages+0x72>
    if(*pte & PTE_V)
    800010d4:	611c                	ld	a5,0(a0)
    800010d6:	8b85                	andi	a5,a5,1
    800010d8:	ef81                	bnez	a5,800010f0 <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800010da:	80b1                	srli	s1,s1,0xc
    800010dc:	04aa                	slli	s1,s1,0xa
    800010de:	0164e4b3          	or	s1,s1,s6
    800010e2:	0014e493          	ori	s1,s1,1
    800010e6:	e104                	sd	s1,0(a0)
    if(a == last)
    800010e8:	03390863          	beq	s2,s3,80001118 <mappages+0x8a>
    a += PGSIZE;
    800010ec:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800010ee:	bfc9                	j	800010c0 <mappages+0x32>
      panic("remap");
    800010f0:	00007517          	auipc	a0,0x7
    800010f4:	fe850513          	addi	a0,a0,-24 # 800080d8 <digits+0x98>
    800010f8:	fffff097          	auipc	ra,0xfffff
    800010fc:	432080e7          	jalr	1074(ra) # 8000052a <panic>
      return -1;
    80001100:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001102:	60a6                	ld	ra,72(sp)
    80001104:	6406                	ld	s0,64(sp)
    80001106:	74e2                	ld	s1,56(sp)
    80001108:	7942                	ld	s2,48(sp)
    8000110a:	79a2                	ld	s3,40(sp)
    8000110c:	7a02                	ld	s4,32(sp)
    8000110e:	6ae2                	ld	s5,24(sp)
    80001110:	6b42                	ld	s6,16(sp)
    80001112:	6ba2                	ld	s7,8(sp)
    80001114:	6161                	addi	sp,sp,80
    80001116:	8082                	ret
  return 0;
    80001118:	4501                	li	a0,0
    8000111a:	b7e5                	j	80001102 <mappages+0x74>

000000008000111c <kvmmap>:
{
    8000111c:	1141                	addi	sp,sp,-16
    8000111e:	e406                	sd	ra,8(sp)
    80001120:	e022                	sd	s0,0(sp)
    80001122:	0800                	addi	s0,sp,16
    80001124:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001126:	86b2                	mv	a3,a2
    80001128:	863e                	mv	a2,a5
    8000112a:	00000097          	auipc	ra,0x0
    8000112e:	f64080e7          	jalr	-156(ra) # 8000108e <mappages>
    80001132:	e509                	bnez	a0,8000113c <kvmmap+0x20>
}
    80001134:	60a2                	ld	ra,8(sp)
    80001136:	6402                	ld	s0,0(sp)
    80001138:	0141                	addi	sp,sp,16
    8000113a:	8082                	ret
    panic("kvmmap");
    8000113c:	00007517          	auipc	a0,0x7
    80001140:	fa450513          	addi	a0,a0,-92 # 800080e0 <digits+0xa0>
    80001144:	fffff097          	auipc	ra,0xfffff
    80001148:	3e6080e7          	jalr	998(ra) # 8000052a <panic>

000000008000114c <kvmmake>:
{
    8000114c:	1101                	addi	sp,sp,-32
    8000114e:	ec06                	sd	ra,24(sp)
    80001150:	e822                	sd	s0,16(sp)
    80001152:	e426                	sd	s1,8(sp)
    80001154:	e04a                	sd	s2,0(sp)
    80001156:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001158:	00000097          	auipc	ra,0x0
    8000115c:	97a080e7          	jalr	-1670(ra) # 80000ad2 <kalloc>
    80001160:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001162:	6605                	lui	a2,0x1
    80001164:	4581                	li	a1,0
    80001166:	00000097          	auipc	ra,0x0
    8000116a:	b58080e7          	jalr	-1192(ra) # 80000cbe <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000116e:	4719                	li	a4,6
    80001170:	6685                	lui	a3,0x1
    80001172:	10000637          	lui	a2,0x10000
    80001176:	100005b7          	lui	a1,0x10000
    8000117a:	8526                	mv	a0,s1
    8000117c:	00000097          	auipc	ra,0x0
    80001180:	fa0080e7          	jalr	-96(ra) # 8000111c <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001184:	4719                	li	a4,6
    80001186:	6685                	lui	a3,0x1
    80001188:	10001637          	lui	a2,0x10001
    8000118c:	100015b7          	lui	a1,0x10001
    80001190:	8526                	mv	a0,s1
    80001192:	00000097          	auipc	ra,0x0
    80001196:	f8a080e7          	jalr	-118(ra) # 8000111c <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000119a:	4719                	li	a4,6
    8000119c:	004006b7          	lui	a3,0x400
    800011a0:	0c000637          	lui	a2,0xc000
    800011a4:	0c0005b7          	lui	a1,0xc000
    800011a8:	8526                	mv	a0,s1
    800011aa:	00000097          	auipc	ra,0x0
    800011ae:	f72080e7          	jalr	-142(ra) # 8000111c <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800011b2:	00007917          	auipc	s2,0x7
    800011b6:	e4e90913          	addi	s2,s2,-434 # 80008000 <etext>
    800011ba:	4729                	li	a4,10
    800011bc:	80007697          	auipc	a3,0x80007
    800011c0:	e4468693          	addi	a3,a3,-444 # 8000 <_entry-0x7fff8000>
    800011c4:	4605                	li	a2,1
    800011c6:	067e                	slli	a2,a2,0x1f
    800011c8:	85b2                	mv	a1,a2
    800011ca:	8526                	mv	a0,s1
    800011cc:	00000097          	auipc	ra,0x0
    800011d0:	f50080e7          	jalr	-176(ra) # 8000111c <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800011d4:	4719                	li	a4,6
    800011d6:	46c5                	li	a3,17
    800011d8:	06ee                	slli	a3,a3,0x1b
    800011da:	412686b3          	sub	a3,a3,s2
    800011de:	864a                	mv	a2,s2
    800011e0:	85ca                	mv	a1,s2
    800011e2:	8526                	mv	a0,s1
    800011e4:	00000097          	auipc	ra,0x0
    800011e8:	f38080e7          	jalr	-200(ra) # 8000111c <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800011ec:	4729                	li	a4,10
    800011ee:	6685                	lui	a3,0x1
    800011f0:	00006617          	auipc	a2,0x6
    800011f4:	e1060613          	addi	a2,a2,-496 # 80007000 <_trampoline>
    800011f8:	040005b7          	lui	a1,0x4000
    800011fc:	15fd                	addi	a1,a1,-1
    800011fe:	05b2                	slli	a1,a1,0xc
    80001200:	8526                	mv	a0,s1
    80001202:	00000097          	auipc	ra,0x0
    80001206:	f1a080e7          	jalr	-230(ra) # 8000111c <kvmmap>
}
    8000120a:	8526                	mv	a0,s1
    8000120c:	60e2                	ld	ra,24(sp)
    8000120e:	6442                	ld	s0,16(sp)
    80001210:	64a2                	ld	s1,8(sp)
    80001212:	6902                	ld	s2,0(sp)
    80001214:	6105                	addi	sp,sp,32
    80001216:	8082                	ret

0000000080001218 <kvminit>:
{
    80001218:	1141                	addi	sp,sp,-16
    8000121a:	e406                	sd	ra,8(sp)
    8000121c:	e022                	sd	s0,0(sp)
    8000121e:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80001220:	00000097          	auipc	ra,0x0
    80001224:	f2c080e7          	jalr	-212(ra) # 8000114c <kvmmake>
    80001228:	00008797          	auipc	a5,0x8
    8000122c:	dea7bc23          	sd	a0,-520(a5) # 80009020 <kernel_pagetable>
}
    80001230:	60a2                	ld	ra,8(sp)
    80001232:	6402                	ld	s0,0(sp)
    80001234:	0141                	addi	sp,sp,16
    80001236:	8082                	ret

0000000080001238 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001238:	715d                	addi	sp,sp,-80
    8000123a:	e486                	sd	ra,72(sp)
    8000123c:	e0a2                	sd	s0,64(sp)
    8000123e:	fc26                	sd	s1,56(sp)
    80001240:	f84a                	sd	s2,48(sp)
    80001242:	f44e                	sd	s3,40(sp)
    80001244:	f052                	sd	s4,32(sp)
    80001246:	ec56                	sd	s5,24(sp)
    80001248:	e85a                	sd	s6,16(sp)
    8000124a:	e45e                	sd	s7,8(sp)
    8000124c:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000124e:	03459793          	slli	a5,a1,0x34
    80001252:	e795                	bnez	a5,8000127e <uvmunmap+0x46>
    80001254:	8a2a                	mv	s4,a0
    80001256:	892e                	mv	s2,a1
    80001258:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000125a:	0632                	slli	a2,a2,0xc
    8000125c:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001260:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001262:	6b05                	lui	s6,0x1
    80001264:	0735e263          	bltu	a1,s3,800012c8 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80001268:	60a6                	ld	ra,72(sp)
    8000126a:	6406                	ld	s0,64(sp)
    8000126c:	74e2                	ld	s1,56(sp)
    8000126e:	7942                	ld	s2,48(sp)
    80001270:	79a2                	ld	s3,40(sp)
    80001272:	7a02                	ld	s4,32(sp)
    80001274:	6ae2                	ld	s5,24(sp)
    80001276:	6b42                	ld	s6,16(sp)
    80001278:	6ba2                	ld	s7,8(sp)
    8000127a:	6161                	addi	sp,sp,80
    8000127c:	8082                	ret
    panic("uvmunmap: not aligned");
    8000127e:	00007517          	auipc	a0,0x7
    80001282:	e6a50513          	addi	a0,a0,-406 # 800080e8 <digits+0xa8>
    80001286:	fffff097          	auipc	ra,0xfffff
    8000128a:	2a4080e7          	jalr	676(ra) # 8000052a <panic>
      panic("uvmunmap: walk");
    8000128e:	00007517          	auipc	a0,0x7
    80001292:	e7250513          	addi	a0,a0,-398 # 80008100 <digits+0xc0>
    80001296:	fffff097          	auipc	ra,0xfffff
    8000129a:	294080e7          	jalr	660(ra) # 8000052a <panic>
      panic("uvmunmap: not mapped");
    8000129e:	00007517          	auipc	a0,0x7
    800012a2:	e7250513          	addi	a0,a0,-398 # 80008110 <digits+0xd0>
    800012a6:	fffff097          	auipc	ra,0xfffff
    800012aa:	284080e7          	jalr	644(ra) # 8000052a <panic>
      panic("uvmunmap: not a leaf");
    800012ae:	00007517          	auipc	a0,0x7
    800012b2:	e7a50513          	addi	a0,a0,-390 # 80008128 <digits+0xe8>
    800012b6:	fffff097          	auipc	ra,0xfffff
    800012ba:	274080e7          	jalr	628(ra) # 8000052a <panic>
    *pte = 0;
    800012be:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012c2:	995a                	add	s2,s2,s6
    800012c4:	fb3972e3          	bgeu	s2,s3,80001268 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800012c8:	4601                	li	a2,0
    800012ca:	85ca                	mv	a1,s2
    800012cc:	8552                	mv	a0,s4
    800012ce:	00000097          	auipc	ra,0x0
    800012d2:	cd8080e7          	jalr	-808(ra) # 80000fa6 <walk>
    800012d6:	84aa                	mv	s1,a0
    800012d8:	d95d                	beqz	a0,8000128e <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800012da:	6108                	ld	a0,0(a0)
    800012dc:	00157793          	andi	a5,a0,1
    800012e0:	dfdd                	beqz	a5,8000129e <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800012e2:	3ff57793          	andi	a5,a0,1023
    800012e6:	fd7784e3          	beq	a5,s7,800012ae <uvmunmap+0x76>
    if(do_free){
    800012ea:	fc0a8ae3          	beqz	s5,800012be <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800012ee:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800012f0:	0532                	slli	a0,a0,0xc
    800012f2:	fffff097          	auipc	ra,0xfffff
    800012f6:	6e4080e7          	jalr	1764(ra) # 800009d6 <kfree>
    800012fa:	b7d1                	j	800012be <uvmunmap+0x86>

00000000800012fc <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800012fc:	1101                	addi	sp,sp,-32
    800012fe:	ec06                	sd	ra,24(sp)
    80001300:	e822                	sd	s0,16(sp)
    80001302:	e426                	sd	s1,8(sp)
    80001304:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001306:	fffff097          	auipc	ra,0xfffff
    8000130a:	7cc080e7          	jalr	1996(ra) # 80000ad2 <kalloc>
    8000130e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001310:	c519                	beqz	a0,8000131e <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001312:	6605                	lui	a2,0x1
    80001314:	4581                	li	a1,0
    80001316:	00000097          	auipc	ra,0x0
    8000131a:	9a8080e7          	jalr	-1624(ra) # 80000cbe <memset>
  return pagetable;
}
    8000131e:	8526                	mv	a0,s1
    80001320:	60e2                	ld	ra,24(sp)
    80001322:	6442                	ld	s0,16(sp)
    80001324:	64a2                	ld	s1,8(sp)
    80001326:	6105                	addi	sp,sp,32
    80001328:	8082                	ret

000000008000132a <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    8000132a:	7179                	addi	sp,sp,-48
    8000132c:	f406                	sd	ra,40(sp)
    8000132e:	f022                	sd	s0,32(sp)
    80001330:	ec26                	sd	s1,24(sp)
    80001332:	e84a                	sd	s2,16(sp)
    80001334:	e44e                	sd	s3,8(sp)
    80001336:	e052                	sd	s4,0(sp)
    80001338:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000133a:	6785                	lui	a5,0x1
    8000133c:	04f67863          	bgeu	a2,a5,8000138c <uvminit+0x62>
    80001340:	8a2a                	mv	s4,a0
    80001342:	89ae                	mv	s3,a1
    80001344:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80001346:	fffff097          	auipc	ra,0xfffff
    8000134a:	78c080e7          	jalr	1932(ra) # 80000ad2 <kalloc>
    8000134e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001350:	6605                	lui	a2,0x1
    80001352:	4581                	li	a1,0
    80001354:	00000097          	auipc	ra,0x0
    80001358:	96a080e7          	jalr	-1686(ra) # 80000cbe <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000135c:	4779                	li	a4,30
    8000135e:	86ca                	mv	a3,s2
    80001360:	6605                	lui	a2,0x1
    80001362:	4581                	li	a1,0
    80001364:	8552                	mv	a0,s4
    80001366:	00000097          	auipc	ra,0x0
    8000136a:	d28080e7          	jalr	-728(ra) # 8000108e <mappages>
  memmove(mem, src, sz);
    8000136e:	8626                	mv	a2,s1
    80001370:	85ce                	mv	a1,s3
    80001372:	854a                	mv	a0,s2
    80001374:	00000097          	auipc	ra,0x0
    80001378:	9a6080e7          	jalr	-1626(ra) # 80000d1a <memmove>
}
    8000137c:	70a2                	ld	ra,40(sp)
    8000137e:	7402                	ld	s0,32(sp)
    80001380:	64e2                	ld	s1,24(sp)
    80001382:	6942                	ld	s2,16(sp)
    80001384:	69a2                	ld	s3,8(sp)
    80001386:	6a02                	ld	s4,0(sp)
    80001388:	6145                	addi	sp,sp,48
    8000138a:	8082                	ret
    panic("inituvm: more than a page");
    8000138c:	00007517          	auipc	a0,0x7
    80001390:	db450513          	addi	a0,a0,-588 # 80008140 <digits+0x100>
    80001394:	fffff097          	auipc	ra,0xfffff
    80001398:	196080e7          	jalr	406(ra) # 8000052a <panic>

000000008000139c <uvmapping>:
  }
  return newsz;
}

// * copy mapping from va to end to another pagetable dst.
int uvmapping(pagetable_t pagetable,pagetable_t dst,u64 ori,u64 end){
    8000139c:	7139                	addi	sp,sp,-64
    8000139e:	fc06                	sd	ra,56(sp)
    800013a0:	f822                	sd	s0,48(sp)
    800013a2:	f426                	sd	s1,40(sp)
    800013a4:	f04a                	sd	s2,32(sp)
    800013a6:	ec4e                	sd	s3,24(sp)
    800013a8:	e852                	sd	s4,16(sp)
    800013aa:	e456                	sd	s5,8(sp)
    800013ac:	e05a                	sd	s6,0(sp)
    800013ae:	0080                	addi	s0,sp,64
  ori = PGROUNDUP(ori);
    800013b0:	6905                	lui	s2,0x1
    800013b2:	197d                	addi	s2,s2,-1
    800013b4:	964a                	add	a2,a2,s2
    800013b6:	797d                	lui	s2,0xfffff
    800013b8:	01267933          	and	s2,a2,s2
  for (u64 cur = ori;cur < end; cur += PGSIZE){
    800013bc:	04d97063          	bgeu	s2,a3,800013fc <uvmapping+0x60>
    800013c0:	8a2a                	mv	s4,a0
    800013c2:	8aae                	mv	s5,a1
    800013c4:	89b6                	mv	s3,a3
    800013c6:	6b05                	lui	s6,0x1
    pte_t *pte = walk(pagetable,cur,0);
    800013c8:	4601                	li	a2,0
    800013ca:	85ca                	mv	a1,s2
    800013cc:	8552                	mv	a0,s4
    800013ce:	00000097          	auipc	ra,0x0
    800013d2:	bd8080e7          	jalr	-1064(ra) # 80000fa6 <walk>
    800013d6:	84aa                	mv	s1,a0
    if (pte == 0){
    800013d8:	cd0d                	beqz	a0,80001412 <uvmapping+0x76>
      panic("mapping should exist!");
    }
    if ((*pte & PTE_V) == 0 ){
    800013da:	611c                	ld	a5,0(a0)
    800013dc:	8b85                	andi	a5,a5,1
    800013de:	c3b1                	beqz	a5,80001422 <uvmapping+0x86>
      panic("should exist a valid mapping");
    }
    pte_t *d_pte = walk(dst,cur,1);
    800013e0:	4605                	li	a2,1
    800013e2:	85ca                	mv	a1,s2
    800013e4:	8556                	mv	a0,s5
    800013e6:	00000097          	auipc	ra,0x0
    800013ea:	bc0080e7          	jalr	-1088(ra) # 80000fa6 <walk>
    if (d_pte == 0){
    800013ee:	c131                	beqz	a0,80001432 <uvmapping+0x96>
      panic("can't allocate an pte");
    }
    *d_pte = *pte & (~PTE_U);
    800013f0:	609c                	ld	a5,0(s1)
    800013f2:	9bbd                	andi	a5,a5,-17
    800013f4:	e11c                	sd	a5,0(a0)
  for (u64 cur = ori;cur < end; cur += PGSIZE){
    800013f6:	995a                	add	s2,s2,s6
    800013f8:	fd3968e3          	bltu	s2,s3,800013c8 <uvmapping+0x2c>
  }
  return 0;
}
    800013fc:	4501                	li	a0,0
    800013fe:	70e2                	ld	ra,56(sp)
    80001400:	7442                	ld	s0,48(sp)
    80001402:	74a2                	ld	s1,40(sp)
    80001404:	7902                	ld	s2,32(sp)
    80001406:	69e2                	ld	s3,24(sp)
    80001408:	6a42                	ld	s4,16(sp)
    8000140a:	6aa2                	ld	s5,8(sp)
    8000140c:	6b02                	ld	s6,0(sp)
    8000140e:	6121                	addi	sp,sp,64
    80001410:	8082                	ret
      panic("mapping should exist!");
    80001412:	00007517          	auipc	a0,0x7
    80001416:	d4e50513          	addi	a0,a0,-690 # 80008160 <digits+0x120>
    8000141a:	fffff097          	auipc	ra,0xfffff
    8000141e:	110080e7          	jalr	272(ra) # 8000052a <panic>
      panic("should exist a valid mapping");
    80001422:	00007517          	auipc	a0,0x7
    80001426:	d5650513          	addi	a0,a0,-682 # 80008178 <digits+0x138>
    8000142a:	fffff097          	auipc	ra,0xfffff
    8000142e:	100080e7          	jalr	256(ra) # 8000052a <panic>
      panic("can't allocate an pte");
    80001432:	00007517          	auipc	a0,0x7
    80001436:	d6650513          	addi	a0,a0,-666 # 80008198 <digits+0x158>
    8000143a:	fffff097          	auipc	ra,0xfffff
    8000143e:	0f0080e7          	jalr	240(ra) # 8000052a <panic>

0000000080001442 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001442:	1101                	addi	sp,sp,-32
    80001444:	ec06                	sd	ra,24(sp)
    80001446:	e822                	sd	s0,16(sp)
    80001448:	e426                	sd	s1,8(sp)
    8000144a:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000144c:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000144e:	00b67d63          	bgeu	a2,a1,80001468 <uvmdealloc+0x26>
    80001452:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001454:	6785                	lui	a5,0x1
    80001456:	17fd                	addi	a5,a5,-1
    80001458:	00f60733          	add	a4,a2,a5
    8000145c:	767d                	lui	a2,0xfffff
    8000145e:	8f71                	and	a4,a4,a2
    80001460:	97ae                	add	a5,a5,a1
    80001462:	8ff1                	and	a5,a5,a2
    80001464:	00f76863          	bltu	a4,a5,80001474 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001468:	8526                	mv	a0,s1
    8000146a:	60e2                	ld	ra,24(sp)
    8000146c:	6442                	ld	s0,16(sp)
    8000146e:	64a2                	ld	s1,8(sp)
    80001470:	6105                	addi	sp,sp,32
    80001472:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001474:	8f99                	sub	a5,a5,a4
    80001476:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001478:	4685                	li	a3,1
    8000147a:	0007861b          	sext.w	a2,a5
    8000147e:	85ba                	mv	a1,a4
    80001480:	00000097          	auipc	ra,0x0
    80001484:	db8080e7          	jalr	-584(ra) # 80001238 <uvmunmap>
    80001488:	b7c5                	j	80001468 <uvmdealloc+0x26>

000000008000148a <uvmalloc>:
  if(newsz < oldsz)
    8000148a:	0cb66963          	bltu	a2,a1,8000155c <uvmalloc+0xd2>
{
    8000148e:	7139                	addi	sp,sp,-64
    80001490:	fc06                	sd	ra,56(sp)
    80001492:	f822                	sd	s0,48(sp)
    80001494:	f426                	sd	s1,40(sp)
    80001496:	f04a                	sd	s2,32(sp)
    80001498:	ec4e                	sd	s3,24(sp)
    8000149a:	e852                	sd	s4,16(sp)
    8000149c:	e456                	sd	s5,8(sp)
    8000149e:	e05a                	sd	s6,0(sp)
    800014a0:	0080                	addi	s0,sp,64
    800014a2:	8aaa                	mv	s5,a0
    800014a4:	8b32                	mv	s6,a2
  if (newsz >= PLIC){
    800014a6:	0c0007b7          	lui	a5,0xc000
    800014aa:	06f67163          	bgeu	a2,a5,8000150c <uvmalloc+0x82>
  oldsz = PGROUNDUP(oldsz);
    800014ae:	6985                	lui	s3,0x1
    800014b0:	19fd                	addi	s3,s3,-1
    800014b2:	95ce                	add	a1,a1,s3
    800014b4:	79fd                	lui	s3,0xfffff
    800014b6:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800014ba:	0ac9f363          	bgeu	s3,a2,80001560 <uvmalloc+0xd6>
    800014be:	fff60a13          	addi	s4,a2,-1 # ffffffffffffefff <end+0xffffffff7ffd8fff>
    800014c2:	413a0a33          	sub	s4,s4,s3
    800014c6:	77fd                	lui	a5,0xfffff
    800014c8:	00fa7a33          	and	s4,s4,a5
    800014cc:	6785                	lui	a5,0x1
    800014ce:	97ce                	add	a5,a5,s3
    800014d0:	9a3e                	add	s4,s4,a5
    800014d2:	894e                	mv	s2,s3
    mem = kalloc();
    800014d4:	fffff097          	auipc	ra,0xfffff
    800014d8:	5fe080e7          	jalr	1534(ra) # 80000ad2 <kalloc>
    800014dc:	84aa                	mv	s1,a0
    if(mem == 0){
    800014de:	cd1d                	beqz	a0,8000151c <uvmalloc+0x92>
    memset(mem, 0, PGSIZE);
    800014e0:	6605                	lui	a2,0x1
    800014e2:	4581                	li	a1,0
    800014e4:	fffff097          	auipc	ra,0xfffff
    800014e8:	7da080e7          	jalr	2010(ra) # 80000cbe <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800014ec:	4779                	li	a4,30
    800014ee:	86a6                	mv	a3,s1
    800014f0:	6605                	lui	a2,0x1
    800014f2:	85ca                	mv	a1,s2
    800014f4:	8556                	mv	a0,s5
    800014f6:	00000097          	auipc	ra,0x0
    800014fa:	b98080e7          	jalr	-1128(ra) # 8000108e <mappages>
    800014fe:	e129                	bnez	a0,80001540 <uvmalloc+0xb6>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001500:	6785                	lui	a5,0x1
    80001502:	993e                	add	s2,s2,a5
    80001504:	fd4918e3          	bne	s2,s4,800014d4 <uvmalloc+0x4a>
  return newsz;
    80001508:	855a                	mv	a0,s6
    8000150a:	a00d                	j	8000152c <uvmalloc+0xa2>
    panic("user memory overloaded!");
    8000150c:	00007517          	auipc	a0,0x7
    80001510:	ca450513          	addi	a0,a0,-860 # 800081b0 <digits+0x170>
    80001514:	fffff097          	auipc	ra,0xfffff
    80001518:	016080e7          	jalr	22(ra) # 8000052a <panic>
      uvmdealloc(pagetable, a, oldsz);
    8000151c:	864e                	mv	a2,s3
    8000151e:	85ca                	mv	a1,s2
    80001520:	8556                	mv	a0,s5
    80001522:	00000097          	auipc	ra,0x0
    80001526:	f20080e7          	jalr	-224(ra) # 80001442 <uvmdealloc>
      return 0;
    8000152a:	4501                	li	a0,0
}
    8000152c:	70e2                	ld	ra,56(sp)
    8000152e:	7442                	ld	s0,48(sp)
    80001530:	74a2                	ld	s1,40(sp)
    80001532:	7902                	ld	s2,32(sp)
    80001534:	69e2                	ld	s3,24(sp)
    80001536:	6a42                	ld	s4,16(sp)
    80001538:	6aa2                	ld	s5,8(sp)
    8000153a:	6b02                	ld	s6,0(sp)
    8000153c:	6121                	addi	sp,sp,64
    8000153e:	8082                	ret
      kfree(mem);
    80001540:	8526                	mv	a0,s1
    80001542:	fffff097          	auipc	ra,0xfffff
    80001546:	494080e7          	jalr	1172(ra) # 800009d6 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000154a:	864e                	mv	a2,s3
    8000154c:	85ca                	mv	a1,s2
    8000154e:	8556                	mv	a0,s5
    80001550:	00000097          	auipc	ra,0x0
    80001554:	ef2080e7          	jalr	-270(ra) # 80001442 <uvmdealloc>
      return 0;
    80001558:	4501                	li	a0,0
    8000155a:	bfc9                	j	8000152c <uvmalloc+0xa2>
    return oldsz;
    8000155c:	852e                	mv	a0,a1
}
    8000155e:	8082                	ret
  return newsz;
    80001560:	8532                	mv	a0,a2
    80001562:	b7e9                	j	8000152c <uvmalloc+0xa2>

0000000080001564 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001564:	7179                	addi	sp,sp,-48
    80001566:	f406                	sd	ra,40(sp)
    80001568:	f022                	sd	s0,32(sp)
    8000156a:	ec26                	sd	s1,24(sp)
    8000156c:	e84a                	sd	s2,16(sp)
    8000156e:	e44e                	sd	s3,8(sp)
    80001570:	e052                	sd	s4,0(sp)
    80001572:	1800                	addi	s0,sp,48
    80001574:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001576:	84aa                	mv	s1,a0
    80001578:	6905                	lui	s2,0x1
    8000157a:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000157c:	4985                	li	s3,1
    8000157e:	a821                	j	80001596 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001580:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80001582:	0532                	slli	a0,a0,0xc
    80001584:	00000097          	auipc	ra,0x0
    80001588:	fe0080e7          	jalr	-32(ra) # 80001564 <freewalk>
      pagetable[i] = 0;
    8000158c:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001590:	04a1                	addi	s1,s1,8
    80001592:	03248163          	beq	s1,s2,800015b4 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80001596:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001598:	00f57793          	andi	a5,a0,15
    8000159c:	ff3782e3          	beq	a5,s3,80001580 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800015a0:	8905                	andi	a0,a0,1
    800015a2:	d57d                	beqz	a0,80001590 <freewalk+0x2c>
      panic("freewalk: leaf");
    800015a4:	00007517          	auipc	a0,0x7
    800015a8:	c2450513          	addi	a0,a0,-988 # 800081c8 <digits+0x188>
    800015ac:	fffff097          	auipc	ra,0xfffff
    800015b0:	f7e080e7          	jalr	-130(ra) # 8000052a <panic>
    }
  }
  kfree((void*)pagetable);
    800015b4:	8552                	mv	a0,s4
    800015b6:	fffff097          	auipc	ra,0xfffff
    800015ba:	420080e7          	jalr	1056(ra) # 800009d6 <kfree>
}
    800015be:	70a2                	ld	ra,40(sp)
    800015c0:	7402                	ld	s0,32(sp)
    800015c2:	64e2                	ld	s1,24(sp)
    800015c4:	6942                	ld	s2,16(sp)
    800015c6:	69a2                	ld	s3,8(sp)
    800015c8:	6a02                	ld	s4,0(sp)
    800015ca:	6145                	addi	sp,sp,48
    800015cc:	8082                	ret

00000000800015ce <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800015ce:	1101                	addi	sp,sp,-32
    800015d0:	ec06                	sd	ra,24(sp)
    800015d2:	e822                	sd	s0,16(sp)
    800015d4:	e426                	sd	s1,8(sp)
    800015d6:	1000                	addi	s0,sp,32
    800015d8:	84aa                	mv	s1,a0
  if(sz > 0)
    800015da:	e999                	bnez	a1,800015f0 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800015dc:	8526                	mv	a0,s1
    800015de:	00000097          	auipc	ra,0x0
    800015e2:	f86080e7          	jalr	-122(ra) # 80001564 <freewalk>
}
    800015e6:	60e2                	ld	ra,24(sp)
    800015e8:	6442                	ld	s0,16(sp)
    800015ea:	64a2                	ld	s1,8(sp)
    800015ec:	6105                	addi	sp,sp,32
    800015ee:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800015f0:	6605                	lui	a2,0x1
    800015f2:	167d                	addi	a2,a2,-1
    800015f4:	962e                	add	a2,a2,a1
    800015f6:	4685                	li	a3,1
    800015f8:	8231                	srli	a2,a2,0xc
    800015fa:	4581                	li	a1,0
    800015fc:	00000097          	auipc	ra,0x0
    80001600:	c3c080e7          	jalr	-964(ra) # 80001238 <uvmunmap>
    80001604:	bfe1                	j	800015dc <uvmfree+0xe>

0000000080001606 <free_kmapping>:



void  
free_kmapping( struct proc *p)
{
    80001606:	7179                	addi	sp,sp,-48
    80001608:	f406                	sd	ra,40(sp)
    8000160a:	f022                	sd	s0,32(sp)
    8000160c:	ec26                	sd	s1,24(sp)
    8000160e:	e84a                	sd	s2,16(sp)
    80001610:	e44e                	sd	s3,8(sp)
    80001612:	1800                	addi	s0,sp,48
    80001614:	892a                	mv	s2,a0

  pagetable_t k_pagetable = p->k_pagetable;
    80001616:	7124                	ld	s1,96(a0)
  uvmunmap(k_pagetable,UART0,1,0);
    80001618:	4681                	li	a3,0
    8000161a:	4605                	li	a2,1
    8000161c:	100005b7          	lui	a1,0x10000
    80001620:	8526                	mv	a0,s1
    80001622:	00000097          	auipc	ra,0x0
    80001626:	c16080e7          	jalr	-1002(ra) # 80001238 <uvmunmap>
  uvmunmap(k_pagetable,VIRTIO0, 1, 0);
    8000162a:	4681                	li	a3,0
    8000162c:	4605                	li	a2,1
    8000162e:	100015b7          	lui	a1,0x10001
    80001632:	8526                	mv	a0,s1
    80001634:	00000097          	auipc	ra,0x0
    80001638:	c04080e7          	jalr	-1020(ra) # 80001238 <uvmunmap>
  uvmunmap(k_pagetable,PLIC,(0x400000)/PGSIZE,0);
    8000163c:	4681                	li	a3,0
    8000163e:	40000613          	li	a2,1024
    80001642:	0c0005b7          	lui	a1,0xc000
    80001646:	8526                	mv	a0,s1
    80001648:	00000097          	auipc	ra,0x0
    8000164c:	bf0080e7          	jalr	-1040(ra) # 80001238 <uvmunmap>
  uvmunmap(k_pagetable,KERNBASE,((uint64)etext-KERNBASE) / PGSIZE,0);
    80001650:	00007997          	auipc	s3,0x7
    80001654:	9b098993          	addi	s3,s3,-1616 # 80008000 <etext>
    80001658:	4681                	li	a3,0
    8000165a:	80007617          	auipc	a2,0x80007
    8000165e:	9a660613          	addi	a2,a2,-1626 # 8000 <_entry-0x7fff8000>
    80001662:	8231                	srli	a2,a2,0xc
    80001664:	4585                	li	a1,1
    80001666:	05fe                	slli	a1,a1,0x1f
    80001668:	8526                	mv	a0,s1
    8000166a:	00000097          	auipc	ra,0x0
    8000166e:	bce080e7          	jalr	-1074(ra) # 80001238 <uvmunmap>
  uvmunmap(k_pagetable,(u64)etext,(PHYSTOP - (u64)etext) / PGSIZE,0);
    80001672:	4645                	li	a2,17
    80001674:	066e                	slli	a2,a2,0x1b
    80001676:	41360633          	sub	a2,a2,s3
    8000167a:	4681                	li	a3,0
    8000167c:	8231                	srli	a2,a2,0xc
    8000167e:	85ce                	mv	a1,s3
    80001680:	8526                	mv	a0,s1
    80001682:	00000097          	auipc	ra,0x0
    80001686:	bb6080e7          	jalr	-1098(ra) # 80001238 <uvmunmap>
  uvmunmap(k_pagetable,TRAMPOLINE,1,0);
    8000168a:	4681                	li	a3,0
    8000168c:	4605                	li	a2,1
    8000168e:	040005b7          	lui	a1,0x4000
    80001692:	15fd                	addi	a1,a1,-1
    80001694:	05b2                	slli	a1,a1,0xc
    80001696:	8526                	mv	a0,s1
    80001698:	00000097          	auipc	ra,0x0
    8000169c:	ba0080e7          	jalr	-1120(ra) # 80001238 <uvmunmap>

  //  * free physical page for kernel stack
  pte_t *pte =  walk(p->k_pagetable,p->kstack,0);
    800016a0:	4601                	li	a2,0
    800016a2:	04893583          	ld	a1,72(s2) # 1048 <_entry-0x7fffefb8>
    800016a6:	06093503          	ld	a0,96(s2)
    800016aa:	00000097          	auipc	ra,0x0
    800016ae:	8fc080e7          	jalr	-1796(ra) # 80000fa6 <walk>
  void *s = (void*)PTE2PA(*pte);
    800016b2:	6108                	ld	a0,0(a0)
    800016b4:	8129                	srli	a0,a0,0xa
  kfree(s);
    800016b6:	0532                	slli	a0,a0,0xc
    800016b8:	fffff097          	auipc	ra,0xfffff
    800016bc:	31e080e7          	jalr	798(ra) # 800009d6 <kfree>
  uvmunmap(k_pagetable,p->kstack,1,0);
    800016c0:	4681                	li	a3,0
    800016c2:	4605                	li	a2,1
    800016c4:	04893583          	ld	a1,72(s2)
    800016c8:	8526                	mv	a0,s1
    800016ca:	00000097          	auipc	ra,0x0
    800016ce:	b6e080e7          	jalr	-1170(ra) # 80001238 <uvmunmap>


}
    800016d2:	70a2                	ld	ra,40(sp)
    800016d4:	7402                	ld	s0,32(sp)
    800016d6:	64e2                	ld	s1,24(sp)
    800016d8:	6942                	ld	s2,16(sp)
    800016da:	69a2                	ld	s3,8(sp)
    800016dc:	6145                	addi	sp,sp,48
    800016de:	8082                	ret

00000000800016e0 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800016e0:	c679                	beqz	a2,800017ae <uvmcopy+0xce>
{
    800016e2:	715d                	addi	sp,sp,-80
    800016e4:	e486                	sd	ra,72(sp)
    800016e6:	e0a2                	sd	s0,64(sp)
    800016e8:	fc26                	sd	s1,56(sp)
    800016ea:	f84a                	sd	s2,48(sp)
    800016ec:	f44e                	sd	s3,40(sp)
    800016ee:	f052                	sd	s4,32(sp)
    800016f0:	ec56                	sd	s5,24(sp)
    800016f2:	e85a                	sd	s6,16(sp)
    800016f4:	e45e                	sd	s7,8(sp)
    800016f6:	0880                	addi	s0,sp,80
    800016f8:	8b2a                	mv	s6,a0
    800016fa:	8aae                	mv	s5,a1
    800016fc:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    800016fe:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001700:	4601                	li	a2,0
    80001702:	85ce                	mv	a1,s3
    80001704:	855a                	mv	a0,s6
    80001706:	00000097          	auipc	ra,0x0
    8000170a:	8a0080e7          	jalr	-1888(ra) # 80000fa6 <walk>
    8000170e:	c531                	beqz	a0,8000175a <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80001710:	6118                	ld	a4,0(a0)
    80001712:	00177793          	andi	a5,a4,1
    80001716:	cbb1                	beqz	a5,8000176a <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001718:	00a75593          	srli	a1,a4,0xa
    8000171c:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001720:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80001724:	fffff097          	auipc	ra,0xfffff
    80001728:	3ae080e7          	jalr	942(ra) # 80000ad2 <kalloc>
    8000172c:	892a                	mv	s2,a0
    8000172e:	c939                	beqz	a0,80001784 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001730:	6605                	lui	a2,0x1
    80001732:	85de                	mv	a1,s7
    80001734:	fffff097          	auipc	ra,0xfffff
    80001738:	5e6080e7          	jalr	1510(ra) # 80000d1a <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000173c:	8726                	mv	a4,s1
    8000173e:	86ca                	mv	a3,s2
    80001740:	6605                	lui	a2,0x1
    80001742:	85ce                	mv	a1,s3
    80001744:	8556                	mv	a0,s5
    80001746:	00000097          	auipc	ra,0x0
    8000174a:	948080e7          	jalr	-1720(ra) # 8000108e <mappages>
    8000174e:	e515                	bnez	a0,8000177a <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80001750:	6785                	lui	a5,0x1
    80001752:	99be                	add	s3,s3,a5
    80001754:	fb49e6e3          	bltu	s3,s4,80001700 <uvmcopy+0x20>
    80001758:	a081                	j	80001798 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    8000175a:	00007517          	auipc	a0,0x7
    8000175e:	a7e50513          	addi	a0,a0,-1410 # 800081d8 <digits+0x198>
    80001762:	fffff097          	auipc	ra,0xfffff
    80001766:	dc8080e7          	jalr	-568(ra) # 8000052a <panic>
      panic("uvmcopy: page not present");
    8000176a:	00007517          	auipc	a0,0x7
    8000176e:	a8e50513          	addi	a0,a0,-1394 # 800081f8 <digits+0x1b8>
    80001772:	fffff097          	auipc	ra,0xfffff
    80001776:	db8080e7          	jalr	-584(ra) # 8000052a <panic>
      kfree(mem);
    8000177a:	854a                	mv	a0,s2
    8000177c:	fffff097          	auipc	ra,0xfffff
    80001780:	25a080e7          	jalr	602(ra) # 800009d6 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001784:	4685                	li	a3,1
    80001786:	00c9d613          	srli	a2,s3,0xc
    8000178a:	4581                	li	a1,0
    8000178c:	8556                	mv	a0,s5
    8000178e:	00000097          	auipc	ra,0x0
    80001792:	aaa080e7          	jalr	-1366(ra) # 80001238 <uvmunmap>
  return -1;
    80001796:	557d                	li	a0,-1
}
    80001798:	60a6                	ld	ra,72(sp)
    8000179a:	6406                	ld	s0,64(sp)
    8000179c:	74e2                	ld	s1,56(sp)
    8000179e:	7942                	ld	s2,48(sp)
    800017a0:	79a2                	ld	s3,40(sp)
    800017a2:	7a02                	ld	s4,32(sp)
    800017a4:	6ae2                	ld	s5,24(sp)
    800017a6:	6b42                	ld	s6,16(sp)
    800017a8:	6ba2                	ld	s7,8(sp)
    800017aa:	6161                	addi	sp,sp,80
    800017ac:	8082                	ret
  return 0;
    800017ae:	4501                	li	a0,0
}
    800017b0:	8082                	ret

00000000800017b2 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800017b2:	1141                	addi	sp,sp,-16
    800017b4:	e406                	sd	ra,8(sp)
    800017b6:	e022                	sd	s0,0(sp)
    800017b8:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800017ba:	4601                	li	a2,0
    800017bc:	fffff097          	auipc	ra,0xfffff
    800017c0:	7ea080e7          	jalr	2026(ra) # 80000fa6 <walk>
  if(pte == 0)
    800017c4:	c901                	beqz	a0,800017d4 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800017c6:	611c                	ld	a5,0(a0)
    800017c8:	9bbd                	andi	a5,a5,-17
    800017ca:	e11c                	sd	a5,0(a0)
}
    800017cc:	60a2                	ld	ra,8(sp)
    800017ce:	6402                	ld	s0,0(sp)
    800017d0:	0141                	addi	sp,sp,16
    800017d2:	8082                	ret
    panic("uvmclear");
    800017d4:	00007517          	auipc	a0,0x7
    800017d8:	a4450513          	addi	a0,a0,-1468 # 80008218 <digits+0x1d8>
    800017dc:	fffff097          	auipc	ra,0xfffff
    800017e0:	d4e080e7          	jalr	-690(ra) # 8000052a <panic>

00000000800017e4 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800017e4:	c6bd                	beqz	a3,80001852 <copyout+0x6e>
{
    800017e6:	715d                	addi	sp,sp,-80
    800017e8:	e486                	sd	ra,72(sp)
    800017ea:	e0a2                	sd	s0,64(sp)
    800017ec:	fc26                	sd	s1,56(sp)
    800017ee:	f84a                	sd	s2,48(sp)
    800017f0:	f44e                	sd	s3,40(sp)
    800017f2:	f052                	sd	s4,32(sp)
    800017f4:	ec56                	sd	s5,24(sp)
    800017f6:	e85a                	sd	s6,16(sp)
    800017f8:	e45e                	sd	s7,8(sp)
    800017fa:	e062                	sd	s8,0(sp)
    800017fc:	0880                	addi	s0,sp,80
    800017fe:	8b2a                	mv	s6,a0
    80001800:	8c2e                	mv	s8,a1
    80001802:	8a32                	mv	s4,a2
    80001804:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001806:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001808:	6a85                	lui	s5,0x1
    8000180a:	a015                	j	8000182e <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    8000180c:	9562                	add	a0,a0,s8
    8000180e:	0004861b          	sext.w	a2,s1
    80001812:	85d2                	mv	a1,s4
    80001814:	41250533          	sub	a0,a0,s2
    80001818:	fffff097          	auipc	ra,0xfffff
    8000181c:	502080e7          	jalr	1282(ra) # 80000d1a <memmove>

    len -= n;
    80001820:	409989b3          	sub	s3,s3,s1
    src += n;
    80001824:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80001826:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000182a:	02098263          	beqz	s3,8000184e <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    8000182e:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001832:	85ca                	mv	a1,s2
    80001834:	855a                	mv	a0,s6
    80001836:	00000097          	auipc	ra,0x0
    8000183a:	816080e7          	jalr	-2026(ra) # 8000104c <walkaddr>
    if(pa0 == 0)
    8000183e:	cd01                	beqz	a0,80001856 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80001840:	418904b3          	sub	s1,s2,s8
    80001844:	94d6                	add	s1,s1,s5
    if(n > len)
    80001846:	fc99f3e3          	bgeu	s3,s1,8000180c <copyout+0x28>
    8000184a:	84ce                	mv	s1,s3
    8000184c:	b7c1                	j	8000180c <copyout+0x28>
  }
  return 0;
    8000184e:	4501                	li	a0,0
    80001850:	a021                	j	80001858 <copyout+0x74>
    80001852:	4501                	li	a0,0
}
    80001854:	8082                	ret
      return -1;
    80001856:	557d                	li	a0,-1
}
    80001858:	60a6                	ld	ra,72(sp)
    8000185a:	6406                	ld	s0,64(sp)
    8000185c:	74e2                	ld	s1,56(sp)
    8000185e:	7942                	ld	s2,48(sp)
    80001860:	79a2                	ld	s3,40(sp)
    80001862:	7a02                	ld	s4,32(sp)
    80001864:	6ae2                	ld	s5,24(sp)
    80001866:	6b42                	ld	s6,16(sp)
    80001868:	6ba2                	ld	s7,8(sp)
    8000186a:	6c02                	ld	s8,0(sp)
    8000186c:	6161                	addi	sp,sp,80
    8000186e:	8082                	ret

0000000080001870 <copyin_new>:
// Copy from user to kernel.
// Copy len bytes to dst from virtual address srcva in a given page table.
// Return 0 on success, -1 on error.

int
copyin_new(char *dst, uint64 srcva, uint64 len){
    80001870:	7139                	addi	sp,sp,-64
    80001872:	fc06                	sd	ra,56(sp)
    80001874:	f822                	sd	s0,48(sp)
    80001876:	f426                	sd	s1,40(sp)
    80001878:	f04a                	sd	s2,32(sp)
    8000187a:	ec4e                	sd	s3,24(sp)
    8000187c:	e852                	sd	s4,16(sp)
    8000187e:	e456                	sd	s5,8(sp)
    80001880:	e05a                	sd	s6,0(sp)
    80001882:	0080                	addi	s0,sp,64
  uint64 n, va0, pa0;
  if (srcva > PLIC){
    80001884:	0c0007b7          	lui	a5,0xc000
    80001888:	02b7e263          	bltu	a5,a1,800018ac <copyin_new+0x3c>
    8000188c:	89aa                	mv	s3,a0
    8000188e:	8932                	mv	s2,a2
  // if (*pte1 != *pte2){
  //   printf("pte1 = %p , pte2 = %p\n",PTE2PA(*pte1),PTE2PA(*pte2));
  // }

  while(len > 0){
    va0 = PGROUNDDOWN(srcva);
    80001890:	7b7d                	lui	s6,0xfffff
    n = PGSIZE - (srcva - va0);
    80001892:	6a85                	lui	s5,0x1
  while(len > 0){
    80001894:	e231                	bnez	a2,800018d8 <copyin_new+0x68>
    len -= n;
    dst += n;
    srcva = va0 + PGSIZE;
  }
  return 0;
}
    80001896:	4501                	li	a0,0
    80001898:	70e2                	ld	ra,56(sp)
    8000189a:	7442                	ld	s0,48(sp)
    8000189c:	74a2                	ld	s1,40(sp)
    8000189e:	7902                	ld	s2,32(sp)
    800018a0:	69e2                	ld	s3,24(sp)
    800018a2:	6a42                	ld	s4,16(sp)
    800018a4:	6aa2                	ld	s5,8(sp)
    800018a6:	6b02                	ld	s6,0(sp)
    800018a8:	6121                	addi	sp,sp,64
    800018aa:	8082                	ret
    panic("invalid user pointer");
    800018ac:	00007517          	auipc	a0,0x7
    800018b0:	97c50513          	addi	a0,a0,-1668 # 80008228 <digits+0x1e8>
    800018b4:	fffff097          	auipc	ra,0xfffff
    800018b8:	c76080e7          	jalr	-906(ra) # 8000052a <panic>
    memmove(dst, (void *)srcva, n);
    800018bc:	0004861b          	sext.w	a2,s1
    800018c0:	854e                	mv	a0,s3
    800018c2:	fffff097          	auipc	ra,0xfffff
    800018c6:	458080e7          	jalr	1112(ra) # 80000d1a <memmove>
    len -= n;
    800018ca:	40990933          	sub	s2,s2,s1
    dst += n;
    800018ce:	99a6                	add	s3,s3,s1
    srcva = va0 + PGSIZE;
    800018d0:	015a05b3          	add	a1,s4,s5
  while(len > 0){
    800018d4:	fc0901e3          	beqz	s2,80001896 <copyin_new+0x26>
    va0 = PGROUNDDOWN(srcva);
    800018d8:	0165fa33          	and	s4,a1,s6
    n = PGSIZE - (srcva - va0);
    800018dc:	40ba04b3          	sub	s1,s4,a1
    800018e0:	94d6                	add	s1,s1,s5
    if(n > len)
    800018e2:	fc997de3          	bgeu	s2,s1,800018bc <copyin_new+0x4c>
    800018e6:	84ca                	mv	s1,s2
    800018e8:	bfd1                	j	800018bc <copyin_new+0x4c>

00000000800018ea <copyin>:

int
copyin(pagetable_t p, char *dst, uint64 srcva, uint64 len)
{
    800018ea:	1141                	addi	sp,sp,-16
    800018ec:	e406                	sd	ra,8(sp)
    800018ee:	e022                	sd	s0,0(sp)
    800018f0:	0800                	addi	s0,sp,16
    800018f2:	852e                	mv	a0,a1
    800018f4:	85b2                	mv	a1,a2
  return copyin_new(dst,srcva,len);
    800018f6:	8636                	mv	a2,a3
    800018f8:	00000097          	auipc	ra,0x0
    800018fc:	f78080e7          	jalr	-136(ra) # 80001870 <copyin_new>
}
    80001900:	60a2                	ld	ra,8(sp)
    80001902:	6402                	ld	s0,0(sp)
    80001904:	0141                	addi	sp,sp,16
    80001906:	8082                	ret

0000000080001908 <copyinstr_new>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr_new(char *dst, uint64 srcva, uint64 max)
{
    80001908:	1141                	addi	sp,sp,-16
    8000190a:	e422                	sd	s0,8(sp)
    8000190c:	0800                	addi	s0,sp,16
  uint64 n, va0, pa0;
  int got_null = 0;

  pa0 = srcva;
  while(got_null == 0 && max > 0){
    8000190e:	c23d                	beqz	a2,80001974 <copyinstr_new+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001910:	78fd                	lui	a7,0xfffff
    80001912:	0115f8b3          	and	a7,a1,a7
    // pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
    80001916:	c1ad                	beqz	a1,80001978 <copyinstr_new+0x70>
    80001918:	6785                	lui	a5,0x1
    8000191a:	98be                	add	a7,a7,a5
    8000191c:	86ae                	mv	a3,a1
    8000191e:	6305                	lui	t1,0x1
    80001920:	a831                	j	8000193c <copyinstr_new+0x34>
      n = max;

    char *p = (char*)pa0;
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001922:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001926:	4785                	li	a5,1
      dst++;
    }
    pa0 += n;
    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001928:	0017b793          	seqz	a5,a5
    8000192c:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001930:	6422                	ld	s0,8(sp)
    80001932:	0141                	addi	sp,sp,16
    80001934:	8082                	ret
  while(got_null == 0 && max > 0){
    80001936:	ce0d                	beqz	a2,80001970 <copyinstr_new+0x68>
    srcva = va0 + PGSIZE;
    80001938:	86c6                	mv	a3,a7
    if(pa0 == 0)
    8000193a:	989a                	add	a7,a7,t1
    n = PGSIZE - (srcva - va0);
    8000193c:	40d886b3          	sub	a3,a7,a3
    if(n > max)
    80001940:	00d67363          	bgeu	a2,a3,80001946 <copyinstr_new+0x3e>
    80001944:	86b2                	mv	a3,a2
    while(n > 0){
    80001946:	dae5                	beqz	a3,80001936 <copyinstr_new+0x2e>
    80001948:	96aa                	add	a3,a3,a0
    8000194a:	87aa                	mv	a5,a0
      if(*p == '\0'){
    8000194c:	40a58833          	sub	a6,a1,a0
    80001950:	167d                	addi	a2,a2,-1
    80001952:	9532                	add	a0,a0,a2
    80001954:	00f80733          	add	a4,a6,a5
    80001958:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd9000>
    8000195c:	d379                	beqz	a4,80001922 <copyinstr_new+0x1a>
        *dst = *p;
    8000195e:	00e78023          	sb	a4,0(a5)
      --max;
    80001962:	40f50633          	sub	a2,a0,a5
      dst++;
    80001966:	0785                	addi	a5,a5,1
    while(n > 0){
    80001968:	fef696e3          	bne	a3,a5,80001954 <copyinstr_new+0x4c>
      dst++;
    8000196c:	8536                	mv	a0,a3
    8000196e:	b7e1                	j	80001936 <copyinstr_new+0x2e>
    80001970:	4781                	li	a5,0
    80001972:	bf5d                	j	80001928 <copyinstr_new+0x20>
  int got_null = 0;
    80001974:	4781                	li	a5,0
    80001976:	bf4d                	j	80001928 <copyinstr_new+0x20>
      return -1;
    80001978:	557d                	li	a0,-1
    8000197a:	bf5d                	j	80001930 <copyinstr_new+0x28>

000000008000197c <copyinstr>:

int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max){
    8000197c:	1141                	addi	sp,sp,-16
    8000197e:	e406                	sd	ra,8(sp)
    80001980:	e022                	sd	s0,0(sp)
    80001982:	0800                	addi	s0,sp,16
    80001984:	852e                	mv	a0,a1
    80001986:	85b2                	mv	a1,a2
  return copyinstr_new(dst,srcva,max);
    80001988:	8636                	mv	a2,a3
    8000198a:	00000097          	auipc	ra,0x0
    8000198e:	f7e080e7          	jalr	-130(ra) # 80001908 <copyinstr_new>

}
    80001992:	60a2                	ld	ra,8(sp)
    80001994:	6402                	ld	s0,0(sp)
    80001996:	0141                	addi	sp,sp,16
    80001998:	8082                	ret

000000008000199a <vm_p_helper>:


void vm_p_helper(pagetable_t pgt,int level){
  if (level < 0 )
    8000199a:	0a05c963          	bltz	a1,80001a4c <vm_p_helper+0xb2>
void vm_p_helper(pagetable_t pgt,int level){
    8000199e:	7139                	addi	sp,sp,-64
    800019a0:	fc06                	sd	ra,56(sp)
    800019a2:	f822                	sd	s0,48(sp)
    800019a4:	f426                	sd	s1,40(sp)
    800019a6:	f04a                	sd	s2,32(sp)
    800019a8:	ec4e                	sd	s3,24(sp)
    800019aa:	e852                	sd	s4,16(sp)
    800019ac:	e456                	sd	s5,8(sp)
    800019ae:	e05a                	sd	s6,0(sp)
    800019b0:	0080                	addi	s0,sp,64
    return ; 
  char *sep;
  if (level == 2){
    800019b2:	4789                	li	a5,2
    800019b4:	02f58d63          	beq	a1,a5,800019ee <vm_p_helper+0x54>
    sep = ".."; 
  }
  else if (level == 1){
    800019b8:	4785                	li	a5,1
    800019ba:	02f58f63          	beq	a1,a5,800019f8 <vm_p_helper+0x5e>
    sep = ".. ..";
  }
  else if (level == 0){
    sep = ".. .. ..";
    800019be:	00007b17          	auipc	s6,0x7
    800019c2:	892b0b13          	addi	s6,s6,-1902 # 80008250 <digits+0x210>
  else if (level == 0){
    800019c6:	ed81                	bnez	a1,800019de <vm_p_helper+0x44>
  }
  else {
    panic("error print page table");
  }
  for(int i = 0; i <512;i++){
    800019c8:	84aa                	mv	s1,a0
    800019ca:	4901                	li	s2,0
    pte_t *pte = &pgt[i];
    if ((*pte & PTE_V) ==1){
      printf(" %s%d: pte %p pa %p\n",sep,i,*pte,PTE2PA(*pte));
    800019cc:	00007a97          	auipc	s5,0x7
    800019d0:	8aca8a93          	addi	s5,s5,-1876 # 80008278 <digits+0x238>
      vm_p_helper((pagetable_t)PTE2PA(*pte),level-1);
    800019d4:	fff58a1b          	addiw	s4,a1,-1
  for(int i = 0; i <512;i++){
    800019d8:	20000993          	li	s3,512
    800019dc:	a03d                	j	80001a0a <vm_p_helper+0x70>
    panic("error print page table");
    800019de:	00007517          	auipc	a0,0x7
    800019e2:	88250513          	addi	a0,a0,-1918 # 80008260 <digits+0x220>
    800019e6:	fffff097          	auipc	ra,0xfffff
    800019ea:	b44080e7          	jalr	-1212(ra) # 8000052a <panic>
    sep = ".."; 
    800019ee:	00007b17          	auipc	s6,0x7
    800019f2:	852b0b13          	addi	s6,s6,-1966 # 80008240 <digits+0x200>
    800019f6:	bfc9                	j	800019c8 <vm_p_helper+0x2e>
    sep = ".. ..";
    800019f8:	00007b17          	auipc	s6,0x7
    800019fc:	850b0b13          	addi	s6,s6,-1968 # 80008248 <digits+0x208>
    80001a00:	b7e1                	j	800019c8 <vm_p_helper+0x2e>
  for(int i = 0; i <512;i++){
    80001a02:	2905                	addiw	s2,s2,1
    80001a04:	04a1                	addi	s1,s1,8
    80001a06:	03390963          	beq	s2,s3,80001a38 <vm_p_helper+0x9e>
    if ((*pte & PTE_V) ==1){
    80001a0a:	6094                	ld	a3,0(s1)
    80001a0c:	0016f793          	andi	a5,a3,1
    80001a10:	dbed                	beqz	a5,80001a02 <vm_p_helper+0x68>
      printf(" %s%d: pte %p pa %p\n",sep,i,*pte,PTE2PA(*pte));
    80001a12:	00a6d713          	srli	a4,a3,0xa
    80001a16:	0732                	slli	a4,a4,0xc
    80001a18:	864a                	mv	a2,s2
    80001a1a:	85da                	mv	a1,s6
    80001a1c:	8556                	mv	a0,s5
    80001a1e:	fffff097          	auipc	ra,0xfffff
    80001a22:	b56080e7          	jalr	-1194(ra) # 80000574 <printf>
      vm_p_helper((pagetable_t)PTE2PA(*pte),level-1);
    80001a26:	6088                	ld	a0,0(s1)
    80001a28:	8129                	srli	a0,a0,0xa
    80001a2a:	85d2                	mv	a1,s4
    80001a2c:	0532                	slli	a0,a0,0xc
    80001a2e:	00000097          	auipc	ra,0x0
    80001a32:	f6c080e7          	jalr	-148(ra) # 8000199a <vm_p_helper>
    80001a36:	b7f1                	j	80001a02 <vm_p_helper+0x68>
    }
  }
}
    80001a38:	70e2                	ld	ra,56(sp)
    80001a3a:	7442                	ld	s0,48(sp)
    80001a3c:	74a2                	ld	s1,40(sp)
    80001a3e:	7902                	ld	s2,32(sp)
    80001a40:	69e2                	ld	s3,24(sp)
    80001a42:	6a42                	ld	s4,16(sp)
    80001a44:	6aa2                	ld	s5,8(sp)
    80001a46:	6b02                	ld	s6,0(sp)
    80001a48:	6121                	addi	sp,sp,64
    80001a4a:	8082                	ret
    80001a4c:	8082                	ret

0000000080001a4e <vmprint>:


void vmprint(pagetable_t pgt){
    80001a4e:	1101                	addi	sp,sp,-32
    80001a50:	ec06                	sd	ra,24(sp)
    80001a52:	e822                	sd	s0,16(sp)
    80001a54:	e426                	sd	s1,8(sp)
    80001a56:	1000                	addi	s0,sp,32
    80001a58:	84aa                	mv	s1,a0
  printf("page table %p\n",pgt);
    80001a5a:	85aa                	mv	a1,a0
    80001a5c:	00007517          	auipc	a0,0x7
    80001a60:	83450513          	addi	a0,a0,-1996 # 80008290 <digits+0x250>
    80001a64:	fffff097          	auipc	ra,0xfffff
    80001a68:	b10080e7          	jalr	-1264(ra) # 80000574 <printf>
  vm_p_helper(pgt,2);
    80001a6c:	4589                	li	a1,2
    80001a6e:	8526                	mv	a0,s1
    80001a70:	00000097          	auipc	ra,0x0
    80001a74:	f2a080e7          	jalr	-214(ra) # 8000199a <vm_p_helper>
    80001a78:	60e2                	ld	ra,24(sp)
    80001a7a:	6442                	ld	s0,16(sp)
    80001a7c:	64a2                	ld	s1,8(sp)
    80001a7e:	6105                	addi	sp,sp,32
    80001a80:	8082                	ret

0000000080001a82 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80001a82:	7139                	addi	sp,sp,-64
    80001a84:	fc06                	sd	ra,56(sp)
    80001a86:	f822                	sd	s0,48(sp)
    80001a88:	f426                	sd	s1,40(sp)
    80001a8a:	f04a                	sd	s2,32(sp)
    80001a8c:	ec4e                	sd	s3,24(sp)
    80001a8e:	e852                	sd	s4,16(sp)
    80001a90:	e456                	sd	s5,8(sp)
    80001a92:	e05a                	sd	s6,0(sp)
    80001a94:	0080                	addi	s0,sp,64
    80001a96:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a98:	00010497          	auipc	s1,0x10
    80001a9c:	c3848493          	addi	s1,s1,-968 # 800116d0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001aa0:	8b26                	mv	s6,s1
    80001aa2:	00006a97          	auipc	s5,0x6
    80001aa6:	55ea8a93          	addi	s5,s5,1374 # 80008000 <etext>
    80001aaa:	04000937          	lui	s2,0x4000
    80001aae:	197d                	addi	s2,s2,-1
    80001ab0:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ab2:	00016a17          	auipc	s4,0x16
    80001ab6:	a1ea0a13          	addi	s4,s4,-1506 # 800174d0 <tickslock>
    char *pa = kalloc();
    80001aba:	fffff097          	auipc	ra,0xfffff
    80001abe:	018080e7          	jalr	24(ra) # 80000ad2 <kalloc>
    80001ac2:	862a                	mv	a2,a0
    if(pa == 0)
    80001ac4:	c131                	beqz	a0,80001b08 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80001ac6:	416485b3          	sub	a1,s1,s6
    80001aca:	858d                	srai	a1,a1,0x3
    80001acc:	000ab783          	ld	a5,0(s5)
    80001ad0:	02f585b3          	mul	a1,a1,a5
    80001ad4:	2585                	addiw	a1,a1,1
    80001ad6:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001ada:	4719                	li	a4,6
    80001adc:	6685                	lui	a3,0x1
    80001ade:	40b905b3          	sub	a1,s2,a1
    80001ae2:	854e                	mv	a0,s3
    80001ae4:	fffff097          	auipc	ra,0xfffff
    80001ae8:	638080e7          	jalr	1592(ra) # 8000111c <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001aec:	17848493          	addi	s1,s1,376
    80001af0:	fd4495e3          	bne	s1,s4,80001aba <proc_mapstacks+0x38>
  }
}
    80001af4:	70e2                	ld	ra,56(sp)
    80001af6:	7442                	ld	s0,48(sp)
    80001af8:	74a2                	ld	s1,40(sp)
    80001afa:	7902                	ld	s2,32(sp)
    80001afc:	69e2                	ld	s3,24(sp)
    80001afe:	6a42                	ld	s4,16(sp)
    80001b00:	6aa2                	ld	s5,8(sp)
    80001b02:	6b02                	ld	s6,0(sp)
    80001b04:	6121                	addi	sp,sp,64
    80001b06:	8082                	ret
      panic("kalloc");
    80001b08:	00006517          	auipc	a0,0x6
    80001b0c:	79850513          	addi	a0,a0,1944 # 800082a0 <digits+0x260>
    80001b10:	fffff097          	auipc	ra,0xfffff
    80001b14:	a1a080e7          	jalr	-1510(ra) # 8000052a <panic>

0000000080001b18 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80001b18:	7139                	addi	sp,sp,-64
    80001b1a:	fc06                	sd	ra,56(sp)
    80001b1c:	f822                	sd	s0,48(sp)
    80001b1e:	f426                	sd	s1,40(sp)
    80001b20:	f04a                	sd	s2,32(sp)
    80001b22:	ec4e                	sd	s3,24(sp)
    80001b24:	e852                	sd	s4,16(sp)
    80001b26:	e456                	sd	s5,8(sp)
    80001b28:	e05a                	sd	s6,0(sp)
    80001b2a:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001b2c:	00006597          	auipc	a1,0x6
    80001b30:	77c58593          	addi	a1,a1,1916 # 800082a8 <digits+0x268>
    80001b34:	0000f517          	auipc	a0,0xf
    80001b38:	76c50513          	addi	a0,a0,1900 # 800112a0 <pid_lock>
    80001b3c:	fffff097          	auipc	ra,0xfffff
    80001b40:	ff6080e7          	jalr	-10(ra) # 80000b32 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001b44:	00006597          	auipc	a1,0x6
    80001b48:	76c58593          	addi	a1,a1,1900 # 800082b0 <digits+0x270>
    80001b4c:	0000f517          	auipc	a0,0xf
    80001b50:	76c50513          	addi	a0,a0,1900 # 800112b8 <wait_lock>
    80001b54:	fffff097          	auipc	ra,0xfffff
    80001b58:	fde080e7          	jalr	-34(ra) # 80000b32 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b5c:	00010497          	auipc	s1,0x10
    80001b60:	b7448493          	addi	s1,s1,-1164 # 800116d0 <proc>
      initlock(&p->lock, "proc");
    80001b64:	00006b17          	auipc	s6,0x6
    80001b68:	75cb0b13          	addi	s6,s6,1884 # 800082c0 <digits+0x280>
      p->kstack = KSTACK((int) (p - proc));
    80001b6c:	8aa6                	mv	s5,s1
    80001b6e:	00006a17          	auipc	s4,0x6
    80001b72:	492a0a13          	addi	s4,s4,1170 # 80008000 <etext>
    80001b76:	04000937          	lui	s2,0x4000
    80001b7a:	197d                	addi	s2,s2,-1
    80001b7c:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b7e:	00016997          	auipc	s3,0x16
    80001b82:	95298993          	addi	s3,s3,-1710 # 800174d0 <tickslock>
      initlock(&p->lock, "proc");
    80001b86:	85da                	mv	a1,s6
    80001b88:	8526                	mv	a0,s1
    80001b8a:	fffff097          	auipc	ra,0xfffff
    80001b8e:	fa8080e7          	jalr	-88(ra) # 80000b32 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80001b92:	415487b3          	sub	a5,s1,s5
    80001b96:	878d                	srai	a5,a5,0x3
    80001b98:	000a3703          	ld	a4,0(s4)
    80001b9c:	02e787b3          	mul	a5,a5,a4
    80001ba0:	2785                	addiw	a5,a5,1
    80001ba2:	00d7979b          	slliw	a5,a5,0xd
    80001ba6:	40f907b3          	sub	a5,s2,a5
    80001baa:	e4bc                	sd	a5,72(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bac:	17848493          	addi	s1,s1,376
    80001bb0:	fd349be3          	bne	s1,s3,80001b86 <procinit+0x6e>
  }
}
    80001bb4:	70e2                	ld	ra,56(sp)
    80001bb6:	7442                	ld	s0,48(sp)
    80001bb8:	74a2                	ld	s1,40(sp)
    80001bba:	7902                	ld	s2,32(sp)
    80001bbc:	69e2                	ld	s3,24(sp)
    80001bbe:	6a42                	ld	s4,16(sp)
    80001bc0:	6aa2                	ld	s5,8(sp)
    80001bc2:	6b02                	ld	s6,0(sp)
    80001bc4:	6121                	addi	sp,sp,64
    80001bc6:	8082                	ret

0000000080001bc8 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001bc8:	1141                	addi	sp,sp,-16
    80001bca:	e422                	sd	s0,8(sp)
    80001bcc:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bce:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001bd0:	2501                	sext.w	a0,a0
    80001bd2:	6422                	ld	s0,8(sp)
    80001bd4:	0141                	addi	sp,sp,16
    80001bd6:	8082                	ret

0000000080001bd8 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80001bd8:	1141                	addi	sp,sp,-16
    80001bda:	e422                	sd	s0,8(sp)
    80001bdc:	0800                	addi	s0,sp,16
    80001bde:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001be0:	2781                	sext.w	a5,a5
    80001be2:	079e                	slli	a5,a5,0x7
  return c;
}
    80001be4:	0000f517          	auipc	a0,0xf
    80001be8:	6ec50513          	addi	a0,a0,1772 # 800112d0 <cpus>
    80001bec:	953e                	add	a0,a0,a5
    80001bee:	6422                	ld	s0,8(sp)
    80001bf0:	0141                	addi	sp,sp,16
    80001bf2:	8082                	ret

0000000080001bf4 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80001bf4:	1101                	addi	sp,sp,-32
    80001bf6:	ec06                	sd	ra,24(sp)
    80001bf8:	e822                	sd	s0,16(sp)
    80001bfa:	e426                	sd	s1,8(sp)
    80001bfc:	1000                	addi	s0,sp,32
  push_off();
    80001bfe:	fffff097          	auipc	ra,0xfffff
    80001c02:	f78080e7          	jalr	-136(ra) # 80000b76 <push_off>
    80001c06:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001c08:	2781                	sext.w	a5,a5
    80001c0a:	079e                	slli	a5,a5,0x7
    80001c0c:	0000f717          	auipc	a4,0xf
    80001c10:	69470713          	addi	a4,a4,1684 # 800112a0 <pid_lock>
    80001c14:	97ba                	add	a5,a5,a4
    80001c16:	7b84                	ld	s1,48(a5)
  pop_off();
    80001c18:	fffff097          	auipc	ra,0xfffff
    80001c1c:	ffe080e7          	jalr	-2(ra) # 80000c16 <pop_off>
  return p;
}
    80001c20:	8526                	mv	a0,s1
    80001c22:	60e2                	ld	ra,24(sp)
    80001c24:	6442                	ld	s0,16(sp)
    80001c26:	64a2                	ld	s1,8(sp)
    80001c28:	6105                	addi	sp,sp,32
    80001c2a:	8082                	ret

0000000080001c2c <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001c2c:	1141                	addi	sp,sp,-16
    80001c2e:	e406                	sd	ra,8(sp)
    80001c30:	e022                	sd	s0,0(sp)
    80001c32:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001c34:	00000097          	auipc	ra,0x0
    80001c38:	fc0080e7          	jalr	-64(ra) # 80001bf4 <myproc>
    80001c3c:	fffff097          	auipc	ra,0xfffff
    80001c40:	03a080e7          	jalr	58(ra) # 80000c76 <release>

  if (first) {
    80001c44:	00007797          	auipc	a5,0x7
    80001c48:	ccc7a783          	lw	a5,-820(a5) # 80008910 <first.1>
    80001c4c:	eb89                	bnez	a5,80001c5e <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001c4e:	00001097          	auipc	ra,0x1
    80001c52:	dbe080e7          	jalr	-578(ra) # 80002a0c <usertrapret>
}
    80001c56:	60a2                	ld	ra,8(sp)
    80001c58:	6402                	ld	s0,0(sp)
    80001c5a:	0141                	addi	sp,sp,16
    80001c5c:	8082                	ret
    first = 0;
    80001c5e:	00007797          	auipc	a5,0x7
    80001c62:	ca07a923          	sw	zero,-846(a5) # 80008910 <first.1>
    fsinit(ROOTDEV);
    80001c66:	4505                	li	a0,1
    80001c68:	00002097          	auipc	ra,0x2
    80001c6c:	b5c080e7          	jalr	-1188(ra) # 800037c4 <fsinit>
    80001c70:	bff9                	j	80001c4e <forkret+0x22>

0000000080001c72 <allocpid>:
allocpid() {
    80001c72:	1101                	addi	sp,sp,-32
    80001c74:	ec06                	sd	ra,24(sp)
    80001c76:	e822                	sd	s0,16(sp)
    80001c78:	e426                	sd	s1,8(sp)
    80001c7a:	e04a                	sd	s2,0(sp)
    80001c7c:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001c7e:	0000f917          	auipc	s2,0xf
    80001c82:	62290913          	addi	s2,s2,1570 # 800112a0 <pid_lock>
    80001c86:	854a                	mv	a0,s2
    80001c88:	fffff097          	auipc	ra,0xfffff
    80001c8c:	f3a080e7          	jalr	-198(ra) # 80000bc2 <acquire>
  pid = nextpid;
    80001c90:	00007797          	auipc	a5,0x7
    80001c94:	c8478793          	addi	a5,a5,-892 # 80008914 <nextpid>
    80001c98:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001c9a:	0014871b          	addiw	a4,s1,1
    80001c9e:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001ca0:	854a                	mv	a0,s2
    80001ca2:	fffff097          	auipc	ra,0xfffff
    80001ca6:	fd4080e7          	jalr	-44(ra) # 80000c76 <release>
}
    80001caa:	8526                	mv	a0,s1
    80001cac:	60e2                	ld	ra,24(sp)
    80001cae:	6442                	ld	s0,16(sp)
    80001cb0:	64a2                	ld	s1,8(sp)
    80001cb2:	6902                	ld	s2,0(sp)
    80001cb4:	6105                	addi	sp,sp,32
    80001cb6:	8082                	ret

0000000080001cb8 <proc_pagetable>:
{
    80001cb8:	1101                	addi	sp,sp,-32
    80001cba:	ec06                	sd	ra,24(sp)
    80001cbc:	e822                	sd	s0,16(sp)
    80001cbe:	e426                	sd	s1,8(sp)
    80001cc0:	e04a                	sd	s2,0(sp)
    80001cc2:	1000                	addi	s0,sp,32
    80001cc4:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001cc6:	fffff097          	auipc	ra,0xfffff
    80001cca:	636080e7          	jalr	1590(ra) # 800012fc <uvmcreate>
    80001cce:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001cd0:	c121                	beqz	a0,80001d10 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001cd2:	4729                	li	a4,10
    80001cd4:	00005697          	auipc	a3,0x5
    80001cd8:	32c68693          	addi	a3,a3,812 # 80007000 <_trampoline>
    80001cdc:	6605                	lui	a2,0x1
    80001cde:	040005b7          	lui	a1,0x4000
    80001ce2:	15fd                	addi	a1,a1,-1
    80001ce4:	05b2                	slli	a1,a1,0xc
    80001ce6:	fffff097          	auipc	ra,0xfffff
    80001cea:	3a8080e7          	jalr	936(ra) # 8000108e <mappages>
    80001cee:	02054863          	bltz	a0,80001d1e <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001cf2:	4719                	li	a4,6
    80001cf4:	06893683          	ld	a3,104(s2)
    80001cf8:	6605                	lui	a2,0x1
    80001cfa:	020005b7          	lui	a1,0x2000
    80001cfe:	15fd                	addi	a1,a1,-1
    80001d00:	05b6                	slli	a1,a1,0xd
    80001d02:	8526                	mv	a0,s1
    80001d04:	fffff097          	auipc	ra,0xfffff
    80001d08:	38a080e7          	jalr	906(ra) # 8000108e <mappages>
    80001d0c:	02054163          	bltz	a0,80001d2e <proc_pagetable+0x76>
}
    80001d10:	8526                	mv	a0,s1
    80001d12:	60e2                	ld	ra,24(sp)
    80001d14:	6442                	ld	s0,16(sp)
    80001d16:	64a2                	ld	s1,8(sp)
    80001d18:	6902                	ld	s2,0(sp)
    80001d1a:	6105                	addi	sp,sp,32
    80001d1c:	8082                	ret
    uvmfree(pagetable, 0);
    80001d1e:	4581                	li	a1,0
    80001d20:	8526                	mv	a0,s1
    80001d22:	00000097          	auipc	ra,0x0
    80001d26:	8ac080e7          	jalr	-1876(ra) # 800015ce <uvmfree>
    return 0;
    80001d2a:	4481                	li	s1,0
    80001d2c:	b7d5                	j	80001d10 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001d2e:	4681                	li	a3,0
    80001d30:	4605                	li	a2,1
    80001d32:	040005b7          	lui	a1,0x4000
    80001d36:	15fd                	addi	a1,a1,-1
    80001d38:	05b2                	slli	a1,a1,0xc
    80001d3a:	8526                	mv	a0,s1
    80001d3c:	fffff097          	auipc	ra,0xfffff
    80001d40:	4fc080e7          	jalr	1276(ra) # 80001238 <uvmunmap>
    uvmfree(pagetable, 0);
    80001d44:	4581                	li	a1,0
    80001d46:	8526                	mv	a0,s1
    80001d48:	00000097          	auipc	ra,0x0
    80001d4c:	886080e7          	jalr	-1914(ra) # 800015ce <uvmfree>
    return 0;
    80001d50:	4481                	li	s1,0
    80001d52:	bf7d                	j	80001d10 <proc_pagetable+0x58>

0000000080001d54 <proc_freepagetable>:
{
    80001d54:	1101                	addi	sp,sp,-32
    80001d56:	ec06                	sd	ra,24(sp)
    80001d58:	e822                	sd	s0,16(sp)
    80001d5a:	e426                	sd	s1,8(sp)
    80001d5c:	e04a                	sd	s2,0(sp)
    80001d5e:	1000                	addi	s0,sp,32
    80001d60:	84aa                	mv	s1,a0
    80001d62:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001d64:	4681                	li	a3,0
    80001d66:	4605                	li	a2,1
    80001d68:	040005b7          	lui	a1,0x4000
    80001d6c:	15fd                	addi	a1,a1,-1
    80001d6e:	05b2                	slli	a1,a1,0xc
    80001d70:	fffff097          	auipc	ra,0xfffff
    80001d74:	4c8080e7          	jalr	1224(ra) # 80001238 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001d78:	4681                	li	a3,0
    80001d7a:	4605                	li	a2,1
    80001d7c:	020005b7          	lui	a1,0x2000
    80001d80:	15fd                	addi	a1,a1,-1
    80001d82:	05b6                	slli	a1,a1,0xd
    80001d84:	8526                	mv	a0,s1
    80001d86:	fffff097          	auipc	ra,0xfffff
    80001d8a:	4b2080e7          	jalr	1202(ra) # 80001238 <uvmunmap>
  uvmfree(pagetable, sz);
    80001d8e:	85ca                	mv	a1,s2
    80001d90:	8526                	mv	a0,s1
    80001d92:	00000097          	auipc	ra,0x0
    80001d96:	83c080e7          	jalr	-1988(ra) # 800015ce <uvmfree>
}
    80001d9a:	60e2                	ld	ra,24(sp)
    80001d9c:	6442                	ld	s0,16(sp)
    80001d9e:	64a2                	ld	s1,8(sp)
    80001da0:	6902                	ld	s2,0(sp)
    80001da2:	6105                	addi	sp,sp,32
    80001da4:	8082                	ret

0000000080001da6 <freeproc>:
{
    80001da6:	1101                	addi	sp,sp,-32
    80001da8:	ec06                	sd	ra,24(sp)
    80001daa:	e822                	sd	s0,16(sp)
    80001dac:	e426                	sd	s1,8(sp)
    80001dae:	1000                	addi	s0,sp,32
    80001db0:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001db2:	7528                	ld	a0,104(a0)
    80001db4:	c509                	beqz	a0,80001dbe <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001db6:	fffff097          	auipc	ra,0xfffff
    80001dba:	c20080e7          	jalr	-992(ra) # 800009d6 <kfree>
  p->trapframe = 0;
    80001dbe:	0604b423          	sd	zero,104(s1)
  if(p->pagetable)
    80001dc2:	6ca8                	ld	a0,88(s1)
    80001dc4:	c511                	beqz	a0,80001dd0 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001dc6:	68ac                	ld	a1,80(s1)
    80001dc8:	00000097          	auipc	ra,0x0
    80001dcc:	f8c080e7          	jalr	-116(ra) # 80001d54 <proc_freepagetable>
  if (p->k_pagetable){
    80001dd0:	70bc                	ld	a5,96(s1)
    80001dd2:	c791                	beqz	a5,80001dde <freeproc+0x38>
  free_kmapping(p);
    80001dd4:	8526                	mv	a0,s1
    80001dd6:	00000097          	auipc	ra,0x0
    80001dda:	830080e7          	jalr	-2000(ra) # 80001606 <free_kmapping>
  p->pagetable = 0;
    80001dde:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    80001de2:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    80001de6:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001dea:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001dee:	16048423          	sb	zero,360(s1)
  p->chan = 0;
    80001df2:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001df6:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001dfa:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001dfe:	0004ac23          	sw	zero,24(s1)
}
    80001e02:	60e2                	ld	ra,24(sp)
    80001e04:	6442                	ld	s0,16(sp)
    80001e06:	64a2                	ld	s1,8(sp)
    80001e08:	6105                	addi	sp,sp,32
    80001e0a:	8082                	ret

0000000080001e0c <allocproc>:
{
    80001e0c:	1101                	addi	sp,sp,-32
    80001e0e:	ec06                	sd	ra,24(sp)
    80001e10:	e822                	sd	s0,16(sp)
    80001e12:	e426                	sd	s1,8(sp)
    80001e14:	e04a                	sd	s2,0(sp)
    80001e16:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e18:	00010497          	auipc	s1,0x10
    80001e1c:	8b848493          	addi	s1,s1,-1864 # 800116d0 <proc>
    80001e20:	00015917          	auipc	s2,0x15
    80001e24:	6b090913          	addi	s2,s2,1712 # 800174d0 <tickslock>
    acquire(&p->lock);
    80001e28:	8526                	mv	a0,s1
    80001e2a:	fffff097          	auipc	ra,0xfffff
    80001e2e:	d98080e7          	jalr	-616(ra) # 80000bc2 <acquire>
    if(p->state == UNUSED) {
    80001e32:	4c9c                	lw	a5,24(s1)
    80001e34:	cf81                	beqz	a5,80001e4c <allocproc+0x40>
      release(&p->lock);
    80001e36:	8526                	mv	a0,s1
    80001e38:	fffff097          	auipc	ra,0xfffff
    80001e3c:	e3e080e7          	jalr	-450(ra) # 80000c76 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e40:	17848493          	addi	s1,s1,376
    80001e44:	ff2492e3          	bne	s1,s2,80001e28 <allocproc+0x1c>
  return 0;
    80001e48:	4481                	li	s1,0
    80001e4a:	a075                	j	80001ef6 <allocproc+0xea>
  p->pid = allocpid();
    80001e4c:	00000097          	auipc	ra,0x0
    80001e50:	e26080e7          	jalr	-474(ra) # 80001c72 <allocpid>
    80001e54:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001e56:	4785                	li	a5,1
    80001e58:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001e5a:	fffff097          	auipc	ra,0xfffff
    80001e5e:	c78080e7          	jalr	-904(ra) # 80000ad2 <kalloc>
    80001e62:	892a                	mv	s2,a0
    80001e64:	f4a8                	sd	a0,104(s1)
    80001e66:	cd59                	beqz	a0,80001f04 <allocproc+0xf8>
  p->pagetable = proc_pagetable(p);
    80001e68:	8526                	mv	a0,s1
    80001e6a:	00000097          	auipc	ra,0x0
    80001e6e:	e4e080e7          	jalr	-434(ra) # 80001cb8 <proc_pagetable>
    80001e72:	892a                	mv	s2,a0
    80001e74:	eca8                	sd	a0,88(s1)
  if(p->pagetable == 0){
    80001e76:	c15d                	beqz	a0,80001f1c <allocproc+0x110>
  p->k_pagetable = kvmmake();
    80001e78:	fffff097          	auipc	ra,0xfffff
    80001e7c:	2d4080e7          	jalr	724(ra) # 8000114c <kvmmake>
    80001e80:	892a                	mv	s2,a0
    80001e82:	f0a8                	sd	a0,96(s1)
  if(p->k_pagetable == 0){
    80001e84:	c945                	beqz	a0,80001f34 <allocproc+0x128>
  char *pa = kalloc();
    80001e86:	fffff097          	auipc	ra,0xfffff
    80001e8a:	c4c080e7          	jalr	-948(ra) # 80000ad2 <kalloc>
    80001e8e:	862a                	mv	a2,a0
  if(pa == 0)
    80001e90:	cd55                	beqz	a0,80001f4c <allocproc+0x140>
  uint64 va = KSTACK((int) (p - proc));
    80001e92:	00010797          	auipc	a5,0x10
    80001e96:	83e78793          	addi	a5,a5,-1986 # 800116d0 <proc>
    80001e9a:	40f487b3          	sub	a5,s1,a5
    80001e9e:	878d                	srai	a5,a5,0x3
    80001ea0:	00006717          	auipc	a4,0x6
    80001ea4:	16073703          	ld	a4,352(a4) # 80008000 <etext>
    80001ea8:	02e787b3          	mul	a5,a5,a4
    80001eac:	2785                	addiw	a5,a5,1
    80001eae:	00d7979b          	slliw	a5,a5,0xd
    80001eb2:	04000937          	lui	s2,0x4000
    80001eb6:	197d                	addi	s2,s2,-1
    80001eb8:	0932                	slli	s2,s2,0xc
    80001eba:	40f90933          	sub	s2,s2,a5
  kvmmap(p->k_pagetable, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001ebe:	4719                	li	a4,6
    80001ec0:	6685                	lui	a3,0x1
    80001ec2:	85ca                	mv	a1,s2
    80001ec4:	70a8                	ld	a0,96(s1)
    80001ec6:	fffff097          	auipc	ra,0xfffff
    80001eca:	256080e7          	jalr	598(ra) # 8000111c <kvmmap>
  p->kstack = va;
    80001ece:	0524b423          	sd	s2,72(s1)
  memset(&p->context, 0, sizeof(p->context));
    80001ed2:	07000613          	li	a2,112
    80001ed6:	4581                	li	a1,0
    80001ed8:	07048513          	addi	a0,s1,112
    80001edc:	fffff097          	auipc	ra,0xfffff
    80001ee0:	de2080e7          	jalr	-542(ra) # 80000cbe <memset>
  p->context.ra = (uint64)forkret;
    80001ee4:	00000797          	auipc	a5,0x0
    80001ee8:	d4878793          	addi	a5,a5,-696 # 80001c2c <forkret>
    80001eec:	f8bc                	sd	a5,112(s1)
  p->context.sp = p->kstack +  PGSIZE;
    80001eee:	64bc                	ld	a5,72(s1)
    80001ef0:	6705                	lui	a4,0x1
    80001ef2:	97ba                	add	a5,a5,a4
    80001ef4:	fcbc                	sd	a5,120(s1)
}
    80001ef6:	8526                	mv	a0,s1
    80001ef8:	60e2                	ld	ra,24(sp)
    80001efa:	6442                	ld	s0,16(sp)
    80001efc:	64a2                	ld	s1,8(sp)
    80001efe:	6902                	ld	s2,0(sp)
    80001f00:	6105                	addi	sp,sp,32
    80001f02:	8082                	ret
    freeproc(p);
    80001f04:	8526                	mv	a0,s1
    80001f06:	00000097          	auipc	ra,0x0
    80001f0a:	ea0080e7          	jalr	-352(ra) # 80001da6 <freeproc>
    release(&p->lock);
    80001f0e:	8526                	mv	a0,s1
    80001f10:	fffff097          	auipc	ra,0xfffff
    80001f14:	d66080e7          	jalr	-666(ra) # 80000c76 <release>
    return 0;
    80001f18:	84ca                	mv	s1,s2
    80001f1a:	bff1                	j	80001ef6 <allocproc+0xea>
    freeproc(p);
    80001f1c:	8526                	mv	a0,s1
    80001f1e:	00000097          	auipc	ra,0x0
    80001f22:	e88080e7          	jalr	-376(ra) # 80001da6 <freeproc>
    release(&p->lock);
    80001f26:	8526                	mv	a0,s1
    80001f28:	fffff097          	auipc	ra,0xfffff
    80001f2c:	d4e080e7          	jalr	-690(ra) # 80000c76 <release>
    return 0;
    80001f30:	84ca                	mv	s1,s2
    80001f32:	b7d1                	j	80001ef6 <allocproc+0xea>
    freeproc(p);
    80001f34:	8526                	mv	a0,s1
    80001f36:	00000097          	auipc	ra,0x0
    80001f3a:	e70080e7          	jalr	-400(ra) # 80001da6 <freeproc>
    release(&p->lock);
    80001f3e:	8526                	mv	a0,s1
    80001f40:	fffff097          	auipc	ra,0xfffff
    80001f44:	d36080e7          	jalr	-714(ra) # 80000c76 <release>
    return 0;
    80001f48:	84ca                	mv	s1,s2
    80001f4a:	b775                	j	80001ef6 <allocproc+0xea>
    panic("kalloc");
    80001f4c:	00006517          	auipc	a0,0x6
    80001f50:	35450513          	addi	a0,a0,852 # 800082a0 <digits+0x260>
    80001f54:	ffffe097          	auipc	ra,0xffffe
    80001f58:	5d6080e7          	jalr	1494(ra) # 8000052a <panic>

0000000080001f5c <proc_freekpagetable>:
void proc_freekpagetable(struct proc *p){
    80001f5c:	1141                	addi	sp,sp,-16
    80001f5e:	e406                	sd	ra,8(sp)
    80001f60:	e022                	sd	s0,0(sp)
    80001f62:	0800                	addi	s0,sp,16
  free_kmapping(p);
    80001f64:	fffff097          	auipc	ra,0xfffff
    80001f68:	6a2080e7          	jalr	1698(ra) # 80001606 <free_kmapping>
}
    80001f6c:	60a2                	ld	ra,8(sp)
    80001f6e:	6402                	ld	s0,0(sp)
    80001f70:	0141                	addi	sp,sp,16
    80001f72:	8082                	ret

0000000080001f74 <userinit>:
{
    80001f74:	1101                	addi	sp,sp,-32
    80001f76:	ec06                	sd	ra,24(sp)
    80001f78:	e822                	sd	s0,16(sp)
    80001f7a:	e426                	sd	s1,8(sp)
    80001f7c:	e04a                	sd	s2,0(sp)
    80001f7e:	1000                	addi	s0,sp,32
  p = allocproc();
    80001f80:	00000097          	auipc	ra,0x0
    80001f84:	e8c080e7          	jalr	-372(ra) # 80001e0c <allocproc>
    80001f88:	84aa                	mv	s1,a0
  initproc = p;
    80001f8a:	00007797          	auipc	a5,0x7
    80001f8e:	08a7bf23          	sd	a0,158(a5) # 80009028 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001f92:	03400613          	li	a2,52
    80001f96:	00007597          	auipc	a1,0x7
    80001f9a:	98a58593          	addi	a1,a1,-1654 # 80008920 <initcode>
    80001f9e:	6d28                	ld	a0,88(a0)
    80001fa0:	fffff097          	auipc	ra,0xfffff
    80001fa4:	38a080e7          	jalr	906(ra) # 8000132a <uvminit>
  p->sz = PGSIZE;
    80001fa8:	6905                	lui	s2,0x1
    80001faa:	0524b823          	sd	s2,80(s1)
  uvmapping(p->pagetable,p->k_pagetable,0,p->sz);
    80001fae:	6685                	lui	a3,0x1
    80001fb0:	4601                	li	a2,0
    80001fb2:	70ac                	ld	a1,96(s1)
    80001fb4:	6ca8                	ld	a0,88(s1)
    80001fb6:	fffff097          	auipc	ra,0xfffff
    80001fba:	3e6080e7          	jalr	998(ra) # 8000139c <uvmapping>
  p->trapframe->epc = 0;      // user program counter
    80001fbe:	74bc                	ld	a5,104(s1)
    80001fc0:	0007bc23          	sd	zero,24(a5)
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001fc4:	74bc                	ld	a5,104(s1)
    80001fc6:	0327b823          	sd	s2,48(a5)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001fca:	4641                	li	a2,16
    80001fcc:	00006597          	auipc	a1,0x6
    80001fd0:	2fc58593          	addi	a1,a1,764 # 800082c8 <digits+0x288>
    80001fd4:	16848513          	addi	a0,s1,360
    80001fd8:	fffff097          	auipc	ra,0xfffff
    80001fdc:	e38080e7          	jalr	-456(ra) # 80000e10 <safestrcpy>
  p->cwd = namei("/");
    80001fe0:	00006517          	auipc	a0,0x6
    80001fe4:	2f850513          	addi	a0,a0,760 # 800082d8 <digits+0x298>
    80001fe8:	00002097          	auipc	ra,0x2
    80001fec:	20a080e7          	jalr	522(ra) # 800041f2 <namei>
    80001ff0:	16a4b023          	sd	a0,352(s1)
  p->state = RUNNABLE;
    80001ff4:	478d                	li	a5,3
    80001ff6:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001ff8:	8526                	mv	a0,s1
    80001ffa:	fffff097          	auipc	ra,0xfffff
    80001ffe:	c7c080e7          	jalr	-900(ra) # 80000c76 <release>
}
    80002002:	60e2                	ld	ra,24(sp)
    80002004:	6442                	ld	s0,16(sp)
    80002006:	64a2                	ld	s1,8(sp)
    80002008:	6902                	ld	s2,0(sp)
    8000200a:	6105                	addi	sp,sp,32
    8000200c:	8082                	ret

000000008000200e <growproc>:
{
    8000200e:	7139                	addi	sp,sp,-64
    80002010:	fc06                	sd	ra,56(sp)
    80002012:	f822                	sd	s0,48(sp)
    80002014:	f426                	sd	s1,40(sp)
    80002016:	f04a                	sd	s2,32(sp)
    80002018:	ec4e                	sd	s3,24(sp)
    8000201a:	e852                	sd	s4,16(sp)
    8000201c:	e456                	sd	s5,8(sp)
    8000201e:	0080                	addi	s0,sp,64
    80002020:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002022:	00000097          	auipc	ra,0x0
    80002026:	bd2080e7          	jalr	-1070(ra) # 80001bf4 <myproc>
    8000202a:	892a                	mv	s2,a0
  sz = p->sz;
    8000202c:	05053a03          	ld	s4,80(a0)
    80002030:	000a0a9b          	sext.w	s5,s4
  if(n > 0){
    80002034:	04904363          	bgtz	s1,8000207a <growproc+0x6c>
  sz = p->sz;
    80002038:	89d6                	mv	s3,s5
  } else if(n < 0){
    8000203a:	0604c263          	bltz	s1,8000209e <growproc+0x90>
  uvmapping(p->pagetable,p->k_pagetable,oldsz,oldsz+n);
    8000203e:	015486bb          	addw	a3,s1,s5
    80002042:	1682                	slli	a3,a3,0x20
    80002044:	9281                	srli	a3,a3,0x20
    80002046:	020a1613          	slli	a2,s4,0x20
    8000204a:	9201                	srli	a2,a2,0x20
    8000204c:	06093583          	ld	a1,96(s2) # 1060 <_entry-0x7fffefa0>
    80002050:	05893503          	ld	a0,88(s2)
    80002054:	fffff097          	auipc	ra,0xfffff
    80002058:	348080e7          	jalr	840(ra) # 8000139c <uvmapping>
  p->sz = sz;
    8000205c:	1982                	slli	s3,s3,0x20
    8000205e:	0209d993          	srli	s3,s3,0x20
    80002062:	05393823          	sd	s3,80(s2)
  return 0;
    80002066:	4501                	li	a0,0
}
    80002068:	70e2                	ld	ra,56(sp)
    8000206a:	7442                	ld	s0,48(sp)
    8000206c:	74a2                	ld	s1,40(sp)
    8000206e:	7902                	ld	s2,32(sp)
    80002070:	69e2                	ld	s3,24(sp)
    80002072:	6a42                	ld	s4,16(sp)
    80002074:	6aa2                	ld	s5,8(sp)
    80002076:	6121                	addi	sp,sp,64
    80002078:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000207a:	0154863b          	addw	a2,s1,s5
    8000207e:	1602                	slli	a2,a2,0x20
    80002080:	9201                	srli	a2,a2,0x20
    80002082:	020a1593          	slli	a1,s4,0x20
    80002086:	9181                	srli	a1,a1,0x20
    80002088:	6d28                	ld	a0,88(a0)
    8000208a:	fffff097          	auipc	ra,0xfffff
    8000208e:	400080e7          	jalr	1024(ra) # 8000148a <uvmalloc>
    80002092:	0005099b          	sext.w	s3,a0
    80002096:	fa0994e3          	bnez	s3,8000203e <growproc+0x30>
      return -1;
    8000209a:	557d                	li	a0,-1
    8000209c:	b7f1                	j	80002068 <growproc+0x5a>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000209e:	0154863b          	addw	a2,s1,s5
    800020a2:	1602                	slli	a2,a2,0x20
    800020a4:	9201                	srli	a2,a2,0x20
    800020a6:	020a1593          	slli	a1,s4,0x20
    800020aa:	9181                	srli	a1,a1,0x20
    800020ac:	6d28                	ld	a0,88(a0)
    800020ae:	fffff097          	auipc	ra,0xfffff
    800020b2:	394080e7          	jalr	916(ra) # 80001442 <uvmdealloc>
    800020b6:	0005099b          	sext.w	s3,a0
    800020ba:	b751                	j	8000203e <growproc+0x30>

00000000800020bc <trace>:
i32 trace(i32 traced){
    800020bc:	1101                	addi	sp,sp,-32
    800020be:	ec06                	sd	ra,24(sp)
    800020c0:	e822                	sd	s0,16(sp)
    800020c2:	e426                	sd	s1,8(sp)
    800020c4:	1000                	addi	s0,sp,32
    800020c6:	84aa                	mv	s1,a0
  struct proc *p  = myproc();
    800020c8:	00000097          	auipc	ra,0x0
    800020cc:	b2c080e7          	jalr	-1236(ra) # 80001bf4 <myproc>
  p->traced |= traced;
    800020d0:	413c                	lw	a5,64(a0)
    800020d2:	8cdd                	or	s1,s1,a5
    800020d4:	c124                	sw	s1,64(a0)
}
    800020d6:	4501                	li	a0,0
    800020d8:	60e2                	ld	ra,24(sp)
    800020da:	6442                	ld	s0,16(sp)
    800020dc:	64a2                	ld	s1,8(sp)
    800020de:	6105                	addi	sp,sp,32
    800020e0:	8082                	ret

00000000800020e2 <fork>:
{
    800020e2:	7139                	addi	sp,sp,-64
    800020e4:	fc06                	sd	ra,56(sp)
    800020e6:	f822                	sd	s0,48(sp)
    800020e8:	f426                	sd	s1,40(sp)
    800020ea:	f04a                	sd	s2,32(sp)
    800020ec:	ec4e                	sd	s3,24(sp)
    800020ee:	e852                	sd	s4,16(sp)
    800020f0:	e456                	sd	s5,8(sp)
    800020f2:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800020f4:	00000097          	auipc	ra,0x0
    800020f8:	b00080e7          	jalr	-1280(ra) # 80001bf4 <myproc>
    800020fc:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800020fe:	00000097          	auipc	ra,0x0
    80002102:	d0e080e7          	jalr	-754(ra) # 80001e0c <allocproc>
    80002106:	14050c63          	beqz	a0,8000225e <fork+0x17c>
    8000210a:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000210c:	050ab603          	ld	a2,80(s5)
    80002110:	6d2c                	ld	a1,88(a0)
    80002112:	058ab503          	ld	a0,88(s5)
    80002116:	fffff097          	auipc	ra,0xfffff
    8000211a:	5ca080e7          	jalr	1482(ra) # 800016e0 <uvmcopy>
    8000211e:	08054063          	bltz	a0,8000219e <fork+0xbc>
  uvmapping(np->pagetable,np->k_pagetable,0,p->sz);
    80002122:	050ab683          	ld	a3,80(s5)
    80002126:	4601                	li	a2,0
    80002128:	0609b583          	ld	a1,96(s3)
    8000212c:	0589b503          	ld	a0,88(s3)
    80002130:	fffff097          	auipc	ra,0xfffff
    80002134:	26c080e7          	jalr	620(ra) # 8000139c <uvmapping>
  if ((pte = walk(np->k_pagetable,0,0) )== 0){
    80002138:	4601                	li	a2,0
    8000213a:	4581                	li	a1,0
    8000213c:	0609b503          	ld	a0,96(s3)
    80002140:	fffff097          	auipc	ra,0xfffff
    80002144:	e66080e7          	jalr	-410(ra) # 80000fa6 <walk>
    80002148:	c53d                	beqz	a0,800021b6 <fork+0xd4>
  np->sz = p->sz;
    8000214a:	050ab783          	ld	a5,80(s5)
    8000214e:	04f9b823          	sd	a5,80(s3)
  np->traced = p->traced;
    80002152:	040aa783          	lw	a5,64(s5)
    80002156:	04f9a023          	sw	a5,64(s3)
  *(np->trapframe) = *(p->trapframe);
    8000215a:	068ab683          	ld	a3,104(s5)
    8000215e:	87b6                	mv	a5,a3
    80002160:	0689b703          	ld	a4,104(s3)
    80002164:	12068693          	addi	a3,a3,288 # 1120 <_entry-0x7fffeee0>
    80002168:	0007b803          	ld	a6,0(a5)
    8000216c:	6788                	ld	a0,8(a5)
    8000216e:	6b8c                	ld	a1,16(a5)
    80002170:	6f90                	ld	a2,24(a5)
    80002172:	01073023          	sd	a6,0(a4) # 1000 <_entry-0x7ffff000>
    80002176:	e708                	sd	a0,8(a4)
    80002178:	eb0c                	sd	a1,16(a4)
    8000217a:	ef10                	sd	a2,24(a4)
    8000217c:	02078793          	addi	a5,a5,32
    80002180:	02070713          	addi	a4,a4,32
    80002184:	fed792e3          	bne	a5,a3,80002168 <fork+0x86>
  np->trapframe->a0 = 0;
    80002188:	0689b783          	ld	a5,104(s3)
    8000218c:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80002190:	0e0a8493          	addi	s1,s5,224
    80002194:	0e098913          	addi	s2,s3,224
    80002198:	160a8a13          	addi	s4,s5,352
    8000219c:	a83d                	j	800021da <fork+0xf8>
    freeproc(np);
    8000219e:	854e                	mv	a0,s3
    800021a0:	00000097          	auipc	ra,0x0
    800021a4:	c06080e7          	jalr	-1018(ra) # 80001da6 <freeproc>
    release(&np->lock);
    800021a8:	854e                	mv	a0,s3
    800021aa:	fffff097          	auipc	ra,0xfffff
    800021ae:	acc080e7          	jalr	-1332(ra) # 80000c76 <release>
    return -1;
    800021b2:	597d                	li	s2,-1
    800021b4:	a859                	j	8000224a <fork+0x168>
    panic("not valid k table");
    800021b6:	00006517          	auipc	a0,0x6
    800021ba:	12a50513          	addi	a0,a0,298 # 800082e0 <digits+0x2a0>
    800021be:	ffffe097          	auipc	ra,0xffffe
    800021c2:	36c080e7          	jalr	876(ra) # 8000052a <panic>
      np->ofile[i] = filedup(p->ofile[i]);
    800021c6:	00002097          	auipc	ra,0x2
    800021ca:	6c2080e7          	jalr	1730(ra) # 80004888 <filedup>
    800021ce:	00a93023          	sd	a0,0(s2)
  for(i = 0; i < NOFILE; i++)
    800021d2:	04a1                	addi	s1,s1,8
    800021d4:	0921                	addi	s2,s2,8
    800021d6:	01448563          	beq	s1,s4,800021e0 <fork+0xfe>
    if(p->ofile[i])
    800021da:	6088                	ld	a0,0(s1)
    800021dc:	f56d                	bnez	a0,800021c6 <fork+0xe4>
    800021de:	bfd5                	j	800021d2 <fork+0xf0>
  np->cwd = idup(p->cwd);
    800021e0:	160ab503          	ld	a0,352(s5)
    800021e4:	00002097          	auipc	ra,0x2
    800021e8:	81a080e7          	jalr	-2022(ra) # 800039fe <idup>
    800021ec:	16a9b023          	sd	a0,352(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800021f0:	4641                	li	a2,16
    800021f2:	168a8593          	addi	a1,s5,360
    800021f6:	16898513          	addi	a0,s3,360
    800021fa:	fffff097          	auipc	ra,0xfffff
    800021fe:	c16080e7          	jalr	-1002(ra) # 80000e10 <safestrcpy>
  pid = np->pid;
    80002202:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    80002206:	854e                	mv	a0,s3
    80002208:	fffff097          	auipc	ra,0xfffff
    8000220c:	a6e080e7          	jalr	-1426(ra) # 80000c76 <release>
  acquire(&wait_lock);
    80002210:	0000f497          	auipc	s1,0xf
    80002214:	0a848493          	addi	s1,s1,168 # 800112b8 <wait_lock>
    80002218:	8526                	mv	a0,s1
    8000221a:	fffff097          	auipc	ra,0xfffff
    8000221e:	9a8080e7          	jalr	-1624(ra) # 80000bc2 <acquire>
  np->parent = p;
    80002222:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80002226:	8526                	mv	a0,s1
    80002228:	fffff097          	auipc	ra,0xfffff
    8000222c:	a4e080e7          	jalr	-1458(ra) # 80000c76 <release>
  acquire(&np->lock);
    80002230:	854e                	mv	a0,s3
    80002232:	fffff097          	auipc	ra,0xfffff
    80002236:	990080e7          	jalr	-1648(ra) # 80000bc2 <acquire>
  np->state = RUNNABLE;
    8000223a:	478d                	li	a5,3
    8000223c:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80002240:	854e                	mv	a0,s3
    80002242:	fffff097          	auipc	ra,0xfffff
    80002246:	a34080e7          	jalr	-1484(ra) # 80000c76 <release>
}
    8000224a:	854a                	mv	a0,s2
    8000224c:	70e2                	ld	ra,56(sp)
    8000224e:	7442                	ld	s0,48(sp)
    80002250:	74a2                	ld	s1,40(sp)
    80002252:	7902                	ld	s2,32(sp)
    80002254:	69e2                	ld	s3,24(sp)
    80002256:	6a42                	ld	s4,16(sp)
    80002258:	6aa2                	ld	s5,8(sp)
    8000225a:	6121                	addi	sp,sp,64
    8000225c:	8082                	ret
    return -1;
    8000225e:	597d                	li	s2,-1
    80002260:	b7ed                	j	8000224a <fork+0x168>

0000000080002262 <scheduler>:
{
    80002262:	715d                	addi	sp,sp,-80
    80002264:	e486                	sd	ra,72(sp)
    80002266:	e0a2                	sd	s0,64(sp)
    80002268:	fc26                	sd	s1,56(sp)
    8000226a:	f84a                	sd	s2,48(sp)
    8000226c:	f44e                	sd	s3,40(sp)
    8000226e:	f052                	sd	s4,32(sp)
    80002270:	ec56                	sd	s5,24(sp)
    80002272:	e85a                	sd	s6,16(sp)
    80002274:	e45e                	sd	s7,8(sp)
    80002276:	e062                	sd	s8,0(sp)
    80002278:	0880                	addi	s0,sp,80
    8000227a:	8792                	mv	a5,tp
  int id = r_tp();
    8000227c:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000227e:	00779c13          	slli	s8,a5,0x7
    80002282:	0000f717          	auipc	a4,0xf
    80002286:	01e70713          	addi	a4,a4,30 # 800112a0 <pid_lock>
    8000228a:	9762                	add	a4,a4,s8
    8000228c:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80002290:	0000f717          	auipc	a4,0xf
    80002294:	04870713          	addi	a4,a4,72 # 800112d8 <cpus+0x8>
    80002298:	9c3a                	add	s8,s8,a4
        w_satp(MAKE_SATP(kernel_pagetable));
    8000229a:	00007b17          	auipc	s6,0x7
    8000229e:	d86b0b13          	addi	s6,s6,-634 # 80009020 <kernel_pagetable>
    800022a2:	5afd                	li	s5,-1
    800022a4:	1afe                	slli	s5,s5,0x3f
        c->proc = p;
    800022a6:	079e                	slli	a5,a5,0x7
    800022a8:	0000fb97          	auipc	s7,0xf
    800022ac:	ff8b8b93          	addi	s7,s7,-8 # 800112a0 <pid_lock>
    800022b0:	9bbe                	add	s7,s7,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800022b2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800022b6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800022ba:	10079073          	csrw	sstatus,a5
    int found = 0;
    800022be:	4a01                	li	s4,0
    for(p = proc; p < &proc[NPROC]; p++) {
    800022c0:	0000f497          	auipc	s1,0xf
    800022c4:	41048493          	addi	s1,s1,1040 # 800116d0 <proc>
      if(p->state == RUNNABLE) {
    800022c8:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    800022ca:	00015917          	auipc	s2,0x15
    800022ce:	20690913          	addi	s2,s2,518 # 800174d0 <tickslock>
    800022d2:	a085                	j	80002332 <scheduler+0xd0>
        p->state = RUNNING;
    800022d4:	4791                	li	a5,4
    800022d6:	cc9c                	sw	a5,24(s1)
        c->proc = p;
    800022d8:	029bb823          	sd	s1,48(s7)
        w_satp(MAKE_SATP(p->k_pagetable));
    800022dc:	70bc                	ld	a5,96(s1)
    800022de:	83b1                	srli	a5,a5,0xc
    800022e0:	0157e7b3          	or	a5,a5,s5
  asm volatile("csrw satp, %0" : : "r" (x));
    800022e4:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800022e8:	12000073          	sfence.vma
        swtch(&c->context, &p->context);
    800022ec:	07048593          	addi	a1,s1,112
    800022f0:	8562                	mv	a0,s8
    800022f2:	00000097          	auipc	ra,0x0
    800022f6:	670080e7          	jalr	1648(ra) # 80002962 <swtch>
        c->proc = 0;
    800022fa:	020bb823          	sd	zero,48(s7)
      release(&p->lock);
    800022fe:	8526                	mv	a0,s1
    80002300:	fffff097          	auipc	ra,0xfffff
    80002304:	976080e7          	jalr	-1674(ra) # 80000c76 <release>
        found = 1;
    80002308:	4a05                	li	s4,1
    8000230a:	a005                	j	8000232a <scheduler+0xc8>
        w_satp(MAKE_SATP(kernel_pagetable));
    8000230c:	000b3783          	ld	a5,0(s6)
    80002310:	83b1                	srli	a5,a5,0xc
    80002312:	0157e7b3          	or	a5,a5,s5
  asm volatile("csrw satp, %0" : : "r" (x));
    80002316:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000231a:	12000073          	sfence.vma
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000231e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002322:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002326:	10079073          	csrw	sstatus,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000232a:	17848493          	addi	s1,s1,376
    8000232e:	f92482e3          	beq	s1,s2,800022b2 <scheduler+0x50>
      acquire(&p->lock);
    80002332:	8526                	mv	a0,s1
    80002334:	fffff097          	auipc	ra,0xfffff
    80002338:	88e080e7          	jalr	-1906(ra) # 80000bc2 <acquire>
      if(p->state == RUNNABLE) {
    8000233c:	4c9c                	lw	a5,24(s1)
    8000233e:	f9378be3          	beq	a5,s3,800022d4 <scheduler+0x72>
      release(&p->lock);
    80002342:	8526                	mv	a0,s1
    80002344:	fffff097          	auipc	ra,0xfffff
    80002348:	932080e7          	jalr	-1742(ra) # 80000c76 <release>
      if (!found){
    8000234c:	fc0a00e3          	beqz	s4,8000230c <scheduler+0xaa>
    80002350:	bfe9                	j	8000232a <scheduler+0xc8>

0000000080002352 <sched>:
{
    80002352:	7179                	addi	sp,sp,-48
    80002354:	f406                	sd	ra,40(sp)
    80002356:	f022                	sd	s0,32(sp)
    80002358:	ec26                	sd	s1,24(sp)
    8000235a:	e84a                	sd	s2,16(sp)
    8000235c:	e44e                	sd	s3,8(sp)
    8000235e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002360:	00000097          	auipc	ra,0x0
    80002364:	894080e7          	jalr	-1900(ra) # 80001bf4 <myproc>
    80002368:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000236a:	ffffe097          	auipc	ra,0xffffe
    8000236e:	7de080e7          	jalr	2014(ra) # 80000b48 <holding>
    80002372:	c93d                	beqz	a0,800023e8 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002374:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80002376:	2781                	sext.w	a5,a5
    80002378:	079e                	slli	a5,a5,0x7
    8000237a:	0000f717          	auipc	a4,0xf
    8000237e:	f2670713          	addi	a4,a4,-218 # 800112a0 <pid_lock>
    80002382:	97ba                	add	a5,a5,a4
    80002384:	0a87a703          	lw	a4,168(a5)
    80002388:	4785                	li	a5,1
    8000238a:	06f71763          	bne	a4,a5,800023f8 <sched+0xa6>
  if(p->state == RUNNING)
    8000238e:	4c98                	lw	a4,24(s1)
    80002390:	4791                	li	a5,4
    80002392:	06f70b63          	beq	a4,a5,80002408 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002396:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000239a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000239c:	efb5                	bnez	a5,80002418 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000239e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800023a0:	0000f917          	auipc	s2,0xf
    800023a4:	f0090913          	addi	s2,s2,-256 # 800112a0 <pid_lock>
    800023a8:	2781                	sext.w	a5,a5
    800023aa:	079e                	slli	a5,a5,0x7
    800023ac:	97ca                	add	a5,a5,s2
    800023ae:	0ac7a983          	lw	s3,172(a5)
    800023b2:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800023b4:	2781                	sext.w	a5,a5
    800023b6:	079e                	slli	a5,a5,0x7
    800023b8:	0000f597          	auipc	a1,0xf
    800023bc:	f2058593          	addi	a1,a1,-224 # 800112d8 <cpus+0x8>
    800023c0:	95be                	add	a1,a1,a5
    800023c2:	07048513          	addi	a0,s1,112
    800023c6:	00000097          	auipc	ra,0x0
    800023ca:	59c080e7          	jalr	1436(ra) # 80002962 <swtch>
    800023ce:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800023d0:	2781                	sext.w	a5,a5
    800023d2:	079e                	slli	a5,a5,0x7
    800023d4:	97ca                	add	a5,a5,s2
    800023d6:	0b37a623          	sw	s3,172(a5)
}
    800023da:	70a2                	ld	ra,40(sp)
    800023dc:	7402                	ld	s0,32(sp)
    800023de:	64e2                	ld	s1,24(sp)
    800023e0:	6942                	ld	s2,16(sp)
    800023e2:	69a2                	ld	s3,8(sp)
    800023e4:	6145                	addi	sp,sp,48
    800023e6:	8082                	ret
    panic("sched p->lock");
    800023e8:	00006517          	auipc	a0,0x6
    800023ec:	f1050513          	addi	a0,a0,-240 # 800082f8 <digits+0x2b8>
    800023f0:	ffffe097          	auipc	ra,0xffffe
    800023f4:	13a080e7          	jalr	314(ra) # 8000052a <panic>
    panic("sched locks");
    800023f8:	00006517          	auipc	a0,0x6
    800023fc:	f1050513          	addi	a0,a0,-240 # 80008308 <digits+0x2c8>
    80002400:	ffffe097          	auipc	ra,0xffffe
    80002404:	12a080e7          	jalr	298(ra) # 8000052a <panic>
    panic("sched running");
    80002408:	00006517          	auipc	a0,0x6
    8000240c:	f1050513          	addi	a0,a0,-240 # 80008318 <digits+0x2d8>
    80002410:	ffffe097          	auipc	ra,0xffffe
    80002414:	11a080e7          	jalr	282(ra) # 8000052a <panic>
    panic("sched interruptible");
    80002418:	00006517          	auipc	a0,0x6
    8000241c:	f1050513          	addi	a0,a0,-240 # 80008328 <digits+0x2e8>
    80002420:	ffffe097          	auipc	ra,0xffffe
    80002424:	10a080e7          	jalr	266(ra) # 8000052a <panic>

0000000080002428 <yield>:
{
    80002428:	1101                	addi	sp,sp,-32
    8000242a:	ec06                	sd	ra,24(sp)
    8000242c:	e822                	sd	s0,16(sp)
    8000242e:	e426                	sd	s1,8(sp)
    80002430:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002432:	fffff097          	auipc	ra,0xfffff
    80002436:	7c2080e7          	jalr	1986(ra) # 80001bf4 <myproc>
    8000243a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000243c:	ffffe097          	auipc	ra,0xffffe
    80002440:	786080e7          	jalr	1926(ra) # 80000bc2 <acquire>
  p->state = RUNNABLE;
    80002444:	478d                	li	a5,3
    80002446:	cc9c                	sw	a5,24(s1)
  sched();
    80002448:	00000097          	auipc	ra,0x0
    8000244c:	f0a080e7          	jalr	-246(ra) # 80002352 <sched>
  release(&p->lock);
    80002450:	8526                	mv	a0,s1
    80002452:	fffff097          	auipc	ra,0xfffff
    80002456:	824080e7          	jalr	-2012(ra) # 80000c76 <release>
}
    8000245a:	60e2                	ld	ra,24(sp)
    8000245c:	6442                	ld	s0,16(sp)
    8000245e:	64a2                	ld	s1,8(sp)
    80002460:	6105                	addi	sp,sp,32
    80002462:	8082                	ret

0000000080002464 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80002464:	7179                	addi	sp,sp,-48
    80002466:	f406                	sd	ra,40(sp)
    80002468:	f022                	sd	s0,32(sp)
    8000246a:	ec26                	sd	s1,24(sp)
    8000246c:	e84a                	sd	s2,16(sp)
    8000246e:	e44e                	sd	s3,8(sp)
    80002470:	1800                	addi	s0,sp,48
    80002472:	89aa                	mv	s3,a0
    80002474:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002476:	fffff097          	auipc	ra,0xfffff
    8000247a:	77e080e7          	jalr	1918(ra) # 80001bf4 <myproc>
    8000247e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80002480:	ffffe097          	auipc	ra,0xffffe
    80002484:	742080e7          	jalr	1858(ra) # 80000bc2 <acquire>
  release(lk);
    80002488:	854a                	mv	a0,s2
    8000248a:	ffffe097          	auipc	ra,0xffffe
    8000248e:	7ec080e7          	jalr	2028(ra) # 80000c76 <release>

  // Go to sleep.
  p->chan = chan;
    80002492:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002496:	4789                	li	a5,2
    80002498:	cc9c                	sw	a5,24(s1)

  sched();
    8000249a:	00000097          	auipc	ra,0x0
    8000249e:	eb8080e7          	jalr	-328(ra) # 80002352 <sched>

  // Tidy up.
  p->chan = 0;
    800024a2:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800024a6:	8526                	mv	a0,s1
    800024a8:	ffffe097          	auipc	ra,0xffffe
    800024ac:	7ce080e7          	jalr	1998(ra) # 80000c76 <release>
  acquire(lk);
    800024b0:	854a                	mv	a0,s2
    800024b2:	ffffe097          	auipc	ra,0xffffe
    800024b6:	710080e7          	jalr	1808(ra) # 80000bc2 <acquire>
}
    800024ba:	70a2                	ld	ra,40(sp)
    800024bc:	7402                	ld	s0,32(sp)
    800024be:	64e2                	ld	s1,24(sp)
    800024c0:	6942                	ld	s2,16(sp)
    800024c2:	69a2                	ld	s3,8(sp)
    800024c4:	6145                	addi	sp,sp,48
    800024c6:	8082                	ret

00000000800024c8 <wait>:
{
    800024c8:	715d                	addi	sp,sp,-80
    800024ca:	e486                	sd	ra,72(sp)
    800024cc:	e0a2                	sd	s0,64(sp)
    800024ce:	fc26                	sd	s1,56(sp)
    800024d0:	f84a                	sd	s2,48(sp)
    800024d2:	f44e                	sd	s3,40(sp)
    800024d4:	f052                	sd	s4,32(sp)
    800024d6:	ec56                	sd	s5,24(sp)
    800024d8:	e85a                	sd	s6,16(sp)
    800024da:	e45e                	sd	s7,8(sp)
    800024dc:	e062                	sd	s8,0(sp)
    800024de:	0880                	addi	s0,sp,80
    800024e0:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800024e2:	fffff097          	auipc	ra,0xfffff
    800024e6:	712080e7          	jalr	1810(ra) # 80001bf4 <myproc>
    800024ea:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800024ec:	0000f517          	auipc	a0,0xf
    800024f0:	dcc50513          	addi	a0,a0,-564 # 800112b8 <wait_lock>
    800024f4:	ffffe097          	auipc	ra,0xffffe
    800024f8:	6ce080e7          	jalr	1742(ra) # 80000bc2 <acquire>
    havekids = 0;
    800024fc:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800024fe:	4a15                	li	s4,5
        havekids = 1;
    80002500:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    80002502:	00015997          	auipc	s3,0x15
    80002506:	fce98993          	addi	s3,s3,-50 # 800174d0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000250a:	0000fc17          	auipc	s8,0xf
    8000250e:	daec0c13          	addi	s8,s8,-594 # 800112b8 <wait_lock>
    havekids = 0;
    80002512:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80002514:	0000f497          	auipc	s1,0xf
    80002518:	1bc48493          	addi	s1,s1,444 # 800116d0 <proc>
    8000251c:	a0bd                	j	8000258a <wait+0xc2>
          pid = np->pid;
    8000251e:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002522:	000b0e63          	beqz	s6,8000253e <wait+0x76>
    80002526:	4691                	li	a3,4
    80002528:	02c48613          	addi	a2,s1,44
    8000252c:	85da                	mv	a1,s6
    8000252e:	05893503          	ld	a0,88(s2)
    80002532:	fffff097          	auipc	ra,0xfffff
    80002536:	2b2080e7          	jalr	690(ra) # 800017e4 <copyout>
    8000253a:	02054563          	bltz	a0,80002564 <wait+0x9c>
          freeproc(np);
    8000253e:	8526                	mv	a0,s1
    80002540:	00000097          	auipc	ra,0x0
    80002544:	866080e7          	jalr	-1946(ra) # 80001da6 <freeproc>
          release(&np->lock);
    80002548:	8526                	mv	a0,s1
    8000254a:	ffffe097          	auipc	ra,0xffffe
    8000254e:	72c080e7          	jalr	1836(ra) # 80000c76 <release>
          release(&wait_lock);
    80002552:	0000f517          	auipc	a0,0xf
    80002556:	d6650513          	addi	a0,a0,-666 # 800112b8 <wait_lock>
    8000255a:	ffffe097          	auipc	ra,0xffffe
    8000255e:	71c080e7          	jalr	1820(ra) # 80000c76 <release>
          return pid;
    80002562:	a09d                	j	800025c8 <wait+0x100>
            release(&np->lock);
    80002564:	8526                	mv	a0,s1
    80002566:	ffffe097          	auipc	ra,0xffffe
    8000256a:	710080e7          	jalr	1808(ra) # 80000c76 <release>
            release(&wait_lock);
    8000256e:	0000f517          	auipc	a0,0xf
    80002572:	d4a50513          	addi	a0,a0,-694 # 800112b8 <wait_lock>
    80002576:	ffffe097          	auipc	ra,0xffffe
    8000257a:	700080e7          	jalr	1792(ra) # 80000c76 <release>
            return -1;
    8000257e:	59fd                	li	s3,-1
    80002580:	a0a1                	j	800025c8 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80002582:	17848493          	addi	s1,s1,376
    80002586:	03348463          	beq	s1,s3,800025ae <wait+0xe6>
      if(np->parent == p){
    8000258a:	7c9c                	ld	a5,56(s1)
    8000258c:	ff279be3          	bne	a5,s2,80002582 <wait+0xba>
        acquire(&np->lock);
    80002590:	8526                	mv	a0,s1
    80002592:	ffffe097          	auipc	ra,0xffffe
    80002596:	630080e7          	jalr	1584(ra) # 80000bc2 <acquire>
        if(np->state == ZOMBIE){
    8000259a:	4c9c                	lw	a5,24(s1)
    8000259c:	f94781e3          	beq	a5,s4,8000251e <wait+0x56>
        release(&np->lock);
    800025a0:	8526                	mv	a0,s1
    800025a2:	ffffe097          	auipc	ra,0xffffe
    800025a6:	6d4080e7          	jalr	1748(ra) # 80000c76 <release>
        havekids = 1;
    800025aa:	8756                	mv	a4,s5
    800025ac:	bfd9                	j	80002582 <wait+0xba>
    if(!havekids || p->killed){
    800025ae:	c701                	beqz	a4,800025b6 <wait+0xee>
    800025b0:	02892783          	lw	a5,40(s2)
    800025b4:	c79d                	beqz	a5,800025e2 <wait+0x11a>
      release(&wait_lock);
    800025b6:	0000f517          	auipc	a0,0xf
    800025ba:	d0250513          	addi	a0,a0,-766 # 800112b8 <wait_lock>
    800025be:	ffffe097          	auipc	ra,0xffffe
    800025c2:	6b8080e7          	jalr	1720(ra) # 80000c76 <release>
      return -1;
    800025c6:	59fd                	li	s3,-1
}
    800025c8:	854e                	mv	a0,s3
    800025ca:	60a6                	ld	ra,72(sp)
    800025cc:	6406                	ld	s0,64(sp)
    800025ce:	74e2                	ld	s1,56(sp)
    800025d0:	7942                	ld	s2,48(sp)
    800025d2:	79a2                	ld	s3,40(sp)
    800025d4:	7a02                	ld	s4,32(sp)
    800025d6:	6ae2                	ld	s5,24(sp)
    800025d8:	6b42                	ld	s6,16(sp)
    800025da:	6ba2                	ld	s7,8(sp)
    800025dc:	6c02                	ld	s8,0(sp)
    800025de:	6161                	addi	sp,sp,80
    800025e0:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800025e2:	85e2                	mv	a1,s8
    800025e4:	854a                	mv	a0,s2
    800025e6:	00000097          	auipc	ra,0x0
    800025ea:	e7e080e7          	jalr	-386(ra) # 80002464 <sleep>
    havekids = 0;
    800025ee:	b715                	j	80002512 <wait+0x4a>

00000000800025f0 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800025f0:	7139                	addi	sp,sp,-64
    800025f2:	fc06                	sd	ra,56(sp)
    800025f4:	f822                	sd	s0,48(sp)
    800025f6:	f426                	sd	s1,40(sp)
    800025f8:	f04a                	sd	s2,32(sp)
    800025fa:	ec4e                	sd	s3,24(sp)
    800025fc:	e852                	sd	s4,16(sp)
    800025fe:	e456                	sd	s5,8(sp)
    80002600:	0080                	addi	s0,sp,64
    80002602:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80002604:	0000f497          	auipc	s1,0xf
    80002608:	0cc48493          	addi	s1,s1,204 # 800116d0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000260c:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000260e:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80002610:	00015917          	auipc	s2,0x15
    80002614:	ec090913          	addi	s2,s2,-320 # 800174d0 <tickslock>
    80002618:	a811                	j	8000262c <wakeup+0x3c>
      }
      release(&p->lock);
    8000261a:	8526                	mv	a0,s1
    8000261c:	ffffe097          	auipc	ra,0xffffe
    80002620:	65a080e7          	jalr	1626(ra) # 80000c76 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002624:	17848493          	addi	s1,s1,376
    80002628:	03248663          	beq	s1,s2,80002654 <wakeup+0x64>
    if(p != myproc()){
    8000262c:	fffff097          	auipc	ra,0xfffff
    80002630:	5c8080e7          	jalr	1480(ra) # 80001bf4 <myproc>
    80002634:	fea488e3          	beq	s1,a0,80002624 <wakeup+0x34>
      acquire(&p->lock);
    80002638:	8526                	mv	a0,s1
    8000263a:	ffffe097          	auipc	ra,0xffffe
    8000263e:	588080e7          	jalr	1416(ra) # 80000bc2 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80002642:	4c9c                	lw	a5,24(s1)
    80002644:	fd379be3          	bne	a5,s3,8000261a <wakeup+0x2a>
    80002648:	709c                	ld	a5,32(s1)
    8000264a:	fd4798e3          	bne	a5,s4,8000261a <wakeup+0x2a>
        p->state = RUNNABLE;
    8000264e:	0154ac23          	sw	s5,24(s1)
    80002652:	b7e1                	j	8000261a <wakeup+0x2a>
    }
  }
}
    80002654:	70e2                	ld	ra,56(sp)
    80002656:	7442                	ld	s0,48(sp)
    80002658:	74a2                	ld	s1,40(sp)
    8000265a:	7902                	ld	s2,32(sp)
    8000265c:	69e2                	ld	s3,24(sp)
    8000265e:	6a42                	ld	s4,16(sp)
    80002660:	6aa2                	ld	s5,8(sp)
    80002662:	6121                	addi	sp,sp,64
    80002664:	8082                	ret

0000000080002666 <reparent>:
{
    80002666:	7179                	addi	sp,sp,-48
    80002668:	f406                	sd	ra,40(sp)
    8000266a:	f022                	sd	s0,32(sp)
    8000266c:	ec26                	sd	s1,24(sp)
    8000266e:	e84a                	sd	s2,16(sp)
    80002670:	e44e                	sd	s3,8(sp)
    80002672:	e052                	sd	s4,0(sp)
    80002674:	1800                	addi	s0,sp,48
    80002676:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002678:	0000f497          	auipc	s1,0xf
    8000267c:	05848493          	addi	s1,s1,88 # 800116d0 <proc>
      pp->parent = initproc;
    80002680:	00007a17          	auipc	s4,0x7
    80002684:	9a8a0a13          	addi	s4,s4,-1624 # 80009028 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002688:	00015997          	auipc	s3,0x15
    8000268c:	e4898993          	addi	s3,s3,-440 # 800174d0 <tickslock>
    80002690:	a029                	j	8000269a <reparent+0x34>
    80002692:	17848493          	addi	s1,s1,376
    80002696:	01348d63          	beq	s1,s3,800026b0 <reparent+0x4a>
    if(pp->parent == p){
    8000269a:	7c9c                	ld	a5,56(s1)
    8000269c:	ff279be3          	bne	a5,s2,80002692 <reparent+0x2c>
      pp->parent = initproc;
    800026a0:	000a3503          	ld	a0,0(s4)
    800026a4:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800026a6:	00000097          	auipc	ra,0x0
    800026aa:	f4a080e7          	jalr	-182(ra) # 800025f0 <wakeup>
    800026ae:	b7d5                	j	80002692 <reparent+0x2c>
}
    800026b0:	70a2                	ld	ra,40(sp)
    800026b2:	7402                	ld	s0,32(sp)
    800026b4:	64e2                	ld	s1,24(sp)
    800026b6:	6942                	ld	s2,16(sp)
    800026b8:	69a2                	ld	s3,8(sp)
    800026ba:	6a02                	ld	s4,0(sp)
    800026bc:	6145                	addi	sp,sp,48
    800026be:	8082                	ret

00000000800026c0 <exit>:
{
    800026c0:	7179                	addi	sp,sp,-48
    800026c2:	f406                	sd	ra,40(sp)
    800026c4:	f022                	sd	s0,32(sp)
    800026c6:	ec26                	sd	s1,24(sp)
    800026c8:	e84a                	sd	s2,16(sp)
    800026ca:	e44e                	sd	s3,8(sp)
    800026cc:	e052                	sd	s4,0(sp)
    800026ce:	1800                	addi	s0,sp,48
    800026d0:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800026d2:	fffff097          	auipc	ra,0xfffff
    800026d6:	522080e7          	jalr	1314(ra) # 80001bf4 <myproc>
    800026da:	89aa                	mv	s3,a0
  if(p == initproc)
    800026dc:	00007797          	auipc	a5,0x7
    800026e0:	94c7b783          	ld	a5,-1716(a5) # 80009028 <initproc>
    800026e4:	0e050493          	addi	s1,a0,224
    800026e8:	16050913          	addi	s2,a0,352
    800026ec:	02a79363          	bne	a5,a0,80002712 <exit+0x52>
    panic("init exiting");
    800026f0:	00006517          	auipc	a0,0x6
    800026f4:	c5050513          	addi	a0,a0,-944 # 80008340 <digits+0x300>
    800026f8:	ffffe097          	auipc	ra,0xffffe
    800026fc:	e32080e7          	jalr	-462(ra) # 8000052a <panic>
      fileclose(f);
    80002700:	00002097          	auipc	ra,0x2
    80002704:	1da080e7          	jalr	474(ra) # 800048da <fileclose>
      p->ofile[fd] = 0;
    80002708:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000270c:	04a1                	addi	s1,s1,8
    8000270e:	01248563          	beq	s1,s2,80002718 <exit+0x58>
    if(p->ofile[fd]){
    80002712:	6088                	ld	a0,0(s1)
    80002714:	f575                	bnez	a0,80002700 <exit+0x40>
    80002716:	bfdd                	j	8000270c <exit+0x4c>
  begin_op();
    80002718:	00002097          	auipc	ra,0x2
    8000271c:	cf6080e7          	jalr	-778(ra) # 8000440e <begin_op>
  iput(p->cwd);
    80002720:	1609b503          	ld	a0,352(s3)
    80002724:	00001097          	auipc	ra,0x1
    80002728:	4d2080e7          	jalr	1234(ra) # 80003bf6 <iput>
  end_op();
    8000272c:	00002097          	auipc	ra,0x2
    80002730:	d62080e7          	jalr	-670(ra) # 8000448e <end_op>
  p->cwd = 0;
    80002734:	1609b023          	sd	zero,352(s3)
  acquire(&wait_lock);
    80002738:	0000f497          	auipc	s1,0xf
    8000273c:	b8048493          	addi	s1,s1,-1152 # 800112b8 <wait_lock>
    80002740:	8526                	mv	a0,s1
    80002742:	ffffe097          	auipc	ra,0xffffe
    80002746:	480080e7          	jalr	1152(ra) # 80000bc2 <acquire>
  reparent(p);
    8000274a:	854e                	mv	a0,s3
    8000274c:	00000097          	auipc	ra,0x0
    80002750:	f1a080e7          	jalr	-230(ra) # 80002666 <reparent>
  wakeup(p->parent);
    80002754:	0389b503          	ld	a0,56(s3)
    80002758:	00000097          	auipc	ra,0x0
    8000275c:	e98080e7          	jalr	-360(ra) # 800025f0 <wakeup>
  acquire(&p->lock);
    80002760:	854e                	mv	a0,s3
    80002762:	ffffe097          	auipc	ra,0xffffe
    80002766:	460080e7          	jalr	1120(ra) # 80000bc2 <acquire>
  p->xstate = status;
    8000276a:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000276e:	4795                	li	a5,5
    80002770:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80002774:	8526                	mv	a0,s1
    80002776:	ffffe097          	auipc	ra,0xffffe
    8000277a:	500080e7          	jalr	1280(ra) # 80000c76 <release>
  sched();
    8000277e:	00000097          	auipc	ra,0x0
    80002782:	bd4080e7          	jalr	-1068(ra) # 80002352 <sched>
  panic("zombie exit");
    80002786:	00006517          	auipc	a0,0x6
    8000278a:	bca50513          	addi	a0,a0,-1078 # 80008350 <digits+0x310>
    8000278e:	ffffe097          	auipc	ra,0xffffe
    80002792:	d9c080e7          	jalr	-612(ra) # 8000052a <panic>

0000000080002796 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002796:	7179                	addi	sp,sp,-48
    80002798:	f406                	sd	ra,40(sp)
    8000279a:	f022                	sd	s0,32(sp)
    8000279c:	ec26                	sd	s1,24(sp)
    8000279e:	e84a                	sd	s2,16(sp)
    800027a0:	e44e                	sd	s3,8(sp)
    800027a2:	1800                	addi	s0,sp,48
    800027a4:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800027a6:	0000f497          	auipc	s1,0xf
    800027aa:	f2a48493          	addi	s1,s1,-214 # 800116d0 <proc>
    800027ae:	00015997          	auipc	s3,0x15
    800027b2:	d2298993          	addi	s3,s3,-734 # 800174d0 <tickslock>
    acquire(&p->lock);
    800027b6:	8526                	mv	a0,s1
    800027b8:	ffffe097          	auipc	ra,0xffffe
    800027bc:	40a080e7          	jalr	1034(ra) # 80000bc2 <acquire>
    if(p->pid == pid){
    800027c0:	589c                	lw	a5,48(s1)
    800027c2:	01278d63          	beq	a5,s2,800027dc <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800027c6:	8526                	mv	a0,s1
    800027c8:	ffffe097          	auipc	ra,0xffffe
    800027cc:	4ae080e7          	jalr	1198(ra) # 80000c76 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800027d0:	17848493          	addi	s1,s1,376
    800027d4:	ff3491e3          	bne	s1,s3,800027b6 <kill+0x20>
  }
  return -1;
    800027d8:	557d                	li	a0,-1
    800027da:	a829                	j	800027f4 <kill+0x5e>
      p->killed = 1;
    800027dc:	4785                	li	a5,1
    800027de:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800027e0:	4c98                	lw	a4,24(s1)
    800027e2:	4789                	li	a5,2
    800027e4:	00f70f63          	beq	a4,a5,80002802 <kill+0x6c>
      release(&p->lock);
    800027e8:	8526                	mv	a0,s1
    800027ea:	ffffe097          	auipc	ra,0xffffe
    800027ee:	48c080e7          	jalr	1164(ra) # 80000c76 <release>
      return 0;
    800027f2:	4501                	li	a0,0
}
    800027f4:	70a2                	ld	ra,40(sp)
    800027f6:	7402                	ld	s0,32(sp)
    800027f8:	64e2                	ld	s1,24(sp)
    800027fa:	6942                	ld	s2,16(sp)
    800027fc:	69a2                	ld	s3,8(sp)
    800027fe:	6145                	addi	sp,sp,48
    80002800:	8082                	ret
        p->state = RUNNABLE;
    80002802:	478d                	li	a5,3
    80002804:	cc9c                	sw	a5,24(s1)
    80002806:	b7cd                	j	800027e8 <kill+0x52>

0000000080002808 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002808:	7179                	addi	sp,sp,-48
    8000280a:	f406                	sd	ra,40(sp)
    8000280c:	f022                	sd	s0,32(sp)
    8000280e:	ec26                	sd	s1,24(sp)
    80002810:	e84a                	sd	s2,16(sp)
    80002812:	e44e                	sd	s3,8(sp)
    80002814:	e052                	sd	s4,0(sp)
    80002816:	1800                	addi	s0,sp,48
    80002818:	84aa                	mv	s1,a0
    8000281a:	892e                	mv	s2,a1
    8000281c:	89b2                	mv	s3,a2
    8000281e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002820:	fffff097          	auipc	ra,0xfffff
    80002824:	3d4080e7          	jalr	980(ra) # 80001bf4 <myproc>
  if(user_dst){
    80002828:	c08d                	beqz	s1,8000284a <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000282a:	86d2                	mv	a3,s4
    8000282c:	864e                	mv	a2,s3
    8000282e:	85ca                	mv	a1,s2
    80002830:	6d28                	ld	a0,88(a0)
    80002832:	fffff097          	auipc	ra,0xfffff
    80002836:	fb2080e7          	jalr	-78(ra) # 800017e4 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000283a:	70a2                	ld	ra,40(sp)
    8000283c:	7402                	ld	s0,32(sp)
    8000283e:	64e2                	ld	s1,24(sp)
    80002840:	6942                	ld	s2,16(sp)
    80002842:	69a2                	ld	s3,8(sp)
    80002844:	6a02                	ld	s4,0(sp)
    80002846:	6145                	addi	sp,sp,48
    80002848:	8082                	ret
    memmove((char *)dst, src, len);
    8000284a:	000a061b          	sext.w	a2,s4
    8000284e:	85ce                	mv	a1,s3
    80002850:	854a                	mv	a0,s2
    80002852:	ffffe097          	auipc	ra,0xffffe
    80002856:	4c8080e7          	jalr	1224(ra) # 80000d1a <memmove>
    return 0;
    8000285a:	8526                	mv	a0,s1
    8000285c:	bff9                	j	8000283a <either_copyout+0x32>

000000008000285e <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000285e:	7179                	addi	sp,sp,-48
    80002860:	f406                	sd	ra,40(sp)
    80002862:	f022                	sd	s0,32(sp)
    80002864:	ec26                	sd	s1,24(sp)
    80002866:	e84a                	sd	s2,16(sp)
    80002868:	e44e                	sd	s3,8(sp)
    8000286a:	e052                	sd	s4,0(sp)
    8000286c:	1800                	addi	s0,sp,48
    8000286e:	892a                	mv	s2,a0
    80002870:	84ae                	mv	s1,a1
    80002872:	89b2                	mv	s3,a2
    80002874:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002876:	fffff097          	auipc	ra,0xfffff
    8000287a:	37e080e7          	jalr	894(ra) # 80001bf4 <myproc>
  if(user_src){
    8000287e:	c08d                	beqz	s1,800028a0 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002880:	86d2                	mv	a3,s4
    80002882:	864e                	mv	a2,s3
    80002884:	85ca                	mv	a1,s2
    80002886:	6d28                	ld	a0,88(a0)
    80002888:	fffff097          	auipc	ra,0xfffff
    8000288c:	062080e7          	jalr	98(ra) # 800018ea <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002890:	70a2                	ld	ra,40(sp)
    80002892:	7402                	ld	s0,32(sp)
    80002894:	64e2                	ld	s1,24(sp)
    80002896:	6942                	ld	s2,16(sp)
    80002898:	69a2                	ld	s3,8(sp)
    8000289a:	6a02                	ld	s4,0(sp)
    8000289c:	6145                	addi	sp,sp,48
    8000289e:	8082                	ret
    memmove(dst, (char*)src, len);
    800028a0:	000a061b          	sext.w	a2,s4
    800028a4:	85ce                	mv	a1,s3
    800028a6:	854a                	mv	a0,s2
    800028a8:	ffffe097          	auipc	ra,0xffffe
    800028ac:	472080e7          	jalr	1138(ra) # 80000d1a <memmove>
    return 0;
    800028b0:	8526                	mv	a0,s1
    800028b2:	bff9                	j	80002890 <either_copyin+0x32>

00000000800028b4 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800028b4:	715d                	addi	sp,sp,-80
    800028b6:	e486                	sd	ra,72(sp)
    800028b8:	e0a2                	sd	s0,64(sp)
    800028ba:	fc26                	sd	s1,56(sp)
    800028bc:	f84a                	sd	s2,48(sp)
    800028be:	f44e                	sd	s3,40(sp)
    800028c0:	f052                	sd	s4,32(sp)
    800028c2:	ec56                	sd	s5,24(sp)
    800028c4:	e85a                	sd	s6,16(sp)
    800028c6:	e45e                	sd	s7,8(sp)
    800028c8:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800028ca:	00005517          	auipc	a0,0x5
    800028ce:	7fe50513          	addi	a0,a0,2046 # 800080c8 <digits+0x88>
    800028d2:	ffffe097          	auipc	ra,0xffffe
    800028d6:	ca2080e7          	jalr	-862(ra) # 80000574 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800028da:	0000f497          	auipc	s1,0xf
    800028de:	f5e48493          	addi	s1,s1,-162 # 80011838 <proc+0x168>
    800028e2:	00015917          	auipc	s2,0x15
    800028e6:	d5690913          	addi	s2,s2,-682 # 80017638 <bcache+0x150>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800028ea:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800028ec:	00006997          	auipc	s3,0x6
    800028f0:	a7498993          	addi	s3,s3,-1420 # 80008360 <digits+0x320>
    printf("%d %s %s", p->pid, state, p->name);
    800028f4:	00006a97          	auipc	s5,0x6
    800028f8:	a74a8a93          	addi	s5,s5,-1420 # 80008368 <digits+0x328>
    printf("\n");
    800028fc:	00005a17          	auipc	s4,0x5
    80002900:	7cca0a13          	addi	s4,s4,1996 # 800080c8 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002904:	00006b97          	auipc	s7,0x6
    80002908:	a9cb8b93          	addi	s7,s7,-1380 # 800083a0 <states.0>
    8000290c:	a00d                	j	8000292e <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    8000290e:	ec86a583          	lw	a1,-312(a3)
    80002912:	8556                	mv	a0,s5
    80002914:	ffffe097          	auipc	ra,0xffffe
    80002918:	c60080e7          	jalr	-928(ra) # 80000574 <printf>
    printf("\n");
    8000291c:	8552                	mv	a0,s4
    8000291e:	ffffe097          	auipc	ra,0xffffe
    80002922:	c56080e7          	jalr	-938(ra) # 80000574 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002926:	17848493          	addi	s1,s1,376
    8000292a:	03248163          	beq	s1,s2,8000294c <procdump+0x98>
    if(p->state == UNUSED)
    8000292e:	86a6                	mv	a3,s1
    80002930:	eb04a783          	lw	a5,-336(s1)
    80002934:	dbed                	beqz	a5,80002926 <procdump+0x72>
      state = "???";
    80002936:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002938:	fcfb6be3          	bltu	s6,a5,8000290e <procdump+0x5a>
    8000293c:	1782                	slli	a5,a5,0x20
    8000293e:	9381                	srli	a5,a5,0x20
    80002940:	078e                	slli	a5,a5,0x3
    80002942:	97de                	add	a5,a5,s7
    80002944:	6390                	ld	a2,0(a5)
    80002946:	f661                	bnez	a2,8000290e <procdump+0x5a>
      state = "???";
    80002948:	864e                	mv	a2,s3
    8000294a:	b7d1                	j	8000290e <procdump+0x5a>
  }
}
    8000294c:	60a6                	ld	ra,72(sp)
    8000294e:	6406                	ld	s0,64(sp)
    80002950:	74e2                	ld	s1,56(sp)
    80002952:	7942                	ld	s2,48(sp)
    80002954:	79a2                	ld	s3,40(sp)
    80002956:	7a02                	ld	s4,32(sp)
    80002958:	6ae2                	ld	s5,24(sp)
    8000295a:	6b42                	ld	s6,16(sp)
    8000295c:	6ba2                	ld	s7,8(sp)
    8000295e:	6161                	addi	sp,sp,80
    80002960:	8082                	ret

0000000080002962 <swtch>:
    80002962:	00153023          	sd	ra,0(a0)
    80002966:	00253423          	sd	sp,8(a0)
    8000296a:	e900                	sd	s0,16(a0)
    8000296c:	ed04                	sd	s1,24(a0)
    8000296e:	03253023          	sd	s2,32(a0)
    80002972:	03353423          	sd	s3,40(a0)
    80002976:	03453823          	sd	s4,48(a0)
    8000297a:	03553c23          	sd	s5,56(a0)
    8000297e:	05653023          	sd	s6,64(a0)
    80002982:	05753423          	sd	s7,72(a0)
    80002986:	05853823          	sd	s8,80(a0)
    8000298a:	05953c23          	sd	s9,88(a0)
    8000298e:	07a53023          	sd	s10,96(a0)
    80002992:	07b53423          	sd	s11,104(a0)
    80002996:	0005b083          	ld	ra,0(a1)
    8000299a:	0085b103          	ld	sp,8(a1)
    8000299e:	6980                	ld	s0,16(a1)
    800029a0:	6d84                	ld	s1,24(a1)
    800029a2:	0205b903          	ld	s2,32(a1)
    800029a6:	0285b983          	ld	s3,40(a1)
    800029aa:	0305ba03          	ld	s4,48(a1)
    800029ae:	0385ba83          	ld	s5,56(a1)
    800029b2:	0405bb03          	ld	s6,64(a1)
    800029b6:	0485bb83          	ld	s7,72(a1)
    800029ba:	0505bc03          	ld	s8,80(a1)
    800029be:	0585bc83          	ld	s9,88(a1)
    800029c2:	0605bd03          	ld	s10,96(a1)
    800029c6:	0685bd83          	ld	s11,104(a1)
    800029ca:	8082                	ret

00000000800029cc <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800029cc:	1141                	addi	sp,sp,-16
    800029ce:	e406                	sd	ra,8(sp)
    800029d0:	e022                	sd	s0,0(sp)
    800029d2:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800029d4:	00006597          	auipc	a1,0x6
    800029d8:	9fc58593          	addi	a1,a1,-1540 # 800083d0 <states.0+0x30>
    800029dc:	00015517          	auipc	a0,0x15
    800029e0:	af450513          	addi	a0,a0,-1292 # 800174d0 <tickslock>
    800029e4:	ffffe097          	auipc	ra,0xffffe
    800029e8:	14e080e7          	jalr	334(ra) # 80000b32 <initlock>
}
    800029ec:	60a2                	ld	ra,8(sp)
    800029ee:	6402                	ld	s0,0(sp)
    800029f0:	0141                	addi	sp,sp,16
    800029f2:	8082                	ret

00000000800029f4 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800029f4:	1141                	addi	sp,sp,-16
    800029f6:	e422                	sd	s0,8(sp)
    800029f8:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800029fa:	00003797          	auipc	a5,0x3
    800029fe:	54678793          	addi	a5,a5,1350 # 80005f40 <kernelvec>
    80002a02:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002a06:	6422                	ld	s0,8(sp)
    80002a08:	0141                	addi	sp,sp,16
    80002a0a:	8082                	ret

0000000080002a0c <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002a0c:	1141                	addi	sp,sp,-16
    80002a0e:	e406                	sd	ra,8(sp)
    80002a10:	e022                	sd	s0,0(sp)
    80002a12:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002a14:	fffff097          	auipc	ra,0xfffff
    80002a18:	1e0080e7          	jalr	480(ra) # 80001bf4 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a1c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002a20:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a22:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002a26:	00004617          	auipc	a2,0x4
    80002a2a:	5da60613          	addi	a2,a2,1498 # 80007000 <_trampoline>
    80002a2e:	00004697          	auipc	a3,0x4
    80002a32:	5d268693          	addi	a3,a3,1490 # 80007000 <_trampoline>
    80002a36:	8e91                	sub	a3,a3,a2
    80002a38:	040007b7          	lui	a5,0x4000
    80002a3c:	17fd                	addi	a5,a5,-1
    80002a3e:	07b2                	slli	a5,a5,0xc
    80002a40:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002a42:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002a46:	7538                	ld	a4,104(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002a48:	180026f3          	csrr	a3,satp
    80002a4c:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002a4e:	7538                	ld	a4,104(a0)
    80002a50:	6534                	ld	a3,72(a0)
    80002a52:	6585                	lui	a1,0x1
    80002a54:	96ae                	add	a3,a3,a1
    80002a56:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002a58:	7538                	ld	a4,104(a0)
    80002a5a:	00000697          	auipc	a3,0x0
    80002a5e:	13868693          	addi	a3,a3,312 # 80002b92 <usertrap>
    80002a62:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002a64:	7538                	ld	a4,104(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002a66:	8692                	mv	a3,tp
    80002a68:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a6a:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002a6e:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002a72:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a76:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002a7a:	7538                	ld	a4,104(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002a7c:	6f18                	ld	a4,24(a4)
    80002a7e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002a82:	6d2c                	ld	a1,88(a0)
    80002a84:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80002a86:	00004717          	auipc	a4,0x4
    80002a8a:	60a70713          	addi	a4,a4,1546 # 80007090 <userret>
    80002a8e:	8f11                	sub	a4,a4,a2
    80002a90:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80002a92:	577d                	li	a4,-1
    80002a94:	177e                	slli	a4,a4,0x3f
    80002a96:	8dd9                	or	a1,a1,a4
    80002a98:	02000537          	lui	a0,0x2000
    80002a9c:	157d                	addi	a0,a0,-1
    80002a9e:	0536                	slli	a0,a0,0xd
    80002aa0:	9782                	jalr	a5
}
    80002aa2:	60a2                	ld	ra,8(sp)
    80002aa4:	6402                	ld	s0,0(sp)
    80002aa6:	0141                	addi	sp,sp,16
    80002aa8:	8082                	ret

0000000080002aaa <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002aaa:	1101                	addi	sp,sp,-32
    80002aac:	ec06                	sd	ra,24(sp)
    80002aae:	e822                	sd	s0,16(sp)
    80002ab0:	e426                	sd	s1,8(sp)
    80002ab2:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002ab4:	00015497          	auipc	s1,0x15
    80002ab8:	a1c48493          	addi	s1,s1,-1508 # 800174d0 <tickslock>
    80002abc:	8526                	mv	a0,s1
    80002abe:	ffffe097          	auipc	ra,0xffffe
    80002ac2:	104080e7          	jalr	260(ra) # 80000bc2 <acquire>
  ticks++;
    80002ac6:	00006517          	auipc	a0,0x6
    80002aca:	56a50513          	addi	a0,a0,1386 # 80009030 <ticks>
    80002ace:	411c                	lw	a5,0(a0)
    80002ad0:	2785                	addiw	a5,a5,1
    80002ad2:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002ad4:	00000097          	auipc	ra,0x0
    80002ad8:	b1c080e7          	jalr	-1252(ra) # 800025f0 <wakeup>
  release(&tickslock);
    80002adc:	8526                	mv	a0,s1
    80002ade:	ffffe097          	auipc	ra,0xffffe
    80002ae2:	198080e7          	jalr	408(ra) # 80000c76 <release>
}
    80002ae6:	60e2                	ld	ra,24(sp)
    80002ae8:	6442                	ld	s0,16(sp)
    80002aea:	64a2                	ld	s1,8(sp)
    80002aec:	6105                	addi	sp,sp,32
    80002aee:	8082                	ret

0000000080002af0 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002af0:	1101                	addi	sp,sp,-32
    80002af2:	ec06                	sd	ra,24(sp)
    80002af4:	e822                	sd	s0,16(sp)
    80002af6:	e426                	sd	s1,8(sp)
    80002af8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002afa:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80002afe:	00074d63          	bltz	a4,80002b18 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80002b02:	57fd                	li	a5,-1
    80002b04:	17fe                	slli	a5,a5,0x3f
    80002b06:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002b08:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002b0a:	06f70363          	beq	a4,a5,80002b70 <devintr+0x80>
  }
}
    80002b0e:	60e2                	ld	ra,24(sp)
    80002b10:	6442                	ld	s0,16(sp)
    80002b12:	64a2                	ld	s1,8(sp)
    80002b14:	6105                	addi	sp,sp,32
    80002b16:	8082                	ret
     (scause & 0xff) == 9){
    80002b18:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80002b1c:	46a5                	li	a3,9
    80002b1e:	fed792e3          	bne	a5,a3,80002b02 <devintr+0x12>
    int irq = plic_claim();
    80002b22:	00003097          	auipc	ra,0x3
    80002b26:	526080e7          	jalr	1318(ra) # 80006048 <plic_claim>
    80002b2a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002b2c:	47a9                	li	a5,10
    80002b2e:	02f50763          	beq	a0,a5,80002b5c <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80002b32:	4785                	li	a5,1
    80002b34:	02f50963          	beq	a0,a5,80002b66 <devintr+0x76>
    return 1;
    80002b38:	4505                	li	a0,1
    } else if(irq){
    80002b3a:	d8f1                	beqz	s1,80002b0e <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002b3c:	85a6                	mv	a1,s1
    80002b3e:	00006517          	auipc	a0,0x6
    80002b42:	89a50513          	addi	a0,a0,-1894 # 800083d8 <states.0+0x38>
    80002b46:	ffffe097          	auipc	ra,0xffffe
    80002b4a:	a2e080e7          	jalr	-1490(ra) # 80000574 <printf>
      plic_complete(irq);
    80002b4e:	8526                	mv	a0,s1
    80002b50:	00003097          	auipc	ra,0x3
    80002b54:	51c080e7          	jalr	1308(ra) # 8000606c <plic_complete>
    return 1;
    80002b58:	4505                	li	a0,1
    80002b5a:	bf55                	j	80002b0e <devintr+0x1e>
      uartintr();
    80002b5c:	ffffe097          	auipc	ra,0xffffe
    80002b60:	e2a080e7          	jalr	-470(ra) # 80000986 <uartintr>
    80002b64:	b7ed                	j	80002b4e <devintr+0x5e>
      virtio_disk_intr();
    80002b66:	00004097          	auipc	ra,0x4
    80002b6a:	998080e7          	jalr	-1640(ra) # 800064fe <virtio_disk_intr>
    80002b6e:	b7c5                	j	80002b4e <devintr+0x5e>
    if(cpuid() == 0){
    80002b70:	fffff097          	auipc	ra,0xfffff
    80002b74:	058080e7          	jalr	88(ra) # 80001bc8 <cpuid>
    80002b78:	c901                	beqz	a0,80002b88 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002b7a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002b7e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002b80:	14479073          	csrw	sip,a5
    return 2;
    80002b84:	4509                	li	a0,2
    80002b86:	b761                	j	80002b0e <devintr+0x1e>
      clockintr();
    80002b88:	00000097          	auipc	ra,0x0
    80002b8c:	f22080e7          	jalr	-222(ra) # 80002aaa <clockintr>
    80002b90:	b7ed                	j	80002b7a <devintr+0x8a>

0000000080002b92 <usertrap>:
{
    80002b92:	1101                	addi	sp,sp,-32
    80002b94:	ec06                	sd	ra,24(sp)
    80002b96:	e822                	sd	s0,16(sp)
    80002b98:	e426                	sd	s1,8(sp)
    80002b9a:	e04a                	sd	s2,0(sp)
    80002b9c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b9e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002ba2:	1007f793          	andi	a5,a5,256
    80002ba6:	e3ad                	bnez	a5,80002c08 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002ba8:	00003797          	auipc	a5,0x3
    80002bac:	39878793          	addi	a5,a5,920 # 80005f40 <kernelvec>
    80002bb0:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002bb4:	fffff097          	auipc	ra,0xfffff
    80002bb8:	040080e7          	jalr	64(ra) # 80001bf4 <myproc>
    80002bbc:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002bbe:	753c                	ld	a5,104(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002bc0:	14102773          	csrr	a4,sepc
    80002bc4:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002bc6:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002bca:	47a1                	li	a5,8
    80002bcc:	04f71c63          	bne	a4,a5,80002c24 <usertrap+0x92>
    if(p->killed)
    80002bd0:	551c                	lw	a5,40(a0)
    80002bd2:	e3b9                	bnez	a5,80002c18 <usertrap+0x86>
    p->trapframe->epc += 4;
    80002bd4:	74b8                	ld	a4,104(s1)
    80002bd6:	6f1c                	ld	a5,24(a4)
    80002bd8:	0791                	addi	a5,a5,4
    80002bda:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002bdc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002be0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002be4:	10079073          	csrw	sstatus,a5
    syscall();
    80002be8:	00000097          	auipc	ra,0x0
    80002bec:	2e0080e7          	jalr	736(ra) # 80002ec8 <syscall>
  if(p->killed)
    80002bf0:	549c                	lw	a5,40(s1)
    80002bf2:	ebc1                	bnez	a5,80002c82 <usertrap+0xf0>
  usertrapret();
    80002bf4:	00000097          	auipc	ra,0x0
    80002bf8:	e18080e7          	jalr	-488(ra) # 80002a0c <usertrapret>
}
    80002bfc:	60e2                	ld	ra,24(sp)
    80002bfe:	6442                	ld	s0,16(sp)
    80002c00:	64a2                	ld	s1,8(sp)
    80002c02:	6902                	ld	s2,0(sp)
    80002c04:	6105                	addi	sp,sp,32
    80002c06:	8082                	ret
    panic("usertrap: not from user mode");
    80002c08:	00005517          	auipc	a0,0x5
    80002c0c:	7f050513          	addi	a0,a0,2032 # 800083f8 <states.0+0x58>
    80002c10:	ffffe097          	auipc	ra,0xffffe
    80002c14:	91a080e7          	jalr	-1766(ra) # 8000052a <panic>
      exit(-1);
    80002c18:	557d                	li	a0,-1
    80002c1a:	00000097          	auipc	ra,0x0
    80002c1e:	aa6080e7          	jalr	-1370(ra) # 800026c0 <exit>
    80002c22:	bf4d                	j	80002bd4 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80002c24:	00000097          	auipc	ra,0x0
    80002c28:	ecc080e7          	jalr	-308(ra) # 80002af0 <devintr>
    80002c2c:	892a                	mv	s2,a0
    80002c2e:	c501                	beqz	a0,80002c36 <usertrap+0xa4>
  if(p->killed)
    80002c30:	549c                	lw	a5,40(s1)
    80002c32:	c3a1                	beqz	a5,80002c72 <usertrap+0xe0>
    80002c34:	a815                	j	80002c68 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002c36:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002c3a:	5890                	lw	a2,48(s1)
    80002c3c:	00005517          	auipc	a0,0x5
    80002c40:	7dc50513          	addi	a0,a0,2012 # 80008418 <states.0+0x78>
    80002c44:	ffffe097          	auipc	ra,0xffffe
    80002c48:	930080e7          	jalr	-1744(ra) # 80000574 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002c4c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002c50:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002c54:	00005517          	auipc	a0,0x5
    80002c58:	7f450513          	addi	a0,a0,2036 # 80008448 <states.0+0xa8>
    80002c5c:	ffffe097          	auipc	ra,0xffffe
    80002c60:	918080e7          	jalr	-1768(ra) # 80000574 <printf>
    p->killed = 1;
    80002c64:	4785                	li	a5,1
    80002c66:	d49c                	sw	a5,40(s1)
    exit(-1);
    80002c68:	557d                	li	a0,-1
    80002c6a:	00000097          	auipc	ra,0x0
    80002c6e:	a56080e7          	jalr	-1450(ra) # 800026c0 <exit>
  if(which_dev == 2)
    80002c72:	4789                	li	a5,2
    80002c74:	f8f910e3          	bne	s2,a5,80002bf4 <usertrap+0x62>
    yield();
    80002c78:	fffff097          	auipc	ra,0xfffff
    80002c7c:	7b0080e7          	jalr	1968(ra) # 80002428 <yield>
    80002c80:	bf95                	j	80002bf4 <usertrap+0x62>
  int which_dev = 0;
    80002c82:	4901                	li	s2,0
    80002c84:	b7d5                	j	80002c68 <usertrap+0xd6>

0000000080002c86 <kerneltrap>:
{
    80002c86:	7179                	addi	sp,sp,-48
    80002c88:	f406                	sd	ra,40(sp)
    80002c8a:	f022                	sd	s0,32(sp)
    80002c8c:	ec26                	sd	s1,24(sp)
    80002c8e:	e84a                	sd	s2,16(sp)
    80002c90:	e44e                	sd	s3,8(sp)
    80002c92:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002c94:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002c98:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002c9c:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002ca0:	1004f793          	andi	a5,s1,256
    80002ca4:	cb85                	beqz	a5,80002cd4 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ca6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002caa:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002cac:	ef85                	bnez	a5,80002ce4 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002cae:	00000097          	auipc	ra,0x0
    80002cb2:	e42080e7          	jalr	-446(ra) # 80002af0 <devintr>
    80002cb6:	cd1d                	beqz	a0,80002cf4 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002cb8:	4789                	li	a5,2
    80002cba:	06f50a63          	beq	a0,a5,80002d2e <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002cbe:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002cc2:	10049073          	csrw	sstatus,s1
}
    80002cc6:	70a2                	ld	ra,40(sp)
    80002cc8:	7402                	ld	s0,32(sp)
    80002cca:	64e2                	ld	s1,24(sp)
    80002ccc:	6942                	ld	s2,16(sp)
    80002cce:	69a2                	ld	s3,8(sp)
    80002cd0:	6145                	addi	sp,sp,48
    80002cd2:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002cd4:	00005517          	auipc	a0,0x5
    80002cd8:	79450513          	addi	a0,a0,1940 # 80008468 <states.0+0xc8>
    80002cdc:	ffffe097          	auipc	ra,0xffffe
    80002ce0:	84e080e7          	jalr	-1970(ra) # 8000052a <panic>
    panic("kerneltrap: interrupts enabled");
    80002ce4:	00005517          	auipc	a0,0x5
    80002ce8:	7ac50513          	addi	a0,a0,1964 # 80008490 <states.0+0xf0>
    80002cec:	ffffe097          	auipc	ra,0xffffe
    80002cf0:	83e080e7          	jalr	-1986(ra) # 8000052a <panic>
    printf("scause %p\n", scause);
    80002cf4:	85ce                	mv	a1,s3
    80002cf6:	00005517          	auipc	a0,0x5
    80002cfa:	7ba50513          	addi	a0,a0,1978 # 800084b0 <states.0+0x110>
    80002cfe:	ffffe097          	auipc	ra,0xffffe
    80002d02:	876080e7          	jalr	-1930(ra) # 80000574 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002d06:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002d0a:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002d0e:	00005517          	auipc	a0,0x5
    80002d12:	7b250513          	addi	a0,a0,1970 # 800084c0 <states.0+0x120>
    80002d16:	ffffe097          	auipc	ra,0xffffe
    80002d1a:	85e080e7          	jalr	-1954(ra) # 80000574 <printf>
    panic("kerneltrap");
    80002d1e:	00005517          	auipc	a0,0x5
    80002d22:	7ba50513          	addi	a0,a0,1978 # 800084d8 <states.0+0x138>
    80002d26:	ffffe097          	auipc	ra,0xffffe
    80002d2a:	804080e7          	jalr	-2044(ra) # 8000052a <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002d2e:	fffff097          	auipc	ra,0xfffff
    80002d32:	ec6080e7          	jalr	-314(ra) # 80001bf4 <myproc>
    80002d36:	d541                	beqz	a0,80002cbe <kerneltrap+0x38>
    80002d38:	fffff097          	auipc	ra,0xfffff
    80002d3c:	ebc080e7          	jalr	-324(ra) # 80001bf4 <myproc>
    80002d40:	4d18                	lw	a4,24(a0)
    80002d42:	4791                	li	a5,4
    80002d44:	f6f71de3          	bne	a4,a5,80002cbe <kerneltrap+0x38>
    yield();
    80002d48:	fffff097          	auipc	ra,0xfffff
    80002d4c:	6e0080e7          	jalr	1760(ra) # 80002428 <yield>
    80002d50:	b7bd                	j	80002cbe <kerneltrap+0x38>

0000000080002d52 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002d52:	1101                	addi	sp,sp,-32
    80002d54:	ec06                	sd	ra,24(sp)
    80002d56:	e822                	sd	s0,16(sp)
    80002d58:	e426                	sd	s1,8(sp)
    80002d5a:	1000                	addi	s0,sp,32
    80002d5c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002d5e:	fffff097          	auipc	ra,0xfffff
    80002d62:	e96080e7          	jalr	-362(ra) # 80001bf4 <myproc>
  switch (n) {
    80002d66:	4795                	li	a5,5
    80002d68:	0497e163          	bltu	a5,s1,80002daa <argraw+0x58>
    80002d6c:	048a                	slli	s1,s1,0x2
    80002d6e:	00005717          	auipc	a4,0x5
    80002d72:	7ba70713          	addi	a4,a4,1978 # 80008528 <states.0+0x188>
    80002d76:	94ba                	add	s1,s1,a4
    80002d78:	409c                	lw	a5,0(s1)
    80002d7a:	97ba                	add	a5,a5,a4
    80002d7c:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002d7e:	753c                	ld	a5,104(a0)
    80002d80:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002d82:	60e2                	ld	ra,24(sp)
    80002d84:	6442                	ld	s0,16(sp)
    80002d86:	64a2                	ld	s1,8(sp)
    80002d88:	6105                	addi	sp,sp,32
    80002d8a:	8082                	ret
    return p->trapframe->a1;
    80002d8c:	753c                	ld	a5,104(a0)
    80002d8e:	7fa8                	ld	a0,120(a5)
    80002d90:	bfcd                	j	80002d82 <argraw+0x30>
    return p->trapframe->a2;
    80002d92:	753c                	ld	a5,104(a0)
    80002d94:	63c8                	ld	a0,128(a5)
    80002d96:	b7f5                	j	80002d82 <argraw+0x30>
    return p->trapframe->a3;
    80002d98:	753c                	ld	a5,104(a0)
    80002d9a:	67c8                	ld	a0,136(a5)
    80002d9c:	b7dd                	j	80002d82 <argraw+0x30>
    return p->trapframe->a4;
    80002d9e:	753c                	ld	a5,104(a0)
    80002da0:	6bc8                	ld	a0,144(a5)
    80002da2:	b7c5                	j	80002d82 <argraw+0x30>
    return p->trapframe->a5;
    80002da4:	753c                	ld	a5,104(a0)
    80002da6:	6fc8                	ld	a0,152(a5)
    80002da8:	bfe9                	j	80002d82 <argraw+0x30>
  panic("argraw");
    80002daa:	00005517          	auipc	a0,0x5
    80002dae:	73e50513          	addi	a0,a0,1854 # 800084e8 <states.0+0x148>
    80002db2:	ffffd097          	auipc	ra,0xffffd
    80002db6:	778080e7          	jalr	1912(ra) # 8000052a <panic>

0000000080002dba <fetchaddr>:
{
    80002dba:	1101                	addi	sp,sp,-32
    80002dbc:	ec06                	sd	ra,24(sp)
    80002dbe:	e822                	sd	s0,16(sp)
    80002dc0:	e426                	sd	s1,8(sp)
    80002dc2:	e04a                	sd	s2,0(sp)
    80002dc4:	1000                	addi	s0,sp,32
    80002dc6:	84aa                	mv	s1,a0
    80002dc8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002dca:	fffff097          	auipc	ra,0xfffff
    80002dce:	e2a080e7          	jalr	-470(ra) # 80001bf4 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002dd2:	693c                	ld	a5,80(a0)
    80002dd4:	02f4f863          	bgeu	s1,a5,80002e04 <fetchaddr+0x4a>
    80002dd8:	00848713          	addi	a4,s1,8
    80002ddc:	02e7e663          	bltu	a5,a4,80002e08 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002de0:	46a1                	li	a3,8
    80002de2:	8626                	mv	a2,s1
    80002de4:	85ca                	mv	a1,s2
    80002de6:	6d28                	ld	a0,88(a0)
    80002de8:	fffff097          	auipc	ra,0xfffff
    80002dec:	b02080e7          	jalr	-1278(ra) # 800018ea <copyin>
    80002df0:	00a03533          	snez	a0,a0
    80002df4:	40a00533          	neg	a0,a0
}
    80002df8:	60e2                	ld	ra,24(sp)
    80002dfa:	6442                	ld	s0,16(sp)
    80002dfc:	64a2                	ld	s1,8(sp)
    80002dfe:	6902                	ld	s2,0(sp)
    80002e00:	6105                	addi	sp,sp,32
    80002e02:	8082                	ret
    return -1;
    80002e04:	557d                	li	a0,-1
    80002e06:	bfcd                	j	80002df8 <fetchaddr+0x3e>
    80002e08:	557d                	li	a0,-1
    80002e0a:	b7fd                	j	80002df8 <fetchaddr+0x3e>

0000000080002e0c <fetchstr>:
{
    80002e0c:	7179                	addi	sp,sp,-48
    80002e0e:	f406                	sd	ra,40(sp)
    80002e10:	f022                	sd	s0,32(sp)
    80002e12:	ec26                	sd	s1,24(sp)
    80002e14:	e84a                	sd	s2,16(sp)
    80002e16:	e44e                	sd	s3,8(sp)
    80002e18:	1800                	addi	s0,sp,48
    80002e1a:	892a                	mv	s2,a0
    80002e1c:	84ae                	mv	s1,a1
    80002e1e:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002e20:	fffff097          	auipc	ra,0xfffff
    80002e24:	dd4080e7          	jalr	-556(ra) # 80001bf4 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002e28:	86ce                	mv	a3,s3
    80002e2a:	864a                	mv	a2,s2
    80002e2c:	85a6                	mv	a1,s1
    80002e2e:	6d28                	ld	a0,88(a0)
    80002e30:	fffff097          	auipc	ra,0xfffff
    80002e34:	b4c080e7          	jalr	-1204(ra) # 8000197c <copyinstr>
  if(err < 0)
    80002e38:	00054763          	bltz	a0,80002e46 <fetchstr+0x3a>
  return strlen(buf);
    80002e3c:	8526                	mv	a0,s1
    80002e3e:	ffffe097          	auipc	ra,0xffffe
    80002e42:	004080e7          	jalr	4(ra) # 80000e42 <strlen>
}
    80002e46:	70a2                	ld	ra,40(sp)
    80002e48:	7402                	ld	s0,32(sp)
    80002e4a:	64e2                	ld	s1,24(sp)
    80002e4c:	6942                	ld	s2,16(sp)
    80002e4e:	69a2                	ld	s3,8(sp)
    80002e50:	6145                	addi	sp,sp,48
    80002e52:	8082                	ret

0000000080002e54 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002e54:	1101                	addi	sp,sp,-32
    80002e56:	ec06                	sd	ra,24(sp)
    80002e58:	e822                	sd	s0,16(sp)
    80002e5a:	e426                	sd	s1,8(sp)
    80002e5c:	1000                	addi	s0,sp,32
    80002e5e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002e60:	00000097          	auipc	ra,0x0
    80002e64:	ef2080e7          	jalr	-270(ra) # 80002d52 <argraw>
    80002e68:	c088                	sw	a0,0(s1)
  return 0;
}
    80002e6a:	4501                	li	a0,0
    80002e6c:	60e2                	ld	ra,24(sp)
    80002e6e:	6442                	ld	s0,16(sp)
    80002e70:	64a2                	ld	s1,8(sp)
    80002e72:	6105                	addi	sp,sp,32
    80002e74:	8082                	ret

0000000080002e76 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002e76:	1101                	addi	sp,sp,-32
    80002e78:	ec06                	sd	ra,24(sp)
    80002e7a:	e822                	sd	s0,16(sp)
    80002e7c:	e426                	sd	s1,8(sp)
    80002e7e:	1000                	addi	s0,sp,32
    80002e80:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002e82:	00000097          	auipc	ra,0x0
    80002e86:	ed0080e7          	jalr	-304(ra) # 80002d52 <argraw>
    80002e8a:	e088                	sd	a0,0(s1)
  return 0;
}
    80002e8c:	4501                	li	a0,0
    80002e8e:	60e2                	ld	ra,24(sp)
    80002e90:	6442                	ld	s0,16(sp)
    80002e92:	64a2                	ld	s1,8(sp)
    80002e94:	6105                	addi	sp,sp,32
    80002e96:	8082                	ret

0000000080002e98 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002e98:	1101                	addi	sp,sp,-32
    80002e9a:	ec06                	sd	ra,24(sp)
    80002e9c:	e822                	sd	s0,16(sp)
    80002e9e:	e426                	sd	s1,8(sp)
    80002ea0:	e04a                	sd	s2,0(sp)
    80002ea2:	1000                	addi	s0,sp,32
    80002ea4:	84ae                	mv	s1,a1
    80002ea6:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002ea8:	00000097          	auipc	ra,0x0
    80002eac:	eaa080e7          	jalr	-342(ra) # 80002d52 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002eb0:	864a                	mv	a2,s2
    80002eb2:	85a6                	mv	a1,s1
    80002eb4:	00000097          	auipc	ra,0x0
    80002eb8:	f58080e7          	jalr	-168(ra) # 80002e0c <fetchstr>
}
    80002ebc:	60e2                	ld	ra,24(sp)
    80002ebe:	6442                	ld	s0,16(sp)
    80002ec0:	64a2                	ld	s1,8(sp)
    80002ec2:	6902                	ld	s2,0(sp)
    80002ec4:	6105                	addi	sp,sp,32
    80002ec6:	8082                	ret

0000000080002ec8 <syscall>:
};


void
syscall(void)
{
    80002ec8:	7179                	addi	sp,sp,-48
    80002eca:	f406                	sd	ra,40(sp)
    80002ecc:	f022                	sd	s0,32(sp)
    80002ece:	ec26                	sd	s1,24(sp)
    80002ed0:	e84a                	sd	s2,16(sp)
    80002ed2:	e44e                	sd	s3,8(sp)
    80002ed4:	e052                	sd	s4,0(sp)
    80002ed6:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80002ed8:	fffff097          	auipc	ra,0xfffff
    80002edc:	d1c080e7          	jalr	-740(ra) # 80001bf4 <myproc>
    80002ee0:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002ee2:	753c                	ld	a5,104(a0)
    80002ee4:	77dc                	ld	a5,168(a5)
    80002ee6:	0007891b          	sext.w	s2,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002eea:	37fd                	addiw	a5,a5,-1
    80002eec:	4755                	li	a4,21
    80002eee:	04f76f63          	bltu	a4,a5,80002f4c <syscall+0x84>
    80002ef2:	00391713          	slli	a4,s2,0x3
    80002ef6:	00005797          	auipc	a5,0x5
    80002efa:	64a78793          	addi	a5,a5,1610 # 80008540 <syscalls>
    80002efe:	97ba                	add	a5,a5,a4
    80002f00:	0007ba03          	ld	s4,0(a5)
    80002f04:	040a0463          	beqz	s4,80002f4c <syscall+0x84>
    i32 mask = myproc()->traced;
    80002f08:	fffff097          	auipc	ra,0xfffff
    80002f0c:	cec080e7          	jalr	-788(ra) # 80001bf4 <myproc>
    80002f10:	04052983          	lw	s3,64(a0)
    u64 res = syscalls[num]();
    80002f14:	9a02                	jalr	s4
    80002f16:	8a2a                	mv	s4,a0
    if (mask & (1 << num)){
    80002f18:	4129d9bb          	sraw	s3,s3,s2
    80002f1c:	0019f993          	andi	s3,s3,1
    80002f20:	00099663          	bnez	s3,80002f2c <syscall+0x64>
      printf("%d: syscall %d -> %d\n",myproc()->pid,num,res);
    }
    p->trapframe->a0 = res;
    80002f24:	74bc                	ld	a5,104(s1)
    80002f26:	0747b823          	sd	s4,112(a5)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002f2a:	a081                	j	80002f6a <syscall+0xa2>
      printf("%d: syscall %d -> %d\n",myproc()->pid,num,res);
    80002f2c:	fffff097          	auipc	ra,0xfffff
    80002f30:	cc8080e7          	jalr	-824(ra) # 80001bf4 <myproc>
    80002f34:	86d2                	mv	a3,s4
    80002f36:	864a                	mv	a2,s2
    80002f38:	590c                	lw	a1,48(a0)
    80002f3a:	00005517          	auipc	a0,0x5
    80002f3e:	5b650513          	addi	a0,a0,1462 # 800084f0 <states.0+0x150>
    80002f42:	ffffd097          	auipc	ra,0xffffd
    80002f46:	632080e7          	jalr	1586(ra) # 80000574 <printf>
    80002f4a:	bfe9                	j	80002f24 <syscall+0x5c>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002f4c:	86ca                	mv	a3,s2
    80002f4e:	16848613          	addi	a2,s1,360
    80002f52:	588c                	lw	a1,48(s1)
    80002f54:	00005517          	auipc	a0,0x5
    80002f58:	5b450513          	addi	a0,a0,1460 # 80008508 <states.0+0x168>
    80002f5c:	ffffd097          	auipc	ra,0xffffd
    80002f60:	618080e7          	jalr	1560(ra) # 80000574 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002f64:	74bc                	ld	a5,104(s1)
    80002f66:	577d                	li	a4,-1
    80002f68:	fbb8                	sd	a4,112(a5)
  }
}
    80002f6a:	70a2                	ld	ra,40(sp)
    80002f6c:	7402                	ld	s0,32(sp)
    80002f6e:	64e2                	ld	s1,24(sp)
    80002f70:	6942                	ld	s2,16(sp)
    80002f72:	69a2                	ld	s3,8(sp)
    80002f74:	6a02                	ld	s4,0(sp)
    80002f76:	6145                	addi	sp,sp,48
    80002f78:	8082                	ret

0000000080002f7a <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002f7a:	1101                	addi	sp,sp,-32
    80002f7c:	ec06                	sd	ra,24(sp)
    80002f7e:	e822                	sd	s0,16(sp)
    80002f80:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002f82:	fec40593          	addi	a1,s0,-20
    80002f86:	4501                	li	a0,0
    80002f88:	00000097          	auipc	ra,0x0
    80002f8c:	ecc080e7          	jalr	-308(ra) # 80002e54 <argint>
    return -1;
    80002f90:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002f92:	00054963          	bltz	a0,80002fa4 <sys_exit+0x2a>
  exit(n);
    80002f96:	fec42503          	lw	a0,-20(s0)
    80002f9a:	fffff097          	auipc	ra,0xfffff
    80002f9e:	726080e7          	jalr	1830(ra) # 800026c0 <exit>
  return 0;  // not reached
    80002fa2:	4781                	li	a5,0
}
    80002fa4:	853e                	mv	a0,a5
    80002fa6:	60e2                	ld	ra,24(sp)
    80002fa8:	6442                	ld	s0,16(sp)
    80002faa:	6105                	addi	sp,sp,32
    80002fac:	8082                	ret

0000000080002fae <sys_getpid>:

uint64
sys_getpid(void)
{
    80002fae:	1141                	addi	sp,sp,-16
    80002fb0:	e406                	sd	ra,8(sp)
    80002fb2:	e022                	sd	s0,0(sp)
    80002fb4:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002fb6:	fffff097          	auipc	ra,0xfffff
    80002fba:	c3e080e7          	jalr	-962(ra) # 80001bf4 <myproc>
}
    80002fbe:	5908                	lw	a0,48(a0)
    80002fc0:	60a2                	ld	ra,8(sp)
    80002fc2:	6402                	ld	s0,0(sp)
    80002fc4:	0141                	addi	sp,sp,16
    80002fc6:	8082                	ret

0000000080002fc8 <sys_fork>:

uint64
sys_fork(void)
{
    80002fc8:	1141                	addi	sp,sp,-16
    80002fca:	e406                	sd	ra,8(sp)
    80002fcc:	e022                	sd	s0,0(sp)
    80002fce:	0800                	addi	s0,sp,16
  return fork();
    80002fd0:	fffff097          	auipc	ra,0xfffff
    80002fd4:	112080e7          	jalr	274(ra) # 800020e2 <fork>
}
    80002fd8:	60a2                	ld	ra,8(sp)
    80002fda:	6402                	ld	s0,0(sp)
    80002fdc:	0141                	addi	sp,sp,16
    80002fde:	8082                	ret

0000000080002fe0 <sys_wait>:

uint64
sys_wait(void)
{
    80002fe0:	1101                	addi	sp,sp,-32
    80002fe2:	ec06                	sd	ra,24(sp)
    80002fe4:	e822                	sd	s0,16(sp)
    80002fe6:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002fe8:	fe840593          	addi	a1,s0,-24
    80002fec:	4501                	li	a0,0
    80002fee:	00000097          	auipc	ra,0x0
    80002ff2:	e88080e7          	jalr	-376(ra) # 80002e76 <argaddr>
    80002ff6:	87aa                	mv	a5,a0
    return -1;
    80002ff8:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002ffa:	0007c863          	bltz	a5,8000300a <sys_wait+0x2a>
  return wait(p);
    80002ffe:	fe843503          	ld	a0,-24(s0)
    80003002:	fffff097          	auipc	ra,0xfffff
    80003006:	4c6080e7          	jalr	1222(ra) # 800024c8 <wait>
}
    8000300a:	60e2                	ld	ra,24(sp)
    8000300c:	6442                	ld	s0,16(sp)
    8000300e:	6105                	addi	sp,sp,32
    80003010:	8082                	ret

0000000080003012 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80003012:	7179                	addi	sp,sp,-48
    80003014:	f406                	sd	ra,40(sp)
    80003016:	f022                	sd	s0,32(sp)
    80003018:	ec26                	sd	s1,24(sp)
    8000301a:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    8000301c:	fdc40593          	addi	a1,s0,-36
    80003020:	4501                	li	a0,0
    80003022:	00000097          	auipc	ra,0x0
    80003026:	e32080e7          	jalr	-462(ra) # 80002e54 <argint>
    return -1;
    8000302a:	54fd                	li	s1,-1
  if(argint(0, &n) < 0)
    8000302c:	00054f63          	bltz	a0,8000304a <sys_sbrk+0x38>
  addr = myproc()->sz;
    80003030:	fffff097          	auipc	ra,0xfffff
    80003034:	bc4080e7          	jalr	-1084(ra) # 80001bf4 <myproc>
    80003038:	4924                	lw	s1,80(a0)
  if(growproc(n) < 0)
    8000303a:	fdc42503          	lw	a0,-36(s0)
    8000303e:	fffff097          	auipc	ra,0xfffff
    80003042:	fd0080e7          	jalr	-48(ra) # 8000200e <growproc>
    80003046:	00054863          	bltz	a0,80003056 <sys_sbrk+0x44>
    return -1;
  return addr;
}
    8000304a:	8526                	mv	a0,s1
    8000304c:	70a2                	ld	ra,40(sp)
    8000304e:	7402                	ld	s0,32(sp)
    80003050:	64e2                	ld	s1,24(sp)
    80003052:	6145                	addi	sp,sp,48
    80003054:	8082                	ret
    return -1;
    80003056:	54fd                	li	s1,-1
    80003058:	bfcd                	j	8000304a <sys_sbrk+0x38>

000000008000305a <sys_trace>:



u64 sys_trace(void){
    8000305a:	1101                	addi	sp,sp,-32
    8000305c:	ec06                	sd	ra,24(sp)
    8000305e:	e822                	sd	s0,16(sp)
    80003060:	1000                	addi	s0,sp,32
  i32 traced;
  if (argint(0, &traced) < 0)
    80003062:	fec40593          	addi	a1,s0,-20
    80003066:	4501                	li	a0,0
    80003068:	00000097          	auipc	ra,0x0
    8000306c:	dec080e7          	jalr	-532(ra) # 80002e54 <argint>
    80003070:	87aa                	mv	a5,a0
    return -1;
    80003072:	557d                	li	a0,-1
  if (argint(0, &traced) < 0)
    80003074:	0007c863          	bltz	a5,80003084 <sys_trace+0x2a>
  return trace(traced);
    80003078:	fec42503          	lw	a0,-20(s0)
    8000307c:	fffff097          	auipc	ra,0xfffff
    80003080:	040080e7          	jalr	64(ra) # 800020bc <trace>
}
    80003084:	60e2                	ld	ra,24(sp)
    80003086:	6442                	ld	s0,16(sp)
    80003088:	6105                	addi	sp,sp,32
    8000308a:	8082                	ret

000000008000308c <sys_sleep>:

uint64
sys_sleep(void)
{
    8000308c:	7139                	addi	sp,sp,-64
    8000308e:	fc06                	sd	ra,56(sp)
    80003090:	f822                	sd	s0,48(sp)
    80003092:	f426                	sd	s1,40(sp)
    80003094:	f04a                	sd	s2,32(sp)
    80003096:	ec4e                	sd	s3,24(sp)
    80003098:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    8000309a:	fcc40593          	addi	a1,s0,-52
    8000309e:	4501                	li	a0,0
    800030a0:	00000097          	auipc	ra,0x0
    800030a4:	db4080e7          	jalr	-588(ra) # 80002e54 <argint>
    return -1;
    800030a8:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800030aa:	06054563          	bltz	a0,80003114 <sys_sleep+0x88>
  acquire(&tickslock);
    800030ae:	00014517          	auipc	a0,0x14
    800030b2:	42250513          	addi	a0,a0,1058 # 800174d0 <tickslock>
    800030b6:	ffffe097          	auipc	ra,0xffffe
    800030ba:	b0c080e7          	jalr	-1268(ra) # 80000bc2 <acquire>
  ticks0 = ticks;
    800030be:	00006917          	auipc	s2,0x6
    800030c2:	f7292903          	lw	s2,-142(s2) # 80009030 <ticks>
  while(ticks - ticks0 < n){
    800030c6:	fcc42783          	lw	a5,-52(s0)
    800030ca:	cf85                	beqz	a5,80003102 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800030cc:	00014997          	auipc	s3,0x14
    800030d0:	40498993          	addi	s3,s3,1028 # 800174d0 <tickslock>
    800030d4:	00006497          	auipc	s1,0x6
    800030d8:	f5c48493          	addi	s1,s1,-164 # 80009030 <ticks>
    if(myproc()->killed){
    800030dc:	fffff097          	auipc	ra,0xfffff
    800030e0:	b18080e7          	jalr	-1256(ra) # 80001bf4 <myproc>
    800030e4:	551c                	lw	a5,40(a0)
    800030e6:	ef9d                	bnez	a5,80003124 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800030e8:	85ce                	mv	a1,s3
    800030ea:	8526                	mv	a0,s1
    800030ec:	fffff097          	auipc	ra,0xfffff
    800030f0:	378080e7          	jalr	888(ra) # 80002464 <sleep>
  while(ticks - ticks0 < n){
    800030f4:	409c                	lw	a5,0(s1)
    800030f6:	412787bb          	subw	a5,a5,s2
    800030fa:	fcc42703          	lw	a4,-52(s0)
    800030fe:	fce7efe3          	bltu	a5,a4,800030dc <sys_sleep+0x50>
  }
  release(&tickslock);
    80003102:	00014517          	auipc	a0,0x14
    80003106:	3ce50513          	addi	a0,a0,974 # 800174d0 <tickslock>
    8000310a:	ffffe097          	auipc	ra,0xffffe
    8000310e:	b6c080e7          	jalr	-1172(ra) # 80000c76 <release>
  return 0;
    80003112:	4781                	li	a5,0
}
    80003114:	853e                	mv	a0,a5
    80003116:	70e2                	ld	ra,56(sp)
    80003118:	7442                	ld	s0,48(sp)
    8000311a:	74a2                	ld	s1,40(sp)
    8000311c:	7902                	ld	s2,32(sp)
    8000311e:	69e2                	ld	s3,24(sp)
    80003120:	6121                	addi	sp,sp,64
    80003122:	8082                	ret
      release(&tickslock);
    80003124:	00014517          	auipc	a0,0x14
    80003128:	3ac50513          	addi	a0,a0,940 # 800174d0 <tickslock>
    8000312c:	ffffe097          	auipc	ra,0xffffe
    80003130:	b4a080e7          	jalr	-1206(ra) # 80000c76 <release>
      return -1;
    80003134:	57fd                	li	a5,-1
    80003136:	bff9                	j	80003114 <sys_sleep+0x88>

0000000080003138 <sys_kill>:

uint64
sys_kill(void)
{
    80003138:	1101                	addi	sp,sp,-32
    8000313a:	ec06                	sd	ra,24(sp)
    8000313c:	e822                	sd	s0,16(sp)
    8000313e:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80003140:	fec40593          	addi	a1,s0,-20
    80003144:	4501                	li	a0,0
    80003146:	00000097          	auipc	ra,0x0
    8000314a:	d0e080e7          	jalr	-754(ra) # 80002e54 <argint>
    8000314e:	87aa                	mv	a5,a0
    return -1;
    80003150:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80003152:	0007c863          	bltz	a5,80003162 <sys_kill+0x2a>
  return kill(pid);
    80003156:	fec42503          	lw	a0,-20(s0)
    8000315a:	fffff097          	auipc	ra,0xfffff
    8000315e:	63c080e7          	jalr	1596(ra) # 80002796 <kill>
}
    80003162:	60e2                	ld	ra,24(sp)
    80003164:	6442                	ld	s0,16(sp)
    80003166:	6105                	addi	sp,sp,32
    80003168:	8082                	ret

000000008000316a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000316a:	1101                	addi	sp,sp,-32
    8000316c:	ec06                	sd	ra,24(sp)
    8000316e:	e822                	sd	s0,16(sp)
    80003170:	e426                	sd	s1,8(sp)
    80003172:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80003174:	00014517          	auipc	a0,0x14
    80003178:	35c50513          	addi	a0,a0,860 # 800174d0 <tickslock>
    8000317c:	ffffe097          	auipc	ra,0xffffe
    80003180:	a46080e7          	jalr	-1466(ra) # 80000bc2 <acquire>
  xticks = ticks;
    80003184:	00006497          	auipc	s1,0x6
    80003188:	eac4a483          	lw	s1,-340(s1) # 80009030 <ticks>
  release(&tickslock);
    8000318c:	00014517          	auipc	a0,0x14
    80003190:	34450513          	addi	a0,a0,836 # 800174d0 <tickslock>
    80003194:	ffffe097          	auipc	ra,0xffffe
    80003198:	ae2080e7          	jalr	-1310(ra) # 80000c76 <release>
  return xticks;
}
    8000319c:	02049513          	slli	a0,s1,0x20
    800031a0:	9101                	srli	a0,a0,0x20
    800031a2:	60e2                	ld	ra,24(sp)
    800031a4:	6442                	ld	s0,16(sp)
    800031a6:	64a2                	ld	s1,8(sp)
    800031a8:	6105                	addi	sp,sp,32
    800031aa:	8082                	ret

00000000800031ac <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800031ac:	7179                	addi	sp,sp,-48
    800031ae:	f406                	sd	ra,40(sp)
    800031b0:	f022                	sd	s0,32(sp)
    800031b2:	ec26                	sd	s1,24(sp)
    800031b4:	e84a                	sd	s2,16(sp)
    800031b6:	e44e                	sd	s3,8(sp)
    800031b8:	e052                	sd	s4,0(sp)
    800031ba:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800031bc:	00005597          	auipc	a1,0x5
    800031c0:	43c58593          	addi	a1,a1,1084 # 800085f8 <syscalls+0xb8>
    800031c4:	00014517          	auipc	a0,0x14
    800031c8:	32450513          	addi	a0,a0,804 # 800174e8 <bcache>
    800031cc:	ffffe097          	auipc	ra,0xffffe
    800031d0:	966080e7          	jalr	-1690(ra) # 80000b32 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800031d4:	0001c797          	auipc	a5,0x1c
    800031d8:	31478793          	addi	a5,a5,788 # 8001f4e8 <bcache+0x8000>
    800031dc:	0001c717          	auipc	a4,0x1c
    800031e0:	57470713          	addi	a4,a4,1396 # 8001f750 <bcache+0x8268>
    800031e4:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800031e8:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800031ec:	00014497          	auipc	s1,0x14
    800031f0:	31448493          	addi	s1,s1,788 # 80017500 <bcache+0x18>
    b->next = bcache.head.next;
    800031f4:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800031f6:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800031f8:	00005a17          	auipc	s4,0x5
    800031fc:	408a0a13          	addi	s4,s4,1032 # 80008600 <syscalls+0xc0>
    b->next = bcache.head.next;
    80003200:	2b893783          	ld	a5,696(s2)
    80003204:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003206:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000320a:	85d2                	mv	a1,s4
    8000320c:	01048513          	addi	a0,s1,16
    80003210:	00001097          	auipc	ra,0x1
    80003214:	4bc080e7          	jalr	1212(ra) # 800046cc <initsleeplock>
    bcache.head.next->prev = b;
    80003218:	2b893783          	ld	a5,696(s2)
    8000321c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000321e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003222:	45848493          	addi	s1,s1,1112
    80003226:	fd349de3          	bne	s1,s3,80003200 <binit+0x54>
  }
}
    8000322a:	70a2                	ld	ra,40(sp)
    8000322c:	7402                	ld	s0,32(sp)
    8000322e:	64e2                	ld	s1,24(sp)
    80003230:	6942                	ld	s2,16(sp)
    80003232:	69a2                	ld	s3,8(sp)
    80003234:	6a02                	ld	s4,0(sp)
    80003236:	6145                	addi	sp,sp,48
    80003238:	8082                	ret

000000008000323a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000323a:	7179                	addi	sp,sp,-48
    8000323c:	f406                	sd	ra,40(sp)
    8000323e:	f022                	sd	s0,32(sp)
    80003240:	ec26                	sd	s1,24(sp)
    80003242:	e84a                	sd	s2,16(sp)
    80003244:	e44e                	sd	s3,8(sp)
    80003246:	1800                	addi	s0,sp,48
    80003248:	892a                	mv	s2,a0
    8000324a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000324c:	00014517          	auipc	a0,0x14
    80003250:	29c50513          	addi	a0,a0,668 # 800174e8 <bcache>
    80003254:	ffffe097          	auipc	ra,0xffffe
    80003258:	96e080e7          	jalr	-1682(ra) # 80000bc2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000325c:	0001c497          	auipc	s1,0x1c
    80003260:	5444b483          	ld	s1,1348(s1) # 8001f7a0 <bcache+0x82b8>
    80003264:	0001c797          	auipc	a5,0x1c
    80003268:	4ec78793          	addi	a5,a5,1260 # 8001f750 <bcache+0x8268>
    8000326c:	02f48f63          	beq	s1,a5,800032aa <bread+0x70>
    80003270:	873e                	mv	a4,a5
    80003272:	a021                	j	8000327a <bread+0x40>
    80003274:	68a4                	ld	s1,80(s1)
    80003276:	02e48a63          	beq	s1,a4,800032aa <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000327a:	449c                	lw	a5,8(s1)
    8000327c:	ff279ce3          	bne	a5,s2,80003274 <bread+0x3a>
    80003280:	44dc                	lw	a5,12(s1)
    80003282:	ff3799e3          	bne	a5,s3,80003274 <bread+0x3a>
      b->refcnt++;
    80003286:	40bc                	lw	a5,64(s1)
    80003288:	2785                	addiw	a5,a5,1
    8000328a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000328c:	00014517          	auipc	a0,0x14
    80003290:	25c50513          	addi	a0,a0,604 # 800174e8 <bcache>
    80003294:	ffffe097          	auipc	ra,0xffffe
    80003298:	9e2080e7          	jalr	-1566(ra) # 80000c76 <release>
      acquiresleep(&b->lock);
    8000329c:	01048513          	addi	a0,s1,16
    800032a0:	00001097          	auipc	ra,0x1
    800032a4:	466080e7          	jalr	1126(ra) # 80004706 <acquiresleep>
      return b;
    800032a8:	a8b9                	j	80003306 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800032aa:	0001c497          	auipc	s1,0x1c
    800032ae:	4ee4b483          	ld	s1,1262(s1) # 8001f798 <bcache+0x82b0>
    800032b2:	0001c797          	auipc	a5,0x1c
    800032b6:	49e78793          	addi	a5,a5,1182 # 8001f750 <bcache+0x8268>
    800032ba:	00f48863          	beq	s1,a5,800032ca <bread+0x90>
    800032be:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800032c0:	40bc                	lw	a5,64(s1)
    800032c2:	cf81                	beqz	a5,800032da <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800032c4:	64a4                	ld	s1,72(s1)
    800032c6:	fee49de3          	bne	s1,a4,800032c0 <bread+0x86>
  panic("bget: no buffers");
    800032ca:	00005517          	auipc	a0,0x5
    800032ce:	33e50513          	addi	a0,a0,830 # 80008608 <syscalls+0xc8>
    800032d2:	ffffd097          	auipc	ra,0xffffd
    800032d6:	258080e7          	jalr	600(ra) # 8000052a <panic>
      b->dev = dev;
    800032da:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800032de:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800032e2:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800032e6:	4785                	li	a5,1
    800032e8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800032ea:	00014517          	auipc	a0,0x14
    800032ee:	1fe50513          	addi	a0,a0,510 # 800174e8 <bcache>
    800032f2:	ffffe097          	auipc	ra,0xffffe
    800032f6:	984080e7          	jalr	-1660(ra) # 80000c76 <release>
      acquiresleep(&b->lock);
    800032fa:	01048513          	addi	a0,s1,16
    800032fe:	00001097          	auipc	ra,0x1
    80003302:	408080e7          	jalr	1032(ra) # 80004706 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003306:	409c                	lw	a5,0(s1)
    80003308:	cb89                	beqz	a5,8000331a <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000330a:	8526                	mv	a0,s1
    8000330c:	70a2                	ld	ra,40(sp)
    8000330e:	7402                	ld	s0,32(sp)
    80003310:	64e2                	ld	s1,24(sp)
    80003312:	6942                	ld	s2,16(sp)
    80003314:	69a2                	ld	s3,8(sp)
    80003316:	6145                	addi	sp,sp,48
    80003318:	8082                	ret
    virtio_disk_rw(b, 0);
    8000331a:	4581                	li	a1,0
    8000331c:	8526                	mv	a0,s1
    8000331e:	00003097          	auipc	ra,0x3
    80003322:	f58080e7          	jalr	-168(ra) # 80006276 <virtio_disk_rw>
    b->valid = 1;
    80003326:	4785                	li	a5,1
    80003328:	c09c                	sw	a5,0(s1)
  return b;
    8000332a:	b7c5                	j	8000330a <bread+0xd0>

000000008000332c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000332c:	1101                	addi	sp,sp,-32
    8000332e:	ec06                	sd	ra,24(sp)
    80003330:	e822                	sd	s0,16(sp)
    80003332:	e426                	sd	s1,8(sp)
    80003334:	1000                	addi	s0,sp,32
    80003336:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003338:	0541                	addi	a0,a0,16
    8000333a:	00001097          	auipc	ra,0x1
    8000333e:	466080e7          	jalr	1126(ra) # 800047a0 <holdingsleep>
    80003342:	cd01                	beqz	a0,8000335a <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003344:	4585                	li	a1,1
    80003346:	8526                	mv	a0,s1
    80003348:	00003097          	auipc	ra,0x3
    8000334c:	f2e080e7          	jalr	-210(ra) # 80006276 <virtio_disk_rw>
}
    80003350:	60e2                	ld	ra,24(sp)
    80003352:	6442                	ld	s0,16(sp)
    80003354:	64a2                	ld	s1,8(sp)
    80003356:	6105                	addi	sp,sp,32
    80003358:	8082                	ret
    panic("bwrite");
    8000335a:	00005517          	auipc	a0,0x5
    8000335e:	2c650513          	addi	a0,a0,710 # 80008620 <syscalls+0xe0>
    80003362:	ffffd097          	auipc	ra,0xffffd
    80003366:	1c8080e7          	jalr	456(ra) # 8000052a <panic>

000000008000336a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000336a:	1101                	addi	sp,sp,-32
    8000336c:	ec06                	sd	ra,24(sp)
    8000336e:	e822                	sd	s0,16(sp)
    80003370:	e426                	sd	s1,8(sp)
    80003372:	e04a                	sd	s2,0(sp)
    80003374:	1000                	addi	s0,sp,32
    80003376:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003378:	01050913          	addi	s2,a0,16
    8000337c:	854a                	mv	a0,s2
    8000337e:	00001097          	auipc	ra,0x1
    80003382:	422080e7          	jalr	1058(ra) # 800047a0 <holdingsleep>
    80003386:	c92d                	beqz	a0,800033f8 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80003388:	854a                	mv	a0,s2
    8000338a:	00001097          	auipc	ra,0x1
    8000338e:	3d2080e7          	jalr	978(ra) # 8000475c <releasesleep>

  acquire(&bcache.lock);
    80003392:	00014517          	auipc	a0,0x14
    80003396:	15650513          	addi	a0,a0,342 # 800174e8 <bcache>
    8000339a:	ffffe097          	auipc	ra,0xffffe
    8000339e:	828080e7          	jalr	-2008(ra) # 80000bc2 <acquire>
  b->refcnt--;
    800033a2:	40bc                	lw	a5,64(s1)
    800033a4:	37fd                	addiw	a5,a5,-1
    800033a6:	0007871b          	sext.w	a4,a5
    800033aa:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800033ac:	eb05                	bnez	a4,800033dc <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800033ae:	68bc                	ld	a5,80(s1)
    800033b0:	64b8                	ld	a4,72(s1)
    800033b2:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800033b4:	64bc                	ld	a5,72(s1)
    800033b6:	68b8                	ld	a4,80(s1)
    800033b8:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800033ba:	0001c797          	auipc	a5,0x1c
    800033be:	12e78793          	addi	a5,a5,302 # 8001f4e8 <bcache+0x8000>
    800033c2:	2b87b703          	ld	a4,696(a5)
    800033c6:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800033c8:	0001c717          	auipc	a4,0x1c
    800033cc:	38870713          	addi	a4,a4,904 # 8001f750 <bcache+0x8268>
    800033d0:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800033d2:	2b87b703          	ld	a4,696(a5)
    800033d6:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800033d8:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800033dc:	00014517          	auipc	a0,0x14
    800033e0:	10c50513          	addi	a0,a0,268 # 800174e8 <bcache>
    800033e4:	ffffe097          	auipc	ra,0xffffe
    800033e8:	892080e7          	jalr	-1902(ra) # 80000c76 <release>
}
    800033ec:	60e2                	ld	ra,24(sp)
    800033ee:	6442                	ld	s0,16(sp)
    800033f0:	64a2                	ld	s1,8(sp)
    800033f2:	6902                	ld	s2,0(sp)
    800033f4:	6105                	addi	sp,sp,32
    800033f6:	8082                	ret
    panic("brelse");
    800033f8:	00005517          	auipc	a0,0x5
    800033fc:	23050513          	addi	a0,a0,560 # 80008628 <syscalls+0xe8>
    80003400:	ffffd097          	auipc	ra,0xffffd
    80003404:	12a080e7          	jalr	298(ra) # 8000052a <panic>

0000000080003408 <bpin>:

void
bpin(struct buf *b) {
    80003408:	1101                	addi	sp,sp,-32
    8000340a:	ec06                	sd	ra,24(sp)
    8000340c:	e822                	sd	s0,16(sp)
    8000340e:	e426                	sd	s1,8(sp)
    80003410:	1000                	addi	s0,sp,32
    80003412:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003414:	00014517          	auipc	a0,0x14
    80003418:	0d450513          	addi	a0,a0,212 # 800174e8 <bcache>
    8000341c:	ffffd097          	auipc	ra,0xffffd
    80003420:	7a6080e7          	jalr	1958(ra) # 80000bc2 <acquire>
  b->refcnt++;
    80003424:	40bc                	lw	a5,64(s1)
    80003426:	2785                	addiw	a5,a5,1
    80003428:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000342a:	00014517          	auipc	a0,0x14
    8000342e:	0be50513          	addi	a0,a0,190 # 800174e8 <bcache>
    80003432:	ffffe097          	auipc	ra,0xffffe
    80003436:	844080e7          	jalr	-1980(ra) # 80000c76 <release>
}
    8000343a:	60e2                	ld	ra,24(sp)
    8000343c:	6442                	ld	s0,16(sp)
    8000343e:	64a2                	ld	s1,8(sp)
    80003440:	6105                	addi	sp,sp,32
    80003442:	8082                	ret

0000000080003444 <bunpin>:

void
bunpin(struct buf *b) {
    80003444:	1101                	addi	sp,sp,-32
    80003446:	ec06                	sd	ra,24(sp)
    80003448:	e822                	sd	s0,16(sp)
    8000344a:	e426                	sd	s1,8(sp)
    8000344c:	1000                	addi	s0,sp,32
    8000344e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003450:	00014517          	auipc	a0,0x14
    80003454:	09850513          	addi	a0,a0,152 # 800174e8 <bcache>
    80003458:	ffffd097          	auipc	ra,0xffffd
    8000345c:	76a080e7          	jalr	1898(ra) # 80000bc2 <acquire>
  b->refcnt--;
    80003460:	40bc                	lw	a5,64(s1)
    80003462:	37fd                	addiw	a5,a5,-1
    80003464:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003466:	00014517          	auipc	a0,0x14
    8000346a:	08250513          	addi	a0,a0,130 # 800174e8 <bcache>
    8000346e:	ffffe097          	auipc	ra,0xffffe
    80003472:	808080e7          	jalr	-2040(ra) # 80000c76 <release>
}
    80003476:	60e2                	ld	ra,24(sp)
    80003478:	6442                	ld	s0,16(sp)
    8000347a:	64a2                	ld	s1,8(sp)
    8000347c:	6105                	addi	sp,sp,32
    8000347e:	8082                	ret

0000000080003480 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003480:	1101                	addi	sp,sp,-32
    80003482:	ec06                	sd	ra,24(sp)
    80003484:	e822                	sd	s0,16(sp)
    80003486:	e426                	sd	s1,8(sp)
    80003488:	e04a                	sd	s2,0(sp)
    8000348a:	1000                	addi	s0,sp,32
    8000348c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000348e:	00d5d59b          	srliw	a1,a1,0xd
    80003492:	0001c797          	auipc	a5,0x1c
    80003496:	7327a783          	lw	a5,1842(a5) # 8001fbc4 <sb+0x1c>
    8000349a:	9dbd                	addw	a1,a1,a5
    8000349c:	00000097          	auipc	ra,0x0
    800034a0:	d9e080e7          	jalr	-610(ra) # 8000323a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800034a4:	0074f713          	andi	a4,s1,7
    800034a8:	4785                	li	a5,1
    800034aa:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800034ae:	14ce                	slli	s1,s1,0x33
    800034b0:	90d9                	srli	s1,s1,0x36
    800034b2:	00950733          	add	a4,a0,s1
    800034b6:	05874703          	lbu	a4,88(a4)
    800034ba:	00e7f6b3          	and	a3,a5,a4
    800034be:	c69d                	beqz	a3,800034ec <bfree+0x6c>
    800034c0:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800034c2:	94aa                	add	s1,s1,a0
    800034c4:	fff7c793          	not	a5,a5
    800034c8:	8ff9                	and	a5,a5,a4
    800034ca:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800034ce:	00001097          	auipc	ra,0x1
    800034d2:	118080e7          	jalr	280(ra) # 800045e6 <log_write>
  brelse(bp);
    800034d6:	854a                	mv	a0,s2
    800034d8:	00000097          	auipc	ra,0x0
    800034dc:	e92080e7          	jalr	-366(ra) # 8000336a <brelse>
}
    800034e0:	60e2                	ld	ra,24(sp)
    800034e2:	6442                	ld	s0,16(sp)
    800034e4:	64a2                	ld	s1,8(sp)
    800034e6:	6902                	ld	s2,0(sp)
    800034e8:	6105                	addi	sp,sp,32
    800034ea:	8082                	ret
    panic("freeing free block");
    800034ec:	00005517          	auipc	a0,0x5
    800034f0:	14450513          	addi	a0,a0,324 # 80008630 <syscalls+0xf0>
    800034f4:	ffffd097          	auipc	ra,0xffffd
    800034f8:	036080e7          	jalr	54(ra) # 8000052a <panic>

00000000800034fc <balloc>:
{
    800034fc:	711d                	addi	sp,sp,-96
    800034fe:	ec86                	sd	ra,88(sp)
    80003500:	e8a2                	sd	s0,80(sp)
    80003502:	e4a6                	sd	s1,72(sp)
    80003504:	e0ca                	sd	s2,64(sp)
    80003506:	fc4e                	sd	s3,56(sp)
    80003508:	f852                	sd	s4,48(sp)
    8000350a:	f456                	sd	s5,40(sp)
    8000350c:	f05a                	sd	s6,32(sp)
    8000350e:	ec5e                	sd	s7,24(sp)
    80003510:	e862                	sd	s8,16(sp)
    80003512:	e466                	sd	s9,8(sp)
    80003514:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003516:	0001c797          	auipc	a5,0x1c
    8000351a:	6967a783          	lw	a5,1686(a5) # 8001fbac <sb+0x4>
    8000351e:	cbd1                	beqz	a5,800035b2 <balloc+0xb6>
    80003520:	8baa                	mv	s7,a0
    80003522:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003524:	0001cb17          	auipc	s6,0x1c
    80003528:	684b0b13          	addi	s6,s6,1668 # 8001fba8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000352c:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000352e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003530:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003532:	6c89                	lui	s9,0x2
    80003534:	a831                	j	80003550 <balloc+0x54>
    brelse(bp);
    80003536:	854a                	mv	a0,s2
    80003538:	00000097          	auipc	ra,0x0
    8000353c:	e32080e7          	jalr	-462(ra) # 8000336a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003540:	015c87bb          	addw	a5,s9,s5
    80003544:	00078a9b          	sext.w	s5,a5
    80003548:	004b2703          	lw	a4,4(s6)
    8000354c:	06eaf363          	bgeu	s5,a4,800035b2 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80003550:	41fad79b          	sraiw	a5,s5,0x1f
    80003554:	0137d79b          	srliw	a5,a5,0x13
    80003558:	015787bb          	addw	a5,a5,s5
    8000355c:	40d7d79b          	sraiw	a5,a5,0xd
    80003560:	01cb2583          	lw	a1,28(s6)
    80003564:	9dbd                	addw	a1,a1,a5
    80003566:	855e                	mv	a0,s7
    80003568:	00000097          	auipc	ra,0x0
    8000356c:	cd2080e7          	jalr	-814(ra) # 8000323a <bread>
    80003570:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003572:	004b2503          	lw	a0,4(s6)
    80003576:	000a849b          	sext.w	s1,s5
    8000357a:	8662                	mv	a2,s8
    8000357c:	faa4fde3          	bgeu	s1,a0,80003536 <balloc+0x3a>
      m = 1 << (bi % 8);
    80003580:	41f6579b          	sraiw	a5,a2,0x1f
    80003584:	01d7d69b          	srliw	a3,a5,0x1d
    80003588:	00c6873b          	addw	a4,a3,a2
    8000358c:	00777793          	andi	a5,a4,7
    80003590:	9f95                	subw	a5,a5,a3
    80003592:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003596:	4037571b          	sraiw	a4,a4,0x3
    8000359a:	00e906b3          	add	a3,s2,a4
    8000359e:	0586c683          	lbu	a3,88(a3)
    800035a2:	00d7f5b3          	and	a1,a5,a3
    800035a6:	cd91                	beqz	a1,800035c2 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800035a8:	2605                	addiw	a2,a2,1
    800035aa:	2485                	addiw	s1,s1,1
    800035ac:	fd4618e3          	bne	a2,s4,8000357c <balloc+0x80>
    800035b0:	b759                	j	80003536 <balloc+0x3a>
  panic("balloc: out of blocks");
    800035b2:	00005517          	auipc	a0,0x5
    800035b6:	09650513          	addi	a0,a0,150 # 80008648 <syscalls+0x108>
    800035ba:	ffffd097          	auipc	ra,0xffffd
    800035be:	f70080e7          	jalr	-144(ra) # 8000052a <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800035c2:	974a                	add	a4,a4,s2
    800035c4:	8fd5                	or	a5,a5,a3
    800035c6:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800035ca:	854a                	mv	a0,s2
    800035cc:	00001097          	auipc	ra,0x1
    800035d0:	01a080e7          	jalr	26(ra) # 800045e6 <log_write>
        brelse(bp);
    800035d4:	854a                	mv	a0,s2
    800035d6:	00000097          	auipc	ra,0x0
    800035da:	d94080e7          	jalr	-620(ra) # 8000336a <brelse>
  bp = bread(dev, bno);
    800035de:	85a6                	mv	a1,s1
    800035e0:	855e                	mv	a0,s7
    800035e2:	00000097          	auipc	ra,0x0
    800035e6:	c58080e7          	jalr	-936(ra) # 8000323a <bread>
    800035ea:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800035ec:	40000613          	li	a2,1024
    800035f0:	4581                	li	a1,0
    800035f2:	05850513          	addi	a0,a0,88
    800035f6:	ffffd097          	auipc	ra,0xffffd
    800035fa:	6c8080e7          	jalr	1736(ra) # 80000cbe <memset>
  log_write(bp);
    800035fe:	854a                	mv	a0,s2
    80003600:	00001097          	auipc	ra,0x1
    80003604:	fe6080e7          	jalr	-26(ra) # 800045e6 <log_write>
  brelse(bp);
    80003608:	854a                	mv	a0,s2
    8000360a:	00000097          	auipc	ra,0x0
    8000360e:	d60080e7          	jalr	-672(ra) # 8000336a <brelse>
}
    80003612:	8526                	mv	a0,s1
    80003614:	60e6                	ld	ra,88(sp)
    80003616:	6446                	ld	s0,80(sp)
    80003618:	64a6                	ld	s1,72(sp)
    8000361a:	6906                	ld	s2,64(sp)
    8000361c:	79e2                	ld	s3,56(sp)
    8000361e:	7a42                	ld	s4,48(sp)
    80003620:	7aa2                	ld	s5,40(sp)
    80003622:	7b02                	ld	s6,32(sp)
    80003624:	6be2                	ld	s7,24(sp)
    80003626:	6c42                	ld	s8,16(sp)
    80003628:	6ca2                	ld	s9,8(sp)
    8000362a:	6125                	addi	sp,sp,96
    8000362c:	8082                	ret

000000008000362e <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000362e:	7179                	addi	sp,sp,-48
    80003630:	f406                	sd	ra,40(sp)
    80003632:	f022                	sd	s0,32(sp)
    80003634:	ec26                	sd	s1,24(sp)
    80003636:	e84a                	sd	s2,16(sp)
    80003638:	e44e                	sd	s3,8(sp)
    8000363a:	e052                	sd	s4,0(sp)
    8000363c:	1800                	addi	s0,sp,48
    8000363e:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003640:	47ad                	li	a5,11
    80003642:	04b7fe63          	bgeu	a5,a1,8000369e <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80003646:	ff45849b          	addiw	s1,a1,-12
    8000364a:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000364e:	0ff00793          	li	a5,255
    80003652:	0ae7e363          	bltu	a5,a4,800036f8 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80003656:	08052583          	lw	a1,128(a0)
    8000365a:	c5ad                	beqz	a1,800036c4 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    8000365c:	00092503          	lw	a0,0(s2)
    80003660:	00000097          	auipc	ra,0x0
    80003664:	bda080e7          	jalr	-1062(ra) # 8000323a <bread>
    80003668:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000366a:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000366e:	02049593          	slli	a1,s1,0x20
    80003672:	9181                	srli	a1,a1,0x20
    80003674:	058a                	slli	a1,a1,0x2
    80003676:	00b784b3          	add	s1,a5,a1
    8000367a:	0004a983          	lw	s3,0(s1)
    8000367e:	04098d63          	beqz	s3,800036d8 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80003682:	8552                	mv	a0,s4
    80003684:	00000097          	auipc	ra,0x0
    80003688:	ce6080e7          	jalr	-794(ra) # 8000336a <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000368c:	854e                	mv	a0,s3
    8000368e:	70a2                	ld	ra,40(sp)
    80003690:	7402                	ld	s0,32(sp)
    80003692:	64e2                	ld	s1,24(sp)
    80003694:	6942                	ld	s2,16(sp)
    80003696:	69a2                	ld	s3,8(sp)
    80003698:	6a02                	ld	s4,0(sp)
    8000369a:	6145                	addi	sp,sp,48
    8000369c:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000369e:	02059493          	slli	s1,a1,0x20
    800036a2:	9081                	srli	s1,s1,0x20
    800036a4:	048a                	slli	s1,s1,0x2
    800036a6:	94aa                	add	s1,s1,a0
    800036a8:	0504a983          	lw	s3,80(s1)
    800036ac:	fe0990e3          	bnez	s3,8000368c <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800036b0:	4108                	lw	a0,0(a0)
    800036b2:	00000097          	auipc	ra,0x0
    800036b6:	e4a080e7          	jalr	-438(ra) # 800034fc <balloc>
    800036ba:	0005099b          	sext.w	s3,a0
    800036be:	0534a823          	sw	s3,80(s1)
    800036c2:	b7e9                	j	8000368c <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800036c4:	4108                	lw	a0,0(a0)
    800036c6:	00000097          	auipc	ra,0x0
    800036ca:	e36080e7          	jalr	-458(ra) # 800034fc <balloc>
    800036ce:	0005059b          	sext.w	a1,a0
    800036d2:	08b92023          	sw	a1,128(s2)
    800036d6:	b759                	j	8000365c <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800036d8:	00092503          	lw	a0,0(s2)
    800036dc:	00000097          	auipc	ra,0x0
    800036e0:	e20080e7          	jalr	-480(ra) # 800034fc <balloc>
    800036e4:	0005099b          	sext.w	s3,a0
    800036e8:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800036ec:	8552                	mv	a0,s4
    800036ee:	00001097          	auipc	ra,0x1
    800036f2:	ef8080e7          	jalr	-264(ra) # 800045e6 <log_write>
    800036f6:	b771                	j	80003682 <bmap+0x54>
  panic("bmap: out of range");
    800036f8:	00005517          	auipc	a0,0x5
    800036fc:	f6850513          	addi	a0,a0,-152 # 80008660 <syscalls+0x120>
    80003700:	ffffd097          	auipc	ra,0xffffd
    80003704:	e2a080e7          	jalr	-470(ra) # 8000052a <panic>

0000000080003708 <iget>:
{
    80003708:	7179                	addi	sp,sp,-48
    8000370a:	f406                	sd	ra,40(sp)
    8000370c:	f022                	sd	s0,32(sp)
    8000370e:	ec26                	sd	s1,24(sp)
    80003710:	e84a                	sd	s2,16(sp)
    80003712:	e44e                	sd	s3,8(sp)
    80003714:	e052                	sd	s4,0(sp)
    80003716:	1800                	addi	s0,sp,48
    80003718:	89aa                	mv	s3,a0
    8000371a:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000371c:	0001c517          	auipc	a0,0x1c
    80003720:	4ac50513          	addi	a0,a0,1196 # 8001fbc8 <itable>
    80003724:	ffffd097          	auipc	ra,0xffffd
    80003728:	49e080e7          	jalr	1182(ra) # 80000bc2 <acquire>
  empty = 0;
    8000372c:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000372e:	0001c497          	auipc	s1,0x1c
    80003732:	4b248493          	addi	s1,s1,1202 # 8001fbe0 <itable+0x18>
    80003736:	0001e697          	auipc	a3,0x1e
    8000373a:	f3a68693          	addi	a3,a3,-198 # 80021670 <log>
    8000373e:	a039                	j	8000374c <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003740:	02090b63          	beqz	s2,80003776 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003744:	08848493          	addi	s1,s1,136
    80003748:	02d48a63          	beq	s1,a3,8000377c <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000374c:	449c                	lw	a5,8(s1)
    8000374e:	fef059e3          	blez	a5,80003740 <iget+0x38>
    80003752:	4098                	lw	a4,0(s1)
    80003754:	ff3716e3          	bne	a4,s3,80003740 <iget+0x38>
    80003758:	40d8                	lw	a4,4(s1)
    8000375a:	ff4713e3          	bne	a4,s4,80003740 <iget+0x38>
      ip->ref++;
    8000375e:	2785                	addiw	a5,a5,1
    80003760:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003762:	0001c517          	auipc	a0,0x1c
    80003766:	46650513          	addi	a0,a0,1126 # 8001fbc8 <itable>
    8000376a:	ffffd097          	auipc	ra,0xffffd
    8000376e:	50c080e7          	jalr	1292(ra) # 80000c76 <release>
      return ip;
    80003772:	8926                	mv	s2,s1
    80003774:	a03d                	j	800037a2 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003776:	f7f9                	bnez	a5,80003744 <iget+0x3c>
    80003778:	8926                	mv	s2,s1
    8000377a:	b7e9                	j	80003744 <iget+0x3c>
  if(empty == 0)
    8000377c:	02090c63          	beqz	s2,800037b4 <iget+0xac>
  ip->dev = dev;
    80003780:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003784:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003788:	4785                	li	a5,1
    8000378a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000378e:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003792:	0001c517          	auipc	a0,0x1c
    80003796:	43650513          	addi	a0,a0,1078 # 8001fbc8 <itable>
    8000379a:	ffffd097          	auipc	ra,0xffffd
    8000379e:	4dc080e7          	jalr	1244(ra) # 80000c76 <release>
}
    800037a2:	854a                	mv	a0,s2
    800037a4:	70a2                	ld	ra,40(sp)
    800037a6:	7402                	ld	s0,32(sp)
    800037a8:	64e2                	ld	s1,24(sp)
    800037aa:	6942                	ld	s2,16(sp)
    800037ac:	69a2                	ld	s3,8(sp)
    800037ae:	6a02                	ld	s4,0(sp)
    800037b0:	6145                	addi	sp,sp,48
    800037b2:	8082                	ret
    panic("iget: no inodes");
    800037b4:	00005517          	auipc	a0,0x5
    800037b8:	ec450513          	addi	a0,a0,-316 # 80008678 <syscalls+0x138>
    800037bc:	ffffd097          	auipc	ra,0xffffd
    800037c0:	d6e080e7          	jalr	-658(ra) # 8000052a <panic>

00000000800037c4 <fsinit>:
fsinit(int dev) {
    800037c4:	7179                	addi	sp,sp,-48
    800037c6:	f406                	sd	ra,40(sp)
    800037c8:	f022                	sd	s0,32(sp)
    800037ca:	ec26                	sd	s1,24(sp)
    800037cc:	e84a                	sd	s2,16(sp)
    800037ce:	e44e                	sd	s3,8(sp)
    800037d0:	1800                	addi	s0,sp,48
    800037d2:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800037d4:	4585                	li	a1,1
    800037d6:	00000097          	auipc	ra,0x0
    800037da:	a64080e7          	jalr	-1436(ra) # 8000323a <bread>
    800037de:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800037e0:	0001c997          	auipc	s3,0x1c
    800037e4:	3c898993          	addi	s3,s3,968 # 8001fba8 <sb>
    800037e8:	02000613          	li	a2,32
    800037ec:	05850593          	addi	a1,a0,88
    800037f0:	854e                	mv	a0,s3
    800037f2:	ffffd097          	auipc	ra,0xffffd
    800037f6:	528080e7          	jalr	1320(ra) # 80000d1a <memmove>
  brelse(bp);
    800037fa:	8526                	mv	a0,s1
    800037fc:	00000097          	auipc	ra,0x0
    80003800:	b6e080e7          	jalr	-1170(ra) # 8000336a <brelse>
  if(sb.magic != FSMAGIC)
    80003804:	0009a703          	lw	a4,0(s3)
    80003808:	102037b7          	lui	a5,0x10203
    8000380c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003810:	02f71263          	bne	a4,a5,80003834 <fsinit+0x70>
  initlog(dev, &sb);
    80003814:	0001c597          	auipc	a1,0x1c
    80003818:	39458593          	addi	a1,a1,916 # 8001fba8 <sb>
    8000381c:	854a                	mv	a0,s2
    8000381e:	00001097          	auipc	ra,0x1
    80003822:	b4c080e7          	jalr	-1204(ra) # 8000436a <initlog>
}
    80003826:	70a2                	ld	ra,40(sp)
    80003828:	7402                	ld	s0,32(sp)
    8000382a:	64e2                	ld	s1,24(sp)
    8000382c:	6942                	ld	s2,16(sp)
    8000382e:	69a2                	ld	s3,8(sp)
    80003830:	6145                	addi	sp,sp,48
    80003832:	8082                	ret
    panic("invalid file system");
    80003834:	00005517          	auipc	a0,0x5
    80003838:	e5450513          	addi	a0,a0,-428 # 80008688 <syscalls+0x148>
    8000383c:	ffffd097          	auipc	ra,0xffffd
    80003840:	cee080e7          	jalr	-786(ra) # 8000052a <panic>

0000000080003844 <iinit>:
{
    80003844:	7179                	addi	sp,sp,-48
    80003846:	f406                	sd	ra,40(sp)
    80003848:	f022                	sd	s0,32(sp)
    8000384a:	ec26                	sd	s1,24(sp)
    8000384c:	e84a                	sd	s2,16(sp)
    8000384e:	e44e                	sd	s3,8(sp)
    80003850:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003852:	00005597          	auipc	a1,0x5
    80003856:	e4e58593          	addi	a1,a1,-434 # 800086a0 <syscalls+0x160>
    8000385a:	0001c517          	auipc	a0,0x1c
    8000385e:	36e50513          	addi	a0,a0,878 # 8001fbc8 <itable>
    80003862:	ffffd097          	auipc	ra,0xffffd
    80003866:	2d0080e7          	jalr	720(ra) # 80000b32 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000386a:	0001c497          	auipc	s1,0x1c
    8000386e:	38648493          	addi	s1,s1,902 # 8001fbf0 <itable+0x28>
    80003872:	0001e997          	auipc	s3,0x1e
    80003876:	e0e98993          	addi	s3,s3,-498 # 80021680 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000387a:	00005917          	auipc	s2,0x5
    8000387e:	e2e90913          	addi	s2,s2,-466 # 800086a8 <syscalls+0x168>
    80003882:	85ca                	mv	a1,s2
    80003884:	8526                	mv	a0,s1
    80003886:	00001097          	auipc	ra,0x1
    8000388a:	e46080e7          	jalr	-442(ra) # 800046cc <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000388e:	08848493          	addi	s1,s1,136
    80003892:	ff3498e3          	bne	s1,s3,80003882 <iinit+0x3e>
}
    80003896:	70a2                	ld	ra,40(sp)
    80003898:	7402                	ld	s0,32(sp)
    8000389a:	64e2                	ld	s1,24(sp)
    8000389c:	6942                	ld	s2,16(sp)
    8000389e:	69a2                	ld	s3,8(sp)
    800038a0:	6145                	addi	sp,sp,48
    800038a2:	8082                	ret

00000000800038a4 <ialloc>:
{
    800038a4:	715d                	addi	sp,sp,-80
    800038a6:	e486                	sd	ra,72(sp)
    800038a8:	e0a2                	sd	s0,64(sp)
    800038aa:	fc26                	sd	s1,56(sp)
    800038ac:	f84a                	sd	s2,48(sp)
    800038ae:	f44e                	sd	s3,40(sp)
    800038b0:	f052                	sd	s4,32(sp)
    800038b2:	ec56                	sd	s5,24(sp)
    800038b4:	e85a                	sd	s6,16(sp)
    800038b6:	e45e                	sd	s7,8(sp)
    800038b8:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800038ba:	0001c717          	auipc	a4,0x1c
    800038be:	2fa72703          	lw	a4,762(a4) # 8001fbb4 <sb+0xc>
    800038c2:	4785                	li	a5,1
    800038c4:	04e7fa63          	bgeu	a5,a4,80003918 <ialloc+0x74>
    800038c8:	8aaa                	mv	s5,a0
    800038ca:	8bae                	mv	s7,a1
    800038cc:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    800038ce:	0001ca17          	auipc	s4,0x1c
    800038d2:	2daa0a13          	addi	s4,s4,730 # 8001fba8 <sb>
    800038d6:	00048b1b          	sext.w	s6,s1
    800038da:	0044d793          	srli	a5,s1,0x4
    800038de:	018a2583          	lw	a1,24(s4)
    800038e2:	9dbd                	addw	a1,a1,a5
    800038e4:	8556                	mv	a0,s5
    800038e6:	00000097          	auipc	ra,0x0
    800038ea:	954080e7          	jalr	-1708(ra) # 8000323a <bread>
    800038ee:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800038f0:	05850993          	addi	s3,a0,88
    800038f4:	00f4f793          	andi	a5,s1,15
    800038f8:	079a                	slli	a5,a5,0x6
    800038fa:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800038fc:	00099783          	lh	a5,0(s3)
    80003900:	c785                	beqz	a5,80003928 <ialloc+0x84>
    brelse(bp);
    80003902:	00000097          	auipc	ra,0x0
    80003906:	a68080e7          	jalr	-1432(ra) # 8000336a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000390a:	0485                	addi	s1,s1,1
    8000390c:	00ca2703          	lw	a4,12(s4)
    80003910:	0004879b          	sext.w	a5,s1
    80003914:	fce7e1e3          	bltu	a5,a4,800038d6 <ialloc+0x32>
  panic("ialloc: no inodes");
    80003918:	00005517          	auipc	a0,0x5
    8000391c:	d9850513          	addi	a0,a0,-616 # 800086b0 <syscalls+0x170>
    80003920:	ffffd097          	auipc	ra,0xffffd
    80003924:	c0a080e7          	jalr	-1014(ra) # 8000052a <panic>
      memset(dip, 0, sizeof(*dip));
    80003928:	04000613          	li	a2,64
    8000392c:	4581                	li	a1,0
    8000392e:	854e                	mv	a0,s3
    80003930:	ffffd097          	auipc	ra,0xffffd
    80003934:	38e080e7          	jalr	910(ra) # 80000cbe <memset>
      dip->type = type;
    80003938:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000393c:	854a                	mv	a0,s2
    8000393e:	00001097          	auipc	ra,0x1
    80003942:	ca8080e7          	jalr	-856(ra) # 800045e6 <log_write>
      brelse(bp);
    80003946:	854a                	mv	a0,s2
    80003948:	00000097          	auipc	ra,0x0
    8000394c:	a22080e7          	jalr	-1502(ra) # 8000336a <brelse>
      return iget(dev, inum);
    80003950:	85da                	mv	a1,s6
    80003952:	8556                	mv	a0,s5
    80003954:	00000097          	auipc	ra,0x0
    80003958:	db4080e7          	jalr	-588(ra) # 80003708 <iget>
}
    8000395c:	60a6                	ld	ra,72(sp)
    8000395e:	6406                	ld	s0,64(sp)
    80003960:	74e2                	ld	s1,56(sp)
    80003962:	7942                	ld	s2,48(sp)
    80003964:	79a2                	ld	s3,40(sp)
    80003966:	7a02                	ld	s4,32(sp)
    80003968:	6ae2                	ld	s5,24(sp)
    8000396a:	6b42                	ld	s6,16(sp)
    8000396c:	6ba2                	ld	s7,8(sp)
    8000396e:	6161                	addi	sp,sp,80
    80003970:	8082                	ret

0000000080003972 <iupdate>:
{
    80003972:	1101                	addi	sp,sp,-32
    80003974:	ec06                	sd	ra,24(sp)
    80003976:	e822                	sd	s0,16(sp)
    80003978:	e426                	sd	s1,8(sp)
    8000397a:	e04a                	sd	s2,0(sp)
    8000397c:	1000                	addi	s0,sp,32
    8000397e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003980:	415c                	lw	a5,4(a0)
    80003982:	0047d79b          	srliw	a5,a5,0x4
    80003986:	0001c597          	auipc	a1,0x1c
    8000398a:	23a5a583          	lw	a1,570(a1) # 8001fbc0 <sb+0x18>
    8000398e:	9dbd                	addw	a1,a1,a5
    80003990:	4108                	lw	a0,0(a0)
    80003992:	00000097          	auipc	ra,0x0
    80003996:	8a8080e7          	jalr	-1880(ra) # 8000323a <bread>
    8000399a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000399c:	05850793          	addi	a5,a0,88
    800039a0:	40c8                	lw	a0,4(s1)
    800039a2:	893d                	andi	a0,a0,15
    800039a4:	051a                	slli	a0,a0,0x6
    800039a6:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    800039a8:	04449703          	lh	a4,68(s1)
    800039ac:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    800039b0:	04649703          	lh	a4,70(s1)
    800039b4:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    800039b8:	04849703          	lh	a4,72(s1)
    800039bc:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    800039c0:	04a49703          	lh	a4,74(s1)
    800039c4:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    800039c8:	44f8                	lw	a4,76(s1)
    800039ca:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800039cc:	03400613          	li	a2,52
    800039d0:	05048593          	addi	a1,s1,80
    800039d4:	0531                	addi	a0,a0,12
    800039d6:	ffffd097          	auipc	ra,0xffffd
    800039da:	344080e7          	jalr	836(ra) # 80000d1a <memmove>
  log_write(bp);
    800039de:	854a                	mv	a0,s2
    800039e0:	00001097          	auipc	ra,0x1
    800039e4:	c06080e7          	jalr	-1018(ra) # 800045e6 <log_write>
  brelse(bp);
    800039e8:	854a                	mv	a0,s2
    800039ea:	00000097          	auipc	ra,0x0
    800039ee:	980080e7          	jalr	-1664(ra) # 8000336a <brelse>
}
    800039f2:	60e2                	ld	ra,24(sp)
    800039f4:	6442                	ld	s0,16(sp)
    800039f6:	64a2                	ld	s1,8(sp)
    800039f8:	6902                	ld	s2,0(sp)
    800039fa:	6105                	addi	sp,sp,32
    800039fc:	8082                	ret

00000000800039fe <idup>:
{
    800039fe:	1101                	addi	sp,sp,-32
    80003a00:	ec06                	sd	ra,24(sp)
    80003a02:	e822                	sd	s0,16(sp)
    80003a04:	e426                	sd	s1,8(sp)
    80003a06:	1000                	addi	s0,sp,32
    80003a08:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003a0a:	0001c517          	auipc	a0,0x1c
    80003a0e:	1be50513          	addi	a0,a0,446 # 8001fbc8 <itable>
    80003a12:	ffffd097          	auipc	ra,0xffffd
    80003a16:	1b0080e7          	jalr	432(ra) # 80000bc2 <acquire>
  ip->ref++;
    80003a1a:	449c                	lw	a5,8(s1)
    80003a1c:	2785                	addiw	a5,a5,1
    80003a1e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003a20:	0001c517          	auipc	a0,0x1c
    80003a24:	1a850513          	addi	a0,a0,424 # 8001fbc8 <itable>
    80003a28:	ffffd097          	auipc	ra,0xffffd
    80003a2c:	24e080e7          	jalr	590(ra) # 80000c76 <release>
}
    80003a30:	8526                	mv	a0,s1
    80003a32:	60e2                	ld	ra,24(sp)
    80003a34:	6442                	ld	s0,16(sp)
    80003a36:	64a2                	ld	s1,8(sp)
    80003a38:	6105                	addi	sp,sp,32
    80003a3a:	8082                	ret

0000000080003a3c <ilock>:
{
    80003a3c:	1101                	addi	sp,sp,-32
    80003a3e:	ec06                	sd	ra,24(sp)
    80003a40:	e822                	sd	s0,16(sp)
    80003a42:	e426                	sd	s1,8(sp)
    80003a44:	e04a                	sd	s2,0(sp)
    80003a46:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003a48:	c115                	beqz	a0,80003a6c <ilock+0x30>
    80003a4a:	84aa                	mv	s1,a0
    80003a4c:	451c                	lw	a5,8(a0)
    80003a4e:	00f05f63          	blez	a5,80003a6c <ilock+0x30>
  acquiresleep(&ip->lock);
    80003a52:	0541                	addi	a0,a0,16
    80003a54:	00001097          	auipc	ra,0x1
    80003a58:	cb2080e7          	jalr	-846(ra) # 80004706 <acquiresleep>
  if(ip->valid == 0){
    80003a5c:	40bc                	lw	a5,64(s1)
    80003a5e:	cf99                	beqz	a5,80003a7c <ilock+0x40>
}
    80003a60:	60e2                	ld	ra,24(sp)
    80003a62:	6442                	ld	s0,16(sp)
    80003a64:	64a2                	ld	s1,8(sp)
    80003a66:	6902                	ld	s2,0(sp)
    80003a68:	6105                	addi	sp,sp,32
    80003a6a:	8082                	ret
    panic("ilock");
    80003a6c:	00005517          	auipc	a0,0x5
    80003a70:	c5c50513          	addi	a0,a0,-932 # 800086c8 <syscalls+0x188>
    80003a74:	ffffd097          	auipc	ra,0xffffd
    80003a78:	ab6080e7          	jalr	-1354(ra) # 8000052a <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003a7c:	40dc                	lw	a5,4(s1)
    80003a7e:	0047d79b          	srliw	a5,a5,0x4
    80003a82:	0001c597          	auipc	a1,0x1c
    80003a86:	13e5a583          	lw	a1,318(a1) # 8001fbc0 <sb+0x18>
    80003a8a:	9dbd                	addw	a1,a1,a5
    80003a8c:	4088                	lw	a0,0(s1)
    80003a8e:	fffff097          	auipc	ra,0xfffff
    80003a92:	7ac080e7          	jalr	1964(ra) # 8000323a <bread>
    80003a96:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003a98:	05850593          	addi	a1,a0,88
    80003a9c:	40dc                	lw	a5,4(s1)
    80003a9e:	8bbd                	andi	a5,a5,15
    80003aa0:	079a                	slli	a5,a5,0x6
    80003aa2:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003aa4:	00059783          	lh	a5,0(a1)
    80003aa8:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003aac:	00259783          	lh	a5,2(a1)
    80003ab0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003ab4:	00459783          	lh	a5,4(a1)
    80003ab8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003abc:	00659783          	lh	a5,6(a1)
    80003ac0:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003ac4:	459c                	lw	a5,8(a1)
    80003ac6:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003ac8:	03400613          	li	a2,52
    80003acc:	05b1                	addi	a1,a1,12
    80003ace:	05048513          	addi	a0,s1,80
    80003ad2:	ffffd097          	auipc	ra,0xffffd
    80003ad6:	248080e7          	jalr	584(ra) # 80000d1a <memmove>
    brelse(bp);
    80003ada:	854a                	mv	a0,s2
    80003adc:	00000097          	auipc	ra,0x0
    80003ae0:	88e080e7          	jalr	-1906(ra) # 8000336a <brelse>
    ip->valid = 1;
    80003ae4:	4785                	li	a5,1
    80003ae6:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003ae8:	04449783          	lh	a5,68(s1)
    80003aec:	fbb5                	bnez	a5,80003a60 <ilock+0x24>
      panic("ilock: no type");
    80003aee:	00005517          	auipc	a0,0x5
    80003af2:	be250513          	addi	a0,a0,-1054 # 800086d0 <syscalls+0x190>
    80003af6:	ffffd097          	auipc	ra,0xffffd
    80003afa:	a34080e7          	jalr	-1484(ra) # 8000052a <panic>

0000000080003afe <iunlock>:
{
    80003afe:	1101                	addi	sp,sp,-32
    80003b00:	ec06                	sd	ra,24(sp)
    80003b02:	e822                	sd	s0,16(sp)
    80003b04:	e426                	sd	s1,8(sp)
    80003b06:	e04a                	sd	s2,0(sp)
    80003b08:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003b0a:	c905                	beqz	a0,80003b3a <iunlock+0x3c>
    80003b0c:	84aa                	mv	s1,a0
    80003b0e:	01050913          	addi	s2,a0,16
    80003b12:	854a                	mv	a0,s2
    80003b14:	00001097          	auipc	ra,0x1
    80003b18:	c8c080e7          	jalr	-884(ra) # 800047a0 <holdingsleep>
    80003b1c:	cd19                	beqz	a0,80003b3a <iunlock+0x3c>
    80003b1e:	449c                	lw	a5,8(s1)
    80003b20:	00f05d63          	blez	a5,80003b3a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003b24:	854a                	mv	a0,s2
    80003b26:	00001097          	auipc	ra,0x1
    80003b2a:	c36080e7          	jalr	-970(ra) # 8000475c <releasesleep>
}
    80003b2e:	60e2                	ld	ra,24(sp)
    80003b30:	6442                	ld	s0,16(sp)
    80003b32:	64a2                	ld	s1,8(sp)
    80003b34:	6902                	ld	s2,0(sp)
    80003b36:	6105                	addi	sp,sp,32
    80003b38:	8082                	ret
    panic("iunlock");
    80003b3a:	00005517          	auipc	a0,0x5
    80003b3e:	ba650513          	addi	a0,a0,-1114 # 800086e0 <syscalls+0x1a0>
    80003b42:	ffffd097          	auipc	ra,0xffffd
    80003b46:	9e8080e7          	jalr	-1560(ra) # 8000052a <panic>

0000000080003b4a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003b4a:	7179                	addi	sp,sp,-48
    80003b4c:	f406                	sd	ra,40(sp)
    80003b4e:	f022                	sd	s0,32(sp)
    80003b50:	ec26                	sd	s1,24(sp)
    80003b52:	e84a                	sd	s2,16(sp)
    80003b54:	e44e                	sd	s3,8(sp)
    80003b56:	e052                	sd	s4,0(sp)
    80003b58:	1800                	addi	s0,sp,48
    80003b5a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003b5c:	05050493          	addi	s1,a0,80
    80003b60:	08050913          	addi	s2,a0,128
    80003b64:	a021                	j	80003b6c <itrunc+0x22>
    80003b66:	0491                	addi	s1,s1,4
    80003b68:	01248d63          	beq	s1,s2,80003b82 <itrunc+0x38>
    if(ip->addrs[i]){
    80003b6c:	408c                	lw	a1,0(s1)
    80003b6e:	dde5                	beqz	a1,80003b66 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003b70:	0009a503          	lw	a0,0(s3)
    80003b74:	00000097          	auipc	ra,0x0
    80003b78:	90c080e7          	jalr	-1780(ra) # 80003480 <bfree>
      ip->addrs[i] = 0;
    80003b7c:	0004a023          	sw	zero,0(s1)
    80003b80:	b7dd                	j	80003b66 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003b82:	0809a583          	lw	a1,128(s3)
    80003b86:	e185                	bnez	a1,80003ba6 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003b88:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003b8c:	854e                	mv	a0,s3
    80003b8e:	00000097          	auipc	ra,0x0
    80003b92:	de4080e7          	jalr	-540(ra) # 80003972 <iupdate>
}
    80003b96:	70a2                	ld	ra,40(sp)
    80003b98:	7402                	ld	s0,32(sp)
    80003b9a:	64e2                	ld	s1,24(sp)
    80003b9c:	6942                	ld	s2,16(sp)
    80003b9e:	69a2                	ld	s3,8(sp)
    80003ba0:	6a02                	ld	s4,0(sp)
    80003ba2:	6145                	addi	sp,sp,48
    80003ba4:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003ba6:	0009a503          	lw	a0,0(s3)
    80003baa:	fffff097          	auipc	ra,0xfffff
    80003bae:	690080e7          	jalr	1680(ra) # 8000323a <bread>
    80003bb2:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003bb4:	05850493          	addi	s1,a0,88
    80003bb8:	45850913          	addi	s2,a0,1112
    80003bbc:	a021                	j	80003bc4 <itrunc+0x7a>
    80003bbe:	0491                	addi	s1,s1,4
    80003bc0:	01248b63          	beq	s1,s2,80003bd6 <itrunc+0x8c>
      if(a[j])
    80003bc4:	408c                	lw	a1,0(s1)
    80003bc6:	dde5                	beqz	a1,80003bbe <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003bc8:	0009a503          	lw	a0,0(s3)
    80003bcc:	00000097          	auipc	ra,0x0
    80003bd0:	8b4080e7          	jalr	-1868(ra) # 80003480 <bfree>
    80003bd4:	b7ed                	j	80003bbe <itrunc+0x74>
    brelse(bp);
    80003bd6:	8552                	mv	a0,s4
    80003bd8:	fffff097          	auipc	ra,0xfffff
    80003bdc:	792080e7          	jalr	1938(ra) # 8000336a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003be0:	0809a583          	lw	a1,128(s3)
    80003be4:	0009a503          	lw	a0,0(s3)
    80003be8:	00000097          	auipc	ra,0x0
    80003bec:	898080e7          	jalr	-1896(ra) # 80003480 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003bf0:	0809a023          	sw	zero,128(s3)
    80003bf4:	bf51                	j	80003b88 <itrunc+0x3e>

0000000080003bf6 <iput>:
{
    80003bf6:	1101                	addi	sp,sp,-32
    80003bf8:	ec06                	sd	ra,24(sp)
    80003bfa:	e822                	sd	s0,16(sp)
    80003bfc:	e426                	sd	s1,8(sp)
    80003bfe:	e04a                	sd	s2,0(sp)
    80003c00:	1000                	addi	s0,sp,32
    80003c02:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003c04:	0001c517          	auipc	a0,0x1c
    80003c08:	fc450513          	addi	a0,a0,-60 # 8001fbc8 <itable>
    80003c0c:	ffffd097          	auipc	ra,0xffffd
    80003c10:	fb6080e7          	jalr	-74(ra) # 80000bc2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003c14:	4498                	lw	a4,8(s1)
    80003c16:	4785                	li	a5,1
    80003c18:	02f70363          	beq	a4,a5,80003c3e <iput+0x48>
  ip->ref--;
    80003c1c:	449c                	lw	a5,8(s1)
    80003c1e:	37fd                	addiw	a5,a5,-1
    80003c20:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003c22:	0001c517          	auipc	a0,0x1c
    80003c26:	fa650513          	addi	a0,a0,-90 # 8001fbc8 <itable>
    80003c2a:	ffffd097          	auipc	ra,0xffffd
    80003c2e:	04c080e7          	jalr	76(ra) # 80000c76 <release>
}
    80003c32:	60e2                	ld	ra,24(sp)
    80003c34:	6442                	ld	s0,16(sp)
    80003c36:	64a2                	ld	s1,8(sp)
    80003c38:	6902                	ld	s2,0(sp)
    80003c3a:	6105                	addi	sp,sp,32
    80003c3c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003c3e:	40bc                	lw	a5,64(s1)
    80003c40:	dff1                	beqz	a5,80003c1c <iput+0x26>
    80003c42:	04a49783          	lh	a5,74(s1)
    80003c46:	fbf9                	bnez	a5,80003c1c <iput+0x26>
    acquiresleep(&ip->lock);
    80003c48:	01048913          	addi	s2,s1,16
    80003c4c:	854a                	mv	a0,s2
    80003c4e:	00001097          	auipc	ra,0x1
    80003c52:	ab8080e7          	jalr	-1352(ra) # 80004706 <acquiresleep>
    release(&itable.lock);
    80003c56:	0001c517          	auipc	a0,0x1c
    80003c5a:	f7250513          	addi	a0,a0,-142 # 8001fbc8 <itable>
    80003c5e:	ffffd097          	auipc	ra,0xffffd
    80003c62:	018080e7          	jalr	24(ra) # 80000c76 <release>
    itrunc(ip);
    80003c66:	8526                	mv	a0,s1
    80003c68:	00000097          	auipc	ra,0x0
    80003c6c:	ee2080e7          	jalr	-286(ra) # 80003b4a <itrunc>
    ip->type = 0;
    80003c70:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003c74:	8526                	mv	a0,s1
    80003c76:	00000097          	auipc	ra,0x0
    80003c7a:	cfc080e7          	jalr	-772(ra) # 80003972 <iupdate>
    ip->valid = 0;
    80003c7e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003c82:	854a                	mv	a0,s2
    80003c84:	00001097          	auipc	ra,0x1
    80003c88:	ad8080e7          	jalr	-1320(ra) # 8000475c <releasesleep>
    acquire(&itable.lock);
    80003c8c:	0001c517          	auipc	a0,0x1c
    80003c90:	f3c50513          	addi	a0,a0,-196 # 8001fbc8 <itable>
    80003c94:	ffffd097          	auipc	ra,0xffffd
    80003c98:	f2e080e7          	jalr	-210(ra) # 80000bc2 <acquire>
    80003c9c:	b741                	j	80003c1c <iput+0x26>

0000000080003c9e <iunlockput>:
{
    80003c9e:	1101                	addi	sp,sp,-32
    80003ca0:	ec06                	sd	ra,24(sp)
    80003ca2:	e822                	sd	s0,16(sp)
    80003ca4:	e426                	sd	s1,8(sp)
    80003ca6:	1000                	addi	s0,sp,32
    80003ca8:	84aa                	mv	s1,a0
  iunlock(ip);
    80003caa:	00000097          	auipc	ra,0x0
    80003cae:	e54080e7          	jalr	-428(ra) # 80003afe <iunlock>
  iput(ip);
    80003cb2:	8526                	mv	a0,s1
    80003cb4:	00000097          	auipc	ra,0x0
    80003cb8:	f42080e7          	jalr	-190(ra) # 80003bf6 <iput>
}
    80003cbc:	60e2                	ld	ra,24(sp)
    80003cbe:	6442                	ld	s0,16(sp)
    80003cc0:	64a2                	ld	s1,8(sp)
    80003cc2:	6105                	addi	sp,sp,32
    80003cc4:	8082                	ret

0000000080003cc6 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003cc6:	1141                	addi	sp,sp,-16
    80003cc8:	e422                	sd	s0,8(sp)
    80003cca:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003ccc:	411c                	lw	a5,0(a0)
    80003cce:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003cd0:	415c                	lw	a5,4(a0)
    80003cd2:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003cd4:	04451783          	lh	a5,68(a0)
    80003cd8:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003cdc:	04a51783          	lh	a5,74(a0)
    80003ce0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003ce4:	04c56783          	lwu	a5,76(a0)
    80003ce8:	e99c                	sd	a5,16(a1)
}
    80003cea:	6422                	ld	s0,8(sp)
    80003cec:	0141                	addi	sp,sp,16
    80003cee:	8082                	ret

0000000080003cf0 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003cf0:	457c                	lw	a5,76(a0)
    80003cf2:	0ed7e963          	bltu	a5,a3,80003de4 <readi+0xf4>
{
    80003cf6:	7159                	addi	sp,sp,-112
    80003cf8:	f486                	sd	ra,104(sp)
    80003cfa:	f0a2                	sd	s0,96(sp)
    80003cfc:	eca6                	sd	s1,88(sp)
    80003cfe:	e8ca                	sd	s2,80(sp)
    80003d00:	e4ce                	sd	s3,72(sp)
    80003d02:	e0d2                	sd	s4,64(sp)
    80003d04:	fc56                	sd	s5,56(sp)
    80003d06:	f85a                	sd	s6,48(sp)
    80003d08:	f45e                	sd	s7,40(sp)
    80003d0a:	f062                	sd	s8,32(sp)
    80003d0c:	ec66                	sd	s9,24(sp)
    80003d0e:	e86a                	sd	s10,16(sp)
    80003d10:	e46e                	sd	s11,8(sp)
    80003d12:	1880                	addi	s0,sp,112
    80003d14:	8baa                	mv	s7,a0
    80003d16:	8c2e                	mv	s8,a1
    80003d18:	8ab2                	mv	s5,a2
    80003d1a:	84b6                	mv	s1,a3
    80003d1c:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003d1e:	9f35                	addw	a4,a4,a3
    return 0;
    80003d20:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003d22:	0ad76063          	bltu	a4,a3,80003dc2 <readi+0xd2>
  if(off + n > ip->size)
    80003d26:	00e7f463          	bgeu	a5,a4,80003d2e <readi+0x3e>
    n = ip->size - off;
    80003d2a:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003d2e:	0a0b0963          	beqz	s6,80003de0 <readi+0xf0>
    80003d32:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003d34:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003d38:	5cfd                	li	s9,-1
    80003d3a:	a82d                	j	80003d74 <readi+0x84>
    80003d3c:	020a1d93          	slli	s11,s4,0x20
    80003d40:	020ddd93          	srli	s11,s11,0x20
    80003d44:	05890793          	addi	a5,s2,88
    80003d48:	86ee                	mv	a3,s11
    80003d4a:	963e                	add	a2,a2,a5
    80003d4c:	85d6                	mv	a1,s5
    80003d4e:	8562                	mv	a0,s8
    80003d50:	fffff097          	auipc	ra,0xfffff
    80003d54:	ab8080e7          	jalr	-1352(ra) # 80002808 <either_copyout>
    80003d58:	05950d63          	beq	a0,s9,80003db2 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003d5c:	854a                	mv	a0,s2
    80003d5e:	fffff097          	auipc	ra,0xfffff
    80003d62:	60c080e7          	jalr	1548(ra) # 8000336a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003d66:	013a09bb          	addw	s3,s4,s3
    80003d6a:	009a04bb          	addw	s1,s4,s1
    80003d6e:	9aee                	add	s5,s5,s11
    80003d70:	0569f763          	bgeu	s3,s6,80003dbe <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003d74:	000ba903          	lw	s2,0(s7)
    80003d78:	00a4d59b          	srliw	a1,s1,0xa
    80003d7c:	855e                	mv	a0,s7
    80003d7e:	00000097          	auipc	ra,0x0
    80003d82:	8b0080e7          	jalr	-1872(ra) # 8000362e <bmap>
    80003d86:	0005059b          	sext.w	a1,a0
    80003d8a:	854a                	mv	a0,s2
    80003d8c:	fffff097          	auipc	ra,0xfffff
    80003d90:	4ae080e7          	jalr	1198(ra) # 8000323a <bread>
    80003d94:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003d96:	3ff4f613          	andi	a2,s1,1023
    80003d9a:	40cd07bb          	subw	a5,s10,a2
    80003d9e:	413b073b          	subw	a4,s6,s3
    80003da2:	8a3e                	mv	s4,a5
    80003da4:	2781                	sext.w	a5,a5
    80003da6:	0007069b          	sext.w	a3,a4
    80003daa:	f8f6f9e3          	bgeu	a3,a5,80003d3c <readi+0x4c>
    80003dae:	8a3a                	mv	s4,a4
    80003db0:	b771                	j	80003d3c <readi+0x4c>
      brelse(bp);
    80003db2:	854a                	mv	a0,s2
    80003db4:	fffff097          	auipc	ra,0xfffff
    80003db8:	5b6080e7          	jalr	1462(ra) # 8000336a <brelse>
      tot = -1;
    80003dbc:	59fd                	li	s3,-1
  }
  return tot;
    80003dbe:	0009851b          	sext.w	a0,s3
}
    80003dc2:	70a6                	ld	ra,104(sp)
    80003dc4:	7406                	ld	s0,96(sp)
    80003dc6:	64e6                	ld	s1,88(sp)
    80003dc8:	6946                	ld	s2,80(sp)
    80003dca:	69a6                	ld	s3,72(sp)
    80003dcc:	6a06                	ld	s4,64(sp)
    80003dce:	7ae2                	ld	s5,56(sp)
    80003dd0:	7b42                	ld	s6,48(sp)
    80003dd2:	7ba2                	ld	s7,40(sp)
    80003dd4:	7c02                	ld	s8,32(sp)
    80003dd6:	6ce2                	ld	s9,24(sp)
    80003dd8:	6d42                	ld	s10,16(sp)
    80003dda:	6da2                	ld	s11,8(sp)
    80003ddc:	6165                	addi	sp,sp,112
    80003dde:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003de0:	89da                	mv	s3,s6
    80003de2:	bff1                	j	80003dbe <readi+0xce>
    return 0;
    80003de4:	4501                	li	a0,0
}
    80003de6:	8082                	ret

0000000080003de8 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003de8:	457c                	lw	a5,76(a0)
    80003dea:	10d7e863          	bltu	a5,a3,80003efa <writei+0x112>
{
    80003dee:	7159                	addi	sp,sp,-112
    80003df0:	f486                	sd	ra,104(sp)
    80003df2:	f0a2                	sd	s0,96(sp)
    80003df4:	eca6                	sd	s1,88(sp)
    80003df6:	e8ca                	sd	s2,80(sp)
    80003df8:	e4ce                	sd	s3,72(sp)
    80003dfa:	e0d2                	sd	s4,64(sp)
    80003dfc:	fc56                	sd	s5,56(sp)
    80003dfe:	f85a                	sd	s6,48(sp)
    80003e00:	f45e                	sd	s7,40(sp)
    80003e02:	f062                	sd	s8,32(sp)
    80003e04:	ec66                	sd	s9,24(sp)
    80003e06:	e86a                	sd	s10,16(sp)
    80003e08:	e46e                	sd	s11,8(sp)
    80003e0a:	1880                	addi	s0,sp,112
    80003e0c:	8b2a                	mv	s6,a0
    80003e0e:	8c2e                	mv	s8,a1
    80003e10:	8ab2                	mv	s5,a2
    80003e12:	8936                	mv	s2,a3
    80003e14:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003e16:	00e687bb          	addw	a5,a3,a4
    80003e1a:	0ed7e263          	bltu	a5,a3,80003efe <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003e1e:	00043737          	lui	a4,0x43
    80003e22:	0ef76063          	bltu	a4,a5,80003f02 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003e26:	0c0b8863          	beqz	s7,80003ef6 <writei+0x10e>
    80003e2a:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003e2c:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003e30:	5cfd                	li	s9,-1
    80003e32:	a091                	j	80003e76 <writei+0x8e>
    80003e34:	02099d93          	slli	s11,s3,0x20
    80003e38:	020ddd93          	srli	s11,s11,0x20
    80003e3c:	05848793          	addi	a5,s1,88
    80003e40:	86ee                	mv	a3,s11
    80003e42:	8656                	mv	a2,s5
    80003e44:	85e2                	mv	a1,s8
    80003e46:	953e                	add	a0,a0,a5
    80003e48:	fffff097          	auipc	ra,0xfffff
    80003e4c:	a16080e7          	jalr	-1514(ra) # 8000285e <either_copyin>
    80003e50:	07950263          	beq	a0,s9,80003eb4 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003e54:	8526                	mv	a0,s1
    80003e56:	00000097          	auipc	ra,0x0
    80003e5a:	790080e7          	jalr	1936(ra) # 800045e6 <log_write>
    brelse(bp);
    80003e5e:	8526                	mv	a0,s1
    80003e60:	fffff097          	auipc	ra,0xfffff
    80003e64:	50a080e7          	jalr	1290(ra) # 8000336a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003e68:	01498a3b          	addw	s4,s3,s4
    80003e6c:	0129893b          	addw	s2,s3,s2
    80003e70:	9aee                	add	s5,s5,s11
    80003e72:	057a7663          	bgeu	s4,s7,80003ebe <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003e76:	000b2483          	lw	s1,0(s6)
    80003e7a:	00a9559b          	srliw	a1,s2,0xa
    80003e7e:	855a                	mv	a0,s6
    80003e80:	fffff097          	auipc	ra,0xfffff
    80003e84:	7ae080e7          	jalr	1966(ra) # 8000362e <bmap>
    80003e88:	0005059b          	sext.w	a1,a0
    80003e8c:	8526                	mv	a0,s1
    80003e8e:	fffff097          	auipc	ra,0xfffff
    80003e92:	3ac080e7          	jalr	940(ra) # 8000323a <bread>
    80003e96:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003e98:	3ff97513          	andi	a0,s2,1023
    80003e9c:	40ad07bb          	subw	a5,s10,a0
    80003ea0:	414b873b          	subw	a4,s7,s4
    80003ea4:	89be                	mv	s3,a5
    80003ea6:	2781                	sext.w	a5,a5
    80003ea8:	0007069b          	sext.w	a3,a4
    80003eac:	f8f6f4e3          	bgeu	a3,a5,80003e34 <writei+0x4c>
    80003eb0:	89ba                	mv	s3,a4
    80003eb2:	b749                	j	80003e34 <writei+0x4c>
      brelse(bp);
    80003eb4:	8526                	mv	a0,s1
    80003eb6:	fffff097          	auipc	ra,0xfffff
    80003eba:	4b4080e7          	jalr	1204(ra) # 8000336a <brelse>
  }

  if(off > ip->size)
    80003ebe:	04cb2783          	lw	a5,76(s6)
    80003ec2:	0127f463          	bgeu	a5,s2,80003eca <writei+0xe2>
    ip->size = off;
    80003ec6:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003eca:	855a                	mv	a0,s6
    80003ecc:	00000097          	auipc	ra,0x0
    80003ed0:	aa6080e7          	jalr	-1370(ra) # 80003972 <iupdate>

  return tot;
    80003ed4:	000a051b          	sext.w	a0,s4
}
    80003ed8:	70a6                	ld	ra,104(sp)
    80003eda:	7406                	ld	s0,96(sp)
    80003edc:	64e6                	ld	s1,88(sp)
    80003ede:	6946                	ld	s2,80(sp)
    80003ee0:	69a6                	ld	s3,72(sp)
    80003ee2:	6a06                	ld	s4,64(sp)
    80003ee4:	7ae2                	ld	s5,56(sp)
    80003ee6:	7b42                	ld	s6,48(sp)
    80003ee8:	7ba2                	ld	s7,40(sp)
    80003eea:	7c02                	ld	s8,32(sp)
    80003eec:	6ce2                	ld	s9,24(sp)
    80003eee:	6d42                	ld	s10,16(sp)
    80003ef0:	6da2                	ld	s11,8(sp)
    80003ef2:	6165                	addi	sp,sp,112
    80003ef4:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003ef6:	8a5e                	mv	s4,s7
    80003ef8:	bfc9                	j	80003eca <writei+0xe2>
    return -1;
    80003efa:	557d                	li	a0,-1
}
    80003efc:	8082                	ret
    return -1;
    80003efe:	557d                	li	a0,-1
    80003f00:	bfe1                	j	80003ed8 <writei+0xf0>
    return -1;
    80003f02:	557d                	li	a0,-1
    80003f04:	bfd1                	j	80003ed8 <writei+0xf0>

0000000080003f06 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003f06:	1141                	addi	sp,sp,-16
    80003f08:	e406                	sd	ra,8(sp)
    80003f0a:	e022                	sd	s0,0(sp)
    80003f0c:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003f0e:	4639                	li	a2,14
    80003f10:	ffffd097          	auipc	ra,0xffffd
    80003f14:	e86080e7          	jalr	-378(ra) # 80000d96 <strncmp>
}
    80003f18:	60a2                	ld	ra,8(sp)
    80003f1a:	6402                	ld	s0,0(sp)
    80003f1c:	0141                	addi	sp,sp,16
    80003f1e:	8082                	ret

0000000080003f20 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003f20:	7139                	addi	sp,sp,-64
    80003f22:	fc06                	sd	ra,56(sp)
    80003f24:	f822                	sd	s0,48(sp)
    80003f26:	f426                	sd	s1,40(sp)
    80003f28:	f04a                	sd	s2,32(sp)
    80003f2a:	ec4e                	sd	s3,24(sp)
    80003f2c:	e852                	sd	s4,16(sp)
    80003f2e:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003f30:	04451703          	lh	a4,68(a0)
    80003f34:	4785                	li	a5,1
    80003f36:	00f71a63          	bne	a4,a5,80003f4a <dirlookup+0x2a>
    80003f3a:	892a                	mv	s2,a0
    80003f3c:	89ae                	mv	s3,a1
    80003f3e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003f40:	457c                	lw	a5,76(a0)
    80003f42:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003f44:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003f46:	e79d                	bnez	a5,80003f74 <dirlookup+0x54>
    80003f48:	a8a5                	j	80003fc0 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003f4a:	00004517          	auipc	a0,0x4
    80003f4e:	79e50513          	addi	a0,a0,1950 # 800086e8 <syscalls+0x1a8>
    80003f52:	ffffc097          	auipc	ra,0xffffc
    80003f56:	5d8080e7          	jalr	1496(ra) # 8000052a <panic>
      panic("dirlookup read");
    80003f5a:	00004517          	auipc	a0,0x4
    80003f5e:	7a650513          	addi	a0,a0,1958 # 80008700 <syscalls+0x1c0>
    80003f62:	ffffc097          	auipc	ra,0xffffc
    80003f66:	5c8080e7          	jalr	1480(ra) # 8000052a <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003f6a:	24c1                	addiw	s1,s1,16
    80003f6c:	04c92783          	lw	a5,76(s2)
    80003f70:	04f4f763          	bgeu	s1,a5,80003fbe <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003f74:	4741                	li	a4,16
    80003f76:	86a6                	mv	a3,s1
    80003f78:	fc040613          	addi	a2,s0,-64
    80003f7c:	4581                	li	a1,0
    80003f7e:	854a                	mv	a0,s2
    80003f80:	00000097          	auipc	ra,0x0
    80003f84:	d70080e7          	jalr	-656(ra) # 80003cf0 <readi>
    80003f88:	47c1                	li	a5,16
    80003f8a:	fcf518e3          	bne	a0,a5,80003f5a <dirlookup+0x3a>
    if(de.inum == 0)
    80003f8e:	fc045783          	lhu	a5,-64(s0)
    80003f92:	dfe1                	beqz	a5,80003f6a <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003f94:	fc240593          	addi	a1,s0,-62
    80003f98:	854e                	mv	a0,s3
    80003f9a:	00000097          	auipc	ra,0x0
    80003f9e:	f6c080e7          	jalr	-148(ra) # 80003f06 <namecmp>
    80003fa2:	f561                	bnez	a0,80003f6a <dirlookup+0x4a>
      if(poff)
    80003fa4:	000a0463          	beqz	s4,80003fac <dirlookup+0x8c>
        *poff = off;
    80003fa8:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003fac:	fc045583          	lhu	a1,-64(s0)
    80003fb0:	00092503          	lw	a0,0(s2)
    80003fb4:	fffff097          	auipc	ra,0xfffff
    80003fb8:	754080e7          	jalr	1876(ra) # 80003708 <iget>
    80003fbc:	a011                	j	80003fc0 <dirlookup+0xa0>
  return 0;
    80003fbe:	4501                	li	a0,0
}
    80003fc0:	70e2                	ld	ra,56(sp)
    80003fc2:	7442                	ld	s0,48(sp)
    80003fc4:	74a2                	ld	s1,40(sp)
    80003fc6:	7902                	ld	s2,32(sp)
    80003fc8:	69e2                	ld	s3,24(sp)
    80003fca:	6a42                	ld	s4,16(sp)
    80003fcc:	6121                	addi	sp,sp,64
    80003fce:	8082                	ret

0000000080003fd0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003fd0:	711d                	addi	sp,sp,-96
    80003fd2:	ec86                	sd	ra,88(sp)
    80003fd4:	e8a2                	sd	s0,80(sp)
    80003fd6:	e4a6                	sd	s1,72(sp)
    80003fd8:	e0ca                	sd	s2,64(sp)
    80003fda:	fc4e                	sd	s3,56(sp)
    80003fdc:	f852                	sd	s4,48(sp)
    80003fde:	f456                	sd	s5,40(sp)
    80003fe0:	f05a                	sd	s6,32(sp)
    80003fe2:	ec5e                	sd	s7,24(sp)
    80003fe4:	e862                	sd	s8,16(sp)
    80003fe6:	e466                	sd	s9,8(sp)
    80003fe8:	1080                	addi	s0,sp,96
    80003fea:	84aa                	mv	s1,a0
    80003fec:	8aae                	mv	s5,a1
    80003fee:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003ff0:	00054703          	lbu	a4,0(a0)
    80003ff4:	02f00793          	li	a5,47
    80003ff8:	02f70363          	beq	a4,a5,8000401e <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003ffc:	ffffe097          	auipc	ra,0xffffe
    80004000:	bf8080e7          	jalr	-1032(ra) # 80001bf4 <myproc>
    80004004:	16053503          	ld	a0,352(a0)
    80004008:	00000097          	auipc	ra,0x0
    8000400c:	9f6080e7          	jalr	-1546(ra) # 800039fe <idup>
    80004010:	89aa                	mv	s3,a0
  while(*path == '/')
    80004012:	02f00913          	li	s2,47
  len = path - s;
    80004016:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80004018:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000401a:	4b85                	li	s7,1
    8000401c:	a865                	j	800040d4 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    8000401e:	4585                	li	a1,1
    80004020:	4505                	li	a0,1
    80004022:	fffff097          	auipc	ra,0xfffff
    80004026:	6e6080e7          	jalr	1766(ra) # 80003708 <iget>
    8000402a:	89aa                	mv	s3,a0
    8000402c:	b7dd                	j	80004012 <namex+0x42>
      iunlockput(ip);
    8000402e:	854e                	mv	a0,s3
    80004030:	00000097          	auipc	ra,0x0
    80004034:	c6e080e7          	jalr	-914(ra) # 80003c9e <iunlockput>
      return 0;
    80004038:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000403a:	854e                	mv	a0,s3
    8000403c:	60e6                	ld	ra,88(sp)
    8000403e:	6446                	ld	s0,80(sp)
    80004040:	64a6                	ld	s1,72(sp)
    80004042:	6906                	ld	s2,64(sp)
    80004044:	79e2                	ld	s3,56(sp)
    80004046:	7a42                	ld	s4,48(sp)
    80004048:	7aa2                	ld	s5,40(sp)
    8000404a:	7b02                	ld	s6,32(sp)
    8000404c:	6be2                	ld	s7,24(sp)
    8000404e:	6c42                	ld	s8,16(sp)
    80004050:	6ca2                	ld	s9,8(sp)
    80004052:	6125                	addi	sp,sp,96
    80004054:	8082                	ret
      iunlock(ip);
    80004056:	854e                	mv	a0,s3
    80004058:	00000097          	auipc	ra,0x0
    8000405c:	aa6080e7          	jalr	-1370(ra) # 80003afe <iunlock>
      return ip;
    80004060:	bfe9                	j	8000403a <namex+0x6a>
      iunlockput(ip);
    80004062:	854e                	mv	a0,s3
    80004064:	00000097          	auipc	ra,0x0
    80004068:	c3a080e7          	jalr	-966(ra) # 80003c9e <iunlockput>
      return 0;
    8000406c:	89e6                	mv	s3,s9
    8000406e:	b7f1                	j	8000403a <namex+0x6a>
  len = path - s;
    80004070:	40b48633          	sub	a2,s1,a1
    80004074:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80004078:	099c5463          	bge	s8,s9,80004100 <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000407c:	4639                	li	a2,14
    8000407e:	8552                	mv	a0,s4
    80004080:	ffffd097          	auipc	ra,0xffffd
    80004084:	c9a080e7          	jalr	-870(ra) # 80000d1a <memmove>
  while(*path == '/')
    80004088:	0004c783          	lbu	a5,0(s1)
    8000408c:	01279763          	bne	a5,s2,8000409a <namex+0xca>
    path++;
    80004090:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004092:	0004c783          	lbu	a5,0(s1)
    80004096:	ff278de3          	beq	a5,s2,80004090 <namex+0xc0>
    ilock(ip);
    8000409a:	854e                	mv	a0,s3
    8000409c:	00000097          	auipc	ra,0x0
    800040a0:	9a0080e7          	jalr	-1632(ra) # 80003a3c <ilock>
    if(ip->type != T_DIR){
    800040a4:	04499783          	lh	a5,68(s3)
    800040a8:	f97793e3          	bne	a5,s7,8000402e <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800040ac:	000a8563          	beqz	s5,800040b6 <namex+0xe6>
    800040b0:	0004c783          	lbu	a5,0(s1)
    800040b4:	d3cd                	beqz	a5,80004056 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800040b6:	865a                	mv	a2,s6
    800040b8:	85d2                	mv	a1,s4
    800040ba:	854e                	mv	a0,s3
    800040bc:	00000097          	auipc	ra,0x0
    800040c0:	e64080e7          	jalr	-412(ra) # 80003f20 <dirlookup>
    800040c4:	8caa                	mv	s9,a0
    800040c6:	dd51                	beqz	a0,80004062 <namex+0x92>
    iunlockput(ip);
    800040c8:	854e                	mv	a0,s3
    800040ca:	00000097          	auipc	ra,0x0
    800040ce:	bd4080e7          	jalr	-1068(ra) # 80003c9e <iunlockput>
    ip = next;
    800040d2:	89e6                	mv	s3,s9
  while(*path == '/')
    800040d4:	0004c783          	lbu	a5,0(s1)
    800040d8:	05279763          	bne	a5,s2,80004126 <namex+0x156>
    path++;
    800040dc:	0485                	addi	s1,s1,1
  while(*path == '/')
    800040de:	0004c783          	lbu	a5,0(s1)
    800040e2:	ff278de3          	beq	a5,s2,800040dc <namex+0x10c>
  if(*path == 0)
    800040e6:	c79d                	beqz	a5,80004114 <namex+0x144>
    path++;
    800040e8:	85a6                	mv	a1,s1
  len = path - s;
    800040ea:	8cda                	mv	s9,s6
    800040ec:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    800040ee:	01278963          	beq	a5,s2,80004100 <namex+0x130>
    800040f2:	dfbd                	beqz	a5,80004070 <namex+0xa0>
    path++;
    800040f4:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800040f6:	0004c783          	lbu	a5,0(s1)
    800040fa:	ff279ce3          	bne	a5,s2,800040f2 <namex+0x122>
    800040fe:	bf8d                	j	80004070 <namex+0xa0>
    memmove(name, s, len);
    80004100:	2601                	sext.w	a2,a2
    80004102:	8552                	mv	a0,s4
    80004104:	ffffd097          	auipc	ra,0xffffd
    80004108:	c16080e7          	jalr	-1002(ra) # 80000d1a <memmove>
    name[len] = 0;
    8000410c:	9cd2                	add	s9,s9,s4
    8000410e:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80004112:	bf9d                	j	80004088 <namex+0xb8>
  if(nameiparent){
    80004114:	f20a83e3          	beqz	s5,8000403a <namex+0x6a>
    iput(ip);
    80004118:	854e                	mv	a0,s3
    8000411a:	00000097          	auipc	ra,0x0
    8000411e:	adc080e7          	jalr	-1316(ra) # 80003bf6 <iput>
    return 0;
    80004122:	4981                	li	s3,0
    80004124:	bf19                	j	8000403a <namex+0x6a>
  if(*path == 0)
    80004126:	d7fd                	beqz	a5,80004114 <namex+0x144>
  while(*path != '/' && *path != 0)
    80004128:	0004c783          	lbu	a5,0(s1)
    8000412c:	85a6                	mv	a1,s1
    8000412e:	b7d1                	j	800040f2 <namex+0x122>

0000000080004130 <dirlink>:
{
    80004130:	7139                	addi	sp,sp,-64
    80004132:	fc06                	sd	ra,56(sp)
    80004134:	f822                	sd	s0,48(sp)
    80004136:	f426                	sd	s1,40(sp)
    80004138:	f04a                	sd	s2,32(sp)
    8000413a:	ec4e                	sd	s3,24(sp)
    8000413c:	e852                	sd	s4,16(sp)
    8000413e:	0080                	addi	s0,sp,64
    80004140:	892a                	mv	s2,a0
    80004142:	8a2e                	mv	s4,a1
    80004144:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004146:	4601                	li	a2,0
    80004148:	00000097          	auipc	ra,0x0
    8000414c:	dd8080e7          	jalr	-552(ra) # 80003f20 <dirlookup>
    80004150:	e93d                	bnez	a0,800041c6 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004152:	04c92483          	lw	s1,76(s2)
    80004156:	c49d                	beqz	s1,80004184 <dirlink+0x54>
    80004158:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000415a:	4741                	li	a4,16
    8000415c:	86a6                	mv	a3,s1
    8000415e:	fc040613          	addi	a2,s0,-64
    80004162:	4581                	li	a1,0
    80004164:	854a                	mv	a0,s2
    80004166:	00000097          	auipc	ra,0x0
    8000416a:	b8a080e7          	jalr	-1142(ra) # 80003cf0 <readi>
    8000416e:	47c1                	li	a5,16
    80004170:	06f51163          	bne	a0,a5,800041d2 <dirlink+0xa2>
    if(de.inum == 0)
    80004174:	fc045783          	lhu	a5,-64(s0)
    80004178:	c791                	beqz	a5,80004184 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000417a:	24c1                	addiw	s1,s1,16
    8000417c:	04c92783          	lw	a5,76(s2)
    80004180:	fcf4ede3          	bltu	s1,a5,8000415a <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80004184:	4639                	li	a2,14
    80004186:	85d2                	mv	a1,s4
    80004188:	fc240513          	addi	a0,s0,-62
    8000418c:	ffffd097          	auipc	ra,0xffffd
    80004190:	c46080e7          	jalr	-954(ra) # 80000dd2 <strncpy>
  de.inum = inum;
    80004194:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004198:	4741                	li	a4,16
    8000419a:	86a6                	mv	a3,s1
    8000419c:	fc040613          	addi	a2,s0,-64
    800041a0:	4581                	li	a1,0
    800041a2:	854a                	mv	a0,s2
    800041a4:	00000097          	auipc	ra,0x0
    800041a8:	c44080e7          	jalr	-956(ra) # 80003de8 <writei>
    800041ac:	872a                	mv	a4,a0
    800041ae:	47c1                	li	a5,16
  return 0;
    800041b0:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800041b2:	02f71863          	bne	a4,a5,800041e2 <dirlink+0xb2>
}
    800041b6:	70e2                	ld	ra,56(sp)
    800041b8:	7442                	ld	s0,48(sp)
    800041ba:	74a2                	ld	s1,40(sp)
    800041bc:	7902                	ld	s2,32(sp)
    800041be:	69e2                	ld	s3,24(sp)
    800041c0:	6a42                	ld	s4,16(sp)
    800041c2:	6121                	addi	sp,sp,64
    800041c4:	8082                	ret
    iput(ip);
    800041c6:	00000097          	auipc	ra,0x0
    800041ca:	a30080e7          	jalr	-1488(ra) # 80003bf6 <iput>
    return -1;
    800041ce:	557d                	li	a0,-1
    800041d0:	b7dd                	j	800041b6 <dirlink+0x86>
      panic("dirlink read");
    800041d2:	00004517          	auipc	a0,0x4
    800041d6:	53e50513          	addi	a0,a0,1342 # 80008710 <syscalls+0x1d0>
    800041da:	ffffc097          	auipc	ra,0xffffc
    800041de:	350080e7          	jalr	848(ra) # 8000052a <panic>
    panic("dirlink");
    800041e2:	00004517          	auipc	a0,0x4
    800041e6:	63650513          	addi	a0,a0,1590 # 80008818 <syscalls+0x2d8>
    800041ea:	ffffc097          	auipc	ra,0xffffc
    800041ee:	340080e7          	jalr	832(ra) # 8000052a <panic>

00000000800041f2 <namei>:

struct inode*
namei(char *path)
{
    800041f2:	1101                	addi	sp,sp,-32
    800041f4:	ec06                	sd	ra,24(sp)
    800041f6:	e822                	sd	s0,16(sp)
    800041f8:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800041fa:	fe040613          	addi	a2,s0,-32
    800041fe:	4581                	li	a1,0
    80004200:	00000097          	auipc	ra,0x0
    80004204:	dd0080e7          	jalr	-560(ra) # 80003fd0 <namex>
}
    80004208:	60e2                	ld	ra,24(sp)
    8000420a:	6442                	ld	s0,16(sp)
    8000420c:	6105                	addi	sp,sp,32
    8000420e:	8082                	ret

0000000080004210 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004210:	1141                	addi	sp,sp,-16
    80004212:	e406                	sd	ra,8(sp)
    80004214:	e022                	sd	s0,0(sp)
    80004216:	0800                	addi	s0,sp,16
    80004218:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000421a:	4585                	li	a1,1
    8000421c:	00000097          	auipc	ra,0x0
    80004220:	db4080e7          	jalr	-588(ra) # 80003fd0 <namex>
}
    80004224:	60a2                	ld	ra,8(sp)
    80004226:	6402                	ld	s0,0(sp)
    80004228:	0141                	addi	sp,sp,16
    8000422a:	8082                	ret

000000008000422c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000422c:	1101                	addi	sp,sp,-32
    8000422e:	ec06                	sd	ra,24(sp)
    80004230:	e822                	sd	s0,16(sp)
    80004232:	e426                	sd	s1,8(sp)
    80004234:	e04a                	sd	s2,0(sp)
    80004236:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004238:	0001d917          	auipc	s2,0x1d
    8000423c:	43890913          	addi	s2,s2,1080 # 80021670 <log>
    80004240:	01892583          	lw	a1,24(s2)
    80004244:	02892503          	lw	a0,40(s2)
    80004248:	fffff097          	auipc	ra,0xfffff
    8000424c:	ff2080e7          	jalr	-14(ra) # 8000323a <bread>
    80004250:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004252:	02c92683          	lw	a3,44(s2)
    80004256:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004258:	02d05763          	blez	a3,80004286 <write_head+0x5a>
    8000425c:	0001d797          	auipc	a5,0x1d
    80004260:	44478793          	addi	a5,a5,1092 # 800216a0 <log+0x30>
    80004264:	05c50713          	addi	a4,a0,92
    80004268:	36fd                	addiw	a3,a3,-1
    8000426a:	1682                	slli	a3,a3,0x20
    8000426c:	9281                	srli	a3,a3,0x20
    8000426e:	068a                	slli	a3,a3,0x2
    80004270:	0001d617          	auipc	a2,0x1d
    80004274:	43460613          	addi	a2,a2,1076 # 800216a4 <log+0x34>
    80004278:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000427a:	4390                	lw	a2,0(a5)
    8000427c:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000427e:	0791                	addi	a5,a5,4
    80004280:	0711                	addi	a4,a4,4
    80004282:	fed79ce3          	bne	a5,a3,8000427a <write_head+0x4e>
  }
  bwrite(buf);
    80004286:	8526                	mv	a0,s1
    80004288:	fffff097          	auipc	ra,0xfffff
    8000428c:	0a4080e7          	jalr	164(ra) # 8000332c <bwrite>
  brelse(buf);
    80004290:	8526                	mv	a0,s1
    80004292:	fffff097          	auipc	ra,0xfffff
    80004296:	0d8080e7          	jalr	216(ra) # 8000336a <brelse>
}
    8000429a:	60e2                	ld	ra,24(sp)
    8000429c:	6442                	ld	s0,16(sp)
    8000429e:	64a2                	ld	s1,8(sp)
    800042a0:	6902                	ld	s2,0(sp)
    800042a2:	6105                	addi	sp,sp,32
    800042a4:	8082                	ret

00000000800042a6 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800042a6:	0001d797          	auipc	a5,0x1d
    800042aa:	3f67a783          	lw	a5,1014(a5) # 8002169c <log+0x2c>
    800042ae:	0af05d63          	blez	a5,80004368 <install_trans+0xc2>
{
    800042b2:	7139                	addi	sp,sp,-64
    800042b4:	fc06                	sd	ra,56(sp)
    800042b6:	f822                	sd	s0,48(sp)
    800042b8:	f426                	sd	s1,40(sp)
    800042ba:	f04a                	sd	s2,32(sp)
    800042bc:	ec4e                	sd	s3,24(sp)
    800042be:	e852                	sd	s4,16(sp)
    800042c0:	e456                	sd	s5,8(sp)
    800042c2:	e05a                	sd	s6,0(sp)
    800042c4:	0080                	addi	s0,sp,64
    800042c6:	8b2a                	mv	s6,a0
    800042c8:	0001da97          	auipc	s5,0x1d
    800042cc:	3d8a8a93          	addi	s5,s5,984 # 800216a0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800042d0:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800042d2:	0001d997          	auipc	s3,0x1d
    800042d6:	39e98993          	addi	s3,s3,926 # 80021670 <log>
    800042da:	a00d                	j	800042fc <install_trans+0x56>
    brelse(lbuf);
    800042dc:	854a                	mv	a0,s2
    800042de:	fffff097          	auipc	ra,0xfffff
    800042e2:	08c080e7          	jalr	140(ra) # 8000336a <brelse>
    brelse(dbuf);
    800042e6:	8526                	mv	a0,s1
    800042e8:	fffff097          	auipc	ra,0xfffff
    800042ec:	082080e7          	jalr	130(ra) # 8000336a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800042f0:	2a05                	addiw	s4,s4,1
    800042f2:	0a91                	addi	s5,s5,4
    800042f4:	02c9a783          	lw	a5,44(s3)
    800042f8:	04fa5e63          	bge	s4,a5,80004354 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800042fc:	0189a583          	lw	a1,24(s3)
    80004300:	014585bb          	addw	a1,a1,s4
    80004304:	2585                	addiw	a1,a1,1
    80004306:	0289a503          	lw	a0,40(s3)
    8000430a:	fffff097          	auipc	ra,0xfffff
    8000430e:	f30080e7          	jalr	-208(ra) # 8000323a <bread>
    80004312:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004314:	000aa583          	lw	a1,0(s5)
    80004318:	0289a503          	lw	a0,40(s3)
    8000431c:	fffff097          	auipc	ra,0xfffff
    80004320:	f1e080e7          	jalr	-226(ra) # 8000323a <bread>
    80004324:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004326:	40000613          	li	a2,1024
    8000432a:	05890593          	addi	a1,s2,88
    8000432e:	05850513          	addi	a0,a0,88
    80004332:	ffffd097          	auipc	ra,0xffffd
    80004336:	9e8080e7          	jalr	-1560(ra) # 80000d1a <memmove>
    bwrite(dbuf);  // write dst to disk
    8000433a:	8526                	mv	a0,s1
    8000433c:	fffff097          	auipc	ra,0xfffff
    80004340:	ff0080e7          	jalr	-16(ra) # 8000332c <bwrite>
    if(recovering == 0)
    80004344:	f80b1ce3          	bnez	s6,800042dc <install_trans+0x36>
      bunpin(dbuf);
    80004348:	8526                	mv	a0,s1
    8000434a:	fffff097          	auipc	ra,0xfffff
    8000434e:	0fa080e7          	jalr	250(ra) # 80003444 <bunpin>
    80004352:	b769                	j	800042dc <install_trans+0x36>
}
    80004354:	70e2                	ld	ra,56(sp)
    80004356:	7442                	ld	s0,48(sp)
    80004358:	74a2                	ld	s1,40(sp)
    8000435a:	7902                	ld	s2,32(sp)
    8000435c:	69e2                	ld	s3,24(sp)
    8000435e:	6a42                	ld	s4,16(sp)
    80004360:	6aa2                	ld	s5,8(sp)
    80004362:	6b02                	ld	s6,0(sp)
    80004364:	6121                	addi	sp,sp,64
    80004366:	8082                	ret
    80004368:	8082                	ret

000000008000436a <initlog>:
{
    8000436a:	7179                	addi	sp,sp,-48
    8000436c:	f406                	sd	ra,40(sp)
    8000436e:	f022                	sd	s0,32(sp)
    80004370:	ec26                	sd	s1,24(sp)
    80004372:	e84a                	sd	s2,16(sp)
    80004374:	e44e                	sd	s3,8(sp)
    80004376:	1800                	addi	s0,sp,48
    80004378:	892a                	mv	s2,a0
    8000437a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000437c:	0001d497          	auipc	s1,0x1d
    80004380:	2f448493          	addi	s1,s1,756 # 80021670 <log>
    80004384:	00004597          	auipc	a1,0x4
    80004388:	39c58593          	addi	a1,a1,924 # 80008720 <syscalls+0x1e0>
    8000438c:	8526                	mv	a0,s1
    8000438e:	ffffc097          	auipc	ra,0xffffc
    80004392:	7a4080e7          	jalr	1956(ra) # 80000b32 <initlock>
  log.start = sb->logstart;
    80004396:	0149a583          	lw	a1,20(s3)
    8000439a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000439c:	0109a783          	lw	a5,16(s3)
    800043a0:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800043a2:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800043a6:	854a                	mv	a0,s2
    800043a8:	fffff097          	auipc	ra,0xfffff
    800043ac:	e92080e7          	jalr	-366(ra) # 8000323a <bread>
  log.lh.n = lh->n;
    800043b0:	4d34                	lw	a3,88(a0)
    800043b2:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800043b4:	02d05563          	blez	a3,800043de <initlog+0x74>
    800043b8:	05c50793          	addi	a5,a0,92
    800043bc:	0001d717          	auipc	a4,0x1d
    800043c0:	2e470713          	addi	a4,a4,740 # 800216a0 <log+0x30>
    800043c4:	36fd                	addiw	a3,a3,-1
    800043c6:	1682                	slli	a3,a3,0x20
    800043c8:	9281                	srli	a3,a3,0x20
    800043ca:	068a                	slli	a3,a3,0x2
    800043cc:	06050613          	addi	a2,a0,96
    800043d0:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800043d2:	4390                	lw	a2,0(a5)
    800043d4:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800043d6:	0791                	addi	a5,a5,4
    800043d8:	0711                	addi	a4,a4,4
    800043da:	fed79ce3          	bne	a5,a3,800043d2 <initlog+0x68>
  brelse(buf);
    800043de:	fffff097          	auipc	ra,0xfffff
    800043e2:	f8c080e7          	jalr	-116(ra) # 8000336a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800043e6:	4505                	li	a0,1
    800043e8:	00000097          	auipc	ra,0x0
    800043ec:	ebe080e7          	jalr	-322(ra) # 800042a6 <install_trans>
  log.lh.n = 0;
    800043f0:	0001d797          	auipc	a5,0x1d
    800043f4:	2a07a623          	sw	zero,684(a5) # 8002169c <log+0x2c>
  write_head(); // clear the log
    800043f8:	00000097          	auipc	ra,0x0
    800043fc:	e34080e7          	jalr	-460(ra) # 8000422c <write_head>
}
    80004400:	70a2                	ld	ra,40(sp)
    80004402:	7402                	ld	s0,32(sp)
    80004404:	64e2                	ld	s1,24(sp)
    80004406:	6942                	ld	s2,16(sp)
    80004408:	69a2                	ld	s3,8(sp)
    8000440a:	6145                	addi	sp,sp,48
    8000440c:	8082                	ret

000000008000440e <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000440e:	1101                	addi	sp,sp,-32
    80004410:	ec06                	sd	ra,24(sp)
    80004412:	e822                	sd	s0,16(sp)
    80004414:	e426                	sd	s1,8(sp)
    80004416:	e04a                	sd	s2,0(sp)
    80004418:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000441a:	0001d517          	auipc	a0,0x1d
    8000441e:	25650513          	addi	a0,a0,598 # 80021670 <log>
    80004422:	ffffc097          	auipc	ra,0xffffc
    80004426:	7a0080e7          	jalr	1952(ra) # 80000bc2 <acquire>
  while(1){
    if(log.committing){
    8000442a:	0001d497          	auipc	s1,0x1d
    8000442e:	24648493          	addi	s1,s1,582 # 80021670 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004432:	4979                	li	s2,30
    80004434:	a039                	j	80004442 <begin_op+0x34>
      sleep(&log, &log.lock);
    80004436:	85a6                	mv	a1,s1
    80004438:	8526                	mv	a0,s1
    8000443a:	ffffe097          	auipc	ra,0xffffe
    8000443e:	02a080e7          	jalr	42(ra) # 80002464 <sleep>
    if(log.committing){
    80004442:	50dc                	lw	a5,36(s1)
    80004444:	fbed                	bnez	a5,80004436 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004446:	509c                	lw	a5,32(s1)
    80004448:	0017871b          	addiw	a4,a5,1
    8000444c:	0007069b          	sext.w	a3,a4
    80004450:	0027179b          	slliw	a5,a4,0x2
    80004454:	9fb9                	addw	a5,a5,a4
    80004456:	0017979b          	slliw	a5,a5,0x1
    8000445a:	54d8                	lw	a4,44(s1)
    8000445c:	9fb9                	addw	a5,a5,a4
    8000445e:	00f95963          	bge	s2,a5,80004470 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004462:	85a6                	mv	a1,s1
    80004464:	8526                	mv	a0,s1
    80004466:	ffffe097          	auipc	ra,0xffffe
    8000446a:	ffe080e7          	jalr	-2(ra) # 80002464 <sleep>
    8000446e:	bfd1                	j	80004442 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004470:	0001d517          	auipc	a0,0x1d
    80004474:	20050513          	addi	a0,a0,512 # 80021670 <log>
    80004478:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000447a:	ffffc097          	auipc	ra,0xffffc
    8000447e:	7fc080e7          	jalr	2044(ra) # 80000c76 <release>
      break;
    }
  }
}
    80004482:	60e2                	ld	ra,24(sp)
    80004484:	6442                	ld	s0,16(sp)
    80004486:	64a2                	ld	s1,8(sp)
    80004488:	6902                	ld	s2,0(sp)
    8000448a:	6105                	addi	sp,sp,32
    8000448c:	8082                	ret

000000008000448e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000448e:	7139                	addi	sp,sp,-64
    80004490:	fc06                	sd	ra,56(sp)
    80004492:	f822                	sd	s0,48(sp)
    80004494:	f426                	sd	s1,40(sp)
    80004496:	f04a                	sd	s2,32(sp)
    80004498:	ec4e                	sd	s3,24(sp)
    8000449a:	e852                	sd	s4,16(sp)
    8000449c:	e456                	sd	s5,8(sp)
    8000449e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800044a0:	0001d497          	auipc	s1,0x1d
    800044a4:	1d048493          	addi	s1,s1,464 # 80021670 <log>
    800044a8:	8526                	mv	a0,s1
    800044aa:	ffffc097          	auipc	ra,0xffffc
    800044ae:	718080e7          	jalr	1816(ra) # 80000bc2 <acquire>
  log.outstanding -= 1;
    800044b2:	509c                	lw	a5,32(s1)
    800044b4:	37fd                	addiw	a5,a5,-1
    800044b6:	0007891b          	sext.w	s2,a5
    800044ba:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800044bc:	50dc                	lw	a5,36(s1)
    800044be:	e7b9                	bnez	a5,8000450c <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800044c0:	04091e63          	bnez	s2,8000451c <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800044c4:	0001d497          	auipc	s1,0x1d
    800044c8:	1ac48493          	addi	s1,s1,428 # 80021670 <log>
    800044cc:	4785                	li	a5,1
    800044ce:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800044d0:	8526                	mv	a0,s1
    800044d2:	ffffc097          	auipc	ra,0xffffc
    800044d6:	7a4080e7          	jalr	1956(ra) # 80000c76 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800044da:	54dc                	lw	a5,44(s1)
    800044dc:	06f04763          	bgtz	a5,8000454a <end_op+0xbc>
    acquire(&log.lock);
    800044e0:	0001d497          	auipc	s1,0x1d
    800044e4:	19048493          	addi	s1,s1,400 # 80021670 <log>
    800044e8:	8526                	mv	a0,s1
    800044ea:	ffffc097          	auipc	ra,0xffffc
    800044ee:	6d8080e7          	jalr	1752(ra) # 80000bc2 <acquire>
    log.committing = 0;
    800044f2:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800044f6:	8526                	mv	a0,s1
    800044f8:	ffffe097          	auipc	ra,0xffffe
    800044fc:	0f8080e7          	jalr	248(ra) # 800025f0 <wakeup>
    release(&log.lock);
    80004500:	8526                	mv	a0,s1
    80004502:	ffffc097          	auipc	ra,0xffffc
    80004506:	774080e7          	jalr	1908(ra) # 80000c76 <release>
}
    8000450a:	a03d                	j	80004538 <end_op+0xaa>
    panic("log.committing");
    8000450c:	00004517          	auipc	a0,0x4
    80004510:	21c50513          	addi	a0,a0,540 # 80008728 <syscalls+0x1e8>
    80004514:	ffffc097          	auipc	ra,0xffffc
    80004518:	016080e7          	jalr	22(ra) # 8000052a <panic>
    wakeup(&log);
    8000451c:	0001d497          	auipc	s1,0x1d
    80004520:	15448493          	addi	s1,s1,340 # 80021670 <log>
    80004524:	8526                	mv	a0,s1
    80004526:	ffffe097          	auipc	ra,0xffffe
    8000452a:	0ca080e7          	jalr	202(ra) # 800025f0 <wakeup>
  release(&log.lock);
    8000452e:	8526                	mv	a0,s1
    80004530:	ffffc097          	auipc	ra,0xffffc
    80004534:	746080e7          	jalr	1862(ra) # 80000c76 <release>
}
    80004538:	70e2                	ld	ra,56(sp)
    8000453a:	7442                	ld	s0,48(sp)
    8000453c:	74a2                	ld	s1,40(sp)
    8000453e:	7902                	ld	s2,32(sp)
    80004540:	69e2                	ld	s3,24(sp)
    80004542:	6a42                	ld	s4,16(sp)
    80004544:	6aa2                	ld	s5,8(sp)
    80004546:	6121                	addi	sp,sp,64
    80004548:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    8000454a:	0001da97          	auipc	s5,0x1d
    8000454e:	156a8a93          	addi	s5,s5,342 # 800216a0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004552:	0001da17          	auipc	s4,0x1d
    80004556:	11ea0a13          	addi	s4,s4,286 # 80021670 <log>
    8000455a:	018a2583          	lw	a1,24(s4)
    8000455e:	012585bb          	addw	a1,a1,s2
    80004562:	2585                	addiw	a1,a1,1
    80004564:	028a2503          	lw	a0,40(s4)
    80004568:	fffff097          	auipc	ra,0xfffff
    8000456c:	cd2080e7          	jalr	-814(ra) # 8000323a <bread>
    80004570:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004572:	000aa583          	lw	a1,0(s5)
    80004576:	028a2503          	lw	a0,40(s4)
    8000457a:	fffff097          	auipc	ra,0xfffff
    8000457e:	cc0080e7          	jalr	-832(ra) # 8000323a <bread>
    80004582:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004584:	40000613          	li	a2,1024
    80004588:	05850593          	addi	a1,a0,88
    8000458c:	05848513          	addi	a0,s1,88
    80004590:	ffffc097          	auipc	ra,0xffffc
    80004594:	78a080e7          	jalr	1930(ra) # 80000d1a <memmove>
    bwrite(to);  // write the log
    80004598:	8526                	mv	a0,s1
    8000459a:	fffff097          	auipc	ra,0xfffff
    8000459e:	d92080e7          	jalr	-622(ra) # 8000332c <bwrite>
    brelse(from);
    800045a2:	854e                	mv	a0,s3
    800045a4:	fffff097          	auipc	ra,0xfffff
    800045a8:	dc6080e7          	jalr	-570(ra) # 8000336a <brelse>
    brelse(to);
    800045ac:	8526                	mv	a0,s1
    800045ae:	fffff097          	auipc	ra,0xfffff
    800045b2:	dbc080e7          	jalr	-580(ra) # 8000336a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800045b6:	2905                	addiw	s2,s2,1
    800045b8:	0a91                	addi	s5,s5,4
    800045ba:	02ca2783          	lw	a5,44(s4)
    800045be:	f8f94ee3          	blt	s2,a5,8000455a <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800045c2:	00000097          	auipc	ra,0x0
    800045c6:	c6a080e7          	jalr	-918(ra) # 8000422c <write_head>
    install_trans(0); // Now install writes to home locations
    800045ca:	4501                	li	a0,0
    800045cc:	00000097          	auipc	ra,0x0
    800045d0:	cda080e7          	jalr	-806(ra) # 800042a6 <install_trans>
    log.lh.n = 0;
    800045d4:	0001d797          	auipc	a5,0x1d
    800045d8:	0c07a423          	sw	zero,200(a5) # 8002169c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800045dc:	00000097          	auipc	ra,0x0
    800045e0:	c50080e7          	jalr	-944(ra) # 8000422c <write_head>
    800045e4:	bdf5                	j	800044e0 <end_op+0x52>

00000000800045e6 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800045e6:	1101                	addi	sp,sp,-32
    800045e8:	ec06                	sd	ra,24(sp)
    800045ea:	e822                	sd	s0,16(sp)
    800045ec:	e426                	sd	s1,8(sp)
    800045ee:	e04a                	sd	s2,0(sp)
    800045f0:	1000                	addi	s0,sp,32
    800045f2:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800045f4:	0001d917          	auipc	s2,0x1d
    800045f8:	07c90913          	addi	s2,s2,124 # 80021670 <log>
    800045fc:	854a                	mv	a0,s2
    800045fe:	ffffc097          	auipc	ra,0xffffc
    80004602:	5c4080e7          	jalr	1476(ra) # 80000bc2 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004606:	02c92603          	lw	a2,44(s2)
    8000460a:	47f5                	li	a5,29
    8000460c:	06c7c563          	blt	a5,a2,80004676 <log_write+0x90>
    80004610:	0001d797          	auipc	a5,0x1d
    80004614:	07c7a783          	lw	a5,124(a5) # 8002168c <log+0x1c>
    80004618:	37fd                	addiw	a5,a5,-1
    8000461a:	04f65e63          	bge	a2,a5,80004676 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000461e:	0001d797          	auipc	a5,0x1d
    80004622:	0727a783          	lw	a5,114(a5) # 80021690 <log+0x20>
    80004626:	06f05063          	blez	a5,80004686 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000462a:	4781                	li	a5,0
    8000462c:	06c05563          	blez	a2,80004696 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80004630:	44cc                	lw	a1,12(s1)
    80004632:	0001d717          	auipc	a4,0x1d
    80004636:	06e70713          	addi	a4,a4,110 # 800216a0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000463a:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    8000463c:	4314                	lw	a3,0(a4)
    8000463e:	04b68c63          	beq	a3,a1,80004696 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80004642:	2785                	addiw	a5,a5,1
    80004644:	0711                	addi	a4,a4,4
    80004646:	fef61be3          	bne	a2,a5,8000463c <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000464a:	0621                	addi	a2,a2,8
    8000464c:	060a                	slli	a2,a2,0x2
    8000464e:	0001d797          	auipc	a5,0x1d
    80004652:	02278793          	addi	a5,a5,34 # 80021670 <log>
    80004656:	963e                	add	a2,a2,a5
    80004658:	44dc                	lw	a5,12(s1)
    8000465a:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000465c:	8526                	mv	a0,s1
    8000465e:	fffff097          	auipc	ra,0xfffff
    80004662:	daa080e7          	jalr	-598(ra) # 80003408 <bpin>
    log.lh.n++;
    80004666:	0001d717          	auipc	a4,0x1d
    8000466a:	00a70713          	addi	a4,a4,10 # 80021670 <log>
    8000466e:	575c                	lw	a5,44(a4)
    80004670:	2785                	addiw	a5,a5,1
    80004672:	d75c                	sw	a5,44(a4)
    80004674:	a835                	j	800046b0 <log_write+0xca>
    panic("too big a transaction");
    80004676:	00004517          	auipc	a0,0x4
    8000467a:	0c250513          	addi	a0,a0,194 # 80008738 <syscalls+0x1f8>
    8000467e:	ffffc097          	auipc	ra,0xffffc
    80004682:	eac080e7          	jalr	-340(ra) # 8000052a <panic>
    panic("log_write outside of trans");
    80004686:	00004517          	auipc	a0,0x4
    8000468a:	0ca50513          	addi	a0,a0,202 # 80008750 <syscalls+0x210>
    8000468e:	ffffc097          	auipc	ra,0xffffc
    80004692:	e9c080e7          	jalr	-356(ra) # 8000052a <panic>
  log.lh.block[i] = b->blockno;
    80004696:	00878713          	addi	a4,a5,8
    8000469a:	00271693          	slli	a3,a4,0x2
    8000469e:	0001d717          	auipc	a4,0x1d
    800046a2:	fd270713          	addi	a4,a4,-46 # 80021670 <log>
    800046a6:	9736                	add	a4,a4,a3
    800046a8:	44d4                	lw	a3,12(s1)
    800046aa:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800046ac:	faf608e3          	beq	a2,a5,8000465c <log_write+0x76>
  }
  release(&log.lock);
    800046b0:	0001d517          	auipc	a0,0x1d
    800046b4:	fc050513          	addi	a0,a0,-64 # 80021670 <log>
    800046b8:	ffffc097          	auipc	ra,0xffffc
    800046bc:	5be080e7          	jalr	1470(ra) # 80000c76 <release>
}
    800046c0:	60e2                	ld	ra,24(sp)
    800046c2:	6442                	ld	s0,16(sp)
    800046c4:	64a2                	ld	s1,8(sp)
    800046c6:	6902                	ld	s2,0(sp)
    800046c8:	6105                	addi	sp,sp,32
    800046ca:	8082                	ret

00000000800046cc <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800046cc:	1101                	addi	sp,sp,-32
    800046ce:	ec06                	sd	ra,24(sp)
    800046d0:	e822                	sd	s0,16(sp)
    800046d2:	e426                	sd	s1,8(sp)
    800046d4:	e04a                	sd	s2,0(sp)
    800046d6:	1000                	addi	s0,sp,32
    800046d8:	84aa                	mv	s1,a0
    800046da:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800046dc:	00004597          	auipc	a1,0x4
    800046e0:	09458593          	addi	a1,a1,148 # 80008770 <syscalls+0x230>
    800046e4:	0521                	addi	a0,a0,8
    800046e6:	ffffc097          	auipc	ra,0xffffc
    800046ea:	44c080e7          	jalr	1100(ra) # 80000b32 <initlock>
  lk->name = name;
    800046ee:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800046f2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800046f6:	0204a423          	sw	zero,40(s1)
}
    800046fa:	60e2                	ld	ra,24(sp)
    800046fc:	6442                	ld	s0,16(sp)
    800046fe:	64a2                	ld	s1,8(sp)
    80004700:	6902                	ld	s2,0(sp)
    80004702:	6105                	addi	sp,sp,32
    80004704:	8082                	ret

0000000080004706 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004706:	1101                	addi	sp,sp,-32
    80004708:	ec06                	sd	ra,24(sp)
    8000470a:	e822                	sd	s0,16(sp)
    8000470c:	e426                	sd	s1,8(sp)
    8000470e:	e04a                	sd	s2,0(sp)
    80004710:	1000                	addi	s0,sp,32
    80004712:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004714:	00850913          	addi	s2,a0,8
    80004718:	854a                	mv	a0,s2
    8000471a:	ffffc097          	auipc	ra,0xffffc
    8000471e:	4a8080e7          	jalr	1192(ra) # 80000bc2 <acquire>
  while (lk->locked) {
    80004722:	409c                	lw	a5,0(s1)
    80004724:	cb89                	beqz	a5,80004736 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004726:	85ca                	mv	a1,s2
    80004728:	8526                	mv	a0,s1
    8000472a:	ffffe097          	auipc	ra,0xffffe
    8000472e:	d3a080e7          	jalr	-710(ra) # 80002464 <sleep>
  while (lk->locked) {
    80004732:	409c                	lw	a5,0(s1)
    80004734:	fbed                	bnez	a5,80004726 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004736:	4785                	li	a5,1
    80004738:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000473a:	ffffd097          	auipc	ra,0xffffd
    8000473e:	4ba080e7          	jalr	1210(ra) # 80001bf4 <myproc>
    80004742:	591c                	lw	a5,48(a0)
    80004744:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004746:	854a                	mv	a0,s2
    80004748:	ffffc097          	auipc	ra,0xffffc
    8000474c:	52e080e7          	jalr	1326(ra) # 80000c76 <release>
}
    80004750:	60e2                	ld	ra,24(sp)
    80004752:	6442                	ld	s0,16(sp)
    80004754:	64a2                	ld	s1,8(sp)
    80004756:	6902                	ld	s2,0(sp)
    80004758:	6105                	addi	sp,sp,32
    8000475a:	8082                	ret

000000008000475c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000475c:	1101                	addi	sp,sp,-32
    8000475e:	ec06                	sd	ra,24(sp)
    80004760:	e822                	sd	s0,16(sp)
    80004762:	e426                	sd	s1,8(sp)
    80004764:	e04a                	sd	s2,0(sp)
    80004766:	1000                	addi	s0,sp,32
    80004768:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000476a:	00850913          	addi	s2,a0,8
    8000476e:	854a                	mv	a0,s2
    80004770:	ffffc097          	auipc	ra,0xffffc
    80004774:	452080e7          	jalr	1106(ra) # 80000bc2 <acquire>
  lk->locked = 0;
    80004778:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000477c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004780:	8526                	mv	a0,s1
    80004782:	ffffe097          	auipc	ra,0xffffe
    80004786:	e6e080e7          	jalr	-402(ra) # 800025f0 <wakeup>
  release(&lk->lk);
    8000478a:	854a                	mv	a0,s2
    8000478c:	ffffc097          	auipc	ra,0xffffc
    80004790:	4ea080e7          	jalr	1258(ra) # 80000c76 <release>
}
    80004794:	60e2                	ld	ra,24(sp)
    80004796:	6442                	ld	s0,16(sp)
    80004798:	64a2                	ld	s1,8(sp)
    8000479a:	6902                	ld	s2,0(sp)
    8000479c:	6105                	addi	sp,sp,32
    8000479e:	8082                	ret

00000000800047a0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800047a0:	7179                	addi	sp,sp,-48
    800047a2:	f406                	sd	ra,40(sp)
    800047a4:	f022                	sd	s0,32(sp)
    800047a6:	ec26                	sd	s1,24(sp)
    800047a8:	e84a                	sd	s2,16(sp)
    800047aa:	e44e                	sd	s3,8(sp)
    800047ac:	1800                	addi	s0,sp,48
    800047ae:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800047b0:	00850913          	addi	s2,a0,8
    800047b4:	854a                	mv	a0,s2
    800047b6:	ffffc097          	auipc	ra,0xffffc
    800047ba:	40c080e7          	jalr	1036(ra) # 80000bc2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800047be:	409c                	lw	a5,0(s1)
    800047c0:	ef99                	bnez	a5,800047de <holdingsleep+0x3e>
    800047c2:	4481                	li	s1,0
  release(&lk->lk);
    800047c4:	854a                	mv	a0,s2
    800047c6:	ffffc097          	auipc	ra,0xffffc
    800047ca:	4b0080e7          	jalr	1200(ra) # 80000c76 <release>
  return r;
}
    800047ce:	8526                	mv	a0,s1
    800047d0:	70a2                	ld	ra,40(sp)
    800047d2:	7402                	ld	s0,32(sp)
    800047d4:	64e2                	ld	s1,24(sp)
    800047d6:	6942                	ld	s2,16(sp)
    800047d8:	69a2                	ld	s3,8(sp)
    800047da:	6145                	addi	sp,sp,48
    800047dc:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800047de:	0284a983          	lw	s3,40(s1)
    800047e2:	ffffd097          	auipc	ra,0xffffd
    800047e6:	412080e7          	jalr	1042(ra) # 80001bf4 <myproc>
    800047ea:	5904                	lw	s1,48(a0)
    800047ec:	413484b3          	sub	s1,s1,s3
    800047f0:	0014b493          	seqz	s1,s1
    800047f4:	bfc1                	j	800047c4 <holdingsleep+0x24>

00000000800047f6 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800047f6:	1141                	addi	sp,sp,-16
    800047f8:	e406                	sd	ra,8(sp)
    800047fa:	e022                	sd	s0,0(sp)
    800047fc:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800047fe:	00004597          	auipc	a1,0x4
    80004802:	f8258593          	addi	a1,a1,-126 # 80008780 <syscalls+0x240>
    80004806:	0001d517          	auipc	a0,0x1d
    8000480a:	fb250513          	addi	a0,a0,-78 # 800217b8 <ftable>
    8000480e:	ffffc097          	auipc	ra,0xffffc
    80004812:	324080e7          	jalr	804(ra) # 80000b32 <initlock>
}
    80004816:	60a2                	ld	ra,8(sp)
    80004818:	6402                	ld	s0,0(sp)
    8000481a:	0141                	addi	sp,sp,16
    8000481c:	8082                	ret

000000008000481e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000481e:	1101                	addi	sp,sp,-32
    80004820:	ec06                	sd	ra,24(sp)
    80004822:	e822                	sd	s0,16(sp)
    80004824:	e426                	sd	s1,8(sp)
    80004826:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004828:	0001d517          	auipc	a0,0x1d
    8000482c:	f9050513          	addi	a0,a0,-112 # 800217b8 <ftable>
    80004830:	ffffc097          	auipc	ra,0xffffc
    80004834:	392080e7          	jalr	914(ra) # 80000bc2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004838:	0001d497          	auipc	s1,0x1d
    8000483c:	f9848493          	addi	s1,s1,-104 # 800217d0 <ftable+0x18>
    80004840:	0001e717          	auipc	a4,0x1e
    80004844:	f3070713          	addi	a4,a4,-208 # 80022770 <ftable+0xfb8>
    if(f->ref == 0){
    80004848:	40dc                	lw	a5,4(s1)
    8000484a:	cf99                	beqz	a5,80004868 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000484c:	02848493          	addi	s1,s1,40
    80004850:	fee49ce3          	bne	s1,a4,80004848 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004854:	0001d517          	auipc	a0,0x1d
    80004858:	f6450513          	addi	a0,a0,-156 # 800217b8 <ftable>
    8000485c:	ffffc097          	auipc	ra,0xffffc
    80004860:	41a080e7          	jalr	1050(ra) # 80000c76 <release>
  return 0;
    80004864:	4481                	li	s1,0
    80004866:	a819                	j	8000487c <filealloc+0x5e>
      f->ref = 1;
    80004868:	4785                	li	a5,1
    8000486a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000486c:	0001d517          	auipc	a0,0x1d
    80004870:	f4c50513          	addi	a0,a0,-180 # 800217b8 <ftable>
    80004874:	ffffc097          	auipc	ra,0xffffc
    80004878:	402080e7          	jalr	1026(ra) # 80000c76 <release>
}
    8000487c:	8526                	mv	a0,s1
    8000487e:	60e2                	ld	ra,24(sp)
    80004880:	6442                	ld	s0,16(sp)
    80004882:	64a2                	ld	s1,8(sp)
    80004884:	6105                	addi	sp,sp,32
    80004886:	8082                	ret

0000000080004888 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004888:	1101                	addi	sp,sp,-32
    8000488a:	ec06                	sd	ra,24(sp)
    8000488c:	e822                	sd	s0,16(sp)
    8000488e:	e426                	sd	s1,8(sp)
    80004890:	1000                	addi	s0,sp,32
    80004892:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004894:	0001d517          	auipc	a0,0x1d
    80004898:	f2450513          	addi	a0,a0,-220 # 800217b8 <ftable>
    8000489c:	ffffc097          	auipc	ra,0xffffc
    800048a0:	326080e7          	jalr	806(ra) # 80000bc2 <acquire>
  if(f->ref < 1)
    800048a4:	40dc                	lw	a5,4(s1)
    800048a6:	02f05263          	blez	a5,800048ca <filedup+0x42>
    panic("filedup");
  f->ref++;
    800048aa:	2785                	addiw	a5,a5,1
    800048ac:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800048ae:	0001d517          	auipc	a0,0x1d
    800048b2:	f0a50513          	addi	a0,a0,-246 # 800217b8 <ftable>
    800048b6:	ffffc097          	auipc	ra,0xffffc
    800048ba:	3c0080e7          	jalr	960(ra) # 80000c76 <release>
  return f;
}
    800048be:	8526                	mv	a0,s1
    800048c0:	60e2                	ld	ra,24(sp)
    800048c2:	6442                	ld	s0,16(sp)
    800048c4:	64a2                	ld	s1,8(sp)
    800048c6:	6105                	addi	sp,sp,32
    800048c8:	8082                	ret
    panic("filedup");
    800048ca:	00004517          	auipc	a0,0x4
    800048ce:	ebe50513          	addi	a0,a0,-322 # 80008788 <syscalls+0x248>
    800048d2:	ffffc097          	auipc	ra,0xffffc
    800048d6:	c58080e7          	jalr	-936(ra) # 8000052a <panic>

00000000800048da <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800048da:	7139                	addi	sp,sp,-64
    800048dc:	fc06                	sd	ra,56(sp)
    800048de:	f822                	sd	s0,48(sp)
    800048e0:	f426                	sd	s1,40(sp)
    800048e2:	f04a                	sd	s2,32(sp)
    800048e4:	ec4e                	sd	s3,24(sp)
    800048e6:	e852                	sd	s4,16(sp)
    800048e8:	e456                	sd	s5,8(sp)
    800048ea:	0080                	addi	s0,sp,64
    800048ec:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800048ee:	0001d517          	auipc	a0,0x1d
    800048f2:	eca50513          	addi	a0,a0,-310 # 800217b8 <ftable>
    800048f6:	ffffc097          	auipc	ra,0xffffc
    800048fa:	2cc080e7          	jalr	716(ra) # 80000bc2 <acquire>
  if(f->ref < 1)
    800048fe:	40dc                	lw	a5,4(s1)
    80004900:	06f05163          	blez	a5,80004962 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004904:	37fd                	addiw	a5,a5,-1
    80004906:	0007871b          	sext.w	a4,a5
    8000490a:	c0dc                	sw	a5,4(s1)
    8000490c:	06e04363          	bgtz	a4,80004972 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004910:	0004a903          	lw	s2,0(s1)
    80004914:	0094ca83          	lbu	s5,9(s1)
    80004918:	0104ba03          	ld	s4,16(s1)
    8000491c:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004920:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004924:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004928:	0001d517          	auipc	a0,0x1d
    8000492c:	e9050513          	addi	a0,a0,-368 # 800217b8 <ftable>
    80004930:	ffffc097          	auipc	ra,0xffffc
    80004934:	346080e7          	jalr	838(ra) # 80000c76 <release>

  if(ff.type == FD_PIPE){
    80004938:	4785                	li	a5,1
    8000493a:	04f90d63          	beq	s2,a5,80004994 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000493e:	3979                	addiw	s2,s2,-2
    80004940:	4785                	li	a5,1
    80004942:	0527e063          	bltu	a5,s2,80004982 <fileclose+0xa8>
    begin_op();
    80004946:	00000097          	auipc	ra,0x0
    8000494a:	ac8080e7          	jalr	-1336(ra) # 8000440e <begin_op>
    iput(ff.ip);
    8000494e:	854e                	mv	a0,s3
    80004950:	fffff097          	auipc	ra,0xfffff
    80004954:	2a6080e7          	jalr	678(ra) # 80003bf6 <iput>
    end_op();
    80004958:	00000097          	auipc	ra,0x0
    8000495c:	b36080e7          	jalr	-1226(ra) # 8000448e <end_op>
    80004960:	a00d                	j	80004982 <fileclose+0xa8>
    panic("fileclose");
    80004962:	00004517          	auipc	a0,0x4
    80004966:	e2e50513          	addi	a0,a0,-466 # 80008790 <syscalls+0x250>
    8000496a:	ffffc097          	auipc	ra,0xffffc
    8000496e:	bc0080e7          	jalr	-1088(ra) # 8000052a <panic>
    release(&ftable.lock);
    80004972:	0001d517          	auipc	a0,0x1d
    80004976:	e4650513          	addi	a0,a0,-442 # 800217b8 <ftable>
    8000497a:	ffffc097          	auipc	ra,0xffffc
    8000497e:	2fc080e7          	jalr	764(ra) # 80000c76 <release>
  }
}
    80004982:	70e2                	ld	ra,56(sp)
    80004984:	7442                	ld	s0,48(sp)
    80004986:	74a2                	ld	s1,40(sp)
    80004988:	7902                	ld	s2,32(sp)
    8000498a:	69e2                	ld	s3,24(sp)
    8000498c:	6a42                	ld	s4,16(sp)
    8000498e:	6aa2                	ld	s5,8(sp)
    80004990:	6121                	addi	sp,sp,64
    80004992:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004994:	85d6                	mv	a1,s5
    80004996:	8552                	mv	a0,s4
    80004998:	00000097          	auipc	ra,0x0
    8000499c:	34c080e7          	jalr	844(ra) # 80004ce4 <pipeclose>
    800049a0:	b7cd                	j	80004982 <fileclose+0xa8>

00000000800049a2 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800049a2:	715d                	addi	sp,sp,-80
    800049a4:	e486                	sd	ra,72(sp)
    800049a6:	e0a2                	sd	s0,64(sp)
    800049a8:	fc26                	sd	s1,56(sp)
    800049aa:	f84a                	sd	s2,48(sp)
    800049ac:	f44e                	sd	s3,40(sp)
    800049ae:	0880                	addi	s0,sp,80
    800049b0:	84aa                	mv	s1,a0
    800049b2:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800049b4:	ffffd097          	auipc	ra,0xffffd
    800049b8:	240080e7          	jalr	576(ra) # 80001bf4 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800049bc:	409c                	lw	a5,0(s1)
    800049be:	37f9                	addiw	a5,a5,-2
    800049c0:	4705                	li	a4,1
    800049c2:	04f76763          	bltu	a4,a5,80004a10 <filestat+0x6e>
    800049c6:	892a                	mv	s2,a0
    ilock(f->ip);
    800049c8:	6c88                	ld	a0,24(s1)
    800049ca:	fffff097          	auipc	ra,0xfffff
    800049ce:	072080e7          	jalr	114(ra) # 80003a3c <ilock>
    stati(f->ip, &st);
    800049d2:	fb840593          	addi	a1,s0,-72
    800049d6:	6c88                	ld	a0,24(s1)
    800049d8:	fffff097          	auipc	ra,0xfffff
    800049dc:	2ee080e7          	jalr	750(ra) # 80003cc6 <stati>
    iunlock(f->ip);
    800049e0:	6c88                	ld	a0,24(s1)
    800049e2:	fffff097          	auipc	ra,0xfffff
    800049e6:	11c080e7          	jalr	284(ra) # 80003afe <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800049ea:	46e1                	li	a3,24
    800049ec:	fb840613          	addi	a2,s0,-72
    800049f0:	85ce                	mv	a1,s3
    800049f2:	05893503          	ld	a0,88(s2)
    800049f6:	ffffd097          	auipc	ra,0xffffd
    800049fa:	dee080e7          	jalr	-530(ra) # 800017e4 <copyout>
    800049fe:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004a02:	60a6                	ld	ra,72(sp)
    80004a04:	6406                	ld	s0,64(sp)
    80004a06:	74e2                	ld	s1,56(sp)
    80004a08:	7942                	ld	s2,48(sp)
    80004a0a:	79a2                	ld	s3,40(sp)
    80004a0c:	6161                	addi	sp,sp,80
    80004a0e:	8082                	ret
  return -1;
    80004a10:	557d                	li	a0,-1
    80004a12:	bfc5                	j	80004a02 <filestat+0x60>

0000000080004a14 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004a14:	7179                	addi	sp,sp,-48
    80004a16:	f406                	sd	ra,40(sp)
    80004a18:	f022                	sd	s0,32(sp)
    80004a1a:	ec26                	sd	s1,24(sp)
    80004a1c:	e84a                	sd	s2,16(sp)
    80004a1e:	e44e                	sd	s3,8(sp)
    80004a20:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004a22:	00854783          	lbu	a5,8(a0)
    80004a26:	c3d5                	beqz	a5,80004aca <fileread+0xb6>
    80004a28:	84aa                	mv	s1,a0
    80004a2a:	89ae                	mv	s3,a1
    80004a2c:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004a2e:	411c                	lw	a5,0(a0)
    80004a30:	4705                	li	a4,1
    80004a32:	04e78963          	beq	a5,a4,80004a84 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004a36:	470d                	li	a4,3
    80004a38:	04e78d63          	beq	a5,a4,80004a92 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004a3c:	4709                	li	a4,2
    80004a3e:	06e79e63          	bne	a5,a4,80004aba <fileread+0xa6>
    ilock(f->ip);
    80004a42:	6d08                	ld	a0,24(a0)
    80004a44:	fffff097          	auipc	ra,0xfffff
    80004a48:	ff8080e7          	jalr	-8(ra) # 80003a3c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004a4c:	874a                	mv	a4,s2
    80004a4e:	5094                	lw	a3,32(s1)
    80004a50:	864e                	mv	a2,s3
    80004a52:	4585                	li	a1,1
    80004a54:	6c88                	ld	a0,24(s1)
    80004a56:	fffff097          	auipc	ra,0xfffff
    80004a5a:	29a080e7          	jalr	666(ra) # 80003cf0 <readi>
    80004a5e:	892a                	mv	s2,a0
    80004a60:	00a05563          	blez	a0,80004a6a <fileread+0x56>
      f->off += r;
    80004a64:	509c                	lw	a5,32(s1)
    80004a66:	9fa9                	addw	a5,a5,a0
    80004a68:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004a6a:	6c88                	ld	a0,24(s1)
    80004a6c:	fffff097          	auipc	ra,0xfffff
    80004a70:	092080e7          	jalr	146(ra) # 80003afe <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004a74:	854a                	mv	a0,s2
    80004a76:	70a2                	ld	ra,40(sp)
    80004a78:	7402                	ld	s0,32(sp)
    80004a7a:	64e2                	ld	s1,24(sp)
    80004a7c:	6942                	ld	s2,16(sp)
    80004a7e:	69a2                	ld	s3,8(sp)
    80004a80:	6145                	addi	sp,sp,48
    80004a82:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004a84:	6908                	ld	a0,16(a0)
    80004a86:	00000097          	auipc	ra,0x0
    80004a8a:	3c0080e7          	jalr	960(ra) # 80004e46 <piperead>
    80004a8e:	892a                	mv	s2,a0
    80004a90:	b7d5                	j	80004a74 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004a92:	02451783          	lh	a5,36(a0)
    80004a96:	03079693          	slli	a3,a5,0x30
    80004a9a:	92c1                	srli	a3,a3,0x30
    80004a9c:	4725                	li	a4,9
    80004a9e:	02d76863          	bltu	a4,a3,80004ace <fileread+0xba>
    80004aa2:	0792                	slli	a5,a5,0x4
    80004aa4:	0001d717          	auipc	a4,0x1d
    80004aa8:	c7470713          	addi	a4,a4,-908 # 80021718 <devsw>
    80004aac:	97ba                	add	a5,a5,a4
    80004aae:	639c                	ld	a5,0(a5)
    80004ab0:	c38d                	beqz	a5,80004ad2 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004ab2:	4505                	li	a0,1
    80004ab4:	9782                	jalr	a5
    80004ab6:	892a                	mv	s2,a0
    80004ab8:	bf75                	j	80004a74 <fileread+0x60>
    panic("fileread");
    80004aba:	00004517          	auipc	a0,0x4
    80004abe:	ce650513          	addi	a0,a0,-794 # 800087a0 <syscalls+0x260>
    80004ac2:	ffffc097          	auipc	ra,0xffffc
    80004ac6:	a68080e7          	jalr	-1432(ra) # 8000052a <panic>
    return -1;
    80004aca:	597d                	li	s2,-1
    80004acc:	b765                	j	80004a74 <fileread+0x60>
      return -1;
    80004ace:	597d                	li	s2,-1
    80004ad0:	b755                	j	80004a74 <fileread+0x60>
    80004ad2:	597d                	li	s2,-1
    80004ad4:	b745                	j	80004a74 <fileread+0x60>

0000000080004ad6 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80004ad6:	715d                	addi	sp,sp,-80
    80004ad8:	e486                	sd	ra,72(sp)
    80004ada:	e0a2                	sd	s0,64(sp)
    80004adc:	fc26                	sd	s1,56(sp)
    80004ade:	f84a                	sd	s2,48(sp)
    80004ae0:	f44e                	sd	s3,40(sp)
    80004ae2:	f052                	sd	s4,32(sp)
    80004ae4:	ec56                	sd	s5,24(sp)
    80004ae6:	e85a                	sd	s6,16(sp)
    80004ae8:	e45e                	sd	s7,8(sp)
    80004aea:	e062                	sd	s8,0(sp)
    80004aec:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80004aee:	00954783          	lbu	a5,9(a0)
    80004af2:	10078663          	beqz	a5,80004bfe <filewrite+0x128>
    80004af6:	892a                	mv	s2,a0
    80004af8:	8aae                	mv	s5,a1
    80004afa:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004afc:	411c                	lw	a5,0(a0)
    80004afe:	4705                	li	a4,1
    80004b00:	02e78263          	beq	a5,a4,80004b24 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004b04:	470d                	li	a4,3
    80004b06:	02e78663          	beq	a5,a4,80004b32 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004b0a:	4709                	li	a4,2
    80004b0c:	0ee79163          	bne	a5,a4,80004bee <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004b10:	0ac05d63          	blez	a2,80004bca <filewrite+0xf4>
    int i = 0;
    80004b14:	4981                	li	s3,0
    80004b16:	6b05                	lui	s6,0x1
    80004b18:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004b1c:	6b85                	lui	s7,0x1
    80004b1e:	c00b8b9b          	addiw	s7,s7,-1024
    80004b22:	a861                	j	80004bba <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80004b24:	6908                	ld	a0,16(a0)
    80004b26:	00000097          	auipc	ra,0x0
    80004b2a:	22e080e7          	jalr	558(ra) # 80004d54 <pipewrite>
    80004b2e:	8a2a                	mv	s4,a0
    80004b30:	a045                	j	80004bd0 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004b32:	02451783          	lh	a5,36(a0)
    80004b36:	03079693          	slli	a3,a5,0x30
    80004b3a:	92c1                	srli	a3,a3,0x30
    80004b3c:	4725                	li	a4,9
    80004b3e:	0cd76263          	bltu	a4,a3,80004c02 <filewrite+0x12c>
    80004b42:	0792                	slli	a5,a5,0x4
    80004b44:	0001d717          	auipc	a4,0x1d
    80004b48:	bd470713          	addi	a4,a4,-1068 # 80021718 <devsw>
    80004b4c:	97ba                	add	a5,a5,a4
    80004b4e:	679c                	ld	a5,8(a5)
    80004b50:	cbdd                	beqz	a5,80004c06 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80004b52:	4505                	li	a0,1
    80004b54:	9782                	jalr	a5
    80004b56:	8a2a                	mv	s4,a0
    80004b58:	a8a5                	j	80004bd0 <filewrite+0xfa>
    80004b5a:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004b5e:	00000097          	auipc	ra,0x0
    80004b62:	8b0080e7          	jalr	-1872(ra) # 8000440e <begin_op>
      ilock(f->ip);
    80004b66:	01893503          	ld	a0,24(s2)
    80004b6a:	fffff097          	auipc	ra,0xfffff
    80004b6e:	ed2080e7          	jalr	-302(ra) # 80003a3c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004b72:	8762                	mv	a4,s8
    80004b74:	02092683          	lw	a3,32(s2)
    80004b78:	01598633          	add	a2,s3,s5
    80004b7c:	4585                	li	a1,1
    80004b7e:	01893503          	ld	a0,24(s2)
    80004b82:	fffff097          	auipc	ra,0xfffff
    80004b86:	266080e7          	jalr	614(ra) # 80003de8 <writei>
    80004b8a:	84aa                	mv	s1,a0
    80004b8c:	00a05763          	blez	a0,80004b9a <filewrite+0xc4>
        f->off += r;
    80004b90:	02092783          	lw	a5,32(s2)
    80004b94:	9fa9                	addw	a5,a5,a0
    80004b96:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004b9a:	01893503          	ld	a0,24(s2)
    80004b9e:	fffff097          	auipc	ra,0xfffff
    80004ba2:	f60080e7          	jalr	-160(ra) # 80003afe <iunlock>
      end_op();
    80004ba6:	00000097          	auipc	ra,0x0
    80004baa:	8e8080e7          	jalr	-1816(ra) # 8000448e <end_op>

      if(r != n1){
    80004bae:	009c1f63          	bne	s8,s1,80004bcc <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80004bb2:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004bb6:	0149db63          	bge	s3,s4,80004bcc <filewrite+0xf6>
      int n1 = n - i;
    80004bba:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004bbe:	84be                	mv	s1,a5
    80004bc0:	2781                	sext.w	a5,a5
    80004bc2:	f8fb5ce3          	bge	s6,a5,80004b5a <filewrite+0x84>
    80004bc6:	84de                	mv	s1,s7
    80004bc8:	bf49                	j	80004b5a <filewrite+0x84>
    int i = 0;
    80004bca:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004bcc:	013a1f63          	bne	s4,s3,80004bea <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004bd0:	8552                	mv	a0,s4
    80004bd2:	60a6                	ld	ra,72(sp)
    80004bd4:	6406                	ld	s0,64(sp)
    80004bd6:	74e2                	ld	s1,56(sp)
    80004bd8:	7942                	ld	s2,48(sp)
    80004bda:	79a2                	ld	s3,40(sp)
    80004bdc:	7a02                	ld	s4,32(sp)
    80004bde:	6ae2                	ld	s5,24(sp)
    80004be0:	6b42                	ld	s6,16(sp)
    80004be2:	6ba2                	ld	s7,8(sp)
    80004be4:	6c02                	ld	s8,0(sp)
    80004be6:	6161                	addi	sp,sp,80
    80004be8:	8082                	ret
    ret = (i == n ? n : -1);
    80004bea:	5a7d                	li	s4,-1
    80004bec:	b7d5                	j	80004bd0 <filewrite+0xfa>
    panic("filewrite");
    80004bee:	00004517          	auipc	a0,0x4
    80004bf2:	bc250513          	addi	a0,a0,-1086 # 800087b0 <syscalls+0x270>
    80004bf6:	ffffc097          	auipc	ra,0xffffc
    80004bfa:	934080e7          	jalr	-1740(ra) # 8000052a <panic>
    return -1;
    80004bfe:	5a7d                	li	s4,-1
    80004c00:	bfc1                	j	80004bd0 <filewrite+0xfa>
      return -1;
    80004c02:	5a7d                	li	s4,-1
    80004c04:	b7f1                	j	80004bd0 <filewrite+0xfa>
    80004c06:	5a7d                	li	s4,-1
    80004c08:	b7e1                	j	80004bd0 <filewrite+0xfa>

0000000080004c0a <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004c0a:	7179                	addi	sp,sp,-48
    80004c0c:	f406                	sd	ra,40(sp)
    80004c0e:	f022                	sd	s0,32(sp)
    80004c10:	ec26                	sd	s1,24(sp)
    80004c12:	e84a                	sd	s2,16(sp)
    80004c14:	e44e                	sd	s3,8(sp)
    80004c16:	e052                	sd	s4,0(sp)
    80004c18:	1800                	addi	s0,sp,48
    80004c1a:	84aa                	mv	s1,a0
    80004c1c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004c1e:	0005b023          	sd	zero,0(a1)
    80004c22:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004c26:	00000097          	auipc	ra,0x0
    80004c2a:	bf8080e7          	jalr	-1032(ra) # 8000481e <filealloc>
    80004c2e:	e088                	sd	a0,0(s1)
    80004c30:	c551                	beqz	a0,80004cbc <pipealloc+0xb2>
    80004c32:	00000097          	auipc	ra,0x0
    80004c36:	bec080e7          	jalr	-1044(ra) # 8000481e <filealloc>
    80004c3a:	00aa3023          	sd	a0,0(s4)
    80004c3e:	c92d                	beqz	a0,80004cb0 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004c40:	ffffc097          	auipc	ra,0xffffc
    80004c44:	e92080e7          	jalr	-366(ra) # 80000ad2 <kalloc>
    80004c48:	892a                	mv	s2,a0
    80004c4a:	c125                	beqz	a0,80004caa <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004c4c:	4985                	li	s3,1
    80004c4e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004c52:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004c56:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004c5a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004c5e:	00004597          	auipc	a1,0x4
    80004c62:	b6258593          	addi	a1,a1,-1182 # 800087c0 <syscalls+0x280>
    80004c66:	ffffc097          	auipc	ra,0xffffc
    80004c6a:	ecc080e7          	jalr	-308(ra) # 80000b32 <initlock>
  (*f0)->type = FD_PIPE;
    80004c6e:	609c                	ld	a5,0(s1)
    80004c70:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004c74:	609c                	ld	a5,0(s1)
    80004c76:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004c7a:	609c                	ld	a5,0(s1)
    80004c7c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004c80:	609c                	ld	a5,0(s1)
    80004c82:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004c86:	000a3783          	ld	a5,0(s4)
    80004c8a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004c8e:	000a3783          	ld	a5,0(s4)
    80004c92:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004c96:	000a3783          	ld	a5,0(s4)
    80004c9a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004c9e:	000a3783          	ld	a5,0(s4)
    80004ca2:	0127b823          	sd	s2,16(a5)
  return 0;
    80004ca6:	4501                	li	a0,0
    80004ca8:	a025                	j	80004cd0 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004caa:	6088                	ld	a0,0(s1)
    80004cac:	e501                	bnez	a0,80004cb4 <pipealloc+0xaa>
    80004cae:	a039                	j	80004cbc <pipealloc+0xb2>
    80004cb0:	6088                	ld	a0,0(s1)
    80004cb2:	c51d                	beqz	a0,80004ce0 <pipealloc+0xd6>
    fileclose(*f0);
    80004cb4:	00000097          	auipc	ra,0x0
    80004cb8:	c26080e7          	jalr	-986(ra) # 800048da <fileclose>
  if(*f1)
    80004cbc:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004cc0:	557d                	li	a0,-1
  if(*f1)
    80004cc2:	c799                	beqz	a5,80004cd0 <pipealloc+0xc6>
    fileclose(*f1);
    80004cc4:	853e                	mv	a0,a5
    80004cc6:	00000097          	auipc	ra,0x0
    80004cca:	c14080e7          	jalr	-1004(ra) # 800048da <fileclose>
  return -1;
    80004cce:	557d                	li	a0,-1
}
    80004cd0:	70a2                	ld	ra,40(sp)
    80004cd2:	7402                	ld	s0,32(sp)
    80004cd4:	64e2                	ld	s1,24(sp)
    80004cd6:	6942                	ld	s2,16(sp)
    80004cd8:	69a2                	ld	s3,8(sp)
    80004cda:	6a02                	ld	s4,0(sp)
    80004cdc:	6145                	addi	sp,sp,48
    80004cde:	8082                	ret
  return -1;
    80004ce0:	557d                	li	a0,-1
    80004ce2:	b7fd                	j	80004cd0 <pipealloc+0xc6>

0000000080004ce4 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004ce4:	1101                	addi	sp,sp,-32
    80004ce6:	ec06                	sd	ra,24(sp)
    80004ce8:	e822                	sd	s0,16(sp)
    80004cea:	e426                	sd	s1,8(sp)
    80004cec:	e04a                	sd	s2,0(sp)
    80004cee:	1000                	addi	s0,sp,32
    80004cf0:	84aa                	mv	s1,a0
    80004cf2:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004cf4:	ffffc097          	auipc	ra,0xffffc
    80004cf8:	ece080e7          	jalr	-306(ra) # 80000bc2 <acquire>
  if(writable){
    80004cfc:	02090d63          	beqz	s2,80004d36 <pipeclose+0x52>
    pi->writeopen = 0;
    80004d00:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004d04:	21848513          	addi	a0,s1,536
    80004d08:	ffffe097          	auipc	ra,0xffffe
    80004d0c:	8e8080e7          	jalr	-1816(ra) # 800025f0 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004d10:	2204b783          	ld	a5,544(s1)
    80004d14:	eb95                	bnez	a5,80004d48 <pipeclose+0x64>
    release(&pi->lock);
    80004d16:	8526                	mv	a0,s1
    80004d18:	ffffc097          	auipc	ra,0xffffc
    80004d1c:	f5e080e7          	jalr	-162(ra) # 80000c76 <release>
    kfree((char*)pi);
    80004d20:	8526                	mv	a0,s1
    80004d22:	ffffc097          	auipc	ra,0xffffc
    80004d26:	cb4080e7          	jalr	-844(ra) # 800009d6 <kfree>
  } else
    release(&pi->lock);
}
    80004d2a:	60e2                	ld	ra,24(sp)
    80004d2c:	6442                	ld	s0,16(sp)
    80004d2e:	64a2                	ld	s1,8(sp)
    80004d30:	6902                	ld	s2,0(sp)
    80004d32:	6105                	addi	sp,sp,32
    80004d34:	8082                	ret
    pi->readopen = 0;
    80004d36:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004d3a:	21c48513          	addi	a0,s1,540
    80004d3e:	ffffe097          	auipc	ra,0xffffe
    80004d42:	8b2080e7          	jalr	-1870(ra) # 800025f0 <wakeup>
    80004d46:	b7e9                	j	80004d10 <pipeclose+0x2c>
    release(&pi->lock);
    80004d48:	8526                	mv	a0,s1
    80004d4a:	ffffc097          	auipc	ra,0xffffc
    80004d4e:	f2c080e7          	jalr	-212(ra) # 80000c76 <release>
}
    80004d52:	bfe1                	j	80004d2a <pipeclose+0x46>

0000000080004d54 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004d54:	711d                	addi	sp,sp,-96
    80004d56:	ec86                	sd	ra,88(sp)
    80004d58:	e8a2                	sd	s0,80(sp)
    80004d5a:	e4a6                	sd	s1,72(sp)
    80004d5c:	e0ca                	sd	s2,64(sp)
    80004d5e:	fc4e                	sd	s3,56(sp)
    80004d60:	f852                	sd	s4,48(sp)
    80004d62:	f456                	sd	s5,40(sp)
    80004d64:	f05a                	sd	s6,32(sp)
    80004d66:	ec5e                	sd	s7,24(sp)
    80004d68:	e862                	sd	s8,16(sp)
    80004d6a:	1080                	addi	s0,sp,96
    80004d6c:	84aa                	mv	s1,a0
    80004d6e:	8aae                	mv	s5,a1
    80004d70:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004d72:	ffffd097          	auipc	ra,0xffffd
    80004d76:	e82080e7          	jalr	-382(ra) # 80001bf4 <myproc>
    80004d7a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004d7c:	8526                	mv	a0,s1
    80004d7e:	ffffc097          	auipc	ra,0xffffc
    80004d82:	e44080e7          	jalr	-444(ra) # 80000bc2 <acquire>
  while(i < n){
    80004d86:	0b405363          	blez	s4,80004e2c <pipewrite+0xd8>
  int i = 0;
    80004d8a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004d8c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004d8e:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004d92:	21c48b93          	addi	s7,s1,540
    80004d96:	a089                	j	80004dd8 <pipewrite+0x84>
      release(&pi->lock);
    80004d98:	8526                	mv	a0,s1
    80004d9a:	ffffc097          	auipc	ra,0xffffc
    80004d9e:	edc080e7          	jalr	-292(ra) # 80000c76 <release>
      return -1;
    80004da2:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004da4:	854a                	mv	a0,s2
    80004da6:	60e6                	ld	ra,88(sp)
    80004da8:	6446                	ld	s0,80(sp)
    80004daa:	64a6                	ld	s1,72(sp)
    80004dac:	6906                	ld	s2,64(sp)
    80004dae:	79e2                	ld	s3,56(sp)
    80004db0:	7a42                	ld	s4,48(sp)
    80004db2:	7aa2                	ld	s5,40(sp)
    80004db4:	7b02                	ld	s6,32(sp)
    80004db6:	6be2                	ld	s7,24(sp)
    80004db8:	6c42                	ld	s8,16(sp)
    80004dba:	6125                	addi	sp,sp,96
    80004dbc:	8082                	ret
      wakeup(&pi->nread);
    80004dbe:	8562                	mv	a0,s8
    80004dc0:	ffffe097          	auipc	ra,0xffffe
    80004dc4:	830080e7          	jalr	-2000(ra) # 800025f0 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004dc8:	85a6                	mv	a1,s1
    80004dca:	855e                	mv	a0,s7
    80004dcc:	ffffd097          	auipc	ra,0xffffd
    80004dd0:	698080e7          	jalr	1688(ra) # 80002464 <sleep>
  while(i < n){
    80004dd4:	05495d63          	bge	s2,s4,80004e2e <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80004dd8:	2204a783          	lw	a5,544(s1)
    80004ddc:	dfd5                	beqz	a5,80004d98 <pipewrite+0x44>
    80004dde:	0289a783          	lw	a5,40(s3)
    80004de2:	fbdd                	bnez	a5,80004d98 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004de4:	2184a783          	lw	a5,536(s1)
    80004de8:	21c4a703          	lw	a4,540(s1)
    80004dec:	2007879b          	addiw	a5,a5,512
    80004df0:	fcf707e3          	beq	a4,a5,80004dbe <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004df4:	4685                	li	a3,1
    80004df6:	01590633          	add	a2,s2,s5
    80004dfa:	faf40593          	addi	a1,s0,-81
    80004dfe:	0589b503          	ld	a0,88(s3)
    80004e02:	ffffd097          	auipc	ra,0xffffd
    80004e06:	ae8080e7          	jalr	-1304(ra) # 800018ea <copyin>
    80004e0a:	03650263          	beq	a0,s6,80004e2e <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004e0e:	21c4a783          	lw	a5,540(s1)
    80004e12:	0017871b          	addiw	a4,a5,1
    80004e16:	20e4ae23          	sw	a4,540(s1)
    80004e1a:	1ff7f793          	andi	a5,a5,511
    80004e1e:	97a6                	add	a5,a5,s1
    80004e20:	faf44703          	lbu	a4,-81(s0)
    80004e24:	00e78c23          	sb	a4,24(a5)
      i++;
    80004e28:	2905                	addiw	s2,s2,1
    80004e2a:	b76d                	j	80004dd4 <pipewrite+0x80>
  int i = 0;
    80004e2c:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004e2e:	21848513          	addi	a0,s1,536
    80004e32:	ffffd097          	auipc	ra,0xffffd
    80004e36:	7be080e7          	jalr	1982(ra) # 800025f0 <wakeup>
  release(&pi->lock);
    80004e3a:	8526                	mv	a0,s1
    80004e3c:	ffffc097          	auipc	ra,0xffffc
    80004e40:	e3a080e7          	jalr	-454(ra) # 80000c76 <release>
  return i;
    80004e44:	b785                	j	80004da4 <pipewrite+0x50>

0000000080004e46 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004e46:	715d                	addi	sp,sp,-80
    80004e48:	e486                	sd	ra,72(sp)
    80004e4a:	e0a2                	sd	s0,64(sp)
    80004e4c:	fc26                	sd	s1,56(sp)
    80004e4e:	f84a                	sd	s2,48(sp)
    80004e50:	f44e                	sd	s3,40(sp)
    80004e52:	f052                	sd	s4,32(sp)
    80004e54:	ec56                	sd	s5,24(sp)
    80004e56:	e85a                	sd	s6,16(sp)
    80004e58:	0880                	addi	s0,sp,80
    80004e5a:	84aa                	mv	s1,a0
    80004e5c:	892e                	mv	s2,a1
    80004e5e:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004e60:	ffffd097          	auipc	ra,0xffffd
    80004e64:	d94080e7          	jalr	-620(ra) # 80001bf4 <myproc>
    80004e68:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004e6a:	8526                	mv	a0,s1
    80004e6c:	ffffc097          	auipc	ra,0xffffc
    80004e70:	d56080e7          	jalr	-682(ra) # 80000bc2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004e74:	2184a703          	lw	a4,536(s1)
    80004e78:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004e7c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004e80:	02f71463          	bne	a4,a5,80004ea8 <piperead+0x62>
    80004e84:	2244a783          	lw	a5,548(s1)
    80004e88:	c385                	beqz	a5,80004ea8 <piperead+0x62>
    if(pr->killed){
    80004e8a:	028a2783          	lw	a5,40(s4)
    80004e8e:	ebc1                	bnez	a5,80004f1e <piperead+0xd8>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004e90:	85a6                	mv	a1,s1
    80004e92:	854e                	mv	a0,s3
    80004e94:	ffffd097          	auipc	ra,0xffffd
    80004e98:	5d0080e7          	jalr	1488(ra) # 80002464 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004e9c:	2184a703          	lw	a4,536(s1)
    80004ea0:	21c4a783          	lw	a5,540(s1)
    80004ea4:	fef700e3          	beq	a4,a5,80004e84 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004ea8:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004eaa:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004eac:	05505363          	blez	s5,80004ef2 <piperead+0xac>
    if(pi->nread == pi->nwrite)
    80004eb0:	2184a783          	lw	a5,536(s1)
    80004eb4:	21c4a703          	lw	a4,540(s1)
    80004eb8:	02f70d63          	beq	a4,a5,80004ef2 <piperead+0xac>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004ebc:	0017871b          	addiw	a4,a5,1
    80004ec0:	20e4ac23          	sw	a4,536(s1)
    80004ec4:	1ff7f793          	andi	a5,a5,511
    80004ec8:	97a6                	add	a5,a5,s1
    80004eca:	0187c783          	lbu	a5,24(a5)
    80004ece:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004ed2:	4685                	li	a3,1
    80004ed4:	fbf40613          	addi	a2,s0,-65
    80004ed8:	85ca                	mv	a1,s2
    80004eda:	058a3503          	ld	a0,88(s4)
    80004ede:	ffffd097          	auipc	ra,0xffffd
    80004ee2:	906080e7          	jalr	-1786(ra) # 800017e4 <copyout>
    80004ee6:	01650663          	beq	a0,s6,80004ef2 <piperead+0xac>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004eea:	2985                	addiw	s3,s3,1
    80004eec:	0905                	addi	s2,s2,1
    80004eee:	fd3a91e3          	bne	s5,s3,80004eb0 <piperead+0x6a>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004ef2:	21c48513          	addi	a0,s1,540
    80004ef6:	ffffd097          	auipc	ra,0xffffd
    80004efa:	6fa080e7          	jalr	1786(ra) # 800025f0 <wakeup>
  release(&pi->lock);
    80004efe:	8526                	mv	a0,s1
    80004f00:	ffffc097          	auipc	ra,0xffffc
    80004f04:	d76080e7          	jalr	-650(ra) # 80000c76 <release>
  return i;
}
    80004f08:	854e                	mv	a0,s3
    80004f0a:	60a6                	ld	ra,72(sp)
    80004f0c:	6406                	ld	s0,64(sp)
    80004f0e:	74e2                	ld	s1,56(sp)
    80004f10:	7942                	ld	s2,48(sp)
    80004f12:	79a2                	ld	s3,40(sp)
    80004f14:	7a02                	ld	s4,32(sp)
    80004f16:	6ae2                	ld	s5,24(sp)
    80004f18:	6b42                	ld	s6,16(sp)
    80004f1a:	6161                	addi	sp,sp,80
    80004f1c:	8082                	ret
      release(&pi->lock);
    80004f1e:	8526                	mv	a0,s1
    80004f20:	ffffc097          	auipc	ra,0xffffc
    80004f24:	d56080e7          	jalr	-682(ra) # 80000c76 <release>
      return -1;
    80004f28:	59fd                	li	s3,-1
    80004f2a:	bff9                	j	80004f08 <piperead+0xc2>

0000000080004f2c <exec>:
extern struct proc proc[NPROC];
static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004f2c:	dd010113          	addi	sp,sp,-560
    80004f30:	22113423          	sd	ra,552(sp)
    80004f34:	22813023          	sd	s0,544(sp)
    80004f38:	20913c23          	sd	s1,536(sp)
    80004f3c:	21213823          	sd	s2,528(sp)
    80004f40:	21313423          	sd	s3,520(sp)
    80004f44:	21413023          	sd	s4,512(sp)
    80004f48:	ffd6                	sd	s5,504(sp)
    80004f4a:	fbda                	sd	s6,496(sp)
    80004f4c:	f7de                	sd	s7,488(sp)
    80004f4e:	f3e2                	sd	s8,480(sp)
    80004f50:	efe6                	sd	s9,472(sp)
    80004f52:	ebea                	sd	s10,464(sp)
    80004f54:	e7ee                	sd	s11,456(sp)
    80004f56:	1c00                	addi	s0,sp,560
    80004f58:	84aa                	mv	s1,a0
    80004f5a:	dea43023          	sd	a0,-544(s0)
    80004f5e:	deb43423          	sd	a1,-536(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004f62:	ffffd097          	auipc	ra,0xffffd
    80004f66:	c92080e7          	jalr	-878(ra) # 80001bf4 <myproc>
    80004f6a:	dea43c23          	sd	a0,-520(s0)

  begin_op();
    80004f6e:	fffff097          	auipc	ra,0xfffff
    80004f72:	4a0080e7          	jalr	1184(ra) # 8000440e <begin_op>

  if((ip = namei(path)) == 0){
    80004f76:	8526                	mv	a0,s1
    80004f78:	fffff097          	auipc	ra,0xfffff
    80004f7c:	27a080e7          	jalr	634(ra) # 800041f2 <namei>
    80004f80:	cd2d                	beqz	a0,80004ffa <exec+0xce>
    80004f82:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004f84:	fffff097          	auipc	ra,0xfffff
    80004f88:	ab8080e7          	jalr	-1352(ra) # 80003a3c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004f8c:	04000713          	li	a4,64
    80004f90:	4681                	li	a3,0
    80004f92:	e4840613          	addi	a2,s0,-440
    80004f96:	4581                	li	a1,0
    80004f98:	8556                	mv	a0,s5
    80004f9a:	fffff097          	auipc	ra,0xfffff
    80004f9e:	d56080e7          	jalr	-682(ra) # 80003cf0 <readi>
    80004fa2:	04000793          	li	a5,64
    80004fa6:	00f51a63          	bne	a0,a5,80004fba <exec+0x8e>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004faa:	e4842703          	lw	a4,-440(s0)
    80004fae:	464c47b7          	lui	a5,0x464c4
    80004fb2:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004fb6:	04f70863          	beq	a4,a5,80005006 <exec+0xda>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004fba:	8556                	mv	a0,s5
    80004fbc:	fffff097          	auipc	ra,0xfffff
    80004fc0:	ce2080e7          	jalr	-798(ra) # 80003c9e <iunlockput>
    end_op();
    80004fc4:	fffff097          	auipc	ra,0xfffff
    80004fc8:	4ca080e7          	jalr	1226(ra) # 8000448e <end_op>
  }
  return -1;
    80004fcc:	557d                	li	a0,-1
}
    80004fce:	22813083          	ld	ra,552(sp)
    80004fd2:	22013403          	ld	s0,544(sp)
    80004fd6:	21813483          	ld	s1,536(sp)
    80004fda:	21013903          	ld	s2,528(sp)
    80004fde:	20813983          	ld	s3,520(sp)
    80004fe2:	20013a03          	ld	s4,512(sp)
    80004fe6:	7afe                	ld	s5,504(sp)
    80004fe8:	7b5e                	ld	s6,496(sp)
    80004fea:	7bbe                	ld	s7,488(sp)
    80004fec:	7c1e                	ld	s8,480(sp)
    80004fee:	6cfe                	ld	s9,472(sp)
    80004ff0:	6d5e                	ld	s10,464(sp)
    80004ff2:	6dbe                	ld	s11,456(sp)
    80004ff4:	23010113          	addi	sp,sp,560
    80004ff8:	8082                	ret
    end_op();
    80004ffa:	fffff097          	auipc	ra,0xfffff
    80004ffe:	494080e7          	jalr	1172(ra) # 8000448e <end_op>
    return -1;
    80005002:	557d                	li	a0,-1
    80005004:	b7e9                	j	80004fce <exec+0xa2>
  if((pagetable = proc_pagetable(p)) == 0)
    80005006:	df843503          	ld	a0,-520(s0)
    8000500a:	ffffd097          	auipc	ra,0xffffd
    8000500e:	cae080e7          	jalr	-850(ra) # 80001cb8 <proc_pagetable>
    80005012:	8b2a                	mv	s6,a0
    80005014:	d15d                	beqz	a0,80004fba <exec+0x8e>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005016:	e6842783          	lw	a5,-408(s0)
    8000501a:	e8045703          	lhu	a4,-384(s0)
    8000501e:	c735                	beqz	a4,8000508a <exec+0x15e>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80005020:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005022:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80005026:	6a05                	lui	s4,0x1
    80005028:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    8000502c:	dce43c23          	sd	a4,-552(s0)
  uint64 pa;

  if((va % PGSIZE) != 0)
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    80005030:	6d85                	lui	s11,0x1
    80005032:	7d7d                	lui	s10,0xfffff
    80005034:	a4b1                	j	80005280 <exec+0x354>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80005036:	00003517          	auipc	a0,0x3
    8000503a:	79250513          	addi	a0,a0,1938 # 800087c8 <syscalls+0x288>
    8000503e:	ffffb097          	auipc	ra,0xffffb
    80005042:	4ec080e7          	jalr	1260(ra) # 8000052a <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80005046:	874a                	mv	a4,s2
    80005048:	009c86bb          	addw	a3,s9,s1
    8000504c:	4581                	li	a1,0
    8000504e:	8556                	mv	a0,s5
    80005050:	fffff097          	auipc	ra,0xfffff
    80005054:	ca0080e7          	jalr	-864(ra) # 80003cf0 <readi>
    80005058:	2501                	sext.w	a0,a0
    8000505a:	1ca91363          	bne	s2,a0,80005220 <exec+0x2f4>
  for(i = 0; i < sz; i += PGSIZE){
    8000505e:	009d84bb          	addw	s1,s11,s1
    80005062:	013d09bb          	addw	s3,s10,s3
    80005066:	1f74fd63          	bgeu	s1,s7,80005260 <exec+0x334>
    pa = walkaddr(pagetable, va + i);
    8000506a:	02049593          	slli	a1,s1,0x20
    8000506e:	9181                	srli	a1,a1,0x20
    80005070:	95e2                	add	a1,a1,s8
    80005072:	855a                	mv	a0,s6
    80005074:	ffffc097          	auipc	ra,0xffffc
    80005078:	fd8080e7          	jalr	-40(ra) # 8000104c <walkaddr>
    8000507c:	862a                	mv	a2,a0
    if(pa == 0)
    8000507e:	dd45                	beqz	a0,80005036 <exec+0x10a>
      n = PGSIZE;
    80005080:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80005082:	fd49f2e3          	bgeu	s3,s4,80005046 <exec+0x11a>
      n = sz - i;
    80005086:	894e                	mv	s2,s3
    80005088:	bf7d                	j	80005046 <exec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    8000508a:	4481                	li	s1,0
  iunlockput(ip);
    8000508c:	8556                	mv	a0,s5
    8000508e:	fffff097          	auipc	ra,0xfffff
    80005092:	c10080e7          	jalr	-1008(ra) # 80003c9e <iunlockput>
  end_op();
    80005096:	fffff097          	auipc	ra,0xfffff
    8000509a:	3f8080e7          	jalr	1016(ra) # 8000448e <end_op>
  uint64 oldsz = p->sz;
    8000509e:	df843983          	ld	s3,-520(s0)
    800050a2:	0509bc83          	ld	s9,80(s3)
  sz = PGROUNDUP(sz);
    800050a6:	6785                	lui	a5,0x1
    800050a8:	17fd                	addi	a5,a5,-1
    800050aa:	94be                	add	s1,s1,a5
    800050ac:	77fd                	lui	a5,0xfffff
    800050ae:	00f4f933          	and	s2,s1,a5
    800050b2:	df243823          	sd	s2,-528(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800050b6:	6489                	lui	s1,0x2
    800050b8:	94ca                	add	s1,s1,s2
    800050ba:	8626                	mv	a2,s1
    800050bc:	85ca                	mv	a1,s2
    800050be:	855a                	mv	a0,s6
    800050c0:	ffffc097          	auipc	ra,0xffffc
    800050c4:	3ca080e7          	jalr	970(ra) # 8000148a <uvmalloc>
    800050c8:	8baa                	mv	s7,a0
  ip = 0;
    800050ca:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800050cc:	14050a63          	beqz	a0,80005220 <exec+0x2f4>
  uvmapping(pagetable,p->k_pagetable,sz,sz + 2 * PGSIZE);
    800050d0:	86a6                	mv	a3,s1
    800050d2:	864a                	mv	a2,s2
    800050d4:	0609b583          	ld	a1,96(s3)
    800050d8:	855a                	mv	a0,s6
    800050da:	ffffc097          	auipc	ra,0xffffc
    800050de:	2c2080e7          	jalr	706(ra) # 8000139c <uvmapping>
  uvmclear(pagetable, sz-2*PGSIZE);
    800050e2:	75f9                	lui	a1,0xffffe
    800050e4:	95de                	add	a1,a1,s7
    800050e6:	855a                	mv	a0,s6
    800050e8:	ffffc097          	auipc	ra,0xffffc
    800050ec:	6ca080e7          	jalr	1738(ra) # 800017b2 <uvmclear>
  stackbase = sp - PGSIZE;
    800050f0:	7afd                	lui	s5,0xfffff
    800050f2:	9ade                	add	s5,s5,s7
  for(argc = 0; argv[argc]; argc++) {
    800050f4:	de843783          	ld	a5,-536(s0)
    800050f8:	6388                	ld	a0,0(a5)
    800050fa:	c925                	beqz	a0,8000516a <exec+0x23e>
    800050fc:	e8840993          	addi	s3,s0,-376
    80005100:	f8840c13          	addi	s8,s0,-120
  sp = sz;
    80005104:	895e                	mv	s2,s7
  for(argc = 0; argv[argc]; argc++) {
    80005106:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80005108:	ffffc097          	auipc	ra,0xffffc
    8000510c:	d3a080e7          	jalr	-710(ra) # 80000e42 <strlen>
    80005110:	0015079b          	addiw	a5,a0,1
    80005114:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005118:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    8000511c:	13596663          	bltu	s2,s5,80005248 <exec+0x31c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005120:	de843d03          	ld	s10,-536(s0)
    80005124:	000d3a03          	ld	s4,0(s10) # fffffffffffff000 <end+0xffffffff7ffd9000>
    80005128:	8552                	mv	a0,s4
    8000512a:	ffffc097          	auipc	ra,0xffffc
    8000512e:	d18080e7          	jalr	-744(ra) # 80000e42 <strlen>
    80005132:	0015069b          	addiw	a3,a0,1
    80005136:	8652                	mv	a2,s4
    80005138:	85ca                	mv	a1,s2
    8000513a:	855a                	mv	a0,s6
    8000513c:	ffffc097          	auipc	ra,0xffffc
    80005140:	6a8080e7          	jalr	1704(ra) # 800017e4 <copyout>
    80005144:	10054663          	bltz	a0,80005250 <exec+0x324>
    ustack[argc] = sp;
    80005148:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000514c:	0485                	addi	s1,s1,1
    8000514e:	008d0793          	addi	a5,s10,8
    80005152:	def43423          	sd	a5,-536(s0)
    80005156:	008d3503          	ld	a0,8(s10)
    8000515a:	c911                	beqz	a0,8000516e <exec+0x242>
    if(argc >= MAXARG)
    8000515c:	09a1                	addi	s3,s3,8
    8000515e:	fb3c15e3          	bne	s8,s3,80005108 <exec+0x1dc>
  sz = sz1;
    80005162:	df743823          	sd	s7,-528(s0)
  ip = 0;
    80005166:	4a81                	li	s5,0
    80005168:	a865                	j	80005220 <exec+0x2f4>
  sp = sz;
    8000516a:	895e                	mv	s2,s7
  for(argc = 0; argv[argc]; argc++) {
    8000516c:	4481                	li	s1,0
  ustack[argc] = 0;
    8000516e:	00349793          	slli	a5,s1,0x3
    80005172:	f9040713          	addi	a4,s0,-112
    80005176:	97ba                	add	a5,a5,a4
    80005178:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ffd8ef8>
  sp -= (argc+1) * sizeof(uint64);
    8000517c:	00148693          	addi	a3,s1,1 # 2001 <_entry-0x7fffdfff>
    80005180:	068e                	slli	a3,a3,0x3
    80005182:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005186:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000518a:	01597663          	bgeu	s2,s5,80005196 <exec+0x26a>
  sz = sz1;
    8000518e:	df743823          	sd	s7,-528(s0)
  ip = 0;
    80005192:	4a81                	li	s5,0
    80005194:	a071                	j	80005220 <exec+0x2f4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005196:	e8840613          	addi	a2,s0,-376
    8000519a:	85ca                	mv	a1,s2
    8000519c:	855a                	mv	a0,s6
    8000519e:	ffffc097          	auipc	ra,0xffffc
    800051a2:	646080e7          	jalr	1606(ra) # 800017e4 <copyout>
    800051a6:	0a054963          	bltz	a0,80005258 <exec+0x32c>
  p->trapframe->a1 = sp;
    800051aa:	df843783          	ld	a5,-520(s0)
    800051ae:	77bc                	ld	a5,104(a5)
    800051b0:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800051b4:	de043783          	ld	a5,-544(s0)
    800051b8:	0007c703          	lbu	a4,0(a5)
    800051bc:	cf11                	beqz	a4,800051d8 <exec+0x2ac>
    800051be:	0785                	addi	a5,a5,1
    if(*s == '/')
    800051c0:	02f00693          	li	a3,47
    800051c4:	a039                	j	800051d2 <exec+0x2a6>
      last = s+1;
    800051c6:	def43023          	sd	a5,-544(s0)
  for(last=s=path; *s; s++)
    800051ca:	0785                	addi	a5,a5,1
    800051cc:	fff7c703          	lbu	a4,-1(a5)
    800051d0:	c701                	beqz	a4,800051d8 <exec+0x2ac>
    if(*s == '/')
    800051d2:	fed71ce3          	bne	a4,a3,800051ca <exec+0x29e>
    800051d6:	bfc5                	j	800051c6 <exec+0x29a>
  safestrcpy(p->name, last, sizeof(p->name));
    800051d8:	4641                	li	a2,16
    800051da:	de043583          	ld	a1,-544(s0)
    800051de:	df843983          	ld	s3,-520(s0)
    800051e2:	16898513          	addi	a0,s3,360
    800051e6:	ffffc097          	auipc	ra,0xffffc
    800051ea:	c2a080e7          	jalr	-982(ra) # 80000e10 <safestrcpy>
  oldpagetable = p->pagetable;
    800051ee:	0589b503          	ld	a0,88(s3)
  p->pagetable = pagetable;
    800051f2:	0569bc23          	sd	s6,88(s3)
  p->sz = sz;
    800051f6:	0579b823          	sd	s7,80(s3)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800051fa:	0689b783          	ld	a5,104(s3)
    800051fe:	e6043703          	ld	a4,-416(s0)
    80005202:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80005204:	0689b783          	ld	a5,104(s3)
    80005208:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000520c:	85e6                	mv	a1,s9
    8000520e:	ffffd097          	auipc	ra,0xffffd
    80005212:	b46080e7          	jalr	-1210(ra) # 80001d54 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005216:	0004851b          	sext.w	a0,s1
    8000521a:	bb55                	j	80004fce <exec+0xa2>
    8000521c:	de943823          	sd	s1,-528(s0)
    proc_freepagetable(pagetable, sz);
    80005220:	df043583          	ld	a1,-528(s0)
    80005224:	855a                	mv	a0,s6
    80005226:	ffffd097          	auipc	ra,0xffffd
    8000522a:	b2e080e7          	jalr	-1234(ra) # 80001d54 <proc_freepagetable>
  if(ip){
    8000522e:	d80a96e3          	bnez	s5,80004fba <exec+0x8e>
  return -1;
    80005232:	557d                	li	a0,-1
    80005234:	bb69                	j	80004fce <exec+0xa2>
    80005236:	de943823          	sd	s1,-528(s0)
    8000523a:	b7dd                	j	80005220 <exec+0x2f4>
    8000523c:	de943823          	sd	s1,-528(s0)
    80005240:	b7c5                	j	80005220 <exec+0x2f4>
    80005242:	de943823          	sd	s1,-528(s0)
    80005246:	bfe9                	j	80005220 <exec+0x2f4>
  sz = sz1;
    80005248:	df743823          	sd	s7,-528(s0)
  ip = 0;
    8000524c:	4a81                	li	s5,0
    8000524e:	bfc9                	j	80005220 <exec+0x2f4>
  sz = sz1;
    80005250:	df743823          	sd	s7,-528(s0)
  ip = 0;
    80005254:	4a81                	li	s5,0
    80005256:	b7e9                	j	80005220 <exec+0x2f4>
  sz = sz1;
    80005258:	df743823          	sd	s7,-528(s0)
  ip = 0;
    8000525c:	4a81                	li	s5,0
    8000525e:	b7c9                	j	80005220 <exec+0x2f4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80005260:	df043483          	ld	s1,-528(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005264:	e0843783          	ld	a5,-504(s0)
    80005268:	0017869b          	addiw	a3,a5,1
    8000526c:	e0d43423          	sd	a3,-504(s0)
    80005270:	e0043783          	ld	a5,-512(s0)
    80005274:	0387879b          	addiw	a5,a5,56
    80005278:	e8045703          	lhu	a4,-384(s0)
    8000527c:	e0e6d8e3          	bge	a3,a4,8000508c <exec+0x160>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005280:	2781                	sext.w	a5,a5
    80005282:	e0f43023          	sd	a5,-512(s0)
    80005286:	03800713          	li	a4,56
    8000528a:	86be                	mv	a3,a5
    8000528c:	e1040613          	addi	a2,s0,-496
    80005290:	4581                	li	a1,0
    80005292:	8556                	mv	a0,s5
    80005294:	fffff097          	auipc	ra,0xfffff
    80005298:	a5c080e7          	jalr	-1444(ra) # 80003cf0 <readi>
    8000529c:	03800793          	li	a5,56
    800052a0:	f6f51ee3          	bne	a0,a5,8000521c <exec+0x2f0>
    if(ph.type != ELF_PROG_LOAD)
    800052a4:	e1042783          	lw	a5,-496(s0)
    800052a8:	4705                	li	a4,1
    800052aa:	fae79de3          	bne	a5,a4,80005264 <exec+0x338>
    if(ph.memsz < ph.filesz)
    800052ae:	e3843603          	ld	a2,-456(s0)
    800052b2:	e3043783          	ld	a5,-464(s0)
    800052b6:	f8f660e3          	bltu	a2,a5,80005236 <exec+0x30a>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800052ba:	e2043783          	ld	a5,-480(s0)
    800052be:	963e                	add	a2,a2,a5
    800052c0:	f6f66ee3          	bltu	a2,a5,8000523c <exec+0x310>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800052c4:	85a6                	mv	a1,s1
    800052c6:	855a                	mv	a0,s6
    800052c8:	ffffc097          	auipc	ra,0xffffc
    800052cc:	1c2080e7          	jalr	450(ra) # 8000148a <uvmalloc>
    800052d0:	dea43823          	sd	a0,-528(s0)
    800052d4:	d53d                	beqz	a0,80005242 <exec+0x316>
    uvmapping(pagetable,p->k_pagetable,sz, ph.vaddr + ph.memsz);
    800052d6:	e2043683          	ld	a3,-480(s0)
    800052da:	e3843783          	ld	a5,-456(s0)
    800052de:	96be                	add	a3,a3,a5
    800052e0:	8626                	mv	a2,s1
    800052e2:	df843783          	ld	a5,-520(s0)
    800052e6:	73ac                	ld	a1,96(a5)
    800052e8:	855a                	mv	a0,s6
    800052ea:	ffffc097          	auipc	ra,0xffffc
    800052ee:	0b2080e7          	jalr	178(ra) # 8000139c <uvmapping>
    if(ph.vaddr % PGSIZE != 0)
    800052f2:	e2043c03          	ld	s8,-480(s0)
    800052f6:	dd843783          	ld	a5,-552(s0)
    800052fa:	00fc77b3          	and	a5,s8,a5
    800052fe:	f38d                	bnez	a5,80005220 <exec+0x2f4>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005300:	e1842c83          	lw	s9,-488(s0)
    80005304:	e3042b83          	lw	s7,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005308:	f40b8ce3          	beqz	s7,80005260 <exec+0x334>
    8000530c:	89de                	mv	s3,s7
    8000530e:	4481                	li	s1,0
    80005310:	bba9                	j	8000506a <exec+0x13e>

0000000080005312 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005312:	7179                	addi	sp,sp,-48
    80005314:	f406                	sd	ra,40(sp)
    80005316:	f022                	sd	s0,32(sp)
    80005318:	ec26                	sd	s1,24(sp)
    8000531a:	e84a                	sd	s2,16(sp)
    8000531c:	1800                	addi	s0,sp,48
    8000531e:	892e                	mv	s2,a1
    80005320:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80005322:	fdc40593          	addi	a1,s0,-36
    80005326:	ffffe097          	auipc	ra,0xffffe
    8000532a:	b2e080e7          	jalr	-1234(ra) # 80002e54 <argint>
    8000532e:	04054063          	bltz	a0,8000536e <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005332:	fdc42703          	lw	a4,-36(s0)
    80005336:	47bd                	li	a5,15
    80005338:	02e7ed63          	bltu	a5,a4,80005372 <argfd+0x60>
    8000533c:	ffffd097          	auipc	ra,0xffffd
    80005340:	8b8080e7          	jalr	-1864(ra) # 80001bf4 <myproc>
    80005344:	fdc42703          	lw	a4,-36(s0)
    80005348:	01c70793          	addi	a5,a4,28
    8000534c:	078e                	slli	a5,a5,0x3
    8000534e:	953e                	add	a0,a0,a5
    80005350:	611c                	ld	a5,0(a0)
    80005352:	c395                	beqz	a5,80005376 <argfd+0x64>
    return -1;
  if(pfd)
    80005354:	00090463          	beqz	s2,8000535c <argfd+0x4a>
    *pfd = fd;
    80005358:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000535c:	4501                	li	a0,0
  if(pf)
    8000535e:	c091                	beqz	s1,80005362 <argfd+0x50>
    *pf = f;
    80005360:	e09c                	sd	a5,0(s1)
}
    80005362:	70a2                	ld	ra,40(sp)
    80005364:	7402                	ld	s0,32(sp)
    80005366:	64e2                	ld	s1,24(sp)
    80005368:	6942                	ld	s2,16(sp)
    8000536a:	6145                	addi	sp,sp,48
    8000536c:	8082                	ret
    return -1;
    8000536e:	557d                	li	a0,-1
    80005370:	bfcd                	j	80005362 <argfd+0x50>
    return -1;
    80005372:	557d                	li	a0,-1
    80005374:	b7fd                	j	80005362 <argfd+0x50>
    80005376:	557d                	li	a0,-1
    80005378:	b7ed                	j	80005362 <argfd+0x50>

000000008000537a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000537a:	1101                	addi	sp,sp,-32
    8000537c:	ec06                	sd	ra,24(sp)
    8000537e:	e822                	sd	s0,16(sp)
    80005380:	e426                	sd	s1,8(sp)
    80005382:	1000                	addi	s0,sp,32
    80005384:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005386:	ffffd097          	auipc	ra,0xffffd
    8000538a:	86e080e7          	jalr	-1938(ra) # 80001bf4 <myproc>
    8000538e:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005390:	0e050793          	addi	a5,a0,224
    80005394:	4501                	li	a0,0
    80005396:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005398:	6398                	ld	a4,0(a5)
    8000539a:	cb19                	beqz	a4,800053b0 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000539c:	2505                	addiw	a0,a0,1
    8000539e:	07a1                	addi	a5,a5,8
    800053a0:	fed51ce3          	bne	a0,a3,80005398 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800053a4:	557d                	li	a0,-1
}
    800053a6:	60e2                	ld	ra,24(sp)
    800053a8:	6442                	ld	s0,16(sp)
    800053aa:	64a2                	ld	s1,8(sp)
    800053ac:	6105                	addi	sp,sp,32
    800053ae:	8082                	ret
      p->ofile[fd] = f;
    800053b0:	01c50793          	addi	a5,a0,28
    800053b4:	078e                	slli	a5,a5,0x3
    800053b6:	963e                	add	a2,a2,a5
    800053b8:	e204                	sd	s1,0(a2)
      return fd;
    800053ba:	b7f5                	j	800053a6 <fdalloc+0x2c>

00000000800053bc <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800053bc:	715d                	addi	sp,sp,-80
    800053be:	e486                	sd	ra,72(sp)
    800053c0:	e0a2                	sd	s0,64(sp)
    800053c2:	fc26                	sd	s1,56(sp)
    800053c4:	f84a                	sd	s2,48(sp)
    800053c6:	f44e                	sd	s3,40(sp)
    800053c8:	f052                	sd	s4,32(sp)
    800053ca:	ec56                	sd	s5,24(sp)
    800053cc:	0880                	addi	s0,sp,80
    800053ce:	89ae                	mv	s3,a1
    800053d0:	8ab2                	mv	s5,a2
    800053d2:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800053d4:	fb040593          	addi	a1,s0,-80
    800053d8:	fffff097          	auipc	ra,0xfffff
    800053dc:	e38080e7          	jalr	-456(ra) # 80004210 <nameiparent>
    800053e0:	892a                	mv	s2,a0
    800053e2:	12050e63          	beqz	a0,8000551e <create+0x162>
    return 0;

  ilock(dp);
    800053e6:	ffffe097          	auipc	ra,0xffffe
    800053ea:	656080e7          	jalr	1622(ra) # 80003a3c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800053ee:	4601                	li	a2,0
    800053f0:	fb040593          	addi	a1,s0,-80
    800053f4:	854a                	mv	a0,s2
    800053f6:	fffff097          	auipc	ra,0xfffff
    800053fa:	b2a080e7          	jalr	-1238(ra) # 80003f20 <dirlookup>
    800053fe:	84aa                	mv	s1,a0
    80005400:	c921                	beqz	a0,80005450 <create+0x94>
    iunlockput(dp);
    80005402:	854a                	mv	a0,s2
    80005404:	fffff097          	auipc	ra,0xfffff
    80005408:	89a080e7          	jalr	-1894(ra) # 80003c9e <iunlockput>
    ilock(ip);
    8000540c:	8526                	mv	a0,s1
    8000540e:	ffffe097          	auipc	ra,0xffffe
    80005412:	62e080e7          	jalr	1582(ra) # 80003a3c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005416:	2981                	sext.w	s3,s3
    80005418:	4789                	li	a5,2
    8000541a:	02f99463          	bne	s3,a5,80005442 <create+0x86>
    8000541e:	0444d783          	lhu	a5,68(s1)
    80005422:	37f9                	addiw	a5,a5,-2
    80005424:	17c2                	slli	a5,a5,0x30
    80005426:	93c1                	srli	a5,a5,0x30
    80005428:	4705                	li	a4,1
    8000542a:	00f76c63          	bltu	a4,a5,80005442 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000542e:	8526                	mv	a0,s1
    80005430:	60a6                	ld	ra,72(sp)
    80005432:	6406                	ld	s0,64(sp)
    80005434:	74e2                	ld	s1,56(sp)
    80005436:	7942                	ld	s2,48(sp)
    80005438:	79a2                	ld	s3,40(sp)
    8000543a:	7a02                	ld	s4,32(sp)
    8000543c:	6ae2                	ld	s5,24(sp)
    8000543e:	6161                	addi	sp,sp,80
    80005440:	8082                	ret
    iunlockput(ip);
    80005442:	8526                	mv	a0,s1
    80005444:	fffff097          	auipc	ra,0xfffff
    80005448:	85a080e7          	jalr	-1958(ra) # 80003c9e <iunlockput>
    return 0;
    8000544c:	4481                	li	s1,0
    8000544e:	b7c5                	j	8000542e <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80005450:	85ce                	mv	a1,s3
    80005452:	00092503          	lw	a0,0(s2)
    80005456:	ffffe097          	auipc	ra,0xffffe
    8000545a:	44e080e7          	jalr	1102(ra) # 800038a4 <ialloc>
    8000545e:	84aa                	mv	s1,a0
    80005460:	c521                	beqz	a0,800054a8 <create+0xec>
  ilock(ip);
    80005462:	ffffe097          	auipc	ra,0xffffe
    80005466:	5da080e7          	jalr	1498(ra) # 80003a3c <ilock>
  ip->major = major;
    8000546a:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    8000546e:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80005472:	4a05                	li	s4,1
    80005474:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    80005478:	8526                	mv	a0,s1
    8000547a:	ffffe097          	auipc	ra,0xffffe
    8000547e:	4f8080e7          	jalr	1272(ra) # 80003972 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005482:	2981                	sext.w	s3,s3
    80005484:	03498a63          	beq	s3,s4,800054b8 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80005488:	40d0                	lw	a2,4(s1)
    8000548a:	fb040593          	addi	a1,s0,-80
    8000548e:	854a                	mv	a0,s2
    80005490:	fffff097          	auipc	ra,0xfffff
    80005494:	ca0080e7          	jalr	-864(ra) # 80004130 <dirlink>
    80005498:	06054b63          	bltz	a0,8000550e <create+0x152>
  iunlockput(dp);
    8000549c:	854a                	mv	a0,s2
    8000549e:	fffff097          	auipc	ra,0xfffff
    800054a2:	800080e7          	jalr	-2048(ra) # 80003c9e <iunlockput>
  return ip;
    800054a6:	b761                	j	8000542e <create+0x72>
    panic("create: ialloc");
    800054a8:	00003517          	auipc	a0,0x3
    800054ac:	34050513          	addi	a0,a0,832 # 800087e8 <syscalls+0x2a8>
    800054b0:	ffffb097          	auipc	ra,0xffffb
    800054b4:	07a080e7          	jalr	122(ra) # 8000052a <panic>
    dp->nlink++;  // for ".."
    800054b8:	04a95783          	lhu	a5,74(s2)
    800054bc:	2785                	addiw	a5,a5,1
    800054be:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800054c2:	854a                	mv	a0,s2
    800054c4:	ffffe097          	auipc	ra,0xffffe
    800054c8:	4ae080e7          	jalr	1198(ra) # 80003972 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800054cc:	40d0                	lw	a2,4(s1)
    800054ce:	00003597          	auipc	a1,0x3
    800054d2:	32a58593          	addi	a1,a1,810 # 800087f8 <syscalls+0x2b8>
    800054d6:	8526                	mv	a0,s1
    800054d8:	fffff097          	auipc	ra,0xfffff
    800054dc:	c58080e7          	jalr	-936(ra) # 80004130 <dirlink>
    800054e0:	00054f63          	bltz	a0,800054fe <create+0x142>
    800054e4:	00492603          	lw	a2,4(s2)
    800054e8:	00003597          	auipc	a1,0x3
    800054ec:	d5858593          	addi	a1,a1,-680 # 80008240 <digits+0x200>
    800054f0:	8526                	mv	a0,s1
    800054f2:	fffff097          	auipc	ra,0xfffff
    800054f6:	c3e080e7          	jalr	-962(ra) # 80004130 <dirlink>
    800054fa:	f80557e3          	bgez	a0,80005488 <create+0xcc>
      panic("create dots");
    800054fe:	00003517          	auipc	a0,0x3
    80005502:	30250513          	addi	a0,a0,770 # 80008800 <syscalls+0x2c0>
    80005506:	ffffb097          	auipc	ra,0xffffb
    8000550a:	024080e7          	jalr	36(ra) # 8000052a <panic>
    panic("create: dirlink");
    8000550e:	00003517          	auipc	a0,0x3
    80005512:	30250513          	addi	a0,a0,770 # 80008810 <syscalls+0x2d0>
    80005516:	ffffb097          	auipc	ra,0xffffb
    8000551a:	014080e7          	jalr	20(ra) # 8000052a <panic>
    return 0;
    8000551e:	84aa                	mv	s1,a0
    80005520:	b739                	j	8000542e <create+0x72>

0000000080005522 <sys_dup>:
{
    80005522:	7179                	addi	sp,sp,-48
    80005524:	f406                	sd	ra,40(sp)
    80005526:	f022                	sd	s0,32(sp)
    80005528:	ec26                	sd	s1,24(sp)
    8000552a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000552c:	fd840613          	addi	a2,s0,-40
    80005530:	4581                	li	a1,0
    80005532:	4501                	li	a0,0
    80005534:	00000097          	auipc	ra,0x0
    80005538:	dde080e7          	jalr	-546(ra) # 80005312 <argfd>
    return -1;
    8000553c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000553e:	02054363          	bltz	a0,80005564 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80005542:	fd843503          	ld	a0,-40(s0)
    80005546:	00000097          	auipc	ra,0x0
    8000554a:	e34080e7          	jalr	-460(ra) # 8000537a <fdalloc>
    8000554e:	84aa                	mv	s1,a0
    return -1;
    80005550:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005552:	00054963          	bltz	a0,80005564 <sys_dup+0x42>
  filedup(f);
    80005556:	fd843503          	ld	a0,-40(s0)
    8000555a:	fffff097          	auipc	ra,0xfffff
    8000555e:	32e080e7          	jalr	814(ra) # 80004888 <filedup>
  return fd;
    80005562:	87a6                	mv	a5,s1
}
    80005564:	853e                	mv	a0,a5
    80005566:	70a2                	ld	ra,40(sp)
    80005568:	7402                	ld	s0,32(sp)
    8000556a:	64e2                	ld	s1,24(sp)
    8000556c:	6145                	addi	sp,sp,48
    8000556e:	8082                	ret

0000000080005570 <sys_read>:
{
    80005570:	7179                	addi	sp,sp,-48
    80005572:	f406                	sd	ra,40(sp)
    80005574:	f022                	sd	s0,32(sp)
    80005576:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005578:	fe840613          	addi	a2,s0,-24
    8000557c:	4581                	li	a1,0
    8000557e:	4501                	li	a0,0
    80005580:	00000097          	auipc	ra,0x0
    80005584:	d92080e7          	jalr	-622(ra) # 80005312 <argfd>
    return -1;
    80005588:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000558a:	04054163          	bltz	a0,800055cc <sys_read+0x5c>
    8000558e:	fe440593          	addi	a1,s0,-28
    80005592:	4509                	li	a0,2
    80005594:	ffffe097          	auipc	ra,0xffffe
    80005598:	8c0080e7          	jalr	-1856(ra) # 80002e54 <argint>
    return -1;
    8000559c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000559e:	02054763          	bltz	a0,800055cc <sys_read+0x5c>
    800055a2:	fd840593          	addi	a1,s0,-40
    800055a6:	4505                	li	a0,1
    800055a8:	ffffe097          	auipc	ra,0xffffe
    800055ac:	8ce080e7          	jalr	-1842(ra) # 80002e76 <argaddr>
    return -1;
    800055b0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800055b2:	00054d63          	bltz	a0,800055cc <sys_read+0x5c>
  return fileread(f, p, n);
    800055b6:	fe442603          	lw	a2,-28(s0)
    800055ba:	fd843583          	ld	a1,-40(s0)
    800055be:	fe843503          	ld	a0,-24(s0)
    800055c2:	fffff097          	auipc	ra,0xfffff
    800055c6:	452080e7          	jalr	1106(ra) # 80004a14 <fileread>
    800055ca:	87aa                	mv	a5,a0
}
    800055cc:	853e                	mv	a0,a5
    800055ce:	70a2                	ld	ra,40(sp)
    800055d0:	7402                	ld	s0,32(sp)
    800055d2:	6145                	addi	sp,sp,48
    800055d4:	8082                	ret

00000000800055d6 <sys_write>:
{
    800055d6:	7179                	addi	sp,sp,-48
    800055d8:	f406                	sd	ra,40(sp)
    800055da:	f022                	sd	s0,32(sp)
    800055dc:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800055de:	fe840613          	addi	a2,s0,-24
    800055e2:	4581                	li	a1,0
    800055e4:	4501                	li	a0,0
    800055e6:	00000097          	auipc	ra,0x0
    800055ea:	d2c080e7          	jalr	-724(ra) # 80005312 <argfd>
    return -1;
    800055ee:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800055f0:	04054163          	bltz	a0,80005632 <sys_write+0x5c>
    800055f4:	fe440593          	addi	a1,s0,-28
    800055f8:	4509                	li	a0,2
    800055fa:	ffffe097          	auipc	ra,0xffffe
    800055fe:	85a080e7          	jalr	-1958(ra) # 80002e54 <argint>
    return -1;
    80005602:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005604:	02054763          	bltz	a0,80005632 <sys_write+0x5c>
    80005608:	fd840593          	addi	a1,s0,-40
    8000560c:	4505                	li	a0,1
    8000560e:	ffffe097          	auipc	ra,0xffffe
    80005612:	868080e7          	jalr	-1944(ra) # 80002e76 <argaddr>
    return -1;
    80005616:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005618:	00054d63          	bltz	a0,80005632 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000561c:	fe442603          	lw	a2,-28(s0)
    80005620:	fd843583          	ld	a1,-40(s0)
    80005624:	fe843503          	ld	a0,-24(s0)
    80005628:	fffff097          	auipc	ra,0xfffff
    8000562c:	4ae080e7          	jalr	1198(ra) # 80004ad6 <filewrite>
    80005630:	87aa                	mv	a5,a0
}
    80005632:	853e                	mv	a0,a5
    80005634:	70a2                	ld	ra,40(sp)
    80005636:	7402                	ld	s0,32(sp)
    80005638:	6145                	addi	sp,sp,48
    8000563a:	8082                	ret

000000008000563c <sys_close>:
{
    8000563c:	1101                	addi	sp,sp,-32
    8000563e:	ec06                	sd	ra,24(sp)
    80005640:	e822                	sd	s0,16(sp)
    80005642:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005644:	fe040613          	addi	a2,s0,-32
    80005648:	fec40593          	addi	a1,s0,-20
    8000564c:	4501                	li	a0,0
    8000564e:	00000097          	auipc	ra,0x0
    80005652:	cc4080e7          	jalr	-828(ra) # 80005312 <argfd>
    return -1;
    80005656:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005658:	02054463          	bltz	a0,80005680 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000565c:	ffffc097          	auipc	ra,0xffffc
    80005660:	598080e7          	jalr	1432(ra) # 80001bf4 <myproc>
    80005664:	fec42783          	lw	a5,-20(s0)
    80005668:	07f1                	addi	a5,a5,28
    8000566a:	078e                	slli	a5,a5,0x3
    8000566c:	97aa                	add	a5,a5,a0
    8000566e:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80005672:	fe043503          	ld	a0,-32(s0)
    80005676:	fffff097          	auipc	ra,0xfffff
    8000567a:	264080e7          	jalr	612(ra) # 800048da <fileclose>
  return 0;
    8000567e:	4781                	li	a5,0
}
    80005680:	853e                	mv	a0,a5
    80005682:	60e2                	ld	ra,24(sp)
    80005684:	6442                	ld	s0,16(sp)
    80005686:	6105                	addi	sp,sp,32
    80005688:	8082                	ret

000000008000568a <sys_fstat>:
{
    8000568a:	1101                	addi	sp,sp,-32
    8000568c:	ec06                	sd	ra,24(sp)
    8000568e:	e822                	sd	s0,16(sp)
    80005690:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005692:	fe840613          	addi	a2,s0,-24
    80005696:	4581                	li	a1,0
    80005698:	4501                	li	a0,0
    8000569a:	00000097          	auipc	ra,0x0
    8000569e:	c78080e7          	jalr	-904(ra) # 80005312 <argfd>
    return -1;
    800056a2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800056a4:	02054563          	bltz	a0,800056ce <sys_fstat+0x44>
    800056a8:	fe040593          	addi	a1,s0,-32
    800056ac:	4505                	li	a0,1
    800056ae:	ffffd097          	auipc	ra,0xffffd
    800056b2:	7c8080e7          	jalr	1992(ra) # 80002e76 <argaddr>
    return -1;
    800056b6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800056b8:	00054b63          	bltz	a0,800056ce <sys_fstat+0x44>
  return filestat(f, st);
    800056bc:	fe043583          	ld	a1,-32(s0)
    800056c0:	fe843503          	ld	a0,-24(s0)
    800056c4:	fffff097          	auipc	ra,0xfffff
    800056c8:	2de080e7          	jalr	734(ra) # 800049a2 <filestat>
    800056cc:	87aa                	mv	a5,a0
}
    800056ce:	853e                	mv	a0,a5
    800056d0:	60e2                	ld	ra,24(sp)
    800056d2:	6442                	ld	s0,16(sp)
    800056d4:	6105                	addi	sp,sp,32
    800056d6:	8082                	ret

00000000800056d8 <sys_link>:
{
    800056d8:	7169                	addi	sp,sp,-304
    800056da:	f606                	sd	ra,296(sp)
    800056dc:	f222                	sd	s0,288(sp)
    800056de:	ee26                	sd	s1,280(sp)
    800056e0:	ea4a                	sd	s2,272(sp)
    800056e2:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800056e4:	08000613          	li	a2,128
    800056e8:	ed040593          	addi	a1,s0,-304
    800056ec:	4501                	li	a0,0
    800056ee:	ffffd097          	auipc	ra,0xffffd
    800056f2:	7aa080e7          	jalr	1962(ra) # 80002e98 <argstr>
    return -1;
    800056f6:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800056f8:	10054e63          	bltz	a0,80005814 <sys_link+0x13c>
    800056fc:	08000613          	li	a2,128
    80005700:	f5040593          	addi	a1,s0,-176
    80005704:	4505                	li	a0,1
    80005706:	ffffd097          	auipc	ra,0xffffd
    8000570a:	792080e7          	jalr	1938(ra) # 80002e98 <argstr>
    return -1;
    8000570e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005710:	10054263          	bltz	a0,80005814 <sys_link+0x13c>
  begin_op();
    80005714:	fffff097          	auipc	ra,0xfffff
    80005718:	cfa080e7          	jalr	-774(ra) # 8000440e <begin_op>
  if((ip = namei(old)) == 0){
    8000571c:	ed040513          	addi	a0,s0,-304
    80005720:	fffff097          	auipc	ra,0xfffff
    80005724:	ad2080e7          	jalr	-1326(ra) # 800041f2 <namei>
    80005728:	84aa                	mv	s1,a0
    8000572a:	c551                	beqz	a0,800057b6 <sys_link+0xde>
  ilock(ip);
    8000572c:	ffffe097          	auipc	ra,0xffffe
    80005730:	310080e7          	jalr	784(ra) # 80003a3c <ilock>
  if(ip->type == T_DIR){
    80005734:	04449703          	lh	a4,68(s1)
    80005738:	4785                	li	a5,1
    8000573a:	08f70463          	beq	a4,a5,800057c2 <sys_link+0xea>
  ip->nlink++;
    8000573e:	04a4d783          	lhu	a5,74(s1)
    80005742:	2785                	addiw	a5,a5,1
    80005744:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005748:	8526                	mv	a0,s1
    8000574a:	ffffe097          	auipc	ra,0xffffe
    8000574e:	228080e7          	jalr	552(ra) # 80003972 <iupdate>
  iunlock(ip);
    80005752:	8526                	mv	a0,s1
    80005754:	ffffe097          	auipc	ra,0xffffe
    80005758:	3aa080e7          	jalr	938(ra) # 80003afe <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000575c:	fd040593          	addi	a1,s0,-48
    80005760:	f5040513          	addi	a0,s0,-176
    80005764:	fffff097          	auipc	ra,0xfffff
    80005768:	aac080e7          	jalr	-1364(ra) # 80004210 <nameiparent>
    8000576c:	892a                	mv	s2,a0
    8000576e:	c935                	beqz	a0,800057e2 <sys_link+0x10a>
  ilock(dp);
    80005770:	ffffe097          	auipc	ra,0xffffe
    80005774:	2cc080e7          	jalr	716(ra) # 80003a3c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005778:	00092703          	lw	a4,0(s2)
    8000577c:	409c                	lw	a5,0(s1)
    8000577e:	04f71d63          	bne	a4,a5,800057d8 <sys_link+0x100>
    80005782:	40d0                	lw	a2,4(s1)
    80005784:	fd040593          	addi	a1,s0,-48
    80005788:	854a                	mv	a0,s2
    8000578a:	fffff097          	auipc	ra,0xfffff
    8000578e:	9a6080e7          	jalr	-1626(ra) # 80004130 <dirlink>
    80005792:	04054363          	bltz	a0,800057d8 <sys_link+0x100>
  iunlockput(dp);
    80005796:	854a                	mv	a0,s2
    80005798:	ffffe097          	auipc	ra,0xffffe
    8000579c:	506080e7          	jalr	1286(ra) # 80003c9e <iunlockput>
  iput(ip);
    800057a0:	8526                	mv	a0,s1
    800057a2:	ffffe097          	auipc	ra,0xffffe
    800057a6:	454080e7          	jalr	1108(ra) # 80003bf6 <iput>
  end_op();
    800057aa:	fffff097          	auipc	ra,0xfffff
    800057ae:	ce4080e7          	jalr	-796(ra) # 8000448e <end_op>
  return 0;
    800057b2:	4781                	li	a5,0
    800057b4:	a085                	j	80005814 <sys_link+0x13c>
    end_op();
    800057b6:	fffff097          	auipc	ra,0xfffff
    800057ba:	cd8080e7          	jalr	-808(ra) # 8000448e <end_op>
    return -1;
    800057be:	57fd                	li	a5,-1
    800057c0:	a891                	j	80005814 <sys_link+0x13c>
    iunlockput(ip);
    800057c2:	8526                	mv	a0,s1
    800057c4:	ffffe097          	auipc	ra,0xffffe
    800057c8:	4da080e7          	jalr	1242(ra) # 80003c9e <iunlockput>
    end_op();
    800057cc:	fffff097          	auipc	ra,0xfffff
    800057d0:	cc2080e7          	jalr	-830(ra) # 8000448e <end_op>
    return -1;
    800057d4:	57fd                	li	a5,-1
    800057d6:	a83d                	j	80005814 <sys_link+0x13c>
    iunlockput(dp);
    800057d8:	854a                	mv	a0,s2
    800057da:	ffffe097          	auipc	ra,0xffffe
    800057de:	4c4080e7          	jalr	1220(ra) # 80003c9e <iunlockput>
  ilock(ip);
    800057e2:	8526                	mv	a0,s1
    800057e4:	ffffe097          	auipc	ra,0xffffe
    800057e8:	258080e7          	jalr	600(ra) # 80003a3c <ilock>
  ip->nlink--;
    800057ec:	04a4d783          	lhu	a5,74(s1)
    800057f0:	37fd                	addiw	a5,a5,-1
    800057f2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800057f6:	8526                	mv	a0,s1
    800057f8:	ffffe097          	auipc	ra,0xffffe
    800057fc:	17a080e7          	jalr	378(ra) # 80003972 <iupdate>
  iunlockput(ip);
    80005800:	8526                	mv	a0,s1
    80005802:	ffffe097          	auipc	ra,0xffffe
    80005806:	49c080e7          	jalr	1180(ra) # 80003c9e <iunlockput>
  end_op();
    8000580a:	fffff097          	auipc	ra,0xfffff
    8000580e:	c84080e7          	jalr	-892(ra) # 8000448e <end_op>
  return -1;
    80005812:	57fd                	li	a5,-1
}
    80005814:	853e                	mv	a0,a5
    80005816:	70b2                	ld	ra,296(sp)
    80005818:	7412                	ld	s0,288(sp)
    8000581a:	64f2                	ld	s1,280(sp)
    8000581c:	6952                	ld	s2,272(sp)
    8000581e:	6155                	addi	sp,sp,304
    80005820:	8082                	ret

0000000080005822 <sys_unlink>:
{
    80005822:	7151                	addi	sp,sp,-240
    80005824:	f586                	sd	ra,232(sp)
    80005826:	f1a2                	sd	s0,224(sp)
    80005828:	eda6                	sd	s1,216(sp)
    8000582a:	e9ca                	sd	s2,208(sp)
    8000582c:	e5ce                	sd	s3,200(sp)
    8000582e:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005830:	08000613          	li	a2,128
    80005834:	f3040593          	addi	a1,s0,-208
    80005838:	4501                	li	a0,0
    8000583a:	ffffd097          	auipc	ra,0xffffd
    8000583e:	65e080e7          	jalr	1630(ra) # 80002e98 <argstr>
    80005842:	18054163          	bltz	a0,800059c4 <sys_unlink+0x1a2>
  begin_op();
    80005846:	fffff097          	auipc	ra,0xfffff
    8000584a:	bc8080e7          	jalr	-1080(ra) # 8000440e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000584e:	fb040593          	addi	a1,s0,-80
    80005852:	f3040513          	addi	a0,s0,-208
    80005856:	fffff097          	auipc	ra,0xfffff
    8000585a:	9ba080e7          	jalr	-1606(ra) # 80004210 <nameiparent>
    8000585e:	84aa                	mv	s1,a0
    80005860:	c979                	beqz	a0,80005936 <sys_unlink+0x114>
  ilock(dp);
    80005862:	ffffe097          	auipc	ra,0xffffe
    80005866:	1da080e7          	jalr	474(ra) # 80003a3c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000586a:	00003597          	auipc	a1,0x3
    8000586e:	f8e58593          	addi	a1,a1,-114 # 800087f8 <syscalls+0x2b8>
    80005872:	fb040513          	addi	a0,s0,-80
    80005876:	ffffe097          	auipc	ra,0xffffe
    8000587a:	690080e7          	jalr	1680(ra) # 80003f06 <namecmp>
    8000587e:	14050a63          	beqz	a0,800059d2 <sys_unlink+0x1b0>
    80005882:	00003597          	auipc	a1,0x3
    80005886:	9be58593          	addi	a1,a1,-1602 # 80008240 <digits+0x200>
    8000588a:	fb040513          	addi	a0,s0,-80
    8000588e:	ffffe097          	auipc	ra,0xffffe
    80005892:	678080e7          	jalr	1656(ra) # 80003f06 <namecmp>
    80005896:	12050e63          	beqz	a0,800059d2 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000589a:	f2c40613          	addi	a2,s0,-212
    8000589e:	fb040593          	addi	a1,s0,-80
    800058a2:	8526                	mv	a0,s1
    800058a4:	ffffe097          	auipc	ra,0xffffe
    800058a8:	67c080e7          	jalr	1660(ra) # 80003f20 <dirlookup>
    800058ac:	892a                	mv	s2,a0
    800058ae:	12050263          	beqz	a0,800059d2 <sys_unlink+0x1b0>
  ilock(ip);
    800058b2:	ffffe097          	auipc	ra,0xffffe
    800058b6:	18a080e7          	jalr	394(ra) # 80003a3c <ilock>
  if(ip->nlink < 1)
    800058ba:	04a91783          	lh	a5,74(s2)
    800058be:	08f05263          	blez	a5,80005942 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800058c2:	04491703          	lh	a4,68(s2)
    800058c6:	4785                	li	a5,1
    800058c8:	08f70563          	beq	a4,a5,80005952 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800058cc:	4641                	li	a2,16
    800058ce:	4581                	li	a1,0
    800058d0:	fc040513          	addi	a0,s0,-64
    800058d4:	ffffb097          	auipc	ra,0xffffb
    800058d8:	3ea080e7          	jalr	1002(ra) # 80000cbe <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800058dc:	4741                	li	a4,16
    800058de:	f2c42683          	lw	a3,-212(s0)
    800058e2:	fc040613          	addi	a2,s0,-64
    800058e6:	4581                	li	a1,0
    800058e8:	8526                	mv	a0,s1
    800058ea:	ffffe097          	auipc	ra,0xffffe
    800058ee:	4fe080e7          	jalr	1278(ra) # 80003de8 <writei>
    800058f2:	47c1                	li	a5,16
    800058f4:	0af51563          	bne	a0,a5,8000599e <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800058f8:	04491703          	lh	a4,68(s2)
    800058fc:	4785                	li	a5,1
    800058fe:	0af70863          	beq	a4,a5,800059ae <sys_unlink+0x18c>
  iunlockput(dp);
    80005902:	8526                	mv	a0,s1
    80005904:	ffffe097          	auipc	ra,0xffffe
    80005908:	39a080e7          	jalr	922(ra) # 80003c9e <iunlockput>
  ip->nlink--;
    8000590c:	04a95783          	lhu	a5,74(s2)
    80005910:	37fd                	addiw	a5,a5,-1
    80005912:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005916:	854a                	mv	a0,s2
    80005918:	ffffe097          	auipc	ra,0xffffe
    8000591c:	05a080e7          	jalr	90(ra) # 80003972 <iupdate>
  iunlockput(ip);
    80005920:	854a                	mv	a0,s2
    80005922:	ffffe097          	auipc	ra,0xffffe
    80005926:	37c080e7          	jalr	892(ra) # 80003c9e <iunlockput>
  end_op();
    8000592a:	fffff097          	auipc	ra,0xfffff
    8000592e:	b64080e7          	jalr	-1180(ra) # 8000448e <end_op>
  return 0;
    80005932:	4501                	li	a0,0
    80005934:	a84d                	j	800059e6 <sys_unlink+0x1c4>
    end_op();
    80005936:	fffff097          	auipc	ra,0xfffff
    8000593a:	b58080e7          	jalr	-1192(ra) # 8000448e <end_op>
    return -1;
    8000593e:	557d                	li	a0,-1
    80005940:	a05d                	j	800059e6 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005942:	00003517          	auipc	a0,0x3
    80005946:	ede50513          	addi	a0,a0,-290 # 80008820 <syscalls+0x2e0>
    8000594a:	ffffb097          	auipc	ra,0xffffb
    8000594e:	be0080e7          	jalr	-1056(ra) # 8000052a <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005952:	04c92703          	lw	a4,76(s2)
    80005956:	02000793          	li	a5,32
    8000595a:	f6e7f9e3          	bgeu	a5,a4,800058cc <sys_unlink+0xaa>
    8000595e:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005962:	4741                	li	a4,16
    80005964:	86ce                	mv	a3,s3
    80005966:	f1840613          	addi	a2,s0,-232
    8000596a:	4581                	li	a1,0
    8000596c:	854a                	mv	a0,s2
    8000596e:	ffffe097          	auipc	ra,0xffffe
    80005972:	382080e7          	jalr	898(ra) # 80003cf0 <readi>
    80005976:	47c1                	li	a5,16
    80005978:	00f51b63          	bne	a0,a5,8000598e <sys_unlink+0x16c>
    if(de.inum != 0)
    8000597c:	f1845783          	lhu	a5,-232(s0)
    80005980:	e7a1                	bnez	a5,800059c8 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005982:	29c1                	addiw	s3,s3,16
    80005984:	04c92783          	lw	a5,76(s2)
    80005988:	fcf9ede3          	bltu	s3,a5,80005962 <sys_unlink+0x140>
    8000598c:	b781                	j	800058cc <sys_unlink+0xaa>
      panic("isdirempty: readi");
    8000598e:	00003517          	auipc	a0,0x3
    80005992:	eaa50513          	addi	a0,a0,-342 # 80008838 <syscalls+0x2f8>
    80005996:	ffffb097          	auipc	ra,0xffffb
    8000599a:	b94080e7          	jalr	-1132(ra) # 8000052a <panic>
    panic("unlink: writei");
    8000599e:	00003517          	auipc	a0,0x3
    800059a2:	eb250513          	addi	a0,a0,-334 # 80008850 <syscalls+0x310>
    800059a6:	ffffb097          	auipc	ra,0xffffb
    800059aa:	b84080e7          	jalr	-1148(ra) # 8000052a <panic>
    dp->nlink--;
    800059ae:	04a4d783          	lhu	a5,74(s1)
    800059b2:	37fd                	addiw	a5,a5,-1
    800059b4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800059b8:	8526                	mv	a0,s1
    800059ba:	ffffe097          	auipc	ra,0xffffe
    800059be:	fb8080e7          	jalr	-72(ra) # 80003972 <iupdate>
    800059c2:	b781                	j	80005902 <sys_unlink+0xe0>
    return -1;
    800059c4:	557d                	li	a0,-1
    800059c6:	a005                	j	800059e6 <sys_unlink+0x1c4>
    iunlockput(ip);
    800059c8:	854a                	mv	a0,s2
    800059ca:	ffffe097          	auipc	ra,0xffffe
    800059ce:	2d4080e7          	jalr	724(ra) # 80003c9e <iunlockput>
  iunlockput(dp);
    800059d2:	8526                	mv	a0,s1
    800059d4:	ffffe097          	auipc	ra,0xffffe
    800059d8:	2ca080e7          	jalr	714(ra) # 80003c9e <iunlockput>
  end_op();
    800059dc:	fffff097          	auipc	ra,0xfffff
    800059e0:	ab2080e7          	jalr	-1358(ra) # 8000448e <end_op>
  return -1;
    800059e4:	557d                	li	a0,-1
}
    800059e6:	70ae                	ld	ra,232(sp)
    800059e8:	740e                	ld	s0,224(sp)
    800059ea:	64ee                	ld	s1,216(sp)
    800059ec:	694e                	ld	s2,208(sp)
    800059ee:	69ae                	ld	s3,200(sp)
    800059f0:	616d                	addi	sp,sp,240
    800059f2:	8082                	ret

00000000800059f4 <sys_open>:

uint64
sys_open(void)
{
    800059f4:	7131                	addi	sp,sp,-192
    800059f6:	fd06                	sd	ra,184(sp)
    800059f8:	f922                	sd	s0,176(sp)
    800059fa:	f526                	sd	s1,168(sp)
    800059fc:	f14a                	sd	s2,160(sp)
    800059fe:	ed4e                	sd	s3,152(sp)
    80005a00:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005a02:	08000613          	li	a2,128
    80005a06:	f5040593          	addi	a1,s0,-176
    80005a0a:	4501                	li	a0,0
    80005a0c:	ffffd097          	auipc	ra,0xffffd
    80005a10:	48c080e7          	jalr	1164(ra) # 80002e98 <argstr>
    return -1;
    80005a14:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005a16:	0c054163          	bltz	a0,80005ad8 <sys_open+0xe4>
    80005a1a:	f4c40593          	addi	a1,s0,-180
    80005a1e:	4505                	li	a0,1
    80005a20:	ffffd097          	auipc	ra,0xffffd
    80005a24:	434080e7          	jalr	1076(ra) # 80002e54 <argint>
    80005a28:	0a054863          	bltz	a0,80005ad8 <sys_open+0xe4>

  begin_op();
    80005a2c:	fffff097          	auipc	ra,0xfffff
    80005a30:	9e2080e7          	jalr	-1566(ra) # 8000440e <begin_op>

  if(omode & O_CREATE){
    80005a34:	f4c42783          	lw	a5,-180(s0)
    80005a38:	2007f793          	andi	a5,a5,512
    80005a3c:	cbdd                	beqz	a5,80005af2 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005a3e:	4681                	li	a3,0
    80005a40:	4601                	li	a2,0
    80005a42:	4589                	li	a1,2
    80005a44:	f5040513          	addi	a0,s0,-176
    80005a48:	00000097          	auipc	ra,0x0
    80005a4c:	974080e7          	jalr	-1676(ra) # 800053bc <create>
    80005a50:	892a                	mv	s2,a0
    if(ip == 0){
    80005a52:	c959                	beqz	a0,80005ae8 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005a54:	04491703          	lh	a4,68(s2)
    80005a58:	478d                	li	a5,3
    80005a5a:	00f71763          	bne	a4,a5,80005a68 <sys_open+0x74>
    80005a5e:	04695703          	lhu	a4,70(s2)
    80005a62:	47a5                	li	a5,9
    80005a64:	0ce7ec63          	bltu	a5,a4,80005b3c <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005a68:	fffff097          	auipc	ra,0xfffff
    80005a6c:	db6080e7          	jalr	-586(ra) # 8000481e <filealloc>
    80005a70:	89aa                	mv	s3,a0
    80005a72:	10050263          	beqz	a0,80005b76 <sys_open+0x182>
    80005a76:	00000097          	auipc	ra,0x0
    80005a7a:	904080e7          	jalr	-1788(ra) # 8000537a <fdalloc>
    80005a7e:	84aa                	mv	s1,a0
    80005a80:	0e054663          	bltz	a0,80005b6c <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005a84:	04491703          	lh	a4,68(s2)
    80005a88:	478d                	li	a5,3
    80005a8a:	0cf70463          	beq	a4,a5,80005b52 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005a8e:	4789                	li	a5,2
    80005a90:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005a94:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005a98:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005a9c:	f4c42783          	lw	a5,-180(s0)
    80005aa0:	0017c713          	xori	a4,a5,1
    80005aa4:	8b05                	andi	a4,a4,1
    80005aa6:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005aaa:	0037f713          	andi	a4,a5,3
    80005aae:	00e03733          	snez	a4,a4
    80005ab2:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005ab6:	4007f793          	andi	a5,a5,1024
    80005aba:	c791                	beqz	a5,80005ac6 <sys_open+0xd2>
    80005abc:	04491703          	lh	a4,68(s2)
    80005ac0:	4789                	li	a5,2
    80005ac2:	08f70f63          	beq	a4,a5,80005b60 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005ac6:	854a                	mv	a0,s2
    80005ac8:	ffffe097          	auipc	ra,0xffffe
    80005acc:	036080e7          	jalr	54(ra) # 80003afe <iunlock>
  end_op();
    80005ad0:	fffff097          	auipc	ra,0xfffff
    80005ad4:	9be080e7          	jalr	-1602(ra) # 8000448e <end_op>

  return fd;
}
    80005ad8:	8526                	mv	a0,s1
    80005ada:	70ea                	ld	ra,184(sp)
    80005adc:	744a                	ld	s0,176(sp)
    80005ade:	74aa                	ld	s1,168(sp)
    80005ae0:	790a                	ld	s2,160(sp)
    80005ae2:	69ea                	ld	s3,152(sp)
    80005ae4:	6129                	addi	sp,sp,192
    80005ae6:	8082                	ret
      end_op();
    80005ae8:	fffff097          	auipc	ra,0xfffff
    80005aec:	9a6080e7          	jalr	-1626(ra) # 8000448e <end_op>
      return -1;
    80005af0:	b7e5                	j	80005ad8 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80005af2:	f5040513          	addi	a0,s0,-176
    80005af6:	ffffe097          	auipc	ra,0xffffe
    80005afa:	6fc080e7          	jalr	1788(ra) # 800041f2 <namei>
    80005afe:	892a                	mv	s2,a0
    80005b00:	c905                	beqz	a0,80005b30 <sys_open+0x13c>
    ilock(ip);
    80005b02:	ffffe097          	auipc	ra,0xffffe
    80005b06:	f3a080e7          	jalr	-198(ra) # 80003a3c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005b0a:	04491703          	lh	a4,68(s2)
    80005b0e:	4785                	li	a5,1
    80005b10:	f4f712e3          	bne	a4,a5,80005a54 <sys_open+0x60>
    80005b14:	f4c42783          	lw	a5,-180(s0)
    80005b18:	dba1                	beqz	a5,80005a68 <sys_open+0x74>
      iunlockput(ip);
    80005b1a:	854a                	mv	a0,s2
    80005b1c:	ffffe097          	auipc	ra,0xffffe
    80005b20:	182080e7          	jalr	386(ra) # 80003c9e <iunlockput>
      end_op();
    80005b24:	fffff097          	auipc	ra,0xfffff
    80005b28:	96a080e7          	jalr	-1686(ra) # 8000448e <end_op>
      return -1;
    80005b2c:	54fd                	li	s1,-1
    80005b2e:	b76d                	j	80005ad8 <sys_open+0xe4>
      end_op();
    80005b30:	fffff097          	auipc	ra,0xfffff
    80005b34:	95e080e7          	jalr	-1698(ra) # 8000448e <end_op>
      return -1;
    80005b38:	54fd                	li	s1,-1
    80005b3a:	bf79                	j	80005ad8 <sys_open+0xe4>
    iunlockput(ip);
    80005b3c:	854a                	mv	a0,s2
    80005b3e:	ffffe097          	auipc	ra,0xffffe
    80005b42:	160080e7          	jalr	352(ra) # 80003c9e <iunlockput>
    end_op();
    80005b46:	fffff097          	auipc	ra,0xfffff
    80005b4a:	948080e7          	jalr	-1720(ra) # 8000448e <end_op>
    return -1;
    80005b4e:	54fd                	li	s1,-1
    80005b50:	b761                	j	80005ad8 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005b52:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005b56:	04691783          	lh	a5,70(s2)
    80005b5a:	02f99223          	sh	a5,36(s3)
    80005b5e:	bf2d                	j	80005a98 <sys_open+0xa4>
    itrunc(ip);
    80005b60:	854a                	mv	a0,s2
    80005b62:	ffffe097          	auipc	ra,0xffffe
    80005b66:	fe8080e7          	jalr	-24(ra) # 80003b4a <itrunc>
    80005b6a:	bfb1                	j	80005ac6 <sys_open+0xd2>
      fileclose(f);
    80005b6c:	854e                	mv	a0,s3
    80005b6e:	fffff097          	auipc	ra,0xfffff
    80005b72:	d6c080e7          	jalr	-660(ra) # 800048da <fileclose>
    iunlockput(ip);
    80005b76:	854a                	mv	a0,s2
    80005b78:	ffffe097          	auipc	ra,0xffffe
    80005b7c:	126080e7          	jalr	294(ra) # 80003c9e <iunlockput>
    end_op();
    80005b80:	fffff097          	auipc	ra,0xfffff
    80005b84:	90e080e7          	jalr	-1778(ra) # 8000448e <end_op>
    return -1;
    80005b88:	54fd                	li	s1,-1
    80005b8a:	b7b9                	j	80005ad8 <sys_open+0xe4>

0000000080005b8c <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005b8c:	7175                	addi	sp,sp,-144
    80005b8e:	e506                	sd	ra,136(sp)
    80005b90:	e122                	sd	s0,128(sp)
    80005b92:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005b94:	fffff097          	auipc	ra,0xfffff
    80005b98:	87a080e7          	jalr	-1926(ra) # 8000440e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005b9c:	08000613          	li	a2,128
    80005ba0:	f7040593          	addi	a1,s0,-144
    80005ba4:	4501                	li	a0,0
    80005ba6:	ffffd097          	auipc	ra,0xffffd
    80005baa:	2f2080e7          	jalr	754(ra) # 80002e98 <argstr>
    80005bae:	02054963          	bltz	a0,80005be0 <sys_mkdir+0x54>
    80005bb2:	4681                	li	a3,0
    80005bb4:	4601                	li	a2,0
    80005bb6:	4585                	li	a1,1
    80005bb8:	f7040513          	addi	a0,s0,-144
    80005bbc:	00000097          	auipc	ra,0x0
    80005bc0:	800080e7          	jalr	-2048(ra) # 800053bc <create>
    80005bc4:	cd11                	beqz	a0,80005be0 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005bc6:	ffffe097          	auipc	ra,0xffffe
    80005bca:	0d8080e7          	jalr	216(ra) # 80003c9e <iunlockput>
  end_op();
    80005bce:	fffff097          	auipc	ra,0xfffff
    80005bd2:	8c0080e7          	jalr	-1856(ra) # 8000448e <end_op>
  return 0;
    80005bd6:	4501                	li	a0,0
}
    80005bd8:	60aa                	ld	ra,136(sp)
    80005bda:	640a                	ld	s0,128(sp)
    80005bdc:	6149                	addi	sp,sp,144
    80005bde:	8082                	ret
    end_op();
    80005be0:	fffff097          	auipc	ra,0xfffff
    80005be4:	8ae080e7          	jalr	-1874(ra) # 8000448e <end_op>
    return -1;
    80005be8:	557d                	li	a0,-1
    80005bea:	b7fd                	j	80005bd8 <sys_mkdir+0x4c>

0000000080005bec <sys_mknod>:

uint64
sys_mknod(void)
{
    80005bec:	7135                	addi	sp,sp,-160
    80005bee:	ed06                	sd	ra,152(sp)
    80005bf0:	e922                	sd	s0,144(sp)
    80005bf2:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005bf4:	fffff097          	auipc	ra,0xfffff
    80005bf8:	81a080e7          	jalr	-2022(ra) # 8000440e <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005bfc:	08000613          	li	a2,128
    80005c00:	f7040593          	addi	a1,s0,-144
    80005c04:	4501                	li	a0,0
    80005c06:	ffffd097          	auipc	ra,0xffffd
    80005c0a:	292080e7          	jalr	658(ra) # 80002e98 <argstr>
    80005c0e:	04054a63          	bltz	a0,80005c62 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80005c12:	f6c40593          	addi	a1,s0,-148
    80005c16:	4505                	li	a0,1
    80005c18:	ffffd097          	auipc	ra,0xffffd
    80005c1c:	23c080e7          	jalr	572(ra) # 80002e54 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005c20:	04054163          	bltz	a0,80005c62 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005c24:	f6840593          	addi	a1,s0,-152
    80005c28:	4509                	li	a0,2
    80005c2a:	ffffd097          	auipc	ra,0xffffd
    80005c2e:	22a080e7          	jalr	554(ra) # 80002e54 <argint>
     argint(1, &major) < 0 ||
    80005c32:	02054863          	bltz	a0,80005c62 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005c36:	f6841683          	lh	a3,-152(s0)
    80005c3a:	f6c41603          	lh	a2,-148(s0)
    80005c3e:	458d                	li	a1,3
    80005c40:	f7040513          	addi	a0,s0,-144
    80005c44:	fffff097          	auipc	ra,0xfffff
    80005c48:	778080e7          	jalr	1912(ra) # 800053bc <create>
     argint(2, &minor) < 0 ||
    80005c4c:	c919                	beqz	a0,80005c62 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005c4e:	ffffe097          	auipc	ra,0xffffe
    80005c52:	050080e7          	jalr	80(ra) # 80003c9e <iunlockput>
  end_op();
    80005c56:	fffff097          	auipc	ra,0xfffff
    80005c5a:	838080e7          	jalr	-1992(ra) # 8000448e <end_op>
  return 0;
    80005c5e:	4501                	li	a0,0
    80005c60:	a031                	j	80005c6c <sys_mknod+0x80>
    end_op();
    80005c62:	fffff097          	auipc	ra,0xfffff
    80005c66:	82c080e7          	jalr	-2004(ra) # 8000448e <end_op>
    return -1;
    80005c6a:	557d                	li	a0,-1
}
    80005c6c:	60ea                	ld	ra,152(sp)
    80005c6e:	644a                	ld	s0,144(sp)
    80005c70:	610d                	addi	sp,sp,160
    80005c72:	8082                	ret

0000000080005c74 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005c74:	7135                	addi	sp,sp,-160
    80005c76:	ed06                	sd	ra,152(sp)
    80005c78:	e922                	sd	s0,144(sp)
    80005c7a:	e526                	sd	s1,136(sp)
    80005c7c:	e14a                	sd	s2,128(sp)
    80005c7e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005c80:	ffffc097          	auipc	ra,0xffffc
    80005c84:	f74080e7          	jalr	-140(ra) # 80001bf4 <myproc>
    80005c88:	892a                	mv	s2,a0
  
  begin_op();
    80005c8a:	ffffe097          	auipc	ra,0xffffe
    80005c8e:	784080e7          	jalr	1924(ra) # 8000440e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005c92:	08000613          	li	a2,128
    80005c96:	f6040593          	addi	a1,s0,-160
    80005c9a:	4501                	li	a0,0
    80005c9c:	ffffd097          	auipc	ra,0xffffd
    80005ca0:	1fc080e7          	jalr	508(ra) # 80002e98 <argstr>
    80005ca4:	04054b63          	bltz	a0,80005cfa <sys_chdir+0x86>
    80005ca8:	f6040513          	addi	a0,s0,-160
    80005cac:	ffffe097          	auipc	ra,0xffffe
    80005cb0:	546080e7          	jalr	1350(ra) # 800041f2 <namei>
    80005cb4:	84aa                	mv	s1,a0
    80005cb6:	c131                	beqz	a0,80005cfa <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005cb8:	ffffe097          	auipc	ra,0xffffe
    80005cbc:	d84080e7          	jalr	-636(ra) # 80003a3c <ilock>
  if(ip->type != T_DIR){
    80005cc0:	04449703          	lh	a4,68(s1)
    80005cc4:	4785                	li	a5,1
    80005cc6:	04f71063          	bne	a4,a5,80005d06 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005cca:	8526                	mv	a0,s1
    80005ccc:	ffffe097          	auipc	ra,0xffffe
    80005cd0:	e32080e7          	jalr	-462(ra) # 80003afe <iunlock>
  iput(p->cwd);
    80005cd4:	16093503          	ld	a0,352(s2)
    80005cd8:	ffffe097          	auipc	ra,0xffffe
    80005cdc:	f1e080e7          	jalr	-226(ra) # 80003bf6 <iput>
  end_op();
    80005ce0:	ffffe097          	auipc	ra,0xffffe
    80005ce4:	7ae080e7          	jalr	1966(ra) # 8000448e <end_op>
  p->cwd = ip;
    80005ce8:	16993023          	sd	s1,352(s2)
  return 0;
    80005cec:	4501                	li	a0,0
}
    80005cee:	60ea                	ld	ra,152(sp)
    80005cf0:	644a                	ld	s0,144(sp)
    80005cf2:	64aa                	ld	s1,136(sp)
    80005cf4:	690a                	ld	s2,128(sp)
    80005cf6:	610d                	addi	sp,sp,160
    80005cf8:	8082                	ret
    end_op();
    80005cfa:	ffffe097          	auipc	ra,0xffffe
    80005cfe:	794080e7          	jalr	1940(ra) # 8000448e <end_op>
    return -1;
    80005d02:	557d                	li	a0,-1
    80005d04:	b7ed                	j	80005cee <sys_chdir+0x7a>
    iunlockput(ip);
    80005d06:	8526                	mv	a0,s1
    80005d08:	ffffe097          	auipc	ra,0xffffe
    80005d0c:	f96080e7          	jalr	-106(ra) # 80003c9e <iunlockput>
    end_op();
    80005d10:	ffffe097          	auipc	ra,0xffffe
    80005d14:	77e080e7          	jalr	1918(ra) # 8000448e <end_op>
    return -1;
    80005d18:	557d                	li	a0,-1
    80005d1a:	bfd1                	j	80005cee <sys_chdir+0x7a>

0000000080005d1c <sys_exec>:

uint64
sys_exec(void)
{
    80005d1c:	7145                	addi	sp,sp,-464
    80005d1e:	e786                	sd	ra,456(sp)
    80005d20:	e3a2                	sd	s0,448(sp)
    80005d22:	ff26                	sd	s1,440(sp)
    80005d24:	fb4a                	sd	s2,432(sp)
    80005d26:	f74e                	sd	s3,424(sp)
    80005d28:	f352                	sd	s4,416(sp)
    80005d2a:	ef56                	sd	s5,408(sp)
    80005d2c:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005d2e:	08000613          	li	a2,128
    80005d32:	f4040593          	addi	a1,s0,-192
    80005d36:	4501                	li	a0,0
    80005d38:	ffffd097          	auipc	ra,0xffffd
    80005d3c:	160080e7          	jalr	352(ra) # 80002e98 <argstr>
    return -1;
    80005d40:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005d42:	0c054a63          	bltz	a0,80005e16 <sys_exec+0xfa>
    80005d46:	e3840593          	addi	a1,s0,-456
    80005d4a:	4505                	li	a0,1
    80005d4c:	ffffd097          	auipc	ra,0xffffd
    80005d50:	12a080e7          	jalr	298(ra) # 80002e76 <argaddr>
    80005d54:	0c054163          	bltz	a0,80005e16 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005d58:	10000613          	li	a2,256
    80005d5c:	4581                	li	a1,0
    80005d5e:	e4040513          	addi	a0,s0,-448
    80005d62:	ffffb097          	auipc	ra,0xffffb
    80005d66:	f5c080e7          	jalr	-164(ra) # 80000cbe <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005d6a:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005d6e:	89a6                	mv	s3,s1
    80005d70:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005d72:	02000a13          	li	s4,32
    80005d76:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005d7a:	00391793          	slli	a5,s2,0x3
    80005d7e:	e3040593          	addi	a1,s0,-464
    80005d82:	e3843503          	ld	a0,-456(s0)
    80005d86:	953e                	add	a0,a0,a5
    80005d88:	ffffd097          	auipc	ra,0xffffd
    80005d8c:	032080e7          	jalr	50(ra) # 80002dba <fetchaddr>
    80005d90:	02054a63          	bltz	a0,80005dc4 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005d94:	e3043783          	ld	a5,-464(s0)
    80005d98:	c3b9                	beqz	a5,80005dde <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005d9a:	ffffb097          	auipc	ra,0xffffb
    80005d9e:	d38080e7          	jalr	-712(ra) # 80000ad2 <kalloc>
    80005da2:	85aa                	mv	a1,a0
    80005da4:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005da8:	cd11                	beqz	a0,80005dc4 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005daa:	6605                	lui	a2,0x1
    80005dac:	e3043503          	ld	a0,-464(s0)
    80005db0:	ffffd097          	auipc	ra,0xffffd
    80005db4:	05c080e7          	jalr	92(ra) # 80002e0c <fetchstr>
    80005db8:	00054663          	bltz	a0,80005dc4 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005dbc:	0905                	addi	s2,s2,1
    80005dbe:	09a1                	addi	s3,s3,8
    80005dc0:	fb491be3          	bne	s2,s4,80005d76 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005dc4:	10048913          	addi	s2,s1,256
    80005dc8:	6088                	ld	a0,0(s1)
    80005dca:	c529                	beqz	a0,80005e14 <sys_exec+0xf8>
    kfree(argv[i]);
    80005dcc:	ffffb097          	auipc	ra,0xffffb
    80005dd0:	c0a080e7          	jalr	-1014(ra) # 800009d6 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005dd4:	04a1                	addi	s1,s1,8
    80005dd6:	ff2499e3          	bne	s1,s2,80005dc8 <sys_exec+0xac>
  return -1;
    80005dda:	597d                	li	s2,-1
    80005ddc:	a82d                	j	80005e16 <sys_exec+0xfa>
      argv[i] = 0;
    80005dde:	0a8e                	slli	s5,s5,0x3
    80005de0:	fc040793          	addi	a5,s0,-64
    80005de4:	9abe                	add	s5,s5,a5
    80005de6:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffd8e80>
  int ret = exec(path, argv);
    80005dea:	e4040593          	addi	a1,s0,-448
    80005dee:	f4040513          	addi	a0,s0,-192
    80005df2:	fffff097          	auipc	ra,0xfffff
    80005df6:	13a080e7          	jalr	314(ra) # 80004f2c <exec>
    80005dfa:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005dfc:	10048993          	addi	s3,s1,256
    80005e00:	6088                	ld	a0,0(s1)
    80005e02:	c911                	beqz	a0,80005e16 <sys_exec+0xfa>
    kfree(argv[i]);
    80005e04:	ffffb097          	auipc	ra,0xffffb
    80005e08:	bd2080e7          	jalr	-1070(ra) # 800009d6 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005e0c:	04a1                	addi	s1,s1,8
    80005e0e:	ff3499e3          	bne	s1,s3,80005e00 <sys_exec+0xe4>
    80005e12:	a011                	j	80005e16 <sys_exec+0xfa>
  return -1;
    80005e14:	597d                	li	s2,-1
}
    80005e16:	854a                	mv	a0,s2
    80005e18:	60be                	ld	ra,456(sp)
    80005e1a:	641e                	ld	s0,448(sp)
    80005e1c:	74fa                	ld	s1,440(sp)
    80005e1e:	795a                	ld	s2,432(sp)
    80005e20:	79ba                	ld	s3,424(sp)
    80005e22:	7a1a                	ld	s4,416(sp)
    80005e24:	6afa                	ld	s5,408(sp)
    80005e26:	6179                	addi	sp,sp,464
    80005e28:	8082                	ret

0000000080005e2a <sys_pipe>:

uint64
sys_pipe(void)
{
    80005e2a:	7139                	addi	sp,sp,-64
    80005e2c:	fc06                	sd	ra,56(sp)
    80005e2e:	f822                	sd	s0,48(sp)
    80005e30:	f426                	sd	s1,40(sp)
    80005e32:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005e34:	ffffc097          	auipc	ra,0xffffc
    80005e38:	dc0080e7          	jalr	-576(ra) # 80001bf4 <myproc>
    80005e3c:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005e3e:	fd840593          	addi	a1,s0,-40
    80005e42:	4501                	li	a0,0
    80005e44:	ffffd097          	auipc	ra,0xffffd
    80005e48:	032080e7          	jalr	50(ra) # 80002e76 <argaddr>
    return -1;
    80005e4c:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005e4e:	0e054063          	bltz	a0,80005f2e <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005e52:	fc840593          	addi	a1,s0,-56
    80005e56:	fd040513          	addi	a0,s0,-48
    80005e5a:	fffff097          	auipc	ra,0xfffff
    80005e5e:	db0080e7          	jalr	-592(ra) # 80004c0a <pipealloc>
    return -1;
    80005e62:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005e64:	0c054563          	bltz	a0,80005f2e <sys_pipe+0x104>
  fd0 = -1;
    80005e68:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005e6c:	fd043503          	ld	a0,-48(s0)
    80005e70:	fffff097          	auipc	ra,0xfffff
    80005e74:	50a080e7          	jalr	1290(ra) # 8000537a <fdalloc>
    80005e78:	fca42223          	sw	a0,-60(s0)
    80005e7c:	08054c63          	bltz	a0,80005f14 <sys_pipe+0xea>
    80005e80:	fc843503          	ld	a0,-56(s0)
    80005e84:	fffff097          	auipc	ra,0xfffff
    80005e88:	4f6080e7          	jalr	1270(ra) # 8000537a <fdalloc>
    80005e8c:	fca42023          	sw	a0,-64(s0)
    80005e90:	06054863          	bltz	a0,80005f00 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005e94:	4691                	li	a3,4
    80005e96:	fc440613          	addi	a2,s0,-60
    80005e9a:	fd843583          	ld	a1,-40(s0)
    80005e9e:	6ca8                	ld	a0,88(s1)
    80005ea0:	ffffc097          	auipc	ra,0xffffc
    80005ea4:	944080e7          	jalr	-1724(ra) # 800017e4 <copyout>
    80005ea8:	02054063          	bltz	a0,80005ec8 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005eac:	4691                	li	a3,4
    80005eae:	fc040613          	addi	a2,s0,-64
    80005eb2:	fd843583          	ld	a1,-40(s0)
    80005eb6:	0591                	addi	a1,a1,4
    80005eb8:	6ca8                	ld	a0,88(s1)
    80005eba:	ffffc097          	auipc	ra,0xffffc
    80005ebe:	92a080e7          	jalr	-1750(ra) # 800017e4 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005ec2:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005ec4:	06055563          	bgez	a0,80005f2e <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005ec8:	fc442783          	lw	a5,-60(s0)
    80005ecc:	07f1                	addi	a5,a5,28
    80005ece:	078e                	slli	a5,a5,0x3
    80005ed0:	97a6                	add	a5,a5,s1
    80005ed2:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005ed6:	fc042503          	lw	a0,-64(s0)
    80005eda:	0571                	addi	a0,a0,28
    80005edc:	050e                	slli	a0,a0,0x3
    80005ede:	9526                	add	a0,a0,s1
    80005ee0:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005ee4:	fd043503          	ld	a0,-48(s0)
    80005ee8:	fffff097          	auipc	ra,0xfffff
    80005eec:	9f2080e7          	jalr	-1550(ra) # 800048da <fileclose>
    fileclose(wf);
    80005ef0:	fc843503          	ld	a0,-56(s0)
    80005ef4:	fffff097          	auipc	ra,0xfffff
    80005ef8:	9e6080e7          	jalr	-1562(ra) # 800048da <fileclose>
    return -1;
    80005efc:	57fd                	li	a5,-1
    80005efe:	a805                	j	80005f2e <sys_pipe+0x104>
    if(fd0 >= 0)
    80005f00:	fc442783          	lw	a5,-60(s0)
    80005f04:	0007c863          	bltz	a5,80005f14 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005f08:	01c78513          	addi	a0,a5,28
    80005f0c:	050e                	slli	a0,a0,0x3
    80005f0e:	9526                	add	a0,a0,s1
    80005f10:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005f14:	fd043503          	ld	a0,-48(s0)
    80005f18:	fffff097          	auipc	ra,0xfffff
    80005f1c:	9c2080e7          	jalr	-1598(ra) # 800048da <fileclose>
    fileclose(wf);
    80005f20:	fc843503          	ld	a0,-56(s0)
    80005f24:	fffff097          	auipc	ra,0xfffff
    80005f28:	9b6080e7          	jalr	-1610(ra) # 800048da <fileclose>
    return -1;
    80005f2c:	57fd                	li	a5,-1
}
    80005f2e:	853e                	mv	a0,a5
    80005f30:	70e2                	ld	ra,56(sp)
    80005f32:	7442                	ld	s0,48(sp)
    80005f34:	74a2                	ld	s1,40(sp)
    80005f36:	6121                	addi	sp,sp,64
    80005f38:	8082                	ret
    80005f3a:	0000                	unimp
    80005f3c:	0000                	unimp
	...

0000000080005f40 <kernelvec>:
    80005f40:	7111                	addi	sp,sp,-256
    80005f42:	e006                	sd	ra,0(sp)
    80005f44:	e40a                	sd	sp,8(sp)
    80005f46:	e80e                	sd	gp,16(sp)
    80005f48:	ec12                	sd	tp,24(sp)
    80005f4a:	f016                	sd	t0,32(sp)
    80005f4c:	f41a                	sd	t1,40(sp)
    80005f4e:	f81e                	sd	t2,48(sp)
    80005f50:	fc22                	sd	s0,56(sp)
    80005f52:	e0a6                	sd	s1,64(sp)
    80005f54:	e4aa                	sd	a0,72(sp)
    80005f56:	e8ae                	sd	a1,80(sp)
    80005f58:	ecb2                	sd	a2,88(sp)
    80005f5a:	f0b6                	sd	a3,96(sp)
    80005f5c:	f4ba                	sd	a4,104(sp)
    80005f5e:	f8be                	sd	a5,112(sp)
    80005f60:	fcc2                	sd	a6,120(sp)
    80005f62:	e146                	sd	a7,128(sp)
    80005f64:	e54a                	sd	s2,136(sp)
    80005f66:	e94e                	sd	s3,144(sp)
    80005f68:	ed52                	sd	s4,152(sp)
    80005f6a:	f156                	sd	s5,160(sp)
    80005f6c:	f55a                	sd	s6,168(sp)
    80005f6e:	f95e                	sd	s7,176(sp)
    80005f70:	fd62                	sd	s8,184(sp)
    80005f72:	e1e6                	sd	s9,192(sp)
    80005f74:	e5ea                	sd	s10,200(sp)
    80005f76:	e9ee                	sd	s11,208(sp)
    80005f78:	edf2                	sd	t3,216(sp)
    80005f7a:	f1f6                	sd	t4,224(sp)
    80005f7c:	f5fa                	sd	t5,232(sp)
    80005f7e:	f9fe                	sd	t6,240(sp)
    80005f80:	d07fc0ef          	jal	ra,80002c86 <kerneltrap>
    80005f84:	6082                	ld	ra,0(sp)
    80005f86:	6122                	ld	sp,8(sp)
    80005f88:	61c2                	ld	gp,16(sp)
    80005f8a:	7282                	ld	t0,32(sp)
    80005f8c:	7322                	ld	t1,40(sp)
    80005f8e:	73c2                	ld	t2,48(sp)
    80005f90:	7462                	ld	s0,56(sp)
    80005f92:	6486                	ld	s1,64(sp)
    80005f94:	6526                	ld	a0,72(sp)
    80005f96:	65c6                	ld	a1,80(sp)
    80005f98:	6666                	ld	a2,88(sp)
    80005f9a:	7686                	ld	a3,96(sp)
    80005f9c:	7726                	ld	a4,104(sp)
    80005f9e:	77c6                	ld	a5,112(sp)
    80005fa0:	7866                	ld	a6,120(sp)
    80005fa2:	688a                	ld	a7,128(sp)
    80005fa4:	692a                	ld	s2,136(sp)
    80005fa6:	69ca                	ld	s3,144(sp)
    80005fa8:	6a6a                	ld	s4,152(sp)
    80005faa:	7a8a                	ld	s5,160(sp)
    80005fac:	7b2a                	ld	s6,168(sp)
    80005fae:	7bca                	ld	s7,176(sp)
    80005fb0:	7c6a                	ld	s8,184(sp)
    80005fb2:	6c8e                	ld	s9,192(sp)
    80005fb4:	6d2e                	ld	s10,200(sp)
    80005fb6:	6dce                	ld	s11,208(sp)
    80005fb8:	6e6e                	ld	t3,216(sp)
    80005fba:	7e8e                	ld	t4,224(sp)
    80005fbc:	7f2e                	ld	t5,232(sp)
    80005fbe:	7fce                	ld	t6,240(sp)
    80005fc0:	6111                	addi	sp,sp,256
    80005fc2:	10200073          	sret
    80005fc6:	00000013          	nop
    80005fca:	00000013          	nop
    80005fce:	0001                	nop

0000000080005fd0 <timervec>:
    80005fd0:	34051573          	csrrw	a0,mscratch,a0
    80005fd4:	e10c                	sd	a1,0(a0)
    80005fd6:	e510                	sd	a2,8(a0)
    80005fd8:	e914                	sd	a3,16(a0)
    80005fda:	6d0c                	ld	a1,24(a0)
    80005fdc:	7110                	ld	a2,32(a0)
    80005fde:	6194                	ld	a3,0(a1)
    80005fe0:	96b2                	add	a3,a3,a2
    80005fe2:	e194                	sd	a3,0(a1)
    80005fe4:	4589                	li	a1,2
    80005fe6:	14459073          	csrw	sip,a1
    80005fea:	6914                	ld	a3,16(a0)
    80005fec:	6510                	ld	a2,8(a0)
    80005fee:	610c                	ld	a1,0(a0)
    80005ff0:	34051573          	csrrw	a0,mscratch,a0
    80005ff4:	30200073          	mret
	...

0000000080005ffa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005ffa:	1141                	addi	sp,sp,-16
    80005ffc:	e422                	sd	s0,8(sp)
    80005ffe:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006000:	0c0007b7          	lui	a5,0xc000
    80006004:	4705                	li	a4,1
    80006006:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006008:	c3d8                	sw	a4,4(a5)
}
    8000600a:	6422                	ld	s0,8(sp)
    8000600c:	0141                	addi	sp,sp,16
    8000600e:	8082                	ret

0000000080006010 <plicinithart>:

void
plicinithart(void)
{
    80006010:	1141                	addi	sp,sp,-16
    80006012:	e406                	sd	ra,8(sp)
    80006014:	e022                	sd	s0,0(sp)
    80006016:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006018:	ffffc097          	auipc	ra,0xffffc
    8000601c:	bb0080e7          	jalr	-1104(ra) # 80001bc8 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006020:	0085171b          	slliw	a4,a0,0x8
    80006024:	0c0027b7          	lui	a5,0xc002
    80006028:	97ba                	add	a5,a5,a4
    8000602a:	40200713          	li	a4,1026
    8000602e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006032:	00d5151b          	slliw	a0,a0,0xd
    80006036:	0c2017b7          	lui	a5,0xc201
    8000603a:	953e                	add	a0,a0,a5
    8000603c:	00052023          	sw	zero,0(a0)
}
    80006040:	60a2                	ld	ra,8(sp)
    80006042:	6402                	ld	s0,0(sp)
    80006044:	0141                	addi	sp,sp,16
    80006046:	8082                	ret

0000000080006048 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80006048:	1141                	addi	sp,sp,-16
    8000604a:	e406                	sd	ra,8(sp)
    8000604c:	e022                	sd	s0,0(sp)
    8000604e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006050:	ffffc097          	auipc	ra,0xffffc
    80006054:	b78080e7          	jalr	-1160(ra) # 80001bc8 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80006058:	00d5179b          	slliw	a5,a0,0xd
    8000605c:	0c201537          	lui	a0,0xc201
    80006060:	953e                	add	a0,a0,a5
  return irq;
}
    80006062:	4148                	lw	a0,4(a0)
    80006064:	60a2                	ld	ra,8(sp)
    80006066:	6402                	ld	s0,0(sp)
    80006068:	0141                	addi	sp,sp,16
    8000606a:	8082                	ret

000000008000606c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000606c:	1101                	addi	sp,sp,-32
    8000606e:	ec06                	sd	ra,24(sp)
    80006070:	e822                	sd	s0,16(sp)
    80006072:	e426                	sd	s1,8(sp)
    80006074:	1000                	addi	s0,sp,32
    80006076:	84aa                	mv	s1,a0
  int hart = cpuid();
    80006078:	ffffc097          	auipc	ra,0xffffc
    8000607c:	b50080e7          	jalr	-1200(ra) # 80001bc8 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006080:	00d5151b          	slliw	a0,a0,0xd
    80006084:	0c2017b7          	lui	a5,0xc201
    80006088:	97aa                	add	a5,a5,a0
    8000608a:	c3c4                	sw	s1,4(a5)
}
    8000608c:	60e2                	ld	ra,24(sp)
    8000608e:	6442                	ld	s0,16(sp)
    80006090:	64a2                	ld	s1,8(sp)
    80006092:	6105                	addi	sp,sp,32
    80006094:	8082                	ret

0000000080006096 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80006096:	1141                	addi	sp,sp,-16
    80006098:	e406                	sd	ra,8(sp)
    8000609a:	e022                	sd	s0,0(sp)
    8000609c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000609e:	479d                	li	a5,7
    800060a0:	06a7c963          	blt	a5,a0,80006112 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800060a4:	0001d797          	auipc	a5,0x1d
    800060a8:	f5c78793          	addi	a5,a5,-164 # 80023000 <disk>
    800060ac:	00a78733          	add	a4,a5,a0
    800060b0:	6789                	lui	a5,0x2
    800060b2:	97ba                	add	a5,a5,a4
    800060b4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800060b8:	e7ad                	bnez	a5,80006122 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800060ba:	00451793          	slli	a5,a0,0x4
    800060be:	0001f717          	auipc	a4,0x1f
    800060c2:	f4270713          	addi	a4,a4,-190 # 80025000 <disk+0x2000>
    800060c6:	6314                	ld	a3,0(a4)
    800060c8:	96be                	add	a3,a3,a5
    800060ca:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800060ce:	6314                	ld	a3,0(a4)
    800060d0:	96be                	add	a3,a3,a5
    800060d2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800060d6:	6314                	ld	a3,0(a4)
    800060d8:	96be                	add	a3,a3,a5
    800060da:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800060de:	6318                	ld	a4,0(a4)
    800060e0:	97ba                	add	a5,a5,a4
    800060e2:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800060e6:	0001d797          	auipc	a5,0x1d
    800060ea:	f1a78793          	addi	a5,a5,-230 # 80023000 <disk>
    800060ee:	97aa                	add	a5,a5,a0
    800060f0:	6509                	lui	a0,0x2
    800060f2:	953e                	add	a0,a0,a5
    800060f4:	4785                	li	a5,1
    800060f6:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800060fa:	0001f517          	auipc	a0,0x1f
    800060fe:	f1e50513          	addi	a0,a0,-226 # 80025018 <disk+0x2018>
    80006102:	ffffc097          	auipc	ra,0xffffc
    80006106:	4ee080e7          	jalr	1262(ra) # 800025f0 <wakeup>
}
    8000610a:	60a2                	ld	ra,8(sp)
    8000610c:	6402                	ld	s0,0(sp)
    8000610e:	0141                	addi	sp,sp,16
    80006110:	8082                	ret
    panic("free_desc 1");
    80006112:	00002517          	auipc	a0,0x2
    80006116:	74e50513          	addi	a0,a0,1870 # 80008860 <syscalls+0x320>
    8000611a:	ffffa097          	auipc	ra,0xffffa
    8000611e:	410080e7          	jalr	1040(ra) # 8000052a <panic>
    panic("free_desc 2");
    80006122:	00002517          	auipc	a0,0x2
    80006126:	74e50513          	addi	a0,a0,1870 # 80008870 <syscalls+0x330>
    8000612a:	ffffa097          	auipc	ra,0xffffa
    8000612e:	400080e7          	jalr	1024(ra) # 8000052a <panic>

0000000080006132 <virtio_disk_init>:
{
    80006132:	1101                	addi	sp,sp,-32
    80006134:	ec06                	sd	ra,24(sp)
    80006136:	e822                	sd	s0,16(sp)
    80006138:	e426                	sd	s1,8(sp)
    8000613a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000613c:	00002597          	auipc	a1,0x2
    80006140:	74458593          	addi	a1,a1,1860 # 80008880 <syscalls+0x340>
    80006144:	0001f517          	auipc	a0,0x1f
    80006148:	fe450513          	addi	a0,a0,-28 # 80025128 <disk+0x2128>
    8000614c:	ffffb097          	auipc	ra,0xffffb
    80006150:	9e6080e7          	jalr	-1562(ra) # 80000b32 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006154:	100017b7          	lui	a5,0x10001
    80006158:	4398                	lw	a4,0(a5)
    8000615a:	2701                	sext.w	a4,a4
    8000615c:	747277b7          	lui	a5,0x74727
    80006160:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006164:	0ef71163          	bne	a4,a5,80006246 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80006168:	100017b7          	lui	a5,0x10001
    8000616c:	43dc                	lw	a5,4(a5)
    8000616e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006170:	4705                	li	a4,1
    80006172:	0ce79a63          	bne	a5,a4,80006246 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006176:	100017b7          	lui	a5,0x10001
    8000617a:	479c                	lw	a5,8(a5)
    8000617c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000617e:	4709                	li	a4,2
    80006180:	0ce79363          	bne	a5,a4,80006246 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80006184:	100017b7          	lui	a5,0x10001
    80006188:	47d8                	lw	a4,12(a5)
    8000618a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000618c:	554d47b7          	lui	a5,0x554d4
    80006190:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80006194:	0af71963          	bne	a4,a5,80006246 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006198:	100017b7          	lui	a5,0x10001
    8000619c:	4705                	li	a4,1
    8000619e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800061a0:	470d                	li	a4,3
    800061a2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800061a4:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800061a6:	c7ffe737          	lui	a4,0xc7ffe
    800061aa:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd875f>
    800061ae:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800061b0:	2701                	sext.w	a4,a4
    800061b2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800061b4:	472d                	li	a4,11
    800061b6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800061b8:	473d                	li	a4,15
    800061ba:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800061bc:	6705                	lui	a4,0x1
    800061be:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800061c0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800061c4:	5bdc                	lw	a5,52(a5)
    800061c6:	2781                	sext.w	a5,a5
  if(max == 0)
    800061c8:	c7d9                	beqz	a5,80006256 <virtio_disk_init+0x124>
  if(max < NUM)
    800061ca:	471d                	li	a4,7
    800061cc:	08f77d63          	bgeu	a4,a5,80006266 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800061d0:	100014b7          	lui	s1,0x10001
    800061d4:	47a1                	li	a5,8
    800061d6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800061d8:	6609                	lui	a2,0x2
    800061da:	4581                	li	a1,0
    800061dc:	0001d517          	auipc	a0,0x1d
    800061e0:	e2450513          	addi	a0,a0,-476 # 80023000 <disk>
    800061e4:	ffffb097          	auipc	ra,0xffffb
    800061e8:	ada080e7          	jalr	-1318(ra) # 80000cbe <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800061ec:	0001d717          	auipc	a4,0x1d
    800061f0:	e1470713          	addi	a4,a4,-492 # 80023000 <disk>
    800061f4:	00c75793          	srli	a5,a4,0xc
    800061f8:	2781                	sext.w	a5,a5
    800061fa:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800061fc:	0001f797          	auipc	a5,0x1f
    80006200:	e0478793          	addi	a5,a5,-508 # 80025000 <disk+0x2000>
    80006204:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80006206:	0001d717          	auipc	a4,0x1d
    8000620a:	e7a70713          	addi	a4,a4,-390 # 80023080 <disk+0x80>
    8000620e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80006210:	0001e717          	auipc	a4,0x1e
    80006214:	df070713          	addi	a4,a4,-528 # 80024000 <disk+0x1000>
    80006218:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000621a:	4705                	li	a4,1
    8000621c:	00e78c23          	sb	a4,24(a5)
    80006220:	00e78ca3          	sb	a4,25(a5)
    80006224:	00e78d23          	sb	a4,26(a5)
    80006228:	00e78da3          	sb	a4,27(a5)
    8000622c:	00e78e23          	sb	a4,28(a5)
    80006230:	00e78ea3          	sb	a4,29(a5)
    80006234:	00e78f23          	sb	a4,30(a5)
    80006238:	00e78fa3          	sb	a4,31(a5)
}
    8000623c:	60e2                	ld	ra,24(sp)
    8000623e:	6442                	ld	s0,16(sp)
    80006240:	64a2                	ld	s1,8(sp)
    80006242:	6105                	addi	sp,sp,32
    80006244:	8082                	ret
    panic("could not find virtio disk");
    80006246:	00002517          	auipc	a0,0x2
    8000624a:	64a50513          	addi	a0,a0,1610 # 80008890 <syscalls+0x350>
    8000624e:	ffffa097          	auipc	ra,0xffffa
    80006252:	2dc080e7          	jalr	732(ra) # 8000052a <panic>
    panic("virtio disk has no queue 0");
    80006256:	00002517          	auipc	a0,0x2
    8000625a:	65a50513          	addi	a0,a0,1626 # 800088b0 <syscalls+0x370>
    8000625e:	ffffa097          	auipc	ra,0xffffa
    80006262:	2cc080e7          	jalr	716(ra) # 8000052a <panic>
    panic("virtio disk max queue too short");
    80006266:	00002517          	auipc	a0,0x2
    8000626a:	66a50513          	addi	a0,a0,1642 # 800088d0 <syscalls+0x390>
    8000626e:	ffffa097          	auipc	ra,0xffffa
    80006272:	2bc080e7          	jalr	700(ra) # 8000052a <panic>

0000000080006276 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006276:	7119                	addi	sp,sp,-128
    80006278:	fc86                	sd	ra,120(sp)
    8000627a:	f8a2                	sd	s0,112(sp)
    8000627c:	f4a6                	sd	s1,104(sp)
    8000627e:	f0ca                	sd	s2,96(sp)
    80006280:	ecce                	sd	s3,88(sp)
    80006282:	e8d2                	sd	s4,80(sp)
    80006284:	e4d6                	sd	s5,72(sp)
    80006286:	e0da                	sd	s6,64(sp)
    80006288:	fc5e                	sd	s7,56(sp)
    8000628a:	f862                	sd	s8,48(sp)
    8000628c:	f466                	sd	s9,40(sp)
    8000628e:	f06a                	sd	s10,32(sp)
    80006290:	ec6e                	sd	s11,24(sp)
    80006292:	0100                	addi	s0,sp,128
    80006294:	8aaa                	mv	s5,a0
    80006296:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006298:	00c52c83          	lw	s9,12(a0)
    8000629c:	001c9c9b          	slliw	s9,s9,0x1
    800062a0:	1c82                	slli	s9,s9,0x20
    800062a2:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800062a6:	0001f517          	auipc	a0,0x1f
    800062aa:	e8250513          	addi	a0,a0,-382 # 80025128 <disk+0x2128>
    800062ae:	ffffb097          	auipc	ra,0xffffb
    800062b2:	914080e7          	jalr	-1772(ra) # 80000bc2 <acquire>
  for(int i = 0; i < 3; i++){
    800062b6:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800062b8:	44a1                	li	s1,8
      disk.free[i] = 0;
    800062ba:	0001dc17          	auipc	s8,0x1d
    800062be:	d46c0c13          	addi	s8,s8,-698 # 80023000 <disk>
    800062c2:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    800062c4:	4b0d                	li	s6,3
    800062c6:	a0ad                	j	80006330 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    800062c8:	00fc0733          	add	a4,s8,a5
    800062cc:	975e                	add	a4,a4,s7
    800062ce:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800062d2:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800062d4:	0207c563          	bltz	a5,800062fe <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800062d8:	2905                	addiw	s2,s2,1
    800062da:	0611                	addi	a2,a2,4
    800062dc:	19690d63          	beq	s2,s6,80006476 <virtio_disk_rw+0x200>
    idx[i] = alloc_desc();
    800062e0:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800062e2:	0001f717          	auipc	a4,0x1f
    800062e6:	d3670713          	addi	a4,a4,-714 # 80025018 <disk+0x2018>
    800062ea:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800062ec:	00074683          	lbu	a3,0(a4)
    800062f0:	fee1                	bnez	a3,800062c8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800062f2:	2785                	addiw	a5,a5,1
    800062f4:	0705                	addi	a4,a4,1
    800062f6:	fe979be3          	bne	a5,s1,800062ec <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800062fa:	57fd                	li	a5,-1
    800062fc:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800062fe:	01205d63          	blez	s2,80006318 <virtio_disk_rw+0xa2>
    80006302:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80006304:	000a2503          	lw	a0,0(s4)
    80006308:	00000097          	auipc	ra,0x0
    8000630c:	d8e080e7          	jalr	-626(ra) # 80006096 <free_desc>
      for(int j = 0; j < i; j++)
    80006310:	2d85                	addiw	s11,s11,1
    80006312:	0a11                	addi	s4,s4,4
    80006314:	ffb918e3          	bne	s2,s11,80006304 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006318:	0001f597          	auipc	a1,0x1f
    8000631c:	e1058593          	addi	a1,a1,-496 # 80025128 <disk+0x2128>
    80006320:	0001f517          	auipc	a0,0x1f
    80006324:	cf850513          	addi	a0,a0,-776 # 80025018 <disk+0x2018>
    80006328:	ffffc097          	auipc	ra,0xffffc
    8000632c:	13c080e7          	jalr	316(ra) # 80002464 <sleep>
  for(int i = 0; i < 3; i++){
    80006330:	f8040a13          	addi	s4,s0,-128
{
    80006334:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80006336:	894e                	mv	s2,s3
    80006338:	b765                	j	800062e0 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000633a:	0001f697          	auipc	a3,0x1f
    8000633e:	cc66b683          	ld	a3,-826(a3) # 80025000 <disk+0x2000>
    80006342:	96ba                	add	a3,a3,a4
    80006344:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006348:	0001d817          	auipc	a6,0x1d
    8000634c:	cb880813          	addi	a6,a6,-840 # 80023000 <disk>
    80006350:	0001f697          	auipc	a3,0x1f
    80006354:	cb068693          	addi	a3,a3,-848 # 80025000 <disk+0x2000>
    80006358:	6290                	ld	a2,0(a3)
    8000635a:	963a                	add	a2,a2,a4
    8000635c:	00c65583          	lhu	a1,12(a2) # 200c <_entry-0x7fffdff4>
    80006360:	0015e593          	ori	a1,a1,1
    80006364:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80006368:	f8842603          	lw	a2,-120(s0)
    8000636c:	628c                	ld	a1,0(a3)
    8000636e:	972e                	add	a4,a4,a1
    80006370:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006374:	20050593          	addi	a1,a0,512
    80006378:	0592                	slli	a1,a1,0x4
    8000637a:	95c2                	add	a1,a1,a6
    8000637c:	577d                	li	a4,-1
    8000637e:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006382:	00461713          	slli	a4,a2,0x4
    80006386:	6290                	ld	a2,0(a3)
    80006388:	963a                	add	a2,a2,a4
    8000638a:	03078793          	addi	a5,a5,48
    8000638e:	97c2                	add	a5,a5,a6
    80006390:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    80006392:	629c                	ld	a5,0(a3)
    80006394:	97ba                	add	a5,a5,a4
    80006396:	4605                	li	a2,1
    80006398:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000639a:	629c                	ld	a5,0(a3)
    8000639c:	97ba                	add	a5,a5,a4
    8000639e:	4809                	li	a6,2
    800063a0:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800063a4:	629c                	ld	a5,0(a3)
    800063a6:	973e                	add	a4,a4,a5
    800063a8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800063ac:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    800063b0:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800063b4:	6698                	ld	a4,8(a3)
    800063b6:	00275783          	lhu	a5,2(a4)
    800063ba:	8b9d                	andi	a5,a5,7
    800063bc:	0786                	slli	a5,a5,0x1
    800063be:	97ba                	add	a5,a5,a4
    800063c0:	00a79223          	sh	a0,4(a5)

  __sync_synchronize();
    800063c4:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800063c8:	6698                	ld	a4,8(a3)
    800063ca:	00275783          	lhu	a5,2(a4)
    800063ce:	2785                	addiw	a5,a5,1
    800063d0:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800063d4:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800063d8:	100017b7          	lui	a5,0x10001
    800063dc:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800063e0:	004aa783          	lw	a5,4(s5)
    800063e4:	02c79163          	bne	a5,a2,80006406 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    800063e8:	0001f917          	auipc	s2,0x1f
    800063ec:	d4090913          	addi	s2,s2,-704 # 80025128 <disk+0x2128>
  while(b->disk == 1) {
    800063f0:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800063f2:	85ca                	mv	a1,s2
    800063f4:	8556                	mv	a0,s5
    800063f6:	ffffc097          	auipc	ra,0xffffc
    800063fa:	06e080e7          	jalr	110(ra) # 80002464 <sleep>
  while(b->disk == 1) {
    800063fe:	004aa783          	lw	a5,4(s5)
    80006402:	fe9788e3          	beq	a5,s1,800063f2 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80006406:	f8042903          	lw	s2,-128(s0)
    8000640a:	20090793          	addi	a5,s2,512
    8000640e:	00479713          	slli	a4,a5,0x4
    80006412:	0001d797          	auipc	a5,0x1d
    80006416:	bee78793          	addi	a5,a5,-1042 # 80023000 <disk>
    8000641a:	97ba                	add	a5,a5,a4
    8000641c:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80006420:	0001f997          	auipc	s3,0x1f
    80006424:	be098993          	addi	s3,s3,-1056 # 80025000 <disk+0x2000>
    80006428:	00491713          	slli	a4,s2,0x4
    8000642c:	0009b783          	ld	a5,0(s3)
    80006430:	97ba                	add	a5,a5,a4
    80006432:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006436:	854a                	mv	a0,s2
    80006438:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000643c:	00000097          	auipc	ra,0x0
    80006440:	c5a080e7          	jalr	-934(ra) # 80006096 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006444:	8885                	andi	s1,s1,1
    80006446:	f0ed                	bnez	s1,80006428 <virtio_disk_rw+0x1b2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006448:	0001f517          	auipc	a0,0x1f
    8000644c:	ce050513          	addi	a0,a0,-800 # 80025128 <disk+0x2128>
    80006450:	ffffb097          	auipc	ra,0xffffb
    80006454:	826080e7          	jalr	-2010(ra) # 80000c76 <release>
}
    80006458:	70e6                	ld	ra,120(sp)
    8000645a:	7446                	ld	s0,112(sp)
    8000645c:	74a6                	ld	s1,104(sp)
    8000645e:	7906                	ld	s2,96(sp)
    80006460:	69e6                	ld	s3,88(sp)
    80006462:	6a46                	ld	s4,80(sp)
    80006464:	6aa6                	ld	s5,72(sp)
    80006466:	6b06                	ld	s6,64(sp)
    80006468:	7be2                	ld	s7,56(sp)
    8000646a:	7c42                	ld	s8,48(sp)
    8000646c:	7ca2                	ld	s9,40(sp)
    8000646e:	7d02                	ld	s10,32(sp)
    80006470:	6de2                	ld	s11,24(sp)
    80006472:	6109                	addi	sp,sp,128
    80006474:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006476:	f8042503          	lw	a0,-128(s0)
    8000647a:	20050793          	addi	a5,a0,512
    8000647e:	0792                	slli	a5,a5,0x4
  if(write)
    80006480:	0001d817          	auipc	a6,0x1d
    80006484:	b8080813          	addi	a6,a6,-1152 # 80023000 <disk>
    80006488:	00f80733          	add	a4,a6,a5
    8000648c:	01a036b3          	snez	a3,s10
    80006490:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    80006494:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80006498:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000649c:	7679                	lui	a2,0xffffe
    8000649e:	963e                	add	a2,a2,a5
    800064a0:	0001f697          	auipc	a3,0x1f
    800064a4:	b6068693          	addi	a3,a3,-1184 # 80025000 <disk+0x2000>
    800064a8:	6298                	ld	a4,0(a3)
    800064aa:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800064ac:	0a878593          	addi	a1,a5,168
    800064b0:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    800064b2:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800064b4:	6298                	ld	a4,0(a3)
    800064b6:	9732                	add	a4,a4,a2
    800064b8:	45c1                	li	a1,16
    800064ba:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800064bc:	6298                	ld	a4,0(a3)
    800064be:	9732                	add	a4,a4,a2
    800064c0:	4585                	li	a1,1
    800064c2:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800064c6:	f8442703          	lw	a4,-124(s0)
    800064ca:	628c                	ld	a1,0(a3)
    800064cc:	962e                	add	a2,a2,a1
    800064ce:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd800e>
  disk.desc[idx[1]].addr = (uint64) b->data;
    800064d2:	0712                	slli	a4,a4,0x4
    800064d4:	6290                	ld	a2,0(a3)
    800064d6:	963a                	add	a2,a2,a4
    800064d8:	058a8593          	addi	a1,s5,88
    800064dc:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800064de:	6294                	ld	a3,0(a3)
    800064e0:	96ba                	add	a3,a3,a4
    800064e2:	40000613          	li	a2,1024
    800064e6:	c690                	sw	a2,8(a3)
  if(write)
    800064e8:	e40d19e3          	bnez	s10,8000633a <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800064ec:	0001f697          	auipc	a3,0x1f
    800064f0:	b146b683          	ld	a3,-1260(a3) # 80025000 <disk+0x2000>
    800064f4:	96ba                	add	a3,a3,a4
    800064f6:	4609                	li	a2,2
    800064f8:	00c69623          	sh	a2,12(a3)
    800064fc:	b5b1                	j	80006348 <virtio_disk_rw+0xd2>

00000000800064fe <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800064fe:	1101                	addi	sp,sp,-32
    80006500:	ec06                	sd	ra,24(sp)
    80006502:	e822                	sd	s0,16(sp)
    80006504:	e426                	sd	s1,8(sp)
    80006506:	e04a                	sd	s2,0(sp)
    80006508:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000650a:	0001f517          	auipc	a0,0x1f
    8000650e:	c1e50513          	addi	a0,a0,-994 # 80025128 <disk+0x2128>
    80006512:	ffffa097          	auipc	ra,0xffffa
    80006516:	6b0080e7          	jalr	1712(ra) # 80000bc2 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000651a:	10001737          	lui	a4,0x10001
    8000651e:	533c                	lw	a5,96(a4)
    80006520:	8b8d                	andi	a5,a5,3
    80006522:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80006524:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006528:	0001f797          	auipc	a5,0x1f
    8000652c:	ad878793          	addi	a5,a5,-1320 # 80025000 <disk+0x2000>
    80006530:	6b94                	ld	a3,16(a5)
    80006532:	0207d703          	lhu	a4,32(a5)
    80006536:	0026d783          	lhu	a5,2(a3)
    8000653a:	06f70163          	beq	a4,a5,8000659c <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000653e:	0001d917          	auipc	s2,0x1d
    80006542:	ac290913          	addi	s2,s2,-1342 # 80023000 <disk>
    80006546:	0001f497          	auipc	s1,0x1f
    8000654a:	aba48493          	addi	s1,s1,-1350 # 80025000 <disk+0x2000>
    __sync_synchronize();
    8000654e:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006552:	6898                	ld	a4,16(s1)
    80006554:	0204d783          	lhu	a5,32(s1)
    80006558:	8b9d                	andi	a5,a5,7
    8000655a:	078e                	slli	a5,a5,0x3
    8000655c:	97ba                	add	a5,a5,a4
    8000655e:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006560:	20078713          	addi	a4,a5,512
    80006564:	0712                	slli	a4,a4,0x4
    80006566:	974a                	add	a4,a4,s2
    80006568:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000656c:	e731                	bnez	a4,800065b8 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000656e:	20078793          	addi	a5,a5,512
    80006572:	0792                	slli	a5,a5,0x4
    80006574:	97ca                	add	a5,a5,s2
    80006576:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80006578:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000657c:	ffffc097          	auipc	ra,0xffffc
    80006580:	074080e7          	jalr	116(ra) # 800025f0 <wakeup>

    disk.used_idx += 1;
    80006584:	0204d783          	lhu	a5,32(s1)
    80006588:	2785                	addiw	a5,a5,1
    8000658a:	17c2                	slli	a5,a5,0x30
    8000658c:	93c1                	srli	a5,a5,0x30
    8000658e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006592:	6898                	ld	a4,16(s1)
    80006594:	00275703          	lhu	a4,2(a4)
    80006598:	faf71be3          	bne	a4,a5,8000654e <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000659c:	0001f517          	auipc	a0,0x1f
    800065a0:	b8c50513          	addi	a0,a0,-1140 # 80025128 <disk+0x2128>
    800065a4:	ffffa097          	auipc	ra,0xffffa
    800065a8:	6d2080e7          	jalr	1746(ra) # 80000c76 <release>
}
    800065ac:	60e2                	ld	ra,24(sp)
    800065ae:	6442                	ld	s0,16(sp)
    800065b0:	64a2                	ld	s1,8(sp)
    800065b2:	6902                	ld	s2,0(sp)
    800065b4:	6105                	addi	sp,sp,32
    800065b6:	8082                	ret
      panic("virtio_disk_intr status");
    800065b8:	00002517          	auipc	a0,0x2
    800065bc:	33850513          	addi	a0,a0,824 # 800088f0 <syscalls+0x3b0>
    800065c0:	ffffa097          	auipc	ra,0xffffa
    800065c4:	f6a080e7          	jalr	-150(ra) # 8000052a <panic>
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
