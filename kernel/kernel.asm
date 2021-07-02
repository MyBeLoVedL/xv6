
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
    80000060:	0f478793          	addi	a5,a5,244 # 80006150 <timervec>
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
    800000aa:	17e78793          	addi	a5,a5,382 # 80001224 <main>
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
    80000110:	e6e080e7          	jalr	-402(ra) # 80000f7a <acquire>
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
    80000126:	00003097          	auipc	ra,0x3
    8000012a:	844080e7          	jalr	-1980(ra) # 8000296a <either_copyin>
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
    80000152:	ee0080e7          	jalr	-288(ra) # 8000102e <release>

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
    800001a0:	dde080e7          	jalr	-546(ra) # 80000f7a <acquire>
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
    800001ce:	cdc080e7          	jalr	-804(ra) # 80001ea6 <myproc>
    800001d2:	591c                	lw	a5,48(a0)
    800001d4:	e7b5                	bnez	a5,80000240 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    800001d6:	85a6                	mv	a1,s1
    800001d8:	854a                	mv	a0,s2
    800001da:	00002097          	auipc	ra,0x2
    800001de:	4e0080e7          	jalr	1248(ra) # 800026ba <sleep>
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
    8000021a:	6fe080e7          	jalr	1790(ra) # 80002914 <either_copyout>
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
    80000236:	dfc080e7          	jalr	-516(ra) # 8000102e <release>

  return target - n;
    8000023a:	413b053b          	subw	a0,s6,s3
    8000023e:	a811                	j	80000252 <consoleread+0xe4>
        release(&cons.lock);
    80000240:	00011517          	auipc	a0,0x11
    80000244:	60050513          	addi	a0,a0,1536 # 80011840 <cons>
    80000248:	00001097          	auipc	ra,0x1
    8000024c:	de6080e7          	jalr	-538(ra) # 8000102e <release>
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
    800002dc:	ca2080e7          	jalr	-862(ra) # 80000f7a <acquire>

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
    800002fa:	6ca080e7          	jalr	1738(ra) # 800029c0 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002fe:	00011517          	auipc	a0,0x11
    80000302:	54250513          	addi	a0,a0,1346 # 80011840 <cons>
    80000306:	00001097          	auipc	ra,0x1
    8000030a:	d28080e7          	jalr	-728(ra) # 8000102e <release>
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
    8000044e:	3f0080e7          	jalr	1008(ra) # 8000283a <wakeup>
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
    80000470:	a7e080e7          	jalr	-1410(ra) # 80000eea <initlock>

  uartinit();
    80000474:	00000097          	auipc	ra,0x0
    80000478:	3a2080e7          	jalr	930(ra) # 80000816 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000047c:	00041797          	auipc	a5,0x41
    80000480:	69478793          	addi	a5,a5,1684 # 80041b10 <devsw>
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
    8000055e:	00001097          	auipc	ra,0x1
    80000562:	98c080e7          	jalr	-1652(ra) # 80000eea <initlock>
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
    80000616:	b7650513          	addi	a0,a0,-1162 # 80008188 <digits+0x120>
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
    800006ae:	00001097          	auipc	ra,0x1
    800006b2:	8cc080e7          	jalr	-1844(ra) # 80000f7a <acquire>
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
    8000080c:	00001097          	auipc	ra,0x1
    80000810:	822080e7          	jalr	-2014(ra) # 8000102e <release>
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
    8000085a:	694080e7          	jalr	1684(ra) # 80000eea <initlock>
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
    80000876:	6bc080e7          	jalr	1724(ra) # 80000f2e <push_off>

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
    800008a4:	72e080e7          	jalr	1838(ra) # 80000fce <pop_off>
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
    8000091e:	f20080e7          	jalr	-224(ra) # 8000283a <wakeup>
    
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
    80000962:	61c080e7          	jalr	1564(ra) # 80000f7a <acquire>
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
    800009b8:	d06080e7          	jalr	-762(ra) # 800026ba <sleep>
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
    800009fe:	634080e7          	jalr	1588(ra) # 8000102e <release>
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
    80000a6a:	514080e7          	jalr	1300(ra) # 80000f7a <acquire>
  uartstart();
    80000a6e:	00000097          	auipc	ra,0x0
    80000a72:	e44080e7          	jalr	-444(ra) # 800008b2 <uartstart>
  release(&uart_tx_lock);
    80000a76:	8526                	mv	a0,s1
    80000a78:	00000097          	auipc	ra,0x0
    80000a7c:	5b6080e7          	jalr	1462(ra) # 8000102e <release>
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
    80000a8a:	7139                	addi	sp,sp,-64
    80000a8c:	fc06                	sd	ra,56(sp)
    80000a8e:	f822                	sd	s0,48(sp)
    80000a90:	f426                	sd	s1,40(sp)
    80000a92:	f04a                	sd	s2,32(sp)
    80000a94:	ec4e                	sd	s3,24(sp)
    80000a96:	e852                	sd	s4,16(sp)
    80000a98:	e456                	sd	s5,8(sp)
    80000a9a:	0080                	addi	s0,sp,64
  struct run *r;

  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000a9c:	03451793          	slli	a5,a0,0x34
    80000aa0:	e3ed                	bnez	a5,80000b82 <kfree+0xf8>
    80000aa2:	84aa                	mv	s1,a0
    80000aa4:	00045797          	auipc	a5,0x45
    80000aa8:	55c78793          	addi	a5,a5,1372 # 80046000 <end>
    80000aac:	0cf56b63          	bltu	a0,a5,80000b82 <kfree+0xf8>
    80000ab0:	47c5                	li	a5,17
    80000ab2:	07ee                	slli	a5,a5,0x1b
    80000ab4:	0cf57763          	bgeu	a0,a5,80000b82 <kfree+0xf8>
    panic("kfree");

  acquire(&ref_lock);
    80000ab8:	00011517          	auipc	a0,0x11
    80000abc:	e8850513          	addi	a0,a0,-376 # 80011940 <ref_lock>
    80000ac0:	00000097          	auipc	ra,0x0
    80000ac4:	4ba080e7          	jalr	1210(ra) # 80000f7a <acquire>
  if (page_ref_count[REF_IDX(pa)] > 0) {
    80000ac8:	77fd                	lui	a5,0xfffff
    80000aca:	8fe5                	and	a5,a5,s1
    80000acc:	80000737          	lui	a4,0x80000
    80000ad0:	97ba                	add	a5,a5,a4
    80000ad2:	00c7d693          	srli	a3,a5,0xc
    80000ad6:	83a9                	srli	a5,a5,0xa
    80000ad8:	00011717          	auipc	a4,0x11
    80000adc:	fd870713          	addi	a4,a4,-40 # 80011ab0 <page_ref_count>
    80000ae0:	97ba                	add	a5,a5,a4
    80000ae2:	439c                	lw	a5,0(a5)
    80000ae4:	00f05a63          	blez	a5,80000af8 <kfree+0x6e>
    page_ref_count[REF_IDX(pa)] -= 1;
    80000ae8:	37fd                	addiw	a5,a5,-1
    80000aea:	0007861b          	sext.w	a2,a5
    80000aee:	068a                	slli	a3,a3,0x2
    80000af0:	96ba                	add	a3,a3,a4
    80000af2:	c29c                	sw	a5,0(a3)
    if (page_ref_count[REF_IDX(pa)] > 0) {
    80000af4:	08c04f63          	bgtz	a2,80000b92 <kfree+0x108>
      release(&ref_lock);
      return;
    }
  }
  release(&ref_lock);
    80000af8:	00011a17          	auipc	s4,0x11
    80000afc:	e48a0a13          	addi	s4,s4,-440 # 80011940 <ref_lock>
    80000b00:	8552                	mv	a0,s4
    80000b02:	00000097          	auipc	ra,0x0
    80000b06:	52c080e7          	jalr	1324(ra) # 8000102e <release>
  push_off();
    80000b0a:	00000097          	auipc	ra,0x0
    80000b0e:	424080e7          	jalr	1060(ra) # 80000f2e <push_off>
  int cpu_id = cpuid();
    80000b12:	00001097          	auipc	ra,0x1
    80000b16:	368080e7          	jalr	872(ra) # 80001e7a <cpuid>
    80000b1a:	89aa                	mv	s3,a0
  pop_off();
    80000b1c:	00000097          	auipc	ra,0x0
    80000b20:	4b2080e7          	jalr	1202(ra) # 80000fce <pop_off>

  memset(pa, 1, PGSIZE);
    80000b24:	6605                	lui	a2,0x1
    80000b26:	4585                	li	a1,1
    80000b28:	8526                	mv	a0,s1
    80000b2a:	00000097          	auipc	ra,0x0
    80000b2e:	54c080e7          	jalr	1356(ra) # 80001076 <memset>
  // Fill with junk to catch dangling refs.
  r = (struct run *)pa;

  acquire(&kmem[cpu_id].lock);
    80000b32:	00299913          	slli	s2,s3,0x2
    80000b36:	01390ab3          	add	s5,s2,s3
    80000b3a:	003a9793          	slli	a5,s5,0x3
    80000b3e:	00011a97          	auipc	s5,0x11
    80000b42:	e1aa8a93          	addi	s5,s5,-486 # 80011958 <kmem>
    80000b46:	9abe                	add	s5,s5,a5
    80000b48:	8556                	mv	a0,s5
    80000b4a:	00000097          	auipc	ra,0x0
    80000b4e:	430080e7          	jalr	1072(ra) # 80000f7a <acquire>
  r->next = kmem[cpu_id].freelist;
    80000b52:	013907b3          	add	a5,s2,s3
    80000b56:	078e                	slli	a5,a5,0x3
    80000b58:	97d2                	add	a5,a5,s4
    80000b5a:	7b98                	ld	a4,48(a5)
    80000b5c:	e098                	sd	a4,0(s1)
  kmem[cpu_id].freelist = r;
    80000b5e:	fb84                	sd	s1,48(a5)
  kmem[cpu_id].free_page += 1;
    80000b60:	5f98                	lw	a4,56(a5)
    80000b62:	2705                	addiw	a4,a4,1
    80000b64:	df98                	sw	a4,56(a5)
  release(&kmem[cpu_id].lock);
    80000b66:	8556                	mv	a0,s5
    80000b68:	00000097          	auipc	ra,0x0
    80000b6c:	4c6080e7          	jalr	1222(ra) # 8000102e <release>
}
    80000b70:	70e2                	ld	ra,56(sp)
    80000b72:	7442                	ld	s0,48(sp)
    80000b74:	74a2                	ld	s1,40(sp)
    80000b76:	7902                	ld	s2,32(sp)
    80000b78:	69e2                	ld	s3,24(sp)
    80000b7a:	6a42                	ld	s4,16(sp)
    80000b7c:	6aa2                	ld	s5,8(sp)
    80000b7e:	6121                	addi	sp,sp,64
    80000b80:	8082                	ret
    panic("kfree");
    80000b82:	00007517          	auipc	a0,0x7
    80000b86:	50650513          	addi	a0,a0,1286 # 80008088 <digits+0x20>
    80000b8a:	00000097          	auipc	ra,0x0
    80000b8e:	a5a080e7          	jalr	-1446(ra) # 800005e4 <panic>
      release(&ref_lock);
    80000b92:	00011517          	auipc	a0,0x11
    80000b96:	dae50513          	addi	a0,a0,-594 # 80011940 <ref_lock>
    80000b9a:	00000097          	auipc	ra,0x0
    80000b9e:	494080e7          	jalr	1172(ra) # 8000102e <release>
      return;
    80000ba2:	b7f9                	j	80000b70 <kfree+0xe6>

0000000080000ba4 <freerange>:
void freerange(void *pa_start, void *pa_end) {
    80000ba4:	7179                	addi	sp,sp,-48
    80000ba6:	f406                	sd	ra,40(sp)
    80000ba8:	f022                	sd	s0,32(sp)
    80000baa:	ec26                	sd	s1,24(sp)
    80000bac:	e84a                	sd	s2,16(sp)
    80000bae:	e44e                	sd	s3,8(sp)
    80000bb0:	e052                	sd	s4,0(sp)
    80000bb2:	1800                	addi	s0,sp,48
  p = (char *)PGROUNDUP((uint64)pa_start);
    80000bb4:	6785                	lui	a5,0x1
    80000bb6:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000bba:	94aa                	add	s1,s1,a0
    80000bbc:	757d                	lui	a0,0xfffff
    80000bbe:	8ce9                	and	s1,s1,a0
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000bc0:	94be                	add	s1,s1,a5
    80000bc2:	0095ee63          	bltu	a1,s1,80000bde <freerange+0x3a>
    80000bc6:	892e                	mv	s2,a1
    kfree(p);
    80000bc8:	7a7d                	lui	s4,0xfffff
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000bca:	6985                	lui	s3,0x1
    kfree(p);
    80000bcc:	01448533          	add	a0,s1,s4
    80000bd0:	00000097          	auipc	ra,0x0
    80000bd4:	eba080e7          	jalr	-326(ra) # 80000a8a <kfree>
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000bd8:	94ce                	add	s1,s1,s3
    80000bda:	fe9979e3          	bgeu	s2,s1,80000bcc <freerange+0x28>
}
    80000bde:	70a2                	ld	ra,40(sp)
    80000be0:	7402                	ld	s0,32(sp)
    80000be2:	64e2                	ld	s1,24(sp)
    80000be4:	6942                	ld	s2,16(sp)
    80000be6:	69a2                	ld	s3,8(sp)
    80000be8:	6a02                	ld	s4,0(sp)
    80000bea:	6145                	addi	sp,sp,48
    80000bec:	8082                	ret

0000000080000bee <kinit>:
void kinit() {
    80000bee:	7179                	addi	sp,sp,-48
    80000bf0:	f406                	sd	ra,40(sp)
    80000bf2:	f022                	sd	s0,32(sp)
    80000bf4:	ec26                	sd	s1,24(sp)
    80000bf6:	e84a                	sd	s2,16(sp)
    80000bf8:	e44e                	sd	s3,8(sp)
    80000bfa:	1800                	addi	s0,sp,48
  for (int i = 0; i < NCPU; i++) {
    80000bfc:	00011497          	auipc	s1,0x11
    80000c00:	d5c48493          	addi	s1,s1,-676 # 80011958 <kmem>
    80000c04:	00011997          	auipc	s3,0x11
    80000c08:	e9498993          	addi	s3,s3,-364 # 80011a98 <alloc_lock>
    initlock(&kmem[i].lock, "kmem");
    80000c0c:	00007917          	auipc	s2,0x7
    80000c10:	48490913          	addi	s2,s2,1156 # 80008090 <digits+0x28>
    80000c14:	85ca                	mv	a1,s2
    80000c16:	8526                	mv	a0,s1
    80000c18:	00000097          	auipc	ra,0x0
    80000c1c:	2d2080e7          	jalr	722(ra) # 80000eea <initlock>
    kmem[i].free_page = 0;
    80000c20:	0204a023          	sw	zero,32(s1)
  for (int i = 0; i < NCPU; i++) {
    80000c24:	02848493          	addi	s1,s1,40
    80000c28:	ff3496e3          	bne	s1,s3,80000c14 <kinit+0x26>
  initlock(&alloc_lock, "lock for allocating physical page");
    80000c2c:	00007597          	auipc	a1,0x7
    80000c30:	46c58593          	addi	a1,a1,1132 # 80008098 <digits+0x30>
    80000c34:	00011517          	auipc	a0,0x11
    80000c38:	e6450513          	addi	a0,a0,-412 # 80011a98 <alloc_lock>
    80000c3c:	00000097          	auipc	ra,0x0
    80000c40:	2ae080e7          	jalr	686(ra) # 80000eea <initlock>
  initlock(&ref_lock, "lock to protect reference array");
    80000c44:	00007597          	auipc	a1,0x7
    80000c48:	47c58593          	addi	a1,a1,1148 # 800080c0 <digits+0x58>
    80000c4c:	00011517          	auipc	a0,0x11
    80000c50:	cf450513          	addi	a0,a0,-780 # 80011940 <ref_lock>
    80000c54:	00000097          	auipc	ra,0x0
    80000c58:	296080e7          	jalr	662(ra) # 80000eea <initlock>
  freerange(end, (void *)PHYSTOP);
    80000c5c:	45c5                	li	a1,17
    80000c5e:	05ee                	slli	a1,a1,0x1b
    80000c60:	00045517          	auipc	a0,0x45
    80000c64:	3a050513          	addi	a0,a0,928 # 80046000 <end>
    80000c68:	00000097          	auipc	ra,0x0
    80000c6c:	f3c080e7          	jalr	-196(ra) # 80000ba4 <freerange>
}
    80000c70:	70a2                	ld	ra,40(sp)
    80000c72:	7402                	ld	s0,32(sp)
    80000c74:	64e2                	ld	s1,24(sp)
    80000c76:	6942                	ld	s2,16(sp)
    80000c78:	69a2                	ld	s3,8(sp)
    80000c7a:	6145                	addi	sp,sp,48
    80000c7c:	8082                	ret

0000000080000c7e <steal_page>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.

void steal_page(int cur_cpu) {
    80000c7e:	1101                	addi	sp,sp,-32
    80000c80:	ec06                	sd	ra,24(sp)
    80000c82:	e822                	sd	s0,16(sp)
    80000c84:	e426                	sd	s1,8(sp)
    80000c86:	1000                	addi	s0,sp,32
    80000c88:	84aa                	mv	s1,a0
  acquire(&alloc_lock);
    80000c8a:	00011517          	auipc	a0,0x11
    80000c8e:	e0e50513          	addi	a0,a0,-498 # 80011a98 <alloc_lock>
    80000c92:	00000097          	auipc	ra,0x0
    80000c96:	2e8080e7          	jalr	744(ra) # 80000f7a <acquire>
  int max_pages = 0, max_id = 0;
  for (int i = 0; i < NCPU; i++) {
    80000c9a:	00011717          	auipc	a4,0x11
    80000c9e:	cbe70713          	addi	a4,a4,-834 # 80011958 <kmem>
    80000ca2:	4781                	li	a5,0
  int max_pages = 0, max_id = 0;
    80000ca4:	4501                	li	a0,0
    80000ca6:	4681                	li	a3,0
  for (int i = 0; i < NCPU; i++) {
    80000ca8:	45a1                	li	a1,8
    80000caa:	a031                	j	80000cb6 <steal_page+0x38>
    80000cac:	2785                	addiw	a5,a5,1
    80000cae:	02870713          	addi	a4,a4,40
    80000cb2:	00b78a63          	beq	a5,a1,80000cc6 <steal_page+0x48>
    if (i == cur_cpu)
    80000cb6:	fef48be3          	beq	s1,a5,80000cac <steal_page+0x2e>
      continue;
    if (kmem[i].free_page > max_pages) {
    80000cba:	5310                	lw	a2,32(a4)
    80000cbc:	fec6d8e3          	bge	a3,a2,80000cac <steal_page+0x2e>
    80000cc0:	853e                	mv	a0,a5
      max_pages = kmem[i].free_page;
    80000cc2:	86b2                	mv	a3,a2
    80000cc4:	b7e5                	j	80000cac <steal_page+0x2e>
      max_id = i;
    }
  }
  if (max_pages <= 1) {
    80000cc6:	4785                	li	a5,1
    80000cc8:	08d7d763          	bge	a5,a3,80000d56 <steal_page+0xd8>
    release(&alloc_lock);
    return;
  }
  struct run *head, *t, *prev;
  prev = 0;
  t = head = kmem[max_id].freelist;
    80000ccc:	00251793          	slli	a5,a0,0x2
    80000cd0:	97aa                	add	a5,a5,a0
    80000cd2:	078e                	slli	a5,a5,0x3
    80000cd4:	00011717          	auipc	a4,0x11
    80000cd8:	c6c70713          	addi	a4,a4,-916 # 80011940 <ref_lock>
    80000cdc:	97ba                	add	a5,a5,a4
    80000cde:	0307b883          	ld	a7,48(a5)
  for (int i = 0; i < (int)(max_pages / 2); i++) {
    80000ce2:	01f6d81b          	srliw	a6,a3,0x1f
    80000ce6:	00d8083b          	addw	a6,a6,a3
    80000cea:	4018581b          	sraiw	a6,a6,0x1
    80000cee:	0008061b          	sext.w	a2,a6
  t = head = kmem[max_id].freelist;
    80000cf2:	87c6                	mv	a5,a7
  for (int i = 0; i < (int)(max_pages / 2); i++) {
    80000cf4:	4701                	li	a4,0
    prev = t;
    t = t->next;
    80000cf6:	85be                	mv	a1,a5
    80000cf8:	639c                	ld	a5,0(a5)
  for (int i = 0; i < (int)(max_pages / 2); i++) {
    80000cfa:	2705                	addiw	a4,a4,1
    80000cfc:	fec74de3          	blt	a4,a2,80000cf6 <steal_page+0x78>
  }
  if (prev)
    prev->next = 0;
    80000d00:	0005b023          	sd	zero,0(a1)
  kmem[max_id].freelist = t;
    80000d04:	00011617          	auipc	a2,0x11
    80000d08:	c3c60613          	addi	a2,a2,-964 # 80011940 <ref_lock>
    80000d0c:	00251713          	slli	a4,a0,0x2
    80000d10:	00a705b3          	add	a1,a4,a0
    80000d14:	058e                	slli	a1,a1,0x3
    80000d16:	95b2                	add	a1,a1,a2
    80000d18:	f99c                	sd	a5,48(a1)
  kmem[max_id].free_page = max_pages - (int)(max_pages / 2);
    80000d1a:	01f6d79b          	srliw	a5,a3,0x1f
    80000d1e:	9fb5                	addw	a5,a5,a3
    80000d20:	4017d79b          	sraiw	a5,a5,0x1
    80000d24:	9e9d                	subw	a3,a3,a5
    80000d26:	dd94                	sw	a3,56(a1)
  kmem[cur_cpu].freelist = head;
    80000d28:	00249793          	slli	a5,s1,0x2
    80000d2c:	00978733          	add	a4,a5,s1
    80000d30:	070e                	slli	a4,a4,0x3
    80000d32:	9732                	add	a4,a4,a2
    80000d34:	03173823          	sd	a7,48(a4)
  kmem[cur_cpu].free_page = (int)(max_pages / 2);
    80000d38:	03072c23          	sw	a6,56(a4)
  release(&alloc_lock);
    80000d3c:	00011517          	auipc	a0,0x11
    80000d40:	d5c50513          	addi	a0,a0,-676 # 80011a98 <alloc_lock>
    80000d44:	00000097          	auipc	ra,0x0
    80000d48:	2ea080e7          	jalr	746(ra) # 8000102e <release>
}
    80000d4c:	60e2                	ld	ra,24(sp)
    80000d4e:	6442                	ld	s0,16(sp)
    80000d50:	64a2                	ld	s1,8(sp)
    80000d52:	6105                	addi	sp,sp,32
    80000d54:	8082                	ret
    release(&alloc_lock);
    80000d56:	00011517          	auipc	a0,0x11
    80000d5a:	d4250513          	addi	a0,a0,-702 # 80011a98 <alloc_lock>
    80000d5e:	00000097          	auipc	ra,0x0
    80000d62:	2d0080e7          	jalr	720(ra) # 8000102e <release>
    return;
    80000d66:	b7dd                	j	80000d4c <steal_page+0xce>

0000000080000d68 <kalloc>:

void *kalloc(void) {
    80000d68:	7179                	addi	sp,sp,-48
    80000d6a:	f406                	sd	ra,40(sp)
    80000d6c:	f022                	sd	s0,32(sp)
    80000d6e:	ec26                	sd	s1,24(sp)
    80000d70:	e84a                	sd	s2,16(sp)
    80000d72:	e44e                	sd	s3,8(sp)
    80000d74:	1800                	addi	s0,sp,48
  struct run *r;

  push_off();
    80000d76:	00000097          	auipc	ra,0x0
    80000d7a:	1b8080e7          	jalr	440(ra) # 80000f2e <push_off>
  int cpu_id = cpuid();
    80000d7e:	00001097          	auipc	ra,0x1
    80000d82:	0fc080e7          	jalr	252(ra) # 80001e7a <cpuid>
    80000d86:	84aa                	mv	s1,a0
  pop_off();
    80000d88:	00000097          	auipc	ra,0x0
    80000d8c:	246080e7          	jalr	582(ra) # 80000fce <pop_off>
  acquire(&kmem[cpu_id].lock);
    80000d90:	00249913          	slli	s2,s1,0x2
    80000d94:	009909b3          	add	s3,s2,s1
    80000d98:	00399793          	slli	a5,s3,0x3
    80000d9c:	00011997          	auipc	s3,0x11
    80000da0:	bbc98993          	addi	s3,s3,-1092 # 80011958 <kmem>
    80000da4:	99be                	add	s3,s3,a5
    80000da6:	854e                	mv	a0,s3
    80000da8:	00000097          	auipc	ra,0x0
    80000dac:	1d2080e7          	jalr	466(ra) # 80000f7a <acquire>
  r = kmem[cpu_id].freelist;
    80000db0:	9926                	add	s2,s2,s1
    80000db2:	090e                	slli	s2,s2,0x3
    80000db4:	00011797          	auipc	a5,0x11
    80000db8:	b8c78793          	addi	a5,a5,-1140 # 80011940 <ref_lock>
    80000dbc:	993e                	add	s2,s2,a5
    80000dbe:	03093903          	ld	s2,48(s2)
  if (r) {
    80000dc2:	08090b63          	beqz	s2,80000e58 <kalloc+0xf0>
    kmem[cpu_id].freelist = r->next;
    80000dc6:	00093603          	ld	a2,0(s2)
    80000dca:	86be                	mv	a3,a5
    80000dcc:	00249713          	slli	a4,s1,0x2
    80000dd0:	009707b3          	add	a5,a4,s1
    80000dd4:	078e                	slli	a5,a5,0x3
    80000dd6:	97b6                	add	a5,a5,a3
    80000dd8:	fb90                	sd	a2,48(a5)
    kmem[cpu_id].free_page -= 1;
    80000dda:	5f98                	lw	a4,56(a5)
    80000ddc:	377d                	addiw	a4,a4,-1
    80000dde:	df98                	sw	a4,56(a5)
    if (r) {
      kmem[cpu_id].freelist = r->next;
      kmem[cpu_id].free_page -= 1;
    }
  }
  release(&kmem[cpu_id].lock);
    80000de0:	854e                	mv	a0,s3
    80000de2:	00000097          	auipc	ra,0x0
    80000de6:	24c080e7          	jalr	588(ra) # 8000102e <release>

  if (r) {
    memset((char *)r, 5, PGSIZE); // fill with junk
    80000dea:	6605                	lui	a2,0x1
    80000dec:	4595                	li	a1,5
    80000dee:	854a                	mv	a0,s2
    80000df0:	00000097          	auipc	ra,0x0
    80000df4:	286080e7          	jalr	646(ra) # 80001076 <memset>
    acquire(&ref_lock);
    80000df8:	00011517          	auipc	a0,0x11
    80000dfc:	b4850513          	addi	a0,a0,-1208 # 80011940 <ref_lock>
    80000e00:	00000097          	auipc	ra,0x0
    80000e04:	17a080e7          	jalr	378(ra) # 80000f7a <acquire>
    if (page_ref_count[REF_IDX(r)] != 0) {
    80000e08:	77fd                	lui	a5,0xfffff
    80000e0a:	00f977b3          	and	a5,s2,a5
    80000e0e:	80000737          	lui	a4,0x80000
    80000e12:	97ba                	add	a5,a5,a4
    80000e14:	00c7d693          	srli	a3,a5,0xc
    80000e18:	83a9                	srli	a5,a5,0xa
    80000e1a:	00011717          	auipc	a4,0x11
    80000e1e:	c9670713          	addi	a4,a4,-874 # 80011ab0 <page_ref_count>
    80000e22:	97ba                	add	a5,a5,a4
    80000e24:	438c                	lw	a1,0(a5)
    80000e26:	edc1                	bnez	a1,80000ebe <kalloc+0x156>
      printf("reference count %d\n", page_ref_count[REF_IDX(r)]);
      panic("incorrect reference count!\n");
    }
    page_ref_count[REF_IDX(r)] = 1;
    80000e28:	068a                	slli	a3,a3,0x2
    80000e2a:	00011797          	auipc	a5,0x11
    80000e2e:	c8678793          	addi	a5,a5,-890 # 80011ab0 <page_ref_count>
    80000e32:	96be                	add	a3,a3,a5
    80000e34:	4785                	li	a5,1
    80000e36:	c29c                	sw	a5,0(a3)
    release(&ref_lock);
    80000e38:	00011517          	auipc	a0,0x11
    80000e3c:	b0850513          	addi	a0,a0,-1272 # 80011940 <ref_lock>
    80000e40:	00000097          	auipc	ra,0x0
    80000e44:	1ee080e7          	jalr	494(ra) # 8000102e <release>
  }
  return (void *)r;
}
    80000e48:	854a                	mv	a0,s2
    80000e4a:	70a2                	ld	ra,40(sp)
    80000e4c:	7402                	ld	s0,32(sp)
    80000e4e:	64e2                	ld	s1,24(sp)
    80000e50:	6942                	ld	s2,16(sp)
    80000e52:	69a2                	ld	s3,8(sp)
    80000e54:	6145                	addi	sp,sp,48
    80000e56:	8082                	ret
    if (kmem[cpu_id].free_page != 0) {
    80000e58:	00249793          	slli	a5,s1,0x2
    80000e5c:	97a6                	add	a5,a5,s1
    80000e5e:	078e                	slli	a5,a5,0x3
    80000e60:	00011717          	auipc	a4,0x11
    80000e64:	ae070713          	addi	a4,a4,-1312 # 80011940 <ref_lock>
    80000e68:	97ba                	add	a5,a5,a4
    80000e6a:	5f9c                	lw	a5,56(a5)
    80000e6c:	e3a9                	bnez	a5,80000eae <kalloc+0x146>
    steal_page(cpu_id);
    80000e6e:	8526                	mv	a0,s1
    80000e70:	00000097          	auipc	ra,0x0
    80000e74:	e0e080e7          	jalr	-498(ra) # 80000c7e <steal_page>
    r = kmem[cpu_id].freelist;
    80000e78:	00249793          	slli	a5,s1,0x2
    80000e7c:	97a6                	add	a5,a5,s1
    80000e7e:	078e                	slli	a5,a5,0x3
    80000e80:	00011717          	auipc	a4,0x11
    80000e84:	ac070713          	addi	a4,a4,-1344 # 80011940 <ref_lock>
    80000e88:	97ba                	add	a5,a5,a4
    80000e8a:	0307b903          	ld	s2,48(a5)
    if (r) {
    80000e8e:	04090863          	beqz	s2,80000ede <kalloc+0x176>
      kmem[cpu_id].freelist = r->next;
    80000e92:	00093603          	ld	a2,0(s2)
    80000e96:	86ba                	mv	a3,a4
    80000e98:	00249713          	slli	a4,s1,0x2
    80000e9c:	009707b3          	add	a5,a4,s1
    80000ea0:	078e                	slli	a5,a5,0x3
    80000ea2:	97b6                	add	a5,a5,a3
    80000ea4:	fb90                	sd	a2,48(a5)
      kmem[cpu_id].free_page -= 1;
    80000ea6:	5f98                	lw	a4,56(a5)
    80000ea8:	377d                	addiw	a4,a4,-1
    80000eaa:	df98                	sw	a4,56(a5)
    80000eac:	bf15                	j	80000de0 <kalloc+0x78>
      panic("should not get here");
    80000eae:	00007517          	auipc	a0,0x7
    80000eb2:	23250513          	addi	a0,a0,562 # 800080e0 <digits+0x78>
    80000eb6:	fffff097          	auipc	ra,0xfffff
    80000eba:	72e080e7          	jalr	1838(ra) # 800005e4 <panic>
      printf("reference count %d\n", page_ref_count[REF_IDX(r)]);
    80000ebe:	00007517          	auipc	a0,0x7
    80000ec2:	23a50513          	addi	a0,a0,570 # 800080f8 <digits+0x90>
    80000ec6:	fffff097          	auipc	ra,0xfffff
    80000eca:	770080e7          	jalr	1904(ra) # 80000636 <printf>
      panic("incorrect reference count!\n");
    80000ece:	00007517          	auipc	a0,0x7
    80000ed2:	24250513          	addi	a0,a0,578 # 80008110 <digits+0xa8>
    80000ed6:	fffff097          	auipc	ra,0xfffff
    80000eda:	70e080e7          	jalr	1806(ra) # 800005e4 <panic>
  release(&kmem[cpu_id].lock);
    80000ede:	854e                	mv	a0,s3
    80000ee0:	00000097          	auipc	ra,0x0
    80000ee4:	14e080e7          	jalr	334(ra) # 8000102e <release>
  if (r) {
    80000ee8:	b785                	j	80000e48 <kalloc+0xe0>

0000000080000eea <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000eea:	1141                	addi	sp,sp,-16
    80000eec:	e422                	sd	s0,8(sp)
    80000eee:	0800                	addi	s0,sp,16
  lk->name = name;
    80000ef0:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000ef2:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000ef6:	00053823          	sd	zero,16(a0)
}
    80000efa:	6422                	ld	s0,8(sp)
    80000efc:	0141                	addi	sp,sp,16
    80000efe:	8082                	ret

0000000080000f00 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000f00:	411c                	lw	a5,0(a0)
    80000f02:	e399                	bnez	a5,80000f08 <holding+0x8>
    80000f04:	4501                	li	a0,0
  return r;
}
    80000f06:	8082                	ret
{
    80000f08:	1101                	addi	sp,sp,-32
    80000f0a:	ec06                	sd	ra,24(sp)
    80000f0c:	e822                	sd	s0,16(sp)
    80000f0e:	e426                	sd	s1,8(sp)
    80000f10:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000f12:	6904                	ld	s1,16(a0)
    80000f14:	00001097          	auipc	ra,0x1
    80000f18:	f76080e7          	jalr	-138(ra) # 80001e8a <mycpu>
    80000f1c:	40a48533          	sub	a0,s1,a0
    80000f20:	00153513          	seqz	a0,a0
}
    80000f24:	60e2                	ld	ra,24(sp)
    80000f26:	6442                	ld	s0,16(sp)
    80000f28:	64a2                	ld	s1,8(sp)
    80000f2a:	6105                	addi	sp,sp,32
    80000f2c:	8082                	ret

0000000080000f2e <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000f2e:	1101                	addi	sp,sp,-32
    80000f30:	ec06                	sd	ra,24(sp)
    80000f32:	e822                	sd	s0,16(sp)
    80000f34:	e426                	sd	s1,8(sp)
    80000f36:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80000f38:	100024f3          	csrr	s1,sstatus
    80000f3c:	100027f3          	csrr	a5,sstatus
static inline void intr_off() { w_sstatus(r_sstatus() & ~SSTATUS_SIE); }
    80000f40:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80000f42:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000f46:	00001097          	auipc	ra,0x1
    80000f4a:	f44080e7          	jalr	-188(ra) # 80001e8a <mycpu>
    80000f4e:	5d3c                	lw	a5,120(a0)
    80000f50:	cf89                	beqz	a5,80000f6a <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000f52:	00001097          	auipc	ra,0x1
    80000f56:	f38080e7          	jalr	-200(ra) # 80001e8a <mycpu>
    80000f5a:	5d3c                	lw	a5,120(a0)
    80000f5c:	2785                	addiw	a5,a5,1
    80000f5e:	dd3c                	sw	a5,120(a0)
}
    80000f60:	60e2                	ld	ra,24(sp)
    80000f62:	6442                	ld	s0,16(sp)
    80000f64:	64a2                	ld	s1,8(sp)
    80000f66:	6105                	addi	sp,sp,32
    80000f68:	8082                	ret
    mycpu()->intena = old;
    80000f6a:	00001097          	auipc	ra,0x1
    80000f6e:	f20080e7          	jalr	-224(ra) # 80001e8a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000f72:	8085                	srli	s1,s1,0x1
    80000f74:	8885                	andi	s1,s1,1
    80000f76:	dd64                	sw	s1,124(a0)
    80000f78:	bfe9                	j	80000f52 <push_off+0x24>

0000000080000f7a <acquire>:
{
    80000f7a:	1101                	addi	sp,sp,-32
    80000f7c:	ec06                	sd	ra,24(sp)
    80000f7e:	e822                	sd	s0,16(sp)
    80000f80:	e426                	sd	s1,8(sp)
    80000f82:	1000                	addi	s0,sp,32
    80000f84:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000f86:	00000097          	auipc	ra,0x0
    80000f8a:	fa8080e7          	jalr	-88(ra) # 80000f2e <push_off>
  if(holding(lk))
    80000f8e:	8526                	mv	a0,s1
    80000f90:	00000097          	auipc	ra,0x0
    80000f94:	f70080e7          	jalr	-144(ra) # 80000f00 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000f98:	4705                	li	a4,1
  if(holding(lk))
    80000f9a:	e115                	bnez	a0,80000fbe <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000f9c:	87ba                	mv	a5,a4
    80000f9e:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000fa2:	2781                	sext.w	a5,a5
    80000fa4:	ffe5                	bnez	a5,80000f9c <acquire+0x22>
  __sync_synchronize();
    80000fa6:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000faa:	00001097          	auipc	ra,0x1
    80000fae:	ee0080e7          	jalr	-288(ra) # 80001e8a <mycpu>
    80000fb2:	e888                	sd	a0,16(s1)
}
    80000fb4:	60e2                	ld	ra,24(sp)
    80000fb6:	6442                	ld	s0,16(sp)
    80000fb8:	64a2                	ld	s1,8(sp)
    80000fba:	6105                	addi	sp,sp,32
    80000fbc:	8082                	ret
    panic("acquire");
    80000fbe:	00007517          	auipc	a0,0x7
    80000fc2:	17250513          	addi	a0,a0,370 # 80008130 <digits+0xc8>
    80000fc6:	fffff097          	auipc	ra,0xfffff
    80000fca:	61e080e7          	jalr	1566(ra) # 800005e4 <panic>

0000000080000fce <pop_off>:

void
pop_off(void)
{
    80000fce:	1141                	addi	sp,sp,-16
    80000fd0:	e406                	sd	ra,8(sp)
    80000fd2:	e022                	sd	s0,0(sp)
    80000fd4:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000fd6:	00001097          	auipc	ra,0x1
    80000fda:	eb4080e7          	jalr	-332(ra) # 80001e8a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80000fde:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000fe2:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000fe4:	e78d                	bnez	a5,8000100e <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000fe6:	5d3c                	lw	a5,120(a0)
    80000fe8:	02f05b63          	blez	a5,8000101e <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000fec:	37fd                	addiw	a5,a5,-1
    80000fee:	0007871b          	sext.w	a4,a5
    80000ff2:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000ff4:	eb09                	bnez	a4,80001006 <pop_off+0x38>
    80000ff6:	5d7c                	lw	a5,124(a0)
    80000ff8:	c799                	beqz	a5,80001006 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80000ffa:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80000ffe:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001002:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80001006:	60a2                	ld	ra,8(sp)
    80001008:	6402                	ld	s0,0(sp)
    8000100a:	0141                	addi	sp,sp,16
    8000100c:	8082                	ret
    panic("pop_off - interruptible");
    8000100e:	00007517          	auipc	a0,0x7
    80001012:	12a50513          	addi	a0,a0,298 # 80008138 <digits+0xd0>
    80001016:	fffff097          	auipc	ra,0xfffff
    8000101a:	5ce080e7          	jalr	1486(ra) # 800005e4 <panic>
    panic("pop_off");
    8000101e:	00007517          	auipc	a0,0x7
    80001022:	13250513          	addi	a0,a0,306 # 80008150 <digits+0xe8>
    80001026:	fffff097          	auipc	ra,0xfffff
    8000102a:	5be080e7          	jalr	1470(ra) # 800005e4 <panic>

000000008000102e <release>:
{
    8000102e:	1101                	addi	sp,sp,-32
    80001030:	ec06                	sd	ra,24(sp)
    80001032:	e822                	sd	s0,16(sp)
    80001034:	e426                	sd	s1,8(sp)
    80001036:	1000                	addi	s0,sp,32
    80001038:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000103a:	00000097          	auipc	ra,0x0
    8000103e:	ec6080e7          	jalr	-314(ra) # 80000f00 <holding>
    80001042:	c115                	beqz	a0,80001066 <release+0x38>
  lk->cpu = 0;
    80001044:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80001048:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000104c:	0f50000f          	fence	iorw,ow
    80001050:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80001054:	00000097          	auipc	ra,0x0
    80001058:	f7a080e7          	jalr	-134(ra) # 80000fce <pop_off>
}
    8000105c:	60e2                	ld	ra,24(sp)
    8000105e:	6442                	ld	s0,16(sp)
    80001060:	64a2                	ld	s1,8(sp)
    80001062:	6105                	addi	sp,sp,32
    80001064:	8082                	ret
    panic("release");
    80001066:	00007517          	auipc	a0,0x7
    8000106a:	0f250513          	addi	a0,a0,242 # 80008158 <digits+0xf0>
    8000106e:	fffff097          	auipc	ra,0xfffff
    80001072:	576080e7          	jalr	1398(ra) # 800005e4 <panic>

0000000080001076 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80001076:	1141                	addi	sp,sp,-16
    80001078:	e422                	sd	s0,8(sp)
    8000107a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000107c:	ca19                	beqz	a2,80001092 <memset+0x1c>
    8000107e:	87aa                	mv	a5,a0
    80001080:	1602                	slli	a2,a2,0x20
    80001082:	9201                	srli	a2,a2,0x20
    80001084:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80001088:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    8000108c:	0785                	addi	a5,a5,1
    8000108e:	fee79de3          	bne	a5,a4,80001088 <memset+0x12>
  }
  return dst;
}
    80001092:	6422                	ld	s0,8(sp)
    80001094:	0141                	addi	sp,sp,16
    80001096:	8082                	ret

0000000080001098 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80001098:	1141                	addi	sp,sp,-16
    8000109a:	e422                	sd	s0,8(sp)
    8000109c:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    8000109e:	ca05                	beqz	a2,800010ce <memcmp+0x36>
    800010a0:	fff6069b          	addiw	a3,a2,-1
    800010a4:	1682                	slli	a3,a3,0x20
    800010a6:	9281                	srli	a3,a3,0x20
    800010a8:	0685                	addi	a3,a3,1
    800010aa:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800010ac:	00054783          	lbu	a5,0(a0)
    800010b0:	0005c703          	lbu	a4,0(a1)
    800010b4:	00e79863          	bne	a5,a4,800010c4 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800010b8:	0505                	addi	a0,a0,1
    800010ba:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800010bc:	fed518e3          	bne	a0,a3,800010ac <memcmp+0x14>
  }

  return 0;
    800010c0:	4501                	li	a0,0
    800010c2:	a019                	j	800010c8 <memcmp+0x30>
      return *s1 - *s2;
    800010c4:	40e7853b          	subw	a0,a5,a4
}
    800010c8:	6422                	ld	s0,8(sp)
    800010ca:	0141                	addi	sp,sp,16
    800010cc:	8082                	ret
  return 0;
    800010ce:	4501                	li	a0,0
    800010d0:	bfe5                	j	800010c8 <memcmp+0x30>

00000000800010d2 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800010d2:	1141                	addi	sp,sp,-16
    800010d4:	e422                	sd	s0,8(sp)
    800010d6:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    800010d8:	02a5e563          	bltu	a1,a0,80001102 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800010dc:	fff6069b          	addiw	a3,a2,-1
    800010e0:	ce11                	beqz	a2,800010fc <memmove+0x2a>
    800010e2:	1682                	slli	a3,a3,0x20
    800010e4:	9281                	srli	a3,a3,0x20
    800010e6:	0685                	addi	a3,a3,1
    800010e8:	96ae                	add	a3,a3,a1
    800010ea:	87aa                	mv	a5,a0
      *d++ = *s++;
    800010ec:	0585                	addi	a1,a1,1
    800010ee:	0785                	addi	a5,a5,1
    800010f0:	fff5c703          	lbu	a4,-1(a1)
    800010f4:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    800010f8:	fed59ae3          	bne	a1,a3,800010ec <memmove+0x1a>

  return dst;
}
    800010fc:	6422                	ld	s0,8(sp)
    800010fe:	0141                	addi	sp,sp,16
    80001100:	8082                	ret
  if(s < d && s + n > d){
    80001102:	02061713          	slli	a4,a2,0x20
    80001106:	9301                	srli	a4,a4,0x20
    80001108:	00e587b3          	add	a5,a1,a4
    8000110c:	fcf578e3          	bgeu	a0,a5,800010dc <memmove+0xa>
    d += n;
    80001110:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80001112:	fff6069b          	addiw	a3,a2,-1
    80001116:	d27d                	beqz	a2,800010fc <memmove+0x2a>
    80001118:	02069613          	slli	a2,a3,0x20
    8000111c:	9201                	srli	a2,a2,0x20
    8000111e:	fff64613          	not	a2,a2
    80001122:	963e                	add	a2,a2,a5
      *--d = *--s;
    80001124:	17fd                	addi	a5,a5,-1
    80001126:	177d                	addi	a4,a4,-1
    80001128:	0007c683          	lbu	a3,0(a5)
    8000112c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80001130:	fef61ae3          	bne	a2,a5,80001124 <memmove+0x52>
    80001134:	b7e1                	j	800010fc <memmove+0x2a>

0000000080001136 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80001136:	1141                	addi	sp,sp,-16
    80001138:	e406                	sd	ra,8(sp)
    8000113a:	e022                	sd	s0,0(sp)
    8000113c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000113e:	00000097          	auipc	ra,0x0
    80001142:	f94080e7          	jalr	-108(ra) # 800010d2 <memmove>
}
    80001146:	60a2                	ld	ra,8(sp)
    80001148:	6402                	ld	s0,0(sp)
    8000114a:	0141                	addi	sp,sp,16
    8000114c:	8082                	ret

000000008000114e <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000114e:	1141                	addi	sp,sp,-16
    80001150:	e422                	sd	s0,8(sp)
    80001152:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80001154:	ce11                	beqz	a2,80001170 <strncmp+0x22>
    80001156:	00054783          	lbu	a5,0(a0)
    8000115a:	cf89                	beqz	a5,80001174 <strncmp+0x26>
    8000115c:	0005c703          	lbu	a4,0(a1)
    80001160:	00f71a63          	bne	a4,a5,80001174 <strncmp+0x26>
    n--, p++, q++;
    80001164:	367d                	addiw	a2,a2,-1
    80001166:	0505                	addi	a0,a0,1
    80001168:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000116a:	f675                	bnez	a2,80001156 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000116c:	4501                	li	a0,0
    8000116e:	a809                	j	80001180 <strncmp+0x32>
    80001170:	4501                	li	a0,0
    80001172:	a039                	j	80001180 <strncmp+0x32>
  if(n == 0)
    80001174:	ca09                	beqz	a2,80001186 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80001176:	00054503          	lbu	a0,0(a0)
    8000117a:	0005c783          	lbu	a5,0(a1)
    8000117e:	9d1d                	subw	a0,a0,a5
}
    80001180:	6422                	ld	s0,8(sp)
    80001182:	0141                	addi	sp,sp,16
    80001184:	8082                	ret
    return 0;
    80001186:	4501                	li	a0,0
    80001188:	bfe5                	j	80001180 <strncmp+0x32>

000000008000118a <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000118a:	1141                	addi	sp,sp,-16
    8000118c:	e422                	sd	s0,8(sp)
    8000118e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80001190:	872a                	mv	a4,a0
    80001192:	8832                	mv	a6,a2
    80001194:	367d                	addiw	a2,a2,-1
    80001196:	01005963          	blez	a6,800011a8 <strncpy+0x1e>
    8000119a:	0705                	addi	a4,a4,1
    8000119c:	0005c783          	lbu	a5,0(a1)
    800011a0:	fef70fa3          	sb	a5,-1(a4)
    800011a4:	0585                	addi	a1,a1,1
    800011a6:	f7f5                	bnez	a5,80001192 <strncpy+0x8>
    ;
  while(n-- > 0)
    800011a8:	86ba                	mv	a3,a4
    800011aa:	00c05c63          	blez	a2,800011c2 <strncpy+0x38>
    *s++ = 0;
    800011ae:	0685                	addi	a3,a3,1
    800011b0:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800011b4:	fff6c793          	not	a5,a3
    800011b8:	9fb9                	addw	a5,a5,a4
    800011ba:	010787bb          	addw	a5,a5,a6
    800011be:	fef048e3          	bgtz	a5,800011ae <strncpy+0x24>
  return os;
}
    800011c2:	6422                	ld	s0,8(sp)
    800011c4:	0141                	addi	sp,sp,16
    800011c6:	8082                	ret

00000000800011c8 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800011c8:	1141                	addi	sp,sp,-16
    800011ca:	e422                	sd	s0,8(sp)
    800011cc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800011ce:	02c05363          	blez	a2,800011f4 <safestrcpy+0x2c>
    800011d2:	fff6069b          	addiw	a3,a2,-1
    800011d6:	1682                	slli	a3,a3,0x20
    800011d8:	9281                	srli	a3,a3,0x20
    800011da:	96ae                	add	a3,a3,a1
    800011dc:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800011de:	00d58963          	beq	a1,a3,800011f0 <safestrcpy+0x28>
    800011e2:	0585                	addi	a1,a1,1
    800011e4:	0785                	addi	a5,a5,1
    800011e6:	fff5c703          	lbu	a4,-1(a1)
    800011ea:	fee78fa3          	sb	a4,-1(a5)
    800011ee:	fb65                	bnez	a4,800011de <safestrcpy+0x16>
    ;
  *s = 0;
    800011f0:	00078023          	sb	zero,0(a5)
  return os;
}
    800011f4:	6422                	ld	s0,8(sp)
    800011f6:	0141                	addi	sp,sp,16
    800011f8:	8082                	ret

00000000800011fa <strlen>:

int
strlen(const char *s)
{
    800011fa:	1141                	addi	sp,sp,-16
    800011fc:	e422                	sd	s0,8(sp)
    800011fe:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80001200:	00054783          	lbu	a5,0(a0)
    80001204:	cf91                	beqz	a5,80001220 <strlen+0x26>
    80001206:	0505                	addi	a0,a0,1
    80001208:	87aa                	mv	a5,a0
    8000120a:	4685                	li	a3,1
    8000120c:	9e89                	subw	a3,a3,a0
    8000120e:	00f6853b          	addw	a0,a3,a5
    80001212:	0785                	addi	a5,a5,1
    80001214:	fff7c703          	lbu	a4,-1(a5)
    80001218:	fb7d                	bnez	a4,8000120e <strlen+0x14>
    ;
  return n;
}
    8000121a:	6422                	ld	s0,8(sp)
    8000121c:	0141                	addi	sp,sp,16
    8000121e:	8082                	ret
  for(n = 0; s[n]; n++)
    80001220:	4501                	li	a0,0
    80001222:	bfe5                	j	8000121a <strlen+0x20>

0000000080001224 <main>:
#include "types.h"

volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void main() {
    80001224:	1141                	addi	sp,sp,-16
    80001226:	e406                	sd	ra,8(sp)
    80001228:	e022                	sd	s0,0(sp)
    8000122a:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    8000122c:	00001097          	auipc	ra,0x1
    80001230:	c4e080e7          	jalr	-946(ra) # 80001e7a <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();         // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while (started == 0)
    80001234:	00008717          	auipc	a4,0x8
    80001238:	dd870713          	addi	a4,a4,-552 # 8000900c <started>
  if (cpuid() == 0) {
    8000123c:	c139                	beqz	a0,80001282 <main+0x5e>
    while (started == 0)
    8000123e:	431c                	lw	a5,0(a4)
    80001240:	2781                	sext.w	a5,a5
    80001242:	dff5                	beqz	a5,8000123e <main+0x1a>
      ;
    __sync_synchronize();
    80001244:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80001248:	00001097          	auipc	ra,0x1
    8000124c:	c32080e7          	jalr	-974(ra) # 80001e7a <cpuid>
    80001250:	85aa                	mv	a1,a0
    80001252:	00007517          	auipc	a0,0x7
    80001256:	f2650513          	addi	a0,a0,-218 # 80008178 <digits+0x110>
    8000125a:	fffff097          	auipc	ra,0xfffff
    8000125e:	3dc080e7          	jalr	988(ra) # 80000636 <printf>
    kvminithart();  // turn on paging
    80001262:	00000097          	auipc	ra,0x0
    80001266:	0d8080e7          	jalr	216(ra) # 8000133a <kvminithart>
    trapinithart(); // install kernel trap vector
    8000126a:	00002097          	auipc	ra,0x2
    8000126e:	896080e7          	jalr	-1898(ra) # 80002b00 <trapinithart>
    plicinithart(); // ask PLIC for device interrupts
    80001272:	00005097          	auipc	ra,0x5
    80001276:	f1e080e7          	jalr	-226(ra) # 80006190 <plicinithart>
  }

  scheduler();
    8000127a:	00001097          	auipc	ra,0x1
    8000127e:	160080e7          	jalr	352(ra) # 800023da <scheduler>
    consoleinit();
    80001282:	fffff097          	auipc	ra,0xfffff
    80001286:	1d2080e7          	jalr	466(ra) # 80000454 <consoleinit>
    printfinit();
    8000128a:	fffff097          	auipc	ra,0xfffff
    8000128e:	2b8080e7          	jalr	696(ra) # 80000542 <printfinit>
    printf("\n");
    80001292:	00007517          	auipc	a0,0x7
    80001296:	ef650513          	addi	a0,a0,-266 # 80008188 <digits+0x120>
    8000129a:	fffff097          	auipc	ra,0xfffff
    8000129e:	39c080e7          	jalr	924(ra) # 80000636 <printf>
    printf("xv6 kernel is booting\n");
    800012a2:	00007517          	auipc	a0,0x7
    800012a6:	ebe50513          	addi	a0,a0,-322 # 80008160 <digits+0xf8>
    800012aa:	fffff097          	auipc	ra,0xfffff
    800012ae:	38c080e7          	jalr	908(ra) # 80000636 <printf>
    printf("\n");
    800012b2:	00007517          	auipc	a0,0x7
    800012b6:	ed650513          	addi	a0,a0,-298 # 80008188 <digits+0x120>
    800012ba:	fffff097          	auipc	ra,0xfffff
    800012be:	37c080e7          	jalr	892(ra) # 80000636 <printf>
    kinit();            // physical page allocator
    800012c2:	00000097          	auipc	ra,0x0
    800012c6:	92c080e7          	jalr	-1748(ra) # 80000bee <kinit>
    kvminit();          // create kernel page table
    800012ca:	00000097          	auipc	ra,0x0
    800012ce:	296080e7          	jalr	662(ra) # 80001560 <kvminit>
    kvminithart();      // turn on paging
    800012d2:	00000097          	auipc	ra,0x0
    800012d6:	068080e7          	jalr	104(ra) # 8000133a <kvminithart>
    procinit();         // process table
    800012da:	00001097          	auipc	ra,0x1
    800012de:	ad0080e7          	jalr	-1328(ra) # 80001daa <procinit>
    trapinit();         // trap vectors
    800012e2:	00001097          	auipc	ra,0x1
    800012e6:	7f6080e7          	jalr	2038(ra) # 80002ad8 <trapinit>
    trapinithart();     // install kernel trap vector
    800012ea:	00002097          	auipc	ra,0x2
    800012ee:	816080e7          	jalr	-2026(ra) # 80002b00 <trapinithart>
    plicinit();         // set up interrupt controller
    800012f2:	00005097          	auipc	ra,0x5
    800012f6:	e88080e7          	jalr	-376(ra) # 8000617a <plicinit>
    plicinithart();     // ask PLIC for device interrupts
    800012fa:	00005097          	auipc	ra,0x5
    800012fe:	e96080e7          	jalr	-362(ra) # 80006190 <plicinithart>
    binit();            // buffer cache
    80001302:	00002097          	auipc	ra,0x2
    80001306:	03a080e7          	jalr	58(ra) # 8000333c <binit>
    iinit();            // inode cache
    8000130a:	00002097          	auipc	ra,0x2
    8000130e:	6ca080e7          	jalr	1738(ra) # 800039d4 <iinit>
    fileinit();         // file table
    80001312:	00003097          	auipc	ra,0x3
    80001316:	668080e7          	jalr	1640(ra) # 8000497a <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000131a:	00005097          	auipc	ra,0x5
    8000131e:	f7e080e7          	jalr	-130(ra) # 80006298 <virtio_disk_init>
    userinit();         // first user process
    80001322:	00001097          	auipc	ra,0x1
    80001326:	e4e080e7          	jalr	-434(ra) # 80002170 <userinit>
    __sync_synchronize();
    8000132a:	0ff0000f          	fence
    started = 1;
    8000132e:	4785                	li	a5,1
    80001330:	00008717          	auipc	a4,0x8
    80001334:	ccf72e23          	sw	a5,-804(a4) # 8000900c <started>
    80001338:	b789                	j	8000127a <main+0x56>

000000008000133a <kvminithart>:
  kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
}

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void kvminithart() {
    8000133a:	1141                	addi	sp,sp,-16
    8000133c:	e422                	sd	s0,8(sp)
    8000133e:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80001340:	00008797          	auipc	a5,0x8
    80001344:	cd07b783          	ld	a5,-816(a5) # 80009010 <kernel_pagetable>
    80001348:	83b1                	srli	a5,a5,0xc
    8000134a:	577d                	li	a4,-1
    8000134c:	177e                	slli	a4,a4,0x3f
    8000134e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r"(x));
    80001350:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80001354:	12000073          	sfence.vma
  sfence_vma();
}
    80001358:	6422                	ld	s0,8(sp)
    8000135a:	0141                	addi	sp,sp,16
    8000135c:	8082                	ret

000000008000135e <walk>:
//   30..38 -- 9 bits of level-2 index.
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *walk(pagetable_t pagetable, uint64 va, int alloc) {
  if (va >= MAXVA)
    8000135e:	57fd                	li	a5,-1
    80001360:	83e9                	srli	a5,a5,0x1a
    80001362:	08b7e863          	bltu	a5,a1,800013f2 <walk+0x94>
pte_t *walk(pagetable_t pagetable, uint64 va, int alloc) {
    80001366:	7139                	addi	sp,sp,-64
    80001368:	fc06                	sd	ra,56(sp)
    8000136a:	f822                	sd	s0,48(sp)
    8000136c:	f426                	sd	s1,40(sp)
    8000136e:	f04a                	sd	s2,32(sp)
    80001370:	ec4e                	sd	s3,24(sp)
    80001372:	e852                	sd	s4,16(sp)
    80001374:	e456                	sd	s5,8(sp)
    80001376:	e05a                	sd	s6,0(sp)
    80001378:	0080                	addi	s0,sp,64
    8000137a:	84aa                	mv	s1,a0
    8000137c:	89ae                	mv	s3,a1
    8000137e:	8ab2                	mv	s5,a2
    80001380:	4a79                	li	s4,30
    return 0;

  for (int level = 2; level > 0; level--) {
    80001382:	4b31                	li	s6,12
    80001384:	a80d                	j	800013b6 <walk+0x58>
    pte_t *pte = &pagetable[PX(level, va)];
    if (*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    80001386:	060a8863          	beqz	s5,800013f6 <walk+0x98>
    8000138a:	00000097          	auipc	ra,0x0
    8000138e:	9de080e7          	jalr	-1570(ra) # 80000d68 <kalloc>
    80001392:	84aa                	mv	s1,a0
    80001394:	c529                	beqz	a0,800013de <walk+0x80>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80001396:	6605                	lui	a2,0x1
    80001398:	4581                	li	a1,0
    8000139a:	00000097          	auipc	ra,0x0
    8000139e:	cdc080e7          	jalr	-804(ra) # 80001076 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800013a2:	00c4d793          	srli	a5,s1,0xc
    800013a6:	07aa                	slli	a5,a5,0xa
    800013a8:	0017e793          	ori	a5,a5,1
    800013ac:	00f93023          	sd	a5,0(s2)
  for (int level = 2; level > 0; level--) {
    800013b0:	3a5d                	addiw	s4,s4,-9
    800013b2:	036a0063          	beq	s4,s6,800013d2 <walk+0x74>
    pte_t *pte = &pagetable[PX(level, va)];
    800013b6:	0149d933          	srl	s2,s3,s4
    800013ba:	1ff97913          	andi	s2,s2,511
    800013be:	090e                	slli	s2,s2,0x3
    800013c0:	9926                	add	s2,s2,s1
    if (*pte & PTE_V) {
    800013c2:	00093483          	ld	s1,0(s2)
    800013c6:	0014f793          	andi	a5,s1,1
    800013ca:	dfd5                	beqz	a5,80001386 <walk+0x28>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800013cc:	80a9                	srli	s1,s1,0xa
    800013ce:	04b2                	slli	s1,s1,0xc
    800013d0:	b7c5                	j	800013b0 <walk+0x52>
    }
  }
  return &pagetable[PX(0, va)];
    800013d2:	00c9d513          	srli	a0,s3,0xc
    800013d6:	1ff57513          	andi	a0,a0,511
    800013da:	050e                	slli	a0,a0,0x3
    800013dc:	9526                	add	a0,a0,s1
}
    800013de:	70e2                	ld	ra,56(sp)
    800013e0:	7442                	ld	s0,48(sp)
    800013e2:	74a2                	ld	s1,40(sp)
    800013e4:	7902                	ld	s2,32(sp)
    800013e6:	69e2                	ld	s3,24(sp)
    800013e8:	6a42                	ld	s4,16(sp)
    800013ea:	6aa2                	ld	s5,8(sp)
    800013ec:	6b02                	ld	s6,0(sp)
    800013ee:	6121                	addi	sp,sp,64
    800013f0:	8082                	ret
    return 0;
    800013f2:	4501                	li	a0,0
}
    800013f4:	8082                	ret
        return 0;
    800013f6:	4501                	li	a0,0
    800013f8:	b7dd                	j	800013de <walk+0x80>

00000000800013fa <walkaddr>:
// Can only be used to look up user pages.
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA)
    800013fa:	57fd                	li	a5,-1
    800013fc:	83e9                	srli	a5,a5,0x1a
    800013fe:	00b7f463          	bgeu	a5,a1,80001406 <walkaddr+0xc>
    return 0;
    80001402:	4501                	li	a0,0
    return 0;
  if ((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001404:	8082                	ret
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
    80001406:	1141                	addi	sp,sp,-16
    80001408:	e406                	sd	ra,8(sp)
    8000140a:	e022                	sd	s0,0(sp)
    8000140c:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000140e:	4601                	li	a2,0
    80001410:	00000097          	auipc	ra,0x0
    80001414:	f4e080e7          	jalr	-178(ra) # 8000135e <walk>
  if (pte == 0)
    80001418:	c105                	beqz	a0,80001438 <walkaddr+0x3e>
  if ((*pte & PTE_V) == 0)
    8000141a:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0)
    8000141c:	0117f693          	andi	a3,a5,17
    80001420:	4745                	li	a4,17
    return 0;
    80001422:	4501                	li	a0,0
  if ((*pte & PTE_U) == 0)
    80001424:	00e68663          	beq	a3,a4,80001430 <walkaddr+0x36>
}
    80001428:	60a2                	ld	ra,8(sp)
    8000142a:	6402                	ld	s0,0(sp)
    8000142c:	0141                	addi	sp,sp,16
    8000142e:	8082                	ret
  pa = PTE2PA(*pte);
    80001430:	00a7d513          	srli	a0,a5,0xa
    80001434:	0532                	slli	a0,a0,0xc
  return pa;
    80001436:	bfcd                	j	80001428 <walkaddr+0x2e>
    return 0;
    80001438:	4501                	li	a0,0
    8000143a:	b7fd                	j	80001428 <walkaddr+0x2e>

000000008000143c <kvmpa>:

// translate a kernel virtual address to
// a physical address. only needed for
// addresses on the stack.
// assumes va is page aligned.
uint64 kvmpa(uint64 va) {
    8000143c:	1101                	addi	sp,sp,-32
    8000143e:	ec06                	sd	ra,24(sp)
    80001440:	e822                	sd	s0,16(sp)
    80001442:	e426                	sd	s1,8(sp)
    80001444:	1000                	addi	s0,sp,32
    80001446:	85aa                	mv	a1,a0
  uint64 off = va % PGSIZE;
    80001448:	1552                	slli	a0,a0,0x34
    8000144a:	03455493          	srli	s1,a0,0x34
  pte_t *pte;
  uint64 pa;

  pte = walk(kernel_pagetable, va, 0);
    8000144e:	4601                	li	a2,0
    80001450:	00008517          	auipc	a0,0x8
    80001454:	bc053503          	ld	a0,-1088(a0) # 80009010 <kernel_pagetable>
    80001458:	00000097          	auipc	ra,0x0
    8000145c:	f06080e7          	jalr	-250(ra) # 8000135e <walk>
  if (pte == 0)
    80001460:	cd09                	beqz	a0,8000147a <kvmpa+0x3e>
    panic("kvmpa");
  if ((*pte & PTE_V) == 0)
    80001462:	6108                	ld	a0,0(a0)
    80001464:	00157793          	andi	a5,a0,1
    80001468:	c38d                	beqz	a5,8000148a <kvmpa+0x4e>
    panic("kvmpa");
  pa = PTE2PA(*pte);
    8000146a:	8129                	srli	a0,a0,0xa
    8000146c:	0532                	slli	a0,a0,0xc
  return pa + off;
}
    8000146e:	9526                	add	a0,a0,s1
    80001470:	60e2                	ld	ra,24(sp)
    80001472:	6442                	ld	s0,16(sp)
    80001474:	64a2                	ld	s1,8(sp)
    80001476:	6105                	addi	sp,sp,32
    80001478:	8082                	ret
    panic("kvmpa");
    8000147a:	00007517          	auipc	a0,0x7
    8000147e:	d1650513          	addi	a0,a0,-746 # 80008190 <digits+0x128>
    80001482:	fffff097          	auipc	ra,0xfffff
    80001486:	162080e7          	jalr	354(ra) # 800005e4 <panic>
    panic("kvmpa");
    8000148a:	00007517          	auipc	a0,0x7
    8000148e:	d0650513          	addi	a0,a0,-762 # 80008190 <digits+0x128>
    80001492:	fffff097          	auipc	ra,0xfffff
    80001496:	152080e7          	jalr	338(ra) # 800005e4 <panic>

000000008000149a <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa,
             int perm) {
    8000149a:	715d                	addi	sp,sp,-80
    8000149c:	e486                	sd	ra,72(sp)
    8000149e:	e0a2                	sd	s0,64(sp)
    800014a0:	fc26                	sd	s1,56(sp)
    800014a2:	f84a                	sd	s2,48(sp)
    800014a4:	f44e                	sd	s3,40(sp)
    800014a6:	f052                	sd	s4,32(sp)
    800014a8:	ec56                	sd	s5,24(sp)
    800014aa:	e85a                	sd	s6,16(sp)
    800014ac:	e45e                	sd	s7,8(sp)
    800014ae:	0880                	addi	s0,sp,80
    800014b0:	8aaa                	mv	s5,a0
    800014b2:	8b3a                	mv	s6,a4
  uint64 a, last;
  pte_t *pte;

  a = PGROUNDDOWN(va);
    800014b4:	777d                	lui	a4,0xfffff
    800014b6:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800014ba:	167d                	addi	a2,a2,-1
    800014bc:	00b609b3          	add	s3,a2,a1
    800014c0:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800014c4:	893e                	mv	s2,a5
    800014c6:	40f68a33          	sub	s4,a3,a5
    if (*pte & PTE_V)
      panic("remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last)
      break;
    a += PGSIZE;
    800014ca:	6b85                	lui	s7,0x1
    800014cc:	012a04b3          	add	s1,s4,s2
    if ((pte = walk(pagetable, a, 1)) == 0)
    800014d0:	4605                	li	a2,1
    800014d2:	85ca                	mv	a1,s2
    800014d4:	8556                	mv	a0,s5
    800014d6:	00000097          	auipc	ra,0x0
    800014da:	e88080e7          	jalr	-376(ra) # 8000135e <walk>
    800014de:	c51d                	beqz	a0,8000150c <mappages+0x72>
    if (*pte & PTE_V)
    800014e0:	611c                	ld	a5,0(a0)
    800014e2:	8b85                	andi	a5,a5,1
    800014e4:	ef81                	bnez	a5,800014fc <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800014e6:	80b1                	srli	s1,s1,0xc
    800014e8:	04aa                	slli	s1,s1,0xa
    800014ea:	0164e4b3          	or	s1,s1,s6
    800014ee:	0014e493          	ori	s1,s1,1
    800014f2:	e104                	sd	s1,0(a0)
    if (a == last)
    800014f4:	03390863          	beq	s2,s3,80001524 <mappages+0x8a>
    a += PGSIZE;
    800014f8:	995e                	add	s2,s2,s7
    if ((pte = walk(pagetable, a, 1)) == 0)
    800014fa:	bfc9                	j	800014cc <mappages+0x32>
      panic("remap");
    800014fc:	00007517          	auipc	a0,0x7
    80001500:	c9c50513          	addi	a0,a0,-868 # 80008198 <digits+0x130>
    80001504:	fffff097          	auipc	ra,0xfffff
    80001508:	0e0080e7          	jalr	224(ra) # 800005e4 <panic>
      return -1;
    8000150c:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000150e:	60a6                	ld	ra,72(sp)
    80001510:	6406                	ld	s0,64(sp)
    80001512:	74e2                	ld	s1,56(sp)
    80001514:	7942                	ld	s2,48(sp)
    80001516:	79a2                	ld	s3,40(sp)
    80001518:	7a02                	ld	s4,32(sp)
    8000151a:	6ae2                	ld	s5,24(sp)
    8000151c:	6b42                	ld	s6,16(sp)
    8000151e:	6ba2                	ld	s7,8(sp)
    80001520:	6161                	addi	sp,sp,80
    80001522:	8082                	ret
  return 0;
    80001524:	4501                	li	a0,0
    80001526:	b7e5                	j	8000150e <mappages+0x74>

0000000080001528 <kvmmap>:
void kvmmap(uint64 va, uint64 pa, uint64 sz, int perm) {
    80001528:	1141                	addi	sp,sp,-16
    8000152a:	e406                	sd	ra,8(sp)
    8000152c:	e022                	sd	s0,0(sp)
    8000152e:	0800                	addi	s0,sp,16
    80001530:	8736                	mv	a4,a3
  if (mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    80001532:	86ae                	mv	a3,a1
    80001534:	85aa                	mv	a1,a0
    80001536:	00008517          	auipc	a0,0x8
    8000153a:	ada53503          	ld	a0,-1318(a0) # 80009010 <kernel_pagetable>
    8000153e:	00000097          	auipc	ra,0x0
    80001542:	f5c080e7          	jalr	-164(ra) # 8000149a <mappages>
    80001546:	e509                	bnez	a0,80001550 <kvmmap+0x28>
}
    80001548:	60a2                	ld	ra,8(sp)
    8000154a:	6402                	ld	s0,0(sp)
    8000154c:	0141                	addi	sp,sp,16
    8000154e:	8082                	ret
    panic("kvmmap");
    80001550:	00007517          	auipc	a0,0x7
    80001554:	c5050513          	addi	a0,a0,-944 # 800081a0 <digits+0x138>
    80001558:	fffff097          	auipc	ra,0xfffff
    8000155c:	08c080e7          	jalr	140(ra) # 800005e4 <panic>

0000000080001560 <kvminit>:
void kvminit() {
    80001560:	1101                	addi	sp,sp,-32
    80001562:	ec06                	sd	ra,24(sp)
    80001564:	e822                	sd	s0,16(sp)
    80001566:	e426                	sd	s1,8(sp)
    80001568:	1000                	addi	s0,sp,32
  kernel_pagetable = (pagetable_t)kalloc();
    8000156a:	fffff097          	auipc	ra,0xfffff
    8000156e:	7fe080e7          	jalr	2046(ra) # 80000d68 <kalloc>
    80001572:	00008797          	auipc	a5,0x8
    80001576:	a8a7bf23          	sd	a0,-1378(a5) # 80009010 <kernel_pagetable>
  memset(kernel_pagetable, 0, PGSIZE);
    8000157a:	6605                	lui	a2,0x1
    8000157c:	4581                	li	a1,0
    8000157e:	00000097          	auipc	ra,0x0
    80001582:	af8080e7          	jalr	-1288(ra) # 80001076 <memset>
  kvmmap(UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001586:	4699                	li	a3,6
    80001588:	6605                	lui	a2,0x1
    8000158a:	100005b7          	lui	a1,0x10000
    8000158e:	10000537          	lui	a0,0x10000
    80001592:	00000097          	auipc	ra,0x0
    80001596:	f96080e7          	jalr	-106(ra) # 80001528 <kvmmap>
  kvmmap(VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000159a:	4699                	li	a3,6
    8000159c:	6605                	lui	a2,0x1
    8000159e:	100015b7          	lui	a1,0x10001
    800015a2:	10001537          	lui	a0,0x10001
    800015a6:	00000097          	auipc	ra,0x0
    800015aa:	f82080e7          	jalr	-126(ra) # 80001528 <kvmmap>
  kvmmap(CLINT, CLINT, 0x10000, PTE_R | PTE_W);
    800015ae:	4699                	li	a3,6
    800015b0:	6641                	lui	a2,0x10
    800015b2:	020005b7          	lui	a1,0x2000
    800015b6:	02000537          	lui	a0,0x2000
    800015ba:	00000097          	auipc	ra,0x0
    800015be:	f6e080e7          	jalr	-146(ra) # 80001528 <kvmmap>
  kvmmap(PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800015c2:	4699                	li	a3,6
    800015c4:	00400637          	lui	a2,0x400
    800015c8:	0c0005b7          	lui	a1,0xc000
    800015cc:	0c000537          	lui	a0,0xc000
    800015d0:	00000097          	auipc	ra,0x0
    800015d4:	f58080e7          	jalr	-168(ra) # 80001528 <kvmmap>
  kvmmap(KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    800015d8:	00007497          	auipc	s1,0x7
    800015dc:	a2848493          	addi	s1,s1,-1496 # 80008000 <etext>
    800015e0:	46a9                	li	a3,10
    800015e2:	80007617          	auipc	a2,0x80007
    800015e6:	a1e60613          	addi	a2,a2,-1506 # 8000 <_entry-0x7fff8000>
    800015ea:	4585                	li	a1,1
    800015ec:	05fe                	slli	a1,a1,0x1f
    800015ee:	852e                	mv	a0,a1
    800015f0:	00000097          	auipc	ra,0x0
    800015f4:	f38080e7          	jalr	-200(ra) # 80001528 <kvmmap>
  kvmmap((uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext, PTE_R | PTE_W);
    800015f8:	4699                	li	a3,6
    800015fa:	4645                	li	a2,17
    800015fc:	066e                	slli	a2,a2,0x1b
    800015fe:	8e05                	sub	a2,a2,s1
    80001600:	85a6                	mv	a1,s1
    80001602:	8526                	mv	a0,s1
    80001604:	00000097          	auipc	ra,0x0
    80001608:	f24080e7          	jalr	-220(ra) # 80001528 <kvmmap>
  kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000160c:	46a9                	li	a3,10
    8000160e:	6605                	lui	a2,0x1
    80001610:	00006597          	auipc	a1,0x6
    80001614:	9f058593          	addi	a1,a1,-1552 # 80007000 <_trampoline>
    80001618:	04000537          	lui	a0,0x4000
    8000161c:	157d                	addi	a0,a0,-1
    8000161e:	0532                	slli	a0,a0,0xc
    80001620:	00000097          	auipc	ra,0x0
    80001624:	f08080e7          	jalr	-248(ra) # 80001528 <kvmmap>
}
    80001628:	60e2                	ld	ra,24(sp)
    8000162a:	6442                	ld	s0,16(sp)
    8000162c:	64a2                	ld	s1,8(sp)
    8000162e:	6105                	addi	sp,sp,32
    80001630:	8082                	ret

0000000080001632 <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free) {
    80001632:	715d                	addi	sp,sp,-80
    80001634:	e486                	sd	ra,72(sp)
    80001636:	e0a2                	sd	s0,64(sp)
    80001638:	fc26                	sd	s1,56(sp)
    8000163a:	f84a                	sd	s2,48(sp)
    8000163c:	f44e                	sd	s3,40(sp)
    8000163e:	f052                	sd	s4,32(sp)
    80001640:	ec56                	sd	s5,24(sp)
    80001642:	e85a                	sd	s6,16(sp)
    80001644:	e45e                	sd	s7,8(sp)
    80001646:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  // printf("va %p npages %d\n", va, npages);
  if ((va % PGSIZE) != 0)
    80001648:	03459793          	slli	a5,a1,0x34
    8000164c:	e795                	bnez	a5,80001678 <uvmunmap+0x46>
    8000164e:	8a2a                	mv	s4,a0
    80001650:	892e                	mv	s2,a1
    80001652:	8b36                	mv	s6,a3
    panic("uvmunmap: not aligned");
  // int total = 0;
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80001654:	0632                	slli	a2,a2,0xc
    80001656:	00b609b3          	add	s3,a2,a1
      continue;
    // panic("uvmunmap: walk");
    if ((*pte & PTE_V) == 0)
      continue;
    // panic("uvmunmap: not mapped");
    if (PTE_FLAGS(*pte) == PTE_V)
    8000165a:	4b85                	li	s7,1
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    8000165c:	6a85                	lui	s5,0x1
    8000165e:	0535e263          	bltu	a1,s3,800016a2 <uvmunmap+0x70>
  }
  // if (myproc()->pid == 5) {
  //   backtrace();
  //   printf("sz %p pages %d  freed pages %d\n", myproc()->sz, npages, total);
  // }
}
    80001662:	60a6                	ld	ra,72(sp)
    80001664:	6406                	ld	s0,64(sp)
    80001666:	74e2                	ld	s1,56(sp)
    80001668:	7942                	ld	s2,48(sp)
    8000166a:	79a2                	ld	s3,40(sp)
    8000166c:	7a02                	ld	s4,32(sp)
    8000166e:	6ae2                	ld	s5,24(sp)
    80001670:	6b42                	ld	s6,16(sp)
    80001672:	6ba2                	ld	s7,8(sp)
    80001674:	6161                	addi	sp,sp,80
    80001676:	8082                	ret
    panic("uvmunmap: not aligned");
    80001678:	00007517          	auipc	a0,0x7
    8000167c:	b3050513          	addi	a0,a0,-1232 # 800081a8 <digits+0x140>
    80001680:	fffff097          	auipc	ra,0xfffff
    80001684:	f64080e7          	jalr	-156(ra) # 800005e4 <panic>
      panic("uvmunmap: not a leaf");
    80001688:	00007517          	auipc	a0,0x7
    8000168c:	b3850513          	addi	a0,a0,-1224 # 800081c0 <digits+0x158>
    80001690:	fffff097          	auipc	ra,0xfffff
    80001694:	f54080e7          	jalr	-172(ra) # 800005e4 <panic>
    *pte = 0;
    80001698:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    8000169c:	9956                	add	s2,s2,s5
    8000169e:	fd3972e3          	bgeu	s2,s3,80001662 <uvmunmap+0x30>
    if ((pte = walk(pagetable, a, 0)) == 0)
    800016a2:	4601                	li	a2,0
    800016a4:	85ca                	mv	a1,s2
    800016a6:	8552                	mv	a0,s4
    800016a8:	00000097          	auipc	ra,0x0
    800016ac:	cb6080e7          	jalr	-842(ra) # 8000135e <walk>
    800016b0:	84aa                	mv	s1,a0
    800016b2:	d56d                	beqz	a0,8000169c <uvmunmap+0x6a>
    if ((*pte & PTE_V) == 0)
    800016b4:	611c                	ld	a5,0(a0)
    800016b6:	0017f713          	andi	a4,a5,1
    800016ba:	d36d                	beqz	a4,8000169c <uvmunmap+0x6a>
    if (PTE_FLAGS(*pte) == PTE_V)
    800016bc:	3ff7f713          	andi	a4,a5,1023
    800016c0:	fd7704e3          	beq	a4,s7,80001688 <uvmunmap+0x56>
    if (do_free) {
    800016c4:	fc0b0ae3          	beqz	s6,80001698 <uvmunmap+0x66>
      uint64 pa = PTE2PA(*pte);
    800016c8:	83a9                	srli	a5,a5,0xa
      kfree((void *)pa);
    800016ca:	00c79513          	slli	a0,a5,0xc
    800016ce:	fffff097          	auipc	ra,0xfffff
    800016d2:	3bc080e7          	jalr	956(ra) # 80000a8a <kfree>
    800016d6:	b7c9                	j	80001698 <uvmunmap+0x66>

00000000800016d8 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t uvmcreate() {
    800016d8:	1101                	addi	sp,sp,-32
    800016da:	ec06                	sd	ra,24(sp)
    800016dc:	e822                	sd	s0,16(sp)
    800016de:	e426                	sd	s1,8(sp)
    800016e0:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    800016e2:	fffff097          	auipc	ra,0xfffff
    800016e6:	686080e7          	jalr	1670(ra) # 80000d68 <kalloc>
    800016ea:	84aa                	mv	s1,a0
  if (pagetable == 0)
    800016ec:	c519                	beqz	a0,800016fa <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800016ee:	6605                	lui	a2,0x1
    800016f0:	4581                	li	a1,0
    800016f2:	00000097          	auipc	ra,0x0
    800016f6:	984080e7          	jalr	-1660(ra) # 80001076 <memset>
  return pagetable;
}
    800016fa:	8526                	mv	a0,s1
    800016fc:	60e2                	ld	ra,24(sp)
    800016fe:	6442                	ld	s0,16(sp)
    80001700:	64a2                	ld	s1,8(sp)
    80001702:	6105                	addi	sp,sp,32
    80001704:	8082                	ret

0000000080001706 <uvminit>:

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvminit(pagetable_t pagetable, uchar *src, uint sz) {
    80001706:	7179                	addi	sp,sp,-48
    80001708:	f406                	sd	ra,40(sp)
    8000170a:	f022                	sd	s0,32(sp)
    8000170c:	ec26                	sd	s1,24(sp)
    8000170e:	e84a                	sd	s2,16(sp)
    80001710:	e44e                	sd	s3,8(sp)
    80001712:	e052                	sd	s4,0(sp)
    80001714:	1800                	addi	s0,sp,48
  char *mem;

  if (sz >= PGSIZE)
    80001716:	6785                	lui	a5,0x1
    80001718:	04f67863          	bgeu	a2,a5,80001768 <uvminit+0x62>
    8000171c:	8a2a                	mv	s4,a0
    8000171e:	89ae                	mv	s3,a1
    80001720:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80001722:	fffff097          	auipc	ra,0xfffff
    80001726:	646080e7          	jalr	1606(ra) # 80000d68 <kalloc>
    8000172a:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000172c:	6605                	lui	a2,0x1
    8000172e:	4581                	li	a1,0
    80001730:	00000097          	auipc	ra,0x0
    80001734:	946080e7          	jalr	-1722(ra) # 80001076 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    80001738:	4779                	li	a4,30
    8000173a:	86ca                	mv	a3,s2
    8000173c:	6605                	lui	a2,0x1
    8000173e:	4581                	li	a1,0
    80001740:	8552                	mv	a0,s4
    80001742:	00000097          	auipc	ra,0x0
    80001746:	d58080e7          	jalr	-680(ra) # 8000149a <mappages>
  memmove(mem, src, sz);
    8000174a:	8626                	mv	a2,s1
    8000174c:	85ce                	mv	a1,s3
    8000174e:	854a                	mv	a0,s2
    80001750:	00000097          	auipc	ra,0x0
    80001754:	982080e7          	jalr	-1662(ra) # 800010d2 <memmove>
}
    80001758:	70a2                	ld	ra,40(sp)
    8000175a:	7402                	ld	s0,32(sp)
    8000175c:	64e2                	ld	s1,24(sp)
    8000175e:	6942                	ld	s2,16(sp)
    80001760:	69a2                	ld	s3,8(sp)
    80001762:	6a02                	ld	s4,0(sp)
    80001764:	6145                	addi	sp,sp,48
    80001766:	8082                	ret
    panic("inituvm: more than a page");
    80001768:	00007517          	auipc	a0,0x7
    8000176c:	a7050513          	addi	a0,a0,-1424 # 800081d8 <digits+0x170>
    80001770:	fffff097          	auipc	ra,0xfffff
    80001774:	e74080e7          	jalr	-396(ra) # 800005e4 <panic>

0000000080001778 <uvmdealloc>:

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64 uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz) {
    80001778:	1101                	addi	sp,sp,-32
    8000177a:	ec06                	sd	ra,24(sp)
    8000177c:	e822                	sd	s0,16(sp)
    8000177e:	e426                	sd	s1,8(sp)
    80001780:	1000                	addi	s0,sp,32
  if (newsz >= oldsz)
    return oldsz;
    80001782:	84ae                	mv	s1,a1
  if (newsz >= oldsz)
    80001784:	00b67d63          	bgeu	a2,a1,8000179e <uvmdealloc+0x26>
    80001788:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
    8000178a:	6785                	lui	a5,0x1
    8000178c:	17fd                	addi	a5,a5,-1
    8000178e:	00f60733          	add	a4,a2,a5
    80001792:	767d                	lui	a2,0xfffff
    80001794:	8f71                	and	a4,a4,a2
    80001796:	97ae                	add	a5,a5,a1
    80001798:	8ff1                	and	a5,a5,a2
    8000179a:	00f76863          	bltu	a4,a5,800017aa <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000179e:	8526                	mv	a0,s1
    800017a0:	60e2                	ld	ra,24(sp)
    800017a2:	6442                	ld	s0,16(sp)
    800017a4:	64a2                	ld	s1,8(sp)
    800017a6:	6105                	addi	sp,sp,32
    800017a8:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800017aa:	8f99                	sub	a5,a5,a4
    800017ac:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800017ae:	4685                	li	a3,1
    800017b0:	0007861b          	sext.w	a2,a5
    800017b4:	85ba                	mv	a1,a4
    800017b6:	00000097          	auipc	ra,0x0
    800017ba:	e7c080e7          	jalr	-388(ra) # 80001632 <uvmunmap>
    800017be:	b7c5                	j	8000179e <uvmdealloc+0x26>

00000000800017c0 <uvmalloc>:
  if (newsz < oldsz)
    800017c0:	0ab66163          	bltu	a2,a1,80001862 <uvmalloc+0xa2>
uint64 uvmalloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz) {
    800017c4:	7139                	addi	sp,sp,-64
    800017c6:	fc06                	sd	ra,56(sp)
    800017c8:	f822                	sd	s0,48(sp)
    800017ca:	f426                	sd	s1,40(sp)
    800017cc:	f04a                	sd	s2,32(sp)
    800017ce:	ec4e                	sd	s3,24(sp)
    800017d0:	e852                	sd	s4,16(sp)
    800017d2:	e456                	sd	s5,8(sp)
    800017d4:	0080                	addi	s0,sp,64
    800017d6:	8aaa                	mv	s5,a0
    800017d8:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800017da:	6985                	lui	s3,0x1
    800017dc:	19fd                	addi	s3,s3,-1
    800017de:	95ce                	add	a1,a1,s3
    800017e0:	79fd                	lui	s3,0xfffff
    800017e2:	0135f9b3          	and	s3,a1,s3
  for (a = oldsz; a < newsz; a += PGSIZE) {
    800017e6:	08c9f063          	bgeu	s3,a2,80001866 <uvmalloc+0xa6>
    800017ea:	894e                	mv	s2,s3
    mem = kalloc();
    800017ec:	fffff097          	auipc	ra,0xfffff
    800017f0:	57c080e7          	jalr	1404(ra) # 80000d68 <kalloc>
    800017f4:	84aa                	mv	s1,a0
    if (mem == 0) {
    800017f6:	c51d                	beqz	a0,80001824 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800017f8:	6605                	lui	a2,0x1
    800017fa:	4581                	li	a1,0
    800017fc:	00000097          	auipc	ra,0x0
    80001800:	87a080e7          	jalr	-1926(ra) # 80001076 <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem,
    80001804:	4779                	li	a4,30
    80001806:	86a6                	mv	a3,s1
    80001808:	6605                	lui	a2,0x1
    8000180a:	85ca                	mv	a1,s2
    8000180c:	8556                	mv	a0,s5
    8000180e:	00000097          	auipc	ra,0x0
    80001812:	c8c080e7          	jalr	-884(ra) # 8000149a <mappages>
    80001816:	e905                	bnez	a0,80001846 <uvmalloc+0x86>
  for (a = oldsz; a < newsz; a += PGSIZE) {
    80001818:	6785                	lui	a5,0x1
    8000181a:	993e                	add	s2,s2,a5
    8000181c:	fd4968e3          	bltu	s2,s4,800017ec <uvmalloc+0x2c>
  return newsz;
    80001820:	8552                	mv	a0,s4
    80001822:	a809                	j	80001834 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80001824:	864e                	mv	a2,s3
    80001826:	85ca                	mv	a1,s2
    80001828:	8556                	mv	a0,s5
    8000182a:	00000097          	auipc	ra,0x0
    8000182e:	f4e080e7          	jalr	-178(ra) # 80001778 <uvmdealloc>
      return 0;
    80001832:	4501                	li	a0,0
}
    80001834:	70e2                	ld	ra,56(sp)
    80001836:	7442                	ld	s0,48(sp)
    80001838:	74a2                	ld	s1,40(sp)
    8000183a:	7902                	ld	s2,32(sp)
    8000183c:	69e2                	ld	s3,24(sp)
    8000183e:	6a42                	ld	s4,16(sp)
    80001840:	6aa2                	ld	s5,8(sp)
    80001842:	6121                	addi	sp,sp,64
    80001844:	8082                	ret
      kfree(mem);
    80001846:	8526                	mv	a0,s1
    80001848:	fffff097          	auipc	ra,0xfffff
    8000184c:	242080e7          	jalr	578(ra) # 80000a8a <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001850:	864e                	mv	a2,s3
    80001852:	85ca                	mv	a1,s2
    80001854:	8556                	mv	a0,s5
    80001856:	00000097          	auipc	ra,0x0
    8000185a:	f22080e7          	jalr	-222(ra) # 80001778 <uvmdealloc>
      return 0;
    8000185e:	4501                	li	a0,0
    80001860:	bfd1                	j	80001834 <uvmalloc+0x74>
    return oldsz;
    80001862:	852e                	mv	a0,a1
}
    80001864:	8082                	ret
  return newsz;
    80001866:	8532                	mv	a0,a2
    80001868:	b7f1                	j	80001834 <uvmalloc+0x74>

000000008000186a <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable) {
    8000186a:	7179                	addi	sp,sp,-48
    8000186c:	f406                	sd	ra,40(sp)
    8000186e:	f022                	sd	s0,32(sp)
    80001870:	ec26                	sd	s1,24(sp)
    80001872:	e84a                	sd	s2,16(sp)
    80001874:	e44e                	sd	s3,8(sp)
    80001876:	e052                	sd	s4,0(sp)
    80001878:	1800                	addi	s0,sp,48
    8000187a:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++) {
    8000187c:	84aa                	mv	s1,a0
    8000187e:	6905                	lui	s2,0x1
    80001880:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80001882:	4985                	li	s3,1
    80001884:	a821                	j	8000189c <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001886:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80001888:	0532                	slli	a0,a0,0xc
    8000188a:	00000097          	auipc	ra,0x0
    8000188e:	fe0080e7          	jalr	-32(ra) # 8000186a <freewalk>
      pagetable[i] = 0;
    80001892:	0004b023          	sd	zero,0(s1)
  for (int i = 0; i < 512; i++) {
    80001896:	04a1                	addi	s1,s1,8
    80001898:	03248163          	beq	s1,s2,800018ba <freewalk+0x50>
    pte_t pte = pagetable[i];
    8000189c:	6088                	ld	a0,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    8000189e:	00f57793          	andi	a5,a0,15
    800018a2:	ff3782e3          	beq	a5,s3,80001886 <freewalk+0x1c>
    } else if (pte & PTE_V) {
    800018a6:	8905                	andi	a0,a0,1
    800018a8:	d57d                	beqz	a0,80001896 <freewalk+0x2c>
      panic("freewalk: leaf");
    800018aa:	00007517          	auipc	a0,0x7
    800018ae:	94e50513          	addi	a0,a0,-1714 # 800081f8 <digits+0x190>
    800018b2:	fffff097          	auipc	ra,0xfffff
    800018b6:	d32080e7          	jalr	-718(ra) # 800005e4 <panic>
    }
  }
  kfree((void *)pagetable);
    800018ba:	8552                	mv	a0,s4
    800018bc:	fffff097          	auipc	ra,0xfffff
    800018c0:	1ce080e7          	jalr	462(ra) # 80000a8a <kfree>
}
    800018c4:	70a2                	ld	ra,40(sp)
    800018c6:	7402                	ld	s0,32(sp)
    800018c8:	64e2                	ld	s1,24(sp)
    800018ca:	6942                	ld	s2,16(sp)
    800018cc:	69a2                	ld	s3,8(sp)
    800018ce:	6a02                	ld	s4,0(sp)
    800018d0:	6145                	addi	sp,sp,48
    800018d2:	8082                	ret

00000000800018d4 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz) {
    800018d4:	1101                	addi	sp,sp,-32
    800018d6:	ec06                	sd	ra,24(sp)
    800018d8:	e822                	sd	s0,16(sp)
    800018da:	e426                	sd	s1,8(sp)
    800018dc:	1000                	addi	s0,sp,32
    800018de:	84aa                	mv	s1,a0
  if (sz > 0)
    800018e0:	e999                	bnez	a1,800018f6 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
    800018e2:	8526                	mv	a0,s1
    800018e4:	00000097          	auipc	ra,0x0
    800018e8:	f86080e7          	jalr	-122(ra) # 8000186a <freewalk>
}
    800018ec:	60e2                	ld	ra,24(sp)
    800018ee:	6442                	ld	s0,16(sp)
    800018f0:	64a2                	ld	s1,8(sp)
    800018f2:	6105                	addi	sp,sp,32
    800018f4:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    800018f6:	6605                	lui	a2,0x1
    800018f8:	167d                	addi	a2,a2,-1
    800018fa:	962e                	add	a2,a2,a1
    800018fc:	4685                	li	a3,1
    800018fe:	8231                	srli	a2,a2,0xc
    80001900:	4581                	li	a1,0
    80001902:	00000097          	auipc	ra,0x0
    80001906:	d30080e7          	jalr	-720(ra) # 80001632 <uvmunmap>
    8000190a:	bfe1                	j	800018e2 <uvmfree+0xe>

000000008000190c <uvmcopy>:
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) {
  pte_t *pte;
  uint64 i, pa;
  uint flags;

  for (i = 0; i < sz; i += PGSIZE) {
    8000190c:	ce55                	beqz	a2,800019c8 <uvmcopy+0xbc>
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) {
    8000190e:	711d                	addi	sp,sp,-96
    80001910:	ec86                	sd	ra,88(sp)
    80001912:	e8a2                	sd	s0,80(sp)
    80001914:	e4a6                	sd	s1,72(sp)
    80001916:	e0ca                	sd	s2,64(sp)
    80001918:	fc4e                	sd	s3,56(sp)
    8000191a:	f852                	sd	s4,48(sp)
    8000191c:	f456                	sd	s5,40(sp)
    8000191e:	f05a                	sd	s6,32(sp)
    80001920:	ec5e                	sd	s7,24(sp)
    80001922:	e862                	sd	s8,16(sp)
    80001924:	e466                	sd	s9,8(sp)
    80001926:	1080                	addi	s0,sp,96
    80001928:	89aa                	mv	s3,a0
    8000192a:	8aae                	mv	s5,a1
    8000192c:	8932                	mv	s2,a2
  for (i = 0; i < sz; i += PGSIZE) {
    8000192e:	4481                	li	s1,0
      goto err;
    }
    *pte &= ~PTE_W;
    *pte |= PTE_COW;
    *new_pte = *pte;
    page_ref_count[REF_IDX(pa)] += 1;
    80001930:	80000bb7          	lui	s7,0x80000
    80001934:	00010b17          	auipc	s6,0x10
    80001938:	17cb0b13          	addi	s6,s6,380 # 80011ab0 <page_ref_count>
  for (i = 0; i < sz; i += PGSIZE) {
    8000193c:	6a05                	lui	s4,0x1
    8000193e:	a839                	j	8000195c <uvmcopy+0x50>
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001940:	4685                	li	a3,1
    80001942:	00c4d613          	srli	a2,s1,0xc
    80001946:	4581                	li	a1,0
    80001948:	8556                	mv	a0,s5
    8000194a:	00000097          	auipc	ra,0x0
    8000194e:	ce8080e7          	jalr	-792(ra) # 80001632 <uvmunmap>
  return -1;
    80001952:	557d                	li	a0,-1
    80001954:	a8a9                	j	800019ae <uvmcopy+0xa2>
  for (i = 0; i < sz; i += PGSIZE) {
    80001956:	94d2                	add	s1,s1,s4
    80001958:	0524fa63          	bgeu	s1,s2,800019ac <uvmcopy+0xa0>
    if ((pte = walk(old, i, 0)) == 0)
    8000195c:	4601                	li	a2,0
    8000195e:	85a6                	mv	a1,s1
    80001960:	854e                	mv	a0,s3
    80001962:	00000097          	auipc	ra,0x0
    80001966:	9fc080e7          	jalr	-1540(ra) # 8000135e <walk>
    8000196a:	8caa                	mv	s9,a0
    8000196c:	d56d                	beqz	a0,80001956 <uvmcopy+0x4a>
    if ((*pte & PTE_V) == 0)
    8000196e:	611c                	ld	a5,0(a0)
    80001970:	0017f713          	andi	a4,a5,1
    80001974:	d36d                	beqz	a4,80001956 <uvmcopy+0x4a>
    pa = PTE2PA(*pte);
    80001976:	83a9                	srli	a5,a5,0xa
    80001978:	00c79c13          	slli	s8,a5,0xc
    pte_t *new_pte = walk(new, i, 1);
    8000197c:	4605                	li	a2,1
    8000197e:	85a6                	mv	a1,s1
    80001980:	8556                	mv	a0,s5
    80001982:	00000097          	auipc	ra,0x0
    80001986:	9dc080e7          	jalr	-1572(ra) # 8000135e <walk>
    if (new_pte == 0) {
    8000198a:	d95d                	beqz	a0,80001940 <uvmcopy+0x34>
    *pte &= ~PTE_W;
    8000198c:	000cb783          	ld	a5,0(s9)
    80001990:	9bed                	andi	a5,a5,-5
    *pte |= PTE_COW;
    80001992:	1007e793          	ori	a5,a5,256
    80001996:	00fcb023          	sd	a5,0(s9)
    *new_pte = *pte;
    8000199a:	e11c                	sd	a5,0(a0)
    page_ref_count[REF_IDX(pa)] += 1;
    8000199c:	017c07b3          	add	a5,s8,s7
    800019a0:	83a9                	srli	a5,a5,0xa
    800019a2:	97da                	add	a5,a5,s6
    800019a4:	4398                	lw	a4,0(a5)
    800019a6:	2705                	addiw	a4,a4,1
    800019a8:	c398                	sw	a4,0(a5)
    800019aa:	b775                	j	80001956 <uvmcopy+0x4a>
  return 0;
    800019ac:	4501                	li	a0,0
}
    800019ae:	60e6                	ld	ra,88(sp)
    800019b0:	6446                	ld	s0,80(sp)
    800019b2:	64a6                	ld	s1,72(sp)
    800019b4:	6906                	ld	s2,64(sp)
    800019b6:	79e2                	ld	s3,56(sp)
    800019b8:	7a42                	ld	s4,48(sp)
    800019ba:	7aa2                	ld	s5,40(sp)
    800019bc:	7b02                	ld	s6,32(sp)
    800019be:	6be2                	ld	s7,24(sp)
    800019c0:	6c42                	ld	s8,16(sp)
    800019c2:	6ca2                	ld	s9,8(sp)
    800019c4:	6125                	addi	sp,sp,96
    800019c6:	8082                	ret
  return 0;
    800019c8:	4501                	li	a0,0
}
    800019ca:	8082                	ret

00000000800019cc <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va) {
    800019cc:	1141                	addi	sp,sp,-16
    800019ce:	e406                	sd	ra,8(sp)
    800019d0:	e022                	sd	s0,0(sp)
    800019d2:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    800019d4:	4601                	li	a2,0
    800019d6:	00000097          	auipc	ra,0x0
    800019da:	988080e7          	jalr	-1656(ra) # 8000135e <walk>
  if (pte == 0)
    800019de:	c901                	beqz	a0,800019ee <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800019e0:	611c                	ld	a5,0(a0)
    800019e2:	9bbd                	andi	a5,a5,-17
    800019e4:	e11c                	sd	a5,0(a0)
}
    800019e6:	60a2                	ld	ra,8(sp)
    800019e8:	6402                	ld	s0,0(sp)
    800019ea:	0141                	addi	sp,sp,16
    800019ec:	8082                	ret
    panic("uvmclear");
    800019ee:	00007517          	auipc	a0,0x7
    800019f2:	81a50513          	addi	a0,a0,-2022 # 80008208 <digits+0x1a0>
    800019f6:	fffff097          	auipc	ra,0xfffff
    800019fa:	bee080e7          	jalr	-1042(ra) # 800005e4 <panic>

00000000800019fe <copyin>:
// Copy len bytes to dst from virtual address srcva in a given page table.
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len) {
  uint64 n, va0, pa0;

  while (len > 0) {
    800019fe:	caa5                	beqz	a3,80001a6e <copyin+0x70>
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len) {
    80001a00:	715d                	addi	sp,sp,-80
    80001a02:	e486                	sd	ra,72(sp)
    80001a04:	e0a2                	sd	s0,64(sp)
    80001a06:	fc26                	sd	s1,56(sp)
    80001a08:	f84a                	sd	s2,48(sp)
    80001a0a:	f44e                	sd	s3,40(sp)
    80001a0c:	f052                	sd	s4,32(sp)
    80001a0e:	ec56                	sd	s5,24(sp)
    80001a10:	e85a                	sd	s6,16(sp)
    80001a12:	e45e                	sd	s7,8(sp)
    80001a14:	e062                	sd	s8,0(sp)
    80001a16:	0880                	addi	s0,sp,80
    80001a18:	8b2a                	mv	s6,a0
    80001a1a:	8a2e                	mv	s4,a1
    80001a1c:	8c32                	mv	s8,a2
    80001a1e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001a20:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001a22:	6a85                	lui	s5,0x1
    80001a24:	a01d                	j	80001a4a <copyin+0x4c>
    if (n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001a26:	018505b3          	add	a1,a0,s8
    80001a2a:	0004861b          	sext.w	a2,s1
    80001a2e:	412585b3          	sub	a1,a1,s2
    80001a32:	8552                	mv	a0,s4
    80001a34:	fffff097          	auipc	ra,0xfffff
    80001a38:	69e080e7          	jalr	1694(ra) # 800010d2 <memmove>

    len -= n;
    80001a3c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001a40:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001a42:	01590c33          	add	s8,s2,s5
  while (len > 0) {
    80001a46:	02098263          	beqz	s3,80001a6a <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001a4a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001a4e:	85ca                	mv	a1,s2
    80001a50:	855a                	mv	a0,s6
    80001a52:	00000097          	auipc	ra,0x0
    80001a56:	9a8080e7          	jalr	-1624(ra) # 800013fa <walkaddr>
    if (pa0 == 0)
    80001a5a:	cd01                	beqz	a0,80001a72 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80001a5c:	418904b3          	sub	s1,s2,s8
    80001a60:	94d6                	add	s1,s1,s5
    if (n > len)
    80001a62:	fc99f2e3          	bgeu	s3,s1,80001a26 <copyin+0x28>
    80001a66:	84ce                	mv	s1,s3
    80001a68:	bf7d                	j	80001a26 <copyin+0x28>
  }
  return 0;
    80001a6a:	4501                	li	a0,0
    80001a6c:	a021                	j	80001a74 <copyin+0x76>
    80001a6e:	4501                	li	a0,0
}
    80001a70:	8082                	ret
      return -1;
    80001a72:	557d                	li	a0,-1
}
    80001a74:	60a6                	ld	ra,72(sp)
    80001a76:	6406                	ld	s0,64(sp)
    80001a78:	74e2                	ld	s1,56(sp)
    80001a7a:	7942                	ld	s2,48(sp)
    80001a7c:	79a2                	ld	s3,40(sp)
    80001a7e:	7a02                	ld	s4,32(sp)
    80001a80:	6ae2                	ld	s5,24(sp)
    80001a82:	6b42                	ld	s6,16(sp)
    80001a84:	6ba2                	ld	s7,8(sp)
    80001a86:	6c02                	ld	s8,0(sp)
    80001a88:	6161                	addi	sp,sp,80
    80001a8a:	8082                	ret

0000000080001a8c <copyinstr>:
// Return 0 on success, -1 on error.
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max) {
  uint64 n, va0, pa0;
  int got_null = 0;

  while (got_null == 0 && max > 0) {
    80001a8c:	c6c5                	beqz	a3,80001b34 <copyinstr+0xa8>
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max) {
    80001a8e:	715d                	addi	sp,sp,-80
    80001a90:	e486                	sd	ra,72(sp)
    80001a92:	e0a2                	sd	s0,64(sp)
    80001a94:	fc26                	sd	s1,56(sp)
    80001a96:	f84a                	sd	s2,48(sp)
    80001a98:	f44e                	sd	s3,40(sp)
    80001a9a:	f052                	sd	s4,32(sp)
    80001a9c:	ec56                	sd	s5,24(sp)
    80001a9e:	e85a                	sd	s6,16(sp)
    80001aa0:	e45e                	sd	s7,8(sp)
    80001aa2:	0880                	addi	s0,sp,80
    80001aa4:	8a2a                	mv	s4,a0
    80001aa6:	8b2e                	mv	s6,a1
    80001aa8:	8bb2                	mv	s7,a2
    80001aaa:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80001aac:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001aae:	6985                	lui	s3,0x1
    80001ab0:	a035                	j	80001adc <copyinstr+0x50>
      n = max;

    char *p = (char *)(pa0 + (srcva - va0));
    while (n > 0) {
      if (*p == '\0') {
        *dst = '\0';
    80001ab2:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001ab6:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if (got_null) {
    80001ab8:	0017b793          	seqz	a5,a5
    80001abc:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001ac0:	60a6                	ld	ra,72(sp)
    80001ac2:	6406                	ld	s0,64(sp)
    80001ac4:	74e2                	ld	s1,56(sp)
    80001ac6:	7942                	ld	s2,48(sp)
    80001ac8:	79a2                	ld	s3,40(sp)
    80001aca:	7a02                	ld	s4,32(sp)
    80001acc:	6ae2                	ld	s5,24(sp)
    80001ace:	6b42                	ld	s6,16(sp)
    80001ad0:	6ba2                	ld	s7,8(sp)
    80001ad2:	6161                	addi	sp,sp,80
    80001ad4:	8082                	ret
    srcva = va0 + PGSIZE;
    80001ad6:	01390bb3          	add	s7,s2,s3
  while (got_null == 0 && max > 0) {
    80001ada:	c8a9                	beqz	s1,80001b2c <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80001adc:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80001ae0:	85ca                	mv	a1,s2
    80001ae2:	8552                	mv	a0,s4
    80001ae4:	00000097          	auipc	ra,0x0
    80001ae8:	916080e7          	jalr	-1770(ra) # 800013fa <walkaddr>
    if (pa0 == 0)
    80001aec:	c131                	beqz	a0,80001b30 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80001aee:	41790833          	sub	a6,s2,s7
    80001af2:	984e                	add	a6,a6,s3
    if (n > max)
    80001af4:	0104f363          	bgeu	s1,a6,80001afa <copyinstr+0x6e>
    80001af8:	8826                	mv	a6,s1
    char *p = (char *)(pa0 + (srcva - va0));
    80001afa:	955e                	add	a0,a0,s7
    80001afc:	41250533          	sub	a0,a0,s2
    while (n > 0) {
    80001b00:	fc080be3          	beqz	a6,80001ad6 <copyinstr+0x4a>
    80001b04:	985a                	add	a6,a6,s6
    80001b06:	87da                	mv	a5,s6
      if (*p == '\0') {
    80001b08:	41650633          	sub	a2,a0,s6
    80001b0c:	14fd                	addi	s1,s1,-1
    80001b0e:	9b26                	add	s6,s6,s1
    80001b10:	00f60733          	add	a4,a2,a5
    80001b14:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffb9000>
    80001b18:	df49                	beqz	a4,80001ab2 <copyinstr+0x26>
        *dst = *p;
    80001b1a:	00e78023          	sb	a4,0(a5)
      --max;
    80001b1e:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80001b22:	0785                	addi	a5,a5,1
    while (n > 0) {
    80001b24:	ff0796e3          	bne	a5,a6,80001b10 <copyinstr+0x84>
      dst++;
    80001b28:	8b42                	mv	s6,a6
    80001b2a:	b775                	j	80001ad6 <copyinstr+0x4a>
    80001b2c:	4781                	li	a5,0
    80001b2e:	b769                	j	80001ab8 <copyinstr+0x2c>
      return -1;
    80001b30:	557d                	li	a0,-1
    80001b32:	b779                	j	80001ac0 <copyinstr+0x34>
  int got_null = 0;
    80001b34:	4781                	li	a5,0
  if (got_null) {
    80001b36:	0017b793          	seqz	a5,a5
    80001b3a:	40f00533          	neg	a0,a5
}
    80001b3e:	8082                	ret

0000000080001b40 <do_cow>:

int do_cow(pagetable_t pt, uint64 addr) {
    80001b40:	7179                	addi	sp,sp,-48
    80001b42:	f406                	sd	ra,40(sp)
    80001b44:	f022                	sd	s0,32(sp)
    80001b46:	ec26                	sd	s1,24(sp)
    80001b48:	e84a                	sd	s2,16(sp)
    80001b4a:	e44e                	sd	s3,8(sp)
    80001b4c:	e052                	sd	s4,0(sp)
    80001b4e:	1800                	addi	s0,sp,48
  pte_t *pte;
  uint64 pa;
  uint flags;
  char *mem;
  uint64 va = PGROUNDDOWN(addr);
  if ((pte = walk(pt, va, 0)) == 0)
    80001b50:	4601                	li	a2,0
    80001b52:	77fd                	lui	a5,0xfffff
    80001b54:	8dfd                	and	a1,a1,a5
    80001b56:	00000097          	auipc	ra,0x0
    80001b5a:	808080e7          	jalr	-2040(ra) # 8000135e <walk>
    80001b5e:	c141                	beqz	a0,80001bde <do_cow+0x9e>
    80001b60:	89aa                	mv	s3,a0
    panic("uvmcopy: pte should exist");
  if ((*pte & PTE_V) == 0)
    80001b62:	6104                	ld	s1,0(a0)
    80001b64:	0014f793          	andi	a5,s1,1
    80001b68:	c3d9                	beqz	a5,80001bee <do_cow+0xae>
    panic("uvmcopy: page not present");
  pa = PTE2PA(*pte);
    80001b6a:	00a4da13          	srli	s4,s1,0xa
    80001b6e:	0a32                	slli	s4,s4,0xc
  flags = PTE_FLAGS(*pte);
  flags |= PTE_W;
  flags &= ~PTE_COW;
  if (page_ref_count[REF_IDX(pa)] == 1) {
    80001b70:	800007b7          	lui	a5,0x80000
    80001b74:	97d2                	add	a5,a5,s4
    80001b76:	00c7d693          	srli	a3,a5,0xc
    80001b7a:	83a9                	srli	a5,a5,0xa
    80001b7c:	00010717          	auipc	a4,0x10
    80001b80:	f3470713          	addi	a4,a4,-204 # 80011ab0 <page_ref_count>
    80001b84:	97ba                	add	a5,a5,a4
    80001b86:	439c                	lw	a5,0(a5)
    80001b88:	4705                	li	a4,1
    80001b8a:	06e78a63          	beq	a5,a4,80001bfe <do_cow+0xbe>
    *pte |= PTE_W;
    *pte &= ~PTE_COW;
    return 0;
  }
  page_ref_count[REF_IDX(pa)] -= 1;
    80001b8e:	068a                	slli	a3,a3,0x2
    80001b90:	00010717          	auipc	a4,0x10
    80001b94:	f2070713          	addi	a4,a4,-224 # 80011ab0 <page_ref_count>
    80001b98:	96ba                	add	a3,a3,a4
    80001b9a:	37fd                	addiw	a5,a5,-1
    80001b9c:	c29c                	sw	a5,0(a3)
  if ((mem = kalloc()) == 0)
    80001b9e:	fffff097          	auipc	ra,0xfffff
    80001ba2:	1ca080e7          	jalr	458(ra) # 80000d68 <kalloc>
    80001ba6:	892a                	mv	s2,a0
    80001ba8:	c135                	beqz	a0,80001c0c <do_cow+0xcc>
    return -1;
  memmove(mem, (char *)pa, PGSIZE);
    80001baa:	6605                	lui	a2,0x1
    80001bac:	85d2                	mv	a1,s4
    80001bae:	fffff097          	auipc	ra,0xfffff
    80001bb2:	524080e7          	jalr	1316(ra) # 800010d2 <memmove>
  *pte = PA2PTE(mem) | flags;
    80001bb6:	00c95913          	srli	s2,s2,0xc
    80001bba:	092a                	slli	s2,s2,0xa
  flags &= ~PTE_COW;
    80001bbc:	2ff4f493          	andi	s1,s1,767
  *pte = PA2PTE(mem) | flags;
    80001bc0:	0044e493          	ori	s1,s1,4
    80001bc4:	009964b3          	or	s1,s2,s1
    80001bc8:	0099b023          	sd	s1,0(s3) # 1000 <_entry-0x7ffff000>

  return 0;
    80001bcc:	4501                	li	a0,0
}
    80001bce:	70a2                	ld	ra,40(sp)
    80001bd0:	7402                	ld	s0,32(sp)
    80001bd2:	64e2                	ld	s1,24(sp)
    80001bd4:	6942                	ld	s2,16(sp)
    80001bd6:	69a2                	ld	s3,8(sp)
    80001bd8:	6a02                	ld	s4,0(sp)
    80001bda:	6145                	addi	sp,sp,48
    80001bdc:	8082                	ret
    panic("uvmcopy: pte should exist");
    80001bde:	00006517          	auipc	a0,0x6
    80001be2:	63a50513          	addi	a0,a0,1594 # 80008218 <digits+0x1b0>
    80001be6:	fffff097          	auipc	ra,0xfffff
    80001bea:	9fe080e7          	jalr	-1538(ra) # 800005e4 <panic>
    panic("uvmcopy: page not present");
    80001bee:	00006517          	auipc	a0,0x6
    80001bf2:	64a50513          	addi	a0,a0,1610 # 80008238 <digits+0x1d0>
    80001bf6:	fffff097          	auipc	ra,0xfffff
    80001bfa:	9ee080e7          	jalr	-1554(ra) # 800005e4 <panic>
    *pte &= ~PTE_COW;
    80001bfe:	eff4f493          	andi	s1,s1,-257
    80001c02:	0044e493          	ori	s1,s1,4
    80001c06:	e104                	sd	s1,0(a0)
    return 0;
    80001c08:	4501                	li	a0,0
    80001c0a:	b7d1                	j	80001bce <do_cow+0x8e>
    return -1;
    80001c0c:	557d                	li	a0,-1
    80001c0e:	b7c1                	j	80001bce <do_cow+0x8e>

0000000080001c10 <do_lazy_allocation>:

int do_lazy_allocation(pagetable_t pt, u64 addr) {
    80001c10:	7179                	addi	sp,sp,-48
    80001c12:	f406                	sd	ra,40(sp)
    80001c14:	f022                	sd	s0,32(sp)
    80001c16:	ec26                	sd	s1,24(sp)
    80001c18:	e84a                	sd	s2,16(sp)
    80001c1a:	e44e                	sd	s3,8(sp)
    80001c1c:	1800                	addi	s0,sp,48
    80001c1e:	892a                	mv	s2,a0
  u64 va, pa;
  va = PGROUNDDOWN(addr);
    80001c20:	79fd                	lui	s3,0xfffff
    80001c22:	0135f9b3          	and	s3,a1,s3
  if ((pa = (u64)kalloc()) == 0) {
    80001c26:	fffff097          	auipc	ra,0xfffff
    80001c2a:	142080e7          	jalr	322(ra) # 80000d68 <kalloc>
    80001c2e:	c121                	beqz	a0,80001c6e <do_lazy_allocation+0x5e>
    80001c30:	84aa                	mv	s1,a0
    // uvmdealloc(pt, va + PGSIZE, va);
    return -1;
  }
  memset((void *)pa, 0, PGSIZE);
    80001c32:	6605                	lui	a2,0x1
    80001c34:	4581                	li	a1,0
    80001c36:	fffff097          	auipc	ra,0xfffff
    80001c3a:	440080e7          	jalr	1088(ra) # 80001076 <memset>
  if (mappages(pt, va, PGSIZE, pa, PTE_R | PTE_W | PTE_X | PTE_U) != 0) {
    80001c3e:	4779                	li	a4,30
    80001c40:	86a6                	mv	a3,s1
    80001c42:	6605                	lui	a2,0x1
    80001c44:	85ce                	mv	a1,s3
    80001c46:	854a                	mv	a0,s2
    80001c48:	00000097          	auipc	ra,0x0
    80001c4c:	852080e7          	jalr	-1966(ra) # 8000149a <mappages>
    80001c50:	e901                	bnez	a0,80001c60 <do_lazy_allocation+0x50>
    kfree((void *)pa);
    // uvmdealloc(pt, va + PGSIZE, va);
    return -2;
  }
  return 0;
}
    80001c52:	70a2                	ld	ra,40(sp)
    80001c54:	7402                	ld	s0,32(sp)
    80001c56:	64e2                	ld	s1,24(sp)
    80001c58:	6942                	ld	s2,16(sp)
    80001c5a:	69a2                	ld	s3,8(sp)
    80001c5c:	6145                	addi	sp,sp,48
    80001c5e:	8082                	ret
    kfree((void *)pa);
    80001c60:	8526                	mv	a0,s1
    80001c62:	fffff097          	auipc	ra,0xfffff
    80001c66:	e28080e7          	jalr	-472(ra) # 80000a8a <kfree>
    return -2;
    80001c6a:	5579                	li	a0,-2
    80001c6c:	b7dd                	j	80001c52 <do_lazy_allocation+0x42>
    return -1;
    80001c6e:	557d                	li	a0,-1
    80001c70:	b7cd                	j	80001c52 <do_lazy_allocation+0x42>

0000000080001c72 <copyout>:
  while (len > 0) {
    80001c72:	c695                	beqz	a3,80001c9e <copyout+0x2c>
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
    80001c74:	715d                	addi	sp,sp,-80
    80001c76:	e486                	sd	ra,72(sp)
    80001c78:	e0a2                	sd	s0,64(sp)
    80001c7a:	fc26                	sd	s1,56(sp)
    80001c7c:	f84a                	sd	s2,48(sp)
    80001c7e:	f44e                	sd	s3,40(sp)
    80001c80:	f052                	sd	s4,32(sp)
    80001c82:	ec56                	sd	s5,24(sp)
    80001c84:	e85a                	sd	s6,16(sp)
    80001c86:	e45e                	sd	s7,8(sp)
    80001c88:	e062                	sd	s8,0(sp)
    80001c8a:	0880                	addi	s0,sp,80
    80001c8c:	8b2a                	mv	s6,a0
    80001c8e:	89ae                	mv	s3,a1
    80001c90:	8ab2                	mv	s5,a2
    80001c92:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    80001c94:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (dstva - va0);
    80001c96:	6b85                	lui	s7,0x1
    80001c98:	a061                	j	80001d20 <copyout+0xae>
  return 0;
    80001c9a:	4501                	li	a0,0
    80001c9c:	a031                	j	80001ca8 <copyout+0x36>
    80001c9e:	4501                	li	a0,0
}
    80001ca0:	8082                	ret
        return -1;
    80001ca2:	557d                	li	a0,-1
    80001ca4:	a011                	j	80001ca8 <copyout+0x36>
      return -1;
    80001ca6:	557d                	li	a0,-1
}
    80001ca8:	60a6                	ld	ra,72(sp)
    80001caa:	6406                	ld	s0,64(sp)
    80001cac:	74e2                	ld	s1,56(sp)
    80001cae:	7942                	ld	s2,48(sp)
    80001cb0:	79a2                	ld	s3,40(sp)
    80001cb2:	7a02                	ld	s4,32(sp)
    80001cb4:	6ae2                	ld	s5,24(sp)
    80001cb6:	6b42                	ld	s6,16(sp)
    80001cb8:	6ba2                	ld	s7,8(sp)
    80001cba:	6c02                	ld	s8,0(sp)
    80001cbc:	6161                	addi	sp,sp,80
    80001cbe:	8082                	ret
    if ((!pte || !(*pte & PTE_V)) && va0 < myproc()->sz) {
    80001cc0:	00000097          	auipc	ra,0x0
    80001cc4:	1e6080e7          	jalr	486(ra) # 80001ea6 <myproc>
    80001cc8:	653c                	ld	a5,72(a0)
    80001cca:	06f97963          	bgeu	s2,a5,80001d3c <copyout+0xca>
      if (do_lazy_allocation(myproc()->pagetable, va0) != 0) {
    80001cce:	00000097          	auipc	ra,0x0
    80001cd2:	1d8080e7          	jalr	472(ra) # 80001ea6 <myproc>
    80001cd6:	85ca                	mv	a1,s2
    80001cd8:	6928                	ld	a0,80(a0)
    80001cda:	00000097          	auipc	ra,0x0
    80001cde:	f36080e7          	jalr	-202(ra) # 80001c10 <do_lazy_allocation>
    80001ce2:	f161                	bnez	a0,80001ca2 <copyout+0x30>
    pa0 = walkaddr(pagetable, va0);
    80001ce4:	85ca                	mv	a1,s2
    80001ce6:	855a                	mv	a0,s6
    80001ce8:	fffff097          	auipc	ra,0xfffff
    80001cec:	712080e7          	jalr	1810(ra) # 800013fa <walkaddr>
    if (pa0 == 0)
    80001cf0:	d95d                	beqz	a0,80001ca6 <copyout+0x34>
    n = PGSIZE - (dstva - va0);
    80001cf2:	413904b3          	sub	s1,s2,s3
    80001cf6:	94de                	add	s1,s1,s7
    if (n > len)
    80001cf8:	009a7363          	bgeu	s4,s1,80001cfe <copyout+0x8c>
    80001cfc:	84d2                	mv	s1,s4
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001cfe:	412989b3          	sub	s3,s3,s2
    80001d02:	0004861b          	sext.w	a2,s1
    80001d06:	85d6                	mv	a1,s5
    80001d08:	954e                	add	a0,a0,s3
    80001d0a:	fffff097          	auipc	ra,0xfffff
    80001d0e:	3c8080e7          	jalr	968(ra) # 800010d2 <memmove>
    len -= n;
    80001d12:	409a0a33          	sub	s4,s4,s1
    src += n;
    80001d16:	9aa6                	add	s5,s5,s1
    dstva = va0 + PGSIZE;
    80001d18:	017909b3          	add	s3,s2,s7
  while (len > 0) {
    80001d1c:	f60a0fe3          	beqz	s4,80001c9a <copyout+0x28>
    va0 = PGROUNDDOWN(dstva);
    80001d20:	0189f933          	and	s2,s3,s8
    pte_t *pte = walk(pagetable, va0, 0);
    80001d24:	4601                	li	a2,0
    80001d26:	85ca                	mv	a1,s2
    80001d28:	855a                	mv	a0,s6
    80001d2a:	fffff097          	auipc	ra,0xfffff
    80001d2e:	634080e7          	jalr	1588(ra) # 8000135e <walk>
    80001d32:	84aa                	mv	s1,a0
    if ((!pte || !(*pte & PTE_V)) && va0 < myproc()->sz) {
    80001d34:	c10d                	beqz	a0,80001d56 <copyout+0xe4>
    80001d36:	611c                	ld	a5,0(a0)
    80001d38:	8b85                	andi	a5,a5,1
    80001d3a:	d3d9                	beqz	a5,80001cc0 <copyout+0x4e>
    } else if (pte && (*pte & PTE_COW)) {
    80001d3c:	609c                	ld	a5,0(s1)
    80001d3e:	1007f793          	andi	a5,a5,256
    80001d42:	d3cd                	beqz	a5,80001ce4 <copyout+0x72>
      if (do_cow(pagetable, va0) != 0)
    80001d44:	85ca                	mv	a1,s2
    80001d46:	855a                	mv	a0,s6
    80001d48:	00000097          	auipc	ra,0x0
    80001d4c:	df8080e7          	jalr	-520(ra) # 80001b40 <do_cow>
    80001d50:	d951                	beqz	a0,80001ce4 <copyout+0x72>
        return -2;
    80001d52:	5579                	li	a0,-2
    80001d54:	bf91                	j	80001ca8 <copyout+0x36>
    if ((!pte || !(*pte & PTE_V)) && va0 < myproc()->sz) {
    80001d56:	00000097          	auipc	ra,0x0
    80001d5a:	150080e7          	jalr	336(ra) # 80001ea6 <myproc>
    80001d5e:	653c                	ld	a5,72(a0)
    80001d60:	f8f972e3          	bgeu	s2,a5,80001ce4 <copyout+0x72>
    80001d64:	b7ad                	j	80001cce <copyout+0x5c>

0000000080001d66 <wakeup1>:
  }
}

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void wakeup1(struct proc *p) {
    80001d66:	1101                	addi	sp,sp,-32
    80001d68:	ec06                	sd	ra,24(sp)
    80001d6a:	e822                	sd	s0,16(sp)
    80001d6c:	e426                	sd	s1,8(sp)
    80001d6e:	1000                	addi	s0,sp,32
    80001d70:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    80001d72:	fffff097          	auipc	ra,0xfffff
    80001d76:	18e080e7          	jalr	398(ra) # 80000f00 <holding>
    80001d7a:	c909                	beqz	a0,80001d8c <wakeup1+0x26>
    panic("wakeup1");
  if (p->chan == p && p->state == SLEEPING) {
    80001d7c:	749c                	ld	a5,40(s1)
    80001d7e:	00978f63          	beq	a5,s1,80001d9c <wakeup1+0x36>
    p->state = RUNNABLE;
  }
}
    80001d82:	60e2                	ld	ra,24(sp)
    80001d84:	6442                	ld	s0,16(sp)
    80001d86:	64a2                	ld	s1,8(sp)
    80001d88:	6105                	addi	sp,sp,32
    80001d8a:	8082                	ret
    panic("wakeup1");
    80001d8c:	00006517          	auipc	a0,0x6
    80001d90:	4cc50513          	addi	a0,a0,1228 # 80008258 <digits+0x1f0>
    80001d94:	fffff097          	auipc	ra,0xfffff
    80001d98:	850080e7          	jalr	-1968(ra) # 800005e4 <panic>
  if (p->chan == p && p->state == SLEEPING) {
    80001d9c:	4c98                	lw	a4,24(s1)
    80001d9e:	4785                	li	a5,1
    80001da0:	fef711e3          	bne	a4,a5,80001d82 <wakeup1+0x1c>
    p->state = RUNNABLE;
    80001da4:	4789                	li	a5,2
    80001da6:	cc9c                	sw	a5,24(s1)
}
    80001da8:	bfe9                	j	80001d82 <wakeup1+0x1c>

0000000080001daa <procinit>:
void procinit(void) {
    80001daa:	715d                	addi	sp,sp,-80
    80001dac:	e486                	sd	ra,72(sp)
    80001dae:	e0a2                	sd	s0,64(sp)
    80001db0:	fc26                	sd	s1,56(sp)
    80001db2:	f84a                	sd	s2,48(sp)
    80001db4:	f44e                	sd	s3,40(sp)
    80001db6:	f052                	sd	s4,32(sp)
    80001db8:	ec56                	sd	s5,24(sp)
    80001dba:	e85a                	sd	s6,16(sp)
    80001dbc:	e45e                	sd	s7,8(sp)
    80001dbe:	0880                	addi	s0,sp,80
  initlock(&pid_lock, "nextpid");
    80001dc0:	00006597          	auipc	a1,0x6
    80001dc4:	4a058593          	addi	a1,a1,1184 # 80008260 <digits+0x1f8>
    80001dc8:	00030517          	auipc	a0,0x30
    80001dcc:	ce850513          	addi	a0,a0,-792 # 80031ab0 <pid_lock>
    80001dd0:	fffff097          	auipc	ra,0xfffff
    80001dd4:	11a080e7          	jalr	282(ra) # 80000eea <initlock>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001dd8:	00030917          	auipc	s2,0x30
    80001ddc:	0f090913          	addi	s2,s2,240 # 80031ec8 <proc>
    initlock(&p->lock, "proc");
    80001de0:	00006b97          	auipc	s7,0x6
    80001de4:	488b8b93          	addi	s7,s7,1160 # 80008268 <digits+0x200>
    uint64 va = KSTACK((int)(p - proc));
    80001de8:	8b4a                	mv	s6,s2
    80001dea:	00006a97          	auipc	s5,0x6
    80001dee:	216a8a93          	addi	s5,s5,534 # 80008000 <etext>
    80001df2:	040009b7          	lui	s3,0x4000
    80001df6:	19fd                	addi	s3,s3,-1
    80001df8:	09b2                	slli	s3,s3,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    80001dfa:	00036a17          	auipc	s4,0x36
    80001dfe:	acea0a13          	addi	s4,s4,-1330 # 800378c8 <tickslock>
    initlock(&p->lock, "proc");
    80001e02:	85de                	mv	a1,s7
    80001e04:	854a                	mv	a0,s2
    80001e06:	fffff097          	auipc	ra,0xfffff
    80001e0a:	0e4080e7          	jalr	228(ra) # 80000eea <initlock>
    char *pa = kalloc();
    80001e0e:	fffff097          	auipc	ra,0xfffff
    80001e12:	f5a080e7          	jalr	-166(ra) # 80000d68 <kalloc>
    80001e16:	85aa                	mv	a1,a0
    if (pa == 0)
    80001e18:	c929                	beqz	a0,80001e6a <procinit+0xc0>
    uint64 va = KSTACK((int)(p - proc));
    80001e1a:	416904b3          	sub	s1,s2,s6
    80001e1e:	848d                	srai	s1,s1,0x3
    80001e20:	000ab783          	ld	a5,0(s5)
    80001e24:	02f484b3          	mul	s1,s1,a5
    80001e28:	2485                	addiw	s1,s1,1
    80001e2a:	00d4949b          	slliw	s1,s1,0xd
    80001e2e:	409984b3          	sub	s1,s3,s1
    kvmmap(va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001e32:	4699                	li	a3,6
    80001e34:	6605                	lui	a2,0x1
    80001e36:	8526                	mv	a0,s1
    80001e38:	fffff097          	auipc	ra,0xfffff
    80001e3c:	6f0080e7          	jalr	1776(ra) # 80001528 <kvmmap>
    p->kstack = va;
    80001e40:	04993023          	sd	s1,64(s2)
  for (p = proc; p < &proc[NPROC]; p++) {
    80001e44:	16890913          	addi	s2,s2,360
    80001e48:	fb491de3          	bne	s2,s4,80001e02 <procinit+0x58>
  kvminithart();
    80001e4c:	fffff097          	auipc	ra,0xfffff
    80001e50:	4ee080e7          	jalr	1262(ra) # 8000133a <kvminithart>
}
    80001e54:	60a6                	ld	ra,72(sp)
    80001e56:	6406                	ld	s0,64(sp)
    80001e58:	74e2                	ld	s1,56(sp)
    80001e5a:	7942                	ld	s2,48(sp)
    80001e5c:	79a2                	ld	s3,40(sp)
    80001e5e:	7a02                	ld	s4,32(sp)
    80001e60:	6ae2                	ld	s5,24(sp)
    80001e62:	6b42                	ld	s6,16(sp)
    80001e64:	6ba2                	ld	s7,8(sp)
    80001e66:	6161                	addi	sp,sp,80
    80001e68:	8082                	ret
      panic("kalloc");
    80001e6a:	00006517          	auipc	a0,0x6
    80001e6e:	40650513          	addi	a0,a0,1030 # 80008270 <digits+0x208>
    80001e72:	ffffe097          	auipc	ra,0xffffe
    80001e76:	772080e7          	jalr	1906(ra) # 800005e4 <panic>

0000000080001e7a <cpuid>:
int cpuid() {
    80001e7a:	1141                	addi	sp,sp,-16
    80001e7c:	e422                	sd	s0,8(sp)
    80001e7e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r"(x));
    80001e80:	8512                	mv	a0,tp
}
    80001e82:	2501                	sext.w	a0,a0
    80001e84:	6422                	ld	s0,8(sp)
    80001e86:	0141                	addi	sp,sp,16
    80001e88:	8082                	ret

0000000080001e8a <mycpu>:
struct cpu *mycpu(void) {
    80001e8a:	1141                	addi	sp,sp,-16
    80001e8c:	e422                	sd	s0,8(sp)
    80001e8e:	0800                	addi	s0,sp,16
    80001e90:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    80001e92:	2781                	sext.w	a5,a5
    80001e94:	079e                	slli	a5,a5,0x7
}
    80001e96:	00030517          	auipc	a0,0x30
    80001e9a:	c3250513          	addi	a0,a0,-974 # 80031ac8 <cpus>
    80001e9e:	953e                	add	a0,a0,a5
    80001ea0:	6422                	ld	s0,8(sp)
    80001ea2:	0141                	addi	sp,sp,16
    80001ea4:	8082                	ret

0000000080001ea6 <myproc>:
struct proc *myproc(void) {
    80001ea6:	1101                	addi	sp,sp,-32
    80001ea8:	ec06                	sd	ra,24(sp)
    80001eaa:	e822                	sd	s0,16(sp)
    80001eac:	e426                	sd	s1,8(sp)
    80001eae:	1000                	addi	s0,sp,32
  push_off();
    80001eb0:	fffff097          	auipc	ra,0xfffff
    80001eb4:	07e080e7          	jalr	126(ra) # 80000f2e <push_off>
    80001eb8:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    80001eba:	2781                	sext.w	a5,a5
    80001ebc:	079e                	slli	a5,a5,0x7
    80001ebe:	00030717          	auipc	a4,0x30
    80001ec2:	bf270713          	addi	a4,a4,-1038 # 80031ab0 <pid_lock>
    80001ec6:	97ba                	add	a5,a5,a4
    80001ec8:	6f84                	ld	s1,24(a5)
  pop_off();
    80001eca:	fffff097          	auipc	ra,0xfffff
    80001ece:	104080e7          	jalr	260(ra) # 80000fce <pop_off>
}
    80001ed2:	8526                	mv	a0,s1
    80001ed4:	60e2                	ld	ra,24(sp)
    80001ed6:	6442                	ld	s0,16(sp)
    80001ed8:	64a2                	ld	s1,8(sp)
    80001eda:	6105                	addi	sp,sp,32
    80001edc:	8082                	ret

0000000080001ede <forkret>:
void forkret(void) {
    80001ede:	1141                	addi	sp,sp,-16
    80001ee0:	e406                	sd	ra,8(sp)
    80001ee2:	e022                	sd	s0,0(sp)
    80001ee4:	0800                	addi	s0,sp,16
  release(&myproc()->lock);
    80001ee6:	00000097          	auipc	ra,0x0
    80001eea:	fc0080e7          	jalr	-64(ra) # 80001ea6 <myproc>
    80001eee:	fffff097          	auipc	ra,0xfffff
    80001ef2:	140080e7          	jalr	320(ra) # 8000102e <release>
  if (first) {
    80001ef6:	00007797          	auipc	a5,0x7
    80001efa:	a1a7a783          	lw	a5,-1510(a5) # 80008910 <first.1>
    80001efe:	eb89                	bnez	a5,80001f10 <forkret+0x32>
  usertrapret();
    80001f00:	00001097          	auipc	ra,0x1
    80001f04:	c18080e7          	jalr	-1000(ra) # 80002b18 <usertrapret>
}
    80001f08:	60a2                	ld	ra,8(sp)
    80001f0a:	6402                	ld	s0,0(sp)
    80001f0c:	0141                	addi	sp,sp,16
    80001f0e:	8082                	ret
    first = 0;
    80001f10:	00007797          	auipc	a5,0x7
    80001f14:	a007a023          	sw	zero,-1536(a5) # 80008910 <first.1>
    fsinit(ROOTDEV);
    80001f18:	4505                	li	a0,1
    80001f1a:	00002097          	auipc	ra,0x2
    80001f1e:	a3a080e7          	jalr	-1478(ra) # 80003954 <fsinit>
    80001f22:	bff9                	j	80001f00 <forkret+0x22>

0000000080001f24 <allocpid>:
int allocpid() {
    80001f24:	1101                	addi	sp,sp,-32
    80001f26:	ec06                	sd	ra,24(sp)
    80001f28:	e822                	sd	s0,16(sp)
    80001f2a:	e426                	sd	s1,8(sp)
    80001f2c:	e04a                	sd	s2,0(sp)
    80001f2e:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001f30:	00030917          	auipc	s2,0x30
    80001f34:	b8090913          	addi	s2,s2,-1152 # 80031ab0 <pid_lock>
    80001f38:	854a                	mv	a0,s2
    80001f3a:	fffff097          	auipc	ra,0xfffff
    80001f3e:	040080e7          	jalr	64(ra) # 80000f7a <acquire>
  pid = nextpid;
    80001f42:	00007797          	auipc	a5,0x7
    80001f46:	9d278793          	addi	a5,a5,-1582 # 80008914 <nextpid>
    80001f4a:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001f4c:	0014871b          	addiw	a4,s1,1
    80001f50:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001f52:	854a                	mv	a0,s2
    80001f54:	fffff097          	auipc	ra,0xfffff
    80001f58:	0da080e7          	jalr	218(ra) # 8000102e <release>
}
    80001f5c:	8526                	mv	a0,s1
    80001f5e:	60e2                	ld	ra,24(sp)
    80001f60:	6442                	ld	s0,16(sp)
    80001f62:	64a2                	ld	s1,8(sp)
    80001f64:	6902                	ld	s2,0(sp)
    80001f66:	6105                	addi	sp,sp,32
    80001f68:	8082                	ret

0000000080001f6a <proc_pagetable>:
pagetable_t proc_pagetable(struct proc *p) {
    80001f6a:	1101                	addi	sp,sp,-32
    80001f6c:	ec06                	sd	ra,24(sp)
    80001f6e:	e822                	sd	s0,16(sp)
    80001f70:	e426                	sd	s1,8(sp)
    80001f72:	e04a                	sd	s2,0(sp)
    80001f74:	1000                	addi	s0,sp,32
    80001f76:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001f78:	fffff097          	auipc	ra,0xfffff
    80001f7c:	760080e7          	jalr	1888(ra) # 800016d8 <uvmcreate>
    80001f80:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80001f82:	c121                	beqz	a0,80001fc2 <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
    80001f84:	4729                	li	a4,10
    80001f86:	00005697          	auipc	a3,0x5
    80001f8a:	07a68693          	addi	a3,a3,122 # 80007000 <_trampoline>
    80001f8e:	6605                	lui	a2,0x1
    80001f90:	040005b7          	lui	a1,0x4000
    80001f94:	15fd                	addi	a1,a1,-1
    80001f96:	05b2                	slli	a1,a1,0xc
    80001f98:	fffff097          	auipc	ra,0xfffff
    80001f9c:	502080e7          	jalr	1282(ra) # 8000149a <mappages>
    80001fa0:	02054863          	bltz	a0,80001fd0 <proc_pagetable+0x66>
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe),
    80001fa4:	4719                	li	a4,6
    80001fa6:	05893683          	ld	a3,88(s2)
    80001faa:	6605                	lui	a2,0x1
    80001fac:	020005b7          	lui	a1,0x2000
    80001fb0:	15fd                	addi	a1,a1,-1
    80001fb2:	05b6                	slli	a1,a1,0xd
    80001fb4:	8526                	mv	a0,s1
    80001fb6:	fffff097          	auipc	ra,0xfffff
    80001fba:	4e4080e7          	jalr	1252(ra) # 8000149a <mappages>
    80001fbe:	02054163          	bltz	a0,80001fe0 <proc_pagetable+0x76>
}
    80001fc2:	8526                	mv	a0,s1
    80001fc4:	60e2                	ld	ra,24(sp)
    80001fc6:	6442                	ld	s0,16(sp)
    80001fc8:	64a2                	ld	s1,8(sp)
    80001fca:	6902                	ld	s2,0(sp)
    80001fcc:	6105                	addi	sp,sp,32
    80001fce:	8082                	ret
    uvmfree(pagetable, 0);
    80001fd0:	4581                	li	a1,0
    80001fd2:	8526                	mv	a0,s1
    80001fd4:	00000097          	auipc	ra,0x0
    80001fd8:	900080e7          	jalr	-1792(ra) # 800018d4 <uvmfree>
    return 0;
    80001fdc:	4481                	li	s1,0
    80001fde:	b7d5                	j	80001fc2 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001fe0:	4681                	li	a3,0
    80001fe2:	4605                	li	a2,1
    80001fe4:	040005b7          	lui	a1,0x4000
    80001fe8:	15fd                	addi	a1,a1,-1
    80001fea:	05b2                	slli	a1,a1,0xc
    80001fec:	8526                	mv	a0,s1
    80001fee:	fffff097          	auipc	ra,0xfffff
    80001ff2:	644080e7          	jalr	1604(ra) # 80001632 <uvmunmap>
    uvmfree(pagetable, 0);
    80001ff6:	4581                	li	a1,0
    80001ff8:	8526                	mv	a0,s1
    80001ffa:	00000097          	auipc	ra,0x0
    80001ffe:	8da080e7          	jalr	-1830(ra) # 800018d4 <uvmfree>
    return 0;
    80002002:	4481                	li	s1,0
    80002004:	bf7d                	j	80001fc2 <proc_pagetable+0x58>

0000000080002006 <proc_freepagetable>:
void proc_freepagetable(pagetable_t pagetable, uint64 sz) {
    80002006:	1101                	addi	sp,sp,-32
    80002008:	ec06                	sd	ra,24(sp)
    8000200a:	e822                	sd	s0,16(sp)
    8000200c:	e426                	sd	s1,8(sp)
    8000200e:	e04a                	sd	s2,0(sp)
    80002010:	1000                	addi	s0,sp,32
    80002012:	84aa                	mv	s1,a0
    80002014:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80002016:	4681                	li	a3,0
    80002018:	4605                	li	a2,1
    8000201a:	040005b7          	lui	a1,0x4000
    8000201e:	15fd                	addi	a1,a1,-1
    80002020:	05b2                	slli	a1,a1,0xc
    80002022:	fffff097          	auipc	ra,0xfffff
    80002026:	610080e7          	jalr	1552(ra) # 80001632 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000202a:	4681                	li	a3,0
    8000202c:	4605                	li	a2,1
    8000202e:	020005b7          	lui	a1,0x2000
    80002032:	15fd                	addi	a1,a1,-1
    80002034:	05b6                	slli	a1,a1,0xd
    80002036:	8526                	mv	a0,s1
    80002038:	fffff097          	auipc	ra,0xfffff
    8000203c:	5fa080e7          	jalr	1530(ra) # 80001632 <uvmunmap>
  uvmfree(pagetable, sz);
    80002040:	85ca                	mv	a1,s2
    80002042:	8526                	mv	a0,s1
    80002044:	00000097          	auipc	ra,0x0
    80002048:	890080e7          	jalr	-1904(ra) # 800018d4 <uvmfree>
}
    8000204c:	60e2                	ld	ra,24(sp)
    8000204e:	6442                	ld	s0,16(sp)
    80002050:	64a2                	ld	s1,8(sp)
    80002052:	6902                	ld	s2,0(sp)
    80002054:	6105                	addi	sp,sp,32
    80002056:	8082                	ret

0000000080002058 <freeproc>:
static void freeproc(struct proc *p) {
    80002058:	1101                	addi	sp,sp,-32
    8000205a:	ec06                	sd	ra,24(sp)
    8000205c:	e822                	sd	s0,16(sp)
    8000205e:	e426                	sd	s1,8(sp)
    80002060:	1000                	addi	s0,sp,32
    80002062:	84aa                	mv	s1,a0
  if (p->trapframe)
    80002064:	6d28                	ld	a0,88(a0)
    80002066:	c509                	beqz	a0,80002070 <freeproc+0x18>
    kfree((void *)p->trapframe);
    80002068:	fffff097          	auipc	ra,0xfffff
    8000206c:	a22080e7          	jalr	-1502(ra) # 80000a8a <kfree>
  p->trapframe = 0;
    80002070:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable)
    80002074:	68a8                	ld	a0,80(s1)
    80002076:	c511                	beqz	a0,80002082 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80002078:	64ac                	ld	a1,72(s1)
    8000207a:	00000097          	auipc	ra,0x0
    8000207e:	f8c080e7          	jalr	-116(ra) # 80002006 <proc_freepagetable>
  p->pagetable = 0;
    80002082:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80002086:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000208a:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    8000208e:	0204b023          	sd	zero,32(s1)
  p->name[0] = 0;
    80002092:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80002096:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    8000209a:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    8000209e:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    800020a2:	0004ac23          	sw	zero,24(s1)
}
    800020a6:	60e2                	ld	ra,24(sp)
    800020a8:	6442                	ld	s0,16(sp)
    800020aa:	64a2                	ld	s1,8(sp)
    800020ac:	6105                	addi	sp,sp,32
    800020ae:	8082                	ret

00000000800020b0 <allocproc>:
static struct proc *allocproc(void) {
    800020b0:	1101                	addi	sp,sp,-32
    800020b2:	ec06                	sd	ra,24(sp)
    800020b4:	e822                	sd	s0,16(sp)
    800020b6:	e426                	sd	s1,8(sp)
    800020b8:	e04a                	sd	s2,0(sp)
    800020ba:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++) {
    800020bc:	00030497          	auipc	s1,0x30
    800020c0:	e0c48493          	addi	s1,s1,-500 # 80031ec8 <proc>
    800020c4:	00036917          	auipc	s2,0x36
    800020c8:	80490913          	addi	s2,s2,-2044 # 800378c8 <tickslock>
    acquire(&p->lock);
    800020cc:	8526                	mv	a0,s1
    800020ce:	fffff097          	auipc	ra,0xfffff
    800020d2:	eac080e7          	jalr	-340(ra) # 80000f7a <acquire>
    if (p->state == UNUSED) {
    800020d6:	4c9c                	lw	a5,24(s1)
    800020d8:	cf81                	beqz	a5,800020f0 <allocproc+0x40>
      release(&p->lock);
    800020da:	8526                	mv	a0,s1
    800020dc:	fffff097          	auipc	ra,0xfffff
    800020e0:	f52080e7          	jalr	-174(ra) # 8000102e <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    800020e4:	16848493          	addi	s1,s1,360
    800020e8:	ff2492e3          	bne	s1,s2,800020cc <allocproc+0x1c>
  return 0;
    800020ec:	4481                	li	s1,0
    800020ee:	a0b9                	j	8000213c <allocproc+0x8c>
  p->pid = allocpid();
    800020f0:	00000097          	auipc	ra,0x0
    800020f4:	e34080e7          	jalr	-460(ra) # 80001f24 <allocpid>
    800020f8:	dc88                	sw	a0,56(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    800020fa:	fffff097          	auipc	ra,0xfffff
    800020fe:	c6e080e7          	jalr	-914(ra) # 80000d68 <kalloc>
    80002102:	892a                	mv	s2,a0
    80002104:	eca8                	sd	a0,88(s1)
    80002106:	c131                	beqz	a0,8000214a <allocproc+0x9a>
  p->pagetable = proc_pagetable(p);
    80002108:	8526                	mv	a0,s1
    8000210a:	00000097          	auipc	ra,0x0
    8000210e:	e60080e7          	jalr	-416(ra) # 80001f6a <proc_pagetable>
    80002112:	892a                	mv	s2,a0
    80002114:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0) {
    80002116:	c129                	beqz	a0,80002158 <allocproc+0xa8>
  memset(&p->context, 0, sizeof(p->context));
    80002118:	07000613          	li	a2,112
    8000211c:	4581                	li	a1,0
    8000211e:	06048513          	addi	a0,s1,96
    80002122:	fffff097          	auipc	ra,0xfffff
    80002126:	f54080e7          	jalr	-172(ra) # 80001076 <memset>
  p->context.ra = (uint64)forkret;
    8000212a:	00000797          	auipc	a5,0x0
    8000212e:	db478793          	addi	a5,a5,-588 # 80001ede <forkret>
    80002132:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80002134:	60bc                	ld	a5,64(s1)
    80002136:	6705                	lui	a4,0x1
    80002138:	97ba                	add	a5,a5,a4
    8000213a:	f4bc                	sd	a5,104(s1)
}
    8000213c:	8526                	mv	a0,s1
    8000213e:	60e2                	ld	ra,24(sp)
    80002140:	6442                	ld	s0,16(sp)
    80002142:	64a2                	ld	s1,8(sp)
    80002144:	6902                	ld	s2,0(sp)
    80002146:	6105                	addi	sp,sp,32
    80002148:	8082                	ret
    release(&p->lock);
    8000214a:	8526                	mv	a0,s1
    8000214c:	fffff097          	auipc	ra,0xfffff
    80002150:	ee2080e7          	jalr	-286(ra) # 8000102e <release>
    return 0;
    80002154:	84ca                	mv	s1,s2
    80002156:	b7dd                	j	8000213c <allocproc+0x8c>
    freeproc(p);
    80002158:	8526                	mv	a0,s1
    8000215a:	00000097          	auipc	ra,0x0
    8000215e:	efe080e7          	jalr	-258(ra) # 80002058 <freeproc>
    release(&p->lock);
    80002162:	8526                	mv	a0,s1
    80002164:	fffff097          	auipc	ra,0xfffff
    80002168:	eca080e7          	jalr	-310(ra) # 8000102e <release>
    return 0;
    8000216c:	84ca                	mv	s1,s2
    8000216e:	b7f9                	j	8000213c <allocproc+0x8c>

0000000080002170 <userinit>:
void userinit(void) {
    80002170:	1101                	addi	sp,sp,-32
    80002172:	ec06                	sd	ra,24(sp)
    80002174:	e822                	sd	s0,16(sp)
    80002176:	e426                	sd	s1,8(sp)
    80002178:	1000                	addi	s0,sp,32
  p = allocproc();
    8000217a:	00000097          	auipc	ra,0x0
    8000217e:	f36080e7          	jalr	-202(ra) # 800020b0 <allocproc>
    80002182:	84aa                	mv	s1,a0
  initproc = p;
    80002184:	00007797          	auipc	a5,0x7
    80002188:	e8a7ba23          	sd	a0,-364(a5) # 80009018 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000218c:	03400613          	li	a2,52
    80002190:	00006597          	auipc	a1,0x6
    80002194:	79058593          	addi	a1,a1,1936 # 80008920 <initcode>
    80002198:	6928                	ld	a0,80(a0)
    8000219a:	fffff097          	auipc	ra,0xfffff
    8000219e:	56c080e7          	jalr	1388(ra) # 80001706 <uvminit>
  p->sz = PGSIZE;
    800021a2:	6785                	lui	a5,0x1
    800021a4:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;     // user program counter
    800021a6:	6cb8                	ld	a4,88(s1)
    800021a8:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE; // user stack pointer
    800021ac:	6cb8                	ld	a4,88(s1)
    800021ae:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800021b0:	4641                	li	a2,16
    800021b2:	00006597          	auipc	a1,0x6
    800021b6:	0c658593          	addi	a1,a1,198 # 80008278 <digits+0x210>
    800021ba:	15848513          	addi	a0,s1,344
    800021be:	fffff097          	auipc	ra,0xfffff
    800021c2:	00a080e7          	jalr	10(ra) # 800011c8 <safestrcpy>
  p->cwd = namei("/");
    800021c6:	00006517          	auipc	a0,0x6
    800021ca:	0c250513          	addi	a0,a0,194 # 80008288 <digits+0x220>
    800021ce:	00002097          	auipc	ra,0x2
    800021d2:	1b2080e7          	jalr	434(ra) # 80004380 <namei>
    800021d6:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800021da:	4789                	li	a5,2
    800021dc:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800021de:	8526                	mv	a0,s1
    800021e0:	fffff097          	auipc	ra,0xfffff
    800021e4:	e4e080e7          	jalr	-434(ra) # 8000102e <release>
}
    800021e8:	60e2                	ld	ra,24(sp)
    800021ea:	6442                	ld	s0,16(sp)
    800021ec:	64a2                	ld	s1,8(sp)
    800021ee:	6105                	addi	sp,sp,32
    800021f0:	8082                	ret

00000000800021f2 <growproc>:
int growproc(int n) {
    800021f2:	1101                	addi	sp,sp,-32
    800021f4:	ec06                	sd	ra,24(sp)
    800021f6:	e822                	sd	s0,16(sp)
    800021f8:	e426                	sd	s1,8(sp)
    800021fa:	e04a                	sd	s2,0(sp)
    800021fc:	1000                	addi	s0,sp,32
    800021fe:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002200:	00000097          	auipc	ra,0x0
    80002204:	ca6080e7          	jalr	-858(ra) # 80001ea6 <myproc>
    80002208:	892a                	mv	s2,a0
  sz = p->sz;
    8000220a:	652c                	ld	a1,72(a0)
    8000220c:	0005861b          	sext.w	a2,a1
  if (n > 0) {
    80002210:	00904f63          	bgtz	s1,8000222e <growproc+0x3c>
  } else if (n < 0) {
    80002214:	0204cc63          	bltz	s1,8000224c <growproc+0x5a>
  p->sz = sz;
    80002218:	1602                	slli	a2,a2,0x20
    8000221a:	9201                	srli	a2,a2,0x20
    8000221c:	04c93423          	sd	a2,72(s2)
  return 0;
    80002220:	4501                	li	a0,0
}
    80002222:	60e2                	ld	ra,24(sp)
    80002224:	6442                	ld	s0,16(sp)
    80002226:	64a2                	ld	s1,8(sp)
    80002228:	6902                	ld	s2,0(sp)
    8000222a:	6105                	addi	sp,sp,32
    8000222c:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000222e:	9e25                	addw	a2,a2,s1
    80002230:	1602                	slli	a2,a2,0x20
    80002232:	9201                	srli	a2,a2,0x20
    80002234:	1582                	slli	a1,a1,0x20
    80002236:	9181                	srli	a1,a1,0x20
    80002238:	6928                	ld	a0,80(a0)
    8000223a:	fffff097          	auipc	ra,0xfffff
    8000223e:	586080e7          	jalr	1414(ra) # 800017c0 <uvmalloc>
    80002242:	0005061b          	sext.w	a2,a0
    80002246:	fa69                	bnez	a2,80002218 <growproc+0x26>
      return -1;
    80002248:	557d                	li	a0,-1
    8000224a:	bfe1                	j	80002222 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000224c:	9e25                	addw	a2,a2,s1
    8000224e:	1602                	slli	a2,a2,0x20
    80002250:	9201                	srli	a2,a2,0x20
    80002252:	1582                	slli	a1,a1,0x20
    80002254:	9181                	srli	a1,a1,0x20
    80002256:	6928                	ld	a0,80(a0)
    80002258:	fffff097          	auipc	ra,0xfffff
    8000225c:	520080e7          	jalr	1312(ra) # 80001778 <uvmdealloc>
    80002260:	0005061b          	sext.w	a2,a0
    80002264:	bf55                	j	80002218 <growproc+0x26>

0000000080002266 <fork>:
int fork(void) {
    80002266:	7139                	addi	sp,sp,-64
    80002268:	fc06                	sd	ra,56(sp)
    8000226a:	f822                	sd	s0,48(sp)
    8000226c:	f426                	sd	s1,40(sp)
    8000226e:	f04a                	sd	s2,32(sp)
    80002270:	ec4e                	sd	s3,24(sp)
    80002272:	e852                	sd	s4,16(sp)
    80002274:	e456                	sd	s5,8(sp)
    80002276:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80002278:	00000097          	auipc	ra,0x0
    8000227c:	c2e080e7          	jalr	-978(ra) # 80001ea6 <myproc>
    80002280:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0) {
    80002282:	00000097          	auipc	ra,0x0
    80002286:	e2e080e7          	jalr	-466(ra) # 800020b0 <allocproc>
    8000228a:	c17d                	beqz	a0,80002370 <fork+0x10a>
    8000228c:	8a2a                	mv	s4,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    8000228e:	048ab603          	ld	a2,72(s5)
    80002292:	692c                	ld	a1,80(a0)
    80002294:	050ab503          	ld	a0,80(s5)
    80002298:	fffff097          	auipc	ra,0xfffff
    8000229c:	674080e7          	jalr	1652(ra) # 8000190c <uvmcopy>
    800022a0:	04054a63          	bltz	a0,800022f4 <fork+0x8e>
  np->sz = p->sz;
    800022a4:	048ab783          	ld	a5,72(s5)
    800022a8:	04fa3423          	sd	a5,72(s4)
  np->parent = p;
    800022ac:	035a3023          	sd	s5,32(s4)
  *(np->trapframe) = *(p->trapframe);
    800022b0:	058ab683          	ld	a3,88(s5)
    800022b4:	87b6                	mv	a5,a3
    800022b6:	058a3703          	ld	a4,88(s4)
    800022ba:	12068693          	addi	a3,a3,288
    800022be:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800022c2:	6788                	ld	a0,8(a5)
    800022c4:	6b8c                	ld	a1,16(a5)
    800022c6:	6f90                	ld	a2,24(a5)
    800022c8:	01073023          	sd	a6,0(a4)
    800022cc:	e708                	sd	a0,8(a4)
    800022ce:	eb0c                	sd	a1,16(a4)
    800022d0:	ef10                	sd	a2,24(a4)
    800022d2:	02078793          	addi	a5,a5,32
    800022d6:	02070713          	addi	a4,a4,32
    800022da:	fed792e3          	bne	a5,a3,800022be <fork+0x58>
  np->trapframe->a0 = 0;
    800022de:	058a3783          	ld	a5,88(s4)
    800022e2:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    800022e6:	0d0a8493          	addi	s1,s5,208
    800022ea:	0d0a0913          	addi	s2,s4,208
    800022ee:	150a8993          	addi	s3,s5,336
    800022f2:	a00d                	j	80002314 <fork+0xae>
    freeproc(np);
    800022f4:	8552                	mv	a0,s4
    800022f6:	00000097          	auipc	ra,0x0
    800022fa:	d62080e7          	jalr	-670(ra) # 80002058 <freeproc>
    release(&np->lock);
    800022fe:	8552                	mv	a0,s4
    80002300:	fffff097          	auipc	ra,0xfffff
    80002304:	d2e080e7          	jalr	-722(ra) # 8000102e <release>
    return -1;
    80002308:	54fd                	li	s1,-1
    8000230a:	a889                	j	8000235c <fork+0xf6>
  for (i = 0; i < NOFILE; i++)
    8000230c:	04a1                	addi	s1,s1,8
    8000230e:	0921                	addi	s2,s2,8
    80002310:	01348b63          	beq	s1,s3,80002326 <fork+0xc0>
    if (p->ofile[i])
    80002314:	6088                	ld	a0,0(s1)
    80002316:	d97d                	beqz	a0,8000230c <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80002318:	00002097          	auipc	ra,0x2
    8000231c:	6f4080e7          	jalr	1780(ra) # 80004a0c <filedup>
    80002320:	00a93023          	sd	a0,0(s2)
    80002324:	b7e5                	j	8000230c <fork+0xa6>
  np->cwd = idup(p->cwd);
    80002326:	150ab503          	ld	a0,336(s5)
    8000232a:	00002097          	auipc	ra,0x2
    8000232e:	864080e7          	jalr	-1948(ra) # 80003b8e <idup>
    80002332:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80002336:	4641                	li	a2,16
    80002338:	158a8593          	addi	a1,s5,344
    8000233c:	158a0513          	addi	a0,s4,344
    80002340:	fffff097          	auipc	ra,0xfffff
    80002344:	e88080e7          	jalr	-376(ra) # 800011c8 <safestrcpy>
  pid = np->pid;
    80002348:	038a2483          	lw	s1,56(s4)
  np->state = RUNNABLE;
    8000234c:	4789                	li	a5,2
    8000234e:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80002352:	8552                	mv	a0,s4
    80002354:	fffff097          	auipc	ra,0xfffff
    80002358:	cda080e7          	jalr	-806(ra) # 8000102e <release>
}
    8000235c:	8526                	mv	a0,s1
    8000235e:	70e2                	ld	ra,56(sp)
    80002360:	7442                	ld	s0,48(sp)
    80002362:	74a2                	ld	s1,40(sp)
    80002364:	7902                	ld	s2,32(sp)
    80002366:	69e2                	ld	s3,24(sp)
    80002368:	6a42                	ld	s4,16(sp)
    8000236a:	6aa2                	ld	s5,8(sp)
    8000236c:	6121                	addi	sp,sp,64
    8000236e:	8082                	ret
    return -1;
    80002370:	54fd                	li	s1,-1
    80002372:	b7ed                	j	8000235c <fork+0xf6>

0000000080002374 <reparent>:
void reparent(struct proc *p) {
    80002374:	7179                	addi	sp,sp,-48
    80002376:	f406                	sd	ra,40(sp)
    80002378:	f022                	sd	s0,32(sp)
    8000237a:	ec26                	sd	s1,24(sp)
    8000237c:	e84a                	sd	s2,16(sp)
    8000237e:	e44e                	sd	s3,8(sp)
    80002380:	e052                	sd	s4,0(sp)
    80002382:	1800                	addi	s0,sp,48
    80002384:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002386:	00030497          	auipc	s1,0x30
    8000238a:	b4248493          	addi	s1,s1,-1214 # 80031ec8 <proc>
      pp->parent = initproc;
    8000238e:	00007a17          	auipc	s4,0x7
    80002392:	c8aa0a13          	addi	s4,s4,-886 # 80009018 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002396:	00035997          	auipc	s3,0x35
    8000239a:	53298993          	addi	s3,s3,1330 # 800378c8 <tickslock>
    8000239e:	a029                	j	800023a8 <reparent+0x34>
    800023a0:	16848493          	addi	s1,s1,360
    800023a4:	03348363          	beq	s1,s3,800023ca <reparent+0x56>
    if (pp->parent == p) {
    800023a8:	709c                	ld	a5,32(s1)
    800023aa:	ff279be3          	bne	a5,s2,800023a0 <reparent+0x2c>
      acquire(&pp->lock);
    800023ae:	8526                	mv	a0,s1
    800023b0:	fffff097          	auipc	ra,0xfffff
    800023b4:	bca080e7          	jalr	-1078(ra) # 80000f7a <acquire>
      pp->parent = initproc;
    800023b8:	000a3783          	ld	a5,0(s4)
    800023bc:	f09c                	sd	a5,32(s1)
      release(&pp->lock);
    800023be:	8526                	mv	a0,s1
    800023c0:	fffff097          	auipc	ra,0xfffff
    800023c4:	c6e080e7          	jalr	-914(ra) # 8000102e <release>
    800023c8:	bfe1                	j	800023a0 <reparent+0x2c>
}
    800023ca:	70a2                	ld	ra,40(sp)
    800023cc:	7402                	ld	s0,32(sp)
    800023ce:	64e2                	ld	s1,24(sp)
    800023d0:	6942                	ld	s2,16(sp)
    800023d2:	69a2                	ld	s3,8(sp)
    800023d4:	6a02                	ld	s4,0(sp)
    800023d6:	6145                	addi	sp,sp,48
    800023d8:	8082                	ret

00000000800023da <scheduler>:
void scheduler(void) {
    800023da:	711d                	addi	sp,sp,-96
    800023dc:	ec86                	sd	ra,88(sp)
    800023de:	e8a2                	sd	s0,80(sp)
    800023e0:	e4a6                	sd	s1,72(sp)
    800023e2:	e0ca                	sd	s2,64(sp)
    800023e4:	fc4e                	sd	s3,56(sp)
    800023e6:	f852                	sd	s4,48(sp)
    800023e8:	f456                	sd	s5,40(sp)
    800023ea:	f05a                	sd	s6,32(sp)
    800023ec:	ec5e                	sd	s7,24(sp)
    800023ee:	e862                	sd	s8,16(sp)
    800023f0:	e466                	sd	s9,8(sp)
    800023f2:	1080                	addi	s0,sp,96
    800023f4:	8792                	mv	a5,tp
  int id = r_tp();
    800023f6:	2781                	sext.w	a5,a5
  c->proc = 0;
    800023f8:	00779c13          	slli	s8,a5,0x7
    800023fc:	0002f717          	auipc	a4,0x2f
    80002400:	6b470713          	addi	a4,a4,1716 # 80031ab0 <pid_lock>
    80002404:	9762                	add	a4,a4,s8
    80002406:	00073c23          	sd	zero,24(a4)
        swtch(&c->context, &p->context);
    8000240a:	0002f717          	auipc	a4,0x2f
    8000240e:	6c670713          	addi	a4,a4,1734 # 80031ad0 <cpus+0x8>
    80002412:	9c3a                	add	s8,s8,a4
    int nproc = 0;
    80002414:	4c81                	li	s9,0
      if (p->state == RUNNABLE) {
    80002416:	4a89                	li	s5,2
        c->proc = p;
    80002418:	079e                	slli	a5,a5,0x7
    8000241a:	0002fb17          	auipc	s6,0x2f
    8000241e:	696b0b13          	addi	s6,s6,1686 # 80031ab0 <pid_lock>
    80002422:	9b3e                	add	s6,s6,a5
    for (p = proc; p < &proc[NPROC]; p++) {
    80002424:	00035a17          	auipc	s4,0x35
    80002428:	4a4a0a13          	addi	s4,s4,1188 # 800378c8 <tickslock>
    8000242c:	a8a1                	j	80002484 <scheduler+0xaa>
      release(&p->lock);
    8000242e:	8526                	mv	a0,s1
    80002430:	fffff097          	auipc	ra,0xfffff
    80002434:	bfe080e7          	jalr	-1026(ra) # 8000102e <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    80002438:	16848493          	addi	s1,s1,360
    8000243c:	03448a63          	beq	s1,s4,80002470 <scheduler+0x96>
      acquire(&p->lock);
    80002440:	8526                	mv	a0,s1
    80002442:	fffff097          	auipc	ra,0xfffff
    80002446:	b38080e7          	jalr	-1224(ra) # 80000f7a <acquire>
      if (p->state != UNUSED) {
    8000244a:	4c9c                	lw	a5,24(s1)
    8000244c:	d3ed                	beqz	a5,8000242e <scheduler+0x54>
        nproc++;
    8000244e:	2985                	addiw	s3,s3,1
      if (p->state == RUNNABLE) {
    80002450:	fd579fe3          	bne	a5,s5,8000242e <scheduler+0x54>
        p->state = RUNNING;
    80002454:	0174ac23          	sw	s7,24(s1)
        c->proc = p;
    80002458:	009b3c23          	sd	s1,24(s6)
        swtch(&c->context, &p->context);
    8000245c:	06048593          	addi	a1,s1,96
    80002460:	8562                	mv	a0,s8
    80002462:	00000097          	auipc	ra,0x0
    80002466:	60c080e7          	jalr	1548(ra) # 80002a6e <swtch>
        c->proc = 0;
    8000246a:	000b3c23          	sd	zero,24(s6)
    8000246e:	b7c1                	j	8000242e <scheduler+0x54>
    if (nproc <= 2) { // only init and sh exist
    80002470:	013aca63          	blt	s5,s3,80002484 <scheduler+0xaa>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002474:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80002478:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    8000247c:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80002480:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002484:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80002488:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    8000248c:	10079073          	csrw	sstatus,a5
    int nproc = 0;
    80002490:	89e6                	mv	s3,s9
    for (p = proc; p < &proc[NPROC]; p++) {
    80002492:	00030497          	auipc	s1,0x30
    80002496:	a3648493          	addi	s1,s1,-1482 # 80031ec8 <proc>
        p->state = RUNNING;
    8000249a:	4b8d                	li	s7,3
    8000249c:	b755                	j	80002440 <scheduler+0x66>

000000008000249e <sched>:
void sched(void) {
    8000249e:	7179                	addi	sp,sp,-48
    800024a0:	f406                	sd	ra,40(sp)
    800024a2:	f022                	sd	s0,32(sp)
    800024a4:	ec26                	sd	s1,24(sp)
    800024a6:	e84a                	sd	s2,16(sp)
    800024a8:	e44e                	sd	s3,8(sp)
    800024aa:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800024ac:	00000097          	auipc	ra,0x0
    800024b0:	9fa080e7          	jalr	-1542(ra) # 80001ea6 <myproc>
    800024b4:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    800024b6:	fffff097          	auipc	ra,0xfffff
    800024ba:	a4a080e7          	jalr	-1462(ra) # 80000f00 <holding>
    800024be:	c93d                	beqz	a0,80002534 <sched+0x96>
  asm volatile("mv %0, tp" : "=r"(x));
    800024c0:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    800024c2:	2781                	sext.w	a5,a5
    800024c4:	079e                	slli	a5,a5,0x7
    800024c6:	0002f717          	auipc	a4,0x2f
    800024ca:	5ea70713          	addi	a4,a4,1514 # 80031ab0 <pid_lock>
    800024ce:	97ba                	add	a5,a5,a4
    800024d0:	0907a703          	lw	a4,144(a5)
    800024d4:	4785                	li	a5,1
    800024d6:	06f71763          	bne	a4,a5,80002544 <sched+0xa6>
  if (p->state == RUNNING)
    800024da:	4c98                	lw	a4,24(s1)
    800024dc:	478d                	li	a5,3
    800024de:	06f70b63          	beq	a4,a5,80002554 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800024e2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800024e6:	8b89                	andi	a5,a5,2
  if (intr_get())
    800024e8:	efb5                	bnez	a5,80002564 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r"(x));
    800024ea:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800024ec:	0002f917          	auipc	s2,0x2f
    800024f0:	5c490913          	addi	s2,s2,1476 # 80031ab0 <pid_lock>
    800024f4:	2781                	sext.w	a5,a5
    800024f6:	079e                	slli	a5,a5,0x7
    800024f8:	97ca                	add	a5,a5,s2
    800024fa:	0947a983          	lw	s3,148(a5)
    800024fe:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002500:	2781                	sext.w	a5,a5
    80002502:	079e                	slli	a5,a5,0x7
    80002504:	0002f597          	auipc	a1,0x2f
    80002508:	5cc58593          	addi	a1,a1,1484 # 80031ad0 <cpus+0x8>
    8000250c:	95be                	add	a1,a1,a5
    8000250e:	06048513          	addi	a0,s1,96
    80002512:	00000097          	auipc	ra,0x0
    80002516:	55c080e7          	jalr	1372(ra) # 80002a6e <swtch>
    8000251a:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000251c:	2781                	sext.w	a5,a5
    8000251e:	079e                	slli	a5,a5,0x7
    80002520:	97ca                	add	a5,a5,s2
    80002522:	0937aa23          	sw	s3,148(a5)
}
    80002526:	70a2                	ld	ra,40(sp)
    80002528:	7402                	ld	s0,32(sp)
    8000252a:	64e2                	ld	s1,24(sp)
    8000252c:	6942                	ld	s2,16(sp)
    8000252e:	69a2                	ld	s3,8(sp)
    80002530:	6145                	addi	sp,sp,48
    80002532:	8082                	ret
    panic("sched p->lock");
    80002534:	00006517          	auipc	a0,0x6
    80002538:	d5c50513          	addi	a0,a0,-676 # 80008290 <digits+0x228>
    8000253c:	ffffe097          	auipc	ra,0xffffe
    80002540:	0a8080e7          	jalr	168(ra) # 800005e4 <panic>
    panic("sched locks");
    80002544:	00006517          	auipc	a0,0x6
    80002548:	d5c50513          	addi	a0,a0,-676 # 800082a0 <digits+0x238>
    8000254c:	ffffe097          	auipc	ra,0xffffe
    80002550:	098080e7          	jalr	152(ra) # 800005e4 <panic>
    panic("sched running");
    80002554:	00006517          	auipc	a0,0x6
    80002558:	d5c50513          	addi	a0,a0,-676 # 800082b0 <digits+0x248>
    8000255c:	ffffe097          	auipc	ra,0xffffe
    80002560:	088080e7          	jalr	136(ra) # 800005e4 <panic>
    panic("sched interruptible");
    80002564:	00006517          	auipc	a0,0x6
    80002568:	d5c50513          	addi	a0,a0,-676 # 800082c0 <digits+0x258>
    8000256c:	ffffe097          	auipc	ra,0xffffe
    80002570:	078080e7          	jalr	120(ra) # 800005e4 <panic>

0000000080002574 <exit>:
void exit(int status) {
    80002574:	7179                	addi	sp,sp,-48
    80002576:	f406                	sd	ra,40(sp)
    80002578:	f022                	sd	s0,32(sp)
    8000257a:	ec26                	sd	s1,24(sp)
    8000257c:	e84a                	sd	s2,16(sp)
    8000257e:	e44e                	sd	s3,8(sp)
    80002580:	e052                	sd	s4,0(sp)
    80002582:	1800                	addi	s0,sp,48
    80002584:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002586:	00000097          	auipc	ra,0x0
    8000258a:	920080e7          	jalr	-1760(ra) # 80001ea6 <myproc>
    8000258e:	89aa                	mv	s3,a0
  if (p == initproc)
    80002590:	00007797          	auipc	a5,0x7
    80002594:	a887b783          	ld	a5,-1400(a5) # 80009018 <initproc>
    80002598:	0d050493          	addi	s1,a0,208
    8000259c:	15050913          	addi	s2,a0,336
    800025a0:	02a79363          	bne	a5,a0,800025c6 <exit+0x52>
    panic("init exiting");
    800025a4:	00006517          	auipc	a0,0x6
    800025a8:	d3450513          	addi	a0,a0,-716 # 800082d8 <digits+0x270>
    800025ac:	ffffe097          	auipc	ra,0xffffe
    800025b0:	038080e7          	jalr	56(ra) # 800005e4 <panic>
      fileclose(f);
    800025b4:	00002097          	auipc	ra,0x2
    800025b8:	4aa080e7          	jalr	1194(ra) # 80004a5e <fileclose>
      p->ofile[fd] = 0;
    800025bc:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++) {
    800025c0:	04a1                	addi	s1,s1,8
    800025c2:	01248563          	beq	s1,s2,800025cc <exit+0x58>
    if (p->ofile[fd]) {
    800025c6:	6088                	ld	a0,0(s1)
    800025c8:	f575                	bnez	a0,800025b4 <exit+0x40>
    800025ca:	bfdd                	j	800025c0 <exit+0x4c>
  begin_op();
    800025cc:	00002097          	auipc	ra,0x2
    800025d0:	fc0080e7          	jalr	-64(ra) # 8000458c <begin_op>
  iput(p->cwd);
    800025d4:	1509b503          	ld	a0,336(s3)
    800025d8:	00001097          	auipc	ra,0x1
    800025dc:	7ae080e7          	jalr	1966(ra) # 80003d86 <iput>
  end_op();
    800025e0:	00002097          	auipc	ra,0x2
    800025e4:	02c080e7          	jalr	44(ra) # 8000460c <end_op>
  p->cwd = 0;
    800025e8:	1409b823          	sd	zero,336(s3)
  acquire(&initproc->lock);
    800025ec:	00007497          	auipc	s1,0x7
    800025f0:	a2c48493          	addi	s1,s1,-1492 # 80009018 <initproc>
    800025f4:	6088                	ld	a0,0(s1)
    800025f6:	fffff097          	auipc	ra,0xfffff
    800025fa:	984080e7          	jalr	-1660(ra) # 80000f7a <acquire>
  wakeup1(initproc);
    800025fe:	6088                	ld	a0,0(s1)
    80002600:	fffff097          	auipc	ra,0xfffff
    80002604:	766080e7          	jalr	1894(ra) # 80001d66 <wakeup1>
  release(&initproc->lock);
    80002608:	6088                	ld	a0,0(s1)
    8000260a:	fffff097          	auipc	ra,0xfffff
    8000260e:	a24080e7          	jalr	-1500(ra) # 8000102e <release>
  acquire(&p->lock);
    80002612:	854e                	mv	a0,s3
    80002614:	fffff097          	auipc	ra,0xfffff
    80002618:	966080e7          	jalr	-1690(ra) # 80000f7a <acquire>
  struct proc *original_parent = p->parent;
    8000261c:	0209b483          	ld	s1,32(s3)
  release(&p->lock);
    80002620:	854e                	mv	a0,s3
    80002622:	fffff097          	auipc	ra,0xfffff
    80002626:	a0c080e7          	jalr	-1524(ra) # 8000102e <release>
  acquire(&original_parent->lock);
    8000262a:	8526                	mv	a0,s1
    8000262c:	fffff097          	auipc	ra,0xfffff
    80002630:	94e080e7          	jalr	-1714(ra) # 80000f7a <acquire>
  acquire(&p->lock);
    80002634:	854e                	mv	a0,s3
    80002636:	fffff097          	auipc	ra,0xfffff
    8000263a:	944080e7          	jalr	-1724(ra) # 80000f7a <acquire>
  reparent(p);
    8000263e:	854e                	mv	a0,s3
    80002640:	00000097          	auipc	ra,0x0
    80002644:	d34080e7          	jalr	-716(ra) # 80002374 <reparent>
  wakeup1(original_parent);
    80002648:	8526                	mv	a0,s1
    8000264a:	fffff097          	auipc	ra,0xfffff
    8000264e:	71c080e7          	jalr	1820(ra) # 80001d66 <wakeup1>
  p->xstate = status;
    80002652:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    80002656:	4791                	li	a5,4
    80002658:	00f9ac23          	sw	a5,24(s3)
  release(&original_parent->lock);
    8000265c:	8526                	mv	a0,s1
    8000265e:	fffff097          	auipc	ra,0xfffff
    80002662:	9d0080e7          	jalr	-1584(ra) # 8000102e <release>
  sched();
    80002666:	00000097          	auipc	ra,0x0
    8000266a:	e38080e7          	jalr	-456(ra) # 8000249e <sched>
  panic("zombie exit");
    8000266e:	00006517          	auipc	a0,0x6
    80002672:	c7a50513          	addi	a0,a0,-902 # 800082e8 <digits+0x280>
    80002676:	ffffe097          	auipc	ra,0xffffe
    8000267a:	f6e080e7          	jalr	-146(ra) # 800005e4 <panic>

000000008000267e <yield>:
void yield(void) {
    8000267e:	1101                	addi	sp,sp,-32
    80002680:	ec06                	sd	ra,24(sp)
    80002682:	e822                	sd	s0,16(sp)
    80002684:	e426                	sd	s1,8(sp)
    80002686:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002688:	00000097          	auipc	ra,0x0
    8000268c:	81e080e7          	jalr	-2018(ra) # 80001ea6 <myproc>
    80002690:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002692:	fffff097          	auipc	ra,0xfffff
    80002696:	8e8080e7          	jalr	-1816(ra) # 80000f7a <acquire>
  p->state = RUNNABLE;
    8000269a:	4789                	li	a5,2
    8000269c:	cc9c                	sw	a5,24(s1)
  sched();
    8000269e:	00000097          	auipc	ra,0x0
    800026a2:	e00080e7          	jalr	-512(ra) # 8000249e <sched>
  release(&p->lock);
    800026a6:	8526                	mv	a0,s1
    800026a8:	fffff097          	auipc	ra,0xfffff
    800026ac:	986080e7          	jalr	-1658(ra) # 8000102e <release>
}
    800026b0:	60e2                	ld	ra,24(sp)
    800026b2:	6442                	ld	s0,16(sp)
    800026b4:	64a2                	ld	s1,8(sp)
    800026b6:	6105                	addi	sp,sp,32
    800026b8:	8082                	ret

00000000800026ba <sleep>:
void sleep(void *chan, struct spinlock *lk) {
    800026ba:	7179                	addi	sp,sp,-48
    800026bc:	f406                	sd	ra,40(sp)
    800026be:	f022                	sd	s0,32(sp)
    800026c0:	ec26                	sd	s1,24(sp)
    800026c2:	e84a                	sd	s2,16(sp)
    800026c4:	e44e                	sd	s3,8(sp)
    800026c6:	1800                	addi	s0,sp,48
    800026c8:	89aa                	mv	s3,a0
    800026ca:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800026cc:	fffff097          	auipc	ra,0xfffff
    800026d0:	7da080e7          	jalr	2010(ra) # 80001ea6 <myproc>
    800026d4:	84aa                	mv	s1,a0
  if (lk != &p->lock) { // DOC: sleeplock0
    800026d6:	05250663          	beq	a0,s2,80002722 <sleep+0x68>
    acquire(&p->lock);  // DOC: sleeplock1
    800026da:	fffff097          	auipc	ra,0xfffff
    800026de:	8a0080e7          	jalr	-1888(ra) # 80000f7a <acquire>
    release(lk);
    800026e2:	854a                	mv	a0,s2
    800026e4:	fffff097          	auipc	ra,0xfffff
    800026e8:	94a080e7          	jalr	-1718(ra) # 8000102e <release>
  p->chan = chan;
    800026ec:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    800026f0:	4785                	li	a5,1
    800026f2:	cc9c                	sw	a5,24(s1)
  sched();
    800026f4:	00000097          	auipc	ra,0x0
    800026f8:	daa080e7          	jalr	-598(ra) # 8000249e <sched>
  p->chan = 0;
    800026fc:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    80002700:	8526                	mv	a0,s1
    80002702:	fffff097          	auipc	ra,0xfffff
    80002706:	92c080e7          	jalr	-1748(ra) # 8000102e <release>
    acquire(lk);
    8000270a:	854a                	mv	a0,s2
    8000270c:	fffff097          	auipc	ra,0xfffff
    80002710:	86e080e7          	jalr	-1938(ra) # 80000f7a <acquire>
}
    80002714:	70a2                	ld	ra,40(sp)
    80002716:	7402                	ld	s0,32(sp)
    80002718:	64e2                	ld	s1,24(sp)
    8000271a:	6942                	ld	s2,16(sp)
    8000271c:	69a2                	ld	s3,8(sp)
    8000271e:	6145                	addi	sp,sp,48
    80002720:	8082                	ret
  p->chan = chan;
    80002722:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    80002726:	4785                	li	a5,1
    80002728:	cd1c                	sw	a5,24(a0)
  sched();
    8000272a:	00000097          	auipc	ra,0x0
    8000272e:	d74080e7          	jalr	-652(ra) # 8000249e <sched>
  p->chan = 0;
    80002732:	0204b423          	sd	zero,40(s1)
  if (lk != &p->lock) {
    80002736:	bff9                	j	80002714 <sleep+0x5a>

0000000080002738 <wait>:
int wait(uint64 addr) {
    80002738:	715d                	addi	sp,sp,-80
    8000273a:	e486                	sd	ra,72(sp)
    8000273c:	e0a2                	sd	s0,64(sp)
    8000273e:	fc26                	sd	s1,56(sp)
    80002740:	f84a                	sd	s2,48(sp)
    80002742:	f44e                	sd	s3,40(sp)
    80002744:	f052                	sd	s4,32(sp)
    80002746:	ec56                	sd	s5,24(sp)
    80002748:	e85a                	sd	s6,16(sp)
    8000274a:	e45e                	sd	s7,8(sp)
    8000274c:	0880                	addi	s0,sp,80
    8000274e:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002750:	fffff097          	auipc	ra,0xfffff
    80002754:	756080e7          	jalr	1878(ra) # 80001ea6 <myproc>
    80002758:	892a                	mv	s2,a0
  acquire(&p->lock);
    8000275a:	fffff097          	auipc	ra,0xfffff
    8000275e:	820080e7          	jalr	-2016(ra) # 80000f7a <acquire>
    havekids = 0;
    80002762:	4b81                	li	s7,0
        if (np->state == ZOMBIE) {
    80002764:	4a11                	li	s4,4
        havekids = 1;
    80002766:	4a85                	li	s5,1
    for (np = proc; np < &proc[NPROC]; np++) {
    80002768:	00035997          	auipc	s3,0x35
    8000276c:	16098993          	addi	s3,s3,352 # 800378c8 <tickslock>
    havekids = 0;
    80002770:	875e                	mv	a4,s7
    for (np = proc; np < &proc[NPROC]; np++) {
    80002772:	0002f497          	auipc	s1,0x2f
    80002776:	75648493          	addi	s1,s1,1878 # 80031ec8 <proc>
    8000277a:	a08d                	j	800027dc <wait+0xa4>
          pid = np->pid;
    8000277c:	0384a983          	lw	s3,56(s1)
          freeproc(np);
    80002780:	8526                	mv	a0,s1
    80002782:	00000097          	auipc	ra,0x0
    80002786:	8d6080e7          	jalr	-1834(ra) # 80002058 <freeproc>
          if (addr != 0 &&
    8000278a:	000b0e63          	beqz	s6,800027a6 <wait+0x6e>
              (res = copyout(p->pagetable, addr, (char *)&np->xstate,
    8000278e:	4691                	li	a3,4
    80002790:	03448613          	addi	a2,s1,52
    80002794:	85da                	mv	a1,s6
    80002796:	05093503          	ld	a0,80(s2)
    8000279a:	fffff097          	auipc	ra,0xfffff
    8000279e:	4d8080e7          	jalr	1240(ra) # 80001c72 <copyout>
          if (addr != 0 &&
    800027a2:	00054d63          	bltz	a0,800027bc <wait+0x84>
          release(&np->lock);
    800027a6:	8526                	mv	a0,s1
    800027a8:	fffff097          	auipc	ra,0xfffff
    800027ac:	886080e7          	jalr	-1914(ra) # 8000102e <release>
          release(&p->lock);
    800027b0:	854a                	mv	a0,s2
    800027b2:	fffff097          	auipc	ra,0xfffff
    800027b6:	87c080e7          	jalr	-1924(ra) # 8000102e <release>
          return pid;
    800027ba:	a8a9                	j	80002814 <wait+0xdc>
            release(&np->lock);
    800027bc:	8526                	mv	a0,s1
    800027be:	fffff097          	auipc	ra,0xfffff
    800027c2:	870080e7          	jalr	-1936(ra) # 8000102e <release>
            release(&p->lock);
    800027c6:	854a                	mv	a0,s2
    800027c8:	fffff097          	auipc	ra,0xfffff
    800027cc:	866080e7          	jalr	-1946(ra) # 8000102e <release>
            return -1;
    800027d0:	59fd                	li	s3,-1
    800027d2:	a089                	j	80002814 <wait+0xdc>
    for (np = proc; np < &proc[NPROC]; np++) {
    800027d4:	16848493          	addi	s1,s1,360
    800027d8:	03348463          	beq	s1,s3,80002800 <wait+0xc8>
      if (np->parent == p) {
    800027dc:	709c                	ld	a5,32(s1)
    800027de:	ff279be3          	bne	a5,s2,800027d4 <wait+0x9c>
        acquire(&np->lock);
    800027e2:	8526                	mv	a0,s1
    800027e4:	ffffe097          	auipc	ra,0xffffe
    800027e8:	796080e7          	jalr	1942(ra) # 80000f7a <acquire>
        if (np->state == ZOMBIE) {
    800027ec:	4c9c                	lw	a5,24(s1)
    800027ee:	f94787e3          	beq	a5,s4,8000277c <wait+0x44>
        release(&np->lock);
    800027f2:	8526                	mv	a0,s1
    800027f4:	fffff097          	auipc	ra,0xfffff
    800027f8:	83a080e7          	jalr	-1990(ra) # 8000102e <release>
        havekids = 1;
    800027fc:	8756                	mv	a4,s5
    800027fe:	bfd9                	j	800027d4 <wait+0x9c>
    if (!havekids || p->killed) {
    80002800:	c701                	beqz	a4,80002808 <wait+0xd0>
    80002802:	03092783          	lw	a5,48(s2)
    80002806:	c39d                	beqz	a5,8000282c <wait+0xf4>
      release(&p->lock);
    80002808:	854a                	mv	a0,s2
    8000280a:	fffff097          	auipc	ra,0xfffff
    8000280e:	824080e7          	jalr	-2012(ra) # 8000102e <release>
      return -1;
    80002812:	59fd                	li	s3,-1
}
    80002814:	854e                	mv	a0,s3
    80002816:	60a6                	ld	ra,72(sp)
    80002818:	6406                	ld	s0,64(sp)
    8000281a:	74e2                	ld	s1,56(sp)
    8000281c:	7942                	ld	s2,48(sp)
    8000281e:	79a2                	ld	s3,40(sp)
    80002820:	7a02                	ld	s4,32(sp)
    80002822:	6ae2                	ld	s5,24(sp)
    80002824:	6b42                	ld	s6,16(sp)
    80002826:	6ba2                	ld	s7,8(sp)
    80002828:	6161                	addi	sp,sp,80
    8000282a:	8082                	ret
    sleep(p, &p->lock); // DOC: wait-sleep
    8000282c:	85ca                	mv	a1,s2
    8000282e:	854a                	mv	a0,s2
    80002830:	00000097          	auipc	ra,0x0
    80002834:	e8a080e7          	jalr	-374(ra) # 800026ba <sleep>
    havekids = 0;
    80002838:	bf25                	j	80002770 <wait+0x38>

000000008000283a <wakeup>:
void wakeup(void *chan) {
    8000283a:	7139                	addi	sp,sp,-64
    8000283c:	fc06                	sd	ra,56(sp)
    8000283e:	f822                	sd	s0,48(sp)
    80002840:	f426                	sd	s1,40(sp)
    80002842:	f04a                	sd	s2,32(sp)
    80002844:	ec4e                	sd	s3,24(sp)
    80002846:	e852                	sd	s4,16(sp)
    80002848:	e456                	sd	s5,8(sp)
    8000284a:	0080                	addi	s0,sp,64
    8000284c:	8a2a                	mv	s4,a0
  for (p = proc; p < &proc[NPROC]; p++) {
    8000284e:	0002f497          	auipc	s1,0x2f
    80002852:	67a48493          	addi	s1,s1,1658 # 80031ec8 <proc>
    if (p->state == SLEEPING && p->chan == chan) {
    80002856:	4985                	li	s3,1
      p->state = RUNNABLE;
    80002858:	4a89                	li	s5,2
  for (p = proc; p < &proc[NPROC]; p++) {
    8000285a:	00035917          	auipc	s2,0x35
    8000285e:	06e90913          	addi	s2,s2,110 # 800378c8 <tickslock>
    80002862:	a811                	j	80002876 <wakeup+0x3c>
    release(&p->lock);
    80002864:	8526                	mv	a0,s1
    80002866:	ffffe097          	auipc	ra,0xffffe
    8000286a:	7c8080e7          	jalr	1992(ra) # 8000102e <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    8000286e:	16848493          	addi	s1,s1,360
    80002872:	03248063          	beq	s1,s2,80002892 <wakeup+0x58>
    acquire(&p->lock);
    80002876:	8526                	mv	a0,s1
    80002878:	ffffe097          	auipc	ra,0xffffe
    8000287c:	702080e7          	jalr	1794(ra) # 80000f7a <acquire>
    if (p->state == SLEEPING && p->chan == chan) {
    80002880:	4c9c                	lw	a5,24(s1)
    80002882:	ff3791e3          	bne	a5,s3,80002864 <wakeup+0x2a>
    80002886:	749c                	ld	a5,40(s1)
    80002888:	fd479ee3          	bne	a5,s4,80002864 <wakeup+0x2a>
      p->state = RUNNABLE;
    8000288c:	0154ac23          	sw	s5,24(s1)
    80002890:	bfd1                	j	80002864 <wakeup+0x2a>
}
    80002892:	70e2                	ld	ra,56(sp)
    80002894:	7442                	ld	s0,48(sp)
    80002896:	74a2                	ld	s1,40(sp)
    80002898:	7902                	ld	s2,32(sp)
    8000289a:	69e2                	ld	s3,24(sp)
    8000289c:	6a42                	ld	s4,16(sp)
    8000289e:	6aa2                	ld	s5,8(sp)
    800028a0:	6121                	addi	sp,sp,64
    800028a2:	8082                	ret

00000000800028a4 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid) {
    800028a4:	7179                	addi	sp,sp,-48
    800028a6:	f406                	sd	ra,40(sp)
    800028a8:	f022                	sd	s0,32(sp)
    800028aa:	ec26                	sd	s1,24(sp)
    800028ac:	e84a                	sd	s2,16(sp)
    800028ae:	e44e                	sd	s3,8(sp)
    800028b0:	1800                	addi	s0,sp,48
    800028b2:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    800028b4:	0002f497          	auipc	s1,0x2f
    800028b8:	61448493          	addi	s1,s1,1556 # 80031ec8 <proc>
    800028bc:	00035997          	auipc	s3,0x35
    800028c0:	00c98993          	addi	s3,s3,12 # 800378c8 <tickslock>
    acquire(&p->lock);
    800028c4:	8526                	mv	a0,s1
    800028c6:	ffffe097          	auipc	ra,0xffffe
    800028ca:	6b4080e7          	jalr	1716(ra) # 80000f7a <acquire>
    if (p->pid == pid) {
    800028ce:	5c9c                	lw	a5,56(s1)
    800028d0:	01278d63          	beq	a5,s2,800028ea <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800028d4:	8526                	mv	a0,s1
    800028d6:	ffffe097          	auipc	ra,0xffffe
    800028da:	758080e7          	jalr	1880(ra) # 8000102e <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    800028de:	16848493          	addi	s1,s1,360
    800028e2:	ff3491e3          	bne	s1,s3,800028c4 <kill+0x20>
  }
  return -1;
    800028e6:	557d                	li	a0,-1
    800028e8:	a821                	j	80002900 <kill+0x5c>
      p->killed = 1;
    800028ea:	4785                	li	a5,1
    800028ec:	d89c                	sw	a5,48(s1)
      if (p->state == SLEEPING) {
    800028ee:	4c98                	lw	a4,24(s1)
    800028f0:	00f70f63          	beq	a4,a5,8000290e <kill+0x6a>
      release(&p->lock);
    800028f4:	8526                	mv	a0,s1
    800028f6:	ffffe097          	auipc	ra,0xffffe
    800028fa:	738080e7          	jalr	1848(ra) # 8000102e <release>
      return 0;
    800028fe:	4501                	li	a0,0
}
    80002900:	70a2                	ld	ra,40(sp)
    80002902:	7402                	ld	s0,32(sp)
    80002904:	64e2                	ld	s1,24(sp)
    80002906:	6942                	ld	s2,16(sp)
    80002908:	69a2                	ld	s3,8(sp)
    8000290a:	6145                	addi	sp,sp,48
    8000290c:	8082                	ret
        p->state = RUNNABLE;
    8000290e:	4789                	li	a5,2
    80002910:	cc9c                	sw	a5,24(s1)
    80002912:	b7cd                	j	800028f4 <kill+0x50>

0000000080002914 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len) {
    80002914:	7179                	addi	sp,sp,-48
    80002916:	f406                	sd	ra,40(sp)
    80002918:	f022                	sd	s0,32(sp)
    8000291a:	ec26                	sd	s1,24(sp)
    8000291c:	e84a                	sd	s2,16(sp)
    8000291e:	e44e                	sd	s3,8(sp)
    80002920:	e052                	sd	s4,0(sp)
    80002922:	1800                	addi	s0,sp,48
    80002924:	84aa                	mv	s1,a0
    80002926:	892e                	mv	s2,a1
    80002928:	89b2                	mv	s3,a2
    8000292a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000292c:	fffff097          	auipc	ra,0xfffff
    80002930:	57a080e7          	jalr	1402(ra) # 80001ea6 <myproc>
  if (user_dst) {
    80002934:	c08d                	beqz	s1,80002956 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80002936:	86d2                	mv	a3,s4
    80002938:	864e                	mv	a2,s3
    8000293a:	85ca                	mv	a1,s2
    8000293c:	6928                	ld	a0,80(a0)
    8000293e:	fffff097          	auipc	ra,0xfffff
    80002942:	334080e7          	jalr	820(ra) # 80001c72 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002946:	70a2                	ld	ra,40(sp)
    80002948:	7402                	ld	s0,32(sp)
    8000294a:	64e2                	ld	s1,24(sp)
    8000294c:	6942                	ld	s2,16(sp)
    8000294e:	69a2                	ld	s3,8(sp)
    80002950:	6a02                	ld	s4,0(sp)
    80002952:	6145                	addi	sp,sp,48
    80002954:	8082                	ret
    memmove((char *)dst, src, len);
    80002956:	000a061b          	sext.w	a2,s4
    8000295a:	85ce                	mv	a1,s3
    8000295c:	854a                	mv	a0,s2
    8000295e:	ffffe097          	auipc	ra,0xffffe
    80002962:	774080e7          	jalr	1908(ra) # 800010d2 <memmove>
    return 0;
    80002966:	8526                	mv	a0,s1
    80002968:	bff9                	j	80002946 <either_copyout+0x32>

000000008000296a <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len) {
    8000296a:	7179                	addi	sp,sp,-48
    8000296c:	f406                	sd	ra,40(sp)
    8000296e:	f022                	sd	s0,32(sp)
    80002970:	ec26                	sd	s1,24(sp)
    80002972:	e84a                	sd	s2,16(sp)
    80002974:	e44e                	sd	s3,8(sp)
    80002976:	e052                	sd	s4,0(sp)
    80002978:	1800                	addi	s0,sp,48
    8000297a:	892a                	mv	s2,a0
    8000297c:	84ae                	mv	s1,a1
    8000297e:	89b2                	mv	s3,a2
    80002980:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002982:	fffff097          	auipc	ra,0xfffff
    80002986:	524080e7          	jalr	1316(ra) # 80001ea6 <myproc>
  if (user_src) {
    8000298a:	c08d                	beqz	s1,800029ac <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000298c:	86d2                	mv	a3,s4
    8000298e:	864e                	mv	a2,s3
    80002990:	85ca                	mv	a1,s2
    80002992:	6928                	ld	a0,80(a0)
    80002994:	fffff097          	auipc	ra,0xfffff
    80002998:	06a080e7          	jalr	106(ra) # 800019fe <copyin>
  } else {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    8000299c:	70a2                	ld	ra,40(sp)
    8000299e:	7402                	ld	s0,32(sp)
    800029a0:	64e2                	ld	s1,24(sp)
    800029a2:	6942                	ld	s2,16(sp)
    800029a4:	69a2                	ld	s3,8(sp)
    800029a6:	6a02                	ld	s4,0(sp)
    800029a8:	6145                	addi	sp,sp,48
    800029aa:	8082                	ret
    memmove(dst, (char *)src, len);
    800029ac:	000a061b          	sext.w	a2,s4
    800029b0:	85ce                	mv	a1,s3
    800029b2:	854a                	mv	a0,s2
    800029b4:	ffffe097          	auipc	ra,0xffffe
    800029b8:	71e080e7          	jalr	1822(ra) # 800010d2 <memmove>
    return 0;
    800029bc:	8526                	mv	a0,s1
    800029be:	bff9                	j	8000299c <either_copyin+0x32>

00000000800029c0 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void) {
    800029c0:	715d                	addi	sp,sp,-80
    800029c2:	e486                	sd	ra,72(sp)
    800029c4:	e0a2                	sd	s0,64(sp)
    800029c6:	fc26                	sd	s1,56(sp)
    800029c8:	f84a                	sd	s2,48(sp)
    800029ca:	f44e                	sd	s3,40(sp)
    800029cc:	f052                	sd	s4,32(sp)
    800029ce:	ec56                	sd	s5,24(sp)
    800029d0:	e85a                	sd	s6,16(sp)
    800029d2:	e45e                	sd	s7,8(sp)
    800029d4:	0880                	addi	s0,sp,80
                           [RUNNING] "run   ",
                           [ZOMBIE] "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    800029d6:	00005517          	auipc	a0,0x5
    800029da:	7b250513          	addi	a0,a0,1970 # 80008188 <digits+0x120>
    800029de:	ffffe097          	auipc	ra,0xffffe
    800029e2:	c58080e7          	jalr	-936(ra) # 80000636 <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    800029e6:	0002f497          	auipc	s1,0x2f
    800029ea:	63a48493          	addi	s1,s1,1594 # 80032020 <proc+0x158>
    800029ee:	00035917          	auipc	s2,0x35
    800029f2:	03290913          	addi	s2,s2,50 # 80037a20 <bcache+0x140>
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800029f6:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    800029f8:	00006997          	auipc	s3,0x6
    800029fc:	90098993          	addi	s3,s3,-1792 # 800082f8 <digits+0x290>
    printf("%d %s %s", p->pid, state, p->name);
    80002a00:	00006a97          	auipc	s5,0x6
    80002a04:	900a8a93          	addi	s5,s5,-1792 # 80008300 <digits+0x298>
    printf("\n");
    80002a08:	00005a17          	auipc	s4,0x5
    80002a0c:	780a0a13          	addi	s4,s4,1920 # 80008188 <digits+0x120>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002a10:	00006b97          	auipc	s7,0x6
    80002a14:	928b8b93          	addi	s7,s7,-1752 # 80008338 <states.0>
    80002a18:	a00d                	j	80002a3a <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80002a1a:	ee06a583          	lw	a1,-288(a3)
    80002a1e:	8556                	mv	a0,s5
    80002a20:	ffffe097          	auipc	ra,0xffffe
    80002a24:	c16080e7          	jalr	-1002(ra) # 80000636 <printf>
    printf("\n");
    80002a28:	8552                	mv	a0,s4
    80002a2a:	ffffe097          	auipc	ra,0xffffe
    80002a2e:	c0c080e7          	jalr	-1012(ra) # 80000636 <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002a32:	16848493          	addi	s1,s1,360
    80002a36:	03248163          	beq	s1,s2,80002a58 <procdump+0x98>
    if (p->state == UNUSED)
    80002a3a:	86a6                	mv	a3,s1
    80002a3c:	ec04a783          	lw	a5,-320(s1)
    80002a40:	dbed                	beqz	a5,80002a32 <procdump+0x72>
      state = "???";
    80002a42:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002a44:	fcfb6be3          	bltu	s6,a5,80002a1a <procdump+0x5a>
    80002a48:	1782                	slli	a5,a5,0x20
    80002a4a:	9381                	srli	a5,a5,0x20
    80002a4c:	078e                	slli	a5,a5,0x3
    80002a4e:	97de                	add	a5,a5,s7
    80002a50:	6390                	ld	a2,0(a5)
    80002a52:	f661                	bnez	a2,80002a1a <procdump+0x5a>
      state = "???";
    80002a54:	864e                	mv	a2,s3
    80002a56:	b7d1                	j	80002a1a <procdump+0x5a>
  }
}
    80002a58:	60a6                	ld	ra,72(sp)
    80002a5a:	6406                	ld	s0,64(sp)
    80002a5c:	74e2                	ld	s1,56(sp)
    80002a5e:	7942                	ld	s2,48(sp)
    80002a60:	79a2                	ld	s3,40(sp)
    80002a62:	7a02                	ld	s4,32(sp)
    80002a64:	6ae2                	ld	s5,24(sp)
    80002a66:	6b42                	ld	s6,16(sp)
    80002a68:	6ba2                	ld	s7,8(sp)
    80002a6a:	6161                	addi	sp,sp,80
    80002a6c:	8082                	ret

0000000080002a6e <swtch>:
    80002a6e:	00153023          	sd	ra,0(a0)
    80002a72:	00253423          	sd	sp,8(a0)
    80002a76:	e900                	sd	s0,16(a0)
    80002a78:	ed04                	sd	s1,24(a0)
    80002a7a:	03253023          	sd	s2,32(a0)
    80002a7e:	03353423          	sd	s3,40(a0)
    80002a82:	03453823          	sd	s4,48(a0)
    80002a86:	03553c23          	sd	s5,56(a0)
    80002a8a:	05653023          	sd	s6,64(a0)
    80002a8e:	05753423          	sd	s7,72(a0)
    80002a92:	05853823          	sd	s8,80(a0)
    80002a96:	05953c23          	sd	s9,88(a0)
    80002a9a:	07a53023          	sd	s10,96(a0)
    80002a9e:	07b53423          	sd	s11,104(a0)
    80002aa2:	0005b083          	ld	ra,0(a1)
    80002aa6:	0085b103          	ld	sp,8(a1)
    80002aaa:	6980                	ld	s0,16(a1)
    80002aac:	6d84                	ld	s1,24(a1)
    80002aae:	0205b903          	ld	s2,32(a1)
    80002ab2:	0285b983          	ld	s3,40(a1)
    80002ab6:	0305ba03          	ld	s4,48(a1)
    80002aba:	0385ba83          	ld	s5,56(a1)
    80002abe:	0405bb03          	ld	s6,64(a1)
    80002ac2:	0485bb83          	ld	s7,72(a1)
    80002ac6:	0505bc03          	ld	s8,80(a1)
    80002aca:	0585bc83          	ld	s9,88(a1)
    80002ace:	0605bd03          	ld	s10,96(a1)
    80002ad2:	0685bd83          	ld	s11,104(a1)
    80002ad6:	8082                	ret

0000000080002ad8 <trapinit>:
// in kernelvec.S, calls kerneltrap().
void kernelvec();

extern int devintr();

void trapinit(void) { initlock(&tickslock, "time"); }
    80002ad8:	1141                	addi	sp,sp,-16
    80002ada:	e406                	sd	ra,8(sp)
    80002adc:	e022                	sd	s0,0(sp)
    80002ade:	0800                	addi	s0,sp,16
    80002ae0:	00006597          	auipc	a1,0x6
    80002ae4:	88058593          	addi	a1,a1,-1920 # 80008360 <states.0+0x28>
    80002ae8:	00035517          	auipc	a0,0x35
    80002aec:	de050513          	addi	a0,a0,-544 # 800378c8 <tickslock>
    80002af0:	ffffe097          	auipc	ra,0xffffe
    80002af4:	3fa080e7          	jalr	1018(ra) # 80000eea <initlock>
    80002af8:	60a2                	ld	ra,8(sp)
    80002afa:	6402                	ld	s0,0(sp)
    80002afc:	0141                	addi	sp,sp,16
    80002afe:	8082                	ret

0000000080002b00 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void) { w_stvec((uint64)kernelvec); }
    80002b00:	1141                	addi	sp,sp,-16
    80002b02:	e422                	sd	s0,8(sp)
    80002b04:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002b06:	00003797          	auipc	a5,0x3
    80002b0a:	5ba78793          	addi	a5,a5,1466 # 800060c0 <kernelvec>
    80002b0e:	10579073          	csrw	stvec,a5
    80002b12:	6422                	ld	s0,8(sp)
    80002b14:	0141                	addi	sp,sp,16
    80002b16:	8082                	ret

0000000080002b18 <usertrapret>:
}

//
// return to user space
//
void usertrapret(void) {
    80002b18:	1141                	addi	sp,sp,-16
    80002b1a:	e406                	sd	ra,8(sp)
    80002b1c:	e022                	sd	s0,0(sp)
    80002b1e:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002b20:	fffff097          	auipc	ra,0xfffff
    80002b24:	386080e7          	jalr	902(ra) # 80001ea6 <myproc>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002b28:	100027f3          	csrr	a5,sstatus
static inline void intr_off() { w_sstatus(r_sstatus() & ~SSTATUS_SIE); }
    80002b2c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002b2e:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002b32:	00004617          	auipc	a2,0x4
    80002b36:	4ce60613          	addi	a2,a2,1230 # 80007000 <_trampoline>
    80002b3a:	00004697          	auipc	a3,0x4
    80002b3e:	4c668693          	addi	a3,a3,1222 # 80007000 <_trampoline>
    80002b42:	8e91                	sub	a3,a3,a2
    80002b44:	040007b7          	lui	a5,0x4000
    80002b48:	17fd                	addi	a5,a5,-1
    80002b4a:	07b2                	slli	a5,a5,0xc
    80002b4c:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002b4e:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002b52:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    80002b54:	180026f3          	csrr	a3,satp
    80002b58:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002b5a:	6d38                	ld	a4,88(a0)
    80002b5c:	6134                	ld	a3,64(a0)
    80002b5e:	6585                	lui	a1,0x1
    80002b60:	96ae                	add	a3,a3,a1
    80002b62:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002b64:	6d38                	ld	a4,88(a0)
    80002b66:	00000697          	auipc	a3,0x0
    80002b6a:	13868693          	addi	a3,a3,312 # 80002c9e <usertrap>
    80002b6e:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002b70:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    80002b72:	8692                	mv	a3,tp
    80002b74:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002b76:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002b7a:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002b7e:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002b82:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002b86:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    80002b88:	6f18                	ld	a4,24(a4)
    80002b8a:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002b8e:	692c                	ld	a1,80(a0)
    80002b90:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80002b92:	00004717          	auipc	a4,0x4
    80002b96:	4fe70713          	addi	a4,a4,1278 # 80007090 <userret>
    80002b9a:	8f11                	sub	a4,a4,a2
    80002b9c:	97ba                	add	a5,a5,a4
  ((void (*)(uint64, uint64))fn)(TRAPFRAME, satp);
    80002b9e:	577d                	li	a4,-1
    80002ba0:	177e                	slli	a4,a4,0x3f
    80002ba2:	8dd9                	or	a1,a1,a4
    80002ba4:	02000537          	lui	a0,0x2000
    80002ba8:	157d                	addi	a0,a0,-1
    80002baa:	0536                	slli	a0,a0,0xd
    80002bac:	9782                	jalr	a5
}
    80002bae:	60a2                	ld	ra,8(sp)
    80002bb0:	6402                	ld	s0,0(sp)
    80002bb2:	0141                	addi	sp,sp,16
    80002bb4:	8082                	ret

0000000080002bb6 <clockintr>:
  // so restore trap registers for use by kernelvec.S's sepc instruction.
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr() {
    80002bb6:	1101                	addi	sp,sp,-32
    80002bb8:	ec06                	sd	ra,24(sp)
    80002bba:	e822                	sd	s0,16(sp)
    80002bbc:	e426                	sd	s1,8(sp)
    80002bbe:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002bc0:	00035497          	auipc	s1,0x35
    80002bc4:	d0848493          	addi	s1,s1,-760 # 800378c8 <tickslock>
    80002bc8:	8526                	mv	a0,s1
    80002bca:	ffffe097          	auipc	ra,0xffffe
    80002bce:	3b0080e7          	jalr	944(ra) # 80000f7a <acquire>
  ticks++;
    80002bd2:	00006517          	auipc	a0,0x6
    80002bd6:	44e50513          	addi	a0,a0,1102 # 80009020 <ticks>
    80002bda:	411c                	lw	a5,0(a0)
    80002bdc:	2785                	addiw	a5,a5,1
    80002bde:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002be0:	00000097          	auipc	ra,0x0
    80002be4:	c5a080e7          	jalr	-934(ra) # 8000283a <wakeup>
  release(&tickslock);
    80002be8:	8526                	mv	a0,s1
    80002bea:	ffffe097          	auipc	ra,0xffffe
    80002bee:	444080e7          	jalr	1092(ra) # 8000102e <release>
}
    80002bf2:	60e2                	ld	ra,24(sp)
    80002bf4:	6442                	ld	s0,16(sp)
    80002bf6:	64a2                	ld	s1,8(sp)
    80002bf8:	6105                	addi	sp,sp,32
    80002bfa:	8082                	ret

0000000080002bfc <devintr>:
// check if it's an external interrupt or software interrupt,
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr() {
    80002bfc:	1101                	addi	sp,sp,-32
    80002bfe:	ec06                	sd	ra,24(sp)
    80002c00:	e822                	sd	s0,16(sp)
    80002c02:	e426                	sd	s1,8(sp)
    80002c04:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r"(x));
    80002c06:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80002c0a:	00074d63          	bltz	a4,80002c24 <devintr+0x28>
    // now allowed to interrupt again.
    if (irq)
      plic_complete(irq);

    return 1;
  } else if (scause == 0x8000000000000001L) {
    80002c0e:	57fd                	li	a5,-1
    80002c10:	17fe                	slli	a5,a5,0x3f
    80002c12:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002c14:	4501                	li	a0,0
  } else if (scause == 0x8000000000000001L) {
    80002c16:	06f70363          	beq	a4,a5,80002c7c <devintr+0x80>
  }
}
    80002c1a:	60e2                	ld	ra,24(sp)
    80002c1c:	6442                	ld	s0,16(sp)
    80002c1e:	64a2                	ld	s1,8(sp)
    80002c20:	6105                	addi	sp,sp,32
    80002c22:	8082                	ret
  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80002c24:	0ff77793          	andi	a5,a4,255
    80002c28:	46a5                	li	a3,9
    80002c2a:	fed792e3          	bne	a5,a3,80002c0e <devintr+0x12>
    int irq = plic_claim();
    80002c2e:	00003097          	auipc	ra,0x3
    80002c32:	59a080e7          	jalr	1434(ra) # 800061c8 <plic_claim>
    80002c36:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ) {
    80002c38:	47a9                	li	a5,10
    80002c3a:	02f50763          	beq	a0,a5,80002c68 <devintr+0x6c>
    } else if (irq == VIRTIO0_IRQ) {
    80002c3e:	4785                	li	a5,1
    80002c40:	02f50963          	beq	a0,a5,80002c72 <devintr+0x76>
    return 1;
    80002c44:	4505                	li	a0,1
    } else if (irq) {
    80002c46:	d8f1                	beqz	s1,80002c1a <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002c48:	85a6                	mv	a1,s1
    80002c4a:	00005517          	auipc	a0,0x5
    80002c4e:	71e50513          	addi	a0,a0,1822 # 80008368 <states.0+0x30>
    80002c52:	ffffe097          	auipc	ra,0xffffe
    80002c56:	9e4080e7          	jalr	-1564(ra) # 80000636 <printf>
      plic_complete(irq);
    80002c5a:	8526                	mv	a0,s1
    80002c5c:	00003097          	auipc	ra,0x3
    80002c60:	590080e7          	jalr	1424(ra) # 800061ec <plic_complete>
    return 1;
    80002c64:	4505                	li	a0,1
    80002c66:	bf55                	j	80002c1a <devintr+0x1e>
      uartintr();
    80002c68:	ffffe097          	auipc	ra,0xffffe
    80002c6c:	dd2080e7          	jalr	-558(ra) # 80000a3a <uartintr>
    80002c70:	b7ed                	j	80002c5a <devintr+0x5e>
      virtio_disk_intr();
    80002c72:	00004097          	auipc	ra,0x4
    80002c76:	9f4080e7          	jalr	-1548(ra) # 80006666 <virtio_disk_intr>
    80002c7a:	b7c5                	j	80002c5a <devintr+0x5e>
    if (cpuid() == 0) {
    80002c7c:	fffff097          	auipc	ra,0xfffff
    80002c80:	1fe080e7          	jalr	510(ra) # 80001e7a <cpuid>
    80002c84:	c901                	beqz	a0,80002c94 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r"(x));
    80002c86:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002c8a:	9bf5                	andi	a5,a5,-3
static inline void w_sip(uint64 x) { asm volatile("csrw sip, %0" : : "r"(x)); }
    80002c8c:	14479073          	csrw	sip,a5
    return 2;
    80002c90:	4509                	li	a0,2
    80002c92:	b761                	j	80002c1a <devintr+0x1e>
      clockintr();
    80002c94:	00000097          	auipc	ra,0x0
    80002c98:	f22080e7          	jalr	-222(ra) # 80002bb6 <clockintr>
    80002c9c:	b7ed                	j	80002c86 <devintr+0x8a>

0000000080002c9e <usertrap>:
void usertrap(void) {
    80002c9e:	7179                	addi	sp,sp,-48
    80002ca0:	f406                	sd	ra,40(sp)
    80002ca2:	f022                	sd	s0,32(sp)
    80002ca4:	ec26                	sd	s1,24(sp)
    80002ca6:	e84a                	sd	s2,16(sp)
    80002ca8:	e44e                	sd	s3,8(sp)
    80002caa:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002cac:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80002cb0:	1007f793          	andi	a5,a5,256
    80002cb4:	e3bd                	bnez	a5,80002d1a <usertrap+0x7c>
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002cb6:	00003797          	auipc	a5,0x3
    80002cba:	40a78793          	addi	a5,a5,1034 # 800060c0 <kernelvec>
    80002cbe:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002cc2:	fffff097          	auipc	ra,0xfffff
    80002cc6:	1e4080e7          	jalr	484(ra) # 80001ea6 <myproc>
    80002cca:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002ccc:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002cce:	14102773          	csrr	a4,sepc
    80002cd2:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    80002cd4:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    80002cd8:	47a1                	li	a5,8
    80002cda:	04f71e63          	bne	a4,a5,80002d36 <usertrap+0x98>
    if (p->killed)
    80002cde:	591c                	lw	a5,48(a0)
    80002ce0:	e7a9                	bnez	a5,80002d2a <usertrap+0x8c>
    p->trapframe->epc += 4;
    80002ce2:	6cb8                	ld	a4,88(s1)
    80002ce4:	6f1c                	ld	a5,24(a4)
    80002ce6:	0791                	addi	a5,a5,4
    80002ce8:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002cea:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80002cee:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002cf2:	10079073          	csrw	sstatus,a5
    syscall();
    80002cf6:	00000097          	auipc	ra,0x0
    80002cfa:	396080e7          	jalr	918(ra) # 8000308c <syscall>
  if (p->killed)
    80002cfe:	589c                	lw	a5,48(s1)
    80002d00:	12079163          	bnez	a5,80002e22 <usertrap+0x184>
  usertrapret();
    80002d04:	00000097          	auipc	ra,0x0
    80002d08:	e14080e7          	jalr	-492(ra) # 80002b18 <usertrapret>
}
    80002d0c:	70a2                	ld	ra,40(sp)
    80002d0e:	7402                	ld	s0,32(sp)
    80002d10:	64e2                	ld	s1,24(sp)
    80002d12:	6942                	ld	s2,16(sp)
    80002d14:	69a2                	ld	s3,8(sp)
    80002d16:	6145                	addi	sp,sp,48
    80002d18:	8082                	ret
    panic("usertrap: not from user mode");
    80002d1a:	00005517          	auipc	a0,0x5
    80002d1e:	66e50513          	addi	a0,a0,1646 # 80008388 <states.0+0x50>
    80002d22:	ffffe097          	auipc	ra,0xffffe
    80002d26:	8c2080e7          	jalr	-1854(ra) # 800005e4 <panic>
      exit(-1);
    80002d2a:	557d                	li	a0,-1
    80002d2c:	00000097          	auipc	ra,0x0
    80002d30:	848080e7          	jalr	-1976(ra) # 80002574 <exit>
    80002d34:	b77d                	j	80002ce2 <usertrap+0x44>
  } else if ((which_dev = devintr()) != 0) {
    80002d36:	00000097          	auipc	ra,0x0
    80002d3a:	ec6080e7          	jalr	-314(ra) # 80002bfc <devintr>
    80002d3e:	892a                	mv	s2,a0
    80002d40:	ed71                	bnez	a0,80002e1c <usertrap+0x17e>
  asm volatile("csrr %0, scause" : "=r"(x));
    80002d42:	14202773          	csrr	a4,scause
  } else if (r_scause() == 13 || r_scause() == 15) {
    80002d46:	47b5                	li	a5,13
    80002d48:	00f70763          	beq	a4,a5,80002d56 <usertrap+0xb8>
    80002d4c:	14202773          	csrr	a4,scause
    80002d50:	47bd                	li	a5,15
    80002d52:	08f71b63          	bne	a4,a5,80002de8 <usertrap+0x14a>
  asm volatile("csrr %0, stval" : "=r"(x));
    80002d56:	143029f3          	csrr	s3,stval
    if (addr > MAXVA) {
    80002d5a:	4785                	li	a5,1
    80002d5c:	179a                	slli	a5,a5,0x26
    80002d5e:	0537e863          	bltu	a5,s3,80002dae <usertrap+0x110>
    pte_t *pte = walk(p->pagetable, addr, 0);
    80002d62:	4601                	li	a2,0
    80002d64:	85ce                	mv	a1,s3
    80002d66:	68a8                	ld	a0,80(s1)
    80002d68:	ffffe097          	auipc	ra,0xffffe
    80002d6c:	5f6080e7          	jalr	1526(ra) # 8000135e <walk>
    if ((!pte || !(*pte & PTE_V)) && addr < p->sz) {
    80002d70:	c95d                	beqz	a0,80002e26 <usertrap+0x188>
    80002d72:	611c                	ld	a5,0(a0)
    80002d74:	0017f713          	andi	a4,a5,1
    80002d78:	c769                	beqz	a4,80002e42 <usertrap+0x1a4>
    } else if (pte && (*pte & PTE_COW)) {
    80002d7a:	1007f793          	andi	a5,a5,256
    80002d7e:	e3b9                	bnez	a5,80002dc4 <usertrap+0x126>
      printf("permission denied");
    80002d80:	00005517          	auipc	a0,0x5
    80002d84:	64850513          	addi	a0,a0,1608 # 800083c8 <states.0+0x90>
    80002d88:	ffffe097          	auipc	ra,0xffffe
    80002d8c:	8ae080e7          	jalr	-1874(ra) # 80000636 <printf>
      p->killed = 1;
    80002d90:	4785                	li	a5,1
    80002d92:	d89c                	sw	a5,48(s1)
    exit(-1);
    80002d94:	557d                	li	a0,-1
    80002d96:	fffff097          	auipc	ra,0xfffff
    80002d9a:	7de080e7          	jalr	2014(ra) # 80002574 <exit>
  if (which_dev == 2)
    80002d9e:	4789                	li	a5,2
    80002da0:	f6f912e3          	bne	s2,a5,80002d04 <usertrap+0x66>
    yield();
    80002da4:	00000097          	auipc	ra,0x0
    80002da8:	8da080e7          	jalr	-1830(ra) # 8000267e <yield>
    80002dac:	bfa1                	j	80002d04 <usertrap+0x66>
      printf("memory overflow");
    80002dae:	00005517          	auipc	a0,0x5
    80002db2:	5fa50513          	addi	a0,a0,1530 # 800083a8 <states.0+0x70>
    80002db6:	ffffe097          	auipc	ra,0xffffe
    80002dba:	880080e7          	jalr	-1920(ra) # 80000636 <printf>
      p->killed = 1;
    80002dbe:	4785                	li	a5,1
    80002dc0:	d89c                	sw	a5,48(s1)
    80002dc2:	b745                	j	80002d62 <usertrap+0xc4>
      int res = do_cow(p->pagetable, addr);
    80002dc4:	85ce                	mv	a1,s3
    80002dc6:	68a8                	ld	a0,80(s1)
    80002dc8:	fffff097          	auipc	ra,0xfffff
    80002dcc:	d78080e7          	jalr	-648(ra) # 80001b40 <do_cow>
      if (res != 0) {
    80002dd0:	d51d                	beqz	a0,80002cfe <usertrap+0x60>
        printf("cow failed");
    80002dd2:	00005517          	auipc	a0,0x5
    80002dd6:	5e650513          	addi	a0,a0,1510 # 800083b8 <states.0+0x80>
    80002dda:	ffffe097          	auipc	ra,0xffffe
    80002dde:	85c080e7          	jalr	-1956(ra) # 80000636 <printf>
        p->killed = 1;
    80002de2:	4785                	li	a5,1
    80002de4:	d89c                	sw	a5,48(s1)
    80002de6:	b77d                	j	80002d94 <usertrap+0xf6>
  asm volatile("csrr %0, scause" : "=r"(x));
    80002de8:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002dec:	5c90                	lw	a2,56(s1)
    80002dee:	00005517          	auipc	a0,0x5
    80002df2:	5f250513          	addi	a0,a0,1522 # 800083e0 <states.0+0xa8>
    80002df6:	ffffe097          	auipc	ra,0xffffe
    80002dfa:	840080e7          	jalr	-1984(ra) # 80000636 <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002dfe:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80002e02:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002e06:	00005517          	auipc	a0,0x5
    80002e0a:	60a50513          	addi	a0,a0,1546 # 80008410 <states.0+0xd8>
    80002e0e:	ffffe097          	auipc	ra,0xffffe
    80002e12:	828080e7          	jalr	-2008(ra) # 80000636 <printf>
    p->killed = 1;
    80002e16:	4785                	li	a5,1
    80002e18:	d89c                	sw	a5,48(s1)
    80002e1a:	bfad                	j	80002d94 <usertrap+0xf6>
  if (p->killed)
    80002e1c:	589c                	lw	a5,48(s1)
    80002e1e:	d3c1                	beqz	a5,80002d9e <usertrap+0x100>
    80002e20:	bf95                	j	80002d94 <usertrap+0xf6>
    80002e22:	4901                	li	s2,0
    80002e24:	bf85                	j	80002d94 <usertrap+0xf6>
    if ((!pte || !(*pte & PTE_V)) && addr < p->sz) {
    80002e26:	64bc                	ld	a5,72(s1)
    80002e28:	f4f9fce3          	bgeu	s3,a5,80002d80 <usertrap+0xe2>
      int res = do_lazy_allocation(p->pagetable, addr);
    80002e2c:	85ce                	mv	a1,s3
    80002e2e:	68a8                	ld	a0,80(s1)
    80002e30:	fffff097          	auipc	ra,0xfffff
    80002e34:	de0080e7          	jalr	-544(ra) # 80001c10 <do_lazy_allocation>
      if (res != 0) {
    80002e38:	ec0503e3          	beqz	a0,80002cfe <usertrap+0x60>
        p->killed = 1;
    80002e3c:	4785                	li	a5,1
    80002e3e:	d89c                	sw	a5,48(s1)
    80002e40:	bf91                	j	80002d94 <usertrap+0xf6>
    if ((!pte || !(*pte & PTE_V)) && addr < p->sz) {
    80002e42:	64b8                	ld	a4,72(s1)
    80002e44:	f2e9fbe3          	bgeu	s3,a4,80002d7a <usertrap+0xdc>
    80002e48:	b7d5                	j	80002e2c <usertrap+0x18e>

0000000080002e4a <kerneltrap>:
void kerneltrap() {
    80002e4a:	7179                	addi	sp,sp,-48
    80002e4c:	f406                	sd	ra,40(sp)
    80002e4e:	f022                	sd	s0,32(sp)
    80002e50:	ec26                	sd	s1,24(sp)
    80002e52:	e84a                	sd	s2,16(sp)
    80002e54:	e44e                	sd	s3,8(sp)
    80002e56:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002e58:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002e5c:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    80002e60:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80002e64:	1004f793          	andi	a5,s1,256
    80002e68:	cb85                	beqz	a5,80002e98 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002e6a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002e6e:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80002e70:	ef85                	bnez	a5,80002ea8 <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0) {
    80002e72:	00000097          	auipc	ra,0x0
    80002e76:	d8a080e7          	jalr	-630(ra) # 80002bfc <devintr>
    80002e7a:	cd1d                	beqz	a0,80002eb8 <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002e7c:	4789                	li	a5,2
    80002e7e:	06f50a63          	beq	a0,a5,80002ef2 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r"(x));
    80002e82:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002e86:	10049073          	csrw	sstatus,s1
}
    80002e8a:	70a2                	ld	ra,40(sp)
    80002e8c:	7402                	ld	s0,32(sp)
    80002e8e:	64e2                	ld	s1,24(sp)
    80002e90:	6942                	ld	s2,16(sp)
    80002e92:	69a2                	ld	s3,8(sp)
    80002e94:	6145                	addi	sp,sp,48
    80002e96:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002e98:	00005517          	auipc	a0,0x5
    80002e9c:	59850513          	addi	a0,a0,1432 # 80008430 <states.0+0xf8>
    80002ea0:	ffffd097          	auipc	ra,0xffffd
    80002ea4:	744080e7          	jalr	1860(ra) # 800005e4 <panic>
    panic("kerneltrap: interrupts enabled");
    80002ea8:	00005517          	auipc	a0,0x5
    80002eac:	5b050513          	addi	a0,a0,1456 # 80008458 <states.0+0x120>
    80002eb0:	ffffd097          	auipc	ra,0xffffd
    80002eb4:	734080e7          	jalr	1844(ra) # 800005e4 <panic>
    printf("scause %p\n", scause);
    80002eb8:	85ce                	mv	a1,s3
    80002eba:	00005517          	auipc	a0,0x5
    80002ebe:	5be50513          	addi	a0,a0,1470 # 80008478 <states.0+0x140>
    80002ec2:	ffffd097          	auipc	ra,0xffffd
    80002ec6:	774080e7          	jalr	1908(ra) # 80000636 <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002eca:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80002ece:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002ed2:	00005517          	auipc	a0,0x5
    80002ed6:	5b650513          	addi	a0,a0,1462 # 80008488 <states.0+0x150>
    80002eda:	ffffd097          	auipc	ra,0xffffd
    80002ede:	75c080e7          	jalr	1884(ra) # 80000636 <printf>
    panic("kerneltrap");
    80002ee2:	00005517          	auipc	a0,0x5
    80002ee6:	5be50513          	addi	a0,a0,1470 # 800084a0 <states.0+0x168>
    80002eea:	ffffd097          	auipc	ra,0xffffd
    80002eee:	6fa080e7          	jalr	1786(ra) # 800005e4 <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002ef2:	fffff097          	auipc	ra,0xfffff
    80002ef6:	fb4080e7          	jalr	-76(ra) # 80001ea6 <myproc>
    80002efa:	d541                	beqz	a0,80002e82 <kerneltrap+0x38>
    80002efc:	fffff097          	auipc	ra,0xfffff
    80002f00:	faa080e7          	jalr	-86(ra) # 80001ea6 <myproc>
    80002f04:	4d18                	lw	a4,24(a0)
    80002f06:	478d                	li	a5,3
    80002f08:	f6f71de3          	bne	a4,a5,80002e82 <kerneltrap+0x38>
    yield();
    80002f0c:	fffff097          	auipc	ra,0xfffff
    80002f10:	772080e7          	jalr	1906(ra) # 8000267e <yield>
    80002f14:	b7bd                	j	80002e82 <kerneltrap+0x38>

0000000080002f16 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002f16:	1101                	addi	sp,sp,-32
    80002f18:	ec06                	sd	ra,24(sp)
    80002f1a:	e822                	sd	s0,16(sp)
    80002f1c:	e426                	sd	s1,8(sp)
    80002f1e:	1000                	addi	s0,sp,32
    80002f20:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002f22:	fffff097          	auipc	ra,0xfffff
    80002f26:	f84080e7          	jalr	-124(ra) # 80001ea6 <myproc>
  switch (n) {
    80002f2a:	4795                	li	a5,5
    80002f2c:	0497e163          	bltu	a5,s1,80002f6e <argraw+0x58>
    80002f30:	048a                	slli	s1,s1,0x2
    80002f32:	00005717          	auipc	a4,0x5
    80002f36:	5a670713          	addi	a4,a4,1446 # 800084d8 <states.0+0x1a0>
    80002f3a:	94ba                	add	s1,s1,a4
    80002f3c:	409c                	lw	a5,0(s1)
    80002f3e:	97ba                	add	a5,a5,a4
    80002f40:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002f42:	6d3c                	ld	a5,88(a0)
    80002f44:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002f46:	60e2                	ld	ra,24(sp)
    80002f48:	6442                	ld	s0,16(sp)
    80002f4a:	64a2                	ld	s1,8(sp)
    80002f4c:	6105                	addi	sp,sp,32
    80002f4e:	8082                	ret
    return p->trapframe->a1;
    80002f50:	6d3c                	ld	a5,88(a0)
    80002f52:	7fa8                	ld	a0,120(a5)
    80002f54:	bfcd                	j	80002f46 <argraw+0x30>
    return p->trapframe->a2;
    80002f56:	6d3c                	ld	a5,88(a0)
    80002f58:	63c8                	ld	a0,128(a5)
    80002f5a:	b7f5                	j	80002f46 <argraw+0x30>
    return p->trapframe->a3;
    80002f5c:	6d3c                	ld	a5,88(a0)
    80002f5e:	67c8                	ld	a0,136(a5)
    80002f60:	b7dd                	j	80002f46 <argraw+0x30>
    return p->trapframe->a4;
    80002f62:	6d3c                	ld	a5,88(a0)
    80002f64:	6bc8                	ld	a0,144(a5)
    80002f66:	b7c5                	j	80002f46 <argraw+0x30>
    return p->trapframe->a5;
    80002f68:	6d3c                	ld	a5,88(a0)
    80002f6a:	6fc8                	ld	a0,152(a5)
    80002f6c:	bfe9                	j	80002f46 <argraw+0x30>
  panic("argraw");
    80002f6e:	00005517          	auipc	a0,0x5
    80002f72:	54250513          	addi	a0,a0,1346 # 800084b0 <states.0+0x178>
    80002f76:	ffffd097          	auipc	ra,0xffffd
    80002f7a:	66e080e7          	jalr	1646(ra) # 800005e4 <panic>

0000000080002f7e <fetchaddr>:
{
    80002f7e:	1101                	addi	sp,sp,-32
    80002f80:	ec06                	sd	ra,24(sp)
    80002f82:	e822                	sd	s0,16(sp)
    80002f84:	e426                	sd	s1,8(sp)
    80002f86:	e04a                	sd	s2,0(sp)
    80002f88:	1000                	addi	s0,sp,32
    80002f8a:	84aa                	mv	s1,a0
    80002f8c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002f8e:	fffff097          	auipc	ra,0xfffff
    80002f92:	f18080e7          	jalr	-232(ra) # 80001ea6 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002f96:	653c                	ld	a5,72(a0)
    80002f98:	02f4f863          	bgeu	s1,a5,80002fc8 <fetchaddr+0x4a>
    80002f9c:	00848713          	addi	a4,s1,8
    80002fa0:	02e7e663          	bltu	a5,a4,80002fcc <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002fa4:	46a1                	li	a3,8
    80002fa6:	8626                	mv	a2,s1
    80002fa8:	85ca                	mv	a1,s2
    80002faa:	6928                	ld	a0,80(a0)
    80002fac:	fffff097          	auipc	ra,0xfffff
    80002fb0:	a52080e7          	jalr	-1454(ra) # 800019fe <copyin>
    80002fb4:	00a03533          	snez	a0,a0
    80002fb8:	40a00533          	neg	a0,a0
}
    80002fbc:	60e2                	ld	ra,24(sp)
    80002fbe:	6442                	ld	s0,16(sp)
    80002fc0:	64a2                	ld	s1,8(sp)
    80002fc2:	6902                	ld	s2,0(sp)
    80002fc4:	6105                	addi	sp,sp,32
    80002fc6:	8082                	ret
    return -1;
    80002fc8:	557d                	li	a0,-1
    80002fca:	bfcd                	j	80002fbc <fetchaddr+0x3e>
    80002fcc:	557d                	li	a0,-1
    80002fce:	b7fd                	j	80002fbc <fetchaddr+0x3e>

0000000080002fd0 <fetchstr>:
{
    80002fd0:	7179                	addi	sp,sp,-48
    80002fd2:	f406                	sd	ra,40(sp)
    80002fd4:	f022                	sd	s0,32(sp)
    80002fd6:	ec26                	sd	s1,24(sp)
    80002fd8:	e84a                	sd	s2,16(sp)
    80002fda:	e44e                	sd	s3,8(sp)
    80002fdc:	1800                	addi	s0,sp,48
    80002fde:	892a                	mv	s2,a0
    80002fe0:	84ae                	mv	s1,a1
    80002fe2:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002fe4:	fffff097          	auipc	ra,0xfffff
    80002fe8:	ec2080e7          	jalr	-318(ra) # 80001ea6 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002fec:	86ce                	mv	a3,s3
    80002fee:	864a                	mv	a2,s2
    80002ff0:	85a6                	mv	a1,s1
    80002ff2:	6928                	ld	a0,80(a0)
    80002ff4:	fffff097          	auipc	ra,0xfffff
    80002ff8:	a98080e7          	jalr	-1384(ra) # 80001a8c <copyinstr>
  if(err < 0)
    80002ffc:	00054763          	bltz	a0,8000300a <fetchstr+0x3a>
  return strlen(buf);
    80003000:	8526                	mv	a0,s1
    80003002:	ffffe097          	auipc	ra,0xffffe
    80003006:	1f8080e7          	jalr	504(ra) # 800011fa <strlen>
}
    8000300a:	70a2                	ld	ra,40(sp)
    8000300c:	7402                	ld	s0,32(sp)
    8000300e:	64e2                	ld	s1,24(sp)
    80003010:	6942                	ld	s2,16(sp)
    80003012:	69a2                	ld	s3,8(sp)
    80003014:	6145                	addi	sp,sp,48
    80003016:	8082                	ret

0000000080003018 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80003018:	1101                	addi	sp,sp,-32
    8000301a:	ec06                	sd	ra,24(sp)
    8000301c:	e822                	sd	s0,16(sp)
    8000301e:	e426                	sd	s1,8(sp)
    80003020:	1000                	addi	s0,sp,32
    80003022:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80003024:	00000097          	auipc	ra,0x0
    80003028:	ef2080e7          	jalr	-270(ra) # 80002f16 <argraw>
    8000302c:	c088                	sw	a0,0(s1)
  return 0;
}
    8000302e:	4501                	li	a0,0
    80003030:	60e2                	ld	ra,24(sp)
    80003032:	6442                	ld	s0,16(sp)
    80003034:	64a2                	ld	s1,8(sp)
    80003036:	6105                	addi	sp,sp,32
    80003038:	8082                	ret

000000008000303a <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    8000303a:	1101                	addi	sp,sp,-32
    8000303c:	ec06                	sd	ra,24(sp)
    8000303e:	e822                	sd	s0,16(sp)
    80003040:	e426                	sd	s1,8(sp)
    80003042:	1000                	addi	s0,sp,32
    80003044:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80003046:	00000097          	auipc	ra,0x0
    8000304a:	ed0080e7          	jalr	-304(ra) # 80002f16 <argraw>
    8000304e:	e088                	sd	a0,0(s1)
  return 0;
}
    80003050:	4501                	li	a0,0
    80003052:	60e2                	ld	ra,24(sp)
    80003054:	6442                	ld	s0,16(sp)
    80003056:	64a2                	ld	s1,8(sp)
    80003058:	6105                	addi	sp,sp,32
    8000305a:	8082                	ret

000000008000305c <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000305c:	1101                	addi	sp,sp,-32
    8000305e:	ec06                	sd	ra,24(sp)
    80003060:	e822                	sd	s0,16(sp)
    80003062:	e426                	sd	s1,8(sp)
    80003064:	e04a                	sd	s2,0(sp)
    80003066:	1000                	addi	s0,sp,32
    80003068:	84ae                	mv	s1,a1
    8000306a:	8932                	mv	s2,a2
  *ip = argraw(n);
    8000306c:	00000097          	auipc	ra,0x0
    80003070:	eaa080e7          	jalr	-342(ra) # 80002f16 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80003074:	864a                	mv	a2,s2
    80003076:	85a6                	mv	a1,s1
    80003078:	00000097          	auipc	ra,0x0
    8000307c:	f58080e7          	jalr	-168(ra) # 80002fd0 <fetchstr>
}
    80003080:	60e2                	ld	ra,24(sp)
    80003082:	6442                	ld	s0,16(sp)
    80003084:	64a2                	ld	s1,8(sp)
    80003086:	6902                	ld	s2,0(sp)
    80003088:	6105                	addi	sp,sp,32
    8000308a:	8082                	ret

000000008000308c <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    8000308c:	1101                	addi	sp,sp,-32
    8000308e:	ec06                	sd	ra,24(sp)
    80003090:	e822                	sd	s0,16(sp)
    80003092:	e426                	sd	s1,8(sp)
    80003094:	e04a                	sd	s2,0(sp)
    80003096:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80003098:	fffff097          	auipc	ra,0xfffff
    8000309c:	e0e080e7          	jalr	-498(ra) # 80001ea6 <myproc>
    800030a0:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800030a2:	05853903          	ld	s2,88(a0)
    800030a6:	0a893783          	ld	a5,168(s2)
    800030aa:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800030ae:	37fd                	addiw	a5,a5,-1
    800030b0:	4751                	li	a4,20
    800030b2:	00f76f63          	bltu	a4,a5,800030d0 <syscall+0x44>
    800030b6:	00369713          	slli	a4,a3,0x3
    800030ba:	00005797          	auipc	a5,0x5
    800030be:	43678793          	addi	a5,a5,1078 # 800084f0 <syscalls>
    800030c2:	97ba                	add	a5,a5,a4
    800030c4:	639c                	ld	a5,0(a5)
    800030c6:	c789                	beqz	a5,800030d0 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    800030c8:	9782                	jalr	a5
    800030ca:	06a93823          	sd	a0,112(s2)
    800030ce:	a839                	j	800030ec <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800030d0:	15848613          	addi	a2,s1,344
    800030d4:	5c8c                	lw	a1,56(s1)
    800030d6:	00005517          	auipc	a0,0x5
    800030da:	3e250513          	addi	a0,a0,994 # 800084b8 <states.0+0x180>
    800030de:	ffffd097          	auipc	ra,0xffffd
    800030e2:	558080e7          	jalr	1368(ra) # 80000636 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800030e6:	6cbc                	ld	a5,88(s1)
    800030e8:	577d                	li	a4,-1
    800030ea:	fbb8                	sd	a4,112(a5)
  }
}
    800030ec:	60e2                	ld	ra,24(sp)
    800030ee:	6442                	ld	s0,16(sp)
    800030f0:	64a2                	ld	s1,8(sp)
    800030f2:	6902                	ld	s2,0(sp)
    800030f4:	6105                	addi	sp,sp,32
    800030f6:	8082                	ret

00000000800030f8 <sys_exit>:
#include "proc.h"
#include "riscv.h"
#include "spinlock.h"
#include "types.h"

uint64 sys_exit(void) {
    800030f8:	1101                	addi	sp,sp,-32
    800030fa:	ec06                	sd	ra,24(sp)
    800030fc:	e822                	sd	s0,16(sp)
    800030fe:	1000                	addi	s0,sp,32
  int n;
  if (argint(0, &n) < 0)
    80003100:	fec40593          	addi	a1,s0,-20
    80003104:	4501                	li	a0,0
    80003106:	00000097          	auipc	ra,0x0
    8000310a:	f12080e7          	jalr	-238(ra) # 80003018 <argint>
    return -1;
    8000310e:	57fd                	li	a5,-1
  if (argint(0, &n) < 0)
    80003110:	00054963          	bltz	a0,80003122 <sys_exit+0x2a>
  exit(n);
    80003114:	fec42503          	lw	a0,-20(s0)
    80003118:	fffff097          	auipc	ra,0xfffff
    8000311c:	45c080e7          	jalr	1116(ra) # 80002574 <exit>
  return 0; // not reached
    80003120:	4781                	li	a5,0
}
    80003122:	853e                	mv	a0,a5
    80003124:	60e2                	ld	ra,24(sp)
    80003126:	6442                	ld	s0,16(sp)
    80003128:	6105                	addi	sp,sp,32
    8000312a:	8082                	ret

000000008000312c <sys_getpid>:

uint64 sys_getpid(void) { return myproc()->pid; }
    8000312c:	1141                	addi	sp,sp,-16
    8000312e:	e406                	sd	ra,8(sp)
    80003130:	e022                	sd	s0,0(sp)
    80003132:	0800                	addi	s0,sp,16
    80003134:	fffff097          	auipc	ra,0xfffff
    80003138:	d72080e7          	jalr	-654(ra) # 80001ea6 <myproc>
    8000313c:	5d08                	lw	a0,56(a0)
    8000313e:	60a2                	ld	ra,8(sp)
    80003140:	6402                	ld	s0,0(sp)
    80003142:	0141                	addi	sp,sp,16
    80003144:	8082                	ret

0000000080003146 <sys_fork>:

uint64 sys_fork(void) { return fork(); }
    80003146:	1141                	addi	sp,sp,-16
    80003148:	e406                	sd	ra,8(sp)
    8000314a:	e022                	sd	s0,0(sp)
    8000314c:	0800                	addi	s0,sp,16
    8000314e:	fffff097          	auipc	ra,0xfffff
    80003152:	118080e7          	jalr	280(ra) # 80002266 <fork>
    80003156:	60a2                	ld	ra,8(sp)
    80003158:	6402                	ld	s0,0(sp)
    8000315a:	0141                	addi	sp,sp,16
    8000315c:	8082                	ret

000000008000315e <sys_wait>:

uint64 sys_wait(void) {
    8000315e:	1101                	addi	sp,sp,-32
    80003160:	ec06                	sd	ra,24(sp)
    80003162:	e822                	sd	s0,16(sp)
    80003164:	1000                	addi	s0,sp,32
  uint64 p;
  if (argaddr(0, &p) < 0)
    80003166:	fe840593          	addi	a1,s0,-24
    8000316a:	4501                	li	a0,0
    8000316c:	00000097          	auipc	ra,0x0
    80003170:	ece080e7          	jalr	-306(ra) # 8000303a <argaddr>
    80003174:	87aa                	mv	a5,a0
    return -1;
    80003176:	557d                	li	a0,-1
  if (argaddr(0, &p) < 0)
    80003178:	0007c863          	bltz	a5,80003188 <sys_wait+0x2a>
  return wait(p);
    8000317c:	fe843503          	ld	a0,-24(s0)
    80003180:	fffff097          	auipc	ra,0xfffff
    80003184:	5b8080e7          	jalr	1464(ra) # 80002738 <wait>
}
    80003188:	60e2                	ld	ra,24(sp)
    8000318a:	6442                	ld	s0,16(sp)
    8000318c:	6105                	addi	sp,sp,32
    8000318e:	8082                	ret

0000000080003190 <sys_sbrk>:

uint64 sys_sbrk(void) {
    80003190:	7179                	addi	sp,sp,-48
    80003192:	f406                	sd	ra,40(sp)
    80003194:	f022                	sd	s0,32(sp)
    80003196:	ec26                	sd	s1,24(sp)
    80003198:	e84a                	sd	s2,16(sp)
    8000319a:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if (argint(0, &n) < 0)
    8000319c:	fdc40593          	addi	a1,s0,-36
    800031a0:	4501                	li	a0,0
    800031a2:	00000097          	auipc	ra,0x0
    800031a6:	e76080e7          	jalr	-394(ra) # 80003018 <argint>
    800031aa:	87aa                	mv	a5,a0
    return -1;
    800031ac:	557d                	li	a0,-1
  if (argint(0, &n) < 0)
    800031ae:	0207c763          	bltz	a5,800031dc <sys_sbrk+0x4c>
  struct proc *p = myproc();
    800031b2:	fffff097          	auipc	ra,0xfffff
    800031b6:	cf4080e7          	jalr	-780(ra) # 80001ea6 <myproc>
    800031ba:	892a                	mv	s2,a0
  addr = p->sz;
    800031bc:	6538                	ld	a4,72(a0)
    800031be:	0007049b          	sext.w	s1,a4
  p->sz += n;
    800031c2:	fdc42783          	lw	a5,-36(s0)
    800031c6:	97ba                	add	a5,a5,a4
    800031c8:	e53c                	sd	a5,72(a0)
  if (p->sz >= MAXVA) {
    800031ca:	577d                	li	a4,-1
    800031cc:	8369                	srli	a4,a4,0x1a
    800031ce:	00f76d63          	bltu	a4,a5,800031e8 <sys_sbrk+0x58>
    p->killed = 1;
    printf("user momry overflow");
    exit(-1);
  }
  if (n < 0) {
    800031d2:	fdc42783          	lw	a5,-36(s0)
    800031d6:	0207c963          	bltz	a5,80003208 <sys_sbrk+0x78>
    uvmdealloc(p->pagetable, addr, p->sz);
  }
  return addr;
    800031da:	8526                	mv	a0,s1
}
    800031dc:	70a2                	ld	ra,40(sp)
    800031de:	7402                	ld	s0,32(sp)
    800031e0:	64e2                	ld	s1,24(sp)
    800031e2:	6942                	ld	s2,16(sp)
    800031e4:	6145                	addi	sp,sp,48
    800031e6:	8082                	ret
    p->killed = 1;
    800031e8:	4785                	li	a5,1
    800031ea:	d91c                	sw	a5,48(a0)
    printf("user momry overflow");
    800031ec:	00005517          	auipc	a0,0x5
    800031f0:	3b450513          	addi	a0,a0,948 # 800085a0 <syscalls+0xb0>
    800031f4:	ffffd097          	auipc	ra,0xffffd
    800031f8:	442080e7          	jalr	1090(ra) # 80000636 <printf>
    exit(-1);
    800031fc:	557d                	li	a0,-1
    800031fe:	fffff097          	auipc	ra,0xfffff
    80003202:	376080e7          	jalr	886(ra) # 80002574 <exit>
    80003206:	b7f1                	j	800031d2 <sys_sbrk+0x42>
    uvmdealloc(p->pagetable, addr, p->sz);
    80003208:	04893603          	ld	a2,72(s2)
    8000320c:	85a6                	mv	a1,s1
    8000320e:	05093503          	ld	a0,80(s2)
    80003212:	ffffe097          	auipc	ra,0xffffe
    80003216:	566080e7          	jalr	1382(ra) # 80001778 <uvmdealloc>
    8000321a:	b7c1                	j	800031da <sys_sbrk+0x4a>

000000008000321c <sys_sleep>:

uint64 sys_sleep(void) {
    8000321c:	7139                	addi	sp,sp,-64
    8000321e:	fc06                	sd	ra,56(sp)
    80003220:	f822                	sd	s0,48(sp)
    80003222:	f426                	sd	s1,40(sp)
    80003224:	f04a                	sd	s2,32(sp)
    80003226:	ec4e                	sd	s3,24(sp)
    80003228:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
    8000322a:	fcc40593          	addi	a1,s0,-52
    8000322e:	4501                	li	a0,0
    80003230:	00000097          	auipc	ra,0x0
    80003234:	de8080e7          	jalr	-536(ra) # 80003018 <argint>
    return -1;
    80003238:	57fd                	li	a5,-1
  if (argint(0, &n) < 0)
    8000323a:	06054563          	bltz	a0,800032a4 <sys_sleep+0x88>
  acquire(&tickslock);
    8000323e:	00034517          	auipc	a0,0x34
    80003242:	68a50513          	addi	a0,a0,1674 # 800378c8 <tickslock>
    80003246:	ffffe097          	auipc	ra,0xffffe
    8000324a:	d34080e7          	jalr	-716(ra) # 80000f7a <acquire>
  ticks0 = ticks;
    8000324e:	00006917          	auipc	s2,0x6
    80003252:	dd292903          	lw	s2,-558(s2) # 80009020 <ticks>
  while (ticks - ticks0 < n) {
    80003256:	fcc42783          	lw	a5,-52(s0)
    8000325a:	cf85                	beqz	a5,80003292 <sys_sleep+0x76>
    if (myproc()->killed) {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000325c:	00034997          	auipc	s3,0x34
    80003260:	66c98993          	addi	s3,s3,1644 # 800378c8 <tickslock>
    80003264:	00006497          	auipc	s1,0x6
    80003268:	dbc48493          	addi	s1,s1,-580 # 80009020 <ticks>
    if (myproc()->killed) {
    8000326c:	fffff097          	auipc	ra,0xfffff
    80003270:	c3a080e7          	jalr	-966(ra) # 80001ea6 <myproc>
    80003274:	591c                	lw	a5,48(a0)
    80003276:	ef9d                	bnez	a5,800032b4 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80003278:	85ce                	mv	a1,s3
    8000327a:	8526                	mv	a0,s1
    8000327c:	fffff097          	auipc	ra,0xfffff
    80003280:	43e080e7          	jalr	1086(ra) # 800026ba <sleep>
  while (ticks - ticks0 < n) {
    80003284:	409c                	lw	a5,0(s1)
    80003286:	412787bb          	subw	a5,a5,s2
    8000328a:	fcc42703          	lw	a4,-52(s0)
    8000328e:	fce7efe3          	bltu	a5,a4,8000326c <sys_sleep+0x50>
  }
  release(&tickslock);
    80003292:	00034517          	auipc	a0,0x34
    80003296:	63650513          	addi	a0,a0,1590 # 800378c8 <tickslock>
    8000329a:	ffffe097          	auipc	ra,0xffffe
    8000329e:	d94080e7          	jalr	-620(ra) # 8000102e <release>
  return 0;
    800032a2:	4781                	li	a5,0
}
    800032a4:	853e                	mv	a0,a5
    800032a6:	70e2                	ld	ra,56(sp)
    800032a8:	7442                	ld	s0,48(sp)
    800032aa:	74a2                	ld	s1,40(sp)
    800032ac:	7902                	ld	s2,32(sp)
    800032ae:	69e2                	ld	s3,24(sp)
    800032b0:	6121                	addi	sp,sp,64
    800032b2:	8082                	ret
      release(&tickslock);
    800032b4:	00034517          	auipc	a0,0x34
    800032b8:	61450513          	addi	a0,a0,1556 # 800378c8 <tickslock>
    800032bc:	ffffe097          	auipc	ra,0xffffe
    800032c0:	d72080e7          	jalr	-654(ra) # 8000102e <release>
      return -1;
    800032c4:	57fd                	li	a5,-1
    800032c6:	bff9                	j	800032a4 <sys_sleep+0x88>

00000000800032c8 <sys_kill>:

uint64 sys_kill(void) {
    800032c8:	1101                	addi	sp,sp,-32
    800032ca:	ec06                	sd	ra,24(sp)
    800032cc:	e822                	sd	s0,16(sp)
    800032ce:	1000                	addi	s0,sp,32
  int pid;

  if (argint(0, &pid) < 0)
    800032d0:	fec40593          	addi	a1,s0,-20
    800032d4:	4501                	li	a0,0
    800032d6:	00000097          	auipc	ra,0x0
    800032da:	d42080e7          	jalr	-702(ra) # 80003018 <argint>
    800032de:	87aa                	mv	a5,a0
    return -1;
    800032e0:	557d                	li	a0,-1
  if (argint(0, &pid) < 0)
    800032e2:	0007c863          	bltz	a5,800032f2 <sys_kill+0x2a>
  return kill(pid);
    800032e6:	fec42503          	lw	a0,-20(s0)
    800032ea:	fffff097          	auipc	ra,0xfffff
    800032ee:	5ba080e7          	jalr	1466(ra) # 800028a4 <kill>
}
    800032f2:	60e2                	ld	ra,24(sp)
    800032f4:	6442                	ld	s0,16(sp)
    800032f6:	6105                	addi	sp,sp,32
    800032f8:	8082                	ret

00000000800032fa <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64 sys_uptime(void) {
    800032fa:	1101                	addi	sp,sp,-32
    800032fc:	ec06                	sd	ra,24(sp)
    800032fe:	e822                	sd	s0,16(sp)
    80003300:	e426                	sd	s1,8(sp)
    80003302:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80003304:	00034517          	auipc	a0,0x34
    80003308:	5c450513          	addi	a0,a0,1476 # 800378c8 <tickslock>
    8000330c:	ffffe097          	auipc	ra,0xffffe
    80003310:	c6e080e7          	jalr	-914(ra) # 80000f7a <acquire>
  xticks = ticks;
    80003314:	00006497          	auipc	s1,0x6
    80003318:	d0c4a483          	lw	s1,-756(s1) # 80009020 <ticks>
  release(&tickslock);
    8000331c:	00034517          	auipc	a0,0x34
    80003320:	5ac50513          	addi	a0,a0,1452 # 800378c8 <tickslock>
    80003324:	ffffe097          	auipc	ra,0xffffe
    80003328:	d0a080e7          	jalr	-758(ra) # 8000102e <release>
  return xticks;
}
    8000332c:	02049513          	slli	a0,s1,0x20
    80003330:	9101                	srli	a0,a0,0x20
    80003332:	60e2                	ld	ra,24(sp)
    80003334:	6442                	ld	s0,16(sp)
    80003336:	64a2                	ld	s1,8(sp)
    80003338:	6105                	addi	sp,sp,32
    8000333a:	8082                	ret

000000008000333c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000333c:	7179                	addi	sp,sp,-48
    8000333e:	f406                	sd	ra,40(sp)
    80003340:	f022                	sd	s0,32(sp)
    80003342:	ec26                	sd	s1,24(sp)
    80003344:	e84a                	sd	s2,16(sp)
    80003346:	e44e                	sd	s3,8(sp)
    80003348:	e052                	sd	s4,0(sp)
    8000334a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000334c:	00005597          	auipc	a1,0x5
    80003350:	26c58593          	addi	a1,a1,620 # 800085b8 <syscalls+0xc8>
    80003354:	00034517          	auipc	a0,0x34
    80003358:	58c50513          	addi	a0,a0,1420 # 800378e0 <bcache>
    8000335c:	ffffe097          	auipc	ra,0xffffe
    80003360:	b8e080e7          	jalr	-1138(ra) # 80000eea <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003364:	0003c797          	auipc	a5,0x3c
    80003368:	57c78793          	addi	a5,a5,1404 # 8003f8e0 <bcache+0x8000>
    8000336c:	0003c717          	auipc	a4,0x3c
    80003370:	7dc70713          	addi	a4,a4,2012 # 8003fb48 <bcache+0x8268>
    80003374:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003378:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000337c:	00034497          	auipc	s1,0x34
    80003380:	57c48493          	addi	s1,s1,1404 # 800378f8 <bcache+0x18>
    b->next = bcache.head.next;
    80003384:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003386:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003388:	00005a17          	auipc	s4,0x5
    8000338c:	238a0a13          	addi	s4,s4,568 # 800085c0 <syscalls+0xd0>
    b->next = bcache.head.next;
    80003390:	2b893783          	ld	a5,696(s2)
    80003394:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003396:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000339a:	85d2                	mv	a1,s4
    8000339c:	01048513          	addi	a0,s1,16
    800033a0:	00001097          	auipc	ra,0x1
    800033a4:	4b0080e7          	jalr	1200(ra) # 80004850 <initsleeplock>
    bcache.head.next->prev = b;
    800033a8:	2b893783          	ld	a5,696(s2)
    800033ac:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800033ae:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800033b2:	45848493          	addi	s1,s1,1112
    800033b6:	fd349de3          	bne	s1,s3,80003390 <binit+0x54>
  }
}
    800033ba:	70a2                	ld	ra,40(sp)
    800033bc:	7402                	ld	s0,32(sp)
    800033be:	64e2                	ld	s1,24(sp)
    800033c0:	6942                	ld	s2,16(sp)
    800033c2:	69a2                	ld	s3,8(sp)
    800033c4:	6a02                	ld	s4,0(sp)
    800033c6:	6145                	addi	sp,sp,48
    800033c8:	8082                	ret

00000000800033ca <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800033ca:	7179                	addi	sp,sp,-48
    800033cc:	f406                	sd	ra,40(sp)
    800033ce:	f022                	sd	s0,32(sp)
    800033d0:	ec26                	sd	s1,24(sp)
    800033d2:	e84a                	sd	s2,16(sp)
    800033d4:	e44e                	sd	s3,8(sp)
    800033d6:	1800                	addi	s0,sp,48
    800033d8:	892a                	mv	s2,a0
    800033da:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800033dc:	00034517          	auipc	a0,0x34
    800033e0:	50450513          	addi	a0,a0,1284 # 800378e0 <bcache>
    800033e4:	ffffe097          	auipc	ra,0xffffe
    800033e8:	b96080e7          	jalr	-1130(ra) # 80000f7a <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800033ec:	0003c497          	auipc	s1,0x3c
    800033f0:	7ac4b483          	ld	s1,1964(s1) # 8003fb98 <bcache+0x82b8>
    800033f4:	0003c797          	auipc	a5,0x3c
    800033f8:	75478793          	addi	a5,a5,1876 # 8003fb48 <bcache+0x8268>
    800033fc:	02f48f63          	beq	s1,a5,8000343a <bread+0x70>
    80003400:	873e                	mv	a4,a5
    80003402:	a021                	j	8000340a <bread+0x40>
    80003404:	68a4                	ld	s1,80(s1)
    80003406:	02e48a63          	beq	s1,a4,8000343a <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000340a:	449c                	lw	a5,8(s1)
    8000340c:	ff279ce3          	bne	a5,s2,80003404 <bread+0x3a>
    80003410:	44dc                	lw	a5,12(s1)
    80003412:	ff3799e3          	bne	a5,s3,80003404 <bread+0x3a>
      b->refcnt++;
    80003416:	40bc                	lw	a5,64(s1)
    80003418:	2785                	addiw	a5,a5,1
    8000341a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000341c:	00034517          	auipc	a0,0x34
    80003420:	4c450513          	addi	a0,a0,1220 # 800378e0 <bcache>
    80003424:	ffffe097          	auipc	ra,0xffffe
    80003428:	c0a080e7          	jalr	-1014(ra) # 8000102e <release>
      acquiresleep(&b->lock);
    8000342c:	01048513          	addi	a0,s1,16
    80003430:	00001097          	auipc	ra,0x1
    80003434:	45a080e7          	jalr	1114(ra) # 8000488a <acquiresleep>
      return b;
    80003438:	a8b9                	j	80003496 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000343a:	0003c497          	auipc	s1,0x3c
    8000343e:	7564b483          	ld	s1,1878(s1) # 8003fb90 <bcache+0x82b0>
    80003442:	0003c797          	auipc	a5,0x3c
    80003446:	70678793          	addi	a5,a5,1798 # 8003fb48 <bcache+0x8268>
    8000344a:	00f48863          	beq	s1,a5,8000345a <bread+0x90>
    8000344e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003450:	40bc                	lw	a5,64(s1)
    80003452:	cf81                	beqz	a5,8000346a <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003454:	64a4                	ld	s1,72(s1)
    80003456:	fee49de3          	bne	s1,a4,80003450 <bread+0x86>
  panic("bget: no buffers");
    8000345a:	00005517          	auipc	a0,0x5
    8000345e:	16e50513          	addi	a0,a0,366 # 800085c8 <syscalls+0xd8>
    80003462:	ffffd097          	auipc	ra,0xffffd
    80003466:	182080e7          	jalr	386(ra) # 800005e4 <panic>
      b->dev = dev;
    8000346a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000346e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003472:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003476:	4785                	li	a5,1
    80003478:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000347a:	00034517          	auipc	a0,0x34
    8000347e:	46650513          	addi	a0,a0,1126 # 800378e0 <bcache>
    80003482:	ffffe097          	auipc	ra,0xffffe
    80003486:	bac080e7          	jalr	-1108(ra) # 8000102e <release>
      acquiresleep(&b->lock);
    8000348a:	01048513          	addi	a0,s1,16
    8000348e:	00001097          	auipc	ra,0x1
    80003492:	3fc080e7          	jalr	1020(ra) # 8000488a <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003496:	409c                	lw	a5,0(s1)
    80003498:	cb89                	beqz	a5,800034aa <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000349a:	8526                	mv	a0,s1
    8000349c:	70a2                	ld	ra,40(sp)
    8000349e:	7402                	ld	s0,32(sp)
    800034a0:	64e2                	ld	s1,24(sp)
    800034a2:	6942                	ld	s2,16(sp)
    800034a4:	69a2                	ld	s3,8(sp)
    800034a6:	6145                	addi	sp,sp,48
    800034a8:	8082                	ret
    virtio_disk_rw(b, 0);
    800034aa:	4581                	li	a1,0
    800034ac:	8526                	mv	a0,s1
    800034ae:	00003097          	auipc	ra,0x3
    800034b2:	f2e080e7          	jalr	-210(ra) # 800063dc <virtio_disk_rw>
    b->valid = 1;
    800034b6:	4785                	li	a5,1
    800034b8:	c09c                	sw	a5,0(s1)
  return b;
    800034ba:	b7c5                	j	8000349a <bread+0xd0>

00000000800034bc <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800034bc:	1101                	addi	sp,sp,-32
    800034be:	ec06                	sd	ra,24(sp)
    800034c0:	e822                	sd	s0,16(sp)
    800034c2:	e426                	sd	s1,8(sp)
    800034c4:	1000                	addi	s0,sp,32
    800034c6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800034c8:	0541                	addi	a0,a0,16
    800034ca:	00001097          	auipc	ra,0x1
    800034ce:	45a080e7          	jalr	1114(ra) # 80004924 <holdingsleep>
    800034d2:	cd01                	beqz	a0,800034ea <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800034d4:	4585                	li	a1,1
    800034d6:	8526                	mv	a0,s1
    800034d8:	00003097          	auipc	ra,0x3
    800034dc:	f04080e7          	jalr	-252(ra) # 800063dc <virtio_disk_rw>
}
    800034e0:	60e2                	ld	ra,24(sp)
    800034e2:	6442                	ld	s0,16(sp)
    800034e4:	64a2                	ld	s1,8(sp)
    800034e6:	6105                	addi	sp,sp,32
    800034e8:	8082                	ret
    panic("bwrite");
    800034ea:	00005517          	auipc	a0,0x5
    800034ee:	0f650513          	addi	a0,a0,246 # 800085e0 <syscalls+0xf0>
    800034f2:	ffffd097          	auipc	ra,0xffffd
    800034f6:	0f2080e7          	jalr	242(ra) # 800005e4 <panic>

00000000800034fa <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800034fa:	1101                	addi	sp,sp,-32
    800034fc:	ec06                	sd	ra,24(sp)
    800034fe:	e822                	sd	s0,16(sp)
    80003500:	e426                	sd	s1,8(sp)
    80003502:	e04a                	sd	s2,0(sp)
    80003504:	1000                	addi	s0,sp,32
    80003506:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003508:	01050913          	addi	s2,a0,16
    8000350c:	854a                	mv	a0,s2
    8000350e:	00001097          	auipc	ra,0x1
    80003512:	416080e7          	jalr	1046(ra) # 80004924 <holdingsleep>
    80003516:	c92d                	beqz	a0,80003588 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80003518:	854a                	mv	a0,s2
    8000351a:	00001097          	auipc	ra,0x1
    8000351e:	3c6080e7          	jalr	966(ra) # 800048e0 <releasesleep>

  acquire(&bcache.lock);
    80003522:	00034517          	auipc	a0,0x34
    80003526:	3be50513          	addi	a0,a0,958 # 800378e0 <bcache>
    8000352a:	ffffe097          	auipc	ra,0xffffe
    8000352e:	a50080e7          	jalr	-1456(ra) # 80000f7a <acquire>
  b->refcnt--;
    80003532:	40bc                	lw	a5,64(s1)
    80003534:	37fd                	addiw	a5,a5,-1
    80003536:	0007871b          	sext.w	a4,a5
    8000353a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000353c:	eb05                	bnez	a4,8000356c <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000353e:	68bc                	ld	a5,80(s1)
    80003540:	64b8                	ld	a4,72(s1)
    80003542:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80003544:	64bc                	ld	a5,72(s1)
    80003546:	68b8                	ld	a4,80(s1)
    80003548:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000354a:	0003c797          	auipc	a5,0x3c
    8000354e:	39678793          	addi	a5,a5,918 # 8003f8e0 <bcache+0x8000>
    80003552:	2b87b703          	ld	a4,696(a5)
    80003556:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003558:	0003c717          	auipc	a4,0x3c
    8000355c:	5f070713          	addi	a4,a4,1520 # 8003fb48 <bcache+0x8268>
    80003560:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003562:	2b87b703          	ld	a4,696(a5)
    80003566:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003568:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000356c:	00034517          	auipc	a0,0x34
    80003570:	37450513          	addi	a0,a0,884 # 800378e0 <bcache>
    80003574:	ffffe097          	auipc	ra,0xffffe
    80003578:	aba080e7          	jalr	-1350(ra) # 8000102e <release>
}
    8000357c:	60e2                	ld	ra,24(sp)
    8000357e:	6442                	ld	s0,16(sp)
    80003580:	64a2                	ld	s1,8(sp)
    80003582:	6902                	ld	s2,0(sp)
    80003584:	6105                	addi	sp,sp,32
    80003586:	8082                	ret
    panic("brelse");
    80003588:	00005517          	auipc	a0,0x5
    8000358c:	06050513          	addi	a0,a0,96 # 800085e8 <syscalls+0xf8>
    80003590:	ffffd097          	auipc	ra,0xffffd
    80003594:	054080e7          	jalr	84(ra) # 800005e4 <panic>

0000000080003598 <bpin>:

void
bpin(struct buf *b) {
    80003598:	1101                	addi	sp,sp,-32
    8000359a:	ec06                	sd	ra,24(sp)
    8000359c:	e822                	sd	s0,16(sp)
    8000359e:	e426                	sd	s1,8(sp)
    800035a0:	1000                	addi	s0,sp,32
    800035a2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800035a4:	00034517          	auipc	a0,0x34
    800035a8:	33c50513          	addi	a0,a0,828 # 800378e0 <bcache>
    800035ac:	ffffe097          	auipc	ra,0xffffe
    800035b0:	9ce080e7          	jalr	-1586(ra) # 80000f7a <acquire>
  b->refcnt++;
    800035b4:	40bc                	lw	a5,64(s1)
    800035b6:	2785                	addiw	a5,a5,1
    800035b8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800035ba:	00034517          	auipc	a0,0x34
    800035be:	32650513          	addi	a0,a0,806 # 800378e0 <bcache>
    800035c2:	ffffe097          	auipc	ra,0xffffe
    800035c6:	a6c080e7          	jalr	-1428(ra) # 8000102e <release>
}
    800035ca:	60e2                	ld	ra,24(sp)
    800035cc:	6442                	ld	s0,16(sp)
    800035ce:	64a2                	ld	s1,8(sp)
    800035d0:	6105                	addi	sp,sp,32
    800035d2:	8082                	ret

00000000800035d4 <bunpin>:

void
bunpin(struct buf *b) {
    800035d4:	1101                	addi	sp,sp,-32
    800035d6:	ec06                	sd	ra,24(sp)
    800035d8:	e822                	sd	s0,16(sp)
    800035da:	e426                	sd	s1,8(sp)
    800035dc:	1000                	addi	s0,sp,32
    800035de:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800035e0:	00034517          	auipc	a0,0x34
    800035e4:	30050513          	addi	a0,a0,768 # 800378e0 <bcache>
    800035e8:	ffffe097          	auipc	ra,0xffffe
    800035ec:	992080e7          	jalr	-1646(ra) # 80000f7a <acquire>
  b->refcnt--;
    800035f0:	40bc                	lw	a5,64(s1)
    800035f2:	37fd                	addiw	a5,a5,-1
    800035f4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800035f6:	00034517          	auipc	a0,0x34
    800035fa:	2ea50513          	addi	a0,a0,746 # 800378e0 <bcache>
    800035fe:	ffffe097          	auipc	ra,0xffffe
    80003602:	a30080e7          	jalr	-1488(ra) # 8000102e <release>
}
    80003606:	60e2                	ld	ra,24(sp)
    80003608:	6442                	ld	s0,16(sp)
    8000360a:	64a2                	ld	s1,8(sp)
    8000360c:	6105                	addi	sp,sp,32
    8000360e:	8082                	ret

0000000080003610 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003610:	1101                	addi	sp,sp,-32
    80003612:	ec06                	sd	ra,24(sp)
    80003614:	e822                	sd	s0,16(sp)
    80003616:	e426                	sd	s1,8(sp)
    80003618:	e04a                	sd	s2,0(sp)
    8000361a:	1000                	addi	s0,sp,32
    8000361c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000361e:	00d5d59b          	srliw	a1,a1,0xd
    80003622:	0003d797          	auipc	a5,0x3d
    80003626:	99a7a783          	lw	a5,-1638(a5) # 8003ffbc <sb+0x1c>
    8000362a:	9dbd                	addw	a1,a1,a5
    8000362c:	00000097          	auipc	ra,0x0
    80003630:	d9e080e7          	jalr	-610(ra) # 800033ca <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003634:	0074f713          	andi	a4,s1,7
    80003638:	4785                	li	a5,1
    8000363a:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000363e:	14ce                	slli	s1,s1,0x33
    80003640:	90d9                	srli	s1,s1,0x36
    80003642:	00950733          	add	a4,a0,s1
    80003646:	05874703          	lbu	a4,88(a4)
    8000364a:	00e7f6b3          	and	a3,a5,a4
    8000364e:	c69d                	beqz	a3,8000367c <bfree+0x6c>
    80003650:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003652:	94aa                	add	s1,s1,a0
    80003654:	fff7c793          	not	a5,a5
    80003658:	8ff9                	and	a5,a5,a4
    8000365a:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    8000365e:	00001097          	auipc	ra,0x1
    80003662:	104080e7          	jalr	260(ra) # 80004762 <log_write>
  brelse(bp);
    80003666:	854a                	mv	a0,s2
    80003668:	00000097          	auipc	ra,0x0
    8000366c:	e92080e7          	jalr	-366(ra) # 800034fa <brelse>
}
    80003670:	60e2                	ld	ra,24(sp)
    80003672:	6442                	ld	s0,16(sp)
    80003674:	64a2                	ld	s1,8(sp)
    80003676:	6902                	ld	s2,0(sp)
    80003678:	6105                	addi	sp,sp,32
    8000367a:	8082                	ret
    panic("freeing free block");
    8000367c:	00005517          	auipc	a0,0x5
    80003680:	f7450513          	addi	a0,a0,-140 # 800085f0 <syscalls+0x100>
    80003684:	ffffd097          	auipc	ra,0xffffd
    80003688:	f60080e7          	jalr	-160(ra) # 800005e4 <panic>

000000008000368c <balloc>:
{
    8000368c:	711d                	addi	sp,sp,-96
    8000368e:	ec86                	sd	ra,88(sp)
    80003690:	e8a2                	sd	s0,80(sp)
    80003692:	e4a6                	sd	s1,72(sp)
    80003694:	e0ca                	sd	s2,64(sp)
    80003696:	fc4e                	sd	s3,56(sp)
    80003698:	f852                	sd	s4,48(sp)
    8000369a:	f456                	sd	s5,40(sp)
    8000369c:	f05a                	sd	s6,32(sp)
    8000369e:	ec5e                	sd	s7,24(sp)
    800036a0:	e862                	sd	s8,16(sp)
    800036a2:	e466                	sd	s9,8(sp)
    800036a4:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800036a6:	0003d797          	auipc	a5,0x3d
    800036aa:	8fe7a783          	lw	a5,-1794(a5) # 8003ffa4 <sb+0x4>
    800036ae:	cbd1                	beqz	a5,80003742 <balloc+0xb6>
    800036b0:	8baa                	mv	s7,a0
    800036b2:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800036b4:	0003db17          	auipc	s6,0x3d
    800036b8:	8ecb0b13          	addi	s6,s6,-1812 # 8003ffa0 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800036bc:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800036be:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800036c0:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800036c2:	6c89                	lui	s9,0x2
    800036c4:	a831                	j	800036e0 <balloc+0x54>
    brelse(bp);
    800036c6:	854a                	mv	a0,s2
    800036c8:	00000097          	auipc	ra,0x0
    800036cc:	e32080e7          	jalr	-462(ra) # 800034fa <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800036d0:	015c87bb          	addw	a5,s9,s5
    800036d4:	00078a9b          	sext.w	s5,a5
    800036d8:	004b2703          	lw	a4,4(s6)
    800036dc:	06eaf363          	bgeu	s5,a4,80003742 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800036e0:	41fad79b          	sraiw	a5,s5,0x1f
    800036e4:	0137d79b          	srliw	a5,a5,0x13
    800036e8:	015787bb          	addw	a5,a5,s5
    800036ec:	40d7d79b          	sraiw	a5,a5,0xd
    800036f0:	01cb2583          	lw	a1,28(s6)
    800036f4:	9dbd                	addw	a1,a1,a5
    800036f6:	855e                	mv	a0,s7
    800036f8:	00000097          	auipc	ra,0x0
    800036fc:	cd2080e7          	jalr	-814(ra) # 800033ca <bread>
    80003700:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003702:	004b2503          	lw	a0,4(s6)
    80003706:	000a849b          	sext.w	s1,s5
    8000370a:	8662                	mv	a2,s8
    8000370c:	faa4fde3          	bgeu	s1,a0,800036c6 <balloc+0x3a>
      m = 1 << (bi % 8);
    80003710:	41f6579b          	sraiw	a5,a2,0x1f
    80003714:	01d7d69b          	srliw	a3,a5,0x1d
    80003718:	00c6873b          	addw	a4,a3,a2
    8000371c:	00777793          	andi	a5,a4,7
    80003720:	9f95                	subw	a5,a5,a3
    80003722:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003726:	4037571b          	sraiw	a4,a4,0x3
    8000372a:	00e906b3          	add	a3,s2,a4
    8000372e:	0586c683          	lbu	a3,88(a3)
    80003732:	00d7f5b3          	and	a1,a5,a3
    80003736:	cd91                	beqz	a1,80003752 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003738:	2605                	addiw	a2,a2,1
    8000373a:	2485                	addiw	s1,s1,1
    8000373c:	fd4618e3          	bne	a2,s4,8000370c <balloc+0x80>
    80003740:	b759                	j	800036c6 <balloc+0x3a>
  panic("balloc: out of blocks");
    80003742:	00005517          	auipc	a0,0x5
    80003746:	ec650513          	addi	a0,a0,-314 # 80008608 <syscalls+0x118>
    8000374a:	ffffd097          	auipc	ra,0xffffd
    8000374e:	e9a080e7          	jalr	-358(ra) # 800005e4 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003752:	974a                	add	a4,a4,s2
    80003754:	8fd5                	or	a5,a5,a3
    80003756:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    8000375a:	854a                	mv	a0,s2
    8000375c:	00001097          	auipc	ra,0x1
    80003760:	006080e7          	jalr	6(ra) # 80004762 <log_write>
        brelse(bp);
    80003764:	854a                	mv	a0,s2
    80003766:	00000097          	auipc	ra,0x0
    8000376a:	d94080e7          	jalr	-620(ra) # 800034fa <brelse>
  bp = bread(dev, bno);
    8000376e:	85a6                	mv	a1,s1
    80003770:	855e                	mv	a0,s7
    80003772:	00000097          	auipc	ra,0x0
    80003776:	c58080e7          	jalr	-936(ra) # 800033ca <bread>
    8000377a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000377c:	40000613          	li	a2,1024
    80003780:	4581                	li	a1,0
    80003782:	05850513          	addi	a0,a0,88
    80003786:	ffffe097          	auipc	ra,0xffffe
    8000378a:	8f0080e7          	jalr	-1808(ra) # 80001076 <memset>
  log_write(bp);
    8000378e:	854a                	mv	a0,s2
    80003790:	00001097          	auipc	ra,0x1
    80003794:	fd2080e7          	jalr	-46(ra) # 80004762 <log_write>
  brelse(bp);
    80003798:	854a                	mv	a0,s2
    8000379a:	00000097          	auipc	ra,0x0
    8000379e:	d60080e7          	jalr	-672(ra) # 800034fa <brelse>
}
    800037a2:	8526                	mv	a0,s1
    800037a4:	60e6                	ld	ra,88(sp)
    800037a6:	6446                	ld	s0,80(sp)
    800037a8:	64a6                	ld	s1,72(sp)
    800037aa:	6906                	ld	s2,64(sp)
    800037ac:	79e2                	ld	s3,56(sp)
    800037ae:	7a42                	ld	s4,48(sp)
    800037b0:	7aa2                	ld	s5,40(sp)
    800037b2:	7b02                	ld	s6,32(sp)
    800037b4:	6be2                	ld	s7,24(sp)
    800037b6:	6c42                	ld	s8,16(sp)
    800037b8:	6ca2                	ld	s9,8(sp)
    800037ba:	6125                	addi	sp,sp,96
    800037bc:	8082                	ret

00000000800037be <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800037be:	7179                	addi	sp,sp,-48
    800037c0:	f406                	sd	ra,40(sp)
    800037c2:	f022                	sd	s0,32(sp)
    800037c4:	ec26                	sd	s1,24(sp)
    800037c6:	e84a                	sd	s2,16(sp)
    800037c8:	e44e                	sd	s3,8(sp)
    800037ca:	e052                	sd	s4,0(sp)
    800037cc:	1800                	addi	s0,sp,48
    800037ce:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800037d0:	47ad                	li	a5,11
    800037d2:	04b7fe63          	bgeu	a5,a1,8000382e <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800037d6:	ff45849b          	addiw	s1,a1,-12
    800037da:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800037de:	0ff00793          	li	a5,255
    800037e2:	0ae7e363          	bltu	a5,a4,80003888 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800037e6:	08052583          	lw	a1,128(a0)
    800037ea:	c5ad                	beqz	a1,80003854 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800037ec:	00092503          	lw	a0,0(s2)
    800037f0:	00000097          	auipc	ra,0x0
    800037f4:	bda080e7          	jalr	-1062(ra) # 800033ca <bread>
    800037f8:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800037fa:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800037fe:	02049593          	slli	a1,s1,0x20
    80003802:	9181                	srli	a1,a1,0x20
    80003804:	058a                	slli	a1,a1,0x2
    80003806:	00b784b3          	add	s1,a5,a1
    8000380a:	0004a983          	lw	s3,0(s1)
    8000380e:	04098d63          	beqz	s3,80003868 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80003812:	8552                	mv	a0,s4
    80003814:	00000097          	auipc	ra,0x0
    80003818:	ce6080e7          	jalr	-794(ra) # 800034fa <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000381c:	854e                	mv	a0,s3
    8000381e:	70a2                	ld	ra,40(sp)
    80003820:	7402                	ld	s0,32(sp)
    80003822:	64e2                	ld	s1,24(sp)
    80003824:	6942                	ld	s2,16(sp)
    80003826:	69a2                	ld	s3,8(sp)
    80003828:	6a02                	ld	s4,0(sp)
    8000382a:	6145                	addi	sp,sp,48
    8000382c:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000382e:	02059493          	slli	s1,a1,0x20
    80003832:	9081                	srli	s1,s1,0x20
    80003834:	048a                	slli	s1,s1,0x2
    80003836:	94aa                	add	s1,s1,a0
    80003838:	0504a983          	lw	s3,80(s1)
    8000383c:	fe0990e3          	bnez	s3,8000381c <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80003840:	4108                	lw	a0,0(a0)
    80003842:	00000097          	auipc	ra,0x0
    80003846:	e4a080e7          	jalr	-438(ra) # 8000368c <balloc>
    8000384a:	0005099b          	sext.w	s3,a0
    8000384e:	0534a823          	sw	s3,80(s1)
    80003852:	b7e9                	j	8000381c <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80003854:	4108                	lw	a0,0(a0)
    80003856:	00000097          	auipc	ra,0x0
    8000385a:	e36080e7          	jalr	-458(ra) # 8000368c <balloc>
    8000385e:	0005059b          	sext.w	a1,a0
    80003862:	08b92023          	sw	a1,128(s2)
    80003866:	b759                	j	800037ec <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80003868:	00092503          	lw	a0,0(s2)
    8000386c:	00000097          	auipc	ra,0x0
    80003870:	e20080e7          	jalr	-480(ra) # 8000368c <balloc>
    80003874:	0005099b          	sext.w	s3,a0
    80003878:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000387c:	8552                	mv	a0,s4
    8000387e:	00001097          	auipc	ra,0x1
    80003882:	ee4080e7          	jalr	-284(ra) # 80004762 <log_write>
    80003886:	b771                	j	80003812 <bmap+0x54>
  panic("bmap: out of range");
    80003888:	00005517          	auipc	a0,0x5
    8000388c:	d9850513          	addi	a0,a0,-616 # 80008620 <syscalls+0x130>
    80003890:	ffffd097          	auipc	ra,0xffffd
    80003894:	d54080e7          	jalr	-684(ra) # 800005e4 <panic>

0000000080003898 <iget>:
{
    80003898:	7179                	addi	sp,sp,-48
    8000389a:	f406                	sd	ra,40(sp)
    8000389c:	f022                	sd	s0,32(sp)
    8000389e:	ec26                	sd	s1,24(sp)
    800038a0:	e84a                	sd	s2,16(sp)
    800038a2:	e44e                	sd	s3,8(sp)
    800038a4:	e052                	sd	s4,0(sp)
    800038a6:	1800                	addi	s0,sp,48
    800038a8:	89aa                	mv	s3,a0
    800038aa:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    800038ac:	0003c517          	auipc	a0,0x3c
    800038b0:	71450513          	addi	a0,a0,1812 # 8003ffc0 <icache>
    800038b4:	ffffd097          	auipc	ra,0xffffd
    800038b8:	6c6080e7          	jalr	1734(ra) # 80000f7a <acquire>
  empty = 0;
    800038bc:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    800038be:	0003c497          	auipc	s1,0x3c
    800038c2:	71a48493          	addi	s1,s1,1818 # 8003ffd8 <icache+0x18>
    800038c6:	0003e697          	auipc	a3,0x3e
    800038ca:	1a268693          	addi	a3,a3,418 # 80041a68 <log>
    800038ce:	a039                	j	800038dc <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800038d0:	02090b63          	beqz	s2,80003906 <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    800038d4:	08848493          	addi	s1,s1,136
    800038d8:	02d48a63          	beq	s1,a3,8000390c <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800038dc:	449c                	lw	a5,8(s1)
    800038de:	fef059e3          	blez	a5,800038d0 <iget+0x38>
    800038e2:	4098                	lw	a4,0(s1)
    800038e4:	ff3716e3          	bne	a4,s3,800038d0 <iget+0x38>
    800038e8:	40d8                	lw	a4,4(s1)
    800038ea:	ff4713e3          	bne	a4,s4,800038d0 <iget+0x38>
      ip->ref++;
    800038ee:	2785                	addiw	a5,a5,1
    800038f0:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    800038f2:	0003c517          	auipc	a0,0x3c
    800038f6:	6ce50513          	addi	a0,a0,1742 # 8003ffc0 <icache>
    800038fa:	ffffd097          	auipc	ra,0xffffd
    800038fe:	734080e7          	jalr	1844(ra) # 8000102e <release>
      return ip;
    80003902:	8926                	mv	s2,s1
    80003904:	a03d                	j	80003932 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003906:	f7f9                	bnez	a5,800038d4 <iget+0x3c>
    80003908:	8926                	mv	s2,s1
    8000390a:	b7e9                	j	800038d4 <iget+0x3c>
  if(empty == 0)
    8000390c:	02090c63          	beqz	s2,80003944 <iget+0xac>
  ip->dev = dev;
    80003910:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003914:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003918:	4785                	li	a5,1
    8000391a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000391e:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    80003922:	0003c517          	auipc	a0,0x3c
    80003926:	69e50513          	addi	a0,a0,1694 # 8003ffc0 <icache>
    8000392a:	ffffd097          	auipc	ra,0xffffd
    8000392e:	704080e7          	jalr	1796(ra) # 8000102e <release>
}
    80003932:	854a                	mv	a0,s2
    80003934:	70a2                	ld	ra,40(sp)
    80003936:	7402                	ld	s0,32(sp)
    80003938:	64e2                	ld	s1,24(sp)
    8000393a:	6942                	ld	s2,16(sp)
    8000393c:	69a2                	ld	s3,8(sp)
    8000393e:	6a02                	ld	s4,0(sp)
    80003940:	6145                	addi	sp,sp,48
    80003942:	8082                	ret
    panic("iget: no inodes");
    80003944:	00005517          	auipc	a0,0x5
    80003948:	cf450513          	addi	a0,a0,-780 # 80008638 <syscalls+0x148>
    8000394c:	ffffd097          	auipc	ra,0xffffd
    80003950:	c98080e7          	jalr	-872(ra) # 800005e4 <panic>

0000000080003954 <fsinit>:
fsinit(int dev) {
    80003954:	7179                	addi	sp,sp,-48
    80003956:	f406                	sd	ra,40(sp)
    80003958:	f022                	sd	s0,32(sp)
    8000395a:	ec26                	sd	s1,24(sp)
    8000395c:	e84a                	sd	s2,16(sp)
    8000395e:	e44e                	sd	s3,8(sp)
    80003960:	1800                	addi	s0,sp,48
    80003962:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003964:	4585                	li	a1,1
    80003966:	00000097          	auipc	ra,0x0
    8000396a:	a64080e7          	jalr	-1436(ra) # 800033ca <bread>
    8000396e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003970:	0003c997          	auipc	s3,0x3c
    80003974:	63098993          	addi	s3,s3,1584 # 8003ffa0 <sb>
    80003978:	02000613          	li	a2,32
    8000397c:	05850593          	addi	a1,a0,88
    80003980:	854e                	mv	a0,s3
    80003982:	ffffd097          	auipc	ra,0xffffd
    80003986:	750080e7          	jalr	1872(ra) # 800010d2 <memmove>
  brelse(bp);
    8000398a:	8526                	mv	a0,s1
    8000398c:	00000097          	auipc	ra,0x0
    80003990:	b6e080e7          	jalr	-1170(ra) # 800034fa <brelse>
  if(sb.magic != FSMAGIC)
    80003994:	0009a703          	lw	a4,0(s3)
    80003998:	102037b7          	lui	a5,0x10203
    8000399c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800039a0:	02f71263          	bne	a4,a5,800039c4 <fsinit+0x70>
  initlog(dev, &sb);
    800039a4:	0003c597          	auipc	a1,0x3c
    800039a8:	5fc58593          	addi	a1,a1,1532 # 8003ffa0 <sb>
    800039ac:	854a                	mv	a0,s2
    800039ae:	00001097          	auipc	ra,0x1
    800039b2:	b3c080e7          	jalr	-1220(ra) # 800044ea <initlog>
}
    800039b6:	70a2                	ld	ra,40(sp)
    800039b8:	7402                	ld	s0,32(sp)
    800039ba:	64e2                	ld	s1,24(sp)
    800039bc:	6942                	ld	s2,16(sp)
    800039be:	69a2                	ld	s3,8(sp)
    800039c0:	6145                	addi	sp,sp,48
    800039c2:	8082                	ret
    panic("invalid file system");
    800039c4:	00005517          	auipc	a0,0x5
    800039c8:	c8450513          	addi	a0,a0,-892 # 80008648 <syscalls+0x158>
    800039cc:	ffffd097          	auipc	ra,0xffffd
    800039d0:	c18080e7          	jalr	-1000(ra) # 800005e4 <panic>

00000000800039d4 <iinit>:
{
    800039d4:	7179                	addi	sp,sp,-48
    800039d6:	f406                	sd	ra,40(sp)
    800039d8:	f022                	sd	s0,32(sp)
    800039da:	ec26                	sd	s1,24(sp)
    800039dc:	e84a                	sd	s2,16(sp)
    800039de:	e44e                	sd	s3,8(sp)
    800039e0:	1800                	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    800039e2:	00005597          	auipc	a1,0x5
    800039e6:	c7e58593          	addi	a1,a1,-898 # 80008660 <syscalls+0x170>
    800039ea:	0003c517          	auipc	a0,0x3c
    800039ee:	5d650513          	addi	a0,a0,1494 # 8003ffc0 <icache>
    800039f2:	ffffd097          	auipc	ra,0xffffd
    800039f6:	4f8080e7          	jalr	1272(ra) # 80000eea <initlock>
  for(i = 0; i < NINODE; i++) {
    800039fa:	0003c497          	auipc	s1,0x3c
    800039fe:	5ee48493          	addi	s1,s1,1518 # 8003ffe8 <icache+0x28>
    80003a02:	0003e997          	auipc	s3,0x3e
    80003a06:	07698993          	addi	s3,s3,118 # 80041a78 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    80003a0a:	00005917          	auipc	s2,0x5
    80003a0e:	c5e90913          	addi	s2,s2,-930 # 80008668 <syscalls+0x178>
    80003a12:	85ca                	mv	a1,s2
    80003a14:	8526                	mv	a0,s1
    80003a16:	00001097          	auipc	ra,0x1
    80003a1a:	e3a080e7          	jalr	-454(ra) # 80004850 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003a1e:	08848493          	addi	s1,s1,136
    80003a22:	ff3498e3          	bne	s1,s3,80003a12 <iinit+0x3e>
}
    80003a26:	70a2                	ld	ra,40(sp)
    80003a28:	7402                	ld	s0,32(sp)
    80003a2a:	64e2                	ld	s1,24(sp)
    80003a2c:	6942                	ld	s2,16(sp)
    80003a2e:	69a2                	ld	s3,8(sp)
    80003a30:	6145                	addi	sp,sp,48
    80003a32:	8082                	ret

0000000080003a34 <ialloc>:
{
    80003a34:	715d                	addi	sp,sp,-80
    80003a36:	e486                	sd	ra,72(sp)
    80003a38:	e0a2                	sd	s0,64(sp)
    80003a3a:	fc26                	sd	s1,56(sp)
    80003a3c:	f84a                	sd	s2,48(sp)
    80003a3e:	f44e                	sd	s3,40(sp)
    80003a40:	f052                	sd	s4,32(sp)
    80003a42:	ec56                	sd	s5,24(sp)
    80003a44:	e85a                	sd	s6,16(sp)
    80003a46:	e45e                	sd	s7,8(sp)
    80003a48:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003a4a:	0003c717          	auipc	a4,0x3c
    80003a4e:	56272703          	lw	a4,1378(a4) # 8003ffac <sb+0xc>
    80003a52:	4785                	li	a5,1
    80003a54:	04e7fa63          	bgeu	a5,a4,80003aa8 <ialloc+0x74>
    80003a58:	8aaa                	mv	s5,a0
    80003a5a:	8bae                	mv	s7,a1
    80003a5c:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003a5e:	0003ca17          	auipc	s4,0x3c
    80003a62:	542a0a13          	addi	s4,s4,1346 # 8003ffa0 <sb>
    80003a66:	00048b1b          	sext.w	s6,s1
    80003a6a:	0044d793          	srli	a5,s1,0x4
    80003a6e:	018a2583          	lw	a1,24(s4)
    80003a72:	9dbd                	addw	a1,a1,a5
    80003a74:	8556                	mv	a0,s5
    80003a76:	00000097          	auipc	ra,0x0
    80003a7a:	954080e7          	jalr	-1708(ra) # 800033ca <bread>
    80003a7e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003a80:	05850993          	addi	s3,a0,88
    80003a84:	00f4f793          	andi	a5,s1,15
    80003a88:	079a                	slli	a5,a5,0x6
    80003a8a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003a8c:	00099783          	lh	a5,0(s3)
    80003a90:	c785                	beqz	a5,80003ab8 <ialloc+0x84>
    brelse(bp);
    80003a92:	00000097          	auipc	ra,0x0
    80003a96:	a68080e7          	jalr	-1432(ra) # 800034fa <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003a9a:	0485                	addi	s1,s1,1
    80003a9c:	00ca2703          	lw	a4,12(s4)
    80003aa0:	0004879b          	sext.w	a5,s1
    80003aa4:	fce7e1e3          	bltu	a5,a4,80003a66 <ialloc+0x32>
  panic("ialloc: no inodes");
    80003aa8:	00005517          	auipc	a0,0x5
    80003aac:	bc850513          	addi	a0,a0,-1080 # 80008670 <syscalls+0x180>
    80003ab0:	ffffd097          	auipc	ra,0xffffd
    80003ab4:	b34080e7          	jalr	-1228(ra) # 800005e4 <panic>
      memset(dip, 0, sizeof(*dip));
    80003ab8:	04000613          	li	a2,64
    80003abc:	4581                	li	a1,0
    80003abe:	854e                	mv	a0,s3
    80003ac0:	ffffd097          	auipc	ra,0xffffd
    80003ac4:	5b6080e7          	jalr	1462(ra) # 80001076 <memset>
      dip->type = type;
    80003ac8:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003acc:	854a                	mv	a0,s2
    80003ace:	00001097          	auipc	ra,0x1
    80003ad2:	c94080e7          	jalr	-876(ra) # 80004762 <log_write>
      brelse(bp);
    80003ad6:	854a                	mv	a0,s2
    80003ad8:	00000097          	auipc	ra,0x0
    80003adc:	a22080e7          	jalr	-1502(ra) # 800034fa <brelse>
      return iget(dev, inum);
    80003ae0:	85da                	mv	a1,s6
    80003ae2:	8556                	mv	a0,s5
    80003ae4:	00000097          	auipc	ra,0x0
    80003ae8:	db4080e7          	jalr	-588(ra) # 80003898 <iget>
}
    80003aec:	60a6                	ld	ra,72(sp)
    80003aee:	6406                	ld	s0,64(sp)
    80003af0:	74e2                	ld	s1,56(sp)
    80003af2:	7942                	ld	s2,48(sp)
    80003af4:	79a2                	ld	s3,40(sp)
    80003af6:	7a02                	ld	s4,32(sp)
    80003af8:	6ae2                	ld	s5,24(sp)
    80003afa:	6b42                	ld	s6,16(sp)
    80003afc:	6ba2                	ld	s7,8(sp)
    80003afe:	6161                	addi	sp,sp,80
    80003b00:	8082                	ret

0000000080003b02 <iupdate>:
{
    80003b02:	1101                	addi	sp,sp,-32
    80003b04:	ec06                	sd	ra,24(sp)
    80003b06:	e822                	sd	s0,16(sp)
    80003b08:	e426                	sd	s1,8(sp)
    80003b0a:	e04a                	sd	s2,0(sp)
    80003b0c:	1000                	addi	s0,sp,32
    80003b0e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003b10:	415c                	lw	a5,4(a0)
    80003b12:	0047d79b          	srliw	a5,a5,0x4
    80003b16:	0003c597          	auipc	a1,0x3c
    80003b1a:	4a25a583          	lw	a1,1186(a1) # 8003ffb8 <sb+0x18>
    80003b1e:	9dbd                	addw	a1,a1,a5
    80003b20:	4108                	lw	a0,0(a0)
    80003b22:	00000097          	auipc	ra,0x0
    80003b26:	8a8080e7          	jalr	-1880(ra) # 800033ca <bread>
    80003b2a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003b2c:	05850793          	addi	a5,a0,88
    80003b30:	40c8                	lw	a0,4(s1)
    80003b32:	893d                	andi	a0,a0,15
    80003b34:	051a                	slli	a0,a0,0x6
    80003b36:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003b38:	04449703          	lh	a4,68(s1)
    80003b3c:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80003b40:	04649703          	lh	a4,70(s1)
    80003b44:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003b48:	04849703          	lh	a4,72(s1)
    80003b4c:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80003b50:	04a49703          	lh	a4,74(s1)
    80003b54:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80003b58:	44f8                	lw	a4,76(s1)
    80003b5a:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003b5c:	03400613          	li	a2,52
    80003b60:	05048593          	addi	a1,s1,80
    80003b64:	0531                	addi	a0,a0,12
    80003b66:	ffffd097          	auipc	ra,0xffffd
    80003b6a:	56c080e7          	jalr	1388(ra) # 800010d2 <memmove>
  log_write(bp);
    80003b6e:	854a                	mv	a0,s2
    80003b70:	00001097          	auipc	ra,0x1
    80003b74:	bf2080e7          	jalr	-1038(ra) # 80004762 <log_write>
  brelse(bp);
    80003b78:	854a                	mv	a0,s2
    80003b7a:	00000097          	auipc	ra,0x0
    80003b7e:	980080e7          	jalr	-1664(ra) # 800034fa <brelse>
}
    80003b82:	60e2                	ld	ra,24(sp)
    80003b84:	6442                	ld	s0,16(sp)
    80003b86:	64a2                	ld	s1,8(sp)
    80003b88:	6902                	ld	s2,0(sp)
    80003b8a:	6105                	addi	sp,sp,32
    80003b8c:	8082                	ret

0000000080003b8e <idup>:
{
    80003b8e:	1101                	addi	sp,sp,-32
    80003b90:	ec06                	sd	ra,24(sp)
    80003b92:	e822                	sd	s0,16(sp)
    80003b94:	e426                	sd	s1,8(sp)
    80003b96:	1000                	addi	s0,sp,32
    80003b98:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003b9a:	0003c517          	auipc	a0,0x3c
    80003b9e:	42650513          	addi	a0,a0,1062 # 8003ffc0 <icache>
    80003ba2:	ffffd097          	auipc	ra,0xffffd
    80003ba6:	3d8080e7          	jalr	984(ra) # 80000f7a <acquire>
  ip->ref++;
    80003baa:	449c                	lw	a5,8(s1)
    80003bac:	2785                	addiw	a5,a5,1
    80003bae:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003bb0:	0003c517          	auipc	a0,0x3c
    80003bb4:	41050513          	addi	a0,a0,1040 # 8003ffc0 <icache>
    80003bb8:	ffffd097          	auipc	ra,0xffffd
    80003bbc:	476080e7          	jalr	1142(ra) # 8000102e <release>
}
    80003bc0:	8526                	mv	a0,s1
    80003bc2:	60e2                	ld	ra,24(sp)
    80003bc4:	6442                	ld	s0,16(sp)
    80003bc6:	64a2                	ld	s1,8(sp)
    80003bc8:	6105                	addi	sp,sp,32
    80003bca:	8082                	ret

0000000080003bcc <ilock>:
{
    80003bcc:	1101                	addi	sp,sp,-32
    80003bce:	ec06                	sd	ra,24(sp)
    80003bd0:	e822                	sd	s0,16(sp)
    80003bd2:	e426                	sd	s1,8(sp)
    80003bd4:	e04a                	sd	s2,0(sp)
    80003bd6:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003bd8:	c115                	beqz	a0,80003bfc <ilock+0x30>
    80003bda:	84aa                	mv	s1,a0
    80003bdc:	451c                	lw	a5,8(a0)
    80003bde:	00f05f63          	blez	a5,80003bfc <ilock+0x30>
  acquiresleep(&ip->lock);
    80003be2:	0541                	addi	a0,a0,16
    80003be4:	00001097          	auipc	ra,0x1
    80003be8:	ca6080e7          	jalr	-858(ra) # 8000488a <acquiresleep>
  if(ip->valid == 0){
    80003bec:	40bc                	lw	a5,64(s1)
    80003bee:	cf99                	beqz	a5,80003c0c <ilock+0x40>
}
    80003bf0:	60e2                	ld	ra,24(sp)
    80003bf2:	6442                	ld	s0,16(sp)
    80003bf4:	64a2                	ld	s1,8(sp)
    80003bf6:	6902                	ld	s2,0(sp)
    80003bf8:	6105                	addi	sp,sp,32
    80003bfa:	8082                	ret
    panic("ilock");
    80003bfc:	00005517          	auipc	a0,0x5
    80003c00:	a8c50513          	addi	a0,a0,-1396 # 80008688 <syscalls+0x198>
    80003c04:	ffffd097          	auipc	ra,0xffffd
    80003c08:	9e0080e7          	jalr	-1568(ra) # 800005e4 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003c0c:	40dc                	lw	a5,4(s1)
    80003c0e:	0047d79b          	srliw	a5,a5,0x4
    80003c12:	0003c597          	auipc	a1,0x3c
    80003c16:	3a65a583          	lw	a1,934(a1) # 8003ffb8 <sb+0x18>
    80003c1a:	9dbd                	addw	a1,a1,a5
    80003c1c:	4088                	lw	a0,0(s1)
    80003c1e:	fffff097          	auipc	ra,0xfffff
    80003c22:	7ac080e7          	jalr	1964(ra) # 800033ca <bread>
    80003c26:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003c28:	05850593          	addi	a1,a0,88
    80003c2c:	40dc                	lw	a5,4(s1)
    80003c2e:	8bbd                	andi	a5,a5,15
    80003c30:	079a                	slli	a5,a5,0x6
    80003c32:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003c34:	00059783          	lh	a5,0(a1)
    80003c38:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003c3c:	00259783          	lh	a5,2(a1)
    80003c40:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003c44:	00459783          	lh	a5,4(a1)
    80003c48:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003c4c:	00659783          	lh	a5,6(a1)
    80003c50:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003c54:	459c                	lw	a5,8(a1)
    80003c56:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003c58:	03400613          	li	a2,52
    80003c5c:	05b1                	addi	a1,a1,12
    80003c5e:	05048513          	addi	a0,s1,80
    80003c62:	ffffd097          	auipc	ra,0xffffd
    80003c66:	470080e7          	jalr	1136(ra) # 800010d2 <memmove>
    brelse(bp);
    80003c6a:	854a                	mv	a0,s2
    80003c6c:	00000097          	auipc	ra,0x0
    80003c70:	88e080e7          	jalr	-1906(ra) # 800034fa <brelse>
    ip->valid = 1;
    80003c74:	4785                	li	a5,1
    80003c76:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003c78:	04449783          	lh	a5,68(s1)
    80003c7c:	fbb5                	bnez	a5,80003bf0 <ilock+0x24>
      panic("ilock: no type");
    80003c7e:	00005517          	auipc	a0,0x5
    80003c82:	a1250513          	addi	a0,a0,-1518 # 80008690 <syscalls+0x1a0>
    80003c86:	ffffd097          	auipc	ra,0xffffd
    80003c8a:	95e080e7          	jalr	-1698(ra) # 800005e4 <panic>

0000000080003c8e <iunlock>:
{
    80003c8e:	1101                	addi	sp,sp,-32
    80003c90:	ec06                	sd	ra,24(sp)
    80003c92:	e822                	sd	s0,16(sp)
    80003c94:	e426                	sd	s1,8(sp)
    80003c96:	e04a                	sd	s2,0(sp)
    80003c98:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003c9a:	c905                	beqz	a0,80003cca <iunlock+0x3c>
    80003c9c:	84aa                	mv	s1,a0
    80003c9e:	01050913          	addi	s2,a0,16
    80003ca2:	854a                	mv	a0,s2
    80003ca4:	00001097          	auipc	ra,0x1
    80003ca8:	c80080e7          	jalr	-896(ra) # 80004924 <holdingsleep>
    80003cac:	cd19                	beqz	a0,80003cca <iunlock+0x3c>
    80003cae:	449c                	lw	a5,8(s1)
    80003cb0:	00f05d63          	blez	a5,80003cca <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003cb4:	854a                	mv	a0,s2
    80003cb6:	00001097          	auipc	ra,0x1
    80003cba:	c2a080e7          	jalr	-982(ra) # 800048e0 <releasesleep>
}
    80003cbe:	60e2                	ld	ra,24(sp)
    80003cc0:	6442                	ld	s0,16(sp)
    80003cc2:	64a2                	ld	s1,8(sp)
    80003cc4:	6902                	ld	s2,0(sp)
    80003cc6:	6105                	addi	sp,sp,32
    80003cc8:	8082                	ret
    panic("iunlock");
    80003cca:	00005517          	auipc	a0,0x5
    80003cce:	9d650513          	addi	a0,a0,-1578 # 800086a0 <syscalls+0x1b0>
    80003cd2:	ffffd097          	auipc	ra,0xffffd
    80003cd6:	912080e7          	jalr	-1774(ra) # 800005e4 <panic>

0000000080003cda <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003cda:	7179                	addi	sp,sp,-48
    80003cdc:	f406                	sd	ra,40(sp)
    80003cde:	f022                	sd	s0,32(sp)
    80003ce0:	ec26                	sd	s1,24(sp)
    80003ce2:	e84a                	sd	s2,16(sp)
    80003ce4:	e44e                	sd	s3,8(sp)
    80003ce6:	e052                	sd	s4,0(sp)
    80003ce8:	1800                	addi	s0,sp,48
    80003cea:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003cec:	05050493          	addi	s1,a0,80
    80003cf0:	08050913          	addi	s2,a0,128
    80003cf4:	a021                	j	80003cfc <itrunc+0x22>
    80003cf6:	0491                	addi	s1,s1,4
    80003cf8:	01248d63          	beq	s1,s2,80003d12 <itrunc+0x38>
    if(ip->addrs[i]){
    80003cfc:	408c                	lw	a1,0(s1)
    80003cfe:	dde5                	beqz	a1,80003cf6 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003d00:	0009a503          	lw	a0,0(s3)
    80003d04:	00000097          	auipc	ra,0x0
    80003d08:	90c080e7          	jalr	-1780(ra) # 80003610 <bfree>
      ip->addrs[i] = 0;
    80003d0c:	0004a023          	sw	zero,0(s1)
    80003d10:	b7dd                	j	80003cf6 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003d12:	0809a583          	lw	a1,128(s3)
    80003d16:	e185                	bnez	a1,80003d36 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003d18:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003d1c:	854e                	mv	a0,s3
    80003d1e:	00000097          	auipc	ra,0x0
    80003d22:	de4080e7          	jalr	-540(ra) # 80003b02 <iupdate>
}
    80003d26:	70a2                	ld	ra,40(sp)
    80003d28:	7402                	ld	s0,32(sp)
    80003d2a:	64e2                	ld	s1,24(sp)
    80003d2c:	6942                	ld	s2,16(sp)
    80003d2e:	69a2                	ld	s3,8(sp)
    80003d30:	6a02                	ld	s4,0(sp)
    80003d32:	6145                	addi	sp,sp,48
    80003d34:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003d36:	0009a503          	lw	a0,0(s3)
    80003d3a:	fffff097          	auipc	ra,0xfffff
    80003d3e:	690080e7          	jalr	1680(ra) # 800033ca <bread>
    80003d42:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003d44:	05850493          	addi	s1,a0,88
    80003d48:	45850913          	addi	s2,a0,1112
    80003d4c:	a021                	j	80003d54 <itrunc+0x7a>
    80003d4e:	0491                	addi	s1,s1,4
    80003d50:	01248b63          	beq	s1,s2,80003d66 <itrunc+0x8c>
      if(a[j])
    80003d54:	408c                	lw	a1,0(s1)
    80003d56:	dde5                	beqz	a1,80003d4e <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003d58:	0009a503          	lw	a0,0(s3)
    80003d5c:	00000097          	auipc	ra,0x0
    80003d60:	8b4080e7          	jalr	-1868(ra) # 80003610 <bfree>
    80003d64:	b7ed                	j	80003d4e <itrunc+0x74>
    brelse(bp);
    80003d66:	8552                	mv	a0,s4
    80003d68:	fffff097          	auipc	ra,0xfffff
    80003d6c:	792080e7          	jalr	1938(ra) # 800034fa <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003d70:	0809a583          	lw	a1,128(s3)
    80003d74:	0009a503          	lw	a0,0(s3)
    80003d78:	00000097          	auipc	ra,0x0
    80003d7c:	898080e7          	jalr	-1896(ra) # 80003610 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003d80:	0809a023          	sw	zero,128(s3)
    80003d84:	bf51                	j	80003d18 <itrunc+0x3e>

0000000080003d86 <iput>:
{
    80003d86:	1101                	addi	sp,sp,-32
    80003d88:	ec06                	sd	ra,24(sp)
    80003d8a:	e822                	sd	s0,16(sp)
    80003d8c:	e426                	sd	s1,8(sp)
    80003d8e:	e04a                	sd	s2,0(sp)
    80003d90:	1000                	addi	s0,sp,32
    80003d92:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003d94:	0003c517          	auipc	a0,0x3c
    80003d98:	22c50513          	addi	a0,a0,556 # 8003ffc0 <icache>
    80003d9c:	ffffd097          	auipc	ra,0xffffd
    80003da0:	1de080e7          	jalr	478(ra) # 80000f7a <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003da4:	4498                	lw	a4,8(s1)
    80003da6:	4785                	li	a5,1
    80003da8:	02f70363          	beq	a4,a5,80003dce <iput+0x48>
  ip->ref--;
    80003dac:	449c                	lw	a5,8(s1)
    80003dae:	37fd                	addiw	a5,a5,-1
    80003db0:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003db2:	0003c517          	auipc	a0,0x3c
    80003db6:	20e50513          	addi	a0,a0,526 # 8003ffc0 <icache>
    80003dba:	ffffd097          	auipc	ra,0xffffd
    80003dbe:	274080e7          	jalr	628(ra) # 8000102e <release>
}
    80003dc2:	60e2                	ld	ra,24(sp)
    80003dc4:	6442                	ld	s0,16(sp)
    80003dc6:	64a2                	ld	s1,8(sp)
    80003dc8:	6902                	ld	s2,0(sp)
    80003dca:	6105                	addi	sp,sp,32
    80003dcc:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003dce:	40bc                	lw	a5,64(s1)
    80003dd0:	dff1                	beqz	a5,80003dac <iput+0x26>
    80003dd2:	04a49783          	lh	a5,74(s1)
    80003dd6:	fbf9                	bnez	a5,80003dac <iput+0x26>
    acquiresleep(&ip->lock);
    80003dd8:	01048913          	addi	s2,s1,16
    80003ddc:	854a                	mv	a0,s2
    80003dde:	00001097          	auipc	ra,0x1
    80003de2:	aac080e7          	jalr	-1364(ra) # 8000488a <acquiresleep>
    release(&icache.lock);
    80003de6:	0003c517          	auipc	a0,0x3c
    80003dea:	1da50513          	addi	a0,a0,474 # 8003ffc0 <icache>
    80003dee:	ffffd097          	auipc	ra,0xffffd
    80003df2:	240080e7          	jalr	576(ra) # 8000102e <release>
    itrunc(ip);
    80003df6:	8526                	mv	a0,s1
    80003df8:	00000097          	auipc	ra,0x0
    80003dfc:	ee2080e7          	jalr	-286(ra) # 80003cda <itrunc>
    ip->type = 0;
    80003e00:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003e04:	8526                	mv	a0,s1
    80003e06:	00000097          	auipc	ra,0x0
    80003e0a:	cfc080e7          	jalr	-772(ra) # 80003b02 <iupdate>
    ip->valid = 0;
    80003e0e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003e12:	854a                	mv	a0,s2
    80003e14:	00001097          	auipc	ra,0x1
    80003e18:	acc080e7          	jalr	-1332(ra) # 800048e0 <releasesleep>
    acquire(&icache.lock);
    80003e1c:	0003c517          	auipc	a0,0x3c
    80003e20:	1a450513          	addi	a0,a0,420 # 8003ffc0 <icache>
    80003e24:	ffffd097          	auipc	ra,0xffffd
    80003e28:	156080e7          	jalr	342(ra) # 80000f7a <acquire>
    80003e2c:	b741                	j	80003dac <iput+0x26>

0000000080003e2e <iunlockput>:
{
    80003e2e:	1101                	addi	sp,sp,-32
    80003e30:	ec06                	sd	ra,24(sp)
    80003e32:	e822                	sd	s0,16(sp)
    80003e34:	e426                	sd	s1,8(sp)
    80003e36:	1000                	addi	s0,sp,32
    80003e38:	84aa                	mv	s1,a0
  iunlock(ip);
    80003e3a:	00000097          	auipc	ra,0x0
    80003e3e:	e54080e7          	jalr	-428(ra) # 80003c8e <iunlock>
  iput(ip);
    80003e42:	8526                	mv	a0,s1
    80003e44:	00000097          	auipc	ra,0x0
    80003e48:	f42080e7          	jalr	-190(ra) # 80003d86 <iput>
}
    80003e4c:	60e2                	ld	ra,24(sp)
    80003e4e:	6442                	ld	s0,16(sp)
    80003e50:	64a2                	ld	s1,8(sp)
    80003e52:	6105                	addi	sp,sp,32
    80003e54:	8082                	ret

0000000080003e56 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003e56:	1141                	addi	sp,sp,-16
    80003e58:	e422                	sd	s0,8(sp)
    80003e5a:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003e5c:	411c                	lw	a5,0(a0)
    80003e5e:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003e60:	415c                	lw	a5,4(a0)
    80003e62:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003e64:	04451783          	lh	a5,68(a0)
    80003e68:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003e6c:	04a51783          	lh	a5,74(a0)
    80003e70:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003e74:	04c56783          	lwu	a5,76(a0)
    80003e78:	e99c                	sd	a5,16(a1)
}
    80003e7a:	6422                	ld	s0,8(sp)
    80003e7c:	0141                	addi	sp,sp,16
    80003e7e:	8082                	ret

0000000080003e80 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003e80:	457c                	lw	a5,76(a0)
    80003e82:	0ed7e963          	bltu	a5,a3,80003f74 <readi+0xf4>
{
    80003e86:	7159                	addi	sp,sp,-112
    80003e88:	f486                	sd	ra,104(sp)
    80003e8a:	f0a2                	sd	s0,96(sp)
    80003e8c:	eca6                	sd	s1,88(sp)
    80003e8e:	e8ca                	sd	s2,80(sp)
    80003e90:	e4ce                	sd	s3,72(sp)
    80003e92:	e0d2                	sd	s4,64(sp)
    80003e94:	fc56                	sd	s5,56(sp)
    80003e96:	f85a                	sd	s6,48(sp)
    80003e98:	f45e                	sd	s7,40(sp)
    80003e9a:	f062                	sd	s8,32(sp)
    80003e9c:	ec66                	sd	s9,24(sp)
    80003e9e:	e86a                	sd	s10,16(sp)
    80003ea0:	e46e                	sd	s11,8(sp)
    80003ea2:	1880                	addi	s0,sp,112
    80003ea4:	8baa                	mv	s7,a0
    80003ea6:	8c2e                	mv	s8,a1
    80003ea8:	8ab2                	mv	s5,a2
    80003eaa:	84b6                	mv	s1,a3
    80003eac:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003eae:	9f35                	addw	a4,a4,a3
    return 0;
    80003eb0:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003eb2:	0ad76063          	bltu	a4,a3,80003f52 <readi+0xd2>
  if(off + n > ip->size)
    80003eb6:	00e7f463          	bgeu	a5,a4,80003ebe <readi+0x3e>
    n = ip->size - off;
    80003eba:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003ebe:	0a0b0963          	beqz	s6,80003f70 <readi+0xf0>
    80003ec2:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003ec4:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003ec8:	5cfd                	li	s9,-1
    80003eca:	a82d                	j	80003f04 <readi+0x84>
    80003ecc:	020a1d93          	slli	s11,s4,0x20
    80003ed0:	020ddd93          	srli	s11,s11,0x20
    80003ed4:	05890793          	addi	a5,s2,88
    80003ed8:	86ee                	mv	a3,s11
    80003eda:	963e                	add	a2,a2,a5
    80003edc:	85d6                	mv	a1,s5
    80003ede:	8562                	mv	a0,s8
    80003ee0:	fffff097          	auipc	ra,0xfffff
    80003ee4:	a34080e7          	jalr	-1484(ra) # 80002914 <either_copyout>
    80003ee8:	05950d63          	beq	a0,s9,80003f42 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003eec:	854a                	mv	a0,s2
    80003eee:	fffff097          	auipc	ra,0xfffff
    80003ef2:	60c080e7          	jalr	1548(ra) # 800034fa <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003ef6:	013a09bb          	addw	s3,s4,s3
    80003efa:	009a04bb          	addw	s1,s4,s1
    80003efe:	9aee                	add	s5,s5,s11
    80003f00:	0569f763          	bgeu	s3,s6,80003f4e <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003f04:	000ba903          	lw	s2,0(s7)
    80003f08:	00a4d59b          	srliw	a1,s1,0xa
    80003f0c:	855e                	mv	a0,s7
    80003f0e:	00000097          	auipc	ra,0x0
    80003f12:	8b0080e7          	jalr	-1872(ra) # 800037be <bmap>
    80003f16:	0005059b          	sext.w	a1,a0
    80003f1a:	854a                	mv	a0,s2
    80003f1c:	fffff097          	auipc	ra,0xfffff
    80003f20:	4ae080e7          	jalr	1198(ra) # 800033ca <bread>
    80003f24:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003f26:	3ff4f613          	andi	a2,s1,1023
    80003f2a:	40cd07bb          	subw	a5,s10,a2
    80003f2e:	413b073b          	subw	a4,s6,s3
    80003f32:	8a3e                	mv	s4,a5
    80003f34:	2781                	sext.w	a5,a5
    80003f36:	0007069b          	sext.w	a3,a4
    80003f3a:	f8f6f9e3          	bgeu	a3,a5,80003ecc <readi+0x4c>
    80003f3e:	8a3a                	mv	s4,a4
    80003f40:	b771                	j	80003ecc <readi+0x4c>
      brelse(bp);
    80003f42:	854a                	mv	a0,s2
    80003f44:	fffff097          	auipc	ra,0xfffff
    80003f48:	5b6080e7          	jalr	1462(ra) # 800034fa <brelse>
      tot = -1;
    80003f4c:	59fd                	li	s3,-1
  }
  return tot;
    80003f4e:	0009851b          	sext.w	a0,s3
}
    80003f52:	70a6                	ld	ra,104(sp)
    80003f54:	7406                	ld	s0,96(sp)
    80003f56:	64e6                	ld	s1,88(sp)
    80003f58:	6946                	ld	s2,80(sp)
    80003f5a:	69a6                	ld	s3,72(sp)
    80003f5c:	6a06                	ld	s4,64(sp)
    80003f5e:	7ae2                	ld	s5,56(sp)
    80003f60:	7b42                	ld	s6,48(sp)
    80003f62:	7ba2                	ld	s7,40(sp)
    80003f64:	7c02                	ld	s8,32(sp)
    80003f66:	6ce2                	ld	s9,24(sp)
    80003f68:	6d42                	ld	s10,16(sp)
    80003f6a:	6da2                	ld	s11,8(sp)
    80003f6c:	6165                	addi	sp,sp,112
    80003f6e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003f70:	89da                	mv	s3,s6
    80003f72:	bff1                	j	80003f4e <readi+0xce>
    return 0;
    80003f74:	4501                	li	a0,0
}
    80003f76:	8082                	ret

0000000080003f78 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003f78:	457c                	lw	a5,76(a0)
    80003f7a:	10d7e763          	bltu	a5,a3,80004088 <writei+0x110>
{
    80003f7e:	7159                	addi	sp,sp,-112
    80003f80:	f486                	sd	ra,104(sp)
    80003f82:	f0a2                	sd	s0,96(sp)
    80003f84:	eca6                	sd	s1,88(sp)
    80003f86:	e8ca                	sd	s2,80(sp)
    80003f88:	e4ce                	sd	s3,72(sp)
    80003f8a:	e0d2                	sd	s4,64(sp)
    80003f8c:	fc56                	sd	s5,56(sp)
    80003f8e:	f85a                	sd	s6,48(sp)
    80003f90:	f45e                	sd	s7,40(sp)
    80003f92:	f062                	sd	s8,32(sp)
    80003f94:	ec66                	sd	s9,24(sp)
    80003f96:	e86a                	sd	s10,16(sp)
    80003f98:	e46e                	sd	s11,8(sp)
    80003f9a:	1880                	addi	s0,sp,112
    80003f9c:	8baa                	mv	s7,a0
    80003f9e:	8c2e                	mv	s8,a1
    80003fa0:	8ab2                	mv	s5,a2
    80003fa2:	8936                	mv	s2,a3
    80003fa4:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003fa6:	00e687bb          	addw	a5,a3,a4
    80003faa:	0ed7e163          	bltu	a5,a3,8000408c <writei+0x114>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003fae:	00043737          	lui	a4,0x43
    80003fb2:	0cf76f63          	bltu	a4,a5,80004090 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003fb6:	0a0b0863          	beqz	s6,80004066 <writei+0xee>
    80003fba:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003fbc:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003fc0:	5cfd                	li	s9,-1
    80003fc2:	a091                	j	80004006 <writei+0x8e>
    80003fc4:	02099d93          	slli	s11,s3,0x20
    80003fc8:	020ddd93          	srli	s11,s11,0x20
    80003fcc:	05848793          	addi	a5,s1,88
    80003fd0:	86ee                	mv	a3,s11
    80003fd2:	8656                	mv	a2,s5
    80003fd4:	85e2                	mv	a1,s8
    80003fd6:	953e                	add	a0,a0,a5
    80003fd8:	fffff097          	auipc	ra,0xfffff
    80003fdc:	992080e7          	jalr	-1646(ra) # 8000296a <either_copyin>
    80003fe0:	07950263          	beq	a0,s9,80004044 <writei+0xcc>
      brelse(bp);
      n = -1;
      break;
    }
    log_write(bp);
    80003fe4:	8526                	mv	a0,s1
    80003fe6:	00000097          	auipc	ra,0x0
    80003fea:	77c080e7          	jalr	1916(ra) # 80004762 <log_write>
    brelse(bp);
    80003fee:	8526                	mv	a0,s1
    80003ff0:	fffff097          	auipc	ra,0xfffff
    80003ff4:	50a080e7          	jalr	1290(ra) # 800034fa <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003ff8:	01498a3b          	addw	s4,s3,s4
    80003ffc:	0129893b          	addw	s2,s3,s2
    80004000:	9aee                	add	s5,s5,s11
    80004002:	056a7763          	bgeu	s4,s6,80004050 <writei+0xd8>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80004006:	000ba483          	lw	s1,0(s7)
    8000400a:	00a9559b          	srliw	a1,s2,0xa
    8000400e:	855e                	mv	a0,s7
    80004010:	fffff097          	auipc	ra,0xfffff
    80004014:	7ae080e7          	jalr	1966(ra) # 800037be <bmap>
    80004018:	0005059b          	sext.w	a1,a0
    8000401c:	8526                	mv	a0,s1
    8000401e:	fffff097          	auipc	ra,0xfffff
    80004022:	3ac080e7          	jalr	940(ra) # 800033ca <bread>
    80004026:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004028:	3ff97513          	andi	a0,s2,1023
    8000402c:	40ad07bb          	subw	a5,s10,a0
    80004030:	414b073b          	subw	a4,s6,s4
    80004034:	89be                	mv	s3,a5
    80004036:	2781                	sext.w	a5,a5
    80004038:	0007069b          	sext.w	a3,a4
    8000403c:	f8f6f4e3          	bgeu	a3,a5,80003fc4 <writei+0x4c>
    80004040:	89ba                	mv	s3,a4
    80004042:	b749                	j	80003fc4 <writei+0x4c>
      brelse(bp);
    80004044:	8526                	mv	a0,s1
    80004046:	fffff097          	auipc	ra,0xfffff
    8000404a:	4b4080e7          	jalr	1204(ra) # 800034fa <brelse>
      n = -1;
    8000404e:	5b7d                	li	s6,-1
  }

  if(n > 0){
    if(off > ip->size)
    80004050:	04cba783          	lw	a5,76(s7)
    80004054:	0127f463          	bgeu	a5,s2,8000405c <writei+0xe4>
      ip->size = off;
    80004058:	052ba623          	sw	s2,76(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    8000405c:	855e                	mv	a0,s7
    8000405e:	00000097          	auipc	ra,0x0
    80004062:	aa4080e7          	jalr	-1372(ra) # 80003b02 <iupdate>
  }

  return n;
    80004066:	000b051b          	sext.w	a0,s6
}
    8000406a:	70a6                	ld	ra,104(sp)
    8000406c:	7406                	ld	s0,96(sp)
    8000406e:	64e6                	ld	s1,88(sp)
    80004070:	6946                	ld	s2,80(sp)
    80004072:	69a6                	ld	s3,72(sp)
    80004074:	6a06                	ld	s4,64(sp)
    80004076:	7ae2                	ld	s5,56(sp)
    80004078:	7b42                	ld	s6,48(sp)
    8000407a:	7ba2                	ld	s7,40(sp)
    8000407c:	7c02                	ld	s8,32(sp)
    8000407e:	6ce2                	ld	s9,24(sp)
    80004080:	6d42                	ld	s10,16(sp)
    80004082:	6da2                	ld	s11,8(sp)
    80004084:	6165                	addi	sp,sp,112
    80004086:	8082                	ret
    return -1;
    80004088:	557d                	li	a0,-1
}
    8000408a:	8082                	ret
    return -1;
    8000408c:	557d                	li	a0,-1
    8000408e:	bff1                	j	8000406a <writei+0xf2>
    return -1;
    80004090:	557d                	li	a0,-1
    80004092:	bfe1                	j	8000406a <writei+0xf2>

0000000080004094 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80004094:	1141                	addi	sp,sp,-16
    80004096:	e406                	sd	ra,8(sp)
    80004098:	e022                	sd	s0,0(sp)
    8000409a:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000409c:	4639                	li	a2,14
    8000409e:	ffffd097          	auipc	ra,0xffffd
    800040a2:	0b0080e7          	jalr	176(ra) # 8000114e <strncmp>
}
    800040a6:	60a2                	ld	ra,8(sp)
    800040a8:	6402                	ld	s0,0(sp)
    800040aa:	0141                	addi	sp,sp,16
    800040ac:	8082                	ret

00000000800040ae <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800040ae:	7139                	addi	sp,sp,-64
    800040b0:	fc06                	sd	ra,56(sp)
    800040b2:	f822                	sd	s0,48(sp)
    800040b4:	f426                	sd	s1,40(sp)
    800040b6:	f04a                	sd	s2,32(sp)
    800040b8:	ec4e                	sd	s3,24(sp)
    800040ba:	e852                	sd	s4,16(sp)
    800040bc:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800040be:	04451703          	lh	a4,68(a0)
    800040c2:	4785                	li	a5,1
    800040c4:	00f71a63          	bne	a4,a5,800040d8 <dirlookup+0x2a>
    800040c8:	892a                	mv	s2,a0
    800040ca:	89ae                	mv	s3,a1
    800040cc:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800040ce:	457c                	lw	a5,76(a0)
    800040d0:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800040d2:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800040d4:	e79d                	bnez	a5,80004102 <dirlookup+0x54>
    800040d6:	a8a5                	j	8000414e <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800040d8:	00004517          	auipc	a0,0x4
    800040dc:	5d050513          	addi	a0,a0,1488 # 800086a8 <syscalls+0x1b8>
    800040e0:	ffffc097          	auipc	ra,0xffffc
    800040e4:	504080e7          	jalr	1284(ra) # 800005e4 <panic>
      panic("dirlookup read");
    800040e8:	00004517          	auipc	a0,0x4
    800040ec:	5d850513          	addi	a0,a0,1496 # 800086c0 <syscalls+0x1d0>
    800040f0:	ffffc097          	auipc	ra,0xffffc
    800040f4:	4f4080e7          	jalr	1268(ra) # 800005e4 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800040f8:	24c1                	addiw	s1,s1,16
    800040fa:	04c92783          	lw	a5,76(s2)
    800040fe:	04f4f763          	bgeu	s1,a5,8000414c <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004102:	4741                	li	a4,16
    80004104:	86a6                	mv	a3,s1
    80004106:	fc040613          	addi	a2,s0,-64
    8000410a:	4581                	li	a1,0
    8000410c:	854a                	mv	a0,s2
    8000410e:	00000097          	auipc	ra,0x0
    80004112:	d72080e7          	jalr	-654(ra) # 80003e80 <readi>
    80004116:	47c1                	li	a5,16
    80004118:	fcf518e3          	bne	a0,a5,800040e8 <dirlookup+0x3a>
    if(de.inum == 0)
    8000411c:	fc045783          	lhu	a5,-64(s0)
    80004120:	dfe1                	beqz	a5,800040f8 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80004122:	fc240593          	addi	a1,s0,-62
    80004126:	854e                	mv	a0,s3
    80004128:	00000097          	auipc	ra,0x0
    8000412c:	f6c080e7          	jalr	-148(ra) # 80004094 <namecmp>
    80004130:	f561                	bnez	a0,800040f8 <dirlookup+0x4a>
      if(poff)
    80004132:	000a0463          	beqz	s4,8000413a <dirlookup+0x8c>
        *poff = off;
    80004136:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000413a:	fc045583          	lhu	a1,-64(s0)
    8000413e:	00092503          	lw	a0,0(s2)
    80004142:	fffff097          	auipc	ra,0xfffff
    80004146:	756080e7          	jalr	1878(ra) # 80003898 <iget>
    8000414a:	a011                	j	8000414e <dirlookup+0xa0>
  return 0;
    8000414c:	4501                	li	a0,0
}
    8000414e:	70e2                	ld	ra,56(sp)
    80004150:	7442                	ld	s0,48(sp)
    80004152:	74a2                	ld	s1,40(sp)
    80004154:	7902                	ld	s2,32(sp)
    80004156:	69e2                	ld	s3,24(sp)
    80004158:	6a42                	ld	s4,16(sp)
    8000415a:	6121                	addi	sp,sp,64
    8000415c:	8082                	ret

000000008000415e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000415e:	711d                	addi	sp,sp,-96
    80004160:	ec86                	sd	ra,88(sp)
    80004162:	e8a2                	sd	s0,80(sp)
    80004164:	e4a6                	sd	s1,72(sp)
    80004166:	e0ca                	sd	s2,64(sp)
    80004168:	fc4e                	sd	s3,56(sp)
    8000416a:	f852                	sd	s4,48(sp)
    8000416c:	f456                	sd	s5,40(sp)
    8000416e:	f05a                	sd	s6,32(sp)
    80004170:	ec5e                	sd	s7,24(sp)
    80004172:	e862                	sd	s8,16(sp)
    80004174:	e466                	sd	s9,8(sp)
    80004176:	1080                	addi	s0,sp,96
    80004178:	84aa                	mv	s1,a0
    8000417a:	8aae                	mv	s5,a1
    8000417c:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000417e:	00054703          	lbu	a4,0(a0)
    80004182:	02f00793          	li	a5,47
    80004186:	02f70363          	beq	a4,a5,800041ac <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000418a:	ffffe097          	auipc	ra,0xffffe
    8000418e:	d1c080e7          	jalr	-740(ra) # 80001ea6 <myproc>
    80004192:	15053503          	ld	a0,336(a0)
    80004196:	00000097          	auipc	ra,0x0
    8000419a:	9f8080e7          	jalr	-1544(ra) # 80003b8e <idup>
    8000419e:	89aa                	mv	s3,a0
  while(*path == '/')
    800041a0:	02f00913          	li	s2,47
  len = path - s;
    800041a4:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    800041a6:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800041a8:	4b85                	li	s7,1
    800041aa:	a865                	j	80004262 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800041ac:	4585                	li	a1,1
    800041ae:	4505                	li	a0,1
    800041b0:	fffff097          	auipc	ra,0xfffff
    800041b4:	6e8080e7          	jalr	1768(ra) # 80003898 <iget>
    800041b8:	89aa                	mv	s3,a0
    800041ba:	b7dd                	j	800041a0 <namex+0x42>
      iunlockput(ip);
    800041bc:	854e                	mv	a0,s3
    800041be:	00000097          	auipc	ra,0x0
    800041c2:	c70080e7          	jalr	-912(ra) # 80003e2e <iunlockput>
      return 0;
    800041c6:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800041c8:	854e                	mv	a0,s3
    800041ca:	60e6                	ld	ra,88(sp)
    800041cc:	6446                	ld	s0,80(sp)
    800041ce:	64a6                	ld	s1,72(sp)
    800041d0:	6906                	ld	s2,64(sp)
    800041d2:	79e2                	ld	s3,56(sp)
    800041d4:	7a42                	ld	s4,48(sp)
    800041d6:	7aa2                	ld	s5,40(sp)
    800041d8:	7b02                	ld	s6,32(sp)
    800041da:	6be2                	ld	s7,24(sp)
    800041dc:	6c42                	ld	s8,16(sp)
    800041de:	6ca2                	ld	s9,8(sp)
    800041e0:	6125                	addi	sp,sp,96
    800041e2:	8082                	ret
      iunlock(ip);
    800041e4:	854e                	mv	a0,s3
    800041e6:	00000097          	auipc	ra,0x0
    800041ea:	aa8080e7          	jalr	-1368(ra) # 80003c8e <iunlock>
      return ip;
    800041ee:	bfe9                	j	800041c8 <namex+0x6a>
      iunlockput(ip);
    800041f0:	854e                	mv	a0,s3
    800041f2:	00000097          	auipc	ra,0x0
    800041f6:	c3c080e7          	jalr	-964(ra) # 80003e2e <iunlockput>
      return 0;
    800041fa:	89e6                	mv	s3,s9
    800041fc:	b7f1                	j	800041c8 <namex+0x6a>
  len = path - s;
    800041fe:	40b48633          	sub	a2,s1,a1
    80004202:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80004206:	099c5463          	bge	s8,s9,8000428e <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000420a:	4639                	li	a2,14
    8000420c:	8552                	mv	a0,s4
    8000420e:	ffffd097          	auipc	ra,0xffffd
    80004212:	ec4080e7          	jalr	-316(ra) # 800010d2 <memmove>
  while(*path == '/')
    80004216:	0004c783          	lbu	a5,0(s1)
    8000421a:	01279763          	bne	a5,s2,80004228 <namex+0xca>
    path++;
    8000421e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004220:	0004c783          	lbu	a5,0(s1)
    80004224:	ff278de3          	beq	a5,s2,8000421e <namex+0xc0>
    ilock(ip);
    80004228:	854e                	mv	a0,s3
    8000422a:	00000097          	auipc	ra,0x0
    8000422e:	9a2080e7          	jalr	-1630(ra) # 80003bcc <ilock>
    if(ip->type != T_DIR){
    80004232:	04499783          	lh	a5,68(s3)
    80004236:	f97793e3          	bne	a5,s7,800041bc <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000423a:	000a8563          	beqz	s5,80004244 <namex+0xe6>
    8000423e:	0004c783          	lbu	a5,0(s1)
    80004242:	d3cd                	beqz	a5,800041e4 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004244:	865a                	mv	a2,s6
    80004246:	85d2                	mv	a1,s4
    80004248:	854e                	mv	a0,s3
    8000424a:	00000097          	auipc	ra,0x0
    8000424e:	e64080e7          	jalr	-412(ra) # 800040ae <dirlookup>
    80004252:	8caa                	mv	s9,a0
    80004254:	dd51                	beqz	a0,800041f0 <namex+0x92>
    iunlockput(ip);
    80004256:	854e                	mv	a0,s3
    80004258:	00000097          	auipc	ra,0x0
    8000425c:	bd6080e7          	jalr	-1066(ra) # 80003e2e <iunlockput>
    ip = next;
    80004260:	89e6                	mv	s3,s9
  while(*path == '/')
    80004262:	0004c783          	lbu	a5,0(s1)
    80004266:	05279763          	bne	a5,s2,800042b4 <namex+0x156>
    path++;
    8000426a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000426c:	0004c783          	lbu	a5,0(s1)
    80004270:	ff278de3          	beq	a5,s2,8000426a <namex+0x10c>
  if(*path == 0)
    80004274:	c79d                	beqz	a5,800042a2 <namex+0x144>
    path++;
    80004276:	85a6                	mv	a1,s1
  len = path - s;
    80004278:	8cda                	mv	s9,s6
    8000427a:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    8000427c:	01278963          	beq	a5,s2,8000428e <namex+0x130>
    80004280:	dfbd                	beqz	a5,800041fe <namex+0xa0>
    path++;
    80004282:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80004284:	0004c783          	lbu	a5,0(s1)
    80004288:	ff279ce3          	bne	a5,s2,80004280 <namex+0x122>
    8000428c:	bf8d                	j	800041fe <namex+0xa0>
    memmove(name, s, len);
    8000428e:	2601                	sext.w	a2,a2
    80004290:	8552                	mv	a0,s4
    80004292:	ffffd097          	auipc	ra,0xffffd
    80004296:	e40080e7          	jalr	-448(ra) # 800010d2 <memmove>
    name[len] = 0;
    8000429a:	9cd2                	add	s9,s9,s4
    8000429c:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800042a0:	bf9d                	j	80004216 <namex+0xb8>
  if(nameiparent){
    800042a2:	f20a83e3          	beqz	s5,800041c8 <namex+0x6a>
    iput(ip);
    800042a6:	854e                	mv	a0,s3
    800042a8:	00000097          	auipc	ra,0x0
    800042ac:	ade080e7          	jalr	-1314(ra) # 80003d86 <iput>
    return 0;
    800042b0:	4981                	li	s3,0
    800042b2:	bf19                	j	800041c8 <namex+0x6a>
  if(*path == 0)
    800042b4:	d7fd                	beqz	a5,800042a2 <namex+0x144>
  while(*path != '/' && *path != 0)
    800042b6:	0004c783          	lbu	a5,0(s1)
    800042ba:	85a6                	mv	a1,s1
    800042bc:	b7d1                	j	80004280 <namex+0x122>

00000000800042be <dirlink>:
{
    800042be:	7139                	addi	sp,sp,-64
    800042c0:	fc06                	sd	ra,56(sp)
    800042c2:	f822                	sd	s0,48(sp)
    800042c4:	f426                	sd	s1,40(sp)
    800042c6:	f04a                	sd	s2,32(sp)
    800042c8:	ec4e                	sd	s3,24(sp)
    800042ca:	e852                	sd	s4,16(sp)
    800042cc:	0080                	addi	s0,sp,64
    800042ce:	892a                	mv	s2,a0
    800042d0:	8a2e                	mv	s4,a1
    800042d2:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800042d4:	4601                	li	a2,0
    800042d6:	00000097          	auipc	ra,0x0
    800042da:	dd8080e7          	jalr	-552(ra) # 800040ae <dirlookup>
    800042de:	e93d                	bnez	a0,80004354 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800042e0:	04c92483          	lw	s1,76(s2)
    800042e4:	c49d                	beqz	s1,80004312 <dirlink+0x54>
    800042e6:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800042e8:	4741                	li	a4,16
    800042ea:	86a6                	mv	a3,s1
    800042ec:	fc040613          	addi	a2,s0,-64
    800042f0:	4581                	li	a1,0
    800042f2:	854a                	mv	a0,s2
    800042f4:	00000097          	auipc	ra,0x0
    800042f8:	b8c080e7          	jalr	-1140(ra) # 80003e80 <readi>
    800042fc:	47c1                	li	a5,16
    800042fe:	06f51163          	bne	a0,a5,80004360 <dirlink+0xa2>
    if(de.inum == 0)
    80004302:	fc045783          	lhu	a5,-64(s0)
    80004306:	c791                	beqz	a5,80004312 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004308:	24c1                	addiw	s1,s1,16
    8000430a:	04c92783          	lw	a5,76(s2)
    8000430e:	fcf4ede3          	bltu	s1,a5,800042e8 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80004312:	4639                	li	a2,14
    80004314:	85d2                	mv	a1,s4
    80004316:	fc240513          	addi	a0,s0,-62
    8000431a:	ffffd097          	auipc	ra,0xffffd
    8000431e:	e70080e7          	jalr	-400(ra) # 8000118a <strncpy>
  de.inum = inum;
    80004322:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004326:	4741                	li	a4,16
    80004328:	86a6                	mv	a3,s1
    8000432a:	fc040613          	addi	a2,s0,-64
    8000432e:	4581                	li	a1,0
    80004330:	854a                	mv	a0,s2
    80004332:	00000097          	auipc	ra,0x0
    80004336:	c46080e7          	jalr	-954(ra) # 80003f78 <writei>
    8000433a:	872a                	mv	a4,a0
    8000433c:	47c1                	li	a5,16
  return 0;
    8000433e:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004340:	02f71863          	bne	a4,a5,80004370 <dirlink+0xb2>
}
    80004344:	70e2                	ld	ra,56(sp)
    80004346:	7442                	ld	s0,48(sp)
    80004348:	74a2                	ld	s1,40(sp)
    8000434a:	7902                	ld	s2,32(sp)
    8000434c:	69e2                	ld	s3,24(sp)
    8000434e:	6a42                	ld	s4,16(sp)
    80004350:	6121                	addi	sp,sp,64
    80004352:	8082                	ret
    iput(ip);
    80004354:	00000097          	auipc	ra,0x0
    80004358:	a32080e7          	jalr	-1486(ra) # 80003d86 <iput>
    return -1;
    8000435c:	557d                	li	a0,-1
    8000435e:	b7dd                	j	80004344 <dirlink+0x86>
      panic("dirlink read");
    80004360:	00004517          	auipc	a0,0x4
    80004364:	37050513          	addi	a0,a0,880 # 800086d0 <syscalls+0x1e0>
    80004368:	ffffc097          	auipc	ra,0xffffc
    8000436c:	27c080e7          	jalr	636(ra) # 800005e4 <panic>
    panic("dirlink");
    80004370:	00004517          	auipc	a0,0x4
    80004374:	48050513          	addi	a0,a0,1152 # 800087f0 <syscalls+0x300>
    80004378:	ffffc097          	auipc	ra,0xffffc
    8000437c:	26c080e7          	jalr	620(ra) # 800005e4 <panic>

0000000080004380 <namei>:

struct inode*
namei(char *path)
{
    80004380:	1101                	addi	sp,sp,-32
    80004382:	ec06                	sd	ra,24(sp)
    80004384:	e822                	sd	s0,16(sp)
    80004386:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004388:	fe040613          	addi	a2,s0,-32
    8000438c:	4581                	li	a1,0
    8000438e:	00000097          	auipc	ra,0x0
    80004392:	dd0080e7          	jalr	-560(ra) # 8000415e <namex>
}
    80004396:	60e2                	ld	ra,24(sp)
    80004398:	6442                	ld	s0,16(sp)
    8000439a:	6105                	addi	sp,sp,32
    8000439c:	8082                	ret

000000008000439e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000439e:	1141                	addi	sp,sp,-16
    800043a0:	e406                	sd	ra,8(sp)
    800043a2:	e022                	sd	s0,0(sp)
    800043a4:	0800                	addi	s0,sp,16
    800043a6:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800043a8:	4585                	li	a1,1
    800043aa:	00000097          	auipc	ra,0x0
    800043ae:	db4080e7          	jalr	-588(ra) # 8000415e <namex>
}
    800043b2:	60a2                	ld	ra,8(sp)
    800043b4:	6402                	ld	s0,0(sp)
    800043b6:	0141                	addi	sp,sp,16
    800043b8:	8082                	ret

00000000800043ba <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800043ba:	1101                	addi	sp,sp,-32
    800043bc:	ec06                	sd	ra,24(sp)
    800043be:	e822                	sd	s0,16(sp)
    800043c0:	e426                	sd	s1,8(sp)
    800043c2:	e04a                	sd	s2,0(sp)
    800043c4:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800043c6:	0003d917          	auipc	s2,0x3d
    800043ca:	6a290913          	addi	s2,s2,1698 # 80041a68 <log>
    800043ce:	01892583          	lw	a1,24(s2)
    800043d2:	02892503          	lw	a0,40(s2)
    800043d6:	fffff097          	auipc	ra,0xfffff
    800043da:	ff4080e7          	jalr	-12(ra) # 800033ca <bread>
    800043de:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800043e0:	02c92683          	lw	a3,44(s2)
    800043e4:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800043e6:	02d05763          	blez	a3,80004414 <write_head+0x5a>
    800043ea:	0003d797          	auipc	a5,0x3d
    800043ee:	6ae78793          	addi	a5,a5,1710 # 80041a98 <log+0x30>
    800043f2:	05c50713          	addi	a4,a0,92
    800043f6:	36fd                	addiw	a3,a3,-1
    800043f8:	1682                	slli	a3,a3,0x20
    800043fa:	9281                	srli	a3,a3,0x20
    800043fc:	068a                	slli	a3,a3,0x2
    800043fe:	0003d617          	auipc	a2,0x3d
    80004402:	69e60613          	addi	a2,a2,1694 # 80041a9c <log+0x34>
    80004406:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80004408:	4390                	lw	a2,0(a5)
    8000440a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000440c:	0791                	addi	a5,a5,4
    8000440e:	0711                	addi	a4,a4,4
    80004410:	fed79ce3          	bne	a5,a3,80004408 <write_head+0x4e>
  }
  bwrite(buf);
    80004414:	8526                	mv	a0,s1
    80004416:	fffff097          	auipc	ra,0xfffff
    8000441a:	0a6080e7          	jalr	166(ra) # 800034bc <bwrite>
  brelse(buf);
    8000441e:	8526                	mv	a0,s1
    80004420:	fffff097          	auipc	ra,0xfffff
    80004424:	0da080e7          	jalr	218(ra) # 800034fa <brelse>
}
    80004428:	60e2                	ld	ra,24(sp)
    8000442a:	6442                	ld	s0,16(sp)
    8000442c:	64a2                	ld	s1,8(sp)
    8000442e:	6902                	ld	s2,0(sp)
    80004430:	6105                	addi	sp,sp,32
    80004432:	8082                	ret

0000000080004434 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004434:	0003d797          	auipc	a5,0x3d
    80004438:	6607a783          	lw	a5,1632(a5) # 80041a94 <log+0x2c>
    8000443c:	0af05663          	blez	a5,800044e8 <install_trans+0xb4>
{
    80004440:	7139                	addi	sp,sp,-64
    80004442:	fc06                	sd	ra,56(sp)
    80004444:	f822                	sd	s0,48(sp)
    80004446:	f426                	sd	s1,40(sp)
    80004448:	f04a                	sd	s2,32(sp)
    8000444a:	ec4e                	sd	s3,24(sp)
    8000444c:	e852                	sd	s4,16(sp)
    8000444e:	e456                	sd	s5,8(sp)
    80004450:	0080                	addi	s0,sp,64
    80004452:	0003da97          	auipc	s5,0x3d
    80004456:	646a8a93          	addi	s5,s5,1606 # 80041a98 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000445a:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000445c:	0003d997          	auipc	s3,0x3d
    80004460:	60c98993          	addi	s3,s3,1548 # 80041a68 <log>
    80004464:	0189a583          	lw	a1,24(s3)
    80004468:	014585bb          	addw	a1,a1,s4
    8000446c:	2585                	addiw	a1,a1,1
    8000446e:	0289a503          	lw	a0,40(s3)
    80004472:	fffff097          	auipc	ra,0xfffff
    80004476:	f58080e7          	jalr	-168(ra) # 800033ca <bread>
    8000447a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000447c:	000aa583          	lw	a1,0(s5)
    80004480:	0289a503          	lw	a0,40(s3)
    80004484:	fffff097          	auipc	ra,0xfffff
    80004488:	f46080e7          	jalr	-186(ra) # 800033ca <bread>
    8000448c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000448e:	40000613          	li	a2,1024
    80004492:	05890593          	addi	a1,s2,88
    80004496:	05850513          	addi	a0,a0,88
    8000449a:	ffffd097          	auipc	ra,0xffffd
    8000449e:	c38080e7          	jalr	-968(ra) # 800010d2 <memmove>
    bwrite(dbuf);  // write dst to disk
    800044a2:	8526                	mv	a0,s1
    800044a4:	fffff097          	auipc	ra,0xfffff
    800044a8:	018080e7          	jalr	24(ra) # 800034bc <bwrite>
    bunpin(dbuf);
    800044ac:	8526                	mv	a0,s1
    800044ae:	fffff097          	auipc	ra,0xfffff
    800044b2:	126080e7          	jalr	294(ra) # 800035d4 <bunpin>
    brelse(lbuf);
    800044b6:	854a                	mv	a0,s2
    800044b8:	fffff097          	auipc	ra,0xfffff
    800044bc:	042080e7          	jalr	66(ra) # 800034fa <brelse>
    brelse(dbuf);
    800044c0:	8526                	mv	a0,s1
    800044c2:	fffff097          	auipc	ra,0xfffff
    800044c6:	038080e7          	jalr	56(ra) # 800034fa <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800044ca:	2a05                	addiw	s4,s4,1
    800044cc:	0a91                	addi	s5,s5,4
    800044ce:	02c9a783          	lw	a5,44(s3)
    800044d2:	f8fa49e3          	blt	s4,a5,80004464 <install_trans+0x30>
}
    800044d6:	70e2                	ld	ra,56(sp)
    800044d8:	7442                	ld	s0,48(sp)
    800044da:	74a2                	ld	s1,40(sp)
    800044dc:	7902                	ld	s2,32(sp)
    800044de:	69e2                	ld	s3,24(sp)
    800044e0:	6a42                	ld	s4,16(sp)
    800044e2:	6aa2                	ld	s5,8(sp)
    800044e4:	6121                	addi	sp,sp,64
    800044e6:	8082                	ret
    800044e8:	8082                	ret

00000000800044ea <initlog>:
{
    800044ea:	7179                	addi	sp,sp,-48
    800044ec:	f406                	sd	ra,40(sp)
    800044ee:	f022                	sd	s0,32(sp)
    800044f0:	ec26                	sd	s1,24(sp)
    800044f2:	e84a                	sd	s2,16(sp)
    800044f4:	e44e                	sd	s3,8(sp)
    800044f6:	1800                	addi	s0,sp,48
    800044f8:	892a                	mv	s2,a0
    800044fa:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800044fc:	0003d497          	auipc	s1,0x3d
    80004500:	56c48493          	addi	s1,s1,1388 # 80041a68 <log>
    80004504:	00004597          	auipc	a1,0x4
    80004508:	1dc58593          	addi	a1,a1,476 # 800086e0 <syscalls+0x1f0>
    8000450c:	8526                	mv	a0,s1
    8000450e:	ffffd097          	auipc	ra,0xffffd
    80004512:	9dc080e7          	jalr	-1572(ra) # 80000eea <initlock>
  log.start = sb->logstart;
    80004516:	0149a583          	lw	a1,20(s3)
    8000451a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000451c:	0109a783          	lw	a5,16(s3)
    80004520:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004522:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004526:	854a                	mv	a0,s2
    80004528:	fffff097          	auipc	ra,0xfffff
    8000452c:	ea2080e7          	jalr	-350(ra) # 800033ca <bread>
  log.lh.n = lh->n;
    80004530:	4d34                	lw	a3,88(a0)
    80004532:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004534:	02d05563          	blez	a3,8000455e <initlog+0x74>
    80004538:	05c50793          	addi	a5,a0,92
    8000453c:	0003d717          	auipc	a4,0x3d
    80004540:	55c70713          	addi	a4,a4,1372 # 80041a98 <log+0x30>
    80004544:	36fd                	addiw	a3,a3,-1
    80004546:	1682                	slli	a3,a3,0x20
    80004548:	9281                	srli	a3,a3,0x20
    8000454a:	068a                	slli	a3,a3,0x2
    8000454c:	06050613          	addi	a2,a0,96
    80004550:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80004552:	4390                	lw	a2,0(a5)
    80004554:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004556:	0791                	addi	a5,a5,4
    80004558:	0711                	addi	a4,a4,4
    8000455a:	fed79ce3          	bne	a5,a3,80004552 <initlog+0x68>
  brelse(buf);
    8000455e:	fffff097          	auipc	ra,0xfffff
    80004562:	f9c080e7          	jalr	-100(ra) # 800034fa <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
    80004566:	00000097          	auipc	ra,0x0
    8000456a:	ece080e7          	jalr	-306(ra) # 80004434 <install_trans>
  log.lh.n = 0;
    8000456e:	0003d797          	auipc	a5,0x3d
    80004572:	5207a323          	sw	zero,1318(a5) # 80041a94 <log+0x2c>
  write_head(); // clear the log
    80004576:	00000097          	auipc	ra,0x0
    8000457a:	e44080e7          	jalr	-444(ra) # 800043ba <write_head>
}
    8000457e:	70a2                	ld	ra,40(sp)
    80004580:	7402                	ld	s0,32(sp)
    80004582:	64e2                	ld	s1,24(sp)
    80004584:	6942                	ld	s2,16(sp)
    80004586:	69a2                	ld	s3,8(sp)
    80004588:	6145                	addi	sp,sp,48
    8000458a:	8082                	ret

000000008000458c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000458c:	1101                	addi	sp,sp,-32
    8000458e:	ec06                	sd	ra,24(sp)
    80004590:	e822                	sd	s0,16(sp)
    80004592:	e426                	sd	s1,8(sp)
    80004594:	e04a                	sd	s2,0(sp)
    80004596:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004598:	0003d517          	auipc	a0,0x3d
    8000459c:	4d050513          	addi	a0,a0,1232 # 80041a68 <log>
    800045a0:	ffffd097          	auipc	ra,0xffffd
    800045a4:	9da080e7          	jalr	-1574(ra) # 80000f7a <acquire>
  while(1){
    if(log.committing){
    800045a8:	0003d497          	auipc	s1,0x3d
    800045ac:	4c048493          	addi	s1,s1,1216 # 80041a68 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800045b0:	4979                	li	s2,30
    800045b2:	a039                	j	800045c0 <begin_op+0x34>
      sleep(&log, &log.lock);
    800045b4:	85a6                	mv	a1,s1
    800045b6:	8526                	mv	a0,s1
    800045b8:	ffffe097          	auipc	ra,0xffffe
    800045bc:	102080e7          	jalr	258(ra) # 800026ba <sleep>
    if(log.committing){
    800045c0:	50dc                	lw	a5,36(s1)
    800045c2:	fbed                	bnez	a5,800045b4 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800045c4:	509c                	lw	a5,32(s1)
    800045c6:	0017871b          	addiw	a4,a5,1
    800045ca:	0007069b          	sext.w	a3,a4
    800045ce:	0027179b          	slliw	a5,a4,0x2
    800045d2:	9fb9                	addw	a5,a5,a4
    800045d4:	0017979b          	slliw	a5,a5,0x1
    800045d8:	54d8                	lw	a4,44(s1)
    800045da:	9fb9                	addw	a5,a5,a4
    800045dc:	00f95963          	bge	s2,a5,800045ee <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800045e0:	85a6                	mv	a1,s1
    800045e2:	8526                	mv	a0,s1
    800045e4:	ffffe097          	auipc	ra,0xffffe
    800045e8:	0d6080e7          	jalr	214(ra) # 800026ba <sleep>
    800045ec:	bfd1                	j	800045c0 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800045ee:	0003d517          	auipc	a0,0x3d
    800045f2:	47a50513          	addi	a0,a0,1146 # 80041a68 <log>
    800045f6:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800045f8:	ffffd097          	auipc	ra,0xffffd
    800045fc:	a36080e7          	jalr	-1482(ra) # 8000102e <release>
      break;
    }
  }
}
    80004600:	60e2                	ld	ra,24(sp)
    80004602:	6442                	ld	s0,16(sp)
    80004604:	64a2                	ld	s1,8(sp)
    80004606:	6902                	ld	s2,0(sp)
    80004608:	6105                	addi	sp,sp,32
    8000460a:	8082                	ret

000000008000460c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000460c:	7139                	addi	sp,sp,-64
    8000460e:	fc06                	sd	ra,56(sp)
    80004610:	f822                	sd	s0,48(sp)
    80004612:	f426                	sd	s1,40(sp)
    80004614:	f04a                	sd	s2,32(sp)
    80004616:	ec4e                	sd	s3,24(sp)
    80004618:	e852                	sd	s4,16(sp)
    8000461a:	e456                	sd	s5,8(sp)
    8000461c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000461e:	0003d497          	auipc	s1,0x3d
    80004622:	44a48493          	addi	s1,s1,1098 # 80041a68 <log>
    80004626:	8526                	mv	a0,s1
    80004628:	ffffd097          	auipc	ra,0xffffd
    8000462c:	952080e7          	jalr	-1710(ra) # 80000f7a <acquire>
  log.outstanding -= 1;
    80004630:	509c                	lw	a5,32(s1)
    80004632:	37fd                	addiw	a5,a5,-1
    80004634:	0007891b          	sext.w	s2,a5
    80004638:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000463a:	50dc                	lw	a5,36(s1)
    8000463c:	e7b9                	bnez	a5,8000468a <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000463e:	04091e63          	bnez	s2,8000469a <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004642:	0003d497          	auipc	s1,0x3d
    80004646:	42648493          	addi	s1,s1,1062 # 80041a68 <log>
    8000464a:	4785                	li	a5,1
    8000464c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000464e:	8526                	mv	a0,s1
    80004650:	ffffd097          	auipc	ra,0xffffd
    80004654:	9de080e7          	jalr	-1570(ra) # 8000102e <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004658:	54dc                	lw	a5,44(s1)
    8000465a:	06f04763          	bgtz	a5,800046c8 <end_op+0xbc>
    acquire(&log.lock);
    8000465e:	0003d497          	auipc	s1,0x3d
    80004662:	40a48493          	addi	s1,s1,1034 # 80041a68 <log>
    80004666:	8526                	mv	a0,s1
    80004668:	ffffd097          	auipc	ra,0xffffd
    8000466c:	912080e7          	jalr	-1774(ra) # 80000f7a <acquire>
    log.committing = 0;
    80004670:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004674:	8526                	mv	a0,s1
    80004676:	ffffe097          	auipc	ra,0xffffe
    8000467a:	1c4080e7          	jalr	452(ra) # 8000283a <wakeup>
    release(&log.lock);
    8000467e:	8526                	mv	a0,s1
    80004680:	ffffd097          	auipc	ra,0xffffd
    80004684:	9ae080e7          	jalr	-1618(ra) # 8000102e <release>
}
    80004688:	a03d                	j	800046b6 <end_op+0xaa>
    panic("log.committing");
    8000468a:	00004517          	auipc	a0,0x4
    8000468e:	05e50513          	addi	a0,a0,94 # 800086e8 <syscalls+0x1f8>
    80004692:	ffffc097          	auipc	ra,0xffffc
    80004696:	f52080e7          	jalr	-174(ra) # 800005e4 <panic>
    wakeup(&log);
    8000469a:	0003d497          	auipc	s1,0x3d
    8000469e:	3ce48493          	addi	s1,s1,974 # 80041a68 <log>
    800046a2:	8526                	mv	a0,s1
    800046a4:	ffffe097          	auipc	ra,0xffffe
    800046a8:	196080e7          	jalr	406(ra) # 8000283a <wakeup>
  release(&log.lock);
    800046ac:	8526                	mv	a0,s1
    800046ae:	ffffd097          	auipc	ra,0xffffd
    800046b2:	980080e7          	jalr	-1664(ra) # 8000102e <release>
}
    800046b6:	70e2                	ld	ra,56(sp)
    800046b8:	7442                	ld	s0,48(sp)
    800046ba:	74a2                	ld	s1,40(sp)
    800046bc:	7902                	ld	s2,32(sp)
    800046be:	69e2                	ld	s3,24(sp)
    800046c0:	6a42                	ld	s4,16(sp)
    800046c2:	6aa2                	ld	s5,8(sp)
    800046c4:	6121                	addi	sp,sp,64
    800046c6:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800046c8:	0003da97          	auipc	s5,0x3d
    800046cc:	3d0a8a93          	addi	s5,s5,976 # 80041a98 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800046d0:	0003da17          	auipc	s4,0x3d
    800046d4:	398a0a13          	addi	s4,s4,920 # 80041a68 <log>
    800046d8:	018a2583          	lw	a1,24(s4)
    800046dc:	012585bb          	addw	a1,a1,s2
    800046e0:	2585                	addiw	a1,a1,1
    800046e2:	028a2503          	lw	a0,40(s4)
    800046e6:	fffff097          	auipc	ra,0xfffff
    800046ea:	ce4080e7          	jalr	-796(ra) # 800033ca <bread>
    800046ee:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800046f0:	000aa583          	lw	a1,0(s5)
    800046f4:	028a2503          	lw	a0,40(s4)
    800046f8:	fffff097          	auipc	ra,0xfffff
    800046fc:	cd2080e7          	jalr	-814(ra) # 800033ca <bread>
    80004700:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004702:	40000613          	li	a2,1024
    80004706:	05850593          	addi	a1,a0,88
    8000470a:	05848513          	addi	a0,s1,88
    8000470e:	ffffd097          	auipc	ra,0xffffd
    80004712:	9c4080e7          	jalr	-1596(ra) # 800010d2 <memmove>
    bwrite(to);  // write the log
    80004716:	8526                	mv	a0,s1
    80004718:	fffff097          	auipc	ra,0xfffff
    8000471c:	da4080e7          	jalr	-604(ra) # 800034bc <bwrite>
    brelse(from);
    80004720:	854e                	mv	a0,s3
    80004722:	fffff097          	auipc	ra,0xfffff
    80004726:	dd8080e7          	jalr	-552(ra) # 800034fa <brelse>
    brelse(to);
    8000472a:	8526                	mv	a0,s1
    8000472c:	fffff097          	auipc	ra,0xfffff
    80004730:	dce080e7          	jalr	-562(ra) # 800034fa <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004734:	2905                	addiw	s2,s2,1
    80004736:	0a91                	addi	s5,s5,4
    80004738:	02ca2783          	lw	a5,44(s4)
    8000473c:	f8f94ee3          	blt	s2,a5,800046d8 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004740:	00000097          	auipc	ra,0x0
    80004744:	c7a080e7          	jalr	-902(ra) # 800043ba <write_head>
    install_trans(); // Now install writes to home locations
    80004748:	00000097          	auipc	ra,0x0
    8000474c:	cec080e7          	jalr	-788(ra) # 80004434 <install_trans>
    log.lh.n = 0;
    80004750:	0003d797          	auipc	a5,0x3d
    80004754:	3407a223          	sw	zero,836(a5) # 80041a94 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004758:	00000097          	auipc	ra,0x0
    8000475c:	c62080e7          	jalr	-926(ra) # 800043ba <write_head>
    80004760:	bdfd                	j	8000465e <end_op+0x52>

0000000080004762 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004762:	1101                	addi	sp,sp,-32
    80004764:	ec06                	sd	ra,24(sp)
    80004766:	e822                	sd	s0,16(sp)
    80004768:	e426                	sd	s1,8(sp)
    8000476a:	e04a                	sd	s2,0(sp)
    8000476c:	1000                	addi	s0,sp,32
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000476e:	0003d717          	auipc	a4,0x3d
    80004772:	32672703          	lw	a4,806(a4) # 80041a94 <log+0x2c>
    80004776:	47f5                	li	a5,29
    80004778:	08e7c063          	blt	a5,a4,800047f8 <log_write+0x96>
    8000477c:	84aa                	mv	s1,a0
    8000477e:	0003d797          	auipc	a5,0x3d
    80004782:	3067a783          	lw	a5,774(a5) # 80041a84 <log+0x1c>
    80004786:	37fd                	addiw	a5,a5,-1
    80004788:	06f75863          	bge	a4,a5,800047f8 <log_write+0x96>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000478c:	0003d797          	auipc	a5,0x3d
    80004790:	2fc7a783          	lw	a5,764(a5) # 80041a88 <log+0x20>
    80004794:	06f05a63          	blez	a5,80004808 <log_write+0xa6>
    panic("log_write outside of trans");

  acquire(&log.lock);
    80004798:	0003d917          	auipc	s2,0x3d
    8000479c:	2d090913          	addi	s2,s2,720 # 80041a68 <log>
    800047a0:	854a                	mv	a0,s2
    800047a2:	ffffc097          	auipc	ra,0xffffc
    800047a6:	7d8080e7          	jalr	2008(ra) # 80000f7a <acquire>
  for (i = 0; i < log.lh.n; i++) {
    800047aa:	02c92603          	lw	a2,44(s2)
    800047ae:	06c05563          	blez	a2,80004818 <log_write+0xb6>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800047b2:	44cc                	lw	a1,12(s1)
    800047b4:	0003d717          	auipc	a4,0x3d
    800047b8:	2e470713          	addi	a4,a4,740 # 80041a98 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800047bc:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800047be:	4314                	lw	a3,0(a4)
    800047c0:	04b68d63          	beq	a3,a1,8000481a <log_write+0xb8>
  for (i = 0; i < log.lh.n; i++) {
    800047c4:	2785                	addiw	a5,a5,1
    800047c6:	0711                	addi	a4,a4,4
    800047c8:	fec79be3          	bne	a5,a2,800047be <log_write+0x5c>
      break;
  }
  log.lh.block[i] = b->blockno;
    800047cc:	0621                	addi	a2,a2,8
    800047ce:	060a                	slli	a2,a2,0x2
    800047d0:	0003d797          	auipc	a5,0x3d
    800047d4:	29878793          	addi	a5,a5,664 # 80041a68 <log>
    800047d8:	963e                	add	a2,a2,a5
    800047da:	44dc                	lw	a5,12(s1)
    800047dc:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800047de:	8526                	mv	a0,s1
    800047e0:	fffff097          	auipc	ra,0xfffff
    800047e4:	db8080e7          	jalr	-584(ra) # 80003598 <bpin>
    log.lh.n++;
    800047e8:	0003d717          	auipc	a4,0x3d
    800047ec:	28070713          	addi	a4,a4,640 # 80041a68 <log>
    800047f0:	575c                	lw	a5,44(a4)
    800047f2:	2785                	addiw	a5,a5,1
    800047f4:	d75c                	sw	a5,44(a4)
    800047f6:	a83d                	j	80004834 <log_write+0xd2>
    panic("too big a transaction");
    800047f8:	00004517          	auipc	a0,0x4
    800047fc:	f0050513          	addi	a0,a0,-256 # 800086f8 <syscalls+0x208>
    80004800:	ffffc097          	auipc	ra,0xffffc
    80004804:	de4080e7          	jalr	-540(ra) # 800005e4 <panic>
    panic("log_write outside of trans");
    80004808:	00004517          	auipc	a0,0x4
    8000480c:	f0850513          	addi	a0,a0,-248 # 80008710 <syscalls+0x220>
    80004810:	ffffc097          	auipc	ra,0xffffc
    80004814:	dd4080e7          	jalr	-556(ra) # 800005e4 <panic>
  for (i = 0; i < log.lh.n; i++) {
    80004818:	4781                	li	a5,0
  log.lh.block[i] = b->blockno;
    8000481a:	00878713          	addi	a4,a5,8
    8000481e:	00271693          	slli	a3,a4,0x2
    80004822:	0003d717          	auipc	a4,0x3d
    80004826:	24670713          	addi	a4,a4,582 # 80041a68 <log>
    8000482a:	9736                	add	a4,a4,a3
    8000482c:	44d4                	lw	a3,12(s1)
    8000482e:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004830:	faf607e3          	beq	a2,a5,800047de <log_write+0x7c>
  }
  release(&log.lock);
    80004834:	0003d517          	auipc	a0,0x3d
    80004838:	23450513          	addi	a0,a0,564 # 80041a68 <log>
    8000483c:	ffffc097          	auipc	ra,0xffffc
    80004840:	7f2080e7          	jalr	2034(ra) # 8000102e <release>
}
    80004844:	60e2                	ld	ra,24(sp)
    80004846:	6442                	ld	s0,16(sp)
    80004848:	64a2                	ld	s1,8(sp)
    8000484a:	6902                	ld	s2,0(sp)
    8000484c:	6105                	addi	sp,sp,32
    8000484e:	8082                	ret

0000000080004850 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004850:	1101                	addi	sp,sp,-32
    80004852:	ec06                	sd	ra,24(sp)
    80004854:	e822                	sd	s0,16(sp)
    80004856:	e426                	sd	s1,8(sp)
    80004858:	e04a                	sd	s2,0(sp)
    8000485a:	1000                	addi	s0,sp,32
    8000485c:	84aa                	mv	s1,a0
    8000485e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004860:	00004597          	auipc	a1,0x4
    80004864:	ed058593          	addi	a1,a1,-304 # 80008730 <syscalls+0x240>
    80004868:	0521                	addi	a0,a0,8
    8000486a:	ffffc097          	auipc	ra,0xffffc
    8000486e:	680080e7          	jalr	1664(ra) # 80000eea <initlock>
  lk->name = name;
    80004872:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004876:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000487a:	0204a423          	sw	zero,40(s1)
}
    8000487e:	60e2                	ld	ra,24(sp)
    80004880:	6442                	ld	s0,16(sp)
    80004882:	64a2                	ld	s1,8(sp)
    80004884:	6902                	ld	s2,0(sp)
    80004886:	6105                	addi	sp,sp,32
    80004888:	8082                	ret

000000008000488a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000488a:	1101                	addi	sp,sp,-32
    8000488c:	ec06                	sd	ra,24(sp)
    8000488e:	e822                	sd	s0,16(sp)
    80004890:	e426                	sd	s1,8(sp)
    80004892:	e04a                	sd	s2,0(sp)
    80004894:	1000                	addi	s0,sp,32
    80004896:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004898:	00850913          	addi	s2,a0,8
    8000489c:	854a                	mv	a0,s2
    8000489e:	ffffc097          	auipc	ra,0xffffc
    800048a2:	6dc080e7          	jalr	1756(ra) # 80000f7a <acquire>
  while (lk->locked) {
    800048a6:	409c                	lw	a5,0(s1)
    800048a8:	cb89                	beqz	a5,800048ba <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800048aa:	85ca                	mv	a1,s2
    800048ac:	8526                	mv	a0,s1
    800048ae:	ffffe097          	auipc	ra,0xffffe
    800048b2:	e0c080e7          	jalr	-500(ra) # 800026ba <sleep>
  while (lk->locked) {
    800048b6:	409c                	lw	a5,0(s1)
    800048b8:	fbed                	bnez	a5,800048aa <acquiresleep+0x20>
  }
  lk->locked = 1;
    800048ba:	4785                	li	a5,1
    800048bc:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800048be:	ffffd097          	auipc	ra,0xffffd
    800048c2:	5e8080e7          	jalr	1512(ra) # 80001ea6 <myproc>
    800048c6:	5d1c                	lw	a5,56(a0)
    800048c8:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800048ca:	854a                	mv	a0,s2
    800048cc:	ffffc097          	auipc	ra,0xffffc
    800048d0:	762080e7          	jalr	1890(ra) # 8000102e <release>
}
    800048d4:	60e2                	ld	ra,24(sp)
    800048d6:	6442                	ld	s0,16(sp)
    800048d8:	64a2                	ld	s1,8(sp)
    800048da:	6902                	ld	s2,0(sp)
    800048dc:	6105                	addi	sp,sp,32
    800048de:	8082                	ret

00000000800048e0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800048e0:	1101                	addi	sp,sp,-32
    800048e2:	ec06                	sd	ra,24(sp)
    800048e4:	e822                	sd	s0,16(sp)
    800048e6:	e426                	sd	s1,8(sp)
    800048e8:	e04a                	sd	s2,0(sp)
    800048ea:	1000                	addi	s0,sp,32
    800048ec:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800048ee:	00850913          	addi	s2,a0,8
    800048f2:	854a                	mv	a0,s2
    800048f4:	ffffc097          	auipc	ra,0xffffc
    800048f8:	686080e7          	jalr	1670(ra) # 80000f7a <acquire>
  lk->locked = 0;
    800048fc:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004900:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004904:	8526                	mv	a0,s1
    80004906:	ffffe097          	auipc	ra,0xffffe
    8000490a:	f34080e7          	jalr	-204(ra) # 8000283a <wakeup>
  release(&lk->lk);
    8000490e:	854a                	mv	a0,s2
    80004910:	ffffc097          	auipc	ra,0xffffc
    80004914:	71e080e7          	jalr	1822(ra) # 8000102e <release>
}
    80004918:	60e2                	ld	ra,24(sp)
    8000491a:	6442                	ld	s0,16(sp)
    8000491c:	64a2                	ld	s1,8(sp)
    8000491e:	6902                	ld	s2,0(sp)
    80004920:	6105                	addi	sp,sp,32
    80004922:	8082                	ret

0000000080004924 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004924:	7179                	addi	sp,sp,-48
    80004926:	f406                	sd	ra,40(sp)
    80004928:	f022                	sd	s0,32(sp)
    8000492a:	ec26                	sd	s1,24(sp)
    8000492c:	e84a                	sd	s2,16(sp)
    8000492e:	e44e                	sd	s3,8(sp)
    80004930:	1800                	addi	s0,sp,48
    80004932:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004934:	00850913          	addi	s2,a0,8
    80004938:	854a                	mv	a0,s2
    8000493a:	ffffc097          	auipc	ra,0xffffc
    8000493e:	640080e7          	jalr	1600(ra) # 80000f7a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004942:	409c                	lw	a5,0(s1)
    80004944:	ef99                	bnez	a5,80004962 <holdingsleep+0x3e>
    80004946:	4481                	li	s1,0
  release(&lk->lk);
    80004948:	854a                	mv	a0,s2
    8000494a:	ffffc097          	auipc	ra,0xffffc
    8000494e:	6e4080e7          	jalr	1764(ra) # 8000102e <release>
  return r;
}
    80004952:	8526                	mv	a0,s1
    80004954:	70a2                	ld	ra,40(sp)
    80004956:	7402                	ld	s0,32(sp)
    80004958:	64e2                	ld	s1,24(sp)
    8000495a:	6942                	ld	s2,16(sp)
    8000495c:	69a2                	ld	s3,8(sp)
    8000495e:	6145                	addi	sp,sp,48
    80004960:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004962:	0284a983          	lw	s3,40(s1)
    80004966:	ffffd097          	auipc	ra,0xffffd
    8000496a:	540080e7          	jalr	1344(ra) # 80001ea6 <myproc>
    8000496e:	5d04                	lw	s1,56(a0)
    80004970:	413484b3          	sub	s1,s1,s3
    80004974:	0014b493          	seqz	s1,s1
    80004978:	bfc1                	j	80004948 <holdingsleep+0x24>

000000008000497a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000497a:	1141                	addi	sp,sp,-16
    8000497c:	e406                	sd	ra,8(sp)
    8000497e:	e022                	sd	s0,0(sp)
    80004980:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004982:	00004597          	auipc	a1,0x4
    80004986:	dbe58593          	addi	a1,a1,-578 # 80008740 <syscalls+0x250>
    8000498a:	0003d517          	auipc	a0,0x3d
    8000498e:	22650513          	addi	a0,a0,550 # 80041bb0 <ftable>
    80004992:	ffffc097          	auipc	ra,0xffffc
    80004996:	558080e7          	jalr	1368(ra) # 80000eea <initlock>
}
    8000499a:	60a2                	ld	ra,8(sp)
    8000499c:	6402                	ld	s0,0(sp)
    8000499e:	0141                	addi	sp,sp,16
    800049a0:	8082                	ret

00000000800049a2 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800049a2:	1101                	addi	sp,sp,-32
    800049a4:	ec06                	sd	ra,24(sp)
    800049a6:	e822                	sd	s0,16(sp)
    800049a8:	e426                	sd	s1,8(sp)
    800049aa:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800049ac:	0003d517          	auipc	a0,0x3d
    800049b0:	20450513          	addi	a0,a0,516 # 80041bb0 <ftable>
    800049b4:	ffffc097          	auipc	ra,0xffffc
    800049b8:	5c6080e7          	jalr	1478(ra) # 80000f7a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800049bc:	0003d497          	auipc	s1,0x3d
    800049c0:	20c48493          	addi	s1,s1,524 # 80041bc8 <ftable+0x18>
    800049c4:	0003e717          	auipc	a4,0x3e
    800049c8:	1a470713          	addi	a4,a4,420 # 80042b68 <ftable+0xfb8>
    if(f->ref == 0){
    800049cc:	40dc                	lw	a5,4(s1)
    800049ce:	cf99                	beqz	a5,800049ec <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800049d0:	02848493          	addi	s1,s1,40
    800049d4:	fee49ce3          	bne	s1,a4,800049cc <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800049d8:	0003d517          	auipc	a0,0x3d
    800049dc:	1d850513          	addi	a0,a0,472 # 80041bb0 <ftable>
    800049e0:	ffffc097          	auipc	ra,0xffffc
    800049e4:	64e080e7          	jalr	1614(ra) # 8000102e <release>
  return 0;
    800049e8:	4481                	li	s1,0
    800049ea:	a819                	j	80004a00 <filealloc+0x5e>
      f->ref = 1;
    800049ec:	4785                	li	a5,1
    800049ee:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800049f0:	0003d517          	auipc	a0,0x3d
    800049f4:	1c050513          	addi	a0,a0,448 # 80041bb0 <ftable>
    800049f8:	ffffc097          	auipc	ra,0xffffc
    800049fc:	636080e7          	jalr	1590(ra) # 8000102e <release>
}
    80004a00:	8526                	mv	a0,s1
    80004a02:	60e2                	ld	ra,24(sp)
    80004a04:	6442                	ld	s0,16(sp)
    80004a06:	64a2                	ld	s1,8(sp)
    80004a08:	6105                	addi	sp,sp,32
    80004a0a:	8082                	ret

0000000080004a0c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004a0c:	1101                	addi	sp,sp,-32
    80004a0e:	ec06                	sd	ra,24(sp)
    80004a10:	e822                	sd	s0,16(sp)
    80004a12:	e426                	sd	s1,8(sp)
    80004a14:	1000                	addi	s0,sp,32
    80004a16:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004a18:	0003d517          	auipc	a0,0x3d
    80004a1c:	19850513          	addi	a0,a0,408 # 80041bb0 <ftable>
    80004a20:	ffffc097          	auipc	ra,0xffffc
    80004a24:	55a080e7          	jalr	1370(ra) # 80000f7a <acquire>
  if(f->ref < 1)
    80004a28:	40dc                	lw	a5,4(s1)
    80004a2a:	02f05263          	blez	a5,80004a4e <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004a2e:	2785                	addiw	a5,a5,1
    80004a30:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004a32:	0003d517          	auipc	a0,0x3d
    80004a36:	17e50513          	addi	a0,a0,382 # 80041bb0 <ftable>
    80004a3a:	ffffc097          	auipc	ra,0xffffc
    80004a3e:	5f4080e7          	jalr	1524(ra) # 8000102e <release>
  return f;
}
    80004a42:	8526                	mv	a0,s1
    80004a44:	60e2                	ld	ra,24(sp)
    80004a46:	6442                	ld	s0,16(sp)
    80004a48:	64a2                	ld	s1,8(sp)
    80004a4a:	6105                	addi	sp,sp,32
    80004a4c:	8082                	ret
    panic("filedup");
    80004a4e:	00004517          	auipc	a0,0x4
    80004a52:	cfa50513          	addi	a0,a0,-774 # 80008748 <syscalls+0x258>
    80004a56:	ffffc097          	auipc	ra,0xffffc
    80004a5a:	b8e080e7          	jalr	-1138(ra) # 800005e4 <panic>

0000000080004a5e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004a5e:	7139                	addi	sp,sp,-64
    80004a60:	fc06                	sd	ra,56(sp)
    80004a62:	f822                	sd	s0,48(sp)
    80004a64:	f426                	sd	s1,40(sp)
    80004a66:	f04a                	sd	s2,32(sp)
    80004a68:	ec4e                	sd	s3,24(sp)
    80004a6a:	e852                	sd	s4,16(sp)
    80004a6c:	e456                	sd	s5,8(sp)
    80004a6e:	0080                	addi	s0,sp,64
    80004a70:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004a72:	0003d517          	auipc	a0,0x3d
    80004a76:	13e50513          	addi	a0,a0,318 # 80041bb0 <ftable>
    80004a7a:	ffffc097          	auipc	ra,0xffffc
    80004a7e:	500080e7          	jalr	1280(ra) # 80000f7a <acquire>
  if(f->ref < 1)
    80004a82:	40dc                	lw	a5,4(s1)
    80004a84:	06f05163          	blez	a5,80004ae6 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004a88:	37fd                	addiw	a5,a5,-1
    80004a8a:	0007871b          	sext.w	a4,a5
    80004a8e:	c0dc                	sw	a5,4(s1)
    80004a90:	06e04363          	bgtz	a4,80004af6 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004a94:	0004a903          	lw	s2,0(s1)
    80004a98:	0094ca83          	lbu	s5,9(s1)
    80004a9c:	0104ba03          	ld	s4,16(s1)
    80004aa0:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004aa4:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004aa8:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004aac:	0003d517          	auipc	a0,0x3d
    80004ab0:	10450513          	addi	a0,a0,260 # 80041bb0 <ftable>
    80004ab4:	ffffc097          	auipc	ra,0xffffc
    80004ab8:	57a080e7          	jalr	1402(ra) # 8000102e <release>

  if(ff.type == FD_PIPE){
    80004abc:	4785                	li	a5,1
    80004abe:	04f90d63          	beq	s2,a5,80004b18 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004ac2:	3979                	addiw	s2,s2,-2
    80004ac4:	4785                	li	a5,1
    80004ac6:	0527e063          	bltu	a5,s2,80004b06 <fileclose+0xa8>
    begin_op();
    80004aca:	00000097          	auipc	ra,0x0
    80004ace:	ac2080e7          	jalr	-1342(ra) # 8000458c <begin_op>
    iput(ff.ip);
    80004ad2:	854e                	mv	a0,s3
    80004ad4:	fffff097          	auipc	ra,0xfffff
    80004ad8:	2b2080e7          	jalr	690(ra) # 80003d86 <iput>
    end_op();
    80004adc:	00000097          	auipc	ra,0x0
    80004ae0:	b30080e7          	jalr	-1232(ra) # 8000460c <end_op>
    80004ae4:	a00d                	j	80004b06 <fileclose+0xa8>
    panic("fileclose");
    80004ae6:	00004517          	auipc	a0,0x4
    80004aea:	c6a50513          	addi	a0,a0,-918 # 80008750 <syscalls+0x260>
    80004aee:	ffffc097          	auipc	ra,0xffffc
    80004af2:	af6080e7          	jalr	-1290(ra) # 800005e4 <panic>
    release(&ftable.lock);
    80004af6:	0003d517          	auipc	a0,0x3d
    80004afa:	0ba50513          	addi	a0,a0,186 # 80041bb0 <ftable>
    80004afe:	ffffc097          	auipc	ra,0xffffc
    80004b02:	530080e7          	jalr	1328(ra) # 8000102e <release>
  }
}
    80004b06:	70e2                	ld	ra,56(sp)
    80004b08:	7442                	ld	s0,48(sp)
    80004b0a:	74a2                	ld	s1,40(sp)
    80004b0c:	7902                	ld	s2,32(sp)
    80004b0e:	69e2                	ld	s3,24(sp)
    80004b10:	6a42                	ld	s4,16(sp)
    80004b12:	6aa2                	ld	s5,8(sp)
    80004b14:	6121                	addi	sp,sp,64
    80004b16:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004b18:	85d6                	mv	a1,s5
    80004b1a:	8552                	mv	a0,s4
    80004b1c:	00000097          	auipc	ra,0x0
    80004b20:	372080e7          	jalr	882(ra) # 80004e8e <pipeclose>
    80004b24:	b7cd                	j	80004b06 <fileclose+0xa8>

0000000080004b26 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004b26:	715d                	addi	sp,sp,-80
    80004b28:	e486                	sd	ra,72(sp)
    80004b2a:	e0a2                	sd	s0,64(sp)
    80004b2c:	fc26                	sd	s1,56(sp)
    80004b2e:	f84a                	sd	s2,48(sp)
    80004b30:	f44e                	sd	s3,40(sp)
    80004b32:	0880                	addi	s0,sp,80
    80004b34:	84aa                	mv	s1,a0
    80004b36:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004b38:	ffffd097          	auipc	ra,0xffffd
    80004b3c:	36e080e7          	jalr	878(ra) # 80001ea6 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004b40:	409c                	lw	a5,0(s1)
    80004b42:	37f9                	addiw	a5,a5,-2
    80004b44:	4705                	li	a4,1
    80004b46:	04f76763          	bltu	a4,a5,80004b94 <filestat+0x6e>
    80004b4a:	892a                	mv	s2,a0
    ilock(f->ip);
    80004b4c:	6c88                	ld	a0,24(s1)
    80004b4e:	fffff097          	auipc	ra,0xfffff
    80004b52:	07e080e7          	jalr	126(ra) # 80003bcc <ilock>
    stati(f->ip, &st);
    80004b56:	fb840593          	addi	a1,s0,-72
    80004b5a:	6c88                	ld	a0,24(s1)
    80004b5c:	fffff097          	auipc	ra,0xfffff
    80004b60:	2fa080e7          	jalr	762(ra) # 80003e56 <stati>
    iunlock(f->ip);
    80004b64:	6c88                	ld	a0,24(s1)
    80004b66:	fffff097          	auipc	ra,0xfffff
    80004b6a:	128080e7          	jalr	296(ra) # 80003c8e <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004b6e:	46e1                	li	a3,24
    80004b70:	fb840613          	addi	a2,s0,-72
    80004b74:	85ce                	mv	a1,s3
    80004b76:	05093503          	ld	a0,80(s2)
    80004b7a:	ffffd097          	auipc	ra,0xffffd
    80004b7e:	0f8080e7          	jalr	248(ra) # 80001c72 <copyout>
    80004b82:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004b86:	60a6                	ld	ra,72(sp)
    80004b88:	6406                	ld	s0,64(sp)
    80004b8a:	74e2                	ld	s1,56(sp)
    80004b8c:	7942                	ld	s2,48(sp)
    80004b8e:	79a2                	ld	s3,40(sp)
    80004b90:	6161                	addi	sp,sp,80
    80004b92:	8082                	ret
  return -1;
    80004b94:	557d                	li	a0,-1
    80004b96:	bfc5                	j	80004b86 <filestat+0x60>

0000000080004b98 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004b98:	7179                	addi	sp,sp,-48
    80004b9a:	f406                	sd	ra,40(sp)
    80004b9c:	f022                	sd	s0,32(sp)
    80004b9e:	ec26                	sd	s1,24(sp)
    80004ba0:	e84a                	sd	s2,16(sp)
    80004ba2:	e44e                	sd	s3,8(sp)
    80004ba4:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004ba6:	00854783          	lbu	a5,8(a0)
    80004baa:	c3d5                	beqz	a5,80004c4e <fileread+0xb6>
    80004bac:	84aa                	mv	s1,a0
    80004bae:	89ae                	mv	s3,a1
    80004bb0:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004bb2:	411c                	lw	a5,0(a0)
    80004bb4:	4705                	li	a4,1
    80004bb6:	04e78963          	beq	a5,a4,80004c08 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004bba:	470d                	li	a4,3
    80004bbc:	04e78d63          	beq	a5,a4,80004c16 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004bc0:	4709                	li	a4,2
    80004bc2:	06e79e63          	bne	a5,a4,80004c3e <fileread+0xa6>
    ilock(f->ip);
    80004bc6:	6d08                	ld	a0,24(a0)
    80004bc8:	fffff097          	auipc	ra,0xfffff
    80004bcc:	004080e7          	jalr	4(ra) # 80003bcc <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004bd0:	874a                	mv	a4,s2
    80004bd2:	5094                	lw	a3,32(s1)
    80004bd4:	864e                	mv	a2,s3
    80004bd6:	4585                	li	a1,1
    80004bd8:	6c88                	ld	a0,24(s1)
    80004bda:	fffff097          	auipc	ra,0xfffff
    80004bde:	2a6080e7          	jalr	678(ra) # 80003e80 <readi>
    80004be2:	892a                	mv	s2,a0
    80004be4:	00a05563          	blez	a0,80004bee <fileread+0x56>
      f->off += r;
    80004be8:	509c                	lw	a5,32(s1)
    80004bea:	9fa9                	addw	a5,a5,a0
    80004bec:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004bee:	6c88                	ld	a0,24(s1)
    80004bf0:	fffff097          	auipc	ra,0xfffff
    80004bf4:	09e080e7          	jalr	158(ra) # 80003c8e <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004bf8:	854a                	mv	a0,s2
    80004bfa:	70a2                	ld	ra,40(sp)
    80004bfc:	7402                	ld	s0,32(sp)
    80004bfe:	64e2                	ld	s1,24(sp)
    80004c00:	6942                	ld	s2,16(sp)
    80004c02:	69a2                	ld	s3,8(sp)
    80004c04:	6145                	addi	sp,sp,48
    80004c06:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004c08:	6908                	ld	a0,16(a0)
    80004c0a:	00000097          	auipc	ra,0x0
    80004c0e:	3f4080e7          	jalr	1012(ra) # 80004ffe <piperead>
    80004c12:	892a                	mv	s2,a0
    80004c14:	b7d5                	j	80004bf8 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004c16:	02451783          	lh	a5,36(a0)
    80004c1a:	03079693          	slli	a3,a5,0x30
    80004c1e:	92c1                	srli	a3,a3,0x30
    80004c20:	4725                	li	a4,9
    80004c22:	02d76863          	bltu	a4,a3,80004c52 <fileread+0xba>
    80004c26:	0792                	slli	a5,a5,0x4
    80004c28:	0003d717          	auipc	a4,0x3d
    80004c2c:	ee870713          	addi	a4,a4,-280 # 80041b10 <devsw>
    80004c30:	97ba                	add	a5,a5,a4
    80004c32:	639c                	ld	a5,0(a5)
    80004c34:	c38d                	beqz	a5,80004c56 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004c36:	4505                	li	a0,1
    80004c38:	9782                	jalr	a5
    80004c3a:	892a                	mv	s2,a0
    80004c3c:	bf75                	j	80004bf8 <fileread+0x60>
    panic("fileread");
    80004c3e:	00004517          	auipc	a0,0x4
    80004c42:	b2250513          	addi	a0,a0,-1246 # 80008760 <syscalls+0x270>
    80004c46:	ffffc097          	auipc	ra,0xffffc
    80004c4a:	99e080e7          	jalr	-1634(ra) # 800005e4 <panic>
    return -1;
    80004c4e:	597d                	li	s2,-1
    80004c50:	b765                	j	80004bf8 <fileread+0x60>
      return -1;
    80004c52:	597d                	li	s2,-1
    80004c54:	b755                	j	80004bf8 <fileread+0x60>
    80004c56:	597d                	li	s2,-1
    80004c58:	b745                	j	80004bf8 <fileread+0x60>

0000000080004c5a <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004c5a:	00954783          	lbu	a5,9(a0)
    80004c5e:	14078563          	beqz	a5,80004da8 <filewrite+0x14e>
{
    80004c62:	715d                	addi	sp,sp,-80
    80004c64:	e486                	sd	ra,72(sp)
    80004c66:	e0a2                	sd	s0,64(sp)
    80004c68:	fc26                	sd	s1,56(sp)
    80004c6a:	f84a                	sd	s2,48(sp)
    80004c6c:	f44e                	sd	s3,40(sp)
    80004c6e:	f052                	sd	s4,32(sp)
    80004c70:	ec56                	sd	s5,24(sp)
    80004c72:	e85a                	sd	s6,16(sp)
    80004c74:	e45e                	sd	s7,8(sp)
    80004c76:	e062                	sd	s8,0(sp)
    80004c78:	0880                	addi	s0,sp,80
    80004c7a:	892a                	mv	s2,a0
    80004c7c:	8aae                	mv	s5,a1
    80004c7e:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004c80:	411c                	lw	a5,0(a0)
    80004c82:	4705                	li	a4,1
    80004c84:	02e78263          	beq	a5,a4,80004ca8 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004c88:	470d                	li	a4,3
    80004c8a:	02e78563          	beq	a5,a4,80004cb4 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004c8e:	4709                	li	a4,2
    80004c90:	10e79463          	bne	a5,a4,80004d98 <filewrite+0x13e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004c94:	0ec05e63          	blez	a2,80004d90 <filewrite+0x136>
    int i = 0;
    80004c98:	4981                	li	s3,0
    80004c9a:	6b05                	lui	s6,0x1
    80004c9c:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004ca0:	6b85                	lui	s7,0x1
    80004ca2:	c00b8b9b          	addiw	s7,s7,-1024
    80004ca6:	a851                	j	80004d3a <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80004ca8:	6908                	ld	a0,16(a0)
    80004caa:	00000097          	auipc	ra,0x0
    80004cae:	254080e7          	jalr	596(ra) # 80004efe <pipewrite>
    80004cb2:	a85d                	j	80004d68 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004cb4:	02451783          	lh	a5,36(a0)
    80004cb8:	03079693          	slli	a3,a5,0x30
    80004cbc:	92c1                	srli	a3,a3,0x30
    80004cbe:	4725                	li	a4,9
    80004cc0:	0ed76663          	bltu	a4,a3,80004dac <filewrite+0x152>
    80004cc4:	0792                	slli	a5,a5,0x4
    80004cc6:	0003d717          	auipc	a4,0x3d
    80004cca:	e4a70713          	addi	a4,a4,-438 # 80041b10 <devsw>
    80004cce:	97ba                	add	a5,a5,a4
    80004cd0:	679c                	ld	a5,8(a5)
    80004cd2:	cff9                	beqz	a5,80004db0 <filewrite+0x156>
    ret = devsw[f->major].write(1, addr, n);
    80004cd4:	4505                	li	a0,1
    80004cd6:	9782                	jalr	a5
    80004cd8:	a841                	j	80004d68 <filewrite+0x10e>
    80004cda:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004cde:	00000097          	auipc	ra,0x0
    80004ce2:	8ae080e7          	jalr	-1874(ra) # 8000458c <begin_op>
      ilock(f->ip);
    80004ce6:	01893503          	ld	a0,24(s2)
    80004cea:	fffff097          	auipc	ra,0xfffff
    80004cee:	ee2080e7          	jalr	-286(ra) # 80003bcc <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004cf2:	8762                	mv	a4,s8
    80004cf4:	02092683          	lw	a3,32(s2)
    80004cf8:	01598633          	add	a2,s3,s5
    80004cfc:	4585                	li	a1,1
    80004cfe:	01893503          	ld	a0,24(s2)
    80004d02:	fffff097          	auipc	ra,0xfffff
    80004d06:	276080e7          	jalr	630(ra) # 80003f78 <writei>
    80004d0a:	84aa                	mv	s1,a0
    80004d0c:	02a05f63          	blez	a0,80004d4a <filewrite+0xf0>
        f->off += r;
    80004d10:	02092783          	lw	a5,32(s2)
    80004d14:	9fa9                	addw	a5,a5,a0
    80004d16:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004d1a:	01893503          	ld	a0,24(s2)
    80004d1e:	fffff097          	auipc	ra,0xfffff
    80004d22:	f70080e7          	jalr	-144(ra) # 80003c8e <iunlock>
      end_op();
    80004d26:	00000097          	auipc	ra,0x0
    80004d2a:	8e6080e7          	jalr	-1818(ra) # 8000460c <end_op>

      if(r < 0)
        break;
      if(r != n1)
    80004d2e:	049c1963          	bne	s8,s1,80004d80 <filewrite+0x126>
        panic("short filewrite");
      i += r;
    80004d32:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004d36:	0349d663          	bge	s3,s4,80004d62 <filewrite+0x108>
      int n1 = n - i;
    80004d3a:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004d3e:	84be                	mv	s1,a5
    80004d40:	2781                	sext.w	a5,a5
    80004d42:	f8fb5ce3          	bge	s6,a5,80004cda <filewrite+0x80>
    80004d46:	84de                	mv	s1,s7
    80004d48:	bf49                	j	80004cda <filewrite+0x80>
      iunlock(f->ip);
    80004d4a:	01893503          	ld	a0,24(s2)
    80004d4e:	fffff097          	auipc	ra,0xfffff
    80004d52:	f40080e7          	jalr	-192(ra) # 80003c8e <iunlock>
      end_op();
    80004d56:	00000097          	auipc	ra,0x0
    80004d5a:	8b6080e7          	jalr	-1866(ra) # 8000460c <end_op>
      if(r < 0)
    80004d5e:	fc04d8e3          	bgez	s1,80004d2e <filewrite+0xd4>
    }
    ret = (i == n ? n : -1);
    80004d62:	8552                	mv	a0,s4
    80004d64:	033a1863          	bne	s4,s3,80004d94 <filewrite+0x13a>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004d68:	60a6                	ld	ra,72(sp)
    80004d6a:	6406                	ld	s0,64(sp)
    80004d6c:	74e2                	ld	s1,56(sp)
    80004d6e:	7942                	ld	s2,48(sp)
    80004d70:	79a2                	ld	s3,40(sp)
    80004d72:	7a02                	ld	s4,32(sp)
    80004d74:	6ae2                	ld	s5,24(sp)
    80004d76:	6b42                	ld	s6,16(sp)
    80004d78:	6ba2                	ld	s7,8(sp)
    80004d7a:	6c02                	ld	s8,0(sp)
    80004d7c:	6161                	addi	sp,sp,80
    80004d7e:	8082                	ret
        panic("short filewrite");
    80004d80:	00004517          	auipc	a0,0x4
    80004d84:	9f050513          	addi	a0,a0,-1552 # 80008770 <syscalls+0x280>
    80004d88:	ffffc097          	auipc	ra,0xffffc
    80004d8c:	85c080e7          	jalr	-1956(ra) # 800005e4 <panic>
    int i = 0;
    80004d90:	4981                	li	s3,0
    80004d92:	bfc1                	j	80004d62 <filewrite+0x108>
    ret = (i == n ? n : -1);
    80004d94:	557d                	li	a0,-1
    80004d96:	bfc9                	j	80004d68 <filewrite+0x10e>
    panic("filewrite");
    80004d98:	00004517          	auipc	a0,0x4
    80004d9c:	9e850513          	addi	a0,a0,-1560 # 80008780 <syscalls+0x290>
    80004da0:	ffffc097          	auipc	ra,0xffffc
    80004da4:	844080e7          	jalr	-1980(ra) # 800005e4 <panic>
    return -1;
    80004da8:	557d                	li	a0,-1
}
    80004daa:	8082                	ret
      return -1;
    80004dac:	557d                	li	a0,-1
    80004dae:	bf6d                	j	80004d68 <filewrite+0x10e>
    80004db0:	557d                	li	a0,-1
    80004db2:	bf5d                	j	80004d68 <filewrite+0x10e>

0000000080004db4 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004db4:	7179                	addi	sp,sp,-48
    80004db6:	f406                	sd	ra,40(sp)
    80004db8:	f022                	sd	s0,32(sp)
    80004dba:	ec26                	sd	s1,24(sp)
    80004dbc:	e84a                	sd	s2,16(sp)
    80004dbe:	e44e                	sd	s3,8(sp)
    80004dc0:	e052                	sd	s4,0(sp)
    80004dc2:	1800                	addi	s0,sp,48
    80004dc4:	84aa                	mv	s1,a0
    80004dc6:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004dc8:	0005b023          	sd	zero,0(a1)
    80004dcc:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004dd0:	00000097          	auipc	ra,0x0
    80004dd4:	bd2080e7          	jalr	-1070(ra) # 800049a2 <filealloc>
    80004dd8:	e088                	sd	a0,0(s1)
    80004dda:	c551                	beqz	a0,80004e66 <pipealloc+0xb2>
    80004ddc:	00000097          	auipc	ra,0x0
    80004de0:	bc6080e7          	jalr	-1082(ra) # 800049a2 <filealloc>
    80004de4:	00aa3023          	sd	a0,0(s4)
    80004de8:	c92d                	beqz	a0,80004e5a <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004dea:	ffffc097          	auipc	ra,0xffffc
    80004dee:	f7e080e7          	jalr	-130(ra) # 80000d68 <kalloc>
    80004df2:	892a                	mv	s2,a0
    80004df4:	c125                	beqz	a0,80004e54 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004df6:	4985                	li	s3,1
    80004df8:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004dfc:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004e00:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004e04:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004e08:	00004597          	auipc	a1,0x4
    80004e0c:	98858593          	addi	a1,a1,-1656 # 80008790 <syscalls+0x2a0>
    80004e10:	ffffc097          	auipc	ra,0xffffc
    80004e14:	0da080e7          	jalr	218(ra) # 80000eea <initlock>
  (*f0)->type = FD_PIPE;
    80004e18:	609c                	ld	a5,0(s1)
    80004e1a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004e1e:	609c                	ld	a5,0(s1)
    80004e20:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004e24:	609c                	ld	a5,0(s1)
    80004e26:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004e2a:	609c                	ld	a5,0(s1)
    80004e2c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004e30:	000a3783          	ld	a5,0(s4)
    80004e34:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004e38:	000a3783          	ld	a5,0(s4)
    80004e3c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004e40:	000a3783          	ld	a5,0(s4)
    80004e44:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004e48:	000a3783          	ld	a5,0(s4)
    80004e4c:	0127b823          	sd	s2,16(a5)
  return 0;
    80004e50:	4501                	li	a0,0
    80004e52:	a025                	j	80004e7a <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004e54:	6088                	ld	a0,0(s1)
    80004e56:	e501                	bnez	a0,80004e5e <pipealloc+0xaa>
    80004e58:	a039                	j	80004e66 <pipealloc+0xb2>
    80004e5a:	6088                	ld	a0,0(s1)
    80004e5c:	c51d                	beqz	a0,80004e8a <pipealloc+0xd6>
    fileclose(*f0);
    80004e5e:	00000097          	auipc	ra,0x0
    80004e62:	c00080e7          	jalr	-1024(ra) # 80004a5e <fileclose>
  if(*f1)
    80004e66:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004e6a:	557d                	li	a0,-1
  if(*f1)
    80004e6c:	c799                	beqz	a5,80004e7a <pipealloc+0xc6>
    fileclose(*f1);
    80004e6e:	853e                	mv	a0,a5
    80004e70:	00000097          	auipc	ra,0x0
    80004e74:	bee080e7          	jalr	-1042(ra) # 80004a5e <fileclose>
  return -1;
    80004e78:	557d                	li	a0,-1
}
    80004e7a:	70a2                	ld	ra,40(sp)
    80004e7c:	7402                	ld	s0,32(sp)
    80004e7e:	64e2                	ld	s1,24(sp)
    80004e80:	6942                	ld	s2,16(sp)
    80004e82:	69a2                	ld	s3,8(sp)
    80004e84:	6a02                	ld	s4,0(sp)
    80004e86:	6145                	addi	sp,sp,48
    80004e88:	8082                	ret
  return -1;
    80004e8a:	557d                	li	a0,-1
    80004e8c:	b7fd                	j	80004e7a <pipealloc+0xc6>

0000000080004e8e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004e8e:	1101                	addi	sp,sp,-32
    80004e90:	ec06                	sd	ra,24(sp)
    80004e92:	e822                	sd	s0,16(sp)
    80004e94:	e426                	sd	s1,8(sp)
    80004e96:	e04a                	sd	s2,0(sp)
    80004e98:	1000                	addi	s0,sp,32
    80004e9a:	84aa                	mv	s1,a0
    80004e9c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004e9e:	ffffc097          	auipc	ra,0xffffc
    80004ea2:	0dc080e7          	jalr	220(ra) # 80000f7a <acquire>
  if(writable){
    80004ea6:	02090d63          	beqz	s2,80004ee0 <pipeclose+0x52>
    pi->writeopen = 0;
    80004eaa:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004eae:	21848513          	addi	a0,s1,536
    80004eb2:	ffffe097          	auipc	ra,0xffffe
    80004eb6:	988080e7          	jalr	-1656(ra) # 8000283a <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004eba:	2204b783          	ld	a5,544(s1)
    80004ebe:	eb95                	bnez	a5,80004ef2 <pipeclose+0x64>
    release(&pi->lock);
    80004ec0:	8526                	mv	a0,s1
    80004ec2:	ffffc097          	auipc	ra,0xffffc
    80004ec6:	16c080e7          	jalr	364(ra) # 8000102e <release>
    kfree((char*)pi);
    80004eca:	8526                	mv	a0,s1
    80004ecc:	ffffc097          	auipc	ra,0xffffc
    80004ed0:	bbe080e7          	jalr	-1090(ra) # 80000a8a <kfree>
  } else
    release(&pi->lock);
}
    80004ed4:	60e2                	ld	ra,24(sp)
    80004ed6:	6442                	ld	s0,16(sp)
    80004ed8:	64a2                	ld	s1,8(sp)
    80004eda:	6902                	ld	s2,0(sp)
    80004edc:	6105                	addi	sp,sp,32
    80004ede:	8082                	ret
    pi->readopen = 0;
    80004ee0:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004ee4:	21c48513          	addi	a0,s1,540
    80004ee8:	ffffe097          	auipc	ra,0xffffe
    80004eec:	952080e7          	jalr	-1710(ra) # 8000283a <wakeup>
    80004ef0:	b7e9                	j	80004eba <pipeclose+0x2c>
    release(&pi->lock);
    80004ef2:	8526                	mv	a0,s1
    80004ef4:	ffffc097          	auipc	ra,0xffffc
    80004ef8:	13a080e7          	jalr	314(ra) # 8000102e <release>
}
    80004efc:	bfe1                	j	80004ed4 <pipeclose+0x46>

0000000080004efe <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004efe:	711d                	addi	sp,sp,-96
    80004f00:	ec86                	sd	ra,88(sp)
    80004f02:	e8a2                	sd	s0,80(sp)
    80004f04:	e4a6                	sd	s1,72(sp)
    80004f06:	e0ca                	sd	s2,64(sp)
    80004f08:	fc4e                	sd	s3,56(sp)
    80004f0a:	f852                	sd	s4,48(sp)
    80004f0c:	f456                	sd	s5,40(sp)
    80004f0e:	f05a                	sd	s6,32(sp)
    80004f10:	ec5e                	sd	s7,24(sp)
    80004f12:	e862                	sd	s8,16(sp)
    80004f14:	1080                	addi	s0,sp,96
    80004f16:	84aa                	mv	s1,a0
    80004f18:	8b2e                	mv	s6,a1
    80004f1a:	8ab2                	mv	s5,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    80004f1c:	ffffd097          	auipc	ra,0xffffd
    80004f20:	f8a080e7          	jalr	-118(ra) # 80001ea6 <myproc>
    80004f24:	892a                	mv	s2,a0

  acquire(&pi->lock);
    80004f26:	8526                	mv	a0,s1
    80004f28:	ffffc097          	auipc	ra,0xffffc
    80004f2c:	052080e7          	jalr	82(ra) # 80000f7a <acquire>
  for(i = 0; i < n; i++){
    80004f30:	09505763          	blez	s5,80004fbe <pipewrite+0xc0>
    80004f34:	4b81                	li	s7,0
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || pr->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    80004f36:	21848a13          	addi	s4,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004f3a:	21c48993          	addi	s3,s1,540
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004f3e:	5c7d                	li	s8,-1
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004f40:	2184a783          	lw	a5,536(s1)
    80004f44:	21c4a703          	lw	a4,540(s1)
    80004f48:	2007879b          	addiw	a5,a5,512
    80004f4c:	02f71b63          	bne	a4,a5,80004f82 <pipewrite+0x84>
      if(pi->readopen == 0 || pr->killed){
    80004f50:	2204a783          	lw	a5,544(s1)
    80004f54:	c3d1                	beqz	a5,80004fd8 <pipewrite+0xda>
    80004f56:	03092783          	lw	a5,48(s2)
    80004f5a:	efbd                	bnez	a5,80004fd8 <pipewrite+0xda>
      wakeup(&pi->nread);
    80004f5c:	8552                	mv	a0,s4
    80004f5e:	ffffe097          	auipc	ra,0xffffe
    80004f62:	8dc080e7          	jalr	-1828(ra) # 8000283a <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004f66:	85a6                	mv	a1,s1
    80004f68:	854e                	mv	a0,s3
    80004f6a:	ffffd097          	auipc	ra,0xffffd
    80004f6e:	750080e7          	jalr	1872(ra) # 800026ba <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004f72:	2184a783          	lw	a5,536(s1)
    80004f76:	21c4a703          	lw	a4,540(s1)
    80004f7a:	2007879b          	addiw	a5,a5,512
    80004f7e:	fcf709e3          	beq	a4,a5,80004f50 <pipewrite+0x52>
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004f82:	4685                	li	a3,1
    80004f84:	865a                	mv	a2,s6
    80004f86:	faf40593          	addi	a1,s0,-81
    80004f8a:	05093503          	ld	a0,80(s2)
    80004f8e:	ffffd097          	auipc	ra,0xffffd
    80004f92:	a70080e7          	jalr	-1424(ra) # 800019fe <copyin>
    80004f96:	03850563          	beq	a0,s8,80004fc0 <pipewrite+0xc2>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004f9a:	21c4a783          	lw	a5,540(s1)
    80004f9e:	0017871b          	addiw	a4,a5,1
    80004fa2:	20e4ae23          	sw	a4,540(s1)
    80004fa6:	1ff7f793          	andi	a5,a5,511
    80004faa:	97a6                	add	a5,a5,s1
    80004fac:	faf44703          	lbu	a4,-81(s0)
    80004fb0:	00e78c23          	sb	a4,24(a5)
  for(i = 0; i < n; i++){
    80004fb4:	2b85                	addiw	s7,s7,1
    80004fb6:	0b05                	addi	s6,s6,1
    80004fb8:	f97a94e3          	bne	s5,s7,80004f40 <pipewrite+0x42>
    80004fbc:	a011                	j	80004fc0 <pipewrite+0xc2>
    80004fbe:	4b81                	li	s7,0
  }
  wakeup(&pi->nread);
    80004fc0:	21848513          	addi	a0,s1,536
    80004fc4:	ffffe097          	auipc	ra,0xffffe
    80004fc8:	876080e7          	jalr	-1930(ra) # 8000283a <wakeup>
  release(&pi->lock);
    80004fcc:	8526                	mv	a0,s1
    80004fce:	ffffc097          	auipc	ra,0xffffc
    80004fd2:	060080e7          	jalr	96(ra) # 8000102e <release>
  return i;
    80004fd6:	a039                	j	80004fe4 <pipewrite+0xe6>
        release(&pi->lock);
    80004fd8:	8526                	mv	a0,s1
    80004fda:	ffffc097          	auipc	ra,0xffffc
    80004fde:	054080e7          	jalr	84(ra) # 8000102e <release>
        return -1;
    80004fe2:	5bfd                	li	s7,-1
}
    80004fe4:	855e                	mv	a0,s7
    80004fe6:	60e6                	ld	ra,88(sp)
    80004fe8:	6446                	ld	s0,80(sp)
    80004fea:	64a6                	ld	s1,72(sp)
    80004fec:	6906                	ld	s2,64(sp)
    80004fee:	79e2                	ld	s3,56(sp)
    80004ff0:	7a42                	ld	s4,48(sp)
    80004ff2:	7aa2                	ld	s5,40(sp)
    80004ff4:	7b02                	ld	s6,32(sp)
    80004ff6:	6be2                	ld	s7,24(sp)
    80004ff8:	6c42                	ld	s8,16(sp)
    80004ffa:	6125                	addi	sp,sp,96
    80004ffc:	8082                	ret

0000000080004ffe <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004ffe:	715d                	addi	sp,sp,-80
    80005000:	e486                	sd	ra,72(sp)
    80005002:	e0a2                	sd	s0,64(sp)
    80005004:	fc26                	sd	s1,56(sp)
    80005006:	f84a                	sd	s2,48(sp)
    80005008:	f44e                	sd	s3,40(sp)
    8000500a:	f052                	sd	s4,32(sp)
    8000500c:	ec56                	sd	s5,24(sp)
    8000500e:	e85a                	sd	s6,16(sp)
    80005010:	0880                	addi	s0,sp,80
    80005012:	84aa                	mv	s1,a0
    80005014:	892e                	mv	s2,a1
    80005016:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80005018:	ffffd097          	auipc	ra,0xffffd
    8000501c:	e8e080e7          	jalr	-370(ra) # 80001ea6 <myproc>
    80005020:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80005022:	8526                	mv	a0,s1
    80005024:	ffffc097          	auipc	ra,0xffffc
    80005028:	f56080e7          	jalr	-170(ra) # 80000f7a <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000502c:	2184a703          	lw	a4,536(s1)
    80005030:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005034:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005038:	02f71463          	bne	a4,a5,80005060 <piperead+0x62>
    8000503c:	2244a783          	lw	a5,548(s1)
    80005040:	c385                	beqz	a5,80005060 <piperead+0x62>
    if(pr->killed){
    80005042:	030a2783          	lw	a5,48(s4)
    80005046:	ebc1                	bnez	a5,800050d6 <piperead+0xd8>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005048:	85a6                	mv	a1,s1
    8000504a:	854e                	mv	a0,s3
    8000504c:	ffffd097          	auipc	ra,0xffffd
    80005050:	66e080e7          	jalr	1646(ra) # 800026ba <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005054:	2184a703          	lw	a4,536(s1)
    80005058:	21c4a783          	lw	a5,540(s1)
    8000505c:	fef700e3          	beq	a4,a5,8000503c <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005060:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005062:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005064:	05505363          	blez	s5,800050aa <piperead+0xac>
    if(pi->nread == pi->nwrite)
    80005068:	2184a783          	lw	a5,536(s1)
    8000506c:	21c4a703          	lw	a4,540(s1)
    80005070:	02f70d63          	beq	a4,a5,800050aa <piperead+0xac>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80005074:	0017871b          	addiw	a4,a5,1
    80005078:	20e4ac23          	sw	a4,536(s1)
    8000507c:	1ff7f793          	andi	a5,a5,511
    80005080:	97a6                	add	a5,a5,s1
    80005082:	0187c783          	lbu	a5,24(a5)
    80005086:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000508a:	4685                	li	a3,1
    8000508c:	fbf40613          	addi	a2,s0,-65
    80005090:	85ca                	mv	a1,s2
    80005092:	050a3503          	ld	a0,80(s4)
    80005096:	ffffd097          	auipc	ra,0xffffd
    8000509a:	bdc080e7          	jalr	-1060(ra) # 80001c72 <copyout>
    8000509e:	01650663          	beq	a0,s6,800050aa <piperead+0xac>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800050a2:	2985                	addiw	s3,s3,1
    800050a4:	0905                	addi	s2,s2,1
    800050a6:	fd3a91e3          	bne	s5,s3,80005068 <piperead+0x6a>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800050aa:	21c48513          	addi	a0,s1,540
    800050ae:	ffffd097          	auipc	ra,0xffffd
    800050b2:	78c080e7          	jalr	1932(ra) # 8000283a <wakeup>
  release(&pi->lock);
    800050b6:	8526                	mv	a0,s1
    800050b8:	ffffc097          	auipc	ra,0xffffc
    800050bc:	f76080e7          	jalr	-138(ra) # 8000102e <release>
  return i;
}
    800050c0:	854e                	mv	a0,s3
    800050c2:	60a6                	ld	ra,72(sp)
    800050c4:	6406                	ld	s0,64(sp)
    800050c6:	74e2                	ld	s1,56(sp)
    800050c8:	7942                	ld	s2,48(sp)
    800050ca:	79a2                	ld	s3,40(sp)
    800050cc:	7a02                	ld	s4,32(sp)
    800050ce:	6ae2                	ld	s5,24(sp)
    800050d0:	6b42                	ld	s6,16(sp)
    800050d2:	6161                	addi	sp,sp,80
    800050d4:	8082                	ret
      release(&pi->lock);
    800050d6:	8526                	mv	a0,s1
    800050d8:	ffffc097          	auipc	ra,0xffffc
    800050dc:	f56080e7          	jalr	-170(ra) # 8000102e <release>
      return -1;
    800050e0:	59fd                	li	s3,-1
    800050e2:	bff9                	j	800050c0 <piperead+0xc2>

00000000800050e4 <exec>:
#include "types.h"

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset,
                   uint sz);

int exec(char *path, char **argv) {
    800050e4:	de010113          	addi	sp,sp,-544
    800050e8:	20113c23          	sd	ra,536(sp)
    800050ec:	20813823          	sd	s0,528(sp)
    800050f0:	20913423          	sd	s1,520(sp)
    800050f4:	21213023          	sd	s2,512(sp)
    800050f8:	ffce                	sd	s3,504(sp)
    800050fa:	fbd2                	sd	s4,496(sp)
    800050fc:	f7d6                	sd	s5,488(sp)
    800050fe:	f3da                	sd	s6,480(sp)
    80005100:	efde                	sd	s7,472(sp)
    80005102:	ebe2                	sd	s8,464(sp)
    80005104:	e7e6                	sd	s9,456(sp)
    80005106:	e3ea                	sd	s10,448(sp)
    80005108:	ff6e                	sd	s11,440(sp)
    8000510a:	1400                	addi	s0,sp,544
    8000510c:	892a                	mv	s2,a0
    8000510e:	dea43423          	sd	a0,-536(s0)
    80005112:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG + 1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80005116:	ffffd097          	auipc	ra,0xffffd
    8000511a:	d90080e7          	jalr	-624(ra) # 80001ea6 <myproc>
    8000511e:	84aa                	mv	s1,a0

  begin_op();
    80005120:	fffff097          	auipc	ra,0xfffff
    80005124:	46c080e7          	jalr	1132(ra) # 8000458c <begin_op>

  if ((ip = namei(path)) == 0) {
    80005128:	854a                	mv	a0,s2
    8000512a:	fffff097          	auipc	ra,0xfffff
    8000512e:	256080e7          	jalr	598(ra) # 80004380 <namei>
    80005132:	c93d                	beqz	a0,800051a8 <exec+0xc4>
    80005134:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80005136:	fffff097          	auipc	ra,0xfffff
    8000513a:	a96080e7          	jalr	-1386(ra) # 80003bcc <ilock>

  // Check ELF header
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000513e:	04000713          	li	a4,64
    80005142:	4681                	li	a3,0
    80005144:	e4840613          	addi	a2,s0,-440
    80005148:	4581                	li	a1,0
    8000514a:	8556                	mv	a0,s5
    8000514c:	fffff097          	auipc	ra,0xfffff
    80005150:	d34080e7          	jalr	-716(ra) # 80003e80 <readi>
    80005154:	04000793          	li	a5,64
    80005158:	00f51a63          	bne	a0,a5,8000516c <exec+0x88>
    goto bad;
  if (elf.magic != ELF_MAGIC)
    8000515c:	e4842703          	lw	a4,-440(s0)
    80005160:	464c47b7          	lui	a5,0x464c4
    80005164:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005168:	04f70663          	beq	a4,a5,800051b4 <exec+0xd0>

bad:
  if (pagetable)
    proc_freepagetable(pagetable, sz);
  if (ip) {
    iunlockput(ip);
    8000516c:	8556                	mv	a0,s5
    8000516e:	fffff097          	auipc	ra,0xfffff
    80005172:	cc0080e7          	jalr	-832(ra) # 80003e2e <iunlockput>
    end_op();
    80005176:	fffff097          	auipc	ra,0xfffff
    8000517a:	496080e7          	jalr	1174(ra) # 8000460c <end_op>
  }
  return -1;
    8000517e:	557d                	li	a0,-1
}
    80005180:	21813083          	ld	ra,536(sp)
    80005184:	21013403          	ld	s0,528(sp)
    80005188:	20813483          	ld	s1,520(sp)
    8000518c:	20013903          	ld	s2,512(sp)
    80005190:	79fe                	ld	s3,504(sp)
    80005192:	7a5e                	ld	s4,496(sp)
    80005194:	7abe                	ld	s5,488(sp)
    80005196:	7b1e                	ld	s6,480(sp)
    80005198:	6bfe                	ld	s7,472(sp)
    8000519a:	6c5e                	ld	s8,464(sp)
    8000519c:	6cbe                	ld	s9,456(sp)
    8000519e:	6d1e                	ld	s10,448(sp)
    800051a0:	7dfa                	ld	s11,440(sp)
    800051a2:	22010113          	addi	sp,sp,544
    800051a6:	8082                	ret
    end_op();
    800051a8:	fffff097          	auipc	ra,0xfffff
    800051ac:	464080e7          	jalr	1124(ra) # 8000460c <end_op>
    return -1;
    800051b0:	557d                	li	a0,-1
    800051b2:	b7f9                	j	80005180 <exec+0x9c>
  if ((pagetable = proc_pagetable(p)) == 0)
    800051b4:	8526                	mv	a0,s1
    800051b6:	ffffd097          	auipc	ra,0xffffd
    800051ba:	db4080e7          	jalr	-588(ra) # 80001f6a <proc_pagetable>
    800051be:	8b2a                	mv	s6,a0
    800051c0:	d555                	beqz	a0,8000516c <exec+0x88>
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800051c2:	e6842783          	lw	a5,-408(s0)
    800051c6:	e8045703          	lhu	a4,-384(s0)
    800051ca:	c735                	beqz	a4,80005236 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG + 1], stackbase;
    800051cc:	4481                	li	s1,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800051ce:	e0043423          	sd	zero,-504(s0)
    if (ph.vaddr % PGSIZE != 0)
    800051d2:	6a05                	lui	s4,0x1
    800051d4:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800051d8:	dee43023          	sd	a4,-544(s0)
  uint64 pa;

  if ((va % PGSIZE) != 0)
    panic("loadseg: va must be page aligned");

  for (i = 0; i < sz; i += PGSIZE) {
    800051dc:	6d85                	lui	s11,0x1
    800051de:	7d7d                	lui	s10,0xfffff
    800051e0:	ac1d                	j	80005416 <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if (pa == 0)
      panic("loadseg: address should exist");
    800051e2:	00003517          	auipc	a0,0x3
    800051e6:	5b650513          	addi	a0,a0,1462 # 80008798 <syscalls+0x2a8>
    800051ea:	ffffb097          	auipc	ra,0xffffb
    800051ee:	3fa080e7          	jalr	1018(ra) # 800005e4 <panic>
    if (sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n)
    800051f2:	874a                	mv	a4,s2
    800051f4:	009c86bb          	addw	a3,s9,s1
    800051f8:	4581                	li	a1,0
    800051fa:	8556                	mv	a0,s5
    800051fc:	fffff097          	auipc	ra,0xfffff
    80005200:	c84080e7          	jalr	-892(ra) # 80003e80 <readi>
    80005204:	2501                	sext.w	a0,a0
    80005206:	1aa91863          	bne	s2,a0,800053b6 <exec+0x2d2>
  for (i = 0; i < sz; i += PGSIZE) {
    8000520a:	009d84bb          	addw	s1,s11,s1
    8000520e:	013d09bb          	addw	s3,s10,s3
    80005212:	1f74f263          	bgeu	s1,s7,800053f6 <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    80005216:	02049593          	slli	a1,s1,0x20
    8000521a:	9181                	srli	a1,a1,0x20
    8000521c:	95e2                	add	a1,a1,s8
    8000521e:	855a                	mv	a0,s6
    80005220:	ffffc097          	auipc	ra,0xffffc
    80005224:	1da080e7          	jalr	474(ra) # 800013fa <walkaddr>
    80005228:	862a                	mv	a2,a0
    if (pa == 0)
    8000522a:	dd45                	beqz	a0,800051e2 <exec+0xfe>
      n = PGSIZE;
    8000522c:	8952                	mv	s2,s4
    if (sz - i < PGSIZE)
    8000522e:	fd49f2e3          	bgeu	s3,s4,800051f2 <exec+0x10e>
      n = sz - i;
    80005232:	894e                	mv	s2,s3
    80005234:	bf7d                	j	800051f2 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG + 1], stackbase;
    80005236:	4481                	li	s1,0
  iunlockput(ip);
    80005238:	8556                	mv	a0,s5
    8000523a:	fffff097          	auipc	ra,0xfffff
    8000523e:	bf4080e7          	jalr	-1036(ra) # 80003e2e <iunlockput>
  end_op();
    80005242:	fffff097          	auipc	ra,0xfffff
    80005246:	3ca080e7          	jalr	970(ra) # 8000460c <end_op>
  p = myproc();
    8000524a:	ffffd097          	auipc	ra,0xffffd
    8000524e:	c5c080e7          	jalr	-932(ra) # 80001ea6 <myproc>
    80005252:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80005254:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80005258:	6785                	lui	a5,0x1
    8000525a:	17fd                	addi	a5,a5,-1
    8000525c:	94be                	add	s1,s1,a5
    8000525e:	77fd                	lui	a5,0xfffff
    80005260:	8fe5                	and	a5,a5,s1
    80005262:	def43c23          	sd	a5,-520(s0)
  if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE)) == 0)
    80005266:	6609                	lui	a2,0x2
    80005268:	963e                	add	a2,a2,a5
    8000526a:	85be                	mv	a1,a5
    8000526c:	855a                	mv	a0,s6
    8000526e:	ffffc097          	auipc	ra,0xffffc
    80005272:	552080e7          	jalr	1362(ra) # 800017c0 <uvmalloc>
    80005276:	8c2a                	mv	s8,a0
  ip = 0;
    80005278:	4a81                	li	s5,0
  if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE)) == 0)
    8000527a:	12050e63          	beqz	a0,800053b6 <exec+0x2d2>
  uvmclear(pagetable, sz - 2 * PGSIZE);
    8000527e:	75f9                	lui	a1,0xffffe
    80005280:	95aa                	add	a1,a1,a0
    80005282:	855a                	mv	a0,s6
    80005284:	ffffc097          	auipc	ra,0xffffc
    80005288:	748080e7          	jalr	1864(ra) # 800019cc <uvmclear>
  stackbase = sp - PGSIZE;
    8000528c:	7afd                	lui	s5,0xfffff
    8000528e:	9ae2                	add	s5,s5,s8
  for (argc = 0; argv[argc]; argc++) {
    80005290:	df043783          	ld	a5,-528(s0)
    80005294:	6388                	ld	a0,0(a5)
    80005296:	c925                	beqz	a0,80005306 <exec+0x222>
    80005298:	e8840993          	addi	s3,s0,-376
    8000529c:	f8840c93          	addi	s9,s0,-120
  sp = sz;
    800052a0:	8962                	mv	s2,s8
  for (argc = 0; argv[argc]; argc++) {
    800052a2:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800052a4:	ffffc097          	auipc	ra,0xffffc
    800052a8:	f56080e7          	jalr	-170(ra) # 800011fa <strlen>
    800052ac:	0015079b          	addiw	a5,a0,1
    800052b0:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800052b4:	ff097913          	andi	s2,s2,-16
    if (sp < stackbase)
    800052b8:	13596363          	bltu	s2,s5,800053de <exec+0x2fa>
    if (copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800052bc:	df043d83          	ld	s11,-528(s0)
    800052c0:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800052c4:	8552                	mv	a0,s4
    800052c6:	ffffc097          	auipc	ra,0xffffc
    800052ca:	f34080e7          	jalr	-204(ra) # 800011fa <strlen>
    800052ce:	0015069b          	addiw	a3,a0,1
    800052d2:	8652                	mv	a2,s4
    800052d4:	85ca                	mv	a1,s2
    800052d6:	855a                	mv	a0,s6
    800052d8:	ffffd097          	auipc	ra,0xffffd
    800052dc:	99a080e7          	jalr	-1638(ra) # 80001c72 <copyout>
    800052e0:	10054363          	bltz	a0,800053e6 <exec+0x302>
    ustack[argc] = sp;
    800052e4:	0129b023          	sd	s2,0(s3)
  for (argc = 0; argv[argc]; argc++) {
    800052e8:	0485                	addi	s1,s1,1
    800052ea:	008d8793          	addi	a5,s11,8
    800052ee:	def43823          	sd	a5,-528(s0)
    800052f2:	008db503          	ld	a0,8(s11)
    800052f6:	c911                	beqz	a0,8000530a <exec+0x226>
    if (argc >= MAXARG)
    800052f8:	09a1                	addi	s3,s3,8
    800052fa:	fb3c95e3          	bne	s9,s3,800052a4 <exec+0x1c0>
  sz = sz1;
    800052fe:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005302:	4a81                	li	s5,0
    80005304:	a84d                	j	800053b6 <exec+0x2d2>
  sp = sz;
    80005306:	8962                	mv	s2,s8
  for (argc = 0; argv[argc]; argc++) {
    80005308:	4481                	li	s1,0
  ustack[argc] = 0;
    8000530a:	00349793          	slli	a5,s1,0x3
    8000530e:	f9040713          	addi	a4,s0,-112
    80005312:	97ba                	add	a5,a5,a4
    80005314:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ffb8ef8>
  sp -= (argc + 1) * sizeof(uint64);
    80005318:	00148693          	addi	a3,s1,1
    8000531c:	068e                	slli	a3,a3,0x3
    8000531e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005322:	ff097913          	andi	s2,s2,-16
  if (sp < stackbase)
    80005326:	01597663          	bgeu	s2,s5,80005332 <exec+0x24e>
  sz = sz1;
    8000532a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000532e:	4a81                	li	s5,0
    80005330:	a059                	j	800053b6 <exec+0x2d2>
  if (copyout(pagetable, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) < 0)
    80005332:	e8840613          	addi	a2,s0,-376
    80005336:	85ca                	mv	a1,s2
    80005338:	855a                	mv	a0,s6
    8000533a:	ffffd097          	auipc	ra,0xffffd
    8000533e:	938080e7          	jalr	-1736(ra) # 80001c72 <copyout>
    80005342:	0a054663          	bltz	a0,800053ee <exec+0x30a>
  p->trapframe->a1 = sp;
    80005346:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    8000534a:	0727bc23          	sd	s2,120(a5)
  for (last = s = path; *s; s++)
    8000534e:	de843783          	ld	a5,-536(s0)
    80005352:	0007c703          	lbu	a4,0(a5)
    80005356:	cf11                	beqz	a4,80005372 <exec+0x28e>
    80005358:	0785                	addi	a5,a5,1
    if (*s == '/')
    8000535a:	02f00693          	li	a3,47
    8000535e:	a039                	j	8000536c <exec+0x288>
      last = s + 1;
    80005360:	def43423          	sd	a5,-536(s0)
  for (last = s = path; *s; s++)
    80005364:	0785                	addi	a5,a5,1
    80005366:	fff7c703          	lbu	a4,-1(a5)
    8000536a:	c701                	beqz	a4,80005372 <exec+0x28e>
    if (*s == '/')
    8000536c:	fed71ce3          	bne	a4,a3,80005364 <exec+0x280>
    80005370:	bfc5                	j	80005360 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    80005372:	4641                	li	a2,16
    80005374:	de843583          	ld	a1,-536(s0)
    80005378:	158b8513          	addi	a0,s7,344
    8000537c:	ffffc097          	auipc	ra,0xffffc
    80005380:	e4c080e7          	jalr	-436(ra) # 800011c8 <safestrcpy>
  oldpagetable = p->pagetable;
    80005384:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80005388:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    8000538c:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry; // initial program counter = main
    80005390:	058bb783          	ld	a5,88(s7)
    80005394:	e6043703          	ld	a4,-416(s0)
    80005398:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;         // initial stack pointer
    8000539a:	058bb783          	ld	a5,88(s7)
    8000539e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800053a2:	85ea                	mv	a1,s10
    800053a4:	ffffd097          	auipc	ra,0xffffd
    800053a8:	c62080e7          	jalr	-926(ra) # 80002006 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800053ac:	0004851b          	sext.w	a0,s1
    800053b0:	bbc1                	j	80005180 <exec+0x9c>
    800053b2:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    800053b6:	df843583          	ld	a1,-520(s0)
    800053ba:	855a                	mv	a0,s6
    800053bc:	ffffd097          	auipc	ra,0xffffd
    800053c0:	c4a080e7          	jalr	-950(ra) # 80002006 <proc_freepagetable>
  if (ip) {
    800053c4:	da0a94e3          	bnez	s5,8000516c <exec+0x88>
  return -1;
    800053c8:	557d                	li	a0,-1
    800053ca:	bb5d                	j	80005180 <exec+0x9c>
    800053cc:	de943c23          	sd	s1,-520(s0)
    800053d0:	b7dd                	j	800053b6 <exec+0x2d2>
    800053d2:	de943c23          	sd	s1,-520(s0)
    800053d6:	b7c5                	j	800053b6 <exec+0x2d2>
    800053d8:	de943c23          	sd	s1,-520(s0)
    800053dc:	bfe9                	j	800053b6 <exec+0x2d2>
  sz = sz1;
    800053de:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800053e2:	4a81                	li	s5,0
    800053e4:	bfc9                	j	800053b6 <exec+0x2d2>
  sz = sz1;
    800053e6:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800053ea:	4a81                	li	s5,0
    800053ec:	b7e9                	j	800053b6 <exec+0x2d2>
  sz = sz1;
    800053ee:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800053f2:	4a81                	li	s5,0
    800053f4:	b7c9                	j	800053b6 <exec+0x2d2>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800053f6:	df843483          	ld	s1,-520(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800053fa:	e0843783          	ld	a5,-504(s0)
    800053fe:	0017869b          	addiw	a3,a5,1
    80005402:	e0d43423          	sd	a3,-504(s0)
    80005406:	e0043783          	ld	a5,-512(s0)
    8000540a:	0387879b          	addiw	a5,a5,56
    8000540e:	e8045703          	lhu	a4,-384(s0)
    80005412:	e2e6d3e3          	bge	a3,a4,80005238 <exec+0x154>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005416:	2781                	sext.w	a5,a5
    80005418:	e0f43023          	sd	a5,-512(s0)
    8000541c:	03800713          	li	a4,56
    80005420:	86be                	mv	a3,a5
    80005422:	e1040613          	addi	a2,s0,-496
    80005426:	4581                	li	a1,0
    80005428:	8556                	mv	a0,s5
    8000542a:	fffff097          	auipc	ra,0xfffff
    8000542e:	a56080e7          	jalr	-1450(ra) # 80003e80 <readi>
    80005432:	03800793          	li	a5,56
    80005436:	f6f51ee3          	bne	a0,a5,800053b2 <exec+0x2ce>
    if (ph.type != ELF_PROG_LOAD)
    8000543a:	e1042783          	lw	a5,-496(s0)
    8000543e:	4705                	li	a4,1
    80005440:	fae79de3          	bne	a5,a4,800053fa <exec+0x316>
    if (ph.memsz < ph.filesz)
    80005444:	e3843603          	ld	a2,-456(s0)
    80005448:	e3043783          	ld	a5,-464(s0)
    8000544c:	f8f660e3          	bltu	a2,a5,800053cc <exec+0x2e8>
    if (ph.vaddr + ph.memsz < ph.vaddr)
    80005450:	e2043783          	ld	a5,-480(s0)
    80005454:	963e                	add	a2,a2,a5
    80005456:	f6f66ee3          	bltu	a2,a5,800053d2 <exec+0x2ee>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000545a:	85a6                	mv	a1,s1
    8000545c:	855a                	mv	a0,s6
    8000545e:	ffffc097          	auipc	ra,0xffffc
    80005462:	362080e7          	jalr	866(ra) # 800017c0 <uvmalloc>
    80005466:	dea43c23          	sd	a0,-520(s0)
    8000546a:	d53d                	beqz	a0,800053d8 <exec+0x2f4>
    if (ph.vaddr % PGSIZE != 0)
    8000546c:	e2043c03          	ld	s8,-480(s0)
    80005470:	de043783          	ld	a5,-544(s0)
    80005474:	00fc77b3          	and	a5,s8,a5
    80005478:	ff9d                	bnez	a5,800053b6 <exec+0x2d2>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000547a:	e1842c83          	lw	s9,-488(s0)
    8000547e:	e3042b83          	lw	s7,-464(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    80005482:	f60b8ae3          	beqz	s7,800053f6 <exec+0x312>
    80005486:	89de                	mv	s3,s7
    80005488:	4481                	li	s1,0
    8000548a:	b371                	j	80005216 <exec+0x132>

000000008000548c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000548c:	7179                	addi	sp,sp,-48
    8000548e:	f406                	sd	ra,40(sp)
    80005490:	f022                	sd	s0,32(sp)
    80005492:	ec26                	sd	s1,24(sp)
    80005494:	e84a                	sd	s2,16(sp)
    80005496:	1800                	addi	s0,sp,48
    80005498:	892e                	mv	s2,a1
    8000549a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000549c:	fdc40593          	addi	a1,s0,-36
    800054a0:	ffffe097          	auipc	ra,0xffffe
    800054a4:	b78080e7          	jalr	-1160(ra) # 80003018 <argint>
    800054a8:	04054063          	bltz	a0,800054e8 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800054ac:	fdc42703          	lw	a4,-36(s0)
    800054b0:	47bd                	li	a5,15
    800054b2:	02e7ed63          	bltu	a5,a4,800054ec <argfd+0x60>
    800054b6:	ffffd097          	auipc	ra,0xffffd
    800054ba:	9f0080e7          	jalr	-1552(ra) # 80001ea6 <myproc>
    800054be:	fdc42703          	lw	a4,-36(s0)
    800054c2:	01a70793          	addi	a5,a4,26
    800054c6:	078e                	slli	a5,a5,0x3
    800054c8:	953e                	add	a0,a0,a5
    800054ca:	611c                	ld	a5,0(a0)
    800054cc:	c395                	beqz	a5,800054f0 <argfd+0x64>
    return -1;
  if(pfd)
    800054ce:	00090463          	beqz	s2,800054d6 <argfd+0x4a>
    *pfd = fd;
    800054d2:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800054d6:	4501                	li	a0,0
  if(pf)
    800054d8:	c091                	beqz	s1,800054dc <argfd+0x50>
    *pf = f;
    800054da:	e09c                	sd	a5,0(s1)
}
    800054dc:	70a2                	ld	ra,40(sp)
    800054de:	7402                	ld	s0,32(sp)
    800054e0:	64e2                	ld	s1,24(sp)
    800054e2:	6942                	ld	s2,16(sp)
    800054e4:	6145                	addi	sp,sp,48
    800054e6:	8082                	ret
    return -1;
    800054e8:	557d                	li	a0,-1
    800054ea:	bfcd                	j	800054dc <argfd+0x50>
    return -1;
    800054ec:	557d                	li	a0,-1
    800054ee:	b7fd                	j	800054dc <argfd+0x50>
    800054f0:	557d                	li	a0,-1
    800054f2:	b7ed                	j	800054dc <argfd+0x50>

00000000800054f4 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800054f4:	1101                	addi	sp,sp,-32
    800054f6:	ec06                	sd	ra,24(sp)
    800054f8:	e822                	sd	s0,16(sp)
    800054fa:	e426                	sd	s1,8(sp)
    800054fc:	1000                	addi	s0,sp,32
    800054fe:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005500:	ffffd097          	auipc	ra,0xffffd
    80005504:	9a6080e7          	jalr	-1626(ra) # 80001ea6 <myproc>
    80005508:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000550a:	0d050793          	addi	a5,a0,208
    8000550e:	4501                	li	a0,0
    80005510:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005512:	6398                	ld	a4,0(a5)
    80005514:	cb19                	beqz	a4,8000552a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005516:	2505                	addiw	a0,a0,1
    80005518:	07a1                	addi	a5,a5,8
    8000551a:	fed51ce3          	bne	a0,a3,80005512 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000551e:	557d                	li	a0,-1
}
    80005520:	60e2                	ld	ra,24(sp)
    80005522:	6442                	ld	s0,16(sp)
    80005524:	64a2                	ld	s1,8(sp)
    80005526:	6105                	addi	sp,sp,32
    80005528:	8082                	ret
      p->ofile[fd] = f;
    8000552a:	01a50793          	addi	a5,a0,26
    8000552e:	078e                	slli	a5,a5,0x3
    80005530:	963e                	add	a2,a2,a5
    80005532:	e204                	sd	s1,0(a2)
      return fd;
    80005534:	b7f5                	j	80005520 <fdalloc+0x2c>

0000000080005536 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005536:	715d                	addi	sp,sp,-80
    80005538:	e486                	sd	ra,72(sp)
    8000553a:	e0a2                	sd	s0,64(sp)
    8000553c:	fc26                	sd	s1,56(sp)
    8000553e:	f84a                	sd	s2,48(sp)
    80005540:	f44e                	sd	s3,40(sp)
    80005542:	f052                	sd	s4,32(sp)
    80005544:	ec56                	sd	s5,24(sp)
    80005546:	0880                	addi	s0,sp,80
    80005548:	89ae                	mv	s3,a1
    8000554a:	8ab2                	mv	s5,a2
    8000554c:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000554e:	fb040593          	addi	a1,s0,-80
    80005552:	fffff097          	auipc	ra,0xfffff
    80005556:	e4c080e7          	jalr	-436(ra) # 8000439e <nameiparent>
    8000555a:	892a                	mv	s2,a0
    8000555c:	12050e63          	beqz	a0,80005698 <create+0x162>
    return 0;

  ilock(dp);
    80005560:	ffffe097          	auipc	ra,0xffffe
    80005564:	66c080e7          	jalr	1644(ra) # 80003bcc <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005568:	4601                	li	a2,0
    8000556a:	fb040593          	addi	a1,s0,-80
    8000556e:	854a                	mv	a0,s2
    80005570:	fffff097          	auipc	ra,0xfffff
    80005574:	b3e080e7          	jalr	-1218(ra) # 800040ae <dirlookup>
    80005578:	84aa                	mv	s1,a0
    8000557a:	c921                	beqz	a0,800055ca <create+0x94>
    iunlockput(dp);
    8000557c:	854a                	mv	a0,s2
    8000557e:	fffff097          	auipc	ra,0xfffff
    80005582:	8b0080e7          	jalr	-1872(ra) # 80003e2e <iunlockput>
    ilock(ip);
    80005586:	8526                	mv	a0,s1
    80005588:	ffffe097          	auipc	ra,0xffffe
    8000558c:	644080e7          	jalr	1604(ra) # 80003bcc <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005590:	2981                	sext.w	s3,s3
    80005592:	4789                	li	a5,2
    80005594:	02f99463          	bne	s3,a5,800055bc <create+0x86>
    80005598:	0444d783          	lhu	a5,68(s1)
    8000559c:	37f9                	addiw	a5,a5,-2
    8000559e:	17c2                	slli	a5,a5,0x30
    800055a0:	93c1                	srli	a5,a5,0x30
    800055a2:	4705                	li	a4,1
    800055a4:	00f76c63          	bltu	a4,a5,800055bc <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800055a8:	8526                	mv	a0,s1
    800055aa:	60a6                	ld	ra,72(sp)
    800055ac:	6406                	ld	s0,64(sp)
    800055ae:	74e2                	ld	s1,56(sp)
    800055b0:	7942                	ld	s2,48(sp)
    800055b2:	79a2                	ld	s3,40(sp)
    800055b4:	7a02                	ld	s4,32(sp)
    800055b6:	6ae2                	ld	s5,24(sp)
    800055b8:	6161                	addi	sp,sp,80
    800055ba:	8082                	ret
    iunlockput(ip);
    800055bc:	8526                	mv	a0,s1
    800055be:	fffff097          	auipc	ra,0xfffff
    800055c2:	870080e7          	jalr	-1936(ra) # 80003e2e <iunlockput>
    return 0;
    800055c6:	4481                	li	s1,0
    800055c8:	b7c5                	j	800055a8 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800055ca:	85ce                	mv	a1,s3
    800055cc:	00092503          	lw	a0,0(s2)
    800055d0:	ffffe097          	auipc	ra,0xffffe
    800055d4:	464080e7          	jalr	1124(ra) # 80003a34 <ialloc>
    800055d8:	84aa                	mv	s1,a0
    800055da:	c521                	beqz	a0,80005622 <create+0xec>
  ilock(ip);
    800055dc:	ffffe097          	auipc	ra,0xffffe
    800055e0:	5f0080e7          	jalr	1520(ra) # 80003bcc <ilock>
  ip->major = major;
    800055e4:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800055e8:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800055ec:	4a05                	li	s4,1
    800055ee:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    800055f2:	8526                	mv	a0,s1
    800055f4:	ffffe097          	auipc	ra,0xffffe
    800055f8:	50e080e7          	jalr	1294(ra) # 80003b02 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800055fc:	2981                	sext.w	s3,s3
    800055fe:	03498a63          	beq	s3,s4,80005632 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80005602:	40d0                	lw	a2,4(s1)
    80005604:	fb040593          	addi	a1,s0,-80
    80005608:	854a                	mv	a0,s2
    8000560a:	fffff097          	auipc	ra,0xfffff
    8000560e:	cb4080e7          	jalr	-844(ra) # 800042be <dirlink>
    80005612:	06054b63          	bltz	a0,80005688 <create+0x152>
  iunlockput(dp);
    80005616:	854a                	mv	a0,s2
    80005618:	fffff097          	auipc	ra,0xfffff
    8000561c:	816080e7          	jalr	-2026(ra) # 80003e2e <iunlockput>
  return ip;
    80005620:	b761                	j	800055a8 <create+0x72>
    panic("create: ialloc");
    80005622:	00003517          	auipc	a0,0x3
    80005626:	19650513          	addi	a0,a0,406 # 800087b8 <syscalls+0x2c8>
    8000562a:	ffffb097          	auipc	ra,0xffffb
    8000562e:	fba080e7          	jalr	-70(ra) # 800005e4 <panic>
    dp->nlink++;  // for ".."
    80005632:	04a95783          	lhu	a5,74(s2)
    80005636:	2785                	addiw	a5,a5,1
    80005638:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000563c:	854a                	mv	a0,s2
    8000563e:	ffffe097          	auipc	ra,0xffffe
    80005642:	4c4080e7          	jalr	1220(ra) # 80003b02 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005646:	40d0                	lw	a2,4(s1)
    80005648:	00003597          	auipc	a1,0x3
    8000564c:	18058593          	addi	a1,a1,384 # 800087c8 <syscalls+0x2d8>
    80005650:	8526                	mv	a0,s1
    80005652:	fffff097          	auipc	ra,0xfffff
    80005656:	c6c080e7          	jalr	-916(ra) # 800042be <dirlink>
    8000565a:	00054f63          	bltz	a0,80005678 <create+0x142>
    8000565e:	00492603          	lw	a2,4(s2)
    80005662:	00003597          	auipc	a1,0x3
    80005666:	16e58593          	addi	a1,a1,366 # 800087d0 <syscalls+0x2e0>
    8000566a:	8526                	mv	a0,s1
    8000566c:	fffff097          	auipc	ra,0xfffff
    80005670:	c52080e7          	jalr	-942(ra) # 800042be <dirlink>
    80005674:	f80557e3          	bgez	a0,80005602 <create+0xcc>
      panic("create dots");
    80005678:	00003517          	auipc	a0,0x3
    8000567c:	16050513          	addi	a0,a0,352 # 800087d8 <syscalls+0x2e8>
    80005680:	ffffb097          	auipc	ra,0xffffb
    80005684:	f64080e7          	jalr	-156(ra) # 800005e4 <panic>
    panic("create: dirlink");
    80005688:	00003517          	auipc	a0,0x3
    8000568c:	16050513          	addi	a0,a0,352 # 800087e8 <syscalls+0x2f8>
    80005690:	ffffb097          	auipc	ra,0xffffb
    80005694:	f54080e7          	jalr	-172(ra) # 800005e4 <panic>
    return 0;
    80005698:	84aa                	mv	s1,a0
    8000569a:	b739                	j	800055a8 <create+0x72>

000000008000569c <sys_dup>:
{
    8000569c:	7179                	addi	sp,sp,-48
    8000569e:	f406                	sd	ra,40(sp)
    800056a0:	f022                	sd	s0,32(sp)
    800056a2:	ec26                	sd	s1,24(sp)
    800056a4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800056a6:	fd840613          	addi	a2,s0,-40
    800056aa:	4581                	li	a1,0
    800056ac:	4501                	li	a0,0
    800056ae:	00000097          	auipc	ra,0x0
    800056b2:	dde080e7          	jalr	-546(ra) # 8000548c <argfd>
    return -1;
    800056b6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800056b8:	02054363          	bltz	a0,800056de <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800056bc:	fd843503          	ld	a0,-40(s0)
    800056c0:	00000097          	auipc	ra,0x0
    800056c4:	e34080e7          	jalr	-460(ra) # 800054f4 <fdalloc>
    800056c8:	84aa                	mv	s1,a0
    return -1;
    800056ca:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800056cc:	00054963          	bltz	a0,800056de <sys_dup+0x42>
  filedup(f);
    800056d0:	fd843503          	ld	a0,-40(s0)
    800056d4:	fffff097          	auipc	ra,0xfffff
    800056d8:	338080e7          	jalr	824(ra) # 80004a0c <filedup>
  return fd;
    800056dc:	87a6                	mv	a5,s1
}
    800056de:	853e                	mv	a0,a5
    800056e0:	70a2                	ld	ra,40(sp)
    800056e2:	7402                	ld	s0,32(sp)
    800056e4:	64e2                	ld	s1,24(sp)
    800056e6:	6145                	addi	sp,sp,48
    800056e8:	8082                	ret

00000000800056ea <sys_read>:
{
    800056ea:	7179                	addi	sp,sp,-48
    800056ec:	f406                	sd	ra,40(sp)
    800056ee:	f022                	sd	s0,32(sp)
    800056f0:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800056f2:	fe840613          	addi	a2,s0,-24
    800056f6:	4581                	li	a1,0
    800056f8:	4501                	li	a0,0
    800056fa:	00000097          	auipc	ra,0x0
    800056fe:	d92080e7          	jalr	-622(ra) # 8000548c <argfd>
    return -1;
    80005702:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005704:	04054163          	bltz	a0,80005746 <sys_read+0x5c>
    80005708:	fe440593          	addi	a1,s0,-28
    8000570c:	4509                	li	a0,2
    8000570e:	ffffe097          	auipc	ra,0xffffe
    80005712:	90a080e7          	jalr	-1782(ra) # 80003018 <argint>
    return -1;
    80005716:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005718:	02054763          	bltz	a0,80005746 <sys_read+0x5c>
    8000571c:	fd840593          	addi	a1,s0,-40
    80005720:	4505                	li	a0,1
    80005722:	ffffe097          	auipc	ra,0xffffe
    80005726:	918080e7          	jalr	-1768(ra) # 8000303a <argaddr>
    return -1;
    8000572a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000572c:	00054d63          	bltz	a0,80005746 <sys_read+0x5c>
  return fileread(f, p, n);
    80005730:	fe442603          	lw	a2,-28(s0)
    80005734:	fd843583          	ld	a1,-40(s0)
    80005738:	fe843503          	ld	a0,-24(s0)
    8000573c:	fffff097          	auipc	ra,0xfffff
    80005740:	45c080e7          	jalr	1116(ra) # 80004b98 <fileread>
    80005744:	87aa                	mv	a5,a0
}
    80005746:	853e                	mv	a0,a5
    80005748:	70a2                	ld	ra,40(sp)
    8000574a:	7402                	ld	s0,32(sp)
    8000574c:	6145                	addi	sp,sp,48
    8000574e:	8082                	ret

0000000080005750 <sys_write>:
{
    80005750:	7179                	addi	sp,sp,-48
    80005752:	f406                	sd	ra,40(sp)
    80005754:	f022                	sd	s0,32(sp)
    80005756:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005758:	fe840613          	addi	a2,s0,-24
    8000575c:	4581                	li	a1,0
    8000575e:	4501                	li	a0,0
    80005760:	00000097          	auipc	ra,0x0
    80005764:	d2c080e7          	jalr	-724(ra) # 8000548c <argfd>
    return -1;
    80005768:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000576a:	04054163          	bltz	a0,800057ac <sys_write+0x5c>
    8000576e:	fe440593          	addi	a1,s0,-28
    80005772:	4509                	li	a0,2
    80005774:	ffffe097          	auipc	ra,0xffffe
    80005778:	8a4080e7          	jalr	-1884(ra) # 80003018 <argint>
    return -1;
    8000577c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000577e:	02054763          	bltz	a0,800057ac <sys_write+0x5c>
    80005782:	fd840593          	addi	a1,s0,-40
    80005786:	4505                	li	a0,1
    80005788:	ffffe097          	auipc	ra,0xffffe
    8000578c:	8b2080e7          	jalr	-1870(ra) # 8000303a <argaddr>
    return -1;
    80005790:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005792:	00054d63          	bltz	a0,800057ac <sys_write+0x5c>
  return filewrite(f, p, n);
    80005796:	fe442603          	lw	a2,-28(s0)
    8000579a:	fd843583          	ld	a1,-40(s0)
    8000579e:	fe843503          	ld	a0,-24(s0)
    800057a2:	fffff097          	auipc	ra,0xfffff
    800057a6:	4b8080e7          	jalr	1208(ra) # 80004c5a <filewrite>
    800057aa:	87aa                	mv	a5,a0
}
    800057ac:	853e                	mv	a0,a5
    800057ae:	70a2                	ld	ra,40(sp)
    800057b0:	7402                	ld	s0,32(sp)
    800057b2:	6145                	addi	sp,sp,48
    800057b4:	8082                	ret

00000000800057b6 <sys_close>:
{
    800057b6:	1101                	addi	sp,sp,-32
    800057b8:	ec06                	sd	ra,24(sp)
    800057ba:	e822                	sd	s0,16(sp)
    800057bc:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800057be:	fe040613          	addi	a2,s0,-32
    800057c2:	fec40593          	addi	a1,s0,-20
    800057c6:	4501                	li	a0,0
    800057c8:	00000097          	auipc	ra,0x0
    800057cc:	cc4080e7          	jalr	-828(ra) # 8000548c <argfd>
    return -1;
    800057d0:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800057d2:	02054463          	bltz	a0,800057fa <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800057d6:	ffffc097          	auipc	ra,0xffffc
    800057da:	6d0080e7          	jalr	1744(ra) # 80001ea6 <myproc>
    800057de:	fec42783          	lw	a5,-20(s0)
    800057e2:	07e9                	addi	a5,a5,26
    800057e4:	078e                	slli	a5,a5,0x3
    800057e6:	97aa                	add	a5,a5,a0
    800057e8:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800057ec:	fe043503          	ld	a0,-32(s0)
    800057f0:	fffff097          	auipc	ra,0xfffff
    800057f4:	26e080e7          	jalr	622(ra) # 80004a5e <fileclose>
  return 0;
    800057f8:	4781                	li	a5,0
}
    800057fa:	853e                	mv	a0,a5
    800057fc:	60e2                	ld	ra,24(sp)
    800057fe:	6442                	ld	s0,16(sp)
    80005800:	6105                	addi	sp,sp,32
    80005802:	8082                	ret

0000000080005804 <sys_fstat>:
{
    80005804:	1101                	addi	sp,sp,-32
    80005806:	ec06                	sd	ra,24(sp)
    80005808:	e822                	sd	s0,16(sp)
    8000580a:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000580c:	fe840613          	addi	a2,s0,-24
    80005810:	4581                	li	a1,0
    80005812:	4501                	li	a0,0
    80005814:	00000097          	auipc	ra,0x0
    80005818:	c78080e7          	jalr	-904(ra) # 8000548c <argfd>
    return -1;
    8000581c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000581e:	02054563          	bltz	a0,80005848 <sys_fstat+0x44>
    80005822:	fe040593          	addi	a1,s0,-32
    80005826:	4505                	li	a0,1
    80005828:	ffffe097          	auipc	ra,0xffffe
    8000582c:	812080e7          	jalr	-2030(ra) # 8000303a <argaddr>
    return -1;
    80005830:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005832:	00054b63          	bltz	a0,80005848 <sys_fstat+0x44>
  return filestat(f, st);
    80005836:	fe043583          	ld	a1,-32(s0)
    8000583a:	fe843503          	ld	a0,-24(s0)
    8000583e:	fffff097          	auipc	ra,0xfffff
    80005842:	2e8080e7          	jalr	744(ra) # 80004b26 <filestat>
    80005846:	87aa                	mv	a5,a0
}
    80005848:	853e                	mv	a0,a5
    8000584a:	60e2                	ld	ra,24(sp)
    8000584c:	6442                	ld	s0,16(sp)
    8000584e:	6105                	addi	sp,sp,32
    80005850:	8082                	ret

0000000080005852 <sys_link>:
{
    80005852:	7169                	addi	sp,sp,-304
    80005854:	f606                	sd	ra,296(sp)
    80005856:	f222                	sd	s0,288(sp)
    80005858:	ee26                	sd	s1,280(sp)
    8000585a:	ea4a                	sd	s2,272(sp)
    8000585c:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000585e:	08000613          	li	a2,128
    80005862:	ed040593          	addi	a1,s0,-304
    80005866:	4501                	li	a0,0
    80005868:	ffffd097          	auipc	ra,0xffffd
    8000586c:	7f4080e7          	jalr	2036(ra) # 8000305c <argstr>
    return -1;
    80005870:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005872:	10054e63          	bltz	a0,8000598e <sys_link+0x13c>
    80005876:	08000613          	li	a2,128
    8000587a:	f5040593          	addi	a1,s0,-176
    8000587e:	4505                	li	a0,1
    80005880:	ffffd097          	auipc	ra,0xffffd
    80005884:	7dc080e7          	jalr	2012(ra) # 8000305c <argstr>
    return -1;
    80005888:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000588a:	10054263          	bltz	a0,8000598e <sys_link+0x13c>
  begin_op();
    8000588e:	fffff097          	auipc	ra,0xfffff
    80005892:	cfe080e7          	jalr	-770(ra) # 8000458c <begin_op>
  if((ip = namei(old)) == 0){
    80005896:	ed040513          	addi	a0,s0,-304
    8000589a:	fffff097          	auipc	ra,0xfffff
    8000589e:	ae6080e7          	jalr	-1306(ra) # 80004380 <namei>
    800058a2:	84aa                	mv	s1,a0
    800058a4:	c551                	beqz	a0,80005930 <sys_link+0xde>
  ilock(ip);
    800058a6:	ffffe097          	auipc	ra,0xffffe
    800058aa:	326080e7          	jalr	806(ra) # 80003bcc <ilock>
  if(ip->type == T_DIR){
    800058ae:	04449703          	lh	a4,68(s1)
    800058b2:	4785                	li	a5,1
    800058b4:	08f70463          	beq	a4,a5,8000593c <sys_link+0xea>
  ip->nlink++;
    800058b8:	04a4d783          	lhu	a5,74(s1)
    800058bc:	2785                	addiw	a5,a5,1
    800058be:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800058c2:	8526                	mv	a0,s1
    800058c4:	ffffe097          	auipc	ra,0xffffe
    800058c8:	23e080e7          	jalr	574(ra) # 80003b02 <iupdate>
  iunlock(ip);
    800058cc:	8526                	mv	a0,s1
    800058ce:	ffffe097          	auipc	ra,0xffffe
    800058d2:	3c0080e7          	jalr	960(ra) # 80003c8e <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800058d6:	fd040593          	addi	a1,s0,-48
    800058da:	f5040513          	addi	a0,s0,-176
    800058de:	fffff097          	auipc	ra,0xfffff
    800058e2:	ac0080e7          	jalr	-1344(ra) # 8000439e <nameiparent>
    800058e6:	892a                	mv	s2,a0
    800058e8:	c935                	beqz	a0,8000595c <sys_link+0x10a>
  ilock(dp);
    800058ea:	ffffe097          	auipc	ra,0xffffe
    800058ee:	2e2080e7          	jalr	738(ra) # 80003bcc <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800058f2:	00092703          	lw	a4,0(s2)
    800058f6:	409c                	lw	a5,0(s1)
    800058f8:	04f71d63          	bne	a4,a5,80005952 <sys_link+0x100>
    800058fc:	40d0                	lw	a2,4(s1)
    800058fe:	fd040593          	addi	a1,s0,-48
    80005902:	854a                	mv	a0,s2
    80005904:	fffff097          	auipc	ra,0xfffff
    80005908:	9ba080e7          	jalr	-1606(ra) # 800042be <dirlink>
    8000590c:	04054363          	bltz	a0,80005952 <sys_link+0x100>
  iunlockput(dp);
    80005910:	854a                	mv	a0,s2
    80005912:	ffffe097          	auipc	ra,0xffffe
    80005916:	51c080e7          	jalr	1308(ra) # 80003e2e <iunlockput>
  iput(ip);
    8000591a:	8526                	mv	a0,s1
    8000591c:	ffffe097          	auipc	ra,0xffffe
    80005920:	46a080e7          	jalr	1130(ra) # 80003d86 <iput>
  end_op();
    80005924:	fffff097          	auipc	ra,0xfffff
    80005928:	ce8080e7          	jalr	-792(ra) # 8000460c <end_op>
  return 0;
    8000592c:	4781                	li	a5,0
    8000592e:	a085                	j	8000598e <sys_link+0x13c>
    end_op();
    80005930:	fffff097          	auipc	ra,0xfffff
    80005934:	cdc080e7          	jalr	-804(ra) # 8000460c <end_op>
    return -1;
    80005938:	57fd                	li	a5,-1
    8000593a:	a891                	j	8000598e <sys_link+0x13c>
    iunlockput(ip);
    8000593c:	8526                	mv	a0,s1
    8000593e:	ffffe097          	auipc	ra,0xffffe
    80005942:	4f0080e7          	jalr	1264(ra) # 80003e2e <iunlockput>
    end_op();
    80005946:	fffff097          	auipc	ra,0xfffff
    8000594a:	cc6080e7          	jalr	-826(ra) # 8000460c <end_op>
    return -1;
    8000594e:	57fd                	li	a5,-1
    80005950:	a83d                	j	8000598e <sys_link+0x13c>
    iunlockput(dp);
    80005952:	854a                	mv	a0,s2
    80005954:	ffffe097          	auipc	ra,0xffffe
    80005958:	4da080e7          	jalr	1242(ra) # 80003e2e <iunlockput>
  ilock(ip);
    8000595c:	8526                	mv	a0,s1
    8000595e:	ffffe097          	auipc	ra,0xffffe
    80005962:	26e080e7          	jalr	622(ra) # 80003bcc <ilock>
  ip->nlink--;
    80005966:	04a4d783          	lhu	a5,74(s1)
    8000596a:	37fd                	addiw	a5,a5,-1
    8000596c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005970:	8526                	mv	a0,s1
    80005972:	ffffe097          	auipc	ra,0xffffe
    80005976:	190080e7          	jalr	400(ra) # 80003b02 <iupdate>
  iunlockput(ip);
    8000597a:	8526                	mv	a0,s1
    8000597c:	ffffe097          	auipc	ra,0xffffe
    80005980:	4b2080e7          	jalr	1202(ra) # 80003e2e <iunlockput>
  end_op();
    80005984:	fffff097          	auipc	ra,0xfffff
    80005988:	c88080e7          	jalr	-888(ra) # 8000460c <end_op>
  return -1;
    8000598c:	57fd                	li	a5,-1
}
    8000598e:	853e                	mv	a0,a5
    80005990:	70b2                	ld	ra,296(sp)
    80005992:	7412                	ld	s0,288(sp)
    80005994:	64f2                	ld	s1,280(sp)
    80005996:	6952                	ld	s2,272(sp)
    80005998:	6155                	addi	sp,sp,304
    8000599a:	8082                	ret

000000008000599c <sys_unlink>:
{
    8000599c:	7151                	addi	sp,sp,-240
    8000599e:	f586                	sd	ra,232(sp)
    800059a0:	f1a2                	sd	s0,224(sp)
    800059a2:	eda6                	sd	s1,216(sp)
    800059a4:	e9ca                	sd	s2,208(sp)
    800059a6:	e5ce                	sd	s3,200(sp)
    800059a8:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800059aa:	08000613          	li	a2,128
    800059ae:	f3040593          	addi	a1,s0,-208
    800059b2:	4501                	li	a0,0
    800059b4:	ffffd097          	auipc	ra,0xffffd
    800059b8:	6a8080e7          	jalr	1704(ra) # 8000305c <argstr>
    800059bc:	18054163          	bltz	a0,80005b3e <sys_unlink+0x1a2>
  begin_op();
    800059c0:	fffff097          	auipc	ra,0xfffff
    800059c4:	bcc080e7          	jalr	-1076(ra) # 8000458c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800059c8:	fb040593          	addi	a1,s0,-80
    800059cc:	f3040513          	addi	a0,s0,-208
    800059d0:	fffff097          	auipc	ra,0xfffff
    800059d4:	9ce080e7          	jalr	-1586(ra) # 8000439e <nameiparent>
    800059d8:	84aa                	mv	s1,a0
    800059da:	c979                	beqz	a0,80005ab0 <sys_unlink+0x114>
  ilock(dp);
    800059dc:	ffffe097          	auipc	ra,0xffffe
    800059e0:	1f0080e7          	jalr	496(ra) # 80003bcc <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800059e4:	00003597          	auipc	a1,0x3
    800059e8:	de458593          	addi	a1,a1,-540 # 800087c8 <syscalls+0x2d8>
    800059ec:	fb040513          	addi	a0,s0,-80
    800059f0:	ffffe097          	auipc	ra,0xffffe
    800059f4:	6a4080e7          	jalr	1700(ra) # 80004094 <namecmp>
    800059f8:	14050a63          	beqz	a0,80005b4c <sys_unlink+0x1b0>
    800059fc:	00003597          	auipc	a1,0x3
    80005a00:	dd458593          	addi	a1,a1,-556 # 800087d0 <syscalls+0x2e0>
    80005a04:	fb040513          	addi	a0,s0,-80
    80005a08:	ffffe097          	auipc	ra,0xffffe
    80005a0c:	68c080e7          	jalr	1676(ra) # 80004094 <namecmp>
    80005a10:	12050e63          	beqz	a0,80005b4c <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005a14:	f2c40613          	addi	a2,s0,-212
    80005a18:	fb040593          	addi	a1,s0,-80
    80005a1c:	8526                	mv	a0,s1
    80005a1e:	ffffe097          	auipc	ra,0xffffe
    80005a22:	690080e7          	jalr	1680(ra) # 800040ae <dirlookup>
    80005a26:	892a                	mv	s2,a0
    80005a28:	12050263          	beqz	a0,80005b4c <sys_unlink+0x1b0>
  ilock(ip);
    80005a2c:	ffffe097          	auipc	ra,0xffffe
    80005a30:	1a0080e7          	jalr	416(ra) # 80003bcc <ilock>
  if(ip->nlink < 1)
    80005a34:	04a91783          	lh	a5,74(s2)
    80005a38:	08f05263          	blez	a5,80005abc <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005a3c:	04491703          	lh	a4,68(s2)
    80005a40:	4785                	li	a5,1
    80005a42:	08f70563          	beq	a4,a5,80005acc <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005a46:	4641                	li	a2,16
    80005a48:	4581                	li	a1,0
    80005a4a:	fc040513          	addi	a0,s0,-64
    80005a4e:	ffffb097          	auipc	ra,0xffffb
    80005a52:	628080e7          	jalr	1576(ra) # 80001076 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005a56:	4741                	li	a4,16
    80005a58:	f2c42683          	lw	a3,-212(s0)
    80005a5c:	fc040613          	addi	a2,s0,-64
    80005a60:	4581                	li	a1,0
    80005a62:	8526                	mv	a0,s1
    80005a64:	ffffe097          	auipc	ra,0xffffe
    80005a68:	514080e7          	jalr	1300(ra) # 80003f78 <writei>
    80005a6c:	47c1                	li	a5,16
    80005a6e:	0af51563          	bne	a0,a5,80005b18 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005a72:	04491703          	lh	a4,68(s2)
    80005a76:	4785                	li	a5,1
    80005a78:	0af70863          	beq	a4,a5,80005b28 <sys_unlink+0x18c>
  iunlockput(dp);
    80005a7c:	8526                	mv	a0,s1
    80005a7e:	ffffe097          	auipc	ra,0xffffe
    80005a82:	3b0080e7          	jalr	944(ra) # 80003e2e <iunlockput>
  ip->nlink--;
    80005a86:	04a95783          	lhu	a5,74(s2)
    80005a8a:	37fd                	addiw	a5,a5,-1
    80005a8c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005a90:	854a                	mv	a0,s2
    80005a92:	ffffe097          	auipc	ra,0xffffe
    80005a96:	070080e7          	jalr	112(ra) # 80003b02 <iupdate>
  iunlockput(ip);
    80005a9a:	854a                	mv	a0,s2
    80005a9c:	ffffe097          	auipc	ra,0xffffe
    80005aa0:	392080e7          	jalr	914(ra) # 80003e2e <iunlockput>
  end_op();
    80005aa4:	fffff097          	auipc	ra,0xfffff
    80005aa8:	b68080e7          	jalr	-1176(ra) # 8000460c <end_op>
  return 0;
    80005aac:	4501                	li	a0,0
    80005aae:	a84d                	j	80005b60 <sys_unlink+0x1c4>
    end_op();
    80005ab0:	fffff097          	auipc	ra,0xfffff
    80005ab4:	b5c080e7          	jalr	-1188(ra) # 8000460c <end_op>
    return -1;
    80005ab8:	557d                	li	a0,-1
    80005aba:	a05d                	j	80005b60 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005abc:	00003517          	auipc	a0,0x3
    80005ac0:	d3c50513          	addi	a0,a0,-708 # 800087f8 <syscalls+0x308>
    80005ac4:	ffffb097          	auipc	ra,0xffffb
    80005ac8:	b20080e7          	jalr	-1248(ra) # 800005e4 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005acc:	04c92703          	lw	a4,76(s2)
    80005ad0:	02000793          	li	a5,32
    80005ad4:	f6e7f9e3          	bgeu	a5,a4,80005a46 <sys_unlink+0xaa>
    80005ad8:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005adc:	4741                	li	a4,16
    80005ade:	86ce                	mv	a3,s3
    80005ae0:	f1840613          	addi	a2,s0,-232
    80005ae4:	4581                	li	a1,0
    80005ae6:	854a                	mv	a0,s2
    80005ae8:	ffffe097          	auipc	ra,0xffffe
    80005aec:	398080e7          	jalr	920(ra) # 80003e80 <readi>
    80005af0:	47c1                	li	a5,16
    80005af2:	00f51b63          	bne	a0,a5,80005b08 <sys_unlink+0x16c>
    if(de.inum != 0)
    80005af6:	f1845783          	lhu	a5,-232(s0)
    80005afa:	e7a1                	bnez	a5,80005b42 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005afc:	29c1                	addiw	s3,s3,16
    80005afe:	04c92783          	lw	a5,76(s2)
    80005b02:	fcf9ede3          	bltu	s3,a5,80005adc <sys_unlink+0x140>
    80005b06:	b781                	j	80005a46 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005b08:	00003517          	auipc	a0,0x3
    80005b0c:	d0850513          	addi	a0,a0,-760 # 80008810 <syscalls+0x320>
    80005b10:	ffffb097          	auipc	ra,0xffffb
    80005b14:	ad4080e7          	jalr	-1324(ra) # 800005e4 <panic>
    panic("unlink: writei");
    80005b18:	00003517          	auipc	a0,0x3
    80005b1c:	d1050513          	addi	a0,a0,-752 # 80008828 <syscalls+0x338>
    80005b20:	ffffb097          	auipc	ra,0xffffb
    80005b24:	ac4080e7          	jalr	-1340(ra) # 800005e4 <panic>
    dp->nlink--;
    80005b28:	04a4d783          	lhu	a5,74(s1)
    80005b2c:	37fd                	addiw	a5,a5,-1
    80005b2e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005b32:	8526                	mv	a0,s1
    80005b34:	ffffe097          	auipc	ra,0xffffe
    80005b38:	fce080e7          	jalr	-50(ra) # 80003b02 <iupdate>
    80005b3c:	b781                	j	80005a7c <sys_unlink+0xe0>
    return -1;
    80005b3e:	557d                	li	a0,-1
    80005b40:	a005                	j	80005b60 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005b42:	854a                	mv	a0,s2
    80005b44:	ffffe097          	auipc	ra,0xffffe
    80005b48:	2ea080e7          	jalr	746(ra) # 80003e2e <iunlockput>
  iunlockput(dp);
    80005b4c:	8526                	mv	a0,s1
    80005b4e:	ffffe097          	auipc	ra,0xffffe
    80005b52:	2e0080e7          	jalr	736(ra) # 80003e2e <iunlockput>
  end_op();
    80005b56:	fffff097          	auipc	ra,0xfffff
    80005b5a:	ab6080e7          	jalr	-1354(ra) # 8000460c <end_op>
  return -1;
    80005b5e:	557d                	li	a0,-1
}
    80005b60:	70ae                	ld	ra,232(sp)
    80005b62:	740e                	ld	s0,224(sp)
    80005b64:	64ee                	ld	s1,216(sp)
    80005b66:	694e                	ld	s2,208(sp)
    80005b68:	69ae                	ld	s3,200(sp)
    80005b6a:	616d                	addi	sp,sp,240
    80005b6c:	8082                	ret

0000000080005b6e <sys_open>:

uint64
sys_open(void)
{
    80005b6e:	7131                	addi	sp,sp,-192
    80005b70:	fd06                	sd	ra,184(sp)
    80005b72:	f922                	sd	s0,176(sp)
    80005b74:	f526                	sd	s1,168(sp)
    80005b76:	f14a                	sd	s2,160(sp)
    80005b78:	ed4e                	sd	s3,152(sp)
    80005b7a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005b7c:	08000613          	li	a2,128
    80005b80:	f5040593          	addi	a1,s0,-176
    80005b84:	4501                	li	a0,0
    80005b86:	ffffd097          	auipc	ra,0xffffd
    80005b8a:	4d6080e7          	jalr	1238(ra) # 8000305c <argstr>
    return -1;
    80005b8e:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005b90:	0c054163          	bltz	a0,80005c52 <sys_open+0xe4>
    80005b94:	f4c40593          	addi	a1,s0,-180
    80005b98:	4505                	li	a0,1
    80005b9a:	ffffd097          	auipc	ra,0xffffd
    80005b9e:	47e080e7          	jalr	1150(ra) # 80003018 <argint>
    80005ba2:	0a054863          	bltz	a0,80005c52 <sys_open+0xe4>

  begin_op();
    80005ba6:	fffff097          	auipc	ra,0xfffff
    80005baa:	9e6080e7          	jalr	-1562(ra) # 8000458c <begin_op>

  if(omode & O_CREATE){
    80005bae:	f4c42783          	lw	a5,-180(s0)
    80005bb2:	2007f793          	andi	a5,a5,512
    80005bb6:	cbdd                	beqz	a5,80005c6c <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005bb8:	4681                	li	a3,0
    80005bba:	4601                	li	a2,0
    80005bbc:	4589                	li	a1,2
    80005bbe:	f5040513          	addi	a0,s0,-176
    80005bc2:	00000097          	auipc	ra,0x0
    80005bc6:	974080e7          	jalr	-1676(ra) # 80005536 <create>
    80005bca:	892a                	mv	s2,a0
    if(ip == 0){
    80005bcc:	c959                	beqz	a0,80005c62 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005bce:	04491703          	lh	a4,68(s2)
    80005bd2:	478d                	li	a5,3
    80005bd4:	00f71763          	bne	a4,a5,80005be2 <sys_open+0x74>
    80005bd8:	04695703          	lhu	a4,70(s2)
    80005bdc:	47a5                	li	a5,9
    80005bde:	0ce7ec63          	bltu	a5,a4,80005cb6 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005be2:	fffff097          	auipc	ra,0xfffff
    80005be6:	dc0080e7          	jalr	-576(ra) # 800049a2 <filealloc>
    80005bea:	89aa                	mv	s3,a0
    80005bec:	10050263          	beqz	a0,80005cf0 <sys_open+0x182>
    80005bf0:	00000097          	auipc	ra,0x0
    80005bf4:	904080e7          	jalr	-1788(ra) # 800054f4 <fdalloc>
    80005bf8:	84aa                	mv	s1,a0
    80005bfa:	0e054663          	bltz	a0,80005ce6 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005bfe:	04491703          	lh	a4,68(s2)
    80005c02:	478d                	li	a5,3
    80005c04:	0cf70463          	beq	a4,a5,80005ccc <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005c08:	4789                	li	a5,2
    80005c0a:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005c0e:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005c12:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005c16:	f4c42783          	lw	a5,-180(s0)
    80005c1a:	0017c713          	xori	a4,a5,1
    80005c1e:	8b05                	andi	a4,a4,1
    80005c20:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005c24:	0037f713          	andi	a4,a5,3
    80005c28:	00e03733          	snez	a4,a4
    80005c2c:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005c30:	4007f793          	andi	a5,a5,1024
    80005c34:	c791                	beqz	a5,80005c40 <sys_open+0xd2>
    80005c36:	04491703          	lh	a4,68(s2)
    80005c3a:	4789                	li	a5,2
    80005c3c:	08f70f63          	beq	a4,a5,80005cda <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005c40:	854a                	mv	a0,s2
    80005c42:	ffffe097          	auipc	ra,0xffffe
    80005c46:	04c080e7          	jalr	76(ra) # 80003c8e <iunlock>
  end_op();
    80005c4a:	fffff097          	auipc	ra,0xfffff
    80005c4e:	9c2080e7          	jalr	-1598(ra) # 8000460c <end_op>

  return fd;
}
    80005c52:	8526                	mv	a0,s1
    80005c54:	70ea                	ld	ra,184(sp)
    80005c56:	744a                	ld	s0,176(sp)
    80005c58:	74aa                	ld	s1,168(sp)
    80005c5a:	790a                	ld	s2,160(sp)
    80005c5c:	69ea                	ld	s3,152(sp)
    80005c5e:	6129                	addi	sp,sp,192
    80005c60:	8082                	ret
      end_op();
    80005c62:	fffff097          	auipc	ra,0xfffff
    80005c66:	9aa080e7          	jalr	-1622(ra) # 8000460c <end_op>
      return -1;
    80005c6a:	b7e5                	j	80005c52 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80005c6c:	f5040513          	addi	a0,s0,-176
    80005c70:	ffffe097          	auipc	ra,0xffffe
    80005c74:	710080e7          	jalr	1808(ra) # 80004380 <namei>
    80005c78:	892a                	mv	s2,a0
    80005c7a:	c905                	beqz	a0,80005caa <sys_open+0x13c>
    ilock(ip);
    80005c7c:	ffffe097          	auipc	ra,0xffffe
    80005c80:	f50080e7          	jalr	-176(ra) # 80003bcc <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005c84:	04491703          	lh	a4,68(s2)
    80005c88:	4785                	li	a5,1
    80005c8a:	f4f712e3          	bne	a4,a5,80005bce <sys_open+0x60>
    80005c8e:	f4c42783          	lw	a5,-180(s0)
    80005c92:	dba1                	beqz	a5,80005be2 <sys_open+0x74>
      iunlockput(ip);
    80005c94:	854a                	mv	a0,s2
    80005c96:	ffffe097          	auipc	ra,0xffffe
    80005c9a:	198080e7          	jalr	408(ra) # 80003e2e <iunlockput>
      end_op();
    80005c9e:	fffff097          	auipc	ra,0xfffff
    80005ca2:	96e080e7          	jalr	-1682(ra) # 8000460c <end_op>
      return -1;
    80005ca6:	54fd                	li	s1,-1
    80005ca8:	b76d                	j	80005c52 <sys_open+0xe4>
      end_op();
    80005caa:	fffff097          	auipc	ra,0xfffff
    80005cae:	962080e7          	jalr	-1694(ra) # 8000460c <end_op>
      return -1;
    80005cb2:	54fd                	li	s1,-1
    80005cb4:	bf79                	j	80005c52 <sys_open+0xe4>
    iunlockput(ip);
    80005cb6:	854a                	mv	a0,s2
    80005cb8:	ffffe097          	auipc	ra,0xffffe
    80005cbc:	176080e7          	jalr	374(ra) # 80003e2e <iunlockput>
    end_op();
    80005cc0:	fffff097          	auipc	ra,0xfffff
    80005cc4:	94c080e7          	jalr	-1716(ra) # 8000460c <end_op>
    return -1;
    80005cc8:	54fd                	li	s1,-1
    80005cca:	b761                	j	80005c52 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005ccc:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005cd0:	04691783          	lh	a5,70(s2)
    80005cd4:	02f99223          	sh	a5,36(s3)
    80005cd8:	bf2d                	j	80005c12 <sys_open+0xa4>
    itrunc(ip);
    80005cda:	854a                	mv	a0,s2
    80005cdc:	ffffe097          	auipc	ra,0xffffe
    80005ce0:	ffe080e7          	jalr	-2(ra) # 80003cda <itrunc>
    80005ce4:	bfb1                	j	80005c40 <sys_open+0xd2>
      fileclose(f);
    80005ce6:	854e                	mv	a0,s3
    80005ce8:	fffff097          	auipc	ra,0xfffff
    80005cec:	d76080e7          	jalr	-650(ra) # 80004a5e <fileclose>
    iunlockput(ip);
    80005cf0:	854a                	mv	a0,s2
    80005cf2:	ffffe097          	auipc	ra,0xffffe
    80005cf6:	13c080e7          	jalr	316(ra) # 80003e2e <iunlockput>
    end_op();
    80005cfa:	fffff097          	auipc	ra,0xfffff
    80005cfe:	912080e7          	jalr	-1774(ra) # 8000460c <end_op>
    return -1;
    80005d02:	54fd                	li	s1,-1
    80005d04:	b7b9                	j	80005c52 <sys_open+0xe4>

0000000080005d06 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005d06:	7175                	addi	sp,sp,-144
    80005d08:	e506                	sd	ra,136(sp)
    80005d0a:	e122                	sd	s0,128(sp)
    80005d0c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005d0e:	fffff097          	auipc	ra,0xfffff
    80005d12:	87e080e7          	jalr	-1922(ra) # 8000458c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005d16:	08000613          	li	a2,128
    80005d1a:	f7040593          	addi	a1,s0,-144
    80005d1e:	4501                	li	a0,0
    80005d20:	ffffd097          	auipc	ra,0xffffd
    80005d24:	33c080e7          	jalr	828(ra) # 8000305c <argstr>
    80005d28:	02054963          	bltz	a0,80005d5a <sys_mkdir+0x54>
    80005d2c:	4681                	li	a3,0
    80005d2e:	4601                	li	a2,0
    80005d30:	4585                	li	a1,1
    80005d32:	f7040513          	addi	a0,s0,-144
    80005d36:	00000097          	auipc	ra,0x0
    80005d3a:	800080e7          	jalr	-2048(ra) # 80005536 <create>
    80005d3e:	cd11                	beqz	a0,80005d5a <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005d40:	ffffe097          	auipc	ra,0xffffe
    80005d44:	0ee080e7          	jalr	238(ra) # 80003e2e <iunlockput>
  end_op();
    80005d48:	fffff097          	auipc	ra,0xfffff
    80005d4c:	8c4080e7          	jalr	-1852(ra) # 8000460c <end_op>
  return 0;
    80005d50:	4501                	li	a0,0
}
    80005d52:	60aa                	ld	ra,136(sp)
    80005d54:	640a                	ld	s0,128(sp)
    80005d56:	6149                	addi	sp,sp,144
    80005d58:	8082                	ret
    end_op();
    80005d5a:	fffff097          	auipc	ra,0xfffff
    80005d5e:	8b2080e7          	jalr	-1870(ra) # 8000460c <end_op>
    return -1;
    80005d62:	557d                	li	a0,-1
    80005d64:	b7fd                	j	80005d52 <sys_mkdir+0x4c>

0000000080005d66 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005d66:	7135                	addi	sp,sp,-160
    80005d68:	ed06                	sd	ra,152(sp)
    80005d6a:	e922                	sd	s0,144(sp)
    80005d6c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005d6e:	fffff097          	auipc	ra,0xfffff
    80005d72:	81e080e7          	jalr	-2018(ra) # 8000458c <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005d76:	08000613          	li	a2,128
    80005d7a:	f7040593          	addi	a1,s0,-144
    80005d7e:	4501                	li	a0,0
    80005d80:	ffffd097          	auipc	ra,0xffffd
    80005d84:	2dc080e7          	jalr	732(ra) # 8000305c <argstr>
    80005d88:	04054a63          	bltz	a0,80005ddc <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80005d8c:	f6c40593          	addi	a1,s0,-148
    80005d90:	4505                	li	a0,1
    80005d92:	ffffd097          	auipc	ra,0xffffd
    80005d96:	286080e7          	jalr	646(ra) # 80003018 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005d9a:	04054163          	bltz	a0,80005ddc <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005d9e:	f6840593          	addi	a1,s0,-152
    80005da2:	4509                	li	a0,2
    80005da4:	ffffd097          	auipc	ra,0xffffd
    80005da8:	274080e7          	jalr	628(ra) # 80003018 <argint>
     argint(1, &major) < 0 ||
    80005dac:	02054863          	bltz	a0,80005ddc <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005db0:	f6841683          	lh	a3,-152(s0)
    80005db4:	f6c41603          	lh	a2,-148(s0)
    80005db8:	458d                	li	a1,3
    80005dba:	f7040513          	addi	a0,s0,-144
    80005dbe:	fffff097          	auipc	ra,0xfffff
    80005dc2:	778080e7          	jalr	1912(ra) # 80005536 <create>
     argint(2, &minor) < 0 ||
    80005dc6:	c919                	beqz	a0,80005ddc <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005dc8:	ffffe097          	auipc	ra,0xffffe
    80005dcc:	066080e7          	jalr	102(ra) # 80003e2e <iunlockput>
  end_op();
    80005dd0:	fffff097          	auipc	ra,0xfffff
    80005dd4:	83c080e7          	jalr	-1988(ra) # 8000460c <end_op>
  return 0;
    80005dd8:	4501                	li	a0,0
    80005dda:	a031                	j	80005de6 <sys_mknod+0x80>
    end_op();
    80005ddc:	fffff097          	auipc	ra,0xfffff
    80005de0:	830080e7          	jalr	-2000(ra) # 8000460c <end_op>
    return -1;
    80005de4:	557d                	li	a0,-1
}
    80005de6:	60ea                	ld	ra,152(sp)
    80005de8:	644a                	ld	s0,144(sp)
    80005dea:	610d                	addi	sp,sp,160
    80005dec:	8082                	ret

0000000080005dee <sys_chdir>:

uint64
sys_chdir(void)
{
    80005dee:	7135                	addi	sp,sp,-160
    80005df0:	ed06                	sd	ra,152(sp)
    80005df2:	e922                	sd	s0,144(sp)
    80005df4:	e526                	sd	s1,136(sp)
    80005df6:	e14a                	sd	s2,128(sp)
    80005df8:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005dfa:	ffffc097          	auipc	ra,0xffffc
    80005dfe:	0ac080e7          	jalr	172(ra) # 80001ea6 <myproc>
    80005e02:	892a                	mv	s2,a0
  
  begin_op();
    80005e04:	ffffe097          	auipc	ra,0xffffe
    80005e08:	788080e7          	jalr	1928(ra) # 8000458c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005e0c:	08000613          	li	a2,128
    80005e10:	f6040593          	addi	a1,s0,-160
    80005e14:	4501                	li	a0,0
    80005e16:	ffffd097          	auipc	ra,0xffffd
    80005e1a:	246080e7          	jalr	582(ra) # 8000305c <argstr>
    80005e1e:	04054b63          	bltz	a0,80005e74 <sys_chdir+0x86>
    80005e22:	f6040513          	addi	a0,s0,-160
    80005e26:	ffffe097          	auipc	ra,0xffffe
    80005e2a:	55a080e7          	jalr	1370(ra) # 80004380 <namei>
    80005e2e:	84aa                	mv	s1,a0
    80005e30:	c131                	beqz	a0,80005e74 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005e32:	ffffe097          	auipc	ra,0xffffe
    80005e36:	d9a080e7          	jalr	-614(ra) # 80003bcc <ilock>
  if(ip->type != T_DIR){
    80005e3a:	04449703          	lh	a4,68(s1)
    80005e3e:	4785                	li	a5,1
    80005e40:	04f71063          	bne	a4,a5,80005e80 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005e44:	8526                	mv	a0,s1
    80005e46:	ffffe097          	auipc	ra,0xffffe
    80005e4a:	e48080e7          	jalr	-440(ra) # 80003c8e <iunlock>
  iput(p->cwd);
    80005e4e:	15093503          	ld	a0,336(s2)
    80005e52:	ffffe097          	auipc	ra,0xffffe
    80005e56:	f34080e7          	jalr	-204(ra) # 80003d86 <iput>
  end_op();
    80005e5a:	ffffe097          	auipc	ra,0xffffe
    80005e5e:	7b2080e7          	jalr	1970(ra) # 8000460c <end_op>
  p->cwd = ip;
    80005e62:	14993823          	sd	s1,336(s2)
  return 0;
    80005e66:	4501                	li	a0,0
}
    80005e68:	60ea                	ld	ra,152(sp)
    80005e6a:	644a                	ld	s0,144(sp)
    80005e6c:	64aa                	ld	s1,136(sp)
    80005e6e:	690a                	ld	s2,128(sp)
    80005e70:	610d                	addi	sp,sp,160
    80005e72:	8082                	ret
    end_op();
    80005e74:	ffffe097          	auipc	ra,0xffffe
    80005e78:	798080e7          	jalr	1944(ra) # 8000460c <end_op>
    return -1;
    80005e7c:	557d                	li	a0,-1
    80005e7e:	b7ed                	j	80005e68 <sys_chdir+0x7a>
    iunlockput(ip);
    80005e80:	8526                	mv	a0,s1
    80005e82:	ffffe097          	auipc	ra,0xffffe
    80005e86:	fac080e7          	jalr	-84(ra) # 80003e2e <iunlockput>
    end_op();
    80005e8a:	ffffe097          	auipc	ra,0xffffe
    80005e8e:	782080e7          	jalr	1922(ra) # 8000460c <end_op>
    return -1;
    80005e92:	557d                	li	a0,-1
    80005e94:	bfd1                	j	80005e68 <sys_chdir+0x7a>

0000000080005e96 <sys_exec>:

uint64
sys_exec(void)
{
    80005e96:	7145                	addi	sp,sp,-464
    80005e98:	e786                	sd	ra,456(sp)
    80005e9a:	e3a2                	sd	s0,448(sp)
    80005e9c:	ff26                	sd	s1,440(sp)
    80005e9e:	fb4a                	sd	s2,432(sp)
    80005ea0:	f74e                	sd	s3,424(sp)
    80005ea2:	f352                	sd	s4,416(sp)
    80005ea4:	ef56                	sd	s5,408(sp)
    80005ea6:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005ea8:	08000613          	li	a2,128
    80005eac:	f4040593          	addi	a1,s0,-192
    80005eb0:	4501                	li	a0,0
    80005eb2:	ffffd097          	auipc	ra,0xffffd
    80005eb6:	1aa080e7          	jalr	426(ra) # 8000305c <argstr>
    return -1;
    80005eba:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005ebc:	0c054a63          	bltz	a0,80005f90 <sys_exec+0xfa>
    80005ec0:	e3840593          	addi	a1,s0,-456
    80005ec4:	4505                	li	a0,1
    80005ec6:	ffffd097          	auipc	ra,0xffffd
    80005eca:	174080e7          	jalr	372(ra) # 8000303a <argaddr>
    80005ece:	0c054163          	bltz	a0,80005f90 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005ed2:	10000613          	li	a2,256
    80005ed6:	4581                	li	a1,0
    80005ed8:	e4040513          	addi	a0,s0,-448
    80005edc:	ffffb097          	auipc	ra,0xffffb
    80005ee0:	19a080e7          	jalr	410(ra) # 80001076 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005ee4:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005ee8:	89a6                	mv	s3,s1
    80005eea:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005eec:	02000a13          	li	s4,32
    80005ef0:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005ef4:	00391793          	slli	a5,s2,0x3
    80005ef8:	e3040593          	addi	a1,s0,-464
    80005efc:	e3843503          	ld	a0,-456(s0)
    80005f00:	953e                	add	a0,a0,a5
    80005f02:	ffffd097          	auipc	ra,0xffffd
    80005f06:	07c080e7          	jalr	124(ra) # 80002f7e <fetchaddr>
    80005f0a:	02054a63          	bltz	a0,80005f3e <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005f0e:	e3043783          	ld	a5,-464(s0)
    80005f12:	c3b9                	beqz	a5,80005f58 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005f14:	ffffb097          	auipc	ra,0xffffb
    80005f18:	e54080e7          	jalr	-428(ra) # 80000d68 <kalloc>
    80005f1c:	85aa                	mv	a1,a0
    80005f1e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005f22:	cd11                	beqz	a0,80005f3e <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005f24:	6605                	lui	a2,0x1
    80005f26:	e3043503          	ld	a0,-464(s0)
    80005f2a:	ffffd097          	auipc	ra,0xffffd
    80005f2e:	0a6080e7          	jalr	166(ra) # 80002fd0 <fetchstr>
    80005f32:	00054663          	bltz	a0,80005f3e <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005f36:	0905                	addi	s2,s2,1
    80005f38:	09a1                	addi	s3,s3,8
    80005f3a:	fb491be3          	bne	s2,s4,80005ef0 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005f3e:	10048913          	addi	s2,s1,256
    80005f42:	6088                	ld	a0,0(s1)
    80005f44:	c529                	beqz	a0,80005f8e <sys_exec+0xf8>
    kfree(argv[i]);
    80005f46:	ffffb097          	auipc	ra,0xffffb
    80005f4a:	b44080e7          	jalr	-1212(ra) # 80000a8a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005f4e:	04a1                	addi	s1,s1,8
    80005f50:	ff2499e3          	bne	s1,s2,80005f42 <sys_exec+0xac>
  return -1;
    80005f54:	597d                	li	s2,-1
    80005f56:	a82d                	j	80005f90 <sys_exec+0xfa>
      argv[i] = 0;
    80005f58:	0a8e                	slli	s5,s5,0x3
    80005f5a:	fc040793          	addi	a5,s0,-64
    80005f5e:	9abe                	add	s5,s5,a5
    80005f60:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffb8e80>
  int ret = exec(path, argv);
    80005f64:	e4040593          	addi	a1,s0,-448
    80005f68:	f4040513          	addi	a0,s0,-192
    80005f6c:	fffff097          	auipc	ra,0xfffff
    80005f70:	178080e7          	jalr	376(ra) # 800050e4 <exec>
    80005f74:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005f76:	10048993          	addi	s3,s1,256
    80005f7a:	6088                	ld	a0,0(s1)
    80005f7c:	c911                	beqz	a0,80005f90 <sys_exec+0xfa>
    kfree(argv[i]);
    80005f7e:	ffffb097          	auipc	ra,0xffffb
    80005f82:	b0c080e7          	jalr	-1268(ra) # 80000a8a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005f86:	04a1                	addi	s1,s1,8
    80005f88:	ff3499e3          	bne	s1,s3,80005f7a <sys_exec+0xe4>
    80005f8c:	a011                	j	80005f90 <sys_exec+0xfa>
  return -1;
    80005f8e:	597d                	li	s2,-1
}
    80005f90:	854a                	mv	a0,s2
    80005f92:	60be                	ld	ra,456(sp)
    80005f94:	641e                	ld	s0,448(sp)
    80005f96:	74fa                	ld	s1,440(sp)
    80005f98:	795a                	ld	s2,432(sp)
    80005f9a:	79ba                	ld	s3,424(sp)
    80005f9c:	7a1a                	ld	s4,416(sp)
    80005f9e:	6afa                	ld	s5,408(sp)
    80005fa0:	6179                	addi	sp,sp,464
    80005fa2:	8082                	ret

0000000080005fa4 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005fa4:	7139                	addi	sp,sp,-64
    80005fa6:	fc06                	sd	ra,56(sp)
    80005fa8:	f822                	sd	s0,48(sp)
    80005faa:	f426                	sd	s1,40(sp)
    80005fac:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005fae:	ffffc097          	auipc	ra,0xffffc
    80005fb2:	ef8080e7          	jalr	-264(ra) # 80001ea6 <myproc>
    80005fb6:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005fb8:	fd840593          	addi	a1,s0,-40
    80005fbc:	4501                	li	a0,0
    80005fbe:	ffffd097          	auipc	ra,0xffffd
    80005fc2:	07c080e7          	jalr	124(ra) # 8000303a <argaddr>
    return -1;
    80005fc6:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005fc8:	0e054063          	bltz	a0,800060a8 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005fcc:	fc840593          	addi	a1,s0,-56
    80005fd0:	fd040513          	addi	a0,s0,-48
    80005fd4:	fffff097          	auipc	ra,0xfffff
    80005fd8:	de0080e7          	jalr	-544(ra) # 80004db4 <pipealloc>
    return -1;
    80005fdc:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005fde:	0c054563          	bltz	a0,800060a8 <sys_pipe+0x104>
  fd0 = -1;
    80005fe2:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005fe6:	fd043503          	ld	a0,-48(s0)
    80005fea:	fffff097          	auipc	ra,0xfffff
    80005fee:	50a080e7          	jalr	1290(ra) # 800054f4 <fdalloc>
    80005ff2:	fca42223          	sw	a0,-60(s0)
    80005ff6:	08054c63          	bltz	a0,8000608e <sys_pipe+0xea>
    80005ffa:	fc843503          	ld	a0,-56(s0)
    80005ffe:	fffff097          	auipc	ra,0xfffff
    80006002:	4f6080e7          	jalr	1270(ra) # 800054f4 <fdalloc>
    80006006:	fca42023          	sw	a0,-64(s0)
    8000600a:	06054863          	bltz	a0,8000607a <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000600e:	4691                	li	a3,4
    80006010:	fc440613          	addi	a2,s0,-60
    80006014:	fd843583          	ld	a1,-40(s0)
    80006018:	68a8                	ld	a0,80(s1)
    8000601a:	ffffc097          	auipc	ra,0xffffc
    8000601e:	c58080e7          	jalr	-936(ra) # 80001c72 <copyout>
    80006022:	02054063          	bltz	a0,80006042 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80006026:	4691                	li	a3,4
    80006028:	fc040613          	addi	a2,s0,-64
    8000602c:	fd843583          	ld	a1,-40(s0)
    80006030:	0591                	addi	a1,a1,4
    80006032:	68a8                	ld	a0,80(s1)
    80006034:	ffffc097          	auipc	ra,0xffffc
    80006038:	c3e080e7          	jalr	-962(ra) # 80001c72 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000603c:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000603e:	06055563          	bgez	a0,800060a8 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80006042:	fc442783          	lw	a5,-60(s0)
    80006046:	07e9                	addi	a5,a5,26
    80006048:	078e                	slli	a5,a5,0x3
    8000604a:	97a6                	add	a5,a5,s1
    8000604c:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80006050:	fc042503          	lw	a0,-64(s0)
    80006054:	0569                	addi	a0,a0,26
    80006056:	050e                	slli	a0,a0,0x3
    80006058:	9526                	add	a0,a0,s1
    8000605a:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000605e:	fd043503          	ld	a0,-48(s0)
    80006062:	fffff097          	auipc	ra,0xfffff
    80006066:	9fc080e7          	jalr	-1540(ra) # 80004a5e <fileclose>
    fileclose(wf);
    8000606a:	fc843503          	ld	a0,-56(s0)
    8000606e:	fffff097          	auipc	ra,0xfffff
    80006072:	9f0080e7          	jalr	-1552(ra) # 80004a5e <fileclose>
    return -1;
    80006076:	57fd                	li	a5,-1
    80006078:	a805                	j	800060a8 <sys_pipe+0x104>
    if(fd0 >= 0)
    8000607a:	fc442783          	lw	a5,-60(s0)
    8000607e:	0007c863          	bltz	a5,8000608e <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80006082:	01a78513          	addi	a0,a5,26
    80006086:	050e                	slli	a0,a0,0x3
    80006088:	9526                	add	a0,a0,s1
    8000608a:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000608e:	fd043503          	ld	a0,-48(s0)
    80006092:	fffff097          	auipc	ra,0xfffff
    80006096:	9cc080e7          	jalr	-1588(ra) # 80004a5e <fileclose>
    fileclose(wf);
    8000609a:	fc843503          	ld	a0,-56(s0)
    8000609e:	fffff097          	auipc	ra,0xfffff
    800060a2:	9c0080e7          	jalr	-1600(ra) # 80004a5e <fileclose>
    return -1;
    800060a6:	57fd                	li	a5,-1
}
    800060a8:	853e                	mv	a0,a5
    800060aa:	70e2                	ld	ra,56(sp)
    800060ac:	7442                	ld	s0,48(sp)
    800060ae:	74a2                	ld	s1,40(sp)
    800060b0:	6121                	addi	sp,sp,64
    800060b2:	8082                	ret
	...

00000000800060c0 <kernelvec>:
    800060c0:	7111                	addi	sp,sp,-256
    800060c2:	e006                	sd	ra,0(sp)
    800060c4:	e40a                	sd	sp,8(sp)
    800060c6:	e80e                	sd	gp,16(sp)
    800060c8:	ec12                	sd	tp,24(sp)
    800060ca:	f016                	sd	t0,32(sp)
    800060cc:	f41a                	sd	t1,40(sp)
    800060ce:	f81e                	sd	t2,48(sp)
    800060d0:	fc22                	sd	s0,56(sp)
    800060d2:	e0a6                	sd	s1,64(sp)
    800060d4:	e4aa                	sd	a0,72(sp)
    800060d6:	e8ae                	sd	a1,80(sp)
    800060d8:	ecb2                	sd	a2,88(sp)
    800060da:	f0b6                	sd	a3,96(sp)
    800060dc:	f4ba                	sd	a4,104(sp)
    800060de:	f8be                	sd	a5,112(sp)
    800060e0:	fcc2                	sd	a6,120(sp)
    800060e2:	e146                	sd	a7,128(sp)
    800060e4:	e54a                	sd	s2,136(sp)
    800060e6:	e94e                	sd	s3,144(sp)
    800060e8:	ed52                	sd	s4,152(sp)
    800060ea:	f156                	sd	s5,160(sp)
    800060ec:	f55a                	sd	s6,168(sp)
    800060ee:	f95e                	sd	s7,176(sp)
    800060f0:	fd62                	sd	s8,184(sp)
    800060f2:	e1e6                	sd	s9,192(sp)
    800060f4:	e5ea                	sd	s10,200(sp)
    800060f6:	e9ee                	sd	s11,208(sp)
    800060f8:	edf2                	sd	t3,216(sp)
    800060fa:	f1f6                	sd	t4,224(sp)
    800060fc:	f5fa                	sd	t5,232(sp)
    800060fe:	f9fe                	sd	t6,240(sp)
    80006100:	d4bfc0ef          	jal	ra,80002e4a <kerneltrap>
    80006104:	6082                	ld	ra,0(sp)
    80006106:	6122                	ld	sp,8(sp)
    80006108:	61c2                	ld	gp,16(sp)
    8000610a:	7282                	ld	t0,32(sp)
    8000610c:	7322                	ld	t1,40(sp)
    8000610e:	73c2                	ld	t2,48(sp)
    80006110:	7462                	ld	s0,56(sp)
    80006112:	6486                	ld	s1,64(sp)
    80006114:	6526                	ld	a0,72(sp)
    80006116:	65c6                	ld	a1,80(sp)
    80006118:	6666                	ld	a2,88(sp)
    8000611a:	7686                	ld	a3,96(sp)
    8000611c:	7726                	ld	a4,104(sp)
    8000611e:	77c6                	ld	a5,112(sp)
    80006120:	7866                	ld	a6,120(sp)
    80006122:	688a                	ld	a7,128(sp)
    80006124:	692a                	ld	s2,136(sp)
    80006126:	69ca                	ld	s3,144(sp)
    80006128:	6a6a                	ld	s4,152(sp)
    8000612a:	7a8a                	ld	s5,160(sp)
    8000612c:	7b2a                	ld	s6,168(sp)
    8000612e:	7bca                	ld	s7,176(sp)
    80006130:	7c6a                	ld	s8,184(sp)
    80006132:	6c8e                	ld	s9,192(sp)
    80006134:	6d2e                	ld	s10,200(sp)
    80006136:	6dce                	ld	s11,208(sp)
    80006138:	6e6e                	ld	t3,216(sp)
    8000613a:	7e8e                	ld	t4,224(sp)
    8000613c:	7f2e                	ld	t5,232(sp)
    8000613e:	7fce                	ld	t6,240(sp)
    80006140:	6111                	addi	sp,sp,256
    80006142:	10200073          	sret
    80006146:	00000013          	nop
    8000614a:	00000013          	nop
    8000614e:	0001                	nop

0000000080006150 <timervec>:
    80006150:	34051573          	csrrw	a0,mscratch,a0
    80006154:	e10c                	sd	a1,0(a0)
    80006156:	e510                	sd	a2,8(a0)
    80006158:	e914                	sd	a3,16(a0)
    8000615a:	710c                	ld	a1,32(a0)
    8000615c:	7510                	ld	a2,40(a0)
    8000615e:	6194                	ld	a3,0(a1)
    80006160:	96b2                	add	a3,a3,a2
    80006162:	e194                	sd	a3,0(a1)
    80006164:	4589                	li	a1,2
    80006166:	14459073          	csrw	sip,a1
    8000616a:	6914                	ld	a3,16(a0)
    8000616c:	6510                	ld	a2,8(a0)
    8000616e:	610c                	ld	a1,0(a0)
    80006170:	34051573          	csrrw	a0,mscratch,a0
    80006174:	30200073          	mret
	...

000000008000617a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000617a:	1141                	addi	sp,sp,-16
    8000617c:	e422                	sd	s0,8(sp)
    8000617e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006180:	0c0007b7          	lui	a5,0xc000
    80006184:	4705                	li	a4,1
    80006186:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006188:	c3d8                	sw	a4,4(a5)
}
    8000618a:	6422                	ld	s0,8(sp)
    8000618c:	0141                	addi	sp,sp,16
    8000618e:	8082                	ret

0000000080006190 <plicinithart>:

void
plicinithart(void)
{
    80006190:	1141                	addi	sp,sp,-16
    80006192:	e406                	sd	ra,8(sp)
    80006194:	e022                	sd	s0,0(sp)
    80006196:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006198:	ffffc097          	auipc	ra,0xffffc
    8000619c:	ce2080e7          	jalr	-798(ra) # 80001e7a <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800061a0:	0085171b          	slliw	a4,a0,0x8
    800061a4:	0c0027b7          	lui	a5,0xc002
    800061a8:	97ba                	add	a5,a5,a4
    800061aa:	40200713          	li	a4,1026
    800061ae:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800061b2:	00d5151b          	slliw	a0,a0,0xd
    800061b6:	0c2017b7          	lui	a5,0xc201
    800061ba:	953e                	add	a0,a0,a5
    800061bc:	00052023          	sw	zero,0(a0)
}
    800061c0:	60a2                	ld	ra,8(sp)
    800061c2:	6402                	ld	s0,0(sp)
    800061c4:	0141                	addi	sp,sp,16
    800061c6:	8082                	ret

00000000800061c8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800061c8:	1141                	addi	sp,sp,-16
    800061ca:	e406                	sd	ra,8(sp)
    800061cc:	e022                	sd	s0,0(sp)
    800061ce:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800061d0:	ffffc097          	auipc	ra,0xffffc
    800061d4:	caa080e7          	jalr	-854(ra) # 80001e7a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800061d8:	00d5179b          	slliw	a5,a0,0xd
    800061dc:	0c201537          	lui	a0,0xc201
    800061e0:	953e                	add	a0,a0,a5
  return irq;
}
    800061e2:	4148                	lw	a0,4(a0)
    800061e4:	60a2                	ld	ra,8(sp)
    800061e6:	6402                	ld	s0,0(sp)
    800061e8:	0141                	addi	sp,sp,16
    800061ea:	8082                	ret

00000000800061ec <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800061ec:	1101                	addi	sp,sp,-32
    800061ee:	ec06                	sd	ra,24(sp)
    800061f0:	e822                	sd	s0,16(sp)
    800061f2:	e426                	sd	s1,8(sp)
    800061f4:	1000                	addi	s0,sp,32
    800061f6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800061f8:	ffffc097          	auipc	ra,0xffffc
    800061fc:	c82080e7          	jalr	-894(ra) # 80001e7a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006200:	00d5151b          	slliw	a0,a0,0xd
    80006204:	0c2017b7          	lui	a5,0xc201
    80006208:	97aa                	add	a5,a5,a0
    8000620a:	c3c4                	sw	s1,4(a5)
}
    8000620c:	60e2                	ld	ra,24(sp)
    8000620e:	6442                	ld	s0,16(sp)
    80006210:	64a2                	ld	s1,8(sp)
    80006212:	6105                	addi	sp,sp,32
    80006214:	8082                	ret

0000000080006216 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80006216:	1141                	addi	sp,sp,-16
    80006218:	e406                	sd	ra,8(sp)
    8000621a:	e022                	sd	s0,0(sp)
    8000621c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000621e:	479d                	li	a5,7
    80006220:	04a7cc63          	blt	a5,a0,80006278 <free_desc+0x62>
    panic("virtio_disk_intr 1");
  if(disk.free[i])
    80006224:	0003d797          	auipc	a5,0x3d
    80006228:	ddc78793          	addi	a5,a5,-548 # 80043000 <disk>
    8000622c:	00a78733          	add	a4,a5,a0
    80006230:	6789                	lui	a5,0x2
    80006232:	97ba                	add	a5,a5,a4
    80006234:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80006238:	eba1                	bnez	a5,80006288 <free_desc+0x72>
    panic("virtio_disk_intr 2");
  disk.desc[i].addr = 0;
    8000623a:	00451713          	slli	a4,a0,0x4
    8000623e:	0003f797          	auipc	a5,0x3f
    80006242:	dc27b783          	ld	a5,-574(a5) # 80045000 <disk+0x2000>
    80006246:	97ba                	add	a5,a5,a4
    80006248:	0007b023          	sd	zero,0(a5)
  disk.free[i] = 1;
    8000624c:	0003d797          	auipc	a5,0x3d
    80006250:	db478793          	addi	a5,a5,-588 # 80043000 <disk>
    80006254:	97aa                	add	a5,a5,a0
    80006256:	6509                	lui	a0,0x2
    80006258:	953e                	add	a0,a0,a5
    8000625a:	4785                	li	a5,1
    8000625c:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80006260:	0003f517          	auipc	a0,0x3f
    80006264:	db850513          	addi	a0,a0,-584 # 80045018 <disk+0x2018>
    80006268:	ffffc097          	auipc	ra,0xffffc
    8000626c:	5d2080e7          	jalr	1490(ra) # 8000283a <wakeup>
}
    80006270:	60a2                	ld	ra,8(sp)
    80006272:	6402                	ld	s0,0(sp)
    80006274:	0141                	addi	sp,sp,16
    80006276:	8082                	ret
    panic("virtio_disk_intr 1");
    80006278:	00002517          	auipc	a0,0x2
    8000627c:	5c050513          	addi	a0,a0,1472 # 80008838 <syscalls+0x348>
    80006280:	ffffa097          	auipc	ra,0xffffa
    80006284:	364080e7          	jalr	868(ra) # 800005e4 <panic>
    panic("virtio_disk_intr 2");
    80006288:	00002517          	auipc	a0,0x2
    8000628c:	5c850513          	addi	a0,a0,1480 # 80008850 <syscalls+0x360>
    80006290:	ffffa097          	auipc	ra,0xffffa
    80006294:	354080e7          	jalr	852(ra) # 800005e4 <panic>

0000000080006298 <virtio_disk_init>:
{
    80006298:	1101                	addi	sp,sp,-32
    8000629a:	ec06                	sd	ra,24(sp)
    8000629c:	e822                	sd	s0,16(sp)
    8000629e:	e426                	sd	s1,8(sp)
    800062a0:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800062a2:	00002597          	auipc	a1,0x2
    800062a6:	5c658593          	addi	a1,a1,1478 # 80008868 <syscalls+0x378>
    800062aa:	0003f517          	auipc	a0,0x3f
    800062ae:	dfe50513          	addi	a0,a0,-514 # 800450a8 <disk+0x20a8>
    800062b2:	ffffb097          	auipc	ra,0xffffb
    800062b6:	c38080e7          	jalr	-968(ra) # 80000eea <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800062ba:	100017b7          	lui	a5,0x10001
    800062be:	4398                	lw	a4,0(a5)
    800062c0:	2701                	sext.w	a4,a4
    800062c2:	747277b7          	lui	a5,0x74727
    800062c6:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800062ca:	0ef71163          	bne	a4,a5,800063ac <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800062ce:	100017b7          	lui	a5,0x10001
    800062d2:	43dc                	lw	a5,4(a5)
    800062d4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800062d6:	4705                	li	a4,1
    800062d8:	0ce79a63          	bne	a5,a4,800063ac <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800062dc:	100017b7          	lui	a5,0x10001
    800062e0:	479c                	lw	a5,8(a5)
    800062e2:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800062e4:	4709                	li	a4,2
    800062e6:	0ce79363          	bne	a5,a4,800063ac <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800062ea:	100017b7          	lui	a5,0x10001
    800062ee:	47d8                	lw	a4,12(a5)
    800062f0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800062f2:	554d47b7          	lui	a5,0x554d4
    800062f6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800062fa:	0af71963          	bne	a4,a5,800063ac <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800062fe:	100017b7          	lui	a5,0x10001
    80006302:	4705                	li	a4,1
    80006304:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006306:	470d                	li	a4,3
    80006308:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000630a:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000630c:	c7ffe737          	lui	a4,0xc7ffe
    80006310:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fb875f>
    80006314:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006316:	2701                	sext.w	a4,a4
    80006318:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000631a:	472d                	li	a4,11
    8000631c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000631e:	473d                	li	a4,15
    80006320:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80006322:	6705                	lui	a4,0x1
    80006324:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006326:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000632a:	5bdc                	lw	a5,52(a5)
    8000632c:	2781                	sext.w	a5,a5
  if(max == 0)
    8000632e:	c7d9                	beqz	a5,800063bc <virtio_disk_init+0x124>
  if(max < NUM)
    80006330:	471d                	li	a4,7
    80006332:	08f77d63          	bgeu	a4,a5,800063cc <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006336:	100014b7          	lui	s1,0x10001
    8000633a:	47a1                	li	a5,8
    8000633c:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    8000633e:	6609                	lui	a2,0x2
    80006340:	4581                	li	a1,0
    80006342:	0003d517          	auipc	a0,0x3d
    80006346:	cbe50513          	addi	a0,a0,-834 # 80043000 <disk>
    8000634a:	ffffb097          	auipc	ra,0xffffb
    8000634e:	d2c080e7          	jalr	-724(ra) # 80001076 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80006352:	0003d717          	auipc	a4,0x3d
    80006356:	cae70713          	addi	a4,a4,-850 # 80043000 <disk>
    8000635a:	00c75793          	srli	a5,a4,0xc
    8000635e:	2781                	sext.w	a5,a5
    80006360:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct VRingDesc *) disk.pages;
    80006362:	0003f797          	auipc	a5,0x3f
    80006366:	c9e78793          	addi	a5,a5,-866 # 80045000 <disk+0x2000>
    8000636a:	e398                	sd	a4,0(a5)
  disk.avail = (uint16*)(((char*)disk.desc) + NUM*sizeof(struct VRingDesc));
    8000636c:	0003d717          	auipc	a4,0x3d
    80006370:	d1470713          	addi	a4,a4,-748 # 80043080 <disk+0x80>
    80006374:	e798                	sd	a4,8(a5)
  disk.used = (struct UsedArea *) (disk.pages + PGSIZE);
    80006376:	0003e717          	auipc	a4,0x3e
    8000637a:	c8a70713          	addi	a4,a4,-886 # 80044000 <disk+0x1000>
    8000637e:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80006380:	4705                	li	a4,1
    80006382:	00e78c23          	sb	a4,24(a5)
    80006386:	00e78ca3          	sb	a4,25(a5)
    8000638a:	00e78d23          	sb	a4,26(a5)
    8000638e:	00e78da3          	sb	a4,27(a5)
    80006392:	00e78e23          	sb	a4,28(a5)
    80006396:	00e78ea3          	sb	a4,29(a5)
    8000639a:	00e78f23          	sb	a4,30(a5)
    8000639e:	00e78fa3          	sb	a4,31(a5)
}
    800063a2:	60e2                	ld	ra,24(sp)
    800063a4:	6442                	ld	s0,16(sp)
    800063a6:	64a2                	ld	s1,8(sp)
    800063a8:	6105                	addi	sp,sp,32
    800063aa:	8082                	ret
    panic("could not find virtio disk");
    800063ac:	00002517          	auipc	a0,0x2
    800063b0:	4cc50513          	addi	a0,a0,1228 # 80008878 <syscalls+0x388>
    800063b4:	ffffa097          	auipc	ra,0xffffa
    800063b8:	230080e7          	jalr	560(ra) # 800005e4 <panic>
    panic("virtio disk has no queue 0");
    800063bc:	00002517          	auipc	a0,0x2
    800063c0:	4dc50513          	addi	a0,a0,1244 # 80008898 <syscalls+0x3a8>
    800063c4:	ffffa097          	auipc	ra,0xffffa
    800063c8:	220080e7          	jalr	544(ra) # 800005e4 <panic>
    panic("virtio disk max queue too short");
    800063cc:	00002517          	auipc	a0,0x2
    800063d0:	4ec50513          	addi	a0,a0,1260 # 800088b8 <syscalls+0x3c8>
    800063d4:	ffffa097          	auipc	ra,0xffffa
    800063d8:	210080e7          	jalr	528(ra) # 800005e4 <panic>

00000000800063dc <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800063dc:	7175                	addi	sp,sp,-144
    800063de:	e506                	sd	ra,136(sp)
    800063e0:	e122                	sd	s0,128(sp)
    800063e2:	fca6                	sd	s1,120(sp)
    800063e4:	f8ca                	sd	s2,112(sp)
    800063e6:	f4ce                	sd	s3,104(sp)
    800063e8:	f0d2                	sd	s4,96(sp)
    800063ea:	ecd6                	sd	s5,88(sp)
    800063ec:	e8da                	sd	s6,80(sp)
    800063ee:	e4de                	sd	s7,72(sp)
    800063f0:	e0e2                	sd	s8,64(sp)
    800063f2:	fc66                	sd	s9,56(sp)
    800063f4:	f86a                	sd	s10,48(sp)
    800063f6:	f46e                	sd	s11,40(sp)
    800063f8:	0900                	addi	s0,sp,144
    800063fa:	8aaa                	mv	s5,a0
    800063fc:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800063fe:	00c52c83          	lw	s9,12(a0)
    80006402:	001c9c9b          	slliw	s9,s9,0x1
    80006406:	1c82                	slli	s9,s9,0x20
    80006408:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    8000640c:	0003f517          	auipc	a0,0x3f
    80006410:	c9c50513          	addi	a0,a0,-868 # 800450a8 <disk+0x20a8>
    80006414:	ffffb097          	auipc	ra,0xffffb
    80006418:	b66080e7          	jalr	-1178(ra) # 80000f7a <acquire>
  for(int i = 0; i < 3; i++){
    8000641c:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    8000641e:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006420:	0003dc17          	auipc	s8,0x3d
    80006424:	be0c0c13          	addi	s8,s8,-1056 # 80043000 <disk>
    80006428:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    8000642a:	4b0d                	li	s6,3
    8000642c:	a0ad                	j	80006496 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    8000642e:	00fc0733          	add	a4,s8,a5
    80006432:	975e                	add	a4,a4,s7
    80006434:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80006438:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000643a:	0207c563          	bltz	a5,80006464 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    8000643e:	2905                	addiw	s2,s2,1
    80006440:	0611                	addi	a2,a2,4
    80006442:	19690d63          	beq	s2,s6,800065dc <virtio_disk_rw+0x200>
    idx[i] = alloc_desc();
    80006446:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006448:	0003f717          	auipc	a4,0x3f
    8000644c:	bd070713          	addi	a4,a4,-1072 # 80045018 <disk+0x2018>
    80006450:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80006452:	00074683          	lbu	a3,0(a4)
    80006456:	fee1                	bnez	a3,8000642e <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80006458:	2785                	addiw	a5,a5,1
    8000645a:	0705                	addi	a4,a4,1
    8000645c:	fe979be3          	bne	a5,s1,80006452 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80006460:	57fd                	li	a5,-1
    80006462:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80006464:	01205d63          	blez	s2,8000647e <virtio_disk_rw+0xa2>
    80006468:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    8000646a:	000a2503          	lw	a0,0(s4)
    8000646e:	00000097          	auipc	ra,0x0
    80006472:	da8080e7          	jalr	-600(ra) # 80006216 <free_desc>
      for(int j = 0; j < i; j++)
    80006476:	2d85                	addiw	s11,s11,1
    80006478:	0a11                	addi	s4,s4,4
    8000647a:	ffb918e3          	bne	s2,s11,8000646a <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000647e:	0003f597          	auipc	a1,0x3f
    80006482:	c2a58593          	addi	a1,a1,-982 # 800450a8 <disk+0x20a8>
    80006486:	0003f517          	auipc	a0,0x3f
    8000648a:	b9250513          	addi	a0,a0,-1134 # 80045018 <disk+0x2018>
    8000648e:	ffffc097          	auipc	ra,0xffffc
    80006492:	22c080e7          	jalr	556(ra) # 800026ba <sleep>
  for(int i = 0; i < 3; i++){
    80006496:	f8040a13          	addi	s4,s0,-128
{
    8000649a:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    8000649c:	894e                	mv	s2,s3
    8000649e:	b765                	j	80006446 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800064a0:	0003f717          	auipc	a4,0x3f
    800064a4:	b6073703          	ld	a4,-1184(a4) # 80045000 <disk+0x2000>
    800064a8:	973e                	add	a4,a4,a5
    800064aa:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800064ae:	0003d517          	auipc	a0,0x3d
    800064b2:	b5250513          	addi	a0,a0,-1198 # 80043000 <disk>
    800064b6:	0003f717          	auipc	a4,0x3f
    800064ba:	b4a70713          	addi	a4,a4,-1206 # 80045000 <disk+0x2000>
    800064be:	6314                	ld	a3,0(a4)
    800064c0:	96be                	add	a3,a3,a5
    800064c2:	00c6d603          	lhu	a2,12(a3)
    800064c6:	00166613          	ori	a2,a2,1
    800064ca:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800064ce:	f8842683          	lw	a3,-120(s0)
    800064d2:	6310                	ld	a2,0(a4)
    800064d4:	97b2                	add	a5,a5,a2
    800064d6:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0;
    800064da:	20048613          	addi	a2,s1,512 # 10001200 <_entry-0x6fffee00>
    800064de:	0612                	slli	a2,a2,0x4
    800064e0:	962a                	add	a2,a2,a0
    800064e2:	02060823          	sb	zero,48(a2) # 2030 <_entry-0x7fffdfd0>
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800064e6:	00469793          	slli	a5,a3,0x4
    800064ea:	630c                	ld	a1,0(a4)
    800064ec:	95be                	add	a1,a1,a5
    800064ee:	6689                	lui	a3,0x2
    800064f0:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    800064f4:	96ca                	add	a3,a3,s2
    800064f6:	96aa                	add	a3,a3,a0
    800064f8:	e194                	sd	a3,0(a1)
  disk.desc[idx[2]].len = 1;
    800064fa:	6314                	ld	a3,0(a4)
    800064fc:	96be                	add	a3,a3,a5
    800064fe:	4585                	li	a1,1
    80006500:	c68c                	sw	a1,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006502:	6314                	ld	a3,0(a4)
    80006504:	96be                	add	a3,a3,a5
    80006506:	4509                	li	a0,2
    80006508:	00a69623          	sh	a0,12(a3)
  disk.desc[idx[2]].next = 0;
    8000650c:	6314                	ld	a3,0(a4)
    8000650e:	97b6                	add	a5,a5,a3
    80006510:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006514:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    80006518:	03563423          	sd	s5,40(a2)

  // avail[0] is flags
  // avail[1] tells the device how far to look in avail[2...].
  // avail[2...] are desc[] indices the device should process.
  // we only tell device the first index in our chain of descriptors.
  disk.avail[2 + (disk.avail[1] % NUM)] = idx[0];
    8000651c:	6714                	ld	a3,8(a4)
    8000651e:	0026d783          	lhu	a5,2(a3)
    80006522:	8b9d                	andi	a5,a5,7
    80006524:	0789                	addi	a5,a5,2
    80006526:	0786                	slli	a5,a5,0x1
    80006528:	97b6                	add	a5,a5,a3
    8000652a:	00979023          	sh	s1,0(a5)
  __sync_synchronize();
    8000652e:	0ff0000f          	fence
  disk.avail[1] = disk.avail[1] + 1;
    80006532:	6718                	ld	a4,8(a4)
    80006534:	00275783          	lhu	a5,2(a4)
    80006538:	2785                	addiw	a5,a5,1
    8000653a:	00f71123          	sh	a5,2(a4)

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000653e:	100017b7          	lui	a5,0x10001
    80006542:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006546:	004aa783          	lw	a5,4(s5)
    8000654a:	02b79163          	bne	a5,a1,8000656c <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    8000654e:	0003f917          	auipc	s2,0x3f
    80006552:	b5a90913          	addi	s2,s2,-1190 # 800450a8 <disk+0x20a8>
  while(b->disk == 1) {
    80006556:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80006558:	85ca                	mv	a1,s2
    8000655a:	8556                	mv	a0,s5
    8000655c:	ffffc097          	auipc	ra,0xffffc
    80006560:	15e080e7          	jalr	350(ra) # 800026ba <sleep>
  while(b->disk == 1) {
    80006564:	004aa783          	lw	a5,4(s5)
    80006568:	fe9788e3          	beq	a5,s1,80006558 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    8000656c:	f8042483          	lw	s1,-128(s0)
    80006570:	20048793          	addi	a5,s1,512
    80006574:	00479713          	slli	a4,a5,0x4
    80006578:	0003d797          	auipc	a5,0x3d
    8000657c:	a8878793          	addi	a5,a5,-1400 # 80043000 <disk>
    80006580:	97ba                	add	a5,a5,a4
    80006582:	0207b423          	sd	zero,40(a5)
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    80006586:	0003f917          	auipc	s2,0x3f
    8000658a:	a7a90913          	addi	s2,s2,-1414 # 80045000 <disk+0x2000>
    8000658e:	a019                	j	80006594 <virtio_disk_rw+0x1b8>
      i = disk.desc[i].next;
    80006590:	00e4d483          	lhu	s1,14(s1)
    free_desc(i);
    80006594:	8526                	mv	a0,s1
    80006596:	00000097          	auipc	ra,0x0
    8000659a:	c80080e7          	jalr	-896(ra) # 80006216 <free_desc>
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    8000659e:	0492                	slli	s1,s1,0x4
    800065a0:	00093783          	ld	a5,0(s2)
    800065a4:	94be                	add	s1,s1,a5
    800065a6:	00c4d783          	lhu	a5,12(s1)
    800065aa:	8b85                	andi	a5,a5,1
    800065ac:	f3f5                	bnez	a5,80006590 <virtio_disk_rw+0x1b4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800065ae:	0003f517          	auipc	a0,0x3f
    800065b2:	afa50513          	addi	a0,a0,-1286 # 800450a8 <disk+0x20a8>
    800065b6:	ffffb097          	auipc	ra,0xffffb
    800065ba:	a78080e7          	jalr	-1416(ra) # 8000102e <release>
}
    800065be:	60aa                	ld	ra,136(sp)
    800065c0:	640a                	ld	s0,128(sp)
    800065c2:	74e6                	ld	s1,120(sp)
    800065c4:	7946                	ld	s2,112(sp)
    800065c6:	79a6                	ld	s3,104(sp)
    800065c8:	7a06                	ld	s4,96(sp)
    800065ca:	6ae6                	ld	s5,88(sp)
    800065cc:	6b46                	ld	s6,80(sp)
    800065ce:	6ba6                	ld	s7,72(sp)
    800065d0:	6c06                	ld	s8,64(sp)
    800065d2:	7ce2                	ld	s9,56(sp)
    800065d4:	7d42                	ld	s10,48(sp)
    800065d6:	7da2                	ld	s11,40(sp)
    800065d8:	6149                	addi	sp,sp,144
    800065da:	8082                	ret
  if(write)
    800065dc:	01a037b3          	snez	a5,s10
    800065e0:	f6f42823          	sw	a5,-144(s0)
  buf0.reserved = 0;
    800065e4:	f6042a23          	sw	zero,-140(s0)
  buf0.sector = sector;
    800065e8:	f7943c23          	sd	s9,-136(s0)
  disk.desc[idx[0]].addr = (uint64) kvmpa((uint64) &buf0);
    800065ec:	f8042483          	lw	s1,-128(s0)
    800065f0:	00449913          	slli	s2,s1,0x4
    800065f4:	0003f997          	auipc	s3,0x3f
    800065f8:	a0c98993          	addi	s3,s3,-1524 # 80045000 <disk+0x2000>
    800065fc:	0009ba03          	ld	s4,0(s3)
    80006600:	9a4a                	add	s4,s4,s2
    80006602:	f7040513          	addi	a0,s0,-144
    80006606:	ffffb097          	auipc	ra,0xffffb
    8000660a:	e36080e7          	jalr	-458(ra) # 8000143c <kvmpa>
    8000660e:	00aa3023          	sd	a0,0(s4)
  disk.desc[idx[0]].len = sizeof(buf0);
    80006612:	0009b783          	ld	a5,0(s3)
    80006616:	97ca                	add	a5,a5,s2
    80006618:	4741                	li	a4,16
    8000661a:	c798                	sw	a4,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000661c:	0009b783          	ld	a5,0(s3)
    80006620:	97ca                	add	a5,a5,s2
    80006622:	4705                	li	a4,1
    80006624:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80006628:	f8442783          	lw	a5,-124(s0)
    8000662c:	0009b703          	ld	a4,0(s3)
    80006630:	974a                	add	a4,a4,s2
    80006632:	00f71723          	sh	a5,14(a4)
  disk.desc[idx[1]].addr = (uint64) b->data;
    80006636:	0792                	slli	a5,a5,0x4
    80006638:	0009b703          	ld	a4,0(s3)
    8000663c:	973e                	add	a4,a4,a5
    8000663e:	058a8693          	addi	a3,s5,88
    80006642:	e314                	sd	a3,0(a4)
  disk.desc[idx[1]].len = BSIZE;
    80006644:	0009b703          	ld	a4,0(s3)
    80006648:	973e                	add	a4,a4,a5
    8000664a:	40000693          	li	a3,1024
    8000664e:	c714                	sw	a3,8(a4)
  if(write)
    80006650:	e40d18e3          	bnez	s10,800064a0 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80006654:	0003f717          	auipc	a4,0x3f
    80006658:	9ac73703          	ld	a4,-1620(a4) # 80045000 <disk+0x2000>
    8000665c:	973e                	add	a4,a4,a5
    8000665e:	4689                	li	a3,2
    80006660:	00d71623          	sh	a3,12(a4)
    80006664:	b5a9                	j	800064ae <virtio_disk_rw+0xd2>

0000000080006666 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006666:	1101                	addi	sp,sp,-32
    80006668:	ec06                	sd	ra,24(sp)
    8000666a:	e822                	sd	s0,16(sp)
    8000666c:	e426                	sd	s1,8(sp)
    8000666e:	e04a                	sd	s2,0(sp)
    80006670:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006672:	0003f517          	auipc	a0,0x3f
    80006676:	a3650513          	addi	a0,a0,-1482 # 800450a8 <disk+0x20a8>
    8000667a:	ffffb097          	auipc	ra,0xffffb
    8000667e:	900080e7          	jalr	-1792(ra) # 80000f7a <acquire>

  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    80006682:	0003f717          	auipc	a4,0x3f
    80006686:	97e70713          	addi	a4,a4,-1666 # 80045000 <disk+0x2000>
    8000668a:	02075783          	lhu	a5,32(a4)
    8000668e:	6b18                	ld	a4,16(a4)
    80006690:	00275683          	lhu	a3,2(a4)
    80006694:	8ebd                	xor	a3,a3,a5
    80006696:	8a9d                	andi	a3,a3,7
    80006698:	cab9                	beqz	a3,800066ee <virtio_disk_intr+0x88>
    int id = disk.used->elems[disk.used_idx].id;

    if(disk.info[id].status != 0)
    8000669a:	0003d917          	auipc	s2,0x3d
    8000669e:	96690913          	addi	s2,s2,-1690 # 80043000 <disk>
      panic("virtio_disk_intr status");
    
    disk.info[id].b->disk = 0;   // disk is done with buf
    wakeup(disk.info[id].b);

    disk.used_idx = (disk.used_idx + 1) % NUM;
    800066a2:	0003f497          	auipc	s1,0x3f
    800066a6:	95e48493          	addi	s1,s1,-1698 # 80045000 <disk+0x2000>
    int id = disk.used->elems[disk.used_idx].id;
    800066aa:	078e                	slli	a5,a5,0x3
    800066ac:	97ba                	add	a5,a5,a4
    800066ae:	43dc                	lw	a5,4(a5)
    if(disk.info[id].status != 0)
    800066b0:	20078713          	addi	a4,a5,512
    800066b4:	0712                	slli	a4,a4,0x4
    800066b6:	974a                	add	a4,a4,s2
    800066b8:	03074703          	lbu	a4,48(a4)
    800066bc:	ef21                	bnez	a4,80006714 <virtio_disk_intr+0xae>
    disk.info[id].b->disk = 0;   // disk is done with buf
    800066be:	20078793          	addi	a5,a5,512
    800066c2:	0792                	slli	a5,a5,0x4
    800066c4:	97ca                	add	a5,a5,s2
    800066c6:	7798                	ld	a4,40(a5)
    800066c8:	00072223          	sw	zero,4(a4)
    wakeup(disk.info[id].b);
    800066cc:	7788                	ld	a0,40(a5)
    800066ce:	ffffc097          	auipc	ra,0xffffc
    800066d2:	16c080e7          	jalr	364(ra) # 8000283a <wakeup>
    disk.used_idx = (disk.used_idx + 1) % NUM;
    800066d6:	0204d783          	lhu	a5,32(s1)
    800066da:	2785                	addiw	a5,a5,1
    800066dc:	8b9d                	andi	a5,a5,7
    800066de:	02f49023          	sh	a5,32(s1)
  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    800066e2:	6898                	ld	a4,16(s1)
    800066e4:	00275683          	lhu	a3,2(a4)
    800066e8:	8a9d                	andi	a3,a3,7
    800066ea:	fcf690e3          	bne	a3,a5,800066aa <virtio_disk_intr+0x44>
  }
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800066ee:	10001737          	lui	a4,0x10001
    800066f2:	533c                	lw	a5,96(a4)
    800066f4:	8b8d                	andi	a5,a5,3
    800066f6:	d37c                	sw	a5,100(a4)

  release(&disk.vdisk_lock);
    800066f8:	0003f517          	auipc	a0,0x3f
    800066fc:	9b050513          	addi	a0,a0,-1616 # 800450a8 <disk+0x20a8>
    80006700:	ffffb097          	auipc	ra,0xffffb
    80006704:	92e080e7          	jalr	-1746(ra) # 8000102e <release>
}
    80006708:	60e2                	ld	ra,24(sp)
    8000670a:	6442                	ld	s0,16(sp)
    8000670c:	64a2                	ld	s1,8(sp)
    8000670e:	6902                	ld	s2,0(sp)
    80006710:	6105                	addi	sp,sp,32
    80006712:	8082                	ret
      panic("virtio_disk_intr status");
    80006714:	00002517          	auipc	a0,0x2
    80006718:	1c450513          	addi	a0,a0,452 # 800088d8 <syscalls+0x3e8>
    8000671c:	ffffa097          	auipc	ra,0xffffa
    80006720:	ec8080e7          	jalr	-312(ra) # 800005e4 <panic>

0000000080006724 <mem_init>:
  page_t *next_page;
} allocator_t;

static allocator_t alloc;
static int if_init = 0;
void mem_init() {
    80006724:	1141                	addi	sp,sp,-16
    80006726:	e406                	sd	ra,8(sp)
    80006728:	e022                	sd	s0,0(sp)
    8000672a:	0800                	addi	s0,sp,16
  alloc.next_page = kalloc();
    8000672c:	ffffa097          	auipc	ra,0xffffa
    80006730:	63c080e7          	jalr	1596(ra) # 80000d68 <kalloc>
    80006734:	00003797          	auipc	a5,0x3
    80006738:	8ea7be23          	sd	a0,-1796(a5) # 80009030 <alloc>
  page_t *p = (page_t *)alloc.next_page;
  p->cur = (void *)p + sizeof(page_t);
    8000673c:	00850793          	addi	a5,a0,8
    80006740:	e11c                	sd	a5,0(a0)
}
    80006742:	60a2                	ld	ra,8(sp)
    80006744:	6402                	ld	s0,0(sp)
    80006746:	0141                	addi	sp,sp,16
    80006748:	8082                	ret

000000008000674a <mallo>:

void *mallo(u32 size) {
    8000674a:	1101                	addi	sp,sp,-32
    8000674c:	ec06                	sd	ra,24(sp)
    8000674e:	e822                	sd	s0,16(sp)
    80006750:	e426                	sd	s1,8(sp)
    80006752:	1000                	addi	s0,sp,32
    80006754:	84aa                	mv	s1,a0
  if (!if_init) {
    80006756:	00003797          	auipc	a5,0x3
    8000675a:	8d27a783          	lw	a5,-1838(a5) # 80009028 <if_init>
    8000675e:	cf9d                	beqz	a5,8000679c <mallo+0x52>
    mem_init();
    if_init = 1;
  }
  void *res = 0;
  printf("size %d ", size);
    80006760:	85a6                	mv	a1,s1
    80006762:	00002517          	auipc	a0,0x2
    80006766:	18e50513          	addi	a0,a0,398 # 800088f0 <syscalls+0x400>
    8000676a:	ffffa097          	auipc	ra,0xffffa
    8000676e:	ecc080e7          	jalr	-308(ra) # 80000636 <printf>
  u32 avail = PGSIZE - (alloc.next_page->cur - (void *)(alloc.next_page)) -
    80006772:	00003717          	auipc	a4,0x3
    80006776:	8be73703          	ld	a4,-1858(a4) # 80009030 <alloc>
    8000677a:	6308                	ld	a0,0(a4)
    8000677c:	40e506b3          	sub	a3,a0,a4
              sizeof(page_t);
  if (avail > size) {
    80006780:	6785                	lui	a5,0x1
    80006782:	37e1                	addiw	a5,a5,-8
    80006784:	9f95                	subw	a5,a5,a3
    80006786:	02f4f563          	bgeu	s1,a5,800067b0 <mallo+0x66>
    res = alloc.next_page->cur;
    alloc.next_page->cur += size;
    8000678a:	1482                	slli	s1,s1,0x20
    8000678c:	9081                	srli	s1,s1,0x20
    8000678e:	94aa                	add	s1,s1,a0
    80006790:	e304                	sd	s1,0(a4)
  } else {
    printf("malloc failed");
    return 0;
  }
  return res;
}
    80006792:	60e2                	ld	ra,24(sp)
    80006794:	6442                	ld	s0,16(sp)
    80006796:	64a2                	ld	s1,8(sp)
    80006798:	6105                	addi	sp,sp,32
    8000679a:	8082                	ret
    mem_init();
    8000679c:	00000097          	auipc	ra,0x0
    800067a0:	f88080e7          	jalr	-120(ra) # 80006724 <mem_init>
    if_init = 1;
    800067a4:	4785                	li	a5,1
    800067a6:	00003717          	auipc	a4,0x3
    800067aa:	88f72123          	sw	a5,-1918(a4) # 80009028 <if_init>
    800067ae:	bf4d                	j	80006760 <mallo+0x16>
    printf("malloc failed");
    800067b0:	00002517          	auipc	a0,0x2
    800067b4:	15050513          	addi	a0,a0,336 # 80008900 <syscalls+0x410>
    800067b8:	ffffa097          	auipc	ra,0xffffa
    800067bc:	e7e080e7          	jalr	-386(ra) # 80000636 <printf>
    return 0;
    800067c0:	4501                	li	a0,0
    800067c2:	bfc1                	j	80006792 <mallo+0x48>

00000000800067c4 <free>:

    800067c4:	1141                	addi	sp,sp,-16
    800067c6:	e422                	sd	s0,8(sp)
    800067c8:	0800                	addi	s0,sp,16
    800067ca:	6422                	ld	s0,8(sp)
    800067cc:	0141                	addi	sp,sp,16
    800067ce:	8082                	ret
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
