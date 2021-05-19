
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
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
#pragma once
#include "types.h"
// which hart (core) is this?
static inline uint64 r_mhartid() {
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r"(x));
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80000026:	0037969b          	slliw	a3,a5,0x3
    8000002a:	02004737          	lui	a4,0x2004
    8000002e:	96ba                	add	a3,a3,a4
    80000030:	0200c737          	lui	a4,0x200c
    80000034:	ff873603          	ld	a2,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80000038:	000f4737          	lui	a4,0xf4
    8000003c:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000040:	963a                	add	a2,a2,a4
    80000042:	e290                	sd	a2,0(a3)

  // prepare information in scratch[] for timervec.
  // scratch[0..3] : space for timervec to save registers.
  // scratch[4] : address of CLINT MTIMECMP register.
  // scratch[5] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &mscratch0[32 * id];
    80000044:	0057979b          	slliw	a5,a5,0x5
    80000048:	078e                	slli	a5,a5,0x3
    8000004a:	00009617          	auipc	a2,0x9
    8000004e:	ff660613          	addi	a2,a2,-10 # 80009040 <mscratch0>
    80000052:	97b2                	add	a5,a5,a2
  scratch[4] = CLINT_MTIMECMP(id);
    80000054:	f394                	sd	a3,32(a5)
  scratch[5] = interval;
    80000056:	f798                	sd	a4,40(a5)
static inline void w_sscratch(uint64 x) {
  asm volatile("csrw sscratch, %0" : : "r"(x));
}

static inline void w_mscratch(uint64 x) {
  asm volatile("csrw mscratch, %0" : : "r"(x));
    80000058:	34079073          	csrw	mscratch,a5
  asm volatile("csrw mtvec, %0" : : "r"(x));
    8000005c:	00006797          	auipc	a5,0x6
    80000060:	eb478793          	addi	a5,a5,-332 # 80005f10 <timervec>
    80000064:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r"(x));
    80000068:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000006c:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r"(x));
    80000070:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r"(x));
    80000074:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000078:	0807e793          	ori	a5,a5,128
static inline void w_mie(uint64 x) { asm volatile("csrw mie, %0" : : "r"(x)); }
    8000007c:	30479073          	csrw	mie,a5
}
    80000080:	6422                	ld	s0,8(sp)
    80000082:	0141                	addi	sp,sp,16
    80000084:	8082                	ret

0000000080000086 <start>:
{
    80000086:	1141                	addi	sp,sp,-16
    80000088:	e406                	sd	ra,8(sp)
    8000008a:	e022                	sd	s0,0(sp)
    8000008c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r"(x));
    8000008e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000092:	7779                	lui	a4,0xffffe
    80000094:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffb87ff>
    80000098:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000009a:	6705                	lui	a4,0x1
    8000009c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r"(x));
    800000a2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r"(x));
    800000a6:	00001797          	auipc	a5,0x1
    800000aa:	f3e78793          	addi	a5,a5,-194 # 80000fe4 <main>
    800000ae:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r"(x));
    800000b2:	4781                	li	a5,0
    800000b4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r"(x));
    800000b8:	67c1                	lui	a5,0x10
    800000ba:	17fd                	addi	a5,a5,-1
    800000bc:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r"(x));
    800000c0:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r"(x));
    800000c4:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000c8:	2227e793          	ori	a5,a5,546
static inline void w_sie(uint64 x) { asm volatile("csrw sie, %0" : : "r"(x)); }
    800000cc:	10479073          	csrw	sie,a5
  timerinit();
    800000d0:	00000097          	auipc	ra,0x0
    800000d4:	f4c080e7          	jalr	-180(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r"(x));
    800000d8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000dc:	2781                	sext.w	a5,a5
  uint64 x;
  asm volatile("mv %0, tp" : "=r"(x));
  return x;
}

static inline void w_tp(uint64 x) { asm volatile("mv tp, %0" : : "r"(x)); }
    800000de:	823e                	mv	tp,a5
  asm volatile("mret");
    800000e0:	30200073          	mret
}
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
    80000110:	c2e080e7          	jalr	-978(ra) # 80000d3a <acquire>
  for(i = 0; i < n; i++){
    80000114:	05305b63          	blez	s3,8000016a <consolewrite+0x7e>
    80000118:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000011a:	5afd                	li	s5,-1
    8000011c:	4685                	li	a3,1
    8000011e:	8626                	mv	a2,s1
    80000120:	85d2                	mv	a1,s4
    80000122:	fbf40513          	addi	a0,s0,-65
    80000126:	00002097          	auipc	ra,0x2
    8000012a:	604080e7          	jalr	1540(ra) # 8000272a <either_copyin>
    8000012e:	01550c63          	beq	a0,s5,80000146 <consolewrite+0x5a>
      break;
    uartputc(c);
    80000132:	fbf44503          	lbu	a0,-65(s0)
    80000136:	00001097          	auipc	ra,0x1
    8000013a:	80e080e7          	jalr	-2034(ra) # 80000944 <uartputc>
  for(i = 0; i < n; i++){
    8000013e:	2905                	addiw	s2,s2,1
    80000140:	0485                	addi	s1,s1,1
    80000142:	fd299de3          	bne	s3,s2,8000011c <consolewrite+0x30>
  }
  release(&cons.lock);
    80000146:	00011517          	auipc	a0,0x11
    8000014a:	6fa50513          	addi	a0,a0,1786 # 80011840 <cons>
    8000014e:	00001097          	auipc	ra,0x1
    80000152:	ca0080e7          	jalr	-864(ra) # 80000dee <release>

  return i;
}
    80000156:	854a                	mv	a0,s2
    80000158:	60a6                	ld	ra,72(sp)
    8000015a:	6406                	ld	s0,64(sp)
    8000015c:	74e2                	ld	s1,56(sp)
    8000015e:	7942                	ld	s2,48(sp)
    80000160:	79a2                	ld	s3,40(sp)
    80000162:	7a02                	ld	s4,32(sp)
    80000164:	6ae2                	ld	s5,24(sp)
    80000166:	6161                	addi	sp,sp,80
    80000168:	8082                	ret
  for(i = 0; i < n; i++){
    8000016a:	4901                	li	s2,0
    8000016c:	bfe9                	j	80000146 <consolewrite+0x5a>

000000008000016e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000016e:	7159                	addi	sp,sp,-112
    80000170:	f486                	sd	ra,104(sp)
    80000172:	f0a2                	sd	s0,96(sp)
    80000174:	eca6                	sd	s1,88(sp)
    80000176:	e8ca                	sd	s2,80(sp)
    80000178:	e4ce                	sd	s3,72(sp)
    8000017a:	e0d2                	sd	s4,64(sp)
    8000017c:	fc56                	sd	s5,56(sp)
    8000017e:	f85a                	sd	s6,48(sp)
    80000180:	f45e                	sd	s7,40(sp)
    80000182:	f062                	sd	s8,32(sp)
    80000184:	ec66                	sd	s9,24(sp)
    80000186:	e86a                	sd	s10,16(sp)
    80000188:	1880                	addi	s0,sp,112
    8000018a:	8aaa                	mv	s5,a0
    8000018c:	8a2e                	mv	s4,a1
    8000018e:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000190:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000194:	00011517          	auipc	a0,0x11
    80000198:	6ac50513          	addi	a0,a0,1708 # 80011840 <cons>
    8000019c:	00001097          	auipc	ra,0x1
    800001a0:	b9e080e7          	jalr	-1122(ra) # 80000d3a <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800001a4:	00011497          	auipc	s1,0x11
    800001a8:	69c48493          	addi	s1,s1,1692 # 80011840 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001ac:	00011917          	auipc	s2,0x11
    800001b0:	72c90913          	addi	s2,s2,1836 # 800118d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800001b4:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001b6:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001b8:	4ca9                	li	s9,10
  while(n > 0){
    800001ba:	07305863          	blez	s3,8000022a <consoleread+0xbc>
    while(cons.r == cons.w){
    800001be:	0984a783          	lw	a5,152(s1)
    800001c2:	09c4a703          	lw	a4,156(s1)
    800001c6:	02f71463          	bne	a4,a5,800001ee <consoleread+0x80>
      if(myproc()->killed){
    800001ca:	00002097          	auipc	ra,0x2
    800001ce:	a9c080e7          	jalr	-1380(ra) # 80001c66 <myproc>
    800001d2:	591c                	lw	a5,48(a0)
    800001d4:	e7b5                	bnez	a5,80000240 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    800001d6:	85a6                	mv	a1,s1
    800001d8:	854a                	mv	a0,s2
    800001da:	00002097          	auipc	ra,0x2
    800001de:	2a0080e7          	jalr	672(ra) # 8000247a <sleep>
    while(cons.r == cons.w){
    800001e2:	0984a783          	lw	a5,152(s1)
    800001e6:	09c4a703          	lw	a4,156(s1)
    800001ea:	fef700e3          	beq	a4,a5,800001ca <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800001ee:	0017871b          	addiw	a4,a5,1
    800001f2:	08e4ac23          	sw	a4,152(s1)
    800001f6:	07f7f713          	andi	a4,a5,127
    800001fa:	9726                	add	a4,a4,s1
    800001fc:	01874703          	lbu	a4,24(a4)
    80000200:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80000204:	077d0563          	beq	s10,s7,8000026e <consoleread+0x100>
    cbuf = c;
    80000208:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000020c:	4685                	li	a3,1
    8000020e:	f9f40613          	addi	a2,s0,-97
    80000212:	85d2                	mv	a1,s4
    80000214:	8556                	mv	a0,s5
    80000216:	00002097          	auipc	ra,0x2
    8000021a:	4be080e7          	jalr	1214(ra) # 800026d4 <either_copyout>
    8000021e:	01850663          	beq	a0,s8,8000022a <consoleread+0xbc>
    dst++;
    80000222:	0a05                	addi	s4,s4,1
    --n;
    80000224:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80000226:	f99d1ae3          	bne	s10,s9,800001ba <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    8000022a:	00011517          	auipc	a0,0x11
    8000022e:	61650513          	addi	a0,a0,1558 # 80011840 <cons>
    80000232:	00001097          	auipc	ra,0x1
    80000236:	bbc080e7          	jalr	-1092(ra) # 80000dee <release>

  return target - n;
    8000023a:	413b053b          	subw	a0,s6,s3
    8000023e:	a811                	j	80000252 <consoleread+0xe4>
        release(&cons.lock);
    80000240:	00011517          	auipc	a0,0x11
    80000244:	60050513          	addi	a0,a0,1536 # 80011840 <cons>
    80000248:	00001097          	auipc	ra,0x1
    8000024c:	ba6080e7          	jalr	-1114(ra) # 80000dee <release>
        return -1;
    80000250:	557d                	li	a0,-1
}
    80000252:	70a6                	ld	ra,104(sp)
    80000254:	7406                	ld	s0,96(sp)
    80000256:	64e6                	ld	s1,88(sp)
    80000258:	6946                	ld	s2,80(sp)
    8000025a:	69a6                	ld	s3,72(sp)
    8000025c:	6a06                	ld	s4,64(sp)
    8000025e:	7ae2                	ld	s5,56(sp)
    80000260:	7b42                	ld	s6,48(sp)
    80000262:	7ba2                	ld	s7,40(sp)
    80000264:	7c02                	ld	s8,32(sp)
    80000266:	6ce2                	ld	s9,24(sp)
    80000268:	6d42                	ld	s10,16(sp)
    8000026a:	6165                	addi	sp,sp,112
    8000026c:	8082                	ret
      if(n < target){
    8000026e:	0009871b          	sext.w	a4,s3
    80000272:	fb677ce3          	bgeu	a4,s6,8000022a <consoleread+0xbc>
        cons.r--;
    80000276:	00011717          	auipc	a4,0x11
    8000027a:	66f72123          	sw	a5,1634(a4) # 800118d8 <cons+0x98>
    8000027e:	b775                	j	8000022a <consoleread+0xbc>

0000000080000280 <consputc>:
{
    80000280:	1141                	addi	sp,sp,-16
    80000282:	e406                	sd	ra,8(sp)
    80000284:	e022                	sd	s0,0(sp)
    80000286:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000288:	10000793          	li	a5,256
    8000028c:	00f50a63          	beq	a0,a5,800002a0 <consputc+0x20>
    uartputc_sync(c);
    80000290:	00000097          	auipc	ra,0x0
    80000294:	5d6080e7          	jalr	1494(ra) # 80000866 <uartputc_sync>
}
    80000298:	60a2                	ld	ra,8(sp)
    8000029a:	6402                	ld	s0,0(sp)
    8000029c:	0141                	addi	sp,sp,16
    8000029e:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800002a0:	4521                	li	a0,8
    800002a2:	00000097          	auipc	ra,0x0
    800002a6:	5c4080e7          	jalr	1476(ra) # 80000866 <uartputc_sync>
    800002aa:	02000513          	li	a0,32
    800002ae:	00000097          	auipc	ra,0x0
    800002b2:	5b8080e7          	jalr	1464(ra) # 80000866 <uartputc_sync>
    800002b6:	4521                	li	a0,8
    800002b8:	00000097          	auipc	ra,0x0
    800002bc:	5ae080e7          	jalr	1454(ra) # 80000866 <uartputc_sync>
    800002c0:	bfe1                	j	80000298 <consputc+0x18>

00000000800002c2 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002c2:	1101                	addi	sp,sp,-32
    800002c4:	ec06                	sd	ra,24(sp)
    800002c6:	e822                	sd	s0,16(sp)
    800002c8:	e426                	sd	s1,8(sp)
    800002ca:	e04a                	sd	s2,0(sp)
    800002cc:	1000                	addi	s0,sp,32
    800002ce:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002d0:	00011517          	auipc	a0,0x11
    800002d4:	57050513          	addi	a0,a0,1392 # 80011840 <cons>
    800002d8:	00001097          	auipc	ra,0x1
    800002dc:	a62080e7          	jalr	-1438(ra) # 80000d3a <acquire>

  switch(c){
    800002e0:	47d5                	li	a5,21
    800002e2:	0af48663          	beq	s1,a5,8000038e <consoleintr+0xcc>
    800002e6:	0297ca63          	blt	a5,s1,8000031a <consoleintr+0x58>
    800002ea:	47a1                	li	a5,8
    800002ec:	0ef48763          	beq	s1,a5,800003da <consoleintr+0x118>
    800002f0:	47c1                	li	a5,16
    800002f2:	10f49a63          	bne	s1,a5,80000406 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002f6:	00002097          	auipc	ra,0x2
    800002fa:	48a080e7          	jalr	1162(ra) # 80002780 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002fe:	00011517          	auipc	a0,0x11
    80000302:	54250513          	addi	a0,a0,1346 # 80011840 <cons>
    80000306:	00001097          	auipc	ra,0x1
    8000030a:	ae8080e7          	jalr	-1304(ra) # 80000dee <release>
}
    8000030e:	60e2                	ld	ra,24(sp)
    80000310:	6442                	ld	s0,16(sp)
    80000312:	64a2                	ld	s1,8(sp)
    80000314:	6902                	ld	s2,0(sp)
    80000316:	6105                	addi	sp,sp,32
    80000318:	8082                	ret
  switch(c){
    8000031a:	07f00793          	li	a5,127
    8000031e:	0af48e63          	beq	s1,a5,800003da <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000322:	00011717          	auipc	a4,0x11
    80000326:	51e70713          	addi	a4,a4,1310 # 80011840 <cons>
    8000032a:	0a072783          	lw	a5,160(a4)
    8000032e:	09872703          	lw	a4,152(a4)
    80000332:	9f99                	subw	a5,a5,a4
    80000334:	07f00713          	li	a4,127
    80000338:	fcf763e3          	bltu	a4,a5,800002fe <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    8000033c:	47b5                	li	a5,13
    8000033e:	0cf48763          	beq	s1,a5,8000040c <consoleintr+0x14a>
      consputc(c);
    80000342:	8526                	mv	a0,s1
    80000344:	00000097          	auipc	ra,0x0
    80000348:	f3c080e7          	jalr	-196(ra) # 80000280 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    8000034c:	00011797          	auipc	a5,0x11
    80000350:	4f478793          	addi	a5,a5,1268 # 80011840 <cons>
    80000354:	0a07a703          	lw	a4,160(a5)
    80000358:	0017069b          	addiw	a3,a4,1
    8000035c:	0006861b          	sext.w	a2,a3
    80000360:	0ad7a023          	sw	a3,160(a5)
    80000364:	07f77713          	andi	a4,a4,127
    80000368:	97ba                	add	a5,a5,a4
    8000036a:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    8000036e:	47a9                	li	a5,10
    80000370:	0cf48563          	beq	s1,a5,8000043a <consoleintr+0x178>
    80000374:	4791                	li	a5,4
    80000376:	0cf48263          	beq	s1,a5,8000043a <consoleintr+0x178>
    8000037a:	00011797          	auipc	a5,0x11
    8000037e:	55e7a783          	lw	a5,1374(a5) # 800118d8 <cons+0x98>
    80000382:	0807879b          	addiw	a5,a5,128
    80000386:	f6f61ce3          	bne	a2,a5,800002fe <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    8000038a:	863e                	mv	a2,a5
    8000038c:	a07d                	j	8000043a <consoleintr+0x178>
    while(cons.e != cons.w &&
    8000038e:	00011717          	auipc	a4,0x11
    80000392:	4b270713          	addi	a4,a4,1202 # 80011840 <cons>
    80000396:	0a072783          	lw	a5,160(a4)
    8000039a:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    8000039e:	00011497          	auipc	s1,0x11
    800003a2:	4a248493          	addi	s1,s1,1186 # 80011840 <cons>
    while(cons.e != cons.w &&
    800003a6:	4929                	li	s2,10
    800003a8:	f4f70be3          	beq	a4,a5,800002fe <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003ac:	37fd                	addiw	a5,a5,-1
    800003ae:	07f7f713          	andi	a4,a5,127
    800003b2:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003b4:	01874703          	lbu	a4,24(a4)
    800003b8:	f52703e3          	beq	a4,s2,800002fe <consoleintr+0x3c>
      cons.e--;
    800003bc:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003c0:	10000513          	li	a0,256
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	ebc080e7          	jalr	-324(ra) # 80000280 <consputc>
    while(cons.e != cons.w &&
    800003cc:	0a04a783          	lw	a5,160(s1)
    800003d0:	09c4a703          	lw	a4,156(s1)
    800003d4:	fcf71ce3          	bne	a4,a5,800003ac <consoleintr+0xea>
    800003d8:	b71d                	j	800002fe <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003da:	00011717          	auipc	a4,0x11
    800003de:	46670713          	addi	a4,a4,1126 # 80011840 <cons>
    800003e2:	0a072783          	lw	a5,160(a4)
    800003e6:	09c72703          	lw	a4,156(a4)
    800003ea:	f0f70ae3          	beq	a4,a5,800002fe <consoleintr+0x3c>
      cons.e--;
    800003ee:	37fd                	addiw	a5,a5,-1
    800003f0:	00011717          	auipc	a4,0x11
    800003f4:	4ef72823          	sw	a5,1264(a4) # 800118e0 <cons+0xa0>
      consputc(BACKSPACE);
    800003f8:	10000513          	li	a0,256
    800003fc:	00000097          	auipc	ra,0x0
    80000400:	e84080e7          	jalr	-380(ra) # 80000280 <consputc>
    80000404:	bded                	j	800002fe <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000406:	ee048ce3          	beqz	s1,800002fe <consoleintr+0x3c>
    8000040a:	bf21                	j	80000322 <consoleintr+0x60>
      consputc(c);
    8000040c:	4529                	li	a0,10
    8000040e:	00000097          	auipc	ra,0x0
    80000412:	e72080e7          	jalr	-398(ra) # 80000280 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000416:	00011797          	auipc	a5,0x11
    8000041a:	42a78793          	addi	a5,a5,1066 # 80011840 <cons>
    8000041e:	0a07a703          	lw	a4,160(a5)
    80000422:	0017069b          	addiw	a3,a4,1
    80000426:	0006861b          	sext.w	a2,a3
    8000042a:	0ad7a023          	sw	a3,160(a5)
    8000042e:	07f77713          	andi	a4,a4,127
    80000432:	97ba                	add	a5,a5,a4
    80000434:	4729                	li	a4,10
    80000436:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000043a:	00011797          	auipc	a5,0x11
    8000043e:	4ac7a123          	sw	a2,1186(a5) # 800118dc <cons+0x9c>
        wakeup(&cons.r);
    80000442:	00011517          	auipc	a0,0x11
    80000446:	49650513          	addi	a0,a0,1174 # 800118d8 <cons+0x98>
    8000044a:	00002097          	auipc	ra,0x2
    8000044e:	1b0080e7          	jalr	432(ra) # 800025fa <wakeup>
    80000452:	b575                	j	800002fe <consoleintr+0x3c>

0000000080000454 <consoleinit>:

void
consoleinit(void)
{
    80000454:	1141                	addi	sp,sp,-16
    80000456:	e406                	sd	ra,8(sp)
    80000458:	e022                	sd	s0,0(sp)
    8000045a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000045c:	00008597          	auipc	a1,0x8
    80000460:	bb458593          	addi	a1,a1,-1100 # 80008010 <etext+0x10>
    80000464:	00011517          	auipc	a0,0x11
    80000468:	3dc50513          	addi	a0,a0,988 # 80011840 <cons>
    8000046c:	00001097          	auipc	ra,0x1
    80000470:	83e080e7          	jalr	-1986(ra) # 80000caa <initlock>

  uartinit();
    80000474:	00000097          	auipc	ra,0x0
    80000478:	3a2080e7          	jalr	930(ra) # 80000816 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000047c:	00041797          	auipc	a5,0x41
    80000480:	54478793          	addi	a5,a5,1348 # 800419c0 <devsw>
    80000484:	00000717          	auipc	a4,0x0
    80000488:	cea70713          	addi	a4,a4,-790 # 8000016e <consoleread>
    8000048c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000048e:	00000717          	auipc	a4,0x0
    80000492:	c5e70713          	addi	a4,a4,-930 # 800000ec <consolewrite>
    80000496:	ef98                	sd	a4,24(a5)
}
    80000498:	60a2                	ld	ra,8(sp)
    8000049a:	6402                	ld	s0,0(sp)
    8000049c:	0141                	addi	sp,sp,16
    8000049e:	8082                	ret

00000000800004a0 <printint>:
  int locking;
} pr;

static char digits[] = "0123456789abcdef";

static void printint(int xx, int base, int sign) {
    800004a0:	7179                	addi	sp,sp,-48
    800004a2:	f406                	sd	ra,40(sp)
    800004a4:	f022                	sd	s0,32(sp)
    800004a6:	ec26                	sd	s1,24(sp)
    800004a8:	e84a                	sd	s2,16(sp)
    800004aa:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if (sign && (sign = xx < 0))
    800004ac:	c219                	beqz	a2,800004b2 <printint+0x12>
    800004ae:	08054663          	bltz	a0,8000053a <printint+0x9a>
    x = -xx;
  else
    x = xx;
    800004b2:	2501                	sext.w	a0,a0
    800004b4:	4881                	li	a7,0
    800004b6:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004ba:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004bc:	2581                	sext.w	a1,a1
    800004be:	00008617          	auipc	a2,0x8
    800004c2:	baa60613          	addi	a2,a2,-1110 # 80008068 <digits>
    800004c6:	883a                	mv	a6,a4
    800004c8:	2705                	addiw	a4,a4,1
    800004ca:	02b577bb          	remuw	a5,a0,a1
    800004ce:	1782                	slli	a5,a5,0x20
    800004d0:	9381                	srli	a5,a5,0x20
    800004d2:	97b2                	add	a5,a5,a2
    800004d4:	0007c783          	lbu	a5,0(a5)
    800004d8:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    800004dc:	0005079b          	sext.w	a5,a0
    800004e0:	02b5553b          	divuw	a0,a0,a1
    800004e4:	0685                	addi	a3,a3,1
    800004e6:	feb7f0e3          	bgeu	a5,a1,800004c6 <printint+0x26>

  if (sign)
    800004ea:	00088b63          	beqz	a7,80000500 <printint+0x60>
    buf[i++] = '-';
    800004ee:	fe040793          	addi	a5,s0,-32
    800004f2:	973e                	add	a4,a4,a5
    800004f4:	02d00793          	li	a5,45
    800004f8:	fef70823          	sb	a5,-16(a4)
    800004fc:	0028071b          	addiw	a4,a6,2

  while (--i >= 0)
    80000500:	02e05763          	blez	a4,8000052e <printint+0x8e>
    80000504:	fd040793          	addi	a5,s0,-48
    80000508:	00e784b3          	add	s1,a5,a4
    8000050c:	fff78913          	addi	s2,a5,-1
    80000510:	993a                	add	s2,s2,a4
    80000512:	377d                	addiw	a4,a4,-1
    80000514:	1702                	slli	a4,a4,0x20
    80000516:	9301                	srli	a4,a4,0x20
    80000518:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000051c:	fff4c503          	lbu	a0,-1(s1)
    80000520:	00000097          	auipc	ra,0x0
    80000524:	d60080e7          	jalr	-672(ra) # 80000280 <consputc>
  while (--i >= 0)
    80000528:	14fd                	addi	s1,s1,-1
    8000052a:	ff2499e3          	bne	s1,s2,8000051c <printint+0x7c>
}
    8000052e:	70a2                	ld	ra,40(sp)
    80000530:	7402                	ld	s0,32(sp)
    80000532:	64e2                	ld	s1,24(sp)
    80000534:	6942                	ld	s2,16(sp)
    80000536:	6145                	addi	sp,sp,48
    80000538:	8082                	ret
    x = -xx;
    8000053a:	40a0053b          	negw	a0,a0
  if (sign && (sign = xx < 0))
    8000053e:	4885                	li	a7,1
    x = -xx;
    80000540:	bf9d                	j	800004b6 <printint+0x16>

0000000080000542 <printfinit>:
  panicked = 1; // freeze uart output from other CPUs
  for (;;)
    ;
}

void printfinit(void) {
    80000542:	1101                	addi	sp,sp,-32
    80000544:	ec06                	sd	ra,24(sp)
    80000546:	e822                	sd	s0,16(sp)
    80000548:	e426                	sd	s1,8(sp)
    8000054a:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000054c:	00011497          	auipc	s1,0x11
    80000550:	39c48493          	addi	s1,s1,924 # 800118e8 <pr>
    80000554:	00008597          	auipc	a1,0x8
    80000558:	ac458593          	addi	a1,a1,-1340 # 80008018 <etext+0x18>
    8000055c:	8526                	mv	a0,s1
    8000055e:	00000097          	auipc	ra,0x0
    80000562:	74c080e7          	jalr	1868(ra) # 80000caa <initlock>
  pr.locking = 1;
    80000566:	4785                	li	a5,1
    80000568:	cc9c                	sw	a5,24(s1)
}
    8000056a:	60e2                	ld	ra,24(sp)
    8000056c:	6442                	ld	s0,16(sp)
    8000056e:	64a2                	ld	s1,8(sp)
    80000570:	6105                	addi	sp,sp,32
    80000572:	8082                	ret

0000000080000574 <backtrace>:

void backtrace() {
    80000574:	7179                	addi	sp,sp,-48
    80000576:	f406                	sd	ra,40(sp)
    80000578:	f022                	sd	s0,32(sp)
    8000057a:	ec26                	sd	s1,24(sp)
    8000057c:	e84a                	sd	s2,16(sp)
    8000057e:	e44e                	sd	s3,8(sp)
    80000580:	e052                	sd	s4,0(sp)
    80000582:	1800                	addi	s0,sp,48
typedef uint64 pte_t;
typedef uint64 *pagetable_t; // 512 PTEs

static inline uint64 r_fp() {
  uint64 x;
  asm volatile("mv %0, s0" : "=r"(x));
    80000584:	8722                	mv	a4,s0
  uint64 sp = r_fp();
  char *s = (char *)sp;
  uint64 stack_base = PGROUNDUP(sp);
    80000586:	6905                	lui	s2,0x1
    80000588:	197d                	addi	s2,s2,-1
    8000058a:	993a                	add	s2,s2,a4
    8000058c:	79fd                	lui	s3,0xfffff
    8000058e:	01397933          	and	s2,s2,s3
  uint64 stack_up = PGROUNDDOWN(sp);
    80000592:	013779b3          	and	s3,a4,s3
  if (!(sp >= stack_up && sp <= stack_base)) {
    80000596:	01376963          	bltu	a4,s3,800005a8 <backtrace+0x34>
    8000059a:	87ba                	mv	a5,a4
  uint64 ra;
  while ((uint64)s <= stack_base && (uint64)s >= stack_up) {
    ra = *(uint64 *)(s - 8);
    s = (char *)*(uint64 *)(s - 16);
    if (((uint64)s <= stack_base && (uint64)s >= stack_up))
      printf("%p\n", ra);
    8000059c:	00008a17          	auipc	s4,0x8
    800005a0:	aa4a0a13          	addi	s4,s4,-1372 # 80008040 <etext+0x40>
  if (!(sp >= stack_up && sp <= stack_base)) {
    800005a4:	02e97263          	bgeu	s2,a4,800005c8 <backtrace+0x54>
    panic("invalid stack frame pointer");
    800005a8:	00008517          	auipc	a0,0x8
    800005ac:	a7850513          	addi	a0,a0,-1416 # 80008020 <etext+0x20>
    800005b0:	00000097          	auipc	ra,0x0
    800005b4:	034080e7          	jalr	52(ra) # 800005e4 <panic>
      printf("%p\n", ra);
    800005b8:	ff87b583          	ld	a1,-8(a5)
    800005bc:	8552                	mv	a0,s4
    800005be:	00000097          	auipc	ra,0x0
    800005c2:	078080e7          	jalr	120(ra) # 80000636 <printf>
    800005c6:	87a6                	mv	a5,s1
    s = (char *)*(uint64 *)(s - 16);
    800005c8:	ff07b483          	ld	s1,-16(a5)
    if (((uint64)s <= stack_base && (uint64)s >= stack_up))
    800005cc:	00996463          	bltu	s2,s1,800005d4 <backtrace+0x60>
    800005d0:	ff34f4e3          	bgeu	s1,s3,800005b8 <backtrace+0x44>
  }
    800005d4:	70a2                	ld	ra,40(sp)
    800005d6:	7402                	ld	s0,32(sp)
    800005d8:	64e2                	ld	s1,24(sp)
    800005da:	6942                	ld	s2,16(sp)
    800005dc:	69a2                	ld	s3,8(sp)
    800005de:	6a02                	ld	s4,0(sp)
    800005e0:	6145                	addi	sp,sp,48
    800005e2:	8082                	ret

00000000800005e4 <panic>:
void panic(char *s) {
    800005e4:	1101                	addi	sp,sp,-32
    800005e6:	ec06                	sd	ra,24(sp)
    800005e8:	e822                	sd	s0,16(sp)
    800005ea:	e426                	sd	s1,8(sp)
    800005ec:	1000                	addi	s0,sp,32
    800005ee:	84aa                	mv	s1,a0
  pr.locking = 0;
    800005f0:	00011797          	auipc	a5,0x11
    800005f4:	3007a823          	sw	zero,784(a5) # 80011900 <pr+0x18>
  printf("panic: ");
    800005f8:	00008517          	auipc	a0,0x8
    800005fc:	a5050513          	addi	a0,a0,-1456 # 80008048 <etext+0x48>
    80000600:	00000097          	auipc	ra,0x0
    80000604:	036080e7          	jalr	54(ra) # 80000636 <printf>
  printf(s);
    80000608:	8526                	mv	a0,s1
    8000060a:	00000097          	auipc	ra,0x0
    8000060e:	02c080e7          	jalr	44(ra) # 80000636 <printf>
  printf("\n");
    80000612:	00008517          	auipc	a0,0x8
    80000616:	aa650513          	addi	a0,a0,-1370 # 800080b8 <digits+0x50>
    8000061a:	00000097          	auipc	ra,0x0
    8000061e:	01c080e7          	jalr	28(ra) # 80000636 <printf>
  backtrace();
    80000622:	00000097          	auipc	ra,0x0
    80000626:	f52080e7          	jalr	-174(ra) # 80000574 <backtrace>
  panicked = 1; // freeze uart output from other CPUs
    8000062a:	4785                	li	a5,1
    8000062c:	00009717          	auipc	a4,0x9
    80000630:	9cf72a23          	sw	a5,-1580(a4) # 80009000 <panicked>
  for (;;)
    80000634:	a001                	j	80000634 <panic+0x50>

0000000080000636 <printf>:
void printf(char *fmt, ...) {
    80000636:	7131                	addi	sp,sp,-192
    80000638:	fc86                	sd	ra,120(sp)
    8000063a:	f8a2                	sd	s0,112(sp)
    8000063c:	f4a6                	sd	s1,104(sp)
    8000063e:	f0ca                	sd	s2,96(sp)
    80000640:	ecce                	sd	s3,88(sp)
    80000642:	e8d2                	sd	s4,80(sp)
    80000644:	e4d6                	sd	s5,72(sp)
    80000646:	e0da                	sd	s6,64(sp)
    80000648:	fc5e                	sd	s7,56(sp)
    8000064a:	f862                	sd	s8,48(sp)
    8000064c:	f466                	sd	s9,40(sp)
    8000064e:	f06a                	sd	s10,32(sp)
    80000650:	ec6e                	sd	s11,24(sp)
    80000652:	0100                	addi	s0,sp,128
    80000654:	8a2a                	mv	s4,a0
    80000656:	e40c                	sd	a1,8(s0)
    80000658:	e810                	sd	a2,16(s0)
    8000065a:	ec14                	sd	a3,24(s0)
    8000065c:	f018                	sd	a4,32(s0)
    8000065e:	f41c                	sd	a5,40(s0)
    80000660:	03043823          	sd	a6,48(s0)
    80000664:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80000668:	00011d97          	auipc	s11,0x11
    8000066c:	298dad83          	lw	s11,664(s11) # 80011900 <pr+0x18>
  if (locking)
    80000670:	020d9b63          	bnez	s11,800006a6 <printf+0x70>
  if (fmt == 0)
    80000674:	040a0263          	beqz	s4,800006b8 <printf+0x82>
  va_start(ap, fmt);
    80000678:	00840793          	addi	a5,s0,8
    8000067c:	f8f43423          	sd	a5,-120(s0)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80000680:	000a4503          	lbu	a0,0(s4)
    80000684:	14050f63          	beqz	a0,800007e2 <printf+0x1ac>
    80000688:	4981                	li	s3,0
    if (c != '%') {
    8000068a:	02500a93          	li	s5,37
    switch (c) {
    8000068e:	07000b93          	li	s7,112
  consputc('x');
    80000692:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000694:	00008b17          	auipc	s6,0x8
    80000698:	9d4b0b13          	addi	s6,s6,-1580 # 80008068 <digits>
    switch (c) {
    8000069c:	07300c93          	li	s9,115
    800006a0:	06400c13          	li	s8,100
    800006a4:	a82d                	j	800006de <printf+0xa8>
    acquire(&pr.lock);
    800006a6:	00011517          	auipc	a0,0x11
    800006aa:	24250513          	addi	a0,a0,578 # 800118e8 <pr>
    800006ae:	00000097          	auipc	ra,0x0
    800006b2:	68c080e7          	jalr	1676(ra) # 80000d3a <acquire>
    800006b6:	bf7d                	j	80000674 <printf+0x3e>
    panic("null fmt");
    800006b8:	00008517          	auipc	a0,0x8
    800006bc:	9a050513          	addi	a0,a0,-1632 # 80008058 <etext+0x58>
    800006c0:	00000097          	auipc	ra,0x0
    800006c4:	f24080e7          	jalr	-220(ra) # 800005e4 <panic>
      consputc(c);
    800006c8:	00000097          	auipc	ra,0x0
    800006cc:	bb8080e7          	jalr	-1096(ra) # 80000280 <consputc>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    800006d0:	2985                	addiw	s3,s3,1
    800006d2:	013a07b3          	add	a5,s4,s3
    800006d6:	0007c503          	lbu	a0,0(a5)
    800006da:	10050463          	beqz	a0,800007e2 <printf+0x1ac>
    if (c != '%') {
    800006de:	ff5515e3          	bne	a0,s5,800006c8 <printf+0x92>
    c = fmt[++i] & 0xff;
    800006e2:	2985                	addiw	s3,s3,1
    800006e4:	013a07b3          	add	a5,s4,s3
    800006e8:	0007c783          	lbu	a5,0(a5)
    800006ec:	0007849b          	sext.w	s1,a5
    if (c == 0)
    800006f0:	cbed                	beqz	a5,800007e2 <printf+0x1ac>
    switch (c) {
    800006f2:	05778a63          	beq	a5,s7,80000746 <printf+0x110>
    800006f6:	02fbf663          	bgeu	s7,a5,80000722 <printf+0xec>
    800006fa:	09978863          	beq	a5,s9,8000078a <printf+0x154>
    800006fe:	07800713          	li	a4,120
    80000702:	0ce79563          	bne	a5,a4,800007cc <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80000706:	f8843783          	ld	a5,-120(s0)
    8000070a:	00878713          	addi	a4,a5,8
    8000070e:	f8e43423          	sd	a4,-120(s0)
    80000712:	4605                	li	a2,1
    80000714:	85ea                	mv	a1,s10
    80000716:	4388                	lw	a0,0(a5)
    80000718:	00000097          	auipc	ra,0x0
    8000071c:	d88080e7          	jalr	-632(ra) # 800004a0 <printint>
      break;
    80000720:	bf45                	j	800006d0 <printf+0x9a>
    switch (c) {
    80000722:	09578f63          	beq	a5,s5,800007c0 <printf+0x18a>
    80000726:	0b879363          	bne	a5,s8,800007cc <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    8000072a:	f8843783          	ld	a5,-120(s0)
    8000072e:	00878713          	addi	a4,a5,8
    80000732:	f8e43423          	sd	a4,-120(s0)
    80000736:	4605                	li	a2,1
    80000738:	45a9                	li	a1,10
    8000073a:	4388                	lw	a0,0(a5)
    8000073c:	00000097          	auipc	ra,0x0
    80000740:	d64080e7          	jalr	-668(ra) # 800004a0 <printint>
      break;
    80000744:	b771                	j	800006d0 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80000746:	f8843783          	ld	a5,-120(s0)
    8000074a:	00878713          	addi	a4,a5,8
    8000074e:	f8e43423          	sd	a4,-120(s0)
    80000752:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80000756:	03000513          	li	a0,48
    8000075a:	00000097          	auipc	ra,0x0
    8000075e:	b26080e7          	jalr	-1242(ra) # 80000280 <consputc>
  consputc('x');
    80000762:	07800513          	li	a0,120
    80000766:	00000097          	auipc	ra,0x0
    8000076a:	b1a080e7          	jalr	-1254(ra) # 80000280 <consputc>
    8000076e:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000770:	03c95793          	srli	a5,s2,0x3c
    80000774:	97da                	add	a5,a5,s6
    80000776:	0007c503          	lbu	a0,0(a5)
    8000077a:	00000097          	auipc	ra,0x0
    8000077e:	b06080e7          	jalr	-1274(ra) # 80000280 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80000782:	0912                	slli	s2,s2,0x4
    80000784:	34fd                	addiw	s1,s1,-1
    80000786:	f4ed                	bnez	s1,80000770 <printf+0x13a>
    80000788:	b7a1                	j	800006d0 <printf+0x9a>
      if ((s = va_arg(ap, char *)) == 0)
    8000078a:	f8843783          	ld	a5,-120(s0)
    8000078e:	00878713          	addi	a4,a5,8
    80000792:	f8e43423          	sd	a4,-120(s0)
    80000796:	6384                	ld	s1,0(a5)
    80000798:	cc89                	beqz	s1,800007b2 <printf+0x17c>
      for (; *s; s++)
    8000079a:	0004c503          	lbu	a0,0(s1)
    8000079e:	d90d                	beqz	a0,800006d0 <printf+0x9a>
        consputc(*s);
    800007a0:	00000097          	auipc	ra,0x0
    800007a4:	ae0080e7          	jalr	-1312(ra) # 80000280 <consputc>
      for (; *s; s++)
    800007a8:	0485                	addi	s1,s1,1
    800007aa:	0004c503          	lbu	a0,0(s1)
    800007ae:	f96d                	bnez	a0,800007a0 <printf+0x16a>
    800007b0:	b705                	j	800006d0 <printf+0x9a>
        s = "(null)";
    800007b2:	00008497          	auipc	s1,0x8
    800007b6:	89e48493          	addi	s1,s1,-1890 # 80008050 <etext+0x50>
      for (; *s; s++)
    800007ba:	02800513          	li	a0,40
    800007be:	b7cd                	j	800007a0 <printf+0x16a>
      consputc('%');
    800007c0:	8556                	mv	a0,s5
    800007c2:	00000097          	auipc	ra,0x0
    800007c6:	abe080e7          	jalr	-1346(ra) # 80000280 <consputc>
      break;
    800007ca:	b719                	j	800006d0 <printf+0x9a>
      consputc('%');
    800007cc:	8556                	mv	a0,s5
    800007ce:	00000097          	auipc	ra,0x0
    800007d2:	ab2080e7          	jalr	-1358(ra) # 80000280 <consputc>
      consputc(c);
    800007d6:	8526                	mv	a0,s1
    800007d8:	00000097          	auipc	ra,0x0
    800007dc:	aa8080e7          	jalr	-1368(ra) # 80000280 <consputc>
      break;
    800007e0:	bdc5                	j	800006d0 <printf+0x9a>
  if (locking)
    800007e2:	020d9163          	bnez	s11,80000804 <printf+0x1ce>
}
    800007e6:	70e6                	ld	ra,120(sp)
    800007e8:	7446                	ld	s0,112(sp)
    800007ea:	74a6                	ld	s1,104(sp)
    800007ec:	7906                	ld	s2,96(sp)
    800007ee:	69e6                	ld	s3,88(sp)
    800007f0:	6a46                	ld	s4,80(sp)
    800007f2:	6aa6                	ld	s5,72(sp)
    800007f4:	6b06                	ld	s6,64(sp)
    800007f6:	7be2                	ld	s7,56(sp)
    800007f8:	7c42                	ld	s8,48(sp)
    800007fa:	7ca2                	ld	s9,40(sp)
    800007fc:	7d02                	ld	s10,32(sp)
    800007fe:	6de2                	ld	s11,24(sp)
    80000800:	6129                	addi	sp,sp,192
    80000802:	8082                	ret
    release(&pr.lock);
    80000804:	00011517          	auipc	a0,0x11
    80000808:	0e450513          	addi	a0,a0,228 # 800118e8 <pr>
    8000080c:	00000097          	auipc	ra,0x0
    80000810:	5e2080e7          	jalr	1506(ra) # 80000dee <release>
}
    80000814:	bfc9                	j	800007e6 <printf+0x1b0>

0000000080000816 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80000816:	1141                	addi	sp,sp,-16
    80000818:	e406                	sd	ra,8(sp)
    8000081a:	e022                	sd	s0,0(sp)
    8000081c:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000081e:	100007b7          	lui	a5,0x10000
    80000822:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80000826:	f8000713          	li	a4,-128
    8000082a:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000082e:	470d                	li	a4,3
    80000830:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80000834:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000838:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000083c:	469d                	li	a3,7
    8000083e:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80000842:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000846:	00008597          	auipc	a1,0x8
    8000084a:	83a58593          	addi	a1,a1,-1990 # 80008080 <digits+0x18>
    8000084e:	00011517          	auipc	a0,0x11
    80000852:	0ba50513          	addi	a0,a0,186 # 80011908 <uart_tx_lock>
    80000856:	00000097          	auipc	ra,0x0
    8000085a:	454080e7          	jalr	1108(ra) # 80000caa <initlock>
}
    8000085e:	60a2                	ld	ra,8(sp)
    80000860:	6402                	ld	s0,0(sp)
    80000862:	0141                	addi	sp,sp,16
    80000864:	8082                	ret

0000000080000866 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000866:	1101                	addi	sp,sp,-32
    80000868:	ec06                	sd	ra,24(sp)
    8000086a:	e822                	sd	s0,16(sp)
    8000086c:	e426                	sd	s1,8(sp)
    8000086e:	1000                	addi	s0,sp,32
    80000870:	84aa                	mv	s1,a0
  push_off();
    80000872:	00000097          	auipc	ra,0x0
    80000876:	47c080e7          	jalr	1148(ra) # 80000cee <push_off>

  if(panicked){
    8000087a:	00008797          	auipc	a5,0x8
    8000087e:	7867a783          	lw	a5,1926(a5) # 80009000 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000882:	10000737          	lui	a4,0x10000
  if(panicked){
    80000886:	c391                	beqz	a5,8000088a <uartputc_sync+0x24>
    for(;;)
    80000888:	a001                	j	80000888 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000088a:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000088e:	0207f793          	andi	a5,a5,32
    80000892:	dfe5                	beqz	a5,8000088a <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000894:	0ff4f513          	andi	a0,s1,255
    80000898:	100007b7          	lui	a5,0x10000
    8000089c:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800008a0:	00000097          	auipc	ra,0x0
    800008a4:	4ee080e7          	jalr	1262(ra) # 80000d8e <pop_off>
}
    800008a8:	60e2                	ld	ra,24(sp)
    800008aa:	6442                	ld	s0,16(sp)
    800008ac:	64a2                	ld	s1,8(sp)
    800008ae:	6105                	addi	sp,sp,32
    800008b0:	8082                	ret

00000000800008b2 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800008b2:	00008797          	auipc	a5,0x8
    800008b6:	7527a783          	lw	a5,1874(a5) # 80009004 <uart_tx_r>
    800008ba:	00008717          	auipc	a4,0x8
    800008be:	74e72703          	lw	a4,1870(a4) # 80009008 <uart_tx_w>
    800008c2:	08f70063          	beq	a4,a5,80000942 <uartstart+0x90>
{
    800008c6:	7139                	addi	sp,sp,-64
    800008c8:	fc06                	sd	ra,56(sp)
    800008ca:	f822                	sd	s0,48(sp)
    800008cc:	f426                	sd	s1,40(sp)
    800008ce:	f04a                	sd	s2,32(sp)
    800008d0:	ec4e                	sd	s3,24(sp)
    800008d2:	e852                	sd	s4,16(sp)
    800008d4:	e456                	sd	s5,8(sp)
    800008d6:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008d8:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r];
    800008dc:	00011a97          	auipc	s5,0x11
    800008e0:	02ca8a93          	addi	s5,s5,44 # 80011908 <uart_tx_lock>
    uart_tx_r = (uart_tx_r + 1) % UART_TX_BUF_SIZE;
    800008e4:	00008497          	auipc	s1,0x8
    800008e8:	72048493          	addi	s1,s1,1824 # 80009004 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800008ec:	00008a17          	auipc	s4,0x8
    800008f0:	71ca0a13          	addi	s4,s4,1820 # 80009008 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008f4:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    800008f8:	02077713          	andi	a4,a4,32
    800008fc:	cb15                	beqz	a4,80000930 <uartstart+0x7e>
    int c = uart_tx_buf[uart_tx_r];
    800008fe:	00fa8733          	add	a4,s5,a5
    80000902:	01874983          	lbu	s3,24(a4)
    uart_tx_r = (uart_tx_r + 1) % UART_TX_BUF_SIZE;
    80000906:	2785                	addiw	a5,a5,1
    80000908:	41f7d71b          	sraiw	a4,a5,0x1f
    8000090c:	01b7571b          	srliw	a4,a4,0x1b
    80000910:	9fb9                	addw	a5,a5,a4
    80000912:	8bfd                	andi	a5,a5,31
    80000914:	9f99                	subw	a5,a5,a4
    80000916:	c09c                	sw	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80000918:	8526                	mv	a0,s1
    8000091a:	00002097          	auipc	ra,0x2
    8000091e:	ce0080e7          	jalr	-800(ra) # 800025fa <wakeup>
    
    WriteReg(THR, c);
    80000922:	01390023          	sb	s3,0(s2)
    if(uart_tx_w == uart_tx_r){
    80000926:	409c                	lw	a5,0(s1)
    80000928:	000a2703          	lw	a4,0(s4)
    8000092c:	fcf714e3          	bne	a4,a5,800008f4 <uartstart+0x42>
  }
}
    80000930:	70e2                	ld	ra,56(sp)
    80000932:	7442                	ld	s0,48(sp)
    80000934:	74a2                	ld	s1,40(sp)
    80000936:	7902                	ld	s2,32(sp)
    80000938:	69e2                	ld	s3,24(sp)
    8000093a:	6a42                	ld	s4,16(sp)
    8000093c:	6aa2                	ld	s5,8(sp)
    8000093e:	6121                	addi	sp,sp,64
    80000940:	8082                	ret
    80000942:	8082                	ret

0000000080000944 <uartputc>:
{
    80000944:	7179                	addi	sp,sp,-48
    80000946:	f406                	sd	ra,40(sp)
    80000948:	f022                	sd	s0,32(sp)
    8000094a:	ec26                	sd	s1,24(sp)
    8000094c:	e84a                	sd	s2,16(sp)
    8000094e:	e44e                	sd	s3,8(sp)
    80000950:	e052                	sd	s4,0(sp)
    80000952:	1800                	addi	s0,sp,48
    80000954:	84aa                	mv	s1,a0
  acquire(&uart_tx_lock);
    80000956:	00011517          	auipc	a0,0x11
    8000095a:	fb250513          	addi	a0,a0,-78 # 80011908 <uart_tx_lock>
    8000095e:	00000097          	auipc	ra,0x0
    80000962:	3dc080e7          	jalr	988(ra) # 80000d3a <acquire>
  if(panicked){
    80000966:	00008797          	auipc	a5,0x8
    8000096a:	69a7a783          	lw	a5,1690(a5) # 80009000 <panicked>
    8000096e:	c391                	beqz	a5,80000972 <uartputc+0x2e>
    for(;;)
    80000970:	a001                	j	80000970 <uartputc+0x2c>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    80000972:	00008697          	auipc	a3,0x8
    80000976:	6966a683          	lw	a3,1686(a3) # 80009008 <uart_tx_w>
    8000097a:	0016879b          	addiw	a5,a3,1
    8000097e:	41f7d71b          	sraiw	a4,a5,0x1f
    80000982:	01b7571b          	srliw	a4,a4,0x1b
    80000986:	9fb9                	addw	a5,a5,a4
    80000988:	8bfd                	andi	a5,a5,31
    8000098a:	9f99                	subw	a5,a5,a4
    8000098c:	00008717          	auipc	a4,0x8
    80000990:	67872703          	lw	a4,1656(a4) # 80009004 <uart_tx_r>
    80000994:	04f71363          	bne	a4,a5,800009da <uartputc+0x96>
      sleep(&uart_tx_r, &uart_tx_lock);
    80000998:	00011a17          	auipc	s4,0x11
    8000099c:	f70a0a13          	addi	s4,s4,-144 # 80011908 <uart_tx_lock>
    800009a0:	00008917          	auipc	s2,0x8
    800009a4:	66490913          	addi	s2,s2,1636 # 80009004 <uart_tx_r>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    800009a8:	00008997          	auipc	s3,0x8
    800009ac:	66098993          	addi	s3,s3,1632 # 80009008 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800009b0:	85d2                	mv	a1,s4
    800009b2:	854a                	mv	a0,s2
    800009b4:	00002097          	auipc	ra,0x2
    800009b8:	ac6080e7          	jalr	-1338(ra) # 8000247a <sleep>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    800009bc:	0009a683          	lw	a3,0(s3)
    800009c0:	0016879b          	addiw	a5,a3,1
    800009c4:	41f7d71b          	sraiw	a4,a5,0x1f
    800009c8:	01b7571b          	srliw	a4,a4,0x1b
    800009cc:	9fb9                	addw	a5,a5,a4
    800009ce:	8bfd                	andi	a5,a5,31
    800009d0:	9f99                	subw	a5,a5,a4
    800009d2:	00092703          	lw	a4,0(s2)
    800009d6:	fcf70de3          	beq	a4,a5,800009b0 <uartputc+0x6c>
      uart_tx_buf[uart_tx_w] = c;
    800009da:	00011917          	auipc	s2,0x11
    800009de:	f2e90913          	addi	s2,s2,-210 # 80011908 <uart_tx_lock>
    800009e2:	96ca                	add	a3,a3,s2
    800009e4:	00968c23          	sb	s1,24(a3)
      uart_tx_w = (uart_tx_w + 1) % UART_TX_BUF_SIZE;
    800009e8:	00008717          	auipc	a4,0x8
    800009ec:	62f72023          	sw	a5,1568(a4) # 80009008 <uart_tx_w>
      uartstart();
    800009f0:	00000097          	auipc	ra,0x0
    800009f4:	ec2080e7          	jalr	-318(ra) # 800008b2 <uartstart>
      release(&uart_tx_lock);
    800009f8:	854a                	mv	a0,s2
    800009fa:	00000097          	auipc	ra,0x0
    800009fe:	3f4080e7          	jalr	1012(ra) # 80000dee <release>
}
    80000a02:	70a2                	ld	ra,40(sp)
    80000a04:	7402                	ld	s0,32(sp)
    80000a06:	64e2                	ld	s1,24(sp)
    80000a08:	6942                	ld	s2,16(sp)
    80000a0a:	69a2                	ld	s3,8(sp)
    80000a0c:	6a02                	ld	s4,0(sp)
    80000a0e:	6145                	addi	sp,sp,48
    80000a10:	8082                	ret

0000000080000a12 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000a12:	1141                	addi	sp,sp,-16
    80000a14:	e422                	sd	s0,8(sp)
    80000a16:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000a18:	100007b7          	lui	a5,0x10000
    80000a1c:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000a20:	8b85                	andi	a5,a5,1
    80000a22:	cb91                	beqz	a5,80000a36 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80000a24:	100007b7          	lui	a5,0x10000
    80000a28:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80000a2c:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80000a30:	6422                	ld	s0,8(sp)
    80000a32:	0141                	addi	sp,sp,16
    80000a34:	8082                	ret
    return -1;
    80000a36:	557d                	li	a0,-1
    80000a38:	bfe5                	j	80000a30 <uartgetc+0x1e>

0000000080000a3a <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80000a3a:	1101                	addi	sp,sp,-32
    80000a3c:	ec06                	sd	ra,24(sp)
    80000a3e:	e822                	sd	s0,16(sp)
    80000a40:	e426                	sd	s1,8(sp)
    80000a42:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a44:	54fd                	li	s1,-1
    80000a46:	a029                	j	80000a50 <uartintr+0x16>
      break;
    consoleintr(c);
    80000a48:	00000097          	auipc	ra,0x0
    80000a4c:	87a080e7          	jalr	-1926(ra) # 800002c2 <consoleintr>
    int c = uartgetc();
    80000a50:	00000097          	auipc	ra,0x0
    80000a54:	fc2080e7          	jalr	-62(ra) # 80000a12 <uartgetc>
    if(c == -1)
    80000a58:	fe9518e3          	bne	a0,s1,80000a48 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a5c:	00011497          	auipc	s1,0x11
    80000a60:	eac48493          	addi	s1,s1,-340 # 80011908 <uart_tx_lock>
    80000a64:	8526                	mv	a0,s1
    80000a66:	00000097          	auipc	ra,0x0
    80000a6a:	2d4080e7          	jalr	724(ra) # 80000d3a <acquire>
  uartstart();
    80000a6e:	00000097          	auipc	ra,0x0
    80000a72:	e44080e7          	jalr	-444(ra) # 800008b2 <uartstart>
  release(&uart_tx_lock);
    80000a76:	8526                	mv	a0,s1
    80000a78:	00000097          	auipc	ra,0x0
    80000a7c:	376080e7          	jalr	886(ra) # 80000dee <release>
}
    80000a80:	60e2                	ld	ra,24(sp)
    80000a82:	6442                	ld	s0,16(sp)
    80000a84:	64a2                	ld	s1,8(sp)
    80000a86:	6105                	addi	sp,sp,32
    80000a88:	8082                	ret

0000000080000a8a <kfree>:

// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa) {
    80000a8a:	1101                	addi	sp,sp,-32
    80000a8c:	ec06                	sd	ra,24(sp)
    80000a8e:	e822                	sd	s0,16(sp)
    80000a90:	e426                	sd	s1,8(sp)
    80000a92:	e04a                	sd	s2,0(sp)
    80000a94:	1000                	addi	s0,sp,32
  struct run *r;

  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000a96:	03451793          	slli	a5,a0,0x34
    80000a9a:	ebc9                	bnez	a5,80000b2c <kfree+0xa2>
    80000a9c:	84aa                	mv	s1,a0
    80000a9e:	00045797          	auipc	a5,0x45
    80000aa2:	56278793          	addi	a5,a5,1378 # 80046000 <end>
    80000aa6:	08f56363          	bltu	a0,a5,80000b2c <kfree+0xa2>
    80000aaa:	47c5                	li	a5,17
    80000aac:	07ee                	slli	a5,a5,0x1b
    80000aae:	06f57f63          	bgeu	a0,a5,80000b2c <kfree+0xa2>
    panic("kfree");

  if (page_ref_count[REF_IDX(pa)] < 0) {
    80000ab2:	77fd                	lui	a5,0xfffff
    80000ab4:	8fe9                	and	a5,a5,a0
    80000ab6:	80000737          	lui	a4,0x80000
    80000aba:	97ba                	add	a5,a5,a4
    80000abc:	00c7d693          	srli	a3,a5,0xc
    80000ac0:	83a9                	srli	a5,a5,0xa
    80000ac2:	00011717          	auipc	a4,0x11
    80000ac6:	e9e70713          	addi	a4,a4,-354 # 80011960 <page_ref_count>
    80000aca:	97ba                	add	a5,a5,a4
    80000acc:	438c                	lw	a1,0(a5)
    80000ace:	0605c763          	bltz	a1,80000b3c <kfree+0xb2>
    printf("free error %d\n", page_ref_count[REF_IDX(pa)]);
    panic("~~~~~");
  } else if (page_ref_count[REF_IDX(pa)] == 0) {
    80000ad2:	cd89                	beqz	a1,80000aec <kfree+0x62>
    goto link;
  } else {
    // printf("free page %p\n", pa);
    page_ref_count[REF_IDX(pa)] -= 1;
    80000ad4:	35fd                	addiw	a1,a1,-1
    80000ad6:	0005871b          	sext.w	a4,a1
    80000ada:	068a                	slli	a3,a3,0x2
    80000adc:	00011797          	auipc	a5,0x11
    80000ae0:	e8478793          	addi	a5,a5,-380 # 80011960 <page_ref_count>
    80000ae4:	96be                	add	a3,a3,a5
    80000ae6:	c28c                	sw	a1,0(a3)
    if (page_ref_count[REF_IDX(pa)] > 0) {
    80000ae8:	02e04c63          	bgtz	a4,80000b20 <kfree+0x96>
      return;
    }

  link:
    // Fill with junk to catch dangling refs.
    memset(pa, 1, PGSIZE);
    80000aec:	6605                	lui	a2,0x1
    80000aee:	4585                	li	a1,1
    80000af0:	8526                	mv	a0,s1
    80000af2:	00000097          	auipc	ra,0x0
    80000af6:	344080e7          	jalr	836(ra) # 80000e36 <memset>

    r = (struct run *)pa;

    acquire(&kmem.lock);
    80000afa:	00011917          	auipc	s2,0x11
    80000afe:	e4690913          	addi	s2,s2,-442 # 80011940 <kmem>
    80000b02:	854a                	mv	a0,s2
    80000b04:	00000097          	auipc	ra,0x0
    80000b08:	236080e7          	jalr	566(ra) # 80000d3a <acquire>
    r->next = kmem.freelist;
    80000b0c:	01893783          	ld	a5,24(s2)
    80000b10:	e09c                	sd	a5,0(s1)
    kmem.freelist = r;
    80000b12:	00993c23          	sd	s1,24(s2)
    release(&kmem.lock);
    80000b16:	854a                	mv	a0,s2
    80000b18:	00000097          	auipc	ra,0x0
    80000b1c:	2d6080e7          	jalr	726(ra) # 80000dee <release>
  }
}
    80000b20:	60e2                	ld	ra,24(sp)
    80000b22:	6442                	ld	s0,16(sp)
    80000b24:	64a2                	ld	s1,8(sp)
    80000b26:	6902                	ld	s2,0(sp)
    80000b28:	6105                	addi	sp,sp,32
    80000b2a:	8082                	ret
    panic("kfree");
    80000b2c:	00007517          	auipc	a0,0x7
    80000b30:	55c50513          	addi	a0,a0,1372 # 80008088 <digits+0x20>
    80000b34:	00000097          	auipc	ra,0x0
    80000b38:	ab0080e7          	jalr	-1360(ra) # 800005e4 <panic>
    printf("free error %d\n", page_ref_count[REF_IDX(pa)]);
    80000b3c:	00007517          	auipc	a0,0x7
    80000b40:	55450513          	addi	a0,a0,1364 # 80008090 <digits+0x28>
    80000b44:	00000097          	auipc	ra,0x0
    80000b48:	af2080e7          	jalr	-1294(ra) # 80000636 <printf>
    panic("~~~~~");
    80000b4c:	00007517          	auipc	a0,0x7
    80000b50:	55450513          	addi	a0,a0,1364 # 800080a0 <digits+0x38>
    80000b54:	00000097          	auipc	ra,0x0
    80000b58:	a90080e7          	jalr	-1392(ra) # 800005e4 <panic>

0000000080000b5c <freerange>:
void freerange(void *pa_start, void *pa_end) {
    80000b5c:	7179                	addi	sp,sp,-48
    80000b5e:	f406                	sd	ra,40(sp)
    80000b60:	f022                	sd	s0,32(sp)
    80000b62:	ec26                	sd	s1,24(sp)
    80000b64:	e84a                	sd	s2,16(sp)
    80000b66:	e44e                	sd	s3,8(sp)
    80000b68:	e052                	sd	s4,0(sp)
    80000b6a:	1800                	addi	s0,sp,48
  p = (char *)PGROUNDUP((uint64)pa_start);
    80000b6c:	6785                	lui	a5,0x1
    80000b6e:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000b72:	94aa                	add	s1,s1,a0
    80000b74:	757d                	lui	a0,0xfffff
    80000b76:	8ce9                	and	s1,s1,a0
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000b78:	94be                	add	s1,s1,a5
    80000b7a:	0095ee63          	bltu	a1,s1,80000b96 <freerange+0x3a>
    80000b7e:	892e                	mv	s2,a1
    kfree(p);
    80000b80:	7a7d                	lui	s4,0xfffff
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000b82:	6985                	lui	s3,0x1
    kfree(p);
    80000b84:	01448533          	add	a0,s1,s4
    80000b88:	00000097          	auipc	ra,0x0
    80000b8c:	f02080e7          	jalr	-254(ra) # 80000a8a <kfree>
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000b90:	94ce                	add	s1,s1,s3
    80000b92:	fe9979e3          	bgeu	s2,s1,80000b84 <freerange+0x28>
}
    80000b96:	70a2                	ld	ra,40(sp)
    80000b98:	7402                	ld	s0,32(sp)
    80000b9a:	64e2                	ld	s1,24(sp)
    80000b9c:	6942                	ld	s2,16(sp)
    80000b9e:	69a2                	ld	s3,8(sp)
    80000ba0:	6a02                	ld	s4,0(sp)
    80000ba2:	6145                	addi	sp,sp,48
    80000ba4:	8082                	ret

0000000080000ba6 <kinit>:
void kinit() {
    80000ba6:	1141                	addi	sp,sp,-16
    80000ba8:	e406                	sd	ra,8(sp)
    80000baa:	e022                	sd	s0,0(sp)
    80000bac:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000bae:	00007597          	auipc	a1,0x7
    80000bb2:	4fa58593          	addi	a1,a1,1274 # 800080a8 <digits+0x40>
    80000bb6:	00011517          	auipc	a0,0x11
    80000bba:	d8a50513          	addi	a0,a0,-630 # 80011940 <kmem>
    80000bbe:	00000097          	auipc	ra,0x0
    80000bc2:	0ec080e7          	jalr	236(ra) # 80000caa <initlock>
  for (i = 0; i < REF_IDX(PHYSTOP); i++)
    80000bc6:	00011797          	auipc	a5,0x11
    80000bca:	d9a78793          	addi	a5,a5,-614 # 80011960 <page_ref_count>
    80000bce:	00031717          	auipc	a4,0x31
    80000bd2:	d9270713          	addi	a4,a4,-622 # 80031960 <pid_lock>
    page_ref_count[i] = 0;
    80000bd6:	0007a023          	sw	zero,0(a5)
  for (i = 0; i < REF_IDX(PHYSTOP); i++)
    80000bda:	0791                	addi	a5,a5,4
    80000bdc:	fee79de3          	bne	a5,a4,80000bd6 <kinit+0x30>
  freerange(end, (void *)PHYSTOP);
    80000be0:	45c5                	li	a1,17
    80000be2:	05ee                	slli	a1,a1,0x1b
    80000be4:	00045517          	auipc	a0,0x45
    80000be8:	41c50513          	addi	a0,a0,1052 # 80046000 <end>
    80000bec:	00000097          	auipc	ra,0x0
    80000bf0:	f70080e7          	jalr	-144(ra) # 80000b5c <freerange>
}
    80000bf4:	60a2                	ld	ra,8(sp)
    80000bf6:	6402                	ld	s0,0(sp)
    80000bf8:	0141                	addi	sp,sp,16
    80000bfa:	8082                	ret

0000000080000bfc <kalloc>:

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *kalloc(void) {
    80000bfc:	1101                	addi	sp,sp,-32
    80000bfe:	ec06                	sd	ra,24(sp)
    80000c00:	e822                	sd	s0,16(sp)
    80000c02:	e426                	sd	s1,8(sp)
    80000c04:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000c06:	00011497          	auipc	s1,0x11
    80000c0a:	d3a48493          	addi	s1,s1,-710 # 80011940 <kmem>
    80000c0e:	8526                	mv	a0,s1
    80000c10:	00000097          	auipc	ra,0x0
    80000c14:	12a080e7          	jalr	298(ra) # 80000d3a <acquire>
  r = kmem.freelist;
    80000c18:	6c84                	ld	s1,24(s1)
  if (r)
    80000c1a:	ccbd                	beqz	s1,80000c98 <kalloc+0x9c>
    kmem.freelist = r->next;
    80000c1c:	609c                	ld	a5,0(s1)
    80000c1e:	00011517          	auipc	a0,0x11
    80000c22:	d2250513          	addi	a0,a0,-734 # 80011940 <kmem>
    80000c26:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000c28:	00000097          	auipc	ra,0x0
    80000c2c:	1c6080e7          	jalr	454(ra) # 80000dee <release>

  if (r)
    memset((char *)r, 5, PGSIZE); // fill with junk
    80000c30:	6605                	lui	a2,0x1
    80000c32:	4595                	li	a1,5
    80000c34:	8526                	mv	a0,s1
    80000c36:	00000097          	auipc	ra,0x0
    80000c3a:	200080e7          	jalr	512(ra) # 80000e36 <memset>

  // ! tomestone: in the case that r is NULL,REF simply return a nasty negative
  if (r) {
    if (page_ref_count[REF_IDX(r)] != 0) {
    80000c3e:	77fd                	lui	a5,0xfffff
    80000c40:	8fe5                	and	a5,a5,s1
    80000c42:	80000737          	lui	a4,0x80000
    80000c46:	97ba                	add	a5,a5,a4
    80000c48:	00c7d693          	srli	a3,a5,0xc
    80000c4c:	83a9                	srli	a5,a5,0xa
    80000c4e:	00011717          	auipc	a4,0x11
    80000c52:	d1270713          	addi	a4,a4,-750 # 80011960 <page_ref_count>
    80000c56:	97ba                	add	a5,a5,a4
    80000c58:	438c                	lw	a1,0(a5)
    80000c5a:	ed99                	bnez	a1,80000c78 <kalloc+0x7c>
      printf("count %d\n", page_ref_count[REF_IDX(r)]);
      panic("incorrect ref count");
    }
    page_ref_count[REF_IDX(r)] = 1;
    80000c5c:	068a                	slli	a3,a3,0x2
    80000c5e:	00011797          	auipc	a5,0x11
    80000c62:	d0278793          	addi	a5,a5,-766 # 80011960 <page_ref_count>
    80000c66:	96be                	add	a3,a3,a5
    80000c68:	4785                	li	a5,1
    80000c6a:	c29c                	sw	a5,0(a3)
  }
  return (void *)r;
}
    80000c6c:	8526                	mv	a0,s1
    80000c6e:	60e2                	ld	ra,24(sp)
    80000c70:	6442                	ld	s0,16(sp)
    80000c72:	64a2                	ld	s1,8(sp)
    80000c74:	6105                	addi	sp,sp,32
    80000c76:	8082                	ret
      printf("count %d\n", page_ref_count[REF_IDX(r)]);
    80000c78:	00007517          	auipc	a0,0x7
    80000c7c:	43850513          	addi	a0,a0,1080 # 800080b0 <digits+0x48>
    80000c80:	00000097          	auipc	ra,0x0
    80000c84:	9b6080e7          	jalr	-1610(ra) # 80000636 <printf>
      panic("incorrect ref count");
    80000c88:	00007517          	auipc	a0,0x7
    80000c8c:	43850513          	addi	a0,a0,1080 # 800080c0 <digits+0x58>
    80000c90:	00000097          	auipc	ra,0x0
    80000c94:	954080e7          	jalr	-1708(ra) # 800005e4 <panic>
  release(&kmem.lock);
    80000c98:	00011517          	auipc	a0,0x11
    80000c9c:	ca850513          	addi	a0,a0,-856 # 80011940 <kmem>
    80000ca0:	00000097          	auipc	ra,0x0
    80000ca4:	14e080e7          	jalr	334(ra) # 80000dee <release>
  if (r) {
    80000ca8:	b7d1                	j	80000c6c <kalloc+0x70>

0000000080000caa <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000caa:	1141                	addi	sp,sp,-16
    80000cac:	e422                	sd	s0,8(sp)
    80000cae:	0800                	addi	s0,sp,16
  lk->name = name;
    80000cb0:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000cb2:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000cb6:	00053823          	sd	zero,16(a0)
}
    80000cba:	6422                	ld	s0,8(sp)
    80000cbc:	0141                	addi	sp,sp,16
    80000cbe:	8082                	ret

0000000080000cc0 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000cc0:	411c                	lw	a5,0(a0)
    80000cc2:	e399                	bnez	a5,80000cc8 <holding+0x8>
    80000cc4:	4501                	li	a0,0
  return r;
}
    80000cc6:	8082                	ret
{
    80000cc8:	1101                	addi	sp,sp,-32
    80000cca:	ec06                	sd	ra,24(sp)
    80000ccc:	e822                	sd	s0,16(sp)
    80000cce:	e426                	sd	s1,8(sp)
    80000cd0:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000cd2:	6904                	ld	s1,16(a0)
    80000cd4:	00001097          	auipc	ra,0x1
    80000cd8:	f76080e7          	jalr	-138(ra) # 80001c4a <mycpu>
    80000cdc:	40a48533          	sub	a0,s1,a0
    80000ce0:	00153513          	seqz	a0,a0
}
    80000ce4:	60e2                	ld	ra,24(sp)
    80000ce6:	6442                	ld	s0,16(sp)
    80000ce8:	64a2                	ld	s1,8(sp)
    80000cea:	6105                	addi	sp,sp,32
    80000cec:	8082                	ret

0000000080000cee <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000cee:	1101                	addi	sp,sp,-32
    80000cf0:	ec06                	sd	ra,24(sp)
    80000cf2:	e822                	sd	s0,16(sp)
    80000cf4:	e426                	sd	s1,8(sp)
    80000cf6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80000cf8:	100024f3          	csrr	s1,sstatus
    80000cfc:	100027f3          	csrr	a5,sstatus
static inline void intr_off() { w_sstatus(r_sstatus() & ~SSTATUS_SIE); }
    80000d00:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80000d02:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000d06:	00001097          	auipc	ra,0x1
    80000d0a:	f44080e7          	jalr	-188(ra) # 80001c4a <mycpu>
    80000d0e:	5d3c                	lw	a5,120(a0)
    80000d10:	cf89                	beqz	a5,80000d2a <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000d12:	00001097          	auipc	ra,0x1
    80000d16:	f38080e7          	jalr	-200(ra) # 80001c4a <mycpu>
    80000d1a:	5d3c                	lw	a5,120(a0)
    80000d1c:	2785                	addiw	a5,a5,1
    80000d1e:	dd3c                	sw	a5,120(a0)
}
    80000d20:	60e2                	ld	ra,24(sp)
    80000d22:	6442                	ld	s0,16(sp)
    80000d24:	64a2                	ld	s1,8(sp)
    80000d26:	6105                	addi	sp,sp,32
    80000d28:	8082                	ret
    mycpu()->intena = old;
    80000d2a:	00001097          	auipc	ra,0x1
    80000d2e:	f20080e7          	jalr	-224(ra) # 80001c4a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000d32:	8085                	srli	s1,s1,0x1
    80000d34:	8885                	andi	s1,s1,1
    80000d36:	dd64                	sw	s1,124(a0)
    80000d38:	bfe9                	j	80000d12 <push_off+0x24>

0000000080000d3a <acquire>:
{
    80000d3a:	1101                	addi	sp,sp,-32
    80000d3c:	ec06                	sd	ra,24(sp)
    80000d3e:	e822                	sd	s0,16(sp)
    80000d40:	e426                	sd	s1,8(sp)
    80000d42:	1000                	addi	s0,sp,32
    80000d44:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000d46:	00000097          	auipc	ra,0x0
    80000d4a:	fa8080e7          	jalr	-88(ra) # 80000cee <push_off>
  if(holding(lk))
    80000d4e:	8526                	mv	a0,s1
    80000d50:	00000097          	auipc	ra,0x0
    80000d54:	f70080e7          	jalr	-144(ra) # 80000cc0 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000d58:	4705                	li	a4,1
  if(holding(lk))
    80000d5a:	e115                	bnez	a0,80000d7e <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000d5c:	87ba                	mv	a5,a4
    80000d5e:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000d62:	2781                	sext.w	a5,a5
    80000d64:	ffe5                	bnez	a5,80000d5c <acquire+0x22>
  __sync_synchronize();
    80000d66:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000d6a:	00001097          	auipc	ra,0x1
    80000d6e:	ee0080e7          	jalr	-288(ra) # 80001c4a <mycpu>
    80000d72:	e888                	sd	a0,16(s1)
}
    80000d74:	60e2                	ld	ra,24(sp)
    80000d76:	6442                	ld	s0,16(sp)
    80000d78:	64a2                	ld	s1,8(sp)
    80000d7a:	6105                	addi	sp,sp,32
    80000d7c:	8082                	ret
    panic("acquire");
    80000d7e:	00007517          	auipc	a0,0x7
    80000d82:	35a50513          	addi	a0,a0,858 # 800080d8 <digits+0x70>
    80000d86:	00000097          	auipc	ra,0x0
    80000d8a:	85e080e7          	jalr	-1954(ra) # 800005e4 <panic>

0000000080000d8e <pop_off>:

void
pop_off(void)
{
    80000d8e:	1141                	addi	sp,sp,-16
    80000d90:	e406                	sd	ra,8(sp)
    80000d92:	e022                	sd	s0,0(sp)
    80000d94:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000d96:	00001097          	auipc	ra,0x1
    80000d9a:	eb4080e7          	jalr	-332(ra) # 80001c4a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80000d9e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000da2:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000da4:	e78d                	bnez	a5,80000dce <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000da6:	5d3c                	lw	a5,120(a0)
    80000da8:	02f05b63          	blez	a5,80000dde <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000dac:	37fd                	addiw	a5,a5,-1
    80000dae:	0007871b          	sext.w	a4,a5
    80000db2:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000db4:	eb09                	bnez	a4,80000dc6 <pop_off+0x38>
    80000db6:	5d7c                	lw	a5,124(a0)
    80000db8:	c799                	beqz	a5,80000dc6 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80000dba:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80000dbe:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80000dc2:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000dc6:	60a2                	ld	ra,8(sp)
    80000dc8:	6402                	ld	s0,0(sp)
    80000dca:	0141                	addi	sp,sp,16
    80000dcc:	8082                	ret
    panic("pop_off - interruptible");
    80000dce:	00007517          	auipc	a0,0x7
    80000dd2:	31250513          	addi	a0,a0,786 # 800080e0 <digits+0x78>
    80000dd6:	00000097          	auipc	ra,0x0
    80000dda:	80e080e7          	jalr	-2034(ra) # 800005e4 <panic>
    panic("pop_off");
    80000dde:	00007517          	auipc	a0,0x7
    80000de2:	31a50513          	addi	a0,a0,794 # 800080f8 <digits+0x90>
    80000de6:	fffff097          	auipc	ra,0xfffff
    80000dea:	7fe080e7          	jalr	2046(ra) # 800005e4 <panic>

0000000080000dee <release>:
{
    80000dee:	1101                	addi	sp,sp,-32
    80000df0:	ec06                	sd	ra,24(sp)
    80000df2:	e822                	sd	s0,16(sp)
    80000df4:	e426                	sd	s1,8(sp)
    80000df6:	1000                	addi	s0,sp,32
    80000df8:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000dfa:	00000097          	auipc	ra,0x0
    80000dfe:	ec6080e7          	jalr	-314(ra) # 80000cc0 <holding>
    80000e02:	c115                	beqz	a0,80000e26 <release+0x38>
  lk->cpu = 0;
    80000e04:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000e08:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000e0c:	0f50000f          	fence	iorw,ow
    80000e10:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000e14:	00000097          	auipc	ra,0x0
    80000e18:	f7a080e7          	jalr	-134(ra) # 80000d8e <pop_off>
}
    80000e1c:	60e2                	ld	ra,24(sp)
    80000e1e:	6442                	ld	s0,16(sp)
    80000e20:	64a2                	ld	s1,8(sp)
    80000e22:	6105                	addi	sp,sp,32
    80000e24:	8082                	ret
    panic("release");
    80000e26:	00007517          	auipc	a0,0x7
    80000e2a:	2da50513          	addi	a0,a0,730 # 80008100 <digits+0x98>
    80000e2e:	fffff097          	auipc	ra,0xfffff
    80000e32:	7b6080e7          	jalr	1974(ra) # 800005e4 <panic>

0000000080000e36 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000e36:	1141                	addi	sp,sp,-16
    80000e38:	e422                	sd	s0,8(sp)
    80000e3a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000e3c:	ca19                	beqz	a2,80000e52 <memset+0x1c>
    80000e3e:	87aa                	mv	a5,a0
    80000e40:	1602                	slli	a2,a2,0x20
    80000e42:	9201                	srli	a2,a2,0x20
    80000e44:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000e48:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000e4c:	0785                	addi	a5,a5,1
    80000e4e:	fee79de3          	bne	a5,a4,80000e48 <memset+0x12>
  }
  return dst;
}
    80000e52:	6422                	ld	s0,8(sp)
    80000e54:	0141                	addi	sp,sp,16
    80000e56:	8082                	ret

0000000080000e58 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000e58:	1141                	addi	sp,sp,-16
    80000e5a:	e422                	sd	s0,8(sp)
    80000e5c:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000e5e:	ca05                	beqz	a2,80000e8e <memcmp+0x36>
    80000e60:	fff6069b          	addiw	a3,a2,-1
    80000e64:	1682                	slli	a3,a3,0x20
    80000e66:	9281                	srli	a3,a3,0x20
    80000e68:	0685                	addi	a3,a3,1
    80000e6a:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000e6c:	00054783          	lbu	a5,0(a0)
    80000e70:	0005c703          	lbu	a4,0(a1)
    80000e74:	00e79863          	bne	a5,a4,80000e84 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000e78:	0505                	addi	a0,a0,1
    80000e7a:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000e7c:	fed518e3          	bne	a0,a3,80000e6c <memcmp+0x14>
  }

  return 0;
    80000e80:	4501                	li	a0,0
    80000e82:	a019                	j	80000e88 <memcmp+0x30>
      return *s1 - *s2;
    80000e84:	40e7853b          	subw	a0,a5,a4
}
    80000e88:	6422                	ld	s0,8(sp)
    80000e8a:	0141                	addi	sp,sp,16
    80000e8c:	8082                	ret
  return 0;
    80000e8e:	4501                	li	a0,0
    80000e90:	bfe5                	j	80000e88 <memcmp+0x30>

0000000080000e92 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000e92:	1141                	addi	sp,sp,-16
    80000e94:	e422                	sd	s0,8(sp)
    80000e96:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000e98:	02a5e563          	bltu	a1,a0,80000ec2 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000e9c:	fff6069b          	addiw	a3,a2,-1
    80000ea0:	ce11                	beqz	a2,80000ebc <memmove+0x2a>
    80000ea2:	1682                	slli	a3,a3,0x20
    80000ea4:	9281                	srli	a3,a3,0x20
    80000ea6:	0685                	addi	a3,a3,1
    80000ea8:	96ae                	add	a3,a3,a1
    80000eaa:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000eac:	0585                	addi	a1,a1,1
    80000eae:	0785                	addi	a5,a5,1
    80000eb0:	fff5c703          	lbu	a4,-1(a1)
    80000eb4:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000eb8:	fed59ae3          	bne	a1,a3,80000eac <memmove+0x1a>

  return dst;
}
    80000ebc:	6422                	ld	s0,8(sp)
    80000ebe:	0141                	addi	sp,sp,16
    80000ec0:	8082                	ret
  if(s < d && s + n > d){
    80000ec2:	02061713          	slli	a4,a2,0x20
    80000ec6:	9301                	srli	a4,a4,0x20
    80000ec8:	00e587b3          	add	a5,a1,a4
    80000ecc:	fcf578e3          	bgeu	a0,a5,80000e9c <memmove+0xa>
    d += n;
    80000ed0:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000ed2:	fff6069b          	addiw	a3,a2,-1
    80000ed6:	d27d                	beqz	a2,80000ebc <memmove+0x2a>
    80000ed8:	02069613          	slli	a2,a3,0x20
    80000edc:	9201                	srli	a2,a2,0x20
    80000ede:	fff64613          	not	a2,a2
    80000ee2:	963e                	add	a2,a2,a5
      *--d = *--s;
    80000ee4:	17fd                	addi	a5,a5,-1
    80000ee6:	177d                	addi	a4,a4,-1
    80000ee8:	0007c683          	lbu	a3,0(a5)
    80000eec:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000ef0:	fef61ae3          	bne	a2,a5,80000ee4 <memmove+0x52>
    80000ef4:	b7e1                	j	80000ebc <memmove+0x2a>

0000000080000ef6 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000ef6:	1141                	addi	sp,sp,-16
    80000ef8:	e406                	sd	ra,8(sp)
    80000efa:	e022                	sd	s0,0(sp)
    80000efc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000efe:	00000097          	auipc	ra,0x0
    80000f02:	f94080e7          	jalr	-108(ra) # 80000e92 <memmove>
}
    80000f06:	60a2                	ld	ra,8(sp)
    80000f08:	6402                	ld	s0,0(sp)
    80000f0a:	0141                	addi	sp,sp,16
    80000f0c:	8082                	ret

0000000080000f0e <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000f0e:	1141                	addi	sp,sp,-16
    80000f10:	e422                	sd	s0,8(sp)
    80000f12:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000f14:	ce11                	beqz	a2,80000f30 <strncmp+0x22>
    80000f16:	00054783          	lbu	a5,0(a0)
    80000f1a:	cf89                	beqz	a5,80000f34 <strncmp+0x26>
    80000f1c:	0005c703          	lbu	a4,0(a1)
    80000f20:	00f71a63          	bne	a4,a5,80000f34 <strncmp+0x26>
    n--, p++, q++;
    80000f24:	367d                	addiw	a2,a2,-1
    80000f26:	0505                	addi	a0,a0,1
    80000f28:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000f2a:	f675                	bnez	a2,80000f16 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000f2c:	4501                	li	a0,0
    80000f2e:	a809                	j	80000f40 <strncmp+0x32>
    80000f30:	4501                	li	a0,0
    80000f32:	a039                	j	80000f40 <strncmp+0x32>
  if(n == 0)
    80000f34:	ca09                	beqz	a2,80000f46 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000f36:	00054503          	lbu	a0,0(a0)
    80000f3a:	0005c783          	lbu	a5,0(a1)
    80000f3e:	9d1d                	subw	a0,a0,a5
}
    80000f40:	6422                	ld	s0,8(sp)
    80000f42:	0141                	addi	sp,sp,16
    80000f44:	8082                	ret
    return 0;
    80000f46:	4501                	li	a0,0
    80000f48:	bfe5                	j	80000f40 <strncmp+0x32>

0000000080000f4a <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000f4a:	1141                	addi	sp,sp,-16
    80000f4c:	e422                	sd	s0,8(sp)
    80000f4e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000f50:	872a                	mv	a4,a0
    80000f52:	8832                	mv	a6,a2
    80000f54:	367d                	addiw	a2,a2,-1
    80000f56:	01005963          	blez	a6,80000f68 <strncpy+0x1e>
    80000f5a:	0705                	addi	a4,a4,1
    80000f5c:	0005c783          	lbu	a5,0(a1)
    80000f60:	fef70fa3          	sb	a5,-1(a4)
    80000f64:	0585                	addi	a1,a1,1
    80000f66:	f7f5                	bnez	a5,80000f52 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000f68:	86ba                	mv	a3,a4
    80000f6a:	00c05c63          	blez	a2,80000f82 <strncpy+0x38>
    *s++ = 0;
    80000f6e:	0685                	addi	a3,a3,1
    80000f70:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000f74:	fff6c793          	not	a5,a3
    80000f78:	9fb9                	addw	a5,a5,a4
    80000f7a:	010787bb          	addw	a5,a5,a6
    80000f7e:	fef048e3          	bgtz	a5,80000f6e <strncpy+0x24>
  return os;
}
    80000f82:	6422                	ld	s0,8(sp)
    80000f84:	0141                	addi	sp,sp,16
    80000f86:	8082                	ret

0000000080000f88 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000f88:	1141                	addi	sp,sp,-16
    80000f8a:	e422                	sd	s0,8(sp)
    80000f8c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000f8e:	02c05363          	blez	a2,80000fb4 <safestrcpy+0x2c>
    80000f92:	fff6069b          	addiw	a3,a2,-1
    80000f96:	1682                	slli	a3,a3,0x20
    80000f98:	9281                	srli	a3,a3,0x20
    80000f9a:	96ae                	add	a3,a3,a1
    80000f9c:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000f9e:	00d58963          	beq	a1,a3,80000fb0 <safestrcpy+0x28>
    80000fa2:	0585                	addi	a1,a1,1
    80000fa4:	0785                	addi	a5,a5,1
    80000fa6:	fff5c703          	lbu	a4,-1(a1)
    80000faa:	fee78fa3          	sb	a4,-1(a5)
    80000fae:	fb65                	bnez	a4,80000f9e <safestrcpy+0x16>
    ;
  *s = 0;
    80000fb0:	00078023          	sb	zero,0(a5)
  return os;
}
    80000fb4:	6422                	ld	s0,8(sp)
    80000fb6:	0141                	addi	sp,sp,16
    80000fb8:	8082                	ret

0000000080000fba <strlen>:

int
strlen(const char *s)
{
    80000fba:	1141                	addi	sp,sp,-16
    80000fbc:	e422                	sd	s0,8(sp)
    80000fbe:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000fc0:	00054783          	lbu	a5,0(a0)
    80000fc4:	cf91                	beqz	a5,80000fe0 <strlen+0x26>
    80000fc6:	0505                	addi	a0,a0,1
    80000fc8:	87aa                	mv	a5,a0
    80000fca:	4685                	li	a3,1
    80000fcc:	9e89                	subw	a3,a3,a0
    80000fce:	00f6853b          	addw	a0,a3,a5
    80000fd2:	0785                	addi	a5,a5,1
    80000fd4:	fff7c703          	lbu	a4,-1(a5)
    80000fd8:	fb7d                	bnez	a4,80000fce <strlen+0x14>
    ;
  return n;
}
    80000fda:	6422                	ld	s0,8(sp)
    80000fdc:	0141                	addi	sp,sp,16
    80000fde:	8082                	ret
  for(n = 0; s[n]; n++)
    80000fe0:	4501                	li	a0,0
    80000fe2:	bfe5                	j	80000fda <strlen+0x20>

0000000080000fe4 <main>:
#include "types.h"

volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void main() {
    80000fe4:	1141                	addi	sp,sp,-16
    80000fe6:	e406                	sd	ra,8(sp)
    80000fe8:	e022                	sd	s0,0(sp)
    80000fea:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    80000fec:	00001097          	auipc	ra,0x1
    80000ff0:	c4e080e7          	jalr	-946(ra) # 80001c3a <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();         // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while (started == 0)
    80000ff4:	00008717          	auipc	a4,0x8
    80000ff8:	01870713          	addi	a4,a4,24 # 8000900c <started>
  if (cpuid() == 0) {
    80000ffc:	c139                	beqz	a0,80001042 <main+0x5e>
    while (started == 0)
    80000ffe:	431c                	lw	a5,0(a4)
    80001000:	2781                	sext.w	a5,a5
    80001002:	dff5                	beqz	a5,80000ffe <main+0x1a>
      ;
    __sync_synchronize();
    80001004:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80001008:	00001097          	auipc	ra,0x1
    8000100c:	c32080e7          	jalr	-974(ra) # 80001c3a <cpuid>
    80001010:	85aa                	mv	a1,a0
    80001012:	00007517          	auipc	a0,0x7
    80001016:	10e50513          	addi	a0,a0,270 # 80008120 <digits+0xb8>
    8000101a:	fffff097          	auipc	ra,0xfffff
    8000101e:	61c080e7          	jalr	1564(ra) # 80000636 <printf>
    kvminithart();  // turn on paging
    80001022:	00000097          	auipc	ra,0x0
    80001026:	0d8080e7          	jalr	216(ra) # 800010fa <kvminithart>
    trapinithart(); // install kernel trap vector
    8000102a:	00002097          	auipc	ra,0x2
    8000102e:	896080e7          	jalr	-1898(ra) # 800028c0 <trapinithart>
    plicinithart(); // ask PLIC for device interrupts
    80001032:	00005097          	auipc	ra,0x5
    80001036:	f1e080e7          	jalr	-226(ra) # 80005f50 <plicinithart>
  }

  scheduler();
    8000103a:	00001097          	auipc	ra,0x1
    8000103e:	160080e7          	jalr	352(ra) # 8000219a <scheduler>
    consoleinit();
    80001042:	fffff097          	auipc	ra,0xfffff
    80001046:	412080e7          	jalr	1042(ra) # 80000454 <consoleinit>
    printfinit();
    8000104a:	fffff097          	auipc	ra,0xfffff
    8000104e:	4f8080e7          	jalr	1272(ra) # 80000542 <printfinit>
    printf("\n");
    80001052:	00007517          	auipc	a0,0x7
    80001056:	06650513          	addi	a0,a0,102 # 800080b8 <digits+0x50>
    8000105a:	fffff097          	auipc	ra,0xfffff
    8000105e:	5dc080e7          	jalr	1500(ra) # 80000636 <printf>
    printf("xv6 kernel is booting\n");
    80001062:	00007517          	auipc	a0,0x7
    80001066:	0a650513          	addi	a0,a0,166 # 80008108 <digits+0xa0>
    8000106a:	fffff097          	auipc	ra,0xfffff
    8000106e:	5cc080e7          	jalr	1484(ra) # 80000636 <printf>
    printf("\n");
    80001072:	00007517          	auipc	a0,0x7
    80001076:	04650513          	addi	a0,a0,70 # 800080b8 <digits+0x50>
    8000107a:	fffff097          	auipc	ra,0xfffff
    8000107e:	5bc080e7          	jalr	1468(ra) # 80000636 <printf>
    kinit();            // physical page allocator
    80001082:	00000097          	auipc	ra,0x0
    80001086:	b24080e7          	jalr	-1244(ra) # 80000ba6 <kinit>
    kvminit();          // create kernel page table
    8000108a:	00000097          	auipc	ra,0x0
    8000108e:	296080e7          	jalr	662(ra) # 80001320 <kvminit>
    kvminithart();      // turn on paging
    80001092:	00000097          	auipc	ra,0x0
    80001096:	068080e7          	jalr	104(ra) # 800010fa <kvminithart>
    procinit();         // process table
    8000109a:	00001097          	auipc	ra,0x1
    8000109e:	ad0080e7          	jalr	-1328(ra) # 80001b6a <procinit>
    trapinit();         // trap vectors
    800010a2:	00001097          	auipc	ra,0x1
    800010a6:	7f6080e7          	jalr	2038(ra) # 80002898 <trapinit>
    trapinithart();     // install kernel trap vector
    800010aa:	00002097          	auipc	ra,0x2
    800010ae:	816080e7          	jalr	-2026(ra) # 800028c0 <trapinithart>
    plicinit();         // set up interrupt controller
    800010b2:	00005097          	auipc	ra,0x5
    800010b6:	e88080e7          	jalr	-376(ra) # 80005f3a <plicinit>
    plicinithart();     // ask PLIC for device interrupts
    800010ba:	00005097          	auipc	ra,0x5
    800010be:	e96080e7          	jalr	-362(ra) # 80005f50 <plicinithart>
    binit();            // buffer cache
    800010c2:	00002097          	auipc	ra,0x2
    800010c6:	03a080e7          	jalr	58(ra) # 800030fc <binit>
    iinit();            // inode cache
    800010ca:	00002097          	auipc	ra,0x2
    800010ce:	6ca080e7          	jalr	1738(ra) # 80003794 <iinit>
    fileinit();         // file table
    800010d2:	00003097          	auipc	ra,0x3
    800010d6:	668080e7          	jalr	1640(ra) # 8000473a <fileinit>
    virtio_disk_init(); // emulated hard disk
    800010da:	00005097          	auipc	ra,0x5
    800010de:	f7e080e7          	jalr	-130(ra) # 80006058 <virtio_disk_init>
    userinit();         // first user process
    800010e2:	00001097          	auipc	ra,0x1
    800010e6:	e4e080e7          	jalr	-434(ra) # 80001f30 <userinit>
    __sync_synchronize();
    800010ea:	0ff0000f          	fence
    started = 1;
    800010ee:	4785                	li	a5,1
    800010f0:	00008717          	auipc	a4,0x8
    800010f4:	f0f72e23          	sw	a5,-228(a4) # 8000900c <started>
    800010f8:	b789                	j	8000103a <main+0x56>

00000000800010fa <kvminithart>:
  kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
}

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void kvminithart() {
    800010fa:	1141                	addi	sp,sp,-16
    800010fc:	e422                	sd	s0,8(sp)
    800010fe:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80001100:	00008797          	auipc	a5,0x8
    80001104:	f107b783          	ld	a5,-240(a5) # 80009010 <kernel_pagetable>
    80001108:	83b1                	srli	a5,a5,0xc
    8000110a:	577d                	li	a4,-1
    8000110c:	177e                	slli	a4,a4,0x3f
    8000110e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r"(x));
    80001110:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80001114:	12000073          	sfence.vma
  sfence_vma();
}
    80001118:	6422                	ld	s0,8(sp)
    8000111a:	0141                	addi	sp,sp,16
    8000111c:	8082                	ret

000000008000111e <walk>:
//   30..38 -- 9 bits of level-2 index.
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *walk(pagetable_t pagetable, uint64 va, int alloc) {
  if (va >= MAXVA)
    8000111e:	57fd                	li	a5,-1
    80001120:	83e9                	srli	a5,a5,0x1a
    80001122:	08b7e863          	bltu	a5,a1,800011b2 <walk+0x94>
pte_t *walk(pagetable_t pagetable, uint64 va, int alloc) {
    80001126:	7139                	addi	sp,sp,-64
    80001128:	fc06                	sd	ra,56(sp)
    8000112a:	f822                	sd	s0,48(sp)
    8000112c:	f426                	sd	s1,40(sp)
    8000112e:	f04a                	sd	s2,32(sp)
    80001130:	ec4e                	sd	s3,24(sp)
    80001132:	e852                	sd	s4,16(sp)
    80001134:	e456                	sd	s5,8(sp)
    80001136:	e05a                	sd	s6,0(sp)
    80001138:	0080                	addi	s0,sp,64
    8000113a:	84aa                	mv	s1,a0
    8000113c:	89ae                	mv	s3,a1
    8000113e:	8ab2                	mv	s5,a2
    80001140:	4a79                	li	s4,30
    return 0;

  for (int level = 2; level > 0; level--) {
    80001142:	4b31                	li	s6,12
    80001144:	a80d                	j	80001176 <walk+0x58>
    pte_t *pte = &pagetable[PX(level, va)];
    if (*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    80001146:	060a8863          	beqz	s5,800011b6 <walk+0x98>
    8000114a:	00000097          	auipc	ra,0x0
    8000114e:	ab2080e7          	jalr	-1358(ra) # 80000bfc <kalloc>
    80001152:	84aa                	mv	s1,a0
    80001154:	c529                	beqz	a0,8000119e <walk+0x80>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80001156:	6605                	lui	a2,0x1
    80001158:	4581                	li	a1,0
    8000115a:	00000097          	auipc	ra,0x0
    8000115e:	cdc080e7          	jalr	-804(ra) # 80000e36 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001162:	00c4d793          	srli	a5,s1,0xc
    80001166:	07aa                	slli	a5,a5,0xa
    80001168:	0017e793          	ori	a5,a5,1
    8000116c:	00f93023          	sd	a5,0(s2)
  for (int level = 2; level > 0; level--) {
    80001170:	3a5d                	addiw	s4,s4,-9
    80001172:	036a0063          	beq	s4,s6,80001192 <walk+0x74>
    pte_t *pte = &pagetable[PX(level, va)];
    80001176:	0149d933          	srl	s2,s3,s4
    8000117a:	1ff97913          	andi	s2,s2,511
    8000117e:	090e                	slli	s2,s2,0x3
    80001180:	9926                	add	s2,s2,s1
    if (*pte & PTE_V) {
    80001182:	00093483          	ld	s1,0(s2)
    80001186:	0014f793          	andi	a5,s1,1
    8000118a:	dfd5                	beqz	a5,80001146 <walk+0x28>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000118c:	80a9                	srli	s1,s1,0xa
    8000118e:	04b2                	slli	s1,s1,0xc
    80001190:	b7c5                	j	80001170 <walk+0x52>
    }
  }
  return &pagetable[PX(0, va)];
    80001192:	00c9d513          	srli	a0,s3,0xc
    80001196:	1ff57513          	andi	a0,a0,511
    8000119a:	050e                	slli	a0,a0,0x3
    8000119c:	9526                	add	a0,a0,s1
}
    8000119e:	70e2                	ld	ra,56(sp)
    800011a0:	7442                	ld	s0,48(sp)
    800011a2:	74a2                	ld	s1,40(sp)
    800011a4:	7902                	ld	s2,32(sp)
    800011a6:	69e2                	ld	s3,24(sp)
    800011a8:	6a42                	ld	s4,16(sp)
    800011aa:	6aa2                	ld	s5,8(sp)
    800011ac:	6b02                	ld	s6,0(sp)
    800011ae:	6121                	addi	sp,sp,64
    800011b0:	8082                	ret
    return 0;
    800011b2:	4501                	li	a0,0
}
    800011b4:	8082                	ret
        return 0;
    800011b6:	4501                	li	a0,0
    800011b8:	b7dd                	j	8000119e <walk+0x80>

00000000800011ba <walkaddr>:
// Can only be used to look up user pages.
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA)
    800011ba:	57fd                	li	a5,-1
    800011bc:	83e9                	srli	a5,a5,0x1a
    800011be:	00b7f463          	bgeu	a5,a1,800011c6 <walkaddr+0xc>
    return 0;
    800011c2:	4501                	li	a0,0
    return 0;
  if ((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800011c4:	8082                	ret
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
    800011c6:	1141                	addi	sp,sp,-16
    800011c8:	e406                	sd	ra,8(sp)
    800011ca:	e022                	sd	s0,0(sp)
    800011cc:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800011ce:	4601                	li	a2,0
    800011d0:	00000097          	auipc	ra,0x0
    800011d4:	f4e080e7          	jalr	-178(ra) # 8000111e <walk>
  if (pte == 0)
    800011d8:	c105                	beqz	a0,800011f8 <walkaddr+0x3e>
  if ((*pte & PTE_V) == 0)
    800011da:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0)
    800011dc:	0117f693          	andi	a3,a5,17
    800011e0:	4745                	li	a4,17
    return 0;
    800011e2:	4501                	li	a0,0
  if ((*pte & PTE_U) == 0)
    800011e4:	00e68663          	beq	a3,a4,800011f0 <walkaddr+0x36>
}
    800011e8:	60a2                	ld	ra,8(sp)
    800011ea:	6402                	ld	s0,0(sp)
    800011ec:	0141                	addi	sp,sp,16
    800011ee:	8082                	ret
  pa = PTE2PA(*pte);
    800011f0:	00a7d513          	srli	a0,a5,0xa
    800011f4:	0532                	slli	a0,a0,0xc
  return pa;
    800011f6:	bfcd                	j	800011e8 <walkaddr+0x2e>
    return 0;
    800011f8:	4501                	li	a0,0
    800011fa:	b7fd                	j	800011e8 <walkaddr+0x2e>

00000000800011fc <kvmpa>:

// translate a kernel virtual address to
// a physical address. only needed for
// addresses on the stack.
// assumes va is page aligned.
uint64 kvmpa(uint64 va) {
    800011fc:	1101                	addi	sp,sp,-32
    800011fe:	ec06                	sd	ra,24(sp)
    80001200:	e822                	sd	s0,16(sp)
    80001202:	e426                	sd	s1,8(sp)
    80001204:	1000                	addi	s0,sp,32
    80001206:	85aa                	mv	a1,a0
  uint64 off = va % PGSIZE;
    80001208:	1552                	slli	a0,a0,0x34
    8000120a:	03455493          	srli	s1,a0,0x34
  pte_t *pte;
  uint64 pa;

  pte = walk(kernel_pagetable, va, 0);
    8000120e:	4601                	li	a2,0
    80001210:	00008517          	auipc	a0,0x8
    80001214:	e0053503          	ld	a0,-512(a0) # 80009010 <kernel_pagetable>
    80001218:	00000097          	auipc	ra,0x0
    8000121c:	f06080e7          	jalr	-250(ra) # 8000111e <walk>
  if (pte == 0)
    80001220:	cd09                	beqz	a0,8000123a <kvmpa+0x3e>
    panic("kvmpa");
  if ((*pte & PTE_V) == 0)
    80001222:	6108                	ld	a0,0(a0)
    80001224:	00157793          	andi	a5,a0,1
    80001228:	c38d                	beqz	a5,8000124a <kvmpa+0x4e>
    panic("kvmpa");
  pa = PTE2PA(*pte);
    8000122a:	8129                	srli	a0,a0,0xa
    8000122c:	0532                	slli	a0,a0,0xc
  return pa + off;
}
    8000122e:	9526                	add	a0,a0,s1
    80001230:	60e2                	ld	ra,24(sp)
    80001232:	6442                	ld	s0,16(sp)
    80001234:	64a2                	ld	s1,8(sp)
    80001236:	6105                	addi	sp,sp,32
    80001238:	8082                	ret
    panic("kvmpa");
    8000123a:	00007517          	auipc	a0,0x7
    8000123e:	efe50513          	addi	a0,a0,-258 # 80008138 <digits+0xd0>
    80001242:	fffff097          	auipc	ra,0xfffff
    80001246:	3a2080e7          	jalr	930(ra) # 800005e4 <panic>
    panic("kvmpa");
    8000124a:	00007517          	auipc	a0,0x7
    8000124e:	eee50513          	addi	a0,a0,-274 # 80008138 <digits+0xd0>
    80001252:	fffff097          	auipc	ra,0xfffff
    80001256:	392080e7          	jalr	914(ra) # 800005e4 <panic>

000000008000125a <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa,
             int perm) {
    8000125a:	715d                	addi	sp,sp,-80
    8000125c:	e486                	sd	ra,72(sp)
    8000125e:	e0a2                	sd	s0,64(sp)
    80001260:	fc26                	sd	s1,56(sp)
    80001262:	f84a                	sd	s2,48(sp)
    80001264:	f44e                	sd	s3,40(sp)
    80001266:	f052                	sd	s4,32(sp)
    80001268:	ec56                	sd	s5,24(sp)
    8000126a:	e85a                	sd	s6,16(sp)
    8000126c:	e45e                	sd	s7,8(sp)
    8000126e:	0880                	addi	s0,sp,80
    80001270:	8aaa                	mv	s5,a0
    80001272:	8b3a                	mv	s6,a4
  uint64 a, last;
  pte_t *pte;

  a = PGROUNDDOWN(va);
    80001274:	777d                	lui	a4,0xfffff
    80001276:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000127a:	167d                	addi	a2,a2,-1
    8000127c:	00b609b3          	add	s3,a2,a1
    80001280:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80001284:	893e                	mv	s2,a5
    80001286:	40f68a33          	sub	s4,a3,a5
    if (*pte & PTE_V)
      panic("remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last)
      break;
    a += PGSIZE;
    8000128a:	6b85                	lui	s7,0x1
    8000128c:	012a04b3          	add	s1,s4,s2
    if ((pte = walk(pagetable, a, 1)) == 0)
    80001290:	4605                	li	a2,1
    80001292:	85ca                	mv	a1,s2
    80001294:	8556                	mv	a0,s5
    80001296:	00000097          	auipc	ra,0x0
    8000129a:	e88080e7          	jalr	-376(ra) # 8000111e <walk>
    8000129e:	c51d                	beqz	a0,800012cc <mappages+0x72>
    if (*pte & PTE_V)
    800012a0:	611c                	ld	a5,0(a0)
    800012a2:	8b85                	andi	a5,a5,1
    800012a4:	ef81                	bnez	a5,800012bc <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800012a6:	80b1                	srli	s1,s1,0xc
    800012a8:	04aa                	slli	s1,s1,0xa
    800012aa:	0164e4b3          	or	s1,s1,s6
    800012ae:	0014e493          	ori	s1,s1,1
    800012b2:	e104                	sd	s1,0(a0)
    if (a == last)
    800012b4:	03390863          	beq	s2,s3,800012e4 <mappages+0x8a>
    a += PGSIZE;
    800012b8:	995e                	add	s2,s2,s7
    if ((pte = walk(pagetable, a, 1)) == 0)
    800012ba:	bfc9                	j	8000128c <mappages+0x32>
      panic("remap");
    800012bc:	00007517          	auipc	a0,0x7
    800012c0:	e8450513          	addi	a0,a0,-380 # 80008140 <digits+0xd8>
    800012c4:	fffff097          	auipc	ra,0xfffff
    800012c8:	320080e7          	jalr	800(ra) # 800005e4 <panic>
      return -1;
    800012cc:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800012ce:	60a6                	ld	ra,72(sp)
    800012d0:	6406                	ld	s0,64(sp)
    800012d2:	74e2                	ld	s1,56(sp)
    800012d4:	7942                	ld	s2,48(sp)
    800012d6:	79a2                	ld	s3,40(sp)
    800012d8:	7a02                	ld	s4,32(sp)
    800012da:	6ae2                	ld	s5,24(sp)
    800012dc:	6b42                	ld	s6,16(sp)
    800012de:	6ba2                	ld	s7,8(sp)
    800012e0:	6161                	addi	sp,sp,80
    800012e2:	8082                	ret
  return 0;
    800012e4:	4501                	li	a0,0
    800012e6:	b7e5                	j	800012ce <mappages+0x74>

00000000800012e8 <kvmmap>:
void kvmmap(uint64 va, uint64 pa, uint64 sz, int perm) {
    800012e8:	1141                	addi	sp,sp,-16
    800012ea:	e406                	sd	ra,8(sp)
    800012ec:	e022                	sd	s0,0(sp)
    800012ee:	0800                	addi	s0,sp,16
    800012f0:	8736                	mv	a4,a3
  if (mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    800012f2:	86ae                	mv	a3,a1
    800012f4:	85aa                	mv	a1,a0
    800012f6:	00008517          	auipc	a0,0x8
    800012fa:	d1a53503          	ld	a0,-742(a0) # 80009010 <kernel_pagetable>
    800012fe:	00000097          	auipc	ra,0x0
    80001302:	f5c080e7          	jalr	-164(ra) # 8000125a <mappages>
    80001306:	e509                	bnez	a0,80001310 <kvmmap+0x28>
}
    80001308:	60a2                	ld	ra,8(sp)
    8000130a:	6402                	ld	s0,0(sp)
    8000130c:	0141                	addi	sp,sp,16
    8000130e:	8082                	ret
    panic("kvmmap");
    80001310:	00007517          	auipc	a0,0x7
    80001314:	e3850513          	addi	a0,a0,-456 # 80008148 <digits+0xe0>
    80001318:	fffff097          	auipc	ra,0xfffff
    8000131c:	2cc080e7          	jalr	716(ra) # 800005e4 <panic>

0000000080001320 <kvminit>:
void kvminit() {
    80001320:	1101                	addi	sp,sp,-32
    80001322:	ec06                	sd	ra,24(sp)
    80001324:	e822                	sd	s0,16(sp)
    80001326:	e426                	sd	s1,8(sp)
    80001328:	1000                	addi	s0,sp,32
  kernel_pagetable = (pagetable_t)kalloc();
    8000132a:	00000097          	auipc	ra,0x0
    8000132e:	8d2080e7          	jalr	-1838(ra) # 80000bfc <kalloc>
    80001332:	00008797          	auipc	a5,0x8
    80001336:	cca7bf23          	sd	a0,-802(a5) # 80009010 <kernel_pagetable>
  memset(kernel_pagetable, 0, PGSIZE);
    8000133a:	6605                	lui	a2,0x1
    8000133c:	4581                	li	a1,0
    8000133e:	00000097          	auipc	ra,0x0
    80001342:	af8080e7          	jalr	-1288(ra) # 80000e36 <memset>
  kvmmap(UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001346:	4699                	li	a3,6
    80001348:	6605                	lui	a2,0x1
    8000134a:	100005b7          	lui	a1,0x10000
    8000134e:	10000537          	lui	a0,0x10000
    80001352:	00000097          	auipc	ra,0x0
    80001356:	f96080e7          	jalr	-106(ra) # 800012e8 <kvmmap>
  kvmmap(VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000135a:	4699                	li	a3,6
    8000135c:	6605                	lui	a2,0x1
    8000135e:	100015b7          	lui	a1,0x10001
    80001362:	10001537          	lui	a0,0x10001
    80001366:	00000097          	auipc	ra,0x0
    8000136a:	f82080e7          	jalr	-126(ra) # 800012e8 <kvmmap>
  kvmmap(CLINT, CLINT, 0x10000, PTE_R | PTE_W);
    8000136e:	4699                	li	a3,6
    80001370:	6641                	lui	a2,0x10
    80001372:	020005b7          	lui	a1,0x2000
    80001376:	02000537          	lui	a0,0x2000
    8000137a:	00000097          	auipc	ra,0x0
    8000137e:	f6e080e7          	jalr	-146(ra) # 800012e8 <kvmmap>
  kvmmap(PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001382:	4699                	li	a3,6
    80001384:	00400637          	lui	a2,0x400
    80001388:	0c0005b7          	lui	a1,0xc000
    8000138c:	0c000537          	lui	a0,0xc000
    80001390:	00000097          	auipc	ra,0x0
    80001394:	f58080e7          	jalr	-168(ra) # 800012e8 <kvmmap>
  kvmmap(KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    80001398:	00007497          	auipc	s1,0x7
    8000139c:	c6848493          	addi	s1,s1,-920 # 80008000 <etext>
    800013a0:	46a9                	li	a3,10
    800013a2:	80007617          	auipc	a2,0x80007
    800013a6:	c5e60613          	addi	a2,a2,-930 # 8000 <_entry-0x7fff8000>
    800013aa:	4585                	li	a1,1
    800013ac:	05fe                	slli	a1,a1,0x1f
    800013ae:	852e                	mv	a0,a1
    800013b0:	00000097          	auipc	ra,0x0
    800013b4:	f38080e7          	jalr	-200(ra) # 800012e8 <kvmmap>
  kvmmap((uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext, PTE_R | PTE_W);
    800013b8:	4699                	li	a3,6
    800013ba:	4645                	li	a2,17
    800013bc:	066e                	slli	a2,a2,0x1b
    800013be:	8e05                	sub	a2,a2,s1
    800013c0:	85a6                	mv	a1,s1
    800013c2:	8526                	mv	a0,s1
    800013c4:	00000097          	auipc	ra,0x0
    800013c8:	f24080e7          	jalr	-220(ra) # 800012e8 <kvmmap>
  kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800013cc:	46a9                	li	a3,10
    800013ce:	6605                	lui	a2,0x1
    800013d0:	00006597          	auipc	a1,0x6
    800013d4:	c3058593          	addi	a1,a1,-976 # 80007000 <_trampoline>
    800013d8:	04000537          	lui	a0,0x4000
    800013dc:	157d                	addi	a0,a0,-1
    800013de:	0532                	slli	a0,a0,0xc
    800013e0:	00000097          	auipc	ra,0x0
    800013e4:	f08080e7          	jalr	-248(ra) # 800012e8 <kvmmap>
}
    800013e8:	60e2                	ld	ra,24(sp)
    800013ea:	6442                	ld	s0,16(sp)
    800013ec:	64a2                	ld	s1,8(sp)
    800013ee:	6105                	addi	sp,sp,32
    800013f0:	8082                	ret

00000000800013f2 <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free) {
    800013f2:	715d                	addi	sp,sp,-80
    800013f4:	e486                	sd	ra,72(sp)
    800013f6:	e0a2                	sd	s0,64(sp)
    800013f8:	fc26                	sd	s1,56(sp)
    800013fa:	f84a                	sd	s2,48(sp)
    800013fc:	f44e                	sd	s3,40(sp)
    800013fe:	f052                	sd	s4,32(sp)
    80001400:	ec56                	sd	s5,24(sp)
    80001402:	e85a                	sd	s6,16(sp)
    80001404:	e45e                	sd	s7,8(sp)
    80001406:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  // printf("va %p npages %d\n", va, npages);
  if ((va % PGSIZE) != 0)
    80001408:	03459793          	slli	a5,a1,0x34
    8000140c:	e795                	bnez	a5,80001438 <uvmunmap+0x46>
    8000140e:	8a2a                	mv	s4,a0
    80001410:	892e                	mv	s2,a1
    80001412:	8b36                	mv	s6,a3
    panic("uvmunmap: not aligned");
  // int total = 0;
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80001414:	0632                	slli	a2,a2,0xc
    80001416:	00b609b3          	add	s3,a2,a1
      continue;
    // panic("uvmunmap: walk");
    if ((*pte & PTE_V) == 0)
      continue;
    // panic("uvmunmap: not mapped");
    if (PTE_FLAGS(*pte) == PTE_V)
    8000141a:	4b85                	li	s7,1
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    8000141c:	6a85                	lui	s5,0x1
    8000141e:	0535e263          	bltu	a1,s3,80001462 <uvmunmap+0x70>
  }
  // if (myproc()->pid == 5) {
  //   backtrace();
  //   printf("sz %p pages %d  freed pages %d\n", myproc()->sz, npages, total);
  // }
}
    80001422:	60a6                	ld	ra,72(sp)
    80001424:	6406                	ld	s0,64(sp)
    80001426:	74e2                	ld	s1,56(sp)
    80001428:	7942                	ld	s2,48(sp)
    8000142a:	79a2                	ld	s3,40(sp)
    8000142c:	7a02                	ld	s4,32(sp)
    8000142e:	6ae2                	ld	s5,24(sp)
    80001430:	6b42                	ld	s6,16(sp)
    80001432:	6ba2                	ld	s7,8(sp)
    80001434:	6161                	addi	sp,sp,80
    80001436:	8082                	ret
    panic("uvmunmap: not aligned");
    80001438:	00007517          	auipc	a0,0x7
    8000143c:	d1850513          	addi	a0,a0,-744 # 80008150 <digits+0xe8>
    80001440:	fffff097          	auipc	ra,0xfffff
    80001444:	1a4080e7          	jalr	420(ra) # 800005e4 <panic>
      panic("uvmunmap: not a leaf");
    80001448:	00007517          	auipc	a0,0x7
    8000144c:	d2050513          	addi	a0,a0,-736 # 80008168 <digits+0x100>
    80001450:	fffff097          	auipc	ra,0xfffff
    80001454:	194080e7          	jalr	404(ra) # 800005e4 <panic>
    *pte = 0;
    80001458:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    8000145c:	9956                	add	s2,s2,s5
    8000145e:	fd3972e3          	bgeu	s2,s3,80001422 <uvmunmap+0x30>
    if ((pte = walk(pagetable, a, 0)) == 0)
    80001462:	4601                	li	a2,0
    80001464:	85ca                	mv	a1,s2
    80001466:	8552                	mv	a0,s4
    80001468:	00000097          	auipc	ra,0x0
    8000146c:	cb6080e7          	jalr	-842(ra) # 8000111e <walk>
    80001470:	84aa                	mv	s1,a0
    80001472:	d56d                	beqz	a0,8000145c <uvmunmap+0x6a>
    if ((*pte & PTE_V) == 0)
    80001474:	611c                	ld	a5,0(a0)
    80001476:	0017f713          	andi	a4,a5,1
    8000147a:	d36d                	beqz	a4,8000145c <uvmunmap+0x6a>
    if (PTE_FLAGS(*pte) == PTE_V)
    8000147c:	3ff7f713          	andi	a4,a5,1023
    80001480:	fd7704e3          	beq	a4,s7,80001448 <uvmunmap+0x56>
    if (do_free) {
    80001484:	fc0b0ae3          	beqz	s6,80001458 <uvmunmap+0x66>
      uint64 pa = PTE2PA(*pte);
    80001488:	83a9                	srli	a5,a5,0xa
      kfree((void *)pa);
    8000148a:	00c79513          	slli	a0,a5,0xc
    8000148e:	fffff097          	auipc	ra,0xfffff
    80001492:	5fc080e7          	jalr	1532(ra) # 80000a8a <kfree>
    80001496:	b7c9                	j	80001458 <uvmunmap+0x66>

0000000080001498 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t uvmcreate() {
    80001498:	1101                	addi	sp,sp,-32
    8000149a:	ec06                	sd	ra,24(sp)
    8000149c:	e822                	sd	s0,16(sp)
    8000149e:	e426                	sd	s1,8(sp)
    800014a0:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    800014a2:	fffff097          	auipc	ra,0xfffff
    800014a6:	75a080e7          	jalr	1882(ra) # 80000bfc <kalloc>
    800014aa:	84aa                	mv	s1,a0
  if (pagetable == 0)
    800014ac:	c519                	beqz	a0,800014ba <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800014ae:	6605                	lui	a2,0x1
    800014b0:	4581                	li	a1,0
    800014b2:	00000097          	auipc	ra,0x0
    800014b6:	984080e7          	jalr	-1660(ra) # 80000e36 <memset>
  return pagetable;
}
    800014ba:	8526                	mv	a0,s1
    800014bc:	60e2                	ld	ra,24(sp)
    800014be:	6442                	ld	s0,16(sp)
    800014c0:	64a2                	ld	s1,8(sp)
    800014c2:	6105                	addi	sp,sp,32
    800014c4:	8082                	ret

00000000800014c6 <uvminit>:

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvminit(pagetable_t pagetable, uchar *src, uint sz) {
    800014c6:	7179                	addi	sp,sp,-48
    800014c8:	f406                	sd	ra,40(sp)
    800014ca:	f022                	sd	s0,32(sp)
    800014cc:	ec26                	sd	s1,24(sp)
    800014ce:	e84a                	sd	s2,16(sp)
    800014d0:	e44e                	sd	s3,8(sp)
    800014d2:	e052                	sd	s4,0(sp)
    800014d4:	1800                	addi	s0,sp,48
  char *mem;

  if (sz >= PGSIZE)
    800014d6:	6785                	lui	a5,0x1
    800014d8:	04f67863          	bgeu	a2,a5,80001528 <uvminit+0x62>
    800014dc:	8a2a                	mv	s4,a0
    800014de:	89ae                	mv	s3,a1
    800014e0:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    800014e2:	fffff097          	auipc	ra,0xfffff
    800014e6:	71a080e7          	jalr	1818(ra) # 80000bfc <kalloc>
    800014ea:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800014ec:	6605                	lui	a2,0x1
    800014ee:	4581                	li	a1,0
    800014f0:	00000097          	auipc	ra,0x0
    800014f4:	946080e7          	jalr	-1722(ra) # 80000e36 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    800014f8:	4779                	li	a4,30
    800014fa:	86ca                	mv	a3,s2
    800014fc:	6605                	lui	a2,0x1
    800014fe:	4581                	li	a1,0
    80001500:	8552                	mv	a0,s4
    80001502:	00000097          	auipc	ra,0x0
    80001506:	d58080e7          	jalr	-680(ra) # 8000125a <mappages>
  memmove(mem, src, sz);
    8000150a:	8626                	mv	a2,s1
    8000150c:	85ce                	mv	a1,s3
    8000150e:	854a                	mv	a0,s2
    80001510:	00000097          	auipc	ra,0x0
    80001514:	982080e7          	jalr	-1662(ra) # 80000e92 <memmove>
}
    80001518:	70a2                	ld	ra,40(sp)
    8000151a:	7402                	ld	s0,32(sp)
    8000151c:	64e2                	ld	s1,24(sp)
    8000151e:	6942                	ld	s2,16(sp)
    80001520:	69a2                	ld	s3,8(sp)
    80001522:	6a02                	ld	s4,0(sp)
    80001524:	6145                	addi	sp,sp,48
    80001526:	8082                	ret
    panic("inituvm: more than a page");
    80001528:	00007517          	auipc	a0,0x7
    8000152c:	c5850513          	addi	a0,a0,-936 # 80008180 <digits+0x118>
    80001530:	fffff097          	auipc	ra,0xfffff
    80001534:	0b4080e7          	jalr	180(ra) # 800005e4 <panic>

0000000080001538 <uvmdealloc>:

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64 uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz) {
    80001538:	1101                	addi	sp,sp,-32
    8000153a:	ec06                	sd	ra,24(sp)
    8000153c:	e822                	sd	s0,16(sp)
    8000153e:	e426                	sd	s1,8(sp)
    80001540:	1000                	addi	s0,sp,32
  if (newsz >= oldsz)
    return oldsz;
    80001542:	84ae                	mv	s1,a1
  if (newsz >= oldsz)
    80001544:	00b67d63          	bgeu	a2,a1,8000155e <uvmdealloc+0x26>
    80001548:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
    8000154a:	6785                	lui	a5,0x1
    8000154c:	17fd                	addi	a5,a5,-1
    8000154e:	00f60733          	add	a4,a2,a5
    80001552:	767d                	lui	a2,0xfffff
    80001554:	8f71                	and	a4,a4,a2
    80001556:	97ae                	add	a5,a5,a1
    80001558:	8ff1                	and	a5,a5,a2
    8000155a:	00f76863          	bltu	a4,a5,8000156a <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000155e:	8526                	mv	a0,s1
    80001560:	60e2                	ld	ra,24(sp)
    80001562:	6442                	ld	s0,16(sp)
    80001564:	64a2                	ld	s1,8(sp)
    80001566:	6105                	addi	sp,sp,32
    80001568:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000156a:	8f99                	sub	a5,a5,a4
    8000156c:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000156e:	4685                	li	a3,1
    80001570:	0007861b          	sext.w	a2,a5
    80001574:	85ba                	mv	a1,a4
    80001576:	00000097          	auipc	ra,0x0
    8000157a:	e7c080e7          	jalr	-388(ra) # 800013f2 <uvmunmap>
    8000157e:	b7c5                	j	8000155e <uvmdealloc+0x26>

0000000080001580 <uvmalloc>:
  if (newsz < oldsz)
    80001580:	0ab66163          	bltu	a2,a1,80001622 <uvmalloc+0xa2>
uint64 uvmalloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz) {
    80001584:	7139                	addi	sp,sp,-64
    80001586:	fc06                	sd	ra,56(sp)
    80001588:	f822                	sd	s0,48(sp)
    8000158a:	f426                	sd	s1,40(sp)
    8000158c:	f04a                	sd	s2,32(sp)
    8000158e:	ec4e                	sd	s3,24(sp)
    80001590:	e852                	sd	s4,16(sp)
    80001592:	e456                	sd	s5,8(sp)
    80001594:	0080                	addi	s0,sp,64
    80001596:	8aaa                	mv	s5,a0
    80001598:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000159a:	6985                	lui	s3,0x1
    8000159c:	19fd                	addi	s3,s3,-1
    8000159e:	95ce                	add	a1,a1,s3
    800015a0:	79fd                	lui	s3,0xfffff
    800015a2:	0135f9b3          	and	s3,a1,s3
  for (a = oldsz; a < newsz; a += PGSIZE) {
    800015a6:	08c9f063          	bgeu	s3,a2,80001626 <uvmalloc+0xa6>
    800015aa:	894e                	mv	s2,s3
    mem = kalloc();
    800015ac:	fffff097          	auipc	ra,0xfffff
    800015b0:	650080e7          	jalr	1616(ra) # 80000bfc <kalloc>
    800015b4:	84aa                	mv	s1,a0
    if (mem == 0) {
    800015b6:	c51d                	beqz	a0,800015e4 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800015b8:	6605                	lui	a2,0x1
    800015ba:	4581                	li	a1,0
    800015bc:	00000097          	auipc	ra,0x0
    800015c0:	87a080e7          	jalr	-1926(ra) # 80000e36 <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem,
    800015c4:	4779                	li	a4,30
    800015c6:	86a6                	mv	a3,s1
    800015c8:	6605                	lui	a2,0x1
    800015ca:	85ca                	mv	a1,s2
    800015cc:	8556                	mv	a0,s5
    800015ce:	00000097          	auipc	ra,0x0
    800015d2:	c8c080e7          	jalr	-884(ra) # 8000125a <mappages>
    800015d6:	e905                	bnez	a0,80001606 <uvmalloc+0x86>
  for (a = oldsz; a < newsz; a += PGSIZE) {
    800015d8:	6785                	lui	a5,0x1
    800015da:	993e                	add	s2,s2,a5
    800015dc:	fd4968e3          	bltu	s2,s4,800015ac <uvmalloc+0x2c>
  return newsz;
    800015e0:	8552                	mv	a0,s4
    800015e2:	a809                	j	800015f4 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    800015e4:	864e                	mv	a2,s3
    800015e6:	85ca                	mv	a1,s2
    800015e8:	8556                	mv	a0,s5
    800015ea:	00000097          	auipc	ra,0x0
    800015ee:	f4e080e7          	jalr	-178(ra) # 80001538 <uvmdealloc>
      return 0;
    800015f2:	4501                	li	a0,0
}
    800015f4:	70e2                	ld	ra,56(sp)
    800015f6:	7442                	ld	s0,48(sp)
    800015f8:	74a2                	ld	s1,40(sp)
    800015fa:	7902                	ld	s2,32(sp)
    800015fc:	69e2                	ld	s3,24(sp)
    800015fe:	6a42                	ld	s4,16(sp)
    80001600:	6aa2                	ld	s5,8(sp)
    80001602:	6121                	addi	sp,sp,64
    80001604:	8082                	ret
      kfree(mem);
    80001606:	8526                	mv	a0,s1
    80001608:	fffff097          	auipc	ra,0xfffff
    8000160c:	482080e7          	jalr	1154(ra) # 80000a8a <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001610:	864e                	mv	a2,s3
    80001612:	85ca                	mv	a1,s2
    80001614:	8556                	mv	a0,s5
    80001616:	00000097          	auipc	ra,0x0
    8000161a:	f22080e7          	jalr	-222(ra) # 80001538 <uvmdealloc>
      return 0;
    8000161e:	4501                	li	a0,0
    80001620:	bfd1                	j	800015f4 <uvmalloc+0x74>
    return oldsz;
    80001622:	852e                	mv	a0,a1
}
    80001624:	8082                	ret
  return newsz;
    80001626:	8532                	mv	a0,a2
    80001628:	b7f1                	j	800015f4 <uvmalloc+0x74>

000000008000162a <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable) {
    8000162a:	7179                	addi	sp,sp,-48
    8000162c:	f406                	sd	ra,40(sp)
    8000162e:	f022                	sd	s0,32(sp)
    80001630:	ec26                	sd	s1,24(sp)
    80001632:	e84a                	sd	s2,16(sp)
    80001634:	e44e                	sd	s3,8(sp)
    80001636:	e052                	sd	s4,0(sp)
    80001638:	1800                	addi	s0,sp,48
    8000163a:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++) {
    8000163c:	84aa                	mv	s1,a0
    8000163e:	6905                	lui	s2,0x1
    80001640:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80001642:	4985                	li	s3,1
    80001644:	a821                	j	8000165c <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001646:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80001648:	0532                	slli	a0,a0,0xc
    8000164a:	00000097          	auipc	ra,0x0
    8000164e:	fe0080e7          	jalr	-32(ra) # 8000162a <freewalk>
      pagetable[i] = 0;
    80001652:	0004b023          	sd	zero,0(s1)
  for (int i = 0; i < 512; i++) {
    80001656:	04a1                	addi	s1,s1,8
    80001658:	03248163          	beq	s1,s2,8000167a <freewalk+0x50>
    pte_t pte = pagetable[i];
    8000165c:	6088                	ld	a0,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    8000165e:	00f57793          	andi	a5,a0,15
    80001662:	ff3782e3          	beq	a5,s3,80001646 <freewalk+0x1c>
    } else if (pte & PTE_V) {
    80001666:	8905                	andi	a0,a0,1
    80001668:	d57d                	beqz	a0,80001656 <freewalk+0x2c>
      panic("freewalk: leaf");
    8000166a:	00007517          	auipc	a0,0x7
    8000166e:	b3650513          	addi	a0,a0,-1226 # 800081a0 <digits+0x138>
    80001672:	fffff097          	auipc	ra,0xfffff
    80001676:	f72080e7          	jalr	-142(ra) # 800005e4 <panic>
    }
  }
  kfree((void *)pagetable);
    8000167a:	8552                	mv	a0,s4
    8000167c:	fffff097          	auipc	ra,0xfffff
    80001680:	40e080e7          	jalr	1038(ra) # 80000a8a <kfree>
}
    80001684:	70a2                	ld	ra,40(sp)
    80001686:	7402                	ld	s0,32(sp)
    80001688:	64e2                	ld	s1,24(sp)
    8000168a:	6942                	ld	s2,16(sp)
    8000168c:	69a2                	ld	s3,8(sp)
    8000168e:	6a02                	ld	s4,0(sp)
    80001690:	6145                	addi	sp,sp,48
    80001692:	8082                	ret

0000000080001694 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz) {
    80001694:	1101                	addi	sp,sp,-32
    80001696:	ec06                	sd	ra,24(sp)
    80001698:	e822                	sd	s0,16(sp)
    8000169a:	e426                	sd	s1,8(sp)
    8000169c:	1000                	addi	s0,sp,32
    8000169e:	84aa                	mv	s1,a0
  if (sz > 0)
    800016a0:	e999                	bnez	a1,800016b6 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
    800016a2:	8526                	mv	a0,s1
    800016a4:	00000097          	auipc	ra,0x0
    800016a8:	f86080e7          	jalr	-122(ra) # 8000162a <freewalk>
}
    800016ac:	60e2                	ld	ra,24(sp)
    800016ae:	6442                	ld	s0,16(sp)
    800016b0:	64a2                	ld	s1,8(sp)
    800016b2:	6105                	addi	sp,sp,32
    800016b4:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    800016b6:	6605                	lui	a2,0x1
    800016b8:	167d                	addi	a2,a2,-1
    800016ba:	962e                	add	a2,a2,a1
    800016bc:	4685                	li	a3,1
    800016be:	8231                	srli	a2,a2,0xc
    800016c0:	4581                	li	a1,0
    800016c2:	00000097          	auipc	ra,0x0
    800016c6:	d30080e7          	jalr	-720(ra) # 800013f2 <uvmunmap>
    800016ca:	bfe1                	j	800016a2 <uvmfree+0xe>

00000000800016cc <uvmcopy>:
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) {
  pte_t *pte;
  uint64 i, pa;
  uint flags;

  for (i = 0; i < sz; i += PGSIZE) {
    800016cc:	ce55                	beqz	a2,80001788 <uvmcopy+0xbc>
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) {
    800016ce:	711d                	addi	sp,sp,-96
    800016d0:	ec86                	sd	ra,88(sp)
    800016d2:	e8a2                	sd	s0,80(sp)
    800016d4:	e4a6                	sd	s1,72(sp)
    800016d6:	e0ca                	sd	s2,64(sp)
    800016d8:	fc4e                	sd	s3,56(sp)
    800016da:	f852                	sd	s4,48(sp)
    800016dc:	f456                	sd	s5,40(sp)
    800016de:	f05a                	sd	s6,32(sp)
    800016e0:	ec5e                	sd	s7,24(sp)
    800016e2:	e862                	sd	s8,16(sp)
    800016e4:	e466                	sd	s9,8(sp)
    800016e6:	1080                	addi	s0,sp,96
    800016e8:	89aa                	mv	s3,a0
    800016ea:	8aae                	mv	s5,a1
    800016ec:	8932                	mv	s2,a2
  for (i = 0; i < sz; i += PGSIZE) {
    800016ee:	4481                	li	s1,0
      goto err;
    }
    *pte &= ~PTE_W;
    *pte |= PTE_COW;
    *new_pte = *pte;
    page_ref_count[REF_IDX(pa)] += 1;
    800016f0:	80000bb7          	lui	s7,0x80000
    800016f4:	00010b17          	auipc	s6,0x10
    800016f8:	26cb0b13          	addi	s6,s6,620 # 80011960 <page_ref_count>
  for (i = 0; i < sz; i += PGSIZE) {
    800016fc:	6a05                	lui	s4,0x1
    800016fe:	a839                	j	8000171c <uvmcopy+0x50>
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001700:	4685                	li	a3,1
    80001702:	00c4d613          	srli	a2,s1,0xc
    80001706:	4581                	li	a1,0
    80001708:	8556                	mv	a0,s5
    8000170a:	00000097          	auipc	ra,0x0
    8000170e:	ce8080e7          	jalr	-792(ra) # 800013f2 <uvmunmap>
  return -1;
    80001712:	557d                	li	a0,-1
    80001714:	a8a9                	j	8000176e <uvmcopy+0xa2>
  for (i = 0; i < sz; i += PGSIZE) {
    80001716:	94d2                	add	s1,s1,s4
    80001718:	0524fa63          	bgeu	s1,s2,8000176c <uvmcopy+0xa0>
    if ((pte = walk(old, i, 0)) == 0)
    8000171c:	4601                	li	a2,0
    8000171e:	85a6                	mv	a1,s1
    80001720:	854e                	mv	a0,s3
    80001722:	00000097          	auipc	ra,0x0
    80001726:	9fc080e7          	jalr	-1540(ra) # 8000111e <walk>
    8000172a:	8caa                	mv	s9,a0
    8000172c:	d56d                	beqz	a0,80001716 <uvmcopy+0x4a>
    if ((*pte & PTE_V) == 0)
    8000172e:	611c                	ld	a5,0(a0)
    80001730:	0017f713          	andi	a4,a5,1
    80001734:	d36d                	beqz	a4,80001716 <uvmcopy+0x4a>
    pa = PTE2PA(*pte);
    80001736:	83a9                	srli	a5,a5,0xa
    80001738:	00c79c13          	slli	s8,a5,0xc
    pte_t *new_pte = walk(new, i, 1);
    8000173c:	4605                	li	a2,1
    8000173e:	85a6                	mv	a1,s1
    80001740:	8556                	mv	a0,s5
    80001742:	00000097          	auipc	ra,0x0
    80001746:	9dc080e7          	jalr	-1572(ra) # 8000111e <walk>
    if (new_pte == 0) {
    8000174a:	d95d                	beqz	a0,80001700 <uvmcopy+0x34>
    *pte &= ~PTE_W;
    8000174c:	000cb783          	ld	a5,0(s9)
    80001750:	9bed                	andi	a5,a5,-5
    *pte |= PTE_COW;
    80001752:	1007e793          	ori	a5,a5,256
    80001756:	00fcb023          	sd	a5,0(s9)
    *new_pte = *pte;
    8000175a:	e11c                	sd	a5,0(a0)
    page_ref_count[REF_IDX(pa)] += 1;
    8000175c:	017c07b3          	add	a5,s8,s7
    80001760:	83a9                	srli	a5,a5,0xa
    80001762:	97da                	add	a5,a5,s6
    80001764:	4398                	lw	a4,0(a5)
    80001766:	2705                	addiw	a4,a4,1
    80001768:	c398                	sw	a4,0(a5)
    8000176a:	b775                	j	80001716 <uvmcopy+0x4a>
  return 0;
    8000176c:	4501                	li	a0,0
}
    8000176e:	60e6                	ld	ra,88(sp)
    80001770:	6446                	ld	s0,80(sp)
    80001772:	64a6                	ld	s1,72(sp)
    80001774:	6906                	ld	s2,64(sp)
    80001776:	79e2                	ld	s3,56(sp)
    80001778:	7a42                	ld	s4,48(sp)
    8000177a:	7aa2                	ld	s5,40(sp)
    8000177c:	7b02                	ld	s6,32(sp)
    8000177e:	6be2                	ld	s7,24(sp)
    80001780:	6c42                	ld	s8,16(sp)
    80001782:	6ca2                	ld	s9,8(sp)
    80001784:	6125                	addi	sp,sp,96
    80001786:	8082                	ret
  return 0;
    80001788:	4501                	li	a0,0
}
    8000178a:	8082                	ret

000000008000178c <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va) {
    8000178c:	1141                	addi	sp,sp,-16
    8000178e:	e406                	sd	ra,8(sp)
    80001790:	e022                	sd	s0,0(sp)
    80001792:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80001794:	4601                	li	a2,0
    80001796:	00000097          	auipc	ra,0x0
    8000179a:	988080e7          	jalr	-1656(ra) # 8000111e <walk>
  if (pte == 0)
    8000179e:	c901                	beqz	a0,800017ae <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800017a0:	611c                	ld	a5,0(a0)
    800017a2:	9bbd                	andi	a5,a5,-17
    800017a4:	e11c                	sd	a5,0(a0)
}
    800017a6:	60a2                	ld	ra,8(sp)
    800017a8:	6402                	ld	s0,0(sp)
    800017aa:	0141                	addi	sp,sp,16
    800017ac:	8082                	ret
    panic("uvmclear");
    800017ae:	00007517          	auipc	a0,0x7
    800017b2:	a0250513          	addi	a0,a0,-1534 # 800081b0 <digits+0x148>
    800017b6:	fffff097          	auipc	ra,0xfffff
    800017ba:	e2e080e7          	jalr	-466(ra) # 800005e4 <panic>

00000000800017be <copyin>:
// Copy len bytes to dst from virtual address srcva in a given page table.
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len) {
  uint64 n, va0, pa0;

  while (len > 0) {
    800017be:	caa5                	beqz	a3,8000182e <copyin+0x70>
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len) {
    800017c0:	715d                	addi	sp,sp,-80
    800017c2:	e486                	sd	ra,72(sp)
    800017c4:	e0a2                	sd	s0,64(sp)
    800017c6:	fc26                	sd	s1,56(sp)
    800017c8:	f84a                	sd	s2,48(sp)
    800017ca:	f44e                	sd	s3,40(sp)
    800017cc:	f052                	sd	s4,32(sp)
    800017ce:	ec56                	sd	s5,24(sp)
    800017d0:	e85a                	sd	s6,16(sp)
    800017d2:	e45e                	sd	s7,8(sp)
    800017d4:	e062                	sd	s8,0(sp)
    800017d6:	0880                	addi	s0,sp,80
    800017d8:	8b2a                	mv	s6,a0
    800017da:	8a2e                	mv	s4,a1
    800017dc:	8c32                	mv	s8,a2
    800017de:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800017e0:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800017e2:	6a85                	lui	s5,0x1
    800017e4:	a01d                	j	8000180a <copyin+0x4c>
    if (n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800017e6:	018505b3          	add	a1,a0,s8
    800017ea:	0004861b          	sext.w	a2,s1
    800017ee:	412585b3          	sub	a1,a1,s2
    800017f2:	8552                	mv	a0,s4
    800017f4:	fffff097          	auipc	ra,0xfffff
    800017f8:	69e080e7          	jalr	1694(ra) # 80000e92 <memmove>

    len -= n;
    800017fc:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001800:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001802:	01590c33          	add	s8,s2,s5
  while (len > 0) {
    80001806:	02098263          	beqz	s3,8000182a <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    8000180a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000180e:	85ca                	mv	a1,s2
    80001810:	855a                	mv	a0,s6
    80001812:	00000097          	auipc	ra,0x0
    80001816:	9a8080e7          	jalr	-1624(ra) # 800011ba <walkaddr>
    if (pa0 == 0)
    8000181a:	cd01                	beqz	a0,80001832 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    8000181c:	418904b3          	sub	s1,s2,s8
    80001820:	94d6                	add	s1,s1,s5
    if (n > len)
    80001822:	fc99f2e3          	bgeu	s3,s1,800017e6 <copyin+0x28>
    80001826:	84ce                	mv	s1,s3
    80001828:	bf7d                	j	800017e6 <copyin+0x28>
  }
  return 0;
    8000182a:	4501                	li	a0,0
    8000182c:	a021                	j	80001834 <copyin+0x76>
    8000182e:	4501                	li	a0,0
}
    80001830:	8082                	ret
      return -1;
    80001832:	557d                	li	a0,-1
}
    80001834:	60a6                	ld	ra,72(sp)
    80001836:	6406                	ld	s0,64(sp)
    80001838:	74e2                	ld	s1,56(sp)
    8000183a:	7942                	ld	s2,48(sp)
    8000183c:	79a2                	ld	s3,40(sp)
    8000183e:	7a02                	ld	s4,32(sp)
    80001840:	6ae2                	ld	s5,24(sp)
    80001842:	6b42                	ld	s6,16(sp)
    80001844:	6ba2                	ld	s7,8(sp)
    80001846:	6c02                	ld	s8,0(sp)
    80001848:	6161                	addi	sp,sp,80
    8000184a:	8082                	ret

000000008000184c <copyinstr>:
// Return 0 on success, -1 on error.
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max) {
  uint64 n, va0, pa0;
  int got_null = 0;

  while (got_null == 0 && max > 0) {
    8000184c:	c6c5                	beqz	a3,800018f4 <copyinstr+0xa8>
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max) {
    8000184e:	715d                	addi	sp,sp,-80
    80001850:	e486                	sd	ra,72(sp)
    80001852:	e0a2                	sd	s0,64(sp)
    80001854:	fc26                	sd	s1,56(sp)
    80001856:	f84a                	sd	s2,48(sp)
    80001858:	f44e                	sd	s3,40(sp)
    8000185a:	f052                	sd	s4,32(sp)
    8000185c:	ec56                	sd	s5,24(sp)
    8000185e:	e85a                	sd	s6,16(sp)
    80001860:	e45e                	sd	s7,8(sp)
    80001862:	0880                	addi	s0,sp,80
    80001864:	8a2a                	mv	s4,a0
    80001866:	8b2e                	mv	s6,a1
    80001868:	8bb2                	mv	s7,a2
    8000186a:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    8000186c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000186e:	6985                	lui	s3,0x1
    80001870:	a035                	j	8000189c <copyinstr+0x50>
      n = max;

    char *p = (char *)(pa0 + (srcva - va0));
    while (n > 0) {
      if (*p == '\0') {
        *dst = '\0';
    80001872:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001876:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if (got_null) {
    80001878:	0017b793          	seqz	a5,a5
    8000187c:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001880:	60a6                	ld	ra,72(sp)
    80001882:	6406                	ld	s0,64(sp)
    80001884:	74e2                	ld	s1,56(sp)
    80001886:	7942                	ld	s2,48(sp)
    80001888:	79a2                	ld	s3,40(sp)
    8000188a:	7a02                	ld	s4,32(sp)
    8000188c:	6ae2                	ld	s5,24(sp)
    8000188e:	6b42                	ld	s6,16(sp)
    80001890:	6ba2                	ld	s7,8(sp)
    80001892:	6161                	addi	sp,sp,80
    80001894:	8082                	ret
    srcva = va0 + PGSIZE;
    80001896:	01390bb3          	add	s7,s2,s3
  while (got_null == 0 && max > 0) {
    8000189a:	c8a9                	beqz	s1,800018ec <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    8000189c:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800018a0:	85ca                	mv	a1,s2
    800018a2:	8552                	mv	a0,s4
    800018a4:	00000097          	auipc	ra,0x0
    800018a8:	916080e7          	jalr	-1770(ra) # 800011ba <walkaddr>
    if (pa0 == 0)
    800018ac:	c131                	beqz	a0,800018f0 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    800018ae:	41790833          	sub	a6,s2,s7
    800018b2:	984e                	add	a6,a6,s3
    if (n > max)
    800018b4:	0104f363          	bgeu	s1,a6,800018ba <copyinstr+0x6e>
    800018b8:	8826                	mv	a6,s1
    char *p = (char *)(pa0 + (srcva - va0));
    800018ba:	955e                	add	a0,a0,s7
    800018bc:	41250533          	sub	a0,a0,s2
    while (n > 0) {
    800018c0:	fc080be3          	beqz	a6,80001896 <copyinstr+0x4a>
    800018c4:	985a                	add	a6,a6,s6
    800018c6:	87da                	mv	a5,s6
      if (*p == '\0') {
    800018c8:	41650633          	sub	a2,a0,s6
    800018cc:	14fd                	addi	s1,s1,-1
    800018ce:	9b26                	add	s6,s6,s1
    800018d0:	00f60733          	add	a4,a2,a5
    800018d4:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffb9000>
    800018d8:	df49                	beqz	a4,80001872 <copyinstr+0x26>
        *dst = *p;
    800018da:	00e78023          	sb	a4,0(a5)
      --max;
    800018de:	40fb04b3          	sub	s1,s6,a5
      dst++;
    800018e2:	0785                	addi	a5,a5,1
    while (n > 0) {
    800018e4:	ff0796e3          	bne	a5,a6,800018d0 <copyinstr+0x84>
      dst++;
    800018e8:	8b42                	mv	s6,a6
    800018ea:	b775                	j	80001896 <copyinstr+0x4a>
    800018ec:	4781                	li	a5,0
    800018ee:	b769                	j	80001878 <copyinstr+0x2c>
      return -1;
    800018f0:	557d                	li	a0,-1
    800018f2:	b779                	j	80001880 <copyinstr+0x34>
  int got_null = 0;
    800018f4:	4781                	li	a5,0
  if (got_null) {
    800018f6:	0017b793          	seqz	a5,a5
    800018fa:	40f00533          	neg	a0,a5
}
    800018fe:	8082                	ret

0000000080001900 <do_cow>:

int do_cow(pagetable_t pt, uint64 addr) {
    80001900:	7179                	addi	sp,sp,-48
    80001902:	f406                	sd	ra,40(sp)
    80001904:	f022                	sd	s0,32(sp)
    80001906:	ec26                	sd	s1,24(sp)
    80001908:	e84a                	sd	s2,16(sp)
    8000190a:	e44e                	sd	s3,8(sp)
    8000190c:	e052                	sd	s4,0(sp)
    8000190e:	1800                	addi	s0,sp,48
  pte_t *pte;
  uint64 pa;
  uint flags;
  char *mem;
  uint64 va = PGROUNDDOWN(addr);
  if ((pte = walk(pt, va, 0)) == 0)
    80001910:	4601                	li	a2,0
    80001912:	77fd                	lui	a5,0xfffff
    80001914:	8dfd                	and	a1,a1,a5
    80001916:	00000097          	auipc	ra,0x0
    8000191a:	808080e7          	jalr	-2040(ra) # 8000111e <walk>
    8000191e:	c141                	beqz	a0,8000199e <do_cow+0x9e>
    80001920:	89aa                	mv	s3,a0
    panic("uvmcopy: pte should exist");
  if ((*pte & PTE_V) == 0)
    80001922:	6104                	ld	s1,0(a0)
    80001924:	0014f793          	andi	a5,s1,1
    80001928:	c3d9                	beqz	a5,800019ae <do_cow+0xae>
    panic("uvmcopy: page not present");
  pa = PTE2PA(*pte);
    8000192a:	00a4da13          	srli	s4,s1,0xa
    8000192e:	0a32                	slli	s4,s4,0xc
  flags = PTE_FLAGS(*pte);
  flags |= PTE_W;
  flags &= ~PTE_COW;
  if (page_ref_count[REF_IDX(pa)] == 1) {
    80001930:	800007b7          	lui	a5,0x80000
    80001934:	97d2                	add	a5,a5,s4
    80001936:	00c7d693          	srli	a3,a5,0xc
    8000193a:	83a9                	srli	a5,a5,0xa
    8000193c:	00010717          	auipc	a4,0x10
    80001940:	02470713          	addi	a4,a4,36 # 80011960 <page_ref_count>
    80001944:	97ba                	add	a5,a5,a4
    80001946:	439c                	lw	a5,0(a5)
    80001948:	4705                	li	a4,1
    8000194a:	06e78a63          	beq	a5,a4,800019be <do_cow+0xbe>
    *pte |= PTE_W;
    *pte &= ~PTE_COW;
    return 0;
  }
  page_ref_count[REF_IDX(pa)] -= 1;
    8000194e:	068a                	slli	a3,a3,0x2
    80001950:	00010717          	auipc	a4,0x10
    80001954:	01070713          	addi	a4,a4,16 # 80011960 <page_ref_count>
    80001958:	96ba                	add	a3,a3,a4
    8000195a:	37fd                	addiw	a5,a5,-1
    8000195c:	c29c                	sw	a5,0(a3)
  if ((mem = kalloc()) == 0)
    8000195e:	fffff097          	auipc	ra,0xfffff
    80001962:	29e080e7          	jalr	670(ra) # 80000bfc <kalloc>
    80001966:	892a                	mv	s2,a0
    80001968:	c135                	beqz	a0,800019cc <do_cow+0xcc>
    return -1;
  memmove(mem, (char *)pa, PGSIZE);
    8000196a:	6605                	lui	a2,0x1
    8000196c:	85d2                	mv	a1,s4
    8000196e:	fffff097          	auipc	ra,0xfffff
    80001972:	524080e7          	jalr	1316(ra) # 80000e92 <memmove>
  *pte = PA2PTE(mem) | flags;
    80001976:	00c95913          	srli	s2,s2,0xc
    8000197a:	092a                	slli	s2,s2,0xa
  flags &= ~PTE_COW;
    8000197c:	2ff4f493          	andi	s1,s1,767
  *pte = PA2PTE(mem) | flags;
    80001980:	0044e493          	ori	s1,s1,4
    80001984:	009964b3          	or	s1,s2,s1
    80001988:	0099b023          	sd	s1,0(s3) # 1000 <_entry-0x7ffff000>

  return 0;
    8000198c:	4501                	li	a0,0
}
    8000198e:	70a2                	ld	ra,40(sp)
    80001990:	7402                	ld	s0,32(sp)
    80001992:	64e2                	ld	s1,24(sp)
    80001994:	6942                	ld	s2,16(sp)
    80001996:	69a2                	ld	s3,8(sp)
    80001998:	6a02                	ld	s4,0(sp)
    8000199a:	6145                	addi	sp,sp,48
    8000199c:	8082                	ret
    panic("uvmcopy: pte should exist");
    8000199e:	00007517          	auipc	a0,0x7
    800019a2:	82250513          	addi	a0,a0,-2014 # 800081c0 <digits+0x158>
    800019a6:	fffff097          	auipc	ra,0xfffff
    800019aa:	c3e080e7          	jalr	-962(ra) # 800005e4 <panic>
    panic("uvmcopy: page not present");
    800019ae:	00007517          	auipc	a0,0x7
    800019b2:	83250513          	addi	a0,a0,-1998 # 800081e0 <digits+0x178>
    800019b6:	fffff097          	auipc	ra,0xfffff
    800019ba:	c2e080e7          	jalr	-978(ra) # 800005e4 <panic>
    *pte &= ~PTE_COW;
    800019be:	eff4f493          	andi	s1,s1,-257
    800019c2:	0044e493          	ori	s1,s1,4
    800019c6:	e104                	sd	s1,0(a0)
    return 0;
    800019c8:	4501                	li	a0,0
    800019ca:	b7d1                	j	8000198e <do_cow+0x8e>
    return -1;
    800019cc:	557d                	li	a0,-1
    800019ce:	b7c1                	j	8000198e <do_cow+0x8e>

00000000800019d0 <do_lazy_allocation>:

int do_lazy_allocation(pagetable_t pt, u64 addr) {
    800019d0:	7179                	addi	sp,sp,-48
    800019d2:	f406                	sd	ra,40(sp)
    800019d4:	f022                	sd	s0,32(sp)
    800019d6:	ec26                	sd	s1,24(sp)
    800019d8:	e84a                	sd	s2,16(sp)
    800019da:	e44e                	sd	s3,8(sp)
    800019dc:	1800                	addi	s0,sp,48
    800019de:	892a                	mv	s2,a0
  u64 va, pa;
  va = PGROUNDDOWN(addr);
    800019e0:	79fd                	lui	s3,0xfffff
    800019e2:	0135f9b3          	and	s3,a1,s3
  if ((pa = (u64)kalloc()) == 0) {
    800019e6:	fffff097          	auipc	ra,0xfffff
    800019ea:	216080e7          	jalr	534(ra) # 80000bfc <kalloc>
    800019ee:	c121                	beqz	a0,80001a2e <do_lazy_allocation+0x5e>
    800019f0:	84aa                	mv	s1,a0
    // uvmdealloc(pt, va + PGSIZE, va);
    return -1;
  }
  memset((void *)pa, 0, PGSIZE);
    800019f2:	6605                	lui	a2,0x1
    800019f4:	4581                	li	a1,0
    800019f6:	fffff097          	auipc	ra,0xfffff
    800019fa:	440080e7          	jalr	1088(ra) # 80000e36 <memset>
  if (mappages(pt, va, PGSIZE, pa, PTE_R | PTE_W | PTE_X | PTE_U) != 0) {
    800019fe:	4779                	li	a4,30
    80001a00:	86a6                	mv	a3,s1
    80001a02:	6605                	lui	a2,0x1
    80001a04:	85ce                	mv	a1,s3
    80001a06:	854a                	mv	a0,s2
    80001a08:	00000097          	auipc	ra,0x0
    80001a0c:	852080e7          	jalr	-1966(ra) # 8000125a <mappages>
    80001a10:	e901                	bnez	a0,80001a20 <do_lazy_allocation+0x50>
    kfree((void *)pa);
    // uvmdealloc(pt, va + PGSIZE, va);
    return -2;
  }
  return 0;
}
    80001a12:	70a2                	ld	ra,40(sp)
    80001a14:	7402                	ld	s0,32(sp)
    80001a16:	64e2                	ld	s1,24(sp)
    80001a18:	6942                	ld	s2,16(sp)
    80001a1a:	69a2                	ld	s3,8(sp)
    80001a1c:	6145                	addi	sp,sp,48
    80001a1e:	8082                	ret
    kfree((void *)pa);
    80001a20:	8526                	mv	a0,s1
    80001a22:	fffff097          	auipc	ra,0xfffff
    80001a26:	068080e7          	jalr	104(ra) # 80000a8a <kfree>
    return -2;
    80001a2a:	5579                	li	a0,-2
    80001a2c:	b7dd                	j	80001a12 <do_lazy_allocation+0x42>
    return -1;
    80001a2e:	557d                	li	a0,-1
    80001a30:	b7cd                	j	80001a12 <do_lazy_allocation+0x42>

0000000080001a32 <copyout>:
  while (len > 0) {
    80001a32:	c695                	beqz	a3,80001a5e <copyout+0x2c>
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
    80001a34:	715d                	addi	sp,sp,-80
    80001a36:	e486                	sd	ra,72(sp)
    80001a38:	e0a2                	sd	s0,64(sp)
    80001a3a:	fc26                	sd	s1,56(sp)
    80001a3c:	f84a                	sd	s2,48(sp)
    80001a3e:	f44e                	sd	s3,40(sp)
    80001a40:	f052                	sd	s4,32(sp)
    80001a42:	ec56                	sd	s5,24(sp)
    80001a44:	e85a                	sd	s6,16(sp)
    80001a46:	e45e                	sd	s7,8(sp)
    80001a48:	e062                	sd	s8,0(sp)
    80001a4a:	0880                	addi	s0,sp,80
    80001a4c:	8b2a                	mv	s6,a0
    80001a4e:	89ae                	mv	s3,a1
    80001a50:	8ab2                	mv	s5,a2
    80001a52:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    80001a54:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (dstva - va0);
    80001a56:	6b85                	lui	s7,0x1
    80001a58:	a061                	j	80001ae0 <copyout+0xae>
  return 0;
    80001a5a:	4501                	li	a0,0
    80001a5c:	a031                	j	80001a68 <copyout+0x36>
    80001a5e:	4501                	li	a0,0
}
    80001a60:	8082                	ret
        return -1;
    80001a62:	557d                	li	a0,-1
    80001a64:	a011                	j	80001a68 <copyout+0x36>
      return -1;
    80001a66:	557d                	li	a0,-1
}
    80001a68:	60a6                	ld	ra,72(sp)
    80001a6a:	6406                	ld	s0,64(sp)
    80001a6c:	74e2                	ld	s1,56(sp)
    80001a6e:	7942                	ld	s2,48(sp)
    80001a70:	79a2                	ld	s3,40(sp)
    80001a72:	7a02                	ld	s4,32(sp)
    80001a74:	6ae2                	ld	s5,24(sp)
    80001a76:	6b42                	ld	s6,16(sp)
    80001a78:	6ba2                	ld	s7,8(sp)
    80001a7a:	6c02                	ld	s8,0(sp)
    80001a7c:	6161                	addi	sp,sp,80
    80001a7e:	8082                	ret
    if ((!pte || !(*pte & PTE_V)) && va0 < myproc()->sz) {
    80001a80:	00000097          	auipc	ra,0x0
    80001a84:	1e6080e7          	jalr	486(ra) # 80001c66 <myproc>
    80001a88:	653c                	ld	a5,72(a0)
    80001a8a:	06f97963          	bgeu	s2,a5,80001afc <copyout+0xca>
      if (do_lazy_allocation(myproc()->pagetable, va0) != 0) {
    80001a8e:	00000097          	auipc	ra,0x0
    80001a92:	1d8080e7          	jalr	472(ra) # 80001c66 <myproc>
    80001a96:	85ca                	mv	a1,s2
    80001a98:	6928                	ld	a0,80(a0)
    80001a9a:	00000097          	auipc	ra,0x0
    80001a9e:	f36080e7          	jalr	-202(ra) # 800019d0 <do_lazy_allocation>
    80001aa2:	f161                	bnez	a0,80001a62 <copyout+0x30>
    pa0 = walkaddr(pagetable, va0);
    80001aa4:	85ca                	mv	a1,s2
    80001aa6:	855a                	mv	a0,s6
    80001aa8:	fffff097          	auipc	ra,0xfffff
    80001aac:	712080e7          	jalr	1810(ra) # 800011ba <walkaddr>
    if (pa0 == 0)
    80001ab0:	d95d                	beqz	a0,80001a66 <copyout+0x34>
    n = PGSIZE - (dstva - va0);
    80001ab2:	413904b3          	sub	s1,s2,s3
    80001ab6:	94de                	add	s1,s1,s7
    if (n > len)
    80001ab8:	009a7363          	bgeu	s4,s1,80001abe <copyout+0x8c>
    80001abc:	84d2                	mv	s1,s4
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001abe:	412989b3          	sub	s3,s3,s2
    80001ac2:	0004861b          	sext.w	a2,s1
    80001ac6:	85d6                	mv	a1,s5
    80001ac8:	954e                	add	a0,a0,s3
    80001aca:	fffff097          	auipc	ra,0xfffff
    80001ace:	3c8080e7          	jalr	968(ra) # 80000e92 <memmove>
    len -= n;
    80001ad2:	409a0a33          	sub	s4,s4,s1
    src += n;
    80001ad6:	9aa6                	add	s5,s5,s1
    dstva = va0 + PGSIZE;
    80001ad8:	017909b3          	add	s3,s2,s7
  while (len > 0) {
    80001adc:	f60a0fe3          	beqz	s4,80001a5a <copyout+0x28>
    va0 = PGROUNDDOWN(dstva);
    80001ae0:	0189f933          	and	s2,s3,s8
    pte_t *pte = walk(pagetable, va0, 0);
    80001ae4:	4601                	li	a2,0
    80001ae6:	85ca                	mv	a1,s2
    80001ae8:	855a                	mv	a0,s6
    80001aea:	fffff097          	auipc	ra,0xfffff
    80001aee:	634080e7          	jalr	1588(ra) # 8000111e <walk>
    80001af2:	84aa                	mv	s1,a0
    if ((!pte || !(*pte & PTE_V)) && va0 < myproc()->sz) {
    80001af4:	c10d                	beqz	a0,80001b16 <copyout+0xe4>
    80001af6:	611c                	ld	a5,0(a0)
    80001af8:	8b85                	andi	a5,a5,1
    80001afa:	d3d9                	beqz	a5,80001a80 <copyout+0x4e>
    } else if (pte && (*pte & PTE_COW)) {
    80001afc:	609c                	ld	a5,0(s1)
    80001afe:	1007f793          	andi	a5,a5,256
    80001b02:	d3cd                	beqz	a5,80001aa4 <copyout+0x72>
      if (do_cow(pagetable, va0) != 0)
    80001b04:	85ca                	mv	a1,s2
    80001b06:	855a                	mv	a0,s6
    80001b08:	00000097          	auipc	ra,0x0
    80001b0c:	df8080e7          	jalr	-520(ra) # 80001900 <do_cow>
    80001b10:	d951                	beqz	a0,80001aa4 <copyout+0x72>
        return -2;
    80001b12:	5579                	li	a0,-2
    80001b14:	bf91                	j	80001a68 <copyout+0x36>
    if ((!pte || !(*pte & PTE_V)) && va0 < myproc()->sz) {
    80001b16:	00000097          	auipc	ra,0x0
    80001b1a:	150080e7          	jalr	336(ra) # 80001c66 <myproc>
    80001b1e:	653c                	ld	a5,72(a0)
    80001b20:	f8f972e3          	bgeu	s2,a5,80001aa4 <copyout+0x72>
    80001b24:	b7ad                	j	80001a8e <copyout+0x5c>

0000000080001b26 <wakeup1>:
  }
}

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void wakeup1(struct proc *p) {
    80001b26:	1101                	addi	sp,sp,-32
    80001b28:	ec06                	sd	ra,24(sp)
    80001b2a:	e822                	sd	s0,16(sp)
    80001b2c:	e426                	sd	s1,8(sp)
    80001b2e:	1000                	addi	s0,sp,32
    80001b30:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    80001b32:	fffff097          	auipc	ra,0xfffff
    80001b36:	18e080e7          	jalr	398(ra) # 80000cc0 <holding>
    80001b3a:	c909                	beqz	a0,80001b4c <wakeup1+0x26>
    panic("wakeup1");
  if (p->chan == p && p->state == SLEEPING) {
    80001b3c:	749c                	ld	a5,40(s1)
    80001b3e:	00978f63          	beq	a5,s1,80001b5c <wakeup1+0x36>
    p->state = RUNNABLE;
  }
}
    80001b42:	60e2                	ld	ra,24(sp)
    80001b44:	6442                	ld	s0,16(sp)
    80001b46:	64a2                	ld	s1,8(sp)
    80001b48:	6105                	addi	sp,sp,32
    80001b4a:	8082                	ret
    panic("wakeup1");
    80001b4c:	00006517          	auipc	a0,0x6
    80001b50:	6b450513          	addi	a0,a0,1716 # 80008200 <digits+0x198>
    80001b54:	fffff097          	auipc	ra,0xfffff
    80001b58:	a90080e7          	jalr	-1392(ra) # 800005e4 <panic>
  if (p->chan == p && p->state == SLEEPING) {
    80001b5c:	4c98                	lw	a4,24(s1)
    80001b5e:	4785                	li	a5,1
    80001b60:	fef711e3          	bne	a4,a5,80001b42 <wakeup1+0x1c>
    p->state = RUNNABLE;
    80001b64:	4789                	li	a5,2
    80001b66:	cc9c                	sw	a5,24(s1)
}
    80001b68:	bfe9                	j	80001b42 <wakeup1+0x1c>

0000000080001b6a <procinit>:
void procinit(void) {
    80001b6a:	715d                	addi	sp,sp,-80
    80001b6c:	e486                	sd	ra,72(sp)
    80001b6e:	e0a2                	sd	s0,64(sp)
    80001b70:	fc26                	sd	s1,56(sp)
    80001b72:	f84a                	sd	s2,48(sp)
    80001b74:	f44e                	sd	s3,40(sp)
    80001b76:	f052                	sd	s4,32(sp)
    80001b78:	ec56                	sd	s5,24(sp)
    80001b7a:	e85a                	sd	s6,16(sp)
    80001b7c:	e45e                	sd	s7,8(sp)
    80001b7e:	0880                	addi	s0,sp,80
  initlock(&pid_lock, "nextpid");
    80001b80:	00006597          	auipc	a1,0x6
    80001b84:	68858593          	addi	a1,a1,1672 # 80008208 <digits+0x1a0>
    80001b88:	00030517          	auipc	a0,0x30
    80001b8c:	dd850513          	addi	a0,a0,-552 # 80031960 <pid_lock>
    80001b90:	fffff097          	auipc	ra,0xfffff
    80001b94:	11a080e7          	jalr	282(ra) # 80000caa <initlock>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001b98:	00030917          	auipc	s2,0x30
    80001b9c:	1e090913          	addi	s2,s2,480 # 80031d78 <proc>
    initlock(&p->lock, "proc");
    80001ba0:	00006b97          	auipc	s7,0x6
    80001ba4:	670b8b93          	addi	s7,s7,1648 # 80008210 <digits+0x1a8>
    uint64 va = KSTACK((int)(p - proc));
    80001ba8:	8b4a                	mv	s6,s2
    80001baa:	00006a97          	auipc	s5,0x6
    80001bae:	456a8a93          	addi	s5,s5,1110 # 80008000 <etext>
    80001bb2:	040009b7          	lui	s3,0x4000
    80001bb6:	19fd                	addi	s3,s3,-1
    80001bb8:	09b2                	slli	s3,s3,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    80001bba:	00036a17          	auipc	s4,0x36
    80001bbe:	bbea0a13          	addi	s4,s4,-1090 # 80037778 <tickslock>
    initlock(&p->lock, "proc");
    80001bc2:	85de                	mv	a1,s7
    80001bc4:	854a                	mv	a0,s2
    80001bc6:	fffff097          	auipc	ra,0xfffff
    80001bca:	0e4080e7          	jalr	228(ra) # 80000caa <initlock>
    char *pa = kalloc();
    80001bce:	fffff097          	auipc	ra,0xfffff
    80001bd2:	02e080e7          	jalr	46(ra) # 80000bfc <kalloc>
    80001bd6:	85aa                	mv	a1,a0
    if (pa == 0)
    80001bd8:	c929                	beqz	a0,80001c2a <procinit+0xc0>
    uint64 va = KSTACK((int)(p - proc));
    80001bda:	416904b3          	sub	s1,s2,s6
    80001bde:	848d                	srai	s1,s1,0x3
    80001be0:	000ab783          	ld	a5,0(s5)
    80001be4:	02f484b3          	mul	s1,s1,a5
    80001be8:	2485                	addiw	s1,s1,1
    80001bea:	00d4949b          	slliw	s1,s1,0xd
    80001bee:	409984b3          	sub	s1,s3,s1
    kvmmap(va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001bf2:	4699                	li	a3,6
    80001bf4:	6605                	lui	a2,0x1
    80001bf6:	8526                	mv	a0,s1
    80001bf8:	fffff097          	auipc	ra,0xfffff
    80001bfc:	6f0080e7          	jalr	1776(ra) # 800012e8 <kvmmap>
    p->kstack = va;
    80001c00:	04993023          	sd	s1,64(s2)
  for (p = proc; p < &proc[NPROC]; p++) {
    80001c04:	16890913          	addi	s2,s2,360
    80001c08:	fb491de3          	bne	s2,s4,80001bc2 <procinit+0x58>
  kvminithart();
    80001c0c:	fffff097          	auipc	ra,0xfffff
    80001c10:	4ee080e7          	jalr	1262(ra) # 800010fa <kvminithart>
}
    80001c14:	60a6                	ld	ra,72(sp)
    80001c16:	6406                	ld	s0,64(sp)
    80001c18:	74e2                	ld	s1,56(sp)
    80001c1a:	7942                	ld	s2,48(sp)
    80001c1c:	79a2                	ld	s3,40(sp)
    80001c1e:	7a02                	ld	s4,32(sp)
    80001c20:	6ae2                	ld	s5,24(sp)
    80001c22:	6b42                	ld	s6,16(sp)
    80001c24:	6ba2                	ld	s7,8(sp)
    80001c26:	6161                	addi	sp,sp,80
    80001c28:	8082                	ret
      panic("kalloc");
    80001c2a:	00006517          	auipc	a0,0x6
    80001c2e:	5ee50513          	addi	a0,a0,1518 # 80008218 <digits+0x1b0>
    80001c32:	fffff097          	auipc	ra,0xfffff
    80001c36:	9b2080e7          	jalr	-1614(ra) # 800005e4 <panic>

0000000080001c3a <cpuid>:
int cpuid() {
    80001c3a:	1141                	addi	sp,sp,-16
    80001c3c:	e422                	sd	s0,8(sp)
    80001c3e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r"(x));
    80001c40:	8512                	mv	a0,tp
}
    80001c42:	2501                	sext.w	a0,a0
    80001c44:	6422                	ld	s0,8(sp)
    80001c46:	0141                	addi	sp,sp,16
    80001c48:	8082                	ret

0000000080001c4a <mycpu>:
struct cpu *mycpu(void) {
    80001c4a:	1141                	addi	sp,sp,-16
    80001c4c:	e422                	sd	s0,8(sp)
    80001c4e:	0800                	addi	s0,sp,16
    80001c50:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    80001c52:	2781                	sext.w	a5,a5
    80001c54:	079e                	slli	a5,a5,0x7
}
    80001c56:	00030517          	auipc	a0,0x30
    80001c5a:	d2250513          	addi	a0,a0,-734 # 80031978 <cpus>
    80001c5e:	953e                	add	a0,a0,a5
    80001c60:	6422                	ld	s0,8(sp)
    80001c62:	0141                	addi	sp,sp,16
    80001c64:	8082                	ret

0000000080001c66 <myproc>:
struct proc *myproc(void) {
    80001c66:	1101                	addi	sp,sp,-32
    80001c68:	ec06                	sd	ra,24(sp)
    80001c6a:	e822                	sd	s0,16(sp)
    80001c6c:	e426                	sd	s1,8(sp)
    80001c6e:	1000                	addi	s0,sp,32
  push_off();
    80001c70:	fffff097          	auipc	ra,0xfffff
    80001c74:	07e080e7          	jalr	126(ra) # 80000cee <push_off>
    80001c78:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    80001c7a:	2781                	sext.w	a5,a5
    80001c7c:	079e                	slli	a5,a5,0x7
    80001c7e:	00030717          	auipc	a4,0x30
    80001c82:	ce270713          	addi	a4,a4,-798 # 80031960 <pid_lock>
    80001c86:	97ba                	add	a5,a5,a4
    80001c88:	6f84                	ld	s1,24(a5)
  pop_off();
    80001c8a:	fffff097          	auipc	ra,0xfffff
    80001c8e:	104080e7          	jalr	260(ra) # 80000d8e <pop_off>
}
    80001c92:	8526                	mv	a0,s1
    80001c94:	60e2                	ld	ra,24(sp)
    80001c96:	6442                	ld	s0,16(sp)
    80001c98:	64a2                	ld	s1,8(sp)
    80001c9a:	6105                	addi	sp,sp,32
    80001c9c:	8082                	ret

0000000080001c9e <forkret>:
void forkret(void) {
    80001c9e:	1141                	addi	sp,sp,-16
    80001ca0:	e406                	sd	ra,8(sp)
    80001ca2:	e022                	sd	s0,0(sp)
    80001ca4:	0800                	addi	s0,sp,16
  release(&myproc()->lock);
    80001ca6:	00000097          	auipc	ra,0x0
    80001caa:	fc0080e7          	jalr	-64(ra) # 80001c66 <myproc>
    80001cae:	fffff097          	auipc	ra,0xfffff
    80001cb2:	140080e7          	jalr	320(ra) # 80000dee <release>
  if (first) {
    80001cb6:	00007797          	auipc	a5,0x7
    80001cba:	c0a7a783          	lw	a5,-1014(a5) # 800088c0 <first.1>
    80001cbe:	eb89                	bnez	a5,80001cd0 <forkret+0x32>
  usertrapret();
    80001cc0:	00001097          	auipc	ra,0x1
    80001cc4:	c18080e7          	jalr	-1000(ra) # 800028d8 <usertrapret>
}
    80001cc8:	60a2                	ld	ra,8(sp)
    80001cca:	6402                	ld	s0,0(sp)
    80001ccc:	0141                	addi	sp,sp,16
    80001cce:	8082                	ret
    first = 0;
    80001cd0:	00007797          	auipc	a5,0x7
    80001cd4:	be07a823          	sw	zero,-1040(a5) # 800088c0 <first.1>
    fsinit(ROOTDEV);
    80001cd8:	4505                	li	a0,1
    80001cda:	00002097          	auipc	ra,0x2
    80001cde:	a3a080e7          	jalr	-1478(ra) # 80003714 <fsinit>
    80001ce2:	bff9                	j	80001cc0 <forkret+0x22>

0000000080001ce4 <allocpid>:
int allocpid() {
    80001ce4:	1101                	addi	sp,sp,-32
    80001ce6:	ec06                	sd	ra,24(sp)
    80001ce8:	e822                	sd	s0,16(sp)
    80001cea:	e426                	sd	s1,8(sp)
    80001cec:	e04a                	sd	s2,0(sp)
    80001cee:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001cf0:	00030917          	auipc	s2,0x30
    80001cf4:	c7090913          	addi	s2,s2,-912 # 80031960 <pid_lock>
    80001cf8:	854a                	mv	a0,s2
    80001cfa:	fffff097          	auipc	ra,0xfffff
    80001cfe:	040080e7          	jalr	64(ra) # 80000d3a <acquire>
  pid = nextpid;
    80001d02:	00007797          	auipc	a5,0x7
    80001d06:	bc278793          	addi	a5,a5,-1086 # 800088c4 <nextpid>
    80001d0a:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001d0c:	0014871b          	addiw	a4,s1,1
    80001d10:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001d12:	854a                	mv	a0,s2
    80001d14:	fffff097          	auipc	ra,0xfffff
    80001d18:	0da080e7          	jalr	218(ra) # 80000dee <release>
}
    80001d1c:	8526                	mv	a0,s1
    80001d1e:	60e2                	ld	ra,24(sp)
    80001d20:	6442                	ld	s0,16(sp)
    80001d22:	64a2                	ld	s1,8(sp)
    80001d24:	6902                	ld	s2,0(sp)
    80001d26:	6105                	addi	sp,sp,32
    80001d28:	8082                	ret

0000000080001d2a <proc_pagetable>:
pagetable_t proc_pagetable(struct proc *p) {
    80001d2a:	1101                	addi	sp,sp,-32
    80001d2c:	ec06                	sd	ra,24(sp)
    80001d2e:	e822                	sd	s0,16(sp)
    80001d30:	e426                	sd	s1,8(sp)
    80001d32:	e04a                	sd	s2,0(sp)
    80001d34:	1000                	addi	s0,sp,32
    80001d36:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001d38:	fffff097          	auipc	ra,0xfffff
    80001d3c:	760080e7          	jalr	1888(ra) # 80001498 <uvmcreate>
    80001d40:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80001d42:	c121                	beqz	a0,80001d82 <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
    80001d44:	4729                	li	a4,10
    80001d46:	00005697          	auipc	a3,0x5
    80001d4a:	2ba68693          	addi	a3,a3,698 # 80007000 <_trampoline>
    80001d4e:	6605                	lui	a2,0x1
    80001d50:	040005b7          	lui	a1,0x4000
    80001d54:	15fd                	addi	a1,a1,-1
    80001d56:	05b2                	slli	a1,a1,0xc
    80001d58:	fffff097          	auipc	ra,0xfffff
    80001d5c:	502080e7          	jalr	1282(ra) # 8000125a <mappages>
    80001d60:	02054863          	bltz	a0,80001d90 <proc_pagetable+0x66>
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe),
    80001d64:	4719                	li	a4,6
    80001d66:	05893683          	ld	a3,88(s2)
    80001d6a:	6605                	lui	a2,0x1
    80001d6c:	020005b7          	lui	a1,0x2000
    80001d70:	15fd                	addi	a1,a1,-1
    80001d72:	05b6                	slli	a1,a1,0xd
    80001d74:	8526                	mv	a0,s1
    80001d76:	fffff097          	auipc	ra,0xfffff
    80001d7a:	4e4080e7          	jalr	1252(ra) # 8000125a <mappages>
    80001d7e:	02054163          	bltz	a0,80001da0 <proc_pagetable+0x76>
}
    80001d82:	8526                	mv	a0,s1
    80001d84:	60e2                	ld	ra,24(sp)
    80001d86:	6442                	ld	s0,16(sp)
    80001d88:	64a2                	ld	s1,8(sp)
    80001d8a:	6902                	ld	s2,0(sp)
    80001d8c:	6105                	addi	sp,sp,32
    80001d8e:	8082                	ret
    uvmfree(pagetable, 0);
    80001d90:	4581                	li	a1,0
    80001d92:	8526                	mv	a0,s1
    80001d94:	00000097          	auipc	ra,0x0
    80001d98:	900080e7          	jalr	-1792(ra) # 80001694 <uvmfree>
    return 0;
    80001d9c:	4481                	li	s1,0
    80001d9e:	b7d5                	j	80001d82 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001da0:	4681                	li	a3,0
    80001da2:	4605                	li	a2,1
    80001da4:	040005b7          	lui	a1,0x4000
    80001da8:	15fd                	addi	a1,a1,-1
    80001daa:	05b2                	slli	a1,a1,0xc
    80001dac:	8526                	mv	a0,s1
    80001dae:	fffff097          	auipc	ra,0xfffff
    80001db2:	644080e7          	jalr	1604(ra) # 800013f2 <uvmunmap>
    uvmfree(pagetable, 0);
    80001db6:	4581                	li	a1,0
    80001db8:	8526                	mv	a0,s1
    80001dba:	00000097          	auipc	ra,0x0
    80001dbe:	8da080e7          	jalr	-1830(ra) # 80001694 <uvmfree>
    return 0;
    80001dc2:	4481                	li	s1,0
    80001dc4:	bf7d                	j	80001d82 <proc_pagetable+0x58>

0000000080001dc6 <proc_freepagetable>:
void proc_freepagetable(pagetable_t pagetable, uint64 sz) {
    80001dc6:	1101                	addi	sp,sp,-32
    80001dc8:	ec06                	sd	ra,24(sp)
    80001dca:	e822                	sd	s0,16(sp)
    80001dcc:	e426                	sd	s1,8(sp)
    80001dce:	e04a                	sd	s2,0(sp)
    80001dd0:	1000                	addi	s0,sp,32
    80001dd2:	84aa                	mv	s1,a0
    80001dd4:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001dd6:	4681                	li	a3,0
    80001dd8:	4605                	li	a2,1
    80001dda:	040005b7          	lui	a1,0x4000
    80001dde:	15fd                	addi	a1,a1,-1
    80001de0:	05b2                	slli	a1,a1,0xc
    80001de2:	fffff097          	auipc	ra,0xfffff
    80001de6:	610080e7          	jalr	1552(ra) # 800013f2 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001dea:	4681                	li	a3,0
    80001dec:	4605                	li	a2,1
    80001dee:	020005b7          	lui	a1,0x2000
    80001df2:	15fd                	addi	a1,a1,-1
    80001df4:	05b6                	slli	a1,a1,0xd
    80001df6:	8526                	mv	a0,s1
    80001df8:	fffff097          	auipc	ra,0xfffff
    80001dfc:	5fa080e7          	jalr	1530(ra) # 800013f2 <uvmunmap>
  uvmfree(pagetable, sz);
    80001e00:	85ca                	mv	a1,s2
    80001e02:	8526                	mv	a0,s1
    80001e04:	00000097          	auipc	ra,0x0
    80001e08:	890080e7          	jalr	-1904(ra) # 80001694 <uvmfree>
}
    80001e0c:	60e2                	ld	ra,24(sp)
    80001e0e:	6442                	ld	s0,16(sp)
    80001e10:	64a2                	ld	s1,8(sp)
    80001e12:	6902                	ld	s2,0(sp)
    80001e14:	6105                	addi	sp,sp,32
    80001e16:	8082                	ret

0000000080001e18 <freeproc>:
static void freeproc(struct proc *p) {
    80001e18:	1101                	addi	sp,sp,-32
    80001e1a:	ec06                	sd	ra,24(sp)
    80001e1c:	e822                	sd	s0,16(sp)
    80001e1e:	e426                	sd	s1,8(sp)
    80001e20:	1000                	addi	s0,sp,32
    80001e22:	84aa                	mv	s1,a0
  if (p->trapframe)
    80001e24:	6d28                	ld	a0,88(a0)
    80001e26:	c509                	beqz	a0,80001e30 <freeproc+0x18>
    kfree((void *)p->trapframe);
    80001e28:	fffff097          	auipc	ra,0xfffff
    80001e2c:	c62080e7          	jalr	-926(ra) # 80000a8a <kfree>
  p->trapframe = 0;
    80001e30:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable)
    80001e34:	68a8                	ld	a0,80(s1)
    80001e36:	c511                	beqz	a0,80001e42 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001e38:	64ac                	ld	a1,72(s1)
    80001e3a:	00000097          	auipc	ra,0x0
    80001e3e:	f8c080e7          	jalr	-116(ra) # 80001dc6 <proc_freepagetable>
  p->pagetable = 0;
    80001e42:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001e46:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001e4a:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001e4e:	0204b023          	sd	zero,32(s1)
  p->name[0] = 0;
    80001e52:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001e56:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001e5a:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001e5e:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80001e62:	0004ac23          	sw	zero,24(s1)
}
    80001e66:	60e2                	ld	ra,24(sp)
    80001e68:	6442                	ld	s0,16(sp)
    80001e6a:	64a2                	ld	s1,8(sp)
    80001e6c:	6105                	addi	sp,sp,32
    80001e6e:	8082                	ret

0000000080001e70 <allocproc>:
static struct proc *allocproc(void) {
    80001e70:	1101                	addi	sp,sp,-32
    80001e72:	ec06                	sd	ra,24(sp)
    80001e74:	e822                	sd	s0,16(sp)
    80001e76:	e426                	sd	s1,8(sp)
    80001e78:	e04a                	sd	s2,0(sp)
    80001e7a:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++) {
    80001e7c:	00030497          	auipc	s1,0x30
    80001e80:	efc48493          	addi	s1,s1,-260 # 80031d78 <proc>
    80001e84:	00036917          	auipc	s2,0x36
    80001e88:	8f490913          	addi	s2,s2,-1804 # 80037778 <tickslock>
    acquire(&p->lock);
    80001e8c:	8526                	mv	a0,s1
    80001e8e:	fffff097          	auipc	ra,0xfffff
    80001e92:	eac080e7          	jalr	-340(ra) # 80000d3a <acquire>
    if (p->state == UNUSED) {
    80001e96:	4c9c                	lw	a5,24(s1)
    80001e98:	cf81                	beqz	a5,80001eb0 <allocproc+0x40>
      release(&p->lock);
    80001e9a:	8526                	mv	a0,s1
    80001e9c:	fffff097          	auipc	ra,0xfffff
    80001ea0:	f52080e7          	jalr	-174(ra) # 80000dee <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001ea4:	16848493          	addi	s1,s1,360
    80001ea8:	ff2492e3          	bne	s1,s2,80001e8c <allocproc+0x1c>
  return 0;
    80001eac:	4481                	li	s1,0
    80001eae:	a0b9                	j	80001efc <allocproc+0x8c>
  p->pid = allocpid();
    80001eb0:	00000097          	auipc	ra,0x0
    80001eb4:	e34080e7          	jalr	-460(ra) # 80001ce4 <allocpid>
    80001eb8:	dc88                	sw	a0,56(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    80001eba:	fffff097          	auipc	ra,0xfffff
    80001ebe:	d42080e7          	jalr	-702(ra) # 80000bfc <kalloc>
    80001ec2:	892a                	mv	s2,a0
    80001ec4:	eca8                	sd	a0,88(s1)
    80001ec6:	c131                	beqz	a0,80001f0a <allocproc+0x9a>
  p->pagetable = proc_pagetable(p);
    80001ec8:	8526                	mv	a0,s1
    80001eca:	00000097          	auipc	ra,0x0
    80001ece:	e60080e7          	jalr	-416(ra) # 80001d2a <proc_pagetable>
    80001ed2:	892a                	mv	s2,a0
    80001ed4:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0) {
    80001ed6:	c129                	beqz	a0,80001f18 <allocproc+0xa8>
  memset(&p->context, 0, sizeof(p->context));
    80001ed8:	07000613          	li	a2,112
    80001edc:	4581                	li	a1,0
    80001ede:	06048513          	addi	a0,s1,96
    80001ee2:	fffff097          	auipc	ra,0xfffff
    80001ee6:	f54080e7          	jalr	-172(ra) # 80000e36 <memset>
  p->context.ra = (uint64)forkret;
    80001eea:	00000797          	auipc	a5,0x0
    80001eee:	db478793          	addi	a5,a5,-588 # 80001c9e <forkret>
    80001ef2:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001ef4:	60bc                	ld	a5,64(s1)
    80001ef6:	6705                	lui	a4,0x1
    80001ef8:	97ba                	add	a5,a5,a4
    80001efa:	f4bc                	sd	a5,104(s1)
}
    80001efc:	8526                	mv	a0,s1
    80001efe:	60e2                	ld	ra,24(sp)
    80001f00:	6442                	ld	s0,16(sp)
    80001f02:	64a2                	ld	s1,8(sp)
    80001f04:	6902                	ld	s2,0(sp)
    80001f06:	6105                	addi	sp,sp,32
    80001f08:	8082                	ret
    release(&p->lock);
    80001f0a:	8526                	mv	a0,s1
    80001f0c:	fffff097          	auipc	ra,0xfffff
    80001f10:	ee2080e7          	jalr	-286(ra) # 80000dee <release>
    return 0;
    80001f14:	84ca                	mv	s1,s2
    80001f16:	b7dd                	j	80001efc <allocproc+0x8c>
    freeproc(p);
    80001f18:	8526                	mv	a0,s1
    80001f1a:	00000097          	auipc	ra,0x0
    80001f1e:	efe080e7          	jalr	-258(ra) # 80001e18 <freeproc>
    release(&p->lock);
    80001f22:	8526                	mv	a0,s1
    80001f24:	fffff097          	auipc	ra,0xfffff
    80001f28:	eca080e7          	jalr	-310(ra) # 80000dee <release>
    return 0;
    80001f2c:	84ca                	mv	s1,s2
    80001f2e:	b7f9                	j	80001efc <allocproc+0x8c>

0000000080001f30 <userinit>:
void userinit(void) {
    80001f30:	1101                	addi	sp,sp,-32
    80001f32:	ec06                	sd	ra,24(sp)
    80001f34:	e822                	sd	s0,16(sp)
    80001f36:	e426                	sd	s1,8(sp)
    80001f38:	1000                	addi	s0,sp,32
  p = allocproc();
    80001f3a:	00000097          	auipc	ra,0x0
    80001f3e:	f36080e7          	jalr	-202(ra) # 80001e70 <allocproc>
    80001f42:	84aa                	mv	s1,a0
  initproc = p;
    80001f44:	00007797          	auipc	a5,0x7
    80001f48:	0ca7ba23          	sd	a0,212(a5) # 80009018 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001f4c:	03400613          	li	a2,52
    80001f50:	00007597          	auipc	a1,0x7
    80001f54:	98058593          	addi	a1,a1,-1664 # 800088d0 <initcode>
    80001f58:	6928                	ld	a0,80(a0)
    80001f5a:	fffff097          	auipc	ra,0xfffff
    80001f5e:	56c080e7          	jalr	1388(ra) # 800014c6 <uvminit>
  p->sz = PGSIZE;
    80001f62:	6785                	lui	a5,0x1
    80001f64:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;     // user program counter
    80001f66:	6cb8                	ld	a4,88(s1)
    80001f68:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE; // user stack pointer
    80001f6c:	6cb8                	ld	a4,88(s1)
    80001f6e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001f70:	4641                	li	a2,16
    80001f72:	00006597          	auipc	a1,0x6
    80001f76:	2ae58593          	addi	a1,a1,686 # 80008220 <digits+0x1b8>
    80001f7a:	15848513          	addi	a0,s1,344
    80001f7e:	fffff097          	auipc	ra,0xfffff
    80001f82:	00a080e7          	jalr	10(ra) # 80000f88 <safestrcpy>
  p->cwd = namei("/");
    80001f86:	00006517          	auipc	a0,0x6
    80001f8a:	2aa50513          	addi	a0,a0,682 # 80008230 <digits+0x1c8>
    80001f8e:	00002097          	auipc	ra,0x2
    80001f92:	1b2080e7          	jalr	434(ra) # 80004140 <namei>
    80001f96:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001f9a:	4789                	li	a5,2
    80001f9c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001f9e:	8526                	mv	a0,s1
    80001fa0:	fffff097          	auipc	ra,0xfffff
    80001fa4:	e4e080e7          	jalr	-434(ra) # 80000dee <release>
}
    80001fa8:	60e2                	ld	ra,24(sp)
    80001faa:	6442                	ld	s0,16(sp)
    80001fac:	64a2                	ld	s1,8(sp)
    80001fae:	6105                	addi	sp,sp,32
    80001fb0:	8082                	ret

0000000080001fb2 <growproc>:
int growproc(int n) {
    80001fb2:	1101                	addi	sp,sp,-32
    80001fb4:	ec06                	sd	ra,24(sp)
    80001fb6:	e822                	sd	s0,16(sp)
    80001fb8:	e426                	sd	s1,8(sp)
    80001fba:	e04a                	sd	s2,0(sp)
    80001fbc:	1000                	addi	s0,sp,32
    80001fbe:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001fc0:	00000097          	auipc	ra,0x0
    80001fc4:	ca6080e7          	jalr	-858(ra) # 80001c66 <myproc>
    80001fc8:	892a                	mv	s2,a0
  sz = p->sz;
    80001fca:	652c                	ld	a1,72(a0)
    80001fcc:	0005861b          	sext.w	a2,a1
  if (n > 0) {
    80001fd0:	00904f63          	bgtz	s1,80001fee <growproc+0x3c>
  } else if (n < 0) {
    80001fd4:	0204cc63          	bltz	s1,8000200c <growproc+0x5a>
  p->sz = sz;
    80001fd8:	1602                	slli	a2,a2,0x20
    80001fda:	9201                	srli	a2,a2,0x20
    80001fdc:	04c93423          	sd	a2,72(s2)
  return 0;
    80001fe0:	4501                	li	a0,0
}
    80001fe2:	60e2                	ld	ra,24(sp)
    80001fe4:	6442                	ld	s0,16(sp)
    80001fe6:	64a2                	ld	s1,8(sp)
    80001fe8:	6902                	ld	s2,0(sp)
    80001fea:	6105                	addi	sp,sp,32
    80001fec:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001fee:	9e25                	addw	a2,a2,s1
    80001ff0:	1602                	slli	a2,a2,0x20
    80001ff2:	9201                	srli	a2,a2,0x20
    80001ff4:	1582                	slli	a1,a1,0x20
    80001ff6:	9181                	srli	a1,a1,0x20
    80001ff8:	6928                	ld	a0,80(a0)
    80001ffa:	fffff097          	auipc	ra,0xfffff
    80001ffe:	586080e7          	jalr	1414(ra) # 80001580 <uvmalloc>
    80002002:	0005061b          	sext.w	a2,a0
    80002006:	fa69                	bnez	a2,80001fd8 <growproc+0x26>
      return -1;
    80002008:	557d                	li	a0,-1
    8000200a:	bfe1                	j	80001fe2 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000200c:	9e25                	addw	a2,a2,s1
    8000200e:	1602                	slli	a2,a2,0x20
    80002010:	9201                	srli	a2,a2,0x20
    80002012:	1582                	slli	a1,a1,0x20
    80002014:	9181                	srli	a1,a1,0x20
    80002016:	6928                	ld	a0,80(a0)
    80002018:	fffff097          	auipc	ra,0xfffff
    8000201c:	520080e7          	jalr	1312(ra) # 80001538 <uvmdealloc>
    80002020:	0005061b          	sext.w	a2,a0
    80002024:	bf55                	j	80001fd8 <growproc+0x26>

0000000080002026 <fork>:
int fork(void) {
    80002026:	7139                	addi	sp,sp,-64
    80002028:	fc06                	sd	ra,56(sp)
    8000202a:	f822                	sd	s0,48(sp)
    8000202c:	f426                	sd	s1,40(sp)
    8000202e:	f04a                	sd	s2,32(sp)
    80002030:	ec4e                	sd	s3,24(sp)
    80002032:	e852                	sd	s4,16(sp)
    80002034:	e456                	sd	s5,8(sp)
    80002036:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80002038:	00000097          	auipc	ra,0x0
    8000203c:	c2e080e7          	jalr	-978(ra) # 80001c66 <myproc>
    80002040:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0) {
    80002042:	00000097          	auipc	ra,0x0
    80002046:	e2e080e7          	jalr	-466(ra) # 80001e70 <allocproc>
    8000204a:	c17d                	beqz	a0,80002130 <fork+0x10a>
    8000204c:	8a2a                	mv	s4,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    8000204e:	048ab603          	ld	a2,72(s5)
    80002052:	692c                	ld	a1,80(a0)
    80002054:	050ab503          	ld	a0,80(s5)
    80002058:	fffff097          	auipc	ra,0xfffff
    8000205c:	674080e7          	jalr	1652(ra) # 800016cc <uvmcopy>
    80002060:	04054a63          	bltz	a0,800020b4 <fork+0x8e>
  np->sz = p->sz;
    80002064:	048ab783          	ld	a5,72(s5)
    80002068:	04fa3423          	sd	a5,72(s4)
  np->parent = p;
    8000206c:	035a3023          	sd	s5,32(s4)
  *(np->trapframe) = *(p->trapframe);
    80002070:	058ab683          	ld	a3,88(s5)
    80002074:	87b6                	mv	a5,a3
    80002076:	058a3703          	ld	a4,88(s4)
    8000207a:	12068693          	addi	a3,a3,288
    8000207e:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80002082:	6788                	ld	a0,8(a5)
    80002084:	6b8c                	ld	a1,16(a5)
    80002086:	6f90                	ld	a2,24(a5)
    80002088:	01073023          	sd	a6,0(a4)
    8000208c:	e708                	sd	a0,8(a4)
    8000208e:	eb0c                	sd	a1,16(a4)
    80002090:	ef10                	sd	a2,24(a4)
    80002092:	02078793          	addi	a5,a5,32
    80002096:	02070713          	addi	a4,a4,32
    8000209a:	fed792e3          	bne	a5,a3,8000207e <fork+0x58>
  np->trapframe->a0 = 0;
    8000209e:	058a3783          	ld	a5,88(s4)
    800020a2:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    800020a6:	0d0a8493          	addi	s1,s5,208
    800020aa:	0d0a0913          	addi	s2,s4,208
    800020ae:	150a8993          	addi	s3,s5,336
    800020b2:	a00d                	j	800020d4 <fork+0xae>
    freeproc(np);
    800020b4:	8552                	mv	a0,s4
    800020b6:	00000097          	auipc	ra,0x0
    800020ba:	d62080e7          	jalr	-670(ra) # 80001e18 <freeproc>
    release(&np->lock);
    800020be:	8552                	mv	a0,s4
    800020c0:	fffff097          	auipc	ra,0xfffff
    800020c4:	d2e080e7          	jalr	-722(ra) # 80000dee <release>
    return -1;
    800020c8:	54fd                	li	s1,-1
    800020ca:	a889                	j	8000211c <fork+0xf6>
  for (i = 0; i < NOFILE; i++)
    800020cc:	04a1                	addi	s1,s1,8
    800020ce:	0921                	addi	s2,s2,8
    800020d0:	01348b63          	beq	s1,s3,800020e6 <fork+0xc0>
    if (p->ofile[i])
    800020d4:	6088                	ld	a0,0(s1)
    800020d6:	d97d                	beqz	a0,800020cc <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    800020d8:	00002097          	auipc	ra,0x2
    800020dc:	6f4080e7          	jalr	1780(ra) # 800047cc <filedup>
    800020e0:	00a93023          	sd	a0,0(s2)
    800020e4:	b7e5                	j	800020cc <fork+0xa6>
  np->cwd = idup(p->cwd);
    800020e6:	150ab503          	ld	a0,336(s5)
    800020ea:	00002097          	auipc	ra,0x2
    800020ee:	864080e7          	jalr	-1948(ra) # 8000394e <idup>
    800020f2:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800020f6:	4641                	li	a2,16
    800020f8:	158a8593          	addi	a1,s5,344
    800020fc:	158a0513          	addi	a0,s4,344
    80002100:	fffff097          	auipc	ra,0xfffff
    80002104:	e88080e7          	jalr	-376(ra) # 80000f88 <safestrcpy>
  pid = np->pid;
    80002108:	038a2483          	lw	s1,56(s4)
  np->state = RUNNABLE;
    8000210c:	4789                	li	a5,2
    8000210e:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80002112:	8552                	mv	a0,s4
    80002114:	fffff097          	auipc	ra,0xfffff
    80002118:	cda080e7          	jalr	-806(ra) # 80000dee <release>
}
    8000211c:	8526                	mv	a0,s1
    8000211e:	70e2                	ld	ra,56(sp)
    80002120:	7442                	ld	s0,48(sp)
    80002122:	74a2                	ld	s1,40(sp)
    80002124:	7902                	ld	s2,32(sp)
    80002126:	69e2                	ld	s3,24(sp)
    80002128:	6a42                	ld	s4,16(sp)
    8000212a:	6aa2                	ld	s5,8(sp)
    8000212c:	6121                	addi	sp,sp,64
    8000212e:	8082                	ret
    return -1;
    80002130:	54fd                	li	s1,-1
    80002132:	b7ed                	j	8000211c <fork+0xf6>

0000000080002134 <reparent>:
void reparent(struct proc *p) {
    80002134:	7179                	addi	sp,sp,-48
    80002136:	f406                	sd	ra,40(sp)
    80002138:	f022                	sd	s0,32(sp)
    8000213a:	ec26                	sd	s1,24(sp)
    8000213c:	e84a                	sd	s2,16(sp)
    8000213e:	e44e                	sd	s3,8(sp)
    80002140:	e052                	sd	s4,0(sp)
    80002142:	1800                	addi	s0,sp,48
    80002144:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002146:	00030497          	auipc	s1,0x30
    8000214a:	c3248493          	addi	s1,s1,-974 # 80031d78 <proc>
      pp->parent = initproc;
    8000214e:	00007a17          	auipc	s4,0x7
    80002152:	ecaa0a13          	addi	s4,s4,-310 # 80009018 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002156:	00035997          	auipc	s3,0x35
    8000215a:	62298993          	addi	s3,s3,1570 # 80037778 <tickslock>
    8000215e:	a029                	j	80002168 <reparent+0x34>
    80002160:	16848493          	addi	s1,s1,360
    80002164:	03348363          	beq	s1,s3,8000218a <reparent+0x56>
    if (pp->parent == p) {
    80002168:	709c                	ld	a5,32(s1)
    8000216a:	ff279be3          	bne	a5,s2,80002160 <reparent+0x2c>
      acquire(&pp->lock);
    8000216e:	8526                	mv	a0,s1
    80002170:	fffff097          	auipc	ra,0xfffff
    80002174:	bca080e7          	jalr	-1078(ra) # 80000d3a <acquire>
      pp->parent = initproc;
    80002178:	000a3783          	ld	a5,0(s4)
    8000217c:	f09c                	sd	a5,32(s1)
      release(&pp->lock);
    8000217e:	8526                	mv	a0,s1
    80002180:	fffff097          	auipc	ra,0xfffff
    80002184:	c6e080e7          	jalr	-914(ra) # 80000dee <release>
    80002188:	bfe1                	j	80002160 <reparent+0x2c>
}
    8000218a:	70a2                	ld	ra,40(sp)
    8000218c:	7402                	ld	s0,32(sp)
    8000218e:	64e2                	ld	s1,24(sp)
    80002190:	6942                	ld	s2,16(sp)
    80002192:	69a2                	ld	s3,8(sp)
    80002194:	6a02                	ld	s4,0(sp)
    80002196:	6145                	addi	sp,sp,48
    80002198:	8082                	ret

000000008000219a <scheduler>:
void scheduler(void) {
    8000219a:	711d                	addi	sp,sp,-96
    8000219c:	ec86                	sd	ra,88(sp)
    8000219e:	e8a2                	sd	s0,80(sp)
    800021a0:	e4a6                	sd	s1,72(sp)
    800021a2:	e0ca                	sd	s2,64(sp)
    800021a4:	fc4e                	sd	s3,56(sp)
    800021a6:	f852                	sd	s4,48(sp)
    800021a8:	f456                	sd	s5,40(sp)
    800021aa:	f05a                	sd	s6,32(sp)
    800021ac:	ec5e                	sd	s7,24(sp)
    800021ae:	e862                	sd	s8,16(sp)
    800021b0:	e466                	sd	s9,8(sp)
    800021b2:	1080                	addi	s0,sp,96
    800021b4:	8792                	mv	a5,tp
  int id = r_tp();
    800021b6:	2781                	sext.w	a5,a5
  c->proc = 0;
    800021b8:	00779c13          	slli	s8,a5,0x7
    800021bc:	0002f717          	auipc	a4,0x2f
    800021c0:	7a470713          	addi	a4,a4,1956 # 80031960 <pid_lock>
    800021c4:	9762                	add	a4,a4,s8
    800021c6:	00073c23          	sd	zero,24(a4)
        swtch(&c->context, &p->context);
    800021ca:	0002f717          	auipc	a4,0x2f
    800021ce:	7b670713          	addi	a4,a4,1974 # 80031980 <cpus+0x8>
    800021d2:	9c3a                	add	s8,s8,a4
    int nproc = 0;
    800021d4:	4c81                	li	s9,0
      if (p->state == RUNNABLE) {
    800021d6:	4a89                	li	s5,2
        c->proc = p;
    800021d8:	079e                	slli	a5,a5,0x7
    800021da:	0002fb17          	auipc	s6,0x2f
    800021de:	786b0b13          	addi	s6,s6,1926 # 80031960 <pid_lock>
    800021e2:	9b3e                	add	s6,s6,a5
    for (p = proc; p < &proc[NPROC]; p++) {
    800021e4:	00035a17          	auipc	s4,0x35
    800021e8:	594a0a13          	addi	s4,s4,1428 # 80037778 <tickslock>
    800021ec:	a8a1                	j	80002244 <scheduler+0xaa>
      release(&p->lock);
    800021ee:	8526                	mv	a0,s1
    800021f0:	fffff097          	auipc	ra,0xfffff
    800021f4:	bfe080e7          	jalr	-1026(ra) # 80000dee <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    800021f8:	16848493          	addi	s1,s1,360
    800021fc:	03448a63          	beq	s1,s4,80002230 <scheduler+0x96>
      acquire(&p->lock);
    80002200:	8526                	mv	a0,s1
    80002202:	fffff097          	auipc	ra,0xfffff
    80002206:	b38080e7          	jalr	-1224(ra) # 80000d3a <acquire>
      if (p->state != UNUSED) {
    8000220a:	4c9c                	lw	a5,24(s1)
    8000220c:	d3ed                	beqz	a5,800021ee <scheduler+0x54>
        nproc++;
    8000220e:	2985                	addiw	s3,s3,1
      if (p->state == RUNNABLE) {
    80002210:	fd579fe3          	bne	a5,s5,800021ee <scheduler+0x54>
        p->state = RUNNING;
    80002214:	0174ac23          	sw	s7,24(s1)
        c->proc = p;
    80002218:	009b3c23          	sd	s1,24(s6)
        swtch(&c->context, &p->context);
    8000221c:	06048593          	addi	a1,s1,96
    80002220:	8562                	mv	a0,s8
    80002222:	00000097          	auipc	ra,0x0
    80002226:	60c080e7          	jalr	1548(ra) # 8000282e <swtch>
        c->proc = 0;
    8000222a:	000b3c23          	sd	zero,24(s6)
    8000222e:	b7c1                	j	800021ee <scheduler+0x54>
    if (nproc <= 2) { // only init and sh exist
    80002230:	013aca63          	blt	s5,s3,80002244 <scheduler+0xaa>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002234:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80002238:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    8000223c:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80002240:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002244:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80002248:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    8000224c:	10079073          	csrw	sstatus,a5
    int nproc = 0;
    80002250:	89e6                	mv	s3,s9
    for (p = proc; p < &proc[NPROC]; p++) {
    80002252:	00030497          	auipc	s1,0x30
    80002256:	b2648493          	addi	s1,s1,-1242 # 80031d78 <proc>
        p->state = RUNNING;
    8000225a:	4b8d                	li	s7,3
    8000225c:	b755                	j	80002200 <scheduler+0x66>

000000008000225e <sched>:
void sched(void) {
    8000225e:	7179                	addi	sp,sp,-48
    80002260:	f406                	sd	ra,40(sp)
    80002262:	f022                	sd	s0,32(sp)
    80002264:	ec26                	sd	s1,24(sp)
    80002266:	e84a                	sd	s2,16(sp)
    80002268:	e44e                	sd	s3,8(sp)
    8000226a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000226c:	00000097          	auipc	ra,0x0
    80002270:	9fa080e7          	jalr	-1542(ra) # 80001c66 <myproc>
    80002274:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    80002276:	fffff097          	auipc	ra,0xfffff
    8000227a:	a4a080e7          	jalr	-1462(ra) # 80000cc0 <holding>
    8000227e:	c93d                	beqz	a0,800022f4 <sched+0x96>
  asm volatile("mv %0, tp" : "=r"(x));
    80002280:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    80002282:	2781                	sext.w	a5,a5
    80002284:	079e                	slli	a5,a5,0x7
    80002286:	0002f717          	auipc	a4,0x2f
    8000228a:	6da70713          	addi	a4,a4,1754 # 80031960 <pid_lock>
    8000228e:	97ba                	add	a5,a5,a4
    80002290:	0907a703          	lw	a4,144(a5)
    80002294:	4785                	li	a5,1
    80002296:	06f71763          	bne	a4,a5,80002304 <sched+0xa6>
  if (p->state == RUNNING)
    8000229a:	4c98                	lw	a4,24(s1)
    8000229c:	478d                	li	a5,3
    8000229e:	06f70b63          	beq	a4,a5,80002314 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800022a2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800022a6:	8b89                	andi	a5,a5,2
  if (intr_get())
    800022a8:	efb5                	bnez	a5,80002324 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r"(x));
    800022aa:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800022ac:	0002f917          	auipc	s2,0x2f
    800022b0:	6b490913          	addi	s2,s2,1716 # 80031960 <pid_lock>
    800022b4:	2781                	sext.w	a5,a5
    800022b6:	079e                	slli	a5,a5,0x7
    800022b8:	97ca                	add	a5,a5,s2
    800022ba:	0947a983          	lw	s3,148(a5)
    800022be:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800022c0:	2781                	sext.w	a5,a5
    800022c2:	079e                	slli	a5,a5,0x7
    800022c4:	0002f597          	auipc	a1,0x2f
    800022c8:	6bc58593          	addi	a1,a1,1724 # 80031980 <cpus+0x8>
    800022cc:	95be                	add	a1,a1,a5
    800022ce:	06048513          	addi	a0,s1,96
    800022d2:	00000097          	auipc	ra,0x0
    800022d6:	55c080e7          	jalr	1372(ra) # 8000282e <swtch>
    800022da:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800022dc:	2781                	sext.w	a5,a5
    800022de:	079e                	slli	a5,a5,0x7
    800022e0:	97ca                	add	a5,a5,s2
    800022e2:	0937aa23          	sw	s3,148(a5)
}
    800022e6:	70a2                	ld	ra,40(sp)
    800022e8:	7402                	ld	s0,32(sp)
    800022ea:	64e2                	ld	s1,24(sp)
    800022ec:	6942                	ld	s2,16(sp)
    800022ee:	69a2                	ld	s3,8(sp)
    800022f0:	6145                	addi	sp,sp,48
    800022f2:	8082                	ret
    panic("sched p->lock");
    800022f4:	00006517          	auipc	a0,0x6
    800022f8:	f4450513          	addi	a0,a0,-188 # 80008238 <digits+0x1d0>
    800022fc:	ffffe097          	auipc	ra,0xffffe
    80002300:	2e8080e7          	jalr	744(ra) # 800005e4 <panic>
    panic("sched locks");
    80002304:	00006517          	auipc	a0,0x6
    80002308:	f4450513          	addi	a0,a0,-188 # 80008248 <digits+0x1e0>
    8000230c:	ffffe097          	auipc	ra,0xffffe
    80002310:	2d8080e7          	jalr	728(ra) # 800005e4 <panic>
    panic("sched running");
    80002314:	00006517          	auipc	a0,0x6
    80002318:	f4450513          	addi	a0,a0,-188 # 80008258 <digits+0x1f0>
    8000231c:	ffffe097          	auipc	ra,0xffffe
    80002320:	2c8080e7          	jalr	712(ra) # 800005e4 <panic>
    panic("sched interruptible");
    80002324:	00006517          	auipc	a0,0x6
    80002328:	f4450513          	addi	a0,a0,-188 # 80008268 <digits+0x200>
    8000232c:	ffffe097          	auipc	ra,0xffffe
    80002330:	2b8080e7          	jalr	696(ra) # 800005e4 <panic>

0000000080002334 <exit>:
void exit(int status) {
    80002334:	7179                	addi	sp,sp,-48
    80002336:	f406                	sd	ra,40(sp)
    80002338:	f022                	sd	s0,32(sp)
    8000233a:	ec26                	sd	s1,24(sp)
    8000233c:	e84a                	sd	s2,16(sp)
    8000233e:	e44e                	sd	s3,8(sp)
    80002340:	e052                	sd	s4,0(sp)
    80002342:	1800                	addi	s0,sp,48
    80002344:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002346:	00000097          	auipc	ra,0x0
    8000234a:	920080e7          	jalr	-1760(ra) # 80001c66 <myproc>
    8000234e:	89aa                	mv	s3,a0
  if (p == initproc)
    80002350:	00007797          	auipc	a5,0x7
    80002354:	cc87b783          	ld	a5,-824(a5) # 80009018 <initproc>
    80002358:	0d050493          	addi	s1,a0,208
    8000235c:	15050913          	addi	s2,a0,336
    80002360:	02a79363          	bne	a5,a0,80002386 <exit+0x52>
    panic("init exiting");
    80002364:	00006517          	auipc	a0,0x6
    80002368:	f1c50513          	addi	a0,a0,-228 # 80008280 <digits+0x218>
    8000236c:	ffffe097          	auipc	ra,0xffffe
    80002370:	278080e7          	jalr	632(ra) # 800005e4 <panic>
      fileclose(f);
    80002374:	00002097          	auipc	ra,0x2
    80002378:	4aa080e7          	jalr	1194(ra) # 8000481e <fileclose>
      p->ofile[fd] = 0;
    8000237c:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++) {
    80002380:	04a1                	addi	s1,s1,8
    80002382:	01248563          	beq	s1,s2,8000238c <exit+0x58>
    if (p->ofile[fd]) {
    80002386:	6088                	ld	a0,0(s1)
    80002388:	f575                	bnez	a0,80002374 <exit+0x40>
    8000238a:	bfdd                	j	80002380 <exit+0x4c>
  begin_op();
    8000238c:	00002097          	auipc	ra,0x2
    80002390:	fc0080e7          	jalr	-64(ra) # 8000434c <begin_op>
  iput(p->cwd);
    80002394:	1509b503          	ld	a0,336(s3)
    80002398:	00001097          	auipc	ra,0x1
    8000239c:	7ae080e7          	jalr	1966(ra) # 80003b46 <iput>
  end_op();
    800023a0:	00002097          	auipc	ra,0x2
    800023a4:	02c080e7          	jalr	44(ra) # 800043cc <end_op>
  p->cwd = 0;
    800023a8:	1409b823          	sd	zero,336(s3)
  acquire(&initproc->lock);
    800023ac:	00007497          	auipc	s1,0x7
    800023b0:	c6c48493          	addi	s1,s1,-916 # 80009018 <initproc>
    800023b4:	6088                	ld	a0,0(s1)
    800023b6:	fffff097          	auipc	ra,0xfffff
    800023ba:	984080e7          	jalr	-1660(ra) # 80000d3a <acquire>
  wakeup1(initproc);
    800023be:	6088                	ld	a0,0(s1)
    800023c0:	fffff097          	auipc	ra,0xfffff
    800023c4:	766080e7          	jalr	1894(ra) # 80001b26 <wakeup1>
  release(&initproc->lock);
    800023c8:	6088                	ld	a0,0(s1)
    800023ca:	fffff097          	auipc	ra,0xfffff
    800023ce:	a24080e7          	jalr	-1500(ra) # 80000dee <release>
  acquire(&p->lock);
    800023d2:	854e                	mv	a0,s3
    800023d4:	fffff097          	auipc	ra,0xfffff
    800023d8:	966080e7          	jalr	-1690(ra) # 80000d3a <acquire>
  struct proc *original_parent = p->parent;
    800023dc:	0209b483          	ld	s1,32(s3)
  release(&p->lock);
    800023e0:	854e                	mv	a0,s3
    800023e2:	fffff097          	auipc	ra,0xfffff
    800023e6:	a0c080e7          	jalr	-1524(ra) # 80000dee <release>
  acquire(&original_parent->lock);
    800023ea:	8526                	mv	a0,s1
    800023ec:	fffff097          	auipc	ra,0xfffff
    800023f0:	94e080e7          	jalr	-1714(ra) # 80000d3a <acquire>
  acquire(&p->lock);
    800023f4:	854e                	mv	a0,s3
    800023f6:	fffff097          	auipc	ra,0xfffff
    800023fa:	944080e7          	jalr	-1724(ra) # 80000d3a <acquire>
  reparent(p);
    800023fe:	854e                	mv	a0,s3
    80002400:	00000097          	auipc	ra,0x0
    80002404:	d34080e7          	jalr	-716(ra) # 80002134 <reparent>
  wakeup1(original_parent);
    80002408:	8526                	mv	a0,s1
    8000240a:	fffff097          	auipc	ra,0xfffff
    8000240e:	71c080e7          	jalr	1820(ra) # 80001b26 <wakeup1>
  p->xstate = status;
    80002412:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    80002416:	4791                	li	a5,4
    80002418:	00f9ac23          	sw	a5,24(s3)
  release(&original_parent->lock);
    8000241c:	8526                	mv	a0,s1
    8000241e:	fffff097          	auipc	ra,0xfffff
    80002422:	9d0080e7          	jalr	-1584(ra) # 80000dee <release>
  sched();
    80002426:	00000097          	auipc	ra,0x0
    8000242a:	e38080e7          	jalr	-456(ra) # 8000225e <sched>
  panic("zombie exit");
    8000242e:	00006517          	auipc	a0,0x6
    80002432:	e6250513          	addi	a0,a0,-414 # 80008290 <digits+0x228>
    80002436:	ffffe097          	auipc	ra,0xffffe
    8000243a:	1ae080e7          	jalr	430(ra) # 800005e4 <panic>

000000008000243e <yield>:
void yield(void) {
    8000243e:	1101                	addi	sp,sp,-32
    80002440:	ec06                	sd	ra,24(sp)
    80002442:	e822                	sd	s0,16(sp)
    80002444:	e426                	sd	s1,8(sp)
    80002446:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002448:	00000097          	auipc	ra,0x0
    8000244c:	81e080e7          	jalr	-2018(ra) # 80001c66 <myproc>
    80002450:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002452:	fffff097          	auipc	ra,0xfffff
    80002456:	8e8080e7          	jalr	-1816(ra) # 80000d3a <acquire>
  p->state = RUNNABLE;
    8000245a:	4789                	li	a5,2
    8000245c:	cc9c                	sw	a5,24(s1)
  sched();
    8000245e:	00000097          	auipc	ra,0x0
    80002462:	e00080e7          	jalr	-512(ra) # 8000225e <sched>
  release(&p->lock);
    80002466:	8526                	mv	a0,s1
    80002468:	fffff097          	auipc	ra,0xfffff
    8000246c:	986080e7          	jalr	-1658(ra) # 80000dee <release>
}
    80002470:	60e2                	ld	ra,24(sp)
    80002472:	6442                	ld	s0,16(sp)
    80002474:	64a2                	ld	s1,8(sp)
    80002476:	6105                	addi	sp,sp,32
    80002478:	8082                	ret

000000008000247a <sleep>:
void sleep(void *chan, struct spinlock *lk) {
    8000247a:	7179                	addi	sp,sp,-48
    8000247c:	f406                	sd	ra,40(sp)
    8000247e:	f022                	sd	s0,32(sp)
    80002480:	ec26                	sd	s1,24(sp)
    80002482:	e84a                	sd	s2,16(sp)
    80002484:	e44e                	sd	s3,8(sp)
    80002486:	1800                	addi	s0,sp,48
    80002488:	89aa                	mv	s3,a0
    8000248a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000248c:	fffff097          	auipc	ra,0xfffff
    80002490:	7da080e7          	jalr	2010(ra) # 80001c66 <myproc>
    80002494:	84aa                	mv	s1,a0
  if (lk != &p->lock) { // DOC: sleeplock0
    80002496:	05250663          	beq	a0,s2,800024e2 <sleep+0x68>
    acquire(&p->lock);  // DOC: sleeplock1
    8000249a:	fffff097          	auipc	ra,0xfffff
    8000249e:	8a0080e7          	jalr	-1888(ra) # 80000d3a <acquire>
    release(lk);
    800024a2:	854a                	mv	a0,s2
    800024a4:	fffff097          	auipc	ra,0xfffff
    800024a8:	94a080e7          	jalr	-1718(ra) # 80000dee <release>
  p->chan = chan;
    800024ac:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    800024b0:	4785                	li	a5,1
    800024b2:	cc9c                	sw	a5,24(s1)
  sched();
    800024b4:	00000097          	auipc	ra,0x0
    800024b8:	daa080e7          	jalr	-598(ra) # 8000225e <sched>
  p->chan = 0;
    800024bc:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    800024c0:	8526                	mv	a0,s1
    800024c2:	fffff097          	auipc	ra,0xfffff
    800024c6:	92c080e7          	jalr	-1748(ra) # 80000dee <release>
    acquire(lk);
    800024ca:	854a                	mv	a0,s2
    800024cc:	fffff097          	auipc	ra,0xfffff
    800024d0:	86e080e7          	jalr	-1938(ra) # 80000d3a <acquire>
}
    800024d4:	70a2                	ld	ra,40(sp)
    800024d6:	7402                	ld	s0,32(sp)
    800024d8:	64e2                	ld	s1,24(sp)
    800024da:	6942                	ld	s2,16(sp)
    800024dc:	69a2                	ld	s3,8(sp)
    800024de:	6145                	addi	sp,sp,48
    800024e0:	8082                	ret
  p->chan = chan;
    800024e2:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    800024e6:	4785                	li	a5,1
    800024e8:	cd1c                	sw	a5,24(a0)
  sched();
    800024ea:	00000097          	auipc	ra,0x0
    800024ee:	d74080e7          	jalr	-652(ra) # 8000225e <sched>
  p->chan = 0;
    800024f2:	0204b423          	sd	zero,40(s1)
  if (lk != &p->lock) {
    800024f6:	bff9                	j	800024d4 <sleep+0x5a>

00000000800024f8 <wait>:
int wait(uint64 addr) {
    800024f8:	715d                	addi	sp,sp,-80
    800024fa:	e486                	sd	ra,72(sp)
    800024fc:	e0a2                	sd	s0,64(sp)
    800024fe:	fc26                	sd	s1,56(sp)
    80002500:	f84a                	sd	s2,48(sp)
    80002502:	f44e                	sd	s3,40(sp)
    80002504:	f052                	sd	s4,32(sp)
    80002506:	ec56                	sd	s5,24(sp)
    80002508:	e85a                	sd	s6,16(sp)
    8000250a:	e45e                	sd	s7,8(sp)
    8000250c:	0880                	addi	s0,sp,80
    8000250e:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002510:	fffff097          	auipc	ra,0xfffff
    80002514:	756080e7          	jalr	1878(ra) # 80001c66 <myproc>
    80002518:	892a                	mv	s2,a0
  acquire(&p->lock);
    8000251a:	fffff097          	auipc	ra,0xfffff
    8000251e:	820080e7          	jalr	-2016(ra) # 80000d3a <acquire>
    havekids = 0;
    80002522:	4b81                	li	s7,0
        if (np->state == ZOMBIE) {
    80002524:	4a11                	li	s4,4
        havekids = 1;
    80002526:	4a85                	li	s5,1
    for (np = proc; np < &proc[NPROC]; np++) {
    80002528:	00035997          	auipc	s3,0x35
    8000252c:	25098993          	addi	s3,s3,592 # 80037778 <tickslock>
    havekids = 0;
    80002530:	875e                	mv	a4,s7
    for (np = proc; np < &proc[NPROC]; np++) {
    80002532:	00030497          	auipc	s1,0x30
    80002536:	84648493          	addi	s1,s1,-1978 # 80031d78 <proc>
    8000253a:	a08d                	j	8000259c <wait+0xa4>
          pid = np->pid;
    8000253c:	0384a983          	lw	s3,56(s1)
          freeproc(np);
    80002540:	8526                	mv	a0,s1
    80002542:	00000097          	auipc	ra,0x0
    80002546:	8d6080e7          	jalr	-1834(ra) # 80001e18 <freeproc>
          if (addr != 0 &&
    8000254a:	000b0e63          	beqz	s6,80002566 <wait+0x6e>
              (res = copyout(p->pagetable, addr, (char *)&np->xstate,
    8000254e:	4691                	li	a3,4
    80002550:	03448613          	addi	a2,s1,52
    80002554:	85da                	mv	a1,s6
    80002556:	05093503          	ld	a0,80(s2)
    8000255a:	fffff097          	auipc	ra,0xfffff
    8000255e:	4d8080e7          	jalr	1240(ra) # 80001a32 <copyout>
          if (addr != 0 &&
    80002562:	00054d63          	bltz	a0,8000257c <wait+0x84>
          release(&np->lock);
    80002566:	8526                	mv	a0,s1
    80002568:	fffff097          	auipc	ra,0xfffff
    8000256c:	886080e7          	jalr	-1914(ra) # 80000dee <release>
          release(&p->lock);
    80002570:	854a                	mv	a0,s2
    80002572:	fffff097          	auipc	ra,0xfffff
    80002576:	87c080e7          	jalr	-1924(ra) # 80000dee <release>
          return pid;
    8000257a:	a8a9                	j	800025d4 <wait+0xdc>
            release(&np->lock);
    8000257c:	8526                	mv	a0,s1
    8000257e:	fffff097          	auipc	ra,0xfffff
    80002582:	870080e7          	jalr	-1936(ra) # 80000dee <release>
            release(&p->lock);
    80002586:	854a                	mv	a0,s2
    80002588:	fffff097          	auipc	ra,0xfffff
    8000258c:	866080e7          	jalr	-1946(ra) # 80000dee <release>
            return -1;
    80002590:	59fd                	li	s3,-1
    80002592:	a089                	j	800025d4 <wait+0xdc>
    for (np = proc; np < &proc[NPROC]; np++) {
    80002594:	16848493          	addi	s1,s1,360
    80002598:	03348463          	beq	s1,s3,800025c0 <wait+0xc8>
      if (np->parent == p) {
    8000259c:	709c                	ld	a5,32(s1)
    8000259e:	ff279be3          	bne	a5,s2,80002594 <wait+0x9c>
        acquire(&np->lock);
    800025a2:	8526                	mv	a0,s1
    800025a4:	ffffe097          	auipc	ra,0xffffe
    800025a8:	796080e7          	jalr	1942(ra) # 80000d3a <acquire>
        if (np->state == ZOMBIE) {
    800025ac:	4c9c                	lw	a5,24(s1)
    800025ae:	f94787e3          	beq	a5,s4,8000253c <wait+0x44>
        release(&np->lock);
    800025b2:	8526                	mv	a0,s1
    800025b4:	fffff097          	auipc	ra,0xfffff
    800025b8:	83a080e7          	jalr	-1990(ra) # 80000dee <release>
        havekids = 1;
    800025bc:	8756                	mv	a4,s5
    800025be:	bfd9                	j	80002594 <wait+0x9c>
    if (!havekids || p->killed) {
    800025c0:	c701                	beqz	a4,800025c8 <wait+0xd0>
    800025c2:	03092783          	lw	a5,48(s2)
    800025c6:	c39d                	beqz	a5,800025ec <wait+0xf4>
      release(&p->lock);
    800025c8:	854a                	mv	a0,s2
    800025ca:	fffff097          	auipc	ra,0xfffff
    800025ce:	824080e7          	jalr	-2012(ra) # 80000dee <release>
      return -1;
    800025d2:	59fd                	li	s3,-1
}
    800025d4:	854e                	mv	a0,s3
    800025d6:	60a6                	ld	ra,72(sp)
    800025d8:	6406                	ld	s0,64(sp)
    800025da:	74e2                	ld	s1,56(sp)
    800025dc:	7942                	ld	s2,48(sp)
    800025de:	79a2                	ld	s3,40(sp)
    800025e0:	7a02                	ld	s4,32(sp)
    800025e2:	6ae2                	ld	s5,24(sp)
    800025e4:	6b42                	ld	s6,16(sp)
    800025e6:	6ba2                	ld	s7,8(sp)
    800025e8:	6161                	addi	sp,sp,80
    800025ea:	8082                	ret
    sleep(p, &p->lock); // DOC: wait-sleep
    800025ec:	85ca                	mv	a1,s2
    800025ee:	854a                	mv	a0,s2
    800025f0:	00000097          	auipc	ra,0x0
    800025f4:	e8a080e7          	jalr	-374(ra) # 8000247a <sleep>
    havekids = 0;
    800025f8:	bf25                	j	80002530 <wait+0x38>

00000000800025fa <wakeup>:
void wakeup(void *chan) {
    800025fa:	7139                	addi	sp,sp,-64
    800025fc:	fc06                	sd	ra,56(sp)
    800025fe:	f822                	sd	s0,48(sp)
    80002600:	f426                	sd	s1,40(sp)
    80002602:	f04a                	sd	s2,32(sp)
    80002604:	ec4e                	sd	s3,24(sp)
    80002606:	e852                	sd	s4,16(sp)
    80002608:	e456                	sd	s5,8(sp)
    8000260a:	0080                	addi	s0,sp,64
    8000260c:	8a2a                	mv	s4,a0
  for (p = proc; p < &proc[NPROC]; p++) {
    8000260e:	0002f497          	auipc	s1,0x2f
    80002612:	76a48493          	addi	s1,s1,1898 # 80031d78 <proc>
    if (p->state == SLEEPING && p->chan == chan) {
    80002616:	4985                	li	s3,1
      p->state = RUNNABLE;
    80002618:	4a89                	li	s5,2
  for (p = proc; p < &proc[NPROC]; p++) {
    8000261a:	00035917          	auipc	s2,0x35
    8000261e:	15e90913          	addi	s2,s2,350 # 80037778 <tickslock>
    80002622:	a811                	j	80002636 <wakeup+0x3c>
    release(&p->lock);
    80002624:	8526                	mv	a0,s1
    80002626:	ffffe097          	auipc	ra,0xffffe
    8000262a:	7c8080e7          	jalr	1992(ra) # 80000dee <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    8000262e:	16848493          	addi	s1,s1,360
    80002632:	03248063          	beq	s1,s2,80002652 <wakeup+0x58>
    acquire(&p->lock);
    80002636:	8526                	mv	a0,s1
    80002638:	ffffe097          	auipc	ra,0xffffe
    8000263c:	702080e7          	jalr	1794(ra) # 80000d3a <acquire>
    if (p->state == SLEEPING && p->chan == chan) {
    80002640:	4c9c                	lw	a5,24(s1)
    80002642:	ff3791e3          	bne	a5,s3,80002624 <wakeup+0x2a>
    80002646:	749c                	ld	a5,40(s1)
    80002648:	fd479ee3          	bne	a5,s4,80002624 <wakeup+0x2a>
      p->state = RUNNABLE;
    8000264c:	0154ac23          	sw	s5,24(s1)
    80002650:	bfd1                	j	80002624 <wakeup+0x2a>
}
    80002652:	70e2                	ld	ra,56(sp)
    80002654:	7442                	ld	s0,48(sp)
    80002656:	74a2                	ld	s1,40(sp)
    80002658:	7902                	ld	s2,32(sp)
    8000265a:	69e2                	ld	s3,24(sp)
    8000265c:	6a42                	ld	s4,16(sp)
    8000265e:	6aa2                	ld	s5,8(sp)
    80002660:	6121                	addi	sp,sp,64
    80002662:	8082                	ret

0000000080002664 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid) {
    80002664:	7179                	addi	sp,sp,-48
    80002666:	f406                	sd	ra,40(sp)
    80002668:	f022                	sd	s0,32(sp)
    8000266a:	ec26                	sd	s1,24(sp)
    8000266c:	e84a                	sd	s2,16(sp)
    8000266e:	e44e                	sd	s3,8(sp)
    80002670:	1800                	addi	s0,sp,48
    80002672:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80002674:	0002f497          	auipc	s1,0x2f
    80002678:	70448493          	addi	s1,s1,1796 # 80031d78 <proc>
    8000267c:	00035997          	auipc	s3,0x35
    80002680:	0fc98993          	addi	s3,s3,252 # 80037778 <tickslock>
    acquire(&p->lock);
    80002684:	8526                	mv	a0,s1
    80002686:	ffffe097          	auipc	ra,0xffffe
    8000268a:	6b4080e7          	jalr	1716(ra) # 80000d3a <acquire>
    if (p->pid == pid) {
    8000268e:	5c9c                	lw	a5,56(s1)
    80002690:	01278d63          	beq	a5,s2,800026aa <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002694:	8526                	mv	a0,s1
    80002696:	ffffe097          	auipc	ra,0xffffe
    8000269a:	758080e7          	jalr	1880(ra) # 80000dee <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    8000269e:	16848493          	addi	s1,s1,360
    800026a2:	ff3491e3          	bne	s1,s3,80002684 <kill+0x20>
  }
  return -1;
    800026a6:	557d                	li	a0,-1
    800026a8:	a821                	j	800026c0 <kill+0x5c>
      p->killed = 1;
    800026aa:	4785                	li	a5,1
    800026ac:	d89c                	sw	a5,48(s1)
      if (p->state == SLEEPING) {
    800026ae:	4c98                	lw	a4,24(s1)
    800026b0:	00f70f63          	beq	a4,a5,800026ce <kill+0x6a>
      release(&p->lock);
    800026b4:	8526                	mv	a0,s1
    800026b6:	ffffe097          	auipc	ra,0xffffe
    800026ba:	738080e7          	jalr	1848(ra) # 80000dee <release>
      return 0;
    800026be:	4501                	li	a0,0
}
    800026c0:	70a2                	ld	ra,40(sp)
    800026c2:	7402                	ld	s0,32(sp)
    800026c4:	64e2                	ld	s1,24(sp)
    800026c6:	6942                	ld	s2,16(sp)
    800026c8:	69a2                	ld	s3,8(sp)
    800026ca:	6145                	addi	sp,sp,48
    800026cc:	8082                	ret
        p->state = RUNNABLE;
    800026ce:	4789                	li	a5,2
    800026d0:	cc9c                	sw	a5,24(s1)
    800026d2:	b7cd                	j	800026b4 <kill+0x50>

00000000800026d4 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len) {
    800026d4:	7179                	addi	sp,sp,-48
    800026d6:	f406                	sd	ra,40(sp)
    800026d8:	f022                	sd	s0,32(sp)
    800026da:	ec26                	sd	s1,24(sp)
    800026dc:	e84a                	sd	s2,16(sp)
    800026de:	e44e                	sd	s3,8(sp)
    800026e0:	e052                	sd	s4,0(sp)
    800026e2:	1800                	addi	s0,sp,48
    800026e4:	84aa                	mv	s1,a0
    800026e6:	892e                	mv	s2,a1
    800026e8:	89b2                	mv	s3,a2
    800026ea:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800026ec:	fffff097          	auipc	ra,0xfffff
    800026f0:	57a080e7          	jalr	1402(ra) # 80001c66 <myproc>
  if (user_dst) {
    800026f4:	c08d                	beqz	s1,80002716 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800026f6:	86d2                	mv	a3,s4
    800026f8:	864e                	mv	a2,s3
    800026fa:	85ca                	mv	a1,s2
    800026fc:	6928                	ld	a0,80(a0)
    800026fe:	fffff097          	auipc	ra,0xfffff
    80002702:	334080e7          	jalr	820(ra) # 80001a32 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002706:	70a2                	ld	ra,40(sp)
    80002708:	7402                	ld	s0,32(sp)
    8000270a:	64e2                	ld	s1,24(sp)
    8000270c:	6942                	ld	s2,16(sp)
    8000270e:	69a2                	ld	s3,8(sp)
    80002710:	6a02                	ld	s4,0(sp)
    80002712:	6145                	addi	sp,sp,48
    80002714:	8082                	ret
    memmove((char *)dst, src, len);
    80002716:	000a061b          	sext.w	a2,s4
    8000271a:	85ce                	mv	a1,s3
    8000271c:	854a                	mv	a0,s2
    8000271e:	ffffe097          	auipc	ra,0xffffe
    80002722:	774080e7          	jalr	1908(ra) # 80000e92 <memmove>
    return 0;
    80002726:	8526                	mv	a0,s1
    80002728:	bff9                	j	80002706 <either_copyout+0x32>

000000008000272a <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len) {
    8000272a:	7179                	addi	sp,sp,-48
    8000272c:	f406                	sd	ra,40(sp)
    8000272e:	f022                	sd	s0,32(sp)
    80002730:	ec26                	sd	s1,24(sp)
    80002732:	e84a                	sd	s2,16(sp)
    80002734:	e44e                	sd	s3,8(sp)
    80002736:	e052                	sd	s4,0(sp)
    80002738:	1800                	addi	s0,sp,48
    8000273a:	892a                	mv	s2,a0
    8000273c:	84ae                	mv	s1,a1
    8000273e:	89b2                	mv	s3,a2
    80002740:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002742:	fffff097          	auipc	ra,0xfffff
    80002746:	524080e7          	jalr	1316(ra) # 80001c66 <myproc>
  if (user_src) {
    8000274a:	c08d                	beqz	s1,8000276c <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000274c:	86d2                	mv	a3,s4
    8000274e:	864e                	mv	a2,s3
    80002750:	85ca                	mv	a1,s2
    80002752:	6928                	ld	a0,80(a0)
    80002754:	fffff097          	auipc	ra,0xfffff
    80002758:	06a080e7          	jalr	106(ra) # 800017be <copyin>
  } else {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    8000275c:	70a2                	ld	ra,40(sp)
    8000275e:	7402                	ld	s0,32(sp)
    80002760:	64e2                	ld	s1,24(sp)
    80002762:	6942                	ld	s2,16(sp)
    80002764:	69a2                	ld	s3,8(sp)
    80002766:	6a02                	ld	s4,0(sp)
    80002768:	6145                	addi	sp,sp,48
    8000276a:	8082                	ret
    memmove(dst, (char *)src, len);
    8000276c:	000a061b          	sext.w	a2,s4
    80002770:	85ce                	mv	a1,s3
    80002772:	854a                	mv	a0,s2
    80002774:	ffffe097          	auipc	ra,0xffffe
    80002778:	71e080e7          	jalr	1822(ra) # 80000e92 <memmove>
    return 0;
    8000277c:	8526                	mv	a0,s1
    8000277e:	bff9                	j	8000275c <either_copyin+0x32>

0000000080002780 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void) {
    80002780:	715d                	addi	sp,sp,-80
    80002782:	e486                	sd	ra,72(sp)
    80002784:	e0a2                	sd	s0,64(sp)
    80002786:	fc26                	sd	s1,56(sp)
    80002788:	f84a                	sd	s2,48(sp)
    8000278a:	f44e                	sd	s3,40(sp)
    8000278c:	f052                	sd	s4,32(sp)
    8000278e:	ec56                	sd	s5,24(sp)
    80002790:	e85a                	sd	s6,16(sp)
    80002792:	e45e                	sd	s7,8(sp)
    80002794:	0880                	addi	s0,sp,80
                           [RUNNING] "run   ",
                           [ZOMBIE] "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    80002796:	00006517          	auipc	a0,0x6
    8000279a:	92250513          	addi	a0,a0,-1758 # 800080b8 <digits+0x50>
    8000279e:	ffffe097          	auipc	ra,0xffffe
    800027a2:	e98080e7          	jalr	-360(ra) # 80000636 <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    800027a6:	0002f497          	auipc	s1,0x2f
    800027aa:	72a48493          	addi	s1,s1,1834 # 80031ed0 <proc+0x158>
    800027ae:	00035917          	auipc	s2,0x35
    800027b2:	12290913          	addi	s2,s2,290 # 800378d0 <bcache+0x140>
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800027b6:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    800027b8:	00006997          	auipc	s3,0x6
    800027bc:	ae898993          	addi	s3,s3,-1304 # 800082a0 <digits+0x238>
    printf("%d %s %s", p->pid, state, p->name);
    800027c0:	00006a97          	auipc	s5,0x6
    800027c4:	ae8a8a93          	addi	s5,s5,-1304 # 800082a8 <digits+0x240>
    printf("\n");
    800027c8:	00006a17          	auipc	s4,0x6
    800027cc:	8f0a0a13          	addi	s4,s4,-1808 # 800080b8 <digits+0x50>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800027d0:	00006b97          	auipc	s7,0x6
    800027d4:	b10b8b93          	addi	s7,s7,-1264 # 800082e0 <states.0>
    800027d8:	a00d                	j	800027fa <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800027da:	ee06a583          	lw	a1,-288(a3)
    800027de:	8556                	mv	a0,s5
    800027e0:	ffffe097          	auipc	ra,0xffffe
    800027e4:	e56080e7          	jalr	-426(ra) # 80000636 <printf>
    printf("\n");
    800027e8:	8552                	mv	a0,s4
    800027ea:	ffffe097          	auipc	ra,0xffffe
    800027ee:	e4c080e7          	jalr	-436(ra) # 80000636 <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    800027f2:	16848493          	addi	s1,s1,360
    800027f6:	03248163          	beq	s1,s2,80002818 <procdump+0x98>
    if (p->state == UNUSED)
    800027fa:	86a6                	mv	a3,s1
    800027fc:	ec04a783          	lw	a5,-320(s1)
    80002800:	dbed                	beqz	a5,800027f2 <procdump+0x72>
      state = "???";
    80002802:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002804:	fcfb6be3          	bltu	s6,a5,800027da <procdump+0x5a>
    80002808:	1782                	slli	a5,a5,0x20
    8000280a:	9381                	srli	a5,a5,0x20
    8000280c:	078e                	slli	a5,a5,0x3
    8000280e:	97de                	add	a5,a5,s7
    80002810:	6390                	ld	a2,0(a5)
    80002812:	f661                	bnez	a2,800027da <procdump+0x5a>
      state = "???";
    80002814:	864e                	mv	a2,s3
    80002816:	b7d1                	j	800027da <procdump+0x5a>
  }
}
    80002818:	60a6                	ld	ra,72(sp)
    8000281a:	6406                	ld	s0,64(sp)
    8000281c:	74e2                	ld	s1,56(sp)
    8000281e:	7942                	ld	s2,48(sp)
    80002820:	79a2                	ld	s3,40(sp)
    80002822:	7a02                	ld	s4,32(sp)
    80002824:	6ae2                	ld	s5,24(sp)
    80002826:	6b42                	ld	s6,16(sp)
    80002828:	6ba2                	ld	s7,8(sp)
    8000282a:	6161                	addi	sp,sp,80
    8000282c:	8082                	ret

000000008000282e <swtch>:
    8000282e:	00153023          	sd	ra,0(a0)
    80002832:	00253423          	sd	sp,8(a0)
    80002836:	e900                	sd	s0,16(a0)
    80002838:	ed04                	sd	s1,24(a0)
    8000283a:	03253023          	sd	s2,32(a0)
    8000283e:	03353423          	sd	s3,40(a0)
    80002842:	03453823          	sd	s4,48(a0)
    80002846:	03553c23          	sd	s5,56(a0)
    8000284a:	05653023          	sd	s6,64(a0)
    8000284e:	05753423          	sd	s7,72(a0)
    80002852:	05853823          	sd	s8,80(a0)
    80002856:	05953c23          	sd	s9,88(a0)
    8000285a:	07a53023          	sd	s10,96(a0)
    8000285e:	07b53423          	sd	s11,104(a0)
    80002862:	0005b083          	ld	ra,0(a1)
    80002866:	0085b103          	ld	sp,8(a1)
    8000286a:	6980                	ld	s0,16(a1)
    8000286c:	6d84                	ld	s1,24(a1)
    8000286e:	0205b903          	ld	s2,32(a1)
    80002872:	0285b983          	ld	s3,40(a1)
    80002876:	0305ba03          	ld	s4,48(a1)
    8000287a:	0385ba83          	ld	s5,56(a1)
    8000287e:	0405bb03          	ld	s6,64(a1)
    80002882:	0485bb83          	ld	s7,72(a1)
    80002886:	0505bc03          	ld	s8,80(a1)
    8000288a:	0585bc83          	ld	s9,88(a1)
    8000288e:	0605bd03          	ld	s10,96(a1)
    80002892:	0685bd83          	ld	s11,104(a1)
    80002896:	8082                	ret

0000000080002898 <trapinit>:
// in kernelvec.S, calls kerneltrap().
void kernelvec();

extern int devintr();

void trapinit(void) { initlock(&tickslock, "time"); }
    80002898:	1141                	addi	sp,sp,-16
    8000289a:	e406                	sd	ra,8(sp)
    8000289c:	e022                	sd	s0,0(sp)
    8000289e:	0800                	addi	s0,sp,16
    800028a0:	00006597          	auipc	a1,0x6
    800028a4:	a6858593          	addi	a1,a1,-1432 # 80008308 <states.0+0x28>
    800028a8:	00035517          	auipc	a0,0x35
    800028ac:	ed050513          	addi	a0,a0,-304 # 80037778 <tickslock>
    800028b0:	ffffe097          	auipc	ra,0xffffe
    800028b4:	3fa080e7          	jalr	1018(ra) # 80000caa <initlock>
    800028b8:	60a2                	ld	ra,8(sp)
    800028ba:	6402                	ld	s0,0(sp)
    800028bc:	0141                	addi	sp,sp,16
    800028be:	8082                	ret

00000000800028c0 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void) { w_stvec((uint64)kernelvec); }
    800028c0:	1141                	addi	sp,sp,-16
    800028c2:	e422                	sd	s0,8(sp)
    800028c4:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    800028c6:	00003797          	auipc	a5,0x3
    800028ca:	5ba78793          	addi	a5,a5,1466 # 80005e80 <kernelvec>
    800028ce:	10579073          	csrw	stvec,a5
    800028d2:	6422                	ld	s0,8(sp)
    800028d4:	0141                	addi	sp,sp,16
    800028d6:	8082                	ret

00000000800028d8 <usertrapret>:
}

//
// return to user space
//
void usertrapret(void) {
    800028d8:	1141                	addi	sp,sp,-16
    800028da:	e406                	sd	ra,8(sp)
    800028dc:	e022                	sd	s0,0(sp)
    800028de:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800028e0:	fffff097          	auipc	ra,0xfffff
    800028e4:	386080e7          	jalr	902(ra) # 80001c66 <myproc>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800028e8:	100027f3          	csrr	a5,sstatus
static inline void intr_off() { w_sstatus(r_sstatus() & ~SSTATUS_SIE); }
    800028ec:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    800028ee:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    800028f2:	00004617          	auipc	a2,0x4
    800028f6:	70e60613          	addi	a2,a2,1806 # 80007000 <_trampoline>
    800028fa:	00004697          	auipc	a3,0x4
    800028fe:	70668693          	addi	a3,a3,1798 # 80007000 <_trampoline>
    80002902:	8e91                	sub	a3,a3,a2
    80002904:	040007b7          	lui	a5,0x4000
    80002908:	17fd                	addi	a5,a5,-1
    8000290a:	07b2                	slli	a5,a5,0xc
    8000290c:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r"(x));
    8000290e:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002912:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    80002914:	180026f3          	csrr	a3,satp
    80002918:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000291a:	6d38                	ld	a4,88(a0)
    8000291c:	6134                	ld	a3,64(a0)
    8000291e:	6585                	lui	a1,0x1
    80002920:	96ae                	add	a3,a3,a1
    80002922:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002924:	6d38                	ld	a4,88(a0)
    80002926:	00000697          	auipc	a3,0x0
    8000292a:	13868693          	addi	a3,a3,312 # 80002a5e <usertrap>
    8000292e:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002930:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    80002932:	8692                	mv	a3,tp
    80002934:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002936:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000293a:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    8000293e:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002942:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002946:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    80002948:	6f18                	ld	a4,24(a4)
    8000294a:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    8000294e:	692c                	ld	a1,80(a0)
    80002950:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80002952:	00004717          	auipc	a4,0x4
    80002956:	73e70713          	addi	a4,a4,1854 # 80007090 <userret>
    8000295a:	8f11                	sub	a4,a4,a2
    8000295c:	97ba                	add	a5,a5,a4
  ((void (*)(uint64, uint64))fn)(TRAPFRAME, satp);
    8000295e:	577d                	li	a4,-1
    80002960:	177e                	slli	a4,a4,0x3f
    80002962:	8dd9                	or	a1,a1,a4
    80002964:	02000537          	lui	a0,0x2000
    80002968:	157d                	addi	a0,a0,-1
    8000296a:	0536                	slli	a0,a0,0xd
    8000296c:	9782                	jalr	a5
}
    8000296e:	60a2                	ld	ra,8(sp)
    80002970:	6402                	ld	s0,0(sp)
    80002972:	0141                	addi	sp,sp,16
    80002974:	8082                	ret

0000000080002976 <clockintr>:
  // so restore trap registers for use by kernelvec.S's sepc instruction.
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr() {
    80002976:	1101                	addi	sp,sp,-32
    80002978:	ec06                	sd	ra,24(sp)
    8000297a:	e822                	sd	s0,16(sp)
    8000297c:	e426                	sd	s1,8(sp)
    8000297e:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002980:	00035497          	auipc	s1,0x35
    80002984:	df848493          	addi	s1,s1,-520 # 80037778 <tickslock>
    80002988:	8526                	mv	a0,s1
    8000298a:	ffffe097          	auipc	ra,0xffffe
    8000298e:	3b0080e7          	jalr	944(ra) # 80000d3a <acquire>
  ticks++;
    80002992:	00006517          	auipc	a0,0x6
    80002996:	68e50513          	addi	a0,a0,1678 # 80009020 <ticks>
    8000299a:	411c                	lw	a5,0(a0)
    8000299c:	2785                	addiw	a5,a5,1
    8000299e:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    800029a0:	00000097          	auipc	ra,0x0
    800029a4:	c5a080e7          	jalr	-934(ra) # 800025fa <wakeup>
  release(&tickslock);
    800029a8:	8526                	mv	a0,s1
    800029aa:	ffffe097          	auipc	ra,0xffffe
    800029ae:	444080e7          	jalr	1092(ra) # 80000dee <release>
}
    800029b2:	60e2                	ld	ra,24(sp)
    800029b4:	6442                	ld	s0,16(sp)
    800029b6:	64a2                	ld	s1,8(sp)
    800029b8:	6105                	addi	sp,sp,32
    800029ba:	8082                	ret

00000000800029bc <devintr>:
// check if it's an external interrupt or software interrupt,
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr() {
    800029bc:	1101                	addi	sp,sp,-32
    800029be:	ec06                	sd	ra,24(sp)
    800029c0:	e822                	sd	s0,16(sp)
    800029c2:	e426                	sd	s1,8(sp)
    800029c4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r"(x));
    800029c6:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    800029ca:	00074d63          	bltz	a4,800029e4 <devintr+0x28>
    // now allowed to interrupt again.
    if (irq)
      plic_complete(irq);

    return 1;
  } else if (scause == 0x8000000000000001L) {
    800029ce:	57fd                	li	a5,-1
    800029d0:	17fe                	slli	a5,a5,0x3f
    800029d2:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    800029d4:	4501                	li	a0,0
  } else if (scause == 0x8000000000000001L) {
    800029d6:	06f70363          	beq	a4,a5,80002a3c <devintr+0x80>
  }
}
    800029da:	60e2                	ld	ra,24(sp)
    800029dc:	6442                	ld	s0,16(sp)
    800029de:	64a2                	ld	s1,8(sp)
    800029e0:	6105                	addi	sp,sp,32
    800029e2:	8082                	ret
  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    800029e4:	0ff77793          	andi	a5,a4,255
    800029e8:	46a5                	li	a3,9
    800029ea:	fed792e3          	bne	a5,a3,800029ce <devintr+0x12>
    int irq = plic_claim();
    800029ee:	00003097          	auipc	ra,0x3
    800029f2:	59a080e7          	jalr	1434(ra) # 80005f88 <plic_claim>
    800029f6:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ) {
    800029f8:	47a9                	li	a5,10
    800029fa:	02f50763          	beq	a0,a5,80002a28 <devintr+0x6c>
    } else if (irq == VIRTIO0_IRQ) {
    800029fe:	4785                	li	a5,1
    80002a00:	02f50963          	beq	a0,a5,80002a32 <devintr+0x76>
    return 1;
    80002a04:	4505                	li	a0,1
    } else if (irq) {
    80002a06:	d8f1                	beqz	s1,800029da <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002a08:	85a6                	mv	a1,s1
    80002a0a:	00006517          	auipc	a0,0x6
    80002a0e:	90650513          	addi	a0,a0,-1786 # 80008310 <states.0+0x30>
    80002a12:	ffffe097          	auipc	ra,0xffffe
    80002a16:	c24080e7          	jalr	-988(ra) # 80000636 <printf>
      plic_complete(irq);
    80002a1a:	8526                	mv	a0,s1
    80002a1c:	00003097          	auipc	ra,0x3
    80002a20:	590080e7          	jalr	1424(ra) # 80005fac <plic_complete>
    return 1;
    80002a24:	4505                	li	a0,1
    80002a26:	bf55                	j	800029da <devintr+0x1e>
      uartintr();
    80002a28:	ffffe097          	auipc	ra,0xffffe
    80002a2c:	012080e7          	jalr	18(ra) # 80000a3a <uartintr>
    80002a30:	b7ed                	j	80002a1a <devintr+0x5e>
      virtio_disk_intr();
    80002a32:	00004097          	auipc	ra,0x4
    80002a36:	9f4080e7          	jalr	-1548(ra) # 80006426 <virtio_disk_intr>
    80002a3a:	b7c5                	j	80002a1a <devintr+0x5e>
    if (cpuid() == 0) {
    80002a3c:	fffff097          	auipc	ra,0xfffff
    80002a40:	1fe080e7          	jalr	510(ra) # 80001c3a <cpuid>
    80002a44:	c901                	beqz	a0,80002a54 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r"(x));
    80002a46:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002a4a:	9bf5                	andi	a5,a5,-3
static inline void w_sip(uint64 x) { asm volatile("csrw sip, %0" : : "r"(x)); }
    80002a4c:	14479073          	csrw	sip,a5
    return 2;
    80002a50:	4509                	li	a0,2
    80002a52:	b761                	j	800029da <devintr+0x1e>
      clockintr();
    80002a54:	00000097          	auipc	ra,0x0
    80002a58:	f22080e7          	jalr	-222(ra) # 80002976 <clockintr>
    80002a5c:	b7ed                	j	80002a46 <devintr+0x8a>

0000000080002a5e <usertrap>:
void usertrap(void) {
    80002a5e:	7179                	addi	sp,sp,-48
    80002a60:	f406                	sd	ra,40(sp)
    80002a62:	f022                	sd	s0,32(sp)
    80002a64:	ec26                	sd	s1,24(sp)
    80002a66:	e84a                	sd	s2,16(sp)
    80002a68:	e44e                	sd	s3,8(sp)
    80002a6a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002a6c:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80002a70:	1007f793          	andi	a5,a5,256
    80002a74:	e3bd                	bnez	a5,80002ada <usertrap+0x7c>
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002a76:	00003797          	auipc	a5,0x3
    80002a7a:	40a78793          	addi	a5,a5,1034 # 80005e80 <kernelvec>
    80002a7e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002a82:	fffff097          	auipc	ra,0xfffff
    80002a86:	1e4080e7          	jalr	484(ra) # 80001c66 <myproc>
    80002a8a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002a8c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002a8e:	14102773          	csrr	a4,sepc
    80002a92:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    80002a94:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    80002a98:	47a1                	li	a5,8
    80002a9a:	04f71e63          	bne	a4,a5,80002af6 <usertrap+0x98>
    if (p->killed)
    80002a9e:	591c                	lw	a5,48(a0)
    80002aa0:	e7a9                	bnez	a5,80002aea <usertrap+0x8c>
    p->trapframe->epc += 4;
    80002aa2:	6cb8                	ld	a4,88(s1)
    80002aa4:	6f1c                	ld	a5,24(a4)
    80002aa6:	0791                	addi	a5,a5,4
    80002aa8:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002aaa:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80002aae:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002ab2:	10079073          	csrw	sstatus,a5
    syscall();
    80002ab6:	00000097          	auipc	ra,0x0
    80002aba:	396080e7          	jalr	918(ra) # 80002e4c <syscall>
  if (p->killed)
    80002abe:	589c                	lw	a5,48(s1)
    80002ac0:	12079163          	bnez	a5,80002be2 <usertrap+0x184>
  usertrapret();
    80002ac4:	00000097          	auipc	ra,0x0
    80002ac8:	e14080e7          	jalr	-492(ra) # 800028d8 <usertrapret>
}
    80002acc:	70a2                	ld	ra,40(sp)
    80002ace:	7402                	ld	s0,32(sp)
    80002ad0:	64e2                	ld	s1,24(sp)
    80002ad2:	6942                	ld	s2,16(sp)
    80002ad4:	69a2                	ld	s3,8(sp)
    80002ad6:	6145                	addi	sp,sp,48
    80002ad8:	8082                	ret
    panic("usertrap: not from user mode");
    80002ada:	00006517          	auipc	a0,0x6
    80002ade:	85650513          	addi	a0,a0,-1962 # 80008330 <states.0+0x50>
    80002ae2:	ffffe097          	auipc	ra,0xffffe
    80002ae6:	b02080e7          	jalr	-1278(ra) # 800005e4 <panic>
      exit(-1);
    80002aea:	557d                	li	a0,-1
    80002aec:	00000097          	auipc	ra,0x0
    80002af0:	848080e7          	jalr	-1976(ra) # 80002334 <exit>
    80002af4:	b77d                	j	80002aa2 <usertrap+0x44>
  } else if ((which_dev = devintr()) != 0) {
    80002af6:	00000097          	auipc	ra,0x0
    80002afa:	ec6080e7          	jalr	-314(ra) # 800029bc <devintr>
    80002afe:	892a                	mv	s2,a0
    80002b00:	ed71                	bnez	a0,80002bdc <usertrap+0x17e>
  asm volatile("csrr %0, scause" : "=r"(x));
    80002b02:	14202773          	csrr	a4,scause
  } else if (r_scause() == 13 || r_scause() == 15) {
    80002b06:	47b5                	li	a5,13
    80002b08:	00f70763          	beq	a4,a5,80002b16 <usertrap+0xb8>
    80002b0c:	14202773          	csrr	a4,scause
    80002b10:	47bd                	li	a5,15
    80002b12:	08f71b63          	bne	a4,a5,80002ba8 <usertrap+0x14a>
  asm volatile("csrr %0, stval" : "=r"(x));
    80002b16:	143029f3          	csrr	s3,stval
    if (addr > MAXVA) {
    80002b1a:	4785                	li	a5,1
    80002b1c:	179a                	slli	a5,a5,0x26
    80002b1e:	0537e863          	bltu	a5,s3,80002b6e <usertrap+0x110>
    pte_t *pte = walk(p->pagetable, addr, 0);
    80002b22:	4601                	li	a2,0
    80002b24:	85ce                	mv	a1,s3
    80002b26:	68a8                	ld	a0,80(s1)
    80002b28:	ffffe097          	auipc	ra,0xffffe
    80002b2c:	5f6080e7          	jalr	1526(ra) # 8000111e <walk>
    if ((!pte || !(*pte & PTE_V)) && addr < p->sz) {
    80002b30:	c95d                	beqz	a0,80002be6 <usertrap+0x188>
    80002b32:	611c                	ld	a5,0(a0)
    80002b34:	0017f713          	andi	a4,a5,1
    80002b38:	c769                	beqz	a4,80002c02 <usertrap+0x1a4>
    } else if (pte && (*pte & PTE_COW)) {
    80002b3a:	1007f793          	andi	a5,a5,256
    80002b3e:	e3b9                	bnez	a5,80002b84 <usertrap+0x126>
      printf("permission denied");
    80002b40:	00006517          	auipc	a0,0x6
    80002b44:	83050513          	addi	a0,a0,-2000 # 80008370 <states.0+0x90>
    80002b48:	ffffe097          	auipc	ra,0xffffe
    80002b4c:	aee080e7          	jalr	-1298(ra) # 80000636 <printf>
      p->killed = 1;
    80002b50:	4785                	li	a5,1
    80002b52:	d89c                	sw	a5,48(s1)
    exit(-1);
    80002b54:	557d                	li	a0,-1
    80002b56:	fffff097          	auipc	ra,0xfffff
    80002b5a:	7de080e7          	jalr	2014(ra) # 80002334 <exit>
  if (which_dev == 2)
    80002b5e:	4789                	li	a5,2
    80002b60:	f6f912e3          	bne	s2,a5,80002ac4 <usertrap+0x66>
    yield();
    80002b64:	00000097          	auipc	ra,0x0
    80002b68:	8da080e7          	jalr	-1830(ra) # 8000243e <yield>
    80002b6c:	bfa1                	j	80002ac4 <usertrap+0x66>
      printf("memory overflow");
    80002b6e:	00005517          	auipc	a0,0x5
    80002b72:	7e250513          	addi	a0,a0,2018 # 80008350 <states.0+0x70>
    80002b76:	ffffe097          	auipc	ra,0xffffe
    80002b7a:	ac0080e7          	jalr	-1344(ra) # 80000636 <printf>
      p->killed = 1;
    80002b7e:	4785                	li	a5,1
    80002b80:	d89c                	sw	a5,48(s1)
    80002b82:	b745                	j	80002b22 <usertrap+0xc4>
      int res = do_cow(p->pagetable, addr);
    80002b84:	85ce                	mv	a1,s3
    80002b86:	68a8                	ld	a0,80(s1)
    80002b88:	fffff097          	auipc	ra,0xfffff
    80002b8c:	d78080e7          	jalr	-648(ra) # 80001900 <do_cow>
      if (res != 0) {
    80002b90:	d51d                	beqz	a0,80002abe <usertrap+0x60>
        printf("cow failed");
    80002b92:	00005517          	auipc	a0,0x5
    80002b96:	7ce50513          	addi	a0,a0,1998 # 80008360 <states.0+0x80>
    80002b9a:	ffffe097          	auipc	ra,0xffffe
    80002b9e:	a9c080e7          	jalr	-1380(ra) # 80000636 <printf>
        p->killed = 1;
    80002ba2:	4785                	li	a5,1
    80002ba4:	d89c                	sw	a5,48(s1)
    80002ba6:	b77d                	j	80002b54 <usertrap+0xf6>
  asm volatile("csrr %0, scause" : "=r"(x));
    80002ba8:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002bac:	5c90                	lw	a2,56(s1)
    80002bae:	00005517          	auipc	a0,0x5
    80002bb2:	7da50513          	addi	a0,a0,2010 # 80008388 <states.0+0xa8>
    80002bb6:	ffffe097          	auipc	ra,0xffffe
    80002bba:	a80080e7          	jalr	-1408(ra) # 80000636 <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002bbe:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80002bc2:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002bc6:	00005517          	auipc	a0,0x5
    80002bca:	7f250513          	addi	a0,a0,2034 # 800083b8 <states.0+0xd8>
    80002bce:	ffffe097          	auipc	ra,0xffffe
    80002bd2:	a68080e7          	jalr	-1432(ra) # 80000636 <printf>
    p->killed = 1;
    80002bd6:	4785                	li	a5,1
    80002bd8:	d89c                	sw	a5,48(s1)
    80002bda:	bfad                	j	80002b54 <usertrap+0xf6>
  if (p->killed)
    80002bdc:	589c                	lw	a5,48(s1)
    80002bde:	d3c1                	beqz	a5,80002b5e <usertrap+0x100>
    80002be0:	bf95                	j	80002b54 <usertrap+0xf6>
    80002be2:	4901                	li	s2,0
    80002be4:	bf85                	j	80002b54 <usertrap+0xf6>
    if ((!pte || !(*pte & PTE_V)) && addr < p->sz) {
    80002be6:	64bc                	ld	a5,72(s1)
    80002be8:	f4f9fce3          	bgeu	s3,a5,80002b40 <usertrap+0xe2>
      int res = do_lazy_allocation(p->pagetable, addr);
    80002bec:	85ce                	mv	a1,s3
    80002bee:	68a8                	ld	a0,80(s1)
    80002bf0:	fffff097          	auipc	ra,0xfffff
    80002bf4:	de0080e7          	jalr	-544(ra) # 800019d0 <do_lazy_allocation>
      if (res != 0) {
    80002bf8:	ec0503e3          	beqz	a0,80002abe <usertrap+0x60>
        p->killed = 1;
    80002bfc:	4785                	li	a5,1
    80002bfe:	d89c                	sw	a5,48(s1)
    80002c00:	bf91                	j	80002b54 <usertrap+0xf6>
    if ((!pte || !(*pte & PTE_V)) && addr < p->sz) {
    80002c02:	64b8                	ld	a4,72(s1)
    80002c04:	f2e9fbe3          	bgeu	s3,a4,80002b3a <usertrap+0xdc>
    80002c08:	b7d5                	j	80002bec <usertrap+0x18e>

0000000080002c0a <kerneltrap>:
void kerneltrap() {
    80002c0a:	7179                	addi	sp,sp,-48
    80002c0c:	f406                	sd	ra,40(sp)
    80002c0e:	f022                	sd	s0,32(sp)
    80002c10:	ec26                	sd	s1,24(sp)
    80002c12:	e84a                	sd	s2,16(sp)
    80002c14:	e44e                	sd	s3,8(sp)
    80002c16:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002c18:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002c1c:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    80002c20:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80002c24:	1004f793          	andi	a5,s1,256
    80002c28:	cb85                	beqz	a5,80002c58 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002c2a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002c2e:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80002c30:	ef85                	bnez	a5,80002c68 <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0) {
    80002c32:	00000097          	auipc	ra,0x0
    80002c36:	d8a080e7          	jalr	-630(ra) # 800029bc <devintr>
    80002c3a:	cd1d                	beqz	a0,80002c78 <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002c3c:	4789                	li	a5,2
    80002c3e:	06f50a63          	beq	a0,a5,80002cb2 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r"(x));
    80002c42:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002c46:	10049073          	csrw	sstatus,s1
}
    80002c4a:	70a2                	ld	ra,40(sp)
    80002c4c:	7402                	ld	s0,32(sp)
    80002c4e:	64e2                	ld	s1,24(sp)
    80002c50:	6942                	ld	s2,16(sp)
    80002c52:	69a2                	ld	s3,8(sp)
    80002c54:	6145                	addi	sp,sp,48
    80002c56:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002c58:	00005517          	auipc	a0,0x5
    80002c5c:	78050513          	addi	a0,a0,1920 # 800083d8 <states.0+0xf8>
    80002c60:	ffffe097          	auipc	ra,0xffffe
    80002c64:	984080e7          	jalr	-1660(ra) # 800005e4 <panic>
    panic("kerneltrap: interrupts enabled");
    80002c68:	00005517          	auipc	a0,0x5
    80002c6c:	79850513          	addi	a0,a0,1944 # 80008400 <states.0+0x120>
    80002c70:	ffffe097          	auipc	ra,0xffffe
    80002c74:	974080e7          	jalr	-1676(ra) # 800005e4 <panic>
    printf("scause %p\n", scause);
    80002c78:	85ce                	mv	a1,s3
    80002c7a:	00005517          	auipc	a0,0x5
    80002c7e:	7a650513          	addi	a0,a0,1958 # 80008420 <states.0+0x140>
    80002c82:	ffffe097          	auipc	ra,0xffffe
    80002c86:	9b4080e7          	jalr	-1612(ra) # 80000636 <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002c8a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80002c8e:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002c92:	00005517          	auipc	a0,0x5
    80002c96:	79e50513          	addi	a0,a0,1950 # 80008430 <states.0+0x150>
    80002c9a:	ffffe097          	auipc	ra,0xffffe
    80002c9e:	99c080e7          	jalr	-1636(ra) # 80000636 <printf>
    panic("kerneltrap");
    80002ca2:	00005517          	auipc	a0,0x5
    80002ca6:	7a650513          	addi	a0,a0,1958 # 80008448 <states.0+0x168>
    80002caa:	ffffe097          	auipc	ra,0xffffe
    80002cae:	93a080e7          	jalr	-1734(ra) # 800005e4 <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002cb2:	fffff097          	auipc	ra,0xfffff
    80002cb6:	fb4080e7          	jalr	-76(ra) # 80001c66 <myproc>
    80002cba:	d541                	beqz	a0,80002c42 <kerneltrap+0x38>
    80002cbc:	fffff097          	auipc	ra,0xfffff
    80002cc0:	faa080e7          	jalr	-86(ra) # 80001c66 <myproc>
    80002cc4:	4d18                	lw	a4,24(a0)
    80002cc6:	478d                	li	a5,3
    80002cc8:	f6f71de3          	bne	a4,a5,80002c42 <kerneltrap+0x38>
    yield();
    80002ccc:	fffff097          	auipc	ra,0xfffff
    80002cd0:	772080e7          	jalr	1906(ra) # 8000243e <yield>
    80002cd4:	b7bd                	j	80002c42 <kerneltrap+0x38>

0000000080002cd6 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002cd6:	1101                	addi	sp,sp,-32
    80002cd8:	ec06                	sd	ra,24(sp)
    80002cda:	e822                	sd	s0,16(sp)
    80002cdc:	e426                	sd	s1,8(sp)
    80002cde:	1000                	addi	s0,sp,32
    80002ce0:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002ce2:	fffff097          	auipc	ra,0xfffff
    80002ce6:	f84080e7          	jalr	-124(ra) # 80001c66 <myproc>
  switch (n) {
    80002cea:	4795                	li	a5,5
    80002cec:	0497e163          	bltu	a5,s1,80002d2e <argraw+0x58>
    80002cf0:	048a                	slli	s1,s1,0x2
    80002cf2:	00005717          	auipc	a4,0x5
    80002cf6:	78e70713          	addi	a4,a4,1934 # 80008480 <states.0+0x1a0>
    80002cfa:	94ba                	add	s1,s1,a4
    80002cfc:	409c                	lw	a5,0(s1)
    80002cfe:	97ba                	add	a5,a5,a4
    80002d00:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002d02:	6d3c                	ld	a5,88(a0)
    80002d04:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002d06:	60e2                	ld	ra,24(sp)
    80002d08:	6442                	ld	s0,16(sp)
    80002d0a:	64a2                	ld	s1,8(sp)
    80002d0c:	6105                	addi	sp,sp,32
    80002d0e:	8082                	ret
    return p->trapframe->a1;
    80002d10:	6d3c                	ld	a5,88(a0)
    80002d12:	7fa8                	ld	a0,120(a5)
    80002d14:	bfcd                	j	80002d06 <argraw+0x30>
    return p->trapframe->a2;
    80002d16:	6d3c                	ld	a5,88(a0)
    80002d18:	63c8                	ld	a0,128(a5)
    80002d1a:	b7f5                	j	80002d06 <argraw+0x30>
    return p->trapframe->a3;
    80002d1c:	6d3c                	ld	a5,88(a0)
    80002d1e:	67c8                	ld	a0,136(a5)
    80002d20:	b7dd                	j	80002d06 <argraw+0x30>
    return p->trapframe->a4;
    80002d22:	6d3c                	ld	a5,88(a0)
    80002d24:	6bc8                	ld	a0,144(a5)
    80002d26:	b7c5                	j	80002d06 <argraw+0x30>
    return p->trapframe->a5;
    80002d28:	6d3c                	ld	a5,88(a0)
    80002d2a:	6fc8                	ld	a0,152(a5)
    80002d2c:	bfe9                	j	80002d06 <argraw+0x30>
  panic("argraw");
    80002d2e:	00005517          	auipc	a0,0x5
    80002d32:	72a50513          	addi	a0,a0,1834 # 80008458 <states.0+0x178>
    80002d36:	ffffe097          	auipc	ra,0xffffe
    80002d3a:	8ae080e7          	jalr	-1874(ra) # 800005e4 <panic>

0000000080002d3e <fetchaddr>:
{
    80002d3e:	1101                	addi	sp,sp,-32
    80002d40:	ec06                	sd	ra,24(sp)
    80002d42:	e822                	sd	s0,16(sp)
    80002d44:	e426                	sd	s1,8(sp)
    80002d46:	e04a                	sd	s2,0(sp)
    80002d48:	1000                	addi	s0,sp,32
    80002d4a:	84aa                	mv	s1,a0
    80002d4c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002d4e:	fffff097          	auipc	ra,0xfffff
    80002d52:	f18080e7          	jalr	-232(ra) # 80001c66 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002d56:	653c                	ld	a5,72(a0)
    80002d58:	02f4f863          	bgeu	s1,a5,80002d88 <fetchaddr+0x4a>
    80002d5c:	00848713          	addi	a4,s1,8
    80002d60:	02e7e663          	bltu	a5,a4,80002d8c <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002d64:	46a1                	li	a3,8
    80002d66:	8626                	mv	a2,s1
    80002d68:	85ca                	mv	a1,s2
    80002d6a:	6928                	ld	a0,80(a0)
    80002d6c:	fffff097          	auipc	ra,0xfffff
    80002d70:	a52080e7          	jalr	-1454(ra) # 800017be <copyin>
    80002d74:	00a03533          	snez	a0,a0
    80002d78:	40a00533          	neg	a0,a0
}
    80002d7c:	60e2                	ld	ra,24(sp)
    80002d7e:	6442                	ld	s0,16(sp)
    80002d80:	64a2                	ld	s1,8(sp)
    80002d82:	6902                	ld	s2,0(sp)
    80002d84:	6105                	addi	sp,sp,32
    80002d86:	8082                	ret
    return -1;
    80002d88:	557d                	li	a0,-1
    80002d8a:	bfcd                	j	80002d7c <fetchaddr+0x3e>
    80002d8c:	557d                	li	a0,-1
    80002d8e:	b7fd                	j	80002d7c <fetchaddr+0x3e>

0000000080002d90 <fetchstr>:
{
    80002d90:	7179                	addi	sp,sp,-48
    80002d92:	f406                	sd	ra,40(sp)
    80002d94:	f022                	sd	s0,32(sp)
    80002d96:	ec26                	sd	s1,24(sp)
    80002d98:	e84a                	sd	s2,16(sp)
    80002d9a:	e44e                	sd	s3,8(sp)
    80002d9c:	1800                	addi	s0,sp,48
    80002d9e:	892a                	mv	s2,a0
    80002da0:	84ae                	mv	s1,a1
    80002da2:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002da4:	fffff097          	auipc	ra,0xfffff
    80002da8:	ec2080e7          	jalr	-318(ra) # 80001c66 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002dac:	86ce                	mv	a3,s3
    80002dae:	864a                	mv	a2,s2
    80002db0:	85a6                	mv	a1,s1
    80002db2:	6928                	ld	a0,80(a0)
    80002db4:	fffff097          	auipc	ra,0xfffff
    80002db8:	a98080e7          	jalr	-1384(ra) # 8000184c <copyinstr>
  if(err < 0)
    80002dbc:	00054763          	bltz	a0,80002dca <fetchstr+0x3a>
  return strlen(buf);
    80002dc0:	8526                	mv	a0,s1
    80002dc2:	ffffe097          	auipc	ra,0xffffe
    80002dc6:	1f8080e7          	jalr	504(ra) # 80000fba <strlen>
}
    80002dca:	70a2                	ld	ra,40(sp)
    80002dcc:	7402                	ld	s0,32(sp)
    80002dce:	64e2                	ld	s1,24(sp)
    80002dd0:	6942                	ld	s2,16(sp)
    80002dd2:	69a2                	ld	s3,8(sp)
    80002dd4:	6145                	addi	sp,sp,48
    80002dd6:	8082                	ret

0000000080002dd8 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002dd8:	1101                	addi	sp,sp,-32
    80002dda:	ec06                	sd	ra,24(sp)
    80002ddc:	e822                	sd	s0,16(sp)
    80002dde:	e426                	sd	s1,8(sp)
    80002de0:	1000                	addi	s0,sp,32
    80002de2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002de4:	00000097          	auipc	ra,0x0
    80002de8:	ef2080e7          	jalr	-270(ra) # 80002cd6 <argraw>
    80002dec:	c088                	sw	a0,0(s1)
  return 0;
}
    80002dee:	4501                	li	a0,0
    80002df0:	60e2                	ld	ra,24(sp)
    80002df2:	6442                	ld	s0,16(sp)
    80002df4:	64a2                	ld	s1,8(sp)
    80002df6:	6105                	addi	sp,sp,32
    80002df8:	8082                	ret

0000000080002dfa <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002dfa:	1101                	addi	sp,sp,-32
    80002dfc:	ec06                	sd	ra,24(sp)
    80002dfe:	e822                	sd	s0,16(sp)
    80002e00:	e426                	sd	s1,8(sp)
    80002e02:	1000                	addi	s0,sp,32
    80002e04:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002e06:	00000097          	auipc	ra,0x0
    80002e0a:	ed0080e7          	jalr	-304(ra) # 80002cd6 <argraw>
    80002e0e:	e088                	sd	a0,0(s1)
  return 0;
}
    80002e10:	4501                	li	a0,0
    80002e12:	60e2                	ld	ra,24(sp)
    80002e14:	6442                	ld	s0,16(sp)
    80002e16:	64a2                	ld	s1,8(sp)
    80002e18:	6105                	addi	sp,sp,32
    80002e1a:	8082                	ret

0000000080002e1c <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002e1c:	1101                	addi	sp,sp,-32
    80002e1e:	ec06                	sd	ra,24(sp)
    80002e20:	e822                	sd	s0,16(sp)
    80002e22:	e426                	sd	s1,8(sp)
    80002e24:	e04a                	sd	s2,0(sp)
    80002e26:	1000                	addi	s0,sp,32
    80002e28:	84ae                	mv	s1,a1
    80002e2a:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002e2c:	00000097          	auipc	ra,0x0
    80002e30:	eaa080e7          	jalr	-342(ra) # 80002cd6 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002e34:	864a                	mv	a2,s2
    80002e36:	85a6                	mv	a1,s1
    80002e38:	00000097          	auipc	ra,0x0
    80002e3c:	f58080e7          	jalr	-168(ra) # 80002d90 <fetchstr>
}
    80002e40:	60e2                	ld	ra,24(sp)
    80002e42:	6442                	ld	s0,16(sp)
    80002e44:	64a2                	ld	s1,8(sp)
    80002e46:	6902                	ld	s2,0(sp)
    80002e48:	6105                	addi	sp,sp,32
    80002e4a:	8082                	ret

0000000080002e4c <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002e4c:	1101                	addi	sp,sp,-32
    80002e4e:	ec06                	sd	ra,24(sp)
    80002e50:	e822                	sd	s0,16(sp)
    80002e52:	e426                	sd	s1,8(sp)
    80002e54:	e04a                	sd	s2,0(sp)
    80002e56:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002e58:	fffff097          	auipc	ra,0xfffff
    80002e5c:	e0e080e7          	jalr	-498(ra) # 80001c66 <myproc>
    80002e60:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002e62:	05853903          	ld	s2,88(a0)
    80002e66:	0a893783          	ld	a5,168(s2)
    80002e6a:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002e6e:	37fd                	addiw	a5,a5,-1
    80002e70:	4751                	li	a4,20
    80002e72:	00f76f63          	bltu	a4,a5,80002e90 <syscall+0x44>
    80002e76:	00369713          	slli	a4,a3,0x3
    80002e7a:	00005797          	auipc	a5,0x5
    80002e7e:	61e78793          	addi	a5,a5,1566 # 80008498 <syscalls>
    80002e82:	97ba                	add	a5,a5,a4
    80002e84:	639c                	ld	a5,0(a5)
    80002e86:	c789                	beqz	a5,80002e90 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002e88:	9782                	jalr	a5
    80002e8a:	06a93823          	sd	a0,112(s2)
    80002e8e:	a839                	j	80002eac <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002e90:	15848613          	addi	a2,s1,344
    80002e94:	5c8c                	lw	a1,56(s1)
    80002e96:	00005517          	auipc	a0,0x5
    80002e9a:	5ca50513          	addi	a0,a0,1482 # 80008460 <states.0+0x180>
    80002e9e:	ffffd097          	auipc	ra,0xffffd
    80002ea2:	798080e7          	jalr	1944(ra) # 80000636 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002ea6:	6cbc                	ld	a5,88(s1)
    80002ea8:	577d                	li	a4,-1
    80002eaa:	fbb8                	sd	a4,112(a5)
  }
}
    80002eac:	60e2                	ld	ra,24(sp)
    80002eae:	6442                	ld	s0,16(sp)
    80002eb0:	64a2                	ld	s1,8(sp)
    80002eb2:	6902                	ld	s2,0(sp)
    80002eb4:	6105                	addi	sp,sp,32
    80002eb6:	8082                	ret

0000000080002eb8 <sys_exit>:
#include "proc.h"
#include "riscv.h"
#include "spinlock.h"
#include "types.h"

uint64 sys_exit(void) {
    80002eb8:	1101                	addi	sp,sp,-32
    80002eba:	ec06                	sd	ra,24(sp)
    80002ebc:	e822                	sd	s0,16(sp)
    80002ebe:	1000                	addi	s0,sp,32
  int n;
  if (argint(0, &n) < 0)
    80002ec0:	fec40593          	addi	a1,s0,-20
    80002ec4:	4501                	li	a0,0
    80002ec6:	00000097          	auipc	ra,0x0
    80002eca:	f12080e7          	jalr	-238(ra) # 80002dd8 <argint>
    return -1;
    80002ece:	57fd                	li	a5,-1
  if (argint(0, &n) < 0)
    80002ed0:	00054963          	bltz	a0,80002ee2 <sys_exit+0x2a>
  exit(n);
    80002ed4:	fec42503          	lw	a0,-20(s0)
    80002ed8:	fffff097          	auipc	ra,0xfffff
    80002edc:	45c080e7          	jalr	1116(ra) # 80002334 <exit>
  return 0; // not reached
    80002ee0:	4781                	li	a5,0
}
    80002ee2:	853e                	mv	a0,a5
    80002ee4:	60e2                	ld	ra,24(sp)
    80002ee6:	6442                	ld	s0,16(sp)
    80002ee8:	6105                	addi	sp,sp,32
    80002eea:	8082                	ret

0000000080002eec <sys_getpid>:

uint64 sys_getpid(void) { return myproc()->pid; }
    80002eec:	1141                	addi	sp,sp,-16
    80002eee:	e406                	sd	ra,8(sp)
    80002ef0:	e022                	sd	s0,0(sp)
    80002ef2:	0800                	addi	s0,sp,16
    80002ef4:	fffff097          	auipc	ra,0xfffff
    80002ef8:	d72080e7          	jalr	-654(ra) # 80001c66 <myproc>
    80002efc:	5d08                	lw	a0,56(a0)
    80002efe:	60a2                	ld	ra,8(sp)
    80002f00:	6402                	ld	s0,0(sp)
    80002f02:	0141                	addi	sp,sp,16
    80002f04:	8082                	ret

0000000080002f06 <sys_fork>:

uint64 sys_fork(void) { return fork(); }
    80002f06:	1141                	addi	sp,sp,-16
    80002f08:	e406                	sd	ra,8(sp)
    80002f0a:	e022                	sd	s0,0(sp)
    80002f0c:	0800                	addi	s0,sp,16
    80002f0e:	fffff097          	auipc	ra,0xfffff
    80002f12:	118080e7          	jalr	280(ra) # 80002026 <fork>
    80002f16:	60a2                	ld	ra,8(sp)
    80002f18:	6402                	ld	s0,0(sp)
    80002f1a:	0141                	addi	sp,sp,16
    80002f1c:	8082                	ret

0000000080002f1e <sys_wait>:

uint64 sys_wait(void) {
    80002f1e:	1101                	addi	sp,sp,-32
    80002f20:	ec06                	sd	ra,24(sp)
    80002f22:	e822                	sd	s0,16(sp)
    80002f24:	1000                	addi	s0,sp,32
  uint64 p;
  if (argaddr(0, &p) < 0)
    80002f26:	fe840593          	addi	a1,s0,-24
    80002f2a:	4501                	li	a0,0
    80002f2c:	00000097          	auipc	ra,0x0
    80002f30:	ece080e7          	jalr	-306(ra) # 80002dfa <argaddr>
    80002f34:	87aa                	mv	a5,a0
    return -1;
    80002f36:	557d                	li	a0,-1
  if (argaddr(0, &p) < 0)
    80002f38:	0007c863          	bltz	a5,80002f48 <sys_wait+0x2a>
  return wait(p);
    80002f3c:	fe843503          	ld	a0,-24(s0)
    80002f40:	fffff097          	auipc	ra,0xfffff
    80002f44:	5b8080e7          	jalr	1464(ra) # 800024f8 <wait>
}
    80002f48:	60e2                	ld	ra,24(sp)
    80002f4a:	6442                	ld	s0,16(sp)
    80002f4c:	6105                	addi	sp,sp,32
    80002f4e:	8082                	ret

0000000080002f50 <sys_sbrk>:

uint64 sys_sbrk(void) {
    80002f50:	7179                	addi	sp,sp,-48
    80002f52:	f406                	sd	ra,40(sp)
    80002f54:	f022                	sd	s0,32(sp)
    80002f56:	ec26                	sd	s1,24(sp)
    80002f58:	e84a                	sd	s2,16(sp)
    80002f5a:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if (argint(0, &n) < 0)
    80002f5c:	fdc40593          	addi	a1,s0,-36
    80002f60:	4501                	li	a0,0
    80002f62:	00000097          	auipc	ra,0x0
    80002f66:	e76080e7          	jalr	-394(ra) # 80002dd8 <argint>
    80002f6a:	87aa                	mv	a5,a0
    return -1;
    80002f6c:	557d                	li	a0,-1
  if (argint(0, &n) < 0)
    80002f6e:	0207c763          	bltz	a5,80002f9c <sys_sbrk+0x4c>
  struct proc *p = myproc();
    80002f72:	fffff097          	auipc	ra,0xfffff
    80002f76:	cf4080e7          	jalr	-780(ra) # 80001c66 <myproc>
    80002f7a:	892a                	mv	s2,a0
  addr = p->sz;
    80002f7c:	6538                	ld	a4,72(a0)
    80002f7e:	0007049b          	sext.w	s1,a4
  p->sz += n;
    80002f82:	fdc42783          	lw	a5,-36(s0)
    80002f86:	97ba                	add	a5,a5,a4
    80002f88:	e53c                	sd	a5,72(a0)
  if (p->sz >= MAXVA) {
    80002f8a:	577d                	li	a4,-1
    80002f8c:	8369                	srli	a4,a4,0x1a
    80002f8e:	00f76d63          	bltu	a4,a5,80002fa8 <sys_sbrk+0x58>
    p->killed = 1;
    printf("user momry overflow");
    exit(-1);
  }
  if (n < 0) {
    80002f92:	fdc42783          	lw	a5,-36(s0)
    80002f96:	0207c963          	bltz	a5,80002fc8 <sys_sbrk+0x78>
    uvmdealloc(p->pagetable, addr, p->sz);
  }
  return addr;
    80002f9a:	8526                	mv	a0,s1
}
    80002f9c:	70a2                	ld	ra,40(sp)
    80002f9e:	7402                	ld	s0,32(sp)
    80002fa0:	64e2                	ld	s1,24(sp)
    80002fa2:	6942                	ld	s2,16(sp)
    80002fa4:	6145                	addi	sp,sp,48
    80002fa6:	8082                	ret
    p->killed = 1;
    80002fa8:	4785                	li	a5,1
    80002faa:	d91c                	sw	a5,48(a0)
    printf("user momry overflow");
    80002fac:	00005517          	auipc	a0,0x5
    80002fb0:	59c50513          	addi	a0,a0,1436 # 80008548 <syscalls+0xb0>
    80002fb4:	ffffd097          	auipc	ra,0xffffd
    80002fb8:	682080e7          	jalr	1666(ra) # 80000636 <printf>
    exit(-1);
    80002fbc:	557d                	li	a0,-1
    80002fbe:	fffff097          	auipc	ra,0xfffff
    80002fc2:	376080e7          	jalr	886(ra) # 80002334 <exit>
    80002fc6:	b7f1                	j	80002f92 <sys_sbrk+0x42>
    uvmdealloc(p->pagetable, addr, p->sz);
    80002fc8:	04893603          	ld	a2,72(s2)
    80002fcc:	85a6                	mv	a1,s1
    80002fce:	05093503          	ld	a0,80(s2)
    80002fd2:	ffffe097          	auipc	ra,0xffffe
    80002fd6:	566080e7          	jalr	1382(ra) # 80001538 <uvmdealloc>
    80002fda:	b7c1                	j	80002f9a <sys_sbrk+0x4a>

0000000080002fdc <sys_sleep>:

uint64 sys_sleep(void) {
    80002fdc:	7139                	addi	sp,sp,-64
    80002fde:	fc06                	sd	ra,56(sp)
    80002fe0:	f822                	sd	s0,48(sp)
    80002fe2:	f426                	sd	s1,40(sp)
    80002fe4:	f04a                	sd	s2,32(sp)
    80002fe6:	ec4e                	sd	s3,24(sp)
    80002fe8:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
    80002fea:	fcc40593          	addi	a1,s0,-52
    80002fee:	4501                	li	a0,0
    80002ff0:	00000097          	auipc	ra,0x0
    80002ff4:	de8080e7          	jalr	-536(ra) # 80002dd8 <argint>
    return -1;
    80002ff8:	57fd                	li	a5,-1
  if (argint(0, &n) < 0)
    80002ffa:	06054563          	bltz	a0,80003064 <sys_sleep+0x88>
  acquire(&tickslock);
    80002ffe:	00034517          	auipc	a0,0x34
    80003002:	77a50513          	addi	a0,a0,1914 # 80037778 <tickslock>
    80003006:	ffffe097          	auipc	ra,0xffffe
    8000300a:	d34080e7          	jalr	-716(ra) # 80000d3a <acquire>
  ticks0 = ticks;
    8000300e:	00006917          	auipc	s2,0x6
    80003012:	01292903          	lw	s2,18(s2) # 80009020 <ticks>
  while (ticks - ticks0 < n) {
    80003016:	fcc42783          	lw	a5,-52(s0)
    8000301a:	cf85                	beqz	a5,80003052 <sys_sleep+0x76>
    if (myproc()->killed) {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000301c:	00034997          	auipc	s3,0x34
    80003020:	75c98993          	addi	s3,s3,1884 # 80037778 <tickslock>
    80003024:	00006497          	auipc	s1,0x6
    80003028:	ffc48493          	addi	s1,s1,-4 # 80009020 <ticks>
    if (myproc()->killed) {
    8000302c:	fffff097          	auipc	ra,0xfffff
    80003030:	c3a080e7          	jalr	-966(ra) # 80001c66 <myproc>
    80003034:	591c                	lw	a5,48(a0)
    80003036:	ef9d                	bnez	a5,80003074 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80003038:	85ce                	mv	a1,s3
    8000303a:	8526                	mv	a0,s1
    8000303c:	fffff097          	auipc	ra,0xfffff
    80003040:	43e080e7          	jalr	1086(ra) # 8000247a <sleep>
  while (ticks - ticks0 < n) {
    80003044:	409c                	lw	a5,0(s1)
    80003046:	412787bb          	subw	a5,a5,s2
    8000304a:	fcc42703          	lw	a4,-52(s0)
    8000304e:	fce7efe3          	bltu	a5,a4,8000302c <sys_sleep+0x50>
  }
  release(&tickslock);
    80003052:	00034517          	auipc	a0,0x34
    80003056:	72650513          	addi	a0,a0,1830 # 80037778 <tickslock>
    8000305a:	ffffe097          	auipc	ra,0xffffe
    8000305e:	d94080e7          	jalr	-620(ra) # 80000dee <release>
  return 0;
    80003062:	4781                	li	a5,0
}
    80003064:	853e                	mv	a0,a5
    80003066:	70e2                	ld	ra,56(sp)
    80003068:	7442                	ld	s0,48(sp)
    8000306a:	74a2                	ld	s1,40(sp)
    8000306c:	7902                	ld	s2,32(sp)
    8000306e:	69e2                	ld	s3,24(sp)
    80003070:	6121                	addi	sp,sp,64
    80003072:	8082                	ret
      release(&tickslock);
    80003074:	00034517          	auipc	a0,0x34
    80003078:	70450513          	addi	a0,a0,1796 # 80037778 <tickslock>
    8000307c:	ffffe097          	auipc	ra,0xffffe
    80003080:	d72080e7          	jalr	-654(ra) # 80000dee <release>
      return -1;
    80003084:	57fd                	li	a5,-1
    80003086:	bff9                	j	80003064 <sys_sleep+0x88>

0000000080003088 <sys_kill>:

uint64 sys_kill(void) {
    80003088:	1101                	addi	sp,sp,-32
    8000308a:	ec06                	sd	ra,24(sp)
    8000308c:	e822                	sd	s0,16(sp)
    8000308e:	1000                	addi	s0,sp,32
  int pid;

  if (argint(0, &pid) < 0)
    80003090:	fec40593          	addi	a1,s0,-20
    80003094:	4501                	li	a0,0
    80003096:	00000097          	auipc	ra,0x0
    8000309a:	d42080e7          	jalr	-702(ra) # 80002dd8 <argint>
    8000309e:	87aa                	mv	a5,a0
    return -1;
    800030a0:	557d                	li	a0,-1
  if (argint(0, &pid) < 0)
    800030a2:	0007c863          	bltz	a5,800030b2 <sys_kill+0x2a>
  return kill(pid);
    800030a6:	fec42503          	lw	a0,-20(s0)
    800030aa:	fffff097          	auipc	ra,0xfffff
    800030ae:	5ba080e7          	jalr	1466(ra) # 80002664 <kill>
}
    800030b2:	60e2                	ld	ra,24(sp)
    800030b4:	6442                	ld	s0,16(sp)
    800030b6:	6105                	addi	sp,sp,32
    800030b8:	8082                	ret

00000000800030ba <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64 sys_uptime(void) {
    800030ba:	1101                	addi	sp,sp,-32
    800030bc:	ec06                	sd	ra,24(sp)
    800030be:	e822                	sd	s0,16(sp)
    800030c0:	e426                	sd	s1,8(sp)
    800030c2:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800030c4:	00034517          	auipc	a0,0x34
    800030c8:	6b450513          	addi	a0,a0,1716 # 80037778 <tickslock>
    800030cc:	ffffe097          	auipc	ra,0xffffe
    800030d0:	c6e080e7          	jalr	-914(ra) # 80000d3a <acquire>
  xticks = ticks;
    800030d4:	00006497          	auipc	s1,0x6
    800030d8:	f4c4a483          	lw	s1,-180(s1) # 80009020 <ticks>
  release(&tickslock);
    800030dc:	00034517          	auipc	a0,0x34
    800030e0:	69c50513          	addi	a0,a0,1692 # 80037778 <tickslock>
    800030e4:	ffffe097          	auipc	ra,0xffffe
    800030e8:	d0a080e7          	jalr	-758(ra) # 80000dee <release>
  return xticks;
}
    800030ec:	02049513          	slli	a0,s1,0x20
    800030f0:	9101                	srli	a0,a0,0x20
    800030f2:	60e2                	ld	ra,24(sp)
    800030f4:	6442                	ld	s0,16(sp)
    800030f6:	64a2                	ld	s1,8(sp)
    800030f8:	6105                	addi	sp,sp,32
    800030fa:	8082                	ret

00000000800030fc <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800030fc:	7179                	addi	sp,sp,-48
    800030fe:	f406                	sd	ra,40(sp)
    80003100:	f022                	sd	s0,32(sp)
    80003102:	ec26                	sd	s1,24(sp)
    80003104:	e84a                	sd	s2,16(sp)
    80003106:	e44e                	sd	s3,8(sp)
    80003108:	e052                	sd	s4,0(sp)
    8000310a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000310c:	00005597          	auipc	a1,0x5
    80003110:	45458593          	addi	a1,a1,1108 # 80008560 <syscalls+0xc8>
    80003114:	00034517          	auipc	a0,0x34
    80003118:	67c50513          	addi	a0,a0,1660 # 80037790 <bcache>
    8000311c:	ffffe097          	auipc	ra,0xffffe
    80003120:	b8e080e7          	jalr	-1138(ra) # 80000caa <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003124:	0003c797          	auipc	a5,0x3c
    80003128:	66c78793          	addi	a5,a5,1644 # 8003f790 <bcache+0x8000>
    8000312c:	0003d717          	auipc	a4,0x3d
    80003130:	8cc70713          	addi	a4,a4,-1844 # 8003f9f8 <bcache+0x8268>
    80003134:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003138:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000313c:	00034497          	auipc	s1,0x34
    80003140:	66c48493          	addi	s1,s1,1644 # 800377a8 <bcache+0x18>
    b->next = bcache.head.next;
    80003144:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003146:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003148:	00005a17          	auipc	s4,0x5
    8000314c:	420a0a13          	addi	s4,s4,1056 # 80008568 <syscalls+0xd0>
    b->next = bcache.head.next;
    80003150:	2b893783          	ld	a5,696(s2)
    80003154:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003156:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000315a:	85d2                	mv	a1,s4
    8000315c:	01048513          	addi	a0,s1,16
    80003160:	00001097          	auipc	ra,0x1
    80003164:	4b0080e7          	jalr	1200(ra) # 80004610 <initsleeplock>
    bcache.head.next->prev = b;
    80003168:	2b893783          	ld	a5,696(s2)
    8000316c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000316e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003172:	45848493          	addi	s1,s1,1112
    80003176:	fd349de3          	bne	s1,s3,80003150 <binit+0x54>
  }
}
    8000317a:	70a2                	ld	ra,40(sp)
    8000317c:	7402                	ld	s0,32(sp)
    8000317e:	64e2                	ld	s1,24(sp)
    80003180:	6942                	ld	s2,16(sp)
    80003182:	69a2                	ld	s3,8(sp)
    80003184:	6a02                	ld	s4,0(sp)
    80003186:	6145                	addi	sp,sp,48
    80003188:	8082                	ret

000000008000318a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000318a:	7179                	addi	sp,sp,-48
    8000318c:	f406                	sd	ra,40(sp)
    8000318e:	f022                	sd	s0,32(sp)
    80003190:	ec26                	sd	s1,24(sp)
    80003192:	e84a                	sd	s2,16(sp)
    80003194:	e44e                	sd	s3,8(sp)
    80003196:	1800                	addi	s0,sp,48
    80003198:	892a                	mv	s2,a0
    8000319a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000319c:	00034517          	auipc	a0,0x34
    800031a0:	5f450513          	addi	a0,a0,1524 # 80037790 <bcache>
    800031a4:	ffffe097          	auipc	ra,0xffffe
    800031a8:	b96080e7          	jalr	-1130(ra) # 80000d3a <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800031ac:	0003d497          	auipc	s1,0x3d
    800031b0:	89c4b483          	ld	s1,-1892(s1) # 8003fa48 <bcache+0x82b8>
    800031b4:	0003d797          	auipc	a5,0x3d
    800031b8:	84478793          	addi	a5,a5,-1980 # 8003f9f8 <bcache+0x8268>
    800031bc:	02f48f63          	beq	s1,a5,800031fa <bread+0x70>
    800031c0:	873e                	mv	a4,a5
    800031c2:	a021                	j	800031ca <bread+0x40>
    800031c4:	68a4                	ld	s1,80(s1)
    800031c6:	02e48a63          	beq	s1,a4,800031fa <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800031ca:	449c                	lw	a5,8(s1)
    800031cc:	ff279ce3          	bne	a5,s2,800031c4 <bread+0x3a>
    800031d0:	44dc                	lw	a5,12(s1)
    800031d2:	ff3799e3          	bne	a5,s3,800031c4 <bread+0x3a>
      b->refcnt++;
    800031d6:	40bc                	lw	a5,64(s1)
    800031d8:	2785                	addiw	a5,a5,1
    800031da:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800031dc:	00034517          	auipc	a0,0x34
    800031e0:	5b450513          	addi	a0,a0,1460 # 80037790 <bcache>
    800031e4:	ffffe097          	auipc	ra,0xffffe
    800031e8:	c0a080e7          	jalr	-1014(ra) # 80000dee <release>
      acquiresleep(&b->lock);
    800031ec:	01048513          	addi	a0,s1,16
    800031f0:	00001097          	auipc	ra,0x1
    800031f4:	45a080e7          	jalr	1114(ra) # 8000464a <acquiresleep>
      return b;
    800031f8:	a8b9                	j	80003256 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800031fa:	0003d497          	auipc	s1,0x3d
    800031fe:	8464b483          	ld	s1,-1978(s1) # 8003fa40 <bcache+0x82b0>
    80003202:	0003c797          	auipc	a5,0x3c
    80003206:	7f678793          	addi	a5,a5,2038 # 8003f9f8 <bcache+0x8268>
    8000320a:	00f48863          	beq	s1,a5,8000321a <bread+0x90>
    8000320e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003210:	40bc                	lw	a5,64(s1)
    80003212:	cf81                	beqz	a5,8000322a <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003214:	64a4                	ld	s1,72(s1)
    80003216:	fee49de3          	bne	s1,a4,80003210 <bread+0x86>
  panic("bget: no buffers");
    8000321a:	00005517          	auipc	a0,0x5
    8000321e:	35650513          	addi	a0,a0,854 # 80008570 <syscalls+0xd8>
    80003222:	ffffd097          	auipc	ra,0xffffd
    80003226:	3c2080e7          	jalr	962(ra) # 800005e4 <panic>
      b->dev = dev;
    8000322a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000322e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003232:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003236:	4785                	li	a5,1
    80003238:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000323a:	00034517          	auipc	a0,0x34
    8000323e:	55650513          	addi	a0,a0,1366 # 80037790 <bcache>
    80003242:	ffffe097          	auipc	ra,0xffffe
    80003246:	bac080e7          	jalr	-1108(ra) # 80000dee <release>
      acquiresleep(&b->lock);
    8000324a:	01048513          	addi	a0,s1,16
    8000324e:	00001097          	auipc	ra,0x1
    80003252:	3fc080e7          	jalr	1020(ra) # 8000464a <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003256:	409c                	lw	a5,0(s1)
    80003258:	cb89                	beqz	a5,8000326a <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000325a:	8526                	mv	a0,s1
    8000325c:	70a2                	ld	ra,40(sp)
    8000325e:	7402                	ld	s0,32(sp)
    80003260:	64e2                	ld	s1,24(sp)
    80003262:	6942                	ld	s2,16(sp)
    80003264:	69a2                	ld	s3,8(sp)
    80003266:	6145                	addi	sp,sp,48
    80003268:	8082                	ret
    virtio_disk_rw(b, 0);
    8000326a:	4581                	li	a1,0
    8000326c:	8526                	mv	a0,s1
    8000326e:	00003097          	auipc	ra,0x3
    80003272:	f2e080e7          	jalr	-210(ra) # 8000619c <virtio_disk_rw>
    b->valid = 1;
    80003276:	4785                	li	a5,1
    80003278:	c09c                	sw	a5,0(s1)
  return b;
    8000327a:	b7c5                	j	8000325a <bread+0xd0>

000000008000327c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000327c:	1101                	addi	sp,sp,-32
    8000327e:	ec06                	sd	ra,24(sp)
    80003280:	e822                	sd	s0,16(sp)
    80003282:	e426                	sd	s1,8(sp)
    80003284:	1000                	addi	s0,sp,32
    80003286:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003288:	0541                	addi	a0,a0,16
    8000328a:	00001097          	auipc	ra,0x1
    8000328e:	45a080e7          	jalr	1114(ra) # 800046e4 <holdingsleep>
    80003292:	cd01                	beqz	a0,800032aa <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003294:	4585                	li	a1,1
    80003296:	8526                	mv	a0,s1
    80003298:	00003097          	auipc	ra,0x3
    8000329c:	f04080e7          	jalr	-252(ra) # 8000619c <virtio_disk_rw>
}
    800032a0:	60e2                	ld	ra,24(sp)
    800032a2:	6442                	ld	s0,16(sp)
    800032a4:	64a2                	ld	s1,8(sp)
    800032a6:	6105                	addi	sp,sp,32
    800032a8:	8082                	ret
    panic("bwrite");
    800032aa:	00005517          	auipc	a0,0x5
    800032ae:	2de50513          	addi	a0,a0,734 # 80008588 <syscalls+0xf0>
    800032b2:	ffffd097          	auipc	ra,0xffffd
    800032b6:	332080e7          	jalr	818(ra) # 800005e4 <panic>

00000000800032ba <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800032ba:	1101                	addi	sp,sp,-32
    800032bc:	ec06                	sd	ra,24(sp)
    800032be:	e822                	sd	s0,16(sp)
    800032c0:	e426                	sd	s1,8(sp)
    800032c2:	e04a                	sd	s2,0(sp)
    800032c4:	1000                	addi	s0,sp,32
    800032c6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800032c8:	01050913          	addi	s2,a0,16
    800032cc:	854a                	mv	a0,s2
    800032ce:	00001097          	auipc	ra,0x1
    800032d2:	416080e7          	jalr	1046(ra) # 800046e4 <holdingsleep>
    800032d6:	c92d                	beqz	a0,80003348 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800032d8:	854a                	mv	a0,s2
    800032da:	00001097          	auipc	ra,0x1
    800032de:	3c6080e7          	jalr	966(ra) # 800046a0 <releasesleep>

  acquire(&bcache.lock);
    800032e2:	00034517          	auipc	a0,0x34
    800032e6:	4ae50513          	addi	a0,a0,1198 # 80037790 <bcache>
    800032ea:	ffffe097          	auipc	ra,0xffffe
    800032ee:	a50080e7          	jalr	-1456(ra) # 80000d3a <acquire>
  b->refcnt--;
    800032f2:	40bc                	lw	a5,64(s1)
    800032f4:	37fd                	addiw	a5,a5,-1
    800032f6:	0007871b          	sext.w	a4,a5
    800032fa:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800032fc:	eb05                	bnez	a4,8000332c <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800032fe:	68bc                	ld	a5,80(s1)
    80003300:	64b8                	ld	a4,72(s1)
    80003302:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80003304:	64bc                	ld	a5,72(s1)
    80003306:	68b8                	ld	a4,80(s1)
    80003308:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000330a:	0003c797          	auipc	a5,0x3c
    8000330e:	48678793          	addi	a5,a5,1158 # 8003f790 <bcache+0x8000>
    80003312:	2b87b703          	ld	a4,696(a5)
    80003316:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003318:	0003c717          	auipc	a4,0x3c
    8000331c:	6e070713          	addi	a4,a4,1760 # 8003f9f8 <bcache+0x8268>
    80003320:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003322:	2b87b703          	ld	a4,696(a5)
    80003326:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003328:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000332c:	00034517          	auipc	a0,0x34
    80003330:	46450513          	addi	a0,a0,1124 # 80037790 <bcache>
    80003334:	ffffe097          	auipc	ra,0xffffe
    80003338:	aba080e7          	jalr	-1350(ra) # 80000dee <release>
}
    8000333c:	60e2                	ld	ra,24(sp)
    8000333e:	6442                	ld	s0,16(sp)
    80003340:	64a2                	ld	s1,8(sp)
    80003342:	6902                	ld	s2,0(sp)
    80003344:	6105                	addi	sp,sp,32
    80003346:	8082                	ret
    panic("brelse");
    80003348:	00005517          	auipc	a0,0x5
    8000334c:	24850513          	addi	a0,a0,584 # 80008590 <syscalls+0xf8>
    80003350:	ffffd097          	auipc	ra,0xffffd
    80003354:	294080e7          	jalr	660(ra) # 800005e4 <panic>

0000000080003358 <bpin>:

void
bpin(struct buf *b) {
    80003358:	1101                	addi	sp,sp,-32
    8000335a:	ec06                	sd	ra,24(sp)
    8000335c:	e822                	sd	s0,16(sp)
    8000335e:	e426                	sd	s1,8(sp)
    80003360:	1000                	addi	s0,sp,32
    80003362:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003364:	00034517          	auipc	a0,0x34
    80003368:	42c50513          	addi	a0,a0,1068 # 80037790 <bcache>
    8000336c:	ffffe097          	auipc	ra,0xffffe
    80003370:	9ce080e7          	jalr	-1586(ra) # 80000d3a <acquire>
  b->refcnt++;
    80003374:	40bc                	lw	a5,64(s1)
    80003376:	2785                	addiw	a5,a5,1
    80003378:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000337a:	00034517          	auipc	a0,0x34
    8000337e:	41650513          	addi	a0,a0,1046 # 80037790 <bcache>
    80003382:	ffffe097          	auipc	ra,0xffffe
    80003386:	a6c080e7          	jalr	-1428(ra) # 80000dee <release>
}
    8000338a:	60e2                	ld	ra,24(sp)
    8000338c:	6442                	ld	s0,16(sp)
    8000338e:	64a2                	ld	s1,8(sp)
    80003390:	6105                	addi	sp,sp,32
    80003392:	8082                	ret

0000000080003394 <bunpin>:

void
bunpin(struct buf *b) {
    80003394:	1101                	addi	sp,sp,-32
    80003396:	ec06                	sd	ra,24(sp)
    80003398:	e822                	sd	s0,16(sp)
    8000339a:	e426                	sd	s1,8(sp)
    8000339c:	1000                	addi	s0,sp,32
    8000339e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800033a0:	00034517          	auipc	a0,0x34
    800033a4:	3f050513          	addi	a0,a0,1008 # 80037790 <bcache>
    800033a8:	ffffe097          	auipc	ra,0xffffe
    800033ac:	992080e7          	jalr	-1646(ra) # 80000d3a <acquire>
  b->refcnt--;
    800033b0:	40bc                	lw	a5,64(s1)
    800033b2:	37fd                	addiw	a5,a5,-1
    800033b4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800033b6:	00034517          	auipc	a0,0x34
    800033ba:	3da50513          	addi	a0,a0,986 # 80037790 <bcache>
    800033be:	ffffe097          	auipc	ra,0xffffe
    800033c2:	a30080e7          	jalr	-1488(ra) # 80000dee <release>
}
    800033c6:	60e2                	ld	ra,24(sp)
    800033c8:	6442                	ld	s0,16(sp)
    800033ca:	64a2                	ld	s1,8(sp)
    800033cc:	6105                	addi	sp,sp,32
    800033ce:	8082                	ret

00000000800033d0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800033d0:	1101                	addi	sp,sp,-32
    800033d2:	ec06                	sd	ra,24(sp)
    800033d4:	e822                	sd	s0,16(sp)
    800033d6:	e426                	sd	s1,8(sp)
    800033d8:	e04a                	sd	s2,0(sp)
    800033da:	1000                	addi	s0,sp,32
    800033dc:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800033de:	00d5d59b          	srliw	a1,a1,0xd
    800033e2:	0003d797          	auipc	a5,0x3d
    800033e6:	a8a7a783          	lw	a5,-1398(a5) # 8003fe6c <sb+0x1c>
    800033ea:	9dbd                	addw	a1,a1,a5
    800033ec:	00000097          	auipc	ra,0x0
    800033f0:	d9e080e7          	jalr	-610(ra) # 8000318a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800033f4:	0074f713          	andi	a4,s1,7
    800033f8:	4785                	li	a5,1
    800033fa:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800033fe:	14ce                	slli	s1,s1,0x33
    80003400:	90d9                	srli	s1,s1,0x36
    80003402:	00950733          	add	a4,a0,s1
    80003406:	05874703          	lbu	a4,88(a4)
    8000340a:	00e7f6b3          	and	a3,a5,a4
    8000340e:	c69d                	beqz	a3,8000343c <bfree+0x6c>
    80003410:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003412:	94aa                	add	s1,s1,a0
    80003414:	fff7c793          	not	a5,a5
    80003418:	8ff9                	and	a5,a5,a4
    8000341a:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    8000341e:	00001097          	auipc	ra,0x1
    80003422:	104080e7          	jalr	260(ra) # 80004522 <log_write>
  brelse(bp);
    80003426:	854a                	mv	a0,s2
    80003428:	00000097          	auipc	ra,0x0
    8000342c:	e92080e7          	jalr	-366(ra) # 800032ba <brelse>
}
    80003430:	60e2                	ld	ra,24(sp)
    80003432:	6442                	ld	s0,16(sp)
    80003434:	64a2                	ld	s1,8(sp)
    80003436:	6902                	ld	s2,0(sp)
    80003438:	6105                	addi	sp,sp,32
    8000343a:	8082                	ret
    panic("freeing free block");
    8000343c:	00005517          	auipc	a0,0x5
    80003440:	15c50513          	addi	a0,a0,348 # 80008598 <syscalls+0x100>
    80003444:	ffffd097          	auipc	ra,0xffffd
    80003448:	1a0080e7          	jalr	416(ra) # 800005e4 <panic>

000000008000344c <balloc>:
{
    8000344c:	711d                	addi	sp,sp,-96
    8000344e:	ec86                	sd	ra,88(sp)
    80003450:	e8a2                	sd	s0,80(sp)
    80003452:	e4a6                	sd	s1,72(sp)
    80003454:	e0ca                	sd	s2,64(sp)
    80003456:	fc4e                	sd	s3,56(sp)
    80003458:	f852                	sd	s4,48(sp)
    8000345a:	f456                	sd	s5,40(sp)
    8000345c:	f05a                	sd	s6,32(sp)
    8000345e:	ec5e                	sd	s7,24(sp)
    80003460:	e862                	sd	s8,16(sp)
    80003462:	e466                	sd	s9,8(sp)
    80003464:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003466:	0003d797          	auipc	a5,0x3d
    8000346a:	9ee7a783          	lw	a5,-1554(a5) # 8003fe54 <sb+0x4>
    8000346e:	cbd1                	beqz	a5,80003502 <balloc+0xb6>
    80003470:	8baa                	mv	s7,a0
    80003472:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003474:	0003db17          	auipc	s6,0x3d
    80003478:	9dcb0b13          	addi	s6,s6,-1572 # 8003fe50 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000347c:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000347e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003480:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003482:	6c89                	lui	s9,0x2
    80003484:	a831                	j	800034a0 <balloc+0x54>
    brelse(bp);
    80003486:	854a                	mv	a0,s2
    80003488:	00000097          	auipc	ra,0x0
    8000348c:	e32080e7          	jalr	-462(ra) # 800032ba <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003490:	015c87bb          	addw	a5,s9,s5
    80003494:	00078a9b          	sext.w	s5,a5
    80003498:	004b2703          	lw	a4,4(s6)
    8000349c:	06eaf363          	bgeu	s5,a4,80003502 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800034a0:	41fad79b          	sraiw	a5,s5,0x1f
    800034a4:	0137d79b          	srliw	a5,a5,0x13
    800034a8:	015787bb          	addw	a5,a5,s5
    800034ac:	40d7d79b          	sraiw	a5,a5,0xd
    800034b0:	01cb2583          	lw	a1,28(s6)
    800034b4:	9dbd                	addw	a1,a1,a5
    800034b6:	855e                	mv	a0,s7
    800034b8:	00000097          	auipc	ra,0x0
    800034bc:	cd2080e7          	jalr	-814(ra) # 8000318a <bread>
    800034c0:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800034c2:	004b2503          	lw	a0,4(s6)
    800034c6:	000a849b          	sext.w	s1,s5
    800034ca:	8662                	mv	a2,s8
    800034cc:	faa4fde3          	bgeu	s1,a0,80003486 <balloc+0x3a>
      m = 1 << (bi % 8);
    800034d0:	41f6579b          	sraiw	a5,a2,0x1f
    800034d4:	01d7d69b          	srliw	a3,a5,0x1d
    800034d8:	00c6873b          	addw	a4,a3,a2
    800034dc:	00777793          	andi	a5,a4,7
    800034e0:	9f95                	subw	a5,a5,a3
    800034e2:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800034e6:	4037571b          	sraiw	a4,a4,0x3
    800034ea:	00e906b3          	add	a3,s2,a4
    800034ee:	0586c683          	lbu	a3,88(a3)
    800034f2:	00d7f5b3          	and	a1,a5,a3
    800034f6:	cd91                	beqz	a1,80003512 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800034f8:	2605                	addiw	a2,a2,1
    800034fa:	2485                	addiw	s1,s1,1
    800034fc:	fd4618e3          	bne	a2,s4,800034cc <balloc+0x80>
    80003500:	b759                	j	80003486 <balloc+0x3a>
  panic("balloc: out of blocks");
    80003502:	00005517          	auipc	a0,0x5
    80003506:	0ae50513          	addi	a0,a0,174 # 800085b0 <syscalls+0x118>
    8000350a:	ffffd097          	auipc	ra,0xffffd
    8000350e:	0da080e7          	jalr	218(ra) # 800005e4 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003512:	974a                	add	a4,a4,s2
    80003514:	8fd5                	or	a5,a5,a3
    80003516:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    8000351a:	854a                	mv	a0,s2
    8000351c:	00001097          	auipc	ra,0x1
    80003520:	006080e7          	jalr	6(ra) # 80004522 <log_write>
        brelse(bp);
    80003524:	854a                	mv	a0,s2
    80003526:	00000097          	auipc	ra,0x0
    8000352a:	d94080e7          	jalr	-620(ra) # 800032ba <brelse>
  bp = bread(dev, bno);
    8000352e:	85a6                	mv	a1,s1
    80003530:	855e                	mv	a0,s7
    80003532:	00000097          	auipc	ra,0x0
    80003536:	c58080e7          	jalr	-936(ra) # 8000318a <bread>
    8000353a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000353c:	40000613          	li	a2,1024
    80003540:	4581                	li	a1,0
    80003542:	05850513          	addi	a0,a0,88
    80003546:	ffffe097          	auipc	ra,0xffffe
    8000354a:	8f0080e7          	jalr	-1808(ra) # 80000e36 <memset>
  log_write(bp);
    8000354e:	854a                	mv	a0,s2
    80003550:	00001097          	auipc	ra,0x1
    80003554:	fd2080e7          	jalr	-46(ra) # 80004522 <log_write>
  brelse(bp);
    80003558:	854a                	mv	a0,s2
    8000355a:	00000097          	auipc	ra,0x0
    8000355e:	d60080e7          	jalr	-672(ra) # 800032ba <brelse>
}
    80003562:	8526                	mv	a0,s1
    80003564:	60e6                	ld	ra,88(sp)
    80003566:	6446                	ld	s0,80(sp)
    80003568:	64a6                	ld	s1,72(sp)
    8000356a:	6906                	ld	s2,64(sp)
    8000356c:	79e2                	ld	s3,56(sp)
    8000356e:	7a42                	ld	s4,48(sp)
    80003570:	7aa2                	ld	s5,40(sp)
    80003572:	7b02                	ld	s6,32(sp)
    80003574:	6be2                	ld	s7,24(sp)
    80003576:	6c42                	ld	s8,16(sp)
    80003578:	6ca2                	ld	s9,8(sp)
    8000357a:	6125                	addi	sp,sp,96
    8000357c:	8082                	ret

000000008000357e <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000357e:	7179                	addi	sp,sp,-48
    80003580:	f406                	sd	ra,40(sp)
    80003582:	f022                	sd	s0,32(sp)
    80003584:	ec26                	sd	s1,24(sp)
    80003586:	e84a                	sd	s2,16(sp)
    80003588:	e44e                	sd	s3,8(sp)
    8000358a:	e052                	sd	s4,0(sp)
    8000358c:	1800                	addi	s0,sp,48
    8000358e:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003590:	47ad                	li	a5,11
    80003592:	04b7fe63          	bgeu	a5,a1,800035ee <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80003596:	ff45849b          	addiw	s1,a1,-12
    8000359a:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000359e:	0ff00793          	li	a5,255
    800035a2:	0ae7e363          	bltu	a5,a4,80003648 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800035a6:	08052583          	lw	a1,128(a0)
    800035aa:	c5ad                	beqz	a1,80003614 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800035ac:	00092503          	lw	a0,0(s2)
    800035b0:	00000097          	auipc	ra,0x0
    800035b4:	bda080e7          	jalr	-1062(ra) # 8000318a <bread>
    800035b8:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800035ba:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800035be:	02049593          	slli	a1,s1,0x20
    800035c2:	9181                	srli	a1,a1,0x20
    800035c4:	058a                	slli	a1,a1,0x2
    800035c6:	00b784b3          	add	s1,a5,a1
    800035ca:	0004a983          	lw	s3,0(s1)
    800035ce:	04098d63          	beqz	s3,80003628 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800035d2:	8552                	mv	a0,s4
    800035d4:	00000097          	auipc	ra,0x0
    800035d8:	ce6080e7          	jalr	-794(ra) # 800032ba <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800035dc:	854e                	mv	a0,s3
    800035de:	70a2                	ld	ra,40(sp)
    800035e0:	7402                	ld	s0,32(sp)
    800035e2:	64e2                	ld	s1,24(sp)
    800035e4:	6942                	ld	s2,16(sp)
    800035e6:	69a2                	ld	s3,8(sp)
    800035e8:	6a02                	ld	s4,0(sp)
    800035ea:	6145                	addi	sp,sp,48
    800035ec:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800035ee:	02059493          	slli	s1,a1,0x20
    800035f2:	9081                	srli	s1,s1,0x20
    800035f4:	048a                	slli	s1,s1,0x2
    800035f6:	94aa                	add	s1,s1,a0
    800035f8:	0504a983          	lw	s3,80(s1)
    800035fc:	fe0990e3          	bnez	s3,800035dc <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80003600:	4108                	lw	a0,0(a0)
    80003602:	00000097          	auipc	ra,0x0
    80003606:	e4a080e7          	jalr	-438(ra) # 8000344c <balloc>
    8000360a:	0005099b          	sext.w	s3,a0
    8000360e:	0534a823          	sw	s3,80(s1)
    80003612:	b7e9                	j	800035dc <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80003614:	4108                	lw	a0,0(a0)
    80003616:	00000097          	auipc	ra,0x0
    8000361a:	e36080e7          	jalr	-458(ra) # 8000344c <balloc>
    8000361e:	0005059b          	sext.w	a1,a0
    80003622:	08b92023          	sw	a1,128(s2)
    80003626:	b759                	j	800035ac <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80003628:	00092503          	lw	a0,0(s2)
    8000362c:	00000097          	auipc	ra,0x0
    80003630:	e20080e7          	jalr	-480(ra) # 8000344c <balloc>
    80003634:	0005099b          	sext.w	s3,a0
    80003638:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000363c:	8552                	mv	a0,s4
    8000363e:	00001097          	auipc	ra,0x1
    80003642:	ee4080e7          	jalr	-284(ra) # 80004522 <log_write>
    80003646:	b771                	j	800035d2 <bmap+0x54>
  panic("bmap: out of range");
    80003648:	00005517          	auipc	a0,0x5
    8000364c:	f8050513          	addi	a0,a0,-128 # 800085c8 <syscalls+0x130>
    80003650:	ffffd097          	auipc	ra,0xffffd
    80003654:	f94080e7          	jalr	-108(ra) # 800005e4 <panic>

0000000080003658 <iget>:
{
    80003658:	7179                	addi	sp,sp,-48
    8000365a:	f406                	sd	ra,40(sp)
    8000365c:	f022                	sd	s0,32(sp)
    8000365e:	ec26                	sd	s1,24(sp)
    80003660:	e84a                	sd	s2,16(sp)
    80003662:	e44e                	sd	s3,8(sp)
    80003664:	e052                	sd	s4,0(sp)
    80003666:	1800                	addi	s0,sp,48
    80003668:	89aa                	mv	s3,a0
    8000366a:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    8000366c:	0003d517          	auipc	a0,0x3d
    80003670:	80450513          	addi	a0,a0,-2044 # 8003fe70 <icache>
    80003674:	ffffd097          	auipc	ra,0xffffd
    80003678:	6c6080e7          	jalr	1734(ra) # 80000d3a <acquire>
  empty = 0;
    8000367c:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    8000367e:	0003d497          	auipc	s1,0x3d
    80003682:	80a48493          	addi	s1,s1,-2038 # 8003fe88 <icache+0x18>
    80003686:	0003e697          	auipc	a3,0x3e
    8000368a:	29268693          	addi	a3,a3,658 # 80041918 <log>
    8000368e:	a039                	j	8000369c <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003690:	02090b63          	beqz	s2,800036c6 <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    80003694:	08848493          	addi	s1,s1,136
    80003698:	02d48a63          	beq	s1,a3,800036cc <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000369c:	449c                	lw	a5,8(s1)
    8000369e:	fef059e3          	blez	a5,80003690 <iget+0x38>
    800036a2:	4098                	lw	a4,0(s1)
    800036a4:	ff3716e3          	bne	a4,s3,80003690 <iget+0x38>
    800036a8:	40d8                	lw	a4,4(s1)
    800036aa:	ff4713e3          	bne	a4,s4,80003690 <iget+0x38>
      ip->ref++;
    800036ae:	2785                	addiw	a5,a5,1
    800036b0:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    800036b2:	0003c517          	auipc	a0,0x3c
    800036b6:	7be50513          	addi	a0,a0,1982 # 8003fe70 <icache>
    800036ba:	ffffd097          	auipc	ra,0xffffd
    800036be:	734080e7          	jalr	1844(ra) # 80000dee <release>
      return ip;
    800036c2:	8926                	mv	s2,s1
    800036c4:	a03d                	j	800036f2 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800036c6:	f7f9                	bnez	a5,80003694 <iget+0x3c>
    800036c8:	8926                	mv	s2,s1
    800036ca:	b7e9                	j	80003694 <iget+0x3c>
  if(empty == 0)
    800036cc:	02090c63          	beqz	s2,80003704 <iget+0xac>
  ip->dev = dev;
    800036d0:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800036d4:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800036d8:	4785                	li	a5,1
    800036da:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800036de:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    800036e2:	0003c517          	auipc	a0,0x3c
    800036e6:	78e50513          	addi	a0,a0,1934 # 8003fe70 <icache>
    800036ea:	ffffd097          	auipc	ra,0xffffd
    800036ee:	704080e7          	jalr	1796(ra) # 80000dee <release>
}
    800036f2:	854a                	mv	a0,s2
    800036f4:	70a2                	ld	ra,40(sp)
    800036f6:	7402                	ld	s0,32(sp)
    800036f8:	64e2                	ld	s1,24(sp)
    800036fa:	6942                	ld	s2,16(sp)
    800036fc:	69a2                	ld	s3,8(sp)
    800036fe:	6a02                	ld	s4,0(sp)
    80003700:	6145                	addi	sp,sp,48
    80003702:	8082                	ret
    panic("iget: no inodes");
    80003704:	00005517          	auipc	a0,0x5
    80003708:	edc50513          	addi	a0,a0,-292 # 800085e0 <syscalls+0x148>
    8000370c:	ffffd097          	auipc	ra,0xffffd
    80003710:	ed8080e7          	jalr	-296(ra) # 800005e4 <panic>

0000000080003714 <fsinit>:
fsinit(int dev) {
    80003714:	7179                	addi	sp,sp,-48
    80003716:	f406                	sd	ra,40(sp)
    80003718:	f022                	sd	s0,32(sp)
    8000371a:	ec26                	sd	s1,24(sp)
    8000371c:	e84a                	sd	s2,16(sp)
    8000371e:	e44e                	sd	s3,8(sp)
    80003720:	1800                	addi	s0,sp,48
    80003722:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003724:	4585                	li	a1,1
    80003726:	00000097          	auipc	ra,0x0
    8000372a:	a64080e7          	jalr	-1436(ra) # 8000318a <bread>
    8000372e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003730:	0003c997          	auipc	s3,0x3c
    80003734:	72098993          	addi	s3,s3,1824 # 8003fe50 <sb>
    80003738:	02000613          	li	a2,32
    8000373c:	05850593          	addi	a1,a0,88
    80003740:	854e                	mv	a0,s3
    80003742:	ffffd097          	auipc	ra,0xffffd
    80003746:	750080e7          	jalr	1872(ra) # 80000e92 <memmove>
  brelse(bp);
    8000374a:	8526                	mv	a0,s1
    8000374c:	00000097          	auipc	ra,0x0
    80003750:	b6e080e7          	jalr	-1170(ra) # 800032ba <brelse>
  if(sb.magic != FSMAGIC)
    80003754:	0009a703          	lw	a4,0(s3)
    80003758:	102037b7          	lui	a5,0x10203
    8000375c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003760:	02f71263          	bne	a4,a5,80003784 <fsinit+0x70>
  initlog(dev, &sb);
    80003764:	0003c597          	auipc	a1,0x3c
    80003768:	6ec58593          	addi	a1,a1,1772 # 8003fe50 <sb>
    8000376c:	854a                	mv	a0,s2
    8000376e:	00001097          	auipc	ra,0x1
    80003772:	b3c080e7          	jalr	-1220(ra) # 800042aa <initlog>
}
    80003776:	70a2                	ld	ra,40(sp)
    80003778:	7402                	ld	s0,32(sp)
    8000377a:	64e2                	ld	s1,24(sp)
    8000377c:	6942                	ld	s2,16(sp)
    8000377e:	69a2                	ld	s3,8(sp)
    80003780:	6145                	addi	sp,sp,48
    80003782:	8082                	ret
    panic("invalid file system");
    80003784:	00005517          	auipc	a0,0x5
    80003788:	e6c50513          	addi	a0,a0,-404 # 800085f0 <syscalls+0x158>
    8000378c:	ffffd097          	auipc	ra,0xffffd
    80003790:	e58080e7          	jalr	-424(ra) # 800005e4 <panic>

0000000080003794 <iinit>:
{
    80003794:	7179                	addi	sp,sp,-48
    80003796:	f406                	sd	ra,40(sp)
    80003798:	f022                	sd	s0,32(sp)
    8000379a:	ec26                	sd	s1,24(sp)
    8000379c:	e84a                	sd	s2,16(sp)
    8000379e:	e44e                	sd	s3,8(sp)
    800037a0:	1800                	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    800037a2:	00005597          	auipc	a1,0x5
    800037a6:	e6658593          	addi	a1,a1,-410 # 80008608 <syscalls+0x170>
    800037aa:	0003c517          	auipc	a0,0x3c
    800037ae:	6c650513          	addi	a0,a0,1734 # 8003fe70 <icache>
    800037b2:	ffffd097          	auipc	ra,0xffffd
    800037b6:	4f8080e7          	jalr	1272(ra) # 80000caa <initlock>
  for(i = 0; i < NINODE; i++) {
    800037ba:	0003c497          	auipc	s1,0x3c
    800037be:	6de48493          	addi	s1,s1,1758 # 8003fe98 <icache+0x28>
    800037c2:	0003e997          	auipc	s3,0x3e
    800037c6:	16698993          	addi	s3,s3,358 # 80041928 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    800037ca:	00005917          	auipc	s2,0x5
    800037ce:	e4690913          	addi	s2,s2,-442 # 80008610 <syscalls+0x178>
    800037d2:	85ca                	mv	a1,s2
    800037d4:	8526                	mv	a0,s1
    800037d6:	00001097          	auipc	ra,0x1
    800037da:	e3a080e7          	jalr	-454(ra) # 80004610 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800037de:	08848493          	addi	s1,s1,136
    800037e2:	ff3498e3          	bne	s1,s3,800037d2 <iinit+0x3e>
}
    800037e6:	70a2                	ld	ra,40(sp)
    800037e8:	7402                	ld	s0,32(sp)
    800037ea:	64e2                	ld	s1,24(sp)
    800037ec:	6942                	ld	s2,16(sp)
    800037ee:	69a2                	ld	s3,8(sp)
    800037f0:	6145                	addi	sp,sp,48
    800037f2:	8082                	ret

00000000800037f4 <ialloc>:
{
    800037f4:	715d                	addi	sp,sp,-80
    800037f6:	e486                	sd	ra,72(sp)
    800037f8:	e0a2                	sd	s0,64(sp)
    800037fa:	fc26                	sd	s1,56(sp)
    800037fc:	f84a                	sd	s2,48(sp)
    800037fe:	f44e                	sd	s3,40(sp)
    80003800:	f052                	sd	s4,32(sp)
    80003802:	ec56                	sd	s5,24(sp)
    80003804:	e85a                	sd	s6,16(sp)
    80003806:	e45e                	sd	s7,8(sp)
    80003808:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    8000380a:	0003c717          	auipc	a4,0x3c
    8000380e:	65272703          	lw	a4,1618(a4) # 8003fe5c <sb+0xc>
    80003812:	4785                	li	a5,1
    80003814:	04e7fa63          	bgeu	a5,a4,80003868 <ialloc+0x74>
    80003818:	8aaa                	mv	s5,a0
    8000381a:	8bae                	mv	s7,a1
    8000381c:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000381e:	0003ca17          	auipc	s4,0x3c
    80003822:	632a0a13          	addi	s4,s4,1586 # 8003fe50 <sb>
    80003826:	00048b1b          	sext.w	s6,s1
    8000382a:	0044d793          	srli	a5,s1,0x4
    8000382e:	018a2583          	lw	a1,24(s4)
    80003832:	9dbd                	addw	a1,a1,a5
    80003834:	8556                	mv	a0,s5
    80003836:	00000097          	auipc	ra,0x0
    8000383a:	954080e7          	jalr	-1708(ra) # 8000318a <bread>
    8000383e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003840:	05850993          	addi	s3,a0,88
    80003844:	00f4f793          	andi	a5,s1,15
    80003848:	079a                	slli	a5,a5,0x6
    8000384a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000384c:	00099783          	lh	a5,0(s3)
    80003850:	c785                	beqz	a5,80003878 <ialloc+0x84>
    brelse(bp);
    80003852:	00000097          	auipc	ra,0x0
    80003856:	a68080e7          	jalr	-1432(ra) # 800032ba <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000385a:	0485                	addi	s1,s1,1
    8000385c:	00ca2703          	lw	a4,12(s4)
    80003860:	0004879b          	sext.w	a5,s1
    80003864:	fce7e1e3          	bltu	a5,a4,80003826 <ialloc+0x32>
  panic("ialloc: no inodes");
    80003868:	00005517          	auipc	a0,0x5
    8000386c:	db050513          	addi	a0,a0,-592 # 80008618 <syscalls+0x180>
    80003870:	ffffd097          	auipc	ra,0xffffd
    80003874:	d74080e7          	jalr	-652(ra) # 800005e4 <panic>
      memset(dip, 0, sizeof(*dip));
    80003878:	04000613          	li	a2,64
    8000387c:	4581                	li	a1,0
    8000387e:	854e                	mv	a0,s3
    80003880:	ffffd097          	auipc	ra,0xffffd
    80003884:	5b6080e7          	jalr	1462(ra) # 80000e36 <memset>
      dip->type = type;
    80003888:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000388c:	854a                	mv	a0,s2
    8000388e:	00001097          	auipc	ra,0x1
    80003892:	c94080e7          	jalr	-876(ra) # 80004522 <log_write>
      brelse(bp);
    80003896:	854a                	mv	a0,s2
    80003898:	00000097          	auipc	ra,0x0
    8000389c:	a22080e7          	jalr	-1502(ra) # 800032ba <brelse>
      return iget(dev, inum);
    800038a0:	85da                	mv	a1,s6
    800038a2:	8556                	mv	a0,s5
    800038a4:	00000097          	auipc	ra,0x0
    800038a8:	db4080e7          	jalr	-588(ra) # 80003658 <iget>
}
    800038ac:	60a6                	ld	ra,72(sp)
    800038ae:	6406                	ld	s0,64(sp)
    800038b0:	74e2                	ld	s1,56(sp)
    800038b2:	7942                	ld	s2,48(sp)
    800038b4:	79a2                	ld	s3,40(sp)
    800038b6:	7a02                	ld	s4,32(sp)
    800038b8:	6ae2                	ld	s5,24(sp)
    800038ba:	6b42                	ld	s6,16(sp)
    800038bc:	6ba2                	ld	s7,8(sp)
    800038be:	6161                	addi	sp,sp,80
    800038c0:	8082                	ret

00000000800038c2 <iupdate>:
{
    800038c2:	1101                	addi	sp,sp,-32
    800038c4:	ec06                	sd	ra,24(sp)
    800038c6:	e822                	sd	s0,16(sp)
    800038c8:	e426                	sd	s1,8(sp)
    800038ca:	e04a                	sd	s2,0(sp)
    800038cc:	1000                	addi	s0,sp,32
    800038ce:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800038d0:	415c                	lw	a5,4(a0)
    800038d2:	0047d79b          	srliw	a5,a5,0x4
    800038d6:	0003c597          	auipc	a1,0x3c
    800038da:	5925a583          	lw	a1,1426(a1) # 8003fe68 <sb+0x18>
    800038de:	9dbd                	addw	a1,a1,a5
    800038e0:	4108                	lw	a0,0(a0)
    800038e2:	00000097          	auipc	ra,0x0
    800038e6:	8a8080e7          	jalr	-1880(ra) # 8000318a <bread>
    800038ea:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800038ec:	05850793          	addi	a5,a0,88
    800038f0:	40c8                	lw	a0,4(s1)
    800038f2:	893d                	andi	a0,a0,15
    800038f4:	051a                	slli	a0,a0,0x6
    800038f6:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    800038f8:	04449703          	lh	a4,68(s1)
    800038fc:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80003900:	04649703          	lh	a4,70(s1)
    80003904:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003908:	04849703          	lh	a4,72(s1)
    8000390c:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80003910:	04a49703          	lh	a4,74(s1)
    80003914:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80003918:	44f8                	lw	a4,76(s1)
    8000391a:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000391c:	03400613          	li	a2,52
    80003920:	05048593          	addi	a1,s1,80
    80003924:	0531                	addi	a0,a0,12
    80003926:	ffffd097          	auipc	ra,0xffffd
    8000392a:	56c080e7          	jalr	1388(ra) # 80000e92 <memmove>
  log_write(bp);
    8000392e:	854a                	mv	a0,s2
    80003930:	00001097          	auipc	ra,0x1
    80003934:	bf2080e7          	jalr	-1038(ra) # 80004522 <log_write>
  brelse(bp);
    80003938:	854a                	mv	a0,s2
    8000393a:	00000097          	auipc	ra,0x0
    8000393e:	980080e7          	jalr	-1664(ra) # 800032ba <brelse>
}
    80003942:	60e2                	ld	ra,24(sp)
    80003944:	6442                	ld	s0,16(sp)
    80003946:	64a2                	ld	s1,8(sp)
    80003948:	6902                	ld	s2,0(sp)
    8000394a:	6105                	addi	sp,sp,32
    8000394c:	8082                	ret

000000008000394e <idup>:
{
    8000394e:	1101                	addi	sp,sp,-32
    80003950:	ec06                	sd	ra,24(sp)
    80003952:	e822                	sd	s0,16(sp)
    80003954:	e426                	sd	s1,8(sp)
    80003956:	1000                	addi	s0,sp,32
    80003958:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    8000395a:	0003c517          	auipc	a0,0x3c
    8000395e:	51650513          	addi	a0,a0,1302 # 8003fe70 <icache>
    80003962:	ffffd097          	auipc	ra,0xffffd
    80003966:	3d8080e7          	jalr	984(ra) # 80000d3a <acquire>
  ip->ref++;
    8000396a:	449c                	lw	a5,8(s1)
    8000396c:	2785                	addiw	a5,a5,1
    8000396e:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003970:	0003c517          	auipc	a0,0x3c
    80003974:	50050513          	addi	a0,a0,1280 # 8003fe70 <icache>
    80003978:	ffffd097          	auipc	ra,0xffffd
    8000397c:	476080e7          	jalr	1142(ra) # 80000dee <release>
}
    80003980:	8526                	mv	a0,s1
    80003982:	60e2                	ld	ra,24(sp)
    80003984:	6442                	ld	s0,16(sp)
    80003986:	64a2                	ld	s1,8(sp)
    80003988:	6105                	addi	sp,sp,32
    8000398a:	8082                	ret

000000008000398c <ilock>:
{
    8000398c:	1101                	addi	sp,sp,-32
    8000398e:	ec06                	sd	ra,24(sp)
    80003990:	e822                	sd	s0,16(sp)
    80003992:	e426                	sd	s1,8(sp)
    80003994:	e04a                	sd	s2,0(sp)
    80003996:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003998:	c115                	beqz	a0,800039bc <ilock+0x30>
    8000399a:	84aa                	mv	s1,a0
    8000399c:	451c                	lw	a5,8(a0)
    8000399e:	00f05f63          	blez	a5,800039bc <ilock+0x30>
  acquiresleep(&ip->lock);
    800039a2:	0541                	addi	a0,a0,16
    800039a4:	00001097          	auipc	ra,0x1
    800039a8:	ca6080e7          	jalr	-858(ra) # 8000464a <acquiresleep>
  if(ip->valid == 0){
    800039ac:	40bc                	lw	a5,64(s1)
    800039ae:	cf99                	beqz	a5,800039cc <ilock+0x40>
}
    800039b0:	60e2                	ld	ra,24(sp)
    800039b2:	6442                	ld	s0,16(sp)
    800039b4:	64a2                	ld	s1,8(sp)
    800039b6:	6902                	ld	s2,0(sp)
    800039b8:	6105                	addi	sp,sp,32
    800039ba:	8082                	ret
    panic("ilock");
    800039bc:	00005517          	auipc	a0,0x5
    800039c0:	c7450513          	addi	a0,a0,-908 # 80008630 <syscalls+0x198>
    800039c4:	ffffd097          	auipc	ra,0xffffd
    800039c8:	c20080e7          	jalr	-992(ra) # 800005e4 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800039cc:	40dc                	lw	a5,4(s1)
    800039ce:	0047d79b          	srliw	a5,a5,0x4
    800039d2:	0003c597          	auipc	a1,0x3c
    800039d6:	4965a583          	lw	a1,1174(a1) # 8003fe68 <sb+0x18>
    800039da:	9dbd                	addw	a1,a1,a5
    800039dc:	4088                	lw	a0,0(s1)
    800039de:	fffff097          	auipc	ra,0xfffff
    800039e2:	7ac080e7          	jalr	1964(ra) # 8000318a <bread>
    800039e6:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800039e8:	05850593          	addi	a1,a0,88
    800039ec:	40dc                	lw	a5,4(s1)
    800039ee:	8bbd                	andi	a5,a5,15
    800039f0:	079a                	slli	a5,a5,0x6
    800039f2:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800039f4:	00059783          	lh	a5,0(a1)
    800039f8:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800039fc:	00259783          	lh	a5,2(a1)
    80003a00:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003a04:	00459783          	lh	a5,4(a1)
    80003a08:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003a0c:	00659783          	lh	a5,6(a1)
    80003a10:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003a14:	459c                	lw	a5,8(a1)
    80003a16:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003a18:	03400613          	li	a2,52
    80003a1c:	05b1                	addi	a1,a1,12
    80003a1e:	05048513          	addi	a0,s1,80
    80003a22:	ffffd097          	auipc	ra,0xffffd
    80003a26:	470080e7          	jalr	1136(ra) # 80000e92 <memmove>
    brelse(bp);
    80003a2a:	854a                	mv	a0,s2
    80003a2c:	00000097          	auipc	ra,0x0
    80003a30:	88e080e7          	jalr	-1906(ra) # 800032ba <brelse>
    ip->valid = 1;
    80003a34:	4785                	li	a5,1
    80003a36:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003a38:	04449783          	lh	a5,68(s1)
    80003a3c:	fbb5                	bnez	a5,800039b0 <ilock+0x24>
      panic("ilock: no type");
    80003a3e:	00005517          	auipc	a0,0x5
    80003a42:	bfa50513          	addi	a0,a0,-1030 # 80008638 <syscalls+0x1a0>
    80003a46:	ffffd097          	auipc	ra,0xffffd
    80003a4a:	b9e080e7          	jalr	-1122(ra) # 800005e4 <panic>

0000000080003a4e <iunlock>:
{
    80003a4e:	1101                	addi	sp,sp,-32
    80003a50:	ec06                	sd	ra,24(sp)
    80003a52:	e822                	sd	s0,16(sp)
    80003a54:	e426                	sd	s1,8(sp)
    80003a56:	e04a                	sd	s2,0(sp)
    80003a58:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003a5a:	c905                	beqz	a0,80003a8a <iunlock+0x3c>
    80003a5c:	84aa                	mv	s1,a0
    80003a5e:	01050913          	addi	s2,a0,16
    80003a62:	854a                	mv	a0,s2
    80003a64:	00001097          	auipc	ra,0x1
    80003a68:	c80080e7          	jalr	-896(ra) # 800046e4 <holdingsleep>
    80003a6c:	cd19                	beqz	a0,80003a8a <iunlock+0x3c>
    80003a6e:	449c                	lw	a5,8(s1)
    80003a70:	00f05d63          	blez	a5,80003a8a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003a74:	854a                	mv	a0,s2
    80003a76:	00001097          	auipc	ra,0x1
    80003a7a:	c2a080e7          	jalr	-982(ra) # 800046a0 <releasesleep>
}
    80003a7e:	60e2                	ld	ra,24(sp)
    80003a80:	6442                	ld	s0,16(sp)
    80003a82:	64a2                	ld	s1,8(sp)
    80003a84:	6902                	ld	s2,0(sp)
    80003a86:	6105                	addi	sp,sp,32
    80003a88:	8082                	ret
    panic("iunlock");
    80003a8a:	00005517          	auipc	a0,0x5
    80003a8e:	bbe50513          	addi	a0,a0,-1090 # 80008648 <syscalls+0x1b0>
    80003a92:	ffffd097          	auipc	ra,0xffffd
    80003a96:	b52080e7          	jalr	-1198(ra) # 800005e4 <panic>

0000000080003a9a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003a9a:	7179                	addi	sp,sp,-48
    80003a9c:	f406                	sd	ra,40(sp)
    80003a9e:	f022                	sd	s0,32(sp)
    80003aa0:	ec26                	sd	s1,24(sp)
    80003aa2:	e84a                	sd	s2,16(sp)
    80003aa4:	e44e                	sd	s3,8(sp)
    80003aa6:	e052                	sd	s4,0(sp)
    80003aa8:	1800                	addi	s0,sp,48
    80003aaa:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003aac:	05050493          	addi	s1,a0,80
    80003ab0:	08050913          	addi	s2,a0,128
    80003ab4:	a021                	j	80003abc <itrunc+0x22>
    80003ab6:	0491                	addi	s1,s1,4
    80003ab8:	01248d63          	beq	s1,s2,80003ad2 <itrunc+0x38>
    if(ip->addrs[i]){
    80003abc:	408c                	lw	a1,0(s1)
    80003abe:	dde5                	beqz	a1,80003ab6 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003ac0:	0009a503          	lw	a0,0(s3)
    80003ac4:	00000097          	auipc	ra,0x0
    80003ac8:	90c080e7          	jalr	-1780(ra) # 800033d0 <bfree>
      ip->addrs[i] = 0;
    80003acc:	0004a023          	sw	zero,0(s1)
    80003ad0:	b7dd                	j	80003ab6 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003ad2:	0809a583          	lw	a1,128(s3)
    80003ad6:	e185                	bnez	a1,80003af6 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003ad8:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003adc:	854e                	mv	a0,s3
    80003ade:	00000097          	auipc	ra,0x0
    80003ae2:	de4080e7          	jalr	-540(ra) # 800038c2 <iupdate>
}
    80003ae6:	70a2                	ld	ra,40(sp)
    80003ae8:	7402                	ld	s0,32(sp)
    80003aea:	64e2                	ld	s1,24(sp)
    80003aec:	6942                	ld	s2,16(sp)
    80003aee:	69a2                	ld	s3,8(sp)
    80003af0:	6a02                	ld	s4,0(sp)
    80003af2:	6145                	addi	sp,sp,48
    80003af4:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003af6:	0009a503          	lw	a0,0(s3)
    80003afa:	fffff097          	auipc	ra,0xfffff
    80003afe:	690080e7          	jalr	1680(ra) # 8000318a <bread>
    80003b02:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003b04:	05850493          	addi	s1,a0,88
    80003b08:	45850913          	addi	s2,a0,1112
    80003b0c:	a021                	j	80003b14 <itrunc+0x7a>
    80003b0e:	0491                	addi	s1,s1,4
    80003b10:	01248b63          	beq	s1,s2,80003b26 <itrunc+0x8c>
      if(a[j])
    80003b14:	408c                	lw	a1,0(s1)
    80003b16:	dde5                	beqz	a1,80003b0e <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003b18:	0009a503          	lw	a0,0(s3)
    80003b1c:	00000097          	auipc	ra,0x0
    80003b20:	8b4080e7          	jalr	-1868(ra) # 800033d0 <bfree>
    80003b24:	b7ed                	j	80003b0e <itrunc+0x74>
    brelse(bp);
    80003b26:	8552                	mv	a0,s4
    80003b28:	fffff097          	auipc	ra,0xfffff
    80003b2c:	792080e7          	jalr	1938(ra) # 800032ba <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003b30:	0809a583          	lw	a1,128(s3)
    80003b34:	0009a503          	lw	a0,0(s3)
    80003b38:	00000097          	auipc	ra,0x0
    80003b3c:	898080e7          	jalr	-1896(ra) # 800033d0 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003b40:	0809a023          	sw	zero,128(s3)
    80003b44:	bf51                	j	80003ad8 <itrunc+0x3e>

0000000080003b46 <iput>:
{
    80003b46:	1101                	addi	sp,sp,-32
    80003b48:	ec06                	sd	ra,24(sp)
    80003b4a:	e822                	sd	s0,16(sp)
    80003b4c:	e426                	sd	s1,8(sp)
    80003b4e:	e04a                	sd	s2,0(sp)
    80003b50:	1000                	addi	s0,sp,32
    80003b52:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003b54:	0003c517          	auipc	a0,0x3c
    80003b58:	31c50513          	addi	a0,a0,796 # 8003fe70 <icache>
    80003b5c:	ffffd097          	auipc	ra,0xffffd
    80003b60:	1de080e7          	jalr	478(ra) # 80000d3a <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003b64:	4498                	lw	a4,8(s1)
    80003b66:	4785                	li	a5,1
    80003b68:	02f70363          	beq	a4,a5,80003b8e <iput+0x48>
  ip->ref--;
    80003b6c:	449c                	lw	a5,8(s1)
    80003b6e:	37fd                	addiw	a5,a5,-1
    80003b70:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003b72:	0003c517          	auipc	a0,0x3c
    80003b76:	2fe50513          	addi	a0,a0,766 # 8003fe70 <icache>
    80003b7a:	ffffd097          	auipc	ra,0xffffd
    80003b7e:	274080e7          	jalr	628(ra) # 80000dee <release>
}
    80003b82:	60e2                	ld	ra,24(sp)
    80003b84:	6442                	ld	s0,16(sp)
    80003b86:	64a2                	ld	s1,8(sp)
    80003b88:	6902                	ld	s2,0(sp)
    80003b8a:	6105                	addi	sp,sp,32
    80003b8c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003b8e:	40bc                	lw	a5,64(s1)
    80003b90:	dff1                	beqz	a5,80003b6c <iput+0x26>
    80003b92:	04a49783          	lh	a5,74(s1)
    80003b96:	fbf9                	bnez	a5,80003b6c <iput+0x26>
    acquiresleep(&ip->lock);
    80003b98:	01048913          	addi	s2,s1,16
    80003b9c:	854a                	mv	a0,s2
    80003b9e:	00001097          	auipc	ra,0x1
    80003ba2:	aac080e7          	jalr	-1364(ra) # 8000464a <acquiresleep>
    release(&icache.lock);
    80003ba6:	0003c517          	auipc	a0,0x3c
    80003baa:	2ca50513          	addi	a0,a0,714 # 8003fe70 <icache>
    80003bae:	ffffd097          	auipc	ra,0xffffd
    80003bb2:	240080e7          	jalr	576(ra) # 80000dee <release>
    itrunc(ip);
    80003bb6:	8526                	mv	a0,s1
    80003bb8:	00000097          	auipc	ra,0x0
    80003bbc:	ee2080e7          	jalr	-286(ra) # 80003a9a <itrunc>
    ip->type = 0;
    80003bc0:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003bc4:	8526                	mv	a0,s1
    80003bc6:	00000097          	auipc	ra,0x0
    80003bca:	cfc080e7          	jalr	-772(ra) # 800038c2 <iupdate>
    ip->valid = 0;
    80003bce:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003bd2:	854a                	mv	a0,s2
    80003bd4:	00001097          	auipc	ra,0x1
    80003bd8:	acc080e7          	jalr	-1332(ra) # 800046a0 <releasesleep>
    acquire(&icache.lock);
    80003bdc:	0003c517          	auipc	a0,0x3c
    80003be0:	29450513          	addi	a0,a0,660 # 8003fe70 <icache>
    80003be4:	ffffd097          	auipc	ra,0xffffd
    80003be8:	156080e7          	jalr	342(ra) # 80000d3a <acquire>
    80003bec:	b741                	j	80003b6c <iput+0x26>

0000000080003bee <iunlockput>:
{
    80003bee:	1101                	addi	sp,sp,-32
    80003bf0:	ec06                	sd	ra,24(sp)
    80003bf2:	e822                	sd	s0,16(sp)
    80003bf4:	e426                	sd	s1,8(sp)
    80003bf6:	1000                	addi	s0,sp,32
    80003bf8:	84aa                	mv	s1,a0
  iunlock(ip);
    80003bfa:	00000097          	auipc	ra,0x0
    80003bfe:	e54080e7          	jalr	-428(ra) # 80003a4e <iunlock>
  iput(ip);
    80003c02:	8526                	mv	a0,s1
    80003c04:	00000097          	auipc	ra,0x0
    80003c08:	f42080e7          	jalr	-190(ra) # 80003b46 <iput>
}
    80003c0c:	60e2                	ld	ra,24(sp)
    80003c0e:	6442                	ld	s0,16(sp)
    80003c10:	64a2                	ld	s1,8(sp)
    80003c12:	6105                	addi	sp,sp,32
    80003c14:	8082                	ret

0000000080003c16 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003c16:	1141                	addi	sp,sp,-16
    80003c18:	e422                	sd	s0,8(sp)
    80003c1a:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003c1c:	411c                	lw	a5,0(a0)
    80003c1e:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003c20:	415c                	lw	a5,4(a0)
    80003c22:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003c24:	04451783          	lh	a5,68(a0)
    80003c28:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003c2c:	04a51783          	lh	a5,74(a0)
    80003c30:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003c34:	04c56783          	lwu	a5,76(a0)
    80003c38:	e99c                	sd	a5,16(a1)
}
    80003c3a:	6422                	ld	s0,8(sp)
    80003c3c:	0141                	addi	sp,sp,16
    80003c3e:	8082                	ret

0000000080003c40 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003c40:	457c                	lw	a5,76(a0)
    80003c42:	0ed7e963          	bltu	a5,a3,80003d34 <readi+0xf4>
{
    80003c46:	7159                	addi	sp,sp,-112
    80003c48:	f486                	sd	ra,104(sp)
    80003c4a:	f0a2                	sd	s0,96(sp)
    80003c4c:	eca6                	sd	s1,88(sp)
    80003c4e:	e8ca                	sd	s2,80(sp)
    80003c50:	e4ce                	sd	s3,72(sp)
    80003c52:	e0d2                	sd	s4,64(sp)
    80003c54:	fc56                	sd	s5,56(sp)
    80003c56:	f85a                	sd	s6,48(sp)
    80003c58:	f45e                	sd	s7,40(sp)
    80003c5a:	f062                	sd	s8,32(sp)
    80003c5c:	ec66                	sd	s9,24(sp)
    80003c5e:	e86a                	sd	s10,16(sp)
    80003c60:	e46e                	sd	s11,8(sp)
    80003c62:	1880                	addi	s0,sp,112
    80003c64:	8baa                	mv	s7,a0
    80003c66:	8c2e                	mv	s8,a1
    80003c68:	8ab2                	mv	s5,a2
    80003c6a:	84b6                	mv	s1,a3
    80003c6c:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003c6e:	9f35                	addw	a4,a4,a3
    return 0;
    80003c70:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003c72:	0ad76063          	bltu	a4,a3,80003d12 <readi+0xd2>
  if(off + n > ip->size)
    80003c76:	00e7f463          	bgeu	a5,a4,80003c7e <readi+0x3e>
    n = ip->size - off;
    80003c7a:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003c7e:	0a0b0963          	beqz	s6,80003d30 <readi+0xf0>
    80003c82:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003c84:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003c88:	5cfd                	li	s9,-1
    80003c8a:	a82d                	j	80003cc4 <readi+0x84>
    80003c8c:	020a1d93          	slli	s11,s4,0x20
    80003c90:	020ddd93          	srli	s11,s11,0x20
    80003c94:	05890793          	addi	a5,s2,88
    80003c98:	86ee                	mv	a3,s11
    80003c9a:	963e                	add	a2,a2,a5
    80003c9c:	85d6                	mv	a1,s5
    80003c9e:	8562                	mv	a0,s8
    80003ca0:	fffff097          	auipc	ra,0xfffff
    80003ca4:	a34080e7          	jalr	-1484(ra) # 800026d4 <either_copyout>
    80003ca8:	05950d63          	beq	a0,s9,80003d02 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003cac:	854a                	mv	a0,s2
    80003cae:	fffff097          	auipc	ra,0xfffff
    80003cb2:	60c080e7          	jalr	1548(ra) # 800032ba <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003cb6:	013a09bb          	addw	s3,s4,s3
    80003cba:	009a04bb          	addw	s1,s4,s1
    80003cbe:	9aee                	add	s5,s5,s11
    80003cc0:	0569f763          	bgeu	s3,s6,80003d0e <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003cc4:	000ba903          	lw	s2,0(s7)
    80003cc8:	00a4d59b          	srliw	a1,s1,0xa
    80003ccc:	855e                	mv	a0,s7
    80003cce:	00000097          	auipc	ra,0x0
    80003cd2:	8b0080e7          	jalr	-1872(ra) # 8000357e <bmap>
    80003cd6:	0005059b          	sext.w	a1,a0
    80003cda:	854a                	mv	a0,s2
    80003cdc:	fffff097          	auipc	ra,0xfffff
    80003ce0:	4ae080e7          	jalr	1198(ra) # 8000318a <bread>
    80003ce4:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003ce6:	3ff4f613          	andi	a2,s1,1023
    80003cea:	40cd07bb          	subw	a5,s10,a2
    80003cee:	413b073b          	subw	a4,s6,s3
    80003cf2:	8a3e                	mv	s4,a5
    80003cf4:	2781                	sext.w	a5,a5
    80003cf6:	0007069b          	sext.w	a3,a4
    80003cfa:	f8f6f9e3          	bgeu	a3,a5,80003c8c <readi+0x4c>
    80003cfe:	8a3a                	mv	s4,a4
    80003d00:	b771                	j	80003c8c <readi+0x4c>
      brelse(bp);
    80003d02:	854a                	mv	a0,s2
    80003d04:	fffff097          	auipc	ra,0xfffff
    80003d08:	5b6080e7          	jalr	1462(ra) # 800032ba <brelse>
      tot = -1;
    80003d0c:	59fd                	li	s3,-1
  }
  return tot;
    80003d0e:	0009851b          	sext.w	a0,s3
}
    80003d12:	70a6                	ld	ra,104(sp)
    80003d14:	7406                	ld	s0,96(sp)
    80003d16:	64e6                	ld	s1,88(sp)
    80003d18:	6946                	ld	s2,80(sp)
    80003d1a:	69a6                	ld	s3,72(sp)
    80003d1c:	6a06                	ld	s4,64(sp)
    80003d1e:	7ae2                	ld	s5,56(sp)
    80003d20:	7b42                	ld	s6,48(sp)
    80003d22:	7ba2                	ld	s7,40(sp)
    80003d24:	7c02                	ld	s8,32(sp)
    80003d26:	6ce2                	ld	s9,24(sp)
    80003d28:	6d42                	ld	s10,16(sp)
    80003d2a:	6da2                	ld	s11,8(sp)
    80003d2c:	6165                	addi	sp,sp,112
    80003d2e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003d30:	89da                	mv	s3,s6
    80003d32:	bff1                	j	80003d0e <readi+0xce>
    return 0;
    80003d34:	4501                	li	a0,0
}
    80003d36:	8082                	ret

0000000080003d38 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003d38:	457c                	lw	a5,76(a0)
    80003d3a:	10d7e763          	bltu	a5,a3,80003e48 <writei+0x110>
{
    80003d3e:	7159                	addi	sp,sp,-112
    80003d40:	f486                	sd	ra,104(sp)
    80003d42:	f0a2                	sd	s0,96(sp)
    80003d44:	eca6                	sd	s1,88(sp)
    80003d46:	e8ca                	sd	s2,80(sp)
    80003d48:	e4ce                	sd	s3,72(sp)
    80003d4a:	e0d2                	sd	s4,64(sp)
    80003d4c:	fc56                	sd	s5,56(sp)
    80003d4e:	f85a                	sd	s6,48(sp)
    80003d50:	f45e                	sd	s7,40(sp)
    80003d52:	f062                	sd	s8,32(sp)
    80003d54:	ec66                	sd	s9,24(sp)
    80003d56:	e86a                	sd	s10,16(sp)
    80003d58:	e46e                	sd	s11,8(sp)
    80003d5a:	1880                	addi	s0,sp,112
    80003d5c:	8baa                	mv	s7,a0
    80003d5e:	8c2e                	mv	s8,a1
    80003d60:	8ab2                	mv	s5,a2
    80003d62:	8936                	mv	s2,a3
    80003d64:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003d66:	00e687bb          	addw	a5,a3,a4
    80003d6a:	0ed7e163          	bltu	a5,a3,80003e4c <writei+0x114>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003d6e:	00043737          	lui	a4,0x43
    80003d72:	0cf76f63          	bltu	a4,a5,80003e50 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003d76:	0a0b0863          	beqz	s6,80003e26 <writei+0xee>
    80003d7a:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003d7c:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003d80:	5cfd                	li	s9,-1
    80003d82:	a091                	j	80003dc6 <writei+0x8e>
    80003d84:	02099d93          	slli	s11,s3,0x20
    80003d88:	020ddd93          	srli	s11,s11,0x20
    80003d8c:	05848793          	addi	a5,s1,88
    80003d90:	86ee                	mv	a3,s11
    80003d92:	8656                	mv	a2,s5
    80003d94:	85e2                	mv	a1,s8
    80003d96:	953e                	add	a0,a0,a5
    80003d98:	fffff097          	auipc	ra,0xfffff
    80003d9c:	992080e7          	jalr	-1646(ra) # 8000272a <either_copyin>
    80003da0:	07950263          	beq	a0,s9,80003e04 <writei+0xcc>
      brelse(bp);
      n = -1;
      break;
    }
    log_write(bp);
    80003da4:	8526                	mv	a0,s1
    80003da6:	00000097          	auipc	ra,0x0
    80003daa:	77c080e7          	jalr	1916(ra) # 80004522 <log_write>
    brelse(bp);
    80003dae:	8526                	mv	a0,s1
    80003db0:	fffff097          	auipc	ra,0xfffff
    80003db4:	50a080e7          	jalr	1290(ra) # 800032ba <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003db8:	01498a3b          	addw	s4,s3,s4
    80003dbc:	0129893b          	addw	s2,s3,s2
    80003dc0:	9aee                	add	s5,s5,s11
    80003dc2:	056a7763          	bgeu	s4,s6,80003e10 <writei+0xd8>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003dc6:	000ba483          	lw	s1,0(s7)
    80003dca:	00a9559b          	srliw	a1,s2,0xa
    80003dce:	855e                	mv	a0,s7
    80003dd0:	fffff097          	auipc	ra,0xfffff
    80003dd4:	7ae080e7          	jalr	1966(ra) # 8000357e <bmap>
    80003dd8:	0005059b          	sext.w	a1,a0
    80003ddc:	8526                	mv	a0,s1
    80003dde:	fffff097          	auipc	ra,0xfffff
    80003de2:	3ac080e7          	jalr	940(ra) # 8000318a <bread>
    80003de6:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003de8:	3ff97513          	andi	a0,s2,1023
    80003dec:	40ad07bb          	subw	a5,s10,a0
    80003df0:	414b073b          	subw	a4,s6,s4
    80003df4:	89be                	mv	s3,a5
    80003df6:	2781                	sext.w	a5,a5
    80003df8:	0007069b          	sext.w	a3,a4
    80003dfc:	f8f6f4e3          	bgeu	a3,a5,80003d84 <writei+0x4c>
    80003e00:	89ba                	mv	s3,a4
    80003e02:	b749                	j	80003d84 <writei+0x4c>
      brelse(bp);
    80003e04:	8526                	mv	a0,s1
    80003e06:	fffff097          	auipc	ra,0xfffff
    80003e0a:	4b4080e7          	jalr	1204(ra) # 800032ba <brelse>
      n = -1;
    80003e0e:	5b7d                	li	s6,-1
  }

  if(n > 0){
    if(off > ip->size)
    80003e10:	04cba783          	lw	a5,76(s7)
    80003e14:	0127f463          	bgeu	a5,s2,80003e1c <writei+0xe4>
      ip->size = off;
    80003e18:	052ba623          	sw	s2,76(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    80003e1c:	855e                	mv	a0,s7
    80003e1e:	00000097          	auipc	ra,0x0
    80003e22:	aa4080e7          	jalr	-1372(ra) # 800038c2 <iupdate>
  }

  return n;
    80003e26:	000b051b          	sext.w	a0,s6
}
    80003e2a:	70a6                	ld	ra,104(sp)
    80003e2c:	7406                	ld	s0,96(sp)
    80003e2e:	64e6                	ld	s1,88(sp)
    80003e30:	6946                	ld	s2,80(sp)
    80003e32:	69a6                	ld	s3,72(sp)
    80003e34:	6a06                	ld	s4,64(sp)
    80003e36:	7ae2                	ld	s5,56(sp)
    80003e38:	7b42                	ld	s6,48(sp)
    80003e3a:	7ba2                	ld	s7,40(sp)
    80003e3c:	7c02                	ld	s8,32(sp)
    80003e3e:	6ce2                	ld	s9,24(sp)
    80003e40:	6d42                	ld	s10,16(sp)
    80003e42:	6da2                	ld	s11,8(sp)
    80003e44:	6165                	addi	sp,sp,112
    80003e46:	8082                	ret
    return -1;
    80003e48:	557d                	li	a0,-1
}
    80003e4a:	8082                	ret
    return -1;
    80003e4c:	557d                	li	a0,-1
    80003e4e:	bff1                	j	80003e2a <writei+0xf2>
    return -1;
    80003e50:	557d                	li	a0,-1
    80003e52:	bfe1                	j	80003e2a <writei+0xf2>

0000000080003e54 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003e54:	1141                	addi	sp,sp,-16
    80003e56:	e406                	sd	ra,8(sp)
    80003e58:	e022                	sd	s0,0(sp)
    80003e5a:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003e5c:	4639                	li	a2,14
    80003e5e:	ffffd097          	auipc	ra,0xffffd
    80003e62:	0b0080e7          	jalr	176(ra) # 80000f0e <strncmp>
}
    80003e66:	60a2                	ld	ra,8(sp)
    80003e68:	6402                	ld	s0,0(sp)
    80003e6a:	0141                	addi	sp,sp,16
    80003e6c:	8082                	ret

0000000080003e6e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003e6e:	7139                	addi	sp,sp,-64
    80003e70:	fc06                	sd	ra,56(sp)
    80003e72:	f822                	sd	s0,48(sp)
    80003e74:	f426                	sd	s1,40(sp)
    80003e76:	f04a                	sd	s2,32(sp)
    80003e78:	ec4e                	sd	s3,24(sp)
    80003e7a:	e852                	sd	s4,16(sp)
    80003e7c:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003e7e:	04451703          	lh	a4,68(a0)
    80003e82:	4785                	li	a5,1
    80003e84:	00f71a63          	bne	a4,a5,80003e98 <dirlookup+0x2a>
    80003e88:	892a                	mv	s2,a0
    80003e8a:	89ae                	mv	s3,a1
    80003e8c:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e8e:	457c                	lw	a5,76(a0)
    80003e90:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003e92:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e94:	e79d                	bnez	a5,80003ec2 <dirlookup+0x54>
    80003e96:	a8a5                	j	80003f0e <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003e98:	00004517          	auipc	a0,0x4
    80003e9c:	7b850513          	addi	a0,a0,1976 # 80008650 <syscalls+0x1b8>
    80003ea0:	ffffc097          	auipc	ra,0xffffc
    80003ea4:	744080e7          	jalr	1860(ra) # 800005e4 <panic>
      panic("dirlookup read");
    80003ea8:	00004517          	auipc	a0,0x4
    80003eac:	7c050513          	addi	a0,a0,1984 # 80008668 <syscalls+0x1d0>
    80003eb0:	ffffc097          	auipc	ra,0xffffc
    80003eb4:	734080e7          	jalr	1844(ra) # 800005e4 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003eb8:	24c1                	addiw	s1,s1,16
    80003eba:	04c92783          	lw	a5,76(s2)
    80003ebe:	04f4f763          	bgeu	s1,a5,80003f0c <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003ec2:	4741                	li	a4,16
    80003ec4:	86a6                	mv	a3,s1
    80003ec6:	fc040613          	addi	a2,s0,-64
    80003eca:	4581                	li	a1,0
    80003ecc:	854a                	mv	a0,s2
    80003ece:	00000097          	auipc	ra,0x0
    80003ed2:	d72080e7          	jalr	-654(ra) # 80003c40 <readi>
    80003ed6:	47c1                	li	a5,16
    80003ed8:	fcf518e3          	bne	a0,a5,80003ea8 <dirlookup+0x3a>
    if(de.inum == 0)
    80003edc:	fc045783          	lhu	a5,-64(s0)
    80003ee0:	dfe1                	beqz	a5,80003eb8 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003ee2:	fc240593          	addi	a1,s0,-62
    80003ee6:	854e                	mv	a0,s3
    80003ee8:	00000097          	auipc	ra,0x0
    80003eec:	f6c080e7          	jalr	-148(ra) # 80003e54 <namecmp>
    80003ef0:	f561                	bnez	a0,80003eb8 <dirlookup+0x4a>
      if(poff)
    80003ef2:	000a0463          	beqz	s4,80003efa <dirlookup+0x8c>
        *poff = off;
    80003ef6:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003efa:	fc045583          	lhu	a1,-64(s0)
    80003efe:	00092503          	lw	a0,0(s2)
    80003f02:	fffff097          	auipc	ra,0xfffff
    80003f06:	756080e7          	jalr	1878(ra) # 80003658 <iget>
    80003f0a:	a011                	j	80003f0e <dirlookup+0xa0>
  return 0;
    80003f0c:	4501                	li	a0,0
}
    80003f0e:	70e2                	ld	ra,56(sp)
    80003f10:	7442                	ld	s0,48(sp)
    80003f12:	74a2                	ld	s1,40(sp)
    80003f14:	7902                	ld	s2,32(sp)
    80003f16:	69e2                	ld	s3,24(sp)
    80003f18:	6a42                	ld	s4,16(sp)
    80003f1a:	6121                	addi	sp,sp,64
    80003f1c:	8082                	ret

0000000080003f1e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003f1e:	711d                	addi	sp,sp,-96
    80003f20:	ec86                	sd	ra,88(sp)
    80003f22:	e8a2                	sd	s0,80(sp)
    80003f24:	e4a6                	sd	s1,72(sp)
    80003f26:	e0ca                	sd	s2,64(sp)
    80003f28:	fc4e                	sd	s3,56(sp)
    80003f2a:	f852                	sd	s4,48(sp)
    80003f2c:	f456                	sd	s5,40(sp)
    80003f2e:	f05a                	sd	s6,32(sp)
    80003f30:	ec5e                	sd	s7,24(sp)
    80003f32:	e862                	sd	s8,16(sp)
    80003f34:	e466                	sd	s9,8(sp)
    80003f36:	1080                	addi	s0,sp,96
    80003f38:	84aa                	mv	s1,a0
    80003f3a:	8aae                	mv	s5,a1
    80003f3c:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003f3e:	00054703          	lbu	a4,0(a0)
    80003f42:	02f00793          	li	a5,47
    80003f46:	02f70363          	beq	a4,a5,80003f6c <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003f4a:	ffffe097          	auipc	ra,0xffffe
    80003f4e:	d1c080e7          	jalr	-740(ra) # 80001c66 <myproc>
    80003f52:	15053503          	ld	a0,336(a0)
    80003f56:	00000097          	auipc	ra,0x0
    80003f5a:	9f8080e7          	jalr	-1544(ra) # 8000394e <idup>
    80003f5e:	89aa                	mv	s3,a0
  while(*path == '/')
    80003f60:	02f00913          	li	s2,47
  len = path - s;
    80003f64:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80003f66:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003f68:	4b85                	li	s7,1
    80003f6a:	a865                	j	80004022 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003f6c:	4585                	li	a1,1
    80003f6e:	4505                	li	a0,1
    80003f70:	fffff097          	auipc	ra,0xfffff
    80003f74:	6e8080e7          	jalr	1768(ra) # 80003658 <iget>
    80003f78:	89aa                	mv	s3,a0
    80003f7a:	b7dd                	j	80003f60 <namex+0x42>
      iunlockput(ip);
    80003f7c:	854e                	mv	a0,s3
    80003f7e:	00000097          	auipc	ra,0x0
    80003f82:	c70080e7          	jalr	-912(ra) # 80003bee <iunlockput>
      return 0;
    80003f86:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003f88:	854e                	mv	a0,s3
    80003f8a:	60e6                	ld	ra,88(sp)
    80003f8c:	6446                	ld	s0,80(sp)
    80003f8e:	64a6                	ld	s1,72(sp)
    80003f90:	6906                	ld	s2,64(sp)
    80003f92:	79e2                	ld	s3,56(sp)
    80003f94:	7a42                	ld	s4,48(sp)
    80003f96:	7aa2                	ld	s5,40(sp)
    80003f98:	7b02                	ld	s6,32(sp)
    80003f9a:	6be2                	ld	s7,24(sp)
    80003f9c:	6c42                	ld	s8,16(sp)
    80003f9e:	6ca2                	ld	s9,8(sp)
    80003fa0:	6125                	addi	sp,sp,96
    80003fa2:	8082                	ret
      iunlock(ip);
    80003fa4:	854e                	mv	a0,s3
    80003fa6:	00000097          	auipc	ra,0x0
    80003faa:	aa8080e7          	jalr	-1368(ra) # 80003a4e <iunlock>
      return ip;
    80003fae:	bfe9                	j	80003f88 <namex+0x6a>
      iunlockput(ip);
    80003fb0:	854e                	mv	a0,s3
    80003fb2:	00000097          	auipc	ra,0x0
    80003fb6:	c3c080e7          	jalr	-964(ra) # 80003bee <iunlockput>
      return 0;
    80003fba:	89e6                	mv	s3,s9
    80003fbc:	b7f1                	j	80003f88 <namex+0x6a>
  len = path - s;
    80003fbe:	40b48633          	sub	a2,s1,a1
    80003fc2:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003fc6:	099c5463          	bge	s8,s9,8000404e <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003fca:	4639                	li	a2,14
    80003fcc:	8552                	mv	a0,s4
    80003fce:	ffffd097          	auipc	ra,0xffffd
    80003fd2:	ec4080e7          	jalr	-316(ra) # 80000e92 <memmove>
  while(*path == '/')
    80003fd6:	0004c783          	lbu	a5,0(s1)
    80003fda:	01279763          	bne	a5,s2,80003fe8 <namex+0xca>
    path++;
    80003fde:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003fe0:	0004c783          	lbu	a5,0(s1)
    80003fe4:	ff278de3          	beq	a5,s2,80003fde <namex+0xc0>
    ilock(ip);
    80003fe8:	854e                	mv	a0,s3
    80003fea:	00000097          	auipc	ra,0x0
    80003fee:	9a2080e7          	jalr	-1630(ra) # 8000398c <ilock>
    if(ip->type != T_DIR){
    80003ff2:	04499783          	lh	a5,68(s3)
    80003ff6:	f97793e3          	bne	a5,s7,80003f7c <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003ffa:	000a8563          	beqz	s5,80004004 <namex+0xe6>
    80003ffe:	0004c783          	lbu	a5,0(s1)
    80004002:	d3cd                	beqz	a5,80003fa4 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004004:	865a                	mv	a2,s6
    80004006:	85d2                	mv	a1,s4
    80004008:	854e                	mv	a0,s3
    8000400a:	00000097          	auipc	ra,0x0
    8000400e:	e64080e7          	jalr	-412(ra) # 80003e6e <dirlookup>
    80004012:	8caa                	mv	s9,a0
    80004014:	dd51                	beqz	a0,80003fb0 <namex+0x92>
    iunlockput(ip);
    80004016:	854e                	mv	a0,s3
    80004018:	00000097          	auipc	ra,0x0
    8000401c:	bd6080e7          	jalr	-1066(ra) # 80003bee <iunlockput>
    ip = next;
    80004020:	89e6                	mv	s3,s9
  while(*path == '/')
    80004022:	0004c783          	lbu	a5,0(s1)
    80004026:	05279763          	bne	a5,s2,80004074 <namex+0x156>
    path++;
    8000402a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000402c:	0004c783          	lbu	a5,0(s1)
    80004030:	ff278de3          	beq	a5,s2,8000402a <namex+0x10c>
  if(*path == 0)
    80004034:	c79d                	beqz	a5,80004062 <namex+0x144>
    path++;
    80004036:	85a6                	mv	a1,s1
  len = path - s;
    80004038:	8cda                	mv	s9,s6
    8000403a:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    8000403c:	01278963          	beq	a5,s2,8000404e <namex+0x130>
    80004040:	dfbd                	beqz	a5,80003fbe <namex+0xa0>
    path++;
    80004042:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80004044:	0004c783          	lbu	a5,0(s1)
    80004048:	ff279ce3          	bne	a5,s2,80004040 <namex+0x122>
    8000404c:	bf8d                	j	80003fbe <namex+0xa0>
    memmove(name, s, len);
    8000404e:	2601                	sext.w	a2,a2
    80004050:	8552                	mv	a0,s4
    80004052:	ffffd097          	auipc	ra,0xffffd
    80004056:	e40080e7          	jalr	-448(ra) # 80000e92 <memmove>
    name[len] = 0;
    8000405a:	9cd2                	add	s9,s9,s4
    8000405c:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80004060:	bf9d                	j	80003fd6 <namex+0xb8>
  if(nameiparent){
    80004062:	f20a83e3          	beqz	s5,80003f88 <namex+0x6a>
    iput(ip);
    80004066:	854e                	mv	a0,s3
    80004068:	00000097          	auipc	ra,0x0
    8000406c:	ade080e7          	jalr	-1314(ra) # 80003b46 <iput>
    return 0;
    80004070:	4981                	li	s3,0
    80004072:	bf19                	j	80003f88 <namex+0x6a>
  if(*path == 0)
    80004074:	d7fd                	beqz	a5,80004062 <namex+0x144>
  while(*path != '/' && *path != 0)
    80004076:	0004c783          	lbu	a5,0(s1)
    8000407a:	85a6                	mv	a1,s1
    8000407c:	b7d1                	j	80004040 <namex+0x122>

000000008000407e <dirlink>:
{
    8000407e:	7139                	addi	sp,sp,-64
    80004080:	fc06                	sd	ra,56(sp)
    80004082:	f822                	sd	s0,48(sp)
    80004084:	f426                	sd	s1,40(sp)
    80004086:	f04a                	sd	s2,32(sp)
    80004088:	ec4e                	sd	s3,24(sp)
    8000408a:	e852                	sd	s4,16(sp)
    8000408c:	0080                	addi	s0,sp,64
    8000408e:	892a                	mv	s2,a0
    80004090:	8a2e                	mv	s4,a1
    80004092:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004094:	4601                	li	a2,0
    80004096:	00000097          	auipc	ra,0x0
    8000409a:	dd8080e7          	jalr	-552(ra) # 80003e6e <dirlookup>
    8000409e:	e93d                	bnez	a0,80004114 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800040a0:	04c92483          	lw	s1,76(s2)
    800040a4:	c49d                	beqz	s1,800040d2 <dirlink+0x54>
    800040a6:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800040a8:	4741                	li	a4,16
    800040aa:	86a6                	mv	a3,s1
    800040ac:	fc040613          	addi	a2,s0,-64
    800040b0:	4581                	li	a1,0
    800040b2:	854a                	mv	a0,s2
    800040b4:	00000097          	auipc	ra,0x0
    800040b8:	b8c080e7          	jalr	-1140(ra) # 80003c40 <readi>
    800040bc:	47c1                	li	a5,16
    800040be:	06f51163          	bne	a0,a5,80004120 <dirlink+0xa2>
    if(de.inum == 0)
    800040c2:	fc045783          	lhu	a5,-64(s0)
    800040c6:	c791                	beqz	a5,800040d2 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800040c8:	24c1                	addiw	s1,s1,16
    800040ca:	04c92783          	lw	a5,76(s2)
    800040ce:	fcf4ede3          	bltu	s1,a5,800040a8 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800040d2:	4639                	li	a2,14
    800040d4:	85d2                	mv	a1,s4
    800040d6:	fc240513          	addi	a0,s0,-62
    800040da:	ffffd097          	auipc	ra,0xffffd
    800040de:	e70080e7          	jalr	-400(ra) # 80000f4a <strncpy>
  de.inum = inum;
    800040e2:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800040e6:	4741                	li	a4,16
    800040e8:	86a6                	mv	a3,s1
    800040ea:	fc040613          	addi	a2,s0,-64
    800040ee:	4581                	li	a1,0
    800040f0:	854a                	mv	a0,s2
    800040f2:	00000097          	auipc	ra,0x0
    800040f6:	c46080e7          	jalr	-954(ra) # 80003d38 <writei>
    800040fa:	872a                	mv	a4,a0
    800040fc:	47c1                	li	a5,16
  return 0;
    800040fe:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004100:	02f71863          	bne	a4,a5,80004130 <dirlink+0xb2>
}
    80004104:	70e2                	ld	ra,56(sp)
    80004106:	7442                	ld	s0,48(sp)
    80004108:	74a2                	ld	s1,40(sp)
    8000410a:	7902                	ld	s2,32(sp)
    8000410c:	69e2                	ld	s3,24(sp)
    8000410e:	6a42                	ld	s4,16(sp)
    80004110:	6121                	addi	sp,sp,64
    80004112:	8082                	ret
    iput(ip);
    80004114:	00000097          	auipc	ra,0x0
    80004118:	a32080e7          	jalr	-1486(ra) # 80003b46 <iput>
    return -1;
    8000411c:	557d                	li	a0,-1
    8000411e:	b7dd                	j	80004104 <dirlink+0x86>
      panic("dirlink read");
    80004120:	00004517          	auipc	a0,0x4
    80004124:	55850513          	addi	a0,a0,1368 # 80008678 <syscalls+0x1e0>
    80004128:	ffffc097          	auipc	ra,0xffffc
    8000412c:	4bc080e7          	jalr	1212(ra) # 800005e4 <panic>
    panic("dirlink");
    80004130:	00004517          	auipc	a0,0x4
    80004134:	66850513          	addi	a0,a0,1640 # 80008798 <syscalls+0x300>
    80004138:	ffffc097          	auipc	ra,0xffffc
    8000413c:	4ac080e7          	jalr	1196(ra) # 800005e4 <panic>

0000000080004140 <namei>:

struct inode*
namei(char *path)
{
    80004140:	1101                	addi	sp,sp,-32
    80004142:	ec06                	sd	ra,24(sp)
    80004144:	e822                	sd	s0,16(sp)
    80004146:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004148:	fe040613          	addi	a2,s0,-32
    8000414c:	4581                	li	a1,0
    8000414e:	00000097          	auipc	ra,0x0
    80004152:	dd0080e7          	jalr	-560(ra) # 80003f1e <namex>
}
    80004156:	60e2                	ld	ra,24(sp)
    80004158:	6442                	ld	s0,16(sp)
    8000415a:	6105                	addi	sp,sp,32
    8000415c:	8082                	ret

000000008000415e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000415e:	1141                	addi	sp,sp,-16
    80004160:	e406                	sd	ra,8(sp)
    80004162:	e022                	sd	s0,0(sp)
    80004164:	0800                	addi	s0,sp,16
    80004166:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004168:	4585                	li	a1,1
    8000416a:	00000097          	auipc	ra,0x0
    8000416e:	db4080e7          	jalr	-588(ra) # 80003f1e <namex>
}
    80004172:	60a2                	ld	ra,8(sp)
    80004174:	6402                	ld	s0,0(sp)
    80004176:	0141                	addi	sp,sp,16
    80004178:	8082                	ret

000000008000417a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000417a:	1101                	addi	sp,sp,-32
    8000417c:	ec06                	sd	ra,24(sp)
    8000417e:	e822                	sd	s0,16(sp)
    80004180:	e426                	sd	s1,8(sp)
    80004182:	e04a                	sd	s2,0(sp)
    80004184:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004186:	0003d917          	auipc	s2,0x3d
    8000418a:	79290913          	addi	s2,s2,1938 # 80041918 <log>
    8000418e:	01892583          	lw	a1,24(s2)
    80004192:	02892503          	lw	a0,40(s2)
    80004196:	fffff097          	auipc	ra,0xfffff
    8000419a:	ff4080e7          	jalr	-12(ra) # 8000318a <bread>
    8000419e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800041a0:	02c92683          	lw	a3,44(s2)
    800041a4:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800041a6:	02d05763          	blez	a3,800041d4 <write_head+0x5a>
    800041aa:	0003d797          	auipc	a5,0x3d
    800041ae:	79e78793          	addi	a5,a5,1950 # 80041948 <log+0x30>
    800041b2:	05c50713          	addi	a4,a0,92
    800041b6:	36fd                	addiw	a3,a3,-1
    800041b8:	1682                	slli	a3,a3,0x20
    800041ba:	9281                	srli	a3,a3,0x20
    800041bc:	068a                	slli	a3,a3,0x2
    800041be:	0003d617          	auipc	a2,0x3d
    800041c2:	78e60613          	addi	a2,a2,1934 # 8004194c <log+0x34>
    800041c6:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800041c8:	4390                	lw	a2,0(a5)
    800041ca:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800041cc:	0791                	addi	a5,a5,4
    800041ce:	0711                	addi	a4,a4,4
    800041d0:	fed79ce3          	bne	a5,a3,800041c8 <write_head+0x4e>
  }
  bwrite(buf);
    800041d4:	8526                	mv	a0,s1
    800041d6:	fffff097          	auipc	ra,0xfffff
    800041da:	0a6080e7          	jalr	166(ra) # 8000327c <bwrite>
  brelse(buf);
    800041de:	8526                	mv	a0,s1
    800041e0:	fffff097          	auipc	ra,0xfffff
    800041e4:	0da080e7          	jalr	218(ra) # 800032ba <brelse>
}
    800041e8:	60e2                	ld	ra,24(sp)
    800041ea:	6442                	ld	s0,16(sp)
    800041ec:	64a2                	ld	s1,8(sp)
    800041ee:	6902                	ld	s2,0(sp)
    800041f0:	6105                	addi	sp,sp,32
    800041f2:	8082                	ret

00000000800041f4 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800041f4:	0003d797          	auipc	a5,0x3d
    800041f8:	7507a783          	lw	a5,1872(a5) # 80041944 <log+0x2c>
    800041fc:	0af05663          	blez	a5,800042a8 <install_trans+0xb4>
{
    80004200:	7139                	addi	sp,sp,-64
    80004202:	fc06                	sd	ra,56(sp)
    80004204:	f822                	sd	s0,48(sp)
    80004206:	f426                	sd	s1,40(sp)
    80004208:	f04a                	sd	s2,32(sp)
    8000420a:	ec4e                	sd	s3,24(sp)
    8000420c:	e852                	sd	s4,16(sp)
    8000420e:	e456                	sd	s5,8(sp)
    80004210:	0080                	addi	s0,sp,64
    80004212:	0003da97          	auipc	s5,0x3d
    80004216:	736a8a93          	addi	s5,s5,1846 # 80041948 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000421a:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000421c:	0003d997          	auipc	s3,0x3d
    80004220:	6fc98993          	addi	s3,s3,1788 # 80041918 <log>
    80004224:	0189a583          	lw	a1,24(s3)
    80004228:	014585bb          	addw	a1,a1,s4
    8000422c:	2585                	addiw	a1,a1,1
    8000422e:	0289a503          	lw	a0,40(s3)
    80004232:	fffff097          	auipc	ra,0xfffff
    80004236:	f58080e7          	jalr	-168(ra) # 8000318a <bread>
    8000423a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000423c:	000aa583          	lw	a1,0(s5)
    80004240:	0289a503          	lw	a0,40(s3)
    80004244:	fffff097          	auipc	ra,0xfffff
    80004248:	f46080e7          	jalr	-186(ra) # 8000318a <bread>
    8000424c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000424e:	40000613          	li	a2,1024
    80004252:	05890593          	addi	a1,s2,88
    80004256:	05850513          	addi	a0,a0,88
    8000425a:	ffffd097          	auipc	ra,0xffffd
    8000425e:	c38080e7          	jalr	-968(ra) # 80000e92 <memmove>
    bwrite(dbuf);  // write dst to disk
    80004262:	8526                	mv	a0,s1
    80004264:	fffff097          	auipc	ra,0xfffff
    80004268:	018080e7          	jalr	24(ra) # 8000327c <bwrite>
    bunpin(dbuf);
    8000426c:	8526                	mv	a0,s1
    8000426e:	fffff097          	auipc	ra,0xfffff
    80004272:	126080e7          	jalr	294(ra) # 80003394 <bunpin>
    brelse(lbuf);
    80004276:	854a                	mv	a0,s2
    80004278:	fffff097          	auipc	ra,0xfffff
    8000427c:	042080e7          	jalr	66(ra) # 800032ba <brelse>
    brelse(dbuf);
    80004280:	8526                	mv	a0,s1
    80004282:	fffff097          	auipc	ra,0xfffff
    80004286:	038080e7          	jalr	56(ra) # 800032ba <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000428a:	2a05                	addiw	s4,s4,1
    8000428c:	0a91                	addi	s5,s5,4
    8000428e:	02c9a783          	lw	a5,44(s3)
    80004292:	f8fa49e3          	blt	s4,a5,80004224 <install_trans+0x30>
}
    80004296:	70e2                	ld	ra,56(sp)
    80004298:	7442                	ld	s0,48(sp)
    8000429a:	74a2                	ld	s1,40(sp)
    8000429c:	7902                	ld	s2,32(sp)
    8000429e:	69e2                	ld	s3,24(sp)
    800042a0:	6a42                	ld	s4,16(sp)
    800042a2:	6aa2                	ld	s5,8(sp)
    800042a4:	6121                	addi	sp,sp,64
    800042a6:	8082                	ret
    800042a8:	8082                	ret

00000000800042aa <initlog>:
{
    800042aa:	7179                	addi	sp,sp,-48
    800042ac:	f406                	sd	ra,40(sp)
    800042ae:	f022                	sd	s0,32(sp)
    800042b0:	ec26                	sd	s1,24(sp)
    800042b2:	e84a                	sd	s2,16(sp)
    800042b4:	e44e                	sd	s3,8(sp)
    800042b6:	1800                	addi	s0,sp,48
    800042b8:	892a                	mv	s2,a0
    800042ba:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800042bc:	0003d497          	auipc	s1,0x3d
    800042c0:	65c48493          	addi	s1,s1,1628 # 80041918 <log>
    800042c4:	00004597          	auipc	a1,0x4
    800042c8:	3c458593          	addi	a1,a1,964 # 80008688 <syscalls+0x1f0>
    800042cc:	8526                	mv	a0,s1
    800042ce:	ffffd097          	auipc	ra,0xffffd
    800042d2:	9dc080e7          	jalr	-1572(ra) # 80000caa <initlock>
  log.start = sb->logstart;
    800042d6:	0149a583          	lw	a1,20(s3)
    800042da:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800042dc:	0109a783          	lw	a5,16(s3)
    800042e0:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800042e2:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800042e6:	854a                	mv	a0,s2
    800042e8:	fffff097          	auipc	ra,0xfffff
    800042ec:	ea2080e7          	jalr	-350(ra) # 8000318a <bread>
  log.lh.n = lh->n;
    800042f0:	4d34                	lw	a3,88(a0)
    800042f2:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800042f4:	02d05563          	blez	a3,8000431e <initlog+0x74>
    800042f8:	05c50793          	addi	a5,a0,92
    800042fc:	0003d717          	auipc	a4,0x3d
    80004300:	64c70713          	addi	a4,a4,1612 # 80041948 <log+0x30>
    80004304:	36fd                	addiw	a3,a3,-1
    80004306:	1682                	slli	a3,a3,0x20
    80004308:	9281                	srli	a3,a3,0x20
    8000430a:	068a                	slli	a3,a3,0x2
    8000430c:	06050613          	addi	a2,a0,96
    80004310:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80004312:	4390                	lw	a2,0(a5)
    80004314:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004316:	0791                	addi	a5,a5,4
    80004318:	0711                	addi	a4,a4,4
    8000431a:	fed79ce3          	bne	a5,a3,80004312 <initlog+0x68>
  brelse(buf);
    8000431e:	fffff097          	auipc	ra,0xfffff
    80004322:	f9c080e7          	jalr	-100(ra) # 800032ba <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
    80004326:	00000097          	auipc	ra,0x0
    8000432a:	ece080e7          	jalr	-306(ra) # 800041f4 <install_trans>
  log.lh.n = 0;
    8000432e:	0003d797          	auipc	a5,0x3d
    80004332:	6007ab23          	sw	zero,1558(a5) # 80041944 <log+0x2c>
  write_head(); // clear the log
    80004336:	00000097          	auipc	ra,0x0
    8000433a:	e44080e7          	jalr	-444(ra) # 8000417a <write_head>
}
    8000433e:	70a2                	ld	ra,40(sp)
    80004340:	7402                	ld	s0,32(sp)
    80004342:	64e2                	ld	s1,24(sp)
    80004344:	6942                	ld	s2,16(sp)
    80004346:	69a2                	ld	s3,8(sp)
    80004348:	6145                	addi	sp,sp,48
    8000434a:	8082                	ret

000000008000434c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000434c:	1101                	addi	sp,sp,-32
    8000434e:	ec06                	sd	ra,24(sp)
    80004350:	e822                	sd	s0,16(sp)
    80004352:	e426                	sd	s1,8(sp)
    80004354:	e04a                	sd	s2,0(sp)
    80004356:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004358:	0003d517          	auipc	a0,0x3d
    8000435c:	5c050513          	addi	a0,a0,1472 # 80041918 <log>
    80004360:	ffffd097          	auipc	ra,0xffffd
    80004364:	9da080e7          	jalr	-1574(ra) # 80000d3a <acquire>
  while(1){
    if(log.committing){
    80004368:	0003d497          	auipc	s1,0x3d
    8000436c:	5b048493          	addi	s1,s1,1456 # 80041918 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004370:	4979                	li	s2,30
    80004372:	a039                	j	80004380 <begin_op+0x34>
      sleep(&log, &log.lock);
    80004374:	85a6                	mv	a1,s1
    80004376:	8526                	mv	a0,s1
    80004378:	ffffe097          	auipc	ra,0xffffe
    8000437c:	102080e7          	jalr	258(ra) # 8000247a <sleep>
    if(log.committing){
    80004380:	50dc                	lw	a5,36(s1)
    80004382:	fbed                	bnez	a5,80004374 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004384:	509c                	lw	a5,32(s1)
    80004386:	0017871b          	addiw	a4,a5,1
    8000438a:	0007069b          	sext.w	a3,a4
    8000438e:	0027179b          	slliw	a5,a4,0x2
    80004392:	9fb9                	addw	a5,a5,a4
    80004394:	0017979b          	slliw	a5,a5,0x1
    80004398:	54d8                	lw	a4,44(s1)
    8000439a:	9fb9                	addw	a5,a5,a4
    8000439c:	00f95963          	bge	s2,a5,800043ae <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800043a0:	85a6                	mv	a1,s1
    800043a2:	8526                	mv	a0,s1
    800043a4:	ffffe097          	auipc	ra,0xffffe
    800043a8:	0d6080e7          	jalr	214(ra) # 8000247a <sleep>
    800043ac:	bfd1                	j	80004380 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800043ae:	0003d517          	auipc	a0,0x3d
    800043b2:	56a50513          	addi	a0,a0,1386 # 80041918 <log>
    800043b6:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800043b8:	ffffd097          	auipc	ra,0xffffd
    800043bc:	a36080e7          	jalr	-1482(ra) # 80000dee <release>
      break;
    }
  }
}
    800043c0:	60e2                	ld	ra,24(sp)
    800043c2:	6442                	ld	s0,16(sp)
    800043c4:	64a2                	ld	s1,8(sp)
    800043c6:	6902                	ld	s2,0(sp)
    800043c8:	6105                	addi	sp,sp,32
    800043ca:	8082                	ret

00000000800043cc <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800043cc:	7139                	addi	sp,sp,-64
    800043ce:	fc06                	sd	ra,56(sp)
    800043d0:	f822                	sd	s0,48(sp)
    800043d2:	f426                	sd	s1,40(sp)
    800043d4:	f04a                	sd	s2,32(sp)
    800043d6:	ec4e                	sd	s3,24(sp)
    800043d8:	e852                	sd	s4,16(sp)
    800043da:	e456                	sd	s5,8(sp)
    800043dc:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800043de:	0003d497          	auipc	s1,0x3d
    800043e2:	53a48493          	addi	s1,s1,1338 # 80041918 <log>
    800043e6:	8526                	mv	a0,s1
    800043e8:	ffffd097          	auipc	ra,0xffffd
    800043ec:	952080e7          	jalr	-1710(ra) # 80000d3a <acquire>
  log.outstanding -= 1;
    800043f0:	509c                	lw	a5,32(s1)
    800043f2:	37fd                	addiw	a5,a5,-1
    800043f4:	0007891b          	sext.w	s2,a5
    800043f8:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800043fa:	50dc                	lw	a5,36(s1)
    800043fc:	e7b9                	bnez	a5,8000444a <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800043fe:	04091e63          	bnez	s2,8000445a <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004402:	0003d497          	auipc	s1,0x3d
    80004406:	51648493          	addi	s1,s1,1302 # 80041918 <log>
    8000440a:	4785                	li	a5,1
    8000440c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000440e:	8526                	mv	a0,s1
    80004410:	ffffd097          	auipc	ra,0xffffd
    80004414:	9de080e7          	jalr	-1570(ra) # 80000dee <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004418:	54dc                	lw	a5,44(s1)
    8000441a:	06f04763          	bgtz	a5,80004488 <end_op+0xbc>
    acquire(&log.lock);
    8000441e:	0003d497          	auipc	s1,0x3d
    80004422:	4fa48493          	addi	s1,s1,1274 # 80041918 <log>
    80004426:	8526                	mv	a0,s1
    80004428:	ffffd097          	auipc	ra,0xffffd
    8000442c:	912080e7          	jalr	-1774(ra) # 80000d3a <acquire>
    log.committing = 0;
    80004430:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004434:	8526                	mv	a0,s1
    80004436:	ffffe097          	auipc	ra,0xffffe
    8000443a:	1c4080e7          	jalr	452(ra) # 800025fa <wakeup>
    release(&log.lock);
    8000443e:	8526                	mv	a0,s1
    80004440:	ffffd097          	auipc	ra,0xffffd
    80004444:	9ae080e7          	jalr	-1618(ra) # 80000dee <release>
}
    80004448:	a03d                	j	80004476 <end_op+0xaa>
    panic("log.committing");
    8000444a:	00004517          	auipc	a0,0x4
    8000444e:	24650513          	addi	a0,a0,582 # 80008690 <syscalls+0x1f8>
    80004452:	ffffc097          	auipc	ra,0xffffc
    80004456:	192080e7          	jalr	402(ra) # 800005e4 <panic>
    wakeup(&log);
    8000445a:	0003d497          	auipc	s1,0x3d
    8000445e:	4be48493          	addi	s1,s1,1214 # 80041918 <log>
    80004462:	8526                	mv	a0,s1
    80004464:	ffffe097          	auipc	ra,0xffffe
    80004468:	196080e7          	jalr	406(ra) # 800025fa <wakeup>
  release(&log.lock);
    8000446c:	8526                	mv	a0,s1
    8000446e:	ffffd097          	auipc	ra,0xffffd
    80004472:	980080e7          	jalr	-1664(ra) # 80000dee <release>
}
    80004476:	70e2                	ld	ra,56(sp)
    80004478:	7442                	ld	s0,48(sp)
    8000447a:	74a2                	ld	s1,40(sp)
    8000447c:	7902                	ld	s2,32(sp)
    8000447e:	69e2                	ld	s3,24(sp)
    80004480:	6a42                	ld	s4,16(sp)
    80004482:	6aa2                	ld	s5,8(sp)
    80004484:	6121                	addi	sp,sp,64
    80004486:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80004488:	0003da97          	auipc	s5,0x3d
    8000448c:	4c0a8a93          	addi	s5,s5,1216 # 80041948 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004490:	0003da17          	auipc	s4,0x3d
    80004494:	488a0a13          	addi	s4,s4,1160 # 80041918 <log>
    80004498:	018a2583          	lw	a1,24(s4)
    8000449c:	012585bb          	addw	a1,a1,s2
    800044a0:	2585                	addiw	a1,a1,1
    800044a2:	028a2503          	lw	a0,40(s4)
    800044a6:	fffff097          	auipc	ra,0xfffff
    800044aa:	ce4080e7          	jalr	-796(ra) # 8000318a <bread>
    800044ae:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800044b0:	000aa583          	lw	a1,0(s5)
    800044b4:	028a2503          	lw	a0,40(s4)
    800044b8:	fffff097          	auipc	ra,0xfffff
    800044bc:	cd2080e7          	jalr	-814(ra) # 8000318a <bread>
    800044c0:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800044c2:	40000613          	li	a2,1024
    800044c6:	05850593          	addi	a1,a0,88
    800044ca:	05848513          	addi	a0,s1,88
    800044ce:	ffffd097          	auipc	ra,0xffffd
    800044d2:	9c4080e7          	jalr	-1596(ra) # 80000e92 <memmove>
    bwrite(to);  // write the log
    800044d6:	8526                	mv	a0,s1
    800044d8:	fffff097          	auipc	ra,0xfffff
    800044dc:	da4080e7          	jalr	-604(ra) # 8000327c <bwrite>
    brelse(from);
    800044e0:	854e                	mv	a0,s3
    800044e2:	fffff097          	auipc	ra,0xfffff
    800044e6:	dd8080e7          	jalr	-552(ra) # 800032ba <brelse>
    brelse(to);
    800044ea:	8526                	mv	a0,s1
    800044ec:	fffff097          	auipc	ra,0xfffff
    800044f0:	dce080e7          	jalr	-562(ra) # 800032ba <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800044f4:	2905                	addiw	s2,s2,1
    800044f6:	0a91                	addi	s5,s5,4
    800044f8:	02ca2783          	lw	a5,44(s4)
    800044fc:	f8f94ee3          	blt	s2,a5,80004498 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004500:	00000097          	auipc	ra,0x0
    80004504:	c7a080e7          	jalr	-902(ra) # 8000417a <write_head>
    install_trans(); // Now install writes to home locations
    80004508:	00000097          	auipc	ra,0x0
    8000450c:	cec080e7          	jalr	-788(ra) # 800041f4 <install_trans>
    log.lh.n = 0;
    80004510:	0003d797          	auipc	a5,0x3d
    80004514:	4207aa23          	sw	zero,1076(a5) # 80041944 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004518:	00000097          	auipc	ra,0x0
    8000451c:	c62080e7          	jalr	-926(ra) # 8000417a <write_head>
    80004520:	bdfd                	j	8000441e <end_op+0x52>

0000000080004522 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004522:	1101                	addi	sp,sp,-32
    80004524:	ec06                	sd	ra,24(sp)
    80004526:	e822                	sd	s0,16(sp)
    80004528:	e426                	sd	s1,8(sp)
    8000452a:	e04a                	sd	s2,0(sp)
    8000452c:	1000                	addi	s0,sp,32
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000452e:	0003d717          	auipc	a4,0x3d
    80004532:	41672703          	lw	a4,1046(a4) # 80041944 <log+0x2c>
    80004536:	47f5                	li	a5,29
    80004538:	08e7c063          	blt	a5,a4,800045b8 <log_write+0x96>
    8000453c:	84aa                	mv	s1,a0
    8000453e:	0003d797          	auipc	a5,0x3d
    80004542:	3f67a783          	lw	a5,1014(a5) # 80041934 <log+0x1c>
    80004546:	37fd                	addiw	a5,a5,-1
    80004548:	06f75863          	bge	a4,a5,800045b8 <log_write+0x96>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000454c:	0003d797          	auipc	a5,0x3d
    80004550:	3ec7a783          	lw	a5,1004(a5) # 80041938 <log+0x20>
    80004554:	06f05a63          	blez	a5,800045c8 <log_write+0xa6>
    panic("log_write outside of trans");

  acquire(&log.lock);
    80004558:	0003d917          	auipc	s2,0x3d
    8000455c:	3c090913          	addi	s2,s2,960 # 80041918 <log>
    80004560:	854a                	mv	a0,s2
    80004562:	ffffc097          	auipc	ra,0xffffc
    80004566:	7d8080e7          	jalr	2008(ra) # 80000d3a <acquire>
  for (i = 0; i < log.lh.n; i++) {
    8000456a:	02c92603          	lw	a2,44(s2)
    8000456e:	06c05563          	blez	a2,800045d8 <log_write+0xb6>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80004572:	44cc                	lw	a1,12(s1)
    80004574:	0003d717          	auipc	a4,0x3d
    80004578:	3d470713          	addi	a4,a4,980 # 80041948 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000457c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    8000457e:	4314                	lw	a3,0(a4)
    80004580:	04b68d63          	beq	a3,a1,800045da <log_write+0xb8>
  for (i = 0; i < log.lh.n; i++) {
    80004584:	2785                	addiw	a5,a5,1
    80004586:	0711                	addi	a4,a4,4
    80004588:	fec79be3          	bne	a5,a2,8000457e <log_write+0x5c>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000458c:	0621                	addi	a2,a2,8
    8000458e:	060a                	slli	a2,a2,0x2
    80004590:	0003d797          	auipc	a5,0x3d
    80004594:	38878793          	addi	a5,a5,904 # 80041918 <log>
    80004598:	963e                	add	a2,a2,a5
    8000459a:	44dc                	lw	a5,12(s1)
    8000459c:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000459e:	8526                	mv	a0,s1
    800045a0:	fffff097          	auipc	ra,0xfffff
    800045a4:	db8080e7          	jalr	-584(ra) # 80003358 <bpin>
    log.lh.n++;
    800045a8:	0003d717          	auipc	a4,0x3d
    800045ac:	37070713          	addi	a4,a4,880 # 80041918 <log>
    800045b0:	575c                	lw	a5,44(a4)
    800045b2:	2785                	addiw	a5,a5,1
    800045b4:	d75c                	sw	a5,44(a4)
    800045b6:	a83d                	j	800045f4 <log_write+0xd2>
    panic("too big a transaction");
    800045b8:	00004517          	auipc	a0,0x4
    800045bc:	0e850513          	addi	a0,a0,232 # 800086a0 <syscalls+0x208>
    800045c0:	ffffc097          	auipc	ra,0xffffc
    800045c4:	024080e7          	jalr	36(ra) # 800005e4 <panic>
    panic("log_write outside of trans");
    800045c8:	00004517          	auipc	a0,0x4
    800045cc:	0f050513          	addi	a0,a0,240 # 800086b8 <syscalls+0x220>
    800045d0:	ffffc097          	auipc	ra,0xffffc
    800045d4:	014080e7          	jalr	20(ra) # 800005e4 <panic>
  for (i = 0; i < log.lh.n; i++) {
    800045d8:	4781                	li	a5,0
  log.lh.block[i] = b->blockno;
    800045da:	00878713          	addi	a4,a5,8
    800045de:	00271693          	slli	a3,a4,0x2
    800045e2:	0003d717          	auipc	a4,0x3d
    800045e6:	33670713          	addi	a4,a4,822 # 80041918 <log>
    800045ea:	9736                	add	a4,a4,a3
    800045ec:	44d4                	lw	a3,12(s1)
    800045ee:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800045f0:	faf607e3          	beq	a2,a5,8000459e <log_write+0x7c>
  }
  release(&log.lock);
    800045f4:	0003d517          	auipc	a0,0x3d
    800045f8:	32450513          	addi	a0,a0,804 # 80041918 <log>
    800045fc:	ffffc097          	auipc	ra,0xffffc
    80004600:	7f2080e7          	jalr	2034(ra) # 80000dee <release>
}
    80004604:	60e2                	ld	ra,24(sp)
    80004606:	6442                	ld	s0,16(sp)
    80004608:	64a2                	ld	s1,8(sp)
    8000460a:	6902                	ld	s2,0(sp)
    8000460c:	6105                	addi	sp,sp,32
    8000460e:	8082                	ret

0000000080004610 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004610:	1101                	addi	sp,sp,-32
    80004612:	ec06                	sd	ra,24(sp)
    80004614:	e822                	sd	s0,16(sp)
    80004616:	e426                	sd	s1,8(sp)
    80004618:	e04a                	sd	s2,0(sp)
    8000461a:	1000                	addi	s0,sp,32
    8000461c:	84aa                	mv	s1,a0
    8000461e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004620:	00004597          	auipc	a1,0x4
    80004624:	0b858593          	addi	a1,a1,184 # 800086d8 <syscalls+0x240>
    80004628:	0521                	addi	a0,a0,8
    8000462a:	ffffc097          	auipc	ra,0xffffc
    8000462e:	680080e7          	jalr	1664(ra) # 80000caa <initlock>
  lk->name = name;
    80004632:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004636:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000463a:	0204a423          	sw	zero,40(s1)
}
    8000463e:	60e2                	ld	ra,24(sp)
    80004640:	6442                	ld	s0,16(sp)
    80004642:	64a2                	ld	s1,8(sp)
    80004644:	6902                	ld	s2,0(sp)
    80004646:	6105                	addi	sp,sp,32
    80004648:	8082                	ret

000000008000464a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000464a:	1101                	addi	sp,sp,-32
    8000464c:	ec06                	sd	ra,24(sp)
    8000464e:	e822                	sd	s0,16(sp)
    80004650:	e426                	sd	s1,8(sp)
    80004652:	e04a                	sd	s2,0(sp)
    80004654:	1000                	addi	s0,sp,32
    80004656:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004658:	00850913          	addi	s2,a0,8
    8000465c:	854a                	mv	a0,s2
    8000465e:	ffffc097          	auipc	ra,0xffffc
    80004662:	6dc080e7          	jalr	1756(ra) # 80000d3a <acquire>
  while (lk->locked) {
    80004666:	409c                	lw	a5,0(s1)
    80004668:	cb89                	beqz	a5,8000467a <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000466a:	85ca                	mv	a1,s2
    8000466c:	8526                	mv	a0,s1
    8000466e:	ffffe097          	auipc	ra,0xffffe
    80004672:	e0c080e7          	jalr	-500(ra) # 8000247a <sleep>
  while (lk->locked) {
    80004676:	409c                	lw	a5,0(s1)
    80004678:	fbed                	bnez	a5,8000466a <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000467a:	4785                	li	a5,1
    8000467c:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000467e:	ffffd097          	auipc	ra,0xffffd
    80004682:	5e8080e7          	jalr	1512(ra) # 80001c66 <myproc>
    80004686:	5d1c                	lw	a5,56(a0)
    80004688:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000468a:	854a                	mv	a0,s2
    8000468c:	ffffc097          	auipc	ra,0xffffc
    80004690:	762080e7          	jalr	1890(ra) # 80000dee <release>
}
    80004694:	60e2                	ld	ra,24(sp)
    80004696:	6442                	ld	s0,16(sp)
    80004698:	64a2                	ld	s1,8(sp)
    8000469a:	6902                	ld	s2,0(sp)
    8000469c:	6105                	addi	sp,sp,32
    8000469e:	8082                	ret

00000000800046a0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800046a0:	1101                	addi	sp,sp,-32
    800046a2:	ec06                	sd	ra,24(sp)
    800046a4:	e822                	sd	s0,16(sp)
    800046a6:	e426                	sd	s1,8(sp)
    800046a8:	e04a                	sd	s2,0(sp)
    800046aa:	1000                	addi	s0,sp,32
    800046ac:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800046ae:	00850913          	addi	s2,a0,8
    800046b2:	854a                	mv	a0,s2
    800046b4:	ffffc097          	auipc	ra,0xffffc
    800046b8:	686080e7          	jalr	1670(ra) # 80000d3a <acquire>
  lk->locked = 0;
    800046bc:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800046c0:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800046c4:	8526                	mv	a0,s1
    800046c6:	ffffe097          	auipc	ra,0xffffe
    800046ca:	f34080e7          	jalr	-204(ra) # 800025fa <wakeup>
  release(&lk->lk);
    800046ce:	854a                	mv	a0,s2
    800046d0:	ffffc097          	auipc	ra,0xffffc
    800046d4:	71e080e7          	jalr	1822(ra) # 80000dee <release>
}
    800046d8:	60e2                	ld	ra,24(sp)
    800046da:	6442                	ld	s0,16(sp)
    800046dc:	64a2                	ld	s1,8(sp)
    800046de:	6902                	ld	s2,0(sp)
    800046e0:	6105                	addi	sp,sp,32
    800046e2:	8082                	ret

00000000800046e4 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800046e4:	7179                	addi	sp,sp,-48
    800046e6:	f406                	sd	ra,40(sp)
    800046e8:	f022                	sd	s0,32(sp)
    800046ea:	ec26                	sd	s1,24(sp)
    800046ec:	e84a                	sd	s2,16(sp)
    800046ee:	e44e                	sd	s3,8(sp)
    800046f0:	1800                	addi	s0,sp,48
    800046f2:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800046f4:	00850913          	addi	s2,a0,8
    800046f8:	854a                	mv	a0,s2
    800046fa:	ffffc097          	auipc	ra,0xffffc
    800046fe:	640080e7          	jalr	1600(ra) # 80000d3a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004702:	409c                	lw	a5,0(s1)
    80004704:	ef99                	bnez	a5,80004722 <holdingsleep+0x3e>
    80004706:	4481                	li	s1,0
  release(&lk->lk);
    80004708:	854a                	mv	a0,s2
    8000470a:	ffffc097          	auipc	ra,0xffffc
    8000470e:	6e4080e7          	jalr	1764(ra) # 80000dee <release>
  return r;
}
    80004712:	8526                	mv	a0,s1
    80004714:	70a2                	ld	ra,40(sp)
    80004716:	7402                	ld	s0,32(sp)
    80004718:	64e2                	ld	s1,24(sp)
    8000471a:	6942                	ld	s2,16(sp)
    8000471c:	69a2                	ld	s3,8(sp)
    8000471e:	6145                	addi	sp,sp,48
    80004720:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004722:	0284a983          	lw	s3,40(s1)
    80004726:	ffffd097          	auipc	ra,0xffffd
    8000472a:	540080e7          	jalr	1344(ra) # 80001c66 <myproc>
    8000472e:	5d04                	lw	s1,56(a0)
    80004730:	413484b3          	sub	s1,s1,s3
    80004734:	0014b493          	seqz	s1,s1
    80004738:	bfc1                	j	80004708 <holdingsleep+0x24>

000000008000473a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000473a:	1141                	addi	sp,sp,-16
    8000473c:	e406                	sd	ra,8(sp)
    8000473e:	e022                	sd	s0,0(sp)
    80004740:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004742:	00004597          	auipc	a1,0x4
    80004746:	fa658593          	addi	a1,a1,-90 # 800086e8 <syscalls+0x250>
    8000474a:	0003d517          	auipc	a0,0x3d
    8000474e:	31650513          	addi	a0,a0,790 # 80041a60 <ftable>
    80004752:	ffffc097          	auipc	ra,0xffffc
    80004756:	558080e7          	jalr	1368(ra) # 80000caa <initlock>
}
    8000475a:	60a2                	ld	ra,8(sp)
    8000475c:	6402                	ld	s0,0(sp)
    8000475e:	0141                	addi	sp,sp,16
    80004760:	8082                	ret

0000000080004762 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004762:	1101                	addi	sp,sp,-32
    80004764:	ec06                	sd	ra,24(sp)
    80004766:	e822                	sd	s0,16(sp)
    80004768:	e426                	sd	s1,8(sp)
    8000476a:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000476c:	0003d517          	auipc	a0,0x3d
    80004770:	2f450513          	addi	a0,a0,756 # 80041a60 <ftable>
    80004774:	ffffc097          	auipc	ra,0xffffc
    80004778:	5c6080e7          	jalr	1478(ra) # 80000d3a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000477c:	0003d497          	auipc	s1,0x3d
    80004780:	2fc48493          	addi	s1,s1,764 # 80041a78 <ftable+0x18>
    80004784:	0003e717          	auipc	a4,0x3e
    80004788:	29470713          	addi	a4,a4,660 # 80042a18 <ftable+0xfb8>
    if(f->ref == 0){
    8000478c:	40dc                	lw	a5,4(s1)
    8000478e:	cf99                	beqz	a5,800047ac <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004790:	02848493          	addi	s1,s1,40
    80004794:	fee49ce3          	bne	s1,a4,8000478c <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004798:	0003d517          	auipc	a0,0x3d
    8000479c:	2c850513          	addi	a0,a0,712 # 80041a60 <ftable>
    800047a0:	ffffc097          	auipc	ra,0xffffc
    800047a4:	64e080e7          	jalr	1614(ra) # 80000dee <release>
  return 0;
    800047a8:	4481                	li	s1,0
    800047aa:	a819                	j	800047c0 <filealloc+0x5e>
      f->ref = 1;
    800047ac:	4785                	li	a5,1
    800047ae:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800047b0:	0003d517          	auipc	a0,0x3d
    800047b4:	2b050513          	addi	a0,a0,688 # 80041a60 <ftable>
    800047b8:	ffffc097          	auipc	ra,0xffffc
    800047bc:	636080e7          	jalr	1590(ra) # 80000dee <release>
}
    800047c0:	8526                	mv	a0,s1
    800047c2:	60e2                	ld	ra,24(sp)
    800047c4:	6442                	ld	s0,16(sp)
    800047c6:	64a2                	ld	s1,8(sp)
    800047c8:	6105                	addi	sp,sp,32
    800047ca:	8082                	ret

00000000800047cc <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800047cc:	1101                	addi	sp,sp,-32
    800047ce:	ec06                	sd	ra,24(sp)
    800047d0:	e822                	sd	s0,16(sp)
    800047d2:	e426                	sd	s1,8(sp)
    800047d4:	1000                	addi	s0,sp,32
    800047d6:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800047d8:	0003d517          	auipc	a0,0x3d
    800047dc:	28850513          	addi	a0,a0,648 # 80041a60 <ftable>
    800047e0:	ffffc097          	auipc	ra,0xffffc
    800047e4:	55a080e7          	jalr	1370(ra) # 80000d3a <acquire>
  if(f->ref < 1)
    800047e8:	40dc                	lw	a5,4(s1)
    800047ea:	02f05263          	blez	a5,8000480e <filedup+0x42>
    panic("filedup");
  f->ref++;
    800047ee:	2785                	addiw	a5,a5,1
    800047f0:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800047f2:	0003d517          	auipc	a0,0x3d
    800047f6:	26e50513          	addi	a0,a0,622 # 80041a60 <ftable>
    800047fa:	ffffc097          	auipc	ra,0xffffc
    800047fe:	5f4080e7          	jalr	1524(ra) # 80000dee <release>
  return f;
}
    80004802:	8526                	mv	a0,s1
    80004804:	60e2                	ld	ra,24(sp)
    80004806:	6442                	ld	s0,16(sp)
    80004808:	64a2                	ld	s1,8(sp)
    8000480a:	6105                	addi	sp,sp,32
    8000480c:	8082                	ret
    panic("filedup");
    8000480e:	00004517          	auipc	a0,0x4
    80004812:	ee250513          	addi	a0,a0,-286 # 800086f0 <syscalls+0x258>
    80004816:	ffffc097          	auipc	ra,0xffffc
    8000481a:	dce080e7          	jalr	-562(ra) # 800005e4 <panic>

000000008000481e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000481e:	7139                	addi	sp,sp,-64
    80004820:	fc06                	sd	ra,56(sp)
    80004822:	f822                	sd	s0,48(sp)
    80004824:	f426                	sd	s1,40(sp)
    80004826:	f04a                	sd	s2,32(sp)
    80004828:	ec4e                	sd	s3,24(sp)
    8000482a:	e852                	sd	s4,16(sp)
    8000482c:	e456                	sd	s5,8(sp)
    8000482e:	0080                	addi	s0,sp,64
    80004830:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004832:	0003d517          	auipc	a0,0x3d
    80004836:	22e50513          	addi	a0,a0,558 # 80041a60 <ftable>
    8000483a:	ffffc097          	auipc	ra,0xffffc
    8000483e:	500080e7          	jalr	1280(ra) # 80000d3a <acquire>
  if(f->ref < 1)
    80004842:	40dc                	lw	a5,4(s1)
    80004844:	06f05163          	blez	a5,800048a6 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004848:	37fd                	addiw	a5,a5,-1
    8000484a:	0007871b          	sext.w	a4,a5
    8000484e:	c0dc                	sw	a5,4(s1)
    80004850:	06e04363          	bgtz	a4,800048b6 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004854:	0004a903          	lw	s2,0(s1)
    80004858:	0094ca83          	lbu	s5,9(s1)
    8000485c:	0104ba03          	ld	s4,16(s1)
    80004860:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004864:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004868:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000486c:	0003d517          	auipc	a0,0x3d
    80004870:	1f450513          	addi	a0,a0,500 # 80041a60 <ftable>
    80004874:	ffffc097          	auipc	ra,0xffffc
    80004878:	57a080e7          	jalr	1402(ra) # 80000dee <release>

  if(ff.type == FD_PIPE){
    8000487c:	4785                	li	a5,1
    8000487e:	04f90d63          	beq	s2,a5,800048d8 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004882:	3979                	addiw	s2,s2,-2
    80004884:	4785                	li	a5,1
    80004886:	0527e063          	bltu	a5,s2,800048c6 <fileclose+0xa8>
    begin_op();
    8000488a:	00000097          	auipc	ra,0x0
    8000488e:	ac2080e7          	jalr	-1342(ra) # 8000434c <begin_op>
    iput(ff.ip);
    80004892:	854e                	mv	a0,s3
    80004894:	fffff097          	auipc	ra,0xfffff
    80004898:	2b2080e7          	jalr	690(ra) # 80003b46 <iput>
    end_op();
    8000489c:	00000097          	auipc	ra,0x0
    800048a0:	b30080e7          	jalr	-1232(ra) # 800043cc <end_op>
    800048a4:	a00d                	j	800048c6 <fileclose+0xa8>
    panic("fileclose");
    800048a6:	00004517          	auipc	a0,0x4
    800048aa:	e5250513          	addi	a0,a0,-430 # 800086f8 <syscalls+0x260>
    800048ae:	ffffc097          	auipc	ra,0xffffc
    800048b2:	d36080e7          	jalr	-714(ra) # 800005e4 <panic>
    release(&ftable.lock);
    800048b6:	0003d517          	auipc	a0,0x3d
    800048ba:	1aa50513          	addi	a0,a0,426 # 80041a60 <ftable>
    800048be:	ffffc097          	auipc	ra,0xffffc
    800048c2:	530080e7          	jalr	1328(ra) # 80000dee <release>
  }
}
    800048c6:	70e2                	ld	ra,56(sp)
    800048c8:	7442                	ld	s0,48(sp)
    800048ca:	74a2                	ld	s1,40(sp)
    800048cc:	7902                	ld	s2,32(sp)
    800048ce:	69e2                	ld	s3,24(sp)
    800048d0:	6a42                	ld	s4,16(sp)
    800048d2:	6aa2                	ld	s5,8(sp)
    800048d4:	6121                	addi	sp,sp,64
    800048d6:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800048d8:	85d6                	mv	a1,s5
    800048da:	8552                	mv	a0,s4
    800048dc:	00000097          	auipc	ra,0x0
    800048e0:	372080e7          	jalr	882(ra) # 80004c4e <pipeclose>
    800048e4:	b7cd                	j	800048c6 <fileclose+0xa8>

00000000800048e6 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800048e6:	715d                	addi	sp,sp,-80
    800048e8:	e486                	sd	ra,72(sp)
    800048ea:	e0a2                	sd	s0,64(sp)
    800048ec:	fc26                	sd	s1,56(sp)
    800048ee:	f84a                	sd	s2,48(sp)
    800048f0:	f44e                	sd	s3,40(sp)
    800048f2:	0880                	addi	s0,sp,80
    800048f4:	84aa                	mv	s1,a0
    800048f6:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800048f8:	ffffd097          	auipc	ra,0xffffd
    800048fc:	36e080e7          	jalr	878(ra) # 80001c66 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004900:	409c                	lw	a5,0(s1)
    80004902:	37f9                	addiw	a5,a5,-2
    80004904:	4705                	li	a4,1
    80004906:	04f76763          	bltu	a4,a5,80004954 <filestat+0x6e>
    8000490a:	892a                	mv	s2,a0
    ilock(f->ip);
    8000490c:	6c88                	ld	a0,24(s1)
    8000490e:	fffff097          	auipc	ra,0xfffff
    80004912:	07e080e7          	jalr	126(ra) # 8000398c <ilock>
    stati(f->ip, &st);
    80004916:	fb840593          	addi	a1,s0,-72
    8000491a:	6c88                	ld	a0,24(s1)
    8000491c:	fffff097          	auipc	ra,0xfffff
    80004920:	2fa080e7          	jalr	762(ra) # 80003c16 <stati>
    iunlock(f->ip);
    80004924:	6c88                	ld	a0,24(s1)
    80004926:	fffff097          	auipc	ra,0xfffff
    8000492a:	128080e7          	jalr	296(ra) # 80003a4e <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000492e:	46e1                	li	a3,24
    80004930:	fb840613          	addi	a2,s0,-72
    80004934:	85ce                	mv	a1,s3
    80004936:	05093503          	ld	a0,80(s2)
    8000493a:	ffffd097          	auipc	ra,0xffffd
    8000493e:	0f8080e7          	jalr	248(ra) # 80001a32 <copyout>
    80004942:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004946:	60a6                	ld	ra,72(sp)
    80004948:	6406                	ld	s0,64(sp)
    8000494a:	74e2                	ld	s1,56(sp)
    8000494c:	7942                	ld	s2,48(sp)
    8000494e:	79a2                	ld	s3,40(sp)
    80004950:	6161                	addi	sp,sp,80
    80004952:	8082                	ret
  return -1;
    80004954:	557d                	li	a0,-1
    80004956:	bfc5                	j	80004946 <filestat+0x60>

0000000080004958 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004958:	7179                	addi	sp,sp,-48
    8000495a:	f406                	sd	ra,40(sp)
    8000495c:	f022                	sd	s0,32(sp)
    8000495e:	ec26                	sd	s1,24(sp)
    80004960:	e84a                	sd	s2,16(sp)
    80004962:	e44e                	sd	s3,8(sp)
    80004964:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004966:	00854783          	lbu	a5,8(a0)
    8000496a:	c3d5                	beqz	a5,80004a0e <fileread+0xb6>
    8000496c:	84aa                	mv	s1,a0
    8000496e:	89ae                	mv	s3,a1
    80004970:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004972:	411c                	lw	a5,0(a0)
    80004974:	4705                	li	a4,1
    80004976:	04e78963          	beq	a5,a4,800049c8 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000497a:	470d                	li	a4,3
    8000497c:	04e78d63          	beq	a5,a4,800049d6 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004980:	4709                	li	a4,2
    80004982:	06e79e63          	bne	a5,a4,800049fe <fileread+0xa6>
    ilock(f->ip);
    80004986:	6d08                	ld	a0,24(a0)
    80004988:	fffff097          	auipc	ra,0xfffff
    8000498c:	004080e7          	jalr	4(ra) # 8000398c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004990:	874a                	mv	a4,s2
    80004992:	5094                	lw	a3,32(s1)
    80004994:	864e                	mv	a2,s3
    80004996:	4585                	li	a1,1
    80004998:	6c88                	ld	a0,24(s1)
    8000499a:	fffff097          	auipc	ra,0xfffff
    8000499e:	2a6080e7          	jalr	678(ra) # 80003c40 <readi>
    800049a2:	892a                	mv	s2,a0
    800049a4:	00a05563          	blez	a0,800049ae <fileread+0x56>
      f->off += r;
    800049a8:	509c                	lw	a5,32(s1)
    800049aa:	9fa9                	addw	a5,a5,a0
    800049ac:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800049ae:	6c88                	ld	a0,24(s1)
    800049b0:	fffff097          	auipc	ra,0xfffff
    800049b4:	09e080e7          	jalr	158(ra) # 80003a4e <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    800049b8:	854a                	mv	a0,s2
    800049ba:	70a2                	ld	ra,40(sp)
    800049bc:	7402                	ld	s0,32(sp)
    800049be:	64e2                	ld	s1,24(sp)
    800049c0:	6942                	ld	s2,16(sp)
    800049c2:	69a2                	ld	s3,8(sp)
    800049c4:	6145                	addi	sp,sp,48
    800049c6:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800049c8:	6908                	ld	a0,16(a0)
    800049ca:	00000097          	auipc	ra,0x0
    800049ce:	3f4080e7          	jalr	1012(ra) # 80004dbe <piperead>
    800049d2:	892a                	mv	s2,a0
    800049d4:	b7d5                	j	800049b8 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800049d6:	02451783          	lh	a5,36(a0)
    800049da:	03079693          	slli	a3,a5,0x30
    800049de:	92c1                	srli	a3,a3,0x30
    800049e0:	4725                	li	a4,9
    800049e2:	02d76863          	bltu	a4,a3,80004a12 <fileread+0xba>
    800049e6:	0792                	slli	a5,a5,0x4
    800049e8:	0003d717          	auipc	a4,0x3d
    800049ec:	fd870713          	addi	a4,a4,-40 # 800419c0 <devsw>
    800049f0:	97ba                	add	a5,a5,a4
    800049f2:	639c                	ld	a5,0(a5)
    800049f4:	c38d                	beqz	a5,80004a16 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    800049f6:	4505                	li	a0,1
    800049f8:	9782                	jalr	a5
    800049fa:	892a                	mv	s2,a0
    800049fc:	bf75                	j	800049b8 <fileread+0x60>
    panic("fileread");
    800049fe:	00004517          	auipc	a0,0x4
    80004a02:	d0a50513          	addi	a0,a0,-758 # 80008708 <syscalls+0x270>
    80004a06:	ffffc097          	auipc	ra,0xffffc
    80004a0a:	bde080e7          	jalr	-1058(ra) # 800005e4 <panic>
    return -1;
    80004a0e:	597d                	li	s2,-1
    80004a10:	b765                	j	800049b8 <fileread+0x60>
      return -1;
    80004a12:	597d                	li	s2,-1
    80004a14:	b755                	j	800049b8 <fileread+0x60>
    80004a16:	597d                	li	s2,-1
    80004a18:	b745                	j	800049b8 <fileread+0x60>

0000000080004a1a <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004a1a:	00954783          	lbu	a5,9(a0)
    80004a1e:	14078563          	beqz	a5,80004b68 <filewrite+0x14e>
{
    80004a22:	715d                	addi	sp,sp,-80
    80004a24:	e486                	sd	ra,72(sp)
    80004a26:	e0a2                	sd	s0,64(sp)
    80004a28:	fc26                	sd	s1,56(sp)
    80004a2a:	f84a                	sd	s2,48(sp)
    80004a2c:	f44e                	sd	s3,40(sp)
    80004a2e:	f052                	sd	s4,32(sp)
    80004a30:	ec56                	sd	s5,24(sp)
    80004a32:	e85a                	sd	s6,16(sp)
    80004a34:	e45e                	sd	s7,8(sp)
    80004a36:	e062                	sd	s8,0(sp)
    80004a38:	0880                	addi	s0,sp,80
    80004a3a:	892a                	mv	s2,a0
    80004a3c:	8aae                	mv	s5,a1
    80004a3e:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004a40:	411c                	lw	a5,0(a0)
    80004a42:	4705                	li	a4,1
    80004a44:	02e78263          	beq	a5,a4,80004a68 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004a48:	470d                	li	a4,3
    80004a4a:	02e78563          	beq	a5,a4,80004a74 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004a4e:	4709                	li	a4,2
    80004a50:	10e79463          	bne	a5,a4,80004b58 <filewrite+0x13e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004a54:	0ec05e63          	blez	a2,80004b50 <filewrite+0x136>
    int i = 0;
    80004a58:	4981                	li	s3,0
    80004a5a:	6b05                	lui	s6,0x1
    80004a5c:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004a60:	6b85                	lui	s7,0x1
    80004a62:	c00b8b9b          	addiw	s7,s7,-1024
    80004a66:	a851                	j	80004afa <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80004a68:	6908                	ld	a0,16(a0)
    80004a6a:	00000097          	auipc	ra,0x0
    80004a6e:	254080e7          	jalr	596(ra) # 80004cbe <pipewrite>
    80004a72:	a85d                	j	80004b28 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004a74:	02451783          	lh	a5,36(a0)
    80004a78:	03079693          	slli	a3,a5,0x30
    80004a7c:	92c1                	srli	a3,a3,0x30
    80004a7e:	4725                	li	a4,9
    80004a80:	0ed76663          	bltu	a4,a3,80004b6c <filewrite+0x152>
    80004a84:	0792                	slli	a5,a5,0x4
    80004a86:	0003d717          	auipc	a4,0x3d
    80004a8a:	f3a70713          	addi	a4,a4,-198 # 800419c0 <devsw>
    80004a8e:	97ba                	add	a5,a5,a4
    80004a90:	679c                	ld	a5,8(a5)
    80004a92:	cff9                	beqz	a5,80004b70 <filewrite+0x156>
    ret = devsw[f->major].write(1, addr, n);
    80004a94:	4505                	li	a0,1
    80004a96:	9782                	jalr	a5
    80004a98:	a841                	j	80004b28 <filewrite+0x10e>
    80004a9a:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004a9e:	00000097          	auipc	ra,0x0
    80004aa2:	8ae080e7          	jalr	-1874(ra) # 8000434c <begin_op>
      ilock(f->ip);
    80004aa6:	01893503          	ld	a0,24(s2)
    80004aaa:	fffff097          	auipc	ra,0xfffff
    80004aae:	ee2080e7          	jalr	-286(ra) # 8000398c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004ab2:	8762                	mv	a4,s8
    80004ab4:	02092683          	lw	a3,32(s2)
    80004ab8:	01598633          	add	a2,s3,s5
    80004abc:	4585                	li	a1,1
    80004abe:	01893503          	ld	a0,24(s2)
    80004ac2:	fffff097          	auipc	ra,0xfffff
    80004ac6:	276080e7          	jalr	630(ra) # 80003d38 <writei>
    80004aca:	84aa                	mv	s1,a0
    80004acc:	02a05f63          	blez	a0,80004b0a <filewrite+0xf0>
        f->off += r;
    80004ad0:	02092783          	lw	a5,32(s2)
    80004ad4:	9fa9                	addw	a5,a5,a0
    80004ad6:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004ada:	01893503          	ld	a0,24(s2)
    80004ade:	fffff097          	auipc	ra,0xfffff
    80004ae2:	f70080e7          	jalr	-144(ra) # 80003a4e <iunlock>
      end_op();
    80004ae6:	00000097          	auipc	ra,0x0
    80004aea:	8e6080e7          	jalr	-1818(ra) # 800043cc <end_op>

      if(r < 0)
        break;
      if(r != n1)
    80004aee:	049c1963          	bne	s8,s1,80004b40 <filewrite+0x126>
        panic("short filewrite");
      i += r;
    80004af2:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004af6:	0349d663          	bge	s3,s4,80004b22 <filewrite+0x108>
      int n1 = n - i;
    80004afa:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004afe:	84be                	mv	s1,a5
    80004b00:	2781                	sext.w	a5,a5
    80004b02:	f8fb5ce3          	bge	s6,a5,80004a9a <filewrite+0x80>
    80004b06:	84de                	mv	s1,s7
    80004b08:	bf49                	j	80004a9a <filewrite+0x80>
      iunlock(f->ip);
    80004b0a:	01893503          	ld	a0,24(s2)
    80004b0e:	fffff097          	auipc	ra,0xfffff
    80004b12:	f40080e7          	jalr	-192(ra) # 80003a4e <iunlock>
      end_op();
    80004b16:	00000097          	auipc	ra,0x0
    80004b1a:	8b6080e7          	jalr	-1866(ra) # 800043cc <end_op>
      if(r < 0)
    80004b1e:	fc04d8e3          	bgez	s1,80004aee <filewrite+0xd4>
    }
    ret = (i == n ? n : -1);
    80004b22:	8552                	mv	a0,s4
    80004b24:	033a1863          	bne	s4,s3,80004b54 <filewrite+0x13a>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004b28:	60a6                	ld	ra,72(sp)
    80004b2a:	6406                	ld	s0,64(sp)
    80004b2c:	74e2                	ld	s1,56(sp)
    80004b2e:	7942                	ld	s2,48(sp)
    80004b30:	79a2                	ld	s3,40(sp)
    80004b32:	7a02                	ld	s4,32(sp)
    80004b34:	6ae2                	ld	s5,24(sp)
    80004b36:	6b42                	ld	s6,16(sp)
    80004b38:	6ba2                	ld	s7,8(sp)
    80004b3a:	6c02                	ld	s8,0(sp)
    80004b3c:	6161                	addi	sp,sp,80
    80004b3e:	8082                	ret
        panic("short filewrite");
    80004b40:	00004517          	auipc	a0,0x4
    80004b44:	bd850513          	addi	a0,a0,-1064 # 80008718 <syscalls+0x280>
    80004b48:	ffffc097          	auipc	ra,0xffffc
    80004b4c:	a9c080e7          	jalr	-1380(ra) # 800005e4 <panic>
    int i = 0;
    80004b50:	4981                	li	s3,0
    80004b52:	bfc1                	j	80004b22 <filewrite+0x108>
    ret = (i == n ? n : -1);
    80004b54:	557d                	li	a0,-1
    80004b56:	bfc9                	j	80004b28 <filewrite+0x10e>
    panic("filewrite");
    80004b58:	00004517          	auipc	a0,0x4
    80004b5c:	bd050513          	addi	a0,a0,-1072 # 80008728 <syscalls+0x290>
    80004b60:	ffffc097          	auipc	ra,0xffffc
    80004b64:	a84080e7          	jalr	-1404(ra) # 800005e4 <panic>
    return -1;
    80004b68:	557d                	li	a0,-1
}
    80004b6a:	8082                	ret
      return -1;
    80004b6c:	557d                	li	a0,-1
    80004b6e:	bf6d                	j	80004b28 <filewrite+0x10e>
    80004b70:	557d                	li	a0,-1
    80004b72:	bf5d                	j	80004b28 <filewrite+0x10e>

0000000080004b74 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004b74:	7179                	addi	sp,sp,-48
    80004b76:	f406                	sd	ra,40(sp)
    80004b78:	f022                	sd	s0,32(sp)
    80004b7a:	ec26                	sd	s1,24(sp)
    80004b7c:	e84a                	sd	s2,16(sp)
    80004b7e:	e44e                	sd	s3,8(sp)
    80004b80:	e052                	sd	s4,0(sp)
    80004b82:	1800                	addi	s0,sp,48
    80004b84:	84aa                	mv	s1,a0
    80004b86:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004b88:	0005b023          	sd	zero,0(a1)
    80004b8c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004b90:	00000097          	auipc	ra,0x0
    80004b94:	bd2080e7          	jalr	-1070(ra) # 80004762 <filealloc>
    80004b98:	e088                	sd	a0,0(s1)
    80004b9a:	c551                	beqz	a0,80004c26 <pipealloc+0xb2>
    80004b9c:	00000097          	auipc	ra,0x0
    80004ba0:	bc6080e7          	jalr	-1082(ra) # 80004762 <filealloc>
    80004ba4:	00aa3023          	sd	a0,0(s4)
    80004ba8:	c92d                	beqz	a0,80004c1a <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004baa:	ffffc097          	auipc	ra,0xffffc
    80004bae:	052080e7          	jalr	82(ra) # 80000bfc <kalloc>
    80004bb2:	892a                	mv	s2,a0
    80004bb4:	c125                	beqz	a0,80004c14 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004bb6:	4985                	li	s3,1
    80004bb8:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004bbc:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004bc0:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004bc4:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004bc8:	00004597          	auipc	a1,0x4
    80004bcc:	b7058593          	addi	a1,a1,-1168 # 80008738 <syscalls+0x2a0>
    80004bd0:	ffffc097          	auipc	ra,0xffffc
    80004bd4:	0da080e7          	jalr	218(ra) # 80000caa <initlock>
  (*f0)->type = FD_PIPE;
    80004bd8:	609c                	ld	a5,0(s1)
    80004bda:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004bde:	609c                	ld	a5,0(s1)
    80004be0:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004be4:	609c                	ld	a5,0(s1)
    80004be6:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004bea:	609c                	ld	a5,0(s1)
    80004bec:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004bf0:	000a3783          	ld	a5,0(s4)
    80004bf4:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004bf8:	000a3783          	ld	a5,0(s4)
    80004bfc:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004c00:	000a3783          	ld	a5,0(s4)
    80004c04:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004c08:	000a3783          	ld	a5,0(s4)
    80004c0c:	0127b823          	sd	s2,16(a5)
  return 0;
    80004c10:	4501                	li	a0,0
    80004c12:	a025                	j	80004c3a <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004c14:	6088                	ld	a0,0(s1)
    80004c16:	e501                	bnez	a0,80004c1e <pipealloc+0xaa>
    80004c18:	a039                	j	80004c26 <pipealloc+0xb2>
    80004c1a:	6088                	ld	a0,0(s1)
    80004c1c:	c51d                	beqz	a0,80004c4a <pipealloc+0xd6>
    fileclose(*f0);
    80004c1e:	00000097          	auipc	ra,0x0
    80004c22:	c00080e7          	jalr	-1024(ra) # 8000481e <fileclose>
  if(*f1)
    80004c26:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004c2a:	557d                	li	a0,-1
  if(*f1)
    80004c2c:	c799                	beqz	a5,80004c3a <pipealloc+0xc6>
    fileclose(*f1);
    80004c2e:	853e                	mv	a0,a5
    80004c30:	00000097          	auipc	ra,0x0
    80004c34:	bee080e7          	jalr	-1042(ra) # 8000481e <fileclose>
  return -1;
    80004c38:	557d                	li	a0,-1
}
    80004c3a:	70a2                	ld	ra,40(sp)
    80004c3c:	7402                	ld	s0,32(sp)
    80004c3e:	64e2                	ld	s1,24(sp)
    80004c40:	6942                	ld	s2,16(sp)
    80004c42:	69a2                	ld	s3,8(sp)
    80004c44:	6a02                	ld	s4,0(sp)
    80004c46:	6145                	addi	sp,sp,48
    80004c48:	8082                	ret
  return -1;
    80004c4a:	557d                	li	a0,-1
    80004c4c:	b7fd                	j	80004c3a <pipealloc+0xc6>

0000000080004c4e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004c4e:	1101                	addi	sp,sp,-32
    80004c50:	ec06                	sd	ra,24(sp)
    80004c52:	e822                	sd	s0,16(sp)
    80004c54:	e426                	sd	s1,8(sp)
    80004c56:	e04a                	sd	s2,0(sp)
    80004c58:	1000                	addi	s0,sp,32
    80004c5a:	84aa                	mv	s1,a0
    80004c5c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004c5e:	ffffc097          	auipc	ra,0xffffc
    80004c62:	0dc080e7          	jalr	220(ra) # 80000d3a <acquire>
  if(writable){
    80004c66:	02090d63          	beqz	s2,80004ca0 <pipeclose+0x52>
    pi->writeopen = 0;
    80004c6a:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004c6e:	21848513          	addi	a0,s1,536
    80004c72:	ffffe097          	auipc	ra,0xffffe
    80004c76:	988080e7          	jalr	-1656(ra) # 800025fa <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004c7a:	2204b783          	ld	a5,544(s1)
    80004c7e:	eb95                	bnez	a5,80004cb2 <pipeclose+0x64>
    release(&pi->lock);
    80004c80:	8526                	mv	a0,s1
    80004c82:	ffffc097          	auipc	ra,0xffffc
    80004c86:	16c080e7          	jalr	364(ra) # 80000dee <release>
    kfree((char*)pi);
    80004c8a:	8526                	mv	a0,s1
    80004c8c:	ffffc097          	auipc	ra,0xffffc
    80004c90:	dfe080e7          	jalr	-514(ra) # 80000a8a <kfree>
  } else
    release(&pi->lock);
}
    80004c94:	60e2                	ld	ra,24(sp)
    80004c96:	6442                	ld	s0,16(sp)
    80004c98:	64a2                	ld	s1,8(sp)
    80004c9a:	6902                	ld	s2,0(sp)
    80004c9c:	6105                	addi	sp,sp,32
    80004c9e:	8082                	ret
    pi->readopen = 0;
    80004ca0:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004ca4:	21c48513          	addi	a0,s1,540
    80004ca8:	ffffe097          	auipc	ra,0xffffe
    80004cac:	952080e7          	jalr	-1710(ra) # 800025fa <wakeup>
    80004cb0:	b7e9                	j	80004c7a <pipeclose+0x2c>
    release(&pi->lock);
    80004cb2:	8526                	mv	a0,s1
    80004cb4:	ffffc097          	auipc	ra,0xffffc
    80004cb8:	13a080e7          	jalr	314(ra) # 80000dee <release>
}
    80004cbc:	bfe1                	j	80004c94 <pipeclose+0x46>

0000000080004cbe <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004cbe:	711d                	addi	sp,sp,-96
    80004cc0:	ec86                	sd	ra,88(sp)
    80004cc2:	e8a2                	sd	s0,80(sp)
    80004cc4:	e4a6                	sd	s1,72(sp)
    80004cc6:	e0ca                	sd	s2,64(sp)
    80004cc8:	fc4e                	sd	s3,56(sp)
    80004cca:	f852                	sd	s4,48(sp)
    80004ccc:	f456                	sd	s5,40(sp)
    80004cce:	f05a                	sd	s6,32(sp)
    80004cd0:	ec5e                	sd	s7,24(sp)
    80004cd2:	e862                	sd	s8,16(sp)
    80004cd4:	1080                	addi	s0,sp,96
    80004cd6:	84aa                	mv	s1,a0
    80004cd8:	8b2e                	mv	s6,a1
    80004cda:	8ab2                	mv	s5,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    80004cdc:	ffffd097          	auipc	ra,0xffffd
    80004ce0:	f8a080e7          	jalr	-118(ra) # 80001c66 <myproc>
    80004ce4:	892a                	mv	s2,a0

  acquire(&pi->lock);
    80004ce6:	8526                	mv	a0,s1
    80004ce8:	ffffc097          	auipc	ra,0xffffc
    80004cec:	052080e7          	jalr	82(ra) # 80000d3a <acquire>
  for(i = 0; i < n; i++){
    80004cf0:	09505763          	blez	s5,80004d7e <pipewrite+0xc0>
    80004cf4:	4b81                	li	s7,0
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || pr->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    80004cf6:	21848a13          	addi	s4,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004cfa:	21c48993          	addi	s3,s1,540
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004cfe:	5c7d                	li	s8,-1
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004d00:	2184a783          	lw	a5,536(s1)
    80004d04:	21c4a703          	lw	a4,540(s1)
    80004d08:	2007879b          	addiw	a5,a5,512
    80004d0c:	02f71b63          	bne	a4,a5,80004d42 <pipewrite+0x84>
      if(pi->readopen == 0 || pr->killed){
    80004d10:	2204a783          	lw	a5,544(s1)
    80004d14:	c3d1                	beqz	a5,80004d98 <pipewrite+0xda>
    80004d16:	03092783          	lw	a5,48(s2)
    80004d1a:	efbd                	bnez	a5,80004d98 <pipewrite+0xda>
      wakeup(&pi->nread);
    80004d1c:	8552                	mv	a0,s4
    80004d1e:	ffffe097          	auipc	ra,0xffffe
    80004d22:	8dc080e7          	jalr	-1828(ra) # 800025fa <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004d26:	85a6                	mv	a1,s1
    80004d28:	854e                	mv	a0,s3
    80004d2a:	ffffd097          	auipc	ra,0xffffd
    80004d2e:	750080e7          	jalr	1872(ra) # 8000247a <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004d32:	2184a783          	lw	a5,536(s1)
    80004d36:	21c4a703          	lw	a4,540(s1)
    80004d3a:	2007879b          	addiw	a5,a5,512
    80004d3e:	fcf709e3          	beq	a4,a5,80004d10 <pipewrite+0x52>
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004d42:	4685                	li	a3,1
    80004d44:	865a                	mv	a2,s6
    80004d46:	faf40593          	addi	a1,s0,-81
    80004d4a:	05093503          	ld	a0,80(s2)
    80004d4e:	ffffd097          	auipc	ra,0xffffd
    80004d52:	a70080e7          	jalr	-1424(ra) # 800017be <copyin>
    80004d56:	03850563          	beq	a0,s8,80004d80 <pipewrite+0xc2>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004d5a:	21c4a783          	lw	a5,540(s1)
    80004d5e:	0017871b          	addiw	a4,a5,1
    80004d62:	20e4ae23          	sw	a4,540(s1)
    80004d66:	1ff7f793          	andi	a5,a5,511
    80004d6a:	97a6                	add	a5,a5,s1
    80004d6c:	faf44703          	lbu	a4,-81(s0)
    80004d70:	00e78c23          	sb	a4,24(a5)
  for(i = 0; i < n; i++){
    80004d74:	2b85                	addiw	s7,s7,1
    80004d76:	0b05                	addi	s6,s6,1
    80004d78:	f97a94e3          	bne	s5,s7,80004d00 <pipewrite+0x42>
    80004d7c:	a011                	j	80004d80 <pipewrite+0xc2>
    80004d7e:	4b81                	li	s7,0
  }
  wakeup(&pi->nread);
    80004d80:	21848513          	addi	a0,s1,536
    80004d84:	ffffe097          	auipc	ra,0xffffe
    80004d88:	876080e7          	jalr	-1930(ra) # 800025fa <wakeup>
  release(&pi->lock);
    80004d8c:	8526                	mv	a0,s1
    80004d8e:	ffffc097          	auipc	ra,0xffffc
    80004d92:	060080e7          	jalr	96(ra) # 80000dee <release>
  return i;
    80004d96:	a039                	j	80004da4 <pipewrite+0xe6>
        release(&pi->lock);
    80004d98:	8526                	mv	a0,s1
    80004d9a:	ffffc097          	auipc	ra,0xffffc
    80004d9e:	054080e7          	jalr	84(ra) # 80000dee <release>
        return -1;
    80004da2:	5bfd                	li	s7,-1
}
    80004da4:	855e                	mv	a0,s7
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

0000000080004dbe <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004dbe:	715d                	addi	sp,sp,-80
    80004dc0:	e486                	sd	ra,72(sp)
    80004dc2:	e0a2                	sd	s0,64(sp)
    80004dc4:	fc26                	sd	s1,56(sp)
    80004dc6:	f84a                	sd	s2,48(sp)
    80004dc8:	f44e                	sd	s3,40(sp)
    80004dca:	f052                	sd	s4,32(sp)
    80004dcc:	ec56                	sd	s5,24(sp)
    80004dce:	e85a                	sd	s6,16(sp)
    80004dd0:	0880                	addi	s0,sp,80
    80004dd2:	84aa                	mv	s1,a0
    80004dd4:	892e                	mv	s2,a1
    80004dd6:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004dd8:	ffffd097          	auipc	ra,0xffffd
    80004ddc:	e8e080e7          	jalr	-370(ra) # 80001c66 <myproc>
    80004de0:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004de2:	8526                	mv	a0,s1
    80004de4:	ffffc097          	auipc	ra,0xffffc
    80004de8:	f56080e7          	jalr	-170(ra) # 80000d3a <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004dec:	2184a703          	lw	a4,536(s1)
    80004df0:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004df4:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004df8:	02f71463          	bne	a4,a5,80004e20 <piperead+0x62>
    80004dfc:	2244a783          	lw	a5,548(s1)
    80004e00:	c385                	beqz	a5,80004e20 <piperead+0x62>
    if(pr->killed){
    80004e02:	030a2783          	lw	a5,48(s4)
    80004e06:	ebc1                	bnez	a5,80004e96 <piperead+0xd8>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004e08:	85a6                	mv	a1,s1
    80004e0a:	854e                	mv	a0,s3
    80004e0c:	ffffd097          	auipc	ra,0xffffd
    80004e10:	66e080e7          	jalr	1646(ra) # 8000247a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004e14:	2184a703          	lw	a4,536(s1)
    80004e18:	21c4a783          	lw	a5,540(s1)
    80004e1c:	fef700e3          	beq	a4,a5,80004dfc <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004e20:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004e22:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004e24:	05505363          	blez	s5,80004e6a <piperead+0xac>
    if(pi->nread == pi->nwrite)
    80004e28:	2184a783          	lw	a5,536(s1)
    80004e2c:	21c4a703          	lw	a4,540(s1)
    80004e30:	02f70d63          	beq	a4,a5,80004e6a <piperead+0xac>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004e34:	0017871b          	addiw	a4,a5,1
    80004e38:	20e4ac23          	sw	a4,536(s1)
    80004e3c:	1ff7f793          	andi	a5,a5,511
    80004e40:	97a6                	add	a5,a5,s1
    80004e42:	0187c783          	lbu	a5,24(a5)
    80004e46:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004e4a:	4685                	li	a3,1
    80004e4c:	fbf40613          	addi	a2,s0,-65
    80004e50:	85ca                	mv	a1,s2
    80004e52:	050a3503          	ld	a0,80(s4)
    80004e56:	ffffd097          	auipc	ra,0xffffd
    80004e5a:	bdc080e7          	jalr	-1060(ra) # 80001a32 <copyout>
    80004e5e:	01650663          	beq	a0,s6,80004e6a <piperead+0xac>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004e62:	2985                	addiw	s3,s3,1
    80004e64:	0905                	addi	s2,s2,1
    80004e66:	fd3a91e3          	bne	s5,s3,80004e28 <piperead+0x6a>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004e6a:	21c48513          	addi	a0,s1,540
    80004e6e:	ffffd097          	auipc	ra,0xffffd
    80004e72:	78c080e7          	jalr	1932(ra) # 800025fa <wakeup>
  release(&pi->lock);
    80004e76:	8526                	mv	a0,s1
    80004e78:	ffffc097          	auipc	ra,0xffffc
    80004e7c:	f76080e7          	jalr	-138(ra) # 80000dee <release>
  return i;
}
    80004e80:	854e                	mv	a0,s3
    80004e82:	60a6                	ld	ra,72(sp)
    80004e84:	6406                	ld	s0,64(sp)
    80004e86:	74e2                	ld	s1,56(sp)
    80004e88:	7942                	ld	s2,48(sp)
    80004e8a:	79a2                	ld	s3,40(sp)
    80004e8c:	7a02                	ld	s4,32(sp)
    80004e8e:	6ae2                	ld	s5,24(sp)
    80004e90:	6b42                	ld	s6,16(sp)
    80004e92:	6161                	addi	sp,sp,80
    80004e94:	8082                	ret
      release(&pi->lock);
    80004e96:	8526                	mv	a0,s1
    80004e98:	ffffc097          	auipc	ra,0xffffc
    80004e9c:	f56080e7          	jalr	-170(ra) # 80000dee <release>
      return -1;
    80004ea0:	59fd                	li	s3,-1
    80004ea2:	bff9                	j	80004e80 <piperead+0xc2>

0000000080004ea4 <exec>:
#include "types.h"

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset,
                   uint sz);

int exec(char *path, char **argv) {
    80004ea4:	de010113          	addi	sp,sp,-544
    80004ea8:	20113c23          	sd	ra,536(sp)
    80004eac:	20813823          	sd	s0,528(sp)
    80004eb0:	20913423          	sd	s1,520(sp)
    80004eb4:	21213023          	sd	s2,512(sp)
    80004eb8:	ffce                	sd	s3,504(sp)
    80004eba:	fbd2                	sd	s4,496(sp)
    80004ebc:	f7d6                	sd	s5,488(sp)
    80004ebe:	f3da                	sd	s6,480(sp)
    80004ec0:	efde                	sd	s7,472(sp)
    80004ec2:	ebe2                	sd	s8,464(sp)
    80004ec4:	e7e6                	sd	s9,456(sp)
    80004ec6:	e3ea                	sd	s10,448(sp)
    80004ec8:	ff6e                	sd	s11,440(sp)
    80004eca:	1400                	addi	s0,sp,544
    80004ecc:	892a                	mv	s2,a0
    80004ece:	dea43423          	sd	a0,-536(s0)
    80004ed2:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG + 1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004ed6:	ffffd097          	auipc	ra,0xffffd
    80004eda:	d90080e7          	jalr	-624(ra) # 80001c66 <myproc>
    80004ede:	84aa                	mv	s1,a0

  begin_op();
    80004ee0:	fffff097          	auipc	ra,0xfffff
    80004ee4:	46c080e7          	jalr	1132(ra) # 8000434c <begin_op>

  if ((ip = namei(path)) == 0) {
    80004ee8:	854a                	mv	a0,s2
    80004eea:	fffff097          	auipc	ra,0xfffff
    80004eee:	256080e7          	jalr	598(ra) # 80004140 <namei>
    80004ef2:	c93d                	beqz	a0,80004f68 <exec+0xc4>
    80004ef4:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004ef6:	fffff097          	auipc	ra,0xfffff
    80004efa:	a96080e7          	jalr	-1386(ra) # 8000398c <ilock>

  // Check ELF header
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004efe:	04000713          	li	a4,64
    80004f02:	4681                	li	a3,0
    80004f04:	e4840613          	addi	a2,s0,-440
    80004f08:	4581                	li	a1,0
    80004f0a:	8556                	mv	a0,s5
    80004f0c:	fffff097          	auipc	ra,0xfffff
    80004f10:	d34080e7          	jalr	-716(ra) # 80003c40 <readi>
    80004f14:	04000793          	li	a5,64
    80004f18:	00f51a63          	bne	a0,a5,80004f2c <exec+0x88>
    goto bad;
  if (elf.magic != ELF_MAGIC)
    80004f1c:	e4842703          	lw	a4,-440(s0)
    80004f20:	464c47b7          	lui	a5,0x464c4
    80004f24:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004f28:	04f70663          	beq	a4,a5,80004f74 <exec+0xd0>

bad:
  if (pagetable)
    proc_freepagetable(pagetable, sz);
  if (ip) {
    iunlockput(ip);
    80004f2c:	8556                	mv	a0,s5
    80004f2e:	fffff097          	auipc	ra,0xfffff
    80004f32:	cc0080e7          	jalr	-832(ra) # 80003bee <iunlockput>
    end_op();
    80004f36:	fffff097          	auipc	ra,0xfffff
    80004f3a:	496080e7          	jalr	1174(ra) # 800043cc <end_op>
  }
  return -1;
    80004f3e:	557d                	li	a0,-1
}
    80004f40:	21813083          	ld	ra,536(sp)
    80004f44:	21013403          	ld	s0,528(sp)
    80004f48:	20813483          	ld	s1,520(sp)
    80004f4c:	20013903          	ld	s2,512(sp)
    80004f50:	79fe                	ld	s3,504(sp)
    80004f52:	7a5e                	ld	s4,496(sp)
    80004f54:	7abe                	ld	s5,488(sp)
    80004f56:	7b1e                	ld	s6,480(sp)
    80004f58:	6bfe                	ld	s7,472(sp)
    80004f5a:	6c5e                	ld	s8,464(sp)
    80004f5c:	6cbe                	ld	s9,456(sp)
    80004f5e:	6d1e                	ld	s10,448(sp)
    80004f60:	7dfa                	ld	s11,440(sp)
    80004f62:	22010113          	addi	sp,sp,544
    80004f66:	8082                	ret
    end_op();
    80004f68:	fffff097          	auipc	ra,0xfffff
    80004f6c:	464080e7          	jalr	1124(ra) # 800043cc <end_op>
    return -1;
    80004f70:	557d                	li	a0,-1
    80004f72:	b7f9                	j	80004f40 <exec+0x9c>
  if ((pagetable = proc_pagetable(p)) == 0)
    80004f74:	8526                	mv	a0,s1
    80004f76:	ffffd097          	auipc	ra,0xffffd
    80004f7a:	db4080e7          	jalr	-588(ra) # 80001d2a <proc_pagetable>
    80004f7e:	8b2a                	mv	s6,a0
    80004f80:	d555                	beqz	a0,80004f2c <exec+0x88>
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004f82:	e6842783          	lw	a5,-408(s0)
    80004f86:	e8045703          	lhu	a4,-384(s0)
    80004f8a:	c735                	beqz	a4,80004ff6 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG + 1], stackbase;
    80004f8c:	4481                	li	s1,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004f8e:	e0043423          	sd	zero,-504(s0)
    if (ph.vaddr % PGSIZE != 0)
    80004f92:	6a05                	lui	s4,0x1
    80004f94:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004f98:	dee43023          	sd	a4,-544(s0)
  uint64 pa;

  if ((va % PGSIZE) != 0)
    panic("loadseg: va must be page aligned");

  for (i = 0; i < sz; i += PGSIZE) {
    80004f9c:	6d85                	lui	s11,0x1
    80004f9e:	7d7d                	lui	s10,0xfffff
    80004fa0:	ac1d                	j	800051d6 <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if (pa == 0)
      panic("loadseg: address should exist");
    80004fa2:	00003517          	auipc	a0,0x3
    80004fa6:	79e50513          	addi	a0,a0,1950 # 80008740 <syscalls+0x2a8>
    80004faa:	ffffb097          	auipc	ra,0xffffb
    80004fae:	63a080e7          	jalr	1594(ra) # 800005e4 <panic>
    if (sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n)
    80004fb2:	874a                	mv	a4,s2
    80004fb4:	009c86bb          	addw	a3,s9,s1
    80004fb8:	4581                	li	a1,0
    80004fba:	8556                	mv	a0,s5
    80004fbc:	fffff097          	auipc	ra,0xfffff
    80004fc0:	c84080e7          	jalr	-892(ra) # 80003c40 <readi>
    80004fc4:	2501                	sext.w	a0,a0
    80004fc6:	1aa91863          	bne	s2,a0,80005176 <exec+0x2d2>
  for (i = 0; i < sz; i += PGSIZE) {
    80004fca:	009d84bb          	addw	s1,s11,s1
    80004fce:	013d09bb          	addw	s3,s10,s3
    80004fd2:	1f74f263          	bgeu	s1,s7,800051b6 <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    80004fd6:	02049593          	slli	a1,s1,0x20
    80004fda:	9181                	srli	a1,a1,0x20
    80004fdc:	95e2                	add	a1,a1,s8
    80004fde:	855a                	mv	a0,s6
    80004fe0:	ffffc097          	auipc	ra,0xffffc
    80004fe4:	1da080e7          	jalr	474(ra) # 800011ba <walkaddr>
    80004fe8:	862a                	mv	a2,a0
    if (pa == 0)
    80004fea:	dd45                	beqz	a0,80004fa2 <exec+0xfe>
      n = PGSIZE;
    80004fec:	8952                	mv	s2,s4
    if (sz - i < PGSIZE)
    80004fee:	fd49f2e3          	bgeu	s3,s4,80004fb2 <exec+0x10e>
      n = sz - i;
    80004ff2:	894e                	mv	s2,s3
    80004ff4:	bf7d                	j	80004fb2 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG + 1], stackbase;
    80004ff6:	4481                	li	s1,0
  iunlockput(ip);
    80004ff8:	8556                	mv	a0,s5
    80004ffa:	fffff097          	auipc	ra,0xfffff
    80004ffe:	bf4080e7          	jalr	-1036(ra) # 80003bee <iunlockput>
  end_op();
    80005002:	fffff097          	auipc	ra,0xfffff
    80005006:	3ca080e7          	jalr	970(ra) # 800043cc <end_op>
  p = myproc();
    8000500a:	ffffd097          	auipc	ra,0xffffd
    8000500e:	c5c080e7          	jalr	-932(ra) # 80001c66 <myproc>
    80005012:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80005014:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80005018:	6785                	lui	a5,0x1
    8000501a:	17fd                	addi	a5,a5,-1
    8000501c:	94be                	add	s1,s1,a5
    8000501e:	77fd                	lui	a5,0xfffff
    80005020:	8fe5                	and	a5,a5,s1
    80005022:	def43c23          	sd	a5,-520(s0)
  if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE)) == 0)
    80005026:	6609                	lui	a2,0x2
    80005028:	963e                	add	a2,a2,a5
    8000502a:	85be                	mv	a1,a5
    8000502c:	855a                	mv	a0,s6
    8000502e:	ffffc097          	auipc	ra,0xffffc
    80005032:	552080e7          	jalr	1362(ra) # 80001580 <uvmalloc>
    80005036:	8c2a                	mv	s8,a0
  ip = 0;
    80005038:	4a81                	li	s5,0
  if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE)) == 0)
    8000503a:	12050e63          	beqz	a0,80005176 <exec+0x2d2>
  uvmclear(pagetable, sz - 2 * PGSIZE);
    8000503e:	75f9                	lui	a1,0xffffe
    80005040:	95aa                	add	a1,a1,a0
    80005042:	855a                	mv	a0,s6
    80005044:	ffffc097          	auipc	ra,0xffffc
    80005048:	748080e7          	jalr	1864(ra) # 8000178c <uvmclear>
  stackbase = sp - PGSIZE;
    8000504c:	7afd                	lui	s5,0xfffff
    8000504e:	9ae2                	add	s5,s5,s8
  for (argc = 0; argv[argc]; argc++) {
    80005050:	df043783          	ld	a5,-528(s0)
    80005054:	6388                	ld	a0,0(a5)
    80005056:	c925                	beqz	a0,800050c6 <exec+0x222>
    80005058:	e8840993          	addi	s3,s0,-376
    8000505c:	f8840c93          	addi	s9,s0,-120
  sp = sz;
    80005060:	8962                	mv	s2,s8
  for (argc = 0; argv[argc]; argc++) {
    80005062:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80005064:	ffffc097          	auipc	ra,0xffffc
    80005068:	f56080e7          	jalr	-170(ra) # 80000fba <strlen>
    8000506c:	0015079b          	addiw	a5,a0,1
    80005070:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005074:	ff097913          	andi	s2,s2,-16
    if (sp < stackbase)
    80005078:	13596363          	bltu	s2,s5,8000519e <exec+0x2fa>
    if (copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000507c:	df043d83          	ld	s11,-528(s0)
    80005080:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80005084:	8552                	mv	a0,s4
    80005086:	ffffc097          	auipc	ra,0xffffc
    8000508a:	f34080e7          	jalr	-204(ra) # 80000fba <strlen>
    8000508e:	0015069b          	addiw	a3,a0,1
    80005092:	8652                	mv	a2,s4
    80005094:	85ca                	mv	a1,s2
    80005096:	855a                	mv	a0,s6
    80005098:	ffffd097          	auipc	ra,0xffffd
    8000509c:	99a080e7          	jalr	-1638(ra) # 80001a32 <copyout>
    800050a0:	10054363          	bltz	a0,800051a6 <exec+0x302>
    ustack[argc] = sp;
    800050a4:	0129b023          	sd	s2,0(s3)
  for (argc = 0; argv[argc]; argc++) {
    800050a8:	0485                	addi	s1,s1,1
    800050aa:	008d8793          	addi	a5,s11,8
    800050ae:	def43823          	sd	a5,-528(s0)
    800050b2:	008db503          	ld	a0,8(s11)
    800050b6:	c911                	beqz	a0,800050ca <exec+0x226>
    if (argc >= MAXARG)
    800050b8:	09a1                	addi	s3,s3,8
    800050ba:	fb3c95e3          	bne	s9,s3,80005064 <exec+0x1c0>
  sz = sz1;
    800050be:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800050c2:	4a81                	li	s5,0
    800050c4:	a84d                	j	80005176 <exec+0x2d2>
  sp = sz;
    800050c6:	8962                	mv	s2,s8
  for (argc = 0; argv[argc]; argc++) {
    800050c8:	4481                	li	s1,0
  ustack[argc] = 0;
    800050ca:	00349793          	slli	a5,s1,0x3
    800050ce:	f9040713          	addi	a4,s0,-112
    800050d2:	97ba                	add	a5,a5,a4
    800050d4:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ffb8ef8>
  sp -= (argc + 1) * sizeof(uint64);
    800050d8:	00148693          	addi	a3,s1,1
    800050dc:	068e                	slli	a3,a3,0x3
    800050de:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800050e2:	ff097913          	andi	s2,s2,-16
  if (sp < stackbase)
    800050e6:	01597663          	bgeu	s2,s5,800050f2 <exec+0x24e>
  sz = sz1;
    800050ea:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800050ee:	4a81                	li	s5,0
    800050f0:	a059                	j	80005176 <exec+0x2d2>
  if (copyout(pagetable, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) < 0)
    800050f2:	e8840613          	addi	a2,s0,-376
    800050f6:	85ca                	mv	a1,s2
    800050f8:	855a                	mv	a0,s6
    800050fa:	ffffd097          	auipc	ra,0xffffd
    800050fe:	938080e7          	jalr	-1736(ra) # 80001a32 <copyout>
    80005102:	0a054663          	bltz	a0,800051ae <exec+0x30a>
  p->trapframe->a1 = sp;
    80005106:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    8000510a:	0727bc23          	sd	s2,120(a5)
  for (last = s = path; *s; s++)
    8000510e:	de843783          	ld	a5,-536(s0)
    80005112:	0007c703          	lbu	a4,0(a5)
    80005116:	cf11                	beqz	a4,80005132 <exec+0x28e>
    80005118:	0785                	addi	a5,a5,1
    if (*s == '/')
    8000511a:	02f00693          	li	a3,47
    8000511e:	a039                	j	8000512c <exec+0x288>
      last = s + 1;
    80005120:	def43423          	sd	a5,-536(s0)
  for (last = s = path; *s; s++)
    80005124:	0785                	addi	a5,a5,1
    80005126:	fff7c703          	lbu	a4,-1(a5)
    8000512a:	c701                	beqz	a4,80005132 <exec+0x28e>
    if (*s == '/')
    8000512c:	fed71ce3          	bne	a4,a3,80005124 <exec+0x280>
    80005130:	bfc5                	j	80005120 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    80005132:	4641                	li	a2,16
    80005134:	de843583          	ld	a1,-536(s0)
    80005138:	158b8513          	addi	a0,s7,344
    8000513c:	ffffc097          	auipc	ra,0xffffc
    80005140:	e4c080e7          	jalr	-436(ra) # 80000f88 <safestrcpy>
  oldpagetable = p->pagetable;
    80005144:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80005148:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    8000514c:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry; // initial program counter = main
    80005150:	058bb783          	ld	a5,88(s7)
    80005154:	e6043703          	ld	a4,-416(s0)
    80005158:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;         // initial stack pointer
    8000515a:	058bb783          	ld	a5,88(s7)
    8000515e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005162:	85ea                	mv	a1,s10
    80005164:	ffffd097          	auipc	ra,0xffffd
    80005168:	c62080e7          	jalr	-926(ra) # 80001dc6 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000516c:	0004851b          	sext.w	a0,s1
    80005170:	bbc1                	j	80004f40 <exec+0x9c>
    80005172:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    80005176:	df843583          	ld	a1,-520(s0)
    8000517a:	855a                	mv	a0,s6
    8000517c:	ffffd097          	auipc	ra,0xffffd
    80005180:	c4a080e7          	jalr	-950(ra) # 80001dc6 <proc_freepagetable>
  if (ip) {
    80005184:	da0a94e3          	bnez	s5,80004f2c <exec+0x88>
  return -1;
    80005188:	557d                	li	a0,-1
    8000518a:	bb5d                	j	80004f40 <exec+0x9c>
    8000518c:	de943c23          	sd	s1,-520(s0)
    80005190:	b7dd                	j	80005176 <exec+0x2d2>
    80005192:	de943c23          	sd	s1,-520(s0)
    80005196:	b7c5                	j	80005176 <exec+0x2d2>
    80005198:	de943c23          	sd	s1,-520(s0)
    8000519c:	bfe9                	j	80005176 <exec+0x2d2>
  sz = sz1;
    8000519e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800051a2:	4a81                	li	s5,0
    800051a4:	bfc9                	j	80005176 <exec+0x2d2>
  sz = sz1;
    800051a6:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800051aa:	4a81                	li	s5,0
    800051ac:	b7e9                	j	80005176 <exec+0x2d2>
  sz = sz1;
    800051ae:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800051b2:	4a81                	li	s5,0
    800051b4:	b7c9                	j	80005176 <exec+0x2d2>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800051b6:	df843483          	ld	s1,-520(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800051ba:	e0843783          	ld	a5,-504(s0)
    800051be:	0017869b          	addiw	a3,a5,1
    800051c2:	e0d43423          	sd	a3,-504(s0)
    800051c6:	e0043783          	ld	a5,-512(s0)
    800051ca:	0387879b          	addiw	a5,a5,56
    800051ce:	e8045703          	lhu	a4,-384(s0)
    800051d2:	e2e6d3e3          	bge	a3,a4,80004ff8 <exec+0x154>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800051d6:	2781                	sext.w	a5,a5
    800051d8:	e0f43023          	sd	a5,-512(s0)
    800051dc:	03800713          	li	a4,56
    800051e0:	86be                	mv	a3,a5
    800051e2:	e1040613          	addi	a2,s0,-496
    800051e6:	4581                	li	a1,0
    800051e8:	8556                	mv	a0,s5
    800051ea:	fffff097          	auipc	ra,0xfffff
    800051ee:	a56080e7          	jalr	-1450(ra) # 80003c40 <readi>
    800051f2:	03800793          	li	a5,56
    800051f6:	f6f51ee3          	bne	a0,a5,80005172 <exec+0x2ce>
    if (ph.type != ELF_PROG_LOAD)
    800051fa:	e1042783          	lw	a5,-496(s0)
    800051fe:	4705                	li	a4,1
    80005200:	fae79de3          	bne	a5,a4,800051ba <exec+0x316>
    if (ph.memsz < ph.filesz)
    80005204:	e3843603          	ld	a2,-456(s0)
    80005208:	e3043783          	ld	a5,-464(s0)
    8000520c:	f8f660e3          	bltu	a2,a5,8000518c <exec+0x2e8>
    if (ph.vaddr + ph.memsz < ph.vaddr)
    80005210:	e2043783          	ld	a5,-480(s0)
    80005214:	963e                	add	a2,a2,a5
    80005216:	f6f66ee3          	bltu	a2,a5,80005192 <exec+0x2ee>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000521a:	85a6                	mv	a1,s1
    8000521c:	855a                	mv	a0,s6
    8000521e:	ffffc097          	auipc	ra,0xffffc
    80005222:	362080e7          	jalr	866(ra) # 80001580 <uvmalloc>
    80005226:	dea43c23          	sd	a0,-520(s0)
    8000522a:	d53d                	beqz	a0,80005198 <exec+0x2f4>
    if (ph.vaddr % PGSIZE != 0)
    8000522c:	e2043c03          	ld	s8,-480(s0)
    80005230:	de043783          	ld	a5,-544(s0)
    80005234:	00fc77b3          	and	a5,s8,a5
    80005238:	ff9d                	bnez	a5,80005176 <exec+0x2d2>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000523a:	e1842c83          	lw	s9,-488(s0)
    8000523e:	e3042b83          	lw	s7,-464(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    80005242:	f60b8ae3          	beqz	s7,800051b6 <exec+0x312>
    80005246:	89de                	mv	s3,s7
    80005248:	4481                	li	s1,0
    8000524a:	b371                	j	80004fd6 <exec+0x132>

000000008000524c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000524c:	7179                	addi	sp,sp,-48
    8000524e:	f406                	sd	ra,40(sp)
    80005250:	f022                	sd	s0,32(sp)
    80005252:	ec26                	sd	s1,24(sp)
    80005254:	e84a                	sd	s2,16(sp)
    80005256:	1800                	addi	s0,sp,48
    80005258:	892e                	mv	s2,a1
    8000525a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000525c:	fdc40593          	addi	a1,s0,-36
    80005260:	ffffe097          	auipc	ra,0xffffe
    80005264:	b78080e7          	jalr	-1160(ra) # 80002dd8 <argint>
    80005268:	04054063          	bltz	a0,800052a8 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000526c:	fdc42703          	lw	a4,-36(s0)
    80005270:	47bd                	li	a5,15
    80005272:	02e7ed63          	bltu	a5,a4,800052ac <argfd+0x60>
    80005276:	ffffd097          	auipc	ra,0xffffd
    8000527a:	9f0080e7          	jalr	-1552(ra) # 80001c66 <myproc>
    8000527e:	fdc42703          	lw	a4,-36(s0)
    80005282:	01a70793          	addi	a5,a4,26
    80005286:	078e                	slli	a5,a5,0x3
    80005288:	953e                	add	a0,a0,a5
    8000528a:	611c                	ld	a5,0(a0)
    8000528c:	c395                	beqz	a5,800052b0 <argfd+0x64>
    return -1;
  if(pfd)
    8000528e:	00090463          	beqz	s2,80005296 <argfd+0x4a>
    *pfd = fd;
    80005292:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005296:	4501                	li	a0,0
  if(pf)
    80005298:	c091                	beqz	s1,8000529c <argfd+0x50>
    *pf = f;
    8000529a:	e09c                	sd	a5,0(s1)
}
    8000529c:	70a2                	ld	ra,40(sp)
    8000529e:	7402                	ld	s0,32(sp)
    800052a0:	64e2                	ld	s1,24(sp)
    800052a2:	6942                	ld	s2,16(sp)
    800052a4:	6145                	addi	sp,sp,48
    800052a6:	8082                	ret
    return -1;
    800052a8:	557d                	li	a0,-1
    800052aa:	bfcd                	j	8000529c <argfd+0x50>
    return -1;
    800052ac:	557d                	li	a0,-1
    800052ae:	b7fd                	j	8000529c <argfd+0x50>
    800052b0:	557d                	li	a0,-1
    800052b2:	b7ed                	j	8000529c <argfd+0x50>

00000000800052b4 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800052b4:	1101                	addi	sp,sp,-32
    800052b6:	ec06                	sd	ra,24(sp)
    800052b8:	e822                	sd	s0,16(sp)
    800052ba:	e426                	sd	s1,8(sp)
    800052bc:	1000                	addi	s0,sp,32
    800052be:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800052c0:	ffffd097          	auipc	ra,0xffffd
    800052c4:	9a6080e7          	jalr	-1626(ra) # 80001c66 <myproc>
    800052c8:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800052ca:	0d050793          	addi	a5,a0,208
    800052ce:	4501                	li	a0,0
    800052d0:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800052d2:	6398                	ld	a4,0(a5)
    800052d4:	cb19                	beqz	a4,800052ea <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800052d6:	2505                	addiw	a0,a0,1
    800052d8:	07a1                	addi	a5,a5,8
    800052da:	fed51ce3          	bne	a0,a3,800052d2 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800052de:	557d                	li	a0,-1
}
    800052e0:	60e2                	ld	ra,24(sp)
    800052e2:	6442                	ld	s0,16(sp)
    800052e4:	64a2                	ld	s1,8(sp)
    800052e6:	6105                	addi	sp,sp,32
    800052e8:	8082                	ret
      p->ofile[fd] = f;
    800052ea:	01a50793          	addi	a5,a0,26
    800052ee:	078e                	slli	a5,a5,0x3
    800052f0:	963e                	add	a2,a2,a5
    800052f2:	e204                	sd	s1,0(a2)
      return fd;
    800052f4:	b7f5                	j	800052e0 <fdalloc+0x2c>

00000000800052f6 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800052f6:	715d                	addi	sp,sp,-80
    800052f8:	e486                	sd	ra,72(sp)
    800052fa:	e0a2                	sd	s0,64(sp)
    800052fc:	fc26                	sd	s1,56(sp)
    800052fe:	f84a                	sd	s2,48(sp)
    80005300:	f44e                	sd	s3,40(sp)
    80005302:	f052                	sd	s4,32(sp)
    80005304:	ec56                	sd	s5,24(sp)
    80005306:	0880                	addi	s0,sp,80
    80005308:	89ae                	mv	s3,a1
    8000530a:	8ab2                	mv	s5,a2
    8000530c:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000530e:	fb040593          	addi	a1,s0,-80
    80005312:	fffff097          	auipc	ra,0xfffff
    80005316:	e4c080e7          	jalr	-436(ra) # 8000415e <nameiparent>
    8000531a:	892a                	mv	s2,a0
    8000531c:	12050e63          	beqz	a0,80005458 <create+0x162>
    return 0;

  ilock(dp);
    80005320:	ffffe097          	auipc	ra,0xffffe
    80005324:	66c080e7          	jalr	1644(ra) # 8000398c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005328:	4601                	li	a2,0
    8000532a:	fb040593          	addi	a1,s0,-80
    8000532e:	854a                	mv	a0,s2
    80005330:	fffff097          	auipc	ra,0xfffff
    80005334:	b3e080e7          	jalr	-1218(ra) # 80003e6e <dirlookup>
    80005338:	84aa                	mv	s1,a0
    8000533a:	c921                	beqz	a0,8000538a <create+0x94>
    iunlockput(dp);
    8000533c:	854a                	mv	a0,s2
    8000533e:	fffff097          	auipc	ra,0xfffff
    80005342:	8b0080e7          	jalr	-1872(ra) # 80003bee <iunlockput>
    ilock(ip);
    80005346:	8526                	mv	a0,s1
    80005348:	ffffe097          	auipc	ra,0xffffe
    8000534c:	644080e7          	jalr	1604(ra) # 8000398c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005350:	2981                	sext.w	s3,s3
    80005352:	4789                	li	a5,2
    80005354:	02f99463          	bne	s3,a5,8000537c <create+0x86>
    80005358:	0444d783          	lhu	a5,68(s1)
    8000535c:	37f9                	addiw	a5,a5,-2
    8000535e:	17c2                	slli	a5,a5,0x30
    80005360:	93c1                	srli	a5,a5,0x30
    80005362:	4705                	li	a4,1
    80005364:	00f76c63          	bltu	a4,a5,8000537c <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80005368:	8526                	mv	a0,s1
    8000536a:	60a6                	ld	ra,72(sp)
    8000536c:	6406                	ld	s0,64(sp)
    8000536e:	74e2                	ld	s1,56(sp)
    80005370:	7942                	ld	s2,48(sp)
    80005372:	79a2                	ld	s3,40(sp)
    80005374:	7a02                	ld	s4,32(sp)
    80005376:	6ae2                	ld	s5,24(sp)
    80005378:	6161                	addi	sp,sp,80
    8000537a:	8082                	ret
    iunlockput(ip);
    8000537c:	8526                	mv	a0,s1
    8000537e:	fffff097          	auipc	ra,0xfffff
    80005382:	870080e7          	jalr	-1936(ra) # 80003bee <iunlockput>
    return 0;
    80005386:	4481                	li	s1,0
    80005388:	b7c5                	j	80005368 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000538a:	85ce                	mv	a1,s3
    8000538c:	00092503          	lw	a0,0(s2)
    80005390:	ffffe097          	auipc	ra,0xffffe
    80005394:	464080e7          	jalr	1124(ra) # 800037f4 <ialloc>
    80005398:	84aa                	mv	s1,a0
    8000539a:	c521                	beqz	a0,800053e2 <create+0xec>
  ilock(ip);
    8000539c:	ffffe097          	auipc	ra,0xffffe
    800053a0:	5f0080e7          	jalr	1520(ra) # 8000398c <ilock>
  ip->major = major;
    800053a4:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800053a8:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800053ac:	4a05                	li	s4,1
    800053ae:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    800053b2:	8526                	mv	a0,s1
    800053b4:	ffffe097          	auipc	ra,0xffffe
    800053b8:	50e080e7          	jalr	1294(ra) # 800038c2 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800053bc:	2981                	sext.w	s3,s3
    800053be:	03498a63          	beq	s3,s4,800053f2 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800053c2:	40d0                	lw	a2,4(s1)
    800053c4:	fb040593          	addi	a1,s0,-80
    800053c8:	854a                	mv	a0,s2
    800053ca:	fffff097          	auipc	ra,0xfffff
    800053ce:	cb4080e7          	jalr	-844(ra) # 8000407e <dirlink>
    800053d2:	06054b63          	bltz	a0,80005448 <create+0x152>
  iunlockput(dp);
    800053d6:	854a                	mv	a0,s2
    800053d8:	fffff097          	auipc	ra,0xfffff
    800053dc:	816080e7          	jalr	-2026(ra) # 80003bee <iunlockput>
  return ip;
    800053e0:	b761                	j	80005368 <create+0x72>
    panic("create: ialloc");
    800053e2:	00003517          	auipc	a0,0x3
    800053e6:	37e50513          	addi	a0,a0,894 # 80008760 <syscalls+0x2c8>
    800053ea:	ffffb097          	auipc	ra,0xffffb
    800053ee:	1fa080e7          	jalr	506(ra) # 800005e4 <panic>
    dp->nlink++;  // for ".."
    800053f2:	04a95783          	lhu	a5,74(s2)
    800053f6:	2785                	addiw	a5,a5,1
    800053f8:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800053fc:	854a                	mv	a0,s2
    800053fe:	ffffe097          	auipc	ra,0xffffe
    80005402:	4c4080e7          	jalr	1220(ra) # 800038c2 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005406:	40d0                	lw	a2,4(s1)
    80005408:	00003597          	auipc	a1,0x3
    8000540c:	36858593          	addi	a1,a1,872 # 80008770 <syscalls+0x2d8>
    80005410:	8526                	mv	a0,s1
    80005412:	fffff097          	auipc	ra,0xfffff
    80005416:	c6c080e7          	jalr	-916(ra) # 8000407e <dirlink>
    8000541a:	00054f63          	bltz	a0,80005438 <create+0x142>
    8000541e:	00492603          	lw	a2,4(s2)
    80005422:	00003597          	auipc	a1,0x3
    80005426:	35658593          	addi	a1,a1,854 # 80008778 <syscalls+0x2e0>
    8000542a:	8526                	mv	a0,s1
    8000542c:	fffff097          	auipc	ra,0xfffff
    80005430:	c52080e7          	jalr	-942(ra) # 8000407e <dirlink>
    80005434:	f80557e3          	bgez	a0,800053c2 <create+0xcc>
      panic("create dots");
    80005438:	00003517          	auipc	a0,0x3
    8000543c:	34850513          	addi	a0,a0,840 # 80008780 <syscalls+0x2e8>
    80005440:	ffffb097          	auipc	ra,0xffffb
    80005444:	1a4080e7          	jalr	420(ra) # 800005e4 <panic>
    panic("create: dirlink");
    80005448:	00003517          	auipc	a0,0x3
    8000544c:	34850513          	addi	a0,a0,840 # 80008790 <syscalls+0x2f8>
    80005450:	ffffb097          	auipc	ra,0xffffb
    80005454:	194080e7          	jalr	404(ra) # 800005e4 <panic>
    return 0;
    80005458:	84aa                	mv	s1,a0
    8000545a:	b739                	j	80005368 <create+0x72>

000000008000545c <sys_dup>:
{
    8000545c:	7179                	addi	sp,sp,-48
    8000545e:	f406                	sd	ra,40(sp)
    80005460:	f022                	sd	s0,32(sp)
    80005462:	ec26                	sd	s1,24(sp)
    80005464:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005466:	fd840613          	addi	a2,s0,-40
    8000546a:	4581                	li	a1,0
    8000546c:	4501                	li	a0,0
    8000546e:	00000097          	auipc	ra,0x0
    80005472:	dde080e7          	jalr	-546(ra) # 8000524c <argfd>
    return -1;
    80005476:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005478:	02054363          	bltz	a0,8000549e <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000547c:	fd843503          	ld	a0,-40(s0)
    80005480:	00000097          	auipc	ra,0x0
    80005484:	e34080e7          	jalr	-460(ra) # 800052b4 <fdalloc>
    80005488:	84aa                	mv	s1,a0
    return -1;
    8000548a:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000548c:	00054963          	bltz	a0,8000549e <sys_dup+0x42>
  filedup(f);
    80005490:	fd843503          	ld	a0,-40(s0)
    80005494:	fffff097          	auipc	ra,0xfffff
    80005498:	338080e7          	jalr	824(ra) # 800047cc <filedup>
  return fd;
    8000549c:	87a6                	mv	a5,s1
}
    8000549e:	853e                	mv	a0,a5
    800054a0:	70a2                	ld	ra,40(sp)
    800054a2:	7402                	ld	s0,32(sp)
    800054a4:	64e2                	ld	s1,24(sp)
    800054a6:	6145                	addi	sp,sp,48
    800054a8:	8082                	ret

00000000800054aa <sys_read>:
{
    800054aa:	7179                	addi	sp,sp,-48
    800054ac:	f406                	sd	ra,40(sp)
    800054ae:	f022                	sd	s0,32(sp)
    800054b0:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800054b2:	fe840613          	addi	a2,s0,-24
    800054b6:	4581                	li	a1,0
    800054b8:	4501                	li	a0,0
    800054ba:	00000097          	auipc	ra,0x0
    800054be:	d92080e7          	jalr	-622(ra) # 8000524c <argfd>
    return -1;
    800054c2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800054c4:	04054163          	bltz	a0,80005506 <sys_read+0x5c>
    800054c8:	fe440593          	addi	a1,s0,-28
    800054cc:	4509                	li	a0,2
    800054ce:	ffffe097          	auipc	ra,0xffffe
    800054d2:	90a080e7          	jalr	-1782(ra) # 80002dd8 <argint>
    return -1;
    800054d6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800054d8:	02054763          	bltz	a0,80005506 <sys_read+0x5c>
    800054dc:	fd840593          	addi	a1,s0,-40
    800054e0:	4505                	li	a0,1
    800054e2:	ffffe097          	auipc	ra,0xffffe
    800054e6:	918080e7          	jalr	-1768(ra) # 80002dfa <argaddr>
    return -1;
    800054ea:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800054ec:	00054d63          	bltz	a0,80005506 <sys_read+0x5c>
  return fileread(f, p, n);
    800054f0:	fe442603          	lw	a2,-28(s0)
    800054f4:	fd843583          	ld	a1,-40(s0)
    800054f8:	fe843503          	ld	a0,-24(s0)
    800054fc:	fffff097          	auipc	ra,0xfffff
    80005500:	45c080e7          	jalr	1116(ra) # 80004958 <fileread>
    80005504:	87aa                	mv	a5,a0
}
    80005506:	853e                	mv	a0,a5
    80005508:	70a2                	ld	ra,40(sp)
    8000550a:	7402                	ld	s0,32(sp)
    8000550c:	6145                	addi	sp,sp,48
    8000550e:	8082                	ret

0000000080005510 <sys_write>:
{
    80005510:	7179                	addi	sp,sp,-48
    80005512:	f406                	sd	ra,40(sp)
    80005514:	f022                	sd	s0,32(sp)
    80005516:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005518:	fe840613          	addi	a2,s0,-24
    8000551c:	4581                	li	a1,0
    8000551e:	4501                	li	a0,0
    80005520:	00000097          	auipc	ra,0x0
    80005524:	d2c080e7          	jalr	-724(ra) # 8000524c <argfd>
    return -1;
    80005528:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000552a:	04054163          	bltz	a0,8000556c <sys_write+0x5c>
    8000552e:	fe440593          	addi	a1,s0,-28
    80005532:	4509                	li	a0,2
    80005534:	ffffe097          	auipc	ra,0xffffe
    80005538:	8a4080e7          	jalr	-1884(ra) # 80002dd8 <argint>
    return -1;
    8000553c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000553e:	02054763          	bltz	a0,8000556c <sys_write+0x5c>
    80005542:	fd840593          	addi	a1,s0,-40
    80005546:	4505                	li	a0,1
    80005548:	ffffe097          	auipc	ra,0xffffe
    8000554c:	8b2080e7          	jalr	-1870(ra) # 80002dfa <argaddr>
    return -1;
    80005550:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005552:	00054d63          	bltz	a0,8000556c <sys_write+0x5c>
  return filewrite(f, p, n);
    80005556:	fe442603          	lw	a2,-28(s0)
    8000555a:	fd843583          	ld	a1,-40(s0)
    8000555e:	fe843503          	ld	a0,-24(s0)
    80005562:	fffff097          	auipc	ra,0xfffff
    80005566:	4b8080e7          	jalr	1208(ra) # 80004a1a <filewrite>
    8000556a:	87aa                	mv	a5,a0
}
    8000556c:	853e                	mv	a0,a5
    8000556e:	70a2                	ld	ra,40(sp)
    80005570:	7402                	ld	s0,32(sp)
    80005572:	6145                	addi	sp,sp,48
    80005574:	8082                	ret

0000000080005576 <sys_close>:
{
    80005576:	1101                	addi	sp,sp,-32
    80005578:	ec06                	sd	ra,24(sp)
    8000557a:	e822                	sd	s0,16(sp)
    8000557c:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000557e:	fe040613          	addi	a2,s0,-32
    80005582:	fec40593          	addi	a1,s0,-20
    80005586:	4501                	li	a0,0
    80005588:	00000097          	auipc	ra,0x0
    8000558c:	cc4080e7          	jalr	-828(ra) # 8000524c <argfd>
    return -1;
    80005590:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005592:	02054463          	bltz	a0,800055ba <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005596:	ffffc097          	auipc	ra,0xffffc
    8000559a:	6d0080e7          	jalr	1744(ra) # 80001c66 <myproc>
    8000559e:	fec42783          	lw	a5,-20(s0)
    800055a2:	07e9                	addi	a5,a5,26
    800055a4:	078e                	slli	a5,a5,0x3
    800055a6:	97aa                	add	a5,a5,a0
    800055a8:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800055ac:	fe043503          	ld	a0,-32(s0)
    800055b0:	fffff097          	auipc	ra,0xfffff
    800055b4:	26e080e7          	jalr	622(ra) # 8000481e <fileclose>
  return 0;
    800055b8:	4781                	li	a5,0
}
    800055ba:	853e                	mv	a0,a5
    800055bc:	60e2                	ld	ra,24(sp)
    800055be:	6442                	ld	s0,16(sp)
    800055c0:	6105                	addi	sp,sp,32
    800055c2:	8082                	ret

00000000800055c4 <sys_fstat>:
{
    800055c4:	1101                	addi	sp,sp,-32
    800055c6:	ec06                	sd	ra,24(sp)
    800055c8:	e822                	sd	s0,16(sp)
    800055ca:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800055cc:	fe840613          	addi	a2,s0,-24
    800055d0:	4581                	li	a1,0
    800055d2:	4501                	li	a0,0
    800055d4:	00000097          	auipc	ra,0x0
    800055d8:	c78080e7          	jalr	-904(ra) # 8000524c <argfd>
    return -1;
    800055dc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800055de:	02054563          	bltz	a0,80005608 <sys_fstat+0x44>
    800055e2:	fe040593          	addi	a1,s0,-32
    800055e6:	4505                	li	a0,1
    800055e8:	ffffe097          	auipc	ra,0xffffe
    800055ec:	812080e7          	jalr	-2030(ra) # 80002dfa <argaddr>
    return -1;
    800055f0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800055f2:	00054b63          	bltz	a0,80005608 <sys_fstat+0x44>
  return filestat(f, st);
    800055f6:	fe043583          	ld	a1,-32(s0)
    800055fa:	fe843503          	ld	a0,-24(s0)
    800055fe:	fffff097          	auipc	ra,0xfffff
    80005602:	2e8080e7          	jalr	744(ra) # 800048e6 <filestat>
    80005606:	87aa                	mv	a5,a0
}
    80005608:	853e                	mv	a0,a5
    8000560a:	60e2                	ld	ra,24(sp)
    8000560c:	6442                	ld	s0,16(sp)
    8000560e:	6105                	addi	sp,sp,32
    80005610:	8082                	ret

0000000080005612 <sys_link>:
{
    80005612:	7169                	addi	sp,sp,-304
    80005614:	f606                	sd	ra,296(sp)
    80005616:	f222                	sd	s0,288(sp)
    80005618:	ee26                	sd	s1,280(sp)
    8000561a:	ea4a                	sd	s2,272(sp)
    8000561c:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000561e:	08000613          	li	a2,128
    80005622:	ed040593          	addi	a1,s0,-304
    80005626:	4501                	li	a0,0
    80005628:	ffffd097          	auipc	ra,0xffffd
    8000562c:	7f4080e7          	jalr	2036(ra) # 80002e1c <argstr>
    return -1;
    80005630:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005632:	10054e63          	bltz	a0,8000574e <sys_link+0x13c>
    80005636:	08000613          	li	a2,128
    8000563a:	f5040593          	addi	a1,s0,-176
    8000563e:	4505                	li	a0,1
    80005640:	ffffd097          	auipc	ra,0xffffd
    80005644:	7dc080e7          	jalr	2012(ra) # 80002e1c <argstr>
    return -1;
    80005648:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000564a:	10054263          	bltz	a0,8000574e <sys_link+0x13c>
  begin_op();
    8000564e:	fffff097          	auipc	ra,0xfffff
    80005652:	cfe080e7          	jalr	-770(ra) # 8000434c <begin_op>
  if((ip = namei(old)) == 0){
    80005656:	ed040513          	addi	a0,s0,-304
    8000565a:	fffff097          	auipc	ra,0xfffff
    8000565e:	ae6080e7          	jalr	-1306(ra) # 80004140 <namei>
    80005662:	84aa                	mv	s1,a0
    80005664:	c551                	beqz	a0,800056f0 <sys_link+0xde>
  ilock(ip);
    80005666:	ffffe097          	auipc	ra,0xffffe
    8000566a:	326080e7          	jalr	806(ra) # 8000398c <ilock>
  if(ip->type == T_DIR){
    8000566e:	04449703          	lh	a4,68(s1)
    80005672:	4785                	li	a5,1
    80005674:	08f70463          	beq	a4,a5,800056fc <sys_link+0xea>
  ip->nlink++;
    80005678:	04a4d783          	lhu	a5,74(s1)
    8000567c:	2785                	addiw	a5,a5,1
    8000567e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005682:	8526                	mv	a0,s1
    80005684:	ffffe097          	auipc	ra,0xffffe
    80005688:	23e080e7          	jalr	574(ra) # 800038c2 <iupdate>
  iunlock(ip);
    8000568c:	8526                	mv	a0,s1
    8000568e:	ffffe097          	auipc	ra,0xffffe
    80005692:	3c0080e7          	jalr	960(ra) # 80003a4e <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005696:	fd040593          	addi	a1,s0,-48
    8000569a:	f5040513          	addi	a0,s0,-176
    8000569e:	fffff097          	auipc	ra,0xfffff
    800056a2:	ac0080e7          	jalr	-1344(ra) # 8000415e <nameiparent>
    800056a6:	892a                	mv	s2,a0
    800056a8:	c935                	beqz	a0,8000571c <sys_link+0x10a>
  ilock(dp);
    800056aa:	ffffe097          	auipc	ra,0xffffe
    800056ae:	2e2080e7          	jalr	738(ra) # 8000398c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800056b2:	00092703          	lw	a4,0(s2)
    800056b6:	409c                	lw	a5,0(s1)
    800056b8:	04f71d63          	bne	a4,a5,80005712 <sys_link+0x100>
    800056bc:	40d0                	lw	a2,4(s1)
    800056be:	fd040593          	addi	a1,s0,-48
    800056c2:	854a                	mv	a0,s2
    800056c4:	fffff097          	auipc	ra,0xfffff
    800056c8:	9ba080e7          	jalr	-1606(ra) # 8000407e <dirlink>
    800056cc:	04054363          	bltz	a0,80005712 <sys_link+0x100>
  iunlockput(dp);
    800056d0:	854a                	mv	a0,s2
    800056d2:	ffffe097          	auipc	ra,0xffffe
    800056d6:	51c080e7          	jalr	1308(ra) # 80003bee <iunlockput>
  iput(ip);
    800056da:	8526                	mv	a0,s1
    800056dc:	ffffe097          	auipc	ra,0xffffe
    800056e0:	46a080e7          	jalr	1130(ra) # 80003b46 <iput>
  end_op();
    800056e4:	fffff097          	auipc	ra,0xfffff
    800056e8:	ce8080e7          	jalr	-792(ra) # 800043cc <end_op>
  return 0;
    800056ec:	4781                	li	a5,0
    800056ee:	a085                	j	8000574e <sys_link+0x13c>
    end_op();
    800056f0:	fffff097          	auipc	ra,0xfffff
    800056f4:	cdc080e7          	jalr	-804(ra) # 800043cc <end_op>
    return -1;
    800056f8:	57fd                	li	a5,-1
    800056fa:	a891                	j	8000574e <sys_link+0x13c>
    iunlockput(ip);
    800056fc:	8526                	mv	a0,s1
    800056fe:	ffffe097          	auipc	ra,0xffffe
    80005702:	4f0080e7          	jalr	1264(ra) # 80003bee <iunlockput>
    end_op();
    80005706:	fffff097          	auipc	ra,0xfffff
    8000570a:	cc6080e7          	jalr	-826(ra) # 800043cc <end_op>
    return -1;
    8000570e:	57fd                	li	a5,-1
    80005710:	a83d                	j	8000574e <sys_link+0x13c>
    iunlockput(dp);
    80005712:	854a                	mv	a0,s2
    80005714:	ffffe097          	auipc	ra,0xffffe
    80005718:	4da080e7          	jalr	1242(ra) # 80003bee <iunlockput>
  ilock(ip);
    8000571c:	8526                	mv	a0,s1
    8000571e:	ffffe097          	auipc	ra,0xffffe
    80005722:	26e080e7          	jalr	622(ra) # 8000398c <ilock>
  ip->nlink--;
    80005726:	04a4d783          	lhu	a5,74(s1)
    8000572a:	37fd                	addiw	a5,a5,-1
    8000572c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005730:	8526                	mv	a0,s1
    80005732:	ffffe097          	auipc	ra,0xffffe
    80005736:	190080e7          	jalr	400(ra) # 800038c2 <iupdate>
  iunlockput(ip);
    8000573a:	8526                	mv	a0,s1
    8000573c:	ffffe097          	auipc	ra,0xffffe
    80005740:	4b2080e7          	jalr	1202(ra) # 80003bee <iunlockput>
  end_op();
    80005744:	fffff097          	auipc	ra,0xfffff
    80005748:	c88080e7          	jalr	-888(ra) # 800043cc <end_op>
  return -1;
    8000574c:	57fd                	li	a5,-1
}
    8000574e:	853e                	mv	a0,a5
    80005750:	70b2                	ld	ra,296(sp)
    80005752:	7412                	ld	s0,288(sp)
    80005754:	64f2                	ld	s1,280(sp)
    80005756:	6952                	ld	s2,272(sp)
    80005758:	6155                	addi	sp,sp,304
    8000575a:	8082                	ret

000000008000575c <sys_unlink>:
{
    8000575c:	7151                	addi	sp,sp,-240
    8000575e:	f586                	sd	ra,232(sp)
    80005760:	f1a2                	sd	s0,224(sp)
    80005762:	eda6                	sd	s1,216(sp)
    80005764:	e9ca                	sd	s2,208(sp)
    80005766:	e5ce                	sd	s3,200(sp)
    80005768:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000576a:	08000613          	li	a2,128
    8000576e:	f3040593          	addi	a1,s0,-208
    80005772:	4501                	li	a0,0
    80005774:	ffffd097          	auipc	ra,0xffffd
    80005778:	6a8080e7          	jalr	1704(ra) # 80002e1c <argstr>
    8000577c:	18054163          	bltz	a0,800058fe <sys_unlink+0x1a2>
  begin_op();
    80005780:	fffff097          	auipc	ra,0xfffff
    80005784:	bcc080e7          	jalr	-1076(ra) # 8000434c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005788:	fb040593          	addi	a1,s0,-80
    8000578c:	f3040513          	addi	a0,s0,-208
    80005790:	fffff097          	auipc	ra,0xfffff
    80005794:	9ce080e7          	jalr	-1586(ra) # 8000415e <nameiparent>
    80005798:	84aa                	mv	s1,a0
    8000579a:	c979                	beqz	a0,80005870 <sys_unlink+0x114>
  ilock(dp);
    8000579c:	ffffe097          	auipc	ra,0xffffe
    800057a0:	1f0080e7          	jalr	496(ra) # 8000398c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800057a4:	00003597          	auipc	a1,0x3
    800057a8:	fcc58593          	addi	a1,a1,-52 # 80008770 <syscalls+0x2d8>
    800057ac:	fb040513          	addi	a0,s0,-80
    800057b0:	ffffe097          	auipc	ra,0xffffe
    800057b4:	6a4080e7          	jalr	1700(ra) # 80003e54 <namecmp>
    800057b8:	14050a63          	beqz	a0,8000590c <sys_unlink+0x1b0>
    800057bc:	00003597          	auipc	a1,0x3
    800057c0:	fbc58593          	addi	a1,a1,-68 # 80008778 <syscalls+0x2e0>
    800057c4:	fb040513          	addi	a0,s0,-80
    800057c8:	ffffe097          	auipc	ra,0xffffe
    800057cc:	68c080e7          	jalr	1676(ra) # 80003e54 <namecmp>
    800057d0:	12050e63          	beqz	a0,8000590c <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800057d4:	f2c40613          	addi	a2,s0,-212
    800057d8:	fb040593          	addi	a1,s0,-80
    800057dc:	8526                	mv	a0,s1
    800057de:	ffffe097          	auipc	ra,0xffffe
    800057e2:	690080e7          	jalr	1680(ra) # 80003e6e <dirlookup>
    800057e6:	892a                	mv	s2,a0
    800057e8:	12050263          	beqz	a0,8000590c <sys_unlink+0x1b0>
  ilock(ip);
    800057ec:	ffffe097          	auipc	ra,0xffffe
    800057f0:	1a0080e7          	jalr	416(ra) # 8000398c <ilock>
  if(ip->nlink < 1)
    800057f4:	04a91783          	lh	a5,74(s2)
    800057f8:	08f05263          	blez	a5,8000587c <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800057fc:	04491703          	lh	a4,68(s2)
    80005800:	4785                	li	a5,1
    80005802:	08f70563          	beq	a4,a5,8000588c <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005806:	4641                	li	a2,16
    80005808:	4581                	li	a1,0
    8000580a:	fc040513          	addi	a0,s0,-64
    8000580e:	ffffb097          	auipc	ra,0xffffb
    80005812:	628080e7          	jalr	1576(ra) # 80000e36 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005816:	4741                	li	a4,16
    80005818:	f2c42683          	lw	a3,-212(s0)
    8000581c:	fc040613          	addi	a2,s0,-64
    80005820:	4581                	li	a1,0
    80005822:	8526                	mv	a0,s1
    80005824:	ffffe097          	auipc	ra,0xffffe
    80005828:	514080e7          	jalr	1300(ra) # 80003d38 <writei>
    8000582c:	47c1                	li	a5,16
    8000582e:	0af51563          	bne	a0,a5,800058d8 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005832:	04491703          	lh	a4,68(s2)
    80005836:	4785                	li	a5,1
    80005838:	0af70863          	beq	a4,a5,800058e8 <sys_unlink+0x18c>
  iunlockput(dp);
    8000583c:	8526                	mv	a0,s1
    8000583e:	ffffe097          	auipc	ra,0xffffe
    80005842:	3b0080e7          	jalr	944(ra) # 80003bee <iunlockput>
  ip->nlink--;
    80005846:	04a95783          	lhu	a5,74(s2)
    8000584a:	37fd                	addiw	a5,a5,-1
    8000584c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005850:	854a                	mv	a0,s2
    80005852:	ffffe097          	auipc	ra,0xffffe
    80005856:	070080e7          	jalr	112(ra) # 800038c2 <iupdate>
  iunlockput(ip);
    8000585a:	854a                	mv	a0,s2
    8000585c:	ffffe097          	auipc	ra,0xffffe
    80005860:	392080e7          	jalr	914(ra) # 80003bee <iunlockput>
  end_op();
    80005864:	fffff097          	auipc	ra,0xfffff
    80005868:	b68080e7          	jalr	-1176(ra) # 800043cc <end_op>
  return 0;
    8000586c:	4501                	li	a0,0
    8000586e:	a84d                	j	80005920 <sys_unlink+0x1c4>
    end_op();
    80005870:	fffff097          	auipc	ra,0xfffff
    80005874:	b5c080e7          	jalr	-1188(ra) # 800043cc <end_op>
    return -1;
    80005878:	557d                	li	a0,-1
    8000587a:	a05d                	j	80005920 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    8000587c:	00003517          	auipc	a0,0x3
    80005880:	f2450513          	addi	a0,a0,-220 # 800087a0 <syscalls+0x308>
    80005884:	ffffb097          	auipc	ra,0xffffb
    80005888:	d60080e7          	jalr	-672(ra) # 800005e4 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000588c:	04c92703          	lw	a4,76(s2)
    80005890:	02000793          	li	a5,32
    80005894:	f6e7f9e3          	bgeu	a5,a4,80005806 <sys_unlink+0xaa>
    80005898:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000589c:	4741                	li	a4,16
    8000589e:	86ce                	mv	a3,s3
    800058a0:	f1840613          	addi	a2,s0,-232
    800058a4:	4581                	li	a1,0
    800058a6:	854a                	mv	a0,s2
    800058a8:	ffffe097          	auipc	ra,0xffffe
    800058ac:	398080e7          	jalr	920(ra) # 80003c40 <readi>
    800058b0:	47c1                	li	a5,16
    800058b2:	00f51b63          	bne	a0,a5,800058c8 <sys_unlink+0x16c>
    if(de.inum != 0)
    800058b6:	f1845783          	lhu	a5,-232(s0)
    800058ba:	e7a1                	bnez	a5,80005902 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800058bc:	29c1                	addiw	s3,s3,16
    800058be:	04c92783          	lw	a5,76(s2)
    800058c2:	fcf9ede3          	bltu	s3,a5,8000589c <sys_unlink+0x140>
    800058c6:	b781                	j	80005806 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    800058c8:	00003517          	auipc	a0,0x3
    800058cc:	ef050513          	addi	a0,a0,-272 # 800087b8 <syscalls+0x320>
    800058d0:	ffffb097          	auipc	ra,0xffffb
    800058d4:	d14080e7          	jalr	-748(ra) # 800005e4 <panic>
    panic("unlink: writei");
    800058d8:	00003517          	auipc	a0,0x3
    800058dc:	ef850513          	addi	a0,a0,-264 # 800087d0 <syscalls+0x338>
    800058e0:	ffffb097          	auipc	ra,0xffffb
    800058e4:	d04080e7          	jalr	-764(ra) # 800005e4 <panic>
    dp->nlink--;
    800058e8:	04a4d783          	lhu	a5,74(s1)
    800058ec:	37fd                	addiw	a5,a5,-1
    800058ee:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800058f2:	8526                	mv	a0,s1
    800058f4:	ffffe097          	auipc	ra,0xffffe
    800058f8:	fce080e7          	jalr	-50(ra) # 800038c2 <iupdate>
    800058fc:	b781                	j	8000583c <sys_unlink+0xe0>
    return -1;
    800058fe:	557d                	li	a0,-1
    80005900:	a005                	j	80005920 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005902:	854a                	mv	a0,s2
    80005904:	ffffe097          	auipc	ra,0xffffe
    80005908:	2ea080e7          	jalr	746(ra) # 80003bee <iunlockput>
  iunlockput(dp);
    8000590c:	8526                	mv	a0,s1
    8000590e:	ffffe097          	auipc	ra,0xffffe
    80005912:	2e0080e7          	jalr	736(ra) # 80003bee <iunlockput>
  end_op();
    80005916:	fffff097          	auipc	ra,0xfffff
    8000591a:	ab6080e7          	jalr	-1354(ra) # 800043cc <end_op>
  return -1;
    8000591e:	557d                	li	a0,-1
}
    80005920:	70ae                	ld	ra,232(sp)
    80005922:	740e                	ld	s0,224(sp)
    80005924:	64ee                	ld	s1,216(sp)
    80005926:	694e                	ld	s2,208(sp)
    80005928:	69ae                	ld	s3,200(sp)
    8000592a:	616d                	addi	sp,sp,240
    8000592c:	8082                	ret

000000008000592e <sys_open>:

uint64
sys_open(void)
{
    8000592e:	7131                	addi	sp,sp,-192
    80005930:	fd06                	sd	ra,184(sp)
    80005932:	f922                	sd	s0,176(sp)
    80005934:	f526                	sd	s1,168(sp)
    80005936:	f14a                	sd	s2,160(sp)
    80005938:	ed4e                	sd	s3,152(sp)
    8000593a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    8000593c:	08000613          	li	a2,128
    80005940:	f5040593          	addi	a1,s0,-176
    80005944:	4501                	li	a0,0
    80005946:	ffffd097          	auipc	ra,0xffffd
    8000594a:	4d6080e7          	jalr	1238(ra) # 80002e1c <argstr>
    return -1;
    8000594e:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005950:	0c054163          	bltz	a0,80005a12 <sys_open+0xe4>
    80005954:	f4c40593          	addi	a1,s0,-180
    80005958:	4505                	li	a0,1
    8000595a:	ffffd097          	auipc	ra,0xffffd
    8000595e:	47e080e7          	jalr	1150(ra) # 80002dd8 <argint>
    80005962:	0a054863          	bltz	a0,80005a12 <sys_open+0xe4>

  begin_op();
    80005966:	fffff097          	auipc	ra,0xfffff
    8000596a:	9e6080e7          	jalr	-1562(ra) # 8000434c <begin_op>

  if(omode & O_CREATE){
    8000596e:	f4c42783          	lw	a5,-180(s0)
    80005972:	2007f793          	andi	a5,a5,512
    80005976:	cbdd                	beqz	a5,80005a2c <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005978:	4681                	li	a3,0
    8000597a:	4601                	li	a2,0
    8000597c:	4589                	li	a1,2
    8000597e:	f5040513          	addi	a0,s0,-176
    80005982:	00000097          	auipc	ra,0x0
    80005986:	974080e7          	jalr	-1676(ra) # 800052f6 <create>
    8000598a:	892a                	mv	s2,a0
    if(ip == 0){
    8000598c:	c959                	beqz	a0,80005a22 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000598e:	04491703          	lh	a4,68(s2)
    80005992:	478d                	li	a5,3
    80005994:	00f71763          	bne	a4,a5,800059a2 <sys_open+0x74>
    80005998:	04695703          	lhu	a4,70(s2)
    8000599c:	47a5                	li	a5,9
    8000599e:	0ce7ec63          	bltu	a5,a4,80005a76 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800059a2:	fffff097          	auipc	ra,0xfffff
    800059a6:	dc0080e7          	jalr	-576(ra) # 80004762 <filealloc>
    800059aa:	89aa                	mv	s3,a0
    800059ac:	10050263          	beqz	a0,80005ab0 <sys_open+0x182>
    800059b0:	00000097          	auipc	ra,0x0
    800059b4:	904080e7          	jalr	-1788(ra) # 800052b4 <fdalloc>
    800059b8:	84aa                	mv	s1,a0
    800059ba:	0e054663          	bltz	a0,80005aa6 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800059be:	04491703          	lh	a4,68(s2)
    800059c2:	478d                	li	a5,3
    800059c4:	0cf70463          	beq	a4,a5,80005a8c <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800059c8:	4789                	li	a5,2
    800059ca:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    800059ce:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    800059d2:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    800059d6:	f4c42783          	lw	a5,-180(s0)
    800059da:	0017c713          	xori	a4,a5,1
    800059de:	8b05                	andi	a4,a4,1
    800059e0:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800059e4:	0037f713          	andi	a4,a5,3
    800059e8:	00e03733          	snez	a4,a4
    800059ec:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800059f0:	4007f793          	andi	a5,a5,1024
    800059f4:	c791                	beqz	a5,80005a00 <sys_open+0xd2>
    800059f6:	04491703          	lh	a4,68(s2)
    800059fa:	4789                	li	a5,2
    800059fc:	08f70f63          	beq	a4,a5,80005a9a <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005a00:	854a                	mv	a0,s2
    80005a02:	ffffe097          	auipc	ra,0xffffe
    80005a06:	04c080e7          	jalr	76(ra) # 80003a4e <iunlock>
  end_op();
    80005a0a:	fffff097          	auipc	ra,0xfffff
    80005a0e:	9c2080e7          	jalr	-1598(ra) # 800043cc <end_op>

  return fd;
}
    80005a12:	8526                	mv	a0,s1
    80005a14:	70ea                	ld	ra,184(sp)
    80005a16:	744a                	ld	s0,176(sp)
    80005a18:	74aa                	ld	s1,168(sp)
    80005a1a:	790a                	ld	s2,160(sp)
    80005a1c:	69ea                	ld	s3,152(sp)
    80005a1e:	6129                	addi	sp,sp,192
    80005a20:	8082                	ret
      end_op();
    80005a22:	fffff097          	auipc	ra,0xfffff
    80005a26:	9aa080e7          	jalr	-1622(ra) # 800043cc <end_op>
      return -1;
    80005a2a:	b7e5                	j	80005a12 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80005a2c:	f5040513          	addi	a0,s0,-176
    80005a30:	ffffe097          	auipc	ra,0xffffe
    80005a34:	710080e7          	jalr	1808(ra) # 80004140 <namei>
    80005a38:	892a                	mv	s2,a0
    80005a3a:	c905                	beqz	a0,80005a6a <sys_open+0x13c>
    ilock(ip);
    80005a3c:	ffffe097          	auipc	ra,0xffffe
    80005a40:	f50080e7          	jalr	-176(ra) # 8000398c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005a44:	04491703          	lh	a4,68(s2)
    80005a48:	4785                	li	a5,1
    80005a4a:	f4f712e3          	bne	a4,a5,8000598e <sys_open+0x60>
    80005a4e:	f4c42783          	lw	a5,-180(s0)
    80005a52:	dba1                	beqz	a5,800059a2 <sys_open+0x74>
      iunlockput(ip);
    80005a54:	854a                	mv	a0,s2
    80005a56:	ffffe097          	auipc	ra,0xffffe
    80005a5a:	198080e7          	jalr	408(ra) # 80003bee <iunlockput>
      end_op();
    80005a5e:	fffff097          	auipc	ra,0xfffff
    80005a62:	96e080e7          	jalr	-1682(ra) # 800043cc <end_op>
      return -1;
    80005a66:	54fd                	li	s1,-1
    80005a68:	b76d                	j	80005a12 <sys_open+0xe4>
      end_op();
    80005a6a:	fffff097          	auipc	ra,0xfffff
    80005a6e:	962080e7          	jalr	-1694(ra) # 800043cc <end_op>
      return -1;
    80005a72:	54fd                	li	s1,-1
    80005a74:	bf79                	j	80005a12 <sys_open+0xe4>
    iunlockput(ip);
    80005a76:	854a                	mv	a0,s2
    80005a78:	ffffe097          	auipc	ra,0xffffe
    80005a7c:	176080e7          	jalr	374(ra) # 80003bee <iunlockput>
    end_op();
    80005a80:	fffff097          	auipc	ra,0xfffff
    80005a84:	94c080e7          	jalr	-1716(ra) # 800043cc <end_op>
    return -1;
    80005a88:	54fd                	li	s1,-1
    80005a8a:	b761                	j	80005a12 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005a8c:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005a90:	04691783          	lh	a5,70(s2)
    80005a94:	02f99223          	sh	a5,36(s3)
    80005a98:	bf2d                	j	800059d2 <sys_open+0xa4>
    itrunc(ip);
    80005a9a:	854a                	mv	a0,s2
    80005a9c:	ffffe097          	auipc	ra,0xffffe
    80005aa0:	ffe080e7          	jalr	-2(ra) # 80003a9a <itrunc>
    80005aa4:	bfb1                	j	80005a00 <sys_open+0xd2>
      fileclose(f);
    80005aa6:	854e                	mv	a0,s3
    80005aa8:	fffff097          	auipc	ra,0xfffff
    80005aac:	d76080e7          	jalr	-650(ra) # 8000481e <fileclose>
    iunlockput(ip);
    80005ab0:	854a                	mv	a0,s2
    80005ab2:	ffffe097          	auipc	ra,0xffffe
    80005ab6:	13c080e7          	jalr	316(ra) # 80003bee <iunlockput>
    end_op();
    80005aba:	fffff097          	auipc	ra,0xfffff
    80005abe:	912080e7          	jalr	-1774(ra) # 800043cc <end_op>
    return -1;
    80005ac2:	54fd                	li	s1,-1
    80005ac4:	b7b9                	j	80005a12 <sys_open+0xe4>

0000000080005ac6 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005ac6:	7175                	addi	sp,sp,-144
    80005ac8:	e506                	sd	ra,136(sp)
    80005aca:	e122                	sd	s0,128(sp)
    80005acc:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005ace:	fffff097          	auipc	ra,0xfffff
    80005ad2:	87e080e7          	jalr	-1922(ra) # 8000434c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005ad6:	08000613          	li	a2,128
    80005ada:	f7040593          	addi	a1,s0,-144
    80005ade:	4501                	li	a0,0
    80005ae0:	ffffd097          	auipc	ra,0xffffd
    80005ae4:	33c080e7          	jalr	828(ra) # 80002e1c <argstr>
    80005ae8:	02054963          	bltz	a0,80005b1a <sys_mkdir+0x54>
    80005aec:	4681                	li	a3,0
    80005aee:	4601                	li	a2,0
    80005af0:	4585                	li	a1,1
    80005af2:	f7040513          	addi	a0,s0,-144
    80005af6:	00000097          	auipc	ra,0x0
    80005afa:	800080e7          	jalr	-2048(ra) # 800052f6 <create>
    80005afe:	cd11                	beqz	a0,80005b1a <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005b00:	ffffe097          	auipc	ra,0xffffe
    80005b04:	0ee080e7          	jalr	238(ra) # 80003bee <iunlockput>
  end_op();
    80005b08:	fffff097          	auipc	ra,0xfffff
    80005b0c:	8c4080e7          	jalr	-1852(ra) # 800043cc <end_op>
  return 0;
    80005b10:	4501                	li	a0,0
}
    80005b12:	60aa                	ld	ra,136(sp)
    80005b14:	640a                	ld	s0,128(sp)
    80005b16:	6149                	addi	sp,sp,144
    80005b18:	8082                	ret
    end_op();
    80005b1a:	fffff097          	auipc	ra,0xfffff
    80005b1e:	8b2080e7          	jalr	-1870(ra) # 800043cc <end_op>
    return -1;
    80005b22:	557d                	li	a0,-1
    80005b24:	b7fd                	j	80005b12 <sys_mkdir+0x4c>

0000000080005b26 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005b26:	7135                	addi	sp,sp,-160
    80005b28:	ed06                	sd	ra,152(sp)
    80005b2a:	e922                	sd	s0,144(sp)
    80005b2c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005b2e:	fffff097          	auipc	ra,0xfffff
    80005b32:	81e080e7          	jalr	-2018(ra) # 8000434c <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005b36:	08000613          	li	a2,128
    80005b3a:	f7040593          	addi	a1,s0,-144
    80005b3e:	4501                	li	a0,0
    80005b40:	ffffd097          	auipc	ra,0xffffd
    80005b44:	2dc080e7          	jalr	732(ra) # 80002e1c <argstr>
    80005b48:	04054a63          	bltz	a0,80005b9c <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80005b4c:	f6c40593          	addi	a1,s0,-148
    80005b50:	4505                	li	a0,1
    80005b52:	ffffd097          	auipc	ra,0xffffd
    80005b56:	286080e7          	jalr	646(ra) # 80002dd8 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005b5a:	04054163          	bltz	a0,80005b9c <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005b5e:	f6840593          	addi	a1,s0,-152
    80005b62:	4509                	li	a0,2
    80005b64:	ffffd097          	auipc	ra,0xffffd
    80005b68:	274080e7          	jalr	628(ra) # 80002dd8 <argint>
     argint(1, &major) < 0 ||
    80005b6c:	02054863          	bltz	a0,80005b9c <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005b70:	f6841683          	lh	a3,-152(s0)
    80005b74:	f6c41603          	lh	a2,-148(s0)
    80005b78:	458d                	li	a1,3
    80005b7a:	f7040513          	addi	a0,s0,-144
    80005b7e:	fffff097          	auipc	ra,0xfffff
    80005b82:	778080e7          	jalr	1912(ra) # 800052f6 <create>
     argint(2, &minor) < 0 ||
    80005b86:	c919                	beqz	a0,80005b9c <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005b88:	ffffe097          	auipc	ra,0xffffe
    80005b8c:	066080e7          	jalr	102(ra) # 80003bee <iunlockput>
  end_op();
    80005b90:	fffff097          	auipc	ra,0xfffff
    80005b94:	83c080e7          	jalr	-1988(ra) # 800043cc <end_op>
  return 0;
    80005b98:	4501                	li	a0,0
    80005b9a:	a031                	j	80005ba6 <sys_mknod+0x80>
    end_op();
    80005b9c:	fffff097          	auipc	ra,0xfffff
    80005ba0:	830080e7          	jalr	-2000(ra) # 800043cc <end_op>
    return -1;
    80005ba4:	557d                	li	a0,-1
}
    80005ba6:	60ea                	ld	ra,152(sp)
    80005ba8:	644a                	ld	s0,144(sp)
    80005baa:	610d                	addi	sp,sp,160
    80005bac:	8082                	ret

0000000080005bae <sys_chdir>:

uint64
sys_chdir(void)
{
    80005bae:	7135                	addi	sp,sp,-160
    80005bb0:	ed06                	sd	ra,152(sp)
    80005bb2:	e922                	sd	s0,144(sp)
    80005bb4:	e526                	sd	s1,136(sp)
    80005bb6:	e14a                	sd	s2,128(sp)
    80005bb8:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005bba:	ffffc097          	auipc	ra,0xffffc
    80005bbe:	0ac080e7          	jalr	172(ra) # 80001c66 <myproc>
    80005bc2:	892a                	mv	s2,a0
  
  begin_op();
    80005bc4:	ffffe097          	auipc	ra,0xffffe
    80005bc8:	788080e7          	jalr	1928(ra) # 8000434c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005bcc:	08000613          	li	a2,128
    80005bd0:	f6040593          	addi	a1,s0,-160
    80005bd4:	4501                	li	a0,0
    80005bd6:	ffffd097          	auipc	ra,0xffffd
    80005bda:	246080e7          	jalr	582(ra) # 80002e1c <argstr>
    80005bde:	04054b63          	bltz	a0,80005c34 <sys_chdir+0x86>
    80005be2:	f6040513          	addi	a0,s0,-160
    80005be6:	ffffe097          	auipc	ra,0xffffe
    80005bea:	55a080e7          	jalr	1370(ra) # 80004140 <namei>
    80005bee:	84aa                	mv	s1,a0
    80005bf0:	c131                	beqz	a0,80005c34 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005bf2:	ffffe097          	auipc	ra,0xffffe
    80005bf6:	d9a080e7          	jalr	-614(ra) # 8000398c <ilock>
  if(ip->type != T_DIR){
    80005bfa:	04449703          	lh	a4,68(s1)
    80005bfe:	4785                	li	a5,1
    80005c00:	04f71063          	bne	a4,a5,80005c40 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005c04:	8526                	mv	a0,s1
    80005c06:	ffffe097          	auipc	ra,0xffffe
    80005c0a:	e48080e7          	jalr	-440(ra) # 80003a4e <iunlock>
  iput(p->cwd);
    80005c0e:	15093503          	ld	a0,336(s2)
    80005c12:	ffffe097          	auipc	ra,0xffffe
    80005c16:	f34080e7          	jalr	-204(ra) # 80003b46 <iput>
  end_op();
    80005c1a:	ffffe097          	auipc	ra,0xffffe
    80005c1e:	7b2080e7          	jalr	1970(ra) # 800043cc <end_op>
  p->cwd = ip;
    80005c22:	14993823          	sd	s1,336(s2)
  return 0;
    80005c26:	4501                	li	a0,0
}
    80005c28:	60ea                	ld	ra,152(sp)
    80005c2a:	644a                	ld	s0,144(sp)
    80005c2c:	64aa                	ld	s1,136(sp)
    80005c2e:	690a                	ld	s2,128(sp)
    80005c30:	610d                	addi	sp,sp,160
    80005c32:	8082                	ret
    end_op();
    80005c34:	ffffe097          	auipc	ra,0xffffe
    80005c38:	798080e7          	jalr	1944(ra) # 800043cc <end_op>
    return -1;
    80005c3c:	557d                	li	a0,-1
    80005c3e:	b7ed                	j	80005c28 <sys_chdir+0x7a>
    iunlockput(ip);
    80005c40:	8526                	mv	a0,s1
    80005c42:	ffffe097          	auipc	ra,0xffffe
    80005c46:	fac080e7          	jalr	-84(ra) # 80003bee <iunlockput>
    end_op();
    80005c4a:	ffffe097          	auipc	ra,0xffffe
    80005c4e:	782080e7          	jalr	1922(ra) # 800043cc <end_op>
    return -1;
    80005c52:	557d                	li	a0,-1
    80005c54:	bfd1                	j	80005c28 <sys_chdir+0x7a>

0000000080005c56 <sys_exec>:

uint64
sys_exec(void)
{
    80005c56:	7145                	addi	sp,sp,-464
    80005c58:	e786                	sd	ra,456(sp)
    80005c5a:	e3a2                	sd	s0,448(sp)
    80005c5c:	ff26                	sd	s1,440(sp)
    80005c5e:	fb4a                	sd	s2,432(sp)
    80005c60:	f74e                	sd	s3,424(sp)
    80005c62:	f352                	sd	s4,416(sp)
    80005c64:	ef56                	sd	s5,408(sp)
    80005c66:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005c68:	08000613          	li	a2,128
    80005c6c:	f4040593          	addi	a1,s0,-192
    80005c70:	4501                	li	a0,0
    80005c72:	ffffd097          	auipc	ra,0xffffd
    80005c76:	1aa080e7          	jalr	426(ra) # 80002e1c <argstr>
    return -1;
    80005c7a:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005c7c:	0c054a63          	bltz	a0,80005d50 <sys_exec+0xfa>
    80005c80:	e3840593          	addi	a1,s0,-456
    80005c84:	4505                	li	a0,1
    80005c86:	ffffd097          	auipc	ra,0xffffd
    80005c8a:	174080e7          	jalr	372(ra) # 80002dfa <argaddr>
    80005c8e:	0c054163          	bltz	a0,80005d50 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005c92:	10000613          	li	a2,256
    80005c96:	4581                	li	a1,0
    80005c98:	e4040513          	addi	a0,s0,-448
    80005c9c:	ffffb097          	auipc	ra,0xffffb
    80005ca0:	19a080e7          	jalr	410(ra) # 80000e36 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005ca4:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005ca8:	89a6                	mv	s3,s1
    80005caa:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005cac:	02000a13          	li	s4,32
    80005cb0:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005cb4:	00391793          	slli	a5,s2,0x3
    80005cb8:	e3040593          	addi	a1,s0,-464
    80005cbc:	e3843503          	ld	a0,-456(s0)
    80005cc0:	953e                	add	a0,a0,a5
    80005cc2:	ffffd097          	auipc	ra,0xffffd
    80005cc6:	07c080e7          	jalr	124(ra) # 80002d3e <fetchaddr>
    80005cca:	02054a63          	bltz	a0,80005cfe <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005cce:	e3043783          	ld	a5,-464(s0)
    80005cd2:	c3b9                	beqz	a5,80005d18 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005cd4:	ffffb097          	auipc	ra,0xffffb
    80005cd8:	f28080e7          	jalr	-216(ra) # 80000bfc <kalloc>
    80005cdc:	85aa                	mv	a1,a0
    80005cde:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005ce2:	cd11                	beqz	a0,80005cfe <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005ce4:	6605                	lui	a2,0x1
    80005ce6:	e3043503          	ld	a0,-464(s0)
    80005cea:	ffffd097          	auipc	ra,0xffffd
    80005cee:	0a6080e7          	jalr	166(ra) # 80002d90 <fetchstr>
    80005cf2:	00054663          	bltz	a0,80005cfe <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005cf6:	0905                	addi	s2,s2,1
    80005cf8:	09a1                	addi	s3,s3,8
    80005cfa:	fb491be3          	bne	s2,s4,80005cb0 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005cfe:	10048913          	addi	s2,s1,256
    80005d02:	6088                	ld	a0,0(s1)
    80005d04:	c529                	beqz	a0,80005d4e <sys_exec+0xf8>
    kfree(argv[i]);
    80005d06:	ffffb097          	auipc	ra,0xffffb
    80005d0a:	d84080e7          	jalr	-636(ra) # 80000a8a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005d0e:	04a1                	addi	s1,s1,8
    80005d10:	ff2499e3          	bne	s1,s2,80005d02 <sys_exec+0xac>
  return -1;
    80005d14:	597d                	li	s2,-1
    80005d16:	a82d                	j	80005d50 <sys_exec+0xfa>
      argv[i] = 0;
    80005d18:	0a8e                	slli	s5,s5,0x3
    80005d1a:	fc040793          	addi	a5,s0,-64
    80005d1e:	9abe                	add	s5,s5,a5
    80005d20:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffb8e80>
  int ret = exec(path, argv);
    80005d24:	e4040593          	addi	a1,s0,-448
    80005d28:	f4040513          	addi	a0,s0,-192
    80005d2c:	fffff097          	auipc	ra,0xfffff
    80005d30:	178080e7          	jalr	376(ra) # 80004ea4 <exec>
    80005d34:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005d36:	10048993          	addi	s3,s1,256
    80005d3a:	6088                	ld	a0,0(s1)
    80005d3c:	c911                	beqz	a0,80005d50 <sys_exec+0xfa>
    kfree(argv[i]);
    80005d3e:	ffffb097          	auipc	ra,0xffffb
    80005d42:	d4c080e7          	jalr	-692(ra) # 80000a8a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005d46:	04a1                	addi	s1,s1,8
    80005d48:	ff3499e3          	bne	s1,s3,80005d3a <sys_exec+0xe4>
    80005d4c:	a011                	j	80005d50 <sys_exec+0xfa>
  return -1;
    80005d4e:	597d                	li	s2,-1
}
    80005d50:	854a                	mv	a0,s2
    80005d52:	60be                	ld	ra,456(sp)
    80005d54:	641e                	ld	s0,448(sp)
    80005d56:	74fa                	ld	s1,440(sp)
    80005d58:	795a                	ld	s2,432(sp)
    80005d5a:	79ba                	ld	s3,424(sp)
    80005d5c:	7a1a                	ld	s4,416(sp)
    80005d5e:	6afa                	ld	s5,408(sp)
    80005d60:	6179                	addi	sp,sp,464
    80005d62:	8082                	ret

0000000080005d64 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005d64:	7139                	addi	sp,sp,-64
    80005d66:	fc06                	sd	ra,56(sp)
    80005d68:	f822                	sd	s0,48(sp)
    80005d6a:	f426                	sd	s1,40(sp)
    80005d6c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005d6e:	ffffc097          	auipc	ra,0xffffc
    80005d72:	ef8080e7          	jalr	-264(ra) # 80001c66 <myproc>
    80005d76:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005d78:	fd840593          	addi	a1,s0,-40
    80005d7c:	4501                	li	a0,0
    80005d7e:	ffffd097          	auipc	ra,0xffffd
    80005d82:	07c080e7          	jalr	124(ra) # 80002dfa <argaddr>
    return -1;
    80005d86:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005d88:	0e054063          	bltz	a0,80005e68 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005d8c:	fc840593          	addi	a1,s0,-56
    80005d90:	fd040513          	addi	a0,s0,-48
    80005d94:	fffff097          	auipc	ra,0xfffff
    80005d98:	de0080e7          	jalr	-544(ra) # 80004b74 <pipealloc>
    return -1;
    80005d9c:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005d9e:	0c054563          	bltz	a0,80005e68 <sys_pipe+0x104>
  fd0 = -1;
    80005da2:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005da6:	fd043503          	ld	a0,-48(s0)
    80005daa:	fffff097          	auipc	ra,0xfffff
    80005dae:	50a080e7          	jalr	1290(ra) # 800052b4 <fdalloc>
    80005db2:	fca42223          	sw	a0,-60(s0)
    80005db6:	08054c63          	bltz	a0,80005e4e <sys_pipe+0xea>
    80005dba:	fc843503          	ld	a0,-56(s0)
    80005dbe:	fffff097          	auipc	ra,0xfffff
    80005dc2:	4f6080e7          	jalr	1270(ra) # 800052b4 <fdalloc>
    80005dc6:	fca42023          	sw	a0,-64(s0)
    80005dca:	06054863          	bltz	a0,80005e3a <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005dce:	4691                	li	a3,4
    80005dd0:	fc440613          	addi	a2,s0,-60
    80005dd4:	fd843583          	ld	a1,-40(s0)
    80005dd8:	68a8                	ld	a0,80(s1)
    80005dda:	ffffc097          	auipc	ra,0xffffc
    80005dde:	c58080e7          	jalr	-936(ra) # 80001a32 <copyout>
    80005de2:	02054063          	bltz	a0,80005e02 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005de6:	4691                	li	a3,4
    80005de8:	fc040613          	addi	a2,s0,-64
    80005dec:	fd843583          	ld	a1,-40(s0)
    80005df0:	0591                	addi	a1,a1,4
    80005df2:	68a8                	ld	a0,80(s1)
    80005df4:	ffffc097          	auipc	ra,0xffffc
    80005df8:	c3e080e7          	jalr	-962(ra) # 80001a32 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005dfc:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005dfe:	06055563          	bgez	a0,80005e68 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005e02:	fc442783          	lw	a5,-60(s0)
    80005e06:	07e9                	addi	a5,a5,26
    80005e08:	078e                	slli	a5,a5,0x3
    80005e0a:	97a6                	add	a5,a5,s1
    80005e0c:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005e10:	fc042503          	lw	a0,-64(s0)
    80005e14:	0569                	addi	a0,a0,26
    80005e16:	050e                	slli	a0,a0,0x3
    80005e18:	9526                	add	a0,a0,s1
    80005e1a:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005e1e:	fd043503          	ld	a0,-48(s0)
    80005e22:	fffff097          	auipc	ra,0xfffff
    80005e26:	9fc080e7          	jalr	-1540(ra) # 8000481e <fileclose>
    fileclose(wf);
    80005e2a:	fc843503          	ld	a0,-56(s0)
    80005e2e:	fffff097          	auipc	ra,0xfffff
    80005e32:	9f0080e7          	jalr	-1552(ra) # 8000481e <fileclose>
    return -1;
    80005e36:	57fd                	li	a5,-1
    80005e38:	a805                	j	80005e68 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005e3a:	fc442783          	lw	a5,-60(s0)
    80005e3e:	0007c863          	bltz	a5,80005e4e <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005e42:	01a78513          	addi	a0,a5,26
    80005e46:	050e                	slli	a0,a0,0x3
    80005e48:	9526                	add	a0,a0,s1
    80005e4a:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005e4e:	fd043503          	ld	a0,-48(s0)
    80005e52:	fffff097          	auipc	ra,0xfffff
    80005e56:	9cc080e7          	jalr	-1588(ra) # 8000481e <fileclose>
    fileclose(wf);
    80005e5a:	fc843503          	ld	a0,-56(s0)
    80005e5e:	fffff097          	auipc	ra,0xfffff
    80005e62:	9c0080e7          	jalr	-1600(ra) # 8000481e <fileclose>
    return -1;
    80005e66:	57fd                	li	a5,-1
}
    80005e68:	853e                	mv	a0,a5
    80005e6a:	70e2                	ld	ra,56(sp)
    80005e6c:	7442                	ld	s0,48(sp)
    80005e6e:	74a2                	ld	s1,40(sp)
    80005e70:	6121                	addi	sp,sp,64
    80005e72:	8082                	ret
	...

0000000080005e80 <kernelvec>:
    80005e80:	7111                	addi	sp,sp,-256
    80005e82:	e006                	sd	ra,0(sp)
    80005e84:	e40a                	sd	sp,8(sp)
    80005e86:	e80e                	sd	gp,16(sp)
    80005e88:	ec12                	sd	tp,24(sp)
    80005e8a:	f016                	sd	t0,32(sp)
    80005e8c:	f41a                	sd	t1,40(sp)
    80005e8e:	f81e                	sd	t2,48(sp)
    80005e90:	fc22                	sd	s0,56(sp)
    80005e92:	e0a6                	sd	s1,64(sp)
    80005e94:	e4aa                	sd	a0,72(sp)
    80005e96:	e8ae                	sd	a1,80(sp)
    80005e98:	ecb2                	sd	a2,88(sp)
    80005e9a:	f0b6                	sd	a3,96(sp)
    80005e9c:	f4ba                	sd	a4,104(sp)
    80005e9e:	f8be                	sd	a5,112(sp)
    80005ea0:	fcc2                	sd	a6,120(sp)
    80005ea2:	e146                	sd	a7,128(sp)
    80005ea4:	e54a                	sd	s2,136(sp)
    80005ea6:	e94e                	sd	s3,144(sp)
    80005ea8:	ed52                	sd	s4,152(sp)
    80005eaa:	f156                	sd	s5,160(sp)
    80005eac:	f55a                	sd	s6,168(sp)
    80005eae:	f95e                	sd	s7,176(sp)
    80005eb0:	fd62                	sd	s8,184(sp)
    80005eb2:	e1e6                	sd	s9,192(sp)
    80005eb4:	e5ea                	sd	s10,200(sp)
    80005eb6:	e9ee                	sd	s11,208(sp)
    80005eb8:	edf2                	sd	t3,216(sp)
    80005eba:	f1f6                	sd	t4,224(sp)
    80005ebc:	f5fa                	sd	t5,232(sp)
    80005ebe:	f9fe                	sd	t6,240(sp)
    80005ec0:	d4bfc0ef          	jal	ra,80002c0a <kerneltrap>
    80005ec4:	6082                	ld	ra,0(sp)
    80005ec6:	6122                	ld	sp,8(sp)
    80005ec8:	61c2                	ld	gp,16(sp)
    80005eca:	7282                	ld	t0,32(sp)
    80005ecc:	7322                	ld	t1,40(sp)
    80005ece:	73c2                	ld	t2,48(sp)
    80005ed0:	7462                	ld	s0,56(sp)
    80005ed2:	6486                	ld	s1,64(sp)
    80005ed4:	6526                	ld	a0,72(sp)
    80005ed6:	65c6                	ld	a1,80(sp)
    80005ed8:	6666                	ld	a2,88(sp)
    80005eda:	7686                	ld	a3,96(sp)
    80005edc:	7726                	ld	a4,104(sp)
    80005ede:	77c6                	ld	a5,112(sp)
    80005ee0:	7866                	ld	a6,120(sp)
    80005ee2:	688a                	ld	a7,128(sp)
    80005ee4:	692a                	ld	s2,136(sp)
    80005ee6:	69ca                	ld	s3,144(sp)
    80005ee8:	6a6a                	ld	s4,152(sp)
    80005eea:	7a8a                	ld	s5,160(sp)
    80005eec:	7b2a                	ld	s6,168(sp)
    80005eee:	7bca                	ld	s7,176(sp)
    80005ef0:	7c6a                	ld	s8,184(sp)
    80005ef2:	6c8e                	ld	s9,192(sp)
    80005ef4:	6d2e                	ld	s10,200(sp)
    80005ef6:	6dce                	ld	s11,208(sp)
    80005ef8:	6e6e                	ld	t3,216(sp)
    80005efa:	7e8e                	ld	t4,224(sp)
    80005efc:	7f2e                	ld	t5,232(sp)
    80005efe:	7fce                	ld	t6,240(sp)
    80005f00:	6111                	addi	sp,sp,256
    80005f02:	10200073          	sret
    80005f06:	00000013          	nop
    80005f0a:	00000013          	nop
    80005f0e:	0001                	nop

0000000080005f10 <timervec>:
    80005f10:	34051573          	csrrw	a0,mscratch,a0
    80005f14:	e10c                	sd	a1,0(a0)
    80005f16:	e510                	sd	a2,8(a0)
    80005f18:	e914                	sd	a3,16(a0)
    80005f1a:	710c                	ld	a1,32(a0)
    80005f1c:	7510                	ld	a2,40(a0)
    80005f1e:	6194                	ld	a3,0(a1)
    80005f20:	96b2                	add	a3,a3,a2
    80005f22:	e194                	sd	a3,0(a1)
    80005f24:	4589                	li	a1,2
    80005f26:	14459073          	csrw	sip,a1
    80005f2a:	6914                	ld	a3,16(a0)
    80005f2c:	6510                	ld	a2,8(a0)
    80005f2e:	610c                	ld	a1,0(a0)
    80005f30:	34051573          	csrrw	a0,mscratch,a0
    80005f34:	30200073          	mret
	...

0000000080005f3a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005f3a:	1141                	addi	sp,sp,-16
    80005f3c:	e422                	sd	s0,8(sp)
    80005f3e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005f40:	0c0007b7          	lui	a5,0xc000
    80005f44:	4705                	li	a4,1
    80005f46:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005f48:	c3d8                	sw	a4,4(a5)
}
    80005f4a:	6422                	ld	s0,8(sp)
    80005f4c:	0141                	addi	sp,sp,16
    80005f4e:	8082                	ret

0000000080005f50 <plicinithart>:

void
plicinithart(void)
{
    80005f50:	1141                	addi	sp,sp,-16
    80005f52:	e406                	sd	ra,8(sp)
    80005f54:	e022                	sd	s0,0(sp)
    80005f56:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005f58:	ffffc097          	auipc	ra,0xffffc
    80005f5c:	ce2080e7          	jalr	-798(ra) # 80001c3a <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005f60:	0085171b          	slliw	a4,a0,0x8
    80005f64:	0c0027b7          	lui	a5,0xc002
    80005f68:	97ba                	add	a5,a5,a4
    80005f6a:	40200713          	li	a4,1026
    80005f6e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005f72:	00d5151b          	slliw	a0,a0,0xd
    80005f76:	0c2017b7          	lui	a5,0xc201
    80005f7a:	953e                	add	a0,a0,a5
    80005f7c:	00052023          	sw	zero,0(a0)
}
    80005f80:	60a2                	ld	ra,8(sp)
    80005f82:	6402                	ld	s0,0(sp)
    80005f84:	0141                	addi	sp,sp,16
    80005f86:	8082                	ret

0000000080005f88 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005f88:	1141                	addi	sp,sp,-16
    80005f8a:	e406                	sd	ra,8(sp)
    80005f8c:	e022                	sd	s0,0(sp)
    80005f8e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005f90:	ffffc097          	auipc	ra,0xffffc
    80005f94:	caa080e7          	jalr	-854(ra) # 80001c3a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005f98:	00d5179b          	slliw	a5,a0,0xd
    80005f9c:	0c201537          	lui	a0,0xc201
    80005fa0:	953e                	add	a0,a0,a5
  return irq;
}
    80005fa2:	4148                	lw	a0,4(a0)
    80005fa4:	60a2                	ld	ra,8(sp)
    80005fa6:	6402                	ld	s0,0(sp)
    80005fa8:	0141                	addi	sp,sp,16
    80005faa:	8082                	ret

0000000080005fac <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005fac:	1101                	addi	sp,sp,-32
    80005fae:	ec06                	sd	ra,24(sp)
    80005fb0:	e822                	sd	s0,16(sp)
    80005fb2:	e426                	sd	s1,8(sp)
    80005fb4:	1000                	addi	s0,sp,32
    80005fb6:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005fb8:	ffffc097          	auipc	ra,0xffffc
    80005fbc:	c82080e7          	jalr	-894(ra) # 80001c3a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005fc0:	00d5151b          	slliw	a0,a0,0xd
    80005fc4:	0c2017b7          	lui	a5,0xc201
    80005fc8:	97aa                	add	a5,a5,a0
    80005fca:	c3c4                	sw	s1,4(a5)
}
    80005fcc:	60e2                	ld	ra,24(sp)
    80005fce:	6442                	ld	s0,16(sp)
    80005fd0:	64a2                	ld	s1,8(sp)
    80005fd2:	6105                	addi	sp,sp,32
    80005fd4:	8082                	ret

0000000080005fd6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005fd6:	1141                	addi	sp,sp,-16
    80005fd8:	e406                	sd	ra,8(sp)
    80005fda:	e022                	sd	s0,0(sp)
    80005fdc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005fde:	479d                	li	a5,7
    80005fe0:	04a7cc63          	blt	a5,a0,80006038 <free_desc+0x62>
    panic("virtio_disk_intr 1");
  if(disk.free[i])
    80005fe4:	0003d797          	auipc	a5,0x3d
    80005fe8:	01c78793          	addi	a5,a5,28 # 80043000 <disk>
    80005fec:	00a78733          	add	a4,a5,a0
    80005ff0:	6789                	lui	a5,0x2
    80005ff2:	97ba                	add	a5,a5,a4
    80005ff4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005ff8:	eba1                	bnez	a5,80006048 <free_desc+0x72>
    panic("virtio_disk_intr 2");
  disk.desc[i].addr = 0;
    80005ffa:	00451713          	slli	a4,a0,0x4
    80005ffe:	0003f797          	auipc	a5,0x3f
    80006002:	0027b783          	ld	a5,2(a5) # 80045000 <disk+0x2000>
    80006006:	97ba                	add	a5,a5,a4
    80006008:	0007b023          	sd	zero,0(a5)
  disk.free[i] = 1;
    8000600c:	0003d797          	auipc	a5,0x3d
    80006010:	ff478793          	addi	a5,a5,-12 # 80043000 <disk>
    80006014:	97aa                	add	a5,a5,a0
    80006016:	6509                	lui	a0,0x2
    80006018:	953e                	add	a0,a0,a5
    8000601a:	4785                	li	a5,1
    8000601c:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80006020:	0003f517          	auipc	a0,0x3f
    80006024:	ff850513          	addi	a0,a0,-8 # 80045018 <disk+0x2018>
    80006028:	ffffc097          	auipc	ra,0xffffc
    8000602c:	5d2080e7          	jalr	1490(ra) # 800025fa <wakeup>
}
    80006030:	60a2                	ld	ra,8(sp)
    80006032:	6402                	ld	s0,0(sp)
    80006034:	0141                	addi	sp,sp,16
    80006036:	8082                	ret
    panic("virtio_disk_intr 1");
    80006038:	00002517          	auipc	a0,0x2
    8000603c:	7a850513          	addi	a0,a0,1960 # 800087e0 <syscalls+0x348>
    80006040:	ffffa097          	auipc	ra,0xffffa
    80006044:	5a4080e7          	jalr	1444(ra) # 800005e4 <panic>
    panic("virtio_disk_intr 2");
    80006048:	00002517          	auipc	a0,0x2
    8000604c:	7b050513          	addi	a0,a0,1968 # 800087f8 <syscalls+0x360>
    80006050:	ffffa097          	auipc	ra,0xffffa
    80006054:	594080e7          	jalr	1428(ra) # 800005e4 <panic>

0000000080006058 <virtio_disk_init>:
{
    80006058:	1101                	addi	sp,sp,-32
    8000605a:	ec06                	sd	ra,24(sp)
    8000605c:	e822                	sd	s0,16(sp)
    8000605e:	e426                	sd	s1,8(sp)
    80006060:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006062:	00002597          	auipc	a1,0x2
    80006066:	7ae58593          	addi	a1,a1,1966 # 80008810 <syscalls+0x378>
    8000606a:	0003f517          	auipc	a0,0x3f
    8000606e:	03e50513          	addi	a0,a0,62 # 800450a8 <disk+0x20a8>
    80006072:	ffffb097          	auipc	ra,0xffffb
    80006076:	c38080e7          	jalr	-968(ra) # 80000caa <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000607a:	100017b7          	lui	a5,0x10001
    8000607e:	4398                	lw	a4,0(a5)
    80006080:	2701                	sext.w	a4,a4
    80006082:	747277b7          	lui	a5,0x74727
    80006086:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000608a:	0ef71163          	bne	a4,a5,8000616c <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000608e:	100017b7          	lui	a5,0x10001
    80006092:	43dc                	lw	a5,4(a5)
    80006094:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006096:	4705                	li	a4,1
    80006098:	0ce79a63          	bne	a5,a4,8000616c <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000609c:	100017b7          	lui	a5,0x10001
    800060a0:	479c                	lw	a5,8(a5)
    800060a2:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800060a4:	4709                	li	a4,2
    800060a6:	0ce79363          	bne	a5,a4,8000616c <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800060aa:	100017b7          	lui	a5,0x10001
    800060ae:	47d8                	lw	a4,12(a5)
    800060b0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800060b2:	554d47b7          	lui	a5,0x554d4
    800060b6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800060ba:	0af71963          	bne	a4,a5,8000616c <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800060be:	100017b7          	lui	a5,0x10001
    800060c2:	4705                	li	a4,1
    800060c4:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800060c6:	470d                	li	a4,3
    800060c8:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800060ca:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800060cc:	c7ffe737          	lui	a4,0xc7ffe
    800060d0:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fb875f>
    800060d4:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800060d6:	2701                	sext.w	a4,a4
    800060d8:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800060da:	472d                	li	a4,11
    800060dc:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800060de:	473d                	li	a4,15
    800060e0:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800060e2:	6705                	lui	a4,0x1
    800060e4:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800060e6:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800060ea:	5bdc                	lw	a5,52(a5)
    800060ec:	2781                	sext.w	a5,a5
  if(max == 0)
    800060ee:	c7d9                	beqz	a5,8000617c <virtio_disk_init+0x124>
  if(max < NUM)
    800060f0:	471d                	li	a4,7
    800060f2:	08f77d63          	bgeu	a4,a5,8000618c <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800060f6:	100014b7          	lui	s1,0x10001
    800060fa:	47a1                	li	a5,8
    800060fc:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800060fe:	6609                	lui	a2,0x2
    80006100:	4581                	li	a1,0
    80006102:	0003d517          	auipc	a0,0x3d
    80006106:	efe50513          	addi	a0,a0,-258 # 80043000 <disk>
    8000610a:	ffffb097          	auipc	ra,0xffffb
    8000610e:	d2c080e7          	jalr	-724(ra) # 80000e36 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80006112:	0003d717          	auipc	a4,0x3d
    80006116:	eee70713          	addi	a4,a4,-274 # 80043000 <disk>
    8000611a:	00c75793          	srli	a5,a4,0xc
    8000611e:	2781                	sext.w	a5,a5
    80006120:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct VRingDesc *) disk.pages;
    80006122:	0003f797          	auipc	a5,0x3f
    80006126:	ede78793          	addi	a5,a5,-290 # 80045000 <disk+0x2000>
    8000612a:	e398                	sd	a4,0(a5)
  disk.avail = (uint16*)(((char*)disk.desc) + NUM*sizeof(struct VRingDesc));
    8000612c:	0003d717          	auipc	a4,0x3d
    80006130:	f5470713          	addi	a4,a4,-172 # 80043080 <disk+0x80>
    80006134:	e798                	sd	a4,8(a5)
  disk.used = (struct UsedArea *) (disk.pages + PGSIZE);
    80006136:	0003e717          	auipc	a4,0x3e
    8000613a:	eca70713          	addi	a4,a4,-310 # 80044000 <disk+0x1000>
    8000613e:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80006140:	4705                	li	a4,1
    80006142:	00e78c23          	sb	a4,24(a5)
    80006146:	00e78ca3          	sb	a4,25(a5)
    8000614a:	00e78d23          	sb	a4,26(a5)
    8000614e:	00e78da3          	sb	a4,27(a5)
    80006152:	00e78e23          	sb	a4,28(a5)
    80006156:	00e78ea3          	sb	a4,29(a5)
    8000615a:	00e78f23          	sb	a4,30(a5)
    8000615e:	00e78fa3          	sb	a4,31(a5)
}
    80006162:	60e2                	ld	ra,24(sp)
    80006164:	6442                	ld	s0,16(sp)
    80006166:	64a2                	ld	s1,8(sp)
    80006168:	6105                	addi	sp,sp,32
    8000616a:	8082                	ret
    panic("could not find virtio disk");
    8000616c:	00002517          	auipc	a0,0x2
    80006170:	6b450513          	addi	a0,a0,1716 # 80008820 <syscalls+0x388>
    80006174:	ffffa097          	auipc	ra,0xffffa
    80006178:	470080e7          	jalr	1136(ra) # 800005e4 <panic>
    panic("virtio disk has no queue 0");
    8000617c:	00002517          	auipc	a0,0x2
    80006180:	6c450513          	addi	a0,a0,1732 # 80008840 <syscalls+0x3a8>
    80006184:	ffffa097          	auipc	ra,0xffffa
    80006188:	460080e7          	jalr	1120(ra) # 800005e4 <panic>
    panic("virtio disk max queue too short");
    8000618c:	00002517          	auipc	a0,0x2
    80006190:	6d450513          	addi	a0,a0,1748 # 80008860 <syscalls+0x3c8>
    80006194:	ffffa097          	auipc	ra,0xffffa
    80006198:	450080e7          	jalr	1104(ra) # 800005e4 <panic>

000000008000619c <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    8000619c:	7175                	addi	sp,sp,-144
    8000619e:	e506                	sd	ra,136(sp)
    800061a0:	e122                	sd	s0,128(sp)
    800061a2:	fca6                	sd	s1,120(sp)
    800061a4:	f8ca                	sd	s2,112(sp)
    800061a6:	f4ce                	sd	s3,104(sp)
    800061a8:	f0d2                	sd	s4,96(sp)
    800061aa:	ecd6                	sd	s5,88(sp)
    800061ac:	e8da                	sd	s6,80(sp)
    800061ae:	e4de                	sd	s7,72(sp)
    800061b0:	e0e2                	sd	s8,64(sp)
    800061b2:	fc66                	sd	s9,56(sp)
    800061b4:	f86a                	sd	s10,48(sp)
    800061b6:	f46e                	sd	s11,40(sp)
    800061b8:	0900                	addi	s0,sp,144
    800061ba:	8aaa                	mv	s5,a0
    800061bc:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800061be:	00c52c83          	lw	s9,12(a0)
    800061c2:	001c9c9b          	slliw	s9,s9,0x1
    800061c6:	1c82                	slli	s9,s9,0x20
    800061c8:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800061cc:	0003f517          	auipc	a0,0x3f
    800061d0:	edc50513          	addi	a0,a0,-292 # 800450a8 <disk+0x20a8>
    800061d4:	ffffb097          	auipc	ra,0xffffb
    800061d8:	b66080e7          	jalr	-1178(ra) # 80000d3a <acquire>
  for(int i = 0; i < 3; i++){
    800061dc:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800061de:	44a1                	li	s1,8
      disk.free[i] = 0;
    800061e0:	0003dc17          	auipc	s8,0x3d
    800061e4:	e20c0c13          	addi	s8,s8,-480 # 80043000 <disk>
    800061e8:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    800061ea:	4b0d                	li	s6,3
    800061ec:	a0ad                	j	80006256 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    800061ee:	00fc0733          	add	a4,s8,a5
    800061f2:	975e                	add	a4,a4,s7
    800061f4:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800061f8:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800061fa:	0207c563          	bltz	a5,80006224 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800061fe:	2905                	addiw	s2,s2,1
    80006200:	0611                	addi	a2,a2,4
    80006202:	19690d63          	beq	s2,s6,8000639c <virtio_disk_rw+0x200>
    idx[i] = alloc_desc();
    80006206:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006208:	0003f717          	auipc	a4,0x3f
    8000620c:	e1070713          	addi	a4,a4,-496 # 80045018 <disk+0x2018>
    80006210:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80006212:	00074683          	lbu	a3,0(a4)
    80006216:	fee1                	bnez	a3,800061ee <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80006218:	2785                	addiw	a5,a5,1
    8000621a:	0705                	addi	a4,a4,1
    8000621c:	fe979be3          	bne	a5,s1,80006212 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80006220:	57fd                	li	a5,-1
    80006222:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80006224:	01205d63          	blez	s2,8000623e <virtio_disk_rw+0xa2>
    80006228:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    8000622a:	000a2503          	lw	a0,0(s4)
    8000622e:	00000097          	auipc	ra,0x0
    80006232:	da8080e7          	jalr	-600(ra) # 80005fd6 <free_desc>
      for(int j = 0; j < i; j++)
    80006236:	2d85                	addiw	s11,s11,1
    80006238:	0a11                	addi	s4,s4,4
    8000623a:	ffb918e3          	bne	s2,s11,8000622a <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000623e:	0003f597          	auipc	a1,0x3f
    80006242:	e6a58593          	addi	a1,a1,-406 # 800450a8 <disk+0x20a8>
    80006246:	0003f517          	auipc	a0,0x3f
    8000624a:	dd250513          	addi	a0,a0,-558 # 80045018 <disk+0x2018>
    8000624e:	ffffc097          	auipc	ra,0xffffc
    80006252:	22c080e7          	jalr	556(ra) # 8000247a <sleep>
  for(int i = 0; i < 3; i++){
    80006256:	f8040a13          	addi	s4,s0,-128
{
    8000625a:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    8000625c:	894e                	mv	s2,s3
    8000625e:	b765                	j	80006206 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80006260:	0003f717          	auipc	a4,0x3f
    80006264:	da073703          	ld	a4,-608(a4) # 80045000 <disk+0x2000>
    80006268:	973e                	add	a4,a4,a5
    8000626a:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000626e:	0003d517          	auipc	a0,0x3d
    80006272:	d9250513          	addi	a0,a0,-622 # 80043000 <disk>
    80006276:	0003f717          	auipc	a4,0x3f
    8000627a:	d8a70713          	addi	a4,a4,-630 # 80045000 <disk+0x2000>
    8000627e:	6314                	ld	a3,0(a4)
    80006280:	96be                	add	a3,a3,a5
    80006282:	00c6d603          	lhu	a2,12(a3)
    80006286:	00166613          	ori	a2,a2,1
    8000628a:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000628e:	f8842683          	lw	a3,-120(s0)
    80006292:	6310                	ld	a2,0(a4)
    80006294:	97b2                	add	a5,a5,a2
    80006296:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0;
    8000629a:	20048613          	addi	a2,s1,512 # 10001200 <_entry-0x6fffee00>
    8000629e:	0612                	slli	a2,a2,0x4
    800062a0:	962a                	add	a2,a2,a0
    800062a2:	02060823          	sb	zero,48(a2) # 2030 <_entry-0x7fffdfd0>
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800062a6:	00469793          	slli	a5,a3,0x4
    800062aa:	630c                	ld	a1,0(a4)
    800062ac:	95be                	add	a1,a1,a5
    800062ae:	6689                	lui	a3,0x2
    800062b0:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    800062b4:	96ca                	add	a3,a3,s2
    800062b6:	96aa                	add	a3,a3,a0
    800062b8:	e194                	sd	a3,0(a1)
  disk.desc[idx[2]].len = 1;
    800062ba:	6314                	ld	a3,0(a4)
    800062bc:	96be                	add	a3,a3,a5
    800062be:	4585                	li	a1,1
    800062c0:	c68c                	sw	a1,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800062c2:	6314                	ld	a3,0(a4)
    800062c4:	96be                	add	a3,a3,a5
    800062c6:	4509                	li	a0,2
    800062c8:	00a69623          	sh	a0,12(a3)
  disk.desc[idx[2]].next = 0;
    800062cc:	6314                	ld	a3,0(a4)
    800062ce:	97b6                	add	a5,a5,a3
    800062d0:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800062d4:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    800062d8:	03563423          	sd	s5,40(a2)

  // avail[0] is flags
  // avail[1] tells the device how far to look in avail[2...].
  // avail[2...] are desc[] indices the device should process.
  // we only tell device the first index in our chain of descriptors.
  disk.avail[2 + (disk.avail[1] % NUM)] = idx[0];
    800062dc:	6714                	ld	a3,8(a4)
    800062de:	0026d783          	lhu	a5,2(a3)
    800062e2:	8b9d                	andi	a5,a5,7
    800062e4:	0789                	addi	a5,a5,2
    800062e6:	0786                	slli	a5,a5,0x1
    800062e8:	97b6                	add	a5,a5,a3
    800062ea:	00979023          	sh	s1,0(a5)
  __sync_synchronize();
    800062ee:	0ff0000f          	fence
  disk.avail[1] = disk.avail[1] + 1;
    800062f2:	6718                	ld	a4,8(a4)
    800062f4:	00275783          	lhu	a5,2(a4)
    800062f8:	2785                	addiw	a5,a5,1
    800062fa:	00f71123          	sh	a5,2(a4)

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800062fe:	100017b7          	lui	a5,0x10001
    80006302:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006306:	004aa783          	lw	a5,4(s5)
    8000630a:	02b79163          	bne	a5,a1,8000632c <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    8000630e:	0003f917          	auipc	s2,0x3f
    80006312:	d9a90913          	addi	s2,s2,-614 # 800450a8 <disk+0x20a8>
  while(b->disk == 1) {
    80006316:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80006318:	85ca                	mv	a1,s2
    8000631a:	8556                	mv	a0,s5
    8000631c:	ffffc097          	auipc	ra,0xffffc
    80006320:	15e080e7          	jalr	350(ra) # 8000247a <sleep>
  while(b->disk == 1) {
    80006324:	004aa783          	lw	a5,4(s5)
    80006328:	fe9788e3          	beq	a5,s1,80006318 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    8000632c:	f8042483          	lw	s1,-128(s0)
    80006330:	20048793          	addi	a5,s1,512
    80006334:	00479713          	slli	a4,a5,0x4
    80006338:	0003d797          	auipc	a5,0x3d
    8000633c:	cc878793          	addi	a5,a5,-824 # 80043000 <disk>
    80006340:	97ba                	add	a5,a5,a4
    80006342:	0207b423          	sd	zero,40(a5)
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    80006346:	0003f917          	auipc	s2,0x3f
    8000634a:	cba90913          	addi	s2,s2,-838 # 80045000 <disk+0x2000>
    8000634e:	a019                	j	80006354 <virtio_disk_rw+0x1b8>
      i = disk.desc[i].next;
    80006350:	00e4d483          	lhu	s1,14(s1)
    free_desc(i);
    80006354:	8526                	mv	a0,s1
    80006356:	00000097          	auipc	ra,0x0
    8000635a:	c80080e7          	jalr	-896(ra) # 80005fd6 <free_desc>
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    8000635e:	0492                	slli	s1,s1,0x4
    80006360:	00093783          	ld	a5,0(s2)
    80006364:	94be                	add	s1,s1,a5
    80006366:	00c4d783          	lhu	a5,12(s1)
    8000636a:	8b85                	andi	a5,a5,1
    8000636c:	f3f5                	bnez	a5,80006350 <virtio_disk_rw+0x1b4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000636e:	0003f517          	auipc	a0,0x3f
    80006372:	d3a50513          	addi	a0,a0,-710 # 800450a8 <disk+0x20a8>
    80006376:	ffffb097          	auipc	ra,0xffffb
    8000637a:	a78080e7          	jalr	-1416(ra) # 80000dee <release>
}
    8000637e:	60aa                	ld	ra,136(sp)
    80006380:	640a                	ld	s0,128(sp)
    80006382:	74e6                	ld	s1,120(sp)
    80006384:	7946                	ld	s2,112(sp)
    80006386:	79a6                	ld	s3,104(sp)
    80006388:	7a06                	ld	s4,96(sp)
    8000638a:	6ae6                	ld	s5,88(sp)
    8000638c:	6b46                	ld	s6,80(sp)
    8000638e:	6ba6                	ld	s7,72(sp)
    80006390:	6c06                	ld	s8,64(sp)
    80006392:	7ce2                	ld	s9,56(sp)
    80006394:	7d42                	ld	s10,48(sp)
    80006396:	7da2                	ld	s11,40(sp)
    80006398:	6149                	addi	sp,sp,144
    8000639a:	8082                	ret
  if(write)
    8000639c:	01a037b3          	snez	a5,s10
    800063a0:	f6f42823          	sw	a5,-144(s0)
  buf0.reserved = 0;
    800063a4:	f6042a23          	sw	zero,-140(s0)
  buf0.sector = sector;
    800063a8:	f7943c23          	sd	s9,-136(s0)
  disk.desc[idx[0]].addr = (uint64) kvmpa((uint64) &buf0);
    800063ac:	f8042483          	lw	s1,-128(s0)
    800063b0:	00449913          	slli	s2,s1,0x4
    800063b4:	0003f997          	auipc	s3,0x3f
    800063b8:	c4c98993          	addi	s3,s3,-948 # 80045000 <disk+0x2000>
    800063bc:	0009ba03          	ld	s4,0(s3)
    800063c0:	9a4a                	add	s4,s4,s2
    800063c2:	f7040513          	addi	a0,s0,-144
    800063c6:	ffffb097          	auipc	ra,0xffffb
    800063ca:	e36080e7          	jalr	-458(ra) # 800011fc <kvmpa>
    800063ce:	00aa3023          	sd	a0,0(s4)
  disk.desc[idx[0]].len = sizeof(buf0);
    800063d2:	0009b783          	ld	a5,0(s3)
    800063d6:	97ca                	add	a5,a5,s2
    800063d8:	4741                	li	a4,16
    800063da:	c798                	sw	a4,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800063dc:	0009b783          	ld	a5,0(s3)
    800063e0:	97ca                	add	a5,a5,s2
    800063e2:	4705                	li	a4,1
    800063e4:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[0]].next = idx[1];
    800063e8:	f8442783          	lw	a5,-124(s0)
    800063ec:	0009b703          	ld	a4,0(s3)
    800063f0:	974a                	add	a4,a4,s2
    800063f2:	00f71723          	sh	a5,14(a4)
  disk.desc[idx[1]].addr = (uint64) b->data;
    800063f6:	0792                	slli	a5,a5,0x4
    800063f8:	0009b703          	ld	a4,0(s3)
    800063fc:	973e                	add	a4,a4,a5
    800063fe:	058a8693          	addi	a3,s5,88
    80006402:	e314                	sd	a3,0(a4)
  disk.desc[idx[1]].len = BSIZE;
    80006404:	0009b703          	ld	a4,0(s3)
    80006408:	973e                	add	a4,a4,a5
    8000640a:	40000693          	li	a3,1024
    8000640e:	c714                	sw	a3,8(a4)
  if(write)
    80006410:	e40d18e3          	bnez	s10,80006260 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80006414:	0003f717          	auipc	a4,0x3f
    80006418:	bec73703          	ld	a4,-1044(a4) # 80045000 <disk+0x2000>
    8000641c:	973e                	add	a4,a4,a5
    8000641e:	4689                	li	a3,2
    80006420:	00d71623          	sh	a3,12(a4)
    80006424:	b5a9                	j	8000626e <virtio_disk_rw+0xd2>

0000000080006426 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006426:	1101                	addi	sp,sp,-32
    80006428:	ec06                	sd	ra,24(sp)
    8000642a:	e822                	sd	s0,16(sp)
    8000642c:	e426                	sd	s1,8(sp)
    8000642e:	e04a                	sd	s2,0(sp)
    80006430:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006432:	0003f517          	auipc	a0,0x3f
    80006436:	c7650513          	addi	a0,a0,-906 # 800450a8 <disk+0x20a8>
    8000643a:	ffffb097          	auipc	ra,0xffffb
    8000643e:	900080e7          	jalr	-1792(ra) # 80000d3a <acquire>

  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    80006442:	0003f717          	auipc	a4,0x3f
    80006446:	bbe70713          	addi	a4,a4,-1090 # 80045000 <disk+0x2000>
    8000644a:	02075783          	lhu	a5,32(a4)
    8000644e:	6b18                	ld	a4,16(a4)
    80006450:	00275683          	lhu	a3,2(a4)
    80006454:	8ebd                	xor	a3,a3,a5
    80006456:	8a9d                	andi	a3,a3,7
    80006458:	cab9                	beqz	a3,800064ae <virtio_disk_intr+0x88>
    int id = disk.used->elems[disk.used_idx].id;

    if(disk.info[id].status != 0)
    8000645a:	0003d917          	auipc	s2,0x3d
    8000645e:	ba690913          	addi	s2,s2,-1114 # 80043000 <disk>
      panic("virtio_disk_intr status");
    
    disk.info[id].b->disk = 0;   // disk is done with buf
    wakeup(disk.info[id].b);

    disk.used_idx = (disk.used_idx + 1) % NUM;
    80006462:	0003f497          	auipc	s1,0x3f
    80006466:	b9e48493          	addi	s1,s1,-1122 # 80045000 <disk+0x2000>
    int id = disk.used->elems[disk.used_idx].id;
    8000646a:	078e                	slli	a5,a5,0x3
    8000646c:	97ba                	add	a5,a5,a4
    8000646e:	43dc                	lw	a5,4(a5)
    if(disk.info[id].status != 0)
    80006470:	20078713          	addi	a4,a5,512
    80006474:	0712                	slli	a4,a4,0x4
    80006476:	974a                	add	a4,a4,s2
    80006478:	03074703          	lbu	a4,48(a4)
    8000647c:	ef21                	bnez	a4,800064d4 <virtio_disk_intr+0xae>
    disk.info[id].b->disk = 0;   // disk is done with buf
    8000647e:	20078793          	addi	a5,a5,512
    80006482:	0792                	slli	a5,a5,0x4
    80006484:	97ca                	add	a5,a5,s2
    80006486:	7798                	ld	a4,40(a5)
    80006488:	00072223          	sw	zero,4(a4)
    wakeup(disk.info[id].b);
    8000648c:	7788                	ld	a0,40(a5)
    8000648e:	ffffc097          	auipc	ra,0xffffc
    80006492:	16c080e7          	jalr	364(ra) # 800025fa <wakeup>
    disk.used_idx = (disk.used_idx + 1) % NUM;
    80006496:	0204d783          	lhu	a5,32(s1)
    8000649a:	2785                	addiw	a5,a5,1
    8000649c:	8b9d                	andi	a5,a5,7
    8000649e:	02f49023          	sh	a5,32(s1)
  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    800064a2:	6898                	ld	a4,16(s1)
    800064a4:	00275683          	lhu	a3,2(a4)
    800064a8:	8a9d                	andi	a3,a3,7
    800064aa:	fcf690e3          	bne	a3,a5,8000646a <virtio_disk_intr+0x44>
  }
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800064ae:	10001737          	lui	a4,0x10001
    800064b2:	533c                	lw	a5,96(a4)
    800064b4:	8b8d                	andi	a5,a5,3
    800064b6:	d37c                	sw	a5,100(a4)

  release(&disk.vdisk_lock);
    800064b8:	0003f517          	auipc	a0,0x3f
    800064bc:	bf050513          	addi	a0,a0,-1040 # 800450a8 <disk+0x20a8>
    800064c0:	ffffb097          	auipc	ra,0xffffb
    800064c4:	92e080e7          	jalr	-1746(ra) # 80000dee <release>
}
    800064c8:	60e2                	ld	ra,24(sp)
    800064ca:	6442                	ld	s0,16(sp)
    800064cc:	64a2                	ld	s1,8(sp)
    800064ce:	6902                	ld	s2,0(sp)
    800064d0:	6105                	addi	sp,sp,32
    800064d2:	8082                	ret
      panic("virtio_disk_intr status");
    800064d4:	00002517          	auipc	a0,0x2
    800064d8:	3ac50513          	addi	a0,a0,940 # 80008880 <syscalls+0x3e8>
    800064dc:	ffffa097          	auipc	ra,0xffffa
    800064e0:	108080e7          	jalr	264(ra) # 800005e4 <panic>

00000000800064e4 <mem_init>:
  page_t *next_page;
} allocator_t;

static allocator_t alloc;
static int if_init = 0;
void mem_init() {
    800064e4:	1141                	addi	sp,sp,-16
    800064e6:	e406                	sd	ra,8(sp)
    800064e8:	e022                	sd	s0,0(sp)
    800064ea:	0800                	addi	s0,sp,16
  alloc.next_page = kalloc();
    800064ec:	ffffa097          	auipc	ra,0xffffa
    800064f0:	710080e7          	jalr	1808(ra) # 80000bfc <kalloc>
    800064f4:	00003797          	auipc	a5,0x3
    800064f8:	b2a7be23          	sd	a0,-1220(a5) # 80009030 <alloc>
  page_t *p = (page_t *)alloc.next_page;
  p->cur = (void *)p + sizeof(page_t);
    800064fc:	00850793          	addi	a5,a0,8
    80006500:	e11c                	sd	a5,0(a0)
}
    80006502:	60a2                	ld	ra,8(sp)
    80006504:	6402                	ld	s0,0(sp)
    80006506:	0141                	addi	sp,sp,16
    80006508:	8082                	ret

000000008000650a <mallo>:

void *mallo(u32 size) {
    8000650a:	1101                	addi	sp,sp,-32
    8000650c:	ec06                	sd	ra,24(sp)
    8000650e:	e822                	sd	s0,16(sp)
    80006510:	e426                	sd	s1,8(sp)
    80006512:	1000                	addi	s0,sp,32
    80006514:	84aa                	mv	s1,a0
  if (!if_init) {
    80006516:	00003797          	auipc	a5,0x3
    8000651a:	b127a783          	lw	a5,-1262(a5) # 80009028 <if_init>
    8000651e:	cf9d                	beqz	a5,8000655c <mallo+0x52>
    mem_init();
    if_init = 1;
  }
  void *res = 0;
  printf("size %d ", size);
    80006520:	85a6                	mv	a1,s1
    80006522:	00002517          	auipc	a0,0x2
    80006526:	37650513          	addi	a0,a0,886 # 80008898 <syscalls+0x400>
    8000652a:	ffffa097          	auipc	ra,0xffffa
    8000652e:	10c080e7          	jalr	268(ra) # 80000636 <printf>
  u32 avail = PGSIZE - (alloc.next_page->cur - (void *)(alloc.next_page)) -
    80006532:	00003717          	auipc	a4,0x3
    80006536:	afe73703          	ld	a4,-1282(a4) # 80009030 <alloc>
    8000653a:	6308                	ld	a0,0(a4)
    8000653c:	40e506b3          	sub	a3,a0,a4
              sizeof(page_t);
  if (avail > size) {
    80006540:	6785                	lui	a5,0x1
    80006542:	37e1                	addiw	a5,a5,-8
    80006544:	9f95                	subw	a5,a5,a3
    80006546:	02f4f563          	bgeu	s1,a5,80006570 <mallo+0x66>
    res = alloc.next_page->cur;
    alloc.next_page->cur += size;
    8000654a:	1482                	slli	s1,s1,0x20
    8000654c:	9081                	srli	s1,s1,0x20
    8000654e:	94aa                	add	s1,s1,a0
    80006550:	e304                	sd	s1,0(a4)
  } else {
    printf("malloc failed");
    return 0;
  }
  return res;
}
    80006552:	60e2                	ld	ra,24(sp)
    80006554:	6442                	ld	s0,16(sp)
    80006556:	64a2                	ld	s1,8(sp)
    80006558:	6105                	addi	sp,sp,32
    8000655a:	8082                	ret
    mem_init();
    8000655c:	00000097          	auipc	ra,0x0
    80006560:	f88080e7          	jalr	-120(ra) # 800064e4 <mem_init>
    if_init = 1;
    80006564:	4785                	li	a5,1
    80006566:	00003717          	auipc	a4,0x3
    8000656a:	acf72123          	sw	a5,-1342(a4) # 80009028 <if_init>
    8000656e:	bf4d                	j	80006520 <mallo+0x16>
    printf("malloc failed");
    80006570:	00002517          	auipc	a0,0x2
    80006574:	33850513          	addi	a0,a0,824 # 800088a8 <syscalls+0x410>
    80006578:	ffffa097          	auipc	ra,0xffffa
    8000657c:	0be080e7          	jalr	190(ra) # 80000636 <printf>
    return 0;
    80006580:	4501                	li	a0,0
    80006582:	bfc1                	j	80006552 <mallo+0x48>

0000000080006584 <free>:

    80006584:	1141                	addi	sp,sp,-16
    80006586:	e422                	sd	s0,8(sp)
    80006588:	0800                	addi	s0,sp,16
    8000658a:	6422                	ld	s0,8(sp)
    8000658c:	0141                	addi	sp,sp,16
    8000658e:	8082                	ret
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
