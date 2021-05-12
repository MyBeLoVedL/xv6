
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

#include "types.h"
// which hart (core) is this?
static inline uint64 r_mhartid() {
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r"(x));
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
static inline void w_sscratch(uint64 x) {
  asm volatile("csrw sscratch, %0" : : "r"(x));
}

static inline void w_mscratch(uint64 x) {
  asm volatile("csrw mscratch, %0" : : "r"(x));
    80000060:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r"(x));
    80000064:	00006797          	auipc	a5,0x6
    80000068:	fec78793          	addi	a5,a5,-20 # 80006050 <timervec>
    8000006c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r"(x));
    80000070:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000074:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r"(x));
    80000078:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r"(x));
    8000007c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000080:	0807e793          	ori	a5,a5,128
static inline void w_mie(uint64 x) { asm volatile("csrw mie, %0" : : "r"(x)); }
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
  asm volatile("csrr %0, mstatus" : "=r"(x));
    80000096:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000009a:	7779                	lui	a4,0xffffe
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd87ff>
    800000a0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a2:	6705                	lui	a4,0x1
    800000a4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r"(x));
    800000aa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r"(x));
    800000ae:	00001797          	auipc	a5,0x1
    800000b2:	e3678793          	addi	a5,a5,-458 # 80000ee4 <main>
    800000b6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r"(x));
    800000ba:	4781                	li	a5,0
    800000bc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r"(x));
    800000c0:	67c1                	lui	a5,0x10
    800000c2:	17fd                	addi	a5,a5,-1
    800000c4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r"(x));
    800000c8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r"(x));
    800000cc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000d0:	2227e793          	ori	a5,a5,546
static inline void w_sie(uint64 x) { asm volatile("csrw sie, %0" : : "r"(x)); }
    800000d4:	10479073          	csrw	sie,a5
  timerinit();
    800000d8:	00000097          	auipc	ra,0x0
    800000dc:	f44080e7          	jalr	-188(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r"(x));
    800000e0:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000e4:	2781                	sext.w	a5,a5
  uint64 x;
  asm volatile("mv %0, tp" : "=r"(x));
  return x;
}

static inline void w_tp(uint64 x) { asm volatile("mv tp, %0" : : "r"(x)); }
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
    80000122:	7b8080e7          	jalr	1976(ra) # 800028d6 <either_copyin>
    80000126:	01550c63          	beq	a0,s5,8000013e <consolewrite+0x4a>
      break;
    uartputc(c);
    8000012a:	fbf44503          	lbu	a0,-65(s0)
    8000012e:	00000097          	auipc	ra,0x0
    80000132:	7f2080e7          	jalr	2034(ra) # 80000920 <uartputc>
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
    80000188:	ab6080e7          	jalr	-1354(ra) # 80000c3a <acquire>
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
    800001b6:	aba080e7          	jalr	-1350(ra) # 80001c6c <myproc>
    800001ba:	551c                	lw	a5,40(a0)
    800001bc:	e7b5                	bnez	a5,80000228 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    800001be:	85a6                	mv	a1,s1
    800001c0:	854a                	mv	a0,s2
    800001c2:	00002097          	auipc	ra,0x2
    800001c6:	31a080e7          	jalr	794(ra) # 800024dc <sleep>
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
    80000202:	682080e7          	jalr	1666(ra) # 80002880 <either_copyout>
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
    8000021e:	ad4080e7          	jalr	-1324(ra) # 80000cee <release>

  return target - n;
    80000222:	413b053b          	subw	a0,s6,s3
    80000226:	a811                	j	8000023a <consoleread+0xe4>
        release(&cons.lock);
    80000228:	00011517          	auipc	a0,0x11
    8000022c:	f5850513          	addi	a0,a0,-168 # 80011180 <cons>
    80000230:	00001097          	auipc	ra,0x1
    80000234:	abe080e7          	jalr	-1346(ra) # 80000cee <release>
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
    8000027c:	5d6080e7          	jalr	1494(ra) # 8000084e <uartputc_sync>
}
    80000280:	60a2                	ld	ra,8(sp)
    80000282:	6402                	ld	s0,0(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000288:	4521                	li	a0,8
    8000028a:	00000097          	auipc	ra,0x0
    8000028e:	5c4080e7          	jalr	1476(ra) # 8000084e <uartputc_sync>
    80000292:	02000513          	li	a0,32
    80000296:	00000097          	auipc	ra,0x0
    8000029a:	5b8080e7          	jalr	1464(ra) # 8000084e <uartputc_sync>
    8000029e:	4521                	li	a0,8
    800002a0:	00000097          	auipc	ra,0x0
    800002a4:	5ae080e7          	jalr	1454(ra) # 8000084e <uartputc_sync>
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
    800002c4:	97a080e7          	jalr	-1670(ra) # 80000c3a <acquire>

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
    800002e2:	64e080e7          	jalr	1614(ra) # 8000292c <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002e6:	00011517          	auipc	a0,0x11
    800002ea:	e9a50513          	addi	a0,a0,-358 # 80011180 <cons>
    800002ee:	00001097          	auipc	ra,0x1
    800002f2:	a00080e7          	jalr	-1536(ra) # 80000cee <release>
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
    80000436:	236080e7          	jalr	566(ra) # 80002668 <wakeup>
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
    80000458:	756080e7          	jalr	1878(ra) # 80000baa <initlock>

  uartinit();
    8000045c:	00000097          	auipc	ra,0x0
    80000460:	3a2080e7          	jalr	930(ra) # 800007fe <uartinit>

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
  int locking;
} pr;

static char digits[] = "0123456789abcdef";

static void printint(int xx, int base, int sign) {
    80000488:	7179                	addi	sp,sp,-48
    8000048a:	f406                	sd	ra,40(sp)
    8000048c:	f022                	sd	s0,32(sp)
    8000048e:	ec26                	sd	s1,24(sp)
    80000490:	e84a                	sd	s2,16(sp)
    80000492:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if (sign && (sign = xx < 0))
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
    800004aa:	bc260613          	addi	a2,a2,-1086 # 80008068 <digits>
    800004ae:	883a                	mv	a6,a4
    800004b0:	2705                	addiw	a4,a4,1
    800004b2:	02b577bb          	remuw	a5,a0,a1
    800004b6:	1782                	slli	a5,a5,0x20
    800004b8:	9381                	srli	a5,a5,0x20
    800004ba:	97b2                	add	a5,a5,a2
    800004bc:	0007c783          	lbu	a5,0(a5)
    800004c0:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    800004c4:	0005079b          	sext.w	a5,a0
    800004c8:	02b5553b          	divuw	a0,a0,a1
    800004cc:	0685                	addi	a3,a3,1
    800004ce:	feb7f0e3          	bgeu	a5,a1,800004ae <printint+0x26>

  if (sign)
    800004d2:	00088b63          	beqz	a7,800004e8 <printint+0x60>
    buf[i++] = '-';
    800004d6:	fe040793          	addi	a5,s0,-32
    800004da:	973e                	add	a4,a4,a5
    800004dc:	02d00793          	li	a5,45
    800004e0:	fef70823          	sb	a5,-16(a4)
    800004e4:	0028071b          	addiw	a4,a6,2

  while (--i >= 0)
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
  while (--i >= 0)
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
  if (sign && (sign = xx < 0))
    80000526:	4885                	li	a7,1
    x = -xx;
    80000528:	bf9d                	j	8000049e <printint+0x16>

000000008000052a <printfinit>:
  panicked = 1; // freeze uart output from other CPUs
  for (;;)
    ;
}

void printfinit(void) {
    8000052a:	1101                	addi	sp,sp,-32
    8000052c:	ec06                	sd	ra,24(sp)
    8000052e:	e822                	sd	s0,16(sp)
    80000530:	e426                	sd	s1,8(sp)
    80000532:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80000534:	00011497          	auipc	s1,0x11
    80000538:	cf448493          	addi	s1,s1,-780 # 80011228 <pr>
    8000053c:	00008597          	auipc	a1,0x8
    80000540:	adc58593          	addi	a1,a1,-1316 # 80008018 <etext+0x18>
    80000544:	8526                	mv	a0,s1
    80000546:	00000097          	auipc	ra,0x0
    8000054a:	664080e7          	jalr	1636(ra) # 80000baa <initlock>
  pr.locking = 1;
    8000054e:	4785                	li	a5,1
    80000550:	cc9c                	sw	a5,24(s1)
}
    80000552:	60e2                	ld	ra,24(sp)
    80000554:	6442                	ld	s0,16(sp)
    80000556:	64a2                	ld	s1,8(sp)
    80000558:	6105                	addi	sp,sp,32
    8000055a:	8082                	ret

000000008000055c <backtrace>:

void backtrace() {
    8000055c:	7179                	addi	sp,sp,-48
    8000055e:	f406                	sd	ra,40(sp)
    80000560:	f022                	sd	s0,32(sp)
    80000562:	ec26                	sd	s1,24(sp)
    80000564:	e84a                	sd	s2,16(sp)
    80000566:	e44e                	sd	s3,8(sp)
    80000568:	e052                	sd	s4,0(sp)
    8000056a:	1800                	addi	s0,sp,48
  asm volatile("mv %0, s0" : "=r"(x));
    8000056c:	8722                	mv	a4,s0
  u64 sp = r_fp();
  char *s = (char *)sp;
  u64 stack_base = PGROUNDUP(sp);
    8000056e:	6905                	lui	s2,0x1
    80000570:	197d                	addi	s2,s2,-1
    80000572:	993a                	add	s2,s2,a4
    80000574:	79fd                	lui	s3,0xfffff
    80000576:	01397933          	and	s2,s2,s3
  u64 stack_up = PGROUNDDOWN(sp);
    8000057a:	013779b3          	and	s3,a4,s3
  if (!(sp >= stack_up && sp <= stack_base)) {
    8000057e:	01376963          	bltu	a4,s3,80000590 <backtrace+0x34>
    80000582:	87ba                	mv	a5,a4
  u64 ra;
  while ((u64)s <= stack_base && (u64)s >= stack_up) {
    ra = *(u64 *)(s - 8);
    s = (char *)*(u64 *)(s - 16);
    if (((u64)s <= stack_base && (u64)s >= stack_up))
      printf("%p\n", ra);
    80000584:	00008a17          	auipc	s4,0x8
    80000588:	abca0a13          	addi	s4,s4,-1348 # 80008040 <etext+0x40>
  if (!(sp >= stack_up && sp <= stack_base)) {
    8000058c:	02e97263          	bgeu	s2,a4,800005b0 <backtrace+0x54>
    panic("invalid stack frame pointer");
    80000590:	00008517          	auipc	a0,0x8
    80000594:	a9050513          	addi	a0,a0,-1392 # 80008020 <etext+0x20>
    80000598:	00000097          	auipc	ra,0x0
    8000059c:	034080e7          	jalr	52(ra) # 800005cc <panic>
      printf("%p\n", ra);
    800005a0:	ff87b583          	ld	a1,-8(a5)
    800005a4:	8552                	mv	a0,s4
    800005a6:	00000097          	auipc	ra,0x0
    800005aa:	078080e7          	jalr	120(ra) # 8000061e <printf>
    800005ae:	87a6                	mv	a5,s1
    s = (char *)*(u64 *)(s - 16);
    800005b0:	ff07b483          	ld	s1,-16(a5)
    if (((u64)s <= stack_base && (u64)s >= stack_up))
    800005b4:	00996463          	bltu	s2,s1,800005bc <backtrace+0x60>
    800005b8:	ff34f4e3          	bgeu	s1,s3,800005a0 <backtrace+0x44>
  }
}
    800005bc:	70a2                	ld	ra,40(sp)
    800005be:	7402                	ld	s0,32(sp)
    800005c0:	64e2                	ld	s1,24(sp)
    800005c2:	6942                	ld	s2,16(sp)
    800005c4:	69a2                	ld	s3,8(sp)
    800005c6:	6a02                	ld	s4,0(sp)
    800005c8:	6145                	addi	sp,sp,48
    800005ca:	8082                	ret

00000000800005cc <panic>:
void panic(char *s) {
    800005cc:	1101                	addi	sp,sp,-32
    800005ce:	ec06                	sd	ra,24(sp)
    800005d0:	e822                	sd	s0,16(sp)
    800005d2:	e426                	sd	s1,8(sp)
    800005d4:	1000                	addi	s0,sp,32
    800005d6:	84aa                	mv	s1,a0
  pr.locking = 0;
    800005d8:	00011797          	auipc	a5,0x11
    800005dc:	c607a423          	sw	zero,-920(a5) # 80011240 <pr+0x18>
  backtrace();
    800005e0:	00000097          	auipc	ra,0x0
    800005e4:	f7c080e7          	jalr	-132(ra) # 8000055c <backtrace>
  printf(s);
    800005e8:	8526                	mv	a0,s1
    800005ea:	00000097          	auipc	ra,0x0
    800005ee:	034080e7          	jalr	52(ra) # 8000061e <printf>
  printf("\n");
    800005f2:	00008517          	auipc	a0,0x8
    800005f6:	afe50513          	addi	a0,a0,-1282 # 800080f0 <digits+0x88>
    800005fa:	00000097          	auipc	ra,0x0
    800005fe:	024080e7          	jalr	36(ra) # 8000061e <printf>
  printf("panic: ");
    80000602:	00008517          	auipc	a0,0x8
    80000606:	a4650513          	addi	a0,a0,-1466 # 80008048 <etext+0x48>
    8000060a:	00000097          	auipc	ra,0x0
    8000060e:	014080e7          	jalr	20(ra) # 8000061e <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000612:	4785                	li	a5,1
    80000614:	00009717          	auipc	a4,0x9
    80000618:	9ef72623          	sw	a5,-1556(a4) # 80009000 <panicked>
  for (;;)
    8000061c:	a001                	j	8000061c <panic+0x50>

000000008000061e <printf>:
void printf(char *fmt, ...) {
    8000061e:	7131                	addi	sp,sp,-192
    80000620:	fc86                	sd	ra,120(sp)
    80000622:	f8a2                	sd	s0,112(sp)
    80000624:	f4a6                	sd	s1,104(sp)
    80000626:	f0ca                	sd	s2,96(sp)
    80000628:	ecce                	sd	s3,88(sp)
    8000062a:	e8d2                	sd	s4,80(sp)
    8000062c:	e4d6                	sd	s5,72(sp)
    8000062e:	e0da                	sd	s6,64(sp)
    80000630:	fc5e                	sd	s7,56(sp)
    80000632:	f862                	sd	s8,48(sp)
    80000634:	f466                	sd	s9,40(sp)
    80000636:	f06a                	sd	s10,32(sp)
    80000638:	ec6e                	sd	s11,24(sp)
    8000063a:	0100                	addi	s0,sp,128
    8000063c:	8a2a                	mv	s4,a0
    8000063e:	e40c                	sd	a1,8(s0)
    80000640:	e810                	sd	a2,16(s0)
    80000642:	ec14                	sd	a3,24(s0)
    80000644:	f018                	sd	a4,32(s0)
    80000646:	f41c                	sd	a5,40(s0)
    80000648:	03043823          	sd	a6,48(s0)
    8000064c:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80000650:	00011d97          	auipc	s11,0x11
    80000654:	bf0dad83          	lw	s11,-1040(s11) # 80011240 <pr+0x18>
  if (locking)
    80000658:	020d9b63          	bnez	s11,8000068e <printf+0x70>
  if (fmt == 0)
    8000065c:	040a0263          	beqz	s4,800006a0 <printf+0x82>
  va_start(ap, fmt);
    80000660:	00840793          	addi	a5,s0,8
    80000664:	f8f43423          	sd	a5,-120(s0)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80000668:	000a4503          	lbu	a0,0(s4)
    8000066c:	14050f63          	beqz	a0,800007ca <printf+0x1ac>
    80000670:	4981                	li	s3,0
    if (c != '%') {
    80000672:	02500a93          	li	s5,37
    switch (c) {
    80000676:	07000b93          	li	s7,112
  consputc('x');
    8000067a:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000067c:	00008b17          	auipc	s6,0x8
    80000680:	9ecb0b13          	addi	s6,s6,-1556 # 80008068 <digits>
    switch (c) {
    80000684:	07300c93          	li	s9,115
    80000688:	06400c13          	li	s8,100
    8000068c:	a82d                	j	800006c6 <printf+0xa8>
    acquire(&pr.lock);
    8000068e:	00011517          	auipc	a0,0x11
    80000692:	b9a50513          	addi	a0,a0,-1126 # 80011228 <pr>
    80000696:	00000097          	auipc	ra,0x0
    8000069a:	5a4080e7          	jalr	1444(ra) # 80000c3a <acquire>
    8000069e:	bf7d                	j	8000065c <printf+0x3e>
    panic("null fmt");
    800006a0:	00008517          	auipc	a0,0x8
    800006a4:	9b850513          	addi	a0,a0,-1608 # 80008058 <etext+0x58>
    800006a8:	00000097          	auipc	ra,0x0
    800006ac:	f24080e7          	jalr	-220(ra) # 800005cc <panic>
      consputc(c);
    800006b0:	00000097          	auipc	ra,0x0
    800006b4:	bb8080e7          	jalr	-1096(ra) # 80000268 <consputc>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    800006b8:	2985                	addiw	s3,s3,1
    800006ba:	013a07b3          	add	a5,s4,s3
    800006be:	0007c503          	lbu	a0,0(a5)
    800006c2:	10050463          	beqz	a0,800007ca <printf+0x1ac>
    if (c != '%') {
    800006c6:	ff5515e3          	bne	a0,s5,800006b0 <printf+0x92>
    c = fmt[++i] & 0xff;
    800006ca:	2985                	addiw	s3,s3,1
    800006cc:	013a07b3          	add	a5,s4,s3
    800006d0:	0007c783          	lbu	a5,0(a5)
    800006d4:	0007849b          	sext.w	s1,a5
    if (c == 0)
    800006d8:	cbed                	beqz	a5,800007ca <printf+0x1ac>
    switch (c) {
    800006da:	05778a63          	beq	a5,s7,8000072e <printf+0x110>
    800006de:	02fbf663          	bgeu	s7,a5,8000070a <printf+0xec>
    800006e2:	09978863          	beq	a5,s9,80000772 <printf+0x154>
    800006e6:	07800713          	li	a4,120
    800006ea:	0ce79563          	bne	a5,a4,800007b4 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    800006ee:	f8843783          	ld	a5,-120(s0)
    800006f2:	00878713          	addi	a4,a5,8
    800006f6:	f8e43423          	sd	a4,-120(s0)
    800006fa:	4605                	li	a2,1
    800006fc:	85ea                	mv	a1,s10
    800006fe:	4388                	lw	a0,0(a5)
    80000700:	00000097          	auipc	ra,0x0
    80000704:	d88080e7          	jalr	-632(ra) # 80000488 <printint>
      break;
    80000708:	bf45                	j	800006b8 <printf+0x9a>
    switch (c) {
    8000070a:	09578f63          	beq	a5,s5,800007a8 <printf+0x18a>
    8000070e:	0b879363          	bne	a5,s8,800007b4 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80000712:	f8843783          	ld	a5,-120(s0)
    80000716:	00878713          	addi	a4,a5,8
    8000071a:	f8e43423          	sd	a4,-120(s0)
    8000071e:	4605                	li	a2,1
    80000720:	45a9                	li	a1,10
    80000722:	4388                	lw	a0,0(a5)
    80000724:	00000097          	auipc	ra,0x0
    80000728:	d64080e7          	jalr	-668(ra) # 80000488 <printint>
      break;
    8000072c:	b771                	j	800006b8 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    8000072e:	f8843783          	ld	a5,-120(s0)
    80000732:	00878713          	addi	a4,a5,8
    80000736:	f8e43423          	sd	a4,-120(s0)
    8000073a:	0007b903          	ld	s2,0(a5)
  consputc('0');
    8000073e:	03000513          	li	a0,48
    80000742:	00000097          	auipc	ra,0x0
    80000746:	b26080e7          	jalr	-1242(ra) # 80000268 <consputc>
  consputc('x');
    8000074a:	07800513          	li	a0,120
    8000074e:	00000097          	auipc	ra,0x0
    80000752:	b1a080e7          	jalr	-1254(ra) # 80000268 <consputc>
    80000756:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000758:	03c95793          	srli	a5,s2,0x3c
    8000075c:	97da                	add	a5,a5,s6
    8000075e:	0007c503          	lbu	a0,0(a5)
    80000762:	00000097          	auipc	ra,0x0
    80000766:	b06080e7          	jalr	-1274(ra) # 80000268 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000076a:	0912                	slli	s2,s2,0x4
    8000076c:	34fd                	addiw	s1,s1,-1
    8000076e:	f4ed                	bnez	s1,80000758 <printf+0x13a>
    80000770:	b7a1                	j	800006b8 <printf+0x9a>
      if ((s = va_arg(ap, char *)) == 0)
    80000772:	f8843783          	ld	a5,-120(s0)
    80000776:	00878713          	addi	a4,a5,8
    8000077a:	f8e43423          	sd	a4,-120(s0)
    8000077e:	6384                	ld	s1,0(a5)
    80000780:	cc89                	beqz	s1,8000079a <printf+0x17c>
      for (; *s; s++)
    80000782:	0004c503          	lbu	a0,0(s1)
    80000786:	d90d                	beqz	a0,800006b8 <printf+0x9a>
        consputc(*s);
    80000788:	00000097          	auipc	ra,0x0
    8000078c:	ae0080e7          	jalr	-1312(ra) # 80000268 <consputc>
      for (; *s; s++)
    80000790:	0485                	addi	s1,s1,1
    80000792:	0004c503          	lbu	a0,0(s1)
    80000796:	f96d                	bnez	a0,80000788 <printf+0x16a>
    80000798:	b705                	j	800006b8 <printf+0x9a>
        s = "(null)";
    8000079a:	00008497          	auipc	s1,0x8
    8000079e:	8b648493          	addi	s1,s1,-1866 # 80008050 <etext+0x50>
      for (; *s; s++)
    800007a2:	02800513          	li	a0,40
    800007a6:	b7cd                	j	80000788 <printf+0x16a>
      consputc('%');
    800007a8:	8556                	mv	a0,s5
    800007aa:	00000097          	auipc	ra,0x0
    800007ae:	abe080e7          	jalr	-1346(ra) # 80000268 <consputc>
      break;
    800007b2:	b719                	j	800006b8 <printf+0x9a>
      consputc('%');
    800007b4:	8556                	mv	a0,s5
    800007b6:	00000097          	auipc	ra,0x0
    800007ba:	ab2080e7          	jalr	-1358(ra) # 80000268 <consputc>
      consputc(c);
    800007be:	8526                	mv	a0,s1
    800007c0:	00000097          	auipc	ra,0x0
    800007c4:	aa8080e7          	jalr	-1368(ra) # 80000268 <consputc>
      break;
    800007c8:	bdc5                	j	800006b8 <printf+0x9a>
  if (locking)
    800007ca:	020d9163          	bnez	s11,800007ec <printf+0x1ce>
}
    800007ce:	70e6                	ld	ra,120(sp)
    800007d0:	7446                	ld	s0,112(sp)
    800007d2:	74a6                	ld	s1,104(sp)
    800007d4:	7906                	ld	s2,96(sp)
    800007d6:	69e6                	ld	s3,88(sp)
    800007d8:	6a46                	ld	s4,80(sp)
    800007da:	6aa6                	ld	s5,72(sp)
    800007dc:	6b06                	ld	s6,64(sp)
    800007de:	7be2                	ld	s7,56(sp)
    800007e0:	7c42                	ld	s8,48(sp)
    800007e2:	7ca2                	ld	s9,40(sp)
    800007e4:	7d02                	ld	s10,32(sp)
    800007e6:	6de2                	ld	s11,24(sp)
    800007e8:	6129                	addi	sp,sp,192
    800007ea:	8082                	ret
    release(&pr.lock);
    800007ec:	00011517          	auipc	a0,0x11
    800007f0:	a3c50513          	addi	a0,a0,-1476 # 80011228 <pr>
    800007f4:	00000097          	auipc	ra,0x0
    800007f8:	4fa080e7          	jalr	1274(ra) # 80000cee <release>
}
    800007fc:	bfc9                	j	800007ce <printf+0x1b0>

00000000800007fe <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007fe:	1141                	addi	sp,sp,-16
    80000800:	e406                	sd	ra,8(sp)
    80000802:	e022                	sd	s0,0(sp)
    80000804:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80000806:	100007b7          	lui	a5,0x10000
    8000080a:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000080e:	f8000713          	li	a4,-128
    80000812:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000816:	470d                	li	a4,3
    80000818:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000081c:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000820:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000824:	469d                	li	a3,7
    80000826:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000082a:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000082e:	00008597          	auipc	a1,0x8
    80000832:	85258593          	addi	a1,a1,-1966 # 80008080 <digits+0x18>
    80000836:	00011517          	auipc	a0,0x11
    8000083a:	a1250513          	addi	a0,a0,-1518 # 80011248 <uart_tx_lock>
    8000083e:	00000097          	auipc	ra,0x0
    80000842:	36c080e7          	jalr	876(ra) # 80000baa <initlock>
}
    80000846:	60a2                	ld	ra,8(sp)
    80000848:	6402                	ld	s0,0(sp)
    8000084a:	0141                	addi	sp,sp,16
    8000084c:	8082                	ret

000000008000084e <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000084e:	1101                	addi	sp,sp,-32
    80000850:	ec06                	sd	ra,24(sp)
    80000852:	e822                	sd	s0,16(sp)
    80000854:	e426                	sd	s1,8(sp)
    80000856:	1000                	addi	s0,sp,32
    80000858:	84aa                	mv	s1,a0
  push_off();
    8000085a:	00000097          	auipc	ra,0x0
    8000085e:	394080e7          	jalr	916(ra) # 80000bee <push_off>

  if(panicked){
    80000862:	00008797          	auipc	a5,0x8
    80000866:	79e7a783          	lw	a5,1950(a5) # 80009000 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000086a:	10000737          	lui	a4,0x10000
  if(panicked){
    8000086e:	c391                	beqz	a5,80000872 <uartputc_sync+0x24>
    for(;;)
    80000870:	a001                	j	80000870 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000872:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000876:	0207f793          	andi	a5,a5,32
    8000087a:	dfe5                	beqz	a5,80000872 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000087c:	0ff4f513          	andi	a0,s1,255
    80000880:	100007b7          	lui	a5,0x10000
    80000884:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000888:	00000097          	auipc	ra,0x0
    8000088c:	406080e7          	jalr	1030(ra) # 80000c8e <pop_off>
}
    80000890:	60e2                	ld	ra,24(sp)
    80000892:	6442                	ld	s0,16(sp)
    80000894:	64a2                	ld	s1,8(sp)
    80000896:	6105                	addi	sp,sp,32
    80000898:	8082                	ret

000000008000089a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000089a:	00008797          	auipc	a5,0x8
    8000089e:	76e7b783          	ld	a5,1902(a5) # 80009008 <uart_tx_r>
    800008a2:	00008717          	auipc	a4,0x8
    800008a6:	76e73703          	ld	a4,1902(a4) # 80009010 <uart_tx_w>
    800008aa:	06f70a63          	beq	a4,a5,8000091e <uartstart+0x84>
{
    800008ae:	7139                	addi	sp,sp,-64
    800008b0:	fc06                	sd	ra,56(sp)
    800008b2:	f822                	sd	s0,48(sp)
    800008b4:	f426                	sd	s1,40(sp)
    800008b6:	f04a                	sd	s2,32(sp)
    800008b8:	ec4e                	sd	s3,24(sp)
    800008ba:	e852                	sd	s4,16(sp)
    800008bc:	e456                	sd	s5,8(sp)
    800008be:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008c0:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008c4:	00011a17          	auipc	s4,0x11
    800008c8:	984a0a13          	addi	s4,s4,-1660 # 80011248 <uart_tx_lock>
    uart_tx_r += 1;
    800008cc:	00008497          	auipc	s1,0x8
    800008d0:	73c48493          	addi	s1,s1,1852 # 80009008 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800008d4:	00008997          	auipc	s3,0x8
    800008d8:	73c98993          	addi	s3,s3,1852 # 80009010 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008dc:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    800008e0:	02077713          	andi	a4,a4,32
    800008e4:	c705                	beqz	a4,8000090c <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008e6:	01f7f713          	andi	a4,a5,31
    800008ea:	9752                	add	a4,a4,s4
    800008ec:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    800008f0:	0785                	addi	a5,a5,1
    800008f2:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800008f4:	8526                	mv	a0,s1
    800008f6:	00002097          	auipc	ra,0x2
    800008fa:	d72080e7          	jalr	-654(ra) # 80002668 <wakeup>
    
    WriteReg(THR, c);
    800008fe:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80000902:	609c                	ld	a5,0(s1)
    80000904:	0009b703          	ld	a4,0(s3)
    80000908:	fcf71ae3          	bne	a4,a5,800008dc <uartstart+0x42>
  }
}
    8000090c:	70e2                	ld	ra,56(sp)
    8000090e:	7442                	ld	s0,48(sp)
    80000910:	74a2                	ld	s1,40(sp)
    80000912:	7902                	ld	s2,32(sp)
    80000914:	69e2                	ld	s3,24(sp)
    80000916:	6a42                	ld	s4,16(sp)
    80000918:	6aa2                	ld	s5,8(sp)
    8000091a:	6121                	addi	sp,sp,64
    8000091c:	8082                	ret
    8000091e:	8082                	ret

0000000080000920 <uartputc>:
{
    80000920:	7179                	addi	sp,sp,-48
    80000922:	f406                	sd	ra,40(sp)
    80000924:	f022                	sd	s0,32(sp)
    80000926:	ec26                	sd	s1,24(sp)
    80000928:	e84a                	sd	s2,16(sp)
    8000092a:	e44e                	sd	s3,8(sp)
    8000092c:	e052                	sd	s4,0(sp)
    8000092e:	1800                	addi	s0,sp,48
    80000930:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80000932:	00011517          	auipc	a0,0x11
    80000936:	91650513          	addi	a0,a0,-1770 # 80011248 <uart_tx_lock>
    8000093a:	00000097          	auipc	ra,0x0
    8000093e:	300080e7          	jalr	768(ra) # 80000c3a <acquire>
  if(panicked){
    80000942:	00008797          	auipc	a5,0x8
    80000946:	6be7a783          	lw	a5,1726(a5) # 80009000 <panicked>
    8000094a:	c391                	beqz	a5,8000094e <uartputc+0x2e>
    for(;;)
    8000094c:	a001                	j	8000094c <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000094e:	00008717          	auipc	a4,0x8
    80000952:	6c273703          	ld	a4,1730(a4) # 80009010 <uart_tx_w>
    80000956:	00008797          	auipc	a5,0x8
    8000095a:	6b27b783          	ld	a5,1714(a5) # 80009008 <uart_tx_r>
    8000095e:	02078793          	addi	a5,a5,32
    80000962:	02e79b63          	bne	a5,a4,80000998 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80000966:	00011997          	auipc	s3,0x11
    8000096a:	8e298993          	addi	s3,s3,-1822 # 80011248 <uart_tx_lock>
    8000096e:	00008497          	auipc	s1,0x8
    80000972:	69a48493          	addi	s1,s1,1690 # 80009008 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000976:	00008917          	auipc	s2,0x8
    8000097a:	69a90913          	addi	s2,s2,1690 # 80009010 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000097e:	85ce                	mv	a1,s3
    80000980:	8526                	mv	a0,s1
    80000982:	00002097          	auipc	ra,0x2
    80000986:	b5a080e7          	jalr	-1190(ra) # 800024dc <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000098a:	00093703          	ld	a4,0(s2)
    8000098e:	609c                	ld	a5,0(s1)
    80000990:	02078793          	addi	a5,a5,32
    80000994:	fee785e3          	beq	a5,a4,8000097e <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000998:	00011497          	auipc	s1,0x11
    8000099c:	8b048493          	addi	s1,s1,-1872 # 80011248 <uart_tx_lock>
    800009a0:	01f77793          	andi	a5,a4,31
    800009a4:	97a6                	add	a5,a5,s1
    800009a6:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    800009aa:	0705                	addi	a4,a4,1
    800009ac:	00008797          	auipc	a5,0x8
    800009b0:	66e7b223          	sd	a4,1636(a5) # 80009010 <uart_tx_w>
      uartstart();
    800009b4:	00000097          	auipc	ra,0x0
    800009b8:	ee6080e7          	jalr	-282(ra) # 8000089a <uartstart>
      release(&uart_tx_lock);
    800009bc:	8526                	mv	a0,s1
    800009be:	00000097          	auipc	ra,0x0
    800009c2:	330080e7          	jalr	816(ra) # 80000cee <release>
}
    800009c6:	70a2                	ld	ra,40(sp)
    800009c8:	7402                	ld	s0,32(sp)
    800009ca:	64e2                	ld	s1,24(sp)
    800009cc:	6942                	ld	s2,16(sp)
    800009ce:	69a2                	ld	s3,8(sp)
    800009d0:	6a02                	ld	s4,0(sp)
    800009d2:	6145                	addi	sp,sp,48
    800009d4:	8082                	ret

00000000800009d6 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009d6:	1141                	addi	sp,sp,-16
    800009d8:	e422                	sd	s0,8(sp)
    800009da:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009dc:	100007b7          	lui	a5,0x10000
    800009e0:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009e4:	8b85                	andi	a5,a5,1
    800009e6:	cb91                	beqz	a5,800009fa <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800009e8:	100007b7          	lui	a5,0x10000
    800009ec:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800009f0:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800009f4:	6422                	ld	s0,8(sp)
    800009f6:	0141                	addi	sp,sp,16
    800009f8:	8082                	ret
    return -1;
    800009fa:	557d                	li	a0,-1
    800009fc:	bfe5                	j	800009f4 <uartgetc+0x1e>

00000000800009fe <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800009fe:	1101                	addi	sp,sp,-32
    80000a00:	ec06                	sd	ra,24(sp)
    80000a02:	e822                	sd	s0,16(sp)
    80000a04:	e426                	sd	s1,8(sp)
    80000a06:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a08:	54fd                	li	s1,-1
    80000a0a:	a029                	j	80000a14 <uartintr+0x16>
      break;
    consoleintr(c);
    80000a0c:	00000097          	auipc	ra,0x0
    80000a10:	89e080e7          	jalr	-1890(ra) # 800002aa <consoleintr>
    int c = uartgetc();
    80000a14:	00000097          	auipc	ra,0x0
    80000a18:	fc2080e7          	jalr	-62(ra) # 800009d6 <uartgetc>
    if(c == -1)
    80000a1c:	fe9518e3          	bne	a0,s1,80000a0c <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a20:	00011497          	auipc	s1,0x11
    80000a24:	82848493          	addi	s1,s1,-2008 # 80011248 <uart_tx_lock>
    80000a28:	8526                	mv	a0,s1
    80000a2a:	00000097          	auipc	ra,0x0
    80000a2e:	210080e7          	jalr	528(ra) # 80000c3a <acquire>
  uartstart();
    80000a32:	00000097          	auipc	ra,0x0
    80000a36:	e68080e7          	jalr	-408(ra) # 8000089a <uartstart>
  release(&uart_tx_lock);
    80000a3a:	8526                	mv	a0,s1
    80000a3c:	00000097          	auipc	ra,0x0
    80000a40:	2b2080e7          	jalr	690(ra) # 80000cee <release>
}
    80000a44:	60e2                	ld	ra,24(sp)
    80000a46:	6442                	ld	s0,16(sp)
    80000a48:	64a2                	ld	s1,8(sp)
    80000a4a:	6105                	addi	sp,sp,32
    80000a4c:	8082                	ret

0000000080000a4e <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a4e:	1101                	addi	sp,sp,-32
    80000a50:	ec06                	sd	ra,24(sp)
    80000a52:	e822                	sd	s0,16(sp)
    80000a54:	e426                	sd	s1,8(sp)
    80000a56:	e04a                	sd	s2,0(sp)
    80000a58:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a5a:	03451793          	slli	a5,a0,0x34
    80000a5e:	ebb9                	bnez	a5,80000ab4 <kfree+0x66>
    80000a60:	84aa                	mv	s1,a0
    80000a62:	00025797          	auipc	a5,0x25
    80000a66:	59e78793          	addi	a5,a5,1438 # 80026000 <end>
    80000a6a:	04f56563          	bltu	a0,a5,80000ab4 <kfree+0x66>
    80000a6e:	47c5                	li	a5,17
    80000a70:	07ee                	slli	a5,a5,0x1b
    80000a72:	04f57163          	bgeu	a0,a5,80000ab4 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a76:	6605                	lui	a2,0x1
    80000a78:	4585                	li	a1,1
    80000a7a:	00000097          	auipc	ra,0x0
    80000a7e:	2bc080e7          	jalr	700(ra) # 80000d36 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a82:	00010917          	auipc	s2,0x10
    80000a86:	7fe90913          	addi	s2,s2,2046 # 80011280 <kmem>
    80000a8a:	854a                	mv	a0,s2
    80000a8c:	00000097          	auipc	ra,0x0
    80000a90:	1ae080e7          	jalr	430(ra) # 80000c3a <acquire>
  r->next = kmem.freelist;
    80000a94:	01893783          	ld	a5,24(s2)
    80000a98:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a9a:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a9e:	854a                	mv	a0,s2
    80000aa0:	00000097          	auipc	ra,0x0
    80000aa4:	24e080e7          	jalr	590(ra) # 80000cee <release>
}
    80000aa8:	60e2                	ld	ra,24(sp)
    80000aaa:	6442                	ld	s0,16(sp)
    80000aac:	64a2                	ld	s1,8(sp)
    80000aae:	6902                	ld	s2,0(sp)
    80000ab0:	6105                	addi	sp,sp,32
    80000ab2:	8082                	ret
    panic("kfree");
    80000ab4:	00007517          	auipc	a0,0x7
    80000ab8:	5d450513          	addi	a0,a0,1492 # 80008088 <digits+0x20>
    80000abc:	00000097          	auipc	ra,0x0
    80000ac0:	b10080e7          	jalr	-1264(ra) # 800005cc <panic>

0000000080000ac4 <freerange>:
{
    80000ac4:	7179                	addi	sp,sp,-48
    80000ac6:	f406                	sd	ra,40(sp)
    80000ac8:	f022                	sd	s0,32(sp)
    80000aca:	ec26                	sd	s1,24(sp)
    80000acc:	e84a                	sd	s2,16(sp)
    80000ace:	e44e                	sd	s3,8(sp)
    80000ad0:	e052                	sd	s4,0(sp)
    80000ad2:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000ad4:	6785                	lui	a5,0x1
    80000ad6:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000ada:	94aa                	add	s1,s1,a0
    80000adc:	757d                	lui	a0,0xfffff
    80000ade:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ae0:	94be                	add	s1,s1,a5
    80000ae2:	0095ee63          	bltu	a1,s1,80000afe <freerange+0x3a>
    80000ae6:	892e                	mv	s2,a1
    kfree(p);
    80000ae8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000aea:	6985                	lui	s3,0x1
    kfree(p);
    80000aec:	01448533          	add	a0,s1,s4
    80000af0:	00000097          	auipc	ra,0x0
    80000af4:	f5e080e7          	jalr	-162(ra) # 80000a4e <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000af8:	94ce                	add	s1,s1,s3
    80000afa:	fe9979e3          	bgeu	s2,s1,80000aec <freerange+0x28>
}
    80000afe:	70a2                	ld	ra,40(sp)
    80000b00:	7402                	ld	s0,32(sp)
    80000b02:	64e2                	ld	s1,24(sp)
    80000b04:	6942                	ld	s2,16(sp)
    80000b06:	69a2                	ld	s3,8(sp)
    80000b08:	6a02                	ld	s4,0(sp)
    80000b0a:	6145                	addi	sp,sp,48
    80000b0c:	8082                	ret

0000000080000b0e <kinit>:
{
    80000b0e:	1141                	addi	sp,sp,-16
    80000b10:	e406                	sd	ra,8(sp)
    80000b12:	e022                	sd	s0,0(sp)
    80000b14:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000b16:	00007597          	auipc	a1,0x7
    80000b1a:	57a58593          	addi	a1,a1,1402 # 80008090 <digits+0x28>
    80000b1e:	00010517          	auipc	a0,0x10
    80000b22:	76250513          	addi	a0,a0,1890 # 80011280 <kmem>
    80000b26:	00000097          	auipc	ra,0x0
    80000b2a:	084080e7          	jalr	132(ra) # 80000baa <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b2e:	45c5                	li	a1,17
    80000b30:	05ee                	slli	a1,a1,0x1b
    80000b32:	00025517          	auipc	a0,0x25
    80000b36:	4ce50513          	addi	a0,a0,1230 # 80026000 <end>
    80000b3a:	00000097          	auipc	ra,0x0
    80000b3e:	f8a080e7          	jalr	-118(ra) # 80000ac4 <freerange>
}
    80000b42:	60a2                	ld	ra,8(sp)
    80000b44:	6402                	ld	s0,0(sp)
    80000b46:	0141                	addi	sp,sp,16
    80000b48:	8082                	ret

0000000080000b4a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b4a:	1101                	addi	sp,sp,-32
    80000b4c:	ec06                	sd	ra,24(sp)
    80000b4e:	e822                	sd	s0,16(sp)
    80000b50:	e426                	sd	s1,8(sp)
    80000b52:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b54:	00010497          	auipc	s1,0x10
    80000b58:	72c48493          	addi	s1,s1,1836 # 80011280 <kmem>
    80000b5c:	8526                	mv	a0,s1
    80000b5e:	00000097          	auipc	ra,0x0
    80000b62:	0dc080e7          	jalr	220(ra) # 80000c3a <acquire>
  r = kmem.freelist;
    80000b66:	6c84                	ld	s1,24(s1)
  if(r)
    80000b68:	c885                	beqz	s1,80000b98 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b6a:	609c                	ld	a5,0(s1)
    80000b6c:	00010517          	auipc	a0,0x10
    80000b70:	71450513          	addi	a0,a0,1812 # 80011280 <kmem>
    80000b74:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b76:	00000097          	auipc	ra,0x0
    80000b7a:	178080e7          	jalr	376(ra) # 80000cee <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b7e:	6605                	lui	a2,0x1
    80000b80:	4595                	li	a1,5
    80000b82:	8526                	mv	a0,s1
    80000b84:	00000097          	auipc	ra,0x0
    80000b88:	1b2080e7          	jalr	434(ra) # 80000d36 <memset>
  return (void*)r;
}
    80000b8c:	8526                	mv	a0,s1
    80000b8e:	60e2                	ld	ra,24(sp)
    80000b90:	6442                	ld	s0,16(sp)
    80000b92:	64a2                	ld	s1,8(sp)
    80000b94:	6105                	addi	sp,sp,32
    80000b96:	8082                	ret
  release(&kmem.lock);
    80000b98:	00010517          	auipc	a0,0x10
    80000b9c:	6e850513          	addi	a0,a0,1768 # 80011280 <kmem>
    80000ba0:	00000097          	auipc	ra,0x0
    80000ba4:	14e080e7          	jalr	334(ra) # 80000cee <release>
  if(r)
    80000ba8:	b7d5                	j	80000b8c <kalloc+0x42>

0000000080000baa <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000baa:	1141                	addi	sp,sp,-16
    80000bac:	e422                	sd	s0,8(sp)
    80000bae:	0800                	addi	s0,sp,16
  lk->name = name;
    80000bb0:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000bb2:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000bb6:	00053823          	sd	zero,16(a0)
}
    80000bba:	6422                	ld	s0,8(sp)
    80000bbc:	0141                	addi	sp,sp,16
    80000bbe:	8082                	ret

0000000080000bc0 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000bc0:	411c                	lw	a5,0(a0)
    80000bc2:	e399                	bnez	a5,80000bc8 <holding+0x8>
    80000bc4:	4501                	li	a0,0
  return r;
}
    80000bc6:	8082                	ret
{
    80000bc8:	1101                	addi	sp,sp,-32
    80000bca:	ec06                	sd	ra,24(sp)
    80000bcc:	e822                	sd	s0,16(sp)
    80000bce:	e426                	sd	s1,8(sp)
    80000bd0:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000bd2:	6904                	ld	s1,16(a0)
    80000bd4:	00001097          	auipc	ra,0x1
    80000bd8:	07c080e7          	jalr	124(ra) # 80001c50 <mycpu>
    80000bdc:	40a48533          	sub	a0,s1,a0
    80000be0:	00153513          	seqz	a0,a0
}
    80000be4:	60e2                	ld	ra,24(sp)
    80000be6:	6442                	ld	s0,16(sp)
    80000be8:	64a2                	ld	s1,8(sp)
    80000bea:	6105                	addi	sp,sp,32
    80000bec:	8082                	ret

0000000080000bee <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bee:	1101                	addi	sp,sp,-32
    80000bf0:	ec06                	sd	ra,24(sp)
    80000bf2:	e822                	sd	s0,16(sp)
    80000bf4:	e426                	sd	s1,8(sp)
    80000bf6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80000bf8:	100024f3          	csrr	s1,sstatus
    80000bfc:	100027f3          	csrr	a5,sstatus
static inline void intr_off() { w_sstatus(r_sstatus() & ~SSTATUS_SIE); }
    80000c00:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80000c02:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000c06:	00001097          	auipc	ra,0x1
    80000c0a:	04a080e7          	jalr	74(ra) # 80001c50 <mycpu>
    80000c0e:	5d3c                	lw	a5,120(a0)
    80000c10:	cf89                	beqz	a5,80000c2a <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c12:	00001097          	auipc	ra,0x1
    80000c16:	03e080e7          	jalr	62(ra) # 80001c50 <mycpu>
    80000c1a:	5d3c                	lw	a5,120(a0)
    80000c1c:	2785                	addiw	a5,a5,1
    80000c1e:	dd3c                	sw	a5,120(a0)
}
    80000c20:	60e2                	ld	ra,24(sp)
    80000c22:	6442                	ld	s0,16(sp)
    80000c24:	64a2                	ld	s1,8(sp)
    80000c26:	6105                	addi	sp,sp,32
    80000c28:	8082                	ret
    mycpu()->intena = old;
    80000c2a:	00001097          	auipc	ra,0x1
    80000c2e:	026080e7          	jalr	38(ra) # 80001c50 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000c32:	8085                	srli	s1,s1,0x1
    80000c34:	8885                	andi	s1,s1,1
    80000c36:	dd64                	sw	s1,124(a0)
    80000c38:	bfe9                	j	80000c12 <push_off+0x24>

0000000080000c3a <acquire>:
{
    80000c3a:	1101                	addi	sp,sp,-32
    80000c3c:	ec06                	sd	ra,24(sp)
    80000c3e:	e822                	sd	s0,16(sp)
    80000c40:	e426                	sd	s1,8(sp)
    80000c42:	1000                	addi	s0,sp,32
    80000c44:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c46:	00000097          	auipc	ra,0x0
    80000c4a:	fa8080e7          	jalr	-88(ra) # 80000bee <push_off>
  if(holding(lk))
    80000c4e:	8526                	mv	a0,s1
    80000c50:	00000097          	auipc	ra,0x0
    80000c54:	f70080e7          	jalr	-144(ra) # 80000bc0 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c58:	4705                	li	a4,1
  if(holding(lk))
    80000c5a:	e115                	bnez	a0,80000c7e <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c5c:	87ba                	mv	a5,a4
    80000c5e:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c62:	2781                	sext.w	a5,a5
    80000c64:	ffe5                	bnez	a5,80000c5c <acquire+0x22>
  __sync_synchronize();
    80000c66:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c6a:	00001097          	auipc	ra,0x1
    80000c6e:	fe6080e7          	jalr	-26(ra) # 80001c50 <mycpu>
    80000c72:	e888                	sd	a0,16(s1)
}
    80000c74:	60e2                	ld	ra,24(sp)
    80000c76:	6442                	ld	s0,16(sp)
    80000c78:	64a2                	ld	s1,8(sp)
    80000c7a:	6105                	addi	sp,sp,32
    80000c7c:	8082                	ret
    panic("acquire");
    80000c7e:	00007517          	auipc	a0,0x7
    80000c82:	41a50513          	addi	a0,a0,1050 # 80008098 <digits+0x30>
    80000c86:	00000097          	auipc	ra,0x0
    80000c8a:	946080e7          	jalr	-1722(ra) # 800005cc <panic>

0000000080000c8e <pop_off>:

void
pop_off(void)
{
    80000c8e:	1141                	addi	sp,sp,-16
    80000c90:	e406                	sd	ra,8(sp)
    80000c92:	e022                	sd	s0,0(sp)
    80000c94:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c96:	00001097          	auipc	ra,0x1
    80000c9a:	fba080e7          	jalr	-70(ra) # 80001c50 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80000c9e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000ca2:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000ca4:	e78d                	bnez	a5,80000cce <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000ca6:	5d3c                	lw	a5,120(a0)
    80000ca8:	02f05b63          	blez	a5,80000cde <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000cac:	37fd                	addiw	a5,a5,-1
    80000cae:	0007871b          	sext.w	a4,a5
    80000cb2:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000cb4:	eb09                	bnez	a4,80000cc6 <pop_off+0x38>
    80000cb6:	5d7c                	lw	a5,124(a0)
    80000cb8:	c799                	beqz	a5,80000cc6 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80000cba:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80000cbe:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80000cc2:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000cc6:	60a2                	ld	ra,8(sp)
    80000cc8:	6402                	ld	s0,0(sp)
    80000cca:	0141                	addi	sp,sp,16
    80000ccc:	8082                	ret
    panic("pop_off - interruptible");
    80000cce:	00007517          	auipc	a0,0x7
    80000cd2:	3d250513          	addi	a0,a0,978 # 800080a0 <digits+0x38>
    80000cd6:	00000097          	auipc	ra,0x0
    80000cda:	8f6080e7          	jalr	-1802(ra) # 800005cc <panic>
    panic("pop_off");
    80000cde:	00007517          	auipc	a0,0x7
    80000ce2:	3da50513          	addi	a0,a0,986 # 800080b8 <digits+0x50>
    80000ce6:	00000097          	auipc	ra,0x0
    80000cea:	8e6080e7          	jalr	-1818(ra) # 800005cc <panic>

0000000080000cee <release>:
{
    80000cee:	1101                	addi	sp,sp,-32
    80000cf0:	ec06                	sd	ra,24(sp)
    80000cf2:	e822                	sd	s0,16(sp)
    80000cf4:	e426                	sd	s1,8(sp)
    80000cf6:	1000                	addi	s0,sp,32
    80000cf8:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000cfa:	00000097          	auipc	ra,0x0
    80000cfe:	ec6080e7          	jalr	-314(ra) # 80000bc0 <holding>
    80000d02:	c115                	beqz	a0,80000d26 <release+0x38>
  lk->cpu = 0;
    80000d04:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000d08:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000d0c:	0f50000f          	fence	iorw,ow
    80000d10:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000d14:	00000097          	auipc	ra,0x0
    80000d18:	f7a080e7          	jalr	-134(ra) # 80000c8e <pop_off>
}
    80000d1c:	60e2                	ld	ra,24(sp)
    80000d1e:	6442                	ld	s0,16(sp)
    80000d20:	64a2                	ld	s1,8(sp)
    80000d22:	6105                	addi	sp,sp,32
    80000d24:	8082                	ret
    panic("release");
    80000d26:	00007517          	auipc	a0,0x7
    80000d2a:	39a50513          	addi	a0,a0,922 # 800080c0 <digits+0x58>
    80000d2e:	00000097          	auipc	ra,0x0
    80000d32:	89e080e7          	jalr	-1890(ra) # 800005cc <panic>

0000000080000d36 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000d36:	1141                	addi	sp,sp,-16
    80000d38:	e422                	sd	s0,8(sp)
    80000d3a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000d3c:	ca19                	beqz	a2,80000d52 <memset+0x1c>
    80000d3e:	87aa                	mv	a5,a0
    80000d40:	1602                	slli	a2,a2,0x20
    80000d42:	9201                	srli	a2,a2,0x20
    80000d44:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000d48:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000d4c:	0785                	addi	a5,a5,1
    80000d4e:	fee79de3          	bne	a5,a4,80000d48 <memset+0x12>
  }
  return dst;
}
    80000d52:	6422                	ld	s0,8(sp)
    80000d54:	0141                	addi	sp,sp,16
    80000d56:	8082                	ret

0000000080000d58 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d58:	1141                	addi	sp,sp,-16
    80000d5a:	e422                	sd	s0,8(sp)
    80000d5c:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d5e:	ca05                	beqz	a2,80000d8e <memcmp+0x36>
    80000d60:	fff6069b          	addiw	a3,a2,-1
    80000d64:	1682                	slli	a3,a3,0x20
    80000d66:	9281                	srli	a3,a3,0x20
    80000d68:	0685                	addi	a3,a3,1
    80000d6a:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d6c:	00054783          	lbu	a5,0(a0)
    80000d70:	0005c703          	lbu	a4,0(a1)
    80000d74:	00e79863          	bne	a5,a4,80000d84 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d78:	0505                	addi	a0,a0,1
    80000d7a:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d7c:	fed518e3          	bne	a0,a3,80000d6c <memcmp+0x14>
  }

  return 0;
    80000d80:	4501                	li	a0,0
    80000d82:	a019                	j	80000d88 <memcmp+0x30>
      return *s1 - *s2;
    80000d84:	40e7853b          	subw	a0,a5,a4
}
    80000d88:	6422                	ld	s0,8(sp)
    80000d8a:	0141                	addi	sp,sp,16
    80000d8c:	8082                	ret
  return 0;
    80000d8e:	4501                	li	a0,0
    80000d90:	bfe5                	j	80000d88 <memcmp+0x30>

0000000080000d92 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d92:	1141                	addi	sp,sp,-16
    80000d94:	e422                	sd	s0,8(sp)
    80000d96:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d98:	02a5e563          	bltu	a1,a0,80000dc2 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d9c:	fff6069b          	addiw	a3,a2,-1
    80000da0:	ce11                	beqz	a2,80000dbc <memmove+0x2a>
    80000da2:	1682                	slli	a3,a3,0x20
    80000da4:	9281                	srli	a3,a3,0x20
    80000da6:	0685                	addi	a3,a3,1
    80000da8:	96ae                	add	a3,a3,a1
    80000daa:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000dac:	0585                	addi	a1,a1,1
    80000dae:	0785                	addi	a5,a5,1
    80000db0:	fff5c703          	lbu	a4,-1(a1)
    80000db4:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000db8:	fed59ae3          	bne	a1,a3,80000dac <memmove+0x1a>

  return dst;
}
    80000dbc:	6422                	ld	s0,8(sp)
    80000dbe:	0141                	addi	sp,sp,16
    80000dc0:	8082                	ret
  if(s < d && s + n > d){
    80000dc2:	02061713          	slli	a4,a2,0x20
    80000dc6:	9301                	srli	a4,a4,0x20
    80000dc8:	00e587b3          	add	a5,a1,a4
    80000dcc:	fcf578e3          	bgeu	a0,a5,80000d9c <memmove+0xa>
    d += n;
    80000dd0:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000dd2:	fff6069b          	addiw	a3,a2,-1
    80000dd6:	d27d                	beqz	a2,80000dbc <memmove+0x2a>
    80000dd8:	02069613          	slli	a2,a3,0x20
    80000ddc:	9201                	srli	a2,a2,0x20
    80000dde:	fff64613          	not	a2,a2
    80000de2:	963e                	add	a2,a2,a5
      *--d = *--s;
    80000de4:	17fd                	addi	a5,a5,-1
    80000de6:	177d                	addi	a4,a4,-1
    80000de8:	0007c683          	lbu	a3,0(a5)
    80000dec:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000df0:	fef61ae3          	bne	a2,a5,80000de4 <memmove+0x52>
    80000df4:	b7e1                	j	80000dbc <memmove+0x2a>

0000000080000df6 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000df6:	1141                	addi	sp,sp,-16
    80000df8:	e406                	sd	ra,8(sp)
    80000dfa:	e022                	sd	s0,0(sp)
    80000dfc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000dfe:	00000097          	auipc	ra,0x0
    80000e02:	f94080e7          	jalr	-108(ra) # 80000d92 <memmove>
}
    80000e06:	60a2                	ld	ra,8(sp)
    80000e08:	6402                	ld	s0,0(sp)
    80000e0a:	0141                	addi	sp,sp,16
    80000e0c:	8082                	ret

0000000080000e0e <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000e0e:	1141                	addi	sp,sp,-16
    80000e10:	e422                	sd	s0,8(sp)
    80000e12:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000e14:	ce11                	beqz	a2,80000e30 <strncmp+0x22>
    80000e16:	00054783          	lbu	a5,0(a0)
    80000e1a:	cf89                	beqz	a5,80000e34 <strncmp+0x26>
    80000e1c:	0005c703          	lbu	a4,0(a1)
    80000e20:	00f71a63          	bne	a4,a5,80000e34 <strncmp+0x26>
    n--, p++, q++;
    80000e24:	367d                	addiw	a2,a2,-1
    80000e26:	0505                	addi	a0,a0,1
    80000e28:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000e2a:	f675                	bnez	a2,80000e16 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000e2c:	4501                	li	a0,0
    80000e2e:	a809                	j	80000e40 <strncmp+0x32>
    80000e30:	4501                	li	a0,0
    80000e32:	a039                	j	80000e40 <strncmp+0x32>
  if(n == 0)
    80000e34:	ca09                	beqz	a2,80000e46 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000e36:	00054503          	lbu	a0,0(a0)
    80000e3a:	0005c783          	lbu	a5,0(a1)
    80000e3e:	9d1d                	subw	a0,a0,a5
}
    80000e40:	6422                	ld	s0,8(sp)
    80000e42:	0141                	addi	sp,sp,16
    80000e44:	8082                	ret
    return 0;
    80000e46:	4501                	li	a0,0
    80000e48:	bfe5                	j	80000e40 <strncmp+0x32>

0000000080000e4a <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e4a:	1141                	addi	sp,sp,-16
    80000e4c:	e422                	sd	s0,8(sp)
    80000e4e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e50:	872a                	mv	a4,a0
    80000e52:	8832                	mv	a6,a2
    80000e54:	367d                	addiw	a2,a2,-1
    80000e56:	01005963          	blez	a6,80000e68 <strncpy+0x1e>
    80000e5a:	0705                	addi	a4,a4,1
    80000e5c:	0005c783          	lbu	a5,0(a1)
    80000e60:	fef70fa3          	sb	a5,-1(a4)
    80000e64:	0585                	addi	a1,a1,1
    80000e66:	f7f5                	bnez	a5,80000e52 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000e68:	86ba                	mv	a3,a4
    80000e6a:	00c05c63          	blez	a2,80000e82 <strncpy+0x38>
    *s++ = 0;
    80000e6e:	0685                	addi	a3,a3,1
    80000e70:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000e74:	fff6c793          	not	a5,a3
    80000e78:	9fb9                	addw	a5,a5,a4
    80000e7a:	010787bb          	addw	a5,a5,a6
    80000e7e:	fef048e3          	bgtz	a5,80000e6e <strncpy+0x24>
  return os;
}
    80000e82:	6422                	ld	s0,8(sp)
    80000e84:	0141                	addi	sp,sp,16
    80000e86:	8082                	ret

0000000080000e88 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e88:	1141                	addi	sp,sp,-16
    80000e8a:	e422                	sd	s0,8(sp)
    80000e8c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e8e:	02c05363          	blez	a2,80000eb4 <safestrcpy+0x2c>
    80000e92:	fff6069b          	addiw	a3,a2,-1
    80000e96:	1682                	slli	a3,a3,0x20
    80000e98:	9281                	srli	a3,a3,0x20
    80000e9a:	96ae                	add	a3,a3,a1
    80000e9c:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e9e:	00d58963          	beq	a1,a3,80000eb0 <safestrcpy+0x28>
    80000ea2:	0585                	addi	a1,a1,1
    80000ea4:	0785                	addi	a5,a5,1
    80000ea6:	fff5c703          	lbu	a4,-1(a1)
    80000eaa:	fee78fa3          	sb	a4,-1(a5)
    80000eae:	fb65                	bnez	a4,80000e9e <safestrcpy+0x16>
    ;
  *s = 0;
    80000eb0:	00078023          	sb	zero,0(a5)
  return os;
}
    80000eb4:	6422                	ld	s0,8(sp)
    80000eb6:	0141                	addi	sp,sp,16
    80000eb8:	8082                	ret

0000000080000eba <strlen>:

int
strlen(const char *s)
{
    80000eba:	1141                	addi	sp,sp,-16
    80000ebc:	e422                	sd	s0,8(sp)
    80000ebe:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000ec0:	00054783          	lbu	a5,0(a0)
    80000ec4:	cf91                	beqz	a5,80000ee0 <strlen+0x26>
    80000ec6:	0505                	addi	a0,a0,1
    80000ec8:	87aa                	mv	a5,a0
    80000eca:	4685                	li	a3,1
    80000ecc:	9e89                	subw	a3,a3,a0
    80000ece:	00f6853b          	addw	a0,a3,a5
    80000ed2:	0785                	addi	a5,a5,1
    80000ed4:	fff7c703          	lbu	a4,-1(a5)
    80000ed8:	fb7d                	bnez	a4,80000ece <strlen+0x14>
    ;
  return n;
}
    80000eda:	6422                	ld	s0,8(sp)
    80000edc:	0141                	addi	sp,sp,16
    80000ede:	8082                	ret
  for(n = 0; s[n]; n++)
    80000ee0:	4501                	li	a0,0
    80000ee2:	bfe5                	j	80000eda <strlen+0x20>

0000000080000ee4 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000ee4:	1141                	addi	sp,sp,-16
    80000ee6:	e406                	sd	ra,8(sp)
    80000ee8:	e022                	sd	s0,0(sp)
    80000eea:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000eec:	00001097          	auipc	ra,0x1
    80000ef0:	d54080e7          	jalr	-684(ra) # 80001c40 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000ef4:	00008717          	auipc	a4,0x8
    80000ef8:	12470713          	addi	a4,a4,292 # 80009018 <started>
  if(cpuid() == 0){
    80000efc:	c139                	beqz	a0,80000f42 <main+0x5e>
    while(started == 0)
    80000efe:	431c                	lw	a5,0(a4)
    80000f00:	2781                	sext.w	a5,a5
    80000f02:	dff5                	beqz	a5,80000efe <main+0x1a>
      ;
    __sync_synchronize();
    80000f04:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000f08:	00001097          	auipc	ra,0x1
    80000f0c:	d38080e7          	jalr	-712(ra) # 80001c40 <cpuid>
    80000f10:	85aa                	mv	a1,a0
    80000f12:	00007517          	auipc	a0,0x7
    80000f16:	1ce50513          	addi	a0,a0,462 # 800080e0 <digits+0x78>
    80000f1a:	fffff097          	auipc	ra,0xfffff
    80000f1e:	704080e7          	jalr	1796(ra) # 8000061e <printf>
    kvminithart();    // turn on paging
    80000f22:	00000097          	auipc	ra,0x0
    80000f26:	0d8080e7          	jalr	216(ra) # 80000ffa <kvminithart>
    trapinithart();   // install kernel trap vector
    80000f2a:	00002097          	auipc	ra,0x2
    80000f2e:	b42080e7          	jalr	-1214(ra) # 80002a6c <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f32:	00005097          	auipc	ra,0x5
    80000f36:	15e080e7          	jalr	350(ra) # 80006090 <plicinithart>
  }

  scheduler();        
    80000f3a:	00001097          	auipc	ra,0x1
    80000f3e:	3a0080e7          	jalr	928(ra) # 800022da <scheduler>
    consoleinit();
    80000f42:	fffff097          	auipc	ra,0xfffff
    80000f46:	4fa080e7          	jalr	1274(ra) # 8000043c <consoleinit>
    printfinit();
    80000f4a:	fffff097          	auipc	ra,0xfffff
    80000f4e:	5e0080e7          	jalr	1504(ra) # 8000052a <printfinit>
    printf("\n");
    80000f52:	00007517          	auipc	a0,0x7
    80000f56:	19e50513          	addi	a0,a0,414 # 800080f0 <digits+0x88>
    80000f5a:	fffff097          	auipc	ra,0xfffff
    80000f5e:	6c4080e7          	jalr	1732(ra) # 8000061e <printf>
    printf("xv6 kernel is booting\n");
    80000f62:	00007517          	auipc	a0,0x7
    80000f66:	16650513          	addi	a0,a0,358 # 800080c8 <digits+0x60>
    80000f6a:	fffff097          	auipc	ra,0xfffff
    80000f6e:	6b4080e7          	jalr	1716(ra) # 8000061e <printf>
    printf("\n");
    80000f72:	00007517          	auipc	a0,0x7
    80000f76:	17e50513          	addi	a0,a0,382 # 800080f0 <digits+0x88>
    80000f7a:	fffff097          	auipc	ra,0xfffff
    80000f7e:	6a4080e7          	jalr	1700(ra) # 8000061e <printf>
    kinit();         // physical page allocator
    80000f82:	00000097          	auipc	ra,0x0
    80000f86:	b8c080e7          	jalr	-1140(ra) # 80000b0e <kinit>
    kvminit();       // create kernel page table
    80000f8a:	00000097          	auipc	ra,0x0
    80000f8e:	306080e7          	jalr	774(ra) # 80001290 <kvminit>
    kvminithart();   // turn on paging
    80000f92:	00000097          	auipc	ra,0x0
    80000f96:	068080e7          	jalr	104(ra) # 80000ffa <kvminithart>
    procinit();      // process table
    80000f9a:	00001097          	auipc	ra,0x1
    80000f9e:	bf6080e7          	jalr	-1034(ra) # 80001b90 <procinit>
    trapinit();      // trap vectors
    80000fa2:	00002097          	auipc	ra,0x2
    80000fa6:	aa2080e7          	jalr	-1374(ra) # 80002a44 <trapinit>
    trapinithart();  // install kernel trap vector
    80000faa:	00002097          	auipc	ra,0x2
    80000fae:	ac2080e7          	jalr	-1342(ra) # 80002a6c <trapinithart>
    plicinit();      // set up interrupt controller
    80000fb2:	00005097          	auipc	ra,0x5
    80000fb6:	0c8080e7          	jalr	200(ra) # 8000607a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000fba:	00005097          	auipc	ra,0x5
    80000fbe:	0d6080e7          	jalr	214(ra) # 80006090 <plicinithart>
    binit();         // buffer cache
    80000fc2:	00002097          	auipc	ra,0x2
    80000fc6:	26a080e7          	jalr	618(ra) # 8000322c <binit>
    iinit();         // inode cache
    80000fca:	00003097          	auipc	ra,0x3
    80000fce:	8fa080e7          	jalr	-1798(ra) # 800038c4 <iinit>
    fileinit();      // file table
    80000fd2:	00004097          	auipc	ra,0x4
    80000fd6:	8a4080e7          	jalr	-1884(ra) # 80004876 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000fda:	00005097          	auipc	ra,0x5
    80000fde:	1d8080e7          	jalr	472(ra) # 800061b2 <virtio_disk_init>
    userinit();      // first user process
    80000fe2:	00001097          	auipc	ra,0x1
    80000fe6:	00a080e7          	jalr	10(ra) # 80001fec <userinit>
    __sync_synchronize();
    80000fea:	0ff0000f          	fence
    started = 1;
    80000fee:	4785                	li	a5,1
    80000ff0:	00008717          	auipc	a4,0x8
    80000ff4:	02f72423          	sw	a5,40(a4) # 80009018 <started>
    80000ff8:	b789                	j	80000f3a <main+0x56>

0000000080000ffa <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000ffa:	1141                	addi	sp,sp,-16
    80000ffc:	e422                	sd	s0,8(sp)
    80000ffe:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80001000:	00008797          	auipc	a5,0x8
    80001004:	0207b783          	ld	a5,32(a5) # 80009020 <kernel_pagetable>
    80001008:	83b1                	srli	a5,a5,0xc
    8000100a:	577d                	li	a4,-1
    8000100c:	177e                	slli	a4,a4,0x3f
    8000100e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r"(x));
    80001010:	18079073          	csrw	satp,a5
}

// flush the TLB.
static inline void sfence_vma() {
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80001014:	12000073          	sfence.vma
  sfence_vma();
}
    80001018:	6422                	ld	s0,8(sp)
    8000101a:	0141                	addi	sp,sp,16
    8000101c:	8082                	ret

000000008000101e <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000101e:	7139                	addi	sp,sp,-64
    80001020:	fc06                	sd	ra,56(sp)
    80001022:	f822                	sd	s0,48(sp)
    80001024:	f426                	sd	s1,40(sp)
    80001026:	f04a                	sd	s2,32(sp)
    80001028:	ec4e                	sd	s3,24(sp)
    8000102a:	e852                	sd	s4,16(sp)
    8000102c:	e456                	sd	s5,8(sp)
    8000102e:	e05a                	sd	s6,0(sp)
    80001030:	0080                	addi	s0,sp,64
    80001032:	84aa                	mv	s1,a0
    80001034:	89ae                	mv	s3,a1
    80001036:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80001038:	57fd                	li	a5,-1
    8000103a:	83e9                	srli	a5,a5,0x1a
    8000103c:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000103e:	4b31                	li	s6,12
  if(va >= MAXVA)
    80001040:	04b7f263          	bgeu	a5,a1,80001084 <walk+0x66>
    panic("walk");
    80001044:	00007517          	auipc	a0,0x7
    80001048:	0b450513          	addi	a0,a0,180 # 800080f8 <digits+0x90>
    8000104c:	fffff097          	auipc	ra,0xfffff
    80001050:	580080e7          	jalr	1408(ra) # 800005cc <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80001054:	060a8663          	beqz	s5,800010c0 <walk+0xa2>
    80001058:	00000097          	auipc	ra,0x0
    8000105c:	af2080e7          	jalr	-1294(ra) # 80000b4a <kalloc>
    80001060:	84aa                	mv	s1,a0
    80001062:	c529                	beqz	a0,800010ac <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80001064:	6605                	lui	a2,0x1
    80001066:	4581                	li	a1,0
    80001068:	00000097          	auipc	ra,0x0
    8000106c:	cce080e7          	jalr	-818(ra) # 80000d36 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001070:	00c4d793          	srli	a5,s1,0xc
    80001074:	07aa                	slli	a5,a5,0xa
    80001076:	0017e793          	ori	a5,a5,1
    8000107a:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    8000107e:	3a5d                	addiw	s4,s4,-9
    80001080:	036a0063          	beq	s4,s6,800010a0 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80001084:	0149d933          	srl	s2,s3,s4
    80001088:	1ff97913          	andi	s2,s2,511
    8000108c:	090e                	slli	s2,s2,0x3
    8000108e:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001090:	00093483          	ld	s1,0(s2)
    80001094:	0014f793          	andi	a5,s1,1
    80001098:	dfd5                	beqz	a5,80001054 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000109a:	80a9                	srli	s1,s1,0xa
    8000109c:	04b2                	slli	s1,s1,0xc
    8000109e:	b7c5                	j	8000107e <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800010a0:	00c9d513          	srli	a0,s3,0xc
    800010a4:	1ff57513          	andi	a0,a0,511
    800010a8:	050e                	slli	a0,a0,0x3
    800010aa:	9526                	add	a0,a0,s1
}
    800010ac:	70e2                	ld	ra,56(sp)
    800010ae:	7442                	ld	s0,48(sp)
    800010b0:	74a2                	ld	s1,40(sp)
    800010b2:	7902                	ld	s2,32(sp)
    800010b4:	69e2                	ld	s3,24(sp)
    800010b6:	6a42                	ld	s4,16(sp)
    800010b8:	6aa2                	ld	s5,8(sp)
    800010ba:	6b02                	ld	s6,0(sp)
    800010bc:	6121                	addi	sp,sp,64
    800010be:	8082                	ret
        return 0;
    800010c0:	4501                	li	a0,0
    800010c2:	b7ed                	j	800010ac <walk+0x8e>

00000000800010c4 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800010c4:	57fd                	li	a5,-1
    800010c6:	83e9                	srli	a5,a5,0x1a
    800010c8:	00b7f463          	bgeu	a5,a1,800010d0 <walkaddr+0xc>
    return 0;
    800010cc:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800010ce:	8082                	ret
{
    800010d0:	1141                	addi	sp,sp,-16
    800010d2:	e406                	sd	ra,8(sp)
    800010d4:	e022                	sd	s0,0(sp)
    800010d6:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800010d8:	4601                	li	a2,0
    800010da:	00000097          	auipc	ra,0x0
    800010de:	f44080e7          	jalr	-188(ra) # 8000101e <walk>
  if(pte == 0)
    800010e2:	c105                	beqz	a0,80001102 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800010e4:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800010e6:	0117f693          	andi	a3,a5,17
    800010ea:	4745                	li	a4,17
    return 0;
    800010ec:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800010ee:	00e68663          	beq	a3,a4,800010fa <walkaddr+0x36>
}
    800010f2:	60a2                	ld	ra,8(sp)
    800010f4:	6402                	ld	s0,0(sp)
    800010f6:	0141                	addi	sp,sp,16
    800010f8:	8082                	ret
  pa = PTE2PA(*pte);
    800010fa:	00a7d513          	srli	a0,a5,0xa
    800010fe:	0532                	slli	a0,a0,0xc
  return pa;
    80001100:	bfcd                	j	800010f2 <walkaddr+0x2e>
    return 0;
    80001102:	4501                	li	a0,0
    80001104:	b7fd                	j	800010f2 <walkaddr+0x2e>

0000000080001106 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001106:	715d                	addi	sp,sp,-80
    80001108:	e486                	sd	ra,72(sp)
    8000110a:	e0a2                	sd	s0,64(sp)
    8000110c:	fc26                	sd	s1,56(sp)
    8000110e:	f84a                	sd	s2,48(sp)
    80001110:	f44e                	sd	s3,40(sp)
    80001112:	f052                	sd	s4,32(sp)
    80001114:	ec56                	sd	s5,24(sp)
    80001116:	e85a                	sd	s6,16(sp)
    80001118:	e45e                	sd	s7,8(sp)
    8000111a:	0880                	addi	s0,sp,80
    8000111c:	8aaa                	mv	s5,a0
    8000111e:	8b3a                	mv	s6,a4
  uint64 a, last;
  pte_t *pte;

  a = PGROUNDDOWN(va);
    80001120:	777d                	lui	a4,0xfffff
    80001122:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80001126:	167d                	addi	a2,a2,-1
    80001128:	00b609b3          	add	s3,a2,a1
    8000112c:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80001130:	893e                	mv	s2,a5
    80001132:	40f68a33          	sub	s4,a3,a5
    *pte = PA2PTE(pa) | perm | PTE_V;
    // if (a == va)
    //   printf("pte in map page %p\n",pte);
    if(a == last)
      break;
    a += PGSIZE;
    80001136:	6b85                	lui	s7,0x1
    80001138:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000113c:	4605                	li	a2,1
    8000113e:	85ca                	mv	a1,s2
    80001140:	8556                	mv	a0,s5
    80001142:	00000097          	auipc	ra,0x0
    80001146:	edc080e7          	jalr	-292(ra) # 8000101e <walk>
    8000114a:	c51d                	beqz	a0,80001178 <mappages+0x72>
    if(*pte & PTE_V)
    8000114c:	611c                	ld	a5,0(a0)
    8000114e:	8b85                	andi	a5,a5,1
    80001150:	ef81                	bnez	a5,80001168 <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001152:	80b1                	srli	s1,s1,0xc
    80001154:	04aa                	slli	s1,s1,0xa
    80001156:	0164e4b3          	or	s1,s1,s6
    8000115a:	0014e493          	ori	s1,s1,1
    8000115e:	e104                	sd	s1,0(a0)
    if(a == last)
    80001160:	03390863          	beq	s2,s3,80001190 <mappages+0x8a>
    a += PGSIZE;
    80001164:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001166:	bfc9                	j	80001138 <mappages+0x32>
      panic("remap");
    80001168:	00007517          	auipc	a0,0x7
    8000116c:	f9850513          	addi	a0,a0,-104 # 80008100 <digits+0x98>
    80001170:	fffff097          	auipc	ra,0xfffff
    80001174:	45c080e7          	jalr	1116(ra) # 800005cc <panic>
      return -1;
    80001178:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000117a:	60a6                	ld	ra,72(sp)
    8000117c:	6406                	ld	s0,64(sp)
    8000117e:	74e2                	ld	s1,56(sp)
    80001180:	7942                	ld	s2,48(sp)
    80001182:	79a2                	ld	s3,40(sp)
    80001184:	7a02                	ld	s4,32(sp)
    80001186:	6ae2                	ld	s5,24(sp)
    80001188:	6b42                	ld	s6,16(sp)
    8000118a:	6ba2                	ld	s7,8(sp)
    8000118c:	6161                	addi	sp,sp,80
    8000118e:	8082                	ret
  return 0;
    80001190:	4501                	li	a0,0
    80001192:	b7e5                	j	8000117a <mappages+0x74>

0000000080001194 <kvmmap>:
{
    80001194:	1141                	addi	sp,sp,-16
    80001196:	e406                	sd	ra,8(sp)
    80001198:	e022                	sd	s0,0(sp)
    8000119a:	0800                	addi	s0,sp,16
    8000119c:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000119e:	86b2                	mv	a3,a2
    800011a0:	863e                	mv	a2,a5
    800011a2:	00000097          	auipc	ra,0x0
    800011a6:	f64080e7          	jalr	-156(ra) # 80001106 <mappages>
    800011aa:	e509                	bnez	a0,800011b4 <kvmmap+0x20>
}
    800011ac:	60a2                	ld	ra,8(sp)
    800011ae:	6402                	ld	s0,0(sp)
    800011b0:	0141                	addi	sp,sp,16
    800011b2:	8082                	ret
    panic("kvmmap");
    800011b4:	00007517          	auipc	a0,0x7
    800011b8:	f5450513          	addi	a0,a0,-172 # 80008108 <digits+0xa0>
    800011bc:	fffff097          	auipc	ra,0xfffff
    800011c0:	410080e7          	jalr	1040(ra) # 800005cc <panic>

00000000800011c4 <kvmmake>:
{
    800011c4:	1101                	addi	sp,sp,-32
    800011c6:	ec06                	sd	ra,24(sp)
    800011c8:	e822                	sd	s0,16(sp)
    800011ca:	e426                	sd	s1,8(sp)
    800011cc:	e04a                	sd	s2,0(sp)
    800011ce:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800011d0:	00000097          	auipc	ra,0x0
    800011d4:	97a080e7          	jalr	-1670(ra) # 80000b4a <kalloc>
    800011d8:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800011da:	6605                	lui	a2,0x1
    800011dc:	4581                	li	a1,0
    800011de:	00000097          	auipc	ra,0x0
    800011e2:	b58080e7          	jalr	-1192(ra) # 80000d36 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800011e6:	4719                	li	a4,6
    800011e8:	6685                	lui	a3,0x1
    800011ea:	10000637          	lui	a2,0x10000
    800011ee:	100005b7          	lui	a1,0x10000
    800011f2:	8526                	mv	a0,s1
    800011f4:	00000097          	auipc	ra,0x0
    800011f8:	fa0080e7          	jalr	-96(ra) # 80001194 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800011fc:	4719                	li	a4,6
    800011fe:	6685                	lui	a3,0x1
    80001200:	10001637          	lui	a2,0x10001
    80001204:	100015b7          	lui	a1,0x10001
    80001208:	8526                	mv	a0,s1
    8000120a:	00000097          	auipc	ra,0x0
    8000120e:	f8a080e7          	jalr	-118(ra) # 80001194 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001212:	4719                	li	a4,6
    80001214:	004006b7          	lui	a3,0x400
    80001218:	0c000637          	lui	a2,0xc000
    8000121c:	0c0005b7          	lui	a1,0xc000
    80001220:	8526                	mv	a0,s1
    80001222:	00000097          	auipc	ra,0x0
    80001226:	f72080e7          	jalr	-142(ra) # 80001194 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000122a:	00007917          	auipc	s2,0x7
    8000122e:	dd690913          	addi	s2,s2,-554 # 80008000 <etext>
    80001232:	4729                	li	a4,10
    80001234:	80007697          	auipc	a3,0x80007
    80001238:	dcc68693          	addi	a3,a3,-564 # 8000 <_entry-0x7fff8000>
    8000123c:	4605                	li	a2,1
    8000123e:	067e                	slli	a2,a2,0x1f
    80001240:	85b2                	mv	a1,a2
    80001242:	8526                	mv	a0,s1
    80001244:	00000097          	auipc	ra,0x0
    80001248:	f50080e7          	jalr	-176(ra) # 80001194 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000124c:	4719                	li	a4,6
    8000124e:	46c5                	li	a3,17
    80001250:	06ee                	slli	a3,a3,0x1b
    80001252:	412686b3          	sub	a3,a3,s2
    80001256:	864a                	mv	a2,s2
    80001258:	85ca                	mv	a1,s2
    8000125a:	8526                	mv	a0,s1
    8000125c:	00000097          	auipc	ra,0x0
    80001260:	f38080e7          	jalr	-200(ra) # 80001194 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001264:	4729                	li	a4,10
    80001266:	6685                	lui	a3,0x1
    80001268:	00006617          	auipc	a2,0x6
    8000126c:	d9860613          	addi	a2,a2,-616 # 80007000 <_trampoline>
    80001270:	040005b7          	lui	a1,0x4000
    80001274:	15fd                	addi	a1,a1,-1
    80001276:	05b2                	slli	a1,a1,0xc
    80001278:	8526                	mv	a0,s1
    8000127a:	00000097          	auipc	ra,0x0
    8000127e:	f1a080e7          	jalr	-230(ra) # 80001194 <kvmmap>
}
    80001282:	8526                	mv	a0,s1
    80001284:	60e2                	ld	ra,24(sp)
    80001286:	6442                	ld	s0,16(sp)
    80001288:	64a2                	ld	s1,8(sp)
    8000128a:	6902                	ld	s2,0(sp)
    8000128c:	6105                	addi	sp,sp,32
    8000128e:	8082                	ret

0000000080001290 <kvminit>:
{
    80001290:	1141                	addi	sp,sp,-16
    80001292:	e406                	sd	ra,8(sp)
    80001294:	e022                	sd	s0,0(sp)
    80001296:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80001298:	00000097          	auipc	ra,0x0
    8000129c:	f2c080e7          	jalr	-212(ra) # 800011c4 <kvmmake>
    800012a0:	00008797          	auipc	a5,0x8
    800012a4:	d8a7b023          	sd	a0,-640(a5) # 80009020 <kernel_pagetable>
}
    800012a8:	60a2                	ld	ra,8(sp)
    800012aa:	6402                	ld	s0,0(sp)
    800012ac:	0141                	addi	sp,sp,16
    800012ae:	8082                	ret

00000000800012b0 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800012b0:	715d                	addi	sp,sp,-80
    800012b2:	e486                	sd	ra,72(sp)
    800012b4:	e0a2                	sd	s0,64(sp)
    800012b6:	fc26                	sd	s1,56(sp)
    800012b8:	f84a                	sd	s2,48(sp)
    800012ba:	f44e                	sd	s3,40(sp)
    800012bc:	f052                	sd	s4,32(sp)
    800012be:	ec56                	sd	s5,24(sp)
    800012c0:	e85a                	sd	s6,16(sp)
    800012c2:	e45e                	sd	s7,8(sp)
    800012c4:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800012c6:	03459793          	slli	a5,a1,0x34
    800012ca:	e795                	bnez	a5,800012f6 <uvmunmap+0x46>
    800012cc:	8a2a                	mv	s4,a0
    800012ce:	892e                	mv	s2,a1
    800012d0:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012d2:	0632                	slli	a2,a2,0xc
    800012d4:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800012d8:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012da:	6b05                	lui	s6,0x1
    800012dc:	0735e263          	bltu	a1,s3,80001340 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    800012e0:	60a6                	ld	ra,72(sp)
    800012e2:	6406                	ld	s0,64(sp)
    800012e4:	74e2                	ld	s1,56(sp)
    800012e6:	7942                	ld	s2,48(sp)
    800012e8:	79a2                	ld	s3,40(sp)
    800012ea:	7a02                	ld	s4,32(sp)
    800012ec:	6ae2                	ld	s5,24(sp)
    800012ee:	6b42                	ld	s6,16(sp)
    800012f0:	6ba2                	ld	s7,8(sp)
    800012f2:	6161                	addi	sp,sp,80
    800012f4:	8082                	ret
    panic("uvmunmap: not aligned");
    800012f6:	00007517          	auipc	a0,0x7
    800012fa:	e1a50513          	addi	a0,a0,-486 # 80008110 <digits+0xa8>
    800012fe:	fffff097          	auipc	ra,0xfffff
    80001302:	2ce080e7          	jalr	718(ra) # 800005cc <panic>
      panic("uvmunmap: walk");
    80001306:	00007517          	auipc	a0,0x7
    8000130a:	e2250513          	addi	a0,a0,-478 # 80008128 <digits+0xc0>
    8000130e:	fffff097          	auipc	ra,0xfffff
    80001312:	2be080e7          	jalr	702(ra) # 800005cc <panic>
      panic("uvmunmap: not mapped");
    80001316:	00007517          	auipc	a0,0x7
    8000131a:	e2250513          	addi	a0,a0,-478 # 80008138 <digits+0xd0>
    8000131e:	fffff097          	auipc	ra,0xfffff
    80001322:	2ae080e7          	jalr	686(ra) # 800005cc <panic>
      panic("uvmunmap: not a leaf");
    80001326:	00007517          	auipc	a0,0x7
    8000132a:	e2a50513          	addi	a0,a0,-470 # 80008150 <digits+0xe8>
    8000132e:	fffff097          	auipc	ra,0xfffff
    80001332:	29e080e7          	jalr	670(ra) # 800005cc <panic>
    *pte = 0;
    80001336:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000133a:	995a                	add	s2,s2,s6
    8000133c:	fb3972e3          	bgeu	s2,s3,800012e0 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001340:	4601                	li	a2,0
    80001342:	85ca                	mv	a1,s2
    80001344:	8552                	mv	a0,s4
    80001346:	00000097          	auipc	ra,0x0
    8000134a:	cd8080e7          	jalr	-808(ra) # 8000101e <walk>
    8000134e:	84aa                	mv	s1,a0
    80001350:	d95d                	beqz	a0,80001306 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    80001352:	6108                	ld	a0,0(a0)
    80001354:	00157793          	andi	a5,a0,1
    80001358:	dfdd                	beqz	a5,80001316 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000135a:	3ff57793          	andi	a5,a0,1023
    8000135e:	fd7784e3          	beq	a5,s7,80001326 <uvmunmap+0x76>
    if(do_free){
    80001362:	fc0a8ae3          	beqz	s5,80001336 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    80001366:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001368:	0532                	slli	a0,a0,0xc
    8000136a:	fffff097          	auipc	ra,0xfffff
    8000136e:	6e4080e7          	jalr	1764(ra) # 80000a4e <kfree>
    80001372:	b7d1                	j	80001336 <uvmunmap+0x86>

0000000080001374 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001374:	1101                	addi	sp,sp,-32
    80001376:	ec06                	sd	ra,24(sp)
    80001378:	e822                	sd	s0,16(sp)
    8000137a:	e426                	sd	s1,8(sp)
    8000137c:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000137e:	fffff097          	auipc	ra,0xfffff
    80001382:	7cc080e7          	jalr	1996(ra) # 80000b4a <kalloc>
    80001386:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001388:	c519                	beqz	a0,80001396 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000138a:	6605                	lui	a2,0x1
    8000138c:	4581                	li	a1,0
    8000138e:	00000097          	auipc	ra,0x0
    80001392:	9a8080e7          	jalr	-1624(ra) # 80000d36 <memset>
  return pagetable;
}
    80001396:	8526                	mv	a0,s1
    80001398:	60e2                	ld	ra,24(sp)
    8000139a:	6442                	ld	s0,16(sp)
    8000139c:	64a2                	ld	s1,8(sp)
    8000139e:	6105                	addi	sp,sp,32
    800013a0:	8082                	ret

00000000800013a2 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800013a2:	7179                	addi	sp,sp,-48
    800013a4:	f406                	sd	ra,40(sp)
    800013a6:	f022                	sd	s0,32(sp)
    800013a8:	ec26                	sd	s1,24(sp)
    800013aa:	e84a                	sd	s2,16(sp)
    800013ac:	e44e                	sd	s3,8(sp)
    800013ae:	e052                	sd	s4,0(sp)
    800013b0:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800013b2:	6785                	lui	a5,0x1
    800013b4:	04f67863          	bgeu	a2,a5,80001404 <uvminit+0x62>
    800013b8:	8a2a                	mv	s4,a0
    800013ba:	89ae                	mv	s3,a1
    800013bc:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    800013be:	fffff097          	auipc	ra,0xfffff
    800013c2:	78c080e7          	jalr	1932(ra) # 80000b4a <kalloc>
    800013c6:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800013c8:	6605                	lui	a2,0x1
    800013ca:	4581                	li	a1,0
    800013cc:	00000097          	auipc	ra,0x0
    800013d0:	96a080e7          	jalr	-1686(ra) # 80000d36 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800013d4:	4779                	li	a4,30
    800013d6:	86ca                	mv	a3,s2
    800013d8:	6605                	lui	a2,0x1
    800013da:	4581                	li	a1,0
    800013dc:	8552                	mv	a0,s4
    800013de:	00000097          	auipc	ra,0x0
    800013e2:	d28080e7          	jalr	-728(ra) # 80001106 <mappages>
  memmove(mem, src, sz);
    800013e6:	8626                	mv	a2,s1
    800013e8:	85ce                	mv	a1,s3
    800013ea:	854a                	mv	a0,s2
    800013ec:	00000097          	auipc	ra,0x0
    800013f0:	9a6080e7          	jalr	-1626(ra) # 80000d92 <memmove>
}
    800013f4:	70a2                	ld	ra,40(sp)
    800013f6:	7402                	ld	s0,32(sp)
    800013f8:	64e2                	ld	s1,24(sp)
    800013fa:	6942                	ld	s2,16(sp)
    800013fc:	69a2                	ld	s3,8(sp)
    800013fe:	6a02                	ld	s4,0(sp)
    80001400:	6145                	addi	sp,sp,48
    80001402:	8082                	ret
    panic("inituvm: more than a page");
    80001404:	00007517          	auipc	a0,0x7
    80001408:	d6450513          	addi	a0,a0,-668 # 80008168 <digits+0x100>
    8000140c:	fffff097          	auipc	ra,0xfffff
    80001410:	1c0080e7          	jalr	448(ra) # 800005cc <panic>

0000000080001414 <uvmapping>:
  }
  return newsz;
}

// * copy mapping from va to end to another pagetable dst.
int uvmapping(pagetable_t pagetable,pagetable_t dst,u64 ori,u64 end){
    80001414:	7139                	addi	sp,sp,-64
    80001416:	fc06                	sd	ra,56(sp)
    80001418:	f822                	sd	s0,48(sp)
    8000141a:	f426                	sd	s1,40(sp)
    8000141c:	f04a                	sd	s2,32(sp)
    8000141e:	ec4e                	sd	s3,24(sp)
    80001420:	e852                	sd	s4,16(sp)
    80001422:	e456                	sd	s5,8(sp)
    80001424:	e05a                	sd	s6,0(sp)
    80001426:	0080                	addi	s0,sp,64
  ori = PGROUNDUP(ori);
    80001428:	6905                	lui	s2,0x1
    8000142a:	197d                	addi	s2,s2,-1
    8000142c:	964a                	add	a2,a2,s2
    8000142e:	797d                	lui	s2,0xfffff
    80001430:	01267933          	and	s2,a2,s2
  for (u64 cur = ori;cur < end; cur += PGSIZE){
    80001434:	04d97063          	bgeu	s2,a3,80001474 <uvmapping+0x60>
    80001438:	8a2a                	mv	s4,a0
    8000143a:	8aae                	mv	s5,a1
    8000143c:	89b6                	mv	s3,a3
    8000143e:	6b05                	lui	s6,0x1
    pte_t *pte = walk(pagetable,cur,0);
    80001440:	4601                	li	a2,0
    80001442:	85ca                	mv	a1,s2
    80001444:	8552                	mv	a0,s4
    80001446:	00000097          	auipc	ra,0x0
    8000144a:	bd8080e7          	jalr	-1064(ra) # 8000101e <walk>
    8000144e:	84aa                	mv	s1,a0
    if (pte == 0){
    80001450:	cd0d                	beqz	a0,8000148a <uvmapping+0x76>
      panic("mapping should exist!");
    }
    if ((*pte & PTE_V) == 0 ){
    80001452:	611c                	ld	a5,0(a0)
    80001454:	8b85                	andi	a5,a5,1
    80001456:	c3b1                	beqz	a5,8000149a <uvmapping+0x86>
      panic("should exist a valid mapping");
    }
    pte_t *d_pte = walk(dst,cur,1);
    80001458:	4605                	li	a2,1
    8000145a:	85ca                	mv	a1,s2
    8000145c:	8556                	mv	a0,s5
    8000145e:	00000097          	auipc	ra,0x0
    80001462:	bc0080e7          	jalr	-1088(ra) # 8000101e <walk>
    if (d_pte == 0){
    80001466:	c131                	beqz	a0,800014aa <uvmapping+0x96>
      panic("can't allocate an pte");
    }
    *d_pte = *pte & (~PTE_U);
    80001468:	609c                	ld	a5,0(s1)
    8000146a:	9bbd                	andi	a5,a5,-17
    8000146c:	e11c                	sd	a5,0(a0)
  for (u64 cur = ori;cur < end; cur += PGSIZE){
    8000146e:	995a                	add	s2,s2,s6
    80001470:	fd3968e3          	bltu	s2,s3,80001440 <uvmapping+0x2c>
  }
  return 0;
}
    80001474:	4501                	li	a0,0
    80001476:	70e2                	ld	ra,56(sp)
    80001478:	7442                	ld	s0,48(sp)
    8000147a:	74a2                	ld	s1,40(sp)
    8000147c:	7902                	ld	s2,32(sp)
    8000147e:	69e2                	ld	s3,24(sp)
    80001480:	6a42                	ld	s4,16(sp)
    80001482:	6aa2                	ld	s5,8(sp)
    80001484:	6b02                	ld	s6,0(sp)
    80001486:	6121                	addi	sp,sp,64
    80001488:	8082                	ret
      panic("mapping should exist!");
    8000148a:	00007517          	auipc	a0,0x7
    8000148e:	cfe50513          	addi	a0,a0,-770 # 80008188 <digits+0x120>
    80001492:	fffff097          	auipc	ra,0xfffff
    80001496:	13a080e7          	jalr	314(ra) # 800005cc <panic>
      panic("should exist a valid mapping");
    8000149a:	00007517          	auipc	a0,0x7
    8000149e:	d0650513          	addi	a0,a0,-762 # 800081a0 <digits+0x138>
    800014a2:	fffff097          	auipc	ra,0xfffff
    800014a6:	12a080e7          	jalr	298(ra) # 800005cc <panic>
      panic("can't allocate an pte");
    800014aa:	00007517          	auipc	a0,0x7
    800014ae:	d1650513          	addi	a0,a0,-746 # 800081c0 <digits+0x158>
    800014b2:	fffff097          	auipc	ra,0xfffff
    800014b6:	11a080e7          	jalr	282(ra) # 800005cc <panic>

00000000800014ba <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800014ba:	1101                	addi	sp,sp,-32
    800014bc:	ec06                	sd	ra,24(sp)
    800014be:	e822                	sd	s0,16(sp)
    800014c0:	e426                	sd	s1,8(sp)
    800014c2:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800014c4:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800014c6:	00b67d63          	bgeu	a2,a1,800014e0 <uvmdealloc+0x26>
    800014ca:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800014cc:	6785                	lui	a5,0x1
    800014ce:	17fd                	addi	a5,a5,-1
    800014d0:	00f60733          	add	a4,a2,a5
    800014d4:	767d                	lui	a2,0xfffff
    800014d6:	8f71                	and	a4,a4,a2
    800014d8:	97ae                	add	a5,a5,a1
    800014da:	8ff1                	and	a5,a5,a2
    800014dc:	00f76863          	bltu	a4,a5,800014ec <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800014e0:	8526                	mv	a0,s1
    800014e2:	60e2                	ld	ra,24(sp)
    800014e4:	6442                	ld	s0,16(sp)
    800014e6:	64a2                	ld	s1,8(sp)
    800014e8:	6105                	addi	sp,sp,32
    800014ea:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800014ec:	8f99                	sub	a5,a5,a4
    800014ee:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800014f0:	4685                	li	a3,1
    800014f2:	0007861b          	sext.w	a2,a5
    800014f6:	85ba                	mv	a1,a4
    800014f8:	00000097          	auipc	ra,0x0
    800014fc:	db8080e7          	jalr	-584(ra) # 800012b0 <uvmunmap>
    80001500:	b7c5                	j	800014e0 <uvmdealloc+0x26>

0000000080001502 <uvmalloc>:
  if(newsz < oldsz)
    80001502:	0cb66963          	bltu	a2,a1,800015d4 <uvmalloc+0xd2>
{
    80001506:	7139                	addi	sp,sp,-64
    80001508:	fc06                	sd	ra,56(sp)
    8000150a:	f822                	sd	s0,48(sp)
    8000150c:	f426                	sd	s1,40(sp)
    8000150e:	f04a                	sd	s2,32(sp)
    80001510:	ec4e                	sd	s3,24(sp)
    80001512:	e852                	sd	s4,16(sp)
    80001514:	e456                	sd	s5,8(sp)
    80001516:	e05a                	sd	s6,0(sp)
    80001518:	0080                	addi	s0,sp,64
    8000151a:	8aaa                	mv	s5,a0
    8000151c:	8b32                	mv	s6,a2
  if (newsz >= PLIC){
    8000151e:	0c0007b7          	lui	a5,0xc000
    80001522:	06f67163          	bgeu	a2,a5,80001584 <uvmalloc+0x82>
  oldsz = PGROUNDUP(oldsz);
    80001526:	6985                	lui	s3,0x1
    80001528:	19fd                	addi	s3,s3,-1
    8000152a:	95ce                	add	a1,a1,s3
    8000152c:	79fd                	lui	s3,0xfffff
    8000152e:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001532:	0ac9f363          	bgeu	s3,a2,800015d8 <uvmalloc+0xd6>
    80001536:	fff60a13          	addi	s4,a2,-1 # ffffffffffffefff <end+0xffffffff7ffd8fff>
    8000153a:	413a0a33          	sub	s4,s4,s3
    8000153e:	77fd                	lui	a5,0xfffff
    80001540:	00fa7a33          	and	s4,s4,a5
    80001544:	6785                	lui	a5,0x1
    80001546:	97ce                	add	a5,a5,s3
    80001548:	9a3e                	add	s4,s4,a5
    8000154a:	894e                	mv	s2,s3
    mem = kalloc();
    8000154c:	fffff097          	auipc	ra,0xfffff
    80001550:	5fe080e7          	jalr	1534(ra) # 80000b4a <kalloc>
    80001554:	84aa                	mv	s1,a0
    if(mem == 0){
    80001556:	cd1d                	beqz	a0,80001594 <uvmalloc+0x92>
    memset(mem, 0, PGSIZE);
    80001558:	6605                	lui	a2,0x1
    8000155a:	4581                	li	a1,0
    8000155c:	fffff097          	auipc	ra,0xfffff
    80001560:	7da080e7          	jalr	2010(ra) # 80000d36 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80001564:	4779                	li	a4,30
    80001566:	86a6                	mv	a3,s1
    80001568:	6605                	lui	a2,0x1
    8000156a:	85ca                	mv	a1,s2
    8000156c:	8556                	mv	a0,s5
    8000156e:	00000097          	auipc	ra,0x0
    80001572:	b98080e7          	jalr	-1128(ra) # 80001106 <mappages>
    80001576:	e129                	bnez	a0,800015b8 <uvmalloc+0xb6>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001578:	6785                	lui	a5,0x1
    8000157a:	993e                	add	s2,s2,a5
    8000157c:	fd4918e3          	bne	s2,s4,8000154c <uvmalloc+0x4a>
  return newsz;
    80001580:	855a                	mv	a0,s6
    80001582:	a00d                	j	800015a4 <uvmalloc+0xa2>
    panic("user memory overloaded!");
    80001584:	00007517          	auipc	a0,0x7
    80001588:	c5450513          	addi	a0,a0,-940 # 800081d8 <digits+0x170>
    8000158c:	fffff097          	auipc	ra,0xfffff
    80001590:	040080e7          	jalr	64(ra) # 800005cc <panic>
      uvmdealloc(pagetable, a, oldsz);
    80001594:	864e                	mv	a2,s3
    80001596:	85ca                	mv	a1,s2
    80001598:	8556                	mv	a0,s5
    8000159a:	00000097          	auipc	ra,0x0
    8000159e:	f20080e7          	jalr	-224(ra) # 800014ba <uvmdealloc>
      return 0;
    800015a2:	4501                	li	a0,0
}
    800015a4:	70e2                	ld	ra,56(sp)
    800015a6:	7442                	ld	s0,48(sp)
    800015a8:	74a2                	ld	s1,40(sp)
    800015aa:	7902                	ld	s2,32(sp)
    800015ac:	69e2                	ld	s3,24(sp)
    800015ae:	6a42                	ld	s4,16(sp)
    800015b0:	6aa2                	ld	s5,8(sp)
    800015b2:	6b02                	ld	s6,0(sp)
    800015b4:	6121                	addi	sp,sp,64
    800015b6:	8082                	ret
      kfree(mem);
    800015b8:	8526                	mv	a0,s1
    800015ba:	fffff097          	auipc	ra,0xfffff
    800015be:	494080e7          	jalr	1172(ra) # 80000a4e <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800015c2:	864e                	mv	a2,s3
    800015c4:	85ca                	mv	a1,s2
    800015c6:	8556                	mv	a0,s5
    800015c8:	00000097          	auipc	ra,0x0
    800015cc:	ef2080e7          	jalr	-270(ra) # 800014ba <uvmdealloc>
      return 0;
    800015d0:	4501                	li	a0,0
    800015d2:	bfc9                	j	800015a4 <uvmalloc+0xa2>
    return oldsz;
    800015d4:	852e                	mv	a0,a1
}
    800015d6:	8082                	ret
  return newsz;
    800015d8:	8532                	mv	a0,a2
    800015da:	b7e9                	j	800015a4 <uvmalloc+0xa2>

00000000800015dc <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800015dc:	7179                	addi	sp,sp,-48
    800015de:	f406                	sd	ra,40(sp)
    800015e0:	f022                	sd	s0,32(sp)
    800015e2:	ec26                	sd	s1,24(sp)
    800015e4:	e84a                	sd	s2,16(sp)
    800015e6:	e44e                	sd	s3,8(sp)
    800015e8:	e052                	sd	s4,0(sp)
    800015ea:	1800                	addi	s0,sp,48
    800015ec:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800015ee:	84aa                	mv	s1,a0
    800015f0:	6905                	lui	s2,0x1
    800015f2:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800015f4:	4985                	li	s3,1
    800015f6:	a821                	j	8000160e <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800015f8:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800015fa:	0532                	slli	a0,a0,0xc
    800015fc:	00000097          	auipc	ra,0x0
    80001600:	fe0080e7          	jalr	-32(ra) # 800015dc <freewalk>
      pagetable[i] = 0;
    80001604:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001608:	04a1                	addi	s1,s1,8
    8000160a:	03248163          	beq	s1,s2,8000162c <freewalk+0x50>
    pte_t pte = pagetable[i];
    8000160e:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001610:	00f57793          	andi	a5,a0,15
    80001614:	ff3782e3          	beq	a5,s3,800015f8 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001618:	8905                	andi	a0,a0,1
    8000161a:	d57d                	beqz	a0,80001608 <freewalk+0x2c>
      panic("freewalk: leaf");
    8000161c:	00007517          	auipc	a0,0x7
    80001620:	bd450513          	addi	a0,a0,-1068 # 800081f0 <digits+0x188>
    80001624:	fffff097          	auipc	ra,0xfffff
    80001628:	fa8080e7          	jalr	-88(ra) # 800005cc <panic>
    }
  }
  kfree((void*)pagetable);
    8000162c:	8552                	mv	a0,s4
    8000162e:	fffff097          	auipc	ra,0xfffff
    80001632:	420080e7          	jalr	1056(ra) # 80000a4e <kfree>
}
    80001636:	70a2                	ld	ra,40(sp)
    80001638:	7402                	ld	s0,32(sp)
    8000163a:	64e2                	ld	s1,24(sp)
    8000163c:	6942                	ld	s2,16(sp)
    8000163e:	69a2                	ld	s3,8(sp)
    80001640:	6a02                	ld	s4,0(sp)
    80001642:	6145                	addi	sp,sp,48
    80001644:	8082                	ret

0000000080001646 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001646:	1101                	addi	sp,sp,-32
    80001648:	ec06                	sd	ra,24(sp)
    8000164a:	e822                	sd	s0,16(sp)
    8000164c:	e426                	sd	s1,8(sp)
    8000164e:	1000                	addi	s0,sp,32
    80001650:	84aa                	mv	s1,a0
  if(sz > 0)
    80001652:	e999                	bnez	a1,80001668 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001654:	8526                	mv	a0,s1
    80001656:	00000097          	auipc	ra,0x0
    8000165a:	f86080e7          	jalr	-122(ra) # 800015dc <freewalk>
}
    8000165e:	60e2                	ld	ra,24(sp)
    80001660:	6442                	ld	s0,16(sp)
    80001662:	64a2                	ld	s1,8(sp)
    80001664:	6105                	addi	sp,sp,32
    80001666:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001668:	6605                	lui	a2,0x1
    8000166a:	167d                	addi	a2,a2,-1
    8000166c:	962e                	add	a2,a2,a1
    8000166e:	4685                	li	a3,1
    80001670:	8231                	srli	a2,a2,0xc
    80001672:	4581                	li	a1,0
    80001674:	00000097          	auipc	ra,0x0
    80001678:	c3c080e7          	jalr	-964(ra) # 800012b0 <uvmunmap>
    8000167c:	bfe1                	j	80001654 <uvmfree+0xe>

000000008000167e <free_kmapping>:



void  
free_kmapping( struct proc *p)
{
    8000167e:	7179                	addi	sp,sp,-48
    80001680:	f406                	sd	ra,40(sp)
    80001682:	f022                	sd	s0,32(sp)
    80001684:	ec26                	sd	s1,24(sp)
    80001686:	e84a                	sd	s2,16(sp)
    80001688:	e44e                	sd	s3,8(sp)
    8000168a:	1800                	addi	s0,sp,48
    8000168c:	892a                	mv	s2,a0

  pagetable_t k_pagetable = p->k_pagetable;
    8000168e:	7124                	ld	s1,96(a0)
  uvmunmap(k_pagetable,UART0,1,0);
    80001690:	4681                	li	a3,0
    80001692:	4605                	li	a2,1
    80001694:	100005b7          	lui	a1,0x10000
    80001698:	8526                	mv	a0,s1
    8000169a:	00000097          	auipc	ra,0x0
    8000169e:	c16080e7          	jalr	-1002(ra) # 800012b0 <uvmunmap>
  uvmunmap(k_pagetable,VIRTIO0, 1, 0);
    800016a2:	4681                	li	a3,0
    800016a4:	4605                	li	a2,1
    800016a6:	100015b7          	lui	a1,0x10001
    800016aa:	8526                	mv	a0,s1
    800016ac:	00000097          	auipc	ra,0x0
    800016b0:	c04080e7          	jalr	-1020(ra) # 800012b0 <uvmunmap>
  uvmunmap(k_pagetable,PLIC,(0x400000)/PGSIZE,0);
    800016b4:	4681                	li	a3,0
    800016b6:	40000613          	li	a2,1024
    800016ba:	0c0005b7          	lui	a1,0xc000
    800016be:	8526                	mv	a0,s1
    800016c0:	00000097          	auipc	ra,0x0
    800016c4:	bf0080e7          	jalr	-1040(ra) # 800012b0 <uvmunmap>
  uvmunmap(k_pagetable,KERNBASE,((uint64)etext-KERNBASE) / PGSIZE,0);
    800016c8:	00007997          	auipc	s3,0x7
    800016cc:	93898993          	addi	s3,s3,-1736 # 80008000 <etext>
    800016d0:	4681                	li	a3,0
    800016d2:	80007617          	auipc	a2,0x80007
    800016d6:	92e60613          	addi	a2,a2,-1746 # 8000 <_entry-0x7fff8000>
    800016da:	8231                	srli	a2,a2,0xc
    800016dc:	4585                	li	a1,1
    800016de:	05fe                	slli	a1,a1,0x1f
    800016e0:	8526                	mv	a0,s1
    800016e2:	00000097          	auipc	ra,0x0
    800016e6:	bce080e7          	jalr	-1074(ra) # 800012b0 <uvmunmap>
  uvmunmap(k_pagetable,(u64)etext,(PHYSTOP - (u64)etext) / PGSIZE,0);
    800016ea:	4645                	li	a2,17
    800016ec:	066e                	slli	a2,a2,0x1b
    800016ee:	41360633          	sub	a2,a2,s3
    800016f2:	4681                	li	a3,0
    800016f4:	8231                	srli	a2,a2,0xc
    800016f6:	85ce                	mv	a1,s3
    800016f8:	8526                	mv	a0,s1
    800016fa:	00000097          	auipc	ra,0x0
    800016fe:	bb6080e7          	jalr	-1098(ra) # 800012b0 <uvmunmap>
  uvmunmap(k_pagetable,TRAMPOLINE,1,0);
    80001702:	4681                	li	a3,0
    80001704:	4605                	li	a2,1
    80001706:	040005b7          	lui	a1,0x4000
    8000170a:	15fd                	addi	a1,a1,-1
    8000170c:	05b2                	slli	a1,a1,0xc
    8000170e:	8526                	mv	a0,s1
    80001710:	00000097          	auipc	ra,0x0
    80001714:	ba0080e7          	jalr	-1120(ra) # 800012b0 <uvmunmap>

  //  * free physical page for kernel stack
  pte_t *pte =  walk(p->k_pagetable,p->kstack,0);
    80001718:	4601                	li	a2,0
    8000171a:	04893583          	ld	a1,72(s2) # 1048 <_entry-0x7fffefb8>
    8000171e:	06093503          	ld	a0,96(s2)
    80001722:	00000097          	auipc	ra,0x0
    80001726:	8fc080e7          	jalr	-1796(ra) # 8000101e <walk>
  void *s = (void*)PTE2PA(*pte);
    8000172a:	6108                	ld	a0,0(a0)
    8000172c:	8129                	srli	a0,a0,0xa
  kfree(s);
    8000172e:	0532                	slli	a0,a0,0xc
    80001730:	fffff097          	auipc	ra,0xfffff
    80001734:	31e080e7          	jalr	798(ra) # 80000a4e <kfree>
  uvmunmap(k_pagetable,p->kstack,1,0);
    80001738:	4681                	li	a3,0
    8000173a:	4605                	li	a2,1
    8000173c:	04893583          	ld	a1,72(s2)
    80001740:	8526                	mv	a0,s1
    80001742:	00000097          	auipc	ra,0x0
    80001746:	b6e080e7          	jalr	-1170(ra) # 800012b0 <uvmunmap>


}
    8000174a:	70a2                	ld	ra,40(sp)
    8000174c:	7402                	ld	s0,32(sp)
    8000174e:	64e2                	ld	s1,24(sp)
    80001750:	6942                	ld	s2,16(sp)
    80001752:	69a2                	ld	s3,8(sp)
    80001754:	6145                	addi	sp,sp,48
    80001756:	8082                	ret

0000000080001758 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001758:	c679                	beqz	a2,80001826 <uvmcopy+0xce>
{
    8000175a:	715d                	addi	sp,sp,-80
    8000175c:	e486                	sd	ra,72(sp)
    8000175e:	e0a2                	sd	s0,64(sp)
    80001760:	fc26                	sd	s1,56(sp)
    80001762:	f84a                	sd	s2,48(sp)
    80001764:	f44e                	sd	s3,40(sp)
    80001766:	f052                	sd	s4,32(sp)
    80001768:	ec56                	sd	s5,24(sp)
    8000176a:	e85a                	sd	s6,16(sp)
    8000176c:	e45e                	sd	s7,8(sp)
    8000176e:	0880                	addi	s0,sp,80
    80001770:	8b2a                	mv	s6,a0
    80001772:	8aae                	mv	s5,a1
    80001774:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001776:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001778:	4601                	li	a2,0
    8000177a:	85ce                	mv	a1,s3
    8000177c:	855a                	mv	a0,s6
    8000177e:	00000097          	auipc	ra,0x0
    80001782:	8a0080e7          	jalr	-1888(ra) # 8000101e <walk>
    80001786:	c531                	beqz	a0,800017d2 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80001788:	6118                	ld	a4,0(a0)
    8000178a:	00177793          	andi	a5,a4,1
    8000178e:	cbb1                	beqz	a5,800017e2 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001790:	00a75593          	srli	a1,a4,0xa
    80001794:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001798:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    8000179c:	fffff097          	auipc	ra,0xfffff
    800017a0:	3ae080e7          	jalr	942(ra) # 80000b4a <kalloc>
    800017a4:	892a                	mv	s2,a0
    800017a6:	c939                	beqz	a0,800017fc <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800017a8:	6605                	lui	a2,0x1
    800017aa:	85de                	mv	a1,s7
    800017ac:	fffff097          	auipc	ra,0xfffff
    800017b0:	5e6080e7          	jalr	1510(ra) # 80000d92 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800017b4:	8726                	mv	a4,s1
    800017b6:	86ca                	mv	a3,s2
    800017b8:	6605                	lui	a2,0x1
    800017ba:	85ce                	mv	a1,s3
    800017bc:	8556                	mv	a0,s5
    800017be:	00000097          	auipc	ra,0x0
    800017c2:	948080e7          	jalr	-1720(ra) # 80001106 <mappages>
    800017c6:	e515                	bnez	a0,800017f2 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    800017c8:	6785                	lui	a5,0x1
    800017ca:	99be                	add	s3,s3,a5
    800017cc:	fb49e6e3          	bltu	s3,s4,80001778 <uvmcopy+0x20>
    800017d0:	a081                	j	80001810 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    800017d2:	00007517          	auipc	a0,0x7
    800017d6:	a2e50513          	addi	a0,a0,-1490 # 80008200 <digits+0x198>
    800017da:	fffff097          	auipc	ra,0xfffff
    800017de:	df2080e7          	jalr	-526(ra) # 800005cc <panic>
      panic("uvmcopy: page not present");
    800017e2:	00007517          	auipc	a0,0x7
    800017e6:	a3e50513          	addi	a0,a0,-1474 # 80008220 <digits+0x1b8>
    800017ea:	fffff097          	auipc	ra,0xfffff
    800017ee:	de2080e7          	jalr	-542(ra) # 800005cc <panic>
      kfree(mem);
    800017f2:	854a                	mv	a0,s2
    800017f4:	fffff097          	auipc	ra,0xfffff
    800017f8:	25a080e7          	jalr	602(ra) # 80000a4e <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800017fc:	4685                	li	a3,1
    800017fe:	00c9d613          	srli	a2,s3,0xc
    80001802:	4581                	li	a1,0
    80001804:	8556                	mv	a0,s5
    80001806:	00000097          	auipc	ra,0x0
    8000180a:	aaa080e7          	jalr	-1366(ra) # 800012b0 <uvmunmap>
  return -1;
    8000180e:	557d                	li	a0,-1
}
    80001810:	60a6                	ld	ra,72(sp)
    80001812:	6406                	ld	s0,64(sp)
    80001814:	74e2                	ld	s1,56(sp)
    80001816:	7942                	ld	s2,48(sp)
    80001818:	79a2                	ld	s3,40(sp)
    8000181a:	7a02                	ld	s4,32(sp)
    8000181c:	6ae2                	ld	s5,24(sp)
    8000181e:	6b42                	ld	s6,16(sp)
    80001820:	6ba2                	ld	s7,8(sp)
    80001822:	6161                	addi	sp,sp,80
    80001824:	8082                	ret
  return 0;
    80001826:	4501                	li	a0,0
}
    80001828:	8082                	ret

000000008000182a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000182a:	1141                	addi	sp,sp,-16
    8000182c:	e406                	sd	ra,8(sp)
    8000182e:	e022                	sd	s0,0(sp)
    80001830:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001832:	4601                	li	a2,0
    80001834:	fffff097          	auipc	ra,0xfffff
    80001838:	7ea080e7          	jalr	2026(ra) # 8000101e <walk>
  if(pte == 0)
    8000183c:	c901                	beqz	a0,8000184c <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000183e:	611c                	ld	a5,0(a0)
    80001840:	9bbd                	andi	a5,a5,-17
    80001842:	e11c                	sd	a5,0(a0)
}
    80001844:	60a2                	ld	ra,8(sp)
    80001846:	6402                	ld	s0,0(sp)
    80001848:	0141                	addi	sp,sp,16
    8000184a:	8082                	ret
    panic("uvmclear");
    8000184c:	00007517          	auipc	a0,0x7
    80001850:	9f450513          	addi	a0,a0,-1548 # 80008240 <digits+0x1d8>
    80001854:	fffff097          	auipc	ra,0xfffff
    80001858:	d78080e7          	jalr	-648(ra) # 800005cc <panic>

000000008000185c <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000185c:	c6bd                	beqz	a3,800018ca <copyout+0x6e>
{
    8000185e:	715d                	addi	sp,sp,-80
    80001860:	e486                	sd	ra,72(sp)
    80001862:	e0a2                	sd	s0,64(sp)
    80001864:	fc26                	sd	s1,56(sp)
    80001866:	f84a                	sd	s2,48(sp)
    80001868:	f44e                	sd	s3,40(sp)
    8000186a:	f052                	sd	s4,32(sp)
    8000186c:	ec56                	sd	s5,24(sp)
    8000186e:	e85a                	sd	s6,16(sp)
    80001870:	e45e                	sd	s7,8(sp)
    80001872:	e062                	sd	s8,0(sp)
    80001874:	0880                	addi	s0,sp,80
    80001876:	8b2a                	mv	s6,a0
    80001878:	8c2e                	mv	s8,a1
    8000187a:	8a32                	mv	s4,a2
    8000187c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000187e:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001880:	6a85                	lui	s5,0x1
    80001882:	a015                	j	800018a6 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001884:	9562                	add	a0,a0,s8
    80001886:	0004861b          	sext.w	a2,s1
    8000188a:	85d2                	mv	a1,s4
    8000188c:	41250533          	sub	a0,a0,s2
    80001890:	fffff097          	auipc	ra,0xfffff
    80001894:	502080e7          	jalr	1282(ra) # 80000d92 <memmove>

    len -= n;
    80001898:	409989b3          	sub	s3,s3,s1
    src += n;
    8000189c:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    8000189e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800018a2:	02098263          	beqz	s3,800018c6 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    800018a6:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800018aa:	85ca                	mv	a1,s2
    800018ac:	855a                	mv	a0,s6
    800018ae:	00000097          	auipc	ra,0x0
    800018b2:	816080e7          	jalr	-2026(ra) # 800010c4 <walkaddr>
    if(pa0 == 0)
    800018b6:	cd01                	beqz	a0,800018ce <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    800018b8:	418904b3          	sub	s1,s2,s8
    800018bc:	94d6                	add	s1,s1,s5
    if(n > len)
    800018be:	fc99f3e3          	bgeu	s3,s1,80001884 <copyout+0x28>
    800018c2:	84ce                	mv	s1,s3
    800018c4:	b7c1                	j	80001884 <copyout+0x28>
  }
  return 0;
    800018c6:	4501                	li	a0,0
    800018c8:	a021                	j	800018d0 <copyout+0x74>
    800018ca:	4501                	li	a0,0
}
    800018cc:	8082                	ret
      return -1;
    800018ce:	557d                	li	a0,-1
}
    800018d0:	60a6                	ld	ra,72(sp)
    800018d2:	6406                	ld	s0,64(sp)
    800018d4:	74e2                	ld	s1,56(sp)
    800018d6:	7942                	ld	s2,48(sp)
    800018d8:	79a2                	ld	s3,40(sp)
    800018da:	7a02                	ld	s4,32(sp)
    800018dc:	6ae2                	ld	s5,24(sp)
    800018de:	6b42                	ld	s6,16(sp)
    800018e0:	6ba2                	ld	s7,8(sp)
    800018e2:	6c02                	ld	s8,0(sp)
    800018e4:	6161                	addi	sp,sp,80
    800018e6:	8082                	ret

00000000800018e8 <copyin_new>:
// Copy from user to kernel.
// Copy len bytes to dst from virtual address srcva in a given page table.
// Return 0 on success, -1 on error.

int
copyin_new(char *dst, uint64 srcva, uint64 len){
    800018e8:	7139                	addi	sp,sp,-64
    800018ea:	fc06                	sd	ra,56(sp)
    800018ec:	f822                	sd	s0,48(sp)
    800018ee:	f426                	sd	s1,40(sp)
    800018f0:	f04a                	sd	s2,32(sp)
    800018f2:	ec4e                	sd	s3,24(sp)
    800018f4:	e852                	sd	s4,16(sp)
    800018f6:	e456                	sd	s5,8(sp)
    800018f8:	e05a                	sd	s6,0(sp)
    800018fa:	0080                	addi	s0,sp,64
  uint64 n, va0, pa0;
  if (srcva > PLIC){
    800018fc:	0c0007b7          	lui	a5,0xc000
    80001900:	02b7e263          	bltu	a5,a1,80001924 <copyin_new+0x3c>
    80001904:	89aa                	mv	s3,a0
    80001906:	8932                	mv	s2,a2
  // if (*pte1 != *pte2){
  //   printf("pte1 = %p , pte2 = %p\n",PTE2PA(*pte1),PTE2PA(*pte2));
  // }

  while(len > 0){
    va0 = PGROUNDDOWN(srcva);
    80001908:	7b7d                	lui	s6,0xfffff
    n = PGSIZE - (srcva - va0);
    8000190a:	6a85                	lui	s5,0x1
  while(len > 0){
    8000190c:	e231                	bnez	a2,80001950 <copyin_new+0x68>
    len -= n;
    dst += n;
    srcva = va0 + PGSIZE;
  }
  return 0;
}
    8000190e:	4501                	li	a0,0
    80001910:	70e2                	ld	ra,56(sp)
    80001912:	7442                	ld	s0,48(sp)
    80001914:	74a2                	ld	s1,40(sp)
    80001916:	7902                	ld	s2,32(sp)
    80001918:	69e2                	ld	s3,24(sp)
    8000191a:	6a42                	ld	s4,16(sp)
    8000191c:	6aa2                	ld	s5,8(sp)
    8000191e:	6b02                	ld	s6,0(sp)
    80001920:	6121                	addi	sp,sp,64
    80001922:	8082                	ret
    panic("invalid user pointer");
    80001924:	00007517          	auipc	a0,0x7
    80001928:	92c50513          	addi	a0,a0,-1748 # 80008250 <digits+0x1e8>
    8000192c:	fffff097          	auipc	ra,0xfffff
    80001930:	ca0080e7          	jalr	-864(ra) # 800005cc <panic>
    memmove(dst, (void *)srcva, n);
    80001934:	0004861b          	sext.w	a2,s1
    80001938:	854e                	mv	a0,s3
    8000193a:	fffff097          	auipc	ra,0xfffff
    8000193e:	458080e7          	jalr	1112(ra) # 80000d92 <memmove>
    len -= n;
    80001942:	40990933          	sub	s2,s2,s1
    dst += n;
    80001946:	99a6                	add	s3,s3,s1
    srcva = va0 + PGSIZE;
    80001948:	015a05b3          	add	a1,s4,s5
  while(len > 0){
    8000194c:	fc0901e3          	beqz	s2,8000190e <copyin_new+0x26>
    va0 = PGROUNDDOWN(srcva);
    80001950:	0165fa33          	and	s4,a1,s6
    n = PGSIZE - (srcva - va0);
    80001954:	40ba04b3          	sub	s1,s4,a1
    80001958:	94d6                	add	s1,s1,s5
    if(n > len)
    8000195a:	fc997de3          	bgeu	s2,s1,80001934 <copyin_new+0x4c>
    8000195e:	84ca                	mv	s1,s2
    80001960:	bfd1                	j	80001934 <copyin_new+0x4c>

0000000080001962 <copyin>:

int
copyin(pagetable_t p, char *dst, uint64 srcva, uint64 len)
{
    80001962:	1141                	addi	sp,sp,-16
    80001964:	e406                	sd	ra,8(sp)
    80001966:	e022                	sd	s0,0(sp)
    80001968:	0800                	addi	s0,sp,16
    8000196a:	852e                	mv	a0,a1
    8000196c:	85b2                	mv	a1,a2
  return copyin_new(dst,srcva,len);
    8000196e:	8636                	mv	a2,a3
    80001970:	00000097          	auipc	ra,0x0
    80001974:	f78080e7          	jalr	-136(ra) # 800018e8 <copyin_new>
}
    80001978:	60a2                	ld	ra,8(sp)
    8000197a:	6402                	ld	s0,0(sp)
    8000197c:	0141                	addi	sp,sp,16
    8000197e:	8082                	ret

0000000080001980 <copyinstr_new>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr_new(char *dst, uint64 srcva, uint64 max)
{
    80001980:	1141                	addi	sp,sp,-16
    80001982:	e422                	sd	s0,8(sp)
    80001984:	0800                	addi	s0,sp,16
  uint64 n, va0, pa0;
  int got_null = 0;

  pa0 = srcva;
  while(got_null == 0 && max > 0){
    80001986:	c23d                	beqz	a2,800019ec <copyinstr_new+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001988:	78fd                	lui	a7,0xfffff
    8000198a:	0115f8b3          	and	a7,a1,a7
    // pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
    8000198e:	c1ad                	beqz	a1,800019f0 <copyinstr_new+0x70>
    80001990:	6785                	lui	a5,0x1
    80001992:	98be                	add	a7,a7,a5
    80001994:	86ae                	mv	a3,a1
    80001996:	6305                	lui	t1,0x1
    80001998:	a831                	j	800019b4 <copyinstr_new+0x34>
      n = max;

    char *p = (char*)pa0;
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    8000199a:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    8000199e:	4785                	li	a5,1
      dst++;
    }
    pa0 += n;
    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800019a0:	0017b793          	seqz	a5,a5
    800019a4:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800019a8:	6422                	ld	s0,8(sp)
    800019aa:	0141                	addi	sp,sp,16
    800019ac:	8082                	ret
  while(got_null == 0 && max > 0){
    800019ae:	ce0d                	beqz	a2,800019e8 <copyinstr_new+0x68>
    srcva = va0 + PGSIZE;
    800019b0:	86c6                	mv	a3,a7
    if(pa0 == 0)
    800019b2:	989a                	add	a7,a7,t1
    n = PGSIZE - (srcva - va0);
    800019b4:	40d886b3          	sub	a3,a7,a3
    if(n > max)
    800019b8:	00d67363          	bgeu	a2,a3,800019be <copyinstr_new+0x3e>
    800019bc:	86b2                	mv	a3,a2
    while(n > 0){
    800019be:	dae5                	beqz	a3,800019ae <copyinstr_new+0x2e>
    800019c0:	96aa                	add	a3,a3,a0
    800019c2:	87aa                	mv	a5,a0
      if(*p == '\0'){
    800019c4:	40a58833          	sub	a6,a1,a0
    800019c8:	167d                	addi	a2,a2,-1
    800019ca:	9532                	add	a0,a0,a2
    800019cc:	00f80733          	add	a4,a6,a5
    800019d0:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd9000>
    800019d4:	d379                	beqz	a4,8000199a <copyinstr_new+0x1a>
        *dst = *p;
    800019d6:	00e78023          	sb	a4,0(a5)
      --max;
    800019da:	40f50633          	sub	a2,a0,a5
      dst++;
    800019de:	0785                	addi	a5,a5,1
    while(n > 0){
    800019e0:	fef696e3          	bne	a3,a5,800019cc <copyinstr_new+0x4c>
      dst++;
    800019e4:	8536                	mv	a0,a3
    800019e6:	b7e1                	j	800019ae <copyinstr_new+0x2e>
    800019e8:	4781                	li	a5,0
    800019ea:	bf5d                	j	800019a0 <copyinstr_new+0x20>
  int got_null = 0;
    800019ec:	4781                	li	a5,0
    800019ee:	bf4d                	j	800019a0 <copyinstr_new+0x20>
      return -1;
    800019f0:	557d                	li	a0,-1
    800019f2:	bf5d                	j	800019a8 <copyinstr_new+0x28>

00000000800019f4 <copyinstr>:

int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max){
    800019f4:	1141                	addi	sp,sp,-16
    800019f6:	e406                	sd	ra,8(sp)
    800019f8:	e022                	sd	s0,0(sp)
    800019fa:	0800                	addi	s0,sp,16
    800019fc:	852e                	mv	a0,a1
    800019fe:	85b2                	mv	a1,a2
  return copyinstr_new(dst,srcva,max);
    80001a00:	8636                	mv	a2,a3
    80001a02:	00000097          	auipc	ra,0x0
    80001a06:	f7e080e7          	jalr	-130(ra) # 80001980 <copyinstr_new>

}
    80001a0a:	60a2                	ld	ra,8(sp)
    80001a0c:	6402                	ld	s0,0(sp)
    80001a0e:	0141                	addi	sp,sp,16
    80001a10:	8082                	ret

0000000080001a12 <vm_p_helper>:


void vm_p_helper(pagetable_t pgt,int level){
  if (level < 0 )
    80001a12:	0a05c963          	bltz	a1,80001ac4 <vm_p_helper+0xb2>
void vm_p_helper(pagetable_t pgt,int level){
    80001a16:	7139                	addi	sp,sp,-64
    80001a18:	fc06                	sd	ra,56(sp)
    80001a1a:	f822                	sd	s0,48(sp)
    80001a1c:	f426                	sd	s1,40(sp)
    80001a1e:	f04a                	sd	s2,32(sp)
    80001a20:	ec4e                	sd	s3,24(sp)
    80001a22:	e852                	sd	s4,16(sp)
    80001a24:	e456                	sd	s5,8(sp)
    80001a26:	e05a                	sd	s6,0(sp)
    80001a28:	0080                	addi	s0,sp,64
    return ; 
  char *sep;
  if (level == 2){
    80001a2a:	4789                	li	a5,2
    80001a2c:	02f58d63          	beq	a1,a5,80001a66 <vm_p_helper+0x54>
    sep = ".."; 
  }
  else if (level == 1){
    80001a30:	4785                	li	a5,1
    80001a32:	02f58f63          	beq	a1,a5,80001a70 <vm_p_helper+0x5e>
    sep = ".. ..";
  }
  else if (level == 0){
    sep = ".. .. ..";
    80001a36:	00007b17          	auipc	s6,0x7
    80001a3a:	842b0b13          	addi	s6,s6,-1982 # 80008278 <digits+0x210>
  else if (level == 0){
    80001a3e:	ed81                	bnez	a1,80001a56 <vm_p_helper+0x44>
  }
  else {
    panic("error print page table");
  }
  for(int i = 0; i <512;i++){
    80001a40:	84aa                	mv	s1,a0
    80001a42:	4901                	li	s2,0
    pte_t *pte = &pgt[i];
    if ((*pte & PTE_V) ==1){
      printf(" %s%d: pte %p pa %p\n",sep,i,*pte,PTE2PA(*pte));
    80001a44:	00007a97          	auipc	s5,0x7
    80001a48:	85ca8a93          	addi	s5,s5,-1956 # 800082a0 <digits+0x238>
      vm_p_helper((pagetable_t)PTE2PA(*pte),level-1);
    80001a4c:	fff58a1b          	addiw	s4,a1,-1
  for(int i = 0; i <512;i++){
    80001a50:	20000993          	li	s3,512
    80001a54:	a03d                	j	80001a82 <vm_p_helper+0x70>
    panic("error print page table");
    80001a56:	00007517          	auipc	a0,0x7
    80001a5a:	83250513          	addi	a0,a0,-1998 # 80008288 <digits+0x220>
    80001a5e:	fffff097          	auipc	ra,0xfffff
    80001a62:	b6e080e7          	jalr	-1170(ra) # 800005cc <panic>
    sep = ".."; 
    80001a66:	00007b17          	auipc	s6,0x7
    80001a6a:	802b0b13          	addi	s6,s6,-2046 # 80008268 <digits+0x200>
    80001a6e:	bfc9                	j	80001a40 <vm_p_helper+0x2e>
    sep = ".. ..";
    80001a70:	00007b17          	auipc	s6,0x7
    80001a74:	800b0b13          	addi	s6,s6,-2048 # 80008270 <digits+0x208>
    80001a78:	b7e1                	j	80001a40 <vm_p_helper+0x2e>
  for(int i = 0; i <512;i++){
    80001a7a:	2905                	addiw	s2,s2,1
    80001a7c:	04a1                	addi	s1,s1,8
    80001a7e:	03390963          	beq	s2,s3,80001ab0 <vm_p_helper+0x9e>
    if ((*pte & PTE_V) ==1){
    80001a82:	6094                	ld	a3,0(s1)
    80001a84:	0016f793          	andi	a5,a3,1
    80001a88:	dbed                	beqz	a5,80001a7a <vm_p_helper+0x68>
      printf(" %s%d: pte %p pa %p\n",sep,i,*pte,PTE2PA(*pte));
    80001a8a:	00a6d713          	srli	a4,a3,0xa
    80001a8e:	0732                	slli	a4,a4,0xc
    80001a90:	864a                	mv	a2,s2
    80001a92:	85da                	mv	a1,s6
    80001a94:	8556                	mv	a0,s5
    80001a96:	fffff097          	auipc	ra,0xfffff
    80001a9a:	b88080e7          	jalr	-1144(ra) # 8000061e <printf>
      vm_p_helper((pagetable_t)PTE2PA(*pte),level-1);
    80001a9e:	6088                	ld	a0,0(s1)
    80001aa0:	8129                	srli	a0,a0,0xa
    80001aa2:	85d2                	mv	a1,s4
    80001aa4:	0532                	slli	a0,a0,0xc
    80001aa6:	00000097          	auipc	ra,0x0
    80001aaa:	f6c080e7          	jalr	-148(ra) # 80001a12 <vm_p_helper>
    80001aae:	b7f1                	j	80001a7a <vm_p_helper+0x68>
    }
  }
}
    80001ab0:	70e2                	ld	ra,56(sp)
    80001ab2:	7442                	ld	s0,48(sp)
    80001ab4:	74a2                	ld	s1,40(sp)
    80001ab6:	7902                	ld	s2,32(sp)
    80001ab8:	69e2                	ld	s3,24(sp)
    80001aba:	6a42                	ld	s4,16(sp)
    80001abc:	6aa2                	ld	s5,8(sp)
    80001abe:	6b02                	ld	s6,0(sp)
    80001ac0:	6121                	addi	sp,sp,64
    80001ac2:	8082                	ret
    80001ac4:	8082                	ret

0000000080001ac6 <vmprint>:


void vmprint(pagetable_t pgt){
    80001ac6:	1101                	addi	sp,sp,-32
    80001ac8:	ec06                	sd	ra,24(sp)
    80001aca:	e822                	sd	s0,16(sp)
    80001acc:	e426                	sd	s1,8(sp)
    80001ace:	1000                	addi	s0,sp,32
    80001ad0:	84aa                	mv	s1,a0
  printf("page table %p\n",pgt);
    80001ad2:	85aa                	mv	a1,a0
    80001ad4:	00006517          	auipc	a0,0x6
    80001ad8:	7e450513          	addi	a0,a0,2020 # 800082b8 <digits+0x250>
    80001adc:	fffff097          	auipc	ra,0xfffff
    80001ae0:	b42080e7          	jalr	-1214(ra) # 8000061e <printf>
  vm_p_helper(pgt,2);
    80001ae4:	4589                	li	a1,2
    80001ae6:	8526                	mv	a0,s1
    80001ae8:	00000097          	auipc	ra,0x0
    80001aec:	f2a080e7          	jalr	-214(ra) # 80001a12 <vm_p_helper>
    80001af0:	60e2                	ld	ra,24(sp)
    80001af2:	6442                	ld	s0,16(sp)
    80001af4:	64a2                	ld	s1,8(sp)
    80001af6:	6105                	addi	sp,sp,32
    80001af8:	8082                	ret

0000000080001afa <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80001afa:	7139                	addi	sp,sp,-64
    80001afc:	fc06                	sd	ra,56(sp)
    80001afe:	f822                	sd	s0,48(sp)
    80001b00:	f426                	sd	s1,40(sp)
    80001b02:	f04a                	sd	s2,32(sp)
    80001b04:	ec4e                	sd	s3,24(sp)
    80001b06:	e852                	sd	s4,16(sp)
    80001b08:	e456                	sd	s5,8(sp)
    80001b0a:	e05a                	sd	s6,0(sp)
    80001b0c:	0080                	addi	s0,sp,64
    80001b0e:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b10:	00010497          	auipc	s1,0x10
    80001b14:	bc048493          	addi	s1,s1,-1088 # 800116d0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001b18:	8b26                	mv	s6,s1
    80001b1a:	00006a97          	auipc	s5,0x6
    80001b1e:	4e6a8a93          	addi	s5,s5,1254 # 80008000 <etext>
    80001b22:	04000937          	lui	s2,0x4000
    80001b26:	197d                	addi	s2,s2,-1
    80001b28:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b2a:	00016a17          	auipc	s4,0x16
    80001b2e:	9a6a0a13          	addi	s4,s4,-1626 # 800174d0 <tickslock>
    char *pa = kalloc();
    80001b32:	fffff097          	auipc	ra,0xfffff
    80001b36:	018080e7          	jalr	24(ra) # 80000b4a <kalloc>
    80001b3a:	862a                	mv	a2,a0
    if(pa == 0)
    80001b3c:	c131                	beqz	a0,80001b80 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80001b3e:	416485b3          	sub	a1,s1,s6
    80001b42:	858d                	srai	a1,a1,0x3
    80001b44:	000ab783          	ld	a5,0(s5)
    80001b48:	02f585b3          	mul	a1,a1,a5
    80001b4c:	2585                	addiw	a1,a1,1
    80001b4e:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001b52:	4719                	li	a4,6
    80001b54:	6685                	lui	a3,0x1
    80001b56:	40b905b3          	sub	a1,s2,a1
    80001b5a:	854e                	mv	a0,s3
    80001b5c:	fffff097          	auipc	ra,0xfffff
    80001b60:	638080e7          	jalr	1592(ra) # 80001194 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b64:	17848493          	addi	s1,s1,376
    80001b68:	fd4495e3          	bne	s1,s4,80001b32 <proc_mapstacks+0x38>
  }
}
    80001b6c:	70e2                	ld	ra,56(sp)
    80001b6e:	7442                	ld	s0,48(sp)
    80001b70:	74a2                	ld	s1,40(sp)
    80001b72:	7902                	ld	s2,32(sp)
    80001b74:	69e2                	ld	s3,24(sp)
    80001b76:	6a42                	ld	s4,16(sp)
    80001b78:	6aa2                	ld	s5,8(sp)
    80001b7a:	6b02                	ld	s6,0(sp)
    80001b7c:	6121                	addi	sp,sp,64
    80001b7e:	8082                	ret
      panic("kalloc");
    80001b80:	00006517          	auipc	a0,0x6
    80001b84:	74850513          	addi	a0,a0,1864 # 800082c8 <digits+0x260>
    80001b88:	fffff097          	auipc	ra,0xfffff
    80001b8c:	a44080e7          	jalr	-1468(ra) # 800005cc <panic>

0000000080001b90 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80001b90:	7139                	addi	sp,sp,-64
    80001b92:	fc06                	sd	ra,56(sp)
    80001b94:	f822                	sd	s0,48(sp)
    80001b96:	f426                	sd	s1,40(sp)
    80001b98:	f04a                	sd	s2,32(sp)
    80001b9a:	ec4e                	sd	s3,24(sp)
    80001b9c:	e852                	sd	s4,16(sp)
    80001b9e:	e456                	sd	s5,8(sp)
    80001ba0:	e05a                	sd	s6,0(sp)
    80001ba2:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001ba4:	00006597          	auipc	a1,0x6
    80001ba8:	72c58593          	addi	a1,a1,1836 # 800082d0 <digits+0x268>
    80001bac:	0000f517          	auipc	a0,0xf
    80001bb0:	6f450513          	addi	a0,a0,1780 # 800112a0 <pid_lock>
    80001bb4:	fffff097          	auipc	ra,0xfffff
    80001bb8:	ff6080e7          	jalr	-10(ra) # 80000baa <initlock>
  initlock(&wait_lock, "wait_lock");
    80001bbc:	00006597          	auipc	a1,0x6
    80001bc0:	71c58593          	addi	a1,a1,1820 # 800082d8 <digits+0x270>
    80001bc4:	0000f517          	auipc	a0,0xf
    80001bc8:	6f450513          	addi	a0,a0,1780 # 800112b8 <wait_lock>
    80001bcc:	fffff097          	auipc	ra,0xfffff
    80001bd0:	fde080e7          	jalr	-34(ra) # 80000baa <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bd4:	00010497          	auipc	s1,0x10
    80001bd8:	afc48493          	addi	s1,s1,-1284 # 800116d0 <proc>
      initlock(&p->lock, "proc");
    80001bdc:	00006b17          	auipc	s6,0x6
    80001be0:	70cb0b13          	addi	s6,s6,1804 # 800082e8 <digits+0x280>
      p->kstack = KSTACK((int) (p - proc));
    80001be4:	8aa6                	mv	s5,s1
    80001be6:	00006a17          	auipc	s4,0x6
    80001bea:	41aa0a13          	addi	s4,s4,1050 # 80008000 <etext>
    80001bee:	04000937          	lui	s2,0x4000
    80001bf2:	197d                	addi	s2,s2,-1
    80001bf4:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bf6:	00016997          	auipc	s3,0x16
    80001bfa:	8da98993          	addi	s3,s3,-1830 # 800174d0 <tickslock>
      initlock(&p->lock, "proc");
    80001bfe:	85da                	mv	a1,s6
    80001c00:	8526                	mv	a0,s1
    80001c02:	fffff097          	auipc	ra,0xfffff
    80001c06:	fa8080e7          	jalr	-88(ra) # 80000baa <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80001c0a:	415487b3          	sub	a5,s1,s5
    80001c0e:	878d                	srai	a5,a5,0x3
    80001c10:	000a3703          	ld	a4,0(s4)
    80001c14:	02e787b3          	mul	a5,a5,a4
    80001c18:	2785                	addiw	a5,a5,1
    80001c1a:	00d7979b          	slliw	a5,a5,0xd
    80001c1e:	40f907b3          	sub	a5,s2,a5
    80001c22:	e4bc                	sd	a5,72(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c24:	17848493          	addi	s1,s1,376
    80001c28:	fd349be3          	bne	s1,s3,80001bfe <procinit+0x6e>
  }
}
    80001c2c:	70e2                	ld	ra,56(sp)
    80001c2e:	7442                	ld	s0,48(sp)
    80001c30:	74a2                	ld	s1,40(sp)
    80001c32:	7902                	ld	s2,32(sp)
    80001c34:	69e2                	ld	s3,24(sp)
    80001c36:	6a42                	ld	s4,16(sp)
    80001c38:	6aa2                	ld	s5,8(sp)
    80001c3a:	6b02                	ld	s6,0(sp)
    80001c3c:	6121                	addi	sp,sp,64
    80001c3e:	8082                	ret

0000000080001c40 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001c40:	1141                	addi	sp,sp,-16
    80001c42:	e422                	sd	s0,8(sp)
    80001c44:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r"(x));
    80001c46:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001c48:	2501                	sext.w	a0,a0
    80001c4a:	6422                	ld	s0,8(sp)
    80001c4c:	0141                	addi	sp,sp,16
    80001c4e:	8082                	ret

0000000080001c50 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80001c50:	1141                	addi	sp,sp,-16
    80001c52:	e422                	sd	s0,8(sp)
    80001c54:	0800                	addi	s0,sp,16
    80001c56:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001c58:	2781                	sext.w	a5,a5
    80001c5a:	079e                	slli	a5,a5,0x7
  return c;
}
    80001c5c:	0000f517          	auipc	a0,0xf
    80001c60:	67450513          	addi	a0,a0,1652 # 800112d0 <cpus>
    80001c64:	953e                	add	a0,a0,a5
    80001c66:	6422                	ld	s0,8(sp)
    80001c68:	0141                	addi	sp,sp,16
    80001c6a:	8082                	ret

0000000080001c6c <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80001c6c:	1101                	addi	sp,sp,-32
    80001c6e:	ec06                	sd	ra,24(sp)
    80001c70:	e822                	sd	s0,16(sp)
    80001c72:	e426                	sd	s1,8(sp)
    80001c74:	1000                	addi	s0,sp,32
  push_off();
    80001c76:	fffff097          	auipc	ra,0xfffff
    80001c7a:	f78080e7          	jalr	-136(ra) # 80000bee <push_off>
    80001c7e:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001c80:	2781                	sext.w	a5,a5
    80001c82:	079e                	slli	a5,a5,0x7
    80001c84:	0000f717          	auipc	a4,0xf
    80001c88:	61c70713          	addi	a4,a4,1564 # 800112a0 <pid_lock>
    80001c8c:	97ba                	add	a5,a5,a4
    80001c8e:	7b84                	ld	s1,48(a5)
  pop_off();
    80001c90:	fffff097          	auipc	ra,0xfffff
    80001c94:	ffe080e7          	jalr	-2(ra) # 80000c8e <pop_off>
  return p;
}
    80001c98:	8526                	mv	a0,s1
    80001c9a:	60e2                	ld	ra,24(sp)
    80001c9c:	6442                	ld	s0,16(sp)
    80001c9e:	64a2                	ld	s1,8(sp)
    80001ca0:	6105                	addi	sp,sp,32
    80001ca2:	8082                	ret

0000000080001ca4 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001ca4:	1141                	addi	sp,sp,-16
    80001ca6:	e406                	sd	ra,8(sp)
    80001ca8:	e022                	sd	s0,0(sp)
    80001caa:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001cac:	00000097          	auipc	ra,0x0
    80001cb0:	fc0080e7          	jalr	-64(ra) # 80001c6c <myproc>
    80001cb4:	fffff097          	auipc	ra,0xfffff
    80001cb8:	03a080e7          	jalr	58(ra) # 80000cee <release>

  if (first) {
    80001cbc:	00007797          	auipc	a5,0x7
    80001cc0:	c747a783          	lw	a5,-908(a5) # 80008930 <first.1>
    80001cc4:	eb89                	bnez	a5,80001cd6 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001cc6:	00001097          	auipc	ra,0x1
    80001cca:	dbe080e7          	jalr	-578(ra) # 80002a84 <usertrapret>
}
    80001cce:	60a2                	ld	ra,8(sp)
    80001cd0:	6402                	ld	s0,0(sp)
    80001cd2:	0141                	addi	sp,sp,16
    80001cd4:	8082                	ret
    first = 0;
    80001cd6:	00007797          	auipc	a5,0x7
    80001cda:	c407ad23          	sw	zero,-934(a5) # 80008930 <first.1>
    fsinit(ROOTDEV);
    80001cde:	4505                	li	a0,1
    80001ce0:	00002097          	auipc	ra,0x2
    80001ce4:	b64080e7          	jalr	-1180(ra) # 80003844 <fsinit>
    80001ce8:	bff9                	j	80001cc6 <forkret+0x22>

0000000080001cea <allocpid>:
allocpid() {
    80001cea:	1101                	addi	sp,sp,-32
    80001cec:	ec06                	sd	ra,24(sp)
    80001cee:	e822                	sd	s0,16(sp)
    80001cf0:	e426                	sd	s1,8(sp)
    80001cf2:	e04a                	sd	s2,0(sp)
    80001cf4:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001cf6:	0000f917          	auipc	s2,0xf
    80001cfa:	5aa90913          	addi	s2,s2,1450 # 800112a0 <pid_lock>
    80001cfe:	854a                	mv	a0,s2
    80001d00:	fffff097          	auipc	ra,0xfffff
    80001d04:	f3a080e7          	jalr	-198(ra) # 80000c3a <acquire>
  pid = nextpid;
    80001d08:	00007797          	auipc	a5,0x7
    80001d0c:	c2c78793          	addi	a5,a5,-980 # 80008934 <nextpid>
    80001d10:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001d12:	0014871b          	addiw	a4,s1,1
    80001d16:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001d18:	854a                	mv	a0,s2
    80001d1a:	fffff097          	auipc	ra,0xfffff
    80001d1e:	fd4080e7          	jalr	-44(ra) # 80000cee <release>
}
    80001d22:	8526                	mv	a0,s1
    80001d24:	60e2                	ld	ra,24(sp)
    80001d26:	6442                	ld	s0,16(sp)
    80001d28:	64a2                	ld	s1,8(sp)
    80001d2a:	6902                	ld	s2,0(sp)
    80001d2c:	6105                	addi	sp,sp,32
    80001d2e:	8082                	ret

0000000080001d30 <proc_pagetable>:
{
    80001d30:	1101                	addi	sp,sp,-32
    80001d32:	ec06                	sd	ra,24(sp)
    80001d34:	e822                	sd	s0,16(sp)
    80001d36:	e426                	sd	s1,8(sp)
    80001d38:	e04a                	sd	s2,0(sp)
    80001d3a:	1000                	addi	s0,sp,32
    80001d3c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001d3e:	fffff097          	auipc	ra,0xfffff
    80001d42:	636080e7          	jalr	1590(ra) # 80001374 <uvmcreate>
    80001d46:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001d48:	c121                	beqz	a0,80001d88 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001d4a:	4729                	li	a4,10
    80001d4c:	00005697          	auipc	a3,0x5
    80001d50:	2b468693          	addi	a3,a3,692 # 80007000 <_trampoline>
    80001d54:	6605                	lui	a2,0x1
    80001d56:	040005b7          	lui	a1,0x4000
    80001d5a:	15fd                	addi	a1,a1,-1
    80001d5c:	05b2                	slli	a1,a1,0xc
    80001d5e:	fffff097          	auipc	ra,0xfffff
    80001d62:	3a8080e7          	jalr	936(ra) # 80001106 <mappages>
    80001d66:	02054863          	bltz	a0,80001d96 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001d6a:	4719                	li	a4,6
    80001d6c:	06893683          	ld	a3,104(s2)
    80001d70:	6605                	lui	a2,0x1
    80001d72:	020005b7          	lui	a1,0x2000
    80001d76:	15fd                	addi	a1,a1,-1
    80001d78:	05b6                	slli	a1,a1,0xd
    80001d7a:	8526                	mv	a0,s1
    80001d7c:	fffff097          	auipc	ra,0xfffff
    80001d80:	38a080e7          	jalr	906(ra) # 80001106 <mappages>
    80001d84:	02054163          	bltz	a0,80001da6 <proc_pagetable+0x76>
}
    80001d88:	8526                	mv	a0,s1
    80001d8a:	60e2                	ld	ra,24(sp)
    80001d8c:	6442                	ld	s0,16(sp)
    80001d8e:	64a2                	ld	s1,8(sp)
    80001d90:	6902                	ld	s2,0(sp)
    80001d92:	6105                	addi	sp,sp,32
    80001d94:	8082                	ret
    uvmfree(pagetable, 0);
    80001d96:	4581                	li	a1,0
    80001d98:	8526                	mv	a0,s1
    80001d9a:	00000097          	auipc	ra,0x0
    80001d9e:	8ac080e7          	jalr	-1876(ra) # 80001646 <uvmfree>
    return 0;
    80001da2:	4481                	li	s1,0
    80001da4:	b7d5                	j	80001d88 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001da6:	4681                	li	a3,0
    80001da8:	4605                	li	a2,1
    80001daa:	040005b7          	lui	a1,0x4000
    80001dae:	15fd                	addi	a1,a1,-1
    80001db0:	05b2                	slli	a1,a1,0xc
    80001db2:	8526                	mv	a0,s1
    80001db4:	fffff097          	auipc	ra,0xfffff
    80001db8:	4fc080e7          	jalr	1276(ra) # 800012b0 <uvmunmap>
    uvmfree(pagetable, 0);
    80001dbc:	4581                	li	a1,0
    80001dbe:	8526                	mv	a0,s1
    80001dc0:	00000097          	auipc	ra,0x0
    80001dc4:	886080e7          	jalr	-1914(ra) # 80001646 <uvmfree>
    return 0;
    80001dc8:	4481                	li	s1,0
    80001dca:	bf7d                	j	80001d88 <proc_pagetable+0x58>

0000000080001dcc <proc_freepagetable>:
{
    80001dcc:	1101                	addi	sp,sp,-32
    80001dce:	ec06                	sd	ra,24(sp)
    80001dd0:	e822                	sd	s0,16(sp)
    80001dd2:	e426                	sd	s1,8(sp)
    80001dd4:	e04a                	sd	s2,0(sp)
    80001dd6:	1000                	addi	s0,sp,32
    80001dd8:	84aa                	mv	s1,a0
    80001dda:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001ddc:	4681                	li	a3,0
    80001dde:	4605                	li	a2,1
    80001de0:	040005b7          	lui	a1,0x4000
    80001de4:	15fd                	addi	a1,a1,-1
    80001de6:	05b2                	slli	a1,a1,0xc
    80001de8:	fffff097          	auipc	ra,0xfffff
    80001dec:	4c8080e7          	jalr	1224(ra) # 800012b0 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001df0:	4681                	li	a3,0
    80001df2:	4605                	li	a2,1
    80001df4:	020005b7          	lui	a1,0x2000
    80001df8:	15fd                	addi	a1,a1,-1
    80001dfa:	05b6                	slli	a1,a1,0xd
    80001dfc:	8526                	mv	a0,s1
    80001dfe:	fffff097          	auipc	ra,0xfffff
    80001e02:	4b2080e7          	jalr	1202(ra) # 800012b0 <uvmunmap>
  uvmfree(pagetable, sz);
    80001e06:	85ca                	mv	a1,s2
    80001e08:	8526                	mv	a0,s1
    80001e0a:	00000097          	auipc	ra,0x0
    80001e0e:	83c080e7          	jalr	-1988(ra) # 80001646 <uvmfree>
}
    80001e12:	60e2                	ld	ra,24(sp)
    80001e14:	6442                	ld	s0,16(sp)
    80001e16:	64a2                	ld	s1,8(sp)
    80001e18:	6902                	ld	s2,0(sp)
    80001e1a:	6105                	addi	sp,sp,32
    80001e1c:	8082                	ret

0000000080001e1e <freeproc>:
{
    80001e1e:	1101                	addi	sp,sp,-32
    80001e20:	ec06                	sd	ra,24(sp)
    80001e22:	e822                	sd	s0,16(sp)
    80001e24:	e426                	sd	s1,8(sp)
    80001e26:	1000                	addi	s0,sp,32
    80001e28:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001e2a:	7528                	ld	a0,104(a0)
    80001e2c:	c509                	beqz	a0,80001e36 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001e2e:	fffff097          	auipc	ra,0xfffff
    80001e32:	c20080e7          	jalr	-992(ra) # 80000a4e <kfree>
  p->trapframe = 0;
    80001e36:	0604b423          	sd	zero,104(s1)
  if(p->pagetable)
    80001e3a:	6ca8                	ld	a0,88(s1)
    80001e3c:	c511                	beqz	a0,80001e48 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001e3e:	68ac                	ld	a1,80(s1)
    80001e40:	00000097          	auipc	ra,0x0
    80001e44:	f8c080e7          	jalr	-116(ra) # 80001dcc <proc_freepagetable>
  if (p->k_pagetable){
    80001e48:	70bc                	ld	a5,96(s1)
    80001e4a:	c791                	beqz	a5,80001e56 <freeproc+0x38>
  free_kmapping(p);
    80001e4c:	8526                	mv	a0,s1
    80001e4e:	00000097          	auipc	ra,0x0
    80001e52:	830080e7          	jalr	-2000(ra) # 8000167e <free_kmapping>
  p->pagetable = 0;
    80001e56:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    80001e5a:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    80001e5e:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001e62:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001e66:	16048423          	sb	zero,360(s1)
  p->chan = 0;
    80001e6a:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001e6e:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001e72:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001e76:	0004ac23          	sw	zero,24(s1)
}
    80001e7a:	60e2                	ld	ra,24(sp)
    80001e7c:	6442                	ld	s0,16(sp)
    80001e7e:	64a2                	ld	s1,8(sp)
    80001e80:	6105                	addi	sp,sp,32
    80001e82:	8082                	ret

0000000080001e84 <allocproc>:
{
    80001e84:	1101                	addi	sp,sp,-32
    80001e86:	ec06                	sd	ra,24(sp)
    80001e88:	e822                	sd	s0,16(sp)
    80001e8a:	e426                	sd	s1,8(sp)
    80001e8c:	e04a                	sd	s2,0(sp)
    80001e8e:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e90:	00010497          	auipc	s1,0x10
    80001e94:	84048493          	addi	s1,s1,-1984 # 800116d0 <proc>
    80001e98:	00015917          	auipc	s2,0x15
    80001e9c:	63890913          	addi	s2,s2,1592 # 800174d0 <tickslock>
    acquire(&p->lock);
    80001ea0:	8526                	mv	a0,s1
    80001ea2:	fffff097          	auipc	ra,0xfffff
    80001ea6:	d98080e7          	jalr	-616(ra) # 80000c3a <acquire>
    if(p->state == UNUSED) {
    80001eaa:	4c9c                	lw	a5,24(s1)
    80001eac:	cf81                	beqz	a5,80001ec4 <allocproc+0x40>
      release(&p->lock);
    80001eae:	8526                	mv	a0,s1
    80001eb0:	fffff097          	auipc	ra,0xfffff
    80001eb4:	e3e080e7          	jalr	-450(ra) # 80000cee <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001eb8:	17848493          	addi	s1,s1,376
    80001ebc:	ff2492e3          	bne	s1,s2,80001ea0 <allocproc+0x1c>
  return 0;
    80001ec0:	4481                	li	s1,0
    80001ec2:	a075                	j	80001f6e <allocproc+0xea>
  p->pid = allocpid();
    80001ec4:	00000097          	auipc	ra,0x0
    80001ec8:	e26080e7          	jalr	-474(ra) # 80001cea <allocpid>
    80001ecc:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001ece:	4785                	li	a5,1
    80001ed0:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001ed2:	fffff097          	auipc	ra,0xfffff
    80001ed6:	c78080e7          	jalr	-904(ra) # 80000b4a <kalloc>
    80001eda:	892a                	mv	s2,a0
    80001edc:	f4a8                	sd	a0,104(s1)
    80001ede:	cd59                	beqz	a0,80001f7c <allocproc+0xf8>
  p->pagetable = proc_pagetable(p);
    80001ee0:	8526                	mv	a0,s1
    80001ee2:	00000097          	auipc	ra,0x0
    80001ee6:	e4e080e7          	jalr	-434(ra) # 80001d30 <proc_pagetable>
    80001eea:	892a                	mv	s2,a0
    80001eec:	eca8                	sd	a0,88(s1)
  if(p->pagetable == 0){
    80001eee:	c15d                	beqz	a0,80001f94 <allocproc+0x110>
  p->k_pagetable = kvmmake();
    80001ef0:	fffff097          	auipc	ra,0xfffff
    80001ef4:	2d4080e7          	jalr	724(ra) # 800011c4 <kvmmake>
    80001ef8:	892a                	mv	s2,a0
    80001efa:	f0a8                	sd	a0,96(s1)
  if(p->k_pagetable == 0){
    80001efc:	c945                	beqz	a0,80001fac <allocproc+0x128>
  char *pa = kalloc();
    80001efe:	fffff097          	auipc	ra,0xfffff
    80001f02:	c4c080e7          	jalr	-948(ra) # 80000b4a <kalloc>
    80001f06:	862a                	mv	a2,a0
  if(pa == 0)
    80001f08:	cd55                	beqz	a0,80001fc4 <allocproc+0x140>
  uint64 va = KSTACK((int) (p - proc));
    80001f0a:	0000f797          	auipc	a5,0xf
    80001f0e:	7c678793          	addi	a5,a5,1990 # 800116d0 <proc>
    80001f12:	40f487b3          	sub	a5,s1,a5
    80001f16:	878d                	srai	a5,a5,0x3
    80001f18:	00006717          	auipc	a4,0x6
    80001f1c:	0e873703          	ld	a4,232(a4) # 80008000 <etext>
    80001f20:	02e787b3          	mul	a5,a5,a4
    80001f24:	2785                	addiw	a5,a5,1
    80001f26:	00d7979b          	slliw	a5,a5,0xd
    80001f2a:	04000937          	lui	s2,0x4000
    80001f2e:	197d                	addi	s2,s2,-1
    80001f30:	0932                	slli	s2,s2,0xc
    80001f32:	40f90933          	sub	s2,s2,a5
  kvmmap(p->k_pagetable, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001f36:	4719                	li	a4,6
    80001f38:	6685                	lui	a3,0x1
    80001f3a:	85ca                	mv	a1,s2
    80001f3c:	70a8                	ld	a0,96(s1)
    80001f3e:	fffff097          	auipc	ra,0xfffff
    80001f42:	256080e7          	jalr	598(ra) # 80001194 <kvmmap>
  p->kstack = va;
    80001f46:	0524b423          	sd	s2,72(s1)
  memset(&p->context, 0, sizeof(p->context));
    80001f4a:	07000613          	li	a2,112
    80001f4e:	4581                	li	a1,0
    80001f50:	07048513          	addi	a0,s1,112
    80001f54:	fffff097          	auipc	ra,0xfffff
    80001f58:	de2080e7          	jalr	-542(ra) # 80000d36 <memset>
  p->context.ra = (uint64)forkret;
    80001f5c:	00000797          	auipc	a5,0x0
    80001f60:	d4878793          	addi	a5,a5,-696 # 80001ca4 <forkret>
    80001f64:	f8bc                	sd	a5,112(s1)
  p->context.sp = p->kstack +  PGSIZE;
    80001f66:	64bc                	ld	a5,72(s1)
    80001f68:	6705                	lui	a4,0x1
    80001f6a:	97ba                	add	a5,a5,a4
    80001f6c:	fcbc                	sd	a5,120(s1)
}
    80001f6e:	8526                	mv	a0,s1
    80001f70:	60e2                	ld	ra,24(sp)
    80001f72:	6442                	ld	s0,16(sp)
    80001f74:	64a2                	ld	s1,8(sp)
    80001f76:	6902                	ld	s2,0(sp)
    80001f78:	6105                	addi	sp,sp,32
    80001f7a:	8082                	ret
    freeproc(p);
    80001f7c:	8526                	mv	a0,s1
    80001f7e:	00000097          	auipc	ra,0x0
    80001f82:	ea0080e7          	jalr	-352(ra) # 80001e1e <freeproc>
    release(&p->lock);
    80001f86:	8526                	mv	a0,s1
    80001f88:	fffff097          	auipc	ra,0xfffff
    80001f8c:	d66080e7          	jalr	-666(ra) # 80000cee <release>
    return 0;
    80001f90:	84ca                	mv	s1,s2
    80001f92:	bff1                	j	80001f6e <allocproc+0xea>
    freeproc(p);
    80001f94:	8526                	mv	a0,s1
    80001f96:	00000097          	auipc	ra,0x0
    80001f9a:	e88080e7          	jalr	-376(ra) # 80001e1e <freeproc>
    release(&p->lock);
    80001f9e:	8526                	mv	a0,s1
    80001fa0:	fffff097          	auipc	ra,0xfffff
    80001fa4:	d4e080e7          	jalr	-690(ra) # 80000cee <release>
    return 0;
    80001fa8:	84ca                	mv	s1,s2
    80001faa:	b7d1                	j	80001f6e <allocproc+0xea>
    freeproc(p);
    80001fac:	8526                	mv	a0,s1
    80001fae:	00000097          	auipc	ra,0x0
    80001fb2:	e70080e7          	jalr	-400(ra) # 80001e1e <freeproc>
    release(&p->lock);
    80001fb6:	8526                	mv	a0,s1
    80001fb8:	fffff097          	auipc	ra,0xfffff
    80001fbc:	d36080e7          	jalr	-714(ra) # 80000cee <release>
    return 0;
    80001fc0:	84ca                	mv	s1,s2
    80001fc2:	b775                	j	80001f6e <allocproc+0xea>
    panic("kalloc");
    80001fc4:	00006517          	auipc	a0,0x6
    80001fc8:	30450513          	addi	a0,a0,772 # 800082c8 <digits+0x260>
    80001fcc:	ffffe097          	auipc	ra,0xffffe
    80001fd0:	600080e7          	jalr	1536(ra) # 800005cc <panic>

0000000080001fd4 <proc_freekpagetable>:
void proc_freekpagetable(struct proc *p){
    80001fd4:	1141                	addi	sp,sp,-16
    80001fd6:	e406                	sd	ra,8(sp)
    80001fd8:	e022                	sd	s0,0(sp)
    80001fda:	0800                	addi	s0,sp,16
  free_kmapping(p);
    80001fdc:	fffff097          	auipc	ra,0xfffff
    80001fe0:	6a2080e7          	jalr	1698(ra) # 8000167e <free_kmapping>
}
    80001fe4:	60a2                	ld	ra,8(sp)
    80001fe6:	6402                	ld	s0,0(sp)
    80001fe8:	0141                	addi	sp,sp,16
    80001fea:	8082                	ret

0000000080001fec <userinit>:
{
    80001fec:	1101                	addi	sp,sp,-32
    80001fee:	ec06                	sd	ra,24(sp)
    80001ff0:	e822                	sd	s0,16(sp)
    80001ff2:	e426                	sd	s1,8(sp)
    80001ff4:	e04a                	sd	s2,0(sp)
    80001ff6:	1000                	addi	s0,sp,32
  p = allocproc();
    80001ff8:	00000097          	auipc	ra,0x0
    80001ffc:	e8c080e7          	jalr	-372(ra) # 80001e84 <allocproc>
    80002000:	84aa                	mv	s1,a0
  initproc = p;
    80002002:	00007797          	auipc	a5,0x7
    80002006:	02a7b323          	sd	a0,38(a5) # 80009028 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000200a:	03400613          	li	a2,52
    8000200e:	00007597          	auipc	a1,0x7
    80002012:	93258593          	addi	a1,a1,-1742 # 80008940 <initcode>
    80002016:	6d28                	ld	a0,88(a0)
    80002018:	fffff097          	auipc	ra,0xfffff
    8000201c:	38a080e7          	jalr	906(ra) # 800013a2 <uvminit>
  p->sz = PGSIZE;
    80002020:	6905                	lui	s2,0x1
    80002022:	0524b823          	sd	s2,80(s1)
  uvmapping(p->pagetable,p->k_pagetable,0,p->sz);
    80002026:	6685                	lui	a3,0x1
    80002028:	4601                	li	a2,0
    8000202a:	70ac                	ld	a1,96(s1)
    8000202c:	6ca8                	ld	a0,88(s1)
    8000202e:	fffff097          	auipc	ra,0xfffff
    80002032:	3e6080e7          	jalr	998(ra) # 80001414 <uvmapping>
  p->trapframe->epc = 0;      // user program counter
    80002036:	74bc                	ld	a5,104(s1)
    80002038:	0007bc23          	sd	zero,24(a5)
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000203c:	74bc                	ld	a5,104(s1)
    8000203e:	0327b823          	sd	s2,48(a5)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80002042:	4641                	li	a2,16
    80002044:	00006597          	auipc	a1,0x6
    80002048:	2ac58593          	addi	a1,a1,684 # 800082f0 <digits+0x288>
    8000204c:	16848513          	addi	a0,s1,360
    80002050:	fffff097          	auipc	ra,0xfffff
    80002054:	e38080e7          	jalr	-456(ra) # 80000e88 <safestrcpy>
  p->cwd = namei("/");
    80002058:	00006517          	auipc	a0,0x6
    8000205c:	2a850513          	addi	a0,a0,680 # 80008300 <digits+0x298>
    80002060:	00002097          	auipc	ra,0x2
    80002064:	212080e7          	jalr	530(ra) # 80004272 <namei>
    80002068:	16a4b023          	sd	a0,352(s1)
  p->state = RUNNABLE;
    8000206c:	478d                	li	a5,3
    8000206e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80002070:	8526                	mv	a0,s1
    80002072:	fffff097          	auipc	ra,0xfffff
    80002076:	c7c080e7          	jalr	-900(ra) # 80000cee <release>
}
    8000207a:	60e2                	ld	ra,24(sp)
    8000207c:	6442                	ld	s0,16(sp)
    8000207e:	64a2                	ld	s1,8(sp)
    80002080:	6902                	ld	s2,0(sp)
    80002082:	6105                	addi	sp,sp,32
    80002084:	8082                	ret

0000000080002086 <growproc>:
{
    80002086:	7139                	addi	sp,sp,-64
    80002088:	fc06                	sd	ra,56(sp)
    8000208a:	f822                	sd	s0,48(sp)
    8000208c:	f426                	sd	s1,40(sp)
    8000208e:	f04a                	sd	s2,32(sp)
    80002090:	ec4e                	sd	s3,24(sp)
    80002092:	e852                	sd	s4,16(sp)
    80002094:	e456                	sd	s5,8(sp)
    80002096:	0080                	addi	s0,sp,64
    80002098:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000209a:	00000097          	auipc	ra,0x0
    8000209e:	bd2080e7          	jalr	-1070(ra) # 80001c6c <myproc>
    800020a2:	892a                	mv	s2,a0
  sz = p->sz;
    800020a4:	05053a03          	ld	s4,80(a0)
    800020a8:	000a0a9b          	sext.w	s5,s4
  if(n > 0){
    800020ac:	04904363          	bgtz	s1,800020f2 <growproc+0x6c>
  sz = p->sz;
    800020b0:	89d6                	mv	s3,s5
  } else if(n < 0){
    800020b2:	0604c263          	bltz	s1,80002116 <growproc+0x90>
  uvmapping(p->pagetable,p->k_pagetable,oldsz,oldsz+n);
    800020b6:	015486bb          	addw	a3,s1,s5
    800020ba:	1682                	slli	a3,a3,0x20
    800020bc:	9281                	srli	a3,a3,0x20
    800020be:	020a1613          	slli	a2,s4,0x20
    800020c2:	9201                	srli	a2,a2,0x20
    800020c4:	06093583          	ld	a1,96(s2) # 1060 <_entry-0x7fffefa0>
    800020c8:	05893503          	ld	a0,88(s2)
    800020cc:	fffff097          	auipc	ra,0xfffff
    800020d0:	348080e7          	jalr	840(ra) # 80001414 <uvmapping>
  p->sz = sz;
    800020d4:	1982                	slli	s3,s3,0x20
    800020d6:	0209d993          	srli	s3,s3,0x20
    800020da:	05393823          	sd	s3,80(s2)
  return 0;
    800020de:	4501                	li	a0,0
}
    800020e0:	70e2                	ld	ra,56(sp)
    800020e2:	7442                	ld	s0,48(sp)
    800020e4:	74a2                	ld	s1,40(sp)
    800020e6:	7902                	ld	s2,32(sp)
    800020e8:	69e2                	ld	s3,24(sp)
    800020ea:	6a42                	ld	s4,16(sp)
    800020ec:	6aa2                	ld	s5,8(sp)
    800020ee:	6121                	addi	sp,sp,64
    800020f0:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800020f2:	0154863b          	addw	a2,s1,s5
    800020f6:	1602                	slli	a2,a2,0x20
    800020f8:	9201                	srli	a2,a2,0x20
    800020fa:	020a1593          	slli	a1,s4,0x20
    800020fe:	9181                	srli	a1,a1,0x20
    80002100:	6d28                	ld	a0,88(a0)
    80002102:	fffff097          	auipc	ra,0xfffff
    80002106:	400080e7          	jalr	1024(ra) # 80001502 <uvmalloc>
    8000210a:	0005099b          	sext.w	s3,a0
    8000210e:	fa0994e3          	bnez	s3,800020b6 <growproc+0x30>
      return -1;
    80002112:	557d                	li	a0,-1
    80002114:	b7f1                	j	800020e0 <growproc+0x5a>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80002116:	0154863b          	addw	a2,s1,s5
    8000211a:	1602                	slli	a2,a2,0x20
    8000211c:	9201                	srli	a2,a2,0x20
    8000211e:	020a1593          	slli	a1,s4,0x20
    80002122:	9181                	srli	a1,a1,0x20
    80002124:	6d28                	ld	a0,88(a0)
    80002126:	fffff097          	auipc	ra,0xfffff
    8000212a:	394080e7          	jalr	916(ra) # 800014ba <uvmdealloc>
    8000212e:	0005099b          	sext.w	s3,a0
    80002132:	b751                	j	800020b6 <growproc+0x30>

0000000080002134 <trace>:
i32 trace(i32 traced){
    80002134:	1101                	addi	sp,sp,-32
    80002136:	ec06                	sd	ra,24(sp)
    80002138:	e822                	sd	s0,16(sp)
    8000213a:	e426                	sd	s1,8(sp)
    8000213c:	1000                	addi	s0,sp,32
    8000213e:	84aa                	mv	s1,a0
  struct proc *p  = myproc();
    80002140:	00000097          	auipc	ra,0x0
    80002144:	b2c080e7          	jalr	-1236(ra) # 80001c6c <myproc>
  p->traced |= traced;
    80002148:	413c                	lw	a5,64(a0)
    8000214a:	8cdd                	or	s1,s1,a5
    8000214c:	c124                	sw	s1,64(a0)
}
    8000214e:	4501                	li	a0,0
    80002150:	60e2                	ld	ra,24(sp)
    80002152:	6442                	ld	s0,16(sp)
    80002154:	64a2                	ld	s1,8(sp)
    80002156:	6105                	addi	sp,sp,32
    80002158:	8082                	ret

000000008000215a <fork>:
{
    8000215a:	7139                	addi	sp,sp,-64
    8000215c:	fc06                	sd	ra,56(sp)
    8000215e:	f822                	sd	s0,48(sp)
    80002160:	f426                	sd	s1,40(sp)
    80002162:	f04a                	sd	s2,32(sp)
    80002164:	ec4e                	sd	s3,24(sp)
    80002166:	e852                	sd	s4,16(sp)
    80002168:	e456                	sd	s5,8(sp)
    8000216a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000216c:	00000097          	auipc	ra,0x0
    80002170:	b00080e7          	jalr	-1280(ra) # 80001c6c <myproc>
    80002174:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80002176:	00000097          	auipc	ra,0x0
    8000217a:	d0e080e7          	jalr	-754(ra) # 80001e84 <allocproc>
    8000217e:	14050c63          	beqz	a0,800022d6 <fork+0x17c>
    80002182:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80002184:	050ab603          	ld	a2,80(s5)
    80002188:	6d2c                	ld	a1,88(a0)
    8000218a:	058ab503          	ld	a0,88(s5)
    8000218e:	fffff097          	auipc	ra,0xfffff
    80002192:	5ca080e7          	jalr	1482(ra) # 80001758 <uvmcopy>
    80002196:	08054063          	bltz	a0,80002216 <fork+0xbc>
  uvmapping(np->pagetable,np->k_pagetable,0,p->sz);
    8000219a:	050ab683          	ld	a3,80(s5)
    8000219e:	4601                	li	a2,0
    800021a0:	0609b583          	ld	a1,96(s3)
    800021a4:	0589b503          	ld	a0,88(s3)
    800021a8:	fffff097          	auipc	ra,0xfffff
    800021ac:	26c080e7          	jalr	620(ra) # 80001414 <uvmapping>
  if ((pte = walk(np->k_pagetable,0,0) )== 0){
    800021b0:	4601                	li	a2,0
    800021b2:	4581                	li	a1,0
    800021b4:	0609b503          	ld	a0,96(s3)
    800021b8:	fffff097          	auipc	ra,0xfffff
    800021bc:	e66080e7          	jalr	-410(ra) # 8000101e <walk>
    800021c0:	c53d                	beqz	a0,8000222e <fork+0xd4>
  np->sz = p->sz;
    800021c2:	050ab783          	ld	a5,80(s5)
    800021c6:	04f9b823          	sd	a5,80(s3)
  np->traced = p->traced;
    800021ca:	040aa783          	lw	a5,64(s5)
    800021ce:	04f9a023          	sw	a5,64(s3)
  *(np->trapframe) = *(p->trapframe);
    800021d2:	068ab683          	ld	a3,104(s5)
    800021d6:	87b6                	mv	a5,a3
    800021d8:	0689b703          	ld	a4,104(s3)
    800021dc:	12068693          	addi	a3,a3,288 # 1120 <_entry-0x7fffeee0>
    800021e0:	0007b803          	ld	a6,0(a5)
    800021e4:	6788                	ld	a0,8(a5)
    800021e6:	6b8c                	ld	a1,16(a5)
    800021e8:	6f90                	ld	a2,24(a5)
    800021ea:	01073023          	sd	a6,0(a4) # 1000 <_entry-0x7ffff000>
    800021ee:	e708                	sd	a0,8(a4)
    800021f0:	eb0c                	sd	a1,16(a4)
    800021f2:	ef10                	sd	a2,24(a4)
    800021f4:	02078793          	addi	a5,a5,32
    800021f8:	02070713          	addi	a4,a4,32
    800021fc:	fed792e3          	bne	a5,a3,800021e0 <fork+0x86>
  np->trapframe->a0 = 0;
    80002200:	0689b783          	ld	a5,104(s3)
    80002204:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80002208:	0e0a8493          	addi	s1,s5,224
    8000220c:	0e098913          	addi	s2,s3,224
    80002210:	160a8a13          	addi	s4,s5,352
    80002214:	a83d                	j	80002252 <fork+0xf8>
    freeproc(np);
    80002216:	854e                	mv	a0,s3
    80002218:	00000097          	auipc	ra,0x0
    8000221c:	c06080e7          	jalr	-1018(ra) # 80001e1e <freeproc>
    release(&np->lock);
    80002220:	854e                	mv	a0,s3
    80002222:	fffff097          	auipc	ra,0xfffff
    80002226:	acc080e7          	jalr	-1332(ra) # 80000cee <release>
    return -1;
    8000222a:	597d                	li	s2,-1
    8000222c:	a859                	j	800022c2 <fork+0x168>
    panic("not valid k table");
    8000222e:	00006517          	auipc	a0,0x6
    80002232:	0da50513          	addi	a0,a0,218 # 80008308 <digits+0x2a0>
    80002236:	ffffe097          	auipc	ra,0xffffe
    8000223a:	396080e7          	jalr	918(ra) # 800005cc <panic>
      np->ofile[i] = filedup(p->ofile[i]);
    8000223e:	00002097          	auipc	ra,0x2
    80002242:	6ca080e7          	jalr	1738(ra) # 80004908 <filedup>
    80002246:	00a93023          	sd	a0,0(s2)
  for(i = 0; i < NOFILE; i++)
    8000224a:	04a1                	addi	s1,s1,8
    8000224c:	0921                	addi	s2,s2,8
    8000224e:	01448563          	beq	s1,s4,80002258 <fork+0xfe>
    if(p->ofile[i])
    80002252:	6088                	ld	a0,0(s1)
    80002254:	f56d                	bnez	a0,8000223e <fork+0xe4>
    80002256:	bfd5                	j	8000224a <fork+0xf0>
  np->cwd = idup(p->cwd);
    80002258:	160ab503          	ld	a0,352(s5)
    8000225c:	00002097          	auipc	ra,0x2
    80002260:	822080e7          	jalr	-2014(ra) # 80003a7e <idup>
    80002264:	16a9b023          	sd	a0,352(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80002268:	4641                	li	a2,16
    8000226a:	168a8593          	addi	a1,s5,360
    8000226e:	16898513          	addi	a0,s3,360
    80002272:	fffff097          	auipc	ra,0xfffff
    80002276:	c16080e7          	jalr	-1002(ra) # 80000e88 <safestrcpy>
  pid = np->pid;
    8000227a:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    8000227e:	854e                	mv	a0,s3
    80002280:	fffff097          	auipc	ra,0xfffff
    80002284:	a6e080e7          	jalr	-1426(ra) # 80000cee <release>
  acquire(&wait_lock);
    80002288:	0000f497          	auipc	s1,0xf
    8000228c:	03048493          	addi	s1,s1,48 # 800112b8 <wait_lock>
    80002290:	8526                	mv	a0,s1
    80002292:	fffff097          	auipc	ra,0xfffff
    80002296:	9a8080e7          	jalr	-1624(ra) # 80000c3a <acquire>
  np->parent = p;
    8000229a:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    8000229e:	8526                	mv	a0,s1
    800022a0:	fffff097          	auipc	ra,0xfffff
    800022a4:	a4e080e7          	jalr	-1458(ra) # 80000cee <release>
  acquire(&np->lock);
    800022a8:	854e                	mv	a0,s3
    800022aa:	fffff097          	auipc	ra,0xfffff
    800022ae:	990080e7          	jalr	-1648(ra) # 80000c3a <acquire>
  np->state = RUNNABLE;
    800022b2:	478d                	li	a5,3
    800022b4:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800022b8:	854e                	mv	a0,s3
    800022ba:	fffff097          	auipc	ra,0xfffff
    800022be:	a34080e7          	jalr	-1484(ra) # 80000cee <release>
}
    800022c2:	854a                	mv	a0,s2
    800022c4:	70e2                	ld	ra,56(sp)
    800022c6:	7442                	ld	s0,48(sp)
    800022c8:	74a2                	ld	s1,40(sp)
    800022ca:	7902                	ld	s2,32(sp)
    800022cc:	69e2                	ld	s3,24(sp)
    800022ce:	6a42                	ld	s4,16(sp)
    800022d0:	6aa2                	ld	s5,8(sp)
    800022d2:	6121                	addi	sp,sp,64
    800022d4:	8082                	ret
    return -1;
    800022d6:	597d                	li	s2,-1
    800022d8:	b7ed                	j	800022c2 <fork+0x168>

00000000800022da <scheduler>:
{
    800022da:	715d                	addi	sp,sp,-80
    800022dc:	e486                	sd	ra,72(sp)
    800022de:	e0a2                	sd	s0,64(sp)
    800022e0:	fc26                	sd	s1,56(sp)
    800022e2:	f84a                	sd	s2,48(sp)
    800022e4:	f44e                	sd	s3,40(sp)
    800022e6:	f052                	sd	s4,32(sp)
    800022e8:	ec56                	sd	s5,24(sp)
    800022ea:	e85a                	sd	s6,16(sp)
    800022ec:	e45e                	sd	s7,8(sp)
    800022ee:	e062                	sd	s8,0(sp)
    800022f0:	0880                	addi	s0,sp,80
    800022f2:	8792                	mv	a5,tp
  int id = r_tp();
    800022f4:	2781                	sext.w	a5,a5
  c->proc = 0;
    800022f6:	00779c13          	slli	s8,a5,0x7
    800022fa:	0000f717          	auipc	a4,0xf
    800022fe:	fa670713          	addi	a4,a4,-90 # 800112a0 <pid_lock>
    80002302:	9762                	add	a4,a4,s8
    80002304:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80002308:	0000f717          	auipc	a4,0xf
    8000230c:	fd070713          	addi	a4,a4,-48 # 800112d8 <cpus+0x8>
    80002310:	9c3a                	add	s8,s8,a4
        w_satp(MAKE_SATP(kernel_pagetable));
    80002312:	00007b17          	auipc	s6,0x7
    80002316:	d0eb0b13          	addi	s6,s6,-754 # 80009020 <kernel_pagetable>
    8000231a:	5afd                	li	s5,-1
    8000231c:	1afe                	slli	s5,s5,0x3f
        c->proc = p;
    8000231e:	079e                	slli	a5,a5,0x7
    80002320:	0000fb97          	auipc	s7,0xf
    80002324:	f80b8b93          	addi	s7,s7,-128 # 800112a0 <pid_lock>
    80002328:	9bbe                	add	s7,s7,a5
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000232a:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    8000232e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002332:	10079073          	csrw	sstatus,a5
    int found = 0;
    80002336:	4a01                	li	s4,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80002338:	0000f497          	auipc	s1,0xf
    8000233c:	39848493          	addi	s1,s1,920 # 800116d0 <proc>
      if(p->state == RUNNABLE) {
    80002340:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    80002342:	00015917          	auipc	s2,0x15
    80002346:	18e90913          	addi	s2,s2,398 # 800174d0 <tickslock>
    8000234a:	a085                	j	800023aa <scheduler+0xd0>
        p->state = RUNNING;
    8000234c:	4791                	li	a5,4
    8000234e:	cc9c                	sw	a5,24(s1)
        c->proc = p;
    80002350:	029bb823          	sd	s1,48(s7)
        w_satp(MAKE_SATP(p->k_pagetable));
    80002354:	70bc                	ld	a5,96(s1)
    80002356:	83b1                	srli	a5,a5,0xc
    80002358:	0157e7b3          	or	a5,a5,s5
  asm volatile("csrw satp, %0" : : "r"(x));
    8000235c:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80002360:	12000073          	sfence.vma
        swtch(&c->context, &p->context);
    80002364:	07048593          	addi	a1,s1,112
    80002368:	8562                	mv	a0,s8
    8000236a:	00000097          	auipc	ra,0x0
    8000236e:	670080e7          	jalr	1648(ra) # 800029da <swtch>
        c->proc = 0;
    80002372:	020bb823          	sd	zero,48(s7)
      release(&p->lock);
    80002376:	8526                	mv	a0,s1
    80002378:	fffff097          	auipc	ra,0xfffff
    8000237c:	976080e7          	jalr	-1674(ra) # 80000cee <release>
        found = 1;
    80002380:	4a05                	li	s4,1
    80002382:	a005                	j	800023a2 <scheduler+0xc8>
        w_satp(MAKE_SATP(kernel_pagetable));
    80002384:	000b3783          	ld	a5,0(s6)
    80002388:	83b1                	srli	a5,a5,0xc
    8000238a:	0157e7b3          	or	a5,a5,s5
  asm volatile("csrw satp, %0" : : "r"(x));
    8000238e:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80002392:	12000073          	sfence.vma
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002396:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    8000239a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    8000239e:	10079073          	csrw	sstatus,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800023a2:	17848493          	addi	s1,s1,376
    800023a6:	f92482e3          	beq	s1,s2,8000232a <scheduler+0x50>
      acquire(&p->lock);
    800023aa:	8526                	mv	a0,s1
    800023ac:	fffff097          	auipc	ra,0xfffff
    800023b0:	88e080e7          	jalr	-1906(ra) # 80000c3a <acquire>
      if(p->state == RUNNABLE) {
    800023b4:	4c9c                	lw	a5,24(s1)
    800023b6:	f9378be3          	beq	a5,s3,8000234c <scheduler+0x72>
      release(&p->lock);
    800023ba:	8526                	mv	a0,s1
    800023bc:	fffff097          	auipc	ra,0xfffff
    800023c0:	932080e7          	jalr	-1742(ra) # 80000cee <release>
      if (!found){
    800023c4:	fc0a00e3          	beqz	s4,80002384 <scheduler+0xaa>
    800023c8:	bfe9                	j	800023a2 <scheduler+0xc8>

00000000800023ca <sched>:
{
    800023ca:	7179                	addi	sp,sp,-48
    800023cc:	f406                	sd	ra,40(sp)
    800023ce:	f022                	sd	s0,32(sp)
    800023d0:	ec26                	sd	s1,24(sp)
    800023d2:	e84a                	sd	s2,16(sp)
    800023d4:	e44e                	sd	s3,8(sp)
    800023d6:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800023d8:	00000097          	auipc	ra,0x0
    800023dc:	894080e7          	jalr	-1900(ra) # 80001c6c <myproc>
    800023e0:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800023e2:	ffffe097          	auipc	ra,0xffffe
    800023e6:	7de080e7          	jalr	2014(ra) # 80000bc0 <holding>
    800023ea:	c93d                	beqz	a0,80002460 <sched+0x96>
  asm volatile("mv %0, tp" : "=r"(x));
    800023ec:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800023ee:	2781                	sext.w	a5,a5
    800023f0:	079e                	slli	a5,a5,0x7
    800023f2:	0000f717          	auipc	a4,0xf
    800023f6:	eae70713          	addi	a4,a4,-338 # 800112a0 <pid_lock>
    800023fa:	97ba                	add	a5,a5,a4
    800023fc:	0a87a703          	lw	a4,168(a5)
    80002400:	4785                	li	a5,1
    80002402:	06f71763          	bne	a4,a5,80002470 <sched+0xa6>
  if(p->state == RUNNING)
    80002406:	4c98                	lw	a4,24(s1)
    80002408:	4791                	li	a5,4
    8000240a:	06f70b63          	beq	a4,a5,80002480 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000240e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002412:	8b89                	andi	a5,a5,2
  if(intr_get())
    80002414:	efb5                	bnez	a5,80002490 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r"(x));
    80002416:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002418:	0000f917          	auipc	s2,0xf
    8000241c:	e8890913          	addi	s2,s2,-376 # 800112a0 <pid_lock>
    80002420:	2781                	sext.w	a5,a5
    80002422:	079e                	slli	a5,a5,0x7
    80002424:	97ca                	add	a5,a5,s2
    80002426:	0ac7a983          	lw	s3,172(a5)
    8000242a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000242c:	2781                	sext.w	a5,a5
    8000242e:	079e                	slli	a5,a5,0x7
    80002430:	0000f597          	auipc	a1,0xf
    80002434:	ea858593          	addi	a1,a1,-344 # 800112d8 <cpus+0x8>
    80002438:	95be                	add	a1,a1,a5
    8000243a:	07048513          	addi	a0,s1,112
    8000243e:	00000097          	auipc	ra,0x0
    80002442:	59c080e7          	jalr	1436(ra) # 800029da <swtch>
    80002446:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002448:	2781                	sext.w	a5,a5
    8000244a:	079e                	slli	a5,a5,0x7
    8000244c:	97ca                	add	a5,a5,s2
    8000244e:	0b37a623          	sw	s3,172(a5)
}
    80002452:	70a2                	ld	ra,40(sp)
    80002454:	7402                	ld	s0,32(sp)
    80002456:	64e2                	ld	s1,24(sp)
    80002458:	6942                	ld	s2,16(sp)
    8000245a:	69a2                	ld	s3,8(sp)
    8000245c:	6145                	addi	sp,sp,48
    8000245e:	8082                	ret
    panic("sched p->lock");
    80002460:	00006517          	auipc	a0,0x6
    80002464:	ec050513          	addi	a0,a0,-320 # 80008320 <digits+0x2b8>
    80002468:	ffffe097          	auipc	ra,0xffffe
    8000246c:	164080e7          	jalr	356(ra) # 800005cc <panic>
    panic("sched locks");
    80002470:	00006517          	auipc	a0,0x6
    80002474:	ec050513          	addi	a0,a0,-320 # 80008330 <digits+0x2c8>
    80002478:	ffffe097          	auipc	ra,0xffffe
    8000247c:	154080e7          	jalr	340(ra) # 800005cc <panic>
    panic("sched running");
    80002480:	00006517          	auipc	a0,0x6
    80002484:	ec050513          	addi	a0,a0,-320 # 80008340 <digits+0x2d8>
    80002488:	ffffe097          	auipc	ra,0xffffe
    8000248c:	144080e7          	jalr	324(ra) # 800005cc <panic>
    panic("sched interruptible");
    80002490:	00006517          	auipc	a0,0x6
    80002494:	ec050513          	addi	a0,a0,-320 # 80008350 <digits+0x2e8>
    80002498:	ffffe097          	auipc	ra,0xffffe
    8000249c:	134080e7          	jalr	308(ra) # 800005cc <panic>

00000000800024a0 <yield>:
{
    800024a0:	1101                	addi	sp,sp,-32
    800024a2:	ec06                	sd	ra,24(sp)
    800024a4:	e822                	sd	s0,16(sp)
    800024a6:	e426                	sd	s1,8(sp)
    800024a8:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800024aa:	fffff097          	auipc	ra,0xfffff
    800024ae:	7c2080e7          	jalr	1986(ra) # 80001c6c <myproc>
    800024b2:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800024b4:	ffffe097          	auipc	ra,0xffffe
    800024b8:	786080e7          	jalr	1926(ra) # 80000c3a <acquire>
  p->state = RUNNABLE;
    800024bc:	478d                	li	a5,3
    800024be:	cc9c                	sw	a5,24(s1)
  sched();
    800024c0:	00000097          	auipc	ra,0x0
    800024c4:	f0a080e7          	jalr	-246(ra) # 800023ca <sched>
  release(&p->lock);
    800024c8:	8526                	mv	a0,s1
    800024ca:	fffff097          	auipc	ra,0xfffff
    800024ce:	824080e7          	jalr	-2012(ra) # 80000cee <release>
}
    800024d2:	60e2                	ld	ra,24(sp)
    800024d4:	6442                	ld	s0,16(sp)
    800024d6:	64a2                	ld	s1,8(sp)
    800024d8:	6105                	addi	sp,sp,32
    800024da:	8082                	ret

00000000800024dc <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800024dc:	7179                	addi	sp,sp,-48
    800024de:	f406                	sd	ra,40(sp)
    800024e0:	f022                	sd	s0,32(sp)
    800024e2:	ec26                	sd	s1,24(sp)
    800024e4:	e84a                	sd	s2,16(sp)
    800024e6:	e44e                	sd	s3,8(sp)
    800024e8:	1800                	addi	s0,sp,48
    800024ea:	89aa                	mv	s3,a0
    800024ec:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800024ee:	fffff097          	auipc	ra,0xfffff
    800024f2:	77e080e7          	jalr	1918(ra) # 80001c6c <myproc>
    800024f6:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800024f8:	ffffe097          	auipc	ra,0xffffe
    800024fc:	742080e7          	jalr	1858(ra) # 80000c3a <acquire>
  release(lk);
    80002500:	854a                	mv	a0,s2
    80002502:	ffffe097          	auipc	ra,0xffffe
    80002506:	7ec080e7          	jalr	2028(ra) # 80000cee <release>

  // Go to sleep.
  p->chan = chan;
    8000250a:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000250e:	4789                	li	a5,2
    80002510:	cc9c                	sw	a5,24(s1)

  sched();
    80002512:	00000097          	auipc	ra,0x0
    80002516:	eb8080e7          	jalr	-328(ra) # 800023ca <sched>

  // Tidy up.
  p->chan = 0;
    8000251a:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000251e:	8526                	mv	a0,s1
    80002520:	ffffe097          	auipc	ra,0xffffe
    80002524:	7ce080e7          	jalr	1998(ra) # 80000cee <release>
  acquire(lk);
    80002528:	854a                	mv	a0,s2
    8000252a:	ffffe097          	auipc	ra,0xffffe
    8000252e:	710080e7          	jalr	1808(ra) # 80000c3a <acquire>
}
    80002532:	70a2                	ld	ra,40(sp)
    80002534:	7402                	ld	s0,32(sp)
    80002536:	64e2                	ld	s1,24(sp)
    80002538:	6942                	ld	s2,16(sp)
    8000253a:	69a2                	ld	s3,8(sp)
    8000253c:	6145                	addi	sp,sp,48
    8000253e:	8082                	ret

0000000080002540 <wait>:
{
    80002540:	715d                	addi	sp,sp,-80
    80002542:	e486                	sd	ra,72(sp)
    80002544:	e0a2                	sd	s0,64(sp)
    80002546:	fc26                	sd	s1,56(sp)
    80002548:	f84a                	sd	s2,48(sp)
    8000254a:	f44e                	sd	s3,40(sp)
    8000254c:	f052                	sd	s4,32(sp)
    8000254e:	ec56                	sd	s5,24(sp)
    80002550:	e85a                	sd	s6,16(sp)
    80002552:	e45e                	sd	s7,8(sp)
    80002554:	e062                	sd	s8,0(sp)
    80002556:	0880                	addi	s0,sp,80
    80002558:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000255a:	fffff097          	auipc	ra,0xfffff
    8000255e:	712080e7          	jalr	1810(ra) # 80001c6c <myproc>
    80002562:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002564:	0000f517          	auipc	a0,0xf
    80002568:	d5450513          	addi	a0,a0,-684 # 800112b8 <wait_lock>
    8000256c:	ffffe097          	auipc	ra,0xffffe
    80002570:	6ce080e7          	jalr	1742(ra) # 80000c3a <acquire>
    havekids = 0;
    80002574:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80002576:	4a15                	li	s4,5
        havekids = 1;
    80002578:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    8000257a:	00015997          	auipc	s3,0x15
    8000257e:	f5698993          	addi	s3,s3,-170 # 800174d0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002582:	0000fc17          	auipc	s8,0xf
    80002586:	d36c0c13          	addi	s8,s8,-714 # 800112b8 <wait_lock>
    havekids = 0;
    8000258a:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000258c:	0000f497          	auipc	s1,0xf
    80002590:	14448493          	addi	s1,s1,324 # 800116d0 <proc>
    80002594:	a0bd                	j	80002602 <wait+0xc2>
          pid = np->pid;
    80002596:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000259a:	000b0e63          	beqz	s6,800025b6 <wait+0x76>
    8000259e:	4691                	li	a3,4
    800025a0:	02c48613          	addi	a2,s1,44
    800025a4:	85da                	mv	a1,s6
    800025a6:	05893503          	ld	a0,88(s2)
    800025aa:	fffff097          	auipc	ra,0xfffff
    800025ae:	2b2080e7          	jalr	690(ra) # 8000185c <copyout>
    800025b2:	02054563          	bltz	a0,800025dc <wait+0x9c>
          freeproc(np);
    800025b6:	8526                	mv	a0,s1
    800025b8:	00000097          	auipc	ra,0x0
    800025bc:	866080e7          	jalr	-1946(ra) # 80001e1e <freeproc>
          release(&np->lock);
    800025c0:	8526                	mv	a0,s1
    800025c2:	ffffe097          	auipc	ra,0xffffe
    800025c6:	72c080e7          	jalr	1836(ra) # 80000cee <release>
          release(&wait_lock);
    800025ca:	0000f517          	auipc	a0,0xf
    800025ce:	cee50513          	addi	a0,a0,-786 # 800112b8 <wait_lock>
    800025d2:	ffffe097          	auipc	ra,0xffffe
    800025d6:	71c080e7          	jalr	1820(ra) # 80000cee <release>
          return pid;
    800025da:	a09d                	j	80002640 <wait+0x100>
            release(&np->lock);
    800025dc:	8526                	mv	a0,s1
    800025de:	ffffe097          	auipc	ra,0xffffe
    800025e2:	710080e7          	jalr	1808(ra) # 80000cee <release>
            release(&wait_lock);
    800025e6:	0000f517          	auipc	a0,0xf
    800025ea:	cd250513          	addi	a0,a0,-814 # 800112b8 <wait_lock>
    800025ee:	ffffe097          	auipc	ra,0xffffe
    800025f2:	700080e7          	jalr	1792(ra) # 80000cee <release>
            return -1;
    800025f6:	59fd                	li	s3,-1
    800025f8:	a0a1                	j	80002640 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    800025fa:	17848493          	addi	s1,s1,376
    800025fe:	03348463          	beq	s1,s3,80002626 <wait+0xe6>
      if(np->parent == p){
    80002602:	7c9c                	ld	a5,56(s1)
    80002604:	ff279be3          	bne	a5,s2,800025fa <wait+0xba>
        acquire(&np->lock);
    80002608:	8526                	mv	a0,s1
    8000260a:	ffffe097          	auipc	ra,0xffffe
    8000260e:	630080e7          	jalr	1584(ra) # 80000c3a <acquire>
        if(np->state == ZOMBIE){
    80002612:	4c9c                	lw	a5,24(s1)
    80002614:	f94781e3          	beq	a5,s4,80002596 <wait+0x56>
        release(&np->lock);
    80002618:	8526                	mv	a0,s1
    8000261a:	ffffe097          	auipc	ra,0xffffe
    8000261e:	6d4080e7          	jalr	1748(ra) # 80000cee <release>
        havekids = 1;
    80002622:	8756                	mv	a4,s5
    80002624:	bfd9                	j	800025fa <wait+0xba>
    if(!havekids || p->killed){
    80002626:	c701                	beqz	a4,8000262e <wait+0xee>
    80002628:	02892783          	lw	a5,40(s2)
    8000262c:	c79d                	beqz	a5,8000265a <wait+0x11a>
      release(&wait_lock);
    8000262e:	0000f517          	auipc	a0,0xf
    80002632:	c8a50513          	addi	a0,a0,-886 # 800112b8 <wait_lock>
    80002636:	ffffe097          	auipc	ra,0xffffe
    8000263a:	6b8080e7          	jalr	1720(ra) # 80000cee <release>
      return -1;
    8000263e:	59fd                	li	s3,-1
}
    80002640:	854e                	mv	a0,s3
    80002642:	60a6                	ld	ra,72(sp)
    80002644:	6406                	ld	s0,64(sp)
    80002646:	74e2                	ld	s1,56(sp)
    80002648:	7942                	ld	s2,48(sp)
    8000264a:	79a2                	ld	s3,40(sp)
    8000264c:	7a02                	ld	s4,32(sp)
    8000264e:	6ae2                	ld	s5,24(sp)
    80002650:	6b42                	ld	s6,16(sp)
    80002652:	6ba2                	ld	s7,8(sp)
    80002654:	6c02                	ld	s8,0(sp)
    80002656:	6161                	addi	sp,sp,80
    80002658:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000265a:	85e2                	mv	a1,s8
    8000265c:	854a                	mv	a0,s2
    8000265e:	00000097          	auipc	ra,0x0
    80002662:	e7e080e7          	jalr	-386(ra) # 800024dc <sleep>
    havekids = 0;
    80002666:	b715                	j	8000258a <wait+0x4a>

0000000080002668 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80002668:	7139                	addi	sp,sp,-64
    8000266a:	fc06                	sd	ra,56(sp)
    8000266c:	f822                	sd	s0,48(sp)
    8000266e:	f426                	sd	s1,40(sp)
    80002670:	f04a                	sd	s2,32(sp)
    80002672:	ec4e                	sd	s3,24(sp)
    80002674:	e852                	sd	s4,16(sp)
    80002676:	e456                	sd	s5,8(sp)
    80002678:	0080                	addi	s0,sp,64
    8000267a:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000267c:	0000f497          	auipc	s1,0xf
    80002680:	05448493          	addi	s1,s1,84 # 800116d0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80002684:	4989                	li	s3,2
        p->state = RUNNABLE;
    80002686:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80002688:	00015917          	auipc	s2,0x15
    8000268c:	e4890913          	addi	s2,s2,-440 # 800174d0 <tickslock>
    80002690:	a811                	j	800026a4 <wakeup+0x3c>
      }
      release(&p->lock);
    80002692:	8526                	mv	a0,s1
    80002694:	ffffe097          	auipc	ra,0xffffe
    80002698:	65a080e7          	jalr	1626(ra) # 80000cee <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000269c:	17848493          	addi	s1,s1,376
    800026a0:	03248663          	beq	s1,s2,800026cc <wakeup+0x64>
    if(p != myproc()){
    800026a4:	fffff097          	auipc	ra,0xfffff
    800026a8:	5c8080e7          	jalr	1480(ra) # 80001c6c <myproc>
    800026ac:	fea488e3          	beq	s1,a0,8000269c <wakeup+0x34>
      acquire(&p->lock);
    800026b0:	8526                	mv	a0,s1
    800026b2:	ffffe097          	auipc	ra,0xffffe
    800026b6:	588080e7          	jalr	1416(ra) # 80000c3a <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800026ba:	4c9c                	lw	a5,24(s1)
    800026bc:	fd379be3          	bne	a5,s3,80002692 <wakeup+0x2a>
    800026c0:	709c                	ld	a5,32(s1)
    800026c2:	fd4798e3          	bne	a5,s4,80002692 <wakeup+0x2a>
        p->state = RUNNABLE;
    800026c6:	0154ac23          	sw	s5,24(s1)
    800026ca:	b7e1                	j	80002692 <wakeup+0x2a>
    }
  }
}
    800026cc:	70e2                	ld	ra,56(sp)
    800026ce:	7442                	ld	s0,48(sp)
    800026d0:	74a2                	ld	s1,40(sp)
    800026d2:	7902                	ld	s2,32(sp)
    800026d4:	69e2                	ld	s3,24(sp)
    800026d6:	6a42                	ld	s4,16(sp)
    800026d8:	6aa2                	ld	s5,8(sp)
    800026da:	6121                	addi	sp,sp,64
    800026dc:	8082                	ret

00000000800026de <reparent>:
{
    800026de:	7179                	addi	sp,sp,-48
    800026e0:	f406                	sd	ra,40(sp)
    800026e2:	f022                	sd	s0,32(sp)
    800026e4:	ec26                	sd	s1,24(sp)
    800026e6:	e84a                	sd	s2,16(sp)
    800026e8:	e44e                	sd	s3,8(sp)
    800026ea:	e052                	sd	s4,0(sp)
    800026ec:	1800                	addi	s0,sp,48
    800026ee:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800026f0:	0000f497          	auipc	s1,0xf
    800026f4:	fe048493          	addi	s1,s1,-32 # 800116d0 <proc>
      pp->parent = initproc;
    800026f8:	00007a17          	auipc	s4,0x7
    800026fc:	930a0a13          	addi	s4,s4,-1744 # 80009028 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002700:	00015997          	auipc	s3,0x15
    80002704:	dd098993          	addi	s3,s3,-560 # 800174d0 <tickslock>
    80002708:	a029                	j	80002712 <reparent+0x34>
    8000270a:	17848493          	addi	s1,s1,376
    8000270e:	01348d63          	beq	s1,s3,80002728 <reparent+0x4a>
    if(pp->parent == p){
    80002712:	7c9c                	ld	a5,56(s1)
    80002714:	ff279be3          	bne	a5,s2,8000270a <reparent+0x2c>
      pp->parent = initproc;
    80002718:	000a3503          	ld	a0,0(s4)
    8000271c:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000271e:	00000097          	auipc	ra,0x0
    80002722:	f4a080e7          	jalr	-182(ra) # 80002668 <wakeup>
    80002726:	b7d5                	j	8000270a <reparent+0x2c>
}
    80002728:	70a2                	ld	ra,40(sp)
    8000272a:	7402                	ld	s0,32(sp)
    8000272c:	64e2                	ld	s1,24(sp)
    8000272e:	6942                	ld	s2,16(sp)
    80002730:	69a2                	ld	s3,8(sp)
    80002732:	6a02                	ld	s4,0(sp)
    80002734:	6145                	addi	sp,sp,48
    80002736:	8082                	ret

0000000080002738 <exit>:
{
    80002738:	7179                	addi	sp,sp,-48
    8000273a:	f406                	sd	ra,40(sp)
    8000273c:	f022                	sd	s0,32(sp)
    8000273e:	ec26                	sd	s1,24(sp)
    80002740:	e84a                	sd	s2,16(sp)
    80002742:	e44e                	sd	s3,8(sp)
    80002744:	e052                	sd	s4,0(sp)
    80002746:	1800                	addi	s0,sp,48
    80002748:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000274a:	fffff097          	auipc	ra,0xfffff
    8000274e:	522080e7          	jalr	1314(ra) # 80001c6c <myproc>
    80002752:	89aa                	mv	s3,a0
  if(p == initproc)
    80002754:	00007797          	auipc	a5,0x7
    80002758:	8d47b783          	ld	a5,-1836(a5) # 80009028 <initproc>
    8000275c:	0e050493          	addi	s1,a0,224
    80002760:	16050913          	addi	s2,a0,352
    80002764:	02a79363          	bne	a5,a0,8000278a <exit+0x52>
    panic("init exiting");
    80002768:	00006517          	auipc	a0,0x6
    8000276c:	c0050513          	addi	a0,a0,-1024 # 80008368 <digits+0x300>
    80002770:	ffffe097          	auipc	ra,0xffffe
    80002774:	e5c080e7          	jalr	-420(ra) # 800005cc <panic>
      fileclose(f);
    80002778:	00002097          	auipc	ra,0x2
    8000277c:	1e2080e7          	jalr	482(ra) # 8000495a <fileclose>
      p->ofile[fd] = 0;
    80002780:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002784:	04a1                	addi	s1,s1,8
    80002786:	01248563          	beq	s1,s2,80002790 <exit+0x58>
    if(p->ofile[fd]){
    8000278a:	6088                	ld	a0,0(s1)
    8000278c:	f575                	bnez	a0,80002778 <exit+0x40>
    8000278e:	bfdd                	j	80002784 <exit+0x4c>
  begin_op();
    80002790:	00002097          	auipc	ra,0x2
    80002794:	cfe080e7          	jalr	-770(ra) # 8000448e <begin_op>
  iput(p->cwd);
    80002798:	1609b503          	ld	a0,352(s3)
    8000279c:	00001097          	auipc	ra,0x1
    800027a0:	4da080e7          	jalr	1242(ra) # 80003c76 <iput>
  end_op();
    800027a4:	00002097          	auipc	ra,0x2
    800027a8:	d6a080e7          	jalr	-662(ra) # 8000450e <end_op>
  p->cwd = 0;
    800027ac:	1609b023          	sd	zero,352(s3)
  acquire(&wait_lock);
    800027b0:	0000f497          	auipc	s1,0xf
    800027b4:	b0848493          	addi	s1,s1,-1272 # 800112b8 <wait_lock>
    800027b8:	8526                	mv	a0,s1
    800027ba:	ffffe097          	auipc	ra,0xffffe
    800027be:	480080e7          	jalr	1152(ra) # 80000c3a <acquire>
  reparent(p);
    800027c2:	854e                	mv	a0,s3
    800027c4:	00000097          	auipc	ra,0x0
    800027c8:	f1a080e7          	jalr	-230(ra) # 800026de <reparent>
  wakeup(p->parent);
    800027cc:	0389b503          	ld	a0,56(s3)
    800027d0:	00000097          	auipc	ra,0x0
    800027d4:	e98080e7          	jalr	-360(ra) # 80002668 <wakeup>
  acquire(&p->lock);
    800027d8:	854e                	mv	a0,s3
    800027da:	ffffe097          	auipc	ra,0xffffe
    800027de:	460080e7          	jalr	1120(ra) # 80000c3a <acquire>
  p->xstate = status;
    800027e2:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800027e6:	4795                	li	a5,5
    800027e8:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800027ec:	8526                	mv	a0,s1
    800027ee:	ffffe097          	auipc	ra,0xffffe
    800027f2:	500080e7          	jalr	1280(ra) # 80000cee <release>
  sched();
    800027f6:	00000097          	auipc	ra,0x0
    800027fa:	bd4080e7          	jalr	-1068(ra) # 800023ca <sched>
  panic("zombie exit");
    800027fe:	00006517          	auipc	a0,0x6
    80002802:	b7a50513          	addi	a0,a0,-1158 # 80008378 <digits+0x310>
    80002806:	ffffe097          	auipc	ra,0xffffe
    8000280a:	dc6080e7          	jalr	-570(ra) # 800005cc <panic>

000000008000280e <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000280e:	7179                	addi	sp,sp,-48
    80002810:	f406                	sd	ra,40(sp)
    80002812:	f022                	sd	s0,32(sp)
    80002814:	ec26                	sd	s1,24(sp)
    80002816:	e84a                	sd	s2,16(sp)
    80002818:	e44e                	sd	s3,8(sp)
    8000281a:	1800                	addi	s0,sp,48
    8000281c:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000281e:	0000f497          	auipc	s1,0xf
    80002822:	eb248493          	addi	s1,s1,-334 # 800116d0 <proc>
    80002826:	00015997          	auipc	s3,0x15
    8000282a:	caa98993          	addi	s3,s3,-854 # 800174d0 <tickslock>
    acquire(&p->lock);
    8000282e:	8526                	mv	a0,s1
    80002830:	ffffe097          	auipc	ra,0xffffe
    80002834:	40a080e7          	jalr	1034(ra) # 80000c3a <acquire>
    if(p->pid == pid){
    80002838:	589c                	lw	a5,48(s1)
    8000283a:	01278d63          	beq	a5,s2,80002854 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000283e:	8526                	mv	a0,s1
    80002840:	ffffe097          	auipc	ra,0xffffe
    80002844:	4ae080e7          	jalr	1198(ra) # 80000cee <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002848:	17848493          	addi	s1,s1,376
    8000284c:	ff3491e3          	bne	s1,s3,8000282e <kill+0x20>
  }
  return -1;
    80002850:	557d                	li	a0,-1
    80002852:	a829                	j	8000286c <kill+0x5e>
      p->killed = 1;
    80002854:	4785                	li	a5,1
    80002856:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002858:	4c98                	lw	a4,24(s1)
    8000285a:	4789                	li	a5,2
    8000285c:	00f70f63          	beq	a4,a5,8000287a <kill+0x6c>
      release(&p->lock);
    80002860:	8526                	mv	a0,s1
    80002862:	ffffe097          	auipc	ra,0xffffe
    80002866:	48c080e7          	jalr	1164(ra) # 80000cee <release>
      return 0;
    8000286a:	4501                	li	a0,0
}
    8000286c:	70a2                	ld	ra,40(sp)
    8000286e:	7402                	ld	s0,32(sp)
    80002870:	64e2                	ld	s1,24(sp)
    80002872:	6942                	ld	s2,16(sp)
    80002874:	69a2                	ld	s3,8(sp)
    80002876:	6145                	addi	sp,sp,48
    80002878:	8082                	ret
        p->state = RUNNABLE;
    8000287a:	478d                	li	a5,3
    8000287c:	cc9c                	sw	a5,24(s1)
    8000287e:	b7cd                	j	80002860 <kill+0x52>

0000000080002880 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002880:	7179                	addi	sp,sp,-48
    80002882:	f406                	sd	ra,40(sp)
    80002884:	f022                	sd	s0,32(sp)
    80002886:	ec26                	sd	s1,24(sp)
    80002888:	e84a                	sd	s2,16(sp)
    8000288a:	e44e                	sd	s3,8(sp)
    8000288c:	e052                	sd	s4,0(sp)
    8000288e:	1800                	addi	s0,sp,48
    80002890:	84aa                	mv	s1,a0
    80002892:	892e                	mv	s2,a1
    80002894:	89b2                	mv	s3,a2
    80002896:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002898:	fffff097          	auipc	ra,0xfffff
    8000289c:	3d4080e7          	jalr	980(ra) # 80001c6c <myproc>
  if(user_dst){
    800028a0:	c08d                	beqz	s1,800028c2 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800028a2:	86d2                	mv	a3,s4
    800028a4:	864e                	mv	a2,s3
    800028a6:	85ca                	mv	a1,s2
    800028a8:	6d28                	ld	a0,88(a0)
    800028aa:	fffff097          	auipc	ra,0xfffff
    800028ae:	fb2080e7          	jalr	-78(ra) # 8000185c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800028b2:	70a2                	ld	ra,40(sp)
    800028b4:	7402                	ld	s0,32(sp)
    800028b6:	64e2                	ld	s1,24(sp)
    800028b8:	6942                	ld	s2,16(sp)
    800028ba:	69a2                	ld	s3,8(sp)
    800028bc:	6a02                	ld	s4,0(sp)
    800028be:	6145                	addi	sp,sp,48
    800028c0:	8082                	ret
    memmove((char *)dst, src, len);
    800028c2:	000a061b          	sext.w	a2,s4
    800028c6:	85ce                	mv	a1,s3
    800028c8:	854a                	mv	a0,s2
    800028ca:	ffffe097          	auipc	ra,0xffffe
    800028ce:	4c8080e7          	jalr	1224(ra) # 80000d92 <memmove>
    return 0;
    800028d2:	8526                	mv	a0,s1
    800028d4:	bff9                	j	800028b2 <either_copyout+0x32>

00000000800028d6 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800028d6:	7179                	addi	sp,sp,-48
    800028d8:	f406                	sd	ra,40(sp)
    800028da:	f022                	sd	s0,32(sp)
    800028dc:	ec26                	sd	s1,24(sp)
    800028de:	e84a                	sd	s2,16(sp)
    800028e0:	e44e                	sd	s3,8(sp)
    800028e2:	e052                	sd	s4,0(sp)
    800028e4:	1800                	addi	s0,sp,48
    800028e6:	892a                	mv	s2,a0
    800028e8:	84ae                	mv	s1,a1
    800028ea:	89b2                	mv	s3,a2
    800028ec:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800028ee:	fffff097          	auipc	ra,0xfffff
    800028f2:	37e080e7          	jalr	894(ra) # 80001c6c <myproc>
  if(user_src){
    800028f6:	c08d                	beqz	s1,80002918 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800028f8:	86d2                	mv	a3,s4
    800028fa:	864e                	mv	a2,s3
    800028fc:	85ca                	mv	a1,s2
    800028fe:	6d28                	ld	a0,88(a0)
    80002900:	fffff097          	auipc	ra,0xfffff
    80002904:	062080e7          	jalr	98(ra) # 80001962 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002908:	70a2                	ld	ra,40(sp)
    8000290a:	7402                	ld	s0,32(sp)
    8000290c:	64e2                	ld	s1,24(sp)
    8000290e:	6942                	ld	s2,16(sp)
    80002910:	69a2                	ld	s3,8(sp)
    80002912:	6a02                	ld	s4,0(sp)
    80002914:	6145                	addi	sp,sp,48
    80002916:	8082                	ret
    memmove(dst, (char*)src, len);
    80002918:	000a061b          	sext.w	a2,s4
    8000291c:	85ce                	mv	a1,s3
    8000291e:	854a                	mv	a0,s2
    80002920:	ffffe097          	auipc	ra,0xffffe
    80002924:	472080e7          	jalr	1138(ra) # 80000d92 <memmove>
    return 0;
    80002928:	8526                	mv	a0,s1
    8000292a:	bff9                	j	80002908 <either_copyin+0x32>

000000008000292c <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000292c:	715d                	addi	sp,sp,-80
    8000292e:	e486                	sd	ra,72(sp)
    80002930:	e0a2                	sd	s0,64(sp)
    80002932:	fc26                	sd	s1,56(sp)
    80002934:	f84a                	sd	s2,48(sp)
    80002936:	f44e                	sd	s3,40(sp)
    80002938:	f052                	sd	s4,32(sp)
    8000293a:	ec56                	sd	s5,24(sp)
    8000293c:	e85a                	sd	s6,16(sp)
    8000293e:	e45e                	sd	s7,8(sp)
    80002940:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002942:	00005517          	auipc	a0,0x5
    80002946:	7ae50513          	addi	a0,a0,1966 # 800080f0 <digits+0x88>
    8000294a:	ffffe097          	auipc	ra,0xffffe
    8000294e:	cd4080e7          	jalr	-812(ra) # 8000061e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002952:	0000f497          	auipc	s1,0xf
    80002956:	ee648493          	addi	s1,s1,-282 # 80011838 <proc+0x168>
    8000295a:	00015917          	auipc	s2,0x15
    8000295e:	cde90913          	addi	s2,s2,-802 # 80017638 <bcache+0x150>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002962:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002964:	00006997          	auipc	s3,0x6
    80002968:	a2498993          	addi	s3,s3,-1500 # 80008388 <digits+0x320>
    printf("%d %s %s", p->pid, state, p->name);
    8000296c:	00006a97          	auipc	s5,0x6
    80002970:	a24a8a93          	addi	s5,s5,-1500 # 80008390 <digits+0x328>
    printf("\n");
    80002974:	00005a17          	auipc	s4,0x5
    80002978:	77ca0a13          	addi	s4,s4,1916 # 800080f0 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000297c:	00006b97          	auipc	s7,0x6
    80002980:	a4cb8b93          	addi	s7,s7,-1460 # 800083c8 <states.0>
    80002984:	a00d                	j	800029a6 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80002986:	ec86a583          	lw	a1,-312(a3)
    8000298a:	8556                	mv	a0,s5
    8000298c:	ffffe097          	auipc	ra,0xffffe
    80002990:	c92080e7          	jalr	-878(ra) # 8000061e <printf>
    printf("\n");
    80002994:	8552                	mv	a0,s4
    80002996:	ffffe097          	auipc	ra,0xffffe
    8000299a:	c88080e7          	jalr	-888(ra) # 8000061e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000299e:	17848493          	addi	s1,s1,376
    800029a2:	03248163          	beq	s1,s2,800029c4 <procdump+0x98>
    if(p->state == UNUSED)
    800029a6:	86a6                	mv	a3,s1
    800029a8:	eb04a783          	lw	a5,-336(s1)
    800029ac:	dbed                	beqz	a5,8000299e <procdump+0x72>
      state = "???";
    800029ae:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800029b0:	fcfb6be3          	bltu	s6,a5,80002986 <procdump+0x5a>
    800029b4:	1782                	slli	a5,a5,0x20
    800029b6:	9381                	srli	a5,a5,0x20
    800029b8:	078e                	slli	a5,a5,0x3
    800029ba:	97de                	add	a5,a5,s7
    800029bc:	6390                	ld	a2,0(a5)
    800029be:	f661                	bnez	a2,80002986 <procdump+0x5a>
      state = "???";
    800029c0:	864e                	mv	a2,s3
    800029c2:	b7d1                	j	80002986 <procdump+0x5a>
  }
}
    800029c4:	60a6                	ld	ra,72(sp)
    800029c6:	6406                	ld	s0,64(sp)
    800029c8:	74e2                	ld	s1,56(sp)
    800029ca:	7942                	ld	s2,48(sp)
    800029cc:	79a2                	ld	s3,40(sp)
    800029ce:	7a02                	ld	s4,32(sp)
    800029d0:	6ae2                	ld	s5,24(sp)
    800029d2:	6b42                	ld	s6,16(sp)
    800029d4:	6ba2                	ld	s7,8(sp)
    800029d6:	6161                	addi	sp,sp,80
    800029d8:	8082                	ret

00000000800029da <swtch>:
    800029da:	00153023          	sd	ra,0(a0)
    800029de:	00253423          	sd	sp,8(a0)
    800029e2:	e900                	sd	s0,16(a0)
    800029e4:	ed04                	sd	s1,24(a0)
    800029e6:	03253023          	sd	s2,32(a0)
    800029ea:	03353423          	sd	s3,40(a0)
    800029ee:	03453823          	sd	s4,48(a0)
    800029f2:	03553c23          	sd	s5,56(a0)
    800029f6:	05653023          	sd	s6,64(a0)
    800029fa:	05753423          	sd	s7,72(a0)
    800029fe:	05853823          	sd	s8,80(a0)
    80002a02:	05953c23          	sd	s9,88(a0)
    80002a06:	07a53023          	sd	s10,96(a0)
    80002a0a:	07b53423          	sd	s11,104(a0)
    80002a0e:	0005b083          	ld	ra,0(a1)
    80002a12:	0085b103          	ld	sp,8(a1)
    80002a16:	6980                	ld	s0,16(a1)
    80002a18:	6d84                	ld	s1,24(a1)
    80002a1a:	0205b903          	ld	s2,32(a1)
    80002a1e:	0285b983          	ld	s3,40(a1)
    80002a22:	0305ba03          	ld	s4,48(a1)
    80002a26:	0385ba83          	ld	s5,56(a1)
    80002a2a:	0405bb03          	ld	s6,64(a1)
    80002a2e:	0485bb83          	ld	s7,72(a1)
    80002a32:	0505bc03          	ld	s8,80(a1)
    80002a36:	0585bc83          	ld	s9,88(a1)
    80002a3a:	0605bd03          	ld	s10,96(a1)
    80002a3e:	0685bd83          	ld	s11,104(a1)
    80002a42:	8082                	ret

0000000080002a44 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002a44:	1141                	addi	sp,sp,-16
    80002a46:	e406                	sd	ra,8(sp)
    80002a48:	e022                	sd	s0,0(sp)
    80002a4a:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002a4c:	00006597          	auipc	a1,0x6
    80002a50:	9ac58593          	addi	a1,a1,-1620 # 800083f8 <states.0+0x30>
    80002a54:	00015517          	auipc	a0,0x15
    80002a58:	a7c50513          	addi	a0,a0,-1412 # 800174d0 <tickslock>
    80002a5c:	ffffe097          	auipc	ra,0xffffe
    80002a60:	14e080e7          	jalr	334(ra) # 80000baa <initlock>
}
    80002a64:	60a2                	ld	ra,8(sp)
    80002a66:	6402                	ld	s0,0(sp)
    80002a68:	0141                	addi	sp,sp,16
    80002a6a:	8082                	ret

0000000080002a6c <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002a6c:	1141                	addi	sp,sp,-16
    80002a6e:	e422                	sd	s0,8(sp)
    80002a70:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002a72:	00003797          	auipc	a5,0x3
    80002a76:	54e78793          	addi	a5,a5,1358 # 80005fc0 <kernelvec>
    80002a7a:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002a7e:	6422                	ld	s0,8(sp)
    80002a80:	0141                	addi	sp,sp,16
    80002a82:	8082                	ret

0000000080002a84 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002a84:	1141                	addi	sp,sp,-16
    80002a86:	e406                	sd	ra,8(sp)
    80002a88:	e022                	sd	s0,0(sp)
    80002a8a:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002a8c:	fffff097          	auipc	ra,0xfffff
    80002a90:	1e0080e7          	jalr	480(ra) # 80001c6c <myproc>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002a94:	100027f3          	csrr	a5,sstatus
static inline void intr_off() { w_sstatus(r_sstatus() & ~SSTATUS_SIE); }
    80002a98:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002a9a:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002a9e:	00004617          	auipc	a2,0x4
    80002aa2:	56260613          	addi	a2,a2,1378 # 80007000 <_trampoline>
    80002aa6:	00004697          	auipc	a3,0x4
    80002aaa:	55a68693          	addi	a3,a3,1370 # 80007000 <_trampoline>
    80002aae:	8e91                	sub	a3,a3,a2
    80002ab0:	040007b7          	lui	a5,0x4000
    80002ab4:	17fd                	addi	a5,a5,-1
    80002ab6:	07b2                	slli	a5,a5,0xc
    80002ab8:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002aba:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002abe:	7538                	ld	a4,104(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    80002ac0:	180026f3          	csrr	a3,satp
    80002ac4:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002ac6:	7538                	ld	a4,104(a0)
    80002ac8:	6534                	ld	a3,72(a0)
    80002aca:	6585                	lui	a1,0x1
    80002acc:	96ae                	add	a3,a3,a1
    80002ace:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002ad0:	7538                	ld	a4,104(a0)
    80002ad2:	00000697          	auipc	a3,0x0
    80002ad6:	13868693          	addi	a3,a3,312 # 80002c0a <usertrap>
    80002ada:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002adc:	7538                	ld	a4,104(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    80002ade:	8692                	mv	a3,tp
    80002ae0:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002ae2:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002ae6:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002aea:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002aee:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002af2:	7538                	ld	a4,104(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    80002af4:	6f18                	ld	a4,24(a4)
    80002af6:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002afa:	6d2c                	ld	a1,88(a0)
    80002afc:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80002afe:	00004717          	auipc	a4,0x4
    80002b02:	59270713          	addi	a4,a4,1426 # 80007090 <userret>
    80002b06:	8f11                	sub	a4,a4,a2
    80002b08:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80002b0a:	577d                	li	a4,-1
    80002b0c:	177e                	slli	a4,a4,0x3f
    80002b0e:	8dd9                	or	a1,a1,a4
    80002b10:	02000537          	lui	a0,0x2000
    80002b14:	157d                	addi	a0,a0,-1
    80002b16:	0536                	slli	a0,a0,0xd
    80002b18:	9782                	jalr	a5
}
    80002b1a:	60a2                	ld	ra,8(sp)
    80002b1c:	6402                	ld	s0,0(sp)
    80002b1e:	0141                	addi	sp,sp,16
    80002b20:	8082                	ret

0000000080002b22 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002b22:	1101                	addi	sp,sp,-32
    80002b24:	ec06                	sd	ra,24(sp)
    80002b26:	e822                	sd	s0,16(sp)
    80002b28:	e426                	sd	s1,8(sp)
    80002b2a:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002b2c:	00015497          	auipc	s1,0x15
    80002b30:	9a448493          	addi	s1,s1,-1628 # 800174d0 <tickslock>
    80002b34:	8526                	mv	a0,s1
    80002b36:	ffffe097          	auipc	ra,0xffffe
    80002b3a:	104080e7          	jalr	260(ra) # 80000c3a <acquire>
  ticks++;
    80002b3e:	00006517          	auipc	a0,0x6
    80002b42:	4f250513          	addi	a0,a0,1266 # 80009030 <ticks>
    80002b46:	411c                	lw	a5,0(a0)
    80002b48:	2785                	addiw	a5,a5,1
    80002b4a:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002b4c:	00000097          	auipc	ra,0x0
    80002b50:	b1c080e7          	jalr	-1252(ra) # 80002668 <wakeup>
  release(&tickslock);
    80002b54:	8526                	mv	a0,s1
    80002b56:	ffffe097          	auipc	ra,0xffffe
    80002b5a:	198080e7          	jalr	408(ra) # 80000cee <release>
}
    80002b5e:	60e2                	ld	ra,24(sp)
    80002b60:	6442                	ld	s0,16(sp)
    80002b62:	64a2                	ld	s1,8(sp)
    80002b64:	6105                	addi	sp,sp,32
    80002b66:	8082                	ret

0000000080002b68 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002b68:	1101                	addi	sp,sp,-32
    80002b6a:	ec06                	sd	ra,24(sp)
    80002b6c:	e822                	sd	s0,16(sp)
    80002b6e:	e426                	sd	s1,8(sp)
    80002b70:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r"(x));
    80002b72:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80002b76:	00074d63          	bltz	a4,80002b90 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80002b7a:	57fd                	li	a5,-1
    80002b7c:	17fe                	slli	a5,a5,0x3f
    80002b7e:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002b80:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002b82:	06f70363          	beq	a4,a5,80002be8 <devintr+0x80>
  }
}
    80002b86:	60e2                	ld	ra,24(sp)
    80002b88:	6442                	ld	s0,16(sp)
    80002b8a:	64a2                	ld	s1,8(sp)
    80002b8c:	6105                	addi	sp,sp,32
    80002b8e:	8082                	ret
     (scause & 0xff) == 9){
    80002b90:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80002b94:	46a5                	li	a3,9
    80002b96:	fed792e3          	bne	a5,a3,80002b7a <devintr+0x12>
    int irq = plic_claim();
    80002b9a:	00003097          	auipc	ra,0x3
    80002b9e:	52e080e7          	jalr	1326(ra) # 800060c8 <plic_claim>
    80002ba2:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002ba4:	47a9                	li	a5,10
    80002ba6:	02f50763          	beq	a0,a5,80002bd4 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80002baa:	4785                	li	a5,1
    80002bac:	02f50963          	beq	a0,a5,80002bde <devintr+0x76>
    return 1;
    80002bb0:	4505                	li	a0,1
    } else if(irq){
    80002bb2:	d8f1                	beqz	s1,80002b86 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002bb4:	85a6                	mv	a1,s1
    80002bb6:	00006517          	auipc	a0,0x6
    80002bba:	84a50513          	addi	a0,a0,-1974 # 80008400 <states.0+0x38>
    80002bbe:	ffffe097          	auipc	ra,0xffffe
    80002bc2:	a60080e7          	jalr	-1440(ra) # 8000061e <printf>
      plic_complete(irq);
    80002bc6:	8526                	mv	a0,s1
    80002bc8:	00003097          	auipc	ra,0x3
    80002bcc:	524080e7          	jalr	1316(ra) # 800060ec <plic_complete>
    return 1;
    80002bd0:	4505                	li	a0,1
    80002bd2:	bf55                	j	80002b86 <devintr+0x1e>
      uartintr();
    80002bd4:	ffffe097          	auipc	ra,0xffffe
    80002bd8:	e2a080e7          	jalr	-470(ra) # 800009fe <uartintr>
    80002bdc:	b7ed                	j	80002bc6 <devintr+0x5e>
      virtio_disk_intr();
    80002bde:	00004097          	auipc	ra,0x4
    80002be2:	9a0080e7          	jalr	-1632(ra) # 8000657e <virtio_disk_intr>
    80002be6:	b7c5                	j	80002bc6 <devintr+0x5e>
    if(cpuid() == 0){
    80002be8:	fffff097          	auipc	ra,0xfffff
    80002bec:	058080e7          	jalr	88(ra) # 80001c40 <cpuid>
    80002bf0:	c901                	beqz	a0,80002c00 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r"(x));
    80002bf2:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002bf6:	9bf5                	andi	a5,a5,-3
static inline void w_sip(uint64 x) { asm volatile("csrw sip, %0" : : "r"(x)); }
    80002bf8:	14479073          	csrw	sip,a5
    return 2;
    80002bfc:	4509                	li	a0,2
    80002bfe:	b761                	j	80002b86 <devintr+0x1e>
      clockintr();
    80002c00:	00000097          	auipc	ra,0x0
    80002c04:	f22080e7          	jalr	-222(ra) # 80002b22 <clockintr>
    80002c08:	b7ed                	j	80002bf2 <devintr+0x8a>

0000000080002c0a <usertrap>:
{
    80002c0a:	1101                	addi	sp,sp,-32
    80002c0c:	ec06                	sd	ra,24(sp)
    80002c0e:	e822                	sd	s0,16(sp)
    80002c10:	e426                	sd	s1,8(sp)
    80002c12:	e04a                	sd	s2,0(sp)
    80002c14:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002c16:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002c1a:	1007f793          	andi	a5,a5,256
    80002c1e:	e3ad                	bnez	a5,80002c80 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002c20:	00003797          	auipc	a5,0x3
    80002c24:	3a078793          	addi	a5,a5,928 # 80005fc0 <kernelvec>
    80002c28:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002c2c:	fffff097          	auipc	ra,0xfffff
    80002c30:	040080e7          	jalr	64(ra) # 80001c6c <myproc>
    80002c34:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002c36:	753c                	ld	a5,104(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002c38:	14102773          	csrr	a4,sepc
    80002c3c:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    80002c3e:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002c42:	47a1                	li	a5,8
    80002c44:	04f71c63          	bne	a4,a5,80002c9c <usertrap+0x92>
    if(p->killed)
    80002c48:	551c                	lw	a5,40(a0)
    80002c4a:	e3b9                	bnez	a5,80002c90 <usertrap+0x86>
    p->trapframe->epc += 4;
    80002c4c:	74b8                	ld	a4,104(s1)
    80002c4e:	6f1c                	ld	a5,24(a4)
    80002c50:	0791                	addi	a5,a5,4
    80002c52:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002c54:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80002c58:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002c5c:	10079073          	csrw	sstatus,a5
    syscall();
    80002c60:	00000097          	auipc	ra,0x0
    80002c64:	2e0080e7          	jalr	736(ra) # 80002f40 <syscall>
  if(p->killed)
    80002c68:	549c                	lw	a5,40(s1)
    80002c6a:	ebc1                	bnez	a5,80002cfa <usertrap+0xf0>
  usertrapret();
    80002c6c:	00000097          	auipc	ra,0x0
    80002c70:	e18080e7          	jalr	-488(ra) # 80002a84 <usertrapret>
}
    80002c74:	60e2                	ld	ra,24(sp)
    80002c76:	6442                	ld	s0,16(sp)
    80002c78:	64a2                	ld	s1,8(sp)
    80002c7a:	6902                	ld	s2,0(sp)
    80002c7c:	6105                	addi	sp,sp,32
    80002c7e:	8082                	ret
    panic("usertrap: not from user mode");
    80002c80:	00005517          	auipc	a0,0x5
    80002c84:	7a050513          	addi	a0,a0,1952 # 80008420 <states.0+0x58>
    80002c88:	ffffe097          	auipc	ra,0xffffe
    80002c8c:	944080e7          	jalr	-1724(ra) # 800005cc <panic>
      exit(-1);
    80002c90:	557d                	li	a0,-1
    80002c92:	00000097          	auipc	ra,0x0
    80002c96:	aa6080e7          	jalr	-1370(ra) # 80002738 <exit>
    80002c9a:	bf4d                	j	80002c4c <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80002c9c:	00000097          	auipc	ra,0x0
    80002ca0:	ecc080e7          	jalr	-308(ra) # 80002b68 <devintr>
    80002ca4:	892a                	mv	s2,a0
    80002ca6:	c501                	beqz	a0,80002cae <usertrap+0xa4>
  if(p->killed)
    80002ca8:	549c                	lw	a5,40(s1)
    80002caa:	c3a1                	beqz	a5,80002cea <usertrap+0xe0>
    80002cac:	a815                	j	80002ce0 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r"(x));
    80002cae:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002cb2:	5890                	lw	a2,48(s1)
    80002cb4:	00005517          	auipc	a0,0x5
    80002cb8:	78c50513          	addi	a0,a0,1932 # 80008440 <states.0+0x78>
    80002cbc:	ffffe097          	auipc	ra,0xffffe
    80002cc0:	962080e7          	jalr	-1694(ra) # 8000061e <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002cc4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80002cc8:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002ccc:	00005517          	auipc	a0,0x5
    80002cd0:	7a450513          	addi	a0,a0,1956 # 80008470 <states.0+0xa8>
    80002cd4:	ffffe097          	auipc	ra,0xffffe
    80002cd8:	94a080e7          	jalr	-1718(ra) # 8000061e <printf>
    p->killed = 1;
    80002cdc:	4785                	li	a5,1
    80002cde:	d49c                	sw	a5,40(s1)
    exit(-1);
    80002ce0:	557d                	li	a0,-1
    80002ce2:	00000097          	auipc	ra,0x0
    80002ce6:	a56080e7          	jalr	-1450(ra) # 80002738 <exit>
  if(which_dev == 2)
    80002cea:	4789                	li	a5,2
    80002cec:	f8f910e3          	bne	s2,a5,80002c6c <usertrap+0x62>
    yield();
    80002cf0:	fffff097          	auipc	ra,0xfffff
    80002cf4:	7b0080e7          	jalr	1968(ra) # 800024a0 <yield>
    80002cf8:	bf95                	j	80002c6c <usertrap+0x62>
  int which_dev = 0;
    80002cfa:	4901                	li	s2,0
    80002cfc:	b7d5                	j	80002ce0 <usertrap+0xd6>

0000000080002cfe <kerneltrap>:
{
    80002cfe:	7179                	addi	sp,sp,-48
    80002d00:	f406                	sd	ra,40(sp)
    80002d02:	f022                	sd	s0,32(sp)
    80002d04:	ec26                	sd	s1,24(sp)
    80002d06:	e84a                	sd	s2,16(sp)
    80002d08:	e44e                	sd	s3,8(sp)
    80002d0a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002d0c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002d10:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    80002d14:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002d18:	1004f793          	andi	a5,s1,256
    80002d1c:	cb85                	beqz	a5,80002d4c <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002d1e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002d22:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002d24:	ef85                	bnez	a5,80002d5c <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002d26:	00000097          	auipc	ra,0x0
    80002d2a:	e42080e7          	jalr	-446(ra) # 80002b68 <devintr>
    80002d2e:	cd1d                	beqz	a0,80002d6c <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002d30:	4789                	li	a5,2
    80002d32:	06f50a63          	beq	a0,a5,80002da6 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r"(x));
    80002d36:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002d3a:	10049073          	csrw	sstatus,s1
}
    80002d3e:	70a2                	ld	ra,40(sp)
    80002d40:	7402                	ld	s0,32(sp)
    80002d42:	64e2                	ld	s1,24(sp)
    80002d44:	6942                	ld	s2,16(sp)
    80002d46:	69a2                	ld	s3,8(sp)
    80002d48:	6145                	addi	sp,sp,48
    80002d4a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002d4c:	00005517          	auipc	a0,0x5
    80002d50:	74450513          	addi	a0,a0,1860 # 80008490 <states.0+0xc8>
    80002d54:	ffffe097          	auipc	ra,0xffffe
    80002d58:	878080e7          	jalr	-1928(ra) # 800005cc <panic>
    panic("kerneltrap: interrupts enabled");
    80002d5c:	00005517          	auipc	a0,0x5
    80002d60:	75c50513          	addi	a0,a0,1884 # 800084b8 <states.0+0xf0>
    80002d64:	ffffe097          	auipc	ra,0xffffe
    80002d68:	868080e7          	jalr	-1944(ra) # 800005cc <panic>
    printf("scause %p\n", scause);
    80002d6c:	85ce                	mv	a1,s3
    80002d6e:	00005517          	auipc	a0,0x5
    80002d72:	76a50513          	addi	a0,a0,1898 # 800084d8 <states.0+0x110>
    80002d76:	ffffe097          	auipc	ra,0xffffe
    80002d7a:	8a8080e7          	jalr	-1880(ra) # 8000061e <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002d7e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80002d82:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002d86:	00005517          	auipc	a0,0x5
    80002d8a:	76250513          	addi	a0,a0,1890 # 800084e8 <states.0+0x120>
    80002d8e:	ffffe097          	auipc	ra,0xffffe
    80002d92:	890080e7          	jalr	-1904(ra) # 8000061e <printf>
    panic("kerneltrap");
    80002d96:	00005517          	auipc	a0,0x5
    80002d9a:	76a50513          	addi	a0,a0,1898 # 80008500 <states.0+0x138>
    80002d9e:	ffffe097          	auipc	ra,0xffffe
    80002da2:	82e080e7          	jalr	-2002(ra) # 800005cc <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002da6:	fffff097          	auipc	ra,0xfffff
    80002daa:	ec6080e7          	jalr	-314(ra) # 80001c6c <myproc>
    80002dae:	d541                	beqz	a0,80002d36 <kerneltrap+0x38>
    80002db0:	fffff097          	auipc	ra,0xfffff
    80002db4:	ebc080e7          	jalr	-324(ra) # 80001c6c <myproc>
    80002db8:	4d18                	lw	a4,24(a0)
    80002dba:	4791                	li	a5,4
    80002dbc:	f6f71de3          	bne	a4,a5,80002d36 <kerneltrap+0x38>
    yield();
    80002dc0:	fffff097          	auipc	ra,0xfffff
    80002dc4:	6e0080e7          	jalr	1760(ra) # 800024a0 <yield>
    80002dc8:	b7bd                	j	80002d36 <kerneltrap+0x38>

0000000080002dca <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002dca:	1101                	addi	sp,sp,-32
    80002dcc:	ec06                	sd	ra,24(sp)
    80002dce:	e822                	sd	s0,16(sp)
    80002dd0:	e426                	sd	s1,8(sp)
    80002dd2:	1000                	addi	s0,sp,32
    80002dd4:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002dd6:	fffff097          	auipc	ra,0xfffff
    80002dda:	e96080e7          	jalr	-362(ra) # 80001c6c <myproc>
  switch (n) {
    80002dde:	4795                	li	a5,5
    80002de0:	0497e163          	bltu	a5,s1,80002e22 <argraw+0x58>
    80002de4:	048a                	slli	s1,s1,0x2
    80002de6:	00005717          	auipc	a4,0x5
    80002dea:	76a70713          	addi	a4,a4,1898 # 80008550 <states.0+0x188>
    80002dee:	94ba                	add	s1,s1,a4
    80002df0:	409c                	lw	a5,0(s1)
    80002df2:	97ba                	add	a5,a5,a4
    80002df4:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002df6:	753c                	ld	a5,104(a0)
    80002df8:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002dfa:	60e2                	ld	ra,24(sp)
    80002dfc:	6442                	ld	s0,16(sp)
    80002dfe:	64a2                	ld	s1,8(sp)
    80002e00:	6105                	addi	sp,sp,32
    80002e02:	8082                	ret
    return p->trapframe->a1;
    80002e04:	753c                	ld	a5,104(a0)
    80002e06:	7fa8                	ld	a0,120(a5)
    80002e08:	bfcd                	j	80002dfa <argraw+0x30>
    return p->trapframe->a2;
    80002e0a:	753c                	ld	a5,104(a0)
    80002e0c:	63c8                	ld	a0,128(a5)
    80002e0e:	b7f5                	j	80002dfa <argraw+0x30>
    return p->trapframe->a3;
    80002e10:	753c                	ld	a5,104(a0)
    80002e12:	67c8                	ld	a0,136(a5)
    80002e14:	b7dd                	j	80002dfa <argraw+0x30>
    return p->trapframe->a4;
    80002e16:	753c                	ld	a5,104(a0)
    80002e18:	6bc8                	ld	a0,144(a5)
    80002e1a:	b7c5                	j	80002dfa <argraw+0x30>
    return p->trapframe->a5;
    80002e1c:	753c                	ld	a5,104(a0)
    80002e1e:	6fc8                	ld	a0,152(a5)
    80002e20:	bfe9                	j	80002dfa <argraw+0x30>
  panic("argraw");
    80002e22:	00005517          	auipc	a0,0x5
    80002e26:	6ee50513          	addi	a0,a0,1774 # 80008510 <states.0+0x148>
    80002e2a:	ffffd097          	auipc	ra,0xffffd
    80002e2e:	7a2080e7          	jalr	1954(ra) # 800005cc <panic>

0000000080002e32 <fetchaddr>:
{
    80002e32:	1101                	addi	sp,sp,-32
    80002e34:	ec06                	sd	ra,24(sp)
    80002e36:	e822                	sd	s0,16(sp)
    80002e38:	e426                	sd	s1,8(sp)
    80002e3a:	e04a                	sd	s2,0(sp)
    80002e3c:	1000                	addi	s0,sp,32
    80002e3e:	84aa                	mv	s1,a0
    80002e40:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002e42:	fffff097          	auipc	ra,0xfffff
    80002e46:	e2a080e7          	jalr	-470(ra) # 80001c6c <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002e4a:	693c                	ld	a5,80(a0)
    80002e4c:	02f4f863          	bgeu	s1,a5,80002e7c <fetchaddr+0x4a>
    80002e50:	00848713          	addi	a4,s1,8
    80002e54:	02e7e663          	bltu	a5,a4,80002e80 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002e58:	46a1                	li	a3,8
    80002e5a:	8626                	mv	a2,s1
    80002e5c:	85ca                	mv	a1,s2
    80002e5e:	6d28                	ld	a0,88(a0)
    80002e60:	fffff097          	auipc	ra,0xfffff
    80002e64:	b02080e7          	jalr	-1278(ra) # 80001962 <copyin>
    80002e68:	00a03533          	snez	a0,a0
    80002e6c:	40a00533          	neg	a0,a0
}
    80002e70:	60e2                	ld	ra,24(sp)
    80002e72:	6442                	ld	s0,16(sp)
    80002e74:	64a2                	ld	s1,8(sp)
    80002e76:	6902                	ld	s2,0(sp)
    80002e78:	6105                	addi	sp,sp,32
    80002e7a:	8082                	ret
    return -1;
    80002e7c:	557d                	li	a0,-1
    80002e7e:	bfcd                	j	80002e70 <fetchaddr+0x3e>
    80002e80:	557d                	li	a0,-1
    80002e82:	b7fd                	j	80002e70 <fetchaddr+0x3e>

0000000080002e84 <fetchstr>:
{
    80002e84:	7179                	addi	sp,sp,-48
    80002e86:	f406                	sd	ra,40(sp)
    80002e88:	f022                	sd	s0,32(sp)
    80002e8a:	ec26                	sd	s1,24(sp)
    80002e8c:	e84a                	sd	s2,16(sp)
    80002e8e:	e44e                	sd	s3,8(sp)
    80002e90:	1800                	addi	s0,sp,48
    80002e92:	892a                	mv	s2,a0
    80002e94:	84ae                	mv	s1,a1
    80002e96:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002e98:	fffff097          	auipc	ra,0xfffff
    80002e9c:	dd4080e7          	jalr	-556(ra) # 80001c6c <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002ea0:	86ce                	mv	a3,s3
    80002ea2:	864a                	mv	a2,s2
    80002ea4:	85a6                	mv	a1,s1
    80002ea6:	6d28                	ld	a0,88(a0)
    80002ea8:	fffff097          	auipc	ra,0xfffff
    80002eac:	b4c080e7          	jalr	-1204(ra) # 800019f4 <copyinstr>
  if(err < 0)
    80002eb0:	00054763          	bltz	a0,80002ebe <fetchstr+0x3a>
  return strlen(buf);
    80002eb4:	8526                	mv	a0,s1
    80002eb6:	ffffe097          	auipc	ra,0xffffe
    80002eba:	004080e7          	jalr	4(ra) # 80000eba <strlen>
}
    80002ebe:	70a2                	ld	ra,40(sp)
    80002ec0:	7402                	ld	s0,32(sp)
    80002ec2:	64e2                	ld	s1,24(sp)
    80002ec4:	6942                	ld	s2,16(sp)
    80002ec6:	69a2                	ld	s3,8(sp)
    80002ec8:	6145                	addi	sp,sp,48
    80002eca:	8082                	ret

0000000080002ecc <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002ecc:	1101                	addi	sp,sp,-32
    80002ece:	ec06                	sd	ra,24(sp)
    80002ed0:	e822                	sd	s0,16(sp)
    80002ed2:	e426                	sd	s1,8(sp)
    80002ed4:	1000                	addi	s0,sp,32
    80002ed6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002ed8:	00000097          	auipc	ra,0x0
    80002edc:	ef2080e7          	jalr	-270(ra) # 80002dca <argraw>
    80002ee0:	c088                	sw	a0,0(s1)
  return 0;
}
    80002ee2:	4501                	li	a0,0
    80002ee4:	60e2                	ld	ra,24(sp)
    80002ee6:	6442                	ld	s0,16(sp)
    80002ee8:	64a2                	ld	s1,8(sp)
    80002eea:	6105                	addi	sp,sp,32
    80002eec:	8082                	ret

0000000080002eee <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002eee:	1101                	addi	sp,sp,-32
    80002ef0:	ec06                	sd	ra,24(sp)
    80002ef2:	e822                	sd	s0,16(sp)
    80002ef4:	e426                	sd	s1,8(sp)
    80002ef6:	1000                	addi	s0,sp,32
    80002ef8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002efa:	00000097          	auipc	ra,0x0
    80002efe:	ed0080e7          	jalr	-304(ra) # 80002dca <argraw>
    80002f02:	e088                	sd	a0,0(s1)
  return 0;
}
    80002f04:	4501                	li	a0,0
    80002f06:	60e2                	ld	ra,24(sp)
    80002f08:	6442                	ld	s0,16(sp)
    80002f0a:	64a2                	ld	s1,8(sp)
    80002f0c:	6105                	addi	sp,sp,32
    80002f0e:	8082                	ret

0000000080002f10 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002f10:	1101                	addi	sp,sp,-32
    80002f12:	ec06                	sd	ra,24(sp)
    80002f14:	e822                	sd	s0,16(sp)
    80002f16:	e426                	sd	s1,8(sp)
    80002f18:	e04a                	sd	s2,0(sp)
    80002f1a:	1000                	addi	s0,sp,32
    80002f1c:	84ae                	mv	s1,a1
    80002f1e:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002f20:	00000097          	auipc	ra,0x0
    80002f24:	eaa080e7          	jalr	-342(ra) # 80002dca <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002f28:	864a                	mv	a2,s2
    80002f2a:	85a6                	mv	a1,s1
    80002f2c:	00000097          	auipc	ra,0x0
    80002f30:	f58080e7          	jalr	-168(ra) # 80002e84 <fetchstr>
}
    80002f34:	60e2                	ld	ra,24(sp)
    80002f36:	6442                	ld	s0,16(sp)
    80002f38:	64a2                	ld	s1,8(sp)
    80002f3a:	6902                	ld	s2,0(sp)
    80002f3c:	6105                	addi	sp,sp,32
    80002f3e:	8082                	ret

0000000080002f40 <syscall>:
};


void
syscall(void)
{
    80002f40:	7179                	addi	sp,sp,-48
    80002f42:	f406                	sd	ra,40(sp)
    80002f44:	f022                	sd	s0,32(sp)
    80002f46:	ec26                	sd	s1,24(sp)
    80002f48:	e84a                	sd	s2,16(sp)
    80002f4a:	e44e                	sd	s3,8(sp)
    80002f4c:	e052                	sd	s4,0(sp)
    80002f4e:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80002f50:	fffff097          	auipc	ra,0xfffff
    80002f54:	d1c080e7          	jalr	-740(ra) # 80001c6c <myproc>
    80002f58:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002f5a:	753c                	ld	a5,104(a0)
    80002f5c:	77dc                	ld	a5,168(a5)
    80002f5e:	0007891b          	sext.w	s2,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002f62:	37fd                	addiw	a5,a5,-1
    80002f64:	4755                	li	a4,21
    80002f66:	04f76f63          	bltu	a4,a5,80002fc4 <syscall+0x84>
    80002f6a:	00391713          	slli	a4,s2,0x3
    80002f6e:	00005797          	auipc	a5,0x5
    80002f72:	5fa78793          	addi	a5,a5,1530 # 80008568 <syscalls>
    80002f76:	97ba                	add	a5,a5,a4
    80002f78:	0007ba03          	ld	s4,0(a5)
    80002f7c:	040a0463          	beqz	s4,80002fc4 <syscall+0x84>
    i32 mask = myproc()->traced;
    80002f80:	fffff097          	auipc	ra,0xfffff
    80002f84:	cec080e7          	jalr	-788(ra) # 80001c6c <myproc>
    80002f88:	04052983          	lw	s3,64(a0)
    u64 res = syscalls[num]();
    80002f8c:	9a02                	jalr	s4
    80002f8e:	8a2a                	mv	s4,a0
    if (mask & (1 << num)){
    80002f90:	4129d9bb          	sraw	s3,s3,s2
    80002f94:	0019f993          	andi	s3,s3,1
    80002f98:	00099663          	bnez	s3,80002fa4 <syscall+0x64>
      printf("%d: syscall %d -> %d\n",myproc()->pid,num,res);
    }
    p->trapframe->a0 = res;
    80002f9c:	74bc                	ld	a5,104(s1)
    80002f9e:	0747b823          	sd	s4,112(a5)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002fa2:	a081                	j	80002fe2 <syscall+0xa2>
      printf("%d: syscall %d -> %d\n",myproc()->pid,num,res);
    80002fa4:	fffff097          	auipc	ra,0xfffff
    80002fa8:	cc8080e7          	jalr	-824(ra) # 80001c6c <myproc>
    80002fac:	86d2                	mv	a3,s4
    80002fae:	864a                	mv	a2,s2
    80002fb0:	590c                	lw	a1,48(a0)
    80002fb2:	00005517          	auipc	a0,0x5
    80002fb6:	56650513          	addi	a0,a0,1382 # 80008518 <states.0+0x150>
    80002fba:	ffffd097          	auipc	ra,0xffffd
    80002fbe:	664080e7          	jalr	1636(ra) # 8000061e <printf>
    80002fc2:	bfe9                	j	80002f9c <syscall+0x5c>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002fc4:	86ca                	mv	a3,s2
    80002fc6:	16848613          	addi	a2,s1,360
    80002fca:	588c                	lw	a1,48(s1)
    80002fcc:	00005517          	auipc	a0,0x5
    80002fd0:	56450513          	addi	a0,a0,1380 # 80008530 <states.0+0x168>
    80002fd4:	ffffd097          	auipc	ra,0xffffd
    80002fd8:	64a080e7          	jalr	1610(ra) # 8000061e <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002fdc:	74bc                	ld	a5,104(s1)
    80002fde:	577d                	li	a4,-1
    80002fe0:	fbb8                	sd	a4,112(a5)
  }
}
    80002fe2:	70a2                	ld	ra,40(sp)
    80002fe4:	7402                	ld	s0,32(sp)
    80002fe6:	64e2                	ld	s1,24(sp)
    80002fe8:	6942                	ld	s2,16(sp)
    80002fea:	69a2                	ld	s3,8(sp)
    80002fec:	6a02                	ld	s4,0(sp)
    80002fee:	6145                	addi	sp,sp,48
    80002ff0:	8082                	ret

0000000080002ff2 <sys_exit>:
#include "proc.h"
#include "riscv.h"
#include "spinlock.h"
#include "types.h"

uint64 sys_exit(void) {
    80002ff2:	1101                	addi	sp,sp,-32
    80002ff4:	ec06                	sd	ra,24(sp)
    80002ff6:	e822                	sd	s0,16(sp)
    80002ff8:	1000                	addi	s0,sp,32
  int n;
  if (argint(0, &n) < 0)
    80002ffa:	fec40593          	addi	a1,s0,-20
    80002ffe:	4501                	li	a0,0
    80003000:	00000097          	auipc	ra,0x0
    80003004:	ecc080e7          	jalr	-308(ra) # 80002ecc <argint>
    return -1;
    80003008:	57fd                	li	a5,-1
  if (argint(0, &n) < 0)
    8000300a:	00054963          	bltz	a0,8000301c <sys_exit+0x2a>
  exit(n);
    8000300e:	fec42503          	lw	a0,-20(s0)
    80003012:	fffff097          	auipc	ra,0xfffff
    80003016:	726080e7          	jalr	1830(ra) # 80002738 <exit>
  return 0; // not reached
    8000301a:	4781                	li	a5,0
}
    8000301c:	853e                	mv	a0,a5
    8000301e:	60e2                	ld	ra,24(sp)
    80003020:	6442                	ld	s0,16(sp)
    80003022:	6105                	addi	sp,sp,32
    80003024:	8082                	ret

0000000080003026 <sys_getpid>:

uint64 sys_getpid(void) { return myproc()->pid; }
    80003026:	1141                	addi	sp,sp,-16
    80003028:	e406                	sd	ra,8(sp)
    8000302a:	e022                	sd	s0,0(sp)
    8000302c:	0800                	addi	s0,sp,16
    8000302e:	fffff097          	auipc	ra,0xfffff
    80003032:	c3e080e7          	jalr	-962(ra) # 80001c6c <myproc>
    80003036:	5908                	lw	a0,48(a0)
    80003038:	60a2                	ld	ra,8(sp)
    8000303a:	6402                	ld	s0,0(sp)
    8000303c:	0141                	addi	sp,sp,16
    8000303e:	8082                	ret

0000000080003040 <sys_fork>:

uint64 sys_fork(void) { return fork(); }
    80003040:	1141                	addi	sp,sp,-16
    80003042:	e406                	sd	ra,8(sp)
    80003044:	e022                	sd	s0,0(sp)
    80003046:	0800                	addi	s0,sp,16
    80003048:	fffff097          	auipc	ra,0xfffff
    8000304c:	112080e7          	jalr	274(ra) # 8000215a <fork>
    80003050:	60a2                	ld	ra,8(sp)
    80003052:	6402                	ld	s0,0(sp)
    80003054:	0141                	addi	sp,sp,16
    80003056:	8082                	ret

0000000080003058 <sys_wait>:

uint64 sys_wait(void) {
    80003058:	1101                	addi	sp,sp,-32
    8000305a:	ec06                	sd	ra,24(sp)
    8000305c:	e822                	sd	s0,16(sp)
    8000305e:	1000                	addi	s0,sp,32
  uint64 p;
  if (argaddr(0, &p) < 0)
    80003060:	fe840593          	addi	a1,s0,-24
    80003064:	4501                	li	a0,0
    80003066:	00000097          	auipc	ra,0x0
    8000306a:	e88080e7          	jalr	-376(ra) # 80002eee <argaddr>
    8000306e:	87aa                	mv	a5,a0
    return -1;
    80003070:	557d                	li	a0,-1
  if (argaddr(0, &p) < 0)
    80003072:	0007c863          	bltz	a5,80003082 <sys_wait+0x2a>
  return wait(p);
    80003076:	fe843503          	ld	a0,-24(s0)
    8000307a:	fffff097          	auipc	ra,0xfffff
    8000307e:	4c6080e7          	jalr	1222(ra) # 80002540 <wait>
}
    80003082:	60e2                	ld	ra,24(sp)
    80003084:	6442                	ld	s0,16(sp)
    80003086:	6105                	addi	sp,sp,32
    80003088:	8082                	ret

000000008000308a <sys_sbrk>:

uint64 sys_sbrk(void) {
    8000308a:	7179                	addi	sp,sp,-48
    8000308c:	f406                	sd	ra,40(sp)
    8000308e:	f022                	sd	s0,32(sp)
    80003090:	ec26                	sd	s1,24(sp)
    80003092:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if (argint(0, &n) < 0)
    80003094:	fdc40593          	addi	a1,s0,-36
    80003098:	4501                	li	a0,0
    8000309a:	00000097          	auipc	ra,0x0
    8000309e:	e32080e7          	jalr	-462(ra) # 80002ecc <argint>
    return -1;
    800030a2:	54fd                	li	s1,-1
  if (argint(0, &n) < 0)
    800030a4:	00054f63          	bltz	a0,800030c2 <sys_sbrk+0x38>
  addr = myproc()->sz;
    800030a8:	fffff097          	auipc	ra,0xfffff
    800030ac:	bc4080e7          	jalr	-1084(ra) # 80001c6c <myproc>
    800030b0:	4924                	lw	s1,80(a0)
  if (growproc(n) < 0)
    800030b2:	fdc42503          	lw	a0,-36(s0)
    800030b6:	fffff097          	auipc	ra,0xfffff
    800030ba:	fd0080e7          	jalr	-48(ra) # 80002086 <growproc>
    800030be:	00054863          	bltz	a0,800030ce <sys_sbrk+0x44>
    return -1;
  return addr;
}
    800030c2:	8526                	mv	a0,s1
    800030c4:	70a2                	ld	ra,40(sp)
    800030c6:	7402                	ld	s0,32(sp)
    800030c8:	64e2                	ld	s1,24(sp)
    800030ca:	6145                	addi	sp,sp,48
    800030cc:	8082                	ret
    return -1;
    800030ce:	54fd                	li	s1,-1
    800030d0:	bfcd                	j	800030c2 <sys_sbrk+0x38>

00000000800030d2 <sys_trace>:

u64 sys_trace(void) {
    800030d2:	1101                	addi	sp,sp,-32
    800030d4:	ec06                	sd	ra,24(sp)
    800030d6:	e822                	sd	s0,16(sp)
    800030d8:	1000                	addi	s0,sp,32
  i32 traced;
  if (argint(0, &traced) < 0)
    800030da:	fec40593          	addi	a1,s0,-20
    800030de:	4501                	li	a0,0
    800030e0:	00000097          	auipc	ra,0x0
    800030e4:	dec080e7          	jalr	-532(ra) # 80002ecc <argint>
    800030e8:	87aa                	mv	a5,a0
    return -1;
    800030ea:	557d                	li	a0,-1
  if (argint(0, &traced) < 0)
    800030ec:	0007c863          	bltz	a5,800030fc <sys_trace+0x2a>
  return trace(traced);
    800030f0:	fec42503          	lw	a0,-20(s0)
    800030f4:	fffff097          	auipc	ra,0xfffff
    800030f8:	040080e7          	jalr	64(ra) # 80002134 <trace>
}
    800030fc:	60e2                	ld	ra,24(sp)
    800030fe:	6442                	ld	s0,16(sp)
    80003100:	6105                	addi	sp,sp,32
    80003102:	8082                	ret

0000000080003104 <sys_sleep>:

uint64 sys_sleep(void) {
    80003104:	7139                	addi	sp,sp,-64
    80003106:	fc06                	sd	ra,56(sp)
    80003108:	f822                	sd	s0,48(sp)
    8000310a:	f426                	sd	s1,40(sp)
    8000310c:	f04a                	sd	s2,32(sp)
    8000310e:	ec4e                	sd	s3,24(sp)
    80003110:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
    80003112:	fcc40593          	addi	a1,s0,-52
    80003116:	4501                	li	a0,0
    80003118:	00000097          	auipc	ra,0x0
    8000311c:	db4080e7          	jalr	-588(ra) # 80002ecc <argint>
    return -1;
    80003120:	57fd                	li	a5,-1
  if (argint(0, &n) < 0)
    80003122:	06054963          	bltz	a0,80003194 <sys_sleep+0x90>
  acquire(&tickslock);
    80003126:	00014517          	auipc	a0,0x14
    8000312a:	3aa50513          	addi	a0,a0,938 # 800174d0 <tickslock>
    8000312e:	ffffe097          	auipc	ra,0xffffe
    80003132:	b0c080e7          	jalr	-1268(ra) # 80000c3a <acquire>
  ticks0 = ticks;
    80003136:	00006917          	auipc	s2,0x6
    8000313a:	efa92903          	lw	s2,-262(s2) # 80009030 <ticks>
  while (ticks - ticks0 < n) {
    8000313e:	fcc42783          	lw	a5,-52(s0)
    80003142:	cf85                	beqz	a5,8000317a <sys_sleep+0x76>
    if (myproc()->killed) {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80003144:	00014997          	auipc	s3,0x14
    80003148:	38c98993          	addi	s3,s3,908 # 800174d0 <tickslock>
    8000314c:	00006497          	auipc	s1,0x6
    80003150:	ee448493          	addi	s1,s1,-284 # 80009030 <ticks>
    if (myproc()->killed) {
    80003154:	fffff097          	auipc	ra,0xfffff
    80003158:	b18080e7          	jalr	-1256(ra) # 80001c6c <myproc>
    8000315c:	551c                	lw	a5,40(a0)
    8000315e:	e3b9                	bnez	a5,800031a4 <sys_sleep+0xa0>
    sleep(&ticks, &tickslock);
    80003160:	85ce                	mv	a1,s3
    80003162:	8526                	mv	a0,s1
    80003164:	fffff097          	auipc	ra,0xfffff
    80003168:	378080e7          	jalr	888(ra) # 800024dc <sleep>
  while (ticks - ticks0 < n) {
    8000316c:	409c                	lw	a5,0(s1)
    8000316e:	412787bb          	subw	a5,a5,s2
    80003172:	fcc42703          	lw	a4,-52(s0)
    80003176:	fce7efe3          	bltu	a5,a4,80003154 <sys_sleep+0x50>
  }
  backtrace();
    8000317a:	ffffd097          	auipc	ra,0xffffd
    8000317e:	3e2080e7          	jalr	994(ra) # 8000055c <backtrace>
  release(&tickslock);
    80003182:	00014517          	auipc	a0,0x14
    80003186:	34e50513          	addi	a0,a0,846 # 800174d0 <tickslock>
    8000318a:	ffffe097          	auipc	ra,0xffffe
    8000318e:	b64080e7          	jalr	-1180(ra) # 80000cee <release>
  return 0;
    80003192:	4781                	li	a5,0
}
    80003194:	853e                	mv	a0,a5
    80003196:	70e2                	ld	ra,56(sp)
    80003198:	7442                	ld	s0,48(sp)
    8000319a:	74a2                	ld	s1,40(sp)
    8000319c:	7902                	ld	s2,32(sp)
    8000319e:	69e2                	ld	s3,24(sp)
    800031a0:	6121                	addi	sp,sp,64
    800031a2:	8082                	ret
      release(&tickslock);
    800031a4:	00014517          	auipc	a0,0x14
    800031a8:	32c50513          	addi	a0,a0,812 # 800174d0 <tickslock>
    800031ac:	ffffe097          	auipc	ra,0xffffe
    800031b0:	b42080e7          	jalr	-1214(ra) # 80000cee <release>
      return -1;
    800031b4:	57fd                	li	a5,-1
    800031b6:	bff9                	j	80003194 <sys_sleep+0x90>

00000000800031b8 <sys_kill>:

uint64 sys_kill(void) {
    800031b8:	1101                	addi	sp,sp,-32
    800031ba:	ec06                	sd	ra,24(sp)
    800031bc:	e822                	sd	s0,16(sp)
    800031be:	1000                	addi	s0,sp,32
  int pid;

  if (argint(0, &pid) < 0)
    800031c0:	fec40593          	addi	a1,s0,-20
    800031c4:	4501                	li	a0,0
    800031c6:	00000097          	auipc	ra,0x0
    800031ca:	d06080e7          	jalr	-762(ra) # 80002ecc <argint>
    800031ce:	87aa                	mv	a5,a0
    return -1;
    800031d0:	557d                	li	a0,-1
  if (argint(0, &pid) < 0)
    800031d2:	0007c863          	bltz	a5,800031e2 <sys_kill+0x2a>
  return kill(pid);
    800031d6:	fec42503          	lw	a0,-20(s0)
    800031da:	fffff097          	auipc	ra,0xfffff
    800031de:	634080e7          	jalr	1588(ra) # 8000280e <kill>
}
    800031e2:	60e2                	ld	ra,24(sp)
    800031e4:	6442                	ld	s0,16(sp)
    800031e6:	6105                	addi	sp,sp,32
    800031e8:	8082                	ret

00000000800031ea <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64 sys_uptime(void) {
    800031ea:	1101                	addi	sp,sp,-32
    800031ec:	ec06                	sd	ra,24(sp)
    800031ee:	e822                	sd	s0,16(sp)
    800031f0:	e426                	sd	s1,8(sp)
    800031f2:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800031f4:	00014517          	auipc	a0,0x14
    800031f8:	2dc50513          	addi	a0,a0,732 # 800174d0 <tickslock>
    800031fc:	ffffe097          	auipc	ra,0xffffe
    80003200:	a3e080e7          	jalr	-1474(ra) # 80000c3a <acquire>
  xticks = ticks;
    80003204:	00006497          	auipc	s1,0x6
    80003208:	e2c4a483          	lw	s1,-468(s1) # 80009030 <ticks>
  release(&tickslock);
    8000320c:	00014517          	auipc	a0,0x14
    80003210:	2c450513          	addi	a0,a0,708 # 800174d0 <tickslock>
    80003214:	ffffe097          	auipc	ra,0xffffe
    80003218:	ada080e7          	jalr	-1318(ra) # 80000cee <release>
  return xticks;
}
    8000321c:	02049513          	slli	a0,s1,0x20
    80003220:	9101                	srli	a0,a0,0x20
    80003222:	60e2                	ld	ra,24(sp)
    80003224:	6442                	ld	s0,16(sp)
    80003226:	64a2                	ld	s1,8(sp)
    80003228:	6105                	addi	sp,sp,32
    8000322a:	8082                	ret

000000008000322c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000322c:	7179                	addi	sp,sp,-48
    8000322e:	f406                	sd	ra,40(sp)
    80003230:	f022                	sd	s0,32(sp)
    80003232:	ec26                	sd	s1,24(sp)
    80003234:	e84a                	sd	s2,16(sp)
    80003236:	e44e                	sd	s3,8(sp)
    80003238:	e052                	sd	s4,0(sp)
    8000323a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000323c:	00005597          	auipc	a1,0x5
    80003240:	3e458593          	addi	a1,a1,996 # 80008620 <syscalls+0xb8>
    80003244:	00014517          	auipc	a0,0x14
    80003248:	2a450513          	addi	a0,a0,676 # 800174e8 <bcache>
    8000324c:	ffffe097          	auipc	ra,0xffffe
    80003250:	95e080e7          	jalr	-1698(ra) # 80000baa <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003254:	0001c797          	auipc	a5,0x1c
    80003258:	29478793          	addi	a5,a5,660 # 8001f4e8 <bcache+0x8000>
    8000325c:	0001c717          	auipc	a4,0x1c
    80003260:	4f470713          	addi	a4,a4,1268 # 8001f750 <bcache+0x8268>
    80003264:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003268:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000326c:	00014497          	auipc	s1,0x14
    80003270:	29448493          	addi	s1,s1,660 # 80017500 <bcache+0x18>
    b->next = bcache.head.next;
    80003274:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003276:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003278:	00005a17          	auipc	s4,0x5
    8000327c:	3b0a0a13          	addi	s4,s4,944 # 80008628 <syscalls+0xc0>
    b->next = bcache.head.next;
    80003280:	2b893783          	ld	a5,696(s2)
    80003284:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003286:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000328a:	85d2                	mv	a1,s4
    8000328c:	01048513          	addi	a0,s1,16
    80003290:	00001097          	auipc	ra,0x1
    80003294:	4bc080e7          	jalr	1212(ra) # 8000474c <initsleeplock>
    bcache.head.next->prev = b;
    80003298:	2b893783          	ld	a5,696(s2)
    8000329c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000329e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800032a2:	45848493          	addi	s1,s1,1112
    800032a6:	fd349de3          	bne	s1,s3,80003280 <binit+0x54>
  }
}
    800032aa:	70a2                	ld	ra,40(sp)
    800032ac:	7402                	ld	s0,32(sp)
    800032ae:	64e2                	ld	s1,24(sp)
    800032b0:	6942                	ld	s2,16(sp)
    800032b2:	69a2                	ld	s3,8(sp)
    800032b4:	6a02                	ld	s4,0(sp)
    800032b6:	6145                	addi	sp,sp,48
    800032b8:	8082                	ret

00000000800032ba <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800032ba:	7179                	addi	sp,sp,-48
    800032bc:	f406                	sd	ra,40(sp)
    800032be:	f022                	sd	s0,32(sp)
    800032c0:	ec26                	sd	s1,24(sp)
    800032c2:	e84a                	sd	s2,16(sp)
    800032c4:	e44e                	sd	s3,8(sp)
    800032c6:	1800                	addi	s0,sp,48
    800032c8:	892a                	mv	s2,a0
    800032ca:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800032cc:	00014517          	auipc	a0,0x14
    800032d0:	21c50513          	addi	a0,a0,540 # 800174e8 <bcache>
    800032d4:	ffffe097          	auipc	ra,0xffffe
    800032d8:	966080e7          	jalr	-1690(ra) # 80000c3a <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800032dc:	0001c497          	auipc	s1,0x1c
    800032e0:	4c44b483          	ld	s1,1220(s1) # 8001f7a0 <bcache+0x82b8>
    800032e4:	0001c797          	auipc	a5,0x1c
    800032e8:	46c78793          	addi	a5,a5,1132 # 8001f750 <bcache+0x8268>
    800032ec:	02f48f63          	beq	s1,a5,8000332a <bread+0x70>
    800032f0:	873e                	mv	a4,a5
    800032f2:	a021                	j	800032fa <bread+0x40>
    800032f4:	68a4                	ld	s1,80(s1)
    800032f6:	02e48a63          	beq	s1,a4,8000332a <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800032fa:	449c                	lw	a5,8(s1)
    800032fc:	ff279ce3          	bne	a5,s2,800032f4 <bread+0x3a>
    80003300:	44dc                	lw	a5,12(s1)
    80003302:	ff3799e3          	bne	a5,s3,800032f4 <bread+0x3a>
      b->refcnt++;
    80003306:	40bc                	lw	a5,64(s1)
    80003308:	2785                	addiw	a5,a5,1
    8000330a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000330c:	00014517          	auipc	a0,0x14
    80003310:	1dc50513          	addi	a0,a0,476 # 800174e8 <bcache>
    80003314:	ffffe097          	auipc	ra,0xffffe
    80003318:	9da080e7          	jalr	-1574(ra) # 80000cee <release>
      acquiresleep(&b->lock);
    8000331c:	01048513          	addi	a0,s1,16
    80003320:	00001097          	auipc	ra,0x1
    80003324:	466080e7          	jalr	1126(ra) # 80004786 <acquiresleep>
      return b;
    80003328:	a8b9                	j	80003386 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000332a:	0001c497          	auipc	s1,0x1c
    8000332e:	46e4b483          	ld	s1,1134(s1) # 8001f798 <bcache+0x82b0>
    80003332:	0001c797          	auipc	a5,0x1c
    80003336:	41e78793          	addi	a5,a5,1054 # 8001f750 <bcache+0x8268>
    8000333a:	00f48863          	beq	s1,a5,8000334a <bread+0x90>
    8000333e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003340:	40bc                	lw	a5,64(s1)
    80003342:	cf81                	beqz	a5,8000335a <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003344:	64a4                	ld	s1,72(s1)
    80003346:	fee49de3          	bne	s1,a4,80003340 <bread+0x86>
  panic("bget: no buffers");
    8000334a:	00005517          	auipc	a0,0x5
    8000334e:	2e650513          	addi	a0,a0,742 # 80008630 <syscalls+0xc8>
    80003352:	ffffd097          	auipc	ra,0xffffd
    80003356:	27a080e7          	jalr	634(ra) # 800005cc <panic>
      b->dev = dev;
    8000335a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000335e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003362:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003366:	4785                	li	a5,1
    80003368:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000336a:	00014517          	auipc	a0,0x14
    8000336e:	17e50513          	addi	a0,a0,382 # 800174e8 <bcache>
    80003372:	ffffe097          	auipc	ra,0xffffe
    80003376:	97c080e7          	jalr	-1668(ra) # 80000cee <release>
      acquiresleep(&b->lock);
    8000337a:	01048513          	addi	a0,s1,16
    8000337e:	00001097          	auipc	ra,0x1
    80003382:	408080e7          	jalr	1032(ra) # 80004786 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003386:	409c                	lw	a5,0(s1)
    80003388:	cb89                	beqz	a5,8000339a <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000338a:	8526                	mv	a0,s1
    8000338c:	70a2                	ld	ra,40(sp)
    8000338e:	7402                	ld	s0,32(sp)
    80003390:	64e2                	ld	s1,24(sp)
    80003392:	6942                	ld	s2,16(sp)
    80003394:	69a2                	ld	s3,8(sp)
    80003396:	6145                	addi	sp,sp,48
    80003398:	8082                	ret
    virtio_disk_rw(b, 0);
    8000339a:	4581                	li	a1,0
    8000339c:	8526                	mv	a0,s1
    8000339e:	00003097          	auipc	ra,0x3
    800033a2:	f58080e7          	jalr	-168(ra) # 800062f6 <virtio_disk_rw>
    b->valid = 1;
    800033a6:	4785                	li	a5,1
    800033a8:	c09c                	sw	a5,0(s1)
  return b;
    800033aa:	b7c5                	j	8000338a <bread+0xd0>

00000000800033ac <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800033ac:	1101                	addi	sp,sp,-32
    800033ae:	ec06                	sd	ra,24(sp)
    800033b0:	e822                	sd	s0,16(sp)
    800033b2:	e426                	sd	s1,8(sp)
    800033b4:	1000                	addi	s0,sp,32
    800033b6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800033b8:	0541                	addi	a0,a0,16
    800033ba:	00001097          	auipc	ra,0x1
    800033be:	466080e7          	jalr	1126(ra) # 80004820 <holdingsleep>
    800033c2:	cd01                	beqz	a0,800033da <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800033c4:	4585                	li	a1,1
    800033c6:	8526                	mv	a0,s1
    800033c8:	00003097          	auipc	ra,0x3
    800033cc:	f2e080e7          	jalr	-210(ra) # 800062f6 <virtio_disk_rw>
}
    800033d0:	60e2                	ld	ra,24(sp)
    800033d2:	6442                	ld	s0,16(sp)
    800033d4:	64a2                	ld	s1,8(sp)
    800033d6:	6105                	addi	sp,sp,32
    800033d8:	8082                	ret
    panic("bwrite");
    800033da:	00005517          	auipc	a0,0x5
    800033de:	26e50513          	addi	a0,a0,622 # 80008648 <syscalls+0xe0>
    800033e2:	ffffd097          	auipc	ra,0xffffd
    800033e6:	1ea080e7          	jalr	490(ra) # 800005cc <panic>

00000000800033ea <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800033ea:	1101                	addi	sp,sp,-32
    800033ec:	ec06                	sd	ra,24(sp)
    800033ee:	e822                	sd	s0,16(sp)
    800033f0:	e426                	sd	s1,8(sp)
    800033f2:	e04a                	sd	s2,0(sp)
    800033f4:	1000                	addi	s0,sp,32
    800033f6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800033f8:	01050913          	addi	s2,a0,16
    800033fc:	854a                	mv	a0,s2
    800033fe:	00001097          	auipc	ra,0x1
    80003402:	422080e7          	jalr	1058(ra) # 80004820 <holdingsleep>
    80003406:	c92d                	beqz	a0,80003478 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80003408:	854a                	mv	a0,s2
    8000340a:	00001097          	auipc	ra,0x1
    8000340e:	3d2080e7          	jalr	978(ra) # 800047dc <releasesleep>

  acquire(&bcache.lock);
    80003412:	00014517          	auipc	a0,0x14
    80003416:	0d650513          	addi	a0,a0,214 # 800174e8 <bcache>
    8000341a:	ffffe097          	auipc	ra,0xffffe
    8000341e:	820080e7          	jalr	-2016(ra) # 80000c3a <acquire>
  b->refcnt--;
    80003422:	40bc                	lw	a5,64(s1)
    80003424:	37fd                	addiw	a5,a5,-1
    80003426:	0007871b          	sext.w	a4,a5
    8000342a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000342c:	eb05                	bnez	a4,8000345c <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000342e:	68bc                	ld	a5,80(s1)
    80003430:	64b8                	ld	a4,72(s1)
    80003432:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80003434:	64bc                	ld	a5,72(s1)
    80003436:	68b8                	ld	a4,80(s1)
    80003438:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000343a:	0001c797          	auipc	a5,0x1c
    8000343e:	0ae78793          	addi	a5,a5,174 # 8001f4e8 <bcache+0x8000>
    80003442:	2b87b703          	ld	a4,696(a5)
    80003446:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003448:	0001c717          	auipc	a4,0x1c
    8000344c:	30870713          	addi	a4,a4,776 # 8001f750 <bcache+0x8268>
    80003450:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003452:	2b87b703          	ld	a4,696(a5)
    80003456:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003458:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000345c:	00014517          	auipc	a0,0x14
    80003460:	08c50513          	addi	a0,a0,140 # 800174e8 <bcache>
    80003464:	ffffe097          	auipc	ra,0xffffe
    80003468:	88a080e7          	jalr	-1910(ra) # 80000cee <release>
}
    8000346c:	60e2                	ld	ra,24(sp)
    8000346e:	6442                	ld	s0,16(sp)
    80003470:	64a2                	ld	s1,8(sp)
    80003472:	6902                	ld	s2,0(sp)
    80003474:	6105                	addi	sp,sp,32
    80003476:	8082                	ret
    panic("brelse");
    80003478:	00005517          	auipc	a0,0x5
    8000347c:	1d850513          	addi	a0,a0,472 # 80008650 <syscalls+0xe8>
    80003480:	ffffd097          	auipc	ra,0xffffd
    80003484:	14c080e7          	jalr	332(ra) # 800005cc <panic>

0000000080003488 <bpin>:

void
bpin(struct buf *b) {
    80003488:	1101                	addi	sp,sp,-32
    8000348a:	ec06                	sd	ra,24(sp)
    8000348c:	e822                	sd	s0,16(sp)
    8000348e:	e426                	sd	s1,8(sp)
    80003490:	1000                	addi	s0,sp,32
    80003492:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003494:	00014517          	auipc	a0,0x14
    80003498:	05450513          	addi	a0,a0,84 # 800174e8 <bcache>
    8000349c:	ffffd097          	auipc	ra,0xffffd
    800034a0:	79e080e7          	jalr	1950(ra) # 80000c3a <acquire>
  b->refcnt++;
    800034a4:	40bc                	lw	a5,64(s1)
    800034a6:	2785                	addiw	a5,a5,1
    800034a8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800034aa:	00014517          	auipc	a0,0x14
    800034ae:	03e50513          	addi	a0,a0,62 # 800174e8 <bcache>
    800034b2:	ffffe097          	auipc	ra,0xffffe
    800034b6:	83c080e7          	jalr	-1988(ra) # 80000cee <release>
}
    800034ba:	60e2                	ld	ra,24(sp)
    800034bc:	6442                	ld	s0,16(sp)
    800034be:	64a2                	ld	s1,8(sp)
    800034c0:	6105                	addi	sp,sp,32
    800034c2:	8082                	ret

00000000800034c4 <bunpin>:

void
bunpin(struct buf *b) {
    800034c4:	1101                	addi	sp,sp,-32
    800034c6:	ec06                	sd	ra,24(sp)
    800034c8:	e822                	sd	s0,16(sp)
    800034ca:	e426                	sd	s1,8(sp)
    800034cc:	1000                	addi	s0,sp,32
    800034ce:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800034d0:	00014517          	auipc	a0,0x14
    800034d4:	01850513          	addi	a0,a0,24 # 800174e8 <bcache>
    800034d8:	ffffd097          	auipc	ra,0xffffd
    800034dc:	762080e7          	jalr	1890(ra) # 80000c3a <acquire>
  b->refcnt--;
    800034e0:	40bc                	lw	a5,64(s1)
    800034e2:	37fd                	addiw	a5,a5,-1
    800034e4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800034e6:	00014517          	auipc	a0,0x14
    800034ea:	00250513          	addi	a0,a0,2 # 800174e8 <bcache>
    800034ee:	ffffe097          	auipc	ra,0xffffe
    800034f2:	800080e7          	jalr	-2048(ra) # 80000cee <release>
}
    800034f6:	60e2                	ld	ra,24(sp)
    800034f8:	6442                	ld	s0,16(sp)
    800034fa:	64a2                	ld	s1,8(sp)
    800034fc:	6105                	addi	sp,sp,32
    800034fe:	8082                	ret

0000000080003500 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003500:	1101                	addi	sp,sp,-32
    80003502:	ec06                	sd	ra,24(sp)
    80003504:	e822                	sd	s0,16(sp)
    80003506:	e426                	sd	s1,8(sp)
    80003508:	e04a                	sd	s2,0(sp)
    8000350a:	1000                	addi	s0,sp,32
    8000350c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000350e:	00d5d59b          	srliw	a1,a1,0xd
    80003512:	0001c797          	auipc	a5,0x1c
    80003516:	6b27a783          	lw	a5,1714(a5) # 8001fbc4 <sb+0x1c>
    8000351a:	9dbd                	addw	a1,a1,a5
    8000351c:	00000097          	auipc	ra,0x0
    80003520:	d9e080e7          	jalr	-610(ra) # 800032ba <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003524:	0074f713          	andi	a4,s1,7
    80003528:	4785                	li	a5,1
    8000352a:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000352e:	14ce                	slli	s1,s1,0x33
    80003530:	90d9                	srli	s1,s1,0x36
    80003532:	00950733          	add	a4,a0,s1
    80003536:	05874703          	lbu	a4,88(a4)
    8000353a:	00e7f6b3          	and	a3,a5,a4
    8000353e:	c69d                	beqz	a3,8000356c <bfree+0x6c>
    80003540:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003542:	94aa                	add	s1,s1,a0
    80003544:	fff7c793          	not	a5,a5
    80003548:	8ff9                	and	a5,a5,a4
    8000354a:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    8000354e:	00001097          	auipc	ra,0x1
    80003552:	118080e7          	jalr	280(ra) # 80004666 <log_write>
  brelse(bp);
    80003556:	854a                	mv	a0,s2
    80003558:	00000097          	auipc	ra,0x0
    8000355c:	e92080e7          	jalr	-366(ra) # 800033ea <brelse>
}
    80003560:	60e2                	ld	ra,24(sp)
    80003562:	6442                	ld	s0,16(sp)
    80003564:	64a2                	ld	s1,8(sp)
    80003566:	6902                	ld	s2,0(sp)
    80003568:	6105                	addi	sp,sp,32
    8000356a:	8082                	ret
    panic("freeing free block");
    8000356c:	00005517          	auipc	a0,0x5
    80003570:	0ec50513          	addi	a0,a0,236 # 80008658 <syscalls+0xf0>
    80003574:	ffffd097          	auipc	ra,0xffffd
    80003578:	058080e7          	jalr	88(ra) # 800005cc <panic>

000000008000357c <balloc>:
{
    8000357c:	711d                	addi	sp,sp,-96
    8000357e:	ec86                	sd	ra,88(sp)
    80003580:	e8a2                	sd	s0,80(sp)
    80003582:	e4a6                	sd	s1,72(sp)
    80003584:	e0ca                	sd	s2,64(sp)
    80003586:	fc4e                	sd	s3,56(sp)
    80003588:	f852                	sd	s4,48(sp)
    8000358a:	f456                	sd	s5,40(sp)
    8000358c:	f05a                	sd	s6,32(sp)
    8000358e:	ec5e                	sd	s7,24(sp)
    80003590:	e862                	sd	s8,16(sp)
    80003592:	e466                	sd	s9,8(sp)
    80003594:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003596:	0001c797          	auipc	a5,0x1c
    8000359a:	6167a783          	lw	a5,1558(a5) # 8001fbac <sb+0x4>
    8000359e:	cbd1                	beqz	a5,80003632 <balloc+0xb6>
    800035a0:	8baa                	mv	s7,a0
    800035a2:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800035a4:	0001cb17          	auipc	s6,0x1c
    800035a8:	604b0b13          	addi	s6,s6,1540 # 8001fba8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800035ac:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800035ae:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800035b0:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800035b2:	6c89                	lui	s9,0x2
    800035b4:	a831                	j	800035d0 <balloc+0x54>
    brelse(bp);
    800035b6:	854a                	mv	a0,s2
    800035b8:	00000097          	auipc	ra,0x0
    800035bc:	e32080e7          	jalr	-462(ra) # 800033ea <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800035c0:	015c87bb          	addw	a5,s9,s5
    800035c4:	00078a9b          	sext.w	s5,a5
    800035c8:	004b2703          	lw	a4,4(s6)
    800035cc:	06eaf363          	bgeu	s5,a4,80003632 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800035d0:	41fad79b          	sraiw	a5,s5,0x1f
    800035d4:	0137d79b          	srliw	a5,a5,0x13
    800035d8:	015787bb          	addw	a5,a5,s5
    800035dc:	40d7d79b          	sraiw	a5,a5,0xd
    800035e0:	01cb2583          	lw	a1,28(s6)
    800035e4:	9dbd                	addw	a1,a1,a5
    800035e6:	855e                	mv	a0,s7
    800035e8:	00000097          	auipc	ra,0x0
    800035ec:	cd2080e7          	jalr	-814(ra) # 800032ba <bread>
    800035f0:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800035f2:	004b2503          	lw	a0,4(s6)
    800035f6:	000a849b          	sext.w	s1,s5
    800035fa:	8662                	mv	a2,s8
    800035fc:	faa4fde3          	bgeu	s1,a0,800035b6 <balloc+0x3a>
      m = 1 << (bi % 8);
    80003600:	41f6579b          	sraiw	a5,a2,0x1f
    80003604:	01d7d69b          	srliw	a3,a5,0x1d
    80003608:	00c6873b          	addw	a4,a3,a2
    8000360c:	00777793          	andi	a5,a4,7
    80003610:	9f95                	subw	a5,a5,a3
    80003612:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003616:	4037571b          	sraiw	a4,a4,0x3
    8000361a:	00e906b3          	add	a3,s2,a4
    8000361e:	0586c683          	lbu	a3,88(a3)
    80003622:	00d7f5b3          	and	a1,a5,a3
    80003626:	cd91                	beqz	a1,80003642 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003628:	2605                	addiw	a2,a2,1
    8000362a:	2485                	addiw	s1,s1,1
    8000362c:	fd4618e3          	bne	a2,s4,800035fc <balloc+0x80>
    80003630:	b759                	j	800035b6 <balloc+0x3a>
  panic("balloc: out of blocks");
    80003632:	00005517          	auipc	a0,0x5
    80003636:	03e50513          	addi	a0,a0,62 # 80008670 <syscalls+0x108>
    8000363a:	ffffd097          	auipc	ra,0xffffd
    8000363e:	f92080e7          	jalr	-110(ra) # 800005cc <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003642:	974a                	add	a4,a4,s2
    80003644:	8fd5                	or	a5,a5,a3
    80003646:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    8000364a:	854a                	mv	a0,s2
    8000364c:	00001097          	auipc	ra,0x1
    80003650:	01a080e7          	jalr	26(ra) # 80004666 <log_write>
        brelse(bp);
    80003654:	854a                	mv	a0,s2
    80003656:	00000097          	auipc	ra,0x0
    8000365a:	d94080e7          	jalr	-620(ra) # 800033ea <brelse>
  bp = bread(dev, bno);
    8000365e:	85a6                	mv	a1,s1
    80003660:	855e                	mv	a0,s7
    80003662:	00000097          	auipc	ra,0x0
    80003666:	c58080e7          	jalr	-936(ra) # 800032ba <bread>
    8000366a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000366c:	40000613          	li	a2,1024
    80003670:	4581                	li	a1,0
    80003672:	05850513          	addi	a0,a0,88
    80003676:	ffffd097          	auipc	ra,0xffffd
    8000367a:	6c0080e7          	jalr	1728(ra) # 80000d36 <memset>
  log_write(bp);
    8000367e:	854a                	mv	a0,s2
    80003680:	00001097          	auipc	ra,0x1
    80003684:	fe6080e7          	jalr	-26(ra) # 80004666 <log_write>
  brelse(bp);
    80003688:	854a                	mv	a0,s2
    8000368a:	00000097          	auipc	ra,0x0
    8000368e:	d60080e7          	jalr	-672(ra) # 800033ea <brelse>
}
    80003692:	8526                	mv	a0,s1
    80003694:	60e6                	ld	ra,88(sp)
    80003696:	6446                	ld	s0,80(sp)
    80003698:	64a6                	ld	s1,72(sp)
    8000369a:	6906                	ld	s2,64(sp)
    8000369c:	79e2                	ld	s3,56(sp)
    8000369e:	7a42                	ld	s4,48(sp)
    800036a0:	7aa2                	ld	s5,40(sp)
    800036a2:	7b02                	ld	s6,32(sp)
    800036a4:	6be2                	ld	s7,24(sp)
    800036a6:	6c42                	ld	s8,16(sp)
    800036a8:	6ca2                	ld	s9,8(sp)
    800036aa:	6125                	addi	sp,sp,96
    800036ac:	8082                	ret

00000000800036ae <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800036ae:	7179                	addi	sp,sp,-48
    800036b0:	f406                	sd	ra,40(sp)
    800036b2:	f022                	sd	s0,32(sp)
    800036b4:	ec26                	sd	s1,24(sp)
    800036b6:	e84a                	sd	s2,16(sp)
    800036b8:	e44e                	sd	s3,8(sp)
    800036ba:	e052                	sd	s4,0(sp)
    800036bc:	1800                	addi	s0,sp,48
    800036be:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800036c0:	47ad                	li	a5,11
    800036c2:	04b7fe63          	bgeu	a5,a1,8000371e <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800036c6:	ff45849b          	addiw	s1,a1,-12
    800036ca:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800036ce:	0ff00793          	li	a5,255
    800036d2:	0ae7e363          	bltu	a5,a4,80003778 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800036d6:	08052583          	lw	a1,128(a0)
    800036da:	c5ad                	beqz	a1,80003744 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800036dc:	00092503          	lw	a0,0(s2)
    800036e0:	00000097          	auipc	ra,0x0
    800036e4:	bda080e7          	jalr	-1062(ra) # 800032ba <bread>
    800036e8:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800036ea:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800036ee:	02049593          	slli	a1,s1,0x20
    800036f2:	9181                	srli	a1,a1,0x20
    800036f4:	058a                	slli	a1,a1,0x2
    800036f6:	00b784b3          	add	s1,a5,a1
    800036fa:	0004a983          	lw	s3,0(s1)
    800036fe:	04098d63          	beqz	s3,80003758 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80003702:	8552                	mv	a0,s4
    80003704:	00000097          	auipc	ra,0x0
    80003708:	ce6080e7          	jalr	-794(ra) # 800033ea <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000370c:	854e                	mv	a0,s3
    8000370e:	70a2                	ld	ra,40(sp)
    80003710:	7402                	ld	s0,32(sp)
    80003712:	64e2                	ld	s1,24(sp)
    80003714:	6942                	ld	s2,16(sp)
    80003716:	69a2                	ld	s3,8(sp)
    80003718:	6a02                	ld	s4,0(sp)
    8000371a:	6145                	addi	sp,sp,48
    8000371c:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000371e:	02059493          	slli	s1,a1,0x20
    80003722:	9081                	srli	s1,s1,0x20
    80003724:	048a                	slli	s1,s1,0x2
    80003726:	94aa                	add	s1,s1,a0
    80003728:	0504a983          	lw	s3,80(s1)
    8000372c:	fe0990e3          	bnez	s3,8000370c <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80003730:	4108                	lw	a0,0(a0)
    80003732:	00000097          	auipc	ra,0x0
    80003736:	e4a080e7          	jalr	-438(ra) # 8000357c <balloc>
    8000373a:	0005099b          	sext.w	s3,a0
    8000373e:	0534a823          	sw	s3,80(s1)
    80003742:	b7e9                	j	8000370c <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80003744:	4108                	lw	a0,0(a0)
    80003746:	00000097          	auipc	ra,0x0
    8000374a:	e36080e7          	jalr	-458(ra) # 8000357c <balloc>
    8000374e:	0005059b          	sext.w	a1,a0
    80003752:	08b92023          	sw	a1,128(s2)
    80003756:	b759                	j	800036dc <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80003758:	00092503          	lw	a0,0(s2)
    8000375c:	00000097          	auipc	ra,0x0
    80003760:	e20080e7          	jalr	-480(ra) # 8000357c <balloc>
    80003764:	0005099b          	sext.w	s3,a0
    80003768:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000376c:	8552                	mv	a0,s4
    8000376e:	00001097          	auipc	ra,0x1
    80003772:	ef8080e7          	jalr	-264(ra) # 80004666 <log_write>
    80003776:	b771                	j	80003702 <bmap+0x54>
  panic("bmap: out of range");
    80003778:	00005517          	auipc	a0,0x5
    8000377c:	f1050513          	addi	a0,a0,-240 # 80008688 <syscalls+0x120>
    80003780:	ffffd097          	auipc	ra,0xffffd
    80003784:	e4c080e7          	jalr	-436(ra) # 800005cc <panic>

0000000080003788 <iget>:
{
    80003788:	7179                	addi	sp,sp,-48
    8000378a:	f406                	sd	ra,40(sp)
    8000378c:	f022                	sd	s0,32(sp)
    8000378e:	ec26                	sd	s1,24(sp)
    80003790:	e84a                	sd	s2,16(sp)
    80003792:	e44e                	sd	s3,8(sp)
    80003794:	e052                	sd	s4,0(sp)
    80003796:	1800                	addi	s0,sp,48
    80003798:	89aa                	mv	s3,a0
    8000379a:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000379c:	0001c517          	auipc	a0,0x1c
    800037a0:	42c50513          	addi	a0,a0,1068 # 8001fbc8 <itable>
    800037a4:	ffffd097          	auipc	ra,0xffffd
    800037a8:	496080e7          	jalr	1174(ra) # 80000c3a <acquire>
  empty = 0;
    800037ac:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800037ae:	0001c497          	auipc	s1,0x1c
    800037b2:	43248493          	addi	s1,s1,1074 # 8001fbe0 <itable+0x18>
    800037b6:	0001e697          	auipc	a3,0x1e
    800037ba:	eba68693          	addi	a3,a3,-326 # 80021670 <log>
    800037be:	a039                	j	800037cc <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800037c0:	02090b63          	beqz	s2,800037f6 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800037c4:	08848493          	addi	s1,s1,136
    800037c8:	02d48a63          	beq	s1,a3,800037fc <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800037cc:	449c                	lw	a5,8(s1)
    800037ce:	fef059e3          	blez	a5,800037c0 <iget+0x38>
    800037d2:	4098                	lw	a4,0(s1)
    800037d4:	ff3716e3          	bne	a4,s3,800037c0 <iget+0x38>
    800037d8:	40d8                	lw	a4,4(s1)
    800037da:	ff4713e3          	bne	a4,s4,800037c0 <iget+0x38>
      ip->ref++;
    800037de:	2785                	addiw	a5,a5,1
    800037e0:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800037e2:	0001c517          	auipc	a0,0x1c
    800037e6:	3e650513          	addi	a0,a0,998 # 8001fbc8 <itable>
    800037ea:	ffffd097          	auipc	ra,0xffffd
    800037ee:	504080e7          	jalr	1284(ra) # 80000cee <release>
      return ip;
    800037f2:	8926                	mv	s2,s1
    800037f4:	a03d                	j	80003822 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800037f6:	f7f9                	bnez	a5,800037c4 <iget+0x3c>
    800037f8:	8926                	mv	s2,s1
    800037fa:	b7e9                	j	800037c4 <iget+0x3c>
  if(empty == 0)
    800037fc:	02090c63          	beqz	s2,80003834 <iget+0xac>
  ip->dev = dev;
    80003800:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003804:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003808:	4785                	li	a5,1
    8000380a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000380e:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003812:	0001c517          	auipc	a0,0x1c
    80003816:	3b650513          	addi	a0,a0,950 # 8001fbc8 <itable>
    8000381a:	ffffd097          	auipc	ra,0xffffd
    8000381e:	4d4080e7          	jalr	1236(ra) # 80000cee <release>
}
    80003822:	854a                	mv	a0,s2
    80003824:	70a2                	ld	ra,40(sp)
    80003826:	7402                	ld	s0,32(sp)
    80003828:	64e2                	ld	s1,24(sp)
    8000382a:	6942                	ld	s2,16(sp)
    8000382c:	69a2                	ld	s3,8(sp)
    8000382e:	6a02                	ld	s4,0(sp)
    80003830:	6145                	addi	sp,sp,48
    80003832:	8082                	ret
    panic("iget: no inodes");
    80003834:	00005517          	auipc	a0,0x5
    80003838:	e6c50513          	addi	a0,a0,-404 # 800086a0 <syscalls+0x138>
    8000383c:	ffffd097          	auipc	ra,0xffffd
    80003840:	d90080e7          	jalr	-624(ra) # 800005cc <panic>

0000000080003844 <fsinit>:
fsinit(int dev) {
    80003844:	7179                	addi	sp,sp,-48
    80003846:	f406                	sd	ra,40(sp)
    80003848:	f022                	sd	s0,32(sp)
    8000384a:	ec26                	sd	s1,24(sp)
    8000384c:	e84a                	sd	s2,16(sp)
    8000384e:	e44e                	sd	s3,8(sp)
    80003850:	1800                	addi	s0,sp,48
    80003852:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003854:	4585                	li	a1,1
    80003856:	00000097          	auipc	ra,0x0
    8000385a:	a64080e7          	jalr	-1436(ra) # 800032ba <bread>
    8000385e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003860:	0001c997          	auipc	s3,0x1c
    80003864:	34898993          	addi	s3,s3,840 # 8001fba8 <sb>
    80003868:	02000613          	li	a2,32
    8000386c:	05850593          	addi	a1,a0,88
    80003870:	854e                	mv	a0,s3
    80003872:	ffffd097          	auipc	ra,0xffffd
    80003876:	520080e7          	jalr	1312(ra) # 80000d92 <memmove>
  brelse(bp);
    8000387a:	8526                	mv	a0,s1
    8000387c:	00000097          	auipc	ra,0x0
    80003880:	b6e080e7          	jalr	-1170(ra) # 800033ea <brelse>
  if(sb.magic != FSMAGIC)
    80003884:	0009a703          	lw	a4,0(s3)
    80003888:	102037b7          	lui	a5,0x10203
    8000388c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003890:	02f71263          	bne	a4,a5,800038b4 <fsinit+0x70>
  initlog(dev, &sb);
    80003894:	0001c597          	auipc	a1,0x1c
    80003898:	31458593          	addi	a1,a1,788 # 8001fba8 <sb>
    8000389c:	854a                	mv	a0,s2
    8000389e:	00001097          	auipc	ra,0x1
    800038a2:	b4c080e7          	jalr	-1204(ra) # 800043ea <initlog>
}
    800038a6:	70a2                	ld	ra,40(sp)
    800038a8:	7402                	ld	s0,32(sp)
    800038aa:	64e2                	ld	s1,24(sp)
    800038ac:	6942                	ld	s2,16(sp)
    800038ae:	69a2                	ld	s3,8(sp)
    800038b0:	6145                	addi	sp,sp,48
    800038b2:	8082                	ret
    panic("invalid file system");
    800038b4:	00005517          	auipc	a0,0x5
    800038b8:	dfc50513          	addi	a0,a0,-516 # 800086b0 <syscalls+0x148>
    800038bc:	ffffd097          	auipc	ra,0xffffd
    800038c0:	d10080e7          	jalr	-752(ra) # 800005cc <panic>

00000000800038c4 <iinit>:
{
    800038c4:	7179                	addi	sp,sp,-48
    800038c6:	f406                	sd	ra,40(sp)
    800038c8:	f022                	sd	s0,32(sp)
    800038ca:	ec26                	sd	s1,24(sp)
    800038cc:	e84a                	sd	s2,16(sp)
    800038ce:	e44e                	sd	s3,8(sp)
    800038d0:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800038d2:	00005597          	auipc	a1,0x5
    800038d6:	df658593          	addi	a1,a1,-522 # 800086c8 <syscalls+0x160>
    800038da:	0001c517          	auipc	a0,0x1c
    800038de:	2ee50513          	addi	a0,a0,750 # 8001fbc8 <itable>
    800038e2:	ffffd097          	auipc	ra,0xffffd
    800038e6:	2c8080e7          	jalr	712(ra) # 80000baa <initlock>
  for(i = 0; i < NINODE; i++) {
    800038ea:	0001c497          	auipc	s1,0x1c
    800038ee:	30648493          	addi	s1,s1,774 # 8001fbf0 <itable+0x28>
    800038f2:	0001e997          	auipc	s3,0x1e
    800038f6:	d8e98993          	addi	s3,s3,-626 # 80021680 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800038fa:	00005917          	auipc	s2,0x5
    800038fe:	dd690913          	addi	s2,s2,-554 # 800086d0 <syscalls+0x168>
    80003902:	85ca                	mv	a1,s2
    80003904:	8526                	mv	a0,s1
    80003906:	00001097          	auipc	ra,0x1
    8000390a:	e46080e7          	jalr	-442(ra) # 8000474c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000390e:	08848493          	addi	s1,s1,136
    80003912:	ff3498e3          	bne	s1,s3,80003902 <iinit+0x3e>
}
    80003916:	70a2                	ld	ra,40(sp)
    80003918:	7402                	ld	s0,32(sp)
    8000391a:	64e2                	ld	s1,24(sp)
    8000391c:	6942                	ld	s2,16(sp)
    8000391e:	69a2                	ld	s3,8(sp)
    80003920:	6145                	addi	sp,sp,48
    80003922:	8082                	ret

0000000080003924 <ialloc>:
{
    80003924:	715d                	addi	sp,sp,-80
    80003926:	e486                	sd	ra,72(sp)
    80003928:	e0a2                	sd	s0,64(sp)
    8000392a:	fc26                	sd	s1,56(sp)
    8000392c:	f84a                	sd	s2,48(sp)
    8000392e:	f44e                	sd	s3,40(sp)
    80003930:	f052                	sd	s4,32(sp)
    80003932:	ec56                	sd	s5,24(sp)
    80003934:	e85a                	sd	s6,16(sp)
    80003936:	e45e                	sd	s7,8(sp)
    80003938:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    8000393a:	0001c717          	auipc	a4,0x1c
    8000393e:	27a72703          	lw	a4,634(a4) # 8001fbb4 <sb+0xc>
    80003942:	4785                	li	a5,1
    80003944:	04e7fa63          	bgeu	a5,a4,80003998 <ialloc+0x74>
    80003948:	8aaa                	mv	s5,a0
    8000394a:	8bae                	mv	s7,a1
    8000394c:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000394e:	0001ca17          	auipc	s4,0x1c
    80003952:	25aa0a13          	addi	s4,s4,602 # 8001fba8 <sb>
    80003956:	00048b1b          	sext.w	s6,s1
    8000395a:	0044d793          	srli	a5,s1,0x4
    8000395e:	018a2583          	lw	a1,24(s4)
    80003962:	9dbd                	addw	a1,a1,a5
    80003964:	8556                	mv	a0,s5
    80003966:	00000097          	auipc	ra,0x0
    8000396a:	954080e7          	jalr	-1708(ra) # 800032ba <bread>
    8000396e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003970:	05850993          	addi	s3,a0,88
    80003974:	00f4f793          	andi	a5,s1,15
    80003978:	079a                	slli	a5,a5,0x6
    8000397a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000397c:	00099783          	lh	a5,0(s3)
    80003980:	c785                	beqz	a5,800039a8 <ialloc+0x84>
    brelse(bp);
    80003982:	00000097          	auipc	ra,0x0
    80003986:	a68080e7          	jalr	-1432(ra) # 800033ea <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000398a:	0485                	addi	s1,s1,1
    8000398c:	00ca2703          	lw	a4,12(s4)
    80003990:	0004879b          	sext.w	a5,s1
    80003994:	fce7e1e3          	bltu	a5,a4,80003956 <ialloc+0x32>
  panic("ialloc: no inodes");
    80003998:	00005517          	auipc	a0,0x5
    8000399c:	d4050513          	addi	a0,a0,-704 # 800086d8 <syscalls+0x170>
    800039a0:	ffffd097          	auipc	ra,0xffffd
    800039a4:	c2c080e7          	jalr	-980(ra) # 800005cc <panic>
      memset(dip, 0, sizeof(*dip));
    800039a8:	04000613          	li	a2,64
    800039ac:	4581                	li	a1,0
    800039ae:	854e                	mv	a0,s3
    800039b0:	ffffd097          	auipc	ra,0xffffd
    800039b4:	386080e7          	jalr	902(ra) # 80000d36 <memset>
      dip->type = type;
    800039b8:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800039bc:	854a                	mv	a0,s2
    800039be:	00001097          	auipc	ra,0x1
    800039c2:	ca8080e7          	jalr	-856(ra) # 80004666 <log_write>
      brelse(bp);
    800039c6:	854a                	mv	a0,s2
    800039c8:	00000097          	auipc	ra,0x0
    800039cc:	a22080e7          	jalr	-1502(ra) # 800033ea <brelse>
      return iget(dev, inum);
    800039d0:	85da                	mv	a1,s6
    800039d2:	8556                	mv	a0,s5
    800039d4:	00000097          	auipc	ra,0x0
    800039d8:	db4080e7          	jalr	-588(ra) # 80003788 <iget>
}
    800039dc:	60a6                	ld	ra,72(sp)
    800039de:	6406                	ld	s0,64(sp)
    800039e0:	74e2                	ld	s1,56(sp)
    800039e2:	7942                	ld	s2,48(sp)
    800039e4:	79a2                	ld	s3,40(sp)
    800039e6:	7a02                	ld	s4,32(sp)
    800039e8:	6ae2                	ld	s5,24(sp)
    800039ea:	6b42                	ld	s6,16(sp)
    800039ec:	6ba2                	ld	s7,8(sp)
    800039ee:	6161                	addi	sp,sp,80
    800039f0:	8082                	ret

00000000800039f2 <iupdate>:
{
    800039f2:	1101                	addi	sp,sp,-32
    800039f4:	ec06                	sd	ra,24(sp)
    800039f6:	e822                	sd	s0,16(sp)
    800039f8:	e426                	sd	s1,8(sp)
    800039fa:	e04a                	sd	s2,0(sp)
    800039fc:	1000                	addi	s0,sp,32
    800039fe:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003a00:	415c                	lw	a5,4(a0)
    80003a02:	0047d79b          	srliw	a5,a5,0x4
    80003a06:	0001c597          	auipc	a1,0x1c
    80003a0a:	1ba5a583          	lw	a1,442(a1) # 8001fbc0 <sb+0x18>
    80003a0e:	9dbd                	addw	a1,a1,a5
    80003a10:	4108                	lw	a0,0(a0)
    80003a12:	00000097          	auipc	ra,0x0
    80003a16:	8a8080e7          	jalr	-1880(ra) # 800032ba <bread>
    80003a1a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003a1c:	05850793          	addi	a5,a0,88
    80003a20:	40c8                	lw	a0,4(s1)
    80003a22:	893d                	andi	a0,a0,15
    80003a24:	051a                	slli	a0,a0,0x6
    80003a26:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003a28:	04449703          	lh	a4,68(s1)
    80003a2c:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80003a30:	04649703          	lh	a4,70(s1)
    80003a34:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003a38:	04849703          	lh	a4,72(s1)
    80003a3c:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80003a40:	04a49703          	lh	a4,74(s1)
    80003a44:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80003a48:	44f8                	lw	a4,76(s1)
    80003a4a:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003a4c:	03400613          	li	a2,52
    80003a50:	05048593          	addi	a1,s1,80
    80003a54:	0531                	addi	a0,a0,12
    80003a56:	ffffd097          	auipc	ra,0xffffd
    80003a5a:	33c080e7          	jalr	828(ra) # 80000d92 <memmove>
  log_write(bp);
    80003a5e:	854a                	mv	a0,s2
    80003a60:	00001097          	auipc	ra,0x1
    80003a64:	c06080e7          	jalr	-1018(ra) # 80004666 <log_write>
  brelse(bp);
    80003a68:	854a                	mv	a0,s2
    80003a6a:	00000097          	auipc	ra,0x0
    80003a6e:	980080e7          	jalr	-1664(ra) # 800033ea <brelse>
}
    80003a72:	60e2                	ld	ra,24(sp)
    80003a74:	6442                	ld	s0,16(sp)
    80003a76:	64a2                	ld	s1,8(sp)
    80003a78:	6902                	ld	s2,0(sp)
    80003a7a:	6105                	addi	sp,sp,32
    80003a7c:	8082                	ret

0000000080003a7e <idup>:
{
    80003a7e:	1101                	addi	sp,sp,-32
    80003a80:	ec06                	sd	ra,24(sp)
    80003a82:	e822                	sd	s0,16(sp)
    80003a84:	e426                	sd	s1,8(sp)
    80003a86:	1000                	addi	s0,sp,32
    80003a88:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003a8a:	0001c517          	auipc	a0,0x1c
    80003a8e:	13e50513          	addi	a0,a0,318 # 8001fbc8 <itable>
    80003a92:	ffffd097          	auipc	ra,0xffffd
    80003a96:	1a8080e7          	jalr	424(ra) # 80000c3a <acquire>
  ip->ref++;
    80003a9a:	449c                	lw	a5,8(s1)
    80003a9c:	2785                	addiw	a5,a5,1
    80003a9e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003aa0:	0001c517          	auipc	a0,0x1c
    80003aa4:	12850513          	addi	a0,a0,296 # 8001fbc8 <itable>
    80003aa8:	ffffd097          	auipc	ra,0xffffd
    80003aac:	246080e7          	jalr	582(ra) # 80000cee <release>
}
    80003ab0:	8526                	mv	a0,s1
    80003ab2:	60e2                	ld	ra,24(sp)
    80003ab4:	6442                	ld	s0,16(sp)
    80003ab6:	64a2                	ld	s1,8(sp)
    80003ab8:	6105                	addi	sp,sp,32
    80003aba:	8082                	ret

0000000080003abc <ilock>:
{
    80003abc:	1101                	addi	sp,sp,-32
    80003abe:	ec06                	sd	ra,24(sp)
    80003ac0:	e822                	sd	s0,16(sp)
    80003ac2:	e426                	sd	s1,8(sp)
    80003ac4:	e04a                	sd	s2,0(sp)
    80003ac6:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003ac8:	c115                	beqz	a0,80003aec <ilock+0x30>
    80003aca:	84aa                	mv	s1,a0
    80003acc:	451c                	lw	a5,8(a0)
    80003ace:	00f05f63          	blez	a5,80003aec <ilock+0x30>
  acquiresleep(&ip->lock);
    80003ad2:	0541                	addi	a0,a0,16
    80003ad4:	00001097          	auipc	ra,0x1
    80003ad8:	cb2080e7          	jalr	-846(ra) # 80004786 <acquiresleep>
  if(ip->valid == 0){
    80003adc:	40bc                	lw	a5,64(s1)
    80003ade:	cf99                	beqz	a5,80003afc <ilock+0x40>
}
    80003ae0:	60e2                	ld	ra,24(sp)
    80003ae2:	6442                	ld	s0,16(sp)
    80003ae4:	64a2                	ld	s1,8(sp)
    80003ae6:	6902                	ld	s2,0(sp)
    80003ae8:	6105                	addi	sp,sp,32
    80003aea:	8082                	ret
    panic("ilock");
    80003aec:	00005517          	auipc	a0,0x5
    80003af0:	c0450513          	addi	a0,a0,-1020 # 800086f0 <syscalls+0x188>
    80003af4:	ffffd097          	auipc	ra,0xffffd
    80003af8:	ad8080e7          	jalr	-1320(ra) # 800005cc <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003afc:	40dc                	lw	a5,4(s1)
    80003afe:	0047d79b          	srliw	a5,a5,0x4
    80003b02:	0001c597          	auipc	a1,0x1c
    80003b06:	0be5a583          	lw	a1,190(a1) # 8001fbc0 <sb+0x18>
    80003b0a:	9dbd                	addw	a1,a1,a5
    80003b0c:	4088                	lw	a0,0(s1)
    80003b0e:	fffff097          	auipc	ra,0xfffff
    80003b12:	7ac080e7          	jalr	1964(ra) # 800032ba <bread>
    80003b16:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003b18:	05850593          	addi	a1,a0,88
    80003b1c:	40dc                	lw	a5,4(s1)
    80003b1e:	8bbd                	andi	a5,a5,15
    80003b20:	079a                	slli	a5,a5,0x6
    80003b22:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003b24:	00059783          	lh	a5,0(a1)
    80003b28:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003b2c:	00259783          	lh	a5,2(a1)
    80003b30:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003b34:	00459783          	lh	a5,4(a1)
    80003b38:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003b3c:	00659783          	lh	a5,6(a1)
    80003b40:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003b44:	459c                	lw	a5,8(a1)
    80003b46:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003b48:	03400613          	li	a2,52
    80003b4c:	05b1                	addi	a1,a1,12
    80003b4e:	05048513          	addi	a0,s1,80
    80003b52:	ffffd097          	auipc	ra,0xffffd
    80003b56:	240080e7          	jalr	576(ra) # 80000d92 <memmove>
    brelse(bp);
    80003b5a:	854a                	mv	a0,s2
    80003b5c:	00000097          	auipc	ra,0x0
    80003b60:	88e080e7          	jalr	-1906(ra) # 800033ea <brelse>
    ip->valid = 1;
    80003b64:	4785                	li	a5,1
    80003b66:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003b68:	04449783          	lh	a5,68(s1)
    80003b6c:	fbb5                	bnez	a5,80003ae0 <ilock+0x24>
      panic("ilock: no type");
    80003b6e:	00005517          	auipc	a0,0x5
    80003b72:	b8a50513          	addi	a0,a0,-1142 # 800086f8 <syscalls+0x190>
    80003b76:	ffffd097          	auipc	ra,0xffffd
    80003b7a:	a56080e7          	jalr	-1450(ra) # 800005cc <panic>

0000000080003b7e <iunlock>:
{
    80003b7e:	1101                	addi	sp,sp,-32
    80003b80:	ec06                	sd	ra,24(sp)
    80003b82:	e822                	sd	s0,16(sp)
    80003b84:	e426                	sd	s1,8(sp)
    80003b86:	e04a                	sd	s2,0(sp)
    80003b88:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003b8a:	c905                	beqz	a0,80003bba <iunlock+0x3c>
    80003b8c:	84aa                	mv	s1,a0
    80003b8e:	01050913          	addi	s2,a0,16
    80003b92:	854a                	mv	a0,s2
    80003b94:	00001097          	auipc	ra,0x1
    80003b98:	c8c080e7          	jalr	-884(ra) # 80004820 <holdingsleep>
    80003b9c:	cd19                	beqz	a0,80003bba <iunlock+0x3c>
    80003b9e:	449c                	lw	a5,8(s1)
    80003ba0:	00f05d63          	blez	a5,80003bba <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003ba4:	854a                	mv	a0,s2
    80003ba6:	00001097          	auipc	ra,0x1
    80003baa:	c36080e7          	jalr	-970(ra) # 800047dc <releasesleep>
}
    80003bae:	60e2                	ld	ra,24(sp)
    80003bb0:	6442                	ld	s0,16(sp)
    80003bb2:	64a2                	ld	s1,8(sp)
    80003bb4:	6902                	ld	s2,0(sp)
    80003bb6:	6105                	addi	sp,sp,32
    80003bb8:	8082                	ret
    panic("iunlock");
    80003bba:	00005517          	auipc	a0,0x5
    80003bbe:	b4e50513          	addi	a0,a0,-1202 # 80008708 <syscalls+0x1a0>
    80003bc2:	ffffd097          	auipc	ra,0xffffd
    80003bc6:	a0a080e7          	jalr	-1526(ra) # 800005cc <panic>

0000000080003bca <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003bca:	7179                	addi	sp,sp,-48
    80003bcc:	f406                	sd	ra,40(sp)
    80003bce:	f022                	sd	s0,32(sp)
    80003bd0:	ec26                	sd	s1,24(sp)
    80003bd2:	e84a                	sd	s2,16(sp)
    80003bd4:	e44e                	sd	s3,8(sp)
    80003bd6:	e052                	sd	s4,0(sp)
    80003bd8:	1800                	addi	s0,sp,48
    80003bda:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003bdc:	05050493          	addi	s1,a0,80
    80003be0:	08050913          	addi	s2,a0,128
    80003be4:	a021                	j	80003bec <itrunc+0x22>
    80003be6:	0491                	addi	s1,s1,4
    80003be8:	01248d63          	beq	s1,s2,80003c02 <itrunc+0x38>
    if(ip->addrs[i]){
    80003bec:	408c                	lw	a1,0(s1)
    80003bee:	dde5                	beqz	a1,80003be6 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003bf0:	0009a503          	lw	a0,0(s3)
    80003bf4:	00000097          	auipc	ra,0x0
    80003bf8:	90c080e7          	jalr	-1780(ra) # 80003500 <bfree>
      ip->addrs[i] = 0;
    80003bfc:	0004a023          	sw	zero,0(s1)
    80003c00:	b7dd                	j	80003be6 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003c02:	0809a583          	lw	a1,128(s3)
    80003c06:	e185                	bnez	a1,80003c26 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003c08:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003c0c:	854e                	mv	a0,s3
    80003c0e:	00000097          	auipc	ra,0x0
    80003c12:	de4080e7          	jalr	-540(ra) # 800039f2 <iupdate>
}
    80003c16:	70a2                	ld	ra,40(sp)
    80003c18:	7402                	ld	s0,32(sp)
    80003c1a:	64e2                	ld	s1,24(sp)
    80003c1c:	6942                	ld	s2,16(sp)
    80003c1e:	69a2                	ld	s3,8(sp)
    80003c20:	6a02                	ld	s4,0(sp)
    80003c22:	6145                	addi	sp,sp,48
    80003c24:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003c26:	0009a503          	lw	a0,0(s3)
    80003c2a:	fffff097          	auipc	ra,0xfffff
    80003c2e:	690080e7          	jalr	1680(ra) # 800032ba <bread>
    80003c32:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003c34:	05850493          	addi	s1,a0,88
    80003c38:	45850913          	addi	s2,a0,1112
    80003c3c:	a021                	j	80003c44 <itrunc+0x7a>
    80003c3e:	0491                	addi	s1,s1,4
    80003c40:	01248b63          	beq	s1,s2,80003c56 <itrunc+0x8c>
      if(a[j])
    80003c44:	408c                	lw	a1,0(s1)
    80003c46:	dde5                	beqz	a1,80003c3e <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003c48:	0009a503          	lw	a0,0(s3)
    80003c4c:	00000097          	auipc	ra,0x0
    80003c50:	8b4080e7          	jalr	-1868(ra) # 80003500 <bfree>
    80003c54:	b7ed                	j	80003c3e <itrunc+0x74>
    brelse(bp);
    80003c56:	8552                	mv	a0,s4
    80003c58:	fffff097          	auipc	ra,0xfffff
    80003c5c:	792080e7          	jalr	1938(ra) # 800033ea <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003c60:	0809a583          	lw	a1,128(s3)
    80003c64:	0009a503          	lw	a0,0(s3)
    80003c68:	00000097          	auipc	ra,0x0
    80003c6c:	898080e7          	jalr	-1896(ra) # 80003500 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003c70:	0809a023          	sw	zero,128(s3)
    80003c74:	bf51                	j	80003c08 <itrunc+0x3e>

0000000080003c76 <iput>:
{
    80003c76:	1101                	addi	sp,sp,-32
    80003c78:	ec06                	sd	ra,24(sp)
    80003c7a:	e822                	sd	s0,16(sp)
    80003c7c:	e426                	sd	s1,8(sp)
    80003c7e:	e04a                	sd	s2,0(sp)
    80003c80:	1000                	addi	s0,sp,32
    80003c82:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003c84:	0001c517          	auipc	a0,0x1c
    80003c88:	f4450513          	addi	a0,a0,-188 # 8001fbc8 <itable>
    80003c8c:	ffffd097          	auipc	ra,0xffffd
    80003c90:	fae080e7          	jalr	-82(ra) # 80000c3a <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003c94:	4498                	lw	a4,8(s1)
    80003c96:	4785                	li	a5,1
    80003c98:	02f70363          	beq	a4,a5,80003cbe <iput+0x48>
  ip->ref--;
    80003c9c:	449c                	lw	a5,8(s1)
    80003c9e:	37fd                	addiw	a5,a5,-1
    80003ca0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003ca2:	0001c517          	auipc	a0,0x1c
    80003ca6:	f2650513          	addi	a0,a0,-218 # 8001fbc8 <itable>
    80003caa:	ffffd097          	auipc	ra,0xffffd
    80003cae:	044080e7          	jalr	68(ra) # 80000cee <release>
}
    80003cb2:	60e2                	ld	ra,24(sp)
    80003cb4:	6442                	ld	s0,16(sp)
    80003cb6:	64a2                	ld	s1,8(sp)
    80003cb8:	6902                	ld	s2,0(sp)
    80003cba:	6105                	addi	sp,sp,32
    80003cbc:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003cbe:	40bc                	lw	a5,64(s1)
    80003cc0:	dff1                	beqz	a5,80003c9c <iput+0x26>
    80003cc2:	04a49783          	lh	a5,74(s1)
    80003cc6:	fbf9                	bnez	a5,80003c9c <iput+0x26>
    acquiresleep(&ip->lock);
    80003cc8:	01048913          	addi	s2,s1,16
    80003ccc:	854a                	mv	a0,s2
    80003cce:	00001097          	auipc	ra,0x1
    80003cd2:	ab8080e7          	jalr	-1352(ra) # 80004786 <acquiresleep>
    release(&itable.lock);
    80003cd6:	0001c517          	auipc	a0,0x1c
    80003cda:	ef250513          	addi	a0,a0,-270 # 8001fbc8 <itable>
    80003cde:	ffffd097          	auipc	ra,0xffffd
    80003ce2:	010080e7          	jalr	16(ra) # 80000cee <release>
    itrunc(ip);
    80003ce6:	8526                	mv	a0,s1
    80003ce8:	00000097          	auipc	ra,0x0
    80003cec:	ee2080e7          	jalr	-286(ra) # 80003bca <itrunc>
    ip->type = 0;
    80003cf0:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003cf4:	8526                	mv	a0,s1
    80003cf6:	00000097          	auipc	ra,0x0
    80003cfa:	cfc080e7          	jalr	-772(ra) # 800039f2 <iupdate>
    ip->valid = 0;
    80003cfe:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003d02:	854a                	mv	a0,s2
    80003d04:	00001097          	auipc	ra,0x1
    80003d08:	ad8080e7          	jalr	-1320(ra) # 800047dc <releasesleep>
    acquire(&itable.lock);
    80003d0c:	0001c517          	auipc	a0,0x1c
    80003d10:	ebc50513          	addi	a0,a0,-324 # 8001fbc8 <itable>
    80003d14:	ffffd097          	auipc	ra,0xffffd
    80003d18:	f26080e7          	jalr	-218(ra) # 80000c3a <acquire>
    80003d1c:	b741                	j	80003c9c <iput+0x26>

0000000080003d1e <iunlockput>:
{
    80003d1e:	1101                	addi	sp,sp,-32
    80003d20:	ec06                	sd	ra,24(sp)
    80003d22:	e822                	sd	s0,16(sp)
    80003d24:	e426                	sd	s1,8(sp)
    80003d26:	1000                	addi	s0,sp,32
    80003d28:	84aa                	mv	s1,a0
  iunlock(ip);
    80003d2a:	00000097          	auipc	ra,0x0
    80003d2e:	e54080e7          	jalr	-428(ra) # 80003b7e <iunlock>
  iput(ip);
    80003d32:	8526                	mv	a0,s1
    80003d34:	00000097          	auipc	ra,0x0
    80003d38:	f42080e7          	jalr	-190(ra) # 80003c76 <iput>
}
    80003d3c:	60e2                	ld	ra,24(sp)
    80003d3e:	6442                	ld	s0,16(sp)
    80003d40:	64a2                	ld	s1,8(sp)
    80003d42:	6105                	addi	sp,sp,32
    80003d44:	8082                	ret

0000000080003d46 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003d46:	1141                	addi	sp,sp,-16
    80003d48:	e422                	sd	s0,8(sp)
    80003d4a:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003d4c:	411c                	lw	a5,0(a0)
    80003d4e:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003d50:	415c                	lw	a5,4(a0)
    80003d52:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003d54:	04451783          	lh	a5,68(a0)
    80003d58:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003d5c:	04a51783          	lh	a5,74(a0)
    80003d60:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003d64:	04c56783          	lwu	a5,76(a0)
    80003d68:	e99c                	sd	a5,16(a1)
}
    80003d6a:	6422                	ld	s0,8(sp)
    80003d6c:	0141                	addi	sp,sp,16
    80003d6e:	8082                	ret

0000000080003d70 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003d70:	457c                	lw	a5,76(a0)
    80003d72:	0ed7e963          	bltu	a5,a3,80003e64 <readi+0xf4>
{
    80003d76:	7159                	addi	sp,sp,-112
    80003d78:	f486                	sd	ra,104(sp)
    80003d7a:	f0a2                	sd	s0,96(sp)
    80003d7c:	eca6                	sd	s1,88(sp)
    80003d7e:	e8ca                	sd	s2,80(sp)
    80003d80:	e4ce                	sd	s3,72(sp)
    80003d82:	e0d2                	sd	s4,64(sp)
    80003d84:	fc56                	sd	s5,56(sp)
    80003d86:	f85a                	sd	s6,48(sp)
    80003d88:	f45e                	sd	s7,40(sp)
    80003d8a:	f062                	sd	s8,32(sp)
    80003d8c:	ec66                	sd	s9,24(sp)
    80003d8e:	e86a                	sd	s10,16(sp)
    80003d90:	e46e                	sd	s11,8(sp)
    80003d92:	1880                	addi	s0,sp,112
    80003d94:	8baa                	mv	s7,a0
    80003d96:	8c2e                	mv	s8,a1
    80003d98:	8ab2                	mv	s5,a2
    80003d9a:	84b6                	mv	s1,a3
    80003d9c:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003d9e:	9f35                	addw	a4,a4,a3
    return 0;
    80003da0:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003da2:	0ad76063          	bltu	a4,a3,80003e42 <readi+0xd2>
  if(off + n > ip->size)
    80003da6:	00e7f463          	bgeu	a5,a4,80003dae <readi+0x3e>
    n = ip->size - off;
    80003daa:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003dae:	0a0b0963          	beqz	s6,80003e60 <readi+0xf0>
    80003db2:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003db4:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003db8:	5cfd                	li	s9,-1
    80003dba:	a82d                	j	80003df4 <readi+0x84>
    80003dbc:	020a1d93          	slli	s11,s4,0x20
    80003dc0:	020ddd93          	srli	s11,s11,0x20
    80003dc4:	05890793          	addi	a5,s2,88
    80003dc8:	86ee                	mv	a3,s11
    80003dca:	963e                	add	a2,a2,a5
    80003dcc:	85d6                	mv	a1,s5
    80003dce:	8562                	mv	a0,s8
    80003dd0:	fffff097          	auipc	ra,0xfffff
    80003dd4:	ab0080e7          	jalr	-1360(ra) # 80002880 <either_copyout>
    80003dd8:	05950d63          	beq	a0,s9,80003e32 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003ddc:	854a                	mv	a0,s2
    80003dde:	fffff097          	auipc	ra,0xfffff
    80003de2:	60c080e7          	jalr	1548(ra) # 800033ea <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003de6:	013a09bb          	addw	s3,s4,s3
    80003dea:	009a04bb          	addw	s1,s4,s1
    80003dee:	9aee                	add	s5,s5,s11
    80003df0:	0569f763          	bgeu	s3,s6,80003e3e <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003df4:	000ba903          	lw	s2,0(s7)
    80003df8:	00a4d59b          	srliw	a1,s1,0xa
    80003dfc:	855e                	mv	a0,s7
    80003dfe:	00000097          	auipc	ra,0x0
    80003e02:	8b0080e7          	jalr	-1872(ra) # 800036ae <bmap>
    80003e06:	0005059b          	sext.w	a1,a0
    80003e0a:	854a                	mv	a0,s2
    80003e0c:	fffff097          	auipc	ra,0xfffff
    80003e10:	4ae080e7          	jalr	1198(ra) # 800032ba <bread>
    80003e14:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003e16:	3ff4f613          	andi	a2,s1,1023
    80003e1a:	40cd07bb          	subw	a5,s10,a2
    80003e1e:	413b073b          	subw	a4,s6,s3
    80003e22:	8a3e                	mv	s4,a5
    80003e24:	2781                	sext.w	a5,a5
    80003e26:	0007069b          	sext.w	a3,a4
    80003e2a:	f8f6f9e3          	bgeu	a3,a5,80003dbc <readi+0x4c>
    80003e2e:	8a3a                	mv	s4,a4
    80003e30:	b771                	j	80003dbc <readi+0x4c>
      brelse(bp);
    80003e32:	854a                	mv	a0,s2
    80003e34:	fffff097          	auipc	ra,0xfffff
    80003e38:	5b6080e7          	jalr	1462(ra) # 800033ea <brelse>
      tot = -1;
    80003e3c:	59fd                	li	s3,-1
  }
  return tot;
    80003e3e:	0009851b          	sext.w	a0,s3
}
    80003e42:	70a6                	ld	ra,104(sp)
    80003e44:	7406                	ld	s0,96(sp)
    80003e46:	64e6                	ld	s1,88(sp)
    80003e48:	6946                	ld	s2,80(sp)
    80003e4a:	69a6                	ld	s3,72(sp)
    80003e4c:	6a06                	ld	s4,64(sp)
    80003e4e:	7ae2                	ld	s5,56(sp)
    80003e50:	7b42                	ld	s6,48(sp)
    80003e52:	7ba2                	ld	s7,40(sp)
    80003e54:	7c02                	ld	s8,32(sp)
    80003e56:	6ce2                	ld	s9,24(sp)
    80003e58:	6d42                	ld	s10,16(sp)
    80003e5a:	6da2                	ld	s11,8(sp)
    80003e5c:	6165                	addi	sp,sp,112
    80003e5e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003e60:	89da                	mv	s3,s6
    80003e62:	bff1                	j	80003e3e <readi+0xce>
    return 0;
    80003e64:	4501                	li	a0,0
}
    80003e66:	8082                	ret

0000000080003e68 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003e68:	457c                	lw	a5,76(a0)
    80003e6a:	10d7e863          	bltu	a5,a3,80003f7a <writei+0x112>
{
    80003e6e:	7159                	addi	sp,sp,-112
    80003e70:	f486                	sd	ra,104(sp)
    80003e72:	f0a2                	sd	s0,96(sp)
    80003e74:	eca6                	sd	s1,88(sp)
    80003e76:	e8ca                	sd	s2,80(sp)
    80003e78:	e4ce                	sd	s3,72(sp)
    80003e7a:	e0d2                	sd	s4,64(sp)
    80003e7c:	fc56                	sd	s5,56(sp)
    80003e7e:	f85a                	sd	s6,48(sp)
    80003e80:	f45e                	sd	s7,40(sp)
    80003e82:	f062                	sd	s8,32(sp)
    80003e84:	ec66                	sd	s9,24(sp)
    80003e86:	e86a                	sd	s10,16(sp)
    80003e88:	e46e                	sd	s11,8(sp)
    80003e8a:	1880                	addi	s0,sp,112
    80003e8c:	8b2a                	mv	s6,a0
    80003e8e:	8c2e                	mv	s8,a1
    80003e90:	8ab2                	mv	s5,a2
    80003e92:	8936                	mv	s2,a3
    80003e94:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003e96:	00e687bb          	addw	a5,a3,a4
    80003e9a:	0ed7e263          	bltu	a5,a3,80003f7e <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003e9e:	00043737          	lui	a4,0x43
    80003ea2:	0ef76063          	bltu	a4,a5,80003f82 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003ea6:	0c0b8863          	beqz	s7,80003f76 <writei+0x10e>
    80003eaa:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003eac:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003eb0:	5cfd                	li	s9,-1
    80003eb2:	a091                	j	80003ef6 <writei+0x8e>
    80003eb4:	02099d93          	slli	s11,s3,0x20
    80003eb8:	020ddd93          	srli	s11,s11,0x20
    80003ebc:	05848793          	addi	a5,s1,88
    80003ec0:	86ee                	mv	a3,s11
    80003ec2:	8656                	mv	a2,s5
    80003ec4:	85e2                	mv	a1,s8
    80003ec6:	953e                	add	a0,a0,a5
    80003ec8:	fffff097          	auipc	ra,0xfffff
    80003ecc:	a0e080e7          	jalr	-1522(ra) # 800028d6 <either_copyin>
    80003ed0:	07950263          	beq	a0,s9,80003f34 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003ed4:	8526                	mv	a0,s1
    80003ed6:	00000097          	auipc	ra,0x0
    80003eda:	790080e7          	jalr	1936(ra) # 80004666 <log_write>
    brelse(bp);
    80003ede:	8526                	mv	a0,s1
    80003ee0:	fffff097          	auipc	ra,0xfffff
    80003ee4:	50a080e7          	jalr	1290(ra) # 800033ea <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003ee8:	01498a3b          	addw	s4,s3,s4
    80003eec:	0129893b          	addw	s2,s3,s2
    80003ef0:	9aee                	add	s5,s5,s11
    80003ef2:	057a7663          	bgeu	s4,s7,80003f3e <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003ef6:	000b2483          	lw	s1,0(s6)
    80003efa:	00a9559b          	srliw	a1,s2,0xa
    80003efe:	855a                	mv	a0,s6
    80003f00:	fffff097          	auipc	ra,0xfffff
    80003f04:	7ae080e7          	jalr	1966(ra) # 800036ae <bmap>
    80003f08:	0005059b          	sext.w	a1,a0
    80003f0c:	8526                	mv	a0,s1
    80003f0e:	fffff097          	auipc	ra,0xfffff
    80003f12:	3ac080e7          	jalr	940(ra) # 800032ba <bread>
    80003f16:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003f18:	3ff97513          	andi	a0,s2,1023
    80003f1c:	40ad07bb          	subw	a5,s10,a0
    80003f20:	414b873b          	subw	a4,s7,s4
    80003f24:	89be                	mv	s3,a5
    80003f26:	2781                	sext.w	a5,a5
    80003f28:	0007069b          	sext.w	a3,a4
    80003f2c:	f8f6f4e3          	bgeu	a3,a5,80003eb4 <writei+0x4c>
    80003f30:	89ba                	mv	s3,a4
    80003f32:	b749                	j	80003eb4 <writei+0x4c>
      brelse(bp);
    80003f34:	8526                	mv	a0,s1
    80003f36:	fffff097          	auipc	ra,0xfffff
    80003f3a:	4b4080e7          	jalr	1204(ra) # 800033ea <brelse>
  }

  if(off > ip->size)
    80003f3e:	04cb2783          	lw	a5,76(s6)
    80003f42:	0127f463          	bgeu	a5,s2,80003f4a <writei+0xe2>
    ip->size = off;
    80003f46:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003f4a:	855a                	mv	a0,s6
    80003f4c:	00000097          	auipc	ra,0x0
    80003f50:	aa6080e7          	jalr	-1370(ra) # 800039f2 <iupdate>

  return tot;
    80003f54:	000a051b          	sext.w	a0,s4
}
    80003f58:	70a6                	ld	ra,104(sp)
    80003f5a:	7406                	ld	s0,96(sp)
    80003f5c:	64e6                	ld	s1,88(sp)
    80003f5e:	6946                	ld	s2,80(sp)
    80003f60:	69a6                	ld	s3,72(sp)
    80003f62:	6a06                	ld	s4,64(sp)
    80003f64:	7ae2                	ld	s5,56(sp)
    80003f66:	7b42                	ld	s6,48(sp)
    80003f68:	7ba2                	ld	s7,40(sp)
    80003f6a:	7c02                	ld	s8,32(sp)
    80003f6c:	6ce2                	ld	s9,24(sp)
    80003f6e:	6d42                	ld	s10,16(sp)
    80003f70:	6da2                	ld	s11,8(sp)
    80003f72:	6165                	addi	sp,sp,112
    80003f74:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003f76:	8a5e                	mv	s4,s7
    80003f78:	bfc9                	j	80003f4a <writei+0xe2>
    return -1;
    80003f7a:	557d                	li	a0,-1
}
    80003f7c:	8082                	ret
    return -1;
    80003f7e:	557d                	li	a0,-1
    80003f80:	bfe1                	j	80003f58 <writei+0xf0>
    return -1;
    80003f82:	557d                	li	a0,-1
    80003f84:	bfd1                	j	80003f58 <writei+0xf0>

0000000080003f86 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003f86:	1141                	addi	sp,sp,-16
    80003f88:	e406                	sd	ra,8(sp)
    80003f8a:	e022                	sd	s0,0(sp)
    80003f8c:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003f8e:	4639                	li	a2,14
    80003f90:	ffffd097          	auipc	ra,0xffffd
    80003f94:	e7e080e7          	jalr	-386(ra) # 80000e0e <strncmp>
}
    80003f98:	60a2                	ld	ra,8(sp)
    80003f9a:	6402                	ld	s0,0(sp)
    80003f9c:	0141                	addi	sp,sp,16
    80003f9e:	8082                	ret

0000000080003fa0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003fa0:	7139                	addi	sp,sp,-64
    80003fa2:	fc06                	sd	ra,56(sp)
    80003fa4:	f822                	sd	s0,48(sp)
    80003fa6:	f426                	sd	s1,40(sp)
    80003fa8:	f04a                	sd	s2,32(sp)
    80003faa:	ec4e                	sd	s3,24(sp)
    80003fac:	e852                	sd	s4,16(sp)
    80003fae:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003fb0:	04451703          	lh	a4,68(a0)
    80003fb4:	4785                	li	a5,1
    80003fb6:	00f71a63          	bne	a4,a5,80003fca <dirlookup+0x2a>
    80003fba:	892a                	mv	s2,a0
    80003fbc:	89ae                	mv	s3,a1
    80003fbe:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003fc0:	457c                	lw	a5,76(a0)
    80003fc2:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003fc4:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003fc6:	e79d                	bnez	a5,80003ff4 <dirlookup+0x54>
    80003fc8:	a8a5                	j	80004040 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003fca:	00004517          	auipc	a0,0x4
    80003fce:	74650513          	addi	a0,a0,1862 # 80008710 <syscalls+0x1a8>
    80003fd2:	ffffc097          	auipc	ra,0xffffc
    80003fd6:	5fa080e7          	jalr	1530(ra) # 800005cc <panic>
      panic("dirlookup read");
    80003fda:	00004517          	auipc	a0,0x4
    80003fde:	74e50513          	addi	a0,a0,1870 # 80008728 <syscalls+0x1c0>
    80003fe2:	ffffc097          	auipc	ra,0xffffc
    80003fe6:	5ea080e7          	jalr	1514(ra) # 800005cc <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003fea:	24c1                	addiw	s1,s1,16
    80003fec:	04c92783          	lw	a5,76(s2)
    80003ff0:	04f4f763          	bgeu	s1,a5,8000403e <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003ff4:	4741                	li	a4,16
    80003ff6:	86a6                	mv	a3,s1
    80003ff8:	fc040613          	addi	a2,s0,-64
    80003ffc:	4581                	li	a1,0
    80003ffe:	854a                	mv	a0,s2
    80004000:	00000097          	auipc	ra,0x0
    80004004:	d70080e7          	jalr	-656(ra) # 80003d70 <readi>
    80004008:	47c1                	li	a5,16
    8000400a:	fcf518e3          	bne	a0,a5,80003fda <dirlookup+0x3a>
    if(de.inum == 0)
    8000400e:	fc045783          	lhu	a5,-64(s0)
    80004012:	dfe1                	beqz	a5,80003fea <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80004014:	fc240593          	addi	a1,s0,-62
    80004018:	854e                	mv	a0,s3
    8000401a:	00000097          	auipc	ra,0x0
    8000401e:	f6c080e7          	jalr	-148(ra) # 80003f86 <namecmp>
    80004022:	f561                	bnez	a0,80003fea <dirlookup+0x4a>
      if(poff)
    80004024:	000a0463          	beqz	s4,8000402c <dirlookup+0x8c>
        *poff = off;
    80004028:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000402c:	fc045583          	lhu	a1,-64(s0)
    80004030:	00092503          	lw	a0,0(s2)
    80004034:	fffff097          	auipc	ra,0xfffff
    80004038:	754080e7          	jalr	1876(ra) # 80003788 <iget>
    8000403c:	a011                	j	80004040 <dirlookup+0xa0>
  return 0;
    8000403e:	4501                	li	a0,0
}
    80004040:	70e2                	ld	ra,56(sp)
    80004042:	7442                	ld	s0,48(sp)
    80004044:	74a2                	ld	s1,40(sp)
    80004046:	7902                	ld	s2,32(sp)
    80004048:	69e2                	ld	s3,24(sp)
    8000404a:	6a42                	ld	s4,16(sp)
    8000404c:	6121                	addi	sp,sp,64
    8000404e:	8082                	ret

0000000080004050 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80004050:	711d                	addi	sp,sp,-96
    80004052:	ec86                	sd	ra,88(sp)
    80004054:	e8a2                	sd	s0,80(sp)
    80004056:	e4a6                	sd	s1,72(sp)
    80004058:	e0ca                	sd	s2,64(sp)
    8000405a:	fc4e                	sd	s3,56(sp)
    8000405c:	f852                	sd	s4,48(sp)
    8000405e:	f456                	sd	s5,40(sp)
    80004060:	f05a                	sd	s6,32(sp)
    80004062:	ec5e                	sd	s7,24(sp)
    80004064:	e862                	sd	s8,16(sp)
    80004066:	e466                	sd	s9,8(sp)
    80004068:	1080                	addi	s0,sp,96
    8000406a:	84aa                	mv	s1,a0
    8000406c:	8aae                	mv	s5,a1
    8000406e:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80004070:	00054703          	lbu	a4,0(a0)
    80004074:	02f00793          	li	a5,47
    80004078:	02f70363          	beq	a4,a5,8000409e <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000407c:	ffffe097          	auipc	ra,0xffffe
    80004080:	bf0080e7          	jalr	-1040(ra) # 80001c6c <myproc>
    80004084:	16053503          	ld	a0,352(a0)
    80004088:	00000097          	auipc	ra,0x0
    8000408c:	9f6080e7          	jalr	-1546(ra) # 80003a7e <idup>
    80004090:	89aa                	mv	s3,a0
  while(*path == '/')
    80004092:	02f00913          	li	s2,47
  len = path - s;
    80004096:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80004098:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000409a:	4b85                	li	s7,1
    8000409c:	a865                	j	80004154 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    8000409e:	4585                	li	a1,1
    800040a0:	4505                	li	a0,1
    800040a2:	fffff097          	auipc	ra,0xfffff
    800040a6:	6e6080e7          	jalr	1766(ra) # 80003788 <iget>
    800040aa:	89aa                	mv	s3,a0
    800040ac:	b7dd                	j	80004092 <namex+0x42>
      iunlockput(ip);
    800040ae:	854e                	mv	a0,s3
    800040b0:	00000097          	auipc	ra,0x0
    800040b4:	c6e080e7          	jalr	-914(ra) # 80003d1e <iunlockput>
      return 0;
    800040b8:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800040ba:	854e                	mv	a0,s3
    800040bc:	60e6                	ld	ra,88(sp)
    800040be:	6446                	ld	s0,80(sp)
    800040c0:	64a6                	ld	s1,72(sp)
    800040c2:	6906                	ld	s2,64(sp)
    800040c4:	79e2                	ld	s3,56(sp)
    800040c6:	7a42                	ld	s4,48(sp)
    800040c8:	7aa2                	ld	s5,40(sp)
    800040ca:	7b02                	ld	s6,32(sp)
    800040cc:	6be2                	ld	s7,24(sp)
    800040ce:	6c42                	ld	s8,16(sp)
    800040d0:	6ca2                	ld	s9,8(sp)
    800040d2:	6125                	addi	sp,sp,96
    800040d4:	8082                	ret
      iunlock(ip);
    800040d6:	854e                	mv	a0,s3
    800040d8:	00000097          	auipc	ra,0x0
    800040dc:	aa6080e7          	jalr	-1370(ra) # 80003b7e <iunlock>
      return ip;
    800040e0:	bfe9                	j	800040ba <namex+0x6a>
      iunlockput(ip);
    800040e2:	854e                	mv	a0,s3
    800040e4:	00000097          	auipc	ra,0x0
    800040e8:	c3a080e7          	jalr	-966(ra) # 80003d1e <iunlockput>
      return 0;
    800040ec:	89e6                	mv	s3,s9
    800040ee:	b7f1                	j	800040ba <namex+0x6a>
  len = path - s;
    800040f0:	40b48633          	sub	a2,s1,a1
    800040f4:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800040f8:	099c5463          	bge	s8,s9,80004180 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800040fc:	4639                	li	a2,14
    800040fe:	8552                	mv	a0,s4
    80004100:	ffffd097          	auipc	ra,0xffffd
    80004104:	c92080e7          	jalr	-878(ra) # 80000d92 <memmove>
  while(*path == '/')
    80004108:	0004c783          	lbu	a5,0(s1)
    8000410c:	01279763          	bne	a5,s2,8000411a <namex+0xca>
    path++;
    80004110:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004112:	0004c783          	lbu	a5,0(s1)
    80004116:	ff278de3          	beq	a5,s2,80004110 <namex+0xc0>
    ilock(ip);
    8000411a:	854e                	mv	a0,s3
    8000411c:	00000097          	auipc	ra,0x0
    80004120:	9a0080e7          	jalr	-1632(ra) # 80003abc <ilock>
    if(ip->type != T_DIR){
    80004124:	04499783          	lh	a5,68(s3)
    80004128:	f97793e3          	bne	a5,s7,800040ae <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000412c:	000a8563          	beqz	s5,80004136 <namex+0xe6>
    80004130:	0004c783          	lbu	a5,0(s1)
    80004134:	d3cd                	beqz	a5,800040d6 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004136:	865a                	mv	a2,s6
    80004138:	85d2                	mv	a1,s4
    8000413a:	854e                	mv	a0,s3
    8000413c:	00000097          	auipc	ra,0x0
    80004140:	e64080e7          	jalr	-412(ra) # 80003fa0 <dirlookup>
    80004144:	8caa                	mv	s9,a0
    80004146:	dd51                	beqz	a0,800040e2 <namex+0x92>
    iunlockput(ip);
    80004148:	854e                	mv	a0,s3
    8000414a:	00000097          	auipc	ra,0x0
    8000414e:	bd4080e7          	jalr	-1068(ra) # 80003d1e <iunlockput>
    ip = next;
    80004152:	89e6                	mv	s3,s9
  while(*path == '/')
    80004154:	0004c783          	lbu	a5,0(s1)
    80004158:	05279763          	bne	a5,s2,800041a6 <namex+0x156>
    path++;
    8000415c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000415e:	0004c783          	lbu	a5,0(s1)
    80004162:	ff278de3          	beq	a5,s2,8000415c <namex+0x10c>
  if(*path == 0)
    80004166:	c79d                	beqz	a5,80004194 <namex+0x144>
    path++;
    80004168:	85a6                	mv	a1,s1
  len = path - s;
    8000416a:	8cda                	mv	s9,s6
    8000416c:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    8000416e:	01278963          	beq	a5,s2,80004180 <namex+0x130>
    80004172:	dfbd                	beqz	a5,800040f0 <namex+0xa0>
    path++;
    80004174:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80004176:	0004c783          	lbu	a5,0(s1)
    8000417a:	ff279ce3          	bne	a5,s2,80004172 <namex+0x122>
    8000417e:	bf8d                	j	800040f0 <namex+0xa0>
    memmove(name, s, len);
    80004180:	2601                	sext.w	a2,a2
    80004182:	8552                	mv	a0,s4
    80004184:	ffffd097          	auipc	ra,0xffffd
    80004188:	c0e080e7          	jalr	-1010(ra) # 80000d92 <memmove>
    name[len] = 0;
    8000418c:	9cd2                	add	s9,s9,s4
    8000418e:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80004192:	bf9d                	j	80004108 <namex+0xb8>
  if(nameiparent){
    80004194:	f20a83e3          	beqz	s5,800040ba <namex+0x6a>
    iput(ip);
    80004198:	854e                	mv	a0,s3
    8000419a:	00000097          	auipc	ra,0x0
    8000419e:	adc080e7          	jalr	-1316(ra) # 80003c76 <iput>
    return 0;
    800041a2:	4981                	li	s3,0
    800041a4:	bf19                	j	800040ba <namex+0x6a>
  if(*path == 0)
    800041a6:	d7fd                	beqz	a5,80004194 <namex+0x144>
  while(*path != '/' && *path != 0)
    800041a8:	0004c783          	lbu	a5,0(s1)
    800041ac:	85a6                	mv	a1,s1
    800041ae:	b7d1                	j	80004172 <namex+0x122>

00000000800041b0 <dirlink>:
{
    800041b0:	7139                	addi	sp,sp,-64
    800041b2:	fc06                	sd	ra,56(sp)
    800041b4:	f822                	sd	s0,48(sp)
    800041b6:	f426                	sd	s1,40(sp)
    800041b8:	f04a                	sd	s2,32(sp)
    800041ba:	ec4e                	sd	s3,24(sp)
    800041bc:	e852                	sd	s4,16(sp)
    800041be:	0080                	addi	s0,sp,64
    800041c0:	892a                	mv	s2,a0
    800041c2:	8a2e                	mv	s4,a1
    800041c4:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800041c6:	4601                	li	a2,0
    800041c8:	00000097          	auipc	ra,0x0
    800041cc:	dd8080e7          	jalr	-552(ra) # 80003fa0 <dirlookup>
    800041d0:	e93d                	bnez	a0,80004246 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800041d2:	04c92483          	lw	s1,76(s2)
    800041d6:	c49d                	beqz	s1,80004204 <dirlink+0x54>
    800041d8:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800041da:	4741                	li	a4,16
    800041dc:	86a6                	mv	a3,s1
    800041de:	fc040613          	addi	a2,s0,-64
    800041e2:	4581                	li	a1,0
    800041e4:	854a                	mv	a0,s2
    800041e6:	00000097          	auipc	ra,0x0
    800041ea:	b8a080e7          	jalr	-1142(ra) # 80003d70 <readi>
    800041ee:	47c1                	li	a5,16
    800041f0:	06f51163          	bne	a0,a5,80004252 <dirlink+0xa2>
    if(de.inum == 0)
    800041f4:	fc045783          	lhu	a5,-64(s0)
    800041f8:	c791                	beqz	a5,80004204 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800041fa:	24c1                	addiw	s1,s1,16
    800041fc:	04c92783          	lw	a5,76(s2)
    80004200:	fcf4ede3          	bltu	s1,a5,800041da <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80004204:	4639                	li	a2,14
    80004206:	85d2                	mv	a1,s4
    80004208:	fc240513          	addi	a0,s0,-62
    8000420c:	ffffd097          	auipc	ra,0xffffd
    80004210:	c3e080e7          	jalr	-962(ra) # 80000e4a <strncpy>
  de.inum = inum;
    80004214:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004218:	4741                	li	a4,16
    8000421a:	86a6                	mv	a3,s1
    8000421c:	fc040613          	addi	a2,s0,-64
    80004220:	4581                	li	a1,0
    80004222:	854a                	mv	a0,s2
    80004224:	00000097          	auipc	ra,0x0
    80004228:	c44080e7          	jalr	-956(ra) # 80003e68 <writei>
    8000422c:	872a                	mv	a4,a0
    8000422e:	47c1                	li	a5,16
  return 0;
    80004230:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004232:	02f71863          	bne	a4,a5,80004262 <dirlink+0xb2>
}
    80004236:	70e2                	ld	ra,56(sp)
    80004238:	7442                	ld	s0,48(sp)
    8000423a:	74a2                	ld	s1,40(sp)
    8000423c:	7902                	ld	s2,32(sp)
    8000423e:	69e2                	ld	s3,24(sp)
    80004240:	6a42                	ld	s4,16(sp)
    80004242:	6121                	addi	sp,sp,64
    80004244:	8082                	ret
    iput(ip);
    80004246:	00000097          	auipc	ra,0x0
    8000424a:	a30080e7          	jalr	-1488(ra) # 80003c76 <iput>
    return -1;
    8000424e:	557d                	li	a0,-1
    80004250:	b7dd                	j	80004236 <dirlink+0x86>
      panic("dirlink read");
    80004252:	00004517          	auipc	a0,0x4
    80004256:	4e650513          	addi	a0,a0,1254 # 80008738 <syscalls+0x1d0>
    8000425a:	ffffc097          	auipc	ra,0xffffc
    8000425e:	372080e7          	jalr	882(ra) # 800005cc <panic>
    panic("dirlink");
    80004262:	00004517          	auipc	a0,0x4
    80004266:	5de50513          	addi	a0,a0,1502 # 80008840 <syscalls+0x2d8>
    8000426a:	ffffc097          	auipc	ra,0xffffc
    8000426e:	362080e7          	jalr	866(ra) # 800005cc <panic>

0000000080004272 <namei>:

struct inode*
namei(char *path)
{
    80004272:	1101                	addi	sp,sp,-32
    80004274:	ec06                	sd	ra,24(sp)
    80004276:	e822                	sd	s0,16(sp)
    80004278:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000427a:	fe040613          	addi	a2,s0,-32
    8000427e:	4581                	li	a1,0
    80004280:	00000097          	auipc	ra,0x0
    80004284:	dd0080e7          	jalr	-560(ra) # 80004050 <namex>
}
    80004288:	60e2                	ld	ra,24(sp)
    8000428a:	6442                	ld	s0,16(sp)
    8000428c:	6105                	addi	sp,sp,32
    8000428e:	8082                	ret

0000000080004290 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004290:	1141                	addi	sp,sp,-16
    80004292:	e406                	sd	ra,8(sp)
    80004294:	e022                	sd	s0,0(sp)
    80004296:	0800                	addi	s0,sp,16
    80004298:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000429a:	4585                	li	a1,1
    8000429c:	00000097          	auipc	ra,0x0
    800042a0:	db4080e7          	jalr	-588(ra) # 80004050 <namex>
}
    800042a4:	60a2                	ld	ra,8(sp)
    800042a6:	6402                	ld	s0,0(sp)
    800042a8:	0141                	addi	sp,sp,16
    800042aa:	8082                	ret

00000000800042ac <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800042ac:	1101                	addi	sp,sp,-32
    800042ae:	ec06                	sd	ra,24(sp)
    800042b0:	e822                	sd	s0,16(sp)
    800042b2:	e426                	sd	s1,8(sp)
    800042b4:	e04a                	sd	s2,0(sp)
    800042b6:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800042b8:	0001d917          	auipc	s2,0x1d
    800042bc:	3b890913          	addi	s2,s2,952 # 80021670 <log>
    800042c0:	01892583          	lw	a1,24(s2)
    800042c4:	02892503          	lw	a0,40(s2)
    800042c8:	fffff097          	auipc	ra,0xfffff
    800042cc:	ff2080e7          	jalr	-14(ra) # 800032ba <bread>
    800042d0:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800042d2:	02c92683          	lw	a3,44(s2)
    800042d6:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800042d8:	02d05763          	blez	a3,80004306 <write_head+0x5a>
    800042dc:	0001d797          	auipc	a5,0x1d
    800042e0:	3c478793          	addi	a5,a5,964 # 800216a0 <log+0x30>
    800042e4:	05c50713          	addi	a4,a0,92
    800042e8:	36fd                	addiw	a3,a3,-1
    800042ea:	1682                	slli	a3,a3,0x20
    800042ec:	9281                	srli	a3,a3,0x20
    800042ee:	068a                	slli	a3,a3,0x2
    800042f0:	0001d617          	auipc	a2,0x1d
    800042f4:	3b460613          	addi	a2,a2,948 # 800216a4 <log+0x34>
    800042f8:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800042fa:	4390                	lw	a2,0(a5)
    800042fc:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800042fe:	0791                	addi	a5,a5,4
    80004300:	0711                	addi	a4,a4,4
    80004302:	fed79ce3          	bne	a5,a3,800042fa <write_head+0x4e>
  }
  bwrite(buf);
    80004306:	8526                	mv	a0,s1
    80004308:	fffff097          	auipc	ra,0xfffff
    8000430c:	0a4080e7          	jalr	164(ra) # 800033ac <bwrite>
  brelse(buf);
    80004310:	8526                	mv	a0,s1
    80004312:	fffff097          	auipc	ra,0xfffff
    80004316:	0d8080e7          	jalr	216(ra) # 800033ea <brelse>
}
    8000431a:	60e2                	ld	ra,24(sp)
    8000431c:	6442                	ld	s0,16(sp)
    8000431e:	64a2                	ld	s1,8(sp)
    80004320:	6902                	ld	s2,0(sp)
    80004322:	6105                	addi	sp,sp,32
    80004324:	8082                	ret

0000000080004326 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004326:	0001d797          	auipc	a5,0x1d
    8000432a:	3767a783          	lw	a5,886(a5) # 8002169c <log+0x2c>
    8000432e:	0af05d63          	blez	a5,800043e8 <install_trans+0xc2>
{
    80004332:	7139                	addi	sp,sp,-64
    80004334:	fc06                	sd	ra,56(sp)
    80004336:	f822                	sd	s0,48(sp)
    80004338:	f426                	sd	s1,40(sp)
    8000433a:	f04a                	sd	s2,32(sp)
    8000433c:	ec4e                	sd	s3,24(sp)
    8000433e:	e852                	sd	s4,16(sp)
    80004340:	e456                	sd	s5,8(sp)
    80004342:	e05a                	sd	s6,0(sp)
    80004344:	0080                	addi	s0,sp,64
    80004346:	8b2a                	mv	s6,a0
    80004348:	0001da97          	auipc	s5,0x1d
    8000434c:	358a8a93          	addi	s5,s5,856 # 800216a0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004350:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004352:	0001d997          	auipc	s3,0x1d
    80004356:	31e98993          	addi	s3,s3,798 # 80021670 <log>
    8000435a:	a00d                	j	8000437c <install_trans+0x56>
    brelse(lbuf);
    8000435c:	854a                	mv	a0,s2
    8000435e:	fffff097          	auipc	ra,0xfffff
    80004362:	08c080e7          	jalr	140(ra) # 800033ea <brelse>
    brelse(dbuf);
    80004366:	8526                	mv	a0,s1
    80004368:	fffff097          	auipc	ra,0xfffff
    8000436c:	082080e7          	jalr	130(ra) # 800033ea <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004370:	2a05                	addiw	s4,s4,1
    80004372:	0a91                	addi	s5,s5,4
    80004374:	02c9a783          	lw	a5,44(s3)
    80004378:	04fa5e63          	bge	s4,a5,800043d4 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000437c:	0189a583          	lw	a1,24(s3)
    80004380:	014585bb          	addw	a1,a1,s4
    80004384:	2585                	addiw	a1,a1,1
    80004386:	0289a503          	lw	a0,40(s3)
    8000438a:	fffff097          	auipc	ra,0xfffff
    8000438e:	f30080e7          	jalr	-208(ra) # 800032ba <bread>
    80004392:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004394:	000aa583          	lw	a1,0(s5)
    80004398:	0289a503          	lw	a0,40(s3)
    8000439c:	fffff097          	auipc	ra,0xfffff
    800043a0:	f1e080e7          	jalr	-226(ra) # 800032ba <bread>
    800043a4:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800043a6:	40000613          	li	a2,1024
    800043aa:	05890593          	addi	a1,s2,88
    800043ae:	05850513          	addi	a0,a0,88
    800043b2:	ffffd097          	auipc	ra,0xffffd
    800043b6:	9e0080e7          	jalr	-1568(ra) # 80000d92 <memmove>
    bwrite(dbuf);  // write dst to disk
    800043ba:	8526                	mv	a0,s1
    800043bc:	fffff097          	auipc	ra,0xfffff
    800043c0:	ff0080e7          	jalr	-16(ra) # 800033ac <bwrite>
    if(recovering == 0)
    800043c4:	f80b1ce3          	bnez	s6,8000435c <install_trans+0x36>
      bunpin(dbuf);
    800043c8:	8526                	mv	a0,s1
    800043ca:	fffff097          	auipc	ra,0xfffff
    800043ce:	0fa080e7          	jalr	250(ra) # 800034c4 <bunpin>
    800043d2:	b769                	j	8000435c <install_trans+0x36>
}
    800043d4:	70e2                	ld	ra,56(sp)
    800043d6:	7442                	ld	s0,48(sp)
    800043d8:	74a2                	ld	s1,40(sp)
    800043da:	7902                	ld	s2,32(sp)
    800043dc:	69e2                	ld	s3,24(sp)
    800043de:	6a42                	ld	s4,16(sp)
    800043e0:	6aa2                	ld	s5,8(sp)
    800043e2:	6b02                	ld	s6,0(sp)
    800043e4:	6121                	addi	sp,sp,64
    800043e6:	8082                	ret
    800043e8:	8082                	ret

00000000800043ea <initlog>:
{
    800043ea:	7179                	addi	sp,sp,-48
    800043ec:	f406                	sd	ra,40(sp)
    800043ee:	f022                	sd	s0,32(sp)
    800043f0:	ec26                	sd	s1,24(sp)
    800043f2:	e84a                	sd	s2,16(sp)
    800043f4:	e44e                	sd	s3,8(sp)
    800043f6:	1800                	addi	s0,sp,48
    800043f8:	892a                	mv	s2,a0
    800043fa:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800043fc:	0001d497          	auipc	s1,0x1d
    80004400:	27448493          	addi	s1,s1,628 # 80021670 <log>
    80004404:	00004597          	auipc	a1,0x4
    80004408:	34458593          	addi	a1,a1,836 # 80008748 <syscalls+0x1e0>
    8000440c:	8526                	mv	a0,s1
    8000440e:	ffffc097          	auipc	ra,0xffffc
    80004412:	79c080e7          	jalr	1948(ra) # 80000baa <initlock>
  log.start = sb->logstart;
    80004416:	0149a583          	lw	a1,20(s3)
    8000441a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000441c:	0109a783          	lw	a5,16(s3)
    80004420:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004422:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004426:	854a                	mv	a0,s2
    80004428:	fffff097          	auipc	ra,0xfffff
    8000442c:	e92080e7          	jalr	-366(ra) # 800032ba <bread>
  log.lh.n = lh->n;
    80004430:	4d34                	lw	a3,88(a0)
    80004432:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004434:	02d05563          	blez	a3,8000445e <initlog+0x74>
    80004438:	05c50793          	addi	a5,a0,92
    8000443c:	0001d717          	auipc	a4,0x1d
    80004440:	26470713          	addi	a4,a4,612 # 800216a0 <log+0x30>
    80004444:	36fd                	addiw	a3,a3,-1
    80004446:	1682                	slli	a3,a3,0x20
    80004448:	9281                	srli	a3,a3,0x20
    8000444a:	068a                	slli	a3,a3,0x2
    8000444c:	06050613          	addi	a2,a0,96
    80004450:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80004452:	4390                	lw	a2,0(a5)
    80004454:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004456:	0791                	addi	a5,a5,4
    80004458:	0711                	addi	a4,a4,4
    8000445a:	fed79ce3          	bne	a5,a3,80004452 <initlog+0x68>
  brelse(buf);
    8000445e:	fffff097          	auipc	ra,0xfffff
    80004462:	f8c080e7          	jalr	-116(ra) # 800033ea <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004466:	4505                	li	a0,1
    80004468:	00000097          	auipc	ra,0x0
    8000446c:	ebe080e7          	jalr	-322(ra) # 80004326 <install_trans>
  log.lh.n = 0;
    80004470:	0001d797          	auipc	a5,0x1d
    80004474:	2207a623          	sw	zero,556(a5) # 8002169c <log+0x2c>
  write_head(); // clear the log
    80004478:	00000097          	auipc	ra,0x0
    8000447c:	e34080e7          	jalr	-460(ra) # 800042ac <write_head>
}
    80004480:	70a2                	ld	ra,40(sp)
    80004482:	7402                	ld	s0,32(sp)
    80004484:	64e2                	ld	s1,24(sp)
    80004486:	6942                	ld	s2,16(sp)
    80004488:	69a2                	ld	s3,8(sp)
    8000448a:	6145                	addi	sp,sp,48
    8000448c:	8082                	ret

000000008000448e <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000448e:	1101                	addi	sp,sp,-32
    80004490:	ec06                	sd	ra,24(sp)
    80004492:	e822                	sd	s0,16(sp)
    80004494:	e426                	sd	s1,8(sp)
    80004496:	e04a                	sd	s2,0(sp)
    80004498:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000449a:	0001d517          	auipc	a0,0x1d
    8000449e:	1d650513          	addi	a0,a0,470 # 80021670 <log>
    800044a2:	ffffc097          	auipc	ra,0xffffc
    800044a6:	798080e7          	jalr	1944(ra) # 80000c3a <acquire>
  while(1){
    if(log.committing){
    800044aa:	0001d497          	auipc	s1,0x1d
    800044ae:	1c648493          	addi	s1,s1,454 # 80021670 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800044b2:	4979                	li	s2,30
    800044b4:	a039                	j	800044c2 <begin_op+0x34>
      sleep(&log, &log.lock);
    800044b6:	85a6                	mv	a1,s1
    800044b8:	8526                	mv	a0,s1
    800044ba:	ffffe097          	auipc	ra,0xffffe
    800044be:	022080e7          	jalr	34(ra) # 800024dc <sleep>
    if(log.committing){
    800044c2:	50dc                	lw	a5,36(s1)
    800044c4:	fbed                	bnez	a5,800044b6 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800044c6:	509c                	lw	a5,32(s1)
    800044c8:	0017871b          	addiw	a4,a5,1
    800044cc:	0007069b          	sext.w	a3,a4
    800044d0:	0027179b          	slliw	a5,a4,0x2
    800044d4:	9fb9                	addw	a5,a5,a4
    800044d6:	0017979b          	slliw	a5,a5,0x1
    800044da:	54d8                	lw	a4,44(s1)
    800044dc:	9fb9                	addw	a5,a5,a4
    800044de:	00f95963          	bge	s2,a5,800044f0 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800044e2:	85a6                	mv	a1,s1
    800044e4:	8526                	mv	a0,s1
    800044e6:	ffffe097          	auipc	ra,0xffffe
    800044ea:	ff6080e7          	jalr	-10(ra) # 800024dc <sleep>
    800044ee:	bfd1                	j	800044c2 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800044f0:	0001d517          	auipc	a0,0x1d
    800044f4:	18050513          	addi	a0,a0,384 # 80021670 <log>
    800044f8:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800044fa:	ffffc097          	auipc	ra,0xffffc
    800044fe:	7f4080e7          	jalr	2036(ra) # 80000cee <release>
      break;
    }
  }
}
    80004502:	60e2                	ld	ra,24(sp)
    80004504:	6442                	ld	s0,16(sp)
    80004506:	64a2                	ld	s1,8(sp)
    80004508:	6902                	ld	s2,0(sp)
    8000450a:	6105                	addi	sp,sp,32
    8000450c:	8082                	ret

000000008000450e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000450e:	7139                	addi	sp,sp,-64
    80004510:	fc06                	sd	ra,56(sp)
    80004512:	f822                	sd	s0,48(sp)
    80004514:	f426                	sd	s1,40(sp)
    80004516:	f04a                	sd	s2,32(sp)
    80004518:	ec4e                	sd	s3,24(sp)
    8000451a:	e852                	sd	s4,16(sp)
    8000451c:	e456                	sd	s5,8(sp)
    8000451e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004520:	0001d497          	auipc	s1,0x1d
    80004524:	15048493          	addi	s1,s1,336 # 80021670 <log>
    80004528:	8526                	mv	a0,s1
    8000452a:	ffffc097          	auipc	ra,0xffffc
    8000452e:	710080e7          	jalr	1808(ra) # 80000c3a <acquire>
  log.outstanding -= 1;
    80004532:	509c                	lw	a5,32(s1)
    80004534:	37fd                	addiw	a5,a5,-1
    80004536:	0007891b          	sext.w	s2,a5
    8000453a:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000453c:	50dc                	lw	a5,36(s1)
    8000453e:	e7b9                	bnez	a5,8000458c <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80004540:	04091e63          	bnez	s2,8000459c <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004544:	0001d497          	auipc	s1,0x1d
    80004548:	12c48493          	addi	s1,s1,300 # 80021670 <log>
    8000454c:	4785                	li	a5,1
    8000454e:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004550:	8526                	mv	a0,s1
    80004552:	ffffc097          	auipc	ra,0xffffc
    80004556:	79c080e7          	jalr	1948(ra) # 80000cee <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000455a:	54dc                	lw	a5,44(s1)
    8000455c:	06f04763          	bgtz	a5,800045ca <end_op+0xbc>
    acquire(&log.lock);
    80004560:	0001d497          	auipc	s1,0x1d
    80004564:	11048493          	addi	s1,s1,272 # 80021670 <log>
    80004568:	8526                	mv	a0,s1
    8000456a:	ffffc097          	auipc	ra,0xffffc
    8000456e:	6d0080e7          	jalr	1744(ra) # 80000c3a <acquire>
    log.committing = 0;
    80004572:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004576:	8526                	mv	a0,s1
    80004578:	ffffe097          	auipc	ra,0xffffe
    8000457c:	0f0080e7          	jalr	240(ra) # 80002668 <wakeup>
    release(&log.lock);
    80004580:	8526                	mv	a0,s1
    80004582:	ffffc097          	auipc	ra,0xffffc
    80004586:	76c080e7          	jalr	1900(ra) # 80000cee <release>
}
    8000458a:	a03d                	j	800045b8 <end_op+0xaa>
    panic("log.committing");
    8000458c:	00004517          	auipc	a0,0x4
    80004590:	1c450513          	addi	a0,a0,452 # 80008750 <syscalls+0x1e8>
    80004594:	ffffc097          	auipc	ra,0xffffc
    80004598:	038080e7          	jalr	56(ra) # 800005cc <panic>
    wakeup(&log);
    8000459c:	0001d497          	auipc	s1,0x1d
    800045a0:	0d448493          	addi	s1,s1,212 # 80021670 <log>
    800045a4:	8526                	mv	a0,s1
    800045a6:	ffffe097          	auipc	ra,0xffffe
    800045aa:	0c2080e7          	jalr	194(ra) # 80002668 <wakeup>
  release(&log.lock);
    800045ae:	8526                	mv	a0,s1
    800045b0:	ffffc097          	auipc	ra,0xffffc
    800045b4:	73e080e7          	jalr	1854(ra) # 80000cee <release>
}
    800045b8:	70e2                	ld	ra,56(sp)
    800045ba:	7442                	ld	s0,48(sp)
    800045bc:	74a2                	ld	s1,40(sp)
    800045be:	7902                	ld	s2,32(sp)
    800045c0:	69e2                	ld	s3,24(sp)
    800045c2:	6a42                	ld	s4,16(sp)
    800045c4:	6aa2                	ld	s5,8(sp)
    800045c6:	6121                	addi	sp,sp,64
    800045c8:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800045ca:	0001da97          	auipc	s5,0x1d
    800045ce:	0d6a8a93          	addi	s5,s5,214 # 800216a0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800045d2:	0001da17          	auipc	s4,0x1d
    800045d6:	09ea0a13          	addi	s4,s4,158 # 80021670 <log>
    800045da:	018a2583          	lw	a1,24(s4)
    800045de:	012585bb          	addw	a1,a1,s2
    800045e2:	2585                	addiw	a1,a1,1
    800045e4:	028a2503          	lw	a0,40(s4)
    800045e8:	fffff097          	auipc	ra,0xfffff
    800045ec:	cd2080e7          	jalr	-814(ra) # 800032ba <bread>
    800045f0:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800045f2:	000aa583          	lw	a1,0(s5)
    800045f6:	028a2503          	lw	a0,40(s4)
    800045fa:	fffff097          	auipc	ra,0xfffff
    800045fe:	cc0080e7          	jalr	-832(ra) # 800032ba <bread>
    80004602:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004604:	40000613          	li	a2,1024
    80004608:	05850593          	addi	a1,a0,88
    8000460c:	05848513          	addi	a0,s1,88
    80004610:	ffffc097          	auipc	ra,0xffffc
    80004614:	782080e7          	jalr	1922(ra) # 80000d92 <memmove>
    bwrite(to);  // write the log
    80004618:	8526                	mv	a0,s1
    8000461a:	fffff097          	auipc	ra,0xfffff
    8000461e:	d92080e7          	jalr	-622(ra) # 800033ac <bwrite>
    brelse(from);
    80004622:	854e                	mv	a0,s3
    80004624:	fffff097          	auipc	ra,0xfffff
    80004628:	dc6080e7          	jalr	-570(ra) # 800033ea <brelse>
    brelse(to);
    8000462c:	8526                	mv	a0,s1
    8000462e:	fffff097          	auipc	ra,0xfffff
    80004632:	dbc080e7          	jalr	-580(ra) # 800033ea <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004636:	2905                	addiw	s2,s2,1
    80004638:	0a91                	addi	s5,s5,4
    8000463a:	02ca2783          	lw	a5,44(s4)
    8000463e:	f8f94ee3          	blt	s2,a5,800045da <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004642:	00000097          	auipc	ra,0x0
    80004646:	c6a080e7          	jalr	-918(ra) # 800042ac <write_head>
    install_trans(0); // Now install writes to home locations
    8000464a:	4501                	li	a0,0
    8000464c:	00000097          	auipc	ra,0x0
    80004650:	cda080e7          	jalr	-806(ra) # 80004326 <install_trans>
    log.lh.n = 0;
    80004654:	0001d797          	auipc	a5,0x1d
    80004658:	0407a423          	sw	zero,72(a5) # 8002169c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000465c:	00000097          	auipc	ra,0x0
    80004660:	c50080e7          	jalr	-944(ra) # 800042ac <write_head>
    80004664:	bdf5                	j	80004560 <end_op+0x52>

0000000080004666 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004666:	1101                	addi	sp,sp,-32
    80004668:	ec06                	sd	ra,24(sp)
    8000466a:	e822                	sd	s0,16(sp)
    8000466c:	e426                	sd	s1,8(sp)
    8000466e:	e04a                	sd	s2,0(sp)
    80004670:	1000                	addi	s0,sp,32
    80004672:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004674:	0001d917          	auipc	s2,0x1d
    80004678:	ffc90913          	addi	s2,s2,-4 # 80021670 <log>
    8000467c:	854a                	mv	a0,s2
    8000467e:	ffffc097          	auipc	ra,0xffffc
    80004682:	5bc080e7          	jalr	1468(ra) # 80000c3a <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004686:	02c92603          	lw	a2,44(s2)
    8000468a:	47f5                	li	a5,29
    8000468c:	06c7c563          	blt	a5,a2,800046f6 <log_write+0x90>
    80004690:	0001d797          	auipc	a5,0x1d
    80004694:	ffc7a783          	lw	a5,-4(a5) # 8002168c <log+0x1c>
    80004698:	37fd                	addiw	a5,a5,-1
    8000469a:	04f65e63          	bge	a2,a5,800046f6 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000469e:	0001d797          	auipc	a5,0x1d
    800046a2:	ff27a783          	lw	a5,-14(a5) # 80021690 <log+0x20>
    800046a6:	06f05063          	blez	a5,80004706 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800046aa:	4781                	li	a5,0
    800046ac:	06c05563          	blez	a2,80004716 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800046b0:	44cc                	lw	a1,12(s1)
    800046b2:	0001d717          	auipc	a4,0x1d
    800046b6:	fee70713          	addi	a4,a4,-18 # 800216a0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800046ba:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800046bc:	4314                	lw	a3,0(a4)
    800046be:	04b68c63          	beq	a3,a1,80004716 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800046c2:	2785                	addiw	a5,a5,1
    800046c4:	0711                	addi	a4,a4,4
    800046c6:	fef61be3          	bne	a2,a5,800046bc <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800046ca:	0621                	addi	a2,a2,8
    800046cc:	060a                	slli	a2,a2,0x2
    800046ce:	0001d797          	auipc	a5,0x1d
    800046d2:	fa278793          	addi	a5,a5,-94 # 80021670 <log>
    800046d6:	963e                	add	a2,a2,a5
    800046d8:	44dc                	lw	a5,12(s1)
    800046da:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800046dc:	8526                	mv	a0,s1
    800046de:	fffff097          	auipc	ra,0xfffff
    800046e2:	daa080e7          	jalr	-598(ra) # 80003488 <bpin>
    log.lh.n++;
    800046e6:	0001d717          	auipc	a4,0x1d
    800046ea:	f8a70713          	addi	a4,a4,-118 # 80021670 <log>
    800046ee:	575c                	lw	a5,44(a4)
    800046f0:	2785                	addiw	a5,a5,1
    800046f2:	d75c                	sw	a5,44(a4)
    800046f4:	a835                	j	80004730 <log_write+0xca>
    panic("too big a transaction");
    800046f6:	00004517          	auipc	a0,0x4
    800046fa:	06a50513          	addi	a0,a0,106 # 80008760 <syscalls+0x1f8>
    800046fe:	ffffc097          	auipc	ra,0xffffc
    80004702:	ece080e7          	jalr	-306(ra) # 800005cc <panic>
    panic("log_write outside of trans");
    80004706:	00004517          	auipc	a0,0x4
    8000470a:	07250513          	addi	a0,a0,114 # 80008778 <syscalls+0x210>
    8000470e:	ffffc097          	auipc	ra,0xffffc
    80004712:	ebe080e7          	jalr	-322(ra) # 800005cc <panic>
  log.lh.block[i] = b->blockno;
    80004716:	00878713          	addi	a4,a5,8
    8000471a:	00271693          	slli	a3,a4,0x2
    8000471e:	0001d717          	auipc	a4,0x1d
    80004722:	f5270713          	addi	a4,a4,-174 # 80021670 <log>
    80004726:	9736                	add	a4,a4,a3
    80004728:	44d4                	lw	a3,12(s1)
    8000472a:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000472c:	faf608e3          	beq	a2,a5,800046dc <log_write+0x76>
  }
  release(&log.lock);
    80004730:	0001d517          	auipc	a0,0x1d
    80004734:	f4050513          	addi	a0,a0,-192 # 80021670 <log>
    80004738:	ffffc097          	auipc	ra,0xffffc
    8000473c:	5b6080e7          	jalr	1462(ra) # 80000cee <release>
}
    80004740:	60e2                	ld	ra,24(sp)
    80004742:	6442                	ld	s0,16(sp)
    80004744:	64a2                	ld	s1,8(sp)
    80004746:	6902                	ld	s2,0(sp)
    80004748:	6105                	addi	sp,sp,32
    8000474a:	8082                	ret

000000008000474c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000474c:	1101                	addi	sp,sp,-32
    8000474e:	ec06                	sd	ra,24(sp)
    80004750:	e822                	sd	s0,16(sp)
    80004752:	e426                	sd	s1,8(sp)
    80004754:	e04a                	sd	s2,0(sp)
    80004756:	1000                	addi	s0,sp,32
    80004758:	84aa                	mv	s1,a0
    8000475a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000475c:	00004597          	auipc	a1,0x4
    80004760:	03c58593          	addi	a1,a1,60 # 80008798 <syscalls+0x230>
    80004764:	0521                	addi	a0,a0,8
    80004766:	ffffc097          	auipc	ra,0xffffc
    8000476a:	444080e7          	jalr	1092(ra) # 80000baa <initlock>
  lk->name = name;
    8000476e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004772:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004776:	0204a423          	sw	zero,40(s1)
}
    8000477a:	60e2                	ld	ra,24(sp)
    8000477c:	6442                	ld	s0,16(sp)
    8000477e:	64a2                	ld	s1,8(sp)
    80004780:	6902                	ld	s2,0(sp)
    80004782:	6105                	addi	sp,sp,32
    80004784:	8082                	ret

0000000080004786 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004786:	1101                	addi	sp,sp,-32
    80004788:	ec06                	sd	ra,24(sp)
    8000478a:	e822                	sd	s0,16(sp)
    8000478c:	e426                	sd	s1,8(sp)
    8000478e:	e04a                	sd	s2,0(sp)
    80004790:	1000                	addi	s0,sp,32
    80004792:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004794:	00850913          	addi	s2,a0,8
    80004798:	854a                	mv	a0,s2
    8000479a:	ffffc097          	auipc	ra,0xffffc
    8000479e:	4a0080e7          	jalr	1184(ra) # 80000c3a <acquire>
  while (lk->locked) {
    800047a2:	409c                	lw	a5,0(s1)
    800047a4:	cb89                	beqz	a5,800047b6 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800047a6:	85ca                	mv	a1,s2
    800047a8:	8526                	mv	a0,s1
    800047aa:	ffffe097          	auipc	ra,0xffffe
    800047ae:	d32080e7          	jalr	-718(ra) # 800024dc <sleep>
  while (lk->locked) {
    800047b2:	409c                	lw	a5,0(s1)
    800047b4:	fbed                	bnez	a5,800047a6 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800047b6:	4785                	li	a5,1
    800047b8:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800047ba:	ffffd097          	auipc	ra,0xffffd
    800047be:	4b2080e7          	jalr	1202(ra) # 80001c6c <myproc>
    800047c2:	591c                	lw	a5,48(a0)
    800047c4:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800047c6:	854a                	mv	a0,s2
    800047c8:	ffffc097          	auipc	ra,0xffffc
    800047cc:	526080e7          	jalr	1318(ra) # 80000cee <release>
}
    800047d0:	60e2                	ld	ra,24(sp)
    800047d2:	6442                	ld	s0,16(sp)
    800047d4:	64a2                	ld	s1,8(sp)
    800047d6:	6902                	ld	s2,0(sp)
    800047d8:	6105                	addi	sp,sp,32
    800047da:	8082                	ret

00000000800047dc <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800047dc:	1101                	addi	sp,sp,-32
    800047de:	ec06                	sd	ra,24(sp)
    800047e0:	e822                	sd	s0,16(sp)
    800047e2:	e426                	sd	s1,8(sp)
    800047e4:	e04a                	sd	s2,0(sp)
    800047e6:	1000                	addi	s0,sp,32
    800047e8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800047ea:	00850913          	addi	s2,a0,8
    800047ee:	854a                	mv	a0,s2
    800047f0:	ffffc097          	auipc	ra,0xffffc
    800047f4:	44a080e7          	jalr	1098(ra) # 80000c3a <acquire>
  lk->locked = 0;
    800047f8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800047fc:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004800:	8526                	mv	a0,s1
    80004802:	ffffe097          	auipc	ra,0xffffe
    80004806:	e66080e7          	jalr	-410(ra) # 80002668 <wakeup>
  release(&lk->lk);
    8000480a:	854a                	mv	a0,s2
    8000480c:	ffffc097          	auipc	ra,0xffffc
    80004810:	4e2080e7          	jalr	1250(ra) # 80000cee <release>
}
    80004814:	60e2                	ld	ra,24(sp)
    80004816:	6442                	ld	s0,16(sp)
    80004818:	64a2                	ld	s1,8(sp)
    8000481a:	6902                	ld	s2,0(sp)
    8000481c:	6105                	addi	sp,sp,32
    8000481e:	8082                	ret

0000000080004820 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004820:	7179                	addi	sp,sp,-48
    80004822:	f406                	sd	ra,40(sp)
    80004824:	f022                	sd	s0,32(sp)
    80004826:	ec26                	sd	s1,24(sp)
    80004828:	e84a                	sd	s2,16(sp)
    8000482a:	e44e                	sd	s3,8(sp)
    8000482c:	1800                	addi	s0,sp,48
    8000482e:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004830:	00850913          	addi	s2,a0,8
    80004834:	854a                	mv	a0,s2
    80004836:	ffffc097          	auipc	ra,0xffffc
    8000483a:	404080e7          	jalr	1028(ra) # 80000c3a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000483e:	409c                	lw	a5,0(s1)
    80004840:	ef99                	bnez	a5,8000485e <holdingsleep+0x3e>
    80004842:	4481                	li	s1,0
  release(&lk->lk);
    80004844:	854a                	mv	a0,s2
    80004846:	ffffc097          	auipc	ra,0xffffc
    8000484a:	4a8080e7          	jalr	1192(ra) # 80000cee <release>
  return r;
}
    8000484e:	8526                	mv	a0,s1
    80004850:	70a2                	ld	ra,40(sp)
    80004852:	7402                	ld	s0,32(sp)
    80004854:	64e2                	ld	s1,24(sp)
    80004856:	6942                	ld	s2,16(sp)
    80004858:	69a2                	ld	s3,8(sp)
    8000485a:	6145                	addi	sp,sp,48
    8000485c:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000485e:	0284a983          	lw	s3,40(s1)
    80004862:	ffffd097          	auipc	ra,0xffffd
    80004866:	40a080e7          	jalr	1034(ra) # 80001c6c <myproc>
    8000486a:	5904                	lw	s1,48(a0)
    8000486c:	413484b3          	sub	s1,s1,s3
    80004870:	0014b493          	seqz	s1,s1
    80004874:	bfc1                	j	80004844 <holdingsleep+0x24>

0000000080004876 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004876:	1141                	addi	sp,sp,-16
    80004878:	e406                	sd	ra,8(sp)
    8000487a:	e022                	sd	s0,0(sp)
    8000487c:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000487e:	00004597          	auipc	a1,0x4
    80004882:	f2a58593          	addi	a1,a1,-214 # 800087a8 <syscalls+0x240>
    80004886:	0001d517          	auipc	a0,0x1d
    8000488a:	f3250513          	addi	a0,a0,-206 # 800217b8 <ftable>
    8000488e:	ffffc097          	auipc	ra,0xffffc
    80004892:	31c080e7          	jalr	796(ra) # 80000baa <initlock>
}
    80004896:	60a2                	ld	ra,8(sp)
    80004898:	6402                	ld	s0,0(sp)
    8000489a:	0141                	addi	sp,sp,16
    8000489c:	8082                	ret

000000008000489e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000489e:	1101                	addi	sp,sp,-32
    800048a0:	ec06                	sd	ra,24(sp)
    800048a2:	e822                	sd	s0,16(sp)
    800048a4:	e426                	sd	s1,8(sp)
    800048a6:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800048a8:	0001d517          	auipc	a0,0x1d
    800048ac:	f1050513          	addi	a0,a0,-240 # 800217b8 <ftable>
    800048b0:	ffffc097          	auipc	ra,0xffffc
    800048b4:	38a080e7          	jalr	906(ra) # 80000c3a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800048b8:	0001d497          	auipc	s1,0x1d
    800048bc:	f1848493          	addi	s1,s1,-232 # 800217d0 <ftable+0x18>
    800048c0:	0001e717          	auipc	a4,0x1e
    800048c4:	eb070713          	addi	a4,a4,-336 # 80022770 <ftable+0xfb8>
    if(f->ref == 0){
    800048c8:	40dc                	lw	a5,4(s1)
    800048ca:	cf99                	beqz	a5,800048e8 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800048cc:	02848493          	addi	s1,s1,40
    800048d0:	fee49ce3          	bne	s1,a4,800048c8 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800048d4:	0001d517          	auipc	a0,0x1d
    800048d8:	ee450513          	addi	a0,a0,-284 # 800217b8 <ftable>
    800048dc:	ffffc097          	auipc	ra,0xffffc
    800048e0:	412080e7          	jalr	1042(ra) # 80000cee <release>
  return 0;
    800048e4:	4481                	li	s1,0
    800048e6:	a819                	j	800048fc <filealloc+0x5e>
      f->ref = 1;
    800048e8:	4785                	li	a5,1
    800048ea:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800048ec:	0001d517          	auipc	a0,0x1d
    800048f0:	ecc50513          	addi	a0,a0,-308 # 800217b8 <ftable>
    800048f4:	ffffc097          	auipc	ra,0xffffc
    800048f8:	3fa080e7          	jalr	1018(ra) # 80000cee <release>
}
    800048fc:	8526                	mv	a0,s1
    800048fe:	60e2                	ld	ra,24(sp)
    80004900:	6442                	ld	s0,16(sp)
    80004902:	64a2                	ld	s1,8(sp)
    80004904:	6105                	addi	sp,sp,32
    80004906:	8082                	ret

0000000080004908 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004908:	1101                	addi	sp,sp,-32
    8000490a:	ec06                	sd	ra,24(sp)
    8000490c:	e822                	sd	s0,16(sp)
    8000490e:	e426                	sd	s1,8(sp)
    80004910:	1000                	addi	s0,sp,32
    80004912:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004914:	0001d517          	auipc	a0,0x1d
    80004918:	ea450513          	addi	a0,a0,-348 # 800217b8 <ftable>
    8000491c:	ffffc097          	auipc	ra,0xffffc
    80004920:	31e080e7          	jalr	798(ra) # 80000c3a <acquire>
  if(f->ref < 1)
    80004924:	40dc                	lw	a5,4(s1)
    80004926:	02f05263          	blez	a5,8000494a <filedup+0x42>
    panic("filedup");
  f->ref++;
    8000492a:	2785                	addiw	a5,a5,1
    8000492c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000492e:	0001d517          	auipc	a0,0x1d
    80004932:	e8a50513          	addi	a0,a0,-374 # 800217b8 <ftable>
    80004936:	ffffc097          	auipc	ra,0xffffc
    8000493a:	3b8080e7          	jalr	952(ra) # 80000cee <release>
  return f;
}
    8000493e:	8526                	mv	a0,s1
    80004940:	60e2                	ld	ra,24(sp)
    80004942:	6442                	ld	s0,16(sp)
    80004944:	64a2                	ld	s1,8(sp)
    80004946:	6105                	addi	sp,sp,32
    80004948:	8082                	ret
    panic("filedup");
    8000494a:	00004517          	auipc	a0,0x4
    8000494e:	e6650513          	addi	a0,a0,-410 # 800087b0 <syscalls+0x248>
    80004952:	ffffc097          	auipc	ra,0xffffc
    80004956:	c7a080e7          	jalr	-902(ra) # 800005cc <panic>

000000008000495a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000495a:	7139                	addi	sp,sp,-64
    8000495c:	fc06                	sd	ra,56(sp)
    8000495e:	f822                	sd	s0,48(sp)
    80004960:	f426                	sd	s1,40(sp)
    80004962:	f04a                	sd	s2,32(sp)
    80004964:	ec4e                	sd	s3,24(sp)
    80004966:	e852                	sd	s4,16(sp)
    80004968:	e456                	sd	s5,8(sp)
    8000496a:	0080                	addi	s0,sp,64
    8000496c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000496e:	0001d517          	auipc	a0,0x1d
    80004972:	e4a50513          	addi	a0,a0,-438 # 800217b8 <ftable>
    80004976:	ffffc097          	auipc	ra,0xffffc
    8000497a:	2c4080e7          	jalr	708(ra) # 80000c3a <acquire>
  if(f->ref < 1)
    8000497e:	40dc                	lw	a5,4(s1)
    80004980:	06f05163          	blez	a5,800049e2 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004984:	37fd                	addiw	a5,a5,-1
    80004986:	0007871b          	sext.w	a4,a5
    8000498a:	c0dc                	sw	a5,4(s1)
    8000498c:	06e04363          	bgtz	a4,800049f2 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004990:	0004a903          	lw	s2,0(s1)
    80004994:	0094ca83          	lbu	s5,9(s1)
    80004998:	0104ba03          	ld	s4,16(s1)
    8000499c:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800049a0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800049a4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800049a8:	0001d517          	auipc	a0,0x1d
    800049ac:	e1050513          	addi	a0,a0,-496 # 800217b8 <ftable>
    800049b0:	ffffc097          	auipc	ra,0xffffc
    800049b4:	33e080e7          	jalr	830(ra) # 80000cee <release>

  if(ff.type == FD_PIPE){
    800049b8:	4785                	li	a5,1
    800049ba:	04f90d63          	beq	s2,a5,80004a14 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800049be:	3979                	addiw	s2,s2,-2
    800049c0:	4785                	li	a5,1
    800049c2:	0527e063          	bltu	a5,s2,80004a02 <fileclose+0xa8>
    begin_op();
    800049c6:	00000097          	auipc	ra,0x0
    800049ca:	ac8080e7          	jalr	-1336(ra) # 8000448e <begin_op>
    iput(ff.ip);
    800049ce:	854e                	mv	a0,s3
    800049d0:	fffff097          	auipc	ra,0xfffff
    800049d4:	2a6080e7          	jalr	678(ra) # 80003c76 <iput>
    end_op();
    800049d8:	00000097          	auipc	ra,0x0
    800049dc:	b36080e7          	jalr	-1226(ra) # 8000450e <end_op>
    800049e0:	a00d                	j	80004a02 <fileclose+0xa8>
    panic("fileclose");
    800049e2:	00004517          	auipc	a0,0x4
    800049e6:	dd650513          	addi	a0,a0,-554 # 800087b8 <syscalls+0x250>
    800049ea:	ffffc097          	auipc	ra,0xffffc
    800049ee:	be2080e7          	jalr	-1054(ra) # 800005cc <panic>
    release(&ftable.lock);
    800049f2:	0001d517          	auipc	a0,0x1d
    800049f6:	dc650513          	addi	a0,a0,-570 # 800217b8 <ftable>
    800049fa:	ffffc097          	auipc	ra,0xffffc
    800049fe:	2f4080e7          	jalr	756(ra) # 80000cee <release>
  }
}
    80004a02:	70e2                	ld	ra,56(sp)
    80004a04:	7442                	ld	s0,48(sp)
    80004a06:	74a2                	ld	s1,40(sp)
    80004a08:	7902                	ld	s2,32(sp)
    80004a0a:	69e2                	ld	s3,24(sp)
    80004a0c:	6a42                	ld	s4,16(sp)
    80004a0e:	6aa2                	ld	s5,8(sp)
    80004a10:	6121                	addi	sp,sp,64
    80004a12:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004a14:	85d6                	mv	a1,s5
    80004a16:	8552                	mv	a0,s4
    80004a18:	00000097          	auipc	ra,0x0
    80004a1c:	34c080e7          	jalr	844(ra) # 80004d64 <pipeclose>
    80004a20:	b7cd                	j	80004a02 <fileclose+0xa8>

0000000080004a22 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004a22:	715d                	addi	sp,sp,-80
    80004a24:	e486                	sd	ra,72(sp)
    80004a26:	e0a2                	sd	s0,64(sp)
    80004a28:	fc26                	sd	s1,56(sp)
    80004a2a:	f84a                	sd	s2,48(sp)
    80004a2c:	f44e                	sd	s3,40(sp)
    80004a2e:	0880                	addi	s0,sp,80
    80004a30:	84aa                	mv	s1,a0
    80004a32:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004a34:	ffffd097          	auipc	ra,0xffffd
    80004a38:	238080e7          	jalr	568(ra) # 80001c6c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004a3c:	409c                	lw	a5,0(s1)
    80004a3e:	37f9                	addiw	a5,a5,-2
    80004a40:	4705                	li	a4,1
    80004a42:	04f76763          	bltu	a4,a5,80004a90 <filestat+0x6e>
    80004a46:	892a                	mv	s2,a0
    ilock(f->ip);
    80004a48:	6c88                	ld	a0,24(s1)
    80004a4a:	fffff097          	auipc	ra,0xfffff
    80004a4e:	072080e7          	jalr	114(ra) # 80003abc <ilock>
    stati(f->ip, &st);
    80004a52:	fb840593          	addi	a1,s0,-72
    80004a56:	6c88                	ld	a0,24(s1)
    80004a58:	fffff097          	auipc	ra,0xfffff
    80004a5c:	2ee080e7          	jalr	750(ra) # 80003d46 <stati>
    iunlock(f->ip);
    80004a60:	6c88                	ld	a0,24(s1)
    80004a62:	fffff097          	auipc	ra,0xfffff
    80004a66:	11c080e7          	jalr	284(ra) # 80003b7e <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004a6a:	46e1                	li	a3,24
    80004a6c:	fb840613          	addi	a2,s0,-72
    80004a70:	85ce                	mv	a1,s3
    80004a72:	05893503          	ld	a0,88(s2)
    80004a76:	ffffd097          	auipc	ra,0xffffd
    80004a7a:	de6080e7          	jalr	-538(ra) # 8000185c <copyout>
    80004a7e:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004a82:	60a6                	ld	ra,72(sp)
    80004a84:	6406                	ld	s0,64(sp)
    80004a86:	74e2                	ld	s1,56(sp)
    80004a88:	7942                	ld	s2,48(sp)
    80004a8a:	79a2                	ld	s3,40(sp)
    80004a8c:	6161                	addi	sp,sp,80
    80004a8e:	8082                	ret
  return -1;
    80004a90:	557d                	li	a0,-1
    80004a92:	bfc5                	j	80004a82 <filestat+0x60>

0000000080004a94 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004a94:	7179                	addi	sp,sp,-48
    80004a96:	f406                	sd	ra,40(sp)
    80004a98:	f022                	sd	s0,32(sp)
    80004a9a:	ec26                	sd	s1,24(sp)
    80004a9c:	e84a                	sd	s2,16(sp)
    80004a9e:	e44e                	sd	s3,8(sp)
    80004aa0:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004aa2:	00854783          	lbu	a5,8(a0)
    80004aa6:	c3d5                	beqz	a5,80004b4a <fileread+0xb6>
    80004aa8:	84aa                	mv	s1,a0
    80004aaa:	89ae                	mv	s3,a1
    80004aac:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004aae:	411c                	lw	a5,0(a0)
    80004ab0:	4705                	li	a4,1
    80004ab2:	04e78963          	beq	a5,a4,80004b04 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004ab6:	470d                	li	a4,3
    80004ab8:	04e78d63          	beq	a5,a4,80004b12 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004abc:	4709                	li	a4,2
    80004abe:	06e79e63          	bne	a5,a4,80004b3a <fileread+0xa6>
    ilock(f->ip);
    80004ac2:	6d08                	ld	a0,24(a0)
    80004ac4:	fffff097          	auipc	ra,0xfffff
    80004ac8:	ff8080e7          	jalr	-8(ra) # 80003abc <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004acc:	874a                	mv	a4,s2
    80004ace:	5094                	lw	a3,32(s1)
    80004ad0:	864e                	mv	a2,s3
    80004ad2:	4585                	li	a1,1
    80004ad4:	6c88                	ld	a0,24(s1)
    80004ad6:	fffff097          	auipc	ra,0xfffff
    80004ada:	29a080e7          	jalr	666(ra) # 80003d70 <readi>
    80004ade:	892a                	mv	s2,a0
    80004ae0:	00a05563          	blez	a0,80004aea <fileread+0x56>
      f->off += r;
    80004ae4:	509c                	lw	a5,32(s1)
    80004ae6:	9fa9                	addw	a5,a5,a0
    80004ae8:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004aea:	6c88                	ld	a0,24(s1)
    80004aec:	fffff097          	auipc	ra,0xfffff
    80004af0:	092080e7          	jalr	146(ra) # 80003b7e <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004af4:	854a                	mv	a0,s2
    80004af6:	70a2                	ld	ra,40(sp)
    80004af8:	7402                	ld	s0,32(sp)
    80004afa:	64e2                	ld	s1,24(sp)
    80004afc:	6942                	ld	s2,16(sp)
    80004afe:	69a2                	ld	s3,8(sp)
    80004b00:	6145                	addi	sp,sp,48
    80004b02:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004b04:	6908                	ld	a0,16(a0)
    80004b06:	00000097          	auipc	ra,0x0
    80004b0a:	3c0080e7          	jalr	960(ra) # 80004ec6 <piperead>
    80004b0e:	892a                	mv	s2,a0
    80004b10:	b7d5                	j	80004af4 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004b12:	02451783          	lh	a5,36(a0)
    80004b16:	03079693          	slli	a3,a5,0x30
    80004b1a:	92c1                	srli	a3,a3,0x30
    80004b1c:	4725                	li	a4,9
    80004b1e:	02d76863          	bltu	a4,a3,80004b4e <fileread+0xba>
    80004b22:	0792                	slli	a5,a5,0x4
    80004b24:	0001d717          	auipc	a4,0x1d
    80004b28:	bf470713          	addi	a4,a4,-1036 # 80021718 <devsw>
    80004b2c:	97ba                	add	a5,a5,a4
    80004b2e:	639c                	ld	a5,0(a5)
    80004b30:	c38d                	beqz	a5,80004b52 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004b32:	4505                	li	a0,1
    80004b34:	9782                	jalr	a5
    80004b36:	892a                	mv	s2,a0
    80004b38:	bf75                	j	80004af4 <fileread+0x60>
    panic("fileread");
    80004b3a:	00004517          	auipc	a0,0x4
    80004b3e:	c8e50513          	addi	a0,a0,-882 # 800087c8 <syscalls+0x260>
    80004b42:	ffffc097          	auipc	ra,0xffffc
    80004b46:	a8a080e7          	jalr	-1398(ra) # 800005cc <panic>
    return -1;
    80004b4a:	597d                	li	s2,-1
    80004b4c:	b765                	j	80004af4 <fileread+0x60>
      return -1;
    80004b4e:	597d                	li	s2,-1
    80004b50:	b755                	j	80004af4 <fileread+0x60>
    80004b52:	597d                	li	s2,-1
    80004b54:	b745                	j	80004af4 <fileread+0x60>

0000000080004b56 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80004b56:	715d                	addi	sp,sp,-80
    80004b58:	e486                	sd	ra,72(sp)
    80004b5a:	e0a2                	sd	s0,64(sp)
    80004b5c:	fc26                	sd	s1,56(sp)
    80004b5e:	f84a                	sd	s2,48(sp)
    80004b60:	f44e                	sd	s3,40(sp)
    80004b62:	f052                	sd	s4,32(sp)
    80004b64:	ec56                	sd	s5,24(sp)
    80004b66:	e85a                	sd	s6,16(sp)
    80004b68:	e45e                	sd	s7,8(sp)
    80004b6a:	e062                	sd	s8,0(sp)
    80004b6c:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80004b6e:	00954783          	lbu	a5,9(a0)
    80004b72:	10078663          	beqz	a5,80004c7e <filewrite+0x128>
    80004b76:	892a                	mv	s2,a0
    80004b78:	8aae                	mv	s5,a1
    80004b7a:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004b7c:	411c                	lw	a5,0(a0)
    80004b7e:	4705                	li	a4,1
    80004b80:	02e78263          	beq	a5,a4,80004ba4 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004b84:	470d                	li	a4,3
    80004b86:	02e78663          	beq	a5,a4,80004bb2 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004b8a:	4709                	li	a4,2
    80004b8c:	0ee79163          	bne	a5,a4,80004c6e <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004b90:	0ac05d63          	blez	a2,80004c4a <filewrite+0xf4>
    int i = 0;
    80004b94:	4981                	li	s3,0
    80004b96:	6b05                	lui	s6,0x1
    80004b98:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004b9c:	6b85                	lui	s7,0x1
    80004b9e:	c00b8b9b          	addiw	s7,s7,-1024
    80004ba2:	a861                	j	80004c3a <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80004ba4:	6908                	ld	a0,16(a0)
    80004ba6:	00000097          	auipc	ra,0x0
    80004baa:	22e080e7          	jalr	558(ra) # 80004dd4 <pipewrite>
    80004bae:	8a2a                	mv	s4,a0
    80004bb0:	a045                	j	80004c50 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004bb2:	02451783          	lh	a5,36(a0)
    80004bb6:	03079693          	slli	a3,a5,0x30
    80004bba:	92c1                	srli	a3,a3,0x30
    80004bbc:	4725                	li	a4,9
    80004bbe:	0cd76263          	bltu	a4,a3,80004c82 <filewrite+0x12c>
    80004bc2:	0792                	slli	a5,a5,0x4
    80004bc4:	0001d717          	auipc	a4,0x1d
    80004bc8:	b5470713          	addi	a4,a4,-1196 # 80021718 <devsw>
    80004bcc:	97ba                	add	a5,a5,a4
    80004bce:	679c                	ld	a5,8(a5)
    80004bd0:	cbdd                	beqz	a5,80004c86 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80004bd2:	4505                	li	a0,1
    80004bd4:	9782                	jalr	a5
    80004bd6:	8a2a                	mv	s4,a0
    80004bd8:	a8a5                	j	80004c50 <filewrite+0xfa>
    80004bda:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004bde:	00000097          	auipc	ra,0x0
    80004be2:	8b0080e7          	jalr	-1872(ra) # 8000448e <begin_op>
      ilock(f->ip);
    80004be6:	01893503          	ld	a0,24(s2)
    80004bea:	fffff097          	auipc	ra,0xfffff
    80004bee:	ed2080e7          	jalr	-302(ra) # 80003abc <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004bf2:	8762                	mv	a4,s8
    80004bf4:	02092683          	lw	a3,32(s2)
    80004bf8:	01598633          	add	a2,s3,s5
    80004bfc:	4585                	li	a1,1
    80004bfe:	01893503          	ld	a0,24(s2)
    80004c02:	fffff097          	auipc	ra,0xfffff
    80004c06:	266080e7          	jalr	614(ra) # 80003e68 <writei>
    80004c0a:	84aa                	mv	s1,a0
    80004c0c:	00a05763          	blez	a0,80004c1a <filewrite+0xc4>
        f->off += r;
    80004c10:	02092783          	lw	a5,32(s2)
    80004c14:	9fa9                	addw	a5,a5,a0
    80004c16:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004c1a:	01893503          	ld	a0,24(s2)
    80004c1e:	fffff097          	auipc	ra,0xfffff
    80004c22:	f60080e7          	jalr	-160(ra) # 80003b7e <iunlock>
      end_op();
    80004c26:	00000097          	auipc	ra,0x0
    80004c2a:	8e8080e7          	jalr	-1816(ra) # 8000450e <end_op>

      if(r != n1){
    80004c2e:	009c1f63          	bne	s8,s1,80004c4c <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80004c32:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004c36:	0149db63          	bge	s3,s4,80004c4c <filewrite+0xf6>
      int n1 = n - i;
    80004c3a:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004c3e:	84be                	mv	s1,a5
    80004c40:	2781                	sext.w	a5,a5
    80004c42:	f8fb5ce3          	bge	s6,a5,80004bda <filewrite+0x84>
    80004c46:	84de                	mv	s1,s7
    80004c48:	bf49                	j	80004bda <filewrite+0x84>
    int i = 0;
    80004c4a:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004c4c:	013a1f63          	bne	s4,s3,80004c6a <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004c50:	8552                	mv	a0,s4
    80004c52:	60a6                	ld	ra,72(sp)
    80004c54:	6406                	ld	s0,64(sp)
    80004c56:	74e2                	ld	s1,56(sp)
    80004c58:	7942                	ld	s2,48(sp)
    80004c5a:	79a2                	ld	s3,40(sp)
    80004c5c:	7a02                	ld	s4,32(sp)
    80004c5e:	6ae2                	ld	s5,24(sp)
    80004c60:	6b42                	ld	s6,16(sp)
    80004c62:	6ba2                	ld	s7,8(sp)
    80004c64:	6c02                	ld	s8,0(sp)
    80004c66:	6161                	addi	sp,sp,80
    80004c68:	8082                	ret
    ret = (i == n ? n : -1);
    80004c6a:	5a7d                	li	s4,-1
    80004c6c:	b7d5                	j	80004c50 <filewrite+0xfa>
    panic("filewrite");
    80004c6e:	00004517          	auipc	a0,0x4
    80004c72:	b6a50513          	addi	a0,a0,-1174 # 800087d8 <syscalls+0x270>
    80004c76:	ffffc097          	auipc	ra,0xffffc
    80004c7a:	956080e7          	jalr	-1706(ra) # 800005cc <panic>
    return -1;
    80004c7e:	5a7d                	li	s4,-1
    80004c80:	bfc1                	j	80004c50 <filewrite+0xfa>
      return -1;
    80004c82:	5a7d                	li	s4,-1
    80004c84:	b7f1                	j	80004c50 <filewrite+0xfa>
    80004c86:	5a7d                	li	s4,-1
    80004c88:	b7e1                	j	80004c50 <filewrite+0xfa>

0000000080004c8a <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004c8a:	7179                	addi	sp,sp,-48
    80004c8c:	f406                	sd	ra,40(sp)
    80004c8e:	f022                	sd	s0,32(sp)
    80004c90:	ec26                	sd	s1,24(sp)
    80004c92:	e84a                	sd	s2,16(sp)
    80004c94:	e44e                	sd	s3,8(sp)
    80004c96:	e052                	sd	s4,0(sp)
    80004c98:	1800                	addi	s0,sp,48
    80004c9a:	84aa                	mv	s1,a0
    80004c9c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004c9e:	0005b023          	sd	zero,0(a1)
    80004ca2:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004ca6:	00000097          	auipc	ra,0x0
    80004caa:	bf8080e7          	jalr	-1032(ra) # 8000489e <filealloc>
    80004cae:	e088                	sd	a0,0(s1)
    80004cb0:	c551                	beqz	a0,80004d3c <pipealloc+0xb2>
    80004cb2:	00000097          	auipc	ra,0x0
    80004cb6:	bec080e7          	jalr	-1044(ra) # 8000489e <filealloc>
    80004cba:	00aa3023          	sd	a0,0(s4)
    80004cbe:	c92d                	beqz	a0,80004d30 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004cc0:	ffffc097          	auipc	ra,0xffffc
    80004cc4:	e8a080e7          	jalr	-374(ra) # 80000b4a <kalloc>
    80004cc8:	892a                	mv	s2,a0
    80004cca:	c125                	beqz	a0,80004d2a <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004ccc:	4985                	li	s3,1
    80004cce:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004cd2:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004cd6:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004cda:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004cde:	00004597          	auipc	a1,0x4
    80004ce2:	b0a58593          	addi	a1,a1,-1270 # 800087e8 <syscalls+0x280>
    80004ce6:	ffffc097          	auipc	ra,0xffffc
    80004cea:	ec4080e7          	jalr	-316(ra) # 80000baa <initlock>
  (*f0)->type = FD_PIPE;
    80004cee:	609c                	ld	a5,0(s1)
    80004cf0:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004cf4:	609c                	ld	a5,0(s1)
    80004cf6:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004cfa:	609c                	ld	a5,0(s1)
    80004cfc:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004d00:	609c                	ld	a5,0(s1)
    80004d02:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004d06:	000a3783          	ld	a5,0(s4)
    80004d0a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004d0e:	000a3783          	ld	a5,0(s4)
    80004d12:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004d16:	000a3783          	ld	a5,0(s4)
    80004d1a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004d1e:	000a3783          	ld	a5,0(s4)
    80004d22:	0127b823          	sd	s2,16(a5)
  return 0;
    80004d26:	4501                	li	a0,0
    80004d28:	a025                	j	80004d50 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004d2a:	6088                	ld	a0,0(s1)
    80004d2c:	e501                	bnez	a0,80004d34 <pipealloc+0xaa>
    80004d2e:	a039                	j	80004d3c <pipealloc+0xb2>
    80004d30:	6088                	ld	a0,0(s1)
    80004d32:	c51d                	beqz	a0,80004d60 <pipealloc+0xd6>
    fileclose(*f0);
    80004d34:	00000097          	auipc	ra,0x0
    80004d38:	c26080e7          	jalr	-986(ra) # 8000495a <fileclose>
  if(*f1)
    80004d3c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004d40:	557d                	li	a0,-1
  if(*f1)
    80004d42:	c799                	beqz	a5,80004d50 <pipealloc+0xc6>
    fileclose(*f1);
    80004d44:	853e                	mv	a0,a5
    80004d46:	00000097          	auipc	ra,0x0
    80004d4a:	c14080e7          	jalr	-1004(ra) # 8000495a <fileclose>
  return -1;
    80004d4e:	557d                	li	a0,-1
}
    80004d50:	70a2                	ld	ra,40(sp)
    80004d52:	7402                	ld	s0,32(sp)
    80004d54:	64e2                	ld	s1,24(sp)
    80004d56:	6942                	ld	s2,16(sp)
    80004d58:	69a2                	ld	s3,8(sp)
    80004d5a:	6a02                	ld	s4,0(sp)
    80004d5c:	6145                	addi	sp,sp,48
    80004d5e:	8082                	ret
  return -1;
    80004d60:	557d                	li	a0,-1
    80004d62:	b7fd                	j	80004d50 <pipealloc+0xc6>

0000000080004d64 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004d64:	1101                	addi	sp,sp,-32
    80004d66:	ec06                	sd	ra,24(sp)
    80004d68:	e822                	sd	s0,16(sp)
    80004d6a:	e426                	sd	s1,8(sp)
    80004d6c:	e04a                	sd	s2,0(sp)
    80004d6e:	1000                	addi	s0,sp,32
    80004d70:	84aa                	mv	s1,a0
    80004d72:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004d74:	ffffc097          	auipc	ra,0xffffc
    80004d78:	ec6080e7          	jalr	-314(ra) # 80000c3a <acquire>
  if(writable){
    80004d7c:	02090d63          	beqz	s2,80004db6 <pipeclose+0x52>
    pi->writeopen = 0;
    80004d80:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004d84:	21848513          	addi	a0,s1,536
    80004d88:	ffffe097          	auipc	ra,0xffffe
    80004d8c:	8e0080e7          	jalr	-1824(ra) # 80002668 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004d90:	2204b783          	ld	a5,544(s1)
    80004d94:	eb95                	bnez	a5,80004dc8 <pipeclose+0x64>
    release(&pi->lock);
    80004d96:	8526                	mv	a0,s1
    80004d98:	ffffc097          	auipc	ra,0xffffc
    80004d9c:	f56080e7          	jalr	-170(ra) # 80000cee <release>
    kfree((char*)pi);
    80004da0:	8526                	mv	a0,s1
    80004da2:	ffffc097          	auipc	ra,0xffffc
    80004da6:	cac080e7          	jalr	-852(ra) # 80000a4e <kfree>
  } else
    release(&pi->lock);
}
    80004daa:	60e2                	ld	ra,24(sp)
    80004dac:	6442                	ld	s0,16(sp)
    80004dae:	64a2                	ld	s1,8(sp)
    80004db0:	6902                	ld	s2,0(sp)
    80004db2:	6105                	addi	sp,sp,32
    80004db4:	8082                	ret
    pi->readopen = 0;
    80004db6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004dba:	21c48513          	addi	a0,s1,540
    80004dbe:	ffffe097          	auipc	ra,0xffffe
    80004dc2:	8aa080e7          	jalr	-1878(ra) # 80002668 <wakeup>
    80004dc6:	b7e9                	j	80004d90 <pipeclose+0x2c>
    release(&pi->lock);
    80004dc8:	8526                	mv	a0,s1
    80004dca:	ffffc097          	auipc	ra,0xffffc
    80004dce:	f24080e7          	jalr	-220(ra) # 80000cee <release>
}
    80004dd2:	bfe1                	j	80004daa <pipeclose+0x46>

0000000080004dd4 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004dd4:	711d                	addi	sp,sp,-96
    80004dd6:	ec86                	sd	ra,88(sp)
    80004dd8:	e8a2                	sd	s0,80(sp)
    80004dda:	e4a6                	sd	s1,72(sp)
    80004ddc:	e0ca                	sd	s2,64(sp)
    80004dde:	fc4e                	sd	s3,56(sp)
    80004de0:	f852                	sd	s4,48(sp)
    80004de2:	f456                	sd	s5,40(sp)
    80004de4:	f05a                	sd	s6,32(sp)
    80004de6:	ec5e                	sd	s7,24(sp)
    80004de8:	e862                	sd	s8,16(sp)
    80004dea:	1080                	addi	s0,sp,96
    80004dec:	84aa                	mv	s1,a0
    80004dee:	8aae                	mv	s5,a1
    80004df0:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004df2:	ffffd097          	auipc	ra,0xffffd
    80004df6:	e7a080e7          	jalr	-390(ra) # 80001c6c <myproc>
    80004dfa:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004dfc:	8526                	mv	a0,s1
    80004dfe:	ffffc097          	auipc	ra,0xffffc
    80004e02:	e3c080e7          	jalr	-452(ra) # 80000c3a <acquire>
  while(i < n){
    80004e06:	0b405363          	blez	s4,80004eac <pipewrite+0xd8>
  int i = 0;
    80004e0a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004e0c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004e0e:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004e12:	21c48b93          	addi	s7,s1,540
    80004e16:	a089                	j	80004e58 <pipewrite+0x84>
      release(&pi->lock);
    80004e18:	8526                	mv	a0,s1
    80004e1a:	ffffc097          	auipc	ra,0xffffc
    80004e1e:	ed4080e7          	jalr	-300(ra) # 80000cee <release>
      return -1;
    80004e22:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004e24:	854a                	mv	a0,s2
    80004e26:	60e6                	ld	ra,88(sp)
    80004e28:	6446                	ld	s0,80(sp)
    80004e2a:	64a6                	ld	s1,72(sp)
    80004e2c:	6906                	ld	s2,64(sp)
    80004e2e:	79e2                	ld	s3,56(sp)
    80004e30:	7a42                	ld	s4,48(sp)
    80004e32:	7aa2                	ld	s5,40(sp)
    80004e34:	7b02                	ld	s6,32(sp)
    80004e36:	6be2                	ld	s7,24(sp)
    80004e38:	6c42                	ld	s8,16(sp)
    80004e3a:	6125                	addi	sp,sp,96
    80004e3c:	8082                	ret
      wakeup(&pi->nread);
    80004e3e:	8562                	mv	a0,s8
    80004e40:	ffffe097          	auipc	ra,0xffffe
    80004e44:	828080e7          	jalr	-2008(ra) # 80002668 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004e48:	85a6                	mv	a1,s1
    80004e4a:	855e                	mv	a0,s7
    80004e4c:	ffffd097          	auipc	ra,0xffffd
    80004e50:	690080e7          	jalr	1680(ra) # 800024dc <sleep>
  while(i < n){
    80004e54:	05495d63          	bge	s2,s4,80004eae <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80004e58:	2204a783          	lw	a5,544(s1)
    80004e5c:	dfd5                	beqz	a5,80004e18 <pipewrite+0x44>
    80004e5e:	0289a783          	lw	a5,40(s3)
    80004e62:	fbdd                	bnez	a5,80004e18 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004e64:	2184a783          	lw	a5,536(s1)
    80004e68:	21c4a703          	lw	a4,540(s1)
    80004e6c:	2007879b          	addiw	a5,a5,512
    80004e70:	fcf707e3          	beq	a4,a5,80004e3e <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004e74:	4685                	li	a3,1
    80004e76:	01590633          	add	a2,s2,s5
    80004e7a:	faf40593          	addi	a1,s0,-81
    80004e7e:	0589b503          	ld	a0,88(s3)
    80004e82:	ffffd097          	auipc	ra,0xffffd
    80004e86:	ae0080e7          	jalr	-1312(ra) # 80001962 <copyin>
    80004e8a:	03650263          	beq	a0,s6,80004eae <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004e8e:	21c4a783          	lw	a5,540(s1)
    80004e92:	0017871b          	addiw	a4,a5,1
    80004e96:	20e4ae23          	sw	a4,540(s1)
    80004e9a:	1ff7f793          	andi	a5,a5,511
    80004e9e:	97a6                	add	a5,a5,s1
    80004ea0:	faf44703          	lbu	a4,-81(s0)
    80004ea4:	00e78c23          	sb	a4,24(a5)
      i++;
    80004ea8:	2905                	addiw	s2,s2,1
    80004eaa:	b76d                	j	80004e54 <pipewrite+0x80>
  int i = 0;
    80004eac:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004eae:	21848513          	addi	a0,s1,536
    80004eb2:	ffffd097          	auipc	ra,0xffffd
    80004eb6:	7b6080e7          	jalr	1974(ra) # 80002668 <wakeup>
  release(&pi->lock);
    80004eba:	8526                	mv	a0,s1
    80004ebc:	ffffc097          	auipc	ra,0xffffc
    80004ec0:	e32080e7          	jalr	-462(ra) # 80000cee <release>
  return i;
    80004ec4:	b785                	j	80004e24 <pipewrite+0x50>

0000000080004ec6 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004ec6:	715d                	addi	sp,sp,-80
    80004ec8:	e486                	sd	ra,72(sp)
    80004eca:	e0a2                	sd	s0,64(sp)
    80004ecc:	fc26                	sd	s1,56(sp)
    80004ece:	f84a                	sd	s2,48(sp)
    80004ed0:	f44e                	sd	s3,40(sp)
    80004ed2:	f052                	sd	s4,32(sp)
    80004ed4:	ec56                	sd	s5,24(sp)
    80004ed6:	e85a                	sd	s6,16(sp)
    80004ed8:	0880                	addi	s0,sp,80
    80004eda:	84aa                	mv	s1,a0
    80004edc:	892e                	mv	s2,a1
    80004ede:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004ee0:	ffffd097          	auipc	ra,0xffffd
    80004ee4:	d8c080e7          	jalr	-628(ra) # 80001c6c <myproc>
    80004ee8:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004eea:	8526                	mv	a0,s1
    80004eec:	ffffc097          	auipc	ra,0xffffc
    80004ef0:	d4e080e7          	jalr	-690(ra) # 80000c3a <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004ef4:	2184a703          	lw	a4,536(s1)
    80004ef8:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004efc:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004f00:	02f71463          	bne	a4,a5,80004f28 <piperead+0x62>
    80004f04:	2244a783          	lw	a5,548(s1)
    80004f08:	c385                	beqz	a5,80004f28 <piperead+0x62>
    if(pr->killed){
    80004f0a:	028a2783          	lw	a5,40(s4)
    80004f0e:	ebc1                	bnez	a5,80004f9e <piperead+0xd8>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004f10:	85a6                	mv	a1,s1
    80004f12:	854e                	mv	a0,s3
    80004f14:	ffffd097          	auipc	ra,0xffffd
    80004f18:	5c8080e7          	jalr	1480(ra) # 800024dc <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004f1c:	2184a703          	lw	a4,536(s1)
    80004f20:	21c4a783          	lw	a5,540(s1)
    80004f24:	fef700e3          	beq	a4,a5,80004f04 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004f28:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004f2a:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004f2c:	05505363          	blez	s5,80004f72 <piperead+0xac>
    if(pi->nread == pi->nwrite)
    80004f30:	2184a783          	lw	a5,536(s1)
    80004f34:	21c4a703          	lw	a4,540(s1)
    80004f38:	02f70d63          	beq	a4,a5,80004f72 <piperead+0xac>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004f3c:	0017871b          	addiw	a4,a5,1
    80004f40:	20e4ac23          	sw	a4,536(s1)
    80004f44:	1ff7f793          	andi	a5,a5,511
    80004f48:	97a6                	add	a5,a5,s1
    80004f4a:	0187c783          	lbu	a5,24(a5)
    80004f4e:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004f52:	4685                	li	a3,1
    80004f54:	fbf40613          	addi	a2,s0,-65
    80004f58:	85ca                	mv	a1,s2
    80004f5a:	058a3503          	ld	a0,88(s4)
    80004f5e:	ffffd097          	auipc	ra,0xffffd
    80004f62:	8fe080e7          	jalr	-1794(ra) # 8000185c <copyout>
    80004f66:	01650663          	beq	a0,s6,80004f72 <piperead+0xac>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004f6a:	2985                	addiw	s3,s3,1
    80004f6c:	0905                	addi	s2,s2,1
    80004f6e:	fd3a91e3          	bne	s5,s3,80004f30 <piperead+0x6a>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004f72:	21c48513          	addi	a0,s1,540
    80004f76:	ffffd097          	auipc	ra,0xffffd
    80004f7a:	6f2080e7          	jalr	1778(ra) # 80002668 <wakeup>
  release(&pi->lock);
    80004f7e:	8526                	mv	a0,s1
    80004f80:	ffffc097          	auipc	ra,0xffffc
    80004f84:	d6e080e7          	jalr	-658(ra) # 80000cee <release>
  return i;
}
    80004f88:	854e                	mv	a0,s3
    80004f8a:	60a6                	ld	ra,72(sp)
    80004f8c:	6406                	ld	s0,64(sp)
    80004f8e:	74e2                	ld	s1,56(sp)
    80004f90:	7942                	ld	s2,48(sp)
    80004f92:	79a2                	ld	s3,40(sp)
    80004f94:	7a02                	ld	s4,32(sp)
    80004f96:	6ae2                	ld	s5,24(sp)
    80004f98:	6b42                	ld	s6,16(sp)
    80004f9a:	6161                	addi	sp,sp,80
    80004f9c:	8082                	ret
      release(&pi->lock);
    80004f9e:	8526                	mv	a0,s1
    80004fa0:	ffffc097          	auipc	ra,0xffffc
    80004fa4:	d4e080e7          	jalr	-690(ra) # 80000cee <release>
      return -1;
    80004fa8:	59fd                	li	s3,-1
    80004faa:	bff9                	j	80004f88 <piperead+0xc2>

0000000080004fac <exec>:
extern char trampoline[]; // trampoline.S
extern struct proc proc[NPROC];
static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset,
                   uint sz);

int exec(char *path, char **argv) {
    80004fac:	dd010113          	addi	sp,sp,-560
    80004fb0:	22113423          	sd	ra,552(sp)
    80004fb4:	22813023          	sd	s0,544(sp)
    80004fb8:	20913c23          	sd	s1,536(sp)
    80004fbc:	21213823          	sd	s2,528(sp)
    80004fc0:	21313423          	sd	s3,520(sp)
    80004fc4:	21413023          	sd	s4,512(sp)
    80004fc8:	ffd6                	sd	s5,504(sp)
    80004fca:	fbda                	sd	s6,496(sp)
    80004fcc:	f7de                	sd	s7,488(sp)
    80004fce:	f3e2                	sd	s8,480(sp)
    80004fd0:	efe6                	sd	s9,472(sp)
    80004fd2:	ebea                	sd	s10,464(sp)
    80004fd4:	e7ee                	sd	s11,456(sp)
    80004fd6:	1c00                	addi	s0,sp,560
    80004fd8:	84aa                	mv	s1,a0
    80004fda:	dea43023          	sd	a0,-544(s0)
    80004fde:	deb43423          	sd	a1,-536(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG + 1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004fe2:	ffffd097          	auipc	ra,0xffffd
    80004fe6:	c8a080e7          	jalr	-886(ra) # 80001c6c <myproc>
    80004fea:	dea43c23          	sd	a0,-520(s0)

  begin_op();
    80004fee:	fffff097          	auipc	ra,0xfffff
    80004ff2:	4a0080e7          	jalr	1184(ra) # 8000448e <begin_op>

  if ((ip = namei(path)) == 0) {
    80004ff6:	8526                	mv	a0,s1
    80004ff8:	fffff097          	auipc	ra,0xfffff
    80004ffc:	27a080e7          	jalr	634(ra) # 80004272 <namei>
    80005000:	cd2d                	beqz	a0,8000507a <exec+0xce>
    80005002:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80005004:	fffff097          	auipc	ra,0xfffff
    80005008:	ab8080e7          	jalr	-1352(ra) # 80003abc <ilock>

  // Check ELF header
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000500c:	04000713          	li	a4,64
    80005010:	4681                	li	a3,0
    80005012:	e4840613          	addi	a2,s0,-440
    80005016:	4581                	li	a1,0
    80005018:	8556                	mv	a0,s5
    8000501a:	fffff097          	auipc	ra,0xfffff
    8000501e:	d56080e7          	jalr	-682(ra) # 80003d70 <readi>
    80005022:	04000793          	li	a5,64
    80005026:	00f51a63          	bne	a0,a5,8000503a <exec+0x8e>
    goto bad;
  if (elf.magic != ELF_MAGIC)
    8000502a:	e4842703          	lw	a4,-440(s0)
    8000502e:	464c47b7          	lui	a5,0x464c4
    80005032:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005036:	04f70863          	beq	a4,a5,80005086 <exec+0xda>

bad:
  if (pagetable)
    proc_freepagetable(pagetable, sz);
  if (ip) {
    iunlockput(ip);
    8000503a:	8556                	mv	a0,s5
    8000503c:	fffff097          	auipc	ra,0xfffff
    80005040:	ce2080e7          	jalr	-798(ra) # 80003d1e <iunlockput>
    end_op();
    80005044:	fffff097          	auipc	ra,0xfffff
    80005048:	4ca080e7          	jalr	1226(ra) # 8000450e <end_op>
  }
  return -1;
    8000504c:	557d                	li	a0,-1
}
    8000504e:	22813083          	ld	ra,552(sp)
    80005052:	22013403          	ld	s0,544(sp)
    80005056:	21813483          	ld	s1,536(sp)
    8000505a:	21013903          	ld	s2,528(sp)
    8000505e:	20813983          	ld	s3,520(sp)
    80005062:	20013a03          	ld	s4,512(sp)
    80005066:	7afe                	ld	s5,504(sp)
    80005068:	7b5e                	ld	s6,496(sp)
    8000506a:	7bbe                	ld	s7,488(sp)
    8000506c:	7c1e                	ld	s8,480(sp)
    8000506e:	6cfe                	ld	s9,472(sp)
    80005070:	6d5e                	ld	s10,464(sp)
    80005072:	6dbe                	ld	s11,456(sp)
    80005074:	23010113          	addi	sp,sp,560
    80005078:	8082                	ret
    end_op();
    8000507a:	fffff097          	auipc	ra,0xfffff
    8000507e:	494080e7          	jalr	1172(ra) # 8000450e <end_op>
    return -1;
    80005082:	557d                	li	a0,-1
    80005084:	b7e9                	j	8000504e <exec+0xa2>
  if ((pagetable = proc_pagetable(p)) == 0)
    80005086:	df843503          	ld	a0,-520(s0)
    8000508a:	ffffd097          	auipc	ra,0xffffd
    8000508e:	ca6080e7          	jalr	-858(ra) # 80001d30 <proc_pagetable>
    80005092:	8b2a                	mv	s6,a0
    80005094:	d15d                	beqz	a0,8000503a <exec+0x8e>
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80005096:	e6842783          	lw	a5,-408(s0)
    8000509a:	e8045703          	lhu	a4,-384(s0)
    8000509e:	c735                	beqz	a4,8000510a <exec+0x15e>
  uint64 argc, sz = 0, sp, ustack[MAXARG + 1], stackbase;
    800050a0:	4481                	li	s1,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800050a2:	e0043423          	sd	zero,-504(s0)
    if (ph.vaddr % PGSIZE != 0)
    800050a6:	6a05                	lui	s4,0x1
    800050a8:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800050ac:	dce43c23          	sd	a4,-552(s0)
  uint64 pa;

  if ((va % PGSIZE) != 0)
    panic("loadseg: va must be page aligned");

  for (i = 0; i < sz; i += PGSIZE) {
    800050b0:	6d85                	lui	s11,0x1
    800050b2:	7d7d                	lui	s10,0xfffff
    800050b4:	a4b1                	j	80005300 <exec+0x354>
    pa = walkaddr(pagetable, va + i);
    if (pa == 0)
      panic("loadseg: address should exist");
    800050b6:	00003517          	auipc	a0,0x3
    800050ba:	73a50513          	addi	a0,a0,1850 # 800087f0 <syscalls+0x288>
    800050be:	ffffb097          	auipc	ra,0xffffb
    800050c2:	50e080e7          	jalr	1294(ra) # 800005cc <panic>
    if (sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n)
    800050c6:	874a                	mv	a4,s2
    800050c8:	009c86bb          	addw	a3,s9,s1
    800050cc:	4581                	li	a1,0
    800050ce:	8556                	mv	a0,s5
    800050d0:	fffff097          	auipc	ra,0xfffff
    800050d4:	ca0080e7          	jalr	-864(ra) # 80003d70 <readi>
    800050d8:	2501                	sext.w	a0,a0
    800050da:	1ca91363          	bne	s2,a0,800052a0 <exec+0x2f4>
  for (i = 0; i < sz; i += PGSIZE) {
    800050de:	009d84bb          	addw	s1,s11,s1
    800050e2:	013d09bb          	addw	s3,s10,s3
    800050e6:	1f74fd63          	bgeu	s1,s7,800052e0 <exec+0x334>
    pa = walkaddr(pagetable, va + i);
    800050ea:	02049593          	slli	a1,s1,0x20
    800050ee:	9181                	srli	a1,a1,0x20
    800050f0:	95e2                	add	a1,a1,s8
    800050f2:	855a                	mv	a0,s6
    800050f4:	ffffc097          	auipc	ra,0xffffc
    800050f8:	fd0080e7          	jalr	-48(ra) # 800010c4 <walkaddr>
    800050fc:	862a                	mv	a2,a0
    if (pa == 0)
    800050fe:	dd45                	beqz	a0,800050b6 <exec+0x10a>
      n = PGSIZE;
    80005100:	8952                	mv	s2,s4
    if (sz - i < PGSIZE)
    80005102:	fd49f2e3          	bgeu	s3,s4,800050c6 <exec+0x11a>
      n = sz - i;
    80005106:	894e                	mv	s2,s3
    80005108:	bf7d                	j	800050c6 <exec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG + 1], stackbase;
    8000510a:	4481                	li	s1,0
  iunlockput(ip);
    8000510c:	8556                	mv	a0,s5
    8000510e:	fffff097          	auipc	ra,0xfffff
    80005112:	c10080e7          	jalr	-1008(ra) # 80003d1e <iunlockput>
  end_op();
    80005116:	fffff097          	auipc	ra,0xfffff
    8000511a:	3f8080e7          	jalr	1016(ra) # 8000450e <end_op>
  uint64 oldsz = p->sz;
    8000511e:	df843983          	ld	s3,-520(s0)
    80005122:	0509bc83          	ld	s9,80(s3)
  sz = PGROUNDUP(sz);
    80005126:	6785                	lui	a5,0x1
    80005128:	17fd                	addi	a5,a5,-1
    8000512a:	94be                	add	s1,s1,a5
    8000512c:	77fd                	lui	a5,0xfffff
    8000512e:	00f4f933          	and	s2,s1,a5
    80005132:	df243823          	sd	s2,-528(s0)
  if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE)) == 0)
    80005136:	6489                	lui	s1,0x2
    80005138:	94ca                	add	s1,s1,s2
    8000513a:	8626                	mv	a2,s1
    8000513c:	85ca                	mv	a1,s2
    8000513e:	855a                	mv	a0,s6
    80005140:	ffffc097          	auipc	ra,0xffffc
    80005144:	3c2080e7          	jalr	962(ra) # 80001502 <uvmalloc>
    80005148:	8baa                	mv	s7,a0
  ip = 0;
    8000514a:	4a81                	li	s5,0
  if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE)) == 0)
    8000514c:	14050a63          	beqz	a0,800052a0 <exec+0x2f4>
  uvmapping(pagetable, p->k_pagetable, sz, sz + 2 * PGSIZE);
    80005150:	86a6                	mv	a3,s1
    80005152:	864a                	mv	a2,s2
    80005154:	0609b583          	ld	a1,96(s3)
    80005158:	855a                	mv	a0,s6
    8000515a:	ffffc097          	auipc	ra,0xffffc
    8000515e:	2ba080e7          	jalr	698(ra) # 80001414 <uvmapping>
  uvmclear(pagetable, sz - 2 * PGSIZE);
    80005162:	75f9                	lui	a1,0xffffe
    80005164:	95de                	add	a1,a1,s7
    80005166:	855a                	mv	a0,s6
    80005168:	ffffc097          	auipc	ra,0xffffc
    8000516c:	6c2080e7          	jalr	1730(ra) # 8000182a <uvmclear>
  stackbase = sp - PGSIZE;
    80005170:	7afd                	lui	s5,0xfffff
    80005172:	9ade                	add	s5,s5,s7
  for (argc = 0; argv[argc]; argc++) {
    80005174:	de843783          	ld	a5,-536(s0)
    80005178:	6388                	ld	a0,0(a5)
    8000517a:	c925                	beqz	a0,800051ea <exec+0x23e>
    8000517c:	e8840993          	addi	s3,s0,-376
    80005180:	f8840c13          	addi	s8,s0,-120
  sp = sz;
    80005184:	895e                	mv	s2,s7
  for (argc = 0; argv[argc]; argc++) {
    80005186:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80005188:	ffffc097          	auipc	ra,0xffffc
    8000518c:	d32080e7          	jalr	-718(ra) # 80000eba <strlen>
    80005190:	0015079b          	addiw	a5,a0,1
    80005194:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005198:	ff097913          	andi	s2,s2,-16
    if (sp < stackbase)
    8000519c:	13596663          	bltu	s2,s5,800052c8 <exec+0x31c>
    if (copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800051a0:	de843d03          	ld	s10,-536(s0)
    800051a4:	000d3a03          	ld	s4,0(s10) # fffffffffffff000 <end+0xffffffff7ffd9000>
    800051a8:	8552                	mv	a0,s4
    800051aa:	ffffc097          	auipc	ra,0xffffc
    800051ae:	d10080e7          	jalr	-752(ra) # 80000eba <strlen>
    800051b2:	0015069b          	addiw	a3,a0,1
    800051b6:	8652                	mv	a2,s4
    800051b8:	85ca                	mv	a1,s2
    800051ba:	855a                	mv	a0,s6
    800051bc:	ffffc097          	auipc	ra,0xffffc
    800051c0:	6a0080e7          	jalr	1696(ra) # 8000185c <copyout>
    800051c4:	10054663          	bltz	a0,800052d0 <exec+0x324>
    ustack[argc] = sp;
    800051c8:	0129b023          	sd	s2,0(s3)
  for (argc = 0; argv[argc]; argc++) {
    800051cc:	0485                	addi	s1,s1,1
    800051ce:	008d0793          	addi	a5,s10,8
    800051d2:	def43423          	sd	a5,-536(s0)
    800051d6:	008d3503          	ld	a0,8(s10)
    800051da:	c911                	beqz	a0,800051ee <exec+0x242>
    if (argc >= MAXARG)
    800051dc:	09a1                	addi	s3,s3,8
    800051de:	fb3c15e3          	bne	s8,s3,80005188 <exec+0x1dc>
  sz = sz1;
    800051e2:	df743823          	sd	s7,-528(s0)
  ip = 0;
    800051e6:	4a81                	li	s5,0
    800051e8:	a865                	j	800052a0 <exec+0x2f4>
  sp = sz;
    800051ea:	895e                	mv	s2,s7
  for (argc = 0; argv[argc]; argc++) {
    800051ec:	4481                	li	s1,0
  ustack[argc] = 0;
    800051ee:	00349793          	slli	a5,s1,0x3
    800051f2:	f9040713          	addi	a4,s0,-112
    800051f6:	97ba                	add	a5,a5,a4
    800051f8:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ffd8ef8>
  sp -= (argc + 1) * sizeof(uint64);
    800051fc:	00148693          	addi	a3,s1,1 # 2001 <_entry-0x7fffdfff>
    80005200:	068e                	slli	a3,a3,0x3
    80005202:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005206:	ff097913          	andi	s2,s2,-16
  if (sp < stackbase)
    8000520a:	01597663          	bgeu	s2,s5,80005216 <exec+0x26a>
  sz = sz1;
    8000520e:	df743823          	sd	s7,-528(s0)
  ip = 0;
    80005212:	4a81                	li	s5,0
    80005214:	a071                	j	800052a0 <exec+0x2f4>
  if (copyout(pagetable, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) < 0)
    80005216:	e8840613          	addi	a2,s0,-376
    8000521a:	85ca                	mv	a1,s2
    8000521c:	855a                	mv	a0,s6
    8000521e:	ffffc097          	auipc	ra,0xffffc
    80005222:	63e080e7          	jalr	1598(ra) # 8000185c <copyout>
    80005226:	0a054963          	bltz	a0,800052d8 <exec+0x32c>
  p->trapframe->a1 = sp;
    8000522a:	df843783          	ld	a5,-520(s0)
    8000522e:	77bc                	ld	a5,104(a5)
    80005230:	0727bc23          	sd	s2,120(a5)
  for (last = s = path; *s; s++)
    80005234:	de043783          	ld	a5,-544(s0)
    80005238:	0007c703          	lbu	a4,0(a5)
    8000523c:	cf11                	beqz	a4,80005258 <exec+0x2ac>
    8000523e:	0785                	addi	a5,a5,1
    if (*s == '/')
    80005240:	02f00693          	li	a3,47
    80005244:	a039                	j	80005252 <exec+0x2a6>
      last = s + 1;
    80005246:	def43023          	sd	a5,-544(s0)
  for (last = s = path; *s; s++)
    8000524a:	0785                	addi	a5,a5,1
    8000524c:	fff7c703          	lbu	a4,-1(a5)
    80005250:	c701                	beqz	a4,80005258 <exec+0x2ac>
    if (*s == '/')
    80005252:	fed71ce3          	bne	a4,a3,8000524a <exec+0x29e>
    80005256:	bfc5                	j	80005246 <exec+0x29a>
  safestrcpy(p->name, last, sizeof(p->name));
    80005258:	4641                	li	a2,16
    8000525a:	de043583          	ld	a1,-544(s0)
    8000525e:	df843983          	ld	s3,-520(s0)
    80005262:	16898513          	addi	a0,s3,360
    80005266:	ffffc097          	auipc	ra,0xffffc
    8000526a:	c22080e7          	jalr	-990(ra) # 80000e88 <safestrcpy>
  oldpagetable = p->pagetable;
    8000526e:	0589b503          	ld	a0,88(s3)
  p->pagetable = pagetable;
    80005272:	0569bc23          	sd	s6,88(s3)
  p->sz = sz;
    80005276:	0579b823          	sd	s7,80(s3)
  p->trapframe->epc = elf.entry; // initial program counter = main
    8000527a:	0689b783          	ld	a5,104(s3)
    8000527e:	e6043703          	ld	a4,-416(s0)
    80005282:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;         // initial stack pointer
    80005284:	0689b783          	ld	a5,104(s3)
    80005288:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000528c:	85e6                	mv	a1,s9
    8000528e:	ffffd097          	auipc	ra,0xffffd
    80005292:	b3e080e7          	jalr	-1218(ra) # 80001dcc <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005296:	0004851b          	sext.w	a0,s1
    8000529a:	bb55                	j	8000504e <exec+0xa2>
    8000529c:	de943823          	sd	s1,-528(s0)
    proc_freepagetable(pagetable, sz);
    800052a0:	df043583          	ld	a1,-528(s0)
    800052a4:	855a                	mv	a0,s6
    800052a6:	ffffd097          	auipc	ra,0xffffd
    800052aa:	b26080e7          	jalr	-1242(ra) # 80001dcc <proc_freepagetable>
  if (ip) {
    800052ae:	d80a96e3          	bnez	s5,8000503a <exec+0x8e>
  return -1;
    800052b2:	557d                	li	a0,-1
    800052b4:	bb69                	j	8000504e <exec+0xa2>
    800052b6:	de943823          	sd	s1,-528(s0)
    800052ba:	b7dd                	j	800052a0 <exec+0x2f4>
    800052bc:	de943823          	sd	s1,-528(s0)
    800052c0:	b7c5                	j	800052a0 <exec+0x2f4>
    800052c2:	de943823          	sd	s1,-528(s0)
    800052c6:	bfe9                	j	800052a0 <exec+0x2f4>
  sz = sz1;
    800052c8:	df743823          	sd	s7,-528(s0)
  ip = 0;
    800052cc:	4a81                	li	s5,0
    800052ce:	bfc9                	j	800052a0 <exec+0x2f4>
  sz = sz1;
    800052d0:	df743823          	sd	s7,-528(s0)
  ip = 0;
    800052d4:	4a81                	li	s5,0
    800052d6:	b7e9                	j	800052a0 <exec+0x2f4>
  sz = sz1;
    800052d8:	df743823          	sd	s7,-528(s0)
  ip = 0;
    800052dc:	4a81                	li	s5,0
    800052de:	b7c9                	j	800052a0 <exec+0x2f4>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800052e0:	df043483          	ld	s1,-528(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800052e4:	e0843783          	ld	a5,-504(s0)
    800052e8:	0017869b          	addiw	a3,a5,1
    800052ec:	e0d43423          	sd	a3,-504(s0)
    800052f0:	e0043783          	ld	a5,-512(s0)
    800052f4:	0387879b          	addiw	a5,a5,56
    800052f8:	e8045703          	lhu	a4,-384(s0)
    800052fc:	e0e6d8e3          	bge	a3,a4,8000510c <exec+0x160>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005300:	2781                	sext.w	a5,a5
    80005302:	e0f43023          	sd	a5,-512(s0)
    80005306:	03800713          	li	a4,56
    8000530a:	86be                	mv	a3,a5
    8000530c:	e1040613          	addi	a2,s0,-496
    80005310:	4581                	li	a1,0
    80005312:	8556                	mv	a0,s5
    80005314:	fffff097          	auipc	ra,0xfffff
    80005318:	a5c080e7          	jalr	-1444(ra) # 80003d70 <readi>
    8000531c:	03800793          	li	a5,56
    80005320:	f6f51ee3          	bne	a0,a5,8000529c <exec+0x2f0>
    if (ph.type != ELF_PROG_LOAD)
    80005324:	e1042783          	lw	a5,-496(s0)
    80005328:	4705                	li	a4,1
    8000532a:	fae79de3          	bne	a5,a4,800052e4 <exec+0x338>
    if (ph.memsz < ph.filesz)
    8000532e:	e3843603          	ld	a2,-456(s0)
    80005332:	e3043783          	ld	a5,-464(s0)
    80005336:	f8f660e3          	bltu	a2,a5,800052b6 <exec+0x30a>
    if (ph.vaddr + ph.memsz < ph.vaddr)
    8000533a:	e2043783          	ld	a5,-480(s0)
    8000533e:	963e                	add	a2,a2,a5
    80005340:	f6f66ee3          	bltu	a2,a5,800052bc <exec+0x310>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80005344:	85a6                	mv	a1,s1
    80005346:	855a                	mv	a0,s6
    80005348:	ffffc097          	auipc	ra,0xffffc
    8000534c:	1ba080e7          	jalr	442(ra) # 80001502 <uvmalloc>
    80005350:	dea43823          	sd	a0,-528(s0)
    80005354:	d53d                	beqz	a0,800052c2 <exec+0x316>
    uvmapping(pagetable, p->k_pagetable, sz, ph.vaddr + ph.memsz);
    80005356:	e2043683          	ld	a3,-480(s0)
    8000535a:	e3843783          	ld	a5,-456(s0)
    8000535e:	96be                	add	a3,a3,a5
    80005360:	8626                	mv	a2,s1
    80005362:	df843783          	ld	a5,-520(s0)
    80005366:	73ac                	ld	a1,96(a5)
    80005368:	855a                	mv	a0,s6
    8000536a:	ffffc097          	auipc	ra,0xffffc
    8000536e:	0aa080e7          	jalr	170(ra) # 80001414 <uvmapping>
    if (ph.vaddr % PGSIZE != 0)
    80005372:	e2043c03          	ld	s8,-480(s0)
    80005376:	dd843783          	ld	a5,-552(s0)
    8000537a:	00fc77b3          	and	a5,s8,a5
    8000537e:	f38d                	bnez	a5,800052a0 <exec+0x2f4>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005380:	e1842c83          	lw	s9,-488(s0)
    80005384:	e3042b83          	lw	s7,-464(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    80005388:	f40b8ce3          	beqz	s7,800052e0 <exec+0x334>
    8000538c:	89de                	mv	s3,s7
    8000538e:	4481                	li	s1,0
    80005390:	bba9                	j	800050ea <exec+0x13e>

0000000080005392 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005392:	7179                	addi	sp,sp,-48
    80005394:	f406                	sd	ra,40(sp)
    80005396:	f022                	sd	s0,32(sp)
    80005398:	ec26                	sd	s1,24(sp)
    8000539a:	e84a                	sd	s2,16(sp)
    8000539c:	1800                	addi	s0,sp,48
    8000539e:	892e                	mv	s2,a1
    800053a0:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800053a2:	fdc40593          	addi	a1,s0,-36
    800053a6:	ffffe097          	auipc	ra,0xffffe
    800053aa:	b26080e7          	jalr	-1242(ra) # 80002ecc <argint>
    800053ae:	04054063          	bltz	a0,800053ee <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800053b2:	fdc42703          	lw	a4,-36(s0)
    800053b6:	47bd                	li	a5,15
    800053b8:	02e7ed63          	bltu	a5,a4,800053f2 <argfd+0x60>
    800053bc:	ffffd097          	auipc	ra,0xffffd
    800053c0:	8b0080e7          	jalr	-1872(ra) # 80001c6c <myproc>
    800053c4:	fdc42703          	lw	a4,-36(s0)
    800053c8:	01c70793          	addi	a5,a4,28
    800053cc:	078e                	slli	a5,a5,0x3
    800053ce:	953e                	add	a0,a0,a5
    800053d0:	611c                	ld	a5,0(a0)
    800053d2:	c395                	beqz	a5,800053f6 <argfd+0x64>
    return -1;
  if(pfd)
    800053d4:	00090463          	beqz	s2,800053dc <argfd+0x4a>
    *pfd = fd;
    800053d8:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800053dc:	4501                	li	a0,0
  if(pf)
    800053de:	c091                	beqz	s1,800053e2 <argfd+0x50>
    *pf = f;
    800053e0:	e09c                	sd	a5,0(s1)
}
    800053e2:	70a2                	ld	ra,40(sp)
    800053e4:	7402                	ld	s0,32(sp)
    800053e6:	64e2                	ld	s1,24(sp)
    800053e8:	6942                	ld	s2,16(sp)
    800053ea:	6145                	addi	sp,sp,48
    800053ec:	8082                	ret
    return -1;
    800053ee:	557d                	li	a0,-1
    800053f0:	bfcd                	j	800053e2 <argfd+0x50>
    return -1;
    800053f2:	557d                	li	a0,-1
    800053f4:	b7fd                	j	800053e2 <argfd+0x50>
    800053f6:	557d                	li	a0,-1
    800053f8:	b7ed                	j	800053e2 <argfd+0x50>

00000000800053fa <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800053fa:	1101                	addi	sp,sp,-32
    800053fc:	ec06                	sd	ra,24(sp)
    800053fe:	e822                	sd	s0,16(sp)
    80005400:	e426                	sd	s1,8(sp)
    80005402:	1000                	addi	s0,sp,32
    80005404:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005406:	ffffd097          	auipc	ra,0xffffd
    8000540a:	866080e7          	jalr	-1946(ra) # 80001c6c <myproc>
    8000540e:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005410:	0e050793          	addi	a5,a0,224
    80005414:	4501                	li	a0,0
    80005416:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005418:	6398                	ld	a4,0(a5)
    8000541a:	cb19                	beqz	a4,80005430 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000541c:	2505                	addiw	a0,a0,1
    8000541e:	07a1                	addi	a5,a5,8
    80005420:	fed51ce3          	bne	a0,a3,80005418 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005424:	557d                	li	a0,-1
}
    80005426:	60e2                	ld	ra,24(sp)
    80005428:	6442                	ld	s0,16(sp)
    8000542a:	64a2                	ld	s1,8(sp)
    8000542c:	6105                	addi	sp,sp,32
    8000542e:	8082                	ret
      p->ofile[fd] = f;
    80005430:	01c50793          	addi	a5,a0,28
    80005434:	078e                	slli	a5,a5,0x3
    80005436:	963e                	add	a2,a2,a5
    80005438:	e204                	sd	s1,0(a2)
      return fd;
    8000543a:	b7f5                	j	80005426 <fdalloc+0x2c>

000000008000543c <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000543c:	715d                	addi	sp,sp,-80
    8000543e:	e486                	sd	ra,72(sp)
    80005440:	e0a2                	sd	s0,64(sp)
    80005442:	fc26                	sd	s1,56(sp)
    80005444:	f84a                	sd	s2,48(sp)
    80005446:	f44e                	sd	s3,40(sp)
    80005448:	f052                	sd	s4,32(sp)
    8000544a:	ec56                	sd	s5,24(sp)
    8000544c:	0880                	addi	s0,sp,80
    8000544e:	89ae                	mv	s3,a1
    80005450:	8ab2                	mv	s5,a2
    80005452:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005454:	fb040593          	addi	a1,s0,-80
    80005458:	fffff097          	auipc	ra,0xfffff
    8000545c:	e38080e7          	jalr	-456(ra) # 80004290 <nameiparent>
    80005460:	892a                	mv	s2,a0
    80005462:	12050e63          	beqz	a0,8000559e <create+0x162>
    return 0;

  ilock(dp);
    80005466:	ffffe097          	auipc	ra,0xffffe
    8000546a:	656080e7          	jalr	1622(ra) # 80003abc <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000546e:	4601                	li	a2,0
    80005470:	fb040593          	addi	a1,s0,-80
    80005474:	854a                	mv	a0,s2
    80005476:	fffff097          	auipc	ra,0xfffff
    8000547a:	b2a080e7          	jalr	-1238(ra) # 80003fa0 <dirlookup>
    8000547e:	84aa                	mv	s1,a0
    80005480:	c921                	beqz	a0,800054d0 <create+0x94>
    iunlockput(dp);
    80005482:	854a                	mv	a0,s2
    80005484:	fffff097          	auipc	ra,0xfffff
    80005488:	89a080e7          	jalr	-1894(ra) # 80003d1e <iunlockput>
    ilock(ip);
    8000548c:	8526                	mv	a0,s1
    8000548e:	ffffe097          	auipc	ra,0xffffe
    80005492:	62e080e7          	jalr	1582(ra) # 80003abc <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005496:	2981                	sext.w	s3,s3
    80005498:	4789                	li	a5,2
    8000549a:	02f99463          	bne	s3,a5,800054c2 <create+0x86>
    8000549e:	0444d783          	lhu	a5,68(s1)
    800054a2:	37f9                	addiw	a5,a5,-2
    800054a4:	17c2                	slli	a5,a5,0x30
    800054a6:	93c1                	srli	a5,a5,0x30
    800054a8:	4705                	li	a4,1
    800054aa:	00f76c63          	bltu	a4,a5,800054c2 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800054ae:	8526                	mv	a0,s1
    800054b0:	60a6                	ld	ra,72(sp)
    800054b2:	6406                	ld	s0,64(sp)
    800054b4:	74e2                	ld	s1,56(sp)
    800054b6:	7942                	ld	s2,48(sp)
    800054b8:	79a2                	ld	s3,40(sp)
    800054ba:	7a02                	ld	s4,32(sp)
    800054bc:	6ae2                	ld	s5,24(sp)
    800054be:	6161                	addi	sp,sp,80
    800054c0:	8082                	ret
    iunlockput(ip);
    800054c2:	8526                	mv	a0,s1
    800054c4:	fffff097          	auipc	ra,0xfffff
    800054c8:	85a080e7          	jalr	-1958(ra) # 80003d1e <iunlockput>
    return 0;
    800054cc:	4481                	li	s1,0
    800054ce:	b7c5                	j	800054ae <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800054d0:	85ce                	mv	a1,s3
    800054d2:	00092503          	lw	a0,0(s2)
    800054d6:	ffffe097          	auipc	ra,0xffffe
    800054da:	44e080e7          	jalr	1102(ra) # 80003924 <ialloc>
    800054de:	84aa                	mv	s1,a0
    800054e0:	c521                	beqz	a0,80005528 <create+0xec>
  ilock(ip);
    800054e2:	ffffe097          	auipc	ra,0xffffe
    800054e6:	5da080e7          	jalr	1498(ra) # 80003abc <ilock>
  ip->major = major;
    800054ea:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800054ee:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800054f2:	4a05                	li	s4,1
    800054f4:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    800054f8:	8526                	mv	a0,s1
    800054fa:	ffffe097          	auipc	ra,0xffffe
    800054fe:	4f8080e7          	jalr	1272(ra) # 800039f2 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005502:	2981                	sext.w	s3,s3
    80005504:	03498a63          	beq	s3,s4,80005538 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80005508:	40d0                	lw	a2,4(s1)
    8000550a:	fb040593          	addi	a1,s0,-80
    8000550e:	854a                	mv	a0,s2
    80005510:	fffff097          	auipc	ra,0xfffff
    80005514:	ca0080e7          	jalr	-864(ra) # 800041b0 <dirlink>
    80005518:	06054b63          	bltz	a0,8000558e <create+0x152>
  iunlockput(dp);
    8000551c:	854a                	mv	a0,s2
    8000551e:	fffff097          	auipc	ra,0xfffff
    80005522:	800080e7          	jalr	-2048(ra) # 80003d1e <iunlockput>
  return ip;
    80005526:	b761                	j	800054ae <create+0x72>
    panic("create: ialloc");
    80005528:	00003517          	auipc	a0,0x3
    8000552c:	2e850513          	addi	a0,a0,744 # 80008810 <syscalls+0x2a8>
    80005530:	ffffb097          	auipc	ra,0xffffb
    80005534:	09c080e7          	jalr	156(ra) # 800005cc <panic>
    dp->nlink++;  // for ".."
    80005538:	04a95783          	lhu	a5,74(s2)
    8000553c:	2785                	addiw	a5,a5,1
    8000553e:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80005542:	854a                	mv	a0,s2
    80005544:	ffffe097          	auipc	ra,0xffffe
    80005548:	4ae080e7          	jalr	1198(ra) # 800039f2 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000554c:	40d0                	lw	a2,4(s1)
    8000554e:	00003597          	auipc	a1,0x3
    80005552:	2d258593          	addi	a1,a1,722 # 80008820 <syscalls+0x2b8>
    80005556:	8526                	mv	a0,s1
    80005558:	fffff097          	auipc	ra,0xfffff
    8000555c:	c58080e7          	jalr	-936(ra) # 800041b0 <dirlink>
    80005560:	00054f63          	bltz	a0,8000557e <create+0x142>
    80005564:	00492603          	lw	a2,4(s2)
    80005568:	00003597          	auipc	a1,0x3
    8000556c:	d0058593          	addi	a1,a1,-768 # 80008268 <digits+0x200>
    80005570:	8526                	mv	a0,s1
    80005572:	fffff097          	auipc	ra,0xfffff
    80005576:	c3e080e7          	jalr	-962(ra) # 800041b0 <dirlink>
    8000557a:	f80557e3          	bgez	a0,80005508 <create+0xcc>
      panic("create dots");
    8000557e:	00003517          	auipc	a0,0x3
    80005582:	2aa50513          	addi	a0,a0,682 # 80008828 <syscalls+0x2c0>
    80005586:	ffffb097          	auipc	ra,0xffffb
    8000558a:	046080e7          	jalr	70(ra) # 800005cc <panic>
    panic("create: dirlink");
    8000558e:	00003517          	auipc	a0,0x3
    80005592:	2aa50513          	addi	a0,a0,682 # 80008838 <syscalls+0x2d0>
    80005596:	ffffb097          	auipc	ra,0xffffb
    8000559a:	036080e7          	jalr	54(ra) # 800005cc <panic>
    return 0;
    8000559e:	84aa                	mv	s1,a0
    800055a0:	b739                	j	800054ae <create+0x72>

00000000800055a2 <sys_dup>:
{
    800055a2:	7179                	addi	sp,sp,-48
    800055a4:	f406                	sd	ra,40(sp)
    800055a6:	f022                	sd	s0,32(sp)
    800055a8:	ec26                	sd	s1,24(sp)
    800055aa:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800055ac:	fd840613          	addi	a2,s0,-40
    800055b0:	4581                	li	a1,0
    800055b2:	4501                	li	a0,0
    800055b4:	00000097          	auipc	ra,0x0
    800055b8:	dde080e7          	jalr	-546(ra) # 80005392 <argfd>
    return -1;
    800055bc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800055be:	02054363          	bltz	a0,800055e4 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800055c2:	fd843503          	ld	a0,-40(s0)
    800055c6:	00000097          	auipc	ra,0x0
    800055ca:	e34080e7          	jalr	-460(ra) # 800053fa <fdalloc>
    800055ce:	84aa                	mv	s1,a0
    return -1;
    800055d0:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800055d2:	00054963          	bltz	a0,800055e4 <sys_dup+0x42>
  filedup(f);
    800055d6:	fd843503          	ld	a0,-40(s0)
    800055da:	fffff097          	auipc	ra,0xfffff
    800055de:	32e080e7          	jalr	814(ra) # 80004908 <filedup>
  return fd;
    800055e2:	87a6                	mv	a5,s1
}
    800055e4:	853e                	mv	a0,a5
    800055e6:	70a2                	ld	ra,40(sp)
    800055e8:	7402                	ld	s0,32(sp)
    800055ea:	64e2                	ld	s1,24(sp)
    800055ec:	6145                	addi	sp,sp,48
    800055ee:	8082                	ret

00000000800055f0 <sys_read>:
{
    800055f0:	7179                	addi	sp,sp,-48
    800055f2:	f406                	sd	ra,40(sp)
    800055f4:	f022                	sd	s0,32(sp)
    800055f6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800055f8:	fe840613          	addi	a2,s0,-24
    800055fc:	4581                	li	a1,0
    800055fe:	4501                	li	a0,0
    80005600:	00000097          	auipc	ra,0x0
    80005604:	d92080e7          	jalr	-622(ra) # 80005392 <argfd>
    return -1;
    80005608:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000560a:	04054163          	bltz	a0,8000564c <sys_read+0x5c>
    8000560e:	fe440593          	addi	a1,s0,-28
    80005612:	4509                	li	a0,2
    80005614:	ffffe097          	auipc	ra,0xffffe
    80005618:	8b8080e7          	jalr	-1864(ra) # 80002ecc <argint>
    return -1;
    8000561c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000561e:	02054763          	bltz	a0,8000564c <sys_read+0x5c>
    80005622:	fd840593          	addi	a1,s0,-40
    80005626:	4505                	li	a0,1
    80005628:	ffffe097          	auipc	ra,0xffffe
    8000562c:	8c6080e7          	jalr	-1850(ra) # 80002eee <argaddr>
    return -1;
    80005630:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005632:	00054d63          	bltz	a0,8000564c <sys_read+0x5c>
  return fileread(f, p, n);
    80005636:	fe442603          	lw	a2,-28(s0)
    8000563a:	fd843583          	ld	a1,-40(s0)
    8000563e:	fe843503          	ld	a0,-24(s0)
    80005642:	fffff097          	auipc	ra,0xfffff
    80005646:	452080e7          	jalr	1106(ra) # 80004a94 <fileread>
    8000564a:	87aa                	mv	a5,a0
}
    8000564c:	853e                	mv	a0,a5
    8000564e:	70a2                	ld	ra,40(sp)
    80005650:	7402                	ld	s0,32(sp)
    80005652:	6145                	addi	sp,sp,48
    80005654:	8082                	ret

0000000080005656 <sys_write>:
{
    80005656:	7179                	addi	sp,sp,-48
    80005658:	f406                	sd	ra,40(sp)
    8000565a:	f022                	sd	s0,32(sp)
    8000565c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000565e:	fe840613          	addi	a2,s0,-24
    80005662:	4581                	li	a1,0
    80005664:	4501                	li	a0,0
    80005666:	00000097          	auipc	ra,0x0
    8000566a:	d2c080e7          	jalr	-724(ra) # 80005392 <argfd>
    return -1;
    8000566e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005670:	04054163          	bltz	a0,800056b2 <sys_write+0x5c>
    80005674:	fe440593          	addi	a1,s0,-28
    80005678:	4509                	li	a0,2
    8000567a:	ffffe097          	auipc	ra,0xffffe
    8000567e:	852080e7          	jalr	-1966(ra) # 80002ecc <argint>
    return -1;
    80005682:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005684:	02054763          	bltz	a0,800056b2 <sys_write+0x5c>
    80005688:	fd840593          	addi	a1,s0,-40
    8000568c:	4505                	li	a0,1
    8000568e:	ffffe097          	auipc	ra,0xffffe
    80005692:	860080e7          	jalr	-1952(ra) # 80002eee <argaddr>
    return -1;
    80005696:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005698:	00054d63          	bltz	a0,800056b2 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000569c:	fe442603          	lw	a2,-28(s0)
    800056a0:	fd843583          	ld	a1,-40(s0)
    800056a4:	fe843503          	ld	a0,-24(s0)
    800056a8:	fffff097          	auipc	ra,0xfffff
    800056ac:	4ae080e7          	jalr	1198(ra) # 80004b56 <filewrite>
    800056b0:	87aa                	mv	a5,a0
}
    800056b2:	853e                	mv	a0,a5
    800056b4:	70a2                	ld	ra,40(sp)
    800056b6:	7402                	ld	s0,32(sp)
    800056b8:	6145                	addi	sp,sp,48
    800056ba:	8082                	ret

00000000800056bc <sys_close>:
{
    800056bc:	1101                	addi	sp,sp,-32
    800056be:	ec06                	sd	ra,24(sp)
    800056c0:	e822                	sd	s0,16(sp)
    800056c2:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800056c4:	fe040613          	addi	a2,s0,-32
    800056c8:	fec40593          	addi	a1,s0,-20
    800056cc:	4501                	li	a0,0
    800056ce:	00000097          	auipc	ra,0x0
    800056d2:	cc4080e7          	jalr	-828(ra) # 80005392 <argfd>
    return -1;
    800056d6:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800056d8:	02054463          	bltz	a0,80005700 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800056dc:	ffffc097          	auipc	ra,0xffffc
    800056e0:	590080e7          	jalr	1424(ra) # 80001c6c <myproc>
    800056e4:	fec42783          	lw	a5,-20(s0)
    800056e8:	07f1                	addi	a5,a5,28
    800056ea:	078e                	slli	a5,a5,0x3
    800056ec:	97aa                	add	a5,a5,a0
    800056ee:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800056f2:	fe043503          	ld	a0,-32(s0)
    800056f6:	fffff097          	auipc	ra,0xfffff
    800056fa:	264080e7          	jalr	612(ra) # 8000495a <fileclose>
  return 0;
    800056fe:	4781                	li	a5,0
}
    80005700:	853e                	mv	a0,a5
    80005702:	60e2                	ld	ra,24(sp)
    80005704:	6442                	ld	s0,16(sp)
    80005706:	6105                	addi	sp,sp,32
    80005708:	8082                	ret

000000008000570a <sys_fstat>:
{
    8000570a:	1101                	addi	sp,sp,-32
    8000570c:	ec06                	sd	ra,24(sp)
    8000570e:	e822                	sd	s0,16(sp)
    80005710:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005712:	fe840613          	addi	a2,s0,-24
    80005716:	4581                	li	a1,0
    80005718:	4501                	li	a0,0
    8000571a:	00000097          	auipc	ra,0x0
    8000571e:	c78080e7          	jalr	-904(ra) # 80005392 <argfd>
    return -1;
    80005722:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005724:	02054563          	bltz	a0,8000574e <sys_fstat+0x44>
    80005728:	fe040593          	addi	a1,s0,-32
    8000572c:	4505                	li	a0,1
    8000572e:	ffffd097          	auipc	ra,0xffffd
    80005732:	7c0080e7          	jalr	1984(ra) # 80002eee <argaddr>
    return -1;
    80005736:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005738:	00054b63          	bltz	a0,8000574e <sys_fstat+0x44>
  return filestat(f, st);
    8000573c:	fe043583          	ld	a1,-32(s0)
    80005740:	fe843503          	ld	a0,-24(s0)
    80005744:	fffff097          	auipc	ra,0xfffff
    80005748:	2de080e7          	jalr	734(ra) # 80004a22 <filestat>
    8000574c:	87aa                	mv	a5,a0
}
    8000574e:	853e                	mv	a0,a5
    80005750:	60e2                	ld	ra,24(sp)
    80005752:	6442                	ld	s0,16(sp)
    80005754:	6105                	addi	sp,sp,32
    80005756:	8082                	ret

0000000080005758 <sys_link>:
{
    80005758:	7169                	addi	sp,sp,-304
    8000575a:	f606                	sd	ra,296(sp)
    8000575c:	f222                	sd	s0,288(sp)
    8000575e:	ee26                	sd	s1,280(sp)
    80005760:	ea4a                	sd	s2,272(sp)
    80005762:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005764:	08000613          	li	a2,128
    80005768:	ed040593          	addi	a1,s0,-304
    8000576c:	4501                	li	a0,0
    8000576e:	ffffd097          	auipc	ra,0xffffd
    80005772:	7a2080e7          	jalr	1954(ra) # 80002f10 <argstr>
    return -1;
    80005776:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005778:	10054e63          	bltz	a0,80005894 <sys_link+0x13c>
    8000577c:	08000613          	li	a2,128
    80005780:	f5040593          	addi	a1,s0,-176
    80005784:	4505                	li	a0,1
    80005786:	ffffd097          	auipc	ra,0xffffd
    8000578a:	78a080e7          	jalr	1930(ra) # 80002f10 <argstr>
    return -1;
    8000578e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005790:	10054263          	bltz	a0,80005894 <sys_link+0x13c>
  begin_op();
    80005794:	fffff097          	auipc	ra,0xfffff
    80005798:	cfa080e7          	jalr	-774(ra) # 8000448e <begin_op>
  if((ip = namei(old)) == 0){
    8000579c:	ed040513          	addi	a0,s0,-304
    800057a0:	fffff097          	auipc	ra,0xfffff
    800057a4:	ad2080e7          	jalr	-1326(ra) # 80004272 <namei>
    800057a8:	84aa                	mv	s1,a0
    800057aa:	c551                	beqz	a0,80005836 <sys_link+0xde>
  ilock(ip);
    800057ac:	ffffe097          	auipc	ra,0xffffe
    800057b0:	310080e7          	jalr	784(ra) # 80003abc <ilock>
  if(ip->type == T_DIR){
    800057b4:	04449703          	lh	a4,68(s1)
    800057b8:	4785                	li	a5,1
    800057ba:	08f70463          	beq	a4,a5,80005842 <sys_link+0xea>
  ip->nlink++;
    800057be:	04a4d783          	lhu	a5,74(s1)
    800057c2:	2785                	addiw	a5,a5,1
    800057c4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800057c8:	8526                	mv	a0,s1
    800057ca:	ffffe097          	auipc	ra,0xffffe
    800057ce:	228080e7          	jalr	552(ra) # 800039f2 <iupdate>
  iunlock(ip);
    800057d2:	8526                	mv	a0,s1
    800057d4:	ffffe097          	auipc	ra,0xffffe
    800057d8:	3aa080e7          	jalr	938(ra) # 80003b7e <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800057dc:	fd040593          	addi	a1,s0,-48
    800057e0:	f5040513          	addi	a0,s0,-176
    800057e4:	fffff097          	auipc	ra,0xfffff
    800057e8:	aac080e7          	jalr	-1364(ra) # 80004290 <nameiparent>
    800057ec:	892a                	mv	s2,a0
    800057ee:	c935                	beqz	a0,80005862 <sys_link+0x10a>
  ilock(dp);
    800057f0:	ffffe097          	auipc	ra,0xffffe
    800057f4:	2cc080e7          	jalr	716(ra) # 80003abc <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800057f8:	00092703          	lw	a4,0(s2)
    800057fc:	409c                	lw	a5,0(s1)
    800057fe:	04f71d63          	bne	a4,a5,80005858 <sys_link+0x100>
    80005802:	40d0                	lw	a2,4(s1)
    80005804:	fd040593          	addi	a1,s0,-48
    80005808:	854a                	mv	a0,s2
    8000580a:	fffff097          	auipc	ra,0xfffff
    8000580e:	9a6080e7          	jalr	-1626(ra) # 800041b0 <dirlink>
    80005812:	04054363          	bltz	a0,80005858 <sys_link+0x100>
  iunlockput(dp);
    80005816:	854a                	mv	a0,s2
    80005818:	ffffe097          	auipc	ra,0xffffe
    8000581c:	506080e7          	jalr	1286(ra) # 80003d1e <iunlockput>
  iput(ip);
    80005820:	8526                	mv	a0,s1
    80005822:	ffffe097          	auipc	ra,0xffffe
    80005826:	454080e7          	jalr	1108(ra) # 80003c76 <iput>
  end_op();
    8000582a:	fffff097          	auipc	ra,0xfffff
    8000582e:	ce4080e7          	jalr	-796(ra) # 8000450e <end_op>
  return 0;
    80005832:	4781                	li	a5,0
    80005834:	a085                	j	80005894 <sys_link+0x13c>
    end_op();
    80005836:	fffff097          	auipc	ra,0xfffff
    8000583a:	cd8080e7          	jalr	-808(ra) # 8000450e <end_op>
    return -1;
    8000583e:	57fd                	li	a5,-1
    80005840:	a891                	j	80005894 <sys_link+0x13c>
    iunlockput(ip);
    80005842:	8526                	mv	a0,s1
    80005844:	ffffe097          	auipc	ra,0xffffe
    80005848:	4da080e7          	jalr	1242(ra) # 80003d1e <iunlockput>
    end_op();
    8000584c:	fffff097          	auipc	ra,0xfffff
    80005850:	cc2080e7          	jalr	-830(ra) # 8000450e <end_op>
    return -1;
    80005854:	57fd                	li	a5,-1
    80005856:	a83d                	j	80005894 <sys_link+0x13c>
    iunlockput(dp);
    80005858:	854a                	mv	a0,s2
    8000585a:	ffffe097          	auipc	ra,0xffffe
    8000585e:	4c4080e7          	jalr	1220(ra) # 80003d1e <iunlockput>
  ilock(ip);
    80005862:	8526                	mv	a0,s1
    80005864:	ffffe097          	auipc	ra,0xffffe
    80005868:	258080e7          	jalr	600(ra) # 80003abc <ilock>
  ip->nlink--;
    8000586c:	04a4d783          	lhu	a5,74(s1)
    80005870:	37fd                	addiw	a5,a5,-1
    80005872:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005876:	8526                	mv	a0,s1
    80005878:	ffffe097          	auipc	ra,0xffffe
    8000587c:	17a080e7          	jalr	378(ra) # 800039f2 <iupdate>
  iunlockput(ip);
    80005880:	8526                	mv	a0,s1
    80005882:	ffffe097          	auipc	ra,0xffffe
    80005886:	49c080e7          	jalr	1180(ra) # 80003d1e <iunlockput>
  end_op();
    8000588a:	fffff097          	auipc	ra,0xfffff
    8000588e:	c84080e7          	jalr	-892(ra) # 8000450e <end_op>
  return -1;
    80005892:	57fd                	li	a5,-1
}
    80005894:	853e                	mv	a0,a5
    80005896:	70b2                	ld	ra,296(sp)
    80005898:	7412                	ld	s0,288(sp)
    8000589a:	64f2                	ld	s1,280(sp)
    8000589c:	6952                	ld	s2,272(sp)
    8000589e:	6155                	addi	sp,sp,304
    800058a0:	8082                	ret

00000000800058a2 <sys_unlink>:
{
    800058a2:	7151                	addi	sp,sp,-240
    800058a4:	f586                	sd	ra,232(sp)
    800058a6:	f1a2                	sd	s0,224(sp)
    800058a8:	eda6                	sd	s1,216(sp)
    800058aa:	e9ca                	sd	s2,208(sp)
    800058ac:	e5ce                	sd	s3,200(sp)
    800058ae:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800058b0:	08000613          	li	a2,128
    800058b4:	f3040593          	addi	a1,s0,-208
    800058b8:	4501                	li	a0,0
    800058ba:	ffffd097          	auipc	ra,0xffffd
    800058be:	656080e7          	jalr	1622(ra) # 80002f10 <argstr>
    800058c2:	18054163          	bltz	a0,80005a44 <sys_unlink+0x1a2>
  begin_op();
    800058c6:	fffff097          	auipc	ra,0xfffff
    800058ca:	bc8080e7          	jalr	-1080(ra) # 8000448e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800058ce:	fb040593          	addi	a1,s0,-80
    800058d2:	f3040513          	addi	a0,s0,-208
    800058d6:	fffff097          	auipc	ra,0xfffff
    800058da:	9ba080e7          	jalr	-1606(ra) # 80004290 <nameiparent>
    800058de:	84aa                	mv	s1,a0
    800058e0:	c979                	beqz	a0,800059b6 <sys_unlink+0x114>
  ilock(dp);
    800058e2:	ffffe097          	auipc	ra,0xffffe
    800058e6:	1da080e7          	jalr	474(ra) # 80003abc <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800058ea:	00003597          	auipc	a1,0x3
    800058ee:	f3658593          	addi	a1,a1,-202 # 80008820 <syscalls+0x2b8>
    800058f2:	fb040513          	addi	a0,s0,-80
    800058f6:	ffffe097          	auipc	ra,0xffffe
    800058fa:	690080e7          	jalr	1680(ra) # 80003f86 <namecmp>
    800058fe:	14050a63          	beqz	a0,80005a52 <sys_unlink+0x1b0>
    80005902:	00003597          	auipc	a1,0x3
    80005906:	96658593          	addi	a1,a1,-1690 # 80008268 <digits+0x200>
    8000590a:	fb040513          	addi	a0,s0,-80
    8000590e:	ffffe097          	auipc	ra,0xffffe
    80005912:	678080e7          	jalr	1656(ra) # 80003f86 <namecmp>
    80005916:	12050e63          	beqz	a0,80005a52 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000591a:	f2c40613          	addi	a2,s0,-212
    8000591e:	fb040593          	addi	a1,s0,-80
    80005922:	8526                	mv	a0,s1
    80005924:	ffffe097          	auipc	ra,0xffffe
    80005928:	67c080e7          	jalr	1660(ra) # 80003fa0 <dirlookup>
    8000592c:	892a                	mv	s2,a0
    8000592e:	12050263          	beqz	a0,80005a52 <sys_unlink+0x1b0>
  ilock(ip);
    80005932:	ffffe097          	auipc	ra,0xffffe
    80005936:	18a080e7          	jalr	394(ra) # 80003abc <ilock>
  if(ip->nlink < 1)
    8000593a:	04a91783          	lh	a5,74(s2)
    8000593e:	08f05263          	blez	a5,800059c2 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005942:	04491703          	lh	a4,68(s2)
    80005946:	4785                	li	a5,1
    80005948:	08f70563          	beq	a4,a5,800059d2 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    8000594c:	4641                	li	a2,16
    8000594e:	4581                	li	a1,0
    80005950:	fc040513          	addi	a0,s0,-64
    80005954:	ffffb097          	auipc	ra,0xffffb
    80005958:	3e2080e7          	jalr	994(ra) # 80000d36 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000595c:	4741                	li	a4,16
    8000595e:	f2c42683          	lw	a3,-212(s0)
    80005962:	fc040613          	addi	a2,s0,-64
    80005966:	4581                	li	a1,0
    80005968:	8526                	mv	a0,s1
    8000596a:	ffffe097          	auipc	ra,0xffffe
    8000596e:	4fe080e7          	jalr	1278(ra) # 80003e68 <writei>
    80005972:	47c1                	li	a5,16
    80005974:	0af51563          	bne	a0,a5,80005a1e <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005978:	04491703          	lh	a4,68(s2)
    8000597c:	4785                	li	a5,1
    8000597e:	0af70863          	beq	a4,a5,80005a2e <sys_unlink+0x18c>
  iunlockput(dp);
    80005982:	8526                	mv	a0,s1
    80005984:	ffffe097          	auipc	ra,0xffffe
    80005988:	39a080e7          	jalr	922(ra) # 80003d1e <iunlockput>
  ip->nlink--;
    8000598c:	04a95783          	lhu	a5,74(s2)
    80005990:	37fd                	addiw	a5,a5,-1
    80005992:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005996:	854a                	mv	a0,s2
    80005998:	ffffe097          	auipc	ra,0xffffe
    8000599c:	05a080e7          	jalr	90(ra) # 800039f2 <iupdate>
  iunlockput(ip);
    800059a0:	854a                	mv	a0,s2
    800059a2:	ffffe097          	auipc	ra,0xffffe
    800059a6:	37c080e7          	jalr	892(ra) # 80003d1e <iunlockput>
  end_op();
    800059aa:	fffff097          	auipc	ra,0xfffff
    800059ae:	b64080e7          	jalr	-1180(ra) # 8000450e <end_op>
  return 0;
    800059b2:	4501                	li	a0,0
    800059b4:	a84d                	j	80005a66 <sys_unlink+0x1c4>
    end_op();
    800059b6:	fffff097          	auipc	ra,0xfffff
    800059ba:	b58080e7          	jalr	-1192(ra) # 8000450e <end_op>
    return -1;
    800059be:	557d                	li	a0,-1
    800059c0:	a05d                	j	80005a66 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800059c2:	00003517          	auipc	a0,0x3
    800059c6:	e8650513          	addi	a0,a0,-378 # 80008848 <syscalls+0x2e0>
    800059ca:	ffffb097          	auipc	ra,0xffffb
    800059ce:	c02080e7          	jalr	-1022(ra) # 800005cc <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800059d2:	04c92703          	lw	a4,76(s2)
    800059d6:	02000793          	li	a5,32
    800059da:	f6e7f9e3          	bgeu	a5,a4,8000594c <sys_unlink+0xaa>
    800059de:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800059e2:	4741                	li	a4,16
    800059e4:	86ce                	mv	a3,s3
    800059e6:	f1840613          	addi	a2,s0,-232
    800059ea:	4581                	li	a1,0
    800059ec:	854a                	mv	a0,s2
    800059ee:	ffffe097          	auipc	ra,0xffffe
    800059f2:	382080e7          	jalr	898(ra) # 80003d70 <readi>
    800059f6:	47c1                	li	a5,16
    800059f8:	00f51b63          	bne	a0,a5,80005a0e <sys_unlink+0x16c>
    if(de.inum != 0)
    800059fc:	f1845783          	lhu	a5,-232(s0)
    80005a00:	e7a1                	bnez	a5,80005a48 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005a02:	29c1                	addiw	s3,s3,16
    80005a04:	04c92783          	lw	a5,76(s2)
    80005a08:	fcf9ede3          	bltu	s3,a5,800059e2 <sys_unlink+0x140>
    80005a0c:	b781                	j	8000594c <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005a0e:	00003517          	auipc	a0,0x3
    80005a12:	e5250513          	addi	a0,a0,-430 # 80008860 <syscalls+0x2f8>
    80005a16:	ffffb097          	auipc	ra,0xffffb
    80005a1a:	bb6080e7          	jalr	-1098(ra) # 800005cc <panic>
    panic("unlink: writei");
    80005a1e:	00003517          	auipc	a0,0x3
    80005a22:	e5a50513          	addi	a0,a0,-422 # 80008878 <syscalls+0x310>
    80005a26:	ffffb097          	auipc	ra,0xffffb
    80005a2a:	ba6080e7          	jalr	-1114(ra) # 800005cc <panic>
    dp->nlink--;
    80005a2e:	04a4d783          	lhu	a5,74(s1)
    80005a32:	37fd                	addiw	a5,a5,-1
    80005a34:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005a38:	8526                	mv	a0,s1
    80005a3a:	ffffe097          	auipc	ra,0xffffe
    80005a3e:	fb8080e7          	jalr	-72(ra) # 800039f2 <iupdate>
    80005a42:	b781                	j	80005982 <sys_unlink+0xe0>
    return -1;
    80005a44:	557d                	li	a0,-1
    80005a46:	a005                	j	80005a66 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005a48:	854a                	mv	a0,s2
    80005a4a:	ffffe097          	auipc	ra,0xffffe
    80005a4e:	2d4080e7          	jalr	724(ra) # 80003d1e <iunlockput>
  iunlockput(dp);
    80005a52:	8526                	mv	a0,s1
    80005a54:	ffffe097          	auipc	ra,0xffffe
    80005a58:	2ca080e7          	jalr	714(ra) # 80003d1e <iunlockput>
  end_op();
    80005a5c:	fffff097          	auipc	ra,0xfffff
    80005a60:	ab2080e7          	jalr	-1358(ra) # 8000450e <end_op>
  return -1;
    80005a64:	557d                	li	a0,-1
}
    80005a66:	70ae                	ld	ra,232(sp)
    80005a68:	740e                	ld	s0,224(sp)
    80005a6a:	64ee                	ld	s1,216(sp)
    80005a6c:	694e                	ld	s2,208(sp)
    80005a6e:	69ae                	ld	s3,200(sp)
    80005a70:	616d                	addi	sp,sp,240
    80005a72:	8082                	ret

0000000080005a74 <sys_open>:

uint64
sys_open(void)
{
    80005a74:	7131                	addi	sp,sp,-192
    80005a76:	fd06                	sd	ra,184(sp)
    80005a78:	f922                	sd	s0,176(sp)
    80005a7a:	f526                	sd	s1,168(sp)
    80005a7c:	f14a                	sd	s2,160(sp)
    80005a7e:	ed4e                	sd	s3,152(sp)
    80005a80:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005a82:	08000613          	li	a2,128
    80005a86:	f5040593          	addi	a1,s0,-176
    80005a8a:	4501                	li	a0,0
    80005a8c:	ffffd097          	auipc	ra,0xffffd
    80005a90:	484080e7          	jalr	1156(ra) # 80002f10 <argstr>
    return -1;
    80005a94:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005a96:	0c054163          	bltz	a0,80005b58 <sys_open+0xe4>
    80005a9a:	f4c40593          	addi	a1,s0,-180
    80005a9e:	4505                	li	a0,1
    80005aa0:	ffffd097          	auipc	ra,0xffffd
    80005aa4:	42c080e7          	jalr	1068(ra) # 80002ecc <argint>
    80005aa8:	0a054863          	bltz	a0,80005b58 <sys_open+0xe4>

  begin_op();
    80005aac:	fffff097          	auipc	ra,0xfffff
    80005ab0:	9e2080e7          	jalr	-1566(ra) # 8000448e <begin_op>

  if(omode & O_CREATE){
    80005ab4:	f4c42783          	lw	a5,-180(s0)
    80005ab8:	2007f793          	andi	a5,a5,512
    80005abc:	cbdd                	beqz	a5,80005b72 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005abe:	4681                	li	a3,0
    80005ac0:	4601                	li	a2,0
    80005ac2:	4589                	li	a1,2
    80005ac4:	f5040513          	addi	a0,s0,-176
    80005ac8:	00000097          	auipc	ra,0x0
    80005acc:	974080e7          	jalr	-1676(ra) # 8000543c <create>
    80005ad0:	892a                	mv	s2,a0
    if(ip == 0){
    80005ad2:	c959                	beqz	a0,80005b68 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005ad4:	04491703          	lh	a4,68(s2)
    80005ad8:	478d                	li	a5,3
    80005ada:	00f71763          	bne	a4,a5,80005ae8 <sys_open+0x74>
    80005ade:	04695703          	lhu	a4,70(s2)
    80005ae2:	47a5                	li	a5,9
    80005ae4:	0ce7ec63          	bltu	a5,a4,80005bbc <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005ae8:	fffff097          	auipc	ra,0xfffff
    80005aec:	db6080e7          	jalr	-586(ra) # 8000489e <filealloc>
    80005af0:	89aa                	mv	s3,a0
    80005af2:	10050263          	beqz	a0,80005bf6 <sys_open+0x182>
    80005af6:	00000097          	auipc	ra,0x0
    80005afa:	904080e7          	jalr	-1788(ra) # 800053fa <fdalloc>
    80005afe:	84aa                	mv	s1,a0
    80005b00:	0e054663          	bltz	a0,80005bec <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005b04:	04491703          	lh	a4,68(s2)
    80005b08:	478d                	li	a5,3
    80005b0a:	0cf70463          	beq	a4,a5,80005bd2 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005b0e:	4789                	li	a5,2
    80005b10:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005b14:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005b18:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005b1c:	f4c42783          	lw	a5,-180(s0)
    80005b20:	0017c713          	xori	a4,a5,1
    80005b24:	8b05                	andi	a4,a4,1
    80005b26:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005b2a:	0037f713          	andi	a4,a5,3
    80005b2e:	00e03733          	snez	a4,a4
    80005b32:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005b36:	4007f793          	andi	a5,a5,1024
    80005b3a:	c791                	beqz	a5,80005b46 <sys_open+0xd2>
    80005b3c:	04491703          	lh	a4,68(s2)
    80005b40:	4789                	li	a5,2
    80005b42:	08f70f63          	beq	a4,a5,80005be0 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005b46:	854a                	mv	a0,s2
    80005b48:	ffffe097          	auipc	ra,0xffffe
    80005b4c:	036080e7          	jalr	54(ra) # 80003b7e <iunlock>
  end_op();
    80005b50:	fffff097          	auipc	ra,0xfffff
    80005b54:	9be080e7          	jalr	-1602(ra) # 8000450e <end_op>

  return fd;
}
    80005b58:	8526                	mv	a0,s1
    80005b5a:	70ea                	ld	ra,184(sp)
    80005b5c:	744a                	ld	s0,176(sp)
    80005b5e:	74aa                	ld	s1,168(sp)
    80005b60:	790a                	ld	s2,160(sp)
    80005b62:	69ea                	ld	s3,152(sp)
    80005b64:	6129                	addi	sp,sp,192
    80005b66:	8082                	ret
      end_op();
    80005b68:	fffff097          	auipc	ra,0xfffff
    80005b6c:	9a6080e7          	jalr	-1626(ra) # 8000450e <end_op>
      return -1;
    80005b70:	b7e5                	j	80005b58 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80005b72:	f5040513          	addi	a0,s0,-176
    80005b76:	ffffe097          	auipc	ra,0xffffe
    80005b7a:	6fc080e7          	jalr	1788(ra) # 80004272 <namei>
    80005b7e:	892a                	mv	s2,a0
    80005b80:	c905                	beqz	a0,80005bb0 <sys_open+0x13c>
    ilock(ip);
    80005b82:	ffffe097          	auipc	ra,0xffffe
    80005b86:	f3a080e7          	jalr	-198(ra) # 80003abc <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005b8a:	04491703          	lh	a4,68(s2)
    80005b8e:	4785                	li	a5,1
    80005b90:	f4f712e3          	bne	a4,a5,80005ad4 <sys_open+0x60>
    80005b94:	f4c42783          	lw	a5,-180(s0)
    80005b98:	dba1                	beqz	a5,80005ae8 <sys_open+0x74>
      iunlockput(ip);
    80005b9a:	854a                	mv	a0,s2
    80005b9c:	ffffe097          	auipc	ra,0xffffe
    80005ba0:	182080e7          	jalr	386(ra) # 80003d1e <iunlockput>
      end_op();
    80005ba4:	fffff097          	auipc	ra,0xfffff
    80005ba8:	96a080e7          	jalr	-1686(ra) # 8000450e <end_op>
      return -1;
    80005bac:	54fd                	li	s1,-1
    80005bae:	b76d                	j	80005b58 <sys_open+0xe4>
      end_op();
    80005bb0:	fffff097          	auipc	ra,0xfffff
    80005bb4:	95e080e7          	jalr	-1698(ra) # 8000450e <end_op>
      return -1;
    80005bb8:	54fd                	li	s1,-1
    80005bba:	bf79                	j	80005b58 <sys_open+0xe4>
    iunlockput(ip);
    80005bbc:	854a                	mv	a0,s2
    80005bbe:	ffffe097          	auipc	ra,0xffffe
    80005bc2:	160080e7          	jalr	352(ra) # 80003d1e <iunlockput>
    end_op();
    80005bc6:	fffff097          	auipc	ra,0xfffff
    80005bca:	948080e7          	jalr	-1720(ra) # 8000450e <end_op>
    return -1;
    80005bce:	54fd                	li	s1,-1
    80005bd0:	b761                	j	80005b58 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005bd2:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005bd6:	04691783          	lh	a5,70(s2)
    80005bda:	02f99223          	sh	a5,36(s3)
    80005bde:	bf2d                	j	80005b18 <sys_open+0xa4>
    itrunc(ip);
    80005be0:	854a                	mv	a0,s2
    80005be2:	ffffe097          	auipc	ra,0xffffe
    80005be6:	fe8080e7          	jalr	-24(ra) # 80003bca <itrunc>
    80005bea:	bfb1                	j	80005b46 <sys_open+0xd2>
      fileclose(f);
    80005bec:	854e                	mv	a0,s3
    80005bee:	fffff097          	auipc	ra,0xfffff
    80005bf2:	d6c080e7          	jalr	-660(ra) # 8000495a <fileclose>
    iunlockput(ip);
    80005bf6:	854a                	mv	a0,s2
    80005bf8:	ffffe097          	auipc	ra,0xffffe
    80005bfc:	126080e7          	jalr	294(ra) # 80003d1e <iunlockput>
    end_op();
    80005c00:	fffff097          	auipc	ra,0xfffff
    80005c04:	90e080e7          	jalr	-1778(ra) # 8000450e <end_op>
    return -1;
    80005c08:	54fd                	li	s1,-1
    80005c0a:	b7b9                	j	80005b58 <sys_open+0xe4>

0000000080005c0c <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005c0c:	7175                	addi	sp,sp,-144
    80005c0e:	e506                	sd	ra,136(sp)
    80005c10:	e122                	sd	s0,128(sp)
    80005c12:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005c14:	fffff097          	auipc	ra,0xfffff
    80005c18:	87a080e7          	jalr	-1926(ra) # 8000448e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005c1c:	08000613          	li	a2,128
    80005c20:	f7040593          	addi	a1,s0,-144
    80005c24:	4501                	li	a0,0
    80005c26:	ffffd097          	auipc	ra,0xffffd
    80005c2a:	2ea080e7          	jalr	746(ra) # 80002f10 <argstr>
    80005c2e:	02054963          	bltz	a0,80005c60 <sys_mkdir+0x54>
    80005c32:	4681                	li	a3,0
    80005c34:	4601                	li	a2,0
    80005c36:	4585                	li	a1,1
    80005c38:	f7040513          	addi	a0,s0,-144
    80005c3c:	00000097          	auipc	ra,0x0
    80005c40:	800080e7          	jalr	-2048(ra) # 8000543c <create>
    80005c44:	cd11                	beqz	a0,80005c60 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005c46:	ffffe097          	auipc	ra,0xffffe
    80005c4a:	0d8080e7          	jalr	216(ra) # 80003d1e <iunlockput>
  end_op();
    80005c4e:	fffff097          	auipc	ra,0xfffff
    80005c52:	8c0080e7          	jalr	-1856(ra) # 8000450e <end_op>
  return 0;
    80005c56:	4501                	li	a0,0
}
    80005c58:	60aa                	ld	ra,136(sp)
    80005c5a:	640a                	ld	s0,128(sp)
    80005c5c:	6149                	addi	sp,sp,144
    80005c5e:	8082                	ret
    end_op();
    80005c60:	fffff097          	auipc	ra,0xfffff
    80005c64:	8ae080e7          	jalr	-1874(ra) # 8000450e <end_op>
    return -1;
    80005c68:	557d                	li	a0,-1
    80005c6a:	b7fd                	j	80005c58 <sys_mkdir+0x4c>

0000000080005c6c <sys_mknod>:

uint64
sys_mknod(void)
{
    80005c6c:	7135                	addi	sp,sp,-160
    80005c6e:	ed06                	sd	ra,152(sp)
    80005c70:	e922                	sd	s0,144(sp)
    80005c72:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005c74:	fffff097          	auipc	ra,0xfffff
    80005c78:	81a080e7          	jalr	-2022(ra) # 8000448e <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005c7c:	08000613          	li	a2,128
    80005c80:	f7040593          	addi	a1,s0,-144
    80005c84:	4501                	li	a0,0
    80005c86:	ffffd097          	auipc	ra,0xffffd
    80005c8a:	28a080e7          	jalr	650(ra) # 80002f10 <argstr>
    80005c8e:	04054a63          	bltz	a0,80005ce2 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80005c92:	f6c40593          	addi	a1,s0,-148
    80005c96:	4505                	li	a0,1
    80005c98:	ffffd097          	auipc	ra,0xffffd
    80005c9c:	234080e7          	jalr	564(ra) # 80002ecc <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005ca0:	04054163          	bltz	a0,80005ce2 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005ca4:	f6840593          	addi	a1,s0,-152
    80005ca8:	4509                	li	a0,2
    80005caa:	ffffd097          	auipc	ra,0xffffd
    80005cae:	222080e7          	jalr	546(ra) # 80002ecc <argint>
     argint(1, &major) < 0 ||
    80005cb2:	02054863          	bltz	a0,80005ce2 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005cb6:	f6841683          	lh	a3,-152(s0)
    80005cba:	f6c41603          	lh	a2,-148(s0)
    80005cbe:	458d                	li	a1,3
    80005cc0:	f7040513          	addi	a0,s0,-144
    80005cc4:	fffff097          	auipc	ra,0xfffff
    80005cc8:	778080e7          	jalr	1912(ra) # 8000543c <create>
     argint(2, &minor) < 0 ||
    80005ccc:	c919                	beqz	a0,80005ce2 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005cce:	ffffe097          	auipc	ra,0xffffe
    80005cd2:	050080e7          	jalr	80(ra) # 80003d1e <iunlockput>
  end_op();
    80005cd6:	fffff097          	auipc	ra,0xfffff
    80005cda:	838080e7          	jalr	-1992(ra) # 8000450e <end_op>
  return 0;
    80005cde:	4501                	li	a0,0
    80005ce0:	a031                	j	80005cec <sys_mknod+0x80>
    end_op();
    80005ce2:	fffff097          	auipc	ra,0xfffff
    80005ce6:	82c080e7          	jalr	-2004(ra) # 8000450e <end_op>
    return -1;
    80005cea:	557d                	li	a0,-1
}
    80005cec:	60ea                	ld	ra,152(sp)
    80005cee:	644a                	ld	s0,144(sp)
    80005cf0:	610d                	addi	sp,sp,160
    80005cf2:	8082                	ret

0000000080005cf4 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005cf4:	7135                	addi	sp,sp,-160
    80005cf6:	ed06                	sd	ra,152(sp)
    80005cf8:	e922                	sd	s0,144(sp)
    80005cfa:	e526                	sd	s1,136(sp)
    80005cfc:	e14a                	sd	s2,128(sp)
    80005cfe:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005d00:	ffffc097          	auipc	ra,0xffffc
    80005d04:	f6c080e7          	jalr	-148(ra) # 80001c6c <myproc>
    80005d08:	892a                	mv	s2,a0
  
  begin_op();
    80005d0a:	ffffe097          	auipc	ra,0xffffe
    80005d0e:	784080e7          	jalr	1924(ra) # 8000448e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005d12:	08000613          	li	a2,128
    80005d16:	f6040593          	addi	a1,s0,-160
    80005d1a:	4501                	li	a0,0
    80005d1c:	ffffd097          	auipc	ra,0xffffd
    80005d20:	1f4080e7          	jalr	500(ra) # 80002f10 <argstr>
    80005d24:	04054b63          	bltz	a0,80005d7a <sys_chdir+0x86>
    80005d28:	f6040513          	addi	a0,s0,-160
    80005d2c:	ffffe097          	auipc	ra,0xffffe
    80005d30:	546080e7          	jalr	1350(ra) # 80004272 <namei>
    80005d34:	84aa                	mv	s1,a0
    80005d36:	c131                	beqz	a0,80005d7a <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005d38:	ffffe097          	auipc	ra,0xffffe
    80005d3c:	d84080e7          	jalr	-636(ra) # 80003abc <ilock>
  if(ip->type != T_DIR){
    80005d40:	04449703          	lh	a4,68(s1)
    80005d44:	4785                	li	a5,1
    80005d46:	04f71063          	bne	a4,a5,80005d86 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005d4a:	8526                	mv	a0,s1
    80005d4c:	ffffe097          	auipc	ra,0xffffe
    80005d50:	e32080e7          	jalr	-462(ra) # 80003b7e <iunlock>
  iput(p->cwd);
    80005d54:	16093503          	ld	a0,352(s2)
    80005d58:	ffffe097          	auipc	ra,0xffffe
    80005d5c:	f1e080e7          	jalr	-226(ra) # 80003c76 <iput>
  end_op();
    80005d60:	ffffe097          	auipc	ra,0xffffe
    80005d64:	7ae080e7          	jalr	1966(ra) # 8000450e <end_op>
  p->cwd = ip;
    80005d68:	16993023          	sd	s1,352(s2)
  return 0;
    80005d6c:	4501                	li	a0,0
}
    80005d6e:	60ea                	ld	ra,152(sp)
    80005d70:	644a                	ld	s0,144(sp)
    80005d72:	64aa                	ld	s1,136(sp)
    80005d74:	690a                	ld	s2,128(sp)
    80005d76:	610d                	addi	sp,sp,160
    80005d78:	8082                	ret
    end_op();
    80005d7a:	ffffe097          	auipc	ra,0xffffe
    80005d7e:	794080e7          	jalr	1940(ra) # 8000450e <end_op>
    return -1;
    80005d82:	557d                	li	a0,-1
    80005d84:	b7ed                	j	80005d6e <sys_chdir+0x7a>
    iunlockput(ip);
    80005d86:	8526                	mv	a0,s1
    80005d88:	ffffe097          	auipc	ra,0xffffe
    80005d8c:	f96080e7          	jalr	-106(ra) # 80003d1e <iunlockput>
    end_op();
    80005d90:	ffffe097          	auipc	ra,0xffffe
    80005d94:	77e080e7          	jalr	1918(ra) # 8000450e <end_op>
    return -1;
    80005d98:	557d                	li	a0,-1
    80005d9a:	bfd1                	j	80005d6e <sys_chdir+0x7a>

0000000080005d9c <sys_exec>:

uint64
sys_exec(void)
{
    80005d9c:	7145                	addi	sp,sp,-464
    80005d9e:	e786                	sd	ra,456(sp)
    80005da0:	e3a2                	sd	s0,448(sp)
    80005da2:	ff26                	sd	s1,440(sp)
    80005da4:	fb4a                	sd	s2,432(sp)
    80005da6:	f74e                	sd	s3,424(sp)
    80005da8:	f352                	sd	s4,416(sp)
    80005daa:	ef56                	sd	s5,408(sp)
    80005dac:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005dae:	08000613          	li	a2,128
    80005db2:	f4040593          	addi	a1,s0,-192
    80005db6:	4501                	li	a0,0
    80005db8:	ffffd097          	auipc	ra,0xffffd
    80005dbc:	158080e7          	jalr	344(ra) # 80002f10 <argstr>
    return -1;
    80005dc0:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005dc2:	0c054a63          	bltz	a0,80005e96 <sys_exec+0xfa>
    80005dc6:	e3840593          	addi	a1,s0,-456
    80005dca:	4505                	li	a0,1
    80005dcc:	ffffd097          	auipc	ra,0xffffd
    80005dd0:	122080e7          	jalr	290(ra) # 80002eee <argaddr>
    80005dd4:	0c054163          	bltz	a0,80005e96 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005dd8:	10000613          	li	a2,256
    80005ddc:	4581                	li	a1,0
    80005dde:	e4040513          	addi	a0,s0,-448
    80005de2:	ffffb097          	auipc	ra,0xffffb
    80005de6:	f54080e7          	jalr	-172(ra) # 80000d36 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005dea:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005dee:	89a6                	mv	s3,s1
    80005df0:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005df2:	02000a13          	li	s4,32
    80005df6:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005dfa:	00391793          	slli	a5,s2,0x3
    80005dfe:	e3040593          	addi	a1,s0,-464
    80005e02:	e3843503          	ld	a0,-456(s0)
    80005e06:	953e                	add	a0,a0,a5
    80005e08:	ffffd097          	auipc	ra,0xffffd
    80005e0c:	02a080e7          	jalr	42(ra) # 80002e32 <fetchaddr>
    80005e10:	02054a63          	bltz	a0,80005e44 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005e14:	e3043783          	ld	a5,-464(s0)
    80005e18:	c3b9                	beqz	a5,80005e5e <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005e1a:	ffffb097          	auipc	ra,0xffffb
    80005e1e:	d30080e7          	jalr	-720(ra) # 80000b4a <kalloc>
    80005e22:	85aa                	mv	a1,a0
    80005e24:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005e28:	cd11                	beqz	a0,80005e44 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005e2a:	6605                	lui	a2,0x1
    80005e2c:	e3043503          	ld	a0,-464(s0)
    80005e30:	ffffd097          	auipc	ra,0xffffd
    80005e34:	054080e7          	jalr	84(ra) # 80002e84 <fetchstr>
    80005e38:	00054663          	bltz	a0,80005e44 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005e3c:	0905                	addi	s2,s2,1
    80005e3e:	09a1                	addi	s3,s3,8
    80005e40:	fb491be3          	bne	s2,s4,80005df6 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005e44:	10048913          	addi	s2,s1,256
    80005e48:	6088                	ld	a0,0(s1)
    80005e4a:	c529                	beqz	a0,80005e94 <sys_exec+0xf8>
    kfree(argv[i]);
    80005e4c:	ffffb097          	auipc	ra,0xffffb
    80005e50:	c02080e7          	jalr	-1022(ra) # 80000a4e <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005e54:	04a1                	addi	s1,s1,8
    80005e56:	ff2499e3          	bne	s1,s2,80005e48 <sys_exec+0xac>
  return -1;
    80005e5a:	597d                	li	s2,-1
    80005e5c:	a82d                	j	80005e96 <sys_exec+0xfa>
      argv[i] = 0;
    80005e5e:	0a8e                	slli	s5,s5,0x3
    80005e60:	fc040793          	addi	a5,s0,-64
    80005e64:	9abe                	add	s5,s5,a5
    80005e66:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffd8e80>
  int ret = exec(path, argv);
    80005e6a:	e4040593          	addi	a1,s0,-448
    80005e6e:	f4040513          	addi	a0,s0,-192
    80005e72:	fffff097          	auipc	ra,0xfffff
    80005e76:	13a080e7          	jalr	314(ra) # 80004fac <exec>
    80005e7a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005e7c:	10048993          	addi	s3,s1,256
    80005e80:	6088                	ld	a0,0(s1)
    80005e82:	c911                	beqz	a0,80005e96 <sys_exec+0xfa>
    kfree(argv[i]);
    80005e84:	ffffb097          	auipc	ra,0xffffb
    80005e88:	bca080e7          	jalr	-1078(ra) # 80000a4e <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005e8c:	04a1                	addi	s1,s1,8
    80005e8e:	ff3499e3          	bne	s1,s3,80005e80 <sys_exec+0xe4>
    80005e92:	a011                	j	80005e96 <sys_exec+0xfa>
  return -1;
    80005e94:	597d                	li	s2,-1
}
    80005e96:	854a                	mv	a0,s2
    80005e98:	60be                	ld	ra,456(sp)
    80005e9a:	641e                	ld	s0,448(sp)
    80005e9c:	74fa                	ld	s1,440(sp)
    80005e9e:	795a                	ld	s2,432(sp)
    80005ea0:	79ba                	ld	s3,424(sp)
    80005ea2:	7a1a                	ld	s4,416(sp)
    80005ea4:	6afa                	ld	s5,408(sp)
    80005ea6:	6179                	addi	sp,sp,464
    80005ea8:	8082                	ret

0000000080005eaa <sys_pipe>:

uint64
sys_pipe(void)
{
    80005eaa:	7139                	addi	sp,sp,-64
    80005eac:	fc06                	sd	ra,56(sp)
    80005eae:	f822                	sd	s0,48(sp)
    80005eb0:	f426                	sd	s1,40(sp)
    80005eb2:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005eb4:	ffffc097          	auipc	ra,0xffffc
    80005eb8:	db8080e7          	jalr	-584(ra) # 80001c6c <myproc>
    80005ebc:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005ebe:	fd840593          	addi	a1,s0,-40
    80005ec2:	4501                	li	a0,0
    80005ec4:	ffffd097          	auipc	ra,0xffffd
    80005ec8:	02a080e7          	jalr	42(ra) # 80002eee <argaddr>
    return -1;
    80005ecc:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005ece:	0e054063          	bltz	a0,80005fae <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005ed2:	fc840593          	addi	a1,s0,-56
    80005ed6:	fd040513          	addi	a0,s0,-48
    80005eda:	fffff097          	auipc	ra,0xfffff
    80005ede:	db0080e7          	jalr	-592(ra) # 80004c8a <pipealloc>
    return -1;
    80005ee2:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005ee4:	0c054563          	bltz	a0,80005fae <sys_pipe+0x104>
  fd0 = -1;
    80005ee8:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005eec:	fd043503          	ld	a0,-48(s0)
    80005ef0:	fffff097          	auipc	ra,0xfffff
    80005ef4:	50a080e7          	jalr	1290(ra) # 800053fa <fdalloc>
    80005ef8:	fca42223          	sw	a0,-60(s0)
    80005efc:	08054c63          	bltz	a0,80005f94 <sys_pipe+0xea>
    80005f00:	fc843503          	ld	a0,-56(s0)
    80005f04:	fffff097          	auipc	ra,0xfffff
    80005f08:	4f6080e7          	jalr	1270(ra) # 800053fa <fdalloc>
    80005f0c:	fca42023          	sw	a0,-64(s0)
    80005f10:	06054863          	bltz	a0,80005f80 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005f14:	4691                	li	a3,4
    80005f16:	fc440613          	addi	a2,s0,-60
    80005f1a:	fd843583          	ld	a1,-40(s0)
    80005f1e:	6ca8                	ld	a0,88(s1)
    80005f20:	ffffc097          	auipc	ra,0xffffc
    80005f24:	93c080e7          	jalr	-1732(ra) # 8000185c <copyout>
    80005f28:	02054063          	bltz	a0,80005f48 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005f2c:	4691                	li	a3,4
    80005f2e:	fc040613          	addi	a2,s0,-64
    80005f32:	fd843583          	ld	a1,-40(s0)
    80005f36:	0591                	addi	a1,a1,4
    80005f38:	6ca8                	ld	a0,88(s1)
    80005f3a:	ffffc097          	auipc	ra,0xffffc
    80005f3e:	922080e7          	jalr	-1758(ra) # 8000185c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005f42:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005f44:	06055563          	bgez	a0,80005fae <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005f48:	fc442783          	lw	a5,-60(s0)
    80005f4c:	07f1                	addi	a5,a5,28
    80005f4e:	078e                	slli	a5,a5,0x3
    80005f50:	97a6                	add	a5,a5,s1
    80005f52:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005f56:	fc042503          	lw	a0,-64(s0)
    80005f5a:	0571                	addi	a0,a0,28
    80005f5c:	050e                	slli	a0,a0,0x3
    80005f5e:	9526                	add	a0,a0,s1
    80005f60:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005f64:	fd043503          	ld	a0,-48(s0)
    80005f68:	fffff097          	auipc	ra,0xfffff
    80005f6c:	9f2080e7          	jalr	-1550(ra) # 8000495a <fileclose>
    fileclose(wf);
    80005f70:	fc843503          	ld	a0,-56(s0)
    80005f74:	fffff097          	auipc	ra,0xfffff
    80005f78:	9e6080e7          	jalr	-1562(ra) # 8000495a <fileclose>
    return -1;
    80005f7c:	57fd                	li	a5,-1
    80005f7e:	a805                	j	80005fae <sys_pipe+0x104>
    if(fd0 >= 0)
    80005f80:	fc442783          	lw	a5,-60(s0)
    80005f84:	0007c863          	bltz	a5,80005f94 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005f88:	01c78513          	addi	a0,a5,28
    80005f8c:	050e                	slli	a0,a0,0x3
    80005f8e:	9526                	add	a0,a0,s1
    80005f90:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005f94:	fd043503          	ld	a0,-48(s0)
    80005f98:	fffff097          	auipc	ra,0xfffff
    80005f9c:	9c2080e7          	jalr	-1598(ra) # 8000495a <fileclose>
    fileclose(wf);
    80005fa0:	fc843503          	ld	a0,-56(s0)
    80005fa4:	fffff097          	auipc	ra,0xfffff
    80005fa8:	9b6080e7          	jalr	-1610(ra) # 8000495a <fileclose>
    return -1;
    80005fac:	57fd                	li	a5,-1
}
    80005fae:	853e                	mv	a0,a5
    80005fb0:	70e2                	ld	ra,56(sp)
    80005fb2:	7442                	ld	s0,48(sp)
    80005fb4:	74a2                	ld	s1,40(sp)
    80005fb6:	6121                	addi	sp,sp,64
    80005fb8:	8082                	ret
    80005fba:	0000                	unimp
    80005fbc:	0000                	unimp
	...

0000000080005fc0 <kernelvec>:
    80005fc0:	7111                	addi	sp,sp,-256
    80005fc2:	e006                	sd	ra,0(sp)
    80005fc4:	e40a                	sd	sp,8(sp)
    80005fc6:	e80e                	sd	gp,16(sp)
    80005fc8:	ec12                	sd	tp,24(sp)
    80005fca:	f016                	sd	t0,32(sp)
    80005fcc:	f41a                	sd	t1,40(sp)
    80005fce:	f81e                	sd	t2,48(sp)
    80005fd0:	fc22                	sd	s0,56(sp)
    80005fd2:	e0a6                	sd	s1,64(sp)
    80005fd4:	e4aa                	sd	a0,72(sp)
    80005fd6:	e8ae                	sd	a1,80(sp)
    80005fd8:	ecb2                	sd	a2,88(sp)
    80005fda:	f0b6                	sd	a3,96(sp)
    80005fdc:	f4ba                	sd	a4,104(sp)
    80005fde:	f8be                	sd	a5,112(sp)
    80005fe0:	fcc2                	sd	a6,120(sp)
    80005fe2:	e146                	sd	a7,128(sp)
    80005fe4:	e54a                	sd	s2,136(sp)
    80005fe6:	e94e                	sd	s3,144(sp)
    80005fe8:	ed52                	sd	s4,152(sp)
    80005fea:	f156                	sd	s5,160(sp)
    80005fec:	f55a                	sd	s6,168(sp)
    80005fee:	f95e                	sd	s7,176(sp)
    80005ff0:	fd62                	sd	s8,184(sp)
    80005ff2:	e1e6                	sd	s9,192(sp)
    80005ff4:	e5ea                	sd	s10,200(sp)
    80005ff6:	e9ee                	sd	s11,208(sp)
    80005ff8:	edf2                	sd	t3,216(sp)
    80005ffa:	f1f6                	sd	t4,224(sp)
    80005ffc:	f5fa                	sd	t5,232(sp)
    80005ffe:	f9fe                	sd	t6,240(sp)
    80006000:	cfffc0ef          	jal	ra,80002cfe <kerneltrap>
    80006004:	6082                	ld	ra,0(sp)
    80006006:	6122                	ld	sp,8(sp)
    80006008:	61c2                	ld	gp,16(sp)
    8000600a:	7282                	ld	t0,32(sp)
    8000600c:	7322                	ld	t1,40(sp)
    8000600e:	73c2                	ld	t2,48(sp)
    80006010:	7462                	ld	s0,56(sp)
    80006012:	6486                	ld	s1,64(sp)
    80006014:	6526                	ld	a0,72(sp)
    80006016:	65c6                	ld	a1,80(sp)
    80006018:	6666                	ld	a2,88(sp)
    8000601a:	7686                	ld	a3,96(sp)
    8000601c:	7726                	ld	a4,104(sp)
    8000601e:	77c6                	ld	a5,112(sp)
    80006020:	7866                	ld	a6,120(sp)
    80006022:	688a                	ld	a7,128(sp)
    80006024:	692a                	ld	s2,136(sp)
    80006026:	69ca                	ld	s3,144(sp)
    80006028:	6a6a                	ld	s4,152(sp)
    8000602a:	7a8a                	ld	s5,160(sp)
    8000602c:	7b2a                	ld	s6,168(sp)
    8000602e:	7bca                	ld	s7,176(sp)
    80006030:	7c6a                	ld	s8,184(sp)
    80006032:	6c8e                	ld	s9,192(sp)
    80006034:	6d2e                	ld	s10,200(sp)
    80006036:	6dce                	ld	s11,208(sp)
    80006038:	6e6e                	ld	t3,216(sp)
    8000603a:	7e8e                	ld	t4,224(sp)
    8000603c:	7f2e                	ld	t5,232(sp)
    8000603e:	7fce                	ld	t6,240(sp)
    80006040:	6111                	addi	sp,sp,256
    80006042:	10200073          	sret
    80006046:	00000013          	nop
    8000604a:	00000013          	nop
    8000604e:	0001                	nop

0000000080006050 <timervec>:
    80006050:	34051573          	csrrw	a0,mscratch,a0
    80006054:	e10c                	sd	a1,0(a0)
    80006056:	e510                	sd	a2,8(a0)
    80006058:	e914                	sd	a3,16(a0)
    8000605a:	6d0c                	ld	a1,24(a0)
    8000605c:	7110                	ld	a2,32(a0)
    8000605e:	6194                	ld	a3,0(a1)
    80006060:	96b2                	add	a3,a3,a2
    80006062:	e194                	sd	a3,0(a1)
    80006064:	4589                	li	a1,2
    80006066:	14459073          	csrw	sip,a1
    8000606a:	6914                	ld	a3,16(a0)
    8000606c:	6510                	ld	a2,8(a0)
    8000606e:	610c                	ld	a1,0(a0)
    80006070:	34051573          	csrrw	a0,mscratch,a0
    80006074:	30200073          	mret
	...

000000008000607a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000607a:	1141                	addi	sp,sp,-16
    8000607c:	e422                	sd	s0,8(sp)
    8000607e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006080:	0c0007b7          	lui	a5,0xc000
    80006084:	4705                	li	a4,1
    80006086:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006088:	c3d8                	sw	a4,4(a5)
}
    8000608a:	6422                	ld	s0,8(sp)
    8000608c:	0141                	addi	sp,sp,16
    8000608e:	8082                	ret

0000000080006090 <plicinithart>:

void
plicinithart(void)
{
    80006090:	1141                	addi	sp,sp,-16
    80006092:	e406                	sd	ra,8(sp)
    80006094:	e022                	sd	s0,0(sp)
    80006096:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006098:	ffffc097          	auipc	ra,0xffffc
    8000609c:	ba8080e7          	jalr	-1112(ra) # 80001c40 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800060a0:	0085171b          	slliw	a4,a0,0x8
    800060a4:	0c0027b7          	lui	a5,0xc002
    800060a8:	97ba                	add	a5,a5,a4
    800060aa:	40200713          	li	a4,1026
    800060ae:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800060b2:	00d5151b          	slliw	a0,a0,0xd
    800060b6:	0c2017b7          	lui	a5,0xc201
    800060ba:	953e                	add	a0,a0,a5
    800060bc:	00052023          	sw	zero,0(a0)
}
    800060c0:	60a2                	ld	ra,8(sp)
    800060c2:	6402                	ld	s0,0(sp)
    800060c4:	0141                	addi	sp,sp,16
    800060c6:	8082                	ret

00000000800060c8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800060c8:	1141                	addi	sp,sp,-16
    800060ca:	e406                	sd	ra,8(sp)
    800060cc:	e022                	sd	s0,0(sp)
    800060ce:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800060d0:	ffffc097          	auipc	ra,0xffffc
    800060d4:	b70080e7          	jalr	-1168(ra) # 80001c40 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800060d8:	00d5179b          	slliw	a5,a0,0xd
    800060dc:	0c201537          	lui	a0,0xc201
    800060e0:	953e                	add	a0,a0,a5
  return irq;
}
    800060e2:	4148                	lw	a0,4(a0)
    800060e4:	60a2                	ld	ra,8(sp)
    800060e6:	6402                	ld	s0,0(sp)
    800060e8:	0141                	addi	sp,sp,16
    800060ea:	8082                	ret

00000000800060ec <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800060ec:	1101                	addi	sp,sp,-32
    800060ee:	ec06                	sd	ra,24(sp)
    800060f0:	e822                	sd	s0,16(sp)
    800060f2:	e426                	sd	s1,8(sp)
    800060f4:	1000                	addi	s0,sp,32
    800060f6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800060f8:	ffffc097          	auipc	ra,0xffffc
    800060fc:	b48080e7          	jalr	-1208(ra) # 80001c40 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006100:	00d5151b          	slliw	a0,a0,0xd
    80006104:	0c2017b7          	lui	a5,0xc201
    80006108:	97aa                	add	a5,a5,a0
    8000610a:	c3c4                	sw	s1,4(a5)
}
    8000610c:	60e2                	ld	ra,24(sp)
    8000610e:	6442                	ld	s0,16(sp)
    80006110:	64a2                	ld	s1,8(sp)
    80006112:	6105                	addi	sp,sp,32
    80006114:	8082                	ret

0000000080006116 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80006116:	1141                	addi	sp,sp,-16
    80006118:	e406                	sd	ra,8(sp)
    8000611a:	e022                	sd	s0,0(sp)
    8000611c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000611e:	479d                	li	a5,7
    80006120:	06a7c963          	blt	a5,a0,80006192 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80006124:	0001d797          	auipc	a5,0x1d
    80006128:	edc78793          	addi	a5,a5,-292 # 80023000 <disk>
    8000612c:	00a78733          	add	a4,a5,a0
    80006130:	6789                	lui	a5,0x2
    80006132:	97ba                	add	a5,a5,a4
    80006134:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80006138:	e7ad                	bnez	a5,800061a2 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000613a:	00451793          	slli	a5,a0,0x4
    8000613e:	0001f717          	auipc	a4,0x1f
    80006142:	ec270713          	addi	a4,a4,-318 # 80025000 <disk+0x2000>
    80006146:	6314                	ld	a3,0(a4)
    80006148:	96be                	add	a3,a3,a5
    8000614a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000614e:	6314                	ld	a3,0(a4)
    80006150:	96be                	add	a3,a3,a5
    80006152:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80006156:	6314                	ld	a3,0(a4)
    80006158:	96be                	add	a3,a3,a5
    8000615a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000615e:	6318                	ld	a4,0(a4)
    80006160:	97ba                	add	a5,a5,a4
    80006162:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80006166:	0001d797          	auipc	a5,0x1d
    8000616a:	e9a78793          	addi	a5,a5,-358 # 80023000 <disk>
    8000616e:	97aa                	add	a5,a5,a0
    80006170:	6509                	lui	a0,0x2
    80006172:	953e                	add	a0,a0,a5
    80006174:	4785                	li	a5,1
    80006176:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000617a:	0001f517          	auipc	a0,0x1f
    8000617e:	e9e50513          	addi	a0,a0,-354 # 80025018 <disk+0x2018>
    80006182:	ffffc097          	auipc	ra,0xffffc
    80006186:	4e6080e7          	jalr	1254(ra) # 80002668 <wakeup>
}
    8000618a:	60a2                	ld	ra,8(sp)
    8000618c:	6402                	ld	s0,0(sp)
    8000618e:	0141                	addi	sp,sp,16
    80006190:	8082                	ret
    panic("free_desc 1");
    80006192:	00002517          	auipc	a0,0x2
    80006196:	6f650513          	addi	a0,a0,1782 # 80008888 <syscalls+0x320>
    8000619a:	ffffa097          	auipc	ra,0xffffa
    8000619e:	432080e7          	jalr	1074(ra) # 800005cc <panic>
    panic("free_desc 2");
    800061a2:	00002517          	auipc	a0,0x2
    800061a6:	6f650513          	addi	a0,a0,1782 # 80008898 <syscalls+0x330>
    800061aa:	ffffa097          	auipc	ra,0xffffa
    800061ae:	422080e7          	jalr	1058(ra) # 800005cc <panic>

00000000800061b2 <virtio_disk_init>:
{
    800061b2:	1101                	addi	sp,sp,-32
    800061b4:	ec06                	sd	ra,24(sp)
    800061b6:	e822                	sd	s0,16(sp)
    800061b8:	e426                	sd	s1,8(sp)
    800061ba:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800061bc:	00002597          	auipc	a1,0x2
    800061c0:	6ec58593          	addi	a1,a1,1772 # 800088a8 <syscalls+0x340>
    800061c4:	0001f517          	auipc	a0,0x1f
    800061c8:	f6450513          	addi	a0,a0,-156 # 80025128 <disk+0x2128>
    800061cc:	ffffb097          	auipc	ra,0xffffb
    800061d0:	9de080e7          	jalr	-1570(ra) # 80000baa <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800061d4:	100017b7          	lui	a5,0x10001
    800061d8:	4398                	lw	a4,0(a5)
    800061da:	2701                	sext.w	a4,a4
    800061dc:	747277b7          	lui	a5,0x74727
    800061e0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800061e4:	0ef71163          	bne	a4,a5,800062c6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800061e8:	100017b7          	lui	a5,0x10001
    800061ec:	43dc                	lw	a5,4(a5)
    800061ee:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800061f0:	4705                	li	a4,1
    800061f2:	0ce79a63          	bne	a5,a4,800062c6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800061f6:	100017b7          	lui	a5,0x10001
    800061fa:	479c                	lw	a5,8(a5)
    800061fc:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800061fe:	4709                	li	a4,2
    80006200:	0ce79363          	bne	a5,a4,800062c6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80006204:	100017b7          	lui	a5,0x10001
    80006208:	47d8                	lw	a4,12(a5)
    8000620a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000620c:	554d47b7          	lui	a5,0x554d4
    80006210:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80006214:	0af71963          	bne	a4,a5,800062c6 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006218:	100017b7          	lui	a5,0x10001
    8000621c:	4705                	li	a4,1
    8000621e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006220:	470d                	li	a4,3
    80006222:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80006224:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80006226:	c7ffe737          	lui	a4,0xc7ffe
    8000622a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd875f>
    8000622e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006230:	2701                	sext.w	a4,a4
    80006232:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006234:	472d                	li	a4,11
    80006236:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006238:	473d                	li	a4,15
    8000623a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000623c:	6705                	lui	a4,0x1
    8000623e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006240:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006244:	5bdc                	lw	a5,52(a5)
    80006246:	2781                	sext.w	a5,a5
  if(max == 0)
    80006248:	c7d9                	beqz	a5,800062d6 <virtio_disk_init+0x124>
  if(max < NUM)
    8000624a:	471d                	li	a4,7
    8000624c:	08f77d63          	bgeu	a4,a5,800062e6 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006250:	100014b7          	lui	s1,0x10001
    80006254:	47a1                	li	a5,8
    80006256:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80006258:	6609                	lui	a2,0x2
    8000625a:	4581                	li	a1,0
    8000625c:	0001d517          	auipc	a0,0x1d
    80006260:	da450513          	addi	a0,a0,-604 # 80023000 <disk>
    80006264:	ffffb097          	auipc	ra,0xffffb
    80006268:	ad2080e7          	jalr	-1326(ra) # 80000d36 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000626c:	0001d717          	auipc	a4,0x1d
    80006270:	d9470713          	addi	a4,a4,-620 # 80023000 <disk>
    80006274:	00c75793          	srli	a5,a4,0xc
    80006278:	2781                	sext.w	a5,a5
    8000627a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000627c:	0001f797          	auipc	a5,0x1f
    80006280:	d8478793          	addi	a5,a5,-636 # 80025000 <disk+0x2000>
    80006284:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80006286:	0001d717          	auipc	a4,0x1d
    8000628a:	dfa70713          	addi	a4,a4,-518 # 80023080 <disk+0x80>
    8000628e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80006290:	0001e717          	auipc	a4,0x1e
    80006294:	d7070713          	addi	a4,a4,-656 # 80024000 <disk+0x1000>
    80006298:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000629a:	4705                	li	a4,1
    8000629c:	00e78c23          	sb	a4,24(a5)
    800062a0:	00e78ca3          	sb	a4,25(a5)
    800062a4:	00e78d23          	sb	a4,26(a5)
    800062a8:	00e78da3          	sb	a4,27(a5)
    800062ac:	00e78e23          	sb	a4,28(a5)
    800062b0:	00e78ea3          	sb	a4,29(a5)
    800062b4:	00e78f23          	sb	a4,30(a5)
    800062b8:	00e78fa3          	sb	a4,31(a5)
}
    800062bc:	60e2                	ld	ra,24(sp)
    800062be:	6442                	ld	s0,16(sp)
    800062c0:	64a2                	ld	s1,8(sp)
    800062c2:	6105                	addi	sp,sp,32
    800062c4:	8082                	ret
    panic("could not find virtio disk");
    800062c6:	00002517          	auipc	a0,0x2
    800062ca:	5f250513          	addi	a0,a0,1522 # 800088b8 <syscalls+0x350>
    800062ce:	ffffa097          	auipc	ra,0xffffa
    800062d2:	2fe080e7          	jalr	766(ra) # 800005cc <panic>
    panic("virtio disk has no queue 0");
    800062d6:	00002517          	auipc	a0,0x2
    800062da:	60250513          	addi	a0,a0,1538 # 800088d8 <syscalls+0x370>
    800062de:	ffffa097          	auipc	ra,0xffffa
    800062e2:	2ee080e7          	jalr	750(ra) # 800005cc <panic>
    panic("virtio disk max queue too short");
    800062e6:	00002517          	auipc	a0,0x2
    800062ea:	61250513          	addi	a0,a0,1554 # 800088f8 <syscalls+0x390>
    800062ee:	ffffa097          	auipc	ra,0xffffa
    800062f2:	2de080e7          	jalr	734(ra) # 800005cc <panic>

00000000800062f6 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800062f6:	7119                	addi	sp,sp,-128
    800062f8:	fc86                	sd	ra,120(sp)
    800062fa:	f8a2                	sd	s0,112(sp)
    800062fc:	f4a6                	sd	s1,104(sp)
    800062fe:	f0ca                	sd	s2,96(sp)
    80006300:	ecce                	sd	s3,88(sp)
    80006302:	e8d2                	sd	s4,80(sp)
    80006304:	e4d6                	sd	s5,72(sp)
    80006306:	e0da                	sd	s6,64(sp)
    80006308:	fc5e                	sd	s7,56(sp)
    8000630a:	f862                	sd	s8,48(sp)
    8000630c:	f466                	sd	s9,40(sp)
    8000630e:	f06a                	sd	s10,32(sp)
    80006310:	ec6e                	sd	s11,24(sp)
    80006312:	0100                	addi	s0,sp,128
    80006314:	8aaa                	mv	s5,a0
    80006316:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006318:	00c52c83          	lw	s9,12(a0)
    8000631c:	001c9c9b          	slliw	s9,s9,0x1
    80006320:	1c82                	slli	s9,s9,0x20
    80006322:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80006326:	0001f517          	auipc	a0,0x1f
    8000632a:	e0250513          	addi	a0,a0,-510 # 80025128 <disk+0x2128>
    8000632e:	ffffb097          	auipc	ra,0xffffb
    80006332:	90c080e7          	jalr	-1780(ra) # 80000c3a <acquire>
  for(int i = 0; i < 3; i++){
    80006336:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80006338:	44a1                	li	s1,8
      disk.free[i] = 0;
    8000633a:	0001dc17          	auipc	s8,0x1d
    8000633e:	cc6c0c13          	addi	s8,s8,-826 # 80023000 <disk>
    80006342:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    80006344:	4b0d                	li	s6,3
    80006346:	a0ad                	j	800063b0 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80006348:	00fc0733          	add	a4,s8,a5
    8000634c:	975e                	add	a4,a4,s7
    8000634e:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80006352:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006354:	0207c563          	bltz	a5,8000637e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80006358:	2905                	addiw	s2,s2,1
    8000635a:	0611                	addi	a2,a2,4
    8000635c:	19690d63          	beq	s2,s6,800064f6 <virtio_disk_rw+0x200>
    idx[i] = alloc_desc();
    80006360:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006362:	0001f717          	auipc	a4,0x1f
    80006366:	cb670713          	addi	a4,a4,-842 # 80025018 <disk+0x2018>
    8000636a:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000636c:	00074683          	lbu	a3,0(a4)
    80006370:	fee1                	bnez	a3,80006348 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80006372:	2785                	addiw	a5,a5,1
    80006374:	0705                	addi	a4,a4,1
    80006376:	fe979be3          	bne	a5,s1,8000636c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000637a:	57fd                	li	a5,-1
    8000637c:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000637e:	01205d63          	blez	s2,80006398 <virtio_disk_rw+0xa2>
    80006382:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80006384:	000a2503          	lw	a0,0(s4)
    80006388:	00000097          	auipc	ra,0x0
    8000638c:	d8e080e7          	jalr	-626(ra) # 80006116 <free_desc>
      for(int j = 0; j < i; j++)
    80006390:	2d85                	addiw	s11,s11,1
    80006392:	0a11                	addi	s4,s4,4
    80006394:	ffb918e3          	bne	s2,s11,80006384 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006398:	0001f597          	auipc	a1,0x1f
    8000639c:	d9058593          	addi	a1,a1,-624 # 80025128 <disk+0x2128>
    800063a0:	0001f517          	auipc	a0,0x1f
    800063a4:	c7850513          	addi	a0,a0,-904 # 80025018 <disk+0x2018>
    800063a8:	ffffc097          	auipc	ra,0xffffc
    800063ac:	134080e7          	jalr	308(ra) # 800024dc <sleep>
  for(int i = 0; i < 3; i++){
    800063b0:	f8040a13          	addi	s4,s0,-128
{
    800063b4:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800063b6:	894e                	mv	s2,s3
    800063b8:	b765                	j	80006360 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800063ba:	0001f697          	auipc	a3,0x1f
    800063be:	c466b683          	ld	a3,-954(a3) # 80025000 <disk+0x2000>
    800063c2:	96ba                	add	a3,a3,a4
    800063c4:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800063c8:	0001d817          	auipc	a6,0x1d
    800063cc:	c3880813          	addi	a6,a6,-968 # 80023000 <disk>
    800063d0:	0001f697          	auipc	a3,0x1f
    800063d4:	c3068693          	addi	a3,a3,-976 # 80025000 <disk+0x2000>
    800063d8:	6290                	ld	a2,0(a3)
    800063da:	963a                	add	a2,a2,a4
    800063dc:	00c65583          	lhu	a1,12(a2) # 200c <_entry-0x7fffdff4>
    800063e0:	0015e593          	ori	a1,a1,1
    800063e4:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    800063e8:	f8842603          	lw	a2,-120(s0)
    800063ec:	628c                	ld	a1,0(a3)
    800063ee:	972e                	add	a4,a4,a1
    800063f0:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800063f4:	20050593          	addi	a1,a0,512
    800063f8:	0592                	slli	a1,a1,0x4
    800063fa:	95c2                	add	a1,a1,a6
    800063fc:	577d                	li	a4,-1
    800063fe:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006402:	00461713          	slli	a4,a2,0x4
    80006406:	6290                	ld	a2,0(a3)
    80006408:	963a                	add	a2,a2,a4
    8000640a:	03078793          	addi	a5,a5,48
    8000640e:	97c2                	add	a5,a5,a6
    80006410:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    80006412:	629c                	ld	a5,0(a3)
    80006414:	97ba                	add	a5,a5,a4
    80006416:	4605                	li	a2,1
    80006418:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000641a:	629c                	ld	a5,0(a3)
    8000641c:	97ba                	add	a5,a5,a4
    8000641e:	4809                	li	a6,2
    80006420:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80006424:	629c                	ld	a5,0(a3)
    80006426:	973e                	add	a4,a4,a5
    80006428:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000642c:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    80006430:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006434:	6698                	ld	a4,8(a3)
    80006436:	00275783          	lhu	a5,2(a4)
    8000643a:	8b9d                	andi	a5,a5,7
    8000643c:	0786                	slli	a5,a5,0x1
    8000643e:	97ba                	add	a5,a5,a4
    80006440:	00a79223          	sh	a0,4(a5)

  __sync_synchronize();
    80006444:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80006448:	6698                	ld	a4,8(a3)
    8000644a:	00275783          	lhu	a5,2(a4)
    8000644e:	2785                	addiw	a5,a5,1
    80006450:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006454:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006458:	100017b7          	lui	a5,0x10001
    8000645c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006460:	004aa783          	lw	a5,4(s5)
    80006464:	02c79163          	bne	a5,a2,80006486 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80006468:	0001f917          	auipc	s2,0x1f
    8000646c:	cc090913          	addi	s2,s2,-832 # 80025128 <disk+0x2128>
  while(b->disk == 1) {
    80006470:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80006472:	85ca                	mv	a1,s2
    80006474:	8556                	mv	a0,s5
    80006476:	ffffc097          	auipc	ra,0xffffc
    8000647a:	066080e7          	jalr	102(ra) # 800024dc <sleep>
  while(b->disk == 1) {
    8000647e:	004aa783          	lw	a5,4(s5)
    80006482:	fe9788e3          	beq	a5,s1,80006472 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80006486:	f8042903          	lw	s2,-128(s0)
    8000648a:	20090793          	addi	a5,s2,512
    8000648e:	00479713          	slli	a4,a5,0x4
    80006492:	0001d797          	auipc	a5,0x1d
    80006496:	b6e78793          	addi	a5,a5,-1170 # 80023000 <disk>
    8000649a:	97ba                	add	a5,a5,a4
    8000649c:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800064a0:	0001f997          	auipc	s3,0x1f
    800064a4:	b6098993          	addi	s3,s3,-1184 # 80025000 <disk+0x2000>
    800064a8:	00491713          	slli	a4,s2,0x4
    800064ac:	0009b783          	ld	a5,0(s3)
    800064b0:	97ba                	add	a5,a5,a4
    800064b2:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800064b6:	854a                	mv	a0,s2
    800064b8:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800064bc:	00000097          	auipc	ra,0x0
    800064c0:	c5a080e7          	jalr	-934(ra) # 80006116 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800064c4:	8885                	andi	s1,s1,1
    800064c6:	f0ed                	bnez	s1,800064a8 <virtio_disk_rw+0x1b2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800064c8:	0001f517          	auipc	a0,0x1f
    800064cc:	c6050513          	addi	a0,a0,-928 # 80025128 <disk+0x2128>
    800064d0:	ffffb097          	auipc	ra,0xffffb
    800064d4:	81e080e7          	jalr	-2018(ra) # 80000cee <release>
}
    800064d8:	70e6                	ld	ra,120(sp)
    800064da:	7446                	ld	s0,112(sp)
    800064dc:	74a6                	ld	s1,104(sp)
    800064de:	7906                	ld	s2,96(sp)
    800064e0:	69e6                	ld	s3,88(sp)
    800064e2:	6a46                	ld	s4,80(sp)
    800064e4:	6aa6                	ld	s5,72(sp)
    800064e6:	6b06                	ld	s6,64(sp)
    800064e8:	7be2                	ld	s7,56(sp)
    800064ea:	7c42                	ld	s8,48(sp)
    800064ec:	7ca2                	ld	s9,40(sp)
    800064ee:	7d02                	ld	s10,32(sp)
    800064f0:	6de2                	ld	s11,24(sp)
    800064f2:	6109                	addi	sp,sp,128
    800064f4:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800064f6:	f8042503          	lw	a0,-128(s0)
    800064fa:	20050793          	addi	a5,a0,512
    800064fe:	0792                	slli	a5,a5,0x4
  if(write)
    80006500:	0001d817          	auipc	a6,0x1d
    80006504:	b0080813          	addi	a6,a6,-1280 # 80023000 <disk>
    80006508:	00f80733          	add	a4,a6,a5
    8000650c:	01a036b3          	snez	a3,s10
    80006510:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    80006514:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80006518:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000651c:	7679                	lui	a2,0xffffe
    8000651e:	963e                	add	a2,a2,a5
    80006520:	0001f697          	auipc	a3,0x1f
    80006524:	ae068693          	addi	a3,a3,-1312 # 80025000 <disk+0x2000>
    80006528:	6298                	ld	a4,0(a3)
    8000652a:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000652c:	0a878593          	addi	a1,a5,168
    80006530:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006532:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80006534:	6298                	ld	a4,0(a3)
    80006536:	9732                	add	a4,a4,a2
    80006538:	45c1                	li	a1,16
    8000653a:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000653c:	6298                	ld	a4,0(a3)
    8000653e:	9732                	add	a4,a4,a2
    80006540:	4585                	li	a1,1
    80006542:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80006546:	f8442703          	lw	a4,-124(s0)
    8000654a:	628c                	ld	a1,0(a3)
    8000654c:	962e                	add	a2,a2,a1
    8000654e:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd800e>
  disk.desc[idx[1]].addr = (uint64) b->data;
    80006552:	0712                	slli	a4,a4,0x4
    80006554:	6290                	ld	a2,0(a3)
    80006556:	963a                	add	a2,a2,a4
    80006558:	058a8593          	addi	a1,s5,88
    8000655c:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    8000655e:	6294                	ld	a3,0(a3)
    80006560:	96ba                	add	a3,a3,a4
    80006562:	40000613          	li	a2,1024
    80006566:	c690                	sw	a2,8(a3)
  if(write)
    80006568:	e40d19e3          	bnez	s10,800063ba <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000656c:	0001f697          	auipc	a3,0x1f
    80006570:	a946b683          	ld	a3,-1388(a3) # 80025000 <disk+0x2000>
    80006574:	96ba                	add	a3,a3,a4
    80006576:	4609                	li	a2,2
    80006578:	00c69623          	sh	a2,12(a3)
    8000657c:	b5b1                	j	800063c8 <virtio_disk_rw+0xd2>

000000008000657e <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000657e:	1101                	addi	sp,sp,-32
    80006580:	ec06                	sd	ra,24(sp)
    80006582:	e822                	sd	s0,16(sp)
    80006584:	e426                	sd	s1,8(sp)
    80006586:	e04a                	sd	s2,0(sp)
    80006588:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000658a:	0001f517          	auipc	a0,0x1f
    8000658e:	b9e50513          	addi	a0,a0,-1122 # 80025128 <disk+0x2128>
    80006592:	ffffa097          	auipc	ra,0xffffa
    80006596:	6a8080e7          	jalr	1704(ra) # 80000c3a <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000659a:	10001737          	lui	a4,0x10001
    8000659e:	533c                	lw	a5,96(a4)
    800065a0:	8b8d                	andi	a5,a5,3
    800065a2:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800065a4:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800065a8:	0001f797          	auipc	a5,0x1f
    800065ac:	a5878793          	addi	a5,a5,-1448 # 80025000 <disk+0x2000>
    800065b0:	6b94                	ld	a3,16(a5)
    800065b2:	0207d703          	lhu	a4,32(a5)
    800065b6:	0026d783          	lhu	a5,2(a3)
    800065ba:	06f70163          	beq	a4,a5,8000661c <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800065be:	0001d917          	auipc	s2,0x1d
    800065c2:	a4290913          	addi	s2,s2,-1470 # 80023000 <disk>
    800065c6:	0001f497          	auipc	s1,0x1f
    800065ca:	a3a48493          	addi	s1,s1,-1478 # 80025000 <disk+0x2000>
    __sync_synchronize();
    800065ce:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800065d2:	6898                	ld	a4,16(s1)
    800065d4:	0204d783          	lhu	a5,32(s1)
    800065d8:	8b9d                	andi	a5,a5,7
    800065da:	078e                	slli	a5,a5,0x3
    800065dc:	97ba                	add	a5,a5,a4
    800065de:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800065e0:	20078713          	addi	a4,a5,512
    800065e4:	0712                	slli	a4,a4,0x4
    800065e6:	974a                	add	a4,a4,s2
    800065e8:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800065ec:	e731                	bnez	a4,80006638 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800065ee:	20078793          	addi	a5,a5,512
    800065f2:	0792                	slli	a5,a5,0x4
    800065f4:	97ca                	add	a5,a5,s2
    800065f6:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800065f8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800065fc:	ffffc097          	auipc	ra,0xffffc
    80006600:	06c080e7          	jalr	108(ra) # 80002668 <wakeup>

    disk.used_idx += 1;
    80006604:	0204d783          	lhu	a5,32(s1)
    80006608:	2785                	addiw	a5,a5,1
    8000660a:	17c2                	slli	a5,a5,0x30
    8000660c:	93c1                	srli	a5,a5,0x30
    8000660e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006612:	6898                	ld	a4,16(s1)
    80006614:	00275703          	lhu	a4,2(a4)
    80006618:	faf71be3          	bne	a4,a5,800065ce <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000661c:	0001f517          	auipc	a0,0x1f
    80006620:	b0c50513          	addi	a0,a0,-1268 # 80025128 <disk+0x2128>
    80006624:	ffffa097          	auipc	ra,0xffffa
    80006628:	6ca080e7          	jalr	1738(ra) # 80000cee <release>
}
    8000662c:	60e2                	ld	ra,24(sp)
    8000662e:	6442                	ld	s0,16(sp)
    80006630:	64a2                	ld	s1,8(sp)
    80006632:	6902                	ld	s2,0(sp)
    80006634:	6105                	addi	sp,sp,32
    80006636:	8082                	ret
      panic("virtio_disk_intr status");
    80006638:	00002517          	auipc	a0,0x2
    8000663c:	2e050513          	addi	a0,a0,736 # 80008918 <syscalls+0x3b0>
    80006640:	ffffa097          	auipc	ra,0xffffa
    80006644:	f8c080e7          	jalr	-116(ra) # 800005cc <panic>
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
