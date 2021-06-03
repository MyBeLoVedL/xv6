
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
    80000060:	36478793          	addi	a5,a5,868 # 800063c0 <timervec>
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
    80000094:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffac7ff>
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
    80000126:	00003097          	auipc	ra,0x3
    8000012a:	a2c080e7          	jalr	-1492(ra) # 80002b52 <either_copyin>
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
    800001ce:	ec4080e7          	jalr	-316(ra) # 8000208e <myproc>
    800001d2:	591c                	lw	a5,48(a0)
    800001d4:	e7b5                	bnez	a5,80000240 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    800001d6:	85a6                	mv	a1,s1
    800001d8:	854a                	mv	a0,s2
    800001da:	00002097          	auipc	ra,0x2
    800001de:	6c8080e7          	jalr	1736(ra) # 800028a2 <sleep>
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
    80000216:	00003097          	auipc	ra,0x3
    8000021a:	8e6080e7          	jalr	-1818(ra) # 80002afc <either_copyout>
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
    800002f6:	00003097          	auipc	ra,0x3
    800002fa:	8b2080e7          	jalr	-1870(ra) # 80002ba8 <procdump>
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
    8000044e:	5d8080e7          	jalr	1496(ra) # 80002a22 <wakeup>
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
    8000047c:	0004d797          	auipc	a5,0x4d
    80000480:	54478793          	addi	a5,a5,1348 # 8004d9c0 <devsw>
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
    8000091e:	108080e7          	jalr	264(ra) # 80002a22 <wakeup>
    
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
    800009b8:	eee080e7          	jalr	-274(ra) # 800028a2 <sleep>
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
    80000a9e:	00051797          	auipc	a5,0x51
    80000aa2:	56278793          	addi	a5,a5,1378 # 80052000 <end>
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
    80000be4:	00051517          	auipc	a0,0x51
    80000be8:	41c50513          	addi	a0,a0,1052 # 80052000 <end>
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
    80000cd8:	39e080e7          	jalr	926(ra) # 80002072 <mycpu>
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
    80000d0a:	36c080e7          	jalr	876(ra) # 80002072 <mycpu>
    80000d0e:	5d3c                	lw	a5,120(a0)
    80000d10:	cf89                	beqz	a5,80000d2a <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000d12:	00001097          	auipc	ra,0x1
    80000d16:	360080e7          	jalr	864(ra) # 80002072 <mycpu>
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
    80000d2e:	348080e7          	jalr	840(ra) # 80002072 <mycpu>
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
    80000d6e:	308080e7          	jalr	776(ra) # 80002072 <mycpu>
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
    80000d9a:	2dc080e7          	jalr	732(ra) # 80002072 <mycpu>
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
    80000ff0:	076080e7          	jalr	118(ra) # 80002062 <cpuid>
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
    8000100c:	05a080e7          	jalr	90(ra) # 80002062 <cpuid>
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
    8000102e:	cbe080e7          	jalr	-834(ra) # 80002ce8 <trapinithart>
    plicinithart(); // ask PLIC for device interrupts
    80001032:	00005097          	auipc	ra,0x5
    80001036:	3ce080e7          	jalr	974(ra) # 80006400 <plicinithart>
  }

  scheduler();
    8000103a:	00001097          	auipc	ra,0x1
    8000103e:	588080e7          	jalr	1416(ra) # 800025c2 <scheduler>
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
    8000109e:	ef8080e7          	jalr	-264(ra) # 80001f92 <procinit>
    trapinit();         // trap vectors
    800010a2:	00002097          	auipc	ra,0x2
    800010a6:	c1e080e7          	jalr	-994(ra) # 80002cc0 <trapinit>
    trapinithart();     // install kernel trap vector
    800010aa:	00002097          	auipc	ra,0x2
    800010ae:	c3e080e7          	jalr	-962(ra) # 80002ce8 <trapinithart>
    plicinit();         // set up interrupt controller
    800010b2:	00005097          	auipc	ra,0x5
    800010b6:	338080e7          	jalr	824(ra) # 800063ea <plicinit>
    plicinithart();     // ask PLIC for device interrupts
    800010ba:	00005097          	auipc	ra,0x5
    800010be:	346080e7          	jalr	838(ra) # 80006400 <plicinithart>
    binit();            // buffer cache
    800010c2:	00002097          	auipc	ra,0x2
    800010c6:	4ee080e7          	jalr	1262(ra) # 800035b0 <binit>
    iinit();            // inode cache
    800010ca:	00003097          	auipc	ra,0x3
    800010ce:	b7e080e7          	jalr	-1154(ra) # 80003c48 <iinit>
    fileinit();         // file table
    800010d2:	00004097          	auipc	ra,0x4
    800010d6:	b1c080e7          	jalr	-1252(ra) # 80004bee <fileinit>
    virtio_disk_init(); // emulated hard disk
    800010da:	00005097          	auipc	ra,0x5
    800010de:	42e080e7          	jalr	1070(ra) # 80006508 <virtio_disk_init>
    userinit();         // first user process
    800010e2:	00001097          	auipc	ra,0x1
    800010e6:	276080e7          	jalr	630(ra) # 80002358 <userinit>
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
    800018d4:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffad000>
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
    80001a84:	60e080e7          	jalr	1550(ra) # 8000208e <myproc>
    80001a88:	653c                	ld	a5,72(a0)
    80001a8a:	06f97963          	bgeu	s2,a5,80001afc <copyout+0xca>
      if (do_lazy_allocation(myproc()->pagetable, va0) != 0) {
    80001a8e:	00000097          	auipc	ra,0x0
    80001a92:	600080e7          	jalr	1536(ra) # 8000208e <myproc>
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
    80001b1a:	578080e7          	jalr	1400(ra) # 8000208e <myproc>
    80001b1e:	653c                	ld	a5,72(a0)
    80001b20:	f8f972e3          	bgeu	s2,a5,80001aa4 <copyout+0x72>
    80001b24:	b7ad                	j	80001a8e <copyout+0x5c>

0000000080001b26 <find_avail_addr_range>:
void *find_avail_addr_range(vma_t *vma) {
    80001b26:	1141                	addi	sp,sp,-16
    80001b28:	e422                	sd	s0,8(sp)
    80001b2a:	0800                	addi	s0,sp,16
    80001b2c:	87aa                	mv	a5,a0
  void *avail = (void *)VMA_ORIGIN;
  for (int i = 0; i < MAX_VMA; i++) {
    80001b2e:	30050613          	addi	a2,a0,768
  void *avail = (void *)VMA_ORIGIN;
    80001b32:	4705                	li	a4,1
    80001b34:	02071513          	slli	a0,a4,0x20
    if ((vma + i)->used) {
      if ((vma + i)->start + (vma + i)->length > avail)
        avail =
            (void *)PGROUNDUP((uint64)((vma + i)->start + (vma + i)->length));
    80001b38:	6585                	lui	a1,0x1
    80001b3a:	15fd                	addi	a1,a1,-1
    80001b3c:	787d                	lui	a6,0xfffff
    80001b3e:	a029                	j	80001b48 <find_avail_addr_range+0x22>
  for (int i = 0; i < MAX_VMA; i++) {
    80001b40:	03078793          	addi	a5,a5,48 # ffffffff80000030 <end+0xfffffffefffae030>
    80001b44:	00c78e63          	beq	a5,a2,80001b60 <find_avail_addr_range+0x3a>
    if ((vma + i)->used) {
    80001b48:	0287c683          	lbu	a3,40(a5)
    80001b4c:	daf5                	beqz	a3,80001b40 <find_avail_addr_range+0x1a>
      if ((vma + i)->start + (vma + i)->length > avail)
    80001b4e:	4b94                	lw	a3,16(a5)
    80001b50:	6398                	ld	a4,0(a5)
    80001b52:	9736                	add	a4,a4,a3
    80001b54:	fee576e3          	bgeu	a0,a4,80001b40 <find_avail_addr_range+0x1a>
            (void *)PGROUNDUP((uint64)((vma + i)->start + (vma + i)->length));
    80001b58:	972e                	add	a4,a4,a1
    80001b5a:	01077533          	and	a0,a4,a6
    80001b5e:	b7cd                	j	80001b40 <find_avail_addr_range+0x1a>
    }
  }
  return avail;
}
    80001b60:	6422                	ld	s0,8(sp)
    80001b62:	0141                	addi	sp,sp,16
    80001b64:	8082                	ret

0000000080001b66 <do_vma>:

int do_vma(void *addr, vma_t *vma) {
    80001b66:	7179                	addi	sp,sp,-48
    80001b68:	f406                	sd	ra,40(sp)
    80001b6a:	f022                	sd	s0,32(sp)
    80001b6c:	ec26                	sd	s1,24(sp)
    80001b6e:	e84a                	sd	s2,16(sp)
    80001b70:	e44e                	sd	s3,8(sp)
    80001b72:	e052                	sd	s4,0(sp)
    80001b74:	1800                	addi	s0,sp,48
  if (addr < vma->start || addr >= vma->start + vma->length)
    80001b76:	619c                	ld	a5,0(a1)
    80001b78:	08f56a63          	bltu	a0,a5,80001c0c <do_vma+0xa6>
    80001b7c:	89aa                	mv	s3,a0
    80001b7e:	84ae                	mv	s1,a1
    80001b80:	4998                	lw	a4,16(a1)
    80001b82:	97ba                	add	a5,a5,a4
    80001b84:	08f57463          	bgeu	a0,a5,80001c0c <do_vma+0xa6>
    panic("invalid mmap!!!");
  void *pa;
  if ((pa = kalloc()) == 0)
    80001b88:	fffff097          	auipc	ra,0xfffff
    80001b8c:	074080e7          	jalr	116(ra) # 80000bfc <kalloc>
    80001b90:	8a2a                	mv	s4,a0
    80001b92:	c155                	beqz	a0,80001c36 <do_vma+0xd0>
    return -1;
  memset(pa, 0, PGSIZE);
    80001b94:	6605                	lui	a2,0x1
    80001b96:	4581                	li	a1,0
    80001b98:	fffff097          	auipc	ra,0xfffff
    80001b9c:	29e080e7          	jalr	670(ra) # 80000e36 <memset>
  uint file_off = ((addr - vma->start + vma->offset) >> 12) << 12;
    80001ba0:	0004b903          	ld	s2,0(s1)
    80001ba4:	412987b3          	sub	a5,s3,s2
    80001ba8:	01c4a903          	lw	s2,28(s1)
    80001bac:	00f9093b          	addw	s2,s2,a5
    80001bb0:	77fd                	lui	a5,0xfffff
    80001bb2:	00f97933          	and	s2,s2,a5
    80001bb6:	2901                	sext.w	s2,s2
  ilock(vma->mmaped_file->ip);
    80001bb8:	709c                	ld	a5,32(s1)
    80001bba:	6f88                	ld	a0,24(a5)
    80001bbc:	00002097          	auipc	ra,0x2
    80001bc0:	284080e7          	jalr	644(ra) # 80003e40 <ilock>
  int rc = 0;
  if ((rc = readi(vma->mmaped_file->ip, 0, (uint64)pa, file_off, PGSIZE)) < 0) {
    80001bc4:	709c                	ld	a5,32(s1)
    80001bc6:	6705                	lui	a4,0x1
    80001bc8:	86ca                	mv	a3,s2
    80001bca:	8652                	mv	a2,s4
    80001bcc:	4581                	li	a1,0
    80001bce:	6f88                	ld	a0,24(a5)
    80001bd0:	00002097          	auipc	ra,0x2
    80001bd4:	524080e7          	jalr	1316(ra) # 800040f4 <readi>
    80001bd8:	04054263          	bltz	a0,80001c1c <do_vma+0xb6>
    printf("read failed , actual read %d\n", rc);
    return -2;
  }
  iunlock(vma->mmaped_file->ip);
    80001bdc:	709c                	ld	a5,32(s1)
    80001bde:	6f88                	ld	a0,24(a5)
    80001be0:	00002097          	auipc	ra,0x2
    80001be4:	322080e7          	jalr	802(ra) # 80003f02 <iunlock>
  int perm = PTE_U;
  if ((vma->mmaped_file->readable) && (vma->proct & PROT_READ))
    80001be8:	709c                	ld	a5,32(s1)
    80001bea:	0087c703          	lbu	a4,8(a5) # fffffffffffff008 <end+0xffffffff7ffad008>
    80001bee:	c731                	beqz	a4,80001c3a <do_vma+0xd4>
    80001bf0:	48d8                	lw	a4,20(s1)
    80001bf2:	00177693          	andi	a3,a4,1
  int perm = PTE_U;
    80001bf6:	4941                	li	s2,16
  if ((vma->mmaped_file->readable) && (vma->proct & PROT_READ))
    80001bf8:	c291                	beqz	a3,80001bfc <do_vma+0x96>
    perm |= PTE_R;
    80001bfa:	4949                	li	s2,18
  if (((vma->mmaped_file->writable) ||
    80001bfc:	0097c783          	lbu	a5,9(a5)
    80001c00:	e3b1                	bnez	a5,80001c44 <do_vma+0xde>
       (vma->mmaped_file->readable && (vma->proct & MAP_PRIVATE))) &&
    80001c02:	8b09                	andi	a4,a4,2
    80001c04:	c339                	beqz	a4,80001c4a <do_vma+0xe4>
      (vma->proct & PROT_WRITE))
    perm |= PTE_W;
    80001c06:	00496913          	ori	s2,s2,4
    80001c0a:	a081                	j	80001c4a <do_vma+0xe4>
    panic("invalid mmap!!!");
    80001c0c:	00006517          	auipc	a0,0x6
    80001c10:	5f450513          	addi	a0,a0,1524 # 80008200 <digits+0x198>
    80001c14:	fffff097          	auipc	ra,0xfffff
    80001c18:	9d0080e7          	jalr	-1584(ra) # 800005e4 <panic>
    printf("read failed , actual read %d\n", rc);
    80001c1c:	85aa                	mv	a1,a0
    80001c1e:	00006517          	auipc	a0,0x6
    80001c22:	5f250513          	addi	a0,a0,1522 # 80008210 <digits+0x1a8>
    80001c26:	fffff097          	auipc	ra,0xfffff
    80001c2a:	a10080e7          	jalr	-1520(ra) # 80000636 <printf>
    return -2;
    80001c2e:	5579                	li	a0,-2
    80001c30:	a0a9                	j	80001c7a <do_vma+0x114>
  if (vma->proct & PROT_EXEC)
    perm |= PTE_X;
  if (mappages(myproc()->pagetable, PGROUNDDOWN((uint64)addr), PGSIZE,
               (uint64)pa, perm) < 0)
    return -3;
    80001c32:	5575                	li	a0,-3
    80001c34:	a099                	j	80001c7a <do_vma+0x114>
    return -1;
    80001c36:	557d                	li	a0,-1
    80001c38:	a089                	j	80001c7a <do_vma+0x114>
  if (((vma->mmaped_file->writable) ||
    80001c3a:	0097c783          	lbu	a5,9(a5)
  int perm = PTE_U;
    80001c3e:	4941                	li	s2,16
  if (((vma->mmaped_file->writable) ||
    80001c40:	c789                	beqz	a5,80001c4a <do_vma+0xe4>
  int perm = PTE_U;
    80001c42:	4941                	li	s2,16
      (vma->proct & PROT_WRITE))
    80001c44:	48dc                	lw	a5,20(s1)
       (vma->mmaped_file->readable && (vma->proct & MAP_PRIVATE))) &&
    80001c46:	8b89                	andi	a5,a5,2
    80001c48:	ffdd                	bnez	a5,80001c06 <do_vma+0xa0>
  if (vma->proct & PROT_EXEC)
    80001c4a:	48dc                	lw	a5,20(s1)
    80001c4c:	8b91                	andi	a5,a5,4
    80001c4e:	c399                	beqz	a5,80001c54 <do_vma+0xee>
    perm |= PTE_X;
    80001c50:	00896913          	ori	s2,s2,8
  if (mappages(myproc()->pagetable, PGROUNDDOWN((uint64)addr), PGSIZE,
    80001c54:	00000097          	auipc	ra,0x0
    80001c58:	43a080e7          	jalr	1082(ra) # 8000208e <myproc>
    80001c5c:	874a                	mv	a4,s2
    80001c5e:	86d2                	mv	a3,s4
    80001c60:	6605                	lui	a2,0x1
    80001c62:	75fd                	lui	a1,0xfffff
    80001c64:	00b9f5b3          	and	a1,s3,a1
    80001c68:	6928                	ld	a0,80(a0)
    80001c6a:	fffff097          	auipc	ra,0xfffff
    80001c6e:	5f0080e7          	jalr	1520(ra) # 8000125a <mappages>
    80001c72:	87aa                	mv	a5,a0
  // printf("hello in do vma\n");
  return 0;
    80001c74:	4501                	li	a0,0
  if (mappages(myproc()->pagetable, PGROUNDDOWN((uint64)addr), PGSIZE,
    80001c76:	fa07cee3          	bltz	a5,80001c32 <do_vma+0xcc>
}
    80001c7a:	70a2                	ld	ra,40(sp)
    80001c7c:	7402                	ld	s0,32(sp)
    80001c7e:	64e2                	ld	s1,24(sp)
    80001c80:	6942                	ld	s2,16(sp)
    80001c82:	69a2                	ld	s3,8(sp)
    80001c84:	6a02                	ld	s4,0(sp)
    80001c86:	6145                	addi	sp,sp,48
    80001c88:	8082                	ret

0000000080001c8a <mmap>:

void *mmap(void *addr, int length, int proct, int flag, int fd, int offset) {
    80001c8a:	715d                	addi	sp,sp,-80
    80001c8c:	e486                	sd	ra,72(sp)
    80001c8e:	e0a2                	sd	s0,64(sp)
    80001c90:	fc26                	sd	s1,56(sp)
    80001c92:	f84a                	sd	s2,48(sp)
    80001c94:	f44e                	sd	s3,40(sp)
    80001c96:	f052                	sd	s4,32(sp)
    80001c98:	ec56                	sd	s5,24(sp)
    80001c9a:	e85a                	sd	s6,16(sp)
    80001c9c:	e45e                	sd	s7,8(sp)
    80001c9e:	0880                	addi	s0,sp,80
    80001ca0:	8b2e                	mv	s6,a1
    80001ca2:	89b2                	mv	s3,a2
    80001ca4:	8a36                	mv	s4,a3
    80001ca6:	84ba                	mv	s1,a4
    80001ca8:	8abe                	mv	s5,a5
  struct proc *p = myproc();
    80001caa:	00000097          	auipc	ra,0x0
    80001cae:	3e4080e7          	jalr	996(ra) # 8000208e <myproc>
  int i;
  if (!p->ofile[fd])
    80001cb2:	04e9                	addi	s1,s1,26
    80001cb4:	048e                	slli	s1,s1,0x3
    80001cb6:	94aa                	add	s1,s1,a0
    80001cb8:	6094                	ld	a3,0(s1)
    80001cba:	c2d5                	beqz	a3,80001d5e <mmap+0xd4>
    80001cbc:	892a                	mv	s2,a0
    goto err;
  // printf("map proct  %d flag  %d\n", proct, flag);
  if (((proct & PROT_WRITE) && !p->ofile[fd]->writable) && (flag & MAP_SHARED))
    80001cbe:	0029f793          	andi	a5,s3,2
    80001cc2:	c781                	beqz	a5,80001cca <mmap+0x40>
    80001cc4:	0096c783          	lbu	a5,9(a3)
    80001cc8:	c385                	beqz	a5,80001ce8 <mmap+0x5e>
    goto err;
  for (i = 0; i < MAX_VMA; i++) {
    80001cca:	19090713          	addi	a4,s2,400 # 1190 <_entry-0x7fffee70>
void *mmap(void *addr, int length, int proct, int flag, int fd, int offset) {
    80001cce:	4481                	li	s1,0
  for (i = 0; i < MAX_VMA; i++) {
    80001cd0:	47c1                	li	a5,16
    if (!p->vma[i].used) {
    80001cd2:	00074803          	lbu	a6,0(a4) # 1000 <_entry-0x7ffff000>
    80001cd6:	00080e63          	beqz	a6,80001cf2 <mmap+0x68>
  for (i = 0; i < MAX_VMA; i++) {
    80001cda:	2485                	addiw	s1,s1,1
    80001cdc:	03070713          	addi	a4,a4,48
    80001ce0:	fef499e3          	bne	s1,a5,80001cd2 <mmap+0x48>
      break;
    }
  }

  if (i == MAX_VMA)
    return (void *)-1;
    80001ce4:	557d                	li	a0,-1
    80001ce6:	a08d                	j	80001d48 <mmap+0xbe>
  if (((proct & PROT_WRITE) && !p->ofile[fd]->writable) && (flag & MAP_SHARED))
    80001ce8:	001a7793          	andi	a5,s4,1

  return p->vma[i].start;

err:
  return (void *)-1;
    80001cec:	557d                	li	a0,-1
  if (((proct & PROT_WRITE) && !p->ofile[fd]->writable) && (flag & MAP_SHARED))
    80001cee:	dff1                	beqz	a5,80001cca <mmap+0x40>
    80001cf0:	a8a1                	j	80001d48 <mmap+0xbe>
      p->vma[i].mmaped_file = filedup(p->ofile[fd]);
    80001cf2:	8536                	mv	a0,a3
    80001cf4:	00003097          	auipc	ra,0x3
    80001cf8:	f8c080e7          	jalr	-116(ra) # 80004c80 <filedup>
    80001cfc:	00149b93          	slli	s7,s1,0x1
    80001d00:	9ba6                	add	s7,s7,s1
    80001d02:	0b92                	slli	s7,s7,0x4
    80001d04:	9bca                	add	s7,s7,s2
    80001d06:	18abb423          	sd	a0,392(s7) # 1188 <_entry-0x7fffee78>
      p->vma[i].used = 1;
    80001d0a:	4785                	li	a5,1
    80001d0c:	18fb8823          	sb	a5,400(s7)
      p->vma[i].length = length;
    80001d10:	176bac23          	sw	s6,376(s7)
      p->vma[i].proct = proct;
    80001d14:	173bae23          	sw	s3,380(s7)
      p->vma[i].offset = offset;
    80001d18:	195ba223          	sw	s5,388(s7)
      p->vma[i].flag = flag;
    80001d1c:	194ba023          	sw	s4,384(s7)
      void *addr = find_avail_addr_range(&p->vma[0]);
    80001d20:	16890513          	addi	a0,s2,360
    80001d24:	00000097          	auipc	ra,0x0
    80001d28:	e02080e7          	jalr	-510(ra) # 80001b26 <find_avail_addr_range>
      p->vma[i].start = addr;
    80001d2c:	16abb423          	sd	a0,360(s7)
      p->vma[i].origin = addr;
    80001d30:	16abb823          	sd	a0,368(s7)
  if (i == MAX_VMA)
    80001d34:	47c1                	li	a5,16
    80001d36:	02f48663          	beq	s1,a5,80001d62 <mmap+0xd8>
  return p->vma[i].start;
    80001d3a:	00149793          	slli	a5,s1,0x1
    80001d3e:	94be                	add	s1,s1,a5
    80001d40:	0492                	slli	s1,s1,0x4
    80001d42:	9926                	add	s2,s2,s1
    80001d44:	16893503          	ld	a0,360(s2)
}
    80001d48:	60a6                	ld	ra,72(sp)
    80001d4a:	6406                	ld	s0,64(sp)
    80001d4c:	74e2                	ld	s1,56(sp)
    80001d4e:	7942                	ld	s2,48(sp)
    80001d50:	79a2                	ld	s3,40(sp)
    80001d52:	7a02                	ld	s4,32(sp)
    80001d54:	6ae2                	ld	s5,24(sp)
    80001d56:	6b42                	ld	s6,16(sp)
    80001d58:	6ba2                	ld	s7,8(sp)
    80001d5a:	6161                	addi	sp,sp,80
    80001d5c:	8082                	ret
  return (void *)-1;
    80001d5e:	557d                	li	a0,-1
    80001d60:	b7e5                	j	80001d48 <mmap+0xbe>
    return (void *)-1;
    80001d62:	557d                	li	a0,-1
    80001d64:	b7d5                	j	80001d48 <mmap+0xbe>

0000000080001d66 <munmap>:

int munmap(void *addr, int length) {
    80001d66:	7119                	addi	sp,sp,-128
    80001d68:	fc86                	sd	ra,120(sp)
    80001d6a:	f8a2                	sd	s0,112(sp)
    80001d6c:	f4a6                	sd	s1,104(sp)
    80001d6e:	f0ca                	sd	s2,96(sp)
    80001d70:	ecce                	sd	s3,88(sp)
    80001d72:	e8d2                	sd	s4,80(sp)
    80001d74:	e4d6                	sd	s5,72(sp)
    80001d76:	e0da                	sd	s6,64(sp)
    80001d78:	fc5e                	sd	s7,56(sp)
    80001d7a:	f862                	sd	s8,48(sp)
    80001d7c:	f466                	sd	s9,40(sp)
    80001d7e:	f06a                	sd	s10,32(sp)
    80001d80:	ec6e                	sd	s11,24(sp)
    80001d82:	0100                	addi	s0,sp,128
    80001d84:	892a                	mv	s2,a0
    80001d86:	8bae                	mv	s7,a1
  // printf("~~~hello in unmap\n");
  vma_t *vma;
  struct proc *p = myproc();
    80001d88:	00000097          	auipc	ra,0x0
    80001d8c:	306080e7          	jalr	774(ra) # 8000208e <myproc>
    80001d90:	8aaa                	mv	s5,a0
  uint8 valid = 0;
  for (int i = 0; i < MAX_VMA; i++) {
    80001d92:	16850793          	addi	a5,a0,360
    80001d96:	4481                	li	s1,0
    80001d98:	46c1                	li	a3,16
    80001d9a:	a031                	j	80001da6 <munmap+0x40>
    80001d9c:	2485                	addiw	s1,s1,1
    80001d9e:	03078793          	addi	a5,a5,48
    80001da2:	04d48463          	beq	s1,a3,80001dea <munmap+0x84>
    if (p->vma[i].start == addr && p->vma[i].length >= length) {
    80001da6:	6398                	ld	a4,0(a5)
    80001da8:	ff271ae3          	bne	a4,s2,80001d9c <munmap+0x36>
    80001dac:	4b98                	lw	a4,16(a5)
    80001dae:	ff7747e3          	blt	a4,s7,80001d9c <munmap+0x36>
    printf("not in vma\n");
    return -1;
  }
  int left = length, should_write = 0;
  void *cur = addr;
  vma->mmaped_file->off = cur - vma->origin + vma->offset;
    80001db2:	00149793          	slli	a5,s1,0x1
    80001db6:	97a6                	add	a5,a5,s1
    80001db8:	0792                	slli	a5,a5,0x4
    80001dba:	97d6                	add	a5,a5,s5
    80001dbc:	1887b683          	ld	a3,392(a5)
    80001dc0:	1707b703          	ld	a4,368(a5)
    80001dc4:	40e90733          	sub	a4,s2,a4
    80001dc8:	1847a783          	lw	a5,388(a5)
    80001dcc:	9fb9                	addw	a5,a5,a4
    80001dce:	d29c                	sw	a5,32(a3)
  // printf("flag %p proctect %p\n", vma->flag, vma->proct);
  for (cur = addr; cur < addr + length; cur += should_write) {
    80001dd0:	01790db3          	add	s11,s2,s7
  int left = length, should_write = 0;
    80001dd4:	8a5e                	mv	s4,s7
    80001dd6:	4b01                	li	s6,0
  for (cur = addr; cur < addr + length; cur += should_write) {
    80001dd8:	11b97063          	bgeu	s2,s11,80001ed8 <munmap+0x172>
    pte_t *pte = walk(p->pagetable, (uint64)cur, 0);
    if (!pte)
      continue;
    // if (!(*pte & PTE_V))
    //   panic("unrecognized");
    should_write = MIN(PGROUNDDOWN((uint64)cur) + PGSIZE - (uint64)cur, left);
    80001ddc:	6d05                	lui	s10,0x1
    left -= should_write;
    int wc = -9;
    if ((vma->flag & MAP_SHARED) && (*pte & PTE_D)) {
    80001dde:	00149c93          	slli	s9,s1,0x1
    80001de2:	9ca6                	add	s9,s9,s1
    80001de4:	0c92                	slli	s9,s9,0x4
    80001de6:	9cd6                	add	s9,s9,s5
    80001de8:	a071                	j	80001e74 <munmap+0x10e>
    printf("not in vma\n");
    80001dea:	00006517          	auipc	a0,0x6
    80001dee:	44650513          	addi	a0,a0,1094 # 80008230 <digits+0x1c8>
    80001df2:	fffff097          	auipc	ra,0xfffff
    80001df6:	844080e7          	jalr	-1980(ra) # 80000636 <printf>
    return -1;
    80001dfa:	557d                	li	a0,-1
  } else {
    vma->start += length;
    vma->length -= length;
  }
  return 0;
    80001dfc:	70e6                	ld	ra,120(sp)
    80001dfe:	7446                	ld	s0,112(sp)
    80001e00:	74a6                	ld	s1,104(sp)
    80001e02:	7906                	ld	s2,96(sp)
    80001e04:	69e6                	ld	s3,88(sp)
    80001e06:	6a46                	ld	s4,80(sp)
    80001e08:	6aa6                	ld	s5,72(sp)
    80001e0a:	6b06                	ld	s6,64(sp)
    80001e0c:	7be2                	ld	s7,56(sp)
    80001e0e:	7c42                	ld	s8,48(sp)
    80001e10:	7ca2                	ld	s9,40(sp)
    80001e12:	7d02                	ld	s10,32(sp)
    80001e14:	6de2                	ld	s11,24(sp)
    80001e16:	6109                	addi	sp,sp,128
    80001e18:	8082                	ret
      wc = filewrite(vma->mmaped_file, (uint64)cur, should_write);
    80001e1a:	865a                	mv	a2,s6
    80001e1c:	f8843583          	ld	a1,-120(s0)
    80001e20:	188cb503          	ld	a0,392(s9)
    80001e24:	00003097          	auipc	ra,0x3
    80001e28:	0aa080e7          	jalr	170(ra) # 80004ece <filewrite>
      if (wc < 0) {
    80001e2c:	08055663          	bgez	a0,80001eb8 <munmap+0x152>
               vma->mmaped_file->off, cur, should_write, wc);
    80001e30:	00149793          	slli	a5,s1,0x1
    80001e34:	97a6                	add	a5,a5,s1
    80001e36:	0792                	slli	a5,a5,0x4
    80001e38:	9abe                	add	s5,s5,a5
        printf("res %d offset %d cur %p should %d vma write %d\n", wc,
    80001e3a:	188ab603          	ld	a2,392(s5) # fffffffffffff188 <end+0xffffffff7ffad188>
    80001e3e:	87aa                	mv	a5,a0
    80001e40:	875a                	mv	a4,s6
    80001e42:	86ca                	mv	a3,s2
    80001e44:	5210                	lw	a2,32(a2)
    80001e46:	85aa                	mv	a1,a0
    80001e48:	00006517          	auipc	a0,0x6
    80001e4c:	3f850513          	addi	a0,a0,1016 # 80008240 <digits+0x1d8>
    80001e50:	ffffe097          	auipc	ra,0xffffe
    80001e54:	7e6080e7          	jalr	2022(ra) # 80000636 <printf>
        return -1;
    80001e58:	557d                	li	a0,-1
    80001e5a:	b74d                	j	80001dfc <munmap+0x96>
      uvmunmap(p->pagetable, PGROUNDDOWN((uint64)cur), 1, 1);
    80001e5c:	4685                	li	a3,1
    80001e5e:	4605                	li	a2,1
    80001e60:	85e2                	mv	a1,s8
    80001e62:	050ab503          	ld	a0,80(s5)
    80001e66:	fffff097          	auipc	ra,0xfffff
    80001e6a:	58c080e7          	jalr	1420(ra) # 800013f2 <uvmunmap>
  for (cur = addr; cur < addr + length; cur += should_write) {
    80001e6e:	995a                	add	s2,s2,s6
    80001e70:	07b97463          	bgeu	s2,s11,80001ed8 <munmap+0x172>
    pte_t *pte = walk(p->pagetable, (uint64)cur, 0);
    80001e74:	f9243423          	sd	s2,-120(s0)
    80001e78:	4601                	li	a2,0
    80001e7a:	85ca                	mv	a1,s2
    80001e7c:	050ab503          	ld	a0,80(s5)
    80001e80:	fffff097          	auipc	ra,0xfffff
    80001e84:	29e080e7          	jalr	670(ra) # 8000111e <walk>
    80001e88:	89aa                	mv	s3,a0
    if (!pte)
    80001e8a:	d175                	beqz	a0,80001e6e <munmap+0x108>
    should_write = MIN(PGROUNDDOWN((uint64)cur) + PGSIZE - (uint64)cur, left);
    80001e8c:	77fd                	lui	a5,0xfffff
    80001e8e:	00f97c33          	and	s8,s2,a5
    80001e92:	412c07b3          	sub	a5,s8,s2
    80001e96:	97ea                	add	a5,a5,s10
    80001e98:	00fa7363          	bgeu	s4,a5,80001e9e <munmap+0x138>
    80001e9c:	87d2                	mv	a5,s4
    80001e9e:	00078b1b          	sext.w	s6,a5
    left -= should_write;
    80001ea2:	40fa0a3b          	subw	s4,s4,a5
    if ((vma->flag & MAP_SHARED) && (*pte & PTE_D)) {
    80001ea6:	180ca783          	lw	a5,384(s9)
    80001eaa:	8b85                	andi	a5,a5,1
    80001eac:	c791                	beqz	a5,80001eb8 <munmap+0x152>
    80001eae:	0009b783          	ld	a5,0(s3) # fffffffffffff000 <end+0xffffffff7ffad000>
    80001eb2:	0807f793          	andi	a5,a5,128
    80001eb6:	f3b5                	bnez	a5,80001e1a <munmap+0xb4>
    if ((*pte & PTE_V) &&
    80001eb8:	0009b783          	ld	a5,0(s3)
    80001ebc:	8b85                	andi	a5,a5,1
    80001ebe:	dbc5                	beqz	a5,80001e6e <munmap+0x108>
        (((uint64)cur + should_write == PGROUNDDOWN((uint64)cur) + PGSIZE) ||
    80001ec0:	f8843783          	ld	a5,-120(s0)
    80001ec4:	97da                	add	a5,a5,s6
    80001ec6:	01ac0733          	add	a4,s8,s10
    if ((*pte & PTE_V) &&
    80001eca:	f8e789e3          	beq	a5,a4,80001e5c <munmap+0xf6>
        (((uint64)cur + should_write == PGROUNDDOWN((uint64)cur) + PGSIZE) ||
    80001ece:	178ca783          	lw	a5,376(s9)
    80001ed2:	f9679ee3          	bne	a5,s6,80001e6e <munmap+0x108>
    80001ed6:	b759                	j	80001e5c <munmap+0xf6>
  if (length == vma->length) {
    80001ed8:	00149793          	slli	a5,s1,0x1
    80001edc:	97a6                	add	a5,a5,s1
    80001ede:	0792                	slli	a5,a5,0x4
    80001ee0:	97d6                	add	a5,a5,s5
    80001ee2:	1787a683          	lw	a3,376(a5) # fffffffffffff178 <end+0xffffffff7ffad178>
    80001ee6:	03768363          	beq	a3,s7,80001f0c <munmap+0x1a6>
    vma->start += length;
    80001eea:	00149793          	slli	a5,s1,0x1
    80001eee:	00978733          	add	a4,a5,s1
    80001ef2:	0712                	slli	a4,a4,0x4
    80001ef4:	9756                	add	a4,a4,s5
    80001ef6:	16873603          	ld	a2,360(a4)
    80001efa:	965e                	add	a2,a2,s7
    80001efc:	16c73423          	sd	a2,360(a4)
    vma->length -= length;
    80001f00:	417686bb          	subw	a3,a3,s7
    80001f04:	16d72c23          	sw	a3,376(a4)
  return 0;
    80001f08:	4501                	li	a0,0
    80001f0a:	bdcd                	j	80001dfc <munmap+0x96>
    fileclose(vma->mmaped_file);
    80001f0c:	00149913          	slli	s2,s1,0x1
    80001f10:	009907b3          	add	a5,s2,s1
    80001f14:	0792                	slli	a5,a5,0x4
    80001f16:	97d6                	add	a5,a5,s5
    80001f18:	1887b503          	ld	a0,392(a5)
    80001f1c:	00003097          	auipc	ra,0x3
    80001f20:	db6080e7          	jalr	-586(ra) # 80004cd2 <fileclose>
      vma = &p->vma[i];
    80001f24:	00990533          	add	a0,s2,s1
    80001f28:	0512                	slli	a0,a0,0x4
    80001f2a:	16850513          	addi	a0,a0,360
    memset(vma, 0, sizeof(*vma));
    80001f2e:	03000613          	li	a2,48
    80001f32:	4581                	li	a1,0
    80001f34:	9556                	add	a0,a0,s5
    80001f36:	fffff097          	auipc	ra,0xfffff
    80001f3a:	f00080e7          	jalr	-256(ra) # 80000e36 <memset>
    vma->used = 0;
    80001f3e:	009907b3          	add	a5,s2,s1
    80001f42:	0792                	slli	a5,a5,0x4
    80001f44:	9abe                	add	s5,s5,a5
    80001f46:	180a8823          	sb	zero,400(s5)
  return 0;
    80001f4a:	4501                	li	a0,0
    80001f4c:	bd45                	j	80001dfc <munmap+0x96>

0000000080001f4e <wakeup1>:
  }
}

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void wakeup1(struct proc *p) {
    80001f4e:	1101                	addi	sp,sp,-32
    80001f50:	ec06                	sd	ra,24(sp)
    80001f52:	e822                	sd	s0,16(sp)
    80001f54:	e426                	sd	s1,8(sp)
    80001f56:	1000                	addi	s0,sp,32
    80001f58:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    80001f5a:	fffff097          	auipc	ra,0xfffff
    80001f5e:	d66080e7          	jalr	-666(ra) # 80000cc0 <holding>
    80001f62:	c909                	beqz	a0,80001f74 <wakeup1+0x26>
    panic("wakeup1");
  if (p->chan == p && p->state == SLEEPING) {
    80001f64:	749c                	ld	a5,40(s1)
    80001f66:	00978f63          	beq	a5,s1,80001f84 <wakeup1+0x36>
    p->state = RUNNABLE;
  }
}
    80001f6a:	60e2                	ld	ra,24(sp)
    80001f6c:	6442                	ld	s0,16(sp)
    80001f6e:	64a2                	ld	s1,8(sp)
    80001f70:	6105                	addi	sp,sp,32
    80001f72:	8082                	ret
    panic("wakeup1");
    80001f74:	00006517          	auipc	a0,0x6
    80001f78:	2fc50513          	addi	a0,a0,764 # 80008270 <digits+0x208>
    80001f7c:	ffffe097          	auipc	ra,0xffffe
    80001f80:	668080e7          	jalr	1640(ra) # 800005e4 <panic>
  if (p->chan == p && p->state == SLEEPING) {
    80001f84:	4c98                	lw	a4,24(s1)
    80001f86:	4785                	li	a5,1
    80001f88:	fef711e3          	bne	a4,a5,80001f6a <wakeup1+0x1c>
    p->state = RUNNABLE;
    80001f8c:	4789                	li	a5,2
    80001f8e:	cc9c                	sw	a5,24(s1)
}
    80001f90:	bfe9                	j	80001f6a <wakeup1+0x1c>

0000000080001f92 <procinit>:
void procinit(void) {
    80001f92:	715d                	addi	sp,sp,-80
    80001f94:	e486                	sd	ra,72(sp)
    80001f96:	e0a2                	sd	s0,64(sp)
    80001f98:	fc26                	sd	s1,56(sp)
    80001f9a:	f84a                	sd	s2,48(sp)
    80001f9c:	f44e                	sd	s3,40(sp)
    80001f9e:	f052                	sd	s4,32(sp)
    80001fa0:	ec56                	sd	s5,24(sp)
    80001fa2:	e85a                	sd	s6,16(sp)
    80001fa4:	e45e                	sd	s7,8(sp)
    80001fa6:	0880                	addi	s0,sp,80
  initlock(&pid_lock, "nextpid");
    80001fa8:	00006597          	auipc	a1,0x6
    80001fac:	2d058593          	addi	a1,a1,720 # 80008278 <digits+0x210>
    80001fb0:	00030517          	auipc	a0,0x30
    80001fb4:	9b050513          	addi	a0,a0,-1616 # 80031960 <pid_lock>
    80001fb8:	fffff097          	auipc	ra,0xfffff
    80001fbc:	cf2080e7          	jalr	-782(ra) # 80000caa <initlock>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001fc0:	00030917          	auipc	s2,0x30
    80001fc4:	db890913          	addi	s2,s2,-584 # 80031d78 <proc>
    initlock(&p->lock, "proc");
    80001fc8:	00006b97          	auipc	s7,0x6
    80001fcc:	2b8b8b93          	addi	s7,s7,696 # 80008280 <digits+0x218>
    uint64 va = KSTACK((int)(p - proc));
    80001fd0:	8b4a                	mv	s6,s2
    80001fd2:	00006a97          	auipc	s5,0x6
    80001fd6:	02ea8a93          	addi	s5,s5,46 # 80008000 <etext>
    80001fda:	040009b7          	lui	s3,0x4000
    80001fde:	19fd                	addi	s3,s3,-1
    80001fe0:	09b2                	slli	s3,s3,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    80001fe2:	00041a17          	auipc	s4,0x41
    80001fe6:	796a0a13          	addi	s4,s4,1942 # 80043778 <tickslock>
    initlock(&p->lock, "proc");
    80001fea:	85de                	mv	a1,s7
    80001fec:	854a                	mv	a0,s2
    80001fee:	fffff097          	auipc	ra,0xfffff
    80001ff2:	cbc080e7          	jalr	-836(ra) # 80000caa <initlock>
    char *pa = kalloc();
    80001ff6:	fffff097          	auipc	ra,0xfffff
    80001ffa:	c06080e7          	jalr	-1018(ra) # 80000bfc <kalloc>
    80001ffe:	85aa                	mv	a1,a0
    if (pa == 0)
    80002000:	c929                	beqz	a0,80002052 <procinit+0xc0>
    uint64 va = KSTACK((int)(p - proc));
    80002002:	416904b3          	sub	s1,s2,s6
    80002006:	848d                	srai	s1,s1,0x3
    80002008:	000ab783          	ld	a5,0(s5)
    8000200c:	02f484b3          	mul	s1,s1,a5
    80002010:	2485                	addiw	s1,s1,1
    80002012:	00d4949b          	slliw	s1,s1,0xd
    80002016:	409984b3          	sub	s1,s3,s1
    kvmmap(va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000201a:	4699                	li	a3,6
    8000201c:	6605                	lui	a2,0x1
    8000201e:	8526                	mv	a0,s1
    80002020:	fffff097          	auipc	ra,0xfffff
    80002024:	2c8080e7          	jalr	712(ra) # 800012e8 <kvmmap>
    p->kstack = va;
    80002028:	04993023          	sd	s1,64(s2)
  for (p = proc; p < &proc[NPROC]; p++) {
    8000202c:	46890913          	addi	s2,s2,1128
    80002030:	fb491de3          	bne	s2,s4,80001fea <procinit+0x58>
  kvminithart();
    80002034:	fffff097          	auipc	ra,0xfffff
    80002038:	0c6080e7          	jalr	198(ra) # 800010fa <kvminithart>
}
    8000203c:	60a6                	ld	ra,72(sp)
    8000203e:	6406                	ld	s0,64(sp)
    80002040:	74e2                	ld	s1,56(sp)
    80002042:	7942                	ld	s2,48(sp)
    80002044:	79a2                	ld	s3,40(sp)
    80002046:	7a02                	ld	s4,32(sp)
    80002048:	6ae2                	ld	s5,24(sp)
    8000204a:	6b42                	ld	s6,16(sp)
    8000204c:	6ba2                	ld	s7,8(sp)
    8000204e:	6161                	addi	sp,sp,80
    80002050:	8082                	ret
      panic("kalloc");
    80002052:	00006517          	auipc	a0,0x6
    80002056:	23650513          	addi	a0,a0,566 # 80008288 <digits+0x220>
    8000205a:	ffffe097          	auipc	ra,0xffffe
    8000205e:	58a080e7          	jalr	1418(ra) # 800005e4 <panic>

0000000080002062 <cpuid>:
int cpuid() {
    80002062:	1141                	addi	sp,sp,-16
    80002064:	e422                	sd	s0,8(sp)
    80002066:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r"(x));
    80002068:	8512                	mv	a0,tp
}
    8000206a:	2501                	sext.w	a0,a0
    8000206c:	6422                	ld	s0,8(sp)
    8000206e:	0141                	addi	sp,sp,16
    80002070:	8082                	ret

0000000080002072 <mycpu>:
struct cpu *mycpu(void) {
    80002072:	1141                	addi	sp,sp,-16
    80002074:	e422                	sd	s0,8(sp)
    80002076:	0800                	addi	s0,sp,16
    80002078:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    8000207a:	2781                	sext.w	a5,a5
    8000207c:	079e                	slli	a5,a5,0x7
}
    8000207e:	00030517          	auipc	a0,0x30
    80002082:	8fa50513          	addi	a0,a0,-1798 # 80031978 <cpus>
    80002086:	953e                	add	a0,a0,a5
    80002088:	6422                	ld	s0,8(sp)
    8000208a:	0141                	addi	sp,sp,16
    8000208c:	8082                	ret

000000008000208e <myproc>:
struct proc *myproc(void) {
    8000208e:	1101                	addi	sp,sp,-32
    80002090:	ec06                	sd	ra,24(sp)
    80002092:	e822                	sd	s0,16(sp)
    80002094:	e426                	sd	s1,8(sp)
    80002096:	1000                	addi	s0,sp,32
  push_off();
    80002098:	fffff097          	auipc	ra,0xfffff
    8000209c:	c56080e7          	jalr	-938(ra) # 80000cee <push_off>
    800020a0:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    800020a2:	2781                	sext.w	a5,a5
    800020a4:	079e                	slli	a5,a5,0x7
    800020a6:	00030717          	auipc	a4,0x30
    800020aa:	8ba70713          	addi	a4,a4,-1862 # 80031960 <pid_lock>
    800020ae:	97ba                	add	a5,a5,a4
    800020b0:	6f84                	ld	s1,24(a5)
  pop_off();
    800020b2:	fffff097          	auipc	ra,0xfffff
    800020b6:	cdc080e7          	jalr	-804(ra) # 80000d8e <pop_off>
}
    800020ba:	8526                	mv	a0,s1
    800020bc:	60e2                	ld	ra,24(sp)
    800020be:	6442                	ld	s0,16(sp)
    800020c0:	64a2                	ld	s1,8(sp)
    800020c2:	6105                	addi	sp,sp,32
    800020c4:	8082                	ret

00000000800020c6 <forkret>:
void forkret(void) {
    800020c6:	1141                	addi	sp,sp,-16
    800020c8:	e406                	sd	ra,8(sp)
    800020ca:	e022                	sd	s0,0(sp)
    800020cc:	0800                	addi	s0,sp,16
  release(&myproc()->lock);
    800020ce:	00000097          	auipc	ra,0x0
    800020d2:	fc0080e7          	jalr	-64(ra) # 8000208e <myproc>
    800020d6:	fffff097          	auipc	ra,0xfffff
    800020da:	d18080e7          	jalr	-744(ra) # 80000dee <release>
  if (first) {
    800020de:	00007797          	auipc	a5,0x7
    800020e2:	8b27a783          	lw	a5,-1870(a5) # 80008990 <first.1>
    800020e6:	eb89                	bnez	a5,800020f8 <forkret+0x32>
  usertrapret();
    800020e8:	00001097          	auipc	ra,0x1
    800020ec:	c18080e7          	jalr	-1000(ra) # 80002d00 <usertrapret>
}
    800020f0:	60a2                	ld	ra,8(sp)
    800020f2:	6402                	ld	s0,0(sp)
    800020f4:	0141                	addi	sp,sp,16
    800020f6:	8082                	ret
    first = 0;
    800020f8:	00007797          	auipc	a5,0x7
    800020fc:	8807ac23          	sw	zero,-1896(a5) # 80008990 <first.1>
    fsinit(ROOTDEV);
    80002100:	4505                	li	a0,1
    80002102:	00002097          	auipc	ra,0x2
    80002106:	ac6080e7          	jalr	-1338(ra) # 80003bc8 <fsinit>
    8000210a:	bff9                	j	800020e8 <forkret+0x22>

000000008000210c <allocpid>:
int allocpid() {
    8000210c:	1101                	addi	sp,sp,-32
    8000210e:	ec06                	sd	ra,24(sp)
    80002110:	e822                	sd	s0,16(sp)
    80002112:	e426                	sd	s1,8(sp)
    80002114:	e04a                	sd	s2,0(sp)
    80002116:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80002118:	00030917          	auipc	s2,0x30
    8000211c:	84890913          	addi	s2,s2,-1976 # 80031960 <pid_lock>
    80002120:	854a                	mv	a0,s2
    80002122:	fffff097          	auipc	ra,0xfffff
    80002126:	c18080e7          	jalr	-1000(ra) # 80000d3a <acquire>
  pid = nextpid;
    8000212a:	00007797          	auipc	a5,0x7
    8000212e:	86a78793          	addi	a5,a5,-1942 # 80008994 <nextpid>
    80002132:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80002134:	0014871b          	addiw	a4,s1,1
    80002138:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    8000213a:	854a                	mv	a0,s2
    8000213c:	fffff097          	auipc	ra,0xfffff
    80002140:	cb2080e7          	jalr	-846(ra) # 80000dee <release>
}
    80002144:	8526                	mv	a0,s1
    80002146:	60e2                	ld	ra,24(sp)
    80002148:	6442                	ld	s0,16(sp)
    8000214a:	64a2                	ld	s1,8(sp)
    8000214c:	6902                	ld	s2,0(sp)
    8000214e:	6105                	addi	sp,sp,32
    80002150:	8082                	ret

0000000080002152 <proc_pagetable>:
pagetable_t proc_pagetable(struct proc *p) {
    80002152:	1101                	addi	sp,sp,-32
    80002154:	ec06                	sd	ra,24(sp)
    80002156:	e822                	sd	s0,16(sp)
    80002158:	e426                	sd	s1,8(sp)
    8000215a:	e04a                	sd	s2,0(sp)
    8000215c:	1000                	addi	s0,sp,32
    8000215e:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80002160:	fffff097          	auipc	ra,0xfffff
    80002164:	338080e7          	jalr	824(ra) # 80001498 <uvmcreate>
    80002168:	84aa                	mv	s1,a0
  if (pagetable == 0)
    8000216a:	c121                	beqz	a0,800021aa <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
    8000216c:	4729                	li	a4,10
    8000216e:	00005697          	auipc	a3,0x5
    80002172:	e9268693          	addi	a3,a3,-366 # 80007000 <_trampoline>
    80002176:	6605                	lui	a2,0x1
    80002178:	040005b7          	lui	a1,0x4000
    8000217c:	15fd                	addi	a1,a1,-1
    8000217e:	05b2                	slli	a1,a1,0xc
    80002180:	fffff097          	auipc	ra,0xfffff
    80002184:	0da080e7          	jalr	218(ra) # 8000125a <mappages>
    80002188:	02054863          	bltz	a0,800021b8 <proc_pagetable+0x66>
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe),
    8000218c:	4719                	li	a4,6
    8000218e:	05893683          	ld	a3,88(s2)
    80002192:	6605                	lui	a2,0x1
    80002194:	020005b7          	lui	a1,0x2000
    80002198:	15fd                	addi	a1,a1,-1
    8000219a:	05b6                	slli	a1,a1,0xd
    8000219c:	8526                	mv	a0,s1
    8000219e:	fffff097          	auipc	ra,0xfffff
    800021a2:	0bc080e7          	jalr	188(ra) # 8000125a <mappages>
    800021a6:	02054163          	bltz	a0,800021c8 <proc_pagetable+0x76>
}
    800021aa:	8526                	mv	a0,s1
    800021ac:	60e2                	ld	ra,24(sp)
    800021ae:	6442                	ld	s0,16(sp)
    800021b0:	64a2                	ld	s1,8(sp)
    800021b2:	6902                	ld	s2,0(sp)
    800021b4:	6105                	addi	sp,sp,32
    800021b6:	8082                	ret
    uvmfree(pagetable, 0);
    800021b8:	4581                	li	a1,0
    800021ba:	8526                	mv	a0,s1
    800021bc:	fffff097          	auipc	ra,0xfffff
    800021c0:	4d8080e7          	jalr	1240(ra) # 80001694 <uvmfree>
    return 0;
    800021c4:	4481                	li	s1,0
    800021c6:	b7d5                	j	800021aa <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800021c8:	4681                	li	a3,0
    800021ca:	4605                	li	a2,1
    800021cc:	040005b7          	lui	a1,0x4000
    800021d0:	15fd                	addi	a1,a1,-1
    800021d2:	05b2                	slli	a1,a1,0xc
    800021d4:	8526                	mv	a0,s1
    800021d6:	fffff097          	auipc	ra,0xfffff
    800021da:	21c080e7          	jalr	540(ra) # 800013f2 <uvmunmap>
    uvmfree(pagetable, 0);
    800021de:	4581                	li	a1,0
    800021e0:	8526                	mv	a0,s1
    800021e2:	fffff097          	auipc	ra,0xfffff
    800021e6:	4b2080e7          	jalr	1202(ra) # 80001694 <uvmfree>
    return 0;
    800021ea:	4481                	li	s1,0
    800021ec:	bf7d                	j	800021aa <proc_pagetable+0x58>

00000000800021ee <proc_freepagetable>:
void proc_freepagetable(pagetable_t pagetable, uint64 sz) {
    800021ee:	1101                	addi	sp,sp,-32
    800021f0:	ec06                	sd	ra,24(sp)
    800021f2:	e822                	sd	s0,16(sp)
    800021f4:	e426                	sd	s1,8(sp)
    800021f6:	e04a                	sd	s2,0(sp)
    800021f8:	1000                	addi	s0,sp,32
    800021fa:	84aa                	mv	s1,a0
    800021fc:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800021fe:	4681                	li	a3,0
    80002200:	4605                	li	a2,1
    80002202:	040005b7          	lui	a1,0x4000
    80002206:	15fd                	addi	a1,a1,-1
    80002208:	05b2                	slli	a1,a1,0xc
    8000220a:	fffff097          	auipc	ra,0xfffff
    8000220e:	1e8080e7          	jalr	488(ra) # 800013f2 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80002212:	4681                	li	a3,0
    80002214:	4605                	li	a2,1
    80002216:	020005b7          	lui	a1,0x2000
    8000221a:	15fd                	addi	a1,a1,-1
    8000221c:	05b6                	slli	a1,a1,0xd
    8000221e:	8526                	mv	a0,s1
    80002220:	fffff097          	auipc	ra,0xfffff
    80002224:	1d2080e7          	jalr	466(ra) # 800013f2 <uvmunmap>
  uvmfree(pagetable, sz);
    80002228:	85ca                	mv	a1,s2
    8000222a:	8526                	mv	a0,s1
    8000222c:	fffff097          	auipc	ra,0xfffff
    80002230:	468080e7          	jalr	1128(ra) # 80001694 <uvmfree>
}
    80002234:	60e2                	ld	ra,24(sp)
    80002236:	6442                	ld	s0,16(sp)
    80002238:	64a2                	ld	s1,8(sp)
    8000223a:	6902                	ld	s2,0(sp)
    8000223c:	6105                	addi	sp,sp,32
    8000223e:	8082                	ret

0000000080002240 <freeproc>:
static void freeproc(struct proc *p) {
    80002240:	1101                	addi	sp,sp,-32
    80002242:	ec06                	sd	ra,24(sp)
    80002244:	e822                	sd	s0,16(sp)
    80002246:	e426                	sd	s1,8(sp)
    80002248:	1000                	addi	s0,sp,32
    8000224a:	84aa                	mv	s1,a0
  if (p->trapframe)
    8000224c:	6d28                	ld	a0,88(a0)
    8000224e:	c509                	beqz	a0,80002258 <freeproc+0x18>
    kfree((void *)p->trapframe);
    80002250:	fffff097          	auipc	ra,0xfffff
    80002254:	83a080e7          	jalr	-1990(ra) # 80000a8a <kfree>
  p->trapframe = 0;
    80002258:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable)
    8000225c:	68a8                	ld	a0,80(s1)
    8000225e:	c511                	beqz	a0,8000226a <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80002260:	64ac                	ld	a1,72(s1)
    80002262:	00000097          	auipc	ra,0x0
    80002266:	f8c080e7          	jalr	-116(ra) # 800021ee <proc_freepagetable>
  p->pagetable = 0;
    8000226a:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000226e:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80002272:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80002276:	0204b023          	sd	zero,32(s1)
  p->name[0] = 0;
    8000227a:	14048823          	sb	zero,336(s1)
  p->chan = 0;
    8000227e:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80002282:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80002286:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    8000228a:	0004ac23          	sw	zero,24(s1)
}
    8000228e:	60e2                	ld	ra,24(sp)
    80002290:	6442                	ld	s0,16(sp)
    80002292:	64a2                	ld	s1,8(sp)
    80002294:	6105                	addi	sp,sp,32
    80002296:	8082                	ret

0000000080002298 <allocproc>:
static struct proc *allocproc(void) {
    80002298:	1101                	addi	sp,sp,-32
    8000229a:	ec06                	sd	ra,24(sp)
    8000229c:	e822                	sd	s0,16(sp)
    8000229e:	e426                	sd	s1,8(sp)
    800022a0:	e04a                	sd	s2,0(sp)
    800022a2:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++) {
    800022a4:	00030497          	auipc	s1,0x30
    800022a8:	ad448493          	addi	s1,s1,-1324 # 80031d78 <proc>
    800022ac:	00041917          	auipc	s2,0x41
    800022b0:	4cc90913          	addi	s2,s2,1228 # 80043778 <tickslock>
    acquire(&p->lock);
    800022b4:	8526                	mv	a0,s1
    800022b6:	fffff097          	auipc	ra,0xfffff
    800022ba:	a84080e7          	jalr	-1404(ra) # 80000d3a <acquire>
    if (p->state == UNUSED) {
    800022be:	4c9c                	lw	a5,24(s1)
    800022c0:	cf81                	beqz	a5,800022d8 <allocproc+0x40>
      release(&p->lock);
    800022c2:	8526                	mv	a0,s1
    800022c4:	fffff097          	auipc	ra,0xfffff
    800022c8:	b2a080e7          	jalr	-1238(ra) # 80000dee <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    800022cc:	46848493          	addi	s1,s1,1128
    800022d0:	ff2492e3          	bne	s1,s2,800022b4 <allocproc+0x1c>
  return 0;
    800022d4:	4481                	li	s1,0
    800022d6:	a0b9                	j	80002324 <allocproc+0x8c>
  p->pid = allocpid();
    800022d8:	00000097          	auipc	ra,0x0
    800022dc:	e34080e7          	jalr	-460(ra) # 8000210c <allocpid>
    800022e0:	dc88                	sw	a0,56(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    800022e2:	fffff097          	auipc	ra,0xfffff
    800022e6:	91a080e7          	jalr	-1766(ra) # 80000bfc <kalloc>
    800022ea:	892a                	mv	s2,a0
    800022ec:	eca8                	sd	a0,88(s1)
    800022ee:	c131                	beqz	a0,80002332 <allocproc+0x9a>
  p->pagetable = proc_pagetable(p);
    800022f0:	8526                	mv	a0,s1
    800022f2:	00000097          	auipc	ra,0x0
    800022f6:	e60080e7          	jalr	-416(ra) # 80002152 <proc_pagetable>
    800022fa:	892a                	mv	s2,a0
    800022fc:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0) {
    800022fe:	c129                	beqz	a0,80002340 <allocproc+0xa8>
  memset(&p->context, 0, sizeof(p->context));
    80002300:	07000613          	li	a2,112
    80002304:	4581                	li	a1,0
    80002306:	06048513          	addi	a0,s1,96
    8000230a:	fffff097          	auipc	ra,0xfffff
    8000230e:	b2c080e7          	jalr	-1236(ra) # 80000e36 <memset>
  p->context.ra = (uint64)forkret;
    80002312:	00000797          	auipc	a5,0x0
    80002316:	db478793          	addi	a5,a5,-588 # 800020c6 <forkret>
    8000231a:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000231c:	60bc                	ld	a5,64(s1)
    8000231e:	6705                	lui	a4,0x1
    80002320:	97ba                	add	a5,a5,a4
    80002322:	f4bc                	sd	a5,104(s1)
}
    80002324:	8526                	mv	a0,s1
    80002326:	60e2                	ld	ra,24(sp)
    80002328:	6442                	ld	s0,16(sp)
    8000232a:	64a2                	ld	s1,8(sp)
    8000232c:	6902                	ld	s2,0(sp)
    8000232e:	6105                	addi	sp,sp,32
    80002330:	8082                	ret
    release(&p->lock);
    80002332:	8526                	mv	a0,s1
    80002334:	fffff097          	auipc	ra,0xfffff
    80002338:	aba080e7          	jalr	-1350(ra) # 80000dee <release>
    return 0;
    8000233c:	84ca                	mv	s1,s2
    8000233e:	b7dd                	j	80002324 <allocproc+0x8c>
    freeproc(p);
    80002340:	8526                	mv	a0,s1
    80002342:	00000097          	auipc	ra,0x0
    80002346:	efe080e7          	jalr	-258(ra) # 80002240 <freeproc>
    release(&p->lock);
    8000234a:	8526                	mv	a0,s1
    8000234c:	fffff097          	auipc	ra,0xfffff
    80002350:	aa2080e7          	jalr	-1374(ra) # 80000dee <release>
    return 0;
    80002354:	84ca                	mv	s1,s2
    80002356:	b7f9                	j	80002324 <allocproc+0x8c>

0000000080002358 <userinit>:
void userinit(void) {
    80002358:	1101                	addi	sp,sp,-32
    8000235a:	ec06                	sd	ra,24(sp)
    8000235c:	e822                	sd	s0,16(sp)
    8000235e:	e426                	sd	s1,8(sp)
    80002360:	1000                	addi	s0,sp,32
  p = allocproc();
    80002362:	00000097          	auipc	ra,0x0
    80002366:	f36080e7          	jalr	-202(ra) # 80002298 <allocproc>
    8000236a:	84aa                	mv	s1,a0
  initproc = p;
    8000236c:	00007797          	auipc	a5,0x7
    80002370:	caa7b623          	sd	a0,-852(a5) # 80009018 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80002374:	03400613          	li	a2,52
    80002378:	00006597          	auipc	a1,0x6
    8000237c:	62858593          	addi	a1,a1,1576 # 800089a0 <initcode>
    80002380:	6928                	ld	a0,80(a0)
    80002382:	fffff097          	auipc	ra,0xfffff
    80002386:	144080e7          	jalr	324(ra) # 800014c6 <uvminit>
  p->sz = PGSIZE;
    8000238a:	6785                	lui	a5,0x1
    8000238c:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;     // user program counter
    8000238e:	6cb8                	ld	a4,88(s1)
    80002390:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE; // user stack pointer
    80002394:	6cb8                	ld	a4,88(s1)
    80002396:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80002398:	4641                	li	a2,16
    8000239a:	00006597          	auipc	a1,0x6
    8000239e:	ef658593          	addi	a1,a1,-266 # 80008290 <digits+0x228>
    800023a2:	15048513          	addi	a0,s1,336
    800023a6:	fffff097          	auipc	ra,0xfffff
    800023aa:	be2080e7          	jalr	-1054(ra) # 80000f88 <safestrcpy>
  p->cwd = namei("/");
    800023ae:	00006517          	auipc	a0,0x6
    800023b2:	ef250513          	addi	a0,a0,-270 # 800082a0 <digits+0x238>
    800023b6:	00002097          	auipc	ra,0x2
    800023ba:	23e080e7          	jalr	574(ra) # 800045f4 <namei>
    800023be:	16a4b023          	sd	a0,352(s1)
  p->state = RUNNABLE;
    800023c2:	4789                	li	a5,2
    800023c4:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800023c6:	8526                	mv	a0,s1
    800023c8:	fffff097          	auipc	ra,0xfffff
    800023cc:	a26080e7          	jalr	-1498(ra) # 80000dee <release>
}
    800023d0:	60e2                	ld	ra,24(sp)
    800023d2:	6442                	ld	s0,16(sp)
    800023d4:	64a2                	ld	s1,8(sp)
    800023d6:	6105                	addi	sp,sp,32
    800023d8:	8082                	ret

00000000800023da <growproc>:
int growproc(int n) {
    800023da:	1101                	addi	sp,sp,-32
    800023dc:	ec06                	sd	ra,24(sp)
    800023de:	e822                	sd	s0,16(sp)
    800023e0:	e426                	sd	s1,8(sp)
    800023e2:	e04a                	sd	s2,0(sp)
    800023e4:	1000                	addi	s0,sp,32
    800023e6:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800023e8:	00000097          	auipc	ra,0x0
    800023ec:	ca6080e7          	jalr	-858(ra) # 8000208e <myproc>
    800023f0:	892a                	mv	s2,a0
  sz = p->sz;
    800023f2:	652c                	ld	a1,72(a0)
    800023f4:	0005861b          	sext.w	a2,a1
  if (n > 0) {
    800023f8:	00904f63          	bgtz	s1,80002416 <growproc+0x3c>
  } else if (n < 0) {
    800023fc:	0204cc63          	bltz	s1,80002434 <growproc+0x5a>
  p->sz = sz;
    80002400:	1602                	slli	a2,a2,0x20
    80002402:	9201                	srli	a2,a2,0x20
    80002404:	04c93423          	sd	a2,72(s2)
  return 0;
    80002408:	4501                	li	a0,0
}
    8000240a:	60e2                	ld	ra,24(sp)
    8000240c:	6442                	ld	s0,16(sp)
    8000240e:	64a2                	ld	s1,8(sp)
    80002410:	6902                	ld	s2,0(sp)
    80002412:	6105                	addi	sp,sp,32
    80002414:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80002416:	9e25                	addw	a2,a2,s1
    80002418:	1602                	slli	a2,a2,0x20
    8000241a:	9201                	srli	a2,a2,0x20
    8000241c:	1582                	slli	a1,a1,0x20
    8000241e:	9181                	srli	a1,a1,0x20
    80002420:	6928                	ld	a0,80(a0)
    80002422:	fffff097          	auipc	ra,0xfffff
    80002426:	15e080e7          	jalr	350(ra) # 80001580 <uvmalloc>
    8000242a:	0005061b          	sext.w	a2,a0
    8000242e:	fa69                	bnez	a2,80002400 <growproc+0x26>
      return -1;
    80002430:	557d                	li	a0,-1
    80002432:	bfe1                	j	8000240a <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80002434:	9e25                	addw	a2,a2,s1
    80002436:	1602                	slli	a2,a2,0x20
    80002438:	9201                	srli	a2,a2,0x20
    8000243a:	1582                	slli	a1,a1,0x20
    8000243c:	9181                	srli	a1,a1,0x20
    8000243e:	6928                	ld	a0,80(a0)
    80002440:	fffff097          	auipc	ra,0xfffff
    80002444:	0f8080e7          	jalr	248(ra) # 80001538 <uvmdealloc>
    80002448:	0005061b          	sext.w	a2,a0
    8000244c:	bf55                	j	80002400 <growproc+0x26>

000000008000244e <fork>:
int fork(void) {
    8000244e:	7139                	addi	sp,sp,-64
    80002450:	fc06                	sd	ra,56(sp)
    80002452:	f822                	sd	s0,48(sp)
    80002454:	f426                	sd	s1,40(sp)
    80002456:	f04a                	sd	s2,32(sp)
    80002458:	ec4e                	sd	s3,24(sp)
    8000245a:	e852                	sd	s4,16(sp)
    8000245c:	e456                	sd	s5,8(sp)
    8000245e:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80002460:	00000097          	auipc	ra,0x0
    80002464:	c2e080e7          	jalr	-978(ra) # 8000208e <myproc>
    80002468:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0) {
    8000246a:	00000097          	auipc	ra,0x0
    8000246e:	e2e080e7          	jalr	-466(ra) # 80002298 <allocproc>
    80002472:	c17d                	beqz	a0,80002558 <fork+0x10a>
    80002474:	8a2a                	mv	s4,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    80002476:	048ab603          	ld	a2,72(s5)
    8000247a:	692c                	ld	a1,80(a0)
    8000247c:	050ab503          	ld	a0,80(s5)
    80002480:	fffff097          	auipc	ra,0xfffff
    80002484:	24c080e7          	jalr	588(ra) # 800016cc <uvmcopy>
    80002488:	04054a63          	bltz	a0,800024dc <fork+0x8e>
  np->sz = p->sz;
    8000248c:	048ab783          	ld	a5,72(s5)
    80002490:	04fa3423          	sd	a5,72(s4)
  np->parent = p;
    80002494:	035a3023          	sd	s5,32(s4)
  *(np->trapframe) = *(p->trapframe);
    80002498:	058ab683          	ld	a3,88(s5)
    8000249c:	87b6                	mv	a5,a3
    8000249e:	058a3703          	ld	a4,88(s4)
    800024a2:	12068693          	addi	a3,a3,288
    800024a6:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800024aa:	6788                	ld	a0,8(a5)
    800024ac:	6b8c                	ld	a1,16(a5)
    800024ae:	6f90                	ld	a2,24(a5)
    800024b0:	01073023          	sd	a6,0(a4)
    800024b4:	e708                	sd	a0,8(a4)
    800024b6:	eb0c                	sd	a1,16(a4)
    800024b8:	ef10                	sd	a2,24(a4)
    800024ba:	02078793          	addi	a5,a5,32
    800024be:	02070713          	addi	a4,a4,32
    800024c2:	fed792e3          	bne	a5,a3,800024a6 <fork+0x58>
  np->trapframe->a0 = 0;
    800024c6:	058a3783          	ld	a5,88(s4)
    800024ca:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    800024ce:	0d0a8493          	addi	s1,s5,208
    800024d2:	0d0a0913          	addi	s2,s4,208
    800024d6:	150a8993          	addi	s3,s5,336
    800024da:	a00d                	j	800024fc <fork+0xae>
    freeproc(np);
    800024dc:	8552                	mv	a0,s4
    800024de:	00000097          	auipc	ra,0x0
    800024e2:	d62080e7          	jalr	-670(ra) # 80002240 <freeproc>
    release(&np->lock);
    800024e6:	8552                	mv	a0,s4
    800024e8:	fffff097          	auipc	ra,0xfffff
    800024ec:	906080e7          	jalr	-1786(ra) # 80000dee <release>
    return -1;
    800024f0:	54fd                	li	s1,-1
    800024f2:	a889                	j	80002544 <fork+0xf6>
  for (i = 0; i < NOFILE; i++)
    800024f4:	04a1                	addi	s1,s1,8
    800024f6:	0921                	addi	s2,s2,8
    800024f8:	01348b63          	beq	s1,s3,8000250e <fork+0xc0>
    if (p->ofile[i])
    800024fc:	6088                	ld	a0,0(s1)
    800024fe:	d97d                	beqz	a0,800024f4 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80002500:	00002097          	auipc	ra,0x2
    80002504:	780080e7          	jalr	1920(ra) # 80004c80 <filedup>
    80002508:	00a93023          	sd	a0,0(s2)
    8000250c:	b7e5                	j	800024f4 <fork+0xa6>
  np->cwd = idup(p->cwd);
    8000250e:	160ab503          	ld	a0,352(s5)
    80002512:	00002097          	auipc	ra,0x2
    80002516:	8f0080e7          	jalr	-1808(ra) # 80003e02 <idup>
    8000251a:	16aa3023          	sd	a0,352(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000251e:	4641                	li	a2,16
    80002520:	150a8593          	addi	a1,s5,336
    80002524:	150a0513          	addi	a0,s4,336
    80002528:	fffff097          	auipc	ra,0xfffff
    8000252c:	a60080e7          	jalr	-1440(ra) # 80000f88 <safestrcpy>
  pid = np->pid;
    80002530:	038a2483          	lw	s1,56(s4)
  np->state = RUNNABLE;
    80002534:	4789                	li	a5,2
    80002536:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000253a:	8552                	mv	a0,s4
    8000253c:	fffff097          	auipc	ra,0xfffff
    80002540:	8b2080e7          	jalr	-1870(ra) # 80000dee <release>
}
    80002544:	8526                	mv	a0,s1
    80002546:	70e2                	ld	ra,56(sp)
    80002548:	7442                	ld	s0,48(sp)
    8000254a:	74a2                	ld	s1,40(sp)
    8000254c:	7902                	ld	s2,32(sp)
    8000254e:	69e2                	ld	s3,24(sp)
    80002550:	6a42                	ld	s4,16(sp)
    80002552:	6aa2                	ld	s5,8(sp)
    80002554:	6121                	addi	sp,sp,64
    80002556:	8082                	ret
    return -1;
    80002558:	54fd                	li	s1,-1
    8000255a:	b7ed                	j	80002544 <fork+0xf6>

000000008000255c <reparent>:
void reparent(struct proc *p) {
    8000255c:	7179                	addi	sp,sp,-48
    8000255e:	f406                	sd	ra,40(sp)
    80002560:	f022                	sd	s0,32(sp)
    80002562:	ec26                	sd	s1,24(sp)
    80002564:	e84a                	sd	s2,16(sp)
    80002566:	e44e                	sd	s3,8(sp)
    80002568:	e052                	sd	s4,0(sp)
    8000256a:	1800                	addi	s0,sp,48
    8000256c:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000256e:	00030497          	auipc	s1,0x30
    80002572:	80a48493          	addi	s1,s1,-2038 # 80031d78 <proc>
      pp->parent = initproc;
    80002576:	00007a17          	auipc	s4,0x7
    8000257a:	aa2a0a13          	addi	s4,s4,-1374 # 80009018 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000257e:	00041997          	auipc	s3,0x41
    80002582:	1fa98993          	addi	s3,s3,506 # 80043778 <tickslock>
    80002586:	a029                	j	80002590 <reparent+0x34>
    80002588:	46848493          	addi	s1,s1,1128
    8000258c:	03348363          	beq	s1,s3,800025b2 <reparent+0x56>
    if (pp->parent == p) {
    80002590:	709c                	ld	a5,32(s1)
    80002592:	ff279be3          	bne	a5,s2,80002588 <reparent+0x2c>
      acquire(&pp->lock);
    80002596:	8526                	mv	a0,s1
    80002598:	ffffe097          	auipc	ra,0xffffe
    8000259c:	7a2080e7          	jalr	1954(ra) # 80000d3a <acquire>
      pp->parent = initproc;
    800025a0:	000a3783          	ld	a5,0(s4)
    800025a4:	f09c                	sd	a5,32(s1)
      release(&pp->lock);
    800025a6:	8526                	mv	a0,s1
    800025a8:	fffff097          	auipc	ra,0xfffff
    800025ac:	846080e7          	jalr	-1978(ra) # 80000dee <release>
    800025b0:	bfe1                	j	80002588 <reparent+0x2c>
}
    800025b2:	70a2                	ld	ra,40(sp)
    800025b4:	7402                	ld	s0,32(sp)
    800025b6:	64e2                	ld	s1,24(sp)
    800025b8:	6942                	ld	s2,16(sp)
    800025ba:	69a2                	ld	s3,8(sp)
    800025bc:	6a02                	ld	s4,0(sp)
    800025be:	6145                	addi	sp,sp,48
    800025c0:	8082                	ret

00000000800025c2 <scheduler>:
void scheduler(void) {
    800025c2:	711d                	addi	sp,sp,-96
    800025c4:	ec86                	sd	ra,88(sp)
    800025c6:	e8a2                	sd	s0,80(sp)
    800025c8:	e4a6                	sd	s1,72(sp)
    800025ca:	e0ca                	sd	s2,64(sp)
    800025cc:	fc4e                	sd	s3,56(sp)
    800025ce:	f852                	sd	s4,48(sp)
    800025d0:	f456                	sd	s5,40(sp)
    800025d2:	f05a                	sd	s6,32(sp)
    800025d4:	ec5e                	sd	s7,24(sp)
    800025d6:	e862                	sd	s8,16(sp)
    800025d8:	e466                	sd	s9,8(sp)
    800025da:	1080                	addi	s0,sp,96
    800025dc:	8792                	mv	a5,tp
  int id = r_tp();
    800025de:	2781                	sext.w	a5,a5
  c->proc = 0;
    800025e0:	00779c13          	slli	s8,a5,0x7
    800025e4:	0002f717          	auipc	a4,0x2f
    800025e8:	37c70713          	addi	a4,a4,892 # 80031960 <pid_lock>
    800025ec:	9762                	add	a4,a4,s8
    800025ee:	00073c23          	sd	zero,24(a4)
        swtch(&c->context, &p->context);
    800025f2:	0002f717          	auipc	a4,0x2f
    800025f6:	38e70713          	addi	a4,a4,910 # 80031980 <cpus+0x8>
    800025fa:	9c3a                	add	s8,s8,a4
    int nproc = 0;
    800025fc:	4c81                	li	s9,0
      if (p->state == RUNNABLE) {
    800025fe:	4a89                	li	s5,2
        c->proc = p;
    80002600:	079e                	slli	a5,a5,0x7
    80002602:	0002fb17          	auipc	s6,0x2f
    80002606:	35eb0b13          	addi	s6,s6,862 # 80031960 <pid_lock>
    8000260a:	9b3e                	add	s6,s6,a5
    for (p = proc; p < &proc[NPROC]; p++) {
    8000260c:	00041a17          	auipc	s4,0x41
    80002610:	16ca0a13          	addi	s4,s4,364 # 80043778 <tickslock>
    80002614:	a8a1                	j	8000266c <scheduler+0xaa>
      release(&p->lock);
    80002616:	8526                	mv	a0,s1
    80002618:	ffffe097          	auipc	ra,0xffffe
    8000261c:	7d6080e7          	jalr	2006(ra) # 80000dee <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    80002620:	46848493          	addi	s1,s1,1128
    80002624:	03448a63          	beq	s1,s4,80002658 <scheduler+0x96>
      acquire(&p->lock);
    80002628:	8526                	mv	a0,s1
    8000262a:	ffffe097          	auipc	ra,0xffffe
    8000262e:	710080e7          	jalr	1808(ra) # 80000d3a <acquire>
      if (p->state != UNUSED) {
    80002632:	4c9c                	lw	a5,24(s1)
    80002634:	d3ed                	beqz	a5,80002616 <scheduler+0x54>
        nproc++;
    80002636:	2985                	addiw	s3,s3,1
      if (p->state == RUNNABLE) {
    80002638:	fd579fe3          	bne	a5,s5,80002616 <scheduler+0x54>
        p->state = RUNNING;
    8000263c:	0174ac23          	sw	s7,24(s1)
        c->proc = p;
    80002640:	009b3c23          	sd	s1,24(s6)
        swtch(&c->context, &p->context);
    80002644:	06048593          	addi	a1,s1,96
    80002648:	8562                	mv	a0,s8
    8000264a:	00000097          	auipc	ra,0x0
    8000264e:	60c080e7          	jalr	1548(ra) # 80002c56 <swtch>
        c->proc = 0;
    80002652:	000b3c23          	sd	zero,24(s6)
    80002656:	b7c1                	j	80002616 <scheduler+0x54>
    if (nproc <= 2) { // only init and sh exist
    80002658:	013aca63          	blt	s5,s3,8000266c <scheduler+0xaa>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000265c:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80002660:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002664:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80002668:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000266c:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80002670:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002674:	10079073          	csrw	sstatus,a5
    int nproc = 0;
    80002678:	89e6                	mv	s3,s9
    for (p = proc; p < &proc[NPROC]; p++) {
    8000267a:	0002f497          	auipc	s1,0x2f
    8000267e:	6fe48493          	addi	s1,s1,1790 # 80031d78 <proc>
        p->state = RUNNING;
    80002682:	4b8d                	li	s7,3
    80002684:	b755                	j	80002628 <scheduler+0x66>

0000000080002686 <sched>:
void sched(void) {
    80002686:	7179                	addi	sp,sp,-48
    80002688:	f406                	sd	ra,40(sp)
    8000268a:	f022                	sd	s0,32(sp)
    8000268c:	ec26                	sd	s1,24(sp)
    8000268e:	e84a                	sd	s2,16(sp)
    80002690:	e44e                	sd	s3,8(sp)
    80002692:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002694:	00000097          	auipc	ra,0x0
    80002698:	9fa080e7          	jalr	-1542(ra) # 8000208e <myproc>
    8000269c:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    8000269e:	ffffe097          	auipc	ra,0xffffe
    800026a2:	622080e7          	jalr	1570(ra) # 80000cc0 <holding>
    800026a6:	c93d                	beqz	a0,8000271c <sched+0x96>
  asm volatile("mv %0, tp" : "=r"(x));
    800026a8:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    800026aa:	2781                	sext.w	a5,a5
    800026ac:	079e                	slli	a5,a5,0x7
    800026ae:	0002f717          	auipc	a4,0x2f
    800026b2:	2b270713          	addi	a4,a4,690 # 80031960 <pid_lock>
    800026b6:	97ba                	add	a5,a5,a4
    800026b8:	0907a703          	lw	a4,144(a5)
    800026bc:	4785                	li	a5,1
    800026be:	06f71763          	bne	a4,a5,8000272c <sched+0xa6>
  if (p->state == RUNNING)
    800026c2:	4c98                	lw	a4,24(s1)
    800026c4:	478d                	li	a5,3
    800026c6:	06f70b63          	beq	a4,a5,8000273c <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800026ca:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800026ce:	8b89                	andi	a5,a5,2
  if (intr_get())
    800026d0:	efb5                	bnez	a5,8000274c <sched+0xc6>
  asm volatile("mv %0, tp" : "=r"(x));
    800026d2:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800026d4:	0002f917          	auipc	s2,0x2f
    800026d8:	28c90913          	addi	s2,s2,652 # 80031960 <pid_lock>
    800026dc:	2781                	sext.w	a5,a5
    800026de:	079e                	slli	a5,a5,0x7
    800026e0:	97ca                	add	a5,a5,s2
    800026e2:	0947a983          	lw	s3,148(a5)
    800026e6:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800026e8:	2781                	sext.w	a5,a5
    800026ea:	079e                	slli	a5,a5,0x7
    800026ec:	0002f597          	auipc	a1,0x2f
    800026f0:	29458593          	addi	a1,a1,660 # 80031980 <cpus+0x8>
    800026f4:	95be                	add	a1,a1,a5
    800026f6:	06048513          	addi	a0,s1,96
    800026fa:	00000097          	auipc	ra,0x0
    800026fe:	55c080e7          	jalr	1372(ra) # 80002c56 <swtch>
    80002702:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002704:	2781                	sext.w	a5,a5
    80002706:	079e                	slli	a5,a5,0x7
    80002708:	97ca                	add	a5,a5,s2
    8000270a:	0937aa23          	sw	s3,148(a5)
}
    8000270e:	70a2                	ld	ra,40(sp)
    80002710:	7402                	ld	s0,32(sp)
    80002712:	64e2                	ld	s1,24(sp)
    80002714:	6942                	ld	s2,16(sp)
    80002716:	69a2                	ld	s3,8(sp)
    80002718:	6145                	addi	sp,sp,48
    8000271a:	8082                	ret
    panic("sched p->lock");
    8000271c:	00006517          	auipc	a0,0x6
    80002720:	b8c50513          	addi	a0,a0,-1140 # 800082a8 <digits+0x240>
    80002724:	ffffe097          	auipc	ra,0xffffe
    80002728:	ec0080e7          	jalr	-320(ra) # 800005e4 <panic>
    panic("sched locks");
    8000272c:	00006517          	auipc	a0,0x6
    80002730:	b8c50513          	addi	a0,a0,-1140 # 800082b8 <digits+0x250>
    80002734:	ffffe097          	auipc	ra,0xffffe
    80002738:	eb0080e7          	jalr	-336(ra) # 800005e4 <panic>
    panic("sched running");
    8000273c:	00006517          	auipc	a0,0x6
    80002740:	b8c50513          	addi	a0,a0,-1140 # 800082c8 <digits+0x260>
    80002744:	ffffe097          	auipc	ra,0xffffe
    80002748:	ea0080e7          	jalr	-352(ra) # 800005e4 <panic>
    panic("sched interruptible");
    8000274c:	00006517          	auipc	a0,0x6
    80002750:	b8c50513          	addi	a0,a0,-1140 # 800082d8 <digits+0x270>
    80002754:	ffffe097          	auipc	ra,0xffffe
    80002758:	e90080e7          	jalr	-368(ra) # 800005e4 <panic>

000000008000275c <exit>:
void exit(int status) {
    8000275c:	7179                	addi	sp,sp,-48
    8000275e:	f406                	sd	ra,40(sp)
    80002760:	f022                	sd	s0,32(sp)
    80002762:	ec26                	sd	s1,24(sp)
    80002764:	e84a                	sd	s2,16(sp)
    80002766:	e44e                	sd	s3,8(sp)
    80002768:	e052                	sd	s4,0(sp)
    8000276a:	1800                	addi	s0,sp,48
    8000276c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000276e:	00000097          	auipc	ra,0x0
    80002772:	920080e7          	jalr	-1760(ra) # 8000208e <myproc>
    80002776:	89aa                	mv	s3,a0
  if (p == initproc)
    80002778:	00007797          	auipc	a5,0x7
    8000277c:	8a07b783          	ld	a5,-1888(a5) # 80009018 <initproc>
    80002780:	0d050493          	addi	s1,a0,208
    80002784:	15050913          	addi	s2,a0,336
    80002788:	02a79363          	bne	a5,a0,800027ae <exit+0x52>
    panic("init exiting");
    8000278c:	00006517          	auipc	a0,0x6
    80002790:	b6450513          	addi	a0,a0,-1180 # 800082f0 <digits+0x288>
    80002794:	ffffe097          	auipc	ra,0xffffe
    80002798:	e50080e7          	jalr	-432(ra) # 800005e4 <panic>
      fileclose(f);
    8000279c:	00002097          	auipc	ra,0x2
    800027a0:	536080e7          	jalr	1334(ra) # 80004cd2 <fileclose>
      p->ofile[fd] = 0;
    800027a4:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++) {
    800027a8:	04a1                	addi	s1,s1,8
    800027aa:	01248563          	beq	s1,s2,800027b4 <exit+0x58>
    if (p->ofile[fd]) {
    800027ae:	6088                	ld	a0,0(s1)
    800027b0:	f575                	bnez	a0,8000279c <exit+0x40>
    800027b2:	bfdd                	j	800027a8 <exit+0x4c>
  begin_op();
    800027b4:	00002097          	auipc	ra,0x2
    800027b8:	04c080e7          	jalr	76(ra) # 80004800 <begin_op>
  iput(p->cwd);
    800027bc:	1609b503          	ld	a0,352(s3)
    800027c0:	00002097          	auipc	ra,0x2
    800027c4:	83a080e7          	jalr	-1990(ra) # 80003ffa <iput>
  end_op();
    800027c8:	00002097          	auipc	ra,0x2
    800027cc:	0b8080e7          	jalr	184(ra) # 80004880 <end_op>
  p->cwd = 0;
    800027d0:	1609b023          	sd	zero,352(s3)
  acquire(&initproc->lock);
    800027d4:	00007497          	auipc	s1,0x7
    800027d8:	84448493          	addi	s1,s1,-1980 # 80009018 <initproc>
    800027dc:	6088                	ld	a0,0(s1)
    800027de:	ffffe097          	auipc	ra,0xffffe
    800027e2:	55c080e7          	jalr	1372(ra) # 80000d3a <acquire>
  wakeup1(initproc);
    800027e6:	6088                	ld	a0,0(s1)
    800027e8:	fffff097          	auipc	ra,0xfffff
    800027ec:	766080e7          	jalr	1894(ra) # 80001f4e <wakeup1>
  release(&initproc->lock);
    800027f0:	6088                	ld	a0,0(s1)
    800027f2:	ffffe097          	auipc	ra,0xffffe
    800027f6:	5fc080e7          	jalr	1532(ra) # 80000dee <release>
  acquire(&p->lock);
    800027fa:	854e                	mv	a0,s3
    800027fc:	ffffe097          	auipc	ra,0xffffe
    80002800:	53e080e7          	jalr	1342(ra) # 80000d3a <acquire>
  struct proc *original_parent = p->parent;
    80002804:	0209b483          	ld	s1,32(s3)
  release(&p->lock);
    80002808:	854e                	mv	a0,s3
    8000280a:	ffffe097          	auipc	ra,0xffffe
    8000280e:	5e4080e7          	jalr	1508(ra) # 80000dee <release>
  acquire(&original_parent->lock);
    80002812:	8526                	mv	a0,s1
    80002814:	ffffe097          	auipc	ra,0xffffe
    80002818:	526080e7          	jalr	1318(ra) # 80000d3a <acquire>
  acquire(&p->lock);
    8000281c:	854e                	mv	a0,s3
    8000281e:	ffffe097          	auipc	ra,0xffffe
    80002822:	51c080e7          	jalr	1308(ra) # 80000d3a <acquire>
  reparent(p);
    80002826:	854e                	mv	a0,s3
    80002828:	00000097          	auipc	ra,0x0
    8000282c:	d34080e7          	jalr	-716(ra) # 8000255c <reparent>
  wakeup1(original_parent);
    80002830:	8526                	mv	a0,s1
    80002832:	fffff097          	auipc	ra,0xfffff
    80002836:	71c080e7          	jalr	1820(ra) # 80001f4e <wakeup1>
  p->xstate = status;
    8000283a:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    8000283e:	4791                	li	a5,4
    80002840:	00f9ac23          	sw	a5,24(s3)
  release(&original_parent->lock);
    80002844:	8526                	mv	a0,s1
    80002846:	ffffe097          	auipc	ra,0xffffe
    8000284a:	5a8080e7          	jalr	1448(ra) # 80000dee <release>
  sched();
    8000284e:	00000097          	auipc	ra,0x0
    80002852:	e38080e7          	jalr	-456(ra) # 80002686 <sched>
  panic("zombie exit");
    80002856:	00006517          	auipc	a0,0x6
    8000285a:	aaa50513          	addi	a0,a0,-1366 # 80008300 <digits+0x298>
    8000285e:	ffffe097          	auipc	ra,0xffffe
    80002862:	d86080e7          	jalr	-634(ra) # 800005e4 <panic>

0000000080002866 <yield>:
void yield(void) {
    80002866:	1101                	addi	sp,sp,-32
    80002868:	ec06                	sd	ra,24(sp)
    8000286a:	e822                	sd	s0,16(sp)
    8000286c:	e426                	sd	s1,8(sp)
    8000286e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002870:	00000097          	auipc	ra,0x0
    80002874:	81e080e7          	jalr	-2018(ra) # 8000208e <myproc>
    80002878:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000287a:	ffffe097          	auipc	ra,0xffffe
    8000287e:	4c0080e7          	jalr	1216(ra) # 80000d3a <acquire>
  p->state = RUNNABLE;
    80002882:	4789                	li	a5,2
    80002884:	cc9c                	sw	a5,24(s1)
  sched();
    80002886:	00000097          	auipc	ra,0x0
    8000288a:	e00080e7          	jalr	-512(ra) # 80002686 <sched>
  release(&p->lock);
    8000288e:	8526                	mv	a0,s1
    80002890:	ffffe097          	auipc	ra,0xffffe
    80002894:	55e080e7          	jalr	1374(ra) # 80000dee <release>
}
    80002898:	60e2                	ld	ra,24(sp)
    8000289a:	6442                	ld	s0,16(sp)
    8000289c:	64a2                	ld	s1,8(sp)
    8000289e:	6105                	addi	sp,sp,32
    800028a0:	8082                	ret

00000000800028a2 <sleep>:
void sleep(void *chan, struct spinlock *lk) {
    800028a2:	7179                	addi	sp,sp,-48
    800028a4:	f406                	sd	ra,40(sp)
    800028a6:	f022                	sd	s0,32(sp)
    800028a8:	ec26                	sd	s1,24(sp)
    800028aa:	e84a                	sd	s2,16(sp)
    800028ac:	e44e                	sd	s3,8(sp)
    800028ae:	1800                	addi	s0,sp,48
    800028b0:	89aa                	mv	s3,a0
    800028b2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800028b4:	fffff097          	auipc	ra,0xfffff
    800028b8:	7da080e7          	jalr	2010(ra) # 8000208e <myproc>
    800028bc:	84aa                	mv	s1,a0
  if (lk != &p->lock) { // DOC: sleeplock0
    800028be:	05250663          	beq	a0,s2,8000290a <sleep+0x68>
    acquire(&p->lock);  // DOC: sleeplock1
    800028c2:	ffffe097          	auipc	ra,0xffffe
    800028c6:	478080e7          	jalr	1144(ra) # 80000d3a <acquire>
    release(lk);
    800028ca:	854a                	mv	a0,s2
    800028cc:	ffffe097          	auipc	ra,0xffffe
    800028d0:	522080e7          	jalr	1314(ra) # 80000dee <release>
  p->chan = chan;
    800028d4:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    800028d8:	4785                	li	a5,1
    800028da:	cc9c                	sw	a5,24(s1)
  sched();
    800028dc:	00000097          	auipc	ra,0x0
    800028e0:	daa080e7          	jalr	-598(ra) # 80002686 <sched>
  p->chan = 0;
    800028e4:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    800028e8:	8526                	mv	a0,s1
    800028ea:	ffffe097          	auipc	ra,0xffffe
    800028ee:	504080e7          	jalr	1284(ra) # 80000dee <release>
    acquire(lk);
    800028f2:	854a                	mv	a0,s2
    800028f4:	ffffe097          	auipc	ra,0xffffe
    800028f8:	446080e7          	jalr	1094(ra) # 80000d3a <acquire>
}
    800028fc:	70a2                	ld	ra,40(sp)
    800028fe:	7402                	ld	s0,32(sp)
    80002900:	64e2                	ld	s1,24(sp)
    80002902:	6942                	ld	s2,16(sp)
    80002904:	69a2                	ld	s3,8(sp)
    80002906:	6145                	addi	sp,sp,48
    80002908:	8082                	ret
  p->chan = chan;
    8000290a:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    8000290e:	4785                	li	a5,1
    80002910:	cd1c                	sw	a5,24(a0)
  sched();
    80002912:	00000097          	auipc	ra,0x0
    80002916:	d74080e7          	jalr	-652(ra) # 80002686 <sched>
  p->chan = 0;
    8000291a:	0204b423          	sd	zero,40(s1)
  if (lk != &p->lock) {
    8000291e:	bff9                	j	800028fc <sleep+0x5a>

0000000080002920 <wait>:
int wait(uint64 addr) {
    80002920:	715d                	addi	sp,sp,-80
    80002922:	e486                	sd	ra,72(sp)
    80002924:	e0a2                	sd	s0,64(sp)
    80002926:	fc26                	sd	s1,56(sp)
    80002928:	f84a                	sd	s2,48(sp)
    8000292a:	f44e                	sd	s3,40(sp)
    8000292c:	f052                	sd	s4,32(sp)
    8000292e:	ec56                	sd	s5,24(sp)
    80002930:	e85a                	sd	s6,16(sp)
    80002932:	e45e                	sd	s7,8(sp)
    80002934:	0880                	addi	s0,sp,80
    80002936:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002938:	fffff097          	auipc	ra,0xfffff
    8000293c:	756080e7          	jalr	1878(ra) # 8000208e <myproc>
    80002940:	892a                	mv	s2,a0
  acquire(&p->lock);
    80002942:	ffffe097          	auipc	ra,0xffffe
    80002946:	3f8080e7          	jalr	1016(ra) # 80000d3a <acquire>
    havekids = 0;
    8000294a:	4b81                	li	s7,0
        if (np->state == ZOMBIE) {
    8000294c:	4a11                	li	s4,4
        havekids = 1;
    8000294e:	4a85                	li	s5,1
    for (np = proc; np < &proc[NPROC]; np++) {
    80002950:	00041997          	auipc	s3,0x41
    80002954:	e2898993          	addi	s3,s3,-472 # 80043778 <tickslock>
    havekids = 0;
    80002958:	875e                	mv	a4,s7
    for (np = proc; np < &proc[NPROC]; np++) {
    8000295a:	0002f497          	auipc	s1,0x2f
    8000295e:	41e48493          	addi	s1,s1,1054 # 80031d78 <proc>
    80002962:	a08d                	j	800029c4 <wait+0xa4>
          pid = np->pid;
    80002964:	0384a983          	lw	s3,56(s1)
          freeproc(np);
    80002968:	8526                	mv	a0,s1
    8000296a:	00000097          	auipc	ra,0x0
    8000296e:	8d6080e7          	jalr	-1834(ra) # 80002240 <freeproc>
          if (addr != 0 &&
    80002972:	000b0e63          	beqz	s6,8000298e <wait+0x6e>
              (res = copyout(p->pagetable, addr, (char *)&np->xstate,
    80002976:	4691                	li	a3,4
    80002978:	03448613          	addi	a2,s1,52
    8000297c:	85da                	mv	a1,s6
    8000297e:	05093503          	ld	a0,80(s2)
    80002982:	fffff097          	auipc	ra,0xfffff
    80002986:	0b0080e7          	jalr	176(ra) # 80001a32 <copyout>
          if (addr != 0 &&
    8000298a:	00054d63          	bltz	a0,800029a4 <wait+0x84>
          release(&np->lock);
    8000298e:	8526                	mv	a0,s1
    80002990:	ffffe097          	auipc	ra,0xffffe
    80002994:	45e080e7          	jalr	1118(ra) # 80000dee <release>
          release(&p->lock);
    80002998:	854a                	mv	a0,s2
    8000299a:	ffffe097          	auipc	ra,0xffffe
    8000299e:	454080e7          	jalr	1108(ra) # 80000dee <release>
          return pid;
    800029a2:	a8a9                	j	800029fc <wait+0xdc>
            release(&np->lock);
    800029a4:	8526                	mv	a0,s1
    800029a6:	ffffe097          	auipc	ra,0xffffe
    800029aa:	448080e7          	jalr	1096(ra) # 80000dee <release>
            release(&p->lock);
    800029ae:	854a                	mv	a0,s2
    800029b0:	ffffe097          	auipc	ra,0xffffe
    800029b4:	43e080e7          	jalr	1086(ra) # 80000dee <release>
            return -1;
    800029b8:	59fd                	li	s3,-1
    800029ba:	a089                	j	800029fc <wait+0xdc>
    for (np = proc; np < &proc[NPROC]; np++) {
    800029bc:	46848493          	addi	s1,s1,1128
    800029c0:	03348463          	beq	s1,s3,800029e8 <wait+0xc8>
      if (np->parent == p) {
    800029c4:	709c                	ld	a5,32(s1)
    800029c6:	ff279be3          	bne	a5,s2,800029bc <wait+0x9c>
        acquire(&np->lock);
    800029ca:	8526                	mv	a0,s1
    800029cc:	ffffe097          	auipc	ra,0xffffe
    800029d0:	36e080e7          	jalr	878(ra) # 80000d3a <acquire>
        if (np->state == ZOMBIE) {
    800029d4:	4c9c                	lw	a5,24(s1)
    800029d6:	f94787e3          	beq	a5,s4,80002964 <wait+0x44>
        release(&np->lock);
    800029da:	8526                	mv	a0,s1
    800029dc:	ffffe097          	auipc	ra,0xffffe
    800029e0:	412080e7          	jalr	1042(ra) # 80000dee <release>
        havekids = 1;
    800029e4:	8756                	mv	a4,s5
    800029e6:	bfd9                	j	800029bc <wait+0x9c>
    if (!havekids || p->killed) {
    800029e8:	c701                	beqz	a4,800029f0 <wait+0xd0>
    800029ea:	03092783          	lw	a5,48(s2)
    800029ee:	c39d                	beqz	a5,80002a14 <wait+0xf4>
      release(&p->lock);
    800029f0:	854a                	mv	a0,s2
    800029f2:	ffffe097          	auipc	ra,0xffffe
    800029f6:	3fc080e7          	jalr	1020(ra) # 80000dee <release>
      return -1;
    800029fa:	59fd                	li	s3,-1
}
    800029fc:	854e                	mv	a0,s3
    800029fe:	60a6                	ld	ra,72(sp)
    80002a00:	6406                	ld	s0,64(sp)
    80002a02:	74e2                	ld	s1,56(sp)
    80002a04:	7942                	ld	s2,48(sp)
    80002a06:	79a2                	ld	s3,40(sp)
    80002a08:	7a02                	ld	s4,32(sp)
    80002a0a:	6ae2                	ld	s5,24(sp)
    80002a0c:	6b42                	ld	s6,16(sp)
    80002a0e:	6ba2                	ld	s7,8(sp)
    80002a10:	6161                	addi	sp,sp,80
    80002a12:	8082                	ret
    sleep(p, &p->lock); // DOC: wait-sleep
    80002a14:	85ca                	mv	a1,s2
    80002a16:	854a                	mv	a0,s2
    80002a18:	00000097          	auipc	ra,0x0
    80002a1c:	e8a080e7          	jalr	-374(ra) # 800028a2 <sleep>
    havekids = 0;
    80002a20:	bf25                	j	80002958 <wait+0x38>

0000000080002a22 <wakeup>:
void wakeup(void *chan) {
    80002a22:	7139                	addi	sp,sp,-64
    80002a24:	fc06                	sd	ra,56(sp)
    80002a26:	f822                	sd	s0,48(sp)
    80002a28:	f426                	sd	s1,40(sp)
    80002a2a:	f04a                	sd	s2,32(sp)
    80002a2c:	ec4e                	sd	s3,24(sp)
    80002a2e:	e852                	sd	s4,16(sp)
    80002a30:	e456                	sd	s5,8(sp)
    80002a32:	0080                	addi	s0,sp,64
    80002a34:	8a2a                	mv	s4,a0
  for (p = proc; p < &proc[NPROC]; p++) {
    80002a36:	0002f497          	auipc	s1,0x2f
    80002a3a:	34248493          	addi	s1,s1,834 # 80031d78 <proc>
    if (p->state == SLEEPING && p->chan == chan) {
    80002a3e:	4985                	li	s3,1
      p->state = RUNNABLE;
    80002a40:	4a89                	li	s5,2
  for (p = proc; p < &proc[NPROC]; p++) {
    80002a42:	00041917          	auipc	s2,0x41
    80002a46:	d3690913          	addi	s2,s2,-714 # 80043778 <tickslock>
    80002a4a:	a811                	j	80002a5e <wakeup+0x3c>
    release(&p->lock);
    80002a4c:	8526                	mv	a0,s1
    80002a4e:	ffffe097          	auipc	ra,0xffffe
    80002a52:	3a0080e7          	jalr	928(ra) # 80000dee <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002a56:	46848493          	addi	s1,s1,1128
    80002a5a:	03248063          	beq	s1,s2,80002a7a <wakeup+0x58>
    acquire(&p->lock);
    80002a5e:	8526                	mv	a0,s1
    80002a60:	ffffe097          	auipc	ra,0xffffe
    80002a64:	2da080e7          	jalr	730(ra) # 80000d3a <acquire>
    if (p->state == SLEEPING && p->chan == chan) {
    80002a68:	4c9c                	lw	a5,24(s1)
    80002a6a:	ff3791e3          	bne	a5,s3,80002a4c <wakeup+0x2a>
    80002a6e:	749c                	ld	a5,40(s1)
    80002a70:	fd479ee3          	bne	a5,s4,80002a4c <wakeup+0x2a>
      p->state = RUNNABLE;
    80002a74:	0154ac23          	sw	s5,24(s1)
    80002a78:	bfd1                	j	80002a4c <wakeup+0x2a>
}
    80002a7a:	70e2                	ld	ra,56(sp)
    80002a7c:	7442                	ld	s0,48(sp)
    80002a7e:	74a2                	ld	s1,40(sp)
    80002a80:	7902                	ld	s2,32(sp)
    80002a82:	69e2                	ld	s3,24(sp)
    80002a84:	6a42                	ld	s4,16(sp)
    80002a86:	6aa2                	ld	s5,8(sp)
    80002a88:	6121                	addi	sp,sp,64
    80002a8a:	8082                	ret

0000000080002a8c <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid) {
    80002a8c:	7179                	addi	sp,sp,-48
    80002a8e:	f406                	sd	ra,40(sp)
    80002a90:	f022                	sd	s0,32(sp)
    80002a92:	ec26                	sd	s1,24(sp)
    80002a94:	e84a                	sd	s2,16(sp)
    80002a96:	e44e                	sd	s3,8(sp)
    80002a98:	1800                	addi	s0,sp,48
    80002a9a:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80002a9c:	0002f497          	auipc	s1,0x2f
    80002aa0:	2dc48493          	addi	s1,s1,732 # 80031d78 <proc>
    80002aa4:	00041997          	auipc	s3,0x41
    80002aa8:	cd498993          	addi	s3,s3,-812 # 80043778 <tickslock>
    acquire(&p->lock);
    80002aac:	8526                	mv	a0,s1
    80002aae:	ffffe097          	auipc	ra,0xffffe
    80002ab2:	28c080e7          	jalr	652(ra) # 80000d3a <acquire>
    if (p->pid == pid) {
    80002ab6:	5c9c                	lw	a5,56(s1)
    80002ab8:	01278d63          	beq	a5,s2,80002ad2 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002abc:	8526                	mv	a0,s1
    80002abe:	ffffe097          	auipc	ra,0xffffe
    80002ac2:	330080e7          	jalr	816(ra) # 80000dee <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002ac6:	46848493          	addi	s1,s1,1128
    80002aca:	ff3491e3          	bne	s1,s3,80002aac <kill+0x20>
  }
  return -1;
    80002ace:	557d                	li	a0,-1
    80002ad0:	a821                	j	80002ae8 <kill+0x5c>
      p->killed = 1;
    80002ad2:	4785                	li	a5,1
    80002ad4:	d89c                	sw	a5,48(s1)
      if (p->state == SLEEPING) {
    80002ad6:	4c98                	lw	a4,24(s1)
    80002ad8:	00f70f63          	beq	a4,a5,80002af6 <kill+0x6a>
      release(&p->lock);
    80002adc:	8526                	mv	a0,s1
    80002ade:	ffffe097          	auipc	ra,0xffffe
    80002ae2:	310080e7          	jalr	784(ra) # 80000dee <release>
      return 0;
    80002ae6:	4501                	li	a0,0
}
    80002ae8:	70a2                	ld	ra,40(sp)
    80002aea:	7402                	ld	s0,32(sp)
    80002aec:	64e2                	ld	s1,24(sp)
    80002aee:	6942                	ld	s2,16(sp)
    80002af0:	69a2                	ld	s3,8(sp)
    80002af2:	6145                	addi	sp,sp,48
    80002af4:	8082                	ret
        p->state = RUNNABLE;
    80002af6:	4789                	li	a5,2
    80002af8:	cc9c                	sw	a5,24(s1)
    80002afa:	b7cd                	j	80002adc <kill+0x50>

0000000080002afc <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len) {
    80002afc:	7179                	addi	sp,sp,-48
    80002afe:	f406                	sd	ra,40(sp)
    80002b00:	f022                	sd	s0,32(sp)
    80002b02:	ec26                	sd	s1,24(sp)
    80002b04:	e84a                	sd	s2,16(sp)
    80002b06:	e44e                	sd	s3,8(sp)
    80002b08:	e052                	sd	s4,0(sp)
    80002b0a:	1800                	addi	s0,sp,48
    80002b0c:	84aa                	mv	s1,a0
    80002b0e:	892e                	mv	s2,a1
    80002b10:	89b2                	mv	s3,a2
    80002b12:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002b14:	fffff097          	auipc	ra,0xfffff
    80002b18:	57a080e7          	jalr	1402(ra) # 8000208e <myproc>
  if (user_dst) {
    80002b1c:	c08d                	beqz	s1,80002b3e <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80002b1e:	86d2                	mv	a3,s4
    80002b20:	864e                	mv	a2,s3
    80002b22:	85ca                	mv	a1,s2
    80002b24:	6928                	ld	a0,80(a0)
    80002b26:	fffff097          	auipc	ra,0xfffff
    80002b2a:	f0c080e7          	jalr	-244(ra) # 80001a32 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002b2e:	70a2                	ld	ra,40(sp)
    80002b30:	7402                	ld	s0,32(sp)
    80002b32:	64e2                	ld	s1,24(sp)
    80002b34:	6942                	ld	s2,16(sp)
    80002b36:	69a2                	ld	s3,8(sp)
    80002b38:	6a02                	ld	s4,0(sp)
    80002b3a:	6145                	addi	sp,sp,48
    80002b3c:	8082                	ret
    memmove((char *)dst, src, len);
    80002b3e:	000a061b          	sext.w	a2,s4
    80002b42:	85ce                	mv	a1,s3
    80002b44:	854a                	mv	a0,s2
    80002b46:	ffffe097          	auipc	ra,0xffffe
    80002b4a:	34c080e7          	jalr	844(ra) # 80000e92 <memmove>
    return 0;
    80002b4e:	8526                	mv	a0,s1
    80002b50:	bff9                	j	80002b2e <either_copyout+0x32>

0000000080002b52 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len) {
    80002b52:	7179                	addi	sp,sp,-48
    80002b54:	f406                	sd	ra,40(sp)
    80002b56:	f022                	sd	s0,32(sp)
    80002b58:	ec26                	sd	s1,24(sp)
    80002b5a:	e84a                	sd	s2,16(sp)
    80002b5c:	e44e                	sd	s3,8(sp)
    80002b5e:	e052                	sd	s4,0(sp)
    80002b60:	1800                	addi	s0,sp,48
    80002b62:	892a                	mv	s2,a0
    80002b64:	84ae                	mv	s1,a1
    80002b66:	89b2                	mv	s3,a2
    80002b68:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002b6a:	fffff097          	auipc	ra,0xfffff
    80002b6e:	524080e7          	jalr	1316(ra) # 8000208e <myproc>
  if (user_src) {
    80002b72:	c08d                	beqz	s1,80002b94 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002b74:	86d2                	mv	a3,s4
    80002b76:	864e                	mv	a2,s3
    80002b78:	85ca                	mv	a1,s2
    80002b7a:	6928                	ld	a0,80(a0)
    80002b7c:	fffff097          	auipc	ra,0xfffff
    80002b80:	c42080e7          	jalr	-958(ra) # 800017be <copyin>
  } else {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    80002b84:	70a2                	ld	ra,40(sp)
    80002b86:	7402                	ld	s0,32(sp)
    80002b88:	64e2                	ld	s1,24(sp)
    80002b8a:	6942                	ld	s2,16(sp)
    80002b8c:	69a2                	ld	s3,8(sp)
    80002b8e:	6a02                	ld	s4,0(sp)
    80002b90:	6145                	addi	sp,sp,48
    80002b92:	8082                	ret
    memmove(dst, (char *)src, len);
    80002b94:	000a061b          	sext.w	a2,s4
    80002b98:	85ce                	mv	a1,s3
    80002b9a:	854a                	mv	a0,s2
    80002b9c:	ffffe097          	auipc	ra,0xffffe
    80002ba0:	2f6080e7          	jalr	758(ra) # 80000e92 <memmove>
    return 0;
    80002ba4:	8526                	mv	a0,s1
    80002ba6:	bff9                	j	80002b84 <either_copyin+0x32>

0000000080002ba8 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void) {
    80002ba8:	715d                	addi	sp,sp,-80
    80002baa:	e486                	sd	ra,72(sp)
    80002bac:	e0a2                	sd	s0,64(sp)
    80002bae:	fc26                	sd	s1,56(sp)
    80002bb0:	f84a                	sd	s2,48(sp)
    80002bb2:	f44e                	sd	s3,40(sp)
    80002bb4:	f052                	sd	s4,32(sp)
    80002bb6:	ec56                	sd	s5,24(sp)
    80002bb8:	e85a                	sd	s6,16(sp)
    80002bba:	e45e                	sd	s7,8(sp)
    80002bbc:	0880                	addi	s0,sp,80
                           [RUNNING] "run   ",
                           [ZOMBIE] "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    80002bbe:	00005517          	auipc	a0,0x5
    80002bc2:	4fa50513          	addi	a0,a0,1274 # 800080b8 <digits+0x50>
    80002bc6:	ffffe097          	auipc	ra,0xffffe
    80002bca:	a70080e7          	jalr	-1424(ra) # 80000636 <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002bce:	0002f497          	auipc	s1,0x2f
    80002bd2:	2fa48493          	addi	s1,s1,762 # 80031ec8 <proc+0x150>
    80002bd6:	00041917          	auipc	s2,0x41
    80002bda:	cf290913          	addi	s2,s2,-782 # 800438c8 <bcache+0x138>
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002bde:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    80002be0:	00005997          	auipc	s3,0x5
    80002be4:	73098993          	addi	s3,s3,1840 # 80008310 <digits+0x2a8>
    printf("%d %s %s", p->pid, state, p->name);
    80002be8:	00005a97          	auipc	s5,0x5
    80002bec:	730a8a93          	addi	s5,s5,1840 # 80008318 <digits+0x2b0>
    printf("\n");
    80002bf0:	00005a17          	auipc	s4,0x5
    80002bf4:	4c8a0a13          	addi	s4,s4,1224 # 800080b8 <digits+0x50>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002bf8:	00005b97          	auipc	s7,0x5
    80002bfc:	758b8b93          	addi	s7,s7,1880 # 80008350 <states.0>
    80002c00:	a00d                	j	80002c22 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80002c02:	ee86a583          	lw	a1,-280(a3)
    80002c06:	8556                	mv	a0,s5
    80002c08:	ffffe097          	auipc	ra,0xffffe
    80002c0c:	a2e080e7          	jalr	-1490(ra) # 80000636 <printf>
    printf("\n");
    80002c10:	8552                	mv	a0,s4
    80002c12:	ffffe097          	auipc	ra,0xffffe
    80002c16:	a24080e7          	jalr	-1500(ra) # 80000636 <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002c1a:	46848493          	addi	s1,s1,1128
    80002c1e:	03248163          	beq	s1,s2,80002c40 <procdump+0x98>
    if (p->state == UNUSED)
    80002c22:	86a6                	mv	a3,s1
    80002c24:	ec84a783          	lw	a5,-312(s1)
    80002c28:	dbed                	beqz	a5,80002c1a <procdump+0x72>
      state = "???";
    80002c2a:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002c2c:	fcfb6be3          	bltu	s6,a5,80002c02 <procdump+0x5a>
    80002c30:	1782                	slli	a5,a5,0x20
    80002c32:	9381                	srli	a5,a5,0x20
    80002c34:	078e                	slli	a5,a5,0x3
    80002c36:	97de                	add	a5,a5,s7
    80002c38:	6390                	ld	a2,0(a5)
    80002c3a:	f661                	bnez	a2,80002c02 <procdump+0x5a>
      state = "???";
    80002c3c:	864e                	mv	a2,s3
    80002c3e:	b7d1                	j	80002c02 <procdump+0x5a>
  }
}
    80002c40:	60a6                	ld	ra,72(sp)
    80002c42:	6406                	ld	s0,64(sp)
    80002c44:	74e2                	ld	s1,56(sp)
    80002c46:	7942                	ld	s2,48(sp)
    80002c48:	79a2                	ld	s3,40(sp)
    80002c4a:	7a02                	ld	s4,32(sp)
    80002c4c:	6ae2                	ld	s5,24(sp)
    80002c4e:	6b42                	ld	s6,16(sp)
    80002c50:	6ba2                	ld	s7,8(sp)
    80002c52:	6161                	addi	sp,sp,80
    80002c54:	8082                	ret

0000000080002c56 <swtch>:
    80002c56:	00153023          	sd	ra,0(a0)
    80002c5a:	00253423          	sd	sp,8(a0)
    80002c5e:	e900                	sd	s0,16(a0)
    80002c60:	ed04                	sd	s1,24(a0)
    80002c62:	03253023          	sd	s2,32(a0)
    80002c66:	03353423          	sd	s3,40(a0)
    80002c6a:	03453823          	sd	s4,48(a0)
    80002c6e:	03553c23          	sd	s5,56(a0)
    80002c72:	05653023          	sd	s6,64(a0)
    80002c76:	05753423          	sd	s7,72(a0)
    80002c7a:	05853823          	sd	s8,80(a0)
    80002c7e:	05953c23          	sd	s9,88(a0)
    80002c82:	07a53023          	sd	s10,96(a0)
    80002c86:	07b53423          	sd	s11,104(a0)
    80002c8a:	0005b083          	ld	ra,0(a1)
    80002c8e:	0085b103          	ld	sp,8(a1)
    80002c92:	6980                	ld	s0,16(a1)
    80002c94:	6d84                	ld	s1,24(a1)
    80002c96:	0205b903          	ld	s2,32(a1)
    80002c9a:	0285b983          	ld	s3,40(a1)
    80002c9e:	0305ba03          	ld	s4,48(a1)
    80002ca2:	0385ba83          	ld	s5,56(a1)
    80002ca6:	0405bb03          	ld	s6,64(a1)
    80002caa:	0485bb83          	ld	s7,72(a1)
    80002cae:	0505bc03          	ld	s8,80(a1)
    80002cb2:	0585bc83          	ld	s9,88(a1)
    80002cb6:	0605bd03          	ld	s10,96(a1)
    80002cba:	0685bd83          	ld	s11,104(a1)
    80002cbe:	8082                	ret

0000000080002cc0 <trapinit>:
// in kernelvec.S, calls kerneltrap().
void kernelvec();

extern int devintr();

void trapinit(void) { initlock(&tickslock, "time"); }
    80002cc0:	1141                	addi	sp,sp,-16
    80002cc2:	e406                	sd	ra,8(sp)
    80002cc4:	e022                	sd	s0,0(sp)
    80002cc6:	0800                	addi	s0,sp,16
    80002cc8:	00005597          	auipc	a1,0x5
    80002ccc:	6b058593          	addi	a1,a1,1712 # 80008378 <states.0+0x28>
    80002cd0:	00041517          	auipc	a0,0x41
    80002cd4:	aa850513          	addi	a0,a0,-1368 # 80043778 <tickslock>
    80002cd8:	ffffe097          	auipc	ra,0xffffe
    80002cdc:	fd2080e7          	jalr	-46(ra) # 80000caa <initlock>
    80002ce0:	60a2                	ld	ra,8(sp)
    80002ce2:	6402                	ld	s0,0(sp)
    80002ce4:	0141                	addi	sp,sp,16
    80002ce6:	8082                	ret

0000000080002ce8 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void) { w_stvec((uint64)kernelvec); }
    80002ce8:	1141                	addi	sp,sp,-16
    80002cea:	e422                	sd	s0,8(sp)
    80002cec:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002cee:	00003797          	auipc	a5,0x3
    80002cf2:	64278793          	addi	a5,a5,1602 # 80006330 <kernelvec>
    80002cf6:	10579073          	csrw	stvec,a5
    80002cfa:	6422                	ld	s0,8(sp)
    80002cfc:	0141                	addi	sp,sp,16
    80002cfe:	8082                	ret

0000000080002d00 <usertrapret>:
}

//
// return to user space
//
void usertrapret(void) {
    80002d00:	1141                	addi	sp,sp,-16
    80002d02:	e406                	sd	ra,8(sp)
    80002d04:	e022                	sd	s0,0(sp)
    80002d06:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002d08:	fffff097          	auipc	ra,0xfffff
    80002d0c:	386080e7          	jalr	902(ra) # 8000208e <myproc>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002d10:	100027f3          	csrr	a5,sstatus
static inline void intr_off() { w_sstatus(r_sstatus() & ~SSTATUS_SIE); }
    80002d14:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002d16:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002d1a:	00004617          	auipc	a2,0x4
    80002d1e:	2e660613          	addi	a2,a2,742 # 80007000 <_trampoline>
    80002d22:	00004697          	auipc	a3,0x4
    80002d26:	2de68693          	addi	a3,a3,734 # 80007000 <_trampoline>
    80002d2a:	8e91                	sub	a3,a3,a2
    80002d2c:	040007b7          	lui	a5,0x4000
    80002d30:	17fd                	addi	a5,a5,-1
    80002d32:	07b2                	slli	a5,a5,0xc
    80002d34:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002d36:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002d3a:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    80002d3c:	180026f3          	csrr	a3,satp
    80002d40:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002d42:	6d38                	ld	a4,88(a0)
    80002d44:	6134                	ld	a3,64(a0)
    80002d46:	6585                	lui	a1,0x1
    80002d48:	96ae                	add	a3,a3,a1
    80002d4a:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002d4c:	6d38                	ld	a4,88(a0)
    80002d4e:	00000697          	auipc	a3,0x0
    80002d52:	13868693          	addi	a3,a3,312 # 80002e86 <usertrap>
    80002d56:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002d58:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    80002d5a:	8692                	mv	a3,tp
    80002d5c:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002d5e:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002d62:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002d66:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002d6a:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002d6e:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    80002d70:	6f18                	ld	a4,24(a4)
    80002d72:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002d76:	692c                	ld	a1,80(a0)
    80002d78:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80002d7a:	00004717          	auipc	a4,0x4
    80002d7e:	31670713          	addi	a4,a4,790 # 80007090 <userret>
    80002d82:	8f11                	sub	a4,a4,a2
    80002d84:	97ba                	add	a5,a5,a4
  ((void (*)(uint64, uint64))fn)(TRAPFRAME, satp);
    80002d86:	577d                	li	a4,-1
    80002d88:	177e                	slli	a4,a4,0x3f
    80002d8a:	8dd9                	or	a1,a1,a4
    80002d8c:	02000537          	lui	a0,0x2000
    80002d90:	157d                	addi	a0,a0,-1
    80002d92:	0536                	slli	a0,a0,0xd
    80002d94:	9782                	jalr	a5
}
    80002d96:	60a2                	ld	ra,8(sp)
    80002d98:	6402                	ld	s0,0(sp)
    80002d9a:	0141                	addi	sp,sp,16
    80002d9c:	8082                	ret

0000000080002d9e <clockintr>:
  // so restore trap registers for use by kernelvec.S's sepc instruction.
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr() {
    80002d9e:	1101                	addi	sp,sp,-32
    80002da0:	ec06                	sd	ra,24(sp)
    80002da2:	e822                	sd	s0,16(sp)
    80002da4:	e426                	sd	s1,8(sp)
    80002da6:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002da8:	00041497          	auipc	s1,0x41
    80002dac:	9d048493          	addi	s1,s1,-1584 # 80043778 <tickslock>
    80002db0:	8526                	mv	a0,s1
    80002db2:	ffffe097          	auipc	ra,0xffffe
    80002db6:	f88080e7          	jalr	-120(ra) # 80000d3a <acquire>
  ticks++;
    80002dba:	00006517          	auipc	a0,0x6
    80002dbe:	26650513          	addi	a0,a0,614 # 80009020 <ticks>
    80002dc2:	411c                	lw	a5,0(a0)
    80002dc4:	2785                	addiw	a5,a5,1
    80002dc6:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002dc8:	00000097          	auipc	ra,0x0
    80002dcc:	c5a080e7          	jalr	-934(ra) # 80002a22 <wakeup>
  release(&tickslock);
    80002dd0:	8526                	mv	a0,s1
    80002dd2:	ffffe097          	auipc	ra,0xffffe
    80002dd6:	01c080e7          	jalr	28(ra) # 80000dee <release>
}
    80002dda:	60e2                	ld	ra,24(sp)
    80002ddc:	6442                	ld	s0,16(sp)
    80002dde:	64a2                	ld	s1,8(sp)
    80002de0:	6105                	addi	sp,sp,32
    80002de2:	8082                	ret

0000000080002de4 <devintr>:
// check if it's an external interrupt or software interrupt,
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr() {
    80002de4:	1101                	addi	sp,sp,-32
    80002de6:	ec06                	sd	ra,24(sp)
    80002de8:	e822                	sd	s0,16(sp)
    80002dea:	e426                	sd	s1,8(sp)
    80002dec:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r"(x));
    80002dee:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80002df2:	00074d63          	bltz	a4,80002e0c <devintr+0x28>
    // now allowed to interrupt again.
    if (irq)
      plic_complete(irq);

    return 1;
  } else if (scause == 0x8000000000000001L) {
    80002df6:	57fd                	li	a5,-1
    80002df8:	17fe                	slli	a5,a5,0x3f
    80002dfa:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002dfc:	4501                	li	a0,0
  } else if (scause == 0x8000000000000001L) {
    80002dfe:	06f70363          	beq	a4,a5,80002e64 <devintr+0x80>
  }
}
    80002e02:	60e2                	ld	ra,24(sp)
    80002e04:	6442                	ld	s0,16(sp)
    80002e06:	64a2                	ld	s1,8(sp)
    80002e08:	6105                	addi	sp,sp,32
    80002e0a:	8082                	ret
  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80002e0c:	0ff77793          	andi	a5,a4,255
    80002e10:	46a5                	li	a3,9
    80002e12:	fed792e3          	bne	a5,a3,80002df6 <devintr+0x12>
    int irq = plic_claim();
    80002e16:	00003097          	auipc	ra,0x3
    80002e1a:	622080e7          	jalr	1570(ra) # 80006438 <plic_claim>
    80002e1e:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ) {
    80002e20:	47a9                	li	a5,10
    80002e22:	02f50763          	beq	a0,a5,80002e50 <devintr+0x6c>
    } else if (irq == VIRTIO0_IRQ) {
    80002e26:	4785                	li	a5,1
    80002e28:	02f50963          	beq	a0,a5,80002e5a <devintr+0x76>
    return 1;
    80002e2c:	4505                	li	a0,1
    } else if (irq) {
    80002e2e:	d8f1                	beqz	s1,80002e02 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002e30:	85a6                	mv	a1,s1
    80002e32:	00005517          	auipc	a0,0x5
    80002e36:	54e50513          	addi	a0,a0,1358 # 80008380 <states.0+0x30>
    80002e3a:	ffffd097          	auipc	ra,0xffffd
    80002e3e:	7fc080e7          	jalr	2044(ra) # 80000636 <printf>
      plic_complete(irq);
    80002e42:	8526                	mv	a0,s1
    80002e44:	00003097          	auipc	ra,0x3
    80002e48:	618080e7          	jalr	1560(ra) # 8000645c <plic_complete>
    return 1;
    80002e4c:	4505                	li	a0,1
    80002e4e:	bf55                	j	80002e02 <devintr+0x1e>
      uartintr();
    80002e50:	ffffe097          	auipc	ra,0xffffe
    80002e54:	bea080e7          	jalr	-1046(ra) # 80000a3a <uartintr>
    80002e58:	b7ed                	j	80002e42 <devintr+0x5e>
      virtio_disk_intr();
    80002e5a:	00004097          	auipc	ra,0x4
    80002e5e:	a7c080e7          	jalr	-1412(ra) # 800068d6 <virtio_disk_intr>
    80002e62:	b7c5                	j	80002e42 <devintr+0x5e>
    if (cpuid() == 0) {
    80002e64:	fffff097          	auipc	ra,0xfffff
    80002e68:	1fe080e7          	jalr	510(ra) # 80002062 <cpuid>
    80002e6c:	c901                	beqz	a0,80002e7c <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r"(x));
    80002e6e:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002e72:	9bf5                	andi	a5,a5,-3
static inline void w_sip(uint64 x) { asm volatile("csrw sip, %0" : : "r"(x)); }
    80002e74:	14479073          	csrw	sip,a5
    return 2;
    80002e78:	4509                	li	a0,2
    80002e7a:	b761                	j	80002e02 <devintr+0x1e>
      clockintr();
    80002e7c:	00000097          	auipc	ra,0x0
    80002e80:	f22080e7          	jalr	-222(ra) # 80002d9e <clockintr>
    80002e84:	b7ed                	j	80002e6e <devintr+0x8a>

0000000080002e86 <usertrap>:
void usertrap(void) {
    80002e86:	7179                	addi	sp,sp,-48
    80002e88:	f406                	sd	ra,40(sp)
    80002e8a:	f022                	sd	s0,32(sp)
    80002e8c:	ec26                	sd	s1,24(sp)
    80002e8e:	e84a                	sd	s2,16(sp)
    80002e90:	e44e                	sd	s3,8(sp)
    80002e92:	e052                	sd	s4,0(sp)
    80002e94:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002e96:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80002e9a:	1007f793          	andi	a5,a5,256
    80002e9e:	e7a5                	bnez	a5,80002f06 <usertrap+0x80>
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002ea0:	00003797          	auipc	a5,0x3
    80002ea4:	49078793          	addi	a5,a5,1168 # 80006330 <kernelvec>
    80002ea8:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002eac:	fffff097          	auipc	ra,0xfffff
    80002eb0:	1e2080e7          	jalr	482(ra) # 8000208e <myproc>
    80002eb4:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002eb6:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002eb8:	14102773          	csrr	a4,sepc
    80002ebc:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    80002ebe:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    80002ec2:	47a1                	li	a5,8
    80002ec4:	04f71f63          	bne	a4,a5,80002f22 <usertrap+0x9c>
    if (p->killed)
    80002ec8:	591c                	lw	a5,48(a0)
    80002eca:	e7b1                	bnez	a5,80002f16 <usertrap+0x90>
    p->trapframe->epc += 4;
    80002ecc:	6cb8                	ld	a4,88(s1)
    80002ece:	6f1c                	ld	a5,24(a4)
    80002ed0:	0791                	addi	a5,a5,4
    80002ed2:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002ed4:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80002ed8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002edc:	10079073          	csrw	sstatus,a5
    syscall();
    80002ee0:	00000097          	auipc	ra,0x0
    80002ee4:	420080e7          	jalr	1056(ra) # 80003300 <syscall>
  if (p->killed)
    80002ee8:	589c                	lw	a5,48(s1)
    80002eea:	1c079863          	bnez	a5,800030ba <usertrap+0x234>
  usertrapret();
    80002eee:	00000097          	auipc	ra,0x0
    80002ef2:	e12080e7          	jalr	-494(ra) # 80002d00 <usertrapret>
}
    80002ef6:	70a2                	ld	ra,40(sp)
    80002ef8:	7402                	ld	s0,32(sp)
    80002efa:	64e2                	ld	s1,24(sp)
    80002efc:	6942                	ld	s2,16(sp)
    80002efe:	69a2                	ld	s3,8(sp)
    80002f00:	6a02                	ld	s4,0(sp)
    80002f02:	6145                	addi	sp,sp,48
    80002f04:	8082                	ret
    panic("usertrap: not from user mode");
    80002f06:	00005517          	auipc	a0,0x5
    80002f0a:	49a50513          	addi	a0,a0,1178 # 800083a0 <states.0+0x50>
    80002f0e:	ffffd097          	auipc	ra,0xffffd
    80002f12:	6d6080e7          	jalr	1750(ra) # 800005e4 <panic>
      exit(-1);
    80002f16:	557d                	li	a0,-1
    80002f18:	00000097          	auipc	ra,0x0
    80002f1c:	844080e7          	jalr	-1980(ra) # 8000275c <exit>
    80002f20:	b775                	j	80002ecc <usertrap+0x46>
  } else if ((which_dev = devintr()) != 0) {
    80002f22:	00000097          	auipc	ra,0x0
    80002f26:	ec2080e7          	jalr	-318(ra) # 80002de4 <devintr>
    80002f2a:	89aa                	mv	s3,a0
    80002f2c:	18051463          	bnez	a0,800030b4 <usertrap+0x22e>
  asm volatile("csrr %0, scause" : "=r"(x));
    80002f30:	14202773          	csrr	a4,scause
  } else if (r_scause() == 13 || r_scause() == 15) {
    80002f34:	47b5                	li	a5,13
    80002f36:	00f70763          	beq	a4,a5,80002f44 <usertrap+0xbe>
    80002f3a:	14202773          	csrr	a4,scause
    80002f3e:	47bd                	li	a5,15
    80002f40:	14f71063          	bne	a4,a5,80003080 <usertrap+0x1fa>
  asm volatile("csrr %0, stval" : "=r"(x));
    80002f44:	14302a73          	csrr	s4,stval
    if (addr > MAXVA) {
    80002f48:	4785                	li	a5,1
    80002f4a:	179a                	slli	a5,a5,0x26
    80002f4c:	0347e463          	bltu	a5,s4,80002f74 <usertrap+0xee>
    pte_t *pte = walk(p->pagetable, addr, 0);
    80002f50:	4601                	li	a2,0
    80002f52:	85d2                	mv	a1,s4
    80002f54:	68a8                	ld	a0,80(s1)
    80002f56:	ffffe097          	auipc	ra,0xffffe
    80002f5a:	1c8080e7          	jalr	456(ra) # 8000111e <walk>
    if (pte && (*pte & PTE_COW)) {
    80002f5e:	c509                	beqz	a0,80002f68 <usertrap+0xe2>
    80002f60:	611c                	ld	a5,0(a0)
    80002f62:	1007f793          	andi	a5,a5,256
    80002f66:	e395                	bnez	a5,80002f8a <usertrap+0x104>
    80002f68:	16848793          	addi	a5,s1,360
void usertrap(void) {
    80002f6c:	894e                	mv	s2,s3
      if ((void *)addr >= p->vma[i].start &&
    80002f6e:	85d2                	mv	a1,s4
    for (int i = 0; i < MAX_VMA; i++) {
    80002f70:	46c1                	li	a3,16
    80002f72:	a07d                	j	80003020 <usertrap+0x19a>
      printf("memory overflow");
    80002f74:	00005517          	auipc	a0,0x5
    80002f78:	44c50513          	addi	a0,a0,1100 # 800083c0 <states.0+0x70>
    80002f7c:	ffffd097          	auipc	ra,0xffffd
    80002f80:	6ba080e7          	jalr	1722(ra) # 80000636 <printf>
      p->killed = 1;
    80002f84:	4785                	li	a5,1
    80002f86:	d89c                	sw	a5,48(s1)
    80002f88:	b7e1                	j	80002f50 <usertrap+0xca>
      int res = do_cow(p->pagetable, addr);
    80002f8a:	85d2                	mv	a1,s4
    80002f8c:	68a8                	ld	a0,80(s1)
    80002f8e:	fffff097          	auipc	ra,0xfffff
    80002f92:	972080e7          	jalr	-1678(ra) # 80001900 <do_cow>
      if (res != 0) {
    80002f96:	d929                	beqz	a0,80002ee8 <usertrap+0x62>
        printf("cow failed");
    80002f98:	00005517          	auipc	a0,0x5
    80002f9c:	43850513          	addi	a0,a0,1080 # 800083d0 <states.0+0x80>
    80002fa0:	ffffd097          	auipc	ra,0xffffd
    80002fa4:	696080e7          	jalr	1686(ra) # 80000636 <printf>
        p->killed = 1;
    80002fa8:	4785                	li	a5,1
    80002faa:	d89c                	sw	a5,48(s1)
    80002fac:	a82d                	j	80002fe6 <usertrap+0x160>
          printf("original permission %p\n", PTE_FLAGS(*pte));
    80002fae:	3ff5f593          	andi	a1,a1,1023
    80002fb2:	00005517          	auipc	a0,0x5
    80002fb6:	42e50513          	addi	a0,a0,1070 # 800083e0 <states.0+0x90>
    80002fba:	ffffd097          	auipc	ra,0xffffd
    80002fbe:	67c080e7          	jalr	1660(ra) # 80000636 <printf>
          printf("map exists");
    80002fc2:	00005517          	auipc	a0,0x5
    80002fc6:	43650513          	addi	a0,a0,1078 # 800083f8 <states.0+0xa8>
    80002fca:	ffffd097          	auipc	ra,0xffffd
    80002fce:	66c080e7          	jalr	1644(ra) # 80000636 <printf>
      printf("memory access  permission denied");
    80002fd2:	00005517          	auipc	a0,0x5
    80002fd6:	45e50513          	addi	a0,a0,1118 # 80008430 <states.0+0xe0>
    80002fda:	ffffd097          	auipc	ra,0xffffd
    80002fde:	65c080e7          	jalr	1628(ra) # 80000636 <printf>
      p->killed = 1;
    80002fe2:	4785                	li	a5,1
    80002fe4:	d89c                	sw	a5,48(s1)
    exit(-1);
    80002fe6:	557d                	li	a0,-1
    80002fe8:	fffff097          	auipc	ra,0xfffff
    80002fec:	774080e7          	jalr	1908(ra) # 8000275c <exit>
  if (which_dev == 2)
    80002ff0:	4789                	li	a5,2
    80002ff2:	eef99ee3          	bne	s3,a5,80002eee <usertrap+0x68>
    yield();
    80002ff6:	00000097          	auipc	ra,0x0
    80002ffa:	870080e7          	jalr	-1936(ra) # 80002866 <yield>
    80002ffe:	bdc5                	j	80002eee <usertrap+0x68>
          printf("run out of memory\n");
    80003000:	00005517          	auipc	a0,0x5
    80003004:	40850513          	addi	a0,a0,1032 # 80008408 <states.0+0xb8>
    80003008:	ffffd097          	auipc	ra,0xffffd
    8000300c:	62e080e7          	jalr	1582(ra) # 80000636 <printf>
          p->killed = 1;
    80003010:	4785                	li	a5,1
    80003012:	d89c                	sw	a5,48(s1)
    80003014:	bfc9                	j	80002fe6 <usertrap+0x160>
    for (int i = 0; i < MAX_VMA; i++) {
    80003016:	2905                	addiw	s2,s2,1
    80003018:	03078793          	addi	a5,a5,48
    8000301c:	fad90be3          	beq	s2,a3,80002fd2 <usertrap+0x14c>
      if ((void *)addr >= p->vma[i].start &&
    80003020:	6398                	ld	a4,0(a5)
    80003022:	feea6ae3          	bltu	s4,a4,80003016 <usertrap+0x190>
          (void *)addr < p->vma[i].start + p->vma[i].length) {
    80003026:	4b90                	lw	a2,16(a5)
    80003028:	9732                	add	a4,a4,a2
      if ((void *)addr >= p->vma[i].start &&
    8000302a:	fee5f6e3          	bgeu	a1,a4,80003016 <usertrap+0x190>
        pte_t *pte = walk(p->pagetable, addr, 0);
    8000302e:	4601                	li	a2,0
    80003030:	85d2                	mv	a1,s4
    80003032:	68a8                	ld	a0,80(s1)
    80003034:	ffffe097          	auipc	ra,0xffffe
    80003038:	0ea080e7          	jalr	234(ra) # 8000111e <walk>
        if (pte && (*pte & PTE_V)) {
    8000303c:	c509                	beqz	a0,80003046 <usertrap+0x1c0>
    8000303e:	610c                	ld	a1,0(a0)
    80003040:	0015f793          	andi	a5,a1,1
    80003044:	f7ad                	bnez	a5,80002fae <usertrap+0x128>
        if ((res = do_vma((void *)addr, &p->vma[i])) == -1) {
    80003046:	00191593          	slli	a1,s2,0x1
    8000304a:	95ca                	add	a1,a1,s2
    8000304c:	0592                	slli	a1,a1,0x4
    8000304e:	16858593          	addi	a1,a1,360 # 1168 <_entry-0x7fffee98>
    80003052:	95a6                	add	a1,a1,s1
    80003054:	8552                	mv	a0,s4
    80003056:	fffff097          	auipc	ra,0xfffff
    8000305a:	b10080e7          	jalr	-1264(ra) # 80001b66 <do_vma>
    8000305e:	57fd                	li	a5,-1
    80003060:	faf500e3          	beq	a0,a5,80003000 <usertrap+0x17a>
        } else if (res == -2) {
    80003064:	57f9                	li	a5,-2
    80003066:	e8f511e3          	bne	a0,a5,80002ee8 <usertrap+0x62>
          printf("map failed");
    8000306a:	00005517          	auipc	a0,0x5
    8000306e:	3b650513          	addi	a0,a0,950 # 80008420 <states.0+0xd0>
    80003072:	ffffd097          	auipc	ra,0xffffd
    80003076:	5c4080e7          	jalr	1476(ra) # 80000636 <printf>
          p->killed = 1;
    8000307a:	4785                	li	a5,1
    8000307c:	d89c                	sw	a5,48(s1)
    8000307e:	b7a5                	j	80002fe6 <usertrap+0x160>
  asm volatile("csrr %0, scause" : "=r"(x));
    80003080:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80003084:	5c90                	lw	a2,56(s1)
    80003086:	00005517          	auipc	a0,0x5
    8000308a:	3d250513          	addi	a0,a0,978 # 80008458 <states.0+0x108>
    8000308e:	ffffd097          	auipc	ra,0xffffd
    80003092:	5a8080e7          	jalr	1448(ra) # 80000636 <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80003096:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    8000309a:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    8000309e:	00005517          	auipc	a0,0x5
    800030a2:	3ea50513          	addi	a0,a0,1002 # 80008488 <states.0+0x138>
    800030a6:	ffffd097          	auipc	ra,0xffffd
    800030aa:	590080e7          	jalr	1424(ra) # 80000636 <printf>
    p->killed = 1;
    800030ae:	4785                	li	a5,1
    800030b0:	d89c                	sw	a5,48(s1)
    800030b2:	bf15                	j	80002fe6 <usertrap+0x160>
  if (p->killed)
    800030b4:	589c                	lw	a5,48(s1)
    800030b6:	df8d                	beqz	a5,80002ff0 <usertrap+0x16a>
    800030b8:	b73d                	j	80002fe6 <usertrap+0x160>
    800030ba:	4981                	li	s3,0
    800030bc:	b72d                	j	80002fe6 <usertrap+0x160>

00000000800030be <kerneltrap>:
void kerneltrap() {
    800030be:	7179                	addi	sp,sp,-48
    800030c0:	f406                	sd	ra,40(sp)
    800030c2:	f022                	sd	s0,32(sp)
    800030c4:	ec26                	sd	s1,24(sp)
    800030c6:	e84a                	sd	s2,16(sp)
    800030c8:	e44e                	sd	s3,8(sp)
    800030ca:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    800030cc:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800030d0:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    800030d4:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    800030d8:	1004f793          	andi	a5,s1,256
    800030dc:	cb85                	beqz	a5,8000310c <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800030de:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800030e2:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    800030e4:	ef85                	bnez	a5,8000311c <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0) {
    800030e6:	00000097          	auipc	ra,0x0
    800030ea:	cfe080e7          	jalr	-770(ra) # 80002de4 <devintr>
    800030ee:	cd1d                	beqz	a0,8000312c <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800030f0:	4789                	li	a5,2
    800030f2:	06f50a63          	beq	a0,a5,80003166 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r"(x));
    800030f6:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    800030fa:	10049073          	csrw	sstatus,s1
}
    800030fe:	70a2                	ld	ra,40(sp)
    80003100:	7402                	ld	s0,32(sp)
    80003102:	64e2                	ld	s1,24(sp)
    80003104:	6942                	ld	s2,16(sp)
    80003106:	69a2                	ld	s3,8(sp)
    80003108:	6145                	addi	sp,sp,48
    8000310a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    8000310c:	00005517          	auipc	a0,0x5
    80003110:	39c50513          	addi	a0,a0,924 # 800084a8 <states.0+0x158>
    80003114:	ffffd097          	auipc	ra,0xffffd
    80003118:	4d0080e7          	jalr	1232(ra) # 800005e4 <panic>
    panic("kerneltrap: interrupts enabled");
    8000311c:	00005517          	auipc	a0,0x5
    80003120:	3b450513          	addi	a0,a0,948 # 800084d0 <states.0+0x180>
    80003124:	ffffd097          	auipc	ra,0xffffd
    80003128:	4c0080e7          	jalr	1216(ra) # 800005e4 <panic>
    printf("scause %p\n", scause);
    8000312c:	85ce                	mv	a1,s3
    8000312e:	00005517          	auipc	a0,0x5
    80003132:	3c250513          	addi	a0,a0,962 # 800084f0 <states.0+0x1a0>
    80003136:	ffffd097          	auipc	ra,0xffffd
    8000313a:	500080e7          	jalr	1280(ra) # 80000636 <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    8000313e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80003142:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003146:	00005517          	auipc	a0,0x5
    8000314a:	3ba50513          	addi	a0,a0,954 # 80008500 <states.0+0x1b0>
    8000314e:	ffffd097          	auipc	ra,0xffffd
    80003152:	4e8080e7          	jalr	1256(ra) # 80000636 <printf>
    panic("kerneltrap");
    80003156:	00005517          	auipc	a0,0x5
    8000315a:	3c250513          	addi	a0,a0,962 # 80008518 <states.0+0x1c8>
    8000315e:	ffffd097          	auipc	ra,0xffffd
    80003162:	486080e7          	jalr	1158(ra) # 800005e4 <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80003166:	fffff097          	auipc	ra,0xfffff
    8000316a:	f28080e7          	jalr	-216(ra) # 8000208e <myproc>
    8000316e:	d541                	beqz	a0,800030f6 <kerneltrap+0x38>
    80003170:	fffff097          	auipc	ra,0xfffff
    80003174:	f1e080e7          	jalr	-226(ra) # 8000208e <myproc>
    80003178:	4d18                	lw	a4,24(a0)
    8000317a:	478d                	li	a5,3
    8000317c:	f6f71de3          	bne	a4,a5,800030f6 <kerneltrap+0x38>
    yield();
    80003180:	fffff097          	auipc	ra,0xfffff
    80003184:	6e6080e7          	jalr	1766(ra) # 80002866 <yield>
    80003188:	b7bd                	j	800030f6 <kerneltrap+0x38>

000000008000318a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000318a:	1101                	addi	sp,sp,-32
    8000318c:	ec06                	sd	ra,24(sp)
    8000318e:	e822                	sd	s0,16(sp)
    80003190:	e426                	sd	s1,8(sp)
    80003192:	1000                	addi	s0,sp,32
    80003194:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80003196:	fffff097          	auipc	ra,0xfffff
    8000319a:	ef8080e7          	jalr	-264(ra) # 8000208e <myproc>
  switch (n) {
    8000319e:	4795                	li	a5,5
    800031a0:	0497e163          	bltu	a5,s1,800031e2 <argraw+0x58>
    800031a4:	048a                	slli	s1,s1,0x2
    800031a6:	00005717          	auipc	a4,0x5
    800031aa:	3aa70713          	addi	a4,a4,938 # 80008550 <states.0+0x200>
    800031ae:	94ba                	add	s1,s1,a4
    800031b0:	409c                	lw	a5,0(s1)
    800031b2:	97ba                	add	a5,a5,a4
    800031b4:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800031b6:	6d3c                	ld	a5,88(a0)
    800031b8:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800031ba:	60e2                	ld	ra,24(sp)
    800031bc:	6442                	ld	s0,16(sp)
    800031be:	64a2                	ld	s1,8(sp)
    800031c0:	6105                	addi	sp,sp,32
    800031c2:	8082                	ret
    return p->trapframe->a1;
    800031c4:	6d3c                	ld	a5,88(a0)
    800031c6:	7fa8                	ld	a0,120(a5)
    800031c8:	bfcd                	j	800031ba <argraw+0x30>
    return p->trapframe->a2;
    800031ca:	6d3c                	ld	a5,88(a0)
    800031cc:	63c8                	ld	a0,128(a5)
    800031ce:	b7f5                	j	800031ba <argraw+0x30>
    return p->trapframe->a3;
    800031d0:	6d3c                	ld	a5,88(a0)
    800031d2:	67c8                	ld	a0,136(a5)
    800031d4:	b7dd                	j	800031ba <argraw+0x30>
    return p->trapframe->a4;
    800031d6:	6d3c                	ld	a5,88(a0)
    800031d8:	6bc8                	ld	a0,144(a5)
    800031da:	b7c5                	j	800031ba <argraw+0x30>
    return p->trapframe->a5;
    800031dc:	6d3c                	ld	a5,88(a0)
    800031de:	6fc8                	ld	a0,152(a5)
    800031e0:	bfe9                	j	800031ba <argraw+0x30>
  panic("argraw");
    800031e2:	00005517          	auipc	a0,0x5
    800031e6:	34650513          	addi	a0,a0,838 # 80008528 <states.0+0x1d8>
    800031ea:	ffffd097          	auipc	ra,0xffffd
    800031ee:	3fa080e7          	jalr	1018(ra) # 800005e4 <panic>

00000000800031f2 <fetchaddr>:
{
    800031f2:	1101                	addi	sp,sp,-32
    800031f4:	ec06                	sd	ra,24(sp)
    800031f6:	e822                	sd	s0,16(sp)
    800031f8:	e426                	sd	s1,8(sp)
    800031fa:	e04a                	sd	s2,0(sp)
    800031fc:	1000                	addi	s0,sp,32
    800031fe:	84aa                	mv	s1,a0
    80003200:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80003202:	fffff097          	auipc	ra,0xfffff
    80003206:	e8c080e7          	jalr	-372(ra) # 8000208e <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    8000320a:	653c                	ld	a5,72(a0)
    8000320c:	02f4f863          	bgeu	s1,a5,8000323c <fetchaddr+0x4a>
    80003210:	00848713          	addi	a4,s1,8
    80003214:	02e7e663          	bltu	a5,a4,80003240 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80003218:	46a1                	li	a3,8
    8000321a:	8626                	mv	a2,s1
    8000321c:	85ca                	mv	a1,s2
    8000321e:	6928                	ld	a0,80(a0)
    80003220:	ffffe097          	auipc	ra,0xffffe
    80003224:	59e080e7          	jalr	1438(ra) # 800017be <copyin>
    80003228:	00a03533          	snez	a0,a0
    8000322c:	40a00533          	neg	a0,a0
}
    80003230:	60e2                	ld	ra,24(sp)
    80003232:	6442                	ld	s0,16(sp)
    80003234:	64a2                	ld	s1,8(sp)
    80003236:	6902                	ld	s2,0(sp)
    80003238:	6105                	addi	sp,sp,32
    8000323a:	8082                	ret
    return -1;
    8000323c:	557d                	li	a0,-1
    8000323e:	bfcd                	j	80003230 <fetchaddr+0x3e>
    80003240:	557d                	li	a0,-1
    80003242:	b7fd                	j	80003230 <fetchaddr+0x3e>

0000000080003244 <fetchstr>:
{
    80003244:	7179                	addi	sp,sp,-48
    80003246:	f406                	sd	ra,40(sp)
    80003248:	f022                	sd	s0,32(sp)
    8000324a:	ec26                	sd	s1,24(sp)
    8000324c:	e84a                	sd	s2,16(sp)
    8000324e:	e44e                	sd	s3,8(sp)
    80003250:	1800                	addi	s0,sp,48
    80003252:	892a                	mv	s2,a0
    80003254:	84ae                	mv	s1,a1
    80003256:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80003258:	fffff097          	auipc	ra,0xfffff
    8000325c:	e36080e7          	jalr	-458(ra) # 8000208e <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80003260:	86ce                	mv	a3,s3
    80003262:	864a                	mv	a2,s2
    80003264:	85a6                	mv	a1,s1
    80003266:	6928                	ld	a0,80(a0)
    80003268:	ffffe097          	auipc	ra,0xffffe
    8000326c:	5e4080e7          	jalr	1508(ra) # 8000184c <copyinstr>
  if(err < 0)
    80003270:	00054763          	bltz	a0,8000327e <fetchstr+0x3a>
  return strlen(buf);
    80003274:	8526                	mv	a0,s1
    80003276:	ffffe097          	auipc	ra,0xffffe
    8000327a:	d44080e7          	jalr	-700(ra) # 80000fba <strlen>
}
    8000327e:	70a2                	ld	ra,40(sp)
    80003280:	7402                	ld	s0,32(sp)
    80003282:	64e2                	ld	s1,24(sp)
    80003284:	6942                	ld	s2,16(sp)
    80003286:	69a2                	ld	s3,8(sp)
    80003288:	6145                	addi	sp,sp,48
    8000328a:	8082                	ret

000000008000328c <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    8000328c:	1101                	addi	sp,sp,-32
    8000328e:	ec06                	sd	ra,24(sp)
    80003290:	e822                	sd	s0,16(sp)
    80003292:	e426                	sd	s1,8(sp)
    80003294:	1000                	addi	s0,sp,32
    80003296:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80003298:	00000097          	auipc	ra,0x0
    8000329c:	ef2080e7          	jalr	-270(ra) # 8000318a <argraw>
    800032a0:	c088                	sw	a0,0(s1)
  return 0;
}
    800032a2:	4501                	li	a0,0
    800032a4:	60e2                	ld	ra,24(sp)
    800032a6:	6442                	ld	s0,16(sp)
    800032a8:	64a2                	ld	s1,8(sp)
    800032aa:	6105                	addi	sp,sp,32
    800032ac:	8082                	ret

00000000800032ae <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800032ae:	1101                	addi	sp,sp,-32
    800032b0:	ec06                	sd	ra,24(sp)
    800032b2:	e822                	sd	s0,16(sp)
    800032b4:	e426                	sd	s1,8(sp)
    800032b6:	1000                	addi	s0,sp,32
    800032b8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800032ba:	00000097          	auipc	ra,0x0
    800032be:	ed0080e7          	jalr	-304(ra) # 8000318a <argraw>
    800032c2:	e088                	sd	a0,0(s1)
  return 0;
}
    800032c4:	4501                	li	a0,0
    800032c6:	60e2                	ld	ra,24(sp)
    800032c8:	6442                	ld	s0,16(sp)
    800032ca:	64a2                	ld	s1,8(sp)
    800032cc:	6105                	addi	sp,sp,32
    800032ce:	8082                	ret

00000000800032d0 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800032d0:	1101                	addi	sp,sp,-32
    800032d2:	ec06                	sd	ra,24(sp)
    800032d4:	e822                	sd	s0,16(sp)
    800032d6:	e426                	sd	s1,8(sp)
    800032d8:	e04a                	sd	s2,0(sp)
    800032da:	1000                	addi	s0,sp,32
    800032dc:	84ae                	mv	s1,a1
    800032de:	8932                	mv	s2,a2
  *ip = argraw(n);
    800032e0:	00000097          	auipc	ra,0x0
    800032e4:	eaa080e7          	jalr	-342(ra) # 8000318a <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800032e8:	864a                	mv	a2,s2
    800032ea:	85a6                	mv	a1,s1
    800032ec:	00000097          	auipc	ra,0x0
    800032f0:	f58080e7          	jalr	-168(ra) # 80003244 <fetchstr>
}
    800032f4:	60e2                	ld	ra,24(sp)
    800032f6:	6442                	ld	s0,16(sp)
    800032f8:	64a2                	ld	s1,8(sp)
    800032fa:	6902                	ld	s2,0(sp)
    800032fc:	6105                	addi	sp,sp,32
    800032fe:	8082                	ret

0000000080003300 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80003300:	1101                	addi	sp,sp,-32
    80003302:	ec06                	sd	ra,24(sp)
    80003304:	e822                	sd	s0,16(sp)
    80003306:	e426                	sd	s1,8(sp)
    80003308:	e04a                	sd	s2,0(sp)
    8000330a:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000330c:	fffff097          	auipc	ra,0xfffff
    80003310:	d82080e7          	jalr	-638(ra) # 8000208e <myproc>
    80003314:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80003316:	05853903          	ld	s2,88(a0)
    8000331a:	0a893783          	ld	a5,168(s2)
    8000331e:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80003322:	37fd                	addiw	a5,a5,-1
    80003324:	4751                	li	a4,20
    80003326:	00f76f63          	bltu	a4,a5,80003344 <syscall+0x44>
    8000332a:	00369713          	slli	a4,a3,0x3
    8000332e:	00005797          	auipc	a5,0x5
    80003332:	23a78793          	addi	a5,a5,570 # 80008568 <syscalls>
    80003336:	97ba                	add	a5,a5,a4
    80003338:	639c                	ld	a5,0(a5)
    8000333a:	c789                	beqz	a5,80003344 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    8000333c:	9782                	jalr	a5
    8000333e:	06a93823          	sd	a0,112(s2)
    80003342:	a839                	j	80003360 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80003344:	15048613          	addi	a2,s1,336
    80003348:	5c8c                	lw	a1,56(s1)
    8000334a:	00005517          	auipc	a0,0x5
    8000334e:	1e650513          	addi	a0,a0,486 # 80008530 <states.0+0x1e0>
    80003352:	ffffd097          	auipc	ra,0xffffd
    80003356:	2e4080e7          	jalr	740(ra) # 80000636 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000335a:	6cbc                	ld	a5,88(s1)
    8000335c:	577d                	li	a4,-1
    8000335e:	fbb8                	sd	a4,112(a5)
  }
}
    80003360:	60e2                	ld	ra,24(sp)
    80003362:	6442                	ld	s0,16(sp)
    80003364:	64a2                	ld	s1,8(sp)
    80003366:	6902                	ld	s2,0(sp)
    80003368:	6105                	addi	sp,sp,32
    8000336a:	8082                	ret

000000008000336c <sys_exit>:
#include "proc.h"
#include "riscv.h"
#include "spinlock.h"
#include "types.h"

uint64 sys_exit(void) {
    8000336c:	1101                	addi	sp,sp,-32
    8000336e:	ec06                	sd	ra,24(sp)
    80003370:	e822                	sd	s0,16(sp)
    80003372:	1000                	addi	s0,sp,32
  int n;
  if (argint(0, &n) < 0)
    80003374:	fec40593          	addi	a1,s0,-20
    80003378:	4501                	li	a0,0
    8000337a:	00000097          	auipc	ra,0x0
    8000337e:	f12080e7          	jalr	-238(ra) # 8000328c <argint>
    return -1;
    80003382:	57fd                	li	a5,-1
  if (argint(0, &n) < 0)
    80003384:	00054963          	bltz	a0,80003396 <sys_exit+0x2a>
  exit(n);
    80003388:	fec42503          	lw	a0,-20(s0)
    8000338c:	fffff097          	auipc	ra,0xfffff
    80003390:	3d0080e7          	jalr	976(ra) # 8000275c <exit>
  return 0; // not reached
    80003394:	4781                	li	a5,0
}
    80003396:	853e                	mv	a0,a5
    80003398:	60e2                	ld	ra,24(sp)
    8000339a:	6442                	ld	s0,16(sp)
    8000339c:	6105                	addi	sp,sp,32
    8000339e:	8082                	ret

00000000800033a0 <sys_getpid>:

uint64 sys_getpid(void) { return myproc()->pid; }
    800033a0:	1141                	addi	sp,sp,-16
    800033a2:	e406                	sd	ra,8(sp)
    800033a4:	e022                	sd	s0,0(sp)
    800033a6:	0800                	addi	s0,sp,16
    800033a8:	fffff097          	auipc	ra,0xfffff
    800033ac:	ce6080e7          	jalr	-794(ra) # 8000208e <myproc>
    800033b0:	5d08                	lw	a0,56(a0)
    800033b2:	60a2                	ld	ra,8(sp)
    800033b4:	6402                	ld	s0,0(sp)
    800033b6:	0141                	addi	sp,sp,16
    800033b8:	8082                	ret

00000000800033ba <sys_fork>:

uint64 sys_fork(void) { return fork(); }
    800033ba:	1141                	addi	sp,sp,-16
    800033bc:	e406                	sd	ra,8(sp)
    800033be:	e022                	sd	s0,0(sp)
    800033c0:	0800                	addi	s0,sp,16
    800033c2:	fffff097          	auipc	ra,0xfffff
    800033c6:	08c080e7          	jalr	140(ra) # 8000244e <fork>
    800033ca:	60a2                	ld	ra,8(sp)
    800033cc:	6402                	ld	s0,0(sp)
    800033ce:	0141                	addi	sp,sp,16
    800033d0:	8082                	ret

00000000800033d2 <sys_wait>:

uint64 sys_wait(void) {
    800033d2:	1101                	addi	sp,sp,-32
    800033d4:	ec06                	sd	ra,24(sp)
    800033d6:	e822                	sd	s0,16(sp)
    800033d8:	1000                	addi	s0,sp,32
  uint64 p;
  if (argaddr(0, &p) < 0)
    800033da:	fe840593          	addi	a1,s0,-24
    800033de:	4501                	li	a0,0
    800033e0:	00000097          	auipc	ra,0x0
    800033e4:	ece080e7          	jalr	-306(ra) # 800032ae <argaddr>
    800033e8:	87aa                	mv	a5,a0
    return -1;
    800033ea:	557d                	li	a0,-1
  if (argaddr(0, &p) < 0)
    800033ec:	0007c863          	bltz	a5,800033fc <sys_wait+0x2a>
  return wait(p);
    800033f0:	fe843503          	ld	a0,-24(s0)
    800033f4:	fffff097          	auipc	ra,0xfffff
    800033f8:	52c080e7          	jalr	1324(ra) # 80002920 <wait>
}
    800033fc:	60e2                	ld	ra,24(sp)
    800033fe:	6442                	ld	s0,16(sp)
    80003400:	6105                	addi	sp,sp,32
    80003402:	8082                	ret

0000000080003404 <sys_sbrk>:

uint64 sys_sbrk(void) {
    80003404:	7179                	addi	sp,sp,-48
    80003406:	f406                	sd	ra,40(sp)
    80003408:	f022                	sd	s0,32(sp)
    8000340a:	ec26                	sd	s1,24(sp)
    8000340c:	e84a                	sd	s2,16(sp)
    8000340e:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if (argint(0, &n) < 0)
    80003410:	fdc40593          	addi	a1,s0,-36
    80003414:	4501                	li	a0,0
    80003416:	00000097          	auipc	ra,0x0
    8000341a:	e76080e7          	jalr	-394(ra) # 8000328c <argint>
    8000341e:	87aa                	mv	a5,a0
    return -1;
    80003420:	557d                	li	a0,-1
  if (argint(0, &n) < 0)
    80003422:	0207c763          	bltz	a5,80003450 <sys_sbrk+0x4c>
  struct proc *p = myproc();
    80003426:	fffff097          	auipc	ra,0xfffff
    8000342a:	c68080e7          	jalr	-920(ra) # 8000208e <myproc>
    8000342e:	892a                	mv	s2,a0
  addr = p->sz;
    80003430:	6538                	ld	a4,72(a0)
    80003432:	0007049b          	sext.w	s1,a4
  p->sz += n;
    80003436:	fdc42783          	lw	a5,-36(s0)
    8000343a:	97ba                	add	a5,a5,a4
    8000343c:	e53c                	sd	a5,72(a0)
  if (p->sz >= MAXVA) {
    8000343e:	577d                	li	a4,-1
    80003440:	8369                	srli	a4,a4,0x1a
    80003442:	00f76d63          	bltu	a4,a5,8000345c <sys_sbrk+0x58>
    p->killed = 1;
    printf("user momry overflow");
    exit(-1);
  }
  if (n < 0) {
    80003446:	fdc42783          	lw	a5,-36(s0)
    8000344a:	0207c963          	bltz	a5,8000347c <sys_sbrk+0x78>
    uvmdealloc(p->pagetable, addr, p->sz);
  }
  return addr;
    8000344e:	8526                	mv	a0,s1
}
    80003450:	70a2                	ld	ra,40(sp)
    80003452:	7402                	ld	s0,32(sp)
    80003454:	64e2                	ld	s1,24(sp)
    80003456:	6942                	ld	s2,16(sp)
    80003458:	6145                	addi	sp,sp,48
    8000345a:	8082                	ret
    p->killed = 1;
    8000345c:	4785                	li	a5,1
    8000345e:	d91c                	sw	a5,48(a0)
    printf("user momry overflow");
    80003460:	00005517          	auipc	a0,0x5
    80003464:	1b850513          	addi	a0,a0,440 # 80008618 <syscalls+0xb0>
    80003468:	ffffd097          	auipc	ra,0xffffd
    8000346c:	1ce080e7          	jalr	462(ra) # 80000636 <printf>
    exit(-1);
    80003470:	557d                	li	a0,-1
    80003472:	fffff097          	auipc	ra,0xfffff
    80003476:	2ea080e7          	jalr	746(ra) # 8000275c <exit>
    8000347a:	b7f1                	j	80003446 <sys_sbrk+0x42>
    uvmdealloc(p->pagetable, addr, p->sz);
    8000347c:	04893603          	ld	a2,72(s2)
    80003480:	85a6                	mv	a1,s1
    80003482:	05093503          	ld	a0,80(s2)
    80003486:	ffffe097          	auipc	ra,0xffffe
    8000348a:	0b2080e7          	jalr	178(ra) # 80001538 <uvmdealloc>
    8000348e:	b7c1                	j	8000344e <sys_sbrk+0x4a>

0000000080003490 <sys_sleep>:

uint64 sys_sleep(void) {
    80003490:	7139                	addi	sp,sp,-64
    80003492:	fc06                	sd	ra,56(sp)
    80003494:	f822                	sd	s0,48(sp)
    80003496:	f426                	sd	s1,40(sp)
    80003498:	f04a                	sd	s2,32(sp)
    8000349a:	ec4e                	sd	s3,24(sp)
    8000349c:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
    8000349e:	fcc40593          	addi	a1,s0,-52
    800034a2:	4501                	li	a0,0
    800034a4:	00000097          	auipc	ra,0x0
    800034a8:	de8080e7          	jalr	-536(ra) # 8000328c <argint>
    return -1;
    800034ac:	57fd                	li	a5,-1
  if (argint(0, &n) < 0)
    800034ae:	06054563          	bltz	a0,80003518 <sys_sleep+0x88>
  acquire(&tickslock);
    800034b2:	00040517          	auipc	a0,0x40
    800034b6:	2c650513          	addi	a0,a0,710 # 80043778 <tickslock>
    800034ba:	ffffe097          	auipc	ra,0xffffe
    800034be:	880080e7          	jalr	-1920(ra) # 80000d3a <acquire>
  ticks0 = ticks;
    800034c2:	00006917          	auipc	s2,0x6
    800034c6:	b5e92903          	lw	s2,-1186(s2) # 80009020 <ticks>
  while (ticks - ticks0 < n) {
    800034ca:	fcc42783          	lw	a5,-52(s0)
    800034ce:	cf85                	beqz	a5,80003506 <sys_sleep+0x76>
    if (myproc()->killed) {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800034d0:	00040997          	auipc	s3,0x40
    800034d4:	2a898993          	addi	s3,s3,680 # 80043778 <tickslock>
    800034d8:	00006497          	auipc	s1,0x6
    800034dc:	b4848493          	addi	s1,s1,-1208 # 80009020 <ticks>
    if (myproc()->killed) {
    800034e0:	fffff097          	auipc	ra,0xfffff
    800034e4:	bae080e7          	jalr	-1106(ra) # 8000208e <myproc>
    800034e8:	591c                	lw	a5,48(a0)
    800034ea:	ef9d                	bnez	a5,80003528 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800034ec:	85ce                	mv	a1,s3
    800034ee:	8526                	mv	a0,s1
    800034f0:	fffff097          	auipc	ra,0xfffff
    800034f4:	3b2080e7          	jalr	946(ra) # 800028a2 <sleep>
  while (ticks - ticks0 < n) {
    800034f8:	409c                	lw	a5,0(s1)
    800034fa:	412787bb          	subw	a5,a5,s2
    800034fe:	fcc42703          	lw	a4,-52(s0)
    80003502:	fce7efe3          	bltu	a5,a4,800034e0 <sys_sleep+0x50>
  }
  release(&tickslock);
    80003506:	00040517          	auipc	a0,0x40
    8000350a:	27250513          	addi	a0,a0,626 # 80043778 <tickslock>
    8000350e:	ffffe097          	auipc	ra,0xffffe
    80003512:	8e0080e7          	jalr	-1824(ra) # 80000dee <release>
  return 0;
    80003516:	4781                	li	a5,0
}
    80003518:	853e                	mv	a0,a5
    8000351a:	70e2                	ld	ra,56(sp)
    8000351c:	7442                	ld	s0,48(sp)
    8000351e:	74a2                	ld	s1,40(sp)
    80003520:	7902                	ld	s2,32(sp)
    80003522:	69e2                	ld	s3,24(sp)
    80003524:	6121                	addi	sp,sp,64
    80003526:	8082                	ret
      release(&tickslock);
    80003528:	00040517          	auipc	a0,0x40
    8000352c:	25050513          	addi	a0,a0,592 # 80043778 <tickslock>
    80003530:	ffffe097          	auipc	ra,0xffffe
    80003534:	8be080e7          	jalr	-1858(ra) # 80000dee <release>
      return -1;
    80003538:	57fd                	li	a5,-1
    8000353a:	bff9                	j	80003518 <sys_sleep+0x88>

000000008000353c <sys_kill>:

uint64 sys_kill(void) {
    8000353c:	1101                	addi	sp,sp,-32
    8000353e:	ec06                	sd	ra,24(sp)
    80003540:	e822                	sd	s0,16(sp)
    80003542:	1000                	addi	s0,sp,32
  int pid;

  if (argint(0, &pid) < 0)
    80003544:	fec40593          	addi	a1,s0,-20
    80003548:	4501                	li	a0,0
    8000354a:	00000097          	auipc	ra,0x0
    8000354e:	d42080e7          	jalr	-702(ra) # 8000328c <argint>
    80003552:	87aa                	mv	a5,a0
    return -1;
    80003554:	557d                	li	a0,-1
  if (argint(0, &pid) < 0)
    80003556:	0007c863          	bltz	a5,80003566 <sys_kill+0x2a>
  return kill(pid);
    8000355a:	fec42503          	lw	a0,-20(s0)
    8000355e:	fffff097          	auipc	ra,0xfffff
    80003562:	52e080e7          	jalr	1326(ra) # 80002a8c <kill>
}
    80003566:	60e2                	ld	ra,24(sp)
    80003568:	6442                	ld	s0,16(sp)
    8000356a:	6105                	addi	sp,sp,32
    8000356c:	8082                	ret

000000008000356e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64 sys_uptime(void) {
    8000356e:	1101                	addi	sp,sp,-32
    80003570:	ec06                	sd	ra,24(sp)
    80003572:	e822                	sd	s0,16(sp)
    80003574:	e426                	sd	s1,8(sp)
    80003576:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80003578:	00040517          	auipc	a0,0x40
    8000357c:	20050513          	addi	a0,a0,512 # 80043778 <tickslock>
    80003580:	ffffd097          	auipc	ra,0xffffd
    80003584:	7ba080e7          	jalr	1978(ra) # 80000d3a <acquire>
  xticks = ticks;
    80003588:	00006497          	auipc	s1,0x6
    8000358c:	a984a483          	lw	s1,-1384(s1) # 80009020 <ticks>
  release(&tickslock);
    80003590:	00040517          	auipc	a0,0x40
    80003594:	1e850513          	addi	a0,a0,488 # 80043778 <tickslock>
    80003598:	ffffe097          	auipc	ra,0xffffe
    8000359c:	856080e7          	jalr	-1962(ra) # 80000dee <release>
  return xticks;
}
    800035a0:	02049513          	slli	a0,s1,0x20
    800035a4:	9101                	srli	a0,a0,0x20
    800035a6:	60e2                	ld	ra,24(sp)
    800035a8:	6442                	ld	s0,16(sp)
    800035aa:	64a2                	ld	s1,8(sp)
    800035ac:	6105                	addi	sp,sp,32
    800035ae:	8082                	ret

00000000800035b0 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800035b0:	7179                	addi	sp,sp,-48
    800035b2:	f406                	sd	ra,40(sp)
    800035b4:	f022                	sd	s0,32(sp)
    800035b6:	ec26                	sd	s1,24(sp)
    800035b8:	e84a                	sd	s2,16(sp)
    800035ba:	e44e                	sd	s3,8(sp)
    800035bc:	e052                	sd	s4,0(sp)
    800035be:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800035c0:	00005597          	auipc	a1,0x5
    800035c4:	07058593          	addi	a1,a1,112 # 80008630 <syscalls+0xc8>
    800035c8:	00040517          	auipc	a0,0x40
    800035cc:	1c850513          	addi	a0,a0,456 # 80043790 <bcache>
    800035d0:	ffffd097          	auipc	ra,0xffffd
    800035d4:	6da080e7          	jalr	1754(ra) # 80000caa <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800035d8:	00048797          	auipc	a5,0x48
    800035dc:	1b878793          	addi	a5,a5,440 # 8004b790 <bcache+0x8000>
    800035e0:	00048717          	auipc	a4,0x48
    800035e4:	41870713          	addi	a4,a4,1048 # 8004b9f8 <bcache+0x8268>
    800035e8:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800035ec:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800035f0:	00040497          	auipc	s1,0x40
    800035f4:	1b848493          	addi	s1,s1,440 # 800437a8 <bcache+0x18>
    b->next = bcache.head.next;
    800035f8:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800035fa:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800035fc:	00005a17          	auipc	s4,0x5
    80003600:	03ca0a13          	addi	s4,s4,60 # 80008638 <syscalls+0xd0>
    b->next = bcache.head.next;
    80003604:	2b893783          	ld	a5,696(s2)
    80003608:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000360a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000360e:	85d2                	mv	a1,s4
    80003610:	01048513          	addi	a0,s1,16
    80003614:	00001097          	auipc	ra,0x1
    80003618:	4b0080e7          	jalr	1200(ra) # 80004ac4 <initsleeplock>
    bcache.head.next->prev = b;
    8000361c:	2b893783          	ld	a5,696(s2)
    80003620:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003622:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003626:	45848493          	addi	s1,s1,1112
    8000362a:	fd349de3          	bne	s1,s3,80003604 <binit+0x54>
  }
}
    8000362e:	70a2                	ld	ra,40(sp)
    80003630:	7402                	ld	s0,32(sp)
    80003632:	64e2                	ld	s1,24(sp)
    80003634:	6942                	ld	s2,16(sp)
    80003636:	69a2                	ld	s3,8(sp)
    80003638:	6a02                	ld	s4,0(sp)
    8000363a:	6145                	addi	sp,sp,48
    8000363c:	8082                	ret

000000008000363e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000363e:	7179                	addi	sp,sp,-48
    80003640:	f406                	sd	ra,40(sp)
    80003642:	f022                	sd	s0,32(sp)
    80003644:	ec26                	sd	s1,24(sp)
    80003646:	e84a                	sd	s2,16(sp)
    80003648:	e44e                	sd	s3,8(sp)
    8000364a:	1800                	addi	s0,sp,48
    8000364c:	892a                	mv	s2,a0
    8000364e:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003650:	00040517          	auipc	a0,0x40
    80003654:	14050513          	addi	a0,a0,320 # 80043790 <bcache>
    80003658:	ffffd097          	auipc	ra,0xffffd
    8000365c:	6e2080e7          	jalr	1762(ra) # 80000d3a <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003660:	00048497          	auipc	s1,0x48
    80003664:	3e84b483          	ld	s1,1000(s1) # 8004ba48 <bcache+0x82b8>
    80003668:	00048797          	auipc	a5,0x48
    8000366c:	39078793          	addi	a5,a5,912 # 8004b9f8 <bcache+0x8268>
    80003670:	02f48f63          	beq	s1,a5,800036ae <bread+0x70>
    80003674:	873e                	mv	a4,a5
    80003676:	a021                	j	8000367e <bread+0x40>
    80003678:	68a4                	ld	s1,80(s1)
    8000367a:	02e48a63          	beq	s1,a4,800036ae <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000367e:	449c                	lw	a5,8(s1)
    80003680:	ff279ce3          	bne	a5,s2,80003678 <bread+0x3a>
    80003684:	44dc                	lw	a5,12(s1)
    80003686:	ff3799e3          	bne	a5,s3,80003678 <bread+0x3a>
      b->refcnt++;
    8000368a:	40bc                	lw	a5,64(s1)
    8000368c:	2785                	addiw	a5,a5,1
    8000368e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003690:	00040517          	auipc	a0,0x40
    80003694:	10050513          	addi	a0,a0,256 # 80043790 <bcache>
    80003698:	ffffd097          	auipc	ra,0xffffd
    8000369c:	756080e7          	jalr	1878(ra) # 80000dee <release>
      acquiresleep(&b->lock);
    800036a0:	01048513          	addi	a0,s1,16
    800036a4:	00001097          	auipc	ra,0x1
    800036a8:	45a080e7          	jalr	1114(ra) # 80004afe <acquiresleep>
      return b;
    800036ac:	a8b9                	j	8000370a <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800036ae:	00048497          	auipc	s1,0x48
    800036b2:	3924b483          	ld	s1,914(s1) # 8004ba40 <bcache+0x82b0>
    800036b6:	00048797          	auipc	a5,0x48
    800036ba:	34278793          	addi	a5,a5,834 # 8004b9f8 <bcache+0x8268>
    800036be:	00f48863          	beq	s1,a5,800036ce <bread+0x90>
    800036c2:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800036c4:	40bc                	lw	a5,64(s1)
    800036c6:	cf81                	beqz	a5,800036de <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800036c8:	64a4                	ld	s1,72(s1)
    800036ca:	fee49de3          	bne	s1,a4,800036c4 <bread+0x86>
  panic("bget: no buffers");
    800036ce:	00005517          	auipc	a0,0x5
    800036d2:	f7250513          	addi	a0,a0,-142 # 80008640 <syscalls+0xd8>
    800036d6:	ffffd097          	auipc	ra,0xffffd
    800036da:	f0e080e7          	jalr	-242(ra) # 800005e4 <panic>
      b->dev = dev;
    800036de:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800036e2:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800036e6:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800036ea:	4785                	li	a5,1
    800036ec:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800036ee:	00040517          	auipc	a0,0x40
    800036f2:	0a250513          	addi	a0,a0,162 # 80043790 <bcache>
    800036f6:	ffffd097          	auipc	ra,0xffffd
    800036fa:	6f8080e7          	jalr	1784(ra) # 80000dee <release>
      acquiresleep(&b->lock);
    800036fe:	01048513          	addi	a0,s1,16
    80003702:	00001097          	auipc	ra,0x1
    80003706:	3fc080e7          	jalr	1020(ra) # 80004afe <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000370a:	409c                	lw	a5,0(s1)
    8000370c:	cb89                	beqz	a5,8000371e <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000370e:	8526                	mv	a0,s1
    80003710:	70a2                	ld	ra,40(sp)
    80003712:	7402                	ld	s0,32(sp)
    80003714:	64e2                	ld	s1,24(sp)
    80003716:	6942                	ld	s2,16(sp)
    80003718:	69a2                	ld	s3,8(sp)
    8000371a:	6145                	addi	sp,sp,48
    8000371c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000371e:	4581                	li	a1,0
    80003720:	8526                	mv	a0,s1
    80003722:	00003097          	auipc	ra,0x3
    80003726:	f2a080e7          	jalr	-214(ra) # 8000664c <virtio_disk_rw>
    b->valid = 1;
    8000372a:	4785                	li	a5,1
    8000372c:	c09c                	sw	a5,0(s1)
  return b;
    8000372e:	b7c5                	j	8000370e <bread+0xd0>

0000000080003730 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003730:	1101                	addi	sp,sp,-32
    80003732:	ec06                	sd	ra,24(sp)
    80003734:	e822                	sd	s0,16(sp)
    80003736:	e426                	sd	s1,8(sp)
    80003738:	1000                	addi	s0,sp,32
    8000373a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000373c:	0541                	addi	a0,a0,16
    8000373e:	00001097          	auipc	ra,0x1
    80003742:	45a080e7          	jalr	1114(ra) # 80004b98 <holdingsleep>
    80003746:	cd01                	beqz	a0,8000375e <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003748:	4585                	li	a1,1
    8000374a:	8526                	mv	a0,s1
    8000374c:	00003097          	auipc	ra,0x3
    80003750:	f00080e7          	jalr	-256(ra) # 8000664c <virtio_disk_rw>
}
    80003754:	60e2                	ld	ra,24(sp)
    80003756:	6442                	ld	s0,16(sp)
    80003758:	64a2                	ld	s1,8(sp)
    8000375a:	6105                	addi	sp,sp,32
    8000375c:	8082                	ret
    panic("bwrite");
    8000375e:	00005517          	auipc	a0,0x5
    80003762:	efa50513          	addi	a0,a0,-262 # 80008658 <syscalls+0xf0>
    80003766:	ffffd097          	auipc	ra,0xffffd
    8000376a:	e7e080e7          	jalr	-386(ra) # 800005e4 <panic>

000000008000376e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000376e:	1101                	addi	sp,sp,-32
    80003770:	ec06                	sd	ra,24(sp)
    80003772:	e822                	sd	s0,16(sp)
    80003774:	e426                	sd	s1,8(sp)
    80003776:	e04a                	sd	s2,0(sp)
    80003778:	1000                	addi	s0,sp,32
    8000377a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000377c:	01050913          	addi	s2,a0,16
    80003780:	854a                	mv	a0,s2
    80003782:	00001097          	auipc	ra,0x1
    80003786:	416080e7          	jalr	1046(ra) # 80004b98 <holdingsleep>
    8000378a:	c92d                	beqz	a0,800037fc <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000378c:	854a                	mv	a0,s2
    8000378e:	00001097          	auipc	ra,0x1
    80003792:	3c6080e7          	jalr	966(ra) # 80004b54 <releasesleep>

  acquire(&bcache.lock);
    80003796:	00040517          	auipc	a0,0x40
    8000379a:	ffa50513          	addi	a0,a0,-6 # 80043790 <bcache>
    8000379e:	ffffd097          	auipc	ra,0xffffd
    800037a2:	59c080e7          	jalr	1436(ra) # 80000d3a <acquire>
  b->refcnt--;
    800037a6:	40bc                	lw	a5,64(s1)
    800037a8:	37fd                	addiw	a5,a5,-1
    800037aa:	0007871b          	sext.w	a4,a5
    800037ae:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800037b0:	eb05                	bnez	a4,800037e0 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800037b2:	68bc                	ld	a5,80(s1)
    800037b4:	64b8                	ld	a4,72(s1)
    800037b6:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800037b8:	64bc                	ld	a5,72(s1)
    800037ba:	68b8                	ld	a4,80(s1)
    800037bc:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800037be:	00048797          	auipc	a5,0x48
    800037c2:	fd278793          	addi	a5,a5,-46 # 8004b790 <bcache+0x8000>
    800037c6:	2b87b703          	ld	a4,696(a5)
    800037ca:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800037cc:	00048717          	auipc	a4,0x48
    800037d0:	22c70713          	addi	a4,a4,556 # 8004b9f8 <bcache+0x8268>
    800037d4:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800037d6:	2b87b703          	ld	a4,696(a5)
    800037da:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800037dc:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800037e0:	00040517          	auipc	a0,0x40
    800037e4:	fb050513          	addi	a0,a0,-80 # 80043790 <bcache>
    800037e8:	ffffd097          	auipc	ra,0xffffd
    800037ec:	606080e7          	jalr	1542(ra) # 80000dee <release>
}
    800037f0:	60e2                	ld	ra,24(sp)
    800037f2:	6442                	ld	s0,16(sp)
    800037f4:	64a2                	ld	s1,8(sp)
    800037f6:	6902                	ld	s2,0(sp)
    800037f8:	6105                	addi	sp,sp,32
    800037fa:	8082                	ret
    panic("brelse");
    800037fc:	00005517          	auipc	a0,0x5
    80003800:	e6450513          	addi	a0,a0,-412 # 80008660 <syscalls+0xf8>
    80003804:	ffffd097          	auipc	ra,0xffffd
    80003808:	de0080e7          	jalr	-544(ra) # 800005e4 <panic>

000000008000380c <bpin>:

void
bpin(struct buf *b) {
    8000380c:	1101                	addi	sp,sp,-32
    8000380e:	ec06                	sd	ra,24(sp)
    80003810:	e822                	sd	s0,16(sp)
    80003812:	e426                	sd	s1,8(sp)
    80003814:	1000                	addi	s0,sp,32
    80003816:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003818:	00040517          	auipc	a0,0x40
    8000381c:	f7850513          	addi	a0,a0,-136 # 80043790 <bcache>
    80003820:	ffffd097          	auipc	ra,0xffffd
    80003824:	51a080e7          	jalr	1306(ra) # 80000d3a <acquire>
  b->refcnt++;
    80003828:	40bc                	lw	a5,64(s1)
    8000382a:	2785                	addiw	a5,a5,1
    8000382c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000382e:	00040517          	auipc	a0,0x40
    80003832:	f6250513          	addi	a0,a0,-158 # 80043790 <bcache>
    80003836:	ffffd097          	auipc	ra,0xffffd
    8000383a:	5b8080e7          	jalr	1464(ra) # 80000dee <release>
}
    8000383e:	60e2                	ld	ra,24(sp)
    80003840:	6442                	ld	s0,16(sp)
    80003842:	64a2                	ld	s1,8(sp)
    80003844:	6105                	addi	sp,sp,32
    80003846:	8082                	ret

0000000080003848 <bunpin>:

void
bunpin(struct buf *b) {
    80003848:	1101                	addi	sp,sp,-32
    8000384a:	ec06                	sd	ra,24(sp)
    8000384c:	e822                	sd	s0,16(sp)
    8000384e:	e426                	sd	s1,8(sp)
    80003850:	1000                	addi	s0,sp,32
    80003852:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003854:	00040517          	auipc	a0,0x40
    80003858:	f3c50513          	addi	a0,a0,-196 # 80043790 <bcache>
    8000385c:	ffffd097          	auipc	ra,0xffffd
    80003860:	4de080e7          	jalr	1246(ra) # 80000d3a <acquire>
  b->refcnt--;
    80003864:	40bc                	lw	a5,64(s1)
    80003866:	37fd                	addiw	a5,a5,-1
    80003868:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000386a:	00040517          	auipc	a0,0x40
    8000386e:	f2650513          	addi	a0,a0,-218 # 80043790 <bcache>
    80003872:	ffffd097          	auipc	ra,0xffffd
    80003876:	57c080e7          	jalr	1404(ra) # 80000dee <release>
}
    8000387a:	60e2                	ld	ra,24(sp)
    8000387c:	6442                	ld	s0,16(sp)
    8000387e:	64a2                	ld	s1,8(sp)
    80003880:	6105                	addi	sp,sp,32
    80003882:	8082                	ret

0000000080003884 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003884:	1101                	addi	sp,sp,-32
    80003886:	ec06                	sd	ra,24(sp)
    80003888:	e822                	sd	s0,16(sp)
    8000388a:	e426                	sd	s1,8(sp)
    8000388c:	e04a                	sd	s2,0(sp)
    8000388e:	1000                	addi	s0,sp,32
    80003890:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003892:	00d5d59b          	srliw	a1,a1,0xd
    80003896:	00048797          	auipc	a5,0x48
    8000389a:	5d67a783          	lw	a5,1494(a5) # 8004be6c <sb+0x1c>
    8000389e:	9dbd                	addw	a1,a1,a5
    800038a0:	00000097          	auipc	ra,0x0
    800038a4:	d9e080e7          	jalr	-610(ra) # 8000363e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800038a8:	0074f713          	andi	a4,s1,7
    800038ac:	4785                	li	a5,1
    800038ae:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800038b2:	14ce                	slli	s1,s1,0x33
    800038b4:	90d9                	srli	s1,s1,0x36
    800038b6:	00950733          	add	a4,a0,s1
    800038ba:	05874703          	lbu	a4,88(a4)
    800038be:	00e7f6b3          	and	a3,a5,a4
    800038c2:	c69d                	beqz	a3,800038f0 <bfree+0x6c>
    800038c4:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800038c6:	94aa                	add	s1,s1,a0
    800038c8:	fff7c793          	not	a5,a5
    800038cc:	8ff9                	and	a5,a5,a4
    800038ce:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800038d2:	00001097          	auipc	ra,0x1
    800038d6:	104080e7          	jalr	260(ra) # 800049d6 <log_write>
  brelse(bp);
    800038da:	854a                	mv	a0,s2
    800038dc:	00000097          	auipc	ra,0x0
    800038e0:	e92080e7          	jalr	-366(ra) # 8000376e <brelse>
}
    800038e4:	60e2                	ld	ra,24(sp)
    800038e6:	6442                	ld	s0,16(sp)
    800038e8:	64a2                	ld	s1,8(sp)
    800038ea:	6902                	ld	s2,0(sp)
    800038ec:	6105                	addi	sp,sp,32
    800038ee:	8082                	ret
    panic("freeing free block");
    800038f0:	00005517          	auipc	a0,0x5
    800038f4:	d7850513          	addi	a0,a0,-648 # 80008668 <syscalls+0x100>
    800038f8:	ffffd097          	auipc	ra,0xffffd
    800038fc:	cec080e7          	jalr	-788(ra) # 800005e4 <panic>

0000000080003900 <balloc>:
{
    80003900:	711d                	addi	sp,sp,-96
    80003902:	ec86                	sd	ra,88(sp)
    80003904:	e8a2                	sd	s0,80(sp)
    80003906:	e4a6                	sd	s1,72(sp)
    80003908:	e0ca                	sd	s2,64(sp)
    8000390a:	fc4e                	sd	s3,56(sp)
    8000390c:	f852                	sd	s4,48(sp)
    8000390e:	f456                	sd	s5,40(sp)
    80003910:	f05a                	sd	s6,32(sp)
    80003912:	ec5e                	sd	s7,24(sp)
    80003914:	e862                	sd	s8,16(sp)
    80003916:	e466                	sd	s9,8(sp)
    80003918:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000391a:	00048797          	auipc	a5,0x48
    8000391e:	53a7a783          	lw	a5,1338(a5) # 8004be54 <sb+0x4>
    80003922:	cbd1                	beqz	a5,800039b6 <balloc+0xb6>
    80003924:	8baa                	mv	s7,a0
    80003926:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003928:	00048b17          	auipc	s6,0x48
    8000392c:	528b0b13          	addi	s6,s6,1320 # 8004be50 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003930:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003932:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003934:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003936:	6c89                	lui	s9,0x2
    80003938:	a831                	j	80003954 <balloc+0x54>
    brelse(bp);
    8000393a:	854a                	mv	a0,s2
    8000393c:	00000097          	auipc	ra,0x0
    80003940:	e32080e7          	jalr	-462(ra) # 8000376e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003944:	015c87bb          	addw	a5,s9,s5
    80003948:	00078a9b          	sext.w	s5,a5
    8000394c:	004b2703          	lw	a4,4(s6)
    80003950:	06eaf363          	bgeu	s5,a4,800039b6 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80003954:	41fad79b          	sraiw	a5,s5,0x1f
    80003958:	0137d79b          	srliw	a5,a5,0x13
    8000395c:	015787bb          	addw	a5,a5,s5
    80003960:	40d7d79b          	sraiw	a5,a5,0xd
    80003964:	01cb2583          	lw	a1,28(s6)
    80003968:	9dbd                	addw	a1,a1,a5
    8000396a:	855e                	mv	a0,s7
    8000396c:	00000097          	auipc	ra,0x0
    80003970:	cd2080e7          	jalr	-814(ra) # 8000363e <bread>
    80003974:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003976:	004b2503          	lw	a0,4(s6)
    8000397a:	000a849b          	sext.w	s1,s5
    8000397e:	8662                	mv	a2,s8
    80003980:	faa4fde3          	bgeu	s1,a0,8000393a <balloc+0x3a>
      m = 1 << (bi % 8);
    80003984:	41f6579b          	sraiw	a5,a2,0x1f
    80003988:	01d7d69b          	srliw	a3,a5,0x1d
    8000398c:	00c6873b          	addw	a4,a3,a2
    80003990:	00777793          	andi	a5,a4,7
    80003994:	9f95                	subw	a5,a5,a3
    80003996:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000399a:	4037571b          	sraiw	a4,a4,0x3
    8000399e:	00e906b3          	add	a3,s2,a4
    800039a2:	0586c683          	lbu	a3,88(a3)
    800039a6:	00d7f5b3          	and	a1,a5,a3
    800039aa:	cd91                	beqz	a1,800039c6 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800039ac:	2605                	addiw	a2,a2,1
    800039ae:	2485                	addiw	s1,s1,1
    800039b0:	fd4618e3          	bne	a2,s4,80003980 <balloc+0x80>
    800039b4:	b759                	j	8000393a <balloc+0x3a>
  panic("balloc: out of blocks");
    800039b6:	00005517          	auipc	a0,0x5
    800039ba:	cca50513          	addi	a0,a0,-822 # 80008680 <syscalls+0x118>
    800039be:	ffffd097          	auipc	ra,0xffffd
    800039c2:	c26080e7          	jalr	-986(ra) # 800005e4 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800039c6:	974a                	add	a4,a4,s2
    800039c8:	8fd5                	or	a5,a5,a3
    800039ca:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800039ce:	854a                	mv	a0,s2
    800039d0:	00001097          	auipc	ra,0x1
    800039d4:	006080e7          	jalr	6(ra) # 800049d6 <log_write>
        brelse(bp);
    800039d8:	854a                	mv	a0,s2
    800039da:	00000097          	auipc	ra,0x0
    800039de:	d94080e7          	jalr	-620(ra) # 8000376e <brelse>
  bp = bread(dev, bno);
    800039e2:	85a6                	mv	a1,s1
    800039e4:	855e                	mv	a0,s7
    800039e6:	00000097          	auipc	ra,0x0
    800039ea:	c58080e7          	jalr	-936(ra) # 8000363e <bread>
    800039ee:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800039f0:	40000613          	li	a2,1024
    800039f4:	4581                	li	a1,0
    800039f6:	05850513          	addi	a0,a0,88
    800039fa:	ffffd097          	auipc	ra,0xffffd
    800039fe:	43c080e7          	jalr	1084(ra) # 80000e36 <memset>
  log_write(bp);
    80003a02:	854a                	mv	a0,s2
    80003a04:	00001097          	auipc	ra,0x1
    80003a08:	fd2080e7          	jalr	-46(ra) # 800049d6 <log_write>
  brelse(bp);
    80003a0c:	854a                	mv	a0,s2
    80003a0e:	00000097          	auipc	ra,0x0
    80003a12:	d60080e7          	jalr	-672(ra) # 8000376e <brelse>
}
    80003a16:	8526                	mv	a0,s1
    80003a18:	60e6                	ld	ra,88(sp)
    80003a1a:	6446                	ld	s0,80(sp)
    80003a1c:	64a6                	ld	s1,72(sp)
    80003a1e:	6906                	ld	s2,64(sp)
    80003a20:	79e2                	ld	s3,56(sp)
    80003a22:	7a42                	ld	s4,48(sp)
    80003a24:	7aa2                	ld	s5,40(sp)
    80003a26:	7b02                	ld	s6,32(sp)
    80003a28:	6be2                	ld	s7,24(sp)
    80003a2a:	6c42                	ld	s8,16(sp)
    80003a2c:	6ca2                	ld	s9,8(sp)
    80003a2e:	6125                	addi	sp,sp,96
    80003a30:	8082                	ret

0000000080003a32 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80003a32:	7179                	addi	sp,sp,-48
    80003a34:	f406                	sd	ra,40(sp)
    80003a36:	f022                	sd	s0,32(sp)
    80003a38:	ec26                	sd	s1,24(sp)
    80003a3a:	e84a                	sd	s2,16(sp)
    80003a3c:	e44e                	sd	s3,8(sp)
    80003a3e:	e052                	sd	s4,0(sp)
    80003a40:	1800                	addi	s0,sp,48
    80003a42:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003a44:	47ad                	li	a5,11
    80003a46:	04b7fe63          	bgeu	a5,a1,80003aa2 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80003a4a:	ff45849b          	addiw	s1,a1,-12
    80003a4e:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003a52:	0ff00793          	li	a5,255
    80003a56:	0ae7e363          	bltu	a5,a4,80003afc <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80003a5a:	08052583          	lw	a1,128(a0)
    80003a5e:	c5ad                	beqz	a1,80003ac8 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80003a60:	00092503          	lw	a0,0(s2)
    80003a64:	00000097          	auipc	ra,0x0
    80003a68:	bda080e7          	jalr	-1062(ra) # 8000363e <bread>
    80003a6c:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003a6e:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003a72:	02049593          	slli	a1,s1,0x20
    80003a76:	9181                	srli	a1,a1,0x20
    80003a78:	058a                	slli	a1,a1,0x2
    80003a7a:	00b784b3          	add	s1,a5,a1
    80003a7e:	0004a983          	lw	s3,0(s1)
    80003a82:	04098d63          	beqz	s3,80003adc <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80003a86:	8552                	mv	a0,s4
    80003a88:	00000097          	auipc	ra,0x0
    80003a8c:	ce6080e7          	jalr	-794(ra) # 8000376e <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003a90:	854e                	mv	a0,s3
    80003a92:	70a2                	ld	ra,40(sp)
    80003a94:	7402                	ld	s0,32(sp)
    80003a96:	64e2                	ld	s1,24(sp)
    80003a98:	6942                	ld	s2,16(sp)
    80003a9a:	69a2                	ld	s3,8(sp)
    80003a9c:	6a02                	ld	s4,0(sp)
    80003a9e:	6145                	addi	sp,sp,48
    80003aa0:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80003aa2:	02059493          	slli	s1,a1,0x20
    80003aa6:	9081                	srli	s1,s1,0x20
    80003aa8:	048a                	slli	s1,s1,0x2
    80003aaa:	94aa                	add	s1,s1,a0
    80003aac:	0504a983          	lw	s3,80(s1)
    80003ab0:	fe0990e3          	bnez	s3,80003a90 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80003ab4:	4108                	lw	a0,0(a0)
    80003ab6:	00000097          	auipc	ra,0x0
    80003aba:	e4a080e7          	jalr	-438(ra) # 80003900 <balloc>
    80003abe:	0005099b          	sext.w	s3,a0
    80003ac2:	0534a823          	sw	s3,80(s1)
    80003ac6:	b7e9                	j	80003a90 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80003ac8:	4108                	lw	a0,0(a0)
    80003aca:	00000097          	auipc	ra,0x0
    80003ace:	e36080e7          	jalr	-458(ra) # 80003900 <balloc>
    80003ad2:	0005059b          	sext.w	a1,a0
    80003ad6:	08b92023          	sw	a1,128(s2)
    80003ada:	b759                	j	80003a60 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80003adc:	00092503          	lw	a0,0(s2)
    80003ae0:	00000097          	auipc	ra,0x0
    80003ae4:	e20080e7          	jalr	-480(ra) # 80003900 <balloc>
    80003ae8:	0005099b          	sext.w	s3,a0
    80003aec:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80003af0:	8552                	mv	a0,s4
    80003af2:	00001097          	auipc	ra,0x1
    80003af6:	ee4080e7          	jalr	-284(ra) # 800049d6 <log_write>
    80003afa:	b771                	j	80003a86 <bmap+0x54>
  panic("bmap: out of range");
    80003afc:	00005517          	auipc	a0,0x5
    80003b00:	b9c50513          	addi	a0,a0,-1124 # 80008698 <syscalls+0x130>
    80003b04:	ffffd097          	auipc	ra,0xffffd
    80003b08:	ae0080e7          	jalr	-1312(ra) # 800005e4 <panic>

0000000080003b0c <iget>:
{
    80003b0c:	7179                	addi	sp,sp,-48
    80003b0e:	f406                	sd	ra,40(sp)
    80003b10:	f022                	sd	s0,32(sp)
    80003b12:	ec26                	sd	s1,24(sp)
    80003b14:	e84a                	sd	s2,16(sp)
    80003b16:	e44e                	sd	s3,8(sp)
    80003b18:	e052                	sd	s4,0(sp)
    80003b1a:	1800                	addi	s0,sp,48
    80003b1c:	89aa                	mv	s3,a0
    80003b1e:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    80003b20:	00048517          	auipc	a0,0x48
    80003b24:	35050513          	addi	a0,a0,848 # 8004be70 <icache>
    80003b28:	ffffd097          	auipc	ra,0xffffd
    80003b2c:	212080e7          	jalr	530(ra) # 80000d3a <acquire>
  empty = 0;
    80003b30:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    80003b32:	00048497          	auipc	s1,0x48
    80003b36:	35648493          	addi	s1,s1,854 # 8004be88 <icache+0x18>
    80003b3a:	0004a697          	auipc	a3,0x4a
    80003b3e:	dde68693          	addi	a3,a3,-546 # 8004d918 <log>
    80003b42:	a039                	j	80003b50 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003b44:	02090b63          	beqz	s2,80003b7a <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    80003b48:	08848493          	addi	s1,s1,136
    80003b4c:	02d48a63          	beq	s1,a3,80003b80 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003b50:	449c                	lw	a5,8(s1)
    80003b52:	fef059e3          	blez	a5,80003b44 <iget+0x38>
    80003b56:	4098                	lw	a4,0(s1)
    80003b58:	ff3716e3          	bne	a4,s3,80003b44 <iget+0x38>
    80003b5c:	40d8                	lw	a4,4(s1)
    80003b5e:	ff4713e3          	bne	a4,s4,80003b44 <iget+0x38>
      ip->ref++;
    80003b62:	2785                	addiw	a5,a5,1
    80003b64:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    80003b66:	00048517          	auipc	a0,0x48
    80003b6a:	30a50513          	addi	a0,a0,778 # 8004be70 <icache>
    80003b6e:	ffffd097          	auipc	ra,0xffffd
    80003b72:	280080e7          	jalr	640(ra) # 80000dee <release>
      return ip;
    80003b76:	8926                	mv	s2,s1
    80003b78:	a03d                	j	80003ba6 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003b7a:	f7f9                	bnez	a5,80003b48 <iget+0x3c>
    80003b7c:	8926                	mv	s2,s1
    80003b7e:	b7e9                	j	80003b48 <iget+0x3c>
  if(empty == 0)
    80003b80:	02090c63          	beqz	s2,80003bb8 <iget+0xac>
  ip->dev = dev;
    80003b84:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003b88:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003b8c:	4785                	li	a5,1
    80003b8e:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003b92:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    80003b96:	00048517          	auipc	a0,0x48
    80003b9a:	2da50513          	addi	a0,a0,730 # 8004be70 <icache>
    80003b9e:	ffffd097          	auipc	ra,0xffffd
    80003ba2:	250080e7          	jalr	592(ra) # 80000dee <release>
}
    80003ba6:	854a                	mv	a0,s2
    80003ba8:	70a2                	ld	ra,40(sp)
    80003baa:	7402                	ld	s0,32(sp)
    80003bac:	64e2                	ld	s1,24(sp)
    80003bae:	6942                	ld	s2,16(sp)
    80003bb0:	69a2                	ld	s3,8(sp)
    80003bb2:	6a02                	ld	s4,0(sp)
    80003bb4:	6145                	addi	sp,sp,48
    80003bb6:	8082                	ret
    panic("iget: no inodes");
    80003bb8:	00005517          	auipc	a0,0x5
    80003bbc:	af850513          	addi	a0,a0,-1288 # 800086b0 <syscalls+0x148>
    80003bc0:	ffffd097          	auipc	ra,0xffffd
    80003bc4:	a24080e7          	jalr	-1500(ra) # 800005e4 <panic>

0000000080003bc8 <fsinit>:
fsinit(int dev) {
    80003bc8:	7179                	addi	sp,sp,-48
    80003bca:	f406                	sd	ra,40(sp)
    80003bcc:	f022                	sd	s0,32(sp)
    80003bce:	ec26                	sd	s1,24(sp)
    80003bd0:	e84a                	sd	s2,16(sp)
    80003bd2:	e44e                	sd	s3,8(sp)
    80003bd4:	1800                	addi	s0,sp,48
    80003bd6:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003bd8:	4585                	li	a1,1
    80003bda:	00000097          	auipc	ra,0x0
    80003bde:	a64080e7          	jalr	-1436(ra) # 8000363e <bread>
    80003be2:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003be4:	00048997          	auipc	s3,0x48
    80003be8:	26c98993          	addi	s3,s3,620 # 8004be50 <sb>
    80003bec:	02000613          	li	a2,32
    80003bf0:	05850593          	addi	a1,a0,88
    80003bf4:	854e                	mv	a0,s3
    80003bf6:	ffffd097          	auipc	ra,0xffffd
    80003bfa:	29c080e7          	jalr	668(ra) # 80000e92 <memmove>
  brelse(bp);
    80003bfe:	8526                	mv	a0,s1
    80003c00:	00000097          	auipc	ra,0x0
    80003c04:	b6e080e7          	jalr	-1170(ra) # 8000376e <brelse>
  if(sb.magic != FSMAGIC)
    80003c08:	0009a703          	lw	a4,0(s3)
    80003c0c:	102037b7          	lui	a5,0x10203
    80003c10:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003c14:	02f71263          	bne	a4,a5,80003c38 <fsinit+0x70>
  initlog(dev, &sb);
    80003c18:	00048597          	auipc	a1,0x48
    80003c1c:	23858593          	addi	a1,a1,568 # 8004be50 <sb>
    80003c20:	854a                	mv	a0,s2
    80003c22:	00001097          	auipc	ra,0x1
    80003c26:	b3c080e7          	jalr	-1220(ra) # 8000475e <initlog>
}
    80003c2a:	70a2                	ld	ra,40(sp)
    80003c2c:	7402                	ld	s0,32(sp)
    80003c2e:	64e2                	ld	s1,24(sp)
    80003c30:	6942                	ld	s2,16(sp)
    80003c32:	69a2                	ld	s3,8(sp)
    80003c34:	6145                	addi	sp,sp,48
    80003c36:	8082                	ret
    panic("invalid file system");
    80003c38:	00005517          	auipc	a0,0x5
    80003c3c:	a8850513          	addi	a0,a0,-1400 # 800086c0 <syscalls+0x158>
    80003c40:	ffffd097          	auipc	ra,0xffffd
    80003c44:	9a4080e7          	jalr	-1628(ra) # 800005e4 <panic>

0000000080003c48 <iinit>:
{
    80003c48:	7179                	addi	sp,sp,-48
    80003c4a:	f406                	sd	ra,40(sp)
    80003c4c:	f022                	sd	s0,32(sp)
    80003c4e:	ec26                	sd	s1,24(sp)
    80003c50:	e84a                	sd	s2,16(sp)
    80003c52:	e44e                	sd	s3,8(sp)
    80003c54:	1800                	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    80003c56:	00005597          	auipc	a1,0x5
    80003c5a:	a8258593          	addi	a1,a1,-1406 # 800086d8 <syscalls+0x170>
    80003c5e:	00048517          	auipc	a0,0x48
    80003c62:	21250513          	addi	a0,a0,530 # 8004be70 <icache>
    80003c66:	ffffd097          	auipc	ra,0xffffd
    80003c6a:	044080e7          	jalr	68(ra) # 80000caa <initlock>
  for(i = 0; i < NINODE; i++) {
    80003c6e:	00048497          	auipc	s1,0x48
    80003c72:	22a48493          	addi	s1,s1,554 # 8004be98 <icache+0x28>
    80003c76:	0004a997          	auipc	s3,0x4a
    80003c7a:	cb298993          	addi	s3,s3,-846 # 8004d928 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    80003c7e:	00005917          	auipc	s2,0x5
    80003c82:	a6290913          	addi	s2,s2,-1438 # 800086e0 <syscalls+0x178>
    80003c86:	85ca                	mv	a1,s2
    80003c88:	8526                	mv	a0,s1
    80003c8a:	00001097          	auipc	ra,0x1
    80003c8e:	e3a080e7          	jalr	-454(ra) # 80004ac4 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003c92:	08848493          	addi	s1,s1,136
    80003c96:	ff3498e3          	bne	s1,s3,80003c86 <iinit+0x3e>
}
    80003c9a:	70a2                	ld	ra,40(sp)
    80003c9c:	7402                	ld	s0,32(sp)
    80003c9e:	64e2                	ld	s1,24(sp)
    80003ca0:	6942                	ld	s2,16(sp)
    80003ca2:	69a2                	ld	s3,8(sp)
    80003ca4:	6145                	addi	sp,sp,48
    80003ca6:	8082                	ret

0000000080003ca8 <ialloc>:
{
    80003ca8:	715d                	addi	sp,sp,-80
    80003caa:	e486                	sd	ra,72(sp)
    80003cac:	e0a2                	sd	s0,64(sp)
    80003cae:	fc26                	sd	s1,56(sp)
    80003cb0:	f84a                	sd	s2,48(sp)
    80003cb2:	f44e                	sd	s3,40(sp)
    80003cb4:	f052                	sd	s4,32(sp)
    80003cb6:	ec56                	sd	s5,24(sp)
    80003cb8:	e85a                	sd	s6,16(sp)
    80003cba:	e45e                	sd	s7,8(sp)
    80003cbc:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003cbe:	00048717          	auipc	a4,0x48
    80003cc2:	19e72703          	lw	a4,414(a4) # 8004be5c <sb+0xc>
    80003cc6:	4785                	li	a5,1
    80003cc8:	04e7fa63          	bgeu	a5,a4,80003d1c <ialloc+0x74>
    80003ccc:	8aaa                	mv	s5,a0
    80003cce:	8bae                	mv	s7,a1
    80003cd0:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003cd2:	00048a17          	auipc	s4,0x48
    80003cd6:	17ea0a13          	addi	s4,s4,382 # 8004be50 <sb>
    80003cda:	00048b1b          	sext.w	s6,s1
    80003cde:	0044d793          	srli	a5,s1,0x4
    80003ce2:	018a2583          	lw	a1,24(s4)
    80003ce6:	9dbd                	addw	a1,a1,a5
    80003ce8:	8556                	mv	a0,s5
    80003cea:	00000097          	auipc	ra,0x0
    80003cee:	954080e7          	jalr	-1708(ra) # 8000363e <bread>
    80003cf2:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003cf4:	05850993          	addi	s3,a0,88
    80003cf8:	00f4f793          	andi	a5,s1,15
    80003cfc:	079a                	slli	a5,a5,0x6
    80003cfe:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003d00:	00099783          	lh	a5,0(s3)
    80003d04:	c785                	beqz	a5,80003d2c <ialloc+0x84>
    brelse(bp);
    80003d06:	00000097          	auipc	ra,0x0
    80003d0a:	a68080e7          	jalr	-1432(ra) # 8000376e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003d0e:	0485                	addi	s1,s1,1
    80003d10:	00ca2703          	lw	a4,12(s4)
    80003d14:	0004879b          	sext.w	a5,s1
    80003d18:	fce7e1e3          	bltu	a5,a4,80003cda <ialloc+0x32>
  panic("ialloc: no inodes");
    80003d1c:	00005517          	auipc	a0,0x5
    80003d20:	9cc50513          	addi	a0,a0,-1588 # 800086e8 <syscalls+0x180>
    80003d24:	ffffd097          	auipc	ra,0xffffd
    80003d28:	8c0080e7          	jalr	-1856(ra) # 800005e4 <panic>
      memset(dip, 0, sizeof(*dip));
    80003d2c:	04000613          	li	a2,64
    80003d30:	4581                	li	a1,0
    80003d32:	854e                	mv	a0,s3
    80003d34:	ffffd097          	auipc	ra,0xffffd
    80003d38:	102080e7          	jalr	258(ra) # 80000e36 <memset>
      dip->type = type;
    80003d3c:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003d40:	854a                	mv	a0,s2
    80003d42:	00001097          	auipc	ra,0x1
    80003d46:	c94080e7          	jalr	-876(ra) # 800049d6 <log_write>
      brelse(bp);
    80003d4a:	854a                	mv	a0,s2
    80003d4c:	00000097          	auipc	ra,0x0
    80003d50:	a22080e7          	jalr	-1502(ra) # 8000376e <brelse>
      return iget(dev, inum);
    80003d54:	85da                	mv	a1,s6
    80003d56:	8556                	mv	a0,s5
    80003d58:	00000097          	auipc	ra,0x0
    80003d5c:	db4080e7          	jalr	-588(ra) # 80003b0c <iget>
}
    80003d60:	60a6                	ld	ra,72(sp)
    80003d62:	6406                	ld	s0,64(sp)
    80003d64:	74e2                	ld	s1,56(sp)
    80003d66:	7942                	ld	s2,48(sp)
    80003d68:	79a2                	ld	s3,40(sp)
    80003d6a:	7a02                	ld	s4,32(sp)
    80003d6c:	6ae2                	ld	s5,24(sp)
    80003d6e:	6b42                	ld	s6,16(sp)
    80003d70:	6ba2                	ld	s7,8(sp)
    80003d72:	6161                	addi	sp,sp,80
    80003d74:	8082                	ret

0000000080003d76 <iupdate>:
{
    80003d76:	1101                	addi	sp,sp,-32
    80003d78:	ec06                	sd	ra,24(sp)
    80003d7a:	e822                	sd	s0,16(sp)
    80003d7c:	e426                	sd	s1,8(sp)
    80003d7e:	e04a                	sd	s2,0(sp)
    80003d80:	1000                	addi	s0,sp,32
    80003d82:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003d84:	415c                	lw	a5,4(a0)
    80003d86:	0047d79b          	srliw	a5,a5,0x4
    80003d8a:	00048597          	auipc	a1,0x48
    80003d8e:	0de5a583          	lw	a1,222(a1) # 8004be68 <sb+0x18>
    80003d92:	9dbd                	addw	a1,a1,a5
    80003d94:	4108                	lw	a0,0(a0)
    80003d96:	00000097          	auipc	ra,0x0
    80003d9a:	8a8080e7          	jalr	-1880(ra) # 8000363e <bread>
    80003d9e:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003da0:	05850793          	addi	a5,a0,88
    80003da4:	40c8                	lw	a0,4(s1)
    80003da6:	893d                	andi	a0,a0,15
    80003da8:	051a                	slli	a0,a0,0x6
    80003daa:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003dac:	04449703          	lh	a4,68(s1)
    80003db0:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80003db4:	04649703          	lh	a4,70(s1)
    80003db8:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003dbc:	04849703          	lh	a4,72(s1)
    80003dc0:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80003dc4:	04a49703          	lh	a4,74(s1)
    80003dc8:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80003dcc:	44f8                	lw	a4,76(s1)
    80003dce:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003dd0:	03400613          	li	a2,52
    80003dd4:	05048593          	addi	a1,s1,80
    80003dd8:	0531                	addi	a0,a0,12
    80003dda:	ffffd097          	auipc	ra,0xffffd
    80003dde:	0b8080e7          	jalr	184(ra) # 80000e92 <memmove>
  log_write(bp);
    80003de2:	854a                	mv	a0,s2
    80003de4:	00001097          	auipc	ra,0x1
    80003de8:	bf2080e7          	jalr	-1038(ra) # 800049d6 <log_write>
  brelse(bp);
    80003dec:	854a                	mv	a0,s2
    80003dee:	00000097          	auipc	ra,0x0
    80003df2:	980080e7          	jalr	-1664(ra) # 8000376e <brelse>
}
    80003df6:	60e2                	ld	ra,24(sp)
    80003df8:	6442                	ld	s0,16(sp)
    80003dfa:	64a2                	ld	s1,8(sp)
    80003dfc:	6902                	ld	s2,0(sp)
    80003dfe:	6105                	addi	sp,sp,32
    80003e00:	8082                	ret

0000000080003e02 <idup>:
{
    80003e02:	1101                	addi	sp,sp,-32
    80003e04:	ec06                	sd	ra,24(sp)
    80003e06:	e822                	sd	s0,16(sp)
    80003e08:	e426                	sd	s1,8(sp)
    80003e0a:	1000                	addi	s0,sp,32
    80003e0c:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003e0e:	00048517          	auipc	a0,0x48
    80003e12:	06250513          	addi	a0,a0,98 # 8004be70 <icache>
    80003e16:	ffffd097          	auipc	ra,0xffffd
    80003e1a:	f24080e7          	jalr	-220(ra) # 80000d3a <acquire>
  ip->ref++;
    80003e1e:	449c                	lw	a5,8(s1)
    80003e20:	2785                	addiw	a5,a5,1
    80003e22:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003e24:	00048517          	auipc	a0,0x48
    80003e28:	04c50513          	addi	a0,a0,76 # 8004be70 <icache>
    80003e2c:	ffffd097          	auipc	ra,0xffffd
    80003e30:	fc2080e7          	jalr	-62(ra) # 80000dee <release>
}
    80003e34:	8526                	mv	a0,s1
    80003e36:	60e2                	ld	ra,24(sp)
    80003e38:	6442                	ld	s0,16(sp)
    80003e3a:	64a2                	ld	s1,8(sp)
    80003e3c:	6105                	addi	sp,sp,32
    80003e3e:	8082                	ret

0000000080003e40 <ilock>:
{
    80003e40:	1101                	addi	sp,sp,-32
    80003e42:	ec06                	sd	ra,24(sp)
    80003e44:	e822                	sd	s0,16(sp)
    80003e46:	e426                	sd	s1,8(sp)
    80003e48:	e04a                	sd	s2,0(sp)
    80003e4a:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003e4c:	c115                	beqz	a0,80003e70 <ilock+0x30>
    80003e4e:	84aa                	mv	s1,a0
    80003e50:	451c                	lw	a5,8(a0)
    80003e52:	00f05f63          	blez	a5,80003e70 <ilock+0x30>
  acquiresleep(&ip->lock);
    80003e56:	0541                	addi	a0,a0,16
    80003e58:	00001097          	auipc	ra,0x1
    80003e5c:	ca6080e7          	jalr	-858(ra) # 80004afe <acquiresleep>
  if(ip->valid == 0){
    80003e60:	40bc                	lw	a5,64(s1)
    80003e62:	cf99                	beqz	a5,80003e80 <ilock+0x40>
}
    80003e64:	60e2                	ld	ra,24(sp)
    80003e66:	6442                	ld	s0,16(sp)
    80003e68:	64a2                	ld	s1,8(sp)
    80003e6a:	6902                	ld	s2,0(sp)
    80003e6c:	6105                	addi	sp,sp,32
    80003e6e:	8082                	ret
    panic("ilock");
    80003e70:	00005517          	auipc	a0,0x5
    80003e74:	89050513          	addi	a0,a0,-1904 # 80008700 <syscalls+0x198>
    80003e78:	ffffc097          	auipc	ra,0xffffc
    80003e7c:	76c080e7          	jalr	1900(ra) # 800005e4 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003e80:	40dc                	lw	a5,4(s1)
    80003e82:	0047d79b          	srliw	a5,a5,0x4
    80003e86:	00048597          	auipc	a1,0x48
    80003e8a:	fe25a583          	lw	a1,-30(a1) # 8004be68 <sb+0x18>
    80003e8e:	9dbd                	addw	a1,a1,a5
    80003e90:	4088                	lw	a0,0(s1)
    80003e92:	fffff097          	auipc	ra,0xfffff
    80003e96:	7ac080e7          	jalr	1964(ra) # 8000363e <bread>
    80003e9a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003e9c:	05850593          	addi	a1,a0,88
    80003ea0:	40dc                	lw	a5,4(s1)
    80003ea2:	8bbd                	andi	a5,a5,15
    80003ea4:	079a                	slli	a5,a5,0x6
    80003ea6:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003ea8:	00059783          	lh	a5,0(a1)
    80003eac:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003eb0:	00259783          	lh	a5,2(a1)
    80003eb4:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003eb8:	00459783          	lh	a5,4(a1)
    80003ebc:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003ec0:	00659783          	lh	a5,6(a1)
    80003ec4:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003ec8:	459c                	lw	a5,8(a1)
    80003eca:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003ecc:	03400613          	li	a2,52
    80003ed0:	05b1                	addi	a1,a1,12
    80003ed2:	05048513          	addi	a0,s1,80
    80003ed6:	ffffd097          	auipc	ra,0xffffd
    80003eda:	fbc080e7          	jalr	-68(ra) # 80000e92 <memmove>
    brelse(bp);
    80003ede:	854a                	mv	a0,s2
    80003ee0:	00000097          	auipc	ra,0x0
    80003ee4:	88e080e7          	jalr	-1906(ra) # 8000376e <brelse>
    ip->valid = 1;
    80003ee8:	4785                	li	a5,1
    80003eea:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003eec:	04449783          	lh	a5,68(s1)
    80003ef0:	fbb5                	bnez	a5,80003e64 <ilock+0x24>
      panic("ilock: no type");
    80003ef2:	00005517          	auipc	a0,0x5
    80003ef6:	81650513          	addi	a0,a0,-2026 # 80008708 <syscalls+0x1a0>
    80003efa:	ffffc097          	auipc	ra,0xffffc
    80003efe:	6ea080e7          	jalr	1770(ra) # 800005e4 <panic>

0000000080003f02 <iunlock>:
{
    80003f02:	1101                	addi	sp,sp,-32
    80003f04:	ec06                	sd	ra,24(sp)
    80003f06:	e822                	sd	s0,16(sp)
    80003f08:	e426                	sd	s1,8(sp)
    80003f0a:	e04a                	sd	s2,0(sp)
    80003f0c:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003f0e:	c905                	beqz	a0,80003f3e <iunlock+0x3c>
    80003f10:	84aa                	mv	s1,a0
    80003f12:	01050913          	addi	s2,a0,16
    80003f16:	854a                	mv	a0,s2
    80003f18:	00001097          	auipc	ra,0x1
    80003f1c:	c80080e7          	jalr	-896(ra) # 80004b98 <holdingsleep>
    80003f20:	cd19                	beqz	a0,80003f3e <iunlock+0x3c>
    80003f22:	449c                	lw	a5,8(s1)
    80003f24:	00f05d63          	blez	a5,80003f3e <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003f28:	854a                	mv	a0,s2
    80003f2a:	00001097          	auipc	ra,0x1
    80003f2e:	c2a080e7          	jalr	-982(ra) # 80004b54 <releasesleep>
}
    80003f32:	60e2                	ld	ra,24(sp)
    80003f34:	6442                	ld	s0,16(sp)
    80003f36:	64a2                	ld	s1,8(sp)
    80003f38:	6902                	ld	s2,0(sp)
    80003f3a:	6105                	addi	sp,sp,32
    80003f3c:	8082                	ret
    panic("iunlock");
    80003f3e:	00004517          	auipc	a0,0x4
    80003f42:	7da50513          	addi	a0,a0,2010 # 80008718 <syscalls+0x1b0>
    80003f46:	ffffc097          	auipc	ra,0xffffc
    80003f4a:	69e080e7          	jalr	1694(ra) # 800005e4 <panic>

0000000080003f4e <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003f4e:	7179                	addi	sp,sp,-48
    80003f50:	f406                	sd	ra,40(sp)
    80003f52:	f022                	sd	s0,32(sp)
    80003f54:	ec26                	sd	s1,24(sp)
    80003f56:	e84a                	sd	s2,16(sp)
    80003f58:	e44e                	sd	s3,8(sp)
    80003f5a:	e052                	sd	s4,0(sp)
    80003f5c:	1800                	addi	s0,sp,48
    80003f5e:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003f60:	05050493          	addi	s1,a0,80
    80003f64:	08050913          	addi	s2,a0,128
    80003f68:	a021                	j	80003f70 <itrunc+0x22>
    80003f6a:	0491                	addi	s1,s1,4
    80003f6c:	01248d63          	beq	s1,s2,80003f86 <itrunc+0x38>
    if(ip->addrs[i]){
    80003f70:	408c                	lw	a1,0(s1)
    80003f72:	dde5                	beqz	a1,80003f6a <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003f74:	0009a503          	lw	a0,0(s3)
    80003f78:	00000097          	auipc	ra,0x0
    80003f7c:	90c080e7          	jalr	-1780(ra) # 80003884 <bfree>
      ip->addrs[i] = 0;
    80003f80:	0004a023          	sw	zero,0(s1)
    80003f84:	b7dd                	j	80003f6a <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003f86:	0809a583          	lw	a1,128(s3)
    80003f8a:	e185                	bnez	a1,80003faa <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003f8c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003f90:	854e                	mv	a0,s3
    80003f92:	00000097          	auipc	ra,0x0
    80003f96:	de4080e7          	jalr	-540(ra) # 80003d76 <iupdate>
}
    80003f9a:	70a2                	ld	ra,40(sp)
    80003f9c:	7402                	ld	s0,32(sp)
    80003f9e:	64e2                	ld	s1,24(sp)
    80003fa0:	6942                	ld	s2,16(sp)
    80003fa2:	69a2                	ld	s3,8(sp)
    80003fa4:	6a02                	ld	s4,0(sp)
    80003fa6:	6145                	addi	sp,sp,48
    80003fa8:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003faa:	0009a503          	lw	a0,0(s3)
    80003fae:	fffff097          	auipc	ra,0xfffff
    80003fb2:	690080e7          	jalr	1680(ra) # 8000363e <bread>
    80003fb6:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003fb8:	05850493          	addi	s1,a0,88
    80003fbc:	45850913          	addi	s2,a0,1112
    80003fc0:	a021                	j	80003fc8 <itrunc+0x7a>
    80003fc2:	0491                	addi	s1,s1,4
    80003fc4:	01248b63          	beq	s1,s2,80003fda <itrunc+0x8c>
      if(a[j])
    80003fc8:	408c                	lw	a1,0(s1)
    80003fca:	dde5                	beqz	a1,80003fc2 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003fcc:	0009a503          	lw	a0,0(s3)
    80003fd0:	00000097          	auipc	ra,0x0
    80003fd4:	8b4080e7          	jalr	-1868(ra) # 80003884 <bfree>
    80003fd8:	b7ed                	j	80003fc2 <itrunc+0x74>
    brelse(bp);
    80003fda:	8552                	mv	a0,s4
    80003fdc:	fffff097          	auipc	ra,0xfffff
    80003fe0:	792080e7          	jalr	1938(ra) # 8000376e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003fe4:	0809a583          	lw	a1,128(s3)
    80003fe8:	0009a503          	lw	a0,0(s3)
    80003fec:	00000097          	auipc	ra,0x0
    80003ff0:	898080e7          	jalr	-1896(ra) # 80003884 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003ff4:	0809a023          	sw	zero,128(s3)
    80003ff8:	bf51                	j	80003f8c <itrunc+0x3e>

0000000080003ffa <iput>:
{
    80003ffa:	1101                	addi	sp,sp,-32
    80003ffc:	ec06                	sd	ra,24(sp)
    80003ffe:	e822                	sd	s0,16(sp)
    80004000:	e426                	sd	s1,8(sp)
    80004002:	e04a                	sd	s2,0(sp)
    80004004:	1000                	addi	s0,sp,32
    80004006:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80004008:	00048517          	auipc	a0,0x48
    8000400c:	e6850513          	addi	a0,a0,-408 # 8004be70 <icache>
    80004010:	ffffd097          	auipc	ra,0xffffd
    80004014:	d2a080e7          	jalr	-726(ra) # 80000d3a <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80004018:	4498                	lw	a4,8(s1)
    8000401a:	4785                	li	a5,1
    8000401c:	02f70363          	beq	a4,a5,80004042 <iput+0x48>
  ip->ref--;
    80004020:	449c                	lw	a5,8(s1)
    80004022:	37fd                	addiw	a5,a5,-1
    80004024:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80004026:	00048517          	auipc	a0,0x48
    8000402a:	e4a50513          	addi	a0,a0,-438 # 8004be70 <icache>
    8000402e:	ffffd097          	auipc	ra,0xffffd
    80004032:	dc0080e7          	jalr	-576(ra) # 80000dee <release>
}
    80004036:	60e2                	ld	ra,24(sp)
    80004038:	6442                	ld	s0,16(sp)
    8000403a:	64a2                	ld	s1,8(sp)
    8000403c:	6902                	ld	s2,0(sp)
    8000403e:	6105                	addi	sp,sp,32
    80004040:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80004042:	40bc                	lw	a5,64(s1)
    80004044:	dff1                	beqz	a5,80004020 <iput+0x26>
    80004046:	04a49783          	lh	a5,74(s1)
    8000404a:	fbf9                	bnez	a5,80004020 <iput+0x26>
    acquiresleep(&ip->lock);
    8000404c:	01048913          	addi	s2,s1,16
    80004050:	854a                	mv	a0,s2
    80004052:	00001097          	auipc	ra,0x1
    80004056:	aac080e7          	jalr	-1364(ra) # 80004afe <acquiresleep>
    release(&icache.lock);
    8000405a:	00048517          	auipc	a0,0x48
    8000405e:	e1650513          	addi	a0,a0,-490 # 8004be70 <icache>
    80004062:	ffffd097          	auipc	ra,0xffffd
    80004066:	d8c080e7          	jalr	-628(ra) # 80000dee <release>
    itrunc(ip);
    8000406a:	8526                	mv	a0,s1
    8000406c:	00000097          	auipc	ra,0x0
    80004070:	ee2080e7          	jalr	-286(ra) # 80003f4e <itrunc>
    ip->type = 0;
    80004074:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80004078:	8526                	mv	a0,s1
    8000407a:	00000097          	auipc	ra,0x0
    8000407e:	cfc080e7          	jalr	-772(ra) # 80003d76 <iupdate>
    ip->valid = 0;
    80004082:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80004086:	854a                	mv	a0,s2
    80004088:	00001097          	auipc	ra,0x1
    8000408c:	acc080e7          	jalr	-1332(ra) # 80004b54 <releasesleep>
    acquire(&icache.lock);
    80004090:	00048517          	auipc	a0,0x48
    80004094:	de050513          	addi	a0,a0,-544 # 8004be70 <icache>
    80004098:	ffffd097          	auipc	ra,0xffffd
    8000409c:	ca2080e7          	jalr	-862(ra) # 80000d3a <acquire>
    800040a0:	b741                	j	80004020 <iput+0x26>

00000000800040a2 <iunlockput>:
{
    800040a2:	1101                	addi	sp,sp,-32
    800040a4:	ec06                	sd	ra,24(sp)
    800040a6:	e822                	sd	s0,16(sp)
    800040a8:	e426                	sd	s1,8(sp)
    800040aa:	1000                	addi	s0,sp,32
    800040ac:	84aa                	mv	s1,a0
  iunlock(ip);
    800040ae:	00000097          	auipc	ra,0x0
    800040b2:	e54080e7          	jalr	-428(ra) # 80003f02 <iunlock>
  iput(ip);
    800040b6:	8526                	mv	a0,s1
    800040b8:	00000097          	auipc	ra,0x0
    800040bc:	f42080e7          	jalr	-190(ra) # 80003ffa <iput>
}
    800040c0:	60e2                	ld	ra,24(sp)
    800040c2:	6442                	ld	s0,16(sp)
    800040c4:	64a2                	ld	s1,8(sp)
    800040c6:	6105                	addi	sp,sp,32
    800040c8:	8082                	ret

00000000800040ca <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800040ca:	1141                	addi	sp,sp,-16
    800040cc:	e422                	sd	s0,8(sp)
    800040ce:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800040d0:	411c                	lw	a5,0(a0)
    800040d2:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800040d4:	415c                	lw	a5,4(a0)
    800040d6:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800040d8:	04451783          	lh	a5,68(a0)
    800040dc:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800040e0:	04a51783          	lh	a5,74(a0)
    800040e4:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800040e8:	04c56783          	lwu	a5,76(a0)
    800040ec:	e99c                	sd	a5,16(a1)
}
    800040ee:	6422                	ld	s0,8(sp)
    800040f0:	0141                	addi	sp,sp,16
    800040f2:	8082                	ret

00000000800040f4 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800040f4:	457c                	lw	a5,76(a0)
    800040f6:	0ed7e963          	bltu	a5,a3,800041e8 <readi+0xf4>
{
    800040fa:	7159                	addi	sp,sp,-112
    800040fc:	f486                	sd	ra,104(sp)
    800040fe:	f0a2                	sd	s0,96(sp)
    80004100:	eca6                	sd	s1,88(sp)
    80004102:	e8ca                	sd	s2,80(sp)
    80004104:	e4ce                	sd	s3,72(sp)
    80004106:	e0d2                	sd	s4,64(sp)
    80004108:	fc56                	sd	s5,56(sp)
    8000410a:	f85a                	sd	s6,48(sp)
    8000410c:	f45e                	sd	s7,40(sp)
    8000410e:	f062                	sd	s8,32(sp)
    80004110:	ec66                	sd	s9,24(sp)
    80004112:	e86a                	sd	s10,16(sp)
    80004114:	e46e                	sd	s11,8(sp)
    80004116:	1880                	addi	s0,sp,112
    80004118:	8baa                	mv	s7,a0
    8000411a:	8c2e                	mv	s8,a1
    8000411c:	8ab2                	mv	s5,a2
    8000411e:	84b6                	mv	s1,a3
    80004120:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80004122:	9f35                	addw	a4,a4,a3
    return 0;
    80004124:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80004126:	0ad76063          	bltu	a4,a3,800041c6 <readi+0xd2>
  if(off + n > ip->size)
    8000412a:	00e7f463          	bgeu	a5,a4,80004132 <readi+0x3e>
    n = ip->size - off;
    8000412e:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004132:	0a0b0963          	beqz	s6,800041e4 <readi+0xf0>
    80004136:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80004138:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000413c:	5cfd                	li	s9,-1
    8000413e:	a82d                	j	80004178 <readi+0x84>
    80004140:	020a1d93          	slli	s11,s4,0x20
    80004144:	020ddd93          	srli	s11,s11,0x20
    80004148:	05890793          	addi	a5,s2,88
    8000414c:	86ee                	mv	a3,s11
    8000414e:	963e                	add	a2,a2,a5
    80004150:	85d6                	mv	a1,s5
    80004152:	8562                	mv	a0,s8
    80004154:	fffff097          	auipc	ra,0xfffff
    80004158:	9a8080e7          	jalr	-1624(ra) # 80002afc <either_copyout>
    8000415c:	05950d63          	beq	a0,s9,800041b6 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80004160:	854a                	mv	a0,s2
    80004162:	fffff097          	auipc	ra,0xfffff
    80004166:	60c080e7          	jalr	1548(ra) # 8000376e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000416a:	013a09bb          	addw	s3,s4,s3
    8000416e:	009a04bb          	addw	s1,s4,s1
    80004172:	9aee                	add	s5,s5,s11
    80004174:	0569f763          	bgeu	s3,s6,800041c2 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80004178:	000ba903          	lw	s2,0(s7)
    8000417c:	00a4d59b          	srliw	a1,s1,0xa
    80004180:	855e                	mv	a0,s7
    80004182:	00000097          	auipc	ra,0x0
    80004186:	8b0080e7          	jalr	-1872(ra) # 80003a32 <bmap>
    8000418a:	0005059b          	sext.w	a1,a0
    8000418e:	854a                	mv	a0,s2
    80004190:	fffff097          	auipc	ra,0xfffff
    80004194:	4ae080e7          	jalr	1198(ra) # 8000363e <bread>
    80004198:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000419a:	3ff4f613          	andi	a2,s1,1023
    8000419e:	40cd07bb          	subw	a5,s10,a2
    800041a2:	413b073b          	subw	a4,s6,s3
    800041a6:	8a3e                	mv	s4,a5
    800041a8:	2781                	sext.w	a5,a5
    800041aa:	0007069b          	sext.w	a3,a4
    800041ae:	f8f6f9e3          	bgeu	a3,a5,80004140 <readi+0x4c>
    800041b2:	8a3a                	mv	s4,a4
    800041b4:	b771                	j	80004140 <readi+0x4c>
      brelse(bp);
    800041b6:	854a                	mv	a0,s2
    800041b8:	fffff097          	auipc	ra,0xfffff
    800041bc:	5b6080e7          	jalr	1462(ra) # 8000376e <brelse>
      tot = -1;
    800041c0:	59fd                	li	s3,-1
  }
  return tot;
    800041c2:	0009851b          	sext.w	a0,s3
}
    800041c6:	70a6                	ld	ra,104(sp)
    800041c8:	7406                	ld	s0,96(sp)
    800041ca:	64e6                	ld	s1,88(sp)
    800041cc:	6946                	ld	s2,80(sp)
    800041ce:	69a6                	ld	s3,72(sp)
    800041d0:	6a06                	ld	s4,64(sp)
    800041d2:	7ae2                	ld	s5,56(sp)
    800041d4:	7b42                	ld	s6,48(sp)
    800041d6:	7ba2                	ld	s7,40(sp)
    800041d8:	7c02                	ld	s8,32(sp)
    800041da:	6ce2                	ld	s9,24(sp)
    800041dc:	6d42                	ld	s10,16(sp)
    800041de:	6da2                	ld	s11,8(sp)
    800041e0:	6165                	addi	sp,sp,112
    800041e2:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800041e4:	89da                	mv	s3,s6
    800041e6:	bff1                	j	800041c2 <readi+0xce>
    return 0;
    800041e8:	4501                	li	a0,0
}
    800041ea:	8082                	ret

00000000800041ec <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800041ec:	457c                	lw	a5,76(a0)
    800041ee:	10d7e763          	bltu	a5,a3,800042fc <writei+0x110>
{
    800041f2:	7159                	addi	sp,sp,-112
    800041f4:	f486                	sd	ra,104(sp)
    800041f6:	f0a2                	sd	s0,96(sp)
    800041f8:	eca6                	sd	s1,88(sp)
    800041fa:	e8ca                	sd	s2,80(sp)
    800041fc:	e4ce                	sd	s3,72(sp)
    800041fe:	e0d2                	sd	s4,64(sp)
    80004200:	fc56                	sd	s5,56(sp)
    80004202:	f85a                	sd	s6,48(sp)
    80004204:	f45e                	sd	s7,40(sp)
    80004206:	f062                	sd	s8,32(sp)
    80004208:	ec66                	sd	s9,24(sp)
    8000420a:	e86a                	sd	s10,16(sp)
    8000420c:	e46e                	sd	s11,8(sp)
    8000420e:	1880                	addi	s0,sp,112
    80004210:	8baa                	mv	s7,a0
    80004212:	8c2e                	mv	s8,a1
    80004214:	8ab2                	mv	s5,a2
    80004216:	8936                	mv	s2,a3
    80004218:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000421a:	00e687bb          	addw	a5,a3,a4
    8000421e:	0ed7e163          	bltu	a5,a3,80004300 <writei+0x114>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80004222:	00043737          	lui	a4,0x43
    80004226:	0cf76f63          	bltu	a4,a5,80004304 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000422a:	0a0b0863          	beqz	s6,800042da <writei+0xee>
    8000422e:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80004230:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80004234:	5cfd                	li	s9,-1
    80004236:	a091                	j	8000427a <writei+0x8e>
    80004238:	02099d93          	slli	s11,s3,0x20
    8000423c:	020ddd93          	srli	s11,s11,0x20
    80004240:	05848793          	addi	a5,s1,88
    80004244:	86ee                	mv	a3,s11
    80004246:	8656                	mv	a2,s5
    80004248:	85e2                	mv	a1,s8
    8000424a:	953e                	add	a0,a0,a5
    8000424c:	fffff097          	auipc	ra,0xfffff
    80004250:	906080e7          	jalr	-1786(ra) # 80002b52 <either_copyin>
    80004254:	07950263          	beq	a0,s9,800042b8 <writei+0xcc>
      brelse(bp);
      n = -1;
      break;
    }
    log_write(bp);
    80004258:	8526                	mv	a0,s1
    8000425a:	00000097          	auipc	ra,0x0
    8000425e:	77c080e7          	jalr	1916(ra) # 800049d6 <log_write>
    brelse(bp);
    80004262:	8526                	mv	a0,s1
    80004264:	fffff097          	auipc	ra,0xfffff
    80004268:	50a080e7          	jalr	1290(ra) # 8000376e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000426c:	01498a3b          	addw	s4,s3,s4
    80004270:	0129893b          	addw	s2,s3,s2
    80004274:	9aee                	add	s5,s5,s11
    80004276:	056a7763          	bgeu	s4,s6,800042c4 <writei+0xd8>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000427a:	000ba483          	lw	s1,0(s7)
    8000427e:	00a9559b          	srliw	a1,s2,0xa
    80004282:	855e                	mv	a0,s7
    80004284:	fffff097          	auipc	ra,0xfffff
    80004288:	7ae080e7          	jalr	1966(ra) # 80003a32 <bmap>
    8000428c:	0005059b          	sext.w	a1,a0
    80004290:	8526                	mv	a0,s1
    80004292:	fffff097          	auipc	ra,0xfffff
    80004296:	3ac080e7          	jalr	940(ra) # 8000363e <bread>
    8000429a:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000429c:	3ff97513          	andi	a0,s2,1023
    800042a0:	40ad07bb          	subw	a5,s10,a0
    800042a4:	414b073b          	subw	a4,s6,s4
    800042a8:	89be                	mv	s3,a5
    800042aa:	2781                	sext.w	a5,a5
    800042ac:	0007069b          	sext.w	a3,a4
    800042b0:	f8f6f4e3          	bgeu	a3,a5,80004238 <writei+0x4c>
    800042b4:	89ba                	mv	s3,a4
    800042b6:	b749                	j	80004238 <writei+0x4c>
      brelse(bp);
    800042b8:	8526                	mv	a0,s1
    800042ba:	fffff097          	auipc	ra,0xfffff
    800042be:	4b4080e7          	jalr	1204(ra) # 8000376e <brelse>
      n = -1;
    800042c2:	5b7d                	li	s6,-1
  }

  if(n > 0){
    if(off > ip->size)
    800042c4:	04cba783          	lw	a5,76(s7)
    800042c8:	0127f463          	bgeu	a5,s2,800042d0 <writei+0xe4>
      ip->size = off;
    800042cc:	052ba623          	sw	s2,76(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    800042d0:	855e                	mv	a0,s7
    800042d2:	00000097          	auipc	ra,0x0
    800042d6:	aa4080e7          	jalr	-1372(ra) # 80003d76 <iupdate>
  }

  return n;
    800042da:	000b051b          	sext.w	a0,s6
}
    800042de:	70a6                	ld	ra,104(sp)
    800042e0:	7406                	ld	s0,96(sp)
    800042e2:	64e6                	ld	s1,88(sp)
    800042e4:	6946                	ld	s2,80(sp)
    800042e6:	69a6                	ld	s3,72(sp)
    800042e8:	6a06                	ld	s4,64(sp)
    800042ea:	7ae2                	ld	s5,56(sp)
    800042ec:	7b42                	ld	s6,48(sp)
    800042ee:	7ba2                	ld	s7,40(sp)
    800042f0:	7c02                	ld	s8,32(sp)
    800042f2:	6ce2                	ld	s9,24(sp)
    800042f4:	6d42                	ld	s10,16(sp)
    800042f6:	6da2                	ld	s11,8(sp)
    800042f8:	6165                	addi	sp,sp,112
    800042fa:	8082                	ret
    return -1;
    800042fc:	557d                	li	a0,-1
}
    800042fe:	8082                	ret
    return -1;
    80004300:	557d                	li	a0,-1
    80004302:	bff1                	j	800042de <writei+0xf2>
    return -1;
    80004304:	557d                	li	a0,-1
    80004306:	bfe1                	j	800042de <writei+0xf2>

0000000080004308 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80004308:	1141                	addi	sp,sp,-16
    8000430a:	e406                	sd	ra,8(sp)
    8000430c:	e022                	sd	s0,0(sp)
    8000430e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80004310:	4639                	li	a2,14
    80004312:	ffffd097          	auipc	ra,0xffffd
    80004316:	bfc080e7          	jalr	-1028(ra) # 80000f0e <strncmp>
}
    8000431a:	60a2                	ld	ra,8(sp)
    8000431c:	6402                	ld	s0,0(sp)
    8000431e:	0141                	addi	sp,sp,16
    80004320:	8082                	ret

0000000080004322 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80004322:	7139                	addi	sp,sp,-64
    80004324:	fc06                	sd	ra,56(sp)
    80004326:	f822                	sd	s0,48(sp)
    80004328:	f426                	sd	s1,40(sp)
    8000432a:	f04a                	sd	s2,32(sp)
    8000432c:	ec4e                	sd	s3,24(sp)
    8000432e:	e852                	sd	s4,16(sp)
    80004330:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80004332:	04451703          	lh	a4,68(a0)
    80004336:	4785                	li	a5,1
    80004338:	00f71a63          	bne	a4,a5,8000434c <dirlookup+0x2a>
    8000433c:	892a                	mv	s2,a0
    8000433e:	89ae                	mv	s3,a1
    80004340:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80004342:	457c                	lw	a5,76(a0)
    80004344:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80004346:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004348:	e79d                	bnez	a5,80004376 <dirlookup+0x54>
    8000434a:	a8a5                	j	800043c2 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000434c:	00004517          	auipc	a0,0x4
    80004350:	3d450513          	addi	a0,a0,980 # 80008720 <syscalls+0x1b8>
    80004354:	ffffc097          	auipc	ra,0xffffc
    80004358:	290080e7          	jalr	656(ra) # 800005e4 <panic>
      panic("dirlookup read");
    8000435c:	00004517          	auipc	a0,0x4
    80004360:	3dc50513          	addi	a0,a0,988 # 80008738 <syscalls+0x1d0>
    80004364:	ffffc097          	auipc	ra,0xffffc
    80004368:	280080e7          	jalr	640(ra) # 800005e4 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000436c:	24c1                	addiw	s1,s1,16
    8000436e:	04c92783          	lw	a5,76(s2)
    80004372:	04f4f763          	bgeu	s1,a5,800043c0 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004376:	4741                	li	a4,16
    80004378:	86a6                	mv	a3,s1
    8000437a:	fc040613          	addi	a2,s0,-64
    8000437e:	4581                	li	a1,0
    80004380:	854a                	mv	a0,s2
    80004382:	00000097          	auipc	ra,0x0
    80004386:	d72080e7          	jalr	-654(ra) # 800040f4 <readi>
    8000438a:	47c1                	li	a5,16
    8000438c:	fcf518e3          	bne	a0,a5,8000435c <dirlookup+0x3a>
    if(de.inum == 0)
    80004390:	fc045783          	lhu	a5,-64(s0)
    80004394:	dfe1                	beqz	a5,8000436c <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80004396:	fc240593          	addi	a1,s0,-62
    8000439a:	854e                	mv	a0,s3
    8000439c:	00000097          	auipc	ra,0x0
    800043a0:	f6c080e7          	jalr	-148(ra) # 80004308 <namecmp>
    800043a4:	f561                	bnez	a0,8000436c <dirlookup+0x4a>
      if(poff)
    800043a6:	000a0463          	beqz	s4,800043ae <dirlookup+0x8c>
        *poff = off;
    800043aa:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800043ae:	fc045583          	lhu	a1,-64(s0)
    800043b2:	00092503          	lw	a0,0(s2)
    800043b6:	fffff097          	auipc	ra,0xfffff
    800043ba:	756080e7          	jalr	1878(ra) # 80003b0c <iget>
    800043be:	a011                	j	800043c2 <dirlookup+0xa0>
  return 0;
    800043c0:	4501                	li	a0,0
}
    800043c2:	70e2                	ld	ra,56(sp)
    800043c4:	7442                	ld	s0,48(sp)
    800043c6:	74a2                	ld	s1,40(sp)
    800043c8:	7902                	ld	s2,32(sp)
    800043ca:	69e2                	ld	s3,24(sp)
    800043cc:	6a42                	ld	s4,16(sp)
    800043ce:	6121                	addi	sp,sp,64
    800043d0:	8082                	ret

00000000800043d2 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800043d2:	711d                	addi	sp,sp,-96
    800043d4:	ec86                	sd	ra,88(sp)
    800043d6:	e8a2                	sd	s0,80(sp)
    800043d8:	e4a6                	sd	s1,72(sp)
    800043da:	e0ca                	sd	s2,64(sp)
    800043dc:	fc4e                	sd	s3,56(sp)
    800043de:	f852                	sd	s4,48(sp)
    800043e0:	f456                	sd	s5,40(sp)
    800043e2:	f05a                	sd	s6,32(sp)
    800043e4:	ec5e                	sd	s7,24(sp)
    800043e6:	e862                	sd	s8,16(sp)
    800043e8:	e466                	sd	s9,8(sp)
    800043ea:	1080                	addi	s0,sp,96
    800043ec:	84aa                	mv	s1,a0
    800043ee:	8aae                	mv	s5,a1
    800043f0:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    800043f2:	00054703          	lbu	a4,0(a0)
    800043f6:	02f00793          	li	a5,47
    800043fa:	02f70363          	beq	a4,a5,80004420 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800043fe:	ffffe097          	auipc	ra,0xffffe
    80004402:	c90080e7          	jalr	-880(ra) # 8000208e <myproc>
    80004406:	16053503          	ld	a0,352(a0)
    8000440a:	00000097          	auipc	ra,0x0
    8000440e:	9f8080e7          	jalr	-1544(ra) # 80003e02 <idup>
    80004412:	89aa                	mv	s3,a0
  while(*path == '/')
    80004414:	02f00913          	li	s2,47
  len = path - s;
    80004418:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    8000441a:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000441c:	4b85                	li	s7,1
    8000441e:	a865                	j	800044d6 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80004420:	4585                	li	a1,1
    80004422:	4505                	li	a0,1
    80004424:	fffff097          	auipc	ra,0xfffff
    80004428:	6e8080e7          	jalr	1768(ra) # 80003b0c <iget>
    8000442c:	89aa                	mv	s3,a0
    8000442e:	b7dd                	j	80004414 <namex+0x42>
      iunlockput(ip);
    80004430:	854e                	mv	a0,s3
    80004432:	00000097          	auipc	ra,0x0
    80004436:	c70080e7          	jalr	-912(ra) # 800040a2 <iunlockput>
      return 0;
    8000443a:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000443c:	854e                	mv	a0,s3
    8000443e:	60e6                	ld	ra,88(sp)
    80004440:	6446                	ld	s0,80(sp)
    80004442:	64a6                	ld	s1,72(sp)
    80004444:	6906                	ld	s2,64(sp)
    80004446:	79e2                	ld	s3,56(sp)
    80004448:	7a42                	ld	s4,48(sp)
    8000444a:	7aa2                	ld	s5,40(sp)
    8000444c:	7b02                	ld	s6,32(sp)
    8000444e:	6be2                	ld	s7,24(sp)
    80004450:	6c42                	ld	s8,16(sp)
    80004452:	6ca2                	ld	s9,8(sp)
    80004454:	6125                	addi	sp,sp,96
    80004456:	8082                	ret
      iunlock(ip);
    80004458:	854e                	mv	a0,s3
    8000445a:	00000097          	auipc	ra,0x0
    8000445e:	aa8080e7          	jalr	-1368(ra) # 80003f02 <iunlock>
      return ip;
    80004462:	bfe9                	j	8000443c <namex+0x6a>
      iunlockput(ip);
    80004464:	854e                	mv	a0,s3
    80004466:	00000097          	auipc	ra,0x0
    8000446a:	c3c080e7          	jalr	-964(ra) # 800040a2 <iunlockput>
      return 0;
    8000446e:	89e6                	mv	s3,s9
    80004470:	b7f1                	j	8000443c <namex+0x6a>
  len = path - s;
    80004472:	40b48633          	sub	a2,s1,a1
    80004476:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    8000447a:	099c5463          	bge	s8,s9,80004502 <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000447e:	4639                	li	a2,14
    80004480:	8552                	mv	a0,s4
    80004482:	ffffd097          	auipc	ra,0xffffd
    80004486:	a10080e7          	jalr	-1520(ra) # 80000e92 <memmove>
  while(*path == '/')
    8000448a:	0004c783          	lbu	a5,0(s1)
    8000448e:	01279763          	bne	a5,s2,8000449c <namex+0xca>
    path++;
    80004492:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004494:	0004c783          	lbu	a5,0(s1)
    80004498:	ff278de3          	beq	a5,s2,80004492 <namex+0xc0>
    ilock(ip);
    8000449c:	854e                	mv	a0,s3
    8000449e:	00000097          	auipc	ra,0x0
    800044a2:	9a2080e7          	jalr	-1630(ra) # 80003e40 <ilock>
    if(ip->type != T_DIR){
    800044a6:	04499783          	lh	a5,68(s3)
    800044aa:	f97793e3          	bne	a5,s7,80004430 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800044ae:	000a8563          	beqz	s5,800044b8 <namex+0xe6>
    800044b2:	0004c783          	lbu	a5,0(s1)
    800044b6:	d3cd                	beqz	a5,80004458 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800044b8:	865a                	mv	a2,s6
    800044ba:	85d2                	mv	a1,s4
    800044bc:	854e                	mv	a0,s3
    800044be:	00000097          	auipc	ra,0x0
    800044c2:	e64080e7          	jalr	-412(ra) # 80004322 <dirlookup>
    800044c6:	8caa                	mv	s9,a0
    800044c8:	dd51                	beqz	a0,80004464 <namex+0x92>
    iunlockput(ip);
    800044ca:	854e                	mv	a0,s3
    800044cc:	00000097          	auipc	ra,0x0
    800044d0:	bd6080e7          	jalr	-1066(ra) # 800040a2 <iunlockput>
    ip = next;
    800044d4:	89e6                	mv	s3,s9
  while(*path == '/')
    800044d6:	0004c783          	lbu	a5,0(s1)
    800044da:	05279763          	bne	a5,s2,80004528 <namex+0x156>
    path++;
    800044de:	0485                	addi	s1,s1,1
  while(*path == '/')
    800044e0:	0004c783          	lbu	a5,0(s1)
    800044e4:	ff278de3          	beq	a5,s2,800044de <namex+0x10c>
  if(*path == 0)
    800044e8:	c79d                	beqz	a5,80004516 <namex+0x144>
    path++;
    800044ea:	85a6                	mv	a1,s1
  len = path - s;
    800044ec:	8cda                	mv	s9,s6
    800044ee:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    800044f0:	01278963          	beq	a5,s2,80004502 <namex+0x130>
    800044f4:	dfbd                	beqz	a5,80004472 <namex+0xa0>
    path++;
    800044f6:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800044f8:	0004c783          	lbu	a5,0(s1)
    800044fc:	ff279ce3          	bne	a5,s2,800044f4 <namex+0x122>
    80004500:	bf8d                	j	80004472 <namex+0xa0>
    memmove(name, s, len);
    80004502:	2601                	sext.w	a2,a2
    80004504:	8552                	mv	a0,s4
    80004506:	ffffd097          	auipc	ra,0xffffd
    8000450a:	98c080e7          	jalr	-1652(ra) # 80000e92 <memmove>
    name[len] = 0;
    8000450e:	9cd2                	add	s9,s9,s4
    80004510:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80004514:	bf9d                	j	8000448a <namex+0xb8>
  if(nameiparent){
    80004516:	f20a83e3          	beqz	s5,8000443c <namex+0x6a>
    iput(ip);
    8000451a:	854e                	mv	a0,s3
    8000451c:	00000097          	auipc	ra,0x0
    80004520:	ade080e7          	jalr	-1314(ra) # 80003ffa <iput>
    return 0;
    80004524:	4981                	li	s3,0
    80004526:	bf19                	j	8000443c <namex+0x6a>
  if(*path == 0)
    80004528:	d7fd                	beqz	a5,80004516 <namex+0x144>
  while(*path != '/' && *path != 0)
    8000452a:	0004c783          	lbu	a5,0(s1)
    8000452e:	85a6                	mv	a1,s1
    80004530:	b7d1                	j	800044f4 <namex+0x122>

0000000080004532 <dirlink>:
{
    80004532:	7139                	addi	sp,sp,-64
    80004534:	fc06                	sd	ra,56(sp)
    80004536:	f822                	sd	s0,48(sp)
    80004538:	f426                	sd	s1,40(sp)
    8000453a:	f04a                	sd	s2,32(sp)
    8000453c:	ec4e                	sd	s3,24(sp)
    8000453e:	e852                	sd	s4,16(sp)
    80004540:	0080                	addi	s0,sp,64
    80004542:	892a                	mv	s2,a0
    80004544:	8a2e                	mv	s4,a1
    80004546:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004548:	4601                	li	a2,0
    8000454a:	00000097          	auipc	ra,0x0
    8000454e:	dd8080e7          	jalr	-552(ra) # 80004322 <dirlookup>
    80004552:	e93d                	bnez	a0,800045c8 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004554:	04c92483          	lw	s1,76(s2)
    80004558:	c49d                	beqz	s1,80004586 <dirlink+0x54>
    8000455a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000455c:	4741                	li	a4,16
    8000455e:	86a6                	mv	a3,s1
    80004560:	fc040613          	addi	a2,s0,-64
    80004564:	4581                	li	a1,0
    80004566:	854a                	mv	a0,s2
    80004568:	00000097          	auipc	ra,0x0
    8000456c:	b8c080e7          	jalr	-1140(ra) # 800040f4 <readi>
    80004570:	47c1                	li	a5,16
    80004572:	06f51163          	bne	a0,a5,800045d4 <dirlink+0xa2>
    if(de.inum == 0)
    80004576:	fc045783          	lhu	a5,-64(s0)
    8000457a:	c791                	beqz	a5,80004586 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000457c:	24c1                	addiw	s1,s1,16
    8000457e:	04c92783          	lw	a5,76(s2)
    80004582:	fcf4ede3          	bltu	s1,a5,8000455c <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80004586:	4639                	li	a2,14
    80004588:	85d2                	mv	a1,s4
    8000458a:	fc240513          	addi	a0,s0,-62
    8000458e:	ffffd097          	auipc	ra,0xffffd
    80004592:	9bc080e7          	jalr	-1604(ra) # 80000f4a <strncpy>
  de.inum = inum;
    80004596:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000459a:	4741                	li	a4,16
    8000459c:	86a6                	mv	a3,s1
    8000459e:	fc040613          	addi	a2,s0,-64
    800045a2:	4581                	li	a1,0
    800045a4:	854a                	mv	a0,s2
    800045a6:	00000097          	auipc	ra,0x0
    800045aa:	c46080e7          	jalr	-954(ra) # 800041ec <writei>
    800045ae:	872a                	mv	a4,a0
    800045b0:	47c1                	li	a5,16
  return 0;
    800045b2:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800045b4:	02f71863          	bne	a4,a5,800045e4 <dirlink+0xb2>
}
    800045b8:	70e2                	ld	ra,56(sp)
    800045ba:	7442                	ld	s0,48(sp)
    800045bc:	74a2                	ld	s1,40(sp)
    800045be:	7902                	ld	s2,32(sp)
    800045c0:	69e2                	ld	s3,24(sp)
    800045c2:	6a42                	ld	s4,16(sp)
    800045c4:	6121                	addi	sp,sp,64
    800045c6:	8082                	ret
    iput(ip);
    800045c8:	00000097          	auipc	ra,0x0
    800045cc:	a32080e7          	jalr	-1486(ra) # 80003ffa <iput>
    return -1;
    800045d0:	557d                	li	a0,-1
    800045d2:	b7dd                	j	800045b8 <dirlink+0x86>
      panic("dirlink read");
    800045d4:	00004517          	auipc	a0,0x4
    800045d8:	17450513          	addi	a0,a0,372 # 80008748 <syscalls+0x1e0>
    800045dc:	ffffc097          	auipc	ra,0xffffc
    800045e0:	008080e7          	jalr	8(ra) # 800005e4 <panic>
    panic("dirlink");
    800045e4:	00004517          	auipc	a0,0x4
    800045e8:	28450513          	addi	a0,a0,644 # 80008868 <syscalls+0x300>
    800045ec:	ffffc097          	auipc	ra,0xffffc
    800045f0:	ff8080e7          	jalr	-8(ra) # 800005e4 <panic>

00000000800045f4 <namei>:

struct inode*
namei(char *path)
{
    800045f4:	1101                	addi	sp,sp,-32
    800045f6:	ec06                	sd	ra,24(sp)
    800045f8:	e822                	sd	s0,16(sp)
    800045fa:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800045fc:	fe040613          	addi	a2,s0,-32
    80004600:	4581                	li	a1,0
    80004602:	00000097          	auipc	ra,0x0
    80004606:	dd0080e7          	jalr	-560(ra) # 800043d2 <namex>
}
    8000460a:	60e2                	ld	ra,24(sp)
    8000460c:	6442                	ld	s0,16(sp)
    8000460e:	6105                	addi	sp,sp,32
    80004610:	8082                	ret

0000000080004612 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004612:	1141                	addi	sp,sp,-16
    80004614:	e406                	sd	ra,8(sp)
    80004616:	e022                	sd	s0,0(sp)
    80004618:	0800                	addi	s0,sp,16
    8000461a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000461c:	4585                	li	a1,1
    8000461e:	00000097          	auipc	ra,0x0
    80004622:	db4080e7          	jalr	-588(ra) # 800043d2 <namex>
}
    80004626:	60a2                	ld	ra,8(sp)
    80004628:	6402                	ld	s0,0(sp)
    8000462a:	0141                	addi	sp,sp,16
    8000462c:	8082                	ret

000000008000462e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000462e:	1101                	addi	sp,sp,-32
    80004630:	ec06                	sd	ra,24(sp)
    80004632:	e822                	sd	s0,16(sp)
    80004634:	e426                	sd	s1,8(sp)
    80004636:	e04a                	sd	s2,0(sp)
    80004638:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000463a:	00049917          	auipc	s2,0x49
    8000463e:	2de90913          	addi	s2,s2,734 # 8004d918 <log>
    80004642:	01892583          	lw	a1,24(s2)
    80004646:	02892503          	lw	a0,40(s2)
    8000464a:	fffff097          	auipc	ra,0xfffff
    8000464e:	ff4080e7          	jalr	-12(ra) # 8000363e <bread>
    80004652:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004654:	02c92683          	lw	a3,44(s2)
    80004658:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000465a:	02d05763          	blez	a3,80004688 <write_head+0x5a>
    8000465e:	00049797          	auipc	a5,0x49
    80004662:	2ea78793          	addi	a5,a5,746 # 8004d948 <log+0x30>
    80004666:	05c50713          	addi	a4,a0,92
    8000466a:	36fd                	addiw	a3,a3,-1
    8000466c:	1682                	slli	a3,a3,0x20
    8000466e:	9281                	srli	a3,a3,0x20
    80004670:	068a                	slli	a3,a3,0x2
    80004672:	00049617          	auipc	a2,0x49
    80004676:	2da60613          	addi	a2,a2,730 # 8004d94c <log+0x34>
    8000467a:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000467c:	4390                	lw	a2,0(a5)
    8000467e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004680:	0791                	addi	a5,a5,4
    80004682:	0711                	addi	a4,a4,4
    80004684:	fed79ce3          	bne	a5,a3,8000467c <write_head+0x4e>
  }
  bwrite(buf);
    80004688:	8526                	mv	a0,s1
    8000468a:	fffff097          	auipc	ra,0xfffff
    8000468e:	0a6080e7          	jalr	166(ra) # 80003730 <bwrite>
  brelse(buf);
    80004692:	8526                	mv	a0,s1
    80004694:	fffff097          	auipc	ra,0xfffff
    80004698:	0da080e7          	jalr	218(ra) # 8000376e <brelse>
}
    8000469c:	60e2                	ld	ra,24(sp)
    8000469e:	6442                	ld	s0,16(sp)
    800046a0:	64a2                	ld	s1,8(sp)
    800046a2:	6902                	ld	s2,0(sp)
    800046a4:	6105                	addi	sp,sp,32
    800046a6:	8082                	ret

00000000800046a8 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800046a8:	00049797          	auipc	a5,0x49
    800046ac:	29c7a783          	lw	a5,668(a5) # 8004d944 <log+0x2c>
    800046b0:	0af05663          	blez	a5,8000475c <install_trans+0xb4>
{
    800046b4:	7139                	addi	sp,sp,-64
    800046b6:	fc06                	sd	ra,56(sp)
    800046b8:	f822                	sd	s0,48(sp)
    800046ba:	f426                	sd	s1,40(sp)
    800046bc:	f04a                	sd	s2,32(sp)
    800046be:	ec4e                	sd	s3,24(sp)
    800046c0:	e852                	sd	s4,16(sp)
    800046c2:	e456                	sd	s5,8(sp)
    800046c4:	0080                	addi	s0,sp,64
    800046c6:	00049a97          	auipc	s5,0x49
    800046ca:	282a8a93          	addi	s5,s5,642 # 8004d948 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800046ce:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800046d0:	00049997          	auipc	s3,0x49
    800046d4:	24898993          	addi	s3,s3,584 # 8004d918 <log>
    800046d8:	0189a583          	lw	a1,24(s3)
    800046dc:	014585bb          	addw	a1,a1,s4
    800046e0:	2585                	addiw	a1,a1,1
    800046e2:	0289a503          	lw	a0,40(s3)
    800046e6:	fffff097          	auipc	ra,0xfffff
    800046ea:	f58080e7          	jalr	-168(ra) # 8000363e <bread>
    800046ee:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800046f0:	000aa583          	lw	a1,0(s5)
    800046f4:	0289a503          	lw	a0,40(s3)
    800046f8:	fffff097          	auipc	ra,0xfffff
    800046fc:	f46080e7          	jalr	-186(ra) # 8000363e <bread>
    80004700:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004702:	40000613          	li	a2,1024
    80004706:	05890593          	addi	a1,s2,88
    8000470a:	05850513          	addi	a0,a0,88
    8000470e:	ffffc097          	auipc	ra,0xffffc
    80004712:	784080e7          	jalr	1924(ra) # 80000e92 <memmove>
    bwrite(dbuf);  // write dst to disk
    80004716:	8526                	mv	a0,s1
    80004718:	fffff097          	auipc	ra,0xfffff
    8000471c:	018080e7          	jalr	24(ra) # 80003730 <bwrite>
    bunpin(dbuf);
    80004720:	8526                	mv	a0,s1
    80004722:	fffff097          	auipc	ra,0xfffff
    80004726:	126080e7          	jalr	294(ra) # 80003848 <bunpin>
    brelse(lbuf);
    8000472a:	854a                	mv	a0,s2
    8000472c:	fffff097          	auipc	ra,0xfffff
    80004730:	042080e7          	jalr	66(ra) # 8000376e <brelse>
    brelse(dbuf);
    80004734:	8526                	mv	a0,s1
    80004736:	fffff097          	auipc	ra,0xfffff
    8000473a:	038080e7          	jalr	56(ra) # 8000376e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000473e:	2a05                	addiw	s4,s4,1
    80004740:	0a91                	addi	s5,s5,4
    80004742:	02c9a783          	lw	a5,44(s3)
    80004746:	f8fa49e3          	blt	s4,a5,800046d8 <install_trans+0x30>
}
    8000474a:	70e2                	ld	ra,56(sp)
    8000474c:	7442                	ld	s0,48(sp)
    8000474e:	74a2                	ld	s1,40(sp)
    80004750:	7902                	ld	s2,32(sp)
    80004752:	69e2                	ld	s3,24(sp)
    80004754:	6a42                	ld	s4,16(sp)
    80004756:	6aa2                	ld	s5,8(sp)
    80004758:	6121                	addi	sp,sp,64
    8000475a:	8082                	ret
    8000475c:	8082                	ret

000000008000475e <initlog>:
{
    8000475e:	7179                	addi	sp,sp,-48
    80004760:	f406                	sd	ra,40(sp)
    80004762:	f022                	sd	s0,32(sp)
    80004764:	ec26                	sd	s1,24(sp)
    80004766:	e84a                	sd	s2,16(sp)
    80004768:	e44e                	sd	s3,8(sp)
    8000476a:	1800                	addi	s0,sp,48
    8000476c:	892a                	mv	s2,a0
    8000476e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004770:	00049497          	auipc	s1,0x49
    80004774:	1a848493          	addi	s1,s1,424 # 8004d918 <log>
    80004778:	00004597          	auipc	a1,0x4
    8000477c:	fe058593          	addi	a1,a1,-32 # 80008758 <syscalls+0x1f0>
    80004780:	8526                	mv	a0,s1
    80004782:	ffffc097          	auipc	ra,0xffffc
    80004786:	528080e7          	jalr	1320(ra) # 80000caa <initlock>
  log.start = sb->logstart;
    8000478a:	0149a583          	lw	a1,20(s3)
    8000478e:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004790:	0109a783          	lw	a5,16(s3)
    80004794:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004796:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000479a:	854a                	mv	a0,s2
    8000479c:	fffff097          	auipc	ra,0xfffff
    800047a0:	ea2080e7          	jalr	-350(ra) # 8000363e <bread>
  log.lh.n = lh->n;
    800047a4:	4d34                	lw	a3,88(a0)
    800047a6:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800047a8:	02d05563          	blez	a3,800047d2 <initlog+0x74>
    800047ac:	05c50793          	addi	a5,a0,92
    800047b0:	00049717          	auipc	a4,0x49
    800047b4:	19870713          	addi	a4,a4,408 # 8004d948 <log+0x30>
    800047b8:	36fd                	addiw	a3,a3,-1
    800047ba:	1682                	slli	a3,a3,0x20
    800047bc:	9281                	srli	a3,a3,0x20
    800047be:	068a                	slli	a3,a3,0x2
    800047c0:	06050613          	addi	a2,a0,96
    800047c4:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800047c6:	4390                	lw	a2,0(a5)
    800047c8:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800047ca:	0791                	addi	a5,a5,4
    800047cc:	0711                	addi	a4,a4,4
    800047ce:	fed79ce3          	bne	a5,a3,800047c6 <initlog+0x68>
  brelse(buf);
    800047d2:	fffff097          	auipc	ra,0xfffff
    800047d6:	f9c080e7          	jalr	-100(ra) # 8000376e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
    800047da:	00000097          	auipc	ra,0x0
    800047de:	ece080e7          	jalr	-306(ra) # 800046a8 <install_trans>
  log.lh.n = 0;
    800047e2:	00049797          	auipc	a5,0x49
    800047e6:	1607a123          	sw	zero,354(a5) # 8004d944 <log+0x2c>
  write_head(); // clear the log
    800047ea:	00000097          	auipc	ra,0x0
    800047ee:	e44080e7          	jalr	-444(ra) # 8000462e <write_head>
}
    800047f2:	70a2                	ld	ra,40(sp)
    800047f4:	7402                	ld	s0,32(sp)
    800047f6:	64e2                	ld	s1,24(sp)
    800047f8:	6942                	ld	s2,16(sp)
    800047fa:	69a2                	ld	s3,8(sp)
    800047fc:	6145                	addi	sp,sp,48
    800047fe:	8082                	ret

0000000080004800 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004800:	1101                	addi	sp,sp,-32
    80004802:	ec06                	sd	ra,24(sp)
    80004804:	e822                	sd	s0,16(sp)
    80004806:	e426                	sd	s1,8(sp)
    80004808:	e04a                	sd	s2,0(sp)
    8000480a:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000480c:	00049517          	auipc	a0,0x49
    80004810:	10c50513          	addi	a0,a0,268 # 8004d918 <log>
    80004814:	ffffc097          	auipc	ra,0xffffc
    80004818:	526080e7          	jalr	1318(ra) # 80000d3a <acquire>
  while(1){
    if(log.committing){
    8000481c:	00049497          	auipc	s1,0x49
    80004820:	0fc48493          	addi	s1,s1,252 # 8004d918 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004824:	4979                	li	s2,30
    80004826:	a039                	j	80004834 <begin_op+0x34>
      sleep(&log, &log.lock);
    80004828:	85a6                	mv	a1,s1
    8000482a:	8526                	mv	a0,s1
    8000482c:	ffffe097          	auipc	ra,0xffffe
    80004830:	076080e7          	jalr	118(ra) # 800028a2 <sleep>
    if(log.committing){
    80004834:	50dc                	lw	a5,36(s1)
    80004836:	fbed                	bnez	a5,80004828 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004838:	509c                	lw	a5,32(s1)
    8000483a:	0017871b          	addiw	a4,a5,1
    8000483e:	0007069b          	sext.w	a3,a4
    80004842:	0027179b          	slliw	a5,a4,0x2
    80004846:	9fb9                	addw	a5,a5,a4
    80004848:	0017979b          	slliw	a5,a5,0x1
    8000484c:	54d8                	lw	a4,44(s1)
    8000484e:	9fb9                	addw	a5,a5,a4
    80004850:	00f95963          	bge	s2,a5,80004862 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004854:	85a6                	mv	a1,s1
    80004856:	8526                	mv	a0,s1
    80004858:	ffffe097          	auipc	ra,0xffffe
    8000485c:	04a080e7          	jalr	74(ra) # 800028a2 <sleep>
    80004860:	bfd1                	j	80004834 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004862:	00049517          	auipc	a0,0x49
    80004866:	0b650513          	addi	a0,a0,182 # 8004d918 <log>
    8000486a:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000486c:	ffffc097          	auipc	ra,0xffffc
    80004870:	582080e7          	jalr	1410(ra) # 80000dee <release>
      break;
    }
  }
}
    80004874:	60e2                	ld	ra,24(sp)
    80004876:	6442                	ld	s0,16(sp)
    80004878:	64a2                	ld	s1,8(sp)
    8000487a:	6902                	ld	s2,0(sp)
    8000487c:	6105                	addi	sp,sp,32
    8000487e:	8082                	ret

0000000080004880 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004880:	7139                	addi	sp,sp,-64
    80004882:	fc06                	sd	ra,56(sp)
    80004884:	f822                	sd	s0,48(sp)
    80004886:	f426                	sd	s1,40(sp)
    80004888:	f04a                	sd	s2,32(sp)
    8000488a:	ec4e                	sd	s3,24(sp)
    8000488c:	e852                	sd	s4,16(sp)
    8000488e:	e456                	sd	s5,8(sp)
    80004890:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004892:	00049497          	auipc	s1,0x49
    80004896:	08648493          	addi	s1,s1,134 # 8004d918 <log>
    8000489a:	8526                	mv	a0,s1
    8000489c:	ffffc097          	auipc	ra,0xffffc
    800048a0:	49e080e7          	jalr	1182(ra) # 80000d3a <acquire>
  log.outstanding -= 1;
    800048a4:	509c                	lw	a5,32(s1)
    800048a6:	37fd                	addiw	a5,a5,-1
    800048a8:	0007891b          	sext.w	s2,a5
    800048ac:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800048ae:	50dc                	lw	a5,36(s1)
    800048b0:	e7b9                	bnez	a5,800048fe <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800048b2:	04091e63          	bnez	s2,8000490e <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800048b6:	00049497          	auipc	s1,0x49
    800048ba:	06248493          	addi	s1,s1,98 # 8004d918 <log>
    800048be:	4785                	li	a5,1
    800048c0:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800048c2:	8526                	mv	a0,s1
    800048c4:	ffffc097          	auipc	ra,0xffffc
    800048c8:	52a080e7          	jalr	1322(ra) # 80000dee <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800048cc:	54dc                	lw	a5,44(s1)
    800048ce:	06f04763          	bgtz	a5,8000493c <end_op+0xbc>
    acquire(&log.lock);
    800048d2:	00049497          	auipc	s1,0x49
    800048d6:	04648493          	addi	s1,s1,70 # 8004d918 <log>
    800048da:	8526                	mv	a0,s1
    800048dc:	ffffc097          	auipc	ra,0xffffc
    800048e0:	45e080e7          	jalr	1118(ra) # 80000d3a <acquire>
    log.committing = 0;
    800048e4:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800048e8:	8526                	mv	a0,s1
    800048ea:	ffffe097          	auipc	ra,0xffffe
    800048ee:	138080e7          	jalr	312(ra) # 80002a22 <wakeup>
    release(&log.lock);
    800048f2:	8526                	mv	a0,s1
    800048f4:	ffffc097          	auipc	ra,0xffffc
    800048f8:	4fa080e7          	jalr	1274(ra) # 80000dee <release>
}
    800048fc:	a03d                	j	8000492a <end_op+0xaa>
    panic("log.committing");
    800048fe:	00004517          	auipc	a0,0x4
    80004902:	e6250513          	addi	a0,a0,-414 # 80008760 <syscalls+0x1f8>
    80004906:	ffffc097          	auipc	ra,0xffffc
    8000490a:	cde080e7          	jalr	-802(ra) # 800005e4 <panic>
    wakeup(&log);
    8000490e:	00049497          	auipc	s1,0x49
    80004912:	00a48493          	addi	s1,s1,10 # 8004d918 <log>
    80004916:	8526                	mv	a0,s1
    80004918:	ffffe097          	auipc	ra,0xffffe
    8000491c:	10a080e7          	jalr	266(ra) # 80002a22 <wakeup>
  release(&log.lock);
    80004920:	8526                	mv	a0,s1
    80004922:	ffffc097          	auipc	ra,0xffffc
    80004926:	4cc080e7          	jalr	1228(ra) # 80000dee <release>
}
    8000492a:	70e2                	ld	ra,56(sp)
    8000492c:	7442                	ld	s0,48(sp)
    8000492e:	74a2                	ld	s1,40(sp)
    80004930:	7902                	ld	s2,32(sp)
    80004932:	69e2                	ld	s3,24(sp)
    80004934:	6a42                	ld	s4,16(sp)
    80004936:	6aa2                	ld	s5,8(sp)
    80004938:	6121                	addi	sp,sp,64
    8000493a:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    8000493c:	00049a97          	auipc	s5,0x49
    80004940:	00ca8a93          	addi	s5,s5,12 # 8004d948 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004944:	00049a17          	auipc	s4,0x49
    80004948:	fd4a0a13          	addi	s4,s4,-44 # 8004d918 <log>
    8000494c:	018a2583          	lw	a1,24(s4)
    80004950:	012585bb          	addw	a1,a1,s2
    80004954:	2585                	addiw	a1,a1,1
    80004956:	028a2503          	lw	a0,40(s4)
    8000495a:	fffff097          	auipc	ra,0xfffff
    8000495e:	ce4080e7          	jalr	-796(ra) # 8000363e <bread>
    80004962:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004964:	000aa583          	lw	a1,0(s5)
    80004968:	028a2503          	lw	a0,40(s4)
    8000496c:	fffff097          	auipc	ra,0xfffff
    80004970:	cd2080e7          	jalr	-814(ra) # 8000363e <bread>
    80004974:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004976:	40000613          	li	a2,1024
    8000497a:	05850593          	addi	a1,a0,88
    8000497e:	05848513          	addi	a0,s1,88
    80004982:	ffffc097          	auipc	ra,0xffffc
    80004986:	510080e7          	jalr	1296(ra) # 80000e92 <memmove>
    bwrite(to);  // write the log
    8000498a:	8526                	mv	a0,s1
    8000498c:	fffff097          	auipc	ra,0xfffff
    80004990:	da4080e7          	jalr	-604(ra) # 80003730 <bwrite>
    brelse(from);
    80004994:	854e                	mv	a0,s3
    80004996:	fffff097          	auipc	ra,0xfffff
    8000499a:	dd8080e7          	jalr	-552(ra) # 8000376e <brelse>
    brelse(to);
    8000499e:	8526                	mv	a0,s1
    800049a0:	fffff097          	auipc	ra,0xfffff
    800049a4:	dce080e7          	jalr	-562(ra) # 8000376e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800049a8:	2905                	addiw	s2,s2,1
    800049aa:	0a91                	addi	s5,s5,4
    800049ac:	02ca2783          	lw	a5,44(s4)
    800049b0:	f8f94ee3          	blt	s2,a5,8000494c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800049b4:	00000097          	auipc	ra,0x0
    800049b8:	c7a080e7          	jalr	-902(ra) # 8000462e <write_head>
    install_trans(); // Now install writes to home locations
    800049bc:	00000097          	auipc	ra,0x0
    800049c0:	cec080e7          	jalr	-788(ra) # 800046a8 <install_trans>
    log.lh.n = 0;
    800049c4:	00049797          	auipc	a5,0x49
    800049c8:	f807a023          	sw	zero,-128(a5) # 8004d944 <log+0x2c>
    write_head();    // Erase the transaction from the log
    800049cc:	00000097          	auipc	ra,0x0
    800049d0:	c62080e7          	jalr	-926(ra) # 8000462e <write_head>
    800049d4:	bdfd                	j	800048d2 <end_op+0x52>

00000000800049d6 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800049d6:	1101                	addi	sp,sp,-32
    800049d8:	ec06                	sd	ra,24(sp)
    800049da:	e822                	sd	s0,16(sp)
    800049dc:	e426                	sd	s1,8(sp)
    800049de:	e04a                	sd	s2,0(sp)
    800049e0:	1000                	addi	s0,sp,32
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800049e2:	00049717          	auipc	a4,0x49
    800049e6:	f6272703          	lw	a4,-158(a4) # 8004d944 <log+0x2c>
    800049ea:	47f5                	li	a5,29
    800049ec:	08e7c063          	blt	a5,a4,80004a6c <log_write+0x96>
    800049f0:	84aa                	mv	s1,a0
    800049f2:	00049797          	auipc	a5,0x49
    800049f6:	f427a783          	lw	a5,-190(a5) # 8004d934 <log+0x1c>
    800049fa:	37fd                	addiw	a5,a5,-1
    800049fc:	06f75863          	bge	a4,a5,80004a6c <log_write+0x96>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004a00:	00049797          	auipc	a5,0x49
    80004a04:	f387a783          	lw	a5,-200(a5) # 8004d938 <log+0x20>
    80004a08:	06f05a63          	blez	a5,80004a7c <log_write+0xa6>
    panic("log_write outside of trans");

  acquire(&log.lock);
    80004a0c:	00049917          	auipc	s2,0x49
    80004a10:	f0c90913          	addi	s2,s2,-244 # 8004d918 <log>
    80004a14:	854a                	mv	a0,s2
    80004a16:	ffffc097          	auipc	ra,0xffffc
    80004a1a:	324080e7          	jalr	804(ra) # 80000d3a <acquire>
  for (i = 0; i < log.lh.n; i++) {
    80004a1e:	02c92603          	lw	a2,44(s2)
    80004a22:	06c05563          	blez	a2,80004a8c <log_write+0xb6>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80004a26:	44cc                	lw	a1,12(s1)
    80004a28:	00049717          	auipc	a4,0x49
    80004a2c:	f2070713          	addi	a4,a4,-224 # 8004d948 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004a30:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80004a32:	4314                	lw	a3,0(a4)
    80004a34:	04b68d63          	beq	a3,a1,80004a8e <log_write+0xb8>
  for (i = 0; i < log.lh.n; i++) {
    80004a38:	2785                	addiw	a5,a5,1
    80004a3a:	0711                	addi	a4,a4,4
    80004a3c:	fec79be3          	bne	a5,a2,80004a32 <log_write+0x5c>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004a40:	0621                	addi	a2,a2,8
    80004a42:	060a                	slli	a2,a2,0x2
    80004a44:	00049797          	auipc	a5,0x49
    80004a48:	ed478793          	addi	a5,a5,-300 # 8004d918 <log>
    80004a4c:	963e                	add	a2,a2,a5
    80004a4e:	44dc                	lw	a5,12(s1)
    80004a50:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004a52:	8526                	mv	a0,s1
    80004a54:	fffff097          	auipc	ra,0xfffff
    80004a58:	db8080e7          	jalr	-584(ra) # 8000380c <bpin>
    log.lh.n++;
    80004a5c:	00049717          	auipc	a4,0x49
    80004a60:	ebc70713          	addi	a4,a4,-324 # 8004d918 <log>
    80004a64:	575c                	lw	a5,44(a4)
    80004a66:	2785                	addiw	a5,a5,1
    80004a68:	d75c                	sw	a5,44(a4)
    80004a6a:	a83d                	j	80004aa8 <log_write+0xd2>
    panic("too big a transaction");
    80004a6c:	00004517          	auipc	a0,0x4
    80004a70:	d0450513          	addi	a0,a0,-764 # 80008770 <syscalls+0x208>
    80004a74:	ffffc097          	auipc	ra,0xffffc
    80004a78:	b70080e7          	jalr	-1168(ra) # 800005e4 <panic>
    panic("log_write outside of trans");
    80004a7c:	00004517          	auipc	a0,0x4
    80004a80:	d0c50513          	addi	a0,a0,-756 # 80008788 <syscalls+0x220>
    80004a84:	ffffc097          	auipc	ra,0xffffc
    80004a88:	b60080e7          	jalr	-1184(ra) # 800005e4 <panic>
  for (i = 0; i < log.lh.n; i++) {
    80004a8c:	4781                	li	a5,0
  log.lh.block[i] = b->blockno;
    80004a8e:	00878713          	addi	a4,a5,8
    80004a92:	00271693          	slli	a3,a4,0x2
    80004a96:	00049717          	auipc	a4,0x49
    80004a9a:	e8270713          	addi	a4,a4,-382 # 8004d918 <log>
    80004a9e:	9736                	add	a4,a4,a3
    80004aa0:	44d4                	lw	a3,12(s1)
    80004aa2:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004aa4:	faf607e3          	beq	a2,a5,80004a52 <log_write+0x7c>
  }
  release(&log.lock);
    80004aa8:	00049517          	auipc	a0,0x49
    80004aac:	e7050513          	addi	a0,a0,-400 # 8004d918 <log>
    80004ab0:	ffffc097          	auipc	ra,0xffffc
    80004ab4:	33e080e7          	jalr	830(ra) # 80000dee <release>
}
    80004ab8:	60e2                	ld	ra,24(sp)
    80004aba:	6442                	ld	s0,16(sp)
    80004abc:	64a2                	ld	s1,8(sp)
    80004abe:	6902                	ld	s2,0(sp)
    80004ac0:	6105                	addi	sp,sp,32
    80004ac2:	8082                	ret

0000000080004ac4 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004ac4:	1101                	addi	sp,sp,-32
    80004ac6:	ec06                	sd	ra,24(sp)
    80004ac8:	e822                	sd	s0,16(sp)
    80004aca:	e426                	sd	s1,8(sp)
    80004acc:	e04a                	sd	s2,0(sp)
    80004ace:	1000                	addi	s0,sp,32
    80004ad0:	84aa                	mv	s1,a0
    80004ad2:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004ad4:	00004597          	auipc	a1,0x4
    80004ad8:	cd458593          	addi	a1,a1,-812 # 800087a8 <syscalls+0x240>
    80004adc:	0521                	addi	a0,a0,8
    80004ade:	ffffc097          	auipc	ra,0xffffc
    80004ae2:	1cc080e7          	jalr	460(ra) # 80000caa <initlock>
  lk->name = name;
    80004ae6:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004aea:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004aee:	0204a423          	sw	zero,40(s1)
}
    80004af2:	60e2                	ld	ra,24(sp)
    80004af4:	6442                	ld	s0,16(sp)
    80004af6:	64a2                	ld	s1,8(sp)
    80004af8:	6902                	ld	s2,0(sp)
    80004afa:	6105                	addi	sp,sp,32
    80004afc:	8082                	ret

0000000080004afe <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004afe:	1101                	addi	sp,sp,-32
    80004b00:	ec06                	sd	ra,24(sp)
    80004b02:	e822                	sd	s0,16(sp)
    80004b04:	e426                	sd	s1,8(sp)
    80004b06:	e04a                	sd	s2,0(sp)
    80004b08:	1000                	addi	s0,sp,32
    80004b0a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004b0c:	00850913          	addi	s2,a0,8
    80004b10:	854a                	mv	a0,s2
    80004b12:	ffffc097          	auipc	ra,0xffffc
    80004b16:	228080e7          	jalr	552(ra) # 80000d3a <acquire>
  while (lk->locked) {
    80004b1a:	409c                	lw	a5,0(s1)
    80004b1c:	cb89                	beqz	a5,80004b2e <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004b1e:	85ca                	mv	a1,s2
    80004b20:	8526                	mv	a0,s1
    80004b22:	ffffe097          	auipc	ra,0xffffe
    80004b26:	d80080e7          	jalr	-640(ra) # 800028a2 <sleep>
  while (lk->locked) {
    80004b2a:	409c                	lw	a5,0(s1)
    80004b2c:	fbed                	bnez	a5,80004b1e <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004b2e:	4785                	li	a5,1
    80004b30:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004b32:	ffffd097          	auipc	ra,0xffffd
    80004b36:	55c080e7          	jalr	1372(ra) # 8000208e <myproc>
    80004b3a:	5d1c                	lw	a5,56(a0)
    80004b3c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004b3e:	854a                	mv	a0,s2
    80004b40:	ffffc097          	auipc	ra,0xffffc
    80004b44:	2ae080e7          	jalr	686(ra) # 80000dee <release>
}
    80004b48:	60e2                	ld	ra,24(sp)
    80004b4a:	6442                	ld	s0,16(sp)
    80004b4c:	64a2                	ld	s1,8(sp)
    80004b4e:	6902                	ld	s2,0(sp)
    80004b50:	6105                	addi	sp,sp,32
    80004b52:	8082                	ret

0000000080004b54 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004b54:	1101                	addi	sp,sp,-32
    80004b56:	ec06                	sd	ra,24(sp)
    80004b58:	e822                	sd	s0,16(sp)
    80004b5a:	e426                	sd	s1,8(sp)
    80004b5c:	e04a                	sd	s2,0(sp)
    80004b5e:	1000                	addi	s0,sp,32
    80004b60:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004b62:	00850913          	addi	s2,a0,8
    80004b66:	854a                	mv	a0,s2
    80004b68:	ffffc097          	auipc	ra,0xffffc
    80004b6c:	1d2080e7          	jalr	466(ra) # 80000d3a <acquire>
  lk->locked = 0;
    80004b70:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004b74:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004b78:	8526                	mv	a0,s1
    80004b7a:	ffffe097          	auipc	ra,0xffffe
    80004b7e:	ea8080e7          	jalr	-344(ra) # 80002a22 <wakeup>
  release(&lk->lk);
    80004b82:	854a                	mv	a0,s2
    80004b84:	ffffc097          	auipc	ra,0xffffc
    80004b88:	26a080e7          	jalr	618(ra) # 80000dee <release>
}
    80004b8c:	60e2                	ld	ra,24(sp)
    80004b8e:	6442                	ld	s0,16(sp)
    80004b90:	64a2                	ld	s1,8(sp)
    80004b92:	6902                	ld	s2,0(sp)
    80004b94:	6105                	addi	sp,sp,32
    80004b96:	8082                	ret

0000000080004b98 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004b98:	7179                	addi	sp,sp,-48
    80004b9a:	f406                	sd	ra,40(sp)
    80004b9c:	f022                	sd	s0,32(sp)
    80004b9e:	ec26                	sd	s1,24(sp)
    80004ba0:	e84a                	sd	s2,16(sp)
    80004ba2:	e44e                	sd	s3,8(sp)
    80004ba4:	1800                	addi	s0,sp,48
    80004ba6:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004ba8:	00850913          	addi	s2,a0,8
    80004bac:	854a                	mv	a0,s2
    80004bae:	ffffc097          	auipc	ra,0xffffc
    80004bb2:	18c080e7          	jalr	396(ra) # 80000d3a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004bb6:	409c                	lw	a5,0(s1)
    80004bb8:	ef99                	bnez	a5,80004bd6 <holdingsleep+0x3e>
    80004bba:	4481                	li	s1,0
  release(&lk->lk);
    80004bbc:	854a                	mv	a0,s2
    80004bbe:	ffffc097          	auipc	ra,0xffffc
    80004bc2:	230080e7          	jalr	560(ra) # 80000dee <release>
  return r;
}
    80004bc6:	8526                	mv	a0,s1
    80004bc8:	70a2                	ld	ra,40(sp)
    80004bca:	7402                	ld	s0,32(sp)
    80004bcc:	64e2                	ld	s1,24(sp)
    80004bce:	6942                	ld	s2,16(sp)
    80004bd0:	69a2                	ld	s3,8(sp)
    80004bd2:	6145                	addi	sp,sp,48
    80004bd4:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004bd6:	0284a983          	lw	s3,40(s1)
    80004bda:	ffffd097          	auipc	ra,0xffffd
    80004bde:	4b4080e7          	jalr	1204(ra) # 8000208e <myproc>
    80004be2:	5d04                	lw	s1,56(a0)
    80004be4:	413484b3          	sub	s1,s1,s3
    80004be8:	0014b493          	seqz	s1,s1
    80004bec:	bfc1                	j	80004bbc <holdingsleep+0x24>

0000000080004bee <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004bee:	1141                	addi	sp,sp,-16
    80004bf0:	e406                	sd	ra,8(sp)
    80004bf2:	e022                	sd	s0,0(sp)
    80004bf4:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004bf6:	00004597          	auipc	a1,0x4
    80004bfa:	bc258593          	addi	a1,a1,-1086 # 800087b8 <syscalls+0x250>
    80004bfe:	00049517          	auipc	a0,0x49
    80004c02:	e6250513          	addi	a0,a0,-414 # 8004da60 <ftable>
    80004c06:	ffffc097          	auipc	ra,0xffffc
    80004c0a:	0a4080e7          	jalr	164(ra) # 80000caa <initlock>
}
    80004c0e:	60a2                	ld	ra,8(sp)
    80004c10:	6402                	ld	s0,0(sp)
    80004c12:	0141                	addi	sp,sp,16
    80004c14:	8082                	ret

0000000080004c16 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004c16:	1101                	addi	sp,sp,-32
    80004c18:	ec06                	sd	ra,24(sp)
    80004c1a:	e822                	sd	s0,16(sp)
    80004c1c:	e426                	sd	s1,8(sp)
    80004c1e:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004c20:	00049517          	auipc	a0,0x49
    80004c24:	e4050513          	addi	a0,a0,-448 # 8004da60 <ftable>
    80004c28:	ffffc097          	auipc	ra,0xffffc
    80004c2c:	112080e7          	jalr	274(ra) # 80000d3a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004c30:	00049497          	auipc	s1,0x49
    80004c34:	e4848493          	addi	s1,s1,-440 # 8004da78 <ftable+0x18>
    80004c38:	0004a717          	auipc	a4,0x4a
    80004c3c:	de070713          	addi	a4,a4,-544 # 8004ea18 <ftable+0xfb8>
    if(f->ref == 0){
    80004c40:	40dc                	lw	a5,4(s1)
    80004c42:	cf99                	beqz	a5,80004c60 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004c44:	02848493          	addi	s1,s1,40
    80004c48:	fee49ce3          	bne	s1,a4,80004c40 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004c4c:	00049517          	auipc	a0,0x49
    80004c50:	e1450513          	addi	a0,a0,-492 # 8004da60 <ftable>
    80004c54:	ffffc097          	auipc	ra,0xffffc
    80004c58:	19a080e7          	jalr	410(ra) # 80000dee <release>
  return 0;
    80004c5c:	4481                	li	s1,0
    80004c5e:	a819                	j	80004c74 <filealloc+0x5e>
      f->ref = 1;
    80004c60:	4785                	li	a5,1
    80004c62:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004c64:	00049517          	auipc	a0,0x49
    80004c68:	dfc50513          	addi	a0,a0,-516 # 8004da60 <ftable>
    80004c6c:	ffffc097          	auipc	ra,0xffffc
    80004c70:	182080e7          	jalr	386(ra) # 80000dee <release>
}
    80004c74:	8526                	mv	a0,s1
    80004c76:	60e2                	ld	ra,24(sp)
    80004c78:	6442                	ld	s0,16(sp)
    80004c7a:	64a2                	ld	s1,8(sp)
    80004c7c:	6105                	addi	sp,sp,32
    80004c7e:	8082                	ret

0000000080004c80 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004c80:	1101                	addi	sp,sp,-32
    80004c82:	ec06                	sd	ra,24(sp)
    80004c84:	e822                	sd	s0,16(sp)
    80004c86:	e426                	sd	s1,8(sp)
    80004c88:	1000                	addi	s0,sp,32
    80004c8a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004c8c:	00049517          	auipc	a0,0x49
    80004c90:	dd450513          	addi	a0,a0,-556 # 8004da60 <ftable>
    80004c94:	ffffc097          	auipc	ra,0xffffc
    80004c98:	0a6080e7          	jalr	166(ra) # 80000d3a <acquire>
  if(f->ref < 1)
    80004c9c:	40dc                	lw	a5,4(s1)
    80004c9e:	02f05263          	blez	a5,80004cc2 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004ca2:	2785                	addiw	a5,a5,1
    80004ca4:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004ca6:	00049517          	auipc	a0,0x49
    80004caa:	dba50513          	addi	a0,a0,-582 # 8004da60 <ftable>
    80004cae:	ffffc097          	auipc	ra,0xffffc
    80004cb2:	140080e7          	jalr	320(ra) # 80000dee <release>
  return f;
}
    80004cb6:	8526                	mv	a0,s1
    80004cb8:	60e2                	ld	ra,24(sp)
    80004cba:	6442                	ld	s0,16(sp)
    80004cbc:	64a2                	ld	s1,8(sp)
    80004cbe:	6105                	addi	sp,sp,32
    80004cc0:	8082                	ret
    panic("filedup");
    80004cc2:	00004517          	auipc	a0,0x4
    80004cc6:	afe50513          	addi	a0,a0,-1282 # 800087c0 <syscalls+0x258>
    80004cca:	ffffc097          	auipc	ra,0xffffc
    80004cce:	91a080e7          	jalr	-1766(ra) # 800005e4 <panic>

0000000080004cd2 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004cd2:	7139                	addi	sp,sp,-64
    80004cd4:	fc06                	sd	ra,56(sp)
    80004cd6:	f822                	sd	s0,48(sp)
    80004cd8:	f426                	sd	s1,40(sp)
    80004cda:	f04a                	sd	s2,32(sp)
    80004cdc:	ec4e                	sd	s3,24(sp)
    80004cde:	e852                	sd	s4,16(sp)
    80004ce0:	e456                	sd	s5,8(sp)
    80004ce2:	0080                	addi	s0,sp,64
    80004ce4:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004ce6:	00049517          	auipc	a0,0x49
    80004cea:	d7a50513          	addi	a0,a0,-646 # 8004da60 <ftable>
    80004cee:	ffffc097          	auipc	ra,0xffffc
    80004cf2:	04c080e7          	jalr	76(ra) # 80000d3a <acquire>
  if(f->ref < 1)
    80004cf6:	40dc                	lw	a5,4(s1)
    80004cf8:	06f05163          	blez	a5,80004d5a <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004cfc:	37fd                	addiw	a5,a5,-1
    80004cfe:	0007871b          	sext.w	a4,a5
    80004d02:	c0dc                	sw	a5,4(s1)
    80004d04:	06e04363          	bgtz	a4,80004d6a <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004d08:	0004a903          	lw	s2,0(s1)
    80004d0c:	0094ca83          	lbu	s5,9(s1)
    80004d10:	0104ba03          	ld	s4,16(s1)
    80004d14:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004d18:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004d1c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004d20:	00049517          	auipc	a0,0x49
    80004d24:	d4050513          	addi	a0,a0,-704 # 8004da60 <ftable>
    80004d28:	ffffc097          	auipc	ra,0xffffc
    80004d2c:	0c6080e7          	jalr	198(ra) # 80000dee <release>

  if(ff.type == FD_PIPE){
    80004d30:	4785                	li	a5,1
    80004d32:	04f90d63          	beq	s2,a5,80004d8c <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004d36:	3979                	addiw	s2,s2,-2
    80004d38:	4785                	li	a5,1
    80004d3a:	0527e063          	bltu	a5,s2,80004d7a <fileclose+0xa8>
    begin_op();
    80004d3e:	00000097          	auipc	ra,0x0
    80004d42:	ac2080e7          	jalr	-1342(ra) # 80004800 <begin_op>
    iput(ff.ip);
    80004d46:	854e                	mv	a0,s3
    80004d48:	fffff097          	auipc	ra,0xfffff
    80004d4c:	2b2080e7          	jalr	690(ra) # 80003ffa <iput>
    end_op();
    80004d50:	00000097          	auipc	ra,0x0
    80004d54:	b30080e7          	jalr	-1232(ra) # 80004880 <end_op>
    80004d58:	a00d                	j	80004d7a <fileclose+0xa8>
    panic("fileclose");
    80004d5a:	00004517          	auipc	a0,0x4
    80004d5e:	a6e50513          	addi	a0,a0,-1426 # 800087c8 <syscalls+0x260>
    80004d62:	ffffc097          	auipc	ra,0xffffc
    80004d66:	882080e7          	jalr	-1918(ra) # 800005e4 <panic>
    release(&ftable.lock);
    80004d6a:	00049517          	auipc	a0,0x49
    80004d6e:	cf650513          	addi	a0,a0,-778 # 8004da60 <ftable>
    80004d72:	ffffc097          	auipc	ra,0xffffc
    80004d76:	07c080e7          	jalr	124(ra) # 80000dee <release>
  }
}
    80004d7a:	70e2                	ld	ra,56(sp)
    80004d7c:	7442                	ld	s0,48(sp)
    80004d7e:	74a2                	ld	s1,40(sp)
    80004d80:	7902                	ld	s2,32(sp)
    80004d82:	69e2                	ld	s3,24(sp)
    80004d84:	6a42                	ld	s4,16(sp)
    80004d86:	6aa2                	ld	s5,8(sp)
    80004d88:	6121                	addi	sp,sp,64
    80004d8a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004d8c:	85d6                	mv	a1,s5
    80004d8e:	8552                	mv	a0,s4
    80004d90:	00000097          	auipc	ra,0x0
    80004d94:	372080e7          	jalr	882(ra) # 80005102 <pipeclose>
    80004d98:	b7cd                	j	80004d7a <fileclose+0xa8>

0000000080004d9a <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004d9a:	715d                	addi	sp,sp,-80
    80004d9c:	e486                	sd	ra,72(sp)
    80004d9e:	e0a2                	sd	s0,64(sp)
    80004da0:	fc26                	sd	s1,56(sp)
    80004da2:	f84a                	sd	s2,48(sp)
    80004da4:	f44e                	sd	s3,40(sp)
    80004da6:	0880                	addi	s0,sp,80
    80004da8:	84aa                	mv	s1,a0
    80004daa:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004dac:	ffffd097          	auipc	ra,0xffffd
    80004db0:	2e2080e7          	jalr	738(ra) # 8000208e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004db4:	409c                	lw	a5,0(s1)
    80004db6:	37f9                	addiw	a5,a5,-2
    80004db8:	4705                	li	a4,1
    80004dba:	04f76763          	bltu	a4,a5,80004e08 <filestat+0x6e>
    80004dbe:	892a                	mv	s2,a0
    ilock(f->ip);
    80004dc0:	6c88                	ld	a0,24(s1)
    80004dc2:	fffff097          	auipc	ra,0xfffff
    80004dc6:	07e080e7          	jalr	126(ra) # 80003e40 <ilock>
    stati(f->ip, &st);
    80004dca:	fb840593          	addi	a1,s0,-72
    80004dce:	6c88                	ld	a0,24(s1)
    80004dd0:	fffff097          	auipc	ra,0xfffff
    80004dd4:	2fa080e7          	jalr	762(ra) # 800040ca <stati>
    iunlock(f->ip);
    80004dd8:	6c88                	ld	a0,24(s1)
    80004dda:	fffff097          	auipc	ra,0xfffff
    80004dde:	128080e7          	jalr	296(ra) # 80003f02 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004de2:	46e1                	li	a3,24
    80004de4:	fb840613          	addi	a2,s0,-72
    80004de8:	85ce                	mv	a1,s3
    80004dea:	05093503          	ld	a0,80(s2)
    80004dee:	ffffd097          	auipc	ra,0xffffd
    80004df2:	c44080e7          	jalr	-956(ra) # 80001a32 <copyout>
    80004df6:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004dfa:	60a6                	ld	ra,72(sp)
    80004dfc:	6406                	ld	s0,64(sp)
    80004dfe:	74e2                	ld	s1,56(sp)
    80004e00:	7942                	ld	s2,48(sp)
    80004e02:	79a2                	ld	s3,40(sp)
    80004e04:	6161                	addi	sp,sp,80
    80004e06:	8082                	ret
  return -1;
    80004e08:	557d                	li	a0,-1
    80004e0a:	bfc5                	j	80004dfa <filestat+0x60>

0000000080004e0c <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004e0c:	7179                	addi	sp,sp,-48
    80004e0e:	f406                	sd	ra,40(sp)
    80004e10:	f022                	sd	s0,32(sp)
    80004e12:	ec26                	sd	s1,24(sp)
    80004e14:	e84a                	sd	s2,16(sp)
    80004e16:	e44e                	sd	s3,8(sp)
    80004e18:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004e1a:	00854783          	lbu	a5,8(a0)
    80004e1e:	c3d5                	beqz	a5,80004ec2 <fileread+0xb6>
    80004e20:	84aa                	mv	s1,a0
    80004e22:	89ae                	mv	s3,a1
    80004e24:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004e26:	411c                	lw	a5,0(a0)
    80004e28:	4705                	li	a4,1
    80004e2a:	04e78963          	beq	a5,a4,80004e7c <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004e2e:	470d                	li	a4,3
    80004e30:	04e78d63          	beq	a5,a4,80004e8a <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004e34:	4709                	li	a4,2
    80004e36:	06e79e63          	bne	a5,a4,80004eb2 <fileread+0xa6>
    ilock(f->ip);
    80004e3a:	6d08                	ld	a0,24(a0)
    80004e3c:	fffff097          	auipc	ra,0xfffff
    80004e40:	004080e7          	jalr	4(ra) # 80003e40 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004e44:	874a                	mv	a4,s2
    80004e46:	5094                	lw	a3,32(s1)
    80004e48:	864e                	mv	a2,s3
    80004e4a:	4585                	li	a1,1
    80004e4c:	6c88                	ld	a0,24(s1)
    80004e4e:	fffff097          	auipc	ra,0xfffff
    80004e52:	2a6080e7          	jalr	678(ra) # 800040f4 <readi>
    80004e56:	892a                	mv	s2,a0
    80004e58:	00a05563          	blez	a0,80004e62 <fileread+0x56>
      f->off += r;
    80004e5c:	509c                	lw	a5,32(s1)
    80004e5e:	9fa9                	addw	a5,a5,a0
    80004e60:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004e62:	6c88                	ld	a0,24(s1)
    80004e64:	fffff097          	auipc	ra,0xfffff
    80004e68:	09e080e7          	jalr	158(ra) # 80003f02 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004e6c:	854a                	mv	a0,s2
    80004e6e:	70a2                	ld	ra,40(sp)
    80004e70:	7402                	ld	s0,32(sp)
    80004e72:	64e2                	ld	s1,24(sp)
    80004e74:	6942                	ld	s2,16(sp)
    80004e76:	69a2                	ld	s3,8(sp)
    80004e78:	6145                	addi	sp,sp,48
    80004e7a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004e7c:	6908                	ld	a0,16(a0)
    80004e7e:	00000097          	auipc	ra,0x0
    80004e82:	3f4080e7          	jalr	1012(ra) # 80005272 <piperead>
    80004e86:	892a                	mv	s2,a0
    80004e88:	b7d5                	j	80004e6c <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004e8a:	02451783          	lh	a5,36(a0)
    80004e8e:	03079693          	slli	a3,a5,0x30
    80004e92:	92c1                	srli	a3,a3,0x30
    80004e94:	4725                	li	a4,9
    80004e96:	02d76863          	bltu	a4,a3,80004ec6 <fileread+0xba>
    80004e9a:	0792                	slli	a5,a5,0x4
    80004e9c:	00049717          	auipc	a4,0x49
    80004ea0:	b2470713          	addi	a4,a4,-1244 # 8004d9c0 <devsw>
    80004ea4:	97ba                	add	a5,a5,a4
    80004ea6:	639c                	ld	a5,0(a5)
    80004ea8:	c38d                	beqz	a5,80004eca <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004eaa:	4505                	li	a0,1
    80004eac:	9782                	jalr	a5
    80004eae:	892a                	mv	s2,a0
    80004eb0:	bf75                	j	80004e6c <fileread+0x60>
    panic("fileread");
    80004eb2:	00004517          	auipc	a0,0x4
    80004eb6:	92650513          	addi	a0,a0,-1754 # 800087d8 <syscalls+0x270>
    80004eba:	ffffb097          	auipc	ra,0xffffb
    80004ebe:	72a080e7          	jalr	1834(ra) # 800005e4 <panic>
    return -1;
    80004ec2:	597d                	li	s2,-1
    80004ec4:	b765                	j	80004e6c <fileread+0x60>
      return -1;
    80004ec6:	597d                	li	s2,-1
    80004ec8:	b755                	j	80004e6c <fileread+0x60>
    80004eca:	597d                	li	s2,-1
    80004ecc:	b745                	j	80004e6c <fileread+0x60>

0000000080004ece <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004ece:	00954783          	lbu	a5,9(a0)
    80004ed2:	14078563          	beqz	a5,8000501c <filewrite+0x14e>
{
    80004ed6:	715d                	addi	sp,sp,-80
    80004ed8:	e486                	sd	ra,72(sp)
    80004eda:	e0a2                	sd	s0,64(sp)
    80004edc:	fc26                	sd	s1,56(sp)
    80004ede:	f84a                	sd	s2,48(sp)
    80004ee0:	f44e                	sd	s3,40(sp)
    80004ee2:	f052                	sd	s4,32(sp)
    80004ee4:	ec56                	sd	s5,24(sp)
    80004ee6:	e85a                	sd	s6,16(sp)
    80004ee8:	e45e                	sd	s7,8(sp)
    80004eea:	e062                	sd	s8,0(sp)
    80004eec:	0880                	addi	s0,sp,80
    80004eee:	892a                	mv	s2,a0
    80004ef0:	8aae                	mv	s5,a1
    80004ef2:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004ef4:	411c                	lw	a5,0(a0)
    80004ef6:	4705                	li	a4,1
    80004ef8:	02e78263          	beq	a5,a4,80004f1c <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004efc:	470d                	li	a4,3
    80004efe:	02e78563          	beq	a5,a4,80004f28 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004f02:	4709                	li	a4,2
    80004f04:	10e79463          	bne	a5,a4,8000500c <filewrite+0x13e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004f08:	0ec05e63          	blez	a2,80005004 <filewrite+0x136>
    int i = 0;
    80004f0c:	4981                	li	s3,0
    80004f0e:	6b05                	lui	s6,0x1
    80004f10:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004f14:	6b85                	lui	s7,0x1
    80004f16:	c00b8b9b          	addiw	s7,s7,-1024
    80004f1a:	a851                	j	80004fae <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80004f1c:	6908                	ld	a0,16(a0)
    80004f1e:	00000097          	auipc	ra,0x0
    80004f22:	254080e7          	jalr	596(ra) # 80005172 <pipewrite>
    80004f26:	a85d                	j	80004fdc <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004f28:	02451783          	lh	a5,36(a0)
    80004f2c:	03079693          	slli	a3,a5,0x30
    80004f30:	92c1                	srli	a3,a3,0x30
    80004f32:	4725                	li	a4,9
    80004f34:	0ed76663          	bltu	a4,a3,80005020 <filewrite+0x152>
    80004f38:	0792                	slli	a5,a5,0x4
    80004f3a:	00049717          	auipc	a4,0x49
    80004f3e:	a8670713          	addi	a4,a4,-1402 # 8004d9c0 <devsw>
    80004f42:	97ba                	add	a5,a5,a4
    80004f44:	679c                	ld	a5,8(a5)
    80004f46:	cff9                	beqz	a5,80005024 <filewrite+0x156>
    ret = devsw[f->major].write(1, addr, n);
    80004f48:	4505                	li	a0,1
    80004f4a:	9782                	jalr	a5
    80004f4c:	a841                	j	80004fdc <filewrite+0x10e>
    80004f4e:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004f52:	00000097          	auipc	ra,0x0
    80004f56:	8ae080e7          	jalr	-1874(ra) # 80004800 <begin_op>
      ilock(f->ip);
    80004f5a:	01893503          	ld	a0,24(s2)
    80004f5e:	fffff097          	auipc	ra,0xfffff
    80004f62:	ee2080e7          	jalr	-286(ra) # 80003e40 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004f66:	8762                	mv	a4,s8
    80004f68:	02092683          	lw	a3,32(s2)
    80004f6c:	01598633          	add	a2,s3,s5
    80004f70:	4585                	li	a1,1
    80004f72:	01893503          	ld	a0,24(s2)
    80004f76:	fffff097          	auipc	ra,0xfffff
    80004f7a:	276080e7          	jalr	630(ra) # 800041ec <writei>
    80004f7e:	84aa                	mv	s1,a0
    80004f80:	02a05f63          	blez	a0,80004fbe <filewrite+0xf0>
        f->off += r;
    80004f84:	02092783          	lw	a5,32(s2)
    80004f88:	9fa9                	addw	a5,a5,a0
    80004f8a:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004f8e:	01893503          	ld	a0,24(s2)
    80004f92:	fffff097          	auipc	ra,0xfffff
    80004f96:	f70080e7          	jalr	-144(ra) # 80003f02 <iunlock>
      end_op();
    80004f9a:	00000097          	auipc	ra,0x0
    80004f9e:	8e6080e7          	jalr	-1818(ra) # 80004880 <end_op>

      if(r < 0)
        break;
      if(r != n1)
    80004fa2:	049c1963          	bne	s8,s1,80004ff4 <filewrite+0x126>
        panic("short filewrite");
      i += r;
    80004fa6:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004faa:	0349d663          	bge	s3,s4,80004fd6 <filewrite+0x108>
      int n1 = n - i;
    80004fae:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004fb2:	84be                	mv	s1,a5
    80004fb4:	2781                	sext.w	a5,a5
    80004fb6:	f8fb5ce3          	bge	s6,a5,80004f4e <filewrite+0x80>
    80004fba:	84de                	mv	s1,s7
    80004fbc:	bf49                	j	80004f4e <filewrite+0x80>
      iunlock(f->ip);
    80004fbe:	01893503          	ld	a0,24(s2)
    80004fc2:	fffff097          	auipc	ra,0xfffff
    80004fc6:	f40080e7          	jalr	-192(ra) # 80003f02 <iunlock>
      end_op();
    80004fca:	00000097          	auipc	ra,0x0
    80004fce:	8b6080e7          	jalr	-1866(ra) # 80004880 <end_op>
      if(r < 0)
    80004fd2:	fc04d8e3          	bgez	s1,80004fa2 <filewrite+0xd4>
    }
    ret = (i == n ? n : -1);
    80004fd6:	8552                	mv	a0,s4
    80004fd8:	033a1863          	bne	s4,s3,80005008 <filewrite+0x13a>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004fdc:	60a6                	ld	ra,72(sp)
    80004fde:	6406                	ld	s0,64(sp)
    80004fe0:	74e2                	ld	s1,56(sp)
    80004fe2:	7942                	ld	s2,48(sp)
    80004fe4:	79a2                	ld	s3,40(sp)
    80004fe6:	7a02                	ld	s4,32(sp)
    80004fe8:	6ae2                	ld	s5,24(sp)
    80004fea:	6b42                	ld	s6,16(sp)
    80004fec:	6ba2                	ld	s7,8(sp)
    80004fee:	6c02                	ld	s8,0(sp)
    80004ff0:	6161                	addi	sp,sp,80
    80004ff2:	8082                	ret
        panic("short filewrite");
    80004ff4:	00003517          	auipc	a0,0x3
    80004ff8:	7f450513          	addi	a0,a0,2036 # 800087e8 <syscalls+0x280>
    80004ffc:	ffffb097          	auipc	ra,0xffffb
    80005000:	5e8080e7          	jalr	1512(ra) # 800005e4 <panic>
    int i = 0;
    80005004:	4981                	li	s3,0
    80005006:	bfc1                	j	80004fd6 <filewrite+0x108>
    ret = (i == n ? n : -1);
    80005008:	557d                	li	a0,-1
    8000500a:	bfc9                	j	80004fdc <filewrite+0x10e>
    panic("filewrite");
    8000500c:	00003517          	auipc	a0,0x3
    80005010:	7ec50513          	addi	a0,a0,2028 # 800087f8 <syscalls+0x290>
    80005014:	ffffb097          	auipc	ra,0xffffb
    80005018:	5d0080e7          	jalr	1488(ra) # 800005e4 <panic>
    return -1;
    8000501c:	557d                	li	a0,-1
}
    8000501e:	8082                	ret
      return -1;
    80005020:	557d                	li	a0,-1
    80005022:	bf6d                	j	80004fdc <filewrite+0x10e>
    80005024:	557d                	li	a0,-1
    80005026:	bf5d                	j	80004fdc <filewrite+0x10e>

0000000080005028 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80005028:	7179                	addi	sp,sp,-48
    8000502a:	f406                	sd	ra,40(sp)
    8000502c:	f022                	sd	s0,32(sp)
    8000502e:	ec26                	sd	s1,24(sp)
    80005030:	e84a                	sd	s2,16(sp)
    80005032:	e44e                	sd	s3,8(sp)
    80005034:	e052                	sd	s4,0(sp)
    80005036:	1800                	addi	s0,sp,48
    80005038:	84aa                	mv	s1,a0
    8000503a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000503c:	0005b023          	sd	zero,0(a1)
    80005040:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80005044:	00000097          	auipc	ra,0x0
    80005048:	bd2080e7          	jalr	-1070(ra) # 80004c16 <filealloc>
    8000504c:	e088                	sd	a0,0(s1)
    8000504e:	c551                	beqz	a0,800050da <pipealloc+0xb2>
    80005050:	00000097          	auipc	ra,0x0
    80005054:	bc6080e7          	jalr	-1082(ra) # 80004c16 <filealloc>
    80005058:	00aa3023          	sd	a0,0(s4)
    8000505c:	c92d                	beqz	a0,800050ce <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000505e:	ffffc097          	auipc	ra,0xffffc
    80005062:	b9e080e7          	jalr	-1122(ra) # 80000bfc <kalloc>
    80005066:	892a                	mv	s2,a0
    80005068:	c125                	beqz	a0,800050c8 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    8000506a:	4985                	li	s3,1
    8000506c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80005070:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80005074:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80005078:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000507c:	00003597          	auipc	a1,0x3
    80005080:	78c58593          	addi	a1,a1,1932 # 80008808 <syscalls+0x2a0>
    80005084:	ffffc097          	auipc	ra,0xffffc
    80005088:	c26080e7          	jalr	-986(ra) # 80000caa <initlock>
  (*f0)->type = FD_PIPE;
    8000508c:	609c                	ld	a5,0(s1)
    8000508e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80005092:	609c                	ld	a5,0(s1)
    80005094:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80005098:	609c                	ld	a5,0(s1)
    8000509a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000509e:	609c                	ld	a5,0(s1)
    800050a0:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800050a4:	000a3783          	ld	a5,0(s4)
    800050a8:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800050ac:	000a3783          	ld	a5,0(s4)
    800050b0:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800050b4:	000a3783          	ld	a5,0(s4)
    800050b8:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800050bc:	000a3783          	ld	a5,0(s4)
    800050c0:	0127b823          	sd	s2,16(a5)
  return 0;
    800050c4:	4501                	li	a0,0
    800050c6:	a025                	j	800050ee <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800050c8:	6088                	ld	a0,0(s1)
    800050ca:	e501                	bnez	a0,800050d2 <pipealloc+0xaa>
    800050cc:	a039                	j	800050da <pipealloc+0xb2>
    800050ce:	6088                	ld	a0,0(s1)
    800050d0:	c51d                	beqz	a0,800050fe <pipealloc+0xd6>
    fileclose(*f0);
    800050d2:	00000097          	auipc	ra,0x0
    800050d6:	c00080e7          	jalr	-1024(ra) # 80004cd2 <fileclose>
  if(*f1)
    800050da:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800050de:	557d                	li	a0,-1
  if(*f1)
    800050e0:	c799                	beqz	a5,800050ee <pipealloc+0xc6>
    fileclose(*f1);
    800050e2:	853e                	mv	a0,a5
    800050e4:	00000097          	auipc	ra,0x0
    800050e8:	bee080e7          	jalr	-1042(ra) # 80004cd2 <fileclose>
  return -1;
    800050ec:	557d                	li	a0,-1
}
    800050ee:	70a2                	ld	ra,40(sp)
    800050f0:	7402                	ld	s0,32(sp)
    800050f2:	64e2                	ld	s1,24(sp)
    800050f4:	6942                	ld	s2,16(sp)
    800050f6:	69a2                	ld	s3,8(sp)
    800050f8:	6a02                	ld	s4,0(sp)
    800050fa:	6145                	addi	sp,sp,48
    800050fc:	8082                	ret
  return -1;
    800050fe:	557d                	li	a0,-1
    80005100:	b7fd                	j	800050ee <pipealloc+0xc6>

0000000080005102 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80005102:	1101                	addi	sp,sp,-32
    80005104:	ec06                	sd	ra,24(sp)
    80005106:	e822                	sd	s0,16(sp)
    80005108:	e426                	sd	s1,8(sp)
    8000510a:	e04a                	sd	s2,0(sp)
    8000510c:	1000                	addi	s0,sp,32
    8000510e:	84aa                	mv	s1,a0
    80005110:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80005112:	ffffc097          	auipc	ra,0xffffc
    80005116:	c28080e7          	jalr	-984(ra) # 80000d3a <acquire>
  if(writable){
    8000511a:	02090d63          	beqz	s2,80005154 <pipeclose+0x52>
    pi->writeopen = 0;
    8000511e:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80005122:	21848513          	addi	a0,s1,536
    80005126:	ffffe097          	auipc	ra,0xffffe
    8000512a:	8fc080e7          	jalr	-1796(ra) # 80002a22 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000512e:	2204b783          	ld	a5,544(s1)
    80005132:	eb95                	bnez	a5,80005166 <pipeclose+0x64>
    release(&pi->lock);
    80005134:	8526                	mv	a0,s1
    80005136:	ffffc097          	auipc	ra,0xffffc
    8000513a:	cb8080e7          	jalr	-840(ra) # 80000dee <release>
    kfree((char*)pi);
    8000513e:	8526                	mv	a0,s1
    80005140:	ffffc097          	auipc	ra,0xffffc
    80005144:	94a080e7          	jalr	-1718(ra) # 80000a8a <kfree>
  } else
    release(&pi->lock);
}
    80005148:	60e2                	ld	ra,24(sp)
    8000514a:	6442                	ld	s0,16(sp)
    8000514c:	64a2                	ld	s1,8(sp)
    8000514e:	6902                	ld	s2,0(sp)
    80005150:	6105                	addi	sp,sp,32
    80005152:	8082                	ret
    pi->readopen = 0;
    80005154:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80005158:	21c48513          	addi	a0,s1,540
    8000515c:	ffffe097          	auipc	ra,0xffffe
    80005160:	8c6080e7          	jalr	-1850(ra) # 80002a22 <wakeup>
    80005164:	b7e9                	j	8000512e <pipeclose+0x2c>
    release(&pi->lock);
    80005166:	8526                	mv	a0,s1
    80005168:	ffffc097          	auipc	ra,0xffffc
    8000516c:	c86080e7          	jalr	-890(ra) # 80000dee <release>
}
    80005170:	bfe1                	j	80005148 <pipeclose+0x46>

0000000080005172 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80005172:	711d                	addi	sp,sp,-96
    80005174:	ec86                	sd	ra,88(sp)
    80005176:	e8a2                	sd	s0,80(sp)
    80005178:	e4a6                	sd	s1,72(sp)
    8000517a:	e0ca                	sd	s2,64(sp)
    8000517c:	fc4e                	sd	s3,56(sp)
    8000517e:	f852                	sd	s4,48(sp)
    80005180:	f456                	sd	s5,40(sp)
    80005182:	f05a                	sd	s6,32(sp)
    80005184:	ec5e                	sd	s7,24(sp)
    80005186:	e862                	sd	s8,16(sp)
    80005188:	1080                	addi	s0,sp,96
    8000518a:	84aa                	mv	s1,a0
    8000518c:	8b2e                	mv	s6,a1
    8000518e:	8ab2                	mv	s5,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    80005190:	ffffd097          	auipc	ra,0xffffd
    80005194:	efe080e7          	jalr	-258(ra) # 8000208e <myproc>
    80005198:	892a                	mv	s2,a0

  acquire(&pi->lock);
    8000519a:	8526                	mv	a0,s1
    8000519c:	ffffc097          	auipc	ra,0xffffc
    800051a0:	b9e080e7          	jalr	-1122(ra) # 80000d3a <acquire>
  for(i = 0; i < n; i++){
    800051a4:	09505763          	blez	s5,80005232 <pipewrite+0xc0>
    800051a8:	4b81                	li	s7,0
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || pr->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    800051aa:	21848a13          	addi	s4,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800051ae:	21c48993          	addi	s3,s1,540
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800051b2:	5c7d                	li	s8,-1
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    800051b4:	2184a783          	lw	a5,536(s1)
    800051b8:	21c4a703          	lw	a4,540(s1)
    800051bc:	2007879b          	addiw	a5,a5,512
    800051c0:	02f71b63          	bne	a4,a5,800051f6 <pipewrite+0x84>
      if(pi->readopen == 0 || pr->killed){
    800051c4:	2204a783          	lw	a5,544(s1)
    800051c8:	c3d1                	beqz	a5,8000524c <pipewrite+0xda>
    800051ca:	03092783          	lw	a5,48(s2)
    800051ce:	efbd                	bnez	a5,8000524c <pipewrite+0xda>
      wakeup(&pi->nread);
    800051d0:	8552                	mv	a0,s4
    800051d2:	ffffe097          	auipc	ra,0xffffe
    800051d6:	850080e7          	jalr	-1968(ra) # 80002a22 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800051da:	85a6                	mv	a1,s1
    800051dc:	854e                	mv	a0,s3
    800051de:	ffffd097          	auipc	ra,0xffffd
    800051e2:	6c4080e7          	jalr	1732(ra) # 800028a2 <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    800051e6:	2184a783          	lw	a5,536(s1)
    800051ea:	21c4a703          	lw	a4,540(s1)
    800051ee:	2007879b          	addiw	a5,a5,512
    800051f2:	fcf709e3          	beq	a4,a5,800051c4 <pipewrite+0x52>
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800051f6:	4685                	li	a3,1
    800051f8:	865a                	mv	a2,s6
    800051fa:	faf40593          	addi	a1,s0,-81
    800051fe:	05093503          	ld	a0,80(s2)
    80005202:	ffffc097          	auipc	ra,0xffffc
    80005206:	5bc080e7          	jalr	1468(ra) # 800017be <copyin>
    8000520a:	03850563          	beq	a0,s8,80005234 <pipewrite+0xc2>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000520e:	21c4a783          	lw	a5,540(s1)
    80005212:	0017871b          	addiw	a4,a5,1
    80005216:	20e4ae23          	sw	a4,540(s1)
    8000521a:	1ff7f793          	andi	a5,a5,511
    8000521e:	97a6                	add	a5,a5,s1
    80005220:	faf44703          	lbu	a4,-81(s0)
    80005224:	00e78c23          	sb	a4,24(a5)
  for(i = 0; i < n; i++){
    80005228:	2b85                	addiw	s7,s7,1
    8000522a:	0b05                	addi	s6,s6,1
    8000522c:	f97a94e3          	bne	s5,s7,800051b4 <pipewrite+0x42>
    80005230:	a011                	j	80005234 <pipewrite+0xc2>
    80005232:	4b81                	li	s7,0
  }
  wakeup(&pi->nread);
    80005234:	21848513          	addi	a0,s1,536
    80005238:	ffffd097          	auipc	ra,0xffffd
    8000523c:	7ea080e7          	jalr	2026(ra) # 80002a22 <wakeup>
  release(&pi->lock);
    80005240:	8526                	mv	a0,s1
    80005242:	ffffc097          	auipc	ra,0xffffc
    80005246:	bac080e7          	jalr	-1108(ra) # 80000dee <release>
  return i;
    8000524a:	a039                	j	80005258 <pipewrite+0xe6>
        release(&pi->lock);
    8000524c:	8526                	mv	a0,s1
    8000524e:	ffffc097          	auipc	ra,0xffffc
    80005252:	ba0080e7          	jalr	-1120(ra) # 80000dee <release>
        return -1;
    80005256:	5bfd                	li	s7,-1
}
    80005258:	855e                	mv	a0,s7
    8000525a:	60e6                	ld	ra,88(sp)
    8000525c:	6446                	ld	s0,80(sp)
    8000525e:	64a6                	ld	s1,72(sp)
    80005260:	6906                	ld	s2,64(sp)
    80005262:	79e2                	ld	s3,56(sp)
    80005264:	7a42                	ld	s4,48(sp)
    80005266:	7aa2                	ld	s5,40(sp)
    80005268:	7b02                	ld	s6,32(sp)
    8000526a:	6be2                	ld	s7,24(sp)
    8000526c:	6c42                	ld	s8,16(sp)
    8000526e:	6125                	addi	sp,sp,96
    80005270:	8082                	ret

0000000080005272 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80005272:	715d                	addi	sp,sp,-80
    80005274:	e486                	sd	ra,72(sp)
    80005276:	e0a2                	sd	s0,64(sp)
    80005278:	fc26                	sd	s1,56(sp)
    8000527a:	f84a                	sd	s2,48(sp)
    8000527c:	f44e                	sd	s3,40(sp)
    8000527e:	f052                	sd	s4,32(sp)
    80005280:	ec56                	sd	s5,24(sp)
    80005282:	e85a                	sd	s6,16(sp)
    80005284:	0880                	addi	s0,sp,80
    80005286:	84aa                	mv	s1,a0
    80005288:	892e                	mv	s2,a1
    8000528a:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000528c:	ffffd097          	auipc	ra,0xffffd
    80005290:	e02080e7          	jalr	-510(ra) # 8000208e <myproc>
    80005294:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80005296:	8526                	mv	a0,s1
    80005298:	ffffc097          	auipc	ra,0xffffc
    8000529c:	aa2080e7          	jalr	-1374(ra) # 80000d3a <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800052a0:	2184a703          	lw	a4,536(s1)
    800052a4:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800052a8:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800052ac:	02f71463          	bne	a4,a5,800052d4 <piperead+0x62>
    800052b0:	2244a783          	lw	a5,548(s1)
    800052b4:	c385                	beqz	a5,800052d4 <piperead+0x62>
    if(pr->killed){
    800052b6:	030a2783          	lw	a5,48(s4)
    800052ba:	ebc1                	bnez	a5,8000534a <piperead+0xd8>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800052bc:	85a6                	mv	a1,s1
    800052be:	854e                	mv	a0,s3
    800052c0:	ffffd097          	auipc	ra,0xffffd
    800052c4:	5e2080e7          	jalr	1506(ra) # 800028a2 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800052c8:	2184a703          	lw	a4,536(s1)
    800052cc:	21c4a783          	lw	a5,540(s1)
    800052d0:	fef700e3          	beq	a4,a5,800052b0 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800052d4:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800052d6:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800052d8:	05505363          	blez	s5,8000531e <piperead+0xac>
    if(pi->nread == pi->nwrite)
    800052dc:	2184a783          	lw	a5,536(s1)
    800052e0:	21c4a703          	lw	a4,540(s1)
    800052e4:	02f70d63          	beq	a4,a5,8000531e <piperead+0xac>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800052e8:	0017871b          	addiw	a4,a5,1
    800052ec:	20e4ac23          	sw	a4,536(s1)
    800052f0:	1ff7f793          	andi	a5,a5,511
    800052f4:	97a6                	add	a5,a5,s1
    800052f6:	0187c783          	lbu	a5,24(a5)
    800052fa:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800052fe:	4685                	li	a3,1
    80005300:	fbf40613          	addi	a2,s0,-65
    80005304:	85ca                	mv	a1,s2
    80005306:	050a3503          	ld	a0,80(s4)
    8000530a:	ffffc097          	auipc	ra,0xffffc
    8000530e:	728080e7          	jalr	1832(ra) # 80001a32 <copyout>
    80005312:	01650663          	beq	a0,s6,8000531e <piperead+0xac>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005316:	2985                	addiw	s3,s3,1
    80005318:	0905                	addi	s2,s2,1
    8000531a:	fd3a91e3          	bne	s5,s3,800052dc <piperead+0x6a>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000531e:	21c48513          	addi	a0,s1,540
    80005322:	ffffd097          	auipc	ra,0xffffd
    80005326:	700080e7          	jalr	1792(ra) # 80002a22 <wakeup>
  release(&pi->lock);
    8000532a:	8526                	mv	a0,s1
    8000532c:	ffffc097          	auipc	ra,0xffffc
    80005330:	ac2080e7          	jalr	-1342(ra) # 80000dee <release>
  return i;
}
    80005334:	854e                	mv	a0,s3
    80005336:	60a6                	ld	ra,72(sp)
    80005338:	6406                	ld	s0,64(sp)
    8000533a:	74e2                	ld	s1,56(sp)
    8000533c:	7942                	ld	s2,48(sp)
    8000533e:	79a2                	ld	s3,40(sp)
    80005340:	7a02                	ld	s4,32(sp)
    80005342:	6ae2                	ld	s5,24(sp)
    80005344:	6b42                	ld	s6,16(sp)
    80005346:	6161                	addi	sp,sp,80
    80005348:	8082                	ret
      release(&pi->lock);
    8000534a:	8526                	mv	a0,s1
    8000534c:	ffffc097          	auipc	ra,0xffffc
    80005350:	aa2080e7          	jalr	-1374(ra) # 80000dee <release>
      return -1;
    80005354:	59fd                	li	s3,-1
    80005356:	bff9                	j	80005334 <piperead+0xc2>

0000000080005358 <exec>:
#include "types.h"

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset,
                   uint sz);

int exec(char *path, char **argv) {
    80005358:	de010113          	addi	sp,sp,-544
    8000535c:	20113c23          	sd	ra,536(sp)
    80005360:	20813823          	sd	s0,528(sp)
    80005364:	20913423          	sd	s1,520(sp)
    80005368:	21213023          	sd	s2,512(sp)
    8000536c:	ffce                	sd	s3,504(sp)
    8000536e:	fbd2                	sd	s4,496(sp)
    80005370:	f7d6                	sd	s5,488(sp)
    80005372:	f3da                	sd	s6,480(sp)
    80005374:	efde                	sd	s7,472(sp)
    80005376:	ebe2                	sd	s8,464(sp)
    80005378:	e7e6                	sd	s9,456(sp)
    8000537a:	e3ea                	sd	s10,448(sp)
    8000537c:	ff6e                	sd	s11,440(sp)
    8000537e:	1400                	addi	s0,sp,544
    80005380:	892a                	mv	s2,a0
    80005382:	dea43423          	sd	a0,-536(s0)
    80005386:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG + 1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000538a:	ffffd097          	auipc	ra,0xffffd
    8000538e:	d04080e7          	jalr	-764(ra) # 8000208e <myproc>
    80005392:	84aa                	mv	s1,a0

  begin_op();
    80005394:	fffff097          	auipc	ra,0xfffff
    80005398:	46c080e7          	jalr	1132(ra) # 80004800 <begin_op>

  if ((ip = namei(path)) == 0) {
    8000539c:	854a                	mv	a0,s2
    8000539e:	fffff097          	auipc	ra,0xfffff
    800053a2:	256080e7          	jalr	598(ra) # 800045f4 <namei>
    800053a6:	c93d                	beqz	a0,8000541c <exec+0xc4>
    800053a8:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800053aa:	fffff097          	auipc	ra,0xfffff
    800053ae:	a96080e7          	jalr	-1386(ra) # 80003e40 <ilock>

  // Check ELF header
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800053b2:	04000713          	li	a4,64
    800053b6:	4681                	li	a3,0
    800053b8:	e4840613          	addi	a2,s0,-440
    800053bc:	4581                	li	a1,0
    800053be:	8556                	mv	a0,s5
    800053c0:	fffff097          	auipc	ra,0xfffff
    800053c4:	d34080e7          	jalr	-716(ra) # 800040f4 <readi>
    800053c8:	04000793          	li	a5,64
    800053cc:	00f51a63          	bne	a0,a5,800053e0 <exec+0x88>
    goto bad;
  if (elf.magic != ELF_MAGIC)
    800053d0:	e4842703          	lw	a4,-440(s0)
    800053d4:	464c47b7          	lui	a5,0x464c4
    800053d8:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800053dc:	04f70663          	beq	a4,a5,80005428 <exec+0xd0>

bad:
  if (pagetable)
    proc_freepagetable(pagetable, sz);
  if (ip) {
    iunlockput(ip);
    800053e0:	8556                	mv	a0,s5
    800053e2:	fffff097          	auipc	ra,0xfffff
    800053e6:	cc0080e7          	jalr	-832(ra) # 800040a2 <iunlockput>
    end_op();
    800053ea:	fffff097          	auipc	ra,0xfffff
    800053ee:	496080e7          	jalr	1174(ra) # 80004880 <end_op>
  }
  return -1;
    800053f2:	557d                	li	a0,-1
}
    800053f4:	21813083          	ld	ra,536(sp)
    800053f8:	21013403          	ld	s0,528(sp)
    800053fc:	20813483          	ld	s1,520(sp)
    80005400:	20013903          	ld	s2,512(sp)
    80005404:	79fe                	ld	s3,504(sp)
    80005406:	7a5e                	ld	s4,496(sp)
    80005408:	7abe                	ld	s5,488(sp)
    8000540a:	7b1e                	ld	s6,480(sp)
    8000540c:	6bfe                	ld	s7,472(sp)
    8000540e:	6c5e                	ld	s8,464(sp)
    80005410:	6cbe                	ld	s9,456(sp)
    80005412:	6d1e                	ld	s10,448(sp)
    80005414:	7dfa                	ld	s11,440(sp)
    80005416:	22010113          	addi	sp,sp,544
    8000541a:	8082                	ret
    end_op();
    8000541c:	fffff097          	auipc	ra,0xfffff
    80005420:	464080e7          	jalr	1124(ra) # 80004880 <end_op>
    return -1;
    80005424:	557d                	li	a0,-1
    80005426:	b7f9                	j	800053f4 <exec+0x9c>
  if ((pagetable = proc_pagetable(p)) == 0)
    80005428:	8526                	mv	a0,s1
    8000542a:	ffffd097          	auipc	ra,0xffffd
    8000542e:	d28080e7          	jalr	-728(ra) # 80002152 <proc_pagetable>
    80005432:	8b2a                	mv	s6,a0
    80005434:	d555                	beqz	a0,800053e0 <exec+0x88>
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80005436:	e6842783          	lw	a5,-408(s0)
    8000543a:	e8045703          	lhu	a4,-384(s0)
    8000543e:	c735                	beqz	a4,800054aa <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG + 1], stackbase;
    80005440:	4481                	li	s1,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80005442:	e0043423          	sd	zero,-504(s0)
    if (ph.vaddr % PGSIZE != 0)
    80005446:	6a05                	lui	s4,0x1
    80005448:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    8000544c:	dee43023          	sd	a4,-544(s0)
  uint64 pa;

  if ((va % PGSIZE) != 0)
    panic("loadseg: va must be page aligned");

  for (i = 0; i < sz; i += PGSIZE) {
    80005450:	6d85                	lui	s11,0x1
    80005452:	7d7d                	lui	s10,0xfffff
    80005454:	ac1d                	j	8000568a <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if (pa == 0)
      panic("loadseg: address should exist");
    80005456:	00003517          	auipc	a0,0x3
    8000545a:	3ba50513          	addi	a0,a0,954 # 80008810 <syscalls+0x2a8>
    8000545e:	ffffb097          	auipc	ra,0xffffb
    80005462:	186080e7          	jalr	390(ra) # 800005e4 <panic>
    if (sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n)
    80005466:	874a                	mv	a4,s2
    80005468:	009c86bb          	addw	a3,s9,s1
    8000546c:	4581                	li	a1,0
    8000546e:	8556                	mv	a0,s5
    80005470:	fffff097          	auipc	ra,0xfffff
    80005474:	c84080e7          	jalr	-892(ra) # 800040f4 <readi>
    80005478:	2501                	sext.w	a0,a0
    8000547a:	1aa91863          	bne	s2,a0,8000562a <exec+0x2d2>
  for (i = 0; i < sz; i += PGSIZE) {
    8000547e:	009d84bb          	addw	s1,s11,s1
    80005482:	013d09bb          	addw	s3,s10,s3
    80005486:	1f74f263          	bgeu	s1,s7,8000566a <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    8000548a:	02049593          	slli	a1,s1,0x20
    8000548e:	9181                	srli	a1,a1,0x20
    80005490:	95e2                	add	a1,a1,s8
    80005492:	855a                	mv	a0,s6
    80005494:	ffffc097          	auipc	ra,0xffffc
    80005498:	d26080e7          	jalr	-730(ra) # 800011ba <walkaddr>
    8000549c:	862a                	mv	a2,a0
    if (pa == 0)
    8000549e:	dd45                	beqz	a0,80005456 <exec+0xfe>
      n = PGSIZE;
    800054a0:	8952                	mv	s2,s4
    if (sz - i < PGSIZE)
    800054a2:	fd49f2e3          	bgeu	s3,s4,80005466 <exec+0x10e>
      n = sz - i;
    800054a6:	894e                	mv	s2,s3
    800054a8:	bf7d                	j	80005466 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG + 1], stackbase;
    800054aa:	4481                	li	s1,0
  iunlockput(ip);
    800054ac:	8556                	mv	a0,s5
    800054ae:	fffff097          	auipc	ra,0xfffff
    800054b2:	bf4080e7          	jalr	-1036(ra) # 800040a2 <iunlockput>
  end_op();
    800054b6:	fffff097          	auipc	ra,0xfffff
    800054ba:	3ca080e7          	jalr	970(ra) # 80004880 <end_op>
  p = myproc();
    800054be:	ffffd097          	auipc	ra,0xffffd
    800054c2:	bd0080e7          	jalr	-1072(ra) # 8000208e <myproc>
    800054c6:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800054c8:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800054cc:	6785                	lui	a5,0x1
    800054ce:	17fd                	addi	a5,a5,-1
    800054d0:	94be                	add	s1,s1,a5
    800054d2:	77fd                	lui	a5,0xfffff
    800054d4:	8fe5                	and	a5,a5,s1
    800054d6:	def43c23          	sd	a5,-520(s0)
  if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE)) == 0)
    800054da:	6609                	lui	a2,0x2
    800054dc:	963e                	add	a2,a2,a5
    800054de:	85be                	mv	a1,a5
    800054e0:	855a                	mv	a0,s6
    800054e2:	ffffc097          	auipc	ra,0xffffc
    800054e6:	09e080e7          	jalr	158(ra) # 80001580 <uvmalloc>
    800054ea:	8c2a                	mv	s8,a0
  ip = 0;
    800054ec:	4a81                	li	s5,0
  if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE)) == 0)
    800054ee:	12050e63          	beqz	a0,8000562a <exec+0x2d2>
  uvmclear(pagetable, sz - 2 * PGSIZE);
    800054f2:	75f9                	lui	a1,0xffffe
    800054f4:	95aa                	add	a1,a1,a0
    800054f6:	855a                	mv	a0,s6
    800054f8:	ffffc097          	auipc	ra,0xffffc
    800054fc:	294080e7          	jalr	660(ra) # 8000178c <uvmclear>
  stackbase = sp - PGSIZE;
    80005500:	7afd                	lui	s5,0xfffff
    80005502:	9ae2                	add	s5,s5,s8
  for (argc = 0; argv[argc]; argc++) {
    80005504:	df043783          	ld	a5,-528(s0)
    80005508:	6388                	ld	a0,0(a5)
    8000550a:	c925                	beqz	a0,8000557a <exec+0x222>
    8000550c:	e8840993          	addi	s3,s0,-376
    80005510:	f8840c93          	addi	s9,s0,-120
  sp = sz;
    80005514:	8962                	mv	s2,s8
  for (argc = 0; argv[argc]; argc++) {
    80005516:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80005518:	ffffc097          	auipc	ra,0xffffc
    8000551c:	aa2080e7          	jalr	-1374(ra) # 80000fba <strlen>
    80005520:	0015079b          	addiw	a5,a0,1
    80005524:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005528:	ff097913          	andi	s2,s2,-16
    if (sp < stackbase)
    8000552c:	13596363          	bltu	s2,s5,80005652 <exec+0x2fa>
    if (copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005530:	df043d83          	ld	s11,-528(s0)
    80005534:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80005538:	8552                	mv	a0,s4
    8000553a:	ffffc097          	auipc	ra,0xffffc
    8000553e:	a80080e7          	jalr	-1408(ra) # 80000fba <strlen>
    80005542:	0015069b          	addiw	a3,a0,1
    80005546:	8652                	mv	a2,s4
    80005548:	85ca                	mv	a1,s2
    8000554a:	855a                	mv	a0,s6
    8000554c:	ffffc097          	auipc	ra,0xffffc
    80005550:	4e6080e7          	jalr	1254(ra) # 80001a32 <copyout>
    80005554:	10054363          	bltz	a0,8000565a <exec+0x302>
    ustack[argc] = sp;
    80005558:	0129b023          	sd	s2,0(s3)
  for (argc = 0; argv[argc]; argc++) {
    8000555c:	0485                	addi	s1,s1,1
    8000555e:	008d8793          	addi	a5,s11,8
    80005562:	def43823          	sd	a5,-528(s0)
    80005566:	008db503          	ld	a0,8(s11)
    8000556a:	c911                	beqz	a0,8000557e <exec+0x226>
    if (argc >= MAXARG)
    8000556c:	09a1                	addi	s3,s3,8
    8000556e:	fb3c95e3          	bne	s9,s3,80005518 <exec+0x1c0>
  sz = sz1;
    80005572:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005576:	4a81                	li	s5,0
    80005578:	a84d                	j	8000562a <exec+0x2d2>
  sp = sz;
    8000557a:	8962                	mv	s2,s8
  for (argc = 0; argv[argc]; argc++) {
    8000557c:	4481                	li	s1,0
  ustack[argc] = 0;
    8000557e:	00349793          	slli	a5,s1,0x3
    80005582:	f9040713          	addi	a4,s0,-112
    80005586:	97ba                	add	a5,a5,a4
    80005588:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ffacef8>
  sp -= (argc + 1) * sizeof(uint64);
    8000558c:	00148693          	addi	a3,s1,1
    80005590:	068e                	slli	a3,a3,0x3
    80005592:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005596:	ff097913          	andi	s2,s2,-16
  if (sp < stackbase)
    8000559a:	01597663          	bgeu	s2,s5,800055a6 <exec+0x24e>
  sz = sz1;
    8000559e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800055a2:	4a81                	li	s5,0
    800055a4:	a059                	j	8000562a <exec+0x2d2>
  if (copyout(pagetable, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) < 0)
    800055a6:	e8840613          	addi	a2,s0,-376
    800055aa:	85ca                	mv	a1,s2
    800055ac:	855a                	mv	a0,s6
    800055ae:	ffffc097          	auipc	ra,0xffffc
    800055b2:	484080e7          	jalr	1156(ra) # 80001a32 <copyout>
    800055b6:	0a054663          	bltz	a0,80005662 <exec+0x30a>
  p->trapframe->a1 = sp;
    800055ba:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    800055be:	0727bc23          	sd	s2,120(a5)
  for (last = s = path; *s; s++)
    800055c2:	de843783          	ld	a5,-536(s0)
    800055c6:	0007c703          	lbu	a4,0(a5)
    800055ca:	cf11                	beqz	a4,800055e6 <exec+0x28e>
    800055cc:	0785                	addi	a5,a5,1
    if (*s == '/')
    800055ce:	02f00693          	li	a3,47
    800055d2:	a039                	j	800055e0 <exec+0x288>
      last = s + 1;
    800055d4:	def43423          	sd	a5,-536(s0)
  for (last = s = path; *s; s++)
    800055d8:	0785                	addi	a5,a5,1
    800055da:	fff7c703          	lbu	a4,-1(a5)
    800055de:	c701                	beqz	a4,800055e6 <exec+0x28e>
    if (*s == '/')
    800055e0:	fed71ce3          	bne	a4,a3,800055d8 <exec+0x280>
    800055e4:	bfc5                	j	800055d4 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    800055e6:	4641                	li	a2,16
    800055e8:	de843583          	ld	a1,-536(s0)
    800055ec:	150b8513          	addi	a0,s7,336
    800055f0:	ffffc097          	auipc	ra,0xffffc
    800055f4:	998080e7          	jalr	-1640(ra) # 80000f88 <safestrcpy>
  oldpagetable = p->pagetable;
    800055f8:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    800055fc:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80005600:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry; // initial program counter = main
    80005604:	058bb783          	ld	a5,88(s7)
    80005608:	e6043703          	ld	a4,-416(s0)
    8000560c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;         // initial stack pointer
    8000560e:	058bb783          	ld	a5,88(s7)
    80005612:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005616:	85ea                	mv	a1,s10
    80005618:	ffffd097          	auipc	ra,0xffffd
    8000561c:	bd6080e7          	jalr	-1066(ra) # 800021ee <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005620:	0004851b          	sext.w	a0,s1
    80005624:	bbc1                	j	800053f4 <exec+0x9c>
    80005626:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    8000562a:	df843583          	ld	a1,-520(s0)
    8000562e:	855a                	mv	a0,s6
    80005630:	ffffd097          	auipc	ra,0xffffd
    80005634:	bbe080e7          	jalr	-1090(ra) # 800021ee <proc_freepagetable>
  if (ip) {
    80005638:	da0a94e3          	bnez	s5,800053e0 <exec+0x88>
  return -1;
    8000563c:	557d                	li	a0,-1
    8000563e:	bb5d                	j	800053f4 <exec+0x9c>
    80005640:	de943c23          	sd	s1,-520(s0)
    80005644:	b7dd                	j	8000562a <exec+0x2d2>
    80005646:	de943c23          	sd	s1,-520(s0)
    8000564a:	b7c5                	j	8000562a <exec+0x2d2>
    8000564c:	de943c23          	sd	s1,-520(s0)
    80005650:	bfe9                	j	8000562a <exec+0x2d2>
  sz = sz1;
    80005652:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005656:	4a81                	li	s5,0
    80005658:	bfc9                	j	8000562a <exec+0x2d2>
  sz = sz1;
    8000565a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000565e:	4a81                	li	s5,0
    80005660:	b7e9                	j	8000562a <exec+0x2d2>
  sz = sz1;
    80005662:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005666:	4a81                	li	s5,0
    80005668:	b7c9                	j	8000562a <exec+0x2d2>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000566a:	df843483          	ld	s1,-520(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    8000566e:	e0843783          	ld	a5,-504(s0)
    80005672:	0017869b          	addiw	a3,a5,1
    80005676:	e0d43423          	sd	a3,-504(s0)
    8000567a:	e0043783          	ld	a5,-512(s0)
    8000567e:	0387879b          	addiw	a5,a5,56
    80005682:	e8045703          	lhu	a4,-384(s0)
    80005686:	e2e6d3e3          	bge	a3,a4,800054ac <exec+0x154>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000568a:	2781                	sext.w	a5,a5
    8000568c:	e0f43023          	sd	a5,-512(s0)
    80005690:	03800713          	li	a4,56
    80005694:	86be                	mv	a3,a5
    80005696:	e1040613          	addi	a2,s0,-496
    8000569a:	4581                	li	a1,0
    8000569c:	8556                	mv	a0,s5
    8000569e:	fffff097          	auipc	ra,0xfffff
    800056a2:	a56080e7          	jalr	-1450(ra) # 800040f4 <readi>
    800056a6:	03800793          	li	a5,56
    800056aa:	f6f51ee3          	bne	a0,a5,80005626 <exec+0x2ce>
    if (ph.type != ELF_PROG_LOAD)
    800056ae:	e1042783          	lw	a5,-496(s0)
    800056b2:	4705                	li	a4,1
    800056b4:	fae79de3          	bne	a5,a4,8000566e <exec+0x316>
    if (ph.memsz < ph.filesz)
    800056b8:	e3843603          	ld	a2,-456(s0)
    800056bc:	e3043783          	ld	a5,-464(s0)
    800056c0:	f8f660e3          	bltu	a2,a5,80005640 <exec+0x2e8>
    if (ph.vaddr + ph.memsz < ph.vaddr)
    800056c4:	e2043783          	ld	a5,-480(s0)
    800056c8:	963e                	add	a2,a2,a5
    800056ca:	f6f66ee3          	bltu	a2,a5,80005646 <exec+0x2ee>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800056ce:	85a6                	mv	a1,s1
    800056d0:	855a                	mv	a0,s6
    800056d2:	ffffc097          	auipc	ra,0xffffc
    800056d6:	eae080e7          	jalr	-338(ra) # 80001580 <uvmalloc>
    800056da:	dea43c23          	sd	a0,-520(s0)
    800056de:	d53d                	beqz	a0,8000564c <exec+0x2f4>
    if (ph.vaddr % PGSIZE != 0)
    800056e0:	e2043c03          	ld	s8,-480(s0)
    800056e4:	de043783          	ld	a5,-544(s0)
    800056e8:	00fc77b3          	and	a5,s8,a5
    800056ec:	ff9d                	bnez	a5,8000562a <exec+0x2d2>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800056ee:	e1842c83          	lw	s9,-488(s0)
    800056f2:	e3042b83          	lw	s7,-464(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    800056f6:	f60b8ae3          	beqz	s7,8000566a <exec+0x312>
    800056fa:	89de                	mv	s3,s7
    800056fc:	4481                	li	s1,0
    800056fe:	b371                	j	8000548a <exec+0x132>

0000000080005700 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005700:	7179                	addi	sp,sp,-48
    80005702:	f406                	sd	ra,40(sp)
    80005704:	f022                	sd	s0,32(sp)
    80005706:	ec26                	sd	s1,24(sp)
    80005708:	e84a                	sd	s2,16(sp)
    8000570a:	1800                	addi	s0,sp,48
    8000570c:	892e                	mv	s2,a1
    8000570e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80005710:	fdc40593          	addi	a1,s0,-36
    80005714:	ffffe097          	auipc	ra,0xffffe
    80005718:	b78080e7          	jalr	-1160(ra) # 8000328c <argint>
    8000571c:	04054063          	bltz	a0,8000575c <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005720:	fdc42703          	lw	a4,-36(s0)
    80005724:	47bd                	li	a5,15
    80005726:	02e7ed63          	bltu	a5,a4,80005760 <argfd+0x60>
    8000572a:	ffffd097          	auipc	ra,0xffffd
    8000572e:	964080e7          	jalr	-1692(ra) # 8000208e <myproc>
    80005732:	fdc42703          	lw	a4,-36(s0)
    80005736:	01a70793          	addi	a5,a4,26
    8000573a:	078e                	slli	a5,a5,0x3
    8000573c:	953e                	add	a0,a0,a5
    8000573e:	611c                	ld	a5,0(a0)
    80005740:	c395                	beqz	a5,80005764 <argfd+0x64>
    return -1;
  if(pfd)
    80005742:	00090463          	beqz	s2,8000574a <argfd+0x4a>
    *pfd = fd;
    80005746:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000574a:	4501                	li	a0,0
  if(pf)
    8000574c:	c091                	beqz	s1,80005750 <argfd+0x50>
    *pf = f;
    8000574e:	e09c                	sd	a5,0(s1)
}
    80005750:	70a2                	ld	ra,40(sp)
    80005752:	7402                	ld	s0,32(sp)
    80005754:	64e2                	ld	s1,24(sp)
    80005756:	6942                	ld	s2,16(sp)
    80005758:	6145                	addi	sp,sp,48
    8000575a:	8082                	ret
    return -1;
    8000575c:	557d                	li	a0,-1
    8000575e:	bfcd                	j	80005750 <argfd+0x50>
    return -1;
    80005760:	557d                	li	a0,-1
    80005762:	b7fd                	j	80005750 <argfd+0x50>
    80005764:	557d                	li	a0,-1
    80005766:	b7ed                	j	80005750 <argfd+0x50>

0000000080005768 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005768:	1101                	addi	sp,sp,-32
    8000576a:	ec06                	sd	ra,24(sp)
    8000576c:	e822                	sd	s0,16(sp)
    8000576e:	e426                	sd	s1,8(sp)
    80005770:	1000                	addi	s0,sp,32
    80005772:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005774:	ffffd097          	auipc	ra,0xffffd
    80005778:	91a080e7          	jalr	-1766(ra) # 8000208e <myproc>
    8000577c:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000577e:	0d050793          	addi	a5,a0,208
    80005782:	4501                	li	a0,0
    80005784:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005786:	6398                	ld	a4,0(a5)
    80005788:	cb19                	beqz	a4,8000579e <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000578a:	2505                	addiw	a0,a0,1
    8000578c:	07a1                	addi	a5,a5,8
    8000578e:	fed51ce3          	bne	a0,a3,80005786 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005792:	557d                	li	a0,-1
}
    80005794:	60e2                	ld	ra,24(sp)
    80005796:	6442                	ld	s0,16(sp)
    80005798:	64a2                	ld	s1,8(sp)
    8000579a:	6105                	addi	sp,sp,32
    8000579c:	8082                	ret
      p->ofile[fd] = f;
    8000579e:	01a50793          	addi	a5,a0,26
    800057a2:	078e                	slli	a5,a5,0x3
    800057a4:	963e                	add	a2,a2,a5
    800057a6:	e204                	sd	s1,0(a2)
      return fd;
    800057a8:	b7f5                	j	80005794 <fdalloc+0x2c>

00000000800057aa <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800057aa:	715d                	addi	sp,sp,-80
    800057ac:	e486                	sd	ra,72(sp)
    800057ae:	e0a2                	sd	s0,64(sp)
    800057b0:	fc26                	sd	s1,56(sp)
    800057b2:	f84a                	sd	s2,48(sp)
    800057b4:	f44e                	sd	s3,40(sp)
    800057b6:	f052                	sd	s4,32(sp)
    800057b8:	ec56                	sd	s5,24(sp)
    800057ba:	0880                	addi	s0,sp,80
    800057bc:	89ae                	mv	s3,a1
    800057be:	8ab2                	mv	s5,a2
    800057c0:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800057c2:	fb040593          	addi	a1,s0,-80
    800057c6:	fffff097          	auipc	ra,0xfffff
    800057ca:	e4c080e7          	jalr	-436(ra) # 80004612 <nameiparent>
    800057ce:	892a                	mv	s2,a0
    800057d0:	12050e63          	beqz	a0,8000590c <create+0x162>
    return 0;

  ilock(dp);
    800057d4:	ffffe097          	auipc	ra,0xffffe
    800057d8:	66c080e7          	jalr	1644(ra) # 80003e40 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800057dc:	4601                	li	a2,0
    800057de:	fb040593          	addi	a1,s0,-80
    800057e2:	854a                	mv	a0,s2
    800057e4:	fffff097          	auipc	ra,0xfffff
    800057e8:	b3e080e7          	jalr	-1218(ra) # 80004322 <dirlookup>
    800057ec:	84aa                	mv	s1,a0
    800057ee:	c921                	beqz	a0,8000583e <create+0x94>
    iunlockput(dp);
    800057f0:	854a                	mv	a0,s2
    800057f2:	fffff097          	auipc	ra,0xfffff
    800057f6:	8b0080e7          	jalr	-1872(ra) # 800040a2 <iunlockput>
    ilock(ip);
    800057fa:	8526                	mv	a0,s1
    800057fc:	ffffe097          	auipc	ra,0xffffe
    80005800:	644080e7          	jalr	1604(ra) # 80003e40 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005804:	2981                	sext.w	s3,s3
    80005806:	4789                	li	a5,2
    80005808:	02f99463          	bne	s3,a5,80005830 <create+0x86>
    8000580c:	0444d783          	lhu	a5,68(s1)
    80005810:	37f9                	addiw	a5,a5,-2
    80005812:	17c2                	slli	a5,a5,0x30
    80005814:	93c1                	srli	a5,a5,0x30
    80005816:	4705                	li	a4,1
    80005818:	00f76c63          	bltu	a4,a5,80005830 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000581c:	8526                	mv	a0,s1
    8000581e:	60a6                	ld	ra,72(sp)
    80005820:	6406                	ld	s0,64(sp)
    80005822:	74e2                	ld	s1,56(sp)
    80005824:	7942                	ld	s2,48(sp)
    80005826:	79a2                	ld	s3,40(sp)
    80005828:	7a02                	ld	s4,32(sp)
    8000582a:	6ae2                	ld	s5,24(sp)
    8000582c:	6161                	addi	sp,sp,80
    8000582e:	8082                	ret
    iunlockput(ip);
    80005830:	8526                	mv	a0,s1
    80005832:	fffff097          	auipc	ra,0xfffff
    80005836:	870080e7          	jalr	-1936(ra) # 800040a2 <iunlockput>
    return 0;
    8000583a:	4481                	li	s1,0
    8000583c:	b7c5                	j	8000581c <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000583e:	85ce                	mv	a1,s3
    80005840:	00092503          	lw	a0,0(s2)
    80005844:	ffffe097          	auipc	ra,0xffffe
    80005848:	464080e7          	jalr	1124(ra) # 80003ca8 <ialloc>
    8000584c:	84aa                	mv	s1,a0
    8000584e:	c521                	beqz	a0,80005896 <create+0xec>
  ilock(ip);
    80005850:	ffffe097          	auipc	ra,0xffffe
    80005854:	5f0080e7          	jalr	1520(ra) # 80003e40 <ilock>
  ip->major = major;
    80005858:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    8000585c:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80005860:	4a05                	li	s4,1
    80005862:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    80005866:	8526                	mv	a0,s1
    80005868:	ffffe097          	auipc	ra,0xffffe
    8000586c:	50e080e7          	jalr	1294(ra) # 80003d76 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005870:	2981                	sext.w	s3,s3
    80005872:	03498a63          	beq	s3,s4,800058a6 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80005876:	40d0                	lw	a2,4(s1)
    80005878:	fb040593          	addi	a1,s0,-80
    8000587c:	854a                	mv	a0,s2
    8000587e:	fffff097          	auipc	ra,0xfffff
    80005882:	cb4080e7          	jalr	-844(ra) # 80004532 <dirlink>
    80005886:	06054b63          	bltz	a0,800058fc <create+0x152>
  iunlockput(dp);
    8000588a:	854a                	mv	a0,s2
    8000588c:	fffff097          	auipc	ra,0xfffff
    80005890:	816080e7          	jalr	-2026(ra) # 800040a2 <iunlockput>
  return ip;
    80005894:	b761                	j	8000581c <create+0x72>
    panic("create: ialloc");
    80005896:	00003517          	auipc	a0,0x3
    8000589a:	f9a50513          	addi	a0,a0,-102 # 80008830 <syscalls+0x2c8>
    8000589e:	ffffb097          	auipc	ra,0xffffb
    800058a2:	d46080e7          	jalr	-698(ra) # 800005e4 <panic>
    dp->nlink++;  // for ".."
    800058a6:	04a95783          	lhu	a5,74(s2)
    800058aa:	2785                	addiw	a5,a5,1
    800058ac:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800058b0:	854a                	mv	a0,s2
    800058b2:	ffffe097          	auipc	ra,0xffffe
    800058b6:	4c4080e7          	jalr	1220(ra) # 80003d76 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800058ba:	40d0                	lw	a2,4(s1)
    800058bc:	00003597          	auipc	a1,0x3
    800058c0:	f8458593          	addi	a1,a1,-124 # 80008840 <syscalls+0x2d8>
    800058c4:	8526                	mv	a0,s1
    800058c6:	fffff097          	auipc	ra,0xfffff
    800058ca:	c6c080e7          	jalr	-916(ra) # 80004532 <dirlink>
    800058ce:	00054f63          	bltz	a0,800058ec <create+0x142>
    800058d2:	00492603          	lw	a2,4(s2)
    800058d6:	00003597          	auipc	a1,0x3
    800058da:	f7258593          	addi	a1,a1,-142 # 80008848 <syscalls+0x2e0>
    800058de:	8526                	mv	a0,s1
    800058e0:	fffff097          	auipc	ra,0xfffff
    800058e4:	c52080e7          	jalr	-942(ra) # 80004532 <dirlink>
    800058e8:	f80557e3          	bgez	a0,80005876 <create+0xcc>
      panic("create dots");
    800058ec:	00003517          	auipc	a0,0x3
    800058f0:	f6450513          	addi	a0,a0,-156 # 80008850 <syscalls+0x2e8>
    800058f4:	ffffb097          	auipc	ra,0xffffb
    800058f8:	cf0080e7          	jalr	-784(ra) # 800005e4 <panic>
    panic("create: dirlink");
    800058fc:	00003517          	auipc	a0,0x3
    80005900:	f6450513          	addi	a0,a0,-156 # 80008860 <syscalls+0x2f8>
    80005904:	ffffb097          	auipc	ra,0xffffb
    80005908:	ce0080e7          	jalr	-800(ra) # 800005e4 <panic>
    return 0;
    8000590c:	84aa                	mv	s1,a0
    8000590e:	b739                	j	8000581c <create+0x72>

0000000080005910 <sys_dup>:
{
    80005910:	7179                	addi	sp,sp,-48
    80005912:	f406                	sd	ra,40(sp)
    80005914:	f022                	sd	s0,32(sp)
    80005916:	ec26                	sd	s1,24(sp)
    80005918:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000591a:	fd840613          	addi	a2,s0,-40
    8000591e:	4581                	li	a1,0
    80005920:	4501                	li	a0,0
    80005922:	00000097          	auipc	ra,0x0
    80005926:	dde080e7          	jalr	-546(ra) # 80005700 <argfd>
    return -1;
    8000592a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000592c:	02054363          	bltz	a0,80005952 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80005930:	fd843503          	ld	a0,-40(s0)
    80005934:	00000097          	auipc	ra,0x0
    80005938:	e34080e7          	jalr	-460(ra) # 80005768 <fdalloc>
    8000593c:	84aa                	mv	s1,a0
    return -1;
    8000593e:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005940:	00054963          	bltz	a0,80005952 <sys_dup+0x42>
  filedup(f);
    80005944:	fd843503          	ld	a0,-40(s0)
    80005948:	fffff097          	auipc	ra,0xfffff
    8000594c:	338080e7          	jalr	824(ra) # 80004c80 <filedup>
  return fd;
    80005950:	87a6                	mv	a5,s1
}
    80005952:	853e                	mv	a0,a5
    80005954:	70a2                	ld	ra,40(sp)
    80005956:	7402                	ld	s0,32(sp)
    80005958:	64e2                	ld	s1,24(sp)
    8000595a:	6145                	addi	sp,sp,48
    8000595c:	8082                	ret

000000008000595e <sys_read>:
{
    8000595e:	7179                	addi	sp,sp,-48
    80005960:	f406                	sd	ra,40(sp)
    80005962:	f022                	sd	s0,32(sp)
    80005964:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005966:	fe840613          	addi	a2,s0,-24
    8000596a:	4581                	li	a1,0
    8000596c:	4501                	li	a0,0
    8000596e:	00000097          	auipc	ra,0x0
    80005972:	d92080e7          	jalr	-622(ra) # 80005700 <argfd>
    return -1;
    80005976:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005978:	04054163          	bltz	a0,800059ba <sys_read+0x5c>
    8000597c:	fe440593          	addi	a1,s0,-28
    80005980:	4509                	li	a0,2
    80005982:	ffffe097          	auipc	ra,0xffffe
    80005986:	90a080e7          	jalr	-1782(ra) # 8000328c <argint>
    return -1;
    8000598a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000598c:	02054763          	bltz	a0,800059ba <sys_read+0x5c>
    80005990:	fd840593          	addi	a1,s0,-40
    80005994:	4505                	li	a0,1
    80005996:	ffffe097          	auipc	ra,0xffffe
    8000599a:	918080e7          	jalr	-1768(ra) # 800032ae <argaddr>
    return -1;
    8000599e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800059a0:	00054d63          	bltz	a0,800059ba <sys_read+0x5c>
  return fileread(f, p, n);
    800059a4:	fe442603          	lw	a2,-28(s0)
    800059a8:	fd843583          	ld	a1,-40(s0)
    800059ac:	fe843503          	ld	a0,-24(s0)
    800059b0:	fffff097          	auipc	ra,0xfffff
    800059b4:	45c080e7          	jalr	1116(ra) # 80004e0c <fileread>
    800059b8:	87aa                	mv	a5,a0
}
    800059ba:	853e                	mv	a0,a5
    800059bc:	70a2                	ld	ra,40(sp)
    800059be:	7402                	ld	s0,32(sp)
    800059c0:	6145                	addi	sp,sp,48
    800059c2:	8082                	ret

00000000800059c4 <sys_write>:
{
    800059c4:	7179                	addi	sp,sp,-48
    800059c6:	f406                	sd	ra,40(sp)
    800059c8:	f022                	sd	s0,32(sp)
    800059ca:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800059cc:	fe840613          	addi	a2,s0,-24
    800059d0:	4581                	li	a1,0
    800059d2:	4501                	li	a0,0
    800059d4:	00000097          	auipc	ra,0x0
    800059d8:	d2c080e7          	jalr	-724(ra) # 80005700 <argfd>
    return -1;
    800059dc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800059de:	04054163          	bltz	a0,80005a20 <sys_write+0x5c>
    800059e2:	fe440593          	addi	a1,s0,-28
    800059e6:	4509                	li	a0,2
    800059e8:	ffffe097          	auipc	ra,0xffffe
    800059ec:	8a4080e7          	jalr	-1884(ra) # 8000328c <argint>
    return -1;
    800059f0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800059f2:	02054763          	bltz	a0,80005a20 <sys_write+0x5c>
    800059f6:	fd840593          	addi	a1,s0,-40
    800059fa:	4505                	li	a0,1
    800059fc:	ffffe097          	auipc	ra,0xffffe
    80005a00:	8b2080e7          	jalr	-1870(ra) # 800032ae <argaddr>
    return -1;
    80005a04:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005a06:	00054d63          	bltz	a0,80005a20 <sys_write+0x5c>
  return filewrite(f, p, n);
    80005a0a:	fe442603          	lw	a2,-28(s0)
    80005a0e:	fd843583          	ld	a1,-40(s0)
    80005a12:	fe843503          	ld	a0,-24(s0)
    80005a16:	fffff097          	auipc	ra,0xfffff
    80005a1a:	4b8080e7          	jalr	1208(ra) # 80004ece <filewrite>
    80005a1e:	87aa                	mv	a5,a0
}
    80005a20:	853e                	mv	a0,a5
    80005a22:	70a2                	ld	ra,40(sp)
    80005a24:	7402                	ld	s0,32(sp)
    80005a26:	6145                	addi	sp,sp,48
    80005a28:	8082                	ret

0000000080005a2a <sys_close>:
{
    80005a2a:	1101                	addi	sp,sp,-32
    80005a2c:	ec06                	sd	ra,24(sp)
    80005a2e:	e822                	sd	s0,16(sp)
    80005a30:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005a32:	fe040613          	addi	a2,s0,-32
    80005a36:	fec40593          	addi	a1,s0,-20
    80005a3a:	4501                	li	a0,0
    80005a3c:	00000097          	auipc	ra,0x0
    80005a40:	cc4080e7          	jalr	-828(ra) # 80005700 <argfd>
    return -1;
    80005a44:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005a46:	02054463          	bltz	a0,80005a6e <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005a4a:	ffffc097          	auipc	ra,0xffffc
    80005a4e:	644080e7          	jalr	1604(ra) # 8000208e <myproc>
    80005a52:	fec42783          	lw	a5,-20(s0)
    80005a56:	07e9                	addi	a5,a5,26
    80005a58:	078e                	slli	a5,a5,0x3
    80005a5a:	97aa                	add	a5,a5,a0
    80005a5c:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80005a60:	fe043503          	ld	a0,-32(s0)
    80005a64:	fffff097          	auipc	ra,0xfffff
    80005a68:	26e080e7          	jalr	622(ra) # 80004cd2 <fileclose>
  return 0;
    80005a6c:	4781                	li	a5,0
}
    80005a6e:	853e                	mv	a0,a5
    80005a70:	60e2                	ld	ra,24(sp)
    80005a72:	6442                	ld	s0,16(sp)
    80005a74:	6105                	addi	sp,sp,32
    80005a76:	8082                	ret

0000000080005a78 <sys_fstat>:
{
    80005a78:	1101                	addi	sp,sp,-32
    80005a7a:	ec06                	sd	ra,24(sp)
    80005a7c:	e822                	sd	s0,16(sp)
    80005a7e:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005a80:	fe840613          	addi	a2,s0,-24
    80005a84:	4581                	li	a1,0
    80005a86:	4501                	li	a0,0
    80005a88:	00000097          	auipc	ra,0x0
    80005a8c:	c78080e7          	jalr	-904(ra) # 80005700 <argfd>
    return -1;
    80005a90:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005a92:	02054563          	bltz	a0,80005abc <sys_fstat+0x44>
    80005a96:	fe040593          	addi	a1,s0,-32
    80005a9a:	4505                	li	a0,1
    80005a9c:	ffffe097          	auipc	ra,0xffffe
    80005aa0:	812080e7          	jalr	-2030(ra) # 800032ae <argaddr>
    return -1;
    80005aa4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005aa6:	00054b63          	bltz	a0,80005abc <sys_fstat+0x44>
  return filestat(f, st);
    80005aaa:	fe043583          	ld	a1,-32(s0)
    80005aae:	fe843503          	ld	a0,-24(s0)
    80005ab2:	fffff097          	auipc	ra,0xfffff
    80005ab6:	2e8080e7          	jalr	744(ra) # 80004d9a <filestat>
    80005aba:	87aa                	mv	a5,a0
}
    80005abc:	853e                	mv	a0,a5
    80005abe:	60e2                	ld	ra,24(sp)
    80005ac0:	6442                	ld	s0,16(sp)
    80005ac2:	6105                	addi	sp,sp,32
    80005ac4:	8082                	ret

0000000080005ac6 <sys_link>:
{
    80005ac6:	7169                	addi	sp,sp,-304
    80005ac8:	f606                	sd	ra,296(sp)
    80005aca:	f222                	sd	s0,288(sp)
    80005acc:	ee26                	sd	s1,280(sp)
    80005ace:	ea4a                	sd	s2,272(sp)
    80005ad0:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005ad2:	08000613          	li	a2,128
    80005ad6:	ed040593          	addi	a1,s0,-304
    80005ada:	4501                	li	a0,0
    80005adc:	ffffd097          	auipc	ra,0xffffd
    80005ae0:	7f4080e7          	jalr	2036(ra) # 800032d0 <argstr>
    return -1;
    80005ae4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005ae6:	10054e63          	bltz	a0,80005c02 <sys_link+0x13c>
    80005aea:	08000613          	li	a2,128
    80005aee:	f5040593          	addi	a1,s0,-176
    80005af2:	4505                	li	a0,1
    80005af4:	ffffd097          	auipc	ra,0xffffd
    80005af8:	7dc080e7          	jalr	2012(ra) # 800032d0 <argstr>
    return -1;
    80005afc:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005afe:	10054263          	bltz	a0,80005c02 <sys_link+0x13c>
  begin_op();
    80005b02:	fffff097          	auipc	ra,0xfffff
    80005b06:	cfe080e7          	jalr	-770(ra) # 80004800 <begin_op>
  if((ip = namei(old)) == 0){
    80005b0a:	ed040513          	addi	a0,s0,-304
    80005b0e:	fffff097          	auipc	ra,0xfffff
    80005b12:	ae6080e7          	jalr	-1306(ra) # 800045f4 <namei>
    80005b16:	84aa                	mv	s1,a0
    80005b18:	c551                	beqz	a0,80005ba4 <sys_link+0xde>
  ilock(ip);
    80005b1a:	ffffe097          	auipc	ra,0xffffe
    80005b1e:	326080e7          	jalr	806(ra) # 80003e40 <ilock>
  if(ip->type == T_DIR){
    80005b22:	04449703          	lh	a4,68(s1)
    80005b26:	4785                	li	a5,1
    80005b28:	08f70463          	beq	a4,a5,80005bb0 <sys_link+0xea>
  ip->nlink++;
    80005b2c:	04a4d783          	lhu	a5,74(s1)
    80005b30:	2785                	addiw	a5,a5,1
    80005b32:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005b36:	8526                	mv	a0,s1
    80005b38:	ffffe097          	auipc	ra,0xffffe
    80005b3c:	23e080e7          	jalr	574(ra) # 80003d76 <iupdate>
  iunlock(ip);
    80005b40:	8526                	mv	a0,s1
    80005b42:	ffffe097          	auipc	ra,0xffffe
    80005b46:	3c0080e7          	jalr	960(ra) # 80003f02 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005b4a:	fd040593          	addi	a1,s0,-48
    80005b4e:	f5040513          	addi	a0,s0,-176
    80005b52:	fffff097          	auipc	ra,0xfffff
    80005b56:	ac0080e7          	jalr	-1344(ra) # 80004612 <nameiparent>
    80005b5a:	892a                	mv	s2,a0
    80005b5c:	c935                	beqz	a0,80005bd0 <sys_link+0x10a>
  ilock(dp);
    80005b5e:	ffffe097          	auipc	ra,0xffffe
    80005b62:	2e2080e7          	jalr	738(ra) # 80003e40 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005b66:	00092703          	lw	a4,0(s2)
    80005b6a:	409c                	lw	a5,0(s1)
    80005b6c:	04f71d63          	bne	a4,a5,80005bc6 <sys_link+0x100>
    80005b70:	40d0                	lw	a2,4(s1)
    80005b72:	fd040593          	addi	a1,s0,-48
    80005b76:	854a                	mv	a0,s2
    80005b78:	fffff097          	auipc	ra,0xfffff
    80005b7c:	9ba080e7          	jalr	-1606(ra) # 80004532 <dirlink>
    80005b80:	04054363          	bltz	a0,80005bc6 <sys_link+0x100>
  iunlockput(dp);
    80005b84:	854a                	mv	a0,s2
    80005b86:	ffffe097          	auipc	ra,0xffffe
    80005b8a:	51c080e7          	jalr	1308(ra) # 800040a2 <iunlockput>
  iput(ip);
    80005b8e:	8526                	mv	a0,s1
    80005b90:	ffffe097          	auipc	ra,0xffffe
    80005b94:	46a080e7          	jalr	1130(ra) # 80003ffa <iput>
  end_op();
    80005b98:	fffff097          	auipc	ra,0xfffff
    80005b9c:	ce8080e7          	jalr	-792(ra) # 80004880 <end_op>
  return 0;
    80005ba0:	4781                	li	a5,0
    80005ba2:	a085                	j	80005c02 <sys_link+0x13c>
    end_op();
    80005ba4:	fffff097          	auipc	ra,0xfffff
    80005ba8:	cdc080e7          	jalr	-804(ra) # 80004880 <end_op>
    return -1;
    80005bac:	57fd                	li	a5,-1
    80005bae:	a891                	j	80005c02 <sys_link+0x13c>
    iunlockput(ip);
    80005bb0:	8526                	mv	a0,s1
    80005bb2:	ffffe097          	auipc	ra,0xffffe
    80005bb6:	4f0080e7          	jalr	1264(ra) # 800040a2 <iunlockput>
    end_op();
    80005bba:	fffff097          	auipc	ra,0xfffff
    80005bbe:	cc6080e7          	jalr	-826(ra) # 80004880 <end_op>
    return -1;
    80005bc2:	57fd                	li	a5,-1
    80005bc4:	a83d                	j	80005c02 <sys_link+0x13c>
    iunlockput(dp);
    80005bc6:	854a                	mv	a0,s2
    80005bc8:	ffffe097          	auipc	ra,0xffffe
    80005bcc:	4da080e7          	jalr	1242(ra) # 800040a2 <iunlockput>
  ilock(ip);
    80005bd0:	8526                	mv	a0,s1
    80005bd2:	ffffe097          	auipc	ra,0xffffe
    80005bd6:	26e080e7          	jalr	622(ra) # 80003e40 <ilock>
  ip->nlink--;
    80005bda:	04a4d783          	lhu	a5,74(s1)
    80005bde:	37fd                	addiw	a5,a5,-1
    80005be0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005be4:	8526                	mv	a0,s1
    80005be6:	ffffe097          	auipc	ra,0xffffe
    80005bea:	190080e7          	jalr	400(ra) # 80003d76 <iupdate>
  iunlockput(ip);
    80005bee:	8526                	mv	a0,s1
    80005bf0:	ffffe097          	auipc	ra,0xffffe
    80005bf4:	4b2080e7          	jalr	1202(ra) # 800040a2 <iunlockput>
  end_op();
    80005bf8:	fffff097          	auipc	ra,0xfffff
    80005bfc:	c88080e7          	jalr	-888(ra) # 80004880 <end_op>
  return -1;
    80005c00:	57fd                	li	a5,-1
}
    80005c02:	853e                	mv	a0,a5
    80005c04:	70b2                	ld	ra,296(sp)
    80005c06:	7412                	ld	s0,288(sp)
    80005c08:	64f2                	ld	s1,280(sp)
    80005c0a:	6952                	ld	s2,272(sp)
    80005c0c:	6155                	addi	sp,sp,304
    80005c0e:	8082                	ret

0000000080005c10 <sys_unlink>:
{
    80005c10:	7151                	addi	sp,sp,-240
    80005c12:	f586                	sd	ra,232(sp)
    80005c14:	f1a2                	sd	s0,224(sp)
    80005c16:	eda6                	sd	s1,216(sp)
    80005c18:	e9ca                	sd	s2,208(sp)
    80005c1a:	e5ce                	sd	s3,200(sp)
    80005c1c:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005c1e:	08000613          	li	a2,128
    80005c22:	f3040593          	addi	a1,s0,-208
    80005c26:	4501                	li	a0,0
    80005c28:	ffffd097          	auipc	ra,0xffffd
    80005c2c:	6a8080e7          	jalr	1704(ra) # 800032d0 <argstr>
    80005c30:	18054163          	bltz	a0,80005db2 <sys_unlink+0x1a2>
  begin_op();
    80005c34:	fffff097          	auipc	ra,0xfffff
    80005c38:	bcc080e7          	jalr	-1076(ra) # 80004800 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005c3c:	fb040593          	addi	a1,s0,-80
    80005c40:	f3040513          	addi	a0,s0,-208
    80005c44:	fffff097          	auipc	ra,0xfffff
    80005c48:	9ce080e7          	jalr	-1586(ra) # 80004612 <nameiparent>
    80005c4c:	84aa                	mv	s1,a0
    80005c4e:	c979                	beqz	a0,80005d24 <sys_unlink+0x114>
  ilock(dp);
    80005c50:	ffffe097          	auipc	ra,0xffffe
    80005c54:	1f0080e7          	jalr	496(ra) # 80003e40 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005c58:	00003597          	auipc	a1,0x3
    80005c5c:	be858593          	addi	a1,a1,-1048 # 80008840 <syscalls+0x2d8>
    80005c60:	fb040513          	addi	a0,s0,-80
    80005c64:	ffffe097          	auipc	ra,0xffffe
    80005c68:	6a4080e7          	jalr	1700(ra) # 80004308 <namecmp>
    80005c6c:	14050a63          	beqz	a0,80005dc0 <sys_unlink+0x1b0>
    80005c70:	00003597          	auipc	a1,0x3
    80005c74:	bd858593          	addi	a1,a1,-1064 # 80008848 <syscalls+0x2e0>
    80005c78:	fb040513          	addi	a0,s0,-80
    80005c7c:	ffffe097          	auipc	ra,0xffffe
    80005c80:	68c080e7          	jalr	1676(ra) # 80004308 <namecmp>
    80005c84:	12050e63          	beqz	a0,80005dc0 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005c88:	f2c40613          	addi	a2,s0,-212
    80005c8c:	fb040593          	addi	a1,s0,-80
    80005c90:	8526                	mv	a0,s1
    80005c92:	ffffe097          	auipc	ra,0xffffe
    80005c96:	690080e7          	jalr	1680(ra) # 80004322 <dirlookup>
    80005c9a:	892a                	mv	s2,a0
    80005c9c:	12050263          	beqz	a0,80005dc0 <sys_unlink+0x1b0>
  ilock(ip);
    80005ca0:	ffffe097          	auipc	ra,0xffffe
    80005ca4:	1a0080e7          	jalr	416(ra) # 80003e40 <ilock>
  if(ip->nlink < 1)
    80005ca8:	04a91783          	lh	a5,74(s2)
    80005cac:	08f05263          	blez	a5,80005d30 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005cb0:	04491703          	lh	a4,68(s2)
    80005cb4:	4785                	li	a5,1
    80005cb6:	08f70563          	beq	a4,a5,80005d40 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005cba:	4641                	li	a2,16
    80005cbc:	4581                	li	a1,0
    80005cbe:	fc040513          	addi	a0,s0,-64
    80005cc2:	ffffb097          	auipc	ra,0xffffb
    80005cc6:	174080e7          	jalr	372(ra) # 80000e36 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005cca:	4741                	li	a4,16
    80005ccc:	f2c42683          	lw	a3,-212(s0)
    80005cd0:	fc040613          	addi	a2,s0,-64
    80005cd4:	4581                	li	a1,0
    80005cd6:	8526                	mv	a0,s1
    80005cd8:	ffffe097          	auipc	ra,0xffffe
    80005cdc:	514080e7          	jalr	1300(ra) # 800041ec <writei>
    80005ce0:	47c1                	li	a5,16
    80005ce2:	0af51563          	bne	a0,a5,80005d8c <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005ce6:	04491703          	lh	a4,68(s2)
    80005cea:	4785                	li	a5,1
    80005cec:	0af70863          	beq	a4,a5,80005d9c <sys_unlink+0x18c>
  iunlockput(dp);
    80005cf0:	8526                	mv	a0,s1
    80005cf2:	ffffe097          	auipc	ra,0xffffe
    80005cf6:	3b0080e7          	jalr	944(ra) # 800040a2 <iunlockput>
  ip->nlink--;
    80005cfa:	04a95783          	lhu	a5,74(s2)
    80005cfe:	37fd                	addiw	a5,a5,-1
    80005d00:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005d04:	854a                	mv	a0,s2
    80005d06:	ffffe097          	auipc	ra,0xffffe
    80005d0a:	070080e7          	jalr	112(ra) # 80003d76 <iupdate>
  iunlockput(ip);
    80005d0e:	854a                	mv	a0,s2
    80005d10:	ffffe097          	auipc	ra,0xffffe
    80005d14:	392080e7          	jalr	914(ra) # 800040a2 <iunlockput>
  end_op();
    80005d18:	fffff097          	auipc	ra,0xfffff
    80005d1c:	b68080e7          	jalr	-1176(ra) # 80004880 <end_op>
  return 0;
    80005d20:	4501                	li	a0,0
    80005d22:	a84d                	j	80005dd4 <sys_unlink+0x1c4>
    end_op();
    80005d24:	fffff097          	auipc	ra,0xfffff
    80005d28:	b5c080e7          	jalr	-1188(ra) # 80004880 <end_op>
    return -1;
    80005d2c:	557d                	li	a0,-1
    80005d2e:	a05d                	j	80005dd4 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005d30:	00003517          	auipc	a0,0x3
    80005d34:	b4050513          	addi	a0,a0,-1216 # 80008870 <syscalls+0x308>
    80005d38:	ffffb097          	auipc	ra,0xffffb
    80005d3c:	8ac080e7          	jalr	-1876(ra) # 800005e4 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005d40:	04c92703          	lw	a4,76(s2)
    80005d44:	02000793          	li	a5,32
    80005d48:	f6e7f9e3          	bgeu	a5,a4,80005cba <sys_unlink+0xaa>
    80005d4c:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005d50:	4741                	li	a4,16
    80005d52:	86ce                	mv	a3,s3
    80005d54:	f1840613          	addi	a2,s0,-232
    80005d58:	4581                	li	a1,0
    80005d5a:	854a                	mv	a0,s2
    80005d5c:	ffffe097          	auipc	ra,0xffffe
    80005d60:	398080e7          	jalr	920(ra) # 800040f4 <readi>
    80005d64:	47c1                	li	a5,16
    80005d66:	00f51b63          	bne	a0,a5,80005d7c <sys_unlink+0x16c>
    if(de.inum != 0)
    80005d6a:	f1845783          	lhu	a5,-232(s0)
    80005d6e:	e7a1                	bnez	a5,80005db6 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005d70:	29c1                	addiw	s3,s3,16
    80005d72:	04c92783          	lw	a5,76(s2)
    80005d76:	fcf9ede3          	bltu	s3,a5,80005d50 <sys_unlink+0x140>
    80005d7a:	b781                	j	80005cba <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005d7c:	00003517          	auipc	a0,0x3
    80005d80:	b0c50513          	addi	a0,a0,-1268 # 80008888 <syscalls+0x320>
    80005d84:	ffffb097          	auipc	ra,0xffffb
    80005d88:	860080e7          	jalr	-1952(ra) # 800005e4 <panic>
    panic("unlink: writei");
    80005d8c:	00003517          	auipc	a0,0x3
    80005d90:	b1450513          	addi	a0,a0,-1260 # 800088a0 <syscalls+0x338>
    80005d94:	ffffb097          	auipc	ra,0xffffb
    80005d98:	850080e7          	jalr	-1968(ra) # 800005e4 <panic>
    dp->nlink--;
    80005d9c:	04a4d783          	lhu	a5,74(s1)
    80005da0:	37fd                	addiw	a5,a5,-1
    80005da2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005da6:	8526                	mv	a0,s1
    80005da8:	ffffe097          	auipc	ra,0xffffe
    80005dac:	fce080e7          	jalr	-50(ra) # 80003d76 <iupdate>
    80005db0:	b781                	j	80005cf0 <sys_unlink+0xe0>
    return -1;
    80005db2:	557d                	li	a0,-1
    80005db4:	a005                	j	80005dd4 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005db6:	854a                	mv	a0,s2
    80005db8:	ffffe097          	auipc	ra,0xffffe
    80005dbc:	2ea080e7          	jalr	746(ra) # 800040a2 <iunlockput>
  iunlockput(dp);
    80005dc0:	8526                	mv	a0,s1
    80005dc2:	ffffe097          	auipc	ra,0xffffe
    80005dc6:	2e0080e7          	jalr	736(ra) # 800040a2 <iunlockput>
  end_op();
    80005dca:	fffff097          	auipc	ra,0xfffff
    80005dce:	ab6080e7          	jalr	-1354(ra) # 80004880 <end_op>
  return -1;
    80005dd2:	557d                	li	a0,-1
}
    80005dd4:	70ae                	ld	ra,232(sp)
    80005dd6:	740e                	ld	s0,224(sp)
    80005dd8:	64ee                	ld	s1,216(sp)
    80005dda:	694e                	ld	s2,208(sp)
    80005ddc:	69ae                	ld	s3,200(sp)
    80005dde:	616d                	addi	sp,sp,240
    80005de0:	8082                	ret

0000000080005de2 <sys_open>:

uint64
sys_open(void)
{
    80005de2:	7131                	addi	sp,sp,-192
    80005de4:	fd06                	sd	ra,184(sp)
    80005de6:	f922                	sd	s0,176(sp)
    80005de8:	f526                	sd	s1,168(sp)
    80005dea:	f14a                	sd	s2,160(sp)
    80005dec:	ed4e                	sd	s3,152(sp)
    80005dee:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005df0:	08000613          	li	a2,128
    80005df4:	f5040593          	addi	a1,s0,-176
    80005df8:	4501                	li	a0,0
    80005dfa:	ffffd097          	auipc	ra,0xffffd
    80005dfe:	4d6080e7          	jalr	1238(ra) # 800032d0 <argstr>
    return -1;
    80005e02:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005e04:	0c054163          	bltz	a0,80005ec6 <sys_open+0xe4>
    80005e08:	f4c40593          	addi	a1,s0,-180
    80005e0c:	4505                	li	a0,1
    80005e0e:	ffffd097          	auipc	ra,0xffffd
    80005e12:	47e080e7          	jalr	1150(ra) # 8000328c <argint>
    80005e16:	0a054863          	bltz	a0,80005ec6 <sys_open+0xe4>

  begin_op();
    80005e1a:	fffff097          	auipc	ra,0xfffff
    80005e1e:	9e6080e7          	jalr	-1562(ra) # 80004800 <begin_op>

  if(omode & O_CREATE){
    80005e22:	f4c42783          	lw	a5,-180(s0)
    80005e26:	2007f793          	andi	a5,a5,512
    80005e2a:	cbdd                	beqz	a5,80005ee0 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005e2c:	4681                	li	a3,0
    80005e2e:	4601                	li	a2,0
    80005e30:	4589                	li	a1,2
    80005e32:	f5040513          	addi	a0,s0,-176
    80005e36:	00000097          	auipc	ra,0x0
    80005e3a:	974080e7          	jalr	-1676(ra) # 800057aa <create>
    80005e3e:	892a                	mv	s2,a0
    if(ip == 0){
    80005e40:	c959                	beqz	a0,80005ed6 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005e42:	04491703          	lh	a4,68(s2)
    80005e46:	478d                	li	a5,3
    80005e48:	00f71763          	bne	a4,a5,80005e56 <sys_open+0x74>
    80005e4c:	04695703          	lhu	a4,70(s2)
    80005e50:	47a5                	li	a5,9
    80005e52:	0ce7ec63          	bltu	a5,a4,80005f2a <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005e56:	fffff097          	auipc	ra,0xfffff
    80005e5a:	dc0080e7          	jalr	-576(ra) # 80004c16 <filealloc>
    80005e5e:	89aa                	mv	s3,a0
    80005e60:	10050263          	beqz	a0,80005f64 <sys_open+0x182>
    80005e64:	00000097          	auipc	ra,0x0
    80005e68:	904080e7          	jalr	-1788(ra) # 80005768 <fdalloc>
    80005e6c:	84aa                	mv	s1,a0
    80005e6e:	0e054663          	bltz	a0,80005f5a <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005e72:	04491703          	lh	a4,68(s2)
    80005e76:	478d                	li	a5,3
    80005e78:	0cf70463          	beq	a4,a5,80005f40 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005e7c:	4789                	li	a5,2
    80005e7e:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005e82:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005e86:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005e8a:	f4c42783          	lw	a5,-180(s0)
    80005e8e:	0017c713          	xori	a4,a5,1
    80005e92:	8b05                	andi	a4,a4,1
    80005e94:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005e98:	0037f713          	andi	a4,a5,3
    80005e9c:	00e03733          	snez	a4,a4
    80005ea0:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005ea4:	4007f793          	andi	a5,a5,1024
    80005ea8:	c791                	beqz	a5,80005eb4 <sys_open+0xd2>
    80005eaa:	04491703          	lh	a4,68(s2)
    80005eae:	4789                	li	a5,2
    80005eb0:	08f70f63          	beq	a4,a5,80005f4e <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005eb4:	854a                	mv	a0,s2
    80005eb6:	ffffe097          	auipc	ra,0xffffe
    80005eba:	04c080e7          	jalr	76(ra) # 80003f02 <iunlock>
  end_op();
    80005ebe:	fffff097          	auipc	ra,0xfffff
    80005ec2:	9c2080e7          	jalr	-1598(ra) # 80004880 <end_op>

  return fd;
}
    80005ec6:	8526                	mv	a0,s1
    80005ec8:	70ea                	ld	ra,184(sp)
    80005eca:	744a                	ld	s0,176(sp)
    80005ecc:	74aa                	ld	s1,168(sp)
    80005ece:	790a                	ld	s2,160(sp)
    80005ed0:	69ea                	ld	s3,152(sp)
    80005ed2:	6129                	addi	sp,sp,192
    80005ed4:	8082                	ret
      end_op();
    80005ed6:	fffff097          	auipc	ra,0xfffff
    80005eda:	9aa080e7          	jalr	-1622(ra) # 80004880 <end_op>
      return -1;
    80005ede:	b7e5                	j	80005ec6 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80005ee0:	f5040513          	addi	a0,s0,-176
    80005ee4:	ffffe097          	auipc	ra,0xffffe
    80005ee8:	710080e7          	jalr	1808(ra) # 800045f4 <namei>
    80005eec:	892a                	mv	s2,a0
    80005eee:	c905                	beqz	a0,80005f1e <sys_open+0x13c>
    ilock(ip);
    80005ef0:	ffffe097          	auipc	ra,0xffffe
    80005ef4:	f50080e7          	jalr	-176(ra) # 80003e40 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005ef8:	04491703          	lh	a4,68(s2)
    80005efc:	4785                	li	a5,1
    80005efe:	f4f712e3          	bne	a4,a5,80005e42 <sys_open+0x60>
    80005f02:	f4c42783          	lw	a5,-180(s0)
    80005f06:	dba1                	beqz	a5,80005e56 <sys_open+0x74>
      iunlockput(ip);
    80005f08:	854a                	mv	a0,s2
    80005f0a:	ffffe097          	auipc	ra,0xffffe
    80005f0e:	198080e7          	jalr	408(ra) # 800040a2 <iunlockput>
      end_op();
    80005f12:	fffff097          	auipc	ra,0xfffff
    80005f16:	96e080e7          	jalr	-1682(ra) # 80004880 <end_op>
      return -1;
    80005f1a:	54fd                	li	s1,-1
    80005f1c:	b76d                	j	80005ec6 <sys_open+0xe4>
      end_op();
    80005f1e:	fffff097          	auipc	ra,0xfffff
    80005f22:	962080e7          	jalr	-1694(ra) # 80004880 <end_op>
      return -1;
    80005f26:	54fd                	li	s1,-1
    80005f28:	bf79                	j	80005ec6 <sys_open+0xe4>
    iunlockput(ip);
    80005f2a:	854a                	mv	a0,s2
    80005f2c:	ffffe097          	auipc	ra,0xffffe
    80005f30:	176080e7          	jalr	374(ra) # 800040a2 <iunlockput>
    end_op();
    80005f34:	fffff097          	auipc	ra,0xfffff
    80005f38:	94c080e7          	jalr	-1716(ra) # 80004880 <end_op>
    return -1;
    80005f3c:	54fd                	li	s1,-1
    80005f3e:	b761                	j	80005ec6 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005f40:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005f44:	04691783          	lh	a5,70(s2)
    80005f48:	02f99223          	sh	a5,36(s3)
    80005f4c:	bf2d                	j	80005e86 <sys_open+0xa4>
    itrunc(ip);
    80005f4e:	854a                	mv	a0,s2
    80005f50:	ffffe097          	auipc	ra,0xffffe
    80005f54:	ffe080e7          	jalr	-2(ra) # 80003f4e <itrunc>
    80005f58:	bfb1                	j	80005eb4 <sys_open+0xd2>
      fileclose(f);
    80005f5a:	854e                	mv	a0,s3
    80005f5c:	fffff097          	auipc	ra,0xfffff
    80005f60:	d76080e7          	jalr	-650(ra) # 80004cd2 <fileclose>
    iunlockput(ip);
    80005f64:	854a                	mv	a0,s2
    80005f66:	ffffe097          	auipc	ra,0xffffe
    80005f6a:	13c080e7          	jalr	316(ra) # 800040a2 <iunlockput>
    end_op();
    80005f6e:	fffff097          	auipc	ra,0xfffff
    80005f72:	912080e7          	jalr	-1774(ra) # 80004880 <end_op>
    return -1;
    80005f76:	54fd                	li	s1,-1
    80005f78:	b7b9                	j	80005ec6 <sys_open+0xe4>

0000000080005f7a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005f7a:	7175                	addi	sp,sp,-144
    80005f7c:	e506                	sd	ra,136(sp)
    80005f7e:	e122                	sd	s0,128(sp)
    80005f80:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005f82:	fffff097          	auipc	ra,0xfffff
    80005f86:	87e080e7          	jalr	-1922(ra) # 80004800 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005f8a:	08000613          	li	a2,128
    80005f8e:	f7040593          	addi	a1,s0,-144
    80005f92:	4501                	li	a0,0
    80005f94:	ffffd097          	auipc	ra,0xffffd
    80005f98:	33c080e7          	jalr	828(ra) # 800032d0 <argstr>
    80005f9c:	02054963          	bltz	a0,80005fce <sys_mkdir+0x54>
    80005fa0:	4681                	li	a3,0
    80005fa2:	4601                	li	a2,0
    80005fa4:	4585                	li	a1,1
    80005fa6:	f7040513          	addi	a0,s0,-144
    80005faa:	00000097          	auipc	ra,0x0
    80005fae:	800080e7          	jalr	-2048(ra) # 800057aa <create>
    80005fb2:	cd11                	beqz	a0,80005fce <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005fb4:	ffffe097          	auipc	ra,0xffffe
    80005fb8:	0ee080e7          	jalr	238(ra) # 800040a2 <iunlockput>
  end_op();
    80005fbc:	fffff097          	auipc	ra,0xfffff
    80005fc0:	8c4080e7          	jalr	-1852(ra) # 80004880 <end_op>
  return 0;
    80005fc4:	4501                	li	a0,0
}
    80005fc6:	60aa                	ld	ra,136(sp)
    80005fc8:	640a                	ld	s0,128(sp)
    80005fca:	6149                	addi	sp,sp,144
    80005fcc:	8082                	ret
    end_op();
    80005fce:	fffff097          	auipc	ra,0xfffff
    80005fd2:	8b2080e7          	jalr	-1870(ra) # 80004880 <end_op>
    return -1;
    80005fd6:	557d                	li	a0,-1
    80005fd8:	b7fd                	j	80005fc6 <sys_mkdir+0x4c>

0000000080005fda <sys_mknod>:

uint64
sys_mknod(void)
{
    80005fda:	7135                	addi	sp,sp,-160
    80005fdc:	ed06                	sd	ra,152(sp)
    80005fde:	e922                	sd	s0,144(sp)
    80005fe0:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005fe2:	fffff097          	auipc	ra,0xfffff
    80005fe6:	81e080e7          	jalr	-2018(ra) # 80004800 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005fea:	08000613          	li	a2,128
    80005fee:	f7040593          	addi	a1,s0,-144
    80005ff2:	4501                	li	a0,0
    80005ff4:	ffffd097          	auipc	ra,0xffffd
    80005ff8:	2dc080e7          	jalr	732(ra) # 800032d0 <argstr>
    80005ffc:	04054a63          	bltz	a0,80006050 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80006000:	f6c40593          	addi	a1,s0,-148
    80006004:	4505                	li	a0,1
    80006006:	ffffd097          	auipc	ra,0xffffd
    8000600a:	286080e7          	jalr	646(ra) # 8000328c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000600e:	04054163          	bltz	a0,80006050 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80006012:	f6840593          	addi	a1,s0,-152
    80006016:	4509                	li	a0,2
    80006018:	ffffd097          	auipc	ra,0xffffd
    8000601c:	274080e7          	jalr	628(ra) # 8000328c <argint>
     argint(1, &major) < 0 ||
    80006020:	02054863          	bltz	a0,80006050 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80006024:	f6841683          	lh	a3,-152(s0)
    80006028:	f6c41603          	lh	a2,-148(s0)
    8000602c:	458d                	li	a1,3
    8000602e:	f7040513          	addi	a0,s0,-144
    80006032:	fffff097          	auipc	ra,0xfffff
    80006036:	778080e7          	jalr	1912(ra) # 800057aa <create>
     argint(2, &minor) < 0 ||
    8000603a:	c919                	beqz	a0,80006050 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000603c:	ffffe097          	auipc	ra,0xffffe
    80006040:	066080e7          	jalr	102(ra) # 800040a2 <iunlockput>
  end_op();
    80006044:	fffff097          	auipc	ra,0xfffff
    80006048:	83c080e7          	jalr	-1988(ra) # 80004880 <end_op>
  return 0;
    8000604c:	4501                	li	a0,0
    8000604e:	a031                	j	8000605a <sys_mknod+0x80>
    end_op();
    80006050:	fffff097          	auipc	ra,0xfffff
    80006054:	830080e7          	jalr	-2000(ra) # 80004880 <end_op>
    return -1;
    80006058:	557d                	li	a0,-1
}
    8000605a:	60ea                	ld	ra,152(sp)
    8000605c:	644a                	ld	s0,144(sp)
    8000605e:	610d                	addi	sp,sp,160
    80006060:	8082                	ret

0000000080006062 <sys_chdir>:

uint64
sys_chdir(void)
{
    80006062:	7135                	addi	sp,sp,-160
    80006064:	ed06                	sd	ra,152(sp)
    80006066:	e922                	sd	s0,144(sp)
    80006068:	e526                	sd	s1,136(sp)
    8000606a:	e14a                	sd	s2,128(sp)
    8000606c:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000606e:	ffffc097          	auipc	ra,0xffffc
    80006072:	020080e7          	jalr	32(ra) # 8000208e <myproc>
    80006076:	892a                	mv	s2,a0
  
  begin_op();
    80006078:	ffffe097          	auipc	ra,0xffffe
    8000607c:	788080e7          	jalr	1928(ra) # 80004800 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80006080:	08000613          	li	a2,128
    80006084:	f6040593          	addi	a1,s0,-160
    80006088:	4501                	li	a0,0
    8000608a:	ffffd097          	auipc	ra,0xffffd
    8000608e:	246080e7          	jalr	582(ra) # 800032d0 <argstr>
    80006092:	04054b63          	bltz	a0,800060e8 <sys_chdir+0x86>
    80006096:	f6040513          	addi	a0,s0,-160
    8000609a:	ffffe097          	auipc	ra,0xffffe
    8000609e:	55a080e7          	jalr	1370(ra) # 800045f4 <namei>
    800060a2:	84aa                	mv	s1,a0
    800060a4:	c131                	beqz	a0,800060e8 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    800060a6:	ffffe097          	auipc	ra,0xffffe
    800060aa:	d9a080e7          	jalr	-614(ra) # 80003e40 <ilock>
  if(ip->type != T_DIR){
    800060ae:	04449703          	lh	a4,68(s1)
    800060b2:	4785                	li	a5,1
    800060b4:	04f71063          	bne	a4,a5,800060f4 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800060b8:	8526                	mv	a0,s1
    800060ba:	ffffe097          	auipc	ra,0xffffe
    800060be:	e48080e7          	jalr	-440(ra) # 80003f02 <iunlock>
  iput(p->cwd);
    800060c2:	16093503          	ld	a0,352(s2)
    800060c6:	ffffe097          	auipc	ra,0xffffe
    800060ca:	f34080e7          	jalr	-204(ra) # 80003ffa <iput>
  end_op();
    800060ce:	ffffe097          	auipc	ra,0xffffe
    800060d2:	7b2080e7          	jalr	1970(ra) # 80004880 <end_op>
  p->cwd = ip;
    800060d6:	16993023          	sd	s1,352(s2)
  return 0;
    800060da:	4501                	li	a0,0
}
    800060dc:	60ea                	ld	ra,152(sp)
    800060de:	644a                	ld	s0,144(sp)
    800060e0:	64aa                	ld	s1,136(sp)
    800060e2:	690a                	ld	s2,128(sp)
    800060e4:	610d                	addi	sp,sp,160
    800060e6:	8082                	ret
    end_op();
    800060e8:	ffffe097          	auipc	ra,0xffffe
    800060ec:	798080e7          	jalr	1944(ra) # 80004880 <end_op>
    return -1;
    800060f0:	557d                	li	a0,-1
    800060f2:	b7ed                	j	800060dc <sys_chdir+0x7a>
    iunlockput(ip);
    800060f4:	8526                	mv	a0,s1
    800060f6:	ffffe097          	auipc	ra,0xffffe
    800060fa:	fac080e7          	jalr	-84(ra) # 800040a2 <iunlockput>
    end_op();
    800060fe:	ffffe097          	auipc	ra,0xffffe
    80006102:	782080e7          	jalr	1922(ra) # 80004880 <end_op>
    return -1;
    80006106:	557d                	li	a0,-1
    80006108:	bfd1                	j	800060dc <sys_chdir+0x7a>

000000008000610a <sys_exec>:

uint64
sys_exec(void)
{
    8000610a:	7145                	addi	sp,sp,-464
    8000610c:	e786                	sd	ra,456(sp)
    8000610e:	e3a2                	sd	s0,448(sp)
    80006110:	ff26                	sd	s1,440(sp)
    80006112:	fb4a                	sd	s2,432(sp)
    80006114:	f74e                	sd	s3,424(sp)
    80006116:	f352                	sd	s4,416(sp)
    80006118:	ef56                	sd	s5,408(sp)
    8000611a:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    8000611c:	08000613          	li	a2,128
    80006120:	f4040593          	addi	a1,s0,-192
    80006124:	4501                	li	a0,0
    80006126:	ffffd097          	auipc	ra,0xffffd
    8000612a:	1aa080e7          	jalr	426(ra) # 800032d0 <argstr>
    return -1;
    8000612e:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80006130:	0c054a63          	bltz	a0,80006204 <sys_exec+0xfa>
    80006134:	e3840593          	addi	a1,s0,-456
    80006138:	4505                	li	a0,1
    8000613a:	ffffd097          	auipc	ra,0xffffd
    8000613e:	174080e7          	jalr	372(ra) # 800032ae <argaddr>
    80006142:	0c054163          	bltz	a0,80006204 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80006146:	10000613          	li	a2,256
    8000614a:	4581                	li	a1,0
    8000614c:	e4040513          	addi	a0,s0,-448
    80006150:	ffffb097          	auipc	ra,0xffffb
    80006154:	ce6080e7          	jalr	-794(ra) # 80000e36 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80006158:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    8000615c:	89a6                	mv	s3,s1
    8000615e:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80006160:	02000a13          	li	s4,32
    80006164:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80006168:	00391793          	slli	a5,s2,0x3
    8000616c:	e3040593          	addi	a1,s0,-464
    80006170:	e3843503          	ld	a0,-456(s0)
    80006174:	953e                	add	a0,a0,a5
    80006176:	ffffd097          	auipc	ra,0xffffd
    8000617a:	07c080e7          	jalr	124(ra) # 800031f2 <fetchaddr>
    8000617e:	02054a63          	bltz	a0,800061b2 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80006182:	e3043783          	ld	a5,-464(s0)
    80006186:	c3b9                	beqz	a5,800061cc <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80006188:	ffffb097          	auipc	ra,0xffffb
    8000618c:	a74080e7          	jalr	-1420(ra) # 80000bfc <kalloc>
    80006190:	85aa                	mv	a1,a0
    80006192:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80006196:	cd11                	beqz	a0,800061b2 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80006198:	6605                	lui	a2,0x1
    8000619a:	e3043503          	ld	a0,-464(s0)
    8000619e:	ffffd097          	auipc	ra,0xffffd
    800061a2:	0a6080e7          	jalr	166(ra) # 80003244 <fetchstr>
    800061a6:	00054663          	bltz	a0,800061b2 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    800061aa:	0905                	addi	s2,s2,1
    800061ac:	09a1                	addi	s3,s3,8
    800061ae:	fb491be3          	bne	s2,s4,80006164 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800061b2:	10048913          	addi	s2,s1,256
    800061b6:	6088                	ld	a0,0(s1)
    800061b8:	c529                	beqz	a0,80006202 <sys_exec+0xf8>
    kfree(argv[i]);
    800061ba:	ffffb097          	auipc	ra,0xffffb
    800061be:	8d0080e7          	jalr	-1840(ra) # 80000a8a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800061c2:	04a1                	addi	s1,s1,8
    800061c4:	ff2499e3          	bne	s1,s2,800061b6 <sys_exec+0xac>
  return -1;
    800061c8:	597d                	li	s2,-1
    800061ca:	a82d                	j	80006204 <sys_exec+0xfa>
      argv[i] = 0;
    800061cc:	0a8e                	slli	s5,s5,0x3
    800061ce:	fc040793          	addi	a5,s0,-64
    800061d2:	9abe                	add	s5,s5,a5
    800061d4:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7fface80>
  int ret = exec(path, argv);
    800061d8:	e4040593          	addi	a1,s0,-448
    800061dc:	f4040513          	addi	a0,s0,-192
    800061e0:	fffff097          	auipc	ra,0xfffff
    800061e4:	178080e7          	jalr	376(ra) # 80005358 <exec>
    800061e8:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800061ea:	10048993          	addi	s3,s1,256
    800061ee:	6088                	ld	a0,0(s1)
    800061f0:	c911                	beqz	a0,80006204 <sys_exec+0xfa>
    kfree(argv[i]);
    800061f2:	ffffb097          	auipc	ra,0xffffb
    800061f6:	898080e7          	jalr	-1896(ra) # 80000a8a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800061fa:	04a1                	addi	s1,s1,8
    800061fc:	ff3499e3          	bne	s1,s3,800061ee <sys_exec+0xe4>
    80006200:	a011                	j	80006204 <sys_exec+0xfa>
  return -1;
    80006202:	597d                	li	s2,-1
}
    80006204:	854a                	mv	a0,s2
    80006206:	60be                	ld	ra,456(sp)
    80006208:	641e                	ld	s0,448(sp)
    8000620a:	74fa                	ld	s1,440(sp)
    8000620c:	795a                	ld	s2,432(sp)
    8000620e:	79ba                	ld	s3,424(sp)
    80006210:	7a1a                	ld	s4,416(sp)
    80006212:	6afa                	ld	s5,408(sp)
    80006214:	6179                	addi	sp,sp,464
    80006216:	8082                	ret

0000000080006218 <sys_pipe>:

uint64
sys_pipe(void)
{
    80006218:	7139                	addi	sp,sp,-64
    8000621a:	fc06                	sd	ra,56(sp)
    8000621c:	f822                	sd	s0,48(sp)
    8000621e:	f426                	sd	s1,40(sp)
    80006220:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80006222:	ffffc097          	auipc	ra,0xffffc
    80006226:	e6c080e7          	jalr	-404(ra) # 8000208e <myproc>
    8000622a:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    8000622c:	fd840593          	addi	a1,s0,-40
    80006230:	4501                	li	a0,0
    80006232:	ffffd097          	auipc	ra,0xffffd
    80006236:	07c080e7          	jalr	124(ra) # 800032ae <argaddr>
    return -1;
    8000623a:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    8000623c:	0e054063          	bltz	a0,8000631c <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80006240:	fc840593          	addi	a1,s0,-56
    80006244:	fd040513          	addi	a0,s0,-48
    80006248:	fffff097          	auipc	ra,0xfffff
    8000624c:	de0080e7          	jalr	-544(ra) # 80005028 <pipealloc>
    return -1;
    80006250:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80006252:	0c054563          	bltz	a0,8000631c <sys_pipe+0x104>
  fd0 = -1;
    80006256:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000625a:	fd043503          	ld	a0,-48(s0)
    8000625e:	fffff097          	auipc	ra,0xfffff
    80006262:	50a080e7          	jalr	1290(ra) # 80005768 <fdalloc>
    80006266:	fca42223          	sw	a0,-60(s0)
    8000626a:	08054c63          	bltz	a0,80006302 <sys_pipe+0xea>
    8000626e:	fc843503          	ld	a0,-56(s0)
    80006272:	fffff097          	auipc	ra,0xfffff
    80006276:	4f6080e7          	jalr	1270(ra) # 80005768 <fdalloc>
    8000627a:	fca42023          	sw	a0,-64(s0)
    8000627e:	06054863          	bltz	a0,800062ee <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006282:	4691                	li	a3,4
    80006284:	fc440613          	addi	a2,s0,-60
    80006288:	fd843583          	ld	a1,-40(s0)
    8000628c:	68a8                	ld	a0,80(s1)
    8000628e:	ffffb097          	auipc	ra,0xffffb
    80006292:	7a4080e7          	jalr	1956(ra) # 80001a32 <copyout>
    80006296:	02054063          	bltz	a0,800062b6 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000629a:	4691                	li	a3,4
    8000629c:	fc040613          	addi	a2,s0,-64
    800062a0:	fd843583          	ld	a1,-40(s0)
    800062a4:	0591                	addi	a1,a1,4
    800062a6:	68a8                	ld	a0,80(s1)
    800062a8:	ffffb097          	auipc	ra,0xffffb
    800062ac:	78a080e7          	jalr	1930(ra) # 80001a32 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800062b0:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800062b2:	06055563          	bgez	a0,8000631c <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800062b6:	fc442783          	lw	a5,-60(s0)
    800062ba:	07e9                	addi	a5,a5,26
    800062bc:	078e                	slli	a5,a5,0x3
    800062be:	97a6                	add	a5,a5,s1
    800062c0:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800062c4:	fc042503          	lw	a0,-64(s0)
    800062c8:	0569                	addi	a0,a0,26
    800062ca:	050e                	slli	a0,a0,0x3
    800062cc:	9526                	add	a0,a0,s1
    800062ce:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800062d2:	fd043503          	ld	a0,-48(s0)
    800062d6:	fffff097          	auipc	ra,0xfffff
    800062da:	9fc080e7          	jalr	-1540(ra) # 80004cd2 <fileclose>
    fileclose(wf);
    800062de:	fc843503          	ld	a0,-56(s0)
    800062e2:	fffff097          	auipc	ra,0xfffff
    800062e6:	9f0080e7          	jalr	-1552(ra) # 80004cd2 <fileclose>
    return -1;
    800062ea:	57fd                	li	a5,-1
    800062ec:	a805                	j	8000631c <sys_pipe+0x104>
    if(fd0 >= 0)
    800062ee:	fc442783          	lw	a5,-60(s0)
    800062f2:	0007c863          	bltz	a5,80006302 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800062f6:	01a78513          	addi	a0,a5,26
    800062fa:	050e                	slli	a0,a0,0x3
    800062fc:	9526                	add	a0,a0,s1
    800062fe:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80006302:	fd043503          	ld	a0,-48(s0)
    80006306:	fffff097          	auipc	ra,0xfffff
    8000630a:	9cc080e7          	jalr	-1588(ra) # 80004cd2 <fileclose>
    fileclose(wf);
    8000630e:	fc843503          	ld	a0,-56(s0)
    80006312:	fffff097          	auipc	ra,0xfffff
    80006316:	9c0080e7          	jalr	-1600(ra) # 80004cd2 <fileclose>
    return -1;
    8000631a:	57fd                	li	a5,-1
}
    8000631c:	853e                	mv	a0,a5
    8000631e:	70e2                	ld	ra,56(sp)
    80006320:	7442                	ld	s0,48(sp)
    80006322:	74a2                	ld	s1,40(sp)
    80006324:	6121                	addi	sp,sp,64
    80006326:	8082                	ret
	...

0000000080006330 <kernelvec>:
    80006330:	7111                	addi	sp,sp,-256
    80006332:	e006                	sd	ra,0(sp)
    80006334:	e40a                	sd	sp,8(sp)
    80006336:	e80e                	sd	gp,16(sp)
    80006338:	ec12                	sd	tp,24(sp)
    8000633a:	f016                	sd	t0,32(sp)
    8000633c:	f41a                	sd	t1,40(sp)
    8000633e:	f81e                	sd	t2,48(sp)
    80006340:	fc22                	sd	s0,56(sp)
    80006342:	e0a6                	sd	s1,64(sp)
    80006344:	e4aa                	sd	a0,72(sp)
    80006346:	e8ae                	sd	a1,80(sp)
    80006348:	ecb2                	sd	a2,88(sp)
    8000634a:	f0b6                	sd	a3,96(sp)
    8000634c:	f4ba                	sd	a4,104(sp)
    8000634e:	f8be                	sd	a5,112(sp)
    80006350:	fcc2                	sd	a6,120(sp)
    80006352:	e146                	sd	a7,128(sp)
    80006354:	e54a                	sd	s2,136(sp)
    80006356:	e94e                	sd	s3,144(sp)
    80006358:	ed52                	sd	s4,152(sp)
    8000635a:	f156                	sd	s5,160(sp)
    8000635c:	f55a                	sd	s6,168(sp)
    8000635e:	f95e                	sd	s7,176(sp)
    80006360:	fd62                	sd	s8,184(sp)
    80006362:	e1e6                	sd	s9,192(sp)
    80006364:	e5ea                	sd	s10,200(sp)
    80006366:	e9ee                	sd	s11,208(sp)
    80006368:	edf2                	sd	t3,216(sp)
    8000636a:	f1f6                	sd	t4,224(sp)
    8000636c:	f5fa                	sd	t5,232(sp)
    8000636e:	f9fe                	sd	t6,240(sp)
    80006370:	d4ffc0ef          	jal	ra,800030be <kerneltrap>
    80006374:	6082                	ld	ra,0(sp)
    80006376:	6122                	ld	sp,8(sp)
    80006378:	61c2                	ld	gp,16(sp)
    8000637a:	7282                	ld	t0,32(sp)
    8000637c:	7322                	ld	t1,40(sp)
    8000637e:	73c2                	ld	t2,48(sp)
    80006380:	7462                	ld	s0,56(sp)
    80006382:	6486                	ld	s1,64(sp)
    80006384:	6526                	ld	a0,72(sp)
    80006386:	65c6                	ld	a1,80(sp)
    80006388:	6666                	ld	a2,88(sp)
    8000638a:	7686                	ld	a3,96(sp)
    8000638c:	7726                	ld	a4,104(sp)
    8000638e:	77c6                	ld	a5,112(sp)
    80006390:	7866                	ld	a6,120(sp)
    80006392:	688a                	ld	a7,128(sp)
    80006394:	692a                	ld	s2,136(sp)
    80006396:	69ca                	ld	s3,144(sp)
    80006398:	6a6a                	ld	s4,152(sp)
    8000639a:	7a8a                	ld	s5,160(sp)
    8000639c:	7b2a                	ld	s6,168(sp)
    8000639e:	7bca                	ld	s7,176(sp)
    800063a0:	7c6a                	ld	s8,184(sp)
    800063a2:	6c8e                	ld	s9,192(sp)
    800063a4:	6d2e                	ld	s10,200(sp)
    800063a6:	6dce                	ld	s11,208(sp)
    800063a8:	6e6e                	ld	t3,216(sp)
    800063aa:	7e8e                	ld	t4,224(sp)
    800063ac:	7f2e                	ld	t5,232(sp)
    800063ae:	7fce                	ld	t6,240(sp)
    800063b0:	6111                	addi	sp,sp,256
    800063b2:	10200073          	sret
    800063b6:	00000013          	nop
    800063ba:	00000013          	nop
    800063be:	0001                	nop

00000000800063c0 <timervec>:
    800063c0:	34051573          	csrrw	a0,mscratch,a0
    800063c4:	e10c                	sd	a1,0(a0)
    800063c6:	e510                	sd	a2,8(a0)
    800063c8:	e914                	sd	a3,16(a0)
    800063ca:	710c                	ld	a1,32(a0)
    800063cc:	7510                	ld	a2,40(a0)
    800063ce:	6194                	ld	a3,0(a1)
    800063d0:	96b2                	add	a3,a3,a2
    800063d2:	e194                	sd	a3,0(a1)
    800063d4:	4589                	li	a1,2
    800063d6:	14459073          	csrw	sip,a1
    800063da:	6914                	ld	a3,16(a0)
    800063dc:	6510                	ld	a2,8(a0)
    800063de:	610c                	ld	a1,0(a0)
    800063e0:	34051573          	csrrw	a0,mscratch,a0
    800063e4:	30200073          	mret
	...

00000000800063ea <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800063ea:	1141                	addi	sp,sp,-16
    800063ec:	e422                	sd	s0,8(sp)
    800063ee:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800063f0:	0c0007b7          	lui	a5,0xc000
    800063f4:	4705                	li	a4,1
    800063f6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800063f8:	c3d8                	sw	a4,4(a5)
}
    800063fa:	6422                	ld	s0,8(sp)
    800063fc:	0141                	addi	sp,sp,16
    800063fe:	8082                	ret

0000000080006400 <plicinithart>:

void
plicinithart(void)
{
    80006400:	1141                	addi	sp,sp,-16
    80006402:	e406                	sd	ra,8(sp)
    80006404:	e022                	sd	s0,0(sp)
    80006406:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006408:	ffffc097          	auipc	ra,0xffffc
    8000640c:	c5a080e7          	jalr	-934(ra) # 80002062 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006410:	0085171b          	slliw	a4,a0,0x8
    80006414:	0c0027b7          	lui	a5,0xc002
    80006418:	97ba                	add	a5,a5,a4
    8000641a:	40200713          	li	a4,1026
    8000641e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006422:	00d5151b          	slliw	a0,a0,0xd
    80006426:	0c2017b7          	lui	a5,0xc201
    8000642a:	953e                	add	a0,a0,a5
    8000642c:	00052023          	sw	zero,0(a0)
}
    80006430:	60a2                	ld	ra,8(sp)
    80006432:	6402                	ld	s0,0(sp)
    80006434:	0141                	addi	sp,sp,16
    80006436:	8082                	ret

0000000080006438 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80006438:	1141                	addi	sp,sp,-16
    8000643a:	e406                	sd	ra,8(sp)
    8000643c:	e022                	sd	s0,0(sp)
    8000643e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006440:	ffffc097          	auipc	ra,0xffffc
    80006444:	c22080e7          	jalr	-990(ra) # 80002062 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80006448:	00d5179b          	slliw	a5,a0,0xd
    8000644c:	0c201537          	lui	a0,0xc201
    80006450:	953e                	add	a0,a0,a5
  return irq;
}
    80006452:	4148                	lw	a0,4(a0)
    80006454:	60a2                	ld	ra,8(sp)
    80006456:	6402                	ld	s0,0(sp)
    80006458:	0141                	addi	sp,sp,16
    8000645a:	8082                	ret

000000008000645c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000645c:	1101                	addi	sp,sp,-32
    8000645e:	ec06                	sd	ra,24(sp)
    80006460:	e822                	sd	s0,16(sp)
    80006462:	e426                	sd	s1,8(sp)
    80006464:	1000                	addi	s0,sp,32
    80006466:	84aa                	mv	s1,a0
  int hart = cpuid();
    80006468:	ffffc097          	auipc	ra,0xffffc
    8000646c:	bfa080e7          	jalr	-1030(ra) # 80002062 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006470:	00d5151b          	slliw	a0,a0,0xd
    80006474:	0c2017b7          	lui	a5,0xc201
    80006478:	97aa                	add	a5,a5,a0
    8000647a:	c3c4                	sw	s1,4(a5)
}
    8000647c:	60e2                	ld	ra,24(sp)
    8000647e:	6442                	ld	s0,16(sp)
    80006480:	64a2                	ld	s1,8(sp)
    80006482:	6105                	addi	sp,sp,32
    80006484:	8082                	ret

0000000080006486 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80006486:	1141                	addi	sp,sp,-16
    80006488:	e406                	sd	ra,8(sp)
    8000648a:	e022                	sd	s0,0(sp)
    8000648c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000648e:	479d                	li	a5,7
    80006490:	04a7cc63          	blt	a5,a0,800064e8 <free_desc+0x62>
    panic("virtio_disk_intr 1");
  if(disk.free[i])
    80006494:	00049797          	auipc	a5,0x49
    80006498:	b6c78793          	addi	a5,a5,-1172 # 8004f000 <disk>
    8000649c:	00a78733          	add	a4,a5,a0
    800064a0:	6789                	lui	a5,0x2
    800064a2:	97ba                	add	a5,a5,a4
    800064a4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800064a8:	eba1                	bnez	a5,800064f8 <free_desc+0x72>
    panic("virtio_disk_intr 2");
  disk.desc[i].addr = 0;
    800064aa:	00451713          	slli	a4,a0,0x4
    800064ae:	0004b797          	auipc	a5,0x4b
    800064b2:	b527b783          	ld	a5,-1198(a5) # 80051000 <disk+0x2000>
    800064b6:	97ba                	add	a5,a5,a4
    800064b8:	0007b023          	sd	zero,0(a5)
  disk.free[i] = 1;
    800064bc:	00049797          	auipc	a5,0x49
    800064c0:	b4478793          	addi	a5,a5,-1212 # 8004f000 <disk>
    800064c4:	97aa                	add	a5,a5,a0
    800064c6:	6509                	lui	a0,0x2
    800064c8:	953e                	add	a0,a0,a5
    800064ca:	4785                	li	a5,1
    800064cc:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800064d0:	0004b517          	auipc	a0,0x4b
    800064d4:	b4850513          	addi	a0,a0,-1208 # 80051018 <disk+0x2018>
    800064d8:	ffffc097          	auipc	ra,0xffffc
    800064dc:	54a080e7          	jalr	1354(ra) # 80002a22 <wakeup>
}
    800064e0:	60a2                	ld	ra,8(sp)
    800064e2:	6402                	ld	s0,0(sp)
    800064e4:	0141                	addi	sp,sp,16
    800064e6:	8082                	ret
    panic("virtio_disk_intr 1");
    800064e8:	00002517          	auipc	a0,0x2
    800064ec:	3c850513          	addi	a0,a0,968 # 800088b0 <syscalls+0x348>
    800064f0:	ffffa097          	auipc	ra,0xffffa
    800064f4:	0f4080e7          	jalr	244(ra) # 800005e4 <panic>
    panic("virtio_disk_intr 2");
    800064f8:	00002517          	auipc	a0,0x2
    800064fc:	3d050513          	addi	a0,a0,976 # 800088c8 <syscalls+0x360>
    80006500:	ffffa097          	auipc	ra,0xffffa
    80006504:	0e4080e7          	jalr	228(ra) # 800005e4 <panic>

0000000080006508 <virtio_disk_init>:
{
    80006508:	1101                	addi	sp,sp,-32
    8000650a:	ec06                	sd	ra,24(sp)
    8000650c:	e822                	sd	s0,16(sp)
    8000650e:	e426                	sd	s1,8(sp)
    80006510:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006512:	00002597          	auipc	a1,0x2
    80006516:	3ce58593          	addi	a1,a1,974 # 800088e0 <syscalls+0x378>
    8000651a:	0004b517          	auipc	a0,0x4b
    8000651e:	b8e50513          	addi	a0,a0,-1138 # 800510a8 <disk+0x20a8>
    80006522:	ffffa097          	auipc	ra,0xffffa
    80006526:	788080e7          	jalr	1928(ra) # 80000caa <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000652a:	100017b7          	lui	a5,0x10001
    8000652e:	4398                	lw	a4,0(a5)
    80006530:	2701                	sext.w	a4,a4
    80006532:	747277b7          	lui	a5,0x74727
    80006536:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000653a:	0ef71163          	bne	a4,a5,8000661c <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000653e:	100017b7          	lui	a5,0x10001
    80006542:	43dc                	lw	a5,4(a5)
    80006544:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006546:	4705                	li	a4,1
    80006548:	0ce79a63          	bne	a5,a4,8000661c <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000654c:	100017b7          	lui	a5,0x10001
    80006550:	479c                	lw	a5,8(a5)
    80006552:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80006554:	4709                	li	a4,2
    80006556:	0ce79363          	bne	a5,a4,8000661c <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000655a:	100017b7          	lui	a5,0x10001
    8000655e:	47d8                	lw	a4,12(a5)
    80006560:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006562:	554d47b7          	lui	a5,0x554d4
    80006566:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000656a:	0af71963          	bne	a4,a5,8000661c <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000656e:	100017b7          	lui	a5,0x10001
    80006572:	4705                	li	a4,1
    80006574:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006576:	470d                	li	a4,3
    80006578:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000657a:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000657c:	c7ffe737          	lui	a4,0xc7ffe
    80006580:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fac75f>
    80006584:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006586:	2701                	sext.w	a4,a4
    80006588:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000658a:	472d                	li	a4,11
    8000658c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000658e:	473d                	li	a4,15
    80006590:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80006592:	6705                	lui	a4,0x1
    80006594:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006596:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000659a:	5bdc                	lw	a5,52(a5)
    8000659c:	2781                	sext.w	a5,a5
  if(max == 0)
    8000659e:	c7d9                	beqz	a5,8000662c <virtio_disk_init+0x124>
  if(max < NUM)
    800065a0:	471d                	li	a4,7
    800065a2:	08f77d63          	bgeu	a4,a5,8000663c <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800065a6:	100014b7          	lui	s1,0x10001
    800065aa:	47a1                	li	a5,8
    800065ac:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800065ae:	6609                	lui	a2,0x2
    800065b0:	4581                	li	a1,0
    800065b2:	00049517          	auipc	a0,0x49
    800065b6:	a4e50513          	addi	a0,a0,-1458 # 8004f000 <disk>
    800065ba:	ffffb097          	auipc	ra,0xffffb
    800065be:	87c080e7          	jalr	-1924(ra) # 80000e36 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800065c2:	00049717          	auipc	a4,0x49
    800065c6:	a3e70713          	addi	a4,a4,-1474 # 8004f000 <disk>
    800065ca:	00c75793          	srli	a5,a4,0xc
    800065ce:	2781                	sext.w	a5,a5
    800065d0:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct VRingDesc *) disk.pages;
    800065d2:	0004b797          	auipc	a5,0x4b
    800065d6:	a2e78793          	addi	a5,a5,-1490 # 80051000 <disk+0x2000>
    800065da:	e398                	sd	a4,0(a5)
  disk.avail = (uint16*)(((char*)disk.desc) + NUM*sizeof(struct VRingDesc));
    800065dc:	00049717          	auipc	a4,0x49
    800065e0:	aa470713          	addi	a4,a4,-1372 # 8004f080 <disk+0x80>
    800065e4:	e798                	sd	a4,8(a5)
  disk.used = (struct UsedArea *) (disk.pages + PGSIZE);
    800065e6:	0004a717          	auipc	a4,0x4a
    800065ea:	a1a70713          	addi	a4,a4,-1510 # 80050000 <disk+0x1000>
    800065ee:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800065f0:	4705                	li	a4,1
    800065f2:	00e78c23          	sb	a4,24(a5)
    800065f6:	00e78ca3          	sb	a4,25(a5)
    800065fa:	00e78d23          	sb	a4,26(a5)
    800065fe:	00e78da3          	sb	a4,27(a5)
    80006602:	00e78e23          	sb	a4,28(a5)
    80006606:	00e78ea3          	sb	a4,29(a5)
    8000660a:	00e78f23          	sb	a4,30(a5)
    8000660e:	00e78fa3          	sb	a4,31(a5)
}
    80006612:	60e2                	ld	ra,24(sp)
    80006614:	6442                	ld	s0,16(sp)
    80006616:	64a2                	ld	s1,8(sp)
    80006618:	6105                	addi	sp,sp,32
    8000661a:	8082                	ret
    panic("could not find virtio disk");
    8000661c:	00002517          	auipc	a0,0x2
    80006620:	2d450513          	addi	a0,a0,724 # 800088f0 <syscalls+0x388>
    80006624:	ffffa097          	auipc	ra,0xffffa
    80006628:	fc0080e7          	jalr	-64(ra) # 800005e4 <panic>
    panic("virtio disk has no queue 0");
    8000662c:	00002517          	auipc	a0,0x2
    80006630:	2e450513          	addi	a0,a0,740 # 80008910 <syscalls+0x3a8>
    80006634:	ffffa097          	auipc	ra,0xffffa
    80006638:	fb0080e7          	jalr	-80(ra) # 800005e4 <panic>
    panic("virtio disk max queue too short");
    8000663c:	00002517          	auipc	a0,0x2
    80006640:	2f450513          	addi	a0,a0,756 # 80008930 <syscalls+0x3c8>
    80006644:	ffffa097          	auipc	ra,0xffffa
    80006648:	fa0080e7          	jalr	-96(ra) # 800005e4 <panic>

000000008000664c <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    8000664c:	7175                	addi	sp,sp,-144
    8000664e:	e506                	sd	ra,136(sp)
    80006650:	e122                	sd	s0,128(sp)
    80006652:	fca6                	sd	s1,120(sp)
    80006654:	f8ca                	sd	s2,112(sp)
    80006656:	f4ce                	sd	s3,104(sp)
    80006658:	f0d2                	sd	s4,96(sp)
    8000665a:	ecd6                	sd	s5,88(sp)
    8000665c:	e8da                	sd	s6,80(sp)
    8000665e:	e4de                	sd	s7,72(sp)
    80006660:	e0e2                	sd	s8,64(sp)
    80006662:	fc66                	sd	s9,56(sp)
    80006664:	f86a                	sd	s10,48(sp)
    80006666:	f46e                	sd	s11,40(sp)
    80006668:	0900                	addi	s0,sp,144
    8000666a:	8aaa                	mv	s5,a0
    8000666c:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000666e:	00c52c83          	lw	s9,12(a0)
    80006672:	001c9c9b          	slliw	s9,s9,0x1
    80006676:	1c82                	slli	s9,s9,0x20
    80006678:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    8000667c:	0004b517          	auipc	a0,0x4b
    80006680:	a2c50513          	addi	a0,a0,-1492 # 800510a8 <disk+0x20a8>
    80006684:	ffffa097          	auipc	ra,0xffffa
    80006688:	6b6080e7          	jalr	1718(ra) # 80000d3a <acquire>
  for(int i = 0; i < 3; i++){
    8000668c:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    8000668e:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006690:	00049c17          	auipc	s8,0x49
    80006694:	970c0c13          	addi	s8,s8,-1680 # 8004f000 <disk>
    80006698:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    8000669a:	4b0d                	li	s6,3
    8000669c:	a0ad                	j	80006706 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    8000669e:	00fc0733          	add	a4,s8,a5
    800066a2:	975e                	add	a4,a4,s7
    800066a4:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800066a8:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800066aa:	0207c563          	bltz	a5,800066d4 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800066ae:	2905                	addiw	s2,s2,1
    800066b0:	0611                	addi	a2,a2,4
    800066b2:	19690d63          	beq	s2,s6,8000684c <virtio_disk_rw+0x200>
    idx[i] = alloc_desc();
    800066b6:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800066b8:	0004b717          	auipc	a4,0x4b
    800066bc:	96070713          	addi	a4,a4,-1696 # 80051018 <disk+0x2018>
    800066c0:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800066c2:	00074683          	lbu	a3,0(a4)
    800066c6:	fee1                	bnez	a3,8000669e <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800066c8:	2785                	addiw	a5,a5,1
    800066ca:	0705                	addi	a4,a4,1
    800066cc:	fe979be3          	bne	a5,s1,800066c2 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800066d0:	57fd                	li	a5,-1
    800066d2:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800066d4:	01205d63          	blez	s2,800066ee <virtio_disk_rw+0xa2>
    800066d8:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800066da:	000a2503          	lw	a0,0(s4)
    800066de:	00000097          	auipc	ra,0x0
    800066e2:	da8080e7          	jalr	-600(ra) # 80006486 <free_desc>
      for(int j = 0; j < i; j++)
    800066e6:	2d85                	addiw	s11,s11,1
    800066e8:	0a11                	addi	s4,s4,4
    800066ea:	ffb918e3          	bne	s2,s11,800066da <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800066ee:	0004b597          	auipc	a1,0x4b
    800066f2:	9ba58593          	addi	a1,a1,-1606 # 800510a8 <disk+0x20a8>
    800066f6:	0004b517          	auipc	a0,0x4b
    800066fa:	92250513          	addi	a0,a0,-1758 # 80051018 <disk+0x2018>
    800066fe:	ffffc097          	auipc	ra,0xffffc
    80006702:	1a4080e7          	jalr	420(ra) # 800028a2 <sleep>
  for(int i = 0; i < 3; i++){
    80006706:	f8040a13          	addi	s4,s0,-128
{
    8000670a:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    8000670c:	894e                	mv	s2,s3
    8000670e:	b765                	j	800066b6 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80006710:	0004b717          	auipc	a4,0x4b
    80006714:	8f073703          	ld	a4,-1808(a4) # 80051000 <disk+0x2000>
    80006718:	973e                	add	a4,a4,a5
    8000671a:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000671e:	00049517          	auipc	a0,0x49
    80006722:	8e250513          	addi	a0,a0,-1822 # 8004f000 <disk>
    80006726:	0004b717          	auipc	a4,0x4b
    8000672a:	8da70713          	addi	a4,a4,-1830 # 80051000 <disk+0x2000>
    8000672e:	6314                	ld	a3,0(a4)
    80006730:	96be                	add	a3,a3,a5
    80006732:	00c6d603          	lhu	a2,12(a3)
    80006736:	00166613          	ori	a2,a2,1
    8000673a:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000673e:	f8842683          	lw	a3,-120(s0)
    80006742:	6310                	ld	a2,0(a4)
    80006744:	97b2                	add	a5,a5,a2
    80006746:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0;
    8000674a:	20048613          	addi	a2,s1,512 # 10001200 <_entry-0x6fffee00>
    8000674e:	0612                	slli	a2,a2,0x4
    80006750:	962a                	add	a2,a2,a0
    80006752:	02060823          	sb	zero,48(a2) # 2030 <_entry-0x7fffdfd0>
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006756:	00469793          	slli	a5,a3,0x4
    8000675a:	630c                	ld	a1,0(a4)
    8000675c:	95be                	add	a1,a1,a5
    8000675e:	6689                	lui	a3,0x2
    80006760:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80006764:	96ca                	add	a3,a3,s2
    80006766:	96aa                	add	a3,a3,a0
    80006768:	e194                	sd	a3,0(a1)
  disk.desc[idx[2]].len = 1;
    8000676a:	6314                	ld	a3,0(a4)
    8000676c:	96be                	add	a3,a3,a5
    8000676e:	4585                	li	a1,1
    80006770:	c68c                	sw	a1,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006772:	6314                	ld	a3,0(a4)
    80006774:	96be                	add	a3,a3,a5
    80006776:	4509                	li	a0,2
    80006778:	00a69623          	sh	a0,12(a3)
  disk.desc[idx[2]].next = 0;
    8000677c:	6314                	ld	a3,0(a4)
    8000677e:	97b6                	add	a5,a5,a3
    80006780:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006784:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    80006788:	03563423          	sd	s5,40(a2)

  // avail[0] is flags
  // avail[1] tells the device how far to look in avail[2...].
  // avail[2...] are desc[] indices the device should process.
  // we only tell device the first index in our chain of descriptors.
  disk.avail[2 + (disk.avail[1] % NUM)] = idx[0];
    8000678c:	6714                	ld	a3,8(a4)
    8000678e:	0026d783          	lhu	a5,2(a3)
    80006792:	8b9d                	andi	a5,a5,7
    80006794:	0789                	addi	a5,a5,2
    80006796:	0786                	slli	a5,a5,0x1
    80006798:	97b6                	add	a5,a5,a3
    8000679a:	00979023          	sh	s1,0(a5)
  __sync_synchronize();
    8000679e:	0ff0000f          	fence
  disk.avail[1] = disk.avail[1] + 1;
    800067a2:	6718                	ld	a4,8(a4)
    800067a4:	00275783          	lhu	a5,2(a4)
    800067a8:	2785                	addiw	a5,a5,1
    800067aa:	00f71123          	sh	a5,2(a4)

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800067ae:	100017b7          	lui	a5,0x10001
    800067b2:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800067b6:	004aa783          	lw	a5,4(s5)
    800067ba:	02b79163          	bne	a5,a1,800067dc <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    800067be:	0004b917          	auipc	s2,0x4b
    800067c2:	8ea90913          	addi	s2,s2,-1814 # 800510a8 <disk+0x20a8>
  while(b->disk == 1) {
    800067c6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800067c8:	85ca                	mv	a1,s2
    800067ca:	8556                	mv	a0,s5
    800067cc:	ffffc097          	auipc	ra,0xffffc
    800067d0:	0d6080e7          	jalr	214(ra) # 800028a2 <sleep>
  while(b->disk == 1) {
    800067d4:	004aa783          	lw	a5,4(s5)
    800067d8:	fe9788e3          	beq	a5,s1,800067c8 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    800067dc:	f8042483          	lw	s1,-128(s0)
    800067e0:	20048793          	addi	a5,s1,512
    800067e4:	00479713          	slli	a4,a5,0x4
    800067e8:	00049797          	auipc	a5,0x49
    800067ec:	81878793          	addi	a5,a5,-2024 # 8004f000 <disk>
    800067f0:	97ba                	add	a5,a5,a4
    800067f2:	0207b423          	sd	zero,40(a5)
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    800067f6:	0004b917          	auipc	s2,0x4b
    800067fa:	80a90913          	addi	s2,s2,-2038 # 80051000 <disk+0x2000>
    800067fe:	a019                	j	80006804 <virtio_disk_rw+0x1b8>
      i = disk.desc[i].next;
    80006800:	00e4d483          	lhu	s1,14(s1)
    free_desc(i);
    80006804:	8526                	mv	a0,s1
    80006806:	00000097          	auipc	ra,0x0
    8000680a:	c80080e7          	jalr	-896(ra) # 80006486 <free_desc>
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    8000680e:	0492                	slli	s1,s1,0x4
    80006810:	00093783          	ld	a5,0(s2)
    80006814:	94be                	add	s1,s1,a5
    80006816:	00c4d783          	lhu	a5,12(s1)
    8000681a:	8b85                	andi	a5,a5,1
    8000681c:	f3f5                	bnez	a5,80006800 <virtio_disk_rw+0x1b4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000681e:	0004b517          	auipc	a0,0x4b
    80006822:	88a50513          	addi	a0,a0,-1910 # 800510a8 <disk+0x20a8>
    80006826:	ffffa097          	auipc	ra,0xffffa
    8000682a:	5c8080e7          	jalr	1480(ra) # 80000dee <release>
}
    8000682e:	60aa                	ld	ra,136(sp)
    80006830:	640a                	ld	s0,128(sp)
    80006832:	74e6                	ld	s1,120(sp)
    80006834:	7946                	ld	s2,112(sp)
    80006836:	79a6                	ld	s3,104(sp)
    80006838:	7a06                	ld	s4,96(sp)
    8000683a:	6ae6                	ld	s5,88(sp)
    8000683c:	6b46                	ld	s6,80(sp)
    8000683e:	6ba6                	ld	s7,72(sp)
    80006840:	6c06                	ld	s8,64(sp)
    80006842:	7ce2                	ld	s9,56(sp)
    80006844:	7d42                	ld	s10,48(sp)
    80006846:	7da2                	ld	s11,40(sp)
    80006848:	6149                	addi	sp,sp,144
    8000684a:	8082                	ret
  if(write)
    8000684c:	01a037b3          	snez	a5,s10
    80006850:	f6f42823          	sw	a5,-144(s0)
  buf0.reserved = 0;
    80006854:	f6042a23          	sw	zero,-140(s0)
  buf0.sector = sector;
    80006858:	f7943c23          	sd	s9,-136(s0)
  disk.desc[idx[0]].addr = (uint64) kvmpa((uint64) &buf0);
    8000685c:	f8042483          	lw	s1,-128(s0)
    80006860:	00449913          	slli	s2,s1,0x4
    80006864:	0004a997          	auipc	s3,0x4a
    80006868:	79c98993          	addi	s3,s3,1948 # 80051000 <disk+0x2000>
    8000686c:	0009ba03          	ld	s4,0(s3)
    80006870:	9a4a                	add	s4,s4,s2
    80006872:	f7040513          	addi	a0,s0,-144
    80006876:	ffffb097          	auipc	ra,0xffffb
    8000687a:	986080e7          	jalr	-1658(ra) # 800011fc <kvmpa>
    8000687e:	00aa3023          	sd	a0,0(s4)
  disk.desc[idx[0]].len = sizeof(buf0);
    80006882:	0009b783          	ld	a5,0(s3)
    80006886:	97ca                	add	a5,a5,s2
    80006888:	4741                	li	a4,16
    8000688a:	c798                	sw	a4,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000688c:	0009b783          	ld	a5,0(s3)
    80006890:	97ca                	add	a5,a5,s2
    80006892:	4705                	li	a4,1
    80006894:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80006898:	f8442783          	lw	a5,-124(s0)
    8000689c:	0009b703          	ld	a4,0(s3)
    800068a0:	974a                	add	a4,a4,s2
    800068a2:	00f71723          	sh	a5,14(a4)
  disk.desc[idx[1]].addr = (uint64) b->data;
    800068a6:	0792                	slli	a5,a5,0x4
    800068a8:	0009b703          	ld	a4,0(s3)
    800068ac:	973e                	add	a4,a4,a5
    800068ae:	058a8693          	addi	a3,s5,88
    800068b2:	e314                	sd	a3,0(a4)
  disk.desc[idx[1]].len = BSIZE;
    800068b4:	0009b703          	ld	a4,0(s3)
    800068b8:	973e                	add	a4,a4,a5
    800068ba:	40000693          	li	a3,1024
    800068be:	c714                	sw	a3,8(a4)
  if(write)
    800068c0:	e40d18e3          	bnez	s10,80006710 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800068c4:	0004a717          	auipc	a4,0x4a
    800068c8:	73c73703          	ld	a4,1852(a4) # 80051000 <disk+0x2000>
    800068cc:	973e                	add	a4,a4,a5
    800068ce:	4689                	li	a3,2
    800068d0:	00d71623          	sh	a3,12(a4)
    800068d4:	b5a9                	j	8000671e <virtio_disk_rw+0xd2>

00000000800068d6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800068d6:	1101                	addi	sp,sp,-32
    800068d8:	ec06                	sd	ra,24(sp)
    800068da:	e822                	sd	s0,16(sp)
    800068dc:	e426                	sd	s1,8(sp)
    800068de:	e04a                	sd	s2,0(sp)
    800068e0:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800068e2:	0004a517          	auipc	a0,0x4a
    800068e6:	7c650513          	addi	a0,a0,1990 # 800510a8 <disk+0x20a8>
    800068ea:	ffffa097          	auipc	ra,0xffffa
    800068ee:	450080e7          	jalr	1104(ra) # 80000d3a <acquire>

  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    800068f2:	0004a717          	auipc	a4,0x4a
    800068f6:	70e70713          	addi	a4,a4,1806 # 80051000 <disk+0x2000>
    800068fa:	02075783          	lhu	a5,32(a4)
    800068fe:	6b18                	ld	a4,16(a4)
    80006900:	00275683          	lhu	a3,2(a4)
    80006904:	8ebd                	xor	a3,a3,a5
    80006906:	8a9d                	andi	a3,a3,7
    80006908:	cab9                	beqz	a3,8000695e <virtio_disk_intr+0x88>
    int id = disk.used->elems[disk.used_idx].id;

    if(disk.info[id].status != 0)
    8000690a:	00048917          	auipc	s2,0x48
    8000690e:	6f690913          	addi	s2,s2,1782 # 8004f000 <disk>
      panic("virtio_disk_intr status");
    
    disk.info[id].b->disk = 0;   // disk is done with buf
    wakeup(disk.info[id].b);

    disk.used_idx = (disk.used_idx + 1) % NUM;
    80006912:	0004a497          	auipc	s1,0x4a
    80006916:	6ee48493          	addi	s1,s1,1774 # 80051000 <disk+0x2000>
    int id = disk.used->elems[disk.used_idx].id;
    8000691a:	078e                	slli	a5,a5,0x3
    8000691c:	97ba                	add	a5,a5,a4
    8000691e:	43dc                	lw	a5,4(a5)
    if(disk.info[id].status != 0)
    80006920:	20078713          	addi	a4,a5,512
    80006924:	0712                	slli	a4,a4,0x4
    80006926:	974a                	add	a4,a4,s2
    80006928:	03074703          	lbu	a4,48(a4)
    8000692c:	ef21                	bnez	a4,80006984 <virtio_disk_intr+0xae>
    disk.info[id].b->disk = 0;   // disk is done with buf
    8000692e:	20078793          	addi	a5,a5,512
    80006932:	0792                	slli	a5,a5,0x4
    80006934:	97ca                	add	a5,a5,s2
    80006936:	7798                	ld	a4,40(a5)
    80006938:	00072223          	sw	zero,4(a4)
    wakeup(disk.info[id].b);
    8000693c:	7788                	ld	a0,40(a5)
    8000693e:	ffffc097          	auipc	ra,0xffffc
    80006942:	0e4080e7          	jalr	228(ra) # 80002a22 <wakeup>
    disk.used_idx = (disk.used_idx + 1) % NUM;
    80006946:	0204d783          	lhu	a5,32(s1)
    8000694a:	2785                	addiw	a5,a5,1
    8000694c:	8b9d                	andi	a5,a5,7
    8000694e:	02f49023          	sh	a5,32(s1)
  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    80006952:	6898                	ld	a4,16(s1)
    80006954:	00275683          	lhu	a3,2(a4)
    80006958:	8a9d                	andi	a3,a3,7
    8000695a:	fcf690e3          	bne	a3,a5,8000691a <virtio_disk_intr+0x44>
  }
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000695e:	10001737          	lui	a4,0x10001
    80006962:	533c                	lw	a5,96(a4)
    80006964:	8b8d                	andi	a5,a5,3
    80006966:	d37c                	sw	a5,100(a4)

  release(&disk.vdisk_lock);
    80006968:	0004a517          	auipc	a0,0x4a
    8000696c:	74050513          	addi	a0,a0,1856 # 800510a8 <disk+0x20a8>
    80006970:	ffffa097          	auipc	ra,0xffffa
    80006974:	47e080e7          	jalr	1150(ra) # 80000dee <release>
}
    80006978:	60e2                	ld	ra,24(sp)
    8000697a:	6442                	ld	s0,16(sp)
    8000697c:	64a2                	ld	s1,8(sp)
    8000697e:	6902                	ld	s2,0(sp)
    80006980:	6105                	addi	sp,sp,32
    80006982:	8082                	ret
      panic("virtio_disk_intr status");
    80006984:	00002517          	auipc	a0,0x2
    80006988:	fcc50513          	addi	a0,a0,-52 # 80008950 <syscalls+0x3e8>
    8000698c:	ffffa097          	auipc	ra,0xffffa
    80006990:	c58080e7          	jalr	-936(ra) # 800005e4 <panic>

0000000080006994 <mem_init>:
  page_t *next_page;
} allocator_t;

static allocator_t alloc;
static int if_init = 0;
void mem_init() {
    80006994:	1141                	addi	sp,sp,-16
    80006996:	e406                	sd	ra,8(sp)
    80006998:	e022                	sd	s0,0(sp)
    8000699a:	0800                	addi	s0,sp,16
  alloc.next_page = kalloc();
    8000699c:	ffffa097          	auipc	ra,0xffffa
    800069a0:	260080e7          	jalr	608(ra) # 80000bfc <kalloc>
    800069a4:	00002797          	auipc	a5,0x2
    800069a8:	68a7b623          	sd	a0,1676(a5) # 80009030 <alloc>
  page_t *p = (page_t *)alloc.next_page;
  p->cur = (void *)p + sizeof(page_t);
    800069ac:	00850793          	addi	a5,a0,8
    800069b0:	e11c                	sd	a5,0(a0)
}
    800069b2:	60a2                	ld	ra,8(sp)
    800069b4:	6402                	ld	s0,0(sp)
    800069b6:	0141                	addi	sp,sp,16
    800069b8:	8082                	ret

00000000800069ba <mallo>:

void *mallo(u32 size) {
    800069ba:	1101                	addi	sp,sp,-32
    800069bc:	ec06                	sd	ra,24(sp)
    800069be:	e822                	sd	s0,16(sp)
    800069c0:	e426                	sd	s1,8(sp)
    800069c2:	1000                	addi	s0,sp,32
    800069c4:	84aa                	mv	s1,a0
  if (!if_init) {
    800069c6:	00002797          	auipc	a5,0x2
    800069ca:	6627a783          	lw	a5,1634(a5) # 80009028 <if_init>
    800069ce:	cf9d                	beqz	a5,80006a0c <mallo+0x52>
    mem_init();
    if_init = 1;
  }
  void *res = 0;
  printf("size %d ", size);
    800069d0:	85a6                	mv	a1,s1
    800069d2:	00002517          	auipc	a0,0x2
    800069d6:	f9650513          	addi	a0,a0,-106 # 80008968 <syscalls+0x400>
    800069da:	ffffa097          	auipc	ra,0xffffa
    800069de:	c5c080e7          	jalr	-932(ra) # 80000636 <printf>
  u32 avail = PGSIZE - (alloc.next_page->cur - (void *)(alloc.next_page)) -
    800069e2:	00002717          	auipc	a4,0x2
    800069e6:	64e73703          	ld	a4,1614(a4) # 80009030 <alloc>
    800069ea:	6308                	ld	a0,0(a4)
    800069ec:	40e506b3          	sub	a3,a0,a4
              sizeof(page_t);
  if (avail > size) {
    800069f0:	6785                	lui	a5,0x1
    800069f2:	37e1                	addiw	a5,a5,-8
    800069f4:	9f95                	subw	a5,a5,a3
    800069f6:	02f4f563          	bgeu	s1,a5,80006a20 <mallo+0x66>
    res = alloc.next_page->cur;
    alloc.next_page->cur += size;
    800069fa:	1482                	slli	s1,s1,0x20
    800069fc:	9081                	srli	s1,s1,0x20
    800069fe:	94aa                	add	s1,s1,a0
    80006a00:	e304                	sd	s1,0(a4)
  } else {
    printf("malloc failed");
    return 0;
  }
  return res;
}
    80006a02:	60e2                	ld	ra,24(sp)
    80006a04:	6442                	ld	s0,16(sp)
    80006a06:	64a2                	ld	s1,8(sp)
    80006a08:	6105                	addi	sp,sp,32
    80006a0a:	8082                	ret
    mem_init();
    80006a0c:	00000097          	auipc	ra,0x0
    80006a10:	f88080e7          	jalr	-120(ra) # 80006994 <mem_init>
    if_init = 1;
    80006a14:	4785                	li	a5,1
    80006a16:	00002717          	auipc	a4,0x2
    80006a1a:	60f72923          	sw	a5,1554(a4) # 80009028 <if_init>
    80006a1e:	bf4d                	j	800069d0 <mallo+0x16>
    printf("malloc failed");
    80006a20:	00002517          	auipc	a0,0x2
    80006a24:	f5850513          	addi	a0,a0,-168 # 80008978 <syscalls+0x410>
    80006a28:	ffffa097          	auipc	ra,0xffffa
    80006a2c:	c0e080e7          	jalr	-1010(ra) # 80000636 <printf>
    return 0;
    80006a30:	4501                	li	a0,0
    80006a32:	bfc1                	j	80006a02 <mallo+0x48>

0000000080006a34 <free>:

    80006a34:	1141                	addi	sp,sp,-16
    80006a36:	e422                	sd	s0,8(sp)
    80006a38:	0800                	addi	s0,sp,16
    80006a3a:	6422                	ld	s0,8(sp)
    80006a3c:	0141                	addi	sp,sp,16
    80006a3e:	8082                	ret
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
